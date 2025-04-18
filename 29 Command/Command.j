library Command requires EquipRandomize, InvenGeneric, Stat

globals
    private unit motion_unit
    private integer global_motion
    
    private real test_field_x = -6221.0
    private real test_field_y = 7916.0
endglobals

private function Test_Zone takes nothing returns nothing
    call SetUnitX(player_hero[0].Get_Hero_Unit(), test_field_x)
    call SetUnitY(player_hero[0].Get_Hero_Unit(), test_field_y)
    call CreateFogModifierRectBJ( true, Player(0), FOG_OF_WAR_VISIBLE, gg_rct_TestZone )
endfunction

private function Set_Motion takes nothing returns nothing
    local string str = GetEventPlayerChatString()
    local integer motion = S2I(JNStringSplit(str, " ", 1))
    
    set global_motion = motion
    call BJDebugMsg(I2S(motion) + " 번 모션 세팅됨")
endfunction

private function Play_Motion takes nothing returns nothing
    local string str = GetEventPlayerChatString()
    local integer motion = S2I(JNStringSplit(str, " ", 1))
    
    call SetUnitAnimationByIndex(motion_unit, motion)
    call BJDebugMsg(I2S(motion) + " 번 모션 재생함")
endfunction

private function Set_Motion_Unit takes nothing returns nothing
    set motion_unit = GetTriggerUnit()
    //call BJDebugMsg("선택됨")
endfunction

private function Exp takes nothing returns nothing
    local string str = GetEventPlayerChatString()
    local integer value = S2I(JNStringSplit(str, " ", 1))
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    
    call AddHeroXP(player_hero[pid].Get_Hero_Unit(), value, true)

    set p = null
endfunction

private function Command_Set_Property takes nothing returns nothing
    local unit u = player_hero[0].Get_Hero_Unit()
    local integer pid = 0
    local string str = GetEventPlayerChatString()
    local string property_str = JNStringSplit(str, " ", 1)
    local integer value = S2I(JNStringSplit(str, " ", 2))
    local integer property = 0
    
    if property_str == "AD" then
        set property = AD
    elseif property_str == "AP" then
        set property = AP
    elseif property_str == "AS" then
        set property = AS
    elseif property_str == "MS" then
        set property = MS
    elseif property_str == "CRIT" then
        set property = CRIT
    elseif property_str == "CRIT_COEF" then
        set property = CRIT_COEF
    elseif property_str == "HP" then
        set property = HP
    elseif property_str == "MP" then
        set property = MP
    elseif property_str == "DEF_AD" then
        set property = DEF_AD
    elseif property_str == "DEF_AP" then
        set property = DEF_AP
    elseif property_str == "HP_REGEN" then
        set property = HP_REGEN
    elseif property_str == "MP_REGEN" then
        set property = MP_REGEN
    else
        call Simple_Msg( 0, "잘못된 명령어" )
        return
    endif
    
    call Set_Unit_Property(u, property, Get_Unit_Property(u, property) + value )
    call Stat_Refresh(pid)
    
    call Simple_Msg(0, property_str + " " + I2S(value) + " 오름" )
    
    set u = null
endfunction

private function View takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local string str = GetEventPlayerChatString()
    local integer value = S2I( SubString(str, 8, StringLength(str)) )
    
    if value < 80 or value > 150 then
        return
    endif
    
    call SetCameraFieldForPlayer( p, CAMERA_FIELD_TARGET_DISTANCE, 20 * value, 0.25 )
    
    set p = null
endfunction

private function Suicide takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local integer pid = GetPlayerId(p)
    local unit u = Hero(pid+1).Get_Hero_Unit()
    
    if Get_Unit_Property(u, IN_COURTYARD) == 0 then
        call KillUnit(u)
    endif

    set u = null
endfunction

// 돈치트
private function Money takes nothing returns nothing
    call AdjustPlayerStateBJ( 900000, GetTriggerPlayer(), PLAYER_STATE_RESOURCE_GOLD )
endfunction

function Command_Init takes nothing returns nothing
    local integer i
    local trigger trg
    
    set trg = CreateTrigger()
    // 자살
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 5
        call TriggerRegisterPlayerChatEvent(trg, Player(i), "-자살", true)
    endloop
    call TriggerAddAction( trg, function Suicide )
    
    // 시야
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 3
        set trg = CreateTrigger()
        call TriggerRegisterPlayerChatEvent(trg, Player(i), "-시야", false)
        call TriggerAddAction( trg, function View )
    endloop
    
    
    
    if is_Test == false then
        return
    endif
    
    
    if is_Test == true then
        // 돈
        set trg = CreateTrigger()
        call TriggerRegisterPlayerChatEvent(trg, Player(0), "-돈", true)
        call TriggerAddAction( trg, function Money )
        
            
        // 경험치
        set trg = CreateTrigger()
        call TriggerRegisterPlayerChatEvent(trg, Player(0), "-경험치 ", false)
        call TriggerAddAction( trg, function Exp )
    endif
    
    set trg = CreateTrigger()
    call TriggerRegisterPlayerChatEvent(trg, Player(0), "-Set ", false)
    call TriggerAddAction( trg, function Command_Set_Property )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterPlayerSelectionEventBJ( trg, Player(0), true )
    call TriggerAddAction( trg, function Set_Motion_Unit )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterPlayerChatEvent( trg, Player(0), "-motion ", false )
    call TriggerAddAction( trg, function Play_Motion )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterPlayerChatEvent( trg, Player(0), "-set_motion ", false )
    call TriggerAddAction( trg, function Set_Motion )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterPlayerChatEvent( trg, Player(0), "테스트", false )
    call TriggerAddAction( trg, function Test_Zone )
    
    set trg = null
endfunction

endlibrary