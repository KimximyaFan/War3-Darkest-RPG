
library MonsterDispose requires MonsterRegister, Basic

globals
    /*
        행 : count값
        열 0 : unit id
        열 1 : x
        열 2 : y
    */
    private integer count = 0
    private integer count_how_many_dispose_function_called = 0
endglobals

function Print_Dispose_Called takes nothing returns nothing
    call Msg("Dispose 호출 횟수 : " + I2S(count_how_many_dispose_function_called), 0.0)
endfunction

// regen_time 이 0 이하면 리젠 안함
function Dispose takes integer unit_id, real x, real y, boolean is_grade, integer regen_time returns unit
    local unit c
    local integer max_regen = 4
    
    set count_how_many_dispose_function_called = count_how_many_dispose_function_called + 1
    set c = CreateUnit(p_enemy, unit_id, x, y, GetRandomDirectionDeg())
    
    if regen_time > 0 then
        set count = count + 1
        
        call SetUnitUserData(c, count)
        call SaveInteger(HT_Monster_Regen, count, 0, unit_id)
        call SaveReal(HT_Monster_Regen, count, 1, x)
        call SaveReal(HT_Monster_Regen, count, 2, y)
        call SaveBoolean(HT_Monster_Regen, count, 3, is_grade)
        call SaveReal(HT_Monster_Regen, count, 4, regen_time)
        call SaveInteger(HT_Monster_Regen, count, 5, max_regen)
    endif
    
    call Monster_Property_Register(c, is_grade)
    
    return c
endfunction

endlibrary
