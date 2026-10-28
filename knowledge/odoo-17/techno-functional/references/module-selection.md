# Module (App) Selection

Scope source of truth: https://www.odoo.com/documentation/17.0/applications.html (categories: Essentials, Finance, Sales, Websites, Supply Chain, Human resources, Marketing, Services, Productivity, Studio, General settings).

## Need to app map (starting points)
- Leads, pipeline: CRM. Quotes/orders/invoicing policy: Sales (+ Subscriptions, Rental for recurring or rented items).
- Retail/restaurant counter: Point of Sale. Online shop: Website + eCommerce (+ online payments).
- Purchasing: Purchase. Stock, routes, warehouses: Inventory (+ Barcode). Production/BoMs: Manufacturing (+ Quality, Maintenance, PLM, Repairs).
- Books, invoices, bank reconciliation, taxes: Accounting and Invoicing + a fiscal localization. Expense claims: Expenses.
- People: Employees, Time off, Attendances, Recruitment, Appraisals, Payroll (country rules come from the localization).
- Services: Project, Timesheets, Planning, Field Service, Helpdesk.
- Documents, e-signature, knowledge, spreadsheets, dashboards: Documents, Sign, Knowledge, Spreadsheet, Dashboards.
- Marketing: Email/SMS Marketing, Marketing Automation, Events, Surveys.
Confirm each app's current scope on its 17.0 page before promising a feature.

## Procedure
1. List processes end to end (lead-to-cash, procure-to-pay, plan-to-produce, hire-to-retire, record-to-report).
2. Assign each step to an app; note cross-app handoffs (sale -> delivery -> invoice).
3. Check dependencies: installing one app installs others; list the resulting footprint.
4. Check edition and hosting: Community vs Enterprise, Odoo Online/Odoo.sh/on-premise (https://www.odoo.com/documentation/17.0/administration.html). Studio on Odoo Online requires the Custom plan (https://www.odoo.com/documentation/17.0/applications/studio.html). Pricing: confirm with the Odoo account manager.
5. Check localization: country accounting, taxes, e-invoicing, payroll (https://www.odoo.com/documentation/17.0/applications/finance/fiscal_localizations.html).
6. Check third-party/OCA/custom modules: maintained for 17, license, overlap with standard.
7. Phase the rollout: core transactional apps first, then analytics/automation; avoid big-bang unless required.

## Red flags
- An app selected for one minor feature that drags in heavy dependencies.
- Two modules covering the same process (custom plus standard).
- No owner for master data (products, partners, BoMs, employees).
