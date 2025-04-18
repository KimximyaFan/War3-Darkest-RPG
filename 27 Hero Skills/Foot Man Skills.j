
scope FootManSkills initializer Foot_Man_Skills_Init

globals
    private real Q_BASE_DMG = 20
    private real W_BASE_DMG = 15
    private real E_BASE_DMG = 30
    private real R_BASE_DMG = 75
    
    real array foot_man_pause_time[8]
    real array foot_man_mana[8]
    integer array foot_man_skill[8]
    string array foot_man_issue_order[8]
    
    
    
    unit global_u
    effect global_eff
    real global_x
    real global_y
    real global_z
    lightning global_lightning
    integer global_int = 0
    
    string eff_str = "A_0021.mdx"
    string eff2_str = "A_0022.mdx"
    
    real absolute_pitch = 0
    real absolute_roll = 0
    real absolute_yaw = 0
endglobals

private function Foot_Man_Variable_Init takes nothing returns nothing
    set foot_man_pause_time[Q] = 0.3
    set foot_man_mana[Q] = 20.0
    set foot_man_skill[Q] = 'A00C'
    set foot_man_issue_order[Q] = "ancestralspirit"
    
    set foot_man_pause_time[W] = 1.25
    set foot_man_mana[W] = 20.0
    set foot_man_skill[W] = 'A00D'
    set foot_man_issue_order[W] = "avatar"
    
    set foot_man_pause_time[E] = 0.5
    set foot_man_mana[E] = 30.0
    set foot_man_skill[E] = 'A00E'
    set foot_man_issue_order[E] = "carrionswarm"
    
    set foot_man_pause_time[R] = 0.75
    set foot_man_mana[R] = 55.0
    set foot_man_skill[R] = 'A00O'
    set foot_man_issue_order[R] = "windwalk"
    
    set foot_man_pause_time[Z] = 0.5
    set foot_man_mana[Z] = 60.0
    set foot_man_skill[Z] = 'A00V'
    set foot_man_issue_order[Z] = "stomp"
    
    set foot_man_pause_time[X] = 0.5
    set foot_man_mana[X] = 60.0
    set foot_man_skill[X] = 'A00W'
    set foot_man_issue_order[X] = "thunderclap"
    
    set foot_man_pause_time[C] = 0.5
    set foot_man_mana[C] = 60.0
    set foot_man_skill[C] = 'A00U'
    set foot_man_issue_order[C] = "resurrection"
endfunction

private function V_Temp_Func takes nothing returns nothing
    local integer pid = 0
    local real x = Get_Mouse_X(pid)
    local real y = Get_Mouse_Y(pid)
    local location loc = Location(x, y)
    local real z = GetLocationZ(loc)
    local real radius = 1500
    local real random_theta = GRR(0, 360)
    local real dist = Dist(global_x, global_y, x, y)
    local real angle
    local real pitch
    local real d_angle
    local real d_pitch
    
    set angle = Angle(global_x, global_y, x, y)
    //set pitch = -AtanBJ( (global_z - z)/dist )
    
    //set d_angle = angle - absolute_yaw
    //set d_pitch = pitch - absolute_pitch
    //set absolute_yaw = absolute_yaw + d_angle
    //set absolute_pitch = absolute_pitch + d_angle
    //call EXEffectMatRotateZ(global_eff, d_angle)
    //call EXEffectMatRotateY(global_eff, d_pitch)
    
    call MoveLightningEx(global_lightning, true, global_x, global_y, global_z, x, y, z)
    
    call Set_Mouse_Position(pid)
    
    if global_int == 1 then
        call Perpendicular_Projectile(global_u, global_x, global_y, 100, 150, false, 1.0, -600, radius * CosBJ(random_theta), radius * SinBJ(random_theta), dist, angle,/*
        */ eff_str, 75, global_z, false, eff2_str, 65, null, 0.01)
    endif
    
    set global_int = Mod(global_int + 1, 2)
    
    call RemoveLocation(loc)
    set loc = null
endfunction

private function V_Temp takes unit u, real x, real y, real eff_height returns nothing
    
    set global_u = u
    
    set global_eff = AddSpecialEffect("Abilities\\Weapons\\DemonHunterMissile\\DemonHunterMissile.mdl", x, y)
    call EXSetEffectSize(global_eff, 3.0)
    //call EXEffectMatRotateY(global_eff, 90)
    //call EXEffectMatRotateZ(global_eff, 90)
    call EXSetEffectZ(global_eff, EXGetEffectZ(global_eff) + eff_height)
    
    set global_x = x
    set global_y = y
    set global_z = EXGetEffectZ(global_eff)
    
    set global_lightning = AddLightningEx("AFOD", true, global_x, global_y, global_z, x, y, 0)
    
    call TimerStart(CreateTimer(), 0.03, true, function V_Temp_Func)
endfunction

private function Temp_Temp_Temp takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local effect e = LoadEffectHandle(HT, id, 0)
    local real angle = LoadReal(HT, id, 1) + 1
    
    call Set_Effect_Euler_Angle(e, angle, 0, 0)
    
    call SaveReal(HT, id, 1, angle)
    
    set t = null
    set e = null
endfunction

private function Temp_Test takes real x, real y returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local effect e = AddSpecialEffect("A_0023.mdx", x, y)
    
    call EXSetEffectZ(e, EXGetEffectZ(e) + 100)
    
    call SaveEffectHandle(HT, id, 0, e)
    call SaveReal(HT, id, 1, 0)
    call TimerStart(t, 0.02, true, function Temp_Temp_Temp)
    
    set t = null
    set e = null
endfunction

private function V_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local unit target = GetSpellTargetUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local real size = 225
    local real dist = Dist(x, y, end_x, end_y)
    local real angle = Angle(x, y , end_x, end_y)
    local real eff_height = 700
    local string eff = "A_0019.mdx"
    
    call SetUnitFacing(u, angle)
    call Unit_Motion(u, 5, 100, 0.01)
    
    call Temp_Test(x, y)
    //call Guided_Projectile(u, target, GetUnitX(target), GetUnitY(target), 10, 1.0, 500, GRR(0, 360), 7, eff, 100, 50, true, null, 100, null, 0.0)

    set u = null
endfunction

private function C_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local integer reduce_value = 20
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 120 * ( (100 + as) / 100 )
    local real duration_time = 12.0
    local real pause_time = 0.50 * ( 100 / (100 + as) )
    local real cool_time = 25.0 * ( 100 / (100 + (as/10.0) ) )
    local string eff = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
    local string eff2 = "A_0010.mdx"
    local integer skill_id = GetSpellAbilityId()
    
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 2, ani_speed, 0.01)
    call Effect_Create(u, 0, GetUnitFacing(u), eff, 0.01)
    call Effect_On_Unit(u, duration_time, 100, "origin", eff2, 0.01)
    call Unit_Add_Stat(u, duration_time, REDUCE_AD, reduce_value, 0.01)
    call Unit_Add_Stat(u, duration_time, REDUCE_AP, reduce_value, 0.01)
    
    call Unit_Taunt(u, 700, 0.02)

    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function X_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 120 * ( (100 + as) / 100 )
    local real duration_time = 12.0
    local real pause_time = 0.50 * ( 100 / (100 + as) )
    local real cool_time = 25.0 * ( 100 / (100 + (as/10.0) ) )
    local string eff = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
    local string eff2 = "A_0009.mdx"
    local integer skill_id = GetSpellAbilityId()
    local integer ad_value = R2I(Get_Unit_Property(u, AD) / 5.0) + 25
    
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 2, ani_speed, 0.01)
    call Effect_Create(u, 0, GetUnitFacing(u), eff, 0.01)
    call Effect_On_Unit(u, duration_time, 100, "left hand", eff2, 0.01)
    
    call Unit_Add_Stat(u, duration_time, AD, ad_value, 0.01)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function Z_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 120 * ( (100 + as) / 100 )
    local real duration_time = 12.0
    local real pause_time = 0.50 * ( 100 / (100 + as) )
    local real cool_time = 25.0 * ( 100 / (100 + (as/10.0) ) )
    local string eff = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
    local string eff2 = "A_0008.mdx"
    local integer skill_id = GetSpellAbilityId()
    local integer def_ad_value = R2I(Get_Unit_Property(u, DEF_AD) / 5.0) + 25
    local integer def_ap_value = R2I(Get_Unit_Property(u, DEF_AP) / 5.0) + 25
    
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 2, ani_speed, 0.01)
    call Effect_Create(u, 0, GetUnitFacing(u), eff, 0.01)
    call Effect_On_Unit(u, duration_time, 100, "right hand", eff2, 0.01)
    
    call Unit_Regen(u, 0.5, 24, Get_Unit_Property(u, HP)/25.0, true, 0.01)

    call Unit_Add_Stat(u, duration_time, DEF_AD, def_ad_value, 0.01)
    call Unit_Add_Stat(u, duration_time, DEF_AP, def_ap_value, 0.01)
    
    call Unit_Taunt(u, 700, 0.02)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

// ap 계수 1.0, ad 계수 0.25
private function R_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AP_TYPE
    local real base_dmg = R_BASE_DMG
    local real coef = 0.75
    local real ad_coef = 0.25
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type) + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real as = Get_Unit_Property(u, AS) / 2 
    local real delay = 0.25 * ( 100 / (100 + as) )
    local real ani_speed = 130 * ( (100 + as) / 100 )
    local real pause_time = 0.75 * ( 100 / (100 + as) )
    local real cool_time = 1.50 * ( 100 / (100 + as) )
    local real dist = 125
    local real size = 250
    local real angle = Closest_Angle(u, 800)
    local string eff = "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl"
    local integer skill_id = GetSpellAbilityId()
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    
    call Unit_Motion(u, 5, ani_speed, 0.01)
    call Effect_Create(u, dist, angle, eff, delay)
    call Unit_Area_Dmg(u, dmg, dist, angle, size, dmg_type, false, delay)

    call Effect_Create(u, dist + 225, angle, eff, delay + 0.15)
    call Unit_Area_Dmg(u, dmg, dist + 225, angle, size, dmg_type, false, delay + 0.15)

    call Effect_Create(u, dist + 450, angle, eff, delay + 0.30)
    call Unit_Area_Dmg(u, dmg, dist + 450, angle, size, dmg_type, false, delay + 0.30)
    
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
    local real coef = 1.80
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2 
    local real dist = Dist(x, y, end_x, end_y)
    local real size = 200
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0003.mdx"
    local integer tic
    local real time
    local real cool_time = 1.00 * ( 100 / (100 + as) )
    local integer skill_id = GetSpellAbilityId()
    
    if dist > 400 then
        set dist = 400
    endif
    
    set tic = (R2I(dist) / 20) + 1
    set time = tic * 0.01 + 0.01
    
    call Effect_On_Unit(u, time, 100, "origin", eff, 0.01)
    
    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, time + 0.02, 0.01)
    call Unit_Motion(u, 7, 150, 0.01)
    call Unit_Move(u, tic, 20, 0, angle, 0.01, 0.01)
    
    call Unit_Area_Dmg(u, dmg, 1, angle, size, dmg_type, false, time)
    
    call Cooldown_Reset(u, skill_id, cool_time)

    set u = null
endfunction



private function W_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AD_TYPE
    local real base_dmg = W_BASE_DMG
    local real coef = 0.8
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2 
    local real delay = 0.25 * ( 100 / (100 + as) )
    local real ani_speed = 160 * ( (100 + as) / 100 )
    local real pause_time = 1.25 * ( 100 / (100 + as) )
    local real cool_time = 1.25 * ( 100 / (100 + as) )
    local real dist = 175
    local real size = 175
    local real angle = Closest_Angle(u, 550)
    local string eff = "A_0002.mdx"
    local integer skill_id = GetSpellAbilityId()
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    
    call Unit_Motion(u, 5, ani_speed, 0.01)
    call Effect_Attached(u, dist, angle, 70, 100, 0, 0, 0, 0, angle, false, eff, delay)
    call Unit_Area_Dmg(u, dmg, dist, angle, size, dmg_type, false, delay)
    
    call Unit_Motion(u, 5, ani_speed, delay * 1)
    call Effect_Attached(u, dist, angle, 70, 100, 0, 0, 0, 0, angle, false, eff, delay * 2)
    call Unit_Area_Dmg(u, dmg, dist, angle, size, dmg_type, false, delay * 2)
    
    call Unit_Motion(u, 5, ani_speed, delay * 2)
    call Effect_Attached(u, dist, angle, 70, 100, 0, 0, 0, 0, angle, false, eff, delay * 3)
    call Unit_Area_Dmg(u, dmg, dist, angle, size, dmg_type, false, delay * 3)
    
    call Unit_Motion(u, 5, ani_speed, delay * 3)
    call Effect_Attached(u, dist, angle, 70, 100, 0, 0, 0, 0, angle, false, eff, delay * 4)
    call Unit_Area_Dmg(u, dmg, dist, angle, size, dmg_type, false, delay * 4)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction
/*
function Effect_Attached takes unit u, real dist, real angle, real eff_size, real eff_speed, real eff_height, real eff_time, real pitch, real roll, real yaw, /*
*/ boolean isFacing, string eff, real delay returns nothing
*/
private function Q_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AD_TYPE
    local real base_dmg = Q_BASE_DMG
    local real coef = 1.25
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.25 * ( 100 / (100 + as) )
    local real ani_speed = 130 * ( (100 + as) / 100 )
    local real pause_time = 0.3 * ( 100 / (100 + as) )
    local real cool_time = 1.0 * ( 100 / (100 + as) )
    local real dist = 175
    local real size = 175
    local real angle = Closest_Angle(u, 400)
    local string eff = "A_0001.mdx"
    local integer skill_id = GetSpellAbilityId()
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 5, ani_speed, 0.01)
    call Effect_Attached(u, dist, angle, 70, 100, 0, 0, 0, 0, angle, false, eff, delay)
    call Unit_Area_Dmg(u, dmg, dist, angle, size, dmg_type, false, delay)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function V_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A00X'
endfunction

private function C_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A00U'
endfunction

private function X_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A00W'
endfunction

private function Z_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A00V'
endfunction

private function R_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A00O'
endfunction

private function E_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A00E'
endfunction

private function W_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A00D'
endfunction

private function Q_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A00C'
endfunction

function Foot_Man_Skills_Init takes nothing returns nothing
    local trigger trg
    
    call Foot_Man_Variable_Init()

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