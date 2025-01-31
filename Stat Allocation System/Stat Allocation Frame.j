library StatAllocationFrame

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
    private integer array property_value_text
    private integer array property_button
    
    private string array property_
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

private function Tool_Tip_Leave takes nothing returns nothing

endfunction

private function Tool_Tip_Enter takes nothing returns nothing

endfunction

private function Increase_Button_Clicked takes nothing returns nothing

endfunction

private function Button_Clicked takes nothing returns nothing
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
// call DzFrameSetText(property_text[i], "|cffffcc00" + "활력" + "|r")
// call DzFrameSetText(property_tip_text[i], "활력 1 당 HP 30 증가")
/*
        private integer ad /* 공격력 */
    private integer ap /* 주문력 */
    private integer as /* 공격속도 */
    private integer ms /* 이동속도 */
    private integer def_ad /* 물리 방어력 */
    private integer def_ap /* 마법 방어력 */ 
    private integer hp /* 체력 */
    private integer mp /* 마나 */
    private integer hp_regen /* 체력회복 */
    private integer mp_regen /* 마나회복 */
*/
// =======================================================================

private function Stat_Text_Preprocess takes nothing returns nothing
    
endfunction

private function Stat_Alloc_Control_Frame takes nothing returns nothing
    local integer i
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= 10
        set property_text_back[i] = DzCreateFrameByTagName("BACKDROP", "", stat_alloc_box, "ScoreScreenButtonBackdropTemplate", 0)
        call DzFrameSetPoint(property_text_back[i], JN_FRAMEPOINT_TOPLEFT, stat_alloc_box, JN_FRAMEPOINT_TOPLEFT, 0.0, -0.03 * i)
        call DzFrameSetSize(property_text_back[i], 0.05, 0.03)
        call DzFrameSetScriptByCode(property_text_back[i], JN_FRAMEEVENT_MOUSE_ENTER, function Tool_Tip_Enter, false)
        call DzFrameSetScriptByCode(property_text_back[i], JN_FRAMEEVENT_MOUSE_LEAVE, function Tool_Tip_Leave, false)

        set property_text[i] = DzCreateFrameByTagName("TEXT", "", property_text_back[i], "", 0)
        call DzFrameSetPoint(property_text[i], JN_FRAMEPOINT_CENTER, property_text_back[i], JN_FRAMEPOINT_CENTER, 0.0, 0.0)
        
        set property_value_back[i] = DzCreateFrameByTagName("BACKDROP", "", property_text_back[i], "ScoreScreenButtonBackdropTemplate", 0)
        call DzFrameSetPoint(property_value_back[i], JN_FRAMEPOINT_LEFT, property_text_back[i], JN_FRAMEPOINT_RIGHT, 0.04, 0)
        call DzFrameSetSize(property_value_back[i], 0.04, 0.03)

        set property_value_text[i] = DzCreateFrameByTagName("TEXT", "", property_text_back[i], "", 0)
        call DzFrameSetPoint(property_value_text[i], JN_FRAMEPOINT_CENTER, property_text_back[i], JN_FRAMEPOINT_CENTER, 0.0, 0.0)
        call DzFrameSetText(property_value_text[i], "0")

        set property_button[i] = DzCreateFrameByTagName("GLUETEXTBUTTON", "", property_value_back[i], "ScriptDialogButton", 0)
        call DzFrameSetPoint(property_button[i], JN_FRAMEPOINT_RIGHT, property_value_back[i], JN_FRAMEPOINT_RIGHT, 0.21, 0)
        call DzFrameSetSize(property_button[i], 0.06, 0.04)
        call DzFrameSetText(property_button[i], "증가")
        call DzFrameSetScriptByCode(property_button[i], JN_FRAMEEVENT_CONTROL_CLICK, function Increase_Button_Clicked, false)
        
        set property_tip_back[i] = DzCreateFrameByTagName("BACKDROP", "", stat_alloc_box, "ScoreScreenButtonBackdropTemplate", 0)
        call DzFrameSetPoint(property_tip_back[i], JN_FRAMEPOINT_CENTER, stat_alloc_box, JN_FRAMEPOINT_CENTER, 0.03, 0.04)
        call DzFrameSetSize(property_tip_back[i], 0.16, 0.03)
        call DzFrameShow(property_tip_back[i], false)

        set property_tip_text[i] = DzCreateFrameByTagName("TEXT", "", property_tip_back[i], "", 0)
        call DzFrameSetPoint(property_tip_text[i], JN_FRAMEPOINT_CENTER, property_tip_back[i], JN_FRAMEPOINT_CENTER, 0.0, 0.0)
    endloop
    
    
endfunction

private function Stat_Alloc_Basic_Frame takes nothing returns nothing
    // 버튼
    set stat_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", DzGetGameUI(), "ScriptDialogButton", 0)
    call DzFrameSetPoint(stat_button, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, 0.0, 0.0)
    call DzFrameSetSize(stat_button, 0.06, 0.040)
    call DzFrameSetText(stat_button, "스탯\n찍기")
    call DzFrameSetScriptByCode(stat_button, JN_FRAMEEVENT_CONTROL_CLICK, function Button_Clicked, false)
    call DzFrameShow(stat_button, false)
    
    // 박스
    set stat_alloc_box = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "QuestButtonBaseTemplate", 0)
    call DzFrameSetPoint(stat_alloc_box, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, -0.235, 0.07)
    call DzFrameSetSize(stat_alloc_box, 0.31, 0.30)
    call DzFrameShow(stat_alloc_box, false)
    
    // 박스 닫는 X 버튼
    set x_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", stat_alloc_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(x_button, JN_FRAMEPOINT_TOPRIGHT, stat_alloc_box, JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetSize(x_button, 0.032, 0.032)
    call DzFrameSetText(x_button, "X")
    call DzFrameSetScriptByCode(x_button, JN_FRAMEEVENT_CONTROL_CLICK, function Button_Clicked, false)
endfunction

function Stat_Allocation_Frame_Init takes nothing returns nothing
    call Stat_Alloc_Basic_Frame()
endfunction

endlibrary