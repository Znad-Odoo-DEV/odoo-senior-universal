# ORM (Odoo 19)

Docs: https://www.odoo.com/documentation/19.0/developer/reference/backend/orm.html — changelog: https://www.odoo.com/documentation/19.0/developer/reference/backend/orm/changelog.html

## Recordsets and environment
- A recordset is an ordered set of ids of one model. `self.env` = (cr, uid, context, su). Access: `self.env['res.partner']`, `self.env.user`, `self.env.company`, `self.env.companies`, `self.env.context`, `self.env.ref('mod.xmlid')`, `self.env.lang`.
- Modify env immutably: `with_user(u)`, `with_company(c)`, `with_context(k=v)`, `with_env(env)`, `sudo()` / `sudo(False)`. They return new recordsets; the original is unchanged.
- Set ops: `|`, `&`, `-`, `in`, `rec1 == rec2`. `ensure_one()`, `exists()`, `mapped('a.b')`, `filtered(lambda r: ..)` or `filtered('field')`, `sorted(key=..)`, `grouped('field')` (dict of recordsets; v18+; verify in 19.0 docs: orm.html), `filtered_domain(domain)`.
- Translations in code: `from odoo import _`; in v18+ prefer `self.env._("text %s", x)`. Lazy: `_lt` (module-level strings). Never format before translating.

## CRUD
- `create(vals_list)`: override with `@api.model_create_multi`; returns recordset. Use `Model.create([{...}, {...}])` to batch.
- `write(vals)`: one SQL UPDATE per call for the set; avoid `write` in per-record loops when the same vals apply to all.
- `unlink()`: guard business rules with `@api.ondelete(at_uninstall=False)` methods instead of overriding `unlink`.
- `copy(default=None)` / `copy_data`; field attr `copy=False` for unique/state fields.
- `browse(ids)` is lazy and cheap; `exists()` filters deleted ids.
- Relational commands: `from odoo.fields import Command` — `Command.create(vals)`, `.update(id, vals)`, `.delete(id)`, `.unlink(id)`, `.link(id)`, `.clear()`, `.set(ids)`. Do not use the legacy tuples `(0,0,..)` in new code.
- `default_get`, `name_create`, `onchange` are framework-called; avoid calling them in business code.

## Search, domains
- `search(domain, offset=0, limit=None, order=None)`, `search_count(domain, limit=None)`, `search_fetch(domain, field_names, offset, limit, order)` (search + prefetch only the fields you need; v17+), `fetch(field_names)` on an existing recordset.
- Domain = list of leaves `(field, operator, value)` with prefix `'&'`, `'|'`, `'!'`. Operators: `= != > >= < <= =? like not like ilike not ilike =like =ilike child_of parent_of in not in any not any`. `any`/`not any` for relational sub-domains: `[('line_ids', 'any', [('qty', '>', 0)])]`.
- Odoo 19 introduces a `Domain` class (`from odoo.fields import Domain`) for composing domains: `Domain('a','=',1) & Domain('b','in',[..])`, `Domain.AND([...])`, `Domain.OR([...])`, `Domain.TRUE/FALSE`. Plain lists still accepted. (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/developer/reference/backend/orm.html)
- Prefer `ilike`/`=` on indexed columns; leading-wildcard `ilike` needs a trigram index on large tables.
- `active_test`: archived records are excluded unless `with_context(active_test=False)` or domain mentions `active`.
- Custom search for non-stored fields: `search='_search_xxx'` returning a domain, never a list of ids loops.
- Name/display search: v17+ uses `_search_display_name` and `_compute_display_name`; `name_get`/`_name_search` overrides are removed.

## Grouping and aggregates
- `_read_group(domain, groupby=(), aggregates=(), having=(), offset=0, limit=None, order=None)` returns list of tuples in order groupby..., aggregates... — aggregates like `'__count'`, `'amount:sum'`, `'id:count_distinct'`, `'date:max'`. Many2one groupby values come back as recordsets; date groupby: `'date:month'`.
- Public `read_group(...)` returning dicts is the legacy API, deprecated since 18 in favor of `_read_group` for code and `formatted_read_group` for dict output (`web_read_group` for the web client). Verify exact 19 behavior: https://www.odoo.com/documentation/19.0/developer/reference/backend/orm.html
- Pattern: replace per-record `search_count` loops with one `_read_group` and a dict lookup.

## Computes, depends, onchange
- `@api.depends('a', 'line_ids.price')`, `@api.depends_context('company')`, `@api.onchange('f')` (UI only, never for invariants), `@api.constrains('f')` (runs on create/write of listed fields, only if field present in vals).
- Assign a compute for every record in every branch; for stored computes, assign nothing outside compute.
- Recursion: `recursive=True` with dotted depends on the parent path.

## Flush, cache, invalidation
- ORM writes are deferred; before raw SQL: `self.env['model'].flush_model(['f'])` or `flush_recordset()`; after raw SQL writing: `invalidate_model(['f'])` / `invalidate_recordset`. `env.flush_all()`, `env.invalidate_all()` are blunt tools.
- Prefetch: reading a field on one record loads it for up to PREFETCH_MAX (1000) ids of the same recordset; iterate over the full recordset, not slices rebuilt via `browse(rec.id)`.

## SQL
- Use `from odoo.tools import SQL`: `SQL("SELECT id FROM %s WHERE x = %s", SQL.identifier('t'), val)`; run `self.env.execute_query(sql)` (v17+) or `self.env.cr.execute(sql)`. Never string-format values.
- `self.env.cr.savepoint()` for recoverable sub-transactions; `self.env.cr.precommit/postcommit.add(fn)` hooks for deferred work.

## Cron, jobs, triggers
- `ir.cron` records in XML (`model_id`, `state=code`, `code=model._cron_method()`, `interval_number/type`, `active`). Make crons idempotent and batch with limits; use `self.env['ir.cron']._commit_progress` / `_trigger()` patterns for large backlogs (verify in 19.0 docs: https://www.odoo.com/documentation/19.0/developer/reference/backend/orm.html). Never call `cr.commit()` outside this framework.

## Context keys worth knowing
`lang`, `tz`, `active_test`, `allowed_company_ids`, `default_<field>`, `mail_notrack`, `mail_create_nolog`, `tracking_disable`, `no_reset_password`, `prefetch_fields=False`.

## Anti-patterns
- `search([])` + Python filter; `len(search(..))` instead of `search_count`; `browse(id)` loops; `write` inside `for`; mutable default args; reading `self.env.user.company_id` instead of `self.env.company`; catching and passing exceptions inside ORM transaction (use savepoint).
