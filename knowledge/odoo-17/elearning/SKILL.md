---
name: elearning
description: Senior Odoo 17 eLearning expertise. Use for Odoo 17 eLearning — building courses and content, quizzes and certifications, channels and enrollment/access, gamification and engagement, and the course forum and reviews.
---

# Odoo 17 eLearning (senior)

## Mindset
- Decide the learner journey first (who sees, who enrolls, how paid, how proven), then configure. Visibility and enrollment are two separate axes; most support tickets come from mixing them.
- Prefer standard config (course options, Surveys certification, karma) over custom code. Extend only for real gaps.
- Test as each persona: visitor, portal/internal attendee, eLearning Officer, eLearning Manager. Invite, add attendee and Contact Attendees differ per role.
- Anything not confirmed in the 17.0 docs is flagged "(verify in 17.0 docs: <url>)". Check the instance before promising it; some options in the newer docs (for example "Anyone with the link" visibility) may not exist in 17.
- Under the hood a course is `slide.channel` and a content item is `slide.slide`. Custom code on 17 uses `<tree>` list views, `oe_chatter` div, `groups_id`, `_sql_constraints`, `_()`; website JS is `publicWidget`, tests are QUnit.

## Principles
1. Structure: course -> sections -> content. Section = divider; content item = Article, Document, Image, Video or Quiz. Certification is added from the course Content tab and comes from Surveys.
2. Two display modes: Training (fixed order) vs Documentation (any order, Featured Content on homepage). Pick by pedagogy.
3. Publish bottom-up: publish content items first, then the course. Unpublishing the course hides all content. Publishing is done from the front end (Go to Website smart button).
4. Visibility ("Show course to": Everyone, Signed In, Course Attendees; an "Anyone with the link" option appears in newer docs, verify in 17.0) is independent of Enroll Policy (Open, On invitation, On payment).
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

## References
- references/courses-content.md — course form, sections, content types, tags, publishing.
- references/quizzes-certification.md — quiz tab, karma by attempt, certification via Surveys.
- references/enrollment-access.md — visibility, enroll policies, prerequisites, paid courses, roles.
- references/engagement-gamification.md — karma, reviews, forum, notifications, badges.

Doc URLs (Odoo 17.0; the eLearning landing page is stable, verify the others resolve):
- https://www.odoo.com/documentation/17.0/applications/websites/elearning.html
- https://www.odoo.com/documentation/17.0/applications/marketing/surveys/create.html
- https://www.odoo.com/documentation/17.0/applications/general/users/access_rights.html
- https://www.odoo.com/documentation/17.0/applications/websites/ecommerce.html
