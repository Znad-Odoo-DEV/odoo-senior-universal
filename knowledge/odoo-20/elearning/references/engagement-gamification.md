# Engagement and gamification (Odoo 20)
Source (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/websites/elearning.html

## Karma (course Karma tab)
- Rewards: karma points for reviewing a course and for finishing a course.
- Access Rights: karma required to Add Review, Add Comment, Vote.
- Quiz karma: Points Rewards by number of attempts (see quizzes-certification.md).
- Karma ranks, global karma rules: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/websites/forum.html (URL unconfirmed).

## Reviews
Options > Communication > Allow Reviews: attendees can like, comment, review content. Gate abuse with karma thresholds.

## Course forum
- Needs Settings > Forum enabled; then Options > Communication > Forum creates a dedicated forum for the course.
- Moderation and forum karma rules: verify in 20.0 docs (forum URL above, unconfirmed).

## Notifications
- New Content Notification: email template sent on new content upload.
- Completion Notification: email template sent when an attendee finishes.
- Mailing enabled: "Contact Attendees" mass-mail button (Managers; Officers with Email Marketing user rights).

## Badges and certificates
- Badge configuration on certification surveys: verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/marketing/surveys/create.html
- Challenges/badges via Gamification: not covered on the eLearning page as documented for 19.0; verify on the instance.

## Design guidance
- Reward finishing (completion karma) and quality (quiz first-try bonus), not just activity.
- Set review/comment thresholds above zero on public courses to limit spam.
- Documentation mode with Featured Content for self-service libraries; Training mode for sequenced onboarding.
- Course Groups and Content Tags keep large catalogs navigable.
- Measure completion, quiz attempts, review ratings, forum questions per course; act on lessons with high drop-off.
- Custom completion dashboards built on `read_group` must use the 20 signature `(domain, groupby, aggregates, having, offset, limit, order)`; old `fields=`/`lazy=` calls break.
