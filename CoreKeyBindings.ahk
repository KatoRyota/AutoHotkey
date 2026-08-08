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

; F13～F24キーの割り当て。
Space & 1:: Send("{F13}")
Space & 2:: Send("{F14}")
Space & 3:: Send("{F15}")
Space & 4:: Send("{F16}")
Space & 5:: Send("{F17}")
Space & 6:: Send("{F18}")
Space & 7:: Send("{F19}")
Space & 8:: Send("{F20}")
Space & 9:: Send("{F21}")
Space & 0:: Send("{F22}")
Space & -:: Send("{F23}")
Space & =:: Send("{F24}")

; Ctrl+F13～F24キーの割り当て。
Space & q:: Send("^{F13}")
Space & w:: Send("^{F14}")
Space & e:: Send("^{F15}")
Space & r:: Send("^{F16}")
Space & t:: Send("^{F17}")
Space & y:: Send("^{F18}")
Space & u:: Send("^{F19}")
Space & i:: Send("^{F20}")
Space & o:: Send("^{F21}")
Space & p:: Send("^{F22}")
Space & [:: Send("^{F23}")
Space & ]:: Send("^{F24}")