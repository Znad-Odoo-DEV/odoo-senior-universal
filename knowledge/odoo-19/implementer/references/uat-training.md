# UAT and training

## UAT preparation
- Environment: staging with production-like migrated data from the latest dry run, neutralized (no outgoing mail or integrations). See environments.md.
- Entry criteria: configuration complete, internal testing passed, test users and roles created, data loaded, scripts approved.
- Scripts: end-to-end by business scenario, not by menu. Each: id, role, preconditions, steps, expected result, data, pass/fail, evidence, tester, date.
- Cover: quote-to-cash, procure-to-pay, manufacturing, inventory counts and returns, month-end close, tax and e-invoicing, reports and print layouts, access rights (positive and negative), integrations, portal/website flows, performance at realistic volumes.
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
- Material: one-page process cards, step-by-step guides showing your configuration, short videos, FAQ. For standard features link the user docs: https://www.odoo.com/documentation/19.0/applications.html
- Timing: 1-3 weeks before go-live after UAT sign-off, with a refresher in go-live week.
- Check competence with a practical exercise per role; record attendance.
- Support model: key users first line, project team second, Odoo/partner support for product issues; publish the ticket channel and response targets.

## Adoption
- Sponsor message with a clear rule: from date X, only Odoo.
- Floor-walkers in week 1; a daily 15-minute issue stand-up.
- Track logins, documents created per app, ticket volume and top topics.
