#Requires AutoHotkey v2.0
#Warn
#UseHook
#InputLevel 100

; ソースコードは、以下のGitHubリポジトリで管理してます。
; https://github.com/KatoRyota/AutoHotkey

ProcessSetPriority "High"
SendMode "Input"
SendLevel 100
SetKeyDelay 10, 10
SetMouseDelay 10
SPI_GETMOUSESPEED := 0x70
SPI_SETMOUSESPEED := 0x71
MOUSE_SPEED_SLOW := 1
OriginalMouseSpeed := GetMouseSpeed()
ScrollMode := "vertical"
OnExit ExitFunc

; スクリプトの終了処理を行います。
ExitFunc(ExitReason, ExitCode) {
    ChangeOriginalMouseSpeed()
}

; 現在のマウスポインターの速度を返します。
GetMouseSpeed() {
    MouseSpeed := Buffer(4)
    DllCall("SystemParametersInfo", "UInt", SPI_GETMOUSESPEED, "UInt", 0, "Ptr", MouseSpeed, "UInt", 0)
    return NumGet(MouseSpeed, 0, "UInt")
}

; マウスポインターの速度を変更します。
SetMouseSpeed(MouseSpeed) {
    DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSESPEED, "UInt", 0, "UInt", MouseSpeed, "UInt", 0)
}

; マウスポインターの速度を元に戻します。
ChangeOriginalMouseSpeed() {
    SetMouseSpeed(OriginalMouseSpeed)
}

; マウスポインターの速度を遅くします。
ChangeSlowMouseSpeed() {
    SetMouseSpeed(MOUSE_SPEED_SLOW)
}

; 垂直スクロールモードに切り替えます。
ChangeVerticalScrollMode() {
    global ScrollMode
    ScrollMode := "vertical"
}

; 水平スクロールモードに切り替えます。
ChangeHorizontalScrollMode() {
    global ScrollMode
    ScrollMode := "horizontal"
}

; 上スクロール or 左スクロール。
WheelUpOrLeft() {
    if (ScrollMode == "vertical") {
        Send "{WheelUp}"
    } else {
        Send "{WheelLeft}"
    }
}

; 下スクロール or 右スクロール。
WheelDownOrRight() {
    if (ScrollMode == "vertical") {
        Send "{WheelDown}"
    } else {
        Send "{WheelRight}"
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

; マウスポインターの速度を表示します。
^#p::MsgBox("現在のマウスポインター速度設定は: " GetMouseSpeed())

; マウスポインターの速度を元に戻します。 (sc029 = 半角／全角キー)
sc029::ChangeOriginalMouseSpeed()

; マウスポインターの速度を遅くします。 (sc03A = 英数キー)
sc03A::ChangeSlowMouseSpeed()

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
