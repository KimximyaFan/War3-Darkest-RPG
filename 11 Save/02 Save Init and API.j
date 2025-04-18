library Save requires SaveFrames

function Save_Init takes nothing returns nothing
    call Save_Frames_Init()
endfunction

function Forced_Save takes integer pid returns nothing
    call Automatic_Save(pid)
endfunction

endlibrary