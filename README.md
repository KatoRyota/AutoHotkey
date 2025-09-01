# MouseAndKeyboardSetting.ahk

AutoHotkey v2 用のマウス・キーボード設定スクリプトです。  
マウス速度やスクロール方向・速度の切り替え、クリップボード翻訳、拡張キー送信など、多彩なホットキーを提供します。

## 特徴

- **マウス設定の即時切り替え**
  - ポインタ速度（デフォルト／スロウ）
  - スクロール方向（垂直／水平）
  - スクロール速度（デフォルト／スロウ／高速／1ページ）
- **翻訳機能**
  - クリップボードの内容を Bing 翻訳または Google 翻訳で表示
- **ホットキー一覧・環境情報のGUI表示**
- **拡張ファンクションキー（F13〜F24）や修飾キー組み合わせの送信**
- **マウスボタンやホイール操作のカスタマイズ**

## 必要環境

- Windows 10 / 11
- [AutoHotkey v2](https://www.autohotkey.com/) がインストールされていること

## インストール

1. AutoHotkey v2 をインストールします。
2. 本リポジトリをクローンまたは ZIP ダウンロードします。
3. `MouseAndKeyboardSetting.ahk` をダブルクリックして実行します。

```bash
git clone https://github.com/KatoRyota/AutoHotkey.git
cd AutoHotkey
```

## 主なホットキー

| ホットキー | 説明 |
|-----------|------|
| `Ctrl + Win + H` | ホットキー一覧を表示 |
| `Ctrl + Win + S` | 環境情報を表示 |
| `F1 & Z` | Ctrl + F4 を送信 |
| `F1 & X` | Bing 翻訳でクリップボードを翻訳 |
| `F1 & C` | Google 翻訳でクリップボードを翻訳 |
| `F1 & A` | マウス設定をリセット |
| `F1 & S` | 水平スクロール方向モードに切替 |
| `F1 & D` | スロウマウススピードモードに切替 |
| `F1 & F` | 1ページスクロールスピードモードに切替 |
| `XButton1` | マウス設定をリセット |
| `XButton2` | 水平スクロール方向モードに切替 |
| `Ctrl + XButton2` | スロウマウススピードモードに切替 |
| `Shift + XButton2` | 1ページスクロールスピードモードに切替 |
| `WheelUp` / `WheelDown` | スクロール方向に応じて上下または左右スクロール |

※ その他、F2キーとの組み合わせで F13〜F24 や Shift + F13〜F24 を送信可能です。

## 関数一覧

- `ShowHotkeys()` — ホットキー一覧GUIを表示
- `ShowEnvironment()` — 現在のマウス・スクロール設定を表示
- `ResetMouseSettings()` — マウス設定をデフォルトに戻す
- `ChangeSlowMouseSpeedMode()` / `ChangePageScrollSpeedMode()` など — 各種モード切替
- `Translate(appPath, url, title)` — クリップボード翻訳
- `WheelUpOrLeft()` / `WheelDownOrRight()` — スクロール方向に応じたホイール動作

## ライセンス

このスクリプトは [MIT License](LICENSE) のもとで公開されています。

---

### 作者
- GitHub: [KatoRyota](https://github.com/KatoRyota)
```
