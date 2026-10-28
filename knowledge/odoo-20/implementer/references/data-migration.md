# Data migration

_20.0 doc pages could not be fetched when this was adapted: URLs follow the 19.0 layout (verify in 20.0 docs). Items marked "(confirmed)" were confirmed on the 19.0 docs and carried over._

Official guide: https://www.odoo.com/documentation/20.0/applications/essentials/export_import_data.html

## Strategy
1. Scope: what moves (master data, open documents, balances) vs what stays archived in the legacy system. Less is safer.
2. A data owner per object; cleanse in the source (dedupe, standardize country/currency/UoM, fill mandatory fields) before import.
3. Mapping sheet per model: source field, Odoo field, transform, default, validation, owner.
4. Dry runs on a duplicate/staging database; time each; reconcile; fix the source or the transform, never hand-patch the target.
5. Final load in the cutover window after the freeze.

## Load order (dependencies first)
Companies, currencies, chart of accounts (parent accounts replace account groups in 20)/taxes/fiscal positions, payment terms, users/employees -> partners -> product categories, UoM, products/variants, pricelists, vendor prices -> warehouses/locations, BOMs, routes -> open orders -> stock quantities -> open invoices/payments -> opening balances.

## Export/import mechanics (confirmed on the 19.0 doc)
- Export from list view: Action > Export; the import-compatible option limits fields to re-importable ones; CSV or XLS; field selections can be saved as templates.
- Import: Action > Import records; download a template with preconfigured mappings; flow: upload, adjust CSV options, check column mapping, Test, then Import.
- Imports cannot be undone; find imported records by created-on/last-modified filters. Back up or work on a duplicate first.
- Formats: CSV, xls, xlsx (formatting options only for CSV). Large files can time out: split into batches.
- Developer mode adds Advanced import options (tracking history during import, which slows it; matching on subfields). Tracking values are removed in 20 and tracking messages are built on the fly, so check how the tracking option behaves on 20.0 (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/essentials/export_import_data.html).

## External IDs
- The `External ID` column gives each row a stable key. Re-importing the same file with the same IDs updates records instead of duplicating them.
- Use a namespaced scheme such as `legacy_partner_1042`. Duplicate IDs cause conflicts (confirmed).
- Relations: reference related records by external ID (`field/id`, e.g. `parent_id/id`) or by name; names can be ambiguous, so prefer external IDs.
- Keep the legacy-key to external-ID mapping: it enables delta loads and reconciliation.
- Many2one/many2many/one2many handling and image imports: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/essentials/export_import_data.html

## Validation
- Row counts per model, source vs Odoo (including archived).
- Totals: receivables/payables by partner, stock valuation by product/location, inventory quantities, open order values.
- Spot-check sample records end to end (a customer, a product, an open order).
- Odoo trial balance equals legacy trial balance at the cutover date.
- Business sign-off on a reconciliation pack per dry run.

## Opening balances
- Choose a cutover date at a period end. Opening method and lock dates: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting.html
- Typical approach: receivables/payables as open invoices/bills by partner (enables payment matching), other balances via one opening journal entry, inventory via adjustment at cost, fixed assets via asset records. Keep entries balanced; use a temporary clearing account and clear it to zero.
- Bank balances: in 20, bank-impacting journal entries must originate from bank transactions, so a manual opening entry on a bank journal is not an option. Load bank opening balances through bank transactions/statements (exact method: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting.html) and agree it with the accountant before the dry run.
- Open employee expenses: expenses become draft vendor bills in 20, so decide whether pending expenses are migrated as draft vendor bills or settled in the legacy system (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/expenses.html).
- Agree treatment with the accountant/auditor before loading. Set a lock date after validating the opening.

## Freeze
- Announce dates: master data freeze, transaction freeze (final delta window), customization freeze.
- Capture changes after the last dry run as a delta file keyed by external ID.
- Keep the legacy system read-only after go-live for reference.

## Tips
- Verify translated fields and country/state values (use codes or exact names).
- Limit side effects during bulk import (mail notifications, tracking); validate on a copy first.
- Watch duplicates in barcodes, SKUs, VAT numbers, bank accounts.
- VAT numbers and IBANs: `base_vat` and `base_iban` are removed in 20, so test how imported VAT numbers and bank account numbers are validated (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html) and clean them in the source first.
- If the legacy data comes from a Field Service, payroll work-entry or batch-picking setup, map it to the 20 equivalents (Planning, payslip inputs, core `stock` batches) rather than importing the old structures.
- Archive bad records instead of deleting.
