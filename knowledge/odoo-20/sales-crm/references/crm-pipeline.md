# CRM Pipeline (Odoo 20)

Base: https://www.odoo.com/documentation/20.0/applications/sales/crm/
Pages (relative to crm/; ported from the 19.0 layout, verify in 20.0 docs): pipeline/lost_opportunities.html, pipeline/merge_similar.html, pipeline/manage_sales_teams.html, acquire_leads/convert.html, acquire_leads/opportunities_form.html, acquire_leads/email_manual.html, acquire_leads/send_quotes.html, acquire_leads/lead_mining.html, track_leads/lead_scoring.html, track_leads/resellers.html, optimize/utilize_activities.html, optimize/lead_enrichment.html, optimize/partner_autocomplete.html, optimize/gamification.html, optimize/member_partner_module.html

## Leads vs opportunities
- Leads are an optional pre-qualification layer (CRM settings). Without it, every record is an opportunity in the pipeline.
- Convert lead to opportunity (convert.html): links/creates the customer, can merge duplicates, assigns team/salesperson.
- Sources: web contact form (opportunities_form.html), email alias or manual (email_manual.html), lead mining via IAP credits (lead_mining.html), enrichment (lead_enrichment.html).

## Stages and teams
- Stages can be team-specific or shared. Keep fewer than about 6, each with a clear exit rule. Probability: stage-based or predictive. Details: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/crm.html).
- Sales teams hold members, pipeline and assignment settings (manage_sales_teams.html). Team-based visibility is access configuration: in 20 it is expressed through `ir.access` (record rules are merged into it), so port custom team rules to `ir.access.csv`.
- Predictive lead scoring and assignment rules: track_leads/lead_scoring.html. Domain/capacity assignment and scheduler specifics: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/crm/track_leads/lead_scoring.html).
- Resellers: assign to partners graded as resellers (resellers.html).

## Activities
- Activity types carry default delay and chaining; activity plans bundle steps launched on a record (utilize_activities.html). Rule: every open opportunity has a planned next activity; overdue-activity filters are the daily list.

## Lost and merge
- Marking lost asks for a configurable lost reason; lost records are archived but restorable (lost_opportunities.html). Keep reasons few and mutually exclusive.
- Merge duplicates (merge_similar.html); chatter history is combined.

## Quotation link
- New Quotation from an opportunity pre-fills customer, team, salesperson and UTM attribution (send_quotes.html). Won-marking on order confirmation: verify behavior in a test.

## Pitfalls
- Enabling leads later changes intake only; existing records stay.
- Auto-assignment without capacity limits floods one rep.
- Mining and enrichment spend IAP credits; confirm budget.
- Deleting stages with records: move, then archive.
