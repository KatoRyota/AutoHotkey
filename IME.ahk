#Requires AutoHotkey v2.0
#Include IMEv2.ahk
/**
 * IME操作関連の関数群
 */

/**
 * IME 半英数モード
 */
ImeOnHanEisu() {
    IME_SET(1)
    IME_SetConvMode(16)
}

/**
 * IME ひらがなモード
 */
ImeOnHiragana() {
    IME_SET(1)
    IME_SetConvMode(25)
}

/**
 * IME 全英数モード
 */
ImeOnZenEisu() {
    IME_SET(1)
    IME_SetConvMode(24)
}