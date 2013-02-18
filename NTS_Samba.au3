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
#AutoIt3Wrapper_Res_Fileversion=0.0.1.2
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




Local $PathToSambaFolder
Local $SambaFiles = @ScriptDir & "\" & $Content_Folder & "\" & $App_Samba_Files
$PathToSambaFolder=$SAMBA_DiskLetter & "\" & $SAMBA_Folder
$PathToSambaFolder=StringReplace($PathToSambaFolder, "\\", "\")
$PathToSambaFolder=StringReplace($PathToSambaFolder, "/", "\")

Local $SourceSize=DirGetSize($SambaFiles)

history("PathToSambaFolder - " & $PathToSambaFolder)
history("SambaFiles - " & $SambaFiles)
history("Folder to delete - " & $PathToSambaFolder & "\" & $App_Samba_Files)

If DirGetSize($PathToSambaFolder)<>-1 Then _WinAPI_ShellFileOperation($PathToSambaFolder & "\" & $App_Samba_Files, "",  $FO_DELETE, BitOR($FOF_NOCONFIRMATION, $FOF_SIMPLEPROGRESS))

ShellExecute($PathToSambaFolder)
PauseTime(5)


; Copy nessasary files to folder
Local $CopyStartTime=GetUnixTimeStamp()

_WinAPI_ShellFileOperation($SambaFiles, $PathToSambaFolder, $FO_COPY, $FOF_SIMPLEPROGRESS)

Local $CopyStopTime=GetUnixTimeStamp()
Local $CopyTime=$CopyStopTime-$CopyStartTime

Local $Speed=$SourceSize/1024/1024/$CopyTime

PauseTime(5)
history("Time - " & $CopyTime)
history("Speed - " & $Speed)


#include "Libs\foot.au3"
