# Taxes, fiscal positions, e-invoicing

_URLs follow the 19.0 layout (20.0 pages could not be fetched when this was adapted; verify in 20.0 docs). Items marked "(confirmed)" were confirmed on the 19.0 docs and carried over._

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
- The partner needs the right country and tax ID for auto-detection. In 20 the VAT-number validation module `base_vat` is removed, so check how an invalid or empty VAT number affects "VAT required" matching (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html).
- Branches follow the parent's localization, hence the parent's fiscal behavior (confirmed).

## E-invoicing / EDI
- Landscape (general; verify per country): (a) generic structured formats (UBL/Peppol-type) via shared account modules; (b) country mandates with government portals, certificates or clearance; (c) none required.
- Typical components: format generation, partner identifiers, company/journal configuration, credentials or certificates, send/status flow, error handling.
- Treat as a workstream: legal requirement, sandbox credentials, test invoices, go-live date, rollback plan.
- Pages to read, not assume: https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations/<country>.html for germany, belgium, india, argentina, united_states (ported from the 19.0 layout).
- Which e-invoicing format/module applies and how it is configured: (verify in 20.0 docs: the country page).
- Module availability can differ between Community and Enterprise; confirm before scoping.
- Partner identifiers used by e-invoicing (VAT, company registry, endpoint IDs) depend on clean tax-ID data; with `base_vat` and `base_iban` removed in 20, re-test identifier and bank-account validation before sending the first e-invoice.

## Verification checklist
- Post a sample per tax and per fiscal position; compare tax report boxes to expectations.
- Credit notes reverse tags correctly.
- The e-invoice file validates in the authority or sandbox validator.
- Numbering, archiving and retention rules satisfied where required (verify per country).
- A valid and an invalid VAT number and IBAN are handled as the country requires (verify in 20.0 docs).
