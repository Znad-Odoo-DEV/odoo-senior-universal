# RFQ and PO flow (Odoo 17)
Docs (verify path in 17.0 docs): https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/purchase/manage_deals/rfq.html
Page tail (confirm, reminders, receipt date, vendor email) not read: verify there.

## Prerequisites on product
Purchase ticked; Buy route enabled (Inventory tab); vendor price + delivery lead time (Purchase tab) or via the Vendor Pricelists menu (location: verify in 17.0 docs: products/pricelist.html).

## Header fields
- Vendor (first), Vendor Reference (vendor's SO/delivery number, used to match receipts), Blanket Order (only if Purchase Agreements enabled).
- Order Deadline: vendor confirm-by date. Passing it marks the RFQ Late; ordering still possible.
- Expected Arrival (older builds label it Receipt Date; verify in 17.0 docs): computed from deadline + vendor lead time. "Ask confirmation" emails the vendor to confirm the shipping date.
- Deliver To: warehouse receipt type, or Dropship (adds Dropship Address from Contacts).

## Dashboard
To Send (unsent), Waiting (sent, no answer), Late (past deadline).

## Auto-generated RFQ grouping
- On Order (default): one draft RFQ per vendor and originating order.
- Vendor contact "Group RFQ" options (Daily: same expected arrival date; Weekly: same arrival week, set day; Always: one RFQ per vendor) are described in newer docs: (verify they exist in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/purchase/manage_deals/rfq.html).
- Manual RFQs are not grouped. Different warehouse, currency, or dropship forces separate RFQs.

## Senior notes
- Unexpected RFQ splits: check the conditions above (grouping, warehouse, currency, dropship).
- Purchase templates (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/purchase/manage_deals/purchase_templates.html)
- Vendor bill management (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/purchase/manage_deals/manage.html)
- EDI order import (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/purchase/advanced/edi.html)
- Alternatives/tenders: see agreements.md.
