#Requires AutoHotkey v2.0

SendMode "Input"
SetKeyDelay 20
SetMouseDelay 20

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

; 半角/全角キーを、Backspaceキーにリマップ。
sc029::Backspace

; 英数キーを、F13キーにリマップ。
sc03A::F13

; カナ/かなキーを、RAltキーにリマップ。
sc070::RAlt

; AppsKeyキーを、RCtrlキーにリマップ。
AppsKey::RCtrl

; ホットキーの一覧表示。
^#h::{
    ListHotkeys()
}

; キーヒストリーの表示。
^#k::{
    KeyHistory()
}

; マウスポインターの速度を表示。
^#p::{
    MsgBox("現在のマウスポインター速度設定は: " GetMouseSpeed())
}

; マウスポインターの速度を遅くする。
~Ctrl::{
    DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSESPEED, "UInt", 0, "UInt", MOUSE_SPEED_SLOW, "UInt", 0)
    KeyWait "Ctrl"
}

; マウスポインターの速度を元に戻す。
~Ctrl Up::{
    DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSESPEED, "UInt", 0, "UInt", OriginalMouseSpeed, "UInt", 0)
}

; F13キーで、マウスポインターの速度を変更。トグル方式。
F13::{
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

; CapsLockキー
+F13::SetCapsLockState !GetKeyState("CapsLock", "T")

; 水平スクロール１
+!WheelUp::Send "{WheelLeft}"
+!WheelDown::Send "{WheelRight}"

; 水平スクロール２
+#WheelUp::Send "{WheelLeft}"
+#WheelDown::Send "{WheelRight}"

; 水平スクロール３
XButton1::Send "{WheelLeft}{WheelLeft}"
XButton2::Send "{WheelRight}{WheelRight}"

; 『戻る, 進む』キー
^+XButton1::Send "{Browser_Back}"
^+XButton2::Send "{Browser_Forward}"

; 『Home, End』キー
^XButton1::Send "{Home}"
^XButton2::Send "{End}"

; 『PgUp, PgDn』キー
+XButton1::Send "{PgUp}"
+XButton2::Send "{PgDn}"

; 『ctrl + Home, ctrl + End』キー
^!XButton1::Send "^{Home}"
^!XButton2::Send "^{End}"

; 『ctrl + PgUp, ctrl + PgDn』キー
^#XButton1::Send "^{PgUp}"
^#XButton2::Send "^{PgDn}"

; 『shift + Home, shift + End』キー
+!XButton1::Send "+{Home}"
+!XButton2::Send "+{End}"

; 『ctrl + shift + Home, ctrl + shift + End』キー
+#XButton1::Send "^+{Home}"
+#XButton2::Send "^+{End}"
