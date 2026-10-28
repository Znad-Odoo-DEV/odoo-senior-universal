# Views, QWeb, OWL (Odoo 17)

Docs: https://www.odoo.com/documentation/17.0/developer/reference/user_interface/view_architectures.html — https://www.odoo.com/documentation/17.0/developer/reference/frontend/owl_components.html

## Views: what is current
- Root tag for list views is `<tree>`; use `view_mode="tree,form"` in actions and `tree` as `ir.ui.view` `type`. (Odoo 18 renames `<tree>` to `<list>`; do not write `<list>` or `view_mode="list"` on 17.)
- `attrs=` and `states=` are gone (removed in 17, the headline view change). Use direct attributes with Python expressions evaluated on the record: `invisible="state != 'draft'"`, `readonly="state in ('done','cancel')"`, `required="type == 'x'"`, `column_invisible="parent.state == 'x'"` (list columns), `context`, `domain` (strings/Python), `options="{'no_create': True}"`. Buttons that used `states="draft"` become `invisible="state != 'draft'"`.
- Form: `<form>`, `<header>` (buttons + `statusbar` widget), `<sheet>`, `<group>`, `<notebook>/<page>`, `<field>`, `<button type="object|action" name=>`, `<div class="oe_button_box" name="button_box">` with `<button class="oe_stat_button">`. Chatter: `<div class="oe_chatter"><field name="message_follower_ids"/><field name="activity_ids"/><field name="message_ids"/></div>` (the single `<chatter/>` tag is Odoo 18+).
- List: `<tree editable="bottom|top" multi_edit="1" default_order= decoration-danger="..." sample="1">`, `<field widget=>`, `optional="show|hide"`, `<groupby>`, `<control><create/></control>`, `<header>` for bulk buttons.
- Search: `<search>` with `<field filter_domain>`, `<filter name domain>`, `<separator>`, `<group expand="0">` + `context="{'group_by': 'x'}"`, `<searchpanel>`.
- Others: `kanban` (QWeb templates, `<t t-name="kanban-box">` in 17; renamed `card` in 18), `pivot`, `graph`, `calendar`, `gantt` (ent), `cohort`/`map`/`activity`. Spreadsheet/dashboard are Enterprise. The `hierarchy` view is 18+.
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
- Add field to view only if it exists on the model (`depends`); a view error blocks module load. A leftover `attrs`/`states` in an inherited view is a load-time error on 17.

## Actions and menus
`ir.actions.act_window` (`res_model, view_mode, domain, context, search_view_id, help`), `ir.actions.server` (`state='code'`/`object_write`...), `ir.actions.client`, `ir.actions.act_url`. Menus: `<menuitem id parent action sequence groups>`. Return actions from Python as dicts (`{'type':'ir.actions.act_window', ...}`). Docs: https://www.odoo.com/documentation/17.0/developer/reference/backend/actions.html

## QWeb
Directives: `t-if/t-elif/t-else`, `t-foreach` (+ `_index/_first/_last`), `t-set`, `t-esc`/`t-out` (escape; `t-raw` is deprecated, use `t-out`), `t-att-*`, `t-attf-*`, `t-call`, `t-slot`, `t-inherit`, `t-model`. Server templates are `ir.ui.view` type `qweb`; client templates live in `static/src/**/*.xml` as `<templates xml:space="preserve"><t t-name="mod.Name">` (the `owl="1"` marker is not needed on 17). In Python, wrap trusted HTML with `markupsafe.Markup`; `Markup` + `%` escapes args. Docs: https://www.odoo.com/documentation/17.0/developer/reference/frontend/qweb.html

## OWL in Odoo 17
- Odoo 17 uses Owl 2.x (the legacy JS compatibility layer is gone from the backend; legacy `web.Widget`/`publicWidget` remain for website/public pages). Components are classes extending `Component` with `static template`, `static props`, `static components`, `setup()` hook.
- Hooks: `useState`, `useRef`, `onWillStart`, `onMounted`, `onWillUpdateProps`, `onWillUnmount`, `useEffect`, `useSubEnv`; Odoo hooks: `useService`, `useBus`, `useAutofocus`, `useChildRef`, `useForwardRefToParent`.
- Services via `useService("orm" | "action" | "dialog" | "notification" | "rpc" | "user" | "company" | "router")`. ORM calls: `await this.orm.searchRead(model, domain, fields, {limit})`, `.call(model, method, args, kwargs)`, `.read`, `.write`, `.create`, `.unlink`, `.webSearchRead`. `rpc` is a service on 17 (a plain `rpc` import is 18+).
- Registries: `registry.category("actions" | "fields" | "views" | "services" | "main_components" | "public_components" | "systray" | "user_menuitems" | "web_tour.tours" | "formatters" | "parsers").add(key, value, {sequence, force})`.
- Field widget skeleton:
```js
/** @odoo-module **/
import { registry } from "@web/core/registry";
import { Component } from "@odoo/owl";
import { standardFieldProps } from "@web/views/fields/standard_field_props";
export class MyField extends Component {
  static template = "my_module.MyField";
  static props = { ...standardFieldProps };
}
registry.category("fields").add("my_field", { component: MyField, supportedTypes: ["char"] });
```
- Module headers: `/** @odoo-module **/` is REQUIRED as the first line of every ES-module JS file under `static/src` on 17 (it triggers the module conversion); without it `import` fails. Odoo 18 makes it optional. (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/developer/reference/frontend/javascript_modules.html)
- Patching: `import { patch } from "@web/core/utils/patch"; patch(Target.prototype, { method() { super.method(...arguments); } });` — two-argument form (the 16 three-argument `patch(obj, "name", {...})` is gone). Keep patches minimal, call `super`, patch the class/prototype (`patch(X.prototype, {...})`), not instances.
- Props validation: define `static props`; mark optional with `?`; avoid `props: ["*"]` outside generic wrappers.
- Avoid direct DOM mutation and jQuery in new backend code; use `t-ref` + hooks.
- Website/public JS uses `publicWidget` (the `Interaction` framework is Odoo 18+):
```js
/** @odoo-module **/
import publicWidget from "@web/legacy/js/public/public_widget";
publicWidget.registry.MyWidget = publicWidget.Widget.extend({
  selector: ".o_my_widget",
  events: { "click .o_btn": "_onClick" },
  start() { return this._super(...arguments); },
  _onClick(ev) { /* ... */ },
});
```
  (verify the import path in your 17.0 source: addons/web/static/src/legacy/js/public/public_widget.js)

## Assets
Manifest: 
```python
'assets': {
  'web.assets_backend': ['my_module/static/src/**/*'],
  'web.assets_frontend': [...],
  'web.assets_tests': ['my_module/static/tests/tours/**/*'],
  'web.qunit_suite_tests': ['my_module/static/tests/**/*_tests.js'],
}
```
Directives: `('include', 'web._assets_helpers')`, `('prepend', ...)`, `('after', target, new)`, `('remove', path)`, `('replace', target, new)`. Docs: https://www.odoo.com/documentation/17.0/developer/reference/frontend/assets.html

## Frontend tests
JS unit tests use QUnit (Hoot is Odoo 18+): files in `static/tests/**/*.js` loaded via `web.qunit_suite_tests`, run in the browser at `/web/tests`. Minimal shape:
```js
/** @odoo-module **/
import { getFixture } from "@web/../tests/helpers/utils";
QUnit.module("my_module", () => {
  QUnit.test("it renders", async (assert) => {
    const target = getFixture();
    // mount the component / view under test into `target`, then:
    assert.strictEqual(target.querySelectorAll(".o_my_widget").length, 0);
  });
});
```
Helpers live in `@web/../tests/helpers/*` and `@web/../tests/views/helpers` (`makeView`, `setupViewRegistries`). (verify names in your 17.0 source)
Tours go in the `web_tour.tours` registry (`{test: true, url: "/web", steps: () => [...]}`) and run from Python via `self.start_tour(url, name, login=)`. Docs: https://www.odoo.com/documentation/17.0/developer/reference/frontend/unit_testing.html (verify path in 17.0).
