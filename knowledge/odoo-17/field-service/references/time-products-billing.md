# Time, products, invoicing

Sources: https://www.odoo.com/documentation/17.0/applications/services/field_service/product_management.html and https://www.odoo.com/documentation/17.0/applications/services/field_service/creating_tasks.html (verify both paths resolve in 17.0)

## Settings
- Field Service > Configuration > Settings: enable Time and Material Invoicing (the same switch may be labelled "Products on Tasks" in 17; verify in 17.0 docs).
- Products: Field Service > Configuration > Products (search; filter by Product Category and Attributes).

## Adding materials
Task > Products smart button > Add on a product card > adjust with - and +. The smart button shows count and price; reopen the catalog to change.

## Warehouse and stock
- Needs the Inventory storage locations feature and more than one warehouse.
- Default warehouse per user: profile > My Profile > Preferences > Default Warehouse; or Settings > Users > Manage users > Preferences tab > Inventory.
- The sales order created from the intervention pulls products from the user's default warehouse; check SO > Other Info > Delivery.
- Marking the task done updates the default warehouse stock.

## Invoicing (verify details in 17.0 docs)
- Products recorded on the task are added to the invoice automatically; inventory stays current in real time.
- The sale order is the invoicing document; the SO Tasks smart button opens the task.

## Time logging and billing basis (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/services/timesheets.html)
- Time goes through Timesheets on the task (timer or manual lines). Billable time reaches the SO line when the project is billable and the service product is invoiced on timesheets (delivered quantity follows timesheets).
- Fixed price: invoice on order (or milestone); timesheets only track cost.
- Time and materials: product policy based on timesheets; invoice delivered quantity.
- Exact invoice button on task vs SO: verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/sales/sales/invoicing.html

## Pitfalls
- Time on a non-billable project, or employee without cost/rate: no revenue or cost.
- Materials added after the SO was invoiced create new lines; invoice again.
- Technician on the wrong warehouse draws stock from the wrong place.
- Onsite upsell: extra quotation from the task if that setting exists (verify in 17.0 docs).
