---
name: manufacturing
description: Senior Odoo 17 Manufacturing/MRP expertise. Use for Odoo 17 Manufacturing — bills of materials, work centers and work orders, routing, manufacturing orders, components and by-products, subcontracting, and master production scheduling.
---

# Odoo 17 Manufacturing / MRP

## Mindset
- The BoM is the contract: components, operations, by-products and lead times all derive from it. A wrong BoM produces wrong costs, wrong procurement and wrong schedules downstream.
- Start with the simplest flow that fits (one-step, no work orders). Add work orders, multi-step picking, IoT or quality only when shop-floor reality demands the data.
- Decide per product: Buy, Manufacture, Subcontract, or Kit. Routes and BoM type must agree with that decision.
- Treat master data (UoM, lead times, work center capacity, vendor lead time) as the planning engine. Garbage in, late orders out.
- Verify behavior in a test database with a real MO before advising; confirm version-specific details in the 17.0 docs.

## Principles
1. **BoM type**: Manufacture (MO), Kit (exploded on delivery, no MO), Subcontracting (PO to vendor generates receipt and subcontract MO). See references/boms.md.
2. **Variants**: one BoM can serve several variants via "Apply on Variants" on component and operation lines. Prefer this over a BoM per variant.
3. **Operations require Work Orders** (Settings > Operations). Each operation names a work center and a duration; durations drive planning and cost.
4. **Work center realism**: working hours, time efficiency, capacity, setup/cleanup and OEE target feed scheduling. See references/work-centers-orders.md.
5. **MO flow**: Draft > Confirmed > In Progress > To Close > Done. Reservation, readiness, backorders, scrap and unbuild each have their own rules. See references/mo-flow.md.
6. **Flexible consumption** (Blocked / Allowed / Allowed with warning) controls how far actual consumption may deviate from the BoM. Choose deliberately; it affects cost variance.
7. **By-products** need the By-Products setting; they carry quantity and an optional operation.
8. **Costing**: MO cost is estimated from the BoM (components plus work center time); real cost uses actual time (and employee cost where configured) and is set after Produce All.
9. **Subcontracting**: basic (subcontractor sources components) vs resupply (you send components). Lead time sits on the vendor line. See references/subcontracting.md.
10. **Planning**: MPS (Enterprise) forecasts and suggests replenishment but does not create orders by itself; never combine MPS products with reordering rules. See references/planning-mps.md.
11. **Multi-step manufacturing** (1/2/3 step) is a warehouse setting: pick components, produce, store finished goods as separate transfers.
12. **Shop Floor** (new in 17.0) is the operator UI; use it for time tracking, quality checks and lot/serial registration (verify edition and exact feature set in the 17.0 docs).

## Common traps
- Operations on the BoM but Work Orders setting off: operations are unused.
- Missing lead times: MO and PO dates collapse to today and everything shows delayed.
- UoM mismatch between BoM line and product: quantity and cost errors.
- Kit used where an MO is needed (no stock for the kit, no cost roll-up).
- Components listed on a basic subcontracting BoM: they are then treated as resupplied components.
- Backorder prompt answered wrongly at validation: remaining quantity is lost or the MO closes short.
- "Replenish Scrapped Quantities" in one-step manufacturing: no picking exists to replenish.
- Editing a confirmed MO's components or quantities: stock moves are regenerated.

## Working method
1. Clarify product strategy (make/buy/subcontract, tracking, variants).
2. Model BoM(s) and operations; set UoM, lead times, work centers.
3. Choose warehouse manufacturing steps and routes.
4. Dry-run: confirm an MO, check reservation, schedule, cost, backorder and scrap.
5. Plan: MPS or reordering rules, never both for one product.
6. Document decisions and the owner of each master-data field.

## References
- references/boms.md - BoM types, kits, variants, by-products, flexible consumption
- references/work-centers-orders.md - work centers, capacity, work orders, dependencies, Shop Floor
- references/mo-flow.md - MO lifecycle, components, backorders, scrap, unbuild, costs
- references/subcontracting.md - basic, resupply, dropship subcontracting
- references/planning-mps.md - MPS, scheduling, replenishment link

Odoo 17 docs index: https://www.odoo.com/documentation/17.0/applications/inventory_and_mrp/manufacturing.html
(Deep-page paths in the references follow the 19.0 docs layout with the version swapped; confirm each resolves in 17.0 and note that some 19.0-only pages and fields may not exist in 17.)
