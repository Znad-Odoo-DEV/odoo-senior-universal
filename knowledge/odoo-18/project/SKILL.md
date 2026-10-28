---
name: project
description: Senior Odoo 18 Project and Timesheets expertise. Use for Odoo 18 Project — projects and tasks, stages and workflow, timesheets, planning, task scheduling, project profitability, and team collaboration.
---

# Odoo 18 Project & Timesheets (senior)

## Mindset
- Project is a delivery-and-cost engine, not a to-do list. Decide first: internal project, or billable project that feeds Sales (SO item, invoicing policy) and profitability (analytic account).
- Model the workflow before the data: stages (per project or shared) express the process; statuses (fixed) express state within a stage.
- Every optional feature is a per-project switch (project Settings tab > Tasks Management / Timesheets / etc.). Check the switch before diagnosing "missing" fields, tabs or buttons.
- Prefer standard configuration over code: stage templates/automations, project templates (verify availability on 18), milestones, recurring tasks, dependencies.
- Measure with what the app already links: timesheets -> analytic lines -> profitability panel. Do not build parallel cost tracking.

## Principles
1. Stages: Odoo ships none; create them right after the project. Share stages across projects with the same workflow (stage Edit > Projects).
2. Statuses are fixed: In Progress, Changes Requested, Approved, Canceled, Done. Changes Requested/Approved reset on stage change; Done/Canceled close the task regardless of stage.
3. Visibility is a security decision: private (invited internal users), all internal users, or public (invited portal + internal; default). Sharing/collaborators require public visibility.
4. Timesheets: users must be employees; time is loggable only on projects with Timesheets enabled. Access levels: No access / own / all / Administrator.
5. T&M billing chain: service product (Invoicing Policy "Based on Timesheets", Create on Order "Project & Task" or "Task") -> SO confirm -> task with SO item -> timesheets -> delivered qty -> invoice.
6. Profitability only counts records linked to BOTH the project and its analytic account. Missing link = missing number.
7. Subtasks decompose work (parent/child); dependencies ("Blocked by") force order via Waiting status; milestones gate milestone-based invoicing.
8. Recurring tasks spawn the next task only when the previous is Done/Canceled; they copy name, description, project, assignees, customer, tags; not timesheets, chatter, activities, subtasks, milestones.
9. Planning (shifts on resources/roles, Gantt) is a separate app that links shifts to projects; the project dashboard shows Planned hours vs timesheet hours.
10. Time off becomes timesheet entries on a configured project/task (default Internal / Time Off) once enabled in Timesheets settings (developer mode).

## Workflow for a request
1. Clarify: internal vs billable, who sees it, who logs time, how it is invoiced.
2. Configure project switches, stages, visibility; then products/SO link if billable.
3. Verify end to end with a test task + timesheet entry; check the profitability panel and invoice flow.
4. Flag anything not confirmed in 18.0 docs rather than asserting it.

## References
- references/projects-tasks.md: projects, templates, tasks, subtasks, stages/statuses, recurring, dependencies, milestones.
- references/timesheets.md: access, logging methods, time off, billing link, billing-rate indicators, validation caveats.
- references/planning-scheduling.md: Planning app shifts/roles/Gantt, task dates, template scheduling.
- references/profitability.md: revenue/cost panel, columns, SO and analytic links.
- references/collaboration.md: activities, chatter, sharing, portal, email alias.

Docs roots: https://www.odoo.com/documentation/18.0/applications/services/project.html and https://www.odoo.com/documentation/18.0/applications/services/timesheets.html
