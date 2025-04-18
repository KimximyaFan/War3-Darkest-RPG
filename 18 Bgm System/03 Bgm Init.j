library BgmInit requires BgmFrame

function Bgm_Init takes nothing returns nothing
    call Bgm_Variable_Init()
    call Bgm_Frame_Init()
    call Bgm_Event_Init()
endfunction

endlibrary