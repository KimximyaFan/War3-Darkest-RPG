library InvenSort requires InvenSprite

globals
    private trigger sync_trg
    private integer sort_button
    private boolean sort_possible = true
endglobals

private function Sort_Cooldown takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local integer pid = LoadInteger(HT, id, 0)
    
    if GetLocalPlayer() == Player(pid) then
        set sort_possible = true
    endif
    
    call Timer_Clear(t)
    
    set t = null
endfunction

private function Sort_Synchronize takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local string sync_data = DzGetTriggerSyncData()
    local integer pid = S2I( SubString(sync_data, 0, 1) )
    local integer i
    local integer j
    local integer max_grade
    local integer max_index
    local integer min_type_num
    local boolean i_exist
    local Equip E
    
    /*
        간단한 Selection Sort
        모르면 구글 검색
    */
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 24
        set max_grade = -1
        set min_type_num = 10
        set max_index = i
        set i_exist = false
        if Hero(pid+1).Check_Inven_Item(i) == true then
            set i_exist = true
            set max_grade = Hero(pid+1).Get_Inven_Item(i).Get_Grade()
            set min_type_num = Hero(pid+1).Get_Inven_Item(i).Get_Type()
        endif
        
        set j = i
        loop 
        set j = j + 1
        exitwhen j > 24
            if Hero(pid+1).Check_Inven_Item(j) == true then
                set E = Hero(pid+1).Get_Inven_Item(j)
                
                if max_grade <= E.Get_Grade() and min_type_num > E.Get_Type() then
                    set max_grade = E.Get_Grade()
                    set min_type_num = E.Get_Type()
                    set max_index = j
                endif
            endif
        endloop
        
        if i != max_index then
            if i_exist == true then
                set E = Hero(pid+1).Get_Inven_Item(i)
            endif
            
            call Hero(pid+1).Set_Inven_Item( i, Hero(pid+1).Get_Inven_Item(max_index) )
            
            if i_exist == true then
                call Hero(pid+1).Set_Inven_Item( max_index, E )
            else
                call Hero(pid+1).Remove_Inven_Item( max_index )
            endif
            
            call Inven_Set_Img( pid, i, Hero(pid+1).Get_Inven_Item(i) )
            
            if i_exist == true then
                call Inven_Set_Img( pid, max_index, E )
            else
                call Inven_Remove_Img( pid, max_index )
            endif
        endif
    endloop
    
    call SaveInteger(HT, id, 0, pid)
    call TimerStart(t, 1.0, false, function Sort_Cooldown)
    
    set t = null
endfunction

private function Sort_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId( DzGetTriggerUIEventPlayer() )
    
    if isUpgrade == true then
        return
    endif
    
    if sort_possible == false then
        return
    endif
    
    set sort_possible = false
    set inven_clicked_index = -1
    set wearing_clicked_index = -1
    call Inven_Sprite_Hide()
    
    // 동기화를 해줍시다
    call DzSyncData("sort", I2S(pid) + " 0" )
endfunction

private function Inven_Sort_Button takes nothing returns nothing
    set sort_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", inven_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(sort_button, JN_FRAMEPOINT_CENTER, inven_box, JN_FRAMEPOINT_CENTER, 0.015, 0.12)
    call DzFrameSetSize(sort_button, 0.060, 0.04)
    call DzFrameSetText(sort_button, "정렬")
    call DzFrameSetScriptByCode(sort_button, JN_FRAMEEVENT_CONTROL_CLICK, function Sort_Clicked, false)
endfunction

function Inven_Sort_Init takes nothing returns nothing
    call Inven_Sort_Button()
    
    // 정렬 동기화
    set sync_trg = CreateTrigger()
    call DzTriggerRegisterSyncData(sync_trg, "sort", false)
    call TriggerAddAction( sync_trg, function Sort_Synchronize )
endfunction

endlibrary