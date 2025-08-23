# Mouse & Keyboard Setting Script (AutoHotkey v2)

このスクリプトは、**マウススピード・スクロール方向・スクロール速度** の切り替えや、**拡張ファンクションキー送信**、**ホットキー一覧表示** などを行うための AutoHotkey v2 スクリプトです。  
作業効率を高めたいユーザーや、マウス・キーボード操作を柔軟にカスタマイズしたい方に最適です。

---

## 📌 主な機能

- **マウス設定の即時切り替え**
  - デフォルト／スロウ／高速／1画面スクロールモード
  - 垂直／水平スクロール方向の切り替え
- **マウス設定のリセット**
  - ホットキーやマウスボタンで即座に初期状態へ戻す
- **拡張ファンクションキー送信**
  - F13〜F24、Shift + F13〜F24 などを送信可能
- **ホットキー一覧表示**
  - GUIで現在登録されているホットキーと説明を一覧表示
- **環境情報表示**
  - 現在のマウススピード、スクロール設定などをGUI表示
- **マウスホイールの方向切り替え**
  - WheelUp/WheelDown を WheelLeft/WheelRight に切り替え可能

---

## ⌨️ ホットキー一覧（抜粋）

| ホットキー | 説明 |
|-----------|------|
| `Ctrl + Win + H` | ホットキー一覧を表示 |
| `Ctrl + Win + S` | 環境情報を表示 |
| `F1 & A` | マウス設定をリセット |
| `F1 & S` | 水平スクロール方向に切り替え |
| `F1 & D` | スロウマウススピードに切り替え |
| `F1 & F` | 1画面スクロールスピードに切り替え |
| `XButton1` | マウス設定をリセット |
| `XButton2` | 水平スクロール方向に切り替え |
| `Ctrl + XButton2` | スロウマウススピードに切り替え |
| `Shift + XButton2` | 1画面スクロールスピードに切り替え |
| `Alt + XButton1` | Home キー送信 |
| `Alt + XButton2` | End キー送信 |

> ※全ホットキーは `Ctrl + Win + H` でGUI表示可能です。

---

## 🖥 動作環境

- **OS**: Windows 10 / 11
- **必須**: [AutoHotkey v2](https://www.autohotkey.com/)
- **推奨**: 日本語キーボード（JIS配列）

---

## 📦 インストール方法

1. 本リポジトリをクローンまたは ZIP ダウンロード
2. `MouseAndKeyboardSetting.exe`を実行
3. タスクトレイに AutoHotkey アイコンが表示されれば準備完了

---

## 🔧 カスタマイズ方法

- **マウススピードやスクロール速度の初期値** は `env.mouse.const` 内で変更可能
- **ホットキーの割り当て** は `hotkeys` 配列を編集
- **GUIサイズ** は `env.popup.const` 内の `listView.width` / `height` を変更

---

## 📜 ライセンス

MIT License  
詳細は [LICENSE](LICENSE) ファイルを参照してください。

---

## 📂 関連リンク

- GitHub: [KatoRyota/AutoHotkey](https://github.com/KatoRyota/AutoHotkey)
