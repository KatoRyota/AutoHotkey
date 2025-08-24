# MouseAndKeyboardSetting.ahk

Windows 環境でのマウス・キーボード操作を効率化する **AutoHotkey v2** スクリプトです。  
マウス速度やスクロール方向・速度の切り替え、拡張キー送信、クリップボード翻訳など、多彩なホットキーを提供します。

## 特徴

- 🖱 **マウス設定の即時切替**
  - デフォルト／スロウ速度
  - 垂直／水平スクロール方向
  - デフォルト／高速／低速／1画面スクロール速度
- ⌨ **豊富なキー送信機能**
  - F13〜F24、Shift+F13〜F24、Ctrl/Alt/Win 組み合わせ
  - ページ移動（PgUp/PgDn）、Home/End など
- 🌐 **クリップボード翻訳**
  - Bing 翻訳（Edge PWA）を新規ウィンドウで起動
- 📋 **ホットキー一覧・環境情報のGUI表示**
  - 一覧表示ウィンドウは中央にポップアップ

## 動作環境

- **OS**: Windows 10 / 11
- **必須**: [AutoHotkey v2](https://www.autohotkey.com/)
- **ブラウザ**: Microsoft Edge（Bing 翻訳機能用）

## インストール

1. [AutoHotkey v2](https://www.autohotkey.com/) をインストール
2. 本リポジトリをクローンまたは ZIP ダウンロード
3. `MouseAndKeyboardSetting.ahk` をダブルクリックで実行

## 主なホットキー

| ホットキー | 説明 |
|-----------|------|
| `^#h` | ホットキー一覧を表示 |
| `^#s` | 環境情報を表示 |
| `F1 & x` | クリップボードを翻訳（Bing 翻訳） |
| `F1 & a` / `sc029` / `XButton1` | マウス設定をリセット |
| `F1 & s` / `XButton2` | 水平スクロール方向に切替 |
| `F1 & d` / `^XButton2` | スロウマウス速度に切替 |
| `F1 & f` / `+XButton2` | 1画面スクロール速度に切替 |
| `WheelUp` / `WheelDown` | 垂直／水平スクロール送信（方向モードに応じて） |
| `F2 & z`〜`F2 & r` | F13〜F24キー送信 |
| `F2 & m`〜`F2 & 8` | Shift+F13〜Shift+F2キー送信 |
| `!XButton1` / `!XButton2` | Home / End キー送信 |
| `#XButton1` / `#XButton2` | PgUp / PgDn キー送信 |

※ 詳細はスクリプト内の `hotkeys` 配列を参照してください。

## 関数概要

- **ShowHotkeys()** — 登録ホットキー一覧をGUI表示
- **ShowEnvironment()** — 現在のマウス設定をGUI表示
- **ResetMouseSettings()** — マウス速度・スクロール方向・速度をデフォルトに戻す
- **Change*/Toggle*** 系 — 各種モード切替（速度・方向）
- **Translate()** — クリップボード文字列をURLエンコードしてBing翻訳を起動
- **UrlEncode()** — UTF-8文字列をURLエンコード
- **WheelUpOrLeft() / WheelDownOrRight()** — スクロール方向に応じた入力送信

## ライセンス

MIT License  
詳細は [LICENSE](LICENSE) ファイルを参照してください。

---

### 作者
- GitHub: [KatoRyota](https://github.com/KatoRyota/AutoHotkey)