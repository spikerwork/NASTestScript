#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: VPN Reconnect
 Site: https://github.com/spikerwork/VPN_Reconnect

 Script Function:
	The main library for VPN_Reconnect
	Include external and internal libs

#ce --------------------------------------------------------------------

; Internal autoit libs
#include <Array.au3>
#include <GuiConstants.au3>
#include <StaticConstants.au3>
#include <File.au3>
#include <WinAPI.au3>
#include <Constants.au3>
#include <Date.au3>
#include <Crypt.au3>

; My external libs
#include "Vars.au3" ; Network functions
#include "Functions.au3" ; Network functions
#include "AzUnixTime.au3" ; Unix timestamp