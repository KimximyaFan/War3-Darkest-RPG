/*
library GetUnitsInRectangle

private function Polar_Y takes real y, real dist, real angle returns real
    return y + dist * Sin(angle * bj_DEGTORAD)
endfunction

private function Polar_X takes real x, real dist, real angle returns real
    return x + dist * Cos(angle * bj_DEGTORAD)
endfunction

private function Group_Clear takes group g returns nothing
    call GroupClear(g)
    call DestroyGroup(g)
endfunction

private function Counter_Clock_Wise takes real x1, real y1, real x2, real y2, real unit_x, real unit_y returns real
    return (x2-x1)*(unit_y-y2) - (y2-y1)*(unit_x - x2)
endfunction

private function Is_Point_In_Rectangle takes real unit_x, real unit_y, real x1, real y1, real x2, real y2, real x3, real y3, real x4, real y4 returns boolean
    if Counter_Clock_Wise(x1, y1, x2, y2, unit_x, unit_y) < 0.0 then
        return false
    endif
    if Counter_Clock_Wise(x2, y2, x3, y3, unit_x, unit_y) < 0.0 then
        return false
    endif
    if Counter_Clock_Wise(x3, y3, x4, y4, unit_x, unit_y) < 0.0 then
        return false
    endif
    if Counter_Clock_Wise(x4, y4, x1, y1, unit_x, unit_y) < 0.0 then
        return false
    endif
    return true
endfunction

private function Units_In_Rectangle takes unit u, real x, real y, real width, real height, real angle, group g returns group
    local real half_width = width/2
    local real half_height = height/2
    local real radius = SquareRoot( half_width*half_width + half_height*half_height )
    local real center_x = Polar_X(x, half_height, angle)
    local real center_y = Polar_Y(y, half_height, angle)
    local real array point_x
    local real array point_y
    local group temp_group
    local unit c
    
    set point_x[0] = Polar_X(x, half_width, angle-90)
    set point_y[0] = Polar_Y(y, half_width, angle-90)
    
    set point_x[1] = Polar_X(point_x[0], height, angle)
    set point_y[1] = Polar_Y(point_y[0], height, angle)
    
    set point_x[2] = Polar_X(point_x[1], width, angle+90)
    set point_y[2] = Polar_Y(point_y[1], width, angle+90)
    
    set point_x[3] = Polar_X(point_x[2], height, angle+180)
    set point_y[3] = Polar_Y(point_y[2], height, angle+180)
    
    set g = CreateGroup()
    set temp_group = CreateGroup()
    
    call GroupEnumUnitsInRange( temp_group, center_x, center_y, radius, null )
    
    loop
    set c = FirstOfGroup(temp_group) 
    exitwhen c == null
        call GroupRemoveUnit(temp_group, c)
        
        if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            if Is_Point_In_Rectangle(GetUnitX(c), GetUnitY(c), point_x[0], point_y[0], point_x[1], point_y[1], point_x[2], point_y[2], point_x[3], point_y[3]) == true then
                call GroupAddUnit(g, c)
            endif
        endif
    endloop
    
    call Group_Clear(temp_group)
    
    set c = null
    set temp_group = null
    
    return g
endfunction

// ===========================================
// API
// ===========================================

function Get_Enemy_Units_In_Rectangle_Center takes unit u, real x, real y, real width, real height, real angle returns group
    return Units_In_Rectangle(u, Polar_X(x, height/2, angle+180), Polar_Y(y, height/2, angle+180), width, height, angle, null) 
endfunction

function Get_Enemy_Units_In_Rectangle takes unit u, real x, real y, real width, real height, real angle returns group
    return Units_In_Rectangle(u, x, y, width, height, angle, null) 
endfunction

endlibrary
*/