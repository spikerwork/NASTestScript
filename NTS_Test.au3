#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: Nas Test Script
 Site: https://github.com/spikerwork/NasTestScript

 Script Function:

   Test Runner for Nas Test Script

#ce ----------------------------------------------------------------------------

#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Icon=nas.ico
#AutoIt3Wrapper_Res_Comment="Nas Test Script"
#AutoIt3Wrapper_Res_Description="Nas Test Script"
#AutoIt3Wrapper_Res_Fileversion=0.1.3.9
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Nas Test Script
#AutoIt3Wrapper_Res_Field=ProductVersion|0.1.3.x
#AutoIt3Wrapper_Res_Field=OriginalFilename|NTS_Test.au3
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"

EnvSet("SEE_MASK_NOZONECHECKS", "1")
EnvUpdate ( )

Dim $Current_Tests_array ; Array with tests
Local $t=0, $i, $l=0, $Current_Test_to_Run, $TestsUnDone=0, $MapNetworkDrive, $PathToSambaFolder
$Current_Tests_array = _StringExplode($Current_Tests, "|", 0) ; Tests to run

history("Current loop " & $Current_Loop)
history("Total loops " & $Number_of_loops)
history("Choosen tests " & $Current_Tests)
history("Pause between each action " & $ClientPause)

PauseTime($ClientPause+20)

; Check server availability

While 1

	$l+=1
	If $l>40 Then MsgBox(0, "Warning!", "Smth wrong with network. Can`t reach " & $NAS_IP)
	Sleep(3000)
	If Ping($NAS_IP, 2500)<>0 Then
		ExitLoop
	Else
		history("Check failed on - " & $l & ". Reason (1 Host is offline, 2 Host is unreachable, 3 Bad destination, 4 Other errors) - " & @error )
	EndIf

WEnd

history("Check NAS availability pass on checkrun - " & $l)


If $Current_Loop>=$Number_of_loops Then

	history("Test finished. Run results ")

	; Clear temp folders and files

	If DirGetSize($ScriptFolder & "\" & $Temp_Folder) <> -1 Then DirRemove( $ScriptFolder & "\" & $Temp_Folder)
	history($ScriptFolder & "\" & $Temp_Folder & " cleared")

	If DirGetSize($ScriptFolder & "\" & $resultfolder & "\" & $NASName) <> -1 Then DirRemove($ScriptFolder & "\" & $resultfolder & "\" & $NASName)
	history($ScriptFolder & "\" & $NASName & " cleared")

	If $ClearCache==1 Then Prepare(1) ; If ClearCache enabled, run this function before test prepare

	FileDelete(@StartupCommonDir & "\NTS_Test.lnk")

	MsgBox(0, "Finish", "All tests done.")

	Exit

Else

	While $t <= UBound($Current_Tests_array)-1

		Local $var = IniReadSection($testsini, $Current_Tests_array[$t])
		history("Read test parameters from section " & $Current_Tests_array[$t])

		If @error Then
			history("Problem with ini-file " & $testsini)
		Else
			; Section read cycle
			For $i = 1 To $var[0][0]

				If $var[$i][1]==0 Then

					If $var[$i][0]=="Clear" Then ; Finish test. Enable Cache and clear temporary files

						Prepare(0)
						IniWrite($testsini,$Current_Tests_array[$t],$var[$i][0],1)
						DirRemove ( $ScriptFolder & "\" & $Temp_Folder, 1)
						PauseTime($ClientPause)
						$TestsUnDone=1

							If $Current_Tests_array[$t]=="Samba" or $Current_Tests_array[$t]=="Samba_NASPT" Then

								NASMount (1)
								history($ScriptFolder & "\" & $Temp_Folder & " cleared")
								If $SAMBA_Folder=="" Then
									$PathToSambaFolder = $SAMBA_DiskLetter & "\" & $Temp_Folder ; Path to folder on NAS (without addition directory)
								Else
									$PathToSambaFolder = $SAMBA_DiskLetter & "\" & $SAMBA_Folder & "\" & $Temp_Folder ; Path to folder on NAS (with addition directory)
								EndIf
								_WinAPI_ShellFileOperation($PathToSambaFolder, "",  $FO_DELETE, BitOR($FOF_NOCONFIRMATION, $FOF_SIMPLEPROGRESS))
								history($PathToSambaFolder & " cleared")
								PauseTime($ClientPause)
								NASMount (0)

							EndIf

						halt("reboot")
						Exit

					ElseIf $var[$i][0]=="Prepare" Then

						$TestsUnDone=1
						If $ClearCache==1 Then Prepare(1) ; If ClearCache enabled, run this function before test prepare
						If DirGetSize($ScriptFolder & "\" & $Temp_Folder) = -1 Then DirCreate ( $ScriptFolder & "\" & $Temp_Folder)
						history("Test to run " & $Current_Tests_array[$t] & ". Mode " & $var[$i][0])
						PauseTime($ClientPause)
						$Current_Test_to_Run=$Current_Tests_array[$t] & " " & $var[$i][0] & " " & $Current_Loop
						ShellExecute($ScriptFolder & "\" & "NTS_" & $Current_Tests_array[$t] & ".exe", $Current_Test_to_Run, $ScriptFolder)
						ExitLoop(2)

					Else ; Main test starts

						$TestsUnDone=1
						history("Test to run " & $Current_Tests_array[$t] & ". Mode " & $var[$i][0])
						$Current_Test_to_Run=$Current_Tests_array[$t] & " " & $var[$i][0] & " " & $Current_Loop
						PauseTime($ClientPause)
						ShellExecute($ScriptFolder & "\" & "NTS_" & $Current_Tests_array[$t] & ".exe", $Current_Test_to_Run, $ScriptFolder) ; Run test with parameters
						ExitLoop(2) ; Exit this and first loop

					EndIf

				EndIf

			Next

		EndIf

		$var=0 ; Clear array
		$t+=1 ; Raise loop
	WEnd

EndIf

	; All tests finished?
	If $TestsUnDone==0 Then
		history("Tests finished. Increasing LoopNumber ")
		IniWrite($testsini,"Runs","LoopNumber", $Current_Loop+1)
		$t=0
		$i=0

		While $t <= UBound($Current_Tests_array)-1

			Local $var = IniReadSection($testsini, $Current_Tests_array[$t])
			history("Section to empty " & $Current_Tests_array[$t])

			If @error Then
				history("Problem with ini-file " & $testsini)
			Else

				For $i = 1 To $var[0][0]


				IniWrite($testsini, $Current_Tests_array[$t], $var[$i][0], 0) ; Empty all tests

				Next

			EndIf

		$var=0 ; Clear array
		$t+=1 ; Raise loop
		WEnd

		history("Ini-file " & $testsini & " reconstructed")

		halt("reboot")


	EndIf

#include "Libs\foot.au3"
