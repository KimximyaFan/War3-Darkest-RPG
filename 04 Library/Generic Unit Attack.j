library GenericUnitAttack requires Base, Basic, GenericUnitBehavior, UnitDamage

private function Unit_Area_Dmg_Rectangle_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dmg = LoadReal(HT, id, 1)
    local real dist = LoadReal(HT, id, 2)
    local real angle = LoadReal(HT, id, 3)
    local real width = LoadReal(HT, id, 4)
    local real height = LoadReal(HT, id, 5)
    local boolean dmg_type = LoadBoolean(HT, id, 6)
    local boolean is_add_angle = LoadBoolean(HT, id, 7)
    local real x
    local real y
    local group g = null
    local unit c
    local integer pid = GetPlayerId(GetOwningPlayer(u))

    if GetUnitState(u, UNIT_STATE_LIFE) <= 0 then
        call Group_Clear(g)
        call Timer_Clear(t)
        set t = null
        set u = null
        set g = null
        set c = null
        return
    endif
    
    
    if is_add_angle == true then
        set angle = GetUnitFacing(u) + angle
    endif
    
    set x = Polar_X( GetUnitX(u), dist, angle )
    set y = Polar_Y( GetUnitY(u), dist, angle )
    
    set g = Get_Enemy_Units_In_Rectangle(u, x, y, width, height, angle)
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        call Unit_Dmg_Target( u, c, dmg, dmg_type)
    endloop
    
    call Group_Clear(g)
    call Timer_Clear(t)
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction

// is_add_angle == true 이면 angle 은 add angle 로 작동
function Unit_Area_Dmg_Rectangle takes unit u, real dmg, real dist, real angle, real width, real height, boolean dmg_type, boolean is_add_angle, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dmg)
    call SaveReal(HT, id, 2, dist)
    call SaveReal(HT, id, 3, angle)
    call SaveReal(HT, id, 4, width)
    call SaveReal(HT, id, 5, height)
    call SaveBoolean(HT, id, 6, dmg_type)
    call SaveBoolean(HT, id, 7, is_add_angle)
    
    call TimerStart(t, delay, false, function Unit_Area_Dmg_Rectangle_Func)
    
    set t = null
endfunction

private function Unit_Taunt_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real size = LoadReal(HT, id, 1)
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local group g = CreateGroup()
    local unit c

    call GroupEnumUnitsInRange( g, x, y, size, null )

    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            call IssueTargetOrderBJ( c, "attack", u )
        endif
    endloop
    
    call Timer_Clear(t)
    call Group_Clear(g)
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction

function Unit_Taunt takes unit u, real size, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, size)
    call TimerStart(t, delay, false, function Unit_Taunt_Func)
    
    set t = null
endfunction

private function Unit_Dmg_Fixed_On_Unit_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dmg = LoadReal(HT, id, 1)
    local real dist = LoadReal(HT, id, 7)
    local real angle = LoadReal(HT, id, 8)
    local real size = LoadReal(HT, id, 2)
    local real duration_time = LoadReal(HT, id, 3) - 0.02
    local boolean dmg_type = LoadBoolean(HT, id, 4)
    local group filter_group = LoadGroupHandle(HT, id, 5)
    local unit owner = LoadUnitHandle(HT, id, 6)
    local real x = Polar_X(GetUnitX(u), dist, angle)
    local real y = Polar_Y(GetUnitY(u), dist, angle)
    local group g = CreateGroup()
    local unit c
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    
    if GetUnitState(u, UNIT_STATE_LIFE) <= 0 then
        call Group_Clear(g)
        call Group_Clear(filter_group)
        call Timer_Clear(t)
        set t = null
        set u = null
        set g = null
        set filter_group = null
        set c = null
        return
    endif
    
    call GroupEnumUnitsInRange( g, x, y, size, null )
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitInGroup(c, filter_group) == false then
            if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
                call Unit_Dmg_Target( owner, c, dmg, dmg_type)
                call GroupAddUnit(filter_group, c)
            endif
        endif
    endloop
    
    call Group_Clear(g)
    
    if duration_time <= 0.0 then
        call Group_Clear(filter_group)
        call Timer_Clear(t)
    else
        call SaveReal(HT, id, 3, duration_time)
        call TimerStart(t, 0.02, false, function Unit_Dmg_Fixed_On_Unit_Func)
    endif

    set t = null
    set u = null
    set g = null
    set filter_group = null
    set c = null
    set owner = null
endfunction

// dist 와 anlge은 유닛 위치 기준으로 어디로 고정시킬건지
function Unit_Dmg_Fixed_On_Unit takes unit u, real dmg, real dist, real angle, real size, real duration_time, boolean dmg_type, unit owner, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dmg)
    call SaveReal(HT, id, 7, dist)
    call SaveReal(HT, id, 8, angle)
    call SaveReal(HT, id, 2, size)
    call SaveReal(HT, id, 3, duration_time)
    call SaveBoolean(HT, id, 4, dmg_type)
    call SaveGroupHandle(HT, id, 5, CreateGroup())
    call SaveUnitHandle(HT, id, 6, owner)
    
    call TimerStart(t, delay, false, function Unit_Dmg_Fixed_On_Unit_Func)
    
    set t = null
endfunction

function Unit_Area_Dmg_With_Owner_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dmg = LoadReal(HT, id, 1)
    local real dist = LoadReal(HT, id, 2)
    local real angle = LoadReal(HT, id, 3)
    local real size = LoadReal(HT, id, 4)
    local boolean dmg_type = LoadBoolean(HT, id, 5)
    local unit owner = LoadUnitHandle(HT, id, 6)
    local real x = Polar_X( GetUnitX(u), dist, angle )
    local real y = Polar_Y( GetUnitY(u), dist, angle )
    local group g = CreateGroup()
    local unit c
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    
    if GetUnitState(u, UNIT_STATE_LIFE) <= 0 then
        call Group_Clear(g)
        call Timer_Clear(t)
        set t = null
        set u = null
        set g = null
        set c = null
        set owner = null
        return
    endif
    
    call GroupEnumUnitsInRange( g, x, y, size, null )
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(owner)) == true then
            call Unit_Dmg_Target( owner, c, dmg, dmg_type)
        endif
    endloop
    
    call Group_Clear(g)
    call Timer_Clear(t)
    
    set t = null
    set u = null
    set g = null
    set c = null
    set owner = null
endfunction

// 기준은 u로 잡고, 실제 데미지 넣는 사람은 owner
function Unit_Area_Dmg_With_Owner takes unit u, real dmg, real dist, real angle, real size, boolean dmg_type, unit owner, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dmg)
    call SaveReal(HT, id, 2, dist)
    call SaveReal(HT, id, 3, angle)
    call SaveReal(HT, id, 4, size)
    call SaveBoolean(HT, id, 5, dmg_type)
    call SaveUnitHandle(HT, id, 6, owner)
    
    call TimerStart(t, delay, false, function Unit_Area_Dmg_With_Owner_Func)
    
    set t = null
endfunction

private function Area_Stun_Attached_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dist = LoadReal(HT, id, 1)
    local real angle = LoadReal(HT, id, 2)
    local real time = LoadReal(HT, id, 3)
    local real size = LoadReal(HT, id, 4)
    local real x
    local real y
    local group g = CreateGroup()
    local unit c
    
    set x = Polar_X( GetUnitX(u), dist, angle )
    set y = Polar_Y( GetUnitY(u), dist, angle )

    call GroupEnumUnitsInRange( g, x, y, size, null )

    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            call CustomStun.Stun( c, time )
        endif
    endloop
    
    call Timer_Clear(t)
    call Group_Clear(g)
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction

function Area_Stun_Attached takes unit u, real dist, real angle, real time, real size, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dist)
    call SaveReal(HT, id, 2, angle)
    call SaveReal(HT, id, 3, time)
    call SaveReal(HT, id, 4, size)

    call TimerStart(t, delay, false, function Area_Stun_Attached_Func)
    
    set t = null
endfunction

private function Area_Stun_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real x = LoadReal(HT, id, 1)
    local real y = LoadReal(HT, id, 2)
    local real time = LoadReal(HT, id, 3)
    local real size = LoadReal(HT, id, 4)
    local group g = CreateGroup()
    local unit c

    call GroupEnumUnitsInRange( g, x, y, size, null )

    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            call CustomStun.Stun( c, time )
        endif
    endloop
    
    call Timer_Clear(t)
    call Group_Clear(g)
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction

function Area_Stun takes unit u, real x, real y, real time, real size, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, x)
    call SaveReal(HT, id, 2, y)
    call SaveReal(HT, id, 3, time)
    call SaveReal(HT, id, 4, size)

    call TimerStart(t, delay, false, function Area_Stun_Func)
    
    set t = null
endfunction

function X_Y_Dmg_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dmg = LoadReal(HT, id, 1)
    local real x = LoadReal(HT, id, 2)
    local real y = LoadReal(HT, id, 3)
    local real size = LoadReal(HT, id, 4)
    local boolean dmg_type = LoadBoolean(HT, id, 5)
    local group g = CreateGroup()
    local unit c
    
    call GroupEnumUnitsInRange( g, x, y, size, null )
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            call Unit_Dmg_Target( u, c, dmg, dmg_type)
        endif
    endloop
    
    call Group_Clear(g)
    call Timer_Clear(t)
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction

function X_Y_Dmg takes unit u, real dmg, real x, real y,  real size, boolean dmg_type, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dmg)
    call SaveReal(HT, id, 2, x)
    call SaveReal(HT, id, 3, y)
    call SaveReal(HT, id, 4, size)
    call SaveBoolean(HT, id, 5, dmg_type)
    
    call TimerStart(t, delay, false, function X_Y_Dmg_Func)
    
    set t = null
endfunction

function Unit_Area_Dmg_Life_Steal_If_Hit_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dmg = LoadReal(HT, id, 1)
    local real dist = LoadReal(HT, id, 2)
    local real angle = LoadReal(HT, id, 3)
    local real size = LoadReal(HT, id, 4)
    local boolean dmg_type = LoadBoolean(HT, id, 5)
    local boolean is_facing = LoadBoolean(HT, id, 6)
    local boolean is_percentile = LoadBoolean(HT, id, 7)
    local real heal_value = LoadReal(HT, id, 8)
    local real x
    local real y
    local group g = CreateGroup()
    local unit c
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    local real actual_dmg

    if GetUnitState(u, UNIT_STATE_LIFE) <= 0 then
        call Group_Clear(g)
        call Timer_Clear(t)
        set t = null
        set u = null
        set g = null
        set c = null
        return
    endif
    
    if is_facing == true then
        set angle = GetUnitFacing(u) + angle
    endif
    
    set x = Polar_X( GetUnitX(u), dist, angle )
    set y = Polar_Y( GetUnitY(u), dist, angle )
    
    call GroupEnumUnitsInRange( g, x, y, size, null )
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            set actual_dmg = Unit_Dmg_Target( u, c, dmg, dmg_type)
            
            if is_percentile == true then
                set heal_value = actual_dmg * heal_value / 100.0
            endif
            call Set_HP(u, Get_HP(u) + heal_value )
        endif
    endloop
    
    call Group_Clear(g)
    call Timer_Clear(t)
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction

// is_facing == true 이면 angle 은 add angle 로 작동
function Unit_Area_Dmg_Life_Steal_If_Hit takes unit u, real dmg, real dist, real angle, real size, boolean dmg_type, boolean is_facing, boolean is_percentile, real heal_value, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dmg)
    call SaveReal(HT, id, 2, dist)
    call SaveReal(HT, id, 3, angle)
    call SaveReal(HT, id, 4, size)
    call SaveBoolean(HT, id, 5, dmg_type)
    call SaveBoolean(HT, id, 6, is_facing)
    call SaveBoolean(HT, id, 7, is_percentile)
    call SaveReal(HT, id, 8, heal_value)
    
    call TimerStart(t, delay, false, function Unit_Area_Dmg_Life_Steal_If_Hit_Func)
    
    set t = null
endfunction

function Unit_Area_Dmg_Sound_If_Hit_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dmg = LoadReal(HT, id, 1)
    local real dist = LoadReal(HT, id, 2)
    local real angle = LoadReal(HT, id, 3)
    local real size = LoadReal(HT, id, 4)
    local boolean dmg_type = LoadBoolean(HT, id, 5)
    local boolean is_facing = LoadBoolean(HT, id, 6)
    local integer sound_id = LoadInteger(HT, id, 7)
    local real x
    local real y
    local group g = CreateGroup()
    local unit c
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    local boolean is_hit = false

    if GetUnitState(u, UNIT_STATE_LIFE) <= 0 then
        call Group_Clear(g)
        call Timer_Clear(t)
        set t = null
        set u = null
        set g = null
        set c = null
        return
    endif
    
    if is_facing == true then
        set angle = GetUnitFacing(u) + angle
    endif
    
    set x = Polar_X( GetUnitX(u), dist, angle )
    set y = Polar_Y( GetUnitY(u), dist, angle )
    
    call GroupEnumUnitsInRange( g, x, y, size, null )
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            call Unit_Dmg_Target( u, c, dmg, dmg_type)
            set is_hit = true
        endif
    endloop
    
    if is_hit == true then
        call Sound_Effect(x, y, sound_id, 0.0)
    endif
    
    call Group_Clear(g)
    call Timer_Clear(t)
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction

// is_facing == true 이면 angle 은 add angle 로 작동
function Unit_Area_Dmg_Sound_If_Hit takes unit u, real dmg, real dist, real angle, real size, boolean dmg_type, boolean is_facing, integer sound_id, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dmg)
    call SaveReal(HT, id, 2, dist)
    call SaveReal(HT, id, 3, angle)
    call SaveReal(HT, id, 4, size)
    call SaveBoolean(HT, id, 5, dmg_type)
    call SaveBoolean(HT, id, 6, is_facing)
    call SaveInteger(HT, id, 7, sound_id)
    
    call TimerStart(t, delay, false, function Unit_Area_Dmg_Sound_If_Hit_Func)
    
    set t = null
endfunction

private function Unit_Area_Dmg_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dmg = LoadReal(HT, id, 1)
    local real dist = LoadReal(HT, id, 2)
    local real angle = LoadReal(HT, id, 3)
    local real size = LoadReal(HT, id, 4)
    local boolean dmg_type = LoadBoolean(HT, id, 5)
    local boolean is_facing = LoadBoolean(HT, id, 6)
    local real x
    local real y
    local group g = CreateGroup()
    local unit c
    local integer pid = GetPlayerId(GetOwningPlayer(u))

    if GetUnitState(u, UNIT_STATE_LIFE) <= 0 then
        call Group_Clear(g)
        call Timer_Clear(t)
        set t = null
        set u = null
        set g = null
        set c = null
        return
    endif
    
    if is_facing == true then
        set angle = GetUnitFacing(u) + angle
    endif
    
    set x = Polar_X( GetUnitX(u), dist, angle )
    set y = Polar_Y( GetUnitY(u), dist, angle )
    
    call GroupEnumUnitsInRange( g, x, y, size, null )
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            call Unit_Dmg_Target( u, c, dmg, dmg_type)
        endif
    endloop
    
    call Group_Clear(g)
    call Timer_Clear(t)
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction

// is_facing == true 이면 angle 은 add angle 로 작동
function Unit_Area_Dmg takes unit u, real dmg, real dist, real angle, real size, boolean dmg_type, boolean is_facing, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, dmg)
    call SaveReal(HT, id, 2, dist)
    call SaveReal(HT, id, 3, angle)
    call SaveReal(HT, id, 4, size)
    call SaveBoolean(HT, id, 5, dmg_type)
    call SaveBoolean(HT, id, 6, is_facing)
    
    call TimerStart(t, delay, false, function Unit_Area_Dmg_Func)
    
    set t = null
endfunction

private function Knock_Back_Attached_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, -1)
    local integer tic = LoadInteger(HT, id, 0)
    local real dist = LoadReal(HT, id, 1)
    local real angle = LoadReal(HT, id, 2)
    local real size = LoadReal(HT, id, 3)
    local real v = LoadReal(HT, id, 4)
    local real a = LoadReal(HT, id, 5)
    local real knock_angle = LoadReal(HT, id, 6)
    local boolean isSpread = LoadBoolean(HT, id, 7)
    local boolean isFacing = LoadBoolean(HT, id, 8)
    local group g = CreateGroup()
    local unit c
    local real x
    local real y
    
    if isFacing == true then
        set angle = GetUnitFacing(u) + angle
    endif
    
    set x = Polar_X(GetUnitX(u), dist, angle)
    set y = Polar_Y(GetUnitY(u), dist, angle)

    call GroupEnumUnitsInRange( g, x, y, size, null )
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            if isSpread == true then
                set knock_angle = Angle(x, y, GetUnitX(c), GetUnitY(c))
            endif

            call Unit_Move(c, tic, v, a, knock_angle, 0.02, 0.0)
        endif
    endloop
    
    call Timer_Clear(t)
    call Group_Clear(g)
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction
// isSpread 체크하면 knock_angle값에 상관없이 방사형 넉백
// isFacing이 true라면 angle은 add_angle로써 작동하게된다
function Knock_Back_Attached takes unit u, real dist, real angle, real size, integer tic, real v, real a, real knock_angle, /*
*/ boolean isSpread, boolean isFacing, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, -1, u)
    call SaveInteger(HT, id, 0, tic)
    call SaveReal(HT, id, 1, dist)
    call SaveReal(HT, id, 2, angle)
    call SaveReal(HT, id, 3, size)
    call SaveReal(HT, id, 4, v)
    call SaveReal(HT, id, 5, a)
    call SaveReal(HT, id, 6, knock_angle)
    call SaveBoolean(HT, id, 7, isSpread)
    call SaveBoolean(HT, id, 8, isFacing)
    
    call TimerStart(t, delay, false, function Knock_Back_Attached_Func)
    
    set t = null
endfunction

private function Knock_Back_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, -1)
    local integer tic = LoadInteger(HT, id, 0)
    local real x = LoadReal(HT, id, 1)
    local real y = LoadReal(HT, id, 2)
    local real size = LoadReal(HT, id, 3)
    local real v = LoadReal(HT, id, 4)
    local real a = LoadReal(HT, id, 5)
    local real angle = LoadReal(HT, id, 6)
    local boolean isSpread = LoadBoolean(HT, id, 7)
    local group g = CreateGroup()
    local unit c

    call GroupEnumUnitsInRange( g, x, y, size, null )
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            if isSpread == true then
                set angle = Angle(x, y, GetUnitX(c), GetUnitY(c))
            endif

            call Unit_Move(c, tic, v, a, angle, 0.02, 0.0)
        endif
    endloop
    
    call Timer_Clear(t)
    call Group_Clear(g)
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction
// isSpread 체크하면 angle값에 상관없이 방사형 넉백 
function Knock_Back takes unit u, real x, real y, real size, integer tic, real v, real a, real angle, boolean isSpread, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, -1, u)
    call SaveInteger(HT, id, 0, tic)
    call SaveReal(HT, id, 1, x)
    call SaveReal(HT, id, 2, y)
    call SaveReal(HT, id, 3, size)
    call SaveReal(HT, id, 4, v)
    call SaveReal(HT, id, 5, a)
    call SaveReal(HT, id, 6, angle)
    call SaveBoolean(HT, id, 7, isSpread)
    
    call TimerStart(t, delay, false, function Knock_Back_Func)
    
    set t = null
endfunction

endlibrary