# Vendor pricelists (Odoo 17)
Docs (verify path in 17.0 docs): https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/purchase/products/pricelist.html
Validity-date and currency sections were not read: (verify in 17.0 docs: same URL).

Pricelist lines auto-fill the unit price on RFQ/PO lines. Enter on product > Purchase tab, or bulk import XLSX/CSV.

## Fields (technical)
partner_id (Vendor, only required), product_tmpl_id, min_qty (Quantity, minimum order qty), price (Unit Price), delay (Lead Time, days), sequence (vendor order), company_id, id (External ID).
Quantity column hidden by default in the list: enable via the adjust icon.

## Export / import
- Vendor Pricelists list (menu location: verify in 17.0 docs: same URL) > select > Actions > Export. Save field selections as templates; dev mode shows technical names.
- Tick "update data" on export to get External ID columns.
- Import: gear icon > Import records > map fields > Import.
- With External ID: updates existing rows. Without: creates new rows (duplicate risk).
- Docs recommend exporting first and editing the exported file as the template. Covers updating prices, adding vendor lines to existing products, multiple vendors per product.

## Senior notes
- Several lines per vendor/product with different min_qty implement quantity tiers; sequence breaks ties between vendors.
- Blanket orders inject vendor lines automatically (see agreements.md); avoid hand-maintaining a competing line.
