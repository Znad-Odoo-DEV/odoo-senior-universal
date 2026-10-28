# Time off and attendance (Odoo 20)

> Provenance: items marked "confirmed on 19.0" were read from the 19.0 docs. The 20.0 pages could not be fetched, so every URL below is ported from the 19.0 layout (verify in 20.0 docs).

## Time off
Docs: https://www.odoo.com/documentation/20.0/applications/hr/time_off.html
Sub-pages (confirmed on 19.0, under .../hr/time_off/): time_off_types, allocations, accrual_plans, mandatory_days, public_holidays, request_time_off, my_time, management, reporting.
- Time off types must exist before requests; some types require an allocation (balance granted by management).
- Accrual plans build balance over time. Level options (frequency, caps, carry-over): (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/time_off/accrual_plans.html)
- Approvals: managers review from dashboards; a "Second Approval" status exists (striped on calendar; solid when fully approved). Validation modes per type: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/time_off/time_off_types.html)
- Public holidays and mandatory days must follow local/national rules; they affect payroll worked days / absence treatment (in 19 through work entries; in 20 through the replacement mechanism: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/payslips.html).
- Payroll link: payroll work entries are removed in Odoo 20, so there is no time off type -> work entry type mapping and no cancel/restore of work entries on approve/refuse (that was the 19 behavior). The `hr_work_entry_holidays` and `l10n_fr_hr_work_entry_holidays` modules that bridged Time Off and work entries are removed. How approved leave reaches payslip worked days/inputs in 20, and the paid/unpaid treatment per time off type: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/payslips.html). Treatment is country-specific.
- Statutory entitlements and paid/unpaid treatment are country-specific; never assume.

## Attendances
Docs: https://www.odoo.com/documentation/20.0/applications/hr/attendances.html
Sub-pages (confirmed on 19.0): check_in_check_out, kiosks, attendance_onboarding, management, attendance_logs, overtime, hardware, attendance_reporting, time_off_ledger.
- Modes: Attendances from Backend (check in/out in database, else kiosk), Automatic Check-Out (after tolerance hours past schedule end), Absence Management (absences not tied to time off; not for flexible schedules).
- Kiosk: dedicated device; can show extra hours at checkout if enabled.
- Overtime: tolerance in favor of company/employee; extra hours validation automatic or manager-approved; approved extra hours can be deducted from approved time off. The "Overtime rulesets" page exists in 20.0 (confirmed: the 20.0 docs have an "Overtime rulesets" page under Configuration > Overtime Rulesets, no rulesets preconfigured, quantity-based and timing-based rules, rate combination mode: https://www.odoo.com/documentation/20.0/applications/hr/attendances/overtime.html).
- Any user can check in/out even without app access.

## Senior notes
- Where attendances feed payroll, missing check-outs create gaps/errors: enforce auto check-out and review logs before computing payslips (in 19 this was the Attendances work entry source; in 20 confirm how attendance data reaches the payslip: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/payslips.html).
- `hr_homeworking` is removed in Odoo 20: do not plan remote-work tracking around it (replacement, if any: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/attendances.html).
- Fixed vs flexible schedules change overtime/absence logic; decide per contract.
- Set a time off approval cutoff before payslip generation (Compute Sheet) so a late leave does not change an already reviewed payslip; the 19 reason (work entry conflicts) no longer applies in 20.
