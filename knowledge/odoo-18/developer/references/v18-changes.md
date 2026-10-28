# Odoo 18 for Developers: new, changed, deprecated

Primary sources: ORM changelog https://www.odoo.com/documentation/18.0/developer/reference/backend/orm/changelog.html — developer index https://www.odoo.com/documentation/18.0/developer.html — release notes https://www.odoo.com/odoo-18-0-release-notes (verify URL). Everything below is "new or changed in 18 relative to 17". Items marked (verify) could not be confirmed against the live 18.0 page; check before relying on exact signatures.

## ORM / Python
- Access API: `check_access(operation)`, `has_access(operation)`, `_filtered_access(operation)` replace `check_access_rights` / `check_access_rule` / `_filter_access_rules` (introduced in 18, old names deprecated). https://www.odoo.com/documentation/18.0/developer/reference/backend/orm/changelog.html
- `self.env._("text %s", x)`: translation helper bound to the env language (18). Module-level strings still use `_` / `_lt`. Never format before translating. (verify) https://www.odoo.com/documentation/18.0/developer/reference/backend/orm.html
- `read_group` (dict API) is deprecated in favor of `_read_group` (tuples, `aggregates=['field:sum','__count']`, `having`; tuple signature since 17) and `formatted_read_group` for dict results; the web client uses `web_read_group`. (verify) https://www.odoo.com/documentation/18.0/developer/reference/backend/orm.html
- `search_fetch` / `fetch` (17) remain the idiomatic fetch-only-what-you-need pair; `name_get` is gone (deprecated in 17), use `_compute_display_name`; `_name_search` override style is replaced by `_search_display_name`.
- `Recordset.grouped(key)` helper available (dict of recordsets); verify the exact since-version in orm.html.
- `odoo.tools.SQL` (17) is the standard way to build queries; run with `self.env.execute_query(SQL(...))`. Prefer it over string-built SQL in new code.
- `company_dependent` fields: storage moved to a single jsonb column on the model table in 18 and the `ir.property` model is gone; code that read/wrote `ir.property` directly must use the field API. (verify)
- `@api.model_create_multi` remains the required pattern; single-dict `create` overrides are deprecated and warn. (verify)
- Cron framework: `_trigger()` for on-demand runs; a progress helper (`ir.cron._notify_progress(done=, remaining=)`) for batching large backlogs. `numbercall`/`doall` were dropped from `ir.cron` records in 18 — remove them from cron XML. (verify exact names in the 18.0 `base` source; `_commit_progress` is a later name)
- Domains are still plain lists of leaves with `'&'`, `'|'`, `'!'` prefixes; compose with `odoo.osv.expression.AND/OR`. SQL constraints are still `_sql_constraints = [(name, sql, message)]`. The users/groups field is still `groups_id`.
- Python 3.10+ is required for Odoo 18; check PostgreSQL minimum in https://www.odoo.com/documentation/18.0/administration/on_premise/source.html (verify).

## Views / UI
- `<tree>` renamed `<list>` (18): list-view root tag, `view_mode="list,form"`, `ir.ui.view` `type` `list`, and `[False, "list"]` in client action `views`. https://www.odoo.com/documentation/18.0/developer/reference/user_interface/view_architectures.html
- `<chatter/>` single tag in forms replaces the `<div class="oe_chatter">` block with `message_follower_ids` / `activity_ids` / `message_ids` fields (18).
- Kanban: the card template is `<t t-name="card">` (replaces `kanban-box`, 18). Check legacy-name fallback for your build. (verify)
- Direct `invisible` / `readonly` / `required` / `column_invisible` Python-expression attributes; `attrs` and `states` were removed in 17 — if migrating from 16, convert them.
- Backend URL scheme `/odoo/...` (replaces `/web#...` hash URLs, 18); actions addressable by path (`/odoo/action-<xmlid>`, `/odoo/<model>/<id>`). Update hard-coded links and tour start URLs.
- New/updated view types and widgets (e.g. `hierarchy`, additional list/kanban options): check https://www.odoo.com/documentation/18.0/developer/reference/user_interface/view_architectures.html (verify; some are Enterprise-only).

## Frontend
- Owl 2.x is the framework in 18; Owl 3 and the breaking frontend changes land in 20. https://www.odoo.com/documentation/18.0/developer/reference/frontend/owl_components.html
- Hoot (`@odoo/hoot`) is the JS unit-test framework (introduced 18; bundle `web.assets_unit_tests`, runner at `/web/tests`); QUnit is retired for new tests. https://www.odoo.com/documentation/18.0/developer/reference/frontend/unit_testing.html (verify)
- Website: the `Interaction` framework supersedes legacy `publicWidget` for new public-side JS (introduced 18); existing `publicWidget` code keeps working. https://www.odoo.com/documentation/18.0/developer/reference/frontend.html (verify)
- `rpc` is a direct import (`import { rpc } from "@web/core/network/rpc"`) rather than a `useService("rpc")` service; check your 17-era components. (verify)
- `@odoo-module` header is no longer required in `static/src` files (harmless if present). (verify) https://www.odoo.com/documentation/18.0/developer/reference/frontend/javascript_modules.html

## HTTP / Web
- Controller JSON route type: `type='jsonrpc'` is the newer name with `type='json'` kept as an alias. `type='json'` works everywhere; only rename after confirming the 18.0 http reference documents `jsonrpc`. (verify) https://www.odoo.com/documentation/18.0/developer/reference/backend/http.html
- External API in 18 is XML-RPC (`/xmlrpc/2/common`, `/xmlrpc/2/object`) and JSON-RPC (`/jsonrpc`, service `object`, method `execute_kw`). https://www.odoo.com/documentation/18.0/developer/reference/external_api.html

## Modules / ecosystem
- Version string in manifest: `18.0.x.y.z`; migrations dir `migrations/18.0.x.y.z/`.
- Standard app changes (accounting, inventory, POS, website, IoT additions) affect inherited views/methods — diff the community source for the models you extend rather than trusting memory. Release notes: https://www.odoo.com/odoo-18-0-release-notes (verify).
- Module hooks (`pre_init_hook`, `post_init_hook`, `uninstall_hook`) receive `env` (since 17).

## Coming in 19 (not in 18; do not use on 18)
- `Domain` class (`odoo.fields.Domain`) for composable domains; declarative `models.Constraint` / `models.Index` / `models.UniqueIndex` replacing `_sql_constraints`; `res.users.groups_id` renamed `group_ids` with `res.groups.privilege`; `/json/2/<model>/<method>` external API (XML-RPC/JSON-RPC deprecated); built-in AI app. If a snippet uses any of these, it targets 19.

## Migrating custom code from 16/17 to 18 (checklist)
1. `<tree>` -> `<list>`; `view_mode="tree,form"` -> `"list,form"`; from 16 also `attrs/states` -> direct attributes.
2. `<div class="oe_chatter">...</div>` -> `<chatter/>`; kanban `kanban-box` -> `t-name="card"`.
3. `name_get/_name_search` -> `_compute_display_name/_search_display_name`.
4. `check_access_rights/_rule` -> `check_access/has_access`; `_filter_access_rules` -> `_filtered_access`.
5. `read_group` -> `_read_group` / `formatted_read_group`; `_` in Python methods -> `self.env._` where convenient.
6. Replace direct `ir.property` use and drop `numbercall`/`doall` from cron XML (verify).
7. Controllers: keep `type='json'` unless 18.0 docs show `jsonrpc` (verify); external callers stay on XML-RPC/JSON-RPC.
8. Frontend: `t-raw` -> `t-out`; `rpc` service -> `rpc` import; `publicWidget` -> `Interaction` for new public JS; QUnit -> Hoot for new JS tests; `/web#...` links and tour URLs -> `/odoo/...`.
9. Manifest `version` -> `18.0.x.y.z`; add `migrations/18.0.x.y.z/` scripts for data changes.
10. Run tests with `--test-enable` and `-u` the module; grep logs for deprecation warnings (`DeprecationWarning`, "deprecated") and fix each.
