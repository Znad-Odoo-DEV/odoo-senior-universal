# Custom-code migration 18.0 -> 19.0

What to change in custom modules so they load and behave on 19.0. Sources: ORM changelog https://www.odoo.com/documentation/19.0/developer/reference/backend/orm/changelog.html and the 19.0 developer reference. Items marked (verify) should be confirmed against the live 19.0 page before relying on exact signatures. 18.0 already uses `<list>`, `<chatter/>`, `check_access/has_access`, `_read_group`, Hoot and Owl 2, so this jump is lighter on view changes than 17->18 and heavier on ORM/security.

## Security (highest-impact)
- **`groups_id` -> `group_ids`** on `res.users` and `res.groups`. Update:
  - Python: `user.groups_id`, `self.env.ref(...)` membership checks, `write({'groups_id': [...]})`.
  - XML: `<field name="groups_id" eval="...">` in data/demo and user/group records.
  - Any domain or ACL logic referencing `groups_id`.
- **Group privileges**: groups are reorganized under `res.groups.privilege` (category/privilege rework). If you define groups or depend on specific group XML ids / categories, diff the 19.0 `base`/`mail` group definitions. (verify)
- `check_access(op)` / `has_access(op)` / `_filtered_access(op)` are the access API (already since 18) — ensure no leftover `check_access_rights`/`check_access_rule`.

## ORM / models
- **Constraints & indexes**: migrate `_sql_constraints = [(name, sql, message)]` to declarative class attributes `x = models.Constraint("UNIQUE(col)", "message")`, `models.Index(...)`, `models.UniqueIndex(...)`. `_sql_constraints` is deprecated (still honored — verify) ; new code should use the declarative form.
- **Domains**: optional adoption of `odoo.fields.Domain` (composable `&`/`|`/`~`, `Domain.AND/OR`, `Domain.TRUE/FALSE`). Plain list domains remain valid, so this is a cleanup, not a forced change.
- `read_group` (dict API) is further discouraged; use `_read_group` (tuples) / `formatted_read_group`. (should already be done from 17.)
- `@api.model_create_multi` remains required for `create` overrides.
- Review any direct SQL: prefer `odoo.tools.SQL` and `self.env.execute_query(SQL(...))`.

## Views / UI
- No `<tree>`/`<chatter>`/`attrs` rename this cycle (those were 17/18). Main risk is **inherited standard views moved**: xpath anchors in accounting, inventory, sale, purchase, hr, website and POS may have changed. For each inherited view, open the 19.0 community source and confirm the anchor still exists; fix xpaths.
- New/updated widgets and view options may exist — check https://www.odoo.com/documentation/19.0/developer/reference/user_interface/view_architectures.html (verify).
- The built-in **AI** app adds models/actions; if you add AI-ish features, prefer the standard AI agents/fields over custom code (see the odoo-19 ai-companion skill).

## Frontend
- Owl is still **2.x** in 19 (Owl 3 lands in 20) — no Owl rewrite now, but avoid new Owl-3-only patterns.
- Website `Interaction` framework is expanded; existing `publicWidget` and `Interaction` code keeps working.
- Re-run JS tests under Hoot (already the framework since 18).

## External API / integrations
- New `/json/2/<model>/<method>` endpoint. XML-RPC (`/xmlrpc/2/common`, `/xmlrpc/2/object`) and JSON-RPC (`/jsonrpc`) are **deprecated**, scheduled for removal in 20. Keep them working for now but plan the migration of external callers. https://www.odoo.com/documentation/19.0/developer/reference/external_api.html

## Data / module mechanics
- Manifest `version` -> `19.0.x.y.z`.
- Put data-shape changes in `migrations/19.0.x.y.z/{pre,post}-*.py` (upgrade scripts run during `-u`). Use for renamed columns/models, `groups_id`->`group_ids` data fix-ups, and cleanup of removed records.
- Re-check `noupdate` data records and XML ids against the 19.0 standard set to avoid duplicate/orphan records.

## Fix checklist
1. Bump manifests to `19.0.x.y.z`; resolve dependencies (all OCA/third-party have 19.0).
2. Rename `groups_id` -> `group_ids` everywhere (Python + XML + domains); verify group privilege ids.
3. Migrate `_sql_constraints` to `models.Constraint/Index/UniqueIndex`.
4. Re-validate every inherited view's xpath anchors against 19.0 source.
5. Add `migrations/19.0.x.y.z/` scripts for data changes (incl. the groups field).
6. Update/test `-u <modules> --test-enable`; grep logs for `DeprecationWarning` and "deprecated" and fix each.
7. Plan external-API callers off XML-RPC/JSON-RPC toward `/json/2` (before 20).
