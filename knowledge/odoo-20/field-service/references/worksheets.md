# Worksheets: what replaces them after Field Service

Field Service is discontinued in Odoo 20; its features moved into Planning. Whether worksheets exist natively in Planning/Project in 20 is not established here (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/services/planning.html). Old page: https://www.odoo.com/documentation/20.0/applications/services/field_service/worksheets.html (verify in 20.0 docs; app discontinued).

## What worksheets were in 17-19
- Structured onsite capture: instructions, to-do lists, checkboxes, bullets, blank fields, HTML, files, images, links.
- Enabled in Field Service > Configuration > Settings (this installed Studio, which could change the price plan). Templates were designed in Studio and became custom models with `x_` fields (code knowledge; verify on the source instance).
- Task > Worksheet smart button; Required fields gated saving; the button read "Worksheet Complete" after the first save; a default template was set in the project settings.

## Decision tree for 20
1. Check the 20.0 Planning/Project docs and release notes for a native worksheet or form-on-task feature (verify in 20.0 docs: https://www.odoo.com/odoo-20-release-notes). If it covers the use case, rebuild templates there.
2. If not, choose per template:
   - Few fields, simple data: custom fields on the task via Studio (Custom plan; Studio skill in this repo) or checklist-style fields.
   - Rich forms, validation, PDF: a custom module (Python >= 3.12, security in `ir.access.csv` with columns `id,name,model_id,group_id/id,operation,domain`, manifest `20.0.x.y.z`).
   - Rarely used: retire and replace with a PDF/spreadsheet attached to the task.
3. Never leave the decision implicit: worksheet data is the part of FSM most likely to be orphaned by the upgrade.

## Migration steps
1. Inventory worksheet templates, their Studio models, fields, required flags and row counts per template.
2. Export all worksheet data (CSV per model) and the customer-facing PDFs before upgrading; store as an archive outside Odoo.
3. Upgrade a copy; check whether the Studio worksheet models and records are still reachable and where (verify in 20.0 docs). If they survive as plain Studio models, you can keep them with their own menu/view until replaced.
4. Rebuild one template at a time: one per service type (installation, maintenance, inspection), not one giant template. Required fields only for data you cannot invoice or audit without (meter reading, serial number, before/after photo).
5. Link the new form to the task/shift and to the invoice flow if the customer needs worksheet-to-invoice traceability.
6. Test as a technician on mobile: photos via image/binary fields, selection and checkbox over free text, about one screen.

## Open questions to settle (all verify in 20.0 docs)
- Native worksheet or form capability in Planning/Project.
- Sending a worksheet PDF to the customer and capturing a signature (the old docs did not cover these on the worksheets page either).
- Whether Studio is still required for templates and what that means for the plan.

## Pitfalls
- Worksheet data stored in Studio custom models is a database customisation, not module data; test it on the upgraded copy.
- Rebuilding fields with different technical names breaks old reports and exports.
- Forgetting access rules: new custom models need `ir.access` rows, otherwise technicians get access errors.
