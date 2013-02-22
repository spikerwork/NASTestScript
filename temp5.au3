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
#AutoIt3Wrapper_Res_Fileversion=0.1.2.17
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Nas Test Script
#AutoIt3Wrapper_Res_Field=ProductVersion|0.1.2.x
#AutoIt3Wrapper_Res_Field=OriginalFilename|NTS_Samba_IO.au3
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"

Local $filecsv= $ScriptFolder & "\" & $resultfolder & "\" & "NASPerf-APP.csv"

Local $file = FileOpen($filecsv, 0)
Local $line, $result
Dim $array

For $i=3 to 14

$line = FileReadLine($file,$i)

$array = _StringExplode($line, ",", 0)
$result=StringReplace($array[1], ".", ",")
IniWrite($resultini, "Run3", $array[0], $result)
;MsgBox(0,"",$result)
Next

#include "Libs\foot.au3"
