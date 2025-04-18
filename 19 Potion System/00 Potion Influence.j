library PotionInfluence requires GenericUnitEffect, GenericUnitUniversal

function Mana_Potion_Influence takes integer pid returns nothing
    local unit u = player_hero[pid].Get_Hero_Unit()
    local integer tic = 4
    local real value = (35 * JNGetUnitMaxMana(u)) / (100.0 * tic)
    
    call Effect_On_Unit(u, 1.0, 100, "origin", "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", 0.0)
    call Unit_Regen(u, 1.0, 4, value, false, 0.0)
    
    set u = null
endfunction

function Health_Potion_Influence takes integer pid returns nothing
    local unit u = player_hero[pid].Get_Hero_Unit()
    local integer tic = 4
    local real value = (30 * JNGetUnitMaxHP(u)) / (100.0 * tic)
    
    call Effect_On_Unit(u, 1.0, 100, "origin", "Abilities\\Spells\\Orc\\HealingWave\\HealingWaveTarget.mdl", 0.0)
    call Unit_Regen(u, 1.0, 4, value, true, 0.0)

    set u = null
endfunction

endlibrary