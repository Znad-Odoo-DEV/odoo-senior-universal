# Valuation and accounting link

Docs (verify paths in 17.0 docs): cheat sheet https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory.html ; operations valuation https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory.html ; landed costs https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory.html ; by lots (later feature, may not exist in 17.0) https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory.html ; scrap https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory.html

## Cheat sheet
- Costing methods (Costing Method on the product category): Standard Price (fixed, manually updated), Average Cost (AVCO, weighted average), FIFO. LIFO/FEFO are removal strategies only.
- Valuation modes (Inventory Valuation on the product category): Manual = periodic (bills to expense, stock accounts adjusted by entries at closing; common in Europe) vs Automated = perpetual (stock moves post journal entries, bills to stock/interim, COGS on sale; Anglo-Saxon accounting setting in Accounting settings).
- Category fields: Stock Valuation Account, Stock Input/Output (interim received/delivered) Accounts, Stock Journal, plus Expense/COGS and Income accounts. The Inventory Adjustment (loss) account sits on the Inventory loss location. Exact labels: (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/inventory.html).
- Stock valuation layers record each valued move (Inventory > Reporting > Valuation); FIFO consumes layers in order and AVCO recomputes the average cost on receipts (verify layer behavior in 17.0 docs).

## Decisions
1. Costing method per category before first move: Standard for stable cost with variance analysis; Average for simple trading; FIFO when actual cost or per-lot cost matters.
2. Automated (perpetual) if finance needs live stock on the balance sheet; Manual (periodic) if closing entries suffice.
3. Separate stock accounts for raw/finished/trading to ease reconciliation.

## Entries (Automated/perpetual, typical; verify account names in operations_valuation page)
- Receipt: Dr Stock / Cr stock interim (received); vendor bill clears interim vs payable.
- Delivery: Cr Stock / Dr interim (delivered); invoice posts COGS/revenue.
- Adjustments/scrap: Dr loss or scrap expense / Cr Stock.

## Landed costs
- Needs the Landed Costs setting; create a landed cost document, select receipts, add cost lines (service products flagged as landed cost with a split method: equal, by quantity, current cost, weight, volume), compute, validate. Valuation impact for Average/FIFO, with journal entries on Automated categories. Exact flags/menus: verify in 17.0 docs (landed_costs page).

## Reconciliation
- Valuation report total must equal the stock account balance at the same date. Typical gaps: manual entries on the stock account, missing category accounts, changed costing method, unposted bills.
- Never post manual entries to the stock account; use adjustments or revaluation.
- Revaluation/cost updates: documented reason, staging test, controlled routine.
