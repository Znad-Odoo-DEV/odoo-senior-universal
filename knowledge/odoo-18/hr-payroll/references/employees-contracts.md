# Employees and contracts (Odoo 18)

Docs: https://www.odoo.com/documentation/18.0/applications/hr/employees.html ; contracts: https://www.odoo.com/documentation/18.0/applications/hr/payroll/contracts.html

## Employees app
- Keeps personnel files, contracts, departments; also certifications, training, badges, equipment.
- Sub-pages (confirmed in page nav, under .../applications/hr/employees/): new_employee, departments, skills_inventory, onboarding, offboarding, archive, learning, certifications, training_attendances, badges, equipment. Verify each exists in the 18 docs.
- Skills Management setting adds a Resume tab (experience, skills, certifications).
- Settings: warning lead time for contract and work permit expiry.
- Archive instead of delete; offboarding handles assets/documents.
- Private information and org chart specifics: (verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/hr/employees/new_employee.html)

## Contracts (documented under Payroll)
- A contract template loaded in the employee's Payroll tab fills most fields; template load is logged in chatter.
- Start date (may be set automatically at signature); optional end date (default Indefinite).
- Template general info: name, job, department, HR responsible (blank job/department = applies to all).
- Salary Structure Type: structure types under Payroll > Configuration > Structure Types (newer releases relabel this field Pay Category).
- Work Entry Source (required): Working Schedule | Attendances | Planning. Working Hours = expected schedule; blank = no weekly restriction.
- Salary: Wage Type (Fixed Wage | Hourly Wage), Scheduled Pay (labelled Pay Schedule in newer releases), Wage, Yearly Cost, Monthly Cost (linked; docs recommend entering Yearly Cost first), Wage on Signature (exact salary-field labels and which cost fields show are localization-dependent: verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/hr/payroll/contracts.html).
- On 18 the contract is its own record (model hr.contract, Employees > Contracts, Contract field on the payslip). Odoo 19 replaces it with employee versions labelled "Employee Record"; do not use that wording or model on 18. Confirm model and field names in the target DB before coding: (verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/hr/payroll/contracts.html)
- Benefits/deductions and signatories sections: (verify in 18.0 docs: same URL).

## Senior notes
- One active contract per employee per period; gaps cause missing work entries, overlaps cause conflicts.
- Wage change mid-period: start a new record at that date so lines split per period.
- Localizations may add contract fields (allowances, tax status); these are country-specific.
- Inspect real fields (fields_get / Odoo shell) on the target DB before writing code.
