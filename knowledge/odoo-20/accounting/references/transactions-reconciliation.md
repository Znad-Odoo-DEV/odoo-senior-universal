# Transactions and Reconciliation

Docs (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/finance/accounting/customer_invoices.html ,
.../vendor_bills.html , .../payments.html , .../bank.html

## Odoo 20 changes in this area (vs 19)
- Bank-impacting journal entries must originate from bank transactions: every entry that moves a bank/cash account comes from a bank transaction (bank feed, file import, or a transaction created in the bank journal). No manual journal entries against bank accounts. (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/bank/transactions.html)
- Payment statuses are renamed: the 19 labels quoted below (Paid / In Payment / Partial / Not paid) are legacy names. Re-map filters, automations and reports to the 20 labels. (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/payments.html)
- Expenses become draft vendor bills: expense-originated bills appear as drafts in Accounting > Vendors > Bills for review and posting. (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/expenses.html)
- `base_iban` is removed: IBAN validation on partner and company bank accounts must be re-tested (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/bank.html).

## Customer invoices
- Flow: draft -> Confirm (posted, sequence assigned) -> payment registered -> reconciled (settled; status labels renamed in 20, see Payments). Overview: .../customer_invoices/overview.html
- Sources: manual (Accounting > Customers > Invoices), Sales orders (invoicing policy ordered/delivered), Subscriptions, Projects/timesheets.
- Credit notes: "Add Credit Note" on a posted invoice (reverse, optionally full refund or new draft invoice). Never delete posted invoices. Docs: .../customer_invoices/credit_notes.html
- Terms: payment terms, cash discounts, cash rounding, default T&C, Incoterms, addresses (docs list in the customer_invoices index).
- Deferred revenue: invoice lines with deferral dates via deferred revenue model (see assets-analytic.md).
- E-invoicing (EDI): formats per journal/country (UBL/CII, Peppol, country formats); docs: .../customer_invoices/electronic_invoicing.html. Availability depends on localization (see localization.md).
- Delivery: send & print, snailmail (.../snailmail.html), EPC QR codes (.../epc_qr_code.html), payment links via payment providers.
- Follow-up (dunning): Accounting > Customers > Follow-up; levels with delays/actions per partner. Docs: .../payments/follow_up.html (verify layout in 20.0 docs). Follow-up filters based on payment status must be checked against the renamed 20 statuses.

## Vendor bills
- Create manually, from email alias on the Purchase journal, upload/drag-drop with OCR digitization (IAP credits, Enterprise), or from Purchase orders (3-way matching via bill control policy). Docs: .../vendor_bills/invoice_digitization.html
- Employee expenses arrive as draft vendor bills in 20: review vendor/employee partner, expense accounts, taxes, analytic distribution, attachments and the payment/reimbursement path before posting; these bills have no purchase order, so keep them out of PO-matching reviews. (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/expenses.html)
- Check "Bill Reference" uniqueness (duplicate warnings), vendor, accounting date vs bill date (accounting date determines period).
- Expense lines to the right account; capitalize with an asset-type account (auto-create asset) -> .../vendor_bills/assets.html ; defer with a deferred-expense model -> .../vendor_bills/deferred_expenses.html
- Vendor credit notes (refunds) work like customer ones.

## Payments
- Register payment from invoice/bill: journal (bank/cash), payment method (manual, checks, SEPA, batch, provider), amount, date, memo. Posting creates a payment entry (outstanding account vs receivable/payable) and reconciles with the invoice. The invoice is reconciled with the payment entry; the later bank transaction match clears the outstanding account. (This is the 19 model; confirm the 20 mechanics in 20.0 docs: .../payments.html.)
- Statuses (19 names, renamed in 20): Paid / In Payment (payment registered but bank line not yet matched) / Partial / Not paid. Before changing any filter, map each of these four meanings to its 20 label (verify in 20.0 docs: .../payments.html).
- Batch payments (group customer/vendor payments for one bank line): .../payments/batch.html . SEPA credit transfer/direct debit: .../payments/sepa_payments.html (partner IBANs: `base_iban` removed in 20, re-test validation) . Checks: .../payments/pay_checks.html
- Payment terms with installments produce multiple receivable lines; each reconciles separately.
- Online payment providers: finance > payment_providers (separate docs).

## Bank and cash
Docs: .../bank.html , .../bank/transactions.html , .../bank/reconciliation.html
- Feeds: bank synchronization (Enterprise; providers via IAP/Ponto/Basiq etc.: .../bank/bank_synchronization.html), file import (CAMT.053, OFX, QIF, CSV, CODA depending on localization), manual bank transactions.
- 20 rule: the bank account balance moves only through bank transactions. Bank fees, interest, FX differences on the bank leg, opening balances and corrections are entered as bank transactions (then matched or written off with a reconciliation model), not as manual entries in the bank journal or the Miscellaneous journal. Custom code that posts moves on bank accounts must be reworked to create bank transactions. (verify in 20.0 docs: .../bank/transactions.html)
- Bank journal tracks: bank account, outstanding receipts/payments, suspense account. Unmatched bank transactions sit in suspense until reconciled; the suspense balance should be zero at close.
- Bank reconciliation widget (Accounting > Reconciliation, in 19.0 the "Bank Reconciliation" kanban/list-detail view; verify the 20 UI in 20.0 docs: .../bank/reconciliation.html): for each bank transaction match open items/payments, or apply a reconciliation model, or write off manually. Validate => line's journal entry posts and reconciles.
- Reconciliation models (Configuration > Reconciliation Models): types — write-off suggestion, rule to match invoices/bills, rule to match existing transactions; conditions by label/note/partner/amount; auto-validate option; partner mapping by regex. Docs: .../bank/reconciliation_models.html . Use for recurring items (bank fees, interest, cards).
- Internal transfers between bank/cash journals: payments with "Internal Transfer" type via a liquidity transfer account, reconcile at each side; under the 20 rule the bank leg on each side must come from a bank transaction (verify in 20.0 docs: .../bank/internal_transfers.html).
- Foreign currency banks: transaction amount in currency; rate difference posts to exchange gain/loss. Docs: .../bank/foreign_currency.html
- Loans management (Enterprise): amortization schedule creates entries; docs: .../bank/loans.html . Disbursement and repayment cash legs follow the bank-transaction rule (verify in 20.0 docs).
- Reconcile accounts other than bank: Accounting > Reporting > Journal items > filter, or Reconcile action on accounts with "Allow Reconciliation" (receivable, payable, outstanding, transfer, GRNI/stock interim).

## Controls to apply routinely
- Bank journal balance = bank statement ending balance on the cutoff date.
- Outstanding receipts/payments accounts only contain items not yet on the bank statement (list with dates).
- Suspense accounts = 0; unreconciled receivable/payable credits investigated (unapplied payments).
- Partial reconciliations reviewed; write-offs only via models/approved accounts.
- No manual entries on bank accounts (20): a quick audit is Journal Items filtered on bank accounts, grouped by journal, looking for Miscellaneous-journal lines.
- Use Reset to Draft sparingly; allowed only if no lock date blocks it and the entry is not part of a locked/e-filed period; reverse instead when in doubt.

## Typical troubleshooting
- Invoice stays in the 19 "In Payment" state (renamed in 20): payment not matched to a bank transaction; reconcile the bank transaction with the payment.
- Duplicate bank line imported: use unique transaction IDs; remove the draft/unreconciled bank transaction, never delete reconciled entries.
- Wrong partner on payment: reset to draft (if permitted), fix partner, repost, re-reconcile.
- Need to correct a bank balance: create the missing or reversing bank transaction; do not post a manual entry on the bank account.
