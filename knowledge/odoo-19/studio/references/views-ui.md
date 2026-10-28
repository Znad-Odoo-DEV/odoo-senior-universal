# Views and UI (Studio, Odoo 19)
Docs: https://www.odoo.com/documentation/19.0/applications/studio/views.html

## View types
- General: Form, Activity (XML-only editing), Search (filters, autocompletion fields on top of other views).
- Multiple records: Kanban (mobile default if present), List, Map.
- Timeline: Calendar, Cohort, Gantt. Reporting: Pivot, Graph. (Gantt/Pivot/Graph option details: verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/studio/views.html)

## Editing
- Drag-and-drop from "+ Add"; Tabs and Columns structure forms. Set model default view via ellipsis > Set as Default.
- Toggles: Can Create / Edit / Delete / Duplicate restrict users on a view.
- Buttons: run a server action or call an existing Python method. Style in Properties: `btn-primary` (main action) or `btn-secondary` (alternative).
- Smart buttons: icon + related field.
- Conditional visibility, group-based visibility, view reset/restore: (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/studio/views.html)

## View-specific options
- Kanban: Quick Create, Default Group By.
- List: When Creating Record behavior, Mass Editing, Sort By, Default Group By, buttons, fixed column width (px), drag reorder via Integer field with Handle widget.
- Map: needs Many2One to Contact; Contact Field, Hide Name/Address, Additional Fields, Enable Routing (needs Mapbox token).
- Calendar: Quick Create (only models accepting name-only records), Color, whole-day Checkbox, Default Display Mode (Day/Week/Month/Year), Delay Field (ignored if End Date Field set).
- Timeline views: need Date/Datetime start and stop fields, changeable later.
- Cohort: Measure Field, Interval, Mode.
- Search: Custom Filters grouped with Separators; Autocompletion Fields.

## XML editor (developer mode)
Enable developer mode, open view, View tab, click `</> XML`.
Caution: do **not** edit standard or inherited views directly there; changes are reset on updates/upgrades. Use the Studio-generated inherited view and its XPath.

## Practice
- Anchor XPaths on field names, not positions, so upgrades do not break them.
- After adding a field to the form, add it to list/search/kanban only where users need it.
- Check mobile when kanban is the default view there.
