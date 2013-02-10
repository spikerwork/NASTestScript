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

Local $adapters=0
Local $PhyAdapters=0
Local $t=0

If $ScriptInstalled==1 Then MsgBox(0,"","INI file found. Vars will be overwriten.")

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


MsgBox(0, $MainAdapter, $MainAdapter_ip & "|" & $MainAdapter_netmask & "|" & $MainAdapter_MAC & "|" & $Adapter_GUID)


#include "Libs\foot.au3"
