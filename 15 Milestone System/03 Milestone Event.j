library MilestoneEvent requires MilestoneReward

globals
    private trigger array quest_trg
    unit quest_bandit_lord
    unit quest_granite_golem
    unit quest_first_abomination
    unit quest_second_abomination
endglobals

private function Quest_Target_Death takes unit target_monster, integer quest_index returns nothing
    local real size = 1500
    local group g = CreateGroup()
    local unit c
    local integer pid
    
    call GroupEnumUnitsInRange(g, GetUnitX(target_monster), GetUnitY(target_monster), 1500, null)
    loop
    set c = FirstOfGroup(g)
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitType(c, UNIT_TYPE_HERO) == true then
            set pid = GetPlayerId(GetOwningPlayer(c))
            
            if milestone[pid] == quest_index then
                call Give_Milestone_Reward(pid)
            endif
        endif
    endloop
    
    call DestroyGroup(g)
    
    set g = null
    set c = null
endfunction

private function Quest_Target_Region takes unit u, integer quest_index returns nothing
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    
    if milestone[pid] != quest_index then
        return
    endif
    
    call Give_Milestone_Reward(pid)
endfunction

private function Quest_Clear takes nothing returns nothing
    local trigger triggering_trg = GetTriggeringTrigger()
    local integer i
    local integer index = -1
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= QUEST_COUNT
        if triggering_trg == quest_trg[i] then
            set index = i
            set i = QUEST_COUNT
        endif
    endloop
    
    if GetTriggerEventId() == EVENT_GAME_ENTER_REGION then
        call Quest_Target_Region(GetTriggerUnit(), index)
    elseif GetTriggerEventId() == EVENT_UNIT_DEATH then
        call Quest_Target_Death(GetTriggerUnit(), index)
    elseif GetTriggerEventId() == EVENT_PLAYER_UNIT_DEATH then
        call Quest_Target_Death(GetTriggerUnit(), index)
    endif
    
    
    set triggering_trg = null
endfunction

private function Boss_Death_Con takes nothing returns boolean
    return GetTriggerUnit() == CoveGeneric_region_boss
endfunction

private function Quest_Trigger_Init takes nothing returns nothing
    local integer i = -1
    
    // function 변경, rect 변경
    
    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterEnterRectSimple( quest_trg[i], PotalEvent_region_potal_rect[0] )
    call TriggerAddCondition( quest_trg[i], Condition( function Hero_Check ) )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )
    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterUnitEvent( quest_trg[i], quest_bandit_lord, EVENT_UNIT_DEATH )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )
    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterEnterRectSimple( quest_trg[i], Create_Rect(-11861, -15114, 400, 200) )
    call TriggerAddCondition( quest_trg[i], Condition( function Hero_Check ) )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )
    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterUnitEvent( quest_trg[i], quest_granite_golem, EVENT_UNIT_DEATH )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )
    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterEnterRectSimple( quest_trg[i], Create_Rect(-9240, -5350, 150, 600) )
    call TriggerAddCondition( quest_trg[i], Condition( function Hero_Check ) )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )
    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterUnitEvent( quest_trg[i], WealdInit_region_boss, EVENT_UNIT_DEATH )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )

    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterEnterRectSimple( quest_trg[i], PotalEvent_region_potal_rect[3] )
    call TriggerAddCondition( quest_trg[i], Condition( function Hero_Check ) )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )
    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterEnterRectSimple( quest_trg[i], PotalEvent_region_potal_rect[4] )
    call TriggerAddCondition( quest_trg[i], Condition( function Hero_Check ) )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )
    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterEnterRectSimple( quest_trg[i], Create_Rect(-7812, -7353, 150, 600) )
    call TriggerAddCondition( quest_trg[i], Condition( function Hero_Check ) )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )
    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterUnitEvent( quest_trg[i], RuinsGeneric_region_boss, EVENT_UNIT_DEATH )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )

    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterEnterRectSimple( quest_trg[i], PotalEvent_region_potal_rect[6] )
    call TriggerAddCondition( quest_trg[i], Condition( function Hero_Check ) )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )
    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterUnitEvent( quest_trg[i], quest_first_abomination, EVENT_UNIT_DEATH )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )
    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterEnterRectSimple( quest_trg[i], PotalEvent_region_potal_rect[7] )
    call TriggerAddCondition( quest_trg[i], Condition( function Hero_Check ) )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )
    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterUnitEvent( quest_trg[i], quest_second_abomination, EVENT_UNIT_DEATH )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )
    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterEnterRectSimple( quest_trg[i], PotalEvent_region_potal_rect[8] )
    call TriggerAddCondition( quest_trg[i], Condition( function Hero_Check ) )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )
    set i = i + 1 
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterEnterRectSimple( quest_trg[i], Create_Rect(10959, -11235, 150, 700) )
    call TriggerAddCondition( quest_trg[i], Condition( function Hero_Check ) )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )
    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterUnitEvent( quest_trg[i], WarrensGeneric_region_boss, EVENT_UNIT_DEATH )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )
    
    
    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterEnterRectSimple( quest_trg[i], PotalEvent_region_potal_rect[9] )
    call TriggerAddCondition( quest_trg[i], Condition( function Hero_Check ) )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )
    set i = i + 1
    set quest_trg[i] = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(quest_trg[i], p_enemy, EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerAddCondition( quest_trg[i], Condition( function Boss_Death_Con ) )
    call TriggerAddAction( quest_trg[i], function Quest_Clear )

endfunction

function Milestone_Event_Init takes nothing returns nothing
    call Quest_Trigger_Init()
endfunction

endlibrary