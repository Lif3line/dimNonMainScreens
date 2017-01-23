; Blacks or dims out all secondary screens leaving your main screen for distraction free work or gaming
; Works by placing a dark GUI on top of all other windows and taskbars
; Alt+x toggles on/off

dimmed := FALSE

!x::
    dimSecondaryScreens(dimmed)
    dimmed := !dimmed
return

; If currentlyDimmed is false activate black GUIs otherwise turn them off
dimSecondaryScreens(currentlyDimmed) {
    dimness := 300 ; Setting this lower will allow you to see through the GUIs if desireable
    SysGet, numMonitors, MonitorCount
    SysGet, mainScreen, MonitorPrimary

    if(currentlyDimmed) {
        Loop %numMonitors% ; Kill all
        {
            Gui, %A_Index%:Destroy, NoActivate
        }
    } else {
        Loop %numMonitors%
        {
            SysGet, curMonitor, Monitor, %A_Index%
            if !(A_Index = mainScreen) { ; If non-active monitorx
                monitorWidth := curMonitorRight - curMonitorLeft
                monitorHeight := curMonitorBottom - curMonitorTop
                monitorMinX := curMonitorLeft
                monitorMinY := curMonitorTop

                ; Build GUI
                Gui, %A_Index%:Default
                Gui,color,000000
                Gui, -Caption +AlwaysOnTop +E0x20 +owner
                Gui, show, NoActivate x%monitorMinX% y%monitorMinY% w%monitorWidth% h%monitorHeight%, Light Blocking GUI %A_Index%
                WinSet, Transparent, %dimness%, Light Blocking GUI %A_Index%
            }
        }
    }
}