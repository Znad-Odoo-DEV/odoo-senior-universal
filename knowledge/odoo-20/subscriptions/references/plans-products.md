# Recurring plans, subscription products, pricing

Source (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/sales/subscriptions.html

## Recurring Plan (Subscriptions > Configuration > Recurring Plans)
Formerly "recurrence periods".
- **Billing Period**: number + unit (Weeks, Months, Years). Days is not allowed for subscription products (reserved for rentals).
- **Automatic Closing**: days after which an unpaid subscription closes.
- **Align to Period Start**: new subscriptions bill on the first day of the next period, first invoice prorated. Arbitrary custom start dates need custom development.
- **Company** (multi-company), **Invoice Email Template** (default "Invoice: Sending").
- **Self-Service** toggles: Closable, Add Products (quantity change -> upsell quotation), Renew (renewal quotation), Optional Plans (customer may switch plan -> new quotation or renewal).
- **Pricing tab**: rules per product/variant/pricelist/recurring price; override product-form prices.
- Smart buttons: Subscriptions (active orders on this plan), Subscription Items (active recurring lines).

## Subscription product (Subscriptions > Products > Products)
- Keep the Subscriptions and Sales options enabled.
- General Information: Product Type (usually Service; goods allowed), Invoicing Policy, UoM, Sales Price.
- Goods require "Ordered quantities" invoicing policy, otherwise invoice creation errors.
- Attributes & Variants optional (e.g. tiers).
- **Recurring Prices tab**: one rule per plan; discount longer commitments.
- eCommerce: Go To Website, set Published. See https://www.odoo.com/documentation/20.0/applications/sales/subscriptions/ecommerce.html
- Field and tab names above are as documented for 19.0; re-check on the 20.0 instance (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/subscriptions.html).

## Design guidance
- One plan per commercial cadence (Monthly, Quarterly, Yearly); avoid plan sprawl, analytics group by Plan.
- Use pricelists for segment-specific recurring prices rather than duplicate products.
- Decide Align to Period Start deliberately: clean calendar billing, but a prorated first invoice customers may question.
- Set Automatic Closing longer than your payment-recovery window so a transient failure does not churn a good customer.
- Mixed recurring plus one-time lines on one order: one-time lines bill once, recurring lines repeat (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/subscriptions.html).
- Deliveries with subscriptions: https://www.odoo.com/documentation/20.0/applications/sales/subscriptions/subscriptions_deliveries.html (details not reviewed). Batch and wave picking are in core `stock` in 20 (`stock_picking_batch` merged), which helps grouping recurring physical shipments.
- Custom pricing or plan logic in modules: 20 security files use `ir.access.csv` (`id,name,model_id,group_id/id,operation,domain`) instead of `ir.model.access.csv` + `ir.rule`; manifests are versioned `20.0.x.y.z`.
