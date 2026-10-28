# Time, products and billing: Project / Sales / Inventory after Field Service

Field Service is discontinued in Odoo 20; its features moved into Planning. The billing chain was always built on sibling apps, so most of it carries over; the FSM-specific conveniences need checking. Docs: Timesheets https://www.odoo.com/documentation/20.0/applications/services/timesheets.html ; Sales invoicing https://www.odoo.com/documentation/20.0/applications/sales/sales/invoicing.html ; Planning https://www.odoo.com/documentation/20.0/applications/services/planning.html ; old page https://www.odoo.com/documentation/20.0/applications/services/field_service/product_management.html (verify in 20.0 docs; app discontinued).

## What it was in 17-19
- Field Service > Configuration > Settings: Time and Material Invoicing; Field Service > Configuration > Products catalog.
- Task > Products smart button: add materials with - and +; the sale order created from the intervention pulled products from the user's default warehouse (needs storage locations and more than one warehouse); marking the task done updated that stock; products on the task flowed to the invoice.
- Time via timesheets on the task (timer or manual); billable time reached the SO line when the project was billable and the service product was invoiced on timesheets.

## Mapping to 20
| Old behaviour | 20 equivalent | Status |
|---|---|---|
| Time and Material Invoicing setting | Service product invoicing policy (delivered quantities / timesheets) in Sales + billable project | Carried over from 19; verify in 20.0 docs: invoicing.html |
| Timesheets on the task, timer | Timesheets app on the task or shift | Carried over from 19; verify in 20.0 docs: timesheets.html |
| Fixed price | Invoice on order or milestone; timesheets track cost only | Carried over from 19; verify in 20.0 docs |
| Materials via task Products catalog | Add storable products to the linked sale order; deliver through Inventory | Native task catalog in Planning/Project: verify in 20.0 docs |
| Default warehouse per user drives stock | Same Inventory feature (user Preferences > Default Warehouse); SO > Other Info > Delivery shows the source | Verify in 20.0 docs |
| Done task triggers stock update | Delivery order validation in Inventory (batch and wave picking are core `stock` in 20) | Verify in 20.0 docs whether task completion still triggers it |
| Onsite upsell quotation | Extra quotation from the order | Verify in 20.0 docs |

## Migration steps
1. Record the billing basis per service product and per project before the upgrade: time and materials, fixed price, or mixed.
2. Check the product configuration that survives: invoicing policy, service tracking, Unit of Measure, project billing type.
3. Invoice everything completed on the source; do not carry half-invoiced interventions across the upgrade.
4. On the upgraded copy run one intervention: order -> task/shift -> timesheet -> materials -> delivery -> invoice. Inspect invoice lines against the same case on 19.
5. If the task-level materials catalog is absent in 20, define the replacement: salesperson/dispatcher adds product lines to the order, or technician requests materials via a note/activity, then deliver and invoice from the order.
6. Re-set default warehouses for technician users; test stock moves with a restricted-rights user.
7. Accounting 20 side effects: invoice payment statuses are renamed; bank-impacting journal entries must come from bank transactions; expenses become draft vendor bills (relevant to technician expense claims). Update reports and filters accordingly (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting.html).
8. Custom billing code or reports: public `read_group(domain, groupby, aggregates, having, offset, limit, order)`; `fields=`/`lazy=` calls break; `_table_query` removed.

## Pitfalls
- Time on a non-billable project, or employee without cost/rate: no revenue or cost.
- Materials added after the order was invoiced create new lines; invoice again.
- Technician on the wrong warehouse draws stock from the wrong place.
- Mixing fixed price and time-and-materials silently double-bills or under-bills; set the policy per product again after the move.
- Assuming the 19 "Products" smart button exists on the 20 task without checking.
