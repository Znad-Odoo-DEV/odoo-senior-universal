# ORM (Odoo 17)

Docs: https://www.odoo.com/documentation/17.0/developer/reference/backend/orm.html — changelog: https://www.odoo.com/documentation/17.0/developer/reference/backend/orm/changelog.html

## Recordsets and environment
- A recordset is an ordered set of ids of one model. `self.env` = (cr, uid, context, su). Access: `self.env['res.partner']`, `self.env.user`, `self.env.company`, `self.env.companies`, `self.env.context`, `self.env.ref('mod.xmlid')`, `self.env.lang`.
- Modify env immutably: `with_user(u)`, `with_company(c)`, `with_context(k=v)`, `with_env(env)`, `sudo()` / `sudo(False)`. They return new recordsets; the original is unchanged.
- Set ops: `|`, `&`, `-`, `in`, `rec1 == rec2`. `ensure_one()`, `exists()`, `mapped('a.b')`, `filtered(lambda r: ..)` or `filtered('field')`, `sorted(key=..)`, `filtered_domain(domain)`. No `grouped()` helper in 17 (added in 18): use `collections.defaultdict`, `itertools.groupby` over a sorted set, or `_read_group`.
- Translations in code: `from odoo import _, _lt`; `_("text %s", x)` inside methods (the language comes from the calling frame's `self.env`/`context`), `_lt("text")` for module/class-level strings evaluated at import time. Never format before translating. (`self.env._()` is Odoo 18+; do not use it on 17.)

## CRUD
- `create(vals_list)`: override with `@api.model_create_multi`; returns recordset. Use `Model.create([{...}, {...}])` to batch.
- `write(vals)`: one SQL UPDATE per call for the set; avoid `write` in per-record loops when the same vals apply to all.
- `unlink()`: guard business rules with `@api.ondelete(at_uninstall=False)` methods instead of overriding `unlink`.
- `copy(default=None)` / `copy_data`; field attr `copy=False` for unique/state fields.
- `browse(ids)` is lazy and cheap; `exists()` filters deleted ids.
- Relational commands: `from odoo.fields import Command` — `Command.create(vals)`, `.update(id, vals)`, `.delete(id)`, `.unlink(id)`, `.link(id)`, `.clear()`, `.set(ids)`. Do not use the legacy tuples `(0,0,..)` in new code.
- `default_get`, `name_create`, `onchange` are framework-called; avoid calling them in business code.

## Search, domains
- `search(domain, offset=0, limit=None, order=None)`, `search_count(domain, limit=None)`, `search_fetch(domain, field_names, offset, limit, order)` (search + prefetch only the fields you need; new in 17), `fetch(field_names)` on an existing recordset (17).
- Domain = list of leaves `(field, operator, value)` with prefix `'&'`, `'|'`, `'!'`. Operators: `= != > >= < <= =? like not like ilike not ilike =like =ilike child_of parent_of in not in any not any`. `any`/`not any` for relational sub-domains: `[('line_ids', 'any', [('qty', '>', 0)])]`.
- Domains in 17 are plain lists of tuples. Compose with `from odoo.osv import expression`: `expression.AND([d1, d2])`, `expression.OR([d1, d2])`, `expression.normalize_domain(d)`. (A composable `Domain` class exists only in Odoo 19; do not use it on 17.)
- Prefer `ilike`/`=` on indexed columns; leading-wildcard `ilike` needs a trigram index on large tables.
- `active_test`: archived records are excluded unless `with_context(active_test=False)` or domain mentions `active`.
- Custom search for non-stored fields: `search='_search_xxx'` returning a domain, never a list of ids loops.
- Name/display search: 17 computes `display_name` in `_compute_display_name` (`name_get` is gone) and name searching goes through `_search_display_name`, which replaces the old `_name_search` override style. (verify the exact hook on your 17.0 build: https://www.odoo.com/documentation/17.0/developer/reference/backend/orm/changelog.html; some 17.0 core models still implement name search via `_name_search` / `_rec_names_search`.)

## Grouping and aggregates
- `_read_group(domain, groupby=(), aggregates=(), having=(), offset=0, limit=None, order=None)` (tuple API, new in 17) returns list of tuples in order groupby..., aggregates... — aggregates like `'__count'`, `'amount:sum'`, `'id:count_distinct'`, `'date:max'`. Many2one groupby values come back as recordsets; date groupby: `'date:month'`.
- Public `read_group(...)` returning dicts is the legacy API: still what the web client calls (with `web_read_group`), but for server code prefer `_read_group`; `formatted_read_group` is the dict-output successor (formalized in 18; verify availability on your 17.0 build: https://www.odoo.com/documentation/17.0/developer/reference/backend/orm.html).
- Pattern: replace per-record `search_count` loops with one `_read_group` and a dict lookup.

## Computes, depends, onchange
- `@api.depends('a', 'line_ids.price')`, `@api.depends_context('company')`, `@api.onchange('f')` (UI only, never for invariants), `@api.constrains('f')` (runs on create/write of listed fields, only if field present in vals).
- Assign a compute for every record in every branch; for stored computes, assign nothing outside compute.
- Recursion: `recursive=True` with dotted depends on the parent path.

## Flush, cache, invalidation
- ORM writes are deferred; before raw SQL: `self.env['model'].flush_model(['f'])` or `flush_recordset()`; after raw SQL writing: `invalidate_model(['f'])` / `invalidate_recordset`. `env.flush_all()`, `env.invalidate_all()` are blunt tools. (The pre-16 `flush()` / `invalidate_cache()` are gone.)
- Prefetch: reading a field on one record loads it for up to PREFETCH_MAX (1000) ids of the same recordset; iterate over the full recordset, not slices rebuilt via `browse(rec.id)`.

## SQL
- Use `from odoo.tools import SQL` (new in 17): `SQL("SELECT id FROM %s WHERE x = %s", SQL.identifier('t'), val)`; run `self.env.execute_query(sql)` or `self.env.cr.execute(sql)`. Never string-format values. (verify `execute_query` on your build)
- `self.env.cr.savepoint()` for recoverable sub-transactions; `self.env.cr.precommit/postcommit.add(fn)` hooks for deferred work.

## Cron, jobs, triggers
- `ir.cron` records in XML (`model_id`, `state=code`, `code=model._cron_method()`, `interval_number/type`, `numbercall` (`-1` = unlimited), `doall`, `active`). `numbercall`/`doall` exist in 17 and are dropped in 18.
- Make crons idempotent and batch with limits; process a bounded chunk per run and re-schedule with `self.env.ref('mod.cron_xmlid')._trigger()` while a backlog remains (`_trigger()` exists in 17; the `_commit_progress` helper is 18+, verify: https://www.odoo.com/documentation/17.0/developer/reference/backend/orm.html). A per-chunk `cr.commit()` is tolerated inside cron methods only, never in request/ORM code paths.

## Context keys worth knowing
`lang`, `tz`, `active_test`, `allowed_company_ids`, `default_<field>`, `mail_notrack`, `mail_create_nolog`, `tracking_disable`, `no_reset_password`, `prefetch_fields=False`.

## Anti-patterns
- `search([])` + Python filter; `len(search(..))` instead of `search_count`; `browse(id)` loops; `write` inside `for`; mutable default args; reading `self.env.user.company_id` instead of `self.env.company`; catching and passing exceptions inside ORM transaction (use savepoint).
