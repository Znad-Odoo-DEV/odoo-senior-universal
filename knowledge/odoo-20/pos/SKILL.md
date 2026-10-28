---
name: pos
description: Senior Odoo 20 Point of Sale expertise. Use for Odoo 20 PoS — configuration and sessions, payment methods and hardware, product and pricing setup, restaurant features, loyalty and promotions, and receipts, closing, and accounting link.
---
# Odoo 20 Point of Sale (senior)

## Mindset
- PoS is an offline-capable OWL/JS client over backend models (pos.config, pos.session, pos.order, pos.payment, pos.payment.method). Orders are created in the browser, synced to the server, and reach accounting and stock mainly when the session is closed (invoiced orders post at once).
- Treat each register as an accounting unit: own cash payment method + own cash journal, so every closing entry is traceable.
- Decide the business model first (shop, restaurant, self-order), then settings; most settings are per pos.config, a few are company/Inventory/Accounting-wide.
- Prove changes on a test config with a real open-sell-refund-close cycle before touching production; closing is the point of no return.

## Principles
1. Configure in Point of Sale > Configuration > Settings (PoS selector at top); payment methods, floor plans, Coins/Bills have their own menus.
2. One session per register at a time. Close daily; never leave sessions open for days (stale cache, huge closing entries, locked periods).
3. Cash: counted vs expected at closing. Differences go to the cash difference journal; enable Set Maximum Difference + Authorized Difference to force manager approval.
4. Payment terminals: Bank-type journal, Integration = Terminal, provider account in test mode first.
5. Hardware: prefer Local Network Access for ePOS printers; use IoT Box or Windows virtual IoT gateway for scales, scanners, Ingenico, legacy printers. Ethernet beats Wi-Fi; physical beats virtual.
6. Products need Available in PoS ticked; with POS categories in use, an uncategorised product is invisible in the register.
7. Pricing layers: pricelists (structured, persistent) vs discount/loyalty programs (promotional, time-bound). Do not duplicate one rule in both.
8. Taxes and fiscal positions come from Accounting; verify tax-included vs excluded and rounding on a printed receipt, not only on screen.
9. Offline: orders live in the browser until sync. Never clear cache or close the browser while offline orders are pending.
10. Restaurant features require Is a Bar/Restaurant; floors/tables, courses, preparation printing/display, tips, bill splitting build on it.
11. Refunds create a return order and credit note linked to the original; never edit posted entries to "fix" sessions.
12. Multi-company/branch: check journal, warehouse (operation type) and fiscal country per PoS before go-live.

## Odoo 20 notes
- PoS behavior in these references was confirmed on the 19.0 docs and carried to 20.0; no Point of Sale-specific change is asserted here. Re-check settings labels, hardware/terminal lists and restaurant features against the 20.0 docs (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale.html).
- PoS is an OWL client: Odoo 20 moves the frontend to OWL 3 (the OWL 2 to 3 guide lists 22 breaking changes; the compatibility layer is only a temporary bridge). Custom PoS JS/patches written for 19 should be reviewed against that migration guide and re-run under Hoot tests (Hoot remains the test framework).
- Runtime: Python >= 3.12, PostgreSQL >= 16. Custom PoS modules ship security as `ir.access.csv` (`id,name,model_id,group_id/id,operation,domain`); 20 merges `ir.model.access` and `ir.rule` into `ir.access`.
- Odoo 20 requires bank-impacting journal entries to originate from bank transactions (no manual bank-journal entries). Whether and how this changes PoS closing entries for card/bank payment methods is not confirmed here: test a close with a terminal payment and reconciliation (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/use.html).

## Workflow for a task
1. Identify model (shop/restaurant/self-order) and country (fiscal rules, certified hardware, local payment providers).
2. Read the matching reference file; confirm exact setting labels in the live database (they shift between minor versions).
3. Configure on a test PoS, run open > sell > refund > close, inspect the journal entries and stock pickings.
4. Roll out per register; train staff on closing and cash counting.

## References
- references/configuration-sessions.md: PoS config, opening/closing, cash control.
- references/payments-hardware.md: payment methods, terminals, cash machines, QR, IoT, printers.
- references/products-pricing.md: products, categories, variants/combos, pricelists, discounts, loyalty, taxes.
- references/restaurant.md: floors/tables, courses, preparation, bill splitting, tips, delivery.
- references/closing-accounting.md: closing, journal entries, invoices, refunds, inventory link.

Odoo 20 docs (URLs ported from the 19.0 layout, confirmed on 19.0; verify in 20.0 docs). Release notes: https://www.odoo.com/odoo-20-release-notes
- https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale.html (landing)
- https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/use.html, https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/use/receipts.html, https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/use/pos_invoices.html
- https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/products.html, https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/shop.html, https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/reporting.html
- https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/payment_methods.html, https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/hardware_network.html, https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/restaurant.html
- https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/extra.html, https://www.odoo.com/documentation/20.0/applications/sales/point_of_sale/extra/pricing.html
