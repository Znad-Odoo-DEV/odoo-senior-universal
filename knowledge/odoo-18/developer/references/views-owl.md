# Views, QWeb, OWL (Odoo 18)

Docs: https://www.odoo.com/documentation/18.0/developer/reference/user_interface/view_architectures.html — https://www.odoo.com/documentation/18.0/developer/reference/frontend/owl_components.html

## Views: what is current
- Root tag for list views is `<list>`. `<tree>` was renamed in 18; use `view_mode="list,form"` in actions and `list` in `ir.ui.view` `type`. Do not write `<tree>` or `view_mode="tree"`.
- `attrs=` and `states=` are gone (removed in 17). Use direct attributes with Python expressions evaluated on the record: `invisible="state != 'draft'"`, `readonly="state in ('done','cancel')"`, `required="type == 'x'"`, `column_invisible="parent.state == 'x'"` (list columns), `context`, `domain` (strings/Python), `options="{'no_create': True}"`.
- Form: `<form>`, `<header>` (buttons + `statusbar` widget), `<sheet>`, `<group>`, `<notebook>/<page>`, `<field>`, `<button type="object|action" name=>`, `<div class="oe_button_box" name="button_box">` with `<button class="oe_stat_button">`. Chatter: `<chatter/>` (v18) replaces the `<div class="oe_chatter">` block.
- List: `<list editable="bottom|top" multi_edit="1" default_order= decoration-danger="..." sample="1">`, `<field widget=>`, `optional="show|hide"`, `<groupby>`, `<control><create/></control>`, `<header>` for bulk buttons.
- Search: `<search>` with `<field filter_domain>`, `<filter name domain>`, `<separator>`, `<group expand="0">` + `context="{'group_by': 'x'}"`, `<searchpanel>`.
- Others: `kanban` (QWeb templates, `t-name="card"` in 18; `kanban-box` renamed — verify legacy fallback in 18.0), `pivot`, `graph`, `calendar`, `activity`; Enterprise: `gantt`, `cohort`, `map`, `hierarchy` (new in 18; verify edition), spreadsheet/dashboard.
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
`ir.actions.act_window` (`res_model, view_mode, domain, context, search_view_id, help`), `ir.actions.server` (`state='code'`/`object_write`...), `ir.actions.client`, `ir.actions.act_url`. Menus: `<menuitem id parent action sequence groups>`. Return actions from Python as dicts (`{'type':'ir.actions.act_window', ...}`). Backend URLs are `/odoo/...`; actions are addressable by path. Docs: https://www.odoo.com/documentation/18.0/developer/reference/backend/actions.html

## QWeb
Directives: `t-if/t-elif/t-else`, `t-foreach` (+ `_index/_first/_last`), `t-set`, `t-esc`/`t-out` (escape; `t-raw` is deprecated, use `t-out`), `t-att-*`, `t-attf-*`, `t-call`, `t-slot`, `t-inherit`, `t-model`. Server templates are `ir.ui.view` type `qweb`; client templates live in `static/src/**/*.xml` as `<templates><t t-name="mod.Name">` (the legacy `owl="1"` marker is not needed). In Python, wrap trusted HTML with `markupsafe.Markup`; `Markup` + `%` escapes args. Docs: https://www.odoo.com/documentation/18.0/developer/reference/frontend/qweb.html

## OWL in Odoo 18
- Odoo 18 uses Owl 2.x (not 3; Owl 3 is a v20 topic). Components are classes extending `Component` with `static template`, `static props`, `static components`, `setup()` hook.
- Hooks: `useState`, `useRef`, `onWillStart`, `onMounted`, `onWillUpdateProps`, `onWillUnmount`, `useEffect`, `useSubEnv`; Odoo hooks: `useService`, `useBus`, `useAutofocus`, `useChildRef`, `useForwardRefToParent`.
- Services via `useService("orm" | "action" | "dialog" | "notification" | "user" | "company" | "router")`. ORM calls: `await this.orm.searchRead(model, domain, fields, {limit})`, `.call(model, method, args, kwargs)`, `.read`, `.write`, `.create`, `.unlink`, `.webSearchRead`. Raw controller calls use the `rpc` function import (`import { rpc } from "@web/core/network/rpc"`; `await rpc("/my/route", params)`), not a service. (verify in 18.0 docs)
- Registries: `registry.category("actions" | "fields" | "views" | "services" | "main_components" | "public_components" | "systray" | "user_menuitems" | "web_tour.tours" | "formatters" | "parsers").add(key, value, {sequence, force})`.
- Field widget skeleton:
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
- Module headers: `/** @odoo-module **/` was the marker for ES-module conversion; in 18 files under `static/src` are processed as ES modules natively and the header is no longer required but harmless. (verify in 18.0 docs: https://www.odoo.com/documentation/18.0/developer/reference/frontend/javascript_modules.html)
- Patching: `import { patch } from "@web/core/utils/patch"; patch(Target.prototype, { method() { super.method(...arguments); } });` — keep patches minimal, call `super`, patch the class/prototype (`patch(X.prototype, {...})`), not instances.
- Props validation: define `static props`; mark optional with `?`; avoid `props: ["*"]` outside generic wrappers.
- Avoid direct DOM mutation and jQuery in new code; use `t-ref` + hooks. Legacy `web.Widget`/`publicWidget` still exist for website; new public-website JS uses the `Interaction` framework introduced in 18 (`public.interactions` registry; verify in 18.0 docs: https://www.odoo.com/documentation/18.0/developer/reference/frontend.html).

## Assets
Manifest: 
```python
'assets': {
  'web.assets_backend': ['my_module/static/src/**/*'],
  'web.assets_frontend': [...],
  'web.assets_tests': ['my_module/static/tests/tours/**/*'],
  'web.assets_unit_tests': ['my_module/static/tests/**/*.test.js'],
}
```
Directives: `('include', 'web._assets_helpers')`, `('prepend', ...)`, `('after', target, new)`, `('remove', path)`, `('replace', target, new)`. Hoot tests go in `web.assets_unit_tests` (legacy QUnit used `web.qunit_suite_tests`; verify bundle names in 18.0). Docs: https://www.odoo.com/documentation/18.0/developer/reference/frontend/assets.html

## Frontend tests
JS unit tests with Hoot (`@odoo/hoot`) in `static/tests/**/*.test.js` (QUnit is retired for new tests); tours in `web_tour.tours` registry run from Python via `self.start_tour(url, name, login=)`. Docs: https://www.odoo.com/documentation/18.0/developer/reference/frontend/unit_testing.html (verify path in 18.0).
