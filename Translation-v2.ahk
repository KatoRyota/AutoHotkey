#Requires AutoHotkey v2.0

; クリップボードの内容を翻訳します。
Translate(appPath, url, title) {

    WinGetPos(&activeX, &activeY, &activeW, &activeH, "A")

    if (!ClipWait(2)) {
        MsgBox("クリップボードが空の為、翻訳できません。")
        return
    }

    text := UrlEncode(A_Clipboard)
    formattedUrl := Format(url, text)
    launchedApp := Format("`"{1}`" --new-window `"{2}`"", appPath, formattedUrl)

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
    WinMove(activeX, activeY, activeW, activeH, title)
}

; URLエンコードします。
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
