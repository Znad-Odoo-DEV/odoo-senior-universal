# Environments: Online vs Odoo.sh vs on-premise

_20.0 doc pages could not be fetched when this was adapted: URLs below follow the 19.0 layout (verify in 20.0 docs). Items marked "(confirmed)" were confirmed on the 19.0 docs and carried over; re-check them on 20.0._

Hosting overview: https://www.odoo.com/documentation/20.0/administration/hosting.html

## Comparison
| Aspect | Odoo Online | Odoo.sh | On-premise |
|---|---|---|---|
| Hosting | Odoo SaaS | Odoo cloud platform | Your servers/cloud |
| Custom modules | Not supported (confirmed: incompatible with custom modules and Apps Store modules) | Yes, via Git repository | Yes |
| Non-code customization | Yes (Studio, automations, per plan) | Yes | Yes |
| Dev workflow | Duplicate databases for testing | Git branches (development, staging, production), builds | Own CI/CD and staging |
| Server access | None | Web shell, SSH, logs, editor | Full |
| Runtime (Python / PostgreSQL) | Managed by Odoo | Provided by the platform build (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/administration/odoo_sh/getting_started/settings.html) | You provide Python >= 3.12 and PostgreSQL >= 16 |
| Ops burden | Lowest | Low | Highest (OS, PostgreSQL, backups, TLS, monitoring) |
| Upgrades | Odoo upgrade service | Upgrade tab per branch, test then production | Upgrade platform plus own deployment |

Choose: no custom code and fast start -> Online. Custom modules or CI discipline without managing servers -> Odoo.sh. Data residency, special integrations, infrastructure control -> on-premise. Plan/edition constraints: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/administration/odoo_online.html

## Runtime requirements for Odoo 20 (on-premise and custom builds)
- **Python >= 3.12** (Odoo 19 required 3.10) and **PostgreSQL >= 16** (Odoo 19 required 13). Both jumps are infrastructure projects: schedule them before the 20.0 install or before the production upgrade run.
- Distribution check (general OS knowledge, not from Odoo docs; confirm on your OS): Ubuntu 24.04 LTS ships Python 3.12 and PostgreSQL 16; older releases (for example Ubuntu 22.04 with Python 3.10 / PostgreSQL 14, or Debian 12 with Python 3.11 / PostgreSQL 15) need extra repositories, a newer interpreter, or a container image.
- PostgreSQL major upgrades are not in-place package upgrades: use dump/restore or `pg_upgrade`, rehearse on a copy, and keep the old cluster until the cutover is accepted.
- Pin the exact Python and PostgreSQL versions in the runbook, and use the same versions in dev, staging and production (rule 3 below).
- Confirm the requirement list on the 20.0 pages before building images: https://www.odoo.com/documentation/20.0/administration/on_premise/source.html (confirmed in 20.0 docs: Python 3.12 or later, PostgreSQL 16.0 or above; the page also carries a stale note saying 3.10, the 3.12 figure is current).

## Third-party and OCA modules (ecosystem check)
- As of 2026-09-24 OCA had **no 20.0 branches** (OpenUpgrade included). This is volatile: **re-check** the OCA repositories and each vendor's compatibility statement at kickoff and again at every phase gate.
- Inventory every non-core module (OCA, Apps Store, in-house). Per module: 20.0 release exists / ported in-house / replace with standard / drop. Modules without a 20.0 path become fit-gap items with a cost.
- Odoo Online cannot run these modules at all; Odoo.sh and on-premise can, but only once a 20.0-compatible version exists.
- Modules removed or merged in 20.0 (`base_vat`, `base_iban`, `stock_picking_batch`, `website_sale_wishlist`, `website_sale_comparison`, `hr_org_chart`, `hr_homeworking`, `delivery_mondialrelay`, `transifex`, `hr_work_entry_holidays`, `l10n_fr_hr_work_entry_holidays`) break any custom or third-party module that lists them in `depends`.

## Integrations and external API (Odoo 20)
- XML-RPC and JSON-RPC are deprecated in 20; the `db` service is removed in 20; the `common` and `object` services are scheduled for removal in Odoo 22 (fall 2028). The replacement is JSON-2 at `/json/2/<model>/<method>`, available on the Custom plan only.
- Hosting impact: on Odoo Online, integrations that must keep working need a plan that includes JSON-2. Scripts that create, duplicate, back up or drop databases through the `db` service stop working in 20 (replacement: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/administration.html).
- Test integrations on staging with API keys created for the integration user, not an admin password.

## Odoo Online
- Database manager > Manage lists: duplicate, download a backup, rename, upgrade, delete, switch plans (confirmed).
- Test in a duplicate; never configure first in production. Duplicate before each risky change or import.
- Duplicate limits and mail behavior: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/administration/odoo_online.html

## Odoo.sh
- Overview: https://www.odoo.com/documentation/20.0/administration/odoo_sh.html (web shell, module dependencies, continuous integration, SSH access)
- Getting started: https://www.odoo.com/documentation/20.0/administration/odoo_sh/getting_started.html
- Branches (stages Production / Staging / Development, merging; tabs History, Mails, Shell, Editor, Monitor, Logs, Backups, Upgrade, Tools, Settings): https://www.odoo.com/documentation/20.0/administration/odoo_sh/getting_started/branches.html
- Builds: https://www.odoo.com/documentation/20.0/administration/odoo_sh/getting_started/builds.html
- Settings (module installation, test suite, Odoo version, custom domains): https://www.odoo.com/documentation/20.0/administration/odoo_sh/getting_started/settings.html
- Flow: build features on development branches, validate on a staging branch with production-like data, merge to production only after sign-off. Exact behaviors (staging data copy, mails/crons disabled, backup frequency and retention): verify in 20.0 docs: https://www.odoo.com/documentation/20.0/administration/odoo_sh/getting_started/branches.html
- Take a manual backup before every production merge; test restores on staging.
- List module updates needed per release in the release note (https://www.odoo.com/odoo-20-release-notes).

## On-premise
- Install: packages https://www.odoo.com/documentation/20.0/administration/on_premise/packages.html , source https://www.odoo.com/documentation/20.0/administration/on_premise/source.html
- System configuration/deployment: https://www.odoo.com/documentation/20.0/administration/on_premise/deploy.html
- Bugfix updates: https://www.odoo.com/documentation/20.0/administration/on_premise/update.html
- Registration: enter the subscription code in the dashboard banner (confirmed).
- Test copy: duplicate from `<server>/web/database/manager` and tick neutralize so outgoing mail and integrations are disabled (confirmed). Details: https://www.odoo.com/documentation/20.0/administration/neutralized_database.html
- Backups: database dump plus filestore, off-site copy, scheduled restore tests, documented RPO/RTO. Specifics: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/administration/on_premise/deploy.html
- Community to Enterprise: https://www.odoo.com/documentation/20.0/administration/on_premise/community_to_enterprise.html

## Environment rules
1. Minimum: staging with production-like data, plus production. Add development where custom code exists.
2. Neutralize every copy of production: no real emails, payment calls, e-invoice submissions, or cron side effects.
3. Staging matches production in version, modules, settings, and runtime (Python / PostgreSQL).
4. One promotion path; no direct production edits except logged emergency fixes, back-ported.
5. Backup and verify restore before each promotion and before the final data load.
6. Least-privilege access; downgrade consultant access after hypercare.
