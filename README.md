# AutoHotkey キーバインド & ユーティリティ集

このリポジトリは、AutoHotkey v2.0 用のキーバインド設定・IME制御・マウス操作・翻訳ツール起動など、日常作業を効率化するためのスクリプト集です。

## 特徴

- **CapsLock/Spaceの修飾キー化**  
  [CoreKeyBindings.ahk](CoreKeyBindings.ahk) でCapsLockやSpaceを修飾キーとして活用。
- **カスタムキーバインド**  
  [CustomKeyBindings.ahk](CustomKeyBindings.ahk) でIME切替や翻訳ツール起動など独自ショートカットを多数定義。
- **マウス・スクロール制御**  
  [Mouse.ahk](Mouse.ahk) と [Environment.ahk](Environment.ahk) でマウス速度やスクロール方向・速度を柔軟に切替。
- **IME制御**  
  [IME.ahk](IME.ahk)・[IMEv2.ahk](IMEv2.ahk) でIMEのON/OFFや入力モード切替を簡単に実現。
- **翻訳ツールの即時起動**  
  [Translation.ahk](Translation.ahk) でGoogle翻訳、Microsoft Translator、DeepLをショートカットで起動。
- **環境情報のGUI表示**  
  [Utility.ahk](Utility.ahk) で現在のマウス・スクロール設定をGUIで確認可能。

## ファイル構成

- [CoreKeyBindings.ahk](CoreKeyBindings.ahk) … 基本キーバインド定義
- [CustomKeyBindings.ahk](CustomKeyBindings.ahk) … カスタムキーバインド定義
- [Environment.ahk](Environment.ahk) … 環境情報管理
- [IME.ahk](IME.ahk) / [IMEv2.ahk](IMEv2.ahk) … IME制御
- [KeyBindings.ahk](KeyBindings.ahk) … メインスクリプト
- [Mouse.ahk](Mouse.ahk) … マウス・スクロール制御
- [Translation.ahk](Translation.ahk) … 翻訳ツール起動
- [Utility.ahk](Utility.ahk) … 環境情報表示

## 使い方

1. [AutoHotkey v2.0](https://www.autohotkey.com/) をインストール
2. このリポジトリをクローンまたはダウンロード
3. `KeyBindings.ahk` を実行

## 主なショートカット例

| キー操作  | 機能                     |
| --------- | ------------------------ |
| Space & f | IME 半英数オン           |
| Space & j | IME ひらがなオン         |
| Space & k | IME 全英数オン           |
| ^#s       | 環境情報GUI表示          |
| Space & z | Microsoft Translator起動 |
| Space & x | Google翻訳起動           |
| Space & c | DeepL翻訳起動            |
| XButton1  | マウス設定リセット       |
| XButton2  | 水平スクロール切替       |
| ^XButton2 | マウススピード低速       |
| +XButton2 | 1画面スクロール          |

## ライセンス

各ファイルの先頭コメントを参照してください。

---

AutoHotkeyスクリプトの詳細やカスタマイズ方法は、[各スクリプトファイル](CoreKeyBindings.ahk)のコメントを参照してください。
