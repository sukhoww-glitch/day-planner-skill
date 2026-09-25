# Connect Microsoft (Outlook, Office 365, Exchange, Outlook.com)

The Outlook calendar is added to the Mac's Calendar app. Having the Outlook app installed does not help — the planner reads the Apple Calendar app, not Outlook.

1. Open **System Settings** → **Internet Accounts** → **Add Account…** → **Microsoft Exchange**. (Use this for Office 365 work accounts and for personal Outlook.com / Hotmail too.)
2. Enter name and email → **Sign In** → choose **Sign In** (not "Configure Manually").
3. Microsoft's sign-in page opens. The user signs in themselves (and approves MFA if asked), then accepts the permissions.
4. Turn on **Calendars**. Turn on **Reminders** too if they want Outlook / To Do tasks to show up in Apple Reminders.
5. Open the **Calendar** app and wait until the Exchange calendars appear in the sidebar.

## Troubleshooting

- **"Need admin approval" / "Your organisation doesn't allow…"** → the company's Microsoft 365 admin blocks third-party mail/calendar apps. Ask IT to allow "Apple Internet Accounts", or use the published calendar link from `connect-other.md`.
- **Shared or team calendars missing** → Exchange on Mac shows only calendars the account owns or that were shared directly to it. Ask the owner to share the calendar with the user's email, then restart the Calendar app. If it still doesn't appear, subscribe to it by link (`connect-other.md`).
- **Account added, but not in `cal --calendars`** → make sure **Calendars** is on for that account, open the Calendar app once, rerun.
