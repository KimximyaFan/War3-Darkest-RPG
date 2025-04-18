library PotionFrame requires Base, PotionInfluence

globals
    private real square_size = 0.048
    private real item_size = 0.046

    private integer health_potion_back_drop
    private integer health_potion_img
    private integer health_potion_button
    private integer health_potion_key_text
    private integer health_potion_count_text
    private integer health_potion_tool_tip_back_drop
    private integer health_potion_tool_tip_text
    
    
    private integer mana_potion_back_drop
    private integer mana_potion_img
    private integer mana_potion_button
    private integer mana_potion_key_text
    private integer mana_potion_count_text
    private integer mana_potion_tool_tip_back_drop
    private integer mana_potion_tool_tip_text
    
    private boolean h_potion_possible = true
    private boolean m_potion_possible = true
    
    private trigger sync_trg
    
    private real potion_cool_time = 0.45
endglobals

private function Mana_Tool_Tip_Leave takes nothing returns nothing
    call DzFrameShow(mana_potion_tool_tip_back_drop, false)
endfunction

private function Mana_Tool_Tip_Enter takes nothing returns nothing
    call DzFrameShow(mana_potion_tool_tip_back_drop, true)
endfunction

private function Health_Tool_Tip_Leave takes nothing returns nothing
    call DzFrameShow(health_potion_tool_tip_back_drop, false)
endfunction

private function Health_Tool_Tip_Enter takes nothing returns nothing
    call DzFrameShow(health_potion_tool_tip_back_drop, true)
endfunction

function Potion_Frame_Show takes nothing returns nothing
    call DzFrameShow(health_potion_back_drop, true)
    call DzFrameShow(mana_potion_back_drop, true)
endfunction

function Mana_Potion_Frame_Refresh takes nothing returns nothing
    call DzFrameSetText(mana_potion_count_text, I2S(mana_potion_count) )
endfunction

function Health_Potion_Frame_Refresh takes nothing returns nothing
    call DzFrameSetText(health_potion_count_text, I2S(health_potion_count) )
endfunction

private function Mana_Potion_Cooldown takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local integer pid = LoadInteger(HT, id, 0)
    
    if GetLocalPlayer() == Player(pid) then
        set m_potion_possible = true
    endif
    
    call Timer_Clear(t)
    
    set t = null
endfunction

private function Health_Potion_Cooldown takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local integer pid = LoadInteger(HT, id, 0)
    
    if GetLocalPlayer() == Player(pid) then
        set h_potion_possible = true
    endif
    
    call Timer_Clear(t)
    
    set t = null
endfunction

private function Mana_Potion_Synchronize takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local integer pid = S2I( DzGetTriggerSyncData() )
    
    call Mana_Potion_Influence(pid)
    
    call SaveInteger(HT, id, 0, pid)
    call TimerStart(t, potion_cool_time, false, function Mana_Potion_Cooldown)
    
    set t = null
endfunction

private function Health_Potion_Synchronize takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local integer pid = S2I( DzGetTriggerSyncData() )
    
    call Health_Potion_Influence(pid)
    
    call SaveInteger(HT, id, 0, pid)
    call TimerStart(t, potion_cool_time, false, function Health_Potion_Cooldown)
    
    set t = null
endfunction

// ==================================================================
// API
// ==================================================================

function Mana_Potion_Generic_Process takes integer pid returns nothing
    if GetLocalPlayer() == Player(pid) then
        if mana_potion_count <= 0 then
            return
        endif
        
        if IsUnitAliveBJ(player_hero[pid].Get_Hero_Unit()) == false then
            return
        endif
        
        set m_potion_possible = false
        set mana_potion_count = mana_potion_count - 1
        
        call Mana_Potion_Frame_Refresh()
        call DzSyncData("m_potion", I2S(pid))
    endif
endfunction

function Health_Potion_Generic_Process takes integer pid returns nothing
    if GetLocalPlayer() == Player(pid) then
        if health_potion_count <= 0 then
            return
        endif
        
        if IsUnitAliveBJ(player_hero[pid].Get_Hero_Unit()) == false then
            return
        endif
        
        set h_potion_possible = false
        set health_potion_count = health_potion_count - 1
        
        call Health_Potion_Frame_Refresh()
        call DzSyncData("h_potion", I2S(pid))
    endif
endfunction

// ==================================================================
// Frame Interaction
// ==================================================================

private function Mana_Potion_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId( DzGetTriggerKeyPlayer() )
    
    if JNMemoryGetByte(JNGetModuleHandle("Game.dll") + 0xD04FEC) != 0 then
            return
    endif
    
    if m_potion_possible == false then
        return
    endif
    
    call PlaySoundBJ(gg_snd_MouseClick1)
    
    call Mana_Potion_Generic_Process(pid)
endfunction

private function Health_Potion_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId( DzGetTriggerKeyPlayer() )
    
    if JNMemoryGetByte(JNGetModuleHandle("Game.dll") + 0xD04FEC) != 0 then
            return
    endif
    
    if h_potion_possible == false then
        return
    endif
    
    call PlaySoundBJ(gg_snd_MouseClick1)
    
    call Health_Potion_Generic_Process(pid)
endfunction

// 가져다대면 설명해주는 툴팁
private function Potion_Tool_Tip takes nothing returns nothing
    set health_potion_tool_tip_back_drop = DzCreateFrameByTagName("BACKDROP", "", health_potion_back_drop, "QuestButtonBaseTemplate", 0)
    call DzFrameSetPoint(health_potion_tool_tip_back_drop, JN_FRAMEPOINT_CENTER, health_potion_back_drop, JN_FRAMEPOINT_CENTER, 0.04, 0.05)
    call DzFrameSetSize(health_potion_tool_tip_back_drop, 0.135, 0.05)

    set health_potion_tool_tip_text = DzCreateFrameByTagName("TEXT", "", health_potion_tool_tip_back_drop, "", 0)
    call DzFrameSetPoint(health_potion_tool_tip_text, JN_FRAMEPOINT_CENTER, health_potion_tool_tip_back_drop, JN_FRAMEPOINT_CENTER, 0.0, 0.0)
    call DzFrameSetText(health_potion_tool_tip_text, " 4초 동안 \n 최대 체력 30% 회복")
    
    call DzFrameShow(health_potion_tool_tip_back_drop, false)
    
    
    set mana_potion_tool_tip_back_drop = DzCreateFrameByTagName("BACKDROP", "", mana_potion_back_drop, "QuestButtonBaseTemplate", 0)
    call DzFrameSetPoint(mana_potion_tool_tip_back_drop, JN_FRAMEPOINT_CENTER, mana_potion_back_drop, JN_FRAMEPOINT_CENTER, 0.04, 0.05)
    call DzFrameSetSize(mana_potion_tool_tip_back_drop, 0.135, 0.05)

    set mana_potion_tool_tip_text = DzCreateFrameByTagName("TEXT", "", mana_potion_tool_tip_back_drop, "", 0)
    call DzFrameSetPoint(mana_potion_tool_tip_text, JN_FRAMEPOINT_CENTER, mana_potion_tool_tip_back_drop, JN_FRAMEPOINT_CENTER, 0.0, 0.0)
    call DzFrameSetText(mana_potion_tool_tip_text, " 4초 동안 \n 최대 마나 35% 회복")
    
    call DzFrameShow(mana_potion_tool_tip_back_drop, false)
endfunction

// 체력포션, 마나포션 -> 백드롭, 이미지, 버튼
private function Potion_Frames takes nothing returns nothing
    // 체력포션 프레임 구현
    set health_potion_back_drop = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "QuestButtonPushedBackdropTemplate", 0)
    call DzFrameSetPoint(health_potion_back_drop, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, -0.05, -0.21 )
    call DzFrameSetSize(health_potion_back_drop, square_size, square_size)
    
    set health_potion_img = DzCreateFrameByTagName("BACKDROP", "", health_potion_back_drop, "QuestButtonPushedBackdropTemplate", 0)
    call DzFrameSetTexture(health_potion_img, "ReplaceableTextures\\CommandButtons\\BTNPotionGreen.blp", 0)
    call DzFrameSetPoint(health_potion_img, JN_FRAMEPOINT_CENTER, health_potion_back_drop, JN_FRAMEPOINT_CENTER, 0, 0 )
    call DzFrameSetSize(health_potion_img, item_size, item_size)
    
    set health_potion_button = DzCreateFrameByTagName("BUTTON", "", health_potion_back_drop, "ScoreScreenTabButtonTemplate", 0)
    call DzFrameSetPoint(health_potion_button, JN_FRAMEPOINT_CENTER, health_potion_back_drop, JN_FRAMEPOINT_CENTER, 0, 0)
    call DzFrameSetSize(health_potion_button, square_size, square_size)
    call DzFrameSetScriptByCode(health_potion_button, JN_FRAMEEVENT_CONTROL_CLICK, function Health_Potion_Clicked, false)
    
    set health_potion_key_text = DzCreateFrameByTagName("TEXT", "", health_potion_back_drop, "ScoreScreenColumnHeaderTemplate", 0)
    call DzFrameSetPoint(health_potion_key_text, JN_FRAMEPOINT_CENTER, health_potion_back_drop, JN_FRAMEPOINT_CENTER, -0.012, 0.012)
    call DzFrameSetText(health_potion_key_text, "2" )
    
    set health_potion_count_text = DzCreateFrameByTagName("TEXT", "", health_potion_back_drop, "ScoreScreenColumnHeaderTemplate", 0)
    call DzFrameSetPoint(health_potion_count_text, JN_FRAMEPOINT_CENTER, health_potion_back_drop, JN_FRAMEPOINT_CENTER, 0, -0.03)
    call DzFrameSetText(health_potion_count_text, "0" )
    
    // 마우스 들어가면 툴팁생성 
    call DzFrameSetScriptByCode(health_potion_button, JN_FRAMEEVENT_MOUSE_ENTER, function Health_Tool_Tip_Enter, false)
    call DzFrameSetScriptByCode(health_potion_button, JN_FRAMEEVENT_MOUSE_LEAVE, function Health_Tool_Tip_Leave, false)
    
    call DzFrameShow(health_potion_back_drop, false)
    
    // 마나포션 프레임 구현
    set mana_potion_back_drop = DzCreateFrameByTagName("BACKDROP", "", health_potion_back_drop, "QuestButtonPushedBackdropTemplate", 0)
    call DzFrameSetPoint(mana_potion_back_drop, JN_FRAMEPOINT_CENTER, health_potion_back_drop, JN_FRAMEPOINT_CENTER, 0.05, 0 )
    call DzFrameSetSize(mana_potion_back_drop, square_size, square_size)
    
    set mana_potion_img = DzCreateFrameByTagName("BACKDROP", "", mana_potion_back_drop, "QuestButtonPushedBackdropTemplate", 0)
    call DzFrameSetTexture(mana_potion_img, "ReplaceableTextures\\CommandButtons\\BTNPotionBlueBig.blp", 0)
    call DzFrameSetPoint(mana_potion_img, JN_FRAMEPOINT_CENTER, mana_potion_back_drop, JN_FRAMEPOINT_CENTER, 0, 0 )
    call DzFrameSetSize(mana_potion_img, item_size, item_size)
    
    set mana_potion_button = DzCreateFrameByTagName("BUTTON", "", mana_potion_back_drop, "ScoreScreenTabButtonTemplate", 0)
    call DzFrameSetPoint(mana_potion_button, JN_FRAMEPOINT_CENTER, mana_potion_back_drop, JN_FRAMEPOINT_CENTER, 0, 0)
    call DzFrameSetSize(mana_potion_button, square_size, square_size)
    call DzFrameSetScriptByCode(mana_potion_button, JN_FRAMEEVENT_CONTROL_CLICK, function Mana_Potion_Clicked, false)
    
    set mana_potion_key_text = DzCreateFrameByTagName("TEXT", "", mana_potion_back_drop, "ScoreScreenColumnHeaderTemplate", 0)
    call DzFrameSetPoint(mana_potion_key_text, JN_FRAMEPOINT_CENTER, mana_potion_back_drop, JN_FRAMEPOINT_CENTER, -0.012, 0.012)
    call DzFrameSetText(mana_potion_key_text, "3" )
    
    set mana_potion_count_text = DzCreateFrameByTagName("TEXT", "", mana_potion_back_drop, "ScoreScreenColumnHeaderTemplate", 0)
    call DzFrameSetPoint(mana_potion_count_text, JN_FRAMEPOINT_CENTER, mana_potion_back_drop, JN_FRAMEPOINT_CENTER, 0, -0.03)
    call DzFrameSetText(mana_potion_count_text, "0" )
    
    // 마우스 들어가면 툴팁생성 
    call DzFrameSetScriptByCode(mana_potion_button, JN_FRAMEEVENT_MOUSE_ENTER, function Mana_Tool_Tip_Enter, false)
    call DzFrameSetScriptByCode(mana_potion_button, JN_FRAMEEVENT_MOUSE_LEAVE, function Mana_Tool_Tip_Leave, false)
    
    call DzFrameShow(mana_potion_back_drop, false)
endfunction

function Potion_Frame_Init takes nothing returns nothing
    call Potion_Frames()
    call Potion_Tool_Tip()
    
    call DzTriggerRegisterKeyEventByCode(null, JN_OSKEY_2, 1, false, function Health_Potion_Clicked)
    call DzTriggerRegisterKeyEventByCode(null, JN_OSKEY_3, 1, false, function Mana_Potion_Clicked)
    
    // 동기화
    set sync_trg = CreateTrigger()
    call DzTriggerRegisterSyncData(sync_trg, "h_potion", false)
    call TriggerAddAction( sync_trg, function Health_Potion_Synchronize )
    
    set sync_trg = CreateTrigger()
    call DzTriggerRegisterSyncData(sync_trg, "m_potion", false)
    call TriggerAddAction( sync_trg, function Mana_Potion_Synchronize )
endfunction


endlibrary