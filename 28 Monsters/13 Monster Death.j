
library MonsterDeath requires Base, MonsterRegen, MonsterDrop, MonsterExp, UnitProperty

private function Monster_Death takes nothing returns nothing
    local unit monster = GetTriggerUnit()
    local unit killing_unit = GetKillingUnit()
    
    if Get_Unit_Property(monster, IS_FORCED_DEATH) == 0 then
        call Monster_Regen( monster )
        call Monster_Equip_Drop( monster, killing_unit )
        call Monster_Potion_Drop( monster, killing_unit )
        call Monster_Exp(monster, killing_unit)
        call Monster_Gold_Drop(monster, killing_unit)
    endif
    
    call Grade_Text_Tag_Unregister(monster)
    call Set_Unit_Property(monster, IN_COMBAT, 0)
    call Set_Unit_Property(monster, IN_COURTYARD, 0)
    call Set_Unit_Property(monster, IS_FORCED_DEATH, 0)

    call UnitApplyTimedLifeBJ( 0.02, 'BHwe', monster )
    
    set monster = null
    set killing_unit = null
endfunction

function Monster_Death_Init takes nothing returns nothing
    local trigger trg
    
    // 기존 워크 경험치 시스템 0으로
    call Disable_Existing_Experience_System()
    
    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, Player(12), EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerAddAction( trg, function Monster_Death )
    
    set trg = null
endfunction

endlibrary
