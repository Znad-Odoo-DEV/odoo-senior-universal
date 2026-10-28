---
name: upgrade-18-to-19
description: Senior guidance for upgrading an Odoo database and its custom modules from 18.0 to 19.0 — the official upgrade process (test/production requests, hosting variants) and the ORM/security/view/frontend breaking changes to fix in custom code before and after the upgrade.
---

# Upgrade Odoo 18.0 -> 19.0

Two halves, both mandatory: (1) the **database upgrade** through Odoo's upgrade platform, and (2) **custom-code migration** so your modules load and behave correctly on 19.0. Standard data is converted by Odoo's scripts; your custom modules are your responsibility.

Grounded in the official docs; confirm specifics there before acting:
- Upgrade overview: https://www.odoo.com/documentation/19.0/administration/upgrade.html
- Upgrade a customized database: https://www.odoo.com/documentation/19.0/developer/howtos/upgrade_custom_db.html
- ORM changelog: https://www.odoo.com/documentation/19.0/developer/reference/backend/orm/changelog.html

## Mindset
- Upgrading is a project, not a button. Rehearse on a **test** database until clean, then do production in a quiet window.
- Custom modules must be made compatible with 19.0 **first** — the platform converts standard data, not your code's assumptions.
- Nothing is "done" until a 19.0 test DB runs your real flows green: install/update all custom modules with `--test-enable`, click through the critical paths, reconcile counts and totals against production.
- Keep the 18.0 source and a restorable backup until production has run on 19.0 for a full cycle.

## Process (summary — see `references/upgrade-process.md`)
1. Inventory: list custom modules, OCA/third-party apps (check each has a 19.0 release), studio customizations, integrations, reports.
2. Make custom code 19.0-compatible on a branch (see `references/code-migration.md`); bump manifests to `19.0.x.y.z`.
3. Request a **test** upgraded database (upgrade platform / `odoo.sh` staging / command line); merge the filestore so the copy is realistic.
4. Install your 19.0 modules on the test DB, run automated tests, then the manual checklist (sales/purchase/inventory/invoicing/reports/portal).
5. Fix, repeat test upgrades as needed. Only when green: schedule and run the **production** upgrade; changes made to production after the copy are not carried over.

## Headline breaking changes 18 -> 19 (see `references/code-migration.md`)
- **Security field rename**: `res.users` / `res.groups` field `groups_id` -> `group_ids`; group privileges reworked via `res.groups.privilege`. Update Python, XML (`<field name="groups_id">`), domains and ACL logic.
- **Declarative constraints/indexes**: `_sql_constraints` is deprecated in favor of `models.Constraint(...)`, `models.Index(...)`, `models.UniqueIndex(...)` class attributes. `_sql_constraints` still loads (verify) but migrate it.
- **Composable domains**: `odoo.fields.Domain` with `&`/`|`/`~` and `Domain.AND/OR`; plain list domains still work.
- **External API**: `/json/2/<model>/<method>` is the new external endpoint; XML-RPC (`/xmlrpc/2`) and JSON-RPC (`/jsonrpc`) are deprecated and scheduled for removal in 20 — plan integration changes.
- **Standard apps shifted**: inherited views/methods in accounting, inventory, POS, HR, website and the new **AI** app may have moved — diff the 19.0 community source for every model/view you extend.
- Views/ORM already modern from 18 (`<list>`, `<chatter/>`, `check_access`, `_read_group`, Hoot, Owl 2) — no 17->18-style rename here.

## When NOT to rush
- A heavily customized or integration-dense database: budget for code migration and a longer test cycle.
- Obsolete/unmaintained third-party modules with no 19.0 release: decide to replace, re-implement, or drop before upgrading.
- Compliance-sensitive data (accounting, payroll): involve the accountant and verify localization modules exist for 19.0.

## References
- `references/upgrade-process.md` — platform, test vs production, hosting (Online / Odoo.sh / on-premise), filestore, neutralization, command line, timing, rollback.
- `references/code-migration.md` — the 18->19 model/field/view/ORM/frontend changes, migration scripts, and a fix checklist.

Key docs (19.0):
- Upgrade: https://www.odoo.com/documentation/19.0/administration/upgrade.html
- Customized DB: https://www.odoo.com/documentation/19.0/developer/howtos/upgrade_custom_db.html
- Supported versions / support policy: https://www.odoo.com/documentation/19.0/administration/supported_versions.html
