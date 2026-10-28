# Employees and contracts (Odoo 20)

> Provenance: items marked "confirmed on 19.0" were read from the 19.0 docs. The 20.0 pages could not be fetched, so every URL below is ported from the 19.0 layout (verify in 20.0 docs).

Docs: https://www.odoo.com/documentation/20.0/applications/hr/employees.html ; contracts: https://www.odoo.com/documentation/20.0/applications/hr/payroll/contracts.html

## Employees app
- Keeps personnel files, contracts, departments; also certifications, training, badges, equipment.
- Sub-pages (confirmed on 19.0 in page nav, under .../applications/hr/employees/): new_employee, departments, skills_inventory, onboarding, offboarding, archive, learning, certifications, training_attendances, badges, equipment.
- Skills Management setting adds a Resume tab (experience, skills, certifications).
- Settings: warning lead time for contract and work permit expiry.
- Archive instead of delete; offboarding handles assets/documents.
- Private information specifics: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/employees/new_employee.html)
- Odoo 20 removes the `hr_org_chart` and `hr_homeworking` modules. Do not depend on the org chart module (or its views/widgets) or the homeworking module in custom code, reports or automations; where org-chart or per-day work-location behavior lives now is not confirmed here (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/employees.html).

## Contracts (documented under Payroll)
- A contract template loaded in the employee's Payroll tab fills most fields; template load is logged in chatter.
- Start date (may be set automatically at signature); optional end date (default Indefinite).
- Template general info: name, job, department, HR responsible (blank job/department = applies to all).
- Pay Category (formerly Salary Structure Type): structure types under Payroll > Configuration > Structure Types.
- Work Entry Source (required on 19.0): Working Schedule | Attendances | Planning. This field belonged to the payroll work entry feature, which Odoo 20 removes: do not rely on it in 20 and confirm what the contract/employee record exposes instead (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/contracts.html). Working Hours = expected schedule; blank = no weekly restriction.
- Salary: Wage Type (Fixed Wage | Hourly Wage), Pay Schedule, Wage, Yearly Cost, Monthly Cost (linked; docs recommend entering Yearly Cost first), Wage on Signature.
- The 19.0 payslip form says "Employee Record" (contract start date record); whether 20 keeps that naming is not confirmed. Confirm actual model naming/versioning in the target DB before coding: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/contracts.html)
- Benefits/deductions and signatories sections: (verify in 20.0 docs: same URL).

## Senior notes
- One active contract per employee per period; gaps leave payroll periods uncovered and overlaps make the applicable wage/structure ambiguous (in 19 they surfaced as missing work entries and work entry conflicts; with work entries removed in 20 they show up at payslip generation, so check contract continuity yourself).
- Wage change mid-period: start a new record at that date so lines split per period.
- Localizations may add contract fields (allowances, tax status); these are country-specific.
- Inspect real fields (fields_get / Odoo shell) on the target DB before writing code.
