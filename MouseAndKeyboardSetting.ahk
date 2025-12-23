#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#InputLevel 100
#UseHook
#Include IME.ahk
#Include Mouse.ahk
#Include Translation.ahk
#Include Information.ahk

; ソースコードは、以下のGitHubリポジトリで管理してます。
; https://github.com/KatoRyota/AutoHotkey

ProcessSetPriority("AboveNormal")
InstallKeybdHook()
InstallMouseHook()
SendMode("Input")
SendLevel(100)
OnExit(ExitFunc)

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
        func: (*) => ShowHotkeys(env),
        desc: "ホットキー一覧を表示します。"
    },
    {
        key: "^#s",
        func: (*) => ShowEnvironment(env),
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
        key: "Space & f",
        func: (*) => ImeOnHanEisu(),
        desc: "IMEをオンにします（半英数）"
    },
    {
        key: "Space & j",
        func: (*) => ImeOnHiragana(),
        desc: "IMEをオンにします（ひらがな）"
    },
    {
        key: "Space & k",
        func: (*) => ImeOnZenEisu(),
        desc: "IMEをオンにします（全英数）"
    },
    {
        key: "Space & q",
        func: (*) => ResetMouseSettings(env),
        desc: "マウスの設定をリセットします。"
    },
    {
        key: "Space & w",
        func: (*) => ChangeHorizontalScrollDirectionMode(env),
        desc: "水平 スクロール方向モードに切り替えます。"
    },
    {
        key: "Space & e",
        func: (*) => ChangeSlowMouseSpeedMode(env),
        desc: "スロウ マウススピードモードに切り替えます。"
    },
    {
        key: "Space & r",
        func: (*) => ChangePageScrollSpeedMode(env),
        desc: "1画面 スクロールスピードモードに切り替えます。"
    },
    {
        key: "Space & a",
        func: (*) => Send("^{F4}"),
        desc: "<<Ctrl+F4>>キーを送信します。"
    },
    {
        key: "Space & z",
        func: (*) => Translate(env.translation.const.bing.appPath, env.translation.const.bing.url, env.translation.const
            .bing.title),
        desc: "クリップボードの内容を翻訳します。Microsoft Translator"
    },
    {
        key: "Space & x",
        func: (*) => Translate(env.translation.const.google.appPath, env.translation.const.google.url, env.translation.const
            .google.title),
        desc: "クリップボードの内容を翻訳します。Google 翻訳"
    },
    {
        key: "Space & c",
        func: (*) => Translate(env.translation.const.deepl.appPath, env.translation.const.deepl.url, env.translation.const
            .deepl.title),
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
        func: (*) => WheelUpOrLeft(env),
        desc: "<<WheelUp>>／<<WheelLeft>>キーを送信します。"
    },
    {
        key: "WheelDown",
        func: (*) => WheelDownOrRight(env),
        desc: "<<WheelDown>>／<<WheelRight>>キーを送信します。"
    },
    {
        key: "XButton1",
        func: (*) => ResetMouseSettings(env),
        desc: "マウスの設定をリセットします。"
    },
    {
        key: "XButton2",
        func: (*) => ChangeHorizontalScrollDirectionMode(env),
        desc: "水平 スクロール方向モードに切り替えます。"
    },
    {
        key: "^XButton1",
        func: (*) => ResetMouseSettings(env),
        desc: "マウスの設定をリセットします。"
    },
    {
        key: "^XButton2",
        func: (*) => ChangeSlowMouseSpeedMode(env),
        desc: "スロウ マウススピードモードに切り替えます。"
    },
    {
        key: "+XButton1",
        func: (*) => ResetMouseSettings(env),
        desc: "マウスの設定をリセットします。"
    },
    {
        key: "+XButton2",
        func: (*) => ChangePageScrollSpeedMode(env),
        desc: "1画面 スクロールスピードモードに切り替えます。"
    },
    {
        key: "^+XButton1",
        func: (*) => ResetMouseSettings(env),
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

; スクリプトの終了処理を行います。
ExitFunc(exitReason, exitCode) {
    ResetMouseSettings(env)
}

; ホットキーを登録します。
RegisterHotkeys() {
    for (i in hotkeys) {
        Hotkey(i.key, i.func)
    }
}

RegisterHotkeys()