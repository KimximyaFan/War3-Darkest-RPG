
library SmartCastSystem initializer Init requires DzAPIFrameHandle, DzAPIHardware, DzAPIPlus, MemoryLib
globals
    boolean Smartkey_On_Q = true
    boolean Smartkey_On_W = true
    boolean Smartkey_On_E = true
    boolean Smartkey_On_R = true
    boolean Smartkey_On_Z = true
    boolean Smartkey_On_X = true
    boolean Smartkey_On_C = true
    boolean Smartkey_On_V = true
    
    private constant integer COMMAND_BAR_ROWS = 3
    private constant integer COMMAND_BAR_COLUMNS = 4

    private constant integer TABLE_TRIGGER_TYPE_KEY = 1
    public constant integer TRIGGER_TYPE_NONE = 0
    public constant integer TRIGGER_TYPE_ALWAYS = 1
    public constant integer TRIGGER_TYPE_SHIFT_DOWN = 2
    public constant integer TRIGGER_TYPE_SHIFT_UP = 3

    private boolean wannaSmartCast = false
    private boolean wannaDisableSmartQueue = false
    private real targetX
    private real targetY
    private unit target

    private hashtable table = InitHashtable()
    private integer defaultTriggerType = TRIGGER_TYPE_NONE
endglobals

//! runtextmacro MemoryLib_DefineMemoryBlock("private", "MemoryBlock", "SmartCastSystem__MemoryBlock", "4 * 200")

public function SetAbilityTriggerType takes integer abilityId, integer triggerType returns nothing
    call SaveInteger(table, abilityId, TABLE_TRIGGER_TYPE_KEY, triggerType)
endfunction

public function UnsetAbilityTriggerType takes integer abilityId returns nothing
    call FlushChildHashtable(table, abilityId)
endfunction

public function SetDefaultTriggerType takes integer triggerType returns nothing
    set defaultTriggerType = triggerType
endfunction

private function GetAbilityTriggerType takes integer abilityId returns integer
    if not HaveSavedInteger(table, abilityId, TABLE_TRIGGER_TYPE_KEY) then
        return defaultTriggerType
    endif
    return LoadInteger(table, abilityId, TABLE_TRIGGER_TYPE_KEY)
endfunction

private function CursorIsOnWorldUI takes nothing returns boolean
    return (DzGetMouseFocus() == 0)
endfunction

private function IsChatInputMode takes nothing returns boolean
    return IntPtr[pGameDll + 0xD04FEC] != 0
endfunction

private function GetCommandBarButtonByHotkey takes integer hotkey returns integer
    local integer x
    local integer y
    local CommandButton btn

    set y = 0
    loop
        exitwhen (y >= COMMAND_BAR_ROWS)

        set x = 0
        loop
            exitwhen (x >= COMMAND_BAR_COLUMNS)

            set btn = CommandButton.getCommandBarButton(x, y)
            if (btn.data.hotkey == hotkey) then
                return btn
            endif

            set x = x + 1
        endloop

        set y = y + 1
    endloop

    return 0
endfunction

private function IsSmartCastable takes integer triggerType returns boolean
    if (triggerType == TRIGGER_TYPE_NONE) then
        return false
    elseif (triggerType == TRIGGER_TYPE_ALWAYS) then
        return true
    elseif (triggerType == TRIGGER_TYPE_SHIFT_DOWN) then
        return DzIsKeyDown(JN_OSKEY_SHIFT)
    elseif (triggerType == TRIGGER_TYPE_SHIFT_UP) then
        return not DzIsKeyDown(JN_OSKEY_SHIFT)
    endif
    return false
endfunction

private function IsTargetMode takes nothing returns boolean
    local GameUI gameUI = GameUI.getInstance()
    return gameUI.currentMode == gameUI.targetMode
endfunction

private function EnableShiftQueue takes boolean enabled returns nothing
    local BytePtr statement = BytePtr(pGameDll + 0x9CE37)
    if (enabled) then
        // mov esi,eax
        set statement[0] = 0x8B
        set statement[1] = 0xF0
    else
        // xor esi,esi
        set statement[0] = 0x31
        set statement[1] = 0xF6
    endif
endfunction

private function CancelTargetMode takes nothing returns nothing
    local Ptr pFunc = pGameDll + 0x3A86C0

    call SaveStr(JNProc_ht, JNProc_key, 0, "(I)V")
    call SaveInteger(JNProc_ht, JNProc_key, 1, GameUI.getInstance())
    call JNProcCall(JNProc__thiscall, pFunc, JNProc_ht)
endfunction

private function GetWidgetAddress takes widget w returns integer
    local integer pFunc = JNGetModuleHandle("Game.dll") + 0x2217A0

    call SaveStr(JNProc_ht, JNProc_key, 0, "(I)I")
    call SaveInteger(JNProc_ht, JNProc_key, 1, GetHandleId(w))
    if (JNProcCall(JNProc__thiscall, pFunc, JNProc_ht)) then
        return LoadInteger(JNProc_ht, JNProc_key, 0)
    endif
    return 0
endfunction

private function SpriteClickEvent takes real x, real y, widget target returns Ptr
    local Ptr pBlock = MemoryBlock.pHead
    local Ptr pTarget = GetWidgetAddress(target)
    set IntPtr(pBlock)[0] = pGameDll + 0xAAC124
    set IntPtr(pBlock)[1] = 0x0
    set IntPtr(pBlock)[2] = 0x001A0064
    set RealPtr(pBlock)[7] = x
    set RealPtr(pBlock)[8] = y
    set IntPtr(pBlock)[10] = 0x1
    set IntPtr(pBlock)[12] = pTarget
    set IntPtr(pBlock)[160] = 0x0
    return pBlock
endfunction

private function TerrainClickEvent takes real x, real y returns Ptr
    local Ptr pBlock = MemoryBlock.pHead
    local Ptr pTarget = GetWidgetAddress(target)
    set IntPtr(pBlock)[0] = pGameDll + 0xAAC118
    set IntPtr(pBlock)[1] = 0x0
    set IntPtr(pBlock)[2] = 0x001A0068
    set RealPtr(pBlock)[7] = x
    set RealPtr(pBlock)[8] = y
    set IntPtr(pBlock)[10] = 0x1
    return pBlock
endfunction

private function DispatchClickEvent takes real targetX, real targetY, widget target returns nothing
    local Ptr pEvent
    if (target != null) then
        set pEvent = SpriteClickEvent(targetX, targetY, target)
    else
        set pEvent = TerrainClickEvent(targetX, targetY)
    endif
    call GameUI.getInstance().handleEvent(pEvent)
endfunction

public function HandleSmartCast takes nothing returns nothing
    local boolean l_wannaDisableSmartQueue

    if (not wannaSmartCast) then
        return
    endif

    set wannaSmartCast = false

    if (not IsTargetMode()) then
        return
    endif

    set l_wannaDisableSmartQueue = wannaDisableSmartQueue
    if (l_wannaDisableSmartQueue) then
        call EnableShiftQueue(false)
    endif
    
    call DispatchClickEvent(targetX, targetY, target)
    
    if (l_wannaDisableSmartQueue) then
        call EnableShiftQueue(true)
    endif
    
    if (IsTargetMode()) then
        call CancelTargetMode()
    endif
endfunction

private function SmartCastCallback takes nothing returns nothing
    call HandleSmartCast()
    call DzFrameSetUpdateCallback("")
endfunction

private function HandleKeyPress takes nothing returns nothing
    local integer keycode
    local CommandButton btn
    local integer triggerType

    if (IsChatInputMode() or not CursorIsOnWorldUI()) then
        return
    endif

    set keycode = JNGetTriggerKey()
    //---------------이하 추가한 함수----------------------------
    
    if keycode==JN_OSKEY_Q then
        if not Smartkey_On_Q then
            return
        endif
    elseif keycode==JN_OSKEY_W then
        if not Smartkey_On_W then
            return
        endif
    elseif keycode==JN_OSKEY_E then
        if not Smartkey_On_E then
            return
        endif
    elseif keycode==JN_OSKEY_R then
        if not Smartkey_On_R then
            return
        endif
    elseif keycode==JN_OSKEY_Z then
        if not Smartkey_On_Z then
            return
        endif
    elseif keycode==JN_OSKEY_X then
        if not Smartkey_On_X then
            return
        endif
    elseif keycode==JN_OSKEY_C then
        if not Smartkey_On_C then
            return
        endif
    elseif keycode==JN_OSKEY_V then
        if not Smartkey_On_V then
            return
        endif
    endif
    //-----------------------끝--------------------
    set btn = GetCommandBarButtonByHotkey(keycode)
    if (btn.data == 0) then
        return
    endif

    set triggerType = GetAbilityTriggerType(btn.data.abilityId)
    if (not IsSmartCastable(triggerType)) then
        return
    endif

    set wannaSmartCast = true
    set wannaDisableSmartQueue = (triggerType == TRIGGER_TYPE_SHIFT_DOWN)
    set targetX = DzGetMouseTerrainX()
    set targetY = DzGetMouseTerrainY()
    set target = JNGetMouseFocusUnit()
    call DzFrameSetUpdateCallbackByCode(function SmartCastCallback)
endfunction

private function RegisterKey takes integer keycode returns nothing
    call DzTriggerRegisterKeyEventByCode(null, keycode, 1, false, function HandleKeyPress)
endfunction

private function RegisterAlphabetKeys takes nothing returns nothing
    local string alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local integer keycode
    local integer i = 0
    local integer n = StringLength(alphabets)
    //loop
        //exitwhen (i >= n)

        //set keycode = JN_OSKEY_A + i
        //call RegisterKey(keycode)

        //set i = i + 1
    //endloop
    //------이상 기존함수 이하 추가한 함수--------------------------------
    call RegisterKey(JN_OSKEY_Q)
    call RegisterKey(JN_OSKEY_W)
    call RegisterKey(JN_OSKEY_E)
    call RegisterKey(JN_OSKEY_R)
    call RegisterKey(JN_OSKEY_Z)
    call RegisterKey(JN_OSKEY_X)
    call RegisterKey(JN_OSKEY_C)
    call RegisterKey(JN_OSKEY_V)
    call SmartCastSystem_SetDefaultTriggerType(SmartCastSystem_TRIGGER_TYPE_ALWAYS)
    //------끝--------------------------------
endfunction

private function RegisterKeys takes nothing returns nothing
    call RegisterAlphabetKeys()
endfunction

private function Init takes nothing returns nothing
    call RegisterKeys()
endfunction
endlibrary