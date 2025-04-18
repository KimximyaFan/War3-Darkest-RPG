/*
scope Shadow initializer Skills_Init

globals
    private real Q_BASE_DMG = 20
    private real W_BASE_DMG = 20
    private real E_BASE_DMG = 20
    private real R_BASE_DMG = 20
    private real C_BASE_DMG = 20
endglobals

private function V_Act takes nothing returns nothing

endfunction

private function C_Act takes nothing returns nothing

endfunction

private function X_Act takes nothing returns nothing

endfunction

private function Z_Act takes nothing returns nothing

endfunction

private function R_Act takes nothing returns nothing

endfunction

private function E_Act takes nothing returns nothing

endfunction

private function W_Act takes nothing returns nothing

endfunction

private function Q_Act takes nothing returns nothing

endfunction

private function V_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01R'
endfunction

private function C_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01Q'
endfunction

private function X_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01P'
endfunction

private function Z_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01O'
endfunction

private function R_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01N'
endfunction

private function E_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01M'
endfunction

private function W_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01L'
endfunction

private function Q_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01K'
endfunction

private function Skills_Init takes nothing returns nothing
    local trigger trg

    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function Q_Con ) )
    call TriggerAddAction( trg, function Q_Act )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function W_Con ) )
    call TriggerAddAction( trg, function W_Act )
    
    set trg = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( trg, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function E_Con ) )
    call TriggerAddAction( trg, function E_Act )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function R_Con ) )
    call TriggerAddAction( trg, function R_Act )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function Z_Con ) )
    call TriggerAddAction( trg, function Z_Act )

    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function X_Con ) )
    call TriggerAddAction( trg, function X_Act )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function C_Con ) )
    call TriggerAddAction( trg, function C_Act )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function V_Con ) )
    call TriggerAddAction( trg, function V_Act )

    set trg = null
endfunction

endscope
*/