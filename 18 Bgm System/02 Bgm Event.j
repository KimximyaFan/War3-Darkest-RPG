library BgmEvent requires BgmGeneric

globals
    private region array bgm_region
endglobals



private function Bgm_Region_Entered takes nothing returns nothing
    local integer pid = GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
    local region triggering_region = GetTriggeringRegion()
    local integer i = 0
    
    loop
    exitwhen triggering_region == bgm_region[i] or i > BgmGeneric_MAX_REGION_INDEX
        set i = i + 1
    endloop
    
    if GetLocalPlayer() == Player(pid) then
        if BgmGeneric_current_bgm_state != i then
            if BgmGeneric_is_bgm_on == true then
                call BgmGeneric_Bgm_Off()
            endif
            set BgmGeneric_current_bgm_state = i
            if BgmGeneric_is_bgm_on == true then
                call BgmGeneric_Bgm_On()
            endif
        endif
    endif
    
    set triggering_region = null
endfunction

private function Bgm_Region_Init takes nothing returns nothing
    set bgm_region[0] = CreateRegion()
    set bgm_region[1] = CreateRegion()
    set bgm_region[2] = CreateRegion()
    set bgm_region[3] = CreateRegion()
    set bgm_region[4] = CreateRegion()
    set bgm_region[10] = CreateRegion()
    set bgm_region[11] = CreateRegion()
    
    // 캠프 
    call RegionAddRect(bgm_region[0], Create_Rect(6, -7, 700, 700))
    
    // 1지역 삼림지대
    call RegionAddRect(bgm_region[1], Create_Rect(-2150, -51, 400, 400))
    call RegionAddRect(bgm_region[1], Create_Rect(-7527, -5329, 350, 350))
    call RegionAddRect(bgm_region[1], Create_Rect(-10185, -4423, 350, 350))
    call RegionAddRect(bgm_region[1], Create_Rect(-15272, -12405, 350, 350))
    call RegionAddRect(bgm_region[1], Create_Rect(-11942, -200, 350, 350))
    
    // 2지역 폐허
    call RegionAddRect(bgm_region[2], Create_Rect(-836, -15477, 350, 350))
    call RegionAddRect(bgm_region[2], Create_Rect(-811, -14098, 350, 350))
    call RegionAddRect(bgm_region[2], Create_Rect(-6848, -6738, 350, 350))
    call RegionAddRect(bgm_region[2], Create_Rect(194, -13062, 350, 350))
    call RegionAddRect(bgm_region[2], Create_Rect(-14530, -7587, 350, 350))
    
    // 3지역 사육장
    call RegionAddRect(bgm_region[3], Create_Rect(6138, -4456, 350, 350))
    call RegionAddRect(bgm_region[3], Create_Rect(7191, -4438, 350, 350))
    call RegionAddRect(bgm_region[3], Create_Rect(6765, -15493, 350, 350))
    call RegionAddRect(bgm_region[3], Create_Rect(9201, -11822, 350, 350))
    call RegionAddRect(bgm_region[3], Create_Rect(14245, -9967, 350, 350))
    
    // 4지역 해안만
    call RegionAddRect(bgm_region[4], Create_Rect(15182, -8645, 350, 350))
    call RegionAddRect(bgm_region[4], Create_Rect(15484, -7416, 350, 350))
    call RegionAddRect(bgm_region[4], Create_Rect(8822, -1210, 350, 350))
    
    // 어던
    call RegionAddRect(bgm_region[10], Create_Rect(14060, 3340, 350, 350))
endfunction

function Bgm_Event_Init takes nothing returns nothing
    local trigger trg
    
    call Bgm_Region_Init()
    
    set trg = CreateTrigger()
    call TriggerRegisterEnterRegion(trg, bgm_region[0], null)
    call TriggerRegisterEnterRegion(trg, bgm_region[1], null)
    call TriggerRegisterEnterRegion(trg, bgm_region[2], null)
    call TriggerRegisterEnterRegion(trg, bgm_region[3], null)
    call TriggerRegisterEnterRegion(trg, bgm_region[4], null)
    call TriggerRegisterEnterRegion(trg, bgm_region[10], null)
    call TriggerAddCondition(trg, function Hero_Check)
    call TriggerAddAction(trg, function Bgm_Region_Entered)
    
    set trg = null
endfunction

endlibrary