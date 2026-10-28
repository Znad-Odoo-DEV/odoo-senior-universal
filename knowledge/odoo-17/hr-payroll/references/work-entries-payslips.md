# Work entries, payslips, batches, accounting (Odoo 17 Payroll)

Docs (same folder .../applications/hr/payroll/): work_entries.html, payslips.html, pay_runs.html (the 19.0 name; 17.0 may call the page batches or payslips: verify)

## Work entries
- Generated from the contract's work entry source (schedule, Attendances, Planning) plus Time Off; can be created manually.
- Default types: attendance, sick leave, training, public holiday; custom types allowed.
- Dashboard: Payroll > Work Entries > Work Entries (opens with Conflicting filter).
- Conflicts (orange triangle): unapproved time off or errors; current-period conflicts block payslip generation. Commonest: leave requested after entries were generated.
- Resolve: Approve Time Off -> conflicting entry Cancelled; Refuse -> entry Draft. Then regenerate affected entries (overwrites conflicting ones).
- Related: working_schedules, time_off_to_report, work_entry_analysis pages (verify in 17.0).

## Payslips
- Payroll > Payslips > Payslips; off-cycle payslips via the off-cycle action where available (verify in 17.0). Required: employee, contract; structure auto-fills from the contract; period defaults to current month; optional batch.
- Tabs: Worked Days & Inputs (worked days auto, not manually addable; other inputs for running adjustments and manual lines), Salary Computation (empty until Compute Sheet; repeatable before processing), Other Info (name, company, payment date, accounting date, salary journal, notes). Verify tab names in 17.0.
- "Date Account" sets the journal date; blank -> validation date.
- Dashboard warnings/errors show before processing.
- States and actions: Draft -> Waiting (verify) -> Done (Create Draft Entry) -> Paid (Mark as Paid); Refund creates a reversing payslip. Journal posting and refund details: (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/hr/payroll/payslips.html)

## Payslip batches (hr.payslip.run; called pay runs in newer docs)
- Create from Work Entries (Generate Payslips), Payslips, or the Batches dashboard; pick structure (blank = all), pay schedule, period, employees.
- Batch states (17.0): New -> Confirmed -> Done (after Create Draft Entry) -> Paid (Mark as Paid after payment report). Verify the Confirmed step and revert rules in 17.0; do not revert Done batches that contain Paid payslips.
- Off-cycle payslips can be added later: set the batch, Compute Sheet.
- Payment Report: export format (CSV always; others per localization), payment date, optional bank journal; Generate, Download, then Mark as paid.
- Technical model names: hr.payslip, hr.payslip.run, hr.work.entry, hr.salary.rule, hr.contract (verify fields with fields_get on the target DB).

## Senior notes
- Month-close routine: approve leave -> check attendance -> clear conflicts -> regenerate -> generate payslip batch -> compute -> review warnings -> create draft entries -> post journal -> payment file -> mark paid.
- Journal entry mismatches usually come from unset accounts on rules or journal.
- Bank file formats (SEPA, local) are localization-specific.
- After processing do not edit inputs; revert/refund per policy.
