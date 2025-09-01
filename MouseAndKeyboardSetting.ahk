#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#InputLevel 100
#UseHook

; ソースコードは、以下のGitHubリポジトリで管理してます。
; https://github.com/KatoRyota/AutoHotkey

ProcessSetPriority("AboveNormal")
InstallKeybdHook()
InstallMouseHook()
SendMode("Input")
SendLevel(100)
DetectHiddenWindows(true)
OnExit(ExitFunc)

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
    translation: {
        const: {
            bing: {
                appPath: "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
                url: "https://www.bing.com/translator?from=en&to=ja&text={1}",
                title: "Microsoft Translator"
            },
            google: {
                appPath: "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
                url: "https://translate.google.com/?sl=en&tl=ja&text={1}&op=translate",
                title: "Google 翻訳"
            },
            deepl: {
                appPath: "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
                url: "https://www.deepl.com/translator#en/ja/{1}",
                title: "DeepL翻訳"
            }
        }
    }
}

bingAppPath := env.translation.const.bing.appPath
bingUrl := env.translation.const.bing.url
bingTitle := env.translation.const.bing.title

googleAppPath := env.translation.const.google.appPath
googleUrl := env.translation.const.google.url
googleTitle := env.translation.const.google.title

deeplAppPath := env.translation.const.deepl.appPath
deeplUrl := env.translation.const.deepl.url
deeplTitle := env.translation.const.deepl.title

hotkeys := [
    {key: "^#h", func: (*) => ShowHotkeys(), desc: "ホットキー一覧を表示します。"},
    {key: "^#s", func: (*) => ShowEnvironment(), desc: "環境情報を表示します。"},
    {key: "^#l", func: (*) => ListHotkeys(), desc: "ホットキー一覧を表示します。組み込みListHotkeys関数。"},
    {key: "^#k", func: (*) => KeyHistory(), desc: "キーヒストリーを表示します。組み込みKeyHistory関数。"},
    {key: "F1 & z", func: (*) => Send("^{F4}"), desc: "『Ctrl + F4』キーを送信します。"},
    {key: "F1 & x", func: (*) => Translate(bingAppPath, bingUrl, bingTitle), desc: "クリップボードの内容を翻訳します。"},
    {key: "F1 & c", func: (*) => Translate(googleAppPath, googleUrl, googleTitle), desc: "クリップボードの内容を翻訳します。"},
    {key: "F1 & v", func: (*) => Translate(deeplAppPath, deeplUrl, deeplTitle), desc: "クリップボードの内容を翻訳します。"},
    {key: "F1 & a", func: (*) => ResetMouseSettings(), desc: "マウスの設定をリセットします。"},
    {key: "F1 & s", func: (*) => ChangeHorizontalScrollDirectionMode(), desc: "水平 スクロール方向モードに切り替えます。"},
    {key: "F1 & d", func: (*) => ChangeSlowMouseSpeedMode(), desc: "スロウ マウススピードモードに切り替えます。"},
    {key: "F1 & f", func: (*) => ChangePageScrollSpeedMode(), desc: "1画面 スクロールスピードモードに切り替えます。"},
    {key: "F2 & z", func: (*) => Send("{F13}"), desc: "『F13』キーを送信します。"},
    {key: "F2 & x", func: (*) => Send("{F14}"), desc: "『F14』キーを送信します。"},
    {key: "F2 & c", func: (*) => Send("{F15}"), desc: "『F15』キーを送信します。"},
    {key: "F2 & v", func: (*) => Send("{F16}"), desc: "『F16』キーを送信します。"},
    {key: "F2 & a", func: (*) => Send("{F17}"), desc: "『F17』キーを送信します。"},
    {key: "F2 & s", func: (*) => Send("{F18}"), desc: "『F18』キーを送信します。"},
    {key: "F2 & d", func: (*) => Send("{F19}"), desc: "『F19』キーを送信します。"},
    {key: "F2 & f", func: (*) => Send("{F20}"), desc: "『F20』キーを送信します。"},
    {key: "F2 & q", func: (*) => Send("{F21}"), desc: "『F21』キーを送信します。"},
    {key: "F2 & w", func: (*) => Send("{F22}"), desc: "『F22』キーを送信します。"},
    {key: "F2 & e", func: (*) => Send("{F23}"), desc: "『F23』キーを送信します。"},
    {key: "F2 & r", func: (*) => Send("{F24}"), desc: "『F24』キーを送信します。"},
    {key: "F2 & 1", func: (*) => Send("{F1}"), desc: "『F1』キーを送信します。"},
    {key: "F2 & 2", func: (*) => Send("{F2}"), desc: "『F2』キーを送信します。"},
    {key: "F2 & m", func: (*) => Send("+{F13}"), desc: "『Shift + F13』キーを送信します。"},
    {key: "F2 & ,", func: (*) => Send("+{F14}"), desc: "『Shift + F14』キーを送信します。"},
    {key: "F2 & .", func: (*) => Send("+{F15}"), desc: "『Shift + F15』キーを送信します。"},
    {key: "F2 & /", func: (*) => Send("+{F16}"), desc: "『Shift + F16』キーを送信します。"},
    {key: "F2 & j", func: (*) => Send("+{F17}"), desc: "『Shift + F17』キーを送信します。"},
    {key: "F2 & k", func: (*) => Send("+{F18}"), desc: "『Shift + F18』キーを送信します。"},
    {key: "F2 & l", func: (*) => Send("+{F19}"), desc: "『Shift + F19』キーを送信します。"},
    {key: "F2 & `;", func: (*) => Send("+{F20}"), desc: "『Shift + F20』キーを送信します。"},
    {key: "F2 & u", func: (*) => Send("+{F21}"), desc: "『Shift + F21』キーを送信します。"},
    {key: "F2 & i", func: (*) => Send("+{F22}"), desc: "『Shift + F22』キーを送信します。"},
    {key: "F2 & o", func: (*) => Send("+{F23}"), desc: "『Shift + F23』キーを送信します。"},
    {key: "F2 & p", func: (*) => Send("+{F24}"), desc: "『Shift + F24』キーを送信します。"},
    {key: "F2 & 7", func: (*) => Send("+{F1}"), desc: "『Shift + F1』キーを送信します。"},
    {key: "F2 & 8", func: (*) => Send("+{F2}"), desc: "『Shift + F2』キーを送信します。"},
    {key: "sc029", func: (*) => ResetMouseSettings(), desc: "マウスの設定をリセットします。(sc029 = 半角／全角キー)"},
    {key: "sc03A", func: (*) => ResetMouseSettings(), desc: "マウスの設定をリセットします。(sc03A = 英数キー)"},
    {key: "sc070", func: (*) => ResetMouseSettings(), desc: "マウスの設定をリセットします。(sc070 = カタカナ・ひらがなキー)"},
    {key: "WheelUp", func: (*) => WheelUpOrLeft(), desc: "『WheelUp』／『WheelLeft』キーを送信します。"},
    {key: "WheelDown", func: (*) => WheelDownOrRight(), desc: "『WheelDown』／『WheelRight』キーを送信します。"},
    {key: "XButton1", func: (*) => ResetMouseSettings(), desc: "マウスの設定をリセットします。"},
    {key: "XButton2", func: (*) => ChangeHorizontalScrollDirectionMode(), desc: "水平 スクロール方向モードに切り替えます。"},
    {key: "^XButton1", func: (*) => ResetMouseSettings(), desc: "マウスの設定をリセットします。"},
    {key: "^XButton2", func: (*) => ChangeSlowMouseSpeedMode(), desc: "スロウ マウススピードモードに切り替えます。"},
    {key: "+XButton1", func: (*) => ResetMouseSettings(), desc: "マウスの設定をリセットします。"},
    {key: "+XButton2", func: (*) => ChangePageScrollSpeedMode(), desc: "1画面 スクロールスピードモードに切り替えます。"},
    {key: "^+XButton1", func: (*) => ResetMouseSettings(), desc: "マウスの設定をリセットします。"},
    {key: "^+XButton2", func: (*) => Send("^{F4}"), desc: "『Ctrl + F4』キーを送信します。"},
    {key: "!XButton1", func: (*) => Send("{Home}"), desc: "『Home』キーを送信します。"},
    {key: "!XButton2", func: (*) => Send("{End}"), desc: "『End』キーを送信します。"},
    {key: "^!XButton1", func: (*) => Send("^{Home}"), desc: "『Ctrl + Home』キーを送信します。"},
    {key: "^!XButton2", func: (*) => Send("^{End}"), desc: "『Ctrl + End』キーを送信します。"},
    {key: "+!XButton1", func: (*) => Send("+{Home}"), desc: "『Shift + Home』キーを送信します。"},
    {key: "+!XButton2", func: (*) => Send("+{End}"), desc: "『Shift + End』キーを送信します。"},
    {key: "^+!XButton1", func: (*) => Send("^+{Home}"), desc: "『Ctrl + Shift + Home』キーを送信します。"},
    {key: "^+!XButton2", func: (*) => Send("^+{End}"), desc: "『Ctrl + Shift + End』キーを送信します。"},
    {key: "#XButton1", func: (*) => Send("{PgUp}"), desc: "『PgUp』キーを送信します。"},
    {key: "#XButton2", func: (*) => Send("{PgDn}"), desc: "『PgDn』キーを送信します。"},
    {key: "^#XButton1", func: (*) => Send("^{PgUp}"), desc: "『Ctrl + PgUp』キーを送信します。"},
    {key: "^#XButton2", func: (*) => Send("^{PgDn}"), desc: "『Ctrl + PgDn』キーを送信します。"},
    {key: "+#XButton1", func: (*) => Send("+{PgUp}"), desc: "『Shift + PgUp』キーを送信します。"},
    {key: "+#XButton2", func: (*) => Send("+{PgDn}"), desc: "『Shift + PgDn』キーを送信します。"},
    {key: "^+#XButton1", func: (*) => Send("^+{PgUp}"), desc: "『Ctrl + Shift + PgUp』キーを送信します。"},
    {key: "^+#XButton2", func: (*) => Send("^+{PgDn}"), desc: "『Ctrl + Shift + PgDn』キーを送信します。"}
]

; ホットキー一覧を表示します。
ShowHotkeys() {
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

    for (i in hotkeys) {
        listView.Add("", i.key, i.desc)
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
    scrollDirection := env.mouse.state.scroll.direction
    scrollSpeed := env.mouse.state.scroll.speed
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
    listView.Add("", "スクロール方向", scrollDirection)
    listView.Add("", "スクロールスピード", scrollSpeed)
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
    speed := env.mouse.const.pointer.speed.default.name
    speedValue := env.mouse.const.pointer.speed.default.value

    env.mouse.state.pointer.speed := speed

    SetMouseSpeed(speedValue)
}

; スロウ マウススピードモードに切り替えます。
ChangeSlowMouseSpeedMode() {
    speed := env.mouse.const.pointer.speed.slow.name
    speedValue := env.mouse.const.pointer.speed.slow.value

    env.mouse.state.pointer.speed := speed

    SetMouseSpeed(speedValue)
}

; 垂直 スクロール方向モードに切り替えます。
ChangeVerticalScrollDirectionMode() {
    direction := env.mouse.const.scroll.direction.vertical
    env.mouse.state.scroll.direction := direction
}

; 水平 スクロール方向モードに切り替えます。
ChangeHorizontalScrollDirectionMode() {
    direction := env.mouse.const.scroll.direction.horizontal
    env.mouse.state.scroll.direction := direction
}

; デフォルト スクロールスピードモードに切り替えます。
ChangeDefaultScrollSpeedMode() {
    speed := env.mouse.const.scroll.speed.default.name
    verticalSpeed := env.mouse.const.scroll.speed.default.vertical
    horizontalSpeed := env.mouse.const.scroll.speed.default.horizontal

    env.mouse.state.scroll.speed := speed

    SetWheelScrollLines(verticalSpeed)
    SetWheelScrollChars(horizontalSpeed)
}

; 1画面 スクロールスピードモードに切り替えます。
ChangePageScrollSpeedMode() {
    speed := env.mouse.const.scroll.speed.page.name
    verticalSpeed := env.mouse.const.scroll.speed.page.vertical
    horizontalSpeed := env.mouse.const.scroll.speed.page.horizontal

    env.mouse.state.scroll.speed := speed

    SetWheelScrollLines(verticalSpeed)
    SetWheelScrollChars(horizontalSpeed)
}

; スロウ スクロールスピードモードに切り替えます。
ChangeSlowScrollSpeedMode() {
    speed := env.mouse.const.scroll.speed.slow.name
    verticalSpeed := env.mouse.const.scroll.speed.slow.vertical
    horizontalSpeed := env.mouse.const.scroll.speed.slow.horizontal

    env.mouse.state.scroll.speed := speed

    SetWheelScrollLines(verticalSpeed)
    SetWheelScrollChars(horizontalSpeed)
}

; ハイ スクロールスピードモードに切り替えます。
ChangeHighScrollSpeedMode() {
    speed := env.mouse.const.scroll.speed.high.name
    verticalSpeed := env.mouse.const.scroll.speed.high.vertical
    horizontalSpeed := env.mouse.const.scroll.speed.high.horizontal

    env.mouse.state.scroll.speed := speed

    SetWheelScrollLines(verticalSpeed)
    SetWheelScrollChars(horizontalSpeed)
}

; スロウ マウススピードモードに切り替えます。トグル方式。
ToggleSlowMouseSpeedMode() {
    speed := env.mouse.state.pointer.speed
    slowSpeed := env.mouse.const.pointer.speed.slow.name

    if (speed != slowSpeed) {
        ChangeSlowMouseSpeedMode()
    } else {
        ChangeDefaultMouseSpeedMode()
    }
}

; 水平 スクロール方向モードに切り替えます。トグル方式。
ToggleHorizontalScrollDirectionMode() {
    direction := env.mouse.state.scroll.direction
    horizontalDirection := env.mouse.const.scroll.direction.horizontal

    if (direction != horizontalDirection) {
        ChangeHorizontalScrollDirectionMode()
    } else {
        ChangeVerticalScrollDirectionMode()
    }
}

; 1画面 スクロールスピードモードに切り替えます。トグル方式。
TogglePageScrollSpeedMode() {
    speed := env.mouse.state.scroll.speed
    pageSpeed := env.mouse.const.scroll.speed.page.name

    if (speed != pageSpeed) {
        ChangePageScrollSpeedMode()
    } else {
        ChangeDefaultScrollSpeedMode()
    }
}

; スロウ スクロールスピードモードに切り替えます。トグル方式。
ToggleSlowScrollSpeedMode() {
    speed := env.mouse.state.scroll.speed
    slowSpeed := env.mouse.const.scroll.speed.slow.name

    if (speed != slowSpeed) {
        ChangeSlowScrollSpeedMode()
    } else {
        ChangeDefaultScrollSpeedMode()
    }
}

; ハイ スクロールスピードモードに切り替えます。トグル方式。
ToggleHighScrollSpeedMode() {
    speed := env.mouse.state.scroll.speed
    highSpeed := env.mouse.const.scroll.speed.high.name

    if (speed != highSpeed) {
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

; クリップボードの内容を翻訳します。
Translate(appPath, url, title) {

    if (!ClipWait(2)) {
        MsgBox("クリップボードが空の為、翻訳できません。")
        return
    }

    text := UrlEncode(A_Clipboard)
    formattedUrl := Format(url, text)
    launchedApp := Format("`"{1}`" --app=`"{2}`" --disable-extensions --disable-plugins --disable-dev-tools", appPath, formattedUrl)

    WinGetPos(&activeX, &activeY, &activeW, &activeH, "A")

    try {
        WinClose(title)
    } catch as e {
        ; 何もしない。ウィンドウが存在しない場合、エラーが発生するが、初期化処理の為、問題なし。
    }

    try {
        Run(launchedApp,, "Hide", &outputVarPID)
    } catch as e {
        ; 何もしない。アプリの起動に失敗した場合、即座に処理終了。
        return
    }

    WinWait(title)
    WinGetPos(,, &newW, &newH, title)

    x := activeX + Floor((activeW - newW) / 2)
    y := activeY + Floor((activeH - newH) / 2)

    WinMove(x, y, newW, newH, title)
}

; URLエンコードします。
UrlEncode(str) {
    byteLen := StrPut(str, "UTF-8") - 1
    buf := Buffer(byteLen)
    StrPut(str, buf, "UTF-8")

    out := ""
    Loop byteLen {
        ch := NumGet(buf, A_Index - 1, "UChar")
        if ( (ch >= 0x30 && ch <= 0x39)    ; 0-9
          || (ch >= 0x41 && ch <= 0x5A)    ; A-Z
          || (ch >= 0x61 && ch <= 0x7A)    ; a-z
          || ch = 45 || ch = 46 || ch = 95 || ch = 126 ) { ; - . _ ~
            out .= Chr(ch)
        } else {
            out .= "%" . Format("{:02X}", ch)
        }
    }
    return out
}

; スクリプトの終了処理を行います。
ExitFunc(exitReason, exitCode) {
    ResetMouseSettings()
}

; 『WheelUp』／『WheelLeft』キーを送信します。
WheelUpOrLeft() {
    direction := env.mouse.state.scroll.direction
    horizontalDirection := env.mouse.const.scroll.direction.horizontal

    if (direction = horizontalDirection) {
        Send("{WheelLeft}")
    } else {
        Send("{WheelUp}")
    }
}

; 『WheelDown』／『WheelRight』キーを送信します。
WheelDownOrRight() {
    direction := env.mouse.state.scroll.direction
    horizontalDirection := env.mouse.const.scroll.direction.horizontal

    if (direction = horizontalDirection) {
        Send("{WheelRight}")
    } else {
        Send("{WheelDown}")
    }
}

; ホットキーを登録します。
RegisterHotkeys() {
    for (i in hotkeys) {
        Hotkey(i.key, i.func)
    }
}

RegisterHotkeys()
