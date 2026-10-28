# Onsite / mobile workflow after Field Service

Field Service is discontinued in Odoo 20; its features moved into Planning. This file maps the technician's day. Which of the old onsite buttons exist in 20 is not established here (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/services/planning.html). Old page: https://www.odoo.com/documentation/20.0/applications/services/field_service.html (verify in 20.0 docs; app discontinued). Odoo tutorial: https://www.odoo.com/slides/field-service-49 (describes the discontinued app; verify in 20.0 docs).

## The technician day in 17-19
1. My Tasks > Map (Today filter): stops in Planned Date order.
2. Navigate to / View in Google Maps from the current location.
3. Open the task: customer, description, worksheet template.
4. Start the task timer (timesheets).
5. Fill the worksheet (Required fields first); first save turns the button into "Worksheet Complete".
6. Add materials with the Products smart button (+/-).
7. Customer sign-off and sending the worksheet.
8. Stop the timer, mark done (updates default-warehouse stock); office invoices.

## Mapping each step to 20
| Step | 20 equivalent | Status |
|---|---|---|
| Daily list in planned order | Planning shift view for the employee / assigned tasks | Verify in 20.0 docs: planning.html |
| Map and navigation | Unknown native equivalent; customer address still required | Verify in 20.0 docs |
| Timer and time entry | Timesheets timer on task/shift | Carried over from 19; verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/services/timesheets.html |
| Worksheet | See worksheets.md | Verify in 20.0 docs |
| Materials | See time-products-billing.md | Verify in 20.0 docs |
| Customer sign-off and PDF | Unknown native equivalent | Verify in 20.0 docs |
| Mark done, stock, invoice | Task stage + Inventory delivery + Sales invoicing | Verify in 20.0 docs |

## Design for field use (still valid)
- Use the Odoo mobile app or the browser on the phone; saving needs connectivity, so keep forms small and save often.
- Give technicians the least rights that cover their work; dispatch and billing stay with managers. Groups use `group_ids` and `res.groups.privilege`; row filtering is an `ir.access` rule in 20.
- Photos in image fields rather than chatter attachments, for traceability.
- Keep stages simple (planned, in progress, done); mark done only after the capture and sign-off steps are complete.

## Migration steps
1. Document the exact current technician routine (screens, buttons, sign-off, photos) from the 19 database or from a technician shadow session.
2. On the upgraded copy walk the same routine with a technician-rights user on a real phone with poor signal; list every missing step.
3. For each gap pick: native Planning option found in 20.0 docs, Project/Sales/Timesheets workaround, Studio or custom module, or process change (e.g. paper sign-off scanned to the task).
4. Rewrite the technician cheat sheet and train dispatchers and technicians on the Planning flow before cut-over.
5. Pilot with a few technicians, keep the 19 database read-only as a reference until the pilot is accepted.

## Troubleshooting
- Task or shift missing from the day view: assignee, dates or customer address missing, or a default filter hides it.
- No route line: map/routing token not configured, if a map exists in 20 (verify in 20.0 docs).
- Stock unchanged after done: user has no default warehouse, product not stock-tracked, or the delivery order was not validated.
- Access errors for technicians after upgrade: custom models lack `ir.access` rows (security files must be rewritten as `ir.access.csv` for 20).
