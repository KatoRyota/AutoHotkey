#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#UseHook
#Include Environment.ahk
#Include Mouse.ahk
#Include Information.ahk
#Include Hotkeys.ahk
/**
 * マウスとキーボードの設定を行うスクリプト
 * 
 * ソースコードは、以下のGitHubリポジトリで管理してます。
 * https://github.com/KatoRyota/AutoHotkey
 */

SendMode("Input")
OnExit(ExitFunc)

/**
 * スクリプトの終了処理を行います。
 * 
 * @param exitReason 終了理由
 * @param exitCode 終了コード
 */
ExitFunc(exitReason, exitCode) {
    ResetMouseSettings(env)
}

/**
 * ホットキーを登録します。
 */
RegisterHotkeys() {
    for (i in hotkeys) {
        Hotkey(i.key, i.func)
    }
    Hotkey("^#h", (*) => ShowHotkeys(env, hotkeys))
}

RegisterHotkeys()