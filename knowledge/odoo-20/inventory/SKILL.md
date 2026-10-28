---
name: inventory
description: Senior Odoo 20 Inventory/WMS expertise. Use for Odoo 20 Inventory — warehouses and locations, operation types, routes (push/pull), replenishment and reordering, batch/wave picking, lots/serial tracking, inventory valuation, barcode, and inventory analytics.
---
# Odoo 20 Inventory / WMS (senior)

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
13. Barcode: scanning relies on product/location/lot/package barcodes and operation-type barcode behavior; clean master barcodes first (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/barcode.html).
14. Batch and wave picking are core in 20: the `stock_picking_batch` module is merged into `stock`, so there is no separate Batch Transfers module to install. Use them only when volume justifies; see references/routes-operations.md. (confirmed: the 20.0 Inventory index lists Batch picking and Wave transfers under Shipping and receiving > Picking methods: https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/shipping_receiving/picking_methods/batch.html; the module merge itself is not stated in the docs reviewed)

## Odoo 20 changes that affect inventory (vs 19)
- `stock_picking_batch` is merged into `stock` (batch and wave transfers are core). Custom modules with `depends` on `stock_picking_batch` must depend on `stock` instead and re-point inherited models/views; whether any Settings toggle still gates the feature is not stated (the index only confirms the pages exist: the 20.0 Inventory index lists Batch picking and Wave transfers under Shipping and receiving > Picking methods: https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/shipping_receiving/picking_methods/batch.html; the module merge itself is not stated in the docs reviewed).
- `delivery_mondialrelay` is removed: the standard Mondial Relay carrier connector no longer exists. Plan another carrier/integration and clean up shipping methods and `depends` that used it. (verify alternatives in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory.html)
- Platform: ACLs and record rules are merged into `ir.access` (custom stock security moves to `ir.access.csv`, multi-company/warehouse row filters become the `domain` column); `_table_query` is removed, which affects custom SQL-view reports on stock models; tracking values are removed (messages generated on the fly).
- Release notes: https://www.odoo.com/odoo-20-release-notes

## Review checklist (auditing a setup)
- Product type Goods + Track Inventory on? Category costing method and accounts set?
- Warehouse steps match physical reality; unused steps disabled.
- No negative quants; no stale reserved moves; no waiting/draft backlog older than lead time.
- Reordering rules exist for stocked items; route and lead times sane; vendor lead time set.
- Lot/serial required only on intended operation types.
- Valuation total reconciles to the stock valuation account in accounting.
- Upgraded database: no custom module still depends on `stock_picking_batch` or `delivery_mondialrelay`; no shipping method left on Mondial Relay.

## Gotchas
- Changing costing method/category with stock on hand needs a revaluation plan; test in staging.
- Changing warehouse steps after activity regenerates routes; old pickings keep old flows.
- Dropship and MTO are routes on the product, not warehouse steps; they need a Buy/Manufacture/pull rule behind them.
- Archiving a location with stock is blocked; move stock first.
- Field and menu names shift between versions: confirm in the docs (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory.html).

## References
- references/warehouses-locations.md - warehouses, location types, putaway, storage categories, removal, adjustments
- references/routes-operations.md - operation types, push/pull, multi-step, MTO, dropship, reservation, batch/wave (core in 20), carriers
- references/replenishment.md - reordering rules, lead times, forecast, buy/manufacture, inter-warehouse
- references/tracking-lots-serials.md - lots, serials, expiration, reassign, valuation by lot
- references/valuation.md - costing methods, accounting link, landed costs, scrap, reconciliation
- references/analytics.md - stock, locations, moves history, forecast, dashboards
- Docs root (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory.html
