#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: Nas Test Script
 Site: https://github.com/spikerwork/NasTestScript

 Script Function:

   Samba test for Nas Test Script

#ce ----------------------------------------------------------------------------

#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Icon=nas.ico
#AutoIt3Wrapper_Res_Comment="Nas Test Script"
#AutoIt3Wrapper_Res_Description="Nas Test Script"
#AutoIt3Wrapper_Res_Fileversion=0.1.3.8
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Nas Test Script
#AutoIt3Wrapper_Res_Field=ProductVersion|0.1.3.x
#AutoIt3Wrapper_Res_Field=OriginalFilename|NTS_Samba.au3
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
Local $CopyStartTime, $CopyStopTime, $CopyTime, $Speed ; Start Stop and other vars
Local $PathToSambaFolder

Local $SambaFiles = $ScriptFolder & "\" & $Content_Folder & "\" & $App_Samba_Files ; Destination of files to test

If $SAMBA_Folder=="" Then
	$PathToSambaFolder = $SAMBA_DiskLetter & "\" & $Temp_Folder ; Path to folder on NAS (without addition directory)
Else
	$PathToSambaFolder = $SAMBA_DiskLetter & "\" & $SAMBA_Folder & "\" & $Temp_Folder ; Path to folder on NAS (with addition directory)
EndIf

Local $PathToCompFolder=$ScriptFolder & "\" & $Temp_Folder ; Path to temp directory on computer

Local $SourceSize=DirGetSize($SambaFiles) ; Size of test files

history("PathToSambaFolder - " & $PathToSambaFolder)
history("SambaFiles - " & $SambaFiles)
history("Folder on computer, to delete - " & $PathToCompFolder)

If $CmdLine[0]>=3 Then

history ("From CMD recieved parameters for test: " & $CmdLine[1] & ", " & $CmdLine[2] & ", " & $CmdLine[3])

NASMount (1)
;ShellExecute($PathToSambaFolder)
;PauseTime($ClientPause)
;Send("!{F4}")

	Switch $CmdLine[2]

		Case "Prepare"

			; Copy nessasary files to folder

			history("Start Prepare Run")
			DirCreate ($PathToSambaFolder)

			_WinAPI_ShellFileOperation($SambaFiles, $PathToSambaFolder, $FO_COPY, BitOR($FOF_NOCONFIRMATION, $FOF_NOCONFIRMMKDIR, $FOF_RENAMEONCOLLISION, $FOF_SIMPLEPROGRESS))

			$TestResult="Pass"

		Case "FromNas"

			history("Copy files from nas")

			$CopyStartTime=GetUnixTimeStamp()

			_WinAPI_ShellFileOperation($PathToSambaFolder & "\" & $App_Samba_Files, $PathToCompFolder, $FO_COPY, BitOR($FOF_NOCONFIRMATION, $FOF_NOCONFIRMMKDIR, $FOF_RENAMEONCOLLISION, $FOF_SIMPLEPROGRESS))

			$CopyStopTime=GetUnixTimeStamp()

			$CopyTime=$CopyStopTime-$CopyStartTime
			$Speed=$SourceSize/1024/1024/$CopyTime

			PauseTime($ClientPause)

			history("Time - " & $CopyTime)
			history("Speed - " & $Speed)

			$TestResult=$Speed


		Case "CopyToNas"

			history("Copy files to nas")

			$CopyStartTime=GetUnixTimeStamp()

			_WinAPI_ShellFileOperation($SambaFiles, $PathToSambaFolder, $FO_COPY, BitOR($FOF_NOCONFIRMATION, $FOF_NOCONFIRMMKDIR, $FOF_RENAMEONCOLLISION, $FOF_SIMPLEPROGRESS))

			$CopyStopTime=GetUnixTimeStamp()

			$CopyTime=$CopyStopTime-$CopyStartTime
			$Speed=$SourceSize/1024/1024/$CopyTime

			PauseTime($ClientPause)

			history("Time - " & $CopyTime)
			history("Speed - " & $Speed)

			$TestResult=$Speed


		Case "CopyFromAndTo"

			history("Simultaneously copy to nas and from nas.")
			history("This daemon copy files from nas.")

			ShellExecute($ScriptFolder & "\" & $NTS_Samba_UD, $CmdLine[1] & " " & $CmdLine[2] & " " & $CmdLine[3], $ScriptFolder)

			$CopyStartTime=GetUnixTimeStamp()

			_WinAPI_ShellFileOperation($PathToSambaFolder & "\" & $App_Samba_Files, $PathToCompFolder, $FO_COPY, BitOR($FOF_NOCONFIRMATION, $FOF_NOCONFIRMMKDIR, $FOF_RENAMEONCOLLISION, $FOF_SIMPLEPROGRESS))

			$CopyStopTime=GetUnixTimeStamp()

			$CopyTime=$CopyStopTime-$CopyStartTime
			$Speed=$SourceSize/1024/1024/$CopyTime

			PauseTime($ClientPause)

			history("Total time - " & $CopyTime)
			history("Average speed - " & $Speed)

			$TestResult=$Speed

			While 1
			If ProcessExists("NTS_Samba_UD.exe")=0 Then
				ExitLoop
			EndIf
			Wend

			history("Upload daemon exit")

	EndSwitch

IniWrite($testsini, $CmdLine[1], $CmdLine[2], 1)
IniWrite($resultini, $CmdLine[1], $CmdLine[2] & "#" & $CmdLine[3], $TestResult)

NASMount (0)
halt("reboot")

EndIf

#include "Libs\foot.au3"
