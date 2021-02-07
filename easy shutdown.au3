#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ProgressConstants.au3>
#include <GuiEdit.au3>

HotKeySet('{ESC}', '_main')

$Form1 = GUICreate("ES", 226, 97, 192, 120)
$shutdown = GUICtrlCreateCombo("Shutdown", 16, 16, 89, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
GUICtrlSetData(-1, "Reboot|Hibernate|Log off")
$h = GUICtrlCreateInput("", 120, 16, 25, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
_GUICtrlEdit_SetCueBanner($h, 'h')
$m = GUICtrlCreateInput("", 152, 16, 25, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
_GUICtrlEdit_SetCueBanner($m, 'm')
$s = GUICtrlCreateInput("", 184, 16, 25, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
_GUICtrlEdit_SetCueBanner($s, 's')
$Start = GUICtrlCreateButton("Start", 27, 48, 171, 25)

$h_input = GUICtrlRead($h)
$m_input = GUICtrlRead($m)
$s_input = GUICtrlRead($s)
$combo = GUICtrlRead($shutdown)
GUISetState(@SW_SHOW)

Local $min = 60
Local $tick = 0
Local $i
Local $xsec = $i

_main()

Func _main()
	$tick = 0
	$i = 0
	GUICtrlSetData($Start, 'Start')
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $Start
				$h_input = GUICtrlRead($h)
				$m_input = GUICtrlRead($m)
				$s_input = GUICtrlRead($s)
				$combo = GUICtrlRead($shutdown)

				If $h_input = "" Then
					$h_input = 0
				EndIf
				If $m_input = "" Then
					$m_input = 0
				EndIf
				If $s_input = "" Then
					$s_input = 0
				EndIf

				$i = ($h_input * 3600) + ($m_input * 60) + ($s_input)
				Local $percent = Int(($i * 100) / $tick)
				Global $xmin = $m_input
				If $i <> 0 Then
					mode('Shutdown', 1)
					mode('Hibernate', 64)
					mode('Reboot', 2)
					mode('Log off', 0)
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>_main

Func mode($mod, $num)
	If $combo = $mod Then
		Do
			GUICtrlSetData($Start, $mod & ': ' & $tick & ' / ' & $i & 's')
			$tick += 1
			Sleep(1000)
		Until ($i = $tick)
		Shutdown($num)
	EndIf
EndFunc   ;==>mode

Func _ex()
	Exit
EndFunc   ;==>_ex
