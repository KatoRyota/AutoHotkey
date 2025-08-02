#Requires AutoHotkey v2.0
#Warn
#UseHook
#InputLevel 100

; ソースコードは、以下のGitHubリポジトリで管理してます。
; https://github.com/KatoRyota/AutoHotkey

ProcessSetPriority "High"
SendMode "Input"
SetKeyDelay -1
SetMouseDelay -1
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
    global ScrollMode
    if (ScrollMode == "vertical") {
        Send "{WheelUp}"
    } else {
        Send "{WheelLeft}"
    }
}

; 下スクロール or 右スクロール。
WheelDownOrRight() {
    global ScrollMode
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

; ホットキーの一覧表示。
^#h::ListHotkeys

; キーヒストリーの表示。
^#k::KeyHistory

; マウスポインターの速度を表示。
^#p::MsgBox("現在のマウスポインター速度設定は: " GetMouseSpeed())

; マウスポインターの速度を元に戻します。 (sc029 = 半角／全角キー)
sc029::ChangeOriginalMouseSpeed()

; マウスポインターの速度を遅くします。 (sc03A = 英数キー)
sc03A::ChangeSlowMouseSpeed()

; カタカナ・ひらがなキーを無効化。 (sc070 = カタカナ・ひらがなキー)
sc070::Return

; 上スクロール or 左スクロール。
WheelUp::WheelUpOrLeft()
; 下スクロール or 右スクロール。
WheelDown::WheelDownOrRight()

; 水平スクロールモードに切り替えます。
XButton1::ChangeHorizontalScrollMode()
; 垂直スクロールモードに切り替えます。
XButton2::ChangeVerticalScrollMode()

; Alt + Leftキー
+^XButton1::Send "!{Left}"
; Alt + Rightキー
+^XButton2::Send "!{Right}"

; Homeキー
^XButton1::Send "{Home}"
; Endキー
^XButton2::Send "{End}"

; PgUpキー
+XButton1::Send "{PgUp}"
; PgDnキー
+XButton2::Send "{PgDn}"

; Ctrl + Homeキー
^!XButton1::Send "^{Home}"
; Ctrl + Endキー
^!XButton2::Send "^{End}"

; Ctrl + PgUpキー
^#XButton1::Send "^{PgUp}"
; Ctrl + PgDnキー
^#XButton2::Send "^{PgDn}"

; Shift + Homeキー
+!XButton1::Send "+{Home}"
; Shift + Endキー
+!XButton2::Send "+{End}"

; Ctrl + Shift + Homeキー
+#XButton1::Send "+^{Home}"
; Ctrl + Shift + Endキー
+#XButton2::Send "+^{End}"
