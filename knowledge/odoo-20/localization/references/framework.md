# Framework: what an l10n package is

Confirmed on the 19.0 version of https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html (20.0 page not fetched; verify in 20.0 docs): fiscal localizations are country-specific modules for compliance with a country's fiscal requirements; they mainly serve Accounting and can matter for Point of Sale and eCommerce. After install you adjust the chart of accounts, activate the taxes you use, and configure country-specific statements and certifications.

## Typical contents (general Odoo knowledge; verify per country)
- Chart of accounts template (accounts, account types, and the account structure: parent accounts in 20, which replace account groups).
- Taxes and tax groups with tags/repartition lines feeding the tax report.
- Fiscal positions (domestic, intra-community/export, etc., depending on country).
- Country-specific reports and statements; sometimes legal formats and exports.
- Sometimes: bank/payment formats, document types, partner tax-ID types, e-invoicing/EDI formats, POS or eCommerce adaptations.
- The main page does not list components (verify in 20.0 docs: the country page).

## How it loads (technical; verify against your source tree)
- Modules are conventionally named `l10n_<country code>` (e.g. `l10n_de`, `l10n_in`); related add-ons add suffixes for features (reports, EDI, POS...). List actual modules with `ls addons/ | grep l10n_` on your version.
- Chart/tax data ships as a template in the module and is instantiated into a company when the package is selected; the result is ordinary company-specific records.
- Each company can use a different localization; branches follow the parent company (confirmed).
- Generic modules (account, shared e-invoice formats) provide the engine; l10n modules add country data and rules.
- Removed in 20.0: `base_vat` and `base_iban` (VAT-number and IBAN validation in 19), and `l10n_fr_hr_work_entry_holidays` (with `hr_work_entry_holidays`; payroll work entries are removed). Where the validation logic and country payroll leave-handling live now: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html).

## Rules for extension
- Never modify shipped modules; create `l10n_xx_custom` depending on the l10n module and add accounts/taxes/positions with new XML ids.
- Do not add `base_vat` or `base_iban` to `depends`: they no longer exist in 20.
- Security files in a custom module use `ir.access.csv` (`id,name,model_id,group_id/id,operation,domain`) in 20; `ir.model.access.csv` and `ir.rule` are merged into `ir.access`.
- Prefer UI configuration for one-off tax/account changes in a single database.
- Templates can change between versions; review release notes (https://www.odoo.com/odoo-20-release-notes) and the country page after an upgrade (verify in 20.0 docs: country page).
