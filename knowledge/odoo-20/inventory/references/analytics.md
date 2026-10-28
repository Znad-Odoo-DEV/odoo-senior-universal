# Inventory analytics

Docs (ported from the 19.0 layout; verify in 20.0 docs): stock https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/warehouses_storage/reporting/stock.html ; locations https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/warehouses_storage/reporting/locations.html ; moves history https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/warehouses_storage/reporting/moves_history.html ; forecasted https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/warehouses_storage/reporting/forecast.html ; dashboards https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/warehouses_storage/reporting/dashboards.html ; replenishment https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/warehouses_storage/replenishment/report.html

- Stock: on hand, reserved, free, forecast per product; drill to quants/moves.
- Locations: quants per location/lot/package (needs Storage Locations); group by location for count prep.
- Moves History (stock.move.line done): every done movement with lot, package, locations; audit and traceability.
- Moves Analysis (stock.move): planned and done moves; backlog analysis.
- Forecasted: product Forecasted button; incoming, outgoing, projected balance by date; check promise dates.
- Valuation: Inventory > Reporting > Valuation (see valuation.md).
- Dashboards: Inventory overview cards per operation type (To Process, Waiting, Late, Backorders); work the day from it.
- KPIs: inventory accuracy, turnover, late transfer %, backorder rate, stockout rate, reservation fill rate.
- Custom views: pivot/graph on stock.move.line and stock.quant; filter on done state and company. Custom reports built on `_table_query` (SQL views) must be rewritten in 20 because `_table_query` is removed; grouped reads use the new public `read_group` signature `(domain, groupby, aggregates, having, offset, limit, order)` and old `fields=`/`lazy=` calls break.
