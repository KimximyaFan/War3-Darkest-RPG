library LoadCharacter requires LoadCharacterDeserialize, PotionFrame

globals
    private string array front
    private string array mid
    private string array back
    
endglobals

// ==============================================================
// For Courtyard API
// ==============================================================

private function Register_Sync_4 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local integer pid = LoadInteger(HT, id, 0)
    local integer index = LoadInteger(HT, id, 1)
    local string str
    
    call Timer_Clear(t)
    
    set str = front[pid] + mid[pid] + back[pid]
    
    if JNStringSplit(str, "/", 0) != "808" then
        if GetLocalPlayer() == Player(pid) then
            call BJDebugMsg("저장된 데이터 없음")
        endif
        return
    endif
        
    call Mercenary_Deserialize(pid, index, str)
endfunction

private function Register_Sync_3 takes nothing returns nothing
    local string sync_data = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(sync_data, "[", 0) )
    local integer index = S2I( JNStringSplit(sync_data, "[", 1) )
    local string str = JNStringSplit(sync_data, "[", 2)
    local timer t
    
    set back[pid] = str
    
    set t = CreateTimer()
    call SaveInteger(HT, GetHandleId(t), 0, pid)
    call SaveInteger(HT, GetHandleId(t), 1, index)
    call TimerStart(t, 0.5, false, function Register_Sync_4)
    
    set t = null
endfunction

private function Register_Sync_2 takes nothing returns nothing
    local string sync_data = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(sync_data, "[", 0) )
    local string str = JNStringSplit(sync_data, "[", 1)
    
    set mid[pid] = str
endfunction

private function Register_Sync_1 takes nothing returns nothing
    local string sync_data = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(sync_data, "[", 0) )
    local string str = JNStringSplit(sync_data, "[", 1)
    
    set front[pid] = str
endfunction

function Register_Character_Code takes integer pid, integer index returns nothing
    local integer total_length
    local integer length
    local integer length2
    local string str
    
    set str = JNGetLoadCode( MAP_ID, USER_ID[pid], SECRET_KEY, "LOAD_INDEX" + I2S(index) )
    
    set str = str
    set total_length = StringLength(str)
    set length = total_length/3
    set length2 = 2 * length

    call DzSyncData("reg_1", I2S(pid) + "[" + SubString(str, 0, length))
    call DzSyncData("reg_2", I2S(pid) + "[" + SubString(str, length, length2))
    call DzSyncData("reg_3", I2S(pid) + "["  + I2S(index) + "[" + SubString(str, length2, total_length))
endfunction

// ==============================================================
// Existing Functions
// ==============================================================

private function Deserialize_Sync_4 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local integer pid = LoadInteger(HT, id, 0)
    local string str
    
    call Timer_Clear(t)
    
    set str = front[pid] + mid[pid] + back[pid]
    
    //call BJDebugMsg(str)
    
    if JNStringSplit(str, "/", 0) != "808" then
        if GetLocalPlayer() == Player(pid) then
            call BJDebugMsg("저장된 데이터 없음")
        endif
        return
    endif
        
    call Deserialize(pid, str)
endfunction

private function Deserialize_Sync_3 takes nothing returns nothing
    local string sync_data = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(sync_data, "[", 0) )
    local string str = JNStringSplit(sync_data, "[", 1)
    local timer t
    
    set back[pid] = str
    
    set t = CreateTimer()
    call SaveInteger(HT, GetHandleId(t), 0, pid)
    call TimerStart(t, 0.5, false, function Deserialize_Sync_4)
    
    set t = null
endfunction

private function Deserialize_Sync_2 takes nothing returns nothing
    local string sync_data = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(sync_data, "[", 0) )
    local string str = JNStringSplit(sync_data, "[", 1)
    
    set mid[pid] = str
endfunction

private function Deserialize_Sync_1 takes nothing returns nothing
    local string sync_data = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(sync_data, "[", 0) )
    local string str = JNStringSplit(sync_data, "[", 1)
    
    set front[pid] = str
endfunction

private function Milestone_Sync takes nothing returns nothing
    local string sync_data = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(sync_data, "/", 0) )
    local integer milestone_value = S2I( JNStringSplit(sync_data, "/", 1) )
    
    set milestone[pid] = milestone_value
    
    // Milestone Frame
    call Milestone_Frame_Refresh(pid)
endfunction

private function Set_Milestone_Value takes integer pid returns nothing
    local integer milestone_value
    
    if MAP_DIFFICULTY == NORMAL then
        set milestone_value = S2I( JNStringSplit(local_milestone_str, ",", 0) )
    elseif MAP_DIFFICULTY == NIGHTMARE then
        set milestone_value = S2I( JNStringSplit(local_milestone_str, ",", 1) )
    elseif MAP_DIFFICULTY == HELL then
        set milestone_value = S2I( JNStringSplit(local_milestone_str, ",", 2) )
    endif
    
    call DzSyncData("mile_1", I2S(pid) + "/" + I2S(milestone_value))
endfunction

function Load_Potal_State_Code takes integer pid returns nothing
    set potal_save_state = JNGetLoadCode( MAP_ID, USER_ID[pid], SECRET_KEY, "POTAL_STATE" + I2S(MAP_DIFFICULTY) )
endfunction

function Load_Extensive_Code takes integer pid returns nothing
    local string str
    local string str2
    
    set str = JNGetLoadCode( MAP_ID, USER_ID[pid], SECRET_KEY, "EXTENSIVE" + I2S(current_load_index) )
    
    set health_potion_count = S2I( JNStringSplit(str, "&", 0) )
    set mana_potion_count = S2I( JNStringSplit(str, "&", 1) )
    
    set str2 = JNStringSplit(str, "&", 2)
    
    if str2 != null then
        set local_milestone_str = str2
        call Set_Milestone_Value(pid)
    endif
    
    // Potion Frame and Interaction
    call Health_Potion_Frame_Refresh()
    call Mana_Potion_Frame_Refresh()
endfunction

function Load_Character_Code takes integer pid returns nothing
    local integer total_length
    local integer length
    local integer length2
    local string str
    
    set str = JNGetLoadCode( MAP_ID, USER_ID[pid], SECRET_KEY, "LOAD_INDEX" + I2S(current_load_index) )
    
    //call DzSyncData("load", I2S(pid) + "[" + str)
    
    set str = str
    set total_length = StringLength(str)
    set length = total_length/3
    set length2 = 2 * length
    //call BJDebugMsg(I2S(length))
    call DzSyncData("load_1", I2S(pid) + "[" + SubString(str, 0, length))
    call DzSyncData("load_2", I2S(pid) + "[" + SubString(str, length, length2))
    call DzSyncData("load_3", I2S(pid) + "[" + SubString(str, length2, total_length))
endfunction

function Load_Sync_Init takes nothing returns nothing
    local trigger trg
    
    // Load 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "load_1", false)
    call TriggerAddAction( trg, function Deserialize_Sync_1 )
    
    // Load 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "load_2", false)
    call TriggerAddAction( trg, function Deserialize_Sync_2 )
    
    // Load 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "load_3", false)
    call TriggerAddAction( trg, function Deserialize_Sync_3 )
    
    // 마일스톤 값 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "mile_1", false)
    call TriggerAddAction( trg, function Milestone_Sync )
    
    // Register 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "reg_1", false)
    call TriggerAddAction( trg, function Register_Sync_1 )
    
    // Register 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "reg_2", false)
    call TriggerAddAction( trg, function Register_Sync_2 )
    
    // Register 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "reg_3", false)
    call TriggerAddAction( trg, function Register_Sync_3 )
    
    set trg = null
endfunction

endlibrary