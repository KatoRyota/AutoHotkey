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
                    default: {
                        name: "default",
                        value: GetMouseSpeed()
                    },
                    slow: {
                        name: "slow",
                        value: 1
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
                    default: {
                        name: "default",
                        vertical: GetWheelScrollLines(),
                        horizontal: GetWheelScrollChars()
                    },
                    page: {
                        name: "page",
                        vertical: 0xFFFFFFFF,
                        horizontal: GetWheelScrollChars() * 6
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