---
name: inventory
description: Senior Odoo 19 Inventory/WMS expertise. Use for Odoo 19 Inventory — warehouses and locations, operation types, routes (push/pull), replenishment and reordering, lots/serial tracking, inventory valuation, barcode, and inventory analytics.
---
# Odoo 19 Inventory / WMS (senior)

## Mindset
- Stock must be accurate first: every quantity change is a stock.move (done moves are the truth). Never "fix" quants by SQL; use adjustments, scrap, or a correcting transfer.
- Valuation ties to accounting: costing method + accounting method (periodic/perpetual) + category accounts decide the journal entries. Decide before the first receipt.
- Lean routes: use the warehouse step settings (1/2/3 steps) and standard routes; add custom routes/rules only for a real flow gap. Fewer rules = fewer stuck moves.
- Replenish by exception: reordering rules + lead times + forecast, not manual buying.

## Principles
1. Model the physical layout once: warehouse -> view location -> internal locations (Storage Locations setting). Do not encode status (quality/damaged) as product variants.
2. Warehouse steps drive routes: set Incoming/Outgoing shipments on the warehouse; do not hand-edit generated rules for 1/2/3-step flows.
3. Every flow is an operation type (receipt, internal, pick, pack, delivery, manufacturing) with default locations, sequence prefix, reservation and lot behavior.
4. Pull rules say "how to get product here"; push rules say "where to send it next after arrival". Prefer pull; use push for post-arrival chains.
5. Putaway rules (and storage categories/capacity) decide the final internal location; removal strategies (FIFO/LIFO/FEFO/closest/least packages) decide what is picked. Neither is valuation.
6. Track only what the business needs: lots/serials add scan and data burden. Serial = 1 unit, lot = batch. Enable expiration only where FEFO matters.
7. Reservation method (at confirmation / manual / before scheduled date) is a per-operation-type policy; match it to order-promising needs.
8. Reordering rules need a vendor (Buy) or BoM (Manufacture); min/max compare against forecasted stock, so confirmed demand counts.
9. Landed costs affect valuation for FIFO/AVCO; validate on a test product first.
10. Count with cycle counts/inventory adjustments; use scrap for losses, scrap location mapped to an expense account.
11. Analytics: use Stock, Locations, Moves History, Forecasted, Valuation views before building custom reports.
12. Multi-company/multi-warehouse: set the company on warehouses and locations; inter-warehouse resupply uses a route between warehouses.
13. Barcode: scanning relies on product/location/lot/package barcodes and operation-type barcode behavior; clean master barcodes first (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/barcode.html).

## Review checklist (auditing a setup)
- Product type Goods + Track Inventory on? Category costing method and accounts set?
- Warehouse steps match physical reality; unused steps disabled.
- No negative quants; no stale reserved moves; no waiting/draft backlog older than lead time.
- Reordering rules exist for stocked items; route and lead times sane; vendor lead time set.
- Lot/serial required only on intended operation types.
- Valuation total reconciles to the stock valuation account in accounting.

## Gotchas
- Changing costing method/category with stock on hand needs a revaluation plan; test in staging.
- Changing warehouse steps after activity regenerates routes; old pickings keep old flows.
- Dropship and MTO are routes on the product, not warehouse steps; they need a Buy/Manufacture/pull rule behind them.
- Archiving a location with stock is blocked; move stock first.
- Field and menu names shift between versions: confirm in the docs (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/inventory.html).

## References
- references/warehouses-locations.md - warehouses, location types, putaway, storage categories, removal, adjustments
- references/routes-operations.md - operation types, push/pull, multi-step, MTO, dropship, reservation, batch/wave
- references/replenishment.md - reordering rules, lead times, forecast, buy/manufacture, inter-warehouse
- references/tracking-lots-serials.md - lots, serials, expiration, reassign, valuation by lot
- references/valuation.md - costing methods, accounting link, landed costs, scrap, reconciliation
- references/analytics.md - stock, locations, moves history, forecast, dashboards
- Docs root (confirmed): https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/inventory.html
