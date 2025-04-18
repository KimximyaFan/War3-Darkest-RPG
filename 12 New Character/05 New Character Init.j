library NewCharacter requires NewCharacterFrame, NewCharacterFunctions

function New_Character_Init takes nothing returns nothing
    call New_Character_Functions_Init()
    call New_Character_Frame_Init()
    call New_Character_Camera_Init()
endfunction

endlibrary