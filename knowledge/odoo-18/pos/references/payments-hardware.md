# Payments and hardware

Sources (confirmed): https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale/payment_methods.html ; https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale/hardware_network.html ; https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale/hardware_network/pos_iot.html

## Create a payment method
Point of Sale > Configuration > Payment Methods > New:
1. Name.
2. Optional: Online Payment (Allowed Providers) ; Identify Customer (customer required at payment).
3. Journal (cash journal for cash; Bank journal for terminals).
4. Point of Sale: where it is enabled (also manageable in PoS settings > Payment).
5. Integration: None required (cash) | Terminal (card; set terminal up first) | Bank App (QR Code) (needs bank account on journal + QR Code Format) | Cash Machine (Cashdro, Glory). These Integration option labels come from the newer docs; on 18 the field and options may be named differently (e.g. Use a Payment Terminal): verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale/payment_methods.html
- Delivery Payment + Delivery Provider: Urban Piper online orders (verify availability on 18).
- Intermediary Account (needs Accounting): receivable account used before reconciliation; empty = company default receivable.
- One-click payment: PoS settings > Payment; shortcut buttons beside Payment; unavailable for online, delivery, terminal, ID-verified methods; assumes exact cash.
- Customer account (on credit): https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale/payment_methods/customer_credit.html
- QR codes: https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale/payment_methods/qr_code_payment.html

## Terminals (one page per provider)
Overview: https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale/payment_methods/terminals.html ; providers under https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale/payment_methods/terminals/ : adyen, dpo, ingenico, mercado_pago, mollie, pine_labs, qfpay, razorpay, six, stripe, tyro, viva_com, worldline (.html). This provider list is from the newer docs; Odoo 18 supports fewer providers and some page names differ (verify the list on the 18 terminals page).
- Pattern: configure provider account/API keys (test mode) > payment method with Integration=Terminal and provider > assign to PoS > pair terminal > test payment, cancel, refund.
- Pick provider by country; check the provider page for supported regions.
Cash machines (verify which of Cashdro, Cashmatic, Glory exist on 18): https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale/payment_methods/cash_machines.html (cashdro, cashmatic, glory subpages).

## Hardware and network
- Supported: payment terminals, cash drawers, customer displays, scales, barcode scanners, receipt printers, electronic shelf labels (Pricer).
- IoT: set up IoT Box or Windows virtual IoT gateway, connect devices, in IoT app click Connect, set Associated POS (turns on the IoT Box setting). Add devices individually. Ingenico needs its own dedicated gateway. Newer docs add a Local Network Access option to reach the gateway; on 18 reach it over the network or certificate route (verify).
- Local Network Access (newer-release feature; the page may not exist in 18, in which case use the self-signed certificate route below): browser talks to local hardware (e.g. ePOS printers) without SSL certificates: https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale/hardware_network/pos_lna.html
- ePOS over HTTPS needs a self-signed certificate: https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale/hardware_network/epos_ssc.html
- Printers: https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale/hardware_network/receipt_printers.html ; scale (EU legal settings): https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale/hardware_network/scale.html ; customer display: https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale/hardware_network/customer_display.html ; shelf labels: https://www.odoo.com/documentation/18.0/applications/sales/point_of_sale/hardware_network/electronic_labels.html

## Pitfalls
- Terminal payment method journal must be Bank; a cash journal breaks reconciliation.
- On terminal timeout, confirm status at the terminal/provider before retrying to avoid double charges.
- Wi-Fi printers drop silently; prefer Ethernet and fixed IPs.
