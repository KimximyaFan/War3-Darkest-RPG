library BuffStatFrame

globals
    private integer buff_button
    private integer buff_box
    private integer array buff_text[4]
    private integer array buff_value[4]
    
    private boolean is_box_on = false
endglobals

function Buff_Button_Show takes nothing returns nothing
    call DzFrameShow(buff_button, true)
endfunction

// 껐다 켰다 
private function Button_Clicked takes nothing returns nothing
    if is_box_on == true then
        set is_box_on = false
        call DzFrameShow(buff_box, false)
    else
        set is_box_on = true
        call DzFrameShow(buff_box, true)
    endif
endfunction

private function Buff_Value_Refresh takes nothing returns nothing
    local integer pid

    set pid = -1
    loop
    set pid = pid + 1
    exitwhen pid > 5
        if GetLocalPlayer() == Player(pid) then
            call DzFrameSetText(buff_value[0], I2S(exp_rate[pid]) + "%" )
            call DzFrameSetText(buff_value[1], I2S(gold_drop_rate[pid]) + "%" )
            call DzFrameSetText(buff_value[2], I2S(item_drop_rate[pid]) + "%" )
            call DzFrameSetText(buff_value[3], I2S(potion_increase) )
            set POTION_LIMIT = POTION_LIMIT + potion_increase
        endif
    endloop
endfunction

private function Box_And_Inner_Frame takes nothing returns nothing
    local real x = 0.02
    local real y = -0.03
    local integer i
    local string array str
    
    set str[0] = "경험치 획득 증가    : "
    set str[1] = "골드 획득 증가      : "
    set str[2] = "아이템 드롭 증가    : "
    set str[3] = "최대 포션 갯수 증가 : "
    
    set buff_box = DzCreateFrameByTagName("BACKDROP", "", buff_button, "EscMenuBackdrop", 0)
    call DzFrameSetPoint(buff_box, JN_FRAMEPOINT_CENTER, buff_button, JN_FRAMEPOINT_CENTER, 0.025, 0.08)
    call DzFrameSetSize(buff_box, 0.20, 0.13)
    call DzFrameShow(buff_box, false)
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 3
        set buff_text[i] = DzCreateFrameByTagName("TEXT", "", buff_box, "TeamLabelTextTemplate", 0)
        call DzFrameSetPoint(buff_text[i], JN_FRAMEPOINT_TOPLEFT, buff_box, JN_FRAMEPOINT_TOPLEFT, x, y - i * 0.02)
        call DzFrameSetText(buff_text[i], str[i] )
        
        set buff_value[i] = DzCreateFrameByTagName("TEXT", "", buff_box, "", 0)
        call DzFrameSetPoint(buff_value[i], JN_FRAMEPOINT_LEFT, buff_text[i], JN_FRAMEPOINT_RIGHT, 0.015, 0.0)
        call DzFrameSetText(buff_value[i], I2S(0) + "%" )
    endloop
endfunction

private function Button_Frame takes nothing returns nothing
    set buff_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", DzGetGameUI(), "ScriptDialogButton", 0)
    call DzFrameSetPoint(buff_button, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, -0.31, -0.16)
    call DzFrameSetSize(buff_button, 0.06, 0.040)
    call DzFrameSetText(buff_button, "버프")
    call DzFrameSetScriptByCode(buff_button, JN_FRAMEEVENT_CONTROL_CLICK, function Button_Clicked, false)
    call DzFrameShow(buff_button, false)
endfunction

function Buff_Stat_Frame_Init takes nothing returns nothing
    call Button_Frame()
    call Box_And_Inner_Frame()
    call Buff_Value_Refresh()
endfunction

endlibrary