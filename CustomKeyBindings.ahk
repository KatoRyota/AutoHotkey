#Requires AutoHotkey v2.0
#Include Environment.ahk
#Include IME.ahk
#Include Mouse.ahk
#Include Translation-v2.ahk
#Include Information.ahk

!Space:: Send("{Space}")
^Space:: Send("^{Space}")
+Space:: Send("+{Space}")
^+Space:: Send("^+{Space}")

Space & f:: ImeOnHanEisu()
Space & j:: ImeOnHiragana()
Space & k:: ImeOnZenEisu()

^#s:: ShowEnvironment(env)
^#l:: ListHotkeys()
^#k:: KeyHistory()

Space & z:: OpenOrActivateMicrosoftTranslator()
Space & x:: OpenOrActivateGoogleTranslate()
Space & c:: OpenOrActivateDeepLTranslate()

^w:: CloseTab()
^PgDn:: NextTab()
^PgUp:: PreviousTab()
WheelUp:: WheelUpOrLeft(env)
WheelDown:: WheelDownOrRight(env)
XButton1:: ResetMouseSettings(env)
XButton2:: ChangeHorizontalScrollDirectionMode(env)
^XButton2:: ChangeSlowMouseSpeedMode(env)
+XButton2:: ChangePageScrollSpeedMode(env)