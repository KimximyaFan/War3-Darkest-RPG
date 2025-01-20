library CourtyardMercenary

    // ===============================================================
    // Frame
    // ===============================================================
    
    // 백드롭과 8칸
    private function Load_Button_Back takes nothing returns nothing
        local integer i
        local integer a
        local integer b
        local real padding = 0.025
        local real x = 0.03
        local real y = -0.035
        local real test_padding = -0.035
        
        set i = -1
        loop
        set i = i + 1
        exitwhen i > 7
            
            set a = ModuloInteger(i, 4)
            set b = (i / 4)
            set load_button_back[i] = DzCreateFrameByTagName("BACKDROP", "", load_box, "QuestButtonBaseTemplate", 0)
            call DzFrameSetPoint(load_button_back[i], JN_FRAMEPOINT_TOPLEFT, load_box, JN_FRAMEPOINT_TOPLEFT, x + ((square_size + padding) * a), y + (-(square_size + padding) * b) )
            call DzFrameSetSize(load_button_back[i], square_size, square_size)
            
            set load_img[i] = DzCreateFrameByTagName("BACKDROP", "", load_button_back[i], "QuestButtonBaseTemplate", 0)
            call DzFrameSetPoint(load_img[i], JN_FRAMEPOINT_CENTER, load_button_back[i], JN_FRAMEPOINT_CENTER, 0, 0 )
            call DzFrameSetSize(load_img[i], img_size, img_size)
            call DzFrameShow(load_img[i], false)
            
            set load_button_text[i] = DzCreateFrameByTagName("TEXT", "", load_button_back[i], "", 0)
            call DzFrameSetPoint(load_button_text[i], JN_FRAMEPOINT_CENTER, load_button_back[i], JN_FRAMEPOINT_CENTER, 0.0, test_padding)
            call DzFrameSetText(load_button_text[i], "빈 캐릭터" )
            
            set load_button[i] = DzCreateFrameByTagName("BUTTON", I2S(i) + "/load", load_button_back[i], "ScoreScreenTabButtonTemplate", 0)
            call DzFrameSetPoint(load_button[i], JN_FRAMEPOINT_CENTER, load_button_back[i], JN_FRAMEPOINT_CENTER, 0, 0)
            call DzFrameSetSize(load_button[i], square_size, square_size)
            call DzFrameSetScriptByCode(load_button[i], JN_FRAMEEVENT_CONTROL_CLICK, function Load_Button_Clicked, false)
        endloop
    endfunction
    
    endlibrary