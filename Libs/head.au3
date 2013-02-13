$ScriptStartTime=GetUnixTimeStamp() ; Each script start time

history ("Program started (" & @ScriptName & "). UnixTimeStamp " & $ScriptStartTime)
history ("Working directory � " & @ScriptDir)

If $DefaultScriptFolder<>$ScriptFolder Then history ("Script use different directory, not default � " &  $DefaultScriptFolder)

;;;; Admin checkin ;;;;
;#RequireAdmin Enable this option causes loop-problem!

If IsAdmin()==0 Then
   MsgBox(0, "", "��� ������� ��������� ���������� ����� ��������������")
   history ("Admin check failed")
   Exit
Else
   history ("Admin check passed")
EndIf
;;;;

;;;; System information ;;;;
$Current_DPI=CheckDPI()
history ("Run on system: " & @OSVersion & "(" & @OSBuild & ") " & @OSArch & " " & "Language" & " (" & @MUILang & ") [0419=Rus 0409=En]"  & " autoitX64 - " & @AutoItX64 )
history ("Desktop settings: " & @DesktopWidth & "x" & @DesktopHeight & " : " & @DesktopDepth & "Bit @ " & @DesktopRefresh & "Hz. DPI " & $Current_DPI[0] )
;;;;

;;;; Determining whether a program is installed ;;;;
If FileExists($inifile)==1 Then

   $ScriptInstalled=1
   history ("INI file found � " & $inifile)

Else

   $ScriptInstalled=0
   history ("INI file not found, use default vars")

EndIf


;;;
;;; Tray settings
;;;

;!!!! Enable it in production
;WinMinimizeAll()
#NoTrayIcon
Opt("TrayIconDebug",$linedebug)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 0) ; Default tray menu items (Script Paused/Exit) will be shown.
Opt("TrayAutoPause", 0) ; Autopause disabled
TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE, "OpenLog") ; Function called when doubleclicked on tray icon
TraySetIcon(@Scriptname) ; Sets tray icon
TraySetState()

;;;
;;; Opt settings
;;;

Opt("MustDeclareVars", 1) ; All vars must set
Opt("WinTitleMatchMode", 2) ; 2 = Match any substring in the title
Opt("GUICoordMode", 1)    ;1=absolute, 0=relative, 2=cell
Opt("GUIOnEventMode", 0)  ;0=disabled, 1=OnEvent mode enabled
Opt("GUIEventOptions",0)  ;0=default, 1=just notification, 2=GuiCtrlRead tab index
