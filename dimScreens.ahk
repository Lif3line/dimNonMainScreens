; Blacks or dims out all secondary screens leaving your main screen for distraction free work/gaming
; Set dimness and your primary (active) screen below. The cursor will be bound to this screen while dimming is active
; Alt+z toggles on/off

dimmed := FALSE
SysGet, numMonitors, MonitorCount

!z::
	dimmed := dimSecondaryScreens(dimmed,numMonitors,2)
return

!x::
	dimmed := dimSecondaryScreens(dimmed,numMonitors,1)
return

!c::
	dimmed := dimSecondaryScreens(dimmed,numMonitors,3)
return


dimSecondaryScreens(dimmed, numMonitors, activeMonitor) {
	mainScreen := 1 ; Must set manually which one is the main monitor for clipping purposes
	dimness := 300
	
	if(dimmed) {
		Gui, show ; Hack to remove clipping - by forcing context to window ClipCursor resource is reset
		
		Loop %numMonitors% ; Kill all 
		{
			Gui, %A_Index%:Destroy, NoActivate
		}

		dimmed := FALSE
	} else {
		Loop %numMonitors%
		{
			SysGet, curMonitor, Monitor, %A_Index%
			monitorWidth := curMonitorRight - curMonitorLeft
			monitorHeight := curMonitorBottom - curMonitorTop
			monitorMinX := curMonitorLeft
			monitorMinY := curMonitorTop

			if !(A_Index = activeMonitor) {
				Gui, %A_Index%:Default
				Gui,color,000000
				Gui, -Caption +AlwaysOnTop +E0x20 +owner
				Gui, show, NoActivate x%monitorMinX% y%monitorMinY% w%monitorWidth% h%monitorHeight%, Light Blocking GUI %A_Index%
				WinSet, Transparent, %dimness%, Light Blocking GUI %A_Index%
			} else if (A_Index = mainScreen) {
				ClipCursor(curMonitorLeft, curMonitorTop, monitorWidth, monitorHeight) ; Clip to active monitor - changing windows removes clip 
			}
		}

		dimmed := TRUE
	}
	return dimmed
}

; Stolen - http://www.autohotkey.com/board/topic/20345-protecting-an-area-of-the-screen-is-it-possible/#entry133444
; Edited due to clip stopping being bust
ClipCursor(x1=0 , y1=0, x2=1, y2=1) {
	VarSetCapacity(R,16,0), NumPut(x1,&R+0), NumPut(y1,&R+4), NumPut(x2,&R+8), NumPut(y2,&R+12)
	return DllCall( "ClipCursor", UInt,&R ) 
}