# Receipts, control policy and 3-way matching (Odoo 20)
Docs (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/purchase/manage_deals/control_bills.html

## Control policy
Per product: Purchase > Products > Products > Purchase tab > Vendor Bills > Control Policy.
- On ordered quantities: draft bill created from PO confirmation, ordered amounts.
- On received quantities: bill only after some/all goods received; only received qty billed.
- Defaults: services ordered, goods received.

## 3-way matching (PO vs receipt vs bill)
Enable: Purchase > Configuration > Settings > Invoicing > 3-way matching. Pay only after receipt.
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
- Landed costs (freight, duty added to receipt valuation) live in Inventory, not Purchase: (verify in 20.0 docs: search "landed costs" under https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory.html)
- Vendor bill management (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/purchase/manage_deals/manage.html)
- Odoo 20 accounting context: payment statuses on bills are renamed, so filters and automations keyed on the 19 labels need re-checking; employee expenses now arrive as draft vendor bills with no purchase order, so keep them out of PO matching reviews (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/vendor_bills.html).
- The cash leg of a vendor payment follows the 20 rule that bank-impacting entries originate from bank transactions (see the accounting skill).
