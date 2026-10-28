# Delivery methods and carriers

Doc URLs (ported from the 19.0 layout; verify in 20.0 docs):
- eCommerce delivery: https://www.odoo.com/documentation/20.0/applications/websites/ecommerce/shipping.html
- Configuring delivery methods: https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/shipping_receiving/setup_configuration.html
- Third-party carriers: https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/shipping_receiving/setup_configuration/third_party_shipper.html
- FedEx: .../setup_configuration/fedex.html ; UPS: .../setup_configuration/ups_credentials.html ; DHL: .../setup_configuration/dhl_credentials.html
- Sendcloud: .../setup_configuration/sendcloud_shipping.html ; Envia.com: .../setup_configuration/envia_shipping.html ; Gelato: https://www.odoo.com/documentation/20.0/applications/sales/sales/gelato.html
- New delivery method: .../setup_configuration/new_delivery_method.html
(`...` = https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/inventory/shipping_receiving)

## Carrier integrations
- Website > Configuration > Settings, eCommerce section, Configure Delivery Methods > "Find a Delivery Provider". Supported: FedEx, UPS, DHL (labels and tracking), aggregators Sendcloud and Envia.com, fulfillment platform Gelato. Carrier list to confirm on the 20.0 instance (verify in 20.0 docs: third_party_shipper.html).
- **Mondial Relay is gone in 20.** The `delivery_mondialrelay` module is removed, so it is not in the carrier list and must not be offered in new designs.
- Shipping price including margin is shown when the customer selects the method. Requires the Inventory app (Delivery Methods setting) and product weight/volume for rate computation.
- Credentials per carrier; use Test environment first. Provider state mirrors payment providers (test vs production).

## Mondial Relay migration (databases coming from 19 or earlier)
1. Before upgrading, list delivery methods using the Mondial Relay integration and the open orders/pickings that reference them.
2. Close or deliver open orders on those methods; archive the methods on the source database where possible.
3. Plan the replacement: a rule-based or fixed-price custom method, Click & Collect, or another supported carrier/aggregator (Sendcloud, Envia.com). What the upgrade does with existing Mondial Relay methods and data: (verify in 20.0 docs: https://www.odoo.com/odoo-20-release-notes).
4. Remove any custom module dependency on `delivery_mondialrelay` (manifest `depends`, views, controllers).
5. Test checkout on the upgraded copy: pickup-point selection no longer exists, so confirm the replacement flow and wording on the delivery step.

## Custom delivery methods
- Website > Configuration > Delivery Methods > New. Types: Fixed Price, Based on Rules, Click & Collect (carrier integrations are separate).
- Website field restricts to one website; Availability tab sets conditions (countries, states, zip prefixes, min/max weight/volume/amount); Cash on Delivery option; Tracking Link template.
- Free shipping: set a fixed method with price 0 or use "free if order amount above" on the method (verify in 20.0 docs: new_delivery_method.html).
- Rule-based: price = base + variable x weight/volume/quantity/price; first matching rule wins, order by sequence.

## Click & Collect (in-store pickup)
1. Enable Click & Collect in Website settings (eCommerce section), save.
2. Configure Pickup Locations; provider "Pick up in store".
3. Stores tab: Add a line, select warehouse(s).
4. Set status to Published (default Unpublished).
- Each warehouse needs complete address; products must be in stock there unless Continue selling is on; multi-company: warehouse company = website company; not for services; Pay on Site is enabled/published by default.

## Operations
- Confirmed order creates a delivery order (picking) in Inventory; carrier labels generated at validation; tracking number shared via portal. Batch and wave picking are part of core `stock` in 20 (`stock_picking_batch` merged), so no extra module is needed to group web orders for picking.
- Multi-warehouse: website warehouse (Settings) drives stock display; pickup uses chosen store warehouse.
- Taxes on shipping: set the delivery product's taxes; fiscal position applies.
- Returns/RMAs follow standard Sales/Inventory return flow.

## Pitfalls
- "No shipping method available": missing weight, country/zip condition mismatch, or carrier in disabled state.
- Carrier rate currency differs from website currency: conversion margin surprises.
- Delivery method not published/website mismatch hides it at checkout.
- Click & Collect with stock only in another warehouse shows out of stock.
- Upgrading with Mondial Relay methods or `delivery_mondialrelay` dependencies still present.
