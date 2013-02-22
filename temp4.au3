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

Global $intelname="NAStest"
Global $inteltestname="Test"

Run("C:\Program Files (x86)\Intel\NASPT\NASPerf.exe", "C:\Program Files (x86)\Intel\NASPT")
Sleep(2000)
Send("{ENTER}")
Sleep(2000)
Send("{ENTER}")

Sleep(20000)
Send("{RIGHT 6}")
Send("{ENTER}")
Sleep(2000)
Send("{Z}")
Send("{:}")
Send("{ENTER}")
Sleep(2000)
Send("{TAB}")
Send($intelname)
Sleep(2000)
Send("{TAB}")
Send($inteltestname)
Sleep(2000)
Send("{TAB 21}")
Send("{ENTER}")
Sleep(1000)
Send("{TAB}")
Send("{ENTER}")
Sleep(1000)
Send("{ENTER}")

;pause(3000)
WinWaitActive("Application Test Result")
Send("{ENTER}")
Sleep(1500)
Send("{ENTER}")
Sleep(500)

$PID = ProcessExists("NASPerf.exe")
If $PID Then ProcessClose($PID)

#include "Libs\foot.au3"
