---
name: hr-payroll
description: Senior Odoo 20 HR and Payroll expertise. Use for Odoo 20 HR — employees, contracts, time off, attendances, recruitment and appraisals — and Payroll — salary structures and rules, payslips and batches, with payroll work entries removed in 20 (noting payroll is localization-dependent).
---

# Odoo 20 HR & Payroll (senior)

## Mindset
- Payroll is a pipeline: employee/contract -> schedule + time off + attendance/planning/timesheet -> payslip (worked days and inputs) -> pay run -> accounting/payment. Fix data upstream; never patch payslip lines.
- **Odoo 20 removes payroll work entries.** The 19 pipeline "contract -> work entries -> payslips" no longer exists: payslip generation must not assume work entries, a Work Entries dashboard, work entry types or conflict resolution. The replacement path for worked time and absences reaching a payslip is described in references/work-entries-payslips.md (exact mechanism: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/payslips.html).
- Payroll is LOCALIZATION-DEPENDENT. The country localization (l10n_xx_hr_payroll) ships structures, rules, rule parameters, taxes, contributions and bank formats. Never assert country rules (tax brackets, social contributions, leave entitlements, 13th month, end-of-service) as universal. Always ask: which country/company/localization? Localization rules written against 19 work entries or worked-day codes must be re-validated on 20 (verify per localization module).
- The 19.0 docs listed localizations for Australia, Belgium, Egypt, Hong Kong, India, Jordan, Kenya, Mexico, Saudi Arabia, Turkiye, UAE, US, Employment Hero; re-check the 20.0 list (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/payroll_localizations.html). For other countries expect a generic/manual setup.
- Removed in Odoo 20: modules `hr_work_entry_holidays`, `l10n_fr_hr_work_entry_holidays`, `hr_org_chart`, `hr_homeworking`. Do not depend on them in custom modules, automations or reports.
- Multi-company: each company can use its own localization; configure per company.
- Payroll data is sensitive: restrict groups (Payroll Officer/Administrator), access rules (in 20 `ir.model.access` and `ir.rule` are merged into `ir.access`), multi-company; audit via chatter.
- Prefer configuration (rule parameters, salary inputs, structure types) over editing localized rules; docs warn to change/create rules only when necessary.

## Principles
1. Clarify first: localization, edition (Payroll is Enterprise), how worked time/absences reach the payslip in 20, wage type (fixed/hourly), pay schedule, accounting needs.
2. Install the localization BEFORE creating contracts/payslips; avoid switching it later except for law changes.
3. The contract (called "Employee Record" on 19.0 payslips; confirm 20 naming) drives wage, pay category/structure type, schedule, pay schedule. The 19 "Work Entry Source" choice (Working Schedule / Attendances / Planning) belonged to the work entry model: treat it as gone unless the 20.0 docs show otherwise (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/contracts.html).
4. Decide the time source deliberately per company: working schedule, attendances/overtime, planning hours or timesheets, and confirm which of these the 20 mechanism actually supports (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/payslips.html). Avoid mixing sources across contracts.
5. Resolve upstream data problems (unapproved time off, attendance gaps and missing check-outs, overlapping or missing contracts) BEFORE generating payslips. In 19 these surfaced as work-entry conflicts; with work entries gone there is no such conflict dashboard, so expect them to show up only as wrong or missing payslip lines (or payslip warnings) and review before Compute Sheet (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/payslips.html).
6. Approve time off before the period closes; how an approved/refused leave reaches payslip worked days/inputs in 20 is defined by the replacement mechanism, not by work entry types (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/payslips.html).
7. Rules compute in ascending sequence; later rules read earlier results (category totals, rule codes). Codes are case-sensitive.
8. Payslip line = amount x quantity x rate/100. Compute Sheet is repeatable until processed.
9. Use pay runs for bulk; off-cycle payslips for exceptions (bonus, correction).
10. Accounting: set salary journal and accounts; processing creates the journal entry (accounting date or validation date); then payment report and Mark as paid. Bank-impacting journal entries must originate from bank transactions in 20 (no manual bank-journal entries); check how salary payments and payment files reconcile (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/pay_runs.html).
11. Never delete processed payslips; revert/refund instead.
12. Promote customizations through a custom module (XML data for structures/rules/parameters with stable xml ids), not UI-only edits. Module security ships as `ir.access.csv` (`id,name,model_id,group_id/id,operation,domain`), not `ir.model.access.csv`/`ir.rule`.
13. Test on a DB copy: run a month for sample employees (new hire, mid-month leaver, unpaid leave, overtime) and compare against manual calculation.

## Review checklist
- Localization installed and matching company? Structure type set on each contract?
- Contract dates contiguous, no overlap; wage vs yearly/monthly cost consistent.
- Time off types, public holidays and attendance/overtime settings configured and approved before payslips are computed; no code or rule still reads removed work entry data.
- Accrual plans and allocations set before leave requests.
- Rules: sequence, condition, category, code uniqueness, Python expression safety; `worked_days` / `inputs` codes re-validated on 20.
- Journal/accounts set; access rights (`ir.access`) and multi-company rules checked.
- Upgrading from 19: closed periods archived, work-entry-based customizations inventoried (see the migration checklist in references/work-entries-payslips.md).

## Runtime (Odoo 20)
- Python >= 3.12, PostgreSQL >= 16; custom payroll modules use OWL 3 for frontend code and the public `read_group(domain, groupby, aggregates, having, offset, limit, order)` signature (old `fields=`/`lazy=` calls break).

## References
- references/employees-contracts.md - employee record, departments, contract fields (org chart and homeworking modules removed).
- references/time-off-attendance.md - time off types, allocations, accruals, attendance modes, overtime, and their link to payroll without work entries.
- references/payroll-structures-rules.md - structures, rules, categories, inputs, conditions.
- references/work-entries-payslips.md - what replaced work entries, payslips, pay runs, accounting, 19 to 20 migration checklist (filename kept for continuity).
- references/recruitment-appraisal.md - recruitment pipeline, offers, appraisals, goals.

Docs entry points (ported from the 19.0 layout, fetched for 19.0; verify in 20.0 docs). Release notes: https://www.odoo.com/odoo-20-release-notes
- https://www.odoo.com/documentation/20.0/applications/hr.html
- https://www.odoo.com/documentation/20.0/applications/hr/payroll.html
- https://www.odoo.com/documentation/20.0/applications/hr/payroll/payroll_localizations.html
