# Fields, models, apps (Studio, Odoo 20)
Docs (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/studio/fields.html , https://www.odoo.com/documentation/20.0/applications/studio/models_modules_apps.html

## Fields
- Fields are model columns; the widget controls display/format. Studio offers 21 field types over 15 technical types (some repeat with different default widgets). Counts are as documented for 19.0; verify in 20.0 docs: fields.html.
- Studio fields are stored columns (technical names `x_studio_*`), present on **every record** of the model. **Property fields** are pseudo-fields scoped to a parent record (e.g., tasks of one project), not columns.
- Studio can add fields, add existing fields to views, edit properties, remove fields from views (removing from a view does not delete the field).
- Relational types: Many2One, One2Many, Lines (one2many), Many2Many, Tags (many2many), Related Field (related). Prefer Related fields over duplicating data.
- Property details (required, readonly, invisible, default, domain, help, groups): (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/studio/fields.html)
- Related fields pointing at models/fields from modules removed or merged in 20 (see SKILL.md) break the view on upgrade; re-point or drop them before migrating.

## Widgets (as documented for 19.0; verify in 20.0 docs: fields.html)
- Text/char: Badge (read-only), Copy to Clipboard, E-mail, Image (URL only, nothing stored; saves disk), Phone (Enable SMS option), URL.
- Multiline Text: Copy to Clipboard. Html: default HTML editor; Multiline Text widget edits raw HTML.
- Integer: Percentage Pie, Progress Bar (computed/read-only use), Handle (drag reorder in list).
- Decimal: Monetary (prefer Monetary type), Percentage, Percentage Pie, Progress Bar, Time (hh:mm). Shows 2 decimals, stores more.
- Monetary: needs a Currency field on the model (Studio prompts to add it).
- Date: Remaining Days (should be read-only). Date & Time defaults to current user time.
- Date Range: needs a Date & Time field using the widget plus a start/end Date field; hide the underlying field to avoid duplication.
- Read-only display widgets need a default or computed source; users cannot edit them.
- Use an Image field (not Text + Image widget) when the image must be stored in Odoo.

## Models, apps, menus
- A model is a DB table for a business concept; apps are modules. New app/model creation offers up to 14 **suggested features** (preset fields/views): Contact details (map), User assignment, Date & Calendar, Date range & Gantt, Pipeline stages (kanban, default stages New/In Progress/Done), Tags, Picture, Lines, Notes, Monetary value (graph/pivot, hidden currency), Company (multi-company), Custom Sorting, Chatter, Archiving.
- Most can be added later; Pipeline stages, Picture, Chatter added later have varying effects, so tick them at creation when sure.
- Menu creation steps and cautions: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/studio/models_modules_apps.html)
- Create a new model only when no standard model fits; adding fields to existing models (partner, task) keeps standard reporting, security and chatter.
- Access to a new Studio model is stored as access records; in 20 these are `ir.access` rows (ACLs and record rules merged), not `ir.model.access` + `ir.rule`. Group permissions set in Studio's security UI: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/studio/models_modules_apps.html).

## Export / import
- Studio keeps customizations in a `studio_customization` module it builds. Studio menu > Export downloads a ZIP; per-model options: Demo, Attachments, Updatable, plus an editable domain filtering exported records.
- The ZIP imports into another database; Studio's import orders records logically (customers before sales orders), unlike standard data import.
- Test import on a duplicate before production. An export taken on 19 should be imported on 20 only after an upgrade test; exports contain records of the source version's security model (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/studio.html).
