#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: Nas Test Script (NTS)
 Site: https://github.com/spikerwork/NasTestScript

 Script Function:

   The main part of Nas Test Script (NTS)

#ce ----------------------------------------------------------------------------

#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Icon=nas.ico
#AutoIt3Wrapper_Res_Comment="Nas Test Script"
#AutoIt3Wrapper_Res_Description="Nas Test Script"
#AutoIt3Wrapper_Res_Fileversion=0.1.2.2
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Nas Test Script
#AutoIt3Wrapper_Res_Field=ProductVersion|0.0.1.x
#AutoIt3Wrapper_Res_Field=OriginalFilename|NasTestScript.au3
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"

Dim $Current_Tests_array ; Array with tests
Local $t=0, $i, $l=0, $Current_Test_to_Run, $TestsUnDone=0, $MapNetworkDrive, $PathToSambaFolder
$Current_Tests_array = _StringExplode($Current_Tests, "|", 0) ; Tests to run

history("Current loop " & $Current_Loop)
history("Total loops " & $Number_of_loops)
history("Choosen tests " & $Current_Tests)
history("Pause between each action " & $ClientPause)
history("ClearCache " & $ClearCache)

If FileExists($testsini) Then

	While $t <= UBound($Current_Tests_array)-1

		Local $var = IniReadSection($testsini, $Current_Tests_array[$t])
		history("Read test parameters from section " & $Current_Tests_array[$t])

		If @error Then
			history("Problem with ini-file " & $testsini)
		Else
			; Section read cycle
			For $i = 1 To $var[0][0]

				If $var[$i][1]==0 Then



				MsgBox(0,$Current_Tests_array[$t],$var[$i][0])






				EndIf

			Next

		EndIf

		$var=0 ; Clear array
		$t+=1 ; Raise loop
	WEnd

EndIf


MsgBox(0,"","lol")

#include "Libs\foot.au3"




