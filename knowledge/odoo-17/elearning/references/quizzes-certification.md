# Quizzes and certification (Odoo 17)
Sources: https://www.odoo.com/documentation/17.0/applications/websites/elearning.html ; https://www.odoo.com/documentation/17.0/applications/marketing/surveys/create.html

## Quiz (content item, Quiz tab)
- Assesses learners, typically at the end of a course.
- "Add a line": question name + answers; tick "Is correct answer"; Comment field shows extra info when an answer is selected.
- Points Rewards section: karma awarded depends on the attempt on which the learner answers correctly (default values: verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/websites/elearning.html).

## Certification
- Enable: eLearning > Configuration > Settings > Certifications (uses Surveys).
- Add to a course: course Content tab > Add Certification.
- Build in Surveys app > New; type Survey, Live Session, Assessment or Custom (Custom exposes all options). The survey type selector is a recent addition; if it is absent in 17, set the options directly on the survey form (verify in 17.0 docs).

### Survey options that matter
- Questions: Pagination (per question, per section, all on one page), Display Progress as (percentage left / number answered), Question Selection (all / randomized per section; "# Questions Randomly Picked" defaults to 1), going back to earlier pages (labelled "Allow Roaming" in newer docs, "Back Button" in some versions; verify in 17.0 docs).
- Time and Scoring: Survey Time Limit (minutes); Scoring = no scoring, with answers after each page, with answers at the end, without answers.
- With any scoring: Required Score (%) = pass mark, and "Is a Certification" toggle (trophy icon on Surveys dashboard).
- Further certification fields (certificate template, badge, attempts limit, access mode): verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/marketing/surveys/create.html

## Design guidance
- Randomize per section from a larger question pool to reduce cheating; set a time limit for formal exams.
- Show answers only at the end for exams, after each page for learning checks.
- Agree Required Score with the business before launch; test how a later change affects past results on the instance.
- Keep quiz (formative, karma) and certification (summative, credential) distinct.
- Test the full path as an enrolled attendee: finish content, take certification, check result and certificate.
