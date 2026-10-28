# Go-live: cutover and hypercare

## Cutover plan (runbook)
Each task: id, description, owner, start/end, duration (measured in the mock cutover), dependency, verification, rollback step.
1. T-4 weeks: cutover date fixed at a period end; freeze calendar published; mock cutover scheduled.
2. T-2 weeks: final dry run with timing; reconciliation pack signed; production prepared (hosting, mail servers/domains, users, access, printers, integration credentials, scheduled actions).
3. T-1 week: training done; support rota set; go/no-go pre-review; communication to staff, customers, vendors.
4. Freeze: legacy transactions stop (or delta captured); customization freeze on production.
5. Backup of the configured production baseline; restore path verified.
6. Final load in dependency order (data-migration.md); validate counts and totals; accountant confirms opening balances; set lock dates.
7. Enable integrations and outgoing mail; switch DNS/links/portal if relevant; verify scheduled actions and e-invoicing connectivity (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/finance/fiscal_localizations.html).
8. Smoke test with key users: a sale, a purchase, a receipt, an invoice, a payment, a report.
9. Go/no-go decision; announce; open to all users.

## Go/no-go checklist
- UAT signed; no open blockers.
- Final load reconciled; opening balances approved.
- Users, roles, authentication policy in place.
- Backups running and a restore tested.
- Production is not neutralized; staging is (no cross-sending of mail).
- Mail works: outgoing/incoming servers, SPF/DKIM, aliases (on-premise email gateway: https://www.odoo.com/documentation/17.0/administration/on_premise/email_gateway.html).
- Subscription valid (on-premise: code entered via the dashboard banner).
- Support rota, escalation path, hypercare plan published.
- Rollback decision point defined: last step we can return to legacy, who decides, what is lost.

## Rollback
Define the point of no return (usually once real external documents are sent or posted). Before it: restore the pre-load backup and resume legacy. After it: fix forward only, with an agreed emergency-change procedure.

## Hypercare
- Duration typically 2-6 weeks, covering the first month-end close; exit criteria agreed up front.
- Daily triage: bug, configuration, data, training, new request. Publish a daily known-issues list.
- Fix path: reproduce on staging, fix, test, promote with backup (environments.md). Log emergency fixes and back-port them.
- Monitor: scheduled actions, mail queue, failed e-invoices, stock and accounting reconciliations, performance, user errors by topic.
- First close: reconcile subledgers to GL, stock valuation to accounting, taxes; review with the accountant.
- Exit: backlog under threshold, no blockers, stable ticket trend, runbooks handed to support, consultant access reviewed, lessons-learned session held.

## After go-live
- Roadmap for wave 2 and enhancements with prioritization.
- Upgrade plan: track the support lifecycle and request test upgrades before deadlines (https://www.odoo.com/documentation/17.0/administration/upgrade.html , https://www.odoo.com/documentation/17.0/administration/standard_extended_support.html).
- Periodic review: unused customizations, access rights, backup restores, data quality.
