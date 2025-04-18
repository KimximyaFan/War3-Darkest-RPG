library NewCharacterBuild requires Stat

function New_Character_Build takes integer pid, integer unit_type returns nothing
    local unit u = CreateUnit(Player(pid), unit_type, map_center_x, map_center_y, 0.0)
    
    call Set_Unit_Property(u, LOAD_CHARACTER_INDEX, loaded_character_count[pid])
    set loaded_character_count[pid] = loaded_character_count[pid] + 1
    
    call Hero(pid+1).Set_Hero_Unit( u )
    
    call Stat_Refresh(pid)
    
    set u = null
endfunction

endlibrary