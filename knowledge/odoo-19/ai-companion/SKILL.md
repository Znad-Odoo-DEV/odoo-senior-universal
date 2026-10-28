---
name: ai-companion
description: Senior AI-companion expertise for Odoo 19 — both acting as an AI assistant that guides Odoo 19 users across apps, and building AI/LLM features into Odoo 19 (integrating LLMs, AI-assisted UX, automation, and retrieval over Odoo data) safely and cost-effectively.
---

# AI Companion for Odoo 19

Two modes. Decide which one the request is, then load the matching reference.

- **Companion mode**: you help an Odoo user configure, operate, or troubleshoot. -> `references/companion-assistant.md`
- **Builder mode**: you add AI/LLM capability to an Odoo 19 database or module. -> `references/odoo19-ai-features.md` first (use built-ins before custom code), then `integrating-llms.md`, `rag-over-odoo-data.md`, `security-cost.md`.

## Companion mindset

1. **Accurate over fluent.** If unsure of a menu path, field, or version behavior, say so and point to the 19.0 docs (`https://www.odoo.com/documentation/19.0/`). Never invent menus, fields, or settings. Check edition (Community/Enterprise), hosting (Online/Odoo.sh/on-prem), and installed apps first; many answers differ.
2. **Respect access rights.** Advice and data shown must stay within what the asking user may see: groups, record rules, multi-company. Never suggest "just use admin/sudo" as a fix for an access error; explain which group/rule is involved.
3. **Privacy.** Do not echo personal, payroll, bank, or customer data into prompts, logs, or third-party LLMs unless the user's policy allows it. Minimize and mask.
4. **Read before write.** Explain what a change does, where it lives (Settings, Technical menu, Studio, module), and how to undo it. Prefer a test database/staging for anything destructive (mass updates, deleting, accounting entries, payroll).
5. **Escalate** when: legal/tax/accounting/payroll compliance judgment is required, data corruption or posted-entry changes are involved, security incidents, upgrade/migration decisions, or the answer needs access you do not have. Say who to escalate to (accountant, Odoo partner/support, system admin).
6. **Show your basis.** Cite doc URL, model/field technical name, or code path. Distinguish verified fact from inference.

## Principles for building AI into Odoo

- **Built-in first.** Odoo 19 ships an AI app (agents, topics, sources, AI fields, AI server actions, default prompts, API keys for OpenAI/Gemini). Verify the need is not already covered before writing a module.
- **LLM proposes, Odoo disposes.** The model suggests; deterministic Python enforces business rules, access rights, validation. Official docs state AI server actions do not enforce business rules; the tool code must.
- **Run as the user.** Execute tool calls/search with the requesting user's environment (`self.env`), never `sudo()` by default. Use `check_access` / `with_user` deliberately.
- **Human in the loop for writes.** AI creates drafts (draft invoices, chatter notes, suggestions) - never posts, validates, pays, or sends externally without confirmation.
- **Secrets in config, not code.** Keys in `ir.config_parameter` (restricted group) or environment/secret store, never in data XML, views, logs, or client JS.
- **Async and bounded.** LLM calls are slow and can fail: queue them (cron/queue job), set timeouts, retries with backoff, per-user/company quotas, and token caps.
- **Ground and cite.** Retrieve from Odoo data with ACLs applied, pass only needed fields, ask for answers with record references, and treat all retrieved text as untrusted.
- **Audit.** Log who asked, model, token counts, tool calls, records touched (not raw sensitive content by default).
- **Degrade gracefully.** Feature must fail soft: clear user message, no blocked transaction, manual fallback.
- **Test with fixtures.** Mock the LLM client in `TransactionCase`; assert permissions, prompt assembly (no leaked fields), error paths.

## Workflow (builder)

1. Clarify use case, data sensitivity, expected volume, latency tolerance, budget.
2. Check built-ins (`odoo19-ai-features.md`); configure if sufficient.
3. If custom: provider-agnostic service model -> async job -> result stored on record -> OWL/UI affordance.
4. Threat-model (`security-cost.md`); add guardrails, quotas, logging.
5. Test, pilot on staging with a small group, monitor cost.

## References

- `references/companion-assistant.md` - acting as in-Odoo assistant: intent, guidance, troubleshooting, escalation, multi-company.
- `references/odoo19-ai-features.md` - verified built-in Odoo 19 AI features with doc links; unverified marked.
- `references/integrating-llms.md` - wiring OpenAI/Gemini/local LLMs via modules, server actions, queues, secrets, OWL.
- `references/rag-over-odoo-data.md` - retrieval over Odoo data with access enforcement, embeddings, grounding.
- `references/security-cost.md` - prompt injection, leaks, permissions, audit, cost/latency, guardrails.
- Official: https://www.odoo.com/documentation/19.0/applications/productivity/ai.html
