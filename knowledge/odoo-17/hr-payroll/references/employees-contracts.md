# Employees and contracts (Odoo 17)

Docs: https://www.odoo.com/documentation/17.0/applications/hr/employees.html ; contracts: https://www.odoo.com/documentation/17.0/applications/hr/payroll/contracts.html (verify the contracts page path in 17.0; it may sit under Employees)

## Employees app
- Keeps personnel files, contracts, departments; also certifications, training, badges, equipment.
- Sub-pages listed in the 19.0 docs nav (under .../applications/hr/employees/): new_employee, departments, skills_inventory, onboarding, offboarding, archive, learning, certifications, training_attendances, badges, equipment. Verify which exist in 17.0.
- Skills Management setting adds a Resume tab (experience, skills, certifications).
- Settings: warning lead time for contract and work permit expiry.
- Archive instead of delete; offboarding handles assets/documents.
- Private information and org chart specifics: (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/hr/employees/new_employee.html)

## Contracts (model hr.contract)
- In Odoo 17 the contract is a distinct record (`hr.contract`) linked to the employee; states: New (draft), Running (open), Expired (close), Cancelled. Contracts-as-employee-versions (the 19.0 "Employee Record" wording) is a later-version change: do not apply it to 17.
- Contract templates (preloading most fields from a template) are described in the 19.0 docs; verify availability in 17.0 (the Salary Configurator / contract template features depend on the installed modules and edition).
- Start date; optional end date (blank = indefinite).
- General info: reference, employee, job position, department, HR responsible, contract type (verify field set in 17.0).
- Salary Structure Type (`structure_type_id`): structure types under Payroll > Configuration > Structure Types.
- Work Entry Source (required): Working Schedule | Attendances | Planning. Working Schedule (`resource_calendar_id`) = expected schedule; in 17 it is required (flexible-hours schedules are newer: verify).
- Salary: Wage Type (Fixed Wage | Hourly Wage), Scheduled Pay, Wage, Yearly Cost, Monthly Cost (linked; enter Yearly Cost first if you use the cost fields), Wage on Signature (needs the Sign / salary configurator modules: verify).
- The payslip form carries a Contract field: confirm the actual model and field names with fields_get before coding (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/hr/payroll/contracts.html).
- Benefits/deductions and signatories sections: (verify in 17.0 docs: same URL).

## Senior notes
- One running contract per employee per period; gaps cause missing work entries, overlaps cause conflicts.
- Wage change mid-period: end the current contract and start a new one at that date (or follow your company's contract-history practice) so lines split per period.
- Localizations may add contract fields (allowances, tax status); these are country-specific.
- Inspect real fields (fields_get / Odoo shell) on the target DB before writing code.
