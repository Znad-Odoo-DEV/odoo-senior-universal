# Salary structures, rules, categories, inputs (Odoo 18 Payroll)

Docs: https://www.odoo.com/documentation/18.0/applications/hr/payroll/salary_rules.html ; localizations: https://www.odoo.com/documentation/18.0/applications/hr/payroll/payroll_localizations.html
LOCALIZATION-DEPENDENT: structures and rules come from the country module; do not assume universal rules.

## Model
- Structure type (Payroll > Configuration > Structure Types) -> salary structure(s) (e.g. Regular Pay) -> salary rules. Contract sets the salary structure type; payslip picks the structure.
- View rules: Payroll > Configuration > Rules.

## Rule fields (confirmed)
- Name (shown on payslip); Code (required, case-sensitive); Category; Salary Structure (required); Sequence (required, ascending: lower runs first and feeds later rules); Appears on Payslip; Contributes to Employer Cost.

## Conditions
- Always True; Salary Input (adds a dynamic field on employee, payslip, or both; unit Monetary/Quantity/Percentage/Checkbox; can depend on another input rule); Other Input (runs if a payslip line of the same input type exists); Python Expression (True/False); Domain. The condition set differs by version (earlier releases also offer Range); verify the options in the 18 UI and docs: https://www.odoo.com/documentation/18.0/applications/hr/payroll/salary_rules.html
- Python variables named in docs: payslip, employee, result_rules, categories, worked_days, inputs. Full list (on 18 the contract is exposed as `contract`; rule-parameter helper): (verify in 18.0 docs: salary_rules.html and the localization module source).

## Computation
- total = amount x quantity x (rate/100).
- Percentage: python amount, quantity expression, rate. Fixed Amount: amount, quantity expression, rate 100. Other Input: amount from matching input lines, rate 100, quantity 1.
- Section hidden when condition is Salary Input.

## Categories
- Group rules; category totals readable by later rules (gross, deductions, net). Standard codes (BASIC, GROSS, NET) are localization conventions: check the installed structure.

## Rule parameters
- Localizations commonly keep rates/thresholds as dated parameters; prefer editing them over rule code. Menu and fields: (verify in 18.0 docs: salary_rules.html).

## Related docs
- https://www.odoo.com/documentation/18.0/applications/hr/payroll/salary_attachments.html (salary adjustments)
- https://www.odoo.com/documentation/18.0/applications/hr/payroll/salaries.html
- https://www.odoo.com/documentation/18.0/applications/hr/payroll/commissions.html
- (page set captured from the newer docs index; verify each page exists in 18)

## Senior notes
- Clone a structure instead of editing shipped rules; keep customizations in a module with own xml ids to survive upgrades.
- Keep Python expressions small and deterministic; test with edge payslips.
- Accounts are set on rules/structure/journal; verify against the localization chart template.
- A rule that reads a category total needs a higher sequence than the rules in that category.
