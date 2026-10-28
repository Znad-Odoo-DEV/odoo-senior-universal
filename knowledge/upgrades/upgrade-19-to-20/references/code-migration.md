# Custom-code migration 19.0 -> 20.0

What to change in custom modules so they load and behave on 20.0. Primary source: ORM changelog https://www.odoo.com/documentation/20.0/developer/reference/backend/orm/changelog.html and the 20.0 developer reference. The facts below are verified; items marked (verify in 20.0 docs) are details to confirm on the live page. This jump is heavier than 17->18 or 18->19: security, frontend framework and the grouping API all change.

## 1. Security model — mandatory rewrite (highest impact)
- `ir.model.access` and `ir.rule` are **merged into `ir.access`**. The file `ir.model.access.csv` is **replaced by `ir.access.csv`** with columns:
  `id,name,model_id,group_id/id,operation,domain`
  - one row per (model, group, operation); `operation` is the access kind (read / write / create / unlink — verify exact values in 20.0 docs);
  - `domain` carries the row-level restriction that a record rule used to express (empty = no restriction).
- Consequences: every custom module's `security/` folder must be rewritten; XML `ir.rule` records become `ir.access` rows with a `domain`; code that queried `ir.model.access` / `ir.rule` must target `ir.access`.
- `_check_access` is **deprecated** — use the public `check_access(operation)` / `has_access(operation)` / `_filtered_access(operation)` API.
- Review every `sudo()` and `with_user()` path again: with ACL + domain in one table, the effective access per group may differ from your 19 setup. Add tests for the access boundary.

## 2. ORM
- **`read_group` is public with a new signature**: `read_group(domain, groupby, aggregates, having=None, offset=0, limit=None, order=None)`. Old calls that pass `fields=` or `lazy=` **break** — rewrite them (aggregates as `'field:sum'`, `'__count'`). `_read_group` remains the tuple-returning core.
- **`_table_query` is removed** — SQL-backed/virtual models must be reimplemented (for example as a regular model fed by a stored computation, or a view model defined through the supported mechanism — verify the recommended replacement in 20.0 docs).
- **Tracking values are removed**: `mail.tracking.value` is no longer written; tracking messages are generated on the fly. Code or reports that read stored tracking values must switch to the message history. (verify in 20.0 docs)
- Still valid from 19: `Domain` class, declarative `models.Constraint/Index/UniqueIndex`, `group_ids` + `res.groups.privilege`, `search_fetch`/`fetch`, `_read_group`, `@api.model_create_multi`, `odoo.tools.SQL`.

## 3. Frontend — OWL 3
- 20 ships **OWL 3** (3.0.0-alpha.49; 19 was 2.8.4). The **OWL 2 -> 3 migration guide lists 22 breaking changes**; the **compatibility layer is only a temporary bridge** — port components rather than relying on it.
- Audit every custom Owl component, hook, registry entry and `patch()`; run Hoot tests on 20; fix deprecation warnings in the browser console.
- `<list>`, `<chatter/>`, kanban `card`, `Interaction` framework and `/odoo/` URLs carry over unchanged.

## 4. Removed / merged modules — fix `depends`
`base_vat`, `base_iban`, `stock_picking_batch` (-> `stock`), `website_sale_wishlist` and `website_sale_comparison` (-> `website_sale`), `hr_org_chart`, `hr_homeworking`, `delivery_mondialrelay`, `transifex`, `hr_work_entry_holidays`, `l10n_fr_hr_work_entry_holidays`.
- Remove them from `depends`; re-point inherited models/views to the absorbing module (`stock`, `website_sale`); drop or re-implement features that relied on a removed module (org chart, homeworking, Mondial Relay). VAT/IBAN handling previously in `base_vat`/`base_iban`: verify where the validation now lives in 20.0 before assuming it is gone. (verify in 20.0 docs)

## 5. External API / integrations
- XML-RPC and JSON-RPC are **deprecated**; the **`db` service is removed in 20**; `common` and `object` are scheduled for removal in **Odoo 22 (fall 2028)**.
- Replacement: **JSON-2** `/json/2/<model>/<method>` (available on the Custom plan only). Plan the move for every external caller now; keep `common`/`object` working only as a dated transition.

## 6. Runtime
- **Python >= 3.12**, **PostgreSQL >= 16**. Re-check pinned Python deps for 3.12 compatibility; re-check any raw SQL for PostgreSQL 16.

## 7. Functional data impacts (plan with the business)
- **Field Service discontinued -> Planning**: map FSM tasks/scheduling/worksheets/time-and-material billing onto Planning + Project + Sales; retrain field users; migrate open tasks. (see the `field-service` topic for 20)
- **Payroll work entries removed**: payslip generation no longer assumes work entries; re-validate every payroll localization and the new payslip-input mechanism. (verify in 20.0 docs)
- **Accounting**: account groups -> **parent accounts** (rebuild group-based statements); **payment statuses renamed** (update filters/automations/reports); **bank-impacting journal entries must originate from bank transactions** (manual bank-journal entries in custom flows must become bank transactions); **expenses become draft vendor bills** (expense approvals/analytics change).
- **Batch picking** is core `stock` now; wishlist/comparison are core `website_sale` — remove duplicate custom implementations.

## Fix checklist
1. Bump manifests to `20.0.x.y.z`; purge removed modules from `depends`; confirm every OCA/third-party dependency has a 20.0 release (OCA had none as of 2026-09-24 — re-check).
2. Rewrite `security/`: `ir.model.access.csv` -> `ir.access.csv` (`id,name,model_id,group_id/id,operation,domain`); fold `ir.rule` records into `ir.access` domains; drop `_check_access` for `check_access`/`has_access`.
3. Rewrite every `read_group(...)` call to `(domain, groupby, aggregates, having, offset, limit, order)`; remove `fields=`/`lazy=`.
4. Replace `_table_query` models; replace reads of stored tracking values.
5. Port Owl components to OWL 3 (22-change guide); do not ship on the compatibility layer.
6. Move integrations off XML-RPC/JSON-RPC toward JSON-2; nothing may still use the `db` service.
7. Runtime: Python 3.12 / PostgreSQL 16; re-pin dependencies.
8. Add `migrations/20.0.x.y.z/` scripts for data changes (security rows, renamed payment statuses, account-group -> parent-account mapping, FSM -> Planning, expense -> vendor bill).
9. `-u <modules> --test-enable`; grep logs and browser console for deprecation warnings and fix each; re-run the access-boundary tests.
