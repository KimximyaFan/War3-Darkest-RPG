globals

// 전역변수들임
string CHARACTER_LOCK = "CHARACTER_LOCK"
string EXP_RATE = "EXP_RATE"
string GOLD_DROP_RATE = "GOLD_DROP_RATE"
string ITEM_DROP_RATE = "ITEM_DROP_RATE"
string POTION_INCREASE = "POTION_INCREASE"
string PLAY_TIME = "PLAY_TIME"


string CHARACTER_LIST = "CHARACTER_LIST"

integer array play_time[6] 

Hero array player_hero

boolean is_Test = false

string MAP_ID = "DRPG"

string SECRET_KEY = "94668e85-a144-48f4-92fb-a5904a3491d2"

string array USER_ID[7]

constant integer REGION_COUNT = 4
constant integer REGION_POTAL_SIZE = 11

string potal_save_state = "-1/-1/-1#-1/-1/-1#-1/-1/-1#-1/-1"
//string potal_save_state_test = "-1/-1/-1#-1/-1/-1#-1/-1/-1#-1/-1"
string potal_save_state_test = "1/1/1#1/1/1#1/1/1#1/1"
boolean array potal_state_check

integer array current_difficulty_cleared

integer array milestone
string local_milestone_str = "0,0,0" /* 로컬용 */

integer POTION_LIMIT = 20 /* buff stat frame 에서 갱신됨 */
integer health_potion_count = 0
integer mana_potion_count = 0

// 저장한 캐릭터 목록
string character_list

// 후원
string character_lock
string aura_list
string wing_list

integer array exp_rate
integer array gold_drop_rate
integer array item_drop_rate
integer potion_increase

integer global_drop_rate = 0

// 저장 가능한 횟수
integer save_count = 3
// 유저가 선택한 로드창 칸 인덱스
integer current_load_index = 0

integer array loaded_character_count[6]

hashtable HT = InitHashtable()
hashtable HT_Monster_Regen = InitHashtable()
hashtable HT_ITEM = InitHashtable()

player p_enemy = Player(12)



constant integer FOOT_MAN = 'H000'
constant integer ELF_ARCHER = 'H001'
constant integer NIGHT_CROW = 'H003'
constant integer ELF_KNIGHT = 'H002'
constant integer SHADOW = 'H004'

constant integer Q = 0
constant integer W = 1
constant integer E = 2
constant integer R = 3
constant integer Z = 4
constant integer X = 5
constant integer C = 6
constant integer V = 7

constant boolean AD_TYPE = false
constant boolean AP_TYPE = true

// 일반
constant integer AD_BASIC_ATTACK = 1
// 관통
constant integer AP_BASIC_ATTACK = 2
// 공성
constant integer AD_NO_CRIT = 3
// 매직
constant integer AP_NO_CRIT = 4
// 카오스
constant integer AD_CRIT = 5
// 영웅
constant integer AP_CRIT = 6

constant real map_center_x = -3.4
constant real map_center_y = -95

// 맵 난이도
integer MAP_DIFFICULTY = 0

constant integer NORMAL = 0
constant integer NIGHTMARE = 1
constant integer HELL = 2

// 이거 아마 아이템 grade에도 쓰일 수 있고 쓰이거나 할 수도
// 몬스터 GRADE 관련, 생성시 랜덤으로 부여되고 특별 스킬에 연관 있음
constant integer UNCOMMON = 1
constant integer RARE = 2
constant integer LEGEND = 3
constant integer EPIC = 4

// 몬스터 CLASS 관련, 몬스터 타입에 따라 고정된 값이고, 몬스터 강함의 척도
constant integer PLANE = 0
constant integer GRUNT = 1
constant integer ELDER = 2
constant integer MID_BOSS = 3
constant integer BOSS = 4

constant integer AD = 0
constant integer AP = 1
constant integer AS = 2
constant integer MS = 3
constant integer CRIT = 4
constant integer CRIT_COEF = 5
constant integer DEF_AD = 6
constant integer DEF_AP = 7
constant integer HP = 8
constant integer MP = 9
constant integer HP_REGEN = 10
constant integer MP_REGEN = 11
constant integer ENHANCE_AD = 12
constant integer ENHANCE_AP = 13
constant integer REDUCE_AD = 14
constant integer REDUCE_AP = 15
constant integer LEVEL = 16
constant integer GRADE = 17 /* 이거 몬스터 GRADE에도 쓰임 */ /* GRADE LENGTH BASE PAD 이 넷은 가상아이템 스탯관련 */
constant integer LENGTH = 18
constant integer BASE = 19
constant integer PAD = 20
constant integer GRADE_GAP = 21
constant integer MODEL_SIZE = 22
constant integer PAUSE = 23 /* 몬스터 정지 관련 */
constant integer CLASS = 24
constant integer REGION = 25 /* 몬스터 생성 지역 */
constant integer TAG_APPLIED = 26 /* grade 몬스터들 유동텍스트 적용됐는지 판별하는 */
constant integer TEXT_TAG = 27 /* 텍스트 태그 자료구조 */
constant integer IN_COMBAT = 28 /* 몬스터가 전투중인지 판별하는 변수 */
constant integer ATTACK_COOLDOWN = 29
constant integer CUSTOM_INT_0 = 30 /* custom int 0~4 그냥 유닛 객체 고유의 정수값들, 유용하게 쓰임  */
constant integer CUSTOM_INT_1 = 31
constant integer CUSTOM_INT_2 = 32
constant integer CUSTOM_INT_3 = 33
constant integer CUSTOM_INT_4 = 34
constant integer GOLD_DROP = 40 /* 몬스터 기본 골드 드랍 수치 */
constant integer IN_COURTYARD = 41 /* 안뜰에 있는건지? 몬스터든 영웅이든 */
constant integer DIFFICULTY_LIKE = 42 /* 안뜰 몬스터를 어느 난이도 급으로 칠껀가?, 드랍에 이용됨 */
constant integer LOAD_CHARACTER_INDEX = 43 /* 캐릭터 로드 관련 변수 */
constant integer IS_AUTO_COMBAT = 44 /* 지금 영웅이 자동전투 상태인지? */
constant integer IS_MERCENARY = 45 /* 용병 유닛인지? */
constant integer IS_FORCED_DEATH = 46 /* 안뜰에서 쓰임, 몬스터 강제로 죽임 처리 한건지? */

constant integer UPGRADE_PADDING = 1000

// 장비 강화 비용
constant integer ITEM_UPGRADE_GOLD_0 = 100
constant integer ITEM_UPGRADE_GOLD_1 = 500
constant integer ITEM_UPGRADE_GOLD_2 = 2500
constant integer ITEM_UPGRADE_GOLD_3 = 12500
constant integer ITEM_UPGRADE_GOLD_4 = 60000
constant integer ITEM_UPGRADE_GOLD_5 = 300000


endglobals