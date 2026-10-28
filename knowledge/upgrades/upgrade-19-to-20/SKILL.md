---
name: upgrade-19-to-20
description: Senior guidance for upgrading an Odoo database and its custom modules from 19.0 to 20.0 — the official upgrade process (test/production requests, hosting variants) and the breaking changes to fix in custom code (ir.access security rewrite, public read_group signature, OWL 3, removed modules, external API deprecations, Python 3.12 / PostgreSQL 16).
---

# Upgrade Odoo 19.0 -> 20.0

Two halves, both mandatory: (1) the **database upgrade** through Odoo's upgrade platform, and (2) **custom-code migration** so your modules load and behave on 20.0. Odoo converts standard data; your custom modules are your responsibility. 19->20 is a **heavy** jump: the security model, the frontend framework and the ORM grouping API all change.

Grounded in the official docs; confirm specifics there:
- Upgrade overview: https://www.odoo.com/documentation/20.0/administration/upgrade.html
- ORM changelog: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm/changelog.html
- Release notes: https://www.odoo.com/odoo-20-release-notes
- Upgrade a customized database: https://www.odoo.com/documentation/20.0/developer/howtos/upgrade_custom_db.html (verify in 20.0 docs)

## Mindset
- Rehearse on a **test** database until clean; run production in a quiet window; keep a restorable 19.0 backup until 20.0 has run a full cycle.
- Make custom code 20.0-compatible **first** — the platform converts standard data, not your code's assumptions, and 20 breaks several of them.
- Not "done" until a 20.0 test DB runs your real flows green with `--test-enable` plus the manual checklist.
- Check the **ecosystem** before committing: as of 2026-09-24 OCA had **no 20.0 branches** (OpenUpgrade included) — re-check; a dependency without a 20.0 release blocks you.

## Process (summary — see `references/upgrade-process.md`)
1. Inventory custom modules, OCA/third-party apps (confirm each has a 20.0 release), Studio customizations, integrations, reports; note any **Field Service**, **payroll** or **batch-picking** usage (all change in 20).
2. Prepare infrastructure: **Python >= 3.12**, **PostgreSQL >= 16** (on-premise / Odoo.sh builds).
3. Port custom code to 20.0 on a branch (see `references/code-migration.md`); bump manifests to `20.0.x.y.z`.
4. Request a **test** upgraded database; merge the production filestore; install your 20.0 modules; run automated tests, then the manual checklist.
5. Fix, repeat test upgrades; only when green, schedule and run **production** (unavailable during the upgrade; post-copy changes are not carried over).

## Headline breaking changes 19 -> 20 (see `references/code-migration.md`)
- **Security rewrite**: `ir.model.access` + `ir.rule` merge into **`ir.access`**; `ir.model.access.csv` -> **`ir.access.csv`** (`id,name,model_id,group_id/id,operation,domain`). Every module's security files must be rewritten.
- **ORM**: `read_group` becomes public with signature `(domain, groupby, aggregates, having, offset, limit, order)` — old `fields=`/`lazy=` calls break; `_table_query` removed; `_check_access` deprecated; tracking values removed.
- **Frontend**: **OWL 3** (22 breaking changes in the 2->3 guide; the compatibility layer is a temporary bridge only).
- **Removed/merged modules**: `base_vat`, `base_iban`, `stock_picking_batch` (-> `stock`), `website_sale_wishlist` / `website_sale_comparison` (-> `website_sale`), `hr_org_chart`, `hr_homeworking`, `delivery_mondialrelay`, `transifex`, `hr_work_entry_holidays`, `l10n_fr_hr_work_entry_holidays` — fix `depends` and inherited code.
- **External API**: XML-RPC/JSON-RPC deprecated; `db` service removed in 20; `common`/`object` removed in Odoo 22 (fall 2028). Move integrations to JSON-2 `/json/2/<model>/<method>` (Custom plan).
- **Functional data**: Field Service discontinued (-> Planning); payroll work entries removed; account groups -> parent accounts; payment statuses renamed; bank-impacting entries must come from bank transactions; expenses become draft vendor bills.

## When NOT to rush
- Heavy FSM / payroll / batch-picking usage: these are process changes, not just code — plan user retraining and data mapping.
- Any OCA/third-party dependency without a 20.0 release.
- Infrastructure not yet on Python 3.12 / PostgreSQL 16.
- Support math: 19.0 is supported until **Sept 2028** — you have time to do this properly; 18.0 ends Sept 2027, 17.0 ended Sept 2026. Enterprise databases older than the 3 latest majors can be billed **+25%**.

## References
- `references/upgrade-process.md` — platform, test vs production, hosting (Online / Odoo.sh / on-premise), prerequisites, filestore, neutralization, command line, rollback, support dates.
- `references/code-migration.md` — the 19->20 security/ORM/frontend/module/API changes with a fix checklist, and the functional data impacts.

Key docs (20.0):
- Upgrade: https://www.odoo.com/documentation/20.0/administration/upgrade.html
- ORM changelog: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm/changelog.html
- Supported versions: https://www.odoo.com/documentation/20.0/administration/supported_versions.html (verify in 20.0 docs)
- Release notes: https://www.odoo.com/odoo-20-release-notes
