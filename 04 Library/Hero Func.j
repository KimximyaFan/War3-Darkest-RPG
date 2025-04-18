library HeroFunc



function Hero_Pause_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real time = LoadReal(HT, id, 1)
    local unit c = CreateUnit( GetOwningPlayer(u), 'h005', GetUnitX(u), GetUnitY(u), 0 )
    
    call UnitAddAbility(c, 'A00F')
    call IssueTargetOrderBJ( c, "magicleash", u )
    call UnitApplyTimedLifeBJ( time, 'BHwe', c )
    
    call Timer_Clear(t)
    
    set t = null
    set u = null
    set c = null
endfunction

function Hero_Pause takes unit u, real time, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, time)
    
    call TimerStart(t, delay, false, function Hero_Pause_Func)
    
    set t = null
endfunction

endlibrary