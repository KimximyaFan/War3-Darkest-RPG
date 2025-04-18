scope NightCrowSkills initializer Night_Crow_Skills_Init

globals
    private real Q_BASE_DMG = 20
    private real W_BASE_DMG = 50
    private real R_BASE_DMG = 40
    private real X_BASE_DMG = 100
    private real C_BASE_DMG = 1000
    
    real array night_crow_pause_time[8]
    real array night_crow_mana[8]
    integer array night_crow_skill[8]
    string array night_crow_issue_order[8]
endglobals

private function Night_Crow_Variable_Init takes nothing returns nothing
    set night_crow_pause_time[Q] = 0.5
    set night_crow_mana[Q] = 5.0
    set night_crow_skill[Q] = 'A00Y'
    set night_crow_issue_order[Q] = "ancestralspirit"
    
    set night_crow_pause_time[W] = 0.5
    set night_crow_mana[W] = 30.0
    set night_crow_skill[W] = 'A00Z'
    set night_crow_issue_order[W] = "flare"
    
    set night_crow_pause_time[E] = 0.20
    set night_crow_mana[E] = 30.0
    set night_crow_skill[E] = 'A010'
    set night_crow_issue_order[E] = "carrionswarm"
    
    set night_crow_pause_time[R] = 0.50
    set night_crow_mana[R] = 35.0
    set night_crow_skill[R] = 'A011'
    set night_crow_issue_order[R] = "stomp"
    
    set night_crow_pause_time[Z] = 0.50
    set night_crow_mana[Z] = 15.0
    set night_crow_skill[Z] = 'A012'
    set night_crow_issue_order[Z] = "thunderclap"
    
    set night_crow_pause_time[X] = 0.50
    set night_crow_mana[X] = 50.0
    set night_crow_skill[X] = 'A013'
    set night_crow_issue_order[X] = "cloudoffog"
    
    set night_crow_pause_time[C] = 0.5
    set night_crow_mana[C] = 100.0
    set night_crow_skill[C] = 'A014'
    set night_crow_issue_order[C] = "blizzard"
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
    local real coef = 10.0
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.01
    local real time_gap = 1.25
    local real ani_speed = 130 * ( (100 + as) / 100 )
    local real pause_time = 0.5 * ( 100 / (100 + as) )
    local real cool_time = 50.0 * ( 100 / (100 + as) )
    local real eff_size = 100.0
    local real size = 700
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0017.mdx"
    local integer skill_id = GetSpellAbilityId()

    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 6, ani_speed, 0.01)
    call X_Y_Effect(end_x, end_y, eff_size, 100, 0, 1.25, 0, 0, GetRandomDirectionDeg(), eff, 0.01)
    
    call Delayed_ND(Player(pid), 0.3, 35, time_gap + 0.01)
    call X_Y_Dmg(u, dmg, end_x, end_y, size, dmg_type, time_gap + 0.01)
    call Area_Stun(u, end_x, end_y, 2.0, size, time_gap + 0.01)
    

    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction
// function Get_Random_Location_In_Range takes real x, real y, real range returns location
private function X_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AP_TYPE
    local real base_dmg = X_BASE_DMG
    local real coef = 1.00
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.20 * ( 100 / (100 + as) )
    local real time_gap = 0.8
    local real ani_speed = 130 * ( (100 + as) / 100 )
    local real pause_time = 0.5 * ( 100 / (100 + as) )
    local real cool_time = 10.0 * ( 100 / (100 + as) )
    local real eff_size = 90.0
    local real size = 325
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0018.mdx"
    local integer skill_id = GetSpellAbilityId()
    local real eff_angle = GetRandomDirectionDeg()
    local integer count = 25
    local integer i
    local location loc
    local real time
    local integer sound_id
    local integer ran

    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 6, ani_speed, 0.01)
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= count
        set time = 0.14 * i + delay
        set loc = Get_Random_Location_In_Range(end_x, end_y, size)
        call X_Y_Effect(GetLocationX(loc), GetLocationY(loc), eff_size, 100, 0, 0.01, 0, 0, eff_angle, eff, time)
        call X_Y_Dmg(u, dmg, GetLocationX(loc), GetLocationY(loc), 200, dmg_type, time + time_gap)
        set ran = GetRandomInt(1, 3)
        if ran == 1 then
            set sound_id = 'A01A'
        elseif ran == 2 then
            set sound_id = 'A019'
        else
            set sound_id = 'A018'
        endif
        call Sound_Effect(GetLocationX(loc), GetLocationY(loc), sound_id, time + time_gap)
        call RemoveLocation(loc)
    endloop
    

    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
    set loc = null
endfunction

private function Z_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 130 * ( (100 + as) / 100 )
    local real duration_time = 12.0
    local real pause_time = 0.50 * ( 100 / (100 + as) )
    local real cool_time = 25.0 * ( 100 / (100 + (as/10.0) ) )
    local string eff = "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl"
    local string eff2 = "A_0016.mdx"
    local integer skill_id = GetSpellAbilityId()
    local integer ap_value = R2I(Get_Unit_Property(u, AP) / 5.0) + 25
    
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 6, ani_speed, 0.01)
    call Effect_On_Unit(u, 0.01, 100, "origin", eff, 0.01)
    call Effect_On_Unit(u, duration_time, 100, "chest", eff2, 0.01)
    
    call Unit_Regen(u, 0.5, 24, Get_Unit_Property(u, MP)/25.0, false, 0.01)
    call Unit_Add_Stat(u, duration_time, AP, ap_value, 0.01)
    
    // 텔포 쿨감 판별용 CUSTOM_INT_0 사용
    call Set_Unit_Custom_Int(u, duration_time, 0, 1, false, 0.01)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function R_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AP_TYPE
    local real base_dmg = R_BASE_DMG
    local real coef = 0.80
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type)
    local real as = Hero(pid+1).Get_AS() / 2
    local real delay = 0.20 * ( 100 / (100 + as) )
    local real ani_speed = 200 * ( (100 + as) / 100 )
    local real pause_time = 0.5 * ( 100 / (100 + as) )
    local real cool_time = 1.00 * ( 100 / (100 + as) )
    local real size = 625
    local real dist = 0
    local real angle = GetUnitFacing(u)
    local string eff = "A_0013.mdx"
    local integer skill_id = GetSpellAbilityId()
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 1, ani_speed, 0.01)
    call Effect_Attached(u, dist, angle, 100, 100, 0, 0, 0, 0, angle, false, eff, delay)
    call Unit_Area_Dmg(u, dmg, dist, angle, size, dmg_type, false, delay)
    call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A016', delay - 0.02)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function E_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 130 * ( (100 + as) / 100 )
    local real cool_time = 2.5 * ( 100 / (100 + as) )
    local real eff_size = 100.0
    local real dist = Dist(x, y, end_x, end_y)
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0012.mdx"
    local integer tic
    local integer unit_dist = 30
    local real interval = 0.01
    local real time
    local integer skill_id = GetSpellAbilityId()
    
    // Z 스킬 사용시, CUSTOM_INT_0 값이 12초간 1로 변함
    // 스킬 쿨감 효과
    if Get_Unit_Property(u, CUSTOM_INT_0) == 1 then
        set cool_time = 1.5 * ( 100 / (100 + as) )
    endif
    
    if dist > 500 then
        set dist = 500
    endif
    
    set tic = (R2I(dist) / unit_dist) + 1
    set time = tic * interval + 0.01
    
    call X_Y_Effect(x, y, eff_size, 200, 0, 0.01, 0, 0, angle, eff, 0.01)
    
    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, time + 0.02, 0.01)
    call Unit_Motion(u, 6, ani_speed, 0.01)
    call Unit_Move(u, tic, unit_dist, 0, angle, interval, 0.01)
    call Set_Unit_Invisible(u, time, 0.01)

    call Effect_Attached(u, 0, angle, eff_size, 200, 0, 0, 0, 0, angle, false, eff, time)
    
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
    local boolean dmg_type = AP_TYPE
    local real base_dmg = W_BASE_DMG
    local real coef = 2.50
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.20 * ( 100 / (100 + as) )
    local real time_gap = 0.75
    local real ani_speed = 130 * ( (100 + as) / 100 )
    local real pause_time = 0.5 * ( 100 / (100 + as) )
    local real cool_time = 4.0 * ( 100 / (100 + as) )
    local real eff_size = 105.0
    local real size = 225.0
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0015.mdx"
    local string eff2 = "A_0014.mdx"
    local integer skill_id = GetSpellAbilityId()
    
    // Z 스킬 사용시, CUSTOM_INT_0 값이 12초간 1로 변함
    // 스킬 쿨감 효과
    if Get_Unit_Property(u, CUSTOM_INT_0) == 1 then
        set cool_time = 1.5 * ( 100 / (100 + as) )
    endif
    
    if Dist(x, y, end_x, end_y) > 850 then
        set end_x = Polar_X(x, 850, angle)
        set end_y = Polar_Y(y, 850, angle)
    endif
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 6, ani_speed, 0.01)

    call X_Y_Effect(end_x, end_y, 200, 75, 0, time_gap + 0.1, 0, 0, angle, eff, delay)
    
    call Delayed_ND(Player(pid), 0.25, 8, time_gap + delay)
    call X_Y_Effect(end_x, end_y, eff_size, 100, 0, 0.01, 0, 0, angle, eff2, time_gap + delay)
    call X_Y_Dmg(u, dmg, end_x, end_y, size, dmg_type, time_gap + delay)
    call Sound_Effect(end_x, end_y, 'A017', time_gap + delay)

    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function Q_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AP_TYPE
    local real base_dmg = Q_BASE_DMG
    local real coef = 0.65
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.25 * ( 100 / (100 + as) )
    local real ani_speed = 130 * ( (100 + as) / 100 )
    local real pause_time = 0.5 * ( 100 / (100 + as) )
    local real cool_time = 0.70 * ( 100 / (100 + as) )
    local real velocity = 900
    local real size = 85
    local real angle = Closest_Angle(u, 850)
    local string eff = "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl"
    local integer skill_id = GetSpellAbilityId()
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 5, ani_speed, 0.01)
    
    call Generic_Projectile(u, Polar_X(GetUnitX(u), 25, angle), Polar_Y(GetUnitY(u), 25, angle), dmg, size, dmg_type, 1.0, velocity, angle,/*
    */eff, 100, 50, false, false, false, null, null, delay)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function V_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A015'
endfunction

private function C_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A014'
endfunction

private function X_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A013'
endfunction

private function Z_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A012'
endfunction

private function R_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A011'
endfunction

private function E_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A010'
endfunction

private function W_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A00Z'
endfunction

private function Q_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A00Y'
endfunction

private function Night_Crow_Skills_Init takes nothing returns nothing
    local trigger trg
    
    call night_Crow_Variable_Init()

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