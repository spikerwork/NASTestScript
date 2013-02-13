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
#AutoIt3Wrapper_Res_Fileversion=0.0.1.5
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

Local $NAS_IP_ctrl
Local $FTP_Passive_ctrl
Local $FTP_Group
Local $FTP_Port_ctrl
Local $FTP_Folder_ctrl
Local $FTP_Login_ctrl
Local $FTP_Password_ctrl
Local $SetButton
Local $CancelButton

; Other
Local $NetworkAdapterIp, $Adapter_NET
Local $AdapterIPs[4]=[@IPAddress1,@IPAddress2,@IPAddress3,@IPAddress4] ; Maximum network adapters in system?
Local $t=0 ; Used for cycles
Local $NET_diff=1 ; Different between local network and $nas_ip. Default yes

; Main frame

; Compare networks
; In future must rebuild this, to analise full network range with different netmask, such as 192.168.0.0/255.255.0.0


If $ScriptInstalled==1 Then
	Local $NAS_NET = StringLeft($NAS_IP, StringInStr($NAS_IP, ".", 0, 3)-1)
	$NetworkAdapterIp=$NAS_NET & ".10"

	MsgBox(4096,"Important!","INI file found. Existing vars will be overwriten.", 5)

	$t=0
		While $t <= UBound($AdapterIPs)-1

			$Adapter_NET=StringLeft($AdapterIPs[$t], StringInStr($AdapterIPs[$t], ".", 0, 3)-1)
			If $Adapter_NET==$NAS_NET Then
				$NetworkAdapterIp=$NAS_NET & ".10"
				history ("Found network conformity " & $Adapter_NET & " and " & $NAS_NET )
				$NET_diff=0
			EndIf
			$t+=1

		WEnd
	If $NET_diff==1 Then history ("Network conformity not found. NAS network is different to real network")

Else

	$NET_diff=0
	Local $NAS_NET = StringLeft($AdapterIPs[0], StringInStr($AdapterIPs[0], ".", 0, 3)-1)
	$NetworkAdapterIp=$NAS_NET & ".10"


EndIf


;;; Create main GUI
$mainGui = GuiCreate("Settings for Nas Test Script (NTS)", $NTS_SettingsFormWidth, $NTS_SettingsFormHeight)
GUISetFont($Current_DPI[1], $Current_DPI[2], 1, $NTS_SettingsFormMainFont,$mainGui)
GUISetBkColor($NTS_SettingsFormBackgroundColor) ; Set background color of GUI
GUISetStyle($WS_POPUP, -1, $mainGui)

GUISwitch($mainGui)

GUICtrlCreateLabel(" ", 0, 0, $NTS_SettingsFormWidth, $NTS_SettingsFormHeight, $SS_CENTER, $GUI_WS_EX_PARENTDRAG)

GUISetState ()

	GUICtrlCreateLabel("NAS IP Address:", $NTS_SettingsFormWidth*0.2, 23, 150, 25, $SS_CENTER)
	GUICtrlSetFont(-1, $Current_DPI[1]+1, $Current_DPI[2]+400, 0, $NTS_SettingsFormGroupFont)

	$NAS_IP_ctrl=GUICtrlCreateInput($NetworkAdapterIp, $NTS_SettingsFormWidth*0.5, 20, $NTS_SettingsFormHeight*0.3, 25, $SS_CENTER)
	If $NET_diff==1 Then
		GUICtrlSetColor(-1, $NTS_SettingsFormBadFontColor)
		GUICtrlSetBkColor(-1, $NTS_SettingsFormBadBackgroundColor)
		GUICtrlSetTip(-1, "NAS IP address not in home network")
	EndIf
	GUICtrlSetState(-1, $GUI_ONTOP)

	$FTP_Group = GUICtrlCreateGroup("FTP", 10, 50, 250, 200)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($FTP_Group), "wstr", 0, "wstr", 0) ; Skip current windows theme for group element
	GUICtrlSetFont(-1, $Current_DPI[1]+1, $Current_DPI[2]+400, 0, $NTS_SettingsFormGroupFont)

	$FTP_Passive_ctrl=GUICtrlCreateCheckbox("Passive Mode", 20, 80, 100, 20)
	GUICtrlSetState(-1, $GUI_ONTOP)

		If $FTP_Passive==1 Then
		GUICtrlSetState(-1, $GUI_CHECKED)
		Else
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		EndIf

	$FTP_Port_ctrl=GUICtrlCreateLabel("Port ", 20, 106, 50, 20)
	GUICtrlCreateInput($FTP_Port, 70, 105, 50, 20, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_ONTOP)

	$FTP_Folder_ctrl=GUICtrlCreateLabel("FTP Folder", 20, 136, 100, 20)
	GUICtrlCreateInput($FTP_Folder, 100, 135, 150, 20, $SS_LEFT)
	GUICtrlSetState(-1, $GUI_ONTOP)

	$FTP_Login_ctrl=GUICtrlCreateLabel("Login", 20, 166, 100, 20)
	GUICtrlCreateInput($FTP_Login, 100, 165, 100, 20, $SS_CENTER)
	GUICtrlSetState(-1, $GUI_ONTOP)

	$FTP_Password_ctrl=GUICtrlCreateLabel("Password", 20, 196, 100, 20)
	GUICtrlCreateInput($FTP_Password, 100, 195, 100, 20, $SS_CENTER)
	GUICtrlSetState(-1, $GUI_ONTOP)

	GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group

	GUICtrlSetState(-1, $GUI_ONTOP)




	$SetButton = GUICtrlCreateButton("Set", $NTS_SettingsFormWidth*0.33, $NTS_SettingsFormWidth*0.8, 100, 30)
	GUICtrlSetState(-1, $GUI_ONTOP)
	$CancelButton = GUICtrlCreateButton("Cancel", $NTS_SettingsFormWidth*0.55, $NTS_SettingsFormWidth*0.8, 100, 30)
	GUICtrlSetState(-1, $GUI_ONTOP)



While 1

   Local $msg = GUIGetMsg()

   Select

	; Changing NAS IP
	Case $msg == $NAS_IP_ctrl

	If GUICtrlRead ($NAS_IP_ctrl)<>"" Then
		$NetworkAdapterIp=GUICtrlRead ($NAS_IP_ctrl)
		history ("NAS IP changed to " & $NetworkAdapterIp)
	Else
		GUICtrlSetColor($NAS_IP_ctrl, $NTS_SettingsFormBadFontColor)
		GUICtrlSetBkColor($NAS_IP_ctrl, $NTS_SettingsFormBadBackgroundColor)
		GUICtrlSetTip($NAS_IP_ctrl, "NAS IP address must be set!")
		GUICtrlSetState($NAS_IP_ctrl, $GUI_ONTOP)
		local $lol=GUICtrlGetHandle($NAS_IP_ctrl)
		Local $iColor = GUIGetBkColor($lol)
		 MsgBox(0,"",$iColor)
	EndIf

	; Exit installer
	Case $msg == $GUI_EVENT_CLOSE

	Local $destr=GUIDelete($mainGui)
	history ("Main GUI destroyed — " & $destr)
	history ("Setting the parms canceled")
	ExitLoop

	EndSelect
WEnd

;MsgBox(0, $MainAdapter, $MainAdapter_ip & "|" & $MainAdapter_netmask & "|" & $MainAdapter_MAC & "|" & $Adapter_GUID)


#include "Libs\foot.au3"
