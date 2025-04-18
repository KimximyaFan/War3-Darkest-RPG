library NameHackCheck

globals
    private integer count = 0
endglobals

private function Name_Hack_Check_Sync takes nothing returns nothing
    local string str = DzGetTriggerSyncData()
    local integer pid = S2I(JNStringSplit(str, "/", 0))
    local integer state = S2I(JNStringSplit(str, "/", 1))
    
    if state == 1 then
        call CustomDefeatBJ( Player(pid), "네임핵 or M16 서버에 아이디 등록 안됨" )
    else
        set count = count - 1
    endif
    
    if count <= 0 then
        call TriggerExecute(second_step_trg)
    endif
endfunction


function Name_Hack_Check takes nothing returns nothing
    local integer pid
    
    if is_Test == true then
        call TriggerExecute(second_step_trg)
        return
    endif
    
    set pid = -1
    loop
    set pid = pid + 1
    exitwhen pid > 5
        if Player_Playing_Check( Player(pid) ) then
            set count = count + 1
            if GetLocalPlayer() == Player(pid) then
                if JNCheckNameHack( GetPlayerName( Player(pid) ) ) == true then
                    call DzSyncData( "nhc1", I2S(pid) + "/" + I2S(1) )
                else
                    call DzSyncData( "nhc1", I2S(pid) + "/" + I2S(0) )
                endif
            endif
        endif
    endloop
endfunction

function Name_Hack_Check_Sync_Init takes nothing returns nothing
    local trigger trg
    
    // 난이도 선택 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData( trg, "nhc1", false)
    call TriggerAddAction( trg, function Name_Hack_Check_Sync )
    
    set trg = null
endfunction

endlibrary