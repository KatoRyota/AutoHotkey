# MouseAndKeyboardSetting.ahk

AutoHotkey v2 で動作する、マウス・キーボード設定の切り替えやホットキー送信、Bing翻訳呼び出しなどをまとめた多機能スクリプトです。  
マウス速度・スクロール方向・スクロール速度の変更や、各種キー送信、環境情報表示などをホットキーで素早く実行できます。

---

## 📦 主な機能

- **マウス設定の切り替え**
  - デフォルト／スロウ速度の切り替え
  - 垂直／水平スクロール方向の切り替え
  - デフォルト／スロウ／高速／1画面スクロール速度の切り替え
  - 設定リセット機能

- **ホットキー送信**
  - F1〜F24、Shift/Ctrl/Alt/Win 修飾付きキー送信
  - Ctrl+F4、Home/End、PgUp/PgDn などの送信

- **Bing翻訳呼び出し**
  - クリップボードの内容を URL エンコードして Microsoft Edge アプリモードで Bing 翻訳を開く
  - 翻訳ウィンドウをアクティブウィンドウ中央に配置

- **情報表示**
  - 登録済みホットキー一覧表示
  - 現在のマウス設定・スクロール設定などの環境情報表示

---

## 🖥 動作環境

- **OS**: Windows 10 / 11
- **必須**: [AutoHotkey v2](https://www.autohotkey.com/)
- **推奨**: Microsoft Edge（Bing翻訳機能利用時）

---

## 🚀 使い方

1. [AutoHotkey v2](https://www.autohotkey.com/) をインストール
2. 本スクリプト `MouseAndKeyboardSetting.ahk` をダウンロード
3. ダブルクリックで実行（タスクトレイに常駐）
4. 以下のホットキーで機能を呼び出し

---

## ⌨ 主なホットキー一覧

| ホットキー | 機能 |
|-----------|------|
| `^#h` | ホットキー一覧を表示 |
| `^#s` | 環境情報を表示 |
| `F1 & x` | クリップボードを翻訳（Bing翻訳） |
| `F1 & a` | マウス設定をリセット |
| `F1 & s` | 水平スクロール方向に切り替え |
| `F1 & d` | スロウマウス速度に切り替え |
| `F1 & f` | 1画面スクロール速度に切り替え |
| `XButton1` | マウス設定をリセット |
| `XButton2` | 水平スクロール方向に切り替え |
| `^XButton2` | スロウマウス速度に切り替え |
| `+XButton2` | 1画面スクロール速度に切り替え |
| `WheelUp` / `WheelDown` | 垂直／水平スクロール送信（方向設定に依存） |

※ その他、F13〜F24や修飾キー付きの送信ホットキー多数あり。詳細は `^#h` で確認可能。

---

## 📂 ファイル構成

```
MouseAndKeyboardSetting.ahk   # メインスクリプト
```

---

## ⚙ 主な内部関数

- `ResetMouseSettings()` — マウス速度・スクロール方向・速度をデフォルトに戻す
- `ChangeSlowMouseSpeedMode()` — スロウマウス速度に変更
- `ChangePageScrollSpeedMode()` — 1画面スクロール速度に変更
- `Translate()` — クリップボードを Bing翻訳で開く
- `UrlEncode(str)` — UTF-8 URLエンコード
- `ShowHotkeys()` — ホットキー一覧GUI表示
- `ShowEnvironment()` — 環境情報GUI表示

---

## 📜 ライセンス

MIT License  
Copyright (c) 2025 Ryota Kato

---

## 🔗 リンク

- GitHub: [https://github.com/KatoRyota/AutoHotkey](https://github.com/KatoRyota/AutoHotkey)
- AutoHotkey公式: [https://www.autohotkey.com/](https://www.autohotkey.com/)
