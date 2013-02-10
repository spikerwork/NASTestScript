#include-once
#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: Nas Test Script
 Site: https://github.com/spikerwork/NasTestScript

 Script Function:

	The main library for Nas Test Script
	Contains main functions

#ce --------------------------------------------------------------------


	; #FUNCTION# ====================================================================================================================
	; Name ..........: PauseTime
	; Description ...: Set Pause for $time (in seconds)
	; Syntax ........: PauseTime($time)
	; Parameters ....: $time
	; Return values .: None
	; Author ........: Not me
	; Example .......: No
	; ===============================================================================================================================
	Func PauseTime($time)

	history ("Pause func triggered. Pause time - " & $time)
	ProgressOn("Progress", "Pause for " & $time & " seconds", "0 seconds")
	Local $i
	For $i = 1 to $time step 1
		Sleep(1000)
		Local $p=(100/$time)*$i
		ProgressSet( $p, $i & " seconds")
    Next
	ProgressSet(100 , "Done", "Complete")
	Sleep(500)
	ProgressOff()
	history ("Pause ended.")

	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name ..........: halt
	; Description ...: Shutdown function
	; Syntax ........: halt($halt_option)
	; Parameters ....: reboot, sleep, hibernate, halt - A handle value.
	; Return values .: None
	; Author ........: Sp1ker
	; Modified ......:
	; Remarks .......: +4 Force didn`t working on many PC
	; Related .......:
	; Link ..........:
	; Example .......: No
	; ===============================================================================================================================
	Func halt($halt_option)

      history ("The system is halting. Reason - " & $halt_option)
	  Switch $halt_option
	  Case "reboot"
   		 Shutdown(6)
	  Case "sleep"
		 Shutdown(32) ; 32+4 not working
	  Case "hibernate"
		 Shutdown(64) ; 64+4 not working
	  Case "halt"
		 Shutdown(5)
	  Case Else
		 MsgBox(0, "", "Wrong shutdown option")
		 Exit
	  EndSwitch

	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name ..........: currenttime
	; Description ...: Return current time of PC
	; Syntax ........: currenttime ()
	; Parameters ....: None
	; Return values .: Hour:Min:Sec:Msec
	; Author ........: Sp1ker
	; Modified ......:
	; Remarks .......:
	; Related .......:
	; Link ..........:
	; Example .......: No
	; ===============================================================================================================================
	Func currenttime ()
	  $currentdate=@HOUR & ":" & @MIN & ":" & @SEC & ":" & @MSEC
	  Return $currentdate
	EndFunc

   ; Logging function
   Func history ($post)

	  If $log == 1 Then

	  Local $time=currenttime ()
	  Local $file = FileOpen($logfile, 9) ; which is similar to 1 + 8 (append to file + create dir)

	  If $file = -1 Then
		  MsgBox(0, "Error", "Unable to create or open log file.")
		  Exit
	   EndIf
	  If $linedebug==1 Then ToolTip("Time - " & $time & @CRLF & $post & @CRLF, 2000, 0, @ScriptName, 2,4)
	  FileWrite($file, "(" & $time & ") --- " & $post & @CRLF)
	  FileClose($file)

	  EndIf

   EndFunc

   ; Open log file of current script when doubleclicked on tray icon
   Func OpenLog()

	  If $log == 1 Then
	  history ("Log file " & $logfile & " opened")
	  ShellExecute($logfile)
	  EndIf

   EndFunc


	; Add to Firewall Exception. Need admin rights
	; #FUNCTION# ====================================================================================================================
	; Name ..........: AddToFirewall
	; Description ...:
	; Syntax ........: AddToFirewall ($appName, $applicationFullPath[, $appSet = 1])
	; Parameters ....: $appName             - Name of program.
	;                  $applicationFullPath - Full path to program (dir+exe).
	;                  $appSet              - [optional]. Default is 1 - on. 0 Delete program from firewall
	; Return values .: None
	; Author ........: Sp1ker
	; Example .......: AddToFirewall($WakeServer, $ScriptFolder & "\" & $WakeServer,0); $WakeServer="WakeServer.exe", $ScriptFolder=@HomeDrive & "\WakeScript"
	; ===============================================================================================================================
	Func AddToFirewall ($appName, $applicationFullPath, $appSet=1)

	If $appSet==1 Then
	  RunWait ('netsh advfirewall firewall add rule name="' & $appName &'" dir=in action=allow program="' & $applicationFullPath & '" enable=yes profile=any')
	ElseIf $appSet==0 Then
	  RunWait ('netsh advfirewall firewall del rule name="' & $appName &'" dir=in program="' & $applicationFullPath )
	EndIf

	EndFunc


	; IMPORTANT MAKE A COPY OF SCRIPT BEFORE DELETION
	; Deletes the running script
	; Author MHz

	Func _SelfDelete($iDelay = 0)
		Local $sCmdFile
		FileDelete(@TempDir & "\scratch.bat")
		$sCmdFile = 'ping -n ' & $iDelay & '127.0.0.1 > nul' & @CRLF _
				& ':loop' & @CRLF _
				& 'del "' & @ScriptFullPath & '"' & @CRLF _
				& 'if exist "' & @ScriptFullPath & '" goto loop' & @CRLF _
				& 'del ' & @TempDir & '\scratch.bat'
		FileWrite(@TempDir & "\scratch.bat", $sCmdFile)
		history ("Function _SelfDelete() is called for file " & @ScriptFullPath)
		Run(@TempDir & "\scratch.bat", @TempDir, @SW_HIDE)

	EndFunc


;
   ; Work with computer IP settings
   ;

    ; Get the Hardware IDs and GUID of current network adapter. Addon for IPDetail()
   Func _GetPNPDeviceID($sAdapter)
	  Local $arra[2]

	  ;history ("Call to GetPNPDeviceID(). Get the Hardware ID of network adapter")
	   Local $oWMIService = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
	   Local $oColItems = $oWMIService.ExecQuery('Select * From Win32_NetworkAdapter Where Name = "' & $sAdapter & '"', "WQL", 0x30)
	   If IsObj($oColItems) Then
		   For $oObjectItem In $oColItems
			   $arra[0]=$oObjectItem.PNPDeviceID
			   $arra[1]=$oObjectItem.GUID

			   ;history ("Found Hardware ID " & $oObjectItem.PNPDeviceID & " for device " & $sAdapter)
			   ;history ("Found Hardware GUID " & $oObjectItem.GUID & " for device " & $sAdapter)

			   Return $arra
		   Next
	   EndIf
	   Return SetError(1, 0, "Unknown")
	EndFunc

   ; Get main information of network adapters
   ; Returns:
   ;
   ; $avArray[0][$iCount] — Description
   ; $avArray[1][$iCount] — IPAddress(0)
   ; $avArray[2][$iCount] — MACAddress
   ; $avArray[3][$iCount] — IPSubnet(0)
   ; $avArray[4][$iCount] — Ven/Dev info
   ; $avArray[5][$iCount] — Physic (1 or 0)
   ; $avArray[6][$iCount] — GUID of adapter
   ;
   ; This function from http://www.autoitscript.com/forum/topic/128276-display-ip-address-default-gateway-dns-servers/

   Func _IPDetail()
    ;history ("Call to network function IPDetail(). Get main information of network adapters")
	Local $iCount = 0
    Local $oWMIService = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
    Local $oColItems = $oWMIService.ExecQuery("Select * From Win32_NetworkAdapterConfiguration Where IPEnabled = True", "WQL", 0x30)
	Local $avArray[7][10]
	Local $physic
	Local $descibe[2]

    If IsObj($oColItems) Then
        For $oObjectItem In $oColItems

		   Local $desc = $oObjectItem.Description
		   $descibe = _GetPNPDeviceID($desc)


			   $avArray[0][$iCount] = _IsString($oObjectItem.Description)
			   $avArray[1][$iCount] = _IsString($oObjectItem.IPAddress(0))
			   $avArray[2][$iCount] = _IsString($oObjectItem.MACAddress)
			   $avArray[3][$iCount] = _IsString($oObjectItem.IPSubnet(0))
			   $avArray[4][$iCount] = $descibe[0]
			   $avArray[6][$iCount] = $descibe[1]


			If StringInStr($descibe[0], "Ven_") Or StringInStr($descibe[0], "usb") Then
			$avArray[5][$iCount] = 1
			$physic += 1

			history ("This is physical adapter (IP: " & $avArray[1][$iCount] & ") - " & $avArray[0][$iCount] & ". Using for it #" & $iCount)
			Else
			history ($avArray[0][$iCount] & " this is virtual adapter (IP: " & $avArray[1][$iCount] & ")")

			$avArray[5][$iCount] = 0
			EndIf


			$iCount += 1

		 Next

		history ("At least found " & $iCount & " active network adapters and " & $physic & " of them is physical (PCI or USB)")

		Return $avArray
    EndIf
    Return SetError(1, 0, $aReturn)
   EndFunc

   ; Check string function for IPDetail()
   Func _IsString($sString)
    If IsString($sString) Then
        Return $sString
    EndIf
    Return "Not Available"
   EndFunc
