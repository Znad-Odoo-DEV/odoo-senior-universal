# Data migration

Official guide: https://www.odoo.com/documentation/19.0/applications/essentials/export_import_data.html

## Strategy
1. Scope: what moves (master data, open documents, balances) vs what stays archived in the legacy system. Less is safer.
2. A data owner per object; cleanse in the source (dedupe, standardize country/currency/UoM, fill mandatory fields) before import.
3. Mapping sheet per model: source field, Odoo field, transform, default, validation, owner.
4. Dry runs on a duplicate/staging database; time each; reconcile; fix the source or the transform, never hand-patch the target.
5. Final load in the cutover window after the freeze.

## Load order (dependencies first)
Companies, currencies, chart of accounts/taxes/fiscal positions, payment terms, users/employees -> partners -> product categories, UoM, products/variants, pricelists, vendor prices -> warehouses/locations, BOMs, routes -> open orders -> stock quantities -> open invoices/payments -> opening balances.

## Export/import mechanics (confirmed on the doc)
- Export from list view: Action > Export; the import-compatible option limits fields to re-importable ones; CSV or XLS; field selections can be saved as templates.
- Import: Action > Import records; download a template with preconfigured mappings; flow: upload, adjust CSV options, check column mapping, Test, then Import.
- Imports cannot be undone; find imported records by created-on/last-modified filters. Back up or work on a duplicate first.
- Formats: CSV, xls, xlsx (formatting options only for CSV). Large files can time out: split into batches.
- Developer mode adds Advanced import options (tracking history during import, which slows it; matching on subfields).

## External IDs
- The `External ID` column gives each row a stable key. Re-importing the same file with the same IDs updates records instead of duplicating them.
- Use a namespaced scheme such as `legacy_partner_1042`. Duplicate IDs cause conflicts (confirmed).
- Relations: reference related records by external ID (`field/id`, e.g. `parent_id/id`) or by name; names can be ambiguous, so prefer external IDs.
- Keep the legacy-key to external-ID mapping: it enables delta loads and reconciliation.
- Many2one/many2many/one2many handling and image imports: verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/essentials/export_import_data.html

## Validation
- Row counts per model, source vs Odoo (including archived).
- Totals: receivables/payables by partner, stock valuation by product/location, inventory quantities, open order values.
- Spot-check sample records end to end (a customer, a product, an open order).
- Odoo trial balance equals legacy trial balance at the cutover date.
- Business sign-off on a reconciliation pack per dry run.

## Opening balances
- Choose a cutover date at a period end. Opening method and lock dates: verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/finance/accounting.html
- Typical approach: receivables/payables as open invoices/bills by partner (enables payment matching), bank balances via statements or opening entry, other balances via one opening journal entry, inventory via adjustment at cost, fixed assets via asset records. Keep entries balanced; use a temporary clearing account and clear it to zero.
- Agree treatment with the accountant/auditor before loading. Set a lock date after validating the opening.

## Freeze
- Announce dates: master data freeze, transaction freeze (final delta window), customization freeze.
- Capture changes after the last dry run as a delta file keyed by external ID.
- Keep the legacy system read-only after go-live for reference.

## Tips
- Verify translated fields and country/state values (use codes or exact names).
- Limit side effects during bulk import (mail notifications, tracking); validate on a copy first.
- Watch duplicates in barcodes, SKUs, VAT numbers, bank accounts.
- Archive bad records instead of deleting.
