#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Users\Pablo Escobar\Downloads\favicon.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ProgressConstants.au3>
#include <GuiEdit.au3>



$Form1 = GUICreate("ES", 226, 97, 420, 420)
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

Local $time
Local $state = 0
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
		Local $aAccelKeys[2] = ["{ENTER}", $Start]
    GUISetAccelerators($aAccelKeys)
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $Start
				$time = TimerInit()
				$h_input = GUICtrlRead($h)
				$m_input = GUICtrlRead($m)
				$s_input = GUICtrlRead($s)
				$combo = GUICtrlRead($shutdown)

				$i = ($h_input * 3600) + ($m_input * 60) + ($s_input)

				If $state = 0 Then
					$state = 1
				ElseIf $state = 1 Then
					$state = 0
					_main()
				EndIf
		EndSwitch

		If $state = 1 Then
			mode('Shutdown', 1)
			mode('Hibernate', 64)
			mode('Reboot', 2)
			mode('Log off', 0)
		EndIf

	WEnd
EndFunc   ;==>_main

Func mode($mod, $num)
	Global $i_sec = $i
	Global $i_min = $i / 60
	Global $i_hour = $i / 3600

	If $combo = $mod Then
		$new = TimerDiff($time)
		$new = ($i * 1000) - $new
		$seconds = Round($new / 1000)
		$newHours = Floor($seconds / 3600)
		$newMin = Floor($seconds / 60)
		If $newMin >= 60 Then
			Do
				$newMin -= 60
			Until $newMin < 60
		EndIf
		$newSec = Mod($seconds, 60)
		If $newSec < 10 Then $newSec = "0" & $newSec
		GUICtrlSetData($Start, $mod & ': ' & $newHours & ':' & $newMin & ":" & $newSec)
		Sleep(50)
		If ($newSec = 0) And ($newMin = 0) And ($newHours = 0) Then
			Shutdown($num)
		EndIf
	EndIf
EndFunc   ;==>mode


