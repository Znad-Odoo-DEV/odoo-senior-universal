# Collaboration (Odoo 19)

Sources (confirmed): https://www.odoo.com/documentation/19.0/applications/services/project/project_management.html ; https://www.odoo.com/documentation/19.0/applications/services/project/tasks/task_creation.html ; https://www.odoo.com/documentation/19.0/applications/services/project/tasks/task_stages_statuses.html

## Visibility and sharing
- Visibility: Invited internal users (private: followers + Project Administrators); All internal users; Invited portal users and all internal users (public, default; portal users see only tasks they follow).
- Share Project (needs public visibility): Public Link (read-only) or collaborators with modes Read, Edit with limited access (followed tasks), Edit (all tasks). Optional email invitation; revoke with the trash icon.
- Internal users can open a task by shared URL; private projects still require follower status on the task.

## Activities and followers
- Schedule on a project: clock icon > + Schedule an activity (Activity Type, Summary, Due Date, assignee). Same pattern on tasks via chatter.
- Follower status drives portal visibility and private-project access. Chatter detail page not fetched (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/productivity/discuss.html).

## Customer communication
- Stage SMS/Email Template: automatic notification when a task enters the stage.
- Project email alias creates tasks from incoming mail (restrict with Accept Emails From).
- Stage Automations: create activities, add followers, webhooks (activates Studio).
- Customer ratings: not confirmed in fetched pages (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/services/project.html).

## Team workflow tips
- Kanban inline edits (priority, allocated hours, assignees, status) and title shortcuts speed intake.
- Changes Requested/Approved statuses model review loops with customers or internal reviewers.
- Saved custom views (Shared) give each team a one-click filtered view.

## Pitfalls
- Collaborator sharing needs public visibility; switching to private removes that option. Portal users only see tasks they follow.
