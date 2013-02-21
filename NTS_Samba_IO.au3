#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: Nas Test Script
 Site: https://github.com/spikerwork/NasTestScript

 Script Function:

   IOmeter Samba test for Nas Test Script

#ce ----------------------------------------------------------------------------

#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Icon=nas.ico
#AutoIt3Wrapper_Res_Comment="Nas Test Script"
#AutoIt3Wrapper_Res_Description="Nas Test Script"
#AutoIt3Wrapper_Res_Fileversion=0.1.2.3
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Nas Test Script
#AutoIt3Wrapper_Res_Field=ProductVersion|0.1.2.x
#AutoIt3Wrapper_Res_Field=OriginalFilename|NTS_Samba_IO.au3
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"

EnvSet("SEE_MASK_NOZONECHECKS", "1")
EnvUpdate ( )

Local $TestResult ; Result of test
Local $PathToSamba = $SAMBA_DiskLetter & "\\" & $NAS_IP & "\" & $SAMBA_Share ; Special line for IOmeter
Local $szFile, $szText
Local $IO_Folder=$ScriptFolder & "\Apps\iometer"
$szFile = $ScriptFolder & "\Apps\iometer\iometer_SAMBA.icf"

history("Path to Samba share - " & $PathToSamba)

If $CmdLine[0]>=3 Then

history ("From CMD recieved parameters for test: " & $CmdLine[1] & ", " & $CmdLine[2] & ", " & $CmdLine[3])

NASMount (1)

	Switch $CmdLine[2]

		Case "Prepare"

			; Copy nessasary files to folder

			history("Start Prepare Run")




			$szText = FileRead($szFile,FileGetSize($szFile))
			$szText = StringReplace($szText, "K:\\10.0.0.99\IxiaChariot", $PathToSamba)
			FileDelete($szFile)
			FileWrite($szFile,$szText)
			Sleep(2000)
			ShellExecuteWait($IO_Folder & "\" &"IOMETER.exe", "iometer_SAMBA.icf results.csv",$IO_Folder)


			$TestResult="Pass"

		Case "IOTest"

			history("IOmeter test")


			$TestResult=$Speed




	EndSwitch

IniWrite($testsini, $CmdLine[1], $CmdLine[2], 1)
IniWrite($resultini, $CmdLine[1], $CmdLine[2] & "#" & $CmdLine[3], $TestResult)

NASMount (0)
halt("reboot")

EndIf

#include "Libs\foot.au3"
