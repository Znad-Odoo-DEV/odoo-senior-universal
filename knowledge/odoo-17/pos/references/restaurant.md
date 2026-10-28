# Restaurant features

Sources (19.0 layout, version swapped; verify paths in 17.0): https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/restaurant.html ; https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/extra/preparation.html

## Setup
- Enable Is a Bar/Restaurant (Point of Sale section of settings); restaurant settings depend on it.
- PoS Interface > Default Screen: Tables or Register (verify the setting in 17.0).

## Floors and tables
- Point of Sale > Configuration > Floor Plans: floor name, linked PoS, optional background image. Tables: number, seats, shape; optional height, width, color, Active.
- Or edit in register Floor plan view > Edit Plan; quick-create floors via Floors & Tables Map in settings.
- Deleting a table or floor is permanent: archive (Active) instead.

## Booking
- Table booking through the Appointments app (Booking setting, Book to Resources, Manage Capacities) is a later-version feature: not part of 17 (verify). In 17 handle reservations outside PoS or via a custom module.

## Order flow (page sections)
- Order management: order process, order transfer (move or merge between tables). Courses are a later-version feature (verify).
- Order printing: kitchen/bar tickets via Order Printers (Point of Sale > Configuration > Order Printers; assign product categories), or Preparation display (https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/extra/preparation.html; verify availability in 17.0). Per-category printer setup: (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/restaurant.html).
- Bills and payment: bill splitting, order payment, receipt printing.
- Tips: tip with payment through the Tips setting and tip product; adding a tip after payment depends on the terminal provider and region (the 19.0 docs say US only; verify in 17.0).

## Ordering and delivery
- Self-ordering (mobile and kiosk): https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/extra/self_order.html (verify in 17.0). Dine-in vs takeaway comes from the self-order settings; the Presets feature (dine-in/takeaway/delivery) is later-version.
- Third-party delivery connectors (UrbanPiper, APAC food delivery in the 19.0 docs) are not native in 17: verify in Apps before promising them, or plan a custom integration.

## Pitfalls
- Restaurant PoS cannot close with open unscheduled draft orders (Review Orders / Cancel Orders popover; verify wording in 17.0).
- Tip product needs the right income account and tax before go-live.
- Kitchen printers per product category: unassigned categories print nowhere.
