#Requires AutoHotkey v2.0
#Include Mouse.ahk
/**
 * 環境情報
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
                    vertical: {
                        name: "vertical"
                    },
                    horizontal: {
                        name: "horizontal"
                    }
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
                speed: {
                    name: "default"
                }
            },
            scroll: {
                direction: {
                    name: "vertical"
                },
                speed: {
                    name: "default"
                }
            }
        }
    },
    popup: {
        const: {
            env: {
                listView: {
                    width: 1100,
                    height: 700
                }
            }
        },
        state: {
            env: {}
        }
    }
}