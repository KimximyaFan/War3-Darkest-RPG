
scope Rita initializer Skills_Init

globals
    private real Q_BASE_DMG = 20
    private real W_BASE_DMG = 20
    private real R_BASE_DMG = 80
    private real X_BASE_DMG = 100
    private real C_BASE_DMG = 70
    
    private integer array C_SOUND_ID[3]
endglobals

private function V_Act takes nothing returns nothing

endfunction

private function C_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local unit scythe = LoadUnitHandle(HT, id, 1)
    local real duration = LoadReal(HT, id, 2)
    local integer count = Mod(LoadInteger(HT, id, 4) + 1, 4)
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AP_TYPE
    local real ad_coef = 0.5
    local real ap_coef = 1.0
    local real base_dmg = C_BASE_DMG + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg , ap_coef, dmg_type)
    local real next_attack_time = 0.15
    local string eff = "A_0070.mdx"
    local string eff2 = "A_0074.mdx"
    local real size = 400
    local real x = GetUnitX(scythe)
    local real y = GetUnitY(scythe)
    local real angle = GRR(0, 366)
    
    call X_Y_Effect(x, y, 85, 125, 50, 2.0, 0, 180, angle, eff, 0.0)
    call X_Y_Effect(x, y, 170, 125, 50, 0.01, 0, 180, angle+100, eff2, 0.0)
    call X_Y_Dmg(u, dmg, x, y, size, dmg_type, 0.0)
    
    call Sound_Effect(x, y, C_SOUND_ID[count], 0.0)
    
    if duration <= 0.0 then
        call Remove_Unit(scythe, 0.10)
        call Timer_Clear(t)
    else
        set duration = duration - next_attack_time
        call SaveReal(HT, id, 2, duration)
        call SaveInteger(HT, id, 4, count)
        call TimerStart(t, next_attack_time, false, function C_Func)
    endif
    
    set t = null
    set u = null
    set scythe = null
endfunction

private function C_Act2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real angle = LoadReal(HT, id, 3)
    local real duration = 3.0
    local real model_size = 1.1
    local string model = "C_0010.mdx"
    local unit scythe
    
    set scythe = CreateUnit(GetOwningPlayer(u), 'e001', GetUnitX(u), GetUnitY(u), angle)
    call SetUnitScale(scythe, model_size, model_size, model_size)
    call UnitAddAbility(scythe, 'Amrf')
    call UnitRemoveAbility(scythe, 'Amrf')
    call SetUnitFlyHeight(scythe, 50, 0.0)
    
    call Set_Unit_Model(scythe, model, 0.0)
    call Unit_Motion(scythe, 13, 125, 0.00)
    
    call Unit_Move_Pathable(scythe, 10, 25, 0, angle, 0.01, 0.0)
    call Unit_Move_Pathable(scythe, 20, 20, -1, angle, 0.02, 0.10)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveUnitHandle(HT, id, 1, scythe)
    call SaveReal(HT, id, 2, duration)
    call SaveInteger(HT, id, 4, 0)
    call TimerStart(t, 0.05, false, function C_Func)
    
    set t = null
    set u = null
    set scythe = null
endfunction

private function C_Act takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real delay = 0.25 * ( 100 / (100 + as) )
    local real pause_time = 0.6 * ( 100 / (100 + as) )
    local real cool_time = 2.0 * ( 100 / (100 + (as/10.0) ) )
    local real angle = Angle(x, y , end_x, end_y)
    local integer skill_id = GetSpellAbilityId()

    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 11, ani_speed, 0.01)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 3, angle)
    call TimerStart(t, delay, false, function C_Act2)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set t = null
    set u = null
endfunction

private function X_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real ad_coef = 2.0
    local real ap_coef = 9.0
    local boolean dmg_type = AP_TYPE
    local real base_dmg = X_BASE_DMG + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg, ap_coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 4
    local real delay = 0.34 * ( 100 / (100 + as) )
    local real size = 325
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0070.mdx"
    local string eff2 = "A_0074.mdx"
    local real eff_height = 90
    local real eff_time = 2.5
    local integer tic = 10
    local real time = delay + 0.40
    local real cool_time = 15.00 * ( 100 / (100 + as) )
    local integer skill_id = GetSpellAbilityId()

    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, time + 0.02, 0.01)
    
    call Unit_Motion_Detailed(u, 4, delay, 100 * (delay / 0.34), 100, 0.01)
    call Unit_Move(u, R2I(delay/0.02), -(130.0/(delay/0.02)), 0, angle, 0.02, 0.01)

    call Unit_Motion(u, 1, 100, 0.01 + delay )
    call Unit_Move(u, tic, 35, 0, angle, 0.01, 0.01 + delay)
    call Unit_Move(u, 15, 28, -2, angle, 0.02, 0.11 + delay)
    
    call Effect_Attached_On_Unit(u, 25, angle, 90, 70, eff_height, eff_time, 0, 15, angle, eff, 0.01 + delay)
    call Effect_Attached_On_Unit_Pre_Yaw_Rotate(u, 25, angle, 200, 70, eff_height, eff_time, 100, 0, 15, angle, eff2, 0.01 + delay)
    call Unit_Dmg_Fixed_On_Unit(u, dmg, 75, angle, size, time + 0.02, dmg_type, u, 0.01 + delay)
    
    call Effect_Attached(u, 25, angle, 60, 125, 50, 2.0, 0, 0, GRR(0, 360), false, eff, 0.01 + delay)
    call Effect_Attached(u, 25, angle, 60, 125, 50, 2.0, 0, 0, GRR(0, 360), false, eff, 0.07 + delay)
    call Effect_Attached(u, 25, angle, 60, 125, 50, 2.0, 0, 0, GRR(0, 360), false, eff, 0.13 + delay)
    call Effect_Attached(u, 25, angle, 120, 125, 50, 0.1, 0, 0, GRR(0, 360), false, eff2, 0.01 + delay)
    call Effect_Attached(u, 25, angle, 120, 125, 50, 0.1, 0, 0, GRR(0, 360), false, eff2, 0.07 + delay)
    call Effect_Attached(u, 25, angle, 120, 125, 50, 0.1, 0, 0, GRR(0, 360), false, eff2, 0.13 + delay)
    call Unit_Area_Dmg(u, dmg/5, 25, angle, size, dmg_type, false, 0.01 + delay)
    call Unit_Area_Dmg(u, dmg/5, 25, angle, size, dmg_type, false, 0.07 + delay)
    call Unit_Area_Dmg(u, dmg/5, 25, angle, size, dmg_type, false, 0.13 + delay)
    
    call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A03P', delay)
    
    call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A03O', 0.19 + delay)
    
    call Delayed_ND(Player(pid), 0.30, 12, 0.01 + delay)
    
    call Cooldown_Reset(u, skill_id, cool_time)

    set u = null
endfunction

private function Z_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 200 * ( (100 + as) / 100 )
    local real duration = 12.0
    local real pause_time = 0.45 * ( 100 / (100 + as) )
    local real cool_time = 25.0 * ( 100 / (100 + (as/10.0) ) )
    local string eff = "A_0071.mdx"
    local string eff2 = "A_0072.mdx"
    local string eff3 = "A_0073.mdx"
    local integer skill_id = GetSpellAbilityId()
    local real shield_value = Get_Max_MP(u) * 3.0 + 4000
    local integer ap_value = R2I(Get_Unit_Property(u, AP) / 5.0) + 25
    
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 7, ani_speed, 0.01)
    
    call Effect_Create(u, 0, GetUnitFacing(u), eff3, 0.01)
    call Effect_On_Unit(u, duration, 100, "chest", eff2, 0.01)
    
    call Unit_Add_Mana(u, 100, true, 0.01)
    call Unit_Add_Shield(u, duration, shield_value, eff, "chest", 0.01)
    call Unit_Add_Stat(u, duration, AP, ap_value, 0.01)
    call Unit_Regen(u, 0.5, 24, Get_Unit_Property(u, MP)/25.0, false, 0.01)
    
    // Q 쿨감 CUSTOM_INT_0 사용
    call Set_Unit_Custom_Int(u, duration, CUSTOM_INT_1, 1, true, 0.01)
    
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
    local boolean dmg_type = AP_TYPE
    local real ap_coef = 5.0
    local real ad_coef = 1.0
    local real base_dmg = R_BASE_DMG + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg, ap_coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.25 * ( 100 / (100 + as) )
    local real ani_speed = 80 * ( (100 + as) / 100 )
    local real pause_time = 0.45 * ( 100 / (100 + as) )
    local real cool_time = 8.0 * ( 100 / (100 + as) )
    local real angle = Angle(x, y , end_x, end_y)
    local real eff_height = 80
    local real eff_time = 2.5
    local string eff = "A_0070.mdx"
    local string eff2 = "A_0074.mdx"
    local integer skill_id = GetSpellAbilityId()
    
    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 3, ani_speed, 0.01)
    
    call Effect_Attached               (u, 100, angle, 75, 75, eff_height, eff_time, 0, 90, angle, false, eff, delay)
    call Effect_Attached_Pre_Yaw_Rotate(u, 100, angle, 150, 75, eff_height, eff_time, 100, 0, 90, angle, false, eff2, delay)
    call Effect_Attached               (u, 100, angle, 100, 75, eff_height, eff_time, 0, 90, angle, false, eff, delay)
    call Effect_Attached_Pre_Yaw_Rotate(u, 100, angle, 200, 75, eff_height, eff_time, 100, 0, 90, angle, false, eff2, delay)
    call Effect_Attached               (u, 100, angle, 125, 75, eff_height, eff_time, 0, 90, angle, false, eff, delay)
    call Effect_Attached_Pre_Yaw_Rotate(u, 100, angle, 250, 75, eff_height, eff_time, 100, 0, 90, angle, false, eff2, delay)
    call Unit_Area_Dmg_Rectangle(u, dmg, -250, angle, 350, 1050, dmg_type, false, delay)
    call Delayed_ND(Player(pid), 0.20, 10, delay)
    
    call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A03S', delay+0.04)

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
    local real ani_speed = 150
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0069.mdx"
    local real eff_height = 10
    local integer tic = 10
    local real time = 0.40 * ( 100 / (100 + as) )
    local real cool_time = 1.50 * ( 100 / (100 + as) )
    local integer skill_id = GetSpellAbilityId()

    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, time, 0.01)
    call Unit_Motion(u, 10, ani_speed, 0.01)
    call Unit_Move(u, tic, 21, 0, angle, 0.01, 0.01)
    call Unit_Move(u, 15, 15, -1, angle, 0.02, 0.11)

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
    local real ad_coef = 0.5
    local real ap_coef = 1.25
    local boolean dmg_type = AP_TYPE
    local real base_dmg = W_BASE_DMG + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg, ap_coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 4
    local real delay = 0.34 * ( 100 / (100 + as) )
    local real ani_speed = 100
    local real size = 275
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0069.mdx"
    local real eff_height = 10
    local real eff_time = 2.5
    local integer tic = 10
    local real time = delay + 0.63 * ( 100 / (100 + as) )
    local real cool_time = 3.00 * ( 100 / (100 + as) )
    local integer skill_id = GetSpellAbilityId()

    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, time + 0.02, 0.01)
    call Unit_Motion_Detailed(u, 4, delay, 100 * (delay / 0.34), 105 * ( (100 + as) / 100 ), 0.01)
    call Unit_Move(u, R2I(delay/0.02), -(130.0/(delay/0.02)), 0, angle, 0.02, 0.01)
    call Unit_Move(u, tic, 20, 0, angle, 0.01, 0.01 + delay)
    call Unit_Move(u, 20, 20, -1, angle, 0.02, 0.11 + delay)
    
    call Effect_Attached_On_Unit(u, 25, angle, 70, 70 * ( (100 + as) / 100 ), eff_height, eff_time, 0, 0, angle, eff, delay)
    call Unit_Area_Dmg(u, dmg, 1, angle, size, dmg_type, false, 0.20 * ( 100 / (100 + as) ) + delay)
    call Unit_Area_Dmg(u, dmg, 1, angle, size, dmg_type, false, 0.35 * ( 100 / (100 + as) ) + delay)
    call Unit_Area_Dmg(u, dmg, 1, angle, size, dmg_type, false, 0.53 * ( 100 / (100 + as) ) + delay)
    call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A03W', 0.20 * ( 100 / (100 + as) ) + delay - 0.04 )
    call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A03W', 0.35 * ( 100 / (100 + as) ) + delay - 0.04 )
    call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A03W', 0.53 * ( 100 / (100 + as) ) + delay - 0.04 )
    
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
    local real ad_coef = 0.5
    local real ap_coef = 1.5
    local boolean dmg_type = AP_TYPE
    local real base_dmg = Q_BASE_DMG + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg, ap_coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 100
    local real size = 200
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0070.mdx"
    local real eff_height = 75
    local real eff_time = 2.5
    local integer tic = 10
    local real time = 0.45 * ( 100 / (100 + as) )
    local real cool_time = 3.00 * ( 100 / (100 + as) )
    local integer skill_id = GetSpellAbilityId()
    local integer motion_num
    local real roll_angle
    local integer sound_id
    
    call Set_Unit_Property(u, CUSTOM_INT_0, Mod( Get_Unit_Property(u, CUSTOM_INT_0) + 1, 2) )
    
    if Get_Unit_Property(u, CUSTOM_INT_0) == 1 then
        set motion_num = 1
        set cool_time = time -0.04
        set roll_angle = 15
        set sound_id = 'A03N'
    else
        set motion_num = 2
        set roll_angle = 165
        
        if Get_Unit_Property(u, CUSTOM_INT_1) != 0 then
            set cool_time = time -0.04
        endif
        set sound_id = 'A03M'
    endif

    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, time, 0.01)
    call Unit_Motion(u, motion_num, ani_speed, 0.01)
    call Unit_Move(u, tic, 18, 0, angle, 0.01, 0.01)
    call Unit_Move(u, 15, 15, -1, angle, 0.02, 0.11)
    
    call Effect_Attached_On_Unit(u, 25, angle, 60, 70, eff_height, eff_time, 0, roll_angle, angle, eff, 0.01)
    call Unit_Dmg_Fixed_On_Unit(u, dmg, 75, angle, size, time + 0.02, dmg_type, u, 0.01)
    
    call Sound_Effect(GetUnitX(u), GetUnitY(u), sound_id, 0.01)
    
    call Cooldown_Reset(u, skill_id, cool_time)

    set u = null
endfunction

private function V_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A03L'
endfunction

private function C_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A03K'
endfunction

private function X_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A03J'
endfunction

private function Z_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A03I'
endfunction

private function R_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A03H'
endfunction

private function E_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A03G'
endfunction

private function W_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A03F'
endfunction

private function Q_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A03E'
endfunction

private function Skills_Init takes nothing returns nothing
    local trigger trg
    
    set C_SOUND_ID[0] = 'A03Q'
    set C_SOUND_ID[1] = 'A03T'
    set C_SOUND_ID[2] = 'A03U'
    set C_SOUND_ID[3] = 'A03V'

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
