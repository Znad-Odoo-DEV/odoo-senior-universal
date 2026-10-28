# Closing and accounting link

Sources (19.0 layout, version swapped; verify paths in 17.0): https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale.html ; https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale.html ; https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale.html ; https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/reporting.html

## Closing
1. Menu (hamburger/ellipsis) > Close Register. Closing Register popover: order count, total sales, expected amount per payment method.
2. Cash: money icon to enter coins/bills (Configuration > Coins/Bills) > Confirm fills Cash Count; clone icon copies expected cash; add Closing note.
3. Close Register again: session closes and accounting entries post.
- Mismatch: Payments Difference window; Proceed Anyway posts to the cash difference journal.
- Control: Set Maximum Difference + Authorized Difference (Payment section); above limit, manager approval.
- Close at the end of each day.
- Exact popover labels differ slightly between versions: confirm on the 17.0 register.

## Accounting link
- Closing posts the session journal entries: sales, taxes, payment-method receivable/outstanding accounts, cash difference (exact account structure: verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale.html).
- Cash method: cash journal; card: bank journal with outstanding/intermediary account, reconciled later with the statement.
- Intermediary Account on payment method: empty = company default receivable.
- Invoiced orders (customer requests Invoice) post the invoice immediately: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale.html. Offline invoice requests: verify in 17.0 whether they generate after reconnect or must be done online.
- Refunds: validated return creates a credit note referencing the original receipt/invoice.

## Inventory link
- Stock moves come from the PoS operation type of its warehouse; timing (at closing vs real time) and valuation: (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/shop.html and the Inventory docs).
- Handle lots/serials and negative stock before sale; check the picking type per config.

## Receipts and reporting
- Receipts: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale.html ; Reporting: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/reporting.html

## Pitfalls
- A locked fiscal period before closing blocks the entry; close sessions before period lock.
- Do not delete or edit orders after closing; use refund/credit note.
- Offline: do not clear browser cache before sync; unsynced orders are lost.
