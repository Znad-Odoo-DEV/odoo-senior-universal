# Users, Access Rights, Multi-company (Odoo 20)

Docs: https://www.odoo.com/documentation/20.0/applications/general/users.html ; https://www.odoo.com/documentation/20.0/applications/general/users/access_rights.html ; https://www.odoo.com/documentation/20.0/applications/general/multi_companies.html (URLs follow the 19.0 layout; 20.0 pages could not be fetched when this was adapted: verify in 20.0 docs).

## 1. Users
- Create: Settings > Users & Companies > Users > New, or **Invite** (email invitation, user sets own password). Set name, login (email), language/timezone, company(ies), access rights per app.
- User types: **Internal user** (licensed seat, backend), **Portal** (customers/vendors, limited self-service), **Public** (website visitor). Choosing type sets baseline groups. (Odoo 20 user type labels — verify in 20.0 docs.)
- Archive instead of delete (keeps history, frees seat per billing rules). Reset password via action; avoid sharing admin.
- Preferences: user language, notification (email vs Odoo inbox), signature, default company.
- Admin vs Settings access: "Administration: Settings" group can change configuration; "Access Rights" (technical) lets user manage users/groups. Give sparingly; keep a break-glass admin.
- Security: 2FA (Settings > General Settings > Permissions/Authentication; users enable under Preferences > Account Security), password policy (min length), OAuth/Google/Microsoft SSO and LDAP (Settings > Integrations), API keys per user for integrations (user > Account Security > New API Key) instead of passwords. In 20 XML-RPC and JSON-RPC are deprecated; integrations move to JSON-2 (`/json/2/<model>/<method>`, Custom plan only), so inventory existing integrations and their API users.
- Impersonate: with developer mode, a user form action to log in as another user (Administrator only) for UAT—verify availability in 20.0.

## 2. Access Rights model (layers)
1. **Groups** (res.groups): per-app privilege levels in the user form (e.g. Sales: User: Own Documents / User: All Documents / Administrator). Higher levels imply lower ones.
2. **Access rules (`ir.access`)**: Odoo 20 merges model access (CRUD per group per model, formerly `ir.model.access`) and record rules (row-level domains, formerly `ir.rule`) into one model. One access record carries the model, the group, the operation and an optional domain; modules ship them as `ir.access.csv` (columns `id,name,model_id,group_id/id,operation,domain`). View: Settings > Technical > Security (developer mode); exact menu names in 20: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/general/users/access_rights.html).
   - How several access records combine (in 19: model access additive across groups; global rules ANDed; group rules ORed) and how a "global" restriction is expressed in `ir.access`: (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/general/users/access_rights.html). Do not assume the 19 combination logic.
3. **Field-level**: `groups` attribute on field/view element hides/restricts (Studio lets you set group visibility on a field/element).
4. **Menu/Action visibility**: groups on menus and buttons (Settings > Technical > User Interface > Menu Items).
5. **Company scoping**: multi-company row filtering (a domain on the access record in 20) and allowed companies.
Rule of thumb: configure via app privileges (levels) first; custom groups + access records second; never grant "Administrator" for convenience.

## 3. Designing roles
- Build a **role matrix**: persona x app x level x special rights (post journal entries, approve PO, see costs, edit prices).
- Create custom groups (developer mode: Settings > Technical > Groups) that **inherit** (Implied Groups) from standard ones; add menu/access records. Assign users to groups; test with a representative user.
- Typical sensitive rights: Accounting "Billing" vs "Accountant" vs "Adviser"; "See Cost" on products (group), "Discount on lines", "Edit unit price", "Validate inventory" (stock manager), Purchase "Manager" for approval, HR "Officer" vs "Manager", Time Off approver via employee form. Expenses are draft vendor bills in 20, so who may post vendor bills becomes part of the expense control (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/expenses.html).
- Separation of duties: purchaser vs approver vs receiver vs bill poster vs payer.
- Audit: chatter tracked fields, access logs (Settings > Technical > Logging), "Audit Trail" feature in Accounting settings (Enterprise/accounting: tracks journal entry changes — verify in 20.0).

## 4. Portal & Website users
Customers/vendors access their documents (quotes, orders, invoices, tickets, projects) via portal after invitation (Contacts > Action > Grant portal access) or sign-up (Settings > Website/Portal > Customer Account: Free sign up vs On invitation). Portal sees only records where partner/follower matches the row-level access rules. Online signature/payment from portal link.

## 5. Multi-company
- Create companies: Settings > Users & Companies > Companies. Each has own chart of accounts (fiscal localization per company), currency, taxes, sequences, warehouses, users scope, reports.
- User: **Allowed Companies** + **Default Company**; the **company switcher** (top right) selects active companies; multiple active = consolidated viewing, new records use the first/current company.
- Records: company-dependent fields (e.g. product costing/valuation, taxes on partner) vs **shared** records (empty Company = shared across companies). Set `Company` on product/partner deliberately: blank shared master data vs per-company.
- Accounting: separate legal entities need separate chart + journals; parent/branches in newer versions (branch companies, shared chart within group: verify "Branches" and tax-unit/consolidation in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting/get_started/multi_currency.html; multi-company: general/multi_companies.html).
- Inter-company transactions: Settings > Companies > Inter-Company Transactions (auto-create SO/PO, auto-validate, sync invoices). Requires each company has a partner.
- Inventory: warehouses per company; inter-company transfer via routes or inter-company rules.
- Access: the row-level domains use `company_ids`; give users only needed companies; check access as that user across companies.
- Consolidation: Accounting reports can include multiple companies (Enterprise: Consolidation app).
- Pitfalls: mismatched currency/taxes between companies; sequences per company; shared products with company-specific accounts need property fields set per company.

## 6. Go-live access checklist
Admin accounts limited; users imported with correct groups; portal invitations staged; 2FA enforced for admins/accountants; access rules (`ir.access`) tested with a non-admin; email aliases and notification settings per user; default company set; demo data off; seats vs licenses reconciled.
