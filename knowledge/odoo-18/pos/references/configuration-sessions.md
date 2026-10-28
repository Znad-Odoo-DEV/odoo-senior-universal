# Configuration and sessions

Sources (confirmed): https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale.html ; https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale.html

## Open
- Point of Sale > Dashboard > Open Register on the PoS card. Opening Control popover: check Opening cash amount, click Open Register. Button then reads Continue Selling.
- Session model pos.session states: opening_control > opened > closing_control > closed (verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale.html).
- One open session per pos.config; other users join the same session.

## Settings (Point of Sale > Configuration > Settings)
- Per-PoS: pick the PoS, then sections: Point of Sale (incl. Is a Bar/Restaurant), PoS Interface (Default Screen Tables/Register), Payment, Pricing, Product & PoS categories (Show margins & costs), connected devices.
- Payment section: payment methods of this PoS, one-click payment, Set Maximum Difference/Authorized Difference.
- Coins/Bills denominations: Point of Sale > Configuration > Coins/Bills (feeds the cash-count popover).
- Multi-employee login (cashier switch): https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale.html
- Page paths under extra/ follow the newer docs layout; some of the pages below (presets in particular) may not exist or may live elsewhere on 18 (verify).
- Presets (dine-in/takeaway/delivery): https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale.html ; Self-ordering: https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale.html ; Preparation display: https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale.html

## Cash control
- Give each PoS a dedicated cash payment method and cash journal.
- Cash in/out during the day via the register menu (verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale.html).
- Closing counts coins/bills; expected vs counted difference handled at close (see closing-accounting.md).

## Pitfalls
- Setting changes need a PoS UI reload; open sessions keep old data until then.
- Sessions left open across days accumulate orders and delay accounting.
- Restaurant PoS cannot close while unscheduled draft orders exist.
- Deactivating payment methods used by an open session causes closing errors; close first.
