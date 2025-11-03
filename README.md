# MouseAndKeyboardSetting

Windows 向けの AutoHotkey v2 スクリプトです。マウス速度・スクロール方向・スクロール速度の切替、クリップボード翻訳、拡張キー送信などをホットキーで操作できます。

- スクリプト本体: [MouseAndKeyboardSetting.ahk](MouseAndKeyboardSetting.ahk)

## 主な機能

- マウス設定の即時切替（ポインタ速度・スクロール方向・スクロール速度）
- クリップボード翻訳（Bing / Google / DeepL）
- ホットキー一覧・環境情報の GUI 表示
- F13〜F24 などの拡張キー送信や XButton の多機能割当

## 必要環境

- Windows 10 / 11
- [AutoHotkey v2](https://www.autohotkey.com/)
- Microsoft Edge（翻訳機能をアプリモードで起動する場合）

## インストール

1. AutoHotkey v2 をインストール
2. 本リポジトリをクローンまたは ZIP ダウンロード
3. [MouseAndKeyboardSetting.ahk](MouseAndKeyboardSetting.ahk) をダブルクリックして実行

## 使い方（主要ホットキー）

- Ctrl + Win + H: ホットキー一覧表示（[`ShowHotkeys()`](MouseAndKeyboardSetting.ahk)）
- Ctrl + Win + S: 環境情報表示（[`ShowEnvironment()`](MouseAndKeyboardSetting.ahk)）
- Space + s / d / f: クリップボード翻訳（[`Translate()`](MouseAndKeyboardSetting.ahk)）
- XButton1 / XButton2: マウス設定リセット／水平スクロール切替
- WheelUp / WheelDown: 現在のスクロール方向に合わせて左右/上下を送信（[`WheelUpOrLeft()`](MouseAndKeyboardSetting.ahk), [`WheelDownOrRight()`](MouseAndKeyboardSetting.ahk)）

詳細なホットキー一覧はスクリプト実行後に Ctrl + Win + H を押して確認してください。

## 主要関数（実装場所: [MouseAndKeyboardSetting.ahk](MouseAndKeyboardSetting.ahk)）

- [`ShowHotkeys()`](MouseAndKeyboardSetting.ahk) — ホットキー一覧を GUI 表示
- [`ShowEnvironment()`](MouseAndKeyboardSetting.ahk) — マウス・スクロール設定を GUI 表示
- [`ResetMouseSettings()`](MouseAndKeyboardSetting.ahk) — マウス設定をデフォルトに戻す
- マウス速度・スクロール切替: [`ChangeDefaultMouseSpeedMode()`](MouseAndKeyboardSetting.ahk), [`ChangeSlowMouseSpeedMode()`](MouseAndKeyboardSetting.ahk), [`ChangeDefaultScrollSpeedMode()`](MouseAndKeyboardSetting.ahk), [`ChangePageScrollSpeedMode()`](MouseAndKeyboardSetting.ahk) など
- [`Translate(appPath, url, title)`](MouseAndKeyboardSetting.ahk) — クリップボード翻訳（内部で [`UrlEncode()`](MouseAndKeyboardSetting.ahk) を利用）
- [`RegisterHotkeys()`](MouseAndKeyboardSetting.ahk) — ホットキー登録

## カスタマイズ

- 翻訳先ブラウザや URL はスクリプト上部の `env.translation.const` を編集して変更できます。
- スクロール速度やポインタ速度の値は `env.mouse.const` 内で定義済みなので必要に応じて調整してください。

## ライセンス

MIT License

© 2025 Ryota Kato
