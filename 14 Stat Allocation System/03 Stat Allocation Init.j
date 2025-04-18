library StatAllocationInit requires StatAllocationFrame

function Stat_Allocation_Init takes nothing returns nothing
    call Stat_Allocation_Frame_Init()
    call Stat_Alloc_Controller_Init()
endfunction

endlibrary