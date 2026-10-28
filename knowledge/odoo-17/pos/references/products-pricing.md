# Products, pricing, loyalty

Sources (19.0 layout, version swapped; verify paths in 17.0): https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/products.html ; https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/extra/pricing.html ; https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/shop.html

## Products
- Product form: tick Point of Sale (Available in PoS). Create in Point of Sale > Products > Products; creating a product from the register menu may not exist in 17.0 (verify).
- POS categories on the Point of Sale tab; with categories in use, uncategorised products do not display.
- Variants: enable Variants in Inventory settings; attributes on Attributes & Variants tab; selectable in register and self-order.
- Combos and combo choices (introduced in 17.0): (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/products.html for exact setup, Combo Choices menu and product type).
- Show margins & costs: PoS settings (Product & PoS categories section where present; verify). Available in Self Order appears once self-ordering is on.
- Units of Measure & Packagings: Inventory setting. Barcode and weighted-product rules: (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/hardware_network/scale.html).

## Taxes
- Taxes come from the product customer taxes; price shown tax-included or excluded per tax config. Fiscal positions remap taxes per order (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/shop.html for the setting name).
- Test a receipt per tax scenario.

## Pricelists vs programs
- Pricelists: structured, persistent rules per customer/context; enabled in PoS settings, Pricing (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/extra/pricing.html for the setting name).
- Discount/loyalty programs: promotional, time-sensitive, public.

## Discounts and programs (PoS settings > Pricing)
- Global Discounts and Line Discounts: enable. Global: Discount button on the order screen. Line: % modifier then numpad.
- Promotions, Coupons, Gift Card & Loyalty Program: enable, then Point of Sale > Products > Discount & Loyalty ; gift cards: Products > Gift cards & eWallet.
- Codes/coupons: Enter Code button > Apply; codes print on receipts.
- Promotions auto-apply when conditions are met; Buy X get Y reward is added manually via the Reward button.
- Loyalty: select the customer first; points show in cart; redeem via the Reward button.
- Gift cards sold at register; eWallet = store credit on a customer; both payable.
- In 17 these actions are buttons on the order screen; later versions group them under an ellipsis menu. Confirm button names on the 17.0 register.

## Pitfalls
- Overlapping pricelist and promotion rules give surprising totals; test stacked cases.
- Loyalty needs a customer on the order; anonymous sales earn nothing.
- Global discounts post via the discount product income account; check it.
