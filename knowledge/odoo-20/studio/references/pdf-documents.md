# PDF document design in Studio (Odoo 20)
Docs (ported from the 19.0 layout; verify in 20.0 docs): https://www.odoo.com/documentation/20.0/applications/studio/pdf_reports.html

## Company layout (outside Studio)
Settings > Configure Document Layout: layouts (Light, Boxed, Bold, Striped, Bubble, Wave, Folder), background, fonts (incl. Tajawal for Arabic + Latin), logo, primary/secondary colors, address, tagline, footer, paper format (A4/US Letter). Set this first; custom documents inherit it. Layout list as documented for 19.0; verify in 20.0 docs: pdf_reports.html.

## Create
Open model > Toggle Studio > Reports > New, choose type:
- External: company logo/name/address header, footer text + page number.
- Internal: user date/time, company name/address, page number; no footer.
- Blank: no header/footer.

## Edit
Open model > Toggle Studio > Reports (or Studio > Reports). **Duplicate the standard report before changing it.** Left-panel options: Rename (print menu + PDF filename), Paper format (defaults to layout), Show in print menu, **Reload from attachment** (stores first generated PDF and reuses it; docs say legally required for invoices), limit to user groups, Edit sources (XML), Reset report. Preview toggle; Print in preview downloads.

## Editor
- Ctrl+Z / Ctrl+Y; autosave on leaving, or Save.
- Editing header/footer affects ALL standard and custom reports.
- Static text edits directly; dynamic text (blue) is replaced by field values at generation.
- Powerbox: type `/` for fields, lists, tables (static/dynamic), images, banners. Field: `/` > Field, then pick.
- Conditional blocks (dashed rectangles, if/else) toggle content; conditions are editable only in XML.
- XML/QWeb specifics (t-foreach, t-field, translation, limits): (verify in 20.0 docs: https://www.odoo.com/documentation/20.0/applications/studio/pdf_reports.html)

## Practice
- Tweaking invoice/quote: duplicate, edit the copy, leave the original untouched, expose the copy via print menu/group.
- Respect the Reload-from-attachment rule for legal invoices; check local regulation.
- Heavy conditional logic, complex loops, or multi-company variants: write QWeb in a module instead.
- Test with long names, multi-page lines, multiple currencies and languages (Arabic/RTL included).
- After the 19 -> 20 upgrade, re-open every duplicated standard report: the standard report it was copied from may have changed (accounting documents in particular, as payment statuses are renamed and bank-impacting entries originate from bank transactions), and duplicates do not follow those changes. Compare the copy to the new standard before reusing it.
