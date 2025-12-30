#Requires AutoHotkey v2.0
#Include Mouse.ahk
/**
 * 環境情報 表示関連の関数群
 */

/**
 * 環境情報を表示します。
 * 
 * @param env 環境情報オブジェクト
 */
ShowEnvironment(env) {
    scrollDirection := env.mouse.state.scroll.direction.name
    scrollSpeed := env.mouse.state.scroll.speed.name
    oldPopup := env.popup.state.env
    listViewWidth := env.popup.const.env.listView.width
    listViewHeight := env.popup.const.env.listView.height

    try {
        oldPopup.Destroy()
    } catch as e {
        ; 何もしない。ポップアップが存在しない場合、エラーが発生するが、初期化処理の為、問題なし。
    }

    popup := Gui("", "環境情報")
    env.popup.state.env := popup
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
    listView.Add("", "スクロール方向", scrollDirection)
    listView.Add("", "スクロールスピード", scrollSpeed)
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
