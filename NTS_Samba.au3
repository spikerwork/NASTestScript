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
#AutoIt3Wrapper_Res_Fileversion=0.0.1.17
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Nas Test Script
#AutoIt3Wrapper_Res_Field=ProductVersion|0.0.1.x
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

Local $TestResult
Local $SambaFiles = @ScriptDir & "\" & $Content_Folder & "\" & $App_Samba_Files ; Destination of files to test
Local $PathToSambaFolder ; Path to folder on NAS (with addition directory)
$PathToSambaFolder=$SAMBA_DiskLetter & "\" & $SAMBA_Folder
$PathToSambaFolder=StringReplace($PathToSambaFolder, "\\", "\")
$PathToSambaFolder=StringReplace($PathToSambaFolder, "/", "\")
Local $PathToCompFolder=@ScriptDir & "\" & $Temp_Folder & "\" & $App_Samba_Files & "_Temp" ; Path to temp directory on computer
Local $CopyStartTime, $CopyStopTime, $CopyTime, $Speed ; Start Stop and other vars

Local $SourceSize=DirGetSize($SambaFiles) ; Size of test files

history("PathToSambaFolder - " & $PathToSambaFolder)
history("SambaFiles - " & $SambaFiles)
history("Folder on nas, to delete - " & $PathToSambaFolder & "\" & $App_Samba_Files)
history("Folder on computer, to delete - " & $PathToCompFolder)

If $CmdLine[0]>=3 Then history ("From CMD recieved parameters for test: " & $CmdLine[1] & ", " & $CmdLine[2] & ", " & $CmdLine[3])

ShellExecute($PathToSambaFolder)
PauseTime($ClientPause)
Send("!{F4}")

If $CmdLine[0]>=3 Then

	Switch $CmdLine[2]

		Case "Prepare"

			; Copy nessasary files to folder

			history("Start Prepare Run")

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

			_WinAPI_ShellFileOperation($PathToCompFolder, "",  $FO_DELETE, BitOR($FOF_NOCONFIRMATION, $FOF_SIMPLEPROGRESS))
			_WinAPI_ShellFileOperation($PathToSambaFolder & "\" & $App_Samba_Files, "",  $FO_DELETE, BitOR($FOF_NOCONFIRMATION, $FOF_SIMPLEPROGRESS))

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

			_WinAPI_ShellFileOperation($PathToSambaFolder & "\" & $App_Samba_Files, "",  $FO_DELETE, BitOR($FOF_NOCONFIRMATION, $FOF_SIMPLEPROGRESS))

		Case "CopyFromAndTo"

			history("Copy and copy. Not yet")

			$TestResult="Not yet"

	EndSwitch

IniWrite($testsini, $CmdLine[1], $CmdLine[2], 1)
IniWrite($resultini, $CmdLine[1], $CmdLine[2] & "#" & $CmdLine[3], $TestResult)

;halt("reboot")

EndIf


#include "Libs\foot.au3"
