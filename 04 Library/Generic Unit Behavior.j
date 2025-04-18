library GenericUnitBehavior requires Base, Basic

private function Unit_Move_Pathable_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer tic = LoadInteger(HT, id, 1)
    local integer i = LoadInteger(HT, id, 2) + 1
    local real v = LoadReal(HT, id, 3)
    local real a = LoadReal(HT, id, 4)
    local real angle = LoadReal(HT, id, 5)
    local real time_interval = LoadReal(HT, id, 6)
    local real x = Polar_X(GetUnitX(u), v, angle)
    local real y = Polar_Y(GetUnitY(u), v, angle)
    
    set v = v + a
    
    call SetUnitX( u, x )
    call SetUnitY( u, y )
    
    if i >= tic then
        call Timer_Clear(t)
    else
        call SaveInteger(HT, id, 2, i)
        call SaveReal(HT, id, 3, v)
        call TimerStart(t, time_interval, false, function Unit_Move_Pathable_Func)
    endif
    
    set t = null
    set u = null
endfunction

function Unit_Move_Pathable takes unit u, integer tic, real v, real a, real angle, real time_interval, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, tic)
    call SaveInteger(HT, id, 2, 0)
    call SaveReal(HT, id, 3, v)
    call SaveReal(HT, id, 4, a)
    call SaveReal(HT, id, 5, angle)
    call SaveReal(HT, id, 6, time_interval)
    
    call TimerStart(t, delay, false, function Unit_Move_Pathable_Func)
    
    set t = null
endfunction

private function Set_Unit_Invisible_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    
    call SetUnitVertexColorBJ( u, 100, 100, 100, 0 )

    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

private function Set_Unit_Invisible_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real time = LoadReal(HT, id, 1)
    
    call SetUnitVertexColorBJ( u, 100, 100, 100, 100 )
    
    call TimerStart(t, time, false, function Set_Unit_Invisible_Func2)
    
    set t = null
    set u = null
endfunction

function Set_Unit_Invisible takes unit u, real time, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, time)
    call TimerStart(t, delay, false, function Set_Unit_Invisible_Func)
    
    set t = null
endfunction

private function Set_Unit_Ex_Facing_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real angle = LoadReal(HT, id, 1)
    
    call SetUnitFacing(u, angle)
    call EXSetUnitFacing(u, angle)
    
    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

function Set_Unit_Ex_Facing takes unit u, real angle, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, angle)
    call TimerStart(t, delay, false, function Set_Unit_Ex_Facing_Func)
    
    set t = null
endfunction

private function Unit_Jump_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real v = LoadReal(HT, id, 1)
    local real a = LoadReal(HT, id, 2)
    local location loc = GetUnitLoc(u)
    local real z = GetUnitFlyHeight(u) + GetLocationZ(loc) + v
    
    call SetUnitFlyHeight(u, GetUnitFlyHeight(u) + v, 0)
    
    set v = v + a
    
    if z < GetLocationZ(loc) then
        call Timer_Clear(t)
    else
        call SaveReal(HT, id, 1, v)
        call TimerStart(t, 0.02, false, function Unit_Jump_Func)
    endif
    
    call RemoveLocation(loc)
    set t = null
    set u = null
    set loc = null
endfunction

// 해당 time 안에 height 높이 찍고 땅을 찍기 
function Unit_Jump_Height_and_Time takes unit u, real height, real time, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local real v
    local real a
    
    call UnitAddAbility(u, 'Amrf')
    call UnitRemoveAbility(u, 'Amrf')
    
    if height <= 0 then
        set height = 1.0
    endif
    
    if time <= 0 then
        set time = 0.01
    endif
    
    set a = -8 * height / (time * time)
    set v = -a * time / 2.0
    set a = a / 2500
    set v = v / 50
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, v)
    call SaveReal(HT, id, 2, a)
    call TimerStart(t, delay, false, function Unit_Jump_Func)
    
    set t = null
endfunction

// (2 * v) / a = tic
// time = tic * 0.02
// tic = time / 0.02
// v = (tic * a) / 2
// v = (time/0.02) * a / 2
function Unit_Jump takes unit u, real v, real a, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call UnitAddAbility(u, 'Amrf')
    call UnitRemoveAbility(u, 'Amrf')
    
    if a >= 0 then
        set a = -a
    endif
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, v)
    call SaveReal(HT, id, 2, a)
    call TimerStart(t, delay, false, function Unit_Jump_Func)
    
    set t = null
endfunction

private function Unit_Move_Front_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer tic = LoadInteger(HT, id, 1)
    local integer i = LoadInteger(HT, id, 2) + 1
    local real v = LoadReal(HT, id, 3)
    local real a = LoadReal(HT, id, 4)
    local real angle = GetUnitFacing(u)
    local real x = Polar_X(GetUnitX(u), v, angle)
    local real y = Polar_Y(GetUnitY(u), v, angle)
    
    set v = v + a
    
    if IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) == false then
        call SetUnitX( u, x )
        call SetUnitY( u, y )
    else
        set i = tic
    endif
    
    if i >= tic then
        call Timer_Clear(t)
    else
        call SaveInteger(HT, id, 2, i)
        call SaveReal(HT, id, 3, v)
        call TimerStart(t, 0.02, false, function Unit_Move_Front_Func)
    endif
    
    set t = null
    set u = null
endfunction

function Unit_Move_Front takes unit u, integer tic, real v, real a, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, tic)
    call SaveInteger(HT, id, 2, 0)
    call SaveReal(HT, id, 3, v)
    call SaveReal(HT, id, 4, a)
    
    call TimerStart(t, delay, false, function Unit_Move_Front_Func)
    
    set t = null
endfunction

private function Unit_Move_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer tic = LoadInteger(HT, id, 1)
    local integer i = LoadInteger(HT, id, 2) + 1
    local real v = LoadReal(HT, id, 3)
    local real a = LoadReal(HT, id, 4)
    local real angle = LoadReal(HT, id, 5)
    local real time_interval = LoadReal(HT, id, 6)
    local real x = Polar_X(GetUnitX(u), v, angle)
    local real y = Polar_Y(GetUnitY(u), v, angle)
    
    set v = v + a
    
    if IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) == false then
        call SetUnitX( u, x )
        call SetUnitY( u, y )
    else
        set i = tic
    endif
    
    if i >= tic then
        call Timer_Clear(t)
    else
        call SaveInteger(HT, id, 2, i)
        call SaveReal(HT, id, 3, v)
        call TimerStart(t, time_interval, false, function Unit_Move_Func)
    endif
    
    set t = null
    set u = null
endfunction

function Unit_Move takes unit u, integer tic, real v, real a, real angle, real time_interval, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, tic)
    call SaveInteger(HT, id, 2, 0)
    call SaveReal(HT, id, 3, v)
    call SaveReal(HT, id, 4, a)
    call SaveReal(HT, id, 5, angle)
    call SaveReal(HT, id, 6, time_interval)
    
    call TimerStart(t, delay, false, function Unit_Move_Func)
    
    set t = null
endfunction


private function Unit_Rotate_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real time = LoadReal(HT, id, 1)
    local real interval = LoadReal(HT, id, 2)
    local real start_angle = LoadReal(HT, id, 3)
    local real d_angle = LoadReal(HT, id, 4)
    
    set start_angle = start_angle + d_angle
    set time = time - interval
    
    call SetUnitFacingTimed(u, start_angle, 0.0)
    
    if time <= 0 then
        call Timer_Clear(t)
    else
        call SaveReal(HT, id, 1, time)
        call SaveReal(HT, id, 3, start_angle)
    endif
    
    set t = null
    set u = null
endfunction

private function Unit_Rotate_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real interval = LoadReal(HT, id, 2)
    local real start_angle = LoadReal(HT, id, 3)
    
    //call SetUnitFacingTimed(u, start_angle, 0.0)
    call EXSetUnitFacing(u, start_angle)
    
    call TimerStart( t, interval, true, function Unit_Rotate_Func2 )
    
    set t = null
    set u = null
endfunction

function Unit_Rotate takes unit u, real time, real interval, real start_angle, real d_angle, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, time)
    call SaveReal(HT, id, 2, interval)
    call SaveReal(HT, id, 3, start_angle)
    call SaveReal(HT, id, 4, d_angle)
    call TimerStart( t, delay, false, function Unit_Rotate_Func )
    
    set t = null
endfunction



function Delayed_Target_Time_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandleBJ(0, id, HT)
    local unit c = LoadUnitHandleBJ(1, id, HT)
    local integer tic = LoadIntegerBJ(2, id, HT)
    local integer i = LoadIntegerBJ(3, id, HT) + 1
    local location loc = GetUnitLoc(u)
    local location loc2 = GetUnitLoc(c)
    local real angle = AngleBetweenPoints(loc, loc2)
    
    call SetUnitFacingTimed( u, angle, 0 )
    
    if i >= tic or IsUnitAliveBJ(u) == false or IsUnitAliveBJ(c) == false then
        call PauseTimer(t)
        call DestroyTimer(t)
        call FlushChildHashtableBJ(id, HT)
    else
        call SaveIntegerBJ(i, 3, id, HT)
    endif
    
    call RemoveLocation(loc)
    call RemoveLocation(loc2)
    set t = null
    set u = null
    set c = null
    set loc = null
    set loc2 = null
endfunction

function Delayed_Target_Time_Func takes nothing returns nothing
    call TimerStart(GetExpiredTimer(), 0.05, true, function Delayed_Target_Time_Func2 )
endfunction

function Delayed_Target_Time takes unit u, unit c, real time, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandleBJ(u, 0, id, HT)
    call SaveUnitHandleBJ(c, 1, id, HT)
    call SaveIntegerBJ(R2I(time/0.05), 2, id, HT)
    call SaveIntegerBJ(0, 3, id, HT)
    
    call TimerStart(t, delay, false, function Delayed_Target_Time_Func )
    
    set t = null
endfunction

private function Unit_Motion_Detailed_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer motion = LoadInteger(HT, id, 1)
    local real pre_time = LoadReal(HT, id, 2)
    local real pre_ani_speed = LoadReal(HT, id, 3)
    local real post_ani_speed = LoadReal(HT, id, 4)
    local boolean flag = LoadBoolean(HT, id, 5)
    
    if IsUnitAliveBJ(u) == false then
        call SetUnitTimeScalePercent( u, 100 )
        call Timer_Clear(t)
        set t = null
        set u = null
        return
    endif
    
    if flag == false then
        set flag = true
        call SaveBoolean(HT, id, 5, flag)
        call SetUnitTimeScalePercent( u, pre_ani_speed )
        call SetUnitAnimationByIndex( u, motion )
        call TimerStart(t, pre_time, false, function Unit_Motion_Detailed_Func)
    else
        call SetUnitTimeScalePercent( u, post_ani_speed )
        call Timer_Clear(t)
    endif
    
    set t = null
    set u = null
endfunction

function Unit_Motion_Detailed takes unit u, integer motion, real pre_time, real pre_ani_speed, real post_ani_speed, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, motion)
    call SaveReal(HT, id, 2, pre_time)
    call SaveReal(HT, id, 3, pre_ani_speed)
    call SaveReal(HT, id, 4, post_ani_speed)
    call SaveBoolean(HT, id, 5, false)

    call TimerStart(t, delay, false, function Unit_Motion_Detailed_Func)
    
    set t = null
endfunction

function Unit_Motion_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer motion = LoadInteger(HT, id, 1)
    local real ani_speed = LoadReal(HT, id, 2)
    
    call SetUnitAnimationByIndex( u, motion )
    call SetUnitTimeScalePercent( u, ani_speed )
    
    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

function Unit_Motion takes unit u, integer motion, real ani_speed, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, motion)
    call SaveReal(HT, id, 2, ani_speed)
    
    call TimerStart(t, delay, false, function Unit_Motion_Func)
    
    set t = null
endfunction

endlibrary