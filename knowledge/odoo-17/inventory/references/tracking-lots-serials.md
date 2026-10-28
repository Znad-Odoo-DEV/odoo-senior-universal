# Tracking: lots, serials, expiration

Docs (verify paths in 17.0 docs): tracking https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/product_management/product_tracking.html ; serial https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/product_management/product_tracking/serial_numbers.html ; lots https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/product_management/product_tracking/lots.html ; reassign https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/product_management/product_tracking/reassign.html ; expiration https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/product_management/product_tracking/expiration_dates.html ; valuation by lots https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory.html ; packages https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/product_management/configure/package.html ; product type https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/product_management/configure/type.html

## Setup
- Product (Storable Product): Tracking = By Unique Serial Number, By Lots, or No Tracking; needs the Lots & Serial Numbers setting. Exact setting and field names in 17: verify in 17.0 docs (product_tracking page).
- Serial = one unit per number, unique per product; lot = batch sharing a number.
- Operation type options: create new vs use existing lots; receipts create, deliveries use existing.
- Stock existing before enabling tracking has no lot: assign via inventory adjustment.

## Operations
- Receipt: enter or generate numbers (first serial + count), import, print labels.
- Delivery: reservation picks lots by removal strategy; entered lots are validated.
- Traceability: lot/serial form and traceability view (upstream/downstream) for recalls.
- Reassign lot/serial numbers: follow the reassign page, never DB edits.
- Expiration dates: needs the Expiration Dates setting; product times (expiration, best before, removal, alert) compute lot dates at creation. Use FEFO to pick earliest expiry. Blocking expired lots: verify in 17.0 docs (expiration_dates page).

## Packages (not lots)
- Packages group products physically (pallet/box); package types hold dimensions/weight; pack-in-pack nests them (verify availability in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/product_management/configure.html). "Put in Pack" on pickings.

## Valuation
- Valuation by lot/serial (each unit at its own cost) is a later feature; on 17.0 FIFO/AVCO value by valuation layer, not by lot (valuation_by_lots page: verify in 17.0 docs); see valuation.md.

## Practice
- Lot for batch/expiry goods; serial only for high-value/warranty items.
- Name convention: no free-text variants; unique per product.
- Scan, do not type.
