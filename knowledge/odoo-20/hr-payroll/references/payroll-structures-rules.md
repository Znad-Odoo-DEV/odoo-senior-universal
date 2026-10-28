# Salary structures, rules, categories, inputs (Odoo 20 Payroll)

> Provenance: items marked "confirmed on 19.0" were read from the 19.0 docs. The 20.0 pages could not be fetched, so every URL below is ported from the 19.0 layout (verify in 20.0 docs).

Docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/salary_rules.html ; localizations: https://www.odoo.com/documentation/20.0/applications/hr/payroll/payroll_localizations.html
LOCALIZATION-DEPENDENT: structures and rules come from the country module; do not assume universal rules.

## Model
- Structure type (Payroll > Configuration > Structure Types) -> salary structure(s) (e.g. Regular Pay) -> salary rules. Contract sets the pay category/structure type; payslip picks the structure.
- View rules: Payroll > Configuration > Rules.

## Rule fields (confirmed on 19.0)
- Name (shown on payslip); Code (required, case-sensitive); Category; Salary Structure (required); Sequence (required, ascending: lower runs first and feeds later rules); Appears on Payslip; Contributes to Employer Cost.

## Conditions
- Always True; Salary Input (adds a dynamic field on employee, payslip, or both; unit Monetary/Quantity/Percentage/Checkbox; can depend on another input rule); Other Input (runs if a payslip line of the same input type exists); Python Expression (True/False); Domain.
- Python variables named in docs: payslip, employee, result_rules, categories, worked_days, inputs. Full list (contract/version access, rule-parameter helper): (verify in 20.0 docs: salary_rules.html and the localization module source).
- Odoo 20 removes payroll work entries: in 19 `worked_days` was built from work entries (by work entry type code). Confirm what `worked_days` and `inputs` contain in 20 and how each code is produced before reusing or cloning any rule that reads them (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/hr/payroll/salary_rules.html).

## Computation
- total = amount x quantity x (rate/100).
- Percentage: python amount, quantity expression, rate. Fixed Amount: amount, quantity expression, rate 100. Other Input: amount from matching input lines, rate 100, quantity 1.
- Section hidden when condition is Salary Input.

## Categories
- Group rules; category totals readable by later rules (gross, deductions, net). Standard codes (BASIC, GROSS, NET) are localization conventions: check the installed structure.

## Rule parameters
- Localizations commonly keep rates/thresholds as dated parameters; prefer editing them over rule code. Menu and fields: (verify in 20.0 docs: salary_rules.html).

## Related docs
- https://www.odoo.com/documentation/20.0/applications/hr/payroll/salary_attachments.html (salary adjustments)
- https://www.odoo.com/documentation/20.0/applications/hr/payroll/salaries.html
- https://www.odoo.com/documentation/20.0/applications/hr/payroll/commissions.html

## Senior notes
- Clone a structure instead of editing shipped rules; keep customizations in a module with own xml ids to survive upgrades.
- Keep Python expressions small and deterministic; test with edge payslips.
- Accounts are set on rules/structure/journal; verify against the localization chart template.
- A rule that reads a category total needs a higher sequence than the rules in that category.
- Custom rule data modules: security files are `ir.access.csv` in 20 (`id,name,model_id,group_id/id,operation,domain`), not `ir.model.access.csv`; localization rules written for 19 that reference work entry types must be re-validated.
