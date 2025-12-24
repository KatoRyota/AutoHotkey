#Requires AutoHotkey v2.0

;---------------------------------------
; Google 翻訳を起動 or アクティブ化します。
;---------------------------------------
OpenOrActivateGoogleTranslate() {
    appTitle := "Google 翻訳"

    if WinExist(appTitle) {
        WinRestore appTitle
        WinActivate appTitle
        WinWaitActive appTitle, , 0.2
    } else {
        Run(
            '"C:\Program Files (x86)\Microsoft\Edge\Application\msedge_proxy.exe"  --profile-directory=Default --app-id=jbehbkkghblhlmbljeonakfkfbbhnlfc --app-url=https://translate.google.co.jp/?lfhs=2 --app-launch-source=4'
        )
    }
}
;---------------------------------------
; Microsoft Translatorを起動 or アクティブ化します。
;---------------------------------------
OpenOrActivateMicrosoftTranslator() {
    appTitle := "Microsoft Translator"

    if WinExist(appTitle) {
        WinRestore appTitle
        WinActivate appTitle
        WinWaitActive appTitle, , 0.2
    } else {
        Run(
            '"C:\Program Files (x86)\Microsoft\Edge\Application\msedge_proxy.exe"  --profile-directory=Default --app-id=aeejedckdleblfbgjfbidhjhhncdoajn --app-url=https://www.bing.com/translator?setlang=ja --app-launch-source=4'
        )
    }
}
;---------------------------------------
; DeepL翻訳を起動 or アクティブ化します。
;---------------------------------------
OpenOrActivateDeepLTranslate() {
    appTitle := "DeepL翻訳"

    if WinExist(appTitle) {
        WinRestore appTitle
        WinActivate appTitle
        WinWaitActive appTitle, , 0.2
    } else {
        Run(
            '"C:\Program Files (x86)\Microsoft\Edge\Application\msedge_proxy.exe"  --profile-directory=Default --app-id=pcipcojnkjooagbokhkaoeiknmdjidjf --app-url=https://www.deepl.com/ja/translator --app-launch-source=4'
        )
    }
}
