library InvenSprite

globals
    private integer sprite
endglobals

function Inven_Sprite_Hide takes nothing returns nothing
    call DzFrameShow(sprite, false)
endfunction

function Inven_Sprite_Show takes nothing returns nothing
    call DzFrameShow(sprite, true)
endfunction

function Inven_Sprite_Set_Position takes integer frame returns nothing
    call DzFrameSetAllPoints(sprite, frame)
endfunction

// 인벤 버튼
function Inven_Sprite_Init takes nothing returns nothing
    set sprite = DzCreateFrameByTagName("SPRITE", "", inven_box, "", 0)
    call DzFrameSetModel(sprite, "UI-ModalButtonOn_1.26x.mdx", 0, 0)
    call DzFrameShow(sprite, false)
endfunction

endlibrary