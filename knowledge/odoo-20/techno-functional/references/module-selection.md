# Module (App) Selection

Scope source of truth: https://www.odoo.com/documentation/20.0/applications.html (categories: Essentials, Finance, Sales, Websites, Supply Chain, Human resources, Marketing, Services, Productivity, Studio, General settings). (ported from the 19.0 layout; verify in 20.0 docs)

## Need to app map (starting points)
- Leads, pipeline: CRM. Quotes/orders/invoicing policy: Sales (+ Subscriptions, Rental for recurring or rented items).
- Retail/restaurant counter: Point of Sale. Online shop: Website + eCommerce (+ online payments); wishlist and product comparison are part of `website_sale` in 20.
- Purchasing: Purchase. Stock, routes, warehouses: Inventory (+ Barcode); batch and wave picking are part of `stock` in 20. Production/BoMs: Manufacturing (+ Quality, Maintenance, PLM, Repairs).
- Books, invoices, bank reconciliation, taxes: Accounting and Invoicing + a fiscal localization. Expense claims: Expenses (in 20, expenses become draft vendor bills).
- People: Employees, Time off, Attendances, Recruitment, Appraisals, Payroll (country rules come from the localization; payroll work entries are removed in 20).
- Services: Project, Timesheets, Planning (now carries the former Field Service features), Helpdesk. Field Service is discontinued in 20.
- Documents, e-signature, knowledge, spreadsheets, dashboards: Documents, Sign, Knowledge, Spreadsheet, Dashboards.
- Marketing: Email/SMS Marketing, Marketing Automation, Events, Surveys.
Confirm each app's current scope on its 20.0 page before promising a feature.

## Odoo 20: modules removed, merged or discontinued (check before selecting)
| Module / app | In 20 | Selection consequence |
|---|---|---|
| `base_vat` | removed | VAT-number validation is no longer a separate module; where it lives now: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html) |
| `base_iban` | removed | IBAN validation is no longer a separate module; where it lives now: (verify in 20.0 docs: same page) |
| `stock_picking_batch` | merged into `stock` | batch/wave picking needs no extra module; no separate install step |
| `website_sale_wishlist`, `website_sale_comparison` | merged into `website_sale` | wishlist/comparison are core eCommerce; drop any separate-module assumption |
| `hr_org_chart` | removed | do not promise the org chart widget as a module; propose an alternative or a gap |
| `hr_homeworking` | removed | homeworking tracking is a gap or a process change |
| `delivery_mondialrelay` | removed | remove Mondial Relay from the carrier shortlist; pick another carrier connector |
| `transifex` | removed | translation workflow tied to it is a gap; plan another way to manage translations |
| `hr_work_entry_holidays`, `l10n_fr_hr_work_entry_holidays` | removed | go with the removal of payroll work entries: payslips no longer assume work entries; re-validate each payroll localization (verify in 20.0 docs) |
| Field Service | discontinued; features moved into Planning | specify field work on Planning + Project + Sales; migration for current FSM users is a project |
Functional shifts that change which app owns a process: account groups are replaced by parent accounts, payment statuses are renamed, bank-impacting journal entries must originate from bank transactions, expenses become draft vendor bills.

## Procedure
1. List processes end to end (lead-to-cash, procure-to-pay, plan-to-produce, hire-to-retire, record-to-report).
2. Assign each step to an app; note cross-app handoffs (sale -> delivery -> invoice).
3. Check dependencies: installing one app installs others; list the resulting footprint. Cross-check against the removed/merged table above.
4. Check edition and hosting: Community vs Enterprise, Odoo Online/Odoo.sh/on-premise (https://www.odoo.com/documentation/20.0/administration.html). Studio on Odoo Online requires the Custom plan (https://www.odoo.com/documentation/20.0/applications/studio.html), and so does the JSON-2 external API (`/json/2/<model>/<method>`), which replaces the deprecated XML-RPC/JSON-RPC; the `db` service is removed in 20. Pricing: confirm with the Odoo account manager.
5. Check localization: country accounting, taxes, e-invoicing, payroll (https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html).
6. Check third-party/OCA/custom modules: maintained for 20, license, overlap with standard. OCA had no 20.0 branches as of 2026-09-24 (OpenUpgrade included; re-check): treat every OCA module as unavailable on 20 until a 20.0 branch exists, and prefer standard or a small custom extension.
7. Check platform for on-premise/Odoo.sh: Python >= 3.12, PostgreSQL >= 16.
8. Phase the rollout: core transactional apps first, then analytics/automation; avoid big-bang unless required.

## Red flags
- An app selected for one minor feature that drags in heavy dependencies.
- Two modules covering the same process (custom plus standard).
- No owner for master data (products, partners, BoMs, employees).
- A solution that depends on a module removed in 20 (see table) or on an OCA add-on with no 20.0 branch.
- A requirement written around Field Service as a separate app, or around payroll work entries.
