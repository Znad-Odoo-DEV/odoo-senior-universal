# Views and UI (Studio, Odoo 20)
Docs (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/studio/views.html

## View types
- General: Form, Activity (XML-only editing), Search (filters, autocompletion fields on top of other views).
- Multiple records: Kanban (mobile default if present), List, Map.
- Timeline: Calendar, Cohort, Gantt. Reporting: Pivot, Graph. (Gantt/Pivot/Graph option details: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/studio/views.html)
- The list view root is `<list>` (not `<tree>`), the kanban card template is `t-name="card"`, and `<chatter/>` replaces the old chatter div; these carry over from 19 to 20. Conditional visibility is expressed directly with `invisible`/`readonly`/`required` attributes (no `attrs`/`states`).

## Editing
- Drag-and-drop from "+ Add"; Tabs and Columns structure forms. Set model default view via ellipsis > Set as Default.
- Toggles: Can Create / Edit / Delete / Duplicate restrict users on a view.
- Buttons: run a server action or call an existing Python method. Style in Properties: `btn-primary` (main action) or `btn-secondary` (alternative).
- Smart buttons: icon + related field.
- Conditional visibility, group-based visibility, view reset/restore: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/studio/views.html)

## View-specific options
- Kanban: Quick Create, Default Group By.
- List: When Creating Record behavior, Mass Editing, Sort By, Default Group By, buttons, fixed column width (px), drag reorder via Integer field with Handle widget.
- Map: needs Many2One to Contact; Contact Field, Hide Name/Address, Additional Fields, Enable Routing (needs Mapbox token).
- Calendar: Quick Create (only models accepting name-only records), Color, whole-day Checkbox, Default Display Mode (Day/Week/Month/Year), Delay Field (ignored if End Date Field set).
- Timeline views: need Date/Datetime start and stop fields, changeable later.
- Cohort: Measure Field, Interval, Mode.
- Search: Custom Filters grouped with Separators; Autocompletion Fields.
- Code behind Graph/Pivot data (custom Python, Execute Code) that calls `read_group` must use the 20 signature `(domain, groupby, aggregates, having, offset, limit, order)`; old `fields=`/`lazy=` calls break. How Studio-built Graph/Pivot views behave on upgrade: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/studio/views.html).

## XML editor (developer mode)
Enable developer mode, open view, View tab, click `</> XML`.
Caution: do **not** edit standard or inherited views directly there; changes are reset on updates/upgrades. Use the Studio-created inherited view and its XPath.

## Practice
- Anchor XPaths on field names, not positions, so upgrades do not break them.
- After adding a field to the form, add it to list/search/kanban only where users need it.
- Check mobile when kanban is the default view there.
- After upgrading to 20, open each Studio-modified view: XPath anchors on fields of removed/merged modules fail, and standard views of changed apps (Accounting, Expenses, Payroll) differ from 19.
