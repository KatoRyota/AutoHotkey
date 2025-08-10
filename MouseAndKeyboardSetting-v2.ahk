#Requires AutoHotkey v2.0
#Warn
#InputLevel 100
#UseHook

; ソースコードは、以下のGitHubリポジトリで管理してます。
; https://github.com/KatoRyota/AutoHotkey

ProcessSetPriority "High"
SendMode "Input"
SendLevel 100

SPI_GETMOUSESPEED := 0x0070
SPI_SETMOUSESPEED := 0x0071
SPI_GETWHEELSCROLLLINES := 0x0068
SPI_SETWHEELSCROLLLINES := 0x0069
SPI_GETWHEELSCROLLCHARS := 0x006C
SPI_SETWHEELSCROLLCHARS := 0x006D
SPIF_UPDATEINIFILE := 0x0001
SPIF_SENDCHANGE := 0x0002

slowMouseSpeedMode := false
defaultMouseSpeed := GetMouseSpeed()
SLOW_MOUSE_SPEED := 1

verticalScrollMode := true
horizontalScrollMode := false

pageScrollMode := false
slowSpeedScrollMode := false
highSpeedScrollMode := false

defaultSpeedWheelScrollLines := GetWheelScrollLines()
PAGE_WHEEL_SCROLL_LINES := 0xFFFFFFFF
slowSpeedWheelScrollLines := Ceil(defaultSpeedWheelScrollLines / 3)
highSpeedWheelScrollLines := defaultSpeedWheelScrollLines * 3

defaultSpeedWheelScrollChars := GetWheelScrollChars()
slowSpeedWheelScrollChars := Ceil(defaultSpeedWheelScrollChars / 3)
highSpeedWheelScrollChars := defaultSpeedWheelScrollChars * 3

hotkeys := []

OnExit ExitFunc

; ホットキーの一覧を表示します。
ShowHotkeys() {
    popup := Gui("", "ホットキー一覧")
    popup.Opt("+AlwaysOnTop -DPIScale")
    popup.SetFont("s12 q5", "Meiryo UI")

    listViewWidth := 1100
    listViewHeight := 700

    listViewOptions := Format("NoSort Grid ReadOnly w{1} h{2}", listViewWidth, listViewHeight)
    listView := popup.Add("ListView", listViewOptions, ["ホットキー", "説明"])

    for (hKey in hotkeys) {
        listView.Add("", hKey.key, hKey.desc)
    }

    listView.ModifyCol()

    popup.Add("Button", "Default", "閉じる").OnEvent("Click", (*) => popup.Destroy())
    popup.OnEvent("Close", (*) => popup.Destroy())
    popup.OnEvent("Escape", (*) => popup.Destroy())

    WinGetPos(&wx, &wy, &ww, &wh, "A")

    popup.Show("AutoSize Hide")
    popup.GetPos(, , &gw, &gh)

    x := wx + Floor((ww - gw) / 2)
    y := wy + Floor((wh - gh) / 2)

    popupOptions := Format("x{1} y{2}", x, y)

    popup.Show(popupOptions)
}

; 現在の設定を表示します。
ShowSettings() {
    popup := Gui("", "現在の設定")
    popup.Opt("+AlwaysOnTop -DPIScale")
    popup.SetFont("s12 q5", "Meiryo UI")

    listViewWidth := 1100
    listViewHeight := 700

    listViewOptions := Format("NoSort Grid ReadOnly w{1} h{2}", listViewWidth, listViewHeight)
    listView := popup.Add("ListView", listViewOptions, ["設定項目", "値"])

    listView.Add("", "マウススピード", GetMouseSpeed())
    listView.Add("", "垂直スクロールの行数", GetWheelScrollLines())
    listView.Add("", "水平スクロールの文字数", GetWheelScrollChars())
    listView.Add("", "垂直スクロールモード", verticalScrollMode ? "オン" : "オフ")
    listView.Add("", "水平スクロールモード", horizontalScrollMode ? "オン" : "オフ")
    listView.Add("", "1画面スクロールモード", pageScrollMode ? "オン" : "オフ")
    listView.Add("", "低速スクロールモード", slowSpeedScrollMode ? "オン" : "オフ")
    listView.Add("", "高速スクロールモード", highSpeedScrollMode ? "オン" : "オフ")
    listView.ModifyCol()

    popup.Add("Button", "Default", "閉じる").OnEvent("Click", (*) => popup.Destroy())
    popup.OnEvent("Close", (*) => popup.Destroy())
    popup.OnEvent("Escape", (*) => popup.Destroy())

    WinGetPos(&wx, &wy, &ww, &wh, "A")

    popup.Show("AutoSize Hide")
    popup.GetPos(, , &gw, &gh)

    x := wx + Floor((ww - gw) / 2)
    y := wy + Floor((wh - gh) / 2)

    popupOptions := Format("x{1} y{2}", x, y)

    popup.Show(popupOptions)
}

; 上スクロール or 左スクロール。
WheelUpOrLeft() {
    if (horizontalScrollMode) {
        Send("{WheelLeft}")
    } else {
        Send("{WheelUp}")
    }
}

; 下スクロール or 右スクロール。
WheelDownOrRight() {
    if (horizontalScrollMode) {
        Send("{WheelRight}")
    } else {
        Send("{WheelDown}")
    }
}

; 低速マウススピードモードに切り替えます。トグル方式。
ToggleSlowMouseSpeedMode() {
    global slowMouseSpeedMode
    slowMouseSpeedMode := !slowMouseSpeedMode

    if (slowMouseSpeedMode) {
        ChangeSlowMouseSpeedMode()
    } else {
        ChangeDefaultMouseSpeedMode()
    }
}

; 1画面スクロールモードに切り替えます。トグル方式。
TogglePageScrollMode() {
    global pageScrollMode
    global slowSpeedScrollMode
    global highSpeedScrollMode
    pageScrollMode := !pageScrollMode
    slowSpeedScrollMode := false
    highSpeedScrollMode := false

    if (pageScrollMode) {
        ChangePageVerticalScrollMode()
        ChangeDefaultSpeedHorizontalScrollMode()
    } else {
        ChangeDefaultSpeedVerticalScrollMode()
        ChangeDefaultSpeedHorizontalScrollMode()
    }
}

; 低速スクロールモードに切り替えます。トグル方式。
ToggleSlowSpeedScrollMode() {
    global pageScrollMode
    global slowSpeedScrollMode
    global highSpeedScrollMode
    pageScrollMode := false
    slowSpeedScrollMode := !slowSpeedScrollMode
    highSpeedScrollMode := false

    if (slowSpeedScrollMode) {
        ChangeSlowSpeedVerticalScrollMode()
        ChangeDefaultSpeedHorizontalScrollMode()
    } else {
        ChangeDefaultSpeedVerticalScrollMode()
        ChangeDefaultSpeedHorizontalScrollMode()
    }
}

; 高速スクロールモードに切り替えます。トグル方式。
ToggleHighSpeedScrollMode() {
    global pageScrollMode
    global slowSpeedScrollMode
    global highSpeedScrollMode
    pageScrollMode := false
    slowSpeedScrollMode := false
    highSpeedScrollMode := !highSpeedScrollMode

    if (highSpeedScrollMode) {
        ChangeHighSpeedVerticalScrollMode()
        ChangeDefaultSpeedHorizontalScrollMode()
    } else {
        ChangeDefaultSpeedVerticalScrollMode()
        ChangeDefaultSpeedHorizontalScrollMode()
    }
}

; デフォルト マウススピードモードにします。
ChangeDefaultMouseSpeedMode() {
    SetMouseSpeed(defaultMouseSpeed)
}

; 低速マウススピードモードにします。
ChangeSlowMouseSpeedMode() {
    SetMouseSpeed(SLOW_MOUSE_SPEED)
}

; 垂直スクロールモードに切り替えます。
ChangeVerticalScrollMode() {
    global verticalScrollMode
    global horizontalScrollMode
    verticalScrollMode := true
    horizontalScrollMode := false
}

; 水平スクロールモードに切り替えます。
ChangeHorizontalScrollMode() {
    global verticalScrollMode
    global horizontalScrollMode
    verticalScrollMode := false
    horizontalScrollMode := true
}

; デフォルト垂直スクロールモードにします。
ChangeDefaultSpeedVerticalScrollMode() {
    SetWheelScrollLines(defaultSpeedWheelScrollLines)
}

; 1画面垂直スクロールモードにします。
ChangePageVerticalScrollMode() {
    SetWheelScrollLines(PAGE_WHEEL_SCROLL_LINES)
}

; 低速垂直スクロールモードにします。
ChangeSlowSpeedVerticalScrollMode() {
    SetWheelScrollLines(slowSpeedWheelScrollLines)
}

; 高速垂直スクロールモードにします。
ChangeHighSpeedVerticalScrollMode() {
    SetWheelScrollLines(highSpeedWheelScrollLines)
}

; デフォルト水平スクロールモードにします。
ChangeDefaultSpeedHorizontalScrollMode() {
    SetWheelScrollChars(defaultSpeedWheelScrollChars)
}

; 低速水平スクロールモードにします。
ChangeSlowSpeedHorizontalScrollMode() {
    SetWheelScrollChars(slowSpeedWheelScrollChars)
}

; 高速水平スクロールモードにします。
ChangeHighSpeedHorizontalScrollMode() {
    SetWheelScrollChars(highSpeedWheelScrollChars)
}

; マウススピードを取得します。
GetMouseSpeed() {
    mouseSpeed := Buffer(4)

    DllCall("SystemParametersInfo",
        "UInt", SPI_GETMOUSESPEED,
        "UInt", 0,
        "Ptr", mouseSpeed,
        "UInt", 0)

    return NumGet(mouseSpeed, 0, "UInt")
}

; マウススピードを変更します。
SetMouseSpeed(mouseSpeed) {
    DllCall("SystemParametersInfo",
        "UInt", SPI_SETMOUSESPEED,
        "UInt", 0,
        "UInt", mouseSpeed,
        "UInt", SPIF_UPDATEINIFILE | SPIF_SENDCHANGE)
}

; 垂直スクロールの行数を取得します。
GetWheelScrollLines() {
    wheelScrollLines := Buffer(4)

    DllCall("SystemParametersInfo",
        "UInt", SPI_GETWHEELSCROLLLINES,
        "UInt", 0,
        "Ptr", wheelScrollLines,
        "UInt", 0)

    return NumGet(wheelScrollLines, 0, "UInt")
}

; 垂直スクロールの行数を変更します。
SetWheelScrollLines(wheelScrollLines) {
    DllCall("SystemParametersInfo",
        "UInt", SPI_SETWHEELSCROLLLINES,
        "UInt", wheelScrollLines,
        "UInt", 0,
        "UInt", SPIF_UPDATEINIFILE | SPIF_SENDCHANGE)
}

; 水平スクロールの文字数を取得します。
GetWheelScrollChars() {
    wheelScrollChars := Buffer(4)

    DllCall("SystemParametersInfo",
        "UInt", SPI_GETWHEELSCROLLCHARS,
        "UInt", 0,
        "Ptr", wheelScrollChars,
        "UInt", 0)

    return NumGet(wheelScrollChars, 0, "UInt")
}

; 水平スクロールの文字数を変更します。
SetWheelScrollChars(wheelScrollChars) {
    DllCall("SystemParametersInfo",
        "UInt", SPI_SETWHEELSCROLLCHARS,
        "UInt", wheelScrollChars,
        "UInt", 0,
        "UInt", SPIF_UPDATEINIFILE | SPIF_SENDCHANGE)
}

; スクリプトの終了処理を行います。
ExitFunc(exitReason, exitCode) {
    ChangeDefaultMouseSpeedMode()
    ChangeDefaultSpeedVerticalScrollMode()
    ChangeDefaultSpeedHorizontalScrollMode()
}

; ホットキーを登録します。
RegisterHotkey(key, func, desc := "") {
    hotkeys.Push({key: key, desc: desc})
    Hotkey(key, func)
}

; ホットキーの一覧を表示します。
RegisterHotkey("^#h", (*) => ShowHotkeys(), "ホットキーの一覧を表示します。")

; 現在の設定を表示します。
RegisterHotkey("^#s", (*) => ShowSettings(), "現在の設定を表示します。")

; ホットキーの一覧を表示します。ListHotkeys関数。
RegisterHotkey("^#l", (*) => ListHotkeys(), "ホットキーの一覧を表示します。ListHotkeys関数。")

; キーヒストリーを表示します。KeyHistory関数。
RegisterHotkey("^#k", (*) => KeyHistory(), "キーヒストリーを表示します。KeyHistory関数。")

; 低速マウススピードモードに切り替えます。トグル方式。 (sc03A = 英数キー)
RegisterHotkey("sc03A", (*) => ToggleSlowMouseSpeedMode(), "低速マウススピードモードに切り替えます。トグル方式。 (sc03A = 英数キー)")

; 1画面スクロールモードに切り替えます。トグル方式。(sc029 = 半角／全角キー)
RegisterHotkey("sc029", (*) => TogglePageScrollMode(), "1画面スクロールモードに切り替えます。トグル方式。(sc029 = 半角／全角キー)")

; 低速スクロールモードに切り替えます。トグル方式。(sc070 = カタカナ・ひらがなキー)
RegisterHotkey("sc070", (*) => ToggleSlowSpeedScrollMode(), "低速スクロールモードに切り替えます。トグル方式。(sc070 = カタカナ・ひらがなキー)")

; 上スクロール or 左スクロール。
RegisterHotkey("WheelUp", (*) => WheelUpOrLeft(), "上スクロール or 左スクロール。")
; 下スクロール or 右スクロール。
RegisterHotkey("WheelDown", (*) => WheelDownOrRight(), "下スクロール or 右スクロール。")

; 水平スクロールモードに切り替えます。
RegisterHotkey("XButton1", (*) => ChangeHorizontalScrollMode(), "水平スクロールモードに切り替えます。")
; 垂直スクロールモードに切り替えます。
RegisterHotkey("XButton2", (*) => ChangeVerticalScrollMode(), "垂直スクロールモードに切り替えます。")

; 『Alt + Left』キーを送信します。
RegisterHotkey("+^XButton1", (*) => Send("!{Left}"), "『Alt + Left』キーを送信します。")
; 『Alt + Right』キーを送信します。
RegisterHotkey("+^XButton2", (*) => Send("!{Right}"), "『Alt + Right』キーを送信します。")

; 『Home』キーを送信します。
RegisterHotkey("^XButton1", (*) => Send("{Home}"), "『Home』キーを送信します。")
; 『End』キーを送信します。
RegisterHotkey("^XButton2", (*) => Send("{End}"), "『End』キーを送信します。")

; 『PgUp』キーを送信します。
RegisterHotkey("+XButton1", (*) => Send("{PgUp}"), "『PgUp』キーを送信します。")
; 『PgDn』キーを送信します。
RegisterHotkey("+XButton2", (*) => Send("{PgDn}"), "『PgDn』キーを送信します。")

; 『Ctrl + Home』キーを送信します。
RegisterHotkey("^!XButton1", (*) => Send("^{Home}"), "『Ctrl + Home』キーを送信します。")
; 『Ctrl + End』キーを送信します。
RegisterHotkey("^!XButton2", (*) => Send("^{End}"), "『Ctrl + End』キーを送信します。")

; 『Ctrl + PgUp』キーを送信します。
RegisterHotkey("^#XButton1", (*) => Send("^{PgUp}"), "『Ctrl + PgUp』キーを送信します。")
; 『Ctrl + PgDn』キーを送信します。
RegisterHotkey("^#XButton2", (*) => Send("^{PgDn}"), "『Ctrl + PgDn』キーを送信します。")

; 『Shift + Home』キーを送信します。
RegisterHotkey("+!XButton1", (*) => Send("+{Home}"), "『Shift + Home』キーを送信します。")
; 『Shift + End』キーを送信します。
RegisterHotkey("+!XButton2", (*) => Send("+{End}"), "『Shift + End』キーを送信します。")

; 『Shift + Ctrl + Home』キーを送信します。
RegisterHotkey("+#XButton1", (*) => Send("+^{Home}"), "『Shift + Ctrl + Home』キーを送信します。")
; 『Shift + Ctrl + End』キーを送信します。
RegisterHotkey("+#XButton2", (*) => Send("+^{End}"), "『Shift + Ctrl + End』キーを送信します。")
