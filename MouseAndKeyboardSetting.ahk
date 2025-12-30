#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
#UseHook
#Include Environment.ahk
#Include IME.ahk
#Include Mouse.ahk
#Include Translation-v2.ahk
#Include Information.ahk
#Include CoreKeyBindings.ahk
#Include CustomKeyBindings.ahk
/**
 * マウスとキーボードの設定を行うスクリプト
 * 
 * ソースコードは、以下のGitHubリポジトリで管理してます。
 * https://github.com/KatoRyota/AutoHotkey
 */

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
