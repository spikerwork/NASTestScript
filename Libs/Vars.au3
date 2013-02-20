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
Global $ScriptName = "NasTestScript" ; Name of script
Global $DefaultScriptFolder=@HomeDrive & "\" & $ScriptName ; Default script directory
Global $ScriptFolder=@ScriptDir ; Script directory

; Ini files
Global $inifile = $ScriptFolder & "\" & "settings.ini" ; Main settings of scipt
Global $resultini = $ScriptFolder & "\" & "result.ini" ; Results
Global $testsini = $ScriptFolder & "\" & "tests.ini" ; Tests setup

; Log files
Global $logfile = $ScriptFolder & "\" & "Log_" & @ScriptName & ".txt" ; Generate log file for current script

; Program timer in Unix time Format
Global $ScriptStartTime ; Script start time (used in head.au3)
Global $ScriptEndTime ; Script end time (used in foot.au3)

; Icon | used only for build.exe script
Global $icon="nas.ico"

; Names of scripts
Global $NTS="NasTestScript.exe"
Global $NTS_Settings="NTS_Settings.exe" ;
Global $NTS_Ftp="NTS_Ftp.exe" ;
Global $NTS_Samba="NTS_Samba.exe" ;
Global $NTS_Samba_UD="NTS_Samba_UD.exe" ; Addon for NTS_Samba
Global $NTS_Test="NTS_Test.exe" ;
Global $NTS_HTTP="NTS_HTTP.exe" ;

Global $FilesArray[7]=[$NTS, $NTS_Settings, $NTS_Ftp, $NTS_Samba, $NTS_Test, $NTS_HTTP, $NTS_Samba_UD]

; Tests
Global $NTS_Tests[6]=["FTP", "Samba", "HTTP", "Samba_NASPT", "Samba_IO", "iSCSI_IO"]

	;;;
	;;; Other global vars ;;;
	;;;

; Detect install script, more info in libs/head.au3
Global $ScriptInstalled
Global $filesinfolder=0
Global $F_arra ; Array of detected files

Global $Current_DPI ; DPI of Windows desktop. relative to function CheckDPI()

	;;;
	;;; Vars may store in ini files
	;;;

	; NAS default settings
	Global $NAS_IP = IniRead($inifile, "Network", "NAS_IP", "192.168.1.6") ; NAS IP

	Global $FTP_Default_login="admin"
	Global $FTP_Default_pass="password"
	Global $FTP_Anon_login="anonymous"
	Global $FTP_Anon_pass="test@test.com"
	Global $FTP_Port = IniRead($inifile, "Network", "FTP_Port", 21 ) ; NAS FTP port
	Global $FTP_Login = IniRead($inifile, "Network", "FTP_Login", $FTP_Default_login ) ; NAS FTP Login
	Global $FTP_Password = IniRead($inifile, "Network", "FTP_Password", $FTP_Default_pass ) ; NAS FTP Password
	Global $FTP_Folder = IniRead($inifile, "Network", "FTP_Folder", "ftpfolder" ) ; FTP folder/path
	Global $FTP_Passive = IniRead($inifile, "Network", "FTP_Passive", 1 ) ; FTP passive mode, default on

	Global $HTTP_Default_login="admin"
	Global $HTTP_Default_pass="admin"
	Global $HTTP_Port = IniRead($inifile, "Network", "HTTP_Port", 8080 ) ; NAS HTTP port
	Global $HTTP_Address = IniRead($inifile, "Network", "HTTP_Address", "") ; HTTP folder/path
	Global $HTTP_Login = IniRead($inifile, "Network", "HTTP_Login", $HTTP_Default_login ) ; NAS HTTP Login
	Global $HTTP_Password = IniRead($inifile, "Network", "HTTP_Password", $HTTP_Default_pass ) ; NAS HTTP Password

	Global $SAMBA_Default_login="guest"
	Global $SAMBA_Default_pass="guest"
	Global $SAMBA_DiskLetter = IniRead($inifile, "Network", "SMB_Letter", "Z:" ) ; NAS samba share mount point
	Global $SAMBA_Folder = IniRead($inifile, "Network", "SMB_Folder", "\sambafolder" ) ; NAS Samba folder
	Global $SAMBA_Login = IniRead($inifile, "Network", "SMB_Login", $SAMBA_Default_login ) ; NAS Samba Login
	Global $SAMBA_Password = IniRead($inifile, "Network", "SMB_Password", $SAMBA_Default_pass ) ; NAS Samba Password

	; Application settings
	Global $Content_Folder =  IniRead($inifile, "Application", "Content_Folder", "Content" ) ; Folder wich store files to run tests
	Global $Temp_Folder =  IniRead($inifile, "Application", "Temp_Folder", "Temp" ) ; Folder wich store files to run tests
	Global $App_FTP = IniRead($inifile, "Application", "FTP_Tool", "Apps\curl\curl.exe" ) ; FTP Tool for test FTP Download/Upload
	Global $App_HTTP = IniRead($inifile, "Application", "HTTP_Tool", "Apps\curl\curl.exe" ) ; HTTP Tool for test HTTP Download
	Global $App_FTP_putlog = IniRead($inifile, "Application", "FTP_Tool_putlog", "FTP_put.txt" ) ; FTP put log
	Global $App_FTP_getlog = IniRead($inifile, "Application", "FTP_Tool_getlog", "FTP_get.txt" ) ; FTP get log
	Global $App_FTP_File = IniRead($inifile, "Application", "FTP_Tool_File", "UpDo.rar" ) ; FTP transfer file
	Global $App_Samba_Files = IniRead($inifile, "Application", "SAMBA_Files", "Test" ) ; FTP transfer file
	Global $App_HTTP_File = IniRead($inifile, "Application", "HTTP_Tool_File", "HTTPUpDo.rar" ) ; HTTP transfer file
	Global $App_HTTP_putlog = IniRead($inifile, "Application", "HTTP_Tool_putlog", "HTTP_put.txt" ) ; HTTP put log
	Global $App_HTTP_getlog = IniRead($inifile, "Application", "HTTP_Tool_getlog", "HTTP_get.txt" ) ; HTTP get log

	; Tempfile
	Global $tempfile=_TempFile($ScriptFolder & "\" & $Temp_Folder, "tst_", ".txt", 7) ; Temp file

	; Main settings
	Global $log = IniRead($inifile, "All", "Log", 1 ) ; Log on/off. Always on.
	Global $linedebug=1 ; Enables trayicondebug mode + traytip func. For exe files — off.
		If @compiled==1 Then $linedebug=0
		$linedebug = IniRead($inifile, "All", "LineDebug", $linedebug )

	; NTS_Settings vars
	Global $NTS_SettingsFormWidth=IniRead($inifile, "All", "SettingsFormWidth", 600)
	Global $NTS_SettingsFormHeight=IniRead($inifile, "All", "SettingsFormHeight", 500)
	Global $NTS_SettingsFormBackgroundColor=IniRead($inifile, "All", "SettingsFormBackgroundColor", 0xE2EEEF)
	Global $NTS_SettingsFormBadBackgroundColor=IniRead($inifile, "All", "SettingsFormBadBackgroundColor", 0xeac4c4)
	Global $NTS_SettingsFormBadFontColor=IniRead($inifile, "All", "SettingsFormBadFontColor", 0x000000)
	Global $NTS_SettingsFormGroupFont=IniRead($inifile, "All", "FormGroupFont", "Tahoma")
	Global $NTS_SettingsFormMainFont=IniRead($inifile, "All", "FormMainFont", "Tahoma")

	; Run settings
	Global $ClientPause = IniRead($testsini, "Runs", "ClientPause", 10 ) ; Default pause between actions
	Global $ClearCache = IniRead($testsini, "Runs", "ClearCache", 0 ) ; Default clear cache (Prefetch) before each test
	Global $Current_Loop=IniRead($testsini, "Runs", "LoopNumber", 0) ; Current loop number, refers to $Number_of_loops
	Global $Number_of_loops=IniRead($testsini, "Runs", "Loops", 5) ; Number of total loops of each test
	Global $Current_Tests=IniRead($testsini, "Runs", "Tests", _ArrayToString($NTS_Tests, "|")) ; List of current tests to run

	; Powerplan changes
	Global $OldGUID=IniRead($inifile, "PowerPlan", "Old", "")
	Global $NewGUID=IniRead($inifile, "PowerPlan", "New", "")

