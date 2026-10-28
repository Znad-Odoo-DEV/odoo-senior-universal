# Analytics: MRR, retention, churn

Source (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/sales/subscriptions/reports.html

## Built-in analysis views (Subscriptions app)
- **Subscriptions Analysis**: counts and recurring revenue; default stacked bar graph with In Progress/Paused and Recurring filters.
- **Retention Analysis**: customizable chart only, Count measure default; no view switcher.
- **MRR Breakdown**: MRR and ARR splits; default stacked bars with MRR Change.
- **MRR Analysis**: time-based MRR analytics (description truncated in the 19.0 fetch; verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/subscriptions/reports.html).
Views: Graph, Pivot (MRR by stage/month, by salesperson/referrer...), List.

## Filters
My Subscriptions, Quotations, In Progress, Paused, Churned, To renew, Recurring, Non-recurring, First contract date, Next Invoice Date, End Date, Custom Filter.

## Group by
Subscription State, Sales Team, Salesperson, Referrer, Customer, Country, Template, Plan, Product, First Contract Date, Next Invoice Date, End Date, Custom Group. Grouping order changes nesting.

## Measures
- Subscriptions Analysis: Expected Cost (untaxed minus margin), Monthly Recurring (gross MRR), Quantity, Recurring Revenue (by next recurrence period), Unit Price, Untaxed Amount Delivered, Untaxed Total, Yearly Recurring (projected annual regardless of billing period).
- MRR Breakdown/Analysis: Active Subscriptions Change, ARR Change, MRR Change.
- Retention Analysis also lists generic sales measures (Count, Margin, ...).
Measure and filter names are as documented for 19.0; confirm they are unchanged on the 20.0 instance.
The docs do not formally define churn rate, logo churn or net revenue retention; the Churned filter only selects Churned orders.

## Analyst reasoning (derive, state assumptions)
- MRR = recurring lines normalized to a month (Monthly Recurring). ARR = Yearly Recurring.
- MRR movement = new + expansion (upsell) - contraction - churn; use MRR Breakdown, MRR Change by period and Subscription State.
- Logo churn % = customers churned in period / customers In Progress at period start (Pivot: Customer grouping, End Date filter).
- Revenue churn % = MRR lost to Churned in period / opening MRR.
- Forecast: To renew filter plus Next Invoice Date grouped by month = renewal pipeline; Yearly Recurring of In Progress = run-rate. Apply a churn assumption from history. A built-in forecast model is not documented (verify in 20.0 docs).
- Cut by Plan, Product, Salesperson, Country to locate churn; assigning churn to a Close Reason depends on the reason being exposed as a grouping (verify on a test database).

## Custom analytics on Odoo 20
- Custom MRR/churn queries that call `read_group` must use the public 20 signature `(domain, groupby, aggregates, having, offset, limit, order)`; calls with `fields=` and `lazy=` break. `_read_group` remains available.
- Models built on `_table_query` (SQL-view style reporting models) must be reworked: it is removed in 20.
- External BI pulling subscription data over XML-RPC/JSON-RPC: move to JSON-2 `/json/2/<model>/<method>` (Custom plan only) before the `common`/`object` services are removed in Odoo 22; the `db` service is already removed in 20.

## Pitfalls
- The default filter counts Paused; decide whether paused counts toward MRR.
- Multi-currency: MRR is in company currency; check conversion dates.
- Dirty close reasons make churn-by-reason analysis meaningless.
- Revenue reconciliation: invoice payment statuses are renamed in 20, so saved filters or exports keyed on old status labels must be rebuilt (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting.html).
