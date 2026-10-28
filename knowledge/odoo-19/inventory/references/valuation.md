# Valuation and accounting link

Docs (confirmed): cheat sheet https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/inventory/inventory_valuation/cheat_sheet.html ; operations valuation https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/inventory/inventory_valuation/operations_valuation.html ; landed costs https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/inventory/inventory_valuation/landed_costs.html ; by lots https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/inventory/inventory_valuation/valuation_by_lots.html ; scrap https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/inventory/inventory_valuation/scrapped_inventory_valuation.html

## Confirmed (cheat sheet)
- Costing methods (accounting settings, overridable per product category): Standard (fixed, manually updated), Average (weighted average), FIFO. LIFO/FEFO are removal strategies only.
- Accounting methods (Accounting > Configuration > Settings > Inventory Valuation): Periodic (bills to expense, stock adjusted at closing; common in Europe) vs Perpetual (bills to stock asset, COGS on sale; Anglo-Saxon).
- Category fields: Stock Account, Expense/COGS account, costing method override. Accounts also include Stock Variation and Inventory Adjustment (loss location).

## Decisions
1. Costing method per category before first move: Standard for stable cost with variance analysis; Average for simple trading; FIFO when actual cost or per-lot cost matters.
2. Perpetual if finance needs live stock on the balance sheet; periodic if closing entries suffice.
3. Separate stock accounts for raw/finished/trading to ease reconciliation.

## Entries (perpetual, typical; verify account names in operations_valuation page)
- Receipt: Dr Stock / Cr stock interim (received); vendor bill clears interim vs payable.
- Delivery: Cr Stock / Dr interim (delivered); invoice posts COGS/revenue.
- Adjustments/scrap: Dr loss or scrap expense / Cr Stock.

## Landed costs
- Needs the Landed Costs setting; create a landed cost document, select receipts, add cost lines (service products flagged as landed cost with a split method: equal, by quantity, current cost, weight, volume), compute, validate. Valuation impact for Average/FIFO. Exact flags/menus: verify in 19.0 docs (landed_costs page).

## Reconciliation
- Valuation report total must equal the stock account balance at the same date. Typical gaps: manual entries on the stock account, missing category accounts, changed costing method, unposted bills.
- Never post manual entries to the stock account; use adjustments or revaluation.
- Revaluation/cost updates: documented reason, staging test, controlled routine.
