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
Space & z:: Send("{F13}")
Space & x:: Send("{F14}")
Space & c:: Send("{F15}")
Space & a:: Send("{F16}")
Space & s:: Send("{F17}")
Space & d:: Send("{F18}")
Space & q:: Send("{F19}")
Space & w:: Send("{F20}")
Space & e:: Send("{F21}")
Space & 1:: Send("{F22}")
Space & 2:: Send("{F23}")
Space & 3:: Send("{F24}")

; Ctrl+F13～F24キーの割り当て。
Space & ,:: Send("^{F13}")
Space & .:: Send("^{F14}")
Space & /:: Send("^{F15}")
Space & k:: Send("^{F16}")
Space & l:: Send("^{F17}")
Space & `;:: Send("^{F18}")
Space & i:: Send("^{F19}")
Space & o:: Send("^{F20}")
Space & p:: Send("^{F21}")
Space & 8:: Send("^{F22}")
Space & 9:: Send("^{F23}")
Space & 0:: Send("^{F24}")