# Taxes, fiscal positions, e-invoicing

## Taxes
- Start from shipped taxes; activate those needed (confirmed: activate the taxes you use).
- Review: type (sales/purchase), computation (percent, fixed, group), price-included, tax group, repartition lines (base/tax, accounts, tags), tax scope, cash-basis settings.
- Tags/repartition drive the tax report; changing them alters reported boxes. Change only via a custom module or with accountant sign-off.
- Rates, exemptions and reverse-charge rules are legal facts: verify with the authority or the country doc page, not memory.
- Rounding: check the company tax rounding setting (per line vs globally) against local law.

## Fiscal positions
- Map taxes (and optionally accounts) by partner situation: domestic, intra-community, export, special regimes (varies by country).
- Applied automatically by criteria (country/group, VAT required, zip) or set manually on partner/document.
- Use shipped positions where present; verify their auto-apply criteria on the country page.
- The partner needs the right country and tax ID for auto-detection.
- Branches follow the parent's localization, hence the parent's fiscal behavior (confirmed).

## E-invoicing / EDI
- Landscape (general; verify per country): (a) generic structured formats (UBL/Peppol-type) via shared account modules; (b) country mandates with government portals, certificates or clearance; (c) none required.
- Typical components: format generation, partner identifiers, company/journal configuration, credentials or certificates, send/status flow, error handling.
- Treat as a workstream: legal requirement, sandbox credentials, test invoices, go-live date, rollback plan.
- Pages to read, not assume: https://www.odoo.com/documentation/18.0/applications/finance/fiscal_localizations.html>.html for germany, belgium, india, argentina, united_states.
- Which e-invoicing format/module applies and how it is configured: (verify in 18.0 docs: the country page).
- Module availability can differ between Community and Enterprise; confirm before scoping.

## Verification checklist
- Post a sample per tax and per fiscal position; compare tax report boxes to expectations.
- Credit notes reverse tags correctly.
- The e-invoice file validates in the authority or sandbox validator.
- Numbering, archiving and retention rules satisfied where required (verify per country).
