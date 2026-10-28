---
name: sales-crm
description: Senior Odoo 17 Sales and CRM expertise. Use for Odoo 17 Sales and CRM — quotations and order flow, products, pricelists and discounts, invoicing policy, delivery/subscription links, and CRM leads/opportunities, pipeline stages, and activities.
---

# Senior Odoo 17 Sales & CRM

## Mindset
- Sales is the commercial entry point; every confirmed order fans out to Inventory (delivery), Accounting (invoice), Project/Subscriptions (services). Design the downstream result first, then configure the order.
- Configuration over customization. Exhaust settings, quotation templates, pricelists, activity types/plans and automated actions before writing code.
- Money paths are sacred: prices, taxes, discounts and invoicing policy must be proven on a test order end to end (quote -> confirm -> deliver -> invoice -> pay).
- Never assume a 17.0 detail from memory. Confirm in docs or the instance; mark unknowns "(verify in 17.0 docs: <url>)".

## Principles
1. Product type and invoicing policy drive the whole flow. Decide per product: storable vs consumable vs service, ordered vs delivered quantities, then check the resulting delivery/invoice/task behavior.
2. Pricing hierarchy: product list price -> pricelist rule -> manual discount. Keep rules few and explicit; use pricelists for customer/volume/currency logic, the discount field for one-off concessions.
3. Variants are real SKUs: only attributes that change stock, price or BoM should create variants; the rest are custom values or notes.
4. Taxes and fiscal positions come from Accounting; Sales only selects them. Fix tax mapping in Accounting, not on lines.
5. Quotation templates, optional products, validity dates and online signature/payment shorten the cycle; use them before building custom flows.
6. Down payments and pro-forma are invoicing tools, not order edits; always reconcile the final invoice against the deposit.
7. CRM: a lead is unqualified, an opportunity is a pursued deal. Keep stages few, defined by exit criteria, with probability and a mandatory lost reason.
8. Activities are the engine: every open opportunity has a next planned activity; chain activity types (suggest/trigger next activity) and use activity plans where your build supports them (verify in 17.0 docs) to standardize follow-up.
9. Multi-company and multi-team: set sales teams, assignment rules and record rules early; retrofitting ownership is painful.
10. Data hygiene: merge duplicates, enforce partner fields, archive instead of delete.

## Workflow for any request
1. Clarify the business case and the downstream effect (delivery? invoice? subscription? project?).
2. Check installed apps/settings and existing data (read-only inspection first).
3. Configure, then run a test order/opportunity end to end.
4. Document settings changed and residual manual steps.

## Pitfalls
- Changing invoicing policy or product type after orders exist: test on a copy; existing orders keep old behavior.
- Pricelist tax-included vs tax-excluded display: verify on quote, portal and invoice.
- Deleting stages that hold opportunities; move then archive.
- Lead mining and enrichment consume IAP credits; confirm before enabling.
- Custom fields on sale.order are not propagated to invoice/picking unless explicitly mapped.

## References
Load on demand:
- references/quotations-orders.md - quotation lifecycle, templates, optional products, signature/payment, addresses, PDF builder
- references/products-pricing.md - products, variants, pricelists, currencies, discounts, loyalty, taxes link
- references/invoicing-flow.md - invoicing policy, down payments, pro-forma, time and materials, milestones, delivery link, returns
- references/crm-pipeline.md - leads, opportunities, stages, activities, lost reasons, scoring, assignment
- references/analytics-forecast.md - pipeline analysis, expected revenue, forecast, lead quality/attribution analytics

Official docs (confirmed):
- https://www.odoo.com/documentation/17.0/applications/sales/sales.html
- https://www.odoo.com/documentation/17.0/applications/sales/crm.html
