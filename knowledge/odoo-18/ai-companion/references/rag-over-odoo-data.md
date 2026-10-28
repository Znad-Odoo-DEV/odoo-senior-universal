# Retrieval over Odoo data (RAG) with access enforcement

Odoo 18 has no built-in agents or Sources, so retrieval is custom or comes from an Apps-store module (`odoo18-ai-approach.md`). Typical corpora: Knowledge articles and Documents files (Enterprise), tickets, products, chatter, attachments. Docs index: https://www.odoo.com/documentation/18.0/applications/productivity.html

## Core rule
Retrieval must be filtered by what the REQUESTING user may read, at query time. Never answer from a shared index that bypasses record rules.

## Architecture options
1. **Live ORM retrieval (safest, start here)**: translate question -> structured search (fixed model allowlist + templated domains) -> `env[model].with_user(user).search_read(domain, fields, limit)`. ACLs and record rules apply automatically. Good for structured questions (orders, partners, stock).
2. **Vector index + post-filter**: index chunks with metadata; at query get top-K candidates, then re-check each via ORM as the user (`records = env[model].with_user(user).browse(ids).exists()` then `records._filtered_access('read')` or `has_access('read')` per record; drop failures). Over-fetch K (3-5x) to survive filtering.
3. **Per-ACL partitions**: store `company_id`, `res_model`, `res_id`, and an ACL signature (group ids / team) on chunks; pre-filter in the vector query, then still post-verify through ORM. Metadata filters alone are not authorization.

## Index storage
- PostgreSQL `pgvector` (extension must be installable on your host; not available on all managed/Odoo.sh setups - verify) with `Vector` column via raw SQL/custom field, HNSW or IVFFlat index; or an external vector DB reached over TLS with per-company namespaces.
- Chunk table: `res_model, res_id, company_id, chunk_idx, text_hash, embedding, write_date_src, lang`. Text stored only if needed; prefer storing ids and re-reading live content at answer time (avoids stale/leaked copies).
- Keep embeddings, which can leak content, under the same access and backup policy as source data. Delete chunks when source is unlinked/archived (`unlink`/`write` hooks or nightly reconcile).

## Embedding pipeline
- Chunk 200-500 tokens with overlap ~10%, by record structure (one record = title + key fields), not raw HTML. Strip HTML (`tools.html2plaintext`), signatures, quoted email threads.
- Trigger: cron picks records where `write_date > last_indexed` (incremental); batch API calls; store `text_hash` to skip unchanged; cap per-run spend.
- Never index fields you would not show broadly unless partitioned: salaries, bank accounts, IDs, health/HR notes, passwords, private chatter (`mail.message` with internal subtype) - exclude by default allowlist of fields.
- Multi-company: one embedding per company-visible record; filter `company_id in user.company_ids` (or allowed_company_ids from context) and null-company rules explicitly.
- Multi-language: record `lang`, embed in source language with a multilingual model; don't mix models in one index.

## Query flow
1. Authenticate: take `self.env.user` (not a service user). Reject if portal/public unless explicitly designed.
2. Rewrite query (optional, cheap model). Embed. Search top-K with company/model filter.
3. Post-verify access via ORM as user; drop failures silently (don't reveal existence).
4. Rerank (optional), keep top 4-8 chunks within a token budget.
5. Build prompt: system rules + clearly delimited context blocks, each with `[model:id]` ref.
6. Ask for answer + citations restricted to supplied refs; validate refs server-side; render as links (`/odoo/<model>/<id>` style - verify URL format on 18.0) only if user can open them.
7. If context is insufficient: say so ("not found in records you can access") instead of guessing.

## Grounding
- "Answer only from the context; if absent say you don't know." Low temperature. Return structured JSON for machine consumption and validate with a schema.
- Verify numbers: when answer includes amounts/dates, recompute via ORM/`_read_group` rather than trusting the LLM arithmetic.
- Show sources to the user; log retrieved ids.

## Avoiding leaks
- Prompt context contains only records passing the user check; no cross-user caches of answers (cache key includes user/company/ACL signature, or cache only retrieval ids of public data).
- Don't include IDs/names of inaccessible records in error messages or "did you mean".
- Treat retrieved text as untrusted (indirect prompt injection): see `security-cost.md`. Don't let retrieved content select tools or change instructions.
- Provider data policy: confirm retention/training opt-out and region for any third-party embedding/LLM API; redact PII (emails, phones, IBAN) before sending when not needed.
- Delete/GDPR: on partner erasure, purge their chunks and cached answers.

## Evaluation
Golden Q/A set per app; measure recall@K, citation validity, and a leak test: user A without rights asks about user B's records -> must return nothing. Automate in `TransactionCase` with two users in different groups/companies.
