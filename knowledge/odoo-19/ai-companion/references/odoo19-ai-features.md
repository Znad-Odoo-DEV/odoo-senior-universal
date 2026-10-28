# Built-in Odoo 19 AI features

Base: https://www.odoo.com/documentation/19.0/applications/productivity/ai.html
Status legend: VERIFIED = content read on the cited page. LISTED = page appears in the official AI index but contents not read here; confirm before asserting details.

## VERIFIED

### Ask AI / AI button
- Open via command palette (Ctrl+K) or the AI button top-right; prompts vary by location. Reply can be sent as message, logged as chatter note, or copied; conversation can open in Discuss.
- Read-only behavior: it can open views and show reports but cannot create or alter records.
- Doc: ai.html (above).

### AI agents, topics, tools, sources
- Requires the AI app. Agent = name, description, LLM model (versions of ChatGPT and Gemini), Response Style (Analytical / Balanced / Creative), System Prompt, "Restrict to Sources".
- Topics bundle instructions + tools. Preconfigured: Natural Language Search, Information retrieval, Create Leads (needs CRM). An agent with no topics can only give information.
- Tools = functions (create lead, open view); available set depends on installed apps.
- Sources: PDFs, web links, Documents files, Knowledge articles; usable once status is Indexed and Active is on.
- Test button opens a conversation to try the agent.
- Doc: https://www.odoo.com/documentation/19.0/applications/productivity/ai/agents.html

### API keys / providers
- Providers: OpenAI (ChatGPT) and Google Gemini. Path: AI app > Configuration > Settings > Providers; tick "Use your own ... account", paste Key, Save.
- Odoo.sh and on-premise must use own API keys; Odoo Online optional. Provider fees apply.
- Doc: https://www.odoo.com/documentation/19.0/applications/productivity/ai/apikeys.html

### AI server actions
- Server action with Type = AI (Settings > Technical > Server Actions). Fields: Model, Prompt, Tools.
- Each tool is a normal server action with "Use in AI" enabled (Usage tab), same model. "AI Schema" declares allowed arguments; names must match variables in the tool's Python code.
- The AI only picks tool + args; it does not enforce business rules - code them in the tool.
- Doc: https://www.odoo.com/documentation/19.0/applications/productivity/ai/server-actions.html

### AI fields
- Generate/suggest values from record context. Types: Text, Multiline, HTML, Integer, Decimal, Monetary, Date, Datetime, Checkbox, Many2one, Tags. Created in Studio (AI Field, `/field` to reference fields) or on Property fields (Edit Properties > AI; form views only).
- AI icon computes/refreshes; a daily scheduled action fills only empty text and property AI fields (Settings > Technical > Automation).
- Studio may affect pricing plan.
- Doc: https://www.odoo.com/documentation/19.0/applications/productivity/ai/fields.html

## LISTED (exist in the 19.0 index; details unverified)

Base path `https://www.odoo.com/documentation/19.0/applications/productivity/ai/`
- Default prompts - `default_prompts.html` (index describes: preconfigured prompts, editable in AI app).
- AI document sort - `document_sort.html` (verify in 19.0 docs: that URL).
- AI live chat - `live-chat.html` (verify in 19.0 docs: that URL).
- AI in email templates - `email-templates.html` (verify in 19.0 docs: that URL).
- AI voice transcription - `voice.html` (verify in 19.0 docs: that URL).
- Write and improve text with AI - `improve_text.html` (verify in 19.0 docs: that URL).
- AI in support workflows - `support_operations.html` (verify in 19.0 docs: that URL).

## NOT verified - do not assert
- Support for providers other than OpenAI/Gemini (e.g. Gemini, local models) in the built-in AI app: (verify in 19.0 docs: .../ai/apikeys.html).
- Edition/plan/licensing requirements and per-feature credit/pricing: (verify in 19.0 docs: .../ai.html and your subscription).
- Exact technical model names (`ai.agent`, etc.) and Python APIs for custom tools: inspect the installed `ai` module source of your 19.0 build instead of guessing.

## Decision guide
- Need Q&A over company docs -> agent + Sources (Knowledge/Documents), Restrict to Sources on.
- Need field autofill/summary -> AI field.
- Need record-triggered action chosen by AI -> AI server action with narrow tools, rules in Python.
- Need other LLM provider, custom retrieval, streaming UI, or workflow beyond the above -> custom module (`integrating-llms.md`).
