scope Barbarian initializer Skills_Init

globals
    private real Q_BASE_DMG = 40
    
    private real W_BASE_DMG = 10
    private integer array W_HIT_SOUND[4]
    
    private real E_BASE_DMG = 35
    private real R_BASE_DMG = 80
    
    private real Z_Life_Steal_Ratio = 25.0
    
    private real X_BASE_DMG = 60
    private real C_BASE_DMG = 500
    
endglobals

// ==================================================
// Functions
// ==================================================

private function Barbarian_Z_Attack_Event takes nothing returns nothing
    local unit u = GetEventDamageSource()
    local real dmg = GetEventDamage()
    local real heal_value
    
    if Get_Unit_Property(u, CUSTOM_INT_1) == 0 then
        set u = null
        return
    endif
    
    set heal_value = dmg * Z_Life_Steal_Ratio / 100.0
    call Set_HP(u, Get_HP(u) + heal_value )

    set u = null
endfunction

private function Z_Preprocess takes nothing returns nothing
    call DERegisterUnitTypeAttackEvent( 'H00B', function Barbarian_Z_Attack_Event )
endfunction

private function W_Sound_Preprocess takes nothing returns nothing
    set W_HIT_SOUND[0] = 'A02I'
    set W_HIT_SOUND[1] = 'A02J'
    set W_HIT_SOUND[2] = 'A02K'
endfunction

private function Stop_W takes unit u returns nothing
    call SetUnitPathing(u, true)
    call AddUnitAnimationProperties( u, "gold", false)
    call Set_Unit_Property(u, CUSTOM_INT_0, 0)
endfunction

private function Set_Gold takes unit u, boolean is_gold returns nothing
    call AddUnitAnimationProperties( u, "gold", is_gold)
endfunction

// ==================================================
// Skills
// ==================================================

private function V_Act takes nothing returns nothing

endfunction

private function C_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AD_TYPE
    local real ad_coef = 20.0
    local real dmg = Get_Unit_Dmg(u, C_BASE_DMG, ad_coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 4 
    local real cool_time = 25.00 * ( 100 / (100 + as) )
    local real dist = Dist(x, y, end_x, end_y)
    local real dist_2 = 0
    local real width = 900
    local real height = 1500
    local real eff_size = 100
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0053.mdx"
    local string eff2 = "A_0054.mdx"
    local integer skill_id = GetSpellAbilityId()
    local integer i
    local integer tic
    local real time = 0.66
    local real velocity
    
    call Stop_W(u)
    
    if dist > 700 then
        set dist = 700
    endif
    
    set tic = 30
    set velocity = dist/30
    
    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, time + 0.5, 0.01)
    call Unit_Jump_Height_and_Time(u, 400, time, 0.01)
    call Unit_Move(u, tic, velocity, 0, angle, 0.02, 0.01)
    call Unit_Motion(u, 0, 125, 0.01)
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 4
        call Effect_Attached(u, dist_2, angle, eff_size, 100, 0, 0.1, 0, 0, angle, false, eff, time)
        call Effect_Attached(u, dist_2, angle, eff_size, 75, 0, 0.1, 0, 0, angle, false, eff2, time)
        set dist_2 = dist_2 + 225
    endloop

    call Unit_Area_Dmg_Rectangle(u, dmg, -225, angle, width, height, dmg_type, false, time)
    
    call Delayed_ND(Player(pid), 0.20, 30, time)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function X_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AD_TYPE
    local real ad_coef = 3.0
    local real ap_coef = 0.5
    local real base_dmg = X_BASE_DMG + Get_Coef_Dmg(u, ap_coef, AP_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg, ad_coef, AD_TYPE)
    local real as = Get_Unit_Property(u, AS) / 2 
    local real delay = 0.25 * ( 100 / (100 + as) )
    local real ani_speed = 300 * ( (100 + as) / 100 )
    local real pause_time = 1.50 * ( 100 / (100 + as) )
    local real cool_time = 8.0 * ( 100 / (100 + as) )
    local real dist = 250
    local real size = 250
    local real angle = Closest_Angle(u, 550)
    local string eff = "A_0049.mdx"
    local integer skill_id = GetSpellAbilityId()
    local integer i
    local real current_delay = 0.01
    
    call Stop_W(u)
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    
    set i = - 1
    loop
    set i = i + 1
    exitwhen i >= 3
        call Unit_Motion(u, 10, ani_speed, current_delay)
        
        call Unit_Add_Life(u, -10.0, true, current_delay + delay)
        call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A02O', current_delay + delay)
        call Effect_Attached(u, 100, angle, 350, 90, 125, 0.1, 0, 30, angle, false, eff, current_delay + delay)
        call Unit_Area_Dmg(u, dmg, dist, angle, size, dmg_type, false, current_delay + delay)
        
        call Unit_Add_Life(u, -10.0, true, current_delay + delay*2)
        call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A02P', current_delay + delay*2)
        call Effect_Attached(u, 100, angle, 350, 90, 125, 0.1, 0, 150, angle, false, eff, current_delay + delay*2)
        call Unit_Area_Dmg(u, dmg, dist, angle, size, dmg_type, false, current_delay + delay*2)
        set current_delay = current_delay + (delay*2)
    endloop

    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function Z_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real duration_time = 12.0
    local real pause_time = 0.50 * ( 100 / (100 + as) )
    local real cool_time = 25.0 * ( 100 / (100 + (as/10.0) ) )
    local string eff = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
    local string eff2 = "A_0050.mdx"
    local string eff3 = "A_0051.mdx"
    local integer skill_id = GetSpellAbilityId()
    local integer ad_value = R2I(Get_Unit_Property(u, AD) / 10.0) + 10
    local integer as_value = R2I(Get_Unit_Property(u, AS) / 10.0) + 10
    local integer ms_value = R2I(Get_Unit_Property(u, MS) / 10.0) + 10
    
    call Stop_W(u)
    
    // Z 판별용 CUSTOM_INT_1
    call Set_Unit_Custom_Int(u, duration_time, CUSTOM_INT_1, 1, true, 0.01)
    
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 6, ani_speed, 0.01)
    
    call Effect_Create(u, 0, GetUnitFacing(u), eff, 0.01)
    call Effect_On_Unit(u, duration_time, 100, "chest", eff2, 0.01)
    call Effect_On_Unit(u, duration_time, 100, "overhead", eff3, 0.01)
    
    call Unit_Add_Stat(u, duration_time, AD, ad_value, 0.01)
    call Unit_Add_Stat(u, duration_time, AS, as_value, 0.01)
    call Unit_Add_Stat(u, duration_time, MS, ms_value, 0.01)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function R_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real ad_coef = 6.0
    local real ap_coef = 1.0
    local real base_dmg = R_BASE_DMG + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg , ap_coef, AP_TYPE)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.20 * ( 100 / (100 + as) )
    local real ani_speed = 150 * ( (100 + as) / 100 )
    local real pause_time = 0.75 * ( 100 / (100 + as) )
    local real cool_time = 8.00 * ( 100 / (100 + as) )
    local real size = 500
    local real dist = 0
    local real angle = GetUnitFacing(u)
    local string eff = "A_0052.mdx"
    local integer skill_id = GetSpellAbilityId()
    
    call Stop_W(u)
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 8, ani_speed, 0.01)
    call Effect_Attached(u, dist, angle, 130, 100, 0, 0, 0, 0, angle, false, eff, delay)
    call Unit_Area_Dmg(u, dmg, dist, angle, size, AP_TYPE, false, delay)
    call Area_Stun_Attached(u, dist, angle, 1.5, size, delay)
    call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A02N', delay)
    call Delayed_ND(Player(pid), 0.2, 10, delay)
    
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
    local boolean dmg_type = AD_TYPE
    local real base_dmg = E_BASE_DMG
    local real coef = 2.0
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 4
    local real dist = Dist(x, y, end_x, end_y)
    local real size = 250
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0001.mdx"
    local string eff2 = "Abilities\\Spells\\Orc\\StasisTrap\\StasisTotemTarget.mdl"
    local integer tic
    local real time = 0.66
    local real cool_time = 2.5 * ( 100 / (100 + as) )
    local integer skill_id = GetSpellAbilityId()
    local real velocity
    
    if dist > 700 then
        set dist = 700
    endif
    
    call Stop_W(u)
    
    set tic = 30
    set velocity = dist/30
    
    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, time + 0.05, 0.01)
    call Unit_Jump_Height_and_Time(u, 300, time, 0.01)
    call Unit_Move(u, tic, velocity, 0, angle, 0.02, 0.01)
    call Unit_Motion(u, 0, 125, 0.01)
    
    call Effect_Attached(u, 1, angle, 100, 100, 0, 0, 0, 0, angle, false, eff, time)
    call Unit_Area_Dmg(u, dmg, 1, angle, size, dmg_type, false, time)
    
    call Unit_Area_Buff_Attached(u, BARBARIAN_ATTACK_SPEED_SLOW, AS, -30, 2.5, 1, angle, 250, eff2, "overhead", true, time)
    call Unit_Area_Buff_Attached(u, BARBARIAN_MOVE_SPEED_SLOW, MS, -75, 2.5, 1, angle, 250, null, "overhead", true, time)
    
    call Cooldown_Reset(u, skill_id, cool_time)

    set u = null
endfunction

private function W_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer tic = LoadInteger(HT, id, 1) + 1
    local integer skill_id = LoadInteger(HT, id, 2)
    local real before_x = LoadReal(HT, id, 3)
    local real before_y = LoadReal(HT, id, 4)
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real dmg = Get_Unit_Dmg(u, W_BASE_DMG, 1.25, AD_TYPE)
    local real as = Get_Unit_Property(u, AS) / 2
    local real attack_cool_time = 0.45 * ( 100 / (100 + as) )
    local real angle = GetUnitFacing(u)
    local real size = 225
    local boolean is_end = false
    
    call Unit_Area_Dmg_Sound_If_Hit(u, dmg, 1, angle, size, AD_TYPE, false, W_HIT_SOUND[Mod(tic, 3)], 0.00)
    
    if IsTerrainPathable(GetUnitX(u), GetUnitY(u), PATHING_TYPE_WALKABILITY) == false then
        set before_x = GetUnitX(u)
        set before_y = GetUnitY(u)
    else
        call SetUnitX(u, before_x)
        call SetUnitY(u, before_y)
    endif
    
    if tic * attack_cool_time > 3.0 or Get_Unit_Property(u, CUSTOM_INT_0) == 0 then
        set is_end = true
    endif
    
    if is_end == true then
        call Cooldown_Reset(u, skill_id, 0.01)
        call SetUnitPathing(u, true)
        
        if Get_Unit_Property(u, CUSTOM_INT_0) != 0 then
            call Set_Gold(u, false)
            call Set_Unit_Property(u, CUSTOM_INT_0, 0)
        endif

        call Timer_Clear(t)
    else
        call SaveInteger(HT, id, 1, tic)
        call SaveReal(HT, id, 3, before_x)
        call SaveReal(HT, id, 4, before_y)
        call TimerStart(t, attack_cool_time, false, function W_Func)
    endif
    
    set t = null
    set u = null
endfunction

private function W_Act takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local unit u = GetTriggerUnit()
    local integer skill_id = GetSpellAbilityId()
    
    call Set_Gold(u, true)
    call Unit_Motion(u, 4, 100, 0.01)
    
    // W 판별용 CUSTOM_INT_0
    call Set_Unit_Property(u, CUSTOM_INT_0, 1)
    call SetUnitPathing(u, false)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, 0) /* tic */
    call SaveInteger(HT, id, 2, skill_id)
    call SaveReal(HT, id, 3, GetUnitX(u))
    call SaveReal(HT, id, 4, GetUnitX(u))
    call TimerStart(t, 0.01, false, function W_Func)
    
    set t = null
    set u = null
endfunction

private function Q_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AD_TYPE
    local real coef = 3.0
    local real dmg = Get_Unit_Dmg(u, Q_BASE_DMG, coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.25 * ( 100 / (100 + as) )
    local real ani_speed = 175 * ( (100 + as) / 100 )
    local real pause_time = 0.45 * ( 100 / (100 + as) )
    local real cool_time = 4.0 * ( 100 / (100 + as) )
    local real dist = 175
    local real size = 175
    local real angle = Closest_Angle(u, 400)
    local string eff = "A_0049.mdx"
    local integer skill_id = GetSpellAbilityId()
    local real heal_value = ( Get_Unit_Property(u, HP) - GetUnitState(u, UNIT_STATE_LIFE) ) * 0.15
    
    call Stop_W(u)
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 9, ani_speed, 0.01)
    call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A02L', delay - 0.02)
    call Effect_Attached(u, 50, angle, 275, 90, 100, 0.1, 0, 150, angle, false, eff, delay)
    call Unit_Area_Dmg_Life_Steal_If_Hit(u, dmg, dist, angle, size, dmg_type, false, false, heal_value, delay)
    

    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function V_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A027'
endfunction

private function C_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A026'
endfunction

private function X_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A025'
endfunction

private function Z_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A024'
endfunction

private function R_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A023'
endfunction

private function E_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A022'
endfunction

private function W_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A021'
endfunction

private function Q_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A020'
endfunction

private function Skills_Init takes nothing returns nothing
    local trigger trg
    
    call W_Sound_Preprocess()
    call Z_Preprocess()

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
