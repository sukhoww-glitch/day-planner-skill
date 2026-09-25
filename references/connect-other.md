# Connect by calendar link (read-only)

For accounts that cannot be added to the Mac — blocked by company IT, or a service without an Internet Accounts option. The Mac subscribes to a private link and refreshes it on a timer. Read-only, which is all the planner needs.

## Get the link

- **Google Calendar** → calendar.google.com → ⚙ Settings → the calendar on the left → **Integrate calendar** → copy **Secret address in iCal format**.
- **Outlook / Office 365** → outlook.office.com → ⚙ Settings → Calendar → **Shared calendars** → **Publish a calendar** → choose the calendar, "Can view all details" → **Publish** → copy the **ICS** link. (If Publish is missing, IT has disabled it — ask them.)
- **Other services** → look for "iCal", "ICS", "subscribe" or "export link" in the calendar's settings.

The link is private: anyone who has it can see the calendar. The user pastes it only into the Calendar app — not into chat, not into any file of this skill.

## Subscribe

1. Open the **Calendar** app → menu **File** → **New Calendar Subscription…**
2. Paste the link → **Subscribe**.
3. **Location**: iCloud (syncs to iPhone) or On My Mac. **Auto-refresh**: Every 5 minutes (or the shortest available).
4. **OK**. Rerun `scripts/cal --calendars` — the subscription appears as its own calendar.

## Troubleshooting

- **Events lag behind** → subscriptions refresh on their timer; Google publishes changes with a delay of up to several hours. Warn the user that a meeting booked minutes ago may be missing.
- **Subscription shows no events** → the link is wrong or publishing was revoked; get a fresh link.
