library CoveEvent requires CoveGeneric, CoveMonster, CurrentDifficulty

globals
    private integer count = 0
endglobals

private function Boss_Death takes nothing returns nothing
    local unit c
    call Trigger_Clear(GetTriggeringTrigger())
    
    set c = CreateUnit(Player(15), 'e000', 10272, 145, 270)
    call SetUnitScale(c, 1.0, 1.0, 1.0)
    call DzSetUnitModel(c, "B_0013.mdx")
    
    set c = CreateUnit(Player(15), 'e000', 519, 12, 270)
    call SetUnitScale(c, 1.0, 1.0, 1.0)
    call DzSetUnitModel(c, "B_0013.mdx")

    call Simple_Potal_Create(10272, 145, 14060, 3340)
    call Simple_Potal_Create(519, 12, 14060, 3340)
    
    call Current_Difficulty_Cleared()
    
    call BJDebugMsg("어두운 던전으로 향하는 포탈이 열렸다...\n\n")
    call BJDebugMsg("해당 던전은 중앙 마을을 통해서도 갈 수 있다")
    call PlaySoundBJ(gg_snd_BattleNetDoorsStereo2)
    
    set c = null
endfunction

private function Tower_Death takes nothing returns nothing
    local real x = GetUnitX(GetTriggerUnit())
    local real y = GetUnitY(GetTriggerUnit())
    
    call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", x, y ) )
    
    if Mod(count, 2) == 0 then
        call Depth_Revernant_Dispose(x, y)
    else
        call Hydra_Dispose(x, y)
    endif
    
    set count = count + 1
    
    if CountUnitsInGroup(CoveGeneric_tower_group) != 0 then
        call GroupRemoveUnit(CoveGeneric_tower_group, GetTriggerUnit())
        
        if CountUnitsInGroup(CoveGeneric_tower_group) != 0 then
            return
        else
            call Msg("중앙 제단에 어두운 존재가 나타났다", 0.0)
        endif
    endif
    
    call Trigger_Clear(GetTriggeringTrigger())
    
    set CoveGeneric_region_boss = Forgotten_One_Dispose(10261, -201)
    call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", 10261, -201 ) )
endfunction

private function Boss_Death_Con takes nothing returns boolean
    return GetTriggerUnit() == CoveGeneric_region_boss
endfunction

private function Tower_Death_Con takes nothing returns boolean
    return IsUnitInGroup(GetTriggerUnit(), CoveGeneric_tower_group)
endfunction

private function Trigger_Init takes nothing returns nothing
    local trigger trg
    
    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, p_enemy, EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerAddCondition( trg, Condition( function Tower_Death_Con ) )
    call TriggerAddAction( trg, function Tower_Death )
    
    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, p_enemy, EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerAddCondition( trg, Condition( function Boss_Death_Con ) )
    call TriggerAddAction( trg, function Boss_Death )
    
    set trg = null
endfunction

function Cove_Event_Init takes nothing returns nothing
    call Trigger_Init()
endfunction

endlibrary