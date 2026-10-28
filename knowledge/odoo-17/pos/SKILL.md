---
name: pos
description: Senior Odoo 17 Point of Sale expertise. Use for Odoo 17 PoS — configuration and sessions, payment methods and hardware, product and pricing setup, restaurant features, loyalty and promotions, and receipts, closing, and accounting link.
---
# Odoo 17 Point of Sale (senior)

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
5. Hardware: prefer direct Epson ePOS (IP address, self-signed certificate over HTTPS) for receipt printers; use an IoT Box (or the Windows virtual IoT gateway, verify availability) for scales, scanners, Ingenico, legacy printers. Ethernet beats Wi-Fi; physical beats virtual.
6. Products need Available in PoS ticked; with POS categories in use, an uncategorised product is invisible in the register.
7. Pricing layers: pricelists (structured, persistent) vs discount/loyalty programs (promotional, time-bound). Do not duplicate one rule in both.
8. Taxes and fiscal positions come from Accounting; verify tax-included vs excluded and rounding on a printed receipt, not only on screen.
9. Offline: orders live in the browser until sync. Never clear cache or close the browser while offline orders are pending.
10. Restaurant features require Is a Bar/Restaurant; floors/tables, order printing/preparation display, tips, bill splitting and table transfer build on it. Courses, presets and online-delivery connectors are newer than 17 (verify).
11. Refunds create a return order and credit note linked to the original; never edit posted entries to "fix" sessions.
12. Multi-company/branch: check journal, warehouse (operation type) and fiscal country per PoS before go-live.

## Workflow for a task
1. Identify model (shop/restaurant/self-order) and country (fiscal rules, certified hardware, local payment providers).
2. Read the matching reference file; confirm exact setting labels in the live database (they shift between minor versions, and 17.0 differs from 18/19 in the register UI, payment providers and restaurant features).
3. Configure on a test PoS, run open > sell > refund > close, inspect the journal entries and stock pickings.
4. Roll out per register; train staff on closing and cash counting.

## References
- references/configuration-sessions.md: PoS config, opening/closing, cash control.
- references/payments-hardware.md: payment methods, terminals, cash machines, QR, IoT, printers.
- references/products-pricing.md: products, categories, variants/combos, pricelists, discounts, loyalty, taxes.
- references/restaurant.md: floors/tables, order printing, preparation display, bill splitting, tips, self-ordering.
- references/closing-accounting.md: closing, journal entries, invoices, refunds, inventory link.

Odoo 17 docs (landing and sections; deep-page paths below follow the 19.0 layout with the version swapped, and the 17.0 docs may organise Point of Sale pages under different sections, so verify each resolves):
- https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale.html (landing)
- https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/use.html, https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/use/receipts.html, https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/use/pos_invoices.html
- https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/products.html, https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/shop.html, https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/reporting.html
- https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/payment_methods.html, https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/hardware_network.html, https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/restaurant.html
- https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/extra.html, https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/extra/pricing.html
