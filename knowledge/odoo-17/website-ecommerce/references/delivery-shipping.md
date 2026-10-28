# Delivery methods and carriers

Odoo 17.0 docs:
- eCommerce delivery: https://www.odoo.com/documentation/17.0/applications/websites/ecommerce/shipping.html
- Delivery methods: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/shipping_receiving/setup_configuration.html
- Third-party carriers (FedEx, UPS, DHL, USPS, bpost, Easypost, Sendcloud): https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory/shipping_receiving/setup_configuration/third_party_shipper.html
- Newer integrations Envia.com and Gelato are 18/19 additions, not expected in 17 (verify in 17.0 docs before promising them).

## Carrier integrations
- Website > Configuration > Settings, eCommerce section, Shipping Costs / Configure Delivery Methods (the "Find a Delivery Provider" wording is from newer docs; verify in 17.0 docs). Supported in 17: FedEx, UPS, DHL (labels and tracking), USPS, bpost, Easypost, and the Sendcloud aggregator (verify the exact list in the 17.0 shipper docs).
- Shipping price including margin is shown when the customer selects the method. Requires the Inventory app (Delivery Methods setting) and product weight/volume for rate computation.
- Credentials per carrier; use Test environment first. Provider state mirrors payment providers (test vs production).

## Custom delivery methods
- Website > Configuration > Delivery Methods > New. Types: Fixed Price, Based on Rules, Click & Collect (carrier integrations are separate).
- Website field restricts to one website; Availability tab sets conditions (countries, states, zip prefixes, min/max weight/volume/amount); Cash on Delivery option; Tracking Link template (verify tab and option names in 17.0 docs).
- Free shipping: set a fixed method with price 0 or use "free if order amount above" on the method (verify in 17.0 docs: setup_configuration.html).
- Rule-based: price = base + variable x weight/volume/quantity/price; first matching rule wins, order by sequence.

## Click & Collect (in-store pickup)
Verify availability and labels in 17.0 docs (Click & Collect, "Pick up in store"; the module arrived late in the 16/17 cycle).
1. Enable Click & Collect in Website settings (eCommerce section), save.
2. Configure Pickup Locations; provider "Pick up in store".
3. Stores tab: Add a line, select warehouse(s).
4. Set status to Published (default Unpublished).
- Each warehouse needs complete address; products must be in stock there unless Continue selling is on; multi-company: warehouse company = website company; not for services; Pay on Site is enabled/published by default.

## Operations
- Confirmed order creates a delivery order (picking) in Inventory; carrier labels generated at validation; tracking number shared via portal.
- Multi-warehouse: website warehouse (Settings) drives stock display; pickup uses chosen store warehouse.
- Taxes on shipping: set the delivery product's taxes; fiscal position applies.
- Returns/RMAs follow standard Sales/Inventory return flow.

## Pitfalls
- "No shipping method available": missing weight, country/zip condition mismatch, or carrier in disabled state.
- Carrier rate currency differs from website currency: conversion margin surprises.
- Delivery method not published/website mismatch hides it at checkout.
- Click & Collect with stock only in another warehouse shows out of stock.
