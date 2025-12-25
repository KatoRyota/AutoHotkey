#Requires AutoHotkey v2.0
/**
 * @deprecated 環境設定関連の定数・変数群
 */

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