library BgmGeneric

globals
    public boolean is_bgm_on = true
    public integer current_bgm_state = -1
    
    public sound array bgm
    
    public constant integer BGM_CAMP = 0
    public constant integer BGM_REGION_1 = 1
    public constant integer BGM_REGION_2 = 2
    public constant integer BGM_REGION_3 = 3
    public constant integer BGM_REGION_4 = 4
    public constant integer BGM_DARK_DUNGEON = 10
    public constant integer BGM_DARKEST_DUNGEON = 11
    
    public constant integer MAX_REGION_INDEX = 11
endglobals

// 각플에서만 사용되어야함
public function Bgm_Off takes nothing returns nothing
    if current_bgm_state == -1 then
        return
    endif
    call StopSoundBJ( bgm[current_bgm_state], false )
endfunction

// 각플에서만 사용되어야함
public function Bgm_On takes nothing returns nothing
    if is_bgm_on == false then
        return
    endif
    
    call PlaySoundBJ( bgm[current_bgm_state] )
endfunction

function Bgm_Variable_Init takes nothing returns nothing
    if is_Test == true then
        set is_bgm_on = false
    endif
    set bgm[0] = gg_snd_Bgm_Camp
    set bgm[1] = gg_snd_Bgm_Weald
    set bgm[2] = gg_snd_Bgm_Ruins
    set bgm[3] = gg_snd_Bgm_Warrens
    set bgm[4] = gg_snd_Bgm_Cove
    set bgm[10] = gg_snd_Bgm_Dark_Dungeon
endfunction

endlibrary