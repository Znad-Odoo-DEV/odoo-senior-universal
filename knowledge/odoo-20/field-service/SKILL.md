---
name: field-service
description: Odoo 20 Field Service transition playbook. The Field Service app is DISCONTINUED in Odoo 20 and its features moved into Planning. Use to answer where Field Service went, how to map field tasks, scheduling, worksheets, time and materials billing and the mobile workflow to Planning/Project/Sales, and how to migrate an existing Field Service database to Odoo 20.
---

# Field Service in Odoo 20: where did it go, and how to migrate (senior)

## Ground truth
- **Odoo 20 discontinues the Field Service app. Its features moved into Planning.** There is no Field Service app to install, configure or train people on in 20.
- Field Service still exists in 17, 18 and 19 (project flagged Field Service, `is_fsm`). Do not tell a 19 customer to stop using it; the cut happens at the 20 upgrade.
- What is NOT established here: the exact 20 menu paths and whether worksheets and sign-off have a native Planning equivalent (auto plan, live map and travel fees are confirmed in Planning). Every such point is marked "(verify in 20.0 docs: <url>)". Never promise parity without checking the instance or the release notes: https://www.odoo.com/odoo-20-release-notes
- Planning docs (target): https://www.odoo.com/documentation/20.0/applications/services/planning.html . Discontinuation is CONFIRMED by the 20 release notes: "The Field Service app has been discontinued. Its features are now integrated into the Planning app"; the Planning section lists former Field Service features including auto plan, live map and travel fees (https://www.odoo.com/odoo-20-release-notes). Confirmed on the Planning page: shifts on resources (employees or materials) and roles, recurring and open shifts with Auto Plan, Gantt view, Sales integration (services linked to roles and shifts) and Project integration (shifts dedicated to projects). The old field_service.html page still exists in the 20.0 docs (not yet removed) — do not read that as the app surviving. Worksheets and the full task/map detail: verify in Planning on the instance.

## Mindset
- Treat this as a migration and re-design job, not a how-to for a removed app. The business flow stays: sale order line (service product) -> task -> schedule -> onsite capture (time, materials, worksheet) -> sign-off -> invoice. Find where each link lives in 20 and close every gap on a test copy.
- Most FSM behaviour always came from the sibling apps (Project, Sales, Timesheets, Inventory). Those carry over; the FSM-specific layer is what to re-map.
- Order of work: inventory what the customer really uses in FSM, decide per capability (native Planning / Project-Sales-Timesheets / Studio-or-code / drop), test on an upgraded copy, then cut over.

## Capability map (19 Field Service -> 20)
| FSM capability (19) | Where it lives in 20 | Status |
|---|---|---|
| Field task (`project.task` in an `is_fsm` project), tasks from SO service products | Project/Planning task; Sales service product creating a task in a project | App gone (established); target project/flag details: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/services/planning.html |
| Scheduling and dispatch (Planned Date, assignee, Gantt, roles) | Planning (shifts, roles, resources, Gantt) | Moved to Planning (established); feature detail: verify in 20.0 docs |
| Map view and itinerary (Mapbox, Google Maps hand-off) | Planning live map (confirmed, release notes: "Field Service: live map"); travel fees also moved to Planning | Verify the itinerary / navigation hand-off on the instance: planning.html |
| Worksheets (Studio-built templates) | Native Planning/Project capability unknown; fallback Studio form or custom module | Verify in 20.0 docs; archive data first |
| Time capture (task timer, timesheets) | Timesheets on the task | Carried over from 19; verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/services/timesheets.html |
| Materials (Products smart button, default warehouse stock) | Sales order lines + Inventory delivery; task product catalog unknown | Verify in 20.0 docs |
| Time and Material / fixed-price billing | Sales invoicing policy on the service product, Timesheets | Carried over from 19; verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/sales/sales/invoicing.html |
| Mobile workflow (map, timer, worksheet, sign-off) | Odoo mobile app/browser on Planning shifts and tasks | Verify in 20.0 docs |
| Helpdesk ticket -> field task | Helpdesk -> task/Planning link | Verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/services/helpdesk.html |

Detail per capability: `references/tasks-scheduling.md`, `references/worksheets.md`, `references/time-products-billing.md`, `references/mobile-workflow.md`.

## Migration playbook (existing Field Service users)
1. **Timing.** Standard support ends: 17.0 Sept 2026 (already ended), 18.0 Sept 2027, 19.0 Sept 2028. Enterprise databases older than the 3 latest majors can be charged +25% (no earlier than 6 months after a new major). FSM keeps working on 17-19; plan the 20 move around these dates.
2. **Inventory (read-only on the source DB).** FSM projects, open/closed task counts, service products creating tasks, worksheet templates and their Studio models with row counts, materials used on tasks, users' default warehouses, Mapbox token, FSM user groups, Studio views/automations on FSM tasks, custom modules depending on FSM modules, external integrations.
3. **Decide per capability** with the map above: native Planning, Project/Sales/Timesheets, Studio or module, or retire.
4. **Clean up on the source.** Finish and invoice open interventions; export worksheet data (CSV and PDF) as an archive; write down the billing basis per service product.
5. **Upgrade a copy to 20.** Python >= 3.12, PostgreSQL >= 16. Check what happened to FSM projects, tasks, worksheet models and menus (verify in 20.0 docs: release notes). Custom code: security files in `ir.access.csv` (ACLs and record rules merged into `ir.access`), public `read_group(domain, groupby, aggregates, having, offset, limit, order)`, OWL 3.
6. **Rebuild on the copy.** Configure Planning (roles, resources, shift templates), re-point service products, recreate worksheets if needed, set warehouses and billing, set up mobile use.
7. **Validate** one intervention end to end with a technician user on a phone; compare invoice lines with the 19 result.
8. **Integrations.** XML-RPC/JSON-RPC are deprecated; the `db` service is removed in 20; `common`/`object` go in Odoo 22. Move to JSON-2 `/json/2/<model>/<method>` (Custom plan only).
9. **Cut over** with a rollback point; retrain dispatchers and technicians on Planning.
10. **Ecosystem.** As of 2026-09-24 OCA had no 20.0 branches (re-check); do not plan a community Field Service add-on as the fallback without checking.

## Pitfalls
- Upgrading without inventory: worksheet data kept in Studio custom models can be orphaned or hidden.
- Telling the customer "Planning does everything" before checking map/itinerary, worksheets, sign-off.
- Mixing time-and-materials with fixed price after the move; set the invoicing policy per product again.
- Old field_service bookmarks and training material pointing at pages that no longer exist.
- Technicians tested as admin only; test with restricted rights on mobile.

## Workflow for a request
1. Ask the source version, what FSM features are actually used, who dispatches, billing basis, stock use, signature need.
2. Fill the capability map for that customer; mark every unverified row.
3. Run the playbook on a copy; list gaps; decide native vs custom.
4. Hand over a short technician and dispatcher cheat sheet for the new flow.

## References
- references/tasks-scheduling.md : tasks, scheduling and dispatch -> Planning
- references/worksheets.md : worksheets -> options after FSM
- references/time-products-billing.md : time, materials, invoicing -> Project/Sales/Inventory
- references/mobile-workflow.md : onsite flow -> Planning/mobile
Related docs (ported from the 19.0 layout; verify in 20.0 docs): Planning https://www.odoo.com/documentation/20.0/applications/services/planning.html ; Project https://www.odoo.com/documentation/20.0/applications/services/project.html ; Sales https://www.odoo.com/documentation/20.0/applications/sales/sales.html
