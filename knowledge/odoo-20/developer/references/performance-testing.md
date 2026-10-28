# Performance and Testing (Odoo 20)

Docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/performance.html — https://www.odoo.com/documentation/20.0/developer/reference/backend/testing.html (ported from the 19.0 layout; verify in 20.0 docs)

Runtime: Python >= 3.12, PostgreSQL >= 16 (re-run `EXPLAIN` on hot queries after moving to 16; planner behavior can differ from 13).

## Performance principles
- Think in batches: one query for N records. The ORM prefetches fields for the whole recordset, so iterate the original recordset (`for rec in records`) rather than rebuilding via `browse(id)`.
- N+1 patterns to hunt: `search`/`search_count`/`browse().field` inside `for`; `mapped()` on a non-prefetched set; `rec.line_ids.filtered(...)` per rec on huge relations; compute that reads other records without declaring them in `@api.depends`.
- Replace per-record counts/sums with one grouped query, e.g. `_read_group(domain, ['partner_id'], ['__count', 'amount:sum'])`, and a dict. The public `read_group(domain, groupby, aggregates, having, offset, limit, order)` (new signature in 20) is the dict-friendly alternative; calls with `fields=`/`lazy=` no longer work.
- Fetch only needed data: `search_fetch(domain, ['name','partner_id'])`, `read(['a','b'])`, `search_read` for lists, `limit`, `order`. `search_count(domain, limit=1000)` for capped counts.
- Write once: build `vals_list` then `create(vals_list)`; group records with equal values then one `write`. Avoid writing inside computes of other records.
- Stored computes: cost is paid on every dependency change; keep depends narrow, avoid depending on frequently written fields (`write_date`, counters), and avoid long dotted chains over One2many with thousands of rows. Use `store=False` + search method when search is rare.
- Indexes: `index=True` on fields used in domains/order/joins at scale (M2O foreign keys used in `search`, status, dates); `'btree_not_null'` for sparse; `'trigram'` for `ilike '%x%'`; composite via `models.Index(...)` (since 19, still valid in 20; verify) or `init()` SQL. Check with `EXPLAIN (ANALYZE, BUFFERS)`.
- Access cost: as record rules did in 19, an `ir.access` `domain` is expected to constrain every query a non-superuser runs on that model (verify in 20.0 docs). Keep those domains simple and indexed (company, owner); a heavy `domain` slows every list, search and read of the model.
- Avoid heavy `_order` on non-indexed expressions; avoid `auto_join` unless profiled; avoid `search([])` on big tables; avoid `ilike` with leading `%` without trigram.
- Large jobs: chunk with `limit` + progress (`ir.cron` with `_commit_progress`/`_trigger` since 18; verify in 20.0), `split_every` helper (`from odoo.tools import split_every`), `with_context(prefetch_fields=False)` for wide reads, `self.env.invalidate_all()` / `cr.flush` between chunks. Use queued jobs/cron rather than blocking HTTP requests. OCA `queue_job` has no 20.0 branch as of 2026-09-24 (re-check) — plan on `ir.cron` unless a 20.0 branch exists.
- Frontend (Owl 3): lazy-load heavy components, avoid re-render loops (do not mutate `useState` in `onPatched`), debounce RPCs, use `webSearchRead` with `specification` to fetch relational display names in one call, keep bundles lean (only declare assets in the needed bundle). Re-profile after the Owl 2 -> 3 port; rendering/reactivity internals changed (see `views-owl.md`).
- External integrations: JSON-2 `/json/2/<model>/<method>` calls are ORM calls; batch ids per call, fetch only the fields needed, and do not poll. The `db` service is gone; do not script database operations through RPC.

## Profiling and diagnosis
- Built-in profiler: `from odoo.tools.profiler import Profiler` / `with Profiler(): ...`; web UI profiler (Debug mode > Profiling, speedscope output; needs developer mode). Docs: https://www.odoo.com/documentation/20.0/developer/reference/backend/performance.html#profiling
- Count queries in tests: `with self.assertQueryCount(admin=12): ...` (`assertQueryCount(__system__=..)`, `assertQueryCount(default=..)`). Re-baseline query counts on 20 (security rewrite, ORM and framework changes can shift them).
- Server: `--dev=all` (reload, xml, qweb, werkzeug), `--log-sql` / `--log-level=debug_sql`, `--limit-time-real`, `--workers`, `--max-cron-threads`, PostgreSQL `pg_stat_statements`, `auto_explain`.
- Logs: use `_logger = logging.getLogger(__name__)`; lazy formatting `_logger.info("x %s", v)`.

## Test framework
- Base classes (`odoo.tests`): `BaseCase`, `TransactionCase` (each test in a rolled-back savepoint over a shared class transaction), `SingleTransactionCase` (one transaction for the whole class; ordered tests), `HttpCase` (browser/tours + `url_open`, `authenticate`, `start_tour`), `ChromeBrowser` helpers. Mail/accounting suites provide extra bases (`MailCommon`, `AccountTestInvoicingCommon`, `ProductCommon`).
- File layout: `tests/__init__.py` importing `test_*.py`; module must be installed (or `-i`) and `--test-enable`. Prefer `setUpClass` with `@classmethod ... super().setUpClass()` to create fixtures once.
- Tags: `from odoo.tests import tagged`; `@tagged('post_install', '-at_install')` for tests needing all modules loaded (default is `at_install`); `@tagged('standard', ...)`; custom tags select via `--test-tags`.
- Run: `odoo-bin -d db -i my_module --test-tags /my_module --stop-after-init`; `--test-tags :TestClass.test_method`, `-at_install,post_install`, `--test-file path`. Test tag syntax: `[-][tag][/module][:class][.method]`. (verify flags in 20.0: https://www.odoo.com/documentation/20.0/developer/reference/cli.html)
- Assertions: `assertEqual/True`, `assertRecordValues(records, [{...}])` (ordered, field-by-field), `assertRaises` as context manager + `mute_logger('odoo.sql_db')`, `assertQueryCount`, `assertItemsEqual`. Use `with self.assertRaises(AccessError): rec.with_user(u).write(..)` for access tests.
- Forms: `from odoo.tests import Form` — `with Form(self.env['sale.order']) as f: f.partner_id = p; with f.order_line.new() as l: ...; rec = f.save()` runs onchanges and respects view readonly/invisible; `Form(rec, view='mod.view_xml_id')`.
- Time/data: `freezegun` (`freeze_time`), `unittest.mock.patch`, `self.env['res.users'].with_context(no_reset_password=True).create(...)`, `new_test_user(self.env, login, groups='base.group_user')` from `odoo.addons.mail.tests.common`/`odoo.tests.common`.
- Mock external HTTP (`patch('requests.post')` or the module's wrapper); never hit network in tests. Mail: `self.mock_mail_gateway()` in mail tests.
- Tours (UI): define in `static/tests/tours/*.js` registered in `web_tour.tours` (`steps: () => [{trigger, run}]`), loaded in `web.assets_tests`; run with `self.start_tour("/odoo", "tour_name", login="admin")`. Python test class must be `HttpCase` and tagged `post_install, -at_install`. The backend URL is `/odoo` (since 17.2+; `/web` still redirects). Tours that click through Owl-rendered screens are the first thing the Owl 3 port will break: run them early.
- JS unit tests: Hoot in `static/tests/**/*.test.js` (`describe/test/expect` from `@odoo/hoot`, mock helpers in `@web/../tests/web_test_helpers`), run in browser at `/web/tests`. Hoot stays in 20. (verify in 20.0: https://www.odoo.com/documentation/20.0/developer/reference/frontend/unit_testing.html)
- Python 3.12 is the floor: run the suite on 3.12 in CI (stdlib modules removed in 3.12 such as `distutils`, `imp`, `asyncore`, `asynchat` break old libraries).

## What a senior dev tests
- Business logic per state transition, multi-record/batch behavior, multi-company isolation, access boundary per group (positive and negative, including each `ir.access` `domain`), constraints raising `ValidationError`, onchange/compute via `Form`, report render (`_render_qweb_pdf` / `_render_qweb_html`), cron method idempotence, migrations (including the 19 -> 20 security rewrite).
- Keep tests deterministic (no sleeps, no real time unless frozen), isolated (create own data via helpers), and fast (reuse class-level fixtures).
