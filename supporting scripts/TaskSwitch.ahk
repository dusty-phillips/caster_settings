#SingleInstance force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#IfWinActive Task Switching ahk_class MultitaskingViewFrame
*WheelDown::Send {Blind}+{Tab}
*WheelUp::Send {Blind}{Tab}
*MButton::Send {Blind}{Enter}
*PgUp::Send {Blind}{Enter}
*PgDn::Send {Blind}{Enter}