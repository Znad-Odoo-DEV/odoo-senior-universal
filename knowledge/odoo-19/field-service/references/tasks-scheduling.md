# Tasks, planning, dispatch

Sources: https://www.odoo.com/documentation/19.0/applications/services/field_service/creating_tasks.html and https://www.odoo.com/documentation/19.0/applications/services/field_service/planning_itinerary.html

## Creating tasks (confirmed)
- Manual: Field Service > All Tasks > All Tasks > New; title and Customer, optional fields, Save.
- From sales: quotation with a service product, confirm; the task is created automatically in your Field Service project; open it via the SO Tasks smart button.
- From Helpdesk: tickets can generate field tasks (steps in the Helpdesk after-sales article; verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/services/helpdesk.html).

## Model facts (code knowledge; verify on the instance)
- Field task = `project.task` whose project has `is_fsm = True`; a default Field Service project exists after install.
- Service product creating tasks: type Service, service tracking "Task" in an existing project (pick the FSM project). Without it no task is generated.
- Useful task fields: partner_id (Customer), user_ids (assignees), planned dates, worksheet template, stage, done flag.

## Map and itinerary (confirmed)
- Field Service > My Tasks > Map pins each task of the day; Today filter is on by default, remove it to list all tasks sorted by date.
- A task needs a valid customer address to appear.
- Itinerary: Mapbox integration draws the route; sequence follows Planned Date. View in Google Maps opens the itinerary from the current location; per task use Open the task or Navigate to.

## Dispatch practice
- Dispatcher views: list/kanban of All Tasks, Map, and Gantt/Planning by assignee (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/services/planning.html).
- Plan by setting assignee + Planned Date; avoid overlapping slots per technician; tasks with no assignee are the dispatch backlog.
- Teams and skills: use assignees and, with the Planning app, roles and resource grouping (verify in 19.0 docs: planning URL above). Do not assume a team field on tasks.
- Recurring service: recurrence on tasks/planning or subscriptions (verify in 19.0 docs).

## Checks
Customer address valid? Mapbox token set for route lines? Planned Date filled? Assignee set?
