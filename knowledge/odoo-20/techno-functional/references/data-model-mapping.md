# Data Model Mapping

Goal: map each business entity to an existing Odoo model before proposing a new one. ORM reference: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference.html).

## Common entity to model
- Customer/vendor/contact: res.partner (company vs person via parent_id; addresses as child contacts)
- Product/service: product.template (variants product.product), product.category
- Sales order: sale.order / sale.order.line; purchase: purchase.order / purchase.order.line
- Invoice/bill/journal entry: account.move / account.move.line; payment: account.payment
- Chart of accounts: account.account; in 20 parent accounts replace account groups (verify model/field names in 20.0 docs)
- Expense claim: in 20 expenses become draft vendor bills (account.move) (verify model-level mapping in 20.0 docs)
- Transfer/move: stock.picking / stock.move; stock.location; stock.warehouse; lots stock.lot; batch and wave picking are in `stock` in 20 (formerly `stock_picking_batch`)
- Production: mrp.production; BoM mrp.bom
- Employee: hr.employee; leave hr.leave; attendance hr.attendance; payroll work entries are removed in 20
- Project/task/timesheet: project.project, project.task, account.analytic.line; field-service work runs on Planning + Project in 20 (Field Service is discontinued)
- Lead/opportunity: crm.lead
- Users/groups/companies: res.users, res.groups, res.company
Verify exact names in the installed 20 instance (developer mode, Settings > Technical > Models).

## Method
1. Entity inventory: name, key attributes, volumes, lifecycle states, owner.
2. Match to a standard model; list missing attributes.
3. Place missing attributes: standard field reuse > properties/tags > custom field (x_ prefix in Studio) > new model.
4. Relations: many2one, one2many (with inverse), many2many; state cardinality and delete behavior (restrict, cascade, set null).
5. States: status field or stages; transitions, who triggers them, side effects.
6. Computed vs stored: stored for reporting/search/grouping; list dependencies.
7. Constraints: required, unique, validation rules, defaults.
8. Security: groups, access per model and operation (read/write/create/unlink) and row-level conditions (company, own records, team), field-level groups. In 20 these are `ir.access` rows (`id,name,model_id,group_id/id,operation,domain`): access and former record rules are one model, so specify the row filter as the `domain` of each access row.
9. Multi-company: company_id on transactional models; shared vs per-company masters.
10. Identification: external IDs and natural keys for imports (https://www.odoo.com/documentation/20.0/applications/essentials/export_import_data.html).

## Output
Table per model: field label | technical name | type | required | stored/computed | source/default | group visibility | notes. Add a relations list and a state-transition table. Add an access table: model | group | operation | row filter (domain in plain language).

## Pitfalls
- Duplicating res.partner as a custom "customer" model.
- Free text where a selection/many2one is needed (breaks reporting).
- Stored computes with undeclared dependencies; no index on large searched fields.
- Forgetting analytic accounts/tags when finance needs cost reporting.
- Modelling on structures that 20 removed: account groups, payroll work entries, a separate Field Service task model, tracking-value records.
- Writing security as separate "ACL" and "record rule" lists: in 20 they are a single `ir.access` model.
