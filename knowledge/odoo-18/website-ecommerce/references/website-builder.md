# Website builder, pages, themes, menus, multi-website

Confirmed Odoo 18.0 docs sections (website.html): website_creation, web_design, structure, configuration, reporting, mail_groups
- https://www.odoo.com/documentation/18.0/applications/websites/website/website_creation.html
- https://www.odoo.com/documentation/18.0/applications/websites/website/web_design.html
- https://www.odoo.com/documentation/18.0/applications/websites/website/structure.html
- https://www.odoo.com/documentation/18.0/applications/websites/website/configuration.html
- https://www.odoo.com/documentation/18.0/applications/websites/website/reporting.html
- https://www.odoo.com/documentation/18.0/applications/websites/website/mail_groups.html
- Multi-website: https://www.odoo.com/documentation/18.0/applications/websites/website/configuration/multi_website.html

## Editor model
- Edit mode: drag building blocks (snippets) onto the page; the Style/Customize tab edits the selected block; Theme tab edits global colors, fonts, buttons, header/footer.
- Pages are `website.page` (linked `ir.ui.view`, URL, publish, indexed, visibility). Content edited in the builder is stored in the view arch.
- Edits to a shared (module) view on a specific website create a website-specific copy (copy-on-write). Such copies stop receiving module updates; track them (Settings > Technical > Views, filter by website) before upgrades.
- Dynamic content blocks (product, blog, events, forms) pull records via snippet options; limit counts to keep pages light.

## Pages and structure
- Manage pages: Website > Site > Pages (URL, publish, indexed, redirect, duplicate, delete). Changing a URL can create a redirect; confirm 301 behavior (verify in 18.0 docs: structure.html).
- Menus: Website > Site > Menu Editor; hierarchical, optional mega menu, per-website. Menu entries can point to pages, anchors or external URLs.
- Header/footer templates are global per website; choose via Theme tab, avoid per-page hacks.
- Visibility on a page: public, signed in, restricted to groups or password (verify in 18.0 docs: structure.html).

## Themes and design
- Install a theme (Website > Configuration > Settings or theme apps), then customize with the Theme tab. Fonts: Google fonts can be downloaded locally for GDPR/performance (verify in 18.0 docs: web_design.html).
- Custom CSS/SCSS: prefer a custom module with `website.assets_frontend` bundles and SCSS variable overrides (`$o-website-values-palettes`) over pasting CSS in the builder; code in modules is versioned.
- Custom frontend JS: on 18 write new public-website behaviour with the `Interaction` framework (supersedes legacy `publicWidget`), shipped in a module asset bundle.
- Custom code (Website > Site > HTML/CSS Editor) is acceptable for quick fixes but is DB-only, not versioned.
- Images: use compressed WebP/appropriate dimensions; the builder offers an image optimization dialog.

## Forms and leads
- Form block can create CRM leads/opportunities, tickets, tasks or send email; map fields to model fields; add spam protection (Cloudflare Turnstile / reCAPTCHA in Settings; verify in 18.0 docs: configuration.html).
- Check outbound mail and a test submission; mark the URL `noindex` on thank-you pages.

## Multi-website
- Create websites in Website > Configuration > Websites: set domain, language(s), default currency/pricelist, company.
- Field "Website" on records (products, categories, pages, menus, delivery methods, payment providers, pricelists): empty = all websites, set = that website only.
- Each website has its own domain; map domain correctly (DNS CNAME/proxy `Host` header) and set `web.base.url`.
- Multi-company: website company must match warehouse/pricelist company; cross-company setups are a frequent source of access errors.
- Languages: installed languages enabled per website; each language gets its own translated content and URL prefix.

## Operational notes
- Reporting: Website > Reporting (visits, conversions); needs cookie consent for tracking.
- Mail groups: separate app feature (mail_groups.html).
- Test in a private window; anonymous users see cached public pages.
