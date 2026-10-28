# Payments and hardware

Sources (19.0 layout, version swapped; verify paths in 17.0): https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/payment_methods.html ; https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/hardware_network.html ; https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/hardware_network/pos_iot.html

## Create a payment method
Point of Sale > Configuration > Payment Methods > New:
1. Name.
2. Optional: Online Payment (Allowed Providers) (online payment methods arrived around 17; verify) ; Identify Customer (customer required at payment; verify in 17.0).
3. Journal (cash journal for cash; Bank journal for terminals).
4. Point of Sale: where it is enabled (also manageable in PoS settings > Payment).
5. Integration: None required (cash) | Terminal (card; set terminal up first) | Bank App (QR Code) (needs bank account on journal + QR Code Format; verify availability in 17.0) | Cash Machine (Cashdro in the older set; Glory and Cashmatic are newer: verify).
- Delivery Payment + Delivery Provider (UrbanPiper online orders) are not part of 17: do not offer them (verify).
- Intermediary Account (needs Accounting): receivable account used before reconciliation; empty = company default receivable.
- One-click payment (shortcut buttons beside Payment) is newer than 17 (verify); in 17 use the normal payment screen.
- Customer account (on credit): https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/payment_methods/customer_credit.html
- QR codes: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/payment_methods/qr_code_payment.html

## Terminals (one page per provider)
Overview: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/payment_methods/terminals.html ; providers under https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/payment_methods/terminals/ : the 19.0 docs list adyen, dpo, ingenico, mercado_pago, mollie, pine_labs, qfpay, razorpay, six, stripe, tyro, viva_com, worldline (.html).
- Several of these are newer than 17. Providers most likely present in 17: Adyen, Stripe, Six, Mercado Pago, Viva.com (Viva Wallet), Ingenico (via IoT), Razorpay; treat DPO, Mollie, Pine Labs, QFPay, Tyro and Worldline as unconfirmed until you see the provider in the 17.0 docs or in Apps (verify per provider and region).
- Pattern: configure provider account/API keys (test mode) > payment method with Integration=Terminal and provider > assign to PoS > pair terminal > test payment, cancel, refund.
- Pick provider by country; check the provider page for supported regions.
Cash machines: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/payment_methods/cash_machines.html (cashdro, cashmatic, glory subpages in the 19.0 docs; verify which exist in 17.0).

## Hardware and network
- Supported: payment terminals, cash drawers, customer displays, scales, barcode scanners, receipt printers, electronic shelf labels (Pricer; verify availability in 17.0).
- IoT: set up IoT Box or Windows virtual IoT gateway (verify availability), connect devices, in IoT app click Connect, set Associated POS (turns on the IoT Box setting). Add devices individually. Ingenico needs its own dedicated gateway.
- Local Network Access (browser-to-hardware without SSL certificates, pos_lna page in the 19.0 docs) is a later-version approach: in 17 use Epson ePOS with a self-signed certificate or an IoT Box.
- ePOS over HTTPS needs a self-signed certificate: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/hardware_network/epos_ssc.html
- Printers: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/hardware_network/receipt_printers.html ; scale (EU legal settings): https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/hardware_network/scale.html ; customer display: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/hardware_network/customer_display.html ; shelf labels: https://www.odoo.com/documentation/17.0/applications/sales/point_of_sale/hardware_network/electronic_labels.html (verify these pages in 17.0)

## Pitfalls
- Terminal payment method journal must be Bank; a cash journal breaks reconciliation.
- On terminal timeout, confirm status at the terminal/provider before retrying to avoid double charges.
- Wi-Fi printers drop silently; prefer Ethernet and fixed IPs.
