#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: Nas Test Script (NTS)
 Site: https://github.com/spikerwork/NasTestScript

 Script Function:

   The part of Nas Test Script (NTS)
   This script build all nessasary EXE files to script. Works only when autoit installed.

#ce --------------------------------------------------------------------
#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Icon=nas.ico
#AutoIt3Wrapper_Res_Comment="Nas Test Script"
#AutoIt3Wrapper_Res_Description="Nas Test Script"
#AutoIt3Wrapper_Res_Fileversion=0.1.2.5
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Nas Test Script
#AutoIt3Wrapper_Res_Field=ProductVersion|0.1.2.x
#AutoIt3Wrapper_Res_Field=OriginalFilename|BuildEXE.au3
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"

Local $t=0
While $t <= Ubound($FilesArray)-1

	If FileExists(@ScriptDir & "\" & $FilesArray[$t])==1 Then FileDelete(@ScriptDir & "\" & $FilesArray[$t])
	$t+=1

WEnd

RunWait(@ProgramFilesDir & '\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in "' & @ScriptDir & '\NasTestScript.au3" /out "' & @ScriptDir & '\' & $NTS & '" /comp 4 /x86 /icon ' & $icon & ' /NoStatus')
RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\NTS_Settings.au3 /out " & @ScriptDir & "\" & $NTS_Settings & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\NTS_FTP.au3 /out " & @ScriptDir & "\" & $NTS_Ftp & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\NTS_Samba.au3 /out " & @ScriptDir & "\" & $NTS_Samba & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\NTS_Test.au3 /out " & @ScriptDir & "\" & $NTS_Test & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\NTS_HTTP.au3 /out " & @ScriptDir & "\" & $NTS_HTTP & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\NTS_Samba_UD.au3 /out " & @ScriptDir & "\" & $NTS_Samba_UD & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\NTS_Samba_IO.au3 /out " & @ScriptDir & "\" & $NTS_Samba_IO & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
