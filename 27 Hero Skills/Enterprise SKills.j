scope Enterprise initializer Skills_Init

globals
    private trigger Q_TRIGGER
    private integer array R_SOUND_ID[3]

    private real Q_BASE_DMG = 20
    private real W_BASE_DMG = 20
    private real R_BASE_DMG = 20
    private real X_BASE_DMG = 50
    private real C_BASE_DMG = 20
endglobals

private function V_Act takes nothing returns nothing

endfunction

private function C_Act takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real duration = 12.0
    local real delay = 3.25
    local real pause_time = 0.50 * ( 100 / (100 + as) )
    local real cool_time = 20.0 * ( 100 / (100 + (as/10.0) ) )
    local real angle = GetUnitFacing(u)
    local real x = Polar_X( GetUnitX(u), 100, angle+180)
    local real y = Polar_Y( GetUnitY(u), 100, angle+180)
    local string eff = "A_0053.mdx"
    local string drop_ship_model = "C_0007.mdx"
    local string tank_model = "C_0006.mdx"
    local integer skill_id = GetSpellAbilityId()
    local unit drop_ship
    local real drop_ship_angle = GRR(0, 360)
    local unit siege_tank
    local real model_size = 1.10
    
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 7, ani_speed, 0.01)
    
    call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A031', 0.01)
    
    set drop_ship = CreateUnit(GetOwningPlayer(u), 'e000', Polar_X(x, 600, drop_ship_angle+180), Polar_Y(y, 600, drop_ship_angle+180), drop_ship_angle)
    call Set_Unit_Model(drop_ship, drop_ship_model, 0.0)
    call SetUnitScale(drop_ship, 0.95, 0.95, 0.95)
    call UnitAddAbility(drop_ship, 'Amrf')
    call UnitRemoveAbility(drop_ship, 'Amrf')
    call SetUnitFlyHeight(drop_ship, 400, 0.0)
    call Unit_Move_Pathable(drop_ship, 50, 24, -0.48, drop_ship_angle, 0.02, 0.0)
    call Unit_Move_Pathable(drop_ship, 50, 0, 0.48, drop_ship_angle, 0.02, 2.0)
    call Remove_Unit(drop_ship, 3.0)
    
    set siege_tank = CreateUnit(GetOwningPlayer(u), 'e000', x, y, angle)
    call SetUnitScale(siege_tank, model_size, model_size, model_size)
    call UnitAddAbility(siege_tank, 'Amrf')
    call UnitRemoveAbility(siege_tank, 'Amrf')
    call SetUnitFlyHeight(siege_tank, 400, 0.0)
    call Set_Unit_Model(siege_tank, ".mdl", 0.0)

    call Set_Unit_Model(siege_tank, tank_model, 1.0)
    call Set_Unit_Height(siege_tank, 0, 800, 1.0)
    call X_Y_Effect(x, y, 100, 100, 0, 0.01, 0, 0, angle, eff, 1.5)
    call Unit_Motion(siege_tank, 8, 100, 1.5)
    call Delayed_ND(Player(pid), 0.20, 12, 1.5)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveUnitHandle(HT, id, 1, siege_tank)
    call SaveReal(HT, id, 2, duration)
    call TimerStart(t, delay, false, function C_Func)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set t = null
    set u = null
    set siege_tank = null
endfunction

private function X_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AP_TYPE
    local real ad_coef = 3.0
    local real ap_coef = 3.0
    local real base_dmg = X_BASE_DMG + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg, ap_coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 1.00 * ( 100 / (100 + as) )
    local real ani_speed = 130 * ( (100 + as) / 100 )
    local real pause_time = 1.25 * ( 100 / (100 + as) )
    local real cool_time = 2.0 * ( 100 / (100 + as) )
    local real size = 175
    local real velocity = 3000
    local real angle = Angle(x, y , end_x, end_y)
    local real add_angle = 25.0
    local string eff = "A_0064.mdx"
    local string eff2 = "A_0060.mdx" /* 총알 궤적기류 */
    local string eff3 = "A_0061.mdx" /* 총쏘는기류퍼지는 */
    local string eff4 = "A_0064.mdx" /* 피격이펙 */
    local string eff5 = "A_0066.mdx" /* 총 팡쏘는이펙 */
    local integer skill_id = GetSpellAbilityId()
    local integer i
    
    set x = Polar_X(GetUnitX(u), 25, angle)
    set y = Polar_Y(GetUnitY(u), 25, angle)

    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 14, ani_speed, 0.01)
    
    set i = -2
    loop
    set i = i + 1
    exitwhen i > 1
        call Effect_Attached(u, 25, angle+add_angle*i, 35, 90, 50, 0.1, 0, 0, angle+add_angle*i, false, eff2, delay)
        call Effect_Attached(u, 25, angle+add_angle*i, 30, 90, 50, 0.1, 0, 0, angle+add_angle*i, false, eff3, delay)
        call Effect_Attached(u, 125, angle+add_angle*i, 200, 100, 100, 0.1, 0, 0, angle+add_angle*i, false, eff5, delay)
        call Sound_Effect(GetUnitX(u), GetUnitY(u), R_SOUND_ID[0], delay + 0.04)
        
        call Generic_Projectile(u, x, y, dmg, size, dmg_type, 0.30, velocity, angle+add_angle*i,/*
        */eff, 100, 80, true, false, false, eff4, "origin", null, delay)
    endloop
    
    call Delayed_ND(Player(pid), 0.20, 12, delay)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function Z_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 130 * ( (100 + as) / 100 )
    local real duration_time = 12.0
    local real pause_time = 0.50 * ( 100 / (100 + as) )
    local real cool_time = 25.0 * ( 100 / (100 + (as/10.0) ) )
    local string eff = "Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl"
    local string eff2 = "A_0055.mdx"
    local string eff3 = "A_0016.mdx"
    local integer skill_id = GetSpellAbilityId()
    local integer ad_value = R2I(Get_Unit_Property(u, AD) / 5.0) + 25
    local real mp_regen_value = Get_Unit_Property(u, MP)/25.0
    
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 15, ani_speed, 0.01)
    call Effect_On_Unit(u, 0.01, 100, "chest", eff, 0.01)
    call Effect_On_Unit(u, duration_time, 100, "overhead", eff2, 0.01)
    call Effect_On_Unit(u, duration_time, 100, "chest", eff3, 0.01)
    
    call Unit_Regen(u, 0.5, 24, mp_regen_value, false, 0.01)
    call Unit_Add_Stat(u, duration_time, AD, ad_value, 0.01)
    
    // 텔포 쿨감 판별용 CUSTOM_INT_0 사용
    call Set_Unit_Custom_Int(u, duration_time, CUSTOM_INT_0, 1, true, 0.01)
    
    call Cooldown_Reset(u, 'A033', 0.0)
    call Cooldown_Reset(u, 'A035', 0.0)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function R_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AD_TYPE
    local real ad_coef = 2.5
    local real ap_coef = 0.5
    local real base_dmg = R_BASE_DMG + Get_Coef_Dmg(u, ap_coef, AP_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg, ad_coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2
    local real start_delay = 0.25 * ( 100 / (100 + as) )
    local real delay = 0.40 * ( 100 / (100 + as) )
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real pause_time = 1.65 * ( 100 / (100 + as) )
    local real cool_time = 8.0 * ( 100 / (100 + as) )
    local real velocity = 2500
    local real size = 150
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0065.mdx" /* 미사일 */
    local string eff2 = "A_0060.mdx" /* 총알 궤적기류 */
    local string eff3 = "A_0061.mdx" /* 총쏘는기류퍼지는 */
    local string eff4 = "A_0065.mdx" /* 피격이펙 */
    local string eff5 = "A_0066.mdx" /* 총 팡쏘는이펙 */
    local integer skill_id = GetSpellAbilityId()
    local integer i
    local integer j = GetRandomInt(0, 2)
    
    set x = Polar_X(GetUnitX(u), 25, angle)
    set y = Polar_Y(GetUnitY(u), 25, angle)
    
    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, pause_time, 0.01)
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= 4
        call Unit_Motion(u, 6, ani_speed, 0.01 + delay*i)
        
        call Effect_Attached(u, 25, angle, 35, 90, 50, 0.1, 0, 0, angle, false, eff2, start_delay + delay*i)
        call Effect_Attached(u, 25, angle, 30, 90, 50, 0.1, 0, 0, angle, false, eff3, start_delay + delay*i)
        call Effect_Attached(u, 125, angle, 200, 100, 100, 0.1, 0, 0, angle, false, eff5, start_delay + delay*i)
        call Sound_Effect(GetUnitX(u), GetUnitY(u), R_SOUND_ID[Mod(i + j, 3)], start_delay + delay*i + 0.04)
        
        call Generic_Projectile(u, x, y, dmg, size, dmg_type, 0.30, velocity, angle,/*
        */eff, 100, 80, true, false, false, eff4, "chest", null, start_delay + delay*i)
    endloop
    
    // Z 버프 판별
    if Get_Unit_Property(u, CUSTOM_INT_0) != 0 then
        set cool_time = cool_time/2.0
    endif
    
    call Cooldown_Reset_Real_Time(u, skill_id, cool_time)
    
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
    local real ani_speed = 100
    local real cool_time = 2.0 * ( 100 / (100 + as) )
    local real eff_size = 100.0
    local real dist = Dist(x, y, end_x, end_y)
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl"
    local integer tic
    local integer unit_dist = 18
    local real interval = 0.01
    local real time
    local integer skill_id = GetSpellAbilityId()
    
    if dist > 360 then
        set dist = 360
    endif
    
    set tic = (R2I(dist) / unit_dist) + 1
    set time = tic * interval + 0.01
    
    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, time + 0.02, 0.01)
    call Unit_Motion(u, 13, ani_speed, 0.01)
    call Unit_Move(u, tic, unit_dist, 0, angle, interval, 0.01)
    call Effect_Continuously_Created_On_Unit(u, 15, angle+180, 100, 100, 0, 0.0, 0, 0, angle, eff, 0.04, time-0.02, 0.01)
    
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
    local real ad_coef = 2.0
    local real ap_coef = 0.5
    local real base_dmg = W_BASE_DMG + Get_Coef_Dmg(u, ap_coef, AP_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg, ad_coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2
    local real start_delay = 0.25 * ( 100 / (100 + as) )
    local real delay = 0.40 * ( 100 / (100 + as) )
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real pause_time = 0.85 * ( 100 / (100 + as) )
    local real cool_time = 4.0 * ( 100 / (100 + as) )
    local real velocity = 2500
    local real size = 150
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0062.mdx"
    local string eff2 = "A_0060.mdx"
    local string eff3 = "A_0061.mdx"
    local string eff4 = "A_0063.mdx"
    local string eff5 = "A_0066.mdx" /* 총 팡쏘는이펙 */
    local integer skill_id = GetSpellAbilityId()
    local integer i
    
    set x = Polar_X(GetUnitX(u), 25, angle)
    set y = Polar_Y(GetUnitY(u), 25, angle)
    
    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, pause_time, 0.01)
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= 2
        call Unit_Motion(u, 6, ani_speed, 0.01 + delay*i)
        call Effect_Attached(u, 25, angle, 35, 90, 50, 0.1, 0, 0, angle, false, eff2, start_delay + delay*i)
        call Effect_Attached(u, 25, angle, 30, 90, 50, 0.1, 0, 0, angle, false, eff3, start_delay + delay*i)
        call Effect_Attached(u, 125, angle, 200, 100, 100, 0.1, 0, 0, angle, false, eff5, start_delay + delay*i)
        call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A019', start_delay + delay*i + 0.04)
        
        call Generic_Projectile(u, x, y, dmg, size, dmg_type, 0.30, velocity, angle,/*
        */eff, 100, 85, true, false, false, eff4, "chest", null, start_delay + delay*i)
    endloop
    
    //call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A01J', delay)
    
    call Cooldown_Reset_Real_Time(u, skill_id, cool_time)
    
    set u = null
endfunction

private function Q_Trigger takes nothing returns nothing
    local Projectile P = last_triggering_projectile
    local real slow_time = 3.0
    local real size = 300
    local string eff = "Abilities\\Spells\\Orc\\StasisTrap\\StasisTotemTarget.mdl"

    call Unit_Area_Buff(P.owner, P.eff_x, P.eff_y, ENTERPRISE_MOVE_SPEED_SLOW, MS, -125, slow_time, size, eff, "overhead", true, 0.0)
    call P.destroy()
endfunction

private function Q_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AP_TYPE
    local real ad_coef = 1.0
    local real ap_coef = 0.5
    local real base_dmg = Q_BASE_DMG + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg, ap_coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.20 * ( 100 / (100 + as) )
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real pause_time = 0.40 * ( 100 / (100 + as) )
    local real cool_time = 5.5 * ( 100 / (100 + as) )
    local real dist = Dist(x, y, end_x, end_y)
    local real angle = Angle(x, y , end_x, end_y)
    local real size = 300
    local real eff_height = 800.0
    local real center_x
    local real center_y
    local string eff = "A_0056.mdx"
    local string eff2 = "A_0067.mdx"
    local integer skill_id = GetSpellAbilityId()
    
    if dist > 800 then
        set dist = 800
    endif
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 6, ani_speed, 0.01)
    
    call Generic_Parabolic_Projectile(u, end_x, end_y, dmg, size, dmg_type, 2.25, 1.0, angle, 0.0,/*
    */ eff, 115, eff_height, false, eff2, 115, Q_TRIGGER, delay)

    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function V_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A039'
endfunction

private function C_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A038'
endfunction

private function X_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A037'
endfunction

private function Z_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A036'
endfunction

private function R_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A035'
endfunction

private function E_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A034'
endfunction

private function W_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A033'
endfunction

private function Q_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A032'
endfunction

private function Skills_Init takes nothing returns nothing
    local trigger trg
    
    set Q_TRIGGER = CreateTrigger()
    call TriggerAddAction(Q_TRIGGER, function Q_Trigger)
    
    set R_SOUND_ID[0] = 'A03A'
    set R_SOUND_ID[1] = 'A03B'
    set R_SOUND_ID[2] = 'A03C'
    
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
