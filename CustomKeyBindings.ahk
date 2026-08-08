#Requires AutoHotkey v2.0
#Include Environment.ahk
#Include IME.ahk
#Include Mouse.ahk
#Include Translation.ahk
#Include Utility.ahk

Space & v:: return
Space & b:: return
Space & f:: Send("{vk1D}")
Space & g:: return
Space & r:: OpenGoogleTranslate()
Space & t:: return
Space & 4:: return
Space & 5:: return

Space & n:: return
Space & m:: return
Space & h:: return
Space & j:: Send("{vk1C}")
Space & y:: return
Space & u:: return
Space & 6:: return
Space & 7:: return

^#s:: ShowEnvironment(env)
^#l:: ListHotkeys()
^#k:: KeyHistory()
^#e:: ExitApp()

F20:: CloseTab()

#HotIf GetKeyState("Space", "P") || IsHorizontalScrolling(env)
WheelUp::WheelLeft
WheelDown::WheelRight
#HotIf

#HotIf WinActive("ahk_exe explorer.exe")
^PgDn:: Send("^{Tab}")
^PgUp:: Send("^+{Tab}")
#HotIf