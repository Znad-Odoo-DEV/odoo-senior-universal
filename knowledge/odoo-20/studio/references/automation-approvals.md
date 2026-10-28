# Automation, webhooks, approvals (Studio, Odoo 20)
Docs (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/studio/automated_actions.html , https://www.odoo.com/documentation/20.0/applications/studio/automated_actions/webhooks.html , https://www.odoo.com/documentation/20.0/applications/studio/approval_rules.html

## Automation rules
- Triggers (model-dependent): Values Updated (tag added, field set), Email Events (sent/received), Timing Conditions (before/after a date field, or after create/last update), Custom, External (Custom/External details: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/studio/automated_actions.html).
- Filters: **Before Update Domain** (state before trigger; not checked on creation) and **Apply on** domain (state after trigger; only matches get the action). Example: "Email is not set" before + "Email is set" after fires on first set only. Full domain editing needs developer mode.
- Actions: Update Record (Update, Update with AI, Sequence, Compute), Create Record, Duplicate Record, Create Activity, Send Email/SMS/WhatsApp, Add/Remove Followers, Execute Code, Send Webhook Notification, Multi Actions. Update with AI relies on the built-in AI app, which exists in 20 (provider setup: verify in 20.0 docs).
- Timing: scheduled action "Automation Rules: check and execute scheduled action" runs every 4h by default; delays under ~40h raise its frequency automatically. Delay in minutes/hours/days/months, before or after the date field. Runs only when execution time falls between last run and current run.
- **Click "Run manually" after creating a time-based rule** to set last-run and avoid retroactive firing on history. Time-based config needs developer mode.
- Use the Notes tab to document purpose. To change target model: switch model first or edit in developer mode.
- Practice: prefer Update/Create Activity/Send Email over Execute Code; keep code short; guard against a rule re-triggering itself with Before Update Domain.
- Odoo 20 code pitfalls in Execute Code: `read_group` is public with signature `(domain, groupby, aggregates, having, offset, limit, order)` and old `fields=`/`lazy=` calls break; `_check_access` is deprecated; tracking values are removed (tracking messages are built on the fly), so do not read them from automation code.
- Rules that react to Accounting states must be re-checked on 20: invoice payment statuses are renamed (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting.html).

## Webhooks (incoming)
- External system POSTs JSON to a Studio-created Odoo URL; Odoo runs predefined actions. Event-driven, unlike scheduled actions.
- Setup: Studio > Webhooks > New (or Automations with "On webhook" trigger). Name, Model (developer mode to choose), copy URL, **Rotate Secret** to replace it, optional **Log Calls**.
- Target Record code locates the record in the payload; Odoo senders must include `id` and `model`; to create records use `model.browse(i)`/`model.search(i)`. Anything other than updating an existing record (e.g., create) needs an Execute Code action.
- URL is confidential: sharing grants access to the database. After rotating, update the sender.
- Test (Postman): POST, raw JSON body. `200 OK`/`status: ok` = fine; `500` = field mapping problem; Logs smart button shows history if Log Calls is on. Test on a duplicate database.
- Do not confuse with Odoo's external API: XML-RPC/JSON-RPC are deprecated in 20 in favor of JSON-2 `/json/2/<model>/<method>` (Custom plan only); webhooks are a separate inbound mechanism (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/studio/automated_actions/webhooks.html).

## Approval rules
- Gate a **button**: in Studio select the button, Properties > "Add an approval step".
- Per step: Approvers (specific users; an activity is created for each) or Approver Group; Conditions (filter icon, domain) for when the step applies; Users to Notify (internal note on approve/reject); Description (shown on button).
- Multiple steps: Approval Order (1 first; higher-step users may act on earlier steps unless Exclusive Approval) and **Exclusive Approval** (a user who approved one step cannot approve another on the same record).
- Use: avatar icon beside the button shows steps; last/only step: authorized user clicks the button; earlier steps: approve or reject via avatar. Unauthorized click errors and creates an activity for Approvers.
- Delegation (Approvers only): Delegate from kanban icon; delegates, end date (blank = indefinite), optional Notify to; applies to **all records**. Users can revoke own decisions, and others' on lower-order steps unless Exclusive.
- Audit: decisions logged in chatter; entries at Settings > Technical > Studio Approval Entries (developer mode).
- Prefer groups over named users so staff changes do not break the flow.
- Approvals on buttons of apps that changed in 20 (expenses become draft vendor bills, payroll work entries removed, Field Service discontinued): the gated button may no longer exist; re-select it after the upgrade.
