#Requires AutoHotkey v2.0
#Include Environment.ahk
#Include IME.ahk
#Include Mouse.ahk
#Include Translation.ahk
#Include Utility.ahk

Space & a:: OpenGoogleTranslate()
Space & s:: return
Space & d:: return
Space & f:: Send("{vk1D}")
Space & g:: return
Space & h:: return
Space & j:: Send("{vk1C}")
Space & k:: return
Space & l:: return
Space & `;:: return
Space & ':: return

Space & z:: return
Space & x:: return
Space & c:: return
Space & v:: return
Space & b:: return
Space & n:: return
Space & m:: return
Space & ,:: return
Space & .:: return
Space & /:: return

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