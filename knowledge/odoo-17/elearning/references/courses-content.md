# Courses and content (Odoo 17)
Source: https://www.odoo.com/documentation/17.0/applications/websites/elearning.html

## Course form
Path: eLearning > Courses > Courses. Card click opens the back-end editor; "View course" opens the front end.
- Title, Tags (user filtering), image (camera placeholder > Edit).
- Tabs: Content, Description, Options, Karma.
- Content tab: Add Section, Add Content, Add Certification (Surveys).
- Description tab: short text under the title on the website.
- Options tab: Responsible, Website; Access rights; Communication; Display (see enrollment-access.md and engagement-gamification.md).

## Content item
Path: eLearning > Courses > Contents > New, or Add content inside a course.
Fields: Content Title, Tags, Course, Content Type, Responsible (defaults to creator), Duration, Allow Preview (lets non-enrolled visitors open the item; exact wording: verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/websites/elearning.html).
Tabs: Document, Description, Additional Resources, Quiz.

### Content types
- Image: JPG, JPEG, PNG, SVG, GIF, WEBP up to 25 MB, or from Google Drive (formats and size limit: verify in 17.0 docs).
- Article: authored in the website builder on the front end (Go to Website smart button).
- Document: PDF upload, or Google Slides/Docs/Sheets link from Drive.
- Video: YouTube, Google Drive or Vimeo link.
- Quiz: built in the Quiz tab.
Additional Resources: link or file per line, shown in the course content on the website.

## Content Tags
eLearning > Configuration > Content Tags. Appear on the website Contents dashboard (e.g. theory vs exercise).

## Course Groups
eLearning > Configuration > Course Groups: name, Menu Entry toggle (search by group on website), tags with optional colors. Filters the All Courses page.

## Display modes
- Training: fixed order.
- Documentation: any order; Featured Content promotes items on the course homepage.

## Publishing
- Done from the front end via Go to Website smart button; toggle Unpublished/Published (upper right).
- Publish content items first, then the course. Content is available only once the course is published. Unpublishing the course hides its content.

## Senior tips
- Use sections to mirror learning objectives; keep items short with accurate Duration.
- Article for editable content, Document/PDF for fixed material, Video for demos.
- Use Preview only on teaser items for paid/invitation courses.
- Article editing and the course front end run on the 17 website stack: frontend JS is `publicWidget`, QUnit for JS tests; the 18+ `Interaction` framework does not apply.
