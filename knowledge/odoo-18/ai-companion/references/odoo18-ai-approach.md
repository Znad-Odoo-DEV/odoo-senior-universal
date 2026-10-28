# AI on Odoo 18: there is no built-in AI app

Base: https://www.odoo.com/documentation/18.0/applications/productivity.html (Productivity apps index; it has no AI section in 18.0). Multi-company settings: https://www.odoo.com/documentation/18.0/applications/general/companies/multi_company.html
Status legend: CONFIRMED = stable fact about the 18 line. (verify) = check the 18.0 docs or your build before asserting.

## CONFIRMED: what 18 does not have
- No AI app. No AI agents, topics, sources, tools; no "Ask AI" button; no AI fields; no AI server-action type; no "Providers / API keys" settings screen. These are Odoo 19 features documented under `applications/productivity/ai.html`, a page that does not exist in the 18.0 docs. Never send an 18 user to those menus.
- No bundled LLM connector for OpenAI, Gemini or local models. Anything that calls an LLM on 18 is custom code, a module from the Apps store/OCA, or an external service wired in.
- Non-LLM "smart" features that do exist are not an AI framework: e.g. predictive lead scoring in CRM (statistical, Community) and document digitization/OCR through IAP (Enterprise, paid credits) (verify scope and pricing in the 18.0 docs).

## Approaches, in order of preference
1. **Apps-store or OCA module** (search apps.odoo.com / github.com/OCA for version 18.0: "OpenAI", "Gemini", "LLM", "AI assistant"). Accept only if: maintained for 18.0, clear license (LGPL/OPL), keys stored in restricted config, requests run as the user (no blanket `sudo()`), async with timeouts, audit log, data sent to the provider is documented. Read the source before installing on a production database. Odoo Online cannot install third-party apps; Odoo.sh and on-premise can.
2. **Automation rules + server actions (low-code glue)**. An automation rule (`base.automation`; Settings > Technical > Automation in developer mode, or Studio automations on Enterprise) triggers a server action on create/update/stage change. Useful actions: create an activity or chatter note, send an email, run a Python action that calls a small model method, or send a webhook notification to an external worker that calls the LLM and writes the result back over XML-RPC/JSON-RPC with a least-privilege API user (verify the action list and webhook availability in your build). Python server actions cannot make arbitrary network calls on Odoo Online; use the webhook route there.
3. **Custom module** for bespoke UX, tools, retrieval or non-OpenAI providers: provider-agnostic service model -> async queue/cron -> result stored on the record -> OWL/UI affordance. Patterns: `integrating-llms.md`, `rag-over-odoo-data.md`, `security-cost.md`. Needs Odoo.sh or on-premise.
4. **External assistant over the API**: an outside chat or agent tool that reads/writes Odoo through XML-RPC (`/xmlrpc/2/common`, `/xmlrpc/2/object`) or JSON-RPC (`/jsonrpc`), authenticating as the requesting user (own API key) so groups and record rules apply. Odoo 19's `/json/2` endpoint does not exist on 18. Never share one admin integration user across end users.
5. **Upgrade to Odoo 19** only if the native AI app is the business driver; that is a migration project (escalate for upgrade planning), not a configuration step.

## Decision guide
- Q&A over company documents -> reviewed Apps-store module, or custom retrieval over Knowledge/Documents content (`rag-over-odoo-data.md`).
- Field autofill, summaries, drafts -> custom module (stored field + button + queued request) or automation -> webhook -> worker writes back.
- Record-triggered action chosen by an LLM -> custom module or external worker with a narrow tool allowlist; rules enforced in Python.
- Any provider (OpenAI, Gemini, local Ollama/vLLM) -> keep a provider-agnostic seam so the choice is a setting.
- Odoo Online -> no custom code; webhook automation or an Online-compatible service only.

## What to tell a user who asks for "the Odoo AI app" on 18
It is not in Odoo 18. Options are the approaches above; the cheapest safe start is one narrow use case (for example a draft reply or a summary stored as a chatter note after user approval) behind a setting, on staging.

## NOT verified - do not assert
- Names, quality, pricing or maintenance status of specific third-party/OCA AI modules for 18.0: check the listing and source.
- Exact labels and paths of the automation UI in your 18 build and which action types Odoo Online allows: (verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/productivity.html and Settings > Technical).
- Edition/plan requirements and credits for IAP-based features: check your subscription.
