# Integrating external LLMs into Odoo 20

Use only when built-ins (`odoo20-ai-features.md`) are insufficient (other provider, custom tools, bespoke UX). Python/OWL code below is a pattern, not an Odoo API: adapt names. Platform for 20: Python >= 3.12, PostgreSQL >= 16, OWL 3 (the JS snippet below is written in Owl 2 style and must be validated against the OWL 2 -> 3 migration guide, which lists 22 breaking changes).

Providers covered: OpenAI, Gemini, and local OpenAI-compatible endpoints (Ollama/vLLM).

## Module layout
```
my_llm/
  __manifest__.py   # version '20.0.1.0.0'; depends: ['base','mail']; 'external_dependencies': {'python': ['requests']}
  models/llm_provider.py, llm_request.py, res_config_settings.py
  security/ir.access.csv, security_groups.xml    # 20: ACLs and record rules are one model, ir.access
  data/ir_cron.xml
  static/src/... (OWL)
  tests/
```
Security file for 20 (header exactly): `id,name,model_id,group_id/id,operation,domain` — put row filters (company, own requests) in the `domain` column; there is no `ir.model.access.csv` or `ir.rule` in 20. Accepted `operation` values and `model_id` cell format: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/security.html).

## Provider-agnostic service (one seam for OpenAI / Gemini / local)
```python
class LlmProvider(models.AbstractModel):
    _name = 'llm.provider'
    def _get_secret(self):
        # restricted param; read with sudo only here, never log it
        return self.env['ir.config_parameter'].sudo().get_param('my_llm.api_key')
    def complete(self, messages, *, model=None, max_tokens=512, timeout=30):
        provider = self.env['ir.config_parameter'].sudo().get_param('my_llm.provider', 'openai')
        return getattr(self, f'_complete_{provider}')(messages, model, max_tokens, timeout)
```
- Implement `_complete_openai`, `_complete_gemini`, `_complete_local` (Ollama/vLLM OpenAI-compatible endpoint) returning one normalized dict: `{text, usage:{in,out}, model, raw_id}`.
- Use `requests` with explicit `timeout`, `raise_for_status`, and map errors to `UserError` (user text) plus `_logger.warning` (no payload, no key).
- Pin model names in settings, not code. Allow per-company config (`company_id` on config or `res.config.settings` company-dependent fields).

## Secrets and config
- `res.config.settings` field with `config_parameter='my_llm.api_key'`, `groups='base.group_system'`, password widget in view. Params are readable by system admins only via `sudo()`; never put keys in XML data, module code, `ir.ui.view`, or client-side JS.
- Prefer environment variable or `odoo.conf` (`[options]` custom key via `odoo.tools.config`) on on-prem/Odoo.sh for production; keep a settings fallback.
- On Odoo Online/SaaS you cannot ship custom code: use built-in AI app or Studio automations (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/productivity/ai.html).
- Rotate keys; one key per environment; restrict by provider project/budget.

## Calling from server actions / automations
- Server action (Technical > Server Actions, type Python code or Execute Code via module XML `ir.actions.server`): keep the body tiny and call a model method: `records.action_ai_summarize()`.
- Never call the LLM synchronously inside a write/create or a form `onchange` that blocks users. Use button -> enqueue -> notify.
- Automated actions (`base.automation`) triggering LLM calls on every write multiply cost: add trigger conditions, debounce, per-record "last_processed_hash".

## Async / queue
Odoo core has no job queue; options: `ir.cron` polling a request table (core, simple) or OCA `queue_job`. OCA had no 20.0 branches as of 2026-09-24 (re-check on https://github.com/OCA/queue); plan on `ir.cron` unless a 20.0 branch exists.
```python
class LlmRequest(models.Model):
    _name = 'llm.request'
    state = fields.Selection([('queued',''),('running',''),('done',''),('error','')], default='queued', index=True)
    res_model = fields.Char(); res_id = fields.Many2oneReference(model_field='res_model')
    user_id = fields.Many2one('res.users', default=lambda s: s.env.uid)   # requesting user
    prompt_hash = fields.Char(index=True); result = fields.Text(); error = fields.Text()
    tokens_in = fields.Integer(); tokens_out = fields.Integer(); attempts = fields.Integer()

    @api.model
    def _cron_process(self, batch=10):
        reqs = self.search([('state','=','queued'),('attempts','<',3)], limit=batch)
        for r in reqs:
            self.env.cr.execute("SELECT 1 FROM llm_request WHERE id=%s FOR UPDATE SKIP LOCKED", [r.id])
            ...  # run as r.user_id: r.with_user(r.user_id)._run(); commit per record
            self.env.cr.commit()   # acceptable in cron only
```
- Idempotency via `prompt_hash` + cache hit; exponential backoff on 429/5xx; dead-letter after N attempts; cron interval and batch size tuned, never one huge batch (cron time limits).
- Streaming to UI: use a controller (`type='http'` SSE) or bus notifications (`self.env['bus.bus']._sendone(partner, 'my_llm', payload)`) - verify bus API signature in your 20.0 source.

## Tool/function calling safely
- Expose a small allowlist of tools (read a record, search with domain templates, create draft). Each tool = Python method that validates args (types, ids as ints, model allowlist) and runs under the requesting user's env, calling `check_access('read'|'write')` as needed (20 style; the older `check_access_rights/rule` are deprecated since 18 and `_check_access` is deprecated in 20 - verify on your build).
- Reject model-supplied arbitrary domains/SQL/model names. Map names -> fixed models.
- Cap loop iterations (e.g. 5 tool rounds) and total tokens per request.

## OWL UI
Owl 2-era snippet kept from 19; validate against the OWL 2 -> 3 migration guide (22 breaking changes) before use in 20, and do not rely on the compatibility layer beyond a short transition.
```js
import { Component, useState } from "@odoo/owl";
import { registry } from "@web/core/registry";
import { useService } from "@web/core/utils/hooks";

export class AiAssist extends Component {
    static template = "my_llm.AiAssist";
    static props = ["*"];
    setup() { this.orm = useService("orm"); this.notification = useService("notification"); this.state = useState({busy:false, text:""}); }
    async onAsk() {
        this.state.busy = true;
        try {
            const res = await this.orm.call("llm.request", "ask", [this.props.resModel, this.props.resId, this.state.prompt]);
            this.state.text = res;
        } catch (e) { this.notification.add("AI unavailable, try again later.", {type: "warning"}); }
        finally { this.state.busy = false; }
    }
}
registry.category("fields").add("ai_assist", { component: AiAssist });  // or actions/view widgets
```
- Register as field widget / form button / systray item; declare in `assets` -> `web.assets_backend` in manifest. Use `orm.call` (access rules enforced server-side); never put keys or provider URLs in the browser.
- UX: show "AI draft" label, editable output, accept/discard, disabled state while busy, cost-free fallback. Write results to chatter as note only after user accepts.

## External callers
If an external system needs to trigger or read your AI feature, expose it through JSON-2 (`/json/2/<model>/<method>`, Custom plan only). XML-RPC/JSON-RPC are deprecated; the `db` service is removed in 20; `common`/`object` are scheduled for removal in Odoo 22 (fall 2028). Call it with a dedicated least-privilege integration user, not an admin.

## Chatter / mail integration
Post as note: `record.message_post(body=..., subtype_xmlid='mail.mt_note', author_id=bot_partner)`. Use a dedicated bot partner/user (no login) for attribution; do not impersonate real users. In 20 tracking values are removed and tracking messages are generated on the fly: do not rely on stored tracking records to audit AI changes; log them in your own audit table (`security-cost.md`).

## Testing
- Patch `llm.provider.complete` with `unittest.mock.patch.object`; assert prompts exclude restricted fields, run with non-admin user, error paths set `state='error'`.
- Test the access boundary against your `ir.access.csv` rows (positive and negative).
- Tag slow/live-provider tests off by default.
