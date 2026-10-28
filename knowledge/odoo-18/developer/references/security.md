# Security (Odoo 18)

Docs: https://www.odoo.com/documentation/18.0/developer/reference/backend/security.html — https://www.odoo.com/documentation/18.0/developer/reference/backend/orm.html

## Layers (all must be considered)
1. Groups (`res.groups`) — who. 2. Model access (`ir.model.access`) — CRUD per model per group. 3. Record rules (`ir.rule`) — which records. 4. Field groups (`groups=` on fields) — which fields. 5. UI hiding (`groups=` on views/menus/buttons) — cosmetic only, never a substitute.

## Groups
- Define in XML (`res.groups`) with `implied_ids` for hierarchy and `category_id` (an `ir.module.category`) to place the group in the user form; groups in the same exclusive category render as a selection. On 18 the user's groups are the Many2many `res.users.groups_id` (and `res.groups.users`). (Odoo 19 renames it `group_ids` and adds `res.groups.privilege`; do not use those on 18. verify in 18.0 docs: https://www.odoo.com/documentation/18.0/developer/reference/backend/security.html)
- Check in Python: `self.env.user.has_group('module.group_x')`; in views `groups="module.group_x"`.
- `base.group_user` internal, `base.group_portal`, `base.group_public`, `base.group_system`, `base.group_erp_manager`.

## Access rights (ACL)
- Every model needs ACL rows or it is inaccessible to non-superusers (a startup warning flags missing ones). Transient models need rows in recent versions only if configured; give them `base.group_user` access anyway for clarity.
- Check/escalate: `Model.check_access('read')` and `records.check_access('write')` raise `AccessError`; `has_access('write')` returns bool; `_filtered_access('read')`. These replaced `check_access_rights` / `check_access_rule` / `_filter_access_rules` (deprecated since 18). (verify exact signatures in 18.0 docs: orm.html)

## Record rules
```xml
<record id="rule_x_company" model="ir.rule">
  <field name="name">X: multi-company</field>
  <field name="model_id" ref="model_x_model"/>
  <field name="domain_force">[('company_id', 'in', company_ids)]</field>
</record>
<record id="rule_x_own" model="ir.rule">
  <field name="name">X: own records</field>
  <field name="model_id" ref="model_x_model"/>
  <field name="groups" eval="[Command.link(ref('base.group_user'))]"/>
  <field name="domain_force">[('user_id', '=', user.id)]</field>
  <field name="perm_unlink" eval="False"/>
</record>
```
- Eval context: `user`, `company_id`, `company_ids`, `time`. Global rules (no groups) are ANDed; group rules are ORed together, then ANDed with global.
- Use `'|', ('company_id','=',False), ('company_id','in',company_ids)` for shared records. Keep rule domains simple and indexed.
- Rules do not apply to `sudo()`/superuser. Rules apply to search results, read, write, unlink, create.

## Multi-company
`company_id = fields.Many2one('res.company', required=True, default=lambda s: s.env.company)`; set `_check_company_auto = True` and `check_company=True` on relations so cross-company links raise. Use `with_company(company)` when computing company-specific values. Company-dependent fields: `company_dependent=True`.

## sudo discipline
- `sudo()` bypasses ACL and rules. Use for narrow, explicit operations (e.g. reading config, writing a technical field), keep the sudo scope to the minimum recordset, and never feed user input into a sudoed search domain unreviewed.
- Prefer `with_user(user)` to act as a specific user; use `with_context(...)` for flags, not security.
- In controllers, never `request.env[...].sudo().browse(int(id))` and return data without checking ownership/access token (`_document_check_access`, `access_token`).

## Controllers / HTTP
- `auth='user'` default for private routes; `'public'` for anonymous (still runs as the public user); `'none'` no db user. Keep `csrf=True` for `type='http'` POST routes; disable only for verified external webhooks with signature checks.
- Validate and cast all params; use `request.env` (user-scoped); return 403/404 consistently to avoid enumeration. Rate-limit expensive public endpoints.
- Portal access: `portal.mixin` + `access_token`, `_get_access_action`, `CustomerPortal._document_check_access`.
- External API clients authenticate through XML-RPC (`/xmlrpc/2/common` `authenticate`, then `/xmlrpc/2/object` `execute_kw`) or JSON-RPC (`/jsonrpc`); prefer a dedicated API user with an API key (Preferences > Account Security) and minimal groups, never the admin password.

## Injection and XSS
- SQL: never format values; use `odoo.tools.SQL` or `cr.execute(query, params)`. Identifiers via `SQL.identifier`. Domains through the ORM are safe.
- XSS: QWeb `t-out`/`t-esc` escape; avoid the deprecated `t-raw`. In Python, `Markup` only for trusted fragments; escape user input with `markupsafe.escape` or `Markup("<b>%s</b>") % value`. `Html` fields are sanitized by default (`sanitize=True`); do not set `sanitize=False` for user-editable HTML.
- `safe_eval` only with trusted domains (server actions, rules); never evaluate user-supplied strings. Avoid `eval/exec`.
- Files: validate mimetype/size of uploads; use `ir.attachment` with `res_model/res_id` so access follows the record; `attachment=True` on Binary.
- Secrets: `ir.config_parameter` (groups restricted) or `res.config.settings`; never hard-code credentials; do not log tokens.

## Field-level
`groups='base.group_system'` on sensitive fields (removed from views/read for others), `fields.Binary(groups=...)`. Computed stored fields with `groups` may be readable via ORM with sudo; mind compute_sudo.

## Checklist
New model → ACL row(s) + record rule if owned/company-scoped; new controller → auth/csrf/params checked; new sudo → comment + minimal; new Html/Markup → sanitization reviewed; new group → implied_ids + menu/view/ACL use.
