# Quotations and Orders (Odoo 20)

Base: https://www.odoo.com/documentation/20.0/applications/sales/
Index (ported from the 19.0 layout, verify in 20.0 docs): sales/sales_quotations.html

## Lifecycle
Quotation (draft) -> Quotation Sent -> Sales Order (confirmed) -> locked/done or cancelled. Confirmation triggers delivery (stock), invoice per policy, and task/project/subscription creation per product configuration. Exact state labels and lock behavior: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/sales/sales_quotations/create_quotations.html).

## Doc pages (sales/sales_quotations/...; 19.0 layout, verify in 20.0 docs)
- create_quotations.html - build a quote
- quote_template.html - reusable templates (preset lines, validity, terms)
- margin.html - margin display on quotes
- optional_products.html - upsell suggestions the customer adds from the portal
- get_signature_to_validate.html - online signature confirms the order
- get_paid_to_validate.html - online payment confirms the order
- deadline.html - quotation validity/expiration
- different_addresses.html - separate invoice and delivery addresses
- orders_and_variants.html - variants on lines
- pdf_quote_builder.html (+ pdf_quote_builder/dynamic_text.html, add_pdf_quotes.html, add_pdf_products.html) - PDF layout, dynamic fields, attached PDFs/URLs
- custom_signatures.html - email signatures

## Practice
- Use quotation templates for repeatable offers; set default validity so stale quotes expire.
- Optional products belong on the template or line, not as extra lines to delete later.
- Online signature vs online payment: choose per customer segment; both confirm the order from the portal. Prepayment percentage option: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/sales/sales_quotations/get_paid_to_validate.html).
- Margins show only with the related setting/group; check access before promising it to reps.
- Addresses: use partner child contacts of type Invoice/Delivery; set on the order, they flow to picking and invoice.
- CRM link: quotations can be created from an opportunity (crm/acquire_leads/send_quotes.html), keeping the opportunity linked.
- Pricing/discount: products-pricing.md. Invoicing: invoicing-flow.md.

## Checks
- Confirm a test quote through the portal as the customer (signature/payment) before go-live.
- Verify sequence, company, salesperson/team defaults when created from CRM vs manually.
- Multi-company: company scope of quotation templates and pricelists.
- Upgraded database: custom access rules on sale.order (team or salesperson visibility) must be ported to `ir.access` (20 merges record rules into it); test as a salesperson and as a manager.
