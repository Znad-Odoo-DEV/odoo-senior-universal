# Receipts, control policy and 3-way matching (Odoo 17)
Docs (verify path in 17.0 docs): https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/purchase/manage_deals/control_bills.html

## Control policy
Per product: Purchase > Products > Products > Purchase tab > Vendor Bills > Control Policy.
- On ordered quantities: draft bill created from PO confirmation, ordered amounts.
- On received quantities: bill only after some/all goods received; only received qty billed.
- Defaults: services ordered, goods received.

## 3-way matching (PO vs receipt vs bill)
Enable: Purchase > Configuration > Settings > Invoicing > 3-way matching (Enterprise module in 17.0; verify edition in 17.0 docs). Pay only after receipt.
- "Should Be Paid" on bill (Other Info tab): Yes (default), No, Exception. Editing a draft bill sets Exception (non-blocking). Paid -> No. Manual change allowed.
- Create bill: PO list > select > Create Bill (PO not already billed). Partial receipts: only received products.
- Confirm bill with a bill date, then register payment.

## PO billing status (Other Information tab)
- Nothing to Bill: received policy, nothing received yet.
- Waiting Bills: received policy with receipts but no bill; ordered policy confirmed without bill.
- Fully Billed: a draft bill has been created (either policy).

## Senior notes
- "Fully Billed" means a bill was created, not posted or paid.
- Receipts are Inventory transfers linked to the PO; Vendor Reference helps match. Quantity mismatches: fix at receipt (backorder/return), then re-bill.
- Landed costs (freight, duty added to receipt valuation) live in Inventory, not Purchase: (verify in 17.0 docs: search "landed costs" under https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory.html)
- Vendor bill management (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/purchase/manage_deals/manage.html)
