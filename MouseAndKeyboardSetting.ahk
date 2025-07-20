#Requires AutoHotkey v2.0
#Warn
#UseHook
#InputLevel 100

; ソースコードは、以下のGitHubリポジトリで管理してます。
; https://github.com/KatoRyota/AutoHotkey

SendMode "Input"
SetKeyDelay 50
SetMouseDelay 50
SPI_GETMOUSESPEED := 0x70
SPI_SETMOUSESPEED := 0x71
MOUSE_SPEED_SLOW := 1
MouseSpeedToggle := false
OriginalMouseSpeed := GetMouseSpeed()
OnExit ExitFunc

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

; スクリプトの終了処理を行います。
ExitFunc(ExitReason, ExitCode) {
    ; マウスポインターの速度を元に戻す。
    SetMouseSpeed(OriginalMouseSpeed)
}

; マウスポインターの速度を変更します。トグル方式。
ToggleMouseSpeed() {
    global MouseSpeedToggle
    MouseSpeedToggle := !MouseSpeedToggle

    if MouseSpeedToggle {
        ; マウスポインターの速度を遅くする。
        SetMouseSpeed(MOUSE_SPEED_SLOW)
    } else {
        ; マウスポインターの速度を元に戻す。
        SetMouseSpeed(OriginalMouseSpeed)
    }
}

; 半角／全角キーを、Backspaceキーにリマップ。
;;sc029::Backspace ;このリマップを行うと、キー配列がおかしくなる。原因不明。

; AppsKeyキーを、右Ctrlキーにリマップ。
;;AppsKey::RControl ;このリマップを行うと、キー配列がおかしくなる。原因不明。

; カタカナ・ひらがなキーを、右Altキーにリマップ。
;;sc070::RAlt ;このリマップを行うと、キー配列がおかしくなる。原因不明。

; ホットキーの一覧表示。
^#h::ListHotkeys()

; キーヒストリーの表示。
^#k::KeyHistory()

; マウスポインターの速度を表示。
^#p::MsgBox("現在のマウスポインター速度設定は: " GetMouseSpeed())

; Backspaceキー (sc029 = 半角／全角キー)
sc029::Send "{Backspace}"

; マウスポインターの速度を変更。トグル方式。 (sc03A = 英数キー)
sc03A::ToggleMouseSpeed()

; カタカナ・ひらがなキーを無効化。 (sc070 = カタカナ・ひらがなキー)
sc070::Return

; 左水平スクロール
+!WheelUp::Send "{WheelLeft}"
; 右水平スクロール
+!WheelDown::Send "{WheelRight}"

; 左水平スクロール2倍
XButton1::Send "{WheelLeft}{WheelLeft}"
; 右水平スクロール2倍
XButton2::Send "{WheelRight}{WheelRight}"

; Alt + Leftキー
^+XButton1::Send "!{Left}"
; Alt + Rightキー
^+XButton2::Send "!{Right}"

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
+#XButton1::Send "^+{Home}"
; Ctrl + Shift + Endキー
+#XButton2::Send "^+{End}"
