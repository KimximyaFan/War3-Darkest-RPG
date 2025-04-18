library RuinsEvent requires SimplePotal

globals
    private rect array restricted_rect
    private trigger trg
endglobals



private function Boss_Death takes nothing returns nothing
    local unit c
    
    call Trigger_Clear(GetTriggeringTrigger())
    
    set c = CreateUnit(Player(15), 'e000', -14528, -7175, 270)
    call SetUnitScale(c, 1.0, 1.0, 1.0)
    call DzSetUnitModel(c, "B_0013.mdx")
    
    set c = CreateUnit(Player(15), 'e000', 5944, -4250, 270)
    call SetUnitScale(c, 1.0, 1.0, 1.0)
    call DzSetUnitModel(c, "B_0013.mdx")

    call Simple_Potal_Create(-14528, -7175, 6138, -4456)
    call Simple_Potal_Create(5944, -4250, -14530, -7587)
    
    set c = null
endfunction

private function Tower_Death_4 takes nothing returns nothing
    if CountUnitsInGroup(RuinsGeneric_tower_group_3) != 0 then
        call GroupRemoveUnit(RuinsGeneric_tower_group_3, GetTriggerUnit())
        
        if CountUnitsInGroup(RuinsGeneric_tower_group_3) != 0 then
            return
        endif
    endif
    
    call Trigger_Clear(GetTriggeringTrigger())
    
    call Simple_Potal_Remove(12)
    call RemoveRect(restricted_rect[4])
    set restricted_rect[4] = null
endfunction

private function Tower_Death_3 takes nothing returns nothing
    if CountUnitsInGroup(RuinsGeneric_tower_group_2) != 0 then
        call GroupRemoveUnit(RuinsGeneric_tower_group_2, GetTriggerUnit())
        
        if CountUnitsInGroup(RuinsGeneric_tower_group_2) != 0 then
            return
        endif
    endif
    
    call Trigger_Clear(GetTriggeringTrigger())
    
    call Simple_Potal_Remove(11)
    call RemoveRect(restricted_rect[3])
    set restricted_rect[3] = null
endfunction

private function Tower_Death_2 takes nothing returns nothing
    if CountUnitsInGroup(RuinsGeneric_tower_group) != 0 then
        call GroupRemoveUnit(RuinsGeneric_tower_group, GetTriggerUnit())
        
        if CountUnitsInGroup(RuinsGeneric_tower_group) == 0 then
            call Msg("보이지않는 벽 제거됨", 0)
        else
            call Msg("남은 타워 갯수 : " + I2S(CountUnitsInGroup(RuinsGeneric_tower_group)) + "\n\n", 0)
            return
        endif
    endif
    
    call Trigger_Clear(GetTriggeringTrigger())
    
    call Simple_Potal_Remove(10)
    call RemoveRect(restricted_rect[2])
    set restricted_rect[2] = null
endfunction

private function Tower_Death_1 takes nothing returns nothing
    if IsUnitAliveBJ(RuinsGeneric_region_unit[2]) == true or IsUnitAliveBJ(RuinsGeneric_region_unit[3]) == true then
        return
    endif
    
    call Trigger_Clear(GetTriggeringTrigger())
    
    call Simple_Potal_Remove(9)
    call RemoveRect(restricted_rect[1])
    set restricted_rect[1] = null
endfunction

private function Tower_Death_0 takes nothing returns nothing
    if IsUnitAliveBJ(RuinsGeneric_region_unit[0]) == true or IsUnitAliveBJ(RuinsGeneric_region_unit[1]) == true then
        return
    endif
    
    call Trigger_Clear(GetTriggeringTrigger())
    
    call Simple_Potal_Remove(8)
    call RemoveRect(restricted_rect[0])
    set restricted_rect[0] = null
endfunction

private function Restrict_Potal_Init takes nothing returns nothing
    set restricted_rect[0] = Create_Rect(-2366, -13438, 800, 200)
    call Simple_Potal_Create_Rect(restricted_rect[0], -2415, -14154)
    
    set restricted_rect[1] = Create_Rect(-6848, -8905, 800, 200)
    call Simple_Potal_Create_Rect(restricted_rect[1], -6843, -9368)
    
    set restricted_rect[2] = Create_Rect(-7238, -7352, 200, 800)
    call Simple_Potal_Create_Rect(restricted_rect[2], -6845, -7345)
    
    set restricted_rect[3] = Create_Rect(-10689, -9574, 800, 200)
    call Simple_Potal_Create_Rect(restricted_rect[3], -10688, -10016)
    
    set restricted_rect[4] = Create_Rect(-11689, -7332, 200, 800)
    call Simple_Potal_Create_Rect(restricted_rect[4], -11243, -7349)
endfunction

private function Boss_Death_Con takes nothing returns boolean
    return GetTriggerUnit() == RuinsGeneric_region_boss
endfunction

private function Tower_Death_Con_4 takes nothing returns boolean
    return IsUnitInGroup(GetTriggerUnit(), RuinsGeneric_tower_group_3)
endfunction

private function Tower_Death_Con_3 takes nothing returns boolean
    return IsUnitInGroup(GetTriggerUnit(), RuinsGeneric_tower_group_2)
endfunction

private function Tower_Death_Con_2 takes nothing returns boolean
    return IsUnitInGroup(GetTriggerUnit(), RuinsGeneric_tower_group)
endfunction

private function Tower_Death_Con_1 takes nothing returns boolean
    return GetTriggerUnit() == RuinsGeneric_region_unit[2] or GetTriggerUnit() == RuinsGeneric_region_unit[3]
endfunction

private function Tower_Death_Con_0 takes nothing returns boolean
    return GetTriggerUnit() == RuinsGeneric_region_unit[0] or GetTriggerUnit() == RuinsGeneric_region_unit[1]
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
    
    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, p_enemy, EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerAddCondition( trg, Condition( function Tower_Death_Con_2 ) )
    call TriggerAddAction( trg, function Tower_Death_2 )
    
    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, p_enemy, EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerAddCondition( trg, Condition( function Tower_Death_Con_3 ) )
    call TriggerAddAction( trg, function Tower_Death_3 )
    
    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, p_enemy, EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerAddCondition( trg, Condition( function Tower_Death_Con_4 ) )
    call TriggerAddAction( trg, function Tower_Death_4 )
endfunction

function Ruins_Event_Init takes nothing returns nothing
    call Trigger_Init()
    call Restrict_Potal_Init()
endfunction

endlibrary