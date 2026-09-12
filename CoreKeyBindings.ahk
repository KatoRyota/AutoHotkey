#Requires AutoHotkey v2.0

SendMode("Input")

; CapsLockをSpaceにリマップ。
SetCapsLockState("AlwaysOff")
SetStoreCapsLockMode(false)
SC03A::Space

; 単独のAltキーを無効化。
~LAlt:: Send("{Blind}{vkE8}")
~RAlt:: Send("{Blind}{vkE8}")

; 単独のWinキーを無効化。
~LWin:: Send("{Blind}{vkE8}")
~RWin:: Send("{Blind}{vkE8}")
Space & LWin:: Send("{LWin}")

; NumLockキーを無効化。
SetNumLockState("AlwaysOff")
NumLock:: return

; ScrollLockキーを無効化。
SetScrollLockState("AlwaysOff")
ScrollLock:: return