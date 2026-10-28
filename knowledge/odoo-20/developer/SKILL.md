---
name: developer
description: Senior Odoo 20 developer expertise. Use when writing, reviewing, debugging, or performance-tuning Odoo 20 code — Python models/ORM, fields, views, ir.access security, OWL 3/QWeb, module structure, external API (JSON-2), and tests on Odoo 20 specifically.
---

# Senior Odoo 20 Developer

## Mindset
- Read before writing: find the standard model/view/method you extend (`grep` the community/enterprise source). Extend via `_inherit` and xpath; never edit core.
- Smallest correct change. Reuse mixins (`mail.thread`, `mail.activity.mixin`, `portal.mixin`, `utm.mixin`) and standard fields/flows before inventing.
- Every change is judged on: correctness under multi-record and multi-company, access rights, upgrade safety, query count, test coverage.
- Target is Odoo 20.0 only (Python >= 3.12, PostgreSQL >= 16). If a snippet comes from a 14-19 tutorial, check it against `references/v20-changes.md` first: 20 rewrites the security model, changes `read_group`, and moves to OWL 3.
- Unsure about a v20 API? Say so and point to the 20.0 docs; do not invent signatures.

## Breaking in 20 (read first; details and checklist in `references/v20-changes.md`)
- **Security**: `ir.model.access` and `ir.rule` are merged into one model, `ir.access`. `ir.model.access.csv` is replaced by `ir.access.csv` with columns `id,name,model_id,group_id/id,operation,domain`; row filtering (the old record rule) is the `domain` column. Every custom module's security files must be rewritten.
- **ORM**: `read_group` is public with signature `(domain, groupby, aggregates, having, offset, limit, order)`; old calls using `fields=`/`lazy=` break. `_table_query` is removed. `_check_access` is deprecated (use `check_access`/`has_access`). Tracking values are removed; tracking messages are generated on the fly.
- **Frontend**: OWL 3 (3.0.0-alpha.49; 19 shipped 2.8.4). The OWL 2->3 migration guide lists 22 breaking changes; its compatibility layer is only a temporary bridge. Hoot stays the JS test framework.
- **External API**: XML-RPC/JSON-RPC are deprecated; the `db` service is removed in 20; `common`/`object` are scheduled for removal in Odoo 22 (fall 2028). Replacement: JSON-2 `/json/2/<model>/<method>` (Custom plan only).
- **Modules gone/merged**: `base_vat`, `base_iban`, `stock_picking_batch` (-> `stock`), `website_sale_wishlist` and `website_sale_comparison` (-> `website_sale`), `hr_org_chart`, `hr_homeworking`, `delivery_mondialrelay`, `transifex`, `hr_work_entry_holidays`, `l10n_fr_hr_work_entry_holidays`. Fix `depends` and inherited code.
- **Still valid from 19**: `<list>`, `<chatter/>`, direct `invisible/readonly/required`, kanban `t-name="card"`, `self.env._()`, `check_access`/`has_access`/`_filtered_access`, `_read_group`, `search_fetch`/`fetch`, `Domain`, declarative `models.Constraint/Index/UniqueIndex`, `group_ids` + `res.groups.privilege`, `/odoo/` URLs, `Interaction` framework, `@api.model_create_multi`.

## Core principles
- Models: `_name`/`_inherit` clarity, `_description` always, snake_case dotted names, `_order`, `_rec_name`. One concern per module; `depends` lists only what is imported/inherited (and only modules that still exist in 20).
- Methods are recordset-based: loop with `for rec in self`, or use `mapped/filtered/sorted`; call `self.ensure_one()` in single-record actions.
- `create` overrides use `@api.model_create_multi` (list of vals). Call `super()` first or last deliberately; keep `write` overrides cheap.
- Computes: declare full `@api.depends` (dotted paths), assign on every record in every branch, `store=True` only if searched/grouped/sorted. Provide `search=`/`inverse=` only when needed.
- Never `cr.commit()`, never raw SQL unless a read-only aggregate; if SQL, use `odoo.tools.SQL` objects with parameters, `flush_model()` before, `invalidate_model()` after writes. No `_table_query` (removed).
- Search/group in the database: `search_fetch`, `_read_group` or the new public `read_group(domain, groupby, aggregates, having, offset, limit, order)`, `search_count`, domains; no Python filtering of big sets, no search/browse inside loops.
- Views: inherit with xpath on stable anchors (`field[@name=..]`), direct `invisible`/`readonly`/`required` Python-expression attributes (no `attrs`/`states`), root `<list>` (not `<tree>`), `<chatter/>`.
- Security is part of the model: `ir.access` rows (`security/ir.access.csv`) for every model, with the `domain` column for multi-company/ownership row filtering (there is no separate `ir.rule` in 20), groups on fields/menus/buttons. `sudo()` only narrowly, with a comment.
- User-facing strings: `self.env._("...")` (module-level: `_("...")`/`_lt`), never f-strings inside translation calls; use `%s`/named params.
- Errors: `UserError` (user mistakes), `ValidationError` (constraints), `AccessError`; no bare `except`, no swallowing `Exception`.
- Data: XML ids stable and namespaced, `noupdate="1"` for user-editable seed data, demo data in `demo`, migrations in `migrations/<version>/` (`20.0.x.y.z`).
- Frontend: OWL 3 components + registries + patching (`patch`), no jQuery for new code, no `t-raw` (use `t-out`), assets declared in manifest `assets`; do not ship on the Owl 2 compatibility layer.
- External integrations: JSON-2 (`/json/2/<model>/<method>`), not XML-RPC/JSON-RPC; nothing may call the removed `db` service.
- Tests: `TransactionCase` for logic, `HttpCase`/tours for UI, Hoot for JS units, `Form` for onchange/view behavior, tags `post_install`, `-at_install` when views/other modules matter.
- Style: PEP8 + Odoo guidelines (import order stdlib/odoo/addons, 4-space, field attrs on separate lines for long definitions, `_compute_*`/`_inverse_*`/`_search_*`/`action_*`/`_onchange_*` naming).

## Review checklist (fast)
1. `ir.access.csv` rows + `domain` row filters + groups present? Multi-company safe (`check_company`, company `domain`)? No leftover `ir.model.access.csv` / `ir.rule` files?
2. Any loop doing `search`/`browse`/`read`/`mapped` on a relation per record (N+1)?
3. Computed fields: depends complete, no writes to other records, no stored compute on volatile data?
4. Overridden `create/write/unlink` signature and `super()` result preserved?
5. Removed/deprecated in 20 or earlier (see v20-changes)? `read_group(fields=, lazy=)`, `_table_query`, `_check_access`, reads of tracking values, `attrs`, `states`, `<tree>`, `name_get`, `_sql_constraints` style, `groups_id`, XML-RPC/JSON-RPC callers, removed modules in `depends`.
6. XML: valid ids, correct `inherit_id`, no hardcoded ids, `groups` on sensitive elements.
7. Tests added for the behavior and for the access boundary (positive and negative, per group, including the `domain`)?
8. Runs on Python 3.12 / PostgreSQL 16; Owl components ported to Owl 3, not left on the compatibility layer?

## References
Read only the file you need:
- `references/orm.md` — recordsets, search/domains (`Domain`), `read_group` (new public signature)/`_read_group`, create/write/unlink, environment, context, flush/cache, SQL, cron, removed/deprecated ORM pieces.
- `references/models-fields.md` — model types, fields and attributes, computes, constraints/indexes, inheritance, manifest, module layout, data files (`ir.access.csv`).
- `references/views-owl.md` — view types, list/direct attributes, inheritance, actions/menus, QWeb, OWL 3 components, registries, assets, patching.
- `references/security.md` — groups, `ir.access` (ACL + row filtering merged), field access, sudo, multi-company, controllers/HTTP auth, external API, XSS/SQL-injection hygiene.
- `references/performance-testing.md` — N+1, prefetch, indexes, profiling, batching, cron; test classes, tags, tours, Hoot, `Form`, mocking.
- `references/v20-changes.md` — new/changed/deprecated in 20 vs 19, removed modules, and the 19->20 migration checklist.

Key official docs (20.0; sub-page URLs ported from the 19.0 layout, verify in 20.0 docs):
- Developer index: https://www.odoo.com/documentation/20.0/developer.html
- ORM API: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm.html
- ORM changelog: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm/changelog.html
- Module manifest / data: https://www.odoo.com/documentation/20.0/developer/reference/backend/module.html
- Security: https://www.odoo.com/documentation/20.0/developer/reference/backend/security.html
- Views: https://www.odoo.com/documentation/20.0/developer/reference/user_interface/view_architectures.html
- Actions: https://www.odoo.com/documentation/20.0/developer/reference/backend/actions.html
- HTTP / controllers: https://www.odoo.com/documentation/20.0/developer/reference/backend/http.html
- External API (JSON-2): https://www.odoo.com/documentation/20.0/developer/reference/external_api.html
- Testing: https://www.odoo.com/documentation/20.0/developer/reference/backend/testing.html
- Performance: https://www.odoo.com/documentation/20.0/developer/reference/backend/performance.html
- Frontend / OWL: https://www.odoo.com/documentation/20.0/developer/reference/frontend/owl_components.html
- Assets: https://www.odoo.com/documentation/20.0/developer/reference/frontend/assets.html
- QWeb: https://www.odoo.com/documentation/20.0/developer/reference/frontend/qweb.html
- Coding guidelines: https://www.odoo.com/documentation/20.0/contributing/development/coding_guidelines.html
- Tutorial: https://www.odoo.com/documentation/20.0/developer/tutorials/server_framework_101.html
- Release notes: https://www.odoo.com/odoo-20-release-notes
