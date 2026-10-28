# Products and Pricing (Odoo 17)

Base: https://www.odoo.com/documentation/17.0/applications/sales/
Pages (verify paths in 17.0 docs): sales/products_prices/products/import.html, products/variants.html, prices/pricing.html, prices/currencies.html, prices/discounts.html, returns.html, ewallets_giftcards.html, loyalty_discount.html

## Products
- Product template vs product.product (variant). Type (storable product / consumable / service; combo products are a later addition) and invoicing policy decide delivery, invoice and project behavior. Exact 17.0 type names and tracking options: (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/sales/sales/products_prices/products/variants.html).
- Import in bulk from a template file; set external IDs so re-imports update (import.html).
- Keep sales description (quote text) separate from internal notes.

## Variants
- Attribute "create variants" modes (instantly / dynamically / never) control whether SKUs exist. Use never/dynamic for free-form attributes (variants.html).
- Extra price per attribute value adjusts list price; exclusions block invalid combinations.
- Large combinatorics hurt performance; model as custom values or separate templates.

## Pricelists
- Enabled in Sales settings (multiple prices per product, or advanced rules with discounts and formulas). Rules by product/category/variant, min quantity, date range, based on list price, cost, or another pricelist; compute modes fixed, discount, formula (pricing.html).
- Assigned per customer or by country group/website; the order takes the default from the partner.
- Currency-specific pricelists depend on Accounting currencies and rates (currencies.html).
- Discount shown to customer vs hidden (pricelist discount policy): (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/sales/sales/products_prices/prices/pricing.html).

## Discounts and loyalty
- Line discount (%) needs the discount setting/group; use for negotiated cuts (discounts.html).
- Programs: promotions, coupons, gift cards, eWallet, loyalty points (loyalty_discount.html, ewallets_giftcards.html). Reward lines are order lines; check tax and invoicing on them.
- Returns and refunds: return picking plus credit note, linked to the order (returns.html).

## Taxes link
- Taxes and fiscal positions are defined in Accounting; the product holds default sales taxes, the partner's fiscal position remaps them. Tax-included vs excluded is set per tax. Never hardcode tax logic in Sales; see the accounting skill.

## Pitfalls
- Overlapping pricelist rules: test with real quantities and dates; do not assume order of evaluation.
- Changing list price does not alter confirmed orders.
- Stacking of pricelist, line discount and loyalty rewards: test final total and margin.
