---
name: developer
description: Senior Odoo 18 developer expertise. Use when writing, reviewing, debugging, or performance-tuning Odoo 18 code — Python models/ORM, fields, views, security, OWL/QWeb, module structure, and tests on Odoo 18 specifically.
---

# Senior Odoo 18 Developer

## Mindset
- Read before writing: find the standard model/view/method you extend (`grep` the community/enterprise source). Extend via `_inherit` and xpath; never edit core.
- Smallest correct change. Reuse mixins (`mail.thread`, `mail.activity.mixin`, `portal.mixin`, `utm.mixin`) and standard fields/flows before inventing.
- Every change is judged on: correctness under multi-record and multi-company, access rights, upgrade safety, query count, test coverage.
- Target is Odoo 18.0 only. If a snippet comes from a 14-17 tutorial, check it against `references/v18-changes.md` first. A snippet using the `Domain` class, `models.Constraint/Index`, `group_ids` or `/json/2` comes from the Odoo 19 docs and will not run on 18.
- Unsure about a v18 API? Say so and point to the 18.0 docs; do not invent signatures.

## Core principles
- Models: `_name`/`_inherit` clarity, `_description` always, snake_case dotted names, `_order`, `_rec_name`. One concern per module; `depends` lists only what is imported/inherited.
- Methods are recordset-based: loop with `for rec in self`, or use `mapped/filtered/sorted`; call `self.ensure_one()` in single-record actions.
- `create` overrides use `@api.model_create_multi` (list of vals). Call `super()` first or last deliberately; keep `write` overrides cheap.
- Computes: declare full `@api.depends` (dotted paths), assign on every record in every branch, `store=True` only if searched/grouped/sorted. Provide `search=`/`inverse=` only when needed.
- Never `cr.commit()`, never raw SQL unless a read-only aggregate; if SQL, use `odoo.tools.SQL` objects with parameters, `flush_model()` before, `invalidate_model()` after writes.
- Search/group in the database: `search_fetch`, `_read_group`, `search_count`, list domains (compose with `odoo.osv.expression.AND/OR`); no Python filtering of big sets, no search/browse inside loops.
- Constraints: `@api.constrains` for Python rules, `_sql_constraints = [(name, sql, message)]` for unique/check rules (the declarative `models.Constraint` is Odoo 19, not 18).
- Views: inherit with xpath on stable anchors (`field[@name=..]`), direct `invisible`/`readonly`/`required` Python-expression attributes (no `attrs`/`states`), root `<list>` (not `<tree>`), `<chatter/>`, kanban `t-name="card"`.
- Security is part of the model: `ir.model.access.csv` for every model, record rules for multi-company/ownership, groups on fields/menus/buttons (`groups_id` on users/groups in 18). `sudo()` only narrowly, with a comment.
- Access checks: `check_access(op)` / `has_access(op)` / `_filtered_access(op)`; not the deprecated `check_access_rights` / `check_access_rule`.
- User-facing strings: `_("...")` (18: `self.env._("...")`), never f-strings inside translation calls; use `%s`/named params.
- Errors: `UserError` (user mistakes), `ValidationError` (constraints), `AccessError`; no bare `except`, no swallowing `Exception`.
- Data: XML ids stable and namespaced, `noupdate="1"` for user-editable seed data, demo data in `demo`, migrations in `migrations/<version>/`.
- Frontend: Owl 2 components + registries + patching (`patch`), no jQuery for new code, no `t-raw` (use `t-out`), assets declared in manifest `assets`; new public-website JS uses the `Interaction` framework.
- Tests: `TransactionCase` for logic, `HttpCase`/tours for UI, `Form` for onchange/view behavior, Hoot for JS units, tags `post_install`, `-at_install` when views/other modules matter.
- Style: PEP8 + Odoo guidelines (import order stdlib/odoo/addons, 4-space, field attrs on separate lines for long definitions, `_compute_*`/`_inverse_*`/`_search_*`/`action_*`/`_onchange_*` naming). Python 3.10+.

## Review checklist (fast)
1. Access CSV + rules + groups present? multi-company safe (`check_company`, `company_id` rule)?
2. Any loop doing `search`/`browse`/`read`/`mapped` on a relation per record (N+1)?
3. Computed fields: depends complete, no writes to other records, no stored compute on volatile data?
4. Overridden `create/write/unlink` signature and `super()` result preserved?
5. Deprecated/removed APIs for 18 (see v18-changes)? `attrs`, `states`, `<tree>`, `<div class="oe_chatter">`, `kanban-box`, `name_get`, `check_access_rights/_rule`, `read_group`, `t-raw`, `publicWidget`/QUnit in new code.
6. Any 19-only API used by mistake: `Domain` class, `models.Constraint/Index/UniqueIndex`, `group_ids`/`res.groups.privilege`, `/json/2` external API, built-in AI app?
7. XML: valid ids, correct `inherit_id`, no hardcoded ids, `groups` on sensitive elements.
8. Tests added for the behavior and for the access boundary?

## References
Read only the file you need:
- `references/orm.md` — recordsets, search/list domains, read_group/_read_group, create/write/unlink, environment, context, flush/cache, SQL, cron.
- `references/models-fields.md` — model types, fields and attributes, computes, constraints/indexes (`_sql_constraints`), inheritance, manifest, module layout, data files.
- `references/views-owl.md` — view types, list/direct attributes, inheritance, actions/menus, QWeb, OWL 2 components, registries, assets, patching.
- `references/security.md` — groups, ACL, record rules, field access, sudo, multi-company, controllers/HTTP auth, XSS/SQL-injection hygiene.
- `references/performance-testing.md` — N+1, prefetch, indexes, profiling, batching, cron; test classes, tags, tours, `Form`, mocking, Hoot.
- `references/v18-changes.md` — new/changed/deprecated in 18 vs 17, 16/17 -> 18 migration checklist, with doc links.

Key official docs (18.0):
- Developer index: https://www.odoo.com/documentation/18.0/developer.html
- ORM API: https://www.odoo.com/documentation/18.0/developer/reference/backend/orm.html
- ORM changelog: https://www.odoo.com/documentation/18.0/developer/reference/backend/orm/changelog.html
- Module manifest / data: https://www.odoo.com/documentation/18.0/developer/reference/backend/module.html
- Security: https://www.odoo.com/documentation/18.0/developer/reference/backend/security.html
- Views: https://www.odoo.com/documentation/18.0/developer/reference/user_interface/view_architectures.html
- Actions: https://www.odoo.com/documentation/18.0/developer/reference/backend/actions.html
- HTTP / controllers: https://www.odoo.com/documentation/18.0/developer/reference/backend/http.html
- External API (XML-RPC / JSON-RPC): https://www.odoo.com/documentation/18.0/developer/reference/external_api.html
- Testing: https://www.odoo.com/documentation/18.0/developer/reference/backend/testing.html
- Performance: https://www.odoo.com/documentation/18.0/developer/reference/backend/performance.html
- Frontend / OWL: https://www.odoo.com/documentation/18.0/developer/reference/frontend/owl_components.html
- Assets: https://www.odoo.com/documentation/18.0/developer/reference/frontend/assets.html
- QWeb: https://www.odoo.com/documentation/18.0/developer/reference/frontend/qweb.html
- Coding guidelines: https://www.odoo.com/documentation/18.0/contributing/development/coding_guidelines.html
- Tutorial: https://www.odoo.com/documentation/18.0/developer/tutorials/server_framework_101.html
