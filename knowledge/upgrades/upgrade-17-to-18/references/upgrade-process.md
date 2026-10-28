# Database upgrade process (17.0 -> 18.0)

Odoo runs the conversion on its **upgrade platform**; you request it and validate the result. Confirm current steps at https://www.odoo.com/documentation/18.0/administration/upgrade.html — platform behavior changes over time.

## Two requests: test, then production
- **Test**: an upgraded copy for validation, **neutralized** (outgoing email, payment acquirers, crons, deliveries and other external actions disabled) so it cannot affect the real world. You may request several test databases.
- **Production**: the real upgrade; the production database is **unavailable** while it runs, and changes made in production **after** the copy was taken are **not** carried into the upgraded database. Freeze changes around cut-over.

The uploaded copy excludes the filestore — **merge the production filestore** into the test database so attachments/images match production.

## By hosting
- **Odoo Online**: upgrade from the database manager / Settings; no custom code, so you validate standard behavior and installed apps.
- **Odoo.sh**: upgrade a **staging** branch first, validate, then merge to production.
- **On-premise**: command line against the upgrade platform; you manage the server, Python (3.10+), PostgreSQL and filestore.

## Command line (on-premise / scripted)
Same command both phases, only the keyword changes (verify the current invocation in the docs):

```
python <(curl -s https://upgrade.odoo.com/upgrade) test -d <db-name> -t 18.0
python <(curl -s https://upgrade.odoo.com/upgrade) production -d <db-name> -t 18.0
```

## Sequence that works
1. Freeze scope; back up DB + filestore; record module list and versions.
2. Port custom modules to 18.0 on a branch (see `code-migration.md`); bump manifests to `18.0.x.y.z`.
3. Request the **test** upgrade; restore with the merged filestore; install/update your 18.0 modules with `--test-enable`.
4. Validate: automated tests, then a manual pass — a sample product through purchase -> receipt -> sale -> delivery -> invoice; validate and credit an invoice; key reports; an online checkout; portal; multi-company; crons. The official checklist is **not exhaustive** — add your business-critical flows.
5. Fix, re-request test upgrades until clean.
6. Schedule production for a quiet window; rehearse the run (ideally the day before). Confirm the staging/test upgrade succeeded first.
7. Run production, re-deploy the 18.0 custom code, smoke-test, then re-enable integrations/crons.

## Obsolete and third-party modules
- A module with no 18.0 version blocks loading. For each: find an 18.0 release, re-implement, replace with standard features, or uninstall and migrate its data **before** upgrading.
- OCA modules: confirm the `18.0` branch exists for every dependency.

## Rollback
- No in-place downgrade. Rollback = restore the 17.0 backup + filestore. Keep that backup until 18.0 has run a full business cycle.

## Support window
- Check supported versions and support duration: https://www.odoo.com/documentation/18.0/administration/supported_versions.html — avoid upgrading onto a version near end of support.
