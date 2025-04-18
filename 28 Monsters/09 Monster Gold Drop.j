library MonsterGoldDrop requires EquipAPI, PotionItem, UnitProperty, DroppedItem

/*

    난이도에 드랍률이랑 드랍템들 영향 받음

*/

globals
    private real array portion_drop_probability
endglobals

function Monster_Gold_Drop takes unit monster, unit killing_unit returns nothing
    local integer pid = GetPlayerId(GetOwningPlayer(killing_unit))
    local integer drop_gold_value = LoadInteger(HT, GetUnitTypeId(monster), GOLD_DROP)
    local texttag tt
    local real x = GetUnitX(monster)
    local real y = GetUnitY(monster)
    local string str
    local string additional = ""
    local integer remainder = 0
    
    if Get_Unit_Property(monster, IN_COURTYARD) != 0 then
        set drop_gold_value = 1
        
        if Get_Unit_Property(monster, DIFFICULTY_LIKE) == NIGHTMARE then
            set drop_gold_value = drop_gold_value + 4
        elseif Get_Unit_Property(monster, DIFFICULTY_LIKE) == HELL then
            set drop_gold_value = drop_gold_value + 8
        endif
        
    elseif MAP_DIFFICULTY == NIGHTMARE then
        set drop_gold_value = drop_gold_value * 2 + 10
    elseif MAP_DIFFICULTY == HELL then
        set drop_gold_value = drop_gold_value * 4 + 20
    endif
    
    if Mod(drop_gold_value * gold_drop_rate[pid], 100) != 0 then
        set remainder = 1
    endif
    
    if gold_drop_rate[pid] != 0 then
        set additional = " (+" + I2S(gold_drop_rate[pid]) + "%)"
    endif

    set drop_gold_value = drop_gold_value + remainder + (drop_gold_value * gold_drop_rate[pid]) / 100
    set str = "+" + I2S(drop_gold_value) + additional

    set tt = Text_Tag(x, y, 255, 230, 5, 7.7, 0, 35, 90, 225, 1.0, 1.0, str, null, pid, 0.0)
    
    call AdjustPlayerStateBJ( drop_gold_value, Player(pid), PLAYER_STATE_RESOURCE_GOLD )
    
    set tt = null
endfunction

private function Gold_Drop_Table_Init takes nothing returns nothing
    local integer unit_type_id
    
    call DestroyTimer(GetExpiredTimer())
    
    // 멀럭 타이드 러너
    set unit_type_id = 'n000'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 4)
    
    // 멀럭 헌터
    set unit_type_id = 'n011'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 4)
    
    // 멀럭 나이트 크러울러
    set unit_type_id = 'n012'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 8)
    
    // 마크루라 스냅퍼
    set unit_type_id = 'n013'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 7)
    
    // 마크루라 타이드로드
    set unit_type_id = 'n014'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 15)
    
    // 나가 사이렌
    set unit_type_id = 'n017'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 15)
    
    // 나가 씨 위치
    set unit_type_id = 'n018'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 30)
    
    // 씨 자이언트 헌터
    set unit_type_id = 'n019'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 15)
    
    // 씨 자이언트 비어머스
    set unit_type_id = 'n01A'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 35)
    
    // 가갠투언 씨 터틀
    set unit_type_id = 'n01B'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 25)
    
    // 드래곤 터틀
    set unit_type_id = 'n01C'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 35)
    
    // 나가 미르미돈스
    set unit_type_id = 'n016'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 20)
    
    // 파워 그래닛 골렘
    set unit_type_id = 'n015'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 50)
    
    // 씨 엘리멘탈
    set unit_type_id = 'n01E'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 60)
    
    // 뎁스 레버넌트
    set unit_type_id = 'n01D'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 60)
    
    // 히드라
    set unit_type_id = 'n01F'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 60)
    
    // 망각의 괴물
    set unit_type_id = 'n01G'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 150)
    
    // 타이드 가디안
    set unit_type_id = 'n002'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 10)
    
    // 텐타클
    set unit_type_id = 'n004'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 2)
    
    // 듄 웜
    set unit_type_id = 'n00V'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 2)
    
    // 좀비
    set unit_type_id = 'n00U'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 3)
    
    // 레이저맨 스카우트
    set unit_type_id = 'n00R'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 3)
    
    // 퀼 볼
    set unit_type_id = 'n00Q'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 3)
    
    // 레이저맨 치프틴
    set unit_type_id = 'n00S'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 6)
    
    // 퀼 비스트
    set unit_type_id = 'n00T'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 5)
    
    // 펠 가드
    set unit_type_id = 'n00W'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 5)
    
    // 펠 스토커
    set unit_type_id = 'n00X'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 5)
    
    // 미트 웨건
    set unit_type_id = 'u003'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 10)
    
    // 사티로스 소울스틸러
    set unit_type_id = 'n00Y'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 10)
    
    // 사라만다
    set unit_type_id = 'n00Z'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 10)
    
    // 어보미네이션
    set unit_type_id = 'u002'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 35)
    
    // 둠가드
    set unit_type_id = 'n010'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 50)
    
    // 가시 해골 타워
    set unit_type_id = 'h009'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 5)
    
    // 해골 칼
    set unit_type_id = 'n00J'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 2)
    
    // 해골 법
    set unit_type_id = 'u000'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 2)
    
    // 해골 도끼
    set unit_type_id = 'n00K'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 5)
    
    // 스펠 브레이커
    set unit_type_id = 'h006'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 3)
    
    // 소서리스
    set unit_type_id = 'h007'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 2)
    
    // 애콜라이트
    set unit_type_id = 'n00L'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 5)
    
    // 골렘 배틀
    set unit_type_id = 'n00M'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 8)
    
    // 리치
    set unit_type_id = 'u001'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 10)
    
    // 오버로드
    set unit_type_id = 'n00N'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 10)
    
    // 레버넌트
    set unit_type_id = 'n00O'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 15)
    
    // 보이드 워커
    set unit_type_id = 'n00P'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 50)
    
    // 아케인 타워
    set unit_type_id = 'h008'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 5)
    
    // 밴딧 도끼
    set unit_type_id = 'n007'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 1)
    
    // 밴딧 창
    set unit_type_id = 'n008'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 1)
    
    // 밴딧 로드
    set unit_type_id = 'n009'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 10)
    
    // 늑대 팀버
    set unit_type_id = 'n00A'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 2)
    
    // 놀 쇠구슬
    set unit_type_id = 'n00B'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 1)
    
    // 놀 석궁
    set unit_type_id = 'n00C'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 1)
    
    // 놀 부르트
    set unit_type_id = 'n00D'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 5)
    
    // 오우거
    set unit_type_id = 'n00E'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 10)
    
    // 타우렌
    set unit_type_id = 'o000'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 10)
    
    // 새스콰치
    set unit_type_id = 'n00F'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 30)

    // 골렘 머드
    set unit_type_id = 'n00G'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 2)

    // 골렘 락
    set unit_type_id = 'n00H'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 4)

    // 골렘 그래닛
    set unit_type_id = 'n00I'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 15)
    
    
    // ==============================================
    // Courtyard
    // ==============================================
    // 안뜰 해골 칼
    set unit_type_id = 'n01I'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 1)
    
    // 안뜰 해골 법
    set unit_type_id = 'u004'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 1)
    
    // 안뜰 트렌트
    set unit_type_id = 'n01J'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 2)
    
    // 안뜰 구울
    set unit_type_id = 'u005'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 2)
    
    // 안뜰 크립트 핀드
    set unit_type_id = 'u006'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 2)
    
    // 안뜰 자이언트 스파이더
    set unit_type_id = 'n01K'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 3)
    
    // 안뜰 뮤턴트
    set unit_type_id = 'n01L'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 2)
    
    // 안뜰 밴시
    set unit_type_id = 'u007'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 2)
    
    // 안뜰 펄볼그 트래커
    set unit_type_id = 'n01M'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 3)
    
    // 안뜰 네크로맨서
    set unit_type_id = 'u008'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 3)
    
    // 안뜰 옵시디언 스태추
    set unit_type_id = 'u009'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 4)
    
    // 안뜰 다크 트롤
    set unit_type_id = 'n01N'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 2)
    
    // 안뜰 다크 트롤 프리스트
    set unit_type_id = 'n01O'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 2)
    
    // 안뜰 스피릿 울프
    set unit_type_id = 'o001'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 3)
    
    // 안뜰 딥로드 레버넌트
    set unit_type_id = 'n01P'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 5)
    
    // 안뜰 와일드킨
    set unit_type_id = 'n01Q'
    call SaveInteger(HT, unit_type_id, GOLD_DROP, 4)
endfunction

function Monster_Gold_Drop_Init takes nothing returns nothing
    call TimerStart(CreateTimer(), 0.00, false, function Gold_Drop_Table_Init)
endfunction

endlibrary
