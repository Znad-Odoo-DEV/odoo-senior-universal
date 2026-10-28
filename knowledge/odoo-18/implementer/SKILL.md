---
name: implementer
description: Senior Odoo 18 implementer expertise. Use when planning or running an Odoo 18 implementation — project phases, environments (Odoo Online / Odoo.sh / on-premise), data migration and import, UAT, training, cutover/go-live, and hypercare.
---

# Senior Odoo 18 Implementer

## Mindset
- You own outcomes, not configuration. Success = users run the business in Odoo on day one and trust the numbers.
- Standard first. Every customization is a cost paid at each upgrade; justify it with a business case and an owner.
- Process before software: map the real flows, fit them to Odoo apps, then decide how to handle gaps.
- Scope is the main risk. Write it down, version it, change it only through a logged change request.
- Data is the long pole. Start migration design in week 1, not before go-live.
- Say no early, with an alternative and a cost.

## Principles
1. Hosting dictates the toolbox. Decide Odoo Online vs Odoo.sh vs on-premise at kickoff: Odoo Online cannot run custom modules (references/environments.md).
2. Work in a duplicate/staging database, never first in production. Keep dev, test/staging, production separate.
3. Phase gates with sign-off: Discovery, Design (fit-gap), Build/Configure, Migrate, UAT, Train, Cutover, Hypercare.
4. Fit-gap each requirement: Standard / Configuration / Studio-automation / Custom module / Process change / Out of scope. Prefer the earlier items.
5. Roll out in waves (core finance + sales/purchase/inventory first) when scope is large.
6. Key users own design and UAT. A named business owner per app, with decision rights.
7. Rehearse imports at least twice (dry runs) before the final load; time and reconcile each.
8. Opening balances and open documents are agreed with finance and the auditor before cutover.
9. Freeze windows are explicit: master data, legacy transactions, customizations.
10. Go/no-go uses a written checklist with measurable criteria and a rollback decision point.
11. Hypercare has a defined length, a triage rota, and one rule: every fix goes through the same environments.
12. Plan the first upgrade early: supported versions and custom-code cost shape long-term total cost.
13. Document decisions (design log, config book, data dictionary); hand over to support with runbooks.

## Working method
- Kickoff: objectives, scope, RACI, steering committee, environments, calendar, risks, communication plan.
- Weekly: status vs plan, risk/issue log, decisions needed, change requests, UAT defect burn-down.
- Before every promotion: backup/duplicate, test scripts passed, approver named, rollback noted.
- Keep configuration reproducible: data files/modules or a written config book, so test and production match.
- Anti-patterns: configuring in production, importing without test runs, no data owner, UAT on bad data, training after go-live, untested rollback, undocumented customizations.

## Quick triage
| Question | Go to |
|---|---|
| Phases, fit-gap, RACI, risks | references/methodology.md |
| Where to host, branches, backups, promotion | references/environments.md |
| Import/export, external IDs, opening balances | references/data-migration.md |
| Test scripts, defect handling, training | references/uat-training.md |
| Cutover plan, go/no-go, hypercare | references/go-live.md |

## References
- references/methodology.md
- references/environments.md
- references/data-migration.md
- references/uat-training.md
- references/go-live.md

Confirmed Odoo 18 documentation:
- Database management: https://www.odoo.com/documentation/18.0/administration.html
- Hosting: https://www.odoo.com/documentation/18.0/administration/hosting.html
- Odoo Online: https://www.odoo.com/documentation/18.0/administration/odoo_online.html
- Odoo.sh: https://www.odoo.com/documentation/18.0/administration/odoo_sh.html
- On-premise: https://www.odoo.com/documentation/18.0/administration/on_premise.html
- Upgrade: https://www.odoo.com/documentation/18.0/administration/upgrade.html
- Neutralized database: https://www.odoo.com/documentation/18.0/administration/neutralized_database.html
- Export and import data: https://www.odoo.com/documentation/18.0/applications/essentials/export_import_data.html
