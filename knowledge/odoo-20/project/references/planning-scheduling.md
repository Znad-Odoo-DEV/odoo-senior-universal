# Planning and scheduling (Odoo 20)

> Provenance: items marked "confirmed on 19.0" were read from the 19.0 docs. The 20.0 pages could not be fetched, so every URL below is ported from the 19.0 layout (verify in 20.0 docs).

Sources (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/services/planning.html ; task dates in https://www.odoo.com/documentation/20.0/applications/services/project/tasks/task_creation.html ; templates in https://www.odoo.com/documentation/20.0/applications/services/project/project_management/project_templates.html ; dependencies in https://www.odoo.com/documentation/20.0/applications/services/project/tasks/task_dependencies.html

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
- Open shifts, auto planning, shift switching/unassignment: not confirmed in fetched text (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/services/planning.html).

## Field Service discontinued (Odoo 20)
- The Field Service app is discontinued in Odoo 20; its features moved into Planning. Existing Field Service users must migrate their scheduling of on-site work to Planning shifts (resource, role, project, SO item) and keep task content, timesheets and billing in Project/Timesheets/Sales (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/services/planning.html).
- Which Field Service capabilities (worksheets, product consumption on site, mobile workflow) have a direct Planning equivalent is not confirmed here: inventory the Field Service features in use before upgrading and test each against the 20.0 Planning and Project docs (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/services/planning.html).
- For a full where-did-it-go playbook, use the field-service knowledge pack for Odoo 20.

## Senior guidance
- Use Planning for capacity (who/when), Project tasks for scope (what). Link shifts to projects so planned vs timesheet hours is comparable.
- Keep working schedules accurate; allocated time and template end dates derive from them.
- Time off shows grey in Gantt and, when enabled, becomes timesheet entries.
