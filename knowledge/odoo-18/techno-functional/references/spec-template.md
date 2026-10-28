# Functional Spec Template (developer handover)

## 1. Header
ID, title, business owner, analyst, developer, status, version, Odoo version (18.0), apps/modules touched, priority.

## 2. Business context
Problem, goal, success metric, as-is process, to-be process (numbered steps with actors), out of scope.

## 3. Requirement and fit-gap
Requirement statement; fit-gap class (fit-gap.md); standard features considered and why insufficient.

## 4. Data model
Per model: new or inherited; fields table (label, technical name, type, required, stored/computed, default, visibility); relations; constraints; indexes; external IDs. States and transitions table (from, to, trigger, who, side effects).

## 5. Behavior and rules
Numbered, testable business rules; computations with formulas and rounding/currency rules; automation triggers (create/update/time-based, conditions, actions); sequences; notifications (channel, template, recipients); edge cases (cancel, refund, partial, multi-company, multi-currency, archived data).

## 6. UI
Views affected (form/list/kanban/search/pivot), field placement, buttons and visibility conditions, filters/groupings, wizards, menus/actions. Mockup or screenshot reference.

## 7. Security
Groups; access matrix (model x group x CRUD); record rules in plain language; field-level restrictions; approval rules.

## 8. Accounting / stock / other impacts
Journals, accounts, taxes, analytic, valuation, routes/operation types, mail/portal/website effects.

## 9. Reports and outputs
PDF/email templates, dashboards, exports: layout, data source, filters, totals.

## 10. Integrations and data migration
Systems, direction, trigger, payload, auth, error handling, retry; import sources, mapping, cleansing, load order, volumes.

## 11. Non-functional
Volume, performance targets, audit/logging, retention, languages, accessibility.

## 12. Acceptance criteria
Given/when/then scenarios with sample data and expected results (record values, postings, emails). Include negative and permission tests.

## 13. Open questions and assumptions
Item, owner, due date, impact.

## 14. Change log
Version, date, change, approver.
