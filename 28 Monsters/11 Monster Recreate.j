
library MonsterRegen requires Base, MonsterRegister



private function Monster_Regen_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local integer count = LoadInteger(HT, id, 0)
    local integer unit_id = LoadInteger(HT_Monster_Regen, count, 0)
    local real x = LoadReal(HT_Monster_Regen, count, 1)
    local real y = LoadReal(HT_Monster_Regen, count, 2)
    local boolean is_grade = LoadBoolean(HT_Monster_Regen, count, 3)
    local unit c
    
    set c = CreateUnit(p_enemy, unit_id, x, y, GetRandomDirectionDeg())
    call SetUnitUserData(c, count)
    call Monster_Property_Register(c, is_grade)
    
    call Timer_Clear(t)
    
    set t = null
    set c = null
endfunction

function Monster_Regen takes unit monster returns nothing
    local timer t = null
    local integer id = 0
    local integer count = GetUnitUserData(monster)
    local integer max_regen
    
    if HaveSavedInteger(HT_Monster_Regen, count, 0) == false then
        return
    endif
    // LoadReal(HT_Monster_Regen, count, 5) 이건 Monster Dispose에서 해쉬테이블에 max_regen 값으로 등록됨
    set max_regen = LoadInteger(HT_Monster_Regen, count, 5)
    
    if max_regen <= 0 then
        return
    endif
    
    call SaveInteger(HT_Monster_Regen, count, 5, max_regen - 1)
    
    set t = CreateTimer()
    set id  = GetHandleId(t)
    
    // LoadReal(HT_Monster_Regen, count, 4) 이건 Monster Dispose에서 해쉬테이블에 regen_time 값으로 등록됨
    
    call SaveInteger(HT, id, 0, count)
    call TimerStart(t, LoadReal(HT_Monster_Regen, count, 4), false, function Monster_Regen_Func)
    
    set t = null
endfunction


endlibrary
