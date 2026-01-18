#Requires AutoHotkey v2.0
#Include Environment.ahk
#Include IME.ahk
#Include Mouse.ahk
#Include Translation.ahk
#Include Utility.ahk

Space & f:: ImeOnHanEisu()
Space & j:: ImeOnHiragana()
Space & k:: ImeOnZenEisu()

^#s:: ShowEnvironment(env)
^#l:: ListHotkeys()
^#k:: KeyHistory()
^#e:: ExitApp()

Space & z:: OpenMicrosoftTranslator()
Space & x:: OpenGoogleTranslate()
Space & c:: OpenDeepLTranslate()

XButton1:: ResetMouseSettings(env)
XButton2:: ChangeHorizontalScrollDirectionMode(env)
^XButton2:: ChangeSlowMouseSpeedMode(env)
+XButton2:: ChangePageScrollSpeedMode(env)
Pause:: Send("^{F4}")

#HotIf IsHorizontalScrolling(env)
WheelUp::WheelLeft
WheelDown::WheelRight
#HotIf

#HotIf WinActive("ahk_exe explorer.exe")
^PgDn:: Send("^{Tab}")
^PgUp:: Send("^+{Tab}")
#HotIf