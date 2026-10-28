# Performance and Testing (Odoo 18)

Docs: https://www.odoo.com/documentation/18.0/developer/reference/backend/performance.html — https://www.odoo.com/documentation/18.0/developer/reference/backend/testing.html

## Performance principles
- Think in batches: one query for N records. The ORM prefetches fields for the whole recordset, so iterate the original recordset (`for rec in records`) rather than rebuilding via `browse(id)`.
- N+1 patterns to hunt: `search`/`search_count`/`browse().field` inside `for`; `mapped()` on a non-prefetched set; `rec.line_ids.filtered(...)` per rec on huge relations; compute that reads other records without declaring them in `@api.depends`.
- Replace per-record counts/sums with one `_read_group(domain, ['partner_id'], ['__count', 'amount:sum'])` and a dict.
- Fetch only needed data: `search_fetch(domain, ['name','partner_id'])`, `read(['a','b'])`, `search_read` for lists, `limit`, `order`. `search_count(domain, limit=1000)` for capped counts.
- Write once: build `vals_list` then `create(vals_list)`; group records with equal values then one `write`. Avoid writing inside computes of other records.
- Stored computes: cost is paid on every dependency change; keep depends narrow, avoid depending on frequently written fields (`write_date`, counters), and avoid long dotted chains over One2many with thousands of rows. Use `store=False` + search method when search is rare.
- Indexes: `index=True` on fields used in domains/order/joins at scale (M2O foreign keys used in `search`, status, dates); `'btree_not_null'` for sparse; `'trigram'` for `ilike '%x%'`; composite via `init()` with `odoo.tools.sql.create_index` (declarative `models.Index` is Odoo 19, not 18; verify helper in 18.0 source). Check with `EXPLAIN (ANALYZE, BUFFERS)`.
- Avoid heavy `_order` on non-indexed expressions; avoid `auto_join` unless profiled; avoid `search([])` on big tables; avoid `ilike` with leading `%` without trigram.
- Large jobs: chunk with `limit` + progress (`ir.cron` `_trigger()` and the progress helper in 18; verify names), `split_every` helper (`from odoo.tools import split_every`), `with_context(prefetch_fields=False)` for wide reads, `self.env.invalidate_all()` / `cr.flush` between chunks. Use queued jobs/cron rather than blocking HTTP requests.
- Frontend: lazy-load heavy components, avoid re-render loops (do not mutate `useState` in `onPatched`), debounce RPCs, use `webSearchRead` with `specification` to fetch relational display names in one call, keep bundles lean (only declare assets in the needed bundle).

## Profiling and diagnosis
- Built-in profiler: `from odoo.tools.profiler import Profiler` / `with Profiler(): ...`; web UI profiler (Debug mode > Profiling, speedscope output; needs developer mode). Docs: https://www.odoo.com/documentation/18.0/developer/reference/backend/performance.html#profiling
- Count queries in tests: `with self.assertQueryCount(admin=12): ...` (`assertQueryCount(__system__=..)`, `assertQueryCount(default=..)`).
- Server: `--dev=all` (reload, xml, qweb, werkzeug), `--log-sql` / `--log-level=debug_sql`, `--limit-time-real`, `--workers`, `--max-cron-threads`, PostgreSQL `pg_stat_statements`, `auto_explain`.
- Logs: use `_logger = logging.getLogger(__name__)`; lazy formatting `_logger.info("x %s", v)`.

## Test framework
- Base classes (`odoo.tests`): `BaseCase`, `TransactionCase` (each test in a rolled-back savepoint over a shared class transaction), `SingleTransactionCase` (one transaction for the whole class; ordered tests), `HttpCase` (browser/tours + `url_open`, `authenticate`, `start_tour`), `ChromeBrowser` helpers. Mail/accounting suites provide extra bases (`MailCommon`, `AccountTestInvoicingCommon`, `ProductCommon`).
- File layout: `tests/__init__.py` importing `test_*.py`; module must be installed (or `-i`) and `--test-enable`. Prefer `setUpClass` with `@classmethod ... super().setUpClass()` to create fixtures once.
- Tags: `from odoo.tests import tagged`; `@tagged('post_install', '-at_install')` for tests needing all modules loaded (default is `at_install`); `@tagged('standard', ...)`; custom tags select via `--test-tags`.
- Run: `odoo-bin -d db -i my_module --test-tags /my_module --stop-after-init`; `--test-tags :TestClass.test_method`, `-at_install,post_install`, `--test-file path`. Test tag syntax: `[-][tag][/module][:class][.method]`. (verify flags in 18.0: https://www.odoo.com/documentation/18.0/developer/reference/cli.html)
- Assertions: `assertEqual/True`, `assertRecordValues(records, [{...}])` (ordered, field-by-field), `assertRaises` as context manager + `mute_logger('odoo.sql_db')`, `assertQueryCount`, `assertItemsEqual`. Use `with self.assertRaises(AccessError): rec.with_user(u).write(..)` for access tests.
- Forms: `from odoo.tests import Form` — `with Form(self.env['sale.order']) as f: f.partner_id = p; with f.order_line.new() as l: ...; rec = f.save()` runs onchanges and respects view readonly/invisible; `Form(rec, view='mod.view_xml_id')`.
- Time/data: `freezegun` (`freeze_time`), `unittest.mock.patch`, `self.env['res.users'].with_context(no_reset_password=True).create(...)`, `new_test_user(self.env, login, groups='base.group_user')` from `odoo.addons.mail.tests.common`/`odoo.tests.common`.
- Mock external HTTP (`patch('requests.post')` or the module's wrapper); never hit network in tests. Mail: `self.mock_mail_gateway()` in mail tests.
- Tours (UI): define in `static/tests/tours/*.js` registered in `web_tour.tours` (`steps: () => [{trigger, run}]`), loaded in `web.assets_tests`; run with `self.start_tour("/odoo", "tour_name", login="admin")`. Python test class must be `HttpCase` and tagged `post_install, -at_install`. In 18 the backend URL is `/odoo` (`/web` still redirects).
- JS unit tests: Hoot in `static/tests/**/*.test.js` (`describe/test/expect` from `@odoo/hoot`, mock helpers in `@web/../tests/web_test_helpers`), bundle `web.assets_unit_tests`, run in browser at `/web/tests`. (verify in 18.0: https://www.odoo.com/documentation/18.0/developer/reference/frontend/unit_testing.html)

## What a senior dev tests
- Business logic per state transition, multi-record/batch behavior, multi-company isolation, access boundary per group (positive and negative), constraints raising `ValidationError`, onchange/compute via `Form`, report render (`_render_qweb_pdf` / `_render_qweb_html`), cron method idempotence, migrations.
- Keep tests deterministic (no sleeps, no real time unless frozen), isolated (create own data via helpers), and fast (reuse class-level fixtures).
