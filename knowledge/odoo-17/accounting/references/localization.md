# Fiscal Localization Packages

Docs: https://www.odoo.com/documentation/17.0/applications/finance/fiscal_localizations.html
(country pages: .../fiscal_localizations/<country>.html, e.g. .../fiscal_localizations/france.html)

## What a package provides
- Chart of accounts (account codes, types, tags), taxes with repartition lines and tax-grid tags, fiscal positions, default journals, tax return and statutory statement structures, and country-specific features (e-invoicing formats, bank formats, legal numbering, tax ID validation, reports such as Intrastat/SAF-T/VAT lists where applicable).
- Packages are modules named `l10n_<country>` (e.g., l10n_fr, l10n_be, l10n_us, l10n_ae, l10n_sa); additional modules per country add e-invoicing, reports, payroll, or POS fiscal devices (e.g. `l10n_<country>_edi`, `l10n_<country>_reports`). Some are Enterprise-only.

## How it is applied
- Selected per company: Accounting > Configuration > Settings > Fiscal Localization > Package (or at company creation/database setup from the company's country).
- Installation loads the chart template into the company; install **before** posting entries. Once journal entries exist, switching packages is restricted and only done with care (verify in 17.0 docs: fiscal_localizations.html).
- Multi-company: each company has its own package; branches share the parent chart (verify in 17.0 docs). Intercompany rules and consolidation are separate configuration.
- Updating: module upgrades can add new taxes/accounts to the chart template; they are not auto-applied to existing companies with data — review via the "update chart template" mechanism if your version offers it (verify in 17.0 docs).

## Choosing one
1. Match the company's country of tax residence (not its customers'); a company needs one package.
2. Prefer an official Odoo package over generic; "Generic Chart of Accounts" only when none exists (the result is a skeleton; add taxes and a statutory mapping yourself).
3. Check the country page for: supported taxes/e-invoicing/e-reporting mandates, required additional modules, and edition requirements.
4. Check the EDI/e-reporting mandate calendar of the country (e.g., Peppol, SDI, ZATCA, GST e-invoicing, FacturX); install and configure the EDI module and company identifiers (tax ID, Peppol ID, certificates) before go-live.
5. For multinational groups: choose per-company package, align parent account mapping through consolidation (.../get_started/consolidation.html).

## Post-install checklist
- Verify company country, currency, tax ID, fiscal year end.
- Review default taxes (sales/purchase) and archive unused ones; confirm tax-grid tags exist on all taxes.
- Confirm fiscal positions (domestic, EU B2B, export) and automatic detection rules.
- Set journals: sequences, bank accounts, payment methods, e-invoice formats.
- Configure tax return periodicity and lock dates.
- Create a test invoice/bill; check journal entry accounts and the tax return grids.
- Load opening balances only after the chart is final.

## Common issues
- Wrong package selected at company creation -> clean database or restricted migration; avoid by planning first.
- Missing country module (e.g., statutory reports or EDI) -> install the specific `l10n_*` add-on.
- Taxes appearing in the wrong return line -> check repartition tags and country-specific tax groups.
- Local legal requirements (hash chain, numbering, e-signatures) are package-specific: read the country page before customizing.
