#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: Nas Test Script (NTS)
 Site: https://github.com/spikerwork/NasTestScript

 Script Function:

   The main part of Nas Test Script (NTS)

#ce ----------------------------------------------------------------------------

#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Icon=nas.ico
#AutoIt3Wrapper_Res_Comment="Nas Test Script"
#AutoIt3Wrapper_Res_Description="Nas Test Script"
#AutoIt3Wrapper_Res_Fileversion=0.1.3.3
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Nas Test Script
#AutoIt3Wrapper_Res_Field=ProductVersion|0.1.3.x
#AutoIt3Wrapper_Res_Field=OriginalFilename|NasTestScript.au3
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"

Dim $Current_Tests_array ; Array with tests
Local $t=0, $i, $l=0
$Current_Tests_array = _StringExplode($Current_Tests, "|", 0) ; Tests to run

history("Current loop " & $Current_Loop)
history("Total loops " & $Number_of_loops)
history("Choosen tests " & $Current_Tests)
history("Pause between each action " & $ClientPause)
history("ClearCache " & $ClearCache)


; Gui vars
Local $mainGui
Local $SAMBA_Group
Local $FTP_Group
Local $Other_Group
Local $Run_Group
Local $FTP_Download_ctrl
Local $FTP_Upload_ctrl
Local $FTP_UpDown_ctrl
Local $Samba_Download_ctrl
Local $Samba_Upload_ctrl
Local $Samba_UpDown_ctrl
Local $HTTP_Download_ctrl
Local $Samba_IO_ctrl
Local $Samba_NASPT_ctrl
Local $iSCSI_IO_ctrl
Local $Cache_ctrl
Local $Testruns_ctrl
Local $Pause_ctrl

; Buttons
Local $StartButton ; Start test button
Local $SettingsButton ; Link to NTS_Settings.exe
Local $ExitButton ; Quit from starter


;;; Create main GUI

Local $hGUI = GuiCreate("Nas Test Script (NTS)", $NTS_FormWidth, $NTS_FormHeight)
GUISetFont($Current_DPI[1], $Current_DPI[2], 1, $NTS_FormMainFont, $hGUI) ; Add font settings
GUISetBkColor($NTS_FormBackgroundColor) ; Set background color of GUI
GUISetStyle($WS_POPUP, -1, $hGUI) ; Remove border

; Apply to WM_WINDOWPOSCHANGING and WM_NCHITTEST functions
GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST")
GUIRegisterMsg($WM_WINDOWPOSCHANGING, "WM_WINDOWPOSCHANGING")

GUISetState ()

; Main elements on GUI

GUICtrlCreateLabel("NAS Test Script", $NTS_FormWidth*0.37, 20, 150, 25, $SS_CENTER)
GUICtrlSetFont(-1, $Current_DPI[1]+1, $Current_DPI[2]+400, 0, $NTS_FormGroupFont)

; FTP Group

$FTP_Group = GUICtrlCreateGroup("FTP", 10, 50, $NTS_FormWidth*0.45, $NTS_FormHeight*0.35)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($FTP_Group), "wstr", 0, "wstr", 0) ; Skip current windows theme for group element
	GUICtrlSetFont(-1, $Current_DPI[1]+1, $Current_DPI[2]+400, 0, $NTS_FormGroupFont)

$FTP_Download_ctrl=GUICtrlCreateCheckbox("Download", 20, $NTS_FormHeight*0.17, 200, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$FTP_Upload_ctrl=GUICtrlCreateCheckbox("Upload", 20, $NTS_FormHeight*0.26, 200, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$FTP_UpDown_ctrl=GUICtrlCreateCheckbox("Download + Upload", 20, $NTS_FormHeight*0.35, 200, 20)
GUICtrlSetState(-1, $GUI_CHECKED)

GUICtrlCreateGroup("", -99, -99, 1, 1)

; Close FTP group

; Samba Group

$SAMBA_Group = GUICtrlCreateGroup("SAMBA/CIFS", $NTS_FormWidth*0.50, 50, $NTS_FormWidth*0.48, $NTS_FormHeight*0.35)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($SAMBA_Group), "wstr", 0, "wstr", 0) ; Skip current windows theme for group element
	GUICtrlSetFont(-1, $Current_DPI[1]+1, $Current_DPI[2]+400, 0, $NTS_FormGroupFont)

$Samba_Download_ctrl=GUICtrlCreateCheckbox("Download", $NTS_FormWidth*0.52, $NTS_FormHeight*0.17, 200, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$Samba_Upload_ctrl=GUICtrlCreateCheckbox("Upload", $NTS_FormWidth*0.52, $NTS_FormHeight*0.26, 200, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$Samba_UpDown_ctrl=GUICtrlCreateCheckbox("Download + Upload", $NTS_FormWidth*0.52, $NTS_FormHeight*0.35, 200, 20)
GUICtrlSetState(-1, $GUI_CHECKED)

GUICtrlCreateGroup("", -99, -99, 1, 1)

; Close Samba group


; Other Group

$Other_Group = GUICtrlCreateGroup("Other Tests", 10, $NTS_FormHeight*0.50, $NTS_FormWidth*0.45, $NTS_FormHeight*0.37)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($Other_Group), "wstr", 0, "wstr", 0) ; Skip current windows theme for group element
	GUICtrlSetFont(-1, $Current_DPI[1]+1, $Current_DPI[2]+400, 0, $NTS_FormGroupFont)

$HTTP_Download_ctrl=GUICtrlCreateCheckbox("HTTP", 20, $NTS_FormHeight*0.57, 200, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$Samba_IO_ctrl=GUICtrlCreateCheckbox("Samba IOmeter", 20, $NTS_FormHeight*0.64, 200, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$Samba_NASPT_ctrl=GUICtrlCreateCheckbox("Samba NASPT", 20, $NTS_FormHeight*0.71, 200, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$iSCSI_IO_ctrl=GUICtrlCreateCheckbox("iSCSI IOmeter", 20, $NTS_FormHeight*0.78, 200, 20)
GUICtrlSetState(-1, $GUI_DISABLE)


GUICtrlCreateGroup("", -99, -99, 1, 1)

; Close other group


; TestRun Group

$Run_Group = GUICtrlCreateGroup("Run settings", $NTS_FormWidth*0.50, $NTS_FormHeight*0.50, $NTS_FormWidth*0.48, $NTS_FormHeight*0.35)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($Run_Group), "wstr", 0, "wstr", 0) ; Skip current windows theme for group element
	GUICtrlSetFont(-1, $Current_DPI[1]+1, $Current_DPI[2]+400, 0, $NTS_FormGroupFont)

GUICtrlCreateLabel("Pause between actions", $NTS_FormWidth*0.52, $NTS_FormHeight*0.59, 200, 20)
$Pause_ctrl=GUICtrlCreateInput($ClientPause, $NTS_FormWidth*0.82, $NTS_FormHeight*0.588, 50, 20, $SS_RIGHT)

GUICtrlCreateLabel("Number of run", $NTS_FormWidth*0.52, $NTS_FormHeight*0.65, 200, 20)
$Testruns_ctrl=GUICtrlCreateInput($Number_of_loops, $NTS_FormWidth*0.82, $NTS_FormHeight*0.648, 50, 20, $SS_RIGHT)

$Cache_ctrl=GUICtrlCreateCheckbox("Clear cache/prefetch before each test", $NTS_FormWidth*0.52, $NTS_FormHeight*0.79, 250, 20)
If $ClearCache==1 Then GUICtrlSetState($Cache_ctrl, $GUI_CHECKED)

GUICtrlCreateGroup("", -99, -99, 1, 1)

; Close TestRun group


; Buttons

$StartButton = GUICtrlCreateButton("Start test", $NTS_FormWidth*0.21, $NTS_FormHeight*0.95, 100, 30)
$SettingsButton = GUICtrlCreateButton("Settings", $NTS_FormWidth*0.42, $NTS_FormHeight*0.95, 100, 30)
$ExitButton = GUICtrlCreateButton("Exit", $NTS_FormWidth*0.63, $NTS_FormHeight*0.95, 100, 30)

; Some functions for GUI

; Enable/disable start button. Depends on settings.ini ($inifile) present
If FileExists($inifile) Then
	GUICtrlSetState($StartButton, $GUI_ENABLE)
Else
	GUICtrlSetState($StartButton, $GUI_DISABLE)
	GUICtrlSetColor($StartButton, $NTS_FormBadFontColor)
	GUICtrlSetBkColor($StartButton, $NTS_FormBadBackgroundColor)
EndIf

; Enable/disable start button adlib function. Depends on settings.ini ($inifile) present

Func Check_ini()
	If FileExists($inifile) Then
		GUICtrlSetState($StartButton, $GUI_ENABLE)
		GUICtrlSetColor($StartButton, 0x000000)
		GUICtrlSetBkColor($StartButton, $NTS_ButtonPushedColor)
	Else
		GUICtrlSetState($StartButton, $GUI_DISABLE)
		GUICtrlSetColor($StartButton, $NTS_FormBadFontColor)
		GUICtrlSetBkColor($StartButton, $NTS_FormBadBackgroundColor)
	EndIf
EndFunc

AdlibRegister("Check_ini", 2000) ; Find ini-file ($inifile) with settings

; Read selected tests from ini if it exist. Apply this parms to GUI elements.
If FileExists($testsini) Then

	history("Ini file already created " & $testsini)

	While $t <= UBound($Current_Tests_array)-1

		Local $var = IniReadSection($testsini, $Current_Tests_array[$t])
		history("Read test parameters from section " & $Current_Tests_array[$t])

		If @error Then
			history("Problem with ini-file " & $testsini)
		Else

			For $i = 1 To $var[0][0]

			If $var[$i][0]=="Clear" or $var[$i][0]=="Prepare" Then
			Else

				history("Find test " & $Current_Tests_array[$t] & ". Selected mode - " & $var[$i][0])

			EndIf

			Next

		EndIf

		$var=0 ; Clear array
		$t+=1 ; Raise loop
	WEnd

EndIf


GUISetState()

;
; GUI messages loop
;

While 1
	;Sleep(2000)
	Switch GUIGetMsg()

	; Run tests
	Case $StartButton

		history("Start tests with ini " & $testsini)
		FileCreateShortcut ($ScriptFolder & "\" & $NTS_Test, @StartupCommonDir & "\NTS_Test.lnk")
		;halt("reboot")
		ExitLoop

	; Run set settings file
	Case $SettingsButton

		history("Settings program started " & $ScriptFolder & "\" & $NTS_Settings)
		Run($ScriptFolder & "\" & $NTS_Settings, $ScriptFolder)

	; Cancel or close window
	Case $GUI_EVENT_CLOSE, $ExitButton

		history ("Main GUI destroyed � " & GUIDelete($mainGui) & ". Test settings didn`t apply.")
		ExitLoop

	EndSwitch

WEnd


#include "Libs\foot.au3"




