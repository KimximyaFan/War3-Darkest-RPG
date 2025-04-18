library PlayerDodge

private function Player_Dodge takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId( p )
    local string str = I2S(pid + 1) + " 번 플레이어 나감"
    
    call RemoveUnit( player_hero[pid].Get_Hero_Unit() )
    
    call BJDebugMsg(str)
endfunction

function Player_Dodge_Init takes nothing returns nothing
    local trigger trg
    set trg = CreateTrigger(  )
    call TriggerRegisterPlayerEventLeave( trg, Player(0) )
    call TriggerRegisterPlayerEventLeave( trg, Player(1) )
    call TriggerRegisterPlayerEventLeave( trg, Player(2) )
    call TriggerRegisterPlayerEventLeave( trg, Player(3) )
    call TriggerAddAction( trg, function Player_Dodge )
    set trg = null
endfunction

endlibrary