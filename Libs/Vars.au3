#include-once
#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: Nas Test Script (NTS)
 Site: https://github.com/spikerwork/NasTestScript

 Script Function:

	The main library for Nas Test Script (NTS)
	Contains global vars used in scripts

#ce --------------------------------------------------------------------

   ; ===================================================================
   ; 								Vars and Path
   ; ===================================================================

	;;;
	;;; Files and directories ;;;
	;;;


; Folder for script
Global $ScriptName = "NasTestScript" ; Name
Global $DefaultScriptFolder=@HomeDrive & "\" & $ScriptName ; Script directory
Global $ScriptFolder=@ScriptDir ; Script directory

; Ini files
Global $inifile = $ScriptFolder & "\" & "settings.ini" ; Main settings of scipt
Global $resultini = $ScriptFolder & "\" & "result.ini" ; Results

; Tempfile
Global $tempfile=_TempFile($ScriptFolder, "tst_", ".txt", 7) ; Temp file

; Log files
Global $logfile = "Log_" & @ScriptName & ".txt" ; Generate log file for current script
$logfile = $ScriptFolder & "\" & $logfile

; Program timer
Global $ScriptStartTime ; Script start time (head.au3)
Global $ScriptEndTime ; Script end time (foot.au3)

; Icon | used only for build.exe script
Global $icon="nas.ico"

; Names of scripts
Global  $NTS="NasTestScript.exe"
Global  $NTS_Settings="NTS_Settings.exe"

Global 	$FilesArray[2]=[$NTS, $NTS_Settings]

	;;;
	;;; Other global vars ;;;
	;;;

; Detect install script, more info in libs/head.au3
Global $ScriptInstalled
Global $filesinfolder=0
Global $F_arra ; Array of detected files


	;;;
	;;; Vars may store in ini files
	;;;

	; NAS default settings
	Global $NAS_IP = IniRead($inifile, "Network", "NAS_IP", "192.168.1.1" ) ; NAS IP
	Global $FTPport = IniRead($inifile, "Network", "FTPport", 21 ) ; NAS FTP port
	Global $FTPFolder = IniRead($inifile, "Network", "FTPFolder", "ftpfolder" ) ; FTP folder/path
	Global $HTTPport = IniRead($inifile, "Network", "HTTPport", 8080 ) ; NAS HTTP port
	Global $HTTPFolder = IniRead($inifile, "Network", "HTTPPath", "pathname" ) ; HTTP folder/path
	Global $SMBLetter = IniRead($inifile, "Network", "SMBLetter", "Z:\" ) ; NAS samba share mount point
	Global $SMBFolder = IniRead($inifile, "Network", "SMBFolder", "foldername" ) ; NAS FTP port

	; Main settings
	Global $log = IniRead($inifile, "All", "Log", 1 ) ; Log on/off. Always on.
	Global $linedebug = IniRead($inifile, "All", "LineDebug", 0 )  ; Enables trayicondebug mode + traytip func. Always off.

	; Client settings
	Global $TestRepeats = IniRead($inifile, "Client", "TestRepeat", 5) ; Default test repeat
	Global $ClientPause = IniRead($inifile, "Client", "ClientPause", 5 ) ; Default pause between actions
	Global $ClearCache = IniRead($inifile, "Client", "ClearCache", 1 ) ; Default clear cache (Prefetch) before each test

	; Powerplan changes
	Global $OldGUID=IniRead($inifile, "PowerPlan", "Old", "")
	Global $NewGUID=IniRead($inifile, "PowerPlan", "New", "")

