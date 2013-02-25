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
	;history ("Pause ended.")

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
					$Fontsize=10
					$Fontweight=400 ;400 = normal
				case else
					$Fontsize=8
					$Fontweight =400 ;400 = normal
			EndSelect

		Local $DPI_array[3]=[$DPI, $Fontsize, $Fontweight]

	Return $DPI_array

	EndFunc

	; Some network check. Not build full
	Func Network_check($network_old, $IPs)

			$network_old=StringLeft($network_old, StringInStr($network_old, ".", 0, 3)-1)


			Local $t=0
			Local $network_new
			While $t <= UBound($IPs)-1

				$network_new=StringLeft($IPs[$t], StringInStr($IPs[$t], ".", 0, 3)-1)
				If $network_new==$network_old Then Return 0
				$t+=1

			WEnd

			Return 1

	EndFunc


	; #FUNCTION# ====================================================================================================================
	; Name ..........: GUIGetBkColor
	; Description ...: Retrieves the RGB value of the GUI background.
	; Syntax ........: GUIGetBkColor($hWnd)
	; Parameters ....: $hWnd                - A handle of the GUI.
	; Return values .: Success - RGB value
	;                  Failure - 0
	; Author ........: noone
	; Remarks .......: WinAPIEx is required.
	; Example .......: Yes
	; ===============================================================================================================================


	Func _GetGuiBkColor($hWnd)
		Local $hDC, $aBGR
		$hDC = _WinAPI_GetDC($hWnd)
		$aBGR = DllCall('gdi32.dll', 'int', 'GetBkColor', 'hwnd', $hDC)
		_WinAPI_ReleaseDC($hWnd, $hDC)
		Return BitOR(BitAND($aBGR[0], 0x00FF00), BitShift(BitAND($aBGR[0], 0x0000FF), -16), BitShift(BitAND($aBGR[0], 0xFF0000), 16))
	EndFunc   ;==>_GetGuiBkColor

	; Dragging GUI offscreen
	; from http://www.autoitscript.com/forum/topic/96281-solved-dragging-gui-offscreen-with-gui-ws-ex-parentdrag-works-fine/

	Func WM_WINDOWPOSCHANGING($hWnd, $Msg, $wParam, $lParam)
		Local $stWinPos = DllStructCreate("uint;uint;int;int;int;int;uint", $lParam)

		Local $iLeft = DllStructGetData($stWinPos, 3)
		Local $iTop = DllStructGetData($stWinPos, 4)
		Local $iWidth = DllStructGetData($stWinPos, 5)
		Local $iHeight = DllStructGetData($stWinPos, 6)

		Local $aGUI_Pos = WinGetPos($hWnd)

		If $iHeight < $aGUI_Pos[3] Then
			Local $iNew_Top = -($aGUI_Pos[3]-$iHeight)-18 ;I am not sure that 18 will fit for all
			DllStructSetData($stWinPos, 4, $iNew_Top)
		EndIf
	EndFunc

	; Dragging GUI offscreen addon
	; from http://www.autoitscript.com/forum/topic/96281-solved-dragging-gui-offscreen-with-gui-ws-ex-parentdrag-works-fine/

	Func WM_NCHITTEST($hWnd, $iMsg, $wParam, $lParam)
		If $hWnd <> $hGUI Or $iMsg <> $WM_NCHITTEST Then Return $GUI_RUNDEFMSG

		Local $iRet = _WinAPI_DefWindowProc($hWnd, $iMsg, $wParam, $lParam)
		If $iRet = 1 Then Return 2

		Return $iRet
	EndFunc

	; FTP_tool results parser
	Func SearchLog($log)

		Local $line, $lastline, $text, $gettext
		Local $file = FileOpen($log, 0)

			If $file = -1 Then
				history("Error! Unable to open file " & $log)
				Exit
			EndIf

		history ("Parse FTP log file " & $log)

			While 1

				$line = FileReadLine($file)

				If @error = -1 Then
					$lastline=$line-1
					ExitLoop
				EndIf

			Wend

		$gettext=FileReadLine($file,$lastline)
		FileClose($file)
		history ("Last line in ftp log file " & $gettext)

		; Parse line
		$text=StringInStr($gettext, "--")
		$text=StringMid($gettext,$text)
		$text=StringMid($text,StringInStr($text, " "))
		$text=StringReplace($text," ", "",0,2)

		Return $text

	EndFunc

	; Prepare for file testing. Clear cache and prefetch
	Func Prepare($PrPmode)

		If $PrPmode==1 Then
			history("Prepare for test. Clear cache and prefetch")

			FileDelete("C:\Windows\Prefetch\*.*")
			FileDelete("C:\Windows\Prefetch\ReadyBoot\*.*")
			RunWait("rundll32.exe advapi32.dll, ProcessIdleTasks")
			RegWrite("HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters", "EnablePrefetcher", "REG_DWORD", 0)
			RegWrite("HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters", "EnableSuperfetch", "REG_DWORD", 0)
			RegWrite("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoRecycleFiles", "REG_DWORD", 1)

		ElseIf $PrPmode==0 Then

			history("Test done. Enable cache and prefetch")
			RegWrite("HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters", "EnablePrefetcher", "REG_DWORD", 3)
			RegWrite("HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters", "EnableSuperfetch", "REG_DWORD", 3)

		EndIf

	EndFunc

	; NAS mount as network drive NASMount (1)
	Func NASMount ($nas_mount)

		Local $MapNetworkDrive
		If $nas_mount==1 Then

			history("Try to map network drive to share " & $SAMBA_DiskLetter & "\\" & $NAS_IP & "\" & $SAMBA_Share)
			If $SAMBA_Login==$SAMBA_Default_login and $SAMBA_Password==$SAMBA_Default_pass Then
				$MapNetworkDrive=DriveMapAdd ($SAMBA_DiskLetter, "\\" & $NAS_IP & "\" & $SAMBA_Share)
			Else
				$MapNetworkDrive=DriveMapAdd ($SAMBA_DiskLetter, "\\" & $NAS_IP & "\" & $SAMBA_Share, 0, $SAMBA_Login, $SAMBA_Password)
			EndIf

			history("Network drive " & $SAMBA_DiskLetter & " mapped - " & $MapNetworkDrive & " Error " & @error)

		ElseIf $nas_mount==0 Then

			$MapNetworkDrive=DriveMapDel($SAMBA_DiskLetter)
			history("Network drive " & $SAMBA_DiskLetter & " unmapped - " & $MapNetworkDrive & " Error " & @error)

		EndIf

	EndFunc


	; Function to catch exeptions in NASPT (NTS_Samba_NASPT.au3)
	Func NASPT_windows()

		If WinActive("Large Memory Size") Then ControlClick("Large Memory Size", "", "[CLASS:Button; INSTANCE:1]")
		If WinActive("NASPT support notice") Then ControlClick("NASPT support notice", "", "[CLASS:Button; INSTANCE:1]")
		If WinActive("Prepare?") Then ControlClick("Prepare?", "", "[CLASS:Button; INSTANCE:1]")
		If WinActive("NASPT Configuration") Then ControlClick("NASPT Configuration", "", "[CLASS:Button; INSTANCE:1]")
		If WinActive("Invalid Directory") Then ControlClick("Invalid Directory", "", "[CLASS:Button; INSTANCE:1]")
		If WinActive("NASPT Test Complete") Then ControlClick("NASPT Test Complete", "", "[CLASS:Button; INSTANCE:1]")

	EndFunc