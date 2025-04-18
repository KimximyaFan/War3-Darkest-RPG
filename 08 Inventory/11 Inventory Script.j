library Inventory requires InvenGeneric, InvenButtonAndBox, InvenItem, InvenWearing, InvenDiscard, DiscardAll, DiscardAllCheck, InvenToolTip

// 이 함수 실행하면 인벤토리 생김
function Inventory_Frame_Init takes nothing returns nothing
    call Inven_Generic_Init()
    call Inven_Button_And_Box_Init()
    call Inven_Item_Init()
    call Inven_Wearing_Init()
    call Inven_Discard_Init()
    call Inven_Discard_All_Init()
    call Inven_Discard_All_Check_Init()
    call Inven_Sort_Init()
    call Inven_Sprite_Init()
    call Inven_Upgrade_Init()
    
    // Tool Tip Init 은 항상 마지막 순서로, 프레임 ordering layer 때문
    call Inven_Tool_Tip_Init()
endfunction

endlibrary