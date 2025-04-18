library LoadCharacterGeneric

function New_Character_Frame_Hide takes nothing returns nothing
    call DzFrameShow(new_character_back_drop, false)
endfunction

function New_Character_Frame_Show takes nothing returns nothing
    call DzFrameShow(new_character_back_drop, true)
endfunction

endlibrary