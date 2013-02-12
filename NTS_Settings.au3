#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: Nas Test Script
 Site: https://github.com/spikerwork/NasTestScript

 Script Function:

   Set parameters for Nas Test Script

#ce ----------------------------------------------------------------------------

#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Icon=nas.ico
#AutoIt3Wrapper_Res_Comment="Nas Test Script"
#AutoIt3Wrapper_Res_Description="Nas Test Script"
#AutoIt3Wrapper_Res_Fileversion=0.0.1.4
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


;;; Local vars

; GUI

Local $mainGui
Local $FTP_PassiveMode_ctrl
Local $NAS_IP_ctrl
Local $FTP_Group



; Other
Local $ipdetails, $adapters=0, $PhyAdapters=0, $PhyAdapterName, $NetworkAdapterIp, $NetworkVirtualAdapterIp, $VirtualAdapterName
Local $AdapterIPs[6] ; Maximum network adapters in system? if not script fails
Local $t=0 ; Used for cycles

; Main frame

$ipdetails=_IPDetail() ; Gather information about network adapters

While $t <= UBound($ipdetails, 2)-1

	If $ipdetails[0][$t]<>"" Then
	$adapters+=1
	$AdapterIPs[$t]=$ipdetails[1][$t]
				If $ipdetails[5][$t]==1 Then

					$PhyAdapters +=1
					$PhyAdapterName=$ipdetails[0][$t]
					$NetworkAdapterIp=$ipdetails[1][$t]

				Else

					$VirtualAdapterName=$ipdetails[0][$t]
					$NetworkVirtualAdapterIp=$ipdetails[1][$t]

				EndIf
	EndIf
	$t+=1

WEnd

If $adapters==0 Then
	MsgBox(0, "Warning!", "Network adapters not found! Enable them and run this script again.")
	history ("Network adapters not found! Enable them and run this script again.")
	Exit
ElseIf $PhyAdapters==0 Then
	$NetworkAdapterIp=$NetworkVirtualAdapterIp
	history ("No physical network adapters found. Using virtual " & $VirtualAdapterName & " (" & $NetworkAdapterIp &")")
Else
	history ("Using physical network adapter " & $PhyAdapterName & " (" & $NetworkAdapterIp &")")
EndIf

If $ScriptInstalled==1 Then
Local $NAS_NET = StringSplit($NAS_IP, '.', 1)

MsgBox(4096,$NAS_NET[0], $NAS_NET[4])
MsgBox(4096,"Important!","INI file found. Existing vars will be overwriten.")
	$t=0
		While $t <= UBound($AdapterIPs)-1

		MsgBox(0,UBound($AdapterIPs),StringInStr($AdapterIPs[$t], $NAS_IP))
		$t+=1
		WEnd
$NetworkAdapterIp=$NAS_IP
EndIf


;;; Create main GUI
$mainGui = GuiCreate("Settings for Nas Test Script (NTS)", $NTS_SettingsFormWidth, $NTS_SettingsFormHeight)
GUISetFont($Current_DPI[1], $Current_DPI[2], 1, $NTS_SettingsFormMainFont,$mainGui)
;If @DesktopWidth>=1900 Then
	;GUISetFont (8.5)
;ElseIf 	@DesktopWidth<1900 Then
	;GUISetFont (6)
;EndIf

GUISetBkColor($NTS_SettingsFormBackgroundColor) ; Set background color of GUI

GUISwitch($mainGui)
GUISetStyle($WS_POPUP, -1, $mainGui)

GUICtrlCreateLabel(" ", 0, 0, $NTS_SettingsFormWidth+20, $NTS_SettingsFormHeight+30, $SS_CENTER, $GUI_WS_EX_PARENTDRAG)

GUISetState ()


	GUICtrlCreateLabel("Port ", 20, 156, 50, 20)
	$NAS_IP_ctrl=GUICtrlCreateInput($NetworkAdapterIp, 20, 55, 150, 25, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_ONTOP)

	$FTP_Group = GUICtrlCreateGroup("FTP", 10, 110, 140, 90)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($FTP_Group), "wstr", 0, "wstr", 0) ; Skip current windows theme for group element
	GUICtrlSetFont(-1, $Current_DPI[1]+1, $Current_DPI[2]+400, 0, $NTS_SettingsFormGroupFont)

	$FTP_PassiveMode_ctrl=GUICtrlCreateCheckbox("Passive Mode", 20, 130, 100, 20)
	GUICtrlSetState(-1, $GUI_ONTOP)
	GUICtrlSetState(-1, $GUI_CHECKED)

	GUICtrlCreateLabel("Port ", 20, 156, 50, 20)

	GUICtrlCreateInput(21, 70, 155, 50, 20, $SS_RIGHT)

	GUICtrlSetState(-1, $GUI_ONTOP)


	GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group

GUICtrlSetState(-1, $GUI_ONTOP)


;;GUICtrlCreateRadio("Radio 2", 20, 50, 60, 20)
;$Button_1 = GUICtrlCreateButton("Start Client", 80, 30, 150, 40)
;GUICtrlSetState(-1, $GUI_ONTOP)
;$Button_2 = GUICtrlCreateButton("Start Server",  80, 80, 150, 40)
;GUICtrlSetState(-1, $GUI_ONTOP)
;$Button_3 = GUICtrlCreateButton("Uninstall Script",  80, 130, 150, 40)
;GUICtrlSetState(-1, $GUI_ONTOP)



While 1

   Local $msg = GUIGetMsg()

   Select

	Case $msg == $GUI_EVENT_CLOSE
	; Exit installer

	  Local $destr=GUIDelete($mainGui)
	  history ("Main GUI destroyed — " & $destr)
	  history ("Setting the parms canceled")
	  ExitLoop

	EndSelect
WEnd

;MsgBox(0, $MainAdapter, $MainAdapter_ip & "|" & $MainAdapter_netmask & "|" & $MainAdapter_MAC & "|" & $Adapter_GUID)


#include "Libs\foot.au3"
