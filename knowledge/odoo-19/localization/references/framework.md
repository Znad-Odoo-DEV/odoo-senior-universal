# Framework: what an l10n package is

Confirmed (https://www.odoo.com/documentation/19.0/applications/finance/fiscal_localizations.html): fiscal localizations are country-specific modules for compliance with a country's fiscal requirements; they mainly serve Accounting and can matter for Point of Sale and eCommerce. After install you adjust the chart of accounts, activate the taxes you use, and configure country-specific statements and certifications.

## Typical contents (general Odoo knowledge; verify per country)
- Chart of accounts template (accounts, groups, account types).
- Taxes and tax groups with tags/repartition lines feeding the tax report.
- Fiscal positions (domestic, intra-community/export, etc., depending on country).
- Country-specific reports and statements; sometimes legal formats and exports.
- Sometimes: bank/payment formats, document types, partner tax-ID types, e-invoicing/EDI formats, POS or eCommerce adaptations.
- The main page does not list components (verify in 19.0 docs: the country page).

## How it loads (technical; verify against your source tree)
- Modules are conventionally named `l10n_<country code>` (e.g. `l10n_de`, `l10n_in`); related add-ons add suffixes for features (reports, EDI, POS...). List actual modules with `ls addons/ | grep l10n_` on your version.
- Chart/tax data ships as a template in the module and is instantiated into a company when the package is selected; the result is ordinary company-specific records.
- Each company can use a different localization; branches follow the parent company (confirmed).
- Generic modules (account, shared e-invoice formats) provide the engine; l10n modules add country data and rules.

## Rules for extension
- Never modify shipped modules; create `l10n_xx_custom` depending on the l10n module and add accounts/taxes/positions with new XML ids.
- Prefer UI configuration for one-off tax/account changes in a single database.
- Templates can change between versions; review release notes and the country page after an upgrade (verify in 19.0 docs: country page).
