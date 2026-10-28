# ORM (Odoo 20)

Docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm.html — changelog: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm/changelog.html (changelog checked against 20.0)

Runtime: Python >= 3.12, PostgreSQL >= 16 (confirmed). Of the items below, only `_table_query` removed is in the 20.0 changelog; the others are unverified. Breaking in 20 for this file: public `read_group` with a new signature, `_table_query` removed, `_check_access` deprecated, tracking values removed (see "Removed and deprecated in 20" below and `v20-changes.md`).

## Recordsets and environment
- A recordset is an ordered set of ids of one model. `self.env` = (cr, uid, context, su). Access: `self.env['res.partner']`, `self.env.user`, `self.env.company`, `self.env.companies`, `self.env.context`, `self.env.ref('mod.xmlid')`, `self.env.lang`.
- Modify env immutably: `with_user(u)`, `with_company(c)`, `with_context(k=v)`, `with_env(env)`, `sudo()` / `sudo(False)`. They return new recordsets; the original is unchanged.
- Set ops: `|`, `&`, `-`, `in`, `rec1 == rec2`. `ensure_one()`, `exists()`, `mapped('a.b')`, `filtered(lambda r: ..)` or `filtered('field')`, `sorted(key=..)`, `grouped('field')` (dict of recordsets; since 18; verify in 20.0 docs: orm.html), `filtered_domain(domain)`.
- Translations in code: `from odoo import _`; prefer `self.env._("text %s", x)` (since 18, still valid in 20). Lazy: `_lt` (module-level strings). Never format before translating.

## CRUD
- `create(vals_list)`: override with `@api.model_create_multi`; returns recordset. Use `Model.create([{...}, {...}])` to batch.
- `write(vals)`: one SQL UPDATE per call for the set; avoid `write` in per-record loops when the same vals apply to all.
- `unlink()`: guard business rules with `@api.ondelete(at_uninstall=False)` methods instead of overriding `unlink`.
- `copy(default=None)` / `copy_data`; field attr `copy=False` for unique/state fields.
- `browse(ids)` is lazy and cheap; `exists()` filters deleted ids.
- Relational commands: `from odoo.fields import Command` — `Command.create(vals)`, `.update(id, vals)`, `.delete(id)`, `.unlink(id)`, `.link(id)`, `.clear()`, `.set(ids)`. Do not use the legacy tuples `(0,0,..)` in new code.
- `default_get`, `name_create`, `onchange` are framework-called; avoid calling them in business code.

## Search, domains
- `search(domain, offset=0, limit=None, order=None)`, `search_count(domain, limit=None)`, `search_fetch(domain, field_names, offset, limit, order)` (search + prefetch only the fields you need; since 17, still valid in 20), `fetch(field_names)` on an existing recordset.
- Domain = list of leaves `(field, operator, value)` with prefix `'&'`, `'|'`, `'!'`. Operators: `= != > >= < <= =? like not like ilike not ilike =like =ilike child_of parent_of in not in any not any`. `any`/`not any` for relational sub-domains: `[('line_ids', 'any', [('qty', '>', 0)])]`.
- The `Domain` class (`from odoo.fields import Domain`, introduced in 19 and still valid in 20) composes domains: `Domain('a','=',1) & Domain('b','in',[..])`, `Domain.AND([...])`, `Domain.OR([...])`, `Domain.TRUE/FALSE`. Plain lists still accepted. (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm.html)
- Prefer `ilike`/`=` on indexed columns; leading-wildcard `ilike` needs a trigram index on large tables.
- `active_test`: archived records are excluded unless `with_context(active_test=False)` or domain mentions `active`.
- Custom search for non-stored fields: `search='_search_xxx'` returning a domain, never a list of ids loops.
- Name/display search: since 17 `_search_display_name` and `_compute_display_name`; `name_get`/`_name_search` overrides are removed.

## Grouping and aggregates
- **`read_group` is public in 20 with signature `read_group(domain, groupby, aggregates, having, offset, limit, order)`.** (Unverified: the changelog lists `read_group` deprecated in favor of `_read_group` under 18.0 and nothing for 20.0.) Old calls written for the pre-20 API with `fields=` or `lazy=` BREAK: rewrite them with `groupby` specs (`'partner_id'`, `'date:month'`) and `aggregates` (`'__count'`, `'amount:sum'`, `'id:count_distinct'`, `'date:max'`). Default values of the optional arguments, the exact return format (dicts vs tuples) and the fate of `formatted_read_group`: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm.html and the changelog).
- `_read_group(domain, groupby=(), aggregates=(), having=(), offset=0, limit=None, order=None)` still returns a list of tuples in order groupby..., aggregates... Many2one groupby values come back as recordsets. `web_read_group` stays the web client's entry point. (verify unchanged in 20.0 docs)
- Old pattern to find and fix: `read_group(domain, ['amount_total:sum'], ['partner_id'], lazy=False)`; new shape: `read_group(domain, ['partner_id'], ['amount_total:sum'])`.
- Pattern: replace per-record `search_count` loops with one grouped query (`_read_group` or `read_group`) and a dict lookup.

## Computes, depends, onchange
- `@api.depends('a', 'line_ids.price')`, `@api.depends_context('company')`, `@api.onchange('f')` (UI only, never for invariants), `@api.constrains('f')` (runs on create/write of listed fields, only if field present in vals).
- Assign a compute for every record in every branch; for stored computes, assign nothing outside compute.
- Recursion: `recursive=True` with dotted depends on the parent path.

## Flush, cache, invalidation
- ORM writes are deferred; before raw SQL: `self.env['model'].flush_model(['f'])` or `flush_recordset()`; after raw SQL writing: `invalidate_model(['f'])` / `invalidate_recordset`. `env.flush_all()`, `env.invalidate_all()` are blunt tools.
- Prefetch: reading a field on one record loads it for up to PREFETCH_MAX (1000) ids of the same recordset; iterate over the full recordset, not slices rebuilt via `browse(rec.id)`.

## SQL
- Use `from odoo.tools import SQL`: `SQL("SELECT id FROM %s WHERE x = %s", SQL.identifier('t'), val)`; run `self.env.execute_query(sql)` (since 17) or `self.env.cr.execute(sql)`. Never string-format values.
- `self.env.cr.savepoint()` for recoverable sub-transactions; `self.env.cr.precommit/postcommit.add(fn)` hooks for deferred work.
- SQL-backed read models: `_table_query` is removed in 20 (see below). PostgreSQL >= 16 is the floor; re-test any hand-written SQL.

## Cron, jobs, triggers
- `ir.cron` records in XML (`model_id`, `state=code`, `code=model._cron_method()`, `interval_number/type`, `active`). Make crons idempotent and batch with limits; use `self.env['ir.cron']._commit_progress` / `_trigger()` patterns for large backlogs (introduced in 18; verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm.html). Never call `cr.commit()` outside this framework.

## Removed and deprecated in 20
- **`_table_query` removed.** Models that defined a SQL-backed table through `_table_query` must be reimplemented. Confirmed by the 20.0 changelog; it names no replacement: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm/changelog.html); the long-standing `_auto = False` plus a view created in `init()` is the fallback to validate on 20, not a promise.
- **`_check_access` deprecated** (not in the 20.0 changelog: unverified). Call `check_access(operation)`, `has_access(operation)`, `_filtered_access(operation)`; do not call or newly override `_check_access`.
- **Tracking values removed** (not in the 20.0 changelog: unverified). Chatter tracking messages are generated on the fly instead of being read back from stored tracking-value records. Code, SQL or reports that read stored tracking values must switch to the message history; whether and how `tracking=True` on fields and the `tracking_disable` / `mail_notrack` context keys behave is (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/orm/changelog.html).
- **Old-style `read_group` calls** (`fields=`, `lazy=`) break: see "Grouping and aggregates".
- **Security models**: `ir.model.access` and `ir.rule` no longer exist separately; use `ir.access` (see `security.md`).

## Context keys worth knowing
`lang`, `tz`, `active_test`, `allowed_company_ids`, `default_<field>`, `mail_notrack`, `mail_create_nolog`, `tracking_disable`, `no_reset_password`, `prefetch_fields=False`. (The tracking-related keys: see the tracking note above.)

## Anti-patterns
- `search([])` + Python filter; `len(search(..))` instead of `search_count`; `browse(id)` loops; `write` inside `for`; mutable default args; reading `self.env.user.company_id` instead of `self.env.company`; catching and passing exceptions inside ORM transaction (use savepoint); pre-20 `read_group(fields=..., lazy=...)` calls; `_table_query`; overriding `_check_access`.
