# Manufacturing Order Flow (Odoo 18)

One step: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/basic_setup/one_step_manufacturing.html
Two step: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/basic_setup/two_step_manufacturing.html
Three step: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/basic_setup/three_step_manufacturing.html
Costs: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/basic_setup/mo_costs.html
WIP: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/basic_setup/work_in_progress.html
Backorders: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/workflows/manufacturing_backorders.html
Scrap: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/workflows/scrap_manufacturing.html
Unbuild: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/workflows/unbuild_orders.html
Split/merge: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/workflows/split_merge.html
Lots/serials: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/workflows/manufacture_lots_serials.html
Delayed analytics: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/reporting/delayed.html

## Lifecycle
Draft > Confirmed (moves created, reservation) > In Progress > To Close > Done; Cancel before done.
- Created manually, from replenishment (MTO, reordering rule, MPS), or from a sales order through the Manufacture route.
- Components and work orders are copied from the BoM; component status follows the BoM readiness setting.

## Warehouse steps
- 1 step: components consumed directly from stock (no picking).
- 2 steps: Pick Components, then manufacture.
- 3 steps: pick components, manufacture, store finished product.
- "Replenish Scrapped Quantities" works only with 2 or 3 steps (confirmed).

## Components
- Editable on draft/confirmed MOs; changes regenerate moves. Flexible Consumption governs deviation from the BoM.
- Manual Consumption lines must be confirmed on the MO.
- Components can be added from Shop Floor.
- Tracked components and finished goods require lot/serial registration.

## Partial production and backorders (confirmed)
- Enter produced quantity, Validate, answer "Create Backorder" in the "less than initial demand" pop-up.
- Result: MO-001 (produced, closed) and MO-002 (remainder, open); repeatable on the backorder.
- In Shop Floor (needs Work Orders): Register Production with a lower quantity; a -002 card appears.

## Scrap (confirmed)
- Scrapped items go to Virtual Locations/Scrap; physical stock is untouched by the virtual move.
- Manufacturing app: components scrappable in Draft/Confirmed; finished products only when Done. Shop Floor: components only.
- Scraps smart button on the MO; all scraps at Inventory > Operations > Scrap.
- Scrap window source defaults to the warehouse pre-production location.

## Unbuild
- Reverses a done MO: components return to stock, finished goods leave (verify details such as lot handling in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/workflows/unbuild_orders.html).

## Split and merge
- Split an MO into several, or merge compatible MOs (verify rules in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/workflows/split_merge.html).

## Costs (confirmed)
- MO overview shows estimated (BoM based) vs real cost side by side; they match before work starts; MO cost updates to real after Produce All.
- Work center hourly rate and per-employee rate; real labor uses each employee's hourly cost.
- WIP accounting: verify in 18.0 docs (WIP page above).

## Senior checklist
- Decide backorder policy before go-live and train operators on it.
- Use Produce All only when quantities truly match; otherwise register through work orders.
- Review delayed MOs weekly.
- Reconcile WIP and scrap accounts at period end.
