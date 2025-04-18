library StatButtonAndBox 

globals
    boolean isStat = false
    integer stat_button
    private integer x_button
    
    integer stat_box
endglobals

function Stat_Button_Show takes nothing returns nothing
    call DzFrameShow(stat_button, true)
endfunction

// 인벤 박스 껐다 켰다 
private function Stat_Button_Clicked takes nothing returns nothing
    if isStat == true then
        set isStat = false
        call DzFrameShow(stat_box, false)
    else
        set isStat = true
        call DzFrameShow(stat_box, true)
    endif
endfunction

// 끄기 버튼
private function Stat_X_Button takes nothing returns nothing
    set x_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", stat_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(x_button, JN_FRAMEPOINT_TOPRIGHT, stat_box, JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetSize(x_button, 0.032, 0.032)
    call DzFrameSetText(x_button, "X")
    call DzFrameSetScriptByCode(x_button, JN_FRAMEEVENT_CONTROL_CLICK, function Stat_Button_Clicked, false)
endfunction

// 스탯 백드롭
private function Stat_Box takes nothing returns nothing
    set stat_box = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "QuestButtonBaseTemplate", 0)
    call DzFrameSetPoint(stat_box, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, -0.235, 0.07)
    call DzFrameSetSize(stat_box, 0.31, 0.30)
    call DzFrameShow(stat_box, false)
endfunction

// 스탯 버튼
private function Stat_Button takes nothing returns nothing
    set stat_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", DzGetGameUI(), "ScriptDialogButton", 0)
    call DzFrameSetPoint(stat_button, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, -0.24, -0.21)
    call DzFrameSetSize(stat_button, 0.06, 0.040)
    call DzFrameSetText(stat_button, "스탯")
    call DzFrameSetScriptByCode(stat_button, JN_FRAMEEVENT_CONTROL_CLICK, function Stat_Button_Clicked, false)
    call DzFrameShow(stat_button, false)
endfunction

function Stat_Button_And_Box_Init takes nothing returns nothing
    call Stat_Button()
    call Stat_Box()
    call Stat_X_Button()
endfunction

endlibrary