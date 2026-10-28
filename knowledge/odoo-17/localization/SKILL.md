---
name: localization
description: Senior Odoo 17 fiscal localization expertise. Use for Odoo 17 country localizations — what an l10n package provides, choosing and installing one, chart-of-accounts templates and taxes, e-invoicing/EDI, and a repeatable approach to set up accounting for any country.
---

# Odoo 17 Fiscal Localization (senior)

Grounded in the Odoo 17 docs page https://www.odoo.com/documentation/17.0/applications/finance/fiscal_localizations.html. Anything not confirmed there is marked "(verify in 17.0 docs: <url>)". Never state country tax rates, legal deadlines or mandates from memory; check the country page and the official authority.

## Mindset
- Localization-first: for accounting, start from the country's l10n package. Never hand-build a chart of accounts or tax set the package already ships.
- Verify per country: packages differ widely in depth (reports, e-invoicing, certifications). Read that country's doc page before promising scope.
- Keep core clean: do not edit l10n data or core modules. Extend with a small custom module, or configure in the UI (activate taxes, rename accounts, add fiscal positions).
- Decide early: the package can only be switched before any entry is posted.

## Principles
1. One company = one country localization. Different countries mean separate companies. Odoo 17 has no "branch company" concept (it arrives in Odoo 18, where branches follow the parent's localization); in 17 model each legal entity/country as its own company.
2. Check Accounting > Configuration > Settings > Fiscal Localization > Package first; Odoo normally auto-installs the package matching the company country.
3. Set company country, currency and tax ID/VAT correctly BEFORE installing or loading the package.
4. After install: review the chart of accounts, activate only the taxes you actually use, then configure country statements/certifications and e-invoicing.
5. Keep shipped tax groups, tags and repartition lines; they feed the tax report. Activating a shipped tax beats duplicate-and-edit.
6. Fiscal positions map taxes/accounts per partner situation; build on shipped ones where available.
7. E-invoicing/EDI is country- and format-specific, often with extra modules, certificates or government portal credentials; plan it as its own workstream.
8. Test in a staging copy with a realistic cycle (invoice, credit note, payment, tax report, e-invoice send) before go-live.
9. Official country doc pages are the source of truth; a pattern from one country does not transfer to another.
10. Multi-company: install and verify the localization per company.

## References
- references/framework.md: what an l10n package contains, how it loads, module families.
- references/choosing-installing.md: choosing the package, install order, before/after checklists.
- references/taxes-einvoicing.md: tax setup, fiscal positions, e-invoicing/EDI landscape.
- references/country-approach.md: step-by-step method for any country plus representative examples and what to verify.

Confirmed URLs: the main page above and country pages under https://www.odoo.com/documentation/17.0/applications/finance/fiscal_localizations/ (argentina, belgium, germany, india, united_states, each `.html`).
