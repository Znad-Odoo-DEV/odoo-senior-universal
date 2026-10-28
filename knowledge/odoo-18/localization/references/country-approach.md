# Method to localize ANY country

## Steps
1. Confirm entity facts: legal country, currency, VAT/tax ID, fiscal year, regulated sector, edition (Community/Enterprise), hosting (Online/Odoo.sh/on-premise).
2. Open https://www.odoo.com/documentation/18.0/applications/finance/fiscal_localizations.html, find the country, read its page end to end (modules, configuration, e-invoicing, reports).
3. List the actual `l10n_<code>*` modules on your version; note Enterprise-only ones.
4. Prepare a staging database; set company data (country, currency, tax ID) first.
5. Install/verify the package in Accounting settings; confirm chart and taxes loaded.
6. Review the chart of accounts with the accountant; map to legal reporting.
7. Activate needed taxes; review repartition/tags; verify rates against the authority.
8. Set fiscal positions; test with sample partners (domestic, foreign, exempt).
9. Configure country reports/certifications and e-invoicing (credentials, sandbox).
10. Configure payment/bank formats and POS/eCommerce taxes if used.
11. Run end-to-end tests; have the accountant sign off tax report output.
12. Load opening balances; go live; monitor the first filing period.
13. Document deviations in a custom module (never edit l10n).

## Representative examples (what to verify; no figures asserted)
Base URL: https://www.odoo.com/documentation/18.0/applications/finance/fiscal_localizations/ (links listed on the main page; individual pages not fetched).
- Germany (germany.html): chart variant used by the accountant, required tax reports/exports, e-invoicing obligations and dates (verify in 18.0 docs: germany.html).
- Belgium (belgium.html): VAT return and listings, structured payment references, e-invoicing/Peppol-type setup (verify in 18.0 docs: belgium.html).
- India (india.html): GST taxes and treatments, portal-based e-invoicing and e-way bill setup, credentials (verify in 18.0 docs: india.html).
- Argentina (argentina.html): document types, tax-authority web services and certificates, journal configuration (verify in 18.0 docs: argentina.html).
- United States (united_states.html): sales tax model (state/local), bank/check formats, need for a tax connector (verify in 18.0 docs: united_states.html).

## Acceptance criteria
- Package confirmed, taxes activated and validated, fiscal positions tested, tax report matches test entries, e-invoice (if required) accepted by validator/sandbox, accountant sign-off, customer changes isolated in a custom module.
