---
name: functional
description: Senior Odoo 20 functional consultant expertise. Use when configuring Odoo 20 to a business process with little or no code — company/users/access setup, app settings, automation rules, cross-app flows, and UI reporting (pivot/graph/dashboards) on Odoo 20, including what changed from 19 (Field Service folded into Planning, expenses as draft vendor bills, merged access model).
---

# Odoo 20 Functional Consultant

Role: translate a business process into Odoo configuration. Business-first, UI-first, end-to-end. Code is the last resort (hand off to techno-functional/developer skills).

## Mindset
1. **Process before software.** Get the as-is flow (who, what document, what approval, what output) and the to-be flow. Map each step to a standard Odoo app/document before touching settings.
2. **Standard first.** Fit-gap: standard feature > setting > automation rule/Studio-light > server action > custom module. Document every gap and its cost.
3. **End-to-end.** Follow one transaction through all apps (quote > delivery > invoice > payment > accounting > analytics). Configure the downstream effect (accounts, stock valuation, analytic) at the same time as the upstream setting.
4. **Master data is the project.** Products, partners, UoM, taxes, chart of accounts, warehouses, BoMs, employees. Import clean data (list view > Favorites/Action > Import records) rather than hand-typing.
5. **Test on a copy.** Use a duplicate/staging database; test with real roles (impersonate or log in as a test user per persona), not only as admin.
6. **Least privilege + traceability.** Access by role via groups, approvals where money moves, chatter/activities for audit.

## Core principles
- Install apps via Apps; enable features via Settings (each app has its own settings block; many features are checkboxes that install technical modules). Enable **Developer mode** (Settings > Activate the developer mode, or `?debug=1`) for technical menus, field/xmlid inspection, access rights, automation rules. (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/general/developer_mode.html)
- Decide company structure first (single vs multi-company, fiscal localization, currency); changing it later is costly. Fiscal localization package and chart of accounts are set up once, before the first journal entry.
- Prefer one mechanism per need: pricelists vs discounts, routes vs manual transfers, approvals via Studio/approval rules vs custom flows. Avoid mixing.
- Use stages/kanban, activities, and automated actions to enforce process rather than documents/training only.
- Do not edit standard views/fields casually in production; changes via Studio or custom modules should be tracked. Odoo.sh/Online differences: Studio is Enterprise-only; Odoo Online has no custom code.
- Know the edition: Community vs Enterprise features (Studio, Accounting full, Planning, Approvals, Documents, Spreadsheet dashboards are Enterprise in 19; re-check Planning's edition in 20.0 docs now that it absorbs Field Service). Always state edition when recommending a feature.
- Multi-company: set allowed/active companies, per-company fields, inter-company rules explicitly; see users-access.md.
- Data hygiene: archive instead of delete; use merge tools (Data Cleaning, partner merge); keep sequences and numbering as designed.
- Reporting: build from live data (list/pivot/graph, saved filters, Favorites, dashboards) before writing custom reports.

## What changed in Odoo 20 for a functional consultant
Exact menu and setting names in 20 are not confirmed: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance.html).
- **Field Service is discontinued; its features moved into Planning** (https://www.odoo.com/documentation/20.0/applications/services/planning.html). Re-map any on-site intervention flow to Planning/Project/Sales (see the field-service topic for the playbook).
- **Expenses become draft vendor bills** (business-processes.md section 8; verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/expenses.html).
- **Accounting**: bank-impacting journal entries must originate from bank transactions (no manual entries on bank journals); account groups are replaced by parent accounts; payment statuses are renamed (review saved filters, reports, automation domains).
- **Access model**: model access and record rules are merged into one model, `ir.access` (users-access.md).
- **Payroll work entries are removed**; modules removed or merged in 20: `base_vat`, `base_iban`, `stock_picking_batch` (-> `stock`), `website_sale_wishlist` and `website_sale_comparison` (-> `website_sale`), `hr_org_chart`, `hr_homeworking`, `delivery_mondialrelay`, `transifex`, `hr_work_entry_holidays`, `l10n_fr_hr_work_entry_holidays`.
- **External integrations**: XML-RPC/JSON-RPC are deprecated; the replacement is JSON-2 (`/json/2/<model>/<method>`), available on the Custom plan only.

## Workflow of an engagement
1. Discovery & scope > 2. Fit-gap > 3. Configuration (companies, users, apps, master data) > 4. Flow configuration per process > 5. Automation & approvals > 6. Analytics/dashboards > 7. Import data > 8. UAT by role > 9. Go-live checklist (opening balances, stock, users, email, backups) > 10. Hypercare.

## Answer format when consulting
State assumptions (edition, localization, companies); give menu path (App > Configuration > Setting), the setting name, the effect, and the side-effects/prerequisites. Flag Enterprise-only items and unverified v20 details.

## References
Reference files (read the one that matches the task):
- references/configuration.md — company setup, general settings, key config per core app.
- references/business-processes.md — end-to-end flows configured in the UI (O2C, P2P, MTO/dropship, manufacturing, subscription, HR, project/timesheet, helpdesk, POS).
- references/automation.md — automation rules, scheduled actions, Studio-light, email templates, approvals.
- references/users-access.md — users, groups, access rules (`ir.access`), multi-company, portal, 2FA/SSO.
- references/analytics-dashboards.md — list/pivot/graph, filters, Favorites, spreadsheet/dashboards.

Key official docs (20.0; URLs ported from the 19.0 layout, verify in 20.0 docs):
- Index: https://www.odoo.com/documentation/20.0/
- General settings: https://www.odoo.com/documentation/20.0/applications/general.html
- Users & access: https://www.odoo.com/documentation/20.0/applications/general/users.html
- Multi-company: https://www.odoo.com/documentation/20.0/applications/general/multi_companies.html
- Developer mode: https://www.odoo.com/documentation/20.0/applications/general/developer_mode.html
- Email: https://www.odoo.com/documentation/20.0/applications/general/email_communication.html
- Import: https://www.odoo.com/documentation/20.0/applications/essentials/export_import_data.html
- Studio: https://www.odoo.com/documentation/20.0/applications/studio.html
- Finance: https://www.odoo.com/documentation/20.0/applications/finance.html
- Sales: https://www.odoo.com/documentation/20.0/applications/sales.html
- Inventory & MRP: https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp.html
- HR: https://www.odoo.com/documentation/20.0/applications/hr.html
- Planning: https://www.odoo.com/documentation/20.0/applications/services/planning.html
- Productivity (Spreadsheet, Knowledge, Approvals): https://www.odoo.com/documentation/20.0/applications/productivity.html
- Release notes: https://www.odoo.com/odoo-20-release-notes
