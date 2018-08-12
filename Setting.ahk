;------------------------------------------------------------------------------
; GET ADMIN AUTH
;------------------------------------------------------------------------------
if not A_IsAdmin 
{
  Run *RunAs "%A_ScriptFullPath%"
  ExitApp 
} 
winsettitle,바람의나라,,[ON]바람의나라
;------------------------------------------------------------------------------

; App 기동 메시지
LinePush("POST", url, "사용자 프로그램 시작 완료", headers)
;------------------------------------------------------------------------------
; GET GUI CONTROLLER
;------------------------------------------------------------------------------
programTitle = ON Macro
Gui, Margin, 20, 20
Gui, Add, Text, x15 y5 w120 h20,On Macro 0.1
Gui, Add, Edit, x15 y25 h20 w60 vEdit2 +ReadOnly, 좌표
Gui, Add, Text, x90 y29 w60 h20, 목표좌표
Gui, Add, Edit, x155 y25 h20 w20 vXinput +ReadOnly, x
Gui, Add, Edit, x180 y25 h20 w20 vYinput +ReadOnly, y
;Gui, Add, Edit, x205 y25 h20 w55 vEdit +ReadOnly, 명령

Gui, Add, Edit, x15 y60 w140 h20 vImgFile +ReadOnly,매크로파일을 불러오세요
Gui, Add, Button, x160 y60 w80 h20 vBtnFile,(1) load File
Gui, Add, Button, x15 y85 w225 h20 vSetting, (2) Setting
Gui, Add, Button, x15 y105 w225 h20, (3) Start
Gui, Add, Button, x15 y125 w225 h20, (4) STOP
Gui, Add, Button, x15 y145 w225 h20, (5) RELOAD
Gui, Add, Edit, x10 y185 h20 w150 vTimerEdit, STATUS ; Debug TEXT MESSAGE BOX
;Gui, Add, Edit, x10 y205 h20 w150 vTransActive, 기본 ; 영술사용 메시지 표시박스
Gui, Add, CheckBox,x15 y170 h20 w185 vMoveAttack, 무빙공격(영술사용)
Gui, Add, Listbox,x15 y195 h150 w225 vMacroList, :: 명령리스트 ::
hIcon := Create_ico()
Gui +LastFound  ; Set the "last found window" for use in the next lines.
SendMessage, 0x80, 0, hIcon  ; Set the window's small icon (0x80 is WM_SETICON).
SendMessage, 0x80, 1, hIcon  ; Set the window's big icon to the same one.
Gui, Add, StatusBar,,
Gui,show,,% programTitle

;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; SET GLOBAL VALUE
;------------------------------------------------------------------------------
msgboxList= ; 
title=[ON]바람의나라
imgX := Create_x_bmp()
imgY := Create_y_bmp()
x0 := Create_x0_bmp()
x1 := Create_x1_bmp()
x2 := Create_x2_bmp()
x3 := Create_x3_bmp()
x4 := Create_x4_bmp()
x5 := Create_x5_bmp()
x6 := Create_x6_bmp()
x7 := Create_x7_bmp()
x8 := Create_x8_bmp()
x9 := Create_x9_bmp()
sk1 := Create_sk1_bmp()
die := Create_die_bmp()
live := Create_live_bmp()
full := Create_full_bmp()
suho := Create_suho_bmp()
var = 50
text1=
text2=
presentX=
presentY=
DES_X=
DES_Y=
ArrayMoveList := Object()
macroListText := Object()
statusImg =
check = false
return
;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
; IMAGE METHOD
;------------------------------------------------------------------------------
Gdip_CropImage(pBitmap, x, y, w, h)
{
pBitmap2 := Gdip_CreateBitmap(w, h), G2 := Gdip_GraphicsFromImage(pBitmap2)
Gdip_DrawImage(G2, pBitmap, 0, 0, w, h, x, y, w, h)
Gdip_DeleteGraphics(G2)
Gdip_DisposeImage(G2)
return pBitmap2
}
SaveHBITMAPToFile(hBitmap, sFile)
{ 
	VarSetCapacity(DIBSECTION, A_PtrSize=8? 104:84, 0)
  NumPut(40, DIBSECTION, A_PtrSize=8? 32:24,"UInt") ;dsBmih.biSize
  DllCall("GetObject", "UPTR", hBitmap, "int", A_PtrSize=8? 104:84, "UPTR", &DIBSECTION)
  hFile:= DllCall("CreateFile", "UPTR", &sFile, "Uint", 0x40000000, "Uint", 0, "Uint", 0, "Uint", 2, "Uint", 0, "Uint", 0)
  DllCall("WriteFile", "UPTR", hFile, "int64P", 0x4D42|14+40+(biSizeImage:=NumGet(DIBSECTION, A_PtrSize=8? 52:44, "UInt"))<<16, "Uint", 6, "UintP", 0, "Uint", 0)
  DllCall("WriteFile", "UPTR", hFile, "int64P", 54<<32, "Uint", 8, "UintP", 0, "Uint", 0)
  DllCall("WriteFile", "UPTR", hFile, "UPTR", &DIBSECTION + (A_PtrSize=8? 32:24), "Uint", 40, "UintP", 0, "Uint", 0)
  DllCall("WriteFile", "UPTR", hFile, "Uint", NumGet(DIBSECTION, A_PtrSize=8? 24:20, "UPtr"), "Uint", biSizeImage, "UintP", 0, "Uint", 0)
  DllCall("CloseHandle", "UPTR", hFile)
}
search_img(param1,param2,param3,param4,var,image) {
	pToken:=Gdip_Startup() 
	pBitmapHayStack1:=Gdip_BitmapFromhwnd(hwnd := WinExist(Title)) 		
	pBitmapNeedle:=Gdip_CreateBitmapFromHBITMAP(image,0)
	pBitmapHayStack:=Gdip_CropImage(pBitmapHayStack1,param1,param2,param3-param1,param4-param2)	
	;SaveHBITMAPToFile(image,"capture/" A_TickCount ".bmp")	; debug save ImageFile
	;Gdip_SaveBitmapToFile(pBitmapHayStack,"capture/" A_TickCount ".bmp") ; debug save ImageFile
	RESULT:= Gdip_ImageSearch(pBitmapHayStack,pBitmapNeedle,list,0,0,0,0,var,0x000000,1,1)	
	Gdip_DisposeImage(pBitmapHayStack1),Gdip_DisposeImage(pBitmapHayStack), Gdip_DisposeImage(pBitmapNeedle)
	Gdip_Shutdown(pToken)
	
	if(RESULT = 1)
	{
		return 0		
	}else
	{
		return -1
	}
}
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Message Send METHOD
;------------------------------------------------------------------------------
msgSend(str)
{
	global msgboxList
	GuiControl,,Edit, %str%
}
return

debug(time){	
	GuiControl,,TimerEdit, %time%
}
return
;------------------------------------------------------------------------------

showMakerList()
{		
	msg = 
	for index, element in ArrayMoveList
	{		
		msg = %msg% | %element%
	}
	return %msg%
}

;------------------------------------------------------------------------------
; SEARCH IMAGE - SKIL
;------------------------------------------------------------------------------
searchSkil()
{
	global title,sk1,sk2,sk3
	sendMsg = ["대장군","도깨비","괴선"]
	ArrayTrans = [sk1,sk2,sk3]		
	wingetpos,x,y,w,h,%title%		
	if (search_img(x,y,(x+w),(y+h),50,sk1) = 0)
	{
		GuiControl,,TransActive, 대장군		
		return false
	}else
	{
		GuiControl,,TransActive, 기본
		return true
	}
	
}
return
;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
; SEARCH IMAGE X
;------------------------------------------------------------------------------
searchX()
{
	global imageXYplace, var, x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,imgX,imgY, title
	;WinActivate,%title%
	wingetpos,x,y,w,h,%title%	
	sy1 := 700
	ex1 := x + w
	ey1 := y + h
	
	result1 = 99	
	result2 = 99	
	result3 = 99	
	Array:=[x0,x1,x2,x3,x4,x5,x6,x7,x8,x9]	
	Loop
	{	in=0	
		Loop,% Array.MaxIndex()	
		{
			file := Array[A_Index]			
			if (search_img(896,sy1,926,ey1,var,file) = 0)
			{
				result1 := in
				break
			}
		in++			
		}				
		in=0	
		Loop,% Array.MaxIndex()	
		{
			file := Array[A_Index]								
			if (search_img(926,sy1,934,ey1,var,file) = 0)
			{				
				result2 := in
				break
			}
		in++			
		}		
		in=0	
		Loop,% Array.MaxIndex()	
		{
			file := Array[A_Index]								
			if (search_img(933,sy1,950,ey1,var,file) = 0)
			{				
				result3 := in
				break
			}
		in++			
		}
		break
	}
	result := [result1,result2,result3]
	return result
}
return
;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
; SEARCH IMAGE Y
;------------------------------------------------------------------------------
searchY()
{
	global imageXYplace, var, x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,imgX,imgY, title	
	wingetpos,x,y,w,h,%title%	
	sy1 := 700
	ex1 := x + w
	ey1 := y + h
	
	result1 = 99	
	result2 = 99	
	result3 = 99		
	Array:=[x0,x1,x2,x3,x4,x5,x6,x7,x8,x9]	
	Loop
	{	in=0	
		Loop,% Array.MaxIndex()	
		{
			file := Array[A_Index]						
			if (search_img(956,sy1,986,ey1,var,file) = 0)
			{
				result1 := in
				break
			}
		in++			
		}				
		in=0	
		Loop,% Array.MaxIndex()	
		{
			file := Array[A_Index]								
			if (search_img(986,sy1,994,ey1,var,file) = 0)
			{				
				result2 := in
				break
			}
		in++			
		}		
		in=0	
		Loop,% Array.MaxIndex()	
		{
			file := Array[A_Index]								
			if (search_img(994,sy1,1002,ey1,var,file) = 0)
			{				
				result3 := in
				break
			}
		in++			
		}
		break
	}
	result := [result1,result2,result3]
	return result
}
return


;------------------------------------------------------------------------------
; UNIT MOVE METHOD
;------------------------------------------------------------------------------
gotoMove(preX,preY,xyArray1,xyArray2,xyArray3)
{	
	global Xinput,Yinput,presentX,presentY,DES_X,DES_Y,RandomTimer,title,MoveAttack
	Gui,submit,NoHide	
	if(MoveAttack = 1)
	{
		if(searchSkil())
		{
			;SB_SetText("자동공격사용중")
			controlsend,,7,%title%
			sleep, 500
		}
	}
	
	x := preX[1]preX[2]preX[3]
	y := preY[1]preY[2]preY[3]	
	DES_X :=xyArray1
	DES_Y :=xyArray2
	
	if(DES_X = x and DES_Y = y)
	{
		if(xyArray3 = 1)
		{
			;Fight()
		}
		if(MoveAttack = 1)
		{
			if(!searchSkil())
			{
				controlsend,,0,%title%
				sleep, 500
			}			
		}
		return true
	}
	SetTimer,setThisXY,1000

	if(presentX = x and presentY = y)
	{
		goRandom()
	}
	loop,3
	{
	 random,A,1,2	 
	 if(A=1)
	 {
	  goX(x,y)
	 }
	 if(A=2)
	 {
	  goY(x,y)
	 }
	}	
setThisXY:
presentX:=x
presentY:=y
return false
}
return
;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
; UNIT MOVE X
;------------------------------------------------------------------------------
goX(x,y)
{
	global DES_X,DES_Y,title,MoveAttack	
	;loop, 3
	;{		
		if(MoveAttack = 1)
		{
			postmessage,0x100,49,131073,,%title%
			postmessage,0x101,49,131073,,%title%
		}
		 if( x > DES_X )
		 {
		  SB_SetText("왼쪽")
		  Loop,3
			{
		  postmessage,0x100,37,21692417,,%title%
		  postmessage,0x101,37,21692417,,%title%  
			}
		 }
		 else if( x < DES_X )
		 {
		  SB_SetText("오른쪽")
		  Loop,3
		{
		  postmessage,0x100,39,21823489,,%title%
		  postmessage,0x101,39,21823489,,%title%	  
	  }
		 }
		 else if( x = DES_X )
		 {
		  goY(x,y)
		 }
	;}
}
return
;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
; UNIT MOVE Y
;------------------------------------------------------------------------------
goY(x,y)
{
	global DES_X,DES_Y,title,MoveAttack
	
	;loop, 3
	;{
		if(MoveAttack = 1)
		{
			postmessage,0x100,49,131073,,%title%
			postmessage,0x101,49,131073,,%title%
		}
		 if( y > DES_Y )
		 {
		  SB_SetText("위로")
		  Loop,3
		{		
		  postmessage,0x100,38,21495809,,%title%
		  postmessage,0x101,38,21495809,,%title%
	  }
		 }
		 else if( y < DES_Y )
		 {
		  SB_SetText("아래로")
		  Loop,3
		{
		  postmessage,0x100,40,22020097,,%title%
		  postmessage,0x101,40,22020097,,%title%
		}		  
		 }
		 else if( y = DES_Y )
		 {
		  goX(x,y)
		 }
	;}
}
return
;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
; UNIT MOVE RANDOM
;------------------------------------------------------------------------------
goRandom()
{		
	global title,MoveAttack
	 random,A,1,4	
	 if(A=1)
	 {
	  loop,3
		{
		  SB_SetText("길막자유이동")
		  postmessage,0x100,38,21495809,,%title%
		  postmessage,0x101,38,21495809,,%title%
		  sleep, 200
			if(MoveAttack = 1)
			{
				postmessage,0x100,49,131073,,%title%
				postmessage,0x101,49,131073,,%title%
				sleep, 200
			}		  
		}
	 }
	 if(A=2)
	 {
		loop,3
		{
		  SB_SetText("길막자유이동")
		  postmessage,0x100,40,22020097,,%title%
		  postmessage,0x101,40,22020097,,%title%
		  sleep, 200	
			if(MoveAttack = 1)
			{
				postmessage,0x100,49,131073,,%title%
				postmessage,0x101,49,131073,,%title%
				sleep, 200
			}		  		  
		}
	 }
	 if(A=3)
	 {
		loop,3
		{
		  SB_SetText("길막자유이동")	
		  postmessage,0x100,37,21692417,,%title%
		  postmessage,0x100,37,21692417,,%title%
		  sleep, 200	
			if(MoveAttack = 1)
			{
				postmessage,0x100,49,131073,,%title%
				postmessage,0x101,49,131073,,%title%
				sleep, 200
			}		  		  
		}
	 }
	 if(A=4)
	 {
		loop,3
		{
		  SB_SetText("길막자유이동")
		  postmessage,0x100,39,21823489,,%title%
		  postmessage,0x101,39,21823489,,%title%
		  sleep, 200		
		  if(MoveAttack = 1)
			{
				postmessage,0x100,49,131073,,%title%
				postmessage,0x101,49,131073,,%title%
				sleep, 200
			}		  
		}
	 }
}
return
