scope Shadow initializer Shadow_Skills_Init

globals
    private unit array mirror
    private real mirror_pad = 50
    
    private real Q_BASE_DMG = 20
    private real W_BASE_DMG = 60
    private real E_BASE_DMG = 40
    private real R_BASE_DMG = 100
    
    private real C_BASE_DMG = 50
    
    real array shadow_pause_time[8]
    real array shadow_mana[8]
    integer array shadow_skill[8]
    string array shadow_issue_order[8]
endglobals

private function Shadow_Variable_Init takes nothing returns nothing
    set shadow_pause_time[Q] = 0.45
    set shadow_mana[Q] = 20.0
    set shadow_skill[Q] = 'A01K'
    set shadow_issue_order[Q] = "ancestralspirit"
    
    set shadow_pause_time[W] = 0.45
    set shadow_mana[W] = 20.0
    set shadow_skill[W] = 'A01L'
    set shadow_issue_order[W] = "avatar"
    
    set shadow_pause_time[E] = 0.25
    set shadow_mana[E] = 25.0
    set shadow_skill[E] = 'A01M'
    set shadow_issue_order[E] = "carrionswarm"
    
    set shadow_pause_time[R] = 0.55
    set shadow_mana[R] = 40.0
    set shadow_skill[R] = 'A01N'
    set shadow_issue_order[R] = "cloudoffog"
    
    set shadow_pause_time[Z] = 0.50
    set shadow_mana[Z] = 50.0
    set shadow_skill[Z] = 'A01O'
    set shadow_issue_order[Z] = "thunderclap"
    
    set shadow_pause_time[X] = 0.50
    set shadow_mana[X] = 50.0
    set shadow_skill[X] = 'A01P'
    set shadow_issue_order[X] = "stomp"
    
    set shadow_pause_time[C] = 0.5
    set shadow_mana[C] = 75.0
    set shadow_skill[C] = 'A01Q'
    set shadow_issue_order[C] = "resurrection"
endfunction

private function C_Mirror_Create takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real dist = 200
    local real angle
    local real size = 200
    local real dmg = Get_Unit_Dmg(u, C_BASE_DMG, 1.5, AD_TYPE)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.40 * ( 100 / (100 + as) )
    local real ani_speed = 120 * ( (100 + as) / 100 )
    local string eff = "A_0032.mdx"
    local string eff2 = "A_0036.mdx"
    local string model = "C_0004.mdx"
    local real pause_time = 0.35
    local unit c_mirror
    local unit c
    local real x
    local real y
    local group g = Get_Group(u, GetUnitX(u), GetUnitY(u), 800, null)
    
    set c = GroupPickRandomUnit(g)
    
    if c != null then
        set angle = GRR(0, 360)
        set x = Polar_X(GetUnitX(c), 125, angle)
        set y = Polar_Y(GetUnitY(c), 125, angle)
        set c_mirror = CreateUnit(GetOwningPlayer(u), 'e000', x, y, angle+180)
        call UnitApplyTimedLifeBJ( 1.5, 'BHwe', c_mirror )
    
        call X_Y_Effect(GetUnitX(c_mirror), GetUnitY(c_mirror), 65, 200, 0, 0.01, 0, 0, angle, eff, 0.01)
        
        call Set_Unit_Model(c_mirror, model, pause_time)
        
        call SetUnitScale(c_mirror, 0.64, 0.64, 0.64)
        call SetUnitVertexColor(c_mirror, 5, 5, 5, 255)
        
        call Unit_Motion(c_mirror, 1, ani_speed, pause_time)
        call Effect_Attached(c_mirror, 125, angle+180, 80, 100, 0, 1.020, 0, 0, angle+180, false, eff2, pause_time + delay)
        call Unit_Area_Dmg_With_Owner(c_mirror, dmg, dist, angle+180, size, AD_TYPE, u, pause_time + delay)
    endif
    
    call Group_Clear(g)
    
    // CUSTOM_INT_1 값이 0 이면 지속시간 끝남
    if Get_Unit_Property(u, CUSTOM_INT_1) == 0 then
        call Timer_Clear(t)
    else
        call TimerStart(t, 1.0, false, function C_Mirror_Create)
    endif
    
    set t = null
    set u = null
    set c_mirror = null
    set c = null
    set g = null
endfunction

private function Z_Mirror_Fix takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real angle = GetUnitFacing(u)
    local real x = Polar_X(GetUnitX(u), mirror_pad, angle + 180)
    local real y = Polar_Y(GetUnitY(u), mirror_pad, angle + 180)
    
    call SetUnitX(mirror[pid], x)
    call SetUnitY(mirror[pid], y)
    call SetUnitFacing(mirror[pid], angle)
    
    // CUSTOM_INT_0 값이 0 이면 지속시간 끝남
    if Get_Unit_Property(u, CUSTOM_INT_0) == 0 then
        call RemoveUnit(mirror[pid])
        call Timer_Clear(t)
    else
        call TimerStart(t, 0.01, false, function Z_Mirror_Fix)
    endif
    
    set t = null
    set u = null
endfunction

// ===============================================================
// ===============================================================

private function V_Act takes nothing returns nothing

endfunction

private function C_Act takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real duration_time = 20.0
    local real pause_time = 0.50 * ( 100 / (100 + as) )
    local real cool_time = 25.0 * ( 100 / (100 + (as/10.0) ) )
    local real angle = GetUnitFacing(u)
    local string eff = "A_0032.mdx"
    local integer skill_id = GetSpellAbilityId()
    
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 4, ani_speed, 0.01)
    
    call Effect_On_Unit(u, 0.01, 100, "origin", eff, 0.01)
    
    // 판별용 CUSTOM_INT_1 사용
    call Set_Unit_Custom_Int(u, duration_time, 1, 1, true, 0.01)
    
    call SaveUnitHandle(HT, id, 0, u)
    call TimerStart(t, pause_time, false, function C_Mirror_Create)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set t = null
    set u = null
endfunction

// X Addtional 은 50% 확률
private function X_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real duration_time = 20.0
    local real pause_time = 0.50 * ( 100 / (100 + as) )
    local real cool_time = 25.0 * ( 100 / (100 + (as/10.0) ) )
    local string eff = "A_0032.mdx"
    local string eff2 = "A_0035.mdx"
    local integer skill_id = GetSpellAbilityId()
    local integer ad_value = R2I(Get_Unit_Property(u, AD) / 5.0) + 25
    local integer as_value = R2I(Get_Unit_Property(u, AS) / 5.0) + 50
    local integer ms_value = R2I(Get_Unit_Property(u, MS) / 5.0) + 50
    local integer crit_value = 20
    local integer crit_coef_value = R2I( 30 + (Get_Unit_Property(u, CRIT_COEF) / 10) )
    
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 4, ani_speed, 0.01)
    
    call Effect_On_Unit(u, 0.01, 100, "origin", eff, 0.01)
    call Effect_On_Unit(u, duration_time, 100, "origin", eff2, 0.01)
    
    call Unit_Add_Stat(u, duration_time, AD, ad_value, 0.01)
    call Unit_Add_Stat(u, duration_time, AS, as_value, 0.01)
    call Unit_Add_Stat(u, duration_time, MS, ms_value, 0.01)
    call Unit_Add_Stat(u, duration_time, CRIT, crit_value, 0.01)
    call Unit_Add_Stat(u, duration_time, CRIT_COEF, crit_coef_value, 0.01)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function Z_Act takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real duration_time = 20.0
    local real pause_time = 0.50 * ( 100 / (100 + as) )
    local real cool_time = 25.0 * ( 100 / (100 + (as/10.0) ) )
    local real angle = GetUnitFacing(u)
    local real x = Polar_X(GetUnitX(u), mirror_pad, angle + 180)
    local real y = Polar_Y(GetUnitY(u), mirror_pad, angle + 180)
    local string eff = "A_0032.mdx"
    local string model = "C_0004.mdx"
    local integer skill_id = GetSpellAbilityId()
    
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 4, ani_speed, 0.01)
    
    if mirror[pid] != null then
        call RemoveUnit(mirror[pid])
    endif
    
    set mirror[pid] = CreateUnit(GetOwningPlayer(u), 'e000', x, y, angle)
    
    call X_Y_Effect(x, y, 100, 100, 0, 0.01, 0, 0, angle, eff, 0.01)
    
    call Set_Unit_Model(mirror[pid], model, pause_time)
    
    call SetUnitScale(mirror[pid], 0.64, 0.64, 0.64)
    call SetUnitVertexColor(mirror[pid], 5, 5, 5, 255)
    
    // 판별용 CUSTOM_INT_0 사용
    call Set_Unit_Custom_Int(u, duration_time, 0, 1, true, 0.01)
    
    call SaveUnitHandle(HT, id, 0, u)
    call TimerStart(t, 0.02, false, function Z_Mirror_Fix)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set t = null
    set u = null
endfunction

private function R_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AP_TYPE
    local real base_dmg = R_BASE_DMG
    local real coef = 2.0
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, AP_TYPE) + Get_Coef_Dmg(u, coef, AD_TYPE)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.35 * ( 100 / (100 + as) )
    local real ani_speed = 120 * ( (100 + as) / 100 )
    local real pause_time = 0.55 * ( 100 / (100 + as) )
    local real cool_time = 2.0 * ( 100 / (100 + as) )
    local real velocity = 1200
    local real size = 200
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0033.mdx" /* 검기 */
    local string eff2 = "A_0031.mdx" /* 피격용 에퍼머럴 컷 */
    local integer skill_id = GetSpellAbilityId()
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 1, ani_speed, 0.01)
    
    call Generic_Projectile(u, Polar_X(GetUnitX(u), 25, angle), Polar_Y(GetUnitY(u), 25, angle), dmg, size, dmg_type, 0.70, velocity, angle,/*
    */eff, 85, 0, true, false, false, eff2, null, delay)
    
    call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A01J', delay)
    
    call Delayed_ND(Player(pid), 0.2, 8, delay)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    // 분신 스킬 추가 타격
    if Get_Unit_Property(u, CUSTOM_INT_0) > 0 then
        call Unit_Motion(mirror[pid], 1, 100, delay)
        call Generic_Projectile(u, GetUnitX(u), GetUnitY(u), dmg/1.5, size, dmg_type, 0.70, velocity, angle,/*
        */eff, 85, 0, true, false, false, eff2, null, delay + delay)
        call Delayed_ND(Player(pid), 0.2, 8, delay + delay)
    endif
    
    set u = null
endfunction

private function E_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AD_TYPE
    local real base_dmg = E_BASE_DMG
    local real coef = 2.5
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2 
    local real dist = 400
    local real size = 200
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0030.mdx"
    local string eff2 = "A_0029.mdx"
    local real eff_height = 15
    local integer tic
    local real time
    local real cool_time = 1.00 * ( 100 / (100 + as) )
    local integer skill_id = GetSpellAbilityId()
    
    set tic = (R2I(dist) / 20) + 1
    set time = tic * 0.01 + 0.01

    call Effect_Fixed_On_Unit(u, -25, angle, 90, 100, eff_height, time + 0.02, 0, 0, angle, eff, 0.01)
    
    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, time + 0.02, 0.01)
    call Unit_Motion(u, 3, 100, 0.01)
    call Unit_Move(u, tic, 20, 0, angle, 0.01, 0.01)
    
    call Unit_Dmg_Fixed_On_Unit(u, dmg, 75, angle, size, time + 0.02, dmg_type, u, 0.01)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    // 분신 스킬 추가 타격
    if Get_Unit_Property(u, CUSTOM_INT_0) > 0 then
        call Unit_Motion(mirror[pid], 1, 100, 0.01)
        call Effect_Attached(mirror[pid], mirror_pad, angle, 80, 100, 50, 0.1, 0, 0, GRR(0, 360), false, eff2, 0.08)
        call Effect_Attached(mirror[pid], mirror_pad, angle, 80, 100, 50, 0.1, 0, 0, GRR(0, 360), false, eff2, 0.14)
        call Effect_Attached(mirror[pid], mirror_pad, angle, 80, 100, 50, 0.1, 0, 0, GRR(0, 360), false, eff2, 0.20)
        call Unit_Area_Dmg_With_Owner(mirror[pid], dmg/5, mirror_pad, angle, size, dmg_type, u, 0.08)
        call Unit_Area_Dmg_With_Owner(mirror[pid], dmg/5, mirror_pad, angle, size, dmg_type, u, 0.14)
        call Unit_Area_Dmg_With_Owner(mirror[pid], dmg/5, mirror_pad, angle, size, dmg_type, u, 0.20)
    endif

    set u = null
endfunction

private function W_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AD_TYPE
    local real base_dmg = W_BASE_DMG
    local real coef = 6.0
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2 
    local real delay = 0.20 * ( 100 / (100 + as) )
    local real ani_speed = 120 * ( (100 + as) / 100 )
    local real pause_time = 0.45 * ( 100 / (100 + as) )
    local real cool_time = 2.50 * ( 100 / (100 + as) )
    local real dist = 225
    local real size = 225
    local real angle = Closest_Angle(u, 550)
    local string eff = "A_0029.mdx"
    local real eff_height = 90
    local integer skill_id = GetSpellAbilityId()
    local real mirror_delay = 0.20 * ( 100 / (100 + as) )
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 1, ani_speed, 0.01)

    // 사운드 필요
    call Effect_Attached(u, 45, angle, 110, 90, eff_height, 0.1, 0, 30, angle, false, eff, delay)
    call Effect_Attached(u, 50, angle, 110, 90, eff_height, 0.1, 0, 30, angle, false, eff, delay)
    call Effect_Attached(u, 55, angle, 110, 90, eff_height, 0.1, 0, 30, angle, false, eff, delay)
    call Unit_Area_Dmg(u, dmg, dist, angle, size, dmg_type, false, delay)
    call Delayed_ND(Player(pid), 0.2, 8, delay)
  
    call Cooldown_Reset(u, skill_id, cool_time)
    
    // 분신 스킬 추가 타격
    if Get_Unit_Property(u, CUSTOM_INT_0) > 0 then
        call Unit_Motion(mirror[pid], 1, ani_speed, delay)
        call Effect_Attached(mirror[pid], 45 + mirror_pad, angle, 110, 90, eff_height+20, 0.1, 0, -30, angle, false, eff, delay + mirror_delay)
        call Effect_Attached(mirror[pid], 50 + mirror_pad, angle, 110, 90, eff_height+20, 0.1, 0, -30, angle, false, eff, delay + mirror_delay)
        call Effect_Attached(mirror[pid], 55 + mirror_pad, angle, 110, 90, eff_height+20, 0.1, 0, -30, angle, false, eff, delay + mirror_delay)
        call Unit_Area_Dmg_With_Owner(mirror[pid], dmg/1.5, dist, angle, size, dmg_type, u, delay + mirror_delay)
        call Delayed_ND(Player(pid), 0.2, 8, delay + mirror_delay)
    endif
    
    set u = null
endfunction

private function Q_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AD_TYPE
    local real base_dmg = Q_BASE_DMG
    local real coef = 1.0
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2 
    local real delay = 0.20 * ( 100 / (100 + as) )
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real pause_time = 0.45 * ( 100 / (100 + as) )
    local real cool_time = 1.00 * ( 100 / (100 + as) )
    local real dist = 175
    local real size = 175
    local real angle = Closest_Angle(u, 550)
    local string eff = "A_0028.mdx"
    local real eff_height = 0
    local integer skill_id = GetSpellAbilityId()
    local real mirror_delay = 0.20 * ( 100 / (100 + as) )

    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    
    // 사운드 필요
    
    call Unit_Motion(u, 0, ani_speed, 0.01)
    call Effect_Attached(u, 25, angle, 110, 100, eff_height, 0.1, 0, -20, angle, false, eff, delay)
    call Unit_Area_Dmg(u, dmg, dist, angle, size, dmg_type, false, delay)
    
    call Unit_Motion(u, 0, ani_speed, delay)
    call Effect_Attached(u, 25, angle, 110, 100, eff_height, 0.1, 0, 20, angle, false, eff, delay * 2)
    call Unit_Area_Dmg(u, dmg, dist, angle, size, dmg_type, false, delay * 2)
  
    call Cooldown_Reset(u, skill_id, cool_time)
    
    // 분신 스킬 추가 타격
    if Get_Unit_Property(u, CUSTOM_INT_0) > 0 then
        call Unit_Motion(mirror[pid], 0, ani_speed, delay * 2)
        call Effect_Attached(mirror[pid], 25 + mirror_pad, angle, 110, 100, eff_height, 0.1, 0, -20, angle, false, eff, delay * 2 + mirror_delay)
        call Unit_Area_Dmg_With_Owner(mirror[pid], dmg/1.5, dist + mirror_pad, angle, size, dmg_type, u, delay * 2 + mirror_delay)
    
        call Unit_Motion(mirror[pid], 0, ani_speed, delay * 2 + delay)
        call Effect_Attached(mirror[pid], 25 + mirror_pad, angle, 110, 100, eff_height, 0.1, 0, 20, angle, false, eff, delay * 2 + mirror_delay + delay)
        call Unit_Area_Dmg_With_Owner(mirror[pid], dmg/1.5, dist + mirror_pad, angle, size, dmg_type, u, delay * 2 + mirror_delay + delay)
    endif
    
    set u = null
endfunction

private function V_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01R'
endfunction

private function C_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01Q'
endfunction

private function X_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01P'
endfunction

private function Z_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01O'
endfunction

private function R_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01N'
endfunction

private function E_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01M'
endfunction

private function W_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01L'
endfunction

private function Q_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01K'
endfunction

private function Shadow_Skills_Init takes nothing returns nothing
    local trigger trg

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