---
name: subscriptions
description: Senior Odoo 18 Subscriptions expertise. Use for Odoo 18 Subscriptions — recurring plans and products, subscription order lifecycle, automatic billing and payment tokens, renewals/upsells/closing, and recurring-revenue analytics (MRR, churn).
---

# Odoo 18 Subscriptions (senior)

## Mindset
- Subscriptions in 18 is a layer on Sales: a subscription is a confirmed sales order whose lines are recurring products tied to a **Recurring Plan**. Think "sale order + plan + schedule", not a separate contract object.
- Recurring revenue is the product. Every decision (plan period, proration, billing alignment, payment method, close reason) must keep MRR/ARR data trustworthy.
- Automation is the default; exceptions (failed payment, manual invoice) must be handled deliberately, never by blindly clearing flags.
- Verify behavior on a test database before telling a client how it behaves; this skill marks gaps rather than guessing.

## Principles
1. **Plan first, product second.** Create Recurring Plans (Subscriptions > Configuration > Recurring Plans) before pricing. Billing Period = number + unit (Weeks/Months/Years; Days is not usable, it is for rentals).
2. **Price per plan.** Recurring price rules live on the product (Recurring Prices tab) or on the plan (Pricing tab, overrides the product form). Longer plans usually get a discount.
3. **Physical goods in a subscription** must use the "Ordered quantities" invoicing policy or invoice creation fails.
4. **Invoice before you change.** A subscription must be invoiced before it can be upsold or closed; an uninvoiced one is cancelled instead.
5. **Upsell and renew via the buttons**, never by editing a running order's lines. Upsell proration applies to Service products only.
6. **Self-service is a plan setting** (Closable, Add Products, Renew, Optional Plans); decide what customers may do per plan.
7. **Automatic payment requires a tokenizing provider** plus customer portal or eCommerce. No saved token means no automatic charge.
8. **Treat "Contract in exception" as a stop-the-line flag.** It halts scheduled actions on that order to prevent double charges; resolve by checking the chatter, then manual invoice or untick (developer mode).
9. **Churn is data.** Closing sets Churned with an end date and a Close Reason (Configuration > Close Reasons); keep the reason list clean for retention analysis.
10. **Analyze with the built-in views** (Subscriptions Analysis, Retention Analysis, MRR Breakdown, MRR Analysis) before building custom ones; know the exact measure names.

## Workflow cheat sheet
- Setup: plan -> subscription product (Subscriptions + Sales options on) -> pricing -> (optional) publish on eCommerce.
- Sell: quotation (manual or eCommerce) with a plan -> confirm -> invoice -> In Progress.
- Run: scheduled invoicing; with token, automatic payment.
- Change: Renew / Upsell buttons -> confirm; Sales History smart button lists linked orders.
- End: Close (When + Reason) -> Churned.

## Out of scope / verify
- Sub-statuses beyond In Progress, Paused, Churned, Closed; automatic dunning/retry schedule; reopening a closed order; automatic-close timing. The fetched docs do not specify these (verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/sales/subscriptions.html).
- Deliveries with subscriptions and eCommerce flows: see the confirmed pages below; not detailed here.

## References
- references/plans-products.md: recurring plans, subscription products, pricing rules
- references/subscription-lifecycle.md: quotation to running, renew, upsell, close/churn
- references/billing-payments.md: automatic invoicing, tokens, failed payments
- references/analytics-mrr.md: analysis views, filters, measures, MRR/churn reasoning

Confirmed Odoo 18.0 docs:
- https://www.odoo.com/documentation/18.0/applications/sales/subscriptions.html
- https://www.odoo.com/documentation/18.0/applications/sales/subscriptions/renewals.html
- https://www.odoo.com/documentation/18.0/applications/sales/subscriptions/upselling.html
- https://www.odoo.com/documentation/18.0/applications/sales/subscriptions/closing.html
- https://www.odoo.com/documentation/18.0/applications/sales/subscriptions/reports.html
- https://www.odoo.com/documentation/18.0/applications/sales/subscriptions/automatic_payments.html
- https://www.odoo.com/documentation/18.0/applications/sales/subscriptions/ecommerce.html
- https://www.odoo.com/documentation/18.0/applications/sales/subscriptions/subscriptions_deliveries.html
