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
#AutoIt3Wrapper_Res_Fileversion=0.0.1.1
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Nas Test Script
#AutoIt3Wrapper_Res_Field=ProductVersion|0.0.1.x
#AutoIt3Wrapper_Res_Field=OriginalFilename|NTS_Test.au3
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"

Dim $Current_Tests_array ; Array with tests
Local $t=0, $i, $Current_Test_to_Run, $TestsUnDone=0
$Current_Tests_array = _StringExplode($Current_Tests, "|", 0)

;Global Vars $Current_Loop, $Number_of_loops, $Current_Tests, $ClientPause, $ClearCache

history("Current loop " & $Current_Loop)
history("Total loops " & $Number_of_loops)
history("Choosen tests " & $Current_Tests)
history("Pause between each action " & $ClientPause)

If $Current_Loop>=$Number_of_loops Then

	history("Test finished. Run results ")

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
						PauseTime($ClientPause)
						$TestsUnDone=1
						halt("lol")
						ExitLoop()

					ElseIf $var[$i][0]=="Prepare" Then

						$TestsUnDone=1
						If $ClearCache==1 Then Prepare(1) ; If ClearCache enabled, run this function before test prepare
						PauseTime($ClientPause)
						$Current_Test_to_Run=$Current_Tests_array[$t] & " " & $var[$i][0] & " " & $Current_Loop
						history("Test to run " & $Current_Tests_array[$t] & ". Mode " & $var[$i][0])
						ShellExecute($ScriptFolder & "\" & "NTS_" & $Current_Tests_array[$t] & ".exe", $Current_Test_to_Run, $ScriptFolder)
						ExitLoop(2)

					Else ; Main test starts

						$TestsUnDone=1
						$Current_Test_to_Run=$Current_Tests_array[$t] & " " & $var[$i][0] & " " & $Current_Loop
						history("Test to run " & $Current_Tests_array[$t] & ". Mode " & $var[$i][0])
						;ExitLoop(2) ; Exit this and first loop
						ShellExecute($ScriptFolder & "\" & "NTS_" & $Current_Tests_array[$t] & ".exe", $Current_Test_to_Run, $ScriptFolder) ; Run test with parameters
						ExitLoop(2)

					EndIf

				EndIf

			Next

		EndIf

		$var=0 ; Clear array
		$t+=1 ; Raise loop
	WEnd

EndIf

	If $TestsUnDone==0 Then
		history("Tests finished. Increasing LoopNumber ")
		IniWrite($testsini,"Runs","LoopNumber",$Current_Loop+1)
		halt("lol")
	EndIf

#include "Libs\foot.au3"
