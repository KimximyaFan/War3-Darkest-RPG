scope ElfKnight initializer Skills_Init

globals
    private real Q_BASE_DMG = 20
    private real W_BASE_DMG = 50
    private real R_BASE_DMG = 40
    private real Z_BASE_DMG = 50
    private real X_BASE_DMG = 100
    
    real array elf_knight_pause_time[8]
    real array elf_knight_mana[8]
    integer array elf_knight_skill[8]
    string array elf_knight_issue_order[8]
endglobals

private function Elf_knight_Variable_Init takes nothing returns nothing
    set elf_knight_pause_time[Q] = 0.3
    set elf_knight_mana[Q] = 20.0
    set elf_knight_skill[Q] = 'A01S'
    set elf_knight_issue_order[Q] = "ancestralspirit"
    
    set elf_knight_pause_time[W] = 0.35
    set elf_knight_mana[W] = 20.0
    set elf_knight_skill[W] = 'A01T'
    set elf_knight_issue_order[W] = "flare"
    
    set elf_knight_pause_time[E] = 0.35
    set elf_knight_mana[E] = 5.0
    set elf_knight_skill[E] = 'A01V'
    set elf_knight_issue_order[E] = "carrionswarm"
    
    set elf_knight_pause_time[R] = 0.6
    set elf_knight_mana[R] = 40.0
    set elf_knight_skill[R] = 'A01U'
    set elf_knight_issue_order[R] = "stomp"
    
    set elf_knight_pause_time[Z] = 0.50
    set elf_knight_mana[Z] = 50.0
    set elf_knight_skill[Z] = 'A01W'
    set elf_knight_issue_order[Z] = "thunderclap"
    
    set elf_knight_pause_time[X] = 0.60
    set elf_knight_mana[X] = 75.0
    set elf_knight_skill[X] = 'A01X'
    set elf_knight_issue_order[X] = "cloudoffog"
    
    set elf_knight_pause_time[C] = 0.6
    set elf_knight_mana[C] = 100.0
    set elf_knight_skill[C] = 'A01Y'
    set elf_knight_issue_order[C] = "avatar"
endfunction

private function V_Act takes nothing returns nothing

endfunction

private function C_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer count = LoadInteger(HT, id, 1) - 1
    local real x = LoadReal(HT, id, 2)
    local real y = LoadReal(HT, id, 3)
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real size = 500
    local group g = Get_Ally_Group(u, x, y, 500, null)
    local unit c
    local real heal_value
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        set heal_value = Get_Unit_Property(u, AP)/5 + Get_Unit_Property(c, HP)/12.5
        call Unit_Regen(c, 0.25, 4, heal_value, true, 0.0)
        call Unit_Add_Stat(u, 1.0, REDUCE_AD, 15, 0.00)
        call Unit_Add_Stat(u, 1.0, REDUCE_AP, 15, 0.00)
        call Effect_On_Unit(c, 1.8, 100, "origin", "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", 0.00)
    endloop
    
    call Group_Clear(g)
    
    if count <= 0 then
        call Timer_Clear(t)
    else
        call SaveInteger(HT, id, 1, count)
        call TimerStart(t, 1.00, false, function C_Func )
    endif
    
    set t = null
    set u = null
    set g = null
    set c = null
endfunction

private function C_Act takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real duration_time = 10.0
    local real delay = 0.60 * ( 100 / (100 + as) )
    local real pause_time = 0.60 * ( 100 / (100 + as) )
    local real cool_time = 30.0 * ( 100 / (100 + (as/10.0) ) )
    local real angle = GetUnitFacing(u)
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local string eff = "A_0044.mdx"
    local string eff2 = "A_0046.mdx"
    local integer skill_id = GetSpellAbilityId()
    local integer count = 10
    
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 7, ani_speed, 0.01)
    call X_Y_Effect(x, y, 200, 75, 0, 0.01, 0, 0, angle, eff, 0.01)
    call X_Y_Effect(x, y, 200, 100, 0, 8.5, 0, 0, angle, eff2, delay)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, count)
    call SaveReal(HT, id, 2, x)
    call SaveReal(HT, id, 3, y)
    call TimerStart(t, delay, false, function C_Func )
    
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
    local boolean dmg_type = AP_TYPE
    local real base_dmg = X_BASE_DMG
    local real coef = 3.0
    local real ad_coef = 3.0
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type) + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real as = Get_Unit_Property(u, AS) / 2 
    local real delay = 0.60 * ( 100 / (100 + as) )
    local real ani_speed = 125 * ( (100 + as) / 100 )
    local real pause_time = 1.00 * ( 100 / (100 + as) )
    local real cool_time = 12.00 * ( 100 / (100 + as) )
    local real dist = 150
    local real size = 250
    local real eff_size = 85
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0041.mdx"
    local integer skill_id = GetSpellAbilityId()
    local integer i
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 4, ani_speed, 0.01)
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 4
        call Effect_Attached(u, dist, angle-30, eff_size, 90, 0, 0.1, 0, 0, angle-30, false, eff, delay + 0.15 * i)
        call Unit_Area_Dmg(u, dmg, dist, angle-30, size, dmg_type, false, delay + 0.15 * i)
    
        call Effect_Attached(u, dist, angle, eff_size, 90, 0, 0.1, 0, 0, angle, false, eff, delay + 0.15 * i)
        call Unit_Area_Dmg(u, dmg, dist, angle, size, dmg_type, false, delay + 0.15 * i)
        
        call Effect_Attached(u, dist, angle+30, eff_size, 90, 0, 0.1, 0, 0, angle+30, false, eff, delay + 0.15 * i)
        call Unit_Area_Dmg(u, dmg, dist, angle+30, size, dmg_type, false, delay + 0.15 * i)
        
        set dist = dist + 225
    endloop
    
    call Delayed_ND(Player(pid), 0.60, 12, delay)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function Z_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2
    local real ani_speed = 100 * ( (100 + as) / 100 )
    local real duration_time = 15.0
    local real pause_time = 0.50 * ( 100 / (100 + as) )
    local real cool_time = 20.0 * ( 100 / (100 + (as/10.0) ) )
    local real angle = GetUnitFacing(u)
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local string eff = "A_0044.mdx"
    local string eff2 = "A_0043.mdx"
    local integer skill_id = GetSpellAbilityId()
    local integer ad_value = R2I(Get_Unit_Property(u, AD) / 5.0) + 25
    local integer ap_value = R2I(Get_Unit_Property(u, AP) / 5.0) + 25
    
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 7, ani_speed, 0.01)
    
    call X_Y_Effect(x, y, 200, 75, 0, 0.01, 0, 0, angle, eff, 0.01)
    call Effect_On_Unit(u, duration_time, 100, "chest", eff2, 0.01)
    
    call Unit_Regen(u, 0.5, 30, Get_Unit_Property(u, MP)/25.0, false, 0.01)
    call Unit_Add_Stat(u, duration_time, AD, ad_value, 0.01)
    call Unit_Add_Stat(u, duration_time, AP, ap_value, 0.01)
    
    // 판별용 CUSTOM_INT_1 사용
    call Set_Unit_Custom_Int(u, duration_time, 1, 1, true, 0.01)
    
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function R_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local group g = LoadGroupHandle(HT, id, 1)
    local integer count = LoadInteger(HT, id, 2) - 1
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AP_TYPE
    local real base_dmg = R_BASE_DMG
    local real coef = 1.0
    local real ad_coef = 1.0
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type) + Get_Coef_Dmg(u, ad_coef, AD_TYPE)
    local real size = 200
    local string eff = "A_0045.mdx"
    local unit c
    
    if g == null then
        set g = Get_Group(u, GetUnitX(u), GetUnitY(u), 800, null)
    endif
    
    set c = FirstOfGroup(g)
    call GroupRemoveUnit(g, c)
    
    if c == null or CountUnitsInGroup(g) == 0 then
        call Group_Clear(g)
        set g = null
    endif
    
    if c != null then
        call Delayed_ND(Player(pid), 0.25, 8, 0.01)
        call X_Y_Effect(GetUnitX(c), GetUnitY(c), 100, 100, 0, 0.01, 0, 0, GRR(0, 360), eff, 0.01)
        call X_Y_Dmg(u, dmg, GetUnitX(c), GetUnitY(c), size, dmg_type, 0.01)
    endif
    
    if count <= 0 then
        call Timer_Clear(t)
        call Group_Clear(g)
    else
        call SaveGroupHandle(HT, id, 1, g)
        call SaveInteger(HT, id, 2, count)
        call TimerStart(t, 0.22, false, function R_Func )
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
    local real cool_time = 8.00 * ( 100 / (100 + as) )
    local real angle = GetUnitFacing(u)
    local string eff = "A_0044.mdx"
    local integer skill_id = GetSpellAbilityId()
    local group g = null
    local integer count = 8
    
    call SetUnitFacing(u, angle)
    call Hero_Pause(u, pause_time, 0.01)
    call Unit_Motion(u, 7, ani_speed, 0.01)
    call X_Y_Effect(GetUnitX(u), GetUnitY(u), 200, 75, 0, 0.01, 0, 0, angle, eff, 0.01)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveGroupHandle(HT, id, 1, g)
    call SaveInteger(HT, id, 2, count)
    call TimerStart(t, delay, false, function R_Func )

    call Cooldown_Reset(u, skill_id, cool_time)
    
    set t = null
    set u = null
    set g = null
endfunction

private function E_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real end_x = GetSpellTargetX()
    local real end_y = GetSpellTargetY()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local real as = Get_Unit_Property(u, AS) / 2 
    local real dist = 300
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0039.mdx" /* 기류 */
    local string eff2 = "A_0040.mdx" /* 윈드웤 이펙 */
    local integer speed = 16
    local integer tic = 30
    local real time
    local real duration = 2.5
    local real cool_time = 0.70 * ( 100 / (100 + as) )
    local integer as_value = R2I(Get_Unit_Property(u, AS) / 5.0) + 50
    local integer ms_value = R2I(Get_Unit_Property(u, MS) / 5.0) + 50
    local integer skill_id = GetSpellAbilityId()
    local Buff B = Buff.create(u, ELF_KNIGHT_DASH)

    set time = tic * 0.01 + 0.01
    
    call B.Set_Buff_Property(AS, as_value)
    call B.Set_Buff_Property(MS, ms_value)
    call Set_Unit_Buff(duration, B, eff2, "origin", 0.01)
    
    call Effect_Attached(u, 25, angle, 90, 100, 0, 0.1, 0, 0, angle, false, eff, 0.00)
    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, time + 0.01, 0.01)
    call Unit_Motion(u, 8, 150, 0.01)
    call Unit_Move(u, tic, speed, -0.53, angle, 0.01, 0.01)
    
    
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
    local real coef = 3.0
    local real ap_coef = 1.0
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type) + Get_Coef_Dmg(u, ap_coef, AP_TYPE)
    local real as = Get_Unit_Property(u, AS) / 2
    local real delay = 0.20 * ( 100 / (100 + as) ) + 0.01
    local real ani_speed = 250 * ( (100 + as) / 100 )
    local real dist = 300
    local real size = 175
    local real angle = Angle(x, y , end_x, end_y)
    local string eff = "A_0038.mdx"
    local real eff_height = 15
    local integer speed = 21
    local integer tic = 28
    local real time
    local real cool_time = 2.0 * ( 100 / (100 + as) )
    local integer skill_id = GetSpellAbilityId()

    set time = tic * 0.01 + 0.01
    
    call Set_Unit_Ex_Facing(u, angle, 0.01)
    call Hero_Pause(u, time + 0.02, 0.01)
    call Unit_Motion(u, 5, ani_speed, 0.01)

    call Effect_Fixed_On_Unit(u, -25, angle, 90, 100, eff_height, time + 0.02, 0, 0, angle, eff, delay)
    call Unit_Motion(u, 6, ani_speed, delay)
    call Unit_Move(u, tic, 20, -0.7, angle, 0.01, delay)
    call Unit_Dmg_Fixed_On_Unit(u, dmg, 75, angle, 175, time + 0.02, dmg_type, u, delay)
    
    call Cooldown_Reset(u, skill_id, cool_time)

    set u = null
endfunction

private function Q_Act takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type = AD_TYPE
    local real base_dmg = Q_BASE_DMG
    local real coef = 1.5
    local real ap_coef = 0.5
    local real dmg = Get_Unit_Dmg(u, base_dmg, coef, dmg_type) + Get_Coef_Dmg(u, ap_coef, AP_TYPE)
    local real as = Get_Unit_Property(u, AS) / 2 
    local real delay = 0.20 * ( 100 / (100 + as) )
    local real ani_speed = 120 * ( (100 + as) / 100 )
    local real pause_time = 0.30 * ( 100 / (100 + as) )
    local real cool_time = 1.0 * ( 100 / (100 + as) )
    local real dist = 175
    local real size = 175
    local real angle = Closest_Angle(u, 550)
    local string eff
    local string eff2 = "A_0042.mdx"
    local real eff_height = 50
    local integer skill_id = GetSpellAbilityId()
    local integer state = Get_Unit_Property(u, CUSTOM_INT_0)
    local integer z_buff_state = Get_Unit_Property(u, CUSTOM_INT_1)
    local integer motion
    
    call SetUnitFacing(u, angle)
    
    if z_buff_state == 0 or state == 0 then
        set eff = "A_0037.mdx"
        set motion = 2
        call Effect_Attached(u, 25, angle, 100, 100, eff_height, 0.1, 0, -10, angle, false, eff, delay)
    elseif state == 1 then
        set eff = "A_0037.mdx"
        set motion = 3
        set dmg = dmg * 1.1
        call Effect_Attached(u, 25, angle, 100, 100, eff_height, 0.1, 0, 190, angle, false, eff, delay)
    elseif state == 2 then
        set eff = "A_0038.mdx"
        set motion = 6
        set dmg = dmg * 1.2
        call Effect_Attached(u, -40, angle, 90, 100, eff_height-25, 0.1, 0, 0, angle, false, eff, delay)
    endif
    
    if z_buff_state != 0 then
        set ani_speed = 144 * ( (100 + as) / 100 )
        set pause_time = 0.25 * ( 100 / (100 + as) )
        set cool_time = 0.35 * ( 100 / (100 + as) )
        call Effect_Attached(u, dist+50, angle, 70, 200, 0, 0.1, 0, 0, angle, false, eff2, delay)
        call Unit_Area_Dmg(u, Get_Unit_Dmg(u, Z_BASE_DMG, 1.0, AP_TYPE), dist+50, angle, size + 50, AP_TYPE, false, delay + 0.4)
        call Delayed_ND(Player(pid), 0.20, 7, delay + 0.4)
    endif
    
    call Hero_Pause(u, pause_time, 0.01)
    
    call Unit_Motion(u, motion, ani_speed, 0.01)
    call Unit_Area_Dmg(u, dmg, dist, angle, size, dmg_type, false, delay)
    call Set_Unit_Custom_Int(u, -1, 0, Mod(state + 1, 3), false, 0.01)
    call Cooldown_Reset(u, skill_id, cool_time)
    
    set u = null
endfunction

private function V_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01Z'
endfunction

private function C_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01Y'
endfunction

private function X_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01X'
endfunction

private function Z_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01W'
endfunction

private function R_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01U'
endfunction

private function E_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01V'
endfunction

private function W_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01T'
endfunction

private function Q_Con takes nothing returns boolean
    return GetSpellAbilityId() == 'A01S'
endfunction

private function Skills_Init takes nothing returns nothing
    local trigger trg
    
    call Elf_knight_Variable_Init()

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