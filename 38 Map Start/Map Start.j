scope MapStart initializer Init

globals
    trigger first_step_trg
    trigger second_step_trg
    trigger next_step_trg
    private boolean map_start = true
    private timer t = CreateTimer()
    
    private boolean is_difficulty_choosing_start = false
    
    private integer difficulty_selecting_pid = 0
    
    boolean is_difficulty_choosen = false
endglobals

private function Announce_Credits takes nothing returns nothing
    call DisplayTimedTextToForce( GetPlayersAll(), 15.0, "* Credits *\n\n" )
    call DisplayTimedTextToForce( GetPlayersAll(), 15.0, "JN 함수 - scvscvgo, 평타천국, 은방\n" )
    call DisplayTimedTextToForce( GetPlayersAll(), 15.0, "데미지 엔진 - 동동주\n" )
    call DisplayTimedTextToForce( GetPlayersAll(), 15.0, "커스텀 스턴 - 동동주\n" )
    call DisplayTimedTextToForce( GetPlayersAll(), 15.0, "핸들 프로파일러 - 동동주\n" )
    call DisplayTimedTextToForce( GetPlayersAll(), 15.0, "Op Limit 해제 - 크로와상\n" )
    call DisplayTimedTextToForce( GetPlayersAll(), 15.0, "이속 제한 해제 - 크로와상\n" )
    call DisplayTimedTextToForce( GetPlayersAll(), 15.0, "스마트키 - 크로와상\n" )
    call DisplayTimedTextToForce( GetPlayersAll(), 15.0, "체력바 - 제정신이아님\n" )
    call DisplayTimedTextToForce( GetPlayersAll(), 15.0, "인근 영웅 경험치 제공 - 제정신이아님\n" )
    call DisplayTimedTextToForce( GetPlayersAll(), 15.0, "Console UI - vcccv\n" )
    call DisplayTimedTextToForce( GetPlayersAll(), 15.0, "데미지 텍스트 - GW\n" )
    call DisplayTimedTextToForce( GetPlayersAll(), 15.0, "공격 타입 받아오기 - 김켈프\n" )
endfunction

private function Buff_Stat_Init takes nothing returns nothing
    local integer i = -1
    
    loop
    set i = i + 1
    exitwhen i > 5
        set exp_rate[i] = 0
        set gold_drop_rate[i] = 0
        set item_drop_rate[i] = 0
        set potion_increase = 0
        set milestone[i] = 0
        set loaded_character_count[i] = 0
    endloop
endfunction

private function Set_Max_Speed takes nothing returns nothing
    call Set_Max_Unit_Speed(1200)
endfunction

private function Map_Sync_Delay takes nothing returns nothing
    if is_Test == false then
        return
    endif
    call JNSetSyncDelay(20)
endfunction

private function Init_End_2 takes nothing returns nothing
    // 유저 체력바 마나바
    call Hp_Mp_Bar_Init()
    // 몬스터 죽음
    call Monster_Death_Init()
    // 마을 캠프 초기화
    call Camp_Init()
    // 타이머 베이스 프레임 갱신
    call Timer_Base_Refresh()

    call Print_Dispose_Called()
    
    call Refresh_Text_Tag_Init()
    // 안뜰
    call Courtyard_Init()
    
    // 플레이 타임
    call Play_Time_Start()
    
    // 스탯 할당 시스템
    call Stat_Allocation_Init()
    
    call SetOpLimit(300000)
endfunction

private function Init_End takes nothing returns nothing
    
    // 영웅 체력, 마나 리젠
    call Hero_Regen_Init()
    // 부활
    call Revive_Init()
    // 명령어
    call Command_Init()
    // 상점 장비 구매
    call Buy_Equip_Init()
    // 플레이어 나감
    call Player_Dodge_Init()
    // 드랍 확률 테이블
    call Monster_Drop_Init()
    
    call TimerStart( t, 0.00, false, function Init_End_2 )
endfunction

private function Post_Init_Final takes nothing returns nothing
    // ESC로 프레임 끄기
    call ESC_Init()
    // BGM 시스템
    call Bgm_Init()
    // 링크 버튼
    call Link_Frame_Init()
    // 스탯창
    call Stat_Frame_Init()
    // 인벤토리
    call Inventory_Frame_Init()
    // 새 캐릭터 생성
    call New_Character_Init()
    // 저장
    call Save_Init()
    // 포션
    call Potion_Init()
    // 캐릭터 로드 창
    call Load_Init()
    call Load_Frame_Show()
    // 몬스터 스킬
    call Monster_Skill_Init()
    // 버프 스탯 프레임
    call Buff_Stat_Frame_Init()
    // 메인퀘 프레임
    call Milestone_Frame_Init()

    

    
    call TimerStart( t, 0.00, false, function Init_End )
endfunction

private function Post_Init_4 takes nothing returns nothing
    call Cove_Init()
    call TimerStart( t, 0.25, false, function Post_Init_Final )
endfunction

private function Post_Init_3 takes nothing returns nothing
    call Warrens_Init()
    call TimerStart( t, 0.25, false, function Post_Init_4 )
endfunction

private function Post_Init_2 takes nothing returns nothing
    call Ruins_Init()
    call TimerStart( t, 0.25, false, function Post_Init_3 )
endfunction

private function Post_Init_1 takes nothing returns nothing
    call Weald_Init()
    call TimerStart( t, 0.25, false, function Post_Init_2 )
endfunction

private function Post_Init_0 takes nothing returns nothing
    if MAP_DIFFICULTY == NORMAL then
        call Normal_Monster_Property_Init()
    elseif MAP_DIFFICULTY == NIGHTMARE then
        call Nightmare_Monster_Property_Init()
    elseif MAP_DIFFICULTY == HELL then
        call Hell_Monster_Property_Init()
    else
        call Normal_Monster_Property_Init()
    endif

    call TimerStart( t, 0.01, false, function Post_Init_1 )
endfunction

private function Difficulty_Init takes nothing returns nothing
    local integer pid
    
    set pid = -1
    loop
    set pid = pid + 1
    exitwhen pid > 5
        if Player_Playing_Check( Player(pid) ) then
            set difficulty_selecting_pid = pid
            set pid = 6
        endif
    endloop
    
    if GetLocalPlayer() == Player(difficulty_selecting_pid) then
        call Difficulty_Frame_Show()
    endif
endfunction

private function Pre_Init takes nothing returns nothing
    // 시간, 시야, 안개제거, 음악
    call UseTimeOfDayBJ( false )
    call SetTimeOfDay( 12 )
    call StopMusic(false)
    
    if Battle_Net_Check() == false then
        call BJDebugMsg("배틀넷에서 플레이 해주세요! ㅇㅅㅇ")
        return
    endif

    call Buff_Stat_Init()
    call Set_Max_Speed()
    
    call Monster_Variable_Init()
    call Monster_Grade_Init()
    call Monster_Gold_Drop_Init()
    
    call Map_Sync_Delay()

    call Set_User_Id()
    
    call Difficulty_Frame_Init()
    
    //call Player_Ban_List_Check()
    
    call Black_Boarder_Init()
    call Initial_Frame_Setting()
    
    call Pre_Load()
    
    call Item_Picked_Init()
    call Hero_Level_Up_Init()
    call Equip_Property_Preprocessing()
    
    // 유닛 공격속도 전처리
    call Unit_Attack_Speed_Init()
    
    // 포탈
    call Potal_Init()
    
    if is_Test == false then
        call Announce_Credits()
        call TimerStart( t, 3.5, false, function Difficulty_Init )
    else
        call TimerStart( t, 0.5, false, function Difficulty_Init )
    endif
endfunction

private function step_2 takes nothing returns nothing
    call Name_Hack_Check_Sync_Init()
    call Name_Hack_Check()
endfunction

private function step_1 takes nothing returns nothing
    call API_Check_Sync_Init()
    call Api_Key_Check()
endfunction

private function Init takes nothing returns nothing
    local trigger trg
    
    call Buff_Frame_Remove()
    
    if map_start == false then
        return
    endif
    
    set first_step_trg = CreateTrigger()
    call TriggerAddAction( first_step_trg, function step_2)
    
    set second_step_trg = CreateTrigger()
    call TriggerAddAction( second_step_trg, function Pre_Init)
    
    set next_step_trg = CreateTrigger()
    call TriggerAddAction( next_step_trg, function Post_Init_0)
    
    // 맵시작하고나서 0초후에 Pre_Init 실행
    set trg = CreateTrigger()
    call TriggerRegisterTimerEvent(trg, 0.00, false)
    call TriggerAddAction( trg, function step_1 )
    
    set trg = null
endfunction

endscope