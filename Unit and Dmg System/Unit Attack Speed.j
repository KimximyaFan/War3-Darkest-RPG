library UnitAttackSpeed requires Base

globals
    private integer array atk_speed
endglobals

private function Remove_All_Ability takes unit u returns nothing
    local integer i = -1
    
    loop
    set i = i + 1
    exitwhen i > 9
        call UnitRemoveAbility(u, atk_speed[i])
    endloop
endfunction

function Set_Hero_Atk_Speed takes unit u, integer value returns nothing
    local integer i = -1
    local real attack_cooldown
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    
    if Player(pid) == p_enemy then
        set attack_cooldown = LoadReal(HT, GetUnitTypeId(u), ATTACK_COOLDOWN)
    else
        set attack_cooldown = LoadReal(HT, GetHandleId(u), ATTACK_COOLDOWN)
    endif
    
    call Remove_All_Ability(u)
    
    if value <= 0 then
        return
    endif
    
    if value > 400 then
        call JNSetUnitAttackCooldown(u, attack_cooldown/2, 1)
        set value = ((value - 100) / 2)
    else
        call JNSetUnitAttackCooldown(u, attack_cooldown, 1)
    endif
    
    loop
    set i = i + 1
    exitwhen value <= 0
        if Mod(value, 2) == 1 then
            call UnitAddAbility(u, atk_speed[i])
        endif
        
        set value = value / 2
    endloop
endfunction

function Set_Unit_Atk_Speed takes unit u, integer value returns nothing
    local integer i = -1
    local real attack_cooldown
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    
    if Player(pid) == p_enemy then
        set attack_cooldown = LoadReal(HT, GetUnitTypeId(u), ATTACK_COOLDOWN)
    else
        set attack_cooldown = LoadReal(HT, GetHandleId(u), ATTACK_COOLDOWN)
    endif
    
    call Remove_All_Ability(u)
    
    if value <= 0 then
        return
    endif
    
    if value > 400 then
        call JNSetUnitAttackCooldown(u, attack_cooldown/2, 1)
        set value = ((value - 100) / 2)
    else
        call JNSetUnitAttackCooldown(u, attack_cooldown, 1)
    endif
    
    
    loop
    set i = i + 1
    exitwhen value <= 0
        if Mod(value, 2) == 1 then
            call UnitAddAbility(u, atk_speed[i])
        endif
        
        set value = value / 2
    endloop
endfunction

function Unit_Attack_Speed_Init takes nothing returns nothing
    set atk_speed[0] = 'A001'
    set atk_speed[1] = 'A002'
    set atk_speed[2] = 'A003'
    set atk_speed[3] = 'A004'
    set atk_speed[4] = 'A005'
    set atk_speed[5] = 'A006'
    set atk_speed[6] = 'A007'
    set atk_speed[7] = 'A008'
    set atk_speed[8] = 'A009'
    set atk_speed[9] = 'A00A'
endfunction

endlibrary