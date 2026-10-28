---
name: website-ecommerce
description: Senior Odoo 20 Website and eCommerce expertise. Use for Odoo 20 Website — the builder, pages and themes — and eCommerce — product catalog, wishlist and comparison, cart and checkout, payment providers, delivery methods, and SEO.
---

# Odoo 20 Website & eCommerce (senior)

## Mindset
- A storefront is an order-to-cash front end: every shop decision touches Sales, Inventory, Accounting and Payment. Design the back-office flow first, then the page.
- Prefer configuration and builder blocks over custom QWeb/JS. Custom code is a last resort and must survive upgrades (inherit views via `website.layout`-based templates, never edit core).
- Test as three personas: anonymous visitor, logged-in portal customer (own pricelist/fiscal position), and shop manager. Many bugs are persona-specific (pricelist, geo, cache).
- Content here is ported from the 19.0 documentation; menu names move between versions. Verify settings names against the live 20.0 UI. Anything not confirmed below is flagged "(verify in 20.0 docs: <url>)".

## Odoo 20 changes that touch the storefront
- **Wishlist and product comparison are core eCommerce features.** The modules `website_sale_wishlist` and `website_sale_comparison` are merged into `website_sale`; there is no separate install or app dependency any more. Confirmed in 20.0 docs (https://www.odoo.com/documentation/20.0/applications/websites/ecommerce/ecommerce_design/additional_features.html): both are website-editor options, not Settings toggles. Compare: Style > Products Details > Compare (product page) and Product Design > Actions > Compare, Inline or On Hover (shop page), max four products. Wishlist: Style > Products Details > Wishlist (on by default on the product page), Product Design > Actions > Wishlist, Fixed or Fixed - On Hover (shop page), header Show/Hide Elements > Wishlist, and Style > Wishlist Page. The module merge into `website_sale` itself is not stated on that page.
- **`delivery_mondialrelay` is removed.** No Mondial Relay carrier in 20; see `references/delivery-shipping.md` for replacing existing methods.
- Custom modules: drop `website_sale_wishlist`, `website_sale_comparison` and `delivery_mondialrelay` from manifest `depends` (use `website_sale`); an unresolved dependency blocks the module on 20.
- Custom shop code must follow the 20 platform: security in `ir.access.csv` (ACLs and record rules merged into `ir.access`), public `read_group(domain, groupby, aggregates, having, offset, limit, order)` (old `fields=`/`lazy=` calls break), OWL 3 for frontend components (22-change migration guide; compat layer is temporary). Public-site JS keeps the `Interaction` framework.
- Hosting baseline: Python >= 3.12, PostgreSQL >= 16.
- Invoice/payment status labels were renamed in Accounting 20; re-check shop filters, reports and automations that match on them (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting.html).

## Principles
1. **Website setup**: pick the theme and website settings early (Website > Configuration > Settings); changing theme late forces rework of blocks. Multi-website: restrict records (products, categories, delivery methods, payment providers, pages) with the Website field; empty = shared across all sites.
2. **Pages vs views**: pages are `website.page` records with a URL, publish flag and indexing flag; menus are `website.menu` (mega menus, per-website). Unpublished is not private: restrict by visibility/group when content is sensitive.
3. **Catalog**: one `product.template` per sellable concept; variants from attributes. Keep variant count small (combinatorial explosion hurts performance); use "Never create" / dynamic creation for large attribute sets and instant creation only when attributes show on cards or need per-variant stock/images.
4. **Pricing**: pricelists drive B2C/B2B pricing, currency and country groups; tax display (included/excluded) is a website setting, tax computation follows fiscal position. Decide B2B vs B2C (customer accounts, login required, price visibility) before launch.
5. **Checkout**: steps are Order summary, Address, optional Extra Info, Payment, Confirmation. Express checkout appears only when the provider supports it. Guest vs mandatory account is a setting; align it with invoicing/legal needs (VAT, company data).
6. **Payments**: each provider needs its own state (Disabled / Enabled / Test mode), journal, currencies, countries, and (for webhooks) a reachable, HTTPS `web.base.url`. Test in test mode end to end, including failed and cancelled payments, then reconcile in Accounting.
7. **Delivery**: carrier integrations (FedEx, UPS, DHL, Sendcloud, Envia.com, Gelato) and custom methods (fixed price, rule-based, Click & Collect). Products need weight/dimensions for rate computation; services cannot be shipped or collected. Mondial Relay is not available in 20.
8. **Stock**: product availability options (continue selling, show stock, out-of-stock message) must match warehouse reality; Click & Collect needs a full warehouse address and stock at that location.
9. **SEO & performance**: unique title/description per page and product, clean URL slugs, one H1, alt text, sitemap, structured data, redirects on slug change (301), image sizing/WebP, minimal custom JS, CDN/cache awareness. Never mix marketing tweaks into the theme base file.
10. **Go-live checklist**: domain + HTTPS, `web.base.url` and `web.base.url.freeze`, outgoing mail, cookie banner/legal pages, payment providers switched out of test mode, delivery rates validated, tax/fiscal positions checked, test order refunded, robots/indexing on, analytics connected.

## Common pitfalls
- Provider in Test mode left on in production; or webhook blocked by auth proxy/IP restrictions.
- Pricelist not assigned to country group so visitors see the wrong currency.
- Variants "instantly" created for huge attribute matrices; slow product form and shop.
- Record published on website A but "Website" empty, leaking onto website B.
- Delivery method without a rate/weight set returns "no shipping method available" at checkout.
- Editing views by the builder on a multi-website DB creates website-specific COW views; later module upgrades do not update them. Prefer module-level changes for shared code. Check these copies before the 19 -> 20 upgrade, especially wishlist/comparison templates now owned by `website_sale`.
- Cached anonymous pages hide personalised content; test logged-in and in a private window.
- Upgrading a database that still has Mondial Relay delivery methods or custom modules depending on the merged modules.

## References
Read the file matching the task; they are short.
- `references/website-builder.md` — pages, blocks, themes, menus, multi-website, forms.
- `references/ecommerce-catalog.md` — products, variants, categories, wishlist/comparison, pricelists, stock display.
- `references/checkout-payments.md` — cart, checkout steps, express checkout, payment providers.
- `references/delivery-shipping.md` — delivery methods, carriers, Click & Collect, Mondial Relay removal.
- `references/seo-performance.md` — SEO, URLs, redirects, speed, Google Merchant Center.

Odoo 20.0 doc roots (ported from the 19.0 layout; verify in 20.0 docs):
- Website: https://www.odoo.com/documentation/20.0/applications/websites/website.html
- eCommerce: https://www.odoo.com/documentation/20.0/applications/websites/ecommerce.html
- Release notes: https://www.odoo.com/odoo-20-release-notes
