library DmgEngineRegister initializer Init requires Base, BasicAttack, DmgText

function Dmg_Event_Occured takes nothing returns nothing
    local unit u = GetEventDamageSource()
    local unit target = GetTriggerUnit()
    local real dmg = GetEventDamage()
    local attacktype attack_type = JNGetEventAttackType()
    
    call Basic_Attack(u, target, attack_type)
    call Dmg_Text(u, target, dmg, attack_type)
    
    set u = null
    set target = null
    set attack_type = null
endfunction


private function Init takes nothing returns nothing
    call DERegisterAnyUnitAttackEvent( function Dmg_Event_Occured )
endfunction

endlibrary