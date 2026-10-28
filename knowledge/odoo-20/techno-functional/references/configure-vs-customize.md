# Configure vs Customize

## Decision ladder (stop at the first rung that meets the requirement)
1. Change the process: adopt the standard flow if the business value of the difference is low.
2. Settings: app settings, enabling features.
3. Master-data configuration: product types, routes, operation types, payment terms, pricelists, fiscal positions, approval settings, stages, tags, templates.
4. Built-in tooling: filters/groupings/favorites, dashboards, spreadsheet, email/PDF templates, activities, scheduled actions.
5. Automation rules: triggers, conditions, actions (update record, create activity, send email, webhook).
6. Studio: fields, views, approvals, simple models, reports (see studio-vs-code.md).
7. Code, small extension: inherit a model/view, add fields/constraints/computes, override a narrow hook.
8. Code, new model/app: only when no standard model fits the entity and its lifecycle.
9. External integration: when the capability lives in another system of record (in 20, via JSON-2; XML-RPC/JSON-RPC are deprecated).

## Cost model per customization
- Build + test effort, documentation, training.
- Upgrade cost: each major version re-validates it; Studio and code both count. 19 -> 20 is a heavy jump for code (security files rewritten for `ir.access`, `read_group` signature, OWL 3, removed modules), so code-level customizations cost more to carry than in earlier jumps.
- Run cost: support, monitoring, performance, security exposure.
- Lock-in: a deviation from standard blocks adopting future standard improvements.
Rule of thumb: if the benefit cannot be stated in money, risk, or compliance terms, push back.

## Questions before customizing
- Which decision, document, or control depends on this? Who uses it, how often?
- Does standard cover 80% of it? Can the remaining 20% be a process change?
- Is it a legal/regulatory need (the localization may already cover it)?
- Will it survive the next upgrade unchanged? Who owns it after go-live?
- Is it already in 20 standard (batch picking in `stock`, wishlist/comparison in `website_sale`, Planning for field work)?
- Does it depend on a module removed in 20 or on an OCA add-on with no 20.0 branch (as of 2026-09-24; re-check)?

## Verdict values
Standard, Configure, Automate, Studio, Code (extend), Code (new), Integrate, Process change, Reject/Defer. Always record the rationale and the cheaper alternative considered.
