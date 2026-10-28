---
name: field-service
description: Senior Odoo 19 Field Service expertise. Use for Odoo 19 Field Service — field tasks, scheduling and dispatch, worksheets, logging time and products/materials, invoicing from interventions, and the mobile/onsite workflow.
---

# Odoo 19 Field Service (senior)

## Mindset
- Field Service (FSM) is Project + Sales + Timesheets + Inventory specialised for onsite work. A field task is a `project.task` in a project flagged Field Service (`is_fsm`); most behaviour comes from the sibling apps. Debug the sibling first.
- One intervention is a chain: sale order line (service product) -> task -> worksheet + timesheets + materials -> sign-off -> invoice. Any break in the chain is a billing leak.
- Design for a technician on a phone with bad signal: few mandatory fields, one worksheet template per service type, checkboxes over free text.
- Dispatch is a data problem: valid customer addresses, planned dates, assignees and a correct default warehouse make the map, itinerary and stock deduction work.

## Principles
1. Enable features deliberately in Field Service > Configuration > Settings (Worksheets, Time and Material Invoicing). Worksheets installs Studio, which can change the price plan; warn the customer first.
2. Create tasks from a confirmed sale order with a service product that creates a task in a Field Service project; manual creation only for ad-hoc work. Helpdesk tickets can also spawn field tasks.
3. Always set Customer with a valid address: the map view and itinerary skip tasks without one.
4. Dispatch by Planned Date and assignee; itinerary order follows Planned Date (Mapbox draws the route, View in Google Maps hands off navigation).
5. One worksheet template per recurring service; set the default in the project settings (Field service section). Required fields gate worksheet completion; use them for readings you cannot bill or audit without.
6. Capture time with timesheets and materials with the task Products catalog; both flow to the sale order and invoice. Never re-key them.
7. Materials come from the user's default warehouse (needs storage locations and more than one warehouse); marking the task done updates that stock.
8. Decide the billing basis per project/product (time and materials vs fixed price) before go-live; mixing silently double-bills or under-bills.
9. Close the loop: worksheet complete, customer sign-off, task done, then invoice. Invoice only completed interventions.
10. Test with a technician user (restricted rights) on mobile, not just as admin.

## Pitfalls
- Task not on map: customer address missing or Today filter still on.
- Products added but not invoiced: Time and Material Invoicing off or billing type not set.
- Stock not moving: wrong default warehouse on the user, or task not marked done.
- Worksheet button empty: no template selected on the task.
- Studio-built worksheet templates are DB customisations; carry them into modules for multi-DB rollout.

## Workflow for a request
1. Clarify service types, billing model, who dispatches, stock use, signature need.
2. Configure settings, projects, products, worksheet templates, warehouses.
3. Walk one intervention end to end on a test database (SO -> task -> plan -> onsite -> invoice) and inspect the invoice lines.
4. Hand over with a short technician cheat sheet.

## References
Confirmed Odoo 19 docs:
- Landing: https://www.odoo.com/documentation/19.0/applications/services/field_service.html
- Creating tasks: https://www.odoo.com/documentation/19.0/applications/services/field_service/creating_tasks.html
- Products: https://www.odoo.com/documentation/19.0/applications/services/field_service/product_management.html
- Itinerary: https://www.odoo.com/documentation/19.0/applications/services/field_service/planning_itinerary.html
- Worksheets: https://www.odoo.com/documentation/19.0/applications/services/field_service/worksheets.html

Deep dives (load on demand):
- references/tasks-scheduling.md : tasks, planning, dispatch, teams
- references/worksheets.md : templates, onsite capture
- references/time-products-billing.md : time, materials, invoicing, SO link
- references/mobile-workflow.md : onsite flow, timer, sign-off
