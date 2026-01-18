#Requires AutoHotkey v2.0
#Include Mouse.ahk

/**
 * @type {Object} 環境情報オブジェクト
 */
env := {
    mouse: {
        pointer: {
            speed: {
                default: GetMouseSpeed(),
                slow: 1
            }
        },
        scroll: {
            direction: {
                horizontal: false
            },
            speed: {
                default: {
                    vertical: GetWheelScrollLines(),
                    horizontal: GetWheelScrollChars()
                },
                page: {
                    vertical: 0xFFFFFFFF,
                    horizontal: GetWheelScrollChars() * 6
                }
            }
        }
    },
    popup: {
        env: {
            current: {}
        }
    }
}