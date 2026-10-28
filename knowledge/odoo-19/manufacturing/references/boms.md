# Bills of Materials (Odoo 19)

Docs: https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/manufacturing/basic_setup/bill_configuration.html
Variants: https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/manufacturing/advanced_configuration/product_variants.html
By-products: https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/manufacturing/workflows/byproducts.html
Sub-assemblies: https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/manufacturing/advanced_configuration/sub_assemblies.html
Kit shipping: https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/manufacturing/advanced_configuration/kit_shipping.html

## Basics (confirmed)
- Path: Manufacturing > Products > Bills of Materials. A BoM lists components and quantities to make or repair a product; it may also define operations and work instructions.
- Types: Manufacture this Product (generates MOs), Kit, Subcontracting.
- Component line options: Apply on Variants (blank = all variants), Consumed in Operation (readiness check per operation), Manual Consumption (operator confirms consumption on the MO).
- Operations need the Work Orders setting. Each has: name, work center, optional variant restriction, duration method (time tracked / based on last N work orders / manual), default duration, Work Sheet tab (PDF, slides, text).
- Step-by-step instructions need the Quality app (instruction-type control points attached to an operation).

## Miscellaneous tab (confirmed)
- Manufacturing Readiness: "when all components are available" keeps status red until everything is ready.
- Flexible Consumption: Blocked / Allowed / Allowed with warning.
- Routing: picks which warehouse's manufacturing operation type applies (multi-warehouse).
- Analytic Distribution: records manufacturing cost on a chosen analytic model.
- Manuf Lead Time: days to complete an MO after confirmation.
- Days to prepare MO: days needed to replenish components or build sub-assemblies.
- Version field appears with PLM installed.

## Kits
- Kit BoM: the product is not manufactured; components are exploded on delivery/transfer. Use for bundles sold together.
- Kit availability derives from the limiting component. Kits can nest.
- No MO, so no cost roll-up; cost follows components at delivery (see kit shipping page for delivery behavior; verify costing in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/manufacturing/advanced_configuration/kit_shipping.html).

## Variants
- Enable Variants in settings. Use Apply on Variants on component and operation lines instead of duplicating BoMs.
- A BoM bound to one variant applies only to it; a template-level BoM applies to all.
- Typical use: attribute-driven components (e.g. color-specific paint).

## Multi-level BoMs (sub-assemblies)
- A component with its own Manufacture BoM and route generates a child MO when stock is short.
- BoM Overview (button on the BoM) shows cost, lead time and availability by level (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/manufacturing/advanced_configuration/sub_assemblies.html).

## By-products (confirmed)
- Enable By-Products (Settings > Operations). By-products tab: product, quantity, UoM, optional operation (e.g. Mush from Grind grapes).
- Produce All on the MO moves each by-product from Production to stock.
- Cost share is not covered on the by-product page (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/inventory_and_mrp/manufacturing/basic_setup/mo_costs.html).

## Senior checklist
- One BoM per product/variant set; archive obsolete BoMs, do not delete.
- Check UoM categories on component vs product.
- Manual Consumption for critical or expensive components.
- Flexible Consumption matched to shop discipline: Blocked adds friction, Allowed hides variances.
- Set lead times on BoM and operations so scheduling is realistic.
- Tie components to operations to allow precise readiness and partial starts.
