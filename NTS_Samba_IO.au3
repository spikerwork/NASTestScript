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
#AutoIt3Wrapper_Res_Fileversion=0.1.3.2
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Nas Test Script
#AutoIt3Wrapper_Res_Field=ProductVersion|0.1.3.x
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

Local $PathToSamba = $SAMBA_DiskLetter & "\\" & $NAS_IP & "\" & $SAMBA_Share ; Special line for IOmeter
Local $TestResult ; Result of test
Local $szText, $Resultfile

$App_IOmeter_conf = $ScriptFolder & "\" & $Temp_Folder & "\" & $App_IOmeter_conf ; Full path to changing config
$App_IOmeter_defconf = $ScriptFolder & "\" &$App_IOmeter_folder & "\" & $App_IOmeter_defconf ; Full path to changing config
$App_IOmeter=$ScriptFolder & "\" & $App_IOmeter_folder & "\" & $App_IOmeter ; Full path to IOmeter

history("Path to Samba share - " & $PathToSamba)
history("Application - " & $App_IOmeter)
history("Default configuration file - " & $App_IOmeter_defconf)
history("New configuration file - " & $App_IOmeter_conf)

If $CmdLine[0]>=3 Then

history ("From CMD recieved parameters for test: " & $CmdLine[1] & ", " & $CmdLine[2] & ", " & $CmdLine[3])

NASMount (1)

	Switch $CmdLine[2]

		Case "Prepare"

			; Copy nessasary files to folder

			history("Start Prepare Run")

			$Resultfile=$ScriptFolder & "\" & $Temp_Folder & "\" & "result_" & $CmdLine[3] & ".csv"
			$szText = FileRead($App_IOmeter_defconf,FileGetSize($App_IOmeter_defconf))
			$szText = StringReplace($szText, "K:\\10.0.0.99\IxiaChariot", $PathToSamba)
			$App_IOmeter_testsize=$App_IOmeter_testsize*1024*1024*2 ; Disk size to test
			$szText = StringReplace($szText, "83886080", $App_IOmeter_testsize)
			history("Set new testdisk to " & $PathToSamba & " and new testsize to " & $App_IOmeter_testsize)
			FileWrite($App_IOmeter_conf,$szText)
			Sleep(2000)
			history("Start IOmeter - " & $App_IOmeter & " " & $App_IOmeter_conf & " " & $Resultfile & " in " & $App_IOmeter_folder)
			ShellExecuteWait($App_IOmeter, $App_IOmeter_conf & " " & $Resultfile, $App_IOmeter_folder)

			$TestResult="Pass"

		Case "IOTest"

			history("IOmeter main test")

			$Resultfile=$ScriptFolder & "\" & $resultfolder & "\" & "Result_Samba_IO_" & $CmdLine[3] & ".csv"
			Sleep(2000)
			history("Start IOmeter - " & $App_IOmeter & " " & $App_IOmeter_conf & " " & $Resultfile & " in " & $App_IOmeter_folder)
			ShellExecuteWait($App_IOmeter, $App_IOmeter_conf & " " & $Resultfile, $App_IOmeter_folder)

			$TestResult=$Resultfile


	EndSwitch

IniWrite($testsini, $CmdLine[1], $CmdLine[2], 1)
IniWrite($resultini, $CmdLine[1], $CmdLine[2] & "#" & $CmdLine[3], $TestResult)

NASMount (0)
halt("reboot")

EndIf

#include "Libs\foot.au3"
