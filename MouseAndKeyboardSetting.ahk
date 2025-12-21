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

hotkeys := [
    {
        key: "^#h",
        func: (*) => ShowHotkeys(),
        desc: "ホットキー一覧を表示します。"
    },
    {
        key: "^#s",
        func: (*) => ShowEnvironment(),
        desc: "環境情報を表示します。"
    },
    {
        key: "^#l",
        func: (*) => ListHotkeys(),
        desc: "ホットキー一覧を表示します。組み込みListHotkeys関数。"
    },
    {
        key: "^#k",
        func: (*) => KeyHistory(),
        desc: "キーヒストリーを表示します。組み込みKeyHistory関数。"
    },
    {
        key: "Space & v",
        func: (*) => TurnOffIME(),
        desc: "IMEをオフにします。"
    },
    {
        key: "Space & b",
        func: (*) => TurnOnIME(),
        desc: "IMEをオンにします。"
    },
    {
        key: "Space & q",
        func: (*) => ResetMouseSettings(),
        desc: "マウスの設定をリセットします。"
    },
    {
        key: "Space & w",
        func: (*) => ChangeHorizontalScrollDirectionMode(),
        desc: "水平 スクロール方向モードに切り替えます。"
    },
    {
        key: "Space & e",
        func: (*) => ChangeSlowMouseSpeedMode(),
        desc: "スロウ マウススピードモードに切り替えます。"
    },
    {
        key: "Space & r",
        func: (*) => ChangePageScrollSpeedMode(),
        desc: "1画面 スクロールスピードモードに切り替えます。"
    },
    {
        key: "Space & a",
        func: (*) => Send("^{F4}"),
        desc: "<<Ctrl+F4>>キーを送信します。"
    },
    {
        key: "Space & s",
        func: (*) => Translate(env.translation.const.bing.appPath, env.translation.const.bing.url, env.translation.const.bing.title),
        desc: "クリップボードの内容を翻訳します。Microsoft Translator"
    },
    {
        key: "Space & d",
        func: (*) => Translate(env.translation.const.google.appPath, env.translation.const.google.url, env.translation.const.google.title),
        desc: "クリップボードの内容を翻訳します。Google 翻訳"
    },
    {
        key: "Space & f",
        func: (*) => Translate(env.translation.const.deepl.appPath, env.translation.const.deepl.url, env.translation.const.deepl.title),
        desc: "クリップボードの内容を翻訳します。DeepL翻訳"
    },
    {
        key: "!Space",
        func: (*) => Send("{Space}"),
        desc: "<<Space>>キーを送信します。"
    },
    {
        key: "^Space",
        func: (*) => Send("^{Space}"),
        desc: "<<Ctrl+Space>>キーを送信します。"
    },
    {
        key: "+Space",
        func: (*) => Send("+{Space}"),
        desc: "<<Shift+Space>>キーを送信します。"
    },
    {
        key: "F1 & 1",
        func: (*) => Send("{F1}"),
        desc: "<<F1>>キーを送信します。"
    },
    {
        key: "F1 & 2",
        func: (*) => Send("^{F1}"),
        desc: "<<Ctrl+F1>>キーを送信します。"
    },
    {
        key: "F1 & 3",
        func: (*) => Send("+{F1}"),
        desc: "<<Shift+F1>>キーを送信します。"
    },
    {
        key: "F1 & 4",
        func: (*) => Send("!{F1}"),
        desc: "<<Alt+F1>>キーを送信します。"
    },
    {
        key: "F1 & z",
        func: (*) => Send("{F13}"),
        desc: "<<F13>>キーを送信します。"
    },
    {
        key: "F1 & x",
        func: (*) => Send("{F14}"),
        desc: "<<F14>>キーを送信します。"
    },
    {
        key: "F1 & c",
        func: (*) => Send("{F15}"),
        desc: "<<F15>>キーを送信します。"
    },
    {
        key: "F1 & v",
        func: (*) => Send("{F16}"),
        desc: "<<F16>>キーを送信します。"
    },
    {
        key: "F1 & a",
        func: (*) => Send("{F17}"),
        desc: "<<F17>>キーを送信します。"
    },
    {
        key: "F1 & s",
        func: (*) => Send("{F18}"),
        desc: "<<F18>>キーを送信します。"
    },
    {
        key: "F1 & d",
        func: (*) => Send("{F19}"),
        desc: "<<F19>>キーを送信します。"
    },
    {
        key: "F1 & f",
        func: (*) => Send("{F20}"),
        desc: "<<F20>>キーを送信します。"
    },
    {
        key: "F1 & q",
        func: (*) => Send("{F21}"),
        desc: "<<F21>>キーを送信します。"
    },
    {
        key: "F1 & w",
        func: (*) => Send("{F22}"),
        desc: "<<F22>>キーを送信します。"
    },
    {
        key: "F1 & e",
        func: (*) => Send("{F23}"),
        desc: "<<F23>>キーを送信します。"
    },
    {
        key: "F1 & r",
        func: (*) => Send("{F24}"),
        desc: "<<F24>>キーを送信します。"
    },
    {
        key: "F2 & 1",
        func: (*) => Send("{F2}"),
        desc: "<<F2>>キーを送信します。"
    },
    {
        key: "F2 & 2",
        func: (*) => Send("^{F2}"),
        desc: "<<Ctrl+F2>>キーを送信します。"
    },
    {
        key: "F2 & 3",
        func: (*) => Send("+{F2}"),
        desc: "<<Shift+F2>>キーを送信します。"
    },
    {
        key: "F2 & 4",
        func: (*) => Send("!{F2}"),
        desc: "<<Alt+F2>>キーを送信します。"
    },
    {
        key: "F2 & z",
        func: (*) => Send("^{F13}"),
        desc: "<<Ctrl+F13>>キーを送信します。"
    },
    {
        key: "F2 & x",
        func: (*) => Send("^{F14}"),
        desc: "<<Ctrl+F14>>キーを送信します。"
    },
    {
        key: "F2 & c",
        func: (*) => Send("^{F15}"),
        desc: "<<Ctrl+F15>>キーを送信します。"
    },
    {
        key: "F2 & v",
        func: (*) => Send("^{F16}"),
        desc: "<<Ctrl+F16>>キーを送信します。"
    },
    {
        key: "F2 & a",
        func: (*) => Send("^{F17}"),
        desc: "<<Ctrl+F17>>キーを送信します。"
    },
    {
        key: "F2 & s",
        func: (*) => Send("^{F18}"),
        desc: "<<Ctrl+F18>>キーを送信します。"
    },
    {
        key: "F2 & d",
        func: (*) => Send("^{F19}"),
        desc: "<<Ctrl+F19>>キーを送信します。"
    },
    {
        key: "F2 & f",
        func: (*) => Send("^{F20}"),
        desc: "<<Ctrl+F20>>キーを送信します。"
    },
    {
        key: "F2 & q",
        func: (*) => Send("^{F21}"),
        desc: "<<Ctrl+F21>>キーを送信します。"
    },
    {
        key: "F2 & w",
        func: (*) => Send("^{F22}"),
        desc: "<<Ctrl+F22>>キーを送信します。"
    },
    {
        key: "F2 & e",
        func: (*) => Send("^{F23}"),
        desc: "<<Ctrl+F23>>キーを送信します。"
    },
    {
        key: "F2 & r",
        func: (*) => Send("^{F24}"),
        desc: "<<Ctrl+F24>>キーを送信します。"
    },
    {
        key: "F12 & 1",
        func: (*) => Send("{F12}"),
        desc: "<<F12>>キーを送信します。"
    },
    {
        key: "F12 & 2",
        func: (*) => Send("^{F12}"),
        desc: "<<Ctrl+F12>>キーを送信します。"
    },
    {
        key: "F12 & 3",
        func: (*) => Send("+{F12}"),
        desc: "<<Shift+F12>>キーを送信します。"
    },
    {
        key: "F12 & 4",
        func: (*) => Send("!{F12}"),
        desc: "<<Alt+F12>>キーを送信します。"
    },
    {
        key: "F12 & z",
        func: (*) => Send("+{F13}"),
        desc: "<<Shift+F13>>キーを送信します。"
    },
    {
        key: "F12 & x",
        func: (*) => Send("+{F14}"),
        desc: "<<Shift+F14>>キーを送信します。"
    },
    {
        key: "F12 & c",
        func: (*) => Send("+{F15}"),
        desc: "<<Shift+F15>>キーを送信します。"
    },
    {
        key: "F12 & v",
        func: (*) => Send("+{F16}"),
        desc: "<<Shift+F16>>キーを送信します。"
    },
    {
        key: "F12 & a",
        func: (*) => Send("+{F17}"),
        desc: "<<Shift+F17>>キーを送信します。"
    },
    {
        key: "F12 & s",
        func: (*) => Send("+{F18}"),
        desc: "<<Shift+F18>>キーを送信します。"
    },
    {
        key: "F12 & d",
        func: (*) => Send("+{F19}"),
        desc: "<<Shift+F19>>キーを送信します。"
    },
    {
        key: "F12 & f",
        func: (*) => Send("+{F20}"),
        desc: "<<Shift+F20>>キーを送信します。"
    },
    {
        key: "F12 & q",
        func: (*) => Send("+{F21}"),
        desc: "<<Shift+F21>>キーを送信します。"
    },
    {
        key: "F12 & w",
        func: (*) => Send("+{F22}"),
        desc: "<<Shift+F22>>キーを送信します。"
    },
    {
        key: "F12 & e",
        func: (*) => Send("+{F23}"),
        desc: "<<Shift+F23>>キーを送信します。"
    },
    {
        key: "F12 & r",
        func: (*) => Send("+{F24}"),
        desc: "<<Shift+F24>>キーを送信します。"
    },
    {
        key: "F11 & 1",
        func: (*) => Send("{F11}"),
        desc: "<<F11>>キーを送信します。"
    },
    {
        key: "F11 & 2",
        func: (*) => Send("^{F11}"),
        desc: "<<Ctrl+F11>>キーを送信します。"
    },
    {
        key: "F11 & 3",
        func: (*) => Send("+{F11}"),
        desc: "<<Shift+F11>>キーを送信します。"
    },
    {
        key: "F11 & 4",
        func: (*) => Send("!{F11}"),
        desc: "<<Alt+F11>>キーを送信します。"
    },
    {
        key: "F11 & z",
        func: (*) => Send("!{F13}"),
        desc: "<<Alt+F13>>キーを送信します。"
    },
    {
        key: "F11 & x",
        func: (*) => Send("!{F14}"),
        desc: "<<Alt+F14>>キーを送信します。"
    },
    {
        key: "F11 & c",
        func: (*) => Send("!{F15}"),
        desc: "<<Alt+F15>>キーを送信します。"
    },
    {
        key: "F11 & v",
        func: (*) => Send("!{F16}"),
        desc: "<<Alt+F16>>キーを送信します。"
    },
    {
        key: "F11 & a",
        func: (*) => Send("!{F17}"),
        desc: "<<Alt+F17>>キーを送信します。"
    },
    {
        key: "F11 & s",
        func: (*) => Send("!{F18}"),
        desc: "<<Alt+F18>>キーを送信します。"
    },
    {
        key: "F11 & d",
        func: (*) => Send("!{F19}"),
        desc: "<<Alt+F19>>キーを送信します。"
    },
    {
        key: "F11 & f",
        func: (*) => Send("!{F20}"),
        desc: "<<Alt+F20>>キーを送信します。"
    },
    {
        key: "F11 & q",
        func: (*) => Send("!{F21}"),
        desc: "<<Alt+F21>>キーを送信します。"
    },
    {
        key: "F11 & w",
        func: (*) => Send("!{F22}"),
        desc: "<<Alt+F22>>キーを送信します。"
    },
    {
        key: "F11 & e",
        func: (*) => Send("!{F23}"),
        desc: "<<Alt+F23>>キーを送信します。"
    },
    {
        key: "F11 & r",
        func: (*) => Send("!{F24}"),
        desc: "<<Alt+F24>>キーを送信します。"
    },
    {
        key: "WheelUp",
        func: (*) => WheelUpOrLeft(),
        desc: "<<WheelUp>>／<<WheelLeft>>キーを送信します。"
    },
    {
        key: "WheelDown",
        func: (*) => WheelDownOrRight(),
        desc: "<<WheelDown>>／<<WheelRight>>キーを送信します。"
    },
    {
        key: "XButton1",
        func: (*) => ResetMouseSettings(),
        desc: "マウスの設定をリセットします。"
    },
    {
        key: "XButton2",
        func: (*) => ChangeHorizontalScrollDirectionMode(),
        desc: "水平 スクロール方向モードに切り替えます。"
    },
    {
        key: "^XButton1",
        func: (*) => ResetMouseSettings(),
        desc: "マウスの設定をリセットします。"
    },
    {
        key: "^XButton2",
        func: (*) => ChangeSlowMouseSpeedMode(),
        desc: "スロウ マウススピードモードに切り替えます。"
    },
    {
        key: "+XButton1",
        func: (*) => ResetMouseSettings(),
        desc: "マウスの設定をリセットします。"
    },
    {
        key: "+XButton2",
        func: (*) => ChangePageScrollSpeedMode(),
        desc: "1画面 スクロールスピードモードに切り替えます。"
    },
    {
        key: "^+XButton1",
        func: (*) => ResetMouseSettings(),
        desc: "マウスの設定をリセットします。"
    },
    {
        key: "^+XButton2",
        func: (*) => Send("^{F4}"),
        desc: "<<Ctrl+F4>>キーを送信します。"
    },
    {
        key: "!XButton1",
        func: (*) => Send("{Home}"),
        desc: "<<Home>>キーを送信します。"
    },
    {
        key: "!XButton2",
        func: (*) => Send("{End}"),
        desc: "<<End>>キーを送信します。"
    },
    {
        key: "^!XButton1",
        func: (*) => Send("^{Home}"),
        desc: "<<Ctrl+Home>>キーを送信します。"
    },
    {
        key: "^!XButton2",
        func: (*) => Send("^{End}"),
        desc: "<<Ctrl+End>>キーを送信します。"
    },
    {
        key: "+!XButton1",
        func: (*) => Send("+{Home}"),
        desc: "<<Shift+Home>>キーを送信します。"
    },
    {
        key: "+!XButton2",
        func: (*) => Send("+{End}"),
        desc: "<<Shift+End>>キーを送信します。"
    },
    {
        key: "^+!XButton1",
        func: (*) => Send("^+{Home}"),
        desc: "<<Ctrl+Shift+Home>>キーを送信します。"
    },
    {
        key: "^+!XButton2",
        func: (*) => Send("^+{End}"),
        desc: "<<Ctrl+Shift+End>>キーを送信します。"
    },
    {
        key: "#XButton1",
        func: (*) => Send("{PgUp}"),
        desc: "<<PgUp>>キーを送信します。"
    },
    {
        key: "#XButton2",
        func: (*) => Send("{PgDn}"),
        desc: "<<PgDn>>キーを送信します。"
    },
    {
        key: "^#XButton1",
        func: (*) => Send("^{PgUp}"),
        desc: "<<Ctrl+PgUp>>キーを送信します。"
    },
    {
        key: "^#XButton2",
        func: (*) => Send("^{PgDn}"),
        desc: "<<Ctrl+PgDn>>キーを送信します。"
    },
    {
        key: "+#XButton1",
        func: (*) => Send("+{PgUp}"),
        desc: "<<Shift+PgUp>>キーを送信します。"
    },
    {
        key: "+#XButton2",
        func: (*) => Send("+{PgDn}"),
        desc: "<<Shift+PgDn>>キーを送信します。"
    },
    {
        key: "^+#XButton1",
        func: (*) => Send("^+{PgUp}"),
        desc: "<<Ctrl+Shift+PgUp>>キーを送信します。"
    },
    {
        key: "^+#XButton2",
        func: (*) => Send("^+{PgDn}"),
        desc: "<<Ctrl+Shift+PgDn>>キーを送信します。"
    }
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

; IMEをオフにします。
TurnOffIME() {
    SetImeOpen(false)
}

; IMEをオンにします。
TurnOnIME() {
    SetImeOpen(true)
}

; IME 開閉状態を取得
ImeGetOpen(hwnd) {
    himc := DllCall("imm32\ImmGetContext", "Ptr", hwnd, "Ptr")
    if (!himc) {
        return -1
    }
    open := DllCall("imm32\ImmGetOpenStatus", "Ptr", himc, "Int")
    DllCall("imm32\ImmReleaseContext", "Ptr", hwnd, "Ptr", himc)
    return open
}

; IMM 直接切替（検証まで）
ImeSetOpenViaImm(hwnd, desired) {
    himc := DllCall("imm32\ImmGetContext", "Ptr", hwnd, "Ptr")
    if (!himc) {
        return false
    }
    current := DllCall("imm32\ImmGetOpenStatus", "Ptr", himc, "Int")
    success := false
    if (current != desired) {
        ok := DllCall("imm32\ImmSetOpenStatus", "Ptr", himc, "Int", desired, "Int")
        if (ok) {
            ; 同じコンテキストで再検証
            success := (DllCall("imm32\ImmGetOpenStatus", "Ptr", himc, "Int") = desired)
        }
    } else {
        success := true
    }
    DllCall("imm32\ImmReleaseContext", "Ptr", hwnd, "Ptr", himc)
    return success
}

; デフォルト IME ウィンドウ取得（ルート祖先フォールバック込み）
GetDefaultImeWndFor(hwnd) {
    hIME := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
    if (hIME) {
        return hIME
    }
    GA_ROOT := 2
    root := DllCall("user32\GetAncestor", "Ptr", hwnd, "UInt", GA_ROOT, "Ptr")
    if (!root) {
        return 0
    }
    return DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", root, "Ptr")
}

; WM_IME_CONTROL 経由で開閉（ブロッキング→ポストの順で試行）
ImeSetOpenViaImeWnd(hwnd, desired, timeoutMs := 300) {
    WM_IME_CONTROL := 0x0283
    IMC_SETOPENSTATUS := 0x0006
    SMTO_BLOCK := 0x0001
    SMTO_ABORTIFHUNG := 0x0002

    hIME := GetDefaultImeWndFor(hwnd)
    if (!hIME) {
        return false
    }

    r := DllCall("user32\SendMessageTimeoutW"
        , "Ptr", hIME
        , "UInt", WM_IME_CONTROL
        , "UPtr", IMC_SETOPENSTATUS
        , "UPtr", desired
        , "UInt", SMTO_BLOCK | SMTO_ABORTIFHUNG
        , "UInt", timeoutMs
        , "Ptr", 0
        , "UInt")

    if (!r) {
        DllCall("user32\PostMessageW"
            , "Ptr", hIME
            , "UInt", WM_IME_CONTROL
            , "UPtr", IMC_SETOPENSTATUS
            , "UPtr", desired
            , "Int")
        Sleep(25)
    }

    ; 検証
    open := ImeGetOpen(hwnd)
    return (open != -1) && (open = desired)
}

; 最終手段：VK_KANJI でトグル（検証可能な時のみ）
ImeToggleViaVkIfNeeded(hwnd, desired) {
    current := ImeGetOpen(hwnd)
    if (current = -1) {
        return false
    }
    if (current = desired) {
        return true
    }
    Send("{vk19}")  ; VK_KANJI
    Sleep(25)
    return (ImeGetOpen(hwnd) = desired)
}

; IMEのオン／オフを切り替えます。
SetImeOpen(on, timeoutMs := 300) {
    hwnd := GetFocusOrActiveHwnd()
    if (!hwnd) {
        return false
    }
    desired := on ? 1 : 0

    if (ImeSetOpenViaImm(hwnd, desired)) {
        return true
    }

    ; 一過性対策で 1 回リトライ
    if (ImeSetOpenViaImeWnd(hwnd, desired, timeoutMs)) {
        return true
    }
    if (ImeSetOpenViaImeWnd(hwnd, desired, timeoutMs)) {
        return true
    }
    ; 最終手段（検証可能時のみトグル送信）
    return ImeToggleViaVkIfNeeded(hwnd, desired)
}

; フォーカス／キャレット／アクティブの候補から、
; IME コンテキストが取得できる窓（なければそのルート祖先）を返す。
GetFocusOrActiveHwnd() {
    hwndActive := WinExist("A")
    if (!hwndActive) {
        return 0
    }

    static GI_SIZE := 4 + 4 + (A_PtrSize * 6) + 16
    static OFF_ACTIVE := 8
    static OFF_FOCUS := 8 + A_PtrSize
    static OFF_CARET := 8 + (A_PtrSize * 5)

    buf := Buffer(GI_SIZE, 0)
    NumPut("UInt", GI_SIZE, buf)

    threadId := DllCall("user32\GetWindowThreadProcessId", "Ptr", hwndActive, "UInt*", 0, "UInt")
    ok := DllCall("user32\GetGUIThreadInfo", "UInt", threadId, "Ptr", buf, "Int")
    
    candidates := []
    if (ok) {
        hwndFocus := NumGet(buf, OFF_FOCUS, "Ptr")
        hwndCaret := NumGet(buf, OFF_CARET, "Ptr")
        hwndActiveGI := NumGet(buf, OFF_ACTIVE, "Ptr")

        if (hwndFocus && DllCall("user32\IsWindow", "Ptr", hwndFocus, "Int")) {
            candidates.Push(hwndFocus)
        }
        if (hwndCaret && DllCall("user32\IsWindow", "Ptr", hwndCaret, "Int")) {
            candidates.Push(hwndCaret)
        }
        if (hwndActiveGI && DllCall("user32\IsWindow", "Ptr", hwndActiveGI, "Int")) {
            candidates.Push(hwndActiveGI)
        }
    }
    ; 最後に必ずアクティブ窓を候補へ
    candidates.Push(hwndActive)

    GA_ROOT := 2

    ; 1) 候補自身に HIMC があるならそれを返す
    ; 2) なければルート祖先に HIMC があるか確認して返す
    for (candidate in candidates) {
        himc := DllCall("imm32\ImmGetContext", "Ptr", candidate, "Ptr")
        if (himc) {
            DllCall("imm32\ImmReleaseContext", "Ptr", candidate, "Ptr", himc)
            return candidate
        }
        root := DllCall("user32\GetAncestor", "Ptr", candidate, "UInt", GA_ROOT, "Ptr")
        if (root) {
            himc2 := DllCall("imm32\ImmGetContext", "Ptr", root, "Ptr")
            if (himc2) {
                DllCall("imm32\ImmReleaseContext", "Ptr", root, "Ptr", himc2)
                return root
            }
        }
    }
    ; どれも取れない場合は最後にアクティブを返す
    return hwndActive
}

; マウスの設定をリセットします。
ResetMouseSettings() {
    ChangeDefaultMouseSpeedMode()
    ChangeVerticalScrollDirectionMode()
    ChangeDefaultScrollSpeedMode()
}

; デフォルト マウススピードモードに切り替えます。
ChangeDefaultMouseSpeedMode() {
    currentSpeed := env.mouse.state.pointer.speed
    defaultName := env.mouse.const.pointer.speed.default.name

    if (currentSpeed = defaultName) {
        return
    }

    speedValue := env.mouse.const.pointer.speed.default.value
    env.mouse.state.pointer.speed := defaultName

    SetMouseSpeed(speedValue)
}

; スロウ マウススピードモードに切り替えます。
ChangeSlowMouseSpeedMode() {
    currentSpeed := env.mouse.state.pointer.speed
    slowName := env.mouse.const.pointer.speed.slow.name

    if (currentSpeed = slowName) {
        return
    }

    speedValue := env.mouse.const.pointer.speed.slow.value
    env.mouse.state.pointer.speed := slowName

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
    currentSpeed := env.mouse.state.scroll.speed
    defaultName := env.mouse.const.scroll.speed.default.name

    if (currentSpeed = defaultName) {
        return
    }

    speed := defaultName
    verticalSpeed := env.mouse.const.scroll.speed.default.vertical
    horizontalSpeed := env.mouse.const.scroll.speed.default.horizontal

    env.mouse.state.scroll.speed := speed

    SetWheelScrollLines(verticalSpeed)
    SetWheelScrollChars(horizontalSpeed)
}

; 1画面 スクロールスピードモードに切り替えます。
ChangePageScrollSpeedMode() {
    currentSpeed := env.mouse.state.scroll.speed
    pageName := env.mouse.const.scroll.speed.page.name

    if (currentSpeed = pageName) {
        return
    }

    speed := pageName
    verticalSpeed := env.mouse.const.scroll.speed.page.vertical
    horizontalSpeed := env.mouse.const.scroll.speed.page.horizontal

    env.mouse.state.scroll.speed := speed

    SetWheelScrollLines(verticalSpeed)
    SetWheelScrollChars(horizontalSpeed)
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
