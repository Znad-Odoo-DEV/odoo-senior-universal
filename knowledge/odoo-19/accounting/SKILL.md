---
name: accounting
description: Senior Odoo 19 accounting expertise. Use for Odoo 19 Accounting/Finance — chart of accounts, journals, taxes and fiscal positions, customer/vendor flows, bank reconciliation, assets and deferrals, analytic accounting, period close, and financial statements.
---

# Senior Odoo 19 Accountant

## Mindset
- The general ledger is the single source of truth. Every operational document (invoice, bill, payment, stock move, payroll, asset) must end as a balanced journal entry; every statement must tie back to journal items.
- Reconcile before you report: bank journal balance = bank statement; receivable/payable account balances = open items = aged reports; tax accounts = tax return; stock valuation account = inventory valuation.
- Period discipline: post in the right period, lock periods once reviewed, never edit posted entries — reverse or credit-note instead.
- Configure first, then transact. A wrong tax, account or journal setup is cheaper to fix before the first posted entry than after.
- Prefer standard flows (reconciliation models, deferral/asset models, fiscal positions, localization packages) over manual journal entries and custom code.
- Audit trail is a feature: keep sequences gap-free, keep attachments on entries, use chatter/logs for approvals.

## Core principles
1. **Localization first.** Install the fiscal localization package for the company's country before posting anything; it creates chart of accounts, taxes, fiscal positions, journals and statements. Changing the chart later is restricted once entries exist.
2. **Accounts carry the type.** Account type drives behavior (receivable/payable require reconciliation, bank/cash, fixed assets, prepayments, income/expense, equity current-year earnings). Pick the correct type; do not repurpose.
3. **Journals = document families + sequences.** One journal per flow (Sales, Purchases, Bank, Cash, Miscellaneous); a bank journal has its own bank account and suspense/outstanding accounts. Never mix flows in one journal.
4. **Taxes are data, not math.** Define tax type, computation (percent/fixed/group), price-included flag, tax scope, tax-grid tags (for the tax return) and repartition lines (accounts, base/tax). Use fiscal positions to remap taxes/accounts per partner or country.
5. **Payment ≠ reconciliation.** A payment posts to an outstanding receipts/payments account; the bank statement line hits the bank account; reconciliation matches them. Understand which account each step touches.
6. **Accrual via deferrals and assets.** Use deferred revenue/expense models and asset models (depreciation boards) so P&L reflects the right period automatically.
7. **Analytic is parallel, not primary.** Analytic plans/accounts slice P&L by project, department or cost center without altering the GL; budgets compare analytic actuals to plan.
8. **Multi-currency by design.** Enable currencies, keep rates updated (automatic provider), and run unrealized FX revaluation at period end; realized FX posts at reconciliation.
9. **Close as a checklist.** Reconcile banks, validate drafts, post accruals/deferrals/depreciation, revalue FX, review tax return, lock the period; at year end, review the closing/retained earnings treatment and lock the fiscal year.
10. **Test with a copy.** Test configuration changes in a duplicate/staging database, and verify the effect on the trial balance before touching production.

## Working method
- Diagnose from the data: Journal Items (filter by account/partner/reconciled), Trial Balance, Aged Receivable/Payable, Partner Ledger, Tax Return grids.
- When a balance looks wrong: find the entry (journal item), then its source document, then the account/tax/fiscal-position config that produced it.
- Prefer corrective documents (credit notes, reversal entries, reset to draft only when the period and lock dates permit) over deletion.
- Features differ by edition (Community vs Enterprise): bank synchronization, assets, deferrals, budgets, full financial statements, tax return filing, and consolidation are Enterprise. State this when advising. (verify per feature in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/finance/accounting.html)

## References
Reference files (load only what the task needs):
- `references/setup-coa-taxes.md` — chart of accounts, journals, taxes, tax computation, cash-basis, fiscal positions, payment terms, multi-currency.
- `references/transactions-reconciliation.md` — customer invoices, credit notes, vendor bills, digitization, payments, batch/SEPA, follow-up, bank sync, reconciliation models, transfers, loans.
- `references/assets-analytic.md` — assets and depreciation, deferred revenue/expenses, analytic plans/accounts, budgets.
- `references/statements-closing.md` — financial statements, tax return, tax carryover, period lock dates, year-end close, audit trail and inalterability.
- `references/localization.md` — how fiscal localization packages work, choosing and installing one, e-invoicing.

Key official docs (19.0):
- Accounting home: https://www.odoo.com/documentation/19.0/applications/finance/accounting.html
- Get started: https://www.odoo.com/documentation/19.0/applications/finance/accounting/get_started.html
- Taxes: https://www.odoo.com/documentation/19.0/applications/finance/accounting/taxes.html
- Customer invoices: https://www.odoo.com/documentation/19.0/applications/finance/accounting/customer_invoices.html
- Vendor bills: https://www.odoo.com/documentation/19.0/applications/finance/accounting/vendor_bills.html
- Payments: https://www.odoo.com/documentation/19.0/applications/finance/accounting/payments.html
- Bank and cash: https://www.odoo.com/documentation/19.0/applications/finance/accounting/bank.html
- Reporting: https://www.odoo.com/documentation/19.0/applications/finance/accounting/reporting.html
- Fiscal localizations: https://www.odoo.com/documentation/19.0/applications/finance/fiscal_localizations.html
