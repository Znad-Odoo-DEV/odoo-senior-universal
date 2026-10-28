# Database upgrade process (18.0 -> 19.0)

Odoo runs the database conversion on its **upgrade platform**; you request it and test the result. Confirm current steps at https://www.odoo.com/documentation/19.0/administration/upgrade.html — the platform behavior changes over time.

## Two requests: test, then production
- **Test**: an upgraded copy for validation. It is **neutralized** — outgoing emails, payment acquirers, crons, deliveries and other external actions are disabled so it cannot affect the real world. You may request multiple test databases.
- **Production**: the real upgrade. The production database is **unavailable** during the upgrade. Any change made in production **after** the copy was taken is **not** carried into the upgraded database, so freeze changes around cut-over.

The filestore is not included in the uploaded copy; **merge the production filestore** into the test database so attachments/images behave as in production.

## By hosting
- **Odoo Online**: upgrade from the database manager / Settings. Online allows no custom code, so the main work is validating standard behavior and apps.
- **Odoo.sh**: upgrade a **staging** branch first; Odoo.sh integrates the upgrade request into the branch workflow, then merge to production when green.
- **On-premise**: use the command line against the upgrade platform; you manage the server, Python (3.10+), PostgreSQL and the filestore yourself.

## Command line (on-premise / scripted)
Same command for both phases, only the keyword changes (verify the current invocation in the docs):

```
python <(curl -s https://upgrade.odoo.com/upgrade) test -d <db-name> -t 19.0
python <(curl -s https://upgrade.odoo.com/upgrade) production -d <db-name> -t 19.0
```

## Sequence that works
1. Freeze scope; take a full backup (DB + filestore). Record module list and versions.
2. Prepare custom modules for 19.0 on a branch (see `code-migration.md`); bump manifests to `19.0.x.y.z`.
3. Request the **test** upgrade; restore with the merged filestore; install/update your 19.0 modules (`-u all` or the specific modules) with `--test-enable`.
4. Validate: automated tests, then a manual pass — a sample product through purchase -> receipt -> sale -> delivery -> invoice; validate and credit an invoice; key reports; an online checkout; portal access; multi-company; scheduled actions. The official checklist is **not exhaustive** — add your business-critical flows.
5. Fix issues, re-request test upgrades until clean.
6. Schedule production for a quiet window; rehearse the full run (ideally the day before). Confirm the staging/test upgrade succeeded first.
7. Run production, re-deploy the 19.0 custom code, smoke-test, then re-enable integrations/crons.

## Obsolete and third-party modules
- Modules with no 19.0 version block loading. For each: find a 19.0 release, re-implement, replace with standard features, or uninstall (and migrate its data) before upgrading.
- OCA modules: check the `19.0` branch exists for every dependency.

## Rollback
- Production stays recoverable only via your pre-upgrade backup — keep it until 19.0 has run a full business cycle. There is no in-place downgrade; rollback = restore the 18.0 backup and filestore.

## Support window
- Check which versions are supported and for how long: https://www.odoo.com/documentation/19.0/administration/supported_versions.html — don't upgrade onto a version close to end of support.
