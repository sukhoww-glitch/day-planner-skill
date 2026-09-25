# Onboarding

Runs when `~/.config/day-planner/config.json` is missing, or when the user asks to reconfigure. Goal: the user connects the accounts they need, picks what the planner may see, sets their working day and rules — and at the end gets a real plan for today.

Keep every message short: one step, one question, then wait. Never ask for a password, app password or token — accounts are added by the user in macOS System Settings. On reconfigure, show the current value of each setting and let them keep it with one word.

## 1. Language

First message, in all three languages, nothing else:

```
Привет! Давай настроим планировщик. На каком языке общаемся?
Привіт! Налаштуймо планувальник. Якою мовою спілкуємось?
Hi! Let's set up your planner. Which language do you prefer?

ru · uk · en
```

From here on speak only the chosen language. Ask their name — used in the plan header, optional.

## 2. Environment check

Run `scripts/check`. It prints `ok`/`fail` per line.

| Fail | What to tell the user |
|---|---|
| `macos` | This skill works only on a Mac. Stop here. |
| `swiftc` | Run `xcode-select --install` in Terminal, accept the dialog, wait for the install (5–10 min), then say "done". |
| `calendar` "access denied" | System Settings → Privacy & Security → Calendars → turn on the app they run Claude in (Claude, Terminal, iTerm…) → set to **Full Access**. Then rerun. |
| `reminders` | macOS will show a dialog "… wants to control Reminders" — click **OK**. If it was denied earlier: System Settings → Privacy & Security → Automation → the app → turn on **Reminders**, and Privacy & Security → Reminders → turn the app on. |

The first `cal` and `rem` call trigger the macOS permission dialogs — tell the user to expect them and to allow them. Rerun `scripts/check` until calendar and reminders are `ok`.

## 3. Which accounts

Ask which accounts hold their meetings and tasks — several are fine:

- **iCloud** (Apple ID)
- **Google** (Gmail, Google Workspace)
- **Microsoft** (Outlook, Office 365, Exchange, Outlook.com)
- **Other** (a calendar link, CalDAV)

Then run `scripts/cal --calendars` and show which accounts are already on this Mac (column 2). For each chosen account that is not there yet, open the matching guide and walk them through it one step at a time:

- iCloud → `references/connect-icloud.md`
- Google → `references/connect-google.md`
- Microsoft → `references/connect-microsoft.md`
- Other / an account that cannot be added → `references/connect-other.md`

After each account: rerun `scripts/cal --calendars`, confirm the new account's calendars appear. If they don't, use the troubleshooting section of that guide.

## 4. Pick calendars

Show the list from `scripts/cal --calendars` as a numbered list grouped by account (title only, not the ids). Suggest excluding holidays, birthdays, subscribed sports/TV and other people's shared calendars — they add noise. Ask which to include. Save each chosen one as `{id, account, title}` in `calendars.include`.

Then run `scripts/cal` for today with the selection and show what it sees — this is the check that the connection works.

Ask: are there recurring meetings that sit on the calendar but usually don't happen or don't block time (an optional sync, a "focus" placeholder)? Save their exact titles to `calendars.not_busy`. Empty is fine.

## 5. Tasks

Ask where tasks should live:

- **Apple Reminders** (recommended — shows on iPhone, Apple Watch). Set `tasks.backend` to `reminders`.
- **Only in plan files** — no sync anywhere. Set `tasks.backend` to `file`.

For Reminders: run `scripts/rem lists`, show the lists, ask what each is for (work, personal, a project…). Save only the ones they want the planner to use, as `{name, purpose}` in `tasks.lists`. If they have no suitable lists, offer to create them with `scripts/rem newlist` — only the names they approve.

Google Tasks do not sync to Apple Reminders; Microsoft Exchange / Office 365 tasks do, if Reminders is ticked for that account (see `connect-microsoft.md`).

## 6. Working day

Ask when they usually start and finish. Save `work_hours.start` / `work_hours.end` as `HH:MM`. Default `10:00`–`18:00`.

Ask where to keep daily plan files. Default `~/Documents/day-planner/plans`. Save as `plans_dir`.

## 7. Planning rules

Show the rules with their defaults as one numbered list and ask which to change. They can answer "ok" to keep all.

1. **Max tasks a day** — 5 real tasks, plus small stuff (`max_tasks`, number)
2. **Deep work in the morning** — hardest task into the longest early window (`deep_work_morning`, on/off)
3. **Prep before meetings** — 20 min before interviews, reviews, syncs with an agenda (`meeting_prep_minutes`, 0 = off)
4. **No overtime** — if the day doesn't fit, cut tasks rather than propose working late (`no_overtime`, on/off)
5. **Group by context** — calls together, reviews together (`group_by_context`, on/off)

## 8. Save and first run

Write `~/.config/day-planner/config.json` (create the folder) following `config.example.json`, with `version: 1`. Show a five-line summary: language, accounts, calendars count, task lists, hours. Run `scripts/check` once more — every line should be `ok`.

Then: "Готово. Скинь, что нужно сделать сегодня" / "Готово. Скинь, що треба зробити сьогодні" / "Done. Tell me what you need to get done today" — and continue with the main loop in `SKILL.md`.
