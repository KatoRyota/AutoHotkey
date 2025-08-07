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

SlowMouseSpeedMode := false
DefaultMouseSpeed := GetMouseSpeed()
SLOW_MOUSE_SPEED := 1

HighSpeedScrollMode := false
DefaultSpeedWheelScrollLines := GetWheelScrollLines()
HIGH_SPEED_WHEEL_SCROLL_LINES := 9
DefaultSpeedWheelScrollChars := GetWheelScrollChars()
HIGH_SPEED_WHEEL_SCROLL_CHARS := 15

PageVerticalScrollMode := false
WHEEL_PAGESCROLL := 0xFFFFFFFF

HorizontalScrollMode := false

Hotkeys := []

OnExit ExitFunc

; ホットキーの一覧を表示します。
ShowHotkeys() {
    popup := Gui("", "ホットキー一覧")
    popup.Opt("+AlwaysOnTop")
    popup.SetFont("s12 q5", "MS Sans Serif")

    lv := popup.Add("ListView", "NoSort Grid ReadOnly r20 w700", ["ホットキー", "説明"])

    for item in Hotkeys {
        lv.Add("", item.key, item.desc)
    }

    lv.ModifyCol()

    popup.Add("Button", "Default", "閉じる").OnEvent("Click", (*) => popup.Destroy())
    popup.OnEvent("Close", (*) => popup.Destroy())
    popup.OnEvent("Escape", (*) => popup.Destroy())
    popup.Show()
}

; 現在の設定を表示します。
ShowSettings() {
    popup := Gui("", "現在の設定")
    popup.Opt("+AlwaysOnTop")
    popup.SetFont("s12 q5", "MS Sans Serif")

    lv := popup.Add("ListView", "NoSort Grid ReadOnly r20 w700", ["設定項目", "値"])

    lv.Add("", "マウススピード", GetMouseSpeed())
    lv.Add("", "垂直スクロールの行数", GetWheelScrollLines())
    lv.Add("", "水平スクロールの文字数", GetWheelScrollChars())

    lv.ModifyCol()

    popup.Add("Button", "Default", "閉じる").OnEvent("Click", (*) => popup.Destroy())
    popup.OnEvent("Close", (*) => popup.Destroy())
    popup.OnEvent("Escape", (*) => popup.Destroy())
    popup.Show()
}

; マウススピードを取得します。
GetMouseSpeed() {
    MouseSpeed := Buffer(4)
    DllCall("SystemParametersInfo",
        "UInt", SPI_GETMOUSESPEED,
        "UInt", 0,
        "Ptr", MouseSpeed,
        "UInt", 0)
    return NumGet(MouseSpeed, 0, "UInt")
}

; マウススピードを変更します。
SetMouseSpeed(MouseSpeed) {
    DllCall("SystemParametersInfo",
        "UInt", SPI_SETMOUSESPEED,
        "UInt", 0,
        "UInt", MouseSpeed,
        "UInt", SPIF_UPDATEINIFILE | SPIF_SENDCHANGE)
}

; 垂直スクロールの行数を取得します。
GetWheelScrollLines() {
    WheelScrollLines := Buffer(4)
    DllCall("SystemParametersInfo",
        "UInt", SPI_GETWHEELSCROLLLINES,
        "UInt", 0,
        "Ptr", WheelScrollLines,
        "UInt", 0)
    return NumGet(WheelScrollLines, 0, "UInt")
}

; 垂直スクロールの行数を変更します。
SetWheelScrollLines(WheelScrollLines) {
    DllCall("SystemParametersInfo",
        "UInt", SPI_SETWHEELSCROLLLINES,
        "UInt", WheelScrollLines,
        "UInt", 0,
        "UInt", SPIF_UPDATEINIFILE | SPIF_SENDCHANGE)
}

; 水平スクロールの文字数を取得します。
GetWheelScrollChars() {
    WheelScrollChars := Buffer(4)
    DllCall("SystemParametersInfo",
        "UInt", SPI_GETWHEELSCROLLCHARS,
        "UInt", 0,
        "Ptr", WheelScrollChars,
        "UInt", 0)
    return NumGet(WheelScrollChars, 0, "UInt")
}

; 水平スクロールの文字数を変更します。
SetWheelScrollChars(WheelScrollChars) {
    DllCall("SystemParametersInfo",
        "UInt", SPI_SETWHEELSCROLLCHARS,
        "UInt", WheelScrollChars,
        "UInt", 0,
        "UInt", SPIF_UPDATEINIFILE | SPIF_SENDCHANGE)
}

; デフォルト マウススピードモードにします。
ChangeDefaultMouseSpeedMode() {
    SetMouseSpeed(DefaultMouseSpeed)
}

; 低速マウススピードモードにします。
ChangeSlowMouseSpeedMode() {
    SetMouseSpeed(SLOW_MOUSE_SPEED)
}

; 低速マウススピードモードに切り替えます。トグル方式。
ToggleSlowMouseSpeedMode() {
    global SlowMouseSpeedMode
    SlowMouseSpeedMode := !SlowMouseSpeedMode

    if (SlowMouseSpeedMode) {
        ChangeSlowMouseSpeedMode()
    } else {
        ChangeDefaultMouseSpeedMode()
    }
}

; デフォルト垂直スクロールモードにします。
ChangeDefaultSpeedVerticalScrollMode() {
    SetWheelScrollLines(DefaultSpeedWheelScrollLines)
}

; 高速垂直スクロールモードにします。
ChangeHighSpeedVerticalScrollMode() {
    SetWheelScrollLines(HIGH_SPEED_WHEEL_SCROLL_LINES)
}

; 1画面垂直スクロールモードにします。
ChangePageVerticalScrollMode() {
    SetWheelScrollLines(WHEEL_PAGESCROLL)
}

; デフォルト水平スクロールモードにします。
ChangeDefaultSpeedHorizontalScrollMode() {
    SetWheelScrollChars(DefaultSpeedWheelScrollChars)
}

; 高速水平スクロールモードにします。
ChangeHighSpeedHorizontalScrollMode() {
    SetWheelScrollChars(HIGH_SPEED_WHEEL_SCROLL_CHARS)
}

; 高速スクロールモードに切り替えます。トグル方式。
ToggleHighSpeedScrollMode() {
    global HighSpeedScrollMode
    global PageVerticalScrollMode
    HighSpeedScrollMode := !HighSpeedScrollMode
    PageVerticalScrollMode := false

    if (HighSpeedScrollMode) {
        ChangeHighSpeedVerticalScrollMode()
        ChangeHighSpeedHorizontalScrollMode()
    } else {
        ChangeDefaultSpeedVerticalScrollMode()
        ChangeDefaultSpeedHorizontalScrollMode()
    }
}

; 1画面垂直スクロールモードに切り替えます。トグル方式。
TogglePageVerticalScrollMode() {
    global HighSpeedScrollMode
    global PageVerticalScrollMode
    HighSpeedScrollMode := false
    PageVerticalScrollMode := !PageVerticalScrollMode

    if (PageVerticalScrollMode) {
        ChangePageVerticalScrollMode()
        ChangeHighSpeedHorizontalScrollMode()
    } else {
        ChangeDefaultSpeedVerticalScrollMode()
        ChangeDefaultSpeedHorizontalScrollMode()
    }
}

; 垂直スクロールモードに切り替えます。
ChangeVerticalScrollMode() {
    global HorizontalScrollMode
    HorizontalScrollMode := false
}

; 水平スクロールモードに切り替えます。
ChangeHorizontalScrollMode() {
    global HorizontalScrollMode
    HorizontalScrollMode := true
}

; 上スクロール or 左スクロール。
WheelUpOrLeft() {
    if (HorizontalScrollMode) {
        Send "{WheelLeft}"
    } else {
        Send "{WheelUp}"
    }
}

; 下スクロール or 右スクロール。
WheelDownOrRight() {
    if (HorizontalScrollMode) {
        Send "{WheelRight}"
    } else {
        Send "{WheelDown}"
    }
}

; スクリプトの終了処理を行います。
ExitFunc(ExitReason, ExitCode) {
    ChangeDefaultMouseSpeedMode()
    ChangeDefaultSpeedVerticalScrollMode()
    ChangeDefaultSpeedHorizontalScrollMode()
}

; ホットキーを登録します。
RegisterHotkey(key, func, desc := "") {
    Hotkeys.Push({key: key, desc: desc})
    Hotkey key, func
}

; ホットキーの一覧を表示します。
RegisterHotkey("^#h", (*) => ShowHotkeys(), "ホットキーの一覧を表示します。")

; ホットキーの一覧を表示します。ListHotkeys関数。
RegisterHotkey("^#l", (*) => ListHotkeys(), "ホットキーの一覧を表示します。ListHotkeys関数。")

; キーヒストリーを表示します。
RegisterHotkey("^#k", (*) => KeyHistory(), "キーヒストリーを表示します。")

; 現在の設定を表示します。
RegisterHotkey("^#s", (*) => ShowSettings(), "現在の設定を表示します。")

; 低速マウススピードモードに切り替えます。トグル方式。 (sc03A = 英数キー)
RegisterHotkey("sc03A", (*) => ToggleSlowMouseSpeedMode(), "低速マウススピードモードに切り替えます。トグル方式。 (sc03A = 英数キー)")

; 高速スクロールモードに切り替えます。トグル方式。 (sc029 = 半角／全角キー)
RegisterHotkey("sc029", (*) => ToggleHighSpeedScrollMode(), "高速スクロールモードに切り替えます。トグル方式。 (sc029 = 半角／全角キー)")

; 1画面垂直スクロールモードに切り替えます。トグル方式。 (sc070 = カタカナ・ひらがなキー)
RegisterHotkey("sc070", (*) => TogglePageVerticalScrollMode(), "1画面垂直スクロールモードに切り替えます。トグル方式。 (sc070 = カタカナ・ひらがなキー)")

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
