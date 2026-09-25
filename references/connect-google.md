# Connect Google (Gmail / Google Workspace)

Google Calendar is added to the Mac's Calendar app; the planner then reads it like any other calendar.

1. Open **System Settings** → **Internet Accounts** → **Add Account…** → **Google**.
2. A browser window opens with Google sign-in. The user signs in themselves and clicks **Allow**.
3. In the account's list of apps turn on **Calendars**. Mail, Contacts and Notes are not needed by the planner — leave them as the user prefers.
4. Open the **Calendar** app and wait until the Google calendars appear in the sidebar.

**Other people's and shared calendars** in Google often don't show up by default: open https://calendar.google.com/calendar/syncselect in the browser (signed in to the same account), tick the calendars they want on the Mac, **Save**. They appear within a few minutes.

Google Tasks do **not** sync to Apple Reminders. Keep tasks in Reminders or in plan files.

## Troubleshooting

- **"This app is blocked" / sign-in refused** → the company's Google Workspace admin blocks the Mac Calendar app. Either ask IT to allow "macOS Internet Accounts", or use the read-only calendar link from `connect-other.md`.
- **Calendars show up but events are old** → Calendar app → Settings → Accounts → the Google account → **Refresh Calendars** "Every 5 minutes".
- **Account added, but not in `cal --calendars`** → make sure **Calendars** is on for that account in Internet Accounts, open the Calendar app once, rerun.
