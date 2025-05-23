library CourtyardController requires Adhoc, CourtyardMonsterTable

globals
    private real loop_delay = 8.0
endglobals

// =====================================================================
// Auto Potion
// =====================================================================

private function Auto_Potion takes integer pid returns nothing
    local unit u = null
    
    if courtyard_potion_check[pid] == false then
        return
    endif
    
    set u = player_hero[pid].Get_Hero_Unit()
    
    if GetUnitLifePercent(u) <= 50.0 then
        call Health_Potion_Generic_Process(pid)
    endif
    
    if GetUnitManaPercent(u) <= 50.0 then
        call Mana_Potion_Generic_Process(pid)
    endif
    
    set u = null
endfunction

// =====================================================================
// Combat Loop
// =====================================================================

private function Combat_Loop takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local integer pid = LoadInteger(HT, id, 0)
    local real wait_time = LoadReal(HT, id, 1) - 1.0
    
    if courtyard_end_check[pid] == true then
        call Simple_Msg(pid, "전투 종료")
        call Timer_Clear(t)
    elseif courtyard_is_in_combat[pid] == true then
        call Timer_Clear(t)
    elseif wait_time < 0.0 then
        call Timer_Clear(t)
        
        if GetLocalPlayer() == Player(pid) then
            call DzSyncData("cystrt", I2S(pid) + "/" + I2S(courtyard_is_auto) + "/" + I2S(courtyard_is_loop) + "/" + I2S(courtyard_level_index) + "/" + I2S(courtyard_is_potion) )
        endif
    else
        call Simple_Msg(pid, "전투 시작까지 " + I2S(R2I(wait_time + 0.01)) + "초")
        call SaveReal(HT, id, 1, wait_time)
        call TimerStart(t, 1.0, false, function Combat_Loop)
    endif
    
    set t = null
endfunction

// =====================================================================
// Combat Control
// =====================================================================

private function Combat_End takes integer pid, boolean is_user_all_dead returns nothing
    local timer t
    local integer id
    local group g
    local unit c
    
    // Remove Monsters
    set g = Group_Copy(courtyard_combat_monster_group[pid], null)
    loop
    set c = FirstOfGroup(g)
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true then
            call Set_Unit_Property(c, IS_FORCED_DEATH, 1)
            call UnitApplyTimedLifeBJ( 0.02, 'BHwe', c )
        endif
    endloop
    call Group_Clear(g)
    
    // Revive User-Units
    set g = Group_Copy(courtyard_combat_user_group[pid], null)
    loop
    set c = FirstOfGroup(g)
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitDeadBJ(c) == true then
            call ReviveHero(c, GetUnitX(c), GetUnitY(c), true)
            call Set_HP( c, JNGetUnitMaxHP(c) )
            call Set_MP( c, JNGetUnitMaxMana(c) )
        endif
    endloop
    call Group_Clear(g)
    
    set courtyard_is_in_combat[pid] = false
    
    // State Check
    if is_user_all_dead == true then
        call Simple_Msg(pid, "모든 유닛 사망으로 전투 종료")
    elseif courtyard_end_check[pid] == true then
        call Simple_Msg(pid, "전투 종료")
    elseif courtyard_loop_check[pid] == true then
        call Simple_Msg(pid, "전투 반복")
        set t = CreateTimer()
        set id = GetHandleId(t)
        call SaveInteger(HT, id, 0, pid)
        call SaveReal(HT, id, 1, loop_delay)
        call TimerStart(t, 1.0, false, function Combat_Loop)
    else
        call Simple_Msg(pid, "전투 종료")
    endif
    
    set t = null
    set g = null
    set c = null
endfunction

private function Combat_Control_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local integer pid = LoadInteger(HT, id, 0)
    local boolean is_combat_end = false
    local boolean is_user_all_dead = true
    local boolean is_monster_all_dead = true
    local group g
    local unit c
    
    // Check If Monsters All Dead
    set g = Group_Copy(courtyard_combat_monster_group[pid], null)
    loop
    set c = FirstOfGroup(g)
    exitwhen c == null or is_monster_all_dead == false
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true then
            set is_monster_all_dead = false
        endif
    endloop
    call Group_Clear(g)
    
    // Check If User-Units All Dead
    set g = Group_Copy(courtyard_combat_user_group[pid], null)
    loop
    set c = FirstOfGroup(g)
    exitwhen c == null or is_user_all_dead == false
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true then
            set is_user_all_dead = false
        endif
    endloop
    call Group_Clear(g)

    // Check If Combat End
    if is_monster_all_dead == true then
        set is_combat_end = true
    endif
    
    if is_user_all_dead == true then
        set is_combat_end = true
    endif
    
    if courtyard_end_check[pid] == true then
        set is_combat_end = true
    endif
    
    // Auto Potion
    call Auto_Potion(pid)
    
    // Loop Combat Control If Combat Not End
    if is_combat_end == true then
        call Timer_Clear(t)
        call Combat_End(pid, is_user_all_dead)
    else
        call TimerStart(t, 1.5, false, function Combat_Control_Func)
    endif
    
    set t = null
    set g = null
    set c = null
endfunction

private function Combat_Control takes integer pid, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveInteger(HT, id, 0, pid)
    call TimerStart(t, delay + 1.5, false, function Combat_Control_Func)
    
    set t = null
endfunction

// =====================================================================
// Functions Deal With After Start
// =====================================================================

private function Monsters_Attack_Order takes integer pid returns nothing
    local group g = Group_Copy(courtyard_combat_monster_group[pid], null)
    local unit c
    
    loop
    set c = FirstOfGroup(g)
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        call IssuePointOrderLoc( c, "attack", courtyard_user_start_loc[pid] )
    endloop
    
    call Group_Clear(g)
    
    set c = null
    set g = null
endfunction

private function Start_Fight_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local integer pid = LoadInteger(HT, id, 0)
    
    // 몬스터 공격 명령
    call Monsters_Attack_Order(pid)
    // 자동사냥 알고리즘
    call Courtyard_Auto_Combat_Algorithm(pid)
    
    call Timer_Clear(t)
    
    set t = null
endfunction

private function Start_Fight takes integer pid, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveInteger(HT, id, 0, pid)
    call TimerStart(t, delay + 0.5, false, function Start_Fight_Func)
    
    set t = null
endfunction

private function User_Group_Setting takes integer pid returns nothing
    local group g = Group_Copy(courtyard_combat_user_group[pid], null)
    local real x
    local real y
    local unit c
    
    loop
    set c = FirstOfGroup(g)
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        // Hide and Teleport
        set x = GetLocationX(courtyard_user_start_loc[pid])
        set y = GetLocationY(courtyard_user_start_loc[pid])
        call Ad_Hoc_Teleport(c, x, y, 1.00, 45, 0.00)
        
        // In Courtyard Flag
        call Set_Unit_Property(c, IN_COURTYARD, 1)
    endloop
    
    call Group_Clear(g)
        
    set g = null
    set c = null
endfunction

// =====================================================================
// Start
// =====================================================================

private function Start takes integer pid, integer level_index returns nothing
    local real time
    // Setting for User Group
    call User_Group_Setting(pid)
    
    // Set Monsters
    set time = Courtyard_Set_Monsters(pid, level_index)
    
    // Start Fight, Apply Auto Combat Algorithm If Auto Checked
    call Start_Fight(pid, time)
    
    // Combat Control, Loop If Loop Checked, Auto Potion If Potion Checked
    call Combat_Control(pid, time)
endfunction

// =====================================================================
// Preprocess
// =====================================================================

private function Courtyard_Combat_Start_Sync takes nothing returns nothing
    local string str = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(str, "/", 0) )
    local integer auto_value = S2I( JNStringSplit(str, "/", 1) )
    local integer loop_value = S2I( JNStringSplit(str, "/", 2) )
    local integer level_index = S2I( JNStringSplit(str, "/", 3) )
    local integer potion_value = S2I( JNStringSplit(str, "/", 4) )
    local group temp_group
    local unit c
    
    if courtyard_is_in_combat[pid] == true then
        return
    endif
    
    set courtyard_end_check[pid] = false
    
    set courtyard_is_in_combat[pid] = true
    
    if auto_value == 0 then
        set courtyard_auto_check[pid] = false
    else
        set courtyard_auto_check[pid] = true
    endif
    
    if loop_value == 0 then
        set courtyard_loop_check[pid] = false
    else
        set courtyard_loop_check[pid] = true
    endif
    
    if potion_value == 0 then
        set courtyard_potion_check[pid] = false
    else
        set courtyard_potion_check[pid] = true
    endif
    
    // 전투 그룹에 유저 유닛들을 넣는다
    set temp_group = CreateGroup()
    call GroupClear(courtyard_combat_user_group[pid])
    call GroupEnumUnitsInRect(temp_group, courtyard_rect[pid], null)
    
    loop
    set c = FirstOfGroup(temp_group)
    exitwhen c == null
        call GroupRemoveUnit(temp_group, c)
        
        if GetOwningPlayer(c) == Player(pid) and IsUnitType(c, UNIT_TYPE_HERO) == true then
            call GroupAddUnit(courtyard_combat_user_group[pid], c)
        endif
    endloop
    
    call Group_Clear(temp_group)
    
    // 시작
    call Start(pid, level_index)
    
    set c = null
    set temp_group = null
endfunction

private function Courtyard_Combat_End_Sync takes nothing returns nothing
    local string str = DzGetTriggerSyncData()
    local integer pid = S2I(str)
    
    set courtyard_end_check[pid] = true
endfunction

function Courtyard_Combat_Start takes integer pid returns nothing
    call DzSyncData("cystrt", I2S(pid) + "/" + I2S(courtyard_is_auto) + "/" + I2S(courtyard_is_loop) + "/" + I2S(courtyard_level_index) + "/" + I2S(courtyard_is_potion) )
endfunction

function Courtyard_Combat_End takes integer pid returns nothing
    call DzSyncData("cyend", I2S(pid))
endfunction

private function Trigger_Init takes nothing returns nothing
    local trigger trg
    
    // 시작 버튼 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "cystrt", false)
    call TriggerAddAction( trg, function Courtyard_Combat_Start_Sync )
    
    // 종료 버튼 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "cyend", false)
    call TriggerAddAction( trg, function Courtyard_Combat_End_Sync )
    
    set trg = null
endfunction

function Courtyard_Controller_Init takes nothing returns nothing
    call Trigger_Init()
endfunction

endlibrary