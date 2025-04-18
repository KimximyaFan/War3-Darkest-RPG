library StoreDispose requires Basic

function Equip_Store_Dispose takes real x, real y, real angle returns nothing
    local unit equip_merchant
    local unit potion_merchant
    local real size = 8.5
    local real height = 125
    
    if is_Test == true then
        set equip_merchant = CreateUnit(Player(15), 'n01H', x, y, angle)
    elseif MAP_DIFFICULTY == NORMAL then
        set equip_merchant = CreateUnit(Player(15), 'n001', x, y, angle)
    elseif MAP_DIFFICULTY == NIGHTMARE then
        set equip_merchant = CreateUnit(Player(15), 'n003', x, y, angle)
    elseif MAP_DIFFICULTY == HELL then
        set equip_merchant = CreateUnit(Player(15), 'n005', x, y, angle)
    else
        // 혹시 모를 예외처리
        set equip_merchant = CreateUnit(Player(15), 'n001', x, y, angle) 
    endif
    
    call Text_Tag(GetUnitX(equip_merchant) - 50, GetUnitY(equip_merchant), 255, 255, 255, size, height, 0, 0, 0, -1, -1, "장비", null, -1, 0)
    
    // 물약 상인
    set potion_merchant = CreateUnit(Player(15), 'n006', x+135, y, 270)
    call Text_Tag(GetUnitX(potion_merchant) - 50, GetUnitY(potion_merchant), 255, 255, 255, size, height, 0, 0, 0, -1, -1, "물약", null, -1, 0)
    
    set equip_merchant = null
    set potion_merchant = null
endfunction

endlibrary