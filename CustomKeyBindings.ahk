#Requires AutoHotkey v2.0
#Include Environment.ahk
#Include IME.ahk
#Include Mouse.ahk
#Include Translation.ahk
#Include Utility.ahk

Space & F1:: Send("^+!{F1}")
Space & F2:: Send("^+!{F2}")
Space & F3:: Send("^+!{F3}")
Space & F4:: Send("^+!{F4}")
Space & F5:: Send("^+!{F5}")
Space & F6:: Send("^+!{F6}")
Space & F7:: Send("^+!{F7}")
Space & F8:: Send("^+!{F8}")
Space & F9:: Send("^+!{F9}")
Space & F10:: Send("^+!{F10}")
Space & F11:: Send("^+!{F11}")
Space & F12:: Send("^+!{F12}")

Space & `:: Send("^+!``")
Space & 1:: Send("^+!1")
Space & 2:: Send("^+!2")
Space & 3:: Send("^+!3")
Space & 4:: Send("^+!4")
Space & 5:: Send("^+!5")
Space & 6:: Send("^+!6")
Space & 7:: Send("^+!7")
Space & 8:: Send("^+!8")
Space & 9:: Send("^+!9")
Space & 0:: Send("^+!0")
Space & -:: Send("^+!-")
Space & =:: Send("^+!=")

#HotIf WinActive("ahk_exe brave.exe") || WinActive("ahk_exe firefox.exe")
Space & q:: Send("+!q")
Space & w:: Send("+!w")
Space & e:: Send("+!e")
Space & r:: Send("+!r")
Space & t:: Send("+!t")
Space & y:: Send("+!y")
Space & u:: Send("+!u")
Space & i:: Send("+!i")
Space & o:: Send("+!o")
Space & p:: Send("+!p")
Space & [:: Send("+![")
Space & ]:: Send("+!]")
Space & \:: Send("+!\")
#HotIf

Space & q:: Send("^+!q")
Space & w:: Send("^+!w")
Space & e:: Send("^+!e")
Space & r:: Send("^+!r")
Space & t:: Send("^+!t")
Space & y:: Send("^+!y")
Space & u:: Send("^+!u")
Space & i:: Send("^+!i")
Space & o:: Send("^+!o")
Space & p:: Send("^+!p")
Space & [:: Send("^+![")
Space & ]:: Send("^+!]")
Space & \:: Send("^+!\")

Space & a:: OpenGoogleTranslate()
Space & s:: Send("^+!s")
Space & d:: Send("^+!d")
Space & f:: Send("{vk1D}")
Space & g:: Send("^+!g")
Space & h:: Send("^+!h")
Space & j:: Send("{vk1C}")
Space & k:: Send("^+!k")
Space & l:: Send("^+!l")
Space & `;:: Send("^+!;")
Space & ':: Send("^+!'")

Space & z:: Send("^+!z")
Space & x:: Send("^+!x")
Space & c:: Send("^+!c")
Space & v:: Send("^+!v")
Space & b:: Send("^+!b")
Space & n:: Send("^+!n")
Space & m:: Send("^+!m")
Space & ,:: Send("^+!,")
Space & .:: Send("^+!.")
Space & /:: Send("^+!/")

^#s:: ShowEnvironment(env)
^#l:: ListHotkeys()
^#k:: KeyHistory()
^#e:: ExitApp()

^+!w:: CloseTab()

#HotIf GetKeyState("Space", "P") || IsHorizontalScrolling(env)
WheelUp::WheelLeft
WheelDown::WheelRight
#HotIf

#HotIf WinActive("ahk_exe explorer.exe")
^PgDn:: Send("^{Tab}")
^PgUp:: Send("^+{Tab}")
#HotIf