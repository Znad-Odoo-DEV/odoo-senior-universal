# Recruitment and appraisals (Odoo 17)

## Recruitment
Docs: https://www.odoo.com/documentation/17.0/applications/hr/recruitment.html
Sub-pages listed in the 19.0 docs (under .../hr/recruitment/): new_job, post_job, recruitment_flow, add_applicants, schedule_interviews, offer_job_positions, refuse_applicant, application_analysis, source_analysis, hiring_velocity, team_performance. Verify which exist in 17.0.
- Each job position has its own pipeline; applications arrive via website, email alias, or manual entry; OCR resume digitization can fill name/phone/email (IAP-based; verify in 17.0).
- Default stages: New, Initial Qualification, First Interview, Second Interview, Contract Proposal, Contract Signed (last folded). Stages are global unless job-specific; can send email templates on entry.
- Card status (manual): green ready, red blocked, grey in progress.
- Offers at Contract Proposal (expiry in days); Contract Signed is the final stage.
- Employee creation from a hired applicant and contract hand-off: (verify in 17.0 docs: https://www.odoo.com/documentation/17.0/applications/hr/recruitment/offer_job_positions.html)
- Referrals app: https://www.odoo.com/documentation/17.0/applications/hr/referrals.html

## Appraisals
Docs: https://www.odoo.com/documentation/17.0/applications/hr/appraisals.html
Sub-pages listed in the 19.0 docs: schedule_appraisals, appraisal_templates, new_appraisals, 360, goals, appraisal_analysis, skills_evolution. Verify which exist in 17.0 (goals, 360 feedback and skills evolution are the most likely to differ).
- Scheduling: automatic (appraisal plans + automation rules) or manual.
- Templates: create/modify.
- Conducting: employee self-assessment, manager feedback, skills review, private note, final rating. 360 Feedback dashboard to request/view feedback (verify in 17.0).
- Goals: library with description, sub-goals, tags; assign and track per employee (verify in 17.0).
- Reports: appraisal analysis, skills evolution.

## Senior notes
- Align appraisal plans with contract milestones (e.g. probation end) via automation rules.
- Restrict private notes/ratings through access groups.
- Keep recruitment stages minimal; use job-specific stages only when the process truly differs.
