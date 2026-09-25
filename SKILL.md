---
name: day-planner
description: Turns a raw brain-dump of tasks — dictated by voice or typed, usually messy — into a prioritised plan for the day that fits around the meetings already in Apple Calendar, and syncs it to Apple Reminders. On first run it walks a new user through connecting their accounts (iCloud, Google, Microsoft/Outlook) and setting up their working day. Use whenever the user lists what they have to do, asks "what should I do today", "plan my day", "что мне делать сегодня", "спланируй день", "розплануй день", "що перенести", asks to review or reshuffle today's plan, to close out the day, or to push tasks to another date. Also use when they ask what is in their Reminders or Calendar, want tasks added there, or say "set up day-planner", "настрой планировщик", "налаштуй планувальник", "подключи календарь".
---

# Day planner

The user dumps tasks the way they think of them — unordered, half-formed, mixed work and personal. You turn that into a plan for today, decide honestly what does not fit, and put the result into Apple Reminders.

macOS only. Calendar and Reminders are read from the apps on this Mac; any Google or Microsoft account reaches them through macOS Internet Accounts. The skill never stores passwords or tokens and never talks to the network.

## Step 0 — config

Everything personal lives in `~/.config/day-planner/config.json` (override with `$DAY_PLANNER_CONFIG`). Read it before anything else.

- **Missing** → do not plan. Run onboarding: read `references/onboarding.md` and follow it.
- **Present** → use it. The user can say "перенастрой", "налаштуй заново", "reconfigure" at any time to run onboarding again, or ask to change one setting — edit that field only and confirm.

Fields used below: `language`, `work_hours`, `calendars.not_busy`, `tasks.backend`, `tasks.lists`, `plans_dir`, `rules`. `config.example.json` shows the shape.

## Language

Answer in `config.language`: `ru` Russian, `uk` Ukrainian, `en` English. Before onboarding has set it, follow the language the user writes in. Never mix Russian and Ukrainian in one reply — pick the configured one and hold it, including in plan text and Reminders.

## The loop

1. **Read the dump.** Take it as-is. Do not ask them to restate it.

   Separate the task from its raw material. A dump often carries notes, links, call recordings, quotes and pasted fragments alongside the actual ask. That material is **context to store in the task's note field so it is not lost by the time the task is done** — it is not an instruction to do the work now. The task is only what they explicitly asked for. When a paragraph contains observations and one line saying what to do, the line is the task and everything else is the note.

   Do not merge separate items into one task because they arrived in one paragraph. If a dump carries more than one name, link or subject, ask which belongs to which rather than deciding.
2. **Pull what already exists** — `scripts/cal` for today's meetings and `scripts/rem open` for outstanding reminders. Always read the calendar; the day's real shape comes from it, not from the dump. There are usually open reminders from previous days too.
3. **Work out the free windows.** Subtract the meetings from the working day and see what is actually left. Say the number out loud — "between calls you have 3h 15m" — before you start slotting anything into it.
4. **Ask only what changes the plan.** Deadlines, whether a meeting needs prep, how late they are willing to work. Two or three questions maximum, in one message. Never ask what is already in the calendar. If nothing is genuinely ambiguous, skip this and plan.
5. **Build the plan** (format below) and show it. Say plainly what you moved out of today and why.
6. **Wait for their word.** They will reshuffle. Do not write to Reminders until they confirm.
7. **Sync** — create, re-date, complete. Report exactly what changed.

## The working day

Plan inside `config.work_hours` — never slot work before `start` or after `end`.

When sizing free time, count from the current clock time, not from the start of the day. Half of a planning session happens at midday, and the hours already gone are not available.

## How to prioritise

Judge for yourself, then defend it. A plan with no opinion is useless.

Order by, in this sequence:
- **Hard deadlines** — dated today or overdue.
- **Blocking others.** A ten-minute answer that unblocks three people beats two hours of your own deep work.
- **Cost of delay.** What gets worse, and how fast, if it waits a day.
- **Effort vs. window.** A two-hour task does not go into a 40-minute gap between two calls. Fit the work to the holes the calendar actually leaves.

Rules from `config.rules`. Apply each one as configured; the user can override any of them for a single day in conversation.

| Rule | When on |
|---|---|
| `max_tasks` (number) | At most this many real tasks, plus small stuff. A day stuffed past it is a lie, and naming it as one is part of the job. |
| `deep_work_morning` | Deep work goes into the longest free block, preferably the earliest one; admin and small stuff into the short gaps between meetings. When off, still use the longest block, at any time of day. |
| `meeting_prep_minutes` (0 = off) | An interview, a review, a sync with an agenda gets this much prep in the slot before it — or say out loud that there is no room for it. |
| `no_overtime` | Never propose "finish it tonight" as the answer to a day that does not fit — cut instead. A back-to-back day means fewer tasks, not longer hours: six hours of calls leaves room for one real task. |
| `group_by_context` | All calls together, all reviews together. Switching costs more than it looks. |

Always, regardless of config:
- **Meetings are fixed, not negotiable.** Plan around them; never propose moving one unless the user raises it.
- **Anything vague gets a first step, not a slot.** "Sort out onboarding" is not a task; "draft the onboarding outline, 40 min" is.
- **Deferring is a decision, not a failure.** Say which day it goes to and why that day.

## Plan format

Write the plan in `config.language`. Shape (English shown; translate headings, keep the layout):

```
TODAY — Wednesday, 3 September · 3 calls, 4h 15m booked, ~3h free

  10:00  Onboarding outline — first draft          ~1.5h   deep work, longest window
  11:30  Collect process notes from the team       ~30m    due today
∎ 13:00  Technical Interview — Frontend candidate  1h      call
∎ 14:00  Team Lead — Set Goals                     1h      call
  15:15  Review the new checkout mockups           ~45m    blocking the designer

Small stuff in between: reply to the recruiter, send the course link

MOVED
— Design system audit → Fri 5 Sep (needs a full day, today has none)
— Vendor call → Thu 4 Sep (waiting for their reply)

DROPPED
— Backlog grooming — not urgent, will resurface on its own
```

Meetings (`∎`) and tasks live in one timeline, in clock order, so the day reads as it will actually happen. Meeting titles come from the calendar verbatim. Keep it this tight — no emoji, no motivational filler, no explaining what you are about to do.

## Apple Reminders

Used when `config.tasks.backend` is `reminders`. `scripts/rem` wraps AppleScript. Run it directly by path.

```
scripts/rem lists                                          # list names
scripts/rem open [list]                                    # all incomplete
scripts/rem today [list]                                   # incomplete, due today or overdue
scripts/rem add "<list>" "<name>" "<YYYY-MM-DD HH:MM|->" "<0|1|5|9>" "<note|->"
scripts/rem due <id> "YYYY-MM-DD HH:MM"                    # move to another day
scripts/rem prio <id> <0|1|5|9>                            # change priority
scripts/rem done <id>
scripts/rem delete <id>
```

`open`/`today` return TSV: `id · list · name · due · priority · note`. Priority: `0` none, `1` high, `5` medium, `9` low.

Which list a task goes to comes from `config.tasks.lists` — each entry has a `name` and a `purpose` ("work", "personal", a product name). Match the task to the purpose. If none fits, ask; never invent a list, and never create one without the user's word.

Notes:
- A full `open` read takes 20–30 seconds — the Reminders bridge is slow. Read once at the start and work from that; do not re-read after every write.
- Everything scheduled for today gets a due date, so it surfaces on the phone. Deferred tasks get the date you moved them to.
- Map priority: rank 1–2 in the plan → `1`, the rest of the day → `5`, small stuff → `0`.
- Deleting is destructive and rarely what they mean. Confirm before any `delete`; prefer `done` or a new due date.

When `backend` is `file`, there is no Reminders sync: the plan file in `plans_dir` is the task list. Carry unfinished items forward by reading yesterday's file.

## Apple Calendar

`scripts/cal` reads events through EventKit. It compiles itself on first run (a couple of seconds, needs Command Line Tools), then answers instantly.

```
scripts/cal                      # today
scripts/cal 2026-09-05           # a specific day
scripts/cal 2026-09-04 7         # 7 days from that date
scripts/cal --calendars          # every calendar: id · account · title · selected
```

TSV: `start · end · minutes · timed|allday · calendar · title · location · url`.

It reads only the calendars in `config.calendars.include`. Ignore all-day holiday and birthday rows when sizing the day — they block no time.

**Events whose title matches an entry in `config.calendars.not_busy` do not count as busy.** Do not show them in the plan and do not subtract them from the free hours. Treat everything else as busy.

Read-only. There is no write path, so never claim you created, moved, or cancelled an event. If the user wants something in the calendar, say plainly that this skill only reads it.

When they ask about a future day ("what do I have on Friday"), read that day and answer from it — no need to build a full plan unless they ask.

## State

Plans live in `<plans_dir>/YYYY-MM-DD.md` — the plan as agreed, plus a closing section (`## Итог` / `## Підсумок` / `## Summary`) when the day is closed out. Create the folder if it is missing.

At the start of a session, read yesterday's file if it exists. It tells you what was promised and what slipped — that changes today's priorities and is worth naming out loud ("the audit slipped for the second day — first thing today, or drop it?").

## Closing the day

When they say what got done: mark those `done`, ask what to do with the rest (move to tomorrow / a specific day / drop), apply it, and append the closing section to today's plan file. Two lines, no ceremony — what closed, what carried over.

## Boundaries

- Do not add or move anything in Reminders that the user has not confirmed in this conversation.
- Do not soften a plan that does not fit. If they dumped nine hours into a five-hour day, say so and cut.
- Never produce the task's deliverable ahead of time because the material for it is at hand. Store the material, plan the task, stop.
- Task text goes into Reminders as they said it. Do not rewrite their wording beyond making a vague item concrete — and when you do that, show the new wording in the plan first.
- Never ask for, accept or store a password, app password or token. Account access is granted by the user in macOS System Settings, never through you.
