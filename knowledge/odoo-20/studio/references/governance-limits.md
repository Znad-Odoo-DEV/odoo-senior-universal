# Governance, limits, export/migrate (Studio, Odoo 20)
Docs (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/studio.html , https://www.odoo.com/documentation/20.0/applications/studio/models_modules_apps.html

## Licensing
Custom plan required; installing on Standard triggers an upsell (yearly/multi-year: upsell order with 30-day limit; monthly: plan switches, new rate at next bill). Verify with account manager or https://www.odoo.com/pricing-plan . Behavior for Odoo.sh/on-premise: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/studio.html)

## What Studio cannot (or should not) do
- Complex Python: constraints, business-rule computes, create/write overrides, method inheritance. Automation Execute Code is a stopgap, not versioned code.
- Unit tests, version control, code review, CI: customizations live in the database.
- Security beyond the UI for groups/rules/access; fine-grained logic goes in modules. In 20 that means writing `ir.access.csv` (`id,name,model_id,group_id/id,operation,domain`) instead of `ir.model.access.csv` + `ir.rule`. (No dedicated sub-page for security rules in the 19.0 docs; verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/studio.html.)
- Performance work: stored computes on big tables, indexes, SQL views. Note `_table_query` is removed in 20, so SQL-view style models need a different approach in code.
- Reliable raw-XML edits of standard views: reset on upgrades.
- Rich integrations (outbound auth flows, queues): use code or connector modules.

## Export / migrate
- Studio export: ZIP of the `studio_customization` module (models, fields, views, automations, reports; data per model with Demo/Attachments/Updatable + domain filter). Import into another DB; Studio orders records logically.
- Promotion path: build in duplicate DB, test, export, import to production (or convert to a real module and drop the Studio one).
- Converting to code: use the exported module as a base, rename `x_studio_` fields deliberately with migration scripts (`migrations/20.0.x.y.z/` for a 20 module), refactor views and automations into XML/Python, replace access records with `ir.access.csv`, remove the Studio dependency. Manifest version form: `20.0.x.y.z`.
- Target runtime for coded modules: Python >= 3.12, PostgreSQL >= 16.

## Upgrades
- Studio fields/views carry upgrade risk: standard views change between versions and XPath may break. Test each upgrade on a copy; review Studio views and automations beforehand.
- 19 -> 20 hot spots: views and automations touching removed/merged modules and apps (see SKILL.md), Execute Code using the old `read_group(fields=, lazy=)`, accounting automations keyed on old payment status labels, and approval rules on buttons that changed.
- Upgrade-service treatment of Studio customizations: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/administration/upgrade.html)
- Support timing: standard support for 19.0 ends Sept 2028, 18.0 Sept 2027, 17.0 Sept 2026 (already ended). Enterprise databases older than the 3 latest majors can be charged +25% (no earlier than 6 months after a new major). Re-check current terms with the account manager.

## Governance checklist
1. Few Studio-capable admins; change log (what/why/who) per customization.
2. Naming convention in labels and Notes; document each automation's purpose in its Notes tab.
3. Work in a duplicate DB; never experiment in production.
4. Review automations and webhooks quarterly; rotate webhook secrets on staff/vendor changes.
5. Prefer groups for approvals and visibility.
6. Threshold: if a feature needs more than ~2 automations or custom Python, move it to a module.
7. Before moving to 20: inventory Studio models, automations and reports, then re-test each on an upgraded copy.
