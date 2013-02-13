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
	  Return (@HOUR & ":" & @MIN & ":" & @SEC & ":" & @MSEC)
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


	; #FUNCTION# ====================================================================================================================
	; Name ..........: CheckDPI
	; Description ...: Determine Font DPI in Windows Vista/7/8
	; Syntax ........: CheckDPI()
	; Parameters ....: none
	; Return values .: Array[3]=[$DPI, $Fontsize, $Fontweight]
	; Author ........: Your Name
	; Modified ......:
	; Remarks .......:
	; Related .......:
	; Link ..........:
	; Example .......: No
	; ===============================================================================================================================
	Func CheckDPI()

		Local $Fontsize ; GUI font size
		Local $Fontweight ; GUI font bold
		Local $DPI = RegRead("HKCU\Control Panel\Desktop\", "LogPixels") ; Font DPI, works on Windows Vista/7/8

			Select
				case $DPI==96 Or $DPI=""
					$DPI=96
					$Fontsize=10
					$Fontweight=400
				case $DPI==120
					$Fontsize=8
					$Fontweight=400 ;400 = normal
				case $DPI=144
					$Fontsize=6
					$Fontweight=400 ;400 = normal
				case else
					$Fontsize=8
					$Fontweight =400 ;400 = normal
			EndSelect

		Local $DPI_array[3]=[$DPI, $Fontsize, $Fontweight]

	Return $DPI_array

	EndFunc


	; #FUNCTION# ====================================================================================================================
	; Name ..........: GUIGetBkColor
	; Description ...: Retrieves the RGB value of the GUI background.
	; Syntax ........: GUIGetBkColor($hWnd)
	; Parameters ....: $hWnd                - A handle of the GUI.
	; Return values .: Success - RGB value
	;                  Failure - 0
	; Author ........: guinness
	; Remarks .......: WinAPIEx is required.
	; Example .......: Yes
	; ===============================================================================================================================
	Func GUIGetBkColor($hWnd)
		;MsgBox(0,"",$hWnd)
		If IsHWnd($hWnd) = 0 Then
			Return 0
		EndIf

		Local $hDC = _WinAPI_GetDC($hWnd)
		Local $iColor = _WinAPI_GetBkColor($hDC)
		_WinAPI_ReleaseDC($hWnd, $hDC)
		Return $iColor
	EndFunc   ;==>GUIGetBkColor


	; #FUNCTION# ====================================================================================================================
	; Name...........: _WinAPI_GetBkColor
	; Description....: Retrieves the current background color for the specified device context.
	; Syntax.........: _WinAPI_GetBkColor ( $hDC )
	; Parameters.....: $hDC    - Handle to the device context.
	; Return values..: Success - The value of the current background color, in RGB.
	;                  Failure - (-1) and sets the @error flag to non-zero.
	; Author.........: Yashied
	; Modified.......:
	; Remarks........: None
	; Related........:
	; Link...........: @@MsdnLink@@ GetBkColor
	; Example........: Yes
	; ===============================================================================================================================

	Func _WinAPI_GetBkColor($hDC)

		Local $Ret = DllCall('gdi32.dll', 'int', 'GetBkColor', 'hwnd', $hDC)

		If (@error) Or ($Ret[0] = -1) Then
			Return SetError(1, 0, -1)
		EndIf
		Return __RGB($Ret[0])
	EndFunc   ;==>_WinAPI_GetBkColor


	Func __RGB($iColor)
		Local $__Var[9] = [0, 0, 0, 0, 16385, 8388608, 1, 0, 0]
	If $__Var[6] Then
		$iColor = _WinAPI_SwitchColor($iColor)
	EndIf
	Return $iColor
	EndFunc   ;==>__RGB

	; #FUNCTION# ====================================================================================================================
	; Name...........: _WinAPI_SwitchColor
	; Description....: Converts a color from BGR to RGB and vice versa.
	; Syntax.........: _WinAPI_SwitchColor ( $iColor )
	; Parameters.....: $iColor - The color to conversion.
	; Return values..: The converted color (RGB or BGR - depends on the $iColor value, BGR > RGB > BGR etc).
	; Author.........: Yashied
	; Modified.......:
	; Remarks........: None
	; Related........:
	; Link...........: None
	; Example........: Yes
	; ===============================================================================================================================

	Func _WinAPI_SwitchColor($iColor)
		Return BitOR(BitAND($iColor, 0x00FF00), BitShift(BitAND($iColor, 0x0000FF), -16), BitShift(BitAND($iColor, 0xFF0000), 16))
	EndFunc   ;==>_WinAPI_SwitchColor





