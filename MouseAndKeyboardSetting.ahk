#Requires AutoHotkey v2.0

; ソースコードは、以下のGitHubリポジトリで管理してます。
; https://github.com/KatoRyota/AutoHotkey

;;SendMode "Input"
;;SendMode "Event"
;;SetKeyDelay 10
;;SetMouseDelay 10

SPI_GETMOUSESPEED := 0x70
SPI_SETMOUSESPEED := 0x71
MOUSE_SPEED_SLOW := 1
MouseSpeedToggle := false

GetMouseSpeed() {
    MouseSpeed := Buffer(4)
    DllCall("SystemParametersInfo", "UInt", SPI_GETMOUSESPEED, "UInt", 0, "Ptr", MouseSpeed, "UInt", 0)
    return NumGet(MouseSpeed, 0, "UInt")
}

OriginalMouseSpeed := GetMouseSpeed()

ExitFunc(ExitReason, ExitCode) {
    DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSESPEED, "UInt", 0, "UInt", OriginalMouseSpeed, "UInt", 0)
}

OnExit ExitFunc

; 半角／全角キーを、Backspaceキーにリマップ。
sc029::Backspace

; AppsKeyキーを、右Ctrlキーにリマップ。
AppsKey::RControl

; カタカナ・ひらがなキーを、右Altキーにリマップ。
sc070::RAlt

; ホットキーの一覧表示。
^#h::ListHotkeys()

; キーヒストリーの表示。
^#k::KeyHistory()

; マウスポインターの速度を表示。
^#p::MsgBox("現在のマウスポインター速度設定は: " GetMouseSpeed())

;;; マウスポインターの速度を遅くする。
;;~LControl::{
;;    DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSESPEED, "UInt", 0, "UInt", MOUSE_SPEED_SLOW, "UInt", 0)
;;    KeyWait "LControl"
;;}
;;
;;; マウスポインターの速度を元に戻す。
;;~LControl Up::{
;;    DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSESPEED, "UInt", 0, "UInt", OriginalMouseSpeed, "UInt", 0)
;;}

ToggleMouseSpeed() {
    global MouseSpeedToggle
    MouseSpeedToggle := !MouseSpeedToggle

    if MouseSpeedToggle {
        ; マウスポインターの速度を遅くする。
        DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSESPEED, "UInt", 0, "UInt", MOUSE_SPEED_SLOW, "UInt", 0)
    } else {
        ; マウスポインターの速度を元に戻す。
        DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSESPEED, "UInt", 0, "UInt", OriginalMouseSpeed, "UInt", 0)
    }
}

; 英数キーで、マウスポインターの速度を変更。トグル方式。
sc03A::ToggleMouseSpeed()

; 左水平スクロール
+!WheelUp::SendEvent "{WheelLeft}"
; 右水平スクロール
+!WheelDown::SendEvent "{WheelRight}"

; 左水平スクロール2倍
XButton1::SendEvent "{WheelLeft}{WheelLeft}"
; 右水平スクロール2倍
XButton2::SendEvent "{WheelRight}{WheelRight}"

; Alt + Leftキー
^+XButton1::SendEvent "!{Left}"
; Alt + Rightキー
^+XButton2::SendEvent "!{Right}"

; Homeキー
^XButton1::SendEvent "{Home}"
; Endキー
^XButton2::SendEvent "{End}"

; PgUpキー
+XButton1::SendEvent "{PgUp}"
; PgDnキー
+XButton2::SendEvent "{PgDn}"

; Ctrl + Homeキー
^!XButton1::SendEvent "^{Home}"
; Ctrl + Endキー
^!XButton2::SendEvent "^{End}"

; Ctrl + PgUpキー
^#XButton1::SendEvent "^{PgUp}"
; Ctrl + PgDnキー
^#XButton2::SendEvent "^{PgDn}"

; Shift + Homeキー
+!XButton1::SendEvent "+{Home}"
; Shift + Endキー
+!XButton2::SendEvent "+{End}"

; Ctrl + Shift + Homeキー
+#XButton1::SendEvent "^+{Home}"
; Ctrl + Shift + Endキー
+#XButton2::SendEvent "^+{End}"
