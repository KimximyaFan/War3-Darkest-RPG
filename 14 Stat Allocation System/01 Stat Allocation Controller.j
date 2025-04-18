library StatAllocationController requires StatAllocationGeneric, Stat

globals
    private boolean lock = false
endglobals

private function Stat_Alloc_Increase_Interaction_Sync takes nothing returns nothing
    local string sync_data = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(sync_data, "/", 0) )
    local integer property = S2I( JNStringSplit(sync_data, "/", 1) )
    local Hero current_hero = player_hero[pid]
    
    if GetLocalPlayer() == Player(pid) then
        set lock = false
    endif
    
    call current_hero.Set_Stat_Alloc_Property(property, current_hero.Get_Stat_Alloc_Property(property) + 1)
    call current_hero.Stat_Point_Calculate()
    
    call Stat_Alloc_Property_Value_Refresh(pid, property)
    call Stat_Alloc_Stat_Point_Refresh(pid)
    call Stat_Refresh_Specific(pid, property)
endfunction

function Stat_Alloc_Increase_Interaction takes integer pid, integer button_index returns nothing
    local Hero current_hero = player_hero[pid]
    local integer property
    
    if lock == true then
        return
    endif
    
    if current_hero.Get_Stat_Point() <= 0 then
        return
    endif
    
    set lock = true
    
    if button_index == 0 then
        set property = AD
    elseif button_index == 1 then
        set property = AP
    elseif button_index == 2 then
        set property = AS
    elseif button_index == 3 then
        set property = MS
    elseif button_index == 4 then
        set property = HP
    elseif button_index == 5 then
        set property = MP
    elseif button_index == 6 then
        set property = DEF_AD
    elseif button_index == 7 then
        set property = DEF_AP
    elseif button_index == 8 then
        set property = HP_REGEN
    elseif button_index == 9 then
        set property = MP_REGEN
    endif
    
    call DzSyncData("saii", I2S(pid) + "/" + I2S(property))
endfunction

private function Trigger_Init takes nothing returns nothing
    local trigger trg
    
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "saii", false)
    call TriggerAddAction( trg, function Stat_Alloc_Increase_Interaction_Sync )
    
    set trg = null
endfunction

function Stat_Alloc_Controller_Init takes nothing returns nothing
    call Trigger_Init()
endfunction

endlibrary