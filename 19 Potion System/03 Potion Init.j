library PotionInit requires PotionInfluence, PotionFrame, PotionItem

function Potion_Init takes nothing returns nothing
    call Potion_Frame_Init()
    call Potion_Item_Picked_Init()
endfunction

endlibrary