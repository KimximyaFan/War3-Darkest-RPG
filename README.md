# War3 Darkest RPG

<br>
<br>
<br>

제작일
: 2024 11 18

제작기간
: 7개월

설명
: RPG 유즈맵 <br>
워크 기본 시스템을 최대한 배제하고 <br>
각종 요소들을 스크립트로 직접 구현한게 특징 <br>

<br>
<br>
<br>

## 내용

<img width="520" height="390" alt="1" src="https://github.com/user-attachments/assets/b4c29034-11db-440f-9aac-82e5ba3544f9" /> <br>

맵 시작 <br>
플레이어에 다 캐릭 육성 제공 <br>
난이도 설정 가능, 구간 재활용으로 컨탠츠 재사용성 향상 <br>

<br>
<br>
<br>

<img width="520" height="390" alt="2" src="https://github.com/user-attachments/assets/ef2af5c1-7895-4365-8a2e-5df819ca7312" /> <br>

캐릭터 선택창

<br>
<br>
<br>

### BGM 시스템

<img width="520" height="390" alt="3" src="https://github.com/user-attachments/assets/86110f69-a6da-4d16-9daa-a0ed6829f643" /> <br>
<img width="225" height="72" alt="4" src="https://github.com/user-attachments/assets/b80b724d-01b9-416a-85ae-6fc336eafe8d" /> <br>

BGM 시스템

워크래프트의 bgm 시스템에는 두 가지 문제점이 있음

1. 볼륨을 조절하려면 각종 사운드이펙트의 볼륨도 같이 줄어버리는 문제 존재
2. 사운드 이펙트를 재생하면 유저 전체에게 똑같이 들림

해당 시스템은 bgm 볼륨만 단독으로 조절할 수 있으며,<br>
서로 다른 지역에 존재하는 플레이어들에게 다른 bgm 사운드를 제공함<br>

<br>
<br>
<br>

### 포션 시스템

<img width="520" height="390" alt="5" src="https://github.com/user-attachments/assets/ef6f485e-f322-46d7-bb09-17ab8da8587c" /> <br>
<img width="229" height="83" alt="6" src="https://github.com/user-attachments/assets/7f3001ad-87f1-4562-80cb-7b43c6cf66a7" /> <br>

포션 시스템

워크래프트는 자체 아이템 오브젝트를 제공하지만 문제점이 존재함

1. 오브젝트 시스템이 꽤 무거움
2. 오브젝트의 효과를 코드로 자유자재 조절하기 까다로움

그래서 이를 사용하지 않고 자체적으로 구현하였음 <br>
플레이어들에게 다른 UI를 보여지게하는 까다로운 구현이 들어감 <br>
스크립트상으로 조절가능하게 되었으며, 효과도 자유롭게 적용 가능함

<br>
<br>
<br>

### 인벤, 착용칸, 스탯, 장비강화

<img width="520" height="390" alt="7" src="https://github.com/user-attachments/assets/4efab247-f48e-4ba0-9790-8c47bd8b2008" /> <br>
<img width="520" height="390" alt="8" src="https://github.com/user-attachments/assets/8c535328-c0b5-4b73-a54a-94335a623385" /> <br>
<img width="520" height="390" alt="9" src="https://github.com/user-attachments/assets/49ef0a2f-d0cf-4f5c-8574-fbf39df1bc35" /> <br>

인벤토리, 착용칸, 스탯, 장비강화 시스템

아이템 생성시 랜덤 스탯, 랜덤 수치 강화

좋은 아이템을 만들기 확률적으로 어려우므로, <br>
컨탠츠 소모속도 낮추는 효과 기대

<br>
<br>
<br>

<img width="520" height="390" alt="10" src="https://github.com/user-attachments/assets/5ab66cef-f348-4008-af11-a02684a77796" />
<img width="520" height="390" alt="11" src="https://github.com/user-attachments/assets/660a43e9-c742-4232-9d77-f22988ca960a" /> <br>

인게임 플레이 1

<br>
<br>
<br>

### 포탈 시스템

<img width="520" height="390" alt="12" src="https://github.com/user-attachments/assets/ab8a2b95-42cb-4a5b-b216-7dd1bf493fd7" /> <br>

포탈 시스템

각종 UI 및, 플레이어 진행 상태에 따른 개별 UI 보여주기

개개인 포탈 상태 저장 기능 존재

처음에는 아무 것도 없지만, 지역 진행하면서 포탈 갱신

<br>
<br>
<br>

<img width="520" height="390" alt="14" src="https://github.com/user-attachments/assets/356df298-0449-4add-a6a0-56b87c1828e0" />

<img width="520" height="390" alt="15" src="https://github.com/user-attachments/assets/83d4633c-b100-4fb8-88d3-52f49d25f443" /> <br>

포탈 이용

<br>
<br>
<br>

<img width="520" height="390" alt="16" src="https://github.com/user-attachments/assets/501394b6-03ec-4535-9e5e-71c498f9763c" />
<img width="520" height="390" alt="18" src="https://github.com/user-attachments/assets/834c1555-8dde-466e-920b-57c3c15ff01d" /> <br>

인게임 플레이 2

<br>
<br>
<br>

### 커스텀 스탯

<img width="248" height="209" alt="19" src="https://github.com/user-attachments/assets/390180ef-0fce-4e19-b23c-f084246bad6b" /> <br>

워크 기본 제공 시스템을 최소한으로 이용하고,

흔히 스탯이라고 불리우는 것들을 싹 다 스크립트로 재정의 하였음

<img width="554" height="662" alt="20" src="https://github.com/user-attachments/assets/452b202d-a1a6-4a22-b52c-a2341631489d" /> <br>

<img width="670" height="534" alt="21" src="https://github.com/user-attachments/assets/f3093ccc-c4ae-4b99-b00e-fc7582d80e11" /> <br>

오브젝트 에디터가 아닌

스크립트 상에서 유닛의 각종 커스텀 스탯들을 조정

공격력 주문력 이속 공속 치확 치피 물방 마방 체력 물리뎀감 마법뎀감 레벨 등등..

이 작업의 효과로는

몬스터 스탯 조절 -> 난이도 조정 가능

이미 완성된 컨탠츠들의 수치조정을 함으로써 재사용성을 높임

그 외에도 엘리트 몬스터 같은 것도 쉽게 만들 수 있음

<br>
<br>
<br>

<img width="745" height="483" alt="22" src="https://github.com/user-attachments/assets/5622b50f-cad6-4cfe-85a5-49e4d40f9a73" /> <br>

워크 기본 방어력 시스템을 안쓰고

커스텀 스탯을 기반으로한 커스텀 데미지 시스템 사용

유저랑 적 몬스터들이 같은 시스템을 공유함

<br>
<br>
<br>


<img width="483" height="36" alt="25" src="https://github.com/user-attachments/assets/1324977c-6ebf-454f-8ea8-6dcd6e292382" /> <br>

커스텀 스탯과 스킬간의 연계 <br> 
기본 시스템에서는 공격속도를 활용할 수 없지만, 스크립트를 통해 커스텀 스탯으로 효과 조절 가능

<br>

<img width="520" height="390" alt="24" src="https://github.com/user-attachments/assets/3ebdd1b8-1b0d-4d32-b8cb-689c847240d7" /> <br>

맘에 드는 템을 조합해서 내가 원하는 스탯을 몰빵해서 개성있는 플레이 가능

위 그림은 공속특화 예시

<img width="520" height="390" alt="26" src="https://github.com/user-attachments/assets/9b8ddf3c-2f1c-4823-9254-bafa02155741" /> <br>

<img width="520" height="390" alt="27" src="https://github.com/user-attachments/assets/56dc90d9-7375-47a9-9064-b23ac4445685" /> <br>

커스텀 스탯 활용 스킬 예시

<br>
<br>
<br>

### 엘리트 몬스터

<img width="900" height="421" alt="28" src="https://github.com/user-attachments/assets/050862b8-a0cf-4927-8285-f86cddd523fd" /> <br>

엘리트 몬스터 시스템

<img width="229" height="75" alt="29" src="https://github.com/user-attachments/assets/02a81867-78c2-40b0-be5f-141edb4fe464" /> <br>

엘리트 몬스터 사이에도 등급이 있음

<img width="702" height="398" alt="30" src="https://github.com/user-attachments/assets/e2c8a643-6bb8-4ee9-8d36-828d3fa0d298" /> <br>

스킬 알려주는 텍스트 태그

<img width="341" height="474" alt="31" src="https://github.com/user-attachments/assets/ecf7c76d-b870-49ef-8f20-b7557c58eab2" /> <br>

엘리트 몬스터들에게 부여될 각종 스킬들

AD_RESISTANCE 같은거 물리뎀감 증가 방어력 증가

ACCEL은 공이속 증가

CRITICAL은 치확 치피 증가

<img width="520" height="390" alt="13" src="https://github.com/user-attachments/assets/d52690c4-07b8-4586-b113-5e18ce817f57" /> <br>

엘리트 몬스터 예시

<br>
<br>
<br>

### 캐릭터 스킬들

<img width="600" height="450" alt="1" src="https://github.com/user-attachments/assets/fbe7f466-52f2-45d0-934d-0d27ff24f826" /> <br>

<br>
<br>
<br>

<img width="600" height="450" alt="2" src="https://github.com/user-attachments/assets/dd14ad85-07df-4928-9381-ff760667fc7b" /> <br>

<br>
<br>
<br>

<img width="600" height="450" alt="3" src="https://github.com/user-attachments/assets/4c526c24-1147-42a1-a533-d618ad1cbe2d" /> <br>

<br>
<br>
<br>

<img width="600" height="450" alt="4" src="https://github.com/user-attachments/assets/a591fea3-f858-4ca0-bedb-32faf7e41c81" /> <br>

<br>
<br>
<br>

<img width="600" height="450" alt="5" src="https://github.com/user-attachments/assets/54657155-8ea7-4d65-a4a1-15883074f8a4" /> <br>

<br>
