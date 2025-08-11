#Requires AutoHotkey v2.0
#Warn
#InputLevel 100
#UseHook

; ソースコードは、以下のGitHubリポジトリで管理してます。
; https://github.com/KatoRyota/AutoHotkey

ProcessSetPriority "High"
SendMode "Input"
SendLevel 100
OnExit ExitFunc

SPI_GETMOUSESPEED := 0x0070
SPI_SETMOUSESPEED := 0x0071
SPI_GETWHEELSCROLLLINES := 0x0068
SPI_SETWHEELSCROLLLINES := 0x0069
SPI_GETWHEELSCROLLCHARS := 0x006C
SPI_SETWHEELSCROLLCHARS := 0x006D
SPIF_UPDATEINIFILE := 0x0001
SPIF_SENDCHANGE := 0x0002

environment := {
    mouse: {
        definition: {
            pointer: {
                speed: {
                    mode: {slow: "slow", default: "default"},
                    slow: 1,
                    default: GetMouseSpeed()
                }
            },
            scroll: {
                direction: {
                    mode: {vertical: "vertical", horizontal: "horizontal"}
                },
                speed: {
                    mode: {page: "page", slow: "slow", high: "high", default: "default"},
                    page: {
                        vertical: 0xFFFFFFFF,
                        horizontal: GetWheelScrollChars() * 6
                    },
                    slow: {
                        vertical: Ceil(GetWheelScrollLines() / 3),
                        horizontal: Ceil(GetWheelScrollChars() / 3)
                    },
                    high: {
                        vertical: GetWheelScrollLines() * 3,
                        horizontal: GetWheelScrollChars() * 3
                    },
                    default: {
                        vertical: GetWheelScrollLines(),
                        horizontal: GetWheelScrollChars()
                    }
                }
            }
        },
        state: {
            pointer: {
                speed: {
                    mode: "default"
                }
            },
            scroll: {
                direction: {
                    mode: "vertical"
                },
                speed: {
                    mode: "default"
                }
            }
        }
    },
    popup: {
        definition: {
            hotkeys: {
                listView: {
                    width: 1100,
                    height: 700
                }
            },
            environment: {
                listView: {
                    width: 1100,
                    height: 700
                }
            }
        },
        state: {
            hotkeys: {},
            environment: {}
        }
    },
    hotkeys: []
}

; ホットキーの一覧を表示します。
ShowHotkeys() {
    hotkeys := environment.hotkeys
    popup := environment.popup.state.hotkeys
    listViewWidth := environment.popup.definition.hotkeys.listView.width
    listViewHeight := environment.popup.definition.hotkeys.listView.height

    try {
        popup.Destroy()
    } catch as e {
        ; 何もしない。ポップアップが存在しない場合、エラーが発生するが、初期化処理の為、問題なし。
    }

    environment.popup.state.hotkeys := Gui("", "ホットキー一覧")

    popup := environment.popup.state.hotkeys
    popup.Opt("+AlwaysOnTop -DPIScale")
    popup.SetFont("s12 q5", "Meiryo UI")

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
    scrollDirectionMode := environment.mouse.state.scroll.direction.mode
    scrollSpeedMode := environment.mouse.state.scroll.speed.mode
    popup := environment.popup.state.environment
    listViewWidth := environment.popup.definition.environment.listView.width
    listViewHeight := environment.popup.definition.environment.listView.height

    try {
        popup.Destroy()
    } catch as e {
        ; 何もしない。ポップアップが存在しない場合、エラーが発生するが、初期化処理の為、問題なし。
    }

    environment.popup.state.environment := Gui("", "現在の設定")

    popup := environment.popup.state.environment
    popup.Opt("+AlwaysOnTop -DPIScale")
    popup.SetFont("s12 q5", "Meiryo UI")

    listViewOptions := Format("NoSort Grid ReadOnly w{1} h{2}", listViewWidth, listViewHeight)
    listView := popup.Add("ListView", listViewOptions, ["設定項目", "値"])

    listView.Add("", "マウススピード", GetMouseSpeed())
    listView.Add("", "垂直スクロールの行数", GetWheelScrollLines())
    listView.Add("", "水平スクロールの文字数", GetWheelScrollChars())
    listView.Add("", "スクロール方向", scrollDirectionMode)
    listView.Add("", "スクロールスピード", scrollSpeedMode)
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

; マウスの設定をリセットします。
ResetMouseSettings() {
    ChangeDefaultMouseSpeedMode()
    ChangeVerticalScrollDirectionMode()
    ChangeDefaultScrollSpeedMode()
}

; デフォルト マウススピードモードに切り替えます。
ChangeDefaultMouseSpeedMode() {
    mode := environment.mouse.definition.pointer.speed.mode.default
    speed := environment.mouse.definition.pointer.speed.default

    environment.mouse.state.pointer.speed.mode := mode

    SetMouseSpeed(speed)
}

; スロウ マウススピードモードに切り替えます。
ChangeSlowMouseSpeedMode() {
    mode := environment.mouse.definition.pointer.speed.mode.slow
    speed := environment.mouse.definition.pointer.speed.slow

    environment.mouse.state.pointer.speed.mode := mode

    SetMouseSpeed(speed)
}

; デフォルト スクロールスピードモードに切り替えます。
ChangeDefaultScrollSpeedMode() {
    mode := environment.mouse.definition.scroll.speed.mode.default
    verticalSpeed := environment.mouse.definition.scroll.speed.default.vertical
    horizontalSpeed := environment.mouse.definition.scroll.speed.default.horizontal

    environment.mouse.state.scroll.speed.mode := mode

    SetWheelScrollLines(verticalSpeed)
    SetWheelScrollChars(horizontalSpeed)
}

; 1画面 スクロールスピードモードに切り替えます。
ChangePageScrollSpeedMode() {
    mode := environment.mouse.definition.scroll.speed.mode.page
    verticalSpeed := environment.mouse.definition.scroll.speed.page.vertical
    horizontalSpeed := environment.mouse.definition.scroll.speed.page.horizontal

    environment.mouse.state.scroll.speed.mode := mode

    SetWheelScrollLines(verticalSpeed)
    SetWheelScrollChars(horizontalSpeed)
}

; スロウ スクロールスピードモードに切り替えます。
ChangeSlowScrollSpeedMode() {
    mode := environment.mouse.definition.scroll.speed.mode.slow
    verticalSpeed := environment.mouse.definition.scroll.speed.slow.vertical
    horizontalSpeed := environment.mouse.definition.scroll.speed.slow.horizontal

    environment.mouse.state.scroll.speed.mode := mode

    SetWheelScrollLines(verticalSpeed)
    SetWheelScrollChars(horizontalSpeed)
}

; ハイ スクロールスピードモードに切り替えます。
ChangeHighScrollSpeedMode() {
    mode := environment.mouse.definition.scroll.speed.mode.high
    verticalSpeed := environment.mouse.definition.scroll.speed.high.vertical
    horizontalSpeed := environment.mouse.definition.scroll.speed.high.horizontal

    environment.mouse.state.scroll.speed.mode := mode

    SetWheelScrollLines(verticalSpeed)
    SetWheelScrollChars(horizontalSpeed)
}

; 垂直 スクロール方向モードに切り替えます。
ChangeVerticalScrollDirectionMode() {
    mode := environment.mouse.definition.scroll.direction.mode.vertical
    environment.mouse.state.scroll.direction.mode := mode
}

; 水平 スクロール方向モードに切り替えます。
ChangeHorizontalScrollDirectionMode() {
    mode := environment.mouse.definition.scroll.direction.mode.horizontal
    environment.mouse.state.scroll.direction.mode := mode
}

; 上スクロール or 左スクロール。
WheelUpOrLeft() {
    mode := environment.mouse.state.scroll.direction.mode
    horizontalMode := environment.mouse.definition.scroll.direction.mode.horizontal

    if (mode = horizontalMode) {
        Send("{WheelLeft}")
    } else {
        Send("{WheelUp}")
    }
}

; 下スクロール or 右スクロール。
WheelDownOrRight() {
    mode := environment.mouse.state.scroll.direction.mode
    horizontalMode := environment.mouse.definition.scroll.direction.mode.horizontal

    if (mode = horizontalMode) {
        Send("{WheelRight}")
    } else {
        Send("{WheelDown}")
    }
}

; スロウ マウススピードモードに切り替えます。トグル方式。
ToggleSlowMouseSpeedMode() {
    mode := environment.mouse.state.pointer.speed.mode
    slowMode := environment.mouse.definition.pointer.speed.mode.slow

    if (mode != slowMode) {
        ChangeSlowMouseSpeedMode()
    } else {
        ChangeDefaultMouseSpeedMode()
    }
}

; 1画面 スクロールスピードモードに切り替えます。トグル方式。
TogglePageScrollSpeedMode() {
    mode := environment.mouse.state.scroll.speed.mode
    pageMode := environment.mouse.definition.scroll.speed.mode.page

    if (mode != pageMode) {
        ChangePageScrollSpeedMode()
    } else {
        ChangeDefaultScrollSpeedMode()
    }
}

; スロウ スクロールスピードモードに切り替えます。トグル方式。
ToggleSlowScrollSpeedMode() {
    mode := environment.mouse.state.scroll.speed.mode
    slowMode := environment.mouse.definition.scroll.speed.mode.slow

    if (mode != slowMode) {
        ChangeSlowScrollSpeedMode()
    } else {
        ChangeDefaultScrollSpeedMode()
    }
}

; ハイ スクロールスピードモードに切り替えます。トグル方式。
ToggleHighScrollSpeedMode() {
    mode := environment.mouse.state.scroll.speed.mode
    highMode := environment.mouse.definition.scroll.speed.mode.high

    if (mode != highMode) {
        ChangeHighScrollSpeedMode()
    } else {
        ChangeDefaultScrollSpeedMode()
    }
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
    ResetMouseSettings()
}

; ホットキーを登録します。
RegisterHotkey(key, func, desc := "") {
    hotkeys := environment.hotkeys
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

; デフォルト マウススピードモードに切り替えます。
RegisterHotkey("F1 & a", (*) => ChangeDefaultMouseSpeedMode(), "デフォルト マウススピードモードに切り替えます。")

; スロウ マウススピードモードに切り替えます。
RegisterHotkey("F1 & s", (*) => ChangeSlowMouseSpeedMode(), "スロウ マウススピードモードに切り替えます。")

; 垂直 スクロール方向モードに切り替えます。
RegisterHotkey("F1 & q", (*) => ChangeVerticalScrollDirectionMode(), "垂直 スクロール方向モードに切り替えます。")
; 水平 スクロール方向モードに切り替えます。
RegisterHotkey("F1 & w", (*) => ChangeHorizontalScrollDirectionMode(), "水平 スクロール方向モードに切り替えます。")

; デフォルト スクロールスピードモードに切り替えます。
RegisterHotkey("F1 & 1", (*) => ChangeDefaultScrollSpeedMode(), "デフォルト スクロールスピードモードに切り替えます。")

; 1画面 スクロールスピードモードに切り替えます。
RegisterHotkey("F1 & 2", (*) => ChangePageScrollSpeedMode(), "1画面 スクロールスピードモードに切り替えます。")

; スロウ スクロールスピードモードに切り替えます。
RegisterHotkey("F1 & 3", (*) => ChangeSlowScrollSpeedMode(), "スロウ スクロールスピードモードに切り替えます。")

; ハイ スクロールスピードモードに切り替えます。
RegisterHotkey("F1 & 4", (*) => ChangeHighScrollSpeedMode(), "ハイ スクロールスピードモードに切り替えます。")

; スロウ マウススピードモードに切り替えます。トグル方式。(sc03A = 英数キー)
RegisterHotkey("sc03A", (*) => ToggleSlowMouseSpeedMode(), "スロウ マウススピードモードに切り替えます。トグル方式。(sc03A = 英数キー)")

; マウスの設定をリセットします。(sc029 = 半角／全角キー)
RegisterHotkey("sc029", (*) => ResetMouseSettings(), "マウスの設定をリセットします。(sc029 = 半角／全角キー)")

; マウスの設定をリセットします。(sc070 = カタカナ・ひらがなキー)
RegisterHotkey("sc070", (*) => ResetMouseSettings(), "マウスの設定をリセットします。(sc070 = カタカナ・ひらがなキー)")

; 上スクロール or 左スクロール。
RegisterHotkey("WheelUp", (*) => WheelUpOrLeft(), "上スクロール or 左スクロール。")
; 下スクロール or 右スクロール。
RegisterHotkey("WheelDown", (*) => WheelDownOrRight(), "下スクロール or 右スクロール。")

; 垂直 スクロール方向モードに切り替えます。
RegisterHotkey("XButton1", (*) => ChangeVerticalScrollDirectionMode(), "垂直 スクロール方向モードに切り替えます。")
; 水平 スクロール方向モードに切り替えます。
RegisterHotkey("XButton2", (*) => ChangeHorizontalScrollDirectionMode(), "水平 スクロール方向モードに切り替えます。")

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
