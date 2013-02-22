#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: Nas Test Script
 Site: https://github.com/spikerwork/NasTestScript

 Script Function:

   NASPT Samba test for Nas Test Script

#ce ----------------------------------------------------------------------------

#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Icon=nas.ico
#AutoIt3Wrapper_Res_Comment="Nas Test Script"
#AutoIt3Wrapper_Res_Description="Nas Test Script"
#AutoIt3Wrapper_Res_Fileversion=0.1.2.20
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Nas Test Script
#AutoIt3Wrapper_Res_Field=ProductVersion|0.1.2.x
#AutoIt3Wrapper_Res_Field=OriginalFilename|NTS_Samba_NASPT.au3
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
Local $NASPTRun=$App_NASPT_folder & "\" & $App_NASPT
Local $PathToSambaFolder
Local $NASName="NASPT"

If $SAMBA_Folder=="" Then
	$PathToSambaFolder = $SAMBA_DiskLetter & "\" & $Temp_Folder ; Path to folder on NAS (without addition directory)
Else
	$PathToSambaFolder = $SAMBA_DiskLetter & "\" & $SAMBA_Folder & "\" & $Temp_Folder ; Path to folder on NAS (with addition directory)
EndIf
Local $Resultfile, $filecsvdir,  $filecsv="NASPerf-APP.csv"

history("Path to Samba - " & $PathToSambaFolder)
history("Application - " & $App_NASPT)
history("Application folder - " & $App_NASPT_folder)

If $CmdLine[0]>=3 Then

history ("From CMD recieved parameters for test: " & $CmdLine[1] & ", " & $CmdLine[2] & ", " & $CmdLine[3])

NASMount (1)

	Switch $CmdLine[2]

		Case "Prepare"

			; Copy nessasary files to folder

			history("Prepare Run")

			history("Start NASPT - " & $NASPTRun)

			Run($NASPTRun, $App_NASPT_folder)

			WinWaitActive("Large Memory Size")
			ControlClick("Large Memory Size", "", "[CLASS:Button; INSTANCE:1]")

			WinWaitActive("NASPT support notice")
			ControlClick("NASPT support notice", "", "[CLASS:Button; INSTANCE:1]")

			WinWaitActive("NAS Performance Toolkit - Exerciser")

			Sleep(2000)
			Send("{RIGHT 6}")
			Sleep(1000)
			Send("{ENTER}")
			Sleep(2000)
			Send($SAMBA_DiskLetter & "\" & $Temp_Folder)
			Send("{TAB}")
			Sleep(2000)
			Send($ScriptFolder & "\" & $resultfolder)
			Send("{ENTER}")
			Sleep(2000)
			Send("{TAB}")
			Send($NASName)
			Sleep(2000)
			Send("{TAB 22} ")
			Sleep(2000)
			Send("{ENTER}")
			Sleep(2000)
			Send("{TAB}")
			Sleep(2000)
			Send("{RIGHT 2}")
			Sleep(2000)
			Send("{ENTER}")

			WinWaitActive("Prepare?")
			ControlClick("Prepare?", "", "[CLASS:Button; INSTANCE:1]")

			WinWaitActive("NASPT Configuration")
			ControlClick("NASPT Configuration", "", "[CLASS:Button; INSTANCE:1]")

			WinWaitActive("Invalid Directory")
			ControlClick("Invalid Directory", "", "[CLASS:Button; INSTANCE:1]")


			WinWaitActive("Application Preparation Result")
			Send("{ENTER}")

			PauseTime($ClientPause)

			If ProcessExists($App_NASPT) Then ProcessClose($App_NASPT)

			PauseTime($ClientPause)

			$TestResult="Pass"

		Case "NASPTRun"

			history("NASPT main test")

			history("Start NASPT - " & $NASPTRun)

			Run($NASPTRun, $App_NASPT_folder)

			WinWaitActive("Large Memory Size")
			ControlClick("Large Memory Size", "", "[CLASS:Button; INSTANCE:1]")

			WinWaitActive("NASPT support notice")
			ControlClick("NASPT support notice", "", "[CLASS:Button; INSTANCE:1]")

			WinWaitActive("NAS Performance Toolkit - Exerciser")

			;PauseTime($ClientPause+50)
			Sleep(2000)
			Send("{RIGHT 6}")
			Sleep(1000)
			Send("{ENTER}")
			Sleep(2000)
			Send($SAMBA_DiskLetter & "\" & $Temp_Folder)
			Send("{TAB}")
			Sleep(2000)
			Send($ScriptFolder & "\" & $resultfolder)
			Send("{ENTER}")
			Sleep(2000)
			Send("{TAB}")
			Send($NASName)
			Sleep(2000)
			Send("{TAB 22} ")
			Sleep(2000)
			Send("{ENTER}")
			Sleep(2000)
			Send("{TAB}")
			Sleep(2000)
			Send("{ENTER}")

			WinWaitActive("NASPT Configuration")
			ControlClick("NASPT Configuration", "", "[CLASS:Button; INSTANCE:1]")

			WinWaitActive("Prepare?")
			ControlClick("Prepare?", "", "[CLASS:Button; INSTANCE:1]")

			;PauseTime($ClientPause+5000)

			;WinWaitActive("Application Preparation Result")
			;Send("{ENTER}")

			$filecsvdir = $ScriptFolder & "\" & $resultfolder & "\" & $NASName & "\Model"

			_FileListToArray($filecsvdir)


			$Resultfile=$CmdLine[2] & "_" & $CmdLine[3] & ".ini"

			Local $file = FileOpen($filecsv, 0)
			Local $line, $result
			Dim $array

			For $i=3 to 14

			$line = FileReadLine($file,$i)

			$array = _StringExplode($line, ",", 0)
			$result=StringReplace($array[1], ".", ",")
			IniWrite($Resultfile, "Run3", $array[0], $result)
			;MsgBox(0,"",$result)
			Next





			If ProcessExists($App_NASPT) Then ProcessClose($App_NASPT)

			PauseTime($ClientPause)


			$TestResult=$Resultfile


	EndSwitch

IniWrite($testsini, $CmdLine[1], $CmdLine[2], 1)
IniWrite($resultini, $CmdLine[1], $CmdLine[2] & "#" & $CmdLine[3], $TestResult)

NASMount (0)
halt("reboot")

EndIf

#include "Libs\foot.au3"
