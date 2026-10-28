# Models, Fields, Module Structure (Odoo 20)

Docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm.html — https://www.odoo.com/documentation/20.0/developer/reference/backend/module.html (ported from the 19.0 layout; verify in 20.0 docs)

Runtime: Python >= 3.12, PostgreSQL >= 16.

## Model types
- `models.Model` persistent; `models.TransientModel` wizards (auto-vacuumed, `_transient_max_hours`); `models.AbstractModel` mixins/services (no table).
- Attributes: `_name`, `_description` (required), `_inherit`, `_inherits` (delegation), `_order`, `_rec_name`, `_table`, `_auto`, `_check_company_auto = True`, `_parent_name`/`_parent_store` (hierarchies with `parent_path`), `_active_name`.
- `_table_query` is removed in 20: do not define SQL-backed models through it (see `orm.md`).
- Inheritance: classical `_inherit='x'` (no `_name`) extends in place; `_inherit='x'` + new `_name` copies; `_inherit=['a','b']` mixin; `_inherits={'res.partner':'partner_id'}` delegation.

## Fields
`Char, Text, Html, Integer, Float, Monetary, Boolean, Date, Datetime, Selection, Binary, Image, Json, Properties, PropertiesDefinition, Many2one, One2many, Many2many, Many2oneReference, Reference`, plus `Id`.

Common attrs: `string, required, readonly, index, default, copy, store, groups, help, company_dependent, tracking, translate`.
- Relational: `comodel_name, domain, context, ondelete` (`'restrict'|'cascade'|'set null'`; set explicitly on required M2O), `check_company=True`, `auto_join` (use sparingly), `bypass_search_access`. One2many needs `inverse_name`; M2M `relation, column1, column2` only when defaults collide.
- Computed: `compute='_compute_x', store, readonly, precompute=True` (stored computes needed on create, e.g. defaults depending on other vals), `compute_sudo` (default True for stored), `search=`, `inverse=`.
- `Monetary` needs `currency_field` (default `currency_id`); `Float` needs `digits` (precision name like `'Product Price'` or tuple).
- `Selection`: list of tuples; extend with `selection_add=[('x','X')]` plus `ondelete={'x': 'set default'}`.
- `Html`: `sanitize=True` default, use `sanitize_overridable`/`sanitize_style` deliberately; `translate=html_translate` for translated HTML.
- Indexes: `index=True` or `'btree'`, `'btree_not_null'` (skip NULLs, good for sparse M2O), `'trigram'` (fast `ilike '%x%'`, needs `pg_trgm`). (verify variants in 20.0: orm.html)
- `company_dependent`: value stored per company (jsonb column); not searchable across companies cheaply; avoid on large hot tables. Storage moved to a single jsonb column in 18/19.
- `tracking`: marks a field for chatter tracking. In 20 tracking values are removed and tracking messages are generated on the fly; do not build logic on stored tracking records. (verify attribute behavior in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm/changelog.html)

## Constraints and indexes
- Python: `@api.constrains('a','b')` raising `ValidationError`.
- SQL: legacy `_sql_constraints = [('name_uniq','unique(name,company_id)','msg')]` is deprecated. Declarative class-level objects (introduced in 19, still the pattern in 20): `_name_uniq = models.Constraint('unique(name, company_id)', 'Name must be unique per company')`, `models.Index('(field)')`, `models.UniqueIndex('(field) WHERE active')`. (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm.html and changelog)
- `@api.ondelete(at_uninstall=False)` for delete guards.

## Defaults, states, workflow
- Status as `Selection` with `default`, `tracking=True`, `copy=False`; transitions in `action_*` methods that `ensure_one()` and validate current state. No `states=` field attribute (removed in 17; use view `readonly`/`invisible` expressions and Python checks).
- Sequences: `ir.sequence` with `next_by_code`, assign in `create` (multi, loop vals) not in default.

## Mixins
`mail.thread` (chatter, `tracking=True`, `message_post`, `_track_subtype`), `mail.activity.mixin`, `mail.alias.mixin`, `portal.mixin` (`access_url`), `utm.mixin`, `rating.mixin`, `image.mixin`, `avatar.mixin`, `format.address.mixin`. Docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/mixins.html

## Module layout
```
my_module/
  __init__.py            # from . import models, controllers, wizard
  __manifest__.py
  models/ controllers/ wizard/ report/ views/ security/ data/ demo/
  static/src/{js,xml,scss}  static/description/icon.png
  i18n/*.po  tests/  migrations/20.0.1.0.1/{pre,post}-*.py
```
`security/` holds the groups XML and `ir.access.csv` (there is no `ir.model.access.csv` and no `ir.rule` XML in 20).

Manifest keys: `name, version ('20.0.x.y.z'), summary, category, author, website, license ('LGPL-3'|'OEEL-1'), depends, data, demo, assets, application, installable, auto_install, external_dependencies, pre_init_hook, post_init_hook (takes env), uninstall_hook`. `data` order matters: security (groups, then `ir.access.csv`), then views, then actions/menus, then data. Files referencing groups/actions must load after them.

`depends` must not name modules removed or merged in 20: `base_vat`, `base_iban`, `stock_picking_batch` (use `stock`), `website_sale_wishlist` / `website_sale_comparison` (use `website_sale`), `hr_org_chart`, `hr_homeworking`, `delivery_mondialrelay`, `transifex`, `hr_work_entry_holidays`, `l10n_fr_hr_work_entry_holidays`. Where VAT-number/IBAN validation APIs from `base_vat`/`base_iban` now live: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/module.html).

## Data files
- `<record id= model=>` with `<field name= ref=/eval=>`; `noupdate="1"` on seed user-editable data; `<function>` sparingly; `<menuitem>` shorthand; CSV for simple data and for access.
- Access file `security/ir.access.csv`, columns: `id,name,model_id,group_id/id,operation,domain`. Row filtering (the former record rule) goes in the `domain` column. Accepted `operation` values and the exact `model_id` cell format: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/security.html). Full detail and a 19->20 mapping: `security.md`.
- Never hard-code database ids; use `env.ref` and XML ids.

## Reports
QWeb PDF actions: `ir.actions.report` (`model, report_type='qweb-pdf', report_name, report_file`), template `t-call="web.external_layout"`, `t-foreach="docs"`; parsers `_get_report_values` on `report.<module>.<name>`. Docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/reports.html

## Controllers (brief)
`@http.route('/path', type='http'|'jsonrpc', auth='user'|'public'|'none', methods, website, csrf)`. The JSON route type is named `'jsonrpc'` (since 19; `'json'` kept as deprecated alias). This is the route type of your own controllers; it is separate from the deprecated external XML-RPC/JSON-RPC API (use JSON-2 for new external integrations). (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/http.html)

## Style
Odoo coding guidelines: https://www.odoo.com/documentation/20.0/contributing/development/coding_guidelines.html — member order: private attrs, defaults, fields, SQL constraints, compute/inverse/search, selection, constrains/onchange, CRUD overrides, actions, business methods.
