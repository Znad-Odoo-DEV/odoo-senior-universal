# Data Model Mapping

Goal: map each business entity to an existing Odoo model before proposing a new one. ORM reference: (verify in 18.0 docs: https://www.odoo.com/documentation/18.0/developer/reference.html).

## Common entity to model
- Customer/vendor/contact: res.partner (company vs person via parent_id; addresses as child contacts)
- Product/service: product.template (variants product.product), product.category
- Sales order: sale.order / sale.order.line; purchase: purchase.order / purchase.order.line
- Invoice/bill/journal entry: account.move / account.move.line; payment: account.payment
- Transfer/move: stock.picking / stock.move; stock.location; stock.warehouse; lots stock.lot
- Production: mrp.production; BoM mrp.bom
- Employee: hr.employee; leave hr.leave; attendance hr.attendance
- Project/task/timesheet: project.project, project.task, account.analytic.line
- Lead/opportunity: crm.lead
- Users/groups/companies: res.users, res.groups (a user's groups are in `groups_id` on 18), res.company
Verify exact names in the installed 18 instance (developer mode, Settings > Technical > Models).

## Method
1. Entity inventory: name, key attributes, volumes, lifecycle states, owner.
2. Match to a standard model; list missing attributes.
3. Place missing attributes: standard field reuse > properties/tags > custom field (x_ prefix in Studio) > new model.
4. Relations: many2one, one2many (with inverse), many2many; state cardinality and delete behavior (restrict, cascade, set null).
5. States: status field or stages; transitions, who triggers them, side effects.
6. Computed vs stored: stored for reporting/search/grouping; list dependencies.
7. Constraints: required, unique, validation rules, defaults.
8. Security: groups, access rights per model (read/write/create/unlink), record rules (company, own records, team), field-level groups.
9. Multi-company: company_id on transactional models; shared vs per-company masters.
10. Identification: external IDs and natural keys for imports (https://www.odoo.com/documentation/18.0/applications/essentials/export_import_data.html).

## Output
Table per model: field label | technical name | type | required | stored/computed | source/default | group visibility | notes. Add a relations list and a state-transition table.

## Pitfalls
- Duplicating res.partner as a custom "customer" model.
- Free text where a selection/many2one is needed (breaks reporting).
- Stored computes with undeclared dependencies; no index on large searched fields.
- Forgetting analytic accounts/tags when finance needs cost reporting.
