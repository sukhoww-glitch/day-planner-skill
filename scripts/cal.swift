// Reads Apple Calendar events via EventKit.
// Usage:
//   cal [YYYY-MM-DD] [days]     events, defaults: today, 1 day
//   cal --calendars             every calendar on this Mac: id · account · title · selected
//
// Only calendars listed in config.json → calendars.include are read.
// If that list is missing or empty, every calendar is read.
// Config: $DAY_PLANNER_CONFIG or ~/.config/day-planner/config.json
import Foundation
import EventKit

func fail(_ msg: String, _ code: Int32) -> Never {
    FileHandle.standardError.write((msg + "\n").data(using: .utf8)!)
    exit(code)
}

func selectedIDs() -> Set<String> {
    let path = ProcessInfo.processInfo.environment["DAY_PLANNER_CONFIG"]
        ?? (NSHomeDirectory() + "/.config/day-planner/config.json")
    guard let data = FileManager.default.contents(atPath: path),
          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
          let cals = json["calendars"] as? [String: Any],
          let include = cals["include"] as? [[String: Any]] else { return [] }
    return Set(include.compactMap { $0["id"] as? String })
}

func clean(_ s: String?) -> String {
    guard let s = s else { return "" }
    return s.replacingOccurrences(of: "\t", with: " ")
            .replacingOccurrences(of: "\n", with: " / ")
            .replacingOccurrences(of: "\r", with: " ")
}

let store = EKEventStore()
let sem = DispatchSemaphore(value: 0)
var granted = false
if #available(macOS 14.0, *) {
    store.requestFullAccessToEvents { ok, _ in granted = ok; sem.signal() }
} else {
    store.requestAccess(to: .event) { ok, _ in granted = ok; sem.signal() }
}
sem.wait()
guard granted else {
    fail("calendar access denied — grant it in System Settings > Privacy & Security > Calendars", 3)
}

let args = CommandLine.arguments
let selected = selectedIDs()

if args.count > 1 && args[1] == "--calendars" {
    let all = store.calendars(for: .event).sorted {
        ($0.source?.title ?? "", $0.title) < ($1.source?.title ?? "", $1.title)
    }
    for c in all {
        let mark = selected.isEmpty ? "-" : (selected.contains(c.calendarIdentifier) ? "yes" : "no")
        print([c.calendarIdentifier, clean(c.source?.title), clean(c.title), mark].joined(separator: "\t"))
    }
    exit(0)
}

let dayStr = args.count > 1 ? args[1] : ISO8601DateFormatter().string(from: Date()).prefix(10).description
let span = args.count > 2 ? (Int(args[2]) ?? 1) : 1

let df = DateFormatter()
df.dateFormat = "yyyy-MM-dd"
df.timeZone = TimeZone.current
guard let start = df.date(from: dayStr) else { fail("bad date: \(dayStr)", 2) }
let end = Calendar.current.date(byAdding: .day, value: span, to: start)!

var calendars: [EKCalendar]? = nil
if !selected.isEmpty {
    calendars = store.calendars(for: .event).filter { selected.contains($0.calendarIdentifier) }
    if calendars!.isEmpty {
        fail("none of the calendars in config.json exist on this Mac — rerun onboarding", 4)
    }
}

let out = DateFormatter()
out.dateFormat = "yyyy-MM-dd HH:mm"
out.timeZone = TimeZone.current

let predicate = store.predicateForEvents(withStart: start, end: end, calendars: calendars)
let events = store.events(matching: predicate).sorted { $0.startDate < $1.startDate }

for e in events {
    if e.status == .canceled { continue }
    let allDay = e.isAllDay ? "allday" : "timed"
    let s = e.isAllDay ? df.string(from: e.startDate) : out.string(from: e.startDate)
    let t = e.isAllDay ? df.string(from: e.endDate)   : out.string(from: e.endDate)
    let mins = e.isAllDay ? 0 : Int(e.endDate.timeIntervalSince(e.startDate) / 60)
    let url = e.url?.absoluteString ?? ""
    print([s, t, "\(mins)", allDay, clean(e.calendar?.title), clean(e.title), clean(e.location), url].joined(separator: "\t"))
}
