# MouseAndKeyboardSetting.ahk

AutoHotkey v2 用のマウス・キーボード設定スクリプトです。  
マウス速度やスクロール方向・速度の切り替え、クリップボード翻訳、拡張キー送信などをホットキーで素早く実行できます。

## 特徴

- **マウス設定の即時切り替え**
  - ポインタ速度（デフォルト／スロウ）
  - スクロール方向（垂直／水平）
  - スクロール速度（デフォルト／スロウ／高速／1ページ）
- **翻訳機能**
  - クリップボードのテキストを Bing / Google / DeepL で翻訳
  - Microsoft Edge のアプリモードで起動
- **ホットキー一覧表示**
  - GUI で現在のホットキーと説明を一覧表示
- **環境情報表示**
  - 現在のマウス速度やスクロール設定を GUI 表示
- **拡張キー送信**
  - F13〜F24 や Shift/Alt/Ctrl/Win 修飾付きキー送信
- **マウスボタン拡張**
  - XButton1 / XButton2 に多機能割り当て

## 必要環境

- Windows 10 / 11
- [AutoHotkey v2](https://www.autohotkey.com/)  
- Microsoft Edge（翻訳機能利用時）

## インストール

1. AutoHotkey v2 をインストール
2. 本リポジトリをクローンまたは ZIP ダウンロード
3. `MouseAndKeyboardSetting.ahk` をダブルクリックで実行

## 主なホットキー

| ホットキー | 説明 |
|-----------|------|
| `Ctrl + Win + H` | ホットキー一覧を表示 |
| `Ctrl + Win + S` | 環境情報を表示 |
| `F1 & X` | Bing 翻訳でクリップボードを翻訳 |
| `F1 & C` | Google 翻訳でクリップボードを翻訳 |
| `F1 & V` | DeepL 翻訳でクリップボードを翻訳 |
| `F1 & A` | マウス設定をリセット |
| `F1 & S` | 水平スクロール方向モードに切替 |
| `F1 & D` | スロウマウススピードモードに切替 |
| `F1 & F` | 1ページスクロールスピードモードに切替 |
| `XButton1` | マウス設定をリセット |
| `XButton2` | 水平スクロール方向モードに切替 |
| `Ctrl + XButton2` | スロウマウススピードモードに切替 |
| `Shift + XButton2` | 1ページスクロールスピードモードに切替 |

※ その他、F13〜F24 や修飾キー付きの送信ホットキー多数あり。詳細は `Ctrl + Win + H` で確認可能。

## 関数概要

- `ShowHotkeys()` — ホットキー一覧を GUI 表示
- `ShowEnvironment()` — マウス速度・スクロール設定を GUI 表示
- `ResetMouseSettings()` — マウス設定をデフォルトに戻す
- `Change*Mode()` — 各種モード切替（速度・方向）
- `Translate(appPath, url, title)` — クリップボード翻訳
- `UrlEncode(str)` — URL エンコード処理

## ライセンス

MIT License

---

© 2025 Ryota Kato
