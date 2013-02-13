#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
;

Global $hGUI = GUICreate("Drag GUI Demo", 400, 330, -1, -1, -1, $WS_EX_CLIENTEDGE)

GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST")
GUIRegisterMsg($WM_WINDOWPOSCHANGING, "WM_WINDOWPOSCHANGING")

GUISetState()

GUICtrlCreateCheckbox("Passive Mode", 20, 80, 100, 20)

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            Exit
    EndSwitch
WEnd

Func WM_WINDOWPOSCHANGING($hWnd, $Msg, $wParam, $lParam)
    Local $stWinPos = DllStructCreate("uint;uint;int;int;int;int;uint", $lParam)

    Local $iLeft = DllStructGetData($stWinPos, 3)
    Local $iTop = DllStructGetData($stWinPos, 4)
    Local $iWidth = DllStructGetData($stWinPos, 5)
    Local $iHeight = DllStructGetData($stWinPos, 6)

    Local $aGUI_Pos = WinGetPos($hWnd)

    If $iHeight < $aGUI_Pos[3] Then
        $iNew_Top = -($aGUI_Pos[3]-$iHeight)-18 ;I am not sure that 18 will fit for all
        DllStructSetData($stWinPos, 4, $iNew_Top)
    EndIf
EndFunc

Func WM_NCHITTEST($hWnd, $iMsg, $wParam, $lParam)
    If $hWnd <> $hGUI Or $iMsg <> $WM_NCHITTEST Then Return $GUI_RUNDEFMSG

    Local $iRet = _WinAPI_DefWindowProc($hWnd, $iMsg, $wParam, $lParam)
    If $iRet = 1 Then Return 2

    Return $iRet
EndFunc