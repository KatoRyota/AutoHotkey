#Requires AutoHotkey v2.0
#Warn
#InputLevel 100
;#UseHook

; ソースコードは、以下のGitHubリポジトリで管理してます。
; https://github.com/KatoRyota/AutoHotkey

ProcessSetPriority "High"
SendMode "Input"
SendLevel 100
SetKeyDelay 10, 10
SetMouseDelay 10

SPI_GETMOUSESPEED := 0x0070
SPI_SETMOUSESPEED := 0x0071
SPI_GETWHEELSCROLLLINES := 0x0068
SPI_SETWHEELSCROLLLINES := 0x0069
SPI_GETWHEELSCROLLCHARS := 0x006C
SPI_SETWHEELSCROLLCHARS := 0x006D
SPIF_UPDATEINIFILE := 0x0001
SPIF_SENDCHANGE := 0x0002

SlowMouseSpeedMode := false
OriginalMouseSpeed := GetMouseSpeed()
SLOW_MOUSE_SPEED := 1

HighSpeedScrollMode := false
VerticalOriginalSpeedScroll := GetWheelScrollLines()
VERTICAL_HIGH_SPEED_SCROLL := 15
HorizontalOriginalSpeedScroll := GetWheelScrollChars()
HORIZONTAL_HIGH_SPEED_SCROLL := 25

HorizontalScrollMode := false

OnExit ExitFunc

; スクリプトの終了処理を行います。
ExitFunc(ExitReason, ExitCode) {
    ChangeOriginalMouseSpeedMode()
    ChangeVerticalOriginalSpeedScrollMode()
    ChangeHorizontalOriginalSpeedScrollMode()
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

; 低速マウススピードモードを元に戻します。
ChangeOriginalMouseSpeedMode() {
    SetMouseSpeed(OriginalMouseSpeed)
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
        ChangeOriginalMouseSpeedMode()
    }
}

; 高速垂直スクロールモードを元に戻します。
ChangeVerticalOriginalSpeedScrollMode() {
    SetWheelScrollLines(VerticalOriginalSpeedScroll)
}

; 高速垂直スクロールモードにします。
ChangeVerticalHighSpeedScrollMode() {
    SetWheelScrollLines(VERTICAL_HIGH_SPEED_SCROLL)
}

; 高速水平スクロールモードを元に戻します。
ChangeHorizontalOriginalSpeedScrollMode() {
    SetWheelScrollChars(HorizontalOriginalSpeedScroll)
}

; 高速水平スクロールモードにします。
ChangeHorizontalHighSpeedScrollMode() {
    SetWheelScrollChars(HORIZONTAL_HIGH_SPEED_SCROLL)
}

; 高速スクロールモードに切り替えます。トグル方式。
ToggleHighSpeedScrollMode() {
    global HighSpeedScrollMode
    HighSpeedScrollMode := !HighSpeedScrollMode

    if (HighSpeedScrollMode) {
        ChangeVerticalHighSpeedScrollMode()
        ChangeHorizontalHighSpeedScrollMode()
    } else {
        ChangeVerticalOriginalSpeedScrollMode()
        ChangeHorizontalOriginalSpeedScrollMode()
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

; 半角／全角キーを、Backspaceキーにリマップ。
;;sc029::Backspace ;このリマップを行うと、キー配列がおかしくなる。原因不明。

; AppsKeyキーを、右Ctrlキーにリマップ。
;;AppsKey::RControl ;このリマップを行うと、キー配列がおかしくなる。原因不明。

; カタカナ・ひらがなキーを、右Altキーにリマップ。
;;sc070::RAlt ;このリマップを行うと、キー配列がおかしくなる。原因不明。

; ホットキーの一覧を表示します。
^#h::ListHotkeys

; キーヒストリーを表示します。
^#k::KeyHistory

; マウススピードを表示します。
^#p::MsgBox Format("現在のマウススピードは: {1}", GetMouseSpeed())

; スクロールの移動量を表示します。
^#w::MsgBox Format("現在の垂直スクロールの行数は: {1}`n現在の水平スクロールの文字数は: {2}", GetWheelScrollLines(), GetWheelScrollChars())

; 高速スクロールモードに切り替えます。トグル方式。 (sc029 = 半角／全角キー)
sc029::ToggleHighSpeedScrollMode()

; 低速マウススピードモードに切り替えます。トグル方式。 (sc03A = 英数キー)
sc03A::ToggleSlowMouseSpeedMode()

; カタカナ・ひらがなキーを無効化します。 (sc070 = カタカナ・ひらがなキー)
sc070::Return

; 上スクロール or 左スクロール。
WheelUp::WheelUpOrLeft()
; 下スクロール or 右スクロール。
WheelDown::WheelDownOrRight()

; 水平スクロールモードに切り替えます。
XButton1::ChangeHorizontalScrollMode()
; 垂直スクロールモードに切り替えます。
XButton2::ChangeVerticalScrollMode()

; `Alt + Left`キーを送信します。
+^XButton1::Send "!{Left}"
; `Alt + Right`キーを送信します。
+^XButton2::Send "!{Right}"

; `Home`キーを送信します。
^XButton1::Send "{Home}"
; `End`キーを送信します。
^XButton2::Send "{End}"

; `PgUp`キーを送信します。
+XButton1::Send "{PgUp}"
; `PgDn`キーを送信します。
+XButton2::Send "{PgDn}"

; `Ctrl + Home`キーを送信します。
^!XButton1::Send "^{Home}"
; `Ctrl + End`キーを送信します。
^!XButton2::Send "^{End}"

; `Ctrl + PgUp`キーを送信します。
^#XButton1::Send "^{PgUp}"
; `Ctrl + PgDn`キーを送信します。
^#XButton2::Send "^{PgDn}"

; `Shift + Home`キーを送信します。
+!XButton1::Send "+{Home}"
; `Shift + End`キーを送信します。
+!XButton2::Send "+{End}"

; `Ctrl + Shift + Home`キーを送信します。
+#XButton1::Send "+^{Home}"
; `Ctrl + Shift + End`キーを送信します。
+#XButton2::Send "+^{End}"
