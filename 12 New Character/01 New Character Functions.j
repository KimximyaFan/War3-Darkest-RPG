library NewCharacterFunctions

globals
    string array char_imgs
    string array char_names
    private string array atk_types
    private string array explainations
    integer array char_unit_types
    
    // 영웅 가짓 수
    integer hero_type_count = 0
endglobals

private function Create_Select_Zone_Characters takes nothing returns nothing
    local integer i = 0
    local unit u
    local real x = -15105
    local real y = 15120
    local real size
    
    // 일반 캐릭
    set u = CreateUnit(Player(15), 'e000', x + i * pad, y, 270)
    call DzSetUnitModel(u, "Royal Captain.mdx")
    call SetUnitScale(u, 1.0, 1.0, 1.0)
    set i = i + 1
    
    set u = CreateUnit(Player(15), 'e000', x + i * pad, y, 272)
    call DzSetUnitModel(u, "C_0001.mdx")
    call SetUnitScale(u, 1.1, 1.1, 1.1)
    set i = i + 1
    
    set u = CreateUnit(Player(15), 'e000', x + i * pad, y, 270)
    call DzSetUnitModel(u, "C_0003.mdx")
    call SetUnitScale(u, 0.80, 0.80, 0.80)
    set i = i + 1
    
    set size = 0.46
    set u = CreateUnit(Player(15), 'e000', x + i * pad, y, 273)
    call DzSetUnitModel(u, "C_0005.mdx")
    call SetUnitScale(u, size, size, size)
    set i = i + 1
    
    set size = 1.17
    set u = CreateUnit(Player(15), 'e000', x + i * pad, y, 270)
    call DzSetUnitModel(u, "Units\\Critters\\Marine\\Marine.mdl")
    call SetUnitScale(u, size, size, size)
    set i = i + 1
    
    set size = 0.78
    set u = CreateUnit(Player(15), 'e000', x + i * pad, y, 274)
    call DzSetUnitModel(u, "C_0008.mdx")
    call SetUnitScale(u, size, size, size)
    set i = i + 1
    
    set size = 0.66
    set u = CreateUnit(Player(15), 'e000', x + i * pad, y, 273)
    call DzSetUnitModel(u, "C_0010.mdx")
    call SetUnitScale(u, size, size, size)
    set i = i + 1
    
    // 후원 캐릭
    set u = CreateUnit(Player(15), 'e000', x + i * pad, y, 260)
    call DzSetUnitModel(u, "C_0002.mdx")
    call SetUnitScale(u, 0.75, 0.75, 0.75)
    set i = i + 1

    set u = CreateUnit(Player(15), 'e000', x + i * pad, y, 270)
    call DzSetUnitModel(u, "C_0004.mdx")
    call SetUnitScale(u, 0.64, 0.64, 0.64)
    set i = i + 1
    
    set size = 0.80
    set u = CreateUnit(Player(15), 'e000', x + i * pad, y, 270)
    call DzSetUnitModel(u, "C_0011.mdx")
    call SetUnitScale(u, size, size, size)
    set i = i + 1
    
    set hero_type_count = i
    
    set u = null
endfunction

private function Variables_Init takes nothing returns nothing
    local integer a = 0
    
    // 일반 캐릭
    set char_imgs[a] = "ReplaceableTextures\\CommandButtons\\BTNFootman.blp"
    set char_names[a] = "풋맨"
    set atk_types[a] = "물리 근거리"
    set explainations[a] = "투박하지만 성능은 보장한다"
    set char_unit_types[a] = 'H000'
    set a = a + 1
    
    set char_imgs[a] = "ReplaceableTextures\\CommandButtons\\BTNArcher.blp"
    set char_names[a] = "엘프 아처"
    set atk_types[a] = "하이브리드"
    set explainations[a] = "전형적인 스타일의 원딜"
    set char_unit_types[a] = 'H001'
    set a = a + 1
    
    set char_imgs[a] = "ReplaceableTextures\\CommandButtons\\BTNAcolyte.blp"
    set char_names[a] = "밤 까마귀"
    set atk_types[a] = "마법 원거리"
    set explainations[a] = "간지나는 화염 마법"
    set char_unit_types[a] = 'H003'
    set a = a + 1
    
    set char_imgs[a] = "ReplaceableTextures\\CommandButtons\\BTNBandit.blp"
    set char_names[a] = "바바리안"
    set atk_types[a] = "물리 근거리"
    set explainations[a] = "빙글빙글"
    set char_unit_types[a] = 'H00B'
    set a = a + 1
    
    set char_imgs[a] = "ReplaceableTextures\\CommandButtons\\BTNRifleman.blp"
    set char_names[a] = "마린"
    set atk_types[a] = "물리 원거리"
    set explainations[a] = "마린 키우기"
    set char_unit_types[a] = 'H00C'
    set a = a + 1
    
    set char_imgs[a] = "ReplaceableTextures\\CommandButtons\\BTNShandris.blp"
    set char_names[a] = "엔터프라이즈"
    set atk_types[a] = "하이브리드"
    set explainations[a] = "예쁨"
    set char_unit_types[a] = 'H00E'
    set a = a + 1
    
    set char_imgs[a] = "ReplaceableTextures\\CommandButtons\\BTNPenguin.blp"
    set char_names[a] = "리타"
    set atk_types[a] = "마법 근접"
    set explainations[a] = "리타쟝"
    set char_unit_types[a] = 'H00F'
    set a = a + 1
    
    // 후원 캐릭
    set char_imgs[a] = "ReplaceableTextures\\CommandButtons\\BTNHuntress.blp"
    set char_names[a] = "엘프 기사"
    set atk_types[a] = "하이브리드"
    set explainations[a] = "예쁜 엘프쟝"
    set char_unit_types[a] = 'H002'
    set a = a + 1

    set char_imgs[a] = "ReplaceableTextures\\CommandButtons\\BTNSnowOwl.blp"
    set char_names[a] = "그림자"
    set atk_types[a] = "물리 근거리"
    set explainations[a] = "슉샥슉샥 스타일리시한\n암살자 스타일"
    set char_unit_types[a] = 'H004'
    set a = a + 1
    
    set char_imgs[a] = "ReplaceableTextures\\CommandButtons\\BTNPolymorph.blp"
    set char_names[a] = "사자왕 세이버"
    set atk_types[a] = "하이브리드"
    set explainations[a] = "사자왕 세이버 입니다\n에크스칼리버를 씁니다"
    set char_unit_types[a] = 'H00G'
    set a = a + 1
endfunction

function New_Character_Unit_Type takes integer index returns integer
    return char_unit_types[index]
endfunction

function New_Character_Explaination takes integer index returns string
    return explainations[index]
endfunction

function New_Character_Atk_Type takes integer index returns string
    return atk_types[index]
endfunction

function New_Character_Name takes integer index returns string
    return char_names[index]
endfunction

function New_Character_Img takes integer index returns string
    return char_imgs[index]
endfunction

function New_Character_Functions_Init takes nothing returns nothing
    call Variables_Init()
    call Create_Select_Zone_Characters()
endfunction

endlibrary