# Payslips, pay runs, accounting without work entries (Odoo 20 Payroll)

> Provenance: Odoo 20 removes payroll work entries — confirmed by the 20 release notes (https://www.odoo.com/odoo-20-release-notes): "Work entries and the Planning-Payroll integration have been removed. Work entry types and time off types have been merged." The 20.0 payroll doc pages had not been rewritten when checked (they still show the 19 work-entries UI), so replacement mechanics are marked "(verify in 20.0 docs)". Items marked "confirmed on 19.0" were read from the 19.0 docs.

Docs (same folder .../applications/hr/payroll/, ported from the 19.0 layout; verify in 20.0 docs): payslips.html, pay_runs.html. The 19.0 work_entries.html page documented the removed feature: expect it to be gone or rewritten in 20.0 (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll.html).

LOCALIZATION-DEPENDENT: how a country localization derives worked days, leave and overtime for its structures is country-specific. Never present one country's treatment as universal, and re-check each installed l10n_xx_hr_payroll module on 20.

## What was removed in 20
- CONFIRMED (release notes): "Work entries and the Planning-Payroll integration have been removed. Work entry types and time off types have been merged." The 20.0 payroll.html / pay_runs.html pages still describe the 19 Work Entries dashboard — treat them as not yet updated for 20, not as evidence the feature survived. Source: https://www.odoo.com/odoo-20-release-notes
- Payroll work entries are removed. Modules confirmed removed: `hr_work_entry_holidays`, `l10n_fr_hr_work_entry_holidays` (also `hr_org_chart` and `hr_homeworking` in the HR area). Whether the remaining technical `hr_work_entry*` modules still exist as dependencies is not confirmed here (verify in 20.0 docs / release notes: https://www.odoo.com/odoo-20-release-notes).
- Also confirmed in the 20 release notes: contract dates can no longer be changed if that affects existing payslips; payslips can be sent on confirmation, on payment, or manually; a pay run can be tested in one click with printed payslips; the Salary Computation tab now shows only relevant information. Source: https://www.odoo.com/odoo-20-release-notes
- Consequently, payslip generation must no longer assume any of the following 19 behaviors:
  - Work Entries dashboard (Payroll > Work Entries > Work Entries, Conflicting filter) and the orange-triangle conflict workflow.
  - Work entry types (attendance, sick leave, training, public holiday, custom) and the time off type -> work entry type mapping.
  - Contract "Work Entry Source" (Working Schedule | Attendances | Planning) as the generator of entries.
  - "Regenerate work entries" as a pre-step before Compute Sheet, and Generate Pay Run started from the Work Entries screen.
  - Approve/Refuse time off cancelling/restoring work entries.
- Treat each of these as unavailable in 20 unless the 20.0 docs show an equivalent (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/payslips.html).

## How worked time reaches a payslip in 20
- The exact new payslip-input mechanism (how worked days, paid/unpaid leave, attendance/overtime and planning hours become payslip Worked Days / Salary Inputs lines, and which fields on the contract or employee drive it) is NOT asserted in this pack (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/payslips.html).
- Discover it on the target database instead of assuming: inspect `fields_get` on `hr.payslip`, `hr.payslip.worked_days` and `hr.payslip.input` (names are from earlier versions; confirm they still exist), check which models exist under `ir.model` with `hr.work.entry` in the name, read the installed localization's structure rules and what they expect in `worked_days` and `inputs`, and generate a test payslip for an employee with a leave and an attendance record.
- Upstream sources are unchanged in role: the contract's schedule, Time Off (types, allocations, public holidays, mandatory days), Attendances (check in/out, overtime), Planning shifts and Timesheets still hold the raw data. Fix them before computing payslips.

## Payslips (confirmed on 19.0; re-verify in 20.0 docs)
- Payroll > Payslips > Payslips; off-cycle via New Off-Cycle. Required: employee, employee record; structure auto-fills; period defaults to current month; optional pay run.
- Tabs on 19.0: Worked Days (auto, not manually addable), Salary Inputs (running adjustments + manual lines), Salary Computation (empty until Compute Sheet; repeatable before processing), Other Info (name, company, payment date, accounting date, salary journal, notes). In 19 the Worked Days tab was filled from work entries; its source in 20 and whether lines can be added manually: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/payslips.html).
- "Date Account" sets the journal date; blank -> validation date.
- Dashboard warnings/errors show before processing. In 19 current-period work-entry conflicts blocked payslip generation; do not assume an equivalent block exists in 20, so validate inputs yourself.
- States, journal posting, refund details: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/payslips.html)

## Pay runs (batches) (confirmed on 19.0; re-verify in 20.0 docs)
- Docs call them "pay runs". Create from Payslips or the Pay Runs dashboard; pick structure (blank = all), pay schedule, period, employees. The 19 "Generate Pay Run from Work Entries" entry point depended on the removed feature (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/pay_runs.html).
- Status: Ready (payslips exist, unprocessed) -> Done (after Create Draft Entry) -> Paid (Mark as paid after payment report). Revert Done -> Ready only if no payslip is Paid.
- Off-cycle payslips can be added later: set Pay Run, Compute Sheet.
- Payment Report: export format (CSV always; others per localization), payment date, optional bank journal; Generate, Download, then Mark as paid.
- Technical model names (hr.payslip, hr.payslip.run) are from earlier versions: (verify in 20.0 source for renames).

## Accounting in 20
- Salary journal and accounts on rules/structure/journal are unchanged in role. In 20, bank-impacting journal entries must originate from bank transactions, so salary payments must be matched to imported/synced bank transactions rather than posted manually to the bank journal (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/pay_runs.html).

## Migration checklist: 19 -> 20 (work entries)
1. Freeze payroll before the upgrade: process, post and pay the last 19 period so no payslip is mid-flight on work entries; keep a payslip/worked-days export for audit.
2. Inventory customizations that reference work entries: custom modules depending on `hr_work_entry*` or `hr_work_entry_holidays`, fields such as work entry source / work entry type on contracts, time off types or rules, automated actions, server actions, reports, exports and API integrations (including XML-RPC/JSON-RPC clients: the `db` service is removed in 20 and `common`/`object` are scheduled for removal in Odoo 22; JSON-2 is `/json/2/<model>/<method>`).
3. Rework salary rules that read `worked_days` codes derived from work entry types; re-validate every rule condition and amount against the 20 payslip data (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/salary_rules.html).
4. France: `l10n_fr_hr_work_entry_holidays` is removed; re-validate French leave and absence treatment on payslips with the French localization owner. Other localizations: check the module's 20.0 source for a work-entry dependency.
5. Rewrite security files for 20 (`ir.access.csv` replaces `ir.model.access.csv`; row filtering via the `domain` column).
6. Run parallel payroll on a DB copy: new hire, mid-month leaver, unpaid leave, sick leave, overtime, public holiday; compare every payslip line with the 19 result.
7. Document the new time source per company and train payroll officers: the old month-close step "clear work entry conflicts" no longer exists.

## Senior notes
- Month-close routine in 20: approve leave -> check attendance/overtime and timesheets -> validate contracts -> generate pay run -> compute -> review warnings -> create draft entries -> post journal -> payment file -> mark paid. (The 19 steps "clear conflicts" and "regenerate work entries" are gone.)
- Journal entry mismatches usually come from unset accounts on rules or journal.
- Bank file formats (SEPA, local) are localization-specific.
- After processing do not edit inputs; revert/refund per policy.
