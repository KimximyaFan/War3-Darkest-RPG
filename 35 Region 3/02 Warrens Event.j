library WarrensEvent requires WarrensGeneric

globals
    private rect array restricted_rect
    private trigger trg
endglobals

private function Boss_Death takes nothing returns nothing
    local unit c
    call Trigger_Clear(GetTriggeringTrigger())
    
    set c = CreateUnit(Player(15), 'e000', 14541, -9692, 270)
    call SetUnitScale(c, 1.0, 1.0, 1.0)
    call DzSetUnitModel(c, "B_0013.mdx")
    
    set c = CreateUnit(Player(15), 'e000', 15520, -8836, 270)
    call SetUnitScale(c, 1.0, 1.0, 1.0)
    call DzSetUnitModel(c, "B_0013.mdx")

    call Simple_Potal_Create(14541, -9692, 15182, -8645)
    call Simple_Potal_Create(15520, -8836, 14245, -9967)
    
    set c = null
endfunction

private function Tower_Death_1 takes nothing returns nothing
    if CountUnitsInGroup(WarrensGeneric_tower_group2) != 0 then
        call GroupRemoveUnit(WarrensGeneric_tower_group2, GetTriggerUnit())
        
        if CountUnitsInGroup(WarrensGeneric_tower_group2) == 0 then
            call Msg("보이지않는 벽 제거됨", 0)
        else
            call Msg("남은 타워 갯수 : " + I2S(CountUnitsInGroup(WarrensGeneric_tower_group2)) + "\n\n", 0)
            return
        endif
    endif
    
    call Trigger_Clear(GetTriggeringTrigger())
    
    call Simple_Potal_Remove(17)
    call RemoveRect(restricted_rect[1])
    set restricted_rect[1] = null
endfunction

private function Tower_Death_0 takes nothing returns nothing
    if CountUnitsInGroup(WarrensGeneric_tower_group) != 0 then
        call GroupRemoveUnit(WarrensGeneric_tower_group, GetTriggerUnit())
        
        if CountUnitsInGroup(WarrensGeneric_tower_group) != 0 then
            return
        endif
    endif
    
    call Trigger_Clear(GetTriggeringTrigger())
    
    call Simple_Potal_Remove(16)
    call RemoveRect(restricted_rect[0])
    set restricted_rect[0] = null
endfunction

private function Restrict_Potal_Init takes nothing returns nothing
    set restricted_rect[0] = Create_Rect(4447, -15457, 200, 800)
    call Simple_Potal_Create_Rect(restricted_rect[0], 4049, -15142)

    set restricted_rect[1] = Create_Rect(10967, -11202, 200, 800)
    call Simple_Potal_Create_Rect(restricted_rect[1], 10460, -11524)
endfunction

private function Boss_Death_Con takes nothing returns boolean
    return GetTriggerUnit() == WarrensGeneric_region_boss
endfunction

private function Tower_Death_Con_1 takes nothing returns boolean
    return IsUnitInGroup(GetTriggerUnit(), WarrensGeneric_tower_group2)
endfunction

private function Tower_Death_Con_0 takes nothing returns boolean
    return IsUnitInGroup(GetTriggerUnit(), WarrensGeneric_tower_group)
endfunction

private function Trigger_Init takes nothing returns nothing
    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, p_enemy, EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerAddCondition( trg, Condition( function Boss_Death_Con ) )
    call TriggerAddAction( trg, function Boss_Death )
    
    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, p_enemy, EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerAddCondition( trg, Condition( function Tower_Death_Con_0 ) )
    call TriggerAddAction( trg, function Tower_Death_0 )
    
    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, p_enemy, EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerAddCondition( trg, Condition( function Tower_Death_Con_1 ) )
    call TriggerAddAction( trg, function Tower_Death_1 )
endfunction

function Warrens_Event_Init takes nothing returns nothing
    call Trigger_Init()
    call Restrict_Potal_Init()
endfunction

endlibrary