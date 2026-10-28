# Implementation methodology

## Phases and gates
| Phase | Outputs | Gate |
|---|---|---|
| 1 Discovery | As-is process maps, scope, objectives, stakeholders, constraints (legal, localization, integrations), hosting choice | Scope baseline signed |
| 2 Design / fit-gap | Fit-gap matrix, to-be processes, data model, roles/access matrix, integration list, migration scope | Design sign-off per app |
| 3 Build / configure | Configured test database, custom modules (if hosting allows), reports, templates, automations | Config complete, internal test passed |
| 4 Data migration | Mapping sheets, import files, dry runs, reconciliation | Reconciliation accepted |
| 5 UAT | Scripts executed by key users, defect log | UAT sign-off |
| 6 Training | Role-based sessions, guides | Attendance + competence check |
| 7 Cutover / go-live | Cutover plan, freeze, final load, go/no-go | Go decision |
| 8 Hypercare | Triage, fixes, stabilization, handover | Exit criteria met |

## Fit-gap
Per requirement record: id, process, app, MoSCoW priority, fit class (Standard / Configuration / Studio-automation / Custom / Process change / Rejected), effort, owner, decision. Challenge every "must" that needs custom code: what does changing the process cost instead? Re-check against Odoo 19 features before building (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications.html).

## Governance
- Steering committee (sponsor, project lead, finance, operations); weekly project meeting; key-user workshops.
- RACI per app. One decision maker per topic.
- Change control: request, impact (scope/cost/date/upgrade), approval, new baseline version.
- RAID log reviewed weekly. Top risks: late data, scope creep, key-user availability, integration vendors, customization debt.

## Scoping tips
- Count what drives effort: companies, warehouses, currencies, languages, chart of accounts, products/variants, BOM depth, users/roles, integrations, legacy volumes.
- Confirm the fiscal localization package and e-invoicing obligations per country early (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/finance/fiscal_localizations.html).
- Buffer migration and UAT; those slip first.

## Customization policy
Order of preference: configuration, automated actions/Studio (where the plan includes them), extension module with minimal inherited views, new module. Each custom item: spec, owner, tests, upgrade note. On Odoo Online no custom modules are possible (confirmed on the Odoo Online page).

## Upgrade awareness
The Upgrade page states each major version is supported for three years and upgrades are required over time, with a test upgrade before production (confirmed: https://www.odoo.com/documentation/19.0/administration/upgrade.html). Exact deadlines and extended support: verify in 19.0 docs: https://www.odoo.com/documentation/19.0/administration/standard_extended_support.html

## Measuring success
After go-live track: month-end close time, order-to-cash cycle, inventory accuracy, active users, tickets per week, defect backlog.
