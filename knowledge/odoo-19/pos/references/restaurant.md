# Restaurant features

Sources (confirmed): https://www.odoo.com/documentation/19.0/applications/sales/point_of_sale/restaurant.html ; https://www.odoo.com/documentation/19.0/applications/sales/point_of_sale/restaurant/urban_piper.html ; https://www.odoo.com/documentation/19.0/applications/sales/point_of_sale/restaurant/APAC_food_delivery.html ; https://www.odoo.com/documentation/19.0/applications/sales/point_of_sale/extra/preparation.html

## Setup
- Enable Is a Bar/Restaurant (Point of Sale section of settings); restaurant settings depend on it.
- PoS Interface > Default Screen: Tables or Register.

## Floors and tables
- Point of Sale > Configuration > Floor Plans: floor name, linked PoS, optional background image. Tables: number, seats, shape; optional height, width, color, Active.
- Or edit in register Floor plan view > Edit Plan; quick-create floors via Floors & Tables Map in settings.
- Deleting a table or floor is permanent: archive (Active) instead.

## Booking
- Enabling Booking installs Appointments; appointment type with Book to Resources, select tables, enable Manage Capacities; stages Booked, Checked-In, No Show; tables can be linked for large parties.

## Order flow (page sections)
- Order management: order process, order transfer (move between tables), courses.
- Order printing: kitchen/bar tickets, or Preparation display (https://www.odoo.com/documentation/19.0/applications/sales/point_of_sale/extra/preparation.html). Per-category printer setup: (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/sales/point_of_sale/restaurant.html).
- Bills and payment: bill splitting, order payment, receipt printing.
- Tips: tip with payment; Tip after payment is US only.

## Delivery and ordering
- UrbanPiper: https://www.odoo.com/documentation/19.0/applications/sales/point_of_sale/restaurant/urban_piper.html ; APAC delivery: https://www.odoo.com/documentation/19.0/applications/sales/point_of_sale/restaurant/APAC_food_delivery.html ; needs Delivery Payment methods.
- Self-ordering and presets (dine-in/takeaway): https://www.odoo.com/documentation/19.0/applications/sales/point_of_sale/extra/self_order.html, https://www.odoo.com/documentation/19.0/applications/sales/point_of_sale/extra/presets.html

## Pitfalls
- Restaurant PoS cannot close with open unscheduled draft orders (Review Orders / Cancel Orders popover).
- Tip product needs the right income account and tax before go-live.
- Kitchen printers per product category: unassigned categories print nowhere.
