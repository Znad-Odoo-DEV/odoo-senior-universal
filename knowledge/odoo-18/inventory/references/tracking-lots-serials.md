# Tracking: lots, serials, expiration

Docs (confirmed): tracking https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/product_management/product_tracking.html ; serial https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/product_management/product_tracking/serial_numbers.html ; lots https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/product_management/product_tracking/lots.html ; reassign https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/product_management/product_tracking/reassign.html ; expiration https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/product_management/product_tracking/expiration_dates.html ; valuation by lots https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/inventory_valuation/valuation_by_lots.html ; packages https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/product_management/configure/package.html ; product type https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/product_management/configure/type.html

## Setup
- Product (Goods, Track Inventory on): track by Serial Number, Lot, or none. Setting names for lots/serials in 18: verify in 18.0 docs (product_tracking page).
- Serial = one unit per number, unique per product; lot = batch sharing a number.
- Operation type options: create new vs use existing lots; receipts create, deliveries use existing.
- Stock existing before enabling tracking has no lot: assign via inventory adjustment.

## Operations
- Receipt: enter or generate numbers (first serial + count), import, print labels.
- Delivery: reservation picks lots by removal strategy; entered lots are validated.
- Traceability: lot/serial form and traceability view (upstream/downstream) for recalls.
- Reassign lot/serial numbers: follow the reassign page, never DB edits.
- Expiration dates: needs the Expiration Dates setting; product times (expiration, best before, removal, alert) compute lot dates at creation. Use FEFO to pick earliest expiry. Blocking expired lots: verify in 18.0 docs (expiration_dates page).

## Packages (not lots)
- Packages group products physically (pallet/box); package types hold dimensions/weight; pack-in-pack nests them (https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/product_management/configure/pack_in_pack.html). "Put in Pack" on pickings.

## Valuation
- Valuation by lot/serial lets FIFO/AVCO value each unit at its own cost (valuation_by_lots page; confirm the feature and its product flag exist in your 18.0 build: verify in 18.0 docs); see valuation.md.

## Practice
- Lot for batch/expiry goods; serial only for high-value/warranty items.
- Name convention: no free-text variants; unique per product.
- Scan, do not type.
