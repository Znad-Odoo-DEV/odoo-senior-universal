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
2. Find standard coverage in the app's 20.0 doc page (https://www.odoo.com/documentation/20.0/applications.html; ported from the 19.0 layout, verify in 20.0 docs), then validate hands-on in a test database; docs alone are not proof.
3. Classify; for each GAP record the cheaper alternative and why it was rejected.
4. Estimate effort (days) for build, test, docs, plus upgrade-risk (low/med/high).
5. Challenge GAPs with the sponsor: value vs cost; convert to PROCESS where value is low.
6. Sequence: must-have FIT first, then GAPs by value/risk; flag dependencies and data prerequisites.
7. Present: counts per class, top risks, decisions needed.

## Output table
ID | Requirement | Priority | Class | Standard coverage / config | Gap detail | Effort | Upgrade risk | Decision/owner

## Scoring
Fit % = (FIT-STD + FIT-CFG + FIT-AUTO) / total, weighted by priority. A high gap share in core processes (accounting, stock valuation, payroll) signals a wrong app choice or immature requirements, not a coding backlog.

## Odoo 20 traps (re-test these before classifying FIT)
| Requirement area | What changed in 20 | Fit-gap consequence |
|---|---|---|
| Field service work (dispatch, worksheets, on-site time and products) | Field Service is discontinued; its features moved into Planning | Re-classify against Planning + Project + Sales; mark FIT only after a hands-on test; migration of existing FSM data is its own requirement |
| Batch / wave picking | `stock_picking_batch` merged into `stock` | FIT-STD in core Inventory; drop any "install the batch module" line |
| Wishlist, product comparison | merged into `website_sale` | FIT-STD in core eCommerce |
| Mondial Relay carrier | `delivery_mondialrelay` removed | GAP-INT or PROCESS: choose another carrier connector |
| Org chart, homeworking | `hr_org_chart`, `hr_homeworking` removed | GAP (or OUT) unless a replacement is confirmed on the 20.0 page |
| Payroll based on work entries, leave-to-work-entry rules | payroll work entries are removed; `hr_work_entry_holidays` and `l10n_fr_hr_work_entry_holidays` removed | Payslip rules must be re-specified per localization; high risk (verify in 20.0 docs) |
| Account groups in reporting | replaced by parent accounts | Re-specify chart-of-accounts hierarchy and group-based reports |
| Manual bank journal entries | bank-impacting journal entries must originate from bank transactions | PROCESS change: entries come from bank transactions; revisit reconciliation specs |
| Payment status filters/automations | payment statuses are renamed | Re-map statuses in filters, automation rules and reports |
| Expense claims | expenses become draft vendor bills | Re-specify approval, reimbursement and analytics on the vendor-bill flow |
| VAT/IBAN validation | `base_vat`, `base_iban` removed | Re-test validation per country; behavior (verify in 20.0 docs) |
| External system integration | XML-RPC/JSON-RPC deprecated; `db` service removed; `common`/`object` removed in Odoo 22 (fall 2028); JSON-2 on Custom plan only | GAP-INT must specify JSON-2 and plan/edition |
| OCA / third-party add-ons | OCA had no 20.0 branches as of 2026-09-24 (re-check) | Never classify FIT on an OCA add-on without a 20.0 branch; consider GAP-EXT/PROCESS |
| Access rules and record rules | merged into `ir.access` | Record security as matrix + row-filter conditions; developer implements `ir.access.csv` |

## Rules
- Never classify FIT from memory of an older version; check 20.
- Separate "must for go-live" from "after stabilization".
- Re-run fit-gap after the first demo iteration; requirements move.
- For an upgrade (19 -> 20) fit-gap, add one line per existing customization and per third-party module: keep, port, replace by standard, or retire.
