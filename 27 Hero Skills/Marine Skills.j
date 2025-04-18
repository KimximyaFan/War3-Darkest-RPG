
scope Marine initializer Skills_Init

globals
    private real Q_BASE_DMG = 20
    private real W_BASE_DMG = 20
    private real E_BASE_DMG = 20
    private real R_BASE_DMG = 10
    private real X_BASE_DMG = 100
    private trigger X_TRIGGER
    private real C_BASE_DMG = 250
endglobals

// ========================================================
// Skills
// ========================================================

private function V_Act takes nothing returns nothing

endfunction

private function C_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local unit siege_tank = LoadUnitHandle(HT, id, 1)
    local real duration = LoadReal(HT, id, 2)
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real ad_coef = 6.0
    local real ap_coef = 1.0
    local real base_dmg = C_BASE_DMG + Get_Coef_Dmg(u, ap_coef, AP_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg , ad_coef, AD_TYPE)
    local real as = Get_Unit_Property(u, AS) / 10
    local real delay = 0.25
    local real next_attack_time = 2.50 * ( 100 / (100 + as) )
    local string eff = "A_0059.mdx"
    local real size = 400
    local real x
    local real y
    local real end_x 
    local real end_y
    local real angle
    local group g
    local unit c
    
    set g = Get_Group(u, GetUnitX(siege_tank), GetUnitY(siege_tank), 1200)
    
    set c = Closest_Unit_In_Group(siege_tank, g)
    
    if c != null then
        set x = GetUnitX(siege_tank)
        set y = GetUnitY(siege_tank)
        set end_x = GetUnitX(c)
        set end_y = GetUnitY(c)
        set angle = Angle(x, y, end_x, end_y)
        
        call SetUnitFacing(siege_tank, angle)
        call Unit_Motion(siege_tank, 10, 150, 0.00)

        call X_Y_Effect(end_x, end_y, 50, 200, 0, 0.01, 0, 0, angle, eff, delay)
        call X_Y_Dmg(u, dmg, end_x, end_y, size, AD_TYPE, delay)
        call Delayed_ND(Player(pid), 0.20, 12, 0.0)
        call Delayed_ND(Player(pid), 0.20, 15, delay)
    endif
    
    call Group_Clear(g)
    
    if duration <= 0.0 then
        call Remove_Unit(siege_tank, 1.5)
        call Timer_Clear(t)
    else
        set duration = duration - next_attack_time
        call SaveReal(HT, id, 2, duration)
        call TimerStart(t, next_attack_time, false, function C_Func)
    endif
    
    set t = null
    set u = null
    set siege_tank = null
    set g = null
    set c = null
endfunction

private function C_Act takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 4
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

private function X_Trigger takes nothing returns nothing
    local Projectile P = last_triggering_projectile
    local real stun_time = 1.25
    call Area_Stun(P.owner, P.eff_x, P.eff_y, stun_time, 350, 0.0)
    call Delayed_ND(Player(GetPlayerId(GetOwningPlayer(P.owner))), 0.20, 15, 0.0)
    call P.destroy()
endfunction

private function X_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AP_TYPE
    local real ad_coef = 9.0
    local real ap_coef = 2.0
    local real base_dmg = Q_BASE_DMG + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg, ap_coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 4
    local real delay = 0.25 * ( 100 / (100 + as) )
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real pause_time = 0.5 * ( 100 / (100 + as) )
    local real cool_time = 12.0 * ( 100 / (100 + as) )
    local real dist = Dist(x, y, end_x, end_y)
    local real size = 350
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0057.mdx"
    local string eff2 = "A_0058.mdx"
    local integer skill_id = GetSpellAbilityId()
    
    if dist > 900 then
        set dist = 900
    endif
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 7, ani_speed, 0.01)
    call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A030', 0.01)
    
    call Generic_Parabolic_Projectile(u, x, y, dmg, size, dmg_type, 1300, dist, angle, 0.0,/*
        */ eff, 100, 80, false, eff2, 150, X_TRIGGER, delay)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function Z_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 4
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real duration_time = 12.0
    local real pause_time = 0.50 * ( 100 / (100 + as) )
    local real cool_time = 25.0 * ( 100 / (100 + (as/10.0) ) )
    local string eff = "Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl"
    local string eff2 = "A_0055.mdx"
    local integer skill_id = GetSpellAbilityId()
    local integer ad_value = R2I(Get_Unit_Property(u, AD) / 5.0) + 25

    // Z 판별용 CUSTOM_INT_3
    call Set_Unit_Custom_Int(u, duration_time, CUSTOM_INT_3, 1, true, 0.01)
    
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 7, ani_speed, 0.01)
    
    call Effect_Create(u, 0, GetUnitFacing(u), eff, 0.01)
    call Effect_On_Unit(u, duration_time, 100, "overhead", eff2, 0.01)
    
    call Unit_Add_Stat(u, duration_time, AD, ad_value, 0.01)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function R_Missle takes unit u, unit c returns nothing
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AD_TYPE
    local real ad_coef = 0.5
    local real ap_coef = 0.25
    local real base_dmg = R_BASE_DMG + Get_Coef_Dmg(u, ap_coef, AP_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg, ad_coef, dmg_type)
    local real size = 125
    //local string eff = "Abilities\\Spells\\Other\\TinkerRocket\\TinkerRocketMissile.mdl"
    local string eff = "A_0056.mdx"
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetUnitX(c)
    local real end_y = GetUnitY(c)
    local real dist = Dist(x, y, end_x, end_y)
    local real time = 0.8 + dist/2250

    call Bezier_Guided_Projectile(u, c, x, y, dmg, size, dmg_type, time, -400, GRR(-400, 400), 300, eff, 35, 100, true, null, 100, null, 0.0)
endfunction

/*
private function R_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real duration = LoadReal(HT, id, 1)
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AD_TYPE
    local real ap_coef = 0.5
    local real ad_coef = 0.5
    local real base_dmg = R_BASE_DMG + Get_Coef_Dmg(u, ap_coef, AP_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg, ad_coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2 
    local real delay = 0.40 * ( 100 / (100 + as) )
    local real size = 150
    //local string eff = "Abilities\\Spells\\Other\\TinkerRocket\\TinkerRocketMissile.mdl"
    local string eff = "A_0056.mdx"
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x
    local real end_y
    local real time
    local real velocity = 800
    local real dist
    local group g
    local unit c
    
    set duration = duration - delay
    
    set g = Get_Group(u, x, y, 900, null)
    
    set c = GroupPickRandomUnit(g)
    
    call Group_Clear(g)

    if c != null then
        set end_x = GetUnitX(c)
        set end_y = GetUnitY(c)
        set dist = Dist(x, y, end_x, end_y)
        set time = 0.8 + dist/2250
        call Bezier_Guided_Projectile(u, c, x, y, dmg, size, dmg_type, time, -400, GRR(-400, 400), 300, eff, 50, 100, false, null, 100, null, 0.0)
    endif
    
    if duration <= 0.0 then
        call Timer_Clear(t)
    else
        call SaveReal(HT, id, 1, duration)
        call TimerStart(t, delay, false, function R_Func )
    endif
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction

private function R_Act takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2 
    local real delay = 0.50 * ( 100 / (100 + as) )
    local real ani_speed = 120 * ( (100 + as) / 100 )
    local real pause_time = 0.60 * ( 100 / (100 + as) )
    local real cool_time = 13.00 * ( 100 / (100 + as) )
    local real angle = GetUnitFacing(u)
    local integer skill_id = GetSpellAbilityId()
    local real duration = 12.0
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 7, ani_speed, 0.01)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, duration)
    call TimerStart(t, delay, false, function R_Func )

    call Cooldown_Reset(u, skill_id, cool_time)
    
    set t = null
    set u = null
endfunction
*/

private function E_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 225
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
    call Unit_Motion(u, 5, ani_speed, 0.01)
    call Unit_Move(u, tic, unit_dist, 0, angle, interval, 0.01)
    call Effect_Continuously_Created_On_Unit(u, 15, angle+180, 100, 100, 0, 0.0, 0, 0, angle, eff, 0.04, time-0.02, 0.01)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function W_Act takes unit u, unit target returns nothing
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AD_TYPE
    local real ad_coef = 2.0
    local real ap_coef = 0.25
    local real base_dmg = W_BASE_DMG + Get_Coef_Dmg(u, ap_coef, AP_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg, ad_coef, dmg_type)
    local real size = 225
    local string eff = "Abilities\\Weapons\\Mortar\\MortarMissile.mdl"
    local real x = GetUnitX(target)
    local real y = GetUnitY(target)
    local real angle = GetUnitFacing(u)

    call X_Y_Effect(x, y, 150, 100, 0, 0.01, 0, 0, angle, eff, 0.05)
    call X_Y_Dmg(u, dmg, x, y, size, dmg_type, 0.05)
endfunction

private function Q_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real duration = 10.0
    local integer as_value = R2I(Get_Unit_Property(u, AS) / 2.5) + 100
    local integer ms_value = R2I(Get_Unit_Property(u, MS) / 10.0) + 25
    local integer skill_id = GetSpellAbilityId()
    local Buff B = Buff.create(u, MARINE_STEAM_PACK)
    local real hp_value = Get_HP(u) - GetUnitState(u, UNIT_STATE_MAX_LIFE) * 0.12
    
    if hp_value <= 1.0 then
        set hp_value = 1.0
    endif
    
    call Set_Unit_Property(u, CUSTOM_INT_0, Mod(Get_Unit_Property(u, CUSTOM_INT_0) + 1, 2) )
    
    if Get_Unit_Property(u, CUSTOM_INT_0) == 1 then
        call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A02Y', 0.01)
    else
        call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A02Z', 0.01)
    endif
    
    call Set_HP(u, hp_value )
    
    call B.Set_Buff_Property(AS, as_value)
    call B.Set_Buff_Property(MS, ms_value)
    call Set_Unit_Buff(duration, B, null, null, 0.01)

    set u = null
endfunction

// ========================================================
// Damage Engine
// ========================================================

private function Marine_Attack_Event takes nothing returns nothing
    local unit u = GetEventDamageSource()
    local unit target = GetTriggerUnit()
    local integer level_flag = Get_Unit_Property(u, LEVEL_FLAG)
    local attacktype attack_type = ConvertAttackType(EXGetEventDamageData(6))
    
    if attack_type != ConvertAttackType(AD_BASIC_ATTACK) then
        set u = null
        set target = null
        set attack_type = null
        return
    endif
    
    if level_flag > W then
        call Set_Unit_Property(u, CUSTOM_INT_1, Mod(Get_Unit_Property(u, CUSTOM_INT_1) + 1, 3) )
        
        if Get_Unit_Property(u, CUSTOM_INT_3) != 0 or Get_Unit_Property(u, CUSTOM_INT_1) == 2 then
            call W_Act(u, target)
        endif
    endif
    
    if level_flag > R then
        call R_Missle(u, target)
    endif

    set u = null
    set target = null
    set attack_type = null
endfunction

private function Marine_Damage_Engine_Register takes nothing returns nothing
    call DERegisterUnitTypeAttackEvent( 'H00C', function Marine_Attack_Event )
endfunction

// ========================================================
// Basic
// ========================================================

private function V_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A02X'
endfunction

private function C_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A02W'
endfunction

private function X_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A02V'
endfunction

private function Z_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A02U'
endfunction

private function R_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A02T'
endfunction

private function E_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A02S'
endfunction
/*
private function W_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A02R'
endfunction
*/
private function Q_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A02Q'
endfunction

private function Skills_Init takes nothing returns nothing
    local trigger trg
    
    call Marine_Damage_Engine_Register()
    
    set X_TRIGGER = CreateTrigger()
    call TriggerAddAction(X_TRIGGER, function X_Trigger)

    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function Q_Con ) )
    call TriggerAddAction( trg, function Q_Act )
    /*
    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function W_Con ) )
    call TriggerAddAction( trg, function W_Act )
    */
    set trg = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( trg, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function E_Con ) )
    call TriggerAddAction( trg, function E_Act )
    /*
    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg , EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( trg, Condition( function R_Con ) )
    call TriggerAddAction( trg, function R_Act )
    */
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
