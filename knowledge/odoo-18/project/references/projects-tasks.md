# Projects, tasks, stages (Odoo 18)

Sources (confirmed): https://www.odoo.com/documentation/18.0/applications/services/project/project_management.html ; https://www.odoo.com/documentation/18.0/applications/services/project/tasks/task_stages_statuses.html ; .../tasks/task_creation.html ; .../tasks/recurring_tasks.html ; .../tasks/sub-tasks.html ; .../tasks/task_dependencies.html ; .../project/project_management/project_milestones.html ; .../project_management/project_templates.html

## Projects
- Create: Project app > Create > Name > Create Project. Card menu (vertical ellipsis): View (Tasks, Milestones, Project Updates; Documents if installed), Reporting, Color, Settings.
- Settings fields: name, Customer, Tags, Company, Project Manager, Planned Date, Allocated Hours, Favorite (My Favorites filter). Further options on the Settings tab depend on installed apps.
- Feature switches under Settings tab > Tasks Management: Recurring Tasks, Task Dependencies, Milestones. Timesheets/Billable switches: verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/services/project/project_management.html
- Top bar sliders button: choose records shown (timesheets, SOs, invoices, documents, dashboard); custom buttons via Save View (+ Shared).

## Project templates
- Availability caveat: Convert to Template, the Project Templates menu and Project Roles are documented for the newer release; confirm they exist on 18 before advising (verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/services/project/project_management/project_templates.html). Fallback on 18: duplicate a project (keep a clean source project) or use the service product's Project Template field (verify) so a sale copies a project.
- Convert an existing project: Settings > cog > Convert to Template. Copies stages, tasks, subtasks and settings; ARCHIVES the original (duplicate first). Planned dates are not saved on conversion; set them on the template afterwards.
- Use: Projects > New > Project Templates > click template; set name, Customer, Planned Date, task email; Create Project.
- Project Roles on template tasks: assign people per role at creation; matching tasks go to them.
- Scheduling: the delta between project start and first scheduled task is reapplied; end dates respect dependencies, availability, schedules, time off, holidays.

## Tasks
- Create: plus (top-left = first stage; beside a stage = that stage), or New in list/Gantt. Fields: Title, priority star, Project, Assignees, Tags, Customer and Sales Order Item (billable projects only), Allocated Time, Deadline.
- Kanban title shortcuts: `5h` allocated, `#tag`, `@user`, `!` high priority (order: name, time, tags, assignee, priority).
- Email alias: project Settings > Settings tab > "Create tasks by sending an email to" (prefix, Domain, Accept Emails From). Sender -> Customer, subject -> title, body -> description.
- Website form creation: not confirmed (verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/services/project/tasks/task_creation.html).

## Stages vs statuses
- Stages = Kanban columns, project-specific by default, shareable (stage Edit > Projects). No defaults shipped.
- Stage cog: Fold, Edit (Name, SMS/Email Template notifying the customer on arrival, Folded in Kanban, Projects, Automations), Delete, Archive/Unarchive all tasks. Automations activates Studio (plan/pricing impact).
- Statuses (fixed, 5): In Progress (default), Changes Requested, Approved, Canceled, Done. Changes Requested/Approved clear on stage move; Done/Canceled are stage-independent and close the task; reopen by changing status.

## Subtasks
- Parent task > Sub-tasks tab > Add a line (default columns Title, Priority, Status, Assignees; sliders to change). Smart button shows total and closed (done/canceled). Parent shows allocated time of parent + children; Timesheets tab breaks down both. Subtasks can nest. A subtask with a Project shows in that project's Kanban.

## Dependencies
- Enable Task Dependencies. Successor task > Blocked by tab > Add a line; or drag dot to dot in Gantt. Successor shows Waiting and cannot go In Progress until predecessors are Approved/Canceled/Done. Predecessor has a Blocked Tasks smart button.

## Recurring tasks
- Enable Recurring Tasks; task Recurrent button next to Deadline; set Repeat Every. Next task is created when the previous is Done/Canceled, in the first stage; deadline shifts by the interval.
- Copied: name, description, project, assignees, customer, tags. Not copied: milestones, timesheets, chatter, activities, subtasks. Edit the last task in the chain to change future ones; stop via its Recurrent button. Option list/limits: verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/services/project/tasks/recurring_tasks.html

## Milestones
- Enable Milestones (auto-enabled for projects created from an SO with a service invoiced by milestone). Fields: Name, Deadline, Sales Order Item, Quantity (%) = share of ordered qty delivered when reached. Link via the task Milestone field. Reached automatically when all linked tasks are Done/Canceled, or manually via the Reached checkbox (tasks unchanged). Gantt: diamond on deadline (red if missed).

## Pitfalls
- Missing tab/field: feature switch off in that project. Converting to template archives the source. Recurrence does not carry timesheets or subtasks.
