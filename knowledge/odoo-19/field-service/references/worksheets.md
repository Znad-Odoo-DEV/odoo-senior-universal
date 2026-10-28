# Worksheets

Source (confirmed): https://www.odoo.com/documentation/19.0/applications/services/field_service/worksheets.html

## Purpose
Structured onsite capture: instructions, to-do lists, checkboxes, bullets, blank fields, HTML, files, images, links. Templates make repeated services consistent.

## Setup (confirmed)
1. Field Service > Configuration > Settings: enable Worksheets, Save. This installs Studio (may affect price plan).
2. Field Service > Configuration > Worksheet Templates > New: name, Save, Design Template (opens Studio).
3. In Studio drag fields from the left column, reorder by dragging, click a field for properties, Close to exit.
4. On the task pick the Worksheet Template, Save. Default is "Default Worksheet". To change the default: hover the Project field on the task, internal link icon, Settings tab, Field service section.

## Onsite use (confirmed)
- Task > Worksheet smart button. Fields marked Required must be filled to save.
- After the first save the button reads "Worksheet Complete" even if optional fields are empty.

## Design advice
- Required only for data you cannot invoice or audit without (meter reading, serial number, before/after photo).
- Prefer selection/checkbox over text; images via image/binary fields; keep to about one screen.
- One template per service type (installation, maintenance, inspection), not one giant template.
- Templates are Studio-generated custom models with `x_` fields; for multi-environment rollout export the customisation or rebuild it in a module.
- Worksheet PDF sent to the customer and signature are not covered on the worksheets page; see mobile-workflow.md (verify in 19.0 docs).
