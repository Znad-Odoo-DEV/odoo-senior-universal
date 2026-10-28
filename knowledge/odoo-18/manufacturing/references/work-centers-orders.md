# Work Centers, Work Orders, Shop Floor (Odoo 18)

Work centers: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/advanced_configuration/using_work_centers.html
Dependencies: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/advanced_configuration/work_order_dependencies.html
Time off: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/workflows/work_center_time_off.html
Shop Floor: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/shop_floor/shop_floor_overview.html
Tracking: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/shop_floor/shop_floor_tracking.html
OEE: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/reporting/oee.html
Production analytics: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/reporting/production_analysis.html

## Prerequisite
Settings > Manufacturing > Operations > Work Orders. Without it, BoM operations are unavailable and MOs have no work orders.

## Work center fields (confirmed)
- Name, Tag, Code, Company, Alternative Work Centers (fallback when unavailable).
- Working Hours: one- or two-week calendar, default 40h week; also the basis for OEE.
- Time Efficiency %: speed multiplier (50% = takes twice as long).
- OEE Target: target efficiency (expected use vs available time).
- Setup Time / Cleanup Time: before and after a work order.
- Cost per hour: work center rate; per-employee value estimates average employee cost.
- Expense Account: used when the MO is done; falls back to the product's expense account.
- Allowed Employees: blank = everyone.
- Product Capacities tab: units producible at once per product, with setup/cleanup per product.
- IoT Triggers: device, security key, action.

## Scheduling logic
- Duration = default duration (or tracked/last-N average) adjusted by time efficiency, plus setup and cleanup; capacity determines cycles for large quantities.
- Work orders are placed on the work center calendar; time off removes capacity; alternatives cover unavailability.
- Planning view for work centers (Gantt) allows rescheduling (verify menu path in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing.html).

## Work order dependencies
- Operations can be sequenced (blocked by a previous operation); otherwise they may run in parallel (verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/advanced_configuration/work_order_dependencies.html).

## Costing link (confirmed)
- Estimated cost: BoM duration x work center rate. Real cost: tracked time x work center rate, labor valued at each employee's hourly cost.
- If the work center's per-employee rate differs from real employee cost, estimated and actual differ.

## Shop Floor (confirmed)
- Open from the dashboard or the MO's Shop Floor smart button. First use: Activate your Work Centers for the workstation.
- Views: Overview (MOs ready, filter MO Ready), My WO (active employee), one per work center.
- Operator panel: employees sign in; time tracked per employee.
- Flow: work orders in sequence; Register Production for lot/serial; Close Production, or Quality Checks if required.
- Options menu: scrap components, add work order, add component, add by-product, open MO, log note.
- Installable as a Chrome app to restrict workstation access.
- Backorders: Register Production below the total; avoid the "# Units" button (registers the full amount).

## Senior checklist
- Model real working hours and time off before trusting dates.
- Use Product Capacities when batch size varies by product.
- Attach quality control points to operations for instructions and checks.
- One work center per physical constraint (bottleneck), not per product.
- Review OEE and production analytics for continuous improvement.
