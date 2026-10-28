# Warehouses and locations

Docs (verify paths in 17.0 docs): warehouses https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/warehouses_storage/inventory_management/warehouses.html ; locations https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/warehouses_storage/inventory_management/use_locations.html ; putaway https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/shipping_receiving/daily_operations/putaway.html ; storage categories https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/shipping_receiving/daily_operations/storage_category.html ; removal strategies https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/shipping_receiving/removal_strategies.html ; adjustments https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/warehouses_storage/inventory_management/count_products.html ; cycle counts https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/warehouses_storage/inventory_management/cycle_counts.html ; scrap https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/warehouses_storage/inventory_management/scrap_inventory.html ; reception report https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/warehouses_storage/inventory_management/reception_report.html

## Warehouse
- Fields: name, short name (prefix of location names), company, address. Each warehouse gets a view location with Stock, Input, Output, Packing, Quality children as steps require.
- Warehouse Configuration tab: Incoming Shipments (1/2/3 steps), Outgoing Shipments (1/2/3 steps), Resupply From. Multi-step needs "Multi-Step Routes" in Inventory settings.
- One warehouse per physical site/legal need; use locations for shelves and zones.

## Locations (need "Storage Locations" setting)
- Types: Internal (counted as stock), Vendor, Customer, Inventory loss, Production, Transit, View (container only).
- Only Internal locations are on-hand stock. Mark scrap places with the Scrap flag.
- Hierarchy via parent: WH/Stock/Aisle-A/Shelf-1. Barcode on locations for scanning.
- Notable fields: Company, Storage Category, Cyclic Inventory frequency, Removal Strategy override (verify in 17.0 docs: use_locations page).
- Archive a location only when empty.

## Putaway and storage categories
- Putaway rule: product/category (optionally package type) arriving at a location is routed to a sublocation. Product rules beat category rules; sequence orders them.
- Storage category: capacity by product, package type or quantity; "Allow New Product" policy. Putaway respects capacity and falls to the next rule.
- Pair with 2-step receipt (Input -> Stock) so putaway applies on the storage transfer.

## Removal strategies (pick logic, not costing)
- FIFO, LIFO, FEFO (needs expiration dates), Closest Location; Least Packages only if your build has it (verify in 17.0 docs: removal_strategies page). Set on product category or location. Valuation is separate.

## Counting
- Inventory adjustments (Operations > Physical Inventory): Counted vs On Hand, Apply creates moves against the Inventory loss location.
- Cycle counts: scheduled per location by frequency; prefer over annual full counts.
- Scrap: moves to a Scrap location; account mapping in valuation.md.
- Reception report: assigns incoming goods to waiting outgoing moves.
