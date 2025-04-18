library PotalEvent requires PotalFrame

globals
    private rect camp_potal_rect
    public rect array region_potal_rect
endglobals

private function Leave_Region_Potal_Statue takes nothing returns nothing
    local integer pid = GetPlayerId(GetOwningPlayer(GetTriggerUnit()))

    if GetLocalPlayer() == Player(pid) then
        call DzFrameShow(PotalFrame_region_potal_back_drop, false)
    endif
endfunction

private function Enter_Region_Potal_Statue takes nothing returns nothing
    local trigger triggering_trg = GetTriggeringTrigger()
    local integer pid = GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
    local integer i
    local integer index = -1
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= REGION_POTAL_SIZE
        if triggering_trg == PotalGeneric_region_enter_trg[i] then
            set index = i
            set i = REGION_POTAL_SIZE
        endif
    endloop

    if GetLocalPlayer() == Player(pid) then
    
        if index != -1 and potal_state_check[index] == false then
            set potal_state_check[index] = true
            call BJDebugMsg("포탈의 위치가 저장되었습니다")
            call PlaySoundBJ(gg_snd_MassTeleportTarget)
            call Reconstruct_Potal_Save_String()
        endif
    
        call DzFrameShow(PotalFrame_region_potal_back_drop, true)
    endif
    
    set triggering_trg = null
endfunction

private function Leave_Camp_Potal_Statue takes nothing returns nothing
    local integer pid = GetPlayerId(GetOwningPlayer(GetTriggerUnit()))

    if GetLocalPlayer() == Player(pid) then
        call DzFrameShow(PotalFrame_camp_potal_back_drop, false)
    endif
endfunction

private function Enter_Camp_Potal_Statue takes nothing returns nothing
    local integer pid = GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
    
    if GetLocalPlayer() == Player(pid) then
        call Potal_List_Refresh()
        call DzFrameShow(PotalFrame_camp_potal_back_drop, true)
    endif
endfunction

function Potal_Event_Init takes nothing returns nothing
    local integer i
    local trigger trg
    
    set camp_potal_rect = Create_Rect(1, 515, 150, 150)
    
    set region_potal_rect[0] = Create_Rect(-7718, -5606, 150, 150)
    set region_potal_rect[1] = Create_Rect(-15457, -12405, 150, 150)
    set region_potal_rect[2] = Create_Rect(-10178, -4184, 150, 150)
    set region_potal_rect[3] = Create_Rect(-630, -13938, 150, 150)
    set region_potal_rect[4] = Create_Rect(-6844, -6496, 150, 150)
    set region_potal_rect[5] = Create_Rect(193, -13279, 150, 150)
    set region_potal_rect[6] = Create_Rect(7356, -4271, 150, 150)
    set region_potal_rect[7] = Create_Rect(6909, -15352, 150, 150)
    set region_potal_rect[8] = Create_Rect(9355, -11666, 150, 150)
    set region_potal_rect[9] = Create_Rect(15484, -7416, 150, 150)
    set region_potal_rect[10] = Create_Rect(8822, -1210, 150, 150)
    
    
    set trg = CreateTrigger()
    call TriggerRegisterEnterRectSimple( trg, camp_potal_rect )
    call TriggerAddCondition( trg, Condition( function Hero_Check ) )
    call TriggerAddAction( trg, function Enter_Camp_Potal_Statue )
    
    set trg = CreateTrigger()
    call TriggerRegisterLeaveRectSimple( trg, camp_potal_rect )
    call TriggerAddCondition( trg, Condition( function Hero_Check ) )
    call TriggerAddAction( trg, function Leave_Camp_Potal_Statue )
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= REGION_POTAL_SIZE
        set PotalGeneric_region_enter_trg[i] = CreateTrigger()
        call TriggerRegisterEnterRectSimple( PotalGeneric_region_enter_trg[i], region_potal_rect[i] )
        call TriggerAddCondition( PotalGeneric_region_enter_trg[i], Condition( function Hero_Check ) )
        call TriggerAddAction( PotalGeneric_region_enter_trg[i], function Enter_Region_Potal_Statue )
    endloop

    set trg = CreateTrigger()
    call TriggerRegisterLeaveRectSimple( trg, region_potal_rect[0] )
    call TriggerRegisterLeaveRectSimple( trg, region_potal_rect[1] )
    call TriggerRegisterLeaveRectSimple( trg, region_potal_rect[2] )
    call TriggerRegisterLeaveRectSimple( trg, region_potal_rect[3] )
    call TriggerRegisterLeaveRectSimple( trg, region_potal_rect[4] )
    call TriggerRegisterLeaveRectSimple( trg, region_potal_rect[5] )
    call TriggerRegisterLeaveRectSimple( trg, region_potal_rect[6] )
    call TriggerRegisterLeaveRectSimple( trg, region_potal_rect[7] )
    call TriggerRegisterLeaveRectSimple( trg, region_potal_rect[8] )
    call TriggerRegisterLeaveRectSimple( trg, region_potal_rect[9] )
    call TriggerRegisterLeaveRectSimple( trg, region_potal_rect[10] )
    call TriggerAddCondition( trg, Condition( function Hero_Check ) )
    call TriggerAddAction( trg, function Leave_Region_Potal_Statue )
    
    set trg = null
endfunction

endlibrary