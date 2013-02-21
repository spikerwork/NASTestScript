#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: Nas Test Script
 Site: https://github.com/spikerwork/NasTestScript

 Script Function:

   Samba double test for Nas Test Script

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
#AutoIt3Wrapper_Res_Field=OriginalFilename|NTS_Samba_UD.au3
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"

EnvSet("SEE_MASK_NOZONECHECKS", "1")
EnvUpdate ( )

Local $TestResult ; Result var
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

If $CmdLine[0]>=3 Then

history ("From CMD recieved parameters for daemon: " & $CmdLine[1] & ", " & $CmdLine[2] & ", " & $CmdLine[3])

	Switch $CmdLine[2]

		Case "CopyFromAndTo"

			history("This daemon copy files to nas.")

			$CopyStartTime=GetUnixTimeStamp()

			_WinAPI_ShellFileOperation($SambaFiles, $PathToSambaFolder, $FO_COPY, BitOR($FOF_NOCONFIRMATION, $FOF_NOCONFIRMMKDIR, $FOF_RENAMEONCOLLISION, $FOF_SIMPLEPROGRESS))

			$CopyStopTime=GetUnixTimeStamp()

			$CopyTime=$CopyStopTime-$CopyStartTime
			$Speed=$SourceSize/1024/1024/$CopyTime

			history("Total time - " & $CopyTime)
			history("Average speed - " & $Speed)

			$TestResult=$Speed

	EndSwitch

IniWrite($resultini, $CmdLine[1], $CmdLine[2] & "# Upload Daemon #" & $CmdLine[3], $TestResult)

EndIf

#include "Libs\foot.au3"
