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
#AutoIt3Wrapper_Res_Fileversion=0.1.3.2
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Nas Test Script
#AutoIt3Wrapper_Res_Field=ProductVersion|0.1.3.x
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

AdlibRegister("NASPT_windows",1000) ; Catch emerging windows from NASPT

Local $TestResult ; Result of test
Local $NASPTRun=$App_NASPT_folder & "\" & $App_NASPT ; Exe file of NASPT
Local $PathToSambaFolder ; Folder wich will contains test files on NAS
Local $NASName="NASPT" ; Name of folder.. maybe enjoy it in future by adding name of wich test
Dim $Folders_array ;

Local $line, $result, $file ; Some local vars, needed to store results.
Dim $array

If $SAMBA_Folder=="" Then
	$PathToSambaFolder = $SAMBA_DiskLetter & "\" & $Temp_Folder ; Path to folder on NAS (without addition directory)
Else
	$PathToSambaFolder = $SAMBA_DiskLetter & "\" & $SAMBA_Folder & "\" & $Temp_Folder ; Path to folder on NAS (with addition directory)
EndIf
Local $Resultfile, $filecsv = $App_NASPT_csv

history("Path to Samba - " & $PathToSambaFolder)
history("Application - " & $App_NASPT)
history("Application folder - " & $App_NASPT_folder)

If $CmdLine[0]>=3 Then

history ("From CMD recieved parameters for test: " & $CmdLine[1] & ", " & $CmdLine[2] & ", " & $CmdLine[3])

NASMount (1)

	Switch $CmdLine[2]

		Case "Prepare"

			; Start prepare NASPT run

			history("Prepare Run")

			history("Start NASPT - " & $NASPTRun)

			Run($NASPTRun, $App_NASPT_folder)

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

			WinWaitActive("Application Preparation Result")

			Send("{ENTER}")

			PauseTime($ClientPause)

			If ProcessExists($App_NASPT) Then ProcessClose($App_NASPT)

			PauseTime($ClientPause)

			$TestResult="Pass"

		Case "NASPTRun"

			; Main test

			history("NASPT main test")

			history("Start NASPT - " & $NASPTRun)

			Run($NASPTRun, $App_NASPT_folder)

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
			Send("{ENTER}")

			WinWaitActive("Application Test Result")

			Send("{ENTER}")

			Sleep(5000) ; Time to catch window - "NASPT Test Complete" by NASPT_windows()

			PauseTime($ClientPause)

			If ProcessExists($App_NASPT) Then ProcessClose($App_NASPT)

			history("NASPT closed, start to sort results.")

			PauseTime($ClientPause)

			$Folders_array=_FileListToArray($ScriptFolder & "\" & $resultfolder & "\" & $NASName & "\Model")
			$filecsv = $ScriptFolder & "\" & $resultfolder & "\" & $NASName & "\Model\" & $Folders_array[1] & "\" & $filecsv
			$Resultfile= $ScriptFolder & "\" & $resultfolder & "\" & $CmdLine[2] & ".ini"
			history("CSV file contatins results - " & $filecsv)
			history("INI-file to write results - " & $Resultfile)

			$file = FileOpen($filecsv, 0)

			For $i=3 to 14

				$line = FileReadLine($file,$i)
				$array = _StringExplode($line, ",", 0)
				$result=StringReplace($array[1], ".", ",")
				IniWrite($Resultfile, "Run" & $CmdLine[3], $array[0], $result)

			Next

			PauseTime($ClientPause)

			$TestResult=$Resultfile

	EndSwitch

IniWrite($testsini, $CmdLine[1], $CmdLine[2], 1)
IniWrite($resultini, $CmdLine[1], $CmdLine[2] & "#" & $CmdLine[3], $TestResult)

NASMount (0)
halt("reboot")

EndIf

#include "Libs\foot.au3"
