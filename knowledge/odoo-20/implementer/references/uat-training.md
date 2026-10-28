# UAT and training

_URLs follow the 19.0 layout; 20.0 pages could not be fetched when this was adapted (verify in 20.0 docs)._

## UAT preparation
- Environment: staging with production-like migrated data from the latest dry run, neutralized (no outgoing mail or integrations). See environments.md.
- Entry criteria: configuration complete, internal testing passed, test users and roles created, data loaded, scripts approved.
- Scripts: end-to-end by business scenario, not by menu. Each: id, role, preconditions, steps, expected result, data, pass/fail, evidence, tester, date.
- Cover: quote-to-cash, procure-to-pay, manufacturing, inventory counts and returns, month-end close, tax and e-invoicing, reports and print layouts, access rights (positive and negative), integrations, portal/website flows, performance at realistic volumes.
- Cover the Odoo 20 process changes that apply to the scope (verify each flow in 20.0 docs): bank transactions and reconciliation (bank-impacting entries originate from bank transactions), expense to draft vendor bill to payment, payslip generation without work entries, scheduling on-site work in Planning (Field Service is discontinued), batch/wave picking in core `stock`, reports and filters affected by parent accounts (instead of account groups) and renamed payment statuses, VAT-number and IBAN validation (`base_vat` / `base_iban` removed), and access rules after the move to `ir.access`.
- Integration scripts run against JSON-2 with the integration user's API key (XML-RPC/JSON-RPC are deprecated in 20).
- Test as the real user profile, not as admin.

## Execution and defects
- Severity: blocker (cannot operate), major (workaround exists, high impact), minor, cosmetic.
- Triage twice weekly: bug (fix), configuration (fix), training issue, new requirement (change request, not a defect).
- Retest every fix in staging; keep a regression subset.
- Exit criteria example: all critical scripts executed; no open blockers; majors with approved workaround; written sign-off by business owners.

## Parallel run / mock cutover
For finance-critical scopes, run a month-end close in parallel, or a full mock cutover including final-load timing and reconciliation.

## Training plan
- Audience matrix: role, apps, processes, language, location, level.
- Key users first (they ran UAT), then they co-deliver end-user sessions. Role-based and hands-on on a training database with realistic data (a neutralized duplicate, reset before each session).
- Users coming from an older version need a "what changed in 20" session per role: accounting (bank transactions, parent accounts, payment statuses), employees and managers (expenses as draft vendor bills), payroll (no work entries), field teams and dispatchers (Planning instead of Field Service).
- Material: one-page process cards, step-by-step guides showing your configuration, short videos, FAQ. For standard features link the user docs: https://www.odoo.com/documentation/20.0/applications.html
- Timing: 1-3 weeks before go-live after UAT sign-off, with a refresher in go-live week.
- Check competence with a practical exercise per role; record attendance.
- Support model: key users first line, project team second, Odoo/partner support for product issues; publish the ticket channel and response targets.

## Adoption
- Sponsor message with a clear rule: from date X, only Odoo.
- Floor-walkers in week 1; a daily 15-minute issue stand-up.
- Track logins, documents created per app, ticket volume and top topics.
