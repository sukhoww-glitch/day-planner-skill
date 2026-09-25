# day-planner

A Claude skill that turns a messy list of tasks into a realistic plan for the day — fitted around the meetings in your calendar — and syncs it to Apple Reminders. Speaks Russian, Ukrainian or English.

**macOS only.** Works with iCloud, Google and Microsoft (Outlook / Office 365) calendars through the Mac's Calendar app. The skill stores no passwords or tokens and makes no network calls; you connect accounts yourself in System Settings, and the skill walks you through it.

## Install

1. Put this `day-planner` folder into `~/.claude/skills/`:
   ```bash
   mkdir -p ~/.claude/skills && cp -R day-planner ~/.claude/skills/
   ```
2. Make the scripts executable (zip archives sometimes drop this):
   ```bash
   chmod +x ~/.claude/skills/day-planner/scripts/{cal,rem,check}
   ```
3. Open Claude (desktop app, Code tab, or `claude` in Terminal) and say **"set up day-planner"** / **"настрой планировщик"** / **"налаштуй планувальник"**.

On first run the skill asks your language, checks the Mac, helps you connect the accounts you choose, lets you pick which calendars and Reminders lists it may use, and asks about your working hours and planning rules. macOS will ask for Calendar and Reminders access — allow it.

You may need Apple's Command Line Tools (the skill tells you if so): `xcode-select --install`.

## Use

Just dump what's on your mind: "what should I do today: finish the report, call the vendor, review mockups…". You get a plan; nothing is written to Reminders until you confirm.

"Reconfigure" / "перенастрой" / "налаштуй заново" reruns the setup.

## Where your data lives

| What | Where |
|---|---|
| Your settings | `~/.config/day-planner/config.json` — outside the skill folder, so updating the skill keeps them |
| Daily plans | `~/Documents/day-planner/plans/` (changeable during setup) |
| Calendar events, reminders | read from the Mac's Calendar and Reminders apps, only the calendars and lists you selected |

Nothing personal is kept inside the skill folder — safe to share it as is.
