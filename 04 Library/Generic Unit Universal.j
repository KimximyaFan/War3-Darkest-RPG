library GenericUnitUniversal requires Base, Basic, UnitProperty, Stat

private function Unit_Add_Mana_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real add_value = LoadReal(HT, id, 1)
    local boolean is_percentile = LoadBoolean(HT, id, 2)
    
    if is_percentile == true then
        set add_value = Get_Max_MP(u) * add_value / 100.0
    endif
    call Set_MP(u, Get_MP(u) + add_value )
    
    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

function Unit_Add_Mana takes unit u, real add_value, boolean is_percentile, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, add_value)
    call SaveBoolean(HT, id, 2, is_percentile)
    call TimerStart(t, delay, false, function Unit_Add_Mana_Func)
    
    set t = null
endfunction

private function Unit_Add_Life_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real add_value = LoadReal(HT, id, 1)
    local boolean is_percentile = LoadBoolean(HT, id, 2)
    
    if is_percentile == true then
        set add_value = Get_Max_HP(u) * add_value / 100.0
    endif
    call Set_HP(u, Get_HP(u) + add_value )
    
    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

function Unit_Add_Life takes unit u, real add_value, boolean is_percentile, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, add_value)
    call SaveBoolean(HT, id, 2, is_percentile)
    call TimerStart(t, delay, false, function Unit_Add_Life_Func)
    
    set t = null
endfunction

private function Unit_Add_Attack_Range_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real duration = LoadReal(HT, id, 1)
    local real add_value = LoadReal(HT, id, 2)
    
    if duration < 0.0 then
        call JNSetUnitAcquistionRange(u, JNGetUnitAcquistionRange(u) - add_value)
        call JNSetUnitAttackRange(u, 1, JNGetUnitAttackRange(u, 1) - add_value)
        call Timer_Clear(t)
    else
        call JNSetUnitAcquistionRange(u, JNGetUnitAcquistionRange(u) + add_value)
        call JNSetUnitAttackRange(u, 1, JNGetUnitAttackRange(u, 1) + add_value)
        call SaveReal(HT, id, 1, -1.0) /* duration을 음수로 */
        call TimerStart(t, duration, false, function Unit_Add_Attack_Range_Func)
    endif
    
    set t = null
    set u = null
endfunction

function Unit_Add_Attack_Range takes unit u, real duration, real add_value, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, duration)
    call SaveReal(HT, id, 2, add_value)
    call TimerStart(t, delay, false, function Unit_Add_Attack_Range_Func)
    
    set t = null
endfunction

private function Set_Unit_Custom_Int_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer index = LoadInteger(HT, id, 2)
    local integer value = LoadInteger(HT, id, 3)
    local boolean is_add = LoadBoolean(HT, id, 4)
    
    if index >= CUSTOM_INT_0 then
        set index = index - CUSTOM_INT_0
    endif
    
    if is_add == true then
        call Set_Unit_Property(u, CUSTOM_INT_0 + index, Get_Unit_Property(u, CUSTOM_INT_0 + index) - value)
    else
        call Set_Unit_Property(u, CUSTOM_INT_0 + index, 0)
    endif

    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

private function Set_Unit_Custom_Int_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real time = LoadReal(HT, id, 1)
    local integer index = LoadInteger(HT, id, 2)
    local integer value = LoadInteger(HT, id, 3)
    local boolean is_add = LoadBoolean(HT, id, 4)
    
    // CUSTOM_INT_0 = 30 인데
    // 여기에 인덱스 값을 더하면 포인터 처럼 씀
    if index >= CUSTOM_INT_0 then
        set index = index - CUSTOM_INT_0
    endif
    
    if is_add == true then
        call Set_Unit_Property(u, CUSTOM_INT_0 + index, Get_Unit_Property(u, CUSTOM_INT_0 + index) + value)
    else
        call Set_Unit_Property(u, CUSTOM_INT_0 + index, value)
    endif

    if time <= 0 then
        call Timer_Clear(t)
    else
        call TimerStart(t, time, false, function Set_Unit_Custom_Int_Func2)
    endif

    set t = null
    set u = null
endfunction

// 현재 index 범위 0 ~ 4
// 만약 영구 적용 하고싶으면 time -1 로
// time 적용시 값 적용후 시간 지나면 0으로 되돌림
// is_add 가 true 이면 set 이 아닌 더하는 형태 
function Set_Unit_Custom_Int takes unit u, real time, integer index, integer value, boolean is_add, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, time)
    call SaveInteger(HT, id, 2, index)
    call SaveInteger(HT, id, 3, value)
    call SaveBoolean(HT, id, 4, is_add)
    call TimerStart(t, delay, false, function Set_Unit_Custom_Int_Func)
    
    set t = null
endfunction

private function Unit_Add_Stat_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer property = LoadInteger(HT, id, 2)
    local integer value = LoadInteger(HT, id, 3)
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    
    call Set_Unit_Property(u, property, Get_Unit_Property(u, property) - value )
    
    if Player(pid) != p_enemy then
        call Stat_Refresh(pid)
    endif
    
    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

private function Unit_Add_Stat_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real time = LoadReal(HT, id, 1)
    local integer property = LoadInteger(HT, id, 2)
    local integer value = LoadInteger(HT, id, 3)
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    
    call Set_Unit_Property(u, property, Get_Unit_Property(u, property) + value )
    
    if Player(pid) != p_enemy then
        call Stat_Refresh(pid)
    endif
    
    if time < 0.0 then
        call Timer_Clear(t)
    else
        call TimerStart(t, time, false, function Unit_Add_Stat_Func2)
    endif
    
    set t = null
    set u = null
endfunction

// value 는 얼마나 더할건지? time 은 지속시간
// time 음수면 영구적용
function Unit_Add_Stat takes unit u, real time, integer property, integer value, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, time)
    call SaveInteger(HT, id, 2, property)
    call SaveInteger(HT, id, 3, value)
    call TimerStart(t, delay, false, function Unit_Add_Stat_Func)
    
    set t = null
endfunction

private function Cooldown_Reset_Real_Time_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer skill_id = LoadInteger(HT, id, 1)
    local real duration = LoadReal(HT, id, 2)
    
    if duration <= 0.0 or JNGetUnitAbilityCooldownRemaining(u, skill_id) <= 0.01 then
        call UnitRemoveAbility(u, skill_id)
        call UnitAddAbility(u, skill_id)
        call Timer_Clear(t)
    else
        set duration = duration - 0.10
        call SaveReal(HT, id, 2, duration)
        call TimerStart(t, 0.10, false, function Cooldown_Reset_Real_Time_Func)
    endif
    
    set t = null
    set u = null
endfunction

function Cooldown_Reset_Real_Time takes unit u, integer skill_id, real duration returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, skill_id)
    call SaveReal(HT, id, 2, duration)
    call TimerStart(t, 0.0, false, function Cooldown_Reset_Real_Time_Func)
    
    set t = null
endfunction

private function Cooldown_Reset_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer skill_id = LoadInteger(HT, id, 1)
    
    call UnitRemoveAbility(u, skill_id)
    call UnitAddAbility(u, skill_id)
    
    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

function Cooldown_Reset takes unit u, integer skill_id, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, skill_id)
    call TimerStart(t, delay, false, function Cooldown_Reset_Func)
    
    set t = null
endfunction

private function Unit_Regen_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real interval = LoadReal(HT, id, 1)
    local integer tic = LoadInteger(HT, id, 2) - 1
    local real value = LoadReal(HT, id, 3)
    local boolean is_hp = LoadBoolean(HT, id, 4)

    if is_hp == true then
        call Set_HP(u, Get_HP(u) + value )
    else
        call Set_MP(u, Get_MP(u) + value )
    endif

    if tic <= 0 then
        call Timer_Clear(t)
    else
        call SaveInteger(HT, id, 2, tic)
        call TimerStart(t, interval, false, function Unit_Regen_Func)
    endif

    set t = null
    set u = null
endfunction


// flag 가 true면 HP 리젠, false면 MP 리젠
function Unit_Regen takes unit u, real interval, integer tic, real value, boolean is_hp, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, interval)
    call SaveInteger(HT, id, 2, tic)
    call SaveReal(HT, id, 3, value)
    call SaveBoolean(HT, id, 4, is_hp)
    
    call TimerStart(t, delay, false, function Unit_Regen_Func)
    
    set t = null
endfunction

function Distance_Between_Units takes unit u, unit c returns real
    local real dx = GetUnitX(u) - GetUnitX(c)
    local real dy = GetUnitY(u) - GetUnitY(c)
    return SquareRoot(dx * dx + dy * dy)
endfunction

// 마지막 unit c 는 null 처리
// 가장 가까운 적 뽑기
private function Closest_Unit_In_Group_Func takes unit u, group source_group, unit closest_unit returns unit
    local unit c
    local group g = CreateGroup()
    local location loc = GetUnitLoc(u)
    local location loc2 = Location(0, 0)
    local real min_dist = 100000.0
    
    call GroupAddGroup(source_group, g)
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            call RemoveLocation(loc2)
            set loc2 = GetUnitLoc(c)
            
            if DistanceBetweenPoints(loc, loc2) < min_dist then
                set min_dist = DistanceBetweenPoints(loc, loc2)
                set closest_unit = c
            endif
        endif
    endloop
    
    call RemoveLocation(loc)
    call RemoveLocation(loc2)
    call GroupClear( g )
    call DestroyGroup( g )
    set c = null
    set g = null
    set loc = null
    set loc2 = null
    return closest_unit
endfunction

function Closest_Unit_In_Group takes unit u, group source_group returns unit
    return Closest_Unit_In_Group_Func(u, source_group, null)
endfunction

function Closest_Angle takes unit u, real size returns real
    local real angle = GetUnitFacing(u)
    local group g = CreateGroup()
    local location loc = GetUnitLoc(u)
    local location loc2 = null
    local location loc3 = PolarProjectionBJ(loc, size + 1000, angle)
    local unit c = null

    call GroupEnumUnitsInRangeOfLoc( g, loc, size, null )
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            call RemoveLocation(loc2)
            set loc2 = GetUnitLoc(c)
            
            if DistanceBetweenPoints(loc, loc2) < DistanceBetweenPoints(loc, loc3) then
                call RemoveLocation(loc3)
                set loc3 = GetUnitLoc(c)
            endif
        endif
    endloop
    
    set angle = AngleBetweenPoints(loc, loc3)
    
    call RemoveLocation(loc)
    call RemoveLocation(loc2)
    call RemoveLocation(loc3)
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set c = null
    set loc = null
    set loc2 = null
    set loc3 = null
    return angle
endfunction

// 마지막 인자는 null 필수 기입
function Get_Ally_Group takes unit u, real x, real y, real range, group h returns group
    local group g = CreateGroup()
    local unit c = null
    
    set h = CreateGroup()
    
    call GroupEnumUnitsInRange(g, x, y, range, null)
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        if IsUnitAliveBJ(c) == true and IsPlayerAlly(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            call GroupAddUnit(h, c)
        endif
    endloop
    call GroupClear(g)
    call DestroyGroup(g)
    set c = null
    set g = null
    return h
endfunction

// Get_Enemy_Group
// 마지막 인자는 null 필수 기입
private function Get_Group_Func takes unit u, real x, real y, real range, group h returns group
    local group g = CreateGroup()
    local unit c = null
    
    set h = CreateGroup()
    
    call GroupEnumUnitsInRange(g, x, y, range, null)
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            call GroupAddUnit(h, c)
        endif
    endloop
    call GroupClear(g)
    call DestroyGroup(g)
    set c = null
    set g = null
    return h
endfunction

function Get_Group takes unit u, real x, real y, real range returns group
    return Get_Group_Func(u, x, y, range, null)
endfunction

private function Set_Unit_Void_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    
    call UnitRemoveType(u, UNIT_TYPE_MECHANICAL)

    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

private function Set_Unit_Void_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real time = LoadReal(HT, id, 1)
    
    call UnitAddType(u, UNIT_TYPE_MECHANICAL)
    
    call TimerStart(t, time, false, function Set_Unit_Void_Func2)
    
    set t = null
    set u = null
endfunction

function Set_Unit_Void takes unit u, real time, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, time)
    call TimerStart(t, delay, false, function Set_Unit_Void_Func)
    
    set t = null
endfunction

endlibrary