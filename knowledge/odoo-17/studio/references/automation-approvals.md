# Automation, webhooks, approvals (Studio, Odoo 17)
Docs: https://www.odoo.com/documentation/17.0/applications/studio/automated_actions.html , https://www.odoo.com/documentation/17.0/applications/studio/automated_actions.html , https://www.odoo.com/documentation/17.0/applications/studio/approval_rules.html (verify sub-page paths resolve in 17.0)

## Automation rules (Automated Actions in 17)
- Naming: Odoo 17 labels these "Automated Actions" (Settings > Technical > Automation); the "Automation Rules" name and the regrouped trigger list come with later versions (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/studio/automated_actions.html).
- Triggers (17, model-dependent): On Creation, On Update, On Creation & Update, On Deletion, Based on Form Modification (onchange), Based on Timed Condition, and incoming webhook where available. The grouped triggers (Values Updated, Email Events, Timing Conditions, Custom, External) with stage/tag/user/priority/email-received triggers are an 18+ layout; check which exist on the instance.
- Filters: **Before Update Domain** (state before trigger; not checked on creation) and **Apply on** domain (state after trigger; only matches get the action). Example: "Email is not set" before + "Email is set" after fires on first set only. Full domain editing needs developer mode. In 17 domains are lists of tuples.
- Actions (Action To Do): Update the Record, Create Activity, Send Email, Send SMS Text Message, Add/Remove Followers, Create a new Record, Execute Python Code, Execute several actions, and (verify availability in 17.0 docs) Send WhatsApp and Send Webhook Notification. Update the Record sets a value, a reference or a Python equation per field (the 18/19 Sequence and Compute options may not be offered; verify in 17.0 docs), or fall back to Execute Python Code.
- Timing: the scheduled action "Base Automation: check and execute" runs periodically (every 4h by default; verify in 17.0 docs whether the frequency self-adjusts for short delays, which is documented for later versions). Delay in minutes/hours/days/months, before or after the date field (Trigger Date, Delay, optional Use Calendar). Runs only when execution time falls between last run and current run.
- **Time-based rules can fire retroactively on history.** In later versions a "Run manually" button sets last-run once; in 17 check the Last Run field in developer mode (verify in 17.0 docs) and bound the Apply on domain (for example create date after go-live). Time-based config needs developer mode.
- Use the Notes tab to document purpose. To change target model: switch model first or edit in developer mode.
- Practice: prefer Update/Create Activity/Send Email over Execute Python Code; keep code short and in Odoo 17 idiom (`_()` for translations, `check_access_rights`/`check_access_rule`, list-of-tuples domains, `groups_id`); guard against a rule re-triggering itself with Before Update Domain.

## Webhooks (incoming)
Verify incoming-webhook support and menu names in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/studio/automated_actions.html . In 17 the external API for custom clients is XML-RPC (`/xmlrpc/2/common`, `/xmlrpc/2/object`) and JSON-RPC (`/jsonrpc`), not `/json/2`.
- External system POSTs JSON to a generated Odoo URL; Odoo runs predefined actions. Event-driven, unlike scheduled actions.
- Setup: Studio > Webhooks > New (or Automated Actions with the webhook trigger). Name, Model (developer mode to choose), copy URL, **Rotate Secret** to replace it, optional **Log Calls**.
- Target Record code locates the record in the payload; Odoo senders must include `id` and `model`; to create records use `model.browse(i)`/`model.search(i)`. Anything other than updating an existing record (e.g., create) needs an Execute Python Code action.
- URL is confidential: sharing grants access to the database. After rotating, update the sender.
- Test (Postman): POST, raw JSON body. `200 OK`/`status: ok` = fine; `500` = field mapping problem; Logs smart button shows history if Log Calls is on. Test on a duplicate database.

## Approval rules
- Gate a **button**: in Studio select the button, Properties > "Add an approval step".
- Per step: Approvers or Approver Group (a single responsible user versus a list of approvers can differ in 17; verify in 17.0 docs); Conditions (filter icon, domain) for when the step applies; Users to Notify (internal note on approve/reject); Description (shown on button).
- Multiple steps: Approval Order (1 first; higher-step users may act on earlier steps unless Exclusive Approval) and **Exclusive Approval** (a user who approved one step cannot approve another on the same record).
- Use: avatar icon beside the button shows steps; last/only step: authorized user clicks the button; earlier steps: approve or reject via avatar. Unauthorized click errors and creates an activity for Approvers.
- Delegation (Approvers only): Delegate from kanban icon; delegates, end date (blank = indefinite), optional Notify to; applies to **all records**. Users can revoke own decisions, and others' on lower-order steps unless Exclusive. Verify delegation exists in 17.0 docs before promising it.
- Audit: decisions logged in chatter; entries at Settings > Technical > Studio Approval Entries (developer mode).
- Prefer groups over named users so staff changes do not break the flow.
