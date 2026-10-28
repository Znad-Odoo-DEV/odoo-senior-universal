---
name: developer
description: Senior Odoo 19 developer expertise. Use when writing, reviewing, debugging, or performance-tuning Odoo 19 code — Python models/ORM, fields, views, security, OWL/QWeb, module structure, and tests on Odoo 19 specifically.
---

# Senior Odoo 19 Developer

## Mindset
- Read before writing: find the standard model/view/method you extend (`grep` the community/enterprise source). Extend via `_inherit` and xpath; never edit core.
- Smallest correct change. Reuse mixins (`mail.thread`, `mail.activity.mixin`, `portal.mixin`, `utm.mixin`) and standard fields/flows before inventing.
- Every change is judged on: correctness under multi-record and multi-company, access rights, upgrade safety, query count, test coverage.
- Target is Odoo 19.0 only. If a snippet comes from a 14-17 tutorial, check it against `references/v19-changes.md` first.
- Unsure about a v19 API? Say so and point to the 19.0 docs; do not invent signatures.

## Core principles
- Models: `_name`/`_inherit` clarity, `_description` always, snake_case dotted names, `_order`, `_rec_name`. One concern per module; `depends` lists only what is imported/inherited.
- Methods are recordset-based: loop with `for rec in self`, or use `mapped/filtered/sorted`; call `self.ensure_one()` in single-record actions.
- `create` overrides use `@api.model_create_multi` (list of vals). Call `super()` first or last deliberately; keep `write` overrides cheap.
- Computes: declare full `@api.depends` (dotted paths), assign on every record in every branch, `store=True` only if searched/grouped/sorted. Provide `search=`/`inverse=` only when needed.
- Never `cr.commit()`, never raw SQL unless a read-only aggregate; if SQL, use `odoo.tools.SQL` objects with parameters, `flush_model()` before, `invalidate_model()` after writes.
- Search/group in the database: `search_fetch`, `_read_group`, `search_count`, domains; no Python filtering of big sets, no search/browse inside loops.
- Views: inherit with xpath on stable anchors (`field[@name=..]`), direct `invisible`/`readonly`/`required` Python-expression attributes (no `attrs`/`states`), root `<list>` (not `<tree>`), `<chatter/>`.
- Security is part of the model: `ir.model.access.csv` for every model, record rules for multi-company/ownership, groups on fields/menus/buttons. `sudo()` only narrowly, with a comment.
- User-facing strings: `_("...")` (v18+: `self.env._("...")`), never f-strings inside translation calls; use `%s`/named params.
- Errors: `UserError` (user mistakes), `ValidationError` (constraints), `AccessError`; no bare `except`, no swallowing `Exception`.
- Data: XML ids stable and namespaced, `noupdate="1"` for user-editable seed data, demo data in `demo`, migrations in `migrations/<version>/`.
- Frontend: OWL components + registries + patching (`patch`), no jQuery for new code, no `t-raw` (use `t-out`), assets declared in manifest `assets`.
- Tests: `TransactionCase` for logic, `HttpCase`/tours for UI, `Form` for onchange/view behavior, tags `post_install`, `-at_install` when views/other modules matter.
- Style: PEP8 + Odoo guidelines (import order stdlib/odoo/addons, 4-space, field attrs on separate lines for long definitions, `_compute_*`/`_inverse_*`/`_search_*`/`action_*`/`_onchange_*` naming).

## Review checklist (fast)
1. Access CSV + rules + groups present? multi-company safe (`check_company`, `company_id` rule)?
2. Any loop doing `search`/`browse`/`read`/`mapped` on a relation per record (N+1)?
3. Computed fields: depends complete, no writes to other records, no stored compute on volatile data?
4. Overridden `create/write/unlink` signature and `super()` result preserved?
5. Deprecated v19 APIs used (see v19-changes)? `attrs`, `states`, `<tree>`, `name_get`, `_sql_constraints` style, `read_group`, `groups_id`?
6. XML: valid ids, correct `inherit_id`, no hardcoded ids, `groups` on sensitive elements.
7. Tests added for the behavior and for the access boundary?

## References
Read only the file you need:
- `references/orm.md` — recordsets, search/domains (`Domain`), read_group/_read_group, create/write/unlink, environment, context, flush/cache, SQL, cron.
- `references/models-fields.md` — model types, fields and attributes, computes, constraints/indexes, inheritance, manifest, module layout, data files.
- `references/views-owl.md` — view types, list/direct attributes, inheritance, actions/menus, QWeb, OWL 2 components, registries, assets, patching.
- `references/security.md` — groups, ACL, record rules, field access, sudo, multi-company, controllers/HTTP auth, XSS/SQL-injection hygiene.
- `references/performance-testing.md` — N+1, prefetch, indexes, profiling, batching, cron; test classes, tags, tours, `Form`, mocking.
- `references/v19-changes.md` — new/changed/deprecated in 19 with doc links.

Key official docs (19.0):
- Developer index: https://www.odoo.com/documentation/19.0/developer.html
- ORM API: https://www.odoo.com/documentation/19.0/developer/reference/backend/orm.html
- ORM changelog: https://www.odoo.com/documentation/19.0/developer/reference/backend/orm/changelog.html
- Module manifest / data: https://www.odoo.com/documentation/19.0/developer/reference/backend/module.html
- Security: https://www.odoo.com/documentation/19.0/developer/reference/backend/security.html
- Views: https://www.odoo.com/documentation/19.0/developer/reference/user_interface/view_architectures.html
- Actions: https://www.odoo.com/documentation/19.0/developer/reference/backend/actions.html
- HTTP / controllers: https://www.odoo.com/documentation/19.0/developer/reference/backend/http.html
- Testing: https://www.odoo.com/documentation/19.0/developer/reference/backend/testing.html
- Performance: https://www.odoo.com/documentation/19.0/developer/reference/backend/performance.html
- Frontend / OWL: https://www.odoo.com/documentation/19.0/developer/reference/frontend/owl_components.html
- Assets: https://www.odoo.com/documentation/19.0/developer/reference/frontend/assets.html
- QWeb: https://www.odoo.com/documentation/19.0/developer/reference/frontend/qweb.html
- Coding guidelines: https://www.odoo.com/documentation/19.0/contributing/development/coding_guidelines.html
- Tutorial: https://www.odoo.com/documentation/19.0/developer/tutorials/server_framework_101.html
