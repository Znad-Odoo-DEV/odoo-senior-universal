---
name: purchase
description: Senior Odoo 18 Purchase expertise. Use for Odoo 18 Purchase/procurement — RFQ and purchase order flow, vendor pricelists, reordering and procurement, receipts and 3-way matching with vendor bills, blanket orders, and purchase agreements.
---

# Odoo 18 Purchase (senior)

## Mindset
- Purchase is the demand-to-cash chain: need (reordering/MTO/manual) -> RFQ -> PO -> receipt -> vendor bill -> payment. Diagnose by locating which link broke, not by editing the symptom.
- Product master data drives everything: Purchase flag, Buy route, vendor lines (price, min qty, lead time), control policy, UoM. Fix the master before blaming the flow.
- Prefer configuration (settings, routes, pricelists, policies) over customization. Custom code only for gaps the docs do not cover.
- Verify claims against the 18.0 docs; mark what cannot be confirmed "(verify in 18.0 docs: <url>)".

## Principles
1. RFQ becomes PO on Confirm. Order Deadline only flags the RFQ as Late; it does not block ordering. Expected Arrival = deadline + vendor lead time.
2. Auto-RFQ grouping defaults to On Order (one draft RFQ per vendor and originating order). The per-vendor Group RFQ option (Daily / Weekly / Always) is documented for 19: (verify it exists in 18.0 docs: rfq.html). Manual RFQs are never grouped; different warehouses, currencies, and dropship always split.
3. Vendor pricelist lines (product Purchase tab or the Vendor Pricelists menu; verify its location in 18.0 docs) price RFQ lines: sequence orders vendors, min qty selects the tier, delay is the lead time. Import with External ID to update rather than duplicate.
4. Reordering needs: Purchase ticked, Goods, Track Inventory, Buy route, a vendor line. Min triggers, Max is the target, Multiple rounds up (can exceed Max). Scheduler runs daily by default.
5. Control policy (per product): ordered qty -> bill from confirmation; received qty -> bill after receipt. Services default to ordered, goods to received.
6. 3-way matching (Settings > Invoicing) adds "Should Be Paid" (Yes/No/Exception) on bills: editing a draft bill flips it to Exception; paying sets No. Treat Exception as a review queue.
7. The Purchase Agreements setting enables blanket orders AND alternative RFQs (calls for tenders). Agreement prices are NOT auto-filled; enter them or lines stay 0.
8. A confirmed blanket order injects a vendor line (vendor, price, agreement) on each product, so reordering rules pick vendor/price from it.
9. Multi-company/multi-currency: check company on vendor lines, agreements, and warehouse before debugging "wrong price" or "no RFQ".

## Diagnostic checklist
- No RFQ from reordering: product Goods + Track Inventory? Buy route active? vendor line exists? scheduler ran (dev mode: Inventory > Operations > Run Scheduler; label per 18.0 docs)?
- Wrong price: vendor line sequence, min qty tier, currency, agreement-injected line.
- Bill empty or not creatable: control policy vs receipts (received policy bills only received qty).
- Two RFQs where one expected: vendor grouping option, warehouse, currency, dropship.

## References
- references/rfq-po-flow.md — RFQ/PO lifecycle, grouping, deadlines, dropship.
- references/vendors-pricelists.md — vendor pricelist fields, import/export, selection.
- references/procurement-reordering.md — reordering rules, Buy route, MTO link, scheduler.
- references/receipts-billing.md — control policy, 3-way matching, billing status, landed costs link.
- references/agreements.md — blanket orders, calls for tenders / alternatives.
- Docs index: https://www.odoo.com/documentation/18.0/applications/inventory_and_mrp/purchase.html
