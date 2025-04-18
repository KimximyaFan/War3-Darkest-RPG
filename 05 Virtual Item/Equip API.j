library EquipAPI requires EquipRandomize, InvenGeneric

function Create_Random_Equip takes integer pid, integer w0, integer w1, integer w2, integer w3, integer w4, integer item_type, integer probability returns integer
    local integer i
    local Equip E
    
    if GetRandomInt(1, 100) > probability then
        return -2
    endif
    
    set i = Hero(pid+1).Check_Inven_Possible()
    
    if i == -1 then
        if GetLocalPlayer() == Player(pid) then
            call BJDebugMsg("인벤 꽉참")
        endif
        return -1
    endif

    set E = Equip.create()
    call Equip_Randomize(E, w0, w1, w2, w3, w4, item_type)

    call Hero(pid+1).Set_Inven_Item( i, E )
    call Inven_Set_Img(pid, i, Hero(pid+1).Get_Inven_Item(i))
    
    return 1
endfunction
    
function Property_To_String takes integer property returns string
    local string str
    
    if property == AD then
        set str = "공격력"
    elseif property == AP then
        set str = "주문력"
    elseif property == AS then
        set str = "공격속도"
    elseif property == MS then
        set str = "이동속도"
    elseif property == CRIT then
        set str = "치명확률"
    elseif property == CRIT_COEF then
        set str = "치명피해"
    elseif property == DEF_AD then
        set str = "물리방어력"
    elseif property == DEF_AP then
        set str = "마법방어력"
    elseif property == HP then
        set str = "체력"
    elseif property == MP then
        set str = "마나"
    elseif property == HP_REGEN then
        set str = "체력회복"
    elseif property == MP_REGEN then
        set str = "마나회복"
    elseif property == ENHANCE_AD then
        set str = "물리피해강화"
    elseif property == ENHANCE_AP then
        set str = "마법피해강화"
    elseif property == REDUCE_AD then
        set str = "물리받피감"
    elseif property == REDUCE_AP then
        set str = "마법받피감"
    endif
    
    return str
endfunction

endlibrary