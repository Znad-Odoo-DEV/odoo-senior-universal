# Timesheets (Odoo 17)

Sources (19.0 layout, version swapped; verify paths in 17.0): https://www.odoo.com/documentation/17.0/applications/services/timesheets.html ; https://www.odoo.com/documentation/17.0/applications/services/timesheets.html ; https://www.odoo.com/documentation/17.0/applications/services/timesheets.html ; https://www.odoo.com/documentation/17.0/applications/sales/sales/invoicing/time_materials.html

## Configuration
- Users must be employees (https://www.odoo.com/documentation/17.0/applications/hr/employees/new_employee.html).
- Access: Settings > Users & Companies > Users > Services section: No access, User (own timesheets), User (all timesheets), Administrator (also the Timesheets Configuration menu). General: https://www.odoo.com/documentation/17.0/applications/general/users/access_rights.html
- Time can only be logged on projects with Timesheets enabled in project settings.
- Encoding method (hours vs days) is set in Timesheets settings; it drives targets and dashboard units.

## Logging
1. Timer (start/stop; optional project, task, description).
2. Manual: grid cells or Add a line (can include Sales Order Item on billable projects).
3. From a task (Timesheets tab > Add a line: Date, Employee, Description, Hours Spent) or a Helpdesk ticket.
- My Timesheets grid (Enterprise): day/week/month; italic suggested entries; totals colored vs expected hours (green on target, orange/brown over, red under). Verify the grid behavior in 17.0.

## Billing link (time and materials)
- Product: Product Type Service; Invoicing Policy "Based on Timesheets"; Create on Order "Project & Task" (new project + task) or "Task" (existing project).
- Confirm SO > Tasks smart button > timesheets on task. Timesheets feed delivered quantity and the profitability panel (see profitability.md).
- Prepaid/fixed price/milestone policies, validated-timesheet rules, "Invoice time spent": not read in full (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/sales/sales/invoicing/time_materials.html).

## Billing rate indicators and leaderboard
- Timesheets > Configuration > Settings: enable Billing Rate Indicators, then Billing Rate Leaderboard (verify the exact settings and names in 17.0; leaderboard options differ across versions). Employee form > Settings tab: Monthly Billing Time Target (hours or days per encoding method). Leaderboard toggles Billing Rate vs Total Time; tips under Configuration > Tips.

## Time off
- Developer mode (verify if required); Timesheets > Configuration > Settings > Time Off section: enable Time Off; set Project (default Internal) and Task (default Time Off). Approved leave and public holidays create entries; types without validation create them immediately, others after approval.

## Approvals
- Timesheet validation (approving or locking entries before invoicing) comes from the Enterprise timesheet grid; the fetched pages do not describe the workflow (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/services/timesheets.html). The profitability docs do distinguish validated vs unvalidated timesheets for "To invoice".

## Pitfalls
- No employee record, or Timesheets switch off = cannot log. Billable time needs an SO item on the task. Time off entries land under Internal / Time Off and inflate internal totals unless filtered.
