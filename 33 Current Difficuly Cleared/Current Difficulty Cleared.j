library CurrentDifficulty

/*
    Cove Event -> Boss Death
*/

// 현재 난이도 클리어시, flag 갱신하는 함수
function Current_Difficulty_Cleared takes nothing returns nothing
    local integer pid
    
    set pid = -1
    loop
    set pid = pid + 1
    exitwhen pid > 5
        if GetLocalPlayer() == Player(pid) then
            if current_difficulty_cleared[current_load_index] <= MAP_DIFFICULTY then
                set current_difficulty_cleared[current_load_index] = MAP_DIFFICULTY + 1
            endif
        endif
    endloop
    
    call BJDebugMsg("현재 난이도를 클리어 하셨습니다.")
endfunction

endlibrary