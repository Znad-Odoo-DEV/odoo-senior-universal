# Closing and accounting link

> Provenance: items marked "confirmed on 19.0" were read from the 19.0 docs. The 20.0 pages could not be fetched, so every URL below is ported from the 19.0 layout (verify in 20.0 docs).

Sources (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/use.html ; https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/use/receipts.html ; https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/use/pos_invoices.html ; https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/reporting.html

## Closing
1. Hamburger menu > Close Register. Closing Register popover: order count, total sales, expected amount per payment method.
2. Cash: money icon to enter coins/bills (Configuration > Coins/Bills) > Confirm fills Cash Count; clone icon copies expected cash; add Closing note.
3. Close Register again: session closes and accounting entries post.
- Mismatch: Payments Difference window; Proceed Anyway posts to the cash difference journal.
- Control: Set Maximum Difference + Authorized Difference (Payment section); above limit, manager approval.
- Close at the end of each day.

## Accounting link
- Closing posts the session journal entries: sales, taxes, payment-method receivable/outstanding accounts, cash difference (exact account structure: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/use.html).
- Cash method: cash journal; card: bank journal with outstanding/intermediary account, reconciled later with the statement.
- Odoo 20: bank-impacting journal entries must originate from bank transactions, so reconcile card/bank payment-method balances against imported or synced bank transactions rather than adjusting the bank journal by hand. Effect on the PoS closing entry itself is not confirmed (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/use.html).
- Intermediary Account on payment method: empty = company default receivable.
- Invoiced orders (customer requests Invoice) post the invoice immediately: https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/use/pos_invoices.html. Offline invoice requests generate after reconnect.
- Refunds: validated return creates a credit note referencing the original receipt/invoice.

## Inventory link
- Stock moves come from the PoS operation type of its warehouse; timing (at closing vs real time) and valuation: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/shop.html and the Inventory docs).
- Handle lots/serials and negative stock before sale; check the picking type per config.

## Receipts and reporting
- Receipts: https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/use/receipts.html ; Reporting: https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/reporting.html

## Pitfalls
- A locked fiscal period before closing blocks the entry; close sessions before period lock.
- Do not delete or edit orders after closing; use refund/credit note.
- Offline: do not clear browser cache before sync; unsynced orders are lost.
