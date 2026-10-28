# Enrollment, access and paid courses (Odoo 17)
Source: https://www.odoo.com/documentation/17.0/applications/websites/elearning.html (Options > Access rights)

## Visibility: "Show course to"
Everyone | Signed In | Course Attendees. Controls who can see the course, not who can enroll. An "Anyone with the link" option is listed in the newer docs; check the field on the 17 instance (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/websites/elearning.html) before offering private link sharing.

## Enroll Policy
- Open: anyone who can see it can enroll. Officers and Managers can add or invite internal/external attendees.
- On invitation: only invited people enroll. If visibility is Everyone/Signed In, non-invited logged-in users can request access. Set an Enroll Message (e.g. contact the Responsible). A request creates a to-do for the Responsible, who can Grant or Refuse Access. Only the Responsible or an eLearning Manager can add/invite.
- On payment: visible only with Paid Courses enabled. Visitors enroll by paying. Officers can invite; Responsible or Manager can add attendees without payment. A Product with Product Type "Course" is mandatory.

## Prerequisites
"Prerequisites" = courses to complete first; "Prerequisite Of" is the read-only reverse list.

## Paid courses
- Settings > Paid Courses installs eCommerce (may change your pricing plan; check first). eCommerce docs: https://www.odoo.com/documentation/17.0/applications/websites/ecommerce.html
- Create the course product (type Course), select it on the course, publish. Payment follows standard eCommerce checkout.
- Pricelists, taxes, coupons on course products: verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/websites/ecommerce.html

## Roles and rights
- eLearning Officer vs Manager differ for inviting, adding attendees, Contact Attendees. Group details: https://www.odoo.com/documentation/17.0/applications/general/users/access_rights.html
- Attendees must be contacts; website sign-up auto-creates the contact.
- Custom access logic on 17: use `check_access_rights(operation)` / `check_access_rule(operation)` (the 18+ `check_access` / `has_access` helpers do not exist) and the `groups_id` field on users and groups.

## Multi-website
Course Options > Website limits display to one site.

## Patterns
- Internal training: Visibility Signed In or Attendees + On invitation.
- Public marketing course: Everyone + Open.
- Premium: Everyone (teaser, Allow Preview items) + On payment.
- Private link sharing: Anyone with the link + Open or invitation, only if that visibility exists on the 17 instance; otherwise use Course Attendees + On invitation and send invitations.

## Troubleshooting
- Cannot see course: check Published, visibility, website, and that content items are published.
- Cannot enroll: check Enroll Policy and the product on paid courses.
- Missing invite option: check user group (Officer/Manager).
