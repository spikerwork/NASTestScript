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



   ; Computer activity gatherer Daemon
   Func ActivityDaemon()

	IniWrite($timeini, "Start", "WMI", GetUnixTimeStamp())
	IniWrite($timeini, "WMI", "Fresh", 1)
	history ("Start WMI daemon...")


	  $objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}\\.\root\cimv2")

	  Local $time=0 ; Cycle timer
	  Local $worktime=0 ; All timer

	  While 1

		If IniRead($timeini, "WMI", "Fresh", 1)==1 Then

			If IniRead($timeini, "Start", "WMI", 0)+$TimeStampShift < GetUnixTimeStamp() Then
			IniWrite($timeini, "WMI", "Fresh", 0)
			IniWrite($timeini, "Start", "Resume", GetUnixTimeStamp())
			EndIf

		Else
		history ("Old WMI. Checking time skipped")
		EndIf


	  $CPULoadArray[0]="0"
	  $HDDLoadArray[0]="0"

	  if $worktime==0 Then
		 $run = 1
	  Else
		 $run=$worktime/5+1
	  EndIf


	  $time=$time+0.5

		If $cpu_need==0 and $hdd_need==0 Then
		history ("Skiping WMI daemon. ")
		IniWrite($timeini, "WMI", "Fresh", 0)
		IniWrite($timeini, "Start", "Resume", GetUnixTimeStamp())
		ExitLoop
		EndIf

	  ; Gathering CPU WMI Information
		If $cpu_need==1 Then

		 $WMIQuery = $objWMIService.ExecQuery("SELECT * FROM Win32_Processor", "WQL",0x10+0x20)
		 For $obj In $WMIQuery
			  $Current_Clock = $obj.CurrentClockSpeed
			  $Load = $obj.LoadPercentage
		 Next

		 _ArrayAdd($CPULoadArray, $Load)

		 $CPU_Clock = "Current CPU Clock: " & $Current_Clock & " MHz"



			$CPU_Load = "Average CPU Load: " & $Load & " %"

		 Else
			$CPU_Clock = ""
			$CPU_Load = "CPULoad monitoring off"

		 EndIf

	  ; Gathering HDD WMI Information

		If $hdd_need==1 Then

		 $WMIQuery2 = $objWMIService.ExecQuery ("SELECT * FROM Win32_PerfFormattedData_PerfDisk_PhysicalDisk WHERE Name = '_Total'")

		 For $obj2 In $WMIQuery2
			   $hdd_activity = $obj2.PercentDiskTime
			   $hdd_bytes = $obj2.DiskBytesPerSec
		 Next

		_ArrayAdd($HDDLoadArray, $hdd_activity)

		$HDD_bytes = "HDD bytes sent (DiskBytesPerSec): " &  $hdd_bytes


		$HDD = "Average HDD Load (PercentDiskTime): " &  $hdd_activity

		 Else

			$HDD = "HDDLoad monitoring off"
			$HDD_bytes=" "

		 EndIf

		 $idle = "Elapsed Time: " & $time & " sec"

		 ToolTip("Cycle number " & $run & @CRLF & $CPU_Load & @CRLF & $CPU_Clock & @CRLF & $HDD & @CRLF & $HDD_bytes& @CRLF & $idle, 2000, 0, @ScriptName, 2,4)

		 Sleep(500)

	  if $time >= 5 Then

	  Local $i=0
	  Local $l=0
	  Local $r

			; CPU Array

			If $cpu_need==1 Then

			   $r=Ubound($CPULoadArray)
			   Do
			   $i=$i+1
			   $l=$l+$CPULoadArray[$i]
			   Until $i = $r-1
			   $CPULoadArray=0
			   Global $CPULoadArray[1]

			   $r=$r-1
			   $AverageLoadCPU=$l/$r

				$AverageLoadCPU=StringFormat ( "%d", $AverageLoadCPU)


			   ; CPU Load check
			   $cpu_percent_need=Number($cpu_percent_need)
			   $AverageLoadCPU=Number($AverageLoadCPU)

				history ("Current CPU Clock: " & $Current_Clock & " MHz")


			   If $AverageLoadCPU == "" Then $AverageLoadCPU=100

				  If $AverageLoadCPU > $cpu_percent_need Then

					 history ("Average CPU Load is too high — " & $AverageLoadCPU & "%. Default is " & $cpu_percent_need & "%")
					 $worktime=$worktime+$time
					 $time=0

				  Else

					 history ("Average CPU Load is low than — " & $cpu_percent_need & "%")

				  EndIf

			EndIf

			;--------------
			; HDD Array

			If $hdd_need==1 Then

			   $r=Ubound($HDDLoadArray)
			   $i=0
			   $l=0

			   Do
			   $i=$i+1
			   $l=$l+$HDDLoadArray[$i]
			   Until $i = $r-1
			   $HDDLoadArray=0
			   Global $HDDLoadArray[1]

			   $r=$r-1
			   $AverageLoadHDD=$l/$r
			   $AverageLoadHDD=StringFormat ( "%d", $AverageLoadHDD)

			   ; HDD Load Check
			   $hdd_percent_need=Number($hdd_percent_need)
			   $AverageLoadHDD=Number($AverageLoadHDD)

			   If $AverageLoadHDD == "" Then $AverageLoadHDD=100

			   history ("HDD bytes sent (DiskBytesPerSec): " &  $hdd_bytes)

				  If $AverageLoadHDD > $hdd_percent_need Then

					 history ("Average HDD Load is too high — " & $AverageLoadHDD & "%. Default is " & $hdd_percent_need & "%")
					 $worktime=$worktime+$time
					 $time=0

				  Else

					 history ("Average HDD Load is low than — " & $hdd_percent_need & "%")

				  EndIf

			EndIf

			if $time==0 Then history ("Next cycle initialized...")
			If $time<>0 Then ExitLoop


	  EndIf
	  WEnd

   $worktime +=5

   history ("System enter IDLE state, after " & $worktime & " seconds. " & $run & " cycles")

	; Time records

	$TimeStampStartScript=IniRead($timeini, "Start", "Time", 0)
	$TimeStampStartWMI=IniRead($timeini, "Start", "WMI", 0)
	$TimeStampResumeWMI=IniRead($timeini, "Start", "Resume", 0)


	Return $worktime & "|" & $run & "|" & $TimeStampStartScript & "|" & $TimeStampStartWMI & "|" & $TimeStampResumeWMI

	EndFunc
