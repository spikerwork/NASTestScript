#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: Nas Test Script
 Site: https://github.com/spikerwork/NasTestScript

 Script Function:

   HTTP test for Nas Test Script

#ce ----------------------------------------------------------------------------

#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Icon=nas.ico
#AutoIt3Wrapper_Res_Comment="Nas Test Script"
#AutoIt3Wrapper_Res_Description="Nas Test Script"
#AutoIt3Wrapper_Res_Fileversion=0.1.3.5
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Nas Test Script
#AutoIt3Wrapper_Res_Field=ProductVersion|0.1.3.x
#AutoIt3Wrapper_Res_Field=OriginalFilename|NTS_HTTP.au3
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"

Local $App_HTTP_UploadFile = "httpdown.down" ; File
Local $Resultget, $Putrun, $Getrun, $TestResult
Local $App_HTTP_DownloadFile= $ScriptFolder & "\" & $Temp_Folder & "\" & $App_HTTP_UploadFile

$App_HTTP_File = $ScriptFolder & "\" & $Content_Folder & "\" & $App_HTTP_File ; File to transfer
$App_HTTP_getlog = $ScriptFolder & "\" & $Temp_Folder & "\" & $App_HTTP_getlog ; Log HTTP Get file
$App_HTTP = $ScriptFolder & "\" & $App_HTTP ; Path to FTP Tool

history("Downloaded file " & $App_HTTP_DownloadFile)
history("Uploading file " & $App_HTTP_UploadFile)

If $CmdLine[0]>=3 Then history ("From CMD recieved parameters for test: " & $CmdLine[1] & ", " & $CmdLine[2] & ", " & $CmdLine[3])

; Check http link. If file already exist, skip ftp put sector
If StringMid($HTTP_Address,StringLen($HTTP_Address))=="/" Then
$HTTP_Address = $HTTP_Address & $App_HTTP_UploadFile ; Link to file or to directory


$Putrun = StringReplace($App_HTTP & " -T " & $App_HTTP_File & " ftp://" & $NAS_IP & ":" & $FTP_Port &  "/" & $FTP_Folder & "/" & $App_HTTP_UploadFile & " --user " & $FTP_Login & ":" & $FTP_Password & " --stderr " & $tempfile, "//", "/")
$Putrun = StringReplace($Putrun, "\", "/")
$Putrun = StringReplace($Putrun, "ftp:/", "ftp://")
history("Put run exe - " & $Putrun & @CRLF & "Log file - " & $tempfile)

Else

	$Putrun=0
	history("Put run skipped. HTTP address " & $HTTP_Address)

EndIf


$Getrun = StringReplace($App_HTTP & " -o " & $App_HTTP_DownloadFile & " " & $HTTP_Address & " --user " & $HTTP_Login & ":" & $HTTP_Password & " --stderr " & $App_HTTP_getlog, "//", "/")
$Getrun = StringReplace($Getrun, "\", "/")
$Getrun = StringReplace($Getrun, "http:/", "http://")
history("Get exe - " & $Getrun )


If $CmdLine[0]>=3 Then

	Switch $CmdLine[2]

		Case "Prepare"

		history("Put HTTP file to FTP")

		If $Putrun<>0 Then RunWait($Putrun)

		PauseTime($ClientPause)

		$TestResult="Pass"

		Case "Get"

		; Start HTTP get run

		history("Start HTTP Get from NAS")

		RunWait($Getrun)

		$Resultget=SearchLog($App_HTTP_getlog)

		PauseTime($ClientPause)

		FileDelete($App_HTTP_getlog)

		history("FTPGet Result - " & $Resultget)

		$TestResult=$Resultget

	EndSwitch

IniWrite($testsini,$CmdLine[1], $CmdLine[2], 1)
IniWrite($resultini, $CmdLine[1], $CmdLine[2] & "#" & $CmdLine[3], $TestResult)

halt("reboot")

EndIf

#include "Libs\foot.au3"
