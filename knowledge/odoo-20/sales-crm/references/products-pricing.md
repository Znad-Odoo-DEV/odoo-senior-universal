# Products and Pricing (Odoo 20)

Base: https://www.odoo.com/documentation/20.0/applications/sales/
Pages (ported from the 19.0 layout, verify in 20.0 docs): sales/products_prices/products/import.html, products/variants.html, prices/pricing.html, prices/currencies.html, prices/discounts.html, returns.html, ewallets_giftcards.html, loyalty_discount.html

## Products
- Product template vs product.product (variant). Type (goods/service/combo) and invoicing policy decide delivery, invoice and project behavior. Exact 20.0 type names and tracking options: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/sales/products_prices/products/variants.html).
- Import in bulk from a template file; set external IDs so re-imports update (import.html).
- Keep sales description (quote text) separate from internal notes.

## Variants
- Attribute "create variants" modes (instantly / dynamically / never) control whether SKUs exist. Use never/dynamic for free-form attributes (variants.html).
- Extra price per attribute value adjusts list price; exclusions block invalid combinations.
- Large combinatorics hurt performance; model as custom values or separate templates.

## Pricelists
- Enabled in Sales settings. Rules by product/category/variant, min quantity, date range, based on list price, cost, or another pricelist; compute modes fixed, discount, formula (pricing.html).
- Assigned per customer or by country group/website; the order takes the default from the partner.
- Currency-specific pricelists depend on Accounting currencies and rates (currencies.html).
- Discount shown to customer vs hidden: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/sales/products_prices/prices/pricing.html).

## Discounts and loyalty
- Line discount (%) needs the discount setting/group; use for negotiated cuts (discounts.html).
- Programs: promotions, coupons, gift cards, eWallet, loyalty points (loyalty_discount.html, ewallets_giftcards.html). Reward lines are order lines; check tax and invoicing on them.
- Returns and refunds: return picking plus credit note, linked to the order (returns.html).

## Taxes link
- Taxes and fiscal positions are defined in Accounting; the product holds default sales taxes, the partner's fiscal position remaps them. Tax-included vs excluded is set per tax. Never hardcode tax logic in Sales; see the accounting skill.
- Customer VAT-number validation drives fiscal-position detection; the `base_vat` module is removed in 20, so re-test partner VAT validation and automatic fiscal-position selection on quotes (see the accounting skill; verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/taxes/vat_verification.html).

## Pitfalls
- Overlapping pricelist rules: test with real quantities and dates; do not assume order of evaluation.
- Changing list price does not alter confirmed orders.
- Stacking of pricelist, line discount and loyalty rewards: test final total and margin.
