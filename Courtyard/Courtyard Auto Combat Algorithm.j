library CourtyardAutoCombat requires Base, CourtyardGeneric, GenericUnitUniversal

globals
    private real kiting_time = 0.5
    private real kiting_delay = 0.1

    private real base_pad = 0.15
endglobals

// ===================================================================
// Generic
// ===================================================================

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


private function Shadow_Algorithm takes nothing returns nothing

endfunction

private function Elf_Knight_Algorithm takes nothing returns nothing

endfunction

private function Night_Crow_Algorithm takes nothing returns nothing

endfunction

// ===================================================================
// Elf Archer
// ===================================================================

private function Elf_Archer_Skill_Selection takes unit u, unit target, integer pid, real mana, integer count returns real
    local real next_time = 0.0
    // 일단 버프기 
    if level_flag[pid] > E and JNGetUnitAbilityCooldownRemaining(u, elf_archer_skill[E]) <= 0.0 and mana > elf_archer_mana[E] then
        call IssueImmediateOrderBJ(u, elf_archer_issue_order[E])
        set next_time = base_pad + elf_archer_pause_time[E] * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/10) )
        
    elseif level_flag[pid] > X and JNGetUnitAbilityCooldownRemaining(u, elf_archer_skill[X]) <= 0.0 and mana > elf_archer_mana[X] then
        call IssueImmediateOrderBJ(u, elf_archer_issue_order[X])
        set next_time = base_pad + elf_archer_pause_time[X] * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/10) )
        
    elseif level_flag[pid] > Z and JNGetUnitAbilityCooldownRemaining(u, elf_archer_skill[Z]) <= 0.0 and mana > elf_archer_mana[Z] then
        call IssueImmediateOrderBJ(u, elf_archer_issue_order[Z])
        set next_time = base_pad + elf_archer_pause_time[Z] * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/10) )
        
    else
        // 공격 방법
        if count == 2 and level_flag[pid] > R and JNGetUnitAbilityCooldownRemaining(u, elf_archer_skill[R]) <= 0.0 and mana > elf_archer_mana[R] then
            call IssueImmediateOrderBJ(u, elf_archer_issue_order[R])
            set next_time = base_pad + elf_archer_pause_time[R] * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/2) )
        elseif level_flag[pid] > W and JNGetUnitAbilityCooldownRemaining(u, elf_archer_skill[W]) <= 0.0 and mana > elf_archer_mana[W] then
            call IssueImmediateOrderBJ(u, elf_archer_issue_order[W])
            set next_time = base_pad + elf_archer_pause_time[W] * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/2) )
        elseif level_flag[pid] > Q and JNGetUnitAbilityCooldownRemaining(u, elf_archer_skill[Q]) <= 0.0 and mana > elf_archer_mana[Q] then
            call IssueImmediateOrderBJ(u, elf_archer_issue_order[Q])
            set next_time = base_pad + elf_archer_pause_time[Q] * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/2) )
        else
            call IssueTargetOrderBJ( u, "attack", target )
            set next_time = 1.0
        endif
    endif
    
    return next_time
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
    elseif dist < 200 then
        set next_time =  Unit_Kiting(u, target)
    elseif dist < 800  then
        set next_time =  Elf_Archer_Skill_Selection(u, target, pid, mana, count)
    else
        call IssueTargetOrder( u, "attack", target )
        set next_time = 1.0
    endif
    
    if is_end == true then
        call Timer_Clear(t)
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
        call IssueImmediateOrderBJ(u, foot_man_issue_order[C])
        set next_time = base_pad + foot_man_pause_time[C] * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/10) )
        
    elseif level_flag[pid] > X and JNGetUnitAbilityCooldownRemaining(u, foot_man_skill[X]) <= 0.0 and mana > foot_man_mana[X] then
        call IssueImmediateOrderBJ(u, foot_man_issue_order[X])
        set next_time = base_pad + foot_man_pause_time[X] * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/10) )
        
    elseif level_flag[pid] > Z and JNGetUnitAbilityCooldownRemaining(u, foot_man_skill[Z]) <= 0.0 and mana > foot_man_mana[Z] then
        call IssueImmediateOrderBJ(u, foot_man_issue_order[Z])
        set next_time = base_pad + foot_man_pause_time[Z] * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/10) )
        
    else
        // 공격 방법
        if count == 2 and level_flag[pid] > R and JNGetUnitAbilityCooldownRemaining(u, foot_man_skill[R]) <= 0.0 and mana > foot_man_mana[R] then
            call IssueImmediateOrderBJ(u, foot_man_issue_order[R])
            set next_time = base_pad + foot_man_pause_time[R] * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/2) )
        elseif level_flag[pid] > W and JNGetUnitAbilityCooldownRemaining(u, foot_man_skill[W]) <= 0.0 and mana > foot_man_mana[W] then
            call IssueImmediateOrderBJ(u, foot_man_issue_order[W])
            set next_time = base_pad + foot_man_pause_time[W] * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/2) )
        elseif level_flag[pid] > Q and JNGetUnitAbilityCooldownRemaining(u, foot_man_skill[Q]) <= 0.0 and mana > foot_man_mana[Q] then
            call IssueImmediateOrderBJ(u, foot_man_issue_order[Q])
            set next_time = base_pad + foot_man_pause_time[Q] * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/2) )
        else
            call IssueTargetOrderBJ( u, "attack", target )
            set next_time = 1.0
        endif
    endif
    
    return next_time
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
        set next_time =  Foot_Man_Skill_Selection(u, target, pid, mana, count)
    elseif dist < 750 and mana > foot_man_mana[E] and level_flag[pid] > E and JNGetUnitAbilityCooldownRemaining(u, foot_man_skill[E]) <= 0.0 then
        set loc = GetUnitLoc(target)
        call IssuePointOrderLocBJ( u, foot_man_issue_order[E], loc )
        set next_time = base_pad + foot_man_pause_time[E] * 100.0 / ( 100.0 + (Get_Unit_Property(u, AS)/2) )
    else
        call IssueTargetOrder( u, "attack", target )
        set next_time = 1.0
    endif
    
    if is_end == true then
        call Timer_Clear(t)
    else
        call SaveInteger(HT, id, 1, Mod(count+1, 3))
        call TimerStart(t, next_time, false, function Foot_Man_Algorithm)
    endif
    
    call RemoveLocation(loc)
    
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