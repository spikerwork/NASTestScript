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
#AutoIt3Wrapper_Res_Fileversion=0.0.1.25
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

Local $FTP_Group
Local $FTP_Port_ctrl
Local $FTP_Folder_ctrl
Local $FTP_Login_ctrl
Local $FTP_Password_ctrl
Local $FTP_Passive_ctrl
Local $FTP_Anon_ctrl

Local $SAMBA_Group
Local $SAMBA_DiskLetter_ctrl
Local $SAMBA_Folder_ctrl
Local $SAMBA_Login_ctrl
Local $SAMBA_Password_ctrl
Local $SAMBA_Anon_ctrl

Local $HTTP_Group
Local $HTTP_Address_ctrl
Local $HTTP_Address_Full
Local $HTTP_Port_ctrl
Local $HTTP_Password_ctrl
Local $HTTP_Login_ctrl
Local $HTTP_NoAnon_ctrl

Local $SetButton
Local $ExitButton

; Other
Local $NetworkAdapterIp, $Adapter_NET
Local $AdapterIPs[4]=[@IPAddress1,@IPAddress2,@IPAddress3,@IPAddress4] ; Maximum network adapters in system?
Local $t=0 ; Used for cycles
Local $NET_diff=1 ; Different between local network and $nas_ip. Default yes
Local $NAS_SMB_Disk=0 ; Network disk present or not
Local $NAS_SMB_Disk_check
Local $NAS_SMB_Disk_Found=0
Local $Local_Disks ; Array with all disk in system
Local $Local_Disks_List ; Special array with disk for combo control

; Main frame

$Local_Disks=DriveGetDrive("ALL")

If @error Then
    ; An error occurred when retrieving the drives.
    MsgBox(4096, "DriveGetDrive", "How can it be?")
	Exit
Else
    For $t = 1 To $Local_Disks[0]
		If StringUpper($SAMBA_DiskLetter)== StringUpper($Local_Disks[$t]) Then $NAS_SMB_Disk_Found=1
		$Local_Disks_List= $Local_Disks_List & "|" & StringUpper($Local_Disks[$t])
		history("Found drive " & $t & " of " & $Local_Disks[0] & ". Path — " & StringUpper($Local_Disks[$t]) & "\")
    Next

	If $NAS_SMB_Disk_Found==1 Then
		history("Disk from ini (" & $SAMBA_DiskLetter & ") present in system")
	Else
		history("Disk from ini (" & $SAMBA_DiskLetter & ") not present in system. Adding to array in GUI")
		$Local_Disks_List= $Local_Disks_List & "|" & $SAMBA_DiskLetter
	EndIf

EndIf


If $ScriptInstalled==1 Then

	history ("Important! INI file found. Existing vars will be overwriten.")

	; Compare networks
	;In future must rebuild this, to analise full network range with different netmask, such as 192.168.0.0/255.255.0.0 - function Network_check()
	$NET_diff=Network_check($NAS_IP, $AdapterIPs)

		If $NET_diff==1 Then
			history ("Network conformity not found. NAS network is different to real network")
		Else
			history ("Found network conformity. NAS in home network" )

		EndIf

	$NetworkAdapterIp=$NAS_IP


	; Samba disk checks

	$NAS_SMB_Disk_check = DriveGetType($SAMBA_DiskLetter)

	If @error Then

		history("Mapped NAS not found with letter " & $SAMBA_DiskLetter & "\")
		$NAS_SMB_Disk=0

	ElseIf $NAS_SMB_Disk_check<>"Network" Then

		$NAS_SMB_Disk=0
		history("Disk " & $SAMBA_DiskLetter & " found, but seems not to be network share..." )

	Else

		If StringInStr(DriveMapGet($SAMBA_DiskLetter), $NetworkAdapterIp)<>0 Then $NAS_SMB_Disk=1 ; Need rebuild. 10.0.0.9 same as 10.0.0.99!
		history("Network disk " & $SAMBA_DiskLetter & " matches NAS IP - " & $NAS_SMB_Disk)

	EndIf


Else

	$NET_diff=0
	$NAS_SMB_Disk=1
	$NetworkAdapterIp=StringLeft($AdapterIPs[0], StringInStr($AdapterIPs[0], ".", 0, 3)-1) & ".10"

EndIf





;;; Create main GUI

Local $hGUI = GuiCreate("Settings for Nas Test Script (NTS)", $NTS_SettingsFormWidth, $NTS_SettingsFormHeight)
GUISetFont($Current_DPI[1], $Current_DPI[2], 1, $NTS_SettingsFormMainFont, $hGUI) ; Add font settings
GUISetBkColor($NTS_SettingsFormBackgroundColor) ; Set background color of GUI
GUISetStyle($WS_POPUP, -1, $hGUI) ; Remove border

; apply to WM_WINDOWPOSCHANGING and WM_NCHITTEST functions
GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST")
GUIRegisterMsg($WM_WINDOWPOSCHANGING, "WM_WINDOWPOSCHANGING")

GUISetState ()

	; NAS IP Address

	GUICtrlCreateLabel("NAS IP Address:", $NTS_SettingsFormWidth*0.2, 23, 150, 25, $SS_CENTER)
	GUICtrlSetFont(-1, $Current_DPI[1]+1, $Current_DPI[2]+400, 0, $NTS_SettingsFormGroupFont)

	$NAS_IP_ctrl=GUICtrlCreateInput($NetworkAdapterIp, $NTS_SettingsFormWidth*0.5, 20, $NTS_SettingsFormHeight*0.3, 25, $SS_CENTER)
	If $NET_diff==1 Then
		GUICtrlSetColor(-1, $NTS_SettingsFormBadFontColor)
		GUICtrlSetBkColor(-1, $NTS_SettingsFormBadBackgroundColor)
		GUICtrlSetTip(-1, "NAS IP address not in home network")
	EndIf

	; Open FTP group

	$FTP_Group = GUICtrlCreateGroup("FTP", 10, 50, $NTS_SettingsFormWidth*0.45, $NTS_SettingsFormHeight*0.38)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($FTP_Group), "wstr", 0, "wstr", 0) ; Skip current windows theme for group element
	GUICtrlSetFont(-1, $Current_DPI[1]+1, $Current_DPI[2]+400, 0, $NTS_SettingsFormGroupFont)

	$FTP_Passive_ctrl=GUICtrlCreateCheckbox("Passive Mode", 20, 80, 100, 20)

		If $FTP_Passive==1 Then
			GUICtrlSetState(-1, $GUI_CHECKED)
		Else
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		EndIf

	$FTP_Anon_ctrl=GUICtrlCreateCheckbox("Anonymous login", $NTS_SettingsFormWidth*0.24, 80, 120, 20)

		If $FTP_Login==$FTP_Anon_login and $FTP_Password==$FTP_Anon_pass Then

			GUICtrlSetState($FTP_Anon_ctrl, $GUI_CHECKED)
			GUICtrlSetState($FTP_Login_ctrl, $GUI_DISABLE)
			GUICtrlSetState($FTP_Password_ctrl, $GUI_DISABLE)

		Else

			GUICtrlSetState($FTP_Anon_ctrl, $GUI_UNCHECKED)

		EndIf



	GUICtrlCreateLabel("Port ", 20, 106, 50, 20)
	$FTP_Port_ctrl=GUICtrlCreateInput($FTP_Port, 70, 105, 50, 20, $SS_RIGHT)


	GUICtrlCreateLabel("FTP Folder", 20, 136, 80, 20)
	$FTP_Folder_ctrl=GUICtrlCreateInput($FTP_Folder, 100, 135, 170, 20, $SS_LEFT)


	GUICtrlCreateLabel("Login", 20, 166, 80, 20)
	$FTP_Login_ctrl=GUICtrlCreateInput($FTP_Login, 100, 165, 100, 20, $SS_CENTER)


	GUICtrlCreateLabel("Password", 20, 196, 80, 20)
	$FTP_Password_ctrl=GUICtrlCreateInput($FTP_Password, 100, 195, 100, 20, $SS_CENTER)


	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Close FTP group

	; Samba Group

	$SAMBA_Group = GUICtrlCreateGroup("SAMBA/CIFS", $NTS_SettingsFormWidth*0.50, 50, $NTS_SettingsFormWidth*0.48, $NTS_SettingsFormHeight*0.38)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($SAMBA_Group), "wstr", 0, "wstr", 0) ; Skip current windows theme for group element
	GUICtrlSetFont(-1, $Current_DPI[1]+1, $Current_DPI[2]+400, 0, $NTS_SettingsFormGroupFont)

	GUICtrlCreateLabel("Disk letter ", $NTS_SettingsFormWidth*0.52, 83, 150, 20)
	$SAMBA_DiskLetter_ctrl=GUICtrlCreateCombo(StringUpper($SAMBA_DiskLetter), $NTS_SettingsFormWidth*0.7, 80, 100, 30, $SS_RIGHT)

	; Check problems
	If $NAS_SMB_Disk<>1 Then
		GUICtrlSetColor(-1, $NTS_SettingsFormBadFontColor)
		GUICtrlSetBkColor(-1, $NTS_SettingsFormBadBackgroundColor)
		GUICtrlSetTip(-1, "Problem with this disk") ; Need more info
	Elseif $NAS_SMB_Disk_Found<>1 Then
		GUICtrlSetColor(-1, $NTS_SettingsFormBadFontColor)
		GUICtrlSetBkColor(-1, $NTS_SettingsFormBadBackgroundColor)
		GUICtrlSetTip(-1, "This disk not present in system!")
	EndIf

	GUICtrlSetData(-1, $Local_Disks_List, StringUpper($SAMBA_DiskLetter))

	GUICtrlCreateLabel("SAMBA Folder", $NTS_SettingsFormWidth*0.52, 136, 100, 20)
	$SAMBA_Folder_ctrl=GUICtrlCreateInput($SAMBA_Folder, $NTS_SettingsFormWidth*0.72, 135, 150, 20, $SS_LEFT)

	$SAMBA_Anon_ctrl=GUICtrlCreateCheckbox("Login anonymously ", $NTS_SettingsFormWidth*0.52, 107, 150, 20)
	;GUICtrlSetState ($SAMBA_Anon_ctrl, $GUI_DISABLE)

	GUICtrlCreateLabel("Login (in dev)", $NTS_SettingsFormWidth*0.52, 166, 120, 20)
	$SAMBA_Login_ctrl=GUICtrlCreateInput($SAMBA_Login, $NTS_SettingsFormWidth*0.72, 165, 100, 20, $SS_CENTER)


	GUICtrlCreateLabel("Password (in dev)", $NTS_SettingsFormWidth*0.52, 196, 120, 20)
	$SAMBA_Password_ctrl=GUICtrlCreateInput($SAMBA_Password, $NTS_SettingsFormWidth*0.72, 195, 100, 20, $SS_CENTER)

	; Pass the checkbox of samba
	If $SAMBA_Login==$SAMBA_Default_login and $SAMBA_Password==$SAMBA_Default_pass Then

		GUICtrlSetState($SAMBA_Anon_ctrl, $GUI_CHECKED)
		GUICtrlSetState($SAMBA_Login_ctrl, $GUI_DISABLE)
		GUICtrlSetState($SAMBA_Password_ctrl, $GUI_DISABLE)

		Else

		GUICtrlSetState($SAMBA_Anon_ctrl, $GUI_UNCHECKED)

	EndIf

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Close samba group

	; HTTP/WebDav Group

	$HTTP_Group = GUICtrlCreateGroup("HTTP/WebDav", 10, $NTS_SettingsFormHeight*0.50, $NTS_SettingsFormWidth*0.96, $NTS_SettingsFormHeight*0.37)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($HTTP_Group), "wstr", 0, "wstr", 0) ; Skip current windows theme for group element
	GUICtrlSetFont(-1, $Current_DPI[1]+1, $Current_DPI[2]+400, 0, $NTS_SettingsFormGroupFont)

	GUICtrlCreateLabel("HTTP address", 20, $NTS_SettingsFormHeight*0.55, 100, 20)

		If $HTTP_Address<>"" Then
			If $HTTP_Port=="80" Or $HTTP_Port=="" Then
				$HTTP_Address_Full="http://" & $NetworkAdapterIp & "/"
			Else
				$HTTP_Address_Full="http://" & $NetworkAdapterIp & ":" & $HTTP_Port & "/"
			EndIf
		Else
			$HTTP_Address_Full=$HTTP_Address
		EndIf

	$HTTP_Address_ctrl=GUICtrlCreateInput($HTTP_Address_Full, 20, $NTS_SettingsFormHeight*0.60, $NTS_SettingsFormWidth*0.87, 20, $SS_LEFT)

	GUICtrlCreateLabel("Port", 20, $NTS_SettingsFormHeight*0.65, 100, 20)
	$HTTP_Port_ctrl=GUICtrlCreateInput($HTTP_Port, 100, $NTS_SettingsFormHeight*0.65, 100, 20, $SS_CENTER)

	$HTTP_NoAnon_ctrl=GUICtrlCreateCheckbox("Login with credits (in develop)", 20, $NTS_SettingsFormHeight*0.70, 200, 20)

	GUICtrlCreateLabel("Login", $NTS_SettingsFormWidth*0.52, $NTS_SettingsFormHeight*0.65, 100, 20)
	$HTTP_Login_ctrl=GUICtrlCreateInput($HTTP_Login, $NTS_SettingsFormWidth*0.7, $NTS_SettingsFormHeight*0.65, 100, 20, $SS_CENTER)

	GUICtrlCreateLabel("Password", $NTS_SettingsFormWidth*0.52, $NTS_SettingsFormHeight*0.70, 100, 20)
	$HTTP_Password_ctrl=GUICtrlCreateInput($HTTP_Password, $NTS_SettingsFormWidth*0.7, $NTS_SettingsFormHeight*0.7, 100, 20, $SS_CENTER)


	; Pass the checkbox of http
	If $HTTP_Login==$HTTP_Default_login and $HTTP_Password==$HTTP_Default_pass Then

		GUICtrlSetState($HTTP_NoAnon_ctrl, $GUI_UNCHECKED)
		GUICtrlSetState($HTTP_Login_ctrl, $GUI_DISABLE)
		GUICtrlSetState($HTTP_Password_ctrl, $GUI_DISABLE)

		Else

		GUICtrlSetState($HTTP_NoAnon_ctrl, $GUI_CHECKED)


	EndIf

	; Close HTTP group

	; Main buttons

	$SetButton = GUICtrlCreateButton("Set", $NTS_SettingsFormWidth*0.33, $NTS_SettingsFormHeight*0.95, 100, 30)
	$ExitButton = GUICtrlCreateButton("Exit", $NTS_SettingsFormWidth*0.55, $NTS_SettingsFormHeight*0.95, 100, 30)

;
; GUI messages loop
;

While 1

   Switch GUIGetMsg()

	; Changing NAS IP

	Case $NAS_IP_ctrl

		; Need check IP address to letters and numbers

		If StringStripWS(GUICtrlRead ($NAS_IP_ctrl),8)<>"" Then
			$NetworkAdapterIp=StringStripWS(GUICtrlRead ($NAS_IP_ctrl),8)
			history ("NAS IP changed to " & $NetworkAdapterIp)
			GUICtrlSetColor($NAS_IP_ctrl, 0x000000)
			GUICtrlSetBkColor($NAS_IP_ctrl, 0xFFFFFF)
			GUICtrlSetTip($NAS_IP_ctrl,"")


				If StringStripWS(GUICtrlRead($HTTP_Port_ctrl),8)=="" or StringStripWS(GUICtrlRead($HTTP_Port_ctrl),8)=="80" Then
					$HTTP_Address_Full="http://" & $NetworkAdapterIp & "/"
				Else
					$HTTP_Address_Full="http://" & $NetworkAdapterIp & ":" & StringStripWS(GUICtrlRead($HTTP_Port_ctrl),8) & "/"
				EndIf

				GUICtrlSetData($HTTP_Address_ctrl, $HTTP_Address_Full)
				GUICtrlSetData($HTTP_Port_ctrl, StringStripWS(GUICtrlRead($HTTP_Port_ctrl),8))


			GUICtrlSetState($SetButton,$GUI_ENABLE)
		Else
			GUICtrlSetColor($NAS_IP_ctrl, $NTS_SettingsFormBadFontColor)
			GUICtrlSetBkColor($NAS_IP_ctrl, $NTS_SettingsFormBadBackgroundColor)
			GUICtrlSetTip($NAS_IP_ctrl, "NAS IP address must be set!")
			GUICtrlSetState($SetButton,$GUI_DISABLE)
		EndIf

	; Changing Samba drive letter

	Case $SAMBA_DiskLetter_ctrl

		; Need check disk

		history ("Disk changed to " & GUICtrlRead ($SAMBA_DiskLetter_ctrl))
		GUICtrlSetColor($SAMBA_DiskLetter_ctrl, 0x000000)
		GUICtrlSetBkColor($SAMBA_DiskLetter_ctrl, 0xFFFFFF)
		GUICtrlSetTip($SAMBA_DiskLetter_ctrl,"")

	; Changing anon login to samba, working this, but disabled at all (in dev)

	Case $SAMBA_Anon_ctrl

		If (BitAnd(GUICtrlRead($SAMBA_Anon_ctrl), $GUI_CHECKED)) = $GUI_CHECKED Then
			history ("Samba guest login enabled")
			GUICtrlSetState($SAMBA_Login_ctrl, $GUI_DISABLE)
			GUICtrlSetState($SAMBA_Password_ctrl, $GUI_DISABLE)
			GUICtrlSetData($SAMBA_Login_ctrl, $SAMBA_Default_login)
			GUICtrlSetData($SAMBA_Password_ctrl, $SAMBA_Default_pass)
		Elseif (BitAnd(GUICtrlRead($SAMBA_Anon_ctrl), $GUI_UNCHECKED)) = $GUI_UNCHECKED Then
			history ("Samba guest login disabled")
			GUICtrlSetState($SAMBA_Login_ctrl, $GUI_ENABLE)
			GUICtrlSetState($SAMBA_Password_ctrl, $GUI_ENABLE)
			GUICtrlSetData($SAMBA_Login_ctrl, $SAMBA_Login)
			GUICtrlSetData($SAMBA_Password_ctrl, $SAMBA_Password)
		EndIf

	; Use creditals to interact with HTTP (in dev)

	Case $HTTP_NoAnon_ctrl

		If (BitAnd(GUICtrlRead($HTTP_NoAnon_ctrl), $GUI_CHECKED)) = $GUI_CHECKED Then
			history ("HTTP login with credits enabled")
			GUICtrlSetState($HTTP_Login_ctrl, $GUI_ENABLE)
			GUICtrlSetState($HTTP_Password_ctrl, $GUI_ENABLE)
		Elseif (BitAnd(GUICtrlRead($HTTP_NoAnon_ctrl), $GUI_UNCHECKED)) = $GUI_UNCHECKED Then
			history ("HTTP login with credits disabled")
			GUICtrlSetState($HTTP_Login_ctrl, $GUI_DISABLE)
			GUICtrlSetState($HTTP_Password_ctrl, $GUI_DISABLE)
			GUICtrlSetData($HTTP_Login_ctrl, $HTTP_Default_login)
			GUICtrlSetData($HTTP_Password_ctrl, $HTTP_Default_Pass)
		EndIf

	; Changing HTTP port
	Case $HTTP_Port_ctrl

		;If Number(GUICtrlRead($HTTP_Port_ctrl))<>0 Then ; Need more correct check, "8080s" working...

			If StringStripWS(GUICtrlRead($HTTP_Port_ctrl),8)=="" or StringStripWS(GUICtrlRead($HTTP_Port_ctrl),8)=="80" Then
				$HTTP_Address_Full="http://" & $NetworkAdapterIp & "/"

			Else
				$HTTP_Address_Full="http://" & $NetworkAdapterIp & ":" & StringStripWS(GUICtrlRead($HTTP_Port_ctrl),8) & "/"
			EndIf

			GUICtrlSetData($HTTP_Address_ctrl, $HTTP_Address_Full)
			GUICtrlSetData($HTTP_Port_ctrl, StringStripWS(GUICtrlRead($HTTP_Port_ctrl),8))

		;EndIf

	; Anon FTP settings
	Case $FTP_Anon_ctrl

		If (BitAnd(GUICtrlRead($FTP_Anon_ctrl), $GUI_CHECKED)) = $GUI_CHECKED Then

			history ("FTP login without credits enabled")
			GUICtrlSetState($FTP_Login_ctrl, $GUI_DISABLE)
			GUICtrlSetState($FTP_Password_ctrl, $GUI_DISABLE)
			GUICtrlSetData($FTP_Login_ctrl, $FTP_Anon_login)
			GUICtrlSetData($FTP_Password_ctrl, $FTP_Anon_pass)

		Elseif (BitAnd(GUICtrlRead($FTP_Anon_ctrl), $GUI_UNCHECKED)) = $GUI_UNCHECKED Then

			history ("FTP login with credits enable")
			GUICtrlSetState($FTP_Login_ctrl, $GUI_ENABLE)
			GUICtrlSetState($FTP_Password_ctrl, $GUI_ENABLE)
			GUICtrlSetData($FTP_Login_ctrl, $FTP_Login)
			GUICtrlSetData($FTP_Password_ctrl, $FTP_Password)

		EndIf


	; Apply changes to ini file

	Case $SetButton

		; NAS IP
		IniWrite($inifile, "Network", "NAS_IP", GUICtrlRead($NAS_IP_ctrl) )

		; FTP settings
		IniWrite($inifile, "Network", "FTP_Port", GUICtrlRead($FTP_Port_ctrl) )
		IniWrite($inifile, "Network", "FTP_Folder", GUICtrlRead($FTP_Folder_ctrl) )
		IniWrite($inifile, "Network", "FTP_Login", GUICtrlRead($FTP_Login_ctrl) )
		IniWrite($inifile, "Network", "FTP_Password", GUICtrlRead($FTP_Password_ctrl) )

		If (BitAnd(GUICtrlRead($FTP_Passive_ctrl), $GUI_CHECKED)) = $GUI_CHECKED Then
			IniWrite($inifile, "Network", "FTP_Passive", 1)
		Else
			IniWrite($inifile, "Network", "FTP_Passive", 0)
		EndIf

		; Samba settings
		IniWrite($inifile, "Network", "SMB_Letter", GUICtrlRead($SAMBA_DiskLetter_ctrl) )
		IniWrite($inifile, "Network", "SMB_Folder", GUICtrlRead($SAMBA_Folder_ctrl) )
		IniWrite($inifile, "Network", "SMB_Login", GUICtrlRead($SAMBA_Login_ctrl) )
		IniWrite($inifile, "Network", "SMB_Password", GUICtrlRead($SAMBA_Password_ctrl) )

		; HTTP settings
		IniWrite($inifile, "Network", "HTTP_Login", GUICtrlRead($HTTP_Login_ctrl) )
		IniWrite($inifile, "Network", "HTTP_Password", GUICtrlRead($HTTP_Password_ctrl) )
		IniWrite($inifile, "Network", "HTTP_Port", GUICtrlRead($HTTP_Port_ctrl) )
		IniWrite($inifile, "Network", "HTTP_Address", GUICtrlRead($HTTP_Address_ctrl) )



	; Cancel settings or close window
	Case $GUI_EVENT_CLOSE, $ExitButton

		history ("Main GUI destroyed — " & GUIDelete($mainGui) & ". Settings not applied.")

		ExitLoop

	EndSwitch

WEnd


#include "Libs\foot.au3"
