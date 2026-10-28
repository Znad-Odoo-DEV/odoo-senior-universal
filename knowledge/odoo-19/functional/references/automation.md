# Automation, Scheduled Actions, Studio-light, Email, Approvals (Odoo 19)

Docs: Studio https://www.odoo.com/documentation/19.0/applications/studio.html (automations: verify page in 19.0 docs https://www.odoo.com/documentation/19.0/applications/studio.html); Email https://www.odoo.com/documentation/19.0/applications/general/email_communication.html

## 1. Automation Rules (base.automation)
Where: Settings > Technical > Automation > Automation Rules (developer mode) — or Studio > Automations. Available in Community via technical menu; some low-code (Studio) UI in Enterprise.
Anatomy:
- **Model** (Target model).
- **Trigger** families: *Values updated* (field set/changed, stage set, user set, tag added, state set, priority set), *On creation / On creation and update / On deletion*, *Based on date field* (date + delay before/after, with calendar), *On timer / Based on a form* (e.g. "email received/sent", "rating", "webhook", "UI change"). Exact list of trigger names changed across versions — verify in 19.0 docs.
- **Before Update Domain** (state before) and **Apply on** domain (state after) to restrict records.
- **Actions** (ir.actions.server): Update Record, Create Record, Send Email (template), Send SMS, Add Followers, Create Activity, Execute Code (Python — developer; avoid for no-code), Multi-action (several actions in order), Send Webhook Notification.
Design tips:
- Make the domain precise to avoid loops (rule that writes the field it watches).
- Test on one record with logging in chatter; disable rule instead of deleting while testing.
- Order of rules = sequence; rules run in the user context of the trigger (sudo or not depends on config). Check access rights for the action target.
- Prefer a trigger on stage change over polling by timer.
Typical recipes:
- Assign salesperson/team on lead creation by country.
- Create an activity "Call customer" when opportunity enters stage Proposal.
- Email vendor when PO delivery date is overdue (date-based trigger).
- Tag overdue invoices 30 days after due date.
- Notify manager when expense > threshold.

## 2. Server Actions & Actions menu
Settings > Technical > Actions > Server Actions. Types: Update Record, Create Record, Send Email, Send SMS, Add Followers, Create Activity, Execute Code, Multi-Action, Webhook. Bindable to a model's **Action** menu for manual bulk use (button "Create Contextual Action"). Run from automation rules, scheduled actions, or manually.

## 3. Scheduled Actions (ir.cron)
Settings > Technical > Automation > Scheduled Actions. Fields: action to run (server action), interval (number+unit), next execution date, user, priority/sequence, active.
Functional notes: Odoo.sh/Online run crons automatically; Online has restricted custom code. Common standard crons: mail queue, stock scheduler, recurring invoices, currency rates, partner autocomplete. Do not disable crons without understanding impact. Staging databases neutralized disable crons/mail.

## 4. Email & Messaging
- **Email templates**: Settings > Technical > Email > Templates (or "Dynamic Placeholders"): subject/body with QWeb/inline placeholders (`{{ object.partner_id.name }}` inline-template syntax; body uses QWeb), attachments (report), sender/to/cc, language (`{{ object.partner_id.lang }}`), scheduled send. Use "Preview" with a record. Template `Use template` in document send wizards.
- **Aliases & catchall**: each team/project/helpdesk has an email alias to create records. Configure alias domain (Settings > General Settings > Discuss) and DNS (MX to Odoo/IMAP).
- **Chatter**: Send message vs Log note; followers and subtypes decide who is notified; activities (schedule + done + feedback) are the lightweight task layer. Activity types: Settings > Technical > Discuss > Activity Types with default assignee/delay and chaining.
- **Mass mailing / Marketing Automation (Enterprise)**: campaigns with triggers by date/event, activities (email/SMS/server action), filters per workflow. Marketing Automation docs: https://www.odoo.com/documentation/19.0/applications/marketing/marketing_automation.html
- **SMS**: IAP credits; templates parallel email.

## 5. Approvals
Choose lightest mechanism that meets control needs:
| Need | Mechanism |
|---|---|
| PO over amount | Purchase settings > Purchase Order Approval (threshold, approver group) |
| SO over amount/discount | Sales settings > Sales Order approval (verify option name in 19.0 docs) |
| Expense / Time Off | Approver on employee + validation type on Time Off type |
| Vendor bill/payment | Accounting approval (Studio approvals on a button, Enterprise); bill “Post” restricted by group |
| Generic requests (travel, equipment, payment) | **Approvals** app (Enterprise): categories, approvers (users/managers, minimum approvals, required), request fields (date, amount, partner, product…), links to purchase/payment where configured |
| Custom button approval | **Studio approval rules** on a button/action: per-model rule with approver group/user, domain, notification, "approve/refuse" in chatter. Lighter than workflow code. |
Docs: https://www.odoo.com/documentation/19.0/applications/productivity.html ; Studio approval rules: https://www.odoo.com/documentation/19.0/applications/studio/approval_rules.html (verify page in 19.0 docs)

## 6. Studio-light (Enterprise, no code)
Studio (app icon or toolbar) edits views and models via UI. Practical scope:
- Add fields (text, selection, many2one, related, computed via formula-like **related** fields), place on form/list, make required/readonly/invisible by conditions.
- Create new apps/models with menus, views (form, list, kanban, calendar, pivot, graph, map, cohort, gantt, dashboard).
- Export/Import customizations; each Studio change creates a customization module "Studio Customizations" (tracked; export for deployment).
- Reports: edit PDF layouts (QWeb) visually; add/hide columns.
- Automations: UI for automation rules; Approvals: approval rules.
- Limits: no complex business logic without server actions/Python; Studio fields are prefixed `x_`; avoid editing core fields heavily; view inheritance can break after upgrades—review after upgrade.
- Studio is not available on Community. For Community use developer mode: Settings > Technical > Views/Models/Fields (Custom fields via Technical > Database Structure > Fields, `x_` fields) — fragile; prefer a module.
Docs: https://www.odoo.com/documentation/19.0/applications/studio.html

## 7. Other no-code automation points
- **Stages with automation**: stage > "Automated Actions"/email template per stage (e.g. Helpdesk, Recruitment, Project: stage email template).
- **Server action "Create Activity"** + **Activity plans** (Employees > Configuration > Activity Plans) for onboarding/offboarding checklists.
- **Reordering rules** & **MTO** = automatic procurement; **Auto-invoicing** of subscriptions; **Follow-up** on invoices (Accounting > Customers > Payment Follow-ups; verify v19 wording).
- **Webhooks**: automation action "Send Webhook Notification" posts record JSON to an external URL (verify in 19.0 docs). Inbound: Settings > Technical > Webhooks? not standard; use external API (needs developer).
- **Validation/constraints**: required fields via Studio; unique via SQL constraint (developer).

## 8. Governance
Document each rule (trigger, domain, action, owner), name with a convention (e.g., `[CRM] Assign by country`), keep rules active/inactive consciously, test in staging, review after upgrades (field/state renames break domains).
