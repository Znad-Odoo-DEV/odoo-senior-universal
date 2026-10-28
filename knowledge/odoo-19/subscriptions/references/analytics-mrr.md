# Analytics: MRR, retention, churn

Source: https://www.odoo.com/documentation/19.0/applications/sales/subscriptions/reports.html

## Built-in analysis views (Subscriptions app)
- **Subscriptions Analysis**: counts and recurring revenue; default stacked bar graph with In Progress/Paused and Recurring filters.
- **Retention Analysis**: customizable chart only, Count measure default; no view switcher.
- **MRR Breakdown**: MRR and ARR splits; default stacked bars with MRR Change.
- **MRR Analysis**: time-based MRR analytics (description truncated in fetch; verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/sales/subscriptions/reports.html).
Views: Graph, Pivot (MRR by stage/month, by salesperson/referrer...), List.

## Filters
My Subscriptions, Quotations, In Progress, Paused, Churned, To renew, Recurring, Non-recurring, First contract date, Next Invoice Date, End Date, Custom Filter.

## Group by
Subscription State, Sales Team, Salesperson, Referrer, Customer, Country, Template, Plan, Product, First Contract Date, Next Invoice Date, End Date, Custom Group. Grouping order changes nesting.

## Measures
- Subscriptions Analysis: Expected Cost (untaxed minus margin), Monthly Recurring (gross MRR), Quantity, Recurring Revenue (by next recurrence period), Unit Price, Untaxed Amount Delivered, Untaxed Total, Yearly Recurring (projected annual regardless of billing period).
- MRR Breakdown/Analysis: Active Subscriptions Change, ARR Change, MRR Change.
- Retention Analysis also lists generic sales measures (Count, Margin, ...).
The docs do not formally define churn rate, logo churn or net revenue retention; the Churned filter only selects Churned orders.

## Analyst reasoning (derive, state assumptions)
- MRR = recurring lines normalized to a month (Monthly Recurring). ARR = Yearly Recurring.
- MRR movement = new + expansion (upsell) - contraction - churn; use MRR Breakdown, MRR Change by period and Subscription State.
- Logo churn % = customers churned in period / customers In Progress at period start (Pivot: Customer grouping, End Date filter).
- Revenue churn % = MRR lost to Churned in period / opening MRR.
- Forecast: To renew filter plus Next Invoice Date grouped by month = renewal pipeline; Yearly Recurring of In Progress = run-rate. Apply a churn assumption from history. A built-in forecast model is not documented (verify in 19.0 docs).
- Cut by Plan, Product, Salesperson, Country to locate churn; attribution by Close Reason depends on the reason being exposed as a grouping (verify on a test database).

## Pitfalls
- The default filter counts Paused; decide whether paused counts toward MRR.
- Multi-currency: MRR is in company currency; check conversion dates.
- Dirty close reasons make churn attribution meaningless.
