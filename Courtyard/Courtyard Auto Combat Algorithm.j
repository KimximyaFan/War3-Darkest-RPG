library CourtyardAutoCombat requires Base, CourtyardGeneric, GenericUnitUniversal

globals
    private real kiting_time = 0.7
    private real kiting_delay = 0.1

    private real base_pad = 0.20
endglobals

// ===================================================================
// Generic
// ===================================================================

private function Auto_Algorithm_End takes unit u returns nothing
    call Set_Unit_Property(u, IS_AUTO_COMBAT, 0)
endfunction

private function Get_Side_Location takes unit u, unit target, real dist returns location
    local real unit_x = GetUnitX(u)
    local real unit_y = GetUnitY(u)
    local real target_x = GetUnitX(target)
    local real target_y = GetUnitY(target)
    local real angle = Angle(target_x, target_y, unit_x, unit_y) + 90 - 180 * GetRandomInt(0, 1)
    local real next_x
    local real next_y

    set next_x = Polar_X(unit_x, dist, angle)
    set next_y = Polar_Y(unit_y, dist, angle)
    
    return Location(next_x, next_y)
endfunction

private function Get_Kiting_Location takes unit u, unit target, real dist returns location
    local real unit_x = GetUnitX(u)
    local real unit_y = GetUnitY(u)
    local real target_x = GetUnitX(target)
    local real target_y = GetUnitY(target)
    local real angle = Angle(target_x, target_y, unit_x, unit_y) + GRR(-15, 15)
    local boolean is_pathable = false
    local real next_x
    local real next_y
    local integer safety_int = 0
    
    loop
    set next_x = Polar_X(unit_x, dist, angle)
    set next_y = Polar_Y(unit_y, dist, angle)
    exitwhen Is_Terrain_Pathable(next_x, next_y) == true or safety_int > 10
        set angle = angle + 90
        set safety_int = safety_int + 1
    endloop
    
    return Location(next_x, next_y)
endfunction

private function Unit_Kiting takes unit u, unit target returns real
    local real unit_x = GetUnitX(u)
    local real unit_y = GetUnitY(u)
    local real target_x = GetUnitX(target)
    local real target_y = GetUnitY(target)
    local real ms = Get_Unit_Property(u, MS)
    local real dist = ms * kiting_time
    local real angle = Angle(target_x, target_y, unit_x, unit_y) + GRR(-15, 15)
    local boolean is_pathable = false
    local real next_x
    local real next_y
    local integer safety_int = 0
    local location loc
    
    loop
    set next_x = Polar_X(unit_x, dist, angle)
    set next_y = Polar_Y(unit_y, dist, angle)
    exitwhen Is_Terrain_Pathable(next_x, next_y) == true or safety_int > 10
        set angle = angle + 90
        set safety_int = safety_int + 1
    endloop
    
    set loc = Location(next_x, next_y)

    call IssuePointOrderLoc(u, "move", loc)
    
    call RemoveLocation(loc)
    
    set loc = null
    
    return kiting_time + kiting_delay
endfunction

// ===================================================================
// Shadow
// ===================================================================

private function Shadow_Skill_Selection takes unit u, unit target, integer pid, real mana, integer count returns real
    local real next_time = 0.0
    local location loc = GetUnitLoc(target)
   
    // 버프기
    // C X Z
    
    if level_flag[pid] > C and JNGetUnitAbilityCooldownRemaining(u, shadow_skill[C]) <= 0.0 and mana > shadow_mana[C] then
        call IssueImmediateOrder(u, shadow_issue_order[C])
        set next_time = shadow_pause_time[C]
    elseif level_flag[pid] > X and JNGetUnitAbilityCooldownRemaining(u, shadow_skill[X]) <= 0.0 and mana > shadow_mana[X] then
        call IssueImmediateOrder(u, shadow_issue_order[X])
        set next_time = shadow_pause_time[X]
    elseif level_flag[pid] > Z and JNGetUnitAbilityCooldownRemaining(u, shadow_skill[Z]) <= 0.0 and mana > shadow_mana[Z] then
        call IssueImmediateOrder(u, shadow_issue_order[Z])
        set next_time = shadow_pause_time[Z] 
    
        
    // 공격 방법
    // W E R Q
    elseif level_flag[pid] > W and JNGetUnitAbilityCooldownRemaining(u, shadow_skill[W]) <= 0.0 and mana > shadow_mana[W] then
        call IssueImmediateOrder(u, shadow_issue_order[W])
        set next_time = shadow_pause_time[W]
    elseif count == 3 and level_flag[pid] > R and JNGetUnitAbilityCooldownRemaining(u, shadow_skill[R]) <= 0.0 and mana > shadow_mana[R] then
        call IssuePointOrderLoc(u, shadow_issue_order[R], loc)
        set next_time = shadow_pause_time[R]
    elseif count == 2 and level_flag[pid] > E and JNGetUnitAbilityCooldownRemaining(u, shadow_skill[E]) <= 0.0 and mana > shadow_mana[E] then
        call IssuePointOrderLoc( u, shadow_issue_order[E], loc )
        set next_time = base_pad + shadow_pause_time[E]
    elseif level_flag[pid] > Q and JNGetUnitAbilityCooldownRemaining(u, shadow_skill[Q]) <= 0.0 and mana > shadow_mana[Q] then
        call IssueImmediateOrder(u, shadow_issue_order[Q])
        set next_time = shadow_pause_time[Q]
        
    else
        call IssueTargetOrder( u, "attack", target )
        set next_time = 1.0
    endif
    
    call RemoveLocation(loc)
    
    set loc = null
    
    return (next_time + base_pad) * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/2) )
endfunction

private function Shadow_Algorithm takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer count = LoadInteger(HT, id, 1)
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    local unit target = Closest_Unit_In_Group(u, courtyard_combat_monster_group[pid], null)
    local real dist = Distance_Between_Units(u, target)
    local real mana = GetUnitStateSwap(UNIT_STATE_MANA, u)
    local real next_time = 1.0
    local boolean is_end = false
    local location loc
    
    // level_flag[pid] 는 Hero Skill Add 에 존재한다
    
    if target == null or IsUnitAliveBJ(u) == false then
        set is_end = true
    elseif dist < 350 then
        set next_time = Shadow_Skill_Selection(u, target, pid, mana, count)
    elseif dist < 900 and mana > shadow_mana[E] and level_flag[pid] > E and JNGetUnitAbilityCooldownRemaining(u, shadow_skill[E]) <= 0.0 then
        set loc = GetUnitLoc(target)
        call IssuePointOrderLoc( u, shadow_issue_order[E], loc )
        set next_time = base_pad + shadow_pause_time[E]
        call RemoveLocation(loc)
    else
        call IssueTargetOrder( u, "attack", target )
        set next_time = 1.0
    endif
    
    if is_end == true then
        call Timer_Clear(t)
        call Auto_Algorithm_End(u)
    else
        call SaveInteger(HT, id, 1, Mod(count+1, 4))
        call TimerStart(t, next_time, false, function Shadow_Algorithm)
    endif
    
    set t = null
    set u = null
    set target = null
    set loc = null
endfunction

// ===================================================================
// Elf_Knight
// ===================================================================

private function Elf_Knight_Skill_Selection takes unit u, unit target, integer pid, real mana, integer count returns real
    local real next_time = 0.0
    local location loc = GetUnitLoc(target)
    
    // 버프기
    // Z E
    if level_flag[pid] > Z and JNGetUnitAbilityCooldownRemaining(u, elf_knight_skill[Z]) <= 0.0 and mana > elf_knight_mana[Z] then
        call IssueImmediateOrder(u, elf_knight_issue_order[Z])
        set next_time = elf_knight_pause_time[Z] 
    
    elseif count == 4 and level_flag[pid] > E and JNGetUnitAbilityCooldownRemaining(u, elf_knight_skill[E]) <= 0.0 and mana > elf_knight_mana[E] then
        call RemoveLocation(loc)
        set loc = Get_Side_Location(u, target, 150)
        call IssuePointOrderLoc( u, elf_knight_issue_order[E], loc )
        set next_time = base_pad + elf_knight_pause_time[E]
        
    // 공격 방법
    // C X R W Q
    elseif level_flag[pid] > C and JNGetUnitAbilityCooldownRemaining(u, elf_knight_skill[C]) <= 0.0 and mana > elf_knight_mana[C] then
        call IssueImmediateOrder(u, elf_knight_issue_order[C])
        set next_time = elf_knight_pause_time[C]
        
    elseif level_flag[pid] > X and JNGetUnitAbilityCooldownRemaining(u, elf_knight_skill[X]) <= 0.0 and mana > elf_knight_mana[X] then
        call IssuePointOrderLoc(u, elf_knight_issue_order[X], loc)
        set next_time = elf_knight_pause_time[X]
        
    elseif level_flag[pid] > R and JNGetUnitAbilityCooldownRemaining(u, elf_knight_skill[R]) <= 0.0 and mana > elf_knight_mana[R] then
        call IssueImmediateOrder(u, elf_knight_issue_order[R])
        set next_time = elf_knight_pause_time[R]
        
    elseif count == 2 and level_flag[pid] > W and JNGetUnitAbilityCooldownRemaining(u, elf_knight_skill[W]) <= 0.0 and mana > elf_knight_mana[W] then
        call IssuePointOrderLoc(u, elf_knight_issue_order[W], loc)
        set next_time = elf_knight_pause_time[W]
        
    elseif level_flag[pid] > Q and JNGetUnitAbilityCooldownRemaining(u, elf_knight_skill[Q]) <= 0.0 and mana > elf_knight_mana[Q] then
        call IssueImmediateOrder(u, elf_knight_issue_order[Q])
        set next_time = elf_knight_pause_time[Q]
        
    else
        call IssueTargetOrder( u, "attack", target )
        set next_time = 1.0
    endif
    
    call RemoveLocation(loc)
    
    set loc = null
    
    return (next_time + base_pad) * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/2) )
endfunction

private function Elf_Knight_Algorithm takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer count = LoadInteger(HT, id, 1)
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    local unit target = Closest_Unit_In_Group(u, courtyard_combat_monster_group[pid], null)
    local real dist = Distance_Between_Units(u, target)
    local real mana = GetUnitStateSwap(UNIT_STATE_MANA, u)
    local real next_time = 1.0
    local boolean is_end = false
    local location loc
    
    // level_flag[pid] 는 Hero Skill Add 에 존재한다
    
    if target == null or IsUnitAliveBJ(u) == false then
        set is_end = true
    elseif dist < 350 then
        set next_time = Elf_Knight_Skill_Selection(u, target, pid, mana, count)
    elseif dist < 900 and mana > elf_knight_mana[E] and level_flag[pid] > E and JNGetUnitAbilityCooldownRemaining(u, elf_knight_skill[E]) <= 0.0 then
        set loc = GetUnitLoc(target)
        call IssuePointOrderLoc( u, elf_knight_issue_order[E], loc )
        set next_time = base_pad + elf_knight_pause_time[E]
        call RemoveLocation(loc)
    else
        call IssueTargetOrder( u, "attack", target )
        set next_time = 1.0
    endif
    
    if is_end == true then
        call Timer_Clear(t)
        call Auto_Algorithm_End(u)
    else
        call SaveInteger(HT, id, 1, Mod(count+1, 5))
        call TimerStart(t, next_time, false, function Elf_Knight_Algorithm)
    endif
    
    set t = null
    set u = null
    set target = null
    set loc = null
endfunction

// ===================================================================
// Night Crow
// ===================================================================

private function Night_Crow_Skill_Selection takes unit u, unit target, integer pid, real mana, integer count returns real
    local real next_time = 0.0
    local location loc = GetUnitLoc(target)
    
    // 버프기
    // Z
    if level_flag[pid] > Z and JNGetUnitAbilityCooldownRemaining(u, night_crow_skill[Z]) <= 0.0 and mana > night_crow_mana[Z] then
        call IssueImmediateOrder(u, night_crow_issue_order[Z])
        set next_time = night_crow_pause_time[Z] 
        
    // 공격 방법
    // C X W R Q
    elseif level_flag[pid] > C and JNGetUnitAbilityCooldownRemaining(u, night_crow_skill[C]) <= 0.0 and mana > night_crow_mana[C] then
        call IssuePointOrderLoc(u, night_crow_issue_order[C], loc)
        set next_time = night_crow_pause_time[C]
        
    elseif level_flag[pid] > X and JNGetUnitAbilityCooldownRemaining(u, night_crow_skill[X]) <= 0.0 and mana > night_crow_mana[X] then
        call IssuePointOrderLoc(u, night_crow_issue_order[X], loc)
        set next_time = night_crow_pause_time[X]
        
    elseif level_flag[pid] > W and JNGetUnitAbilityCooldownRemaining(u, night_crow_skill[W]) <= 0.0 and mana > night_crow_mana[W] then
        call IssuePointOrderLoc(u, night_crow_issue_order[W], loc)
        set next_time = night_crow_pause_time[W]
        
    elseif count == 2 and level_flag[pid] > R and JNGetUnitAbilityCooldownRemaining(u, night_crow_skill[R]) <= 0.0 and mana > night_crow_mana[R] then
        call IssueImmediateOrder(u, night_crow_issue_order[R])
        set next_time = night_crow_pause_time[R]
        
    elseif level_flag[pid] > Q and JNGetUnitAbilityCooldownRemaining(u, night_crow_skill[Q]) <= 0.0 and mana > night_crow_mana[Q] then
        call IssueImmediateOrder(u, night_crow_issue_order[Q])
        set next_time = night_crow_pause_time[Q]
        
    else
        call IssueTargetOrder( u, "attack", target )
        set next_time = 1.0
    endif
    
    call RemoveLocation(loc)
    
    set loc = null
    
    return (next_time + base_pad) * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/2) )
endfunction

private function Night_Crow_Algorithm takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer count = LoadInteger(HT, id, 1)
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    local unit target = Closest_Unit_In_Group(u, courtyard_combat_monster_group[pid], null)
    local real dist = Distance_Between_Units(u, target)
    local real mana = GetUnitStateSwap(UNIT_STATE_MANA, u)
    local real next_time = 1.0
    local boolean is_end = false
    local location loc
    
    // level_flag[pid] 는 Hero Skill Add 에 존재한다
    if target == null or IsUnitAliveBJ(u) == false then
        set is_end = true
    elseif dist < 225 then
        if level_flag[pid] > E and JNGetUnitAbilityCooldownRemaining(u, night_crow_skill[E]) <= 0.0 and mana > night_crow_mana[E] then
            set loc = Get_Kiting_Location(u, target, 500)
            call IssuePointOrderLoc( u, night_crow_issue_order[E], loc )
            set next_time = base_pad + night_crow_pause_time[E]
            call RemoveLocation(loc)
        else
            set next_time = Unit_Kiting(u, target)
        endif
    elseif dist < 800  then
        set next_time = Night_Crow_Skill_Selection(u, target, pid, mana, count)
    else
        call IssueTargetOrder( u, "attack", target )
        set next_time = 1.0
    endif
    
    if is_end == true then
        call Timer_Clear(t)
        call Auto_Algorithm_End(u)
    else
        call SaveInteger(HT, id, 1, Mod(count+1, 3))
        call TimerStart(t, next_time, false, function Night_Crow_Algorithm)
    endif
    
    set t = null
    set u = null
    set target = null
    set loc = null
endfunction

// ===================================================================
// Elf Archer
// ===================================================================

private function Elf_Archer_Skill_Selection takes unit u, unit target, integer pid, real mana, integer count returns real
    local real next_time = 0.0
    local location loc = GetUnitLoc(target)
    
    // 버프기
    // E Z
    if level_flag[pid] > E and JNGetUnitAbilityCooldownRemaining(u, elf_archer_skill[E]) <= 0.0 and mana > elf_archer_mana[E] then
        call IssueImmediateOrder(u, elf_archer_issue_order[E])
        set next_time = elf_archer_pause_time[E] 
        
    elseif level_flag[pid] > Z and JNGetUnitAbilityCooldownRemaining(u, elf_archer_skill[Z]) <= 0.0 and mana > elf_archer_mana[Z] then
        call IssueImmediateOrder(u, elf_archer_issue_order[Z])
        set next_time = elf_archer_pause_time[Z] 
        
    else
        // 공격 방법
        // R C X W Q
        if level_flag[pid] > R and JNGetUnitAbilityCooldownRemaining(u, elf_archer_skill[R]) <= 0.0 and mana > elf_archer_mana[R] then
            call IssueImmediateOrder(u, elf_archer_issue_order[R])
            set next_time = elf_archer_pause_time[R]
            
        elseif level_flag[pid] > C and JNGetUnitAbilityCooldownRemaining(u, elf_archer_skill[C]) <= 0.0 and mana > elf_archer_mana[C] then
            call IssuePointOrderLoc(u, elf_archer_issue_order[C], loc)
            set next_time = elf_archer_pause_time[C]
            
        elseif level_flag[pid] > X and JNGetUnitAbilityCooldownRemaining(u, elf_archer_skill[X]) <= 0.0 and mana > elf_archer_mana[X] then
            call IssuePointOrderLoc(u, elf_archer_issue_order[X], loc)
            set next_time = elf_archer_pause_time[X]
            
        elseif count == 0 and level_flag[pid] > W and JNGetUnitAbilityCooldownRemaining(u, elf_archer_skill[W]) <= 0.0 and mana > elf_archer_mana[W] then
            call IssuePointOrderLoc(u, elf_archer_issue_order[W], loc)
            set next_time = elf_archer_pause_time[W]
            
        elseif count == 1 and level_flag[pid] > Q and JNGetUnitAbilityCooldownRemaining(u, elf_archer_skill[Q]) <= 0.0 and mana > elf_archer_mana[Q] then
            call IssuePointOrderLoc(u, elf_archer_issue_order[Q], loc)
            set next_time = elf_archer_pause_time[Q]
            
        else
            call IssueTargetOrder( u, "attack", target )
            set next_time = 1.0
        endif
    endif
    
    call RemoveLocation(loc)
    
    set loc = null
    
    return (next_time + base_pad) * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/2) )
endfunction

private function Elf_Archer_Algorithm takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer count = LoadInteger(HT, id, 1)
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    local unit target = Closest_Unit_In_Group(u, courtyard_combat_monster_group[pid], null)
    local real dist = Distance_Between_Units(u, target)
    local real mana = GetUnitStateSwap(UNIT_STATE_MANA, u)
    local real next_time = 1.0
    local boolean is_end = false
    
    // level_flag[pid] 는 Hero Skill Add 에 존재한다
    if target == null or IsUnitAliveBJ(u) == false then
        set is_end = true
    elseif dist < 225 then
        set next_time = Unit_Kiting(u, target)
    elseif dist < 800  then
        set next_time = Elf_Archer_Skill_Selection(u, target, pid, mana, count)
    else
        call IssueTargetOrder( u, "attack", target )
        set next_time = 1.0
    endif
    
    if is_end == true then
        call Timer_Clear(t)
        call Auto_Algorithm_End(u)
    else
        call SaveInteger(HT, id, 1, Mod(count+1, 2))
        call TimerStart(t, next_time, false, function Elf_Archer_Algorithm)
    endif
    
    set t = null
    set u = null
    set target = null
endfunction

// ===================================================================
// Foot Man
// ===================================================================

private function Foot_Man_Skill_Selection takes unit u, unit target, integer pid, real mana, integer count returns real
    local real next_time = 0.0
    // 일단 버프기 
    if level_flag[pid] > C and JNGetUnitAbilityCooldownRemaining(u, foot_man_skill[C]) <= 0.0 and mana > foot_man_mana[C] then
        call IssueImmediateOrder(u, foot_man_issue_order[C])
        set next_time = foot_man_pause_time[C] 
        
    elseif level_flag[pid] > X and JNGetUnitAbilityCooldownRemaining(u, foot_man_skill[X]) <= 0.0 and mana > foot_man_mana[X] then
        call IssueImmediateOrder(u, foot_man_issue_order[X])
        set next_time = foot_man_pause_time[X] 
        
    elseif level_flag[pid] > Z and JNGetUnitAbilityCooldownRemaining(u, foot_man_skill[Z]) <= 0.0 and mana > foot_man_mana[Z] then
        call IssueImmediateOrder(u, foot_man_issue_order[Z])
        set next_time = foot_man_pause_time[Z] 
        
    else
        // 공격 방법
        if count == 2 and level_flag[pid] > R and JNGetUnitAbilityCooldownRemaining(u, foot_man_skill[R]) <= 0.0 and mana > foot_man_mana[R] then
            call IssueImmediateOrder(u, foot_man_issue_order[R])
            set next_time = foot_man_pause_time[R]
        elseif level_flag[pid] > W and JNGetUnitAbilityCooldownRemaining(u, foot_man_skill[W]) <= 0.0 and mana > foot_man_mana[W] then
            call IssueImmediateOrder(u, foot_man_issue_order[W])
            set next_time = foot_man_pause_time[W]
        elseif level_flag[pid] > Q and JNGetUnitAbilityCooldownRemaining(u, foot_man_skill[Q]) <= 0.0 and mana > foot_man_mana[Q] then
            call IssueImmediateOrder(u, foot_man_issue_order[Q])
            set next_time = foot_man_pause_time[Q]
        else
            call IssueTargetOrder( u, "attack", target )
            set next_time = 1.0
        endif
    endif
    
    return (next_time + base_pad) * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/2) )
endfunction

private function Foot_Man_Algorithm takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer count = LoadInteger(HT, id, 1)
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    local unit target = Closest_Unit_In_Group(u, courtyard_combat_monster_group[pid], null)
    local real dist = Distance_Between_Units(u, target)
    local real mana = GetUnitStateSwap(UNIT_STATE_MANA, u)
    local real next_time = 1.0
    local boolean is_end = false
    local location loc
    
    // level_flag[pid] 는 Hero Skill Add 에 존재한다
    if target == null or IsUnitAliveBJ(u) == false then
        set is_end = true
    elseif dist < 350 then
        set next_time = Foot_Man_Skill_Selection(u, target, pid, mana, count)
    elseif dist < 900 and level_flag[pid] > E and JNGetUnitAbilityCooldownRemaining(u, foot_man_skill[E]) <= 0.0 and mana > foot_man_mana[E] then
        set loc = GetUnitLoc(target)
        call IssuePointOrderLoc( u, foot_man_issue_order[E], loc )
        set next_time = base_pad + foot_man_pause_time[E]
        call RemoveLocation(loc)
    else
        call IssueTargetOrder( u, "attack", target )
        set next_time = 1.0
    endif
    
    if is_end == true then
        call Timer_Clear(t)
        call Auto_Algorithm_End(u)
    else
        call SaveInteger(HT, id, 1, Mod(count+1, 3))
        call TimerStart(t, next_time, false, function Foot_Man_Algorithm)
    endif

    set t = null
    set u = null
    set target = null
    set loc = null
endfunction

private function Apply_Auto_Algorithm takes unit u returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local integer unit_type = GetUnitTypeId(u)
    local code matching_function
    
    // 자동전투 상태
    call Set_Unit_Property(u, IS_AUTO_COMBAT, 1)
    
    if unit_type == FOOT_MAN then
        set matching_function = function Foot_Man_Algorithm
    elseif unit_type == ELF_ARCHER then
        set matching_function = function Elf_Archer_Algorithm
    elseif unit_type == NIGHT_CROW then
        set matching_function = function Night_Crow_Algorithm
    elseif unit_type == ELF_KNIGHT then
        set matching_function = function Elf_Knight_Algorithm
    elseif unit_type == SHADOW then
        set matching_function = function Shadow_Algorithm
    endif
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, 0)
    call TimerStart(t, 0.01, false, matching_function)
    
    set t = null
    set matching_function = null
endfunction

function Courtyard_Auto_Combat_Algorithm takes integer pid returns nothing
    local group g = null
    local unit c = null
    
    if courtyard_auto_check[pid] == false then
        return
    endif
    
    set g = Group_Copy(courtyard_combat_user_group[pid], null)
    
    loop
    set c = FirstOfGroup(g)
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        call Apply_Auto_Algorithm(c)
    endloop
    
    call Group_Clear(g)
    
    set g = null
    set c = null
endfunction

endlibrary