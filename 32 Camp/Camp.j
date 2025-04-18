library Camp requires SimplePotal, StoreDispose

globals
    private real equip_store_x = -511
    private real equip_store_y = 492
endglobals

private function Store_Init takes nothing returns nothing
    call Equip_Store_Dispose(equip_store_x, equip_store_y, 315)
endfunction

private function Potal_Init takes nothing returns nothing
    call Simple_Potal_Create(-586, 11, -2279, -22)
endfunction

function Camp_Init takes nothing returns nothing
    call Potal_Init()
    call Store_Init()
endfunction

endlibrary