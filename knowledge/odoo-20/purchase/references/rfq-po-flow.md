# RFQ and PO flow (Odoo 20)
Docs (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/purchase/manage_deals/rfq.html
Page tail (confirm, reminders, receipt date, vendor email) not read: verify there.

## Prerequisites on product
Purchase ticked; Buy route enabled (Inventory tab); vendor price + delivery lead time (Purchase tab) or via Purchase > Configuration > Vendor Pricelists.

## Header fields
- Vendor (first), Vendor Reference (vendor's SO/delivery number, used to match receipts), Blanket Order (only if Purchase Agreements enabled).
- Order Deadline: vendor confirm-by date. Passing it marks the RFQ Late; ordering still possible.
- Expected Arrival: computed from deadline + vendor lead time. "Ask confirmation" emails the vendor to confirm the shipping date.
- Deliver To: warehouse receipt type, or Dropship (adds Dropship Address from Contacts).

## Dashboard
To Send (unsent), Waiting (sent, no answer), Late (past deadline).

## Auto-generated RFQ grouping (vendor contact "Group RFQ")
- On Order (default): per originating order.
- Daily: same expected arrival date. Weekly: same arrival week, set day. Always: one RFQ per vendor.
- Manual RFQs are not grouped. Different warehouse, currency, or dropship forces separate RFQs.

## Senior notes
- Unexpected RFQ splits: check the four conditions above (grouping option, warehouse, currency, dropship).
- Purchase templates (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/purchase/manage_deals/purchase_templates.html)
- Vendor bill management (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/purchase/manage_deals/manage.html)
- EDI order import (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/purchase/advanced/edi.html)
- Alternatives/tenders: see agreements.md.
