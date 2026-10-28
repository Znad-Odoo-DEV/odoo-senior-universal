# Subscription lifecycle

Base (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/sales/subscriptions (pages: .html, /renewals.html, /upselling.html, /closing.html)

## Quotation to running
- Create from Sales or Subscriptions dashboard (New), or via eCommerce checkout. Add subscription products and select the Recurring Plan (quotation step details: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/subscriptions.html).
- Confirm -> sales order; subscription shows **In Progress**. Invoice per plan schedule; the first invoice must be registered before renew/upsell/close are possible.
- Subscriptions > Subscriptions > Quotations lists them. Dashboard shows In Progress and Paused by default.

## Renewal (manual)
Prereqs: confirmed order with subscription product, plan selected, initial payment invoiced and registered.
1. Open order: stage Sales Order, tag In Progress, **Renew** button.
2. Renew creates a "Renewal Quotation"; start date and next invoice date are copied into its chatter.
3. Confirm, invoice, register payment (standard flow).
4. **Sales History** smart button lists all linked orders, each with its Subscription Status.
Not documented on the page: proration and automatic renewal mechanics (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/subscriptions/renewals.html). Customers can self-renew if the plan has Renew on.

## Upsell
- Order must be invoiced first. Click **Upsell** -> new quotation (chatter links original; lines show recurring products prorated from original start date).
- Add products, adjust price/tax/discount (Discounts requires the Sales setting in Pricing), **Send**, then **Confirm**. Confirmed upsold products merge into the subscription.
- Proration: Service products only; based on time left in the current invoicing period.
- **Create Alternative** makes another upsell linked to prior ones, even after sending.
- Customers can trigger upsell via plan option Add Products.
- How upsell amounts are invoiced: not stated (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/subscriptions/upselling.html).

## Close and churn
- Only invoiced subscriptions can be closed (else cancel).
- Admin: **Close** on an In Progress order -> set **When** date and **Reason** -> Submit; reason logged in chatter. Reasons: Subscriptions > Configuration > Close Reasons (create via Search more...).
- Customer (plan Closable on): portal **Close Subscription**, preconfigured reason only; timing = chosen date or end of current renewal period.
- Result: order flagged **Churned** (banner, end date, reason); portal wording is "Closed".
- Statuses mentioned: In Progress, Paused, Churned, Closed. Pausing mechanics, reopening, automatic-close behavior are not in the closing article (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/subscriptions/closing.html). Plan field Automatic Closing governs unpaid days.
- Chatter on the order: in 20 tracking values are removed and tracking messages are built on the fly. Audit of who changed what still lives in the chatter, but code or reports that read tracking value records must be rewritten.

## Senior tips
- Never edit running lines to change scope; use Upsell (prorated, auditable) or Renew with a new plan.
- Keep Close Reasons short and mutually exclusive so Retention Analysis stays interpretable.
- Use Sales History to audit the chain renewal -> upsell -> close.
- Before upgrading from 19 to 20, resolve open renewal/upsell quotations and orders in "Contract in exception"; test the lifecycle (renew, upsell, close) on an upgraded copy, since lifecycle behavior here is carried over from 19 and not re-confirmed for 20.
