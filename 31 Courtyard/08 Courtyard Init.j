library Courtyard requires CourtyardGeneric, CourtyardEvent, CourtyardFrame

function Courtyard_Init takes nothing returns nothing
    call Courtyard_Variable_Init()
    call Courtyard_Monster_Attack_Speed_Init()
    call Courtyard_Monster_Table_Init()
    call Courtyard_Controller_Init()
    call Courtyard_Frame_Init()
    call Courtyard_Event_Init()
endfunction

endlibrary