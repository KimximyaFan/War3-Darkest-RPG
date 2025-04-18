scope Test initializer Init

globals
    multiboard temp_mb
    real array test_r
endglobals

private function Test_Potal takes nothing returns nothing
    call Simple_Potal_Create(15000, 15000, 15000, 15000)
endfunction

private function test2 takes nothing returns nothing
    local unit u = player_hero[0].Get_Hero_Unit()
    local string str = GetEventPlayerChatString()
    local real value = S2R(JNStringSplit(str, " ", 1))
    
    call JNSetUnitManaRegen(u, value)
    
    call Msg2("mana_regen : " + R2S(value))
    
    set u = null
endfunction

private function test takes nothing returns nothing
    local unit u = player_hero[0].Get_Hero_Unit()
    local string str = GetEventPlayerChatString()
    local real value = S2R(JNStringSplit(str, " ", 1))
    
    call JNSetUnitHPRegen(u, value)
    
    call Msg2("hp_regen : " + R2S(value))
    
    set u = null
endfunction

private function test_init takes nothing returns nothing
    local trigger trg
    
    set trg = CreateTrigger()
    call TriggerRegisterPlayerChatEvent(trg, Player(0), "h ", false)
    call TriggerAddAction( trg, function test )
    
    set trg = CreateTrigger()
    call TriggerRegisterPlayerChatEvent(trg, Player(0), "m ", false)
    call TriggerAddAction( trg, function test2 )
    
    set trg = null
endfunction

private function Test_Real_Show takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer i = -1
    
    loop
    set i = i + 1
    exitwhen i > 5
        call Msg_One(p, 15, R2S(test_r[i]), 0)
    endloop
    
    set p = null
endfunction

private function Test_Real takes nothing returns nothing
    local string str = GetEventPlayerChatString()
    local integer i = S2I(JNStringSplit(str, "/", 1))
    local real value = S2R(JNStringSplit(str, "/", 2))
    
    set test_r[i] = value
    
    call test()
endfunction


private function Loc_Leak takes nothing returns nothing
    local location loc = GetUnitLoc(player_hero[0].Get_Hero_Unit())
    call RemoveLocation(loc)
    set loc = null
endfunction
// player 타입은 null 처리 안해도 됨
private function Leak takes nothing returns nothing
    local multiboarditem mbitem = null
    
    set mbitem = MultiboardGetItem(temp_mb, 0, 0) 
    //call MultiboardReleaseItem(mbitem)
endfunction

private function Memory_Lick_Test takes nothing returns nothing
    set temp_mb = CreateMultiboard()
    call TimerStart(CreateTimer(), 0.02, true, function Leak)
    
    call BJDebugMsg("시작")
endfunction

private function Init takes nothing returns nothing
    local trigger trg
    
    call test_init()
    call Test_Potal()
    
    if is_Test == false then
        return
    endif
    
    // test real
    set trg = CreateTrigger()
    call TriggerRegisterPlayerChatEvent(trg, Player(0), "test_m", false)
    call TriggerAddAction( trg, function Memory_Lick_Test )
    
    // test real
    set trg = CreateTrigger()
    call TriggerRegisterPlayerChatEvent(trg, Player(0), "test_r", false)
    call TriggerAddAction( trg, function Test_Real )
    
    // test real show
    set trg = CreateTrigger()
    call TriggerRegisterPlayerChatEvent(trg, Player(0), "test_show", true)
    call TriggerAddAction( trg, function Test_Real_Show )
    
    set trg = null
endfunction

endscope