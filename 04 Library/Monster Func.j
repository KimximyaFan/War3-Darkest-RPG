// Monster
library MonsterFunc

function Monster_Pause_Add takes unit u, real time returns nothing
    local integer id = GetHandleId(u)
    call SaveRealBJ(time, PAUSE, id, HT)
endfunction

function Monster_Pause_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandleBJ(0, id, HT)
    
    call PauseUnit(u, false)
    call FlushChildHashtableBJ(id, HT)
    call DestroyTimer(t)
    
    set t = null
    set u = null
endfunction

function Monster_Pause_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandleBJ(0, id, HT)
    local integer id2 = GetHandleId(u)
    
    if HaveSavedReal(HT, id2, PAUSE) == true then
        call TimerStart(t, LoadRealBJ(PAUSE, id2, HT), false, function Monster_Pause_Func2)
        call RemoveSavedReal(HT, id2, PAUSE)
    else
        call PauseUnit(u, false)
        call FlushChildHashtableBJ(id, HT)
        call DestroyTimer(t)
    endif
    
    set t = null
    set u = null
endfunction

function Monster_Pause takes unit u, real time returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call PauseUnit(u, true)
    
    call SaveUnitHandleBJ(u, 0, id, HT)
    call TimerStart(t, time, false, function Monster_Pause_Func)
    
    set t = null
endfunction

endlibrary