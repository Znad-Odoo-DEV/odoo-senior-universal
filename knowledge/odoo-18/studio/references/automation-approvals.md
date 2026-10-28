# Automation, webhooks, approvals (Studio, Odoo 18)
Docs: https://www.odoo.com/documentation/18.0/applications/studio/automated_actions.html , https://www.odoo.com/documentation/18.0/applications/studio/automated_actions/webhooks.html , https://www.odoo.com/documentation/18.0/applications/studio/approval_rules.html

## Automation rules
- Triggers (model-dependent): Values Updated (tag added, field set), Email Events (sent/received), Timing Conditions (before/after a date field, or after create/last update), Custom, External (Custom/External details: verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/studio/automated_actions.html).
- Filters: **Before Update Domain** (state before trigger; not checked on creation) and **Apply on** domain (state after trigger; only matches get the action). Example: "Email is not set" before + "Email is set" after fires on first set only. Full domain editing needs developer mode.
- Actions: Update Record (Update, Sequence, Compute), Create Record, Create Activity, Send Email/SMS/WhatsApp, Add/Remove Followers, Execute Code, Send Webhook Notification, Multi Actions (exact action list and labels: verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/studio/automated_actions.html).
- No AI actions: Odoo 18 has no built-in AI app, so AI-assisted update actions (a 19 addition) are not available; use Execute Code calling a custom service module instead.
- Timing: scheduled action "Automation Rules: check and execute scheduled action" runs every 4h by default; delays under ~40h raise its frequency automatically. Delay in minutes/hours/days/months, before or after the date field. Runs only when execution time falls between last run and current run.
- **Click "Run manually" after creating a time-based rule** to set last-run and avoid retroactive firing on history. Time-based config needs developer mode.
- Use the Notes tab to document purpose. To change target model: switch model first or edit in developer mode.
- Practice: prefer Update/Create Activity/Send Email over Execute Code; keep code short; guard against a rule re-triggering itself with Before Update Domain.

## Webhooks (incoming)
(Menu paths and the "On webhook" trigger label: verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/studio/automated_actions/webhooks.html)
- External system POSTs JSON to a generated Odoo URL; Odoo runs predefined actions. Event-driven, unlike scheduled actions.
- Setup: Studio > Webhooks > New (or Automations with "On webhook" trigger). Name, Model (developer mode to choose), copy URL, **Rotate Secret** to replace it, optional **Log Calls**.
- Target Record code locates the record in the payload; Odoo senders must include `id` and `model`; to create records use `model.browse(i)`/`model.search(i)`. Anything other than updating an existing record (e.g., create) needs an Execute Code action.
- URL is confidential: sharing grants access to the database. After rotating, update the sender.
- Test (Postman): POST, raw JSON body. `200 OK`/`status: ok` = fine; `500` = field mapping problem; Logs smart button shows history if Log Calls is on. Test on a duplicate database.

## Approval rules
- Gate a **button**: in Studio select the button, Properties > "Add an approval step".
- Per step: Approvers (specific users; an activity is created for each) or Approver Group; Conditions (filter icon, domain) for when the step applies; Users to Notify (internal note on approve/reject); Description (shown on button).
- Multiple steps: Approval Order (1 first; higher-step users may act on earlier steps unless Exclusive Approval) and **Exclusive Approval** (a user who approved one step cannot approve another on the same record).
- Use: avatar icon beside the button shows steps; last/only step: authorized user clicks the button; earlier steps: approve or reject via avatar. Unauthorized click errors and creates an activity for Approvers.
- Delegation (Approvers only): Delegate from kanban icon; delegates, end date (blank = indefinite), optional Notify to; applies to **all records**. Users can revoke own decisions, and others' on lower-order steps unless Exclusive.
- Audit: decisions logged in chatter; entries at Settings > Technical > Studio Approval Entries (developer mode).
- Prefer groups over named users so staff changes do not break the flow.
