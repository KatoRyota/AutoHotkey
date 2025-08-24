# MouseAndKeyboardSetting.ahk

AutoHotkey v2 用のマウス・キーボード設定管理スクリプトです。  
マウス速度やスクロール方向・速度の切り替え、各種キー送信、Bing翻訳PWAの呼び出しなどをホットキーで簡単に操作できます。

## 主な機能

- **マウス設定の切り替え**
  - デフォルト／スロウ速度モード
  - 垂直／水平スクロール方向
  - デフォルト／スロウ／高速／1ページスクロール速度
- **ホットキー送信**
  - F13〜F24、Shift+F13〜F24、Ctrl+F4 など
  - Home / End / PgUp / PgDn 系の修飾キー付き送信
- **Bing翻訳PWA呼び出し**
  - クリップボードのテキストを URL エンコードして Microsoft Edge PWA で開く
- **GUI表示**
  - 登録ホットキー一覧
  - 現在の環境設定（マウス速度・スクロール設定など）

## 動作環境

- **OS**: Windows 10 / 11
- **必須**: [AutoHotkey v2](https://www.autohotkey.com/)
- **推奨**: Microsoft Edge（Bing翻訳PWA機能を利用する場合）

## インストール

1. [AutoHotkey v2](https://www.autohotkey.com/) をインストールします。
2. 本リポジトリをクローンまたは ZIP ダウンロードします。
3. `MouseAndKeyboardSetting.ahk` をダブルクリックして実行します。

```bash
git clone https://github.com/ユーザー名/リポジトリ名.git
```

## 主なホットキー一覧

| ホットキー | 説明 |
|-----------|------|
| Ctrl + Win + H | ホットキー一覧を表示 |
| Ctrl + Win + S | 環境情報を表示 |
| F1 & X | クリップボードを翻訳（Bing翻訳PWA） |
| F1 & A | マウス設定をリセット |
| F1 & S | 水平スクロール方向に切替 |
| F1 & D | スロウマウス速度に切替 |
| F1 & F | 1ページスクロール速度に切替 |
| XButton1 | マウス設定をリセット |
| XButton2 | 水平スクロール方向に切替 |
| Ctrl + XButton2 | スロウマウス速度に切替 |
| Shift + XButton2 | 1ページスクロール速度に切替 |
| ... | その他多数（F13〜F24送信など） |

> 詳細はスクリプト内の `hotkeys` 配列を参照してください。

## 関数概要

- **ResetMouseSettings()**  
  マウス速度・スクロール方向・速度をデフォルトに戻します。
- **ChangeSlowMouseSpeedMode() / ChangeDefaultMouseSpeedMode()**  
  マウス速度を切り替えます。
- **ChangeHorizontalScrollDirectionMode() / ChangeVerticalScrollDirectionMode()**  
  スクロール方向を切り替えます。
- **ChangePageScrollSpeedMode() / ChangeSlowScrollSpeedMode() / ChangeHighScrollSpeedMode()**  
  スクロール速度を切り替えます。
- **Translate()**  
  クリップボードのテキストを Bing翻訳PWA で開きます。
- **UrlEncode(str)**  
  UTF-8 URLエンコードを行います。

## ライセンス

このスクリプトのライセンスはリポジトリの `LICENSE` ファイルを参照してください。

---

### 作者
- GitHub: [KatoRyota](https://github.com/KatoRyota)
