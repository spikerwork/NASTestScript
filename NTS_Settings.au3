#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: Nas Test Script
 Site: https://github.com/spikerwork/NasTestScript

 Script Function:

   Set parms for Nas Test Script

#ce ----------------------------------------------------------------------------

#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Icon=nas.ico
#AutoIt3Wrapper_Res_Comment="Nas Test Script"
#AutoIt3Wrapper_Res_Description="Nas Test Script"
#AutoIt3Wrapper_Res_Fileversion=0.0.1.3
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Nas Test Script
#AutoIt3Wrapper_Res_Field=ProductVersion|0.0.1.x
#AutoIt3Wrapper_Res_Field=OriginalFilename|Settings.au3
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"


; Local vars
Local $adapters=0
Local $PhyAdapters=0, $MainAdapter, $MainAdapter_ip, $MainAdapter_MAC, $MainAdapter_netmask, $Adapter_GUID
Local $t=0

If $ScriptInstalled==1 Then MsgBox(0,"Important!","INI file found. Existing vars will be overwriten.")

Local $ipdetails=_IPDetail() ; Gather information about network adapters

While $t <= UBound($ipdetails, 2)-1

	if $ipdetails[0][$t]<>"" Then
	$adapters+=1

				If $ipdetails[5][$t]==1 Then

				  $PhyAdapters +=1
				  $MainAdapter=$ipdetails[0][$t]
				  $MainAdapter_ip=$ipdetails[1][$t]
				  $MainAdapter_MAC=$ipdetails[2][$t]
				  $MainAdapter_netmask=$ipdetails[3][$t]
				  $Adapter_GUID=$ipdetails[6][$t]

			   EndIf
	EndIf
	$t+=1

WEnd

If $adapters==0 Then
	MsgBox(0, "Warning!", "Network adapters not found! Enable them and run this script again.")
	history ("Network adapters not found! Enable them and run this script again.")
	Exit
EndIf

If @DesktopWidth>=1900 Then
	GUISetFont (8.5)
ElseIf 	@DesktopWidth<1900 Then
	GUISetFont (6)
EndIf

Local $Button_1
Local $Button_2
Local $Button_3
Local $SettingsFormWidth=300
Local $SettingsFormHeight=300

; Creating main GUI
Local $mainGui=GuiCreate("Settings for Nas Test Script (NTS)", $SettingsFormWidth, $SettingsFormHeight)
GUISetBkColor(0xABCDEF)
GUISwitch($mainGui)
GUISetStyle($WS_POPUP, -1, $mainGui)

;GuiCtrlCreateLabel("Press F1 for help", 145, 0, 150, 15, $SS_RIGHT)
local $lll=GUICtrlCreateLabel("A ", 0, 0, $SettingsFormWidth+20, $SettingsFormHeight+30, $SS_CENTER, $GUI_WS_EX_PARENTDRAG)
GUICtrlSetBkColor($lll, 0xABCDEF)
_WinAPI_SetLayeredWindowAttributes($lll, 0xABCDEF, 100)

;GUICtrlSetFont(-1, 20, 1000)
;GUICtrlSetColor(-1, 0xc03d3a)

GUISetState ()

$Button_1 = GUICtrlCreateButton("Start Client", 80, 30, 150, 40)
GUICtrlSetState(-1, $GUI_ONTOP)
$Button_2 = GUICtrlCreateButton("Start Server",  80, 80, 150, 40)
GUICtrlSetState(-1, $GUI_ONTOP)
$Button_3 = GUICtrlCreateButton("Uninstall Script",  80, 130, 150, 40)
GUICtrlSetState(-1, $GUI_ONTOP)



While 1

   Local $msg = GUIGetMsg()

   Select

	Case $msg == $GUI_EVENT_CLOSE
	; Exit installer

	  Local $destr=GUIDelete($mainGui)
	  history ("Main GUI destroyed — " & $destr)
	  history ("Start canceled")
	  ExitLoop

	EndSelect
WEnd

;MsgBox(0, $MainAdapter, $MainAdapter_ip & "|" & $MainAdapter_netmask & "|" & $MainAdapter_MAC & "|" & $Adapter_GUID)


#include "Libs\foot.au3"
