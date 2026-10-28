# Odoo 19 for Developers: new, changed, deprecated

Primary sources: ORM changelog https://www.odoo.com/documentation/19.0/developer/reference/backend/orm/changelog.html — developer index https://www.odoo.com/documentation/19.0/developer.html — release notes https://www.odoo.com/odoo-19-0-release-notes (verify URL). Items marked (verify) could not be confirmed against the live 19.0 page; check before relying on exact signatures.

## ORM / Python
- `Domain` class (`odoo.fields.Domain`): composable, optimizable domains with `&`, `|`, `~`, `Domain.AND/OR`, `TRUE/FALSE`. Lists still work. https://www.odoo.com/documentation/19.0/developer/reference/backend/orm.html (verify)
- Declarative SQL constraints and indexes: `models.Constraint(...)`, `models.Index(...)`, `models.UniqueIndex(...)` as class attributes; `_sql_constraints` deprecated. https://www.odoo.com/documentation/19.0/developer/reference/backend/orm/changelog.html (verify)
- `read_group` (dict API) deprecated; use `_read_group` (tuples, `aggregates=['field:sum','__count']`, `having`) and `formatted_read_group` for dict results. (verify) https://www.odoo.com/documentation/19.0/developer/reference/backend/orm.html
- Access API: `check_access(operation)`, `has_access(operation)`, `_filtered_access(operation)` replace `check_access_rights`/`check_access_rule` (introduced 18). https://www.odoo.com/documentation/19.0/developer/reference/backend/orm/changelog.html
- `search_fetch`/`fetch` (17) are the idiomatic fetch-only-what-you-need pair; `name_get` removed in 17, use `_compute_display_name`; `_name_search` replaced by `_search_display_name`.
- `Recordset.grouped(key)` helper; `self.env._()` for translations in 18+ (module-level strings still use `_lt`/`_`). (verify)
- `res.users.groups_id` renamed `group_ids`; group privileges reworked with `res.groups.privilege`. https://www.odoo.com/documentation/19.0/developer/reference/backend/security.html (verify)
- Database cursor: `env.cr` operations should use `odoo.tools.SQL`; `self.env.execute_query(SQL(...))`.
- `@api.model_create_multi` remains the pattern; legacy single-dict `create` signatures are discouraged/removed. (verify)
- Cron framework: progress tracking/`_commit_progress`, `_trigger()` for on-demand runs (since 18). (verify)

## Views / UI
- `<list>` is the list view root (renamed from `<tree>` in 18); `view_mode="list"`. Direct `invisible/readonly/required` Python-expression attributes; `attrs` and `states` removed (17). https://www.odoo.com/documentation/19.0/developer/reference/user_interface/view_architectures.html
- `<chatter/>` single tag in forms (18+). Kanban template naming `t-name="card"` replaced `kanban-box` (18+) (verify).
- Backend URL scheme `/odoo/...` (17.2+ / 18); actions are addressable by path (`/odoo/action-<xmlid>`, `/odoo/<model>/<id>`).
- New/updated view types and widgets (e.g. `hierarchy`, additional list/kanban options): check https://www.odoo.com/documentation/19.0/developer/reference/user_interface/view_architectures.html (verify).

## Frontend
- Owl 2.x still the framework in 19; Owl 3 and breaking frontend changes land in 20. https://www.odoo.com/documentation/19.0/developer/reference/frontend/owl_components.html
- Hoot (`@odoo/hoot`) is the JS unit test framework; QUnit retired for new tests. https://www.odoo.com/documentation/19.0/developer/reference/frontend/unit_testing.html (verify)
- Website: `Interaction` framework supersedes legacy `publicWidget` for new public-side JS (introduced 18, expanded 19). https://www.odoo.com/documentation/19.0/developer/reference/frontend.html (verify)
- `@odoo-module` header no longer required in `static/src` files in recent versions. (verify) https://www.odoo.com/documentation/19.0/developer/reference/frontend/javascript_modules.html

## HTTP / Web
- Controller `type='jsonrpc'` replaces `type='json'` (old name aliased/deprecated). https://www.odoo.com/documentation/19.0/developer/reference/backend/http.html (verify)
- `/json/2/<model>/<method>` external API (replacement for XML-RPC/JSON-RPC `/xmlrpc`, `/jsonrpc`; XML-RPC/JSON-RPC deprecated, scheduled removal in 20). https://www.odoo.com/documentation/19.0/developer/reference/external_api.html (verify)

## Modules / ecosystem
- Version string in manifest: `19.0.x.y.z`; migrations dir `migrations/19.0.x.y.z/`.
- Standard app changes (accounting, inventory, POS, AI agents/IoT additions) affect inherited views/methods — diff the community source for the models you extend rather than trusting memory. Release notes: https://www.odoo.com/odoo-19-0-release-notes (verify).
- Python version support: Odoo 19 requires Python 3.10+ (verify in https://www.odoo.com/documentation/19.0/administration/on_premise/source.html).

## Migrating custom code from 17/18 (checklist)
1. `<tree>` -> `<list>`; `view_mode`; `attrs/states` -> direct attributes.
2. `name_get/_name_search` -> `_compute_display_name/_search_display_name`.
3. `check_access_rights/_rule` -> `check_access/has_access`.
4. `read_group` -> `_read_group`/`formatted_read_group`.
5. `_sql_constraints` -> `models.Constraint/Index` (when ready); `groups_id` -> `group_ids`.
6. `type='json'` -> `type='jsonrpc'` in controllers; replace external XML-RPC use with `/json/2`.
7. `t-raw` -> `t-out`; `<div class="oe_chatter">` -> `<chatter/>`.
8. Run tests with `--test-enable` and `-u` the module; grep logs for deprecation warnings (`DeprecationWarning`, "deprecated") and fix each.
