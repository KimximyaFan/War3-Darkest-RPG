library HpMpBar

globals
    private integer hp_bar /* 체력바 프레임 */
    private integer mp_bar /* 체력바 프레임 */
    private string hp_panel = "ReplaceableTextures\\TeamColor\\TeamColor00.blp"
    private string mp_panel = "ReplaceableTextures\\TeamColor\\TeamColor01.blp"
    private real width = 0.27
    private real height = 0.012
endglobals

public function Hp_Mp_Bar_Refresh takes nothing returns nothing
    local unit u
    local integer pid = 0
    local real current
    local real max
    local real ratio
    
    
    loop
    exitwhen pid > bj_MAX_PLAYERS
        set u = Hero(pid+1).Get_Hero_Unit()
        if u != null then
            if GetLocalPlayer() == Player(pid) then
                // 체력바 크기 설정
                set current = GetWidgetLife(u)
                set max = GetUnitState(u, UNIT_STATE_MAX_LIFE)
                set ratio = current / max
                call DzFrameSetSize(DzFrameFindByName("BsBa_LineB", 0), width * RMinBJ(0.999, ratio), height)

                // 표기
                call DzFrameSetText(DzFrameFindByName("BsBa_TextP", 0), "|CFFFFCC00" + I2S(R2I(current)) + " / " + I2S(R2I(max)))
                
                // 마나바 크기 설정
                set current = GetUnitState(u, UNIT_STATE_MANA)
                set max = GetUnitState(u, UNIT_STATE_MAX_MANA)
                set ratio = current / max
                call DzFrameSetSize(DzFrameFindByName("BsBa_LineB_M", 0), width * RMinBJ(0.999, ratio), height)

                // 표기
                call DzFrameSetText(DzFrameFindByName("BsBa_TextP_M", 0), "|CFFFFCC00" + I2S(R2I(current)) + " / " + I2S(R2I(max)))
            endif
        endif
        set pid = pid + 1
    endloop
    
    set u = null
endfunction

function Hp_Mp_Bar_Show takes nothing returns nothing
    call DzFrameShow(hp_bar, true)
    call DzFrameShow(mp_bar, true)
endfunction

function Hp_Mp_Bar_Init takes nothing returns nothing
    call DzLoadToc("FDE Import.toc")
    
    set hp_bar = DzCreateFrame("BsBa_Back", DzGetGameUI(), 0)
    call DzFrameSetAbsolutePoint(hp_bar, JN_FRAMEPOINT_CENTER, 0.46, 0.04)
    call DzFrameSetTexture(DzFrameFindByName("BsBa_LineA", 0), "Textures\\Black32.blp", 0)
    call DzFrameSetTexture(DzFrameFindByName("BsBa_LineB", 0), hp_panel, 0)
    call DzFrameSetSize(hp_bar, width + 0.004, height + 0.003)
    call DzFrameSetSize(DzFrameFindByName("BsBa_LineA", 0), width, height)
    call DzFrameSetSize(DzFrameFindByName("BsBa_LineB", 0), width, height)
    call DzFrameShow(hp_bar, false)
    
    set mp_bar = DzCreateFrame("BsBa_Back_M", DzGetGameUI(), 0)
    call DzFrameSetAbsolutePoint(mp_bar, JN_FRAMEPOINT_CENTER, 0.46, 0.02)
    call DzFrameSetTexture(DzFrameFindByName("BsBa_LineA_M", 0), "Textures\\Black32.blp", 0)
    call DzFrameSetTexture(DzFrameFindByName("BsBa_LineB_M", 0), mp_panel, 0)
    call DzFrameSetSize(mp_bar, width + 0.004, height + 0.003)
    call DzFrameSetSize(DzFrameFindByName("BsBa_LineA_M", 0), width, height)
    call DzFrameSetSize(DzFrameFindByName("BsBa_LineB_M", 0), width, height)
    call DzFrameShow(mp_bar, false)
endfunction

endlibrary