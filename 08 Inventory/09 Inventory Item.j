library InvenItem requires InvenGeneric, InvenToolTip, Stat

globals
    private trigger sync_trg

    integer array item_back_drops
    integer array item_img
    integer array item_buttons
    
    integer inven_clicked_index = -1
    
    private boolean exception_restriction = false
endglobals

private function Inven_Item_Synchronize takes nothing returns nothing
    local string sync_data = DzGetTriggerSyncData()
    local integer pid = S2I( SubString(sync_data, 0, 1) )
    local integer inven_index = S2I( SubString(sync_data, StringLength(sync_data) - 2, StringLength(sync_data)) )
    local integer wearing_index
    local Equip E = Hero(pid+1).Get_Inven_Item(inven_index)
    set wearing_index = Hero(pid+1).Check_Wearing(E.Get_Type())

    if wearing_index == -1 then
        // 이미 장착 칸에 아이템을 낀경우
        
        set wearing_index = Hero(pid+1).Type_To_Index( E.Get_Type() )
        
        call Hero(pid+1).Set_Inven_Item( inven_index, Hero(pid+1).Get_Wearing_Item(wearing_index) )
        call Hero(pid+1).Remove_Wearing_Item( wearing_index )
        call Hero(pid+1).Set_Wearing_Item( wearing_index, E )

        call Inven_Set_Img( pid, inven_index, Hero(pid+1).Get_Inven_Item(inven_index) )
        call Wearing_Set_Img( pid, wearing_index, Hero(pid+1).Get_Wearing_Item(wearing_index) )

        call Stat_Refresh(pid)
    else
        // 장착 칸이 빈 경우
        call Hero(pid+1).Remove_Inven_Item( inven_index ) /* 동기화 필요 */
        call Hero(pid+1).Set_Wearing_Item( wearing_index, E ) /* 동기화 필요 */
        
        call Inven_Remove_Img( pid, inven_index )
        call Wearing_Set_Img( pid, wearing_index, E )

        call Stat_Refresh(pid)
    endif
    
    if GetLocalPlayer() == Player(pid) then
        set exception_restriction = false
        call PlaySoundBJ(gg_snd_PickUpItem)
    endif
endfunction

private function Inven_Item_Clicked takes nothing returns nothing
    local integer event_frame = DzGetTriggerUIEventFrame()
    local integer pid = GetPlayerId( DzGetTriggerUIEventPlayer() )
    local integer index = S2I( SubString(DzFrameGetName(event_frame), 0, 2) )
    
    if isUpgrade == true or exception_restriction == true then
        return
    endif
    
    if inven_clicked_index == index then
        set inven_clicked_index = -1
        set exception_restriction = true
        call Inven_Tool_Tip_Leave()
        call Inven_Sprite_Hide()
        // 인벤창 아이템 처리 관련 동기화를 해줍시다
        // 문자열 앞부분은 플레이어번호 뒷부분은 템칸 인덱스
        call DzSyncData("inven", I2S(pid) + " 0" + I2S(index))
    else
        // 클릭 사운드 재생
        call PlaySoundBJ(gg_snd_AutoCastButtonClick1)
        call Inven_Sprite_Set_Position(event_frame)
        call Inven_Sprite_Show()
        // 클릭한 인벤의 인덱스
        set inven_clicked_index = index
        // 착용 아이템 인덱스는 -1로
        set wearing_clicked_index = -1
    endif
endfunction

// 아이템칸 25개, 백드롭과 버튼으로 구성됨
private function Inven_Item_Frames takes nothing returns nothing
    local integer i
    local integer a
    local integer b
    local real x = 0.010
    local real y = 0.075
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 24
        
        set a = ModuloInteger(i, 5)
        set b = (i / 5)
        set item_back_drops[i] = DzCreateFrameByTagName("BACKDROP", "", inven_box, "QuestButtonPushedBackdropTemplate", 0)
        call DzFrameSetPoint(item_back_drops[i], JN_FRAMEPOINT_CENTER, inven_box, JN_FRAMEPOINT_CENTER, x + (inven_square_size * a), y + (-inven_square_size * b) )
        call DzFrameSetSize(item_back_drops[i], inven_square_size, inven_square_size)
        
        set item_img[i] = DzCreateFrameByTagName("BACKDROP", "", item_back_drops[i], "QuestButtonPushedBackdropTemplate", 0)
        call DzFrameSetPoint(item_img[i], JN_FRAMEPOINT_CENTER, item_back_drops[i], JN_FRAMEPOINT_CENTER, 0, 0 )
        call DzFrameSetSize(item_img[i], inven_item_size, inven_item_size)
        call DzFrameShow(item_img[i], false)
        
        set item_buttons[i] = DzCreateFrameByTagName("BUTTON", I2S(i) + " item", item_back_drops[i], "ScoreScreenTabButtonTemplate", 0)
        call DzFrameSetPoint(item_buttons[i], JN_FRAMEPOINT_CENTER, item_back_drops[i], JN_FRAMEPOINT_CENTER, 0, 0)
        call DzFrameSetSize(item_buttons[i], inven_square_size, inven_square_size)
        call DzFrameSetScriptByCode(item_buttons[i], JN_FRAMEEVENT_CONTROL_CLICK, function Inven_Item_Clicked, false)
        // 마우스 진입, 빠져나올 때 툴팁 함수 실행됨
        call DzFrameSetScriptByCode(item_buttons[i], JN_FRAMEEVENT_MOUSE_ENTER, function Inven_Tool_Tip_Enter, false)
        call DzFrameSetScriptByCode(item_buttons[i], JN_FRAMEEVENT_MOUSE_LEAVE, function Inven_Tool_Tip_Leave, false)
        
        call DzFrameShow(item_buttons[i], false)
    endloop
endfunction

function Inven_Item_Init takes nothing returns nothing
    call Inven_Item_Frames()
    
    // 아이템칸 동기화
    set sync_trg = CreateTrigger()
    call DzTriggerRegisterSyncData(sync_trg, "inven", false)
    call TriggerAddAction( sync_trg, function Inven_Item_Synchronize )
endfunction

endlibrary