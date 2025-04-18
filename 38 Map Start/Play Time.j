library PlayTime

private function Play_Time_Record takes nothing returns nothing
    local integer pid = -1
    
    loop
    set pid = pid + 1
    exitwhen pid >= 6
        set play_time[pid] = play_time[pid] + 1
    endloop
endfunction

function Play_Time_Start takes nothing returns nothing
    call TimerStart(CreateTimer(), 60.0, true, function Play_Time_Record)
endfunction

endlibrary