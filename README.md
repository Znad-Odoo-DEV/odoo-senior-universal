# odoo-senior-universal

Senior **Odoo** expertise (versions **17.0, 18.0, 19.0** + upgrade guides) packaged as **AI-agnostic knowledge** with ready-made adapters. Use it with Cursor, GitHub Copilot, Windsurf, ChatGPT or any system-prompt, or any coding agent — not just one vendor.

It turns any capable assistant into a senior Odoo developer and techno-functional consultant that is **version-aware**, grounds answers in the official docs, and never invents APIs.

## What's inside

```
SYSTEM_PROMPT.md              # paste into any system prompt / custom instructions
AGENTS.md                     # agent-agnostic brief (Windsurf, Cline, Aider, …)
.github/copilot-instructions.md   # GitHub Copilot (auto-loaded for this repo)
.cursor/rules/*.mdc           # Cursor project rules (persona + per-topic)
knowledge/                    # the senior playbooks, by version and topic
  odoo-19/<topic>/SKILL.md (+ references/)
  odoo-18/<topic>/...
  odoo-17/<topic>/...
  upgrades/upgrade-17-to-18/ , upgrade-18-to-19/
```

Topics (per version): `developer`, `techno-functional`, `functional`, `implementer`, `ai-companion`, `accounting`, `inventory`, `sales-crm`, `purchase`, `manufacturing`, `hr-payroll`, `project`, `website-ecommerce`, `pos`, `studio`, `elearning`, `field-service`, `subscriptions`, `localization`.

Each topic has a concise `SKILL.md` playbook plus deeper `references/*.md`, grounded in `https://www.odoo.com/documentation/<version>/` with "(verify in <version> docs: …)" markers where a detail should be confirmed against the live page.

## Use it with your tool

### Cursor
Clone this repo (or copy `.cursor/rules/` and `knowledge/` into your project). Cursor auto-loads `.cursor/rules/*.mdc`: `00-odoo-senior.mdc` applies always; the `odoo-developer` / `odoo-functional` / `odoo-upgrades` rules attach by file type or on demand. Ask Cursor to "use the Odoo 18 developer playbook" and it will open the matching `knowledge/` file.

### GitHub Copilot
Copilot Chat auto-loads `.github/copilot-instructions.md` for this repository. To use the knowledge in another repo, copy that file (and `knowledge/`) there, or paste `SYSTEM_PROMPT.md` into Copilot Chat.

### Windsurf (and Cline / Aider / other agents)
These read `AGENTS.md`. Keep it at the repo root. Windsurf users can also point a workspace rule at `SYSTEM_PROMPT.md`. The agent should open the relevant `knowledge/odoo-<version>/<topic>/SKILL.md` for each task.

### ChatGPT / Gemini / a local model (system prompt)
Paste `SYSTEM_PROMPT.md` into the system prompt / custom-instructions field. For depth, also paste the specific `knowledge/odoo-<version>/<topic>/SKILL.md` (and the `references/*.md` it names) for the task at hand — or upload the `knowledge/` folder where the tool allows file context / retrieval.

### Any other agent
Point the agent at `SYSTEM_PROMPT.md` for the persona and at `knowledge/` for version-specific depth. The structure is plain Markdown, so retrieval/RAG over `knowledge/` works out of the box.

## How to think about versions

Odoo changes across majors; this pack keeps the versions separate so answers stay correct. Quick API map:

| Area | Odoo 17 | Odoo 18 | Odoo 19 |
|---|---|---|---|
| List view root | `<tree>` | `<list>` | `<list>` |
| Chatter | `<div class="oe_chatter">` | `<chatter/>` | `<chatter/>` |
| Access API | `check_access_rights`/`_rule` | `check_access`/`has_access` | `check_access`/`has_access` |
| Security field | `groups_id` | `groups_id` | `group_ids` (+ `res.groups.privilege`) |
| SQL constraints | `_sql_constraints` | `_sql_constraints` | declarative `models.Constraint`/`Index` |
| Translations | `_()` / `_lt()` | `self.env._()` | `self.env._()` |
| JS tests / public JS | QUnit / `publicWidget` | Hoot / `Interaction` | Hoot / `Interaction` |
| External API | XML-RPC / JSON-RPC | XML-RPC / JSON-RPC | `/json/2/<model>/<method>` |
| Built-in AI app | — | — | yes |

Always confirm edition (Community/Enterprise) and hosting (Online / Odoo.sh / on-premise) too.

## Scope & accuracy

Grounded in the official Odoo documentation for each version. Details that should be re-checked against the live docs are flagged with "(verify …)" markers — treat those as prompts to confirm, especially for compliance-sensitive areas (accounting, payroll, tax, localization). This pack is independent and not affiliated with Odoo S.A.
