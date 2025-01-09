library HeroRevive requires Base, UnitProperty

private function Revive_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    
    call ReviveHero(u, map_center_x, map_center_y, true)
    call SetCameraPositionForPlayer(GetOwningPlayer(u), map_center_x, map_center_y)
    
    call Set_HP( u, JNGetUnitMaxHP(u) )
    call Set_MP( u, JNGetUnitMaxMana(u) )
    
    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

private function Revive takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local unit u = GetTriggerUnit()
    local real delay = 2.00
    
    if Get_Unit_Property(u, IN_COURTYARD) == 0 then
        call SaveUnitHandle(HT, id, 0, u)
        call TimerStart(t, delay, false, function Revive_Func)
    endif
    
    set t = null
    set u = null
endfunction

function Revive_Init takes nothing returns nothing
    local trigger trg
    
    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, Player(0), EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerRegisterPlayerUnitEvent(trg, Player(1), EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerRegisterPlayerUnitEvent(trg, Player(2), EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerRegisterPlayerUnitEvent(trg, Player(3), EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerRegisterPlayerUnitEvent(trg, Player(4), EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerRegisterPlayerUnitEvent(trg, Player(5), EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerAddAction( trg, function Revive )
    
    set trg = null
endfunction

endlibrary