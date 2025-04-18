library PotalInit requires PotalEvent

function Potal_Init takes nothing returns nothing
    call Potal_Preprocess()
    call Potal_Event_Init()
    call Potal_Frame_Init()
endfunction

endlibrary