# Projects, tasks, stages (Odoo 17)

Sources (19.0 layout, version swapped; verify paths in 17.0): https://www.odoo.com/documentation/17.0/applications/services/project/project_management.html ; https://www.odoo.com/documentation/17.0/applications/services/project/tasks/task_stages_statuses.html ; .../tasks/task_creation.html ; .../tasks/recurring_tasks.html ; .../tasks/sub-tasks.html ; .../tasks/task_dependencies.html ; .../project/project_management/project_milestones.html

## Projects
- Create: Project app > Create > Name > Create Project. Card menu (vertical ellipsis): View (Tasks, Milestones, Project Updates; Documents if installed), Reporting, Color, Settings.
- Settings fields: name, Customer, Tags, Company, Project Manager, Planned Date, Allocated Hours, Favorite (My Favorites filter). Further options on the Settings tab depend on installed apps.
- Feature switches under Settings tab > Tasks Management: Sub-tasks, Recurring Tasks, Task Dependencies, Milestones (verify exact set in 17.0). Timesheets/Billable switches: verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/services/project/project_management.html
- Top bar sliders / dashboard record chooser and custom buttons via Save View (+ Shared): verify availability in 17.0.

## Reusing a project structure (no native templates in 17)
- Native project templates (Convert to Template, Project Roles on template tasks, schedule-delta reapplication) are newer than 17; do not promise them (verify before advising).
- Duplicate a model project from its card menu: copies settings, stages and tasks; set the new name, customer and dates afterwards and review task assignees and deadlines.
- For sales-driven projects, set a Project Template on the service product (Create on Order "Project & Task"): confirming the SO duplicates that project (verify field name and behavior in 17.0).

## Tasks
- Create: plus (top-left = first stage; beside a stage = that stage), or New in list/Gantt. Fields: Title, priority star, Project, Assignees, Tags, Customer and Sales Order Item (billable projects only), Allocated Time, Deadline.
- Kanban title shortcuts: `5h` allocated, `#tag`, `@user`, `!` high priority (order: name, time, tags, assignee, priority); verify in 17.0.
- Email alias: project Settings > Settings tab > "Create tasks by sending an email to" (prefix, Domain, Accept Emails From). Sender -> Customer, subject -> title, body -> description.
- Website form creation: not confirmed (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/services/project/tasks/task_creation.html).

## Stages vs statuses
- Stages = Kanban columns, project-specific by default, shareable (stage Edit > Projects). Check whether the target DB pre-creates default stages for a new project (verify in 17.0).
- Stage cog: Fold, Edit (Name, SMS/Email Template notifying the customer on arrival, Folded in Kanban, Projects, Automations), Delete, Archive/Unarchive all tasks. Automations activates Studio (plan/pricing impact).
- Statuses (fixed, 5; introduced with the task status field in 17.0): In Progress (default), Changes Requested, Approved, Canceled, Done. Changes Requested/Approved clear on stage move; Done/Canceled are stage-independent and close the task; reopen by changing status.

## Subtasks
- Parent task > Sub-tasks tab > Add a line (default columns Title, Priority, Status, Assignees; sliders to change). Smart button shows total and closed (done/canceled). Parent shows allocated time of parent + children; Timesheets tab breaks down both. Subtasks can nest. A subtask with a Project shows in that project's Kanban. If the tab is missing, enable the Sub-tasks switch on the project.

## Dependencies
- Enable Task Dependencies. Successor task > Blocked by tab > Add a line; or drag dot to dot in Gantt. A blocked successor should not advance until predecessors are Approved/Canceled/Done; a dedicated Waiting status may be newer than 17.0, so check how blocked tasks are flagged (verify in 17.0). Predecessor has a Blocked Tasks smart button.

## Recurring tasks
- Enable Recurring Tasks; task Recurrent button next to Deadline; set Repeat Every. Next task is created when the previous is Done/Canceled, in the first stage; deadline shifts by the interval.
- Copied: name, description, project, assignees, customer, tags. Not copied: milestones, timesheets, chatter, activities, subtasks. Edit the last task in the chain to change future ones; stop via its Recurrent button. Option list/limits: verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/services/project/tasks/recurring_tasks.html

## Milestones
- Enable Milestones (auto-enabled for projects created from an SO with a service invoiced by milestone). Fields: Name, Deadline, Sales Order Item, Quantity (%) = share of ordered qty delivered when reached (verify the Quantity % field in 17.0). Link via the task Milestone field. Reached automatically when all linked tasks are Done/Canceled, or manually via the Reached checkbox (tasks unchanged). Gantt: diamond on deadline (red if missed).

## Pitfalls
- Missing tab/field: feature switch off in that project. Duplicating a project copies tasks: clean up assignees and dates. Recurrence does not carry timesheets or subtasks.
