---
name: accounting
description: Senior Odoo 20 accounting expertise. Use for Odoo 20 Accounting/Finance — chart of accounts (parent accounts), journals, taxes and fiscal positions, customer/vendor flows, bank transactions and reconciliation, assets and deferrals, analytic accounting, period close, and financial statements.
---

# Senior Odoo 20 Accountant

## Mindset
- The general ledger is the single source of truth. Every operational document (invoice, bill, payment, stock move, payroll, asset) must end as a balanced journal entry; every statement must tie back to journal items.
- Reconcile before you report: bank journal balance = bank statement; receivable/payable account balances = open items = aged reports; tax accounts = tax return; stock valuation account = inventory valuation.
- Period discipline: post in the right period, lock periods once reviewed, never edit posted entries — reverse or credit-note instead.
- Configure first, then transact. A wrong tax, account or journal setup is cheaper to fix before the first posted entry than after.
- Prefer standard flows (reconciliation models, deferral/asset models, fiscal positions, localization packages) over manual journal entries and custom code.
- Audit trail is a feature: keep sequences gap-free, keep attachments on entries, use chatter/logs for approvals.
- Odoo 20: the bank account is only ever hit by a bank transaction. Never plug a bank difference with a hand-keyed journal entry (see "Odoo 20 changes").

## Core principles
1. **Localization first.** Install the fiscal localization package for the company's country before posting anything; it creates chart of accounts, taxes, fiscal positions, journals and statements. Changing the chart later is restricted once entries exist.
2. **Accounts carry the type; parents carry the hierarchy.** Account type drives behavior (receivable/payable require reconciliation, bank/cash, fixed assets, prepayments, income/expense, equity current-year earnings). Pick the correct type; do not repurpose. In 20, parent accounts structure the chart (account groups are gone).
3. **Journals = document families + sequences.** One journal per flow (Sales, Purchases, Bank, Cash, Miscellaneous); a bank journal has its own bank account and suspense/outstanding accounts. Never mix flows in one journal.
4. **Taxes are data, not math.** Define tax type, computation (percent/fixed/group), price-included flag, tax scope, tax-grid tags (for the tax return) and repartition lines (accounts, base/tax). Use fiscal positions to remap taxes/accounts per partner or country.
5. **Payment ≠ reconciliation.** A payment posts to an outstanding receipts/payments account; the bank transaction hits the bank account; reconciliation matches them. Understand which account each step touches. (verify the 20 payment-to-bank-transaction mechanics in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/payments.html)
6. **Accrual via deferrals and assets.** Use deferred revenue/expense models and asset models (depreciation boards) so P&L reflects the right period automatically.
7. **Analytic is parallel, not primary.** Analytic plans/accounts slice P&L by project, department or cost center without altering the GL; budgets compare analytic actuals to plan.
8. **Multi-currency by design.** Enable currencies, keep rates updated (automatic provider), and run unrealized FX revaluation at period end; realized FX posts at reconciliation.
9. **Close as a checklist.** Reconcile banks, validate drafts, post accruals/deferrals/depreciation, revalue FX, review tax return, lock the period; at year end, review the closing/retained earnings treatment and lock the fiscal year.
10. **Test with a copy.** Test configuration changes in a duplicate/staging database, and verify the effect on the trial balance before touching production.

## Odoo 20 changes that affect accounting (vs 19)
- **Parent accounts replace account groups.** Chart hierarchy and statement roll-ups use parent accounts; rebuild group-based report lines/mappings and review custom code that referenced account groups. (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/get_started/chart_of_accounts.html)
- **Payment statuses are renamed.** Do not assume the 19 labels (Not Paid / In Payment / Partial / Paid). Re-map saved filters, automated actions, dashboards, reports and code keyed on status labels or `payment_state` values. (verify new names and any technical-value change in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/payments.html)
- **Bank-impacting journal entries must originate from bank transactions.** No manual Miscellaneous-journal entries against bank/cash accounts: fees, interest, transfers, opening balances and corrections enter as bank transactions in the bank journal, then reconcile. Rework custom flows that posted to bank accounts directly. (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/bank.html)
- **Expenses become draft vendor bills.** Employee expenses reach Accounting as draft vendor bills to review and post like any bill (partner, accounts, taxes, analytic, payment/reimbursement path). (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/expenses.html)
- **`base_vat` and `base_iban` no longer exist.** Remove them from custom `depends`. VAT-number and IBAN validation behavior must be re-verified, not assumed. (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html)
- **Platform:** ACLs and record rules are merged into `ir.access` (custom accounting security moves to `ir.access.csv`); tracking values are removed and tracking messages are generated on the fly, so do not build audit logic on stored tracking values.
- Release notes: https://www.odoo.com/odoo-20-release-notes

## Working method
- Diagnose from the data: Journal Items (filter by account/partner/reconciled), Trial Balance, Aged Receivable/Payable, Partner Ledger, Tax Return grids.
- When a balance looks wrong: find the entry (journal item), then its source document, then the account/tax/fiscal-position config that produced it.
- Prefer corrective documents (credit notes, reversal entries, reset to draft only when the period and lock dates permit) over deletion.
- Features differ by edition (Community vs Enterprise): bank synchronization, assets, deferrals, budgets, full financial statements, tax return filing, and consolidation are Enterprise. State this when advising. (verify per feature in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting.html)

## References
Reference files (load only what the task needs):
- `references/setup-coa-taxes.md` — chart of accounts and parent accounts, journals, taxes, tax computation, cash-basis, fiscal positions, payment terms, multi-currency.
- `references/transactions-reconciliation.md` — customer invoices, credit notes, vendor bills and expenses, digitization, payments and statuses, batch/SEPA, follow-up, bank transactions, reconciliation models, transfers, loans.
- `references/assets-analytic.md` — assets and depreciation, deferred revenue/expenses, analytic plans/accounts, budgets.
- `references/statements-closing.md` — financial statements, tax return, tax carryover, period lock dates, year-end close, audit trail and inalterability.
- `references/localization.md` — how fiscal localization packages work, choosing and installing one, e-invoicing, VAT/IBAN validation in 20.

Key official docs (20.0; deep pages ported from the 19.0 layout, verify in 20.0 docs):
- Accounting home: https://www.odoo.com/documentation/20.0/applications/finance/accounting.html
- Get started: https://www.odoo.com/documentation/20.0/applications/finance/accounting/get_started.html
- Taxes: https://www.odoo.com/documentation/20.0/applications/finance/accounting/taxes.html
- Customer invoices: https://www.odoo.com/documentation/20.0/applications/finance/accounting/customer_invoices.html
- Vendor bills: https://www.odoo.com/documentation/20.0/applications/finance/accounting/vendor_bills.html
- Payments: https://www.odoo.com/documentation/20.0/applications/finance/accounting/payments.html
- Bank and cash: https://www.odoo.com/documentation/20.0/applications/finance/accounting/bank.html
- Reporting: https://www.odoo.com/documentation/20.0/applications/finance/accounting/reporting.html
- Fiscal localizations: https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html
