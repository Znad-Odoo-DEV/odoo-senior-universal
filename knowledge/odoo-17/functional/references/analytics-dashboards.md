# Analytics & Dashboards via the UI (Odoo 17)

Docs: https://www.odoo.com/documentation/17.0/applications/essentials/search.html ; https://www.odoo.com/documentation/17.0/applications/essentials/reporting.html (verify page in 17.0 docs) ; Spreadsheet: https://www.odoo.com/documentation/17.0/applications/productivity/spreadsheet.html ; Dashboards (Enterprise): https://www.odoo.com/documentation/17.0/applications/productivity/dashboards.html (verify)

## 1. Think first
Question > measure (what to sum/count/avg) > dimension (by what) > period > comparison > audience > refresh. Start in the transactional app's own list/pivot/graph; escalate to spreadsheet/dashboard only when stakeholders need a persistent view.

## 2. View types (switcher top right)
- **List**: columns picker (optional columns), group by, subtotal on numeric columns, export (select rows > Action > Export; choose fields, include "I want to update data" for import template).
- **Pivot**: rows/cols by groupable fields (date by day/week/month/quarter/year), measures (Count, Sum of fields), click header to expand/collapse, flip axes, Expand all, **Download xlsx**, **Insert in Spreadsheet** (Enterprise).
- **Graph**: bar/line/pie, stacked/cumulative, ascending/descending sort, measure, group-by (Add custom group).
- **Cohort** (Enterprise): retention/subscription churn. **Gantt, Calendar, Map, Activity** also exist where defined.
- **Dashboard view** (Enterprise, per app Reporting menu): KPI tiles + graph/pivot.
Use Reporting menu per app: Sales > Reporting (Sales, Salespersons, Products, Customers), Inventory > Reporting (Stock, Moves History, Moves Analysis, Valuation, Performance), Purchase > Reporting, Accounting > Reporting (Balance Sheet, P&L, Aged Receivable/Payable, General Ledger, Trial Balance, Cash Flow, Tax Return, Journals audit; Analytic Report), CRM > Reporting (Forecast, Pipeline, Leads, Activities), Project > Reporting (Tasks Analysis, Profitability), HR (Time Off, Attendance, Timesheets analysis). Names vary by edition/version — verify.

## 3. Search, Filters, Group By, Favorites
- Search bar: type to search fields (choose from dropdown), multiple facets (AND between facets, OR within a facet).
- **Filters** panel: predefined (My, Unpaid, Late…), **Add Custom Filter** = domain editor (and/or, fields via relations, dates with relative ranges like "last 30 days"; code editor in developer mode).
- **Group By**: predefined + custom (any groupable field); multi-level; date granularity.
- **Comparison** (date filters): compare period vs previous period / previous year in graph/pivot.
- **Favorites**: Save current search (name, **default** for the view, **shared** with all users; embedding into dashboard/action in Enterprise). A saved filter keeps filters + group by (+ context/view for some). Shared favorites are visible to everyone with the model access: audit them as part of access review.
- Manage via developer mode: Settings > Technical > User Interface > User-defined Filters.

## 4. Accounting analytics
- Financial statements: Balance Sheet, P&L, Cash Flow (Enterprise "report" engine with columns, comparison, Analytic filters, journals filter, export PDF/XLSX, drill down to journal items).
- Aged Receivable/Payable by partner; Partner Ledger; Trial Balance; General Ledger; Tax Report with closing.
- **Analytic accounts/plans**: Accounting > Configuration > Analytic Plans; assign to journal items/invoice lines; **Analytic Items** list/pivot; Distribution models; P&L with analytic filter; budget vs actual (Budgets, Enterprise). Project profitability and department P&L come from analytic.
- Custom financial lines: Enterprise Accounting reports can be configured in developer mode (Accounting > Configuration > Accounting Reports; verify v17 menu naming).

## 5. Spreadsheet & Dashboards (Enterprise)
- **Spreadsheet** (Documents/Dashboards): Excel-like with Odoo data functions: `ODOO.PIVOT`, `ODOO.LIST`, `ODOO.FILTER.VALUE`, `ODOO.CURRENCY.RATE`, `ODOO.ACCOUNT.BALANCE` etc. Create by: view > Insert in Spreadsheet (pivot/list/graph), or Documents > New Spreadsheet. Global filters (date, relation, text) bind to pivots/charts across sheets. Refresh to update. Share via Documents with access groups. Templates/freeze/format as Excel.
- **Dashboards app**: dashboards built from spreadsheets; sections, access by group, global filters; use "Add to dashboard" from a graph/pivot/list. Quick KPIs with scorecards. (https://www.odoo.com/documentation/17.0/applications/productivity/dashboards.html — verify)
- Spreadsheet vs export: spreadsheet stays live; export is static snapshot.
- Studio dashboard view: tiles via aggregates (Count/Sum with domain), graphs, pivots — no code.

## 6. Exports & Integration
- Export list: choose fields, xlsx/csv; save export templates (Export dialog > template).
- Share links via Documents; scheduled email of results via **Scheduled Actions + email template + attached view** is not standard no-code; alternative: automation sending links or spreadsheet shared (verify). Do not promise scheduled PDF dispatch without checking edition/app (e.g., Accounting "Send to" options).
- External BI: connect with read-only DB (Odoo.sh/On-prem) or via export/API (developer).

## 7. Designing a KPI set (functional)
Per process: Sales (pipeline value by stage, win rate, quotation>order conversion, DSO/aged receivable), Inventory (on hand vs reserved, turns, late deliveries, stock valuation), Purchase (lead time, spend by vendor, OTIF), MRP (OEE, MO cycle time, scrap), HR (headcount, absence, attrition, timesheet utilization), Finance (cash, AR/AP aging, P&L vs budget, analytic margin), Support (SLA hit rate, resolution time, rating).
Define for each: source model/menu, filter/group-by definition, owner, refresh cadence; save as shared Favorite or spreadsheet global filters.

## 8. Quality checks
- Reconcile totals with accounting (statements) before publishing.
- Watch company scope (active companies) and currency (multi-currency amounts in company currency fields, e.g. `price_subtotal` vs `*_signed`/`company_currency`).
- Draft/cancelled documents excluded? Check default filters.
- Archive/obsolete saved filters when fields change after upgrade.
- Access: users only see records they have access to; dashboards built by admin may show data others cannot — test as target user.
