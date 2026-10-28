# Environments: Online vs Odoo.sh vs on-premise

Hosting overview: https://www.odoo.com/documentation/19.0/administration/hosting.html

## Comparison
| Aspect | Odoo Online | Odoo.sh | On-premise |
|---|---|---|---|
| Hosting | Odoo SaaS | Odoo cloud platform | Your servers/cloud |
| Custom modules | Not supported (confirmed: incompatible with custom modules and Apps Store modules) | Yes, via Git repository | Yes |
| Non-code customization | Yes (Studio, automations, per plan) | Yes | Yes |
| Dev workflow | Duplicate databases for testing | Git branches (development, staging, production), builds | Own CI/CD and staging |
| Server access | None | Web shell, SSH, logs, editor | Full |
| Ops burden | Lowest | Low | Highest (OS, PostgreSQL, backups, TLS, monitoring) |
| Upgrades | Odoo upgrade service | Upgrade tab per branch, test then production | Upgrade platform plus own deployment |

Choose: no custom code and fast start -> Online. Custom modules or CI discipline without managing servers -> Odoo.sh. Data residency, special integrations, infrastructure control -> on-premise. Plan/edition constraints: verify in 19.0 docs: https://www.odoo.com/documentation/19.0/administration/odoo_online.html

## Odoo Online
- Database manager > Manage lists: duplicate, download a backup, rename, upgrade, delete, switch plans (confirmed).
- Test in a duplicate; never configure first in production. Duplicate before each risky change or import.
- Duplicate limits and mail behavior: verify in 19.0 docs: https://www.odoo.com/documentation/19.0/administration/odoo_online.html

## Odoo.sh
- Overview: https://www.odoo.com/documentation/19.0/administration/odoo_sh.html (web shell, module dependencies, continuous integration, SSH access)
- Getting started: https://www.odoo.com/documentation/19.0/administration/odoo_sh/getting_started.html
- Branches (stages Production / Staging / Development, merging; tabs History, Mails, Shell, Editor, Monitor, Logs, Backups, Upgrade, Tools, Settings): https://www.odoo.com/documentation/19.0/administration/odoo_sh/getting_started/branches.html
- Builds: https://www.odoo.com/documentation/19.0/administration/odoo_sh/getting_started/builds.html
- Settings (module installation, test suite, Odoo version, custom domains): https://www.odoo.com/documentation/19.0/administration/odoo_sh/getting_started/settings.html
- Flow: build features on development branches, validate on a staging branch with production-like data, merge to production only after sign-off. Exact behaviors (staging data copy, mails/crons disabled, backup frequency and retention): verify in 19.0 docs: https://www.odoo.com/documentation/19.0/administration/odoo_sh/getting_started/branches.html
- Take a manual backup before every production merge; test restores on staging.
- List module updates needed per release in the release note.

## On-premise
- Install: packages https://www.odoo.com/documentation/19.0/administration/on_premise/packages.html , source https://www.odoo.com/documentation/19.0/administration/on_premise/source.html
- System configuration/deployment: https://www.odoo.com/documentation/19.0/administration/on_premise/deploy.html
- Bugfix updates: https://www.odoo.com/documentation/19.0/administration/on_premise/update.html
- Registration: enter the subscription code in the dashboard banner (confirmed).
- Test copy: duplicate from `<server>/web/database/manager` and tick neutralize so outgoing mail and integrations are disabled (confirmed). Details: https://www.odoo.com/documentation/19.0/administration/neutralized_database.html
- Backups: database dump plus filestore, off-site copy, scheduled restore tests, documented RPO/RTO. Specifics: verify in 19.0 docs: https://www.odoo.com/documentation/19.0/administration/on_premise/deploy.html
- Community to Enterprise: https://www.odoo.com/documentation/19.0/administration/on_premise/community_to_enterprise.html

## Environment rules
1. Minimum: staging with production-like data, plus production. Add development where custom code exists.
2. Neutralize every copy of production: no real emails, payment calls, e-invoice submissions, or cron side effects.
3. Staging matches production in version, modules, settings.
4. One promotion path; no direct production edits except logged emergency fixes, back-ported.
5. Backup and verify restore before each promotion and before the final data load.
6. Least-privilege access; downgrade consultant access after hypercare.
