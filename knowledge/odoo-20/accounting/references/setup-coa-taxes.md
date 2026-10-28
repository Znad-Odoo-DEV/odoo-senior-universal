# Setup: Chart of Accounts, Journals, Taxes, Fiscal Positions

Docs (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/finance/accounting/get_started/chart_of_accounts.html ,
.../get_started/journals.html , .../taxes.html

## Chart of accounts
- Path: Accounting > Configuration > Chart of Accounts. The chart comes from the installed fiscal localization package (see localization.md).
- Account fields: code, name, type, taxes (default), tags, allowed journals, "Payment Reconciliation" (renamed from "Allow Reconciliation" in 20 — confirmed, release notes; it now also controls whether exchange-rate difference entries are expected on reconciliation), currency (to force one), deprecated flag (hide without deleting).
- Account types drive behavior: Receivable / Payable (partner-bound, reconcilable), Bank and Cash, Credit Card, Current/Non-current Assets, Prepayments, Fixed Assets, Current/Non-current Liabilities, Equity, Current Year Earnings (system), Income, Other Income, Expense, Cost of Revenue, Depreciation, Off-Balance Sheet.
- Code a company-wise numbering scheme and keep it consistent; multi-company: accounts are company-specific, chart can be shared via template.
- Prefer adding accounts over repurposing used ones. Accounts with entries cannot change type to an incompatible one (verify in 20.0 docs: chart_of_accounts.html). Use "Merge" only for accounts with no conflicting config.
- Opening balances: post an opening entry in a Miscellaneous journal at the day before the first period (or use "Opening Balances" import in Enterprise); receivable/payable lines must carry partners to reconcile against later. Odoo 20: lines that touch bank/cash accounts must not be hand-keyed here; the starting bank balance comes in as a bank transaction (verify the opening-balance procedure in 20.0 docs: chart_of_accounts.html).
- Tags on accounts feed financial statement lines; do not strip localization tags.

## Parent accounts (replace account groups in Odoo 20)
- Account groups no longer exist in 20; the chart hierarchy and roll-ups (balance sheet / P&L sections, trial balance subtotals) are expressed with parent accounts. (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/get_started/chart_of_accounts.html)
- Localization charts ship their own parent structure; do not rebuild it by hand. For custom charts, design the parent tree before importing accounts, then keep codes consistent with it.
- Migration impact for databases upgraded from 19: existing account groups must be mapped to parent accounts; statement lines, saved filters, exports, imports (a "group" column in account import files) and custom code that referenced account groups must be reviewed. (exact conversion and field names: verify in 20.0 docs)
- Reconcile after the change: trial balance and balance sheet subtotals must match their pre-upgrade values.

## Journals
- Types: Sales, Purchase, Bank, Cash, Credit Card, Miscellaneous. Path: Accounting > Configuration > Journals.
- Fields: short code (appears in entry sequence), default account, dedicated credit-note sequence, "Use Different Journal for credit notes" option (verify in 20.0 docs: journals.html), allowed accounts, incoming/outgoing payment methods (bank/cash), e-invoice formats.
- Bank journals: bank account number (IBAN validation: the `base_iban` module is removed in 20, verify behavior in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/bank.html), default bank account, suspense account, outstanding receipts/payments accounts (set per payment method line), bank feed config, statement/reconciliation behavior. In 20, entries that hit the bank account originate from bank transactions only; do not post to a bank journal with manual journal entries.
- Cash journals: use for physical cash; reconcile cash counts via statement/cash-control workflow.
- Sequences: per journal (and per credit notes if separated); prefix includes year/month; do not edit sequence after posting except via the supported "Resequence" tool (Journal Items > Resequence) which respects lock dates. Invoice sequence page: .../customer_invoices/sequence.html ; bills: .../vendor_bills/sequence.html.
- One journal per flow; add extra sales journals only for distinct sequences (e.g., proforma series, branch).

## Taxes
Path: Accounting > Configuration > Taxes. Docs: .../taxes.html, .../taxes/tax_computation.html
- Tax Type (Sales/Purchases/None), Tax Computation (Percentage of Price, Fixed, Group of Taxes), Tax Scope (Services/Goods), Amount, "Included in Price", "Affect Base of Subsequent Taxes", Tax Exigibility ("Based on Invoice" or "Based on Payment" = cash basis).
- Distribution (repartition) tabs: lines for Base and Tax, each with account and tax-grid tags; separate sets for Invoices and Refunds. Tags drive the tax return; wrong tags = wrong return.
- Price-included taxes: Odoo back-computes net; mixing included/excluded taxes on one document is fine but watch rounding. Rounding method (per line / globally) is set at company level (Settings > Taxes > Rounding method).
- Groups of taxes (e.g., GST+PST): each child tax keeps its own distribution; sequence order matters with "Affect Base".
- Cash basis taxes: set "Tax Exigibility" to "Based on Payment" and a Cash Basis Transition Account; tax lines move to the final accounts on payment reconciliation. Docs: .../taxes/cash_basis.html
- Withholding taxes: negative-percentage tax on the document; docs: .../taxes/retention.html
- Tax units (consolidated tax returns across companies): .../get_started/tax_units.html
- Defaults: per-company default sale/purchase tax in Settings > Taxes; per-product taxes override; per-account default tax applies to manual entries.
- Archive taxes, never delete once used.

## Fiscal positions
Docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/taxes/fiscal_positions.html
- Remap taxes and accounts by partner situation (domestic, intra-EU B2B, export, tax-exempt). Tabs: Tax Mapping, Account Mapping.
- Automatic detection: "Detect Automatically" with country/state/zip, Foreign Tax ID required, VAT required. Order of fiscal positions matters (sequence).
- Manual: set on the partner (Sales & Purchase tab) or on the document.
- Apply only if a mapping line exists: an unmapped tax stays unchanged; leave "Tax Applied" empty with a replacement tax to remove a tax.
- VAT validation (VIES): .../taxes/vat_verification.html. Odoo 20: the `base_vat` module is removed, so VAT-number format/VIES validation and the "VAT required" detection check must be re-tested rather than assumed . The 20.0 page confirms VIES validation via Accounting > Configuration > Settings > "Verify VAT Numbers" (format check per country always; Intra-Community Valid checkbox for foreign partners) but names no module, so the base_vat removal is not confirmed by the docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/taxes/vat_verification.html. EU distance selling / OSS: .../taxes/eu_distance_selling.html. B2B/B2C price display: .../taxes/B2B_B2C.html. AvaTax (US/CA, Enterprise): .../taxes/avatax.html.

## Payment terms and rounding
- Payment terms: Accounting > Configuration > Payment Terms (percent/fixed/balance lines with delays; early-payment discount). Docs: .../customer_invoices/payment_terms.html, .../customer_invoices/cash_discounts.html
- Cash rounding (e.g., 0.05): .../customer_invoices/cash_rounding.html

## Multi-currency
Docs: .../get_started/multi_currency.html
- Enable Multi-Currencies in Settings > Currencies; activate only needed currencies; configure automatic rate update (provider, interval) in Accounting settings.
- Exchange gain/loss journal and accounts are set in Settings; realized FX posts when reconciling documents with different rates; unrealized FX via "Journals > Unrealized Currency Gains/Losses" revaluation at period end (Enterprise; verify in 20.0 docs: multi_currency.html).
- Bank accounts in foreign currency: .../bank/foreign_currency.html

## Common pitfalls
- Posting before the localization/chart is chosen (hard to change).
- Receivable/payable accounts not set to reconcile; partner missing on lines.
- Tax repartition tags missing on custom taxes -> tax return mismatch.
- Reusing deprecated/archived taxes on posted documents without checking tags.
- Editing sequences manually; use Resequence.
- Upgraded databases: reports, imports or code still referring to account groups after the move to parent accounts.
- Hand-keying entries on bank accounts instead of creating bank transactions (not allowed in 20).
- Custom modules still depending on `base_vat` / `base_iban` (removed in 20).
