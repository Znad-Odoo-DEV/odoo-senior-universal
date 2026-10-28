# Planning: MPS, Scheduling, Replenishment (Odoo 17)

MPS: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/manufacturing/workflows/use_mps.html
Delayed analytics: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/manufacturing/reporting/delayed.html
Allocation analytics: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/manufacturing/reporting/allocation.html
Production analytics: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/manufacturing/reporting/production_analysis.html

## MPS (Enterprise; verify row labels in 17.0)
- Enable: Manufacturing > Configuration > Settings > Planning > Master Production Schedule. Then set Default Time Range (yearly/monthly/weekly/daily) and Number of Periods.
- Rows per product and period: Starting stock (links to forecast), Forecasted Demand (manual), Indirect Demand Forecast (components only, from MOs), Replenishment (suggested, editable), Forecasted Stock.
- Forecasted Stock = Starting Stock - Forecasted Demand - Indirect Demand + Replenishment; ending stock rolls into the next period.
- Actual Demand option shows confirmed sales orders beside the forecast.
- Safety stock and per-product min/max drive suggested replenishment.
- Add a Product: needs the Manufacture or Buy route; purchased products need a vendor pricelist; BoM, route, vendor and indirect demand option can be set.
- The Order button replenishes the shown value. Adding a product does not create orders by itself.
- Do not apply reordering rules to MPS products (inaccurate forecast, spurious orders).
- Manually edited replenishment cells are highlighted with a reset option.

## Scheduling
- MO dates derive from BoM manufacturing lead time, operation durations, work center calendars and capacity (verify exact scheduling rules in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/manufacturing.html).
- Days to prepare MO pulls the start earlier so components can be procured (verify the field exists in 17.0).
- Vendor lead times on buy components set PO dates; missing lead times produce late MOs.

## Replenishment link
- Manufacture route with MTO or a reordering rule creates MOs from demand; Buy route creates RFQs.
- Choose per product: reordering rule (min/max, continuous) or MPS (forecast-driven, periodic), never both.
- Sub-assemblies: child MOs appear when parent MOs confirm and stock is short.

## Analytics
- Production analysis and OEE are long-standing Enterprise reporting; the Delayed (late MOs/work orders) and Allocation (demand vs supply) pages are listed in the 19.0 docs, so verify they exist in 17.0 before pointing users to them.
- Feed results into the next MPS cycle: compare forecast to actual demand, adjust safety stock.

## Senior checklist
- Pick a period granularity matching production cycles (weekly for most discrete manufacturing).
- Calibrate safety stock to real lead-time variability.
- Review MPS weekly and convert suggestions into orders in batches.
- Keep BoM lead times, work center calendars and vendor lead times current; otherwise MPS is cosmetic.
