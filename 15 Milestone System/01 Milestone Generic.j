library MilestoneGeneric requires MilestoneSprite

globals
    integer QUEST_COUNT = 19
endglobals

function Milestone_Text_Init takes nothing returns nothing
    set milestone_text[0] = "산림지대를 돌파하여\n첫 포탈석상에 도달한다"
    set milestone_text[1] = "산림지대의 밴디트 로드\n처치하기"
    set milestone_text[2] = "산림지대의\n큰 동굴에 도달한다"
    set milestone_text[3] = "산림지대 큰 동굴의\n그래닛 골램 처치하기"
    set milestone_text[4] = "산림지대 큰 동굴을 돌파하여\n동굴 밖 평야에 도달한다"
    set milestone_text[5] = "산림지대 끝에 존재하는\n보스 새스콰치 처치하기"
    set milestone_text[6] = "폐허 초입\n포탈석상 도달하기"
    set milestone_text[7] = "폐허 미로 입구\n포탈석상 도달하기"
    set milestone_text[8] = "미로 속 타워를\n다 파괴하여 구역 돌파"
    set milestone_text[9] = "폐허 끝에 존재하는\n보스 보이드워커 처치하기"
    set milestone_text[10] = "사육장 입구\n포탈석상 도달하기"
    set milestone_text[11] = "사육장의 초반부의\n어보미네이션 처치하기"
    set milestone_text[12] = "사육장 중간\n포탈석상 도달하기"
    set milestone_text[13] = "사육장 중간의\n어보미네이션 처치하기"
    set milestone_text[14] = "사육장 세갈래 길\n포탈석상 도달하기"
    set milestone_text[15] = "사육장의 모든 가시타워를\n파괴하여 구역 돌파"
    set milestone_text[16] = "사육장 끝에 존재하는\n보스 둠가드 처치하기"
    set milestone_text[17] = "해안만 외곽\n포탈석상 도달하기"
    set milestone_text[18] = "해안만의 모든 제단을\n파괴하여 보스 망각의 괴물을\n소환하고 처치하기"
    set milestone_text[20] = "어두운 던전 클리어하기"
    set milestone_text[19] = "다음 난이도로 이동하세요"
endfunction

function Milestone_Frame_Refresh takes integer pid returns nothing
    if GetLocalPlayer() == Player(pid) then
        call DzFrameSetText(milestone_frame_text, milestone_text[ milestone[pid] ] )
        call DzFrameSetText(milestone_reward_text_frame, milestone_reward_text[ milestone[pid] ] )
        
        if milestone[pid] < QUEST_COUNT then
            call Milestone_Sprite_Show(pid)
        endif
    endif
endfunction

endlibrary