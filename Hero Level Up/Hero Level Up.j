library HeroLevelUp requires Stat, HeroSkillAdd

private function Hero_Level_Up takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    local Hero current_hero = Get_Unit_Property(u, HERO)
    
    //call player_hero[pid].Level_Up_Property_Apply()
    call Hero_Check_Level_for_Skill_Add(u)
    
    call current_hero.Stat_Point_Calculate()
    
    call Set_HP( u, JNGetUnitMaxHP(u) )
    call Set_MP( u, JNGetUnitMaxMana(u) )
    
    if current_hero == player_hero[pid] then
        call Stat_Refresh(pid)
        call Stat_Point_Frame_Refresh(pid)
    endif
    
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