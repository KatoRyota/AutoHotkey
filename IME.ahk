#Requires AutoHotkey v2.0
#Include IMEv2.ahk

ImeOnHiragana() {
    IME_SET(1)
    IME_SetConvMode(9)
}

ImeOnZenEisu() {
    IME_SET(1)
    IME_SetConvMode(8)
}

ImeOnHanEisu() {
    IME_SET(1)
    IME_SetConvMode(16)
}
