#RequireAdmin
#include <Array.au3>
#include <ScreenCapture.au3>
#include <Date.au3>

Global $g_bPaused = False
HotKeySet("{ESC}", "TogglePause")

Sleep(2000)

StartGenshin()
WindowSize()
ClickEmail()
StartGame()
waitTilGamefinishsLoading()
FullScreen()
;endGame()

;Shutdown($SD_STANDBY)
Exit

Func isColor($positionX, $positionY, $color, $variation = 5)
   $range = 1;was 5
   $cords = PixelSearch($positionX - $range, $positionY - $range, $positionX + $range, $positionY + $range, $color, $variation);when a certain color shows up
   If Not @error Then
	  return True
   EndIf
   return False
EndFunc

;This function change the game into the full screen mode
Func FullScreen()
   $gi = WinWait("[CLASS:UnityWndClass]", "", 150);wait up to 150 sec until the program to start
   WinActivate($gi)
   $aWin_Pos = WinGetPos("[ACTIVE]")
   Sleep(1000)
   If $aWin_Pos[2] <> @DesktopWidth Or $aWin_Pos[3] <> @DesktopHeight Then
	  Send("!+{Enter}")
   EndIf
EndFunc   ;==>FullScreen

;This function change the game into the window size
Func WindowSize()
   ToolTip("waiting for up to 2 mins for the game to load",0,0)
   waitTil2(1816, 998, 0x222222, 1806, 996, 0xFFFFFF, 2 * 60 * 1000)
   ToolTip("changing to window size if needed",0,0)
   $gi = WinWait("[CLASS:UnityWndClass]", "", 150);wait up to 150 sec until the program to start
   WinActivate($gi)
   Sleep(1000)
   $aWin_Pos = WinGetPos("[ACTIVE]")
   If $aWin_Pos[2] = @DesktopWidth And $aWin_Pos[3] = @DesktopHeight Then
	  Send("!+{Enter}")
   EndIf
   ToolTip("",0,0)
EndFunc   ;==>WindowSize

;This function clicks on a certain pixel
Func clk($x,$y,$msg="",$clr=0)
   ToolTip($msg,0,0)
   If $clr == 0 Then
	  MouseClick("left", $x, $y)
	  Sleep(1000)
   Else
	  return tryToClick($x, $y, $clr)
   EndIf
   ToolTip("",0,0)
EndFunc   ;==>clk

;This function clicks on a certain pixel if it is a certain color
Func tryToClick($x, $y, $color)
   If isColor($x, $y, $color) Then
	  clickOn($x, $y)
	  MouseMove($x+50, $y+50)
	  If isColor($x, $y, $color) Then
		 clickOn($x, $y)
		 MouseMove($x+100, $y+100)
		 If isColor($x, $y, $color) Then
			clickOn($x, $y)
		 EndIf
		 Return True
	  Else
		 Return True
	  EndIf
   EndIf
   Return False
EndFunc   ;==>clk


;This function waits until one of 2 certain pixels change to certain colors
Func waitTil2Or($x, $y, $color, $x2, $y2, $color2, $timeout = 99999, $variation = 10)
   $init = TimerInit()
   While True
	  If TimerDiff($init) > $timeout Then ExitLoop
	  If isColor($x, $y, $color, $variation) Or isColor($x2, $y2, $color2, $variation) Then
		 return True
	  EndIf
   WEnd
   return False
EndFunc   ;==>waitTil2Or

;This function waits until 2 certain pixels change to certain colors
Func waitTil2($x, $y, $color, $x2, $y2, $color2, $timeout = 99999, $variation = 10)
   $init = TimerInit()
   While True
	  If TimerDiff($init) > $timeout Then ExitLoop
	  If isColor($x, $y, $color, $variation) And isColor($x2, $y2, $color2, $variation) Then
		 return True
	  EndIf
   WEnd
   return False
EndFunc   ;==>waitTil2

;This function waits until a certain pixel changes to a certain color
Func waitTil($x, $y, $color, $timeout = 99999, $variation = 10)
   $init = TimerInit()
   While True
	  If TimerDiff($init) > $timeout Then ExitLoop
	  If isColor($x, $y, $color, $variation) Then
		 return True
	  EndIf
   WEnd
   return False
EndFunc   ;==>waitTil

;This function start the genshin program (the launcher) and then clicks on the yellow launch button to launch genshin.
Func StartGenshin()
   Run("D:\NA Genshin Impact\Genshin Impact\launcher.exe");start the program
   waitTil(1260, 768, 0xFFC507)
   Sleep(1000)
   MouseMove(1261, 769, "launch the game")
   clk(1260, 768, "launch the game")
EndFunc   ;==>StartGenshin

;This function waits until the yellow email to show up and then click on it.
Func ClickEmail()
   ToolTip("waiting up to nine minutes for the email(account name) to show up",0,0)
   waitTil2(952, 1045, 0xFFE14B, 1827, 910, 0x222222, 1000*60*9)

   clk(956, 546)
   ToolTip("",0,0)
EndFunc   ;==>ClickEmail

;This function waits until the start game button to show up and then click on it.
Func StartGame()
   ToolTip("waiting up to nine minutes for the start game UI to show up",0,0)
   waitTil2(999, 1042, 0xFFFFFF, 1833, 842, 0xFFFFFF, 1000*60*9)
   clk(958, 1048)
   ToolTip("",0,0)
EndFunc   ;==>StartGame

;This function waits until the yueka UI shows up or the game fully starts. It will take a screenshot and collect yueka if needed
Func waitTilGamefinishsLoading()
   ToolTip("waiting up to nine minutes for the game to load",0,0)
   waitTil2Or(968, 520, 0x4D5F90, 75, 52, 0xE8C28E, 1000*60*9)
   If isColor(968, 520, 0x4D5F90) Then
	  clk(968, 520)
	  clk(968, 520)
	  clk(997, 949)
   EndIf
EndFunc   ;==>waitTilGamefinishsLoading

;This function close the game and then close the launcher
Func endGame()
   ToolTip("Exiting the game in 3 seconds",0,0)
   Beep(1000)
   Sleep(1000 * 3)
   Send("!+{F4}")
   ToolTip("waiting for the launcher to show up",0,0)
   waitTil(1260, 768, 0xFFC507)
   clk(1568, 130)
   Sleep(1000)
EndFunc   ;==>endGame

;This function provides the ability to pause the script.
Func TogglePause()
    $g_bPaused = Not $g_bPaused
    While $g_bPaused
        Sleep(100)
        ToolTip('Script is "Paused"', 900, 0)
    WEnd
    ToolTip("",0,0)
EndFunc   ;==>TogglePause


Func goToSgsChrome()
   Global $chromeTitle = "三国杀官方正版_三国杀十周年全新起航_星火燎原重燃三国！ - Google Chrome"
   Global $chromeTitle2 = "三国杀官方正版_十周年全新资料篇_星火燎原重燃三国！ - Google Chrome"
   $windowTitle = $chromeTitle
   If NOT WinExists ($windowTitle, "") Then
   WinActivate($chromeTitle2)
   Else
	  WinActivate($chromeTitle)
   EndIf
EndFunc

Func clkExpect($x, $y, $msg, $expectX, $expectY, $color)
   clk($x, $y, $msg)
   Sleep(1000)
   If Not isColor($expectX, $expectY, $color) Then
	  clk($x, $y, "retrying "&$msg)
   EndIf
EndFunc

Func debugScreenshot()
   $sgsHandler = WinWait($chromeTitle, "", 100)
   $date = _DateTimeFormat(_NowCalc(), 1)
   $time = _DateTimeFormat(_NowCalc(), 3)
   $time = StringReplace($time, ":", "-");windows file name cannot contain the ":" character
   _ScreenCapture_CaptureWnd("D:\fun\sgs\debugScreenshot\questCollectDebug "&$time&" "&$date&".jpg", $sgsHandler)
EndFunc

Func consoleClientLogin($path, $choujiang=False)
   Run("D:\Program Files (x86)\Sgsc10th\Loader.exe");start the program
   Sleep(7000)
   ToolTip("waiting for the program to load",0,0)
   $sgs = WinWait($consoleTitle1, "", 50);wait up to 50 sec until the program to start
   If Not $sgs Then
	  $sgs = WinWait($consoleTitle2, "", 50);wait up to 50 sec until the program to start
   EndIf
   Sleep(1000)
   WinActivate($sgs)
   WinSetState($sgs, "", @SW_MAXIMIZE);max out the window so that the button are at a fixed location

   ToolTip("changing to English",0,0)

   changeToEnglish($sgs)
   clk(1540, 142, "close ToC")
   $credentialFileRead = FileRead ($path);has to use absolute path if running in the scheduler
   $credential = StringSplit($credentialFileRead, @CRLF)
   $credential = StringSplit($credential[1], " ")

   $user = $credential[1]
   $pass = $credential[2]

   Sleep(3000)
   clk(949, 633, "log out")
   Sleep(4000)

   clk(1017, 178, "refresh early")

   clk(1017, 178, "waiting for the login page to show up")
   Sleep(3000)
   clk(911, 395, "user")
   Send($user,1)
   clk(937, 457, "pass")
   Send($pass,1)

   $meichaoshi = False
   while Not $meichaoshi
	  clk(965, 568, "enter the game")
	  clk(1639, 248,"close ToS")
	  ToolTip("waiting for the game to login",0,0)
	  $meichaoshi = waitTil(1149, 636, 0xEBCD98, 5000) Or waitTil(1114, 637, 0xCECECE, 5000)
	  If $meichaoshi Then
		 ExitLoop
	  EndIf
   WEnd
   ToolTip("entering the game",0,0)
   clickOn(1121, 633);enter the game

   $timeOut = 0
   While True
	  Sleep(5000)
	  clk(1339, 157, "trying to load game")
	  speeduppopup()
	  clk(791, 652, "continue log in", 0x6F8D55)
	  If isColor(1747, 944, 0x291714) Or isColor(893, 757, 0x956A40, 3) Or isColor(1409, 290, 0xBE8B3F, 3) Or isColor(1594, 219, 0xC2863A, 3) Or isColor(1373, 297, 0xD96644, 3) Then
		 ExitLoop
	  EndIf

	  If $timeOut >= 60 Then; if they can't sign for 1 minute (roughly because clk takes roughly 1 sec)
		 clk(1344, 842, "login stuck, trying to reload the game")
		 Beep(10000);notice me and fix it manually (they may show a yellow button to click on in order to proceed)
	  EndIf

	  If isColor(882, 895, "0xFDE375",4) Then;xin saiji
		 clk(882, 895, "clk kaiqi xinsaiji")
		 ExitLoop
	  EndIf
   WEnd

   ToolTip("console login finished here")
   Sleep(1000)

   If Not $Choujiang Then
	  WinClose($sgs)
	  Return
   EndIf

   ;autoPopUpqiandao(True)
   Sleep(5000);wait for 5 sec for the pop up to load
   randomNotificationsCheck()

   ToolTip("closing non-arena time notification",0,0)
   If isColor(1030, 620, 0xA28362) Then
	  clk(1030, 620, "clicking on canel to close the pop up window")
   EndIf
   ;autoPopUpqiandao(True)
   randomNotificationsCheck()

   Sleep(1000)
   clickOn(231, 826-45);leave zhulu but not click on saishi

   ;autoPopUpqiandao(True)
   Sleep(3000)
   randomNotificationsCheck();goka start throwing pop up on the home page

   ToolTip("waiting up to 7 sec for the page to fully load",0,0)
   waitTil(458, 94, 0x281A0D, 7000)
   ToolTip("waiting for another 3 sec before try to choujiang",0,0)
   Sleep(3000)
   ToolTip("")

   choujiang(True)

   WinClose($sgs)
EndFunc

Func choujiang($earlyEnd=False)
   ToolTip("Starting to choujiang",0,0)
   Sleep(1000)
   ToolTip("",0,0)

   clickOn(1537, 679);click on hero setting
   While True
	  Sleep(1000)

	  If isColor(1686, 837, 0x4C2717) Then
		 ExitLoop
	  EndIf
   WEnd
   clickOn(1689, 773);click hero recruit
   waitTil(1443, 377,0x111555, 15000);wait for the hero recruit page to load
   Sleep(2000)
   clickOn(1140, 628);click on xingjiang recruit
   waitTil(937, 890-50,0x882627);wait for the xingjiang recruit page to load
   Sleep(1000)
   clickOn(786, 836);hit recruit once; somehow it often bugs out on this line
   Sleep(5000);wait 5 sec for the recuit animation
   $sgsHandler = WinWait("[CLASS:CefBrowserWindow]", "", 100)
   $dateTime = _DateTimeFormat(_NowCalc(), 1)
   _ScreenCapture_CaptureWnd("D:\fun\sgs\screenshot\heroRecruit "&$dateTime&".jpg", $sgsHandler)
   If $earlyEnd Then
	  Return
   EndIf
   clickOn(1087, 902);return
   clickOn(259, 796);leave the page
   Sleep(2000);wait for 2 sec to load the UI
   clickOn(259, 796);leave the page
   Sleep(2000);wait for 2 sec to load the UI
   clickOn(259, 796);leave the page
   Sleep(2000);wait for 2 sec to load the UIs
EndFunc

Func dahaoSonghua($activeMode = 1)
   Sleep(2000)
   maihua()

   If $activeMode Then
	  $playedToday = True; if i have been very active, then always skip this
   EndIf

   If $playedToday Then
	  Return;no need to songhua if i have actively played today
   EndIf

   $cords = PixelSearch(1065, 988, 1311, 1017, "0x722D09", 5)
   $doingSonghua = 0
   If Not @error Then
	  clickOn($cords[0],$cords[1]);click on the haoyoubuttong
	  clickOn($cords[0],$cords[1]);click on the haoyoubuttong
	  Sleep ( 2000 );wait 1 sec to load guild UI
	  $doingSonghua = 1
   EndIf

   If Not $doingSonghua Then
	  clk(1552, 257, "close")
	  Return
   EndIf

   Beep(500)
   Beep(500)
   ToolTip("wait for 10 s in case you want to choose who to give your flower today",0,0)

   clk(568, 379, "first friend")
   clk(1509, 327, "menu")
   clk(1553, 386, "songhua")
   ToolTip("waiting for up to 5 sec to see load ok button",0,0)
   waitTil(918, 724, 0xFEE370, 5000)
   ToolTip("")
   clk(922, 726, "ok")
   If isColor(1377, 381, 0xCF4521) Then
	  clk(1377, 381, "close in case out of flower")
   EndIf
   clk(1552, 262, "close")
   Sleep(3000);wait 3 sec for the animation to go away or the guild color won't be right
EndFunc

Func songhua()
   $alreadyBoughtToday = maihua()
   If $alreadyBoughtToday Then
	  Return
   EndIf

   $cords = PixelSearch(1065, 988, 1311, 1017, "0x722D09", 5)
   $doingSonghua = 0
   If Not @error Then
	  clickOn($cords[0],$cords[1]);click on the haoyoubuttong
	  clickOn($cords[0],$cords[1]);click on the haoyoubuttong
	  Sleep ( 2000 );wait 1 sec to load guild UI
	  $doingSonghua = 1
   EndIf

   If Not $doingSonghua Then
	  clk(1552, 257, "close")
	  Return
   EndIf

   clk(572, 295, "click on the friend search bar")
   Send("欲偕老却白头")
   clk(678, 293, "search")
   clk(1432, 389, "options")
   clk(1471, 454, "songhua")
   ToolTip("waiting for up to 5 sec to see load ok button",0,0)
   waitTil(918, 724, 0xFEE370, 5000)
   ToolTip("")
   clk(922, 726, "ok")
   waitTil(1062, 482, 0x6F5928, 5000)
   clk(1552, 262, "close")

EndFunc

Func maizhaomuling()
   If isColor(518, 408, 0xD2A001) Then
	  clk(518, 408, "clk zhaomuling")
	  waitTil(919, 767, 0xBE8445)
	  clk(919, 767, "ok")
	  clk(1040, 891, "remove pop up")
   EndIf
EndFunc

Func TryToBuyFlowerAt($x, $y, $color);deprecated
   If isColor($x, $y, $color, 3) Then
	  clk($x, $y, "buy flower")
	  waitTil(921, 768, 0xC18845, 10, 5000)
	  If Not isColor(994, 706, 0xB0781B) Then
		 clk(919, 756, "ok")
	  Else
		 clk(1370, 348, "close")
	  EndIf
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func zhaomulingzhoukayueka()
   If isColor(391, 617, 0xD00100, 10) Then
	  clk(391, 617, "clk on kabao")
	  If isColor(1196, 730, 0xDA0202, 10) Then
		 clk(1201, 732, "clk on zhaomulingzhouka", 0xCC0103)
		 clk(1466, 731, "clk anywhere to remove popup")
	  EndIf
	  If isColor(1460, 729, 0xDA0202, 10) Then
		 clk(1466, 731, "clk on zhaomulingyueka", 0xD00304)
		 clk(1466, 731, "clk anywhere to remove popup")
	  EndIf
   EndIf
EndFunc

Func maihua($maizhaomuling=True)
   $alreadyBoughtToday = False
   clkExpect(1622, 988, "shop", 1601, 292, 0xB43218)
   waitTil(387, 488, 0x442B1B)

   zhaomulingzhoukayueka()

   clk(320, 493, "silver tab")

   ToolTip("wait for 5 sec to have the flower UI to show up",0,0)
   Sleep(5000)

   If isColor(778, 298, 0x6B5D46) Then
	  clk(354, 566, "miaosha week")
   EndIf

   If $maizhaomuling Then
	  maizhaomuling();only need to do this once a month
   EndIf

   if isColor(1477, 418, 0xD00F1A) Then
	  clk(1477, 418, "maihua with zhaomuling")
	  waitTil(919, 767, 0xBE8445, 10)
	  clk(919, 767, "ok")
	  clk(1040, 891, "remove pop up")
   ElseIf isColor(1287, 415, 0xD40F1A) Then
	  clk(1287, 415, "maihua")
	  waitTil(919, 767, 0xBE8445, 30000)
	  clk(919, 767, "ok")
	  clk(1040, 891, "remove pop up")
   Else
	  $alreadyBoughtToday = True
   EndIf
   clk(1592, 261,"close")
   return $alreadyBoughtToday
EndFunc

Func zhanchangBonus()
   If isColor(1478, 965, 0xC00301, 5) Then
	  waitTil(303, 365, 0xC89345)
	  clickOn(1464, 986)
	  Sleep(1111)
	  tryToClick(306, 605, 0x3E2615);
	  tryToClick(878, 534, 0x3D932A);lvdan
	  tryToClick(1102, 655, 0x78562A);max
	  tryToClick(986, 772, 0xDC9B4F);ok
	  clk(1557, 261, "close")
   EndIf
EndFunc

Func accpetInvitation($onOrOff)
   MouseClick("left", 1679, 139);click on setting
   Sleep ( 1000 );wait 1 sec to load the game
   MouseClick("left", 1280, 463);click on the dropdown
   Sleep ( 1000 );wait 1 sec to load the dropdown
   If $onOrOff == "off" Then
	  MouseClick("left", 1165, 526+50);reject all invitation
   ElseIf $onOrOff == "on" Then
	  MouseClick("left", 1126, 446+50);accept all invitation
   EndIf

   MouseClick("left", 1136, 676+50);save
   Sleep ( 1000 );wait 1 sec to close the UI
EndFunc

Func zhanchang()
   If isColor(1478, 965, 0xC00301, 5) Then
	  clickOn(1464, 986)
	  Sleep(1111)
	  If isColor(349, 324, 0xD40100, 5) Then
		 clk(349, 324, "dengjijiangli")
	  EndIf
	  If isColor(353, 404, 0xD40101, 5) Then
		 clk(353, 404, "dengjijiangli")
	  EndIf
	  clk(781, 866, "clicking on one-button to collect zhanchang bonus")
	  clk(1274, 326, "click the close button on zhanchangshengji")
	  clk(1556, 259);exit
   EndIf
EndFunc

Func _SetKeyboardLayout($sLayoutID, $hWnd)
    Local $WM_INPUTLANGCHANGEREQUEST = 0x50
    Local $ret = DllCall("user32.dll", "long", "LoadKeyboardLayout", "str", $sLayoutID, "int", 0)
    DllCall("user32.dll", "ptr", "SendMessage", "hwnd", $hWnd, _
   "int", $WM_INPUTLANGCHANGEREQUEST, _
   "int", 1, _
   "int", $ret[0])
EndFunc



Func wuqi()
   Sleep(1000)
   If isColor(1709, 347, 0xFFD93F,11) Then
	  clk(1709, 347, "go to wuqi jiemian")
	  clk(1705, 604, "collect cailiao")
	  clk(779, 605, "remove popup")
   EndIf
EndFunc

Func jianglingMoves($chuzheng = 0, $shengji = 0, $guhuihe = 0)
   goToHomePage()

   guildCheck()

   ToolTip("Doing jiangling moves",0,0)
   Sleep(1000)
   clickOn(579, 854)
   clickOn(625, 841)

   waitTil(1616, 938, 0xF2D29B, 9000);wait for up to 9 sec to load the jiangling UI

   clk(845, 348, "jubaopen")
   clk(1723, 998, "remove animation")

   If isColor(219, 251, 0x794336) Then
	  clk(1737, 138, "leave")
	  waitTil(1616, 938, 0xF2D29B, 30000);wait for up to 30 sec to load the jiangling UI (it once took 15+ seconds)
   EndIf

   If $chuzheng Then
	  clk(489, 316, "chuzheng")
	  waitTil(1122, 840, 0xFDE474, 10000);wait up to 10 sec for the chuzheng bonus to load

	  If Not isColor(938, 876, 0xFDE473, 15) Or Not isColor(1607, 293, 0xDC6743, 15) Then;if the chuzheng work is not in progress
		 Sleep(3000)
		 If isColor(1128, 835, 0xFEE47B) Then;may be out of date
			clk(1125, 836, "collect chuzheng bonus")
		 EndIf
		 If isColor(1122, 842, 0xFCE370) Then
			clk(1122, 842, "collect chuzheng bonus")
		 EndIf
		 clk(1575, 209, "choose the 1st jiangling")
		 clk(767, 854, "ok")
		 clk(803, 681, "confirm ok")

		 $chuji1 = isColor(1330, 283, 0x9A7A5E)
		 $chuji2 = isColor(1340, 472, 0x9A7A5E)
		 $chuji3 = isColor(1321, 653, 0x98785F)
		 $zhongji1 = isColor(1349, 278, 0x93688D)
		 $zhongji2 = isColor(1342, 467, 0x93688D)
		 $zhongji3 = isColor(1334, 652, 0x91678C)
		 $gaoji1 = isColor(1365, 283, 0xCD982D)
		 $gaoji2 = isColor(1342, 467, 0xCD952B)
		 $gaoji3 = isColor(1339, 657, 0xCD952B)
		 $dingji1 = isColor(1299, 278, 0xB6403F)
		 $dingji2 = isColor(1320, 467, 0xB8423F)
		 $dingji3 = isColor(1325, 656, 0xB8423F)

		 Beep(5555)
		 Sleep(5555)

		 If $dingji1 Then
			clk(1572, 389, "1st quest")
		 ElseIf $dingji2 Then
			clk(1573, 577, "2nd quest")
		 ElseIf $dingji3 Then
			clk(1572, 766, "3rd quest")
		 ElseIf $gaoji1 Then
			clk(1558, 391, "1st quest")
		 ElseIf $gaoji2 Then
			clk(1573, 577, "2nd quest")
		 ElseIf $gaoji3 Then
			clk(1572, 766, "3rd quest")
		 ElseIf $zhongji1 Then
			clk(1558, 391, "1st quest")
		 ElseIf $zhongji2 Then
			clk(1575, 577, "2nd quest")
		 ElseIf $zhongji3 Then
			clk(1572, 766, "3rd quest")
		 Else
			clk(1568, 581, "3rd quest")
		 EndIf

		 clk(809, 683, "ok")

		 waitTil(440, 832, 0x512220, 5000);wait for up to 5 sec for the animation to stop

		 If isColor(1604, 292, 0xDC6745) Then
			clk(1592, 274, "go back")
		 Else
			clk(1735, 135, "fanhui in case running out of silver")
		 EndIf
	  Else
		 clk(1592, 274, "go back")
	  EndIf
		 Sleep(1500)
   EndIf

   If $guhuihe Then
	  clk(1182, 341, "guhuihe")
	  waitTil(646, 890, 0x495485, 3000);wait up to 3 sec for guhuihe
	  clk(646, 890, "open a guhuihe")
	  If isColor(928, 709, 0xBD8C07) Then;if run out of guhuihe
		 clk(1375, 344, "close window to buy guhuihe with yuanbao")
	  EndIf
	  Sleep(2000)
	  clk(228, 823, "go back")
   EndIf

   If $shengji Then
	  shengjijiangling($shengji);new UI need some work to adapt
   EndIf

   wuqi()

   clk(228, 823, "go back")
EndFunc

Func shengjijiangling($position=5)
   clk(1622, 939, "clk jiangling list")

   If $position == 1 Then
	  clk(469, 388, "clk the 1st jiangling")
   EndIf

   If $position == 2 Then
	  clk(662, 399, "clk the 2nd jiangling")
   EndIf

   If $position == 3 Then
	  clk(864, 403, "clk the 3rd jiangling")
   EndIf

   If $position == 4 Then
	  clk(1053, 392, "clk the 4th jiangling")
   EndIf

   If $position == 5 Then
	  clk(1253, 408, "clk the 5th jiangling")
   EndIf

   WaitTil(1639, 1001, 0x8F2321, 3000)
   WaitTil(916, 386, 0x882D23, 5000)

   While isColor(513, 787, 0xFE73A1,11);if there are still purple egg
	  $wasBlue = isColor(546, 653, 0xEFA93A)
	  $wasBlue2 = isColor(675, 654, 0xF0AC3A)
	  $wasBlue3 = isColor(824, 654, 0xF0AC3A)

	  clk(513, 787, "eat a purple egg")
	  clk(905, 745, "ok")
	  Sleep(1000)

	  If $wasBlue And isColor(545, 653, 0x332623) Then;when it is not blue
		 ExitLoop
	  EndIf

	  If $wasBlue2 And isColor(683, 653, 0x332623) Then;when it is not blue
		 ExitLoop
	  EndIf

	  If $wasBlue3 And isColor(828, 653, 0x332623) Then;when it is not blue
		 ExitLoop
	  EndIf
   WEnd

   ;fix this when i can jinhua
   ;If isColor(1105, 765, 0xF1A32E) and isColor(1309, 835, 0xFEE373) Then
	;  clk(1309, 835, "jinhua")
	;  clk(827, 841, "skip animation")
	;  clk(827, 841, "ok")
   ;EndIf

   jinhua()

   debugScreenshot()

   clk(1733, 135, "closing jiangling shengji")
   waitTil(1562, 297, 0xD34B2B, 3000)
   clk(1561, 262, "closing jiangling")
   waitTil(231, 865, 0x351E2E, 3000)
EndFunc

Func jinhua()
   If isColor(572, 865, 0xFDE36E) Then
	  clk(572, 865)
	  If isColor(885, 685, 0xD09046) Then
		 clk(885, 685)
		 waitTil(911, 842, 0xFDE36C, 20000);wait up to 20 sec to load the animation
		 clk(911, 842)
	  EndIf
   EndIf
   If isColor(1038, 700, 0xB08F6B) Then
	  clk(1038, 700, "quxiao zhuansheng")
   EndIf
EndFunc

Func goToHomePage()
   ToolTip("Going back to the home page",0,0)
   clk(231, 825, "click to go back to home page")
   Sleep(5000)
   clk(231, 825, "extra click to bypass possible new hero video")
   Sleep(1000)
   ToolTip("",0,0)
EndFunc

Func sanguoShow()
   ToolTip("checkinging sanguoshow",0,0)
   If isColor(1621, 729, "0xCF0200", 5) Or isColor(1641, 704, "0xDA0202", 5) Then
	  ToolTip("Clicking on the sanguoshow button",0,0)
	  clickOn(1621, 729);click on the sanguo show button
	  While Not waitTil(644, 625, 0x6A85B3, 2000)
		 clickOn(1621, 729)
	  WEnd
	  ToolTip("",0,0)
	  MouseClick("left", 632, 585+50);click on the collect sanguo show button
	  Sleep ( 2000 );wait 2 sec to finish sanguo show collecting UI
	  MouseClick("left", 215, 782+50);leave the 1st sanguoshow UI
	  Sleep ( 2000 );wait 1 sec to finish the 1st sanguo show leaving UI
	  MouseClick("left", 215, 782+50);leave the 2nd sanguoshow UI
	  Sleep ( 3000 );wait 3 sec to finish the 2nd sanguo show leaving UI
	  randomNotificationsCheck()
   EndIf
   ToolTip("",0,0)
EndFunc

Func findColor($x1,$y1,$x2,$y2,$color,$var=0)
   $cords = PixelSearch($x1,$y1,$x2,$y2,$color,$var);if found color in the zone

   If Not @error Then
	  return $cords
   EndIf

   return False
EndFunc

Func huodongqiandao()
   ToolTip("huodong qiandao",0,0)
   realhuodongqiandao()
   clk(213, 737, "in case the silver100 has too many icons above")
   realhuodongqiandao()
EndFunc

Func realhuodongqiandao()
   If isColor(245, 268, 0xCC0103) Then
	  huodongqiandaoRun(245, 268)
   EndIf

   If isColor(244, 182, 0xD60001) Then
	  huodongqiandaoRun(244, 182)
   EndIf

   If isColor(244, 351, 0xD20000) Then
	  huodongqiandaoRun(244, 351)
   EndIf

   If isColor(245, 437, 0xC40204) Then
	  huodongqiandaoRun(245, 437)
   EndIf

   If isColor(244, 516, 0xDE0402) Then
	  huodongqiandaoRun(244, 516)
   EndIf
EndFunc

Func huodongqiandaoRun($x, $y)
   clickOn($x, $y)
   Sleep(1000)

   If isColor(349, 324, 0xCA0203, 10) Then
	  clickOn(349, 324)
	  If isColor(672, 281, 0xCC0103, 10) Then
		 clickOn(672, 281)
		 For $i = 4 To 1 Step -1
			$cords = PixelSearch(1338, 416, 1465, 868, "0xD00100", 15);if found clickable red dot
			If Not @error Then
			   clickOn($cords[0]-11, $cords[1]+11)
			EndIf
		 Next
		 MouseMove(1379, 512)
		 MouseWheel("down", 9);scoll all the way down
		 For $i = 4 To 1 Step -1
			$cords = PixelSearch(1335, 410, 1451, 887, "0xCF0200", 15);if found clickable red dot
			If Not @error Then
			   clickOn($cords[0]-11, $cords[1]+11)
			EndIf
		 Next
	  EndIf
   EndIf

   clksToRemoveNotifications()
   If isColor(1637, 257, 0xF8EEA0, 10) Then
	  $cords = PixelSearch(386, 271, 453, 795, "0xD40101", 15);if found clickable red dot
	  If Not @error Then
		 clickOn($cords[0]-11, $cords[1]+11)
	  EndIf
	  For $i = 4 To 1 Step -1
		 $cords = PixelSearch(933, 438, 1623, 495, "0xDB0303", 15);if found clickable red dot
		 If Not @error Then
			clickOn($cords[0]-11, $cords[1]+11)
		 EndIf
		 For $j = 4 To 1 Step -1
			$cords = PixelSearch(1435, 512, 1595, 908, "0xFEE478", 15);if found clickable yellow button
			If Not @error Then
			   clickOn($cords[0], $cords[1])
			EndIf
		 Next
	  Next
	  clk(1636, 257, "quit the zhounianqing page")
   EndIf

   If isColor(1563, 257, 0x895F1E, 10) Then
	  clk(1563, 257, "quit the qiridhenglu page")
   EndIf

   If isColor(1559, 301, 0x8E220C, 10) Then
	  clk(1556, 267, "quit the xianshishangcheng")
   EndIf

   If isColor(304, 364, 0xC79041, 10) Then
	  clk(1555, 261, "quit")
   EndIf
   ;in case jingji shenjiang liuyan
   If isColor(1512, 241, 0xB73C3C) Then
	  clickOn(1512, 241)
   EndIf

   tryToClick(1560, 299, 0xCC963B);zhaoyun window

   tryToClick(1628, 251, 0xCF3E3B);2023 chunjie close button
EndFunc

Func safeClick($x, $y, $color)
   If isColor($x, $y, $color) Then
	  clickOn($x, $y)
   EndIf
EndFunc

Func jiangYin()

   Sleep(2000)
   If isColor(1540, 685, 0xD00102) Or isColor(1560, 665, 0xCF0200) Then
	  clk(1529, 719, "click on the jiangyin button")
	  clk(1527, 717, "click on the jiangyin button again just in case")
	  Sleep ( 3000 );wait 3 sec to load jiangyin button
	  clk(1553, 838+50, "click on the mingjiangtang button")
	  waitTil(1169, 868, 0xA37243,30000);wait until the free jiangyin button to show up
	  MouseClick("left", 1220, 840);click on the button get a free one (y was 820, testing this spot to avoid dup)
	  Sleep ( 2000 );wait 2 sec to finish the animation
	  MouseClick("left", 1562, 210+50);click on the button to mingjiangtang
	  Sleep ( 3000 );wait 3 sec to load the jiangyin page (wait longer here just in case we have done it today)
	  MouseClick("left", 264, 769+50);click on the back button to go to the home page
	  Sleep(2000)
	  randomNotificationsCheck()
   EndIf
EndFunc

Func collect7thDayBonus()
   If isColor(206, 190, "0xBA3515", 3) And isColor(243, 184, "0xCC0103", 3) Then
	  ToolTip("Trying to collect the 7th day's bonus", 0, 0)
	  clickOn(206, 190)
	  clickOn(472, 301);1st day
	  clickOn(1395, 534);first quest
	  clickOn(635, 307);2nd day
	  clickOn(1395, 534);first quest
	  clickOn(789, 299);3rd day
	  clickOn(1395, 534);first quest
	  clickOn(960, 304);4th day
	  clickOn(1395, 534);first quest
	  clickOn(1129, 308);5th day
	  clickOn(1395, 534);first quest
	  clickOn(1286, 302);6th day
	  clickOn(1395, 534);first quest
	  clickOn(1461, 303);7th day
	  clickOn(1395, 534);first quest
	  clickOn(472, 301);1st day
	  clickOn(522, 631);1st day's putongjiangli
	  clickOn(1560, 259);close the window
	  ToolTip("", 0, 0)
   EndIf
EndFunc

Func playArena($times=2, $noob=False)
   If $playedToday Then
	  Return
   EndIf

   guildCheck()

   waitTil(861, 712, 0x281C10)
   Sleep(1500)
   clk(860, 712, "click on 2v2")

   $timeout = waitTil(818, 231, 0x876B53, 200000);one time it took 3 min

   If $timeout Then
	  MouseMove(960, 812)
	  clk(860, 712, "click on 2v2 again in case of bug")
   EndIf

   Sleep(2000)
   closeNotification()
   playJinjiChang($times, $noob)
EndFunc

Func playJinjiChang($times=2, $noob=False)
   If isColor(1577, 257, 0xE1E1E1) Then
	  $noob = True;if the color is grey here, we are a noob
   EndIf

   clk(811, 222, "clk on the jingji tab")
   Sleep(5000)
   If isColor(271, 236, 0x6F4926) Or isColor(237, 858, 0xA23D44) Then
	  ToolTip("arena is not open today",0,0)
	  Return
   EndIf

   For $i = $times to 1 Step -1
	  If $noob Then
		 $notshenfen = startBattle($times, $noob)
		 If $notshenfen == False Then
			ToolTip("shenfen jingji is done",0,0)
			Sleep(5000)
			goToHomePage()
			ToolTip("waiting for the zhangbao pop-up",0,0)
			Sleep(2000)
			clk(567, 495, "try to close the zhangbao pop-up")
			Return
		 EndIf
		 loseBattle()
	  Else
		 $notshenfen = startBattleNoneNoobie($times, $noob)
		 If $notshenfen == False Then
			ToolTip("noob shenfen jingji is done",0,0)
			Sleep(5000)
			goToHomePage()
			ToolTip("waiting for the zhangbao pop-up",0,0)
			Sleep(2000)
			clk(567, 495, "try to close the zhangbao pop-up")
			Return
		 EndIf
		 loseBattleNoneNoobie()
	  EndIf
	  battleEndPopUpCheck($noob)
	  lingdjiangling()
   Next

   goToHomePage()
   ToolTip("waiting for the zhangbao pop-up",0,0)
   Sleep(2000)
   clk(567, 495, "try to close the zhangbao pop-up")
EndFunc

Func lingdjiangling()
   ToolTip("check if we need to ling jiangling",0,0)
   Sleep(1000)
   If isColor(842, 908, 0x7891CB) Then
	  clk(845, 890, "gongsunzan")
	  Sleep(2222)
	  clk(822, 840, "ok")
	  waitTil(631, 568, 0xF1E2BF, 5000)

	  clk(383, 838, "clk gongsunzan")
	  waitTil(1031, 504, 0xFA8781, 5000)
	  clk(962, 586, "clk gongsunzan again")
	  clk(1047, 491, "chakanxiangqing")

	  waitTil(901, 336, 0x3F1915, 5000)

	  clk(901, 336, "ok to tutorial")
	  clk(901, 336, "ok to tutorial2")
	  clk(901, 336, "ok to tutorial3")

	  clk(310, 783, "green egg")
	  clk(926, 747, "ok")
	  waitTil(612, 863, 0xFDE681, 5000)
	  clk(448, 869, "zhuansheng")
	  clk(448, 869, "ok to zhuansheng")
	  clk(811, 684, "confirm to zhuansheng")
	  waitTil(632, 545, 0xECDDBA)
	  clk(828, 841, "ok to the new d jiangling")

	  clk(901, 336, "ok to tutorial")
	  clk(901, 336, "ok to tutorial2")
	  clk(901, 336, "ok to tutorial3")

	  clk(1737, 140, "go back to jiangling home page")

	  clk(1413, 421, "huanling")

	  waitTil(1109, 885, 0xA72121);wait til the huanling page is fully loaded

	  clk(653, 885, "open guhuihe")

	  waitTil(578, 758, 0xECDDBB);wait for the d jiangling animation is done

	  clk(827, 843, "hit ok")

	  clk(653, 885, "open guhuihe again")

	  waitTil(578, 758, 0xECDDBB);wait for the d jiangling animation is done again

	  clk(827, 843, "hit ok to the 2nd d jiangling")

	  clk(232, 848, "go back to the jiangliang home page")

	  Sleep(1000)
	  clk(228, 833, "go back to the main home page")
	  Sleep(2000)
   EndIf
EndFunc

Func levelUpForGuild()
   ToolTip("level up for guild", 0, 0)
   $started = 0
   while True
	  $cords = PixelSearch(1065, 933, 1502, 1025, "0xFF6A4D", 5)
	  If $cords <> 0 Then
		 ToolTip("", 0, 0)
		 Return
	  EndIf

	  $cords = PixelSearch(1064, 944, 1499, 1015, "0xDCC47A")
	  If $cords <> 0 Then
		 ToolTip("", 0, 0)
		 Return
	  EndIf

	  If isColor(1340, 974, 0xAA8632, 5) Then;guild icon shows up
		 Return
	  EndIf

	  If Not $started Then
		 Sleep(2000)
		 clickOn(889, 717);click on 2v2
		 Sleep(3000);wait 3 sec to load the 2v2 UI
		 $started = 1
	  EndIf

	  startBattle()
	  loseBattle()
	  randomNotificationsCheck()
   WEnd
   ToolTip("", 0, 0)
EndFunc

Func seventhDayFarm()
   clickOn(889, 717);click on 2v2
   Sleep(3000);wait 3 sec to load the 2v2 UI
   $totalBattleNum = 8
   For $i = $totalBattleNum To 1 Step -1
	  ToolTip("battle number " & $totalBattleNum - $i + 1, 0, 0)
	  startBattle()
	  If $i == 1 Then
		 loseBattle(1)
	  Else
		 loseBattle()
	  EndIf
	  ToolTip("", 0, 0)
	  randomNotificationsCheck()
   Next
EndFunc

Func startBattle($times=2, $noob=False)
   lingdjiangling()

   ToolTip('Trying to start a new battle', 0, 0)
   Sleep(1000)

   $timeoutinit = TimerInit()
   $matchfindingTimeout = 15000; 15 seconds
   clickOn(1377, 895);start match
   ToolTip('Trying to find out which stage it is at', 0, 0)
   Sleep(2000)
   ToolTip(isColor(1374, 899, 0xF0E48B), 0, 0)
   Sleep(1000)
   ToolTip(isColor(1166, 898, 0xEBD88A), 0, 0)
   Sleep(1000)
   ToolTip(Not isColor(956, 179, 0x871311, 15), 0, 0)
   Sleep(1000)

   While (isColor(1374, 899, 0xF0E48B) Or isColor(1166, 898, 0xEBD88A)) And Not isColor(956, 179, 0x871311, 15)
	  If TimerDiff($timeoutinit) > $matchfindingTimeout Then ExitLoop
	  clickOn(1377, 895);start match
	  ToolTip('Trying to find a match', 0, 0)

	  If isColor(1023, 694, 0xFFE379) Then
		 clk(1307, 404, "2v2 maxouted, close the box")
		 goToHomePage()
		 clk(726, 708, "shenfenmoshi")
		 closeNotification()
		 playJinjiChang($times, $noob)
		 ToolTip("shenfen jingji chang is done!!",0,0)
		 Sleep(11111)
		 Return False
	  EndIf

	  ToolTip('wait up to 7 seconds until the yellow start battle button shows up again', 0, 0)
	  waitTil(902, 942, 0xFDE370, 7000)
	  clk(902, 942, "click on the yellow start battle button")

	  ;if the button keeps being yellow, we are still waiting for everyong to confirm
	  While isColor(894, 904, 0xFFDF72)
		 ToolTip('Waiting for the game to start non-noob', 0, 0)
		 clk(902, 942, "click on the yellow start battle button again just in case it failed")
		 Sleep(1000)
	  WEnd
	  Sleep(2000)
	  ;everyone is ready, waiting for the game to start or fail to start
	  ToolTip('Everyone is ready, Waiting for the game to acutally start', 0, 0)
	  waitTil(1235, 284, 0x690D03, 15000)
   WEnd

   waitTil(1503, 911, 0xA0A0A0, 15000)

   ToolTip('Choosing a hero', 0, 0)
   clickOn(1256, 381);click on huangzhong
   clickOn(1280, 384);click on huangzhong 2
   clickOn(1558, 918);choose the hero
   Sleep(7000);wait 8 sec to start the game
   ToolTip('', 0, 0)
   Return True
EndFunc

Func startBattleNoneNoobie($times=2, $noob=False)
   ToolTip('Trying to start a new battle non-noob', 0, 0)
   clickOn(1377, 895);start match

   If isColor(1023, 694, 0xFFE379) Then
	  clk(1307, 404, "2v2 maxouted, close the box")
	  goToHomePage()
	  clk(726, 708, "shenfenmoshi")
	  closeNotification()
	  playJinjiChang($times, $noob)
	  Return False
   EndIf

   ToolTip('Trying to find a match non-noob', 0, 0)
   Sleep(6000);wait 6 sec to find a match

   While isColor(895, 941, 0xFDE273)
	  clickOn(967, 956);start game
	  Sleep(2000)
   WEnd

   ;ToolTip('Waiting for the game to start', 0, 0)
   ;Sleep(12000);wait 9 sec to start
   While isColor(894, 904, 0xFFDF72) Or isColor(899, 942, 0xFDE370)
	  ToolTip('Waiting for the game to start noob', 0, 0)
	  clk(902, 942, "click on the yellow start battle button again just in case it failed")
	  clk(899, 942, "click on the yellow start battle button again just in case it failed")
	  Sleep(2000)
   WEnd

   Sleep (7000)

   ToolTip('Choosing a hero', 0, 0)
   clk(1088, 373, "choose the 1st hero")
   clk(1488, 726, "choose the hero")
   clickOn(1280, 384);click on huangzhong 2
   clk(1156, 393, "choose the 1st hero (noobie)")
   clk(1507, 916, "hit ok (noobie)")
   clk(1507, 916, "hit ok (noobie) again")
   clk(354, 941, "hit fanhui")
   Sleep(7000);wait 8 sec to start the game
   ToolTip('', 0, 0)
   Return True
EndFunc

Func loseBattleNoneNoobie($dontEndEarly=0)
   clk(396, 809, "expand the control menu")
   $surrenderTimeout = 120000;2 min to surrender

   While True
	  If isColor(1375, 900, "0xF3E593") Then;if the game end without regular ending
		 Return
	  EndIf

	  If isColor(651, 804, "0x241414") And Not isColor(316, 186, "0x161412") Then;team mate die before the battle is over and it is over 2 min
		 clk(564, 801, "surrender")
		 clickOn(650, 813)
		 clickOn(906, 682)
		 Sleep(3000)
	  EndIf
	  If isColor(1611, 224, "0x0C0B0A",5) Or isColor(1017, 908, "0xFDE169") Then;regular end battle
		 clickOn(856, 668)
		 Sleep(3000)
		 clk(960, 911, "hit continue after the end battle animation")
		 Sleep(3000)
		 clk(960, 911, "hit continue after the ranking animation")
		 clk(959, 630, "hit the bonus in the middle")
		 clk(737, 595, "hit the bonus on the left")
		 clk(960, 911, "hit ok")
		 Sleep(2000);wait for the newbie bonus popup
		 clk(960, 911, "hit ok again")
		 clk(1405, 426, "newbie bonus popup", 0xD86543)
		 clk(1470, 387, "newbie bonus popup2", 0xAD3635)
		 clk(354, 941, "hit fanhui")
		 ;clickOn(1095, 900);again
		 clickOn(835, 908);over
		 Sleep(3000)
		 ExitLoop
	  EndIf

	  If isColor(1125, 660, "0xFEE47B",4) Then;die before the battle is over
		 If 0 And $dontEndEarly == 0 Then;disable this feature because if teammate left before 2 minute, the UI looks the same
			clickOn(843, 665)
			Sleep(3000)
			ExitLoop
		 EndIf
	  EndIf

	  Sleep(4000)
	  tuoguan()
   WEnd

   clk(1274, 326, "click the close button on zhanchangshengji")

EndFunc

Func loseBattle($dontEndEarly=0)
   clickOn(486, 804);expand the control menu

   While True
	  If isColor(651, 804, "0x241414") And Not isColor(316, 186, "0x161412") Then;team mate die before the battle is over and it is over 2 min
		 clk(653, 806, "surrender")
		 clickOn(650, 813)
		 clickOn(906, 682)
		 Sleep(3000)
	  EndIf
	  If isColor(1611, 224, "0x0C0B0A",5) Or isColor(1017, 908, "0xFDE169") Then;regular end battle
		 clickOn(856, 668)
		 Sleep(3000)
		 clk(960, 911, "hit continue after the end battle animation")
		 Sleep(3000)
		 clk(960, 911, "hit continue after the ranking animation")
		 clk(959, 630, "hit the bonus in the middle")
		 clk(737, 595, "hit the bonus on the left")
		 clk(960, 911, "hit ok")
		 Sleep(2000);wait for the newbie bonus popup
		 clk(960, 911, "hit ok again")
		 Sleep(2000);wait for the newbie bonus popup
		 clk(1405, 426, "newbie bonus popup", 0xD86543)
		 Sleep(2000);wait for the newbie bonus popup
		 clk(1470, 387, "newbie bonus popup2", 0xAD3635)
		 clk(354, 941, "hit fanhui")
		 ;clickOn(1095, 900);again
		 clickOn(835, 908);over
		 Sleep(3000)
		 ExitLoop
	  EndIf

	  If isColor(1125, 660, "0xFEE47B",4) Then;die before the battle is over
		 If $dontEndEarly == 0 Then
			clickOn(843, 665)
			Sleep(3000)
			ExitLoop
		 EndIf
	  EndIf

	  Sleep(4000)
	  tuoguan()

	  If isColor(1435, 355, 0xA63637, 10) Then
		 clk(1440, 355, "xinren chaozhi shouyi")
		 ContinueLoop
	  EndIf
   WEnd

   clk(1274, 326, "click the close button on zhanchangshengji")
   Sleep(4000)
   clk(1274, 326, "clking somewhere random to remove the newbie levelup pop up msg")

EndFunc

Func tuoguan()
   quickClick(382, 807)
   quickClick(382, 807)
EndFunc



;this function clicks on a pixel and the wait for 1 sec
Func clickOn($x, $y)
   MouseClick("left", $x, $y)
   Sleep ( 1000 );wait 1 sec to load the UI
EndFunc

;this function opens the chrome with the profile that has sgs login page as the default page
Func startChrome($chromePath, $profileName, $windowTitle)
   ToolTip('Starting Chrome', 0, 0)
   Run('"' & $chromePath & '" --profile-directory="' & $profileName & '"');start the chrome profile for sgs
   $sgs = WinWait($windowTitle, "", 3);wait up to 3 sec until the program to start
   Sleep(3000)

   If NOT WinExists ($windowTitle, "") Then
	  $windowTitle = $chromeTitle2
	  $sgs = WinWait($windowTitle, "", 100)
   EndIf

   WinActivate($sgs)
   WinSetState($sgs, "", @SW_MAXIMIZE);max out the window so that the button are at a fixed location
   ToolTip('', 0, 0)
   Sleep(1500)
   clk(1851, 160, "cancel restore in case abnormal crash")
   Sleep(1500)
EndFunc

Func changeToEnglish($windowTitle)
   $hWnd = WinGetHandle($windowTitle)
   _SetKeyboardLayout("00000409", $hWnd)
EndFunc

;this function logs into the sgs game with the credential info in the provided file path
Func login($path, $credential, $nthAccount = 1, $baipiao= 1)
   ToolTip("Logging in",0,0)
   changeToEnglish($windowTitle)
   $credentialparse = StringSplit($credential[$nthAccount], " ")
   $username = $credentialparse[1]
   $password = $credentialparse[2]
   clickOn(1004, 199);click a blank space
   clickOn(897, 448);click $username
   Send($username,1)
   clickOn(919, 512);click $password
   clickOn(1048, 496);click $password offset
   Send($password,1)

   clickOn(821, 655);agree
   clickOn(953, 601);enter the game
   clickOn(821, 683);agree again
   clickOn(957, 613);enter the game
   ToolTip("waiting for the server choosing page to load",0,0)
   waitTil(1218, 370, 0x321F11)
   ToolTip("",0,0)
   clickOn(1089, 534);choose new version
   clickOn(1121, 669);enter game
   ToolTip("waiting for the game to load",0,0)

   $loadingResult = waitingForGameLoad()
   If Not $loadingResult Then
	  ToolTip("Login timed out, retrying "&$username,0,0)
	  clickOn(87, 55);refresh the page
	  Sleep(5000)
	  login($path, $credential, $nthAccount)
	  return
   EndIf

   Sleep(5000)
   randomNotificationsCheck()
   ;autoPopUpqiandao($baipiao)
   ;closeNotification()
   goToHomePage()
   randomNotificationsCheck()
   ;autoPopUpqiandao($baipiao)
EndFunc

func waitingForGameLoad()
   $Timeout = 20;up to 20 seconds to load
   While True
	  Sleep(1000)
	  clk(1402, 227, "click somewhere to pass the video")
	  speeduppopup()
	  If isColor(901, 804, 0xA57241) and Not isColor(1414, 368, 0xCF3D23) Then
		 clk(901, 804, "ok on the zuixin gonggao")
	  EndIf
	  If isColor(787, 688, 0x6A8550) Then
		 clk(787, 688, "confirm on duplicated login")
	  EndIf

	  randomNotificationsCheck()

	  If isColor(547, 137, 0x29190C) Or isColor(1414, 365, 0xAA2C15) Or isColor(908, 801, 0xB87F45) Or isColor(1732, 137, 0xB49778) Then
		 return True
	  EndIf

	  $Timeout = $Timeout - 1
	  If $Timeout <= 0 Then
		 return False
	  EndIf
   WEnd
EndFunc

;this function logs into the sgs game with the credential info in the provided file path
Func loginWithoutPassword($baipiao=0)
   ToolTip("logging in", 0, 0)
   clk(1023, 446, "clk account");click on where account name is
   clk(942, 505, "save acc");click on where saved account name is
   ;clickOn(912, 553);click on where auto sign in is
   clk(864, 601, "click on start game")
   clk(864, 601, "click on start game2")
   ToolTip("wait til the server choosing page",0,0)
   waitTil(1123, 654, 0xD2B99D);wait til the server choosing page
   clk(994, 589, "choose the new server")
   clk(1121, 669, "enter game")
   $loadingResult = waitingForGameLoad()
   If Not $loadingResult Then
	  ToolTip("Login timed out, retrying",0,0)
	  clk(87, 55);refresh the page
	  Sleep(5000)
	  loginWithoutPassword()
	  return
   EndIf
   ToolTip("login process is finished",0,0)
   Sleep(5000)
   randomNotificationsCheck()
   ;autoPopUpqiandao($baipiao)
   ;closeNotification()
   leaveFenghuo()
   goToHomePage()
   randomNotificationsCheck()
   ;autoPopUpqiandao($baipiao)
   ToolTip('', 0, 0)
EndFunc

Func leaveFenghuo()
   If isColor(1613, 178, 0x9B4A2E) Then
	  clk(1738, 136, "leave fenghuo")
	  waitTil(235, 859, 0xA03B3F, 3000)
   EndIf
EndFunc

Func autoPopUpqiandao($console=False)
   Sleep(3000)
   randomNotificationsCheck()
   ;ToolTip("wait for 2 sec before the gaojizhanchangpopup",0,0)
   ;Sleep(2000)
   ;gaojizhanchangPopUp()

   ;ToolTip("wait for up to 2 sec for the huodongnotification to load",0,0)
   ;$timeToLoadTheAutoPopUp = 2000
   ;Sleep(2000)
   If $console Then
	  waitTil(895, 754, 0x976940, $timeToLoadTheAutoPopUp, 3)
	  If isColor(895, 754, 0x976940, 5) Or isColor(1600, 253, 0xA72E13, 5) Then
		 If isColor(895, 754, 0x976940, 5) Then
			clk(1181, 782, "no more display today")
			clk(1411, 293, "close the huodong notification window")
		 EndIf
		 If isColor(1600, 253, 0xA72E13, 5) Then
			clk(1597, 221, "close the huodong window")
		 EndIf
	  EndIf
   Else
	  waitTil(895, 798, 0x9A6D41, $timeToLoadTheAutoPopUp, 3)
	  Sleep(2000)
	  If isColor(895, 796, 0x986B3F, 5) Then
		 If isColor(895, 754, 0x976940, 5) and isColor(1416, 367, 0x976940, 5) Then
			clk(1180, 822, "no more display today")
			clk(1409, 335, "close the huodong notification window")
			$noMorePopupToday = True
		 EndIf
		 If isColor(1601, 296, 0xD44325, 5) Then
			clk(1594, 261, "close the huodong window")
		 EndIf
	  EndIf
   EndIf
   ToolTip("",0,0)

   If isColor(1594, 260, 0xC98A3D) Then
	  clk(1594, 260, "closing the qiandao popup window")
   EndIf

   Sleep(2000)
   If isColor(1117, 657, 0x9F4226, 5) Then
	  clk(1558, 295, "close qunzhaoyun popup")
   EndIf

EndFunc

Func closeNotification()
   Sleep(4000)
   randomNotificationsCheck()
   clk(1065, 664, "quxiapipei");quxiaopipei(before 9 am)

   ;disable this because this may click on maoxianmoshi accidentally
   ;$cords = PixelSearch(890, 782, 1029, 813, 0xFFD98F);find the ok button
   ;If Not @error Then
	;  clickOn($cords[0], $cords[1]);click on the ok button
   ;EndIf

   If isColor(403, 891, 0xFDE375) and isColor(1554, 259, 0xC2863A) Then
	  clk(1554, 259, "close xinrenfuli")
   EndIf

   If isColor(1031, 685, 0xAD8C67) Then;detect the tanhe button
	  clickOn(1031, 685);click on the cancel button
   EndIf

   clk(884, 928, "close kaiqi xinsaiji pop up")
   clk(1273, 347, "close zhanchang dengji tisheng window");zhanchang dengji tisheng yao ni mai gaoji zhanchang
EndFunc



Func randomNotificationsCheck()
   $noMorePopup = False
   While Not $noMorePopup
	  ToolTip("looking for random popup to close",1,1)
	  Sleep(3000)

	  If isColor(1440, 334, 0xD56446) Then
		 clk(1562, 294, "2023 qingrenjie")
		 ContinueLoop
	  EndIf

	  If isColor(1562, 294, 0xD24024) Then
		 clk(1562, 294, "haoyou")
		 ContinueLoop
	  EndIf

	  If isColor(1627, 250, 0xC83A37) Then
		 clk(1627, 250, "xinchunhuodong")
		 ContinueLoop
	  EndIf

	  If isColor(1096, 374, 0xFFF762) Then
		 clk(1096, 374, "gongxishengji")
		 ContinueLoop
	  EndIf

	  If isColor(899, 804, 0xA37243) and isColor(1013, 302, 0x683212) Then
		 clk(899, 804, "zuixingonggao")
		 ContinueLoop
	  EndIf

	  If isColor(855, 632, 0xFFDD99) and isColor(1034, 623, 0xAE8D68) Then
		 clk(1019, 618, "close casual time arena notification (weiduan)")
		 ContinueLoop
	  EndIf

	  If isColor(1023, 662, 0x9D7E5D) and isColor(1017, 413, 0x713610) Then
		 clk(1023, 662, "close casual time arena notification (chrome)")
		 ContinueLoop
	  EndIf

	  If isColor(1181, 783, 0x4F4434) and isColor(1410, 291, 0xC4953C) Then
		 clk(1181, 783, "choose to no longer display the daily ads notification (weiduan)")
		 clk(1408, 289, "close daily ads notification (weiduan)")
		 clk(1593, 221, "close daily huodong pop notification (weiduan)")
		 ContinueLoop
	  EndIf

	  If isColor(1023, 642, 0x9B7B5D) and isColor(1010, 420, 0xCEB392) Then
		 clk(1026, 638, "close dianfengjingji notification (weiduan)")
		 ContinueLoop
	  EndIf

	  If isColor(896, 758, 0x9C6D3F) and isColor(1415, 326, 0xC43419) Then
		 clk(1180, 779, "choose to no longer display the daily ads notification (console)")
		 clk(1413, 290, "close daily ads notification (console)")
		 clk(1600, 224, "close daily huodong pop notification (console)")
		 ContinueLoop
	  EndIf

	  If isColor(895, 754, 0x976940, 5) and isColor(1416, 367, 0x976940, 5) Then
		 clk(1179, 821, "choose to no longer display the daily ads notification (chrome)")
		 clk(1408, 334, "close daily ads notification (chrome)")
		 clk(1600, 251, "close daily huodong pop notification (chrome)")
		 $noMorePopupToday = True
		 ContinueLoop
	  EndIf

	  If isColor(899, 867, 0xFCE16E) and isColor(1360, 323, 0xC55942) Then
		 clk(1357, 321, "close new zhangchang dengji shengji notification (chrome)")
		 ContinueLoop
	  EndIf

	  If isColor(405, 381, 0x54388F) and isColor(1513, 356, 0x85131E) Then
		 clk(1562, 294, "close qunzhaoyun chunge notification")
		 ContinueLoop
	  EndIf

	  If isColor(807, 292, 0x0E2350) and isColor(1134, 344, 0xCD2E32) Then
		 clk(1456, 277, "close zhangbao xiahouba")
		 ContinueLoop
	  EndIf

	  If isColor(898, 802, 0xA27341) And isColor(1415, 369, 0xDB5130) Then
		 clk(1181, 821, "no more meiri news for today chrome")
		 clk(1416, 331, "closing the meiri news chrome")
		 ContinueLoop
	  EndIf

	  If isColor(893, 234, 0x633D1C) and isColor(1602, 295, 0xD84225) Then
		 clk(1595, 259, "close meiri huodong qiandao")
		 ContinueLoop
	  EndIf

	  If isColor(1360, 280, 0xC05641) Then
		 clk(1360, 280, "closing the gaojizhanchangPopUp for console")
		 ContinueLoop
	  EndIf
	  If isColor(1359, 320, 0xC05641) Then
		 clk(1359, 320, "closing the gaojizhanchangPopUp for chrome")
		 ContinueLoop
	  EndIf

	  If (isColor(469, 467, 0xBE2A28) and isColor(1495, 339, 0xC43B20)) Or (isColor(1495, 301, 0xC83A1A, 10) and isColor(753, 302, 0xF0E5D6, 10)) Or (isColor(1494, 341, 0xBB3316, 10) and isColor(521, 259, 0x3D2823, 10)) Then
		 clk(1492, 305, "huiguilibao")
		 ContinueLoop
	  EndIf

	  If isColor(570, 258, 0x3D2822) and isColor(1495, 341, 0xCF361A) Then
		 clk(1494, 306, "luohuayaoyue")
		 ContinueLoop
	  EndIf

	  If isColor(628, 808, 0xFEE479) and isColor(1562, 295, 0xD84225) Then
		 clk(1562, 254, "xinrentehui")
		 ContinueLoop
	  EndIf

	  If isColor(1561, 285, 0xB43218, 10) and isColor(283, 347, 0xD19F4B, 10) Then
		 clk(1559, 254, "huodongchang popup")
		 ContinueLoop
	  EndIf

	  If isColor(886, 934, 0xFDE376) Then
		 clk(886, 934, "kaiqixinsaiji")
		 ContinueLoop
	  EndIf

	  $noMorePopup = True
	  ToolTip("",1,1)
   WEnd
EndFunc

;this function collects the mails and delete old mails
Func mailbox()
   ToolTip("Checking the mailbox",0,0)
   Sleep(1000)
   If isColor(1585, 147, 0xCC0100) Then
	  clk(1571, 134)
	  $OpenedMailbox = waitTil(298, 365, 0xC99542, 15000)
	  If $OpenedMailbox Then
		 clk(566, 869, "take all");
		 clk(1061, 684, "ok in case already taken")
		 clk(1061, 684, "click any where")
		 clk(1061, 684, "click any where")
		 clk(1061, 684, "click any where")
		 clk(1572, 271, "close the mail window")
		 Sleep(1000)
	  EndIf
   EndIf
   ToolTip("",0,0)
EndFunc

;this function collects 100 silver
Func silver100()
   ToolTip("Collecting the 100 silver",0,0)
   realsilver100()
EndFunc

Func realsilver100($secondTry=False)
   Sleep(1000)
   $cords = PixelSearch(163, 154, 252, 665, 0x7ADB88, 11);find the fuli icon
   If Not @error Then
	  clickOn($cords[0], $cords[1]);click on the fuli icon
	  waitTil(1562, 296, 0xD84929);wait for the page to load
	  $cords = PixelSearch(275, 316, 368, 458, 0xD40101, 10);find the meiritehui icon
	  If Not @error Then
		 clickOn($cords[0], $cords[1]);click on the meiritehui icon
		 clickOn(1411, 424);100 silver
	  EndIf
	  clk(1553, 264, "close silver 100 window");close window
	  ToolTip("",0,0)
   Else
	  If Not $secondTry Then
		 clk(213, 737, "in case the silver100 has too many icons above")
		 realsilver100(True)
	  EndIf
   EndIf
EndFunc

;this function collects 100 silver
Func qiandao($baipiao=0, $forceqiandao=False, $maizhouka=False)
   ToolTip("trying to click on the qiandao button", 0, 0)
   $NeedToQianDao = 0

   while isColor(1556, 946, 0xCC0103,5)
	  clickOn(1556, 946);click on huodong
	  Sleep(2000)
	  $NeedToQianDao = 1
   WEnd

   If Not $NeedToQianDao And Not $forceqiandao Then
	  Return
   EndIf


   ;this one stopped working after the update on Nov 1, 2021
   If $noMorePopupToday == False Then
	  ToolTip("waiting for the pop up window", 0, 0)
	  Sleep(2000)
	  $showedUP = waitTil(1416, 367, 0xDB4023, 40000);wait for the huodong notification (timeout 40 sec)
	  If $showedUp Then
		 clickOn(1180, 828);choose to not display the notification
		 $noMorePopupToday = True
		 clickOn(1414, 338);close the notification
	  EndIf
	  ToolTip("", 0, 0)
   EndIf

   ToolTip("collecting yueka zhouka", 0, 0)
   Sleep(1000)

   If $baipiao <> 1 And Not isColor(1356, 582, 0x935911) And Not isColor(1502, 600, 0xFFE428) Then
	  clickOn(1424, 680);yueka
	  clickOn(1376, 343);close yueka window
	  clickOn(1422, 853);zhouka
	  clickOn(1376, 343);close zhouka window
   EndIf

   If $baipiao <> 1 And isColor(1385, 581, 0xE0AA14, 11) And isColor(1474, 584, 0xDCD723, 11) Then
	  clickOn(1402, 681);yueka
	  clickOn(916, 771);ok
	  If isColor(1031, 688, 0xB5946F, 11) Then
		 clickOn(1031, 688);
		 clickOn(1375, 346);
	  Else
		 clickOn(1402, 681);yueka
		 clickOn(1376, 343);close yueka window
	  EndIf
   EndIf

   If $baipiao <> 1 And $maizhouka And isColor(1382, 755, 0xD7C91C, 11) And isColor(1476, 754, 0xF0E31F, 11) Then
	  clickOn(1399, 847);maizhouka
	  clickOn(916, 771);ok
	  If isColor(1031, 688, 0xB5946F, 11) Then
		 clickOn(1031, 688);
		 clickOn(1375, 346);
	  Else
		 clickOn(1399, 847);zhouka
		 clickOn(1376, 343);close zhouka window
	  EndIf
   EndIf

   ToolTip("collecting meiriqiandao", 0, 0)
   Sleep(1000)

   $timesout = 28
   $prex = 0
   $prey = 0

   While True
	  $timesout -= 1
	  $position = findColor(511, 508, 1152, 913, 0x95632B, 2)
	  If Not IsArray($position) Or $timesout <= 0 Or ($prex == $position[0] And $prey == $position[1]) Then
		 ExitLoop
	  EndIf
	  $prex = $position[0]
	  $prey = $position[1]
	  clk($position[0],$position[1],"collecting qiandao bonus")
	  clk(1019, 680, "cancel in case buqian")
   WEnd

   If $baipiao <> 1 And $maizhouka Then
	  debugScreenshot()
   EndIf

   ToolTip("qifuxiaoka",0,0)
   Sleep(2000)
   ;specialQiandao(); only need it when applicable

   lingQiFuXiaoKa()

   If isColor(1535, 254, 0x2B1715, 5) Or isColor(1097, 248, 0x572B15, 5) Or isColor(396, 247, 0x281411, 5) Then ; checking multiple points with less color restriction in case the qifu animation screw up the color
	  MouseClick("left", 1601, 263);click on the button to leave UI to collect sign bonus
   EndIf
   Sleep(1000)
   ToolTip("", 0, 0)
EndFunc

Func lingQiFuXiaoKa()
   If isColor(391, 472, 0xCA0203) Then
	  clk(391, 472, "qifuxiaoka")
   EndIf
   If isColor(519, 614, 0xC60202) Then
	  clk(519, 614, "qifuxiaoka2")
   EndIf
   If isColor(1152, 829, 0xFCE26B) Then
	  clk(1152, 829, "5th qifuxiaoka")
   EndIf
   If isColor(1267, 827, 0xFDE272) Then
	  clk(1267, 827, "6th qifuxiaoka")
   EndIf
   If isColor(1388, 828, 0xFDE272) Then
	  clk(1388, 828, "7th qifuxiaoka")
   EndIf
   If isColor(1497, 829, 0xFCE26B) Then
	  clk(1497, 829, "8th qifuxiaoka")
   EndIf
   If isColor(843, 557, 0xF4DF79) Then
	  clk(843, 557, "qifudeng")
	  clk(918, 709, "ok")
	  clk(839, 661, "remove pop up")
   EndIf
EndFunc

Func specialQiandao()
   tryToClick(389, 545, 0xCA0203)
   tryToClick(518, 528, 0xDA0202)
   tryToClick(1493, 333, 0xFDE36E)
EndFunc
Func quickClick($x, $y)
   MouseClick("left", $x, $y);click on the task menu
   Sleep ( 500 );wait 0.5 sec
   MouseMove($x+3, $y+3)
   MouseClick("left", $x, $y);click on the task menu
   Sleep(500)
EndFunc

Func jiarujiaohui()
   ;If isColor(1469, 360, 0xFFE77D) Or isColor(1411, 363, 0xFEE373) Then
   If isColor(1411, 363, 0xFEE373) Then
	  clickOn(1418, 307)
	  clickOn(1408, 304)
	  clickOn(1408, 304)
	  Send("天翔龙闪")
	  clickOn(1511, 303)
	  clickOn(1428, 359)
	  clickOn(1560, 256)
   EndIf
EndFunc

Func guild($lingHongBao=1)
   ToolTip("Doing the guild work.", 0, 0)
   Sleep(2000)

   $doingGuildWork = clkGuildIcon()

   Sleep(2000)
   clk(1568, 552, "skip tutorial")
   clk(1657, 177, "skip tutorial2")

   If $doingGuildWork == 0 Then
	  ToolTip("Not doing the guild work.", 0, 0)
	  debugScreenshot()
	  Sleep(2000)
	  ToolTip("", 0, 0)
	  leaveguild()
	  Return
   EndIf

   ToolTip("waiting for 1.5 sec for the UI to get ready.", 0, 0)
   waitTil(1561, 294, 0x621E10, 20, 1500)
   ToolTip("", 0, 0)

   If Not isColor(687, 838, 0xFEE479) And isColor(789, 306, 0x64431F,25) Or isColor(1078, 342, 0xFFF3D3,25) Or isColor(703, 303, 0x63461E,25) Then
	  ToolTip("jiarujiaohui..")
	  jiarujiaohui()
	  ToolTip("")
	  Return
   EndIf

   If isColor(1646, 802, "0xD00100",5) Then;if we can hit the drum
	  For $i = 3 To 1 Step -1
		 clk(1598, 682+50, "hitting the drum"&(3-$i))
		 Sleep ( 2000 );wait 2 sec to load the drum animation
	  Next
	  MouseClick("left", 1063, 631+50);click on the cancel button just in case we have run out of free drum times today
   EndIf

   ;click on the 1st bonus
   If isColor(1680, 250, "0xFDE46F",5) Then
	  clickOn(1680, 250)
   EndIf

   ;click on the 2nd bonus
   If isColor(1680, 372, "0xFEE67B", 5) Then
	  clickOn(1680, 372)
   EndIf

   ;click on the 3rd bonus
   If isColor(1681, 498, "0xFEE67B", 5) Then
	  clickOn(1681, 498)
   EndIf

   ;huizhanbaoxiang
   If isColor(371, 761, 0xD30200, 5) Then
	  clickOn(371, 761)
   EndIf

   ;linghongbao
   If $lingHongBao == 1 Then
	  clickOn(371, 761);click anywhere to remove the notification
	  ToolTip("wait for 2 seconds or the hongbao UI will bug out", 0, 0)
	  Sleep(2000)
	  ToolTip("", 0, 0)
	  If Not isColor(1126, 302, 0x6FB430, 10) Then
		clk(1121, 304, "only show hongbao")
	  EndIf
	  $hongbaoNum = 0
	  While True
		 $cords = PixelSearch(832, 323, 1400, 819, "0x6A1A1A");if found clickable hongbao
		 If Not @error Then
			clk(1122, 367, "first hongBao")
			clk(1122, 367, "click anywhere")
			$hongbaoNum = $hongbaoNum + 1
			Sleep(2000)
			clk(1129, 525, "second hongBao")
			clk(1129, 525, "click anywhere")
			$hongbaoNum = $hongbaoNum + 1
			Sleep(2000)
			clk(1130, 659, "third hongBao")
			clk(1130, 659, "click anywhere")
			$hongbaoNum = $hongbaoNum + 1
			Sleep(2000)
			clk(1146, 799, "forth hongBao")
			clk(1146, 799, "click anywhere")
			$hongbaoNum = $hongbaoNum + 1
			clk(1397, 836, "refresh")
			Sleep(1000)
			If $hongbaoNum >= 30 Then
			   ExitLoop
			EndIf
		 Else
			ExitLoop
		 EndIf
	  WEnd
   EndIf

   leaveguild()
EndFunc

Func leaveguild()
   ToolTip("leaving the guild UI");

   ;if not joined any guild yet
   If isColor(1552, 261, 0x63421F) Then
	  clickOn(1552, 261)
   EndIf

   ;if not joined any guild yet
   If isColor(1552, 261, 0x63421F) Then
	  clickOn(1552, 261)
	  Sleep(1000)
	  clickOn(1552, 261);lose guild page in the case of not having one
   EndIf

   clickOn(223, 797+50);close the guild page
   Sleep(2000)
   ToolTip("");
EndFunc

Func collectSunLuBan()
   If (isColor(244, 165, "0xDC0102") And isColor(202, 204, "0xCBCA27")) Or (isColor(226, 192, "0x9B5E77") And isColor(244, 181, "0xDC0100")) Or (isColor(246, 184, "0xCA0201") And isColor(227, 189, "0xC891A1")) Then
	  ToolTip("trying to collect sunluban",0,0)
	  clickOn(210, 183);click on sunluban
	  Sleep(2000);wait for the page to load
	  clickOn(900, 884);click on diaochanpifu
	  clickOn(1362, 888);click on sunluban jiangling
	  Sleep(2000)
	  clickOn(871, 845);click on ok to confirm
	  clickOn(1560, 263);close xianshihaoli window
	  ToolTip("",0,0)
   EndIf
   clk(213, 737, "in case the silver100 has too many icons above")
   Sleep(1000)
   If (isColor(244, 165, "0xDC0102") And isColor(202, 204, "0xCBCA27")) Or (isColor(226, 192, "0x9B5E77") And isColor(244, 181, "0xDC0100")) Or (isColor(246, 184, "0xCA0201") And isColor(227, 189, "0xC891A1")) Then
	  ToolTip("trying to collect sunluban",0,0)
	  clickOn(210, 183);click on sunluban
	  Sleep(2000);wait for the page to load
	  clickOn(900, 884);click on diaochanpifu
	  clickOn(1362, 888);click on sunluban jiangling
	  Sleep(2000)
	  clickOn(871, 845);click on ok to confirm
	  clickOn(1560, 263);close xianshihaoli window
	  ToolTip("",0,0)
   EndIf
EndFunc

Func logout()
   ToolTip("Logging out",0,0)
   clickOn(87, 55);refresh the page
   waitTil(897, 666, 0x120D03)
   clickOn(953, 670);log out
   waitTil(1064, 451, 0x30200C)
   ToolTip("",0,0)
EndFunc

Func levelx($style)
   If $style == "tiaoZhan" Then
	  Sleep ( 1000 );wait 1 sec to load zhulu mode main page
	  MouseClick("left", 1625, 655);click on the button to challenge level x
	  waitTil(1368, 867, 0xFEE16D, 15000, 5);wait for up to 15 sec until the start button shows up
	  Sleep(1500); wait for antoher 1.5 sec just in case
	  MouseClick("left", 1411, 865);click on the button to start level
	  Sleep(2000)

	  If isColor(941, 492, 0xAB947B) Then ;if we run out of energy
		 clickOn(1371, 345);try to close energy buying window just in case we run out of energy
		 clickOn(1555, 258);try to close the challenge window just in case we run out of energy
		 Sleep(2000)
		 return False
	  EndIf

	  $timeInit = TimerInit()
	  $timeOut = 40000

	  While (True And TimerDiff($timeInit) < $timeout)
		 If isColor(948, 899, 0xFFF6E9) Or isColor(907, 902, 0xFDE36C) Or isColor(944, 561, 0xFFF990) Then
			ExitLoop
		 EndIf
	  WEnd
	  MouseClick("left", 1370, 864);click on a blank spot to proceed
	  Sleep(2000)
	  clickOn(959, 920);click on the button to continue (this is a sweet point that won't hit jiangling even if we are running out of energy)
   ElseIf $style == "saoDang" Then
	  Sleep ( 1000 );wait 1 sec to load zhulu mode main page
	  MouseClick("left", 1676, 612+50);click on the button to saodang level x
	  waitTil(1186, 817, 0xFCE579);wait til the saodong button shows up
	  clk(1199, 819, "click on the saodang button")
	  ;clk(638, 819, "click on the saodang button")
	  ;ToolTip("wait til the jiangling window shows up")
	  ;waitTil(803, 319, 0x4A3E30, 10000)
	  ;clk(788, 484, "click on the 2nd jiangling")
	  clk(923, 829, "click on the ok button")
	  clk(1556, 259, "click on the quit button")
   EndIf

   return True
EndFunc

Func ProgressLevel()
   Sleep ( 1000 );wait 1 sec to load zhulu mode main page
   MouseClick("left", 1560, 836);click on the button to challenge the next level
   Sleep ( 1000 );wait 1 sec to load level
   MouseClick("left", 1427, 813);click on the button to start level
   Sleep ( 30000 );wait 0.5 min to finish the game
   MouseClick("left", 919, 855);click on a blank spot to proceed
   MouseClick("left", 956, 850);click on the button to continue
   Sleep ( 1000 );wait 1 sec to load level 100
EndFunc

Func clkGuildIcon()
   $cords = PixelSearch(1124, 947, 1311, 980, "0xDCC279", 5);regular mode
   $doingGuildWork = 0
   If Not @error Then
	  ToolTip("regular mode to click on guild")
	  Sleep(2000)
	  ToolTip("")
	  clickOn($cords[0],$cords[1]);click on the guild button
	  clickOn($cords[0]-25,$cords[1]+25);click on the guild button again in case the hover bug happens again
	  Sleep ( 2000 );wait 1 sec to load guild UI
	  $doingGuildWork = 1
	  waitTil(229, 872, 0xFAF7E1, 40*1000);wait for up to 40 sec, i have seen it took 30 sec to load the guild page
	  If isColor(1560, 294, 0xB73319) And isColor(1551, 264, 0xD5974A) Then
		 clk(1551, 264, "close shitu")
	  EndIf
	  If isColor(1561, 268, 0x9B642E) And isColor(1562, 294, 0xD93922) Then
		 clk(1562, 294, "close haoyou")
	  EndIf
	  return $doingGuildWork
   EndIf

   $cords = PixelSearch(1124, 947, 1253, 1011, "0xD54234", 25);hongbao mode
   If Not @error Then
	  ToolTip("hongbao mode to click on guild")
	  Sleep(2000)
	  ToolTip("")
	  clickOn($cords[0],$cords[1]+20);click on the guild button when there is a red pocket icon 2
	  clickOn($cords[0]-25,$cords[1]+25);click on the guild button again in case the hover bug happens again
	  Sleep ( 2000 );wait 1 sec to load guild UI
	  $doingGuildWork = 1
	  waitTil(229, 872, 0xFAF7E1, 40*1000);wait for up to 40 sec, i have seen it took 30 sec to load the guild page
	  If isColor(1560, 294, 0xB73319) And isColor(1551, 264, 0xD5974A) Then
		 clk(1551, 264, "close shitu")
	  EndIf
	  If isColor(1561, 268, 0x9B642E) And isColor(1562, 294, 0xD93922) Then
		 clk(1562, 294, "close haoyou")
	  EndIf
	  return $doingGuildWork
   EndIf
EndFunc

Func guildCheck()
   ToolTip("Doing the guild check work.", 0, 0)
   Sleep(2000)
   $doingGuildWork = clkGuildIcon()
   If $doingGuildWork == 0 Then
	  ToolTip("Not doing the guild work.", 0, 0)
	  Sleep(2000)
	  ToolTip("", 0, 0)
	  Return
   EndIf
   Sleep(1000)
   clk(1657, 177, "skip tutorial")
   clk(1657, 177, "skip tutorial")
   clk(247, 829, "leave guild")
   Sleep(2000)
EndFunc

Func zhulu($yanglao=0)
   guildCheck()
   ;do nothing if zhulu mode is not available
   If isColor(1210, 709, 0xFADA66) Then
	  return
   EndIf

   If isColor(1175, 710, 0x281C10, 5) Then
	  MouseClick("left", 1175, 710);click on the zhulu mode
	  clk(1175, 710, "click on the zhulu mode")
	  Sleep ( 1000 );wait 1 sec and click again just in case (it sometimes bugs out and clicking won't work)
	  clk(1175+20, 710, "click on the zhulu mode again")
	  Sleep ( 4000 );wait 4 sec to load the zhulu mode
	  MouseClick("left", 1295, 696);click on a blank spot to by pass the video
   EndIf

   Sleep(4000); wait for 4 sec because sometime the UI takes a while to load
   randomNotificationsCheck()

   If $yanglao Then
	  levelx("saoDang")
   EndIf

   While True
	  If Not levelx("tiaoZhan") Then
		 ExitLoop
	  EndIf
   WEnd

   clickOn(204, 830);leave zhulu
   Sleep(3000);wait for 3 seconds to leave zhulu
EndFunc

Func speeduppopup()
   if isColor(885, 640, 0xC58A43) Then
	  clk(885, 640, "yes to speed up (new)")
   EndIf

   if isColor(817, 684, 0xC78B48) Then
	  clk(817, 684, "yes to speed up")
   EndIf
   If isColor(901, 804, 0xA57241) and Not isColor(1414, 368, 0xCF3D23) Then
	  clk(901, 804, "ok on the zuixin gonggao")
   EndIf
   If isColor(787, 688, 0x6A8550) Then
	  clk(787, 688, "confirm on duplicated login")
   EndIf
   If isColor(818, 681, 0xBF8545) Then
	  clk(818, 681, "confirm on duplicated login")
   EndIf
EndFunc