library HeroSkillAdd requires UnitProperty

globals
    private constant integer Q_SKILL = 0
    private constant integer W_SKILL = 1
    private constant integer E_SKILL = 2
    private constant integer R_SKILL = 3
    private constant integer Z_SKILL = 4
    private constant integer X_SKILL = 5
    private constant integer C_SKILL = 6
    private constant integer V_SKILL = 7
endglobals

private function Get_Skill_Id takes unit u, integer skill returns integer
    return LoadInteger(HT, GetUnitTypeId(u), skill)
endfunction

function Hero_Skill_Table_Init takes nothing returns nothing
    local integer i = 0
    local integer unit_type_id
    
    // ================================================
    // 일반 캐릭
    // ================================================
    
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
    
    // 바바리안
    set unit_type_id = 'H00B'
    call SaveInteger(HT, unit_type_id, Q_SKILL, 'A020')
    call SaveInteger(HT, unit_type_id, W_SKILL, 'A021')
    call SaveInteger(HT, unit_type_id, E_SKILL, 'A022')
    call SaveInteger(HT, unit_type_id, R_SKILL, 'A023')
    call SaveInteger(HT, unit_type_id, Z_SKILL, 'A024')
    call SaveInteger(HT, unit_type_id, X_SKILL, 'A025')
    call SaveInteger(HT, unit_type_id, C_SKILL, 'A026')
    call SaveInteger(HT, unit_type_id, V_SKILL, 'A027')
    
    // 마린
    set unit_type_id = 'H00C'
    call SaveInteger(HT, unit_type_id, Q_SKILL, 'A02Q')
    call SaveInteger(HT, unit_type_id, W_SKILL, 'A02R')
    call SaveInteger(HT, unit_type_id, E_SKILL, 'A02S')
    call SaveInteger(HT, unit_type_id, R_SKILL, 'A02T')
    call SaveInteger(HT, unit_type_id, Z_SKILL, 'A02U')
    call SaveInteger(HT, unit_type_id, X_SKILL, 'A02V')
    call SaveInteger(HT, unit_type_id, C_SKILL, 'A02W')
    call SaveInteger(HT, unit_type_id, V_SKILL, 'A02X')
    
    // 엔터프라이즈
    set unit_type_id = 'H00E'
    call SaveInteger(HT, unit_type_id, Q_SKILL, 'A032')
    call SaveInteger(HT, unit_type_id, W_SKILL, 'A033')
    call SaveInteger(HT, unit_type_id, E_SKILL, 'A034')
    call SaveInteger(HT, unit_type_id, R_SKILL, 'A035')
    call SaveInteger(HT, unit_type_id, Z_SKILL, 'A036')
    call SaveInteger(HT, unit_type_id, X_SKILL, 'A037')
    call SaveInteger(HT, unit_type_id, C_SKILL, 'A038')
    call SaveInteger(HT, unit_type_id, V_SKILL, 'A039')
    
    // 엔터프라이즈
    set unit_type_id = 'H00F'
    call SaveInteger(HT, unit_type_id, Q_SKILL, 'A03E')
    call SaveInteger(HT, unit_type_id, W_SKILL, 'A03F')
    call SaveInteger(HT, unit_type_id, E_SKILL, 'A03G')
    call SaveInteger(HT, unit_type_id, R_SKILL, 'A03H')
    call SaveInteger(HT, unit_type_id, Z_SKILL, 'A03I')
    call SaveInteger(HT, unit_type_id, X_SKILL, 'A03J')
    call SaveInteger(HT, unit_type_id, C_SKILL, 'A03K')
    call SaveInteger(HT, unit_type_id, V_SKILL, 'A03L')
    
    // ================================================
    // 후원 캐릭
    // ================================================
    
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
endfunction

function Hero_Check_Level_for_Skill_Add takes unit u returns nothing
    local integer level = GetHeroLevel(u)
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    local integer level_flag = Get_Unit_Property(u, LEVEL_FLAG)
    
    if level_flag >= 8 then
        return
    endif
    
    if level >= 2 and level_flag < 1 then
        call UnitRemoveAbility(u, 'A00G')
        call UnitAddAbility(u, Get_Skill_Id(u, Q_SKILL))
        set level_flag = level_flag + 1
        call Set_Unit_Property(u, LEVEL_FLAG, level_flag)
    endif
    
    if level >= 5 and level_flag < 2 then
        call UnitRemoveAbility(u, 'A00H')
        call UnitAddAbility(u, Get_Skill_Id(u, W_SKILL))
        set level_flag = level_flag + 1
        call Set_Unit_Property(u, LEVEL_FLAG, level_flag)
    endif
    
    if level >= 10 and level_flag < 3 then
        call UnitRemoveAbility(u, 'A00I')
        call UnitAddAbility(u, Get_Skill_Id(u, E_SKILL))
        set level_flag = level_flag + 1
        call Set_Unit_Property(u, LEVEL_FLAG, level_flag)
    endif
    
    if level >= 20 and level_flag < 4 then
        call UnitRemoveAbility(u, 'A00J')
        call UnitAddAbility(u, Get_Skill_Id(u, R_SKILL))
        set level_flag = level_flag + 1
        call Set_Unit_Property(u, LEVEL_FLAG, level_flag)
    endif
    
    if level >= 40 and level_flag < 5 then
        call UnitRemoveAbility(u, 'A00K')
        call UnitAddAbility(u, Get_Skill_Id(u, Z_SKILL))
        set level_flag = level_flag + 1
        call Set_Unit_Property(u, LEVEL_FLAG, level_flag)
    endif
    
    if level >= 80 and level_flag < 6 then
        call UnitRemoveAbility(u, 'A00L')
        call UnitAddAbility(u, Get_Skill_Id(u, X_SKILL))
        set level_flag = level_flag + 1
        call Set_Unit_Property(u, LEVEL_FLAG, level_flag)
    endif
    
    if level >= 160 and level_flag < 7 then
        call UnitRemoveAbility(u, 'A00M')
        call UnitAddAbility(u, Get_Skill_Id(u, C_SKILL))
        set level_flag = level_flag + 1
        call Set_Unit_Property(u, LEVEL_FLAG, level_flag)
    endif
    
    if level >= 320 and level_flag < 8 then
        call UnitRemoveAbility(u, 'A00N')
        call UnitAddAbility(u, Get_Skill_Id(u, V_SKILL))
        set level_flag = level_flag + 1
        call Set_Unit_Property(u, LEVEL_FLAG, level_flag)
    endif
endfunction

endlibrary