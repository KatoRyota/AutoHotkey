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
Space & v:: Run('"C:\clibor\Clibor.exe" /cm') ; Cliborメイン画面表示(ホットキー呼びだしと同じ動作)
Space & a:: Run('"C:\clibor\Clibor.exe" /fr') ; 常に表示するの有効・無効
Space & s:: Run('"C:\clibor\Clibor.exe" /ml') ; クリップボード履歴の複数選択画面の表示
Space & d:: Run('"C:\clibor\Clibor.exe" /tg') ; 定型文グループの編集画面の表示

XButton1:: ResetMouseSettings(env)
XButton2:: ChangeHorizontalScrollDirectionMode(env)
^XButton2:: ChangeSlowMouseSpeedMode(env)
+XButton2:: ChangePageScrollSpeedMode(env)
Pause:: Send("^{F4}")

#HotIf GetKeyState("Space", "P") || IsHorizontalScrolling(env)
WheelUp::WheelLeft
WheelDown::WheelRight
#HotIf

#HotIf WinActive("ahk_exe explorer.exe")
^PgDn:: Send("^{Tab}")
^PgUp:: Send("^+{Tab}")
#HotIf