# Analytics and Forecast (Odoo 18)

Base: https://www.odoo.com/documentation/18.0/applications/sales/crm/
Confirmed pages (relative to crm/): performance/win_loss.html (Pipeline Analysis), performance/expected_revenue_report.html, performance/forecast_report.html, track_leads/unattended_leads_report.html, track_leads/quality_leads_report.html, track_leads/marketing_attribution.html, track_leads/lead_distribution_report.html
Sales-side analysis pages were not listed on the Sales index: (verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/sales/sales.html).

## CRM analytics
- Pipeline Analysis: wins and losses by stage, team, source, lost reason. Use pivot/graph with group-by; choose created vs closed date deliberately.
- Expected revenue: opportunity revenue weighted by probability, grouped by expected closing date. Quality depends on filled expected closing date and revenue.
- Forecast: opportunities by expected closing period; drag between periods to re-plan. Records without a closing date land in an unassigned column.
- Lead analytics: unattended leads, quality leads, distribution, marketing attribution (UTM source/medium/campaign).

## Practice
- Make fields mandatory only where needed: expected revenue, closing date, lost reason, source.
- Compare forecast vs actual monthly to calibrate stage probabilities; use predictive probability only with enough data volume.
- Goals and motivation: CRM gamification (optimize/gamification.html).
- Sales order analytics (orders, invoiced, margin by product/customer): use Sales analysis views; margin needs the margin setting. Menu names: (verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/sales/sales.html).

## Pitfalls
- Weighted revenue misleads when probabilities are stale or based on little data.
- Multi-currency revenue converts to company currency at the record-date rate.
- Lost (archived) records vanish from default views; add the Lost filter for win/loss analysis.
- UTM data is lost if forms or imports bypass source/medium/campaign.
