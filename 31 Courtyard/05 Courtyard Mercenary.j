library CourtyardMercenary requires LoadGeneric, LoadCharacter

globals
    // 글로벌
    boolean array is_character_registered[6][8]
    boolean array is_character_visible[6][8]
    Hero array registered_character[6][8]
    
    // 여기 아래로는 로컬, 각플
    private integer current_register_index = -1

    private integer mercenary_box
    private integer array mercenary_button_back
    private integer array mercenary_button
    private integer array mercenary_img
    private integer array mercenary_button_text
    
    private real square_size = 0.054
    private real img_size = 0.052
    
    private integer mercenary_choose_box
    private integer explain_text
    private integer add_button
    private integer delete_button
endglobals

// ===============================================================
// API
// ===============================================================

private function Choose_Box_Hide takes nothing returns nothing
    call DzFrameShow(mercenary_choose_box, false)
endfunction

private function Choose_Box_Show takes nothing returns nothing
    call DzFrameShow(mercenary_choose_box, true)
endfunction

private function Mercenary_Box_Hide takes nothing returns nothing
    call DzFrameShow(mercenary_box, false)
endfunction

private function Mercenary_Box_Show takes nothing returns nothing
    call DzFrameShow(mercenary_box, true)
endfunction

private function Hide_Unit_Sync takes nothing returns nothing
    local string str = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(str, "/", 0) )
    local integer index = S2I( JNStringSplit(str, "/", 1) )
    
    call ShowUnit(registered_character[pid][index].Get_Hero_Unit(), false)
endfunction

private function Show_Unit_Sync takes nothing returns nothing
    local string str = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(str, "/", 0) )
    local integer index = S2I( JNStringSplit(str, "/", 1) )
    
    call ShowUnit(registered_character[pid][index].Get_Hero_Unit(), true)
endfunction

private function Hide_Unit takes integer pid, integer index returns nothing
    call DzSyncData("merchu", I2S(pid) + "/" + I2S(index))
endfunction

private function Show_Unit takes integer pid, integer index returns nothing
    call DzSyncData("mercsu", I2S(pid) + "/" + I2S(index))
endfunction

// ===============================================================
// Interaction
// ===============================================================

private function Delete_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId( DzGetTriggerUIEventPlayer() )
    
    call Choose_Box_Hide()
    call Mercenary_Box_Show()
    
    if is_character_registered[pid][current_register_index] == false then
        // do nothing
    else
        call Hide_Unit(pid, current_register_index)
    endif
endfunction


private function Add_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId( DzGetTriggerUIEventPlayer() )
    
    call Choose_Box_Hide()
    call Mercenary_Box_Show()
    
    if is_character_registered[pid][current_register_index] == false then
        // Load Character
        call Register_Character_Code(pid, current_register_index)
        set is_character_registered[pid][current_register_index] = true
        set is_character_visible[pid][current_register_index] = true
    else
        call Show_Unit(pid, current_register_index)
    endif
endfunction

private function Character_Button_Clicked takes nothing returns nothing
    local integer index = S2I( JNStringSplit(DzFrameGetName(DzGetTriggerUIEventFrame()), "/", 0) )
    
    call PlaySoundBJ(gg_snd_BigButtonClick)
    
    if index == current_load_index or is_character_loaded[index] == false then
        return
    endif
    
    set current_register_index = index
    
    call Choose_Box_Show()
    call Mercenary_Box_Hide()
endfunction

// ===============================================================
// Frame
// ===============================================================

private function Mercenary_Choose_Frame_Init takes nothing returns nothing
    set mercenary_choose_box = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "EscMenuBackdrop", 0)
    call DzFrameSetPoint(mercenary_choose_box, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, 0.0, 0.0)
    call DzFrameSetSize(mercenary_choose_box, 0.26, 0.16)
    call DzFrameShow(mercenary_choose_box, false)
    
    set explain_text = DzCreateFrameByTagName("TEXT", "", mercenary_choose_box, "ScoreScreenTabTextSelectedTemplate", 0)
    call DzFrameSetPoint(explain_text, JN_FRAMEPOINT_CENTER, mercenary_choose_box, JN_FRAMEPOINT_CENTER, 0.0, 0.03)
    call DzFrameSetText(explain_text, "용병 관리" )
    
    set add_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", mercenary_choose_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(add_button, JN_FRAMEPOINT_CENTER, mercenary_choose_box, JN_FRAMEPOINT_CENTER, -0.05, -0.03)
    call DzFrameSetSize(add_button, 0.060, 0.04)
    call DzFrameSetText(add_button, "추가")
    call DzFrameSetScriptByCode(add_button, JN_FRAMEEVENT_CONTROL_CLICK, function Add_Clicked, false)
    
    set delete_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", mercenary_choose_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(delete_button, JN_FRAMEPOINT_CENTER, mercenary_choose_box, JN_FRAMEPOINT_CENTER, 0.05, -0.03)
    call DzFrameSetSize(delete_button, 0.060, 0.04)
    call DzFrameSetText(delete_button, "제거")
    call DzFrameSetScriptByCode(delete_button, JN_FRAMEEVENT_CONTROL_CLICK, function Delete_Clicked, false)
endfunction

private function Mercenary_Set_Character_List_Img takes nothing returns nothing
    local string str
    local integer i
    local integer unit_id

    set i = -1
    loop
    set i = i + 1
    exitwhen i > 7
        set str = JNStringSplit(character_list, "#", i)
        
        if JNStringSplit(str, ",", 0) != "-1" then
            set unit_id = S2I(JNStringSplit(str, ",", 0))
            
            call DzFrameSetTexture(mercenary_img[i], Get_Icon_Img_From_Unit_Id(unit_id), 0)
            call DzFrameShow(mercenary_img[i], true)
            call DzFrameSetText(mercenary_button_text[i], Get_Character_Name_From_Unit_Id(unit_id) )
        endif
    endloop
endfunction

private function Mercenary_Frame takes nothing returns nothing
    local integer i
    local integer a
    local integer b
    local real padding = 0.025
    local real x = 0.03
    local real y = -0.035
    local real test_padding = -0.035
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 7
        
        set a = ModuloInteger(i, 4)
        set b = (i / 4)
        set mercenary_button_back[i] = DzCreateFrameByTagName("BACKDROP", "", mercenary_box, "QuestButtonBaseTemplate", 0)
        call DzFrameSetPoint(mercenary_button_back[i], JN_FRAMEPOINT_TOPLEFT, mercenary_box, JN_FRAMEPOINT_TOPLEFT, x + ((square_size + padding) * a), y + (-(square_size + padding) * b) )
        call DzFrameSetSize(mercenary_button_back[i], square_size, square_size)
        
        set mercenary_img[i] = DzCreateFrameByTagName("BACKDROP", "", mercenary_button_back[i], "QuestButtonBaseTemplate", 0)
        call DzFrameSetPoint(mercenary_img[i], JN_FRAMEPOINT_CENTER, mercenary_button_back[i], JN_FRAMEPOINT_CENTER, 0, 0 )
        call DzFrameSetSize(mercenary_img[i], img_size, img_size)
        call DzFrameShow(mercenary_img[i], false)
        
        set mercenary_button_text[i] = DzCreateFrameByTagName("TEXT", "", mercenary_button_back[i], "", 0)
        call DzFrameSetPoint(mercenary_button_text[i], JN_FRAMEPOINT_CENTER, mercenary_button_back[i], JN_FRAMEPOINT_CENTER, 0.0, test_padding)
        call DzFrameSetText(mercenary_button_text[i], "빈 캐릭터" )
        
        set mercenary_button[i] = DzCreateFrameByTagName("BUTTON", I2S(i) + "/merc", mercenary_button_back[i], "ScoreScreenTabButtonTemplate", 0)
        call DzFrameSetPoint(mercenary_button[i], JN_FRAMEPOINT_CENTER, mercenary_button_back[i], JN_FRAMEPOINT_CENTER, 0, 0)
        call DzFrameSetSize(mercenary_button[i], square_size, square_size)
        call DzFrameSetScriptByCode(mercenary_button[i], JN_FRAMEEVENT_CONTROL_CLICK, function Character_Button_Clicked, false)
    endloop
endfunction

private function Trigger_Init takes nothing returns nothing
    local trigger trg
    
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "mercsu", false)
    call TriggerAddAction( trg, function Show_Unit_Sync )
    
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "merchu", false)
    call TriggerAddAction( trg, function Hide_Unit_Sync )
    
    set trg = null
endfunction

endlibrary