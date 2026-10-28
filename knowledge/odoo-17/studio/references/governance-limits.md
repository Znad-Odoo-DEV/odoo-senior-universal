# Governance, limits, export/migrate (Studio, Odoo 17)
Docs: https://www.odoo.com/documentation/17.0/applications/studio.html , https://www.odoo.com/documentation/17.0/applications/studio/models_modules_apps.html

## Licensing
Custom plan required; installing on Standard triggers an upsell (yearly/multi-year: upsell order with 30-day limit; monthly: plan switches, new rate at next bill). Verify with account manager or https://www.odoo.com/pricing-plan . Behavior for Odoo.sh/on-premise and the exact 17 wording: (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/studio.html)

## What Studio cannot (or should not) do
- Complex Python: constraints (`_sql_constraints` or `@api.constrains`), business-rule computes, create/write overrides, method inheritance. Automation Execute Python Code is a stopgap, not versioned code.
- Unit tests, version control, code review, CI: customizations live in the database.
- Security beyond the UI for groups/rules/access; fine-grained logic goes in modules. (No dedicated 17.0 sub-page for security rules.)
- Performance work: stored computes on big tables, indexes, SQL views.
- Reliable raw-XML edits of standard views: reset on upgrades.
- Rich integrations (outbound auth flows, queues): use code or connector modules.

## Export / migrate
- Studio export: ZIP of the `studio_customization` module (models, fields, views, automations, reports; data per model with Demo/Attachments/Updatable + domain filter). Import into another DB; Studio orders records logically.
- Promotion path: build in duplicate DB, test, export, import to production (or convert to a real module and drop the Studio one).
- Converting to code: use the exported module as a base, rename `x_studio_` fields deliberately with migration scripts (`migrations/17.0.x.y.z/`), refactor views and automations into XML/Python, remove the Studio dependency. Target Odoo 17 idioms: `<tree>` roots, `oe_chatter` div, `kanban-box`, direct `invisible`/`readonly`/`required` expressions, `groups_id`, `_sql_constraints`, `_()` for translations, `check_access_rights`/`check_access_rule`.

## Upgrades
- Studio fields/views carry upgrade risk: standard views change between versions and XPath may break. Test each upgrade on a copy; review Studio views and automations beforehand. Upgrading 17 to 18 renames `<tree>` to `<list>` and replaces the chatter div; Studio-generated views are not always rewritten for you.
- Upgrade-service treatment of Studio customizations: (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/administration/upgrade.html)

## Governance checklist
1. Few Studio-capable admins; change log (what/why/who) per customization.
2. Naming convention in labels and Notes; document each automation's purpose in its Notes tab.
3. Work in a duplicate DB; never experiment in production.
4. Review automations and webhooks quarterly; rotate webhook secrets on staff/vendor changes.
5. Prefer groups for approvals and visibility.
6. Threshold: if a feature needs more than ~2 automations or custom Python, move it to a module.
