library HeroLevelUp requires Stat, HeroSkillAdd

private function Hero_Level_Up takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    
    call player_hero[pid].Level_Up_Property_Apply()
    call Hero_Check_Level_for_Skill_Add(u)
    
    call Set_HP( u, JNGetUnitMaxHP(u) )
    call Set_MP( u, JNGetUnitMaxMana(u) )
    
    call Stat_Refresh(pid)
    
    set u = null
endfunction

private function Hero_Level_Up_Trigger_Init takes nothing returns nothing
    local trigger trg
    
    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg, EVENT_PLAYER_HERO_LEVEL )
    call TriggerAddAction( trg, function Hero_Level_Up )
    
    set trg = null
endfunction

function Hero_Level_Up_Init takes nothing returns nothing
    call Hero_Level_Up_Trigger_Init()
    call Hero_Skill_Table_Init()
endfunction

endlibrary