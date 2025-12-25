#Requires AutoHotkey v2.0
#Include IMEv2.ahk
/**
 * IME操作関連の関数群
 */

/**
 * IMEをオンにします（半英数）
 */
ImeOnHanEisu() {
    IME_SET(1)
    IME_SetConvMode(16)
}

/**
 * IMEをオンにします（ひらがな）
 */
ImeOnHiragana() {
    IME_SET(1)
    IME_SetConvMode(9)
}

/**
 * IMEをオンにします（全英数）
 */
ImeOnZenEisu() {
    IME_SET(1)
    IME_SetConvMode(8)
}
