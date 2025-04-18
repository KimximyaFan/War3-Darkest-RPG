library MonsterSkill requires MonsterDispose


// 망각의 괴물 촉수 낳기
private function Skill_Act_0 takes nothing returns nothing
    local real x = GetSpellTargetX()
    local real y = GetSpellTargetY()
    
    call SetUnitAnimation( Dispose('n004', x, y, true, 0), "birth" )
endfunction

private function Con_0 takes nothing returns boolean
    return GetSpellAbilityId() == 'A00P'
endfunction

function Monster_Skill_Init takes nothing returns nothing
    local trigger trg
    
    set trg = CreateTrigger(  )
    call TriggerRegisterPlayerUnitEvent(trg, p_enemy, EVENT_PLAYER_UNIT_SPELL_EFFECT, null)
    call TriggerAddCondition( trg, Condition( function Con_0 ) )
    call TriggerAddAction( trg, function Skill_Act_0 )
    
    set trg = null
endfunction

endlibrary