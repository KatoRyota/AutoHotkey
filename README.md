# AutoHotkey Keybindings & Utility Scripts

## 概要

本リポジトリは、Windows環境での作業効率を向上させるためのAutoHotkey v2.0用キーバインド・ユーティリティスクリプト集です。  
CapsLockやSpaceキーの修飾キー化、IME操作、マウス・スクロール制御、翻訳アプリの起動など、多彩な機能を提供します。

## 主な機能

- **CapsLock/Spaceの修飾キー化**  
  誤操作防止やキー割り当ての拡張。
- **IME操作**  
  ショートカットでIMEのオン/オフや入力モード（半英数・ひらがな・全英数）を切替。
- **マウス・スクロール制御**  
  スクロール方向・スピードの動的切替、マウススピードの変更。
- **翻訳アプリの起動**  
  Google翻訳、Microsoft Translator、DeepL翻訳をショートカットで起動・アクティブ化。
- **環境情報の表示**  
  マウスやスクロールの設定値をGUIで表示。
- **タブ操作**  
  Ctrl+Wなどでタブを閉じる、PgDn/PgUpでタブ移動。

## ファイル構成

- [`KeyBindings.ahk`](KeyBindings.ahk)  
  メインスクリプト。各種設定・キーバインドのエントリーポイント。
- [`CoreKeyBindings.ahk`](CoreKeyBindings.ahk)  
  基本的なキーバインド定義。
- [`CustomKeyBindings.ahk`](CustomKeyBindings.ahk)  
  ユーザー独自のキーバインド定義。
- [`Environment.ahk`](Environment.ahk)  
  環境情報（マウス・ポップアップ等）の管理。
- [`IME.ahk`](IME.ahk), [`IMEv2.ahk`](IMEv2.ahk)  
  IME制御用関数群。
- [`Mouse.ahk`](Mouse.ahk)  
  マウス・スクロール制御関数群。
- [`Translation.ahk`](Translation.ahk)  
  翻訳アプリ起動用関数群。
- [`Utility.ahk`](Utility.ahk)  
  補助的なユーティリティ関数群。

## 使い方

1. [AutoHotkey v2.0](https://www.autohotkey.com/) をインストールしてください。
2. このリポジトリを任意のフォルダにクローンまたはダウンロードします。
3. `KeyBindings.ahk` をダブルクリック、またはAutoHotkeyで実行してください。

## 主なショートカット例

| キー操作      | 機能                     |
| ------------- | ------------------------ |
| Space & f     | IMEオン（半英数）        |
| Space & j     | IMEオン（ひらがな）      |
| Space & k     | IMEオン（全英数）        |
| ^#s           | 環境情報を表示           |
| Space & z     | Microsoft Translator起動 |
| Space & x     | Google翻訳起動           |
| Space & c     | DeepL翻訳起動            |
| ^w            | タブを閉じる             |
| ^PgDn / ^PgUp | タブ移動                 |
| XButton1      | マウス設定リセット       |
| XButton2      | 水平スクロールモード切替 |
| ^XButton2     | マウススピード低速化     |
| +XButton2     | 1画面スクロールモード    |

## 注意事項

- 一部の機能はWindowsの設定やアプリケーションによって動作が異なる場合があります。
- IME制御やマウス設定変更はシステム全体に影響するため、自己責任でご利用ください。

## ライセンス

各スクリプトファイルの先頭コメントをご参照ください。

---

ご質問・要望は[Issues](https://github.com/KatoRyota/AutoHotkey/issues)までどうぞ。
