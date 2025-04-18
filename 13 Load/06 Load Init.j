library Load requires LoadFrameButtonBox, LoadCharacterList, LoadInteraction

function Load_Init takes nothing returns nothing
    call Load_Button_and_Box_Init()
    call Load_Character_List_Init()
    call Load_Interaction_Init()
    call Load_Sync_Init()
endfunction

endlibrary