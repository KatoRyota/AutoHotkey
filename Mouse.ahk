#Requires AutoHotkey v2.0
/**
 * マウス操作関連の関数群
 */

/**
 * マウスの設定をリセットします。
 * 
 * @param env 環境情報オブジェクト
 */
ResetMouseSettings(env) {
    ChangeDefaultMouseSpeedMode(env)
    ChangeVerticalScrollDirectionMode(env)
    ChangeDefaultScrollSpeedMode(env)
}

/**
 * ウィンドウのタブを閉じます。
 */
CloseTab() {
    if (WinActive("ahk_exe Code.exe")) {
        Send("^{F4}")
    } else {
        Send("^w")
    }
}

/**
 * {WheelUp}／{WheelLeft} を送信します。
 * 
 * @param env 環境情報オブジェクト
 */
WheelUpOrLeft(env) {
    direction := env.mouse.state.scroll.direction.name
    horizontalDirection := env.mouse.const.scroll.direction.horizontal.name

    if (direction = horizontalDirection) {
        Send("{WheelLeft}")
    } else {
        Send("{WheelUp}")
    }
}

/**
 * {WheelDown}／{WheelRight} を送信します。
 * 
 * @param env 環境情報オブジェクト
 */
WheelDownOrRight(env) {
    direction := env.mouse.state.scroll.direction.name
    horizontalDirection := env.mouse.const.scroll.direction.horizontal.name

    if (direction = horizontalDirection) {
        Send("{WheelRight}")
    } else {
        Send("{WheelDown}")
    }
}

/**
 * 垂直 スクロール方向モードに切り替えます。
 * 
 * @param env 環境情報オブジェクト
 */
ChangeVerticalScrollDirectionMode(env) {
    direction := env.mouse.const.scroll.direction.vertical.name
    env.mouse.state.scroll.direction.name := direction
}

/**
 * 水平 スクロール方向モードに切り替えます。
 * 
 * @param env 環境情報オブジェクト
 */
ChangeHorizontalScrollDirectionMode(env) {
    direction := env.mouse.const.scroll.direction.horizontal.name
    env.mouse.state.scroll.direction.name := direction
}

/**
 * デフォルト マウススピードモードに切り替えます。
 * 
 * @param env 環境情報オブジェクト
 */
ChangeDefaultMouseSpeedMode(env) {
    currentSpeed := env.mouse.state.pointer.speed.name
    defaultName := env.mouse.const.pointer.speed.default.name

    if (currentSpeed = defaultName) {
        return
    }

    speedValue := env.mouse.const.pointer.speed.default.value
    env.mouse.state.pointer.speed.name := defaultName

    SetMouseSpeed(speedValue)
}

/**
 * スロウ マウススピードモードに切り替えます。
 * 
 * @param env 環境情報オブジェクト
 */
ChangeSlowMouseSpeedMode(env) {
    currentSpeed := env.mouse.state.pointer.speed.name
    slowName := env.mouse.const.pointer.speed.slow.name

    if (currentSpeed = slowName) {
        return
    }

    speedValue := env.mouse.const.pointer.speed.slow.value
    env.mouse.state.pointer.speed.name := slowName

    SetMouseSpeed(speedValue)
}

/**
 * デフォルト スクロールスピードモードに切り替えます。
 * 
 * @param env 環境情報オブジェクト
 */
ChangeDefaultScrollSpeedMode(env) {
    currentSpeed := env.mouse.state.scroll.speed.name
    defaultName := env.mouse.const.scroll.speed.default.name

    if (currentSpeed = defaultName) {
        return
    }

    speed := defaultName
    verticalSpeed := env.mouse.const.scroll.speed.default.vertical
    horizontalSpeed := env.mouse.const.scroll.speed.default.horizontal

    env.mouse.state.scroll.speed.name := speed

    SetWheelScrollLines(verticalSpeed)
    SetWheelScrollChars(horizontalSpeed)
}

/**
 * 1画面 スクロールスピードモードに切り替えます。
 * 
 * @param env 環境情報オブジェクト
 */
ChangePageScrollSpeedMode(env) {
    currentSpeed := env.mouse.state.scroll.speed.name
    pageName := env.mouse.const.scroll.speed.page.name

    if (currentSpeed = pageName) {
        return
    }

    speed := pageName
    verticalSpeed := env.mouse.const.scroll.speed.page.vertical
    horizontalSpeed := env.mouse.const.scroll.speed.page.horizontal

    env.mouse.state.scroll.speed.name := speed

    SetWheelScrollLines(verticalSpeed)
    SetWheelScrollChars(horizontalSpeed)
}

/**
 * マウススピードを取得します。
 * 
 * @returns {Number} マウススピード (1〜20)
 */
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

/**
 * マウススピードを変更します。
 * 
 * @param mouseSpeed マウススピード (1〜20)
 */
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

/**
 * 垂直スクロールの行数を取得します。
 * 
 * @returns {Number} 垂直スクロールの行数
 */
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

/**
 * 垂直スクロールの行数を変更します。
 * 
 * @param wheelScrollLines 垂直スクロールの行数
 */
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

/**
 * 水平スクロールの文字数を取得します。
 * 
 * @returns {Number} 水平スクロールの文字数
 */
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

/**
 * 水平スクロールの文字数を変更します。
 * 
 * @param wheelScrollChars 水平スクロールの文字数
 */
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
