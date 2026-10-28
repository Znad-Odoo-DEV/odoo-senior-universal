# Invoicing Flow and Delivery (Odoo 20)

Base: https://www.odoo.com/documentation/20.0/applications/sales/
Pages (ported from the 19.0 layout, verify in 20.0 docs): sales/invoicing/invoicing_policy.html, down_payment.html, proforma.html, time_materials.html, milestone.html; sales/products_prices/returns.html

## Invoicing policy
- Per product: invoice on ordered quantities (before delivery, prepay-friendly) or on delivered quantities (after delivery, service-friendly). Default policy source and 20.0 naming: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/sales/invoicing/invoicing_policy.html).
- Services can bill via timesheets (time_materials.html) or project milestones (milestone.html); these tie to Project/Timesheets.
- Order invoice status (to invoice / fully invoiced / nothing to invoice) is a ready-made billing worklist filter.

## Down payments
- Created via Create Invoice on the order: percentage or fixed amount (down_payment.html). Appears as a deduction on the final invoice; settle every deposit there and check the deposit account in Accounting.
- Multi-tax orders: deposit splits per tax; verify rounding.

## Pro-forma
- Preliminary document without accounting entries (proforma.html); enable in settings.

## Delivery link
- With Inventory, goods lines create a delivery on confirmation; delivered quantity updates the line and drives "invoice on delivered". Routes (MTO, dropship, reordering) belong to Inventory; see the inventory skill.
- Partial deliveries give partial invoices; backorders keep the remainder to invoice.
- Returns reduce delivered quantity; credit note via invoice reversal (returns.html).
- Carriers: the Mondial Relay connector (`delivery_mondialrelay`) is removed in 20, so orders cannot rely on it as a shipping method (see the inventory skill; verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory.html).

## Subscription and Project links
- Recurring products create subscriptions with their own invoicing cadence: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/subscriptions.html).
- Service products can auto-create tasks/projects; billing follows the chosen policy.
- Field Service is discontinued in 20 (features moved into Planning): service products that created field-service tasks need review and re-pointing to Planning/Project; time and material billing then follows the project/sales mechanics above. (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/services/planning.html)

## Checklist
1. Per product: type + policy + delivery behavior documented.
2. Test: confirm -> partial delivery -> invoice -> credit note -> payment.
3. Down payment scenario with two taxes.
4. Verify posting date, journal, currency and payment terms on the generated invoice.
5. After upgrading from 19: check reports, automations and filters that depend on invoice payment status, since payment statuses are renamed in 20 (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/payments.html).
