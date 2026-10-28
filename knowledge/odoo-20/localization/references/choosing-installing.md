# Choosing and installing a localization

_URLs follow the 19.0 layout (20.0 pages could not be fetched when this was adapted; verify in 20.0 docs). Items marked "(confirmed)" were confirmed on the 19.0 docs and carried over._

## Choosing
1. Identify the legal entity's country (the fiscal country), not where customers are. One company = one localization; other countries = other companies (branches follow the parent).
2. Check the full country list on https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html and open that country's page (e.g. .../fiscal_localizations/germany.html) for scope, e-invoicing, certifications.
3. If no dedicated package exists, use a generic package and plan a custom chart/taxes in a custom module (verify in 20.0 docs: the main page for the current country list).
4. If several packages exist for one country, pick by the legal reporting you must file; confirm with the accountant.

## Before install
- Company: country, address, currency, VAT/tax ID set correctly. `base_vat` is removed in 20, so how the tax ID is validated on entry must be checked, not assumed (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html).
- Fiscal year, lock dates and accounting dates agreed with the accountant.
- Decide how opening balances will come in (import after install). In 20, bank-impacting journal entries must originate from bank transactions, so bank opening balances cannot be a manual entry on a bank journal; load them through bank transactions (exact method: verify in 20.0 docs).
- Work in a staging copy first.
- Confirm no entry is posted yet: the package can only be changed before any entry is posted (confirmed).

## Install
- Installing the related app should auto-install the core modules for the company's country; extra modules can be installed from Apps (confirmed).
- Check or change at Accounting > Configuration > Settings > Fiscal Localization > Package (confirmed).
- Multi-company: switch to each company and set/verify its package separately.

## After install
1. Review the chart of accounts; rename/add accounts per the accountant. Do not delete accounts used by taxes or defaults. In 20, parent accounts replace account groups: check how the template structures them.
2. Activate only the taxes you will use; verify rates against the official source.
3. Check default accounts: receivable/payable, income/expense, tax accounts, journals, exchange difference.
4. Configure country statements/certifications and e-invoicing: credentials, certificates, formats (confirmed as required follow-up; details per country page).
5. Test: customer invoice, vendor bill, credit note, payment, tax report, e-invoice, fiscal positions. Include a valid and an invalid VAT number and IBAN (their validation moved with the removal of `base_vat` / `base_iban`: verify in 20.0 docs).
6. Import opening balances and open items last.

## Pitfalls
- Wrong country on the company before install loads the wrong package.
- Posting test entries in production, then wanting another package.
- Activating all taxes "just in case"; it pollutes selection and reports.
- Deleting shipped accounts or taxes referenced by tags/defaults.
- Custom modules that still depend on `base_vat` / `base_iban` (removed in 20): they will not install.
