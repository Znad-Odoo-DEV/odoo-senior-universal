# Go-live: cutover and hypercare

_20.0 doc pages could not be fetched when this was adapted: URLs follow the 19.0 layout (verify in 20.0 docs)._

## Cutover plan (runbook)
Each task: id, description, owner, start/end, duration (measured in the mock cutover), dependency, verification, rollback step.
1. T-4 weeks: cutover date fixed at a period end; freeze calendar published; mock cutover scheduled.
2. T-2 weeks: final dry run with timing; reconciliation pack signed; production prepared (hosting, Python 3.12 / PostgreSQL 16 runtime if on-premise, mail servers/domains, users, access, printers, integration credentials, scheduled actions).
3. T-1 week: training done; support rota set; go/no-go pre-review; communication to staff, customers, vendors.
4. Freeze: legacy transactions stop (or delta captured); customization freeze on production.
5. Backup of the configured production baseline; restore path verified.
6. Final load in dependency order (data-migration.md); validate counts and totals; accountant confirms opening balances (bank balances loaded as bank transactions in 20); set lock dates.
7. Enable integrations and outgoing mail; switch DNS/links/portal if relevant; verify scheduled actions and e-invoicing connectivity (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/fiscal_localizations.html). Integrations must authenticate against JSON-2 (`/json/2/<model>/<method>`); XML-RPC and JSON-RPC are deprecated in 20.
8. Smoke test with key users: a sale, a purchase, a receipt, an invoice, a payment, a bank transaction reconciliation, an expense (draft vendor bill), a report.
9. Go/no-go decision; announce; open to all users.

## Go/no-go checklist
- UAT signed; no open blockers.
- Final load reconciled; opening balances approved.
- Users, roles, authentication policy in place.
- Backups running and a restore tested.
- Production is not neutralized; staging is (no cross-sending of mail).
- Mail works: outgoing/incoming servers, SPF/DKIM, aliases (on-premise email gateway: https://www.odoo.com/documentation/20.0/administration/on_premise/email_gateway.html).
- Subscription valid (on-premise: code entered via the dashboard banner).
- Every third-party/OCA module in production has a 20.0 release (as of 2026-09-24 OCA had no 20.0 branches; re-check).
- Integrations tested on JSON-2 with API keys; none depends on the removed `db` service.
- Support rota, escalation path, hypercare plan published.
- Rollback decision point defined: last step we can return to legacy, who decides, what is lost.

## Rollback
Define the point of no return (usually once real external documents are sent or posted). Before it: restore the pre-load backup and resume legacy. After it: fix forward only, with an agreed emergency-change procedure.

## Hypercare
- Duration typically 2-6 weeks, covering the first month-end close; exit criteria agreed up front.
- Daily triage: bug, configuration, data, training, new request. Publish a daily known-issues list.
- Fix path: reproduce on staging, fix, test, promote with backup (environments.md). Log emergency fixes and back-port them.
- Monitor: scheduled actions, mail queue, failed e-invoices, failed integration calls, stock and accounting reconciliations, performance, user errors by topic.
- First close: reconcile subledgers to GL, stock valuation to accounting, taxes; review with the accountant.
- Exit: backlog under threshold, no blockers, stable ticket trend, runbooks handed to support, consultant access reviewed, lessons-learned session held.

## After go-live
- Roadmap for wave 2 and enhancements with prioritization.
- Upgrade plan: track the support lifecycle and request test upgrades before deadlines (https://www.odoo.com/documentation/20.0/administration/upgrade.html , https://www.odoo.com/documentation/20.0/administration/supported_versions.html ; the 19.0 layout also had https://www.odoo.com/documentation/20.0/administration/standard_extended_support.html ; verify in 20.0 docs which exists). Standard support ends 19.0 Sept 2028, 18.0 Sept 2027; 17.0 ended Sept 2026. Enterprise databases older than the 3 latest majors can be charged +25% (no earlier than 6 months after a new major).
- Before the next major, re-check the OCA/third-party ecosystem for the target version and the runtime requirements (Python / PostgreSQL).
- Periodic review: unused customizations, access rights, backup restores, data quality.
