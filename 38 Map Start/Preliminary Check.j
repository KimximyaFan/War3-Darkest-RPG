library PreliminaryCheck requires Base

private function Ban_List takes string player_name, string ban_list returns boolean
    local integer i
    local string ban_name = "0"
    
    set i = -1
    loop
    set i = i + 1
    exitwhen ban_name == null
        set ban_name = JNStringSplit(ban_list, "/", i)
        
        if player_name == ban_name then
            return true
        endif
    endloop
    
    return false
endfunction

function Player_Ban_List_Check takes nothing returns nothing
    local integer i
    local string ban_list
    
    if is_Test == true then
        return
    endif
    
    set ban_list = JNObjectMapGetString("BAN_LIST")
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 7
        if Player_Playing_Check( Player(i) ) then
            if Ban_List( USER_ID[i], ban_list ) == true then
                call Defeat_Player(Player(i), "당신은 밴리에 올랐어용! ㅇㅅㅇ;; 소명은 카페 문의")
            endif
        endif
    endloop
endfunction

function Battle_Net_Check takes nothing returns boolean
    if is_Test == true then
        return true
    endif
    
    if JNGetConnectionState() == 1112425812 then
        return true
    else
        return false
    endif
endfunction

function Set_User_Id takes nothing returns nothing
    local integer i
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 5
        if Player_Playing_Check( Player(i) ) then
            set USER_ID[i] = StringCase( GetPlayerName( Player(i) ), false )
        endif
    endloop
endfunction

endlibrary