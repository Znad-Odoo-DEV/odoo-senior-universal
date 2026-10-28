# Salary structures, rules, categories, inputs (Odoo 17 Payroll)

Docs: https://www.odoo.com/documentation/17.0/applications/hr/payroll/salary_rules.html ; localizations: https://www.odoo.com/documentation/17.0/applications/hr/payroll/payroll_localizations.html
LOCALIZATION-DEPENDENT: structures and rules come from the country module; do not assume universal rules.

## Model
- Structure type (Payroll > Configuration > Structure Types) -> salary structure(s) (e.g. Regular Pay) -> salary rules. Contract sets the salary structure type; payslip picks the structure.
- View rules: Payroll > Configuration > Rules.

## Rule fields (verify labels in 17.0)
- Name (shown on payslip); Code (required, case-sensitive); Category; Salary Structure (required); Sequence (required, ascending: lower runs first and feeds later rules); Appears on Payslip; employer-cost / payroll-report flags (labelled differently across versions, e.g. Contributes to Employer Cost vs Appears on Employer Cost Dashboard).

## Conditions
- Condition Based on (17.0 model): Always True; Range (a Python-evaluated base value within min/max); Python Expression (True/False). The Salary Input / Other Input / Domain condition types in the 19.0 docs are newer; verify before using them in 17.0.
- Inputs in 17: Other Input Types (Payroll > Configuration) define input codes; payslip Other Inputs lines are read by rules via `inputs.CODE.amount`.
- Python variables commonly available in 17 rules: payslip, employee, contract, categories, rules, result_rules, worked_days, inputs. Full list (rule-parameter helper, same-type input lines): (verify in 17.0 docs: salary_rules.html and the localization module source).

## Computation
- total = amount x quantity x (rate/100).
- Amount types: Fixed Amount (amount, quantity expression, rate 100); Percentage (%) (base, quantity, percentage); Python Code (set `result`, optionally `result_qty`, `result_rate`).
- Rules that depend on other inputs read them through `inputs`, `worked_days`, `categories` and `rules` rather than hard-coded values.

## Categories
- Group rules; category totals readable by later rules (gross, deductions, net). Standard codes (BASIC, GROSS, NET) are localization conventions: check the installed structure.

## Rule parameters
- Localizations commonly keep rates/thresholds as dated parameters (Payroll > Configuration > Rule Parameters); prefer editing them over rule code. Menu and fields: (verify in 17.0 docs: salary_rules.html).

## Related docs
- https://www.odoo.com/documentation/17.0/applications/hr/payroll/salary_attachments.html (salary adjustments)
- https://www.odoo.com/documentation/17.0/applications/hr/payroll/salaries.html
- https://www.odoo.com/documentation/17.0/applications/hr/payroll/commissions.html (verify these pages exist in 17.0)

## Senior notes
- Clone a structure instead of editing shipped rules; keep customizations in a module with own xml ids to survive upgrades.
- Keep Python expressions small and deterministic; test with edge payslips.
- Accounts are set on rules/structure/journal; verify against the localization chart template.
- A rule that reads a category total needs a higher sequence than the rules in that category.
