# eCommerce catalog: products, variants, categories, pricelists

Confirmed 18.0 docs:
- https://www.odoo.com/documentation/18.0/applications/websites/ecommerce.html
- https://www.odoo.com/documentation/18.0/applications/websites/ecommerce.html
- https://www.odoo.com/documentation/18.0/applications/websites/ecommerce.html
- https://www.odoo.com/documentation/18.0/applications/websites/ecommerce.html
- https://www.odoo.com/documentation/18.0/applications/websites/ecommerce.html
- https://www.odoo.com/documentation/18.0/applications/websites/ecommerce.html
- Design: https://www.odoo.com/documentation/18.0/applications/websites/ecommerce.html (product_page.html, catalog.html, additional_features.html under it)

## Products
- Publish a product with the Go to Website smart button / Published toggle; set Website field to restrict to one site.
- Sales tab, "Ecommerce shop" section: eCommerce categories (a product can sit in several), alternative products, accessory products, optional products, extra media.
- Stock behavior (storable goods): continue selling, show available quantity, out-of-stock message; hold until stock is physically available. Exact labels: verify in 18.0 docs: products.html.
- Services/digital: sell without delivery; services are not eligible for Click & Collect.
- Product page layout is edited in the website builder (images grid, zoom, description, tabs); "Ecommerce Description" is the website-specific rich description.

## Categories
- Website > eCommerce > eCommerce Categories: parent/child tree, website restriction, description, cover image. Categories drive the shop sidebar/top filters and URLs (`/shop/category/<slug>`).
- Keep depth shallow (2 levels is usually enough) and avoid categories with a single product.

## Variants and attributes
- Enable the Product Variants setting in Sales settings, then add attribute lines in the Attributes & Variants tab.
- Attribute display types (radio, pills, select, color, multi-checkbox) control the product page selector.
- Attribute options confirmed in docs: eCommerce Filter (Visible shows in shop filters), On Product Cards (Visible/Hover; requires instantly-created variants), Show Thumbnails (variant images replace value labels), attribute categories for the comparison view.
- Variant creation modes: Instantly, Dynamically (on first order), Never (no_variant, free text via custom values). Use Dynamically for big matrices; Instantly only when per-variant stock, barcode or price extra is needed up front. (verify in 18.0 docs: categories_variants.html)
- Price extra per attribute value adds to the template price; per-variant images improve conversion.
- Optional products appear in a modal after Add to Cart; accessories appear in the cart/checkout step.

## Pricelists and prices
- Enable Pricelists in Sales settings. Website > Configuration > Settings selects pricelist behavior; each pricelist has Website, Country Groups, Currency and Selectable flag.
- A visitor gets a pricelist from: customer-assigned > country-group match > website default. Selectable pricelists show a switcher.
- Rules: fixed, discount % or formula; min quantity gives tiered prices; strikethrough "compare to price" shows discounts.
- Taxes: tax-included vs tax-excluded display is a website setting; fiscal positions map taxes per country/VAT. Checkout recomputes on address.
- Hide prices / replace Add to Cart with Contact Us for quote-only products (confirmed in checkout.html: prices must be hidden first).

## B2B vs B2C
- B2B: login required (customer accounts mandatory), restricted prices, invoice address with VAT, pricelists per customer group, quote workflow.
- B2C: guest checkout, shorter forms. Decide in Settings > Customer Account (verify in 18.0 docs: customer_accounts.html and b2b_b2c.html).

## Import/maintenance tips
- Bulk import products with external IDs, categories and website via CSV; set attributes through variant import only after attributes exist.
- Archive rather than delete products with sales history.
- Check "Published" plus company/website match; mismatch is the top reason a product does not appear.
