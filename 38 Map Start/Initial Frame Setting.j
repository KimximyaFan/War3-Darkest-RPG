library InitialFrameSetting

function Initial_Frame_Setting takes nothing returns nothing
    local integer frame
    local integer relative_frame
    local integer mini_map
    local integer hero_info_panel
    local integer buff_panel

    // 이거 안하면 아래에 까만 막대 생김
    call DzFrameEditBlackBorders(0, 0)
    
    // -----------------------------------------------------------
    
    // 미니맵
    set mini_map = DzFrameGetMinimap()
    call DzFrameClearAllPoints(mini_map)
    call DzFrameSetPoint(mini_map, JN_FRAMEPOINT_BOTTOMLEFT, DzGetGameUI(), JN_FRAMEPOINT_BOTTOMLEFT, 0.0077, 0.0079)
    call DzFrameSetPoint(mini_map, JN_FRAMEPOINT_TOPRIGHT, DzGetGameUI(), JN_FRAMEPOINT_BOTTOMLEFT, 0.1124, 0.1098)
    call DzFrameShow(mini_map, false)
    // 미니맵 버튼들
    call DzFrameSetAbsolutePoint(DzFrameGetMinimapButton(0), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetAbsolutePoint(DzFrameGetMinimapButton(1), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetAbsolutePoint(DzFrameGetMinimapButton(2), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetAbsolutePoint(DzFrameGetMinimapButton(3), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    call DzFrameSetAbsolutePoint(DzFrameGetMinimapButton(4), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    // 경험치바
    set relative_frame = JNGetFrameByName("SimpleHeroLevelBar", 0)
    call DzFrameClearAllPoints(relative_frame)
    call DzFrameSetAbsolutePoint(relative_frame, 0, 0.202, 0.135)
    call DzFrameSetSize(relative_frame, 0.1, 0.015)
    // 레벨1 XXX 
    set frame = JNGetFrameByName("SimpleClassValue", 0)
    call DzFrameClearAllPoints(frame)
    call DzFrameSetPoint(frame, JN_FRAMEPOINT_CENTER, relative_frame, JN_FRAMEPOINT_CENTER, 0.0, 0.0)
    // 이름
    set frame = JNGetFrameByName("SimpleNameValue", 0)
    call DzFrameClearAllPoints(frame)
    call DzFrameSetPoint(frame, JN_FRAMEPOINT_CENTER, relative_frame, JN_FRAMEPOINT_CENTER, 0.0, 0.0165)
    
    // 공격력 아이콘, 방어력 아이콘, 힘 민 지
    set hero_info_panel = JNGetFrameByName("SimpleInfoPanelIconDamage", 0)
    call DzFrameClearAllPoints(hero_info_panel)
    call DzFrameSetAbsolutePoint(hero_info_panel, JN_FRAMEPOINT_TOPRIGHT, 0, 0)
endfunction

function Buff_Frame_Remove takes nothing returns nothing
    // 버프창
    call DzFrameClearAllPoints(DzSimpleFrameFindByName("SimpleInfoPanelUnitDetail", 0))
    call DzFrameSetAbsolutePoint(DzSimpleFrameFindByName("SimpleInfoPanelUnitDetail", 0), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
endfunction

endlibrary