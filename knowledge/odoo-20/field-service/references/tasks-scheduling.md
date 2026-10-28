# Tasks and scheduling: from Field Service to Planning

Field Service is discontinued in Odoo 20; its features moved into Planning. This file maps the task, dispatch and itinerary part of the old app. Docs: Planning https://www.odoo.com/documentation/20.0/applications/services/planning.html ; Project https://www.odoo.com/documentation/20.0/applications/services/project.html ; Sales https://www.odoo.com/documentation/20.0/applications/sales/sales.html ; old pages https://www.odoo.com/documentation/20.0/applications/services/field_service/creating_tasks.html and .../field_service/planning_itinerary.html (verify in 20.0 docs; app discontinued). Menu names for 20 are not confirmed here.

## What it was in 17-19 (so you can recognise it in the source database)
- A field task was a `project.task` in a project flagged Field Service (`is_fsm = True`); a default Field Service project existed after install.
- Creation: manual (All Tasks > New), from a confirmed sale order with a service product whose service tracking creates a task in the FSM project, or from a Helpdesk ticket.
- Scheduling: Planned Date + assignee; Map view of My Tasks (Today filter) with Mapbox route and Google Maps hand-off; Gantt/Planning by assignee; roles and resource grouping through the Planning app.
- Useful fields: Customer (`partner_id`), assignees (`user_ids`), planned dates, worksheet template, stage, done flag. (Code knowledge; verify on the source instance.)

## Where each piece lives in 20
| Old FSM piece | 20 equivalent | Status |
|---|---|---|
| Field Service app and menus | Gone (app discontinued) | Established |
| Scheduling, dispatch, Gantt by resource/role | Planning | Moved into Planning (established); screens and options: verify in 20.0 docs: planning.html |
| Task record | Project task linked to Planning | Verify in 20.0 docs whether the FSM flag/project type still exists |
| Task from SO service product | Sales service product with service tracking that creates a task in a project | Carried over from 19; target project choice: verify in 20.0 docs |
| Helpdesk ticket -> field task | Helpdesk after-sales link to a task/shift | Verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/services/helpdesk.html |
| Map and itinerary | Unknown native equivalent; Mapbox token setting | Verify in 20.0 docs: planning.html |
| Teams and skills | Planning roles and resources | Verify in 20.0 docs; do not assume a team field on tasks |
| Recurring service | Recurring shifts/task recurrence or Subscriptions | Verify in 20.0 docs |

## Migration steps
1. On the source DB list FSM projects, tasks by stage and assignee, and the service products with "create task in project" pointing at an FSM project.
2. Finish or reassign open tasks; decide which historical tasks must stay searchable (they should remain as ordinary project tasks; confirm after the test upgrade).
3. On an upgraded copy check: do FSM projects/tasks survive, where do they show, which menu replaced My Tasks > Map, are assignees and planned dates intact.
4. Configure Planning: roles, resources (employees/equipment), working hours and shift templates matching your technician pool.
5. Re-point service products so a confirmed order creates the right task or shift; re-run an order end to end.
6. Rebuild dispatcher views: filters by assignee, unassigned backlog (tasks with no assignee are the dispatch backlog), Gantt by resource.
7. Reproduce the itinerary need: valid customer addresses are still required for any map or route (the old map skipped tasks without one); Mapbox token setup (verify in 20.0 docs).
8. Custom code or automations on FSM tasks (server actions, Studio views, filters on `is_fsm`) must be reviewed; security files go to `ir.access.csv`, `read_group` calls to the public 20 signature `(domain, groupby, aggregates, having, offset, limit, order)`.

## Checks before cut-over
Customer address valid? Planned dates and assignees intact after upgrade? Service products create the expected task/shift? Dispatchers can see the unassigned backlog? Technician user (restricted rights) sees only their work?

## Pitfalls
- Copying the 19 how-to into training: menus and the FSM project concept may not exist.
- Assuming Planning roles equal FSM teams.
- Overlapping slots per technician after bulk import of tasks.
