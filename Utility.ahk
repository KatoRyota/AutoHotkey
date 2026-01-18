#Requires AutoHotkey v2.0
#Include Mouse.ahk
/**
 * ユーティリティ関数群
 */

/**
 * スクリプトの終了処理を行います。
 * 
 * @param {Object} env 環境情報オブジェクト
 * @returns {ExitFunc~_ExitFunc} 
 */
ExitFunc(env) {
    /**
     * スクリプトの終了処理を行います。
     * 
     * @param {String} exitReason 終了理由
     * @param {Integer} exitCode 終了コード
     */
    _ExitFunc(exitReason, exitCode) {
        ResetMouseSettings(env)
    }
    return _ExitFunc
}

/**
 * スクリプトの実行環境の情報を表示します。
 * 
 * @param {Object} env 環境情報オブジェクト
 */
ShowEnvironment(env) {
    oldPopup := env.popup.env.current
    listViewWidth := env.popup.env.listView.width
    listViewHeight := env.popup.env.listView.height

    try {
        oldPopup.Destroy()
    } catch as e {
        ; 何もしない。ポップアップが存在しない場合、エラーが発生するが、初期化処理の為、問題なし。
    }

    popup := Gui("", "環境情報")
    env.popup.env.current := popup
    popup.Opt("+AlwaysOnTop")
    popup.SetFont("s12 q5", "Meiryo UI")

    listViewOptions := Format("NoSort Grid ReadOnly w{1} h{2}", listViewWidth, listViewHeight)
    listView := popup.Add("ListView", listViewOptions, [
        "設定項目",
        "値"
    ])

    listView.Add("", "マウススピード", GetMouseSpeed())
    listView.Add("", "垂直スクロールの行数", GetWheelScrollLines())
    listView.Add("", "水平スクロールの文字数", GetWheelScrollChars())
    listView.ModifyCol()

    popup.Add("Button", "Default", "閉じる").OnEvent("Click", (*) => popup.Destroy())
    popup.OnEvent("Close", (*) => popup.Destroy())
    popup.OnEvent("Escape", (*) => popup.Destroy())

    CoordMode("Mouse", "Screen")
    MouseGetPos(&cx, &cy)
    count := MonitorGetCount()
    loop count {
        MonitorGet(A_Index, &l, &t, &r, &b)
        if (cx >= l && cx < r && cy >= t && cy < b) {
            break
        }
    }
    popupOptions := Format("x{1} y{2}", l, t)
    popup.Show(popupOptions)
}