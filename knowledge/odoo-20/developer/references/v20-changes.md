# Odoo 20 for Developers: new, changed, deprecated (vs 19)

Primary sources: ORM changelog https://www.odoo.com/documentation/20.0/developer/reference/backend/orm/changelog.html — developer index https://www.odoo.com/documentation/20.0/developer.html — release notes https://www.odoo.com/odoo-20-release-notes (verify URL).

How to read this file: statements without a marker are confirmed upstream facts for Odoo 20. Anything marked (verify in 20.0 docs: <url>) is a detail that is not confirmed here (exact values, signatures, replacement APIs, menu paths). Sub-page URLs are ported from the 19.0 layout; open them on 20.0 before quoting. Odoo 20 is a heavy jump from 19: security, ORM grouping, the frontend framework and the external API all change.

## 1. Runtime requirements
| | Odoo 19 | Odoo 20 |
|---|---|---|
| Python | >= 3.10 | **>= 3.12** |
| PostgreSQL | >= 13 | **>= 16** |
- Confirmed by the 20.0 source-install page (https://www.odoo.com/documentation/20.0/administration/on_premise/source.html): Python 3.12 or later, PostgreSQL 16 or above; the AI features need the pgvector extension (PostgreSQL 15+). Re-pin Python dependencies for 3.12 (stdlib removals in 3.12 such as `distutils`, `imp`, `asyncore`, `asynchat` break old libraries); re-run `EXPLAIN` on critical hand-written SQL on PostgreSQL 16.

## 2. Security: `ir.access` replaces `ir.model.access` and `ir.rule`  (highest impact)
- `ir.model.access` (ACL) and `ir.rule` (record rules) are **merged into `ir.access`** (upstream odoo/odoo PR 166359).
- The 20.0 security page documents `ir.access` with the fields `name`, `model_id`, `group_id`, `operation` and `domain`. `operation` is a subsequence of the string "crud" (create, read, update, delete; "r" = read, "cd" = create and delete). `domain` is the row-level condition (unset = all records) and may use `time`, `user`, `company_id`, `company_ids`. An empty `group_id` makes the row a restriction applied to every user (a global rule). `ir.model.access.csv` is replaced by `ir.access.csv`, columns `id,name,model_id,group_id/id,operation,domain`.
- **Every custom module's security files must be rewritten for 20.** `ir.rule` XML records and `ir.model.access.csv` files from 19 do not carry over.
- Combination (documented): access is additive across groups; group rules unify (any matching one grants); global rules (no group) intersect with each other and with group rules; no matching row = no access.
- The page shows no CSV file, so the CSV filename, the column header and the `model_id` cell format are (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/security.html).
- `check_access(operation)`, `has_access(operation)`, `_filtered_access(operation)` stay the public API; `_check_access` is deprecated (section 3).
- Groups: `group_ids` and `res.groups.privilege` (19) are unchanged.
- Full detail and the file-by-file mapping: `security.md`.

## 3. ORM / Python
- **`read_group` is public with a new signature** (not listed in the 20.0 ORM changelog, which records only `read_group` deprecated in favor of `_read_group` under 18.0; unverified): `read_group(domain, groupby, aggregates, having, offset, limit, order)`. Old calls using `fields=` or `lazy=` **break**. Return format and the fate of `formatted_read_group`: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm.html). `_read_group` (tuples) remains valid.
- **`_table_query` is removed** (confirmed, 20.0 ORM changelog: "Removing `Model._table_query`"). SQL-backed models defined through it must be reimplemented; the changelog names no replacement: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm/changelog.html).
- Other 20.0 ORM changelog entries: `BinaryValue.filename` added and the RPC format for binary fields updated; field translation handling simplified (fields get a copy function; by default char fields named `name` get "(copy)" appended); a `populate` script generates fake data for testing; manifest terms are stored in each module's own translation files instead of `base`.
- **`_check_access` is deprecated** (not in the 20.0 changelog: unverified). Use `check_access` / `has_access` / `_filtered_access`; replacement for models that overrode it: (verify in 20.0 docs: same changelog).
- **Tracking values are removed** (not in the 20.0 changelog: unverified); tracking messages are generated on the fly. Anything reading stored tracking values (code, SQL, reports, exports) must be reworked. How `tracking=True` and the `tracking_disable` / `mail_notrack` context keys behave: (verify in 20.0 docs: same changelog).
- Unchanged and still the idiom in 20: `Domain` class (`odoo.fields.Domain`; `&`, `|`, `~`, `Domain.AND/OR`, `TRUE/FALSE`); declarative `models.Constraint(...)`, `models.Index(...)`, `models.UniqueIndex(...)` (with `_sql_constraints` deprecated); `check_access`/`has_access`/`_filtered_access`; `search_fetch`/`fetch`; `_compute_display_name` and `_search_display_name` (no `name_get`/`_name_search`); `Recordset.grouped(key)`; `self.env._()` for translations (module-level strings still use `_lt`/`_`); `res.users.group_ids` and `res.groups.privilege`; `odoo.tools.SQL` with `self.env.execute_query(SQL(...))`; `@api.model_create_multi`; the cron progress framework (`_commit_progress`, `_trigger()`) (verify in 20.0 docs).

## 4. Views / UI
Unchanged from 19: `<list>` root and `view_mode="list"`; direct `invisible/readonly/required` Python-expression attributes (no `attrs`/`states`); `<chatter/>`; kanban `t-name="card"`; `/odoo/...` backend URLs (`/odoo/action-<xmlid>`, `/odoo/<model>/<id>`). Views that inherit from views of removed/merged modules (section 7) must be re-pointed. New 20 view types/widgets: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/user_interface/view_architectures.html).

## 5. Frontend: OWL 3
- Odoo 19 used Owl 2.8.4; **Odoo 20 uses Owl 3** (3.0.0-alpha.49).
- The **OWL 2 -> 3 migration guide lists 22 breaking changes**. The **compatibility layer is only a temporary bridge**, not a long-term solution: port components, hooks, templates and patches to native Owl 3. Details and porting procedure: `views-owl.md`. Guide: odoo/owl repository, https://github.com/odoo/owl (verify exact page).
- **Hoot** (`@odoo/hoot`) stays the JS unit test framework; QUnit remains retired for new tests. https://www.odoo.com/documentation/20.0/developer/reference/frontend/unit_testing.html (verify in 20.0 docs)
- The website `Interaction` framework (introduced 18, expanded 19) remains the way to write public-side JS. https://www.odoo.com/documentation/20.0/developer/reference/frontend.html (verify in 20.0 docs)
- `@odoo-module` headers are not required in `static/src` files. (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/frontend/javascript_modules.html)

## 6. HTTP / external API
- **XML-RPC and JSON-RPC (external API) are deprecated.** The **`db` service is removed in Odoo 20** (no database create/duplicate/drop/backup/restore over RPC). The **`common` and `object` services are scheduled for removal in Odoo 22 (fall 2028)**. (In 19 the whole set was announced for removal in 20; that schedule changed.)
- Replacement: **JSON-2**, `POST /json/2/<model>/<method>` (new in 19.0), authenticated with an API key sent as a bearer token in the `Authorization` header; keys last at most three months. The page states external API access "is not available on One App Free or Standard plans" (a Custom plan is required). Confirmed: https://www.odoo.com/documentation/20.0/developer/reference/external_api.html. Applicability to on-premise/Odoo.sh: (verify in 20.0 docs)
- Controller route type `type='jsonrpc'` (renamed from `'json'` in 19, old name kept as deprecated alias) is about your own controllers, not the external API. https://www.odoo.com/documentation/20.0/developer/reference/backend/http.html (verify in 20.0 docs)
- Migrate every external caller (ETL, BI, mobile apps, scripts, connectors) from `common`/`object` to JSON-2 now; move database administration off the `db` service.

## 7. Modules removed or merged in 20.0
| Module | In 20 | Developer action |
|---|---|---|
| `base_vat` | removed | drop from `depends`; VAT-number validation APIs: (verify in 20.0 docs) |
| `base_iban` | removed | drop from `depends`; IBAN validation APIs: (verify in 20.0 docs) |
| `stock_picking_batch` | merged into `stock` | depend on `stock`; batch/wave picking is core |
| `website_sale_wishlist` | merged into `website_sale` | depend on `website_sale` |
| `website_sale_comparison` | merged into `website_sale` | depend on `website_sale` |
| `hr_org_chart` | removed | drop dependency; re-implement the org chart if needed |
| `hr_homeworking` | removed | drop dependency and inherited fields/views |
| `delivery_mondialrelay` | removed | drop from carrier integrations |
| `transifex` | removed | drop dependency |
| `hr_work_entry_holidays` | removed | with the removal of payroll work entries |
| `l10n_fr_hr_work_entry_holidays` | removed | with the removal of payroll work entries |
Search the whole repo (manifests, `_inherit`, `ref=` XML ids, `env.ref`, view ids, security) for these names; installing a module whose `depends` lists a removed module fails.

## 8. Functional changes that reach custom code
Data and flows change in standard apps; custom models, reports and automations touching them must be re-validated (exact model/field changes: verify in 20.0 docs: https://www.odoo.com/odoo-20-release-notes):
- **Field Service is discontinued**; its features moved into **Planning**.
- **Payroll work entries are removed**: custom payroll code must not assume work entries.
- **Accounting**: account groups are replaced by **parent accounts**; payment statuses are renamed; bank-impacting journal entries must originate from **bank transactions**.
- **Expenses become draft vendor bills.**

## 9. Ecosystem and support
- OCA has **no 20.0 branches** as of 2026-09-24 (OpenUpgrade included). Re-check before relying on any OCA module; this is volatile.
- Standard support ends: 19.0 Sept 2028, 18.0 Sept 2027, 17.0 Sept 2026 (already ended). Enterprise: a database older than the 3 latest majors can be charged +25% (no earlier than 6 months after a new major).
- Manifest version `20.0.x.y.z`; migrations in `migrations/20.0.x.y.z/`.

## 10. 19 -> 20 migration checklist (custom modules)
1. **Environment**: Python 3.12 and PostgreSQL 16 on every environment (dev, CI, staging, production); re-pin and test dependencies.
2. **Manifests**: version `20.0.x.y.z`; `migrations/20.0.x.y.z/` directories renamed/created.
3. **Dependencies**: remove or replace every removed/merged module in `depends` (section 7); fix inherited views and `env.ref` ids that pointed into them.
4. **Security rewrite**: replace `security/ir.model.access.csv` and every `ir.rule` record with `security/ir.access.csv` (`id,name,model_id,group_id/id,operation,domain`); move each rule's domain into the `domain` column; update the manifest `data` list; update any code or SQL that reads `ir.model.access` / `ir.rule`.
5. **Access tests**: for each model and group, a positive and a negative test (including multi-company and ownership domains); re-test every `sudo()` / `with_user()` path.
6. **`read_group`**: grep every `read_group(` and rewrite to `(domain, groupby, aggregates, having, offset, limit, order)`; remove `fields=` / `lazy=`; convert field specs to aggregates (`'amount:sum'`, `'__count'`).
7. **`_table_query`**: replace each model that uses it.
8. **`_check_access`**: remove calls and overrides; use `check_access` / `has_access` / `_filtered_access`.
9. **Tracking**: replace reads of stored tracking values; re-test chatter tracking messages.
10. **OWL 3**: inventory components/templates/patches/tours; read the 22-change guide; port natively; do not ship on the compatibility layer; run Hoot tests and tours.
11. **External API**: move callers to JSON-2 `/json/2/<model>/<method>`; remove use of the `db` service; schedule the `common`/`object` migration before Odoo 22; confirm the Custom plan if hosted.
12. **Functional data**: Field Service tasks to Planning; payroll without work entries; account groups to parent accounts; renamed payment statuses in filters/automations/reports; expense flows as draft vendor bills; no manual entries on bank journals. Write `migrations/20.0.x.y.z/` scripts for data changes.
13. **Ecosystem**: confirm a 20.0 release for every OCA/third-party dependency (OCA: none as of 2026-09-24, re-check).
14. **Verify**: `-u <module> --test-enable` on a 20.0 database; grep server logs and the browser console for deprecation warnings (`DeprecationWarning`, "deprecated") and fix each.

### Carry-over: steps still required when coming from 17/18
1. `<tree>` -> `<list>`; `view_mode`; `attrs/states` -> direct attributes.
2. `name_get/_name_search` -> `_compute_display_name/_search_display_name`.
3. `check_access_rights/_rule` -> `check_access/has_access`.
4. `_sql_constraints` -> `models.Constraint/Index` (when ready); `groups_id` -> `group_ids`.
5. `type='json'` -> `type='jsonrpc'` in controllers.
6. `t-raw` -> `t-out`; `<div class="oe_chatter">` -> `<chatter/>`.
