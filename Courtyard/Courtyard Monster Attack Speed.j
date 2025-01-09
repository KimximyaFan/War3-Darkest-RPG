library CourtyardMonsterAttackSpeed

private function Attack_Speed_Init takes nothing returns nothing
    local integer unit_type_id
    
    // 안뜰 해골 칼
    set unit_type_id = 'n01I'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.50)
    
    // 안뜰 해골 법
    set unit_type_id = 'u004'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.60)
    
    // 안뜰 트렌트
    set unit_type_id = 'n01J'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.40)
    
    // 안뜰 구울
    set unit_type_id = 'u005'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.35)
    
    // 안뜰 크립트 핀드
    set unit_type_id = 'u006'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.40)
    
    // 안뜰 자이언트 스파이더
    set unit_type_id = 'n01K'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.35)
    
    // 안뜰 뮤턴트
    set unit_type_id = 'n01L'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.35)
    
    // 안뜰 밴시
    set unit_type_id = 'u007'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.50)
    
    // 안뜰 펄볼그 트래커
    set unit_type_id = 'n01M'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.35)
    
    // 안뜰 네크로맨서
    set unit_type_id = 'u008'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.50)
    
    // 안뜰 옵시디언 스태추
    set unit_type_id = 'u009'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.25)
    
    // 안뜰 다크 트롤
    set unit_type_id = 'n01N'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.35)
    
    // 안뜰 다크 트롤 프리스트
    set unit_type_id = 'n01O'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.50)
    
    // 안뜰 스피릿 울프
    set unit_type_id = 'o001'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.20)
    
    // 안뜰 딥로드 레버넌트
    set unit_type_id = 'n01P'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.35)
    
    // 안뜰 와일드킨
    set unit_type_id = 'n01Q'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.35)
    
    // 안뜰 브루드 마더
    set unit_type_id = 'n01R'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.35)
    
    // 안뜰 마그나타우어 워리어
    set unit_type_id = 'n01S'
    call SaveReal(HT, unit_type_id, ATTACK_COOLDOWN, 1.35)
endfunction

function Courtyard_Monster_Attack_Speed_Init takes nothing returns nothing
    call TimerStart( CreateTimer(), 0.00, false, function Attack_Speed_Init )
endfunction

endlibrary