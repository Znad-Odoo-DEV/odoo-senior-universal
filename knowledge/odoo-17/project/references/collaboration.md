# Collaboration (Odoo 17)

Sources (19.0 layout, version swapped; verify paths in 17.0): https://www.odoo.com/documentation/17.0/applications/services/project/project_management.html ; https://www.odoo.com/documentation/17.0/applications/services/project/tasks/task_creation.html ; https://www.odoo.com/documentation/17.0/applications/services/project/tasks/task_stages_statuses.html

## Visibility and sharing
- Visibility: Invited internal users (private: followers + Project Administrators); All internal users; Invited portal users and all internal users (public, default; portal users see only tasks they follow).
- Share Project (needs public visibility): Public Link (read-only) or collaborators with modes Read, Edit with limited access (followed tasks), Edit (all tasks). Optional email invitation; revoke with the trash icon. Verify the collaborator modes in 17.0.
- Internal users can open a task by shared URL; private projects still require follower status on the task.

## Activities and followers
- Schedule on a project: clock icon > + Schedule an activity (Activity Type, Summary, Due Date, assignee). Same pattern on tasks via chatter.
- Follower status drives portal visibility and private-project access. Chatter detail page not fetched (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/productivity/discuss.html).

## Customer communication
- Stage SMS/Email Template: automatic notification when a task enters the stage.
- Project email alias creates tasks from incoming mail (restrict with Accept Emails From).
- Stage Automations: create activities, add followers, webhooks (activates Studio).
- Customer ratings: a per-project switch exists in 17 (Customer Ratings); details not confirmed here (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/services/project.html).

## Team workflow tips
- Kanban inline edits (priority, allocated hours, assignees, status) and title shortcuts speed intake.
- Changes Requested/Approved statuses model review loops with customers or internal reviewers.
- Saved custom views (Shared) give each team a one-click filtered view (verify availability in 17.0).

## Pitfalls
- Collaborator sharing needs public visibility; switching to private removes that option. Portal users only see tasks they follow.
