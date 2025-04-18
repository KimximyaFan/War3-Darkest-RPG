library DiscardAll requires InvenGeneric

globals
    private trigger sync_trg

    private integer discard_all_button
endglobals

private function Discard_All_Synchronize takes nothing returns nothing
    local string sync_data = DzGetTriggerSyncData()
    local integer pid = S2I( SubString(sync_data, 0, 1) )
    local integer i
    local integer grade
    local string discard_check_str = SubString(sync_data, StringLength(sync_data) - 3, StringLength(sync_data))
    local integer array discard_check
    local Equip E
    
    set discard_check[0] = S2I(SubString(discard_check_str, 0, 1))
    set discard_check[1] = S2I(SubString(discard_check_str, 1, 2))
    set discard_check[2] = S2I(SubString(discard_check_str, 2, 3))
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 24
        if Hero(pid+1).Check_Inven_Item(i) == true then
            set E = Hero(pid+1).Get_Inven_Item(i)
            set grade = E.Get_Grade()
            
            if grade <= 2 then
                if discard_check[grade] == 1 then
                    call Hero(pid+1).Delete_Inven_Item(i)
                    call Inven_Remove_Img( pid, i )
                endif
            elseif is_Test == true then
                call Hero(pid+1).Delete_Inven_Item(i)
                call Inven_Remove_Img( pid, i )
            endif
        endif
    endloop
    
    if GetLocalPlayer() == Player(pid) then
        call PlaySoundBJ(gg_snd_AlchemistTransmuteDeath1)
    endif
endfunction

private function Discard_All_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId( DzGetTriggerUIEventPlayer() )
    local string discard_check_str = ""
    local integer i
    
    if isUpgrade == true then
        return
    endif
    
    call Inven_Sprite_Hide()
    set inven_clicked_index = -1
    set wearing_clicked_index = -1
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 2
        if discard_all_check[i] == true then
            set discard_check_str = discard_check_str + "1"
        else
            set discard_check_str = discard_check_str + "0"
        endif
    endloop
    
    // 동기화를 해줍시다
    call DzSyncData("all", I2S(pid) + " " + discard_check_str )
endfunction

private function Inven_Discard_All_Button takes nothing returns nothing
    set discard_all_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", inven_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(discard_all_button, JN_FRAMEPOINT_CENTER, inven_box, JN_FRAMEPOINT_CENTER, 0.135, 0.12)
    call DzFrameSetSize(discard_all_button, 0.060, 0.04)
    call DzFrameSetText(discard_all_button, "일괄\n버리기")
    call DzFrameSetScriptByCode(discard_all_button, JN_FRAMEEVENT_CONTROL_CLICK, function Discard_All_Clicked, false)
endfunction

function Inven_Discard_All_Init takes nothing returns nothing
    call Inven_Discard_All_Button()
    
    // 일괄 버리기 동기화
    set sync_trg = CreateTrigger()
    call DzTriggerRegisterSyncData(sync_trg, "all", false)
    call TriggerAddAction( sync_trg, function Discard_All_Synchronize )
endfunction

endlibrary