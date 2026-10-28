# Odoo 17 for Developers: new, changed, deprecated

Primary sources: ORM changelog https://www.odoo.com/documentation/17.0/developer/reference/backend/orm/changelog.html — developer index https://www.odoo.com/documentation/17.0/developer.html — release notes https://www.odoo.com/odoo-17-0-release-notes (verify URL). Everything below is "new or changed in 17 relative to 16" unless marked. Items marked (verify) could not be confirmed against the live 17.0 page; check before relying on exact signatures. Note: 17.0 is the stable major release; the 17.1-17.4 SaaS versions (Odoo Online only) carry features that become standard in 18.0 (flagged "17.2+").

## Views / UI (the biggest change)
- `attrs` and `states` are removed; use direct `invisible` / `readonly` / `required` / `column_invisible` attributes holding Python expressions evaluated on the record (`parent.<field>` in sub-views, `context`, `uid`, `context_today()`). https://www.odoo.com/documentation/17.0/developer/reference/user_interface/view_architectures.html
  - `attrs="{'invisible': [('state', '!=', 'draft')]}"` -> `invisible="state != 'draft'"`
  - `attrs="{'readonly': ['|', ('a', '=', 1), ('b', '=', 2)]}"` -> `readonly="a == 1 or b == 2"`
  - `states="draft,sent"` (buttons, fields) -> `invisible="state not in ('draft', 'sent')"`
  - Inherited views: `<attribute name="invisible">...</attribute>`; a leftover `attrs`/`states` fails at module load.
- The legacy JS view/widget compatibility layer is removed from the backend: views, field widgets and client actions are Owl 2 only. Legacy `web.Widget`/`publicWidget` remain for website/public pages.
- List-view root is still `<tree>` (`view_mode="tree,form"`); chatter is still `<div class="oe_chatter">` with `message_follower_ids` / `activity_ids` / `message_ids`; kanban template is `<t t-name="kanban-box">`.
- Backend URLs on 17.0 are `/web#action=...&id=...`. The path-style `/odoo/...` scheme (actions by path, `/odoo/<model>/<id>`) arrives in the 17.2+ SaaS versions and is standard in 18.0; avoid hard-coding either in links, use `action`/`url` helpers.
- Form/list/kanban/search view XML otherwise unchanged; always diff the community source of the view you inherit.

## ORM / Python
- `name_get` is retired: `display_name` is computed in `_compute_display_name`; name searching moves to `_search_display_name` (replaces the `_name_search` override style). Stop overriding or calling `name_get`. (verify the exact search hook on your 17.0 build; `_rec_names_search` still lists the searched fields)
- `_read_group(domain, groupby, aggregates, having, offset, limit, order)` is the new tuple API (`aggregates=['__count', 'amount:sum']`); the dict `read_group` is the legacy interface (the web client still calls it with `web_read_group`); `formatted_read_group` is the dict-output successor (formalized in 18; verify availability). https://www.odoo.com/documentation/17.0/developer/reference/backend/orm.html
- `search_fetch(domain, fields, ...)` and `fetch(fields)`: search + prefetch only the needed fields, one query.
- `odoo.tools.SQL` builds safe, parameterized queries (`SQL("... %s", val)`, `SQL.identifier(name)`); run via `self.env.execute_query(sql)` or `cr.execute(sql)`. (verify `execute_query`)
- Field `index` accepts `True`/`'btree'`/`'btree_not_null'`/`'trigram'` (trigram needs `pg_trgm`). (verify)
- `fields.Properties` / `fields.PropertiesDefinition`: user-definable per-record fields stored as JSON, defined on a parent record. (verify)
- `@api.model_create_multi` is the only supported `create` override style; single-dict overrides are deprecated and warn. (verify)
- Module hooks (`pre_init_hook`, `post_init_hook`, `uninstall_hook`) take `env` (earlier versions passed `cr`/`registry`).
- `company_dependent` still uses `ir.property` in 17 (reworked in 18). `ir.cron` still has `numbercall` / `doall`; `_trigger()` schedules an extra run.
- Runtime: Python 3.10+ is required; PostgreSQL 12+ (verify in https://www.odoo.com/documentation/17.0/administration/on_premise/source.html).

## Frontend
- Owl 2.x is the framework (Owl 3 is a v20 topic). `patch(obj, {...})` two-argument form; `/** @odoo-module **/` header is still required on JS files; `rpc` is a service (`useService("rpc")`).
- JS unit tests are QUnit (`QUnit.module` / `QUnit.test`, bundle `web.qunit_suite_tests`, runner `/web/tests`). Tours use `web_tour.tours` with `test: true`.
- Website/public JS: `publicWidget` (`publicWidget.registry`).
- QWeb: `t-out` for output; `t-raw` is deprecated; client templates need no `owl="1"` marker.
- ORM web methods `web_read` / `web_search_read` / `web_save` with a `specification` are what the web client uses to fetch related display names in one call. (verify)

## HTTP / Web
- Controllers: `type='http'` and `type='json'` (JSON-RPC envelope). External API is XML-RPC (`/xmlrpc/2/common`, `/xmlrpc/2/object`) and JSON-RPC (`/jsonrpc`, service `object`, method `execute_kw`); users authenticate with passwords or API keys (Preferences > Account Security). https://www.odoo.com/documentation/17.0/developer/reference/external_api.html

## Modules / ecosystem
- Manifest `version`: `17.0.x.y.z`; migrations dir `migrations/17.0.x.y.z/` (`pre-*.py` / `post-*.py`, `def migrate(cr, version)`).
- Standard app changes (accounting, inventory, POS, website, IoT additions) affect inherited views/methods; diff the community source for the models you extend rather than trusting memory. Release notes: https://www.odoo.com/odoo-17-0-release-notes (verify).

## Coming in 18 / 19 (not in 17; do not use on 17)
- 18: `<tree>` -> `<list>`; `<chatter/>` tag; kanban `t-name="card"`; `check_access` / `has_access` / `_filtered_access`; `self.env._()`; `Recordset.grouped()`; `ir.property` removal (jsonb `company_dependent`); `_commit_progress` / `_notify_progress` for crons; `Interaction` framework; Hoot tests; `rpc` as a plain import; `/odoo/...` URLs by default; `hierarchy` view.
- 19: `Domain` class; `models.Constraint` / `models.Index` / `models.UniqueIndex`; `res.users.group_ids` + `res.groups.privilege`; `type='jsonrpc'`; `/json/2/<model>/<method>` external API; built-in AI app.

## Migrating custom code from 15/16 to 17 (checklist)
1. Views: `attrs` / `states` -> direct `invisible` / `readonly` / `required` expressions (mandatory; the module will not load otherwise). Check `odoo-bin upgrade_code --help` for a mechanical rewrite helper (verify availability in your build) and review the result by hand.
2. `name_get` -> `_compute_display_name`; `_name_search` overrides -> `_search_display_name` (verify hook); stop calling `name_get()`.
3. `read_group` -> `_read_group` in server code (tuples, `aggregates=`); adopt `search_fetch` / `fetch` where only a few fields are needed.
4. Raw SQL -> `odoo.tools.SQL`; `flush_model` / `invalidate_model` around it (from 15: `flush()` / `invalidate_cache()` are gone).
5. `create` overrides -> `@api.model_create_multi`; hooks in `__manifest__` -> signature `(env)`.
6. From 15: Owl 1 components -> Owl 2 (`setup()`, `static template/props`, `patch(obj, {...})` two-argument form); remove legacy widget code; `fields_view_get` -> `get_view` / `_get_view` (verify).
7. QWeb: `t-raw` -> `t-out`; drop `owl="1"` where present (harmless).
8. Manifest `version` -> `17.0.x.y.z`; add `migrations/17.0.x.y.z/` scripts for data changes; Python 3.10+ runtime.
9. Tests: JS tests in QUnit; tours with `test: true`; run Python tests with `--test-enable` and `-u` the module; grep logs for deprecation warnings (`DeprecationWarning`, "deprecated") and fix each.
