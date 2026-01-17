#Requires AutoHotkey v2.0
#Include IMEv2.ahk
/**
 * IME操作関連の関数群
 */

/**
 * IME 半英数モード
 */
ImeOnHanEisu() {
    if (IME_GET() != 1) {
        IME_SET(1)
    }
    if (IME_GetConvMode() != 16) {
        IME_SetConvMode(16)
    }
}

/**
 * IME ひらがなモード
 */
ImeOnHiragana() {
    if (IME_GET() != 1) {
        IME_SET(1)
    }
    if (IME_GetConvMode() != 25) {
        IME_SetConvMode(25)
    }
}

/**
 * IME 全英数モード
 */
ImeOnZenEisu() {
    if (IME_GET() != 1) {
        IME_SET(1)
    }
    if (IME_GetConvMode() != 24) {
        IME_SetConvMode(24)
    }
}