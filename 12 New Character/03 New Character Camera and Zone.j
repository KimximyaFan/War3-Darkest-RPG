library NewCharacterCamera

globals 

private real camera_x = -15090
private real camera_y = 15100

private timer t
private boolean array is_Unlock

private fogmodifier array the_view

real pad = 256

endglobals

function Destroy_Select_Zone_View takes integer pid returns nothing
    call DestroyFogModifier(the_view[pid])
endfunction

function New_Character_Camera_Unlock takes integer pid returns nothing
    set is_Unlock[pid] = true
endfunction

private function Camera_Lock takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local integer pid = LoadInteger(HT, id, 0)
    
    if is_Unlock[pid] == true then
        call Timer_Clear(t)
        set t = null
        return
    endif
    
    if GetLocalPlayer() == Player(pid) then
        call CameraSetupApplyForceDuration(gg_cam_New_Character_1, true, 0)
    endif
    
    set t = null
endfunction

private function Camera_Lock_Sync takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local integer pid = S2I(DzGetTriggerSyncData())
    
    set the_view[pid] = CreateFogModifierRectBJ( true, Player(pid), FOG_OF_WAR_VISIBLE, gg_rct_CharacterSelectZone )
    set is_Unlock[pid] = false
    call SaveInteger(HT, id, 0, pid)
    call TimerStart(t, 0.1, true, function Camera_Lock)
    
    set t = null
endfunction

function New_Character_Camera_Lock_Start takes integer pid returns nothing
    call CameraSetupApplyForceDuration(gg_cam_New_Character_1, true, 0)
    call DzSyncData("camera", I2S(pid))
endfunction

function New_Character_Set_Camera takes integer i returns nothing
    call SetCameraBounds(camera_x + (i*pad), 15100, camera_x + (i*pad), 15100, camera_x + (i*pad), 15100, camera_x + (i*pad), 15100)
    call PanCameraToTimed(camera_x + (i*pad), 15100, 0.0)
endfunction

function New_Character_Camera_Init takes nothing returns nothing
    local trigger trg
    
    // 개인 카메라 고정 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "camera", false)
    call TriggerAddAction( trg, function Camera_Lock_Sync )
    
    set trg = null
endfunction


endlibrary