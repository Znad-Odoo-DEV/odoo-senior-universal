# Recurring plans, subscription products, pricing

Source: https://www.odoo.com/documentation/17.0/applications/sales/subscriptions.html

## Recurring Plan (Subscriptions > Configuration > Recurring Plans)
Formerly "recurrence periods" (16 and earlier). If the menu is still called Recurrences/Subscription Templates on the instance, it is an older build (verify in 17.0 docs).
- **Billing Period**: number + unit (Weeks, Months, Years). Days is not allowed for subscription products (reserved for rentals).
- **Automatic Closing**: days after which an unpaid subscription closes.
- **Align to Period Start**: new subscriptions bill on the first day of the next period, first invoice prorated. Arbitrary custom start dates need custom development. Confirm this option exists in 17.0 (verify in 17.0 docs).
- **Company** (multi-company), **Invoice Email Template** (default "Invoice: Sending").
- **Self-Service** toggles: Closable, Add Products (quantity change -> upsell quotation), Renew (renewal quotation), Optional Plans (customer may switch plan -> new quotation or renewal).
- **Pricing tab**: rules per product/variant/pricelist/recurring price; override product-form prices.
- Smart buttons: Subscriptions (active orders on this plan), Subscription Items (active recurring lines).

## Subscription product (Subscriptions > Products > Products)
- Keep the Subscriptions and Sales options enabled (checkbox labels: verify in 17.0 docs).
- General Information: Product Type (usually Service; goods allowed), Invoicing Policy, UoM, Sales Price. In 17 the type is `detailed_type` (service/consu/product).
- Goods require "Ordered quantities" invoicing policy, otherwise invoice creation errors.
- Attributes & Variants optional (e.g. tiers).
- **Recurring Prices tab**: one rule per plan; discount longer commitments.
- eCommerce: Go To Website, set Published. See https://www.odoo.com/documentation/17.0/applications/sales/subscriptions/ecommerce.html

## Design guidance
- One plan per commercial cadence (Monthly, Quarterly, Yearly); avoid plan sprawl, analytics group by Plan.
- Use pricelists for segment-specific recurring prices rather than duplicate products.
- Decide Align to Period Start deliberately: clean calendar billing, but a prorated first invoice customers may question.
- Set Automatic Closing longer than your payment-recovery window so a transient failure does not churn a good customer.
- Mixed recurring plus one-time lines on one order: one-time lines bill once, recurring lines repeat (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/sales/subscriptions.html).
- Deliveries with subscriptions: https://www.odoo.com/documentation/17.0/applications/sales/subscriptions.html (details not reviewed).
