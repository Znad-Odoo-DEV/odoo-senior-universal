# Cart, checkout, payment providers

Doc URLs (ported from the 19.0 layout; verify in 20.0 docs):
- Checkout: https://www.odoo.com/documentation/20.0/applications/websites/ecommerce/checkout.html
- Order handling: https://www.odoo.com/documentation/20.0/applications/websites/ecommerce/order_handling.html
- Performance management: https://www.odoo.com/documentation/20.0/applications/websites/ecommerce/performance.html
- Payment providers (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/payment_providers.html)

## Add to cart behavior
- Website > Configuration > Settings, eCommerce section: after Add to Cart either "Stay on Product Page" or "Go to cart".
- Contact Us button replaces Add to Cart (prices hidden first). Extra Add to Cart / Buy Now buttons via the "Add to Cart Button" block (Product + Action). Reorder via "Order Again" in portal or "Quick reorder" on Order summary.

## Checkout steps (as documented for 19.0; verify in 20.0 docs: checkout.html)
1. Order summary: optional Suggested Accessories, Promo Code, Add to Wishlist. (Wishlist is a core `website_sale` feature in 20; the standalone `website_sale_wishlist` module no longer exists.)
2. Address: delivery/billing, automatic address validation.
3. Extra Info: optional, only if enabled (custom questions).
4. Payment: delivery method choice, terms and conditions, eWallets and gift cards, provider selection.
5. Order confirmation: final page; sale order is confirmed or stays quotation depending on payment flow.
- Express checkout: button from cart straight to confirmation, skipping contact form; only when the installed provider supports it (verify provider list in payment docs).
- Guest checkout vs mandatory sign-in: Settings > Customer Account (verify in 20.0 docs: configuration/customer_accounts.html).
- Terms & conditions checkbox: enable in settings; link the legal page and set it in company/website (verify in 20.0 docs: checkout.html).
- Abandoned carts: automated recovery email in settings (verify in 20.0 docs: order_handling.html).

## Order lifecycle
- Cart = draft `sale.order` bound to website and visitor. Payment creates `payment.transaction`; on success the order is confirmed (auto-confirm depends on settings: online payment confirmation, "Automatic Invoice" option).
- Automatic invoice and its payment registration need a correct journal on the provider. Without it, reconciliation is manual.
- Pending (wire transfer) transactions confirm the order only after manual validation, unless configured otherwise.
- Check order handling and reporting: Website > Orders; Performance: eCommerce dashboard.
- Odoo 20 accounting: invoice payment statuses are renamed and bank-impacting journal entries must originate from bank transactions. Re-check any shop report, automation or domain that filters on the old payment status labels, and reconcile online payments through bank transactions rather than manual bank-journal entries (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting.html).

## Payment providers
- Enable via Accounting/Website > Configuration > Payment Providers: pick provider, click Install, set credentials, state (Disabled, Enabled, Test Mode), and published flag.
- Per provider config: Payment Journal (with the matching payment method line), currencies, countries, minimum/maximum amount, capture mode (automatic or manual authorize), payment form display, Express checkout flag, tokenization (saved cards).
- Webhooks: provider calls Odoo at `/payment/<provider>/webhook`; Odoo must be publicly reachable over HTTPS; `web.base.url` must be the public domain. Behind a proxy set `proxy_mode = True`.
- Common built-in providers: Stripe, PayPal, Adyen, Authorize.Net, Mollie, Razorpay, Wire Transfer, Pay on Site/Cash on Delivery (list varies; verify in 20.0 docs).
- Wire transfer: pending message and bank details; requires manual confirmation of payment.
- Always test in Test Mode end to end (success, failure, cancel, refund), then switch to Enabled with live keys; keep test and live credentials separated.

## Pitfalls
- Provider state Test Mode in production shows a red banner and takes no real money.
- Currency mismatch: website pricelist currency must be supported by the provider.
- Missing journal on provider: payment succeeds but no accounting entry.
- Reverse proxy blocking webhook (auth, IP allowlist, wrong Host header) leaves orders stuck in "Pending".
- Guest checkout plus automatic invoicing creates partner records: set deduplication/VAT policy deliberately.
- Fiscal position changes after address entry; re-check totals at the Payment step.
- VAT-number validation on checkout addresses: the `base_vat` module is removed in 20, so where VAT checks now live is (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting.html).
