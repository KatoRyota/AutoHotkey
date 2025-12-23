#Requires AutoHotkey v2.0

; マウススピードを取得します。
GetMouseSpeed() {
    spiGetmousespeed := 0x0070
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
    spiSetmousespeed := 0x0071
    spifUpdateinifile := 0x0001
    spifSendchange := 0x0002

    DllCall("SystemParametersInfo",
        "UInt", spiSetmousespeed,
        "UInt", 0,
        "UInt", mouseSpeed,
        "UInt", spifUpdateinifile | spifSendchange)
}

; 垂直スクロールの行数を取得します。
GetWheelScrollLines() {
    spiGetwheelscrolllines := 0x0068
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
    spiSetwheelscrolllines := 0x0069
    spifUpdateinifile := 0x0001
    spifSendchange := 0x0002

    DllCall("SystemParametersInfo",
        "UInt", spiSetwheelscrolllines,
        "UInt", wheelScrollLines,
        "UInt", 0,
        "UInt", spifUpdateinifile | spifSendchange)
}

; 水平スクロールの文字数を取得します。
GetWheelScrollChars() {
    spiGetwheelscrollchars := 0x006C
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
    spiSetwheelscrollchars := 0x006D
    spifUpdateinifile := 0x0001
    spifSendchange := 0x0002

    DllCall("SystemParametersInfo",
        "UInt", spiSetwheelscrollchars,
        "UInt", wheelScrollChars,
        "UInt", 0,
        "UInt", spifUpdateinifile | spifSendchange)
}
