library CourtyardController requires Adhoc, CourtyardMonsterTable

globals
    private trigger array loop_trg[6]
endglobals

// =====================================================================
// Loop Trigger Register
// =====================================================================

// =====================================================================
// Combat Control
// =====================================================================

private function Combat_End takes integer pid, boolean is_user_all_dead returns nothing
    local group g
    local unit c
    
    // Remove Monsters
    set g = Group_Copy(courtyard_combat_monster_group[pid], null)
    loop
    set c = FirstOfGroup(g)
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitAliveBJ(c) == true then
            call RemoveUnit(c)
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
            call RemoveUnit(c)
        endif
    endloop
    call Group_Clear(g)
    
    // State Check
    if is_user_all_dead == true then
        call Simple_Msg(pid, "모든 유닛 사망으로 전투 종료")
    elseif courtyard_end_check[pid] == true then
        call Simple_Msg(pid, "전투 종료")
    elseif courtyard_loop_check[pid] == true then
        call Simple_Msg(pid, "전투 반복")
        call TriggerEvaluate(loop_trg[pid])
    else
        call Simple_Msg(pid, "전투 종료")
    endif
    
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
    
    // Combat Control, Loop If Loop Checked
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
    
    set courtyard_end_check[pid] = false
    
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
    
    // 일단 전투 그룹에 메인 유닛을 넣는다
    call GroupAddUnit(courtyard_combat_user_group[pid], player_hero[pid].Get_Hero_Unit())
    
    // 추후에 확장 되면 용병 유닛도 넣는다
    
    call Start(pid, level_index)
endfunction

private function Courtyard_Combat_End_Sync takes nothing returns nothing
    local string str = DzGetTriggerSyncData()
    local integer pid = S2I(str)
    
    set courtyard_end_check[pid] = true
endfunction

function Courtyard_Combat_Start takes integer pid returns nothing
    call DzSyncData("cystrt", I2S(pid) + "/" + I2S(courtyard_is_auto) + "/" + I2S(courtyard_is_loop) + "/" + I2S(courtyard_level_index))
endfunction

function Courtyard_Combat_End takes integer pid returns nothing
    call DzSyncData("cyend", I2S(pid))
endfunction

private function Courtyard_Combat_Loop takes nothing returns nothing
    local trigger trg = GetTriggeringTrigger()
    local integer pid = LoadInteger(HT, GetHandleId(trg), 0)
    
    call Courtyard_Combat_Start(pid)
    
    set trg = null
endfunction

private function Trigger_Init takes nothing returns nothing
    local integer pid
    local trigger trg
    
    // 반복 전투 트리거
    set pid = -1
    loop
    set pid = pid + 1
    exitwhen pid >= 6
        set loop_trg[pid] = CreateTrigger()
        call SaveInteger(HT, GetHandleId(loop_trg[pid]), 0, pid)
        call TriggerAddAction( loop_trg[pid], function Courtyard_Combat_Loop)
    endloop
    
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