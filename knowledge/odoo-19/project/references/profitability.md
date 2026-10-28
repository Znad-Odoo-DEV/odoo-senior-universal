# Project profitability (Odoo 19)

Sources (confirmed): https://www.odoo.com/documentation/19.0/applications/services/project/project_management/project_profitability.html ; https://www.odoo.com/documentation/19.0/applications/services/project/project_management/project_dashboard.html ; https://www.odoo.com/documentation/19.0/applications/sales/sales/invoicing/time_materials.html

## Where
- Right side of the project dashboard (add via sliders icon in top bar) or from the card menu. Compares costs (employee time, materials, purchases, expenses, after-sales) with revenues.

## Columns
- Revenues: Expected (from SOs) -> To invoice (delivered: validated timesheet, completed delivery, manual delivered qty) -> Invoiced (invoice confirmed). Revenues split Sold / Delivered / Invoiced with line breakdown.
- Costs: Expected (POs) -> To bill -> Billed (vendor bill confirmed).

## Linking rule
- A record appears only if linked to BOTH the project and its analytic account. A timesheet appears in revenues (customer payment) and costs (employee wage).

## Revenue sources
- Timesheets (per product invoicing policy: Prepaid/Fixed Price, Based on Timesheets, Based on Milestones), Materials (SO product prices), Customer invoices, Subscriptions, Down payments, re-invoiced Expenses.

## Cost sources
- Timesheets (employee HR cost settings), Purchase orders (shown after the vendor bill is posted), Materials. Remaining cost lines and explicit margin display: not read (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/services/project/project_management/project_profitability.html).

## Dashboard indicators
- Smart buttons: Tasks (done/total), Timesheets (allocated vs logged, validated and not), Planned, Documents, Burndown Chart, Timesheets and Planning, linked SO/SO items/POs. Project updates = status snapshots (status options: verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/services/project/project_management/project_dashboard.html).

## Troubleshooting
1. Number missing: check project + analytic account on the record.
2. Revenue stuck in Expected: nothing delivered; check invoicing policy, delivered qty, timesheet validation, milestone Reached.
3. Cost wrong: check employee timesheet cost on the HR record; PO cost waits for the posted bill.
4. Billable task without SO item: time is not billed; set Sales Order Item on the task.

## Senior notes
- Choose invoicing policy per service deliberately: timesheets (T&M), milestones (fixed phases, Quantity %), prepaid/fixed. Profitability reflects that choice.
- Billable projects carry Customer and SO item; internal projects should not.
