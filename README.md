# AutoHotkey Key Bindings

## 概要

このリポジトリは、Windows環境でのキーバインド・マウス操作・IME制御・翻訳ツール起動などをカスタマイズするAutoHotkey v2.0用スクリプト集です。  
主に日本語入力や効率的なウィンドウ操作を目的としています。

## ファイル構成

- `KeyBindings.ahk`  
  メインスクリプト。各種機能・キーバインドのエントリーポイントです。
- `CoreKeyBindings.ahk`  
  CapsLockやSpaceキーの修飾キー化、F13～F24キーの割り当てなどの基本キーバインド。
- `CustomKeyBindings.ahk`  
  IME切替、翻訳ツール起動、マウス操作などのカスタムキーバインド。
- `Environment.ahk`  
  マウスやポップアップの状態など、環境情報の管理。
- `IME.ahk`  
  IMEのオン/オフや入力モード切替の関数群。
- `IMEv2.ahk`  
  IME制御の低レベル実装（外部ライブラリ）。
- `Mouse.ahk`  
  マウススピードやスクロール設定の取得・変更、リセットなど。
- `Translation.ahk`  
  Google翻訳、Microsoft Translator、DeepLの起動・アクティブ化。
- `Utility.ahk`  
  ユーティリティ関数（環境情報表示、終了処理など）。

## 必要環境

- [AutoHotkey v2.0](https://www.autohotkey.com/)
- Windows 10/11

## 使い方

1. [AutoHotkey v2.0](https://www.autohotkey.com/) をインストールします。
2. このリポジトリをクローンまたはダウンロードします。
3. `KeyBindings.ahk` をダブルクリックして実行します。

## 主な機能

- **CapsLock/Spaceの修飾キー化**
- **F13～F24キーの割り当て**
- **IME入力モードのワンキー切替**
- **Google翻訳・Microsoft Translator・DeepLのワンキー起動**
- **マウススピード・スクロール設定の即時変更**
- **エクスプローラー用タブ切替ショートカット**

## カスタマイズ

- キーバインドは `CustomKeyBindings.ahk` で自由に追加・変更できます。
- マウスやIMEの動作は `Environment.ahk` で初期値を調整できます。

## ライセンス

- 一部外部ライブラリ（`IMEv2.ahk`）はNYSLライセンスです。詳細は各ファイルのコメント参照。

## クレジット

- [KatoRyota/AutoHotkey](https://github.com/KatoRyota/AutoHotkey)
- IME制御: eamat氏, Ken'ichiro Ayaki氏

---

ご質問・要望はIssueまたはPRでお知らせください。
