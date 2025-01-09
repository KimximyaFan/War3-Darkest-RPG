library CourtyardEvent requires SimplePotal, CourtyardFrame


private function Leave_Courtyard takes nothing returns nothing
    local integer pid = GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
    
    call Courtyard_Button_Hide(pid)
    call FogModifierStop(courtyard_fogmodifier[pid])
endfunction

private function Enter_Courtyard takes nothing returns nothing
    local integer pid = GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
    
    call Courtyard_Button_Show(pid)
    call FogModifierStart(courtyard_fogmodifier[pid])
endfunction

private function Entering_Courtyard_Potal takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    
    call Teleport(u, GetRectCenterX(courtyard_rect[pid]), GetRectCenterY(courtyard_rect[pid]), null)
    
    set u = null
endfunction

function Courtyard_Event_Init takes nothing returns nothing
    local region entering_region
    local trigger trg
    
    set entering_region = CreateRegion()
    call RegionAddRect(entering_region, Create_Rect(-4, -582, 150, 150))
    set trg = CreateTrigger()
    call TriggerRegisterEnterRegion( trg, entering_region, null )
    call TriggerAddCondition( trg, Condition( function Hero_Check ) )
    call TriggerAddAction( trg, function Entering_Courtyard_Potal )
    
    set trg = CreateTrigger()
    call TriggerRegisterEnterRegion( trg, courtyard_region, null )
    call TriggerAddCondition( trg, Condition( function Hero_Check ) )
    call TriggerAddAction( trg, function Enter_Courtyard )
    
    set trg = CreateTrigger()
    call TriggerRegisterLeaveRegion( trg, courtyard_region, null )
    call TriggerAddCondition( trg, Condition( function Hero_Check ) )
    call TriggerAddAction( trg, function Leave_Courtyard )
    
    set entering_region = null
    set trg = null
endfunction

endlibrary