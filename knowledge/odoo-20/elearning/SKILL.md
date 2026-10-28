---
name: elearning
description: Senior Odoo 20 eLearning expertise. Use for Odoo 20 eLearning — building courses and content, quizzes and certifications, channels and enrollment/access, gamification and engagement, and the course forum and reviews.
---

# Odoo 20 eLearning (senior)

## Mindset
- Decide the learner journey first (who sees, who enrolls, how paid, how proven), then configure. Visibility and enrollment are two separate axes; most support tickets come from mixing them.
- Prefer standard config (course options, Surveys certification, karma) over custom code. Extend only for real gaps.
- Test as each persona: visitor, portal/internal attendee, eLearning Officer, eLearning Manager. Invite, add attendee and Contact Attendees differ per role.
- Content is ported from the 19.0 documentation and not re-confirmed against the 20.0 UI. Anything not confirmed in the 20.0 docs is flagged "(verify in 20.0 docs: <url>)". Check the instance before promising it.

## Principles
1. Structure: course -> sections -> content. Section = divider; content item = Article, Document, Image, Video or Quiz. Certification is added from the course Content tab and comes from Surveys.
2. Two display modes: Training (fixed order) vs Documentation (any order, Featured Content on homepage). Pick by pedagogy.
3. Publish bottom-up: publish content items first, then the course. Unpublishing the course hides all content. Publishing is done from the front end (Go to Website smart button).
4. Visibility ("Show course to": Everyone, Signed In, Course Attendees, Anyone with the link) is independent of Enroll Policy (Open, On invitation, On payment).
5. On payment needs Paid Courses enabled (installs eCommerce) and a Product of type Course. Check pricing-plan impact before enabling.
6. Attendees must be contacts. Website sign-up creates the contact automatically.
7. Prerequisites gate course sequence; "Prerequisite Of" is the read-only reverse list.
8. Certification = Survey with scoring + "Is a Certification" + Required Score (%). Settings > Certifications must be on.
9. Engagement levers: karma rewards (review/finish), karma thresholds (add review, comment, vote), quiz points by attempt count, reviews, course forum, notification emails.
10. Course Groups + Tags drive website filtering; Content Tags label theory/exercise on the course page.
11. Settings live in eLearning > Configuration > Settings: Certifications, Paid Courses, Mailing, Forum. Enable only what the design needs.
12. Mailing enabled -> "Contact Attendees" button, visible to Managers and to Officers who also hold Email Marketing user rights.

## Review checklist
- Responsible user set (receives access-request to-dos on invitation courses).
- Website field set on multi-website databases.
- Enroll Message written for On invitation courses.
- Email templates for new content and completion chosen deliberately.
- Quiz karma points and certification pass score agreed with the business.
- Course and every content item published; checked as an outsider in a private window.

## Odoo 20 notes
- No eLearning-specific functional change is established here; treat the behavior above as carried over from 19 and confirm on a 20 test database (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/websites/elearning.html).
- Paid courses run on eCommerce; wishlist and comparison are now part of `website_sale` (the separate modules are gone) and `delivery_mondialrelay` is removed, which matters only if course shops add physical goods.
- Custom eLearning/Surveys code on 20: security in `ir.access.csv` (ACLs and record rules merged into `ir.access`), public `read_group(domain, groupby, aggregates, having, offset, limit, order)` (old `fields=`/`lazy=` calls break) for completion reports, OWL 3 for custom frontend components, Python >= 3.12 and PostgreSQL >= 16.
- Reporting scripts or LMS integrations using XML-RPC/JSON-RPC should plan for JSON-2 `/json/2/<model>/<method>` (Custom plan only); the `db` service is removed in 20 and `common`/`object` go in Odoo 22.

## References
- references/courses-content.md — course form, sections, content types, tags, publishing.
- references/quizzes-certification.md — quiz tab, karma by attempt, certification via Surveys.
- references/enrollment-access.md — visibility, enroll policies, prerequisites, paid courses, roles.
- references/engagement-gamification.md — karma, reviews, forum, notifications, badges.

Doc URLs (20.0, ported from the 19.0 layout; verify in 20.0 docs):
- https://www.odoo.com/documentation/20.0/applications/websites/elearning.html
- https://www.odoo.com/documentation/20.0/applications/marketing/surveys/create.html
- https://www.odoo.com/documentation/20.0/applications/general/users/access_rights.html
- https://www.odoo.com/documentation/20.0/applications/websites/ecommerce.html
- Release notes: https://www.odoo.com/odoo-20-release-notes
