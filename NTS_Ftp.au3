#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: Nas Test Script
 Site: https://github.com/spikerwork/NasTestScript

 Script Function:

   FTP test for Nas Test Script

#ce ----------------------------------------------------------------------------

#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Icon=nas.ico
#AutoIt3Wrapper_Res_Comment="Nas Test Script"
#AutoIt3Wrapper_Res_Description="Nas Test Script"
#AutoIt3Wrapper_Res_Fileversion=0.0.1.6
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Nas Test Script
#AutoIt3Wrapper_Res_Field=ProductVersion|0.0.1.x
#AutoIt3Wrapper_Res_Field=OriginalFilename|NTS_Ftp.au3
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"

; Vars
Local $Getrun, $Putrun, $Firstrun, $Resultput, $Resultget, $FTP_Mode

Local $App_FTP_DownloadFile = "downdown.down" ; File
Local $App_FTP_UploadFile = "upload.upload" ; File

$App_FTP_File = $ScriptFolder & "\" & $Content_Folder & "\" & $App_FTP_File ; File to transfer
$App_FTP_getlog = $ScriptFolder & "\" & $App_FTP_getlog ; Log FTP Get file
$App_FTP_putlog = $ScriptFolder & "\" & $App_FTP_putlog ; Log FTP Put file
$App_FTP = $ScriptFolder & "\" & $App_FTP ; Path to FTP Tool

	; Choose FTP Mode
	If $FTP_Passive==1 Then
		history("FTP Passive mode on")
		$FTP_Mode = " --ftp-pasv"
	ElseIf $FTP_Passive==0 Then
		history("FTP Passive mode off")
		$FTP_Mode = " --ftp-skip-pasv-ip"
	EndIf

$FTP_Folder=StringReplace($FTP_Folder," ", "") ; Clear spaces

; Clear double //
$Firstrun = StringReplace($App_FTP & " -T " & $App_FTP_File & " ftp://" & $NAS_IP & ":" & $FTP_Port &  "/" & $FTP_Folder & "/" & $App_FTP_DownloadFile & " --user " & $FTP_Login & ":" & $FTP_Password & " --stderr " & $tempfile & $FTP_Mode, "//", "/")
$Firstrun = StringReplace($Firstrun, "\", "/")
$Firstrun = StringReplace($Firstrun, "ftp:/", "ftp://")
history("First run exe - " & $Firstrun & @CRLF & "Log file - " & $tempfile)

$Putrun= StringReplace($App_FTP & " -T " & $App_FTP_File & " ftp://" & $NAS_IP & ":" & $FTP_Port & "/" & $FTP_Folder & "/" & $App_FTP_UploadFile & " --user " & $FTP_Login & ":" & $FTP_Password & " --stderr " & $App_FTP_putlog & $FTP_Mode, "//", "/")
$Putrun = StringReplace($Putrun, "\", "/")
$Putrun = StringReplace($Putrun, "ftp:/", "ftp://")
history("FTPPut run exe - " & $Putrun)

$Getrun= StringReplace($App_FTP & " ftp://" & $NAS_IP & ":" & $FTP_Port & "/" & $FTP_Folder & "/" & $App_FTP_DownloadFile & " --user " & $FTP_Login & ":" & $FTP_Password & " --stderr " & $App_FTP_getlog & " -o " & $App_FTP_DownloadFile & $FTP_Mode, "//", "/")
$Getrun = StringReplace($Getrun, "\", "/")
$Getrun = StringReplace($Getrun, "ftp:/", "ftp://")
history("FTPGet run exe - " & $Getrun)


; Start first run. Put nessasary file to ftp
history("Start First FTP Run")

RunWait($Firstrun)

PauseTime(10)
FileDelete($tempfile)

; Start FTP put run

history("Start FTP Put Run")

RunWait($Putrun)

$Resultput=SearchLog($App_FTP_putlog)
FileDelete($App_FTP_putlog)
history("FTPPut Result - " & $Resultput)

PauseTime(10)

; Start FTP get run

history("Start FTP Get Run")

RunWait($Getrun)

$Resultget=SearchLog($App_FTP_getlog)
FileDelete($App_FTP_getlog)
history("FTPGet Result - " & $Resultget)

FileDelete($ScriptFolder & "\" & $App_FTP_DownloadFile)

PauseTime(10)

; Simultaneously Upload and Download File

history("Simultaneously Upload and Download File")

Run($Putrun)
Run($Getrun)

; Wait for finish all runs
While 1
	If ProcessExists("curl.exe")=0 Then
		ExitLoop
	EndIf
Wend

PauseTime(10)

FileDelete($ScriptFolder & "\" & $App_FTP_DownloadFile)

$Resultput=$Resultput & " |S " & SearchLog($App_FTP_putlog)
$Resultget=$Resultget & " |S " & SearchLog($App_FTP_getlog)

history("FTPPut 2 Result - " & $Resultput)
history("FTPGet 2 Result - " & $Resultget)

FileDelete($App_FTP_getlog)
FileDelete($App_FTP_putlog)

MsgBox(0, "Results", "Upload " & $Resultput & @CRLF & "Download " &  $Resultget)

#include "Libs\foot.au3"
