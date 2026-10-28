# Fiscal Localization Packages

Docs (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html
(country pages: .../fiscal_localizations/<country>.html, e.g. .../fiscal_localizations/france.html)

## What a package provides
- Chart of accounts (account codes, types, tags), taxes with repartition lines and tax-grid tags, fiscal positions, default journals, tax return and statutory statement structures, and country-specific features (e-invoicing formats, bank formats, legal numbering, tax ID validation, reports such as Intrastat/SAF-T/VAT lists where applicable).
- Packages are modules named `l10n_<country>` (e.g., l10n_fr, l10n_be, l10n_us, l10n_ae, l10n_sa); additional modules per country add e-invoicing, reports, payroll, or POS fiscal devices (e.g. `l10n_<country>_edi`, `l10n_<country>_reports`). Some are Enterprise-only.

## Odoo 20: VAT and IBAN modules removed
- The `base_vat` and `base_iban` modules are removed in 20. Any custom or third-party module (including local `l10n_*` add-ons) that lists them in `depends` fails to load: update `depends` and inherited code.
- Do not assume VAT-number format validation, VIES checking, "VAT required" fiscal-position checks, or IBAN/bank-account validation behave as in 19, and do not assume they are gone: where each now lives and how strict it is per country must be read from the docs (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html).
- Test explicitly in the target database: create a partner with a valid, an invalid and an empty VAT number, and a partner bank account with a valid and an invalid IBAN; record what is accepted before relying on it in imports, EDI or SEPA flows.

## How it is applied
- Selected per company: Accounting > Configuration > Settings > Fiscal Localization > Package (or at company creation/database setup from the company's country).
- Installation loads the chart template into the company; install **before** posting entries. Once journal entries exist, switching packages is restricted and only done with care (verify in 20.0 docs: fiscal_localizations.html).
- Multi-company: each company has its own package; branches share the parent chart (verify in 20.0 docs). Intercompany rules and consolidation are separate configuration.
- Updating: module upgrades can add new taxes/accounts to the chart template; they are not auto-applied to existing companies with data — review via the "update chart template" mechanism if your version offers it (verify in 20.0 docs).
- Odoo 20 charts use parent accounts instead of account groups; package charts and statutory mappings follow that model (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/get_started/chart_of_accounts.html).

## Choosing one
1. Match the company's country of tax residence (not its customers'); a company needs one package.
2. Prefer an official Odoo package over generic; "Generic Chart of Accounts" only when none exists (the result is a skeleton; add taxes and a statutory mapping yourself).
3. Check the country page for: supported taxes/e-invoicing/e-reporting mandates, required additional modules, and edition requirements.
4. Check the EDI/e-reporting mandate calendar of the country (e.g., Peppol, SDI, ZATCA, GST e-invoicing, FacturX); install and configure the EDI module and company identifiers (tax ID, Peppol ID, certificates) before go-live.
5. For multinational groups: choose per-company package, align parent account mapping through consolidation (.../get_started/consolidation.html).

## Post-install checklist
- Verify company country, currency, tax ID (and how the 20 database validates it, see above), fiscal year end.
- Review default taxes (sales/purchase) and archive unused ones; confirm tax-grid tags exist on all taxes.
- Confirm fiscal positions (domestic, EU B2B, export) and automatic detection rules.
- Set journals: sequences, bank accounts, payment methods, e-invoice formats.
- Configure tax return periodicity and lock dates.
- Create a test invoice/bill; check journal entry accounts and the tax return grids.
- Load opening balances only after the chart is final. Bank/cash opening balances follow the 20 bank-transaction rule (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/bank.html).

## Common issues
- Wrong package selected at company creation -> clean database or restricted migration; avoid by planning first.
- Missing country module (e.g., statutory reports or EDI) -> install the specific `l10n_*` add-on.
- Module fails to install with a missing `base_vat` / `base_iban` dependency -> the module predates 20; port its `depends`.
- Taxes appearing in the wrong return line -> check repartition tags and country-specific tax groups.
- Local legal requirements (hash chain, numbering, e-signatures) are package-specific: read the country page before customizing.
