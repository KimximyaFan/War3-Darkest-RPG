library PotalGeneric requires Basic

globals
    public string array region_name
    public string array region_potal_point
    public integer array region_potal_point_count
    public integer array prefix_sum
    
    public real array region_point_x
    public real array region_point_y
    
    public trigger array region_enter_trg
endglobals

// 이 함수는 각플 내에서 실행되어야함
function Reconstruct_Potal_Save_String takes nothing returns nothing
    local string save_str = ""
    local integer i
    local integer j
    local integer state

    set i = -1
    loop
    set i = i + 1
    exitwhen i >= REGION_COUNT
        
        
        set j = -1
        loop
        set j = j + 1
        exitwhen j >= PotalGeneric_region_potal_point_count[i]
            if potal_state_check[ PotalGeneric_prefix_sum[i] + j ] == true then
                set save_str = save_str + "1/"
            else
                set save_str = save_str + "-1/"
            endif
        endloop
        
        set save_str = save_str + "#"
    endloop
    
    if is_Test == true then
        set potal_save_state_test = save_str
    else
        set potal_save_state = save_str
    endif
endfunction

// 이 함수는 각플 내에서 실행되어야함
function Set_Potal_State_Check takes nothing returns nothing
    local string region_potal_str
    local integer i
    local integer j
    local integer state
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= REGION_COUNT
        // i 번째 지역의 포탈 저장 상태 스트링
        
        if is_Test == true then
            set region_potal_str = JNStringSplit(potal_save_state_test, "#", i)
        else
            set region_potal_str = JNStringSplit(potal_save_state, "#", i)
        endif
        
        set j = -1
        loop
        set j = j + 1
        exitwhen j >= region_potal_point_count[i]
            // i 번째 지역의 j 번재 포탈 위치 state를 봄
            set state = S2I(JNStringSplit(region_potal_str, "/", j))
            
            if state == 1 then
                // 사실상 i번째 행 j번 째 열을 다루는 2차원 배열이랑 다름 없음
                set potal_state_check[ prefix_sum[i] + j ] = true
            endif
        endloop
    endloop
endfunction

function Potal_Preprocess takes nothing returns nothing
    local integer i = -1
    local integer size = 9
    
    loop
    set i = i + 1
    exitwhen i > size
        set potal_state_check[i] = false
    endloop
    
    set region_name[0] = "삼림지대"
    set region_name[1] = "폐허"
    set region_name[2] = "사육장"
    set region_name[3] = "해안만"
    
    set region_potal_point_count[0] = 3
    
    set region_potal_point[0] = "삼림지대 중간"
    set region_point_x[0] = -7597
    set region_point_y[0] = -5434
    
    set region_potal_point[1] = "동굴 안"
    set region_point_x[1] = -15272
    set region_point_y[1] = -12579
    
    set region_potal_point[2] = "동굴 밖 평야"
    set region_point_x[2] = -10174
    set region_point_y[2] = -4417
    
    
    set region_potal_point_count[1] = 3
    
    set region_potal_point[3] = "폐허 초입"
    set region_point_x[3] = -734
    set region_point_y[3] = -14052
    
    set region_potal_point[4] = "폐허 미로 입구"
    set region_point_x[4] = -6848
    set region_point_y[4] = -6682
    
    set region_potal_point[5] = "폐허 미로 깊은 곳"
    set region_point_x[5] = 193
    set region_point_y[5] = -13039
    
    
    set region_potal_point_count[2] = 3
    
    set region_potal_point[6] = "사육장 입구"
    set region_point_x[6] = 7259
    set region_point_y[6] = -4385
    
    set region_potal_point[7] = "사육장 중간"
    set region_point_x[7] = 6786
    set region_point_y[7] = -15482
    
    set region_potal_point[8] = "세 갈래 길"
    set region_point_x[8] = 9236
    set region_point_y[8] = -11809
    
    
    set region_potal_point_count[3] = 2
    
    set region_potal_point[9] = "해안만 외곽"
    set region_point_x[9] = 15361
    set region_point_y[9] = -7519
    
    set region_potal_point[10] = "해안만 중심"
    set region_point_x[10] = 8978
    set region_point_y[10] = -1360
    
    
    set prefix_sum[0] = 0
    set prefix_sum[1] = 3
    set prefix_sum[2] = 6
    set prefix_sum[3] = 9
    set prefix_sum[4] = 11
endfunction

endlibrary