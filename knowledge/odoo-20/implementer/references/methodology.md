# Implementation methodology

_20.0 doc pages could not be fetched when this was adapted: URLs follow the 19.0 layout (verify in 20.0 docs). Items marked "(confirmed)" were confirmed on the 19.0 docs and carried over._

## Phases and gates
| Phase | Outputs | Gate |
|---|---|---|
| 1 Discovery | As-is process maps, scope, objectives, stakeholders, constraints (legal, localization, integrations), hosting choice, target version | Scope baseline signed |
| 2 Design / fit-gap | Fit-gap matrix, to-be processes, data model, roles/access matrix, integration list, migration scope | Design sign-off per app |
| 3 Build / configure | Configured test database, custom modules (if hosting allows), reports, templates, automations | Config complete, internal test passed |
| 4 Data migration | Mapping sheets, import files, dry runs, reconciliation | Reconciliation accepted |
| 5 UAT | Scripts executed by key users, defect log | UAT sign-off |
| 6 Training | Role-based sessions, guides | Attendance + competence check |
| 7 Cutover / go-live | Cutover plan, freeze, final load, go/no-go | Go decision |
| 8 Hypercare | Triage, fixes, stabilization, handover | Exit criteria met |

## Fit-gap
Per requirement record: id, process, app, MoSCoW priority, fit class (Standard / Configuration / Studio-automation / Custom / Process change / Rejected), effort, owner, decision. Challenge every "must" that needs custom code: what does changing the process cost instead? Re-check against Odoo 20 features before building (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications.html).

Odoo 20 fit-gap prompts (each is a process change or a gap, not a configuration option):
- Field Service is discontinued: its features moved into Planning. Any field-service requirement is re-fitted against Planning/Project/Sales (see the field-service topic).
- Payroll work entries are removed: payslip inputs for attendance and time off are re-designed with the payroll consultant.
- Bank-impacting journal entries must originate from bank transactions; account groups are replaced by parent accounts; payment statuses are renamed; expenses become draft vendor bills. Finance validates these in the design phase.
- Batch/wave picking is core `stock` (the `stock_picking_batch` module is merged); wishlist and comparison are core `website_sale`; `delivery_mondialrelay`, `hr_org_chart`, `hr_homeworking`, `transifex` are removed.
- Any OCA/third-party module in scope: does a 20.0 release exist? As of 2026-09-24 OCA had no 20.0 branches (re-check).

## Choosing the target version
- New implementation: 20.0 gives the longest support runway (each major is supported for three years, confirmed on the 19.0 Upgrade page; the 20.0 end date: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/administration/supported_versions.html).
- Reasons to start on 19.0 instead: a required OCA/third-party module without a 20.0 release (as of 2026-09-24; re-check), infrastructure that cannot yet move to Python 3.12 / PostgreSQL 16, or a vendor integration still on XML-RPC/JSON-RPC. Record the decision and the planned 20.0 upgrade date in the design log.
- 19.0 standard support runs to Sept 2028. Starting on 18.0 (Sept 2027) or 17.0 (ended Sept 2026) is not recommended for a new project.

## Governance
- Steering committee (sponsor, project lead, finance, operations); weekly project meeting; key-user workshops.
- RACI per app. One decision maker per topic.
- Change control: request, impact (scope/cost/date/upgrade), approval, new baseline version.
- RAID log reviewed weekly. Top risks: late data, scope creep, key-user availability, integration vendors, customization debt, third-party modules without a 20.0 release.

## Scoping tips
- Count what drives effort: companies, warehouses, currencies, languages, chart of accounts, products/variants, BOM depth, users/roles, integrations (and their API: XML-RPC/JSON-RPC to JSON-2), legacy volumes.
- Confirm the fiscal localization package and e-invoicing obligations per country early (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html). `base_vat` and `base_iban` are removed in 20, so check VAT-number and IBAN validation behavior per country.
- Buffer migration and UAT; those slip first.

## Customization policy
Order of preference: configuration, automated actions/Studio (where the plan includes them), extension module with minimal inherited views, new module. Each custom item: spec, owner, tests, upgrade note. On Odoo Online no custom modules are possible (confirmed on the Odoo Online page). Custom code written for 20.0 uses the new security model (`ir.access`), OWL 3 and the public `read_group` signature, which raises the cost of porting anything inherited from 19.

## Upgrade awareness
The Upgrade page states each major version is supported for three years and upgrades are required over time, with a test upgrade before production (confirmed on the 19.0 page: https://www.odoo.com/documentation/20.0/administration/upgrade.html ; verify in 20.0 docs).
- Standard support ends: **19.0 Sept 2028**, **18.0 Sept 2027**, **17.0 Sept 2026 (already ended)**.
- **Enterprise surcharge**: a database older than the 3 latest majors can be charged **+25%**, no earlier than 6 months after a new major is released. With 20.0 out, the three latest majors are 18.0, 19.0 and 20.0, so Enterprise databases on 17.0 or older are exposed. Put the surcharge and the upgrade project on the same budget line.
- Exact deadlines and extended support: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/administration/supported_versions.html (the 19.0 layout also referenced https://www.odoo.com/documentation/20.0/administration/standard_extended_support.html ; verify which page exists).

## Measuring success
After go-live track: month-end close time, order-to-cash cycle, inventory accuracy, active users, tickets per week, defect backlog.
