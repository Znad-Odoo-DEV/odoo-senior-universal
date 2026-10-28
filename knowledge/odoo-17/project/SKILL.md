---
name: project
description: Senior Odoo 17 Project and Timesheets expertise. Use for Odoo 17 Project — projects and tasks, stages and workflow, timesheets, planning, task scheduling, project profitability, and team collaboration.
---

# Odoo 17 Project & Timesheets (senior)

## Mindset
- Project is a delivery-and-cost engine, not a to-do list. Decide first: internal project, or billable project that feeds Sales (SO item, invoicing policy) and profitability (analytic account).
- Model the workflow before the data: stages (per project or shared) express the process; statuses (fixed) express state within a stage.
- Every optional feature is a per-project switch (project Settings tab > Tasks Management / Timesheets / etc.). Check the switch before diagnosing "missing" fields, tabs or buttons.
- Prefer standard configuration over code: stage templates/automations, duplicating a model project, milestones, recurring tasks, dependencies. Native project templates and project roles are newer than 17 (verify).
- Measure with what the app already links: timesheets -> analytic lines -> profitability panel. Do not build parallel cost tracking.

## Principles
1. Stages: create them right after the project (verify in 17.0 whether default stages are pre-created). Share stages across projects with the same workflow (stage Edit > Projects).
2. Statuses are fixed: In Progress, Changes Requested, Approved, Canceled, Done. Changes Requested/Approved reset on stage change; Done/Canceled close the task regardless of stage.
3. Visibility is a security decision: private (invited internal users), all internal users, or public (invited portal + internal; default). Sharing/collaborators require public visibility.
4. Timesheets: users must be employees; time is loggable only on projects with Timesheets enabled. Access levels: No access / own / all / Administrator.
5. T&M billing chain: service product (Invoicing Policy "Based on Timesheets", Create on Order "Project & Task" or "Task") -> SO confirm -> task with SO item -> timesheets -> delivered qty -> invoice.
6. Profitability only counts records linked to BOTH the project and its analytic account. Missing link = missing number.
7. Subtasks decompose work (parent/child; a per-project Sub-tasks switch may apply, verify); dependencies ("Blocked by") force order; milestones gate milestone-based invoicing.
8. Recurring tasks spawn the next task only when the previous is Done/Canceled; they copy name, description, project, assignees, customer, tags; not timesheets, chatter, activities, subtasks, milestones.
9. Planning (shifts on resources/roles, Gantt; Enterprise) is a separate app that links shifts to projects; the project dashboard shows Planned hours vs timesheet hours.
10. Time off becomes timesheet entries on a configured project/task (default Internal / Time Off) once enabled in Timesheets settings (developer mode, verify).
11. Reuse: to repeat a project structure, duplicate a model project, or set a Project Template on a service product (Create on Order "Project & Task") so confirming the SO copies it.

## Workflow for a request
1. Clarify: internal vs billable, who sees it, who logs time, how it is invoiced.
2. Configure project switches, stages, visibility; then products/SO link if billable.
3. Verify end to end with a test task + timesheet entry; check the profitability panel and invoice flow.
4. Flag anything not confirmed in 17.0 docs rather than asserting it.

## References
- references/projects-tasks.md: projects, reuse/duplication, tasks, subtasks, stages/statuses, recurring, dependencies, milestones.
- references/timesheets.md: access, logging methods, time off, billing link, billing-rate indicators, validation caveats.
- references/planning-scheduling.md: Planning app shifts/roles/Gantt, task dates.
- references/profitability.md: revenue/cost panel, columns, SO and analytic links.
- references/collaboration.md: activities, chatter, sharing, portal, email alias.

Docs roots: https://www.odoo.com/documentation/17.0/applications/services/project.html and https://www.odoo.com/documentation/17.0/applications/services/timesheets.html
(Deep-page paths in the references follow the 19.0 docs layout with the version swapped; verify they resolve in 17.0.)
