# Procurement and reordering (Odoo 17)
Docs (verify path in 17.0 docs): https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/purchase/products/reordering.html
Temporary rules page exists but was not read (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/purchase/products/temporary_reordering.html).

## Prerequisites
Inventory app installed; product Purchase ticked (Can be Purchased), type Storable Product; Buy route and a vendor line.

## Rule fields
Location (where received qty lands), Min Quantity (below it -> replenish), Max Quantity (restore target), Multiple Quantity (batch rounding; can overshoot Max), Unit (UoM).

## Triggering
- Automatic: scheduler once daily by default.
- Manual: dev mode > Inventory > Operations > Run Scheduler (also fires other scheduled actions); exact menu label: (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/purchase/products/reordering.html).
- Output: RFQ with vendor, price, quantity needed.
- Manage: product Reordering Rules smart button, or in bulk at Inventory > Operations > Replenishment.

## Buy route and MTO link
Not covered on the reordering page. Working model: the Buy route makes purchasing a supply method; demand-driven (MTO) procurement creates the RFQ from the originating demand instead of min/max. Vendor and price on the generated RFQ come from the product vendor lines (by sequence and min qty) or an agreement-injected line (see agreements.md).
(verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/purchase/products/reordering.html and the Inventory routes/MTO pages)

## Senior notes
- No RFQ generated: Storable Product, Buy route on product/warehouse, vendor line, scheduler run, rule location/warehouse match.
- Overstock after replenishment usually = Multiple Quantity or vendor min_qty exceeding Max.
- Demand-based quantity suggestions (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/purchase/advanced.html)
