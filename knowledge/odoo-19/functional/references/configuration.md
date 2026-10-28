# Configuration (Odoo 19)

Docs: https://www.odoo.com/documentation/19.0/applications/general.html — per-app docs under /applications/{sales,finance,inventory_and_mrp,hr,websites,services,productivity}.html

## 1. Company and base setup (order matters)
1. **Database/instance**: language(s) (Settings > Languages), currencies (activate needed ones; rates auto-update option in Accounting settings), timezone per user.
2. **Company**: Settings > Companies > Update Info — name, address, VAT/tax ID, logo, currency, company registry, colors. Document layout: Settings > General Settings > Business Documents > Configure Document Layout (template, logo, footer, paper format, default terms).
3. **Fiscal localization**: Accounting > Configuration > Settings > Fiscal Localization — choose package (sets chart of accounts, taxes, fiscal positions, reports). Do before any posting; changing later is hard. (https://www.odoo.com/documentation/19.0/applications/finance/fiscal_localizations.html)
4. **Apps**: install only what the process needs; each install adds menus/settings. Uninstall is destructive for related data.
5. **Email**: outgoing mail server (Settings > Technical > Outgoing Mail Servers; or Odoo Online default); incoming via catchall/alias domain (Settings > General Settings > Discuss > Custom Email Servers / alias domain). Set SPF/DKIM/DMARC for the sending domain. (https://www.odoo.com/documentation/19.0/applications/general/email_communication.html)
6. **Users and groups**: see users-access.md.
7. **Master data import**: Partners, products, chart, employees via Import records (CSV/XLSX; use External ID column for updates/relations).

## 2. General Settings highlights
- Users: invite users, default access rights, **Multi-company** toggle is implicit (create >1 company).
- Companies: document layout, default taxes.
- Integrations: Mail Plugin, Google/Microsoft calendar sync, OAuth/SSO providers (Authentication), reCAPTCHA, address autocomplete, Unsplash, cloud storage.
- Developer Tools: Activate developer mode; **Load demo data / Neutralize** (neutralize in staging prevents emails/crons).
- Discuss: activities, mail templates, SMS provider (IAP credits).
- Contacts: **Customer Account** (portal signup: invitation vs free signup) under Website/Portal settings.

## 3. Key configuration per core app

### Contacts
Individuals vs companies; address types (invoice/delivery/other); tags; fiscal position, payment terms, pricelist, salesperson on partner; reference/VAT validation; duplicates merge via Data Cleaning/Merge.

### Sales
- Settings: Quotations & Orders (Quotation Templates, Online Signature/Payment, Margins, Discounts, Delivery Methods, Customer Addresses, Sales Teams, Pro-Forma Invoice, Lock confirmed orders, Order approval via "Sales Order Approval" per amount).
- Products: type (Goods / Service / Combo — verify v19 product type wording: https://www.odoo.com/documentation/19.0/applications/sales/sales/products_prices/products.html), invoicing policy (ordered vs delivered quantities; milestones/timesheets for services), taxes, UoM, variants.
- Pricing: Pricelists (Settings > Pricing > Pricelists; rules by product/category/qty/date; formula/fixed/discount). Discounts per line. Coupons/Promotions (Loyalty).
- Invoicing: invoice on order vs delivery; down payments; payment terms; online payment providers.

### Purchase
Vendor pricelists on product (Purchase tab); RFQ > PO; Purchase Agreements (Blanket/Call for tenders); 3-way match = Vendor Bills "Bill Control" on product (ordered vs received qty); PO approval (Settings > Purchase > Purchase Order Approval, minimum amount); lead times (vendor, security lead time); reordering rules for replenishment.

### Inventory
- Settings: Storage Locations, Multi-Step Routes, Lots & Serial Numbers, Packages, Units of Measure, Delivery Methods, Barcode, Product Packaging, Batch/Wave transfers (verify exact v19 names: https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/inventory.html).
- Warehouse: reception steps (1/2/3), delivery steps (1/2/3 — pick/pack/ship), routes (MTO, Buy, Manufacture, Dropship, Resupply).
- Product: **Track Inventory** and tracking by lot/serial, routes, reordering rules (min/max, trigger auto/manual), removal strategy (FIFO/LIFO/FEFO/closest).
- Valuation: costing method (Standard/Average/FIFO) and **Automated vs Manual** inventory valuation set on product category + stock accounts. Costing method and valuation are Accounting-impacting: decide with finance before go-live. (v19 changed inventory valuation internals — verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/inventory/product_management.html)
- Initial stock: Inventory > Operations > Physical Inventory (apply counts) or import.

### Manufacturing
Work Orders (routings), Work Centers, BoMs (manufacture/kit), by-products, subcontracting, Quality, PLM (Enterprise). Product route "Manufacture"; MTO optional. Operations/lead times for planning.

### Accounting
- Settings: Taxes (default sale/purchase), Currencies, Customer Payments, Default accounts, Fiscal periods/lock dates (Lock Dates), Analytic Accounting, Budgets, Assets/Deferred (Enterprise), Bank Synchronization (Enterprise), Invoice Digitization/OCR (IAP).
- Journals (Sales, Purchase, Bank, Cash, Misc), payment methods, reconciliation models (Bank Reconciliation widget), payment terms, fiscal positions (map taxes/accounts by country/VAT).
- Analytic: Analytic Plans (Accounting > Configuration), distribution models auto-assign analytic by partner/product/account. Analytic is how project/department/cost-center P&L is obtained.
- Go-live: opening balances via Opening Journal Entry / import of trial balance, open invoices and bills as unpaid documents; set Fiscal Year and Lock Dates.
- Docs: https://www.odoo.com/documentation/19.0/applications/finance/accounting.html

### Point of Sale
Create PoS (Configuration), payment methods, pricelists, product categories shown, receipts, cash rounding, restaurants (floors/tables), sessions open/close, accounting journals. (https://www.odoo.com/documentation/19.0/applications/sales/point_of_sale.html)

### CRM
Pipeline stages, sales teams, lead vs opportunity toggle (Leads setting), lead scoring (Predictive Lead Scoring), assignment rules, activity types, mail aliases to create leads, lead mining (IAP).

### Project / Timesheets
Project stages/tasks, billable service products (Time & Materials, Fixed price/milestones), timesheet products and "Invoice based on timesheets", analytic account per project, rate cards (billing rate per employee/product).

### HR
Employees (Private info, Work info, HR settings), departments, job positions, work schedules (Resource Calendars), public holidays, Time Off types + allocations + approvers, Attendance (kiosk/check in-out), Recruitment pipeline, Expenses (categories, reinvoicing), Payroll (Enterprise; salary structures, rules, localization). (https://www.odoo.com/documentation/19.0/applications/hr.html)

### Website / eCommerce
Website, pricelists/currencies, payment providers, shipping methods, product publishing and categories, customer accounts, SEO. (https://www.odoo.com/documentation/19.0/applications/websites.html)

## 4. Config hygiene
- Record settings per company when multi-company (settings page switches by active company).
- Keep a configuration workbook: setting, value, rationale, owner.
- Use seed/import files to replicate config across environments; tag with External IDs.
- Never test with live email: use a neutralized or staging DB.
