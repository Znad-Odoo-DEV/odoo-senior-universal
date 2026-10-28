# Onsite / mobile workflow

Confirmed pieces: map and navigation (itinerary page), worksheet smart button (worksheets page), Products smart button (products page). Landing: https://www.odoo.com/documentation/19.0/applications/services/field_service.html . Odoo tutorial: https://www.odoo.com/slides/field-service-49

## Technician day
1. Field Service > My Tasks > Map (Today filter): stops in Planned Date order.
2. Pick a task; Navigate to or View in Google Maps (starts from current location).
3. Open the task; review customer, description, worksheet template.
4. Start the timer (timesheet timer on the task; button names: verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/services/timesheets.html).
5. Fill the Worksheet (Required fields first); first save turns the button into "Worksheet Complete".
6. Add materials with the Products smart button (+/-).
7. Customer sign-off and sending the worksheet to the customer (exact buttons: verify in 19.0 docs: https://www.odoo.com/documentation/19.0/applications/services/field_service.html).
8. Stop the timer, mark the task done (updates default-warehouse stock); invoicing follows from the office.

## Design for field use
- Use the Odoo mobile app or browser on the phone; saving needs connectivity, so keep forms small and save often.
- Give technicians Field Service user rights only; dispatch and billing to managers.
- Photos in worksheet image fields rather than chatter attachments, for traceability.
- Keep stages simple (planned, in progress, done); mark done only after worksheet and sign-off.

## Troubleshooting
- Task missing on map: no valid address, or Today filter on.
- No route line: Mapbox not configured; the Google Maps button still works.
- Stock unchanged after done: user has no default warehouse, or product not stock-tracked.
