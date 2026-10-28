# Views, QWeb, OWL (Odoo 20)

Docs: https://www.odoo.com/documentation/20.0/developer/reference/user_interface/view_architectures.html — https://www.odoo.com/documentation/20.0/developer/reference/frontend/owl_components.html (ported from the 19.0 layout; verify in 20.0 docs)

## Views: what is current
- Root tag for list views is `<list>` (unchanged since 18). Use `view_mode="list,form"` in actions and `list` in `ir.ui.view` `type`. Do not write `<tree>` or `view_mode="tree"`.
- `attrs=` and `states=` are gone (removed in 17). Use direct attributes with Python expressions evaluated on the record: `invisible="state != 'draft'"`, `readonly="state in ('done','cancel')"`, `required="type == 'x'"`, `column_invisible="parent.state == 'x'"` (list columns), `context`, `domain` (strings/Python), `options="{'no_create': True}"`.
- Form: `<form>`, `<header>` (buttons + `statusbar` widget), `<sheet>`, `<group>`, `<notebook>/<page>`, `<field>`, `<button type="object|action" name=>`, `<div class="oe_button_box" name="button_box">` with `<button class="oe_stat_button">`. Chatter: `<chatter/>` (since 18) replaces the `<div class="oe_chatter">` block.
- List: `<list editable="bottom|top" multi_edit="1" default_order= decoration-danger="..." sample="1">`, `<field widget=>`, `optional="show|hide"`, `<groupby>`, `<control><create/></control>`, `<header>` for bulk buttons.
- Search: `<search>` with `<field filter_domain>`, `<filter name domain>`, `<separator>`, `<group expand="0">` + `context="{'group_by': 'x'}"`, `<searchpanel>`.
- Others: `kanban` (QWeb templates, `t-name="card"` since 18; `kanban-box` was renamed), `pivot`, `graph`, `calendar`, `gantt` (ent), `cohort`/`map`/`activity`, `hierarchy` (since 18). Spreadsheet/dashboard are Enterprise. Pre-existing views that inherit from views of removed/merged modules (for example `stock_picking_batch`, `website_sale_wishlist`, `website_sale_comparison`, `hr_org_chart`) must be re-pointed to the surviving module's view ids. (verify view ids in 20.0 source)
- Conditional visibility in `<group>`/`<page>`/`<button>` with `invisible`. Hide-by-group: `groups="base.group_user"`.
- Widgets worth reusing: `statusbar, many2many_tags, badge, handle, monetary, image, priority, boolean_toggle, daterange, remaining_days, html, one2many (list editing)`, `many2one_avatar_user`.

## Inheritance
```xml
<record id="view_x_form_inherit" model="ir.ui.view">
  <field name="name">x.form.inherit.my_module</field>
  <field name="model">x.model</field>
  <field name="inherit_id" ref="base_module.view_x_form"/>
  <field name="arch" type="xml">
    <xpath expr="//field[@name='partner_id']" position="after">...</xpath>
    <field name="note" position="attributes"><attribute name="invisible">state == 'done'</attribute></field>
  </field>
</record>
```
- Anchor on `field[@name]`/`group[@name]`/`page[@name]`; avoid positional `[2]`. Positions: `inside, after, before, replace, attributes, move`.
- Use `mode="primary"` to create a derived standalone view. Avoid `replace` of whole blocks; it breaks other extenders.
- Add field to view only if it exists on the model (`depends`); a view error blocks module load.

## Actions and menus
`ir.actions.act_window` (`res_model, view_mode, domain, context, search_view_id, help`), `ir.actions.server` (`state='code'`/`object_write`...), `ir.actions.client`, `ir.actions.act_url`. Menus: `<menuitem id parent action sequence groups>`. Return actions from Python as dicts (`{'type':'ir.actions.act_window', ...}`). Backend URLs are `/odoo/...` (e.g. `/odoo/action-<xmlid>`, `/odoo/<model>/<id>`). Docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/actions.html

## QWeb
Directives: `t-if/t-elif/t-else`, `t-foreach` (+ `_index/_first/_last`), `t-set`, `t-esc`/`t-out` (escape; `t-raw` removed), `t-att-*`, `t-attf-*`, `t-call`, `t-slot`, `t-inherit`, `t-model`. Server templates are `ir.ui.view` type `qweb`; client templates live in `static/src/**/*.xml` as `<templates><t t-name="mod.Name" owl="1">`. In Python, wrap trusted HTML with `markupsafe.Markup`; `Markup` + `%` escapes args. Client-template directives are part of the Owl 3 migration (below): re-check this list against the migration guide. Docs: https://www.odoo.com/documentation/20.0/developer/reference/frontend/qweb.html

## OWL in Odoo 20 (Owl 3)
- **Odoo 20 moves to Owl 3** (3.0.0-alpha.49 upstream; Odoo 19 shipped Owl 2.8.4). It is a pre-release tag: pin the exact version bundled with your 20.0 checkout and read its notes.
- **The OWL 2 -> 3 migration guide lists 22 breaking changes.** Read the whole list before porting any component, hook, template or patch. The compatibility layer that accompanies it is only a temporary bridge, not a long-term solution: port to native Owl 3 APIs and do not ship custom code that depends on the layer. Guide location: odoo/owl repository docs, https://github.com/odoo/owl (verify exact page in 20.0 docs / the Owl repo)
- **Treat every JS/XML snippet in this section as Owl 2-era shape (kept from 19) and validate it against the migration guide before reuse**: component declaration, `static props`, hook signatures, reactivity (`useState`), template directives. The 22 changes are not enumerated here on purpose; do not guess them.
- Expected to carry over conceptually (verify each against the guide): components as classes with `static template` and `setup()`, Odoo registries, services via `useService`, `patch`, Hoot unit tests, the website `Interaction` framework.
- Hooks (Owl 2 names): `useState`, `useRef`, `onWillStart`, `onMounted`, `onWillUpdateProps`, `onWillUnmount`, `useEffect`, `useSubEnv`; Odoo hooks: `useService`, `useBus`, `useAutofocus`, `useChildRef`, `useForwardRefToParent`.
- Services via `useService("orm" | "action" | "dialog" | "notification" | "rpc" | "user" | "company" | "router")`. ORM calls: `await this.orm.searchRead(model, domain, fields, {limit})`, `.call(model, method, args, kwargs)`, `.read`, `.write`, `.create`, `.unlink`, `.webSearchRead`. Server-side `read_group` changed signature in 20; client calls that pass through `orm.call(model, "read_group", ...)` or `orm.readGroup` need the same rewrite (verify client wrapper in 20.0 source).
- Registries: `registry.category("actions" | "fields" | "views" | "services" | "main_components" | "public_components" | "systray" | "user_menuitems" | "web_tour.tours" | "formatters" | "parsers").add(key, value, {sequence, force})`.
- Field widget skeleton (Owl 2-era shape; validate for Owl 3):
```js
import { registry } from "@web/core/registry";
import { Component } from "@odoo/owl";
import { standardFieldProps } from "@web/views/fields/standard_field_props";
export class MyField extends Component {
  static template = "my_module.MyField";
  static props = { ...standardFieldProps };
}
registry.category("fields").add("my_field", { component: MyField, supportedTypes: ["char"] });
```
- Module headers: `/** @odoo-module **/` was the marker for ES-module conversion; files under `static/src` are processed as ES modules natively (since 18) and the header is not required. (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/frontend/javascript_modules.html)
- Patching: `import { patch } from "@web/core/utils/patch"; patch(Target.prototype, { method() { super.method(...arguments); } });` — keep patches minimal, call `super`, patch the class/prototype (`patch(X.prototype, {...})`), not instances. Patches on core components are the most fragile thing in an Owl 3 port: re-read the target's 20.0 source first.
- Props validation: define `static props`; mark optional with `?`; avoid `props: ["*"]` outside generic wrappers. (Owl 3 props syntax: verify in the migration guide.)
- Avoid direct DOM mutation and jQuery in new code; use `t-ref` + hooks. Website public-side JS uses the `Interaction` framework (superseding legacy `publicWidget`, introduced in 18, still valid in 20). (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/frontend.html)

### Porting procedure (19 -> 20 frontend)
1. Inventory custom components, templates, hooks, patches, registry entries, tours.
2. Read the OWL 2->3 migration guide (22 changes) and mark which apply to each item.
3. Port to native Owl 3; use the compatibility layer only as a short-lived bridge, with a removal date.
4. Run Hoot unit tests and tours on a 20.0 database; fix every console warning/error.
5. Re-test patched core components against the 20.0 source, since upstream templates changed too.

## Assets
Manifest: 
```python
'assets': {
  'web.assets_backend': ['my_module/static/src/**/*'],
  'web.assets_frontend': [...],
  'web.assets_tests': ['my_module/static/tests/tours/**/*'],
}
```
JS unit tests (Hoot) are registered in the unit-test bundle (`web.assets_unit_tests` in 18/19; verify bundle name in 20.0 docs). The legacy QUnit bundle (`web.qunit_suite_tests`) is not for new tests.
Directives: `('include', 'web._assets_helpers')`, `('prepend', ...)`, `('after', target, new)`, `('remove', path)`, `('replace', target, new)`. Docs: https://www.odoo.com/documentation/20.0/developer/reference/frontend/assets.html

## Frontend tests
JS unit tests with Hoot (`@odoo/hoot`) in `static/tests/**/*.test.js` (Hoot stays in 20; QUnit is replaced); tours in `web_tour.tours` registry run from Python via `self.start_tour(url, name, login=)`. Docs: https://www.odoo.com/documentation/20.0/developer/reference/frontend/unit_testing.html (verify path in 20.0 docs).
