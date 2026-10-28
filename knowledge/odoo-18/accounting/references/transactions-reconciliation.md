# Transactions and Reconciliation

Docs: https://www.odoo.com/documentation/18.0/applications/finance/accounting/customer_invoices.html ,
.../vendor_bills.html , .../payments.html , .../bank.html

## Customer invoices
- Flow: draft -> Confirm (posted, sequence assigned) -> payment registered -> reconciled (Paid). Overview: .../customer_invoices/overview.html
- Sources: manual (Accounting > Customers > Invoices), Sales orders (invoicing policy ordered/delivered), Subscriptions, Projects/timesheets.
- Credit notes: "Add Credit Note" on a posted invoice (reverse, optionally full refund or new draft invoice). Never delete posted invoices. Docs: .../customer_invoices/credit_notes.html
- Terms: payment terms, cash discounts, cash rounding, default T&C, Incoterms, addresses (docs list in the customer_invoices index).
- Deferred revenue: invoice lines with deferral dates via deferred revenue model (see assets-analytic.md).
- E-invoicing (EDI): formats per journal/country (UBL/CII, Peppol, country formats); docs: .../customer_invoices/electronic_invoicing.html. Availability depends on localization (see localization.md).
- Delivery: send & print, snailmail (.../snailmail.html), EPC QR codes (.../epc_qr_code.html), payment links via payment providers.
- Follow-up (dunning): Accounting > Customers > Follow-up; levels with delays/actions per partner. Docs: .../payments/follow_up.html (verify layout in 18.0 docs).

## Vendor bills
- Create manually, from email alias on the Purchase journal, upload/drag-drop with OCR digitization (IAP credits, Enterprise), or from Purchase orders (3-way matching via bill control policy). Docs: .../vendor_bills/invoice_digitization.html
- Check "Bill Reference" uniqueness (duplicate warnings), vendor, accounting date vs bill date (accounting date determines period).
- Expense lines to the right account; capitalize with an asset-type account (auto-create asset) -> .../vendor_bills/assets.html ; defer with a deferred-expense model -> .../vendor_bills/deferred_expenses.html
- Vendor credit notes (refunds) work like customer ones.

## Payments
- Register payment from invoice/bill: journal (bank/cash), payment method (manual, checks, SEPA, batch, provider), amount, date, memo. Posting creates a payment entry (outstanding account vs receivable/payable) and reconciles with the invoice. The invoice is reconciled with the payment entry; the later bank-statement match clears the outstanding account.
- Statuses: Paid / In Payment (payment registered but bank line not yet matched) / Partial / Not paid. (verify in 18.0 docs: .../payments.html)
- Batch payments (group customer/vendor payments for one bank line): .../payments/batch.html . SEPA credit transfer/direct debit: .../payments/sepa_payments.html . Checks: .../payments/pay_checks.html
- Payment terms with installments produce multiple receivable lines; each reconciles separately.
- Online payment providers: finance > payment_providers (separate docs).

## Bank and cash
Docs: .../bank.html , .../bank/transactions.html , .../bank/reconciliation.html
- Feeds: bank synchronization (Enterprise; providers via IAP/Ponto/Basiq etc.: .../bank/bank_synchronization.html), file import (CAMT.053, OFX, QIF, CSV, CODA depending on localization), manual statement lines.
- Bank journal tracks: bank account, outstanding receipts/payments, suspense account. Unmatched statement lines sit in suspense until reconciled; the suspense balance should be zero at close.
- Bank reconciliation widget (Accounting > Reconciliation, in 18.0 the "Bank Reconciliation" kanban/list-detail view; verify UI in 18.0 docs): for each statement line match open items/payments, or apply a reconciliation model, or write off manually. Validate => line's journal entry posts and reconciles.
- Reconciliation models (Configuration > Reconciliation Models): types — write-off suggestion, rule to match invoices/bills, rule to match existing transactions; conditions by label/note/partner/amount; auto-validate option; partner mapping by regex. Docs: .../bank/reconciliation_models.html . Use for recurring items (bank fees, interest, cards).
- Internal transfers between bank/cash journals: payments with "Internal Transfer" type via a liquidity transfer account, reconcile at each side. Docs: .../bank/internal_transfers.html
- Foreign currency banks: statement amount in currency; rate difference posts to exchange gain/loss. Docs: .../bank/foreign_currency.html
- Loans management (Enterprise): amortization schedule creates entries; docs: .../bank/loans.html
- Reconcile accounts other than bank: Accounting > Reporting > Journal items > filter, or Reconcile action on accounts with "Allow Reconciliation" (receivable, payable, outstanding, transfer, GRNI/stock interim).

## Controls to apply routinely
- Bank journal balance = bank statement ending balance on the cutoff date.
- Outstanding receipts/payments accounts only contain items not yet on the statement (list with dates).
- Suspense accounts = 0; unreconciled receivable/payable credits investigated (unapplied payments).
- Partial reconciliations reviewed; write-offs only via models/approved accounts.
- Use Reset to Draft sparingly; allowed only if no lock date blocks it and the entry is not part of a locked/e-filed period; reverse instead when in doubt.

## Typical troubleshooting
- Invoice stays "In Payment": payment not matched to a bank line; reconcile the statement line with the payment.
- Duplicate bank line imported: use unique transaction IDs; remove the draft/unreconciled statement line, never delete reconciled entries.
- Wrong partner on payment: reset to draft (if permitted), fix partner, repost, re-reconcile.
