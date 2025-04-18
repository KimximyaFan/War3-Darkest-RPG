
globals
    constant integer HELMET = 1
    constant integer WEAPON = 2
    constant integer ARMOR = 3
    constant integer SHIELD = 4
    constant integer NECKLACE = 5
    constant integer RING = 6
    constant integer BELT = 7
    constant integer GLOVE = 8
    constant integer BOOTS = 9
endglobals

struct Equip

    // Property
    
    private integer ad /* 0 공격력 */
    private integer ap /* 1 주문력 */
    private integer as /* 2 공격속도 */
    private integer ms /* 3 이동속도 */
    private integer crit /* 4 치확 */
    private integer crit_coef /* 5 치피 */
    private integer def_ad /* 6 물리 방어력 */
    private integer def_ap /* 7 마법 방어력 */ 
    private integer hp /* 8 체력 */
    private integer mp /* 9 마나 */
    private integer hp_regen /* 10 체력회복 */
    private integer mp_regen /* 11 마나회복 */
    private integer enhance_ad /* 12 물리 피해 강화 */
    private integer enhance_ap /* 13 마법 피해 강화 */
    private integer reduce_ad /* 14 물리 받피감 */
    private integer reduce_ap /* 15 마법 받피감 */
    
    private integer grade /* 등급 */
    private integer upgrade_count /* 강화수치 */
    private integer item_type /* 아이템 타입 */
    private string item_name /* 아이템 이름 */
    private string item_img /* 아이템 이미지 */
    
    private integer special
    
    public integer array ran_arr[16]

    
    /*
        등급 목록
        grade 0 : 일반
        grade 1 : 희귀
        grade 2 : 영웅
        grade 3 : 전설
        grade 4 : 신화
    */
    
    
    /*
        랜덤 스탯 목록
        
        헬멧 : 0 1 2 4 5 7 8 9 10 11 
        무기 : 2 4 5 6 7 8 9 10 11
        갑옷 : 4 5 6 7 9 10 11 14 15
        방패 : 4 5 7 8 9 10 11 14 15
        목걸이 : 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
        반지 : 0 1 2 3 4 5 6 8 7 9 10 11 12 13 14 15
        벨트 : 0 1 2 3 4 5 6 8 9 10 11
        장갑 : 0 1 3 4 5 6 8 7 9 10 11
        부츠 : 0 1 2 4 5 6 8 7 9 10 11
    
    */
    
    /*
        장비 타입 목록

        투
        무기
        갑옷
        방패
        목걸이
        반지
        벨트
        장갑
        부츠
    */


    public method Get_AD takes nothing returns integer
        return this.ad
    endmethod
    
    public method Get_AP takes nothing returns integer
        return this.ap
    endmethod
    
    public method Get_AS takes nothing returns integer
        return this.as
    endmethod
    
    public method Get_MS takes nothing returns integer
        return this.ms
    endmethod
    
    public method Get_CRIT takes nothing returns integer
        return this.crit
    endmethod
    
    public method Get_CRIT_COEF takes nothing returns integer
        return this.crit_coef
    endmethod
    
    public method Get_DEF_AD takes nothing returns integer
        return this.def_ad
    endmethod
    
    public method Get_DEF_AP takes nothing returns integer
        return this.def_ap
    endmethod
    
    public method Get_HP takes nothing returns integer
        return this.hp
    endmethod
    
    public method Get_MP takes nothing returns integer
        return this.mp
    endmethod
    
    public method Get_HP_REGEN takes nothing returns integer
        return this.hp_regen
    endmethod
    
    public method Get_MP_REGEN takes nothing returns integer
        return this.mp_regen
    endmethod
    
    public method Get_ENHANCE_AD takes nothing returns integer
        return this.enhance_ad
    endmethod
    
    public method Get_ENHANCE_AP takes nothing returns integer
        return this.enhance_ap
    endmethod
    
    public method Get_REDUCE_AD takes nothing returns integer
        return this.reduce_ad
    endmethod
    
    public method Get_REDUCE_AP takes nothing returns integer
        return this.reduce_ap
    endmethod
    
    // ===================================================================
    
    public method Set_AD takes integer a returns nothing
        set this.ad = a
    endmethod
    
    public method Set_AP takes integer a returns nothing
        set this.ap = a
    endmethod
    
    public method Set_AS takes integer a returns nothing
        set this.as = a
    endmethod
    
    public method Set_MS takes integer a returns nothing
        set this.ms = a
    endmethod

    public method Set_CRIT takes integer a returns nothing
        set this.crit = a
    endmethod
    
    public method Set_CRIT_COEF takes integer a returns nothing
        set this.crit_coef = a
    endmethod
    
    public method Set_DEF_AD takes integer a returns nothing
        set this.def_ad = a
    endmethod
    
    public method Set_DEF_AP takes integer a returns nothing
        set this.def_ap = a
    endmethod
    
    public method Set_HP takes integer a returns nothing
        set this.hp = a
    endmethod
    
    public method Set_MP takes integer a returns nothing
        set this.mp = a
    endmethod
    
    public method Set_HP_REGEN takes integer a returns nothing
        set this.hp_regen = a
    endmethod
    
    public method Set_MP_REGEN takes integer a returns nothing
        set this.mp_regen = a
    endmethod

    public method Set_ENHANCE_AD takes integer a returns nothing
        set this.enhance_ad = a
    endmethod
    
    public method Set_ENHANCE_AP takes integer a returns nothing
        set this.enhance_ap = a
    endmethod
    
    public method Set_REDUCE_AD takes integer a returns nothing
        set this.reduce_ad = a
    endmethod
    
    public method Set_REDUCE_AP takes integer a returns nothing
        set this.reduce_ap = a
    endmethod
    
    // ====================================================================
    
    public method Get_Grade takes nothing returns integer
        return this.grade
    endmethod
    
    public method Get_Upgrade_Count takes nothing returns integer
        return this.upgrade_count
    endmethod
    
    public method Get_Name takes nothing returns string
        return this.item_name
    endmethod
    
    public method Get_Type takes nothing returns integer
        return this.item_type
    endmethod
    
    public method Get_Img takes nothing returns string
        return this.item_img
    endmethod
    
    public method Get_Special takes nothing returns integer
        return this.special
    endmethod
    
    // ====================================================================
    
    public method Set_Grade takes integer a returns nothing
        set this.grade = a
    endmethod
    
    public method Set_Upgrade_Count takes integer a returns nothing
        set this.upgrade_count = a
    endmethod
    
    public method Set_Name takes string s returns nothing
        set this.item_name = s
    endmethod
    
    public method Set_Type takes integer int returns nothing
        set this.item_type = int
    endmethod
    
    public method Set_Img takes string s returns nothing
        set this.item_img = s
    endmethod
    
    public method Set_Special takes integer i returns nothing
        set this.special = i
    endmethod
    
    public static method create takes nothing returns thistype
        local thistype this = thistype.allocate()
        set this.special = -1
        return this
    endmethod
        
    public method destroy takes nothing returns nothing
        set this.grade = 0
        set this.upgrade_count = 0
        set this.ad = 0
        set this.ap = 0
        set this.as = 0
        set this.ms = 0
        set this.crit = 0
        set this.crit_coef = 0
        set this.def_ad = 0
        set this.def_ap = 0
        set this.hp = 0
        set this.mp = 0
        set this.hp_regen = 0
        set this.mp_regen = 0
        set this.enhance_ad = 0
        set this.enhance_ap = 0
        set this.reduce_ad = 0
        set this.reduce_ap = 0
        call thistype.deallocate( this )
    endmethod
    
    public method Integer_To_Type takes nothing returns string
        local string type_str = "?"
        
        if this.item_type == HELMET then
            set type_str = "투구"
        elseif this.item_type == WEAPON then
            set type_str = "무기"
        elseif this.item_type == ARMOR then
            set type_str = "갑옷"
        elseif this.item_type == SHIELD then
            set type_str = "방패"
        elseif this.item_type == NECKLACE then
            set type_str = "목걸이"
        elseif this.item_type == RING then
            set type_str = "반지"
        elseif this.item_type == BELT then
            set type_str = "벨트"
        elseif this.item_type == GLOVE then
            set type_str = "장갑"
        elseif this.item_type == BOOTS then
            set type_str = "부츠"
        endif
        
        return type_str
    endmethod
    
endstruct