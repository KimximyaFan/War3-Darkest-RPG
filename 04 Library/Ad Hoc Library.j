library Adhoc requires Base

globals
    private string teleport_eff = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl"
endglobals

private function Ad_Hoc_Teleport_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    
    call DestroyEffect( AddSpecialEffect(teleport_eff, x, y) )
    call ShowUnitShow(u)
    
    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

private function Ad_Hoc_Teleport_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real x = LoadReal(HT, id, 1)
    local real y = LoadReal(HT, id, 2)
    local real time = LoadReal(HT, id, 3)
    local real angle = LoadReal(HT, id, 4)
    local location loc = Location(x, y)
    
    call DestroyEffect( AddSpecialEffect(teleport_eff, GetUnitX(u), GetUnitY(u)) )
    call ShowUnitHide(u)
    call SetUnitPositionLoc(u, loc)
    call SetUnitFacing(u, angle)
    
    call TimerStart(t, time, false, function Ad_Hoc_Teleport_Func2)
    
    call RemoveLocation(loc)
    
    set t = null
    set u = null
    set loc = null
endfunction

// ===================================================================
// API
// ===================================================================

function Ad_Hoc_Teleport takes unit u, real x, real y, real time, real angle, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, x)
    call SaveReal(HT, id, 2, y)
    call SaveReal(HT, id, 3, time)
    call SaveReal(HT, id, 4, angle)
    call TimerStart(t, delay, false, function Ad_Hoc_Teleport_Func)
    
    set t = null
endfunction

endlibrary