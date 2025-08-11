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

const := {
    SPI_GETMOUSESPEED: 0x0070,
    SPI_SETMOUSESPEED: 0x0071,
    SPI_GETWHEELSCROLLLINES: 0x0068,
    SPI_SETWHEELSCROLLLINES: 0x0069,
    SPI_GETWHEELSCROLLCHARS: 0x006C,
    SPI_SETWHEELSCROLLCHARS: 0x006D,
    SPIF_UPDATEINIFILE: 0x0001,
    SPIF_SENDCHANGE: 0x0002
}

env := {
    mouse: {
        const: {
            pointer: {
                speed: {
                    slow: {
                        name: "slow",
                        value: 1
                    },
                    default: {
                        name: "default",
                        value: GetMouseSpeed()
                    }
                }
            },
            scroll: {
                direction: {
                    vertical: "vertical",
                    horizontal: "horizontal"
                },
                speed: {
                    page: {
                        name: "page",
                        vertical: 0xFFFFFFFF,
                        horizontal: GetWheelScrollChars() * 6
                    },
                    slow: {
                        name: "slow",
                        vertical: Ceil(GetWheelScrollLines() / 3),
                        horizontal: Ceil(GetWheelScrollChars() / 3)
                    },
                    high: {
                        name: "high",
                        vertical: GetWheelScrollLines() * 3,
                        horizontal: GetWheelScrollChars() * 3
                    },
                    default: {
                        name: "default",
                        vertical: GetWheelScrollLines(),
                        horizontal: GetWheelScrollChars()
                    }
                }
            }
        },
        state: {
            pointer: {
                speed: "default"
            },
            scroll: {
                direction: "vertical",
                speed: "default"
            }
        }
    },
    popup: {
        const: {
            hotkeys: {
                listView: {
                    width: 1100,
                    height: 700
                }
            },
            env: {
                listView: {
                    width: 1100,
                    height: 700
                }
            }
        },
        state: {
            hotkeys: {},
            env: {}
        }
    },
    hotkeys: []
}

; ホットキー一覧を表示します。
ShowHotkeys() {
    hotkeys := env.hotkeys
    oldPopup := env.popup.state.hotkeys
    listViewWidth := env.popup.const.hotkeys.listView.width
    listViewHeight := env.popup.const.hotkeys.listView.height

    try {
        oldPopup.Destroy()
    } catch as e {
        ; 何もしない。ポップアップが存在しない場合、エラーが発生するが、初期化処理の為、問題なし。
    }

    popup := Gui("", "ホットキー一覧")
    env.popup.state.hotkeys := popup
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

; 環境情報を表示します。
ShowEnvironment() {
    scrollDirectionMode := env.mouse.state.scroll.direction
    scrollSpeedMode := env.mouse.state.scroll.speed
    oldPopup := env.popup.state.env
    listViewWidth := env.popup.const.env.listView.width
    listViewHeight := env.popup.const.env.listView.height

    try {
        oldPopup.Destroy()
    } catch as e {
        ; 何もしない。ポップアップが存在しない場合、エラーが発生するが、初期化処理の為、問題なし。
    }

    popup := Gui("", "環境情報")
    env.popup.state.env := popup
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
    mode := env.mouse.const.pointer.speed.default.name
    speed := env.mouse.const.pointer.speed.default.value

    env.mouse.state.pointer.speed := mode

    SetMouseSpeed(speed)
}

; スロウ マウススピードモードに切り替えます。
ChangeSlowMouseSpeedMode() {
    mode := env.mouse.const.pointer.speed.slow.name
    speed := env.mouse.const.pointer.speed.slow.value

    env.mouse.state.pointer.speed := mode

    SetMouseSpeed(speed)
}

; デフォルト スクロールスピードモードに切り替えます。
ChangeDefaultScrollSpeedMode() {
    mode := env.mouse.const.scroll.speed.default.name
    verticalSpeed := env.mouse.const.scroll.speed.default.vertical
    horizontalSpeed := env.mouse.const.scroll.speed.default.horizontal

    env.mouse.state.scroll.speed := mode

    SetWheelScrollLines(verticalSpeed)
    SetWheelScrollChars(horizontalSpeed)
}

; 1画面 スクロールスピードモードに切り替えます。
ChangePageScrollSpeedMode() {
    mode := env.mouse.const.scroll.speed.page.name
    verticalSpeed := env.mouse.const.scroll.speed.page.vertical
    horizontalSpeed := env.mouse.const.scroll.speed.page.horizontal

    env.mouse.state.scroll.speed := mode

    SetWheelScrollLines(verticalSpeed)
    SetWheelScrollChars(horizontalSpeed)
}

; スロウ スクロールスピードモードに切り替えます。
ChangeSlowScrollSpeedMode() {
    mode := env.mouse.const.scroll.speed.slow.name
    verticalSpeed := env.mouse.const.scroll.speed.slow.vertical
    horizontalSpeed := env.mouse.const.scroll.speed.slow.horizontal

    env.mouse.state.scroll.speed := mode

    SetWheelScrollLines(verticalSpeed)
    SetWheelScrollChars(horizontalSpeed)
}

; ハイ スクロールスピードモードに切り替えます。
ChangeHighScrollSpeedMode() {
    mode := env.mouse.const.scroll.speed.high.name
    verticalSpeed := env.mouse.const.scroll.speed.high.vertical
    horizontalSpeed := env.mouse.const.scroll.speed.high.horizontal

    env.mouse.state.scroll.speed := mode

    SetWheelScrollLines(verticalSpeed)
    SetWheelScrollChars(horizontalSpeed)
}

; 垂直 スクロール方向モードに切り替えます。
ChangeVerticalScrollDirectionMode() {
    mode := env.mouse.const.scroll.direction.vertical
    env.mouse.state.scroll.direction := mode
}

; 水平 スクロール方向モードに切り替えます。
ChangeHorizontalScrollDirectionMode() {
    mode := env.mouse.const.scroll.direction.horizontal
    env.mouse.state.scroll.direction := mode
}

; 上スクロール or 左スクロール。
WheelUpOrLeft() {
    mode := env.mouse.state.scroll.direction
    horizontalMode := env.mouse.const.scroll.direction.horizontal

    if (mode = horizontalMode) {
        Send("{WheelLeft}")
    } else {
        Send("{WheelUp}")
    }
}

; 下スクロール or 右スクロール。
WheelDownOrRight() {
    mode := env.mouse.state.scroll.direction
    horizontalMode := env.mouse.const.scroll.direction.horizontal

    if (mode = horizontalMode) {
        Send("{WheelRight}")
    } else {
        Send("{WheelDown}")
    }
}

; スロウ マウススピードモードに切り替えます。トグル方式。
ToggleSlowMouseSpeedMode() {
    mode := env.mouse.state.pointer.speed
    slowMode := env.mouse.const.pointer.speed.slow.name

    if (mode != slowMode) {
        ChangeSlowMouseSpeedMode()
    } else {
        ChangeDefaultMouseSpeedMode()
    }
}

; 1画面 スクロールスピードモードに切り替えます。トグル方式。
TogglePageScrollSpeedMode() {
    mode := env.mouse.state.scroll.speed
    pageMode := env.mouse.const.scroll.speed.page.name

    if (mode != pageMode) {
        ChangePageScrollSpeedMode()
    } else {
        ChangeDefaultScrollSpeedMode()
    }
}

; スロウ スクロールスピードモードに切り替えます。トグル方式。
ToggleSlowScrollSpeedMode() {
    mode := env.mouse.state.scroll.speed
    slowMode := env.mouse.const.scroll.speed.slow.name

    if (mode != slowMode) {
        ChangeSlowScrollSpeedMode()
    } else {
        ChangeDefaultScrollSpeedMode()
    }
}

; ハイ スクロールスピードモードに切り替えます。トグル方式。
ToggleHighScrollSpeedMode() {
    mode := env.mouse.state.scroll.speed
    highMode := env.mouse.const.scroll.speed.high.name

    if (mode != highMode) {
        ChangeHighScrollSpeedMode()
    } else {
        ChangeDefaultScrollSpeedMode()
    }
}

; マウススピードを取得します。
GetMouseSpeed() {
    spiGetmousespeed := const.SPI_GETMOUSESPEED
    mouseSpeed := Buffer(4)

    DllCall("SystemParametersInfo",
        "UInt", spiGetmousespeed,
        "UInt", 0,
        "Ptr", mouseSpeed,
        "UInt", 0)

    return NumGet(mouseSpeed, 0, "UInt")
}

; マウススピードを変更します。
SetMouseSpeed(mouseSpeed) {
    spiSetmousespeed := const.SPI_SETMOUSESPEED
    spifUpdateinifile := const.SPIF_UPDATEINIFILE
    spifSendchange := const.SPIF_SENDCHANGE

    DllCall("SystemParametersInfo",
        "UInt", spiSetmousespeed,
        "UInt", 0,
        "UInt", mouseSpeed,
        "UInt", spifUpdateinifile | spifSendchange)
}

; 垂直スクロールの行数を取得します。
GetWheelScrollLines() {
    spiGetwheelscrolllines := const.SPI_GETWHEELSCROLLLINES
    wheelScrollLines := Buffer(4)

    DllCall("SystemParametersInfo",
        "UInt", spiGetwheelscrolllines,
        "UInt", 0,
        "Ptr", wheelScrollLines,
        "UInt", 0)

    return NumGet(wheelScrollLines, 0, "UInt")
}

; 垂直スクロールの行数を変更します。
SetWheelScrollLines(wheelScrollLines) {
    spiSetwheelscrolllines := const.SPI_SETWHEELSCROLLLINES
    spifUpdateinifile := const.SPIF_UPDATEINIFILE
    spifSendchange := const.SPIF_SENDCHANGE

    DllCall("SystemParametersInfo",
        "UInt", spiSetwheelscrolllines,
        "UInt", wheelScrollLines,
        "UInt", 0,
        "UInt", spifUpdateinifile | spifSendchange)
}

; 水平スクロールの文字数を取得します。
GetWheelScrollChars() {
    spiGetwheelscrollchars := const.SPI_GETWHEELSCROLLCHARS
    wheelScrollChars := Buffer(4)

    DllCall("SystemParametersInfo",
        "UInt", spiGetwheelscrollchars,
        "UInt", 0,
        "Ptr", wheelScrollChars,
        "UInt", 0)

    return NumGet(wheelScrollChars, 0, "UInt")
}

; 水平スクロールの文字数を変更します。
SetWheelScrollChars(wheelScrollChars) {
    spiSetwheelscrollchars := const.SPI_SETWHEELSCROLLCHARS
    spifUpdateinifile := const.SPIF_UPDATEINIFILE
    spifSendchange := const.SPIF_SENDCHANGE

    DllCall("SystemParametersInfo",
        "UInt", spiSetwheelscrollchars,
        "UInt", wheelScrollChars,
        "UInt", 0,
        "UInt", spifUpdateinifile | spifSendchange)
}

; スクリプトの終了処理を行います。
ExitFunc(exitReason, exitCode) {
    ResetMouseSettings()
}

; ホットキーを登録します。
RegisterHotkey(key, func, desc := "") {
    hotkeys := env.hotkeys
    hotkeys.Push({key: key, desc: desc})
    Hotkey(key, func)
}

; ホットキー一覧を表示します。
RegisterHotkey("^#h", (*) => ShowHotkeys(), "ホットキー一覧を表示します。")

; 環境情報を表示します。
RegisterHotkey("^#s", (*) => ShowEnvironment(), "環境情報を表示します。")

; ホットキー一覧を表示します。ListHotkeys関数。
RegisterHotkey("^#l", (*) => ListHotkeys(), "ホットキー一覧を表示します。ListHotkeys関数。")

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
