---
name: upgrade-17-to-18
description: Senior guidance for upgrading an Odoo database and its custom modules from 17.0 to 18.0 — the official upgrade process (test/production requests, hosting variants) and the view/security/ORM/frontend breaking changes to fix in custom code (<tree>-><list>, oe_chatter-><chatter/>, check_access, kanban card, Interaction, Hoot).
---

# Upgrade Odoo 17.0 -> 18.0

Two halves, both mandatory: (1) the **database upgrade** through Odoo's upgrade platform, and (2) **custom-code migration** so your modules load and behave on 18.0. Odoo converts standard data; your custom modules are your responsibility. The 17->18 jump has notable **view and API renames**, so expect real code edits.

Grounded in the official docs; confirm specifics there:
- Upgrade overview: https://www.odoo.com/documentation/18.0/administration/upgrade.html
- Upgrade a customized database: https://www.odoo.com/documentation/18.0/developer/howtos/upgrade_custom_db.html
- ORM changelog: https://www.odoo.com/documentation/18.0/developer/reference/backend/orm/changelog.html

## Mindset
- Rehearse on a **test** database until clean, then run production in a quiet window.
- Make custom code 18.0-compatible **first**; the platform converts standard data, not your code.
- Not "done" until an 18.0 test DB runs your real flows green with `--test-enable` and the manual checklist passes.
- Keep the 17.0 source and a restorable backup until production has run a full cycle on 18.0.

## Process (summary — see `references/upgrade-process.md`)
1. Inventory custom modules, OCA/third-party apps (confirm each has an 18.0 release), studio customizations, integrations, reports.
2. Port custom code to 18.0 on a branch (see `references/code-migration.md`); bump manifests to `18.0.x.y.z`.
3. Request a **test** upgraded database; merge the production filestore into the copy.
4. Install 18.0 modules on the test DB; run automated tests, then the manual checklist (sales/purchase/inventory/invoicing/reports/portal).
5. Fix, repeat test upgrades; only when green, schedule and run **production** (unavailable during the upgrade; post-copy changes are not carried over).

## Headline breaking changes 17 -> 18 (see `references/code-migration.md`)
- **List view root renamed**: `<tree>` -> `<list>`; `view_mode="tree,form"` -> `"list,form"`; `[False, "list"]` in client actions; `ir.ui.view` type `list`.
- **Chatter**: `<div class="oe_chatter">...</div>` -> single `<chatter/>` tag in form views.
- **Kanban**: card template `<t t-name="kanban-box">` -> `<t t-name="card">`.
- **Access API**: `check_access_rights(op)` / `check_access_rule(op)` -> `check_access(op)` / `has_access(op)` / `_filtered_access(op)`.
- **Translations**: `self.env._("...")` helper added (module-level `_`/`_lt` still valid).
- **Frontend**: new public-website JS uses the `Interaction` framework (legacy `publicWidget` still works); JS unit tests move from QUnit to **Hoot**; `rpc` is a direct import, not a service.
- **Platform**: `company_dependent` storage moved to a jsonb column and `ir.property` removed; `ir.cron` dropped `numbercall`/`doall`.
- `attrs`/`states` were already removed in 17 — if any slipped through, convert to direct `invisible`/`readonly`/`required`.

## When NOT to rush
- Many custom views (each `<tree>`/`oe_chatter`/kanban needs editing) or integration-heavy setups: budget for the edits and a longer test cycle.
- Unmaintained third-party modules without an 18.0 release: replace, re-implement, or drop first.
- Compliance data (accounting, payroll): involve the accountant; confirm localization modules exist for 18.0.

## References
- `references/upgrade-process.md` — platform, test vs production, hosting (Online / Odoo.sh / on-premise), filestore, neutralization, command line, timing, rollback.
- `references/code-migration.md` — the 17->18 view/model/ORM/frontend changes, migration scripts, and a fix checklist.

Key docs (18.0):
- Upgrade: https://www.odoo.com/documentation/18.0/administration/upgrade.html
- Customized DB: https://www.odoo.com/documentation/18.0/developer/howtos/upgrade_custom_db.html
- Supported versions: https://www.odoo.com/documentation/18.0/administration/supported_versions.html
