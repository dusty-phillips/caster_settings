/**
 * Advanced Window Snap (Extended
 * Snaps the Active Window to one of nine different window positions.
 *
 * @Editing author Jarrett Urech
 * @Original author Andrew Moore <andrew+github@awmoore.com>
 * @version 2.1
 *
**/

/**
 * SnapActiveWindow resizes and moves (snaps) the active window to a given position.
 * @param {string} winPlaceVertical   The vertical placement of the active window.
 *                                    Expecting "bottom" or "middle", otherwise assumes
 *                                    "top" placement.
 * @param {string} winPlaceHorizontal The horizontal placement of the active window.
 *                                    Expecting "left" or "right", otherwise assumes
 *                                    window should span the "full" width of the monitor.
 * @param {string} winSizeHeight      The height of the active window in relation to
 *                                    the active monitor's height. Expecting "half" size,
 *                                    otherwise will resize window to a "third".
 */

#NoEnv
;#NoTrayIcon
#SingleInstance force
#MaxThreads 1


SnapActiveWindow(winPlaceVertical, winPlaceHorizontal, winSizeHeight, activeMon := 0) {
    WinGet activeWin, ID, A
	SysGet, MonitorCount, MonitorCount
	
    if (!activeMon) {
		activeMon := GetMonitorIndexFromWindow(activeWin)
	} else if (activeMon > MonitorCount) {
		activeMon := 1
	}
	
    SysGet, MonitorWorkArea, MonitorWorkArea, %activeMon%
	
    if (winSizeHeight == "half") {
        height := (MonitorWorkAreaBottom - MonitorWorkAreaTop)/2
    } else if (winSizeHeight == "third") {
        height := (MonitorWorkAreaBottom - MonitorWorkAreaTop)/3
    } else {
		height := (MonitorWorkAreaBottom - MonitorWorkAreaTop)
	}

    if (winPlaceHorizontal == "left") {
        posX  := MonitorWorkAreaLeft
        width := (MonitorWorkAreaRight - MonitorWorkAreaLeft)/2
    } else if (winPlaceHorizontal == "right") {
        posX  := MonitorWorkAreaLeft + (MonitorWorkAreaRight - MonitorWorkAreaLeft)/2
        width := (MonitorWorkAreaRight - MonitorWorkAreaLeft)/2
    } else {
        posX  := MonitorWorkAreaLeft
        width := MonitorWorkAreaRight - MonitorWorkAreaLeft
    }

    if (winPlaceVertical == "bottom") {
        posY := MonitorWorkAreaBottom - height
    } else if (winPlaceVertical == "middle") {
        posY := MonitorWorkAreaTop + height
    } else {
        posY := MonitorWorkAreaTop
    }
	
	; Rounding
	posX := floor(posX)
	posY := floor(posY)
	width := floor(width)
	height := floor(height)
	
	/*
	; Borders (Windows 10)
	SysGet, BorderX, 32
	SysGet, BorderY, 33
	if (BorderX) {
		posX := posX - BorderX
		width := width + (BorderX * 2)
	}
	if (BorderY) {
		height := height + BorderY
	}
	*/
	
	; If window is already there move to same spot on next monitor
	WinGetPos, curPosX, curPosY, curWidth, curHeight, A
	if ((posX = curPosX) && (posY = curPosY) && (width = curWidth) && (height = curHeight)) {
		activeMon := activeMon + 1
		SnapActiveWindow(winPlaceVertical, winPlaceHorizontal, winSizeHeight, activeMon)
	} else {
		WinMove,A,,%posX%,%posY%,%width%,%height%
	}
}

/**
 * GetMonitorIndexFromWindow retrieves the HWND (unique ID) of a given window.
 * @param {Uint} windowHandle
 * @author shinywong
 * @link http://www.autohotkey.com/board/topic/69464-how-to-determine-a-window-is-in-which-monitor/?p=440355
 */
GetMonitorIndexFromWindow(windowHandle) {
    ; Starts with 1.
    monitorIndex := 1

    VarSetCapacity(monitorInfo, 40)
    NumPut(40, monitorInfo)

    if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2))
        && DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo) {
        monitorLeft   := NumGet(monitorInfo,  4, "Int")
        monitorTop    := NumGet(monitorInfo,  8, "Int")
        monitorRight  := NumGet(monitorInfo, 12, "Int")
        monitorBottom := NumGet(monitorInfo, 16, "Int")
        workLeft      := NumGet(monitorInfo, 20, "Int")
        workTop       := NumGet(monitorInfo, 24, "Int")
        workRight     := NumGet(monitorInfo, 28, "Int")
        workBottom    := NumGet(monitorInfo, 32, "Int")
        isPrimary     := NumGet(monitorInfo, 36, "Int") & 1

        SysGet, monitorCount, MonitorCount

        Loop, %monitorCount% {
            SysGet, tempMon, Monitor, %A_Index%

            ; Compare location to determine the monitor index.
            if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
                and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom)) {
                monitorIndex := A_Index
                break
            }
        }
    }
	
    return %monitorIndex%
}



SnapActiveWindowAdvanced(anchor, widthUnit, heightUnit, snapGrid := 3,activeMon := 0) {
	; SnapGrid units are the width/height of the active monitor evenly split into the snapgrid number
	; Width and Height is multiples of snapGrid units
	; The anchor points are arranged in order from left to right, top to bottom
	
    WinGet activeWin, ID, A
	SysGet, MonitorCount, MonitorCount
	
    if (!activeMon) {
		activeMon := GetMonitorIndexFromWindow(activeWin)
	} else if (activeMon > MonitorCount) {
		activeMon := 1
	}
	
    SysGet, MonitorWorkArea, MonitorWorkArea, %activeMon%
	
	; Snap Units
	unitX := (MonitorWorkAreaRight - MonitorWorkAreaLeft) / snapGrid
	unitY := (MonitorWorkAreaBottom - MonitorWorkAreaTop) / snapGrid
	
	; Resolve Anchor
	posX := MonitorWorkAreaLeft + (unitX * Mod(anchor - 1, snapGrid))
	posY := MonitorWorkAreaTop + (unitY * floor((anchor - 1) / snapGrid) - 1)

	; Calculate size as a percentage of the screen
	width := (MonitorWorkAreaLeft + (unitX * (Mod(anchor - 1, snapGrid) + widthUnit))) - posX
	if ((posX + width) > (MonitorWorkAreaRight - 50))
		width := MonitorWorkAreaRight - (posX - 1)
	
	height := (MonitorWorkAreaTop + (unitY * (floor((anchor - 1) / snapGrid) + heightUnit) - 1)) - posY
	if ((posY + height) > (MonitorWorkAreaBottom - 50))
		height := MonitorWorkAreaBottom - (posY - 1)
	
	/*
	; Borders (Windows 10)
	SysGet, BorderX, 32
	SysGet, BorderY, 33
	if (BorderX) {
		posX := (posX + 1) - BorderX
		width := (width - 2) + (BorderX * 2)
	}
	if (BorderY) {
		height := height + BorderY
	}
	*/
	; Rounding
	posX := floor(posX)
	posY := floor(posY)
	width := floor(width)
	height := floor(height)
	
	; If window is already there move to same spot on next monitor
	WinGetPos, curPosX, curPosY, curWidth, curHeight, A
	if ((posX = curPosX) && (posY = curPosY) && (width = curWidth) && (height = curHeight)) {
		activeMon := activeMon + 1
		SnapActiveWindowAdvanced(anchor, widthUnit, heightUnit, snapGrid, activeMon)
	} else {
		WinRestore, A
		WinMove,A,,%posX%,%posY%,%width%,%height%
	}
}

LettertoPosition(letter) {
	switch letter {
		Case "g":
			return 1
		Case "c":
			return 2
		Case "r":
			return 3
		Case "h":
			return 4
		Case "t":
			return 5
		Case "n":
			return 6
		Case "m":
			return 7
		Case "w":
			return 8
		Case "v":
			return 9
	}
	return 0
}

PositionToRowAndColumn(positionNumber) {
	row := Floor((positionNumber-1)/3)+1
	col := Mod((positionNumber-1), 3)+1
	return [row, col]
}

SnapLetters(letter1, letter2) {
	input1 := LettertoPosition(letter1)
	input2 := LettertoPosition(letter2)
	number1 := Min(input1, input2)
	number2 := Max(input1, input2)
	position1 := PositionToRowAndColumn(number1)
	position2 := PositionToRowAndColumn(number2)
	width := position2[2] - position1[2] + 1
	height := position2[1] - position1[1] + 1
	SnapActiveWindowAdvanced(number1, width, height)
}

SecondInput(letter1) {
	Input, letter2, L1 T3, , g,c,r,h,t,n,m,w,v
	if (ErrorLevel != "Match") {
		return
	}
	SnapLetters(letter1, letter2)
}

^#g::SecondInput("g")
^#c::SecondInput("c")
^#r::SecondInput("r")
^#h::SecondInput("h")
^#t::SecondInput("t")
^#n::SecondInput("n")
^#m::SecondInput("m")
^#w::SecondInput("w")
^#v::SecondInput("v")

; Directional Arrow Hotkeys
#!Up::SnapActiveWindow("top","full","half")
#!Down::SnapActiveWindow("bottom","full","half")

; Numberpad Hotkeys (Landscape)
#!g::SnapActiveWindow("top","left","half")
#!c::SnapActiveWindow("top","full","half")
#!r::SnapActiveWindow("top","right","half")
#!m::SnapActiveWindow("bottom","left","half")
#!w::SnapActiveWindow("bottom","full","half")
#!v::SnapActiveWindow("bottom","right","half")
#!h::SnapActiveWindow("top","left","full")
#!n::SnapActiveWindow("top","right","full")

; Numberpad Hotkeys (Portrait)
^#!c::SnapActiveWindow("top","full","third")
^#!t::SnapActiveWindow("middle","full","third")
^#!w::SnapActiveWindow("bottom","full","third")
^#!g::SnapActiveWindow("top","left","third")
^#!h::SnapActiveWindow("middle","left","third")
^#!m::SnapActiveWindow("bottom","left","third")
^#!r::SnapActiveWindow("top","right","third")
^#!n::SnapActiveWindow("middle","right","third")
^#!v::SnapActiveWindow("bottom","right","third")
