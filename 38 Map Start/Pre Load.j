library PreLoad requires Base

globals
    private integer local_exp
    private integer local_gold_drop
    private integer local_item_drop
    
    private integer local_load_flag
endglobals

private function Buff_Stat_Sync takes nothing returns nothing
    local string str = DzGetTriggerSyncData()
    local integer pid = S2I(JNStringSplit(str, "/", 0))
    
    set exp_rate[pid] = S2I(JNStringSplit(str, "/", 1))
    set gold_drop_rate[pid] = S2I(JNStringSplit(str, "/", 2))
    set item_drop_rate[pid] = S2I(JNStringSplit(str, "/", 3))
endfunction

private function Buff_Stat_DzSyncData takes nothing returns nothing
    local integer pid
    local string str
    
    call DestroyTimer(GetExpiredTimer())
    
    set pid = -1
    loop
    set pid = pid + 1
    exitwhen pid > 5
        if Player_Playing_Check( Player(pid) ) then
            if GetLocalPlayer() == Player(pid) then
                set str = I2S(pid) + "/" + I2S(local_exp) + "/" + I2S(local_gold_drop) + "/" + I2S(local_item_drop)
                call DzSyncData("b_s_syn", str)
            endif
        endif
    endloop
endfunction

private function Load_Play_Time takes integer pid returns nothing
    if is_Test == false then
        set play_time[pid] = JNObjectUserGetInt(USER_ID[pid], PLAY_TIME)
    endif
endfunction

// 동기화 필요 없음
private function Load_Potion_Increase_1 takes integer pid returns nothing
    local integer value
    
    if is_Test == false then
        set value = JNObjectUserGetInt(USER_ID[pid], POTION_INCREASE)
        
        if value != null then
            set potion_increase = value
        endif
    endif
endfunction

private function Load_Item_Drop_Rate takes integer pid returns nothing
    local integer value
    
    if is_Test == false then
        set value = JNObjectUserGetInt(USER_ID[pid], ITEM_DROP_RATE)
        
        if value != null then
            set local_item_drop = value
        endif
    endif
endfunction

private function Load_Gold_Drop_Rate takes integer pid returns nothing
    local integer value
    
    if is_Test == false then
        set value = JNObjectUserGetInt(USER_ID[pid], GOLD_DROP_RATE)
        
        if value != null then
            set local_gold_drop = value
        endif
    endif
endfunction

private function Load_Exp_Rate takes integer pid returns nothing
    local integer value
    
    if is_Test == false then
        set value = JNObjectUserGetInt(USER_ID[pid], EXP_RATE)
        
        if value != null then
            set local_exp = value
        endif
    endif
endfunction

// 후원 캐릭터 고를수 있게 해주는 정보
private function Load_Character_Lock takes integer pid returns nothing
    if is_Test == true then
        set character_lock = "1/1/1/1/1/1/1/1/1/1/1/1/1/1/1/1/1/1/1/1/1/1/1/1"
    else
        set character_lock = "1/1/1/1/1/1/"
        set character_lock = character_lock + JNObjectUserGetString(USER_ID[pid], CHARACTER_LOCK)
    endif
endfunction

private function Load_Character_List takes integer pid returns nothing
    local string str
    
    set character_list = "-1,0#-1,0#-1,0#-1,0#-1,0#-1,0#-1,0#-1,0"
    
    if is_Test == true then
        return
    endif
    
    set str = JNGetLoadCode(MAP_ID, USER_ID[pid], SECRET_KEY, CHARACTER_LIST)

    if S2I(JNStringSplit(str, "/", 0)) == 808 then
        set character_list = JNStringSplit(str, "/", 1)
    endif
endfunction

private function Sync_Trigger_Init takes nothing returns nothing
    local trigger trg
    
    // 캐릭터 선택 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "b_s_syn", false)
    call TriggerAddAction( trg, function Buff_Stat_Sync )
    
    set trg = null
endfunction

function Pre_Load takes nothing returns nothing
    local integer pid
    
    call Sync_Trigger_Init()
    
    set pid = -1
    loop
    set pid = pid + 1
    exitwhen pid > 8
        set player_hero[pid] = Hero.create()
    endloop
    
    set pid = -1
    loop
    set pid = pid + 1
    exitwhen pid > 5
        if Player_Playing_Check( Player(pid) ) then
            if GetLocalPlayer() == Player(pid) then
            
                call JNObjectUserInit( MAP_ID, USER_ID[pid], SECRET_KEY, "" )
                
                call Load_Character_List(pid)
                call Load_Character_Lock(pid)
                call Load_Exp_Rate(pid)
                call Load_Gold_Drop_Rate(pid)
                call Load_Item_Drop_Rate(pid)
                call Load_Potion_Increase_1(pid)
                call Load_Play_Time(pid)
            endif
        endif
    endloop
    
    
    call TimerStart(CreateTimer(), 1.25, false, function Buff_Stat_DzSyncData)
endfunction

endlibrary