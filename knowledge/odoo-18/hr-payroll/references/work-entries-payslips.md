# Work entries, payslips, batches (pay runs), accounting (Odoo 18 Payroll)

Docs (same folder .../applications/hr/payroll/): work_entries.html, payslips.html, pay_runs.html (the batch page name is from the newer docs set; verify the page and the menu label in 18)

## Work entries
- Generated from the contract's work entry source (schedule, Attendances, Planning) plus Time Off; can be created manually.
- Default types: attendance, sick leave, training, public holiday; custom types allowed.
- Dashboard: Payroll > Work Entries > Work Entries (opens with Conflicting filter).
- Conflicts (orange triangle): unapproved time off or errors; current-period conflicts block payslip generation. Commonest: leave requested after entries were generated.
- Resolve: Approve Time Off -> conflicting entry Cancelled; Refuse -> entry Draft. Then regenerate affected entries (overwrites conflicting ones).
- Related: working_schedules, time_off_to_report, work_entry_analysis pages.

## Payslips
- Payroll > Payslips > Payslips; off-cycle via New Off-Cycle. Required: employee, contract; structure auto-fills; period defaults to current month; optional batch (pay run).
- Tabs: Worked Days (auto, not manually addable), Salary Inputs (running adjustments + manual lines), Salary Computation (empty until Compute Sheet; repeatable before processing), Other Info (name, company, payment date, accounting date, salary journal, notes).
- "Date Account" sets the journal date; blank -> validation date.
- Dashboard warnings/errors show before processing.
- States, journal posting, refund details: (verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/hr/payroll/payslips.html)

## Batches (pay runs)
- The 18 UI menu is Payslips > Batches (model hr.payslip.run); newer docs call them "pay runs". Create from Work Entries (Generate Payslips), Payslips, or the Batches dashboard (button labels: verify in 18); pick structure (blank = all), scheduled pay, period, employees.
- Status: Ready (payslips exist, unprocessed) -> Done (after Create Draft Entry) -> Paid (Mark as paid after payment report). Revert Done -> Ready only if no payslip is Paid.
- Off-cycle payslips can be added later: set the batch on the payslip, Compute Sheet.
- Payment Report: export format (CSV always; others per localization), payment date, optional bank journal; Generate, Download, then Mark as paid.
- Technical model names on 18: hr.payslip (payslip), hr.payslip.run (batch), hr.contract (contract): (verify in 18.0 source).

## Senior notes
- Month-close routine: approve leave -> check attendance -> clear conflicts -> regenerate -> generate batch -> compute -> review warnings -> create draft entries -> post journal -> payment file -> mark paid.
- Journal entry mismatches usually come from unset accounts on rules or journal.
- Bank file formats (SEPA, local) are localization-specific.
- After processing do not edit inputs; revert/refund per policy.
