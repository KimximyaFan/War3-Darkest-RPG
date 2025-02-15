library GenericUnitEffect requires Base, Basic

private function Effect_Continuously_Created_On_Unit_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dist = LoadReal(HT, id, 1)
    local real angle = LoadReal(HT, id, 2)
    local real eff_size = LoadReal(HT, id, 3)
    local real eff_speed = LoadReal(HT, id, 4)
    local real eff_height = LoadReal(HT, id, 5)
    local real eff_time = LoadReal(HT, id, 6)
    local real pitch = LoadReal(HT, id, 7)
    local real roll = LoadReal(HT, id, 8)
    local real yaw = LoadReal(HT, id, 9)
    local string eff = LoadStr(HT, id, 10)
    local real interval = LoadReal(HT, id, 11)
    local real duration = LoadReal(HT, id, 12) - interval
    local effect e
    
    set e = AddSpecialEffect(eff, Polar_X(GetUnitX(u), dist, angle), Polar_Y(GetUnitY(u), dist, angle))
    call EXSetEffectSize(e, eff_size/100)
    call EXSetEffectSpeed(e, eff_speed/100)
    call EXEffectMatRotateY(e, pitch)
    call EXEffectMatRotateX(e, roll)
    call EXEffectMatRotateZ(e, yaw)
    call EXSetEffectZ(e, EXGetEffectZ(e) + eff_height)
    
    call Effect_Destroy(e, eff_time)
    
    if duration <= 0.0 then
        call Timer_Clear(t)
    else
        call SaveReal(HT, id, 12, duration)
        call TimerStart(t, interval, false, function Effect_Continuously_Created_On_Unit_Func)
    endif

    set t = null
    set u = null
    set e = null
endfunction

// 돌진기같은거 만들 때, 찌르기 이펙같은거 
function Effect_Continuously_Created_On_Unit takes unit u, real dist, real angle, real eff_size, real eff_speed, real eff_height, real eff_time, real pitch, real roll, real yaw, /*
*/ string eff, real interval, real duration, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dist)
    call SaveReal(HT, id, 2, angle)
    call SaveReal(HT, id, 3, eff_size)
    call SaveReal(HT, id, 4, eff_speed)
    call SaveReal(HT, id, 5, eff_height)
    call SaveReal(HT, id, 6, eff_time)
    call SaveReal(HT, id, 7, pitch)
    call SaveReal(HT, id, 8, roll)
    call SaveReal(HT, id, 9, yaw)
    call SaveStr(HT, id, 10, eff)
    call SaveReal(HT, id, 11, interval)
    call SaveReal(HT, id, 12, duration)
    
    call TimerStart(t, delay, false, function Effect_Continuously_Created_On_Unit_Func)
    
    set t = null
endfunction

private function Effect_Attached_On_Unit_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dist = LoadReal(HT, id, 1)
    local real angle = LoadReal(HT, id, 2)
    local real eff_time = LoadReal(HT, id, 6) - 0.02
    local effect e = LoadEffectHandle(HT, id, 11)
    
    call EXSetEffectXY(e, Polar_X(GetUnitX(u), dist, angle), Polar_Y(GetUnitY(u), dist, angle))
    
    if eff_time <= 0.0 then
        call Timer_Clear(t)
        call DestroyEffect(e)
    else
        call SaveReal(HT, id, 6, eff_time)
        call TimerStart(t, 0.02, false, function Effect_Attached_On_Unit_Func2)
    endif

    set t = null
    set u = null
    set e = null
endfunction

private function Effect_Attached_On_Unit_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dist = LoadReal(HT, id, 1)
    local real angle = LoadReal(HT, id, 2)
    local real eff_size = LoadReal(HT, id, 3)
    local real eff_speed = LoadReal(HT, id, 4)
    local real eff_height = LoadReal(HT, id, 5)
    local real eff_time = LoadReal(HT, id, 6)
    local real pitch = LoadReal(HT, id, 7)
    local real roll = LoadReal(HT, id, 8)
    local real yaw = LoadReal(HT, id, 9)
    local string eff = LoadStr(HT, id, 10)    
    local effect e
    
    set e = AddSpecialEffect(eff, Polar_X(GetUnitX(u), dist, angle), Polar_Y(GetUnitY(u), dist, angle))
    call EXSetEffectSize(e, eff_size/100)
    call EXSetEffectSpeed(e, eff_speed/100)
    call EXEffectMatRotateY(e, pitch)
    call EXEffectMatRotateX(e, roll)
    call EXEffectMatRotateZ(e, yaw)
    call EXSetEffectZ(e, EXGetEffectZ(e) + eff_height)
    
    call SaveEffectHandle(HT, id, 11, e)
    call TimerStart(t, 0.02, false, function Effect_Attached_On_Unit_Func2)
    
    set t = null
    set u = null
    set e = null
endfunction

// 돌진기같은거 만들 때, 찌르기 이펙같은거 
function Effect_Attached_On_Unit takes unit u, real dist, real angle, real eff_size, real eff_speed, real eff_height, real eff_time, real pitch, real roll, real yaw, /*
*/ string eff, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dist)
    call SaveReal(HT, id, 2, angle)
    call SaveReal(HT, id, 3, eff_size)
    call SaveReal(HT, id, 4, eff_speed)
    call SaveReal(HT, id, 5, eff_height)
    call SaveReal(HT, id, 6, eff_time)
    call SaveReal(HT, id, 7, pitch)
    call SaveReal(HT, id, 8, roll)
    call SaveReal(HT, id, 9, yaw)
    call SaveStr(HT, id, 10, eff)
    
    call TimerStart(t, delay, false, function Effect_Attached_On_Unit_Func)
    
    set t = null
endfunction

private function X_Y_Effect_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local real x = LoadReal(HT, id, 0)
    local real y = LoadReal(HT, id, 1)
    //local real angle = LoadReal(HT, id, 2)
    local real eff_size = LoadReal(HT, id, 3)
    local real eff_speed = LoadReal(HT, id, 4)
    local real eff_height = LoadReal(HT, id, 5)
    local real eff_time = LoadReal(HT, id, 6)
    local real pitch = LoadReal(HT, id, 7)
    local real roll = LoadReal(HT, id, 8)
    local real yaw = LoadReal(HT, id, 9)
    local string eff = LoadStr(HT, id, 10)    
    local effect e
    
    set e = AddSpecialEffect(eff, x, y)
    call EXSetEffectSize(e, eff_size/100)
    call EXSetEffectSpeed(e, eff_speed/100)
    call EXEffectMatRotateY(e, pitch)
    call EXEffectMatRotateX(e, roll)
    call EXEffectMatRotateZ(e, yaw)
    call EXSetEffectZ(e, EXGetEffectZ(e) + eff_height)
    
    call Effect_Destroy(e, eff_time)
    call Timer_Clear(t)
    
    set t = null
    set e = null
endfunction
// yaw 가 angle 역할
function X_Y_Effect takes real x, real y, real eff_size, real eff_speed, real eff_height, real eff_time, real pitch, real roll, real yaw, /*
*/ string eff, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveReal(HT, id, 0, x)
    call SaveReal(HT, id, 1, y)
    //call SaveReal(HT, id, 2, angle)
    call SaveReal(HT, id, 3, eff_size)
    call SaveReal(HT, id, 4, eff_speed)
    call SaveReal(HT, id, 5, eff_height)
    call SaveReal(HT, id, 6, eff_time)
    call SaveReal(HT, id, 7, pitch)
    call SaveReal(HT, id, 8, roll)
    call SaveReal(HT, id, 9, yaw)
    call SaveStr(HT, id, 10, eff)
    
    call TimerStart(t, delay, false, function X_Y_Effect_Func)
    
    set t = null
endfunction

private function Effect_On_Unit_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local effect e = LoadEffectHandle(HT, id, 5)
    
    call DestroyEffect(e)
    
    call Timer_Clear(t)
    
    set t = null
    set e = null
endfunction

private function Effect_On_Unit_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real eff_time = LoadReal(HT, id, 1)
    local real eff_size = LoadReal(HT, id, 2)
    local string attach_point = LoadStr(HT, id, 3)
    local string eff = LoadStr(HT, id, 4)
    local effect e
    
    set e = AddSpecialEffectTarget(eff, u, attach_point)
    
    call EXSetEffectSize(e, eff_size/100)
    
    if eff_time >= 0.0 then
        call SaveEffectHandle(HT, id, 5, e)
        call TimerStart(t, eff_time, false, function Effect_On_Unit_Func2)
    else
        call Timer_Clear(t)
    endif

    set t = null
    set u = null
    set e = null
endfunction
// eff_time 이 음수이면 영구 지속
function Effect_On_Unit takes unit u, real eff_time, real eff_size, string attach_point, string eff, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, eff_time)
    call SaveReal(HT, id, 2, eff_size)
    call SaveStr(HT, id, 3, attach_point)
    call SaveStr(HT, id, 4, eff)
    
    call TimerStart(t, delay, false, function Effect_On_Unit_Func)
    
    set t = null
endfunction

private function Effect_Attached_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dist = LoadReal(HT, id, 1)
    local real angle = LoadReal(HT, id, 2)
    local real eff_size = LoadReal(HT, id, 3)
    local real eff_speed = LoadReal(HT, id, 4)
    local real eff_height = LoadReal(HT, id, 5)
    local real eff_time = LoadReal(HT, id, 6)
    local real pitch = LoadReal(HT, id, 7)
    local real roll = LoadReal(HT, id, 8)
    local real yaw = LoadReal(HT, id, 9)
    local boolean isFacing = LoadBoolean(HT, id, 10)
    local string eff = LoadStr(HT, id, 11)    
    local real x
    local real y
    local effect e
    
    if GetUnitState(u, UNIT_STATE_LIFE) <= 0 then
        call Timer_Clear(t)
        set t = null
        set u = null
        set e = null
        return
    endif
    
    if isFacing == true then
        set angle = GetUnitFacing(u) + angle
        set yaw = angle
    endif
    
    set x = Polar_X(GetUnitX(u), dist, angle)
    set y = Polar_Y(GetUnitY(u), dist, angle)
    
    set e = AddSpecialEffect(eff, x, y)
    call EXSetEffectSize(e, eff_size/100)
    call EXSetEffectSpeed(e, eff_speed/100)
    call EXEffectMatRotateY(e, pitch)
    call EXEffectMatRotateX(e, roll)
    call EXEffectMatRotateZ(e, yaw)
    call EXSetEffectZ(e, EXGetEffectZ(e) + eff_height)
    
    call Effect_Destroy(e, eff_time)
    call Timer_Clear(t)
    
    set t = null
    set u = null
    set e = null
endfunction
// isFacing이 true라면 angle은 add_angle로써 작동하게된다
function Effect_Attached takes unit u, real dist, real angle, real eff_size, real eff_speed, real eff_height, real eff_time, real pitch, real roll, real yaw, /*
*/ boolean isFacing, string eff, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dist)
    call SaveReal(HT, id, 2, angle)
    call SaveReal(HT, id, 3, eff_size)
    call SaveReal(HT, id, 4, eff_speed)
    call SaveReal(HT, id, 5, eff_height)
    call SaveReal(HT, id, 6, eff_time)
    call SaveReal(HT, id, 7, pitch)
    call SaveReal(HT, id, 8, roll)
    call SaveReal(HT, id, 9, yaw)
    call SaveBoolean(HT, id, 10, isFacing)
    call SaveStr(HT, id, 11, eff)
    
    call TimerStart(t, delay, false, function Effect_Attached_Func)
    
    set t = null
endfunction

private function Effect_Create_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dist = LoadReal(HT, id, 1)
    local real angle = LoadReal(HT, id, 2)
    local string eff = LoadStr(HT, id, 3)
    local real x = Polar_X( GetUnitX(u), dist, angle )
    local real y = Polar_Y( GetUnitY(u), dist, angle )
    
    call DestroyEffect( AddSpecialEffect(eff, x, y) )
    
    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

function Effect_Create takes unit u, real dist, real angle, string eff, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dist)
    call SaveReal(HT, id, 2, angle)
    call SaveStr(HT, id, 3, eff)
    
    call TimerStart(t, delay, false, function Effect_Create_Func)
    
    set t = null
endfunction

endlibrary