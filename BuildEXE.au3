#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: Nas Test Script
 Site: https://github.com/spikerwork/NasTestScript

 Script Function:

   The part of Nas Test Script
   This script build all nessasary EXE files to script. Works only when autoit installed.

#ce --------------------------------------------------------------------
#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Icon=nas.ico
#AutoIt3Wrapper_Res_Comment="Nas Test Script"
#AutoIt3Wrapper_Res_Description="Nas Test Script"
#AutoIt3Wrapper_Res_Fileversion=0.0.1.0
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Nas Test Script
#AutoIt3Wrapper_Res_Field=ProductVersion|0.0.1.x
#AutoIt3Wrapper_Res_Field=OriginalFilename|BuildEXE.au3
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"

;RunWait(@ProgramFilesDir & '\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in "' & @ScriptDir & '\VPNReconnect.au3" /out "' & @ScriptDir & '\' & $VPNReconnect & '" /comp 4 /x86 /icon ' & $icon & ' /NoStatus')
;RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\VPNSettings.au3 /out " & @ScriptDir & "\" & $VPNSettings & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
