# Database upgrade process (19.0 -> 20.0)

Odoo runs the conversion on its **upgrade platform**; you request it and validate the result. Steps below match https://www.odoo.com/documentation/20.0/administration/upgrade.html and https://www.odoo.com/documentation/20.0/developer/howtos/upgrade_custom_db.html (checked). Platform behavior changes over time.

## Prerequisites specific to 20.0
- **Python >= 3.12** and **PostgreSQL >= 16** (19 required 3.10 / 13). Upgrade the runtime on on-premise servers before the production upgrade; on Odoo.sh pick a build that provides them; Odoo Online handles it.
- **Ecosystem**: as of 2026-09-24 OCA had **no 20.0 branches** (OpenUpgrade included) — re-check. Every OCA/third-party dependency needs a 20.0 release or a replacement plan.
- **Custom code** must already be ported (see `code-migration.md`): 20 rewrites the security model, so unported modules will not even load.

## Two requests: test, then production
- **Test**: an upgraded copy for validation, **neutralized** (outgoing email, payment acquirers, crons, deliveries and other external actions disabled) so it cannot affect the real world. You may request several test databases.
- **Production**: the real upgrade; the production database is **unavailable** while it runs, and changes made in production **after** the copy was taken are **not** carried into the upgraded database. Freeze changes around cut-over.

The uploaded copy excludes the filestore — **merge the production filestore** into the test database so attachments/images match production.

## By hosting
- **Odoo Online**: Odoo runs a silent test upgrade; if it takes under 20 minutes you can trigger the upgrade yourself; an automatic upgrade happens at the due date. Use the database manager; no custom code, so you validate standard behavior and installed apps — especially the 20 process changes (Field Service -> Planning, payroll, accounting).
- **Odoo.sh**: the latest daily production backup is upgraded and placed on a staging branch; each commit pushed there restores the upgraded backup and updates custom modules (log: `~/logs/upgrade.log`). Validate, then request production.
- **On-premise**: command line against the upgrade platform; you manage the server (Python 3.12+, PostgreSQL 16+), filestore and the custom-code deployment.

## Command line (on-premise / scripted)
Same command both phases, only the keyword changes (command syntax not shown in the pages checked: verify in 20.0 docs):

```
python <(curl -s https://upgrade.odoo.com/upgrade) test -d <db-name> -t 20.0
python <(curl -s https://upgrade.odoo.com/upgrade) production -d <db-name> -t 20.0
```

## Sequence that works
1. Freeze scope; back up DB + filestore; record module list and versions.
2. Port custom modules to 20.0 on a branch (`code-migration.md`); bump manifests to `20.0.x.y.z`.
3. Bring infrastructure to Python 3.12 / PostgreSQL 16 on the target environment.
4. Request the **test** upgrade; restore with the merged filestore; install/update your 20.0 modules with `--test-enable`.
5. Validate: automated tests, then a manual pass — a sample product through purchase -> receipt -> sale -> delivery -> invoice; validate and credit an invoice; bank reconciliation (bank-impacting entries now originate from bank transactions); key statements (parent accounts replace account groups); an expense (now a draft vendor bill); payroll runs (work entries removed); any former Field Service flow (now Planning); batch picking (now core `stock`); portal; multi-company; crons. The official checklist is **not exhaustive** — add your business-critical flows.
6. Fix, re-request test upgrades until clean.
7. Schedule production for a quiet window; rehearse the run (ideally the day before). Confirm the staging/test upgrade succeeded first.
8. Run production, deploy the 20.0 custom code, smoke-test, re-enable integrations/crons (integrations should already be on JSON-2 or on a dated plan to leave XML-RPC/JSON-RPC).

## Removed and merged modules
Modules removed/merged in 20.0 block loading of anything that depends on them: `base_vat`, `base_iban`, `stock_picking_batch` (-> `stock`), `website_sale_wishlist` and `website_sale_comparison` (-> `website_sale`), `hr_org_chart`, `hr_homeworking`, `delivery_mondialrelay`, `transifex`, `hr_work_entry_holidays`, `l10n_fr_hr_work_entry_holidays`. Fix `depends`, inherited models/views and data references before the upgrade.

## Rollback
- No in-place downgrade. Rollback = restore the 19.0 backup + filestore (on the 19-era runtime). Keep that backup until 20.0 has run a full business cycle.

## Support window
- Standard support ends: **19.0 Sept 2028**, **18.0 Sept 2027**, **17.0 Sept 2026** (ended). Enterprise: a database older than the 3 latest majors can be charged **+25%** (no earlier than 6 months after a new major). Official rule: major-version databases must be upgraded about every two years; each major gets three years of support plus two more to complete the upgrade. Details: https://www.odoo.com/documentation/20.0/administration/supported_versions.html (verify in 20.0 docs)
