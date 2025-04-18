library CoveInit requires SimplePotal, CoveGeneric, CoveMonster, CoveEvent

private function Short_Cut_Potal_Init takes nothing returns nothing

endfunction

function Cove_Init takes nothing returns nothing
    call Cove_Monster_Dipose_Init()
    call Cove_Event_Init()
    call Short_Cut_Potal_Init()
endfunction

endlibrary