# Connect iCloud

Usually already connected if the Mac is signed in to an Apple ID.

1. Open **System Settings** → click your name at the top (Apple Account) → **iCloud**.
2. Under "Apps using iCloud" open **See All** (or **Show More Apps**).
3. Turn on **Calendars** and **Reminders**.
4. Open the **Calendar** app once and wait until the iCloud calendars appear in the left sidebar.

Not signed in to an Apple ID? System Settings → **Sign in** at the top → follow Apple's prompts. The user does this themselves; never type an Apple ID or password for them.

## Troubleshooting

- **Calendars missing in `cal --calendars`** → open the Calendar app, Settings → Accounts → iCloud → make sure the account is enabled; wait a minute and rerun.
- **Reminders lists empty** → open the Reminders app once; if it offers to "Upgrade" the lists, accept, then rerun `scripts/rem lists`.
