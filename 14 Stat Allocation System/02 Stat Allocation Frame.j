library StatAllocationFrame requires StatAllocationController

globals
    private boolean is_open = false
    private integer stat_alloc_button
    private integer stat_alloc_box
    private integer x_button
    
    private integer array property_tip_back
    private integer array property_tip_text
    private integer array property_text_back
    private integer array property_text
    private integer array property_value_back
    integer array property_value_text
    private integer array property_button
    
    private integer stat_point_back
    private integer stat_point_text
    private integer stat_point_value_back
    integer stat_point_value_text
    
    private string array property_name
    private string array property_explain
endglobals

// =====================================================
// API
// =====================================================

function Stat_Alloc_Button_Show takes nothing returns nothing
    call DzFrameShow(stat_alloc_button, true)
endfunction

function Stat_Alloc_Box_Off takes nothing returns nothing
    set is_open = false
    call DzFrameShow(stat_alloc_box, false)
endfunction



// ===========================================================
// Interaction
// ===========================================================

private function Increase_Button_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId( DzGetTriggerUIEventPlayer() )
    local integer index = S2I( JNStringSplit( DzFrameGetName( DzGetTriggerUIEventFrame() ), "/", 1 ) )
    
    call Stat_Alloc_Increase_Interaction(pid, index)
endfunction

private function Tool_Tip_Leave takes nothing returns nothing
    local integer index = S2I( JNStringSplit( DzFrameGetName( DzGetTriggerUIEventFrame() ), "/", 1 ) )
    call DzFrameShow(property_tip_back[index], false)
endfunction

private function Tool_Tip_Enter takes nothing returns nothing
    local integer index = S2I( JNStringSplit( DzFrameGetName( DzGetTriggerUIEventFrame() ), "/", 1 ) )
    call DzFrameShow(property_tip_back[index], true)
endfunction

private function Basic_Button_Clicked takes nothing returns nothing
    if is_open == true then
        set is_open = false
        call DzFrameShow(stat_alloc_box, false)
    else
        set is_open = true
        call DzFrameShow(stat_alloc_box, true)
    endif
endfunction

// =======================================================================
// Frame
// =======================================================================

private function Stat_Alloc_Text_Preprocess takes nothing returns nothing
    set property_name[0] = "공격증가"
    set property_name[1] = "주문증가"
    set property_name[2] = "공속증가"
    set property_name[3] = "이속증가"
    set property_name[4] = "체력증가"
    set property_name[5] = "마나증가"
    set property_name[6] = "물방증가"
    set property_name[7] = "마방증가"
    set property_name[8] = "체회증가"
    set property_name[9] = "마회증가"
    
    set property_explain[0] = "1 포인트당\n공격력 0.5 증가"
    set property_explain[1] = "1 포인트당\n주문력 1 증가"
    set property_explain[2] = "1 포인트당\n공격속도 0.33 증가"
    set property_explain[3] = "1 포인트당\n이동속도 0.25 증가"
    set property_explain[4] = "1 포인트당\n체력 15 증가"
    set property_explain[5] = "1 포인트당\n마나 3 증가"
    set property_explain[6] = "1 포인트당\n물리방어력 0.5 증가"
    set property_explain[7] = "1 포인트당\n마법방어력 0.5 증가"
    set property_explain[8] = "1 포인트당\n체력회복 0.5 증가"
    set property_explain[9] = "1 포인트당\n마나회복 0.2 증가"
endfunction

private function Stat_Alloc_Control_Frame takes nothing returns nothing
    local real x = 0.02
    local real y = -0.02
    local integer i
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= 10
        set property_text_back[i] = DzCreateFrameByTagName("BACKDROP", "", stat_alloc_box, "ScoreScreenButtonBackdropTemplate", 0)
        call DzFrameSetPoint(property_text_back[i], JN_FRAMEPOINT_TOPLEFT, stat_alloc_box, JN_FRAMEPOINT_TOPLEFT, x, y - 0.033 * i)
        call DzFrameSetSize(property_text_back[i], 0.07, 0.03)
        set property_text[i] = DzCreateFrameByTagName("TEXT", "pt/" + I2S(i), property_text_back[i], "", 0)
        call DzFrameSetPoint(property_text[i], JN_FRAMEPOINT_CENTER, property_text_back[i], JN_FRAMEPOINT_CENTER, 0.0, 0.0)
        call DzFrameSetText(property_text[i], "|cffffcc00" + property_name[i] + "|r" )
        call DzFrameSetScriptByCode(property_text[i], JN_FRAMEEVENT_MOUSE_ENTER, function Tool_Tip_Enter, false)
        call DzFrameSetScriptByCode(property_text[i], JN_FRAMEEVENT_MOUSE_LEAVE, function Tool_Tip_Leave, false)
        
        set property_value_back[i] = DzCreateFrameByTagName("BACKDROP", "", property_text_back[i], "ScoreScreenButtonBackdropTemplate", 0)
        call DzFrameSetPoint(property_value_back[i], JN_FRAMEPOINT_LEFT, property_text_back[i], JN_FRAMEPOINT_RIGHT, 0.01, 0)
        call DzFrameSetSize(property_value_back[i], 0.04, 0.03)
        set property_value_text[i] = DzCreateFrameByTagName("TEXT", "pvt/" + I2S(i), property_value_back[i], "", 0)
        call DzFrameSetPoint(property_value_text[i], JN_FRAMEPOINT_CENTER, property_value_back[i], JN_FRAMEPOINT_CENTER, 0.0, 0.0)
        call DzFrameSetText(property_value_text[i], "0")
        call DzFrameSetScriptByCode(property_text[i], JN_FRAMEEVENT_MOUSE_ENTER, function Tool_Tip_Enter, false)
        call DzFrameSetScriptByCode(property_text[i], JN_FRAMEEVENT_MOUSE_LEAVE, function Tool_Tip_Leave, false)

        set property_button[i] = DzCreateFrameByTagName("GLUETEXTBUTTON", "pb/" + I2S(i), property_value_back[i], "ScriptDialogButton", 0)
        call DzFrameSetPoint(property_button[i], JN_FRAMEPOINT_LEFT, property_value_back[i], JN_FRAMEPOINT_RIGHT, 0.03, 0)
        call DzFrameSetSize(property_button[i], 0.05, 0.035)
        call DzFrameSetText(property_button[i], "증가")
        call DzFrameSetScriptByCode(property_button[i], JN_FRAMEEVENT_CONTROL_CLICK, function Increase_Button_Clicked, false)
        
        set property_tip_back[i] = DzCreateFrameByTagName("BACKDROP", "", stat_alloc_box, "ScoreScreenButtonBackdropTemplate", 0)
        call DzFrameSetPoint(property_tip_back[i], JN_FRAMEPOINT_CENTER, property_text[i], JN_FRAMEPOINT_CENTER, 0.00, 0.02)
        call DzFrameSetSize(property_tip_back[i], 0.13, 0.032)
        call DzFrameShow(property_tip_back[i], false)
        set property_tip_text[i] = DzCreateFrameByTagName("TEXT", "", property_tip_back[i], "", 0)
        call DzFrameSetPoint(property_tip_text[i], JN_FRAMEPOINT_CENTER, property_tip_back[i], JN_FRAMEPOINT_CENTER, 0.0, 0.0)
        call DzFrameSetText(property_tip_text[i], property_explain[i])
    endloop

    set stat_point_back = DzCreateFrameByTagName("BACKDROP", "", stat_alloc_box, "ScoreScreenButtonBackdropTemplate", 0)
    call DzFrameSetPoint(stat_point_back, JN_FRAMEPOINT_BOTTOMLEFT, stat_alloc_box, JN_FRAMEPOINT_BOTTOMLEFT, 0.04, 0.02)
    call DzFrameSetSize(stat_point_back, 0.08, 0.03)
    set stat_point_text = DzCreateFrameByTagName("TEXT", "", stat_point_back, "", 0)
    call DzFrameSetPoint(stat_point_text, JN_FRAMEPOINT_CENTER, stat_point_back, JN_FRAMEPOINT_CENTER, 0.0, 0.0)
    call DzFrameSetText(stat_point_text, "스탯포인트" )
    
    set stat_point_value_back = DzCreateFrameByTagName("BACKDROP", "", stat_point_back, "ScoreScreenButtonBackdropTemplate", 0)
    call DzFrameSetPoint(stat_point_value_back, JN_FRAMEPOINT_LEFT, stat_point_back, JN_FRAMEPOINT_RIGHT, 0.02, 0)
    call DzFrameSetSize(stat_point_value_back, 0.04, 0.03)
    set stat_point_value_text = DzCreateFrameByTagName("TEXT", "", stat_point_value_back, "", 0)
    call DzFrameSetPoint(stat_point_value_text, JN_FRAMEPOINT_CENTER, stat_point_value_back, JN_FRAMEPOINT_CENTER, 0.0, 0.0)
    call DzFrameSetText(stat_point_value_text, "0")
endfunction

private function Stat_Alloc_Basic_Frame takes nothing returns nothing
    // 버튼
    set stat_alloc_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", DzGetGameUI(), "ScriptDialogButton", 0)
    call DzFrameSetPoint(stat_alloc_button, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, 0.055, -0.21)
    call DzFrameSetSize(stat_alloc_button, 0.06, 0.040)
    call DzFrameSetText(stat_alloc_button, "스탯\n찍기")
    call DzFrameSetScriptByCode(stat_alloc_button, JN_FRAMEEVENT_CONTROL_CLICK, function Basic_Button_Clicked, false)
    call DzFrameShow(stat_alloc_button, false)
    
    // 박스
    set stat_alloc_box = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "QuestButtonBaseTemplate", 0)
    call DzFrameSetPoint(stat_alloc_box, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, 0.06, 0.08)
    call DzFrameSetSize(stat_alloc_box, 0.24, 0.41)
    call DzFrameShow(stat_alloc_box, false)
    
    // 박스 닫는 X 버튼
    set x_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", stat_alloc_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(x_button, JN_FRAMEPOINT_BOTTOMRIGHT, stat_alloc_box, JN_FRAMEPOINT_BOTTOMRIGHT, 0, 0)
    call DzFrameSetSize(x_button, 0.032, 0.032)
    call DzFrameSetText(x_button, "X")
    call DzFrameSetScriptByCode(x_button, JN_FRAMEEVENT_CONTROL_CLICK, function Basic_Button_Clicked, false)
endfunction

function Stat_Allocation_Frame_Init takes nothing returns nothing
    call Stat_Alloc_Text_Preprocess()
    call Stat_Alloc_Basic_Frame()
    call Stat_Alloc_Control_Frame()
endfunction

endlibrary