# Assets, Deferred Entries, Analytic Accounting, Budgets

Enterprise features (Assets, Deferred entries, Budgets). Confirm edition before advising.

## Fixed assets (non-current assets)
Docs: https://www.odoo.com/documentation/19.0/applications/finance/accounting/vendor_bills/assets.html
- Asset model (Accounting > Configuration > Asset Models): fixed asset account, depreciation account (expense), accumulated depreciation (contra) account, journal, method, duration, periodicity, prorata/start date, "Auto-post" option, "Create in draft or running".
- Auto-creation: set an account of type Fixed Assets/Non-current Assets with an asset model (account "Automate Assets"/"Asset Model" field); posting a vendor bill line to it creates a draft asset linked to the bill (verify field name in 19.0 docs: assets.html).
- Depreciation methods: Straight line, Declining balance (with factor), Declining then straight line (verify in 19.0 docs). Prorata Temporis uses the acquisition date.
- Lifecycle: Draft -> Confirm (Running; depreciation board computed) -> Sell/Dispose -> Close; Pause, Modify (change duration/value with a note, creates entries), and Set to Draft. Sale/disposal posts gain/loss.
- Each depreciation line creates a draft/auto-posted entry dated by period; post them before period close (scheduled action can auto-post).
- Reconcile: Fixed asset account balance (gross) and accumulated depreciation = asset register totals. Use the Depreciation Schedule statement for this.
- Assets with partial deductible VAT: purchase amount includes non-recoverable tax in asset value.

## Deferred revenue and expenses
Docs: .../customer_invoices/deferred_revenues.html , .../vendor_bills/deferred_expenses.html
- Configure in Accounting Settings: Deferred Revenue/Expense journal, deferred revenue/expense accounts (current liability/asset), generation method (Equal per month, or Days-based; verify in 19.0 docs), and "Generate entries automatically" (auto-post at period end, optional).
- On an invoice/bill line: set deferral start and end dates; a deferral account (or model) on the line triggers the deferral. Lines on accounts configured as deferrable expose "Deferred" options.
- Mechanism: at posting/month end, Odoo creates a deferral entry and its reversal so the P&L account holds only the portion belonging to each period; the deferred balance sits on the balance sheet account.
- Review: Accounting > Accounting > Deferred Revenues / Deferred Expenses menu lists each month's entries; generate/validate before closing the month.
- Period-based approach is entry-level (monthly), not a full asset board; do not use it for capitalizable assets.
- Control: deferred accounts balance = unexpired portion of deferred invoices (reconcile with the Deferred Revenue / Expense statement).

## Analytic accounting
Docs: https://www.odoo.com/documentation/19.0/applications/finance/accounting/reporting/analytic_accounting.html
- Enable Analytic Accounting in Accounting settings. Structure: Analytic Plans (dimensions: Projects, Departments, Cost centers; hierarchical via parent plan), Analytic Accounts (belong to a plan), Analytic Distribution Models (auto-apply by partner, product category, account, company).
- Distribution: on invoice/bill lines and journal items, split 100% (or any %) across accounts of different plans; each plan has its own 100% target (a plan can be Mandatory/Optional/Unavailable per account applicability; verify wording in 19.0 docs).
- Analytic lines are created when a journal entry is posted and are independent of the GL; ledger totals do not change.
- Reports: Accounting > Reporting > Analytic Reporting (pivot of analytic items); filter statements (P&L) by analytic plan/account via the Analytic filter on the statement; Budgets compare against analytic actuals.
- Related apps: Timesheets, Projects, Expenses, Purchase generate analytic lines automatically; keep the analytic account on the source document.
- Pitfalls: distributions that don't total 100%; analytic added after posting needs edit via journal item; plans with applicability "Mandatory" block posting if unset.

## Budgets
Docs: https://www.odoo.com/documentation/19.0/applications/finance/accounting/reporting/budget.html
- Budgets are built on analytic accounts/plans: define budget lines with target amounts per analytic account and date range (verify structure in 19.0 docs: budget.html); actuals come from analytic items; "Achieved" vs target percent.
- Budget lines can be tied to general accounts to limit actuals considered; use per-period lines for monthly tracking.
- Review monthly with the analytic reporting; budgets do not block posting (informational control only).

## Month-end routine tied to this file
1. Post/auto-post depreciation entries for the month.
2. Generate deferred revenue/expense entries.
3. Check analytic distribution completeness on P&L entries.
4. Compare analytic actuals to budget and document variances.
