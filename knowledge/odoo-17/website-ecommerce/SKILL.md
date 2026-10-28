---
name: website-ecommerce
description: Senior Odoo 17 Website and eCommerce expertise. Use for Odoo 17 Website — the builder, pages and themes — and eCommerce — product catalog, cart and checkout, payment providers, delivery methods, and SEO.
---

# Odoo 17 Website & eCommerce (senior)

## Mindset
- A storefront is an order-to-cash front end: every shop decision touches Sales, Inventory, Accounting and Payment. Design the back-office flow first, then the page.
- Prefer configuration and builder blocks over custom QWeb/JS. Custom code is a last resort and must survive upgrades (inherit views via `website.layout`-based templates, never edit core). Frontend JS in 17 is `publicWidget` (`publicWidget.registry`); the `Interaction` framework is Odoo 18+ and JS unit tests are QUnit, not Hoot.
- Test as three personas: anonymous visitor, logged-in portal customer (own pricelist/fiscal position), and shop manager. Many bugs are persona-specific (pricelist, geo, cache).
- Verify settings names against the live 17.0 UI; menus move between versions (the website builder UI was reworked in 18/19, so 19 screenshots and labels may not match). Anything not confirmed below is flagged "(verify in 17.0 docs: <url>)".

## Principles
1. **Website setup**: pick the theme and website settings early (Website > Configuration > Settings); changing theme late forces rework of blocks. Multi-website: restrict records (products, categories, delivery methods, payment providers, pages) with the Website field; empty = shared across all sites.
2. **Pages vs views**: pages are `website.page` records with a URL, publish flag and indexing flag; menus are `website.menu` (mega menus, per-website). Unpublished is not private: restrict by visibility/group when content is sensitive.
3. **Catalog**: one `product.template` per sellable concept; variants from attributes. Keep variant count small (combinatorial explosion hurts performance); use "Never create" / dynamic creation for large attribute sets and instant creation only when per-variant stock/images/price extras are needed up front.
4. **Pricing**: pricelists drive B2C/B2B pricing, currency and country groups; tax display (included/excluded) is a website setting, tax computation follows fiscal position. Decide B2B vs B2C (customer accounts, login required, price visibility) before launch.
5. **Checkout**: steps are Order summary, Address, optional Extra Info, Payment, Confirmation. Express checkout appears only when the provider supports it. Guest vs mandatory account is a setting; align it with invoicing/legal needs (VAT, company data).
6. **Payments**: each provider (`payment.provider` in 17; "acquirer" in 16 and earlier) needs its own state (Disabled / Enabled / Test mode), journal, currencies, countries, and (for webhooks) a reachable, HTTPS `web.base.url`. Test in test mode end to end, including failed and cancelled payments, then reconcile in Accounting.
7. **Delivery**: carrier integrations (FedEx, UPS, DHL, USPS, bpost, Easypost, Sendcloud; Envia.com and Gelato are newer 18/19 integrations, verify in 17.0 docs) and custom methods (fixed price, rule-based, Click & Collect). Products need weight/dimensions for rate computation; services cannot be shipped or collected.
8. **Stock**: product availability options (continue selling, show stock, out-of-stock message) must match warehouse reality; Click & Collect needs a full warehouse address and stock at that location.
9. **SEO & performance**: unique title/description per page and product, clean URL slugs, one H1, alt text, sitemap, structured data, redirects on slug change (301), image sizing/WebP, minimal custom JS, CDN/cache awareness. Never mix marketing tweaks into the theme base file.
10. **Go-live checklist**: domain + HTTPS, `web.base.url` and `web.base.url.freeze`, outgoing mail, cookie banner/legal pages, payment providers switched out of test mode, delivery rates validated, tax/fiscal positions checked, test order refunded, robots/indexing on, analytics connected.

## Common pitfalls
- Provider in Test mode left on in production; or webhook blocked by auth proxy/IP restrictions.
- Pricelist not assigned to country group so visitors see the wrong currency.
- Variants "instantly" created for huge attribute matrices; slow product form and shop.
- Record published on website A but "Website" empty, leaking onto website B.
- Delivery method without a rate/weight set returns "no shipping method available" at checkout.
- Editing views by the builder on a multi-website DB creates website-specific COW views; later module upgrades do not update them. Prefer module-level changes for shared code.
- Cached anonymous pages hide personalised content; test logged-in and in a private window.
- Custom templates written for 18/19 (`t-name="card"`, `<list>`, `<chatter/>`, Interactions) do not load in 17: use `kanban-box`, `<tree>`, the `oe_chatter` div and `publicWidget`.

## References
Read the file matching the task; they are short.
- `references/website-builder.md` — pages, blocks, themes, menus, multi-website, forms, custom frontend code.
- `references/ecommerce-catalog.md` — products, variants, categories, pricelists, stock display.
- `references/checkout-payments.md` — cart, checkout steps, express checkout, payment providers.
- `references/delivery-shipping.md` — delivery methods, carriers, Click & Collect.
- `references/seo-performance.md` — SEO, URLs, redirects, speed, Google Merchant Center.

Odoo 17.0 doc roots (landing pages are stable; deeper sub-page paths in the references were ported from the newer-version doc set, so verify they resolve in 17.0):
- Website: https://www.odoo.com/documentation/17.0/applications/websites/website.html
- eCommerce: https://www.odoo.com/documentation/17.0/applications/websites/ecommerce.html
