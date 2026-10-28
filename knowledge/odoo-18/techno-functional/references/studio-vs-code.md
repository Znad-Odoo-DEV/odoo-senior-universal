# Studio vs Code

Studio doc: https://www.odoo.com/documentation/18.0/applications/studio.html

## What Studio covers (per the 18.0 docs)
Fields and widgets; views; models (including building an app from scratch); automation rules (with webhooks); PDF reports; approval rules; security rules (listed, details: verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/studio.html). Open it with the Toggle Studio icon in the target app/model.

## Licensing note
On Odoo Online, installing Studio on the Standard plan prompts an upgrade to the Custom plan (see the Studio page for contract details). Confirm edition/hosting before proposing Studio.

## Choose Studio when
- Adding fields, rearranging views, simple approvals, notifications, light PDF layout tweaks.
- Simple standalone models with list/form views and light automation.
- Business-owned changes needing fast iteration and low logic complexity.

## Choose code when
- Complex computations, cross-model transactions, accounting/stock postings, constraints beyond simple rules.
- Performance-critical or high-volume logic, batch jobs.
- Integrations needing error handling, retries, idempotency.
- Version control, code review, automated tests, CI, multi-environment deploys are required.
- Custom widgets/OWL components, custom security logic, modules reused across databases.

## Comparison
| Aspect | Studio | Code |
|---|---|---|
| Speed to first result | Hours | Days |
| Version control/tests | Limited | Full |
| Upgrade handling | Re-validate; dependent views can break | Re-validate; tests help |
| Logic depth | Low-medium | Unlimited |
| Maintained by | Functional admin | Developer |

## Governance
- Naming: Studio adds an x_ prefix; give a clear label and help text; register every change (what, why, owner).
- Build in a test/staging database; promote deliberately; avoid live edits in production.
- When a Studio customization grows logic, move it to a module and remove the Studio original (no duplicate fields/views).
- Before upgrades, review Studio views/automations on the target version in a copy.
- Export/import of customizations and exact Studio limits: verify in 18.0 docs.
