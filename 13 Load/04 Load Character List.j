library LoadCharacterList requires LoadGeneric

globals
    boolean array is_character_loaded
endglobals

function Set_Character_List takes nothing returns nothing
    local string str
    local integer i
    local integer unit_id
    local integer difficulty_cleared
    
    //call BJDebugMsg(character_list)
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 7
        set str = JNStringSplit(character_list, "#", i)
        
        if JNStringSplit(str, ",", 0) != "-1" then
            // 대충 스트링에 있는 정보 추출해서, 프레임 이미지 세팅하고, 프레임 텍스트 세팅
            set is_character_loaded[i] = true
            set unit_id = S2I(JNStringSplit(str, ",", 0))
            set difficulty_cleared = S2I(JNStringSplit(str, ",", 1))
            
            // Load Generic 참조
            call DzFrameSetTexture(load_img[i], Get_Icon_Img_From_Unit_Id(unit_id), 0)
            call DzFrameShow(load_img[i], true)
            call DzFrameSetText(load_button_text[i], Get_Character_Name_From_Unit_Id(unit_id) )
            
            // str은 unit id 랑 current_difficulty_cleared 정보를 가지고있음
            // 자세한건 Save Frames and Interaction 의 Build_Character_List() 함수 참조
            set current_difficulty_cleared[i] = difficulty_cleared
        else
            set is_character_loaded[i] = false
            set current_difficulty_cleared[i] = 0
        endif
    endloop
endfunction

function Load_Character_List_Init takes nothing returns nothing
    local integer i
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 7
        if Player_Playing_Check( Player(i) ) then
            if GetLocalPlayer() == Player(i) then
                call Set_Character_List()
            endif
        endif
    endloop
endfunction

endlibrary