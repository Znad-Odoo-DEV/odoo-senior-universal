---
name: localization
description: Senior Odoo 20 fiscal localization expertise. Use for Odoo 20 country localizations — what an l10n package provides, choosing and installing one, chart-of-accounts templates and taxes, e-invoicing/EDI, VAT-number/IBAN validation now that base_vat and base_iban are removed, and a repeatable approach to set up accounting for any country.
---

# Odoo 20 Fiscal Localization (senior)

Anchored on the Odoo docs page https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html. The 20.0 pages could not be fetched when this was adapted: statements marked "(confirmed)" were confirmed on the 19.0 version of the page and carried over; anything else is marked "(verify in 20.0 docs: <url>)". Never state country tax rates, legal deadlines or mandates from memory; check the country page and the official authority.

## Mindset
- Localization-first: for accounting, start from the country's l10n package. Never hand-build a chart of accounts or tax set the package already ships.
- Verify per country: packages differ widely in depth (reports, e-invoicing, certifications). Read that country's doc page before promising scope.
- Keep core clean: do not edit l10n data or core modules. Extend with a small custom module, or configure in the UI (activate taxes, rename accounts, add fiscal positions).
- Decide early: the package can only be switched before any entry is posted.

## Principles
1. One company = one country localization. Different countries mean separate companies, not branches (branches follow the parent's localization).
2. Check Accounting > Configuration > Settings > Fiscal Localization > Package first; Odoo normally auto-installs the package matching the company country.
3. Set company country, currency and tax ID/VAT correctly BEFORE installing or loading the package. How the VAT number is validated in 20 is not confirmed (see "Odoo 20 changes" below).
4. After install: review the chart of accounts, activate only the taxes you actually use, then configure country statements/certifications and e-invoicing.
5. Keep shipped tax groups, tags and repartition lines; they feed the tax report. Activating a shipped tax beats duplicate-and-edit.
6. Fiscal positions map taxes/accounts per partner situation; build on shipped ones where available.
7. E-invoicing/EDI is country- and format-specific, often with extra modules, certificates or government portal credentials; plan it as its own workstream.
8. Test in a staging copy with a realistic cycle (invoice, credit note, payment, tax report, e-invoice send) before go-live.
9. Official country doc pages are the source of truth; a pattern from one country does not transfer to another.
10. Multi-company: install and verify the localization per company.

## Odoo 20 changes that touch localization
- **`base_vat` and `base_iban` are removed in 20.0.** In 19 they provided VAT-number validation and IBAN (bank account) validation, and l10n modules commonly depended on them. Where those checks live in 20, which formats/countries are validated, and whether any online check remains: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html). Test a valid and an invalid VAT number and IBAN per country in staging before promising behavior.
- Custom or third-party modules (including your own `l10n_xx_custom`) that list `base_vat` or `base_iban` in `depends` will not install on 20: remove the dependency, then re-test validation.
- Account groups are replaced by parent accounts in 20: review how the shipped chart template is structured and re-map any reporting that used groups (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html).
- Payroll: payroll work entries are removed in 20 and the modules `hr_work_entry_holidays` and `l10n_fr_hr_work_entry_holidays` no longer exist; check each country's payroll package on its country page (see the hr-payroll topic).
- Bank-impacting journal entries must originate from bank transactions: plan opening bank balances and bank/payment formats accordingly.
- Custom localization modules ship security as `ir.access.csv` (`id,name,model_id,group_id/id,operation,domain`) in 20, not `ir.model.access.csv` / `ir.rule`.

## References
- references/framework.md: what an l10n package contains, how it loads, module families.
- references/choosing-installing.md: choosing the package, install order, before/after checklists.
- references/taxes-einvoicing.md: tax setup, fiscal positions, e-invoicing/EDI landscape.
- references/country-approach.md: step-by-step method for any country plus representative examples and what to verify.

URLs (ported from the 19.0 layout; verify in 20.0 docs): the main page above and country pages under https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations/ (argentina, belgium, germany, india, united_states, each `.html`).
