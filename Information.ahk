#Requires AutoHotkey v2.0
#Include Mouse.ahk
/**
 * 環境情報 表示関連の関数群
 */

/**
 * スクリプト内で登録された、ホットキーの一覧を表示します。
 * 
 * @param env 環境情報オブジェクト
 * @param hotkeys スクリプト内で登録された、ホットキーのリスト
 */
ShowHotkeys(env, hotkeys) {
    oldPopup := env.popup.state.hotkeys
    listViewWidth := env.popup.const.hotkeys.listView.width
    listViewHeight := env.popup.const.hotkeys.listView.height

    try {
        oldPopup.Destroy()
    } catch as e {
        ; 何もしない。ポップアップが存在しない場合、エラーが発生するが、初期化処理の為、問題なし。
    }

    popup := Gui("", "ホットキー一覧")
    env.popup.state.hotkeys := popup
    popup.Opt("+AlwaysOnTop -DPIScale")
    popup.SetFont("s12 q5", "Meiryo UI")

    listViewOptions := Format("NoSort Grid ReadOnly w{1} h{2}", listViewWidth, listViewHeight)
    listView := popup.Add("ListView", listViewOptions, [
        "ホットキー",
        "説明"
    ])

    for (i in hotkeys) {
        listView.Add("", i.key, i.desc)
    }

    listView.ModifyCol()

    popup.Add("Button", "Default", "閉じる").OnEvent("Click", (*) => popup.Destroy())
    popup.OnEvent("Close", (*) => popup.Destroy())
    popup.OnEvent("Escape", (*) => popup.Destroy())

    WinGetPos(&wx, &wy, &ww, &wh, "A")

    popup.Show("AutoSize Hide")
    popup.GetPos(, , &gw, &gh)

    x := wx + Floor((ww - gw) / 2)
    y := wy + Floor((wh - gh) / 2)

    popupOptions := Format("x{1} y{2}", x, y)

    popup.Show(popupOptions)
}

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
    popup.Opt("+AlwaysOnTop -DPIScale")
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

    WinGetPos(&wx, &wy, &ww, &wh, "A")

    popup.Show("AutoSize Hide")
    popup.GetPos(, , &gw, &gh)

    x := wx + Floor((ww - gw) / 2)
    y := wy + Floor((wh - gh) / 2)

    popupOptions := Format("x{1} y{2}", x, y)

    popup.Show(popupOptions)
}
