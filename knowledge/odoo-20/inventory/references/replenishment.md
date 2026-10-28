# Replenishment

Docs (ported from the 19.0 layout; verify in 20.0 docs): overview https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/warehouses_storage/replenishment.html ; reordering rules https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/warehouses_storage/replenishment/reordering_rules.html ; just in time https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/warehouses_storage/replenishment/just_in_time.html ; replenishment report https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/warehouses_storage/replenishment/report.html ; lead times https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/warehouses_storage/replenishment/lead_times.html ; inter-warehouse https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/warehouses_storage/replenishment/resupply_warehouses.html ; MTO https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/warehouses_storage/replenishment/mto.html ; forecasted https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/warehouses_storage/reporting/forecast.html

## Reordering rules (stock.warehouse.orderpoint)
- Per the 19.0 docs (re-check in 20.0 docs): Min = when forecasted stock falls below it a replenishment is created; Max = level replenished up to; Route sets the document (Buy -> RFQ, Manufacture -> MO). On Hand, Forecast, To Order are computed. Product must be Goods with Track Inventory; Buy needs a vendor; Manufacture needs a BoM. Create from the product smart button or Operations > Replenishment.
- Trigger Auto (scheduler creates orders) vs Manual (listed for a human to order). Manual for costly/review items; Auto for commodities.
- Multiple (round order qty), Preferred route, horizon/visibility days: behavior details (verify in 20.0 docs: reordering_rules and report pages).
- Forecast counts on hand + incoming - outgoing, so confirmed demand triggers early.
- Mass-edit min/max in the Replenishment list; "Order Once" for ad hoc.
- Scheduler/cron naming in 20 (verify in 20.0 docs: just_in_time page).

## Lead times
- Vendor lead time (vendor line), Days to Purchase, Manufacturing lead time, Customer lead time, security lead times. They shift scheduled dates back from the promise date (verify exact set in 20.0 docs: lead_times page).
- Fix lead times before blaming forecast.

## Buy / Manufacture
- Buy: vendor line on product (lowest sequence/price picked); draft RFQ grouped by vendor.
- Manufacture: BoM + route; components get their own rules for multi-level supply.
- MTO + Buy = purchase per sales order for special items.

## Inter-warehouse
- Warehouse "Resupply From" creates a route via a transit location; apply on product/category; a reordering rule in the receiving warehouse can use it.

## Practice
- Start with A-class items; review the Replenishment view weekly; max = min + one order cycle of demand.
- One rule per product+location; archive stale ones.
- Procurement exceptions (missing vendor/BoM) surface as errors/chatter: fix the data, not the rule.
