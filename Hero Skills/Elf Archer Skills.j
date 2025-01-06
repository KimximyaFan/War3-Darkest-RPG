scope ElfArcher initializer Elf_Archer_Skills_Init

globals
    private real Q_BASE_DMG = 20
    private real W_BASE_DMG = 40
    
    private boolean R_DMG_TYPE = false
    private real R_BASE_DMG = 10
    private real R_COEF = 0.8
    private real R_VELOCITY = 1200
    private real R_SIZE = 85
    private string R_EFFECT = "A_0023.mdx"
    
    private real X_BASE_DMG = 40
    private real array X_PAD
    
    private real C_BASE_DMG = 100
    
    real array elf_archer_pause_time[8]
    real array elf_archer_mana[8]
    integer array elf_archer_skill[8]
    string array elf_archer_issue_order[8]
endglobals

private function Elf_Archer_Variable_Init takes nothing returns nothing
    set elf_archer_pause_time[Q] = 0.5
    set elf_archer_mana[Q] = 20.0
    set elf_archer_skill[Q] = 'A01B'
    set elf_archer_issue_order[Q] = "carrionswarm"
    
    set elf_archer_pause_time[W] = 0.45
    set elf_archer_mana[W] = 25.0
    set elf_archer_skill[W] = 'A01C'
    set elf_archer_issue_order[W] = "flare"
    
    set elf_archer_pause_time[E] = 0.01
    set elf_archer_mana[E] = 5.0
    set elf_archer_skill[E] = 'A01D'
    set elf_archer_issue_order[E] = "berserk"
    
    set elf_archer_pause_time[R] = 0.01
    set elf_archer_mana[R] = 40.0
    set elf_archer_skill[R] = 'A01E'
    set elf_archer_issue_order[R] = "stomp"
    
    set elf_archer_pause_time[Z] = 0.5
    set elf_archer_mana[Z] = 50.0
    set elf_archer_skill[Z] = 'A01F'
    set elf_archer_issue_order[Z] = "thunderclap"
    
    set elf_archer_pause_time[X] = 0.45
    set elf_archer_mana[X] = 50.0
    set elf_archer_skill[X] = 'A01G'
    set elf_archer_issue_order[X] = "cloudoffog"
    
    set elf_archer_pause_time[C] = 0.5
    set elf_archer_mana[C] = 75.0
    set elf_archer_skill[C] = 'A01H'
    set elf_archer_issue_order[C] = "blizzard"
endfunction

private function V_Act takes nothing returns nothing

endfunction

private function C_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AP_TYPE
    local real base_dmg = C_BASE_DMG
    local real coef = 1.0
    local real ad_coef = 2.0
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type)  + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 1.00
    local real ani_speed = 400 * ( (100 + as) / 100 )
    local real pause_time = 0.5 * ( 100 / (100 + as) )
    local real cool_time = 30.0 * ( 100 / (100 + as) )
    local real dist = Dist(x, y, end_x, end_y)
    local real size = 225
    local real angle = Angle(x, y , end_x, end_y)
    local real eff_height = 800.0
    local real center_x
    local real center_y
    local real range = 325 /* 스킬 지점 중심 범위 */
    local string eff = "A_0021.mdx"
    local string eff2 = "A_0022.mdx"
    local string eff3 = "A_0027.mdx"
    local integer skill_id = GetSpellAbilityId()
    local integer i
    local real time_gap = 0.11
    local location loc
    
    if dist > 850 then
        set dist = 850
    endif
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 10, ani_speed, 0.01)
    call Effect_On_Unit(u, 0.1, 100, "origin", eff3, 0.01)
    
    set center_x = Polar_X(GetUnitX(u), 25, angle)
    set center_y = Polar_Y(GetUnitY(u), 25, angle)
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 20
        set loc = Get_Random_Location_In_Range(end_x, end_y, range)
        set dist = Dist( center_x, center_y, GetLocationX(loc), GetLocationY(loc) )
        set angle = Angle( center_x, center_y, GetLocationX(loc), GetLocationY(loc) )
        call Generic_Parabolic_Projectile(u, center_x, center_y, dmg, size, dmg_type, 1200, dist, angle, 0.0,/*
        */ eff, 75, eff_height, false, eff2, 100, null, delay + i * time_gap)
        call RemoveLocation(loc)
    endloop
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
    set loc = null
endfunction

private function X_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AD_TYPE
    local real base_dmg = X_BASE_DMG
    local real coef = 2.0
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.20 * ( 100 / (100 + as) )
    local real ani_speed = 130 * ( (100 + as) / 100 )
    local real pause_time = 0.45 * ( 100 / (100 + as) )
    local real cool_time = 8.0 * ( 100 / (100 + as) )
    local real velocity = 1400
    local real size = 175
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0024.mdx"
    local string eff2 = "A_0025.mdx"
    local integer skill_id = GetSpellAbilityId()
    local integer i
    local real time_gap = 0.09
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 5, ani_speed, 0.01)
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 4
        call Generic_Projectile(u, Polar_X(GetUnitX(u), 25, angle), Polar_Y(GetUnitY(u), 25, angle), dmg, size, dmg_type, 0.60, velocity, angle + X_PAD[i],/*
        */eff, 135, 50, true, false, false, eff2, null, delay + i * time_gap)
        
        call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A01J', delay + i * time_gap)
    endloop
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function Z_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS)
    local integer crit = Get_Unit_Property(u, CRIT)
    local integer crit_coef = Get_Unit_Property(u, CRIT_COEF)
    local real duration_time = 12.0
    local real pause_time = 0.50 * ( 100 / (100 + as) )
    local real cool_time = 25.0 * ( 100 / (100 + (as/10)) )
    local string eff = "A_0020.mdx"
    local string eff2 = "A_0026.mdx"
    local integer skill_id = GetSpellAbilityId()
    local integer crit_value = 20
    local integer crit_coef_value = R2I( 30 + (crit_coef / 10) )
    local integer gap
    
    if crit + crit_value >= 100.0 then
        set gap = crit + crit_value - 100
        set crit_value = crit_value - gap
        set crit_coef_value = crit_coef_value + gap
    endif
    
    call Effect_On_Unit(u, 0.1, 100, "origin", eff, 0.01)
    call Effect_On_Unit(u, duration_time, 100, "head", eff2, 0.01)
    
    call Unit_Add_Stat(u, duration_time, CRIT, crit_value, 0.01)
    call Unit_Add_Stat(u, duration_time, CRIT_COEF, crit_coef_value, 0.01)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function R_Shooting takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer tic = LoadInteger(HT, id, 1) + 1
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real dmg = Get_Unit_Dmg(u, R_BASE_DMG, R_COEF, R_DMG_TYPE)
    local real as = Get_Unit_Property(u, AS) / 2
    local real attack_cool_time = 0.25 * ( 100 / (100 + as) )
    local real delay = 0.05
    local real ani_speed = 150 * ( (100 + as) / 100 )
    local real angle = GetUnitFacing(u) + (4.0 - 4.0 * Mod(tic, 3)) /* 원래 각도 +- 4 */
    
    // 공격 사운드
    
    call Unit_Motion(u, 6, ani_speed, 0.00)
    
    call Generic_Projectile(u, Polar_X(GetUnitX(u), 25, angle), Polar_Y(GetUnitY(u), 25, angle), dmg, R_SIZE, R_DMG_TYPE, 0.8, R_VELOCITY, angle,/*
    */R_EFFECT, 100, 50, false, false, false, null, null, delay)
    
    // MoustPosition Library
    if Is_Facing_On(pid) == false then
        call SaveReal( HT, GetHandleId(u), ATTACK_COOLDOWN, 1.0 )
        call Set_Unit_Property(u, AS, Get_Unit_Property(u, AS))
        call Cooldown_Reset(u, LoadInteger(HT, id, 2), 0.1)
        call Timer_Clear(t)
    else
        call SaveInteger(HT, id, 1, tic)
        call TimerStart(t, attack_cool_time, false, function R_Shooting)
    endif
    
    set t = null
    set u = null
endfunction

private function R_Act takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.20
    local integer skill_id = GetSpellAbilityId()
    
    // 자동공격 방지
    call SaveReal( HT, GetHandleId(u), ATTACK_COOLDOWN, 4.0 )
    call JNSetUnitAttackCooldown(u, 4.0, 1)
    
    // Mouse Position Library
    // 마우스 좌표 Facing, 움직이면 풀림
    call Unit_Facing_Mouse_Fix_Check(u, 7.0, 0.26, 0.0)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, 0) /* tic */
    call SaveInteger(HT, id, 2, skill_id)
    call TimerStart(t, delay, false, function R_Shooting)
    
    set t = null
    set u = null
endfunction

private function E_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS)
    local real ms = Get_Unit_Property(u, MS)
    local real duration_time = 2.0
    local real cool_time = 3.0
    local string eff = "A_0020.mdx"
    local string eff2 = "A_0019.mdx"
    local integer skill_id = GetSpellAbilityId()
    local integer as_value = R2I(as / 5.0) + 50
    local integer ms_value = R2I(ms / 5.0) + 50
    
    call Effect_On_Unit(u, 0.1, 100, "origin", eff, 0.01)
    call Effect_On_Unit(u, duration_time, 100, "origin", eff2, 0.01)
    
    call Unit_Add_Stat(u, duration_time, AS, as_value, 0.01)
    call Unit_Add_Stat(u, duration_time, MS, ms_value, 0.01)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function W_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AD_TYPE
    local real base_dmg = W_BASE_DMG
    local real coef = 2.0
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.20 * ( 100 / (100 + as) )
    local real ani_speed = 130 * ( (100 + as) / 100 )
    local real pause_time = 0.45 * ( 100 / (100 + as) )
    local real cool_time = 2.0 * ( 100 / (100 + as) )
    local real velocity = 1400
    local real size = 175
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0024.mdx"
    local string eff2 = "A_0025.mdx"
    local integer skill_id = GetSpellAbilityId()
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 5, ani_speed, 0.01)
    
    call Generic_Projectile(u, Polar_X(GetUnitX(u), 25, angle), Polar_Y(GetUnitY(u), 25, angle), dmg, size, dmg_type, 0.60, velocity, angle,/*
    */eff, 135, 50, true, false, false, eff2, null, delay)
    
    call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A01J', delay)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function Q_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AP_TYPE
    local real base_dmg = Q_BASE_DMG
    local real coef = 1.0
    local real ad_coef = 0.25
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type)  + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.25 * ( 100 / (100 + as) )
    local real ani_speed = 130 * ( (100 + as) / 100 )
    local real pause_time = 0.5 * ( 100 / (100 + as) )
    local real cool_time = 2.0 * ( 100 / (100 + as) )
    local real dist = Dist(x, y, end_x, end_y)
    local real size = 225
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0021.mdx"
    local string eff2 = "A_0022.mdx"
    local integer skill_id = GetSpellAbilityId()
    
    if dist > 850 then
        set dist = 850
    endif
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 5, ani_speed, 0.01)
    
    call Generic_Parabolic_Projectile(u, Polar_X(GetUnitX(u), 25, angle), Polar_Y(GetUnitY(u), 25, angle), dmg, size, dmg_type, 1000, dist, angle, 4000.0,/*
    */ eff, 75, 50, false, eff2, 100, null, delay)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function V_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01I'
endfunction

private function C_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01H'
endfunction

private function X_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01G'
endfunction

private function Z_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01F'
endfunction

private function R_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01E'
endfunction

private function E_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01D'
endfunction

private function W_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01C'
endfunction

private function Q_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01B'
endfunction

private function Elf_Archer_Skills_Init takes nothing returns nothing
    local trigger trg
    
    call Elf_Archer_Variable_Init()
    
    set X_PAD[0] = 0.0
    set X_PAD[1] = 10.0
    set X_PAD[2] = -10.0
    set X_PAD[3] = 20.0
    set X_PAD[4] = -20.0
    set X_PAD[5] = 0.0

    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function Q_Con ) )
    call TriggerAddAction( trg, function Q_Act )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function W_Con ) )
    call TriggerAddAction( trg, function W_Act )
    
    set trg = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( trg, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function E_Con ) )
    call TriggerAddAction( trg, function E_Act )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function R_Con ) )
    call TriggerAddAction( trg, function R_Act )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function Z_Con ) )
    call TriggerAddAction( trg, function Z_Act )

    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function X_Con ) )
    call TriggerAddAction( trg, function X_Act )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function C_Con ) )
    call TriggerAddAction( trg, function C_Act )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function V_Con ) )
    call TriggerAddAction( trg, function V_Act )

    set trg = null
endfunction

endscope