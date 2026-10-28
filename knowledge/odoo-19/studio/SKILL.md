---
name: studio
description: Senior Odoo 19 Studio expertise. Use for Odoo 19 Studio customization — adding fields, building and editing views, creating models and menus, automation and approval rules, and PDF document design, plus when Studio is the right tool versus developer code.
---

# Odoo 19 Studio (senior)

Studio is a toolbox to customize Odoo without coding: fields, views, models/apps/menus, automation rules, webhooks, PDF reports, approval rules (security rules also customizable). Open it from the target app/model via the Toggle Studio icon.
Licensing: Studio requires the **Custom** plan. Installing on Standard triggers an upsell; yearly/multi-year contracts get an upsell order with a 30-day limit; monthly contracts switch plan and the new rate applies at the next bill. Confirm with the account manager. Source: https://www.odoo.com/documentation/19.0/applications/studio.html

## Mindset
- Studio is for **config-level change**: a field, a view tweak, a simple approval, a notification, a document layout. Logic-heavy, performance-critical, or multi-model work belongs in a module (see references/governance-limits.md).
- Every Studio change writes real records (custom fields `x_studio_*`, inherited views with generated XPath, server actions, report records) in that database. It is customization debt: document it, test it on a duplicate, export it.
- Work in a **duplicate/staging database** first, then deploy via Studio export/import or migrate to a coded module.
- Customize narrowly: fewer fields, fewer automations, one owner for Studio changes.

## Principles
1. **Model first**: pick the right field type (stored column vs related/computed) before views; a wrong type is costly to change once data exists.
2. **Use Studio's inherited views**, never edit standard views in the XML editor; edits there are reset on updates/upgrades. Drag-and-drop generates correct XPath.
3. **Prefer standard fields/widgets** and extend existing models before inventing new ones.
4. **Duplicate standard PDF reports** before editing; header/footer edits affect all reports.
5. **Automation**: tight filters (Before Update Domain + Apply on domain), document each rule in Notes, test on duplicate; time-based rules need "Run manually" once to avoid retroactive firing.
6. **Approvals** gate a button, not a field: model them per button with groups, not per-user lists.
7. **Webhook URLs are secrets**: rotate if leaked, test with a copy database, enable Log Calls while debugging.
8. **Governance**: restrict Studio access to few admins, name things consistently, review the customization list before each upgrade.

## Decision: Studio or code?
Studio: extra fields, layout changes, simple stages, notification/activity rules, approval on a button, small PDF edits, simple webhook intake.
Code: complex compute, constraints, cross-model transactions, integration logic, heavy reports, anything needing tests, version control, or CI.

## References
- references/fields-models.md — field types, widgets, models, apps, suggested features, export/import
- references/views-ui.md — view types, options, buttons, XML editor cautions
- references/automation-approvals.md — automation rules, webhooks, approval rules
- references/pdf-documents.md — PDF report design in Studio
- references/governance-limits.md — limits, export/migrate, upgrade risk, when to use code

Official docs (confirmed, 19.0):
- https://www.odoo.com/documentation/19.0/applications/studio.html
- https://www.odoo.com/documentation/19.0/applications/studio/fields.html
- https://www.odoo.com/documentation/19.0/applications/studio/views.html
- https://www.odoo.com/documentation/19.0/applications/studio/models_modules_apps.html
- https://www.odoo.com/documentation/19.0/applications/studio/automated_actions.html
- https://www.odoo.com/documentation/19.0/applications/studio/automated_actions/webhooks.html
- https://www.odoo.com/documentation/19.0/applications/studio/pdf_reports.html
- https://www.odoo.com/documentation/19.0/applications/studio/approval_rules.html
