# Fit-Gap

## Inputs
Requirement list (ID, process, description, MoSCoW priority, owner), apps in scope, edition/localization, constraints (budget, deadline, upgrade policy).

## Classification
- FIT-STD: standard works as is.
- FIT-CFG: standard after configuration/master data.
- FIT-AUTO: achieved with automation rules, templates, activities.
- GAP-STUDIO: needs Studio fields/views/approvals/reports (studio-vs-code.md).
- GAP-EXT: small code extension of an existing model/view.
- GAP-NEW: new model/app or complex logic.
- GAP-INT: needs integration with an external system.
- PROCESS: business adapts to standard.
- OUT: rejected or deferred (with rationale).

## Procedure
1. Normalize each requirement to a testable statement (actor, trigger, outcome, data, volume).
2. Find standard coverage in the app's 17.0 doc page (https://www.odoo.com/documentation/17.0/applications.html), then validate hands-on in a test database; docs alone are not proof.
3. Classify; for each GAP record the cheaper alternative and why it was rejected.
4. Estimate effort (days) for build, test, docs, plus upgrade-risk (low/med/high).
5. Challenge GAPs with the sponsor: value vs cost; convert to PROCESS where value is low.
6. Sequence: must-have FIT first, then GAPs by value/risk; flag dependencies and data prerequisites.
7. Present: counts per class, top risks, decisions needed.

## Output table
ID | Requirement | Priority | Class | Standard coverage / config | Gap detail | Effort | Upgrade risk | Decision/owner

## Scoring
Fit % = (FIT-STD + FIT-CFG + FIT-AUTO) / total, weighted by priority. A high gap share in core processes (accounting, stock valuation, payroll) signals a wrong app choice or immature requirements, not a coding backlog.

## Rules
- Never classify FIT from memory of an older or newer version; check 17 (e.g. the built-in AI app is an Odoo 19 feature, not in 17: classify AI needs as GAP-EXT/GAP-NEW/GAP-INT or an Apps-store module).
- Separate "must for go-live" from "after stabilization".
- Re-run fit-gap after the first demo iteration; requirements move.
