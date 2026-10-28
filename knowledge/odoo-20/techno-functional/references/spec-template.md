# Functional Spec Template (developer handover)

## 1. Header
ID, title, business owner, analyst, developer, status, version, Odoo version (20.0), apps/modules touched, priority.

## 2. Business context
Problem, goal, success metric, as-is process, to-be process (numbered steps with actors), out of scope.

## 3. Requirement and fit-gap
Requirement statement; fit-gap class (fit-gap.md); standard features considered and why insufficient (including 20 changes: removed/merged modules, Planning replacing Field Service).

## 4. Data model
Per model: new or inherited; fields table (label, technical name, type, required, stored/computed, default, visibility); relations; constraints; indexes; external IDs. States and transitions table (from, to, trigger, who, side effects).

## 5. Behavior and rules
Numbered, testable business rules; computations with formulas and rounding/currency rules; automation triggers (create/update/time-based, conditions, actions); sequences; notifications (channel, template, recipients); edge cases (cancel, refund, partial, multi-company, multi-currency, archived data).

## 6. UI
Views affected (form/list/kanban/search/pivot), field placement, buttons and visibility conditions, filters/groupings, wizards, menus/actions. Mockup or screenshot reference.

## 7. Security
Groups; access matrix (model x group x operation) with a "row filter" column in plain language (own records, own company, team); field-level restrictions; approval rules. In 20 the developer implements the matrix as `ir.access` rows (`security/ir.access.csv`, columns `id,name,model_id,group_id/id,operation,domain`); the row filter becomes the `domain`. Do not specify "ACL" and "record rules" separately.

## 8. Accounting / stock / other impacts
Journals, accounts (parent accounts, not account groups), taxes, analytic, valuation, routes/operation types, mail/portal/website effects. State if bank-impacting entries originate from bank transactions and how payment statuses are used (statuses renamed in 20).

## 9. Reports and outputs
PDF/email templates, dashboards, exports: layout, data source, filters, totals.

## 10. Integrations and data migration
Systems, direction, trigger, payload, auth, error handling, retry; for 20 specify JSON-2 (`/json/2/<model>/<method>`, Custom plan only) rather than XML-RPC/JSON-RPC (deprecated; `db` service removed in 20; `common`/`object` removed in Odoo 22); import sources, mapping, cleansing, load order, volumes.

## 11. Non-functional
Volume, performance targets, audit/logging, retention, languages, accessibility. Upgrade impact: custom code on OWL 3, `read_group` signature, `ir.access`; platform Python >= 3.12 / PostgreSQL >= 16.

## 12. Acceptance criteria
Given/when/then scenarios with sample data and expected results (record values, postings, emails). Include negative and permission tests (each `ir.access` row, positive and negative).

## 13. Open questions and assumptions
Item, owner, due date, impact.

## 14. Change log
Version, date, change, approver.
