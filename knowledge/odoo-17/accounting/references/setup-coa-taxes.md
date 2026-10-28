# Setup: Chart of Accounts, Journals, Taxes, Fiscal Positions

Docs: https://www.odoo.com/documentation/17.0/applications/finance/accounting/get_started/chart_of_accounts.html ,
.../get_started/journals.html , .../taxes.html

## Chart of accounts
- Path: Accounting > Configuration > Chart of Accounts. The chart comes from the installed fiscal localization package (see localization.md).
- Account fields: code, name, type, taxes (default), tags, allowed journals, "Allow Reconciliation", currency (to force one), deprecated flag (hide without deleting).
- Account types drive behavior: Receivable / Payable (partner-bound, reconcilable), Bank and Cash, Credit Card, Current/Non-current Assets, Prepayments, Fixed Assets, Current/Non-current Liabilities, Equity, Current Year Earnings (system), Income, Other Income, Expense, Cost of Revenue, Depreciation, Off-Balance Sheet.
- Code a company-wise numbering scheme and keep it consistent; multi-company: accounts are company-specific, chart can be shared via template.
- Prefer adding accounts over repurposing used ones. Accounts with entries cannot change type to an incompatible one. Merge accounts only where the build offers a merge action and only when they have no conflicting config (verify both in 17.0 docs: chart_of_accounts.html).
- Opening balances: post an opening entry in a Miscellaneous journal at the day before the first period (or use "Opening Balances" import in Enterprise); receivable/payable lines must carry partners to reconcile against later.
- Tags on accounts feed financial statement lines; do not strip localization tags.

## Journals
- Types: Sales, Purchase, Bank, Cash, Miscellaneous (a Credit Card journal type is a later addition: verify in 17.0 docs: journals.html). Path: Accounting > Configuration > Journals.
- Fields: short code (appears in entry sequence), default account, dedicated credit-note sequence, "Use Different Journal for credit notes" option (verify in 17.0 docs: journals.html), allowed accounts, incoming/outgoing payment methods (bank/cash), e-invoice formats.
- Bank journals: bank account number, default bank account, suspense account, outstanding receipts/payments accounts (set per payment method line), bank feed config, statement/reconciliation behavior.
- Cash journals: use for physical cash; reconcile cash counts via statement/cash-control workflow.
- Sequences: per journal (and per credit notes if separated); prefix includes year/month; do not edit sequence after posting except via the supported "Resequence" tool (Action menu on Journal Entries, developer mode; verify path in 17.0 docs) which respects lock dates. Invoice sequence page: .../customer_invoices/sequence.html ; bills: .../vendor_bills/sequence.html.
- One journal per flow; add extra sales journals only for distinct sequences (e.g., proforma series, branch).

## Taxes
Path: Accounting > Configuration > Taxes. Docs: .../taxes.html, .../taxes/tax_computation.html
- Tax Type (Sales/Purchases/None), Tax Computation (Percentage of Price, Fixed, Group of Taxes), Tax Scope (Services/Goods), Amount, "Included in Price", "Affect Base of Subsequent Taxes", Tax Exigibility ("Based on Invoice" or "Based on Payment" = cash basis).
- Distribution (repartition) tabs: lines for Base and Tax, each with account and tax-grid tags; separate sets for Invoices and Refunds. Tags drive the tax return; wrong tags = wrong return.
- Price-included taxes: Odoo back-computes net; mixing included/excluded taxes on one document is fine but watch rounding. Rounding method (per line / globally) is set at company level (Accounting settings, Taxes section; may need developer mode: verify in 17.0 docs).
- Groups of taxes (e.g., GST+PST): each child tax keeps its own distribution; sequence order matters with "Affect Base".
- Cash basis taxes: set "Tax Exigibility" to "Based on Payment" and a Cash Basis Transition Account; tax lines move to the final accounts on payment reconciliation. Docs: .../taxes/cash_basis.html
- Withholding taxes: negative-percentage tax on the document; docs: .../taxes/retention.html
- Tax units (consolidated tax returns across companies): .../get_started/tax_units.html
- Defaults: per-company default sale/purchase tax in Settings > Taxes; per-product taxes override; per-account default tax applies to manual entries.
- Archive taxes, never delete once used.

## Fiscal positions
Docs: https://www.odoo.com/documentation/17.0/applications/finance/accounting/taxes/fiscal_positions.html
- Remap taxes and accounts by partner situation (domestic, intra-EU B2B, export, tax-exempt). Tabs: Tax Mapping, Account Mapping.
- Automatic detection: "Detect Automatically" with country/state/zip, Foreign Tax ID required, VAT required. Order of fiscal positions matters (sequence).
- Manual: set on the partner (Sales & Purchase tab) or on the document.
- Apply only if a mapping line exists: an unmapped tax stays unchanged; leave "Tax Applied" empty with a replacement tax to remove a tax.
- VAT validation (VIES): .../taxes/vat_verification.html. EU distance selling / OSS: .../taxes/eu_distance_selling.html. B2B/B2C price display: .../taxes/B2B_B2C.html. AvaTax (US/CA, Enterprise): .../taxes/avatax.html.

## Payment terms and rounding
- Payment terms: Accounting > Configuration > Payment Terms (percent/fixed/balance lines with delays; early-payment discount). Docs: .../customer_invoices/payment_terms.html, .../customer_invoices/cash_discounts.html
- Cash rounding (e.g., 0.05): .../customer_invoices/cash_rounding.html

## Multi-currency
Docs: .../get_started/multi_currency.html
- Enable Multi-Currencies in Settings > Currencies; activate only needed currencies; configure automatic rate update (provider, interval) in Accounting settings.
- Exchange gain/loss journal and accounts are set in Settings; realized FX posts when reconciling documents with different rates; unrealized FX via the Unrealized Currency Gains/Losses revaluation (Enterprise) at period end (menu location and auto-reversal: verify in 17.0 docs: multi_currency.html).
- Bank accounts in foreign currency: .../bank/foreign_currency.html

## Common pitfalls
- Posting before the localization/chart is chosen (hard to change).
- Receivable/payable accounts not set to reconcile; partner missing on lines.
- Tax repartition tags missing on custom taxes -> tax return mismatch.
- Reusing deprecated/archived taxes on posted documents without checking tags.
- Editing sequences manually; use Resequence.
