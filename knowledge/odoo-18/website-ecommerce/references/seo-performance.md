# SEO and performance

Confirmed 18.0 docs:
- Web design: https://www.odoo.com/documentation/18.0/applications/websites/website/web_design.html
- Structure: https://www.odoo.com/documentation/18.0/applications/websites/website/structure.html
- Configuration: https://www.odoo.com/documentation/18.0/applications/websites/website/configuration.html
- Reporting: https://www.odoo.com/documentation/18.0/applications/websites/website/reporting.html
- eCommerce performance: https://www.odoo.com/documentation/18.0/applications/websites/ecommerce/performance.html
- Google Merchant Center: https://www.odoo.com/documentation/18.0/applications/websites/ecommerce.html
- Dedicated SEO page (verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/websites/website/pages/seo.html)

## On-page SEO
- Website > Site > Optimize SEO (Promote tab): page title, description, keywords, Open Graph/Twitter image, indexing flag. Keep titles ~55-60 chars, descriptions ~150-160.
- One H1 per page; logical H2/H3 in blocks; descriptive alt text on images; meaningful link text.
- URL slugs: edit via the page/product URL; keep short and stable. Changing a slug should produce a 301 (redirects table: Website > Configuration > Redirects; verify in 18.0 docs). Avoid redirect chains.
- Products and categories: unique "Ecommerce Description", SEO title/description per product, one canonical URL (variants share the template URL).
- Multilingual: hreflang and language URL prefixes are generated for enabled website languages; translate SEO fields too.
- noindex for thank-you, cart, checkout, test pages.
- Structured data: product pages emit schema.org Product markup (price, availability); verify with Rich Results Test.

## Crawling
- Sitemap at `/sitemap.xml` and `robots.txt` (editable in Settings; verify in 18.0 docs). Submit sitemap in Search Console.
- Keep unpublished or restricted pages out; pagination and filter URLs may need noindex/canonical handling.

## Google Merchant Center
- Product feed from the shop for Shopping ads; requires GTIN/brand/availability data on products and a verified domain (see google_merchant_center.html).

## Performance
- Images: right-size, WebP, lazy-load (default); hero images preloaded; avoid >300 KB images.
- Minimize custom JS/CSS; ship custom assets in module bundles (minified, cached) not inline snippets.
- Limit dynamic snippets per page and number of products per page (shop settings).
- Cache: anonymous pages and assets cached by browser; use a CDN (Settings > CDN base URL) and long cache for static assets (verify in 18.0 docs).
- Fonts: avoid many families/weights; download Google fonts locally.
- Server: enough workers, longpolling/websocket handled by proxy, gzip/brotli at nginx, HTTP/2.
- Variant explosion and large pricelist rules slow shop pages; profile with Odoo debug profiler.
- Measure: Lighthouse/PageSpeed, Core Web Vitals (LCP, CLS, INP); Website > Reporting and eCommerce dashboard for conversions.

## Analytics and consent
- Connect Google Analytics measurement ID in Settings; respect the cookie banner (Website > Configuration > Settings > Cookies bar). Tracking before consent is a legal risk.
