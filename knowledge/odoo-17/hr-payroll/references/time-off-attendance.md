# Time off and attendance (Odoo 17)

## Time off
Docs: https://www.odoo.com/documentation/17.0/applications/hr/time_off.html
Sub-pages listed in the 19.0 docs (under .../hr/time_off/): time_off_types, allocations, accrual_plans, mandatory_days, public_holidays, request_time_off, my_time, management, reporting. Verify which exist in 17.0.
- Time off types must exist before requests; some types require an allocation (balance granted by management).
- Accrual plans build balance over time. Level options (frequency, caps, carry-over): (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/hr/time_off.html)
- Approvals: managers review from dashboards; a "Second Approval" status exists (striped on calendar; solid when fully approved). Validation modes per type: (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/hr/time_off.html)
- Public holidays and mandatory days must follow local/national rules; they affect work entries.
- Payroll link: time off type -> work entry type; approved leave cancels overlapping work entries; refusal returns them to Draft.
- Statutory entitlements and paid/unpaid treatment are country-specific; never assume.

## Attendances
Docs: https://www.odoo.com/documentation/17.0/applications/hr/attendances.html
Sub-pages listed in the 19.0 docs: check_in_check_out, kiosks, attendance_onboarding, management, attendance_logs, overtime, hardware, attendance_reporting, time_off_ledger. Verify which exist in 17.0 (the time-off ledger and overtime rulesets pages are newer).
- Modes in 17: check in/out from the backend or a kiosk (PIN, badge/barcode or manual); automatic check-out after a tolerance past the schedule end and absence management are newer options (verify availability in 17.0).
- Kiosk: dedicated device; can show extra hours at checkout if enabled.
- Overtime: tolerance in favor of company/employee; extra hours validation automatic or manager-approved; approved extra hours can be deducted from approved time off (verify each option in 17.0; overtime rulesets are a later-version feature).
- Any user can check in/out even without app access.

## Senior notes
- With Attendances as work entry source, missing check-outs create gaps/errors: enforce check-out discipline (or auto check-out where available) and review logs before payroll.
- Fixed schedules are the norm in 17; flexible schedules change overtime/absence logic in later versions: decide per contract.
- Set a time off approval cutoff before work entry generation to avoid conflicts.
