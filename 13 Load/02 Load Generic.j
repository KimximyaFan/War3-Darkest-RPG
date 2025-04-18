library LoadGeneric

// =========================================================
// New Character Functions 트리거 페이지에 있는 거랑 연동 됨
// =========================================================

function Get_Character_Name_From_Unit_Id takes integer unit_id returns string
    local integer i
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= hero_type_count
        if unit_id == char_unit_types[i] then
            return char_names[i]
        endif
    endloop
    
    return ""
    
    return "?"
endfunction

function Get_Icon_Img_From_Unit_Id takes integer unit_id returns string
    local integer i
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= hero_type_count
        if unit_id == char_unit_types[i] then
            return char_imgs[i]
        endif
    endloop
    
    return ""
endfunction

function Choose_Frame_Hide takes nothing returns nothing
    call DzFrameShow(choose_box, false)
endfunction

function Choose_Frame_Show takes nothing returns nothing
    call DzFrameShow(choose_box, true)
endfunction

function Load_Frame_Hide takes nothing returns nothing
    call DzFrameShow(load_box, false)
endfunction

function Load_Frame_Show takes nothing returns nothing
    call DzFrameShow(load_box, true)
endfunction

endlibrary