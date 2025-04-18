
scope Saber initializer Skills_Init

globals
    private real Q_BASE_DMG = 20
    private real W_BASE_DMG = 20
    private real E_BASE_DMG = 20
    private real R_BASE_DMG = 20
    private real C_BASE_DMG = 20
endglobals

private function Stop_R takes unit u returns nothing
    call Set_Unit_Property(u, CUSTOM_INT_0, 0)
endfunction

// =======================================================

private function V_Act takes nothing returns nothing

endfunction

private function C_Act takes nothing returns nothing

endfunction

private function X_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real pause_time = 0.60 * ( 100 / (100 + as) )
    local real size = 500
    local real angle = GetUnitFacing(u)
    local string eff = "A_0082.mdx"
    local string eff2 = "A_0083.mdx"
    local real duration = 15.0
    local real cool_time = 25.0 * ( 100 / (100 + (as/10.0) ) )
    local real shield_value = Get_Max_MP(u) * 2.0 + 5000
    local integer def_ad_value = R2I(Get_Unit_Property(u, DEF_AD) / 5.0) + 25
    local integer def_ap_value = R2I(Get_Unit_Property(u, DEF_AP) / 5.0) + 25
    local integer reduce_ad_value = 15
    local integer reduce_ap_value = 15
    local integer skill_id = GetSpellAbilityId()
    local group g = Get_Ally_Group(u, x, y, size, null)
    local unit c
    local Buff B = Buff.create(u, SABER_Z_BUFF)
    
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 7, ani_speed, 0.01)
    call X_Y_Effect(x, y, 100, 100, 0, 0.01, 0, 0, angle, eff, 0.01)
    
    // 광역 버프 작용
    loop
    set c = FirstOfGroup(g)
    exitwhen c == null
        call Unit_Add_Shield(c, duration, shield_value, null, null, 0.01)
        
        set B = Buff.create(c, SABER_Z_BUFF)
        call B.Set_Buff_Property(DEF_AD, def_ad_value)
        call B.Set_Buff_Property(DEF_AP, def_ap_value)
        call B.Set_Buff_Property(REDUCE_AD, reduce_ad_value)
        call B.Set_Buff_Property(REDUCE_AP, reduce_ap_value)
        call Set_Unit_Buff(duration, B, eff2, "origin", 0.01)
    endloop
    
    call Cooldown_Reset(u, skill_id, cool_time)

    call Group_Clear(g)
    
    set u = null
    set g = null
    set c = null
endfunction

private function Z_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real pause_time = 0.60 * ( 100 / (100 + as) )
    local real size = 500
    local real angle = GetUnitFacing(u)
    local string eff = "A_0082.mdx"
    local string eff2 = "A_0078.mdx"
    local real duration = 15.0
    local real cool_time = 25.0 * ( 100 / (100 + (as/10.0) ) )
    local integer ad_value = R2I(Get_Unit_Property(u, AD) / 5.0) + 25
    local integer ap_value = R2I(Get_Unit_Property(u, AP) / 5.0) + 25
    local integer enhance_ad_value = 10
    local integer enhance_ap_value = 10
    local integer skill_id = GetSpellAbilityId()
    local group g = Get_Ally_Group(u, x, y, size, null)
    local unit c
    local Buff B = Buff.create(u, SABER_Z_BUFF)
    
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 7, ani_speed, 0.01)
    call X_Y_Effect(x, y, 100, 100, 0, 0.01, 0, 0, angle, eff, 0.01)
    
    // 광역 버프 작용
    loop
    set c = FirstOfGroup(g)
    exitwhen c == null
        set B = Buff.create(c, SABER_Z_BUFF)
        call B.Set_Buff_Property(AD, ad_value)
        call B.Set_Buff_Property(AP, ap_value)
        call B.Set_Buff_Property(ENHANCE_AD, enhance_ad_value)
        call B.Set_Buff_Property(ENHANCE_AP, enhance_ap_value)
        call Set_Unit_Buff(duration, B, eff2, "origin", 0.01)
    endloop
    
    call Cooldown_Reset(u, skill_id, cool_time)

    call Group_Clear(g)
    
    set u = null
    set g = null
    set c = null
endfunction

private function R_Shooting takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer tic = LoadInteger(HT, id, 1) + 1
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real ad_coef = 0.5
    local real ap_coef = 1.0
    local real base_dmg = E_BASE_DMG + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg , ap_coef, AP_TYPE)
    local real as = Get_Unit_Property(u, AS) / 2
    local real attack_cool_time = 0.50 * ( 100 / (100 + as) )
    local real delay = 0.00
    local real angle = GetUnitFacing(u)
    local real fixed_x = LoadReal(HT, id, 3)
    local real fixed_y = LoadReal(HT, id, 4)
    local boolean is_end = false
    local real total_time = 3.0
    local real width = 500
    local real height = 1000
    
    // 공격 사운드
    
    
    call Unit_Area_Dmg_Rectangle(u, dmg, -100, angle, width, height, AP_TYPE, false, delay)
    
    // MoustPosition Library
    if Get_Unit_Property(u, CUSTOM_INT_0) == 0 then
        set is_end = true
    
    // 자동전투 아니고, 마우스 facing 끝났을 때
    elseif Get_Unit_Property(u, IS_AUTO_COMBAT) == 0 and Is_Facing_On(pid) == false then
        set is_end = true
        
    // 자동전투이고, 3.0 초 넘겼을 때    
    elseif Get_Unit_Property(u, IS_AUTO_COMBAT) != 0 and tic * attack_cool_time > total_time then
        set is_end = true
        
    // 움직였을 때,    
    elseif RAbsBJ(fixed_x - GetUnitX(u)) >= 0.0001 or RAbsBJ(fixed_y - GetUnitY(u)) >= 0.0001 then
        set is_end = true
        
    endif
    
    if is_end == true then
        call Stop_Effect_Attached_On_Unit_Facing(id)
        call Stop_Mouse_Facing(pid)
        call Set_Unit_Property(u, CUSTOM_INT_0, 0)
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
    local real cool_time = 6.0 * ( 100 / (100 + as) )
    local integer skill_id = GetSpellAbilityId()
    local string eff = "A_0075.mdx"
    
    // 모션
    call Unit_Motion_Detailed(u, 6, delay, 100, 25, 0.01)
    
    // 엑스칼리버 이펙트
    call Effect_Attached_On_Unit_Facing(u, 25, 0, 100, 100, 0, 3.0, 0, 0, 0, true, eff, delay)
    
    // R 이 진행중임을 나타냄
    call Set_Unit_Property(u, CUSTOM_INT_0, 1)
    
    // 값이 0 이면 자동전투 아님
    if Get_Unit_Property(u, IS_AUTO_COMBAT) == 0 then
        // Mouse Position Library
        // 마우스 좌표 Facing, 움직이면 풀림
        call Unit_Facing_Mouse_Fix_Check(u, 3.0, 0.26, 0.0)
    endif
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, 0) /* tic */
    call SaveInteger(HT, id, 2, skill_id)
    call SaveReal(HT, id, 3, GetUnitX(u))
    call SaveReal(HT, id, 4, GetUnitY(u))
    call TimerStart(t, delay, false, function R_Shooting)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set t = null
    set u = null
endfunction

private function E_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real ad_coef = 1.0
    local real ap_coef = 2.0
    local real base_dmg = E_BASE_DMG + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg , ap_coef, AP_TYPE)
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 130 * ( (100 + as) / 100 )
    local real cool_time = 1.5 * ( 100 / (100 + as) )
    local real size = 400
    local real dist = Dist(x, y, end_x, end_y)
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0081.mdx"
    local string eff2 = "A_0076.mdx"
    local integer tic
    local integer unit_dist = 30
    local real interval = 0.01
    local real time
    local integer skill_id = GetSpellAbilityId()
    
    call Stop_R(u)
    
    if dist > 600 then
        set dist = 600
    endif
    
    set tic = (R2I(dist) / unit_dist) + 1
    set time = tic * interval + 0.01
    
    call X_Y_Effect(x, y, 100.0, 200, 0, 0.01, 0, 0, angle, eff, 0.01)
    
    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, time + 0.02, 0.01)
    call Unit_Motion(u, 6, ani_speed, 0.01)
    call Unit_Move(u, tic, unit_dist, 0, angle, interval, 0.01)
    call Set_Unit_Invisible(u, time, 0.01)

    call Effect_Attached(u, 0, angle, 125.0, 200, 0, 0, 0, 0, angle, false, eff2, time)
    call Unit_Area_Dmg(u, dmg, 1, angle, size, AP_TYPE, false, time)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function W_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real ad_coef = 1.5
    local real ap_coef = 0.5
    local real base_dmg = W_BASE_DMG + Get_Coef_Dmg(u, ap_coef, AP_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg , ad_coef, AD_TYPE)
    local real as = Get_Unit_Property(u, AS) / 2 
    local real delay = 0.25 * ( 100 / (100 + as) )
    local real ani_speed = 160 * ( (100 + as) / 100 )
    local real pause_time = 1.00 * ( 100 / (100 + as) )
    local real cool_time = 1.00 * ( 100 / (100 + as) )
    local real width = 300
    local real height = 400
    local real angle = Closest_Angle(u, 550)
    local string eff = "A_0076.mdx"
    local integer skill_id = GetSpellAbilityId()
    
    call Stop_R(u)
    
    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, pause_time, 0.01)
    
    call Unit_Motion(u, 5, ani_speed, 0.01)
    call Effect_Attached(u, -25, angle, 70, 100, 0, 0, 0, 0, angle, false, eff, delay)
    call Unit_Area_Dmg_Rectangle(u, dmg, -50, angle, width, height, AD_TYPE, false, delay)
    
    call Unit_Motion(u, 5, ani_speed, delay * 1)
    call Effect_Attached(u, -25, angle, 70, 100, 0, 0, 0, 0, angle, false, eff, delay * 2)
    call Unit_Area_Dmg_Rectangle(u, dmg, -50, angle, width, height, AD_TYPE, false, delay * 2)
    
    call Unit_Motion(u, 5, ani_speed, delay * 2)
    call Effect_Attached(u, -25, angle, 70, 100, 0, 0, 0, 0, angle, false, eff, delay * 3)
    call Unit_Area_Dmg_Rectangle(u, dmg, -50, angle, width, height, AD_TYPE, false, delay * 3)

    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function Q_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real ad_coef = 2.0
    local real ap_coef = 3.0
    local real base_dmg = Q_BASE_DMG + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real dmg = Get_Unit_Dmg(u, base_dmg , ap_coef, AP_TYPE)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.25 * ( 100 / (100 + as) )
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real pause_time = 0.60 * ( 100 / (100 + as) )
    local real cool_time = 6.0 * ( 100 / (100 + as) )
    local real size = 400
    local real dist = 0
    local real angle = GetUnitFacing(u)
    local string eff = "A_0079.mdx"
    local integer skill_id = GetSpellAbilityId()
    local real stun_time = 1.5
    
    call Stop_R(u)
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 1, ani_speed, 0.01)
    call Effect_Attached(u, dist, angle, 100, 100, 0, 0, 0, 0, angle, false, eff, delay)
    call Unit_Area_Dmg(u, dmg, dist, angle, size, AP_TYPE, false, delay)
    call Area_Stun_Attached(u, dist, angle, stun_time, size, delay)
    call Sound_Effect(GetUnitX(u), GetUnitY(u), 'A02N', delay)
    call Delayed_ND(Player(pid), 0.2, 8, delay)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function V_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A044'
endfunction

private function C_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A043'
endfunction

private function X_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A042'
endfunction

private function Z_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A041'
endfunction

private function R_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A040'
endfunction

private function E_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A03Z'
endfunction

private function W_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A03Y'
endfunction

private function Q_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A03X'
endfunction

private function Skills_Init takes nothing returns nothing
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
