# Built-in Odoo 20 AI features

Base: https://www.odoo.com/documentation/20.0/applications/productivity/ai.html
The built-in AI app (agents, topics, tools, sources, AI fields, AI server actions, default prompts, provider API keys) was introduced in Odoo 19 and carries forward to Odoo 20. This file keeps the findings read on the 19.0 pages; every sub-page URL below is ported from the 19.0 layout, so confirm it on 20.0 before quoting UI paths, field names or limits. Confirmed on the 20.0 AI page (https://www.odoo.com/documentation/20.0/applications/productivity/ai.html): AI icon / Ctrl+K access, conversations open in Discuss, AI agents (System Prompt, skills, sources), AI fields, AI server actions, AI document sort, AI in email templates, voice transcription, image generation, AI in Live Chat, and an AI MCP server so an external agent can connect to Odoo. Built-in AI requests go through Odoo's In-App Purchase (IAP) service and consume IAP credits. Installing the AI app on the Standard plan triggers an upsell to the Custom plan. The page names no specific LLM providers.
Status legend: CARRIED FROM 19 = content read on the cited 19.0 page and carried forward; re-confirm on the 20.0 page. LISTED = page appears in the official AI index but contents not read here; confirm before asserting details.

## CARRIED FROM 19 (read on 19.0 pages; re-confirm on 20.0)

### Ask AI / AI button
- Open via command palette (Ctrl+K) or the AI icon at the top of the screen (confirmed on 20.0); prompts vary by location. Reply can be sent as message, logged as chatter note, or copied; conversation can open in Discuss.
- Read-only behavior (19): it can open views and show reports but cannot create or alter records. In 20 the Update Records / Create Records topics exist, so changes are possible through agents (verify exact behavior of the built-in assistant in 20.0 docs).
- Doc: https://www.odoo.com/documentation/20.0/applications/productivity/ai.html

### AI agents, topics, tools, sources
- Requires the AI app. Agent = System Prompt, skills, sources, "Restrict to Sources" (confirmed on 20.0). LLM model choice and Response Style (Analytical / Balanced / Creative) are carried from 19 and not seen on the 20.0 page (verify in 20.0 docs).
- In 20 the docs call the bundles skills (Instructions + Tools); the preconfigured ones are listed as topics: View Builder, Information retrieval, Update Records, Create Records, Generate Images, Web Search, Website Builder, Create Leads (needs CRM). Natural Language Search from 19 is not in the 20.0 list. An agent with no skills can only give information and cannot change the database. Agents can be triggered by automated and scheduled actions.
- Tools = functions (create lead, open view); available set depends on installed apps.
- Sources: PDFs, web links, Documents files, Knowledge articles; files attached during a conversation act as temporary sources unless added to the agent (confirmed on 20.0). "Indexed" status / Active toggle: carried from 19.
- Test button opens a conversation to try the agent.
- Doc: https://www.odoo.com/documentation/20.0/applications/productivity/ai/agents.html

### API keys / providers
- Providers: OpenAI (ChatGPT) and Google Gemini. Path: AI app > Configuration > Settings > Providers; tick "Use your own ... account", paste Key, Save.
- Odoo.sh and on-premise must use own API keys; Odoo Online optional. Provider fees apply.
- The 20.0 API keys page is marked "under construction" and lists no providers or paths, so the provider claims above remain unverified (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/productivity/ai/apikeys.html).

### AI server actions
- Server action with Type = AI (Settings > Technical > Server Actions). Fields: Model, Prompt, Tools.
- Each tool is a normal server action with "Use in AI" enabled (Usage tab), same model. "AI Schema" declares allowed arguments; names must match variables in the tool's Python code.
- The AI only picks tool + args; it does not enforce business rules - code them in the tool. Tools run under Odoo's access control, which in 20 is `ir.access` (access rights and record-rule domains merged).
- Doc: https://www.odoo.com/documentation/20.0/applications/productivity/ai/server-actions.html (verify in 20.0 docs)

### AI fields
- Generate/suggest values from record context. Types: Text, Multiline, HTML, Integer, Decimal, Monetary, Date, Datetime, Checkbox, Many2one, Tags. Created in Studio (AI Field, `/field` to reference fields) or on Property fields (Edit Properties > AI; form views only).
- AI icon computes/refreshes; a daily scheduled action fills only empty text and property AI fields (Settings > Technical > Automation).
- Studio may affect pricing plan.
- Doc: https://www.odoo.com/documentation/20.0/applications/productivity/ai/fields.html (verify in 20.0 docs)

## LISTED (exist in the 19.0 index; details unverified, and not re-checked for 20)

Base path `https://www.odoo.com/documentation/20.0/applications/productivity/ai/` (ported from the 19.0 layout)
- Default prompts - `default_prompts.html` (index describes: preconfigured prompts, editable in AI app).
- AI document sort - `document_sort.html` (verify in 20.0 docs: that URL).
- AI live chat - `live-chat.html` (verify in 20.0 docs: that URL).
- AI in email templates - `email-templates.html` (verify in 20.0 docs: that URL).
- AI voice transcription - `voice.html` (verify in 20.0 docs: that URL).
- Write and improve text with AI - `improve_text.html` (verify in 20.0 docs: that URL).
- AI in support workflows - `support_operations.html` (verify in 20.0 docs: that URL).

## NOT verified - do not assert
- Anything new or changed in the AI app in 20 (features, UI paths, model lists, limits): (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/productivity/ai.html and the release notes https://www.odoo.com/odoo-20-release-notes).
- Support for providers other than OpenAI and Gemini (for example local models) in the built-in AI app: (verify in 20.0 docs: .../ai/apikeys.html). For any other provider or a local endpoint, use a custom module (`integrating-llms.md`).
- Edition/plan/licensing requirements and per-feature credit/pricing: (verify in 20.0 docs: .../ai.html and your subscription).
- Exact technical model names (`ai.agent`, etc.) and Python APIs for custom tools: inspect the installed `ai` module source of your 20.0 build instead of guessing.
## Decision guide
- Need Q&A over company docs -> agent + Sources (Knowledge/Documents), Restrict to Sources on.
- Need field autofill/summary -> AI field.
- Need record-triggered action chosen by AI -> AI server action with narrow tools, rules in Python.
- Need other LLM provider, custom retrieval, streaming UI, or workflow beyond the above -> custom module (`integrating-llms.md`).
