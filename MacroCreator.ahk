﻿; *****************************
; :: PULOVER'S MACRO CREATOR ::
; *****************************
; "The Complete Automation Tool"
; Author: Pulover [Rodolfo U. Batista]
; pulover@macrocreator.com
; Home: http://www.macrocreator.com
; Forum: http://www.autohotkey.com/board/topic/79763-macro-creator
; Version: 4.0.0
; Release Date: August, 2013
; AutoHotkey Version: 1.1.12.00
; Copyright © 2012-2013 Rodolfo U. Batista
; GNU General Public License 3.0 or higher
; <http://www.gnu.org/licenses/gpl-3.0.txt>

/*
Thanks to:

tic (Tariq Porter) for his GDI+ Library.
http://www.autohotkey.com/board/topic/29449-gdi-standard-library

tkoi & majkinetor for the Graphic Buttons function.
http://www.autohotkey.com/board/topic/37147-ilbutton-image-buttons

just me for LV_Colors Class, GuiCtrlAddTab and for updating ILButton to 64bit.
http://www.autohotkey.com/board/topic/88699-class-lv-colors

diebagger and Obi-Wahn for the function to move rows.
http://www.autohotkey.com/board/topic/56396-techdemo-move-rows-in-a-listview

Micahs for the base code of the Drag-Rows function.
http://www.autohotkey.com/board/topic/30486-listview-tooltip-on-mouse-hover/?p=280843

Kdoske & trueski for the CSV functions.
http://www.autohotkey.com/board/topic/51681-csv-library-lib
http://www.autohotkey.com/board/topic/39392-fairly-elaborate-csv-functions

jaco0646 for the function to make hotkey controls detect other keys.
http://www.autohotkey.com/board/topic/47439-user-defined-dynamic-hotkeys

Laszlo for the Monster function to solve expressions.
http://www.autohotkey.com/board/topic/15675-monster

Jethrow for the IEGet Function.
http://www.autohotkey.com/board/topic/47052-basic-webpage-controls

RaptorX for the Scintilla Wrapper for AHK
http://www.autohotkey.com/board/topic/85928-wrapper-scintilla-wrapper

majkinetor for the Dlg_Color function.
http://www.autohotkey.com/board/topic/49214-ahk-ahk-l-forms-framework-08/

rbrtryn for the ChooseColor function.
http://www.autohotkey.com/board/topic/91229-windows-color-picker-plus/

fincs for GenDocs.
http://www.autohotkey.com/board/topic/71751-gendocs-v30-alpha002

T800 for Html Help utils.
http://www.autohotkey.com/board/topic/17984-html-help-utils

Translation revisions: Snow Flake (Swedish), huyaowen (Chinese Simplified), Jörg Schmalenberger (German).
*/

; Compiler Settings
;@Ahk2Exe-SetName Pulover's Macro Creator
;@Ahk2Exe-SetDescription Pulover's Macro Creator
;@Ahk2Exe-SetVersion 4.0.0
;@Ahk2Exe-SetCopyright Copyright © 2012-2013 Rodolfo U. Batista
;@Ahk2Exe-SetOrigFilename MacroCreator.exe

If A_OSVersion in WIN_NT4,WIN_95,WIN_98,WIN_ME
{
	MsgBox This program requires Windows 2000/XP or later.
	ExitApp
}

#NoEnv
#InstallKeybdHook
#MaxThreadsBuffer On
#MaxHotkeysPerInterval 999999999
#HotkeyInterval 9999999999
SetWorkingDir %A_ScriptDir%
SendMode Input
#WinActivateForce
SetTitleMatchMode, 2
SetControlDelay, 1
SetWinDelay, 0
SetKeyDelay, -1
SetMouseDelay, -1
SetBatchLines, -1
FileEncoding, UTF-8
Process, Priority,, High
#NoTrayIcon

Menu, Tray, Tip, Pulovers's Macro Creator
DefaultIcon := (A_IsCompiled) ? A_ScriptFullPath
			:  (FileExist(A_ScriptDir "\Resources\PMC4_Mult.ico") ? A_ScriptDir "\Resources\PMC4_Mult.ico" : A_AhkPath)
Menu, Tray, Icon, %DefaultIcon%, 1, 1

SciDllPath := (A_IsCompiled) ? (A_ScriptDir "\SciLexer.dll")
			: (A_ScriptDir ((A_PtrSize = 8) ? "\SciLexer-x64.dll" : "\SciLexer-x86.dll"))
DllCall("LoadLibrary", "Str", SciDllPath)

IfNotExist, %SciDllPath%
{
	MsgBox A required DLL is missing. Please reinstall the application.
	ExitApp
}

ResDllPath := A_ScriptDir "\Resources.dll", hIL_Icons := IL_Create(10, 10)
IfNotExist, %ResDllPath%
{
	MsgBox A required DLL is missing. Please reinstall the application.
	ExitApp
}

Loop
{
	If (!IL_Add(hIL_Icons, ResDllPath, A_Index) && (A_Index > 1))
		break
}

CurrentVersion := "4.0.0", ReleaseDate := "August, 2013"

;##### Ini File Read #####

If (!FileExist(A_ScriptDir "\MacroCreator.ini") && !InStr(FileExist(A_AppData "\MacroCreator"), "D"))
	FileCreateDir, %A_AppData%\MacroCreator

SettingsFolder := FileExist(A_ScriptDir "\MacroCreator.ini") ? A_ScriptDir : A_AppData "\MacroCreator"
,	IniFilePath := SettingsFolder "\MacroCreator.ini", UserVarsPath := SettingsFolder "\UserGlobalVars.ini"

IniRead, Version, %IniFilePath%, Application, Version
IniRead, Lang, %IniFilePath%, Language, Lang
IniRead, AutoKey, %IniFilePath%, HotKeys, AutoKey, F3|F4|F5|F6|F7
IniRead, ManKey, %IniFilePath%, HotKeys, ManKey, |
IniRead, AbortKey, %IniFilePath%, HotKeys, AbortKey, F8
IniRead, PauseKey, %IniFilePath%, HotKeys, PauseKey, F12
IniRead, RecKey, %IniFilePath%, HotKeys, RecKey, F9
IniRead, RecNewKey, %IniFilePath%, HotKeys, RecNewKey, F10
IniRead, RelKey, %IniFilePath%, HotKeys, RelKey, CapsLock
IniRead, FastKey, %IniFilePath%, HotKeys, FastKey, Insert
IniRead, SlowKey, %IniFilePath%, HotKeys, SlowKey, Pause
IniRead, ClearNewList, %IniFilePath%, Options, ClearNewList, 0
IniRead, DelayG, %IniFilePath%, Options, DelayG, 0
IniRead, OnScCtrl, %IniFilePath%, Options, OnScCtrl, 1
IniRead, ShowStep, %IniFilePath%, Options, ShowStep, 1
IniRead, HideMainWin, %IniFilePath%, Options, HideMainWin, 1
IniRead, DontShowPb, %IniFilePath%, Options, DontShowPb, 0
IniRead, DontShowRec, %IniFilePath%, Options, DontShowRec, 0
IniRead, DontShowAdm, %IniFilePath%, Options, DontShowAdm, 0
IniRead, ShowTips, %IniFilePath%, Options, ShowTips, 1
IniRead, NextTip, %IniFilePath%, Options, NextTip, 1
IniRead, IfDirectContext, %IniFilePath%, Options, IfDirectContext, None
IniRead, IfDirectWindow, %IniFilePath%, Options, IfDirectWindow, %A_Space%
IniRead, KeepHkOn, %IniFilePath%, Options, KeepHkOn, 0
IniRead, Mouse, %IniFilePath%, Options, Mouse, 1
IniRead, Moves, %IniFilePath%, Options, Moves, 1
IniRead, TimedI, %IniFilePath%, Options, TimedI, 1
IniRead, Strokes, %IniFilePath%, Options, Strokes, 1
IniRead, CaptKDn, %IniFilePath%, Options, CaptKDn, 0
IniRead, MScroll, %IniFilePath%, Options, MScroll, 1
IniRead, WClass, %IniFilePath%, Options, WClass, 1
IniRead, WTitle, %IniFilePath%, Options, WTitle, 1
IniRead, MDelay, %IniFilePath%, Options, MDelay, 0
IniRead, DelayM, %IniFilePath%, Options, DelayM, 10
IniRead, DelayW, %IniFilePath%, Options, DelayW, 333
IniRead, MaxHistory, %IniFilePath%, Options, MaxHistory, 100
IniRead, TDelay, %IniFilePath%, Options, TDelay, 10
IniRead, ToggleC, %IniFilePath%, Options, ToggleC, 0
IniRead, RecKeybdCtrl, %IniFilePath%, Options, RecKeybdCtrl, 0
IniRead, RecMouseCtrl, %IniFilePath%, Options, RecMouseCtrl, 0
IniRead, CoordMouse, %IniFilePath%, Options, CoordMouse, Window
IniRead, SpeedUp, %IniFilePath%, Options, SpeedUp, 2
IniRead, SpeedDn, %IniFilePath%, Options, SpeedDn, 2
IniRead, MouseReturn, %IniFilePath%, Options, MouseReturn, 0
IniRead, ShowProgBar, %IniFilePath%, Options, ShowProgBar, 1
IniRead, ShowBarOnStart, %IniFilePath%, Options, ShowBarOnStart, 0
IniRead, RandomSleeps, %IniFilePath%, Options, RandomSleeps, 0
IniRead, RandPercent, %IniFilePath%, Options, RandPercent, 50
IniRead, DrawButton, %IniFilePath%, Options, DrawButton, RButton
IniRead, OnRelease, %IniFilePath%, Options, OnRelease, 1
IniRead, OnEnter, %IniFilePath%, Options, OnEnter, 0
IniRead, LineW, %IniFilePath%, Options, LineW, 2
IniRead, ScreenDir, %IniFilePath%, Options, ScreenDir, %SettingsFolder%\Screenshots
IniRead, DefaultEditor, %IniFilePath%, Options, DefaultEditor, notepad.exe
IniRead, DefaultMacro, %IniFilePath%, Options, DefaultMacro, %A_Space%
IniRead, StdLibFile, %IniFilePath%, Options, StdLibFile, %A_Space%
IniRead, KeepDefKeys, %IniFilePath%, Options, KeepDefKeys, 0
IniRead, HKOff, %IniFilePath%, Options, HKOff, 0
IniRead, MultInst, %IniFilePath%, Options, MultInst, 0
IniRead, EvalDefault, %IniFilePath%, Options, EvalDefault, 0
IniRead, AllowRowDrag, %IniFilePath%, Options, AllowRowDrag, 1
IniRead, ShowLoopIfMark, %IniFilePath%, Options, ShowLoopIfMark, 1
IniRead, ShowActIdent, %IniFilePath%, Options, ShowActIdent, 1
IniRead, LoopLVColor, %IniFilePath%, Options, LoopLVColor, 0xFFFF00
IniRead, IfLVColor, %IniFilePath%, Options, IfLVColor, 0x0000FF
IniRead, VirtualKeys, %IniFilePath%, Options, VirtualKeys, % "
(Join
{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}
{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{1}{2}{3}{4}{5}{6}{7}{8}{9}{0}
{'}{-}{=}{[}{]}{;}{/}{,}{.}{\}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}
{Del}{Ins}{BS}{Esc}{PrintScreen}{Pause}{Enter}{Tab}{Space}
{Numpad0}{Numpad1}{Numpad2}{Numpad3}{Numpad4}{Numpad5}{Numpad6}{Numpad7}{Numpad8}{Numpad9}
{NumpadDot}{NumpadDiv}{NumpadMult}{NumpadAdd}{NumpadSub}{NumpadIns}{NumpadEnd}{NumpadDown}
{NumpadPgDn}{NumpadLeft}{NumpadClear}{NumpadRight}{NumpadHome}{NumpadUp}{NumpadPgUp}{NumpadDel}
{NumpadEnter}{Browser_Back}{Browser_Forward}{Browser_Refresh}{Browser_Stop}{Browser_Search}
{Browser_Favorites}{Browser_Home}{Volume_Mute}{Volume_Down}{Volume_Up}{Media_Next}{Media_Prev}
{Media_Stop}{Media_Play_Pause}{Launch_Mail}{Launch_Media}{Launch_App1}{Launch_App2}
)"
IniRead, AutoUpdate, %IniFilePath%, Options, AutoUpdate, 1
IniRead, Ex_AbortKey, %IniFilePath%, ExportOptions, Ex_AbortKey, 0
IniRead, Ex_PauseKey, %IniFilePath%, ExportOptions, Ex_PauseKey, 0
IniRead, Ex_SM, %IniFilePath%, ExportOptions, Ex_SM, 1
IniRead, SM, %IniFilePath%, ExportOptions, SM, Input
IniRead, Ex_SI, %IniFilePath%, ExportOptions, Ex_SI, 1
IniRead, SI, %IniFilePath%, ExportOptions, SI, Force
IniRead, Ex_ST, %IniFilePath%, ExportOptions, Ex_ST, 1
IniRead, ST, %IniFilePath%, ExportOptions, ST, 2
IniRead, Ex_DH, %IniFilePath%, ExportOptions, Ex_DH, 1
IniRead, Ex_AF, %IniFilePath%, ExportOptions, Ex_AF, 1
IniRead, Ex_HK, %IniFilePath%, ExportOptions, Ex_HK, 0
IniRead, Ex_PT, %IniFilePath%, ExportOptions, Ex_PT, 0
IniRead, Ex_NT, %IniFilePath%, ExportOptions, Ex_NT, 0
IniRead, Ex_SC, %IniFilePath%, ExportOptions, Ex_SC, 1
IniRead, SC, %IniFilePath%, ExportOptions, SC, 1
IniRead, Ex_SW, %IniFilePath%, ExportOptions, Ex_SW, 1
IniRead, SW, %IniFilePath%, ExportOptions, SW, 0
IniRead, Ex_SK, %IniFilePath%, ExportOptions, Ex_SK, 1
IniRead, SK, %IniFilePath%, ExportOptions, SK, -1
IniRead, Ex_MD, %IniFilePath%, ExportOptions, Ex_MD, 1
IniRead, MD, %IniFilePath%, ExportOptions, MD, -1
IniRead, Ex_SB, %IniFilePath%, ExportOptions, Ex_SB, 1
IniRead, SB, %IniFilePath%, ExportOptions, SB, -1
IniRead, Ex_MT, %IniFilePath%, ExportOptions, Ex_MT, 0
IniRead, MT, %IniFilePath%, ExportOptions, MT, 2
IniRead, Ex_IN, %IniFilePath%, ExportOptions, Ex_IN, 1
IniRead, Ex_UV, %IniFilePath%, ExportOptions, Ex_UV, 1
IniRead, Ex_Speed, %IniFilePath%, ExportOptions, Ex_Speed, 0
IniRead, ComCr, %IniFilePath%, ExportOptions, ComCr, 1
IniRead, ComAc, %IniFilePath%, ExportOptions, ComAc, 0
IniRead, Send_Loop, %IniFilePath%, ExportOptions, Send_Loop, 0
IniRead, TabIndent, %IniFilePath%, ExportOptions, TabIndent, 1
IniRead, IncPmc, %IniFilePath%, ExportOptions, IncPmc, 0
IniRead, Exe_Exp, %IniFilePath%, ExportOptions, Exe_Exp, 0
IniRead, MainWinSize, %IniFilePath%, WindowOptions, MainWinSize, W900 H630
IniRead, ShowPrev, %IniFilePath%, WindowOptions, ShowPrev, 0
IniRead, WinState, %IniFilePath%, WindowOptions, WinState, 0
IniRead, ColSizes, %IniFilePath%, WindowOptions, ColSizes, 70,130,190,50,40,85,95,95,60,40
IniRead, CustomColors, %IniFilePath%, WindowOptions, CustomColors, 0
IniRead, OSCPos, %IniFilePath%, WindowOptions, OSCPos, X0 Y0
IniRead, OSTrans, %IniFilePath%, WindowOptions, OSTrans, 255
IniRead, OSCaption, %IniFilePath%, WindowOptions, OSCaption, 0
IniRead, MainLayout, %IniFilePath%, ToolbarOptions, MainLayout
IniRead, MacroLayout, %IniFilePath%, ToolbarOptions, MacroLayout
IniRead, FileLayout, %IniFilePath%, ToolbarOptions, FileLayout
IniRead, RecPlayLayout, %IniFilePath%, ToolbarOptions, RecPlayLayout
IniRead, SettingsLayout, %IniFilePath%, ToolbarOptions, SettingsLayout
IniRead, CommandLayout, %IniFilePath%, ToolbarOptions, CommandLayout
IniRead, EditLayout, %IniFilePath%, ToolbarOptions, EditLayout
IniRead, ShowBands, %IniFilePath%, ToolbarOptions, ShowBands, 1,1,1,1,1,1,1,1,1

If (Version < 4)
	ShowTips := 1

User_Vars := new ObjIni(UserVarsPath)
User_Vars.Read()

LangCodes := {	Id: ["0421"]
			,	Ms: ["043e","083e"]
			,	Ca: ["0403"]
			,	Da: ["0406"]
			,	De: ["0407","0807","0c07","1007","1407"]
			,	Es: ["040a","080a","0c0a","100a","140a","180a","1c0a","200a","240a","280a","2c0a","300a","340a","380a","3c0a","400a","440a","480a","4c0a","500a"]
			,	Fr: ["040c","080c","0c0c","100c","140c","180c"]
			,	Hr: ["041a"]
			,	It: ["0410","0810"]
			,	Hu: ["040e"]
			,	Nl: ["0413","0813"]
			,	No: ["0414","0814"]
			,	Pl: ["0415"]
			,	Pt: ["0416","0816"]
			,	Sl: ["0424"]
			,	Sk: ["041b"]
			,	Fi: ["040b"]
			,	Sv: ["041d","081d"]
			,	Vi: ["042a"]
			,	Tr: ["041f"]
			,	Cs: ["0405"]
			,	El: ["0408"]
			,	Bg: ["0402"]
			,	Ru: ["0419"]
			,	Sr: ["1c1a","0c1a"]
			,	Uk: ["0422"]
			,	Zh: ["0804","0c04","1004","1404","0004","7c04"]
			,	Zt: ["0404"]
			,	Ja: ["0411"]
			,	Ko: ["0412"]}

If (Lang = "ERROR")
{
	For La, Array in LangCodes
	{
		For L, Code in Array
		{
			If (A_Language = Code)
			{
				Lang := La
				break
			}
		}
	}
	If (Lang = "ERROR")
		Lang := "En"
}

GoSub, WriteSettings

CurrentLang := Lang

,	Lang_Id := "Bahasa Indonesia`t(Indonesian)"
,	Lang_Ms := "Bahasa Malaysia`t(Malay)"
,	Lang_Ca := "Català`t(Catalan)"
,	Lang_Da := "Dansk`t(Danish﻿)"
,	Lang_De := "Deutsch`t(German)"
,	Lang_En := "English"
,	Lang_Es := "Español`t(Spanish)"
,	Lang_Fr := "Français`t(French)"
,	Lang_Hr := "Hrvatski`t(Croatian)"
,	Lang_It := "Italiano`t(Italian)"
,	Lang_Hu := "Magyar`t(Hungarian)"
,	Lang_Nl := "Nederlands`t(Dutch)"
,	Lang_No := "Norsk`t(Norwegian)"
,	Lang_Pl := "Polski`t(Polish)"
,	Lang_Pt := "Português`t(Portuguese)"
,	Lang_Sl := "Slovenski`t(Slovenian)"
,	Lang_Sk := "Slovenčina`t(Slovak)"
,	Lang_Fi := "Suomi`t(Finnish)"
,	Lang_Sv := "Svenska`t(Swedish)"
,	Lang_Vi := "Tiếng Việt`t(Vietnamese)"
,	Lang_Tr := "Türkçe`t(Turkish)"
,	Lang_Cs := "Čeština`t(Czech)"
,	Lang_El := "ελληνικά`t(Greek)"
,	Lang_Bg := "Български`t(Bulgarian)"
,	Lang_Ru := "Русский`t(Russian)"
,	Lang_Sr := "Српски`t(Serbian)"
,	Lang_Uk := "Україньска`t(Ukrainian)"
,	Lang_Zh := "中文(简体)`t(Chinese Simplified)"
,	Lang_Zt := "中文(繁體)`t(Chinese Traditional)"
,	Lang_Ja := "日本語`t(Japanese)"
,	Lang_Ko := "한국어`t(Korean)"
,	Lang_All := "
(Join|
Bahasa Indonesia`t(Indonesian)=Id
Bahasa Malaysia`t(Malay)=Ms
Català`t(Catalan)=Ca
Dansk`t(Danish﻿)=Da
Deutsch`t(German)=De
English=En
Español`t(Spanish)=Es
Français`t(French)=Fr
Hrvatski`t(Croatian)=Hr
Italiano`t(Italian)=It
Magyar`t(Hungarian)=Hu
Nederlands`t(Dutch)=Nl
Norsk`t(Norwegian)=No
Polski`t(Polish)=Pl
Português`t(Portuguese)=Pt
Slovenski`t(Slovenian)=Sl
Slovenčina`t(Slovak)=Sk
Suomi`t(Finnish)=Fi
Svenska`t(Swedish)=Sv
Tiếng Việt`t(Vietnamese)=Vi
Türkçe`t(Turkish)=Tr
Čeština`t(Czech)=Cs
ελληνικά`t(Greek)=El
Български`t(Bulgarian)=Bg
Русский`t(Russian)=Ru
Српски`t(Serbian)=Sr
Україньска`t(Ukrainian)=Uk
中文(简体)`t(Chinese Simplified)=Zh
中文(繁體)`t(Chinese Traditional)=Zt
日本語`t(Japanese)=Ja
한국어`t(Korean)=Ko
)"

AppName := "Pulover's Macro Creator"
,	HeadLine := "; This script was created using Pulover's Macro Creator"
,	PmcHead := "/*"
. "`nPMC File Version " CurrentVersion
. "`n---[Do not edit anything in this section]---`n`n"

If (KeepDefKeys = 1)
	DefAutoKey := AutoKey, DefManKey := ManKey

GoSub, LoadLang

#Include <Definitions>
#Include <WordList>

GoSub, ObjCreate
ToggleMode := ToggleC ? "T" : "P"
Loop, Parse, ColSizes, `,
	Col_%A_Index% := A_LoopField
Loop, Parse, ShowBands, `,
	ShowBand%A_Index% := A_LoopField

RegRead, DClickSpd, HKEY_CURRENT_USER, Control Panel\Mouse, DoubleClickSpeed
DClickSpd := Round(DClickSpd * 0.001, 1)

;##### Menus: #####

Gui, 1:+LastFound
Gui, 1:Default

Menu, Tray, NoStandard
GoSub, CreateMenuBar

Menu, MouseB, Add, Click, HelpB
Menu, MouseB, Add, ControlClick, HelpB
Menu, MouseB, Add, MouseClickDrag, HelpB
Menu, MouseB, Icon, Click, %ResDllPath%, 24
Menu, TextB, Add, Send / SendRaw, HelpB
Menu, TextB, Add, ControlSend, HelpB
Menu, TextB, Add, ControlSetText, HelpB
Menu, TextB, Add, Clipboard, HelpB
Menu, TextB, Icon, Send / SendRaw, %ResDllPath%, 24
Menu, ControlB, Add, Control, HelpB
Menu, ControlB, Add, ControlFocus, HelpB
Menu, ControlB, Add, ControlGet, HelpB
Menu, ControlB, Add, ControlGetFocus, HelpB
Menu, ControlB, Add, ControlGetPos, HelpB
Menu, ControlB, Add, ControlGetText, HelpB
Menu, ControlB, Add, ControlMove, HelpB
Menu, ControlB, Add, ControlSetText, HelpB
Menu, ControlB, Icon, Control, %ResDllPath%, 24
Menu, SpecialB, Add, List of Keys, SpecialB
Menu, SpecialB, Icon, List of Keys, %ResDllPath%, 24
Menu, PauseB, Add, Sleep, HelpB
Menu, PauseB, Add, MsgBox, HelpB
Menu, PauseB, Add, KeyWait, HelpB
Menu, PauseB, Icon, Sleep, %ResDllPath%, 24
Menu, WindowB, Add, WinActivate, HelpB
Menu, WindowB, Add, WinActivateBottom, HelpB
Menu, WindowB, Add, WinClose, HelpB
Menu, WindowB, Add, WinGet, HelpB
Menu, WindowB, Add, WinGetClass, HelpB
Menu, WindowB, Add, WinGetText, HelpB
Menu, WindowB, Add, WinGetTitle, HelpB
Menu, WindowB, Add, WinGetPos, HelpB
Menu, WindowB, Add, WinHide, HelpB
Menu, WindowB, Add, WinKill, HelpB
Menu, WindowB, Add, WinMaximize, HelpB
Menu, WindowB, Add, WinMinimize, HelpB
Menu, WindowB, Add, WinMinimizeAll / WinMinimizeAllUndo, HelpB
Menu, WindowB, Add, WinMove, HelpB
Menu, WindowB, Add, WinRestore, HelpB
Menu, WindowB, Add, WinSet, HelpB
Menu, WindowB, Add, WinShow, HelpB
Menu, WindowB, Add, WinWait, HelpB
Menu, WindowB, Add, WinWaitActive / WinWaitNotActive, HelpB
Menu, WindowB, Add, WinWaitClose, HelpB
Menu, WindowB, Icon, WinActivate, %ResDllPath%, 24
Menu, ImageB, Add, ImageSearch, HelpB
Menu, ImageB, Add, PixelSearch, HelpB
Menu, ImageB, Icon, ImageSearch, %ResDllPath%, 24
Loop, Parse, FileCmdList, |
{
	If (A_LoopField = "")
		continue
	If (InStr(A_LoopField, "File")=1 || InStr(A_LoopField, "Drive")=1)
		Menu, m_File, Add, %A_LoopField%, HelpB
	Else If (InStr(A_LoopField, "Sort")=1 || InStr(A_LoopField, "String")=1
	|| InStr(A_LoopField, "Split")=1)
	{
		If (InStr(A_LoopField, "Left") || InStr(A_LoopField, "Lower"))
		{
			LastCmd := A_LoopField " / "
			continue
		}
		Else
		{
			Menu, m_String, Add, %LastCmd%%A_LoopField%, HelpB
			LastCmd := ""
		}
	}
	Else If (!InStr(A_LoopField, "Run") && (InStr(A_LoopField, "Wait")
	|| (A_LoopField = "Input")))
		Menu, m_Wait, Add, %A_LoopField%, HelpB
	Else If A_LoopField contains Box,Tip,Progress,Splash
		Menu, m_Dialogs, Add, %A_LoopField%, HelpB
	Else If (InStr(A_LoopField, "Reg") || InStr(A_LoopField, "Ini")=1)
		Menu, m_Registry, Add, %A_LoopField%, HelpB
	Else If InStr(A_LoopField, "Sound")=1
		Menu, m_Sound, Add, %A_LoopField%, HelpB
	Else If InStr(A_LoopField, "Group")=1
		Menu, m_Group, Add, %A_LoopField%, HelpB
	Else If InStr(A_LoopField, "Env")=1
		Menu, m_Vars, Add, %A_LoopField%, HelpB
	Else If InStr(A_LoopField, "Get")
		Menu, m_Get, Add, %A_LoopField%, HelpB
	Else If A_LoopField not contains Run,Process,Shutdown
		Menu, m_Misc, Add, %A_LoopField%, HelpB
}
Menu, RunB, Add, Run / RunWait, HelpB
Menu, RunB, Add, RunAs, HelpB
Menu, RunB, Add, Process, HelpB
Menu, RunB, Add, Shutdown, HelpB
Menu, RunB, Add, File, :m_File
Menu, RunB, Add, String, :m_String
Menu, RunB, Add, Get Info, :m_Get
Menu, RunB, Add, Wait, :m_Wait
Menu, RunB, Add, Window Groups, :m_Group
Menu, RunB, Add, Dialogs, :m_Dialogs
Menu, RunB, Add, Reg && Ini, :m_Registry
Menu, RunB, Add, Sound, :m_Sound
Menu, RunB, Add, Variables, :m_Vars
Menu, RunB, Add, Misc., :m_Misc
Menu, RunB, Icon, Run / RunWait, %ResDllPath%, 24
Menu, ComLoopB, Add, Loop, LoopB
Menu, ComLoopB, Add, Loop`, FilePattern, LoopB
Menu, ComLoopB, Add, Loop`, Parse, LoopB
Menu, ComLoopB, Add, Loop`, Read File, LoopB
Menu, ComLoopB, Add, Loop`, Registry, LoopB
Menu, ComLoopB, Add, Break, HelpB
Menu, ComLoopB, Add, Continue, HelpB
Menu, ComLoopB, Add, Goto, HelpB
Menu, ComLoopB, Add, Gosub, HelpB
Menu, ComLoopB, Add, Labels, HelpB
Menu, ComLoopB, Icon, Loop, %ResDllPath%, 24
Menu, IfStB, Add, IfWinActive / IfWinNotActive, HelpB
Menu, IfStB, Add, IfWinExist / IfWinNotExist, HelpB
Menu, IfStB, Add, IfExist / IfNotExist, HelpB
Menu, IfStB, Add, IfInString / IfNotInString, HelpB
Menu, IfStB, Add, IfMsgBox, HelpB
Menu, IfStB, Add, If Statements, HelpB
Menu, IfStB, Add, Variables, HelpB
Menu, IfStB, Add, Functions, HelpB
Menu, IfStB, Icon, IfWinActive / IfWinNotActive, %ResDllPath%, 24
Menu, IEComB, Add, COM, IEComB
Menu, IEComB, Add, Basic Webpage COM Tutorial, IEComB
Menu, IEComB, Add, IWebBrowser2 Interface (MSDN), IEComB
Menu, IEComB, Icon, COM, %ResDllPath%, 24
Menu, SendMsgB, Add, PostMessage / SendMessage, HelpB
Menu, SendMsgB, Add, Message List, SendMsgB
Menu, SendMsgB, Add, Microsoft MSDN, SendMsgB
Menu, SendMsgB, Icon, PostMessage / SendMessage, %ResDllPath%, 24
Menu, IfDirB, Add, #IfWinActive / #IfWinExist, HelpB
Menu, IfDirB, Icon, #IfWinActive / #IfWinExist, %ResDllPath%, 24
Menu, ExportG, Add, Hotkeys, ExportG
Menu, ExportG, Add, Hotstrings, ExportG
Menu, ExportG, Add, List of Keys, ExportG
Menu, ExportG, Add, ComObjCreate, ExportG
Menu, ExportG, Add, ComObjActive, ExportG
Menu, ExportG, Add, Auto-execute Section, ExportG
Menu, ExportG, Add, #IfWinActive / #IfWinExist, HelpB
Menu, ExportG, Icon, Hotkeys, %ResDllPath%, 24

Menu, LangMenu, Check, % Lang_%Lang%

;##### Main Window: #####

Gui, +Resize +MinSize310x140 +HwndPMCWinID

Gui, Add, Custom, ClassToolbarWindow32 hwndhTbFile gTbFile 0x0800 0x0100 0x0040 0x0008
Gui, Add, Custom, ClassToolbarWindow32 hwndhTbRecPlay gTbRecPlay 0x0800 0x0100 0x0040 0x0008
Gui, Add, Custom, ClassToolbarWindow32 hwndhTbCommand gTbCommand 0x0800 0x0100 0x0040 0x0008
Gui, Add, Custom, ClassToolbarWindow32 hwndhTbSettings gTbSettings 0x0800 0x0100 0x0040 0x0008
Gui, Add, Custom, ClassToolbarWindow32 hwndhTbEdit gTbEdit 0x0800 0x0100 0x0040 0x0008
Gui, Add, Custom, ClassReBarWindow32 hwndhRbMain vcRbMain gRB_Notify 0x0400 0x0040 0x8000
Gui, Add, Custom, ClassReBarWindow32 hwndhRbMacro vcRbMacro gRB_Notify xm-10 ym+76 -Theme 0x0800 0x0400 0x0040 0x8000 0x0008 ; 0x0004

Gui, Add, Hotkey, hwndhAutoKey vAutoKey gSaveData, % o_AutoKey[1]
Gui, Add, ListBox, hwndhJoyKey vJoyKey r1 ReadOnly Hidden
SendMessage, 0x01A0, 0, 22,, ahk_id %hJoyKey%
Gui, Add, Hotkey, hwndhManKey vManKey gWaitKeys Limit190, % o_ManKey[1]
Gui, Add, Hotkey, hwndhAbortKey vAbortKey, %AbortKey%
Gui, Add, Hotkey, hwndhPauseKey vPauseKey, %PauseKey%

Gui, Add, Text, -Wrap y+129 xm W100 H22 Section vRepeat, %w_Lang015%:
Gui, Add, Edit, ys-3 x+5 W90 R1 vRept
Gui, Add, UpDown, vTimesM 0x80 Range0-999999999, 1
Gui, Add, Button, -Wrap ys-4 x+0 W25 H23 hwndApplyT vApplyT gApplyT
	ILButton(ApplyT, ResDllPath ":" 1)
Gui, Add, Text, W2 H25 ys-3 x+5 0x11 vSeparator1
Gui, Add, Text, -Wrap x+5 ys W100 H22 vDelayT, %w_Lang016%
Gui, Add, Edit, ys-3 x+5 W90 R1 vDelay
Gui, Add, UpDown, vDelayG 0x80 Range0-999999999, %DelayG%
Gui, Add, Button, -Wrap ys-4 x+0 W25 H23 hwndApplyI vApplyI gApplyI
	ILButton(ApplyI, ResDllPath ":" 1)
Gui, Add, Text, W2 H25 ys-3 x+5 0x11 vSeparator2
Gui, Add, Hotkey, ys-3 x+5 W150 vsInput
Gui, Add, Button, -Wrap ys-4 x+0 W25 H23 hwndApplyL vApplyL gApplyL
	ILButton(ApplyL, ResDllPath ":" 32)
Gui, Add, Button, -Wrap ys-4 x+5 W25 H23 hwndInsertKey vInsertKey gInsertKey
	ILButton(InsertKey, ResDllPath ":" 94)
Gui, Add, Text, W2 H25 ys-3 x+5 0x11 vSeparator3
Gui, Add, Text, -Wrap ys-6 x+5 W100 vContextTip gSetWin cBlue, #IfWin: %IfDirectContext%
Gui, Add, Text, -Wrap yp+16 W100 vCoordTip gOptions, CoordMode: %CoordMouse%
GuiControl,, WinKey, % (InStr(o_AutoKey[1], "#")) ? 1 : 0
Gui, Submit
Gui, Show, %MainWinSize% Hide
GoSub, b_Start
GoSub, DefineControls
GoSub, DefineToolbars
OnMessage(WM_COMMAND, "TB_Messages")
OnMessage(WM_MOUSEMOVE, "ShowTooltip")
OnMessage(WM_RBUTTONDOWN, "ShowContextHelp")
OnMessage(WM_LBUTTONDOWN, "DragToolbar")
OnMessage(WM_ACTIVATE, "WinCheck")
OnMessage(WM_COPYDATA, "Receive_Params")
OnMessage(WM_HELP, "CmdHelp")
OnMessage(0x404, "AHK_NOTIFYICON")
If KeepHkOn
	Menu, Tray, Check, %w_Lang014%

If %0%
{
	WinGetActiveTitle, LastFoundWin
	Loop, %0%
	{
		Param .= %A_Index% "`n"
		If !(t_Macro) && (RegExMatch(%A_Index%, "i)^-s(\d+)*$", t_Macro))
		{
			AutoPlay := "Macro" t_Macro1
		,	HideWin := 1, CloseAfterPlay := 1
			break
		}
		If !(t_Macro) && (RegExMatch(%A_Index%, "i)^-a(\d+)*$", t_Macro))
			AutoPlay := "Macro" t_Macro1
		If (%A_Index% = "-p")
			PlayHK := 1
		If (%A_Index% = "-h")
			HideWin := 1
		If !(t_Timer) && (RegExMatch(%A_Index%, "i)^-t(\d*)(!)?$", _t))
			TimerPlay := 1, TimerDelayX := (_t1) ? _t1 : 250, TimedRun := RunFirst := (_t2) ? 1 : 0
		If (%A_Index% = "-c")
			CloseAfterPlay := 1
		If (%A_Index% = "-b")
			ShowCtrlBar := 1
	}
	Param := RTrim(Param, "`n")
	If !MultInst && (TargetID := WinExist("ahk_exe " A_ScriptFullPath))
	{
		Send_Params(Param, TargetID)
		ExitApp
	}
	PMC.Import(Param)
	CurrentFileName := LoadedFileName
	GoSub, FileRead
}
Else If !MultInst && (TargetID := WinExist("ahk_exe " A_ScriptFullPath))
{
	WinActivate, ahk_id %TargetID%
	ExitApp
}
Else IfExist, %DefaultMacro%
{
	PMC.Import(DefaultMacro)
	CurrentFileName := LoadedFileName
	GoSub, FileRead
}
Else
{
	HistoryMacro1 := new LV_Rows()
	HistoryMacro1.Add()
}
Menu, Tray, Icon
Gui, 1:Show, % ((WinState) ? "Maximize" : MainWinSize) ((HideWin) ? "Hide" : ""), %AppName% v%CurrentVersion% %CurrentFileName%
GoSub, LoadData
TB_Edit(tbFile, "Preview", ShowPrev)
,	TB_Edit(TbSettings, "HideMainWin", HideMainWin), TB_Edit(TbSettings, "OnScCtrl", OnScCtrl)
,	TB_Edit(TbSettings, "CheckHkOn", KeepHkOn), TB_Edit(TbSettings, "SetWin", (IfDirectContext = "None") ? 0 : 1)
Gui, 1:Default
GoSub, RowCheck
If (HideWin)
{
	Menu, Tray, Rename, %y_Lang001%, %y_Lang002%
	WinActivate, %LastFoundWin%
}
If (ShowCtrlBar)
	GoSub, OnScControls
If (PlayHK)
	GoSub, PlayStart
If ((AutoPlay) || (TimerPlay))
{
	GuiControl, chMacro:Choose, A_List, %t_Macro1%
	GoSub, TabSel
	If (TimerPlay)
		GoSub, TimerOK
	Else
		GoSub, TestRun
}
Else
{
	If (!DontShowAdm && !A_IsAdmin)
	{
		Gui 26:+LastFoundExist
		IfWinExist
			GoSub, TipClose
		Gui, 26:-SysMenu +HwndTipScrID +owner1
		Gui, 26:Color, FFFFFF
		; Gui, 26:Font, s7
		Gui, 26:Add, Pic, y+20 Icon80, %ResDllPath%
		Gui, 26:Add, Text, yp x+10, %d_Lang058%`n
		Gui, 26:Add, Checkbox, -Wrap W300 vDontShowAdm R1, %d_Lang053%
		Gui, 26:Add, Button, -Wrap Default y+10 W90 H25 gTipClose2, %c_Lang020%
		Gui, 26:Show,, %AppName%
		WinWaitClose, ahk_id %TipScrID%
	}
	If (ShowBarOnStart)
		GoSub, ShowControls
	If (ShowTips)
		GoSub, ShowTips
	If (AutoUpdate)
		SetTimer, CheckUpdates, -1
}
HideWin := "", PlayHK := "", AutoPlay := "", TimerPlay := ""
FreeMemory()
return

;##### Toolbars #####

DefineToolbars:
	TB_Define(TbFile, hTbFile, hIL_Icons, DefaultBar.File, DefaultBar.FileOpt)
,	TB_Define(TbRecPlay, hTbRecPlay, hIL_Icons, DefaultBar.RecPlay, DefaultBar.RecPlayOpt)
,	TB_Define(TbSettings, hTbSettings, hIL_Icons, DefaultBar.Settings, DefaultBar.SetOpt)
,	TB_Define(TbCommand, hTbCommand, hIL_Icons, DefaultBar.Command, DefaultBar.CommandOpt)
,	TB_Define(TbEdit, hTbEdit, hIL_Icons, DefaultBar.Edit, DefaultBar.EditOpt)
,	TB_Define(TbOSC, hTbOSC, hIL_Icons, FixedBar.OSC, FixedBar.OSCOpt)
,	TB_Edit(TbOSC, "ProgBarToggle", ShowProgBar)
,	RbMain := New Rebar(hRbMain)
,	TB_Rebar(RbMain, 1, TbFile), TB_Rebar(RbMain, 2, TbRecPlay), TB_Rebar(RbMain, 3, TbSettings)
,	RbMain.InsertBand(hAutoKey, 0, "", 4, w_Lang006, 50, 0, "", "", 50)
,	RbMain.InsertBand(hTimesCh, 0, "FixedSize NoGripper", 11, w_Lang011 " (" t_Lang004 ")", 75, 0, "", "", 75)
,	TB_Rebar(RbMain, 5, TbCommand, "Break")
,	RbMain.InsertBand(hManKey, 0, "", 6, w_Lang007, 50, 0, "", "", 50)
,	RbMain.InsertBand(hAbortKey, 0, "", 7, w_Lang008, 60, 0, "", "", 50)
,	RbMain.InsertBand(hPauseKey, 0, "", 8, c_Lang003, 60, 0, "", "", 50)
,	TB_Rebar(RbMain, 9, TbEdit, "Break"), RbMain.SetMaxRows(3)
,	TBHwndAll := [TbFile, TbRecPlay, TbSettings, TbCommand, TbEdit, TbPrev, TbPrevF, TbOSC]
,	RBIndexTB := [1, 2, 3, 5, 9], RBIndexHK := [4, 6, 7, 8]
,	Default_MainLayout := RbMain.GetLayout()
If (MainLayout = "ERROR")
	return
Loop, 3
	RbMain.SetLayout(MainLayout)
RbMain.ShowBand(RbMain.IDToIndex(1), ShowBand1), RbMain.ShowBand(RbMain.IDToIndex(2), ShowBand2)
,	RbMain.ShowBand(RbMain.IDToIndex(3), ShowBand3), RbMain.ShowBand(RbMain.IDToIndex(4), ShowBand4)
,	RbMain.ShowBand(RbMain.IDToIndex(5), ShowBand5), RbMain.ShowBand(RbMain.IDToIndex(6), ShowBand6)
,	RbMain.ShowBand(RbMain.IDToIndex(7), ShowBand7), RbMain.ShowBand(RbMain.IDToIndex(8), ShowBand8)
,	RbMain.ShowBand(RbMain.IDToIndex(9), ShowBand9)
,	BtnsArray := [] 
If (FileLayout <> "ERROR")
	TB_Layout(TbFile, FileLayout, 1)
If (RecPlayLayout <> "ERROR")
	TB_Layout(TbRecPlay, RecPlayLayout, 2)
If (SettingsLayout <> "ERROR")
	TB_Layout(TbSettings, SettingsLayout, 3)
If (CommandLayout <> "ERROR")
	TB_Layout(TbCommand, CommandLayout, 5)
If (EditLayout <> "ERROR")
	TB_Layout(TbEdit, EditLayout, 9)
return

TbFile:
TbRecPlay:
TbCommand:
TbSettings:
TbEdit:
TbText:
TbOSC:
If (A_GuiEvent = "N")
{
	TbPtr := %A_ThisLabel%
	,	ErrorLevel := TbPtr.OnNotify(A_EventInfo, MX, MY, bLabel, ID)
	If (bLabel)
		ShowMenu(bLabel, MX, MY)
	If (ErrorLevel = 2) ; TBN_RESET
	{
		TB_Edit(TbFile, "Preview", ShowPrev), TB_Edit(TbSettings, "HideMainWin", HideMainWin)
	,	TB_Edit(TbSettings, "OnScCtrl", OnScCtrl), TB_Edit(TbSettings, "CheckHkOn", KeepHkOn)
	,	TB_Edit(TbSettings, "SetWin", (IfDirectContext = "None") ? 0 : 1)
	,	TB_Edit(TbSettings, "SetJoyButton", JoyHK), TB_Edit(TbOSC, "ProgBarToggle", ShowProgBar)
	}
}
return

RB_Notify:
If (A_GuiEvent = "N")
{
	EventCode := NumGet(A_EventInfo + (A_PtrSize * 2), 0, "Int")
	If (RbMain.OnNotify(A_EventInfo, tbMX, tbMY, BandID))
		ShowChevronMenu(RbMain, BandID, tbMX, tbMY)
	Else If (RbMacro.OnNotify(A_EventInfo, tbMX, tbMY, BandID))
		ShowChevronMenu(RbMacro, BandID, tbMX)
	If (EventCode = -831) ; RBN_HEIGHTCHANGE
	{
		RowsCount := RbMain.GetRowCount()
		MacroOffset := (RowsCount = 2) ? 90 : ((RowsCount = 1) ? 65 : 120)
		GuiControl, 1:Move, cRbMacro, % (RowsCount = 2) ? "y55" : (RowsCount = 1 ? "y30" : "y85")
		GoSub, GuiSize
	}
	If (EventCode = -835) ; RBN_BEGINDRAG
		OnMessage(WM_NOTIFY, ""), LV_Colors.Detach(ListID%A_List%)
	If (EventCode = -836) ; RBN_ENDDRAG
		GoSub, RowCheck
}
return

;##### Other controls #####

DefineControls:
GoSub, BuildMacroWin
GoSub, BuildPrevWin
GoSub, BuildMixedControls
GoSub, BuildOSCWin
	GuiGetSize(gWidth, gHeight), rHeight := gHeight-120, Ideal := TB_GetSize(TbEdit)
,	RbMacro := New Rebar(hRbMacro)
,	RbMacro.InsertBand(hMacroCh, 0, "NoGripper", 30, "", gWidth/2, 0, "", rHeight, 0, Ideal)
,	RbMacro.InsertBand(hPrevCh, 0, "", 31, "", gWidth/2, 0, "", rHeight, 0)
,	(MacroLayout = "ERROR") ? "" : RbMacro.SetLayout(MacroLayout)
,	!ShowPrev ? RbMacro.ModifyBand(2, "Style", "Hidden")
return

BuildMacroWin:
Gui, chMacro:+LastFound
Gui, chMacro:+hwndhMacroCh -Caption +Parent1
Gui, chMacro:Add, Tab2, Section Buttons 0x0008 -Wrap AltSubmit H22 hwndTabSel vA_List gTabSel, Macro1
Gui, chMacro:Add, ListView, AltSubmit Checked x+0 y+0 hwndListID1 vInputList1 gInputList NoSort LV0x10000, %w_Lang030%|%w_Lang031%|%w_Lang032%|%w_Lang033%|%w_Lang034%|%w_Lang035%|%w_Lang036%|%w_Lang037%|%w_Lang038%|%w_Lang039%
Gui, chMacro:Default
LV_SetImageList(hIL_Icons)
Loop, 10
	LV_ModifyCol(A_Index, Col_%A_Index%)
Gui, chMacro:Submit
GuiControl, chMacro:Focus, InputList%A_List%
Gui, 1:Default
return

BuildMixedControls:
Gui, chTimes:+LastFound
Gui, chTimes:+hwndhTimesCh -Caption +Parent1
Gui, chTimes:Add, Edit, x0 y0 W75 H25 Number vReptC
Gui, chTimes:Add, UpDown, vTimesG 0x80 Range0-999999999, 1
return

Preview:
If (FloatPrev)
	GoSub, PrevClose
Else
{
	TB_Edit(TbFile, "Preview", ShowPrev := !ShowPrev)
,	RbMacro.ModifyBand(2, "Style", "Hidden", False)
,	RbMacro.ModifyBand(2, "MinWidth", 0)
	GoSub, PrevRefresh
}
If (ShowPrev)
	Menu, ViewMenu, Check, %v_lang005%`t%_s%Ctrl+P
Else
	Menu, ViewMenu, UnCheck, %v_lang005%`t%_s%Ctrl+P
return

PrevDock:
Input
FloatPrev := !FloatPrev
If (FloatPrev)
{
	RbMacro.ModifyBand(2, "Style", "Hidden")
	Gui, 2:Show, W450 H600, %c_Lang072% - %AppName%
}
Else
{
	Gui, 2:Hide
	RbMacro.ModifyBand(2, "Style", "Hidden", False)
}
Tooltip
return

BuildPrevWin:
Gui, chPrev:+LastFound
Gui, chPrev:+hwndhPrevCh -Resize -Caption +Parent1
Gui, chPrev:Add, Custom, ClassToolbarWindow32 hwndhTbPrev 0x0800 0x0100 0x0040 0x0008
Gui, chPrev:Add, Custom, ClassScintilla x0 y34 hwndhSciPrev vLVPrev
Gui, chPrev:Show, W450 H600 Hide
	TB_Define(TbPrev, hTbPrev, hIL_Icons, FixedBar.Preview, FixedBar.PrevOpt)
,	sciPrev := new scintilla(hSciPrev)
,	sciPrev.SetMarginWidthN(0, 20)
,	sciPrev.SetWrapMode(False)
,	sciPrev.SetLexer(200)
,	sciPrev.StyleClearAll()
,	sciPrev.StyleSetFore(11, 0x0086B3)
,	sciPrev.StyleSetFore(12, 0x990000), sciPrev.StyleSetBold(12, True)
,	sciPrev.StyleSetFore(13, 0x009B4E)
,	sciPrev.StyleSetFore(16, 0x008080)
,	sciPrev.StyleSetFore(15, 0xDD1144)
,	sciPrev.SetKeywords(0, SyHi_Com)
,	sciPrev.SetKeywords(1, SyHi_Fun)
,	sciPrev.SetKeywords(2, SyHi_Keys)
,	sciPrev.SetKeywords(5, SyHi_BIVar)
,	sciPrev.SetKeywords(4, SyHi_Param)
,	sciPrev.SetText("", Preview)
,	sciPrev.SetReadOnly(True)

	Gui, 2:+Resize +hwndPrevID
	Gui, 2:Add, Custom, ClassToolbarWindow32 hwndhTbPrevF 0x0800 0x0100 0x0040 0x0008
	Gui, 2:Add, Custom, ClassScintilla x0 y34 hwndhSciPrevF vLVPrev
	Gui, 2:Add, StatusBar
	TB_Define(TbPrevF, hTbPrevF, hIL_Icons, FixedBar.Preview, FixedBar.PrevOpt)
,	tbPrevF.ModifyButtonInfo(1, "Text", t_Lang125),	tbPrevF.ModifyButtonInfo(1, "Image", 96)
,	sciPrevF := new scintilla(hSciPrevF)
,	sciPrevF.SetMarginWidthN(0, 20)
,	sciPrevF.SetWrapMode(False)
,	sciPrevF.SetLexer(200)
,	sciPrevF.StyleClearAll()
,	sciPrevF.StyleSetFore(11, 0x0086B3)
,	sciPrevF.StyleSetFore(12, 0x990000), sciPrevF.StyleSetBold(12, True)
,	sciPrevF.StyleSetFore(13, 0x009B4E)
,	sciPrevF.StyleSetFore(16, 0x008080)
,	sciPrevF.StyleSetFore(15, 0xDD1144)
,	sciPrevF.SetKeywords(0, SyHi_Com)
,	sciPrevF.SetKeywords(1, SyHi_Fun)
,	sciPrevF.SetKeywords(2, SyHi_Keys)
,	sciPrevF.SetKeywords(5, SyHi_BIVar)
,	sciPrevF.SetKeywords(4, SyHi_Param)
,	sciPrevF.SetText("", Preview)
,	sciPrevF.SetReadOnly(True)
	Gui, 2:Default
	SB_SetParts(150, 150)
,	SB_SetText("Macro" A_List ": " o_AutoKey[A_List], 1)
,	SB_SetText("Record Keys: " RecKey "/" RecNewKey, 2)
,	SB_SetText("CoordMode: " CoordMouse, 3)
,	TB_Edit(TbPrev, "TabIndent", TabIndent)
,	TB_Edit(TbPrevF, "TabIndent", TabIndent)
	Gui, chMacro:Default
return

OnTop:
TB_Edit(TbPrev, "OnTop", OnTop := !OnTop)
,	TB_Edit(TbPrevF, "OnTop", OnTop)
Gui, % (OnTop) ? "2:+AlwaysOnTop" : "2:-AlwaysOnTop"
return

PrevCopy:
Clipboard := sciPrev.GetText(sciPrev.getLength()+1)
return

PrevRefresh:
Preview := LV_Export(A_List)
sciPrev.SetReadOnly(False), sciPrev.ClearAll(), sciPrev.SetText("", Preview)
,	sciPrev.ScrollToEnd(), sciPrev.SetReadOnly(True)
,	sciPrevF.SetReadOnly(False), sciPrevF.ClearAll(), sciPrevF.SetText("", Preview)
,	sciPrevF.ScrollToEnd(), sciPrevF.SetReadOnly(True)
Gui, 2:Default
SB_SetText("Macro" A_List ": " o_AutoKey[A_List], 1)
SB_SetText("Record Keys: " RecKey "/" RecNewKey, 2)
SB_SetText("CoordMode: " CoordMouse, 3)
Gui, chMacro:Default
return

TabIndent:
AutoRefresh:
TB_Edit(TbPrev, A_ThisLabel, %A_ThisLabel% := !%A_ThisLabel%)
,	TB_Edit(TbPrevF, A_ThisLabel, %A_ThisLabel%)
GoSub, PrevRefresh
return

PrevClose:
2GuiClose:
2GuiEscape:
TB_Edit(TbFile, "Preview", ShowPrev := 0), FloatPrev := 0
Menu, ViewMenu, UnCheck, %v_lang002%
Gui, 2:Hide
return

EditScript:
Preview := LV_Export(A_List)
If (Preview = "")
	return
ExFileName := "PMC_" A_Now ".ahk"
FileAppend, %Preview%, %A_Temp%\%ExFileName%, UTF-8
Run, %DefaultEditor% %A_Temp%\%ExFileName%, %A_Temp%
return

;##### Capture Keys #####

MainLoop:
If !Capt
	SetTimer, MainLoop, Off
If !ListFocus
	SetTimer, MainLoop, Off
Input, sKey, M L1, %VirtualKeys%
If ErrorLevel = NewInput
	return
sKey := (ErrorLevel <> "Max") ? SubStr(ErrorLevel, 8) : sKey
If sKey in %A_Space%,`n,`t
	return
If (Asc(sKey) < 192) && ((sKey <> "/") && (sKey <> ".") && (!GetKeyState(sKey, "P")))
	return
If ((GetKeyState("RAlt", "P")) && !(HoldRAlt))
	sKey := "RAlt", HoldRAlt := 1
If (Asc(sKey) < 192) && ((CaptKDn = 1) || InStr(sKey, "Control") || InStr(sKey, "Shift")
|| InStr(sKey, "Alt") || InStr(sKey, "Win"))
{
	ScK := GetKeySC(sKey)
	If Hold%ScK%
		return
	Hotkey, If
	#If
	If (sKey = "/")
		HotKey, ~*VKC1SC730 Up, RecKeyUp, On
	Else
		HotKey, ~*%sKey% Up, RecKeyUp, On
	If (sKey = ".")
		HotKey, ~*VKC2SC7E0 Up, RecKeyUp, On
	Hotkey, If
	#If
	Hold%ScK% := 1
	sKey .= " Down"
}
tKey := sKey, sKey := "{" sKey "}"
If !Capt
	SetTimer, MainLoop, Off
If ListFocus
	GoSub, InsertRow
return

;##### Recording: #####

Record:
Pause, Off
Tooltip
Gui, 1:+OwnDialogs
Gui, 1:Submit, NoHide
ActivateHotKeys(1, 0, 0, "", 1)
If (HideMainWin)
	GoSub, ShowHide
Else
	WinMinimize, ahk_id %PMCWinID%
If !DontShowRec
{
	Gui 26:+LastFoundExist
	IfWinExist
		GoSub, TipClose
	Gui, 26:-SysMenu +HwndTipScrID
	Gui, 26:Color, FFFFFF
	; Gui, 26:Font, s7
	Gui, 26:Add, Pic, y+20 Icon91, %ResDllPath%
	Gui, 26:Add, Text, yp x+10, %d_Lang052%`n`n- %RecKey% %d_Lang026%`n- %RecNewKey% %d_Lang030%`n`n%d_Lang043%`n
	Gui, 26:Add, Checkbox, -Wrap W300 vDontShowRec R1, %d_Lang053%
	Gui, 26:Add, Button, -Wrap Default y+10 W90 H25 gTipClose, %c_Lang020%
	Gui, 26:Show,, %AppName%
}
If (ShowStep = 1)
	Traytip, %AppName%, %RecKey% %d_Lang026%.`n%RecNewKey% %d_Lang030%.,,1
If (OnScCtrl)
	GoSub, ShowControls
return

RemoveToolTip:
ToolTip
return

RecStartNew:
ActivateHotkeys(1)
Pause, Off
GoSub, RecStop
If ClearNewList
	LV_Delete()
Else
{
	GoSub, RowCheck
	GoSub, b_Start
	GoSub, TabPlus
}
GoSub, RecStart
return

RecStart:
ActivateHotkeys(1)
Gui, chMacro:Default
Pause, Off
If (Record := !Record)
{
	p_Title := "", p_Class := ""
	Hotkey, ~*WheelUp, MWUp, On
	Hotkey, ~*WheelDown, MWDn, On
	mScUp := 0, mScDn := 0
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos, xPos, yPos
	LastPos := xPos "/" yPos
,	LastTime := A_TickCount
	SetTimer, MouseRecord, 0
	If ((WClass = 1) || (WTitle = 1))
		WindowRecord(A_List, DelayW)
	If Strokes = 1
		SetTimer, KeyboardRecord, -100
	Tooltip
	If (ShowStep = 1)
		Traytip, %AppName%, Macro%A_List%: %d_Lang028% %RecKey% %d_Lang029%.,,1
	Menu, Tray, Icon, %ResDllPath%, 55
	Menu, Tray, Default, %w_Lang008%
	ToggleButtonIcon(OSRec, RecStopIcon)
	return
}
Else
{
	GoSub, RecStop
	GoSub, b_Start
	GoSub, RowCheck
	GoSub, PlayActive
	ActivateHotKeys(1)
	If ShowStep = 1
		Traytip, %AppName%, % d_Lang027
		. ".`nMacro" A_List ": " o_AutoKey[A_List],,1
	ToggleButtonIcon(OSRec, RecordIcon)
	return
}
return

RecStop:
Gui, chMacro:Default
Pause, Off
Record := 0
Input
Tooltip
Traytip
Hotkey, ~*WheelUp, MWUp, off
Hotkey, ~*WheelDown, MWDn, off
SetTimer, MouseRecord, off
If (!(WinActive("ahk_id" PMCWinID)) && (KeepHkOn = 1))
	GoSub, KeepHkOn
Menu, Tray, Icon, %DefaultIcon%, 1
Try Menu, Tray, Default, %w_Lang005%
ToggleButtonIcon(OSRec, RecordIcon)
return

KeyboardRecord:
Loop
{
	If Record = 0
		break
	Input, sKey, V M L1, %VirtualKeys%
	If ErrorLevel = NewInput
		continue
	sKey := (ErrorLevel <> "Max") ? SubStr(ErrorLevel, 8) : sKey
	If sKey in %A_Space%,`n,`t
		continue
	GoSub, ChReplace
	If (Asc(sKey) < 192) && ((sKey <> "/") && (sKey <> ".") && (sKey <> "?")&& (!GetKeyState(sKey, "P")))
		continue
	If ((GetKeyState("RAlt", "P")) && !(HoldRAlt))
		sKey := "RAlt", HoldRAlt := 1
	If (Asc(sKey) < 192) && ((CaptKDn = 1) || InStr(sKey, "Control") || InStr(sKey, "Shift")
	|| InStr(sKey, "Alt") || InStr(sKey, "Win"))
	{
		ScK := GetKeySC(sKey)
		If Hold%ScK%
			continue
		Hotkey, If
		#If
		If (sKey = "/")
			HotKey, ~*VKC1SC730 Up, RecKeyUp, On
		Else
			HotKey, ~*%sKey% Up, RecKeyUp, On
		If (sKey = ".")
			HotKey, ~*VKC2SC7E0 Up, RecKeyUp, On
		Hotkey, If
		#If
		Hold%ScK% := 1
		sKey .= " Down"
	}
	tKey := sKey, sKey := "{" sKey "}"
	If Record = 0
		break
	GoSub, InsertRow
}
return

InsertRow:
IfWinActive, ahk_id %PMCOSC%
	return
Type := cType1, Target := "", Window := ""
If Record = 1
{
	If RecKeybdCtrl = 1
	{
		If ((InStr(sKey, "Control")) || (InStr(sKey, "Shift"))
		|| (InStr(sKey, "Alt")))
			Goto, KeyInsert
		ControlGetFocus, ActiveCtrl, A
		If (ActiveCtrl <> "")
		{
			Type := cType2, Target := ActiveCtrl
			WinGetTitle, c_Title, A
			WinGetClass, c_Class, A
			If WTitle = 1
				Window := c_Title
			If WClass = 1
				Window := Window " ahk_class " c_Class
			If ((WTitle = 0) && (WClass = 0))
				Window = A
		}
	}
}
KeyInsert:
Gui, chMacro:Default
If Record = 1
{
	If TimedI = 1
	{
		If (Interval := TimeRecord())
		{
			If Interval > %TDelay%
			GoSub, SleepInput
		}
		InputDelay := 0, WinDelay = 0
	}
	Else
		InputDelay := DelayG, WinDelay := DelayW
	If ((WClass = 1) || (WTitle = 1))
		WindowRecord(A_List, WinDelay)
}
Else
	InputDelay := DelayG
RowSelection := LV_GetCount("Selected")
If (Record || RowSelection = 0)
{
	LV_Add("Check", ListCount%A_List%+1, tKey, sKey, 1, InputDelay, Type, Target, Window)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, tKey, sKey, 1, DelayG, Type, Target, Window)
		RowNumber++
	}
	LV_Modify(RowNumber, "Vis")
}
If !Record
{
	GoSub, b_Start
	GoSub, RowCheck
}
return

MouseRecord:
If (Moves = 1) && (MouseMove := MoveCheck())
{
	Action := Action2, Details := MouseMove ", 0"
,	Type := cType3, Target := "", Window := ""
	GoSub, MouseAdd
}
If !GetKeyState(RelKey, ToggleMode)
	RelHold := 0, Relative := ""
If MScroll = 1
{
	If (mScUp > 0 && A_TimeIdle > 50)
	{
		If RecMouseCtrl = 1
			Details := ClickOn(xPos, yPos, "WheelUp", Up)
		Else
			Details := "WheelUp, " Up
		Action := Action5, Type := cType3
		GoSub, MouseInput
		mScUp := 0
	}
	If (mScDn > 0 && A_TimeIdle > 50)
	{
		If RecMouseCtrl = 1
			Details := ClickOn(xPos, yPos, "WheelDown", Dn)
		Else
			Details := "WheelDown, " Dn
		Action := Action6, Type := cType3
		GoSub, MouseInput
		mScDn := 0
	}
}
return

#If ((Record = 1) && (Mouse = 1) && !(A_IsPaused))
*~LButton::
	Critical
	; Send, {Blind}{LButton Down}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos,,, id, control
	WinGetClass, m_Class, ahk_id %id%
	If ((InStr(m_Class, "#32") <> 1) && (m_Class <> "Button")
	&& (id <> PMCWinID) && (id <> PrevID) && (id <> PMCOSC))
		WinActivate, ahk_id %id%
	MouseGetPos, xPd, yPd
	Button := "Left"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Down" : "Down")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~LButton Up::
	Critical
	; Send, {Blind}{LButton Up}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos, xPd, yPd
	Button := "Left"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Up" : "Up")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~RButton::
	Critical
	; Send, {Blind}{RButton Down}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos,,, id, control
	WinGetClass, m_Class, ahk_id %id%
	If ((InStr(m_Class, "#32") <> 1) && (m_Class <> "Button")
	&& (id <> PMCWinID) && (id <> PrevID) && (id <> PMCOSC))
		WinActivate, ahk_id %id%
	MouseGetPos, xPd, yPd
	Button := "Right"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Down" : "Down")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~RButton Up::
	Critical
	; Send, {Blind}{RButton Up}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos, xPd, yPd
	Button := "Right"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Up" : "Up")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~MButton::
	Critical
	; Send, {Blind}{MButton Down}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos,,, id, control
	WinGetClass, m_Class, ahk_id %id%
	If ((InStr(m_Class, "#32") <> 1) && (m_Class <> "Button")
	&& (id <> PMCWinID) && (id <> PrevID) && (id <> PMCOSC))
		WinActivate, ahk_id %id%
	MouseGetPos, xPd, yPd
	Button := "Middle"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Down" : "Down")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~MButton Up::
	Critical
	; Send, {Blind}{MButton Up}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos, xPd, yPd
	Button := "Middle"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Up" : "Up")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~XButton1::
	Critical
	; Send, {Blind}{XButton1 Down}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos,,, id, control
	WinGetClass, m_Class, ahk_id %id%
	If ((InStr(m_Class, "#32") <> 1) && (m_Class <> "Button")
	&& (id <> PMCWinID) && (id <> PrevID) && (id <> PMCOSC))
		WinActivate, ahk_id %id%
	MouseGetPos, xPd, yPd
	Button := "X1"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Down" : "Down")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~XButton1 Up::
	Critical
	; Send, {Blind}{XButton1 Up}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos, xPd, yPd
	Button := "X1"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Up" : "Up")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~XButton2::
	Critical
	; Send, {Blind}{XButton2 Down}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos,,, id, control
	WinGetClass, m_Class, ahk_id %id%
	If ((InStr(m_Class, "#32") <> 1) && (m_Class <> "Button")
	&& (id <> PMCWinID) && (id <> PrevID) && (id <> PMCOSC))
		WinActivate, ahk_id %id%
	MouseGetPos, xPd, yPd
	Button := "X2"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Down" : "Down")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~XButton2 Up::
	Critical
	; Send, {Blind}{XButton2 Up}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos, xPd, yPd
	Button := "X2"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Up" : "Up")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
#If

MWUp:
mScUp++
return

MWDn:
mScDn++
return

MouseInput:
If (id = PMCOSC)
	return
Target := "", Window := ""
If ((RecMouseCtrl = 1) && (InStr(m_Class, "#32") <> 1))
{
	If ((InStr(Details, "rel")) || (InStr(Details, "click")))
		Goto, MouseAdd
	CoordMode, Mouse, %CoordMouse%
	If (control <> "")
	{
		ControlGetPos, x, y,,, %control%, A
		xcpos := Controlpos(xPd, x), ycpos := Controlpos(yPd, y)
	,	Details := RegExReplace(Details, "\d+, \d+ ")
		If (xcpos <> "")
			Details .= " x" xcpos " y" ycpos " NA"
		Else
			Details .= " NA"
		Target := control
	}
	Else
	{
		Details := RegExReplace(Details, "\d+, \d+ ")
	,	Details .= " NA"
	,	Target := "x" xPd " y" yPd
	}
	Action := Button " " Action1, Type := cType4
	WinGetTitle, c_Title, A
	WinGetClass, c_Class, A
	If WTitle = 1
		Window := c_Title
	If WClass = 1
		Window := Window " ahk_class " c_Class
	If ((WTitle = 0) && (WClass = 0))
		Window := "A"
}
MouseAdd:
Gui, chMacro:Default
If TimedI = 1
{
	If (Interval := TimeRecord())
	{
		If Interval > %TDelay%
		GoSub, SleepInput
	}
	RecDelay := 0, WinDelay := 0
}
Else
	RecDelay := DelayM, WinDelay := DelayW
If (!InStr(Details, "Up") && (Action <> Action2))
{
	If ((WClass = 1) || (WTitle = 1))
		WindowRecord(A_List, WinDelay)
}
LV_Add("Check", ListCount%A_List%+1, Action, Details, 1, RecDelay, Type, Target, Window)
return

SleepInput:
LV_Add("Check", ListCount%A_List%+1, "[Pause]", "", 1, Interval, cType5)
return

;##### Subroutines: Menus & Buttons #####

New:
Gui, 1:+OwnDialogs
If ((ListCount > 0) && (SavePrompt))
{
	MsgBox, 35, %d_Lang005%, %d_Lang002%`n`"%CurrentFileName%`"
	IfMsgBox, Yes
		GoSub, Save
	IfMsgBox, Cancel
		return
}
Input
GoSub, DelLists
GuiControl, chMacro:, A_List, |Macro1
Loop, %TabCount%
	HistoryMacro%A_Index% := ""
HistoryMacro1 := new LV_Rows()
TabCount := 1
Gui, 1:Submit, NoHide
Gui, chMacro:Submit, NoHide
If (KeepDefKeys = 1)
{
	AutoKey := DefAutoKey, ManKey := DefManKey
	GoSub, ObjCreate
}
GoSub, LoadData
GoSub, KeepHkOn
GuiControl, 1:, Capt, 0
GuiControl, 1:, TimesG, 1
CurrentFileName = 
Gui, 1:Show, % ((WinExist("ahk_id" PMCWinID)) ? "" : "Hide"), %AppName% v%CurrentVersion%
GuiControl, chMacro:Focus, InputList%A_List%
GoSub, b_Start
FreeMemory(), OnFinishCode := 1, TB_Edit(TbSettings, "OnFinish", 0)
SetWorkingDir %A_ScriptDir%
GoSub, SetFinishButtom
GoSub, RecentFiles
return

GuiDropFiles:
Gui, chMacro:Default
Gui, chMacro:Submit, NoHide
Gui, 1:+OwnDialogs
Gui, 1:Submit, NoHide
GoSub, SaveData
If ((ListCount > 0) && (SavePrompt))
{
	MsgBox, 35, %d_Lang005%, %d_Lang002%`n`"%CurrentFileName%`"
	IfMsgBox, Yes
	{
		GoSub, Save
		IfMsgBox, Cancel
			return
	}
	IfMsgBox, Cancel
		return
}
PMC.Import(A_GuiEvent)
CurrentFileName := LoadedFileName
GoSub, FileRead
GoSub, RecentFiles
return

Open:
Gui, 1:+OwnDialogs
If ((ListCount > 0) && (SavePrompt))
{
	MsgBox, 35, %d_Lang005%, %d_Lang002%`n`"%CurrentFileName%`"
	IfMsgBox, Yes
		GoSub, Save
	IfMsgBox, Cancel
		return
}
Input
FileSelectFile, SelectedFileName, M3,, %d_Lang001%, %d_Lang004% (*.pmc)
FreeMemory()
If !SelectedFileName
	return
Loop, Parse, SelectedFileName, `n
{
	If A_Index = 1
		FilePath := RTrim(A_LoopField, "\") "\"
	Else
		Files .= FilePath . A_LoopField "`n"
}
Files := RTrim(Files, "`n")
PMC.Import(Files)
CurrentFileName := LoadedFileName, Files := ""
GoSub, b_Start
GoSub, FileRead
GoSub, RecentFiles
return

FileRead:
GoSub, b_Start
Gui, chMacro:Default
Gui, chMacro:Listview, InputList%A_List%
HistoryMacro1 := new LV_Rows()
HistoryMacro1.Add()
GuiControl, 1:, Capt, 0
Gui, 1:Show, % ((WinExist("ahk_id" PMCWinID)) ? "" : "Hide"), %AppName% v%CurrentVersion% %CurrentFileName%
SplitPath, CurrentFileName,, wDir
SetWorkingDir %wDir%
GoSub, RowCheck
GoSub, LoadData
GoSub, PrevRefresh
Gui, chMacro:Default
Gui, chMacro:Listview, InputList%A_List%
GuiControl, chMacro:Focus, InputList%A_List%
SavePrompt := False
return

Import:
Gui, chMacro:Default
Gui, 1:+OwnDialogs
FileSelectFile, SelectedFileName, M3,, %d_Lang001%, %d_Lang004% (*.pmc)
FreeMemory()
If !SelectedFileName
	return
Files := ""
Loop, Parse, SelectedFileName, `n
{
	If A_Index = 1
		FilePath := A_LoopField "\"
	Else
		Files .= FilePath . A_LoopField "`n"
}
Files := RTrim(Files, "`n")
PMC.Import(Files, "`n", 0)
Files := ""
GuiControl, chMacro:Choose, A_List, %TabCount%
Gui, chMacro:Submit, NoHide
Gui, 1:Submit, NoHide
GoSub, LoadData
GoSub, RowCheck
GuiControl, chMacro:Focus, InputList%A_List%
GoSub, PrevRefresh
GoSub, b_Start
GoSub, RecentFiles
GoSub, chMacroGuiSize
return

SaveAs:
Input
GoSub, SelectFile
GoSub, Save
return

SelectFile:
Gui 1:+OwnDialogs
FileSelectFile, SelectedFileName, S16, %CurrentFileName%, %d_Lang005%, %d_Lang004% (*.pmc)
FreeMemory()
If SelectedFileName = 
	Exit
SplitPath, SelectedFileName,, wDir, ext
If (ext <> "pmc")
	SelectedFileName .= ".pmc"
CurrentFileName := SelectedFileName
GoSub, RecentFiles
return

Save:
Input
GoSub, SaveData
If CurrentFileName = 
	GoSub, SelectFile
IfExist %CurrentFileName%
{
    FileDelete %CurrentFileName%
    If ErrorLevel
    {
        MsgBox, 16, %d_Lang007%, %d_Lang006% "%CurrentFileName%".
        return
    }
}
Gui, chMacro:Default
Loop, %TabCount%
{
	If (ListCount%A_Index% = 0)
		continue
	PMCSet := "[PMC Code]|" o_AutoKey[A_Index]
	. "|" o_ManKey[A_Index] "|" o_TimesG[A_Index]
	. "|" CoordMouse "|" OnFinishCode "`n"
	LV_Data := PMCSet . PMC.LVGet("InputList" A_Index).Text . "`n"
	FileAppend, %LV_Data%, %CurrentFileName%
}
Gui, 1:Show, % ((WinExist("ahk_id" PMCWinID)) ? "NA" : "Hide"), %AppName% v%CurrentVersion% %CurrentFileName%
SplitPath, CurrentFileName,, wDir
SetWorkingDir %wDir%
SavePrompt := False
GoSub, RecentFiles
return

SaveCurrentList:
Input
ActiveFile := CurrentFileName
GoSub, SaveData
GoSub, SelectFile
ThisListFile := CurrentFileName, CurrentFileName := ActiveFile
IfExist %ThisListFile%
{
    FileDelete %ThisListFile%
    If ErrorLevel
    {
        MsgBox, 16, %d_Lang007%, %d_Lang006% "%ThisListFile%".
        return
    }
}
PMCSet := "[PMC Code]|" o_AutoKey[A_List]
. "|" o_ManKey[A_List] "|" o_TimesG[A_List]
. "|" CoordMouse "`n"
LV_Data := PMCSet . PMC.LVGet("InputList" A_List).Text . "`n"
FileAppend, %LV_Data%, %ThisListFile%
GoSub, RecentFiles
return

RecentFiles:
If (PmcRecentFiles <> "")
{
	Loop, Parse, PmcRecentFiles, `n
		Menu, RecentMenu, Delete, %A_Index%: %A_LoopField%
}
PmcRecentFiles := ""
Loop, %RecentFolder%\*.pmc.lnk
{
	FileGetShortcut, %A_LoopFileFullPath%, OutTarget
	PmcRecentFiles .= A_LoopFileTimeModified "|" OutTarget "`n"
}
Sort, PmcRecentFiles, R
PmcRecentFiles := Trim(RegExReplace(PmcRecentFiles, "`am)^.*\|"), "`n")
Loop, Parse, PmcRecentFiles, `n
	Menu, RecentMenu, Add, %A_Index%: %A_LoopField%, OpenRecent
If (PmcRecentFiles = "")
{
	Menu, RecentMenu, Add, 1: %f_Lang010%, OpenRecent
	Menu, RecentMenu, Disable, 1: %f_Lang010%
	PmcRecentFiles := f_Lang010
}
return

OpenRecent:
Gui, 1:+OwnDialogs
If ((ListCount > 0) && (SavePrompt))
{
	MsgBox, 35, %d_Lang005%, %d_Lang002%`n`"%CurrentFileName%`"
	IfMsgBox, Yes
		GoSub, Save
	IfMsgBox, Cancel
		return
}
Input
PMC.Import(RegExReplace(A_ThisMenuItem, "^\d+:\s"))
CurrentFileName := LoadedFileName, Files := ""
GoSub, b_Start
GoSub, FileRead
GoSub, RowCheck
return

Export:
Input
Gui, 1:Submit, NoHide
GoSub, SaveData
SplitPath, CurrentFileName, name, dir, ext, name_no_ext, drive
If !A_AhkPath
	Exe_Exp := 0
UserVarsList := User_Vars.Get()
Gui, 14:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 14:Default
Gui, 1:+Disabled
; Macros
Gui, 14:Add, GroupBox, W415 H150, %t_Lang002%:
Gui, 14:Add, ListView, Section ys+20 xs+10 AltSubmit Checked W395 r4 vExpList gExpEdit -Multi NoSort -ReadOnly, Macro|Hotkey|Loop|Hotstring?|BlockMouse?
Gui, 14:Add, Button, -Wrap Section xs W75 H23 gCheckAll, %t_Lang007%
Gui, 14:Add, Button, -Wrap yp x+5 W75 H23 gUnCheckAll, %t_Lang008%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_AbortKey% yp+5 x+10 W65 vEx_AbortKey gEx_Checks R1, %w_Lang008%:
Gui, 14:Add, Edit, yp-5 x+0 W45 vAbortKey, %AbortKey%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_PauseKey% yp+5 x+10 W65 vEx_PauseKey R1, %t_Lang081%:
Gui, 14:Add, Edit, yp-5 x+0 W45 vPauseKey, %PauseKey%
; Context
Gui, 14:Add, GroupBox, Section xm W415 H80
Gui, 14:Add, Checkbox, -Wrap Section ys xs vEx_IfDir gEx_Checks R1, %t_Lang009%:
Gui, 14:Add, DDL, xs+10 W105 vEx_IfDirType Disabled, #IfWinActive||#IfWinNotActive|#IfWinExist|#IfNotWinExist
Gui, 14:Add, DDL, yp x+225 W65 vIdent Disabled, Title||Class|Process|ID|PID
Gui, 14:Add, Edit, xs+10 W365 vTitle Disabled
Gui, 14:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin Disabled, ...
; Options
Gui, 14:Add, GroupBox, Section xm W415 H260, %w_Lang003%:
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SM% ys+20 xs+10 W110 vEx_SM R1, SendMode
Gui, 14:Add, DDL, yp-3 xp+115 vSM w75, Input||Play|Event|InputThenPlay|
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SI% y+5 xs+10 W110 vEx_SI R1, #SingleInstance
Gui, 14:Add, DDL, yp-3 xp+115 vSI w75, Force|Ignore||Off|
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_ST% y+5 xs+10 W110 vEx_ST R1, SetTitleMatchMode
Gui, 14:Add, DDL, yp-3 xp+115 vST w75, 1|2||3|RegEx|
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_DH% y+5 xs+10 W195 vEx_DH R1, DetectHiddenWindows
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_AF% y+8 W195 vEx_AF R1, #WinActivateForce
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_PT% y+8 W195 vEx_PT R1, #Persistent
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_HK% y+8 W195 vEx_HK R1, #UseHook
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SK% ys+15 x+5 W165 vEx_SK R1, SetKeyDelay
Gui, 14:Add, Edit, yp-3 xp+165 W30 vSK, %SK%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_MD% y+5 xs+210 W165 vEx_MD R1, SetMouseDelay
Gui, 14:Add, Edit, yp-3 xp+165 W30 vMD, %MD%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SC% y+5 xs+210 W165 vEx_SC R1, SetControlDelay
Gui, 14:Add, Edit, yp-3 xp+165 W30 vSC, %SC%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SW% y+5 xs+210 W165 vEx_SW R1, SetWinDelay
Gui, 14:Add, Edit, yp-3 xp+165 W30 vSW, %SW%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SB% y+5 xs+210 W165 vEx_SB R1, SetBatchLines
Gui, 14:Add, Edit, yp-3 xp+165 W30 vSB, %SB%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_MT% y+5 xs+210 W165 vEx_MT R1, #MaxThreadsPerHotkey
Gui, 14:Add, Edit, yp-3 xp+165 W30 vMT, %MT%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_NT% y+5 xs+210 W165 vEx_NT R1, #NoTrayIcon
Gui, 14:Add, Text, y+10 xs+10 W395 H2 0x10
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_IN% y+10 xs+10 W195 vEx_IN R1, `#`Include (%t_Lang087%)
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_UV% yp x+5 W165 vEx_UV gEx_Checks R1, Global Variables
Gui, 14:Add, Button, yp-5 xp+170 H25 W25 hwndEx_EdVars vEx_EdVars gVarsTree Disabled
	ILButton(Ex_EdVars, ResDllPath ":" 74)
Gui, 14:Add, Text, y+5 xs+10 W80, %t_Lang101%:
Gui, 14:Add, Text, yp xs+90 W50, %t_Lang102%
Gui, 14:Add, Slider, yp-10 xs+140 H35 W150 Center TickInterval Range-5-5 vEx_Speed, %Ex_Speed%
Gui, 14:Add, Text, yp+10 xs+320 W50, %t_Lang103%
Gui, 14:Add, Text, y+15 xs+10 W95, COM Objects:
Gui, 14:Add, Radio, -Wrap Checked%ComCr% yp xp+100 W95 vComCr R1, ComObjCreate
Gui, 14:Add, Radio, -Wrap Checked%ComAc% yp xp+100 W95 vComAc R1, ComObjActive
; Export
Gui, 14:Add, GroupBox, Section xm W415 H100
Gui, 14:Add, Text, Section ys+15 xs+10, %t_Lang010%:
Gui, 14:Add, Edit, vExpFile xs W365 R1 -Multi, %dir%\%name_no_ext%.ahk
Gui, 14:Add, Button, -Wrap W30 H23 yp-1 x+0 gExpSearch, ...
Gui, 14:Add, Checkbox, -Wrap Checked%TabIndent% xs W200 vTabIndent R1, %t_Lang011%
Gui, 14:Add, Checkbox, -Wrap Checked%IncPmc% yp xp+200 W145 vIncPmc R1, %t_Lang012%
Gui, 14:Add, Checkbox, -Wrap Checked%Send_Loop% y+5 xs W200 vSend_Loop R1, %t_Lang013%
Gui, 14:Add, Checkbox, -Wrap Checked%Exe_Exp% yp xp+200 W145 vExe_Exp gExe_Exp R1,%t_Lang088% 
Gui, 14:Add, Button, -Wrap Section Default xm W75 H23 gExpButton, %w_Lang001%
Gui, 14:Add, Button, -Wrap ys W75 H23 gExpClose, %c_Lang022%
Gui, 14:Add, Progress, ys W280 H20 vExpProgress
GuiControl, 14:ChooseString, SM, %SM%
GuiControl, 14:ChooseString, SI, %SI%
GuiControl, 14:ChooseString, ST, %ST%
GuiControl, 14:ChooseString, IN, %IN%
GoSub, Ex_Checks
If (IfDirectContext <> "None")
{
	GuiControl, 14:, Ex_IfDir, 1
	GuiControl, 14:ChooseString, Ex_IfDirType, #IfWin%IfDirectContext%
	GuiControl, 14:, Title, %IfDirectWindow%
	GoSub, Ex_Checks
}
LV_Delete()
Loop, %TabCount%
	LV_Add("Check", A_Index, o_AutoKey[A_Index], o_TimesG[A_Index], 0, (BckIt%A_Index% ? 1 : 0))
LV_ModifyCol(1, 50)		; Macros
LV_ModifyCol(2, 120)	; Hotkeys
LV_ModifyCol(3, 60)		; Loop
LV_ModifyCol(4, 60)		; Hotstrings
LV_ModifyCol(5, 80)		; Block
LV_Modify(0, "Check")
If CurrentFileName = 
	GuiControl, 14:, ExpFile, %A_MyDocuments%\MyScript.ahk
Gui, 14:Show,, %t_Lang001%
Tooltip
return

ExpEdit:
If A_GuiEvent = D
	LV_Rows.Drag()
If A_GuiEvent <> DoubleClick
	return
If (LV_GetCount("Selected") = 0)
	return
RowNumber := LV_GetNext()
LV_GetText(Ex_AutoKey, RowNumber, 2)
LV_GetText(Ex_TimesX, RowNumber, 3)
LV_GetText(Ex_Hotstring, RowNumber, 4)
LV_GetText(Ex_BM, RowNumber, 5)
Gui, 13:+owner14 +ToolWindow
Gui, 14:Default
Gui, 14:+Disabled
Gui, 13:Add, GroupBox, Section xm W270 H95
Gui, 13:Add, Edit, ys+20 xs+10 W140 vEx_AutoKey, %Ex_AutoKey%
Gui, 13:Add, Checkbox, -Wrap Checked%Ex_Hotstring% ys+25 xp+150 W100 vEx_Hotstring gEx_Hotstring R1, %t_Lang005%
Gui, 13:Add, Text, Section ys+50 xs+10, %t_Lang003%:
Gui, 13:Add, Edit, yp-3 xp+40 Limit Number W100 R1 vEx_TE, %Ex_TE%
Gui, 13:Add, UpDown, 0x80 Range0-999999999 vEx_TimesX, %Ex_TimesX%
Gui, 13:Add, Text,, %t_Lang004%
Gui, 13:Add, Checkbox, -Wrap Checked%Ex_BM% yp-22 xp+110 W100 vEx_BM R1, %t_Lang006%
Gui, 13:Show,, %w_Lang019%
return

13GuiClose:
13GuiEscape:
Gui, 13:Submit, NoHide
Gui, 14:-Disabled
Gui, 13:Destroy
Gui, 14:Default
Ex_Hotstring := InStr(Ex_AutoKey, "::")=1 ? 1 : 0
LV_Modify(RowNumber, "Col2", Ex_AutoKey, Ex_TimesX, Ex_Hotstring, Ex_BM)
return

VarsTree:
Gui, 29:+owner14 +ToolWindow
Gui, 14:+Disabled
Gui, 29:Add, TreeView, Checked H500 W300 vIniTV -ReadOnly
User_Vars.Tree(29)
Gui, 29:Add, Button, -Wrap Section xs W75 H23 gCheckAll, %t_Lang007%
Gui, 29:Add, Button, -Wrap yp x+5 W75 H23 gUnCheckAll, %t_Lang008%
Gui, 29:Show,, %t_Lang096%
return

29GuiClose:
29GuiEscape:
Gui, 29:Submit, NoHide
UserVarsList := "", ItemID := 0
Loop
{
	ItemID := TV_GetNext(ItemID, "Checked")
	If !(ItemID)
		break
	TV_GetText(ItemText, ItemID)
	If (TV_Get(TV_GetParent(ItemID), "Checked"))
		UserVarsList .= ItemText "`n"
}
Gui, 14:-Disabled
Gui, 29:Destroy
Gui, 14:Default
return

CheckAll:
ItemID := 0
LV_Modify(0, "Check")
Loop
{
	ItemID := TV_GetNext(ItemID, "Full")
	If !(ItemID)
		break
	TV_Modify(ItemID, "Check")
}
return

UnCheckAll:
LV_Modify(0, "-Check")
ItemID := 0
Loop
{
	ItemID := TV_GetNext(ItemID, "Checked")
	If !(ItemID)
		break
	TV_Modify(ItemID, "-Check")
}
return

Ex_Checks:
Gui, 14:Submit, NoHide
; GuiControl, 14:Enable%Ex_AbortKey%, PauseKey
GuiControl, 14:Enable%Ex_IfDir%, Ex_IfDirType
GuiControl, 14:Enable%Ex_IfDir%, Ident
GuiControl, 14:Enable%Ex_IfDir%, Title
GuiControl, 14:Enable%Ex_IfDir%, GetWin
GuiControl, 14:Enable%Ex_UV%, Ex_EdVars
return

Ex_Hotstring:
Gui, 14:Submit, NoHide
If Ex_Hotstring = 1
	GuiControl, 13:, Ex_AutoKey, ::%Ex_AutoKey%
Else
	GuiControl, 13:, Ex_AutoKey, % RegExReplace(Ex_AutoKey, ".*:")
return

ExpClose:
14GuiClose:
14GuiEscape:
Gui, 14:Submit, NoHide
Loop, %TabCount%
	LV_GetText(BckIt%A_Index%, A_Index, 5)
Gui, 1:-Disabled
Gui, 14:Destroy
Gui, chMacro:Default
return

Exe_Exp:
Gui, 14:+OwnDialogs
If !A_AhkPath
{
	GuiControl, 14:, Exe_Exp, 0
	MsgBox, 17, %d_Lang007%, %d_Lang056%
	IfMsgBox, OK
		Run, http://www.autohotkey.com
	return
}
return

ExpSearch:
Gui, 14:+OwnDialogs
Gui, 14:Submit, NoHide
SplitPath, ExpFile, ExpName
FileSelectFile, SelectedFileName, S16, %ExpName%, %d_Lang013%, AutoHotkey Scripts (*.ahk)
FreeMemory()
If SelectedFileName = 
	return
SplitPath, SelectedFileName, name, dir, ext, name_no_ext, drive
If (ext <> "ahk")
	SelectedFileName := SelectedFileName ".ahk"
GuiControl,, ExpFile, %SelectedFileName%
return

ExpButton:
Gui, 14:+OwnDialogs
Gui, 14:Submit, NoHide
If (ExpFile = "")
	return
If (Ex_AbortKey = 1)
{
	If !RegExMatch(AbortKey, "^\w+$")
	{
		MsgBox, 16, %d_Lang007%, %d_Lang073%
		return
	}
}
If (Ex_PauseKey = 1)
{
	If !RegExMatch(PauseKey, "^\w+$")
	{
		MsgBox, 16, %d_Lang007%, %d_Lang073%
		return
	}
}
SelectedFileName := ExpFile
SplitPath, SelectedFileName, name, dir, ext, name_no_ext, drive
If (ext <> "ahk")
	SelectedFileName .= ".ahk"
If drive = 
{
	MsgBox, 16, %d_Lang007%, %d_Lang010%
	return
}
GoSub, ExportFile
return

ExportFile:
Header := Script_Header()
If (Ex_UV = 1)
	Header .= UserVarsList "`n"
RowNumber := 0, AutoKey := "", IncList := "", ProgRatio := 100 / LV_GetCount()
Loop, % LV_GetCount()
{
	GuiControl, 14:, ExpProgress, +%ProgRatio%
	Gui, 14:Default
	Gui, 14:ListView, ExpList
	RowNumber := LV_GetNext(RowNumber, "Checked")
	If ((A_Index = 1) && (RowNumber = 0))
	{
		GuiControl, 14:, ExpProgress, 0
		MsgBox, 16, %d_Lang007%, %d_Lang008%
		return
	}
	If RowNumber = 0
		break
	LV_GetText(Ex_Macro, RowNumber, 1)
	LV_GetText(Ex_AutoKey, RowNumber, 2)
	LV_GetText(Ex_TimesX, RowNumber, 3)
	LV_GetText(Ex_Hotstring, RowNumber, 4)
	LV_GetText(Ex_BM, RowNumber, 5)
	If (ListCount%Ex_Macro% = 0)
		continue
	Body := LV_Export(Ex_Macro), AutoKey .= Ex_AutoKey "`n"
	GoSub, ExportOpt
	AllScripts .= Body "`n"
	PMCSet := "[PMC Code]|" Ex_AutoKey
	. "|" o_ManKey[Ex_Macro] "|" Ex_TimesX
	. "|" CoordMouse "`n"
	PmcCode .= PMCSet . PMC.LVGet("InputList" Ex_Macro).Text . "`n"
	If (Ex_IN)
		IncList .= IncludeFiles(Ex_Macro, ListCount%Ex_Macro%)
}
o_ExAutoKey := [], AbortKey := (Ex_AbortKey = 1) ? AbortKey : ""
,	PauseKey := (Ex_PauseKey = 1) ? PauseKey : ""
Loop, Parse, AutoKey, `n
	o_ExAutoKey[A_Index] := A_LoopField
If CheckDuplicates(AbortKey, PauseKey, o_ExAutoKey*)
{
	Body := "", AllScripts := "", PmcCode := ""
	MsgBox, 16, %d_Lang007%, %d_Lang032%
	return
}
If (Ex_Speed <> 0)
{
	Body := ""
	If (Ex_Speed < 0)
	{
		Ex_Speed *= -1
		Loop, Parse, AllScripts, `n
		{
			If RegExMatch(A_LoopField, "^Sleep, (\d+)$", Value)
				Body .= "Sleep, " . Value1 * Exp_Mult[Ex_Speed] . "`n"
			Else
				Body .= A_LoopField "`n"
		}
	}
	Else
	{
		Loop, Parse, AllScripts, `n
		{
			If RegExMatch(A_LoopField, "^Sleep, (\d+)$", Value)
				Body .= "Sleep, " . Value1 // Exp_Mult[Ex_Speed] . "`n"
			Else
				Body .= A_LoopField "`n"
		}
	}
}
Else
	Body := AllScripts
AllScripts := ""
If (Ex_IfDir = 1)
	Body := Ex_IfDirType ", " Title "`n`n" Body Ex_IfDirType "`n"
If (Ex_AbortKey = 1)
	Body .= "`n" AbortKey "::ExitApp`n"
If (Ex_PauseKey = 1)
	Body .= "`n" PauseKey "::Pause`n"
Script := Header . Body . IncList, ChoosenFileName := SelectedFileName
GoSub, SaveAHK
return

SaveAHK:
IfExist %ChoosenFileName%
{
    FileDelete %ChoosenFileName%
    If ErrorLevel
    {
        MsgBox, 16, %d_Lang007%, %d_Lang006% "%ChoosenFileName%".
        return
    }
}
FileAppend, %Script%, %ChoosenFileName%
If ErrorLevel
{
	MsgBox, 16, %d_Lang007%, %d_Lang006% "%ChoosenFileName%".
	return
}
If IncPmc
	FileAppend, `n%PmcHead%%PmcCode%*/`n, %SelectedFileName%
If Exe_Exp
{
	SplitPath, A_AhkPath,, AhkDir
	RunWait, "%AhkDir%\Compiler\Ahk2Exe.exe" /in "%SelectedFileName%" /bin "%AhkDir%\Compiler\Unicode 32-bit.bin" /mpress 1,, UseErrorLevel
}
PmcCode := ""
MsgBox, 0, %d_Lang014%, %d_Lang015%
GuiControl, 14:, ExpProgress, 0
return

ExportOpt:
If ((TabIndent = 1) &&(Ex_TimesX <> 1))
	Body := RegExReplace(Body, "`am)^", "`t")
If Ex_TimesX = 0
	Body := "Loop`n{`n" Body "}`n"
Else If Ex_TimesX > 1
	Body := "Loop, " Ex_TimesX "`n{`n" Body "}`n"
If Ex_BM = 1
	Body := "BlockInput, MouseMove`n" Body "BlockInput, MouseMoveOff`n"
Body := "Macro" Ex_Macro ":`n" Body "Return`n"
If (Ex_AutoKey <> "")
	Body := Ex_AutoKey "::`n" Body
return

Options:
Gui 4:+LastFoundExist
IfWinExist
{
	WinActivate
	return
}
Gui, 4:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
GoSub, SaveData
GoSub, GetHotkeys
GoSub, ResetHotkeys
OldLoopColor := LoopLVColor, OldIfColor := IfLVColor
, OldMoves := Moves, OldTimed := TimedI, OldRandM := RandomSleeps, OldRandP := RandPercent
FileRead, UserVarsList, %UserVarsPath%
Gui, 4:Add, Listbox, W200 H400 vAltTab gAltTabControl AltSubmit, %t_Lang022%||%t_Lang035%|%t_Lang090%|%t_Lang046%|%t_Lang018%|%t_Lang096%
Gui, 4:Add, Tab2, yp x+0 W400 H0 vTabControl gAltTabControl AltSubmit, Recording|Playback|Defaults|Screenshots|Misc|UserVars
; Recording
Gui, 4:Add, GroupBox, Section ym xm+210 W400 H85, %t_Lang053%
Gui, 4:Add, Text, ys+20 xs+10, %t_Lang019%:
Gui, 4:Add, Hotkey, y+1 W150 vRecKey, %RecKey%
Gui, 4:Add, Text, ys+20 x+20, %t_Lang020%:
Gui, 4:Add, Hotkey, y+1 W150 vRecNewKey, %RecNewKey%
Gui, 4:Add, Checkbox, -Wrap Checked%ClearNewList% vClearNewList W200 R1, %d_Lang019%
Gui, 4:Add, GroupBox, Section y+15 xs W400 H80, %t_Lang133%
Gui, 4:Add, Checkbox, -Wrap Checked%Strokes% ys+20 xs+10 vStrokes W380 R1, %t_Lang021%
Gui, 4:Add, Checkbox, -Wrap Checked%CaptKDn% vCaptKDn W380 R1, %t_Lang023%
Gui, 4:Add, Checkbox, -Wrap Checked%RecKeybdCtrl% vRecKeybdCtrl W380 R1, %t_Lang031%
Gui, 4:Add, GroupBox, Section y+15 xs W400 H130, %t_Lang134%
Gui, 4:Add, Checkbox, -Wrap Checked%Mouse% ys+20 xs+10 vMouse W380 R1, %t_Lang024%
Gui, 4:Add, Checkbox, -Wrap Checked%MScroll% vMScroll W380 R1, %t_Lang025%
Gui, 4:Add, Checkbox, -Wrap Checked%Moves% vMoves gOptionsSub W200 R1, %t_Lang026%
Gui, 4:Add, Text, yp x+0 W130, %t_Lang028%:
Gui, 4:Add, Edit, Limit Number yp-2 x+0 W40 R1 vMDelayT
Gui, 4:Add, UpDown, vMDelay 0x80 Range0-999999999, %MDelay%
Gui, 4:Add, Checkbox, -Wrap Checked%RecMouseCtrl%  y+0 xs+10 vRecMouseCtrl W380 R1, %t_Lang032%
Gui, 4:Add, Text, W200, %t_Lang033%:
Gui, 4:Add, DDL, yp x+0 vRelKey W80, CapsLock||ScrollLock|NumLock
Gui, 4:Add, Checkbox, -Wrap Checked%ToggleC% yp+5 x+5 vToggleC gOptionsSub W100 R1, %t_Lang034%
Gui, 4:Add, GroupBox, Section y+20 xs W400 H85, %t_Lang135%
Gui, 4:Add, Checkbox, -Wrap Checked%TimedI% ys+20 xs+10 vTimedI gOptionsSub W200 R1, %t_Lang027%
Gui, 4:Add, Text, yp x+0 W130, %t_Lang028%:
Gui, 4:Add, Edit, Limit Number yp-2 x+0 W40 R1 vTDelayT
Gui, 4:Add, UpDown, vTDelay 0x80 Range0-999999999, %TDelay%
Gui, 4:Add, Checkbox, -Wrap Checked%WClass% y+0 xs+10 vWClass W380 R1, %t_Lang029%
Gui, 4:Add, Checkbox, -Wrap Checked%WTitle% vWTitle W380 R1, %t_Lang030%
Gui, 4:Tab, 2
; Playback
Gui, 4:Add, GroupBox, Section ym xm+210 W400 H80, %t_Lang053%
Gui, 4:Add, Text, ys+20 xs+10, %t_Lang036%:
Gui, 4:Add, DDL, yp-2 xp+70 W150 vFastKey, None|Insert||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|CapsLock|NumLock|ScrollLock|
Gui, 4:Add, DDL, yp x+5 W37 vSpeedUp, 2||4|8|16|32
Gui, 4:Add, Text, yp+5 xp+40, X
Gui, 4:Add, Text, y+10 xs+10, %t_Lang037%:
Gui, 4:Add, DDL, yp-2 xp+70 W150 vSlowKey, None|Pause||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|CapsLock|NumLock|ScrollLock|
Gui, 4:Add, DDL, yp x+5 W37 vSpeedDn, 2||4|8|16|32
Gui, 4:Add, Text, yp+5 xp+40, X
Gui, 4:Add, GroupBox, Section y+25 xs W400 H105, %w_Lang003%
Gui, 4:Add, Checkbox, -Wrap Checked%ShowStep% ys+20 xs+10 W380 vShowStep R1, %t_Lang100%
Gui, 4:Add, Checkbox, -Wrap Checked%MouseReturn% W380 vMouseReturn, %t_Lang038%
Gui, 4:Add, Checkbox, -Wrap Checked%ShowBarOnStart% W380 vShowBarOnStart, %t_Lang085%
Gui, 4:Add, Checkbox, -Wrap Checked%RandomSleeps% W200 vRandomSleeps gOptionsSub, %t_Lang107%
Gui, 4:Add, Edit, Limit Number yp-2 x+0 W50 R1 vRandPer
Gui, 4:Add, UpDown, vRandPercent 0x80 Range0-1000, %RandPercent%
Gui, 4:Add, Text, yp+5 x+5, `%
Gui, 4:Tab, 3
; Defaults
Gui, 4:Add, GroupBox, Section ym xm+210 W400 H140, %t_Lang090%
Gui, 4:Add, Text, ys+20 xs+10, %t_Lang039%:
Gui, 4:Add, Radio, -Wrap y+5 xS+10 W180 R1 vRelative R1, %c_Lang005%
Gui, 4:Add, Radio, -Wrap yp x+5 W180 R1 vScreen R1, %t_Lang041%
Gui, 4:Add, Text, y+10 xs+10 W200, %t_Lang042%:
Gui, 4:Add, Edit, Limit Number yp-2 x+0 W60 R1
Gui, 4:Add, UpDown, yp xp+60 vDelayM 0x80 Range0-999999999, %DelayM%
Gui, 4:Add, Text, y+5 xs+10 W200, %t_Lang043%:
Gui, 4:Add, Edit, Limit Number yp-2 x+0 W60 R1
Gui, 4:Add, UpDown, yp xp+60 vDelayW 0x80 Range0-999999999, %DelayW%
Gui, 4:Add, Text, y+5 xs+10 W200, %t_Lang044%:
Gui, 4:Add, Edit, Limit Number yp-2 x+0 W60 R1
Gui, 4:Add, UpDown, yp xp+60 vMaxHistory 0x80 Range0-999999999, %MaxHistory%
Gui, 4:Add, Button, -Wrap yp x+5 gClearHistory, %t_Lang045%
Gui, 4:Add, GroupBox, Section y+15 xs W400 H55, %t_Lang137%
Gui, 4:Add, Edit, ys+20 xs+10 vDefaultEditor W350 R1 -Multi, %DefaultEditor%
Gui, 4:Add, Button, -Wrap yp-1 x+0 W30 H23 gSearchEXE, ...
Gui, 4:Add, GroupBox, Section y+18 xs W400 H55, %t_Lang057%
Gui, 4:Add, Edit, ys+20 xs+10 vDefaultMacro W350 R1 -Multi, %DefaultMacro%
Gui, 4:Add, Button, -Wrap yp-1 x+0 W30 H23 gSearchFile, ...
Gui, 4:Add, GroupBox, Section y+18 xs W400 H55, %t_lang058%
Gui, 4:Add, Edit, ys+20 xs+10 vStdLibFile W350 R1 -Multi, %StdLibFile%
Gui, 4:Add, Button, -Wrap yp-1 x+0 W30 H23 vStdLib gSearchAHK, ...
Gui, 4:Add, GroupBox, Section y+18 xs W400 H70, %t_Lang053%
Gui, 4:Add, Text, ys+20 xs+10 W50, %w_Lang006%
Gui, 4:Add, Edit, yp x+0 W135 R1 -Multi ReadOnly, %AutoKey%
Gui, 4:Add, Text, yp x+10 W50, %w_Lang007%
Gui, 4:Add, Edit, yp x+0 W135 R1 -Multi ReadOnly, %ManKey%
Gui, 4:Add, Checkbox, -Wrap Checked%KeepDefKeys% y+5 xs+10 vKeepDefKeys W320 R1, %t_Lang054%.
Gui, 4:Tab, 4
; Screenshots
Gui, 4:Add, GroupBox, Section ym xm+210 W400 H160, %t_Lang046%
Gui, 4:Add, Text, ys+20 xs+10, %t_Lang047%:
Gui, 4:Add, DDL, yp-5 xs+100 vDrawButton W75, RButton||LButton|MButton
Gui, 4:Add, Text, y+10 xs+10 W200, %t_Lang048%:
Gui, 4:Add, Edit, Limit Number yp-2 x+0 W40 R1 vLineT
Gui, 4:Add, UpDown, yp xp+60 vLineW 0x80 Range1-5, %LineW%
Gui, 4:Add, Radio, -Wrap y+10 xs+10 W180 vOnRelease R1, %t_Lang049%
Gui, 4:Add, Radio, -Wrap yp x+5 W180 vOnEnter R1, %t_Lang050%
Gui, 4:Add, Text, y+10 xs+10, %t_Lang051%:
Gui, 4:Add, Edit, vScreenDir W350 R1 -Multi, %ScreenDir%
Gui, 4:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchScreen gSearchDir, ...
Gui, 4:Tab, 5
; General
Gui, 4:Add, GroupBox, Section ym xm+210 W400 H100, %t_Lang018%
Gui, 4:Add, Checkbox, -Wrap Checked%HKOff% ys+20 xs+10 vHKOff W380 R1, %t_Lang055%
Gui, 4:Add, Checkbox, -Wrap Checked%MultInst% vMultInst W380 R1, %t_Lang089%
Gui, 4:Add, Checkbox, -Wrap Checked%EvalDefault% vEvalDefault W380 R1, %t_Lang059%
Gui, 4:Add, Checkbox, -Wrap Checked%AllowRowDrag% vAllowRowDrag W380 R1, %t_Lang091%
Gui, 4:Add, GroupBox, Section y+15 xs W400 H135, %t_Lang136%
Gui, 4:Add, Checkbox, -Wrap Checked%ShowLoopIfMark% ys+20 xs+10 vShowLoopIfMark W380 R1, %t_Lang060%
Gui, 4:Add, Text, W380, %t_Lang061%
Gui, 4:Add, Text, y+15 W85, %t_Lang003% "{"
Gui, 4:Add, Text, yp x+10 W40 vLoopLVColor gEditColor c%LoopLVColor%, ██████
Gui, 4:Add, Text, yp x+20 W85, %t_Lang082% "*"
Gui, 4:Add, Text, yp x+10 W40 vIfLVColor gEditColor c%IfLVColor%, ██████
Gui, 4:Add, Checkbox, -Wrap Checked%ShowActIdent% yp+25 xs+10 vShowActIdent W380 R1, %t_Lang083%
Gui, 4:Add, Text, W380, %t_Lang084%
Gui, 4:Add, GroupBox, Section y+17 xs W400 H150, %t_Lang062%
Gui, 4:Add, Edit, ys+20 xs+10 W380 r7 vEditMod, %VirtualKeys%
Gui, 4:Add, Button, -Wrap y+0 W75 H23 gConfigRestore, %t_Lang063%
Gui, 4:Add, Button, -Wrap yp x+10 W75 H23 gKeyHistory, %c_Lang124%
Gui, 4:Tab, 6
; User Variables
Gui, 4:Add, GroupBox, Section ym xm+210 W400 H395, %t_Lang096%
Gui, 4:Add, Text, ys+20 xs+10 -Wrap W150 R1, %t_Lang093%:
Gui, 4:Add, Text, -Wrap W200 R1 yp xs+155 cRed, %t_Lang094%
Gui, 4:Add, Text, -Wrap W380 R1 y+5 xs+10, %t_Lang095%
Gui, 4:Add, Edit, W380 r24 vUserVarsList, %UserVarsList%
Gui, 4:Tab
Gui, 4:Add, Button, -Wrap Default Section xm W75 H23 gConfigOK, %c_Lang020%
Gui, 4:Add, Button, -Wrap ys W75 H23 gConfigCancel, %c_Lang021%
GuiControl, 4:ChooseString, RelKey, %RelKey%
GuiControl, 4:ChooseString, FastKey, %FastKey%
GuiControl, 4:ChooseString, SlowKey, %SlowKey%
GuiControl, 4:ChooseString, SpeedUp, %SpeedUp%
GuiControl, 4:ChooseString, SpeedDn, %SpeedDn%
GuiControl, 4:ChooseString, DrawButton, %DrawButton%
If CoordMouse = Window
	GuiControl, 4:, Relative, 1
Else If CoordMouse = Screen
	GuiControl, 4:, Screen, 1
GuiControl, 4:, OnRelease, %OnRelease%
GuiControl, 4:, OnEnter, %OnEnter%
GuiControl, 4:Enable%RandomSleeps%, RandPercent
GuiControl, 4:Enable%RandomSleeps%, RandPer
GoSub, OptionsSub
Gui, 4:Show,, %t_Lang017%
OldMods := VirtualKeys
Input
Tooltip
return

ConfigOK:
Gui, 4:Submit, NoHide
Gui, 4:+OwnDialogs
If Relative = 1
	CoordMouse = Window
Else If Screen = 1
	CoordMouse = Screen
If OnRelease = 1
	SSMode = OnRelease
Else If OnEnter = 1
	SSMode = OnEnter
VirtualKeys := EditMod, UserVarsList := RegExReplace(UserVarsList, "U)\s+=\s+", "=")
User_Vars.Set(UserVarsList)
User_Vars.Read()
FileDelete, %UserVarsPath%
User_Vars.Write(UserVarsPath)
Gui, 1:-Disabled
Gui, 4:Destroy
Gui, chMacro:Default
GoSub, KeepMenuCheck
GoSub, LoadLang
IniWrite, %MultInst%, %IniFilePath%, Options, MultInst
GuiControl, 1:, CoordTip, CoordMode: %CoordMouse%
GoSub, PrevRefresh
If WinExist("ahk_id " PMCOSC)
	GuiControl, 28:, OSProgB, %ShowProgBar%
GoSub, RowCheck
return

ConfigCancel:
4GuiClose:
4GuiEscape:
VirtualKeys := OldMods, LoopLVColor := OldLoopColor, IfLVColor := OldIfColor
, Moves := OldMoves, TimedI := OldTimed, RandomSleeps := OldRandM, RandPercent := OldRandP
Gui, 1:-Disabled
Gui, 4:Destroy
return

ConfigRestore:
GoSub, DefaultMod
GuiControl,, EditMod, %VirtualKeys%
return

KeyHistory:
KeyHistory
return

OptionsSub:
Gui, 4:Submit, NoHide
GuiControl, 4:Enable%Moves%, MDelayT
GuiControl, 4:Enable%TimedI%, TDelayT
GuiControl, 4:Enable%RandomSleeps%, RandPercent
GuiControl, 4:Enable%RandomSleeps%, RandPer
ToggleMode := ToggleC ? "T" : "P"
return

AltTabControl:
Gui, 4:Submit, NoHide
GuiControl, 4:Choose, TabControl, %AltTab%
return

LoadDefaults:
Gui, 1:+OwnDialogs
MsgBox, 49, %d_Lang003%, %d_Lang024%
IfMsgBox, OK
{
	If KeepDefKeys
	{
		IniRead, AutoKey, %IniFilePath%, HotKeys, AutoKey, F2|F3|F4
		IniRead, ManKey, %IniFilePath%, HotKeys, ManKey, F5|F6|F7
	}
	IfExist, %IniFilePath%
		FileDelete %IniFilePath%
	GoSub, LoadSettings
	GoSub, RowCheck
	GoSub, WriteSettings
}
return

DefaultMacro:
If CurrentFileName = 
{
	MsgBox, 33, %d_Lang005%, %d_Lang002%`n`"%CurrentFileName%`"
	IfMsgBox, OK
		GoSub, Save
	IfMsgBox, Cancel
		return
}
DefaultMacro = %CurrentFileName%
return

RemoveDefault:
DefaultMacro =
GuiControl, 4:, DefaultMacro
return

KeepDefKeys:
If !A_GuiControl
	KeepDefKeys := !KeepDefKeys
If KeepDefKeys
{
	GoSub, SaveData
	GoSub, GetHotKeys
	IniWrite, %AutoKey%, %IniFilePath%, HotKeys, AutoKey
	IniWrite, %ManKey%, %IniFilePath%, HotKeys, ManKey
	DefAutoKey := AutoKey, DefManKey := ManKey
}
GoSub, KeepMenuCheck
return

KeepMenuCheck:
If KeepDefKeys
	Menu, OptionsMenu, Check, %o_Lang002%
Else
	Menu, OptionsMenu, Uncheck, %o_Lang002%
return

SearchFile:
Gui, 4:Submit, NoHide
Gui, 4:+OwnDialogs
Gui, 4:+Disabled
FileSelectFile, SelectedFileName,,,, Project Files (*.pmc; *.ahk)
Gui, 4:-Disabled
FreeMemory()
If !SelectedFileName
	return
GuiControl, 4:, DefaultMacro, %SelectedFileName%
return

SearchEXE:
Gui, 4:Submit, NoHide
Gui, 4:+OwnDialogs
Gui, 4:+Disabled
FileSelectFile, SelectedFileName,, %ProgramFiles%,, Executable Files (*.exe)
Gui, 4:-Disabled
FreeMemory()
If !SelectedFileName
	return
GuiControl, 4:, DefaultEditor, %SelectedFileName%
return

ClearHistory:
Loop, %TabCount%
{
	Gui, chMacro:Listview, InputList%A_Index%
	HistoryMacro%A_Index% := new LV_Rows()
	HistoryMacro%A_Index%.Add()
}
Gui, chMacro:Listview, InputList%A_List%
return

HandCursor:
DllCall("SetCursor", "UInt", hCurs)
return


;##### Context Help: #####

HelpB:
ThisMenuItem := RegExReplace(A_ThisMenuItem, "\s/.*")
StringReplace, ThisMenuItem, ThisMenuItem, #, _
If ThisMenuItem = Clipboard
	Run, http://l.autohotkey.net/docs/misc/Clipboard.htm
Else If ThisMenuItem = If Statements
	Run, http://l.autohotkey.net/docs/commands/IfEqual.htm
Else If ThisMenuItem = Labels
	Run, http://l.autohotkey.net/docs/misc/Labels.htm
Else If ThisMenuItem = SplashImage
	Run, http://l.autohotkey.net/docs/commands/Progress.htm
Else If ThisMenuItem = SplashTextOff
	Run, http://l.autohotkey.net/docs/commands/SplashTextOn.htm
Else If InStr(ThisMenuItem, "LockState")
	Run, http://l.autohotkey.net/docs/commands/SetNumScrollCapsLockState.htm
Else If ThisMenuItem = Variables
	Run, http://l.autohotkey.net/docs/Variables.htm
Else If ThisMenuItem = Functions
	Run, http://l.autohotkey.net/docs/Functions.htm
Else
	Run, http://l.autohotkey.net/docs/commands/%ThisMenuItem%.htm
return

LoopB:
StringReplace, ThisMenuItem, A_ThisMenuItem, #, _
StringReplace, ThisMenuItem, ThisMenuItem, `,
StringReplace, ThisMenuItem, ThisMenuItem, %A_Space%,, All
StringReplace, ThisMenuItem, ThisMenuItem, Pattern
StringReplace, ThisMenuItem, ThisMenuItem, istry
Run, http://l.autohotkey.net/docs/commands/%ThisMenuItem%.htm
return

ExportG:
SpecialB:
If A_ThisMenuItem = List of Keys
	Run, http://l.autohotkey.net/docs/KeyList.htm
Else If A_ThisMenuItem = Auto-execute Section
	Run, http://l.autohotkey.net/docs/Scripts.htm#auto
Else If InStr(A_ThisMenuItem, "ComObj")
	Run, http://l.autohotkey.net/docs/commands/%A_ThisMenuItem%.htm
Else
	Run, http://l.autohotkey.net/docs/%A_ThisMenuItem%.htm
return

IEComB:
If A_ThisMenuItem = COM
	Run, http://l.autohotkey.net/docs/commands/ComObjCreate.htm
If A_ThisMenuItem = Basic Webpage COM Tutorial
	Run, http://www.autohotkey.com/board/topic/47052-basic-webpage-controls
If A_ThisMenuItem = IWebBrowser2 Interface (MSDN)
	Run, http://msdn.microsoft.com/en-us/library/aa752127
return

SendMsgB:
If A_ThisMenuItem = Message List
	Run, http://l.autohotkey.net/docs/misc/SendMessageList.htm
If A_ThisMenuItem = Microsoft MSDN
	Run, http://msdn.microsoft.com
return

Help:
IfExist, %A_ScriptDir%\MacroCreator_Help.chm
	Run, %A_ScriptDir%\MacroCreator_Help.chm
Else
	Run, http://www.macrocreator.com/Docs
return

Homepage:
Run, http://www.macrocreator.com
return

Forum:
Run, http://www.autohotkey.com/board/topic/79763-macro-creator
return

HelpAHK:
Run, http://l.autohotkey.net/docs
return

CheckNow:
CheckUpdates:
Gui, 1:+OwnDialogs
IfExist, %A_Temp%\PMCIndex.html
	FileDelete, %A_Temp%\PMCIndex.html
UrlDownloadToFile, http://www.macrocreator.com/Docs/, %A_Temp%\PMCIndex.html
FileRead, VerChk, %A_Temp%\PMCIndex.html
VerChk := RegExReplace(VerChk, "s).*Version: ([\d\.]+).*", "$1", vFound)
If vFound
{
	FileDelete, %A_Temp%\PMCIndex.html
	If (VerChk <> CurrentVersion)
	{
		MsgBox, 68, %d_Lang060%, %d_Lang060%: %VerChk%`n%d_Lang061%
		IfMsgBox, Yes
			Run, http://www.macrocreator.com/download
	}
	Else If (A_ThisLabel = "CheckNow")
		MsgBox, 64, %AppName%, %d_Lang062%
}
Else If (A_ThisLabel = "CheckNow")
	MsgBox, 16, %d_Lang007%, % d_Lang063 "`n`n""" RegExReplace(VerChk, ".*<H2>(.*)</H2>.*", "$1") """"
return

AutoUpdate:
AutoUpdate := !AutoUpdate
Menu, HelpMenu, % (AutoUpdate) ? "Check" : "Uncheck", %h_Lang004%
return

HelpAbout:
Gui 26:+LastFoundExist
IfWinExist
    GoSub, TipClose
OsBit := (A_PtrSize = 8) ? "x64" : "x86"
Gui, 26:-SysMenu +HwndTipScrID +owner1
Gui, 26:Color, FFFFFF
Gui, 26:Add, Pic, w48 y+20 Icon1, %DefaultIcon%
Gui, 26:Font, Bold s12, Tahoma
Gui, 26:Add, Text, yp x+10, PULOVER'S MACRO CREATOR
Gui, 26:Font
Gui, 26:Font, Italic, Tahoma
Gui, 26:Add, Text, y+0 w300, The Complete Automation Tool
Gui, 26:Font
Gui, 26:Font,, Tahoma
Gui, 26:Add, Link,, <a href="http://www.macrocreator.com">www.macrocreator.com</a>
Gui, 26:Add, Text,, Author: Pulover [Rodolfo U. Batista]
Gui, 26:Add, Link, y+0, <a href="mailto:pulover@macrocreator.com">pulover@macrocreator.com</a>
Gui, 26:Add, Text, y+0,
(
Copyright © 2012-2013 Rodolfo U. Batista

Version: %CurrentVersion% (%OsBit%)
Release Date: %ReleaseDate%
AutoHotkey Version: %A_AhkVersion%
)
Gui, 26:Add, Link, y+0, Software Licence: <a href="http://www.gnu.org/licenses/gpl-3.0.txt">GNU General Public License</a>
Gui, 26:Font, Bold, Tahoma
Gui, 26:Add, Text,, Thanks to:
Gui, 26:Font
Gui, 26:Font,, Tahoma
Gui, 26:Add, Link, y+0, Chris and Lexikos for <a href="http://www.autohotkey.com/">AutoHotkey</a>.
Gui, 26:Add, Link, y+0, tic (Tariq Porter) for his <a href="http://www.autohotkey.com/board/topic/29449-gdi-standard-library">GDI+ Library</a>.
Gui, 26:Add, Link, y+0, tkoi && majkinetor for the <a href="http://www.autohotkey.com/board/topic/37147-ilbutton-image-buttons">ILButton function</a>.
Gui, 26:Add, Link, y+0, just me for <a href="http://www.autohotkey.com/board/topic/88699-class-lv-colors">LV_Colors Class</a>, GuiCtrlAddTab and for updating ILButton to 64bit.
Gui, 26:Add, Link, y+0, diebagger and Obi-Wahn for the <a href="http://www.autohotkey.com/board/topic/56396-techdemo-move-rows-in-a-listview">function to move rows</a>.
Gui, 26:Add, Link, y+0, Micahs for the <a href="http://www.autohotkey.com/board/topic/30486-listview-tooltip-on-mouse-hover/?p=280843">base code</a> of the Drag-Rows function.
Gui, 26:Add, Link, y+0, Kdoske && trueski for the <a href="http://www.autohotkey.com/board/topic/51681-csv-library-lib">CSV functions</a>.
Gui, 26:Add, Link, y+0, jaco0646 for the <a href="http://www.autohotkey.com/board/topic/47439-user-defined-dynamic-hotkeys">function</a> to make hotkey controls detect other keys.
Gui, 26:Add, Link, y+0, Laszlo for the <a href="http://www.autohotkey.com/board/topic/15675-monster">Monster function</a> to solve expressions.
Gui, 26:Add, Link, y+0, Jethrow for the <a href="http://www.autohotkey.com/board/topic/47052-basic-webpage-controls">IEGet Function</a>.
Gui, 26:Add, Link, y+0, RaptorX for the <a href="http://www.autohotkey.com/board/topic/85928-wrapper-scintilla-wrapper">Scintilla Wrapper for AHK</a>.
Gui, 26:Add, Link, y+0, majkinetor for the <a href="http://www.autohotkey.com/board/topic/49214-ahk-ahk-l-forms-framework-08/">Dlg_Color</a> function.
Gui, 26:Add, Link, y+0, rbrtryn for the <a href="http://www.autohotkey.com/board/topic/91229-windows-color-picker-plus/">ChooseColor</a> function.
Gui, 26:Add, Link, y+0, fincs for <a href="http://www.autohotkey.com/board/topic/71751-gendocs-v30-alpha002">GenDocs</a>.
Gui, 26:Add, Link, y+0, T800 for <a href="http://www.autohotkey.com/board/topic/17984-html-help-utils">Html Help utils</a>.
Gui, 26:Add, Text, y+0 w380, Translation revisions: Snow Flake (Swedish), huyaowen (Chinese Simplified), Jörg Schmalenberger (German).
Gui, 26:Add, Groupbox, W380 H130 Center, GNU General Public License
Gui, 26:Add, Edit, yp+20 xp+10 W360 H100 ReadOnly -E0x200,
(
This program is free software, and you are welcome to redistribute it under  the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or any later version.

This program comes with ABSOLUTELY NO WARRANTY; for details see GNU General Public License.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
)
Gui, 26:Font
Gui, 26:Add, Button, -Wrap Default y+20 xp-10 W80 H23 gTipClose, %c_Lang020%
Gui, 26:Font, Bold, Tahoma
Gui, 26:Add, Text, yp-3 xp+255 H25 Center Hidden vHolderStatic, %m_Lang009%
GuiControlGet, Hold, 26:Pos, HolderStatic
Gui, 26:Add, Progress, % "x" 429 - HoldW " yp wp+20 hp BackgroundF68C06 vProgStatic Disabled"
Gui, 26:Add, Text, xp yp wp hp Border cWhite Center 0x200 BackgroundTrans vDonateStatic gDonatePayPal, %m_Lang009%
Gui, 26:Font
GuiControl, 26:Focus, %c_Lang020%
Gui, 26:Show, W460, %t_Lang076%
hCurs := DllCall("LoadCursor", "Int", 0, "Int", 32649, "UInt")
return

EditMouse:
s_Caller = Edit
Mouse:
Gui, 5:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
; Action
Gui, 5:Add, GroupBox, Section W250 H100, %c_Lang026%:
Gui, 5:Add, Radio, -Wrap ys+20 xs+10 Checked W115 vClick gClick R1, %c_Lang027%
Gui, 5:Add, Radio, -Wrap y+10 xp W115 vPoint gPoint R1, %c_Lang028%
Gui, 5:Add, Radio, -Wrap y+10 xp W115 vPClick gPClick R1, %c_Lang029%
Gui, 5:Add, Radio, -Wrap ys+20 xp+120 W115 vWUp gWUp R1, %c_Lang030%
Gui, 5:Add, Radio, -Wrap y+10 xp W115 vWDn gWDn R1, %c_Lang031%
Gui, 5:Add, Radio, -Wrap y+10 xp W115 vDrag gDrag R1, %c_Lang032%
; Coordinates
Gui, 5:Add, GroupBox, Section ys x+10 W250 H100, %c_Lang033%:
Gui, 5:Add, Text, Section ys+25 xs+10, X:
Gui, 5:Add, Edit, ys-3 x+5 vIniX W70 Disabled
Gui, 5:Add, Text, ys x+20, Y:
Gui, 5:Add, Edit, ys-3 x+5 vIniY W70 Disabled
Gui, 5:Add, Button, -Wrap ys-5 x+5 W30 H23 vMouseGetI gMouseGetI Disabled, ...
Gui, 5:Add, Text, Section xs, X:
Gui, 5:Add, Edit, ys-3 x+5 vEndX W70 Disabled
Gui, 5:Add, Text, ys x+20, Y:
Gui, 5:Add, Edit, ys-3 x+5 vEndY W70 Disabled
Gui, 5:Add, Button, -Wrap ys-4 x+5 W30 H23 vMouseGetE gMouseGetE Disabled, ...
Gui, 5:Add, Radio, -Wrap Checked y+5 xs W65 vCL gCL R1, %c_Lang034%
Gui, 5:Add, Radio, -Wrap yp x+5 W65 vSE gSE R1, %c_Lang035%
Gui, 5:Add, Checkbox, -Wrap yp x+5 vMRel gMRel Disabled W95 R1, %c_Lang036%
; Button
Gui, 5:Add, GroupBox, Section xm W505 H70, %c_Lang037%:
Gui, 5:Add, Radio, -Wrap ys+20 xs+10 Checked W90 vLB R1, %c_Lang038%
Gui, 5:Add, Radio, -Wrap yp x+5 W90 vRB R1, %c_Lang039%
Gui, 5:Add, Radio, -Wrap yp x+5 W90 vMB R1, %c_Lang040%
Gui, 5:Add, Radio, -Wrap yp x+5 W90 vX1 R1, %c_Lang041%
Gui, 5:Add, Radio, -Wrap yp x+5 W90 vX2 R1, %c_Lang042%
Gui, 5:Add, Checkbox, -Wrap Check3 y+10 xs+10 vMHold gMHold R1, %c_Lang043%
Gui, 5:Add, Text, yp x+10 vClicks, %c_Lang044%:
Gui, 5:Add, Edit, Limit Number yp-2 x+5 W60 R1 vCCount
Gui, 5:Add, UpDown, 0x80 Range0-999999999, 1
; Repeat
Gui, 5:Add, GroupBox, Section xm W250 H125
Gui, 5:Add, Text, ys+15 xs+10, %w_Lang015%:
Gui, 5:Add, Text,, %c_Lang017%:
Gui, 5:Add, Edit, ys+15 xs+120 W120 R1 vEdRept
Gui, 5:Add, UpDown, vTimesX 0x80 Range1-999999999, 1
Gui, 5:Add, Edit, W120 vDelayC
Gui, 5:Add, UpDown, vDelayX 0x80 Range0-999999999, %DelayM%
Gui, 5:Add, Radio, -Wrap Checked W125 vMsc R1, %c_Lang018%
Gui, 5:Add, Radio, -Wrap W125 vSec R1, %c_Lang019%
; Control
Gui, 5:Add, GroupBox, Section ys x+20 W250 H125
Gui, 5:Add, Checkbox, -Wrap ys+15 xs+10 W160 vCSend gCSend R1, %c_Lang016%:
Gui, 5:Add, Edit, vDefCt W200 Disabled
Gui, 5:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl Disabled, ...
Gui, 5:Add, DDL, y+5 xs+10 W65 vIdent Disabled, Title||Class|Process|ID|PID
Gui, 5:Add, Text, -Wrap yp+5 x+5 W140 H20 vWinParsTip Disabled, %wcmd_All%
Gui, 5:Add, Edit, y+5 xs+10 W200 vTitle Disabled, A
Gui, 5:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin Disabled, ...
Gui, 5:Add, Button, -Wrap Section Default xm W75 H23 gMouseOK, %c_Lang020%
Gui, 5:Add, Button, -Wrap ys W75 H23 gMouseCancel, %c_Lang021%
Gui, 5:Add, Button, -Wrap ys W75 H23 vMouseApply gMouseApply Disabled, %c_Lang131%
If (s_Caller = "Edit")
{
	EscCom("Details|TimesX|DelayX|Target|Window", 1)
	If InStr(Action, "Left")
		GuiControl, 5:, LB, 1
	If InStr(Action, "Right")
		GuiControl, 5:, RB, 1
	If InStr(Action, "Middle")
		GuiControl, 5:, MB, 1
	If InStr(Action, "X1")
		GuiControl, 5:, X1, 1
	If InStr(Action, "X2")
		GuiControl, 5:, X2, 1
	StringReplace, Action, Action, Left%A_Space%
	StringReplace, Action, Action, Right%A_Space%
	StringReplace, Action, Action, Middle%A_Space%
	StringReplace, Action, Action, X1%A_Space%
	StringReplace, Action, Action, X2%A_Space%
	If (Action = Action1)
	{
		If (Type = cType13)
		{
			StringReplace, Details, Details, `{Click`,%A_Space%
			StringReplace, Details, Details, `}
		}
		GuiControl, 5:, Click, 1
		GoSub, Click
		Loop, Parse, Details, %A_Space%, `,
			Par%A_Index% := A_LoopField
		If ((Par2 <> "Down") && (Par2 <> "Up"))
			GuiControl, 5:, CCount, %Par2%
		GuiControl, 5:Disable, DefCt
		GuiControl, 5:Disable, GetCtrl
	}
	If (Action = Action2)
	{
		GuiControl, 5:, Point, 1
		GoSub, Point
	}
	If (Action = Action3)
	{
		GuiControl, 5:, PClick, 1
		GoSub, PClick
	}
	If (Action = Action4)
	{
		StringReplace, DetailsX, Details, Rel%A_Space%,, All
		StringReplace, DetailsX, DetailsX, `}`{, |, All
		StringReplace, DetailsX, DetailsX, %A_Space%,, All
		Loop, Parse, DetailsX, |
			Details%A_Index% := A_LoopField
		StringReplace, Details1, Details1, `{
		StringReplace, Details2, Details2, `}
		Loop, Parse, Details1, `,
			Par%A_Index% := A_LoopField
		GuiControl, 5:, IniX, %Par2%
		GuiControl, 5:, IniY, %Par3%
		Loop, Parse, Details2, `,
			Par%A_Index% := A_LoopField
		GuiControl, 5:, EndX, %Par2%
		GuiControl, 5:, EndY, %Par3%
		GuiControl, 5:, Drag, 1
		GoSub, Drag
	}
	If (Action = Action5)
	{
		If (Type = cType13)
		{
			StringReplace, Details, Details, `{Click`,%A_Space%
			StringReplace, Details, Details, `}
		}
		GuiControl, 5:, WUp, 1
		GoSub, WUp
		Loop, Parse, Details, %A_Space%
			Par%A_Index% := A_LoopField
		GuiControl, 5:, CCount, %Par2%
		GuiControl, 5:Disable, DefCt
		GuiControl, 5:Disable, GetCtrl
	}
	If (Action = Action6)
	{
		If (Type = cType13)
		{
			StringReplace, Details, Details, `{Click`,%A_Space%
			StringReplace, Details, Details, `}
		}
		GuiControl, 5:, WDn, 1
		GoSub, WDn
		Loop, Parse, Details, %A_Space%, `,
			Par%A_Index% := A_LoopField
		GuiControl, 5:, CCount, %Par2%
		GuiControl, 5:Disable, DefCt
		GuiControl, 5:Disable, GetCtrl
	}
	If InStr(Details, " Down")
	{
		GuiControl, 5:, MHold, 1
		GuiControl, 5:, CCount, 1
		GuiControl, 5:Disable, Clicks
		GuiControl, 5:Disable, CCount
		StringReplace, Details, Details, %A_Space%Down
	}
	If InStr(Details, " Up")
	{
		GuiControl, 5:, MHold, -1
		GuiControl, 5:, CCount, 1
		GuiControl, 5:Disable, Clicks
		GuiControl, 5:Disable, CCount
		StringReplace, Details, Details, %A_Space%Up
	}
	If (Type = cType4)
	{
		GuiControl, 5:, CSend, 1
		GuiControl, 5:Enable, CSend
		GuiControl, 5:Enable, DefCt
		GuiControl, 5:Enable, GetCtrl
		GuiControl, 5:Enable, Ident
		GuiControl, 5:Enable, Title
		GuiControl, 5:Enable, GetWin
		GuiControl, 5:Enable, MRel
		GuiControl, 5:, MRel, 1
		GuiControl, 5:Enable, IniX
		GuiControl, 5:Enable, IniY
		GuiControl, 5:Enable, MouseGetI
		GuiControl, 5:, DefCt, %Target%
		Loop, Parse, Details, `,, %A_Space%
			Par%A_Index% := A_LoopField
		Loop, Parse, Par3, %A_Space%
			Param%A_Index% := A_LoopField
		If InStr(Param1, "x")
		{
			StringReplace, Param1, Param1, x
			StringReplace, Param2, Param2, y
			GuiControl, 5:, IniX, %Param1%
			GuiControl, 5:, IniY, %Param2%
		}
		If InStr(Param2, "x")
		{
			StringReplace, Param2, Param2, x
			StringReplace, Param3, Param3, y
			GuiControl, 5:, IniX, %Param2%
			GuiControl, 5:, IniY, %Param3%
		}
		If RegExMatch(Target, "^x[0-9]+ y[0-9]+$")
		{
			StringReplace, Target, Target, x
			StringReplace, Target, Target, y
			Loop, Parse, Target, %A_Space%
				Targ%A_Index% := A_LoopField
			GuiControl, 5:Enable, CSend
			GuiControl, 5:Disable, DefCt
			GuiControl, 5:Disable, GetCtrl
			GuiControl, 5:, MRel, 0
			GuiControl, 5:, DefCt
			GuiControl, 5:, IniX, %Targ1%
			GuiControl, 5:, IniY, %Targ2%
		}
		GuiControl, 5:, Title, %Window%
	}
	If (Type = cType13)
	{
		GuiControl, 5:, SE, 1
		GoSub, SE
	}
	If InStr(Details, "Rel")
		GuiControl, 5:, MRel, 1
	GuiControl, 5:, TimesX, %TimesX%
	GuiControl, 5:, EdRept, %TimesX%
	GuiControl, 5:, DelayX, %DelayX%
	GuiControl, 5:, DelayC, %DelayX%
	If ((Action = Action2) || (Action = Action3))
	{
		If (Type = cType13)
		{
			StringReplace, Details, Details, `{Click`,%A_Space%
			StringReplace, Details, Details, `}
		}
		StringReplace, Details, Details, Rel%A_Space%
		Loop, Parse, Details, %A_Space%
			Par%A_Index% := A_LoopField
		StringReplace, Par1, Par1, `,
		StringReplace, Par2, Par2, `,
		GuiControl, 5:, IniX, %Par1%
		GuiControl, 5:, IniY, %Par2%
		If (Action = Action2)
			GuiControl, 5:, CCount, 1
		Else
		{
			If ((Par4 <> "Down") && (Par4 <> "Up"))
				GuiControl, 5:, CCount, %Par4%
		}
	}
	GuiControl, 5:Enable, MouseApply
}
If (s_Caller = "Find")
{
	Gui, 5:Default
	If (GotoRes1 = Action1)
	{
		GuiControl, 5:, Click, 1
		GoSub, Click
	}
	Else If (GotoRes1 = Action2)
	{
		GuiControl, 5:, Point, 1
		GoSub, Point
	}
	Else If (GotoRes1 = Action3)
	{
		GuiControl, 5:, PClick, 1
		GoSub, PClick
	}
	Else If (GotoRes1 = Action4)
	{
		GuiControl, 5:, Drag, 1
		GoSub, Drag
	}
	Else If (GotoRes1 = Action5)
	{
		GuiControl, 5:, WUp, 1
		GoSub, WUp
	}
	Else If (GotoRes1 = Action6)
	{
		GuiControl, 5:, WDn, 1
		GoSub, WDn
	}
}
Gui, 5:Show,, %c_Lang001%
Input
Tooltip
return

MouseApply:
MouseOK:
Gui, 5:+OwnDialogs
Gui, 5:Submit, NoHide
DelayX := InStr(DelayC, "%") ? DelayC : DelayX
If Sec = 1
	DelayX *= 1000
TimesX := InStr(EdRept, "%") ? EdRept : TimesX
If TimesX = 0
	TimesX := 1
If LB = 1
	Button = Left
If RB = 1
	Button = Right
If MB = 1
	Button = Middle
If X1 = 1
	Button = X1
If X2 = 1
	Button = X2
If Click = 1
	GoSub, f_Click
If Point = 1
{
	If ((IniX = "") || (IniY = ""))
	{
		MsgBox, 16, %d_Lang011%, %d_Lang016%
			return
	}
	Else
	GoSub, f_Point
}
If PClick = 1
{
	If ((IniX = "") || (IniY = ""))
	{
		MsgBox, 16, %d_Lang011%, %d_Lang016%
		return
	}
	Else
	GoSub, f_PClick
}
If Drag = 1
{
	If ((IniX = "") || (IniY = "") || (EndX = "") || (EndY = ""))
	{
		MsgBox, 16, %d_Lang011%, %d_Lang016%
		return
	}
	Else
	GoSub, f_Drag
}
If WUp = 1
	GoSub, f_WUp
If WDn = 1
	GoSub, f_WDn
Window := Title
GuiControlGet, CtrlState, Enabled, DefCt
GuiControlGet, SendState, Enabled, CSend
If CtrlState = 1
{
	If ((CSend = 1) && (SendState = 1))
	{
		If DefCt = 
		{
			MsgBox, 52, %d_Lang011%, %d_Lang012%
			IfMsgBox, No
				return
		}
		If ((IniX = "") || (IniY = ""))
			Details .= " NA"
		Target := DefCt, Type := cType4
	}
	Else
		Target := "", Window := ""
}
Else
{
	If ((CSend = 1) && (SendState = 1))
	{
		If ((IniX = "") || (IniY = ""))
		{
			MsgBox, 16, %d_Lang011%, %d_Lang016%
			return
		}
		Else
			Details .= " NA", Target := "x" IniX " y" IniY, Type := cType4
	}
	Else
		Target := "", Window := ""
}
EscCom("TimesX|DelayX")
If (A_ThisLabel <> "MouseApply")
{
	Gui, 1:-Disabled
	Gui, 5:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
{
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type, Target, Window)
}
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Action, Details, TimesX, DelayX, Type, Target, Window)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, Action, Details, TimesX, DelayX, Type, Target, Window)
		RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "MouseApply")
	Gui, 5:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

MouseCancel:
5GuiClose:
5GuiEscape:
Gui, 1:-Disabled
Gui, 5:Destroy
s_Caller = 
return

f_Click:
Action := Button " " Action1, Details := Button
If MHold = 0
	Details .= ", " CCount ", "
If MHold = 1
	Details .= ", , Down"
If MHold = -1
	Details .= ", , Up"
If MRel = 1
{
	If ((IniX <> "") && (IniY <> ""))
		Details .= " x" IniX " y" IniY " NA"
}
If SE = 1
	Details := "{Click, " Details "}", Type := cType13
Else
	Type := cType3
return

f_Point:
Action := Action2, Details := IniX ", " IniY ", 0"
If MRel = 1
	Details := "Rel " Details
If SE = 1
	Details := "{Click, " Details "}", Type := cType13
Else
	Type := cType3
return

f_PClick:
Action := Button " " Action3, Details := IniX ", " IniY " " Button
If MHold = 1
	Details .= ", Down"
If MHold = -1
	Details .= ", Up"
If MRel = 1
	Details := "Rel " Details
If MHold = 0
	Details .= ", " CCount
If SE = 1
	Details := "{Click, " Details "}", Type := cType13
Else
	Type := cType3
return

f_Drag:
Action := Button " " Action4, DetailsI := IniX ", " IniY ", " Button " Down"
,	DetailsE := EndX ", " EndY ", " Button " Up"
If MRel = 1
	DetailsI := " Rel " DetailsI, DetailsE := " Rel " DetailsE
Details := "{Click, " DetailsI "}{Click, " DetailsE "}", Type := cType13
return

f_WUp:
Action := Action5
,	Details := "WheelUp"
,	Details .= ", " CCount
If SE = 1
	Details := "{Click, " Details "}", Type := cType13
Else
	Type := cType3
return

f_WDn:
Action := Action6
,	Details := "WheelDown"
,	Details .= ", " CCount
If SE = 1
	Details := "{Click, " Details "}", Type := cType13
Else
	Type := cType3
return

Click:
GuiControl, 5:, CL, 1
Gui, 5:Submit, NoHide
GuiControl, 5:Disable, IniX
GuiControl, 5:Disable, IniY
GuiControl, 5:Disable, MouseGetI
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Disable, MRel
GuiControl, 5:Enable, LB
GuiControl, 5:Enable, RB
GuiControl, 5:Enable, MB
GuiControl, 5:Enable, X1
GuiControl, 5:Enable, X2
GuiControl, 5:Enable, Clicks
GuiControl, 5:Enable, CCount
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, DefCt
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Enable, Ident
GuiControl, 5:Enable, Title
GuiControl, 5:Enable, GetWin
GuiControl, 5:Enable, CL
GuiControl, 5:Enable, MHold
GoSub, CSend
GuiControl, 5:Disable%SE%, CSend
return

Point:
GuiControl, 5:, CL, 1
Gui, 5:Submit, NoHide
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Enable, IniX
GuiControl, 5:Enable, IniY
GuiControl, 5:Enable, MouseGetI
GuiControl, 5:Enable, MRel
GuiControl, 5:Disable, LB
GuiControl, 5:Disable, RB
GuiControl, 5:Disable, MB
GuiControl, 5:Disable, X1
GuiControl, 5:Disable, X2
GuiControl, 5:Disable, Clicks
GuiControl, 5:Disable, CCount
GuiControl, 5:Enable, CSend
GuiControl, 5:Disable, CSend
GuiControl, 5:Disable, DefCt
GuiControl, 5:Disable, GetCtrl
GuiControl, 5:Disable, Ident
GuiControl, 5:Disable, Title
GuiControl, 5:Disable, GetWin
GuiControl, 5:Enable, CL
GuiControl, 5:Disable, MHold
GuiControl, 5:Disable, CSend
return

PClick:
GuiControl, 5:, CL, 1
Gui, 5:Submit, NoHide
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Enable, IniX
GuiControl, 5:Enable, IniY
GuiControl, 5:Enable, MouseGetI
GuiControl, 5:Enable, MRel
GuiControl, 5:Enable, LB
GuiControl, 5:Enable, RB
GuiControl, 5:Enable, MB
GuiControl, 5:Enable, X1
GuiControl, 5:Enable, X2
GuiControl, 5:Enable, Clicks
GuiControl, 5:Enable, CCount
GuiControl, 5:Enable, CSend
GuiControl, 5:Disable, CSend
GuiControl, 5:Disable, DefCt
GuiControl, 5:Disable, GetCtrl
GuiControl, 5:Disable, Ident
GuiControl, 5:Disable, Title
GuiControl, 5:Disable, GetWin
GuiControl, 5:Enable, CL
GuiControl, 5:Enable, MHold
GuiControl, 5:Disable, CSend
return

Drag:
Gui, 5:Submit, NoHide
GuiControl, 5:Enable, IniX
GuiControl, 5:Enable, IniY
GuiControl, 5:Enable, MouseGetI
GuiControl, 5:Enable, EndX
GuiControl, 5:Enable, EndY
GuiControl, 5:Enable, MouseGetE
GuiControl, 5:Enable, MRel
GuiControl, 5:Enable, LB
GuiControl, 5:Enable, RB
GuiControl, 5:Enable, MB
GuiControl, 5:Enable, X1
GuiControl, 5:Enable, X2
GuiControl, 5:Disable, Clicks
GuiControl, 5:Disable, CCount
GuiControl, 5:Disable, CSend
GuiControl, 5:Disable, DefCt
GuiControl, 5:Disable, GetCtrl
GuiControl, 5:Disable, Ident
GuiControl, 5:Disable, Title
GuiControl, 5:Disable, GetWin
GuiControl, 5:, SE, 1
GuiControl, 5:Disable, CL
GuiControl, 5:Disable, MHold
GuiControl, 5:Disable, CSend
return

WUp:
GuiControl, 5:, CL, 1
Gui, 5:Submit, NoHide
GuiControl, 5:Disable, IniX
GuiControl, 5:Disable, IniY
GuiControl, 5:Disable, MouseGetI
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Disable, MRel
GuiControl, 5:Disable, LB
GuiControl, 5:Disable, RB
GuiControl, 5:Disable, MB
GuiControl, 5:Disable, X1
GuiControl, 5:Disable, X2
GuiControl, 5:Enable, Clicks
GuiControl, 5:Enable, CCount
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, DefCt
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Enable, Ident
GuiControl, 5:Enable, Title
GuiControl, 5:Enable, GetWin
GuiControl, 5:Enable, CL
GuiControl, 5:Disable, MHold
GuiControl, 5:Disable%SE%, CSend
GoSub, CSend
return

WDn:
GuiControl, 5:, CL, 1
Gui, 5:Submit, NoHide
GuiControl, 5:Disable, IniX
GuiControl, 5:Disable, IniY
GuiControl, 5:Disable, MouseGetI
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Disable, MRel
GuiControl, 5:Disable, LB
GuiControl, 5:Disable, RB
GuiControl, 5:Disable, MB
GuiControl, 5:Disable, X1
GuiControl, 5:Disable, X2
GuiControl, 5:Enable, Clicks
GuiControl, 5:Enable, CCount
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, DefCt
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Enable, Ident
GuiControl, 5:Enable, Title
GuiControl, 5:Enable, GetWin
GuiControl, 5:Enable, CL
GuiControl, 5:Disable, MHold
GuiControl, 5:Disable%SE%, CSend
GoSub, CSend
return

CL:
Gui, 5:Submit, NoHide
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, DefCt
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Enable, Ident
GuiControl, 5:Enable, Title
GuiControl, 5:Enable, GetWin
If Click = 1
	GoSub, Click
If Point = 1
	GoSub, Point
If PClick = 1
	GoSub, PClick
If Drag = 1
	GoSub, Drag
If WUp = 1
	GoSub, WUp
If WDn = 1
	GoSub, WDn
return

SE:
Gui, 5:Submit, NoHide
GuiControl, 5:Disable, CSend
GuiControl, 5:Disable, DefCt
GuiControl, 5:Disable, GetCtrl
GuiControl, 5:Disable, Ident
GuiControl, 5:Disable, Title
GuiControl, 5:Disable, GetWin
GuiControl, 5:, MRel, 0
return

MRel:
Gui, 5:Submit, NoHide
If ((Click = 1) || (WUp = 1) || (WDn = 1))
{
	GuiControl, 5:Enable%MRel%, DefCt
	GuiControl, 5:Enable%MRel%, GetCtrl
}
return

MHold:
Gui, 5:Submit, NoHide
If MHold = 0
{
	GuiControl, 5:Enable, Clicks
	GuiControl, 5:Enable, CCount
}
If MHold = 1
{
	GuiControl, 5:Disable, Clicks
	GuiControl, 5:Disable, CCount
}
If MHold = -1
{
	GuiControl, 5:Disable, Clicks
	GuiControl, 5:Disable, CCount
}
return

MouseGetI:
CoordMode, Mouse, %CoordMouse%
Gui, 5:Submit, NoHide
NoKey := 1
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
WaitFor.Key("RButton")
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
GuiControlGet, CtrlState, Enabled, DefCt
If (A_GuiControl = "MouseGet")
{
	GuiControl,, Par2File, %xPos%
	GuiControl,, Par3File, %yPos%
	return
}
If CtrlState = 1
{
	GuiControl,, IniX, %xcpos%
	GuiControl,, IniY, %ycpos%
}
Else
{
	GuiControl,, IniX, %xPos%
	GuiControl,, IniY, %yPos%
}
StopIt := 1
return

MouseGetE:
CoordMode, Mouse, %CoordMouse%
NoKey := 1
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
WaitFor.Key("RButton")
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
GuiControl,, EndX, %xPos%
GuiControl,, EndY, %yPos%
StopIt := 1
return

GetEl:
Gui, 24:Submit, NoHide
Gui, 24:+OwnDialogs
If (TabControl = 2)
{
	If ((ComHwnd = "") || (ComCLSID = ""))
	{
		MsgBox, 16, %d_Lang007%, %d_Lang048%
		return
	}
}
Else
	ControlGet, SelIEWinName, Choice,, ComboBox2, ahk_id %CmdWin%
CoordMode, Mouse, Window
NoKey := 1
WinMinimize, ahk_id %CmdWin%
ComObjError(false)
If (TabControl = 2)
	o_ie := %ComHwnd%
Else
{
	SelIEWin := IEWindows
	If (SelIEWinName = "[blank]")
		o_ie := ""
	Else
	{
		o_ie := IEGet(SelIEWinName)
		DetectHiddenWindows, On
		WinActivate, %SelIEWinName%
		DetectHiddenWindows, Off
	}
}
If !IsObject(o_ie)
{
	o_ie := COMInterface("Visible := true")
	COMInterface("Navigate(about:blank)", o_ie)
}
SetTimer, WatchCursorIE, 100
StopIt := 0
WaitFor.Key("RButton")
SetTimer, WatchCursorIE, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
{
	ComObjError(true)
	Exit
}
If (oel_%Ident% <> "")
{
	ElIndex := GetElIndex(Element, Ident)
	GuiControl,, DefEl, % oel_%Ident%
	GuiControl,, DefElInd, %ElIndex%
}
Else If (oel_Name <> "")
{
	ElIndex := GetElIndex(Element, "Name"), f_ident := "Name"
	GuiControl,, DefEl, % oel_Name
	GuiControl,, DefElInd, %ElIndex%
	GuiControl, ChooseString, Ident, Name
}
Else If (oel_ID <> "")
{
	ElIndex := GetElIndex(Element, "ID")
	GuiControl,, DefEl, %oel_ID%
	GuiControl,, DefElInd, %ElIndex%
	GuiControl, ChooseString, Ident, ID
}
Else If (oel_TagName <> "")
{
	ElIndex := GetElIndex(Element, "TagName")
	GuiControl,, DefEl, %oel_tagName%
	GuiControl,, DefElInd, %ElIndex%
	GuiControl, ChooseString, Ident, TagName
}
Else If (oel_InnerText <> "")
{
	ElIndex := GetElIndex(Element, "Links")
	GuiControl,, DefEl, Links
	GuiControl,, DefElInd, %ElIndex%
	GuiControl, ChooseString, Ident, Links
}
If (TabControl = 2)
{
	Gui, 24:Submit, NoHide
	ComExpSc := IEComExp("", "", oel_%Ident%, ElIndex, "", Ident)
,	ComExpSc := SubStr(ComExpSc, 4, StrLen(ComExpSc)-6)
	GuiControl,, ComSc, %ComExpSc%
}
ComObjError(true)
StopIt := 1
return

GetCtrl:
CoordMode, Mouse, %CoordMouse%
NoKey := 1
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
WaitFor.Key("RButton")
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
GuiControl,, DefCt, %control%
GuiControl,, Title, ahk_class %class%
FoundTitle := "ahk_class " class, Window := "ahk_class " class, StopIt := 1
return

GetWin:
CoordMode, Mouse, %CoordMouse%
Gui, Submit, NoHide
NoKey := 1
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
WaitFor.Key("RButton")
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
If Ident = Title
{
	If Label = IfGet
	{
		FoundTitle := Title
		return
	}
	GuiControl,, Title, %Title%
}
Else If Ident = Class
{
	GuiControl,, Title, ahk_class %class%
	FoundTitle := "ahk_class " class
}
Else If Ident = Process
{
	GuiControl,, Title, ahk_exe %pname%
	FoundTitle := "ahk_exe " pname
}
Else If Ident = ID
{
	GuiControl,, Title, ahk_id %id%
	FoundTitle := "ahk_id " id
}
Else If Ident = PID
{
	GuiControl,, Title, ahk_pid %pid%
	FoundTitle := "ahk_pid " pid
}
StopIt := 1
return

WinGetP:
CoordMode, Mouse, %CoordMouse%
Gui, Submit, NoHide
NoKey := 1
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
WaitFor.Key("RButton")
WinGetPos, X, Y, W, H, ahk_id %id%
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
GuiControl,, PosX, %X%
GuiControl,, PosY, %Y%
GuiControl,, SizeX, %W%
GuiControl,, SizeY, %H%
StopIt := 1
return

CtrlGetP:
CoordMode, Mouse, %CoordMouse%
Gui, Submit, NoHide
NoKey := 1
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
WaitFor.Key("RButton")
ControlGetPos, X, Y, W, H, %control%, ahk_id %id%
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
GuiControl,, PosX, %X%
GuiControl,, PosY, %Y%
GuiControl,, SizeX, %W%
GuiControl,, SizeY, %H%
StopIt := 1
return

Screenshot:
Gui, +OwnDialogs
If !IsFunc("Gdip_Startup")
{
	MsgBox, 17, %d_Lang007%, %d_Lang040%
	IfMsgBox, OK
		Run, http://www.autohotkey.com/board/topic/29449-gdi-standard-library
	return
}
SS := 1
GetArea:
Gui, Submit, NoHide
Draw := 1
WinMinimize, ahk_id %CmdWin%
FirstCall := True
CoordMode, Mouse, Screen
Gui, 20:-Caption +ToolWindow +LastFound +AlwaysOnTop
Gui, 20:Color, Red
SetTimer, WatchCursor, 100
Return

DrawStart:
SetTimer, WatchCursor, Off
CoordMode, Mouse, %CoordPixel%
MouseGetPos, iX, iY
CoordMode, Mouse, Screen
MouseGetPos, OriginX, OriginY
SetTimer, DrawRectangle, 0
KeyWait, %DrawButton%
GoSub, DrawEnd
Return

DrawEnd:
SetTimer, DrawRectangle, Off
FirstCall := True
ToolTip
CoordMode, Mouse, %CoordPixel%
MouseGetPos, eX, eY
If ((iX = eX) || (iY = eY))
	MarkArea(LineW)
Else
	GoSub, ShowAreaTip
If OnRelease
	GoSub, Restore
Return

Restore:
Tooltip
Gui, 20:+LastFound
WinGetPos, wX, wY, wW, wH
Gui, 20:Cancel
AdjustCoords(iX, iY, eX, eY)
Sleep, 200
Draw := 0
If SS = 1
{
	If (ScreenDir = "")
		ScreenDir := A_AppData "\MacroCreator\Screenshots"
	IfNotExist, %ScreenDir%
		FileCreateDir, %ScreenDir%
	file := ScreenDir "\Screen_" A_Now ".png", screen := wX "|" wY "|" wW "|" wH
	Screenshot(file, screen)
	GuiControl, 19:, ImgFile, %file%
	GoSub, MakePrev
	SS := 0
	WinActivate, ahk_id %CmdWin%
	return
}
If ((iX = eX) || (iY = eY)) && (control <> "")
	GuiControl, 19:ChooseString, CoordPixel, Window
iX := wX, iY := wY, eX := wX + wW, eY := wY + wH
WinActivate, ahk_id %CmdWin%
GuiControl, 19:, iPosX, %iX%
GuiControl, 19:, iPosY, %iY%
GuiControl, 19:, ePosX, %eX%
GuiControl, 19:, ePosY, %eY%
return

GetPixel:
CoordMode, Mouse, %CoordPixel%
NoKey := 1
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 10
StopIt := 0
WaitFor.Key("RButton")
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
If (A_GuiControl = "TransCS")
{
	GuiControl, 19:, TransC, %color%
}
Else
{
	GuiControl,, ImgFile, %color%
	GuiControl, +Background%color%, ColorPrev
}
StopIt := 1
return

WatchCursor:
CoordMode, Mouse, % (Draw) ? CoordPixel : CoordMouse
MouseGetPos, xPos, yPos, id, control
WinGetTitle, title, ahk_id %id%
WinGetClass, class, ahk_id %id%
WinGetText, text, ahk_id %id%
text := SubStr(text, 1, 50)
WinGet, pid, PID, ahk_id %id%
PixelGetColor, color, %xPos%, %yPos%, RGB
WinGet, pname, ProcessName, ahk_id %id%
ControlGetPos, cX, cY, cW, cH, %control%, ahk_id %id%
xcpos := Controlpos(xPos, cx), ycpos := Controlpos(yPos, cy)
If Draw
	ToolTip,
	(LTrim
	X%xPos% Y%yPos%
	%c_Lang004%: %control%
	%d_Lang034%
	)
Else
	ToolTip,
	(LTrim
	X%xPos% Y%yPos%
	%c_Lang004%: %control% X%xcpos% Y%ycpos%
	%d_Lang018%: %color%
	
	WinTitle: %title%
	Class: %class%
	Process: %pname%
	ID: %id%
	PID: %pid%
	
	WinText: %text% (...)
	
	%d_Lang017%
	)
return

WatchCursorIE:
CoordMode, Mouse, Window
MouseGetPos, xPos, yPos, id
WinGetClass, class, ahk_id %id%
If (class <> "IEFrame")
{
	Tooltip, %d_Lang045%
	return
}
If (L_Label = "InternetExplorer.Application")
	Tooltip, %d_Lang017%
Else
{
	ControlGetPos, IEFrameX, IEFrameY, IEFrameW, IEFrameH, Internet Explorer_Server1, ahk_class IEFrame
	Element := o_ie.document.elementFromPoint(xPos-IEFrameX, yPos-IEFrameY)
,	oel_Name := Element.Name, oel_ID := Element.ID
,	oel_TagName := Element.TagName, oel_Value := Element.Value
,	oel_InnerText := (StrLen(Element.InnerText) > 50) ? SubStr(Element.InnerText, 1, 50) "..." : Element.InnerText
,	oel_Type := Element.Type
,	oel_Checked := Element.Checked, oel_SelectedIndex := Element.SelectedIndex
,	oel_SourceIndex := Element.sourceindex, oel_Links := "Links"
,	oel_OffsetLeft := Element.OffsetLeft, oel_OffsetTop := Element.OffsetTop

	Tooltip  % "Name: " oel_Name
		. "`nID: " oel_ID
		. "`nTagName: " oel_TagName
		. "`nValue: " oel_Value
		. "`nInnerText: " oel_InnerText
		. "`nType: " oel_Type
		. "`nChecked: " oel_Checked
		. "`nSelectedIndex: " oel_SelectedIndex
		. "`nSourceIndex: " oel_SourceIndex
		. "`nPosition: " oel_OffsetLeft " x " oel_OffsetTop
}
return

WatchCursorXL:
CoordMode, Mouse, Window
MouseGetPos, xPos, yPos, id
WinGetClass, class, ahk_id %id%
If (class <> "XLMAIN")
{
	Tooltip, %d_Lang054%
	return
}
Tooltip, %d_Lang017%
return

DrawRectangle:
CoordMode, Mouse, Screen
MouseGetPos, X2, Y2
; Has the mouse moved?
If (XO = X2) && (YO = Y2)
  Return
Gui, 20:+LastFound
XO := X2, YO := Y2
; Allow dragging to the left of the click point.
If (X2 < OriginX)
  X1 := X2, X2 := OriginX
Else
  X1 := OriginX
; Allow dragging above the click point.
If (Y2 < OriginY)
  Y1 := Y2, Y2 := OriginY
Else
  Y1 := OriginY
; Draw the rectangle
W1 := X2 - X1, H1 := Y2 - Y1, W2 := W1 - LineW, H2 := H1 - LineW
WinSet, Region, 0-0 %W1%-0 %W1%-%H1% 0-%H1% 0-0  %LineW%-%LineW% %W2%-%LineW% %W2%-%H2% %LineW%-%H2% %LineW%-%LineW%
If (FirstCall) {
  Gui, 20:Show, NA x%X1% y%Y1% w%W1% h%H1%
  FirstCall := False
}
WinMove, , , X1, Y1, W1, H1
If ((X2 > OriginX) || (Y2 > OriginY))
	ToolTip, X%X1% Y%Y1%`nX%X2% Y%Y2%`n%d_Lang034%
Else
	ToolTip, X%X1% Y%Y1%`nX%X2% Y%Y2%`n%d_Lang034%, % OriginX +8, % OriginY +8
Return

ShowAreaTip:
Gui, 20:+LastFound
WinGetPos,,, gwW, gwH
Tooltip,
(
%c_Lang059%: %gwW% x %gwH%
%d_Lang057%
)
return

EditText:
s_Caller = Edit
Text:
Gui, 1:Submit, NoHide
Gui, 8:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 8:Add, Custom, ClassToolbarWindow32 hwndhTbText gTbText 0x0800 0x0100 0x0040
Gui, 8:Add, Edit, Section xm ym+25 vTextEdit gTextEdit WantTab W710 R30
; Options
Gui, 8:Add, GroupBox, Section W220 H125, %c_Lang163%:
Gui, 8:Add, Radio, -Wrap Group Checked ys+20 xs+10 W200 vRaw gRaw R1, %c_Lang045%
Gui, 8:Add, Radio, -Wrap W200 vComText gComText R1, %c_Lang046%
Gui, 8:Add, Radio, -Wrap W200 vClip gClip R1, %c_Lang047%
Gui, 8:Add, Radio, -Wrap W200 vEditPaste gEditPaste R1, %c_Lang048%
Gui, 8:Add, Radio, -Wrap W200 vSetText gSetText R1, %c_Lang049%
; Repeat
Gui, 8:Add, GroupBox, Section ys x+20 W220 H125
Gui, 8:Add, Text, ys+15 xs+10, %w_Lang015%:
Gui, 8:Add, Text,, %c_Lang017%:
Gui, 8:Add, Edit, ys+15 xs+110 W100 R1 vEdRept
Gui, 8:Add, UpDown, vTimesX 0x80 Range1-999999999, 1
Gui, 8:Add, Edit, W100 vDelayC
Gui, 8:Add, UpDown, vDelayX 0x80 Range0-999999999, %DelayG%
Gui, 8:Add, Radio, -Wrap Checked W100 vMsc R1, %c_Lang018%
Gui, 8:Add, Radio, -Wrap W100 vSec R1, %c_Lang019%
; Control
Gui, 8:Add, GroupBox, Section ys x+20 W250 H125
Gui, 8:Add, Checkbox, -Wrap ys+15 xs+10 W160 vCSend gCSend R1, %c_Lang016%:
Gui, 8:Add, Edit, vDefCt W200 Disabled
Gui, 8:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl Disabled, ...
Gui, 8:Add, DDL, y+5 xs+10 W65 vIdent Disabled, Title||Class|Process|ID|PID
Gui, 8:Add, Text, -Wrap yp+5 x+5 W140 H20 vWinParsTip Disabled, %wcmd_All%
Gui, 8:Add, Edit, y+5 xs+10 W200 vTitle Disabled, A
Gui, 8:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin Disabled, ...
; Buttons
Gui, 8:Add, Button, -Wrap Section Default xm W75 H23 gTextOK, %c_Lang020%
Gui, 8:Add, Button, -Wrap ys W75 H23 gTextCancel, %c_Lang021%
Gui, 8:Add, Button, -Wrap ys W75 H23 vTextApply gTextApply Disabled, %c_Lang131%
Gui, 8:Add, StatusBar
Gui, 8:Default
SB_SetParts(480, 80)
SB_SetText(c_Lang025, 1)
SB_SetText("length: " 0, 2)
SB_SetText("lines: " 0, 3)
If (s_Caller = "Edit")
{
	EscCom("Details|TimesX|DelayX|Target|Window", 1)
	StringReplace, Details, Details, ``n, `n, All
	GuiControl, 8:, TextEdit, %Details%
	GuiControl, 8:, TimesX, %TimesX%
	GuiControl, 8:, EdRept, %TimesX%
	GuiControl, 8:, DelayX, %DelayX%
	GuiControl, 8:, DelayC, %DelayX%
	If InStr(Type, "Control")
	{
		GuiControl, 8:, CSend, 1
		GuiControl, 8:Enable, DefCt
		GuiControl, 8:Enable, GetCtrl
		GuiControl, 8:Enable, Ident
		GuiControl, 8:Enable, Title
		GuiControl, 8:Enable, GetWin
		GuiControl, 8:, Title, %Window%
		GuiControl, 8:, DefCt, %Target%
	}
	If ((Type = cType1) || (Type = cType2))
		GuiControl, 8:, ComText, 1
	Else If ((Type = cType8) || (Type = cType9))
		GuiControl, 8:, Raw, 1
	Else If (Type = cType10)
	{
		GuiControl, 8:, SetText, 1
		GuiControl, 8:Disable, CSend
	}
	Else If (Type = cType22)
	{
		GuiControl, 8:, EditPaste, 1
		GuiControl, 8:Disable, CSend
	}
	Else If (Type = cType12)
		GuiControl, 8:, Clip, 1
	Gui, 8:Default
		GoSub, TextEdit
	Gui, chMacro:Default
	GuiControl, 8:Enable, TextApply
}
If (s_Caller = "Find")
{
	Gui, 8:Default
	If (GotoRes1 = cType8)
	{
		GuiControl, 8:, Raw, 1
		GoSub, Raw
	}
	Else If (GotoRes1 = cType1)
	{
		GuiControl, 8:, ComText, 1
		GoSub, ComText
	}
	Else If (GotoRes1 = cType12)
	{
		GuiControl, 8:, Clip, 1
		GoSub, Clip
	}
	Else If (GotoRes1 = cType22)
	{
		GuiControl, 8:, EditPaste, 1
		GoSub, EditPaste
	}
	Else If (GotoRes1 = cType10)
	{
		GuiControl, 8:, SetText, 1
		GoSub, SetText
	}
}
Gui, 8:Show,, %c_Lang002%
TB_Define(TbText, hTbText, hIL_Icons, FixedBar.Text, FixedBar.TextOpt)
,	TBHwndAll[7] := TbText
GuiControl, 8:Focus, TextEdit
Input
Tooltip
return

TextApply:
TextOK:
Gui, 8:+OwnDialogs
Gui, 8:Submit, NoHide
StringReplace, TextEdit, TextEdit, `n, ``n, All
DelayX := InStr(DelayC, "%") ? DelayC : DelayX, TimesX := InStr(EdRept, "%") ? EdRept : TimesX
If Raw = 1
	Type := cType8
Else If ComText = 1
	Type := cType1
Else If SetText = 1
	Type := cType10
Else If EditPaste = 1
	Type := cType22
Else If Clip = 1
	Type := cType12
GuiControlGet, CtrlState, Enabled, DefCt
If CtrlState = 1
{
	If CSend = 1
	{
		If DefCt = 
		{
			MsgBox, 52, %d_Lang011%, %d_Lang012%
			IfMsgBox, No
				return
		}
		Target := DefCt, Window := Title
		If (Type = cType1)
			Type := cType2
		If (Type = cType8)
			Type := cType9
	}
	Else
	{
		If CSend = 0
		{
			Target := "", Window := ""
			If (Type = cType2)
				Type := cType1
			If (Type = cType9)
				Type := cType8
		}
	}
}
Else
	Target := "", Window := ""
Action := "[Text]"
EscCom("TextEdit|TimesX|DelayX|Target|Window")
If (A_ThisLabel <> "TextApply")
{
	Gui, 1:-Disabled
	Gui, 8:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
{
	LV_Modify(RowNumber, "Col2", Action, TextEdit, TimesX, DelayX, Type, Target, Window)
}	
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Action, TextEdit, TimesX, DelayX, Type, Target, Window)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, Action, TextEdit, TimesX, DelayX, Type, Target, Window)
		RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "TextApply")
	Gui, 8:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

TextCancel:
8GuiClose:
8GuiEscape:
Gui, 1:-Disabled
Gui, 8:Destroy
s_Caller = 
return

Raw:
GuiControl, Enable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GoSub, CSend
return

ComText:
GuiControl, Enable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GoSub, CSend
return

SetText:
GuiControl, , CSend, 1
GuiControl, Disable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GoSub, CSend
return

Clip:
GuiControl, Enable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GoSub, CSend
return

EditPaste:
GuiControl, , CSend, 1
GuiControl, Disable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GoSub, CSend
return

TextEdit:
Gui, Submit, NoHide
StringSplit, cL, TextEdit, `n
SB_SetText("length: " StrLen(TextEdit), 2)
SB_SetText("lines: " cL0, 3)
return

OpenT:
Gui, +OwnDialogs
FileSelectFile, TextFile, 3
FreeMemory()
If !TextFile
	return
FileRead, InText, %TextFile%
GuiControl,, TextEdit, %InText%
GoSub, TextEdit
return

SaveT:
Gui, Submit, NoHide
Gui +OwnDialogs
FileSelectFile, TextFile, S16
FreeMemory()
If TextFile = 
	Exit
SplitPath, TextFile,,, ext
If (ext = "")
	TextFile .= ".txt"
IfExist %TextFile%
{
    FileDelete %TextFile%
    If ErrorLevel
    {
        MsgBox, 16, %d_Lang007%, %d_Lang006% "%TextFile%".
        return
    }
}
FileAppend, %TextEdit%, %TextFile%
return

CutT:
PostMessage, WM_CUT, 0, 0, Edit1, ahk_id %CmdWin%
return

CopyT:
PostMessage, WM_COPY, 0, 0, Edit1, ahk_id %CmdWin%
return

PasteT:
PostMessage, WM_PASTE, 0, 0, Edit1, ahk_id %CmdWin%
return

SelAllT:
PostMessage, 0x00B1, 0, StrLen(TextEdit) + cL0, Edit1, ahk_id %CmdWin%
return

RemoveT:
PostMessage, WM_CLEAR, 0, 0, Edit1, ahk_id %CmdWin%
return

KeyWait:
MsgBox:
Pause:
Gui, 3:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 3:Add, Tab2, W305 H0 vTabControl AltSubmit, %c_Lang003%|%c_Lang015%|%c_Lang066%
; Sleep
Gui, 3:Add, GroupBox, Section xm ym W280 H235
Gui, 3:Add, Text, ys+15 xs+10, %c_Lang050%:
Gui, 3:Add, Edit, yp-2 xs+100 W170 vDelayC
Gui, 3:Add, UpDown, vDelayX 0x80 Range0-9999999, 300
Gui, 3:Add, Radio, -Wrap Checked W170 vMsc R1, %c_Lang018%
Gui, 3:Add, Radio, -Wrap W170 vSec R1, %c_Lang019%
Gui, 3:Add, Radio, -Wrap W170 vMin R1, %c_Lang154%
; MsgBox
Gui, 3:Tab, 2
Gui, 3:Add, GroupBox, Section ym xm W280 H235
Gui, 3:Add, Text, -Wrap Section ys+15 xs+10 W260 R1, %c_Lang051%:
Gui, 3:Add, Edit, vMsgPt W260 r6
Gui, 3:Add, Text, W260, %c_Lang025%
Gui, 3:Add, Text, yp+30 W210, %c_Lang147%:
Gui, 3:Add, Radio, -Wrap Checked W80 vNoI R1, %c_Lang148%
Gui, 3:Add, Radio, -Wrap x+5 W80 vErr R1, %c_Lang149%
Gui, 3:Add, Radio, -Wrap  x+5 W80 vQue R1, %c_Lang150%
Gui, 3:Add, Radio, -Wrap xs W80 vExc R1, %c_Lang151%
Gui, 3:Add, Radio, -Wrap x+5 W80 vInf R1, %c_Lang152%
Gui, 3:Add, Checkbox, -Wrap W125 xs vAot R1, %c_Lang153%
Gui, 3:Add, Checkbox, -Wrap Checked W125 yp xp+130 vCancelB R1, %c_Lang021%
; KeyWait
Gui, 3:Tab, 3
Gui, 3:Add, GroupBox, Section xm ym W280 H235
Gui, 3:Add, Text, -Wrap Section ys+15 xs+10 W200 R1, %c_Lang052%:
Gui, 3:Add, Hotkey, vWaitKeys gWaitKeys W260
Gui, 3:Add, Text, Section xs vTimoutT, %c_Lang053%:
Gui, 3:Add, Edit, ys-2 xs+90 W170 vTimeoutC
Gui, 3:Add, UpDown, vTimeout 0x80 Range0-999999999, 0
Gui, 3:Add, Text, xs+90, %c_Lang054%
Gui, 3:Tab
Gui, 3:Add, Button, -Wrap Section Default xm W75 H23 gPauseOK, %c_Lang020%
Gui, 3:Add, Button, -Wrap ys W75 H23 gPauseCancel, %c_Lang021%
If (A_ThisLabel = "MsgBox")
	GuiControl, 3:Choose, TabControl, 2
If (A_ThisLabel = "KeyWait")
	GuiControl, 3:Choose, TabControl, 3
Gui, 3:Show, W300, % (A_ThisLabel = "Pause") ? c_Lang003 : (A_ThisLabel = "MsgBox") ? c_Lang015 : c_Lang066
Input
Tooltip
return

MP:
Gui, Submit, NoHide
GuiControl, Enable%MP%, MsgPt
GuiControl, Enable%MP%, NoI
GuiControl, Enable%MP%, Err
GuiControl, Enable%MP%, Que
GuiControl, Enable%MP%, Exc
GuiControl, Enable%MP%, Inf
GuiControl, Enable%MP%, Aot
GuiControl, Enable%MP%, CancelB
GuiControl, Disable%MP%, DelayC
; GuiControl, Disable%MP%, EdRept
GuiControl, Disable%MP%, DelayX
GuiControl, Disable%MP%, Msc
GuiControl, Disable%MP%, Sec
GuiControl, Disable%MP%, KW
return

KW:
Gui, Submit, NoHide
GuiControl, 3:Disable%KW%, DelayC
GuiControl, 3:Disable%KW%, EdRept
GuiControl, 3:Disable%KW%, DelayX
GuiControl, 3:Disable%KW%, Msc
GuiControl, 3:Disable%KW%, Sec
GuiControl, 3:Enable%KW%, WaitKeys
GuiControl, 3:Enable%KW%, TimeoutC
GuiControl, 3:Enable%KW%, Timeout
GuiControl, 3:Disable%KW%, MP
return

WaitKeys:
GuiA := ActiveGui(WinExist())
If %A_GuiControl% contains +^,+!,^!,+^!
	GuiControl, %GuiA%:, %A_GuiControl%
If %A_GuiControl% contains +
	GuiControl, %GuiA%:, %A_GuiControl%, Shift
If %A_GuiControl% contains ^
	GuiControl, %GuiA%:, %A_GuiControl%, Control
If %A_GuiControl% contains !
	GuiControl, %GuiA%:, %A_GuiControl%, Alt
return

PauseOK:
Gui, Submit, NoHide
DelayX := InStr(DelayC, "%") ? DelayC : DelayX
If Sec = 1
	DelayX *= 1000
Else If Min = 1
	DelayX *= 60000
If TabControl = 2
{
	StringReplace, MsgPT, MsgPT, `n, ``n, All
	StringReplace, MsgPT, MsgPT, `,, ```,, All
	Type := cType6, Details := MsgPT, DelayX := 0
	If NoI = 1
		Target := 0
	If Err = 1
		Target := 16
	If Que = 1
		Target := 32
	If Exc = 1
		Target := 48
	If Inf = 1
		Target := 64
	If Aot = 1
		Target += 262144
	If CancelB = 1
		Target += 1
}
Else If TabControl = 3
{
	If (WaitKeys = "")
		return
	Type := cType20, tKey := WaitKeys
,	Details := tKey, Target := ""
,	DelayX := InStr(TimeoutC, "%") ? TimeoutC : Timeout
}
Else If TabControl = 1
	Type := cType5, Details := "", Target := ""
Gui, 1:-Disabled
Gui, 3:Destroy
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, "[Pause]", Details, 1, DelayX, Type, Target)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, "[Pause]", Details, 1, DelayX, Type, Target)
		RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
GuiControl, Focus, InputList%A_List%
return

PauseCancel:
3GuiClose:
3GuiEscape:
Gui, 1:-Disabled
Gui, 3:Destroy
return

EditLoop:
s_Caller = Edit
AddLabel:
ComGoto:
ComLoop:
Proj_Labels := ""
Loop, %TabCount%
{
	Gui, chMacro:ListView, InputList%A_Index%
	Loop, % ListCount%A_Index%
	{
		LV_GetText(Row_Type, A_Index, 6)
		If (Row_Type = cType35)
		{
			LV_GetText(Row_Label, A_Index, 3)
			Proj_Labels .= Row_Label "|"
		}
	}
}
Gui, chMacro:ListView, InputList%A_List%
Loop, %TabCount%
	Proj_Labels .= "Macro" A_Index "|"
Gui, 12:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 12:Add, Tab2, W320 H0 vTabControl AltSubmit, %c_Lang073%|%c_Lang077%|%c_Lang079%
; Loop
Gui, 12:Add, Groupbox, Section xm ym W320 H260
Gui, 12:Add, Radio, -Wrap Checked ys+27 xs+10 W55 vLoop gLoopType R1, %c_Lang132%
Gui, 12:Add, Radio, -Wrap x+5 W55 vLFilePattern gLoopType R1, %c_Lang133%
Gui, 12:Add, Radio, -Wrap x+5 W55 vLParse gLoopType R1, %c_Lang134%
Gui, 12:Add, Radio, -Wrap x+5 W55 vLRead gLoopType R1, %c_Lang135%
Gui, 12:Add, Radio, -Wrap x+5 W55 R1 vLRegistry gLoopType R1, %c_Lang136%
Gui, 12:Add, Text, y+5 xs+10, %w_Lang015% (%t_Lang004%):
Gui, 12:Add, Edit, W300 R1 vEdRept
Gui, 12:Add, UpDown, vTimesX 0x80 Range0-999999999, 2
Gui, 12:Add, Text, W125 vField1, %c_Lang137%
Gui, 12:Add, CheckBox, -Wrap Check3 yp xp+130 W85 vIncFolders Disabled R1, %c_Lang138%
Gui, 12:Add, CheckBox, -Wrap yp xp+85 W85 vRecurse Disabled R1, %c_Lang139%
Gui, 12:Add, Edit, y+5 xs+10 W270 R1 vLParamsFile Disabled
Gui, 12:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchLParams gSearch Disabled, ...
Gui, 12:Add, Text, y+5 xs+10 W150 vField2, %c_Lang141%
Gui, 12:Add, Text, yp xp+155 W150 vField3, %c_Lang142%
Gui, 12:Add, Edit, y+5 xs+10 W145 R1 vDelim Disabled
Gui, 12:Add, Edit, yp x+10 W145 R1 vOmit Disabled
Gui, 12:Add, Text, y+5 xs+15 r1, %c_Lang074%
Gui, 12:Add, Text, y+5 r1, %c_Lang025%
Gui, 12:Add, Text, -Wrap xs+10 y+15 W75 H23, %c_Lang123%:
Gui, 12:Add, Button, -Wrap yp x+0 W75 H23 gAddBreak, %c_Lang075%
Gui, 12:Add, Button, -Wrap yp x+10 W75 H23 gAddContinue, %c_Lang076%
Gui, 12:Add, Button, -Wrap Section Default xm ys+270 W75 H23 gLoopOK, %c_Lang020%
Gui, 12:Add, Button, -Wrap ys W75 H23 gLoopCancel, %c_Lang021%
Gui, 12:Add, Button, -Wrap ys W75 H23 vLoopApply gLoopApply Disabled, %c_Lang131%
Gui, 12:Tab, 2
; Goto
Gui, 12:Add, Groupbox, Section xm ym W320 H260
Gui, 12:Add, Text, ys+15 xs+10, %c_Lang078%:
Gui, 12:Add, ComboBox, W300 vGoLabel, %Proj_Labels%
Gui, 12:Add, Radio, Checked vGoto, Goto
Gui, 12:Add, Radio, yp x+25 vGosub, Gosub
Gui, 12:Add, Text, y+5 xs+10 r1, %c_Lang025%
Gui, 12:Add, Button, -Wrap Section xm ys+270 W75 H23 gGotoOK, %c_Lang020%
Gui, 12:Add, Button, -Wrap ys W75 H23 gLoopCancel, %c_Lang021%
Gui, 12:Tab, 3
; Label
Gui, 12:Add, Groupbox, Section xm ym W320 H260
Gui, 12:Add, Text, ys+15 xs+10, %c_Lang080%:
Gui, 12:Add, Edit, W300 R1 vNewLabel
Gui, 12:Add, Button, -Wrap Section xm ys+270 W75 H23 gLabelOK, %c_Lang020%
Gui, 12:Add, Button, -Wrap ys W75 H23 gLoopCancel, %c_Lang021%
If (s_Caller = "Edit")
{
	EscCom("Details|TimesX|DelayX", 1)
	StringReplace, Details, Details, ```,, ¢, All
	Loop, Parse, Details, `,, %A_Space%
	{
		Par%A_Index% := A_LoopField
		StringReplace, Par%A_Index%,  Par%A_Index%, ¢, ```,, All
	}
	If (Type = cType7)
	{
		If InStr(TimesX, "%")
			GuiControl, 12:, EdRept, %TimesX%
		Else
			GuiControl, 12:, TimesX, %TimesX%
	}
	If (Type = cType38)
	{
		GuiControl, 12:, LParamsFile, %Details%
		GuiControl, 12:, LRead, 1
	}
	If (Type = cType39)
	{
		GuiControl, 12:, LParamsFile, %Par1%
		GuiControl, 12:, Delim, %Par2%
		GuiControl, 12:, Omit, %Par3%
		GuiControl, 12:, LParse, 1
	}
	If (Type = cType40)
	{
		GuiControl, 12:, LParamsFile, %Par1%
		GuiControl, 12:, IncFolders, % ((Par2 = 2) ? -1 : Par2)
		GuiControl, 12:, Recurse, %Par3%
		GuiControl, 12:, LFilePattern, 1
	}
	If (Type = cType41)
	{
		GuiControl, 12:, Delim, %Par1%
		GuiControl, 12:, LParamsFile, %Par2%
		GuiControl, 12:, IncFolders, % ((Par3 = 2) ? -1 : Par3)
		GuiControl, 12:, Recurse, %Par4%
		GuiControl, 12:, LRegistry, 1
	}
	GuiControl, 12:, TabControl, |%c_Lang073%
	GuiControl, 12:Enable, LoopApply
	GoSub, LoopType
}
Else If (A_ThisLabel = "AddLabel")
	GuiControl, 12:Choose, TabControl, 3
Else If (A_ThisLabel = "ComGoto")
{
	GuiControl, 12:Choose, TabControl, 2
	If (s_Caller = "Find")
		GuiControl, 12:, %GotoRes1%, 1
}
Else If ((s_Caller = "Find") && (InStr(GotoRes1, "Loop")))
{
	StringReplace, GotoRes, GotoRes1, Loop, L
	GuiControl, 12:, %GotoRes%, 1
	GoSub, LoopType
}
Gui, 12:Show,, % (A_ThisLabel = "ComGoto") ? c_Lang077 : (A_ThisLabel = "AddLabel") ? c_Lang079 : c_Lang073
Input
Tooltip
return

LoopApply:
LoopOK:
Gui, 12:+OwnDialogs
Gui, 12:Submit, NoHide
If (LRead = 1)
{
	If (LParamsFile = "")
		return
	Details := RTrim(LParamsFile, ", ")
,	TimesX := 1, Type := cType38
}
Else If (LParse = 1)
{
	If (LParamsFile = "")
		return
	Try
		z_Check := VarSetCapacity(%LParamsFile%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		return
	}
	Details := LParamsFile ", " Delim ", " Omit
,	TimesX := 1, Type := cType39
}
Else If (LFilePattern = 1)
{
	If (LParamsFile = "")
		return
	Details := LParamsFile ", " ((IncFolders = -1) ? 2 : IncFolders) ", " Recurse
,	TimesX := 1, Type := cType40
}
Else If (LRegistry = 1)
{
	If (Delim = "")
		return
	Details := Delim ", " LParamsFile ", " ((IncFolders = -1) ? 2 : IncFolders) ", " Recurse
,	TimesX := 1, Type := cType41
}
Else
{
	Details := "LoopStart", Type := cType7
,	TimesX := InStr(EdRept, "%") ? EdRept : TimesX
}
EscCom("Details")
If (A_ThisLabel <> "LoopApply")
{
	Gui, 1:-Disabled
	Gui, 12:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col3", Details, TimesX, DelayX, Type)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, "[LoopStart]", Details, TimesX, 0, Type)
	LV_Add("Check", ListCount%A_List%+2, "[LoopEnd]", "LoopEnd", 1, 0, "Loop")
	LV_Modify(ListCount%A_List%+2, "Vis")
}
Else
{
	LV_Insert(LV_GetNext(), "Check", "", "[LoopStart]", Details, TimesX, 0, Type)
	RowNumber := 0, LastRow := 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If !RowNumber
		{
			LV_Insert(LastRow+1, "Check",LastRow+1, "[LoopEnd]", "LoopEnd", 1, 0, "Loop")
			break
		}
		LastRow := LV_GetNext(LastRow)
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "LoopApply")
	Gui, 12:Default
Else
{
	s_Caller =
	GuiControl, Focus, InputList%A_List%
}
return

GotoOK:
Gui, 12:+OwnDialogs
Gui, 12:Submit, NoHide
If (GoLabel = "")
	return
If RegExMatch(GoLabel, "[\s,``]")
{
	MsgBox, 16, %d_Lang007%, %d_Lang049%
	return
}
Gui, 1:-Disabled
Gui, 12:Destroy
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), Type := (Goto = 1) ? "Goto" : "Gosub"
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, "[Goto]", GoLabel, 1, 0, Type)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
	LV_Insert(LV_GetNext(), "Check", "", "[Goto]", GoLabel, 1, 0, Type)
GoSub, b_Start
GoSub, RowCheck
GuiControl, Focus, InputList%A_List%
return

LabelOK:
Gui, 12:+OwnDialogs
Gui, 12:Submit, NoHide
If (NewLabel = "")
	return
Try
	z_Check := VarSetCapacity(%NewLabel%)
Catch
{
	MsgBox, 16, %d_Lang007%, %d_Lang049%
	return
}
Loop, Parse, Proj_Labels, |
	If (A_LoopField = NewLabel)
	{
		MsgBox, 16, %d_Lang007%, %d_Lang050%
		return
	}
Gui, 1:-Disabled
Gui, 12:Destroy
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, "[Label]", NewLabel, 1, 0, cType35)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
	LV_Insert(LV_GetNext(), "Check", "", "[Label]", NewLabel, 1, 0, cType35)
GoSub, b_Start
GoSub, RowCheck
GuiControl, Focus, InputList%A_List%
return

LoopCancel:
12GuiClose:
12GuiEscape:
Gui, 1:-Disabled
Gui, 12:Destroy
s_Caller = 
return

LoopS:
GuiControl, Enable, EdRept
GuiControl, Enable, TimesX
return

LoopE:
GuiControl, Disable, EdRept
GuiControl, Disable, TimesX
return

AddBreak:
AddContinue:
Gui, 12:Submit, NoHide
Gui, 1:-Disabled
Gui, 12:Destroy
Gui, chMacro:Default
Type := LTrim(A_ThisLabel, "Add"), RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Type, "", 1, 0, Type)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
	LV_Insert(LV_GetNext(), "Check", "", Type, "", 1, 0, Type)
GoSub, b_Start
GoSub, RowCheck
GuiControl, Focus, InputList%A_List%
return

LoopType:
Gui, 12:Submit, NoHide
GuiControl, 12:Enable%Loop%, EdRept
GuiControl, 12:Disable%Loop%, LParamsFile
GuiControl, 12:Enable%LParse%, Omit
If (LFilePattern || LRegistry)
{
	GuiControl, 12:Enable, IncFolders
	GuiControl, 12:Enable, Recurse
}
Else
{
	GuiControl, 12:Disable, IncFolders
	GuiControl, 12:Disable, Recurse
}
If (LParse || LRegistry)
	GuiControl, 12:Enable, Delim
Else
	GuiControl, 12:Disable, Delim
If (LRead || LFilePattern)
	GuiControl, 12:Enable, SearchLParams
Else
	GuiControl, 12:Disable, SearchLParams
GuiControl, 12:, Field1, % (LParse ? c_Lang140 : (LRead ? c_Lang143 : (LRegistry ? c_Lang144 : c_Lang137)))
GuiControl, 12:, Field2, % (LRegistry ? c_Lang145 : c_Lang141)
GuiControl, 12:Text, IncFolders, % (LRegistry ? c_Lang146 : c_Lang138)
return

EditWindow:
s_Caller = Edit
Window:
Gui, 11:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 11:Add, DDL, W120 vWinCom gWinCom, %WinCmdList%
Gui, 11:Add, Text, xm W120, %c_Lang055%:
Gui, 11:Add, DDL, xm W120 -Multi vWCmd gWCmd, %WinCmd%
Gui, 11:Add, Text, vTValue Disabled, 255
Gui, 11:Add, Slider, yp+10 Buddy2TValue vN gN Range0-255 Disabled, 255
Gui, 11:Add, Radio, -Wrap Checked yp+2 xp+150 vAoT R1, Toggle
Gui, 11:Add, Radio, -Wrap yp xp+70 R1, On
Gui, 11:Add, Radio, -Wrap yp xp+70 R1, Off
Gui, 11:Add, Text, xm W80 vValueT, %c_Lang056%:
Gui, 11:Add, Edit, xm W430 -Multi Disabled vValue
Gui, 11:Add, Text, xm W180, %c_Lang057%:
Gui, 11:Add, Edit, xm W430 -Multi Disabled vVarName
Gui, 11:Add, DDL, Section xm W65 vIdent, Title||Class|Process|ID|PID
Gui, 11:Add, Text, -Wrap yp+5 x+5 W240 H20 vWinParsTip Disabled, %wcmd_WinSet%
Gui, 11:Add, Edit, xm W400 vTitle, A
Gui, 11:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin, ...
Gui, 11:Add, Text, Section ym+5 xm+195, %c_Lang058%
Gui, 11:Add, Text, yp xp+50, X:
Gui, 11:Add, Edit, yp-3 xp+15 vPosX W55 Disabled
Gui, 11:Add, Text, yp+3 x+10, Y:
Gui, 11:Add, Edit, yp-3 xp+15 vPosY W55 Disabled
Gui, 11:Add, Button, -Wrap yp-2 x+5 W30 H23 vWinGetP gWinGetP Disabled, ...
Gui, 11:Add, Text, xs, %c_Lang059%
Gui, 11:Add, Text, yp xp+50, W:
Gui, 11:Add, Edit, yp-3 xp+15 vSizeX W55 Disabled
Gui, 11:Add, Text, yp+3 x+10, H:
Gui, 11:Add, Edit, yp-3 xp+15 vSizeY W55 Disabled
Gui, 11:Add, Button, -Wrap Section Default xm W75 H23 gWinOK, %c_Lang020%
Gui, 11:Add, Button, -Wrap ys W75 H23 gWinCancel, %c_Lang021%
Gui, 11:Add, Button, -Wrap ys W75 H23 vWinApply gWinApply Disabled, %c_Lang131%
Gui, 11:Add, Text, ys W180 r2 vCPosT
If (s_Caller = "Edit")
{
	EscCom("Details|TimesX|DelayX|Target|Window", 1)
	WinCom := Type
	GuiControl, 11:ChooseString, WinCom, %WinCom%
	GoSub, WinCom
	If (Type = "WinSet")
	{
		WCmd := RegExReplace(Details, "(^\w*).*", "$1")
	,	Values := RegExReplace(Details, "^\w*, ?(.*)", "$1")
		GuiControl, 11:ChooseString, WCmd, %WCmd%
		SetTitleMatchMode, 3
		If (WCmd = "AlwaysOnTop")
			GuiControl, 11:, %Values%, 1
		Else If (WCmd = "Transparent")
		{
			GuiControl, 11:, N, %Values%
			GuiControl, 11:, TValue, %Values%
		}
		Else If InStr(Details, ",")
			GuiControl, 11:, Value, %Values%
		SetTitleMatchMode, 2
		GoSub, WCmd
	}
	Else If (Type = "WinMove")
	{
		Loop, Parse, Details, `,,%A_Space%
			Par%A_Index% := A_LoopField
		GuiControl, 11:, PosX, %Par1%
		GuiControl, 11:, PosY, %Par2%
		GuiControl, 11:, SizeX, %Par3%
		GuiControl, 11:, SizeY, %Par4%
	}
	Else If InStr(WinCom, "Get")
	{
		Loop, Parse, Details, `,, %A_Space%
			Par%A_Index% := A_LoopField
		GuiControl, 11:, VarName, %Par1%
		GuiControl, 11:ChooseString, WCmd, %Par2%
	}
	Else
		GuiControl, 11:, Value, %Details%
	GuiControl, 11:, Title, %Window%
	GuiControl, 11:Enable, WinApply
}
If (s_Caller = "Find")
{
	GuiControl, 11:ChooseString, WinCom, %GotoRes1%
	GoSub, WinCom
	
	
	If InStr(WinCmd, GotoRes1)
	{
		GuiControl, 11:ChooseString, WCmd, %GotoRes1%
		GoSub, WCmd
	}
	Else If InStr(WinGetCmd, GotoRes1)
	{
		GuiControl, 11:ChooseString, WinCom, WinGet
		GoSub, WinCom
		GuiControl, 11:ChooseString, WCmd, %GotoRes1%
		GoSub, WCmd
	}
	Else
	{
		GuiControl, 11:ChooseString, WinCom, %GotoRes1%
		GoSub, WinCom
	}
}
Gui, 11:Show, , %c_Lang005%
Tooltip
return

WinApply:
WinOK:
Gui, 11:+OwnDialogs
Gui, 11:Submit, NoHide
If (s_Caller <> "Edit")
	TimesX := 1
GuiControlGet, VState, 11:Enabled, VarName
If (VState = 0)
	VarName := ""
GuiControlGet, VState, 11:Enabled, Value
If (VState = 0)
	Value := ""
If (WinCom = "WinSet")
{
	GuiControlGet, Radio,, Button%AoT%, Text
	Details := WCmd
	If (WCmd = "AlwaysOnTop")
		Details .= ", " Radio
	Else If (WCmd = "Transparent")
		Details .= ", " N
	Else If VState = 1
		Details .= ", " Value
	Else
		Details .= ", "
}
Else If (WinCom = "WinMove")
	Details := PosX ", " PosY ", " SizeX ", " SizeY
Else
	Details := Value
If InStr(WinCom, "MinimizeAll")
	Title := ""
If InStr(WinCom, "Get")
{
	If (VarName = "")
	{
		Tooltip, %c_Lang127%, 15, 210
		return
	}
	Try
		z_Check := VarSetCapacity(%VarName%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		return
	}
	If (WinCom = "WinGet")
		Details := VarName ", " WCmd
	Else
		Details := VarName
	DelayWX := DelayG
}
Else
	DelayWX := DelayW
EscCom("Details|WinCom|Title")
If (A_ThisLabel <> "WinApply")
{
	Gui, 1:-Disabled
	Gui, 11:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", WinCom, Details, TimesX, DelayX, WinCom, "", Title)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, WinCom, Details, TimesX, DelayWX, WinCom, "", Title)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, WinCom, Details, TimesX, DelayWX, WinCom, "", Title)
		RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "WinApply")
	Gui, 11:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

WinCancel:
11GuiClose:
11GuiEscape:
Gui, 1:-Disabled
Gui, 11:Destroy
s_Caller = 
return

WinCom:
Gui, 11:Submit, NoHide
If InStr(WinCom, "Get")
{
	GuiControl, 11:, WCmd, |%WinGetCmd%
	GuiControl, 11:Enable, VarName
}
Else
{
	GuiControl, 11:, WCmd, |%WinCmd%
	GuiControl, 11:Disable, VarName
}
If ((WinCom = "WinSet") || (WinCom = "WinGet"))
	GuiControl, 11:Enable, WCmd
Else
	GuiControl, 11:Disable, WCmd
If (WinCom = "WinMove")
{
	GuiControl, 11:Enable, PosX
	GuiControl, 11:Enable, PosY
	GuiControl, 11:Enable, WinGetP
	GuiControl, 11:Enable, SizeX
	GuiControl, 11:Enable, SizeY
	GuiControl, 11:Enable, SizeY
}
Else
{
	GuiControl, 11:Disable, PosX
	GuiControl, 11:Disable, PosY
	GuiControl, 11:Disable, WinGetP
	GuiControl, 11:Disable, SizeX
	GuiControl, 11:Disable, SizeY
}
If (WinCom = "WinGetPos")
	GuiControl, 11:, CPosT, * %c_Lang060%
Else
	GuiControl, 11:, CPosT
GoSub, WCmd
If WinCom contains Close,Kill,Wait
{
	GuiControl, 11:Enable, Value
	GuiControl, 11:, ValueT, %c_Lang019%
}
Else
{
	GuiControl, 11:Disable, Value
	GuiControl, 11:, ValueT, %c_Lang056%:
}
If InStr(WinCom, "MinimizeAll")
{
	GuiControl, 11:Disable, Ident
	GuiControl, 11:Disable, Title
	GuiControl, 11:Disable, GetWin
}
Else
{
	GuiControl, 11:Enable, Ident
	GuiControl, 11:Enable, Title
	GuiControl, 11:Enable, GetWin
}
GuiControl, 11:, WinParsTip, % wcmd_%WinCom%
return

WCmd:
Gui, 11:Submit, NoHide
If ((WinCom = "WinSet") && (WCmd = "Transparent"))
{
	GuiControl, 11:Enable, TValue
	GuiControl, 11:Enable, N
}
Else
{
	GuiControl, 11:Disable, TValue
	GuiControl, 11:Disable, N
}
If ((WinCom = "WinSet") && (WCmd = "AlwaysOnTop"))
{
	GuiControl, 11:Enable, Button1
	GuiControl, 11:Enable, Button2
	GuiControl, 11:Enable, Button3
}
Else
{
	GuiControl, 11:Disable, Button1
	GuiControl, 11:Disable, Button2
	GuiControl, 11:Disable, Button3
}
If (WinCom = "WinSet")
{
	If WCmd in Style,ExStyle,Region,TransColor
		GuiControl, 11:Enable, Value
	Else
		GuiControl, 11:Disable, Value
}
Else
	GuiControl, 11:Disable, Value
return

N:
Gui, 11:Submit, NoHide
GuiControl, 11:, TValue, %N%
return

EditImage:
s_Caller = Edit
Image:
Gui, 1:Submit, NoHide
Gui, 19:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 19:Add, GroupBox, Section W275 H240
Gui, 19:Add, Text, ys+15 xs+10, %c_Lang061%
Gui, 19:Add, Text, yp xs+65, X:
Gui, 19:Add, Edit, yp x+5 viPosX W60, 0
Gui, 19:Add, Text, yp x+15, Y:
Gui, 19:Add, Edit, yp x+5 viPosY W60, 0
Gui, 19:Add, Button, -Wrap yp-1 x+5 W30 H23 vGetArea gGetArea, ...
Gui, 19:Add, Text, y+10 xs+10, %c_Lang062%
Gui, 19:Add, Text, yp xs+65, X:
Gui, 19:Add, Edit, yp-3 x+5 vePosX W60, %A_ScreenWidth%
Gui, 19:Add, Text, yp x+15, Y:
Gui, 19:Add, Edit, yp x+5 vePosY W60, %A_ScreenHeight%
Gui, 19:Add, Radio, -Wrap Checked y+10 xs+10 W90 vImageS gImageS R1, %c_Lang063%
Gui, 19:Add, Radio, -Wrap yp xs+145 W90 vPixelS gPixelS R1, %c_Lang064%
Gui, 19:Add, Button, -Wrap yp-1 xs+115 W25 H25 hwndScreenshot vScreenshot gScreenshot ;, %c_Lang065%
	ILButton(Screenshot, ResDllPath ":" 61)
Gui, 19:Add, Button, -Wrap yp xs+240 W25 H25 hwndColorPick vColorPick gSearchImg Disabled
	ILButton(ColorPick, ResDllPath ":" 3)
Gui, 19:Add, Edit, y+10 xs+10 vImgFile W225 R1 -Multi
Gui, 19:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchImg gSearchImg, ...
Gui, 19:Add, Text, y+10 xs+10 W180 H25, %c_Lang067%:
Gui, 19:Add, DDL, yp-2 xs+185 W80 vIfFound gIfFound, Continue||Break|Stop|Prompt|Move|Left Click|Right Click|Middle Click
Gui, 19:Add, Text, y+10 xs+10 W180 H25, %c_Lang068%:
Gui, 19:Add, DDL, yp-2 xs+185 W80 vIfNotFound, Continue||Break|Stop|Prompt
Gui, 19:Add, CheckBox, Checked -Wrap y+5 xs+10 W180 H25 vAddIf, %c_Lang162%
Gui, 19:Add, Text, -Wrap y+0 xs+10 W250 r1 cBlue, %c_Lang069%
; Preview
Gui, 19:Add, Groupbox, Section ys xs+280 W280 H240, %c_Lang072%:
Gui, 19:Add, Pic, ys+20 xs+10 W260 H200 0x100 vPicPrev gPicOpen
Gui, 19:Add, Progress, ys+20 xs+10 W260 H200 Disabled Hidden vColorPrev
Gui, 19:Add, Text, y+0 xs+10 W150 vImgSize
; Options
Gui, 19:Add, GroupBox, Section y+10 xm W275 H115, %c_Lang159%:
Gui, 19:Add, Text, ys+20 xs+10 W80, %c_Lang070%:
Gui, 19:Add, DDL, ys+20 xs+45 W65 vCoordPixel, Screen||Window
Gui, 19:Add, Text, yp+3 xs+115 W85, %c_Lang071%:
Gui, 19:Add, Edit, yp-3 xs+190 vVariatT W45 Number Limit
Gui, 19:Add, UpDown, vVariat 0x80 Range0-255, 0
Gui, 19:Add, Text, y+5 xs+10 W55 r1, %c_Lang147%:
Gui, 19:Add, Edit, yp-3 xp+55 W45 vIconN
Gui, 19:Add, Text, yp+3 xs+115 W65 r1, %c_Lang160%:
Gui, 19:Add, Edit, yp-3 xs+190 W45 vTransC
Gui, 19:Add, Button, -Wrap yp-1 x+0 W30 H23 vTransCS gGetPixel, ...
Gui, 19:Add, Text, y+5 xs+10 W40 r1, %c_Lang161%:
Gui, 19:Add, Text, yp xs+50 W20, W:
Gui, 19:Add, Edit, yp-3 xs+65 W45 vWScale
Gui, 19:Add, Text, yp+3 xs+168 W20, H:
Gui, 19:Add, Edit, yp-3 xs+190 W45 vHScale
Gui, 19:Add, Checkbox, -Wrap y+5 xs+10 W250 vBreakLoop R1, %c_Lang130%
; Repeat
Gui, 19:Add, GroupBox, Section ys xs+280 W275 H115
Gui, 19:Add, Text, ys+15 xs+10, %w_Lang015%:
Gui, 19:Add, Text,, %c_Lang017%:
Gui, 19:Add, Edit, ys+15 xs+145 W120 R1 vEdRept
Gui, 19:Add, UpDown, vTimesX 0x80 Range1-999999999, 1
Gui, 19:Add, Edit, W120 vDelayC
Gui, 19:Add, UpDown, vDelayX 0x80 Range0-999999999, %DelayG%
Gui, 19:Add, Radio, -Wrap Checked W120 vMsc R1, %c_Lang018%
Gui, 19:Add, Radio, -Wrap W120 vSec R1, %c_Lang019%
Gui, 19:Add, Button, -Wrap Section Default xm W75 H23 gImageOK, %c_Lang020%
Gui, 19:Add, Button, -Wrap ys W75 H23 gImageCancel, %c_Lang021%
Gui, 19:Add, Button, -Wrap ys W75 H23 vImageApply gImageApply Disabled, %c_Lang131%
Gui, 19:Add, Button, -Wrap ys W75 H23 gImageOpt, %w_Lang003%
If (s_Caller = "Edit")
{
	EscCom("Details|TimesX|DelayX|Target|Window", 1)
	Loop, Parse, Action, `,,%A_Space%
		Act%A_Index% := A_LoopField
	GuiControl, 19:ChooseString, IfFound, %Act1%
	GuiControl, 19:ChooseString, IfNotFound, %Act2%
	Loop, Parse, Details, `,,%A_Space%
		Det%A_Index% := A_LoopField
	If (Type = cType16)
	{
		GuiControl, 19:, ImageS, 1
		RegExMatch(Det5, "\*(\d+?)\s+(.*)", ImgOpt)
	,	Variat := ImgOpt1, Det5 := ImgOpt2 ? ImgOpt2 : Det5
	,	RegExMatch(Det5, "\*Icon(.+?)\s+(.*)", ImgOpt)
	,	IconN := ImgOpt1, Det5 := ImgOpt2 ? ImgOpt2 : Det5
	,	RegExMatch(Det5, "\*Trans(.+?)\s+(.*)", ImgOpt)
	,	TransC := ImgOpt1, Det5 := ImgOpt2 ? ImgOpt2 : Det5
	,	RegExMatch(Det5, "\*W(.+?)\s+(.*)", ImgOpt)
	,	WScale := ImgOpt1, Det5 := ImgOpt2 ? ImgOpt2 : Det5
	,	RegExMatch(Det5, "\*H(.+?)\s+(.*)", ImgOpt)
	,	HScale := ImgOpt1, Det5 := ImgOpt2 ? ImgOpt2 : Det5
	,	File := Det5
		GuiControl, 19:, Variat, %Variat%
		GuiControl, 19:, IconN, %IconN%
		GuiControl, 19:, TransC, %TransC%
		GuiControl, 19:, WScale, %WScale%
		GuiControl, 19:, HScale, %HScale%
		GoSub, MakePrev
	}
	If (Type = cType15)
	{
		GuiControl, 19:, PixelS, 1
		GuiControl, 19:Hide, PicPrev
		GuiControl, 19:Show, ColorPrev
		color := Det5
		GuiControl, 19:+Background%color%, ColorPrev
		GuiControl, 19:, Variat, %Det6%
		GuiControl, 19:Disable, Screenshot
		GoSub, PixelS
	}
	GuiControl, 19:, iPosX, %Det1%
	GuiControl, 19:, iPosY, %Det2%
	GuiControl, 19:, ePosX, %Det3%
	GuiControl, 19:, ePosY, %Det4%
	GuiControl, 19:, ImgFile, %Det5%
	GuiControl, 19:ChooseString, CoordPixel, %Window%
	GuiControl, 19:, TimesX, %TimesX%
	GuiControl, 19:, EdRept, %TimesX%
	GuiControl, 19:, DelayX, %DelayX%
	GuiControl, 19:, DelayC, %DelayX%
	If Target = Break
		GuiControl, 19:, BreakLoop, 1
	GuiControl, 19:Enable, ImageApply
	GuiControl, 19:, AddIf, 0
	GuiControl, 19:Disable, AddIf
}
If ((s_Caller = "Find") && (GotoRes1 = "PixelSearch"))
{
	GuiControl, 19:, PixelS, 1
	GoSub, PixelS
}
Gui, 19:Show,, %c_Lang006% / %c_Lang007%
Input
Tooltip
return

ImageApply:
ImageOK:
Gui, 19:Submit, NoHide
If ImgFile = 
	return
DelayX := InStr(DelayC, "%") ? DelayC : DelayX
If Sec = 1
	DelayX *= 1000
TimesX := InStr(EdRept, "%") ? EdRept : TimesX
If TimesX = 0
	TimesX := 1
Action := IfFound "`, " IfNotFound
If ImageS = 1
{
	ImgOptions := ""
	If (Variat > 0)
		ImgOptions .= "*" Variat " "
	If (IconN <> "")
		ImgOptions .= "*Icon" IconN " "
	If (TransC <> "")
		ImgOptions .= "*Trans" TransC " "
	If (WScale <> "")
		ImgOptions .= "*W" WScale " "
	If (HScale <> "")
		ImgOptions .= "*H" HScale " "
	Type := cType16, ImgFile := ImgOptions ImgFile
}
Details := iPosX "`, " iPosY "`, " ePosX "`, " ePosY "`, " ImgFile
If PixelS = 1
	Type := cType15, Details .= ", " Variat ", Fast RGB"
Target := BreakLoop ? "Break" : ""
EscCom("Details|TimesX|DelayX|CoordPixel")
If (A_ThisLabel <> "ImageApply")
{
	Gui, 1:-Disabled
	Gui, 19:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type, Target, CoordPixel)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Action, Details, TimesX, DelayX, Type, Target, CoordPixel)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
	LV_Insert(LV_GetNext(), "Check", LV_GetNext(), Action, Details, TimesX, DelayX, Type, Target, CoordPixel)
GoSub, b_Start
GoSub, RowCheck
If (AddIf = 1)
{
	If RowSelection = 0
	{
		LV_Add("Check", ListCount%A_List%+1, If9, "", 1, 0, cType17)
		LV_Add("Check", ListCount%A_List%+2, "[End If]", "EndIf", 1, 0, cType17)
		LV_Modify(ListCount%A_List%+2, "Vis")
	}
	Else
	{
		LV_Insert(LV_GetNext(), "Check", "", If9, "", 1, 0, cType17)
		RowNumber := 0, LastRow := 0
		Loop
		{
			RowNumber := LV_GetNext(RowNumber)
			If !RowNumber
			{
				LV_Insert(LastRow+1, "Check",LastRow+1, "[End If]", "EndIf", 1, 0, cType17)
				break
			}
			LastRow := LV_GetNext(LastRow)
		}
	}
	GoSub, b_Start
	GoSub, RowCheck
}
If (A_ThisLabel = "ImageApply")
	Gui, 19:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

ImageCancel:
PixelCancel:
19GuiClose:
19GuiEscape:
Gui, 1:-Disabled
Gui, 19:Destroy
s_Caller = 
return

SearchImg:
Gui, 19:+OwnDialogs
Gui, 19:Submit, NoHide
If (ImageS = 1)
	GoSub, GetImage
If (PixelS = 1)
{
	If (A_GuiControl = "SearchImg")
		GoSub, EditColor
	Else
		GoSub, GetPixel
}
return

GetImage:
FileSelectFile, file,,,, Images (*.gif; *.jpg; *.bmp; *.png; *.tif; *.ico; *.cur; *.ani; *.exe; *.dll)
FreeMemory()
If (file = "")
	return
GuiControl, 19:, ImgFile, %File%

MakePrev:
If InStr(file, "%")
	file := DerefVars(file)
Gui, 9:Add, Pic, vLoadedPic, %file% 
GuiControlGet, LoadedPic, 9:Pos
Gui, 9:Destroy
Width = 260
Height = 200
PropH := LoadedPicH * Width // LoadedPicW, PropW := LoadedPicW * Height // LoadedPicH
If ((LoadedPicW <= Width) && (LoadedPicH <= Height))
	GuiControl, 19:, PicPrev, *W0 *H0 %file%
Else If (PropH > Height)
	GuiControl, 19:, PicPrev, *W-1 *H%Height% %file%
Else
	GuiControl, 19:, PicPrev, *W%Width% *H-1 %file%
GuiControl, 19:, ImgSize, %c_Lang059%: %LoadedPicW% x %LoadedPicH%
return

ImageS:
Gui, 19:Submit, NoHide
GuiControl, 19:, ImgFile
GuiControl, 19:, PicPrev
GuiControl, 19:, ImgSize
GuiControl, +BackgroundDefault, ColorPrev
GuiControl, 19:Show, PicPrev
GuiControl, 19:Hide, ColorPrev
GuiControl, 19:Disable, ColorPick
GuiControl, 19:Enable, Screenshot
GuiControl, 19:Enable, IconN
GuiControl, 19:Enable, TransC
GuiControl, 19:Enable, TransCS
GuiControl, 19:Enable, WScale
GuiControl, 19:Enable, HScale
return

PixelS:
Gui, 19:Submit, NoHide
GuiControl, 19:, ImgFile
GuiControl, 19:, PicPrev
GuiControl, 19:, ImgSize
GuiControl, +BackgroundDefault, ColorPrev
GuiControl, 19:Hide, PicPrev
GuiControl, 19:Show, ColorPrev
GuiControl, 19:Enable, ColorPick
GuiControl, 19:Disable, Screenshot
GuiControl, 19:Disable, IconN
GuiControl, 19:Disable, TransC
GuiControl, 19:Disable, TransCS
GuiControl, 19:Disable, WScale
GuiControl, 19:Disable, HScale
return

PicOpen:
If A_GuiEvent <> DoubleClick
	return
Gui, 19:Submit, NoHide
If InStr(FileExist(ImgFile), "A")
	Run, %ImgFile%
return

IfFound:
Gui, 19:Submit, NoHide
If (IfFound <> "Continue")
	GuiControl, 19:, AddIf, 0
return

ImageOpt:
; Screenshots
Gui, 25:+owner19 +ToolWindow
Gui, 19:Default
Gui, 19:+Disabled
Gui, 25:Add, GroupBox, Section W400 H120, %t_Lang046%
Gui, 25:Add, Text, ys+20 xs+10, %t_Lang047%:
Gui, 25:Add, DDL, yp-5 xs+100 vDrawButton W75, RButton||LButton|MButton
Gui, 25:Add, Text, yp+3 xs+210, %t_Lang048%:
Gui, 25:Add, Edit, Limit Number yp-2 x+5 W40 R1 vLineT
Gui, 25:Add, UpDown, yp xp+60 vLineW 0x80 Range1-5, %LineW%
Gui, 25:Add, Radio, -Wrap ys+45 xs+10 W180 vOnRelease R1, %t_Lang049%
Gui, 25:Add, Radio, -Wrap ys+45 xs+210 W180 vOnEnter R1, %t_Lang050%
Gui, 25:Add, Text, ys+70 xs+10, %t_Lang051%:
Gui, 25:Add, Edit, vScreenDir W350 R1 -Multi, %ScreenDir%
Gui, 25:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchScreen gSearchDir, ...
Gui, 25:Add, Button, -Wrap Default Section xm W75 H23 gImgConfigOK, %c_Lang020%
Gui, 25:Add, Button, -Wrap ys W75 H23 gImgConfigCancel, %c_Lang021%
GuiControl, 25:ChooseString, DrawButton, %DrawButton%
GuiControl, 25:, OnRelease, %OnRelease%
GuiControl, 25:, OnEnter, %OnEnter%
Gui, 25:Show,, %t_Lang017%
Tooltip
return

ImgConfigOK:
Gui, 25:Submit, NoHide
If OnRelease = 1
	SSMode = OnRelease
Else If OnEnter = 1
	SSMode = OnEnter
Gui, 19:-Disabled
Gui, 25:Destroy
Gui, 19:Default
return

ImgConfigCancel:
25GuiClose:
25GuiEscape:
Gui, 19:-Disabled
Gui, 25:Destroy
return

EditRun:
s_Caller = Edit
Run:
Gui, 10:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 10:Add, Text, ym+5 W55, %c_Lang055%:
Gui, 10:Add, ComboBox, yp-2 xs+100 W170 vFileCmdL gFileCmd, %FileCmdList%
Gui, 10:Add, Text, yp+30 xm W200 vFCmd1
Gui, 10:Add, Edit, vPar1File W330 R1 -Multi
Gui, 10:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchPar1 gSearch, ...
Gui, 10:Add, Text, xm W200 vFCmd2
Gui, 10:Add, Edit, vPar2File W330 R1 -Multi
Gui, 10:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchPar2 gSearch, ...
Gui, 10:Add, Button, -Wrap yp xp W30 H23 vMouseGet gMouseGetI Hidden, ...
Gui, 10:Add, Text, xm W200 vFCmd3
Gui, 10:Add, Edit, vPar3File W330 R1 -Multi
Gui, 10:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchPar3 gSearch, ...
Gui, 10:Add, Text, xm W200 vFCmd4
Gui, 10:Add, Edit, vPar4File W330 R1 -Multi
Gui, 10:Add, Text, xm W200 vFCmd5
Gui, 10:Add, Edit, vPar5File W330 R1 -Multi
Gui, 10:Add, Text, xm W200 vFCmd6
Gui, 10:Add, Edit, vPar6File W330 R1 -Multi
Gui, 10:Add, Button, -Wrap Section Default y+20 xm W75 H23 vRunOK gRunOK, %c_Lang020%
Gui, 10:Add, Button, -Wrap ys W75 H23 gRunCancel, %c_Lang021%
Gui, 10:Add, Button, -Wrap ys W75 H23 vRunApply gRunApply Disabled, %c_Lang131%
If (s_Caller = "Edit")
{
	GuiControl, 10:ChooseString, FileCmdL, %Type%
	StringReplace, Details, Details, ```,, ¢, All
	Loop, Parse, Details, `,, %A_Space%
	{
		StringReplace, LoopField, A_LoopField, ¢, `,, All
		GuiControl, 10:, Par%A_Index%File, %LoopField%
	}
	GuiControl, 10:Enable, RunApply
}
GoSub, FileCmd
If (s_Caller = "Find")
{
	GuiControl, 10:ChooseString, FileCmdL, %GotoRes1%
	GoSub, FileCmd
}
Gui, 10:Show,, %c_Lang008%
Tooltip
Input
return

Search:
Gui, +OwnDialogs
Gui, Submit, NoHide
GuiControlGet, FcCmd,, FileCmdL
GuiControlGet, FcCtrl,, % "FCmd" SubStr(A_GuiControl, 0, 1)
GuiControlGet, LFile,, LFilePattern
If (InStr(FcCmd, "Dir") || InStr(FcCmd, "Folder") || InStr(FcCtrl, "WorkingDir")
|| InStr(FcCtrl, "Drive") || InStr(FcCtrl, "Path")) || (LFile = 1)
{
	GoSub, SearchDir
	EdField := SubStr(A_GuiControl, 7) "File"
	If (EdField = "LParamsFile")
			Folder .= "\*.*"
	GuiControl,, %EdField%, %Folder%
	return
}
FileSelectFile, File, 2
FreeMemory()
If File = 
	return
EdField := SubStr(A_GuiControl, 7) "File"
GuiControl,, %EdField%, %File%
return

SearchDir:
Gui, +OwnDialogs
Gui, Submit, NoHide
FileSelectFolder, Folder, *%A_ScriptDir%
FreeMemory()
If Folder = 
	return
EdField := SubStr(A_GuiControl, 7) "Dir"
GuiControl,, %EdField%, %Folder%
return

RunApply:
RunOK:
Gui, 10:Submit, NoHide
Details := ""
Loop, 6
{
	GuiControlGet, fTxt, 10:, FCmd%A_Index%
	If (InStr(fTxt, "OutputVar") || InStr(fTxt, "InputVar"))
	{
		VarName := Par%A_Index%File
		If (VarName = "")
		{
			If fTxt not in OutputVarPID,OutputVarX,OutputVarY,OutputVarWin,OutputVarControl
			{
				Tooltip, %c_Lang127%, 15, % (A_Index = 1) ? 80 : 130
				return
			}
		}
		Try
			z_Check := VarSetCapacity(%VarName%)
		Catch
		{
			MsgBox, 16, %d_Lang007%, %d_Lang041%
			return
		}
	}
	GuiControlGet, fState, 10:Enabled, Par%A_Index%File
	If (fState = 1)
	{
		IfInString, Par%A_Index%File, `,
			StringReplace, Par%A_Index%File, Par%A_Index%File, `,, ```,, All
		Details .= Par%A_Index%File ", "
	}
}
StringReplace, Details, Details, ```,, ¢, All
Details := RTrim(Details, ", ")
StringReplace, Details, Details, ¢, ```,, All
If (A_ThisLabel <> "RunApply")
{
	Gui, 1:-Disabled
	Gui, 10:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", FileCmdL, Details, TimesX, DelayX, FileCmdL)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, FileCmdL, Details, 1, DelayG, FileCmdL)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, FileCmdL, Details, 1, DelayG, FileCmdL)
		RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "RunApply")
	Gui, 10:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

RunCancel:
10GuiClose:
10GuiEscape:
Gui, 1:-Disabled
Gui, 10:Destroy
s_Caller = 
return

FileCmd:
Gui, 10:Submit, NoHide
Loop, 6
{
	Try
	{
		GuiControl, 10:, FCmd%A_Index%, % %FileCmdL%%A_Index%
		If !(%FileCmdL%%A_Index%)
			GuiControl, 10:Disable, Par%A_Index%File
		Else
			GuiControl, 10:Enable, Par%A_Index%File
	}
	Catch
	{
		GuiControl, 10:, FCmd%A_Index%
		GuiControl, 10:Disable, Par%A_Index%File
	}
	Try
	{
		If %FileCmdL%%A_Index% contains Target,Dir,File,Source,Dest,Starting,Drive,Path
			GuiControl, 10:Enable, SearchPar%A_Index%
		Else
			GuiControl, 10:Disable, SearchPar%A_Index%
	}
	Catch
		GuiControl, 10:Disable, SearchPar%A_Index%
}
If ((FileCmdL = "PixelGetColor") || (FileCmdL = "Tooltip"))
{
	GuiControl, 10:Hide, SearchPar2
	GuiControl, 10:Show, MouseGet
}
Else
{
	GuiControl, 10:Hide, MouseGet
	GuiControl, 10:Show, SearchPar2
}
If FileCmdL not in %FileCmdML%
{
	GuiControl, 10:Disable, RunOK
	GuiControl, 10:Disable, RunApply
}
Else
{
	GuiControl, 10:Enable, RunOK
	If (s_Caller = "Edit")
		GuiControl, 10:Enable, RunApply
}
return

EditVar:
EditSt:
s_Caller = Edit
AsFunc:
AsVar:
IfSt:
Gui, 21:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin +Delimiter$
Gui, 1:+Disabled
Gui, 21:Add, Tab2, W330 H0 vTabControl AltSubmit, %c_Lang009%$%c_Lang084%$%c_Lang011%
; Statements
Gui, 21:Add, GroupBox, Section xm ym W330 H280
Gui, 21:Add, DDL, ys+15 xs+10 W200 vStatement gStatement, %IfList%
Gui, 21:Add, Button, -Wrap yp-1 x+5 W30 H23 vIfGet gIfGet, ...
Gui, 21:Add, DDL, yp+1 x+0 W75 vIdent, Title$$Class$Process$ID
Gui, 21:Add, Text, y+5 xm+10 W200 vFormatTip
Gui, 21:Add, Edit, W310 H136 -vScroll vTestVar
Gui, 21:Add, Text, W300 r2, %c_Lang025%
Gui, 21:Add, Text, -Wrap xs+15 y+20 W70 H23, %c_Lang123%:
Gui, 21:Add, Button, -Wrap yp x+0 W75 H23 vAddElse gAddElse, %c_Lang083%
Gui, 21:Add, Button, -Wrap Section Default xm ys+290 W75 H23 gIfOK, %c_Lang020%
Gui, 21:Add, Button, -Wrap ys W75 H23 gIfCancel, %c_Lang021%
Gui, 21:Add, Button, -Wrap ys W75 H23 vIfApply gIfApply Disabled, %c_Lang131%
Gui, 21:Tab, 2
; Variables
Gui, 21:Add, GroupBox, Section xm ym W330 H280
Gui, 21:Add, Text, ys+15 xs+10, %c_Lang057%:
Gui, 21:Add, Edit, W245 R1 -Multi vVarName
Gui, 21:Add, Text, yp-20 x+5 W40, %c_Lang086%:
Gui, 21:Add, DDL, y+7 W60 vOper, :=$$+=$-=$*=$/=$//=$.=$|=$&=$^=$>>=$<<=
Gui, 21:Add, Text, ym+70 xs+10 W60, %c_Lang085%:
Gui, 21:Add, Checkbox, -Wrap Checked%EvalDefault% yp x+5 W235 vUseEval gUseEval R1, %c_Lang087%
Gui, 21:Add, Edit, yp+19 xs+10 W310 H125 vVarValue
Gui, 21:Add, Text, W300 r1, %c_Lang025%
Gui, 21:Add, Text, -Wrap xs+15 y+15 W70 H23, %c_Lang010%:
Gui, 21:Add, Button, -Wrap yp x+0 W75 H23 vVarCopyA gVarCopy, %c_Lang023%
Gui, 21:Add, Button, -Wrap x+10 yp W75 H23 gReset, %c_Lang088%
Gui, 21:Add, Button, -Wrap Section xm ys+290 W75 H23 gVarOK, %c_Lang020%
Gui, 21:Add, Button, -Wrap ys W75 H23 gIfCancel, %c_Lang021%
Gui, 21:Add, Button, -Wrap ys W75 H23 vVarApplyA gVarApply Disabled, %c_Lang131%
Gui, 21:Tab, 3
; Functions
Gui, 21:Add, GroupBox, Section xm ym W330 H280
Gui, 21:Add, Text, ys+15 xs+10, %c_Lang057%:
Gui, 21:Add, Edit, W310 R1 -Multi vVarNameF
Gui, 21:Add, Checkbox, yp+30 xs+10 W310 vUseExtFunc gUseExtFunc, %c_Lang128%
Gui, 21:Add, Edit, W280 R1 -Multi vFileNameEx Disabled, %StdLibFile%
Gui, 21:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchFEX gSearchAHK Disabled, ...
Gui, 21:Add, Text, yp+30 xs+10 W130, %c_Lang089%:
Gui, 21:Add, Combobox, W285 -Multi vFuncName gFuncName, %BuiltinFuncList%
Gui, 21:Add, Button, -Wrap W25 yp-1 x+5 hwndFuncHelp vFuncHelp gFuncHelp Disabled
	ILButton(FuncHelp, ResDllPath ":" 24)
Gui, 21:Add, Text, W310 yp+25 xs+10, %c_Lang090%:
Gui, 21:Add, Edit, W310 R1 -Multi vVarValueF
Gui, 21:Add, Text, y+7 W310 r2, %c_Lang091%
Gui, 21:Add, Text, -Wrap xs+15 y+20 W70 H23, %c_Lang010%:
Gui, 21:Add, Button, -Wrap yp x+0 W75 H23 vVarCopyB gVarCopy, %c_Lang023%
Gui, 21:Add, Button, -Wrap x+10 yp W75 H23 gReset, %c_Lang088%
Gui, 21:Add, Button, -Wrap Section xm ys+290 W75 H23 gVarOK, %c_Lang020%
Gui, 21:Add, Button, -Wrap ys W75 H23 gIfCancel, %c_Lang021%
Gui, 21:Add, Button, -Wrap ys W75 H23 vVarApplyB gVarApply Disabled, %c_Lang131%
If (s_Caller = "Edit")
{
	If (A_ThisLabel = "EditSt")
	{
		StringReplace, Details, Details, ``n, `n, All
		EscCom("Details|TimesX|DelayX|Target|Window", 1)
		GuiControl, 21:ChooseString, Statement, %Action%
		GuiControl, 21:, TestVar, %Details%
		GoSub, Statement
		If InStr(Action, "Image")
			GuiControl, 21:Disable, TestVar
		GuiControl, 21:, TabControl, $%c_Lang009%
		GuiTitle := c_Lang009
	}
	Else If (A_ThisLabel = "EditVar")
	{
		If (Action = "[Assign Variable]")
		{
			StringReplace, Details, Details, ``n, `n, All
			AssignReplace(Details), EscCom("VarValue", 1), GuiTitle := c_Lang010
			GuiControl, 21:Choose, TabControl, 2
			GuiControl, 21:, VarName, %VarName%
			GuiControl, 21:ChooseString, Oper, %Oper%
			GuiControl, 21:, VarValue, %VarValue%
			If (Target = "Expression")
				GuiControl, 21:, UseEval, 1
		}
		Else
		{
			AssignReplace(Details), FuncName := Action, GuiTitle := c_Lang011
			GuiControl, 21:Choose, TabControl, 3
			If (VarName <> "_null")
				GuiControl, 21:, VarNameF, %VarName%
			If (IsBuiltIn)
				GuiControl, 21:ChooseString, FuncName, %FuncName%
			Else
				GuiControl, 21:, FuncName, %FuncName%$$
			GuiControl, 21:, VarValueF, %VarValue%
			If (Target <> "")
			{
				UseExtFunc := 1, FileNameEx := Target
				GuiControl, 21:, UseExtFunc, 1
				GuiControl, 21:, FileNameEx, %Target%
				GuiControl, 21:Enable, SearchAHK
				GoSub, UseExtFunc
				GuiControl, 21:ChooseString, FuncName, %FuncName%
			}
			GoSub, FuncName
		}
	}
	GuiControl, 21:Enable, IfApply
	GuiControl, 21:Enable, VarApplyA
	GuiControl, 21:Enable, VarApplyB
}
Else
	ExtList := ReadFunctions(StdLibFile)
If !IsFunc("Eval")
	GuiControl, 21:, UseEval, 0
If (A_ThisLabel = "IfSt")
{
	GuiTitle := c_Lang009
	If (s_Caller = "Find")
	{
		GuiControl, 21:ChooseString, Statement, %GotoRes1%
		GoSub, Statement
	}
}
Else If (A_ThisLabel = "AsVar")
{
	GuiControl, 21:Choose, TabControl, 2
	GuiTitle := c_Lang010
}
Else If (A_ThisLabel = "AsFunc")
{
	GuiControl, 21:Choose, TabControl, 3
	GuiTitle := c_Lang011
	If (s_Caller = "Find")
	{
		GuiControl, 21:ChooseString, FuncName, %GotoRes1%
		GoSub, FuncName
	}
}
Gui, 21:Show,, %GuiTitle%
Tooltip
return

IfApply:
IfOK:
Gui, 21:+OwnDialogs
Gui, 21:Submit, NoHide
If InStr(Statement, "Image")
	TestVar =
Else
{
	If (TestVar = "")
		return
}
If InStr(Statement, "Compare")
{
	AssignReplace(TestVar)
	Try
		z_Check := VarSetCapacity(%VarName%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		return
	}
	If Oper not in =,==,<>,!=,>,<,>=,<=
	{
		MsgBox, 16, %d_Lang007%, %d_Lang042%
		return
	}
}
Else If InStr(Statement, "String")
{
	If !RegExMatch(TestVar, "(.+),\s.+", tMatch)
		return
	VarName := Trim(tMatch1)
	Try
		z_Check := VarSetCapacity(%VarName%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		return
	}
}
Else If (Statement = "Evaluate Expression")
{
	If !IsFunc("Eval")
	{
		MsgBox, 17, %d_Lang007%, %d_Lang044%
		IfMsgBox, OK
			Run, http://www.autohotkey.com/board/topic/15675-monster
		return
	}
}
EscCom("TestVar")
If (A_ThisLabel <> "IfApply")
{
	Gui, 1:-Disabled
	Gui, 21:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Statement, TestVar, 1, 0, cType17)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Statement, TestVar, 1, 0, cType17)
	LV_Add("Check", ListCount%A_List%+2, "[End If]", "EndIf", 1, 0, cType17)
	LV_Modify(ListCount%A_List%+2, "Vis")
}
Else
{
	LV_Insert(LV_GetNext(), "Check", "", Statement, TestVar, 1, 0, cType17)
	RowNumber := 0, LastRow := 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If !RowNumber
		{
			LV_Insert(LastRow+1, "Check",LastRow+1, "[End If]", "EndIf", 1, 0, cType17)
			break
		}
		LastRow := LV_GetNext(LastRow)
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "IfApply")
	Gui, 21:Default
Else
{
	s_Caller =
	GuiControl, Focus, InputList%A_List%
}
return

VarApply:
VarOK:
Gui, 21:+OwnDialogs
Gui, 21:Submit, NoHide
If TabControl = 3
{
	If (UseExtFunc)
	{
		SplitPath, FileNameEx,,, ext
		If ((ext <> "ahk") || (FuncName = ""))
		{
			MsgBox, 16, %d_Lang007%, %d_Lang055%
			return
		}
		Target := FileNameEx
	}
	Else If !IsFunc(FuncName)
	{
		MsgBox, 16, %d_Lang007%, "%FuncName%" %d_Lang031%
		return
	}
	Else
		Target := ""
	VarName := VarNameF
	If (VarName = "")
		VarName := "_null"
}
If (VarName = "")
{
	Tooltip, %c_Lang127%, 25, 75
	return
}
Try
	z_Check := VarSetCapacity(%VarName%)
Catch
{
	MsgBox, 16, %d_Lang007%, %d_Lang041%
	return
}
StringReplace, VarValue, VarValue, `n, ``n, All
If (s_Caller <> "Edit")
	TimesX := 1
If TabControl = 3
	Action := FuncName, Details := VarName " := " VarValueF
Else
{
	Action := "[Assign Variable]", Details := VarName " " Oper " " VarValue
	If (UseEval = 1)
		Target := "Expression"
	Else
		Target := ""
	EscCom("Details|TimesX|DelayX|Target|Window")
}
Type := cType21
If (A_ThisLabel <> "VarApply")
{
	Gui, 1:-Disabled
	Gui, 21:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type, Target, "")
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Action, Details, 1, 0, Type, Target, "")
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
	LV_Insert(LV_GetNext(), "Check", "", Action, Details, 1, 0, Type, Target, "")
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "VarApply")
	Gui, 21:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

AddElse:
Gui, 21:Submit, NoHide
Gui, 1:-Disabled
Gui, 21:Destroy
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, "[Else]", "Else", 1, 0, cType17)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
	LV_Insert(LV_GetNext(), "Check", "", "[Else]", "Else", 1, 0, cType17)
GoSub, b_Start
GoSub, RowCheck
GuiControl, Focus, InputList%A_List%
return

VarCopy:
Gui, 21:Submit, NoHide
If TabControl = 3
{
	If (VarNameF = "")
		return
	Clipboard := %VarNameF%
}
Else
{
	If (VarName = "")
		return
	Clipboard := %VarName%
}
return

Reset:
Gui, 21:Submit, NoHide
If TabControl = 3
{
	If (VarNameF = "")
		return
	%VarNameF% := ""
}
Else
{
	If (VarName = "")
		return
	%VarName% := ""
}
return

UseEval:
Gui, 21:+OwnDialogs
If !IsFunc("Eval")
{
	GuiControl, 21:, UseEval, 0
	MsgBox, 17, %d_Lang007%, %d_Lang044%
	IfMsgBox, OK
		Run, http://www.autohotkey.com/board/topic/15675-monster
	return
}
return

IfCancel:
21GuiClose:
21GuiEscape:
Gui, 1:-Disabled
Gui, 21:Destroy
s_Caller = 
return

FuncName:
Gui, 21:Submit, NoHide
Try IsBuiltIn := Func(FuncName).IsBuiltIn ? 1 : 0
GuiControl, 21:Enable%IsBuiltIn%, FuncHelp
return

UseExtFunc:
Gui, 21:Submit, NoHide
Gui, 21:+OwnDialogs
If !A_AhkPath
{
	GuiControl, 21:, UseExtFunc, 0
	MsgBox, 17, %d_Lang007%, %d_Lang056%
	IfMsgBox, OK
		Run, http://www.autohotkey.com
	return
}
GuiControl, 21:Enable%UseExtFunc%, FileNameEx
GuiControl, 21:Enable%UseExtFunc%, SearchFEX
GuiControl, 21:Disable, FuncHelp
GuiControl, 21:, FuncName, $
If (UseExtFunc = 1)
	ExtList := ReadFunctions(FileNameEx, t_lang086)
GuiControl, 21:, FuncName, % (UseExtFunc) ? "$" ExtList : "$" BuiltinFuncList
return

SearchAHK:
Gui, +OwnDialogs
Gui, Submit, NoHide
FileSelectFile, File, 1,,, AutoHotkey Scripts (*.ahk)
FreeMemory()
If File = 
	return
If (A_GuiControl = "StdLib")
	GuiControl, 4:, StdLibFile, %File%
Else
{
	GuiControl, 21:, FileNameEx, %File%
	GuiControl, 21:, FuncName, $
	ExtList := ReadFunctions(File, t_lang086)
	GuiControl, 21:, FuncName, % (UseExtFunc) ? "$" ExtList : "$" BuiltinFuncList
}
return

FuncHelp:
Gui, Submit, NoHide
If FuncName in Abs,ACos,Asc,ASin,ATan,Ceil,Chr,Exp,FileExist,Floor,Func
,GetKeyName,GetKeySC,GetKeyState,GetKeyVK,InStr,IsByRef,IsFunc,IsLabel
,IsObject,Ln,Log,LTrim,Mod,NumGet,NumPut,Round,RTrim,Sin,Sqrt,StrGet
,StrLen,StrPut,SubStr,Tan,Trim,WinActive,WinExist
	Run, http://l.autohotkey.net/docs/Functions.htm#%FuncName%
Else If (FuncName = "Array")
	Run, http://l.autohotkey.net/docs/misc/Arrays.htm
Else
	Run, http://l.autohotkey.net/docs/commands/%FuncName%.htm
return

Statement:
Gui, 21:Submit, NoHide
If InStr(Statement, "Window")
	GuiControl, 21:Enable, Ident
If !InStr(Statement, "Window")
	GuiControl, 21:Disable, Ident
If (!InStr(Statement, "Window") && !InStr(Statement, "File"))
	GuiControl, 21:Disable, IfGet
Else
	GuiControl, 21:Enable, IfGet
If InStr(Statement, "Image")
	GuiControl, 21:Disable, TestVar
Else
	GuiControl, 21:Enable, TestVar
If InStr(Statement, "String")
	GuiControl, 21:, FormatTip, %c_Lang081%
Else If InStr(Statement, "Compare")
	GuiControl, 21:, FormatTip, %c_Lang082%
Else
	GuiControl, 21:, FormatTip
return

IfGet:
Gui, 21:Submit, NoHide
If InStr(Statement, "Window")
{
	Label = IfGet
	GoSub, GetWin
	Label =
	GuiControl, 21:, TestVar, %FoundTitle%
	return
}
If InStr(Statement, "File")
{
	GoSub, Search
	GuiControl, 21:, TestVar, %File%
	return
}
return

EditMsg:
s_Caller = Edit
SendMsg:
Gui, 22:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 22:Add, DDL, W100 vMsgType, PostMessage||SendMessage
Gui, 22:Add, DDL, yp xp+110 W210 vWinMsg gWinMsg, %WM_Msgs%
Gui, 22:Add, Text, xm W120, %c_Lang102%:
Gui, 22:Add, Edit, xm W320 -Multi vMsgNum
Gui, 22:Add, Text, xm W80, wParam:
Gui, 22:Add, Edit, xm W320 -Multi vwParam
Gui, 22:Add, Text, xm W80, lParam:
Gui, 22:Add, Edit, xm W320 -Multi vlParam
Gui, 22:Add, Text, Section xm, %c_Lang004%:
Gui, 22:Add, Edit, vDefCt W290
Gui, 22:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl, ...
Gui, 22:Add, DDL, Section xm W65 vIdent, Title||Class|Process|ID|PID
Gui, 22:Add, Text, -Wrap yp+5 x+5 W240 H20 vWinParsTip Disabled, %wcmd_WinSet%
Gui, 22:Add, Edit, xs+2 W290 vTitle, A
Gui, 22:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin, ...
Gui, 22:Add, Button, -Wrap Section Default xm W75 H23 gSendMsgOK, %c_Lang020%
Gui, 22:Add, Button, -Wrap ys W75 H23 gSendMsgCancel, %c_Lang021%
Gui, 22:Add, Button, -Wrap ys W75 H23 vSendMsgApply gSendMsgApply Disabled, %c_Lang131%
If (s_Caller = "Edit")
{
	EscCom("Details|TimesX|DelayX|Target|Window", 1)
	Loop, Parse, Details, `,,%A_Space%
	{
		StringReplace, LoopField, A_LoopField, ¢, `,, All
		Par%A_Index% := LoopField
	}
	GuiControl, 22:ChooseString, MsgType, %Type%
	GuiControl, 22:, MsgNum, %Par1%
	GuiControl, 22:, wParam, %Par2%
	GuiControl, 22:, lParam, %Par3%
	GuiControl, 22:, DefCt, %Target%
	GuiControl, 22:, Title, %Window%
	GuiControl, 22:Enable, SendMsgApply
}
If (s_Caller = "Find")
	GuiControl, 22:ChooseString, MsgType, %GotoRes1%
Gui, 22:Show, , % cType19 " / " cType18
Tooltip
return

SendMsgApply:
SendMsgOK:
Gui, 22:+OwnDialogs
Gui, 22:Submit, NoHide
If (MsgNum = "")
	return
If (s_Caller <> "Edit")
	TimesX := 1
IfInString, wParam, `,
	StringReplace, wParam, wParam, `,, ```,, All
IfInString, lParam, `,
	StringReplace, lParam, lParam, `,, ```,, All
Details := MsgNum ", " wParam ", " lParam
EscCom("Details|DefCt|Title")
If (A_ThisLabel <> "SendMsgApply")
{
	Gui, 1:-Disabled
	Gui, 22:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", "[Windows Message]", Details, TimesX, DelayX, MsgType, DefCt, Title)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, "[Windows Message]", Details, TimesX, DelayG, MsgType, DefCt, Title)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, "[Windows Message]", Details, TimesX, DelayG, MsgType, DefCt, Title)
		RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "SendMsgApply")
	Gui, 22:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

WinMsg:
Gui, 22:Submit, NoHide
GuiControl, 22:, MsgNum, % %WinMsg%
return

SendMsgCancel:
22GuiClose:
22GuiEscape:
Gui, 1:-Disabled
Gui, 22:Destroy
s_Caller = 
return

EditControl:
s_Caller = Edit
ControlCmd:
Gui, 23:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 23:Add, DDL, W120 vControlCmd gCtlCmd, %CtrlCmdList%
Gui, 23:Add, Text, xm W120, %c_Lang055%:
Gui, 23:Add, DDL, xm W120 -Multi vCmd gCmd, %CtrlCmd%
Gui, 23:Add, Text, xm W80, %c_Lang056%:
Gui, 23:Add, Edit, xm W430 -Multi Disabled vValue
Gui, 23:Add, Text, xm W180, %c_Lang057%:
Gui, 23:Add, Edit, xm W430 -Multi Disabled vVarName
Gui, 23:Add, Text, Section xm, %c_Lang004%:
Gui, 23:Add, Edit, vDefCt W400
Gui, 23:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl, ...
Gui, 23:Add, DDL, Section xm W65 vIdent, Title||Class|Process|ID|PID
Gui, 23:Add, Text, -Wrap yp+5 x+5 W240 H20 vWinParsTip Disabled, %wcmd_WinSet%
Gui, 23:Add, Edit, xs+2 W400 vTitle, A
Gui, 23:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin, ...
Gui, 23:Add, Text, Section ym+5 xm+195, %c_Lang058%
Gui, 23:Add, Text, yp xp+50, X:
Gui, 23:Add, Edit, yp-3 xp+15 vPosX W55 Disabled
Gui, 23:Add, Text, yp+3 x+10, Y:
Gui, 23:Add, Edit, yp-3 xp+15 vPosY W55 Disabled
Gui, 23:Add, Button, -Wrap yp-2 x+5 W30 H23 vGetCtrlP gCtrlGetP Disabled, ...
Gui, 23:Add, Text, xs, %c_Lang059%
Gui, 23:Add, Text, yp xp+50, W:
Gui, 23:Add, Edit, yp-3 xp+15 vSizeX W55 Disabled
Gui, 23:Add, Text, yp+3 x+10, H:
Gui, 23:Add, Edit, yp-3 xp+15 vSizeY W55 Disabled
Gui, 23:Add, Button, -Wrap Section Default xm W75 H23 gControlOK, %c_Lang020%
Gui, 23:Add, Button, -Wrap ys W75 H23 gControlCancel, %c_Lang021%
Gui, 23:Add, Button, -Wrap ys W75 H23 vControlApply gControlApply Disabled, %c_Lang131%
Gui, 23:Add, Text, ys W180 r2 vCPosT
If (s_Caller = "Edit")
{
	EscCom("Details|TimesX|DelayX|Target|Window", 1)
	ControlCmd := Type
	GuiControl, 23:ChooseString, ControlCmd, %ControlCmd%
	If (Type = cType24)
	{
		GuiControl, 23:ChooseString, Cmd, % cmd := RegExReplace(Details, "(^\w*).*", "$1")
		GuiControl, 23:, Value, % RegExReplace(Details, "^\w*, ?(.*)", "$1")
		GoSub, Cmd
	}
	Else If (Type = cType10)
	{
		GoSub, CtlCmd
		GuiControl, 23:, Value, %Details%
	}
	Else If ((Type = cType23)	|| (Type = cType27)
	|| (Type = cType28) || (Type = cType31))
	{
		Loop, Parse, Details, `,, %A_Space%
			Par%A_Index% := A_LoopField
		GoSub, CtlCmd
		GuiControl, 23:, VarName, %Par1%
		GuiControl, 23:ChooseString, Cmd, %Par2%
		GuiControl, 23:, Value, %Par3%
		GoSub, Cmd
	}
	Else If (Type = cType26)
	{
		GoSub, CtlCmd
		Loop, Parse, Details, `,,%A_Space%
			Par%A_Index% := A_LoopField
		GuiControl, 23:, PosX, %Par1%
		GuiControl, 23:, PosY, %Par2%
		GuiControl, 23:, SizeX, %Par3%
		GuiControl, 23:, SizeY, %Par4%
	}
	GuiControl, 23:, DefCt, %Target%
	GuiControl, 23:, Title, %Window%
	If (Type = cType25)
		GoSub, CtlCmd
	GuiControl, 23:Enable, ControlApply
}
If (s_Caller = "Find")
{
	If InStr(CtrlCmd, GotoRes1)
	{
		GuiControl, 23:ChooseString, Cmd, %GotoRes1%
		GoSub, Cmd
	}
	Else If InStr(CtrlGetCmd, GotoRes1)
	{
		GuiControl, 23:ChooseString, ControlCmd, ControlGet
		GoSub, CtlCmd
		GuiControl, 23:ChooseString, Cmd, %GotoRes1%
		GoSub, Cmd
	}
	Else
	{
		GuiControl, 23:ChooseString, ControlCmd, %GotoRes1%
		GoSub, CtlCmd
	}
}
Gui, 23:Show, , %c_Lang004%
Tooltip
return

ControlApply:
ControlOK:
Gui, 23:+OwnDialogs
Gui, 23:Submit, NoHide
If (s_Caller <> "Edit")
	TimesX := 1
GuiControlGet, VState, 23:Enabled, Value
If (VState = 0)
	Value := ""
GuiControlGet, VState, 23:Enabled, VarName
If (VState = 0)
	VarName := ""
If (ControlCmd = cType24)
	Details := Cmd ", " Value
If (ControlCmd = cType25)
	Details =
If (ControlCmd = cType26)
	Details := PosX ", " PosY ", " SizeX ", " SizeY
If (ControlCmd = cType10)
	Details := Value
If (ControlCmd = cType27)
	DefCt := ""
If ((ControlCmd = cType23) || (ControlCmd = cType27)
|| (ControlCmd = cType28) || (ControlCmd = cType31))
{
	If (VarName = "")
	{
		Tooltip, %c_Lang127%, 15, 160
		return
	}
	Try
		z_Check := VarSetCapacity(%VarName%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		return
	}
	If (ControlCmd = cType28)
		Details := VarName ", " Cmd ", " Value
	Else
		Details := VarName
}
EscCom("Details|DefCt|Title")
If (A_ThisLabel <> "ControlApply")
{
	Gui, 1:-Disabled
	Gui, 23:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", "[Control]", Details, TimesX, DelayX, ControlCmd, DefCt, Title)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, "[Control]", Details, TimesX, DelayG, ControlCmd, DefCt, Title)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, "[Control]", Details, TimesX, DelayG, ControlCmd, DefCt, Title)
		RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "ControlApply")
	Gui, 23:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

ControlCancel:
23GuiClose:
23GuiEscape:
Gui, 1:-Disabled
Gui, 23:Destroy
s_Caller = 
return

CtlCmd:
Gui, 23:Submit, NoHide
If ((ControlCmd <> cType24) && (ControlCmd <> cType28))
	GuiControl, 23:Disable, Cmd
Else
	GuiControl, 23:Enable, Cmd
If ((ControlCmd = cType24) || (ControlCmd = cType10))
	GuiControl, 23:Enable, Value
Else
	GuiControl, 23:Disable, Value
If (ControlCmd = cType24)
	GuiControl, 23:, Cmd, |%CtrlCmd%
Else If (ControlCmd = cType28)
	GuiControl, 23:, Cmd, |%CtrlGetCmd%
If ((ControlCmd = cType23) || (ControlCmd = cType27)
|| (ControlCmd = cType28) || (ControlCmd = cType31))
	GuiControl, 23:Enable, VarName
Else
	GuiControl, 23:Disable, VarName
If (ControlCmd = cType26)
{
	GuiControl, 23:Enable, PosX
	GuiControl, 23:Enable, PosY
	GuiControl, 23:Enable, GetCtrlP
	GuiControl, 23:Enable, SizeX
	GuiControl, 23:Enable, SizeY
}
Else
{
	GuiControl, 23:Disable, PosX
	GuiControl, 23:Disable, PosY
	GuiControl, 23:Disable, GetCtrlP
	GuiControl, 23:Disable, SizeX
	GuiControl, 23:Disable, SizeY
}
If (ControlCmd = cType31)
	GuiControl, 23:, CPosT, * %c_Lang060%
Else
	GuiControl, 23:, CPosT
GoSub, Cmd
return

Cmd:
Gui, 23:Submit, NoHide
If (ControlCmd = cType24)
{
	If Cmd in Style,ExStyle,TabLeft,TabRight,Add,Delete,Choose,ChooseString,EditPaste
		GuiControl, 23:Enable, Value
	Else
		GuiControl, 23:Disable, Value
}
Else If (ControlCmd = cType28)
{
	If Cmd in List,FindString,Line
		GuiControl, 23:Enable, Value
	Else
		GuiControl, 23:Disable, Value
}
return

EditIECom:
s_Caller = Edit
RunScrLet:
ComInt:
IECom:
IEWindows := ListIEWindows()
Gui, 24:+owner1 -MinimizeBox +E0x00000400 +hwndCmdWin
Gui, 1:+Disabled
Gui, 24:Add, Tab2, W410 H0 vTabControl gTabControl AltSubmit, %c_Lang012%|%c_Lang014%|%c_Lang155%
Gui, 24:Add, GroupBox, Section xm ym W410 H260
Gui, 24:Add, Combobox, ys+15 xs+10 W160 vIECmd gIECmd, %IECmdList%
Gui, 24:Add, Radio, -Wrap Checked W90 vSet gIECmd R1, %c_Lang093%
Gui, 24:Add, Radio, -Wrap x+0 W90 vGet gIECmd Disabled R1, %c_Lang094%
Gui, 24:Add, Radio, -Wrap Group Checked ys+75 xs+10 W90 vMethod gIECmd Disabled R1, %c_Lang095%
Gui, 24:Add, Radio, -Wrap x+0 W90 vProperty gIECmd Disabled R1, %c_Lang096%
Gui, 24:Add, Text, Section ys+95 xs+12 W250 vValueT, %c_Lang056%:
Gui, 24:Add, Edit, yp+20 xs W385 -Multi vValue
Gui, 24:Add, Text, y+10 W55, %c_Lang005%:
Gui, 24:Add, DDL, yp-2 xp+60 W295 vIEWindows AltSubmit, %IEWindows%
Gui, 24:Add, Button, -Wrap yp-1 x+5 W25 H25 hwndRefreshIEW vRefreshIEW gRefreshIEW
	ILButton(RefreshIEW, ResDllPath ":" 37)
Gui, 24:Add, Text, Section ym+20 xm+180 W215 R4 vComTip
Gui, 24:Add, Button, -Wrap Section Default ym+265 xm W75 H23 gIEComOK, %c_Lang020%
Gui, 24:Add, Button, -Wrap ys xs+170 W75 H23 vIEComApply gIEComApply Disabled, %c_Lang131%
Gui, 24:Tab, 2
; COM Interface
Gui, 24:Add, GroupBox, Section xm ym W410 H260
Gui, 24:Add, Text, ys+15 xs+10 W40, %c_Lang098%:
Gui, 24:Add, Combobox, yp xp+50 W260 vComCLSID gTabControl, %CLSList%
GuiControl, 24:ChooseString, ComCLSID, %ComCLSID%
Gui, 24:Add, Button, -Wrap yp-1 x+0 W75 H23 vActiveObj gActiveObj, %c_Lang099%
Gui, 24:Add, Text, y+5 xs+10 W80, %c_Lang100%:
Gui, 24:Add, Edit, xp+50 W115 vComHwnd, %ComHwnd%
Gui, 24:Add, Text, x+5 W100, %c_Lang057%:
Gui, 24:Add, Edit, xp+105 W115 vVarName
Gui, 24:Add, Text, y+5 xs+10 W200, %c_Lang101%:
Gui, 24:Add, Edit, y+5 xs+10 W390 R5 vComSc gComSc
Gui, 24:Add, Button, -Wrap y+2 xs+375 W25 H25 hwndExpView vExpView gExpView
	ILButton(ExpView, ResDllPath ":" 17)
Gui, 24:Add, Button, -Wrap Section Default ym+265 xm W75 H23 gComOK, %c_Lang020%
Gui, 24:Add, Button, -Wrap ys xs+170 W75 H23 vComApply gComApply Disabled, %c_Lang131%
Gui, 24:Tab, 3
; Run Scriptlet
Gui, 24:Add, GroupBox, Section xm ym W410 H260
Gui, 24:Add, Text, ys+15 xs+10 W100, %c_Lang156%:
If (A_PtrSize = 8)
	Gui, 24:Add, Text, ys+15 x+30 W210 cRed, %c_Lang158%
Gui, 24:Add, Edit, ys+35 xs+10 W390 R10 vScLet
Gui, 24:Add, Text, W100, %c_Lang157%:
Gui, 24:Add, Radio, -Wrap Checked yp x+5 W100 vRunVB R1, VBScript
Gui, 24:Add, Radio, -Wrap x+5 W100 vRunJS R1, JScript
Gui, 24:Add, Button, -Wrap yp-2 xs+375 W25 H25 hwndExpView2 vExpView2 gExpView
	ILButton(ExpView2, ResDllPath ":" 17)
Gui, 24:Add, Button, -Wrap Section Default ym+265 xm W75 H23 gScLetOK, %c_Lang020%
Gui, 24:Add, Button, -Wrap ys xs+170 W75 H23 vScLetApply gScLetApply Disabled, %c_Lang131%
Gui, 24:Tab
Gui, 24:Add, Text, Section ym+172 xm+12 vPgTxt, %c_Lang092%:
Gui, 24:Add, DDL, W70 vIdent Disabled, Name||ID|TagName|Links
Gui, 24:Add, Edit, yp xp+70 vDefEl W245 Disabled
Gui, 24:Add, Edit, yp x+0 vDefElInd W43 Disabled
Gui, 24:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetEl gGetEl Disabled, ...
Gui, 24:Add, Text, yp+30 xs, %c_Lang025%
Gui, 24:Add, Checkbox, -Wrap Checked ym+240 xs W300 vLoadWait R1, %c_Lang097%
Gui, 24:Add, Button, -Wrap Section ym+265 xs+72 W75 H23 gIEComCancel, %c_Lang021%
If (s_Caller = "Edit")
{
	StringReplace, Details, Details, ``n, `n, All
	If (Type = cType34)
	{
		ComCLSID := Target, TabControl := 2, GuiTitle := c_Lang013
		StringSplit, Act, Action, :
		GuiControl, 24:Choose, TabControl, 2
		If (Target = "")
			GuiControl, 24:Choose, ComCLSID, 0
		Else If InStr(CLSList, Target)
			GuiControl, 24:ChooseString, ComCLSID, %ComCLSID%
		Else
			GuiControl, 24:, ComCLSID, %ComCLSID%||
		GuiControl, 24:, ComHwnd, %Act1%
		GuiControl, 24:, VarName, %Act2%
		GuiControl, 24:, ComSc, %Details%
		GoSub, TabControl
		If InStr(Details, "`n")
			GuiControl, 24:Disabled, VarName
	}
	Else If ((Type = cType42) || (Type = cType43))
	{
		GuiControl, 24:Choose, TabControl, 3
		GuiControl, 24:, ScLet, %Details%
		GuiControl, 24:, % (Type = cType42) ? "RunVB" : "RunJS", 1
		GoSub, TabControl
		GuiTitle := c_Lang155
	}
	Else
	{
		Meth := RegExReplace(Action, ":.*"), IECmd := RegExReplace(Action, "^.*:(.*):.*", "$1")
	,	Ident := RegExReplace(Action, "^.*:"), Act := RegExReplace(Type, ".*_")
	,	DefEl := RegExReplace(Target, ":.*"), DefElInd := RegExReplace(Target, "^.*:")
		GuiControl, 24:, %Act%, 1
		GuiControl, 24:, %Meth%, 1
		If InStr(IECmdList, IECmd)
			GuiControl, 24:ChooseString, IECmd, %IECmd%
		Else
			GuiControl, 24:, IECmd, %IECmd%||
		GoSub, IECmd
		GuiControl, 24:ChooseString, Ident, %Ident%
		GuiControl, 24:, DefEl, %DefEl%
		GuiControl, 24:, DefElInd, %DefElInd%
		GuiControl, 24:, Value, %Details%
		GuiTitle := c_Lang012
	}
	If (Window = "LoadWait")
		GuiControl, 24:, LoadWait, 1
	Else
		GuiControl, 24:, LoadWait, 0
	GuiControl, 24:Enable, IEComApply
	GuiControl, 24:Enable, ComApply
	GuiControl, 24:Enable, ScLetApply
}
Else
{
	Try
		GuiControl, 24:, ComTip, %Tip_Navigate%
	Catch
		GuiControl, 24:, ComTip
}
If (A_ThisLabel = "IECom")
{
	GuiTitle := c_Lang012
	If (s_Caller = "Find")
	{
		GuiControl, 24:ChooseString, IECmd, %GotoRes1%
		GoSub, IECmd
	}
}
If (A_ThisLabel = "ComInt")
{
	GuiControl, 24:Choose, TabControl, 2
	If (s_Caller = "Find")
		GuiControl, 24:ChooseString, ComCLSID, %GotoRes1%
	GoSub, TabControl
	GuiTitle := c_Lang013
}
Else If (A_ThisLabel = "RunScrLet")
{
	GuiControl, 24:Choose, TabControl, 3
	GoSub, TabControl
	GuiTitle := c_Lang155
}
GuiControl, 24:Choose, IEWindows, %SelIEWin%
Gui, 24:Show, , %GuiTitle%
Tooltip
return

IEComCancel:
24GuiClose:
24GuiEscape:
Gui, 1:-Disabled
Gui, 24:Destroy
s_Caller = 
return

IEComApply:
IEComOK:
Gui, 24:+OwnDialogs
Gui, 24:Submit, NoHide
If (s_Caller <> "Edit")
	TimesX := 1
GuiControlGet, VState, 24:Enabled, Value
If (VState = 0)
	Value := ""
GuiControlGet, VState, 24:Enabled, DefEl
If ((VState = 0) || (DefEl = ""))
	DefEl := "", Ident := ""
If Get
{
	If (Value = "")
	{
		Tooltip, %c_Lang127%, 25, 145
		return
	}
	Try
		z_Check := VarSetCapacity(%Value%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		return
	}
	Type := cType33
}
Else
	Type := cType32
If (Value <> "")
	Details := Value
Else
	Details := ""
If (Ident = "ID")
	DefElInd := ""
If (Method = 1)
	Action := "Method:"
Else If (Property = 1)
	Action := "Property:"
Action .= IECmd ":" Ident, Target := DefEl ":" DefElInd
If LoadWait
	Load := "LoadWait"
Else
	Load := ""
ControlGet, SelIEWinName, Choice,, ComboBox2, ahk_id %CmdWin%
SelIEWin := IEWindows
If (SelIEWinName = "[blank]")
	o_ie := ""
Else
	o_ie := IEGet(SelIEWinName)
If (A_ThisLabel <> "IEComApply")
{
	Gui, 1:-Disabled
	Gui, 24:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type, Target, Load)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Action , Details, TimesX, DelayG, Type, Target, Load)
,	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
	,	LV_Insert(RowNumber, "Check", RowNumber, Action , Details, TimesX, DelayG, Type, Target, Load)
	,	RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "IEComApply")
	Gui, 24:Default
Else
{
	s_Caller = 
	GuiControl, chMacro:Focus, InputList%A_List%
}
return

ComApply:
ComOK:
Gui, 24:+OwnDialogs
Gui, 24:Submit, NoHide
StringReplace, ComSc, ComSc, `n, ``n, All
If ((ComHwnd = "") || (ComSc = ""))
	return
If (s_Caller <> "Edit")
	TimesX := 1
Try
	z_Check := VarSetCapacity(%ComHwnd%)
Catch
{
	MsgBox, 16, %d_Lang007%, %d_Lang041%
	return
}
If (VarName <> "")
{
	Try
		z_Check := VarSetCapacity(%VarName%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		return
	}
}
If ((ComCLSID = "InternetExplorer.Application") && LoadWait)
	Load := "LoadWait"
Else
	Load := ""
Action := ComHwnd ":" VarName
If (A_ThisLabel <> "ComApply")
{
	Gui, 1:-Disabled
	Gui, 24:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, ComSc, TimesX, DelayX, cType34, ComCLSID, Load)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Action, ComSc, TimesX, DelayG, cType34, ComCLSID, Load)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, Action, ComSc, TimesX, DelayG, cType34, ComCLSID, Load)
		RowNumber++
	}
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "ComApply")
	Gui, 24:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

ScLetApply:
ScLetOK:
Gui, 24:+OwnDialogs
Gui, 24:Submit, NoHide
StringReplace, ScLet, ScLet, `n, ``n, All
If (ScLet = "")
	return
If (s_Caller <> "Edit")
	TimesX := 1
Action := (RunVB = 1) ? "VB:" : "JS:"
Type := (RunVB = 1) ? cType42 : cType43
If (A_ThisLabel <> "ScLetApply")
{
	Gui, 1:-Disabled
	Gui, 24:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, ScLet, TimesX, DelayX, Type, "ScriptControl")
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Action, ScLet, TimesX, DelayG, Type, "ScriptControl")
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, Action, ScLet, TimesX, DelayG, Type, "ScriptControl")
		RowNumber++
	}
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "ScLetApply")
	Gui, 24:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

IECmd:
Gui, 24:Submit, NoHide
If IECmd in %NoElemList%
{
	GuiControl, 24:Disable, DefEl
	GuiControl, 24:Disable, DefElInd
	GuiControl, 24:Disable, GetEl
	GuiControl, 24:Disable, Ident
	GuiControl, 24:, LoadWait, 1
}
Else
{
	GuiControl, 24:Enable, DefEl
	GuiControl, 24:Enable, DefElInd
	GuiControl, 24:Enable, GetEl
	GuiControl, 24:Enable, Ident
	GuiControl, 24:, LoadWait, 0
}
If IECmd in %SetOnlyList%
{
	GuiControl, 24:, Set, 1
	GuiControl, 24:Enable, Set
	GuiControl, 24:Disable, Get
	GuiControl, 24:Enable, Value
}
Else If IECmd in %GetOnlyList%
{
	GuiControl, 24:, Get, 1
	GuiControl, 24:Enable, Get
	GuiControl, 24:Disable, Set
	GuiControl, 24:Enable, Value
	GuiControl, 24:, LoadWait, 0
}
Else
{
	GuiControl, 24:Enable, Get
	GuiControl, 24:Enable, Set
}
If IECmd in %NoValueList%
	GuiControl, 24:Disable, Value
Else
	GuiControl, 24:Enable, Value
Gui, 24:Submit, NoHide
If Set
	GuiControl, 24:, ValueT, %c_Lang056%:
Else If Get
	GuiControl, 24:, ValueT, %c_Lang057%:
If IECmd in %MethodList%
{
	GuiControl, 24:Disable, Method
	GuiControl, 24:Disable, Property
	GuiControl, 24:, Method, 1
}
Else If IECmd in %ProperList%
{
	GuiControl, 24:Disable, Method
	GuiControl, 24:Disable, Property
	GuiControl, 24:, Property, 1
}
Else
{
	GuiControl, 24:Enable, Method
	GuiControl, 24:Enable, Property
}
Try
	GuiControl, 24:, ComTip, % Tip_%IECmd%
Catch
	GuiControl, 24:, ComTip
return

ComSc:
Gui, 24:Submit, NoHide
If InStr(ComSc, "`n")
{
	GuiControl, 24:, VarName
	GuiControl, 24:Disabled, VarName
}
Else
	GuiControl, 24:Enabled, VarName
return

ActiveObj:
Gui, 24:Submit, NoHide
Gui, 24:+OwnDialogs
If ((ComHwnd = "") || (ComCLSID = ""))
{
	MsgBox, 16, %d_Lang007%, %d_Lang048%
	return
}
Try
	z_Check := VarSetCapacity(%ComHwnd%)
Catch
{
	MsgBox, 16, %d_Lang007%, %d_Lang041%
	return
}
%ComHwnd% := "", Title := ""
If (ComCLSID = "InternetExplorer.Application")
{
	CoordMode, Mouse, Window
	NoKey := 1, L_Label := ComCLSID
	WinMinimize, ahk_id %CmdWin%
	SetTimer, WatchCursorIE, 100
	StopIt := 0
	WaitFor.Key("RButton")
	SetTimer, WatchCursorIE, off
	ToolTip
	Sleep, 200
	NoKey := 0, L_Label := ""
	WinActivate, ahk_id %CmdWin%
	If (StopIt)
		Exit
	Try
		%ComHwnd% := IEGet()
	If IsObject(%ComHwnd%)
	{
		Title := %ComHwnd%["Document"]["Title"]
		MsgBox, 64, %c_Lang099%, %d_Lang046%`n`n%Title%
	}
	Else
		MsgBox, 16, %c_Lang099%, %d_Lang047%
	StopIt := 1
}
Else If (ComCLSID = "Excel.Application")
{
	CoordMode, Mouse, Window
	NoKey := 1
	WinMinimize, ahk_id %CmdWin%
	SetTimer, WatchCursorXL, 100
	StopIt := 0
	WaitFor.Key("RButton")
	SetTimer, WatchCursorXL, off
	ToolTip
	Sleep, 200
	NoKey := 0
	WinActivate, ahk_id %CmdWin%
	If (StopIt)
		Exit
	Try
	{
		%ComHwnd% := ComObjActive(ComCLSID)
	,	Title := %ComHwnd%["ActiveWorkbook"]["Name"]
	}
	If IsObject(%ComHwnd%)
	{
		MsgBox, 64, %c_Lang099%, %d_Lang046%`n`n%Title%
	}
	Else
		MsgBox, 16, %c_Lang099%, %d_Lang047%
	StopIt := 1
}
Else
{
	Try
		%ComHwnd% := ComObjActive(ComCLSID)
	If IsObject(%ComHwnd%)
		MsgBox, 64, %c_Lang099%, %d_Lang046%
	Else
		MsgBox, 16, %c_Lang099%, %d_Lang047%
}
return

TabControl:
Gui, 24:Submit, NoHide
If (TabControl = 2)
{
	If (ComCLSID = "InternetExplorer.Application")
	{
		GuiControl, 24:Enable, DefEl
		GuiControl, 24:Enable, DefElInd
		GuiControl, 24:Enable, GetEl
		GuiControl, 24:Enable, Ident
		GuiControl, 24:Enable, LoadWait
	}
	Else
	{
		GuiControl, 24:Disabled, DefEl
		GuiControl, 24:Disabled, DefElInd
		GuiControl, 24:Disabled, GetEl
		GuiControl, 24:Disabled, Ident
		GuiControl, 24:Disabled, LoadWait
	}
	GuiControl, 24:, LoadWait, 0
}
Else
{
	GuiControl, 24:Enable, LoadWait
	GoSub, IECmd
}
If (TabControl = 3)
{
	GuiControl, 24:Hide, PgTxt
	GuiControl, 24:Hide, DefEl
	GuiControl, 24:Hide, DefElInd
	GuiControl, 24:Hide, GetEl
	GuiControl, 24:Hide, Ident
	GuiControl, 24:Hide, LoadWait
}
Else
{
	GuiControl, 24:Show, PgTxt
	GuiControl, 24:Show, DefEl
	GuiControl, 24:Show, DefElInd
	GuiControl, 24:Show, GetEl
	GuiControl, 24:Show, Ident
	GuiControl, 24:Show, LoadWait
}
return

RefreshIEW:
IEWindows := ListIEWindows()
GuiControl, 24:, IEWindows, |%IEWindows%
return

ExpView:
Gui, Submit, NoHide
Script := (TabControl = 2) ? ComSc : ScLet
Gui, 30:+owner1 -MinimizeBox +E0x00000400 +hwndCmdWin
Gui, 24:+Disabled
Gui, 30:Add, Custom, ClassToolbarWindow32 hwndhTbText gTbText 0x0800 0x0100 0x0040
Gui, 30:Font, s9, Courier New
Gui, 30:Add, Edit, Section xm ym+25 vTextEdit gTextEdit WantTab W720 R30, %Script%
Gui, 30:Font
Gui, 30:Add, Button, -Wrap Section Default xm y+15 W75 H23 gExpViewOK, %c_Lang020%
Gui, 30:Add, Button, -Wrap ys W75 H23 gExpViewCancel, %c_Lang021%
Gui, 30:Add, StatusBar
Gui, 30:Default
SB_SetParts(480, 80)
SB_SetText(c_Lang025, 1)
SB_SetText("length: " 0, 2)
SB_SetText("lines: " 0, 3)
GoSub, TextEdit
Gui, 30:Show,, %GuiTitle%
TB_Define(TbText, hTbText, hIL_Icons, FixedBar.Text, FixedBar.TextOpt)
,	TBHwndAll[7] := TbText
GuiControl, 30:Focus, TextEdit
return

ExpViewOK:
Gui, Submit, NoHide
Gui, 24:-Disabled
Gui, 30:Destroy
Gui, 24:Default
GuiControl,, % (TabControl = 2) ? "ComSc" : "ScLet", %TextEdit%
GoSub, ComSc
return

ExpViewCancel:
30GuiClose:
30GuiEscape:
Gui, 24:-Disabled
Gui, 30:Destroy
return

DonatePayPal:
If (Lang = "Pt")
	Run, "https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=rodolfoub`%40gmail`%2ecom&lc=BR&item_name=Pulover`%27s`%20Macro`%20Creator&item_number=App`%2ePMC`%2eBr&currency_code=BRL&bn=PP`%2dDonationsBF`%3abtn_donateCC_LG`%2egif`%3aNonHosted"
Else
	Run, "https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=rodolfoub`%40gmail`%2ecom&lc=US&item_name=Pulover`%27s`%20Macro`%20Creator&item_number=App`%2ePMC&currency_code=USD&bn=PP`%2dDonationsBF`%3abtn_donateCC_LG`%2egif`%3aNonHosted"
return

26GuiEscape:
TipClose:
Gui, 26:Submit
Gui, 26:Destroy
WinActivate,,, ahk_id %PMCWinID%
return

TipClose2:
Gui, 26:Submit
Gui, 26:Destroy
return

TipClose3:
NextTip++
Gui, 26:Submit
Gui, 26:Destroy
return

CmdFind:
ShowTips:
Gui 26:+LastFoundExist
IfWinExist
	GoSub, TipClose
If (NextTip > MaxTips)
	NextTip := 1
Gui, 26:-MinimizeBox +HwndStartTipID +owner1
If (A_ThisLabel <> "CmdFind")
{
	Gui, 26:Color, FFFFFF
	Gui, 26:Font, Bold s10, Tahoma
	Gui, 26:Add, Text, w220, %d_Lang072%
	Gui, 26:Font
	Gui, 26:Font,, Tahoma
	Gui, 26:Add, Text, w220, %d_Lang069%
	Gui, 26:Font
	Gui, 26:Add, Button, Section -Wrap xm+60 W75 H23 gDonatePayPal, %d_Lang070%
	Gui, 26:Add, Button, -Wrap ys W75 H23 gTipClose3, %d_Lang071%
	Gui, 26:Add, Checkbox, -Wrap Checked%ShowTips% xm y+20 W220 vShowTips R1, %d_Lang067%
	Gui, 26:Add, Text, x+10 ym h255 0x11
	Gui, 26:Add, Pic, x+1 ym Icon73, %ResDllPath%
	Gui, 26:Add, Text, Section yp x+10, %d_Lang068%%A_Space%
	Gui, 26:Add, Text, yp x+0 vCurrTip, %NextTip%%A_Space%%A_Space%%A_Space%
	Gui, 26:Add, Text, yp x+0, / %MaxTips%
	Gui, 26:Add, Edit, xs W350 r6 vTipDisplay ReadOnly -0x200000 -E0x200, % StartTip_%NextTip%
	Gui, 26:Add, Button, Section -Wrap y+0 W90 H25 vPTip gPrevTip, %d_Lang022%
	Gui, 26:Add, Button, -Wrap yp x+5 W90 H25 vNTip gNextTip, %d_Lang021%
	Gui, 26:Add, Text, xs-30 w380 0x10
	If (NextTip = 1)
		GuiControl, 26:Disable, PTip
}
Else
	Gui, 26:+Toolwindow
Gui, 26:Font, Bold
Gui, 26:Add, Text, yp+5 -Wrap r1, %d_Lang074%:
Gui, 26:Font
Gui, 26:Add, Edit, -Wrap W380 r1 vFindCmd gFindCmd
Gui, 26:Add, Listbox, % ((A_ThisLabel <> "CmdFind") ? "r5" : "r10") " y+0 W380 hwndhFindRes vFindResult gFindResult Sort"
GuiControl, 26:Focus, FindCmd
Gui, 26:Show,, %AppName%
return

PrevTip:
If (NextTip = 1)
	return
NextTip--
GuiControl, 26:, CurrTip, %NextTip%
GuiControl, 26:, TipDisplay, % StartTip_%NextTip%
GuiControl, 26:Enable, NTip
If (NextTip = 1)
{
	GuiControl, 26:Disable, PTip
	GuiControl, 26:Focus, NTip
}
return

NextTip:
If (NextTip = MaxTips)
	return
NextTip++
GuiControl, 26:, CurrTip, %NextTip%
GuiControl, 26:, TipDisplay, % StartTip_%NextTip%
GuiControl, 26:Enable, PTip
If (NextTip = MaxTips)
{
	GuiControl, 26:Disable, NTip
	GuiControl, 26:Focus, PTip
}
return

FindCmd:
Gui, 26:Submit, NoHide
GuiControl, 26:, FindResult, |
If (FindCmd = "")
	return
Loop, Parse, KeywordsList, |
{
	SearchIn := A_LoopField
	Loop, Parse, %A_LoopField%_Keywords, `,
	{
		If InStr(A_LoopField, FindCmd)
		{
			If (SearchIn = "Type")
				SearchIn := "Type" A_Index
			GuiControl, 26:, FindResult, % A_LoopField "`t`t[" %SearchIn%_Path "]"
		}
	}
}
return

NextResult:
ControlSend,, {Down}, ahk_id %hFindRes%
return

PrevResult:
ControlSend,, {Up}, ahk_id %hFindRes%
return

FindResult:
If (A_GuiEvent <> "DoubleClick")
	return
GoResult:
Gui, 26:Submit, NoHide
If (FindResult = "")
	return
RegExMatch(FindResult, "(.*?)\t+\[(.*)\]", GotoRes)
Loop, Parse, KeywordsList, |
{
	SearchIn := A_LoopField
	Loop, Parse, %A_LoopField%_Keywords, `,
	{
		If ((SearchIn = "Type") && (GotoRes1 = A_LoopField))
			SearchIn := "Type" A_Index
		If ((A_LoopField = GotoRes1) && (%SearchIn%_Path = GotoRes2))
		{
			s_Caller := "Find"
			GoSub, TipClose3
			Goto, % %SearchIn%_Goto
		}
	}
}
return

RunTimer:
Gui, 27:+owner1 -MinimizeBox
Gui, 1:+Disabled
Gui, 27:Add, Groupbox, W180 H100
Gui, 27:Add, Edit, ys+15 xs+15 Limit Number W150
Gui, 27:Add, UpDown, vTimerDelayX 0x80 Range0-9999999, %TimerDelayX%
Gui, 27:Add, Radio, -Wrap Section Checked%TimerMsc% yp+25 W150 vTimerMsc R1, %c_Lang018%
Gui, 27:Add, Radio, -Wrap Checked%TimerSec% W150 vTimerSec R1, %c_Lang019%
Gui, 27:Add, Radio, -Wrap Checked%TimerMin% W150 vTimerMin R1, %c_Lang154%
Gui, 27:Add, Radio, -Wrap Section Group Checked%RunOnce% xm W180 vRunOnce gTimerSub R1, %t_Lang078%
Gui, 27:Add, Radio, -Wrap Checked%TimedRun% W180 vTimedRun gTimerSub R1, %t_Lang079%
Gui, 27:Add, Checkbox, -Wrap Checked%RunFirst% xp+15 y+5 W180 vRunFirst R1 Disabled, %t_Lang106%
Gui, 27:Add, Button, -Wrap Section Default xm W75 H23 gTimerOK, %c_Lang020%
Gui, 27:Add, Button, -Wrap ys W75 H23 gTimerCancel, %c_Lang021%
If !(Timer_ran)
{
	GuiControl, 27:, TimerDelayX, 250
	GuiControl, 27:, TimerMsc, 1
	GuiControl, 27:, RunOnce, 1
	GuiControl, 27:, RunFirst, 0
}
If (TimedRun)
	GuiControl, 27:Enable, RunFirst
Gui, 27:Show,, %t_Lang080%
return

TimerSub:
Gui, 27:Submit, NoHide
GuiControl, 27:Enable%TimedRun%, RunFirst
return

TimerOK:
Gui, 27:Submit, NoHide
Gui, 1:-Disabled
Gui, 27:Destroy
Gui, chMacro:Default
Timer_ran := True
If ListCount%A_List% = 0
	return
GoSub, SaveData
StopIt := 0
Tooltip
WinMinimize, ahk_id %PMCWinID%
If TimerSec = 1
	DelayX := TimerDelayX * 1000
Else If TimerMin = 1
	DelayX := TimerDelayX * 60000
Else
	DelayX := TimerDelayX
If RunOnce = 1
	DelayX := DelayX * -1
ActivateHotkeys(0, 1, 1, 1, 1)
aHK_Timer := A_List
SetTimer, RunTimerOn, %DelayX%
If (TimedRun) && (RunFirst)
	GoSub, RunTimerOn
return

RunTimerOn:
If StopIt
{
	SetTimer, RunTimerOn, Off
	aHK_Timer := False
	return
}
If (aHK_On := Playback(aHK_Timer))
	GoSub, f_RunMacro
FreeMemory()
return

TimerCancel:
27GuiClose:
27GuiEscape:
Gui, 1:-Disabled
Gui, 27:Destroy
return

PlayFrom:
pb_From := !pb_From
If !(pb_From)
	Menu, MacroMenu, Uncheck, %r_lang011%`t%_s%Alt+1
Else
	Menu, MacroMenu, Check, %r_lang011%`t%_s%Alt+1
Menu, MacroMenu, Uncheck, %r_lang012%`t%_s%Alt+2
Menu, MacroMenu, Uncheck, %r_lang013%`t%_s%Alt+3
pb_To := "", pb_Sel := ""
return

PlayTo:
pb_To := !pb_To
If !(pb_To)
	Menu, MacroMenu, Uncheck, %r_lang012%`t%_s%Alt+2
Else
	Menu, MacroMenu, Check, %r_lang012%`t%_s%Alt+2
Menu, MacroMenu, Uncheck, %r_lang011%`t%_s%Alt+1
Menu, MacroMenu, Uncheck, %r_lang013%`t%_s%Alt+3
pb_From := "", pb_Sel := ""
return

PlaySel:
pb_Sel := !pb_Sel
If !(pb_Sel)
	Menu, MacroMenu, Uncheck, %r_lang013%`t%_s%Alt+3
Else
	Menu, MacroMenu, Check, %r_lang013%`t%_s%Alt+3
Menu, MacroMenu, Uncheck, %r_lang011%`t%_s%Alt+1
Menu, MacroMenu, Uncheck, %r_lang012%`t%_s%Alt+2
pb_To := "", pb_From := ""
return

TestRun:
GoSub, b_Enable
If (ListCount%A_List% = 0)
	return
Gui, 1:Submit, NoHide
Gui, chMacro:Submit, NoHide
GoSub, SaveData
Gui, chMacro:Default
Gui, chMacro:ListView, InputList%A_List%
ActivateHotkeys(0, 0, 1, 1, 1)
StopIt := 0
Tooltip
WinMinimize, ahk_id %PMCWinID%
aHK_On := [A_List]
GoSub, f_RunMacro
return

PlayStart:
Gui, 1:+OwnDialogs
Gui, 1:Submit, NoHide
GoSub, b_Enable
If !ListCount
	return
Gui, chMacro:Submit, NoHide
GoSub, PlayActive
If (ActiveKeys = "Error")
	return
If !DontShowPb
{
	Gui 26:+LastFoundExist
	IfWinExist
		GoSub, TipClose
	Gui, 26:-SysMenu +HwndTipScrID
	Gui, 26:Color, FFFFFF
	; Gui, 26:Font, s7
	Gui, 26:Add, Pic, y+20 Icon91, %ResDllPath%
	Gui, 26:Add, Text, yp x+10, %d_Lang051%`n`n%d_Lang043%`n
	Gui, 26:Add, Checkbox, -Wrap W300 vDontShowPb R1, %d_Lang053%
	Gui, 26:Add, Button, -Wrap Default y+10 W75 H25 gTipClose, %c_Lang020%
	Gui, 26:Show,, %AppName%
}
If (HideMainWin)
	GoSub, ShowHide
Else
	WinMinimize, ahk_id %PMCWinID%
If (OnScCtrl)
	GoSub, ShowControls
Gui, chMacro:Default
Gui, chMacro:ListView, InputList%A_List%
return

PlayActive:
Pause, Off
If (ListCount = 0)
	return
GoSub, SaveData
GoSub, ActivateHotkeys
If (ActiveKeys = "Error")
{
	MsgBox, 16, %d_Lang007%, %d_Lang032%
	return
}
If !ActiveKeys
{
	TrayTip, %AppName%, %d_Lang009%,,3
	return
}
StopIt := 0
Tooltip
return

OnScControls:
If (WinExist("ahk_id " PMCOSC))
{
	GoSub, 28GuiClose
	return
}
ShowControls:
Menu, ViewMenu, Check, %v_lang004%`t%_s%Ctrl+B
Menu, Tray, Check, %y_Lang003%
Gui, 28:Show, % OSCPos (ShowProgBar ? "H40" : "H30") " W415 NoActivate", %AppName%
return

BuildOSCWin:
Gui, 28: +Toolwindow +AlwaysOntop +HwndPMCOSC +E0x08000000
If !(OSCaption)
	Gui, 28:-Caption
Gui, 28:Add, Edit, W40 H23 vOSHKEd Number
Gui, 28:Add, UpDown, hwndOSHK vOSHK gOSHK 0x80 Horz 16 Range1-%TabCount%, %A_List%
Gui, 28:Add, Custom, ClassToolbarWindow32 hwndhTbOSC gTbOSC x55 y5 W320 H25 0x0800 0x0100 0x0040 0x0008 0x0004
Gui, 28:Add, Progress, ym+25 xm W120 H10 vOSCProg c20D000
Gui, 28:Font
Gui, 28:Font, s6 Bold
Gui, 28:Add, Text, -Wrap yp x+0 W180 r1 vOSCProgTip
Gui, 28:Add, Slider, yp-2 x+0 W65 H10 vOSTrans gTrans NoTicks Thick20 ToolTip Range25-255, %OSTrans%
Gui, 28:Show, % OSCPos (ShowProgBar ? " H40" : " H30") " W380 NoActivate Hide", %AppName%
WinSet, Transparent, %OSTrans%, ahk_id %PMCOSC%
return

OSHK:
Gui, 28:Submit, NoHide
Gui, chMacro:Default
GuiControl, chMacro:Choose, A_List, %OSHK%
GoSub, TabSel
return

OSPlay:
Gui, 28:Submit, NoHide
Gui, chMacro:Default
GoSub, b_Enable
If (ListCount%OSHK% = 0)
	return
If !(PlayOSOn)
{
	ActivateHotkeys("", "", 1, 1, 1)
	StopIt := 0
	Tooltip
	SetTimer, OSPlayOn, -1
}
Else
	GoSub, f_PauseKey
return

OSStop:
If (Record)
	GoSub, RecStart
Else
	GoSub, f_AbortKey
return

OSPlayOn:
aHK_On := [OSHK]
Gosub, f_RunMacro
return

OSClear:
Gui, 28:Submit, NoHide
Gui, chMacro:Default
Gui, chMacro:Listview, %OSHK%
MsgBox, 1, %d_Lang019%, %d_Lang020%
IfMsgBox, OK
	LV_Delete()
GoSub, b_Start
GoSub, RowCheck
return

ProgBarToggle:
Gui, 28:Submit, NoHide
TB_Edit(TbOSC, "ProgBarToggle", ShowProgBar := !ShowProgBar)
GuiControl,, OSCProg
GuiControl,, OSCProgTip
GoSub, 28GuiSize
return

Trans:
Gui, 28:Submit, NoHide
WinSet, Transparent, %OSTrans%, ahk_id %PMCOSC%
return

28GuiClose:
OSCClose:
Gui, 28: +LastFound
WinGetPos, OSX, OSY
OSCPos := "X" OSX " Y" OSY
Gui, 28:Hide
Menu, ViewMenu, Uncheck, %v_lang004%`t%_s%Ctrl+B
Menu, Tray, Uncheck, %y_Lang003%
return

ToggleTB:
If (OSCaption := !OSCaption)
	Gui, 28:+Caption
Else
	Gui, 28:-Caption
return

WinKey:
OnScCtrl:
HideMainWin:
TB_Edit(TbSettings, A_ThisLabel, %A_ThisLabel% := !%A_ThisLabel%)
return

Capt:
SetTimer, MainLoop, % (Capt := !Capt) ? 100 : "Off"
Input
TB_Edit(TbSettings, "Capt", Capt)
return

InputList:
Gui, chMacro:ListView, InputList%A_List%
If ((A_GuiEvent == "I") || (A_GuiEvent == "Normal") || (A_GuiEvent == "A")
|| (A_GuiEvent == "C") || (A_GuiEvent == "K") || (A_GuiEvent == "F")
|| (A_GuiEvent == "f"))
{
	If (AutoRefresh = 1)
		GoSub, PrevRefresh
}
If (A_GuiEvent == "F")
{
	Input
	ListFocus := 1
	If Capt
		SetTimer, MainLoop, 100
}
If (A_GuiEvent == "f")
{
	Input
	ListFocus := 0
	SetTimer, MainLoop, Off
}
If (A_GuiEvent == "ColClick")
{
	If (A_EventInfo = 1)
	{
		ShowLoopIfMark := !ShowLoopIfMark
		GoSub, RowCheck
	}
	Else If (A_EventInfo = 2)
	{
		KeyWait, LButton
		KeyWait, LButton, D T%DClickSpd%
		If ErrorLevel
		{
			SelectedRow := LV_GetNext()
			LV_GetText(SelType, SelectedRow, A_EventInfo)
			SelectByType(SelType, A_EventInfo)
		}
		Else
		{
			ShowActIdent := !ShowActIdent
			GoSub, RowCheck
		}
	}
	Else
	{
		SelectedRow := LV_GetNext()
		LV_GetText(SelType, SelectedRow, A_EventInfo)
		SelectByType(SelType, A_EventInfo)
	}
}
If (A_GuiEvent == "D")
{
	If (AllowRowDrag)
	{
		LV_Rows.Drag()
		GoSub, b_Start
		GoSub, RowCheck
	}
}
If (A_GuiEvent == "RightClick")
{
	RowNumber = 0
,	RowSelection := LV_GetCount("Selected")
,	RowNumber := LV_GetNext(RowNumber - 1)
}
If (A_GuiEvent <> "DoubleClick")
	return
RowNumber := LV_GetNext()
If !RowNumber
	return
GoSub, Edit
Tooltip
return

GuiContextMenu:
MouseGetPos,,,, cHwnd, 2
If (cHwnd = ListID%A_List%)
	Menu, EditMenu, Show, %A_GuiX%, %A_GuiY%
Else
{
	tbPtr := TB_GetHwnd(cHwnd)
	If IsObject(tbPtr)
	{
		If ((tbPtr.tbHwnd = hTbPrev) || (tbPtr.tbHwnd = hTbPrevF))
			return
		Menu, TbMenu, Add, %w_Lang090%, Customize
		Menu, TbMenu, Add, %w_Lang093%, TbHide
		Menu, TbMenu, Show
		Menu, TbMenu, DeleteAll
	}
}
return

TbCustomize:
bID := RBIndexTB[A_ThisMenuItemPos]
,	tBand := RbMain.IDToIndex(bID), RbMain.GetBand(tBand,,,,,,, cHwnd)
,	tbPtr := TB_GetHwnd(cHwnd), tbPtr.Customize()
GoSub, SetIdealSize
return

Customize:
tbPtr.Customize(), TB_IdealSize(tbFile, 10)
GoSub, SetIdealSize
return

SetIdealSize:
TB_IdealSize(tbRecPlay, 11), TB_IdealSize(tbSettings, 12)
,	TB_IdealSize(tbCommand, 15), TB_IdealSize(tbEdit, 19)
return

TbHide:
For Index, Ptr in TBHwndAll
{
	If (Ptr.tbHwnd = tbPtr.tbHwnd)
	{
		bID := RBIndexTB[Index]
		break
	}
}
GoSub, ShowHideBandOn
return

CopyTo:
Gui, 1:Submit, NoHide
Gui, chMacro:Default
Gui, chMacro:ListView, InputList%A_List%
Menu, CopyTo, Show
return

DuplicateList:
Gui, chMacro:Default
s_List := A_List
GuiControlGet, c_Time, 1:, TimesG
GoSub, TabPlus
d_List := TabCount, RowSelection := 0
GoSub, CopySelection
HistoryMacro%A_List% := new LV_Rows()
GuiControl, 1:, TimesG, %c_Time%
GoSub, b_Start
return

CopyList:
Gui, chMacro:Default
Gui, chMacro:ListView, InputList%A_List%
s_List := A_List, d_List := A_ThisMenuItemPos, RowSelection := LV_GetCount("Selected")
GoSub, CopySelection
return

CopySelection:
Gui, chMacro:Default
RowNumber := 0
If RowSelection = 0
{
	Loop, % ListCount%s_List%
	{
		RowNumber++
		Gui, chMacro:ListView, InputList%s_List%
		LV_GetTexts(RowNumber, Action, Details, TimesX, DelayX, Type, Target, Window, Comment, Color)
		ckd := (LV_GetNext(RowNumber-1, "Checked")=RowNumber) ? 1 : 0
		Gui, chMacro:ListView, InputList%d_List%
		LV_Add("Check" ckd, ListCount%d_List%+1, Action, Details, TimesX, DelayX, Type, Target, Window, Comment, Color)
	}
}
Else
{
	Loop, %RowSelection%
	{
		Gui, chMacro:ListView, InputList%s_List%
		RowNumber := LV_GetNext(RowNumber)
		LV_GetTexts(RowNumber, Action, Details, TimesX, DelayX, Type, Target, Window, Comment, Color)
		ckd := (LV_GetNext(RowNumber-1, "Checked")=RowNumber) ? 1 : 0
		Gui, chMacro:ListView, InputList%d_List%
		LV_Add("Check" ckd, ListCount%d_List%+1, Action, Details, TimesX, DelayX, Type, Target, Window)
	}
}
Gui, chMacro:ListView, InputList%d_List%
ListCount%d_List% := LV_GetCount()
HistCheck(d_List)
GoSub, RowCheck
Gui, chMacro:ListView, InputList%s_List%
GuiControl, Focus, InputList%A_List%
return

Duplicate:
Gui, chMacro:Default
TempData := new LV_Rows()
TempData.Copy()
If TempData.Paste()
{
	GoSub, b_Start
	GoSub, RowCheck
}
TempData := ""
GuiControl, Focus, InputList%A_List%
return

CopyRows:
Gui, chMacro:Default
If (LV_GetCount("Selected") = 0)
	return
CopyRows := new LV_Rows()
CopyRows.Copy()
return

CutRows:
Gui, chMacro:Default
If (LV_GetCount("Selected") = 0)
	return
CopyRows := new LV_Rows()
CopyRows.Cut()
GoSub, b_Start
GoSub, RowCheck
GuiControl, Focus, InputList%A_List%
return

PasteRows:
Gui, chMacro:Default
If CopyRows.Paste()
{
	GoSub, b_Start
	GoSub, RowCheck
}
return

Remove:
Gui, 1:+OwnDialogs
Gui, 1:Submit, NoHide
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	MsgBox, 1, %d_Lang019%, %d_Lang020%
	IfMsgBox, OK
		LV_Delete()
	IfMsgBox, Cancel
		return
}
Else
{
	RowNumber := 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber - 1)
		If !RowNumber
			break
		LV_Delete(RowNumber)
	}
}
LV_Modify(LV_GetNext(0, "Focused"), "Select")
GoSub, b_Start
GoSub, RowCheck
GuiControl, Focus, InputList%A_List%
return

Undo:
Gui, 1:Submit, NoHide
Gui, chMacro:Default
Gui, chMacro:Listview, InputList%A_List%
GuiControl, chMacro:-Redraw, InputList%A_List%
SelRow := LV_GetNext(0, "Focused"), HistoryMacro%A_List%.Undo()
GoSub, RowCheck
GoSub, b_Enable
GuiControl, chMacro:+Redraw, InputList%A_List%
SelRow ? LV_Modify(SelRow, "Select Focus Vis")
return

Redo:
Gui, 1:Submit, NoHide
Gui, chMacro:Default
Gui, chMacro:Listview, InputList%A_List%
GuiControl, chMacro:-Redraw, InputList%A_List%
SelRow := LV_GetNext(0, "Focused"), HistoryMacro%A_List%.Redo()
GoSub, RowCheck
GoSub, b_Enable
GuiControl, chMacro:+Redraw, InputList%A_List%
SelRow ? LV_Modify(SelRow, "Select Focus Vis")
return

TabPlus:
Gui, 1:Submit, NoHide
TabCount++
GuiCtrlAddTab(TabSel, "Macro" TabCount)
Gui, chMacro:ListView, InputList%TabCount%
HistoryMacro%TabCount% := new LV_Rows(), HistoryMacro%TabCount%.Slot[1] := ""
Gui, chMacro:ListView, InputList%A_List%
GuiAddLV(TabCount)
GuiControl, chMacro:Choose, A_List, %TabCount%
GoSub, chMacroGuiSize
Menu, CopyTo, Add, Macro%TabCount%, CopyList
GuiControl, 28:+Range1-%TabCount%, OSHK

TabSel:
GoSub, SaveData
Gui, 1:Submit, NoHide
Gui, chMacro:Submit, NoHide
Gui, chMacro:ListView, InputList%A_List%
GoSub, chMacroGuiSize
GoSub, LoadData
GoSub, RowCheck
GuiControl, 28:, OSHK, %A_List%
GoSub, PrevRefresh
return

TabClose:
GoSub, SaveData
GoSub, ResetHotkeys
Gui, 1:Submit, NoHide
Gui, chMacro:Submit, NoHide
If (TabCount = 1)
	return
HistoryMacro%A_List% := ""
Menu, CopyTo, Delete, Macro%A_List%
s_Tab := A_List
Loop, % TabCount - A_List
{
	n_Tab := s_Tab+1
,	LV_Data := PMC.LVGet("InputList" n_Tab)
,	HistoryMacro%s_Tab% := HistoryMacro%n_Tab%
	Gui, chMacro:ListView, InputList%s_Tab%
	LV_Delete()
	PMC.LVLoad("InputList" s_Tab, LV_Data)
	Menu, CopyTo, Rename, % "Macro" n_Tab, Macro%s_Tab%
	s_Tab++
}
Gui, chMacro:ListView, InputList%s_Tab%
LV_Delete()
If (A_List <> TabCount)
{
	o_AutoKey.Remove(A_List)
	o_ManKey.Remove(A_List)
	o_TimesG.Remove(A_List)
}
TabCount--
s_List := ""
Loop, %TabCount%
	s_List .= "|Macro" A_Index
Gui, chMacro:ListView, InputList%A_List%
GuiControl, chMacro:, A_List, %s_List%
GuiControl, chMacro:Choose, A_List, % (A_List < TabCount) ? A_List : TabCount
Gui, 1:Submit, NoHide
Gui, chMacro:Submit, NoHide
GoSub, GuiSize
GoSub, LoadData
GoSub, RowCheck
GoSub, PrevRefresh
return

SaveData:
Gui, 1:Default
If (JoyHK = 1)
{
	GuiControlGet, HK_AutoKey, 1:, JoyKey
	If !RegExMatch(HK_AutoKey, "i)Joy\d+$")
		HK_AutoKey := ""
}
Else
	GuiControlGet, HK_AutoKey, 1:, AutoKey
GuiControlGet, ManKey, 1:, ManKey
GuiControlGet, TimesO, chTimes:, TimesG
o_AutoKey[A_List] := (WinKey = 1) ? "#" HK_AutoKey : HK_AutoKey
If (o_AutoKey[A_List] = "#")
	o_AutoKey[A_List] := "LWin"
o_ManKey[A_List] := ManKey, o_TimesG[A_List] := TimesO
return

LoadData:
Gui, 1:Default
If InStr(o_AutoKey[A_List], "Joy")
{
	TB_Edit(TbSettings, "SetJoyButton", JoyHK := 1)
	GuiControl, 1:, AutoKey
	GoSub, SetJoyHK
}
Else
{
	TB_Edit(TbSettings, "SetJoyButton", JoyHK := 0)
	GuiControl, 1:, JoyKey
	GuiControl, 1:, AutoKey, % LTrim(o_AutoKey[A_List], "#")
	GoSub, SetNoJoy
}
WinKey := InStr(o_AutoKey[A_List], "#") ? 1 : 0
,	TB_Edit(TbSettings, "WinKey", WinKey)
GuiControl, 1:, ManKey, % o_ManKey[A_List]
GuiControl, chTimes:, TimesG, % (o_TimesG[A_List] = "") ? 1 : o_TimesG[A_List]
return

GetHotkeys:
AutoKey := "", ManKey := ""
For Index, Key in o_AutoKey
	AutoKey .= Key "|"
For Index, Key in o_ManKey
	ManKey .= Key "|"
AutoKey := RTrim(AutoKey, "|"), ManKey := RTrim(ManKey, "|")
return

MoveUp:
Gui, chMacro:Default
GuiControl, chMacro:-Redraw, InputList%A_List%
LV_Rows.Move(1)
GoSub, RowCheck
HistCheck(A_List)
GuiControl, chMacro:+Redraw, InputList%A_List%
return

MoveDn:
Gui, chMacro:Default
GuiControl, chMacro:-Redraw, InputList%A_List%
LV_Rows.Move()
GoSub, RowCheck
HistCheck(A_List)
GuiControl, chMacro:+Redraw, InputList%A_List%
return

DelLists:
Gui, chMacro:Default
Loop, %TabCount%
{
	Gui, chMacro:ListView, InputList%A_Index%
	LV_Delete()
	GuiControl, chMacro:+Redraw, InputList%A_Index%
	Menu, CopyTo, Delete, Macro%A_Index%
}
Menu, CopyTo, Add, Macro1, CopyList
return

Order:
Gui, chMacro:Default
LV_Rows.Move(Order)
HistCheck(A_List)
GoSub, RowCheck
return

SelectAll:
Gui, chMacro:Default
LV_Modify(0, "Select")
return

SelectNone:
Gui, chMacro:Default
LV_Modify(0, "-Select")
return

InvertSel:
Gui, chMacro:Default
If (LV_GetCount("Selected") = 0)
	LV_Modify(0, "Select")
Else
{
	Loop, % ListCount%A_List%
	{
		If (LV_GetNext(A_Index-1) = A_Index)
			LV_Modify(A_Index, "-Select")
		Else
			LV_Modify(A_Index, "Select")
	}
}
return

CheckSel:
Gui, chMacro:Default
RowNumber = 0
Loop
{
	RowNumber := LV_GetNext(RowNumber)
	If !RowNumber
		break
	LV_Modify(RowNumber, "Check")
}
GoSub, b_Start
return

UnCheckSel:
Gui, chMacro:Default
RowNumber = 0
Loop
{
	RowNumber := LV_GetNext(RowNumber)
	If !RowNumber
		break
	LV_Modify(RowNumber, "-Check")
}
GoSub, b_Start
return

InvertCheck:
Gui, chMacro:Default
RowNumber = 0
Loop
{
	RowNumber := LV_GetNext(RowNumber)
	If !RowNumber
		break
	If (LV_GetNext(RowNumber-1, "Checked")=RowNumber)
		LV_Modify(RowNumber, "-Check")
	Else
		LV_Modify(RowNumber, "Check")
}
GoSub, b_Start
return

SelectCmd:
Gui, chMacro:Default
SelectByType(A_ThisMenuItem)
return

SelType:
Gui, chMacro:Default
SelectedRow := LV_GetNext()
LV_GetText(SelType, SelectedRow, 6)
SelectByType(SelType)
return

ApplyT:
Gui, 1:Submit, NoHide
Gui, chMacro:Default
ApplyTEd:
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
	LV_Modify(0, "Col4", (InStr(Rept, "%") ? Rept : TimesM))
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Modify(RowNumber, "Col4", (InStr(Rept, "%") ? Rept : TimesM))
	}
}
HistCheck(A_List)
return

ApplyI:
Gui, 1:Submit, NoHide
Gui, chMacro:Default
ApplyIEd:
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
	LV_Modify(0, "Col5", (InStr(Delay, "%") ? Delay : DelayG))
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Modify(RowNumber, "Col5", (InStr(Delay, "%") ? Delay : DelayG))
	}
}
HistCheck(A_List)
return

ApplyL:
Gui, 1:Submit, NoHide
Gui, chMacro:Default
StringReplace, sInput, sInput, SC15D, AppsKey
StringReplace, sInput, sInput, SC145, NumLock
StringReplace, sInput, sInput, SC154, PrintScreen
If sInput = 
	return
sKey := RegExReplace(sInput, "(.$)", "$l1"), tKey := sKey
GoSub, Replace
sKey := "{" sKey "}", RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, tKey, sKey, 1, DelayG, cType1)
	GoSub, b_Start
	LV_Modify(ListCount%A_List%, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, tKey, sKey, 1, DelayG, cType1)
		RowNumber++
	}
}
GoSub, RowCheck
GoSub, b_Start
return

InsertKey:
Gui, 1:Submit, NoHide
Gui, chMacro:Default
Gui, 31:+owner1 -MinimizeBox +Delimiter¢ +HwndCmdWin
Gui, 1:+Disabled
Gui, 31:Add, Groupbox, Section W220 H100
Gui, 31:Add, DDL, ys+15 xs+10 W200 vsKey, %KeybdList%
Gui, 31:Add, Radio, Checked W200 vKeystroke, %t_Lang108%
Gui, 31:Add, Radio, W200 vKeyDown, %t_Lang109%
Gui, 31:Add, Radio, W200 vKeyUp, %t_Lang110%
Gui, 31:Add, Button, -Wrap Section Default xm W75 H23 gInsertKeyOK, %c_Lang020%
Gui, 31:Add, Button, -Wrap ys W75 H23 gInsertKeyCancel, %c_Lang021%
Gui, 31:Show,, %t_Lang111%
return

InsertKeyOK:
Gui, 31:Submit, NoHide
If (KeyDown)
	State := " Down"
Else If (KeyUp)
	State := " Up"
Else
	State := ""
tKey := sKey, sKey := "{" sKey State "}"
Gui, 1:-Disabled
Gui, 31:Destroy
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, tKey, sKey, 1, DelayG, cType1)
	GoSub, b_Start
	LV_Modify(ListCount%A_List%, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, tKey, sKey, 1, DelayG, cType1)
		RowNumber++
	}
}
GoSub, RowCheck
GoSub, b_Start
return

InsertKeyCancel:
31GuiClose:
31GuiEscape:
Gui, 1:-Disabled
Gui, 31:Destroy
return

/*
Gui, Submit, NoHide
StringReplace, sInput, sInput, SC15D, AppsKey
StringReplace, sInput, sInput, SC145, NumLock
StringReplace, sInput, sInput, SC154, PrintScreen
If sInput = 
	return
sKey := RegExReplace(sInput, "(.$)", "$l1"), tKey := sKey
GoSub, Replace
sKey := "{" sKey "}", RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, tKey, sKey, 1, DelayG, cType1)
	GoSub, b_Start
	LV_Modify(ListCount%A_List%, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, tKey, sKey, 1, DelayG, cType1)
		RowNumber++
	}
}
GoSub, RowCheck
GoSub, b_Start
return
*/

EditButton:
Gui, 1:Submit, NoHide
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), RowNumber := LV_GetNext()
If (RowSelection = 1)
	GoSub, Edit
Else
	GoSub, MultiEdit
return

Edit:
GoSub, ClearPars
LV_GetTexts(RowNumber, Action, Details, TimesX, DelayX, Type, Target, Window, Comment)
If (Action = "[LoopEnd]")
	return
If Type in %cType7%,%cType38%,%cType39%,%cType40%,%cType41%
	Goto, EditLoop
If Type in %cType15%,%cType16%
	Goto, EditImage
If (Type = cType21)
	Goto, EditVar
If (Action = "[Control]")
	Goto, EditControl
If ((Details = "EndIf") || (Details = "Else") || (Action = "[LoopEnd]"))
	return
If (Type = cType17)
	Goto, EditSt
If Type in %cType18%,%cType19%
	Goto, EditMsg
If ((Type = cType11) || (Type = cType14)
|| InStr(FileCmdList, Type "|")) && (Action <> "[Pause]")
	Goto, EditRun
If Type in %cType29%,%cType30%
	return
If Type in %cType32%,%cType33%,%cType34%,%cType42%,%cType43%
	Goto, EditIECom
If InStr(Type, "Win")
	Goto, EditWindow
If Action contains %Action1%,%Action2%,%Action3%,%Action4%,%Action5%,%Action6%
	Goto, EditMouse
If InStr(Action, "[Text]")
	Goto, EditText
Gui, 15:+owner1 -MinimizeBox +HwndCmdWin
Gui, 1:+Disabled
Gui, 15:Add, GroupBox, vSGroup Section xm W280 H130 Disabled
Gui, 15:Add, Checkbox, -Wrap Section ys+15 xs+10 W260 vCSend gCSend Hidden R1, %c_Lang016%:
Gui, 15:Add, Edit, vDefCt W230 Disabled Hidden
Gui, 15:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl Disabled Hidden, ...
Gui, 15:Add, DDL, Section xs W65 vIdent Disabled Hidden, Title||Class|Process|ID|PID
Gui, 15:Add, Text, -Wrap yp+5 x+5 W190 H20 vWinParsTip Disabled Hidden, %wcmd_All%
Gui, 15:Add, Edit, xs+2 W230 vTitle Disabled Hidden, A
Gui, 15:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin Disabled Hidden, ...
Gui, 15:Add, Checkbox, -Wrap Section ym+15 xs W260 vMP gMP Hidden R1, %c_Lang051%:
Gui, 15:Add, Edit, vMsgPt W260 r4 Multi Disabled Hidden
Gui, 15:Add, Text, vMsgTxt W260 y+5 xs r2 Hidden, %c_Lang025%
If Type in %cType5%,%cType6%
{
	Gui, 15:Add, Text, y+5 W210, %c_Lang147%:
	Gui, 15:Add, Radio, -Wrap Checked W80 vNoI R1 Disabled, %c_Lang148%
	Gui, 15:Add, Radio, -Wrap x+5 W80 vErr R1 Disabled, %c_Lang149%
	Gui, 15:Add, Radio, -Wrap  x+5 W80 vQue R1 Disabled, %c_Lang150%
	Gui, 15:Add, Radio, -Wrap xs W80 vExc R1 Disabled, %c_Lang151%
	Gui, 15:Add, Radio, -Wrap x+5 W80 vInf R1 Disabled, %c_Lang152%
	Gui, 15:Add, Checkbox, -Wrap W125 xs vAot R1 Disabled, %c_Lang153%
	Gui, 15:Add, Checkbox, -Wrap W125 yp xp+130 vCancelB R1 Disabled, %c_Lang021%
	GuiControl, 15:Move, SGroup, H205
}
Gui, 15:Add, Text, Section ys xs vKWT Hidden, %c_Lang052%
Gui, 15:Add, Hotkey, vWaitKeys gWaitKeys W260 Hidden
Gui, 15:Add, Text, vTimoutT Hidden, %c_Lang053%:
Gui, 15:Add, Edit, yp-2 xs+90 W170 vTimeoutC Hidden
Gui, 15:Add, UpDown, vTimeout 0x80 Range0-999999999 Hidden, 0
Gui, 15:Add, Text, xs+90 vWTT Hidden, %c_Lang054%
Gui, 15:Add, Text, Section ys xs vGoLabT Hidden, %c_Lang078%:
Gui, 15:Add, ComboBox, W260 vGoLabel Hidden
Gui, 15:Add, Radio, vGoto Hidden, Goto
Gui, 15:Add, Radio, yp x+25 vGosub Hidden, Gosub
Gui, 15:Add, Text, Section ys xs vLabelT Hidden, %c_Lang080%:
Gui, 15:Add, Edit, W260 R1 vNewLabel Hidden, %Details%
If Type in %cType35%,%cType36%,%cType37%
{
	Proj_Labels := ""
	Loop, %TabCount%
	{
		Gui, chMacro:ListView, InputList%A_Index%
		Loop, % ListCount%A_Index%
		{
			LV_GetText(Row_Type, A_Index, 6)
			If (Row_Type = cType35)
			{
				LV_GetText(Row_Label, A_Index, 3)
				Proj_Labels .= Row_Label "|"
			}
		}
	}
	Loop, %TabCount%
		Proj_Labels .= "Macro" A_Index "|"
	GuiControl, 15:, GoLabel, %Proj_Labels%
}
Else
{
	Gui, 15:Add, GroupBox, Section xm W280 H110
	Gui, 15:Add, Text, Section ys+15 xs+10, %w_Lang015%:
	Gui, 15:Add, Text,, %c_Lang017%:
	Gui, 15:Add, Edit, ys xs+90 W170 R1 ys vEdRept
	Gui, 15:Add, UpDown, vTimesX 0x80 Range1-999999999, %TimesX%
	Gui, 15:Add, Edit, W170 vDelayC
	Gui, 15:Add, UpDown, vDelayX 0x80 Range0-999999999, %DelayX%
	Gui, 15:Add, Radio, -Wrap Section yp+25 xm+10 Checked W175 vMsc R1, %c_Lang018%
	Gui, 15:Add, Radio, -Wrap W175 vSec R1, %c_Lang019%
}
Gui, 15:Add, Button, -Wrap Section Default xm W75 H23 gEditOK, %c_Lang020%
Gui, 15:Add, Button, -Wrap ys W75 H23 gEditCancel, %c_Lang021%
Gui, 15:Add, Button, -Wrap ys W75 H23 gEditApply, %c_Lang131%
If InStr(DelayX, "%")
	GuiControl, 15:, DelayC, %DelayX%
If InStr(TimesX, "%")
	GuiControl, 15:, EdRept, %TimesX%
If Type in %cType1%,%cType2%,%cType3%
,%cType4%,%cType8%,%cType9%,%cType13%
{
	GuiControl, 15:Show, CSend
	GuiControl, 15:Show, DefCt
	GuiControl, 15:Show, GetCtrl
	GuiControl, 15:Show, Ident
	GuiControl, 15:Show, WinParsTip
	GuiControl, 15:Show, Title
	GuiControl, 15:Show, GetWin
	If Target <> ""
		GuiControl, 15:, DefCt, %Target%
	If Action contains %Action2%,%Action3%,%Action4%
		GuiControl, 15:Disable, CSend
	If InStr(Type, "Control")
	{
		GuiControl, 15:, CSend, 1
		GuiControl, 15:Enable, DefCt
		GuiControl, 15:Enable, GetCtrl
		GuiControl, 15:Enable, Ident
		GuiControl, 15:, Title, %Window%
		GuiControl, 15:Enable, Title
		GuiControl, 15:Enable, GetWin
	}
}
Else If Type in %cType35%,%cType36%,%cType37%
{
	If Type in %cType36%,%cType37%
	{
		If InStr(Proj_Labels, Details "|")
			GuiControl, 15:ChooseString, GoLabel, %Details%
		Else
			GuiControl, 15:, GoLabel, %Details%||
		GuiControl, 15:Show, GoLabT
		GuiControl, 15:Show, GoLabel
		GuiControl, 15:Show, Goto
		GuiControl, 15:Show, GoSub
		GuiControl, 15:, %Type%, 1
	}
	Else
	{
		GuiControl, 15:Show, LabelT
		GuiControl, 15:Show, NewLabel
	}
}
Else
{
	If (Type = cType5)
	{
		GuiControl, 15:Show, MP
		GuiControl, 15:Show, MsgPt
		GuiControl, 15:Show, MsgTxt
	}
	If (Type = cType6)
	{
		StringReplace, Details, Details, ``n, `n, All
		StringReplace, Details, Details, ```,, `,, All
		GuiControl, 15:Show, MP
		GuiControl, 15:Show, MsgPt
		GuiControl, 15:Show, MsgTxt
		GuiControl, 15:, MP, 1
		GuiControl, 15:, MsgPt, %Details%
		Gui, 15:Default
		GoSub, MP
		GuiControl, 15:, DelayX, 0
		MsgNum := Target
		If (MsgNum > 64)
		{
			GuiControl, 15:, Aot, 1
			MsgNum := MsgNum - 262144
		}
		If (Mod(MsgNum, 2))
		{
			GuiControl, 15:, CancelB, 1
			MsgNum := MsgNum - 1
		}
		If MsgNum = 16
			GuiControl, 15:, Err, 1
		If MsgNum = 32
			GuiControl, 15:, Que, 1
		If MsgNum = 48
			GuiControl, 15:, Exc, 1
		If MsgNum = 64
			GuiControl, 15:, Inf, 1
	}
	Else If (Type = cType20)
	{
		GuiControl, 15:Show, WaitKeys
		GuiControl, 15:Show, TimoutT
		GuiControl, 15:Show, TimeoutC
		GuiControl, 15:Show, Timeout
		GuiControl, 15:Show, KWT
		GuiControl, 15:Show, WTT
		GuiControl, 15:Disable, DelayC
		; GuiControl, 15:Disable, EdRept
		GuiControl, 15:Disable, DelayX
		GuiControl, 15:Disable, Msc
		GuiControl, 15:Disable, Sec
		GuiControl, 15:, WaitKeys, %Details%
		GuiControl, 15:, Timeout, %DelayX%
		GuiControl, 15:, TimeoutC, %DelayX%
		GuiControl, 15:, DelayX, 0
	}
}
If Type in %cType36%,%cType37%
	GuiControl, 15:Show, MsgTxt
Gui, 15:Show,, %w_Lang019%: %Type%
If Window = 
	Window = A
Input
Tooltip
return

CSend:
Gui, Submit, NoHide
GuiControl, Enable%CSend%, DefCt
GuiControl, Enable%CSend%, GetCtrl
GuiControl, Enable%CSend%, SetWin
GuiControl, Enable%CSend%, MRel
GuiControl,, MRel, %CSend%
GuiControl, Enable%CSend%, IniX
GuiControl, Enable%CSend%, IniY
GuiControl, Enable%CSend%, MouseGetI
GuiControl, Enable%CSend%, Ident
GuiControl, Enable%CSend%, Title
GuiControl, Enable%CSend%, GetWin
GuiControl, Disable%CSend%, MEditRept
GuiControl, Disable%CSend%, MEditDelay
return

MEditRept:
Gui, Submit, NoHide
GuiControl, Disable%MEditRept%, MEditDelay
GuiControl, Disable%MEditRept%, CSend
GuiControl, Enable%MEditRept%, EdRept
return

MEditDelay:
Gui, Submit, NoHide
GuiControl, Disable%MEditDelay%, MEditRept
GuiControl, Disable%MEditDelay%, CSend
GuiControl, Enable%MEditDelay%, DelayC
GuiControl, Enable%MEditDelay%, Msc
GuiControl, Enable%MEditDelay%, Sec
return

EditApply:
EditOK:
Gui, 15:+OwnDialogs
Gui, 15:Submit, NoHide
DelayX := InStr(DelayC, "%") ? DelayC : DelayX
If Sec = 1
	DelayX *= 1000
TimesX := InStr(EdRept, "%") ? EdRept : TimesX
If TimesX = 0
	TimesX := 1
Window := Title
If CSend = 1
{
	If DefCt = 
	{
		MsgBox, 52, %d_Lang011%, %d_Lang012%
		IfMsgBox, No
			return
	}
	Target := DefCt
	If (Type = cType1)
		Type := cType2
	If (Type = cType3)
		Type := cType4
	If (Type = cType8)
		Type := cType9
}
Else
{
	Target := "", Window := ""
	If (Type = cType2)
		Type := cType1
	If (Type = cType4)
		Type := cType3
	If (Type = cType9)
		Type := cType8
}
If ((Type = cType5) || (Type = cType6))
{
	If MP = 1
	{
		StringReplace, MsgPT, MsgPT, `n, ``n, All
		StringReplace, MsgPT, MsgPT, `,, ```,, All
		Type := cType6, Details := MsgPT, DelayX := 0
		If NoI = 1
			Target := 0
		If Err = 1
			Target := 16
		If Que = 1
			Target := 32
		If Exc = 1
			Target := 48
		If Inf = 1
			Target := 64
		If Aot = 1
			Target += 262144
		If CancelB = 1
			Target += 1
	}
	Else
		Type := cType5, Details := ""
}
If (Type = cType20)
{
	If (WaitKeys = "")
		return
	tKey := WaitKeys, Details := tKey, DelayX := InStr(TimeoutC, "%") ? TimeoutC : Timeout
}
Else If ((Type = cType36) || (Type = cType37))
	Details := GoLabel, Type := (Goto = 1) ? "Goto" : "Gosub"
Else If (Type = cType35)
	Details := NewLabel
If (A_ThisLabel <> "EditApply")
{
	Gui, 1:-Disabled
	Gui, 15:Destroy
}
Gui, chMacro:Default
LV_Modify(RowNumber, "Col3", Details, TimesX, DelayX, Type, Target, Window)
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "EditApply")
{
	LV_GetTexts(RowNumber, Action, Details, TimesX, DelayX, Type, Target, Window, Comment)
	Gui, 15:Default
}
Else
	GuiControl, Focus, InputList%A_List%
return

EditCancel:
15GuiClose:
15GuiEscape:
Gui, 1:-Disabled
Gui, 15:Destroy
return

MultiEdit:
Gui, 6:+owner1 -MinimizeBox +hwndCmdWin
Gui, 1:+Disabled
Gui, 6:Add, GroupBox, vSGroup Section xm W280 H120
Gui, 6:Add, Checkbox, -Wrap Section ys+15 xs+10 W250 vCSend gCSend R1, %c_Lang016%:
Gui, 6:Add, Edit, vDefCt W230 Disabled
Gui, 6:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl Disabled, ...
Gui, 6:Add, DDL, Section xs W65 vIdent Disabled, Title||Class|Process|ID|PID
Gui, 6:Add, Text, -Wrap yp+5 x+5 W190 H20 vWinParsTip Disabled, %wcmd_All%
Gui, 6:Add, Edit, xs+2 W230 vTitle Disabled, A
Gui, 6:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin Disabled, ...
Gui, 6:Add, GroupBox, Section xm W280 H110
Gui, 6:Add, Checkbox, -Wrap Section ys+15 xs+10 vMEditRept gMEditRept R1, %w_Lang015%:
Gui, 6:Add, Checkbox, -Wrap y+15 vMEditDelay gMEditDelay R1, %c_Lang017%:
Gui, 6:Add, Edit, Disabled W170 R1 ys xs+90 vEdRept
Gui, 6:Add, UpDown, vTimesX 0x80 Range1-999999999, 1
Gui, 6:Add, Edit, Disabled W170 vDelayC
Gui, 6:Add, UpDown, vDelayX 0x80 Range0-999999999, 0
Gui, 6:Add, Radio, -Wrap Section Checked Disabled W175 vMsc R1, %c_Lang018%
Gui, 6:Add, Radio, -Wrap Disabled W175 vSec R1, %c_Lang019%
Gui, 6:Add, Button, -Wrap Section Default xm W75 H23 gMultiOK, %c_Lang020%
Gui, 6:Add, Button, -Wrap ys W75 H23 gMultiCancel, %c_Lang021%
Gui, 6:Add, Button, -Wrap ys W75 H23 gMultiApply, %c_Lang131%
Gui, 6:Show,, %w_Lang019%
Window := "A"
Input
Tooltip
return

MultiApply:
MultiOK:
Gui, 6:+OwnDialogs
Gui, 6:Submit, NoHide
DelayX := InStr(DelayC, "%") ? DelayC : DelayX, TimesX := InStr(EdRept, "%") ? EdRept : TimesX
If MEditRept = 1
{
	TimesTemp := TimesM, TimesM := TimesX
	Gui, chMacro:Default
	GoSub, ApplyTEd
	TimesM := TimesTemp
	If (A_ThisLabel <> "MultiApply")
		Goto, MultiCancel
	Else
		return
}
Else If MEditDelay = 1
{
	DelayTemp := DelayG, DelayG := DelayX
	Gui, chMacro:Default
	GoSub, ApplyIEd
	DelayG := DelayTemp
	If (A_ThisLabel <> "MultiApply")
		Goto, MultiCancel
	Else
		return
}
If CSend = 1
{
	If DefCt = 
	{
		MsgBox, 52, %d_Lang011%, %d_Lang012%
		IfMsgBox, No
			return
	}
	Target := DefCt, Window := Title
}
If CSend = 0
	Target := "", Window := ""
If (A_ThisLabel <> "MultiApply")
{
	Gui, 1:-Disabled
	Gui, 6:Destroy
}
Gui, chMacro:Default
If RowSelection = 0
{
	Loop
	{
		RowNumber := A_Index
		If (RowNumber > ListCount%A_List%)
			break
		LV_GetText(Action, RowNumber, 2)
		If Action contains %Action2%,%Action3%,%Action4%
			continue
		LV_GetText(Type, RowNumber, 6)
		If ((Type = cType1) || (Type = cType2) || (Type = cType3)
		|| (Type = cType4) || (Type = cType8) || (Type = cType9)
		|| (Type = cType10) || (Type = cType22) || (Type = cType23)
		|| (Type = cType24) || (Type = cType25) || (Type = cType26))
		{
			If CSend = 1
			{
				If (Type = cType1)
					Type := cType2
				Else If (Type = cType3)
					Type := cType4
				Else If (Type = cType8)
					Type := cType9
				LV_Modify(RowNumber, "Col6", Type, Target, Window)
			}
			If CSend = 0
			{
				If (Type = cType2)
					Type := cType1
				Else If (Type = cType4)
					Type := cType3
				Else If (Type = cType9)
					Type := cType8
				LV_Modify(RowNumber, "Col6", Type, Target, Window)
			}
		}
		Else If InStr(Type, "Win")
			LV_Modify(RowNumber, "Col8", Window)
	}
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_GetText(Action, RowNumber, 2)
		If Action contains %Action2%,%Action3%,%Action4%
			continue
		LV_GetText(Type, RowNumber, 6)
		If ((Type = cType1) || (Type = cType2) || (Type = cType3)
		|| (Type = cType4) || (Type = cType8) || (Type = cType9)
		|| (Type = cType10) || (Type = cType22) || (Type = cType23)
		|| (Type = cType24) || (Type = cType25) || (Type = cType26))
		{
			If CSend = 1
			{
				If (Type = cType1)
					Type := cType2
				Else If (Type = cType3)
					Type := cType4
				Else If (Type = cType8)
					Type := cType9
				LV_Modify(RowNumber, "Col6", Type, Target, Window)
			}
			Else If CSend = 0
			{
				If (Type = cType2)
					Type := cType1
				Else If (Type = cType4)
					Type := cType3
				Else If (Type = cType9)
					Type := cType8
				LV_Modify(RowNumber, "Col6", Type, Target, Window)
			}
		}
		Else If InStr(Type, "Win")
			LV_Modify(RowNumber, "Col8", Window)
	}
}
If (A_ThisLabel = "MultiApply")
	Gui, 6:Default
Else
	GuiControl, Focus, InputList%A_List%
HistCheck(A_List)
return

MultiCancel:
6GuiClose:
6GuiEscape:
Gui, 1:-Disabled
Gui, 6:Destroy
return

SetJoyButton:
TB_Edit(TbSettings, "SetJoyButton", JoyHK := !JoyHK)
If (JoyHK = 1)
{
	GoSub, SetJoyHK
	If (JoyKey = "")
		GuiControl, 1:, JoyKey, |%t_Lang097%
	GuiControl, 1:Focus, JoyKey
}
Else
	GoSub, SetNoJoy
return

CaptureJoyB:
GuiControl, 1:, JoyKey, |%A_ThisHotkey%||
GoSub, SaveData
return

SetJoyHK:
Gui, chMacro:Submit, NoHide
GuiControl, 1:Hide, AutoKey
GuiControl, 1:Disable, AutoKey
If RegExMatch(o_AutoKey[A_List], "i)Joy\d+$")
	GuiControl, 1:, JoyKey, % "|" o_AutoKey[A_List] "||"
GuiControl, 1:Show, JoyKey
aBand := RbMain.IDToIndex(4), RbMain.GetBand(aBand,,, bSize)
,	RbMain.ModifyBand(aBand, "Child", hJoyKey), RbMain.SetBandWidth(aBand, bSize)
,	ActivateHotkeys("", "", "", "", "", 1), TB_Edit(TbSettings, "WinKey", 0, 0)
return

SetNoJoy:
Gui, chMacro:Submit, NoHide
GuiControl, 1:Enable, AutoKey
GuiControl, 1:Show, AutoKey
GuiControl, 1:Hide, JoyKey
GuiControl, 1:Enable, WinKey
ActivateHotkeys(,,,,, 0), TB_Edit(TbSettings, "WinKey", 0, 1)
,	aBand := RbMain.IDToIndex(4)
,	RbMain.GetBand(aBand,,, bSize,,,, cChild)
If (cChild <> hAutoKey)
	RbMain.ModifyBand(aBand, "Child", hAutoKey), RbMain.SetBandWidth(aBand, bSize)
return

SetWin:
Gui, 16:+owner1 +ToolWindow +HwndCmdWin
Gui, chMacro:Default
Gui, 1:+Disabled
Gui, 16:Add, Text, ym+5 cBlue, #IfWin
Gui, 16:Add, DDL, yp-3 xp+35 W80 vIfDirectContext, None||Active|NotActive|Exist|NotExist
Gui, 16:Add, DDL, yp x+130 W65 vIdent, Title||Class|Process|ID|PID
Gui, 16:Add, Edit, Section xm W280 vTitle R1 -Multi, %IfDirectWindow%
Gui, 16:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin, ...
Gui, 16:Add, Button, -Wrap Section Default yp+30 xm W75 H23 gSWinOK, %c_Lang020%
Gui, 16:Add, Button, -Wrap ys W75 H23 gSWinCancel, %c_Lang021%
GuiControl, 16:ChooseString, IfDirectContext, %IfDirectContext%
Gui, 16:Show,, %t_Lang009%
Tooltip
return

SWinOK:
Gui, 16:Submit, NoHide
IfDirectWindow := Title, TB_Edit(TbSettings, "SetWin", (IfDirectContext = "None") ? 0 : 1)
Gui, 1:-Disabled
Gui, 16:Destroy
Gui, chMacro:Default
GuiControl, 1:, ContextTip, #IfWin: %IfDirectContext%
return

SWinCancel:
16GuiClose:
16GuiEscape:
Gui, 1:-Disabled
Gui, 16:Destroy
return

EditComm:
Gui, chMacro:Default
Gui, chMacro:Listview, InputList%A_List%
RowSelection := LV_GetCount("Selected")
Gui, 17:+owner1 -MinimizeBox
Gui, chMacro:Default
Gui, 1:+Disabled
Gui, 17:Add, GroupBox, Section xm W230 H110, %t_Lang064%:
Gui, 17:Add, Edit, ys+25 xs+10 vComm W210 r5
Gui, 17:Add, Button, -Wrap Section Default xm W75 H23 gCommOK, %c_Lang020%
Gui, 17:Add, Button, -Wrap ys W75 H23 gCommCancel, %c_Lang021%
If RowSelection = 1
{
	RowNumber := LV_GetNext()
	LV_GetText(Comment, RowNumber, 9)
	StringReplace, Comment, Comment, `n, %A_Space%, All
	GuiControl, 17:, Comm, %Comment%
}
Gui, 17:Show,, %t_Lang065%
Tooltip
return

CommOK:
Gui, 17:Submit, NoHide
StringReplace, Comm, Comm, `n, %A_Space%, All
Comment := Comm
Gui, 1:-Disabled
Gui, 17:Destroy
Gui, chMacro:Default
If RowSelection = 1
	LV_Modify(RowNumber, "Col9", Comment)
Else If RowSelection = 0
{
	RowNumber = 0
	Loop
	{
		RowNumber := A_Index
		If (RowNumber > ListCount%A_List%)
			break
		LV_Modify(RowNumber, "Col9", Comment)
	}
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Modify(RowNumber, "Col9", Comment)
	}
}
GuiControl, Focus, InputList%A_List%
return

CommCancel:
17GuiClose:
17GuiEscape:
Gui, 1:-Disabled
Gui, 17:Destroy
return

EditColor:
Gui, 1:Submit, NoHide
Gui, 19:Submit, NoHide
rColor := ""
If (A_GuiControl = "SearchImg")
	rColor := ImgFile, OwnerID := CmdWin
Else If InStr(A_GuiControl, "LVColor")
	rColor := %A_GuiControl%, OwnerID := CmdWin
Else
{
	Gui, chMacro:Default
	Gui, chMacro:Listview, InputList%A_List%
	RowSelection := LV_GetCount("Selected"), OwnerID := PMCWinID
	If RowSelection = 1
	{
		RowNumber := LV_GetNext()
		LV_GetText(rColor, RowNumber, 10)
	}
}
If Dlg_Color(rColor, OwnerID, CustomColors)
{
	If (A_GuiControl = "SearchImg")
	{
		GuiControl,, ImgFile, %rColor%
		GuiControl, +Background%rColor%, ColorPrev
	}
	Else If InStr(A_GuiControl, "LVColor")
	{
		%A_GuiControl% := rColor
		Gui, 4:Font, c%rColor%
		GuiControl, 4:Font, %A_GuiControl%
	}
	Else
		GoSub, PaintRows
}
return

PaintRows:
If (rColor = "0xffffff")
	rColor := ""
If RowSelection = 1
	LV_Modify(RowNumber, "Col10", rColor)
Else If RowSelection = 0
{
	RowNumber = 0
	Loop
	{
		RowNumber := A_Index
		If (RowNumber > ListCount%A_List%)
			break
		LV_Modify(RowNumber, "Col10", rColor)
	}
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Modify(RowNumber, "Col10", rColor)
	}
}
GoSub, RowCheck
return

FilterSelect:
FindReplace:
Input
Gui 18:+LastFoundExist
IfWinExist
	GoSub, FindClose
Gui, 18:+owner1 +ToolWindow
Gui, chMacro:Default
Gui, 18:Add, Tab2, Section W400 H400 vFindTabC, %t_Lang140%|%t_Lang141%
Gui, 18:Add, Text, ys+40 xs+10 W100, %t_Lang066%:
Gui, 18:Add, DDL, yp-5 xp+90 W120 vSearchCol AltSubmit, %w_Lang030%||%w_Lang031%|%w_Lang032%|%w_Lang033%|%w_Lang034%|%w_Lang035%|%w_Lang036%|%w_Lang037%|%w_Lang038%|%w_Lang039%
Gui, 18:Add, GroupBox, ys+60 xs+10 W380 H155, %t_Lang068%:
Gui, 18:Add, Edit, yp+20 xs+20 vFind W360 r3
Gui, 18:Add, Button, -Wrap Default y+5 xs+305 W75 H23 gFindOK, %t_Lang068%
Gui, 18:Add, Checkbox, -Wrap yp xs+20 W285 vWholC R1, %t_Lang092%
Gui, 18:Add, Checkbox, -Wrap W285 vMCase R1, %t_Lang069%
Gui, 18:Add, Checkbox, -Wrap W285 vRegExSearch gRegExSearch R1, %t_Lang077%
Gui, 18:Add, Text, y+10 xs+20 W280 vFound
Gui, 18:Add, GroupBox, Section y+20 xs+10 W380 H155, %t_Lang070%:
Gui, 18:Add, Edit, ys+25 xs+10 vReplace W360 r3
Gui, 18:Add, Button, -Wrap y+5 xs+295 W75 H23 gReplaceOK, %t_Lang070%
Gui, 18:Add, Radio, -Wrap Checked yp xs+10 W285 vRepSelRows R1, %t_Lang073%
Gui, 18:Add, Radio, -Wrap W285 vRepAllRows R1, %t_Lang074%
Gui, 18:Add, Radio, -Wrap W285 vRepAllMacros R1, %t_Lang075%
Gui, 18:Add, Text, y+10 xs+10 W280 vReplaced
Gui, 18:Tab, 2
Gui, 18:Add, Groupbox, Section ym+60 xm+10 W380 H321
Gui, 18:Add, Text, ys+20 xs+10 W100, %w_Lang031%:
Gui, 18:Add, Edit, yp x+0 W260 vFilterA, %FilterA%
Gui, 18:Add, Text, y+5 xs+10 W100, %w_Lang032%:
Gui, 18:Add, Edit, yp x+0 W260 vFilterB, %FilterB%
Gui, 18:Add, Text, y+5 xs+10 W100, %w_Lang033%:
Gui, 18:Add, Edit, yp x+0 W260 vFilterC, %FilterC%
Gui, 18:Add, Text, y+5 xs+10 W100, %w_Lang034%:
Gui, 18:Add, Edit, yp x+0 W260 vFilterD, %FilterD%
Gui, 18:Add, Text, y+5 xs+10 W100, %w_Lang035%:
Gui, 18:Add, Edit, yp x+0 W260 vFilterE, %FilterE%
Gui, 18:Add, Text, y+5 xs+10 W100, %w_Lang036%:
Gui, 18:Add, Edit, yp x+0 W260 vFilterF, %FilterF%
Gui, 18:Add, Text, y+5 xs+10 W100, %w_Lang037%:
Gui, 18:Add, Edit, yp x+0 W260 vFilterG, %FilterG%
Gui, 18:Add, Text, y+5 xs+10 W100, %w_Lang038%:
Gui, 18:Add, Edit, yp x+0 W260 vFilterH, %FilterH%
Gui, 18:Add, Text, y+5 xs+10 W100, %w_Lang039%:
Gui, 18:Add, Edit, yp x+0 W260 vFilterI, %FilterI%
Gui, 18:Add, Checkbox, -Wrap y+25 xs+10 W185 vFCase R1, %t_Lang069%
Gui, 18:Add, Button, -Wrap yp-5 xs+295 W75 H23 gFilterOK, %t_Lang068%
Gui, 18:Add, Text, y+5 xs+10 W280 vFFound
Gui, 18:Tab
Gui, 18:Add, Button, -Wrap Section xm W75 H23 gFindClose, %c_Lang022%
If (A_ThisLabel = "FilterSelect")
	GuiControl, 18:Choose, FindTabC, 2
Gui, 18:Show,, %t_Lang067%
GuiControl, 18:Focus, Find
Tooltip
return

FindOK:
Gui, 18:Submit, NoHide
If Find = 
	return
Gui, chMacro:Default
StringReplace, Find, Find, `n, ``n, All
LV_Modify(0, "-Select")
t_Col := (SearchCol < 4) ? SearchCol + 2 : SearchCol + 3
Loop
{
	RowNumber := A_Index
	If (RowNumber > ListCount%A_List%)
		break
	LV_GetText(CellText, RowNumber, t_Col)
	If (RegExSearch = 1)
	{
		If RegExMatch(CellText, Find)
			LV_Modify(RowNumber, "Select")
	}
	Else If (WholC = 1)
	{
		 If (MCase = 1)
		 {
			If (CellText == Find)
				LV_Modify(RowNumber, "Select")
		}
		 Else If (CellText = Find)
			LV_Modify(RowNumber, "Select")
	}
	Else If InStr(CellText, Find, MCase)
		LV_Modify(RowNumber, "Select")
}
RowSelection := LV_GetCount("Selected")
GuiControl, 18:, Found, %t_Lang071%: %RowSelection%
If (RowSelection)
	LV_Modify(LV_GetNext(), "Vis")
; GuiControl, Focus, InputList%A_List%
return

ReplaceOK:
Gui, 18:Submit, NoHide
If Find = 
	return
Gui, chMacro:Default
StringReplace, Find, Find, `n, ``n, All
t_Col := (SearchCol < 4) ? SearchCol + 2 : SearchCol + 3
If RepAllRows = 1
{
	Loop, % ListCount%A_List%
	{
		LV_GetText(CellText, A_Index, t_Col)
		If (RegExSearch = 1)
		{
			If RegExMatch(CellText, Find)
			{
				CellText := RegExReplace(CellText, Find, Replace)
				LV_Modify(A_Index, "Col" t_Col, CellText)
				Replaces += 1
			}
		}
		Else If (WholC = 1)
		{
			If (MCase = 1)
			{
				If (CellText == Find)
				{
					StringReplace, CellText, CellText, %Find%, %Replace%, All
					LV_Modify(A_Index, "Col" t_Col, CellText)
					Replaces += 1
				}
			}
			Else If (CellText = Find)
			{
				StringReplace, CellText, CellText, %Find%, %Replace%, All
				LV_Modify(A_Index, "Col" t_Col, CellText)
				Replaces += 1
			}
		}
		Else If InStr(CellText, Find, MCase)
		{
			StringReplace, CellText, CellText, %Find%, %Replace%, All
			LV_Modify(A_Index, "Col" t_Col, CellText)
			Replaces += 1
		}
	}
	If Replaces > 0
		HistCheck(A_List)
}
Else If RepAllMacros = 1
{
	Tmp_List := A_List
	Loop, %TabCount%
	{
		Gui, chMacro:Listview, InputList%A_Index%
		Loop,  % ListCount%A_Index%
		{
			LV_GetText(CellText, A_Index, t_Col)
			If (RegExSearch = 1)
			{
				If RegExMatch(CellText, Find)
				{
					CellText := RegExReplace(CellText, Find, Replace)
					LV_Modify(A_Index, "Col" t_Col, CellText)
					Replaces += 1
				}
			}
			Else If (WholC = 1)
			{
				If (MCase = 1)
				{
					If (CellText == Find)
					{
						StringReplace, CellText, CellText, %Find%, %Replace%, All
						LV_Modify(A_Index, "Col" t_Col, CellText)
						Replaces += 1
					}
				}
				Else If (CellText = Find)
				{
					StringReplace, CellText, CellText, %Find%, %Replace%, All
					LV_Modify(A_Index, "Col" t_Col, CellText)
					Replaces += 1
				}
			}
			Else If InStr(CellText, Find, MCase)
			{
				StringReplace, CellText, CellText, %Find%, %Replace%, All
				LV_Modify(A_Index, "Col" t_Col, CellText)
				Replaces += 1
			}
		}
		If Replaces > 0
			HistCheck(A_Index)
	}
	Gui, chMacro:Listview, InputList%A_List%
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If !RowNumber
			break
		LV_GetText(CellText, RowNumber, t_Col)
		If (RegExSearch = 1)
		{
			If RegExMatch(CellText, Find)
			{
				CellText := RegExReplace(CellText, Find, Replace)
				LV_Modify(RowNumber, "Col" t_Col, CellText)
				Replaces += 1
			}
		}
		Else If (WholC = 1)
		{
			If (MCase = 1)
			{
				If (CellText == Find)
				{
					StringReplace, CellText, CellText, %Find%, %Replace%, All
					LV_Modify(RowNumber, "Col" t_Col, CellText)
					Replaces += 1
				}
			}
			Else If (CellText = Find)
			{
				StringReplace, CellText, CellText, %Find%, %Replace%, All
				LV_Modify(RowNumber, "Col" t_Col, CellText)
				Replaces += 1
			}
		}
		Else If InStr(CellText, Find, MCase)
		{
			StringReplace, CellText, CellText, %Find%, %Replace%, All
			LV_Modify(RowNumber, "Col" t_Col, CellText)
			Replaces += 1
		}
	}
	If Replaces > 0
		HistCheck(A_List)
}
GuiControl, 18:, Replaced, %t_Lang072%: %Replaces%
; GuiControl, Focus, InputList%A_List%
return

RegExSearch:
Gui, 18:Submit, NoHide
GuiControl, 18:Disable%RegExSearch%, WholC
GuiControl, 18:Disable%RegExSearch%, MCase
return

FindClose:
18GuiClose:
18GuiEscape:
Gui, 18:Destroy
return

FilterOK:
Gui, 18:Submit, NoHide
Gui, chMacro:Default
FFound := SelectByFilter(FilterA, FilterB, FilterC, FilterD, FilterE, FilterF, FilterG, FilterH, FilterI, FCase)
GuiControl, 18:, FFound, %t_Lang071%: %FFound%
return

MainOnTop:
Gui, % (MainOnTop := !MainOnTop) ? "1:+AlwaysOnTop" : "1:-AlwaysOnTop"
If (MainOnTop)
	Menu, ViewMenu, Check, %v_lang001%
Else
	Menu, ViewMenu, UnCheck, %v_lang001%
return

ShowLoopIfMark:
ShowLoopIfMark := !ShowLoopIfMark
If (ShowLoopIfMark)
	Menu, ViewMenu, Check, %v_lang002%
Else
	Menu, ViewMenu, UnCheck, %v_lang002%
GoSub, RowCheck
return

ShowActIdent:
ShowActIdent := !ShowActIdent
If (ShowActIdent)
	Menu, ViewMenu, Check, %v_lang003%
Else
	Menu, ViewMenu, UnCheck, %v_lang003%
GoSub, RowCheck
return

ShowHideBand:
bID := RBIndexTB[A_ThisMenuItemPos]
ShowHideBandOn:
tBand := RbMain.IDToIndex(bID), ShowBand%bID% := !ShowBand%bID%
,	RbMain.ShowBand(tBand, ShowBand%bID%)
,	RbMain.ShowBand(RbMain.IDToIndex(1), ShowBand1)
If (ShowBand1)
	Menu, ToolbarsMenu, Check, %v_lang009%
Else
	Menu, ToolbarsMenu, UnCheck, %v_lang009%
If (ShowBand2)
	Menu, ToolbarsMenu, Check, %v_lang010%
Else
	Menu, ToolbarsMenu, UnCheck, %v_lang010%
If (ShowBand3)
	Menu, ToolbarsMenu, Check, %v_lang011%
Else
	Menu, ToolbarsMenu, UnCheck, %v_lang011%
If (ShowBand5)
	Menu, ToolbarsMenu, Check, %v_lang012%
Else
	Menu, ToolbarsMenu, UnCheck, %v_lang012%
If (ShowBand9)
	Menu, ToolbarsMenu, Check, %v_lang013%
Else
	Menu, ToolbarsMenu, UnCheck, %v_lang013%
return

ShowHideBandHK:
bID := RBIndexHK[A_ThisMenuItemPos]
,	tBand := RbMain.IDToIndex(bID), ShowBand%bID% := !ShowBand%bID%
,	RbMain.ShowBand(tBand, ShowBand%bID%)
If (ShowBand4)
	Menu, HotkeyMenu, Check, %v_lang015%
Else
	Menu, HotkeyMenu, UnCheck, %v_lang015%
If (ShowBand6)
	Menu, HotkeyMenu, Check, %v_lang016%
Else
	Menu, HotkeyMenu, UnCheck, %v_lang016%
If (ShowBand7)
	Menu, HotkeyMenu, Check, %v_lang017%
Else
	Menu, HotkeyMenu, UnCheck, %v_lang017%
If (ShowBand8)
	Menu, HotkeyMenu, Check, %v_lang018%
Else
	Menu, HotkeyMenu, UnCheck, %v_lang018%
return

;##### Playback: #####

f_AutoKey:
Loop, %TabCount%  
	If (o_AutoKey[A_Index] = A_ThisHotkey)
		aHK_On := [A_Index]
StopIt := 0
f_RunMacro:
If (aHK_On := Playback(aHK_On*))
	Goto, f_RunMacro
return

f_ManKey:
Loop, %TabCount%
	If (o_ManKey[A_Index] = A_ThisHotkey)
		mHK_On := A_Index
StopIt := 0
Playback(mHK_On, 0, mHK_On)
return

f_AbortKey:
Gui, chMacro:Default
StopIt := 1
Pause, Off
If Record
{
	GoSub, RecStop
	GoSub, b_Start
}
GoSub, RowCheck
Menu, Tray, Icon, %DefaultIcon%, 1
ToggleButtonIcon(OSPlay, TestRunIcon)
return

PauseKey:
Gui, 1:Submit, NoHide
return

f_PauseKey:
If !(CurrentRange) && !(Record)
	return
If ToggleIcon() && !(Record)
	ToggleButtonIcon(OSPlay, PauseIconB)
Else
	ToggleButtonIcon(OSPlay, TestRunIcon)
Pause,, 1
return

FastKeyToggle:
SlowKeyOn := 0, FastKeyOn := !FastKeyOn
If ShowStep = 1
	TrayTip, %AppName%, % (FastKeyOn) ? t_Lang036 " " SpeedUp "x" : t_Lang035 " 1x"
TB_Edit(TbOSC, "SlowKeyToggle", SlowKeyOn), TB_Edit(TbOSC, "FastKeyToggle", FastKeyOn)
return

SlowKeyToggle:
FastKeyOn := 0, SlowKeyOn := !SlowKeyOn
If ShowStep = 1
	TrayTip, %AppName%, % (SlowKeyOn) ? t_Lang037 " " SpeedDn "x" : t_Lang035 " 1x"
TB_Edit(TbOSC, "SlowKeyToggle", SlowKeyOn), TB_Edit(TbOSC, "FastKeyToggle", FastKeyOn)
return

CheckHkOn:
TB_Edit(TbSettings, "CheckHkOn", KeepHkOn := !KeepHkOn)
If (KeepHkOn = 1)
{
	GoSub, KeepHkOn
	Menu, Tray, Check, %w_Lang014%
}
Else
{
	GoSub, ResetHotkeys
	Menu, Tray, Uncheck, %w_Lang014%
	Traytip
}
return

KeepHkOn:
If (A_Gui > 2)
	return
If KeepHkOn
{
	GoSub, SaveData
	ActivateHotkeys(1, 1, 1, 1, 1)
}
return

ResetHotkeys:
ActivateHotkeys(0, 0, 0, 0, 0)
Menu, Tray, Tip, %AppName%
return

ActivateHotkeys:
If CheckDuplicates(AbortKey, o_ManKey, o_AutoKey*)
{
	ActiveKeys := "Error"
	If ShowStep = 1
		Traytip, %AppName%, %d_Lang032%,,3
	return
}
ActiveKeys := ActivateHotkeys(0, 1, 1, 1, 1)
If ((ActiveKeys > 0) && (ShowStep = 1))
	Traytip, %AppName%, % ActiveKeys " " d_Lang025 ((IfDirectContext <> "None") ? "`n[" RegExReplace(t_Lang009, ".*", "$u0") "]" : ""),,1
Menu, Tray, Tip, %AppName%`n%ActiveKeys% %d_Lang025%
return

h_Del:
Gui, chMacro:Default
Gui, chMacro:ListView, InputList%A_List%
RowNumber = 0
Loop
{
	RowNumber := LV_GetNext(RowNumber - 1)
	If !RowNumber
		break
	LV_Delete(RowNumber)
}
LV_Modify(LV_GetNext(0, "Focused"), "Select")
GoSub, RowCheck
GoSub, b_Start
return

h_NumDel:
RowNumber := 0
Loop
{
	RowNumber := LV_GetNext(RowNumber - 1)
	If !RowNumber
		break
	LV_Delete(RowNumber)
}
LV_Modify(LV_GetNext(0, "Focused"), "Select")
GoSub, RowCheck
GoSub, b_Start
return

;##### Playback Commands #####

pb_Send:
	Send, %Step%
return
pb_ControlSend:
	Win := SplitWin(Window)
	ControlSend, %Target%, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_Click:
	Click, %Step%
return
pb_ControlClick:
	Win := SplitWin(Window)
	ControlClick, %Target%, % Win[1], % Win[2], %Par1%, %Par2%, %Par3%, % Win[3], % Win[4]
return
pb_Sleep:
	If (RandomSleeps)
		SleepRandom(DelayX, RandPercent)
	Else If (SlowKeyOn)
		Sleep, (DelayX*SpeedDn)
	Else If (FastKeyOn)
		Sleep, (DelayX/SpeedUp)
	Else
		Sleep, %DelayX%
return
pb_MsgBox:
	StringReplace, Step, Step, ``n, `n, All
	StringReplace, Step, Step, ```,, `,, All
	Menu, Tray, Icon, %ResDllPath%, 78
	ChangeProgBarColor("Blue", "OSCProg", 28)
	If (Action = "MsgBox")
	{
		MsgBox, % Par1, %Par2%, %Par3%, %Par4%
		Menu, Tray, Icon, %ResDllPath%, 47
		ChangeProgBarColor("20D000", "OSCProg", 28)
	}
	Else
	{
		MsgBox, % Target, %d_Lang023%, %Step%
		Menu, Tray, Icon, %ResDllPath%, 47
		ChangeProgBarColor("20D000", "OSCProg", 28)
		IfMsgBox, OK
			return
		IfMsgBox, Cancel
		{
			StopIt := 1
			return
		}
	}
return
pb_SendRaw:
	SendRaw, %Step%
return
pb_ControlSendRaw:
	Win := SplitWin(Window)
	ControlSendRaw, %Target%, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_ControlSetText:
	Win := SplitWin(Window)
	ControlSetText, %Target%, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_Run:
	If (Par4 <> "")
		Run, %Par1%, %Par2%, %Par3%, %Par4%
	Else
		Run, %Par1%, %Par2%, %Par3%
return
pb_RunWait:
	Menu, Tray, Icon, %ResDllPath%, 78
	ChangeProgBarColor("Blue", "OSCProg", 28)
	If (Par4 <> "")
		RunWait, %Par1%, %Par2%, %Par3%, %Par4%
	Else
		RunWait, %Par1%, %Par2%, %Par3%
	Menu, Tray, Icon, %ResDllPath%, 47
	ChangeProgBarColor("20D000", "OSCProg", 28)
return
pb_RunAs:
	RunAs, %Par1%, %Par2%, %Par3%
return
pb_Process:
	Process, %Par1%, %Par2%, %Par3%
return
pb_Shutdown:
	Shutdown, %Step%
return
pb_GetKeyState:
	GetKeyState, %Par1%, %Par2%, %Par3%
return
pb_MouseGetPos:
	Loop, 4
	{
		If (Par%A_Index% = "")
			Par%A_Index% := "Null"
	}
	MouseGetPos, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
	Null := ""
return
pb_PixelGetColor:
	PixelGetColor, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_SysGet:
	SysGet, %Par1%, %Par2%, %Par3%
return
pb_SetCapsLockState:
	SetCapsLockState, %Par1%
return
pb_SetNumLockState:
	SetNumLockState, %Par1%
return
pb_SetScrollLockState:
	SetScrollLockState, %Par1%
return
pb_EnvAdd:
	EnvAdd, %Par1%, %Par2%, %Par3%
return
pb_EnvSub:
	EnvSub, %Par1%, %Par2%, %Par3%
return
pb_EnvDiv:
	EnvDiv, %Par1%, %Par2%
return
pb_EnvMult:
	EnvMult, %Par1%, %Par2%
return
pb_EnvGet:
	EnvGet, %Par1%, %Par2%
return
pb_EnvSet:
	EnvSet, %Par1%, %Par2%
return
pb_EnvUpdate:
	EnvUpdate
return
pb_FormatTime:
	FormatTime, %Par1%, %Par2%, %Par3%
return
pb_Transform:
	Transform, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_Random:
	Random, %Par1%, %Par2%, %Par3%
return
pb_FileAppend:
	FileAppend, %Par1%, %Par2%, %Par3%
return
pb_FileCopy:
	FileCopy, %Par1%, %Par2%, %Par3%
return
pb_FileCopyDir:
	FileCopyDir, %Par1%, %Par2%, %Par3%
return
pb_FileCreateDir:
	FileCreateDir, %Step%
return
pb_FileDelete:
	FileDelete, %Step%
return
pb_FileGetAttrib:
	FileGetAttrib, %Par1%, %Par2%
return
pb_FileGetSize:
	FileGetSize, %Par1%, %Par2%, %Par3%
return
pb_FileGetTime:
	FileGetTime, %Par1%, %Par2%, %Par3%
return
pb_FileGetVersion:
	FileGetVersion, %Par1%, %Par2%
return
pb_FileMove:
	FileMove, %Par1%, %Par2%, %Par3%
return
pb_FileMoveDir:
	FileMoveDir, %Par1%, %Par2%, %Par3%
return
pb_FileRead:
	FileRead, %Par1%, %Par2%
return
pb_FileReadLine:
	FileReadLine, %Par1%, %Par2%, %Par3%
return
pb_FileRecycle:
	FileRecycle, %Step%
return
pb_FileRecycleEmpty:
	FileRecycleEmpty, %Step%
return
pb_FileRemoveDir:
	FileRemoveDir, %Par1%, %Par2%
return
pb_FileSelectFile:
	FileSelectFile, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
return
pb_FileSelectFolder:
	FileSelectFolder, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_FileSetAttrib:
	FileSetAttrib, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_FileSetTime:
	FileSetTime, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
return
pb_Drive:
	Drive, %Par1%, %Par2%, %Par3%
return
pb_DriveGet:
	DriveGet, %Par1%, %Par2%, %Par3%
return
pb_DriveSpaceFree:
	DriveSpaceFree, %Par1%, %Par2%
return
pb_Sort:
	Sort, %Par1%, %Par2%
return
pb_StringGetPos:
	StringGetPos, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
return
pb_StringLeft:
	StringLeft, %Par1%, %Par2%, %Par3%
return
pb_StringRight:
	StringRight, %Par1%, %Par2%, %Par3%
return
pb_StringLen:
	StringLen, %Par1%, %Par2%
return
pb_StringLower:
	StringLower, %Par1%, %Par2%, %Par3%
return
pb_StringUpper:
	StringUpper, %Par1%, %Par2%, %Par3%
return
pb_StringMid:
	StringMid, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
return
pb_StringReplace:
	StringReplace, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
return
pb_StringSplit:
	StringSplit, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_StringTrimLeft:
	StringTrimLeft, %Par1%, %Par2%, %Par3%
return
pb_StringTrimRight:
	StringTrimRight, %Par1%, %Par2%, %Par3%
return
pb_SplitPath:
	Loop, 6
	{
		If (Par%A_Index% = "")
			Par%A_Index% := "Null"
	}
	SplitPath, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
	Null := ""
return
pb_InputBox:
	InputBox, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
return
pb_ToolTip:
	ToolTip, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_TrayTip:
	TrayTip, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_Progress:
	Progress, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
return
pb_SplashImage:
	SplashImage, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
return
pb_SplashTextOn:
	SplashTextOn, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_SplashTextOff:
	SplashTextOff
return
pb_RegRead:
	RegRead, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_RegWrite:
	RegWrite, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
return
pb_RegDelete:
	RegDelete, %Par1%, %Par2%, %Par3%
return
pb_SetRegView:
	SetRegView, %Par1%
return
pb_IniRead:
	IniRead, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
return
pb_IniWrite:
	IniWrite, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_IniDelete:
	IniDelete, %Par1%, %Par2%, %Par3%
return
pb_SoundBeep:
	SoundBeep, %Par1%, %Par2%
return
pb_SoundGet:
	SoundGet, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_SoundGetWaveVolume:
	SoundGetWaveVolume, %Par1%, %Par2%
return
pb_SoundPlay:
	SoundPlay, %Par1%, %Par2%
return
pb_SoundSet:
	SoundSet, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_SoundSetWaveVolume:
	SoundSetWaveVolume, %Par1%, %Par2%
return
pb_ClipWait:
	Menu, Tray, Icon, %ResDllPath%, 78
	ChangeProgBarColor("Blue", "OSCProg", 28)
	ClipWait, %Par1%, %Par2%
	Menu, Tray, Icon, %ResDllPath%, 47
	ChangeProgBarColor("20D000", "OSCProg", 28)
return
pb_BlockInput:
	BlockInput, %Step%
return
pb_UrlDownloadToFile:
	UrlDownloadToFile, %Par1%, %Par2%
return
pb_CoordMode:
	CoordMode, %Par1%, %Par2%
return
pb_SendLevel:
	SendLevel, %Step%
return
pb_Pause:
	ToggleIcon()
	Pause
return
pb_ExitApp:
	ExitApp
return
pb_StatusBarGetText:
	StatusBarGetText, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
return
pb_StatusBarWait:
	Menu, Tray, Icon, %ResDllPath%, 78
	ChangeProgBarColor("Blue", "OSCProg", 28)
	StatusBarWait, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
	Menu, Tray, Icon, %ResDllPath%, 47
	ChangeProgBarColor("20D000", "OSCProg", 28)
return
pb_Clipboard:
	SavedClip := ClipboardAll
	If (Step <> "")
	{
		Clipboard =
		Clipboard := Step
		Sleep, 333
	}
	If (Target <> "")
	{
		Win := SplitWin(Window)
		ControlSend, %Target%, {Control Down}{v}{Control Up}, % Win[1], % Win[2], % Win[3], % Win[4]
	}
	Else
		Send, {Control Down}{v}{Control Up}
	Clipboard := SavedClip
	SavedClip =
return
pb_SendEvent:
	SendEvent, %Step%
return
pb_Control:
	Win := SplitWin(Window)
	Control, % RegExReplace(Step, "(^\w*).*", "$1")
	, % RegExReplace(Step, "^\w*, ?(.*)", "$1")
	, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_ControlFocus:
	Win := SplitWin(Window)
	ControlFocus, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_ControlMove:
	Win := SplitWin(Window)
	ControlMove, %Target%, %Par1%, %Par2%, %Par3%, %Par4%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_PixelSearch:
	CoordMode, Pixel, %Window%
	PixelSearch, FoundX, FoundY, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%, %Par7%
	SearchResult := ErrorLevel
	GoSub, TakeAction
return
pb_ImageSearch:
	CoordMode, Pixel, %Window%
	ImageSearch, FoundX, FoundY, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
	SearchResult := ErrorLevel
	GoSub, TakeAction
return
pb_SendMessage:
	Win := SplitWin(Window)
	SendMessage, %Par1%, %Par2%, %Par3%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_PostMessage:
	Win := SplitWin(Window)
	PostMessage, %Par1%, %Par2%, %Par3%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_KeyWait:
	Menu, Tray, Icon, %ResDllPath%, 78
	ChangeProgBarColor("Blue", "OSCProg", 28)
	If (Action = "KeyWait")
		KeyWait, %Par1%, %Par2%
	Else
		WaitFor.Key(Step, DelayX / 1000)
	Menu, Tray, Icon, %ResDllPath%, 47
	ChangeProgBarColor("20D000", "OSCProg", 28)
return
pb_Input:
	Input, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_ControlEditPaste:
	Win := SplitWin(Window)
	Control, EditPaste, %Step%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_ControlGetText:
	Win := SplitWin(Window)
	ControlGetText, %Step%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_ControlGetFocus:
	Win := SplitWin(Window)
	ControlGetFocus, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_ControlGet:
	Win := SplitWin(Window)
	ControlGet, %Par1%, %Par2%, %Par3%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_ControlGetPos:
	Win := SplitWin(Window)
	ControlGetPos, %Step%X, %Step%Y, %Step%W, %Step%H, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinActivate:
	Win := SplitWin(Window)
	WinActivate, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinActivateBottom:
	Win := SplitWin(Window)
	WinActivateBottom, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinClose:
	Win := SplitWin(Window)
	WinClose, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinHide:
	Win := SplitWin(Window)
	WinHide, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinKill:
	Win := SplitWin(Window)
	WinKill, % Win[1], % Win[2], % Win[3], % Win[4], % Win[5]
return
pb_WinMaximize:
	Win := SplitWin(Window)
	WinMaximize, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinMinimize:
	Win := SplitWin(Window)
	WinMinimize, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinMinimizeAll:
	WinMinimizeAll, %Window%
return
pb_WinMinimizeAllUndo:
	WinMinimizeAllUndo, %Window%
return
pb_WinMove:
	Win := SplitWin(Window)
	WinMove, % Win[1], % Win[2], %Par1%, %Par2%, %Par3%, %Par4%, % Win[3], % Win[4]
return
pb_WinRestore:
	Win := SplitWin(Window)
	WinRestore, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinSet:
	Win := SplitWin(Window)
	WinSet, %Par1%, %Par2%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinShow:
	Win := SplitWin(Window)
	WinShow, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinSetTitle:
	Win := SplitWin(Window)
	WinSetTitle, % Win[1], % Win[2], % Win[3], % Win[4], % Win[5]
return
pb_WinWait:
	Menu, Tray, Icon, %ResDllPath%, 78
	ChangeProgBarColor("Blue", "OSCProg", 28)
,	WaitFor.WinExist(SplitWin(Window), Step)
	Menu, Tray, Icon, %ResDllPath%, 47
	ChangeProgBarColor("20D000", "OSCProg", 28)
return
pb_WinWaitActive:
	Menu, Tray, Icon, %ResDllPath%, 78
	ChangeProgBarColor("Blue", "OSCProg", 28)
,	WaitFor.WinActive(SplitWin(Window), Step)
	Menu, Tray, Icon, %ResDllPath%, 47
	ChangeProgBarColor("20D000", "OSCProg", 28)
return
pb_WinWaitNotActive:
	Menu, Tray, Icon, %ResDllPath%, 78
	ChangeProgBarColor("Blue", "OSCProg", 28)
,	WaitFor.WinNotActive(SplitWin(Window), Step)
	Menu, Tray, Icon, %ResDllPath%, 47
	ChangeProgBarColor("20D000", "OSCProg", 28)
return
pb_WinWaitClose:
	Menu, Tray, Icon, %ResDllPath%, 78
	ChangeProgBarColor("Blue", "OSCProg", 28)
,	WaitFor.WinClose(SplitWin(Window), Step)
	Menu, Tray, Icon, %ResDllPath%, 47
	ChangeProgBarColor("20D000", "OSCProg", 28)
return
pb_WinGet:
	Win := SplitWin(Window)
	WinGet, %Par1%, %Par2%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinGetTitle:
	Win := SplitWin(Window)
	WinGetTitle, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinGetClass:
	Win := SplitWin(Window)
	WinGetClass, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinGetText:
	Win := SplitWin(Window)
	WinGetText, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinGetpos:
	Win := SplitWin(Window)
	WinGetPos, %Step%X, %Step%Y, %Step%W, %Step%H, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_GroupAdd:
	GroupAdd, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
return
pb_GroupActivate:
	GroupActivate, %Par1%, %Par2%
return
pb_GroupDeactivate:
	GroupDeactivate, %Par1%, %Par2%
return
pb_GroupClose:
	GroupClose, %Par1%, %Par2%
return

;##### Playback COM Commands #####

pb_IECOM_Set:
	StringSplit, Act, Action, :
	StringSplit, El, Target, :
	IeIntStr := IEComExp(Act2, Step, El1, El2, "", Act3, Act1)
,	IeIntStr := SubStr(IeIntStr, 4)

	Try
		o_ie.readyState
	Catch
	{
		If (ComAc)
			o_ie := IEGet()
		Else
		{
			o_ie := ComObjCreate("InternetExplorer.Application")
		,	o_ie.Visible := true
		}
	}
	If !IsObject(o_ie)
	{
		o_ie := ComObjCreate("InternetExplorer.Application")
	,	o_ie.Visible := true
	}
	
	Try
		COMInterface(IeIntStr, o_ie)
	Catch e
	{
		MsgBox, 20, %d_Lang007%, % d_Lang064 " Macro" mMacroOn ", " d_Lang065 " " mListRow
			.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" e.Extra "`n`n" d_Lang035
		IfMsgBox, No
		{
			StopIt := 1
			return
		}
	}
	
	If (Window = "LoadWait")
		Try
			IELoad(o_ie)
return

pb_IECOM_Get:
	Try
		z_Check := VarSetCapacity(%Step%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		StopIt := 1
		return
	}
	
	StringSplit, Act, Action, :
	StringSplit, El, Target, :
	IeIntStr := IEComExp(Act2, "", El1, El2, Step, Act3, Act1)
,	IeIntStr := SubStr(IeIntStr, InStr(IeIntStr, "ie.") + 3)
	
	Try
		o_ie.readyState
	Catch
	{
		If (ComAc)
			o_ie := IEGet()
		Else
		{
			o_ie := ComObjCreate("InternetExplorer.Application")
		,	o_ie.Visible := true
		}
	}
	If !IsObject(o_ie)
	{
		o_ie := ComObjCreate("InternetExplorer.Application")
	,	o_ie.Visible := true
	}
	
	Try
		COMInterface(IeIntStr, o_ie, %Step%)
	Catch e
	{
		MsgBox, 20, %d_Lang007%, % d_Lang064 " Macro" mMacroOn ", " d_Lang065 " " mListRow
			.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" e.Extra "`n`n" d_Lang035
		IfMsgBox, No
		{
			StopIt := 1
			return
		}
	}
	
	If (Window = "LoadWait")
		Try
			IELoad(o_ie)
return

pb_VBScript:
pb_JScript:
VB := "", JS := ""
StringReplace, Step, Step, `n, ``n, All
Step := "Language := " Type "`nExecuteStatement(" Step ")"

pb_COMInterface:
	StringSplit, Act, Action, :

	Try
		z_Check := VarSetCapacity(%Act2%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		StopIt := 1
		return
	}

	Loop, Parse, Step, `n, %A_Space%%A_Tab%
	{
		StringReplace, LoopField, A_LoopField, ``n, `n, All
		Try
		{
			If !IsObject(%Act1%)
				%Act1% := COMInterface(LoopField, %Act1%, %Act2%, Target)
			Else
				COMInterface(LoopField, %Act1%, %Act2%, Target)
		}
		Catch e
		{
			MsgBox, 20, %d_Lang007%, % d_Lang064 " Macro" mMacroOn ", " d_Lang065 " " mListRow
				.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" e.Extra "`n`n" d_Lang035
			IfMsgBox, No
			{
				StopIt := 1
				return
			}
		}
	}

	If (Window = "LoadWait")
		Try
			IELoad(%Act1%)
return

TakeAction:
TakeAction := DoAction(FoundX, FoundY, Act1, Act2, Window, SearchResult)
If (TakeAction = "Continue")
	TakeAction := 0
Else If (TakeAction = "Stop")
	StopIt := 1
Else If (TimesX = 1) && (TakeAction = "Break")
	BreakIt++
Else If (TakeAction = "Prompt")
{
	If (SearchResult = 0)
		MsgBox, 49, %d_Lang035%, %d_Lang036% %FoundX%x%FoundY%.`n%d_Lang038%
	Else
		MsgBox, 49, %d_Lang035%, %d_Lang037%`n%d_Lang038%
	IfMsgBox, Cancel
		StopIt := 1
}
CoordMode, Mouse, %CoordMouse%
return

SplitStep:
GoSub, ClearPars
If (Type = cType34)
	StringReplace, Step, Step, `n, ø, All
If (Type = cType39)
	Step := RegExReplace(Step, "\w+", "%$0%", "", 1)
EscCom("Step|TimesX|DelayX|Target|Window", 1)
StringReplace, Step, Step, `%A_Space`%, ⱥ, All
CheckVars("Step|TimesX|DelayX|Target|Window", This_Point)
StringReplace, Step, Step, ```,, ¢, All
StringReplace, Step, Step, ``n, `n, All
StringReplace, Step, Step, ``r, `r, All
StringReplace, Step, Step, ``t, `t, All
Loop, Parse, Step, `,, %A_Space%
{
	LoopField := A_LoopField
	CheckVars("LoopField", This_Point)
	If ((InStr(Type, "String") = 1) || (Type = SplitPath))
	{
		If RegExMatch(LoopField, "i)^A_Loop\w+$", lMatch)
		{
			I := DerefVars(LoopIndex), L := SubStr(lMatch, 3)
		,	This_Par := o_Loop%This_Point%[I][L]
		,	Par%A_Index% := "This_Par"
		}
		Else
			Par%A_Index% := LoopField
	}
	Else
		Par%A_Index% := LoopField
	StringReplace, Par%A_Index%, Par%A_Index%, ``n, `n, All
	StringReplace, Par%A_Index%, Par%A_Index%, ``r, `r, All
	StringReplace, Par%A_Index%, Par%A_Index%, ¢, `,, All
	StringReplace, Par%A_Index%, Par%A_Index%, ⱥ, %A_Space%, All
	StringReplace, Par%A_Index%, Par%A_Index%, ``,, All
}
StringReplace, Step, Step, ¢, `,, All
StringReplace, Step, Step, ⱥ, %A_Space%, All
StringReplace, Step, Step, ``,, All
If (Type = cType34)
{
	StringReplace, Step, Step, `n, ``n, All
	StringReplace, Step, Step, ø, `n, All
}
return

ClearPars:
Loop, 7
	Par%A_Index% := ""
return

ListVars:
ListVars
return

;##### Hide / Close: #####

ShowHideTB:
ShowHide:
If WinExist("ahk_id" PMCWinID)
{
	If (A_ThisLabel = "ShowHideTB")
	{
		WinGet, WinState, MinMax, ahk_id %PMCWinID%
		If WinState = -1
			WinActivate
		Else
		{
			Menu, Tray, Rename, %y_Lang001%, %y_Lang002%
			Gui, 1:Show, Hide
		}
	}
	Else
	{
		Menu, Tray, Rename, %y_Lang001%, %y_Lang002%
		Gui, 1:Show, Hide
	}
}
Else
{
	Menu, Tray, Rename, %y_Lang002%, %y_Lang001%
	Gui, 1:Show,, %AppName% v%CurrentVersion% %CurrentFileName%
	GoSub, GuiSize
}
return

OnFinishAction:
If OnFinishCode =  2
	ExitApp
If OnFinishCode =  3
	Shutdown, 1
If OnFinishCode =  4
	Shutdown, 5
If OnFinishCode =  5
	Shutdown, 2
If OnFinishCode =  6
	Shutdown, 0
If OnFinishCode =  7
	DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
If OnFinishCode =  8
	DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
If OnFinishCode =  9
	DllCall("LockWorkStation")
return

Exit:
GuiClose:
Gui, 1:+OwnDialogs
Gui, 1:Submit, NoHide
GoSub, SaveData
Gui, chMacro:Default
Gui, chMacro:ListView, InputList%A_List%
If ((ListCount > 0) && (SavePrompt))
{
	MsgBox, 35, %d_Lang005%, %d_Lang002%`n`"%CurrentFileName%`"
	IfMsgBox, Yes
	{
		GoSub, Save
		IfMsgBox, Cancel
			return
	}
	IfMsgBox, Cancel
		return
}
DetectHiddenWindows, On
WinGet, WinState, MinMax, ahk_id %PMCWinID%
If WinState = -1
	WinState := 0
Else If WinState = 0
	GuiGetSize(mGuiWidth, mGuiHeight), MainWinSize := "W" mGuiWidth " H" mGuiHeight
ColSizes := ""
Loop % LV_GetCount("Col")
{
    SendMessage, 4125, A_Index - 1, 0, SysListView321, ahk_id %PMCWinID%
	ColSizes .= Floor(ErrorLevel / Round(A_ScreenDPI / 96, 2)) ","
}
GoSub, GetHotkeys
If (KeepDefKeys = 1)
	AutoKey := DefAutoKey, ManKey := DefManKey
IfWinExist, ahk_id %PMCOSC%
	GoSub, 28GuiClose
MainLayout := RbMain.GetLayout(), MacroLayout := RbMacro.GetLayout()
,	FileLayout := TbFile.Export(), RecPlayLayout := TbRecPlay.Export()
,	SettingsLayout := TbSettings.Export(), CommandLayout := TbCommand.Export()
,	EditLayout := TbEdit.Export(), ShowBands := ""
Loop, 9
	ShowBands .= ShowBand%A_Index% ","
GoSub, WriteSettings
IL_Destroy(hIL_Icons)
Loop, %A_Temp%\PMC_*.ahk
	FileDelete, %A_LoopFileFullPath%
ExitApp
return

;##### Default Settings: #####

LoadSettings:
If !KeepDefKeys
	AutoKey := "F3|F4|F5|F6|F7", ManKey := ""
AbortKey := "F8"
,	PauseKey := "F12"
,	RecKey := "F9"
,	RecNewKey := "F10"
,	RelKey := "CapsLock"
,	DelayG := 0
,	OnScCtrl := 1
,	ShowStep := 1
,	HideMainWin := 1
,	DontShowPb := 0
,	DontShowRec := 0
,	DontShowAdm := 0
,	IfDirectContext := "None"
,	IfDirectWindow := ""
,	KeepHkOn := 0
,	Mouse := 1
,	Moves := 1
,	TimedI := 1
,	Strokes := 1
,	CaptKDn := 0
,	MScroll := 1
,	WClass := 1
,	WTitle := 1
,	MDelay := 0
,	DelayM := 10
,	DelayW := 333
,	MaxHistory := 100
,	TDelay := 10
,	ToggleC := 0
,	RecKeybdCtrl := 0
,	RecMouseCtrl := 0
,	CoordMouse := "Window"
,	FastKey := "Insert"
,	SlowKey := "Pause"
,	ClearNewList := 0
,	SpeedUp := 2
,	SpeedDn := 2
,	MouseReturn := 0
,	ShowProgBar := 1
,	ShowBarOnStart := 0
,	RandomSleeps := 0
,	RandPercent := 50
,	DrawButton := "RButton"
,	OnRelease := 1
,	OnEnter := 0
,	LineW := 2
,	ScreenDir := A_AppData "\MacroCreator\Screenshots"
,	DefaultEditor := "notepad.exe"
,	DefaultMacro := ""
,	StdLibFile := ""
,	Ex_AbortKey := 0
,	Ex_PauseKey := 0
,	Ex_SM := 1
,	SM := "Input"
,	Ex_SI := 1
,	SI := "Force"
,	Ex_ST := 1
,	ST := 2
,	Ex_DH := 1
,	Ex_AF := 1
,	Ex_HK := 0
,	Ex_PT := 0
,	Ex_NT := 0
,	Ex_SC := 1
,	SC := 1
,	Ex_SW := 1
,	SW := 0
,	Ex_SK := 1
,	SK := -1
,	Ex_MD := 1
,	MD := -1
,	Ex_SB := 1
,	SB := -1
,	Ex_MT := 0
,	MT := 2
,	Ex_IN := 1
,	Ex_UV := 1
,	Ex_Speed := 0
,	ComCr := 1
,	ComAc := 0
,	Send_Loop := 0
,	TabIndent := 1
,	IncPmc := 0
,	Exe_Exp := 0
,	WinState := 0
,	HKOff := 0
,	MultInst := 0
,	EvalDefault := 0
,	AllowRowDrag := 1
,	ShowLoopIfMark := 1
,	ShowActIdent := 1
,	LoopLVColor := 0xFFFF00
,	IfLVColor := 0x0000FF
,	OSCPos := "X0 Y0"
,	OSTrans := 255
,	OSCaption := 0
,	OSCaption := 0
,	CustomColors := 0
,	OnFinishCode := 1
WinSet, Transparent, %OSTrans%, ahk_id %PMCOSC%
GuiControl, 28:, OSTrans, 255
Gui, 28:-Caption
If (WinExist("ahk_id " PMCOSC))
	Gui, 28:Show, % OSCPos (ShowProgBar ? "H40" : "H30") " W415 NoActivate", %AppName%
GuiControl, 1:, CoordTip, CoordMode: %CoordMouse%
GuiControl, 1:, ContextTip, #IfWin: %IfDirectContext%
GuiControl, 1:, AbortKey, %AbortKey%
GuiControl, 1:, PauseKey, %PauseKey%
GuiControl, 1:, DelayG, 0
GoSub, DefaultLayout
GoSub, DefaultMod
GoSub, ObjCreate
GoSub, LoadData
SetColSizes:
ColSizes := "70,130,190,50,40,85,95,95,60,40"
Loop, Parse, ColSizes, `,
	Col_%A_Index% := A_LoopField
Gui, chMacro:Default
Loop, %TabCount%
{
	Gui, chMacro:ListView, InputList%A_Index%
	Loop, 10
		LV_ModifyCol(A_Index, Col_%A_Index%)
}
Gui, chMacro:ListView, InputList%A_List%
GoSub, SetFinishButtom
return

DefaultMod:
VirtualKeys := "
(Join
{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}
{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}
{1}{2}{3}{4}{5}{6}{7}{8}{9}{0}{'}{-}{=}{[}{]}{;}{/}{,}{.}{\}
{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Esc}
{PrintScreen}{Pause}{Enter}{Tab}{Space}
{Numpad0}{Numpad1}{Numpad2}{Numpad3}{Numpad4}{Numpad5}{Numpad6}{Numpad7}
{Numpad8}{Numpad9}{NumpadDot}{NumpadDiv}{NumpadMult}{NumpadAdd}{NumpadSub}
{NumpadIns}{NumpadEnd}{NumpadDown}{NumpadPgDn}{NumpadLeft}{NumpadClear}
{NumpadRight}{NumpadHome}{NumpadUp}{NumpadPgUp}{NumpadDel}{NumpadEnter}
{Browser_Back}{Browser_Forward}{Browser_Refresh}{Browser_Stop}
{Browser_Search}{Browser_Favorites}{Browser_Home}{Volume_Mute}{Volume_Down}
{Volume_Up}{Media_Next}{Media_Prev}{Media_Stop}{Media_Play_Pause}
{Launch_Mail}{Launch_Media}{Launch_App1}{Launch_App2}
)"
return

DefaultHotkeys:
If (KeepDefKeys = 1)
	AutoKey := DefAutoKey, ManKey := DefManKey
Else
	AutoKey := "F3|F4|F5|F6|F7", ManKey := ""
o_AutoKey := Object(), o_ManKey := Object()
GoSub, ObjParse
GoSub, SetNoJoy
GoSub, LoadData
GoSub, b_Start
return

ObjCreate:
o_AutoKey := Object()
,	o_ManKey := Object()
,	o_TimesG := Object()

ObjParse:
Loop, Parse, AutoKey, |
	o_AutoKey.Insert(A_LoopField)
Loop, Parse, ManKey, |
	o_ManKey.Insert(A_LoopField)
return

DefaultLayout:
Loop, 9
	ShowBand%A_Index% := 1
	TbFile.Reset(), TB_IdealSize(TbFile, 1)
,	TbRecPlay.Reset(), TB_IdealSize(TbRecPlay, 2)
,	TbSettings.Reset(), TB_IdealSize(TbSettings, 3)
,	TbCommand.Reset(), TB_IdealSize(TbCommand, 5)
,	TbEdit.Reset(), TB_IdealSize(TbEdit, 9)
,	TB_Edit(TbFile, "Preview", ShowPrev)
,	TB_Edit(TbSettings, "HideMainWin", HideMainWin)
,	TB_Edit(TbSettings, "OnScCtrl", OnScCtrl)
,	TB_Edit(TbSettings, "CheckHkOn", KeepHkOn)
,	TB_Edit(TbSettings, "SetWin", 0)
,	TB_Edit(TbSettings, "SetJoyButton", 0)
,	TB_Edit(TbOSC, "ProgBarToggle", ShowProgBar)
Loop, 3
	RbMain.SetLayout(Default_MainLayout)
Menu, ViewMenu, Check, %v_lang002%
Menu, ViewMenu, Check, %v_lang003%
Menu, ToolbarsMenu, Check, %v_lang009%
Menu, ToolbarsMenu, Check, %v_lang010%
Menu, ToolbarsMenu, Check, %v_lang011%
Menu, ToolbarsMenu, Check, %v_lang012%
Menu, ToolbarsMenu, Check, %v_lang013%
Menu, HotkeyMenu, Check, %v_lang015%
Menu, HotkeyMenu, Check, %v_lang016%
Menu, HotkeyMenu, Check, %v_lang017%
Menu, HotkeyMenu, Check, %v_lang018%
return

WriteSettings:
IniWrite, %CurrentVersion%, %IniFilePath%, Application, Version
IniWrite, %Lang%, %IniFilePath%, Language, Lang
IniWrite, %AutoKey%, %IniFilePath%, HotKeys, AutoKey
IniWrite, %ManKey%, %IniFilePath%, HotKeys, ManKey
IniWrite, %AbortKey%, %IniFilePath%, HotKeys, AbortKey
IniWrite, %PauseKey%, %IniFilePath%, HotKeys, PauseKey
IniWrite, %RecKey%, %IniFilePath%, HotKeys, RecKey
IniWrite, %RecNewKey%, %IniFilePath%, HotKeys, RecNewKey
IniWrite, %RelKey%, %IniFilePath%, HotKeys, RelKey
IniWrite, %FastKey%, %IniFilePath%, HotKeys, FastKey
IniWrite, %SlowKey%, %IniFilePath%, HotKeys, SlowKey
IniWrite, %ClearNewList%, %IniFilePath%, Options, ClearNewList
IniWrite, %DelayG%, %IniFilePath%, Options, DelayG
IniWrite, %OnScCtrl%, %IniFilePath%, Options, OnScCtrl
IniWrite, %ShowStep%, %IniFilePath%, Options, ShowStep
IniWrite, %HideMainWin%, %IniFilePath%, Options, HideMainWin
IniWrite, %DontShowPb%, %IniFilePath%, Options, DontShowPb
IniWrite, %DontShowRec%, %IniFilePath%, Options, DontShowRec
IniWrite, %DontShowAdm%, %IniFilePath%, Options, DontShowAdm
IniWrite, %ShowTips%, %IniFilePath%, Options, ShowTips
IniWrite, %NextTip%, %IniFilePath%, Options, NextTip
IniWrite, %IfDirectContext%, %IniFilePath%, Options, IfDirectContext
IniWrite, %IfDirectWindow%, %IniFilePath%, Options, IfDirectWindow
IniWrite, %KeepHkOn%, %IniFilePath%, Options, KeepHkOn
IniWrite, %Mouse%, %IniFilePath%, Options, Mouse
IniWrite, %Moves%, %IniFilePath%, Options, Moves
IniWrite, %TimedI%, %IniFilePath%, Options, TimedI
IniWrite, %Strokes%, %IniFilePath%, Options, Strokes
IniWrite, %CaptKDn%, %IniFilePath%, Options, CaptKDn
IniWrite, %MScroll%, %IniFilePath%, Options, MScroll
IniWrite, %WClass%, %IniFilePath%, Options, WClass
IniWrite, %WTitle%, %IniFilePath%, Options, WTitle
IniWrite, %MDelay%, %IniFilePath%, Options, MDelay
IniWrite, %DelayM%, %IniFilePath%, Options, DelayM
IniWrite, %DelayW%, %IniFilePath%, Options, DelayW
IniWrite, %MaxHistory%, %IniFilePath%, Options, MaxHistory
IniWrite, %TDelay%, %IniFilePath%, Options, TDelay
IniWrite, %ToggleC%, %IniFilePath%, Options, ToggleC
IniWrite, %RecKeybdCtrl%, %IniFilePath%, Options, RecKeybdCtrl
IniWrite, %RecMouseCtrl%, %IniFilePath%, Options, RecMouseCtrl
IniWrite, %CoordMouse%, %IniFilePath%, Options, CoordMouse
IniWrite, %SpeedUp%, %IniFilePath%, Options, SpeedUp
IniWrite, %SpeedDn%, %IniFilePath%, Options, SpeedDn
IniWrite, %MouseReturn%, %IniFilePath%, Options, MouseReturn
IniWrite, %ShowProgBar%, %IniFilePath%, Options, ShowProgBar
IniWrite, %ShowBarOnStart%, %IniFilePath%, Options, ShowBarOnStart
IniWrite, %RandomSleeps%, %IniFilePath%, Options, RandomSleeps
IniWrite, %RandPercent%, %IniFilePath%, Options, RandPercent
IniWrite, %DrawButton%, %IniFilePath%, Options, DrawButton
IniWrite, %OnRelease%, %IniFilePath%, Options, OnRelease
IniWrite, %OnEnter%, %IniFilePath%, Options, OnEnter
IniWrite, %LineW%, %IniFilePath%, Options, LineW
IniWrite, %ScreenDir%, %IniFilePath%, Options, ScreenDir
IniWrite, %DefaultEditor%, %IniFilePath%, Options, DefaultEditor
IniWrite, %DefaultMacro%, %IniFilePath%, Options, DefaultMacro
IniWrite, %StdLibFile%, %IniFilePath%, Options, StdLibFile
IniWrite, %KeepDefKeys%, %IniFilePath%, Options, KeepDefKeys
IniWrite, %HKOff%, %IniFilePath%, Options, HKOff
IniWrite, %MultInst%, %IniFilePath%, Options, MultInst
IniWrite, %EvalDefault%, %IniFilePath%, Options, EvalDefault
IniWrite, %AllowRowDrag%, %IniFilePath%, Options, AllowRowDrag
IniWrite, %ShowLoopIfMark%, %IniFilePath%, Options, ShowLoopIfMark
IniWrite, %ShowActIdent%, %IniFilePath%, Options, ShowActIdent
IniWrite, %LoopLVColor%, %IniFilePath%, Options, LoopLVColor
IniWrite, %IfLVColor%, %IniFilePath%, Options, IfLVColor
IniWrite, %VirtualKeys%, %IniFilePath%, Options, VirtualKeys
IniWrite, %AutoUpdate%, %IniFilePath%, Options, AutoUpdate
IniWrite, %Ex_AbortKey%, %IniFilePath%, ExportOptions, Ex_AbortKey
IniWrite, %Ex_PauseKey%, %IniFilePath%, ExportOptions, Ex_PauseKey
IniWrite, %Ex_SM%, %IniFilePath%, ExportOptions, Ex_SM
IniWrite, %SM%, %IniFilePath%, ExportOptions, SM
IniWrite, %Ex_SI%, %IniFilePath%, ExportOptions, Ex_SI
IniWrite, %SI%, %IniFilePath%, ExportOptions, SI
IniWrite, %Ex_ST%, %IniFilePath%, ExportOptions, Ex_ST
IniWrite, %ST%, %IniFilePath%, ExportOptions, ST
IniWrite, %Ex_DH%, %IniFilePath%, ExportOptions, Ex_DH
IniWrite, %Ex_AF%, %IniFilePath%, ExportOptions, Ex_AF
IniWrite, %Ex_HK%, %IniFilePath%, ExportOptions, Ex_HK
IniWrite, %Ex_PT%, %IniFilePath%, ExportOptions, Ex_PT
IniWrite, %Ex_NT%, %IniFilePath%, ExportOptions, Ex_NT
IniWrite, %Ex_SC%, %IniFilePath%, ExportOptions, Ex_SC
IniWrite, %SC%, %IniFilePath%, ExportOptions, SC
IniWrite, %Ex_SW%, %IniFilePath%, ExportOptions, Ex_SW
IniWrite, %SW%, %IniFilePath%, ExportOptions, SW
IniWrite, %Ex_SK%, %IniFilePath%, ExportOptions, Ex_SK
IniWrite, %SK%, %IniFilePath%, ExportOptions, SK
IniWrite, %Ex_MD%, %IniFilePath%, ExportOptions, Ex_MD
IniWrite, %MD%, %IniFilePath%, ExportOptions, MD
IniWrite, %Ex_SB%, %IniFilePath%, ExportOptions, Ex_SB
IniWrite, %SB%, %IniFilePath%, ExportOptions, SB
IniWrite, %Ex_MT%, %IniFilePath%, ExportOptions, Ex_MT
IniWrite, %MT%, %IniFilePath%, ExportOptions, MT
IniWrite, %Ex_IN%, %IniFilePath%, ExportOptions, Ex_IN
IniWrite, %Ex_UV%, %IniFilePath%, ExportOptions, Ex_UV
IniWrite, %Ex_Speed%, %IniFilePath%, ExportOptions, Ex_Speed
IniWrite, %ComCr%, %IniFilePath%, ExportOptions, ComCr
IniWrite, %ComAc%, %IniFilePath%, ExportOptions, ComAc
IniWrite, %Send_Loop%, %IniFilePath%, ExportOptions, Send_Loop
IniWrite, %TabIndent%, %IniFilePath%, ExportOptions, TabIndent
IniWrite, %IncPmc%, %IniFilePath%, ExportOptions, IncPmc
IniWrite, %Exe_Exp%, %IniFilePath%, ExportOptions, Exe_Exp
IniWrite, %MainWinSize%, %IniFilePath%, WindowOptions, MainWinSize
IniWrite, %ShowPrev%, %IniFilePath%, WindowOptions, ShowPrev
IniWrite, %WinState%, %IniFilePath%, WindowOptions, WinState
IniWrite, %ColSizes%, %IniFilePath%, WindowOptions, ColSizes
IniWrite, %CustomColors%, %IniFilePath%, WindowOptions, CustomColors
IniWrite, %OSCPos%, %IniFilePath%, WindowOptions, OSCPos
IniWrite, %OSTrans%, %IniFilePath%, WindowOptions, OSTrans
IniWrite, %OSCaption%, %IniFilePath%, WindowOptions, OSCaption
IniWrite, %MainLayout%, %IniFilePath%, ToolbarOptions, MainLayout
IniWrite, %MacroLayout%, %IniFilePath%, ToolbarOptions, MacroLayout
IniWrite, %FileLayout%, %IniFilePath%, ToolbarOptions, FileLayout
IniWrite, %RecPlayLayout%, %IniFilePath%, ToolbarOptions, RecPlayLayout
IniWrite, %SettingsLayout%, %IniFilePath%, ToolbarOptions, SettingsLayout
IniWrite, %CommandLayout%, %IniFilePath%, ToolbarOptions, CommandLayout
IniWrite, %EditLayout%, %IniFilePath%, ToolbarOptions, EditLayout
IniWrite, %ShowBands%, %IniFilePath%, ToolbarOptions, ShowBands
return

;###########################################################
; Original by jaco0646
; http://autohotkey.com/forum/topic51428.html
;###########################################################

#If ctrl := HotkeyCtrlHasFocus()
*AppsKey::
*BackSpace::
*Delete::
*Enter::
*NumpadEnter::
*Escape::
*Pause::
*PrintScreen::
*Space::
*Tab::
modifier := ""
If (GuiA <> 15) && (GuiA <> 3) && HotkeyCtrlHasFocus()!="ManKey"
{
	If GetKeyState("Shift","P")
		modifier .= "+"
	If GetKeyState("Ctrl","P")
		modifier .= "^"
	If GetKeyState("Alt","P")
		modifier .= "!"
}
Gui, %GuiA%:Submit, NoHide
If (A_ThisHotkey == "*BackSpace" && %ctrl% && !modifier)
	GuiControl, %GuiA%:,%ctrl%
Else
	GuiControl, %GuiA%:,%ctrl%, % modifier SubStr(A_ThisHotkey,2)
return
#If

;##################################################

;##### Subroutines: Checks #####

b_Start:
Gui, 1:Submit, NoHide
GoSub, b_Enable
If !Record
	HistCheck(A_List)
GuiControl, 28:+Range1-%TabCount%, OSHK
GuiControl, 28:, OSHK, %A_List%
return

b_Enable:
Gui, chMacro:Default
Gui, chMacro:ListView, InputList%A_List%
ListCount%A_List% := LV_GetCount(), ListCount := 0
Loop, %TabCount%
	ListCount += ListCount%A_Index%
return

WinCheck:
WinGet, W_ID, ID, A
If ((WinActive("ahk_id " PrevID)) || (W_ID = TipScrID)
|| (W_ID = StartTipID) || (W_ID = PMCOSC))
	return
WinGetClass, W_CLS, ahk_id %W_ID%
If (W_CLS = "#32770")
	return
If ((WPHKC = 1) || (WPHKC = 2))
{
	Input
	ToolTip
	If Record = 1
		GoSub, RowCheck
	If WinActive("ahk_id " PMCWinID)
	{
		Record := 0, StopIt := 1
		Sleep, 100
		GoSub, RecStop
		GoSub, ResetHotkeys
	}
}
Else
	GoSub, KeepHkOn
Gui, 1:Submit, NoHide
Gui, chMacro:ListView, InputList%A_List%
return

WaitMenuClose:
IfWinNotExist, ahk_class #32768
{
	SetTimer, WaitMenuClose, Off
	SetTimer, ResumeCheck, -333
}
return

ResumeCheck:
HaltCheck := 0
return

RowCheck:
Gui, chMacro:Default
Gui, chMacro:ListView, InputList%A_List%
GuiControl, chMacro:-Redraw, InputList%A_List%
ListCount%A_List% := LV_GetCount()
,	IdxLv := "", ActLv := "", IsInIf := 0, IsInLoop := 0, RowColorLoop := 0, RowColorIf := 0
Critical
Loop, % LV_GetCount()
{
	LV_GetText(Action, A_Index, 2)
	Action := LTrim(Action)
	LV_GetText(Type, A_Index, 6)
	LV_GetText(Color, A_Index, 10)
	LV_Modify(A_Index, "Col2", Action)
	If ShowLoopIfMark = 1
	{
		OnMessage(WM_NOTIFY, "LV_ColorsMessage")
	,	LV_Colors.Attach(ListID%A_List%, False, False)
		If (Action = "[LoopEnd]")
			RowColorLoop--, IdxLv := SubStr(IdxLv, 1, StrLen(IdxLv)-1)
		Else If (Action = "[End If]")
			RowColorIf--, IdxLv := SubStr(IdxLv, 1, StrLen(IdxLv)-1)
		Else If (Action = "[LoopStart]")
			RowColorLoop++, IdxLv .= "{"
		Else If ((Type = cType17) && (Action <> "[Else]"))
			RowColorIf++, IdxLv .= "*"
		LV_Colors.Row(ListID%A_List%, A_Index
		, (RowColorLoop > 0) ? LoopLVColor : ((Action = "[LoopEnd]") ? LoopLVColor : "")
		, (RowColorIf > 0 ) ? IfLVColor : ((Action = "[End If]") ? IfLVColor : ""))
		LV_Colors.Cell(ListID%A_List%, A_Index, 1, Color ? Color : "")
	}
	Else
		OnMessage(WM_NOTIFY, ""), LV_Colors.Detach(ListID%A_List%)
	If ShowActIdent = 1
	{
		LV_Modify(A_Index, "Col2", ActLv Action)
		If (Action = "[LoopEnd]")
			ActLv := SubStr(ActLv, 4), LV_Modify(A_Index, "Col2", ActLv Action)
		Else If (Action = "[End If]")
			ActLv := SubStr(ActLv, 4), LV_Modify(A_Index, "Col2", ActLv Action)
		Else If (Action = "[Else]")
			LV_Modify(A_Index, "Col2", SubStr(ActLv, 4) Action)
		Else If (Action = "[LoopStart]")
			ActLv .= (ShowActIdent) ? "   " : ""
		Else If ((Type = cType17) && (Action <> "[Else]"))
			ActLv .= (ShowActIdent) ? "   " : ""
	}
	LV_Modify(A_Index, "", A_Index " " IdxLv)
,	RegExMatch(Type, cType3 "|" cType4 "|" cType13) ? LV_Modify(A_Index, "Icon" 39)
:	(Type = cType5) ? LV_Modify(A_Index, "Icon" 46)
:	(Type = cType6) ? LV_Modify(A_Index, "Icon" 11)
:	(Type = cType14) ? LV_Modify(A_Index, "Icon" 78)
:	RegExMatch(Type, cType7 "|" cType38 "|" cType39 "|" cType40 "|" cType41) ? LV_Modify(A_Index, "Icon" 37)
:	(Type = cType29) ? LV_Modify(A_Index, "Icon" 2)
:	(Type = cType30) ? LV_Modify(A_Index, "Icon" 6)
:	RegExMatch(Type, cType11 "|" cType14 "|Run|RunWait|RunAs") ? LV_Modify(A_Index, "Icon" 59)
:	(Action = "[Assign Variable]") ? LV_Modify(A_Index, "Icon" 76)
:	(Type = cType21) ? LV_Modify(A_Index, "Icon" 21)
:	(Type = cType17) ? LV_Modify(A_Index, "Icon" 27)
:	RegExMatch(Type, cType18 "|" cType19) ? LV_Modify(A_Index, "Icon" 62)
:	(Type = cType15) ? LV_Modify(A_Index, "Icon" 3)
:	(Type = cType16) ? LV_Modify(A_Index, "Icon" 28)
:	(Action = "[Control]") ? LV_Modify(A_Index, "Icon" 7)
:	RegExMatch(Type, cType32 "|" cType33) ? LV_Modify(A_Index, "Icon" 26)
:	(Type = cType34) ? LV_Modify(A_Index, "Icon" 4)
:	(Type = cType42) ? LV_Modify(A_Index, "Icon" 77)
:	(Type = cType43) ? LV_Modify(A_Index, "Icon" 34)
:	(Type = cType35) ? LV_Modify(A_Index, "Icon" 35)
:	RegExMatch(Type, cType36 "|" cType37) ? LV_Modify(A_Index, "Icon" 22)
:	LV_Modify(A_Index, "Icon" 71)
	RegExMatch(Type, "Process") ? LV_Modify(A_Index, "Icon" 51)
:	RegExMatch(Type, "Shutdown") ? LV_Modify(A_Index, "Icon" 63)
:	(InStr(Type, "Sort") || InStr(Type, "String") || InStr(Type, "Split")) ? LV_Modify(A_Index, "Icon" 5)
:	(InStr(Type, "InputBox") || InStr(Type, "Msg") || InStr(Type, "Tip")
	|| InStr(Type, "Progress") || InStr(Type, "Splash")) ? LV_Modify(A_Index, "Icon" 11)
:	InStr(Type, "Win") ? LV_Modify(A_Index, "Icon" 81)
:	(InStr(Type, "File")=1 || InStr(Type, "Drive")=1) ? LV_Modify(A_Index, "Icon" 18)
:	(InStr(Type, "Wait") || InStr(Type, "Input")=1) ? LV_Modify(A_Index, "Icon" 78)
:	InStr(Type, "Ini") ? LV_Modify(A_Index, "Icon" 31)
:	InStr(Type, "Reg") ? LV_Modify(A_Index, "Icon" 58)
:	InStr(Type, "Sound") ? LV_Modify(A_Index, "Icon" 65)
:	InStr(Type, "Group") ? LV_Modify(A_Index, "Icon" 23)
:	InStr(Type, "Env") ? LV_Modify(A_Index, "Icon" 76)
:	(!InStr(Type, "Control") && InStr(Type, "Get")) ? LV_Modify(A_Index, "Icon" 30)
:	(Type = "Pause") ? LV_Modify(A_Index, "Icon" 56)
:	(Type = "Return") ? LV_Modify(A_Index, "Icon" 66)
:	(Type = "ExitApp") ? LV_Modify(A_Index, "Icon" 15)
:	(InStr(Type, "LockState") || InStr(Type, "Time") || InStr(Type, "Transform")
	|| InStr(Type, "Random") || InStr(Type, "ClipWait") || InStr(Type, "Block")
	|| InStr(Type, "Url") || InStr(Type, "Status") || InStr(Type, "SendLevel") || InStr(Type, "CoordMode")) ?  LV_Modify(A_Index, "Icon" 38)
:	""
}
Critical, Off
GuiControl, chMacro:+Redraw, InputList%A_List%
Gui, 1:Default
FreeMemory()
return

RecKeyUp:
If !GetKeyState("RAlt", "P")
	HoldRAlt := 0
If Record = 0
{
	Gui, 1:Submit, NoHide
	If Capt = 0
	{
		HotKey, %A_ThisHotKey%, RecKeyUp, Off
		return
	}
}
StringTrimLeft, sKey, A_ThisHotKey, 2
If (sKey = "VKC1SC730 Up")
	sKey := "/ Up"
Else If (sKey = "VKC2SC7E0 Up")
	sKey := ". Up"
ScK := GetKeySC(RegExReplace(sKey, " Up$"))
Hold%ScK% := 0, tKey := sKey, sKey := "{" sKey "}"
If (Record || ListFocus)
	GoSub, InsertRow
HotKey, %A_ThisHotKey%, RecKeyUp, Off
return

;##### Size & Position: #####

2GuiSize:
If A_EventInfo = 1
	return

GuiGetSize(GuiWidth, GuiHeight, 2)
GuiControl, Move, LVPrev, % "W" GuiWidth "H" GuiHeight-57
return

chPrevGuiSize:
GuiGetSize(GuiWidth, GuiHeight, "chPrev")
GuiControl, chPrev:Move, LVPrev, % "W" GuiWidth "H" GuiHeight-40
return

28GuiSize:
If (WinExist("ahk_id " PMCOSC))
	Gui, 28:Show, % (ShowProgBar ? "H40" : "H30") " W380 NoActivate", %AppName%
return

chMacroGuiSize:
Critical
GuiGetSize(GuiWidth, GuiHeight, "chMacro")
GuiControl, chMacro:Move, InputList%A_List%, % "W" GuiWidth-15 "H" GuiHeight-35
GuiControl, chMacro:Move, A_List, % "W" GuiWidth-15
return

GuiSize:
If A_EventInfo = 1
	return
Critical 1000
GuiGetSize(GuiWidth, GuiHeight)
,	RbMain.ShowBand(1)
,	RbMacro.ModifyBand(1, "MinHeight", (GuiHeight-MacroOffset)*(A_ScreenDPI/96))
,	RbMacro.ModifyBand(2, "MinHeight", (GuiHeight-MacroOffset)*(A_ScreenDPI/96))
GuiControl, 1:Move, cRbMacro, % "W" GuiWidth
GuiControl, 1:Move, Repeat, % "y" GuiHeight-23
GuiControl, 1:Move, Rept, % "y" GuiHeight-27
GuiControl, 1:Move, TimesM, % "y" GuiHeight-27
GuiControl, 1:Move, DelayT, % "y" GuiHeight-23
GuiControl, 1:Move, Delay, % "y" GuiHeight-27
GuiControl, 1:Move, DelayG, % "y" GuiHeight-27
GuiControl, 1:Move, ApplyT, % "y" GuiHeight-28
GuiControl, 1:Move, ApplyI, % "y" GuiHeight-28
GuiControl, 1:Move, sInput, % "y" GuiHeight-27
GuiControl, 1:Move, ApplyL, % "y" GuiHeight-28
GuiControl, 1:Move, InsertKey, % "y" GuiHeight-28
GuiControl, 1:Move, Separator1, % "y" GuiHeight-27
GuiControl, 1:Move, Separator2, % "y" GuiHeight-27
GuiControl, 1:Move, Separator3, % "y" GuiHeight-27
GuiControl, 1:MoveDraw, CoordTip, % "y" GuiHeight-14
GuiControl, 1:MoveDraw, ContextTip, % "y" GuiHeight-30
return

;##### Subroutines: Substitution #####

Replace:
If InStr(sKey, "_")
	StringReplace, tKey, tKey, _, %A_Space%, All
If InStr(tKey, "+")
	StringReplace, sKey, tKey, +, Shift Down}{
If InStr(tKey, "^")
	StringReplace, sKey, tKey, ^, Control Down}{
If InStr(tKey, "!")
	StringReplace, sKey, tKey, !, Alt Down}{
If InStr(sKey, "+")
	StringReplace, sKey, sKey, +, Shift Down}{
If InStr(sKey, "^")
	StringReplace, sKey, sKey, ^, Control Down}{
If InStr(sKey, "!")
	StringReplace, sKey, sKey, !, Alt Down}{

If InStr(sKey, "Alt Down")
	sKey := sKey "}{Alt Up"
If InStr(sKey, "Control Down")
	sKey := sKey "}{Control Up"
If InStr(sKey, "Shift Down")
	sKey := sKey "}{Shift Up"

StringGetPos, pos, tKey, +
If pos = 0
	StringReplace, tKey, tKey, +, Shift +%A_Space%
If InStr(tKey, "^")
	StringReplace, tKey, tKey, ^, Control +%A_Space%
If InStr(tKey, "!")
	StringReplace, tKey, tKey, !, Alt +%A_Space%

If InStr(tKey, "Numpad")
	StringReplace, tKey, tKey, Numpad, Num%A_Space%
return

ChReplace:
Loop, 26
{
	Transform, Ch, Chr, %A_Index%
	StringReplace, sKey, sKey, %Ch%, % Chr(96+A_Index)
}
return

;##### MenuBar: #####

CreateMenuBar:
GoSub, RecentFiles
; Menus
Menu, FileMenu, Add, %f_Lang001%`t%_s%Ctrl+N, New
Menu, FileMenu, Add, %f_Lang002%`t%_s%Ctrl+O, Open
Menu, FileMenu, Add, %f_Lang003%`t%_s%Ctrl+S, Save
Menu, FileMenu, Add, %f_Lang004%`t%_s%Ctrl+Shift+S, SaveAs
Menu, FileMenu, Add, %f_Lang005%, :RecentMenu
Menu, FileMenu, Add
Menu, FileMenu, Add, %f_Lang006%`t%_s%Ctrl+E, Export
Menu, FileMenu, Add, %f_Lang007%`t%_s%Ctrl+P, Preview
Menu, FileMenu, Add
Menu, FileMenu, Add, %f_Lang008%`t%_s%Alt+F3, ListVars
Menu, FileMenu, Add
Menu, FileMenu, Add, %f_Lang009%`t%_s%Alt+F4, Exit

Menu, InsertMenu, Add, %i_Lang001%`t%_s%F2, Mouse
Menu, InsertMenu, Add, %i_Lang002%`t%_s%F3, Text
Menu, InsertMenu, Add, %i_Lang003%`t%_s%F4, ControlCmd
Menu, InsertMenu, Add
Menu, InsertMenu, Add, %i_Lang004%`t%_s%F5, Pause
Menu, InsertMenu, Add, %i_Lang005%`t%_s%Shift+F5, MsgBox
Menu, InsertMenu, Add, %i_Lang006%`t%_s%Ctrl+F5, KeyWait
Menu, InsertMenu, Add
Menu, InsertMenu, Add, %i_Lang007%`t%_s%F6, Window
Menu, InsertMenu, Add, %i_Lang008%`t%_s%F7, Image
Menu, InsertMenu, Add, %i_Lang009%`t%_s%F8, Run
Menu, InsertMenu, Add
Menu, InsertMenu, Add, %i_Lang010%`t%_s%F9, ComLoop
Menu, InsertMenu, Add, %i_Lang011%`t%_s%Shift+F9, ComGoto
Menu, InsertMenu, Add, %i_Lang012%`t%_s%Ctrl+F9, AddLabel
Menu, InsertMenu, Add
Menu, InsertMenu, Add, %i_Lang013%`t%_s%F10, IfSt
Menu, InsertMenu, Add, %i_Lang014%`t%_s%Shift+F10, AsVar
Menu, InsertMenu, Add, %i_Lang015%`t%_s%Ctrl+F10, AsFunc
Menu, InsertMenu, Add
Menu, InsertMenu, Add, %i_Lang016%`t%_s%F11, IECom
Menu, InsertMenu, Add, %i_Lang017%`t%_s%Shift+F11, ComInt
Menu, InsertMenu, Add, %i_Lang018%`t%_s%Ctrl+F11, RunScrLet
Menu, InsertMenu, Add
Menu, InsertMenu, Add, %i_Lang019%`t%_s%F12, SendMsg
Menu, InsertMenu, Add
Menu, InsertMenu, Add, %i_Lang020%`t%_s%Ctrl+Shift+F, CmdFind

TypesMenu := "Win`nFile`nString"
Loop
{
	If !(cType%A_Index%)
		break
	TypesMenu .= "`n" cType%A_Index%
}
Sort, TypesMenu
Loop, Parse, TypesMenu, `n
	Menu, SelCmdMenu, Add, %A_LoopField%, SelectCmd

Menu, SelectMenu, Add, %s_Lang001%`t%_s%Ctrl+A, SelectAll
Menu, SelectMenu, Add, %s_Lang002%`t%_s%Ctrl+Shift+A, SelectNone
Menu, SelectMenu, Add, %s_Lang003%`t%_s%Ctrl+Alt+A, InvertSel
Menu, SelectMenu, Add
Menu, SelectMenu, Add, %s_Lang004%`t%_s%Ctrl+Q, CheckSel
Menu, SelectMenu, Add, %s_Lang005%`t%_s%Ctrl+Shift+Q, UnCheckSel
Menu, SelectMenu, Add, %s_Lang006%`t%_s%Ctrl+Alt+Q, InvertCheck
Menu, SelectMenu, Add
Menu, SelectMenu, Add, %s_Lang007%, SelType
Menu, SelectMenu, Add, %s_Lang008%, :SelCmdMenu

Menu, CopyTo, Add, Macro1, CopyList

Menu, EditMenu, Add, %m_Lang004%`t%_s%Enter, EditButton
Menu, EditMenu, Add, %e_Lang001%`t%_s%Ctrl+D, Duplicate
Menu, EditMenu, Add, %e_Lang003%`t%_s%Ctrl+F, FindReplace
Menu, EditMenu, Add, %e_Lang002%`t%_s%Ctrl+L, EditComm
Menu, EditMenu, Add, %e_Lang014%`t%_s%Ctrl+M, EditColor
Menu, EditMenu, Default, %m_Lang004%`t%_s%Enter
Menu, EditMenu, Add
Menu, EditMenu, Add, %m_Lang002%, :InsertMenu
Menu, EditMenu, Add, %m_Lang003%, :SelectMenu
Menu, EditMenu, Add, %e_Lang004%, :CopyTo
Menu, EditMenu, Add
Menu, EditMenu, Add, %e_Lang005%`t%_s%Ctrl+Z, Undo
Menu, EditMenu, Add, %e_Lang006%`t%_s%Ctrl+Y, Redo
Menu, EditMenu, Add
Menu, EditMenu, Add, %e_Lang007%`t%_s%Ctrl+X, CutRows
Menu, EditMenu, Add, %e_Lang008%`t%_s%Ctrl+C, CopyRows
Menu, EditMenu, Add, %e_Lang009%`t%_s%Ctrl+V, PasteRows
Menu, EditMenu, Add, %e_Lang010%`t%_s%Delete, Remove
Menu, EditMenu, Add, %e_Lang013%`t%_s%Insert, ApplyL
Menu, EditMenu, Add
Menu, EditMenu, Add, %e_Lang011%`t%_s%Ctrl+PgUp, MoveUp
Menu, EditMenu, Add, %e_Lang012%`t%_s%Ctrl+PgDn, MoveDn

Menu, MacroMenu, Add, %r_Lang001%`t%_s%Ctrl+R, Record
Menu, MacroMenu, Add
Menu, MacroMenu, Add, %r_Lang002%`t%_s%Ctrl+Enter, PlayStart
Menu, MacroMenu, Add, %r_Lang003%`t%_s%Ctrl+Shift+Enter, TestRun
Menu, MacroMenu, Add, %r_Lang004%`t%_s%Ctrl+Shift+T, RunTimer
Menu, MacroMenu, Add
Menu, MacroMenu, Add, %r_lang011%`t%_s%Alt+1, PlayFrom
Menu, MacroMenu, Add, %r_lang012%`t%_s%Alt+2, PlayTo
Menu, MacroMenu, Add, %r_lang013%`t%_s%Alt+3, PlaySel
Menu, MacroMenu, Add
Menu, MacroMenu, Add, %r_lang010%`t%_s%Ctrl+H, SetWin
Menu, MacroMenu, Add
Menu, MacroMenu, Add, %r_Lang005%`t%_s%Ctrl+T, TabPlus
Menu, MacroMenu, Add, %r_Lang006%`t%_s%Ctrl+W, TabClose
Menu, MacroMenu, Add, %r_Lang007%`t%_s%Ctrl+Shift+D, DuplicateList
Menu, MacroMenu, Add
Menu, MacroMenu, Add, %r_Lang008%`t%_s%Ctrl+I, Import
Menu, MacroMenu, Add, %r_Lang009%`t%_s%Ctrl+Alt+S, SaveCurrentList

Menu, CustomMenu, Add, %v_lang009%, TbCustomize
Menu, CustomMenu, Add, %v_lang010%, TbCustomize
Menu, CustomMenu, Add, %v_lang011%, TbCustomize
Menu, CustomMenu, Add, %v_lang012%, TbCustomize
Menu, CustomMenu, Add, %v_lang013%, TbCustomize

Menu, ToolbarsMenu, Add, %v_lang009%, ShowHideBand
Menu, ToolbarsMenu, Add, %v_lang010%, ShowHideBand
Menu, ToolbarsMenu, Add, %v_lang011%, ShowHideBand
Menu, ToolbarsMenu, Add, %v_lang012%, ShowHideBand
Menu, ToolbarsMenu, Add, %v_lang013%, ShowHideBand
Menu, ToolbarsMenu, Add
Menu, ToolbarsMenu, Add, %v_lang014%, :CustomMenu
Menu, ToolbarsMenu, Add
Menu, ToolbarsMenu, Add, %v_lang019%, DefaultLayout

Menu, HotkeyMenu, Add, %v_lang015%, ShowHideBandHK
Menu, HotkeyMenu, Add, %v_lang016%, ShowHideBandHK
Menu, HotkeyMenu, Add, %v_lang017%, ShowHideBandHK
Menu, HotkeyMenu, Add, %v_lang018%, ShowHideBandHK

Menu, ViewMenu, Add, %v_lang001%, MainOnTop
Menu, ViewMenu, Add, %v_lang002%, ShowLoopIfMark
Menu, ViewMenu, Add, %v_lang003%, ShowActIdent
Menu, ViewMenu, Add
Menu, ViewMenu, Add, %v_lang004%`t%_s%Ctrl+B, OnScControls
Menu, ViewMenu, Add, %v_lang005%`t%_s%Ctrl+P, Preview
Menu, ViewMenu, Add, %v_lang006%, :ToolbarsMenu
Menu, ViewMenu, Add, %v_lang007%, :HotkeyMenu
Menu, ViewMenu, Add
Menu, ViewMenu, Add, %v_lang008%`t%_s%Alt+F5, SetColSizes

Loop, Parse, Lang_All, |
{
	LangTxt := SubStr(A_LoopField, -1)
	If IsLabel("LoadLang_" LangTxt)
		Menu, LangMenu, Add, % Lang_%LangTxt%, LangChange
}

Menu, OptionsMenu, Add, %o_Lang001%`t%_s%Ctrl+G, Options
Menu, OptionsMenu, Add, %m_Lang008%, :LangMenu
Menu, OptionsMenu, Add
Menu, OptionsMenu, Add, %o_Lang002%, KeepDefKeys
Menu, OptionsMenu, Add, %o_Lang003%, DefaultMacro
Menu, OptionsMenu, Add, %o_Lang004%, RemoveDefault
Menu, OptionsMenu, Add
Menu, OptionsMenu, Add, %o_Lang005%`t%_s%Alt+F6, DefaultHotkeys
Menu, OptionsMenu, Add, %o_Lang006%`t%_s%Alt+F7, LoadDefaults

Menu, HelpMenu, Add, %m_Lang010%`t%_s%F1, Help
Menu, HelpMenu, Add, %h_Lang006%, ShowTips
Menu, HelpMenu, Add
Menu, HelpMenu, Add, %h_Lang001%, Homepage
Menu, HelpMenu, Add, %h_Lang007%, Forum
Menu, HelpMenu, Add, %h_Lang002%, HelpAHK
Menu, HelpMenu, Add
Menu, HelpMenu, Add, %h_Lang003%, CheckNow
Menu, HelpMenu, Add, %h_Lang004%, AutoUpdate
Menu, HelpMenu, Add
Menu, HelpMenu, Add, %h_Lang005%`t%_s%Shift+F1, HelpAbout

Loop, Parse, Start_Tips, `n
{
	StartTip_%A_Index% := A_LoopField
	MaxTips := A_Index
}

Menu, DonationMenu, Add, %p_Lang001%, DonatePayPal

Menu, MenuBar, Add, %m_Lang001%, :FileMenu
Menu, MenuBar, Add, %m_Lang002%, :InsertMenu
Menu, MenuBar, Add, %m_Lang003%, :SelectMenu
Menu, MenuBar, Add, %m_Lang004%, :EditMenu
Menu, MenuBar, Add, %m_Lang005%, :MacroMenu
Menu, MenuBar, Add, %m_Lang006%, :ViewMenu
Menu, MenuBar, Add, %m_Lang007%, :OptionsMenu
Menu, MenuBar, Add, %m_Lang009%, :DonationMenu
Menu, MenuBar, Add, %m_Lang010%, :HelpMenu

Gui, Menu, MenuBar

Menu, ToolbarMenu, Add, %c_Lang022%, OSCClose
Menu, ToolbarMenu, Add, %t_Lang104%, ToggleTB
Menu, ToolbarMenu, Add, %t_Lang105%, ShowHide

Menu, Tray, Add, %w_Lang005%, PlayStart
Menu, Tray, Add, %w_Lang008%, f_AbortKey
Menu, Tray, Add, %w_Lang004%, Record
Menu, Tray, Add, %r_Lang004%, RunTimer
Menu, Tray, Add
Menu, Tray, Add, %w_Lang002%, Preview
Menu, Tray, Add, %f_Lang008%, ListVars
Menu, Tray, Add, %y_Lang003%, OnScControls
Menu, Tray, Add, %w_Lang014%, CheckHkOn
Menu, Tray, Add
Menu, Tray, Add, %f_Lang001%, New
Menu, Tray, Add, %f_Lang002%, Open
Menu, Tray, Add, %f_Lang003%, Save
Menu, Tray, Add, %w_Lang003%, Options
Menu, Tray, Add
Menu, Tray, Add, %y_Lang001%, ShowHide
Menu, Tray, Add, %f_Lang009%, Exit
Menu, Tray, Default, %w_Lang005%

If KeepDefKeys
	Menu, OptionsMenu, Check, %o_Lang002%
If AutoUpdate
	Menu, HelpMenu, Check, %h_Lang004%
If ShowLoopIfMark
	Menu, ViewMenu, Check, %v_lang002%
If ShowActIdent
	Menu, ViewMenu, Check, %v_lang003%
If ShowBarOnStart
{
	Menu, ViewMenu, Check, %v_lang004%`t%_s%Ctrl+B
	Menu, Tray, Check, %y_Lang003%
}
If ShowPrev
	Menu, ViewMenu, Check, %v_lang005%`t%_s%Ctrl+P
If ShowBand1
	Menu, ToolbarsMenu, Check, %v_lang009%
If ShowBand2
	Menu, ToolbarsMenu, Check, %v_lang010%
If ShowBand3
	Menu, ToolbarsMenu, Check, %v_lang011%
If ShowBand4
	Menu, HotkeyMenu, Check, %v_lang015%
If ShowBand5
	Menu, ToolbarsMenu, Check, %v_lang012%
If ShowBand6
	Menu, HotkeyMenu, Check, %v_lang016%
If ShowBand7
	Menu, HotkeyMenu, Check, %v_lang017%
If ShowBand8
	Menu, HotkeyMenu, Check, %v_lang018%
If ShowBand9
	Menu, ToolbarsMenu, Check, %v_lang013%

; Menu Icons
Menu, FileMenu, Icon, %f_Lang001%`t%_s%Ctrl+N, %ResDllPath%, 42
Menu, FileMenu, Icon, %f_Lang002%`t%_s%Ctrl+O, %ResDllPath%, 43
Menu, FileMenu, Icon, %f_Lang003%`t%_s%Ctrl+S, %ResDllPath%, 60
Menu, FileMenu, Icon, %f_Lang004%`t%_s%Ctrl+Shift+S, %ResDllPath%, 88
Menu, FileMenu, Icon, %f_Lang005%, %ResDllPath%, 53
Menu, FileMenu, Icon, %f_Lang006%`t%_s%Ctrl+E, %ResDllPath%, 16
Menu, FileMenu, Icon, %f_Lang007%`t%_s%Ctrl+P, %ResDllPath%, 50
Menu, FileMenu, Icon, %f_Lang008%`t%_s%Alt+F3, %ResDllPath%, 36
Menu, FileMenu, Icon, %f_Lang009%`t%_s%Alt+F4, %ResDllPath%, 15
Menu, InsertMenu, Icon, %i_Lang001%`t%_s%F2, %ResDllPath%, 39
Menu, InsertMenu, Icon, %i_Lang002%`t%_s%F3, %ResDllPath%, 71
Menu, InsertMenu, Icon, %i_Lang003%`t%_s%F4, %ResDllPath%, 7
Menu, InsertMenu, Icon, %i_Lang004%`t%_s%F5, %ResDllPath%, 46
Menu, InsertMenu, Icon, %i_Lang005%`t%_s%Shift+F5, %ResDllPath%, 11
Menu, InsertMenu, Icon, %i_Lang006%`t%_s%Ctrl+F5, %ResDllPath%, 78
Menu, InsertMenu, Icon, %i_Lang007%`t%_s%F6, %ResDllPath%, 81
Menu, InsertMenu, Icon, %i_Lang008%`t%_s%F7, %ResDllPath%, 28
Menu, InsertMenu, Icon, %i_Lang009%`t%_s%F8, %ResDllPath%, 59
Menu, InsertMenu, Icon, %i_Lang010%`t%_s%F9, %ResDllPath%, 37
Menu, InsertMenu, Icon, %i_Lang011%`t%_s%Shift+F9, %ResDllPath%, 22
Menu, InsertMenu, Icon, %i_Lang012%`t%_s%Ctrl+F9, %ResDllPath%, 35
Menu, InsertMenu, Icon, %i_Lang013%`t%_s%F10, %ResDllPath%, 27
Menu, InsertMenu, Icon, %i_Lang014%`t%_s%Shift+F10, %ResDllPath%, 76
Menu, InsertMenu, Icon, %i_Lang015%`t%_s%Ctrl+F10, %ResDllPath%, 21
Menu, InsertMenu, Icon, %i_Lang016%`t%_s%F11, %ResDllPath%, 26
Menu, InsertMenu, Icon, %i_Lang017%`t%_s%Shift+F11, %ResDllPath%, 4
Menu, InsertMenu, Icon, %i_Lang018%`t%_s%Ctrl+F11, %ResDllPath%, 77
Menu, InsertMenu, Icon, %i_Lang019%`t%_s%F12, %ResDllPath%, 62
Menu, InsertMenu, Icon, %i_Lang020%`t%_s%Ctrl+Shift+F, %ResDllPath%, 95
Menu, EditMenu, Icon, %m_Lang004%`t%_s%Enter, %ResDllPath%, 14
Menu, EditMenu, Icon, %e_Lang001%`t%_s%Ctrl+D, %ResDllPath%, 13
Menu, EditMenu, Icon, %e_Lang003%`t%_s%Ctrl+F, %ResDllPath%, 19
Menu, EditMenu, Icon, %e_Lang002%`t%_s%Ctrl+L, %ResDllPath%, 5
Menu, EditMenu, Icon, %e_Lang014%`t%_s%Ctrl+M, %ResDllPath%, 3
Menu, EditMenu, Icon, %e_Lang005%`t%_s%Ctrl+Z, %ResDllPath%, 75
Menu, EditMenu, Icon, %e_Lang006%`t%_s%Ctrl+Y, %ResDllPath%, 57
Menu, EditMenu, Icon, %e_Lang007%`t%_s%Ctrl+X, %ResDllPath%, 9
Menu, EditMenu, Icon, %e_Lang008%`t%_s%Ctrl+C, %ResDllPath%, 8
Menu, EditMenu, Icon, %e_Lang009%`t%_s%Ctrl+V, %ResDllPath%, 45
Menu, EditMenu, Icon, %e_Lang010%`t%_s%Delete, %ResDllPath%, 10
Menu, EditMenu, Icon, %e_Lang013%`t%_s%Insert, %ResDllPath%, 32
Menu, EditMenu, Icon, %e_Lang011%`t%_s%Ctrl+PgUp, %ResDllPath%, 41
Menu, EditMenu, Icon, %e_Lang012%`t%_s%Ctrl+PgDn, %ResDllPath%, 40
Menu, MacroMenu, Icon, %r_Lang001%`t%_s%Ctrl+R, %ResDllPath%, 55
Menu, MacroMenu, Icon, %r_Lang002%`t%_s%Ctrl+Enter, %ResDllPath%, 47
Menu, MacroMenu, Icon, %r_Lang003%`t%_s%Ctrl+Shift+Enter, %ResDllPath%, 49
Menu, MacroMenu, Icon, %r_lang010%`t%_s%Ctrl+H, %ResDllPath%, 48
Menu, MacroMenu, Icon, %r_Lang004%`t%_s%Ctrl+Shift+T, %ResDllPath%, 72
Menu, MacroMenu, Icon, %r_Lang005%`t%_s%Ctrl+T, %ResDllPath%, 67
Menu, MacroMenu, Icon, %r_Lang006%`t%_s%Ctrl+W, %ResDllPath%, 69
Menu, MacroMenu, Icon, %r_Lang007%`t%_s%Ctrl+Shift+D, %ResDllPath%, 70
Menu, MacroMenu, Icon, %r_Lang008%`t%_s%Ctrl+I, %ResDllPath%, 29
Menu, MacroMenu, Icon, %r_Lang009%`t%_s%Ctrl+Alt+S, %ResDllPath%, 68
Menu, OptionsMenu, Icon, %o_Lang001%`t%_s%Ctrl+G, %ResDllPath%, 44
Menu, HelpMenu, Icon, %m_Lang010%`t%_s%F1, %ResDllPath%, 24
Menu, DonationMenu, Icon, %p_Lang001%, %ResDllPath%, 12
Menu, Tray, Icon, %w_Lang005%, %ResDllPath%, 47
Menu, Tray, Icon, %w_Lang008%, %ResDllPath%, 66
Menu, Tray, Icon, %w_Lang004%, %ResDllPath%, 55
Menu, Tray, Icon, %r_Lang004%, %ResDllPath%, 72
Menu, Tray, Icon, %w_Lang002%, %ResDllPath%, 50
Menu, Tray, Icon, %f_Lang008%, %ResDllPath%, 36
Menu, Tray, Icon, %f_Lang001%, %ResDllPath%, 42
Menu, Tray, Icon, %f_Lang002%, %ResDllPath%, 43
Menu, Tray, Icon, %f_Lang003%, %ResDllPath%, 60
Menu, Tray, Icon, %w_Lang003%, %ResDllPath%, 44
Menu, Tray, Icon, %f_Lang009%, %ResDllPath%, 15
return

; Playback / Recording options menu:

ShowRecMenu:
Menu, RecOptMenu, Add, %d_Lang019%, RecOpt
Menu, RecOptMenu, Add
Menu, RecOptMenu, Add, %t_Lang021%, RecOpt
Menu, RecOptMenu, Add, %t_Lang023%, RecOpt
Menu, RecOptMenu, Add, %t_Lang031%, RecOpt
Menu, RecOptMenu, Add
Menu, RecOptMenu, Add, %t_Lang024%, RecOpt
Menu, RecOptMenu, Add, %t_Lang025%, RecOpt
Menu, RecOptMenu, Add, %t_Lang026%, RecOpt
Menu, RecOptMenu, Add, %t_Lang032%, RecOpt
Menu, RecOptMenu, Add
Menu, RecOptMenu, Add, %t_Lang027%, RecOpt
Menu, RecOptMenu, Add, %t_Lang029%, RecOpt
Menu, RecOptMenu, Add, %t_Lang030%, RecOpt

If (ClearNewList)
	Menu, RecOptMenu, Check, %d_Lang019%
If (Strokes)
	Menu, RecOptMenu, Check, %t_Lang021%
If (CaptKDn)
	Menu, RecOptMenu, Check, %t_Lang023%
If (Mouse)
	Menu, RecOptMenu, Check, %t_Lang024%
If (MScroll)
	Menu, RecOptMenu, Check, %t_Lang025%
If (Moves)
	Menu, RecOptMenu, Check, %t_Lang026%
If (TimedI)
	Menu, RecOptMenu, Check, %t_Lang027%
If (WClass)
	Menu, RecOptMenu, Check, %t_Lang029%
If (WTitle)
	Menu, RecOptMenu, Check, %t_Lang030%
If (RecMouseCtrl)
	Menu, RecOptMenu, Check, %t_Lang032%
If (RecKeybdCtrl)
	Menu, RecOptMenu, Check, %t_Lang031%

Menu, RecOptMenu, Show, %mX%, %mY%
Menu, RecOptMenu, DeleteAll
mX := "", mY := ""
return

RecOpt:
ItemVar := RecOptChecks[A_ThisMenuItemPos], %ItemVar% := !%ItemVar%
return

ShowPlayMenu:
Menu, SpeedUpMenu, Add, 2x, SpeedOpt
Menu, SpeedUpMenu, Add, 4x, SpeedOpt
Menu, SpeedUpMenu, Add, 8x, SpeedOpt
Menu, SpeedUpMenu, Add, 16x, SpeedOpt
Menu, SpeedUpMenu, Add, 32x, SpeedOpt
Menu, SpeedDnMenu, Add, 2x, SpeedOpt
Menu, SpeedDnMenu, Add, 4x, SpeedOpt
Menu, SpeedDnMenu, Add, 8x, SpeedOpt
Menu, SpeedDnMenu, Add, 16x, SpeedOpt
Menu, SpeedDnMenu, Add, 32x, SpeedOpt
Menu, PlayOptMenu, Add, %r_lang011%, PlayFrom
Menu, PlayOptMenu, Add, %r_lang012%, PlayTo
Menu, PlayOptMenu, Add, %r_lang013%, PlaySel
Menu, PlayOptMenu, Add
Menu, PlayOptMenu, Add, %t_Lang038%, PlayOpt
Menu, PlayOptMenu, Add, %t_Lang107%, RandOpt
Menu, PlayOptMenu, Add
Menu, PlayOptMenu, Add, %t_Lang036%, :SpeedUpMenu
Menu, PlayOptMenu, Add, %t_Lang037%, :SpeedDnMenu

If (pb_From)
	Menu, PlayOptMenu, Check, %r_lang011%
If (pb_To)
	Menu, PlayOptMenu, Check, %r_lang012%
If (pb_Sel)
	Menu, PlayOptMenu, Check, %r_lang013%
If (MouseReturn)
	Menu, PlayOptMenu, Check, %t_Lang038%
If (RandomSleeps)
	Menu, PlayOptMenu, Check, %t_Lang107%
Menu, SpeedUpMenu, Check, %SpeedUp%x
Menu, SpeedDnMenu, Check, %SpeedDn%x

Menu, PlayOptMenu, Show, %mX%, %mY%
Menu, PlayOptMenu, DeleteAll
Menu, SpeedUpMenu, DeleteAll
Menu, SpeedDnMenu, DeleteAll
mX := "", mY := ""
return

RandOpt:
RandomSleeps := !RandomSleeps
return

PlayOpt:
MouseReturn := !MouseReturn
return

SpeedOpt:
ItemVar := SubStr(A_ThisMenu, 1, 7), %ItemVar% := RegExReplace(A_ThisMenuItem, "\D")
return

OnFinish:
TB_Edit(TbSettings, "OnFinish", (OnFinishCode = 1) ? 0 : 1)
Menu, OnFinish, Add, %w_Lang021%, FinishOpt
Menu, OnFinish, Add, %w_Lang022%, FinishOpt
Menu, OnFinish, Add, %w_Lang023%, FinishOpt
Menu, OnFinish, Add, %w_Lang024%, FinishOpt
Menu, OnFinish, Add, %w_Lang025%, FinishOpt
Menu, OnFinish, Add, %w_Lang026%, FinishOpt
Menu, OnFinish, Add, %w_Lang027%, FinishOpt
Menu, OnFinish, Add, %w_Lang028%, FinishOpt
Menu, OnFinish, Add, %w_Lang029%, FinishOpt

Menu, OnFinish, Check, % w_Lang02%OnFinishCode%

Menu, OnFinish, Show, %mX%, %mY%
Menu, OnFinish, DeleteAll
return

FinishOpt:
OnFinishCode := A_ThisMenuItemPos
SetFinishButtom:
TB_Edit(TbSettings, "OnFinish", (OnFinishCode = 1) ? 0 : 1)
return

;##### Languages: #####

LangChange:
Loop, Parse, Lang_All, |
{
	If InStr(A_LoopField, A_ThisMenuItem)=1
		Lang := SubStr(A_LoopField, -1)
}
If (Lang = CurrentLang)
	return
If !IsLabel("LoadLang_" Lang)
	return
Gui, Menu
Menu, MenuBar, DeleteAll
Menu, FileMenu, DeleteAll
Menu, InsertMenu, DeleteAll
Menu, SelectMenu, DeleteAll
Menu, SelCmdMenu, DeleteAll
Menu, EditMenu, DeleteAll
Menu, MacroMenu, DeleteAll
Menu, CustomMenu, DeleteAll
Menu, ToolbarsMenu, DeleteAll
Menu, HotkeyMenu, DeleteAll
Menu, ViewMenu, DeleteAll
Menu, OptionsMenu, DeleteAll
Menu, DonationMenu, DeleteAll
Menu, LangMenu, DeleteAll
Menu, HelpMenu, DeleteAll
Menu, ToolbarMenu, DeleteAll
Menu, Tray, DeleteAll
GoSub, LoadLang
GoSub, CreateMenuBar
Menu, LangMenu, Uncheck, % Lang_%CurrentLang%
Menu, LangMenu, Check, % Lang_%Lang%
CurrentLang := Lang

Gui, chMacro:Default
Loop, %TabCount%
{
	Gui, chMacro:ListView, InputList%A_Index%
	Loop, % LV_GetCount("Col")
		colTx := "w_Lang0" 29 + A_Index, LV_ModifyCol(A_Index, "", %colTx%)
}
Gui, chMacro:ListView, InputList%A_List%

GuiControl, 1:, Repeat, %w_Lang015%:
GuiControl, 1:, DelayT, %w_Lang016%
GuiControl, 1:-Redraw, cRbMain
RbMain.ModifyBand(RbMain.IDToIndex(4), "Text", w_Lang006)
, RbMain.ModifyBand(RbMain.IDToIndex(11), "Text", w_Lang011 " (" t_Lang004 ")")
, RbMain.ModifyBand(RbMain.IDToIndex(6), "Text", w_Lang007)
, RbMain.ModifyBand(RbMain.IDToIndex(7), "Text", w_Lang008)
, RbMain.ModifyBand(RbMain.IDToIndex(8), "Text", c_Lang003)
; File
TB_Edit(tbFile, "New", "", "", w_Lang040)
, TB_Edit(tbFile, "Open", "", "", w_Lang041) , TB_Edit(tbFile, "Save", "", "", w_Lang042) 
, TB_Edit(tbFile, "Export", "", "", w_Lang043), TB_Edit(tbFile, "Preview", "", "", w_Lang044), TB_Edit(tbFile, "Options", "", "", w_Lang045)
; RecPlay
TB_Edit(tbRecPlay, "Record", "", "", w_Lang046)
, TB_Edit(tbRecPlay, "PlayStart", "", "", w_Lang047), TB_Edit(tbRecPlay, "TestRun", "", "", w_Lang048), TB_Edit(tbRecPlay, "RunTimer", "", "", w_Lang049)
; Command
TB_Edit(tbCommand, "Mouse", "", "", w_Lang050), TB_Edit(tbCommand, "Text", "", "", w_Lang051), TB_Edit(tbCommand, "ControlCmd", "", "", w_Lang053)
, TB_Edit(tbCommand, "Pause", "", "", w_Lang054), TB_Edit(tbCommand, "MsgBox", "", "", w_Lang055), TB_Edit(tbCommand, "KeyWait", "", "", w_Lang056)
, TB_Edit(tbCommand, "Window", "", "", w_Lang057), TB_Edit(tbCommand, "Image", "", "", w_Lang058), TB_Edit(tbCommand, "Run", "", "", w_Lang059)
, TB_Edit(tbCommand, "ComLoop", "", "", w_Lang060), TB_Edit(tbCommand, "ComGoto", "", "", w_Lang061), TB_Edit(tbCommand, "AddLabel", "", "", w_Lang062)
, TB_Edit(tbCommand, "IfSt", "", "", w_Lang063), TB_Edit(tbCommand, "AsVar", "", "", w_Lang064), TB_Edit(tbCommand, "AsFunc", "", "", w_Lang065)
, TB_Edit(tbCommand, "IECom", "", "", w_Lang066), TB_Edit(tbCommand, "ComInt", "", "", w_Lang067), TB_Edit(tbCommand, "RunScrLet", "", "", w_Lang068)
, TB_Edit(tbCommand, "SendMsg", "", "", w_Lang069)
, TB_Edit(tbCommand, "CmdFind", "", "", w_Lang091)
; Settings
TB_Edit(tbSettings, "HideMainWin", "", "", w_Lang013), TB_Edit(tbSettings, "OnScCtrl", "", "", w_Lang009)
, TB_Edit(tbSettings, "Capt", "", "", w_Lang012), TB_Edit(tbSettings, "CheckHkOn", "", "", w_Lang014)
, TB_Edit(tbSettings, "OnFinish", "", "", w_Lang020) , TB_Edit(tbSettings, "SetWin", "", "", t_Lang009)
, TB_Edit(tbSettings, "WinKey", "", "", w_Lang070), TB_Edit(tbSettings, "SetJoyButton", "", "", w_Lang071)
; Edit
TB_Edit(tbEdit, "TabPlus", "", "", w_Lang072), TB_Edit(tbEdit, "TabClose", "", "", w_Lang073), TB_Edit(tbEdit, "DuplicateList", "", "", w_Lang074)
, TB_Edit(tbEdit, "Import", "", "", w_Lang075), TB_Edit(tbEdit, "SaveCurrentList", "", "", w_Lang076)
, TB_Edit(tbEdit, "MoveUp", "", "", w_Lang077), TB_Edit(tbEdit, "MoveDn", "", "", w_Lang078)
, TB_Edit(tbEdit, "CutRows", "", "", w_Lang080), TB_Edit(tbEdit, "CopyRows", "", "", w_Lang081), TB_Edit(tbEdit, "PasteRows", "", "", w_Lang082), TB_Edit(tbEdit, "Remove", "", "", w_Lang083)
, TB_Edit(tbEdit, "Undo", "", "", w_Lang084), TB_Edit(tbEdit, "Redo", "", "", w_Lang085)
, TB_Edit(tbEdit, "Duplicate", "", "", w_Lang079), TB_Edit(tbEdit, "CopyTo", "", "", w_Lang086) 
, TB_Edit(tbEdit, "EditColor", "", "", w_Lang089), TB_Edit(tbEdit, "EditComm", "", "", w_Lang088), TB_Edit(tbEdit, "FindReplace", "", "", w_Lang087)
; Preview
TB_Edit(tbPrev, "PrevDock", "", "", t_Lang124)
, TB_Edit(tbPrev, "PrevCopy", "", "", c_Lang023), TB_Edit(tbPrev, "PrevRefresh", "", "", t_Lang014)
, TB_Edit(tbPrev, "AutoRefresh", "", "", t_Lang015), TB_Edit(tbPrev, "OnTop", "", "", t_Lang016), TB_Edit(tbPrev, "TabIndent", "", "", t_Lang011)
, TB_Edit(tbPrev, "EditScript", "", "", t_Lang138)
, TB_Edit(tbPrevF, "PrevDock", "", "", t_Lang125)
, TB_Edit(tbPrevF, "PrevCopy", "", "", c_Lang023), TB_Edit(tbPrevF, "PrevRefresh", "", "", t_Lang014)
, TB_Edit(tbPrevF, "AutoRefresh", "", "", t_Lang015), TB_Edit(tbPrevF, "OnTop", "", "", t_Lang016), TB_Edit(tbPrevF, "TabIndent", "", "", t_Lang011)
, TB_Edit(tbPrevF, "EditScript", "", "", t_Lang138)
; OSC
TB_Edit(tbOSC, "OSPlay", "", "", t_Lang112), TB_Edit(tbOSC, "OSStop", "", "", t_Lang113), TB_Edit(tbOSC, "ShowPlayMenu", "", "", t_Lang114)
, TB_Edit(tbOSC, "RecStart", "", "", t_Lang115), TB_Edit(tbOSC, "RecStartNew", "", "", t_Lang116), TB_Edit(tbOSC, "ShowRecMenu", "", "", t_Lang117)
, TB_Edit(tbOSC, "OSClear", "", "", t_Lang118)
, TB_Edit(tbOSC, "ProgBarToggle", "", "", t_Lang119)
, TB_Edit(tbOSC, "SlowKeyToggle", "", "", t_Lang120), TB_Edit(tbOSC, "FastKeyToggle", "", "", t_Lang121)
, TB_Edit(tbOSC, "ToggleTB", "", "", t_Lang122), TB_Edit(tbOSC, "ShowHideTB", "", "", t_Lang123)

FixedBar.Text := ["OpenT=" t_Lang126 ":43", "SaveT=" t_Lang127 ":60"
				, "", "CutT=" t_Lang128 ":9", "CopyT=" t_Lang129 ":8", "PasteT=" t_Lang130 ":45"
				, "", "SelAllT=" t_Lang131 ":5", "RemoveT=" t_Lang132 ":10"]
GuiControl, 1:+Redraw, cRbMain

Gui 18:+LastFoundExist
IfWinExist
    GoSub, FindReplace
Gui 26:+LastFoundExist
IfWinExist
    GoSub, TipClose
GoSub, SetFindCmd
return

LoadLang:
If IsLabel("LoadLang_" Lang)
	GoSub, LoadLang_%Lang%
Else
{
	Lang = En
	GoSub, LoadLang_En
}
return

;##### Command Search: #####
SetFindCmd:
Type_Keywords := "
(Join`,
" cType4 "
" cType5 "
" cType6 "
" cType7 "
" cType15 "
" cType16 "
" cType18 "
" cType19 "
" cType20 "
" cType21 "
" cType29 "
" cType30 "
" cType35 "
" cType36 "
" cType37 "
" cType38 "
" cType39 "
" cType40 "
" cType41 "
" cType42 "
" cType43 "
InternetExplorer
COM Interface
)"
,	Types_Path := "
(
" w_Lang050 "
" w_Lang054 "
" w_Lang055 "
" w_Lang060 "
" w_Lang058 "
" w_Lang058 "
" w_Lang069 "
" w_Lang069 "
" w_Lang056 "
" w_Lang064 "
" w_Lang060 "
" w_Lang060 "
" w_Lang062 "
" w_Lang061 "
" w_Lang061 "
" w_Lang060 "
" w_Lang060 "
" w_Lang060 "
" w_Lang060 "
" w_Lang068 "
" w_Lang068 "
" w_Lang066 "
" w_Lang067 "
)"
,	Types_Goto := "
(
Mouse
Pause
MsgBox
ComLoop
Image
Image
SendMsg
SendMsg
KeyWait
AsVar
ComLoop
ComLoop
AddLabel
ComGoto
ComGoto
ComLoop
ComLoop
ComLoop
ComLoop
RunScrLet
RunScrLet
IECom
ComInt
)"
Loop, Parse, Types_Path, `n
	Type%A_Index%_Path := A_LoopField
Loop, Parse, Types_Goto, `n
	Type%A_Index%_Goto := A_LoopField

Text_Keywords := "
(Join`,
" cType1 "
" cType2 "
" cType8 "
" cType9 "
" cType10 "
" cType12 "
" cType22 "
)"
,	Text_Path := w_Lang051, Text_Goto := "Text"

Mouse_Keywords := "
(Join`,
)"
While, Action%A_Index%
	Mouse_Keywords .= Action%A_Index% ","
Mouse_Path := w_Lang050, Mouse_Goto := "Mouse"

Ctrl_Keywords := RegExReplace(CtrlCmdList, "\|", ",") ","
.	RegExReplace(CtrlCmd, "\|", ",") ","
.	RegExReplace(CtrlGetCmd, "\|", ",")
,	Ctrl_Path := w_Lang053, Ctrl_Goto := "ControlCmd"

Win_Keywords := RegExReplace(WinCmdList, "\|", ",") ","
.	RegExReplace(WinCmd, "\|", ",") ","
.	RegExReplace(WinGetCmd, "\|", ",")
,	Win_Path := w_Lang057, Win_Goto := "Window"

Misc_Keywords := RegExReplace(FileCmdList, "\|", ",")
,	Misc_Path := w_Lang059, Misc_Goto := "Run"

If_Keywords := RegExReplace(IfList, "\$", ",")
,	If_Path := w_Lang063, If_Goto := "IfSt"

IE_Keywords := RegExReplace(IECmdList, "\|", ",")
,	IE_Path := w_Lang066, IE_Goto := "IECom"

Com_Keywords := RegExReplace(CLSList, "\|", ",")
,	Com_Path := w_Lang067, Com_Goto := "ComInt"

Func_Keywords := RegExReplace(BuiltinFuncList, "\$", ",")
,	Func_Path := w_Lang065, Func_Goto := "AsFunc"
return

#Include <Hotkeys>
#Include <Internal>
#Include <Recording>
#Include <Playback>
#Include <Export>
#Include <Class_PMC>
#Include <Class_Toolbar>
#Include <Class_Rebar>
#Include <Class_LV_Rows>
#Include <Class_ObjIni>
#Include <Gdip>
#Include <Eval>
#Include <Class_LV_Colors>
#Include <SCI>
#SingleInstance Off

#Include Lang\Id.lang
#Include Lang\Ms.lang
#Include Lang\Ca.lang
#Include Lang\Da.lang
#Include Lang\De.lang
#Include Lang\En.lang
#Include Lang\Es.lang
#Include Lang\Fr.lang
#Include Lang\Hr.lang
#Include Lang\It.lang
#Include Lang\Hu.lang
#Include Lang\Nl.lang
#Include Lang\No.lang
#Include Lang\Pl.lang
#Include Lang\Pt.lang
#Include Lang\Sl.lang
#Include Lang\Sk.lang
#Include Lang\Fi.lang
#Include Lang\Sv.lang
#Include Lang\Vi.lang
#Include Lang\Tr.lang
#Include Lang\Cs.lang
#Include Lang\El.lang
#Include Lang\Bg.lang
#Include Lang\Ru.lang
#Include Lang\Sr.lang
#Include Lang\Uk.lang
#Include Lang\Zh.lang
#Include Lang\Zt.lang
#Include Lang\Ja.lang
#Include Lang\Ko.lang
