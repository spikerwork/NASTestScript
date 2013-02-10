$ScriptStartTime=GetUnixTimeStamp() ; Each script start time

history ("Program started (" & @ScriptName & "). UnixTimeStamp " & $ScriptStartTime)
history ("Working directory Ч " & @ScriptDir)

If $DefaultScriptFolder<>$ScriptFolder Then history ("Script use different directory, not default Ч " &  $DefaultScriptFolder)

;;;; Admin checkin ;;;;
;#RequireAdmin Enable this option causes loop-problem!
If IsAdmin()==0 Then
   MsgBox(0, "", "ƒл€ запуска программы необходимы права администратора")
   history ("Admin check failed")
   Exit
Else
   history ("Admin check passed")
EndIf
;;;;


; Systeminfo
history ("Run on system: " & $osversion & "(" & @OSBuild & ") " & $osarch & " " & "Language" & " (" & $oslang & ") [0419=Rus 0409=En]"  & " autoitX64 - " & @AutoItX64 )
;


;;;; Determining whether a program is installed  ;;;;
If FileExists($inifile)==1 Then

   $ScriptInstalled=1
   history ("INI file found Ч " & $inifile)

Else

   $ScriptInstalled=0
   history ("INI file not found, use default vars")

EndIf


;;;
;;; Tray settings
;;;
WinMinimizeAll()
#NoTrayIcon
Opt("TrayIconDebug",$linedebug)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 0) ; Default tray menu items (Script Paused/Exit) will be shown.
Opt("TrayAutoPause", 0) ; Autopause disabled
TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE, "OpenLog") ; Function called when doubleclicked on tray icon
TraySetIcon(@Scriptname) ; Sets tray icon
TraySetState()


