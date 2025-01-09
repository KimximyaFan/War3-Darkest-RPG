library HeroSkillAdd

globals
    private constant integer Q_SKILL = 0
    private constant integer W_SKILL = 1
    private constant integer E_SKILL = 2
    private constant integer R_SKILL = 3
    private constant integer Z_SKILL = 4
    private constant integer X_SKILL = 5
    private constant integer C_SKILL = 6
    private constant integer V_SKILL = 7
    
    integer array level_flag
endglobals

private function Get_Skill_Id takes unit u, integer skill returns integer
    return LoadInteger(HT, GetUnitTypeId(u), skill)
endfunction

function Hero_Skill_Table_Init takes nothing returns nothing
    local integer i = 0
    local integer unit_type_id
    
    // 풋맨
    set unit_type_id = 'H000'
    call SaveInteger(HT, unit_type_id, Q_SKILL, 'A00C')
    call SaveInteger(HT, unit_type_id, W_SKILL, 'A00D')
    call SaveInteger(HT, unit_type_id, E_SKILL, 'A00E')
    call SaveInteger(HT, unit_type_id, R_SKILL, 'A00O')
    call SaveInteger(HT, unit_type_id, Z_SKILL, 'A00V')
    call SaveInteger(HT, unit_type_id, X_SKILL, 'A00W')
    call SaveInteger(HT, unit_type_id, C_SKILL, 'A00U')
    call SaveInteger(HT, unit_type_id, V_SKILL, 'A00X')
    
    // 밤 까마귀
    set unit_type_id = 'H003'
    call SaveInteger(HT, unit_type_id, Q_SKILL, 'A00Y')
    call SaveInteger(HT, unit_type_id, W_SKILL, 'A00Z')
    call SaveInteger(HT, unit_type_id, E_SKILL, 'A010')
    call SaveInteger(HT, unit_type_id, R_SKILL, 'A011')
    call SaveInteger(HT, unit_type_id, Z_SKILL, 'A012')
    call SaveInteger(HT, unit_type_id, X_SKILL, 'A013')
    call SaveInteger(HT, unit_type_id, C_SKILL, 'A014')
    call SaveInteger(HT, unit_type_id, V_SKILL, 'A015')
    
    // 엘프 궁수
    set unit_type_id = 'H001'
    call SaveInteger(HT, unit_type_id, Q_SKILL, 'A01B')
    call SaveInteger(HT, unit_type_id, W_SKILL, 'A01C')
    call SaveInteger(HT, unit_type_id, E_SKILL, 'A01D')
    call SaveInteger(HT, unit_type_id, R_SKILL, 'A01E')
    call SaveInteger(HT, unit_type_id, Z_SKILL, 'A01F')
    call SaveInteger(HT, unit_type_id, X_SKILL, 'A01G')
    call SaveInteger(HT, unit_type_id, C_SKILL, 'A01H')
    call SaveInteger(HT, unit_type_id, V_SKILL, 'A01I')
    
    // 그림자
    set unit_type_id = 'H004'
    call SaveInteger(HT, unit_type_id, Q_SKILL, 'A01K')
    call SaveInteger(HT, unit_type_id, W_SKILL, 'A01L')
    call SaveInteger(HT, unit_type_id, E_SKILL, 'A01M')
    call SaveInteger(HT, unit_type_id, R_SKILL, 'A01N')
    call SaveInteger(HT, unit_type_id, Z_SKILL, 'A01O')
    call SaveInteger(HT, unit_type_id, X_SKILL, 'A01P')
    call SaveInteger(HT, unit_type_id, C_SKILL, 'A01Q')
    call SaveInteger(HT, unit_type_id, V_SKILL, 'A01R')
    
    // 엘프 기사
    set unit_type_id = 'H002'
    call SaveInteger(HT, unit_type_id, Q_SKILL, 'A01S')
    call SaveInteger(HT, unit_type_id, W_SKILL, 'A01T')
    call SaveInteger(HT, unit_type_id, E_SKILL, 'A01V')
    call SaveInteger(HT, unit_type_id, R_SKILL, 'A01U')
    call SaveInteger(HT, unit_type_id, Z_SKILL, 'A01W')
    call SaveInteger(HT, unit_type_id, X_SKILL, 'A01X')
    call SaveInteger(HT, unit_type_id, C_SKILL, 'A01Y')
    call SaveInteger(HT, unit_type_id, V_SKILL, 'A01Z')
    
    loop
    exitwhen i > 7
        set level_flag[i] = 0
        set i = i + 1
    endloop
endfunction

function Hero_Check_Level_for_Skill_Add takes unit u returns nothing
    local integer level = GetHeroLevel(u)
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    
    if level_flag[pid] >= 8 then
        return
    endif
    
    if level >= 2 and level_flag[pid] < 1 then
        call UnitRemoveAbility(u, 'A00G')
        call UnitAddAbility(u, Get_Skill_Id(u, Q_SKILL))
        set level_flag[pid] = level_flag[pid] + 1
    endif
    
    if level >= 5 and level_flag[pid] < 2 then
        call UnitRemoveAbility(u, 'A00H')
        call UnitAddAbility(u, Get_Skill_Id(u, W_SKILL))
        set level_flag[pid] = level_flag[pid] + 1
    endif
    
    if level >= 10 and level_flag[pid] < 3 then
        call UnitRemoveAbility(u, 'A00I')
        call UnitAddAbility(u, Get_Skill_Id(u, E_SKILL))
        set level_flag[pid] = level_flag[pid] + 1
    endif
    
    if level >= 20 and level_flag[pid] < 4 then
        call UnitRemoveAbility(u, 'A00J')
        call UnitAddAbility(u, Get_Skill_Id(u, R_SKILL))
        set level_flag[pid] = level_flag[pid] + 1
    endif
    
    if level >= 40 and level_flag[pid] < 5 then
        call UnitRemoveAbility(u, 'A00K')
        call UnitAddAbility(u, Get_Skill_Id(u, Z_SKILL))
        set level_flag[pid] = level_flag[pid] + 1
    endif
    
    if level >= 80 and level_flag[pid] < 6 then
        call UnitRemoveAbility(u, 'A00L')
        call UnitAddAbility(u, Get_Skill_Id(u, X_SKILL))
        set level_flag[pid] = level_flag[pid] + 1
    endif
    
    if level >= 160 and level_flag[pid] < 7 then
        call UnitRemoveAbility(u, 'A00M')
        call UnitAddAbility(u, Get_Skill_Id(u, C_SKILL))
        set level_flag[pid] = level_flag[pid] + 1
    endif
    
    if level >= 320 and level_flag[pid] < 8 then
        call UnitRemoveAbility(u, 'A00N')
        call UnitAddAbility(u, Get_Skill_Id(u, V_SKILL))
        set level_flag[pid] = level_flag[pid] + 1
    endif
endfunction

endlibrary