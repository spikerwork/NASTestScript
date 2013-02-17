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
#AutoIt3Wrapper_Res_Fileversion=0.0.1.2
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


Local $Getrun
Local $Putrun
Local $Firstrun
Local $Resultput
Local $Resultget

Local $App_FTP_DownloadFile = "downdown.down"
Local $App_FTP_UploadFile = "upload.upload"

$App_FTP_File = $ScriptFolder & "\" & $App_FTP_File
$App_FTP_getlog = $ScriptFolder & "\" & $App_FTP_getlog
$App_FTP_putlog = $ScriptFolder & "\" & $App_FTP_putlog
$App_FTP = $ScriptFolder & "\" & $App_FTP
Local $Temp_log = @HomeDrive & "\" & "log.txt"

$Resultput = $Resultput & " |S " & SearchLog($App_FTP_putlog)
$Resultget = $Resultget & " |S " & SearchLog($App_FTP_getlog)

;FileDelete($App_FTP_getlog)
;FileDelete($App_FTP_putlog)

MsgBox(0, "Results", "Upload " & $Resultput & @CRLF & "Download " &  $Resultget)


#include "Libs\foot.au3"
