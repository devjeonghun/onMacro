#NoTrayIcon
#Include Gdip_All.ahk
#Include Gdip_ImageSearch.ahk
#Include Create_bmp.ahk
#Include LineNotify.ahk
#Include Setting.ahk

;------------------------------------------------------------------------------
; 수호승 여부 체크
;------------------------------------------------------------------------------
suhoCheck()
{
global suho, var, title	
if(search_img(830,400,1030,680,var,suho) == 0)
{
debug(123)
}
else
{
	debug(000)
	postmessage,0x100,27,65537,,%title%
	postmessage,0x101,27,65537,,%title%
	sleep,200
	postmessage,0x100,96,5373953,,%title% ;0
	postmessage,0x101,96,5373953,,%title%
	sleep,200
	postmessage,0x100,101,4980737,,%title% ;5
	postmessage,0x101,101,4980737,,%title%
	sleep,200
	postmessage,0x100,105,4784129,,%title% ;9
	postmessage,0x101,105,4784129,,%title%
	sleep,200			
	postmessage,0x100,99,5308417,,%title% ;3
	postmessage,0x101,99,5308417,,%title%
	sleep,200			
	postmessage,0x100,36,21430273,,%title% ;home
	postmessage,0x101,36,21430273,,%title%
	sleep,200			
	postmessage,0x100,13,18612225,,%title% ;enter
	postmessage,0x101,13,18612225,,%title%
	sleep,200
	postmessage,0x100,104,4718593,,%title% ;8
	postmessage,0x101,104,4718593,,%title%
	sleep,200
}
}

;------------------------------------------------------------------------------
; 마우스 클릭
;------------------------------------------------------------------------------
click_mouse(clickX,clickY)
{
	global title

	innerX := clickX
	innerY := clickY
	
	lparam := innerX|innerY<<16
	PostMessage, 0x201, 1, %lparam%, , %title%
	PostMessage, 0x202, 1, %lparam%, , %title%
	
	;PostMessage, 0x201, 1, %lparam%, , %title%
	;PostMessage, 0x202, 1, %lparam%, , %title%
}

;------------------------------------------------------------------------------
; FIGHT 명령
;------------------------------------------------------------------------------
Fight()
{
	global title			
	Loop,20{
		suhoCheck()
		postmessage,0x100,9,983041,,%title%
		postmessage,0x101,9,983041,,%title%
		sleep, 200
		postmessage,0x100,97,5177345,,%title%
		postmessage,0x101,97,5177345,,%title%
		sleep, 200
		postmessage,0x100,99,5308417,,%title%
		postmessage,0x101,99,5308417,,%title%		
	}
	postmessage,0x100,96,5373953,,%title% ;0
	postmessage,0x101,96,5373953,,%title%
	postmessage,0x100,100,4915201,,%title% ;0
	sleep,2000
	postmessage,0x101,100,4915201,,%title%
	sleep,200	
}	
return
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; BUTTON SETTING
;------------------------------------------------------------------------------
Button(2)Setting:
{	
	Gui,Submit,nohide
	macroListText = "::명령리스트::"
	sendmessage,0x184,,,listbox1, % programTitle
	
	If !FileExist(ImgFile) {
      GuiControl, Focus, BtnFile
	  MsgBox, Not Exisg File
      Return
   }

	Loop,Read,%ImgFile%
	{	   
		ArrayMoveList.Insert(A_LoopReadLine)		
	}	
	
	macroListText := showMakerList()		
	guicontrol,,MacroList,%macroListText% 
	guicontrol,Disable,Setting,
}
return

Button(3)Start:
{	
gosub,start
}
return

Button(4)Stop:
{	
	global check
	check := 
	Pause
}
return

Button(5)RELOAD:
{
	Reload
}
return

Button(1)loadFile:
{
	Gui, +OwnDialogs
   FileSelectFile, ImgFile, 1, %ImgDir%, Select a MacroSettingFile, ini (*.ini)
   If (ErrorLevel)
      Return
   GuiControl, , ImgFile, %ImgFile%
   SplitPath, ImgFile, , ImgDir, ImgExt, ImgName
   ImgName := RegExReplace(ImgName, "[\W]")
   ImgName .= "_" . ImgExt
   GuiControl, , OutFile, %OutDir%\Create_%ImgName%.ahk
   IniWrite, %ImgDir%, %IniFile%, Image2Include, ImgDir
}
return

;------------------------------------------------------------------------------
; 시작버튼 명령
;------------------------------------------------------------------------------
start:
global check	
check := true
setTimer,statusCheck,600000

Loop
{
	global ArrayMoveList,DES_X,DES_Y,title	
	Loop,% ArrayMoveList.MaxIndex()	
	{			
		thismove := ArrayMoveList[A_Index]
		sendmessage,0x186,A_Index-1,,listbox1, % programTitle
		StringSplit, xyArray, thismove, `,
		GuiControl,,Xinput, %xyArray1%		
		GuiControl,,Yinput, %xyArray2%
			
		Loop
		{	
			text1 := searchX()
			text2 := searchY()
			msg := text1[1] text1[2] text1[3] "," text2[1] text2[2] text2[3]				
			GuiControl,,Edit2, %msg%
			gosub, diecheck
			if(xyArray1 = "ACTION")
			{					
				Loop,%xyArray0%
				{
					debug(xyArray%a_index%)
					if(xyArray%a_index% = "Tab"){
						postmessage,0x100,9,983041,,%title%
						sleep,500
						postmessage,0x101,9,983041,,%title%
						sleep,500
					}
					else if(xyArray%a_index% = "Enter")
					{
						postmessage,0x100,13,1835009,,%title%
						sleep,500
						postmessage,0x101,13,1835009,,%title%
						sleep,500
					}
					else if(xyArray%a_index% = "Left")
					{
						postmessage,0x100,37,21692417,,%title%
						sleep,500
						postmessage,0x101,37,21692417,,%title%
						sleep,500
					}
					else if(xyArray%a_index% = "Right")
					{
						postmessage,0x100,39,21823489,,%title%
						sleep,500
						postmessage,0x101,39,21823489,,%title%
						sleep,500							
					}
					else if(xyArray%a_index% = "Up")
					{
						postmessage,0x100,38,21495809,,%title%
						sleep,500
						postmessage,0x101,38,21495809,,%title%
						sleep,500
									
					}
					else if(xyArray%a_index% = "Down")
					{
						postmessage,0x100,40,22020097,,%title%
						sleep,500
						postmessage,0x101,40,22020097,,%title%
						sleep,500
					}
					else if(xyArray%a_index% = "WEST")
					{
						controlsend,,6,%title%							
						sleep,200
						controlsend,,2,%title%							
						sleep,200
						controlsend,,{enter},%title%							
						sleep,500
					}
					else if(xyArray%a_index% = "EAST")
					{
						controlsend,,6,%title%							
						sleep,200
						controlsend,,1,%title%							
						sleep,200
						controlsend,,{enter},%title%							
						sleep,500
					}
					else if(xyArray%a_index% = "NORTH")
					{
						controlsend,,6,%title%							
						sleep,200
						controlsend,,4,%title%							
						sleep,200
						controlsend,,{enter},%title%							
						sleep,1000
					}
					else if(xyArray%a_index% = "SOUTH")
					{
						controlsend,,3,%title%							
						sleep,200
						controlsend,,2,%title%							
						sleep,200
						controlsend,,{enter},%title%							
						sleep,1000
					}
					else if(xyArray%a_index% = "FIGHT")
					{
						Fight()
						sleep,1000
					}
					else if(xyArray%a_index% = "CHOSANG")
					{
						;controlsend,,7,%title%
						;sleep, 500
						;postmessage,0x100,49,131073,,%title%
						;postmessage,0x101,49,131073,,%title%
						;sleep, 500
						postmessage,0x100,17,1900545,,%title%
						postmessage,0x100,90,2883585,,%title%
						sleep,200							
						postmessage,0x101,17,1900545,,%title%
						postmessage,0x101,90,2883585,,%title%
						;sleep, 500
						;controlsend,,0,%title%							
					}
					else if(xyArray%a_index% = "T")
					{
						controlsend,,7,%title%
						sleep, 500							
					}
					else if(xyArray%a_index% = "F")
					{
						controlsend,,0,%title%		
						sleep, 500
					}else if(xyArray%a_index% = "CLICK")
					{
						click_mouse(386,61)
						sleep,1000
						click_mouse(363,261)
						sleep,500
						click_mouse(317,403)
						sleep,500
						click_mouse(363,261)
						sleep,500
						click_mouse(317,403)
						sleep,500
						click_mouse(386,295)
						sleep,500
						click_mouse(317,403)
						sleep,500
					}
				}
				break
			}
			else if(gotoMove(text1,text2,xyArray1,xyArray2,xyArray3))
			{	
				break
			}
		}
	}
}
return

;------------------------------------------------------------------------------
; 죽었는지 체크
;------------------------------------------------------------------------------
diecheck:	
global die, live, full, var, title	
if(search_img(0,0,1200,900,var,die) = 0)
{
	LinePush("POST", url, "캐릭터 사망", headers)
	sleep, 1000
	controlsend,,7,%title%
	sleep, 500
	controlsend,,우,%title%
	sleep, 500
	controlsend,,{Enter},%title%
	sleep, 500
	Loop
	{	
		controlsend,,{Enter},%title%
		sleep, 200
		controlsend,,살려주세요,%title%					
		sleep, 200
		controlsend,,{Enter},%title%
		
		if(search_img(0,0,1000,1000,var,full) = 0)
		{
			LinePush("POST", url, "캐릭터 부활 완료", headers)
			break
		}
		else
		{
			controlsend,,0,%title%
			sleep, 200
			postmessage,0x100,100,4915201,,%title%
			sleep, 4000
			postmessage,0x101,100,4915201,,%title%
			sleep, 200	
		}
	}	
	goto, Button(3)Start
}
return
statusCheck:
;statusImg := ImageUpload("POST",imgurUrl,imgurHeaders)
msss := LinePushImg("POST", url, "상태체크", headers)
return

GuiClose:
LinePush("POST", url, "사용자 프로그램 종료", headers)
ExitApp
