# Planning and scheduling (Odoo 17)

Sources (19.0 layout, version swapped; verify paths in 17.0): https://www.odoo.com/documentation/17.0/applications/services/planning.html ; task dates in https://www.odoo.com/documentation/17.0/applications/services/project/tasks/task_creation.html ; dependencies in https://www.odoo.com/documentation/17.0/applications/services/project/tasks/task_dependencies.html

## Task-level scheduling (Project)
- Task: Allocated Time (expected duration, tracked by timesheets), Deadline; the date picker calendar icon sets start/end with optional times. Gantt view (Enterprise): drag, dependency arrows (dot to dot). Milestones show as diamonds.
- Dependencies make Gantt dates meaningful. Native project templates that compute end dates from dependencies, availability, schedules, time off and holidays are a later-version feature (verify); in 17.0 reschedule a duplicated project's tasks manually (for example by dragging them in Gantt).
- Project dashboard: Planned button (hours planned in Planning shifts, incl. past and unpublished) and Timesheets and Planning (planned vs actual); verify the exact buttons in 17.0.

## Planning app
- Resources: employees and materials (equipment). Employee Work Information tab: Working Hours set allocated time (in 17 a working schedule is required; flexible hours are newer); Planning roles limit visible templates/open shifts/auto-assign; default role possible.
- Roles: under Configuration; may link to services if Sales is installed; property fields can add role-specific data (verify in 17.0).
- Shift templates: start hour + span; end derived from working hours and breaks; can carry role and project.
- Shift form: resource, role, project, SO item (with Sales), recurrence, date, note, allocated time. "Publish & Save" emails the employee; drafts are striped.
- Gantt: drag-drop, resize, split, duplicate; grey = time off; progress bar from linked timesheets. Admin groupings: resource, role, project, sales order.
- Open shifts, auto planning, shift switching/unassignment: not confirmed in fetched text (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/services/planning.html).

## Senior guidance
- Use Planning for capacity (who/when), Project tasks for scope (what). Link shifts to projects so planned vs timesheet hours is comparable.
- Keep working schedules accurate; allocated time and template end dates derive from them.
- Time off shows grey in Gantt and, when enabled, becomes timesheet entries.
