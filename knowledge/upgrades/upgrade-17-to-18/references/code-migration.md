# Custom-code migration 17.0 -> 18.0

What to change in custom modules so they load and behave on 18.0. Sources: ORM changelog https://www.odoo.com/documentation/18.0/developer/reference/backend/orm/changelog.html and the 18.0 developer reference. Items marked (verify) should be confirmed against the live 18.0 page. This jump renames several view and API constructs, so most modules need edits.

## Views / UI (most frequent edits)
- **`<tree>` -> `<list>`**: the list-view root tag. Also update `view_mode="tree,form"` -> `"list,form"`, client-action `views` `[False, "tree"]` -> `[False, "list"]`, and `ir.ui.view` records with `type` `tree` (and search-view defaults). Inherited views: the `inherit_id` target's structure changed too — re-check xpaths.
- **Chatter**: replace the `<div class="oe_chatter"><field name="message_follower_ids"/><field name="activity_ids"/><field name="message_ids"/></div>` block with a single `<chatter/>` tag.
- **Kanban**: card template `<t t-name="kanban-box">` -> `<t t-name="card">`. (verify any legacy-name fallback.)
- `attrs`/`states` were removed in 17; if migrating code that still has them, convert to direct `invisible`/`readonly`/`required`/`column_invisible` Python-expression attributes.
- Backend links: the `/odoo/...` URL scheme (17.2+) is standard in 18; update hard-coded `/web#...` links and tour start URLs.

## Security / access
- **`check_access_rights(op)` / `check_access_rule(op)` -> `check_access(op)` / `has_access(op)`**; `_filter_access_rules` -> `_filtered_access`. Update permission checks and any custom controllers.
- The users/groups field is still `groups_id` in 18 (the `group_ids` rename is 19) — do **not** rename it during this jump.

## ORM / models
- **Translations**: `self.env._("text %s", x)` is available (bound to env language); module-level `_`/`_lt` still valid. Never format before translating.
- `read_group` (dict API) is deprecated; use `_read_group` (tuples) / `formatted_read_group`. (Already encouraged in 17.)
- **`company_dependent`**: storage moved to a single jsonb column on the model table and the `ir.property` model is **removed** — code that read/wrote `ir.property` directly must use the field API. (verify) Add a migration script if you stored data there.
- **`ir.cron`**: `numbercall` and `doall` fields were dropped — remove them from cron XML/data; use `_trigger()` for on-demand runs and the progress helper for large batches. (verify names)
- Domains are still plain lists (the `Domain` class is 19); `_sql_constraints = [(name, sql, message)]` is still the pattern (declarative `models.Constraint` is 19). `@api.model_create_multi` remains required.

## Frontend
- Owl is **2.x** in both 17 and 18 — no Owl rewrite.
- **Hoot** (`@odoo/hoot`) replaces QUnit for new JS unit tests (bundle `web.assets_unit_tests`, runner `/web/tests`). Existing QUnit suites: port when you touch them. (verify)
- New public-website JS: prefer the **`Interaction`** framework; existing `publicWidget` keeps working.
- `rpc` is a **direct import** (`import { rpc } from "@web/core/network/rpc"`), not `useService("rpc")` — update 17-era components. (verify)
- `@odoo-module` header is no longer required in `static/src` (harmless if present). `t-raw` -> `t-out` (already from earlier versions).

## HTTP / integrations
- Controller JSON route type: `type='jsonrpc'` is the newer name with `type='json'` kept as an alias — `type='json'` works; only rename after confirming the 18.0 http reference documents `jsonrpc`. (verify) https://www.odoo.com/documentation/18.0/developer/reference/backend/http.html
- External API stays XML-RPC (`/xmlrpc/2`) and JSON-RPC (`/jsonrpc`) in 18 (the `/json/2` endpoint is 19). No external-caller change required for this jump.

## Data / module mechanics
- Manifest `version` -> `18.0.x.y.z`.
- Data-shape changes go in `migrations/18.0.x.y.z/{pre,post}-*.py` (run during `-u`): e.g. `ir.property` -> jsonb data move, cron field cleanup, any renamed columns/models.
- Re-check `noupdate` records and XML ids against the 18.0 standard set.

## Fix checklist
1. Bump manifests to `18.0.x.y.z`; confirm all OCA/third-party deps have 18.0.
2. `<tree>` -> `<list>` + `view_mode`/`views` list rename; `oe_chatter` -> `<chatter/>`; kanban `kanban-box` -> `card`.
3. `check_access_rights/_rule` -> `check_access/has_access`; `_filter_access_rules` -> `_filtered_access`.
4. Remove `ir.property` direct use and `numbercall`/`doall` from crons; add migration scripts.
5. Re-validate inherited view xpaths against 18.0 source; fix `/web#...` links and tour URLs to `/odoo/...`.
6. Frontend: QUnit -> Hoot for new tests; `publicWidget` -> `Interaction` for new public JS; `rpc` service -> import.
7. `-u <modules> --test-enable`; grep logs for `DeprecationWarning`/"deprecated" and fix each.
