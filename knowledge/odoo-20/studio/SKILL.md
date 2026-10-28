---
name: studio
description: Senior Odoo 20 Studio expertise. Use for Odoo 20 Studio customization — adding fields, building and editing views, creating models and menus, automation and approval rules, and PDF document design, plus when Studio is the right tool versus developer code.
---

# Odoo 20 Studio (senior)

Studio is a toolbox to customize Odoo without coding: fields, views, models/apps/menus, automation rules, webhooks, PDF reports, approval rules (security rules also customizable). Open it from the target app/model via the Toggle Studio icon.
Licensing: Studio requires the **Custom** plan. Installing on Standard triggers an upsell; yearly/multi-year contracts get an upsell order with a 30-day limit; monthly contracts switch plan and the new rate applies at the next bill. Confirm with the account manager. Source: https://www.odoo.com/documentation/20.0/applications/studio.html (content ported from the 19.0 docs; verify in 20.0 docs: same URL).

## Mindset
- Studio is for **config-level change**: a field, a view tweak, a simple approval, a notification, a document layout. Logic-heavy, performance-critical, or multi-model work belongs in a module (see references/governance-limits.md).
- Every Studio change writes real records (custom fields `x_studio_*`, inherited views with auto-built XPath, server actions, report records) in that database. It is customization debt: document it, test it on a duplicate, export it.
- Work in a **duplicate/staging database** first, then deploy via Studio export/import or migrate to a coded module.
- Customize narrowly: fewer fields, fewer automations, one owner for Studio changes.

## Odoo 20 points that affect Studio work
- **Security model rewritten**: `ir.model.access` and `ir.rule` are merged into `ir.access`; `ir.model.access.csv` becomes `ir.access.csv` (`id,name,model_id,group_id/id,operation,domain`). Access rights and record-level filters for Studio models and the access part of a Studio export must be checked on 20 (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/studio.html).
- **Execute Code actions** and server actions are Python: `read_group` is now public with signature `(domain, groupby, aggregates, having, offset, limit, order)`; old `fields=`/`lazy=` calls break. `_table_query` is removed and `_check_access` is deprecated.
- **Tracking values are removed**; tracking messages are generated on the fly. Check any Studio automation or report that reads tracking values.
- **External callers**: XML-RPC/JSON-RPC are deprecated, the `db` service is removed in 20, `common`/`object` are scheduled for removal in Odoo 22. Replacement is JSON-2 `/json/2/<model>/<method>` (Custom plan only, which Studio already requires). Incoming Studio webhooks are plain HTTP POST to the generated URL and are a separate mechanism.
- Removed/merged modules (e.g. `base_vat`, `base_iban`, `website_sale_wishlist`, `website_sale_comparison`, `hr_org_chart`, `hr_homeworking`, `delivery_mondialrelay`, `stock_picking_batch`) can leave Studio views or automations pointing at fields or buttons that no longer exist: re-test every customization on an upgraded copy.
- Runtime baseline: Python >= 3.12, PostgreSQL >= 16. Odoo's built-in AI app exists in 20; the Update with AI action in automations is carried forward from 19 (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/studio/automated_actions.html).

## Principles
1. **Model first**: pick the right field type (stored column vs related/computed) before views; a wrong type is costly to change once data exists.
2. **Use Studio's inherited views**, never edit standard views in the XML editor; edits there are reset on updates/upgrades. Drag-and-drop builds correct XPath.
3. **Prefer standard fields/widgets** and extend existing models before inventing new ones.
4. **Duplicate standard PDF reports** before editing; header/footer edits affect all reports.
5. **Automation**: tight filters (Before Update Domain + Apply on domain), document each rule in Notes, test on duplicate; time-based rules need "Run manually" once to avoid retroactive firing.
6. **Approvals** gate a button, not a field: model them per button with groups, not per-user lists.
7. **Webhook URLs are secrets**: rotate if leaked, test with a copy database, enable Log Calls while debugging.
8. **Governance**: restrict Studio access to few admins, name things consistently, review the customization list before each upgrade (especially the 19 -> 20 one).

## Decision: Studio or code?
Studio: extra fields, layout changes, simple stages, notification/activity rules, approval on a button, small PDF edits, simple webhook intake.
Code: complex compute, constraints, cross-model transactions, integration logic, heavy reports, anything needing tests, version control, or CI.

## References
- references/fields-models.md — field types, widgets, models, apps, suggested features, export/import
- references/views-ui.md — view types, options, buttons, XML editor cautions
- references/automation-approvals.md — automation rules, webhooks, approval rules
- references/pdf-documents.md — PDF report design in Studio
- references/governance-limits.md — limits, export/migrate, upgrade risk, when to use code

Official docs (ported from the 19.0 layout; verify in 20.0 docs):
- https://www.odoo.com/documentation/20.0/applications/studio.html
- https://www.odoo.com/documentation/20.0/applications/studio/fields.html
- https://www.odoo.com/documentation/20.0/applications/studio/views.html
- https://www.odoo.com/documentation/20.0/applications/studio/models_modules_apps.html
- https://www.odoo.com/documentation/20.0/applications/studio/automated_actions.html
- https://www.odoo.com/documentation/20.0/applications/studio/automated_actions/webhooks.html
- https://www.odoo.com/documentation/20.0/applications/studio/pdf_reports.html
- https://www.odoo.com/documentation/20.0/applications/studio/approval_rules.html
- Release notes: https://www.odoo.com/odoo-20-release-notes
