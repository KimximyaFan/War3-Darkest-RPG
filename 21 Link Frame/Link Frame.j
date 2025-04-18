library LinkFrame

globals
    // 링크 프레임 껐다 켰다 전용 불린변수
    private boolean isLink = false
    // 화면 오른쪽 하단에 생기는 버튼
    private integer link_button
    // 링크 버튼 클릭되면 생기는 박스
    private integer link_box
    
    // 네이버카페 그림 아이콘
    private integer naver_back_drop
    // 네이버카페 버튼 
    private integer naver_button
    
    // 디스코드 그림 아이콘
    private integer discord_back_drop
    // 디스코드 버튼
    private integer discord_button
    
    // 카카오 그림 아이콘
    private integer kakao_back_drop
    // 카카오 버튼
    private integer kakao_button
endglobals

// 카톡 아이콘 클릭되면
private function Link_Kakao_Clicked takes nothing returns nothing
    call JNOpenBrowser("https://open.kakao.com/o/sSAl1B0g")
endfunction

// 디스코드 아이콘 클릭되면
private function Link_Discord_Clicked takes nothing returns nothing
    call JNOpenBrowser("https://discord.gg/Rb2ZZB2v")
endfunction

// 카페 아이콘 클릭되면
private function Link_Naver_Clicked takes nothing returns nothing
    call JNOpenBrowser("https://cafe.naver.com/geunhahahaha")
endfunction

function Link_Button_Show takes nothing returns nothing
    call DzFrameShow(link_button, true)
endfunction

// 링크 프레임 껐다 켰다 
private function Link_Button_Clicked takes nothing returns nothing
    if isLink == true then
        set isLink = false
        call DzFrameShow(link_box, false)
    else
        set isLink = true
        call DzFrameShow(link_box, true)
    endif
endfunction

function Link_Frame_Init takes nothing returns nothing
    // 링크 버튼
    set link_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", DzGetGameUI(), "ScriptDialogButton", 0)
    call DzFrameSetPoint(link_button, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, 0.37, -0.12)
    call DzFrameSetSize(link_button, 0.039, 0.039)
    call DzFrameSetText(link_button, "링크")
    call DzFrameSetScriptByCode(link_button, JN_FRAMEEVENT_CONTROL_CLICK, function Link_Button_Clicked, false)
    call DzFrameShow(link_button, false)
    
    // 링크 백드롭
    set link_box = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "EscMenuBackdrop", 0)
    call DzFrameSetSize(link_box, 0.175, 0.08)
    call DzFrameSetPoint(link_box, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, 0.265, -0.1)
    call DzFrameShow(link_box, false)
    
    // 네이버카페 아이콘 백드롭
    set naver_back_drop = DzCreateFrameByTagName("BACKDROP", "", link_box, "", 0)
    call DzFrameSetSize(naver_back_drop, 0.035, 0.035)
    call DzFrameSetPoint(naver_back_drop, JN_FRAMEPOINT_CENTER, link_box, JN_FRAMEPOINT_CENTER, -0.045, 0)
    call DzFrameSetTexture(naver_back_drop, "BTN_Cafe.blp", 0)
    // 네이버카페 버튼
    set naver_button = DzCreateFrameByTagName("BUTTON", "", naver_back_drop, "ScoreScreenTabButtonTemplate", 0)
    call DzFrameSetPoint(naver_button, JN_FRAMEPOINT_CENTER, naver_back_drop, JN_FRAMEPOINT_CENTER, 0, 0)
    call DzFrameSetSize(naver_button, 0.035, 0.035)
    call DzFrameSetScriptByCode(naver_button, JN_FRAMEEVENT_CONTROL_CLICK, function Link_Naver_Clicked, false)
    
    // 디코 아이콘 백드롭
    set discord_back_drop = DzCreateFrameByTagName("BACKDROP", "", link_box, "", 0)
    call DzFrameSetSize(discord_back_drop, 0.035, 0.035)
    call DzFrameSetPoint(discord_back_drop, JN_FRAMEPOINT_CENTER, link_box, JN_FRAMEPOINT_CENTER, 0.0, 0)
    call DzFrameSetTexture(discord_back_drop, "BTN_Discord.blp", 0)
    // 디코 버튼
    set discord_button = DzCreateFrameByTagName("BUTTON", "", discord_back_drop, "ScoreScreenTabButtonTemplate", 0)
    call DzFrameSetPoint(discord_button, JN_FRAMEPOINT_CENTER, discord_back_drop, JN_FRAMEPOINT_CENTER, 0, 0)
    call DzFrameSetSize(discord_button, 0.035, 0.035)
    call DzFrameSetScriptByCode(discord_button, JN_FRAMEEVENT_CONTROL_CLICK, function Link_Discord_Clicked, false)
    
    // 카카오 아이콘 백드롭
    set kakao_back_drop = DzCreateFrameByTagName("BACKDROP", "", link_box, "", 0)
    call DzFrameSetSize(kakao_back_drop, 0.035, 0.035)
    call DzFrameSetPoint(kakao_back_drop, JN_FRAMEPOINT_CENTER, link_box, JN_FRAMEPOINT_CENTER, 0.045, 0)
    call DzFrameSetTexture(kakao_back_drop, "BTN_Kakao.blp", 0)
    // 카카오 버튼
    set kakao_button = DzCreateFrameByTagName("BUTTON", "", kakao_back_drop, "ScoreScreenTabButtonTemplate", 0)
    call DzFrameSetPoint(kakao_button, JN_FRAMEPOINT_CENTER, kakao_back_drop, JN_FRAMEPOINT_CENTER, 0, 0)
    call DzFrameSetSize(kakao_button, 0.035, 0.035)
    call DzFrameSetScriptByCode(kakao_button, JN_FRAMEEVENT_CONTROL_CLICK, function Link_Kakao_Clicked, false)
endfunction

endlibrary