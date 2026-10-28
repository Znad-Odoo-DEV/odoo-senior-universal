# Security (Odoo 20)

Docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/security.html — https://www.odoo.com/documentation/20.0/developer/reference/backend/orm.html (ported from the 19.0 layout; verify in 20.0 docs)

> **Odoo 20 rewrote model-level security.** `ir.model.access` (ACL) and `ir.rule` (record rules) are merged into a single model, `ir.access`. `ir.model.access.csv` is replaced by `ir.access.csv`. Every custom module's security files must be rewritten for 20 (upstream change: odoo/odoo PR 166359). What you know about `ir.model.access` / `ir.rule` from 14-19 is background only; do not copy 19 security XML/CSV into a 20 module.

## Layers (all must be considered)
1. Groups (`res.groups`) — who. 2. Model access and row filtering (`ir.access`) — which operations per model per group, and which records (the `domain` column). 3. Field groups (`groups=` on fields) — which fields. 4. UI hiding (`groups=` on views/menus/buttons) — cosmetic only, never a substitute.

## Groups
- Define in XML (`res.groups`) with `implied_ids` for hierarchy; `res.groups.privilege` groups related groups in the user form (introduced in 19, still the model in 20); `res.users.groups_id` is `group_ids` (renamed in 19). (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/security.html)
- Check in Python: `self.env.user.has_group('module.group_x')`; in views `groups="module.group_x"`.
- `base.group_user` internal, `base.group_portal`, `base.group_public`, `base.group_system`, `base.group_erp_manager`.

## Access and row filtering: `ir.access`
- One model, `ir.access`, now carries what `ir.model.access` (CRUD per model per group) and `ir.rule` (a domain per model/group) carried in 19. A row ties a model and a group to an `operation`, optionally restricted to records matching a `domain`.
- Every model needs `ir.access` row(s) or it is inaccessible to non-superusers. Give transient models a row for `base.group_user` anyway for clarity.
- File: `security/ir.access.csv`, header exactly:
```
id,name,model_id,group_id/id,operation,domain
```
- Shape of a file (placeholders on purpose: the accepted `operation` values — for example one row per operation vs a combined value — and the exact `model_id` cell format are (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/security.html)):
```csv
id,name,model_id,group_id/id,operation,domain
access_x_model_user,x.model user,<ref to model x.model>,base.group_user,<operation>,
access_x_model_company,x.model own company,<ref to model x.model>,base.group_user,<operation>,"[('company_id', 'in', company_ids)]"
```
- The same data as XML (field names follow the CSV columns):
```xml
<record id="access_x_model_company" model="ir.access">
  <field name="name">X: multi-company</field>
  <field name="model_id" ref="model_x_model"/>
  <field name="group_id" ref="base.group_user"/>
  <!-- operation: value per 20.0 docs -->
  <field name="domain">[('company_id', 'in', company_ids)]</field>
</record>
```
- Load it from the manifest `data` list after the groups file: `security/security.xml`, then `security/ir.access.csv`.
- Do not leave `ir.model.access.csv` or `ir.rule` records in a 20 module: they target models that no longer exist as separate concepts.

### Migrating 19 security to 20
| Odoo 19 | Odoo 20 |
|---|---|
| `security/ir.model.access.csv` (`id,name,model_id:id,group_id:id,perm_read,perm_write,perm_create,perm_unlink`) | `security/ir.access.csv` (`id,name,model_id,group_id/id,operation,domain`) |
| `<record model="ir.rule">` with `domain_force`, `groups`, `perm_*` | an `ir.access` row whose `domain` holds the former `domain_force` |
| Python/SQL/queries on `ir.model.access` or `ir.rule` | target `ir.access` |
| `perm_read/write/create/unlink` flags on one row | expressed through `operation` (how flags map to rows: verify in 20.0 docs) |
| Studio-created access rights and record rules | re-validate after the upgrade; the underlying model changed |
Rewrite by hand and then prove it with tests: for each model and group, one test that should be allowed and one that should be denied.

### Row filtering (the former record rules)
- Domain examples carry over as expressions: own records `[('user_id', '=', user.id)]`; company scope `[('company_id', 'in', company_ids)]`; shared records `['|', ('company_id', '=', False), ('company_id', 'in', company_ids)]`.
- In 19 the `ir.rule` eval context was `user`, `company_id`, `company_ids`, `time`, and global rules were ANDed while group rules were ORed then ANDed with the global ones. How multiple `ir.access` rows with domains combine in 20, and the exact eval context of `domain`, are (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/security.html). Do not assume 19 semantics: write tests for users in several groups.
- Keep domains simple and indexed. `sudo()`/superuser bypasses access checks, including `ir.access` domains.

### Programmatic checks
- `Model.check_access('read')` and `records.check_access('write')` raise `AccessError`; `has_access('write')` returns bool; `_filtered_access('read')` filters a recordset. These replaced `check_access_rights` / `check_access_rule` / `_filter_access_rules` (deprecated since 18) and remain the public API in 20.
- `_check_access` is deprecated in 20: do not call it and do not add new overrides of it; call the public API above. Replacement hook for models that customized it: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm/changelog.html).

## Multi-company
`company_id = fields.Many2one('res.company', required=True, default=lambda s: s.env.company)`; set `_check_company_auto = True` and `check_company=True` on relations so cross-company links raise. Express company visibility as an `ir.access` row with a `company_id` `domain` (see above). Use `with_company(company)` when computing company-specific values. Company-dependent fields: `company_dependent=True`.

## sudo discipline
- `sudo()` bypasses `ir.access` rows and domains. Use for narrow, explicit operations (e.g. reading config, writing a technical field), keep the sudo scope to the minimum recordset, and never feed user input into a sudoed search domain unreviewed.
- Prefer `with_user(user)` to act as a specific user; use `with_context(...)` for flags, not security.
- In controllers, never `request.env[...].sudo().browse(int(id))` and return data without checking ownership/access token (`_document_check_access`, `access_token`).

## Controllers / HTTP
- `auth='user'` default for private routes; `'public'` for anonymous (still runs as the public user); `'none'` no db user. Keep `csrf=True` for `type='http'` POST routes; disable only for verified external webhooks with signature checks.
- Validate and cast all params; use `request.env` (user-scoped); return 403/404 consistently to avoid enumeration. Rate-limit expensive public endpoints.
- Portal access: `portal.mixin` + `access_token`, `_get_access_action`, `CustomerPortal._document_check_access`.

## External API access
- XML-RPC and JSON-RPC are deprecated in 20; the `db` service is removed (no database create/drop/backup over RPC); `common` and `object` are scheduled for removal in Odoo 22 (fall 2028). New integrations use JSON-2 `/json/2/<model>/<method>` (Custom plan only). Docs: https://www.odoo.com/documentation/20.0/developer/reference/external_api.html (verify in 20.0 docs)
- Integrations run as a dedicated user with the minimum groups; its reach is whatever `ir.access` grants that user. Use API keys rather than a human password, never an admin account, and never share one integration user across unrelated systems. (API-key and request-header details: verify in 20.0 docs.)

## Injection and XSS
- SQL: never format values; use `odoo.tools.SQL` or `cr.execute(query, params)`. Identifiers via `SQL.identifier`. Domains through the ORM are safe.
- XSS: QWeb `t-out`/`t-esc` escape; `t-raw` is removed. In Python, `Markup` only for trusted fragments; escape user input with `markupsafe.escape` or `Markup("<b>%s</b>") % value`. `Html` fields are sanitized by default (`sanitize=True`); do not set `sanitize=False` for user-editable HTML.
- `safe_eval` only with trusted domains (server actions, `ir.access` domains); never evaluate user-supplied strings. Avoid `eval/exec`.
- Files: validate mimetype/size of uploads; use `ir.attachment` with `res_model/res_id` so access follows the record; `attachment=True` on Binary.
- Secrets: `ir.config_parameter` (groups restricted) or `res.config.settings`; never hard-code credentials; do not log tokens.

## Field-level
`groups='base.group_system'` on sensitive fields (removed from views/read for others), `fields.Binary(groups=...)`. Computed stored fields with `groups` may be readable via ORM with sudo; mind compute_sudo.

## Checklist
New model -> `ir.access` row(s) in `security/ir.access.csv`, with a `domain` if owned/company-scoped; no `ir.model.access.csv`/`ir.rule` left over; new controller -> auth/csrf/params checked; new sudo -> comment + minimal; new Html/Markup -> sanitization reviewed; new group -> implied_ids + menu/view/`ir.access` use; new external caller -> JSON-2, least-privilege user.
