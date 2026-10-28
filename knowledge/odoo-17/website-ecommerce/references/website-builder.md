# Website builder, pages, themes, menus, multi-website

Odoo 17.0 docs sections (website.html): website_creation, web_design, structure, configuration, reporting, mail_groups (sub-page paths ported from the newer-version doc set; verify each resolves in 17.0)
- https://www.odoo.com/documentation/17.0/applications/websites/website.html
- https://www.odoo.com/documentation/17.0/applications/websites/website/web_design.html
- https://www.odoo.com/documentation/17.0/applications/websites/website.html
- https://www.odoo.com/documentation/17.0/applications/websites/website/configuration.html
- https://www.odoo.com/documentation/17.0/applications/websites/website/reporting.html
- https://www.odoo.com/documentation/17.0/applications/websites/website/mail_groups.html
- Multi-website: https://www.odoo.com/documentation/17.0/applications/websites/website/configuration/multi_website.html

## Editor model
- Edit mode: drag building blocks (snippets) from the Blocks tab onto the page; the Customize tab edits the selected block; the Theme tab edits global colors, fonts, buttons, header/footer. The builder was redesigned in Odoo 18/19, so panel names from newer docs and screenshots will differ.
- Pages are `website.page` (linked `ir.ui.view`, URL, publish, indexed, visibility). Content edited in the builder is stored in the view arch.
- Edits to a shared (module) view on a specific website create a website-specific copy (copy-on-write). Such copies stop receiving module updates; track them (Settings > Technical > Views, filter by website) before upgrades.
- Dynamic content blocks (product, blog, events, forms) pull records via snippet options; limit counts to keep pages light.

## Pages and structure
- Manage pages: Website > Site > Pages (URL, publish, indexed, redirect, duplicate, delete). Changing a URL can create a redirect; confirm 301 behavior (verify in 17.0 docs: structure.html).
- Menus: Website > Site > Menu Editor; hierarchical, optional mega menu, per-website. Menu entries can point to pages, anchors or external URLs.
- Header/footer templates are global per website; choose via Theme tab, avoid per-page hacks.
- Visibility on a page: public, signed in, restricted to groups or password (verify in 17.0 docs: structure.html).

## Themes and design
- Install a theme (Website > Configuration > Settings or theme apps), then customize with the Theme tab. Fonts: Google fonts can be downloaded locally for GDPR/performance (verify in 17.0 docs: web_design.html).
- Custom CSS/SCSS: prefer a custom module that declares assets in its manifest (`web.assets_frontend` bundle, plus SCSS variable overrides of `$o-website-values-palettes` through the website primary-variables bundle; verify bundle names in 17.0 docs) over pasting CSS in the builder; code in modules is versioned.
- Custom code (Website > Site > HTML/CSS Editor) is acceptable for quick fixes but is DB-only, not versioned.
- Images: use compressed WebP/appropriate dimensions; the builder offers an image optimization dialog.

## Custom frontend code (17 specifics)
- Public/website JS = `publicWidget` (`publicWidget.registry.<Name> = publicWidget.Widget.extend({selector, events, start})`) in `/** @odoo-module **/` files added to `web.assets_frontend`. The `Interaction` framework replaces it only in Odoo 18+; do not copy 18/19 snippets.
- Editor-side options for custom snippets use `web_editor` snippet options (`website.snippet_options` template inheritance); keep them in a separate module so the frontend bundle stays light.
- JS tests are QUnit (`QUnit.module` / `QUnit.test`, `web.qunit_suite_tests` / `web.assets_tests` for tours), not Hoot. Tours (`web_tour.tours`) run with `--test-enable` on the website tag.
- QWeb: `t-out` (not `t-raw`); view inheritance with direct `invisible`/`readonly`/`required` expressions (no `attrs`); `<tree>` for backend lists, `kanban-box` for kanban.

## Forms and leads
- Form block can create CRM leads/opportunities, tickets, tasks or send email; map fields to model fields; add spam protection (Cloudflare Turnstile / reCAPTCHA in Settings; verify in 17.0 docs: configuration.html, Turnstile may not be available in every 17.x build).
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
