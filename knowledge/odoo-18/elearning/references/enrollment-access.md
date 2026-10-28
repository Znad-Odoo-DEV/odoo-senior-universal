# Enrollment, access and paid courses (Odoo 18)
Source: https://www.odoo.com/documentation/18.0/applications/websites/elearning.html (Options > Access rights)

## Visibility: "Show course to"
Everyone | Signed In | Course Attendees. Controls who can see the course, not who can enroll. (The 19.0 docs also list Anyone with the link; verify it exists in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/websites/elearning.html)

## Enroll Policy
- Open: anyone who can see it can enroll. Officers and Managers can add or invite internal/external attendees.
- On invitation: only invited people enroll. If visibility is Everyone/Signed In (or Anyone with the link, where available), non-invited logged-in users can request access. Set an Enroll Message (e.g. contact the Responsible). A request creates a to-do for the Responsible, who can Grant or Refuse Access. Only the Responsible or an eLearning Manager can add/invite.
- On payment: visible only with Paid Courses enabled. Visitors enroll by paying. Officers can invite; Responsible or Manager can add attendees without payment. A Product with Product Type "Course" is mandatory.

## Prerequisites
"Prerequisites" = courses to complete first; "Prerequisite Of" is the read-only reverse list.

## Paid courses
- Settings > Paid Courses installs eCommerce (may change your pricing plan; check first). eCommerce docs: https://www.odoo.com/documentation/18.0/applications/websites/ecommerce.html
- Create the course product (type Course), select it on the course, publish. Payment follows standard eCommerce checkout.
- Pricelists, taxes, coupons on course products: verify in 18.0 docs: https://www.odoo.com/documentation/18.0/applications/websites/ecommerce.html

## Roles and rights
- eLearning Officer vs Manager differ for inviting, adding attendees, Contact Attendees. Group details: https://www.odoo.com/documentation/18.0/applications/general/users/access_rights.html
- Attendees must be contacts; website sign-up auto-creates the contact.

## Multi-website
Course Options > Website limits display to one site.

## Patterns
- Internal training: Visibility Signed In or Attendees + On invitation.
- Public marketing course: Everyone + Open.
- Premium: Everyone (teaser, Allow Preview items) + On payment.
- Private link sharing: Anyone with the link + Open or invitation (only if the option exists on your 18.0 instance; verify).

## Troubleshooting
- Cannot see course: check Published, visibility, website, and that content items are published.
- Cannot enroll: check Enroll Policy and the product on paid courses.
- Missing invite option: check user group (Officer/Manager).
