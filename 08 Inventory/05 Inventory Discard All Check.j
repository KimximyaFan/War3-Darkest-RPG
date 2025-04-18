library DiscardAllCheck requires InvenGeneric

globals
    boolean array discard_all_check
    
    private boolean isCheckBox = false
    private integer discard_all_check_button
    private integer discard_all_check_back_drop
    private integer array discard_all_check_text
    private integer array discard_all_check_box
endglobals

private function Discard_All_Check_Box_Unchecked takes nothing returns nothing
    local integer index = S2I( SubString(DzFrameGetName(DzGetTriggerUIEventFrame()), 0, 1) )
    set discard_all_check[index] = false
endfunction

private function Discard_All_Check_Box_Checked takes nothing returns nothing
    local integer index = S2I( SubString(DzFrameGetName(DzGetTriggerUIEventFrame()), 0, 1) )
    set discard_all_check[index] = true
endfunction

private function Discard_All_Check_Clicked takes nothing returns nothing
    if isUpgrade == true then
        return
    endif
    
    if isCheckBox == true then
        set isCheckBox = false
        call DzFrameShow(discard_all_check_back_drop, false)
    else
        set isCheckBox = true
        call DzFrameShow(discard_all_check_back_drop, true)
    endif
endfunction

private function Inven_Discard_All_Check_Frame takes nothing returns nothing
    local integer i

    set discard_all_check_back_drop = DzCreateFrameByTagName("BACKDROP", "", discard_all_check_button, "QuestButtonBaseTemplate", 0)
    call DzFrameSetPoint(discard_all_check_back_drop, JN_FRAMEPOINT_CENTER, discard_all_check_button, JN_FRAMEPOINT_CENTER, 0.00, 0.06)
    call DzFrameSetSize(discard_all_check_back_drop, 0.08, 0.08)
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 2
        set discard_all_check_text[i] = DzCreateFrameByTagName("TEXT", "", discard_all_check_back_drop, "", 0)
        call DzFrameSetPoint(discard_all_check_text[i], JN_FRAMEPOINT_RIGHT, discard_all_check_back_drop, JN_FRAMEPOINT_BOTTOM, 0.0, 0.02 + i * 0.02)
        call DzFrameSetText(discard_all_check_text[i], item_grade[i])
        
        set discard_all_check_box[i] = DzCreateFrameByTagName("GLUECHECKBOX", I2S(i) + " checkbox", discard_all_check_back_drop, "QuestCheckBox", 0)
        call DzFrameSetPoint(discard_all_check_box[i], JN_FRAMEPOINT_LEFT, discard_all_check_text[i], JN_FRAMEPOINT_RIGHT, 0.0, 0.0)
        call DzFrameSetScriptByCode(discard_all_check_box[i], JN_FRAMEEVENT_CHECKBOX_CHECKED, function Discard_All_Check_Box_Checked, false)
        call DzFrameSetScriptByCode(discard_all_check_box[i], JN_FRAMEEVENT_CHECKBOX_UNCHECKED, function Discard_All_Check_Box_Unchecked, false)
    endloop

    call DzFrameShow(discard_all_check_back_drop, false)
endfunction

private function Inven_Discard_All_Check_Button takes nothing returns nothing
    set discard_all_check_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", inven_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(discard_all_check_button, JN_FRAMEPOINT_CENTER, inven_box, JN_FRAMEPOINT_CENTER, 0.075, 0.12)
    call DzFrameSetSize(discard_all_check_button, 0.060, 0.04)
    call DzFrameSetText(discard_all_check_button, "일괄\n체크")
    call DzFrameSetScriptByCode(discard_all_check_button, JN_FRAMEEVENT_CONTROL_CLICK, function Discard_All_Check_Clicked, false)
endfunction

function Inven_Discard_All_Check_Init takes nothing returns nothing
    set discard_all_check[0] = false
    set discard_all_check[1] = false
    set discard_all_check[2] = false
    set discard_all_check[3] = false
    set discard_all_check[4] = false
    
    call Inven_Discard_All_Check_Button()
    call Inven_Discard_All_Check_Frame()
endfunction

endlibrary