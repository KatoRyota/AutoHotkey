#Requires AutoHotkey v2.0

SendMode("Input")
A_MenuMaskKey := "vkFF"

; CapsLockキーの修飾キー化。
SetCapsLockState("AlwaysOff")
CapsLock:: return

; Spaceキーの修飾キー化。
Space:: return
CapsLock & Space:: Send("{Space}")
!Space:: Send("{Space}")
^Space:: Send("^{Space}")
+Space:: Send("+{Space}")
^+Space:: Send("^+{Space}")

; 単独の Alt, Win キーを無効化。
~LAlt:: Send("{Blind}{vkE8}")
~RAlt:: Send("{Blind}{vkE8}")
~LWin:: Send("{Blind}{vkE8}")
~RWin:: Send("{Blind}{vkE8}")
CapsLock & LWin:: Send("{LWin}")

; NumLock, ScrollLock キーを無効化。
SetNumLockState("AlwaysOff")
SetScrollLockState("AlwaysOff")
NumLock:: return
ScrollLock:: return

; F13～F24キーの割り当て。
F1 & 1:: Send("{F1}")
F1 & 2:: Send("^{F1}")
F1 & 3:: Send("+{F1}")
F1 & 4:: Send("!{F1}")
F1 & z:: Send("{F13}")
F1 & x:: Send("{F14}")
F1 & c:: Send("{F15}")
F1 & v:: Send("{F16}")
F1 & a:: Send("{F17}")
F1 & s:: Send("{F18}")
F1 & d:: Send("{F19}")
F1 & f:: Send("{F20}")
F1 & q:: Send("{F21}")
F1 & w:: Send("{F22}")
F1 & e:: Send("{F23}")
F1 & r:: Send("{F24}")

; Ctrl+F13～F24キーの割り当て。
F2 & 1:: Send("{F2}")
F2 & 2:: Send("^{F2}")
F2 & 3:: Send("+{F2}")
F2 & 4:: Send("!{F2}")
F2 & z:: Send("^{F13}")
F2 & x:: Send("^{F14}")
F2 & c:: Send("^{F15}")
F2 & v:: Send("^{F16}")
F2 & a:: Send("^{F17}")
F2 & s:: Send("^{F18}")
F2 & d:: Send("^{F19}")
F2 & f:: Send("^{F20}")
F2 & q:: Send("^{F21}")
F2 & w:: Send("^{F22}")
F2 & e:: Send("^{F23}")
F2 & r:: Send("^{F24}")

; Shift+F13～F24キーの割り当て。
F12 & 1:: Send("{F12}")
F12 & 2:: Send("^{F12}")
F12 & 3:: Send("+{F12}")
F12 & 4:: Send("!{F12}")
F12 & z:: Send("+{F13}")
F12 & x:: Send("+{F14}")
F12 & c:: Send("+{F15}")
F12 & v:: Send("+{F16}")
F12 & a:: Send("+{F17}")
F12 & s:: Send("+{F18}")
F12 & d:: Send("+{F19}")
F12 & f:: Send("+{F20}")
F12 & q:: Send("+{F21}")
F12 & w:: Send("+{F22}")
F12 & e:: Send("+{F23}")
F12 & r:: Send("+{F24}")

; Alt+F13～F24キーの割り当て。
F11 & 1:: Send("{F11}")
F11 & 2:: Send("^{F11}")
F11 & 3:: Send("+{F11}")
F11 & 4:: Send("!{F11}")
F11 & z:: Send("!{F13}")
F11 & x:: Send("!{F14}")
F11 & c:: Send("!{F15}")
F11 & v:: Send("!{F16}")
F11 & a:: Send("!{F17}")
F11 & s:: Send("!{F18}")
F11 & d:: Send("!{F19}")
F11 & f:: Send("!{F20}")
F11 & q:: Send("!{F21}")
F11 & w:: Send("!{F22}")
F11 & e:: Send("!{F23}")
F11 & r:: Send("!{F24}")