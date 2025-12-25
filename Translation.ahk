#Requires AutoHotkey v2.0
/**
 * @deprecated 翻訳関連の関数群
 */

/**
 * クリップボードの内容を翻訳し、翻訳結果を新しいウィンドウに表示します。
 * 
 * @param appPath Microsoft Edgeの実行ファイルのパス 例) C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe
 * @param url 翻訳サービスのURL 例) https://translate.google.com/?sl=en&tl=ja&text={1}&op=translate
 * @param title 翻訳サービスのウィンドウ タイトル 例) Google 翻訳
 */
Translate(appPath, url, title) {

    if (!ClipWait(2)) {
        MsgBox("クリップボードが空の為、翻訳できません。")
        return
    }

    text := UrlEncode(A_Clipboard)
    formattedUrl := Format(url, text)
    launchedApp := Format("`"{1}`" --app=`"{2}`" --disable-extensions --disable-plugins --disable-dev-tools", appPath,
        formattedUrl)

    WinGetPos(&activeX, &activeY, &activeW, &activeH, "A")

    try {
        WinClose(title)
    } catch as e {
        ; 何もしない。ウィンドウが存在しない場合、エラーが発生するが、初期化処理の為、問題なし。
    }

    try {
        Run(launchedApp, , "Hide", &outputVarPID)
    } catch as e {
        ; 何もしない。アプリの起動に失敗した場合、即座に処理終了。
        return
    }

    WinWait(title)
    WinGetPos(, , &newW, &newH, title)

    x := activeX + Floor((activeW - newW) / 2)
    y := activeY + Floor((activeH - newH) / 2)

    WinMove(x, y, newW, newH, title)
}

/**
 * URLエンコードを行います。
 * 
 * @param str 
 */
UrlEncode(str) {
    byteLen := StrPut(str, "UTF-8") - 1
    buf := Buffer(byteLen)
    StrPut(str, buf, "UTF-8")

    out := ""
    loop byteLen {
        ch := NumGet(buf, A_Index - 1, "UChar")
        if ((ch >= 0x30 && ch <= 0x39)    ; 0-9
        || (ch >= 0x41 && ch <= 0x5A)    ; A-Z
        || (ch >= 0x61 && ch <= 0x7A)    ; a-z
        || ch = 45 || ch = 46 || ch = 95 || ch = 126) { ; - . _ ~
            out .= Chr(ch)
        } else {
            out .= "%" . Format("{:02X}", ch)
        }
    }
    return out
}
