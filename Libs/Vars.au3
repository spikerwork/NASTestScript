#include-once
#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: Nas Test Script
 Site: https://github.com/spikerwork/NasTestScript

 Script Function:

	The main library for Nas Test Script
	Contains global vars used in scripts

#ce --------------------------------------------------------------------

   ; ===================================================================
   ; 								Vars
   ; ===================================================================

	;;;
	;;; Files and directories ;;;
	;;;

Global $log=1
Global $linedebug=0

; Folder for script
Global $ScriptName = "VPN_Reconnect" ; Name
Global $ScriptFolder=@HomeDrive & "\" & $ScriptName ; Script directory

; Ini file
Global $inifile = "settings.ini" ; Main settings of scipt
$inifile = $ScriptFolder & "\" & $inifile

; Tempfile
Global $tempfile=_TempFile($ScriptFolder, "tst_", ".txt", 7) ; Temp file

; Log files
Global $logfile = "Log_" & @ScriptName & ".txt" ; Generate log file for current script
$logfile = $ScriptFolder & "\" & $logfile


Global $ScriptStartTime ; Script start time (head.au3)
Global $ScriptEndTime ; Script end time (foot.au3)

; Icon | used only for build.exe script
Global $icon="net.ico"

; Names of scripts
Global  $VPNReconnect="VPNReconnect.exe"
Global  $VPNSettings="VPNSettings.exe"

Global 	$FilesArray[2]=[$VPNReconnect, $VPNSettings]

	;;;
	;;; Other global vars ;;;
	;;;

; System info
Global $osarch = @OSArch ; OS architecture
Global $osversion = @OSVersion ; Version of OS
Global $oslang=@MUILang ; Check system Language 0419=Rus 0409=En

; Detect install script, more info in libs/head.au3
Global $ScriptInstalled
Global $filesinfolder=0
Global $F_arra ; Array of detected files


	;;;
	;;; Vars may store in ini files
	;;;
#CS
   ; Main settings ($inifile)
   Global $TCPport = IniRead($inifile, "Network", "TCPport", 65432 ) ; TCP port for server. Client has TCPport+1
   Global $UDPport = IniRead($inifile, "Network", "UDPport", 7 ) ; UDP port for MagicPacket.
   Global $ServerIP = IniRead($inifile, "Network", "IP", "10.0.0.254" ) ; Default Server IP address
   Global $Client_IP = IniRead($inifile, "Network", "Client_IP", "192.168.1.3" ) ; Default Client IP address
   Global $MAC = IniRead($inifile, "Network", "MAC", "00:24:1D:12:CC:3B" ) ; Default Server IP address
   Global $log = IniRead($inifile, "All", "Log", 1 ) ; Log on/off. Always on.
   Global $linedebug = IniRead($inifile, "All", "LineDebug", 0 )  ; Enables trayicondebug mode + traytip func. Always off.
   Global $serverconsole = IniRead($inifile, "All", "Console", 0 )  ; Server console on/off. Server always on. Client - off.
   Global $ClientPause = IniRead($inifile, "Time", "ClientPause", 2 )
   Global $ServerPause = IniRead($inifile, "Time", "ServerPause", 3 )
   Global $WakeUpPause = IniRead($inifile, "Time", "WakeUpPause", 180 )
   Global $server_broadcast=IniRead($inifile, "Network", "Broadcast", "10.0.0.255")
   Global $OldGUID=IniRead($inifile, "PowerPlan", "Old", "")
   Global $NewGUID=IniRead($inifile, "PowerPlan", "New", "")

   ; Client settings ($resultini)
   Global $testrepeats = IniRead($resultini, "Client", "TestRepeat", 5)
   Global $cpu_need = IniRead($resultini, "Client", "Cpu_activity",  1) ; Now always on. Will`be fixed when Xperf implemented
   Global $cpu_percent_need = IniRead($resultini, "Client", "CPU_load",  5)
   Global $hdd_need = IniRead($resultini, "Client", "Hdd_activity",  1)
   Global $hdd_percent_need = 0 ; Always off. Used before for old system (WinXP and Vista).
#CE