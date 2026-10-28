---
name: hr-payroll
description: Senior Odoo 17 HR and Payroll expertise. Use for Odoo 17 HR — employees, contracts, time off, attendances, recruitment and appraisals — and Payroll — salary structures and rules, work entries, payslips and batches (noting payroll is localization-dependent).
---

# Odoo 17 HR & Payroll (senior)

## Mindset
- Payroll is a pipeline: employee/contract -> schedule + time off + attendance/planning/timesheet -> work entries -> payslips -> payslip batch -> accounting/payment. Fix data upstream; never patch payslip lines.
- Payroll is LOCALIZATION-DEPENDENT. The country localization (l10n_xx_hr_payroll) ships structures, rules, rule parameters, taxes, contributions and bank formats. Never assert country rules (tax brackets, social contributions, leave entitlements, 13th month, end-of-service) as universal. Always ask: which country/company/localization?
- The list of supported localizations differs per version: check the payroll_localizations page of the 17.0 docs (verify the current list; newer integrations such as Employment Hero belong to later versions). For other countries expect a generic/manual setup.
- Multi-company: each company can use its own localization; configure per company.
- Payroll data is sensitive: restrict groups (Payroll Officer/Administrator), record rules, multi-company; audit via chatter.
- Prefer configuration (rule parameters, salary inputs, structure types) over editing localized rules; docs warn to change/create rules only when necessary.

## Principles
1. Clarify first: localization, edition (Payroll is Enterprise), work-entry source, wage type (fixed/hourly), pay schedule, accounting needs.
2. Install the localization BEFORE creating contracts/payslips; avoid switching it later except for law changes.
3. The contract (`hr.contract`, Employees/Payroll > Contracts) drives wage, salary structure type, working schedule, work entry source, pay schedule, and is the record the payslip is computed from. Contracts-as-employee-versions is a later-version change, not 17.
4. Work entry source is a deliberate choice: Working Schedule, Attendances, or Planning (the latter two need those apps). Mixed sources across contracts are a common error.
5. Resolve work-entry conflicts (unapproved time off, overlaps, errors) before generating payslips; regenerate entries after fixing.
6. Approve time off before the period closes; time off type maps to a work entry type, which feeds worked days used by salary rules.
7. Rules compute in ascending sequence; later rules read earlier results (category totals, rule codes). Codes are case-sensitive.
8. Payslip line = amount x quantity x rate/100. Compute Sheet is repeatable until processed.
9. Use payslip batches (Generate Payslips) for bulk; off-cycle payslips for exceptions (bonus, correction) (verify off-cycle availability in 17.0).
10. Accounting: set salary journal and accounts; processing (Create Draft Entry) creates the journal entry (accounting date or validation date); then payment report and Mark as paid.
11. Never delete processed payslips; revert/refund instead.
12. Promote customizations through a custom module (XML data for structures/rules/parameters with stable xml ids), not UI-only edits.
13. Test on a DB copy: run a month for sample employees (new hire, mid-month leaver, unpaid leave, overtime) and compare against manual calculation.

## Review checklist
- Localization installed and matching company? Salary structure type set on each contract?
- Contract dates contiguous, no overlap; contract state (New / Running / Expired / Cancelled) correct; wage vs yearly/monthly cost consistent.
- Work entry types mapped to time off types; public holidays configured.
- Accrual plans and allocations set before leave requests.
- Rules: sequence, condition, category, code uniqueness, Python expression safety.
- Journal/accounts set; access rights and multi-company rules checked.

## References
- references/employees-contracts.md - employee record, departments, contract fields.
- references/time-off-attendance.md - time off types, allocations, accruals, attendance modes, overtime.
- references/payroll-structures-rules.md - structures, rules, categories, inputs, conditions.
- references/work-entries-payslips.md - work entries, payslips, batches, accounting.
- references/recruitment-appraisal.md - recruitment pipeline, offers, appraisals, goals.

Docs entry points for 17.0 (deep-page paths in the references follow the 19.0 layout with the version swapped; verify they resolve):
- https://www.odoo.com/documentation/17.0/applications/hr.html
- https://www.odoo.com/documentation/17.0/applications/hr/payroll.html
- https://www.odoo.com/documentation/17.0/applications/hr/payroll/payroll_localizations.html
