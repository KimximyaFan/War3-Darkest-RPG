library SimplePotal

globals
    // ===================================================
    // 여기 아래 변수들은 취향에 맞게 잘 수정 해서 쓰세요
    // ===================================================
    
    // 포탈 입장 시 유닛을 숨김
    private boolean is_hide = true
    
    // 포탈 입장 시 유닛을 정지
    private boolean is_pause = true
    
    // 포탈 입장 시 도착 좌표로 카메라 이동
    private boolean is_camera_move = true
    
    // 포탈 입장 시 몇번 째 포탈인지 출력
    private boolean is_debug = false
    
    // 포탈 입장 후, 도착지역 순간이동 딜레이 시간
    private real potal_delay = 0.75
    
    // 포탈 입장 후, 도착지역 카메라 이동 시간
    private real potal_camera_time = 0.15
    
    // 포탈 좌표 생성시 기본 구역 크기
    private real rect_width = 150
    private real rect_height = 150
    
    // 포탈 입장, 도착 이펙트
    private string potal_effect = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl"
    
    // 맵에서 이미 쓰고있는 해쉬테이블이 있고, 최적화 하고싶으면 알아서 바꾸셈
    // private hashtable HT = InitHashtable()
    
    // ====================================================
    
    
    // ====================================================
    // 여기 변수들은 뭐 건들 것도 없음, 무시 ㄱ
    // ====================================================
    private trigger array potal_trg
    private rect array potal_rect
    private rect array potal_camera_bound
    private real array potal_out_x
    private real array potal_out_y
    private integer count = -1
    private boolean potal_possible = true
    
    // ====================================================
endglobals


// ====================================================
// 기본적으로 영웅 유닛만 포탈 이동 가능함
// 일반 유닛도 포탈 이동 가능하게 하고 싶으면
// 여기 아래 조건 수정해서 알아서 커스텀 ㄱ
// ====================================================
private function Potal_Enter_Condition takes nothing returns boolean
    return IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) == true
endfunction

// ====================================================

private function Teleport_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real x = LoadReal(HT, id, 1)
    local real y = LoadReal(HT, id, 2)
    local rect camera_bound = LoadRectHandle(HT, id, 3)
    
    call SetUnitPosition(u, x, y)
    
    call DestroyEffect( AddSpecialEffect(potal_effect, x, y) )
    
    if camera_bound != null then
        call SetCameraBoundsToRectForPlayerBJ( GetOwningPlayer(u), camera_bound )
    endif
    
    if is_hide == true then
        call ShowUnitShow( u )
        call SelectUnitForPlayerSingle( u, GetOwningPlayer(u) )
    endif
    
    if is_pause == true then
        call PauseUnitBJ( false, u )
    endif
    
    if is_camera_move == true then
        call PanCameraToTimedForPlayer( GetOwningPlayer(u), x, y, potal_camera_time )
    endif

    call FlushChildHashtable(HT, GetHandleId(t))
    call PauseTimer(t)
    call DestroyTimer(t)
    
    set t = null
    set u = null
    set camera_bound = null
endfunction

function Teleport takes unit u, real x, real y, rect camera_bound returns nothing
    local timer t
    local integer id
    
    if potal_possible == false then
        return
    endif
    
    set t = CreateTimer()
    set id = GetHandleId(t)
    
    call DestroyEffect( AddSpecialEffect(potal_effect, GetUnitX(u), GetUnitY(u)) )
    
    if is_hide == true then
        call ShowUnitHide( u )
    endif
    
    if is_pause == true then
        call PauseUnitBJ( true, u )
    endif
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, x)
    call SaveReal(HT, id, 2, y)
    call SaveRectHandle(HT, id, 3, camera_bound)
    call TimerStart(t, potal_delay, false, function Teleport_Func )
    
    set t = null
endfunction

private function Potal_Entered takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local trigger triggering_trg = GetTriggeringTrigger()
    local integer i
    
    set i = 0
    loop
    exitwhen triggering_trg == potal_trg[i] or i > count
        set i = i + 1
    endloop
    
    if is_debug == true then
        call BJDebugMsg(I2S(i) + "번 포탈 작동")
    endif
    
    call Teleport(u, potal_out_x[i], potal_out_y[i], potal_camera_bound[i])
    
    set u = null
endfunction

private function Trigger_Register takes real in_x, real in_y, real out_x, real out_y, rect in_rect, rect camera_bound returns nothing
    set count = count + 1
    
    set potal_out_x[count] = out_x
    set potal_out_y[count] = out_y
    
    if in_rect != null then
        set potal_rect[count] = Rect( GetRectMinX(in_rect), GetRectMinY(in_rect), GetRectMaxX(in_rect), GetRectMaxY(in_rect))
    else
        set potal_rect[count] = Rect( in_x - (rect_width/2), in_y - (rect_height/2), in_x + (rect_width/2), in_y + (rect_height/2))
    endif
    
    if camera_bound != null then
        set potal_camera_bound[count] = Rect( GetRectMinX(camera_bound), GetRectMinY(camera_bound), GetRectMaxX(camera_bound), GetRectMaxY(camera_bound))
    endif
    
    set potal_trg[count] = CreateTrigger()
    call TriggerRegisterEnterRectSimple( potal_trg[count], potal_rect[count] )
    call TriggerAddCondition( potal_trg[count], Condition( function Potal_Enter_Condition ) )
    call TriggerAddAction( potal_trg[count], function Potal_Entered )
endfunction

// ========================================================
// API
// ========================================================



// 좌표 4개와 함수 하나로 유닛 입장 텔포를 딸깍 생성 해주는 함수
// in_x in_y 는 입장 좌표, out_x out_y 는 도착 좌표임
// 사용 예 : Simple_Potal_Create(-200, -200, 5000, 5000)
function Simple_Potal_Create takes real in_x, real in_y, real out_x, real out_y returns nothing
    call Trigger_Register(in_x, in_y, out_x, out_y, null, null)
endfunction


// 입장구역 1개, 좌표 2개와 함수 하나로 유닛 입장 텔포를 딸깍 생성 해주는 함수
// in_rect는 입장 구역, out_x out_y 는 도착 좌표임
// 사용 예 : Simple_Potal_Create_Rect(rect, 5000, 5000)
function Simple_Potal_Create_Rect takes rect in_rect, real out_x, real out_y returns nothing
    call Trigger_Register(0, 0, out_x, out_y, in_rect, null)
endfunction


// 혹시 몰라서 카메라 바운드 쓰시는 분들을 위한 함수, 뒤에 추가로 도착 구역 카메라바운드 집어넣으면 됨
// 사용 예 : Simple_Potal_Create_Bound(-200, -200, 5000, 5000, camera_bound)
function Simple_Potal_Create_Bound takes real in_x, real in_y, real out_x, real out_y, rect camera_bound returns nothing
    call Trigger_Register(in_x, in_y, out_x, out_y, null, camera_bound)
endfunction


// 혹시 몰라서 카메라 바운드 쓰시는 분들을 위한 함수, 뒤에 추가로 도착 구역 카메라바운드 집어넣으면 됨
// 사용 예 : Simple_Potal_Create_Rect_Bound(rect, 5000, 5000, camera_bound)
function Simple_Potal_Create_Rect_Bound takes rect in_rect, real out_x, real out_y, rect camera_bound returns nothing
    call Trigger_Register(0, 0, out_x, out_y, in_rect, camera_bound)
endfunction


// 이거 작동 시키면 포탈 작동 안함
// 사용 예 : Simple_Potal_Off()
function Simple_Potal_Off takes nothing returns nothing
    set potal_possible = false
endfunction


// 이거 작동 시키면 포탈 작동함, 기본적으로 이미 작동 가능한 상태라서
// Simple_Potal_Off() 를 쓴 상태가 아니면 쓸일 없음
// 사용 예 : Simple_Potal_On()
function Simple_Potal_On takes nothing returns nothing
    set potal_possible = true
endfunction


// 만들어 둔 포탈 삭제 하고 싶으면 포탈 넘버 기입해서 이 함수 작동 시키셈
// 몇번 포탈인지 모르겠으면 global 변수에서 is_debug = true로 체크해서 테스트 ㄱ
// 사용 예 : Simple_Potal_Remove(2)
function Simple_Potal_Remove takes integer num returns nothing
    call TriggerClearConditions( potal_trg[num] )
    call TriggerClearActions( potal_trg[num] )
    call DestroyTrigger( potal_trg[num] )
    call RemoveRect( potal_rect[num] )
    call RemoveRect( potal_camera_bound[num] )
endfunction

endlibrary