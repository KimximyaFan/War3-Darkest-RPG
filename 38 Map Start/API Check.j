library APIcheck requires Base

globals
    private integer represent_pid
endglobals

private function API_Check_Sync takes nothing returns nothing
    local integer state = S2I(DzGetTriggerSyncData())
    
    if state == 0 then
        call TriggerExecute(first_step_trg)
    else
        call BJDebugMsg("맵이 오래됐습니다 신맵 해주세요!")
    endif
endfunction

private function Api_Key_Check_Func takes nothing returns nothing
    local integer state = -1
    
    set state = JNObjectMapInit(MAP_ID, SECRET_KEY)
    
    call DzSyncData("api1", I2S(state))
endfunction

function Api_Key_Check takes nothing returns nothing
    local integer pid
    
    set pid = -1
    loop
    set pid = pid + 1
    exitwhen pid > 5
        if Player_Playing_Check( Player(pid) ) then
            set represent_pid = pid
            set pid = 6
        endif
    endloop
    
    if is_Test == true then
        call TriggerExecute(first_step_trg)
        return
    endif
    
    if GetLocalPlayer() == Player(represent_pid) then
        call Api_Key_Check_Func()
    endif
endfunction

function API_Check_Sync_Init takes nothing returns nothing
    local trigger trg
    
    // 난이도 선택 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData( trg, "api1", false)
    call TriggerAddAction( trg, function API_Check_Sync )
    
    set trg = null
endfunction

endlibrary