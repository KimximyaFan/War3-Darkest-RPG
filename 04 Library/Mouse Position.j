library MousePosition initializer Init

globals
    private real array mouse_x
    private real array mouse_y
    private boolean array is_facing_on
    private boolean array is_stop
endglobals

function Set_Mouse_Position_Func takes nothing returns nothing
    local string str = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(str, "/", 0) )
    local real x = S2R( JNStringSplit(str, "/", 1) )
    local real y = S2R( JNStringSplit(str, "/", 2) )
    
    set mouse_x[pid] = x
    set mouse_y[pid] = y
endfunction

function Set_Mouse_Position takes integer pid returns nothing
    if GetLocalPlayer() == Player(pid) then
        call DzSyncData( "SMP", I2S(pid) + "/" + R2S(DzGetMouseTerrainX()) + "/" + R2S(DzGetMouseTerrainY()) )
    endif
endfunction

function Get_Mouse_X takes integer pid returns real
    return mouse_x[pid]
endfunction

function Get_Mouse_Y takes integer pid returns real
    return mouse_y[pid]
endfunction

function Is_Facing_On takes integer pid returns boolean
    return is_facing_on[pid]
endfunction

function Stop_Mouse_Facing takes integer pid returns nothing
    set is_stop[pid] = true
endfunction

// ====================================================================================================================
// ====================================================================================================================

private function Unit_Facing_Mouse_Fix_Check_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer tic = LoadInteger(HT, id, 1) - 1
    local real facing_delay = LoadReal(HT, id, 2)
    local real fixed_x = LoadReal(HT, id, 3)
    local real fixed_y = LoadReal(HT, id, 4)
    local integer pid = GetPlayerId(GetOwningPlayer(u))

    call Set_Mouse_Position(pid)

    call SetUnitFacingTimed( u, Angle(GetUnitX(u), GetUnitY(u), Get_Mouse_X(pid), Get_Mouse_Y(pid)), facing_delay )
    
    // 움직이면 끊김
    if  RAbsBJ(fixed_x - GetUnitX(u)) >= 0.0001 or RAbsBJ(fixed_y - GetUnitY(u)) >= 0.0001 then
        set tic = 0
    endif
    
    if is_stop[pid] == true then
        set tic = 0
    endif
    
    if tic <= 0 then
        call Timer_Clear(t)
        set is_facing_on[pid] = false
    else
        call SaveInteger(HT, id, 1, tic)
        call TimerStart(t, 0.02, false, function Unit_Facing_Mouse_Fix_Check_Func2)
    endif

    set t = null
    set u = null
endfunction

private function Unit_Facing_Mouse_Fix_Check_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    local real fixed_x = GetUnitX(u)
    local real fixed_y = GetUnitY(u)
    
    set is_stop[pid] = false
    set is_facing_on[pid] = true
    
    call SaveReal(HT, id, 3, fixed_x)
    call SaveReal(HT, id, 4, fixed_y)
    call TimerStart(t, 0.00, false, function Unit_Facing_Mouse_Fix_Check_Func2)
    
    set t = null
    set u = null
endfunction

function Unit_Facing_Mouse_Fix_Check takes unit u, real time, real facing_delay, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, R2I(time/0.02))
    call SaveReal(HT, id, 2, facing_delay)

    call TimerStart(t, delay, false, function Unit_Facing_Mouse_Fix_Check_Func)
    
    set t = null
endfunction

// ------------------------------------------

private function Unit_Facing_Mouse_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer tic = LoadInteger(HT, id, 1) - 1
    local real facing_delay = LoadReal(HT, id, 2)
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    
    call Set_Mouse_Position(pid)

    call SetUnitFacingTimed( u, Angle(GetUnitX(u), GetUnitY(u), Get_Mouse_X(pid), Get_Mouse_Y(pid)), facing_delay )
    
    if is_stop[pid] == true then
        set tic = 0
    endif
    
    if tic <= 0 then
        call Timer_Clear(t)
    else
        call SaveInteger(HT, id, 1, tic)
        call TimerStart(t, 0.02, false, function Unit_Facing_Mouse_Func)
    endif

    set t = null
    set u = null
endfunction

function Unit_Facing_Mouse takes unit u, real time, real facing_delay, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    
    set is_stop[pid] = false
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, R2I(time/0.02))
    call SaveReal(HT, id, 2, facing_delay)

    call TimerStart(t, delay, false, function Unit_Facing_Mouse_Func)
    
    set t = null
endfunction

// ------------------------------------------

private function Init takes nothing returns nothing
    local trigger trg

    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData( trg, "SMP", false )
    call TriggerAddAction( trg, function Set_Mouse_Position_Func )
    
    set trg = null
endfunction

endlibrary