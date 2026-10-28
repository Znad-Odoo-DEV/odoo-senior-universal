# Subcontracting (Odoo 18)

Basic: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/subcontracting/subcontracting_basic.html
Resupply: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/subcontracting/subcontracting_resupply.html
Dropship: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/subcontracting/subcontracting_dropship.html

## Basic subcontracting (confirmed)
- Product Purchase tab: add the subcontractor as vendor with price and lead time. Lead time covers subcontractor production and delivery; BoM lead time is not used.
- BoM type = Subcontracting; assign one or more subcontractors; leave Components empty (the subcontractor sources everything).
- Flow: confirm PO, receipt is created automatically, subcontractor delivers, validate the receipt.
- A dedicated Subcontracting location tracks the process; Production consumes and produces; validating the receipt moves goods into stock. Inspect under Inventory > Reporting > Moves History.
- With multi-step receipts, extra transfers must also be validated.

## Resupply subcontracting (confirmed)
- Same vendor setup; lead time covers shipping components out, production and delivery back.
- Subcontracting BoM lists components, sent from your company to the subcontractor by default.
- Confirming the PO creates a resupply order (components) and a receipt (finished goods); Expected Arrival comes from the vendor lead time.
- Validate resupply (PO Resupply button or Resupply Subcontractor card in Inventory) when components leave; validate the receipt when finished goods arrive.

## Dropship subcontracting
- Page exists in the 18.0 docs; contents not confirmed here (verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/manufacturing/subcontracting/subcontracting_dropship.html).

## Design decisions
- Mixed model: components you list on the BoM are resupplied; components you omit are the subcontractor's responsibility.
- One BoM per subcontractor/product pairing when prices or components differ.
- Costing of the finished good combines the PO price and resupplied component cost (verify in 18.0 docs: the subcontracting pages above).
- Track lots/serials at receipt for tracked finished goods.

## Senior checklist
- Lead times realistic for transit both ways.
- Reconcile the Subcontracting location: residual stock signals unreturned or unconsumed components.
- Match vendor bills to PO after receipt validation.
- Confirm the resupply route and subcontracting location exist per company/warehouse.
