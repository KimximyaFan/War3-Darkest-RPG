library MilestoneSprite

globals
    private integer sprite
endglobals

function Milestone_Sprite_Hide takes integer pid returns nothing
    if GetLocalPlayer() == Player(pid) then
        call DzFrameShow(sprite, false)
    endif
endfunction

function Milestone_Sprite_Show takes integer pid returns nothing
    if GetLocalPlayer() == Player(pid) then
        call DzFrameShow(sprite, true)
    endif
endfunction

function Milestone_Sprite_Init takes nothing returns nothing
    set sprite = DzCreateFrameByTagName("SPRITE", "", milestone_button, "", 0)
    call DzFrameSetModel(sprite, "UI-ModalButtonOn_1.26x.mdx", 0, 0)
    call DzFrameSetAllPoints(sprite, milestone_button)
    call DzFrameShow(sprite, false)
endfunction

endlibrary