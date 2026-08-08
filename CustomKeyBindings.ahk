#Requires AutoHotkey v2.0
#Include Environment.ahk
#Include IME.ahk
#Include Mouse.ahk
#Include Translation.ahk
#Include Utility.ahk

Space & f:: Send("{vk1D}")
Space & j:: Send("{vk1C}")

^#s:: ShowEnvironment(env)
^#l:: ListHotkeys()
^#k:: KeyHistory()
^#e:: ExitApp()

Space & r:: OpenGoogleTranslate()

F20:: CloseTab()

#HotIf GetKeyState("Space", "P") || IsHorizontalScrolling(env)
WheelUp::WheelLeft
WheelDown::WheelRight
#HotIf

#HotIf WinActive("ahk_exe explorer.exe")
^PgDn:: Send("^{Tab}")
^PgUp:: Send("^+{Tab}")
#HotIf