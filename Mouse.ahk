#Requires AutoHotkey v2.0
/**
 * マウス操作関連の関数群
 */

/**
 * マウスの設定をリセットします。
 * 
 * @param {Object} env 環境情報オブジェクト
 */
ResetMouseSettings(env) {
    ChangeDefaultMouseSpeedMode(env)
    ChangeVerticalScrollDirectionMode(env)
    ChangeDefaultScrollSpeedMode(env)
}

/**
 * 水平 スクロール方向モードかどうかを判定します。
 * 
 * @param {Object} env 環境情報オブジェクト
 * @returns {Integer} 水平 スクロール方向モードの場合は true、そうでない場合は false
 */
IsHorizontalScrolling(env) {
    return env.mouse.scroll.direction.horizontal
}

/**
 * 垂直 スクロール方向モードに切り替えます。
 * 
 * @param {Object} env 環境情報オブジェクト
 */
ChangeVerticalScrollDirectionMode(env) {
    env.mouse.scroll.direction.horizontal := false
}

/**
 * 水平 スクロール方向モードに切り替えます。
 * 
 * @param {Object} env 環境情報オブジェクト
 */
ChangeHorizontalScrollDirectionMode(env) {
    env.mouse.scroll.direction.horizontal := true
}

/**
 * デフォルト マウススピードモードに切り替えます。
 * 
 * @param {Object} env 環境情報オブジェクト
 */
ChangeDefaultMouseSpeedMode(env) {
    speed := env.mouse.pointer.speed.default

    if (GetMouseSpeed() != speed) {
        SetMouseSpeed(speed)
    }
}

/**
 * スロウ マウススピードモードに切り替えます。
 * 
 * @param {Object} env 環境情報オブジェクト
 */
ChangeSlowMouseSpeedMode(env) {
    speed := env.mouse.pointer.speed.slow

    if (GetMouseSpeed() != speed) {
        SetMouseSpeed(speed)
    }
}

/**
 * デフォルト スクロールスピードモードに切り替えます。
 * 
 * @param {Object} env 環境情報オブジェクト
 */
ChangeDefaultScrollSpeedMode(env) {
    lines := env.mouse.scroll.speed.default.vertical

    if (GetWheelScrollLines() != lines) {
        SetWheelScrollLines(lines)
    }

    chars := env.mouse.scroll.speed.default.horizontal

    if (GetWheelScrollChars() != chars) {
        SetWheelScrollChars(chars)
    }
}

/**
 * 1画面 スクロールスピードモードに切り替えます。
 * 
 * @param {Object} env 環境情報オブジェクト
 */
ChangePageScrollSpeedMode(env) {
    lines := env.mouse.scroll.speed.page.vertical

    if (GetWheelScrollLines() != lines) {
        SetWheelScrollLines(lines)
    }

    chars := env.mouse.scroll.speed.page.horizontal

    if (GetWheelScrollChars() != chars) {
        SetWheelScrollChars(chars)
    }
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
 * @param {Number} mouseSpeed マウススピード (1〜20)
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
 * @param {Number} wheelScrollLines 垂直スクロールの行数
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
 * @param {Number} wheelScrollChars 水平スクロールの文字数
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