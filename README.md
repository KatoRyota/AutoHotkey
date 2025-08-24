
# MouseAndKeyboardSetting.ahk

AutoHotkey v2 で作成した、マウスとキーボードの操作環境を効率的に切り替えるためのスクリプトです。  
マウス速度・スクロール方向・スクロール速度の変更や、各種キー送信、翻訳機能などをホットキーで素早く実行できます。

## 特徴 ✨

- **マウス設定の即時切り替え**
  - デフォルト／スロウ速度
  - 垂直／水平スクロール方向
  - デフォルト／高速／低速／1画面スクロール
- **豊富なホットキー**
  - F1/F2キーとの組み合わせで特殊キー送信（F13〜F24、Shift+Fxx など）
  - マウスのサイドボタンやホイール操作に機能割り当て
- **翻訳機能**
  - クリップボードのテキストを Bing 翻訳（Edge PWA）で即表示
- **GUI表示**
  - 登録済みホットキー一覧
  - 現在のマウス・スクロール設定

## 必要環境 🖥

- Windows 10 / 11
- [AutoHotkey v2](https://www.autohotkey.com/)  
- Microsoft Edge（Bing 翻訳機能を利用する場合）

## インストール方法 📦

1. [AutoHotkey v2](https://www.autohotkey.com/) をインストール
2. 本スクリプト `MouseAndKeyboardSetting.ahk` を任意のフォルダに配置
3. ダブルクリックで実行（常駐）

## 主なホットキー一覧 ⌨️

| ホットキー | 説明 |
|-----------|------|
| `^#h` | ホットキー一覧を表示 |
| `^#s` | 環境情報を表示 |
| `F1 & x` | クリップボードを翻訳 |
| `F1 & a` | マウス設定をリセット |
| `F1 & s` | 水平スクロール方向に切替 |
| `F1 & d` | スロウマウス速度に切替 |
| `F1 & f` | 1画面スクロール速度に切替 |
| `XButton1` | マウス設定をリセット |
| `XButton2` | 水平スクロール方向に切替 |
| `^XButton2` | スロウマウス速度に切替 |
| `+XButton2` | 1画面スクロール速度に切替 |

※ その他、F2キーとの組み合わせで F13〜F24 や Shift+Fxx の送信が可能です。

## 関数概要 🛠

- `ResetMouseSettings()`  
  マウス速度・スクロール方向・スクロール速度をデフォルトに戻す
- `ChangeSlowMouseSpeedMode()`  
  マウス速度を低速に変更
- `ChangePageScrollSpeedMode()`  
  1画面スクロールに変更
- `Translate()`  
  クリップボードのテキストを Bing 翻訳で開く
- `ShowHotkeys()` / `ShowEnvironment()`  
  GUIでホットキー一覧や環境情報を表示

## ライセンス 📄

MIT License

---

### 作者
[GitHub: KatoRyota](https://github.com/KatoRyota/AutoHotkey)
