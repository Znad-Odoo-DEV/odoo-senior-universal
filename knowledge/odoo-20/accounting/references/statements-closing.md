# Financial Statements, Tax Return, Closing, Audit Trail

Docs (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/finance/accounting/reporting.html

## Financial statements
- Accounting > Reporting: Balance Sheet, Profit & Loss, Cash Flow, Executive Summary, General Ledger, Trial Balance, Partner Ledger, Aged Receivable, Aged Payable, Journal Audit, Tax Return, Depreciation Schedule (Enterprise assets), Deferred statements, Bank Reconciliation Summary (verify list in 20.0 docs: reporting.html).
- Common controls: options bar for date range/comparison periods, journals, "Draft entries" toggle (include unposted), analytic filter, multi-company/branch, "Unfold all", export to PDF/XLSX.
- Statement lines are formulas over account tags/codes (Accounting > Configuration > Accounting Reports in debug mode); localization supplies the structure. Customize or duplicate: .../reporting/customize.html (custom reports via formulas; verify editor in 20.0 docs).
- Odoo 20: account groups are replaced by parent accounts. Any statement line, custom report or export that selected accounts through an account group must be rebuilt on parent accounts/codes/tags; after the change, check that section subtotals equal the pre-change figures (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/reporting/customize.html).
- Annual/audit pack: .../reporting/annual-report.html (verify content in 20.0 docs). Intrastat (EU goods): .../reporting/intrastat.html. Silverfin integration: .../reporting/silverfin.html. Consolidation: .../get_started/consolidation.html.
- Reconcile the statements: Balance sheet equals trial balance sums; Receivable/Payable lines = aged reports; tax payable accounts = tax return; asset accounts = depreciation schedule; cash = bank statement.

## Tax return
Docs: .../reporting/tax_returns.html , .../reporting/tax_carryover.html
- Accounting > Accounting > Tax Returns (Enterprise): periodicity set in Settings (monthly/quarterly/annual, with reminder date). Each period shows the tax report from tax-grid tags (base and tax per grid).
- Closing the period: "Post Journal Entry" (Closing entry) moves the tax balances to the tax payable/receivable account via the tax-closing journal entry; it also locks the tax period (tax lock date). Review before posting; e-filing available in some localizations.
- Carryover: negative tax balances may carry to next period for lines configured for carryover; manual "Carryover" popup on report lines.
- Mismatch checks: taxes with missing tags, entries posted after the closing entry (use "Tax Lock Date"), fiscal position mapping errors.
- Tax payment: the cash leg that pays the tax authority is a bank-impacting entry, so in 20 it comes from the bank transaction (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/bank.html).
- Tax units for multi-company returns: .../get_started/tax_units.html

## Lock dates (period discipline)
- Settings > Accounting > Lock dates (Accounting > Configuration > Settings). Types: Sales Lock Date, Purchase Lock Date, Tax Lock Date, Fiscal Year Lock Date (hard, cannot be unlocked casually), plus a Hard Lock Date (irreversible once set) in recent versions (verify exact set and names in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/reporting/year_end.html and settings).
- Practice: set Sales/Purchase lock after review each month; set Tax lock on filing; set Fiscal Year lock after audit; exceptions are possible for specific users/companies with an expiry (verify in 20.0 docs).
- Entries dated in locked periods are moved to the next open date when posting; reverse and re-post with the new date.

## Period close checklist (month)
1. Post all customer invoices and vendor bills dated in the period; clear draft items, including draft vendor bills coming from expenses (expenses become draft vendor bills in 20; verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/expenses.html).
2. Reconcile bank/cash journals to statements; suspense = 0. Corrections that affect a bank account are made through bank transactions, never manual journal entries (20 rule).
3. Reconcile outstanding payments/receipts and receivable/payable. Check that filters you use for "open/paid" documents still match the renamed 20 payment statuses (verify in 20.0 docs: .../payments.html).
4. Post depreciation; generate deferrals; accruals via recurring/manual entries with auto-reversal.
5. Stock valuation: automated valuation posts to stock accounts (verify settings in 20.0 docs: .../get_started/inventory_valuation.html); run any manual valuation adjustments.
6. FX revaluation (unrealized gain/loss) with auto-reversal; confirm how bank/cash accounts in foreign currency are handled under the 20 bank-transaction rule (verify in 20.0 docs: .../get_started/multi_currency.html).
7. Review aged balances, provisions, intercompany eliminations (consolidation).
8. Run Trial Balance; compare to prior period; investigate variances.
9. File and close tax return; set lock dates.

## Year-end closing
Docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/reporting/year_end.html
- Odoo does not require manual closing entries: the "Current Year Earnings" account accumulates P&L automatically, and at the new fiscal year the previous year's earnings roll to "Unallocated/Retained Earnings" in reports.
- Year-end tasks: complete all monthly checklists for period 12; post adjusting entries (provisions, inventory count, depreciation true-up, accrued payroll/interest, bad debts); set the Fiscal Year Lock Date after approval.
- Fiscal year period/start month and last day are set in Accounting settings (Fiscal Year / Fiscal Periods). Some localizations require local closing entries (verify per country in the localization doc).
- Opening balances for the next year come automatically from the balance sheet; no reopening entry needed.
- Archive: export General Ledger/Trial Balance/Journals to PDF/XLSX for the audit file.

## Audit trail and inalterability
- Posted entries cannot be edited (sequences, amounts); use credit notes or reversal entries. Chatter logs changes on tracked fields (partner, dates, amounts) and attachments on documents. Odoo 20 removes stored tracking values and generates tracking messages on the fly: do not build audit procedures or custom reports on stored tracking-value records.
- Audit tools: Journal Audit statement, General Ledger drill-down, Journal items with "Group by" and filters, Audit trail views (Accounting > Reporting > Audit Trail; verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/reporting.html).
- Data inalterability check (France and some localizations, Enterprise): hashing of posted entries per journal; "Data Inalterability Check" statement verifies chain integrity: .../reporting/data_inalterability.html
- Gap-free sequences: keep default sequences, use Resequence only when allowed; avoid deleting drafts that consumed numbers when locale requires gap-free numbering.
- Access rights: keep Accountant vs Billing roles separated; limit "Adviser" access; review who can reset to draft or change lock dates. In 20, model access rules and record rules are merged into `ir.access` (`ir.access.csv`); custom accounting security from 19 must be rewritten there.
