library WarrensInit requires SimplePotal, WarrensGeneric, WarrensMonster, WarrensEvent

private function Short_Cut_Potal_Init takes nothing returns nothing

endfunction

function Warrens_Init takes nothing returns nothing
    call Warrens_Monster_Dipose_Init()
    call Warrens_Event_Init()
    call Short_Cut_Potal_Init()
endfunction

endlibrary