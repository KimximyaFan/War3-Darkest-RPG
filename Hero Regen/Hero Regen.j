library HeroRegen

globals
    private timer t = CreateTimer()
endglobals


private function Hero_Regen takes nothing returns nothing
    local integer i
    local unit u
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 5
        set u = Hero(i+1).Get_Hero_Unit()
        
        if IsUnitAliveBJ( u ) == true then
            call Set_HP(u, Get_HP(u) + Hero(i+1).Get_HP_REGEN() )
            call Set_MP(u, Get_MP(u) + Hero(i+1).Get_MP_REGEN() )
        endif
    endloop
    
    set u = null
endfunction

function Hero_Regen_Init takes nothing returns nothing
    call TimerStart(t, 1.0, true, function Hero_Regen)
endfunction

endlibrary