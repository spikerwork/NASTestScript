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

Local $szFile, $szText

$szFile = $ScriptFolder & "\Apps\iometer\iometer_SAMBA.icf"
Local $IO_Folder=$ScriptFolder & "\Apps\iometer"

$szText = FileRead($szFile,FileGetSize($szFile))
$szText = StringReplace($szText, "K:\\10.0.0.99\IxiaChariot", "Y:\\10.0.0.83\VideoCam")
FileDelete($szFile)
FileWrite($szFile,$szText)
Sleep(2000)
ShellExecuteWait($IO_Folder & "\" &"IOMETER.exe", "iometer_SAMBA.icf results.csv",$IO_Folder)

;MsgBox(0, "Results", "Upload " & $Resultput & @CRLF & "Download " &  $Resultget)


#include "Libs\foot.au3"
