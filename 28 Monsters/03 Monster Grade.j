library MonsterGrade requires UnitProperty, MonsterTextTag

/*
    constant integer AD_RESISTANCE = 1
    constant integer AP_RESISTANCE = 2
    constant integer ACCEL = 3
    constant integer CRITICAL = 4
    constant integer TANK = 5
    constant integer ARCANE = 6
    constant integer EXPLOSION = 7
    constant integer AURA = 8
    constant integer MANA_BURN = 9
    
    constant integer AD_STRONG = 10
    constant integer AP_STRONG = 11
    constant integer STUN = 12
    constant integer SWAMP = 13
    constant integer KNOCKBACK = 14
    constant integer VORTEX = 15
    constant integer TOWER = 16
    constant integer REGENERATION = 17
    constant integer REFLECTION = 18
    constant integer THUNDER = 19
    constant integer EARTH_QUAKE = 20
    constant integer POISON = 21
    constant integer PLAGUE = 22
    constant integer FROZEN = 23
    constant integer DIVINE = 24
    constant integer Reaper = 25
    constant integer SILENCE = 26
*/

private function Add_Grade_Skill takes unit u, integer skill returns nothing
    if skill == AD_RESISTANCE then
        // 물방 20 증가, 물리 뎀감 50% 증가
        call Set_Unit_Property( u, DEF_AD, Get_Unit_Property(u, DEF_AD) + 20 )
        call Set_Unit_Property( u, REDUCE_AD, Get_Unit_Property(u, REDUCE_AD) + 50 )
        
    elseif skill == AP_RESISTANCE then
        // 마방 20 증가, 마법 뎀감 50% 증가
        call Set_Unit_Property( u, DEF_AP, Get_Unit_Property(u, DEF_AP) + 20 )
        call Set_Unit_Property( u, REDUCE_AP, Get_Unit_Property(u, REDUCE_AP) + 50 )
        
    elseif skill == ACCEL then
        // 공속 100% 이속 200 증가
        call Set_Unit_Property( u, AS, Get_Unit_Property(u, AS) + 100 )
        call Set_Unit_Property( u, MS, Get_Unit_Property(u, MS) + 200 )
        
    elseif skill == CRITICAL then
        // 치확 50% 치피 50% 증가
        call Set_Unit_Property( u, CRIT, Get_Unit_Property(u, CRIT) + 50 )
        call Set_Unit_Property( u, CRIT_COEF, Get_Unit_Property(u, CRIT_COEF) + 50 )
        
    elseif skill == TANK then
        // 엘리트 기본 체력 증가에 체력 1.5배 더 증가
        call Set_Unit_Property( u, HP, R2I(Get_Unit_Property(u, HP) * 1.5) )
        
    elseif skill == ARCANE then
        // 원래 비전강화 액티브 스킬인데 일단 AP 증가로 하자
        call Set_Unit_Property( u, AP, Get_Unit_Property(u, AP) + 50 )
    endif
endfunction

function Apply_Grade_Property takes unit u returns nothing
    local integer array arr
    local integer i
    local integer ran
    local integer temp
    local integer grade = Get_Unit_Property(u, GRADE)
    local integer aura_id
    local boolean is_resistance_exist = false
    local MonsterTextTag MTT

    set i = -1
    loop
    set i = i + 1
    exitwhen i >= GRADE_SKILL_COUNT
        set arr[i] = i + 1
    endloop

    set i = -1
    loop
    set i = i + 1
    exitwhen i >= GRADE_SKILL_COUNT
        set ran = GetRandomInt(i, GRADE_SKILL_COUNT-1)
        set temp = arr[ran]
        set arr[ran] = arr[i]
        set arr[i] = temp
    endloop
    
    // 셔플 된 어레이 검사해서, AP 랑 AD 같이 있으면, 맨 마지막 특성으로 바꿈
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= grade
        if is_resistance_exist == true and (arr[i] == AD_RESISTANCE or arr[i] == AP_RESISTANCE) then
            set arr[i] = arr[GRADE_SKILL_COUNT-1]
            set i = grade /* 바로 루프 탈출 */
        endif
    
        if is_resistance_exist == false and (arr[i] == AD_RESISTANCE or arr[i] == AP_RESISTANCE) then
            set is_resistance_exist = true
        endif
    endloop
    
    // 스킬 집어넣고
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= grade
        call Add_Grade_Skill(u, arr[i])
    endloop
    
    // 오라 집어넣고
    if grade == UNCOMMON then
        set aura_id = 'A00R'
    elseif grade == RARE then
        set aura_id = 'A00S'
    elseif grade == LEGEND then
        set aura_id = 'A00T'
    elseif grade == EPIC then
        set aura_id = 'A00R'
    endif
    
    call UnitAddAbility(u, aura_id)
    
    // 텍스트 태그
    set MTT = MonsterTextTag.create(u)

    set i = -1
    loop
    set i = i + 1
    exitwhen i >= grade
        call MTT.Texttag_Register( GRADE_SKILL_STRING[arr[i]], arr[i] )
    endloop

    call Set_Unit_Property( u, TEXT_TAG, MTT )
    call Set_Unit_Property( u, TAG_APPLIED, 0 )
endfunction

function Grade_Property takes unit u, boolean is_scaled returns nothing
    local integer grade = Get_Unit_Property(u, GRADE)
    local real model_size
    
    if is_scaled == true then
        set model_size = LoadInteger(HT, GetUnitTypeId(u), MODEL_SIZE)
        call SetUnitScalePercent(u, model_size + grade * 40, model_size + grade * 40, model_size + grade * 40)
    endif
    
    if grade != 0 then
        call Set_Unit_Property( u, HP, Get_Unit_Property(u, HP) * (200 + 100 * (grade-1)) / 100 )
        call Apply_Grade_Property(u)
    endif
endfunction

function Weighted_Monster_Grade takes unit u, integer w0, integer w1, integer w2, integer w3, integer w4 returns nothing
    local integer total_weight = w0 + w1 + w2 + w3 + w4
    local integer ran = GetRandomInt(1, total_weight)
    
    // 랜덤 등급
    if ran <= w0 then
        call Set_Unit_Property(u, GRADE, NORMAL)
    elseif ran <= w0 + w1 then
        call Set_Unit_Property(u, GRADE, UNCOMMON)
    elseif ran <= w0 + w1 + w2 then
        call Set_Unit_Property(u, GRADE, RARE)
    elseif ran <= w0 + w1 + w2 + w3 then
        call Set_Unit_Property(u, GRADE, LEGEND)
    elseif ran <= w0 + w1 + w2 + w3 + w4 then
        call Set_Unit_Property(u, GRADE, EPIC)
    endif
endfunction

function Set_Monster_Grade takes unit u, integer grade returns nothing
    if grade == 1 then
        call Weighted_Monster_Grade(u, 0, 100, 0, 0, 0)
    elseif grade == 2 then
        call Weighted_Monster_Grade(u, 0, 0, 100, 0, 0)
    elseif grade == 3 then
        call Weighted_Monster_Grade(u, 0, 0, 0, 100, 0)
    else
        call Weighted_Monster_Grade(u, 100, 0, 0, 0, 0)
    endif
endfunction

function Set_Random_Monster_Grade takes unit u returns nothing
    if MAP_DIFFICULTY == NORMAL then
        call Weighted_Monster_Grade(u, 100, 1, 0, 0, 0)
    elseif MAP_DIFFICULTY == NIGHTMARE then
        call Weighted_Monster_Grade(u, 94, 4, 2, 1, 0)
    elseif MAP_DIFFICULTY == HELL then
        call Weighted_Monster_Grade(u, 93, 5, 2, 1, 0)
    endif
endfunction


// 유동텍스트 적용만 하면 될듯?
private function Apply_Text_Tag_Refresh takes nothing returns nothing
    local unit u = GetAttacker()

    call Grade_Text_Tag_Register(u)
    call Set_Unit_Property(u, TAG_APPLIED, 1)

    set u = null
endfunction

// 몬스터가 그레이드가 있는가?
// 이미 효과 적용을 받았는가?
private function Monster_Grade_Con takes nothing returns boolean
    if Get_Unit_Property( GetAttacker(), GRADE ) > 0 and Get_Unit_Property( GetAttacker(), TAG_APPLIED ) == 0 then
        return true
    endif

    return false
endfunction

private function Trigger_Init takes nothing returns nothing
    local trigger trg
    
    set trg = CreateTrigger(  )
    call TriggerRegisterPlayerUnitEvent(trg, Player(0), EVENT_PLAYER_UNIT_ATTACKED, null)
    call TriggerRegisterPlayerUnitEvent(trg, Player(1), EVENT_PLAYER_UNIT_ATTACKED, null)
    call TriggerRegisterPlayerUnitEvent(trg, Player(2), EVENT_PLAYER_UNIT_ATTACKED, null)
    call TriggerRegisterPlayerUnitEvent(trg, Player(3), EVENT_PLAYER_UNIT_ATTACKED, null)
    call TriggerRegisterPlayerUnitEvent(trg, Player(4), EVENT_PLAYER_UNIT_ATTACKED, null)
    call TriggerRegisterPlayerUnitEvent(trg, Player(5), EVENT_PLAYER_UNIT_ATTACKED, null)
    call TriggerAddCondition(trg, function Monster_Grade_Con)
    call TriggerAddAction( trg, function Apply_Text_Tag_Refresh )
    
    set trg = null
endfunction

function Monster_Grade_Init takes nothing returns nothing
    call Trigger_Init()
endfunction

endlibrary