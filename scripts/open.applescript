on run argv
	set targetList to item 1 of argv
	set out to {}
	tell application "Reminders"
		if targetList is "-" then
			set theLists to every list
		else
			set theLists to (every list whose name is targetList)
		end if
		repeat with L in theLists
			set ln to name of L
			set props to properties of (every reminder in L whose completed is false)
			repeat with p in props
				set dd to due date of p
				if dd is missing value then
					set de to "-"
				else
					set de to my iso(dd)
				end if
				set bd to body of p
				if bd is missing value then set bd to ""
				set end of out to (id of p) & tab & ln & tab & (name of p) & tab & de & tab & ((priority of p) as text) & tab & my flat(bd)
			end repeat
		end repeat
	end tell
	set AppleScript's text item delimiters to linefeed
	set r to out as text
	set AppleScript's text item delimiters to ""
	return r
end run

on iso(d)
	set y to (year of d) as integer
	set m to (month of d) as integer
	set dy to (day of d) as integer
	set hh to hours of d
	set mm to minutes of d
	return (y as text) & "-" & my pad(m) & "-" & my pad(dy) & " " & my pad(hh) & ":" & my pad(mm)
end iso

on pad(n)
	set s to (n as integer) as text
	if length of s is 1 then set s to "0" & s
	return s
end pad

on flat(t)
	set AppleScript's text item delimiters to {return, linefeed, tab}
	set parts to text items of t
	set AppleScript's text item delimiters to " / "
	set r to parts as text
	set AppleScript's text item delimiters to ""
	return r
end flat
