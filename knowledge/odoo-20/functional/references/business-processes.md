# End-to-end Business Processes (UI configuration, Odoo 20)

For each flow: apps, config, document chain, controls. Verify exact setting labels in 20.0 docs: https://www.odoo.com/documentation/20.0/ (URLs below follow the 19.0 layout; 20.0 pages could not be fetched when this was adapted).

## 1. Order-to-Cash (Sales > Inventory > Accounting)
Apps: Sales, Inventory, Accounting (Invoicing in Community).
Config: products (invoicing policy), pricelists, payment terms, taxes/fiscal positions, warehouse delivery steps, customer partners (credit limit optional), quotation template, online signature/payment.
Chain: Quotation > (approval if over limit) > Sales Order > Delivery Order(s) > Customer Invoice (regular/down payment) > Payment > Reconciliation.
Controls: SO approval threshold, lock confirmed orders, credit limit warnings, invoice policy (delivered qty avoids billing undelivered), returns via Reverse transfer + Credit Note. Payment statuses are renamed in 20: re-check filters and reports that rely on invoice payment status names (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting.html).
Docs: https://www.odoo.com/documentation/20.0/applications/sales/sales.html

## 2. Procure-to-Pay (Purchase > Inventory > Accounting)
Config: vendors + vendor pricelists, reordering rules, PO approval, bill control (received qty), reception steps, vendor payment terms.
Chain: Reordering rule / MTO / manual RFQ > RFQ > PO confirm > Receipt (qty/lots) > Vendor Bill (matched to PO) > Payment.
Controls: 3-way matching via bill control + PO status "To Invoice", approval amount, vendor bill duplicate check, landed costs (Inventory > Landed Costs) allocated to valuation.
Docs: https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/purchase.html

## 3. Make-to-Stock / Make-to-Order / Dropship
- MTS: reordering rules (min/max) per product/warehouse; replenishment report; scheduler (Inventory > Operations > Replenishment; scheduler cron runs it).
- MTO: product route "Replenish on Order (MTO)" (activate archived route if needed); sale confirms triggers PO/MO.
- Dropship: enable Dropshipping (Inventory settings), product route Dropship + vendor; SO creates PO delivering to customer; no stock move in own warehouse.
- Multi-step: Settings > Multi-Step Routes + warehouse steps (pick/pack/ship). Batch and wave picking is core `stock` in 20 (the separate `stock_picking_batch` module is gone); delivery carrier `delivery_mondialrelay` is removed.

## 4. Manufacturing (MRP)
Config: BoM (components, operations, by-products, kit type), Work Centers, routes "Manufacture", reordering/MTO, Quality points (Enterprise), subcontracting (vendor + subcontracting BoM).
Chain: SO/Reorder > Manufacturing Order > component reservation/pick > Work Orders on tablet > Finished goods > Valuation entries.
Controls: lead times & planning (MO/work center scheduling), scrap, unbuild, cost analysis (Cost of BoM / MO Cost Analysis), consumption flexibility on BoM.
Docs: https://www.odoo.com/documentation/20.0/applications/inventory_and_mrp/manufacturing.html

## 5. Lead-to-Quote (CRM > Sales)
Pipeline stages > Opportunity > Quotation (button) > SO > Won. Config: teams, stages, lost reasons, assignment rules, activity types, email alias per team, lead scoring. Automate follow-up with automation rules (see automation.md).

## 6. Subscriptions / Recurring (Enterprise)
Recurring plans (monthly/yearly), recurring products, recurring invoices via scheduled invoicing, renewal/upsell/close reasons, payment tokens for auto-charge. Verify v20 subscription UI wording: https://www.odoo.com/documentation/20.0/applications/sales/subscriptions.html

## 7. Services: Project > Timesheet > Invoice
Service product (Create task in project + invoice by timesheets or milestones or fixed price) > SO confirm creates project/task > employees log timesheets (Timesheets app/task) > Invoice based on timesheet (Time & Materials) > Analytic entries produce project profitability (Project > Reporting / Profitability panel).
Config: timesheet UoM, employee hourly cost (HR), billing rate/rate cards, analytic plan.
On-site / field work: **Field Service is discontinued in 20 and its features moved into Planning**. Re-map dispatch and scheduling, worksheets, time-and-materials billing and mobile workflow to Planning, Project and Sales (see the field-service topic for the mapping and migration checklist). Docs: https://www.odoo.com/documentation/20.0/applications/services/planning.html
Docs: https://www.odoo.com/documentation/20.0/applications/services.html

## 8. Hire-to-Retire (HR)
Recruitment (job position > applicants > interviews > offer > contract) > Employee > Contract + salary structure (Payroll) > Time Off (types, allocations, approval) > Attendance > Expenses > Offboarding (archive employee, end contract).
- **Payroll**: payroll work entries are removed in 20, so payslip generation no longer assumes a work-entry step between attendance/time off and the payslip; how time off, attendance and other inputs reach the payslip is (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr.html). The modules `hr_work_entry_holidays`, `l10n_fr_hr_work_entry_holidays`, `hr_org_chart` and `hr_homeworking` no longer exist in 20.
- **Expenses**: in 20 an employee expense becomes a **draft vendor bill**. Chain: employee submits > manager approves (verify where approval now sits) > the draft vendor bill is reviewed and posted by accounting > reimbursed/paid through the normal vendor-bill payment flow (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/expenses.html).
Config: departments/managers (drive approvers), work schedules, public holidays, time off types with validation (no validation / by manager / by HR / both), expense products with accounts (these feed the vendor bill lines in 20).
Docs: https://www.odoo.com/documentation/20.0/applications/hr.html

## 9. Helpdesk (Enterprise) / Customer Support
Teams, stages, SLA policies, assignment methods (manual/random/balanced), email alias/ web form/live chat as channels, ratings, billable tickets (timesheet + SO), refund/return from ticket. Docs: https://www.odoo.com/documentation/20.0/applications/services/helpdesk.html

## 10. Point of Sale to Accounting
Session open > sales (cash/card/customer account) > session close (counted cash difference) > posting to journals (entries per session) > invoice optionally > stock deducted at close (or at order depending on settings). Config: payment methods map to journals; cash rounding; fiscal position per PoS.

## 11. eCommerce
Published product > cart > checkout (address, shipping method, payment provider) > SO (confirmed on payment) > delivery > invoice. Config: pricelists by country/currency, abandoned cart email (automation), payment provider state Enabled/Test, shipping connectors (`delivery_mondialrelay` is removed in 20), taxes by fiscal position (B2B VAT). Wishlist and product comparison are part of `website_sale` in 20 (the modules `website_sale_wishlist` and `website_sale_comparison` are merged).

## 12. Inter-company
Multi-company with inter-company rules (Settings > Companies > Inter-Company Transactions in Sales/Purchase settings): SO in company A creates PO in B (and vice versa), invoices/bills sync optionally. Needs partner = company link and product shared or company-agnostic. (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/general/multi_companies.html)

## 13. Period close & compliance (Accounting)
Reconcile bank > review aged receivable/payable > post accruals/deferrals (Enterprise assets/deferred) > depreciation > tax return (Tax report closing entry) > lock dates > financial statements (Balance Sheet, P&L). In 20, bank-impacting journal entries must originate from bank transactions (no manual entries on bank journals), and parent accounts replace account groups (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting.html).

## Fit-gap checklist per flow
Document types and numbering; approvals; who sees which price/cost; taxes/currency; stock impact and valuation entries; email/print outputs (templates and layout); analytic assignment; reports needed; edge cases (returns, partial deliveries, credit notes, multi-currency).
