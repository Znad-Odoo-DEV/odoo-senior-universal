# Time off and attendance (Odoo 19)

## Time off
Docs: https://www.odoo.com/documentation/19.0/applications/hr/time_off.html
Sub-pages (confirmed, under .../hr/time_off/): time_off_types, allocations, accrual_plans, mandatory_days, public_holidays, request_time_off, my_time, management, reporting.
- Time off types must exist before requests; some types require an allocation (balance granted by management).
- Accrual plans build balance over time. Level options (frequency, caps, carry-over): (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/hr/time_off/accrual_plans.html)
- Approvals: managers review from dashboards; a "Second Approval" status exists (striped on calendar; solid when fully approved). Validation modes per type: (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/hr/time_off/time_off_types.html)
- Public holidays and mandatory days must follow local/national rules; they affect work entries.
- Payroll link: time off type -> work entry type; approved leave cancels overlapping work entries; refusal returns them to Draft.
- Statutory entitlements and paid/unpaid treatment are country-specific; never assume.

## Attendances
Docs: https://www.odoo.com/documentation/19.0/applications/hr/attendances.html
Sub-pages (confirmed): check_in_check_out, kiosks, attendance_onboarding, management, attendance_logs, overtime, hardware, attendance_reporting, time_off_ledger.
- Modes: Attendances from Backend (check in/out in database, else kiosk), Automatic Check-Out (after tolerance hours past schedule end), Absence Management (absences not tied to time off; not for flexible schedules).
- Kiosk: dedicated device; can show extra hours at checkout if enabled.
- Overtime: tolerance in favor of company/employee; extra hours validation automatic or manager-approved; approved extra hours can be deducted from approved time off. 19.0 has an "Overtime rulesets" page.
- Any user can check in/out even without app access.

## Senior notes
- With Attendances as work entry source, missing check-outs create gaps/errors: enforce auto check-out and review logs before payroll.
- Fixed vs flexible schedules change overtime/absence logic; decide per contract.
- Set a time off approval cutoff before work entry generation to avoid conflicts.
