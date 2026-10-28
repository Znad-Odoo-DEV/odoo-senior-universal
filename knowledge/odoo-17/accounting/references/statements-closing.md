# Financial Statements, Tax Return, Closing, Audit Trail

Docs: https://www.odoo.com/documentation/17.0/applications/finance/accounting/reporting.html

## Financial statements
- Accounting > Reporting: Balance Sheet, Profit & Loss, Cash Flow, Executive Summary, General Ledger, Trial Balance, Partner Ledger, Aged Receivable, Aged Payable, Journal Audit, Tax Return, Depreciation Schedule (Enterprise assets), Deferred Revenue/Expense statements (where present), Bank Reconciliation Summary (verify list in 17.0 docs: reporting.html).
- Common controls: options bar for date range/comparison periods, journals, "Draft entries" toggle (include unposted), analytic filter, multi-company/branch, "Unfold all", export to PDF/XLSX.
- Statement lines are formulas over account tags/codes (Accounting > Configuration > Accounting Reports in debug mode); localization supplies the structure. Customize or duplicate: .../reporting/customize.html (custom reports via account groups/formulas; verify editor in 17.0 docs).
- Annual/audit pack: .../reporting/annual-report.html (verify content in 17.0 docs). Intrastat (EU goods): .../reporting/intrastat.html. Silverfin integration: .../reporting/silverfin.html. Consolidation: .../get_started/consolidation.html.
- Reconcile the statements: Balance sheet equals trial balance sums; Receivable/Payable lines = aged reports; tax payable accounts = tax return; asset accounts = depreciation schedule; cash = bank statement.

## Tax return
Docs: .../reporting/tax_returns.html , .../reporting/tax_carryover.html
- Accounting > Accounting > Tax Returns (Enterprise; menu location: verify in 17.0 docs): periodicity set in Settings (monthly/quarterly/annual, with reminder date). Each period shows the tax report from tax-grid tags (base and tax per grid).
- Closing the period: "Post Journal Entry" (Closing entry) moves the tax balances to the tax payable/receivable account via the tax-closing journal entry; it also locks the tax period (tax lock date). Review before posting; e-filing available in some localizations.
- Carryover: negative tax balances may carry to next period for lines configured for carryover; manual "Carryover" popup on report lines.
- Mismatch checks: taxes with missing tags, entries posted after the closing entry (use "Tax Lock Date"), fiscal position mapping errors.
- Tax units for multi-company returns: .../get_started/tax_units.html

## Lock dates (period discipline)
- Lock dates are set from the Lock Dates action under Accounting (Enterprise) or Accounting settings, depending on build. 17.0 offers: Lock Date for Non-Advisers (journal entries), Lock Date for All Users (fiscal year lock; applies to advisers too, though an adviser can still change the date), and Tax Lock Date (set by the tax return closing). Separate Sales/Purchase lock dates and a Hard Lock Date (irreversible once set) are later additions (verify exact set, names and menu location in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/finance/accounting/reporting/year_end.html and settings).
- Practice: set the non-adviser lock after review each month; set Tax lock on filing; set the All Users (fiscal year) lock after audit; advisers can still post under the non-adviser lock, so review who has the Adviser right (per-user exceptions with an expiry are a later feature: verify in 17.0 docs).
- Entries dated in locked periods are moved to the next open date when posting; reverse and re-post with the new date.

## Period close checklist (month)
1. Post all customer invoices and vendor bills dated in the period; clear draft items.
2. Reconcile bank/cash journals to statements; suspense = 0.
3. Reconcile outstanding payments/receipts and receivable/payable.
4. Post depreciation; generate deferrals; accruals via recurring/manual entries with auto-reversal.
5. Stock valuation: automated valuation posts to stock accounts (verify settings in 17.0 docs: .../get_started/inventory_valuation.html); run any manual valuation adjustments.
6. FX revaluation (unrealized gain/loss) with auto-reversal.
7. Review aged balances, provisions, intercompany eliminations (consolidation).
8. Run Trial Balance; compare to prior period; investigate variances.
9. File and close tax return; set lock dates.

## Year-end closing
Docs: https://www.odoo.com/documentation/17.0/applications/finance/accounting/reporting/year_end.html
- Odoo does not require manual closing entries: the "Current Year Earnings" account accumulates P&L automatically, and at the new fiscal year the previous year's earnings roll to "Unallocated/Retained Earnings" in reports.
- Year-end tasks: complete all monthly checklists for period 12; post adjusting entries (provisions, inventory count, depreciation true-up, accrued payroll/interest, bad debts); set the Lock Date for All Users (fiscal year lock) after approval.
- Fiscal year period/start month and last day are set in Accounting settings (Fiscal Year / Fiscal Periods). Some localizations require local closing entries (verify per country in the localization doc).
- Opening balances for the next year come automatically from the balance sheet; no reopening entry needed.
- Archive: export General Ledger/Trial Balance/Journals to PDF/XLSX for the audit file.

## Audit trail and inalterability
- Posted entries cannot be edited (sequences, amounts); use credit notes or reversal entries. Chatter logs changes on tracked fields (partner, dates, amounts) and attachments on documents.
- Audit tools: Journal Audit statement, General Ledger drill-down, Journal items with "Group by" and filters, chatter tracking on entries and attachments. A dedicated Audit Trail view is a later addition: do not promise it on 17.0 (verify in 17.0 docs).
- Data inalterability check (France and some localizations, Enterprise): hashing of posted entries per journal; "Data Inalterability Check" statement verifies chain integrity: .../reporting/data_inalterability.html
- Gap-free sequences: keep default sequences, use Resequence only when allowed; avoid deleting drafts that consumed numbers when locale requires gap-free numbering.
- Access rights: keep Accountant vs Billing roles separated; limit "Adviser" access; review who can reset to draft or change lock dates.
