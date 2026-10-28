# Work entries, payslips, pay runs, accounting (Odoo 19 Payroll)

Docs (same folder .../applications/hr/payroll/): work_entries.html, payslips.html, pay_runs.html

## Work entries
- Generated from the contract's work entry source (schedule, Attendances, Planning) plus Time Off; can be created manually.
- Default types: attendance, sick leave, training, public holiday; custom types allowed.
- Dashboard: Payroll > Work Entries > Work Entries (opens with Conflicting filter).
- Conflicts (orange triangle): unapproved time off or errors; current-period conflicts block payslip generation. Commonest: leave requested after entries were generated.
- Resolve: Approve Time Off -> conflicting entry Cancelled; Refuse -> entry Draft. Then regenerate affected entries (overwrites conflicting ones).
- Related: working_schedules, time_off_to_report, work_entry_analysis pages.

## Payslips
- Payroll > Payslips > Payslips; off-cycle via New Off-Cycle. Required: employee, employee record; structure auto-fills; period defaults to current month; optional pay run.
- Tabs: Worked Days (auto, not manually addable), Salary Inputs (running adjustments + manual lines), Salary Computation (empty until Compute Sheet; repeatable before processing), Other Info (name, company, payment date, accounting date, salary journal, notes).
- "Date Account" sets the journal date; blank -> validation date.
- Dashboard warnings/errors show before processing.
- States, journal posting, refund details: (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/hr/payroll/payslips.html)

## Pay runs (batches)
- Docs call them "pay runs". Create from Work Entries (Generate Pay Run), Payslips, or Pay Runs dashboard; pick structure (blank = all), pay schedule, period, employees.
- Status: Ready (payslips exist, unprocessed) -> Done (after Create Draft Entry) -> Paid (Mark as paid after payment report). Revert Done -> Ready only if no payslip is Paid.
- Off-cycle payslips can be added later: set Pay Run, Compute Sheet.
- Payment Report: export format (CSV always; others per localization), payment date, optional bank journal; Generate, Download, then Mark as paid.
- Technical model names (hr.payslip, hr.payslip.run) are from earlier versions: (verify in 19.0 source for renames).

## Senior notes
- Month-close routine: approve leave -> check attendance -> clear conflicts -> regenerate -> generate pay run -> compute -> review warnings -> create draft entries -> post journal -> payment file -> mark paid.
- Journal entry mismatches usually come from unset accounts on rules or journal.
- Bank file formats (SEPA, local) are localization-specific.
- After processing do not edit inputs; revert/refund per policy.
