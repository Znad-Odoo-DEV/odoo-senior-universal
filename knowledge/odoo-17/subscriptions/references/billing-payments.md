# Billing, payments, failures

Source: https://www.odoo.com/documentation/17.0/applications/sales/subscriptions/automatic_payments.html (verify the path resolves in 17.0)

## Automatic invoicing
Subscriptions generates quotations/invoices automatically by default on the plan schedule. The invoice email uses the plan's Invoice Email Template. A manually posted invoice updates the subscription's next invoice date.

## Automatic payment (tokens)
Needs: a provider supporting tokenization (documented in newer docs: Adyen, Authorize.net, Flutterwave, Razorpay, Stripe, Xendit; the 17 list may be shorter, verify in 17.0 docs) and either the customer portal or an eCommerce website (Website app). In 17 the model is `payment.provider` (formerly acquirer) and saved cards are `payment.token`.
Setup:
1. Pick a tokenizing provider.
2. Follow its guide, enter API credentials in Odoo.
3. Enable the provider.
4. Configure payment methods (per-provider payment method selection is richer in newer versions; verify in 17.0 docs).
5. Configure tokenization.
Customer side: token created from saved details at checkout, or added in the portal. Some providers save automatically, others ask opt-in. No saved details = no automatic charge.

## Failed automatic payment
- Order gets tag **Payment Failure** and **Contract in exception** ticked (Other Info tab, Subscription section).
- While in exception, scheduled actions skip the order (prevents double charge if the payment actually succeeded). Renewals resume when the box is unticked. If left in Payment Failure, Odoo ignores it until the order is closed.
- Resolve:
  1. Subscriptions > Subscriptions > Quotations, open order, read chatter: was payment made?
  2. Not paid: developer mode, Other Info, untick Contract in exception, reload, confirm tag gone.
  3. Paid: create and post the invoice manually (updates next invoice date), then untick the flag on the new sales order (developer mode).
- Retry schedule / dunning cadence: not documented on the page; do not promise one (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/sales/subscriptions/automatic_payments.html). Use the plan's Automatic Closing days as the outer limit and handle dunning through customer outreach or follow-up tooling.

## Senior tips
- Test the full cycle in the provider's test mode: first charge, token reuse, forced failure.
- Never untick Contract in exception before checking whether the charge went through.
- Work orders with the Payment Failure tag as a daily queue (filter in the list view).
- Customer Closable plus a failed payment can both end a subscription; keep the reasons distinguishable.
