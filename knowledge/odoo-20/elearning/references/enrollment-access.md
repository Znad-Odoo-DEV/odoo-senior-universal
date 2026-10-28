# Enrollment, access and paid courses (Odoo 20)
Source (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/websites/elearning.html (Options > Access rights)

## Visibility: "Show course to"
Everyone | Signed In | Course Attendees | Anyone with the link. Controls who can see the course, not who can enroll.

## Enroll Policy
- Open: anyone who can see it can enroll. Officers and Managers can add or invite internal/external attendees.
- On invitation: only invited people enroll. If visibility is Everyone/Signed In/Anyone with the link, non-invited logged-in users can request access. Set an Enroll Message (e.g. contact the Responsible). A request creates a to-do for the Responsible, who can Grant or Refuse Access. Only the Responsible or an eLearning Manager can add/invite.
- On payment: visible only with Paid Courses enabled. Visitors enroll by paying. Officers can invite; Responsible or Manager can add attendees without payment. A Product with Product Type "Course" is mandatory.

## Prerequisites
"Prerequisites" = courses to complete first; "Prerequisite Of" is the read-only reverse list.

## Paid courses
- Settings > Paid Courses installs eCommerce (may change your pricing plan; check first). eCommerce docs: https://www.odoo.com/documentation/20.0/applications/websites/ecommerce.html
- Create the course product (type Course), select it on the course, publish. Payment follows standard eCommerce checkout (see the website-ecommerce skill).
- In 20, wishlist and comparison are part of `website_sale` itself; they do not need separate modules (relevant only if the shop also sells other products).
- Pricelists, taxes, coupons on course products: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/websites/ecommerce.html
- Accounting side of course sales: invoice payment statuses are renamed in 20 and bank-impacting entries originate from bank transactions; re-check reports filtering on payment status (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/finance/accounting.html).

## Roles and rights
- eLearning Officer vs Manager differ for inviting, adding attendees, Contact Attendees. Group details: https://www.odoo.com/documentation/20.0/applications/general/users/access_rights.html
- Groups are assigned with `group_ids` and `res.groups.privilege` (valid in 19 and 20). In 20 the underlying access rules for course models are `ir.access` records (ACLs and record rules merged); custom eLearning modules ship `ir.access.csv` with columns `id,name,model_id,group_id/id,operation,domain`.
- Attendees must be contacts; website sign-up auto-creates the contact.

## Multi-website
Course Options > Website limits display to one site.

## Patterns
- Internal training: Visibility Signed In or Attendees + On invitation.
- Public marketing course: Everyone + Open.
- Premium: Everyone (teaser, Allow Preview items) + On payment.
- Private link sharing: Anyone with the link + Open or invitation.

## Troubleshooting
- Cannot see course: check Published, visibility, website, and that content items are published.
- Cannot enroll: check Enroll Policy and the product on paid courses.
- Missing invite option: check user group (Officer/Manager).
- After a 19 -> 20 upgrade, access errors on custom course models usually mean the security files were not rewritten for `ir.access`.
