# Planning and scheduling (Odoo 19)

Sources (confirmed): https://www.odoo.com/documentation/19.0/applications/services/planning.html ; task dates in https://www.odoo.com/documentation/19.0/applications/services/project/tasks/task_creation.html ; templates in https://www.odoo.com/documentation/19.0/applications/services/project/project_management/project_templates.html ; dependencies in https://www.odoo.com/documentation/19.0/applications/services/project/tasks/task_dependencies.html

## Task-level scheduling (Project)
- Task: Allocated Time (expected duration, tracked by timesheets), Deadline; the date picker calendar icon sets start/end with optional times. Gantt view: drag, dependency arrows (dot to dot). Milestones show as diamonds.
- Dependencies make Gantt dates meaningful; template-created projects compute end dates from dependencies, availability, working schedules, time off, holidays.
- Project dashboard: Planned button (hours planned in Planning shifts, incl. past and unpublished) and Timesheets and Planning (planned vs actual).

## Planning app
- Resources: employees and materials (equipment). Employee Work Information tab: Working Hours (blank = flexible) set allocated time; Planning roles limit visible templates/open shifts/auto-assign; default role possible.
- Roles: under Configuration; may link to services if Sales is installed; property fields can add role-specific data.
- Shift templates: start hour + span; end derived from working hours and breaks; can carry role and project.
- Shift form: resource, role, project, SO item (with Sales), recurrence, date, note, allocated time. "Publish & Save" emails the employee; drafts are striped.
- Gantt: drag-drop, resize, split, duplicate; grey = time off; progress bar from linked timesheets. Admin groupings: resource, role, project, sales order.
- Open shifts, auto planning, shift switching/unassignment: not confirmed in fetched text (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/services/planning.html).

## Senior guidance
- Use Planning for capacity (who/when), Project tasks for scope (what). Link shifts to projects so planned vs timesheet hours is comparable.
- Keep working schedules accurate; allocated time and template end dates derive from them.
- Time off shows grey in Gantt and, when enabled, becomes timesheet entries.
