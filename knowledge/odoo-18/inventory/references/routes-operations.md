# Operation types, routes, multi-step

Docs (confirmed): operation types https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/warehouses_storage/inventory_management/operation_type.html ; routes https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/shipping_receiving/daily_operations/use_routes.html ; one-step https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/shipping_receiving/daily_operations/receipts_delivery_one_step.html ; two-step https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/shipping_receiving/daily_operations/receipts_delivery_two_steps.html ; three-step receipt https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/shipping_receiving/daily_operations/receipts_three_steps.html ; three-step delivery https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/shipping_receiving/daily_operations/delivery_three_steps.html ; MTO https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/warehouses_storage/replenishment/mto.html ; dropshipping https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/shipping_receiving/daily_operations/dropshipping.html ; reservation https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/shipping_receiving/reservation_methods.html ; batch https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/shipping_receiving/picking_methods/batch.html ; wave https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/shipping_receiving/picking_methods/wave.html ; cluster https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/shipping_receiving/picking_methods/cluster.html ; consignment https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/inventory/shipping_receiving/daily_operations/owned_stock.html

## Operation types (stock.picking.type)
- Type: Receipt, Delivery, Internal Transfer (Manufacturing etc. with MRP). Fields: default source/destination, sequence prefix, warehouse, company, barcode, reservation method, create/use existing lots, show detailed operations, return type.
- Warehouse steps create the types (Receipts, Storage, Quality Control, Pick, Pack, Delivery). Unused ones are archived.
- Add a custom type only for a distinct physical process needing its own sequence/defaults/kanban card.

## Routes
- Route = set of push/pull rules. Applicable on products, product categories, package types, shipping methods, sales order lines (confirmed on routes page); warehouse selectable.
- Standard routes come from warehouse steps; do not edit rules for 1/2/3-step flows (confirmed warning).
- Rule actions: Pull From, Push To, Pull & Push, Buy, Manufacture (verify in 18.0 docs: use_routes page). Rule fields include source/destination location, operation type, supply method (take from stock vs trigger another rule), lead time.
- Pull: demand at destination triggers moves backward (delivery -> pick -> stock). Push: a move arriving at the source auto-creates the follow-on move.
- A procurement group links the chained moves of one demand.

## Multi-step flows
- Receipt: 1 step (dock -> stock), 2 (Input -> Stock), 3 (Input -> Quality -> Stock). Delivery: 1 (Stock -> Customer), 2 (Pick -> Output -> Customer), 3 (Pick -> Pack -> Output).
- Use 2-step delivery to separate picking from shipping; 3-step only if packing is a distinct station.

## MTO and dropship
- MTO route: each demand creates its own supply instead of using stock; needs Buy/Manufacture/transfer rule behind it. The route may be archived by default: check (verify in 18.0 docs: mto page).
- Dropship: enable in settings; product route Dropship; confirming the SO creates a PO delivered vendor -> customer, bypassing own stock. Valuation timing: verify in 18.0 docs (dropshipping page).
- Consignment: owner on quants for vendor-owned stock; not valued as own inventory.

## Reservation and picking
- Reservation: at confirmation, manual, before scheduled date. Per operation type.
- Batch transfers (one picker, many pickings), wave transfers (group lines by zone/product), cluster picking (multi-order carts). Use only when volume justifies.
- Backorders on partial validate: Create Backorder or No Backorder (cancels remainder). Use No Backorder deliberately.
- Returns: Return button on a done picking creates the reverse transfer.
