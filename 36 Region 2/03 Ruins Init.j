library RuinsInit requires SimplePotal, RuinsGeneric, RuinsMonster, RuinsEvent

private function Short_Cut_Potal_Init takes nothing returns nothing
    call Simple_Potal_Create(427, -6065, -6841, -6972)
    call Simple_Potal_Create(424, -8641, -6841, -6972)
    call Simple_Potal_Create(439, -11838, -6841, -6972)
endfunction

function Ruins_Init takes nothing returns nothing
    call Ruins_Monster_Dipose_Init()
    call Ruins_Event_Init()
    call Short_Cut_Potal_Init()
endfunction

endlibrary