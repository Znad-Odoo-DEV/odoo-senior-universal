# Blanket orders and calls for tenders (Odoo 20)
Docs (ported from the 19.0 layout; verify in 20.0 docs):
- https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/purchase/manage_deals/blanket_orders.html
- https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/purchase/manage_deals/calls_for_tenders.html
Tender page tail (choosing lines, cancelling alternatives) not read.

## Enable
Purchase > Configuration > Settings > Orders > Purchase Agreements. Also enables alternative RFQs.

## Blanket order
Purchase > Orders > Purchase Agreements > New. For long-term recurring deliveries at agreed prices with flexible qty/timing.
- Header: Vendor, Buyer (default creator), Agreement Type = Blanket Order, Currency, Agreement Validity (blank = no expiry), Reference, Operation Type, Company.
- Lines: product, Quantity, Unit Price. Price does NOT auto-populate; unset = 0.
- Confirm: Draft -> Confirmed; lines stay editable afterward.
- New Quotation button pre-fills terms; linked RFQs under the RFQs/Orders smart button; the Ordered field accumulates quantities from linked orders.
- Replenishment: a confirmed agreement adds a vendor line (vendor, price, agreement) on each product's Purchase tab; reordering rules then use it for vendor/timing/price.

## Calls for tenders (alternative RFQs)
- RFQ > Alternatives tab > Create Alternative (choose vendor; Copy Products default on; vendor-specific values may need manual correction).
- Link to Existing RFQ attaches others; group by Vendor for long lists. Tab shows reference, vendor, total, status, expected arrival.
- Compare Product Lines: groups by product; Clear removes a line from the comparison.
- Choosing winners and cancelling losers: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/purchase/manage_deals/calls_for_tenders.html)

## Senior notes
- Agreement-injected vendor lines compete with manual vendor lines by sequence; keep one source of truth.
- Check agreement validity and Ordered vs agreed qty before RFQs overrun the commitment.
- Upgraded database: custom access rules on purchase agreements (buyer or company visibility) must be ported to `ir.access` (20 merges record rules into it).
