unit Actor;

interface

uses
  SkillInfo,Windows, SysUtils, Classes, Graphics, Forms, HUtil32, uTextures, Grobal2, Math,
  CliUtil, magiceff, Wil, ClFunc, uMessageParse, AbstractCanvas, AbstractTextures,
  DXHelper, AsphyreTypes, uCliUITypes, uTypes, uUITypes, uActionsMgr, uLog, Common,MMSystem,Generics.Collections,uSyncObj;

const
  HUMANFRAME          = 600; // hum.wil,,,一种Race所占的图片数
  HUMANFRAME_CIK   = 888;//刺客的图片数量
  HUMANFRAME_WS       = 728; //武僧的图片数量

  HUMCBOANFRAME       = 2000;
  MAXSAY              = 5;
  RUN_MINHEALTH       = 10; // 低于这个血量只能走动
  DEFSPELLFRAME       = 10; // 魔法最大浈
  MAGBUBBLEBASE       = 3890; // 魔法盾效果图位置
  MAGBUBBLESTRUCKBASE = 3900; // 被攻击时魔法盾效果图位置
  MAXWPEFFECTFRAME    = 5;
  WPEFFECTBASE        = 3750;

type
  THealthStatus = record
    btStatus: Byte; //0=MISS 1=ADD 2=DEC
    nValue: Integer;
    dwFrameTime: LongWord;
    nCurrentFrame: Integer;
  end;
  pTHealthStatus = ^THealthStatus;


type
  TBodyEffect = class
  private
    FActive: Boolean;
    FBodyEffKind: Byte;
    FBodyEffLevel: Byte;
    FBodyEffect: Word;
    FInnerEffect: TEffect;
    procedure Clear;
    procedure DoSoundEffect(Sender: TObject; const Sound: String);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Run;
    procedure SetBodyEffect(Value: Integer);
    procedure DrawEffect(DSurface: TAsphyreCanvas; X, Y: Integer);
  end;

  TActor = class
    m_nRecogId: Integer; // 角色标识 0x4
    m_nTag: Integer;
    m_nCurrX: Integer; // 当前所在地图座标X 0x08
    m_nCurrY: Integer; // 当前所在地图座标Y 0x0A
    m_btDir: byte; // 当前站立方向 0x0C
    m_btSex: byte; // 性别 0x0D
    m_btHair: byte; // 头发类型 0x0F
    m_btDress: Word; // 衣服类型 0x10
    m_btWeapon: Word; // 武器类型
    m_nWeaponEffect: Word; //武器特效
    m_TempWeapon: byte; // 武器类型  临时  解决换武器时黑边
    NeedLoad: Boolean; // 需要重新加载吗
    m_btHorse: Word;
    m_wShield: Word; //盾牌
    m_btEffect: Word; // 天使类型
    m_btJob: byte; // 职业 0:武士  1:法师  2:道士
    m_wAppearance: Word; // 0x14 DIV 10=种族（外貌）， Mod 10=外貌图片在图片库中的位置（第几种）
    m_nLoyal: Integer; // 英雄忠诚度
    m_nFeature: Integer; // 0x18
    m_nFeatureEx: Integer; // 0x18
    m_nDressWeapon: Integer;
    private
      m_nState: Integer; //角色状态
    public
    m_boGateMan: Boolean;
    m_boDeath: Boolean; // 0x20
    m_boSkeleton: Boolean; // 0x21
    m_boDelActor: Boolean; // 0x22
    m_boDelActionAfterFinished: Boolean; // 0x23
    m_sDescUserName: String; // 人物名称，后缀
    m_sUserName: String; // 名字
    m_nNameColor: TColor; // 名字颜色
    m_btMiniMapHeroColor: byte; // 英雄小地图名字颜色
    m_Abil: TAbility; // 基本属性
    m_nBatterZhuiXin: TMessageBodyWL;
    m_nHitSpeed: ShortInt; // 攻击速度 0: 扁夯, (-)蠢覆 (+)狐抚
    m_boVisible: Boolean;
    m_boHoldPlace: Boolean;
    m_boShowHealthBar: Boolean;
    m_dwLastGetMessageTime: LongWord;

    m_SayingArr: array [0 .. MAXSAY - 1] of String; // 最近说的话
    m_SayWidthsArr: array [0 .. MAXSAY - 1] of Integer; // 每句话的宽度
    m_SayFrontColor,
    m_SayBackColor : TColor;
    m_dwSayTime: Longword;
    m_nSayX: Integer;
    m_nSayY: Integer;
    m_nSayLineCount: Integer;
    m_sSayNameFix:String;

    m_nShiftX: Integer; // 0x98
    m_nShiftY: Integer; // 0x9C

    // m_nLightX                 :Integer;  //月灵图片坐标 光 2007.12.12
    m_nPx: Integer; // 0xA0
    m_nSdPx: Integer;
    m_nHpx: Integer; // 0xA4
    m_nWpx: Integer; // 0xA8
    m_nWepx: Integer;
    m_nWepy: Integer;
    m_nWpx2: Integer; // 0xA8
    m_nSpx: Integer; // 0xAC

    // m_nLightY                 :Integer;  //月灵图片坐标 光 2007.12.12
    m_nPy: Integer;
    m_nSdPy: Integer;
    m_nHpy: Integer;
    m_nWpy: Integer;
    m_nWpy2: Integer;
    m_nSpy: Integer; // 0xB0 0xB4 0xB8 0xBC
    m_nStallX, m_nStallY: Integer;

    m_nWLPx, m_nWLPy: Integer; //右手特效武器偏移坐标
    m_nWLPx_ef, m_nWLPy_ef: Integer;  //左手武器特效偏移坐标

    m_nRx: Integer;
    m_nRy: Integer; // 0xC0 0xC4
    m_nDownDrawLevel: Integer; // 0xC8
    m_nTargetX: Integer;
    m_nTargetY: Integer; // 0xCC 0xD0
    m_nTargetRecog: Integer; // 0xD4
    m_nHiterCode: Integer; // 0xD8
    m_nMagicNum: Integer; // 0xDC
    m_nCurrentEvent: Integer; // 辑滚狼 捞亥飘 酒捞叼
    m_boDigFragment: Boolean; // 挖矿效果
    m_nBodyOffset: Integer; // 0x0E8   //0x0D0 // 身体图片索引的主偏移
    m_nShadowBodyOffset: Integer; //阴影
    m_boUseMagic: Boolean; // 0x0F8   //0xE0
    m_boUseEffect: Boolean; // 0x0FA    //0xE2
    m_nHitMagic: Integer;
    m_dwWaitMagicRequest: Longword;
    m_dwWaitMagicRequestTime: Longword;
    m_nWaitForRecogId: Integer; // 磊脚捞 荤扼瘤搁 WaitFor狼 actor甫 visible 矫挪促.
    m_nWaitForFeature: Integer;
    m_nWaitForStatus: Integer;
    m_nWaitForProperties: Integer;
    m_nWaitForDressWeapon: Integer;

    m_nCurEffFrame: Integer; // 0x110
    m_nSpellFrame: Integer; // 0x114
    m_CurMagic: TUseMagicInfo;
    m_CurHitMagic: TUseMagicInfo;
    m_nMagicFrame: Integer;

    m_nGenAniCount: Integer; // 0x124
    m_boOpenHealth: Boolean; // 0x140
    m_noInstanceOpenHealth: Boolean; // 0x141
    m_dwOpenHealthStart: Longword;
    m_dwOpenHealthTime: Longword; // Integer;jacky

    // SRc: TRect;  //Screen Rect 拳搁狼 角力谅钎(付快胶 扁霖)
    m_BodySurface,
    m_ShadowBodySurface: TAsphyreLockableTexture; // 0x14C   //0x134

    // m_LightSurface             :TAsphyreLockableTexture;    //0x14C   //0x134

    m_boGrouped: Boolean; // 是否组队
    m_nCurrentAction: Integer; // 0x154         //0x13C
    m_boReverseFrame: Boolean; // 0x158
    m_boWarMode: Boolean; // 0x159
    m_dwWarModeTime: Longword; // 0x15C
    m_nChrLight: Integer; // 0x160
    m_nMagLight: Integer; // 0x164
    m_nRushDir: Integer; // 0, 1
    // m_nXxI                    :Integer; //0x16C   20080521 注释没用到变量
    m_boLockEndFrame: Boolean;
    m_dwSendQueryUserNameTime: Longword;
    m_dwDeleteTime: Longword;

    m_nMagicStruckSound: Integer; // 0x180 被魔法攻击弯腰发出的声音
    m_boRunSound: Boolean; // 0x184 跑步发出的声音
    m_nFootStepSound: Integer; // CM_WALK, CM_RUN //0x188  走步声
    m_nStruckSound: Integer; // SM_STRUCK         //0x18C  弯腰声音
    m_nStruckWeaponSound: Integer; // 0x190  被指定武器攻击弯腰声音

    m_nAppearSound: Integer; // 出现在玩家视野的声音: 0
    m_nNormalSound: Integer; // 怪物平常不攻击的声音: 1
    m_nAttackSound: Integer; // 怪物攻击的喊声 : 2
    m_nWeaponSound: Integer; // 也是怪物攻击的声音 : 3   很少 主要是一些会丢东西的怪物发出时候的声音
    m_nScreamSound: Integer; // 怪物被打的声音 : 4
    m_nDieSound: Integer;  // 怪物被打死的声音 : 5 SM_DEATHNOW
    m_nDie2Sound: Integer; // 山洞蝙蝠死亡的声音

    m_nMagicStartSound: Integer; // 0x1B0
    m_sMagicStartSound: string;
    m_nMagicFireSound: Integer; // 0x1B4
    m_sMagicFireSound: string;
    m_nMagicExplosionSound: Integer; // 0x1B8
    m_sMagicExplosionSound: string;
    m_Action: pTMonsterAction;
    // 英雄召唤或退出 begin
    HeroLoginStartFrame: Integer; // 英雄登陆开始帧
    HeroLoginExplosionFrame: Integer; // 英雄登陆往后播放的帧数
    HeroLoginNextFrameTime: Integer; // 英雄登陆时间间隔
    HeroTime: Longword;
    HeroFrame: Integer;
    g_HeroLoginOrLogOut: Boolean; // 英雄召唤或退出
    // end
    { ****************************************************************************** }
    // 人自身显示动画 begin   2008.01.13
    m_nMyShowStartFrame: Integer; // 自身动画开始帧
    m_nMyShowExplosionFrame: Integer; // 自身动画往后播放的帧数
    m_nMyShowNextFrameTime: Longword; // 自身动画时间间隔
    m_nMyShowTime: Longword; // 当前时间
    m_nMyShowFrame: Integer; // 当前帧
    g_boIsMyShow: Boolean; // 是否显示动画{接到消息为True}
    g_MagicWILBase: TWMImages; // WIL图库
    // g_MagicWISBase             :TWISImages;//WIS图库
    m_boNoChangeIsMyShow: Boolean; // 是否发出的动画坐标不随着人物动作而变化  20080306
    m_nNoChangeX, m_nNoChangeY: Integer; // 不改变动画的坐标X，Y  20080306
    { ****************************************************************************** }
    // g_boIsHero                 :Boolean;

    m_Skill69NH: Word; // 当前内力值 20080930
    m_Skill69MaxNH: Word; // 最大内力值 20080930
    { ****************************************************************************** }
    m_nDefTimeMsg: pTChrMsg;
    m_nTypeShow: Integer;
    { ****************************************************************************** }
    m_HealthList: TGList;
    m_NameText: TuTexture;
    m_OuterEffect: TItemOuterEffect;
    m_WeponOuterEffect: TItemOuterEffect;
    m_boMonNPC,
    m_boFriendly: Boolean;
    m_boInSneak: Boolean;
    m_nSneakFrame: Integer;
    m_nSneakTick: LongWord;
    m_btActionEffect: Byte;
    m_BodyEffect: TBodyEffect;
    m_btStall: Byte;
    //变身后
    m_wChangeToMonsterAppr:Word;
    m_wChangeToMonsterRace:Word;
    m_ChangeToMonsterAct:THumanAction;//变身后的 行动类型
    m_boChangeToMonster:Boolean;
    m_btOrginalRace : SmallInt;
    m_btOrginalAppr : Word;
    m_nGrpCount : Byte; //队伍人数
    m_nShiftCount:Integer; //调试用


    m_boBloodRush:Boolean;
    m_nBloodRushTargetX : Integer;
    m_nBloodRushTargetY: Integer; //快速突进
    m_nBloodRushSpeed:Integer;//突进速度 一格多少毫秒
    m_btBloodRushDir : Byte; //突进的方向
    m_dwBloodRushStart:Cardinal; //突进开始时间
    m_btBloodRushCardinal:Byte; //突进已经突进的坐标数量

    m_btBeCoolFrame:Byte; //冷酷的帧数
    m_dwBeCoolLastTime :Cardinal; //冷酷上次绘制的帧数
    m_nBlendColor : Integer; //身体混合颜色
    m_nWeaponBlendColor : Integer; //武器混合颜色

    //文字称号以及特效
    m_oEffect,
    m_MyEffect: TEffect;
    m_sTitle: String;
    m_TitleEffects:TObjectList<TEffect>;
  private

    function GetMessage(ChrMsg: pTChrMsg): Boolean;
    procedure CalcHairImageOffset;
    procedure DoSoundEffect(Sender: TObject; const Sound: String);
    function GetRealRace() : Byte; {$IFNDEF DEBUG}inline;{$ENDIF}
  protected
    m_btRace: byte; // 怪物种族
    m_nStartFrame:       Integer; // 0x1BC        //0x1A8  // 当前动作的开始帧索引
    m_nEndFrame:         Integer; // 0x1C0      //0x1AC  // 当前动作的结束帧索引
    m_nCurrentFrame:     Integer; // 0x1C4          //0x1B0
    m_nEffectStart:      Integer; // 0x1C8         //0x1B4
    m_nEffectFrame:      Integer; // 0x1CC         //0x1B8
    m_nEffectEnd:        Integer; // 0x1D0       //0x1BC
    m_dwEffectStartTime: Longword; // 0x1D4             //0x1C0
    m_dwEffectFrameTime: Longword; // 0x1D8             //0x1C4
    m_dwFrameTime:       Longword; // 0x1DC       //0x1C8
    m_dwStartTime:       Longword; // 0x1E0       //0x1CC
    m_nCurTick:          Integer; // 0x1E8
    m_nMoveStep:         Integer; // 0x1EC
    m_boMsgMuch:         Boolean; // 0x1F0
    m_dwStruckFrameTime: Longword; // 0x1F4
    m_nCurrentDefFrame:  Integer; // 0x1F8          //0x1E4
    m_dwDefFrameTime:    Longword; // 0x1FC       //0x1E8
    m_nDefFrameCount:    Integer; // 0x200        //0x1EC
    // m_nSkipTick               :Integer;           //20080816注释掉起步负重
    m_dwSmoothMoveTime:  Longword; // 0x208
    m_dwGenAnicountTime: Longword; // 0x20C
    m_dwLoadSurfaceTime: Longword; // 0x210  //0x200

    m_nOldx:       Integer;
    m_nOldy:       Integer;
    m_nOldDir:     Integer; // 0x214 0x218 0x21C
    m_nActBeforeX: Integer;
    m_nActBeforeY: Integer; // 0x220 0x224
    m_nWpord, m_nLWpord: Byte;
    procedure CalcActorFrame; virtual;
    procedure DefaultMotion; virtual;
    procedure DefaultFrameRun;
    function GetDefaultFrame(wmode: Boolean): Integer; virtual;
    procedure DrawEffSurface(dsurface: TAsphyreCanvas; source: TAsphyreLockableTexture; ddx, ddy: Integer; blend: Boolean; ceff: TColorEffect); inline;

    //绘制身体纹理一律使用这个函数进行绘制因为需要使用身体变色
    procedure DrawBodySurface(dsurface: TAsphyreCanvas; source: TAsphyreLockableTexture; ddx, ddy: Integer; blend: Boolean; ceff: TColorEffect); inline;
    //绘制武器纹理一律使用这个因为需要绘制武器变色
    procedure DrawWeaponSurface(dsurface: TAsphyreCanvas; source: TAsphyreLockableTexture; ddx, ddy: Integer; blend: Boolean; ceff: TColorEffect); inline;
  public
    m_MsgList: TFixedThreadList;
    RealActionMsg:     TChrMsg;
    m_nBatterMoveStep: Integer;
    m_nBatterX:        Word;
    m_nBatterY:        Word;
    m_nBatterdir:      byte;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure UpdateTitle(nTitle: Integer);
    procedure UpdateNameTitle(const sTitle: String);
    procedure UpdateTitles(const sTitle: String);
    procedure SendMsg(wIdent: Word; nX, nY, ndir, nFeature, nState, nProperties, nDressweapon: Integer; sStr: String; nSound: Integer; nTarget: Integer = 0; nToken: Integer = 0);
    procedure UpdateMsg(wIdent: Word; nX, nY, ndir, nFeature, nState, nProperties, nDressweapon: Integer; sStr: String; nSound: Integer; nTarget: Integer = 0; nToken: Integer = 0);
    procedure CleanUserMsgs;
    procedure ProcMsg;
    procedure ProcHurryMsg;
    function IsIdle: Boolean; inline;
    function ActionFinished: Boolean; inline;
    function CanWalk: Integer; inline;
    function CanRun: Integer; inline;
    procedure Shift(dir, step, cur, max: Integer);
    procedure ReadyAction(msg: TChrMsg);
    function CharWidth: Integer; inline;
    function CharHeight: Integer; inline;
    function CheckSelect(dx, dy: Integer): Boolean; inline;
    procedure CleanCharMapSetting(x, y: Integer); inline;
    procedure ClearHitMsg;
    function MsgCount: Integer;
    procedure HealthSpellChange(const AHP, AMP, AMaxHP: Integer; const ISDie: Boolean=False); inline;
    procedure DamageHealthHPChange(const AHP, AMaxHP, ADamage: Integer); inline;
    procedure DamageHealthHPChange2(ADamage: Integer); inline;
    procedure MissHealthSpellChange; inline;
    procedure ShowStormEffect;
    procedure SetNextFixedEffect(AKind, AMagicID: Integer; ALevel: Integer = 0);
    procedure AddHealthStatus(btStatus: Byte; nValue: Integer);
    procedure Say(const Message: string;FrontColor,BackColor:TColor);
    procedure SetSound; virtual;
    procedure Run; virtual;
    procedure ProcessDynamicEffect();virtual;
    procedure RunSound;
    procedure RunActSound(frame: Integer); virtual;
    procedure RunFrameAction(frame: Integer); virtual;
    procedure ActionEnded; virtual;
    function Move: Boolean;
    procedure MoveFail; inline;
    procedure MoveStep(dir: byte; x, y, step: Word); inline;
    function CanCancelAction: Boolean; inline;
    procedure CancelAction; inline;
    procedure CancelActionEx; inline;
    procedure FeatureChanged; virtual;
    function Light: Integer; virtual;
    procedure LoadSurface; virtual;
    function GetDrawEffectValue: TColorEffect; inline;
    procedure HeroLoginOrLogOut(dsurface: TAsphyreCanvas; dx, dy: Integer); virtual; // 召唤英雄动画
    procedure DrawMyShow(dsurface: TAsphyreCanvas; dx, dy: Integer); // 通用人自身动画显示 20080113
    procedure DrawSaying(dsurface: TAsphyreCanvas; dx, dy: Integer);
    procedure DrawChr(dsurface: TAsphyreCanvas; dx, dy: Integer; blend: Boolean; boFlag: Boolean); virtual;
    procedure DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer); virtual;
    procedure DrawMagicEffect(DSurface: TAsphyreCanvas; X, Y: Integer); virtual;
    procedure CreateMagicObject; virtual;
    procedure NameTextOut(dsurface: TAsphyreCanvas; dx, dy: Integer); virtual;
    procedure TitleOut(dsurface: TAsphyreCanvas; dx, dy, AniIndex: Integer); virtual;
    procedure DrawBlood(dsurface: TAsphyreCanvas); virtual;
    procedure ShowHealthStatus(dsurface: TAsphyreCanvas; X, Y: Integer);
    function HumFrame():Integer;inline;
    procedure SetBodyEffectProperty(Value: Integer); inline;
    function LeftX: Integer; inline;
    function LeftY: Integer; inline;
    function RightX: Integer; inline;
    function RightY: Integer; inline;
    procedure UpDateQuickRushPostion(dwTick:Cardinal); //更新突进位置偏移
    procedure DrawQuickRushEffect(dsurface: TAsphyreCanvas; dx, dy: Integer); //绘制突进特效
    function HaveStatus(Status:Integer):Boolean;
    procedure SetStatus(Status:Integer);
    function GetCurrentActionFrameIndex():Integer;
    function GetSayX():Integer;
    function GetSayY():Integer;

    procedure AddSkillEffect(Target:TActor;EffectID,X,Y,DelayTime:Integer;FlySpeed:Single;BoAddToScene:Boolean);  //增加一个技能特效
    procedure AddSkillSound(SoundID,DelayTime:Integer);   //增加一个声音特效
    property Race:Byte read GetRealRace write m_btRace; //这里 read 的是原始种族 set 的是 显示种族 因为有变身的情况存在
  end;

  TMonActor = class(TActor)
  public
    procedure CalcActorSpellHitFrame(AMonAction: PTMonsterAction);
    procedure CalcActorFrame; override;
    procedure DrawMagicEffect(DSurface: TAsphyreCanvas; X, Y: Integer); override;
    procedure CreateMagicObject; override;
    procedure DrawChr(dsurface: TAsphyreCanvas; dx, dy: Integer; blend: Boolean; boFlag: Boolean); override;
  end;

  TNpcActor = class(TActor)
  private
    m_nEffX:           Integer; // 0x240
    m_nEffY:           Integer; // 0x244
    m_bo248:           Boolean; // 0x248
    m_dwUseEffectTick: Longword; // 0x24C
    m_EffSurface:      TAsphyreLockableTexture; // 画NPC 魔法动画效果
    // 酒馆2卷老板娘走动  20080621
    m_boNpcWalkEffect:        Boolean; // 是否走动中怪动画效果
    m_boNpcWalkEffectSurface: TAsphyreLockableTexture;
    m_StatuarySurface: TAsphyreLockableTexture;
    m_StatuaryEffectSurface: TAsphyreLockableTexture;
    m_WeaponSurface,
    m_WeaponSurface_L: TAsphyreLockableTexture;
    m_WeaponEffectSurface: TAsphyreLockableTexture;
    m_HumWinSurface: TAsphyreLockableTexture;
    m_HairSurface: TAsphyreLockableTexture;
    m_EffigySurface: TAsphyreLockableTexture;
    m_nNpcWalkEffectPx:       Integer;
    m_nNpcWalkEffectPy:       Integer;
    m_nEffigyState,
    m_nEffigyOffset,
    m_nEffigyX,
    m_nEffigyY: Integer;
    m_boEffigy: Boolean;
  public
    g_boNpcWalk: Boolean; // NPC走动 20080621
    constructor Create; override;
    procedure Run; override;
    procedure CalcActorFrame; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
    procedure LoadSurface; override;
    procedure NameTextOut(dsurface: TAsphyreCanvas; dx, dy: Integer); override;
    procedure DrawChr(dsurface: TAsphyreCanvas; dx, dy: Integer; blend: Boolean; boFlag: Boolean); override;
    procedure DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer); override;
    procedure SetEffigyState(nEffigyProperties, nEffigyFeature, nEffigyFeatureEx, nEffigyOffset: Integer);
    procedure DrawBlood(dsurface: TAsphyreCanvas); override;
  end;

  THumActor = class(TActor)
  private
    m_HairSurface: TAsphyreLockableTexture;
    m_WeaponSurface,
    m_WeaponSurface_L: TAsphyreLockableTexture;
    m_WeaponEffectSurface,
    m_WeaponEffectSurface_L: TAsphyreLockableTexture;
    m_HumWinSurface: TAsphyreLockableTexture;
    m_StallSurface: TAsphyreLockableTexture;
    m_boWeaponEffect: Boolean;
    m_nCurWeaponEffect: Integer;
    m_nCurBubbleStruck: Integer;
    m_nCurProtEctionStruck: Integer;
    m_dwProtEctionStruckTime: Longword;
    m_HorseSurface: TAsphyreLockableTexture;

    m_dwWeaponpEffectTime: Longword;
    m_nFrame:      Integer;
    m_dwFrameTick: Longword;
    m_dwFrameTime: Longword;
    m_nHX,
    m_nHY: Integer;

  protected
    procedure CalcActorFrame; override;
    procedure DefaultMotion; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
  public
    m_btReLevel: byte;
    // m_boMagbubble4  :Boolean; //是否是4级魔法盾状态
    constructor Create; override;
    destructor Destroy; override;
    procedure Run; override;
    procedure RunFrameAction(frame: Integer); override;
    function Light: Integer; override;
    procedure LoadSurface; override;
    procedure DoWeaponBreakEffect;
    procedure NameTextOut(dsurface: TAsphyreCanvas; dx, dy: Integer); override;
    procedure TitleOut(dsurface: TAsphyreCanvas; dx, dy, AniIndex: Integer); override;
    procedure DrawChr(dsurface: TAsphyreCanvas; dx, dy: Integer; blend: Boolean; boFlag: Boolean); override;
    procedure ShowEffect(ID: Integer);
    function CheckMoveTime(ALastMoveTick: LongWord): Boolean;
  end;

function GetRaceByPM(race: Integer; Appr: Word): pTMonsterAction;
function GetHitFrameTime(ADefFrameTime: Integer): Integer;
function GetSpellFrameTime(ADefFrameTime: Integer): Integer;
function GetRunFrameTime(ADefFrameTime: Integer): Integer;
function GetWalkFrameTime(ADefFrameTime: Integer): Integer;

implementation
  uses ClMain, SoundUtil, clEvent, uMagicTypes, uMagicMgr, AsphyreTextureFonts,
  MShare, Share,SkillEffectConfig,uGameData,uClientCustomSetting;

function TransMonActionToHum(MonAct:pTMonsterAction):THumanAction;
var
  nRushLeftFrame:integer;
  nSpellFrame:Integer;//魔法的施法帧数。这里以攻击的一半作为施法动作
begin
    Move(HA,Result,SizeOf(Result));
    if MonAct = nil then Exit;

    Result.ActStand := MonAct.ActStand;
    Result.ActWalk  := MonAct.ActWalk;
    Result.ActRun   := MonAct.ActWalk;

    //野蛮部分
    Result.ActRushLeft := Monact.ActWalk;
    Result.ActRushLeft.start := MonAct.ActWalk.start;
    nRushLeftFrame := MonAct.ActWalk.frame div 2;
    Result.ActRushLeft.frame := nRushLeftFrame;
    Result.ActRushLeft.skip  := (MonAct.ActWalk.frame + MonAct.ActWalk.skip) - nRushLeftFrame;
    Result.ActRushRight := Result.ActRushLeft;

    //攻击部分
    Result.ActHit := MonAct.ActAttack;
    Result.ActHeavyHit := MonAct.ActAttack;
    Result.ActBigHit := MonAct.ActAttack;

    //施法动作的处理
    Result.ActSpell  := MonAct.ActAttack;
    nSpellFrame := MonAct.ActAttack.frame div 2 + 1;
    Result.ActSpell.frame := nSpellFrame;
    Result.ActSpell.skip := (MonAct.ActAttack.frame + MonAct.ActAttack.skip) - nSpellFrame;


    Result.ActSitdown := MonAct.ActStand;
    Result.ActStruck := MonAct.ActStruck;
    Result.ActDie := MonAct.ActDie;
    //Result.ActDeath := MonAct.ActDeath;

    //攻击恢复的停滞
    Result.ActWarMode.start := MonAct.ActAttack.start;
    Result.ActWarMode.frame := 1;
    Result.ActWarMode.skip := (MonAct.ActAttack.skip + MonAct.ActAttack.frame) - Result.ActWarMode.frame;
    Result.ActWarMode.ftime := 200;

    Result.ActCircinate := MonAct.ActAttack;
    Result.ActFireDragon := MonAct.ActAttack;
    Result.ActSpurn := MonAct.ActAttack;
    Result.ActSneak :=  Monact.ActWalk;
    Result.ActShamanHit := MonAct.ActAttack;
    Result.ActShamanPush := MonAct.ActWalk;
end;

constructor TActor.Create;
begin
  inherited Create;
  FillChar(m_Abil, Sizeof(TAbility), 0);
  FillChar(m_Action, Sizeof(m_Action), 0);

  m_boGateMan :=  False;
  m_MsgList := TFixedThreadList.Create;
  m_nRecogId := 0;
  m_nTag := 0;
  m_BodySurface := nil;
  m_ShadowBodySurface :=  nil;
  m_boHoldPlace := TRUE;
  m_nCurrentAction := 0;
  m_boReverseFrame := FALSE;
  m_nShiftX := 0;
  m_nShiftY := 0;
  m_nDownDrawLevel := 0;
  m_nCurrentFrame := -1;
  m_nEffectFrame := -1;
  m_nWeaponEffect :=  0;
  m_nSayX := -9999;
  m_nSayY := -9999;
  m_nDefTimeMsg := nil;
  m_nTypeShow := 0;

  RealActionMsg.Ident := 0;
  m_sUserName := '';
  m_nNameColor := clWhite;
  m_dwSendQueryUserNameTime := 0; // GetTickCount;
  m_boWarMode := FALSE;
  m_dwWarModeTime := 0; // War mode
  m_boDeath := FALSE;
  m_boSkeleton := FALSE;
  m_boDelActor := FALSE;
  m_boDelActionAfterFinished := FALSE;

  m_nChrLight := 0;
  m_nMagLight := 0;
  m_boLockEndFrame := FALSE;
  m_dwSmoothMoveTime := 0; // GetTickCount;
  m_dwGenAnicountTime := 0;
  m_dwDefFrameTime := 0;
  m_dwLoadSurfaceTime := GetTickCount;
  m_boGrouped := FALSE;
  m_boOpenHealth := FALSE;
  m_noInstanceOpenHealth := FALSE;
  m_CurMagic.ServerMagicCode := 0;

  m_nSpellFrame := DEFSPELLFRAME;

  m_nNormalSound := -1;
  m_nFootStepSound := -1; // 绝澜  //林牢傍牢版快, CM_WALK, CM_RUN
  m_nAttackSound := -1;
  m_nWeaponSound := -1;
  m_nStruckSound := s_struck_body_longstick; // 嘎阑锭 唱绰 家府    SM_STRUCK
  m_nStruckWeaponSound := -1;
  m_nScreamSound := -1;
  m_nDieSound := -1; // 绝澜    //磷阑锭 唱绰 家府    SM_DEATHNOW
  m_nDie2Sound := -1;

  m_Skill69NH := 0; // 当前内力值 20080930
  m_Skill69MaxNH := 0; // 最大内力值 20080930
  m_HealthList  :=  TGList.Create;
  m_NameText  :=  nil;
  m_OuterEffect := nil;
  m_WeponOuterEffect := nil;
  m_boMonNPC := False;
  m_boFriendly := False;
  m_boVisible := False;
  m_boInSneak := False;
  m_nSneakFrame := 0;
  m_nSneakTick := 0;
  m_btActionEffect := 0;
  m_nHitMagic := -1;
  m_CurHitMagic.nMagicId := -1;
  m_dwLastGetMessageTime := GetTickCount;
  m_BodyEffect := TBodyEffect.Create;
  m_btOrginalRace := -1;
end;

function GetCustomMonsterAction(race: Integer; Appr: Word): pTMonsterAction;
begin
  if Race = 50 then
  begin
    if g_CustomNPCAction[Appr] <> nil then
      Result := @g_CustomNPCAction[Appr].MonsterAction;
  end else
  begin
    if g_CustomMonsterAction[Appr] <> nil then
      Result := @g_CustomMonsterAction[Appr].MonsterAction;
  end;

  if Result = nil then
    Result := @MA9;

end;

function GetRaceByPM(race: Integer; Appr: Word): pTMonsterAction;
begin

  Result := nil;
  if (Appr >= CUSTOM_ACTOR_ACTION_APPR_BASE) and (Appr <= CUSTOM_ACTOR_ACTION_APPR_MAX) then
  begin
    Result := GetCustomMonsterAction(race,Appr);
    Exit;
  end;

  case race of
    9 { 01 } :
      Result := @MA9; // 未知
    10 { 02 } :
      Result := @MA10; // 未知
    11 { 03 } :
      Result := @MA11; // 鸡和鹿
    12 { 04 } :
      Result := @MA12; // 大刀卫士
    13 { 05 } :
      Result := @MA13; // 食人花
    14 { 06 } :
      Result := @MA14; // 骷髅系列怪
    15 { 07 } :
      Result := @MA15; // 掷斧骷髅
    16 { 08 } :
      Result := @MA16; // 洞蛆
    17 { 06 } :
      Result := @MA14; // 多钩猫
    18 { 06 } :
      Result := @MA14; // 稻草人
    19 { 0A } :
    begin
      case Appr of
        281:  Result  :=  @MA112;
        else
          Result := @MA19; // 半兽人、蛤蟆、毒蜘蛛之类的
      end;
    end;
    20 { 0A } :
      Result := @MA19; // 火焰沃玛
    21 { 0A } :
      Result := @MA19; // 沃玛教主
    22 { 07 } :
      Result := @MA15; // 暗黑战士、暴牙蜘蛛
    23 { 06 } :
      Result := @MA14; // 变异骷髅
    24 { 04 } :
      Result := @MA12; // 带刀护卫
    30 { 09 } :
      Result := @MA17; // 未知
    31 { 09 } :
      Result := @MA17; // 蜜蜂
    32 { 0F } :
      Result := @MA24; // 蝎子
    33 { 10 } :
      Result := @MA25; // 触龙神
    34 { 11 } :
      Result := @MA30; // 赤月恶魔、宝箱、千年树妖
    35 { 12 } :
      Result := @MA31; // 未知
    36 { 13 } :
      Result := @MA32; // 475E48
    37 { 0A } :
      Result := @MA19; // 475DDC
    40 { 0A } :
      Result := @MA19; // 475DDC
    41 { 0B } :
      Result := @MA20; // 475DE8
    42 { 0B } :
      Result := @MA20; // 475DE8
    43 { 0C } :
      Result := @MA21; // 475DF4
    45 { 0A } :
      Result := @MA19; // 475DDC
    47 { 0D } :
      Result := @MA22; // 祖玛雕像
    48 { 0E } :
      Result := @MA23; // 475E0C
    49 { 0E } :
      Result := @MA23; // 祖玛教主
    50 { 27 } :
      begin // NPC
        case Appr of
          23: Result := @MA36;
          24: Result := @MA37;
          25: Result := @MA37;
          27: Result := @MA37;
          32: Result := @MA37;
          35: Result := @MA41;
          36: Result := @MA41;
          37: Result := @MA41;
          38: Result := @MA41;
          39: Result := @MA41;
          40: Result := @MA41;
          41: Result := @MA41;
          42: Result := @MA46;
          43: Result := @MA46;
          44: Result := @MA46;
          45: Result := @MA46;
          46: Result := @MA46;
          47: Result := @MA46;
          48: Result := @MA41;
          49: Result := @MA41;
          50: Result := @MA41;
          52: Result := @MA41;
          53: Result := @MA41;
          54..61, 62: Result := @MA70;
          63: Result := @MA70; // 卧龙里的空宝箱NPC  20080301
          64 .. 69: Result := @MA70; // 卧龙NPC
          78: Result := @MA35; // 酒神弟子 20081024
          79: Result := @MA70; // 灯笼
          72 .. 74: Result := @MA71; // 酒馆3个人物NPC 20080308
          81..85: Result := @MA50; // 雪域
          86: Result := @MA51; // 雪域
          87: Result  :=  @MA51; //火炉
          91: Result := @MA61; // 圣诞树,新年树
          92: Result := @MA63; // 圣诞老人
          93..95,129,130: Result := @MA51;
          //67: Result  :=  @MA70;
          //90 .. 92: Result := @MA70; // 卧龙里的空宝箱NPC  20080301

          104..106: Result  :=  @MA41;
          108: Result  :=  @MA51;
          110: Result  :=  @MA41;
          111: Result  :=  @MA111;
          112..126: Result  :=  @MA51;
        else
          Result := @MA35;
        end;
      end;

    52 { 0A } :
      Result := @MA19; // 475DDC
    53 { 0A } :
      Result := @MA19; // 475DDC
    54 { 14 } :
      Result := @MA28; // 475E54
    55 { 15 } :
      Result := @MA29; // 475E60
    60 { 16 } :
      Result := @MA33; // 475E6C
    61 { 16 } :
      Result := @MA33; // 475E6C
    62 { 16 } :
      Result := @MA33; // 475E6C
    63 { 17 } :
      Result := @MA34; // 475E78
    64 { 18 } :
      Result := @MA19; // 475E84
    65 { 18 } :
      Result := @MA19; // 475E84
    66 { 18 } :
      Result := @MA19; // 475E84
    67 { 18 } :
      Result := @MA19; // 475E84
    68 { 18 } :
      Result := @MA19; // 475E84
    69 { 18 } :
      Result := @MA19; // 475E84
    70 { 19 } :
      Result := @MA33; // 475E90
    71 { 19 } :
      Result := @MA33; // 475E90
    72 { 19 } :
      Result := @MA33; // 475E90
    73 { 1A } :
      Result := @MA19; // 475E9C
    74 { 1B } :
      Result := @MA19; // 475EA8
    75 { 1C } :
      Result := @MA39; // 475EB4
    76 { 1D } :
      Result := @MA38; // 475EC0
    77 { 1E } :
      Result := @MA39; // 475ECC
    78 { 1F } :
      Result := @MA40; // 475ED8
    79 { 20 } :
      Result := @MA19; // 475EE4
    80 { 21 } :
      Result := @MA42; // 475EF0
    81 { 22 } :
      Result := @MA43; // 475EFC
    83 { 23 } :
      Result := @MA44; // 火龙教主  20080305
    84 { 24 } :
      Result := @MA45; // 475F14
    85 { 24 } :
      Result := @MA45; // 475F14
    86 { 24 } :
      Result := @MA45; // 475F14
    87 { 24 } :
      Result := @MA45; // 475F14
    88 { 24 } :
      Result := @MA45; // 475F14
    89 { 24 } :
      Result := @MA45; // 475F14
    90 { 11 } :
      Result := @MA30; // 475E30
    98 { 25 } :
      Result := @MA27; // 475F20
    99 { 26 } :
      Result := @MA26; // 475F29
    91 { 27 } :
      Result := @MA49;
    92:
      Result := @MA19; // 金杖蜘蛛
    93:
      Result := @MA93; // 雷炎蛛王
    94:
      Result := @MA94; // 雪域寒冰魔、雪域灭天魔、雪域五毒魔
    95:
      Result := @MA95; // 火龙守护兽
    96:
      Result := @MA19;
    97:
      Result := @MA19;
    100 { 28 } :
      Result := @MA19; // 月灵
  end
end;

function GetHitFrameTime(ADefFrameTime: Integer): Integer;
begin
  Result := Min(Round(ADefFrameTime * g_HitTimeRate), ADefFrameTime);
end;

function GetSpellFrameTime(ADefFrameTime: Integer): Integer;
begin
  Result := Min(Round(ADefFrameTime * g_SpellTimeRate), ADefFrameTime);
end;

function GetRunFrameTime(ADefFrameTime: Integer): Integer;
begin
  Result := Min(Round(ADefFrameTime * g_RunTimeRate), ADefFrameTime);
end;

function GetWalkFrameTime(ADefFrameTime: Integer): Integer;
begin
  Result := Min(Round(ADefFrameTime * g_WalkTimeRate), ADefFrameTime);
end;

destructor TActor.Destroy;
var
  I: Integer;
  AList: TList;
begin
  AList := m_MsgList.LockList;
  try
    for I := 0 to AList.Count - 1 do
    begin
      if pTChrMsg(AList.Items[I]) <> nil then
        Dispose(pTChrMsg(AList.Items[I]));
    end;
  finally
    m_MsgList.UnlockList;
  end;
  FreeAndNilEx(m_MsgList);
  for I := 0 to m_HealthList.Count - 1 do
    Dispose(pTHealthStatus(m_HealthList.Items[I]));
  FreeAndNilEx(m_HealthList);
  FreeAndNilEx(m_BodyEffect);
  if m_oEffect <> nil then
    m_oEffect.Free;
  if m_MyEffect <> nil then
    m_MyEffect.Free;

  if m_TitleEffects <> nil then
    m_TitleEffects.Free;
  inherited Destroy;
end;

procedure TActor.UpdateTitle(nTitle: Integer);
begin

  if (m_oEffect <> nil) then
  begin
    if (m_oEffect.EffectID = nTitle) then
      Exit
    else
      FreeAndNilEx(m_oEffect);
  end;

  m_oEffect :=  UIWindowManager.CreateEffect(nTitle);
  if m_oEffect <> nil then
  begin
    m_oEffect.OnSoundEvent :=  DoSoundEffect;
    m_oEffect.Initializa;
  end;
end;

procedure TActor.UpdateTitles(const sTitle: String);
var
  Effect : TEffect;
  L:TStringList;
  nTitle , I : Integer;
begin
  L := TStringList.Create;
  try
    ExtractStrings([';'],[' ',#9],PChar(sTitle),L);
    if m_TitleEffects <> nil then
      m_TitleEffects.Free;

    m_TitleEffects := TObjectList<TEffect>.Create;

    for I := 0  to L.Count - 1 do
    begin
      nTitle := StrToIntDef(Trim(L[i]),-1);
      if nTitle <> -1 then
      begin
        Effect := UIWindowManager.CreateEffect(nTitle);
        m_TitleEffects.Add(Effect);
        Effect.OnSoundEvent :=  DoSoundEffect;
        Effect.Initializa;
      end;
    end;
  finally
    L.Free;
  end;

end;

// 角色接收到的消息
procedure TActor.SendMsg(wIdent: Word; nX, nY, ndir, nFeature, nState, nProperties, nDressweapon: Integer; sStr: String; nSound, nTarget, nToken: Integer);
var
  msg: pTChrMsg;
begin
  if (m_nCurrentAction = SM_BATTERBACKSTEP) and (wIdent <> SM_BATTERBACKSTEP) and (Self <> g_MySelf) then
    Exit;
  if (wIdent = SM_BATTERBACKSTEP) and (Self <> g_MySelf) then
  begin
    CleanUserMsgs;
    if (m_nCurrentAction <> SM_BATTERBACKSTEP) and (m_nCurrentAction <> 0) then
      CancelActionEx;
  end;

  New(msg);
  msg.Ident := wIdent;
  msg.x := nX;
  msg.y := nY;
  msg.dir := ndir;
  msg.feature := nFeature;
  msg.dressWeapon := nDressweapon;
  msg.state := nState;
  msg.properties := nProperties;
  msg.saying := sStr;
  msg.Sound := nSound;
  msg.target := nTarget;
  msg.token := nToken;
//    if (wIdent = SM_DUANYUEHIT) or (wIdent = CM_DUANYUEHIT) then   todo
//    begin
//      SetNextFixedEffect(18);
//      m_nDefTimeMsg := msg;
//    end
//    else
  m_MsgList.Add(msg);
end;

// 用新消息更新（若已经存在）消息列表
procedure TActor.UpdateMsg(wIdent: Word; nX, nY, ndir, nFeature, nState, nProperties, nDressweapon: Integer; sStr: String; nSound, nTarget, nToken: Integer);
var
  I: Integer;
  AMsg: pTChrMsg;
  AList: TList;
begin
  AList := m_MsgList.LockList;
  try
    for I := AList.Count - 1 downto 0 do
    begin
      AMsg := AList[I];
      if ((Self = g_MySelf) and (AMsg.Ident >= 3000) and (AMsg.Ident <= 3099)) or (AMsg.Ident = wIdent) then
      begin
        Dispose(AMsg);
        AList.Delete(I);
      end;
    end;
  finally
    m_MsgList.UnlockList;
  end;
  SendMsg(wIdent, nX, nY, ndir, nFeature, nState, nProperties, nDressweapon, sStr, nSound, nTarget, nToken);
end;

procedure TActor.UpdateNameTitle(const sTitle: String);
begin
  m_sTitle  :=  sTitle;
end;

procedure TActor.UpDateQuickRushPostion(dwTick:Cardinal);
var
  dwEspTime : Cardinal; //从现在开始的突进了的时间
  dbRatio : Double; //突进系数
  nX,nY : Integer;
begin
  if m_boBloodRush then
  begin

    dwEspTime := dwTick - m_dwBloodRushStart;

    //突进时间 / 突进速度 得到 突进格子的个数比
    dbRatio := dwEspTime / m_nBloodRushSpeed;

    GetDirXYSymbol(m_btBloodRushDir,nX,nY);
        //根据方向 计算ShiftX ShiftY
    m_nShiftX := Trunc(dbRatio * UNITX) * nX;
    m_nShiftY := Trunc(dbRatio * UNITY) * nY;

    if dbRatio >= 1 then
    begin
      GetNextPosXY(m_btBloodRushDir,m_nCurrX,m_nCurrY);
      m_nRx := m_nCurrX;
      m_nRy := m_nCurrY;
      m_dwBloodRushStart := GetTickCount;
      m_nShiftX := 0;
      m_nShiftY := 0;
      Inc(m_btBloodRushCardinal); //增加突进坐标格子
    end;

    if (m_nCurrX =  m_nBloodRushTargetX)  and  (m_nCurrY = m_nBloodRushTargetY) then
    begin
      m_nShiftX := 0;
      m_nShiftY := 0;
      m_boBloodRush := False;
    end;

  end;
end;

// 清除消息号在[3000,3099]之间的消息
procedure TActor.CleanUserMsgs;
var
  I:   Integer;
  msg: pTChrMsg;
  AList: TList;
begin
  AList := m_MsgList.LockList;
  try
    for I := AList.Count - 1 downto 0 do
    begin
      msg := AList[I];
      if (msg.Ident > 2999) and (msg.Ident < 3100){ and (msg.Ident <> CM_SANJUEHIT) and (msg.Ident <> CM_ZHUIXINHIT) and (msg.Ident <> CM_DUANYUEHIT) and (msg.Ident <> CM_HENGSAOHIT) todo} then
        AList.Delete(I);
    end;
  finally
    m_MsgList.UnlockList;
  end;
end;

procedure TMonActor.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  inherited;
  if m_nCurrentAction = SM_SPELL then
  begin
    pm := GetRaceByPM(m_btRace, m_wAppearance);
    CalcActorSpellHitFrame(pm);
  end;
end;

procedure TMonActor.DrawMagicEffect(DSurface: TAsphyreCanvas; X, Y: Integer);
var
  AIndex, AOX, AOY: Integer;
  AImages: TWMImages;
  ATexture: TAsphyreLockableTexture;
  AProperties: TuCustomMagicEffectProperties;
begin
  // 显示魔法效果
  if m_boUseMagic and (m_CurMagic.EffectNumber > 0) then
  begin
    if m_nMagicFrame in [0 .. m_nSpellFrame - 1] then
    begin
      AImages := nil;
      if g_MagicMgr.TryGet(m_CurMagic.nMagicId, m_CurMagic.Strengthen, AProperties) then
      begin
        AImages := TuMagicEffects(AProperties.Start).Images;
        case AProperties.Start.Directivity of
          dtNone: AIndex := AProperties.Start.StartIndex + m_nMagicFrame;
          dtDirection8,
          dtDirection16: AIndex := AProperties.Start.StartIndex + m_btDir * AProperties.Start.Count + m_nMagicFrame;
        end;
      end
      else
      begin
        GetEffectBase(m_CurMagic.EffectNumber, m_CurMagic.Strengthen, m_CurMagic.Tag, 0, AImages, AIndex); // 取得魔法效果所在图库
        case m_CurMagic.EffectNumber of
          162, 163: AIndex := AIndex + m_btDir * 10 + m_nMagicFrame;
          166: AIndex := AIndex + m_btDir * 20 + m_nMagicFrame;
          else
            AIndex := AIndex + m_nMagicFrame;
        end;
      end;
      if AImages <> nil then
      begin
        ATexture := AImages.GetCachedImage(AIndex, AOX, AOY);
        if ATexture <> nil then
          DSurface.DrawBlend(X + AOX + m_nShiftX, Y + AOY + m_nShiftY, ATexture, 1);
      end;
    end;
  end;
end;

procedure TMonActor.CreateMagicObject;
var
  APlaySound: Boolean;
  AProperties: TuCustomMagicEffectProperties;
begin
  if m_boUseMagic then
  begin
    if m_CurMagic.ServerMagicCode > 0 then
    begin
      if m_nMagicFrame = m_nSpellFrame - 1 then
      begin
        if g_MagicMgr.TryGet(m_CurMagic.nMagicId, m_CurMagic.Strengthen, AProperties) then
        begin
          if (TuMagicEffects(AProperties.Run).Images <> nil) or (TuMagicEffects(AProperties.Hit).Images <> nil) then
          begin
            with m_CurMagic do
              PlayScene.NewMagic(Self, AProperties, ServerMagicCode, m_nCurrX, m_nCurrY, TargX, TargY, Target, Recusion, AniTime, APlaySound);
            if (m_nMagicFireSound > -1) and (StrToIntDef(AProperties.Run.Sound, -1) = m_nMagicFireSound) then
              g_SoundManager.DXPlaySound(m_nMagicFireSound);
          end;
        end
        else if m_CurMagic.ServerMagicCode > 0 then
        begin
          with m_CurMagic do
            PlayScene.NewMagic(Self, ServerMagicCode, EffectNumber, m_CurMagic.Strengthen, m_CurMagic.Tag, m_nCurrX, m_nCurrY, TargX, TargY, Target, EffectType, Recusion, AniTime, APlaySound);
          if APlaySound then
            g_SoundManager.DXPlaySound(m_nMagicFireSound)
          else
          begin
            if m_CurMagic.EffectNumber = 51 then // 漫天火雨声音 20080511
              g_SoundManager.MyPlaySound('wav\M58-3.wav')
            else
              g_SoundManager.DXPlaySound(m_nMagicExplosionSound);
          end;
        end;
        m_CurMagic.ServerMagicCode := 0;
        m_boUseMagic := False;
      end;
    end;
  end;
end;

procedure TMonActor.CalcActorSpellHitFrame(AMonAction: PTMonsterAction);
var
  AProperties: TuCustomMagicEffectProperties;
begin
  if AMonAction = nil then Exit;

  m_nStartFrame := AMonAction.ActAttack.start + m_btDir * (AMonAction.ActAttack.frame + AMonAction.ActAttack.skip);
  m_nEndFrame := m_nStartFrame + AMonAction.ActAttack.frame - 1;
  m_dwFrameTime := AMonAction.ActAttack.ftime;
  m_dwStartTime := GetTickCount;
  m_dwWarModeTime := GetTickCount;
  m_boWarMode := TRUE;
  m_boUseMagic := TRUE;
  Shift(m_btDir, 0, 0, 1);
  m_nMagicFrame := -1;
  if g_MagicMgr.TryGet(m_CurMagic.nMagicId, m_CurMagic.Strengthen, AProperties) then
    m_nSpellFrame := AProperties.Start.Count - AProperties.Start.Skip
  else
  begin
    case m_CurMagic.EffectNumber of
      60: m_nSpellFrame := 2;
      26, 43: m_nSpellFrame := 20;
      52: m_nSpellFrame := 9;
      66: m_nSpellFrame := 16;
      100, 101: m_nSpellFrame := 6;
      163: m_nSpellFrame := 8;
    else
      m_nSpellFrame := DEFSPELLFRAME;
    end;
  end;
  m_dwWaitMagicRequest := GetTickCount;
  m_dwWaitMagicRequestTime := m_nSpellFrame * m_dwFrameTime;
end;

// 角色动作动画
procedure TActor.CalcActorFrame;
begin
  m_boUseMagic := FALSE;
  m_nHitMagic := -1;
  m_nCurrentFrame := -1;
  // 根据appr计算本角色在图片库中的开始图片索引
  m_nBodyOffset := GetOffset(m_wAppearance);
  m_nShadowBodyOffset :=  GetShadowOffset(m_wAppearance);
  // 动作对应的图片序列定义
  m_Action := GetRaceByPM(m_btRace, m_wAppearance);
  if m_Action = nil then
    Exit;

  case m_nCurrentAction of
    SM_TURN: // 转身=站立动作的开始帧 + 方向 X 站立动作的图片数
      begin
        m_nStartFrame := m_Action.ActStand.start + m_btDir * (m_Action.ActStand.frame + m_Action.ActStand.skip);
        m_nEndFrame := m_nStartFrame + m_Action.ActStand.frame - 1;
        m_dwFrameTime := m_Action.ActStand.ftime;
        m_dwStartTime := GetTickCount;
        m_nDefFrameCount := m_Action.ActStand.frame;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_WALK { 走 } , SM_RUSH, SM_RUSHKUNG, SM_BACKSTEP, SM_BATTERBACKSTEP { 连击快速后退 } : // 走动=走动动作的开始帧 + 方向 X 每方向走动动作的图片数
      begin
        m_nStartFrame := m_Action.ActWalk.start + m_btDir * (m_Action.ActWalk.frame + m_Action.ActWalk.skip);
        m_nEndFrame := m_nStartFrame + m_Action.ActWalk.frame - 1;
        m_dwFrameTime := GetWalkFrameTime(m_Action.ActWalk.ftime);
        m_dwStartTime := GetTickCount;
        m_nCurTick := 0;
        m_nMoveStep := 1;
        if m_nCurrentAction = SM_BATTERBACKSTEP then
        begin
          m_nMoveStep := m_nBatterMoveStep;
          m_nCurrX := m_nBatterX;
          m_nCurrY := m_nBatterY;
        end;
        if m_nCurrentAction = SM_BACKSTEP then // 转身
          Shift(GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1)
        else
          Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    SM_SNEAK:
      begin
        m_nStartFrame := HA.ActSneak.start + m_btDir * (HA.ActSneak.frame + HA.ActSneak.skip);
        m_nEndFrame := m_nStartFrame + HA.ActSneak.frame - 1;
        m_dwFrameTime := HA.ActSneak.ftime;
        m_dwStartTime := GetTickCount;
        m_nCurTick := 0;
        m_nMoveStep := 1;
        if m_nCurrentAction = SM_BACKSTEP then // 转身
          Shift(GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1)
        else
          Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    { SM_BACKSTEP:
      begin
      startframe := pm.ActWalk.start + (pm.ActWalk.frame - 1) + Dir * (pm.ActWalk.frame + pm.ActWalk.skip);
      m_nEndFrame := startframe - (pm.ActWalk.frame - 1);
      m_dwFrameTime := pm.ActWalk.ftime;
      m_dwStartTime := GetTickCount;
      m_nCurTick := 0;
      m_nMoveStep := 1;
      Shift (GetBack(Dir), m_nMoveStep, 0, m_nEndFrame-startframe+1);
      end; }
    SM_HIT { 普通攻击 }:
      begin
        m_nStartFrame := m_Action.ActAttack.start + m_btDir * (m_Action.ActAttack.frame + m_Action.ActAttack.skip);
        m_nEndFrame := m_nStartFrame + m_Action.ActAttack.frame - 1;
        m_dwFrameTime := m_Action.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        // WarMode := TRUE;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_STRUCK: { 受攻击 }
      begin
        m_nStartFrame := m_Action.ActStruck.start + m_btDir * (m_Action.ActStruck.frame + m_Action.ActStruck.skip);
        m_nEndFrame := m_nStartFrame + m_Action.ActStruck.frame - 1;
        m_dwFrameTime := m_dwStruckFrameTime; // pm.ActStruck.ftime;
        m_dwStartTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_DEATH: // 被打死
      begin
        m_nStartFrame := m_Action.ActDie.start + m_btDir * (m_Action.ActDie.frame + m_Action.ActDie.skip);
        m_nEndFrame := m_nStartFrame + m_Action.ActDie.frame - 1;
        m_nStartFrame := m_nEndFrame; //
        m_dwFrameTime := m_Action.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_NOWDEATH: // 死了
      begin
        m_nStartFrame := m_Action.ActDie.start + m_btDir * (m_Action.ActDie.frame + m_Action.ActDie.skip);
        m_nEndFrame := m_nStartFrame + m_Action.ActDie.frame - 1;
        m_dwFrameTime := m_Action.ActDie.ftime;
        m_dwStartTime := GetTickCount;
        if m_btRace <> 22 then
          m_boUseEffect := TRUE;
      end;
    SM_SKELETON: // 彻底死了（不再动作）
      begin
        m_nStartFrame := m_Action.ActDeath.start + m_btDir;
        m_nEndFrame := m_nStartFrame + m_Action.ActDeath.frame - 1;
        m_dwFrameTime := m_Action.ActDeath.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_ALIVE:
      begin
        m_nStartFrame := m_Action.ActDeath.start + m_btDir * (m_Action.ActDeath.frame + m_Action.ActDeath.skip);
        m_nEndFrame := m_nStartFrame + m_Action.ActDeath.frame - 1;
        m_dwFrameTime := m_Action.ActDeath.ftime;
        m_dwStartTime := GetTickCount;
      end;
  end;
end;

procedure TActor.CalcHairImageOffset;
begin
end;

procedure TActor.DoSoundEffect(Sender: TObject; const Sound: String);
begin
  g_SoundManager.PlaySoundEx(Sound);
end;

procedure TActor.ReadyAction(msg: TChrMsg);
var
  n: Integer;
  UseMagic: PTUseMagicInfo;
begin
  m_nActBeforeX := m_nCurrX; // 动作之前的位置（当服务器不认可时可以回去)
  m_nActBeforeY := m_nCurrY;
  if msg.properties > 0 then
  begin
    m_btJob := LoByte(LoWord(msg.properties));
    m_btHorse := HiWord(msg.properties);
  end;
  if msg.Ident = SM_ALIVE then
  begin // 复活
    m_boDeath := FALSE;
    m_boSkeleton := FALSE;
  end;

  if not m_boDeath then
  begin
    case msg.Ident of
      SM_TURN, SM_WALK, SM_SNEAK, SM_NPCWALK, SM_BACKSTEP, SM_RUSH, SM_RUSHKUNG, SM_RUN, SM_BATTERBACKSTEP,  SM_HORSERUN, SM_DIGUP, SM_ALIVE:
        begin
          m_nFeature := msg.feature;
          m_nDressWeapon := msg.dressWeapon;
          m_nState := msg.state;
          // 是否可以查看角色生命值
          if HaveStatus(STATE_OPENHEATH) then
            m_boOpenHealth := TRUE
          else
            m_boOpenHealth := FALSE;
        end;
    end;
    if msg.Ident = SM_LIGHTING then
      n := 0;
    if (g_MySelf = Self) then
    begin
      case msg.Ident of
        CM_WALK, CM_SNEAK:
        begin
          if not PlayScene.CanWalk(msg.x, msg.y) then
            Exit; //不可行走
        end;
        CM_RUN, CM_HORSERUN:
        begin
          if not PlayScene.CanRun (g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, msg.x, msg.y) then
            Exit; //不能跑
        end;
      end;

      // msg
      m_nHitMagic := -1;
      case msg.Ident of
        CM_HIT, CM_HEAVYHIT:
          begin
            RealActionMsg := msg;
            msg.Ident := msg.Ident - 3000;
          end;
        CM_TURN, CM_WALK, CM_SITDOWN, CM_RUN:
          begin
            RealActionMsg := msg;
            msg.Ident := msg.Ident - 3000;
          end;
        CM_SNEAK:
          begin
            RealActionMsg := msg;
            msg.Ident := SM_SNEAK;
          end;
        CM_HORSERUN:
        begin
          RealActionMsg:=msg;
          msg.Ident:=SM_HORSERUN;
        end;
        CM_THROW:
          begin
            if m_nFeature <> 0 then
            begin
              m_nTargetX := TActor(msg.feature).m_nCurrX; // x 带瘤绰 格钎
              m_nTargetY := TActor(msg.feature).m_nCurrY; // y
              m_nTargetRecog := TActor(msg.feature).m_nRecogId;
            end;
            RealActionMsg := msg;
            msg.Ident := SM_THROW;
          end;
        CM_3037:
          begin
            RealActionMsg := msg;
            msg.Ident := SM_41;
          end;
        CM_SPELL:
          begin
            RealActionMsg := msg;
            //使用特效结构体
            if msg.feature <> 0  then
            begin
              UseMagic := PTUseMagicInfo(msg.feature);
              RealActionMsg.dir := UseMagic.nMagicId;
            end;
            msg.Ident := msg.Ident - 3000; // SM_?? 栏肺 函券 窃
          end;
      end;
      m_nOldx := m_nCurrX;
      m_nOldy := m_nCurrY;
      m_nOldDir := m_btDir;
    end;

    case msg.Ident of
      SM_STRUCK:
        begin
          // Abil.HP := msg.x; {HP}
          // Abil.MaxHP := msg.y; {maxHP}
          // msg.dir {damage}
          m_nMagicStruckSound := msg.x;
          n := Round(200 - m_Abil.Level * 5);
          if n > 80 then
            m_dwStruckFrameTime := n
          else
            m_dwStruckFrameTime := 80;
          m_nHitMagic := -1;
        end;
      SM_HIT, SM_HEAVYHIT:
        begin
          m_nHitMagic := msg.State;
          if m_nHitMagic > -1 then
          begin
            m_CurHitMagic.ServerMagicCode := 0;
            m_CurHitMagic.nMagicId := m_nHitMagic;
            m_CurHitMagic.TargX := LoWord(msg.Y);
            m_CurHitMagic.TargY := HiWord(msg.Y);
            m_CurHitMagic.Target := Msg.target;
            m_CurHitMagic.EffectType := TMagicType(LoByte(LoWord(Msg.token)));
            m_CurHitMagic.EffectNumber := HiByte(LoWord(Msg.token));
            m_CurHitMagic.Strengthen := HiWord(Msg.token);
          end;
          m_nCurrX := LoWord(msg.x);
          m_nCurrY := HiWord(msg.x);//msg.y;
          m_btDir := msg.dir;
        end;
      SM_SPELL:
        begin
          m_btDir := msg.dir;
          UseMagic := PTUseMagicInfo(msg.feature);
          if UseMagic <> nil then
          begin
            m_CurMagic := UseMagic^;
            m_CurMagic.ServerMagicCode := -1;
            m_CurMagic.TargX := msg.x;
            m_CurMagic.TargY := msg.y;
            Dispose(UseMagic);
          end;
        end;
      SM_RUSHKUNG:
        begin // 20080409  防止英雄用野蛮消失
          m_nFeature := msg.feature;
          m_nDressWeapon := msg.dressWeapon;
          m_nState := msg.state;
          // 是否可以查看角色生命值
          if HaveStatus(STATE_OPENHEATH) then
            m_boOpenHealth := TRUE
          else
            m_boOpenHealth := FALSE;
        end;
      SM_BLOODRUSHHIT:
        begin

        end;
      SM_BloodRush:
      begin
       //突进的起始 X Y
        m_nCurrX := msg.x;
        m_nCurrY := msg.y;
        m_nBloodRushTargetX := LoWord(msg.feature);
        m_nBloodRushTargetY := HiWord(msg.feature);
        m_btBloodRushDir := GetFlyDirection(msg.x, msg.y,m_nBloodRushTargetX,m_nBloodRushTargetY);
        m_btBloodRushCardinal := 0;
      end
    else
      begin // 此句是用技能失败 人物跑到消息坐标去  20080409
        m_nCurrX := msg.x;
        m_nCurrY := msg.y;
        m_btDir := msg.dir;
      end;
    end;

    m_nCurrentAction := msg.Ident;
    CalcActorFrame;
    // DScreen.AddSysMsg (IntToStr(msg.Ident) + ' ' + IntToStr(XX) + ' ' + IntToStr(YY) + ' : ' + IntToStr(msg.x) + ' ' + IntToStr(msg.y));
  end
  else
  begin
    if msg.Ident = SM_SKELETON then
    begin
      m_nCurrentAction := msg.Ident;
      CalcActorFrame;
      m_boSkeleton := TRUE;
    end;
  end;
  if (msg.Ident = SM_DEATH) or (msg.Ident = SM_NOWDEATH) then
  begin
    m_boDeath := TRUE;
    // m_dwDeathTime := GetTickCount;
    PlayScene.ActorDied(Self);
  end;
  RunSound;
end;

function TActor.GetMessage(ChrMsg: pTChrMsg): Boolean;
var
  msg: pTChrMsg;
  AList: TList;
begin
  Result := FALSE;
  AList := m_MsgList.LockList;
  try
    if AList.Count > 0 then
    begin
      msg := pTChrMsg(AList[0]);
      ChrMsg.Ident := msg.Ident;
      ChrMsg.x := msg.x;
      ChrMsg.y := msg.y;
      ChrMsg.dir := msg.dir;
      ChrMsg.state := msg.state;
      ChrMsg.feature := msg.feature;
      ChrMsg.dressWeapon := msg.dressWeapon;
      ChrMsg.properties := msg.properties;
      ChrMsg.saying := msg.saying;
      ChrMsg.Sound := msg.Sound;
      ChrMsg.target := msg.target;
      ChrMsg.token := msg.token;
      Dispose(msg);
      AList.Delete(0);
      Result := TRUE;
    end;
  finally
    m_MsgList.UnlockList;
  end;
end;

function TActor.GetRealRace: Byte;
begin
  if m_boChangeToMonster then
  begin
    Result := m_btOrginalRace;
  end else
  begin
    Result := m_btRace;
  end;
end;

function TActor.GetSayX: Integer;
begin
  Result := m_nSayX + g_ClientCustomSetting.BloodShowXOffset;
end;

function TActor.GetSayY: Integer;
begin
  Result := m_nSayY + g_ClientCustomSetting.BloodShowYOffset;
end;

procedure TActor.ProcMsg;
var
  msg:  TChrMsg;
  Meff: TMagicEff;
  SkillLevel : TSkillLevel;
begin
  while (m_nCurrentAction = 0) and GetMessage(@msg) do
  begin
    m_dwLastGetMessageTime := GetTickCount;
    case msg.Ident of
      SM_OtherActorSkillSpell:
      begin
        m_btDir := Msg.dir;
        SkillLevel := g_SkillData.GetSkillLevel(Msg.feature,Msg.State);
        if SkillLevel <> nil then
        begin
          frmMain.ActorNewSpellSkill(Self,Pointer(Msg.properties),SkillLevel);
        end;
      end;
      SM_STRUCK:
        begin
          m_nHiterCode := msg.Sound;
          ReadyAction(msg);
        end;
      SM_DEATH, // 27
      SM_NOWDEATH, SM_SKELETON, SM_ALIVE, SM_ACTION_MIN .. SM_ACTION_MAX, // 26
      SM_ACTION2_MIN .. SM_ACTION2_MAX, // 35   2293    293
      SM_NPCWALK, 3000 .. 3099, SM_SNEAK, CM_SNEAK:
        ReadyAction(msg);
      SM_BATTERBACKSTEP:
        ReadyAction(msg); // SM_BATTERBACKSTEP 连击追心刺快速后退
      SM_SPACEMOVE_HIDE:
        begin // 修改传送地图不显示动画 20080521
          Meff := TScrollHideEffect.Create(250, 10, m_nCurrX, m_nCurrY, Self);
          PlayScene.m_EffectList.Add(Meff);
          g_SoundManager.DXPlaySound(s_spacemove_out);
          { if g_TargetCret <> nil then
            PlayScene.DeleteActor (g_TargetCret.m_nRecogId); }
        end;
      SM_SPACEMOVE_HIDE2:
        begin
          Meff := TScrollHideEffect.Create(1590, 10, m_nCurrX, m_nCurrY, Self);
          PlayScene.m_EffectList.Add(Meff);
          g_SoundManager.DXPlaySound(s_spacemove_out);
        end;
      SM_SPACEMOVE_SHOW:
        begin // 修改传送地图不显示动画 20080521
          Meff := TCharEffect.Create(260, 10, Self);
          PlayScene.m_EffectList.Add(Meff);
          msg.Ident := SM_TURN;
          ReadyAction(msg);
          g_SoundManager.DXPlaySound(s_spacemove_in);
        end;
      SM_SPACEMOVE_SHOW2:
        begin
          Meff := TCharEffect.Create(1600, 10, Self);
          PlayScene.m_EffectList.Add(Meff);
          msg.Ident := SM_TURN;
          ReadyAction(msg);
          g_SoundManager.DXPlaySound(s_spacemove_in);
        end;
      SM_SPACEMOVE_SHOW3:
        begin
//          Meff := TCharEffect.Create(1400, 7, Self);
//          Meff.ImgLib := g_WMagicCKImages;

          Meff := TCharEffect.Create(670, 7, Self);
          Meff.ImgLib := g_WMagicCk_NsImage;
          Meff.NextFrameTime := 60;
          PlayScene.m_EffectList.Add(Meff);
          msg.Ident := SM_TURN;
          msg.State := m_nState;
          msg.feature := m_nFeature;
          msg.dressWeapon := m_nDressWeapon;
          msg.properties := m_btJob;
          ReadyAction(msg);
          g_SoundManager.DXPlaySound(s_spacemove_in);
        end;
      SM_CHANGEDIR:
        begin
          msg.Ident := SM_TURN;
          ReadyAction(msg);
        end;
      SM_BLOODRUSHHIT:
        begin
          msg.Ident := SM_BLOODRUSHHIT;
          ReadyAction(msg);
        end;
      SM_BloodRush:
        begin
          ReadyAction(msg);
        end;
      SM_CRSHIT, SM_TWINHIT, SM_QTWINHIT, SM_CIDHIT, SM_4FIREHIT, SM_FAIRYATTACKRATE,
      SM_LEITINGHIT { 雷霆一击战士效果 20080611 } , SM_SANJUEHIT, SM_ZHUIXINHIT, SM_DUANYUEHIT, SM_HENGSAOHIT,
      SM_YTPDHIT, SM_XPYJHIT, SM_4LONGHIT, SM_YUANYUEHIT:
        ReadyAction(msg); // 解决英雄放开天龙影 看不到问题
    else
      begin
        // ReadyAction (msg); //解决人物改变地图黑屏问题 20080410
      end;
    end;
  end;

end;

procedure TActor.ProcessDynamicEffect;
var
  i:Integer;
begin
  if m_oEffect <> nil then
    m_oEffect.Run;
  if m_MyEffect <> nil then
    m_MyEffect.Run;

  if m_TitleEffects <> nil then
  begin
    for i := 0 to m_TitleEffects.Count - 1 do
    begin
      m_TitleEffects[i].Run;
    end;
  end;

end;

procedure TActor.ProcHurryMsg; // 紧急消息处理：使用魔法、魔法失败
var
  I:   Integer;
  AMessage: TChrMsg;
  AFouned: Boolean;
  AClient: TuMagicClient;
  AList: TList;
begin
  I := 0;
  AList := m_MsgList.LockList;
  try
    while True do
    begin
      if AList.Count <= I then
        Break;
      AMessage := pTChrMsg(AList[I])^; // 取出消息
      AFouned := FALSE;
      case AMessage.Ident of
        SM_MAGICFIRE:
          begin
            if m_CurMagic.ServerMagicCode <> 0 then
            begin
              if AMessage.dressWeapon = 0 then
              begin
                m_CurMagic.ServerMagicCode := 0;
                m_boUseMagic := False;
              end
              else
              begin
                m_CurMagic.ServerMagicCode := ACTOR_EFFECTID;
                m_CurMagic.Target := AMessage.x;
                if g_MagicMgr.TryGet(m_CurMagic.nMagicId, AClient) then
                begin
                  case AClient.TargetSelectType of
                    mstSelf, mstCircle:
                    begin
                      if AClient.SelfCentred then
                        m_CurMagic.Target := 0;
                    end;
                  end;
                end;
                if AMessage.y in [0 .. MAXMAGICTYPE - 1] then
                  m_CurMagic.EffectType := TMagicType(AMessage.y); // EffectType
                m_CurMagic.EffectNumber := AMessage.dir; // Effect
                m_CurMagic.TargX := AMessage.feature;
                m_CurMagic.TargY := AMessage.state;
                m_CurMagic.Recusion := TRUE;
              end;
              AFouned := TRUE;
            end;
          end;
        SM_MAGICFIRE_FAIL:
          if m_CurMagic.ServerMagicCode <> 0 then
          begin
            m_CurMagic.ServerMagicCode := 0;
            AFouned := TRUE;
          end;
      end;
      if AFouned then
      begin
        Dispose(pTChrMsg(AList[I]));
        AList.Delete(I);
      end
      else
        Inc(I);
    end;
  finally
    m_MsgList.UnlockList;
  end;
end;

// 当前是否没有可执行的动作
function TActor.IsIdle: Boolean;
begin
  Result := (m_nCurrentAction = 0) and (MsgCount = 0);
end;

// 当前动作是否已经完成
function TActor.ActionFinished: Boolean;
begin
  Result := (m_nCurrentAction = 0) or (m_nCurrentFrame >= m_nEndFrame);
end;

procedure TActor.AddHealthStatus(btStatus: Byte; nValue: Integer);
var
  HealthStatus: pTHealthStatus;
begin
  if m_HealthList.Count < 10 then
  begin
    New(HealthStatus);
    HealthStatus.btStatus := btStatus;
    HealthStatus.nValue := nValue;
    HealthStatus.dwFrameTime := GetTickCount;
    HealthStatus.nCurrentFrame := 0;
    m_HealthList.Lock;
    try
      m_HealthList.Add(HealthStatus);
    finally
      m_HealthList.UnLock;
    end;
  end;
end;

procedure TActor.AddSkillEffect(Target:TActor;EffectID,X,Y,DelayTime:Integer;FlySpeed:Single;BoAddToScene:Boolean);
var
  Effect:TSkillEffectConfig;
  MagicEffect:TMagicEff;
  msg:  pTChrMsg;
  AList : TList;
  Index:Integer;
begin
  MagicEffect := nil;
  Effect := g_SkillEffectData.FindEffectConfigByID(EffectID);
  if Effect <> nil then
  begin
    case Effect.EffectType of
      setFllowAttack:
      begin
        MagicEffect := TFallowActionEffect.Create(Self,Effect.Data,Effect.ImageIndex,Effect.FrameCountPerDir,Effect.SkipFramePerDir);
        AList := m_MsgList.LockList;
        Try
          if AList.Count > 0 then
          begin
            msg := AList.Items[AList.Count - 1];
            TFallowActionEffect(MagicEffect).FBindAction := Msg.Ident - 3000;
          end;
        Finally
          m_MsgList.UnlockList;
        End;

      end;
      setFly:
      begin
        MagicEffect := TFlyEffect.Create(Target,Self,Effect.Data,Effect.ImageIndex,Effect.FramePerTime,Effect.FrameCountPerDir);
        TFlyEffect(MagicEffect).SkipFramePerDir := Effect.SkipFramePerDir;
        TFlyEffect(MagicEffect).SetFlySpeed(FlySpeed);
      end;
      seAnimation:
      begin
        if Effect.ResourceLoadType = fet8or16Direction then
        begin
          Index := Effect.ImageIndex  + (Effect.FrameCountPerDir + Effect.SkipFramePerDir) * m_btDir;
          MagicEffect := TPlayAnimationEffect.Create(Self,Effect.Data,Index,Effect.FrameCountPerDir,Effect.FramePerTime);
        end else
        begin
          MagicEffect := TPlayAnimationEffect.Create(Self,Effect.Data,Effect.ImageIndex,Effect.FrameCountPerDir,Effect.FramePerTime);
        end;

        if BoAddToScene then
          TPlayAnimationEffect(MagicEffect).SetIsSceneEffect();

        if Effect.FramePerTime = -1then
          TPlayAnimationEffect(MagicEffect).SetFrameTime(Effect.FrameTimeArray);
      end else
      begin

      end;

    end;

    if MagicEffect <> nil then
    begin
      if DelayTime > 0 then
      begin
        MagicEffect.m_dwStartWorkTick := GetTickCount + DelayTime;
      end;

      MagicEffect.FDrawBlendMode := Effect.BlendMode;
      PlayScene.m_EffectList.Add(MagicEffect);

      MagicEffect.m_boActive := True;
    end;
  end;
end;

procedure TActor.AddSkillSound(SoundID, DelayTime: Integer);
begin

end;

procedure TActor.ShowStormEffect;
begin

end;

// 可否行走
function TActor.CanWalk: Integer;
begin
  if { (GetTickCount - LastStruckTime < 1300) or } (GetTickCount - g_GameData.LastSpellTick.Data < g_dwMagicPKDelayTime) then
    Result := -1
  else
    Result := 1;
end;

// 可否跑
function TActor.CanRun: Integer;
begin
  Result := 1;
  // 检查人物的HP值是否低于指定值，低于指定值将不允许跑
  if m_Abil.HP < RUN_MINHEALTH then
  begin
    Result := -1;
  end
  else
    // 检查人物是否被攻击，如果被攻击将不允许跑，取消检测将可以跑步逃跑
    // if (GetTickCount - LastStruckTime < 3*1000) or (GetTickCount - LatestSpellTime < MagicPKDelayTime) then
    // Result := -2;

end;

// dir : 方向
// step : 步长  (走是1，跑是2）
// cur : 当前帧(全部帧中的第几帧）
// max : 全部帧
procedure TActor.Shift(dir, step, cur, max: Integer);
var
  unx, uny, ss, v: Integer;
begin
  m_nShiftCount := m_nShiftCount + 1;
  unx := UNITX * step;
  uny := UNITY * step;
  if cur > Max then cur := Max;
  m_nRx := m_nCurrX;
  m_nRy := m_nCurrY;
  ss := Round((Max - cur - 1) / Max) * step;
  case dir of
    DR_UP: begin
        ss := Round((Max - cur) / Max) * step;
        m_nShiftX := 0;
        m_nRy := m_nCurrY + ss;
        if ss = step then m_nShiftY := -Round(uny / Max * cur)
        else m_nShiftY := Round(uny / Max * (Max - cur));
      end;
    DR_UPRIGHT: begin
        if Max >= 6 then v := 2
        else v := 0;
        ss := Round((Max - cur + v) / Max) * step;
        m_nRx := m_nCurrX - ss;
        m_nRy := m_nCurrY + ss;
        if ss = step then begin
          m_nShiftX := Round(unx / Max * cur);
          m_nShiftY := -Round(uny / Max * cur);
        end else begin
          m_nShiftX := -Round(unx / Max * (Max - cur));
          m_nShiftY := Round(uny / Max * (Max - cur));
        end;
      end;
    DR_RIGHT: begin
        ss := Round((Max - cur) / Max) * step;
        m_nRx := m_nCurrX - ss;
        if ss = step then m_nShiftX := Round(unx / Max * cur)
        else m_nShiftX := -Round(unx / Max * (Max - cur));
        m_nShiftY := 0;
      end;
    DR_DOWNRIGHT: begin
        if Max >= 6 then v := 2
        else v := 0;
        ss := Round((Max - cur - v) / Max) * step;
        m_nRx := m_nCurrX - ss;
        m_nRy := m_nCurrY - ss;
        if ss = step then begin
          m_nShiftX := Round(unx / Max * cur);
          m_nShiftY := Round(uny / Max * cur);
        end else begin
          m_nShiftX := -Round(unx / Max * (Max - cur));
          m_nShiftY := -Round(uny / Max * (Max - cur));
        end;
      end;
    DR_DOWN: begin
        if Max >= 6 then v := 1
        else v := 0;
        ss := Round((Max - cur - v) / Max) * step;
        m_nShiftX := 0;
        m_nRy := m_nCurrY - ss;
        if ss = step then m_nShiftY := Round(uny / Max * cur)
        else m_nShiftY := -Round(uny / Max * (Max - cur));
      end;
    DR_DOWNLEFT: begin
        if Max >= 6 then v := 2
        else v := 0;
        ss := Round((Max - cur - v) / Max) * step;
        m_nRx := m_nCurrX + ss;
        m_nRy := m_nCurrY - ss;
        if ss = step then begin
          m_nShiftX := -Round(unx / Max * cur);
          m_nShiftY := Round(uny / Max * cur);
        end else begin
          m_nShiftX := Round(unx / Max * (Max - cur));
          m_nShiftY := -Round(uny / Max * (Max - cur));
        end;
      end;
    DR_LEFT: begin
        ss := Round((Max - cur) / Max) * step;
        m_nRx := m_nCurrX + ss;
        if ss = step then m_nShiftX := -Round(unx / Max * cur)
        else m_nShiftX := Round(unx / Max * (Max - cur));
        m_nShiftY := 0;
      end;
    DR_UPLEFT: begin
        if Max >= 6 then v := 2
        else v := 0;
        ss := Round((Max - cur + v) / Max) * step;
        m_nRx := m_nCurrX + ss;
        m_nRy := m_nCurrY + ss;
        if ss = step then begin
          m_nShiftX := -Round(unx / Max * cur);
          m_nShiftY := -Round(uny / Max * cur);
        end else begin
          m_nShiftX := Round(unx / Max * (Max - cur));
          m_nShiftY := Round(uny / Max * (Max - cur));
        end;
      end;
  end;
end;

procedure TActor.ShowHealthStatus(dsurface: TAsphyreCanvas; X, Y: Integer);
var
  I, II, nWidth, nPerfix, nImgIndex: Integer;
  HealthStatus: pTHealthStatus;
  d: TAsphyreLockableTexture;
  sValue: string;
  nCount : Integer;
begin
  m_HealthList.Lock;
  try
    I := 0;
    while True do
    begin
      nCount := m_HealthList.Count;
      if I >= nCount then
      begin
        Break;
      end;
      HealthStatus := m_HealthList.Items[I];
      if HealthStatus.nCurrentFrame >= 40 then
      begin
        m_HealthList.Delete(I);
        Dispose(HealthStatus);
        Inc(I);
        Continue;
      end;
      if HealthStatus.btStatus = 0 then
      begin
        d := g_77Images.Images[42];
        if d <> nil then
          dsurface.Draw(X + HealthStatus.nCurrentFrame, Y - 10 - HealthStatus.nCurrentFrame, d.ClientRect, d, True); //
      end
      else
      begin
        nImgIndex := -1;
        nPerfix := -1;
        case HealthStatus.btStatus of
          1:
          begin
            nPerfix := 17;
            nImgIndex := 6;
          end;
          2:
          begin
            nPerfix := 16;
            nImgIndex := 6;
          end;
          3:
          begin
            nPerfix := 29;
            nImgIndex := 18;
          end;
          4:
          begin
            nPerfix := 28;
            nImgIndex := 18;
          end;
          5:
          begin
            nPerfix := 41;
            nImgIndex := 30;
          end;
          6:
          begin
            nPerfix := 40;
            nImgIndex := 30;
          end;
        end;
        nWidth := 0;
        if nPerfix <> -1 then
        begin
          d := g_77Images.Images[nPerfix];
          if d <> nil then
          begin
            dsurface.Draw(X + HealthStatus.nCurrentFrame, Y - 10 - HealthStatus.nCurrentFrame, d.ClientRect, d, True);
            nWidth := d.Width;
          end;
        end;
        if nImgIndex <> -1 then
        begin
          sValue := IntToStr(HealthStatus.nValue);
          for II := 1 to Length(sValue) do
          begin
            d := g_77Images.Images[nImgIndex + StrToInt(sValue[II])];
            if d <> nil then
            begin
              dsurface.Draw(X + HealthStatus.nCurrentFrame + nWidth, Y - 10 - HealthStatus.nCurrentFrame, d.ClientRect, d, True);
              Inc(nWidth, d.Width);
            end;
          end;
        end;
      end;
      if GetTickCount - HealthStatus.dwFrameTime > 10 then
      begin
        HealthStatus.dwFrameTime := GetTickCount;
        Inc(HealthStatus.nCurrentFrame);
      end;
      Inc(I);
    end;
  finally
    m_HealthList.UnLock;
  end;
end;

procedure TActor.SetBodyEffectProperty(Value: Integer);
begin
  m_BodyEffect.SetBodyEffect(Value);
end;

function TActor.LeftX: Integer;
begin
  case m_btDir of
    DR_UP: Result := -1;
    DR_UPRIGHT: Result := -1;
    DR_RIGHT: Result := 0;
    DR_DOWNRIGHT: Result := 1;
    DR_DOWN: Result := 1;
    DR_DOWNLEFT: Result := 1;
    DR_LEFT: Result := 0;
    DR_UPLEFT: Result := -1;
  end;
end;

function TActor.LeftY: Integer;
begin
  case m_btDir of
    DR_UP: Result := 0;
    DR_UPRIGHT: Result := -1;
    DR_RIGHT: Result := -1;
    DR_DOWNRIGHT: Result := -1;
    DR_DOWN: Result := 0;
    DR_DOWNLEFT: Result := 1;
    DR_LEFT: Result := 1;
    DR_UPLEFT: Result := 1;
  end;
end;

function TActor.RightX: Integer;
begin
  case m_btDir of
    DR_UP: Result := 1;
    DR_UPRIGHT: Result := 1;
    DR_RIGHT: Result := 0;
    DR_DOWNRIGHT: Result := -1;
    DR_DOWN: Result := -1;
    DR_DOWNLEFT: Result := -1;
    DR_LEFT: Result := 0;
    DR_UPLEFT: Result := 1;
  end;
end;

function TActor.RightY: Integer;
begin
  case m_btDir of
    DR_UP: Result := 0;
    DR_UPRIGHT: Result := 1;
    DR_RIGHT: Result := 1;
    DR_DOWNRIGHT: Result := 1;
    DR_DOWN: Result := 0;
    DR_DOWNLEFT: Result := -1;
    DR_LEFT: Result := -1;
    DR_UPLEFT: Result := -1;
  end;
end;

// 人物外貌特征改变
procedure TActor.FeatureChanged;
var
  AEffect: TdxItemEffect;
  ARaceImg: Byte;
  pMonAct : pTMonsterAction;
begin
  m_OuterEffect := nil;
  m_WeponOuterEffect := nil;

  //之前是变身的 但是经过这次改变后不变身了 说明此处是变身结束
  if m_boChangeToMonster and (m_wChangeToMonsterAppr = 0) then
  begin
    m_boChangeToMonster := False;
    m_btRace := m_btOrginalRace;
    m_btOrginalRace := -1;
    CalcActorFrame();
  end;

  case m_btRace of
    0, 1, 150:
      begin

        m_btHair := HAIRfeature(m_nFeature);
        GetHumanFeature(m_nFeature, ARaceImg, m_btStall, m_btSex, m_btHair);
        if m_btRace = 150 then
          m_btStall := 0;

        m_btDress := DRESSfeature(m_nDressweapon);
        case m_btDress of
          RES_IMG_BASE..RES_IMG_MAX: m_btEffect := m_btDress;
          else
          begin
            m_btDress := m_btDress * 2 + m_btSex;
            m_btEffect :=  DressEffectfeature(m_nFeatureEx);
            if m_btEffect >= 1000 then
              UIWindowManager.TryGetItemOuterEffect(m_btEffect-1000, m_OuterEffect);
          end;
        end;
        m_btWeapon := WEAPONfeature(m_nDressweapon);
        case m_btWeapon of
          RES_IMG_BASE..RES_IMG_MAX: m_nWeaponEffect := m_btWeapon;
          else
          begin
            m_btWeapon := m_btWeapon * 2 + m_btSex;
            m_nWeaponEffect :=  WeponEffectfeature(m_nFeatureEx);
            if m_nWeaponEffect > 1000 then
              UIWindowManager.TryGetItemOuterEffect(m_nWeaponEffect - 1000, m_WeponOuterEffect)
          end;
        end;

        if m_btWeapon <> m_TempWeapon then
        begin
          NeedLoad := TRUE;
          m_TempWeapon := m_btWeapon;
        end;
        if Self = g_MySelf then
        begin
          g_MyDressInnerEff := nil;
          g_MyWeponInnerEff := nil;
          if (g_UseItems[U_DRESS].Name <> '') and (g_UseItems[U_DRESS].Index > 0) and (g_UseItems[U_DRESS].CustomEff > 0) then
          begin
            if UIWindowManager.ItemEffects.TryGetEffect(g_UseItems[U_DRESS].CustomEff, AEffect) then
              UIWindowManager.TryGetItemInnerEffect(AEffect.InnerEffect, g_MyDressInnerEff);
          end;
          if (g_UseItems[U_WEAPON].Name <> '') and (g_UseItems[U_WEAPON].Index > 0) and (g_UseItems[U_WEAPON].CustomEff > 0) then
          begin
            if UIWindowManager.ItemEffects.TryGetEffect(g_UseItems[U_WEAPON].CustomEff, AEffect) then
              UIWindowManager.TryGetItemInnerEffect(AEffect.InnerEffect, g_MyWeponInnerEff);
          end;
        end;
        m_nBodyOffset := GetHumOffset(m_btJob, m_btDress);
        CalcHairImageOffset;
      end;
    50: ;
  else
    begin
      m_wAppearance := APPRfeature(m_nFeature);
      m_nBodyOffset := GetOffset(m_wAppearance);
      m_nShadowBodyOffset :=  GetShadowOffset(m_wAppearance);
    end;
  end;


  //变身开始了
  if (m_wChangeToMonsterAppr > 0) then
  begin
    m_boChangeToMonster := True;
    pMonAct := GetRaceByPM(m_wChangeToMonsterRace,m_wChangeToMonsterAppr);
    m_ChangeToMonsterAct := TransMonActionToHum(pMonAct);
    if m_btOrginalRace = -1 then
    begin
      m_btOrginalRace := m_btRace;
      m_btRace := m_wChangeToMonsterRace;
    end;
    m_wAppearance := m_wChangeToMonsterAppr;
    m_nBodyOffset := GetOffset(m_wAppearance);
  end;

  LoadSurface;
end;

function TActor.Light: Integer;
begin
  Result := m_nChrLight;
end;

// 装载当前动作对应的图片
procedure TActor.LoadSurface;
var
  mimg: TWMImages;
begin
  mimg := GetMonImg(m_wAppearance);
  m_BodySurface :=  nil;
  m_ShadowBodySurface :=  nil;
  if mimg <> nil then
  begin
    if (not m_boReverseFrame) then
    begin
      m_BodySurface := mimg.GetCachedImage(m_nBodyOffset + m_nCurrentFrame, m_nPx, m_nPy);
      if m_nShadowBodyOffset > 0 then
        m_ShadowBodySurface :=  mimg.GetCachedImage(m_nShadowBodyOffset + m_nCurrentFrame, m_nSdPx, m_nSdPy);
    end
    else
    begin
      m_BodySurface := mimg.GetCachedImage(m_nBodyOffset + m_nEndFrame - (m_nCurrentFrame - m_nStartFrame), m_nPx, m_nPy);
      if m_nShadowBodyOffset > 0 then
        m_ShadowBodySurface := mimg.GetCachedImage(m_nShadowBodyOffset + m_nEndFrame - (m_nCurrentFrame - m_nStartFrame), m_nSdPx, m_nSdPy);
    end;
  end;
end;

// 取角色的宽度
function TActor.CharWidth: Integer;
begin
  if m_BodySurface <> nil then
    Result := m_BodySurface.Width
  else
    Result := 48;
end;

// 取角色的高度
function TActor.CharHeight: Integer;
begin
  if m_BodySurface <> nil then
    Result := m_BodySurface.Height
  else
    Result := 70;
end;

// 判断某一点是否是角色的身体
function TActor.CheckSelect(dx, dy: Integer): Boolean;
begin
  Result := FALSE;
  if m_BodySurface <> nil then
  begin
    if (m_BodySurface.Pixels[dx, dy] <> 0) and ((m_BodySurface.Pixels[dx - 1, dy] <> 0) and (m_BodySurface.Pixels[dx + 1, dy] <> 0) and (m_BodySurface.Pixels[dx, dy - 1] <> 0) and
      (m_BodySurface.Pixels[dx, dy + 1] <> 0)) then
      Result := TRUE;
  end;
end;

procedure TActor.DrawEffSurface(dsurface: TAsphyreCanvas; source: TAsphyreLockableTexture; ddx, ddy: Integer; blend: Boolean; ceff: TColorEffect);
begin
  if HaveStatus(STATE_TRANSPARENT) then
    blend := True;
  DrawEffect(ddx, ddy, dsurface, source, ceff, blend);
end;

procedure TActor.DrawBodySurface(dsurface: TAsphyreCanvas;
  source: TAsphyreLockableTexture; ddx, ddy: Integer; blend: Boolean;
  ceff: TColorEffect);
begin
  if HaveStatus(STATE_TRANSPARENT) then
    blend := True;

  if (m_nBlendColor > 0) and ((ceff = ceNone) or (ceff = cebright)) then
  begin

    if not Blend then
      dsurface.DrawColor(ddx, ddy, source, m_nBlendColor, True)
    else
      dsurface.DrawColorAlpha(ddx, ddy, source.ClientRect, source, m_nBlendColor,True,ALPHAVALUE);

  end else
  begin
    DrawEffect(ddx, ddy, dsurface, source, ceff, blend);
  end;

end;

procedure TActor.DrawWeaponSurface(dsurface: TAsphyreCanvas;
  source: TAsphyreLockableTexture; ddx, ddy: Integer; blend: Boolean;
  ceff: TColorEffect);
begin
  if HaveStatus(STATE_TRANSPARENT) then
    blend := True;

  if (m_nWeaponBlendColor > 0) and (ceff = ceNone) then
  begin
    if not Blend then
      dsurface.DrawColor(ddx, ddy, source, m_nWeaponBlendColor, True)
    else
      dsurface.DrawColorAlpha(ddx, ddy, source.ClientRect, source, m_nWeaponBlendColor,True,ALPHAVALUE);
  end else
  begin
    DrawEffect(ddx, ddy, dsurface, source, ceff, blend);
  end;

end;


// 根据当前状态state获得颜色效果（比如中毒状态等，人物显示的颜色就可能不同）
function TActor.GetDrawEffectValue: TColorEffect;
begin
  Result := ceNone;

  // 高亮
  if ((g_FocusCret = Self) or (g_MagicTarget = self)) and (not HaveStatus(STATE_TRANSPARENT)) then
    Result := ceBright;
  // 中了绿毒
  if HaveStatus(STATE_POISON_DECHEALTH) then
    Result := ceGreen;
  //中了红毒
  if HaveStatus(STATE_POISON_DAMAGEARMOR) then
    Result := ceRed;
  //禁止使用魔法
  if HaveStatus(STATE_POISON_LOCKSPELL) then
    Result := ceBlue;
  // 不能移动
  if HaveStatus(STATE_POISON_DONTMOVE) then
    Result := ceFuchsia;

  //禁止跑步 只能行走
  if HaveStatus(STATE_ONLYWALK) then
    Result := ceFuchsia;

  //麻痹
  if HaveStatus(STATE_POISON_STONE) then
    Result := ceGrayScale;
end;

(* ******************************************************************************
  作用 : 显示人自身动画  [通用类]      日期：2008.01.13
  过程 : DrawMyShow(dsurface: TAsphyreCanvas;dx,dy:integer);
  参数 : dsurface为画布；DX为X坐标； DY为Y坐标；
  ****************************************************************************** *)
procedure TActor.DrawMyShow(dsurface: TAsphyreCanvas; dx, dy: Integer);
var
  d: TAsphyreLockableTexture;
  img, ax, ay: Integer;
  FlyX, FlyY:  Integer;
  AList: TList;
begin
  if m_boInSneak and (Self = g_MySelf) then
  begin
    if GetTickCount - m_nSneakTick > 90 then
    begin
      m_nSneakTick := GetTickCount;
      Inc(m_nSneakFrame);

      if IsMirReturnClient and (m_nSneakFrame > 9)  then
        m_nSneakFrame := 0
      else if (not IsMirReturnClient) and (m_nSneakFrame > 11) then
        m_nSneakFrame := 0;
    end;
    if IsMirReturnClient then
    begin
      d := MShare.g_WMagicCKImages.GetCachedImage(1550 + m_nSneakFrame, ax, ay);
      if d <> nil then
      dsurface.DrawBlend(dx + ax + m_nShiftX  , dy + ay + m_nShiftY - HALFY, d, 1);
    end
    else
    begin
      d := MShare.g_WMagicCk_NsImage.GetCachedImage(1180 + m_nSneakFrame, ax, ay);
      if d <> nil then
      dsurface.DrawBlend(dx + ax + m_nShiftX + HALFX , dy + ay + m_nShiftY - UNITY, d, 1);
    end;

  end;

  if g_boIsMyShow then
  begin
    if GetTickCount - m_nMyShowTime > m_nMyShowNextFrameTime { 140 } then
    begin
      m_nMyShowTime := GetTickCount;
      Inc(m_nMyShowFrame);
    end;
    // if g_boIsMyShow then begin
    if m_nMyShowFrame >= m_nMyShowExplosionFrame then
    begin
      g_boIsMyShow := FALSE;
      Exit;
    end;

    img := m_nMyShowStartFrame + m_nMyShowFrame;

    if (m_nTypeShow = 18 { 断岳斩 } ) and (m_nMyShowFrame = m_nMyShowExplosionFrame - 1) then
    begin
      if m_nDefTimeMsg <> nil then
      begin
        m_MsgList.Add(m_nDefTimeMsg);
        m_nDefTimeMsg := nil;
      end;
    end;

    if g_MagicWILBase <> nil then
    begin
      d := g_MagicWILBase.GetCachedImage(img, ax, ay);
      if d <> nil then
      begin
        if not m_boNoChangeIsMyShow then
        begin // 是否跟着人物动作变化而变化     20080306
          dsurface.DrawBlend(dx + ax + m_nShiftX, dy + ay + m_nShiftY, d, 1)
        end
        else
        begin
          PlayScene.ScreenXYfromMCXY(m_nNoChangeX, m_nNoChangeY, FlyX, FlyY);
          dsurface.DrawBlend(FlyX + ax - UNITX div 2, FlyY + ay - UNITY div 2, d, 1);
        end;
      end;
    end;
  end;
end;

procedure TActor.DrawQuickRushEffect(dsurface: TAsphyreCanvas; dx, dy: Integer); //绘制突进特效
var
  EffectIdx: Integer;
  ATexture : TAsphyreLockableTexture;
  nPx,nPy : Integer;
begin
  if m_boBloodRush then
  begin
    EffectIdx := 1080 + (m_btDir * 6) + Min(5,m_btBloodRushDir);
    ATexture := g_WMagicCk_NsImage.GetCachedImage(EffectIdx,nPx,nPy);
    if ATexture <> nil then
    begin
      dsurface.DrawAlpha(dx + nPx + m_nShiftX, dy + nPy + m_nShiftY, ATexture, 255,beSrcColorAdd);
      dsurface.DrawAlpha(dx + nPx + m_nShiftX, dy + nPy + m_nShiftY, ATexture, 255,beBlend);
    end;
  end;
end;

procedure TActor.DrawSaying(dsurface: TAsphyreCanvas; dx, dy: Integer);
var
  I: Integer;
begin
  //dsurface.BoldText(dx, dy, IntToStr(m_nCurrentFrame), clBlue, clWhite);

  if (m_SayingArr[0] <> '') and (GetTickCount - m_dwSayTime < 4 * 1000) then
  begin
    if m_nSayLineCount > 0 then
    begin
      for i := 0 to m_nSayLineCount - 1 do
      begin
        if m_boDeath then
          dsurface.BoldText(dx - (m_SayWidthsArr[i] div 2), dy - (m_nSayLineCount * 16) + i * 14 - 20, m_SayingArr[i], clGray, clBlack)
        else
        begin
          //dsurface.BoldText(dx - (m_SayWidthsArr[i] div 2), dy - (m_nSayLineCount * 16) + i * 14 - 20, m_SayingArr[i], clWhite, clBlack);
          if (m_SayFrontColor = clBlack) and (m_SayBackColor = clWhite) then
            dsurface.BoldText(dx - (m_SayWidthsArr[i] div 2), dy - (m_nSayLineCount * 16) + i * 14 - 20, m_SayingArr[i], clWhite, clBlack)
          else
            dsurface.BoldText(dx - (m_SayWidthsArr[i] div 2), dy - (m_nSayLineCount * 16) + i * 14 - 20, m_SayingArr[i], m_SayFrontColor, clBlack);

          if i = 0 then
          begin
            dsurface.BoldText(dx - (m_SayWidthsArr[i] div 2), dy - (m_nSayLineCount * 16) + i * 14 - 20, m_sSayNameFix,clWhite, clBlack);
          end;
        end;
      end;
    end;
  end
  else
  begin
    m_SayingArr[0] := '';
    m_sSayNameFix := '';
  end;
end;



//判断是否某些状态
function TActor.HaveStatus(Status: Integer): Boolean;
begin
  Result := SetContain(m_nState,Status);
end;

procedure TActor.HealthSpellChange(const AHP, AMP, AMaxHP: Integer; const ISDie: Boolean);
begin
  m_Abil.MaxHP  := AMaxHP;
  if g_Config.Assistant.ShowHealthStatus then
  begin
    if m_Abil.HP = 0 then
      m_Abil.HP :=  AMaxHP;
    if (AHP = 0) then
      AddHealthStatus(2, m_Abil.HP)
    else if m_Abil.HP - AHP > 0 then
      AddHealthStatus(2, m_Abil.HP - AHP)
    else if m_Abil.HP - AHP < 0 then
      AddHealthStatus(1, AHP - m_Abil.HP);
  end;

  m_boOpenHealth  :=  True;
  m_Abil.HP     := AHP;
  if AMP<>-1 then
  begin
    if g_Config.Assistant.ShowHealthStatus then
    begin
      if m_Abil.MP - AMP > 0 then
        AddHealthStatus(4, m_Abil.MP - AMP)
      else if m_Abil.MP - AMP < 0 then
        AddHealthStatus(3, AMP - m_Abil.MP);
    end;
    m_Abil.MP     := AMP;
  end;

  if Self = g_MySelf then
  begin
    g_MyAbil.HP := m_Abil.HP;
    g_MyAbil.MP := m_Abil.MP;
  end;

end;

procedure TActor.DamageHealthHPChange(const AHP, AMaxHP, ADamage: Integer);
begin
  m_Abil.HP  := AHP;
  m_Abil.MaxHP  := AMaxHP;
  DamageHealthHPChange2(ADamage);
end;

procedure TActor.DamageHealthHPChange2(ADamage: Integer);
begin
  if g_Config.Assistant.ShowHealthStatus then
   AddHealthStatus(2, ADamage);
  m_boOpenHealth := True;
end;

procedure TActor.HeroLoginOrLogOut(dsurface: TAsphyreCanvas; dx, dy: Integer);
var
  d:           TAsphyreLockableTexture;
  img, ax, ay: Integer;
begin
  if g_HeroLoginOrLogOut then
  begin
    if GetTickCount - HeroTime > 140 then
    begin
      HeroTime := GetTickCount;
      Inc(HeroFrame);
    end;
    if HeroFrame > HeroLoginExplosionFrame then
      g_HeroLoginOrLogOut := FALSE;

    img := HeroLoginStartFrame + HeroFrame;
    d := g_WEffectImages.GetCachedImage(img, ax, ay);
    if d <> nil then
      dsurface.DrawBlend(dx + ax + m_nShiftX, dy + ay + m_nShiftY, d, 1);
  end;
end;

function TActor.HumFrame: Integer;
begin
  case m_btJob of
      _JOB_WAR,_JOB_MAG,_JOB_DAO:result := HUMANFRAME;
      _JOB_CIK : Result := HUMANFRAME_CIK;
      _JOB_SHAMAN : result := HUMANFRAME_WS;
  else
    Result :=  HUMANFRAME;
  end;
end;

procedure TActor.DrawBlood(dsurface: TAsphyreCanvas);
const
  _Z_: array[_JOB_WAR.._JOB_SHAMAN] of Char = ('Z','F','D','C','G','S');

var
  ey: Integer;
  d, AStallName: TAsphyreLockableTexture;
  rc: TRect;
  S: String;
  ATexture : TuTexture;
begin
  ey := 4;
  if g_Config.Assistant.ShowBlood then
  begin
    if not m_boDeath then
    begin
      d := g_77Images.Images[1];
      if d <> nil then
      begin
        dsurface.Draw( GetSayX() - d.Width div 2, GetSayY() - ey - d.Height, d.ClientRect, d, TRUE);
      end;
      d := g_77Images.Images[2];
      if d <> nil then
      begin
        rc := d.ClientRect;
        if m_Abil.MaxHP > 0 then
          rc.Right := Round((rc.Right - rc.Left) / m_Abil.MaxHP * m_Abil.HP);
        dsurface.Draw(GetSayX() - d.Width div 2, GetSayY() - ey - d.Height, rc, d, TRUE);
        Inc(ey, d.Height + 4);
      end;


      if g_Config.Assistant.ShowBloodNum then
      begin
        if m_Abil.MaxHP > 1 then
        begin
          S := IntToStr(m_Abil.HP) + '/' +IntToStr(m_Abil.MaxHP);
          if g_Config.Assistant.ShowJobLevel and (Self.m_btRace in [0, 1]) then
            S := S + '/' + _Z_[m_btJob] + IntToStr(m_Abil.Level);
          TextNum.DrawNumberMiddle(S, dsurface, GetSayX(), GetSayY() - ey - 10);
          Inc(ey, 12);
        end;
      end;
    end;
  end;

  if m_btStall in [1..4] then
  begin
    D := g_77Images.Images[496];
    if D <> nil then
    begin
      dsurface.DrawAlpha(GetSayX() - D.Width div 2, GetSayY() - D.Height - ey, D, 225);
      AStallName := FontManager.Default.TextOut(m_sUserName + '的摊位');
      if AStallName <> nil then
        Dsurface.DrawBoldText(GetSayX() - AStallName.Width div 2, GetSayY() - D.Height - ey + (D.Height - AStallName.Height) div 2, AStallName, $00A0A9B0, FontBorderColor);
    end;
  end;

end;



procedure TActor.DrawChr(dsurface: TAsphyreCanvas; dx, dy: Integer; blend,
  boFlag: Boolean);
var
  d: TAsphyreLockableTexture;
  ceff: TColorEffect;
begin
  try
    d := nil;
    if m_btDir > 7 then
      Exit;
    if GetTickCount - m_dwLoadSurfaceTime > (FREE_TEXTURE_TIME div 2) then
    begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface; // 由于图片每60秒会释放一次（60秒内未使用的话），所以每60秒要检查一下是否已经被释放了.
    end;
    ceff := GetDrawEffectValue;
    if m_ShadowBodySurface <> nil then
      dsurface.DrawBlend(dx + m_nSdPx + m_nShiftX, dy + m_nSdPy + m_nShiftY, m_ShadowBodySurface, 0);
    if m_BodySurface <> nil then
      DrawBodySurface(dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, blend, ceff);

    DrawMyShow(dsurface, dx, dy);
    m_BodyEffect.DrawEffect(DSurface, dx + m_nShiftX, dy + m_nShiftY);
    DrawMagicEffect(dsurface, dx, dy);
  except
  end;
end;

procedure TActor.DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer);
begin
end;

procedure TActor.DrawMagicEffect(DSurface: TAsphyreCanvas; X, Y: Integer);
var
  AIndex, AOX, AOY: Integer;
  AImages: TWMImages;
  ATexture: TAsphyreLockableTexture;
  AProperties: TuCustomMagicEffectProperties;
begin
  // 显示魔法效果
  if m_boUseMagic and (m_CurMagic.EffectNumber > 0) then
  begin
    if m_nCurEffFrame in [0 .. m_nSpellFrame - 1] then
    begin
      AImages := nil;
      if g_MagicMgr.TryGet(m_CurMagic.nMagicId, m_CurMagic.Strengthen, AProperties) then
      begin
        AImages := TuMagicEffects(AProperties.Start).Images;
        case AProperties.Start.Directivity of
          dtNone: AIndex := AProperties.Start.StartIndex + m_nCurEffFrame;
          dtDirection8,
          dtDirection16: AIndex := AProperties.Start.StartIndex + m_btDir * AProperties.Start.Count + m_nCurEffFrame;
        end;
      end
      else
      begin
        GetEffectBase(m_CurMagic.EffectNumber, m_CurMagic.Strengthen, m_CurMagic.Tag, 0, AImages, AIndex); // 取得魔法效果所在图库
        case m_CurMagic.EffectNumber of
          162, 163: AIndex := AIndex + m_btDir * 10 + m_nCurEffFrame;
          166: AIndex := AIndex + m_btDir * 20 + m_nCurEffFrame;
          else
            AIndex := AIndex + m_nCurEffFrame;
        end;
      end;
      if AImages <> nil then
      begin
        ATexture := AImages.GetCachedImage(AIndex, AOX, AOY);
        if ATexture <> nil then
          DSurface.DrawBlend(X + AOX + m_nShiftX, Y + AOY + m_nShiftY, ATexture, 1);
      end;
    end;
  end;
  { ---------------------------------------------------------------------------- }
  // 显示攻击效果
  // m_btDir  方向
  // m_nCurrentFrame 当前的桢数   m_nStartFrame开始的桢数
  if m_nHitMagic > -1 then
  begin
    AImages := nil;
    if g_MagicMgr.TryGet(m_nHitMagic, m_CurHitMagic.Strengthen, AProperties) then
    begin
      if m_nCurrentFrame - m_nStartFrame >= AProperties.WarFrame then
      begin
        if m_nCurrentFrame - m_nStartFrame - AProperties.WarFrame < AProperties.Start.Count - AProperties.Start.Skip then
        begin
          AImages := TuMagicEffects(AProperties.Start).Images;
          case AProperties.Start.Directivity of
            dtNone: AIndex := AProperties.Start.StartIndex + m_nCurrentFrame - m_nStartFrame - AProperties.WarFrame;
            dtDirection8,
            dtDirection16: AIndex := AProperties.Start.StartIndex + m_btDir * AProperties.Start.Count + m_nCurrentFrame - m_nStartFrame - AProperties.WarFrame;
          end;
        end;
      end;
    end
    else
    begin
      GetHitEffect(m_nHitMagic, m_CurHitMagic.Strengthen, m_CurHitMagic.Tag, AImages, AIndex);
      case m_nHitMagic of
        SKILL_43{龙影}, SKILL_76{三绝杀}, SKILL_69{倚天劈地} : AIndex := AIndex { 开始的号 } + m_btDir { 方向 } * 20 + (m_nCurrentFrame - m_nStartFrame);
        //SKILL_167: AIndex := AIndex + m_btDir * 20 + (m_nCurrentFrame - m_nStartFrame);
        else
          AIndex := AIndex { 开始的号 } + m_btDir { 方向 } * 10 + (m_nCurrentFrame - m_nStartFrame);
      end;
    end;

    if AImages <> nil then
    begin
      ATexture := AImages.GetCachedImage(AIndex, AOX, AOY);
      if ATexture <> nil then
        DSurface.DrawBlend(X + AOX + m_nShiftX, Y + AOY + m_nShiftY, ATexture, 1);
    end;
  end;

  //刺客的冷酷
  if HaveStatus(STATE_BECOOL) then
  begin
    if m_dwBeCoolLastTime = 0 then
    m_dwBeCoolLastTime := GetTickCount;

    if (GetTickCount - m_dwBeCoolLastTime) > 20 then
    begin
      m_dwBeCoolLastTime := GetTickCount;
      Inc(m_btBeCoolFrame);
      if m_btBeCoolFrame > 9 then
        m_btBeCoolFrame := 0;
    end;

    ATexture := g_WMagicCk_NsImage.GetCachedImage(970 + m_btBeCoolFrame, AOX,AOY);
    if ATexture <> nil then
    begin
      DSurface.DrawBlend(X + AOX + m_nShiftX, Y + AOY + m_nShiftY, ATexture, 1);
    end;
  end else
  begin
    m_btBeCoolFrame := 0;
    m_dwBeCoolLastTime := 0;
  end;

end;

procedure TActor.CreateMagicObject;
var
  APlaySound: Boolean;
  AProperties: TuCustomMagicEffectProperties;
begin
  if m_boUseMagic then
  begin
    if m_CurMagic.ServerMagicCode > 0 then
    begin
      if m_nCurEffFrame = m_nSpellFrame - 1 then
      begin
        if g_MagicMgr.TryGet(m_CurMagic.nMagicId, m_CurMagic.Strengthen, AProperties) then
        begin
          if (TuMagicEffects(AProperties.Run).Images <> nil) or (TuMagicEffects(AProperties.Hit).Images <> nil) then
          begin
            with m_CurMagic do
              PlayScene.NewMagic(Self, AProperties, ServerMagicCode, m_nCurrX, m_nCurrY, TargX, TargY, Target, Recusion, AniTime, APlaySound);
            if (m_nMagicFireSound > -1) and (StrToIntDef(AProperties.Run.Sound, -1) = m_nMagicFireSound) then
              g_SoundManager.DXPlaySound(m_nMagicFireSound);
          end;
        end
        else
        begin
          with m_CurMagic do
            PlayScene.NewMagic(Self, ServerMagicCode, EffectNumber, m_CurMagic.Strengthen, m_CurMagic.Tag, m_nCurrX, m_nCurrY, TargX, TargY, Target, EffectType, Recusion, AniTime, APlaySound);
          if APlaySound then
            g_SoundManager.DXPlaySound(m_nMagicFireSound)
          else
          begin
            if m_CurMagic.EffectNumber = 51 then // 漫天火雨声音 20080511
              g_SoundManager.MyPlaySound('wav\M58-3.wav')
            else
              g_SoundManager.DXPlaySound(m_nMagicExplosionSound);
          end;
        end;
        if Self = g_MySelf then
          g_GameData.LastSpellTick.Data := GetTickCount;
        m_CurMagic.ServerMagicCode := 0;
        m_boUseMagic := False;
      end;
    end;
  end;
  if (m_nHitMagic > -1) and (m_CurHitMagic.nMagicId > -1) then
  begin
    if g_MagicMgr.TryGet(m_CurMagic.nMagicId, m_CurMagic.Strengthen, AProperties) then
    begin
      if (TuMagicEffects(AProperties.Run).Images <> nil) or (TuMagicEffects(AProperties.Hit).Images <> nil) then
      begin
        if m_nCurrentFrame - m_nStartFrame = AProperties.WarFrame then
        begin
          with m_CurHitMagic do
          begin      //todo
            PlayScene.NewMagic(Self, ACTOR_EFFECTID, EffectNumber, m_CurHitMagic.Strengthen, m_CurHitMagic.Tag, m_nCurrX, m_nCurrY, TargX, TargY, Target, EffectType, True, AniTime, APlaySound);
            nMagicId := -1;
          end;
        end;
      end;
      Exit;
    end;
    case m_nHitMagic of
      150, 151:
      begin
        if m_nCurrentFrame - m_nStartFrame = 4 then
        begin
          with m_CurHitMagic do
          begin      //todo
            PlayScene.NewMagic(Self, ACTOR_EFFECTID, EffectNumber, m_CurHitMagic.Strengthen, m_CurHitMagic.Tag, m_nCurrX, m_nCurrY, TargX, TargY, Target, EffectType, True, AniTime, APlaySound);
            nMagicId := -1;
          end;
        end;
      end;
    end;
  end;
end;

function TActor.GetCurrentActionFrameIndex: Integer;
begin
  Result :=((m_nEndFrame - m_nStartFrame) - (m_nEndFrame - m_nCurrentFrame));
  //Writeln( Format('EndFrame:%d,StartFame:%d,CurrFrame:%d',[m_nEndFrame,m_nStartFrame,m_nCurrentFrame]));
  if Result < 0 then
    Result := 0;
end;

// 缺省帧
function TActor.GetDefaultFrame(wmode: Boolean): Integer;
var
  cf: Integer;
  pm: pTMonsterAction;
begin
  Result := 0;
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    Exit;
  if m_boDeath then
  begin // 死亡
    if m_boSkeleton then // 地上尸体骷髅
      Result := pm.ActDeath.start
    else
      Result := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip) + (pm.ActDie.frame - 1);
  end
  else
  begin
    m_nDefFrameCount := pm.ActStand.frame;
    if m_nCurrentDefFrame < 0 then
      cf := 0
    else if m_nCurrentDefFrame >= pm.ActStand.frame then
      cf := 0
    else
      cf := m_nCurrentDefFrame;
    Result := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip) + cf;
  end;
end;

// 默认运动
procedure TActor.DefaultMotion; // 缺省动作
begin
  m_boReverseFrame := FALSE;
  if m_boWarMode then
  begin
    if (GetTickCount - m_dwWarModeTime > 4000) then // and not BoNextTimeFireHit then
      m_boWarMode := False;
  end;
  m_nCurrentFrame := GetDefaultFrame(m_boWarMode);
  Shift(m_btDir, 0, 1, 1);
end;

procedure TActor.DefaultFrameRun;
var
  ATime: Integer;
begin
  if GetTickCount - m_dwSmoothMoveTime > 200 then
  begin
    ATime := 500;
    case m_btRace of
      50:
      begin
        case m_wAppearance of
          81..85:
          begin
            m_Action := GetRaceByPM(m_btRace, m_wAppearance);
            if m_Action <> nil then
              ATime := m_Action.ActStand.ftime
            else
              ATime := 200;
          end;
        end;
      end;
    end;
    if GetTickCount - m_dwDefFrameTime > ATime then
    begin
      m_dwDefFrameTime := GetTickCount;
      Inc(m_nCurrentDefFrame);
      if m_nCurrentDefFrame >= m_nDefFrameCount then
        m_nCurrentDefFrame := 0;
    end;
    DefaultMotion;
  end;
end;

procedure TActor.SetNextFixedEffect(AKind, AMagicID, ALevel: Integer);

  procedure MyShow(StartFrame, ExplosionFrame, NextFrameTime: Integer; wimg: TWMImages);
  begin
    m_nMyShowStartFrame := StartFrame;
    m_nMyShowExplosionFrame := ExplosionFrame;
    m_nMyShowNextFrameTime := NextFrameTime;
    m_nMyShowTime := GetTickCount;
    m_nMyShowFrame := 0;
    g_MagicWILBase := wimg;
    g_boIsMyShow := TRUE;
  end;

var
  AProperties: TuCustomMagicEffectProperties;
begin
  if (g_boIsMyShow) and (m_nTypeShow = 18) then
    Exit;
  m_boNoChangeIsMyShow := False; // 初始化 自身效果 是变化的 20080306
  m_nTypeShow := AKind;
  case m_nTypeShow of
    -1:
      begin
        if g_MagicMgr.TryGet(AMagicID, ALevel, AProperties) then  //TODO
        begin
          MyShow(AProperties.Target.StartIndex, AProperties.Target.Count - AProperties.Target.Skip, 60, TuMagicEffects(AProperties.Start).Images);
          g_SoundManager.MyPlaySound(AProperties.Target.Sound);
        end;
      end;
    ET_PROTECTION_PIP:
      begin
        MyShow(470, 5, 140, g_WMagic6Images);
        g_SoundManager.MyPlaySound(heroshield_ground);
      end;
    ET_PROTECTION_STRUCK:
      begin
        MyShow(790, 10, 140, g_WMagic5Images);
        g_SoundManager.MyPlaySound(heroshield_ground);
      end;
    ET_OBJECTLEVELUP:
      begin
        MyShow(110, 14, 80, g_WMain2Images);
        g_SoundManager.MyPlaySound(powerup_ground);
      end;
    ET_OBJECTBUTCHMON:
      begin
        MyShow(30, 24, 140, g_WMain2Images);
        g_SoundManager.MyPlaySound(darewin_ground);
      end;
    ET_DRINKDECDRAGON:
      begin
        MyShow(710, 18, 80, g_WMain2Images);
      end;
    1:
      begin // 龙影剑法
        m_boWarMode := TRUE;
        MyShow(m_btDir * 20 + 746, 9, 50, g_WMagic2Images);
        m_boNoChangeIsMyShow := TRUE;
        m_nNoChangeX := m_nCurrX;
        m_nNoChangeY := m_nCurrY;
      end;
    2:
      begin //开天斩重击碎冰效果
        MyShow(m_btDir * 10 + 555, 5, 50, g_WMagic5Images);
        m_boWarMode := TRUE;
        m_boNoChangeIsMyShow := TRUE;
        m_nNoChangeX := m_nCurrX;
        m_nNoChangeY := m_nCurrY;
      end;
    3:
      begin //开天斩轻击碎冰效果
        MyShow(m_btDir * 10 + 715, 5, 50, g_WMagic5Images);
        m_boWarMode := TRUE;
        m_boNoChangeIsMyShow := TRUE;
        m_nNoChangeX := m_nCurrX;
        m_nNoChangeY := m_nCurrY;
      end;
    4: MyShow(170, 4, 150, g_WMagic4Images);
    //破魂斩  攻击前 怪物自身动画
    5:
      MyShow(460, 10, 80, g_WMagic4Images);
    // 劈星战士效果
    6:
      MyShow(420, 16, 120, g_WMagic4Images);
    // 雷霆一击战士效果
    7:
      MyShow(630, 5, 80, g_WMain2Images);
    // 人物喝酒动画
    8:
      MyShow(640, 9, 80, g_WMain2Images);
    // 人物酒量提升进度释放动画
    9:
      MyShow(650, 14, 80, g_WMain2Images);
    // 人物醉酒动画
    10:
      begin
        MyShow(670, 17, 80, g_WMain2Images);
        g_SoundManager.DXPlaySound(s_click_drug);
      end;
    11:
      begin // 噬血术
        MyShow(1090, 9, 50, g_WMagic2Images);
        g_SoundManager.DXPlaySound(10485);
      end;
    12: MyShow(3990, 15, 100, g_WWiscboWing); // 法师连击开始动作
    13: MyShow(4100, 33, 100, g_WWiscboWing); // 打通单个经脉 自身显示
    14: MyShow(4140, 30, 100, g_WWiscboWing);   // 修炼冲脉，打通经脉 成功
    15: MyShow(1760 + (m_btDir * 20), 15, 100, g_WWiscboWing);// 万剑归宗
    16:
      begin
        MyShow(1391, 14, 50, g_WMagic2Images);
        // 倚天劈地
        m_boWarMode := TRUE;
        m_boNoChangeIsMyShow := TRUE;
        m_nNoChangeX := m_nCurrX;
        m_nNoChangeY := m_nCurrY;
      end;
    17: MyShow(327, 12, 80, g_77Images);
    24: MyShow(418, 12, 80, g_77Images); //会心
    18: MyShow(m_btDir * 10 + 1920, 5, 80, g_WWiscboWing);// 断岳斩
    19:
      begin
        MyShow(m_btDir * 10 + 2003, 4, 150, g_WWiscboWing);
        // 断岳斩结束
        m_boWarMode := TRUE;
        m_boNoChangeIsMyShow := TRUE;
        m_nNoChangeX := m_nCurrX;
        m_nNoChangeY := m_nCurrY;
      end;
    20: MyShow(3990, 15, 80, g_WWiscboWing);// 道士 法师 连击开始的动画;
    21: MyShow(920, 22, 30, g_WEffectGJSImages);//雷光之眼
    22: MyShow(1350, 7, 50, g_WMagicCKImages); //灵魂陷阱
    23: MyShow(1302, 5, 50, g_WMagicCKImages);
    53: MyShow(1560, 19, 50, g_WMagicCKImages);
  end;
end;

procedure TActor.SetSound;
var
  cx, cy, bidx, wunit, attackweapon: Integer;
  hiter: TActor;
  AProperties: TuCustomMagicEffectProperties;
begin
  if (Race = 0) or (Race = 1) or (Race = 150) { 人类,英雄,人型20080629 } then
 // if (m_btRace = 0) or (m_btRace = 1) or (m_btRace = 150) { 人类,英雄,人型20080629 } then
  begin // 人类玩家
    if (Self = g_MySelf) and // 基本动作
      ((m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_SNEAK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_BATTERBACKSTEP) or (m_nCurrentAction = SM_RUN) or
       (m_nCurrentAction=SM_HORSERUN) or (m_nCurrentAction = SM_RUSH) or (m_nCurrentAction = SM_RUSHKUNG)) then
    begin
      cx := g_MySelf.m_nCurrX - Map.m_nBlockLeft;
      cy := g_MySelf.m_nCurrY - Map.m_nBlockTop;
      cx := cx div 2 * 2;
      cy := cy div 2 * 2;
      bidx := Map.m_MArr[cx, cy].wBkImg and $7FFF;
      wunit := Map.m_MArr[cx, cy].btArea;
      bidx := wunit * 10000 + bidx - 1;
      case bidx of
        330 .. 349, 450 .. 454, 550 .. 554, 750 .. 754, 950 .. 954, 1250 .. 1254, 1400 .. 1424, 1455 .. 1474, 1500 .. 1524, 1550 .. 1574:
          m_nFootStepSound := s_walk_lawn_l; // 草地上行走

        250 .. 254, 1005 .. 1009, 1050 .. 1054, 1060 .. 1064, 1450 .. 1454, 1650 .. 1654:
          m_nFootStepSound := s_walk_rough_l; // 粗糙的地面

        605 .. 609, 650 .. 654, 660 .. 664, 2000 .. 2049, 3025 .. 3049, 2400 .. 2424, 4625 .. 4649, 4675 .. 4678:
          m_nFootStepSound := s_walk_stone_l; // 石头地面上行走

        1825 .. 1924, 2150 .. 2174, 3075 .. 3099, 3325 .. 3349, 3375 .. 3399:
          m_nFootStepSound := s_walk_cave_l; // 洞穴里行走

        3230, 3231, 3246, 3277:
          m_nFootStepSound := s_walk_wood_l; // 木头地面行走

        // 带傈..
        3780 .. 3799:
          m_nFootStepSound := s_walk_wood_l;

        3825 .. 4434:
          if (bidx - 3825) mod 25 = 0 then
            m_nFootStepSound := s_walk_wood_l
          else
            m_nFootStepSound := s_walk_ground_l;

        2075 .. 2099, 2125 .. 2149:
          m_nFootStepSound := s_walk_room_l; // 房间里

        1800 .. 1824:
          m_nFootStepSound := s_walk_water_l; // 水中

      else
        m_nFootStepSound := s_walk_ground_l;
      end;
      // 泵傈郴何
      if (bidx >= 825) and (bidx <= 1349) then
      begin
        if ((bidx - 825) div 25) mod 2 = 0 then
          m_nFootStepSound := s_walk_stone_l;
      end;
      // 悼奔郴何
      if (bidx >= 1375) and (bidx <= 1799) then
      begin
        if ((bidx - 1375) div 25) mod 2 = 0 then
          m_nFootStepSound := s_walk_cave_l;
      end;
      case bidx of
        1385, 1386, 1391, 1392:
          m_nFootStepSound := s_walk_wood_l;
      end;

      bidx := Map.m_MArr[cx, cy].wMidImg and $7FFF; // 检查地图属性
      bidx := bidx - 1;
      case bidx of
        0 .. 115:
          m_nFootStepSound := s_walk_ground_l;
        120 .. 124:
          m_nFootStepSound := s_walk_lawn_l;
      end;

      bidx := Map.m_MArr[cx, cy].wFrImg and $7FFF;
      bidx := bidx - 1;
      case bidx of
        221 .. 289, 583 .. 658, 1183 .. 1206, 7163 .. 7295, 7404 .. 7414:
          m_nFootStepSound := s_walk_stone_l;
        3125 .. 3267, { 3319..3345, 3376..3433, } 3757 .. 3948, 6030 .. 6999:
          m_nFootStepSound := s_walk_wood_l;
        3316 .. 3589:
          m_nFootStepSound := s_walk_room_l;
      end;
      if (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then
        m_nFootStepSound := m_nFootStepSound + 2;
    end;

    if m_btSex = 0 then
    begin // 男
      m_nScreamSound := s_man_struck;
      m_nDieSound := s_man_die;
    end
    else
    begin // 女
      m_nScreamSound := s_wom_struck;
      m_nDieSound := s_wom_die;
    end;

    case m_nCurrentAction of // 攻击动作
      SM_THROW, SM_HIT, SM_HEAVYHIT, SM_HIT + 2:
        begin
          case (m_btWeapon div 2) of
            6, 20:
              m_nWeaponSound := s_hit_short;
            1:
              m_nWeaponSound := s_hit_wooden;
            2, 13, 9, 5, 14, 22:
              m_nWeaponSound := s_hit_sword;
            4, 17, 10, 15, 16, 23:
              m_nWeaponSound := s_hit_do;
            3, 7, 11:
              m_nWeaponSound := s_hit_axe;
            24:
              m_nWeaponSound := s_hit_club;
            8, 12, 18, 21:
              m_nWeaponSound := s_hit_long;
          else
            m_nWeaponSound := s_hit_fist;
          end;
          if (m_nCurrentAction = SM_HEAVYHIT) and (m_nHitMagic = 150) then
            m_nWeaponSound := 10750;
        end;
      SM_STRUCK: // 受攻击
        begin
          if m_nMagicStruckSound >= 1 then
          begin
            // strucksound := s_struck_magic;
          end
          else
          begin
            hiter := PlayScene.FindActor(m_nHiterCode);
            // attackweapon := 0;
            if hiter <> nil then
            begin
              attackweapon := hiter.m_btWeapon div 2;
              if (hiter.m_btRace = 0) or (hiter.m_btRace = 1) or (hiter.m_btRace = 150) then // 人类,英雄,人型20080629
                case (m_btDress div 2) of
                  3:
                    case attackweapon of
                      6:
                        m_nStruckSound := s_struck_armor_sword;
                      1, 2, 4, 5, 9, 10, 13, 14, 15, 16, 17:
                        m_nStruckSound := s_struck_armor_sword;
                      3, 7, 11:
                        m_nStruckSound := s_struck_armor_axe;
                      8, 12, 18:
                        m_nStruckSound := s_struck_armor_longstick;
                    else
                      m_nStruckSound := s_struck_armor_fist;
                    end;
                else
                  case attackweapon of
                    6:
                      m_nStruckSound := s_struck_body_sword;
                    1, 2, 4, 5, 9, 10, 13, 14, 15, 16, 17:
                      m_nStruckSound := s_struck_body_sword;
                    3, 7, 11:
                      m_nStruckSound := s_struck_body_axe;
                    8, 12, 18:
                      m_nStruckSound := s_struck_body_longstick;
                  else
                    m_nStruckSound := s_struck_body_fist;
                  end;
                end;
            end;
          end;
        end;
    end;

    if m_boUseMagic and (m_CurMagic.nMagicId > 0) then
    begin
      m_nMagicStartSound := -1;
      m_nMagicFireSound := -1;
      m_nMagicExplosionSound := -1;
      m_sMagicStartSound := '';
      m_sMagicFireSound := '';
      m_sMagicExplosionSound := '';
      if g_MagicMgr.TryGet(m_CurMagic.nMagicId, m_CurMagic.Strengthen, AProperties) then
      begin
        m_nMagicStartSound := StrToIntDef(AProperties.Start.Sound, -1);
        if m_nMagicStartSound = -1 then
          m_sMagicStartSound := AProperties.Start.Sound;
        m_nMagicFireSound := StrToIntDef(AProperties.Run.Sound, -1);
        if m_nMagicFireSound = -1 then
          m_sMagicFireSound := AProperties.Run.Sound;
        m_nMagicExplosionSound := StrToIntDef(AProperties.Hit.Sound, -1);
        if m_nMagicExplosionSound = -1 then
          m_sMagicExplosionSound := AProperties.Hit.Sound;
      end
      else
      begin
        case m_CurMagic.nMagicId of // MagicSerial为魔法ID 20080302
          41:
            m_nMagicStartSound := 10430; // 狮子吼  20080314
          44:
            begin // 寒冰掌
              m_nMagicStartSound := 10000 + (m_CurMagic.nMagicId - 5) * 10;
              m_nMagicFireSound := 10000 + (m_CurMagic.nMagicId - 5) + 1;
              m_nMagicExplosionSound := 10000 + (m_CurMagic.nMagicId - 5) * 10 + 2;
            end;
          45:
            begin // 灭天火
              m_nMagicStartSound := 10000 + (m_CurMagic.nMagicId - 10) * 10;
              m_nMagicExplosionSound := 10000 + (m_CurMagic.nMagicId - 10) + 2;
            end;
          48:
            begin
              m_nMagicStartSound := 10370; // 气功波 20080321
              m_nMagicExplosionSound := 0;
            end;
          50:
            begin
              m_nMagicStartSound := 10360; // 无极真气  20080314
              m_nMagicExplosionSound := 0;
            end;
          59, 94 { 四级噬血术 } :
            begin
              m_nMagicStartSound := 10480; // 噬血术  20080511
              m_nMagicExplosionSound := 10482;
            end;
          62:
            begin // 雷霆一击 20080405
              m_nMagicStartSound := 10520;
              m_nMagicExplosionSound := 10522;
            end;
          63:
            begin // 噬魂沼泽 20080405
              m_nMagicStartSound := 10530;
              m_nMagicExplosionSound := 10532;
            end;
          64:
            begin // 末日审判 20080405
              m_nMagicStartSound := 10540;
              m_nMagicExplosionSound := 10542;
            end;
          65:
            begin // 火龙气焰 20080405
              m_nMagicStartSound := 10550;
              m_nMagicExplosionSound := 10552;
            end;
          72:
            begin // 召唤月灵
              m_nMagicStartSound := 10410;
            end;
          66:
            begin // 4级魔法盾
              m_nMagicStartSound := 10310;
              m_nMagicFireSound := 10311;
              m_nMagicExplosionSound := 10312;
            end;
          { 100: begin //月灵轻击
            m_nMagicStartSound := 11000;
            m_nMagicExplosionSound := 11002;
            end;
            101: begin //月灵重击
            m_nMagicStartSound := 11010;
            m_nMagicExplosionSound := 11012;
            end; }
          77:
            begin
              m_sMagicStartSound := 'wav\cboFs1_start.wav';
              m_sMagicExplosionSound := 'wav\cboFs1_target.wav';
            end;
          78:
            begin
              m_sMagicStartSound := 'wav\cboDs1_start.wav';
              m_sMagicExplosionSound := 'wav\cboDs1_target.wav';
            end;
          80:
            begin
              m_sMagicStartSound := 'wav\cboFs2_start.wav';
              m_sMagicExplosionSound := 'wav\cboFs2_target.wav';
            end;
          81:
            begin
              m_sMagicStartSound := 'wav\cboDs2_start.wav';
              m_sMagicExplosionSound := 'wav\cboDs2_target.wav';
            end;
          83:
            begin
              m_sMagicStartSound := 'wav\cboFs3_start.wav';
              m_sMagicExplosionSound := 'wav\cboFs3_target.wav';
            end;
          84:
            begin
              m_sMagicStartSound := 'wav\cboDs3_start.wav';
              m_sMagicExplosionSound := 'wav\cboDs3_target.wav';
            end;
          86:
            begin
              m_sMagicStartSound := 'wav\cboFs4_start.wav';
            end;
          87:
            begin
              m_sMagicStartSound := 'wav\cboDs4_start.wav';
              m_sMagicExplosionSound := 'wav\cboDs4_target.wav';
            end;
          91:
            begin // 四级雷电术
              m_nMagicStartSound := 10000 + 11 * 10;
              m_nMagicFireSound := 10000 + 11 * 10 + 1;
              m_nMagicExplosionSound := 10000 + 11 * 10 + 2;
            end;
          92:
            begin // 四级流星火雨
              m_nMagicStartSound := 10000 + 58 * 10;
              m_nMagicFireSound := 10000 + 58 * 10 + 1;
              m_nMagicExplosionSound := 10000 + 58 * 10 + 2;
            end;
          93:
            begin // 四级施毒术
              m_nMagicStartSound := 10000 + 6 * 10;
              m_nMagicFireSound := 10000 + 6 * 10 + 1;
              m_nMagicExplosionSound := 10000 + 6 * 10 + 2;
            end;
          150:
            begin
              m_nMagicStartSound := 10750;
              m_nMagicFireSound := 10751;
              m_nMagicExplosionSound := 0;
            end;
          152:
            begin
              m_nMagicStartSound := 10800;
              m_nMagicFireSound := 10802;
              m_nMagicExplosionSound := 0;
            end;
          153:
            begin
              m_nMagicStartSound := 10780;
              m_nMagicFireSound := 0;
              m_nMagicExplosionSound := 0;
            end;
          154:
            begin
              m_nMagicStartSound := 10810;
              m_nMagicFireSound := 0;
              m_nMagicExplosionSound := 0;
            end;
          155:
            begin
              m_nMagicStartSound := 10760;
              m_nMagicFireSound := 0;
              m_nMagicExplosionSound := 0;
            end;
          156:
            begin
              m_nMagicStartSound := 10830;
              m_nMagicFireSound := 0;
              m_nMagicExplosionSound := 0;
            end;
          157:
            begin
              m_sMagicStartSound := 'wav\wjqf.wav';
            end;
          158:
            begin
              m_nMagicStartSound := 10820;
              m_nMagicFireSound := 10822;
              m_nMagicExplosionSound := 0;
            end;
          160:
            begin
              m_sMagicStartSound := 'wav\qianxing_shifang.wav';
            end;
          163:
            begin
              m_sMagicStartSound := 'wav\yanlongbo.wav';
            end;
          169:
            begin
              m_sMagicStartSound := 'wav\linghunxianjing_shifang.wav';
            end;
          164:
            begin
              m_sMagicStartSound := 'wav\旋风.wav';
            end;
          167:
            begin
              m_sMagicStartSound := 'wav\huoliankuangwu.wav';
            end;
          170:
            begin
              m_sMagicStartSound := 'wav\shuangyue.wav';
            end;
        else
          begin
            m_nMagicStartSound := 10000 + m_CurMagic.nMagicId * 10;
            m_nMagicFireSound := 10000 + m_CurMagic.nMagicId * 10 + 1;
            m_nMagicExplosionSound := 10000 + m_CurMagic.nMagicId * 10 + 2;
          end;
        end;
      end;
    end;
  end
  else
  begin
    if m_nCurrentAction = SM_STRUCK then
    begin // 受攻击
      if m_nMagicStruckSound >= 1 then
      begin
        // strucksound := s_struck_magic;
      end
      else
      begin
        hiter := PlayScene.FindActor(m_nHiterCode);
        if hiter <> nil then
        begin
          attackweapon := hiter.m_btWeapon div 2;
          case attackweapon of
            6:
              m_nStruckSound := s_struck_body_sword;
            1, 2, 4, 5, 9, 10, 13, 14, 15, 16, 17:
              m_nStruckSound := s_struck_body_sword;
            3, 11:
              m_nStruckSound := s_struck_body_axe;
            8, 12, 18:
              m_nStruckSound := s_struck_body_longstick;
          else
            m_nStruckSound := s_struck_body_fist;
          end;
        end;
      end;
    end;

    if m_btRace <> 50 then
    begin
      m_nAppearSound := 200 + (m_wAppearance) * 10;
      m_nNormalSound := 200 + (m_wAppearance) * 10 + 1;
      m_nAttackSound := 200 + (m_wAppearance) * 10 + 2;
      m_nWeaponSound := 200 + (m_wAppearance) * 10 + 3;
      m_nScreamSound := 200 + (m_wAppearance) * 10 + 4;
      if m_btRace = 108 then
        m_nDieSound := 1925  //月灵死亡声音
      else
        m_nDieSound := 200 + (m_wAppearance) * 10 + 5;
      m_nDie2Sound := 200 + (m_wAppearance) * 10 + 6;
    end;
  end;

  if m_nCurrentAction = SM_STRUCK then
  begin // 受攻击
    hiter := PlayScene.FindActor(m_nHiterCode);
    if hiter <> nil then
    begin
      attackweapon := hiter.m_btWeapon div 2;
      if hiter.m_btRace in [0, 1, 150] then // 人类,英雄,人型
        case (attackweapon div 2) of
          6, 20:
            m_nStruckWeaponSound := s_struck_short;
          1:
            m_nStruckWeaponSound := s_struck_wooden;
          2, 13, 9, 5, 14, 22:
            m_nStruckWeaponSound := s_struck_sword;
          4, 17, 10, 15, 16, 23:
            m_nStruckWeaponSound := s_struck_do;
          3, 7, 11:
            m_nStruckWeaponSound := s_struck_axe;
          24:
            m_nStruckWeaponSound := s_struck_club;
          8, 12, 18, 21:
            m_nStruckWeaponSound := s_struck_wooden; // long;
          // else struckweaponsound := s_struck_fist;
        end;
    end;
  end;
end;

procedure TActor.SetStatus(Status: Integer);
begin
  m_nState := Status;
end;

// 播放动作声效
procedure TActor.RunSound;
begin
  m_boRunSound := TRUE;
  SetSound;
  case m_nCurrentAction of
    SM_STRUCK: // 被攻击
      begin
        if (m_nStruckWeaponSound >= 0) then
          g_SoundManager.DXPlaySound(m_nStruckWeaponSound); // 攻击的武器的声效
        if (m_nStruckSound >= 0) then
          g_SoundManager.DXPlaySound(m_nStruckSound); // 被攻击的声效
        if (m_nScreamSound >= 0) then
          g_SoundManager.DXPlaySound(m_nScreamSound); // 尖叫
      end;
    SM_NOWDEATH:
      begin
        if (m_nDieSound >= 0) then
        begin
          g_SoundManager.DXPlaySound(m_nDieSound);
        end;
      end;
    SM_THROW, SM_HIT, SM_FLYAXE, SM_LIGHTING, SM_DIGDOWN { 巩摧塞 } :
      begin
        if m_nAttackSound >= 0 then
          g_SoundManager.DXPlaySound(m_nAttackSound);
      end;
    SM_ALIVE, SM_DIGUP :
      begin
        g_SoundManager.DXPlaySound(m_nAppearSound);
      end;
    SM_SPELL:
      begin
        if m_nMagicStartSound <> -1 then
          g_SoundManager.DXPlaySound(m_nMagicStartSound)
        else
          g_SoundManager.MyPlaySound(m_sMagicStartSound);
        case m_CurMagic.nMagicId of
          60: g_SoundManager.PHHitSound(1);
          61: g_SoundManager.PHHitSound(2);
          else
          begin
            case m_CurMagic.EffectNumber of
              51: g_SoundManager.MyPlaySound('wav\M58-0.wav'); // 漫天火雨声音
              91: g_SoundManager.MyPlaySound(heroshield_ground); // 护体神盾声音
            end;
          end;
        end;
      end;
  end;
end;

procedure TActor.RunActSound(frame: Integer);
begin
  if m_boRunSound then
  begin
    case m_nCurrentAction of
      SM_THROW:
      begin
        g_SoundManager.DXPlaySound(m_nWeaponSound);
        m_boRunSound := FALSE;
        Exit;
      end;
      SM_HIT, SM_HEAVYHIT:
      begin
        PlayHitMagicSound(m_nHitMagic, m_CurHitMagic.Strengthen, frame, m_btSex, m_nWeaponSound, m_boRunSound);
        Exit;
      end;
    end;

    if Race <> 50 then
    begin
      if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_SNEAK) or (m_nCurrentAction = SM_TURN) then
      begin
        if (frame = 1) and (Random(8) = 1) then
        begin
          g_SoundManager.DXPlaySound(m_nNormalSound);
          m_boRunSound := FALSE;
        end;
      end;
      if m_nCurrentAction = SM_HIT then
      begin
        if (frame = 3) and (m_nAttackSound >= 0) then
        begin
          g_SoundManager.DXPlaySound(m_nWeaponSound);
          m_boRunSound := FALSE;
        end;
      end;

      //山洞蝙蝠
      if m_wAppearance = 80 then
      begin
        if (m_nCurrentAction = SM_NOWDEATH) and (frame = 2) then
        begin
          g_SoundManager.DXPlaySound(m_nDie2Sound);
          m_boRunSound := FALSE;
        end;
      end;
    end;
  end;
end;

procedure TActor.RunFrameAction(frame: Integer);
begin
end;

procedure TActor.ActionEnded;
begin
end;

procedure TActor.Run;
  function MagicTimeOut: Boolean;
  begin
    Result := GetTickCount - m_dwWaitMagicRequest > m_dwWaitMagicRequestTime;
    if Result then
      m_CurMagic.ServerMagicCode := 0;
  end;

var
  prv:               Integer;
  m_dwFrameTimetime: Longword;
  bofly:             Boolean;
begin
//todo 如何让已死的彻底死掉
//  if (m_Abil.HP <= 0) and (m_Abil.MaxHP > 0) and not m_boDeath then
//  begin
//    SendMsg(SM_DEATH, m_nCurrX, m_nCurrY, 0, 0, 0, 0, '', 0);
//  end;
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_SNEAK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_BATTERBACKSTEP) or (m_nCurrentAction = SM_RUN) or
   (m_nCurrentAction = SM_HORSERUN) or (m_nCurrentAction = SM_RUSH) or (m_nCurrentAction = SM_RUSHKUNG) or (m_nCurrentAction = SM_SANJUEHIT) // 注意 该处添加连击消息 20091205 邱高奇
  then
    Exit;

  m_boMsgMuch := FALSE;
  if Self <> g_MySelf then
  begin
    if MsgCount >= 2 then
      m_boMsgMuch := TRUE;
  end;

  // 声音效果
  RunActSound(m_nCurrentFrame - m_nStartFrame);
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then
  begin // 动作不为空
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if (Self <> g_MySelf) and (m_boUseMagic) then
    begin
      m_dwFrameTimetime := Round(m_dwFrameTime / 1.8);
    end
    else
    begin
      if m_boMsgMuch then
        m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
      else
        m_dwFrameTimetime := m_dwFrameTime;
    end;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then
    begin
      if m_nCurrentFrame < m_nEndFrame then
      begin
        if m_boUseMagic then
        begin
          if (m_nCurEffFrame = m_nSpellFrame - 2) or (MagicTimeOut) then
          begin
            if (m_CurMagic.ServerMagicCode >= 0) or (MagicTimeOut) then
            begin
              Inc(m_nCurrentFrame);
              Inc(m_nCurEffFrame);
              m_dwStartTime := GetTickCount;
            end;
          end
          else
          begin
            if m_nCurrentFrame < m_nEndFrame - 1 then
              Inc(m_nCurrentFrame);
            Inc(m_nCurEffFrame);
            m_dwStartTime := GetTickCount;
          end;
        end
        else
        begin
          Inc(m_nCurrentFrame);
          m_dwStartTime := GetTickCount;
        end;
      end
      else
      begin
        if m_boDelActionAfterFinished then
        begin
          m_boDelActor := TRUE;
        end;
        if Self = g_MySelf then
        begin
          if frmMain.ServerAcceptNextAction then
          begin
            ActionEnded;
            m_nCurrentAction := 0;
            m_boUseMagic := FALSE;
            m_nHitMagic := -1;
          end;
        end
        else
        begin
          ActionEnded;
          m_nCurrentAction := 0;
          m_boUseMagic := FALSE;
          m_nHitMagic := -1;
        end;
      end;
      Inc(m_nMagicFrame);
      CreateMagicObject;
    end;
    if (m_wAppearance = 0) or (m_wAppearance = 1) or (m_wAppearance = 43) then
      m_nCurrentDefFrame := -10
    else
      m_nCurrentDefFrame := 0;
    m_dwDefFrameTime := GetTickCount;
  end
  else
  begin // 动作为空
    if (m_btRace = 50) and (m_wAppearance in [54 .. 58]) then
    begin // 雪域NPC 20081229
      if GetTickCount - m_dwDefFrameTime > m_dwFrameTime then
      begin
        m_dwDefFrameTime := GetTickCount;
        Inc(m_nCurrentDefFrame);
        if m_nCurrentDefFrame >= m_nDefFrameCount then
          m_nCurrentDefFrame := 0;
      end;
      DefaultMotion;
    end
    else
      DefaultFrameRun;
  end;

  if prv <> m_nCurrentFrame then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  m_BodyEffect.Run;
end;

procedure TActor.MissHealthSpellChange;
begin
  if g_Config.Assistant.ShowHealthStatus then
    AddHealthStatus(0, 0);
end;

// 根据当前动作和状态计算下一个动作对应的帧
function TActor.Move: Boolean;
var
  prv, curstep, maxstep: Integer;
  Fastmove, normmove:    Boolean;
begin
  Result := FALSE;
  Fastmove := FALSE;
  normmove := FALSE;
  if m_boBloodRush then
    Exit;

  if (m_nCurrentAction = SM_BACKSTEP) then // or (CurrentAction = SM_RUSH) or (CurrentAction = SM_RUSHKUNG) then
    Fastmove := TRUE;
  //if (m_nCurrentAction = SM_BATTERBACKSTEP) then // or (CurrentAction = SM_RUSH) or (CurrentAction = SM_RUSHKUNG) then
    // Fastmove := TRUE;
    if (m_nCurrentAction = SM_RUSH) or (m_nCurrentAction = SM_RUSHKUNG) then
      normmove := TRUE;
  if (Self = g_MySelf) and (not Fastmove) and (not normmove) then
  begin
    // 走动的声音
    case m_nCurrentAction of
      SM_WALK, SM_BACKSTEP, SM_BATTERBACKSTEP, SM_RUN, SM_HORSERUN, SM_RUSH, SM_RUSHKUNG:
      begin
        case (m_nCurrentFrame - m_nStartFrame) of
          1: g_SoundManager.DXPlaySound(m_nFootStepSound);
          4: g_SoundManager.DXPlaySound(m_nFootStepSound + 1);
        end;
      end;
      SM_SNEAK:
      begin
        if m_nCurrentFrame - m_nStartFrame = 0 then
          g_SoundManager.MyPlaySound('wav\qianxing_run.wav');
      end;
    end;
  end;


  Result := FALSE;
  m_boMsgMuch := FALSE;
  if Self <> g_MySelf then
  begin
    if MsgCount >= 2 then
      m_boMsgMuch := TRUE;
  end;

  prv := m_nCurrentFrame;
  // 移动
  case m_nCurrentAction of
    SM_WALK, SM_SNEAK, SM_RUN, SM_HORSERUN, SM_RUSH, SM_RUSHKUNG, SM_ZHUIXINHIT:
    begin
      RunActSound(m_nCurrentFrame - m_nStartFrame);
      // 调整当前帧
      if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      begin
        m_nCurrentFrame := m_nStartFrame - 1;
      end;
      if m_nCurrentFrame < m_nEndFrame then
      begin
        Inc(m_nCurrentFrame);

        if m_boMsgMuch and not normmove then // 加快步伐
          if m_nCurrentFrame < m_nEndFrame then
            Inc(m_nCurrentFrame);
        curstep := m_nCurrentFrame - m_nStartFrame + 1;
        maxstep := m_nEndFrame - m_nStartFrame + 1;
        Shift(m_btDir, m_nMoveStep, curstep, maxstep); // 变速
      end;
      if m_nCurrentFrame >= m_nEndFrame then
      begin
        if Self = g_MySelf then
        begin
          if frmMain.ServerAcceptNextAction then
          begin
            m_nCurrentAction := 0; // 当前动作：无
            m_boLockEndFrame := TRUE;
            m_dwSmoothMoveTime := GetTickCount;
          end;
        end
        else
        begin
          m_nCurrentAction := 0; // 悼累 肯丰
          m_boLockEndFrame := TRUE;
          m_dwSmoothMoveTime := GetTickCount;
        end;
        m_nHitMagic := -1;
        Result := TRUE;
      end;
      if m_nCurrentAction = SM_RUSH then
      begin
        if Self = g_MySelf then
        begin
          g_dwDizzyDelayStart := GetTickCount;
          g_dwDizzyDelayTime := 300; // 掉饭捞
        end;
      end;
      if m_nCurrentAction = SM_RUSHKUNG then
      begin // 野蛮冲撞
        if m_nCurrentFrame >= m_nEndFrame - 3 then
        begin
          m_nCurrX := m_nActBeforeX;
          m_nCurrY := m_nActBeforeY;
          m_nRx := m_nCurrX;
          m_nRy := m_nCurrY;
          m_nCurrentAction := 0;
          m_boLockEndFrame := TRUE;
          m_dwSmoothMoveTime := GetTickCount;
        end;
      end;
      Result := TRUE;
    end;
    SM_BACKSTEP, SM_BATTERBACKSTEP:
    begin
      if (m_nCurrentFrame > m_nEndFrame) or (m_nCurrentFrame < m_nStartFrame) then
        m_nCurrentFrame := m_nEndFrame + 1;
      if m_nCurrentFrame > m_nStartFrame then
      begin
        Dec(m_nCurrentFrame);
        if m_boMsgMuch or Fastmove then
          if m_nCurrentFrame > m_nStartFrame then
            Dec(m_nCurrentFrame);

        curstep := m_nEndFrame - m_nCurrentFrame + 1;
        maxstep := m_nEndFrame - m_nStartFrame + 1;
        Shift(GetBack(m_btDir), m_nMoveStep, curstep, maxstep);
      end;
      if m_nCurrentFrame <= m_nStartFrame then
      begin
        if Self = g_MySelf then
        begin
          // if FrmMain.ServerAcceptNextAction then begin
          m_nCurrentAction := 0; // 消息为空
          m_boLockEndFrame := TRUE; // 锁定当前操作
          m_dwSmoothMoveTime := GetTickCount;

          g_dwDizzyDelayStart := GetTickCount;
          g_dwDizzyDelayTime := 1000; // 1檬 掉饭捞
        end
        else
        begin
          m_nCurrentAction := 0; // 悼累 肯丰
          m_boLockEndFrame := TRUE;
          m_dwSmoothMoveTime := GetTickCount;
        end;
      end;
      Result := TRUE;
    end;
  end;

  if prv <> m_nCurrentFrame then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
end;

// 移动失败（服务器不接受移动命令）时，退回到上次的位置
procedure TActor.MoveFail;
begin
  m_nCurrentAction := 0; // 悼累 肯丰
  m_boLockEndFrame := TRUE;
  g_MySelf.m_nCurrX := m_nOldx;
  g_MySelf.m_nCurrY := m_nOldy;
  g_MySelf.m_btDir := m_nOldDir;
  CleanUserMsgs;
end;

function TActor.CanCancelAction: Boolean;
begin
  Result := FALSE;
  if m_nCurrentAction = SM_HIT then
    if not m_boUseEffect then
      Result := TRUE;
end;

procedure TActor.CancelAction;
begin
  m_nCurrentAction := 0; // 悼累 肯丰
  m_boLockEndFrame := TRUE;
end;

procedure TActor.CancelActionEx;
begin
  if (m_nCurrentAction in [SM_SANJUEHIT .. SM_HENGSAOHIT]) {or (m_nCurrentAction = CM_SANJUEHIT) or (m_nCurrentAction = CM_ZHUIXINHIT) or (m_nCurrentAction = CM_DUANYUEHIT) or (m_nCurrentAction = CM_HENGSAOHIT) todo} then
    Exit;
  m_nCurrentAction := 0;
  m_boLockEndFrame := TRUE;
end;

procedure TActor.CleanCharMapSetting(x, y: Integer);
begin
  g_MySelf.m_nCurrX := x;
  g_MySelf.m_nCurrY := y;
  g_MySelf.m_nRx := x;
  g_MySelf.m_nRy := y;
  m_nOldx := x;
  m_nOldy := y;
  m_nCurrentAction := 0;
  m_nCurrentFrame := -1;
  CleanUserMsgs;
end;

// 实现分行显示说话内容到Saying
procedure TActor.Say(const Message: string;FrontColor,BackColor:TColor);
const
  MAXWIDTH = 150;
var
  I: Integer;
  List, Widths: TStrings;
begin
  m_dwSayTime := GetTickCount;
  m_nSayLineCount := 0;
  m_SayFrontColor := FrontColor;
  m_SayBackColor := BackColor;
  List  :=  TStringList.Create;
  Widths:=  TStringList.Create;
  GetValidStr3(Message,m_sSayNameFix,[':']);
  try
    TuChatMessage.ParseMultiLine(Message, MAXWIDTH, List, Widths);
    for I := 0 to MAXSAY - 1 do
    begin
      if I < List.Count then
      begin
        m_SayingArr[I]    := List.Strings[I];
        m_SayWidthsArr[I] := StrToInt(Widths.Strings[I]);
        Inc(m_nSayLineCount);
      end
      else
      begin
        m_SayingArr[I]    := '';
        m_SayWidthsArr[I] := 0;
      end;
    end;
  finally
    List.Free;
    Widths.Free;
  end;
end;

{ ============================== NPCActor ============================= }
procedure TNpcActor.CalcActorFrame;
var
  pm: pTMonsterAction;
begin
  m_boUseMagic := FALSE;
  m_nCurrentFrame := -1;
  m_nBodyOffset := GetNpcOffset(m_wAppearance);
  // npc为50
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    Exit;
  m_btDir := m_btDir mod 3;
  case m_nCurrentAction of
    SM_TURN:
      begin // 转向
        if g_boNpcWalk then
          Exit;
        if m_wAppearance in [56, 59, 63..69, 72..74, 79, 81..86, 87, 91, 108, 112..126] then
        begin // 卧龙笔记NPC
          m_nStartFrame := pm.ActStand.start; // + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
          m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
          m_dwFrameTime := pm.ActStand.ftime;
          m_dwStartTime := GetTickCount;
          m_nDefFrameCount := pm.ActStand.frame;
          Shift(m_btDir, 0, 0, 1);
          if m_wAppearance in [56, 72 .. 74, 79, 81..86, 108,112..117,124,126] then
            m_boUseEffect := FALSE
          else
            m_boUseEffect := TRUE;
          if m_boUseEffect then
          begin
            case m_wAppearance of
              59: m_nEffectStart := pm.ActStand.start + 180;
              87: m_nEffectStart  := pm.ActStand.start + 10;
              91: m_nEffectStart := pm.ActStand.start + 20;
              118,119,120:  m_nEffectStart  :=  pm.ActStand.start + 10;
              122,123:  m_nEffectStart  :=  pm.ActStand.start + 20;
              125:  m_nEffectStart  :=  pm.ActStand.start + 10;
              else
                m_nEffectStart := pm.ActStand.start + 4;
            end;
            m_nEffectFrame := m_nEffectStart;
            case m_wAppearance of
              91:
              begin
                m_nEffectEnd := m_nEffectStart + 20 - 1;
                m_dwEffectStartTime := GetTickCount();
                m_dwEffectFrameTime := pm.ActStand.ftime;
              end;
              87:
              begin
                m_nEffectEnd := m_nEffectStart + 20 - 9;
                m_dwEffectStartTime := GetTickCount();
                m_dwEffectFrameTime := pm.ActStand.ftime;
              end;
              118..120:
              begin
                m_nEffectEnd := m_nEffectStart + 20 - 5;
                m_dwEffectStartTime := GetTickCount();
                m_dwEffectFrameTime := pm.ActStand.ftime;
              end;
              122, 123:
              begin
                m_nEffectEnd := m_nEffectStart + 10 - 2;
                m_dwEffectStartTime := GetTickCount();
                m_dwEffectFrameTime := pm.ActStand.ftime;
              end;
              125:
              begin
                m_nEffectEnd := m_nEffectStart + 20 - 5;
                m_dwEffectStartTime := GetTickCount();
                m_dwEffectFrameTime := pm.ActStand.ftime;
              end
              else
              begin
                m_nEffectEnd := m_nEffectStart + 3;
                m_dwEffectStartTime := GetTickCount();
                m_dwEffectFrameTime := 600;
              end;
            end;
          end;
        end
        else
        begin
          m_nStartFrame := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
          m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
          m_dwFrameTime := pm.ActStand.ftime;
          m_dwStartTime := GetTickCount;
          m_nDefFrameCount := pm.ActStand.frame;
          Shift(m_btDir, 0, 0, 1);
          case m_wAppearance of
            33,34:
            begin
              if not m_boUseEffect then
              begin
                m_boUseEffect := TRUE;
                m_nEffectFrame := m_nEffectStart;
                m_nEffectEnd := m_nEffectStart + 9;
                m_dwEffectStartTime := GetTickCount();
                m_dwEffectFrameTime := 300;
              end;
            end;
            42..47:
            begin
              m_nStartFrame := 20;
              m_nEndFrame := 10;
              m_boUseEffect := TRUE;
              m_nEffectStart := 0;
              m_nEffectFrame := 0;
              m_nEffectEnd := 19;
              m_dwEffectStartTime := GetTickCount();
              m_dwEffectFrameTime := 100;
            end;
            51:
            begin
              m_boUseEffect := TRUE;
              m_nEffectStart := 60;
              m_nEffectFrame := m_nEffectStart;
              m_nEffectEnd := m_nEffectStart + 7;
              m_dwEffectStartTime := GetTickCount();
              m_dwEffectFrameTime := 500;
            end;
            110:
            begin
              m_boUseEffect :=  True;
              m_nEffectStart  := pm.ActStand.start + 4;
              m_nEffectFrame := m_nEffectStart;
              m_nEffectEnd := m_nEffectStart + 3;
              m_dwEffectStartTime := GetTickCount();
              m_dwEffectFrameTime := pm.ActStand.ftime;
            end;
          end;
        end;
      end;
    SM_HIT:
      begin // 攻击
        if g_boNpcWalk then
          Exit;
        case m_wAppearance of
          33, 34, 52, 56, 59, 63, 64..69, 79, 81..86, 87, 91, 108,112..126 { ,82..84 } :
            begin // 70 卧龙笔记NPC
              if m_wAppearance in [81 .. 86, 64 .. 69, 63, 59, 56, 79, 91, 87, 108,112..126] then
                m_nStartFrame := pm.ActStand.start
              else
                m_nStartFrame := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
              m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
              m_dwStartTime := GetTickCount;
              m_nDefFrameCount := pm.ActStand.frame;
            end;
        else
          begin
            m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
            m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
            m_dwFrameTime := pm.ActAttack.ftime;
            m_dwStartTime := GetTickCount;
            if m_wAppearance = 51 then
            begin
              m_boUseEffect := TRUE;
              m_nEffectStart := 60;
              m_nEffectFrame := m_nEffectStart;
              m_nEffectEnd := m_nEffectStart + 7;
              m_dwEffectStartTime := GetTickCount();
              m_dwEffectFrameTime := 500;
            end
            else if m_wAppearance = 111 then
            begin
              m_nStartFrame := pm.ActAttack.start;
              m_nEndFrame := m_nStartFrame + 22;
              m_dwFrameTime := 150;
              m_dwStartTime := GetTickCount;
            end
            else if m_wAppearance in [72..74] then
            begin
              m_nStartFrame := pm.ActAttack.start;
              m_nEndFrame := m_nStartFrame + pm.ActStand.frame;
            end;
          end;
        end;
      end;
    SM_DIGUP:
      begin
        if m_wAppearance = 52 then
        begin
          m_bo248 := TRUE;
          m_dwUseEffectTick := GetTickCount + 23000;
          Randomize;
          g_SoundManager.DXPlaySound(Random(7) + 146);
          m_boUseEffect := TRUE;
          m_nEffectStart := 60;
          m_nEffectFrame := m_nEffectStart;
          m_nEffectEnd := m_nEffectStart + 11;
          m_dwEffectStartTime := GetTickCount();
          m_dwEffectFrameTime := 100;
        end;
      end;
    SM_NPCWALK:
      begin // NPC走动
        if m_wAppearance = 71 then
        begin
          m_nStartFrame := 4250;
          m_nEndFrame := m_nStartFrame + 79;
          m_nCurrentFrame := -1;
          m_dwFrameTime := 80;
          m_dwStartTime := GetTickCount;
          g_boNpcWalk := TRUE;
        end;
      end;
  end;
end;

constructor TNpcActor.Create;
begin
  inherited;
  m_EffSurface := nil;
  m_bo248 := FALSE;
  m_boNpcWalkEffect := FALSE;
  m_boNpcWalkEffectSurface := nil;
  m_StatuarySurface :=  nil;
  m_StatuaryEffectSurface :=  nil;
  m_WeaponSurface :=  nil;
  m_WeaponSurface_L := nil;
  m_HairSurface   :=  nil;

  g_boNpcWalk := FALSE;
  m_nNameColor := clLime;
  m_boEffigy  :=  False;
  m_nEffigyX  :=  0;
  m_nEffigyY  :=  0;
end;

// 画NPC 人物自身图
procedure TNpcActor.DrawBlood(dsurface: TAsphyreCanvas);
var
  d: TAsphyreLockableTexture;
  rc: TRect;
begin

  if g_Config.Assistant.ShowBlood then
  begin
    if not m_boDeath then
    begin
      d := g_77Images.Images[1];
      if d <> nil then
        dsurface.Draw(GetSayX() - d.Width div 2, GetSayY() - 4 - d.Height, d);
      d := g_77Images.Images[3];
      if d <> nil then
      begin
        rc := d.ClientRect;
        if m_Abil.MaxHP > 0 then
          rc.Right := Round((rc.Right - rc.Left) / m_Abil.MaxHP * m_Abil.HP);
        dsurface.Draw(GetSayX() - d.Width div 2, GetSayY() - 4 - d.Height, rc, d, TRUE);
      end;
    end;
  end;
end;

procedure TNpcActor.DrawChr(dsurface: TAsphyreCanvas; dx, dy: Integer; blend, boFlag: Boolean);
var
  ceff: TColorEffect;
  d: TAsphyreLockableTexture;
begin
  m_btDir := m_btDir mod 3;
  if GetTickCount - m_dwLoadSurfaceTime > (FREE_TEXTURE_TIME div 2) then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  if m_boEffigy then
  begin
    if (m_nEffigyOffset >= 0) and (m_nEffigyOffset <= 887) then
    begin
      case m_btJob of
        _JOB_CIK : m_nWpord := WORDER_CKL[m_btSex, m_nEffigyOffset];
        _JOB_ARCHER :m_nWpord := WORDER_ARCHER[m_btSex, m_nEffigyOffset];
        else
        m_nWpord := WORDER[m_btSex, m_nEffigyOffset];
      end;
       m_nLWpord := WORDER_CKR[m_btSex, m_nEffigyOffset];
    end;
    if m_EffigySurface <> nil then
      DrawEffSurface(dsurface, m_EffigySurface, dx + m_nShiftX + m_nEffigyX, dy + m_nShiftY + m_nEffigyY, blend, ceNone);
    if (m_btWeapon >= 2) and not blend then
    begin
      if (m_nWpord = 0) and (m_WeaponSurface <> nil) then
      begin
        if m_WeaponEffectSurface <> nil then
          dsurface.DrawBlend(dx + m_nWepx + m_nShiftX,  dy + m_nWepy + m_nShiftY - 72 - m_nEffigyY, m_WeaponEffectSurface, 1);
        DrawWeaponSurface(dsurface, m_WeaponSurface, dx + m_nWpx + m_nShiftX, dy + m_nWpy + m_nShiftY - 72 - m_nEffigyY, blend, ceNone);
      end;
      if (m_nLWpord = 0) and (m_WeaponSurface_L <> nil) then
        DrawWeaponSurface(dsurface, m_WeaponSurface_L, dx + m_nWLPx + m_nShiftX, dy + m_nWLPy + m_nShiftY - 72 - m_nEffigyY, blend, ceNone);
    end;

    if m_BodySurface <> nil then
      DrawBodySurface(dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY - 72 - m_nEffigyY, blend, ceNone);
    if m_HairSurface <> nil then
      DrawEffSurface(dsurface, m_HairSurface, dx + m_nHpx + m_nShiftX, dy + m_nHpy + m_nShiftY - 72 - m_nEffigyY, blend, ceNone);

    if (m_btWeapon >= 2) {and not blend} then
    begin
      if (m_nWpord = 1) and (m_WeaponSurface <> nil) then
      begin
        if m_WeaponEffectSurface <> nil then
          dsurface.DrawBlend(dx + m_nWepx + m_nShiftX,  dy + m_nWepy + m_nShiftY - 72 - m_nEffigyY, m_WeaponEffectSurface, 1);
        DrawWeaponSurface(dsurface, m_WeaponSurface, dx + m_nWpx + m_nShiftX, dy + m_nWpy + m_nShiftY - 72 - m_nEffigyY, blend, ceNone);
      end;
      if (m_nLWpord = 1) and (m_WeaponSurface_L <> nil) then
        DrawWeaponSurface(dsurface, m_WeaponSurface_L, dx + m_nWLPx + m_nShiftX, dy + m_nWLPy + m_nShiftY - 72 - m_nEffigyY, blend, ceNone);
    end;

    if m_HumWinSurface <> nil then
      dsurface.DrawBlend(dx + m_nSpx + m_nShiftX, dy + m_nSpy + m_nShiftY - 72 - m_nEffigyY, m_HumWinSurface, 1);
  end
  else
  begin
    ceff := GetDrawEffectValue;
    if m_BodySurface <> nil then
    begin
      if m_wAppearance in [81..85] then
      begin // 雪域NPC
        dsurface.DrawBlend(dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, m_BodySurface, 1);
      end
      else if m_wAppearance = 51 then
      begin // 酒馆老板娘
        DrawBodySurface(dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, TRUE, ceff);
      end
      else
      begin
        DrawBodySurface(dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, blend, ceff);
      end;
      m_BodyEffect.DrawEffect(DSurface, dx + m_nShiftX, dy + m_nShiftY);
    end;
    if m_boNpcWalkEffect then
    begin // 画酒馆2卷 老板娘效果(走出门帘的光)
      if m_boNpcWalkEffectSurface <> nil then
      begin
        dsurface.DrawBlend(dx + m_nNpcWalkEffectPx + m_nShiftX, dy + m_nNpcWalkEffectPy + m_nShiftY, m_boNpcWalkEffectSurface, 1);
      end;
    end;
  end;
end;

procedure TNpcActor.DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer);
begin
  if m_boUseEffect and (m_EffSurface <> nil) then
  begin
    dsurface.DrawBlend(dx + m_nEffX + m_nShiftX, dy + m_nEffY + m_nShiftY, m_EffSurface, 1);
  end;
end;

function TNpcActor.GetDefaultFrame(wmode: Boolean): Integer;
var
  cf: Integer;
  pm: pTMonsterAction;
begin
  Result := 0;
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    Exit;
  m_btDir := m_btDir mod 3; // NPC只有3个方向（如商人）

  if m_nCurrentDefFrame < 0 then
    cf := 0
  else if m_nCurrentDefFrame >= pm.ActStand.frame then
    cf := 0
  else
    cf := m_nCurrentDefFrame;
  if m_wAppearance in [56, 59, 63, 64..69, 72..74, 79, 81..86, 87, 91, 108,112..126] then // 卧龙笔记NPC
    Result := pm.ActStand.start + cf
  else
    Result := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip) + cf;
end;

procedure TNpcActor.LoadSurface;
var
  AImages: TWMImages;
begin
  if m_boEffigy then
  begin
    m_EffigySurface :=  g_77Images.GetCachedImage(352, m_nEffigyX, m_nEffigyY);
    m_BodySurface   :=  GetWHumImg(m_btJob, m_btSex, m_btDress, m_nEffigyOffset, m_nPx, m_nPy);
    m_WeaponSurface :=  GetWWeaponImg(m_btJob, m_btSex, m_btWeapon, m_nEffigyOffset, m_nWpx, m_nWpy);
    m_WeaponSurface_L := GetWLWeaponImg(m_btJob, m_btSex, m_btWeapon, m_nEffigyOffset, m_nWLPx, m_nWLPy);
    m_HairSurface   :=  GetHumHairImg(m_btJob, m_btSex, m_btHair, m_nEffigyOffset, m_nHpx, m_nHpy);

    m_WeaponEffectSurface := nil;
    if m_WeponOuterEffect <> nil then
      m_WeaponEffectSurface := m_WeponOuterEffect.GetImage(m_nEffigyOffset, m_nWepx, m_nWepy)
    else if m_nWeaponEffect > 0 then
      m_WeaponEffectSurface := GetWWeaponWinImage(m_btJob, m_btSex, m_nWeaponEffect, m_nEffigyOffset, m_nWepx, m_nWepy);
    m_HumWinSurface :=  nil;
    if m_OuterEffect <> nil then
      m_HumWinSurface := m_OuterEffect.GetImage(m_nEffigyOffset, m_nSpx, m_nSpy)
    else if m_btEffect > 0 then
      m_HumWinSurface := GetWHumWinImage(m_btJob, m_btSex, m_btEffect, m_nEffigyOffset, m_nSpx, m_nSpy);
    Exit;
  end;

  AImages := GetNpcImg(m_wAppearance);
  if (m_wAppearance = 71) and g_boNpcWalk then
  begin // 老板娘
    m_BodySurface := AImages.GetCachedImage(m_nCurrentFrame, m_nPx, m_nPy); // 取图
    if m_boNpcWalkEffect then // 取门帘光的图 20080621
      m_boNpcWalkEffectSurface := AImages.GetCachedImage(m_nCurrentFrame + 79, m_nNpcWalkEffectPx, m_nNpcWalkEffectPy); // 取图
  end
  else
    m_BodySurface := AImages.GetCachedImage(m_nBodyOffset + m_nCurrentFrame, m_nPx, m_nPy);

  if m_wAppearance in [42 .. 47] then
    m_BodySurface := nil;
  if m_boUseEffect then
  begin
    m_EffSurface := AImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
    case m_wAppearance of
      42:
      begin
        m_nEffX := m_nEffX + 71;
        m_nEffY := m_nEffY + 5;
      end;
      43:
      begin
        m_nEffX := m_nEffX + 71;
        m_nEffY := m_nEffY + 37;
      end;
      44:
      begin
        m_nEffX := m_nEffX + 7;
        m_nEffY := m_nEffY + 12;
      end;
      45:
      begin
        m_nEffX := m_nEffX + 6;
        m_nEffY := m_nEffY + 12;
      end;
      46:
      begin
        m_nEffX := m_nEffX + 7;
        m_nEffY := m_nEffY + 12;
      end;
      47:
      begin
        m_nEffX := m_nEffX + 8;
        m_nEffY := m_nEffY + 12;
      end;
    end;
  end;
end;

procedure TNpcActor.NameTextOut(dsurface: TAsphyreCanvas; dx, dy: Integer);
var
  ATexture: TuTexture;
begin
  if g_Config.Assistant.ShowNPCName then
  begin
    if g_FocusCret = Self then Exit;
    ATexture  :=  Textures.ObjectName(DSurface, m_sDescUserName + '\' + m_sUserName);
    if ATexture <> nil then
      ATexture.Draw(dsurface, g_ClientCustomSetting.ActorNameShowXOffset + dx - ATexture.Width div 2, g_ClientCustomSetting.ActorNameShowYOffset + dy{ - ATexture.Height div 2}, m_nNameColor);
  end;
end;

procedure TNpcActor.Run;
var
  nEffectFrame:      Integer;
  dwEffectFrameTime: Longword;
begin
  inherited Run;
  if (m_wAppearance = 71) and g_boNpcWalk then
  begin
    if not m_boNpcWalkEffect then
    begin
      if m_nCurrentFrame = 4297 then
        m_boNpcWalkEffect := TRUE;
    end;

    if m_nCurrentFrame >= m_nEndFrame then
    begin
      g_boNpcWalk := FALSE;
      m_boNpcWalkEffect := FALSE;
      SendMsg(SM_TURN, m_nCurrX, m_nCurrY, m_btDir, m_nFeature, m_nState, 0, 0, '', 0); // 转向
    end;
  end;

  nEffectFrame := m_nEffectFrame;
  if m_boUseEffect then
  begin // NPC是否使用了魔法类
    if m_boUseMagic then
    begin
      dwEffectFrameTime := Round(m_dwEffectFrameTime / 3);
    end
    else
      dwEffectFrameTime := m_dwEffectFrameTime;

    if GetTickCount - m_dwEffectStartTime > dwEffectFrameTime then
    begin
      m_dwEffectStartTime := GetTickCount();
      if m_nEffectFrame < m_nEffectEnd then
      begin
        Inc(m_nEffectFrame);
      end
      else
      begin
        if m_bo248 then
        begin
          if GetTickCount > m_dwUseEffectTick then
          begin
            m_boUseEffect := FALSE;
            m_bo248 := FALSE;
            m_dwUseEffectTick := GetTickCount();
          end;
          m_nEffectFrame := m_nEffectStart;
        end
        else
          m_nEffectFrame := m_nEffectStart;
        m_dwEffectStartTime := GetTickCount();
      end;
    end;
  end;
  if nEffectFrame <> m_nEffectFrame then
  begin // 魔法桢
    m_dwLoadSurfaceTime := GetTickCount();
    LoadSurface();
  end;
end;

procedure TNpcActor.SetEffigyState(nEffigyProperties, nEffigyFeature, nEffigyFeatureEx, nEffigyOffset: Integer);
begin
  m_btJob := LoWord(nEffigyOffset);
  m_nEffigyOffset := HiWord(nEffigyOffset);
  m_nEffigyState := nEffigyFeature;  //Feature
  m_boEffigy :=  m_nEffigyState > -1;
  if not m_boEffigy then
  begin
    m_StatuarySurface	:=	nil;
    m_StatuaryEffectSurface	:=	nil;
    m_EffigySurface := nil;
    m_BodySurface   := nil;
    m_WeaponSurface := nil;
    m_WeaponSurface_L := nil;
    m_HairSurface   := nil;
    m_WeaponEffectSurface := nil;
    m_HumWinSurface :=  nil;
  end
  else
  begin
    m_btHair := HAIRfeature(nEffigyProperties); // 得到M2发来对应的发型 , 女=7 男=6 主体,英雄 女=3 男=4
    m_btSex := LoByte(HiWord(nEffigyProperties));//m_btHair mod 2;
    m_btDress := DRESSfeature(m_nEffigyState);//DRESSfeature(m_nEffigyState) * 2 + m_btSex;
    case m_btDress of
      RES_IMG_BASE..RES_IMG_MAX: m_btEffect := m_btDress;
      else
      begin
        m_btDress := m_btDress * 2 + m_btSex;
        m_btEffect :=  DressEffectfeature(nEffigyFeatureEx);
        if m_btEffect >= 1000 then
          UIWindowManager.TryGetItemOuterEffect(m_btEffect - 1000, m_OuterEffect);
      end;
    end;

    m_btWeapon := WEAPONfeature(m_nEffigyState);
    case m_btWeapon of
      RES_IMG_BASE..RES_IMG_MAX: m_nWeaponEffect := m_btWeapon;
      else
      begin
        m_btWeapon := m_btWeapon * 2 + m_btSex;
        m_nWeaponEffect :=  WeponEffectfeature(nEffigyFeatureEx);
        if m_nWeaponEffect > 1000 then
          UIWindowManager.TryGetItemOuterEffect(m_nWeaponEffect - 1000, m_WeponOuterEffect)
      end;
    end;

    m_nWeaponEffect :=  WeponEffectfeature(nEffigyFeatureEx);
    CalcHairImageOffset;
    LoadSurface;
  end;
end;

{ ============================== HUMActor ============================= }

function THumActor.CheckMoveTime(ALastMoveTick: LongWord): Boolean;
begin
  Result := False;
   if m_boBloodRush then
   begin
     Result := True;
     Exit;
   end;

   if g_MySelf = Self then
   begin
     //自身移动帧率 时间延长 5%
      case m_nCurrentAction of
        SM_WALK, SM_SNEAK:
        begin
          Result := TimeGetTime - ALastMoveTick >= Ceil((g_GameData.WalkTime.Data * 1.05) / (m_nEndFrame - m_nStartFrame + 1));
        end;
        SM_RUN, SM_HORSERUN, SM_ZHUIXINHIT, SM_RUSHKUNG:
        begin
          Result := TimeGetTime - ALastMoveTick >= Ceil((g_GameData.RunTime.Data * 1.05) / (m_nEndFrame - m_nStartFrame + 1));
        end;
        SM_RUSH:
        begin
          Result := TimeGetTime - ALastMoveTick >= Ceil((g_GameData.WalkTime.Data / 2 ) / (m_nEndFrame - m_nStartFrame + 1));
        end
        else
        begin
          Result := TimeGetTime - ALastMoveTick >= TIME_MOVEOBJECTS;
        end;
      end;
   end else
   begin
      //这里调整为0.9以便减少 移动时间
      case m_nCurrentAction of
        SM_WALK, SM_SNEAK:
        begin
          Result := TimeGetTime - ALastMoveTick >= Ceil((g_GameData.WalkTime.Data * 0.9) / (m_nEndFrame - m_nStartFrame + 1));
        end;
        SM_RUN, SM_HORSERUN, SM_ZHUIXINHIT, SM_RUSHKUNG:
        begin
          Result := TimeGetTime - ALastMoveTick >= Ceil((g_GameData.RunTime.Data * 0.9) / (m_nEndFrame - m_nStartFrame + 1));
        end;
        SM_RUSH:
        begin
          Result := TimeGetTime - ALastMoveTick >= Ceil((g_GameData.WalkTime.Data / 2 * 0.9) / (m_nEndFrame - m_nStartFrame + 1));
        end
        else
        begin
          Result := TimeGetTime - ALastMoveTick >= TIME_MOVEOBJECTS;
        end;
      end;
   end;
end;

constructor THumActor.Create;
begin
  inherited Create;
  m_HairSurface := nil;
  m_WeaponSurface := nil;
  m_WeaponSurface_L := nil;
  m_HumWinSurface := nil;
  m_WeaponEffectSurface_L := nil;
  m_boWeaponEffect := FALSE;
  // m_boMagbubble4      := False; //20080811
  m_dwFrameTime := 150;
  m_dwFrameTick := GetTickCount();
  m_nFrame := 0;
  m_btReLevel := 0;
end;

destructor THumActor.Destroy;
begin
  inherited Destroy;
end;

procedure THumActor.CalcActorFrame;
var
  AClient: TuMagicClient;
  AProperties: TuCustomMagicEffectProperties;
  HA : pTHumanAction;
  meff : TMagicEff;
  nX,nY:Integer;
begin
  m_boUseMagic := FALSE;
  m_nCurrentFrame := -1;
  m_boBloodRush := False;
  CalcHairImageOffset;

  if m_boChangeToMonster then
  begin
    m_nBodyOffset := GetOffset(m_wAppearance);
    HA := @m_ChangeToMonsterAct;
  end else
  begin
    m_nBodyOffset := GetHumOffset(m_btJob, m_btDress);
    HA := @uActionsMgr.HA;
  end;
//  ConsoleDebug('CalcActor' + IntToStr(m_nCurrentAction));
  case m_nCurrentAction of
    SM_TURN: // 转
      begin
        m_nStartFrame := HA.ActStand.start + m_btDir * (HA.ActStand.frame + HA.ActStand.skip);
        m_nEndFrame := m_nStartFrame + HA.ActStand.frame - 1;
        m_dwFrameTime := HA.ActStand.ftime;
        m_dwStartTime := GetTickCount;
        m_nDefFrameCount := HA.ActStand.frame;
        Shift(m_btDir, 0, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    SM_WALK, SM_BACKSTEP, SM_BATTERBACKSTEP:
      begin
        m_nStartFrame := HA.ActWalk.start + m_btDir * (HA.ActWalk.frame + HA.ActWalk.skip);
        m_nEndFrame := m_nStartFrame + HA.ActWalk.frame - 1;

        m_dwFrameTime := Ceil(g_GameData.WalkTime.Data / (m_nEndFrame - m_nStartFrame + 1));
        m_dwStartTime := GetTickCount;
        m_nCurTick := 0;
        // WarMode := FALSE;
        m_nMoveStep := 1;
        if m_nCurrentAction = SM_BATTERBACKSTEP then
        begin
          m_nMoveStep := m_nBatterMoveStep;
          m_nCurrX := m_nBatterX;
          m_nCurrY := m_nBatterY;
          m_btDir := m_nBatterdir;
        end;
        if m_nCurrentAction = SM_BACKSTEP then
          Shift(GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1)
        else
          Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    SM_SNEAK:
      begin
        m_nStartFrame := HA.ActSneak.start + m_btDir * (HA.ActSneak.frame + HA.ActSneak.skip);
        m_nEndFrame := m_nStartFrame + HA.ActSneak.frame - 1;
        m_dwFrameTime := GetWalkFrameTime(HA.ActSneak.ftime);
        m_dwStartTime := GetTickCount;
        m_nCurTick := 0;
        m_nMoveStep := 1;
        if m_nCurrentAction = SM_BACKSTEP then // 转身
          Shift(GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1)
        else
          Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    SM_RUSH: // 跑动中改变方向
      begin
        if m_btJob = _JOB_CIK then
        begin
          nX := 20;
        end else
        begin
          nX := HA.ActRushLeft.ftime;
        end;

        if m_nRushDir = 0 then
        begin
          m_nRushDir := 1;
          m_nStartFrame := HA.ActRushLeft.start + m_btDir * (HA.ActRushLeft.frame + HA.ActRushLeft.skip);
          m_nEndFrame := m_nStartFrame + HA.ActRushLeft.frame - 1;
          m_dwFrameTime := nX;
          m_dwStartTime := GetTickCount;
          m_nCurTick := 0;
          m_nMoveStep := 1;
          Shift(m_btDir, 1, 0, m_nEndFrame - m_nStartFrame + 1);
        end
        else
        begin
          m_nRushDir := 0;
          m_nStartFrame := HA.ActRushRight.start + m_btDir * (HA.ActRushRight.frame + HA.ActRushRight.skip);
          m_nEndFrame := m_nStartFrame + HA.ActRushRight.frame - 1;
          m_dwFrameTime := nX;
          m_dwStartTime := GetTickCount;
          m_nCurTick := 0;
          m_nMoveStep := 1;
          Shift(m_btDir, 1, 0, m_nEndFrame - m_nStartFrame + 1);
        end;
      end;
    SM_BloodRush:
      begin
        m_boBloodRush := True;
        m_nStartFrame := HA.ActRun.start + m_btDir * (HA.ActRun.frame + HA.ActRun.skip);
        m_nEndFrame := -1;
        m_dwFrameTime := 100;
        m_dwStartTime := GetTickCount;
        m_nCurTick := 0;
        if Self = g_MySelf then
          m_nBloodRushSpeed := 50
        else
          m_nBloodRushSpeed := 40;
        m_dwBloodRushStart := m_dwStartTime;
        m_nCurrentFrame := m_nStartFrame;
        LoadSurface();
      end;
    SM_BLOODRUSHHIT:
      begin
        m_nStartFrame := HA.ActSpell.start + m_btDir * (HA.ActSpell.frame + HA.ActSpell.skip);
        m_nEndFrame := m_nStartFrame + HA.ActSpell.frame - 1;
        m_dwFrameTime := GetHitFrameTime(80);
        m_dwStartTime := GetTickCount;
        m_boWarMode := TRUE;
        m_dwWarModeTime := GetTickCount;
        meff := TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagicCk_NsImage,4*m_btDir + 1040,4,80,true);
        PlayScene.m_EffectList.Add(meff);

        nX := m_nCurrX;
        nY := m_nCurrY;
        GetNextPosXY(m_btDir,nX,nY);
        meff := TNormalDrawEffect.Create(nX,nY,g_WMagicCk_NsImage,1030,4,80,true);
        meff.m_dwStartWorkTick := GetTickCount + 300;
        PlayScene.m_EffectList.Add(meff);
      end;
    SM_RUSHKUNG: // 野蛮冲撞
      begin
        m_nStartFrame := HA.ActRun.start + m_btDir * (HA.ActRun.frame + HA.ActRun.skip);
        m_nEndFrame := m_nStartFrame + HA.ActRun.frame - 1;
        m_dwFrameTime := GetRunFrameTime(HA.ActRun.ftime);
        m_dwStartTime := GetTickCount;
        m_nCurTick := 0;
        m_nMoveStep := 1;
        Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
//     SM_BACKSTEP:
//      begin
//      m_nStartFrame := HA.ActWalk.start + (HA.ActWalk.frame - 1) + m_btDir * (HA.ActWalk.frame + HA.ActWalk.skip);
//      m_nEndFrame := m_nStartFrame - (HA.ActWalk.frame - 1);
//      m_dwFrameTime := HA.ActWalk.ftime;
//      m_dwStartTime := GetTickCount;
//      m_nCurTick := 0;
//      m_nMoveStep := 1;
//      Shift (GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1);
//      end;
    SM_SITDOWN:
      begin
        m_nStartFrame := HA.ActSitdown.start + m_btDir * (HA.ActSitdown.frame + HA.ActSitdown.skip);
        m_nEndFrame := m_nStartFrame + HA.ActSitdown.frame - 1;
        m_dwFrameTime := GetWalkFrameTime(HA.ActSitdown.ftime);
        m_dwStartTime := GetTickCount;
      end;
    SM_RUN:
      begin
        m_nStartFrame := HA.ActRun.start + m_btDir * (HA.ActRun.frame + HA.ActRun.skip);
        m_nEndFrame := m_nStartFrame + HA.ActRun.frame - 1;
        m_dwFrameTime := GetRunFrameTime(HA.ActRun.ftime);
        m_dwStartTime := GetTickCount;
        m_nCurTick := 0;
        // WarMode := FALSE;
        if m_nCurrentAction = SM_RUN then
          m_nMoveStep := 2
        else
          m_nMoveStep := 1;

        // m_nMoveStep := 2;
        Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
      SM_HORSERUN:
      begin
        m_nStartFrame := HA.ActRun.start + m_btDir * (HA.ActRun.frame + HA.ActRun.skip);
        m_nEndFrame := m_nStartFrame + HA.ActRun.frame - 1;
        m_dwFrameTime := GetRunFrameTime(HA.ActRun.ftime);
        m_dwStartTime := GetTickCount;
        m_nCurTick := 0;
        //WarMode := FALSE;
        if m_nCurrentAction = SM_HORSERUN then
          m_nMoveStep := 3
        else
          m_nMoveStep := 1;
        //m_nMoveStep := 2;
        Shift (m_btDir, m_nMoveStep, 0, m_nEndFrame-m_nStartFrame+1);
      end;
    SM_HIT:
      begin
        //TODO 攻击动作
        m_nStartFrame := HA.ActHit.start + m_btDir * (HA.ActHit.frame + HA.ActHit.skip);
        m_nEndFrame := m_nStartFrame + HA.ActHit.frame - 1;
        m_dwFrameTime := GetHitFrameTime(HA.ActHit.ftime);
        m_dwStartTime := GetTickCount;
        m_boWarMode := TRUE;
        m_dwWarModeTime := GetTickCount;
        if g_MagicMgr.TryGet(m_nHitMagic, AClient) then
        begin
          case AClient.ActionType of
            atSpell:
            begin
              m_nStartFrame := HA.ActSpell.start + m_btDir * (HA.ActSpell.frame + HA.ActSpell.skip);
              m_nEndFrame := m_nStartFrame + HA.ActSpell.frame - 1;
              m_dwFrameTime := GetHitFrameTime(HA.ActSpell.ftime);
            end;
            atHit:
            begin
              m_nStartFrame := HA.ActHit.start + m_btDir * (HA.ActHit.frame + HA.ActHit.skip);
              m_nEndFrame := m_nStartFrame + HA.ActHit.frame - 1;
              m_dwFrameTime := GetHitFrameTime(HA.ActHit.ftime);
            end;
            atCircinate:
            begin
              m_nStartFrame := HA.ActCircinate.start + m_btDir * (HA.ActCircinate.frame + HA.ActCircinate.skip);
              m_nEndFrame := m_nStartFrame + HA.ActCircinate.frame - 1;
              m_dwFrameTime := GetHitFrameTime(HA.ActCircinate.ftime);
            end;
            atFireDragon:
            begin
              m_nStartFrame := HA.ActFireDragon.start + m_btDir * (HA.ActFireDragon.frame + HA.ActFireDragon.skip);
              m_nEndFrame := m_nStartFrame + HA.ActFireDragon.frame - 1;
              m_dwFrameTime := GetHitFrameTime(HA.ActFireDragon.ftime);
            end;
            atSpurn:
            begin
              m_nStartFrame := HA.ActSpurn.start + m_btDir * (HA.ActSpurn.frame + HA.ActSpurn.skip);
              m_nEndFrame := m_nStartFrame + HA.ActSpurn.frame - 1;
              m_dwFrameTime := GetHitFrameTime(HA.ActSpurn.ftime);
            end;
            atSneak:
            begin
              m_nStartFrame := HA.ActSneak.start + m_btDir * (HA.ActSneak.frame + HA.ActSneak.skip);
              m_nEndFrame := m_nStartFrame + HA.ActSneak.frame - 1;
              m_dwFrameTime := GetWalkFrameTime(HA.ActSneak.ftime);
            end;
            atShamanHit:
            begin
              m_nStartFrame := HA.ActShamanHit.start + m_btDir * (HA.ActShamanHit.frame + HA.ActShamanHit.skip);
              m_nEndFrame := m_nStartFrame + HA.ActShamanHit.frame - 1;
              m_dwFrameTime := GetHitFrameTime(HA.ActShamanHit.ftime);
            end;
            atShamanPush:
            begin
              m_nStartFrame := HA.ActShamanPush.start + m_btDir * (HA.ActShamanPush.frame + HA.ActShamanPush.skip);
              m_nEndFrame := m_nStartFrame + HA.ActShamanPush.frame - 1;
              m_dwFrameTime := GetHitFrameTime(HA.ActShamanPush.ftime);
            end;
          end;
        end
        else
        begin
          case m_nHitMagic of
            SKILL_159: //刺客暴击术
            begin
              if not IsMirReturnClient then
              begin
                m_nStartFrame := HA.ActSpell.start + m_btDir * (HA.ActSpell.frame + HA.ActSpell.skip);
                m_nEndFrame := m_nStartFrame + HA.ActSpell.frame - 1;
                m_dwFrameTime := GetHitFrameTime(80);
                m_dwStartTime := GetTickCount;
                m_boWarMode := TRUE;
                m_dwWarModeTime := GetTickCount;
                nX := m_nCurrX;
                nY := m_nCurrY;
                GetNextPosXY(m_btDir,nX,nY);

                meff := TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagicCk_NsImage,m_btDir * 10 + 880,4,80,true);
                PlayScene.m_EffectList.Add(meff);
                meff := TNormalDrawEffect.Create(nX,nY,g_WMagicCk_NsImage,870,4,100,true);
                PlayScene.m_EffectList.Add(meff);
              end else
              begin
                m_nStartFrame := HA.ActJumpHit.start + m_btDir * (HA.ActJumpHit.frame + HA.ActJumpHit.skip);
                m_nEndFrame := m_nStartFrame + HA.ActJumpHit.frame - 1;
                m_dwFrameTime := GetHitFrameTime(80);
                m_dwStartTime := GetTickCount;
                m_boWarMode := TRUE;
                m_dwWarModeTime := GetTickCount;
                nX := m_nCurrX;
                nY := m_nCurrY;
                GetNextPosXY(m_btDir,nX,nY);
                meff := TNormalDrawEffect.Create(nX,nY,g_WMagicCKImages,1302,5,80,true);
                meff.m_dwStartWorkTick := GetTickCount + GetHitFrameTime(80) * 5;
                PlayScene.m_EffectList.Add(meff);
              end;
            end;
            SKILL_74:
            begin
              m_nStartFrame := HA.ActBigHit.start + m_btDir * (HA.ActBigHit.frame + HA.ActBigHit.skip);
              m_nEndFrame := m_nStartFrame + HA.ActBigHit.frame - 1;
              m_dwFrameTime := GetHitFrameTime(HA.ActBigHit.ftime);
              m_dwStartTime := GetTickCount;
              m_boWarMode := TRUE;
              m_dwWarModeTime := GetTickCount;
            end;
            SKILL_76:
            begin
              m_nStartFrame := 160 + m_btDir * (15 + 5);
              m_nEndFrame := m_nStartFrame + 15 - 1;
              //m_dwFrameTime := HA.ActBatter.ftime;
              m_dwWarModeTime := GetTickCount;
              m_dwFrameTime := GetHitFrameTime(HA.ActBatter.ftime);
            end;
            SKILL_79:
            begin
              m_nStartFrame := HA.ActBatter.start + m_btDir * (HA.ActBatter.frame + HA.ActBatter.skip);
              m_nEndFrame := m_nStartFrame + HA.ActBatter.frame - 1;
              m_dwFrameTime := 1000; // HA.ActBatter.ftime;
              m_nMagLight := 2;
              if Self = g_MySelf then
                m_nMoveStep := 0 // 防止假动
              else
              begin
                m_nMoveStep := m_nBatterMoveStep;
                m_nCurrX := m_nBatterZhuiXin.Param1;
                m_nCurrY := m_nBatterZhuiXin.Param2;
              end;
            end;
            SKILL_82:
            begin
              m_nStartFrame := 320 + m_btDir * (6 + 4);
              m_nEndFrame := m_nStartFrame + 6 - 1;
              m_dwFrameTime := GetHitFrameTime(HA.ActBatter.ftime);
            end;
            SKILL_85:
            begin
              m_nStartFrame := 560 + m_btDir * (10 + 0);
              m_nEndFrame := m_nStartFrame + 10 - 1;
              m_dwFrameTime := GetHitFrameTime(HA.ActBatter.ftime);
            end;
            SKILL_69:
            begin
              m_nStartFrame := 400 + m_btDir * (13 + 7);
              m_nEndFrame := m_nStartFrame + 13 - 1;
              m_dwFrameTime := GetHitFrameTime(HA.ActBatter.ftime);
            end;
            SKILL_96:
            begin
              m_nStartFrame := 400 + m_btDir * (13 + 7);
              m_nEndFrame := m_nStartFrame + 13 - 1;
              m_dwFrameTime := GetHitFrameTime(HA.ActBatter.ftime);
            end;

            SKILL_163:  //炎龙波
            begin
              m_nStartFrame := HA.ActHit.start + m_btDir * (HA.ActHit.frame + HA.ActHit.skip);
              m_nEndFrame := m_nStartFrame + HA.ActHit.frame - 1;
              m_dwFrameTime := GetHitFrameTime(HA.ActHit.ftime);
              m_dwStartTime := GetTickCount;
              m_dwWarModeTime := GetTickCount;
              if not IsMirReturnClient then
              begin
                meff := TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagicCk_NsImage,1130 + m_btDir * 6,6,100,true);
                PlayScene.m_EffectList.Add(meff);
              end else
              begin
                meff := TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagicCKImages,1430 + m_btDir * 10,6,100,true);
                PlayScene.m_EffectList.Add(meff);
              end;
            end;

            SKILL_161:   //致残毒药
            begin

              m_nStartFrame := HA.ActHit.start + m_btDir * (HA.ActHit.frame + HA.ActHit.skip);
              m_nEndFrame := m_nStartFrame + HA.ActHit.frame - 1;
              m_dwFrameTime := GetHitFrameTime(HA.ActHit.ftime);
              m_dwStartTime := GetTickCount;
              m_dwWarModeTime := GetTickCount;
              nX := m_nCurrX;
              nY := m_nCurrY;
              GetNextPosXY(m_btDir,nX,nY);
              if not IsMirReturnClient then
              begin
                meff := TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagicCk_NsImage,m_btDir * 5 + 990,5,80,true);
                PlayScene.m_EffectList.Add(meff);
                meff := TNormalDrawEffect.Create(nX,nY,g_WMagicCk_NsImage,980,10,80,true);
                meff.m_dwStartWorkTick := GetTickCount + 350;
                PlayScene.m_EffectList.Add(meff);
              end else
              begin
                meff := TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagicCKImages,m_btDir * 10 + 550,10,80,true);
                PlayScene.m_EffectList.Add(meff);
              end;
            end;
            SKILL_170:
            begin
              m_nStartFrame := HA.ActCircinate.start + m_btDir * (HA.ActCircinate.frame + HA.ActCircinate.skip);
              m_nEndFrame := m_nStartFrame + HA.ActCircinate.frame - 1;
              m_dwFrameTime := GetHitFrameTime(HA.ActCircinate.ftime);
              m_dwStartTime := GetTickCount;
              m_dwWarModeTime := GetTickCount;
              //Shift(m_btDir, 0, 0, 0);
            end;
            SKILL_167: //火镰狂舞
            begin
              m_nStartFrame := HA.ActJumpHit.start + m_btDir * (HA.ActJumpHit.frame + HA.ActJumpHit.skip);
              m_nEndFrame := m_nStartFrame + HA.ActJumpHit.frame - 1;
              m_dwFrameTime := GetHitFrameTime(HA.ActJumpHit.ftime);
              m_dwStartTime := GetTickCount;
              m_dwWarModeTime := GetTickCount;

              if not IsMirReturnClient then
              begin
                meff :=TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagicCk_NsImage,m_btDir * 12 + 690,10,100,true);
                PlayScene.m_EffectList.Add(meff);
              end else
              begin
                meff :=TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagicCKImages,m_btDir * 20 + 1580,12,100,true);
                PlayScene.m_EffectList.Add(meff);
              end;

            end;
            SKILL_43:
            begin
              //SetNextFixedEffect(1,SKILL_43);

            end;
          end;
        end;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_HEAVYHIT:
      begin
        m_nStartFrame := HA.ActHeavyHit.start + m_btDir * (HA.ActHeavyHit.frame + HA.ActHeavyHit.skip);
        m_nEndFrame := m_nStartFrame + HA.ActHeavyHit.frame - 1;
        m_dwFrameTime := GetHitFrameTime(HA.ActHeavyHit.ftime);
        m_dwStartTime := GetTickCount;
        m_boWarMode := TRUE;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_SPELL: // 接收使用魔法消息
      begin
        m_nStartFrame := HA.ActSpell.start + m_btDir * (HA.ActSpell.frame + HA.ActSpell.skip);
        m_nEndFrame := m_nStartFrame + HA.ActSpell.frame - 1;
        m_dwFrameTime := HA.ActSpell.ftime;
        //m_dwFrameTime := Ceil(g_dwSpellTime / (m_nEndFrame - m_nStartFrame + 1));
        m_dwStartTime := GetTickCount;
        m_nCurEffFrame := 0;
        m_boUseMagic := TRUE;
        if g_MagicMgr.TryGet(m_CurMagic.nMagicId, AClient) then
        begin
          case AClient.ActionType of
            atSpell:
            begin
              m_nStartFrame := HA.ActSpell.start + m_btDir * (HA.ActSpell.frame + HA.ActSpell.skip);
              m_nEndFrame := m_nStartFrame + HA.ActSpell.frame - 1;
              m_dwFrameTime := HA.ActSpell.ftime;
            end;
            atHit:
            begin
              m_nStartFrame := HA.ActHit.start + m_btDir * (HA.ActHit.frame + HA.ActHit.skip);
              m_nEndFrame := m_nStartFrame + HA.ActHit.frame - 1;
              m_dwFrameTime := HA.ActHit.ftime;
            end;
            atCircinate:
            begin
              m_nStartFrame := HA.ActCircinate.start + m_btDir * (HA.ActCircinate.frame + HA.ActCircinate.skip);
              m_nEndFrame := m_nStartFrame + HA.ActCircinate.frame - 1;
              m_dwFrameTime := HA.ActCircinate.ftime;
            end;
            atFireDragon:
            begin
              m_nStartFrame := HA.ActFireDragon.start + m_btDir * (HA.ActFireDragon.frame + HA.ActFireDragon.skip);
              m_nEndFrame := m_nStartFrame + HA.ActFireDragon.frame - 1;
              m_dwFrameTime := HA.ActFireDragon.ftime;
            end;
            atSpurn:
            begin
              m_nStartFrame := HA.ActSpurn.start + m_btDir * (HA.ActSpurn.frame + HA.ActSpurn.skip);
              m_nEndFrame := m_nStartFrame + HA.ActSpurn.frame - 1;
              m_dwFrameTime := HA.ActSpurn.ftime;
            end;
            atSneak:
            begin
              m_nStartFrame := HA.ActSneak.start + m_btDir * (HA.ActSneak.frame + HA.ActSneak.skip);
              m_nEndFrame := m_nStartFrame + HA.ActSneak.frame - 1;
              m_dwFrameTime := HA.ActSneak.ftime;
            end;
            atShamanPush:
            begin
              m_nStartFrame := HA.ActShamanPush.start + m_btDir * (HA.ActShamanPush.frame + HA.ActShamanPush.skip);
              m_nEndFrame := m_nStartFrame + HA.ActShamanPush.frame - 1;
              m_dwFrameTime := HA.ActShamanPush.ftime;
            end;
          end;
          AProperties := AClient.GetEffectProperties(m_CurMagic.Strengthen);
          if AProperties <> nil then
            m_nSpellFrame := AProperties.Start.Count - AProperties.Start.Skip;
        end
        else
        begin
          case m_CurMagic.EffectNumber of
            60:
              begin
                m_nStartFrame := HA.ActHit.start + m_btDir * (HA.ActHit.frame + HA.ActHit.skip);
                m_nEndFrame := m_nStartFrame + HA.ActHit.frame - 1;
                m_dwFrameTime := HA.ActHit.ftime;
                m_nMagLight := 2;
                m_nSpellFrame := 2;
                // m_nSpellFrame := 15;//15
              end;
            22:
              begin // 火墙
                m_nMagLight := 4; // 汾汲拳
                m_nSpellFrame := 10; // 汾汲拳绰 10 橇贰烙栏肺 函版
              end;
            26:
              begin // 心灵启示
                m_nMagLight := 2;
                m_nSpellFrame := 20;
                 m_dwFrameTime := m_dwFrameTime div 2;
              end;
            43:
              begin // 狮子吼
                m_nMagLight := 2;
                m_nSpellFrame := 20;
              end;
            52:
              begin // 四级魔法盾
                m_nSpellFrame := 9;
              end;
            66:
              begin // 酒气护体
                 m_nSpellFrame := 16;
              end;
            // 75: begin //四级雷电术
            // m_nStartFrame := 20;
            // m_nSpellFrame := 5;
            // m_nEndFrame := m_nStartFrame + 5 - 1;
            // end;
            91:
              begin // 护体神盾
                m_nSpellFrame := 10;
              end;
            100, 101:
              begin // 4级火符 20080111  4级灭天火 20080111
                m_nSpellFrame := 6;
              end;
            103:
              begin // 双龙破
                m_nStartFrame := 1040 + m_btDir * (13 + 7);
                m_nSpellFrame := 13;
                m_nEndFrame := m_nStartFrame + 13 - 1;
              end;
            104:
              begin // 虎啸诀
                m_nStartFrame := 1200 + m_btDir * (6 + 4);
                m_nSpellFrame := 6;
                m_nEndFrame := m_nStartFrame + 6 - 1;
               end;
            106:
              begin // 凤舞祭
                m_nStartFrame := 650 + m_btDir * (6 + 4);
                m_nSpellFrame := 6;
                m_nEndFrame := m_nStartFrame + 6 - 1;
              end;
            107:
              begin // 八卦掌
                m_nStartFrame := 1440 + m_btDir * (12 + 8);
                m_nSpellFrame := 12;
                m_nEndFrame := m_nStartFrame + 12 - 1;
              end;
            109:
              begin // 惊雷爆
                m_nStartFrame := 1360 + m_btDir * (9 + 1);
                m_nSpellFrame := 9;
                m_nEndFrame := m_nStartFrame + 9 - 1;
              end;
            110:
              begin // 三焰咒
                m_nStartFrame := 1600 + m_btDir * (12 + 8);
                m_nSpellFrame := 12;
                m_nEndFrame := m_nStartFrame + 12 - 1;
              end;
            112:
              begin // 冰天雪地
                m_nStartFrame := 800 + m_btDir * (8 + 2);
                m_nSpellFrame := 8;
                m_nEndFrame := m_nStartFrame + 8 - 1;
              end;
            113:
              begin // 万剑归宗
                m_nStartFrame := 1760 + m_btDir * (14 + 6);
                m_nSpellFrame := 14;
                m_nEndFrame := m_nStartFrame + 14 - 1;
              end;
            150, 151, 157, 170:
            begin
              m_nStartFrame := HA.ActHeavyHit.start + m_btDir * (HA.ActHeavyHit.frame + HA.ActHeavyHit.skip);
              m_nEndFrame := m_nStartFrame + HA.ActHeavyHit.frame - 1;
              m_dwFrameTime := HA.ActHeavyHit.ftime;
              m_dwStartTime := GetTickCount;
            end;
            152:
            begin
              //m_nSpellFrame := 6;
            end;
            153:
            begin
              m_btActionEffect := 1;
              m_nStartFrame := HA.ActHeavyHit.start + m_btDir * (HA.ActHeavyHit.frame + HA.ActHeavyHit.skip);
              m_nEndFrame := m_nStartFrame + HA.ActHeavyHit.frame - 1;
              m_dwFrameTime := HA.ActHeavyHit.ftime;
              m_dwStartTime := GetTickCount;
            end;
            154, 155:
            begin
              //m_nSpellFrame := 11;
            end;
            156:
            begin
              //m_nSpellFrame := 5;
            end;
            163: //刺客旋风腿
            begin
              m_nStartFrame := HA.ActSpurn.start + m_btDir * (HA.ActSpurn.frame + HA.ActSpurn.skip);
              m_nEndFrame := m_nStartFrame + HA.ActSpurn.frame - 1;
              m_dwFrameTime := HA.ActSpurn.ftime;
              if not IsMirReturnClient then
              begin
                meff := TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagicCk_NsImage,m_btDir * 10 + 790,7,GetSpellFrameTime(80),true);
                PlayScene.m_EffectList.Add(meff);
              end else
              begin
                meff := TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagicCKImages,m_btDir * 10 + 1110,7,GetSpellFrameTime(80),true);
                PlayScene.m_EffectList.Add(meff);
              end;
            end;
            168:
            begin

            end;
            SKILL_165: //刺客技能 冷酷释放效果
            begin
              if not IsMirReturnClient then
              begin
                meff := TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagicCk_NsImage,960,6,GetSpellFrameTime(80),true);
                PlayScene.m_EffectList.Add(meff);
              end else
              begin

              end;
            end;
            160: //鬼灵步 落地效果
            begin
              if not IsMirReturnClient then
              begin
                meff := TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagicCk_NsImage,680,7,GetSpellFrameTime(80),true);
                PlayScene.m_EffectList.Add(meff);
              end else
              begin
                meff := TNormalDrawEffect.Create(m_nCurrX,m_nCurrY,g_WMagicCKImages,1400,10,GetSpellFrameTime(80),true);
                PlayScene.m_EffectList.Add(meff);
              end;
            end;
            164:  //鬼灵步 起身效果
            begin
              if not IsMirReturnClient then
              begin
                meff := TCharEffect.Create(670,7,Self);
                meff.ImgLib := g_WMagicCk_NsImage;
                meff.NextFrameTime := 60;
                PlayScene.m_EffectList.Add(meff);
              end else
              begin
                meff := TCharEffect.Create(1390,7,Self);
                meff.ImgLib := g_WMagicCKImages;
                meff.NextFrameTime := 60;
                PlayScene.m_EffectList.Add(meff);
              end;
            end
          else
            begin
              m_nMagLight := 2;
              m_nSpellFrame := DEFSPELLFRAME;
            end;
          end;
        end;
        m_dwFrameTime := GetSpellFrameTime(m_dwFrameTime);
        if (m_btRace = 1) or (m_btRace = 150) then // 英雄，人型
          m_dwWaitMagicRequest := GetTickCount - 1500 // 防止,由于网络延时或消息累积,英雄人形连接放魔法时,出现举手卡现像 减少举手放下的时间间隔20080720
        else
          m_dwWaitMagicRequest := GetTickCount;

        m_dwWaitMagicRequestTime := m_nSpellFrame * m_dwFrameTime;
        m_boWarMode := TRUE;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);

        if m_CurMagic.EffectNumber in [103 .. 113] then
        begin
          SetNextFixedEffect(20, 0);
        end;
      end;
    SM_STRUCK:
      begin
        if self.m_btHorse > 0 then
        begin
          m_nStartFrame := 192 + m_btDir * 8;
          m_nEndFrame := m_nStartFrame + 3 - 1;
          //TODO 骑马被攻击
        end
        else
        begin
          m_nStartFrame := HA.ActStruck.start + m_btDir * (HA.ActStruck.frame + HA.ActStruck.skip);
          m_nEndFrame := m_nStartFrame + HA.ActStruck.frame - 1;
        end;
        m_dwFrameTime := m_dwStruckFrameTime; // HA.ActStruck.ftime;
        m_dwStartTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);

        m_dwGenAnicountTime := GetTickCount;
        m_nCurBubbleStruck := 0;
        m_nCurProtEctionStruck := 0;
        m_dwProtEctionStruckTime := GetTickCount;
      end;
    SM_NOWDEATH:
      begin
        m_nStartFrame := HA.ActDie.start + m_btDir * (HA.ActDie.frame + HA.ActDie.skip);
        m_nEndFrame := m_nStartFrame + HA.ActDie.frame - 1;
        m_dwFrameTime := HA.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
  end;
end;

procedure THumActor.DefaultMotion;
begin
  inherited DefaultMotion;
  if m_btHorse = 0 then
  begin
    if m_OuterEffect <> nil then
      m_HumWinSurface := m_OuterEffect.GetImage(m_nCurrentFrame + HumFrame() * m_btSex, m_nSpx, m_nSpy)
    else if (m_btEffect <> 0) then
      m_HumWinSurface := GetWHumWinImage(m_btJob, m_btSex, m_btEffect, m_nCurrentFrame, m_nSpx, m_nSpy)
  end;
end;

function THumActor.GetDefaultFrame(wmode: Boolean): Integer; // 动态函数
var
  cf: Integer;
  HA : pTHumanAction;
begin
  // GlimmingMode := FALSE;
  // dr := Dress div 2;            //HUMANFRAME * (dr)
   if m_boChangeToMonster then
   begin
     HA := @m_ChangeToMonsterAct;
   end else
   begin
     HA := @uActionsMgr.HA;
   end;




  if m_boDeath then // 死亡
    Result := HA.ActDie.start + m_btDir * (HA.ActDie.frame + HA.ActDie.skip) + (HA.ActDie.frame - 1)
  else if wmode then
  begin // 战斗状态
    // GlimmingMode := TRUE;
    Result := HA.ActWarMode.start + m_btDir * (HA.ActWarMode.frame + HA.ActWarMode.skip);
  end
  else
  begin // 站立状态
    m_nDefFrameCount := HA.ActStand.frame;
    if m_nCurrentDefFrame < 0 then
      cf := 0
    else if m_nCurrentDefFrame >= HA.ActStand.frame then
      cf := 0 // HA.ActStand.frame-1
    else
      cf := m_nCurrentDefFrame;
    Result := HA.ActStand.start + m_btDir * (HA.ActStand.frame + HA.ActStand.skip) + cf;
  end;
end;

procedure THumActor.RunFrameAction(frame: Integer);
var
  Meff:  TMapEffect;
  event: TCustomEvent;
  mfly:  TFlyingAxe;
begin
  if m_nCurrentAction = SM_HEAVYHIT then
  begin
    if (frame = 5) and (m_boDigFragment) then
    begin
      m_boDigFragment := FALSE;
      Meff := TMapEffect.Create(8 * m_btDir, 3, m_nCurrX, m_nCurrY);
      Meff.ImgLib := { FrmMain.WEffectImg } g_WEffectImages;
      Meff.NextFrameTime := 80;
      g_SoundManager.DXPlaySound(s_strike_stone);
      // g_SoundManager.DXPlaySound (s_drop_stonepiece);
      PlayScene.m_EffectList.Add(Meff);
      event := EventMan.GetEvent(m_nCurrX, m_nCurrY, ET_PILESTONES);
      if event <> nil then
        event.m_nEventParam := event.m_nEventParam + 1;
    end;
  end;
end;

procedure THumActor.ShowEffect(ID: Integer);
begin
  if m_MyEffect <> nil then
    FreeAndNilEx(m_MyEffect);
  m_MyEffect :=  UIWindowManager.CreateEffect(ID);
  if m_MyEffect <> nil then
  begin
    m_MyEffect.OnSoundEvent :=  DoSoundEffect;
    if m_MyEffect.LoopMax = 0 then
      m_MyEffect.LoopMax  :=  1;
  end;
end;

procedure THumActor.DoWeaponBreakEffect;
begin
  m_boWeaponEffect := TRUE;
  m_nCurWeaponEffect := 0;
end;

procedure THumActor.Run;

//  function MagicTimeOut: Boolean;
//  begin
//    if m_CurMagic.EffectNumber = 60 then
//      Result := GetTickCount - m_dwWaitMagicRequest > 500
//    else
//      Result := GetTickCount - m_dwWaitMagicRequest > m_dwWaitMagicRequestTime;
//    if Result then
//      m_CurMagic.ServerMagicCode := 0;
//  end;

    //判断魔法是否已经完成（人类：3秒，其他：2秒） 从3K拿过来的 进行了修改 随云
   function MagicTimeOut: Boolean;
   begin
      if self = g_MySelf then
      begin
        if m_CurMagic.EffectNumber = 60 then   //破魂斩  缩短人物砍下去的动作 20080227
          Result := GetTickCount - m_dwWaitMagicRequest > 500
        else
         Result := GetTickCount - m_dwWaitMagicRequest > m_dwWaitMagicRequestTime;
      end else
      begin
      if m_CurMagic.EffectNumber = 60 then begin
       Result := GetTickCount - m_dwWaitMagicRequest > 500  //破魂斩  缩短人物砍下去的动作 20080227
      end else if m_CurMagic.EffectNumber in [103,107,109,110,113] then Result := GetTickCount - m_dwWaitMagicRequest > 3000  else Result := GetTickCount - m_dwWaitMagicRequest > 2000;
      if Result then m_CurMagic.ServerMagicCode := 0;
      end;
   end;

var
  prv:               Integer;
  m_dwFrameTimetime: Longword;
  bofly:             Boolean;
  AMagic: PTClientMagic;
  boKTQHit : Boolean; //是否开天斩轻击  默认重击
begin
  if GetTickCount - m_dwGenAnicountTime > 120 then
  begin
    m_dwGenAnicountTime := GetTickCount;
    Inc(m_nGenAniCount);
    if m_nGenAniCount > 100000 then
      m_nGenAniCount := 0;
    Inc(m_nCurBubbleStruck);
  end;
  m_BodyEffect.Run;
  if m_boWeaponEffect then
  begin
    if GetTickCount - m_dwWeaponpEffectTime > 120 then
    begin
      m_dwWeaponpEffectTime := GetTickCount;
      Inc(m_nCurWeaponEffect);
      if m_nCurWeaponEffect >= MAXWPEFFECTFRAME then
        m_boWeaponEffect := FALSE;
    end;
  end;

  if m_boBloodRush then
  begin
    UpDateQuickRushPostion(GetTickCount);
    Exit;
  end;


  case m_nCurrentAction of
    SM_WALK, SM_NPCWALK, SM_BACKSTEP, SM_BATTERBACKSTEP, SM_RUN, SM_SNEAK, SM_HORSERUN,
    SM_RUSH, SM_RUSHKUNG, SM_ZHUIXINHIT: Exit;
  end;

  m_boMsgMuch := FALSE;
  if Self <> g_MySelf then
  begin
    if MsgCount >= 2 then
      m_boMsgMuch := TRUE;
  end;
  // 动作声效
  RunActSound(m_nCurrentFrame - m_nStartFrame);
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);

  prv := m_nCurrentFrame;

  if m_nCurrentAction <> 0 then
  begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if (Self <> g_MySelf) and (m_boUseMagic) then
    begin
      m_dwFrameTimetime := Round(m_dwFrameTime / 1.8);
    end
    else
    begin
      if m_boMsgMuch then
        m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
      else
        m_dwFrameTimetime := m_dwFrameTime;
    end;

    if m_nHitMagic = SKILL_167 then
    begin
      if m_nCurrentFrame = m_nEndFrame then
      begin
        m_dwFrameTimetime := 600;
      end;
    end;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then
    begin
      if m_nCurrentFrame < m_nEndFrame then
      begin
        if m_boUseMagic then
        begin
          if (m_nCurEffFrame = m_nSpellFrame - 2) or (MagicTimeOut) then
          begin // 魔法执行完
            if (m_CurMagic.ServerMagicCode >= 0) or (MagicTimeOut) then
            begin // 辑滚肺 何磐 罐篮 搬苞. 酒流 救吭栏搁 扁促覆
              Inc(m_nCurrentFrame);
              Inc(m_nCurEffFrame);
              m_dwStartTime := GetTickCount;
            end;
          end
          else
          begin
            if m_nCurrentFrame < m_nEndFrame - 1 then
              Inc(m_nCurrentFrame);
            Inc(m_nCurEffFrame);
            m_dwStartTime := GetTickCount;
          end;
        end
        else
        begin // 攻击怪 这有反映
          Inc(m_nCurrentFrame);
          //Writeln('_ADDCurrFrame:' + IntToStr(m_nCurrentFrame));
          m_dwStartTime := GetTickCount;
        end;
      end
      else
      begin

        if Self = g_MySelf then
        begin
          if frmMain.ServerAcceptNextAction then
          begin // 锁定人物本身 服务器返回结果 则释放
            m_nCurrentAction := 0;
            m_boUseMagic := FALSE;
          end;
        end
        else
        begin // 不是人物
          m_nCurrentAction := 0; // 动作为空
          m_boUseMagic := FALSE;
        end;

        //绘制攻击特效的结尾部分
        case m_nHitMagic of
          43:SetNextFixedEffect(1,43); //龙影剑法
          42:    //开天斩
          begin
            boKTQHit := False;
            if TryGetMagic(42, AMagic) then
            begin
              if AMagic.Tag = 1 then
                boKTQHit := True;
            end;
            //轻击
            if boKTQHit then
            begin
               SetNextFixedEffect(3,42);
            end else
            begin
               SetNextFixedEffect(2,42);
            end;
          end;
        end;
        m_btActionEffect := 0;
        m_nHitMagic := -1;
      end;




//      if m_boHitEffect and (m_nHitEffectNumber in [7, 8, 10, 12, 15, 17, 53]) then  todo
//      begin // 魔法攻击效果  20080202
//        if m_nCurrentFrame = m_nEndFrame - 1 then
//        begin
//          case m_nHitEffectNumber of
//            8: SetNextFixedEffect(1); // 龙影剑法  后9个动画效果 20080202
//            // MyShow.Create(m_nCurrX,m_nCurrY,1,80,9,m_btDir,g_WMagic2Images);
//            7: SetNextFixedEffect(2); // 开天斩重击碎冰效果
//            10: SetNextFixedEffect(3); // 开天斩轻击碎冰效果
//            12: SetNextFixedEffect(6); // 雷霆一击战士效果
//            15: SetNextFixedEffect(19); // 断岳斩结束
//            17: SetNextFixedEffect(16);
//            53: SetNextFixedEffect(53);
//          end;
//        end;
//      end;

      CreateMagicObject;
    end;
    if (m_btRace = 0) or (m_btRace = 1) or (m_btRace = 150) then
      m_nCurrentDefFrame := 0 // 人类,英雄,人型20080629
    else
      m_nCurrentDefFrame := -10;
    m_dwDefFrameTime := GetTickCount;
  end
  else
    DefaultFrameRun;

  if prv <> m_nCurrentFrame then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
end;

function THumActor.Light: Integer;
//var
//  l: Integer;
begin
//  l := m_nChrLight; todo
//  if l < m_nMagLight then
//  begin
//    if m_boUseMagic or m_boHitEffect then
//      l := m_nMagLight;
//  end;
//  Result := l;
  Result := m_nChrLight;
end;

procedure THumActor.LoadSurface;
begin
  if m_boChangeToMonster then
  begin
    inherited;
    Exit;
  End;


  m_BodySurface := nil;  //身体
  m_WeaponSurface := nil; //武器
  m_WeaponSurface_L := nil; //左手武器
  m_HairSurface := nil;  //头发
  m_WeaponEffectSurface := nil; //武器特效
  m_HumWinSurface := nil; //翅膀
  m_StallSurface := nil;  //摊位文理
  if m_btHorse = 0 then
  begin
    {$REGION '连击部分处理'}
    if ((m_nCurrentAction in [60, 61, 62, 63, 64 { 连击 和倚天劈地 } ]) { and (m_nCurrentFrame < m_nEndFrame) } ) or
      (m_boUseMagic and (m_CurMagic.EffectNumber in [103, 104, 106, 107, 109, 110, 112, 113])) then
    begin
      m_BodySurface := GetWISHumImg(m_btDress, m_btSex, m_nCurrentFrame, m_nPx, m_nPy);
      m_HairSurface := GetWISHumHairImg(m_btDress, m_btSex, m_nCurrentFrame, m_nHpx, m_nHpy);
      m_WeaponSurface := GetWISWeaponImg(m_btWeapon, m_btSex, m_nCurrentFrame, m_nWpx, m_nWpy);
      if (m_btEffect = 50) then
      begin
//         if (m_nCurrentFrame <= 536) then begin
//         if (GetTickCount - m_dwFrameTick) > 100 then begin
//         if m_nFrame < 19 then Inc(m_nFrame)
//         else begin
//         {if not m_bo2D0 then m_bo2D0:=True
//         else m_bo2D0:=False;  }
//         m_nFrame:=0;
//         end;
//         m_dwFrameTick:=GetTickCount();
//         end;
//         m_HumWinSurface:={FrmMain.WEffectImg}g_WWiscboHumWing.GetCachedImage (m_nHumWinOffset + m_nFrame, m_nSpx, m_nSpy);
//         end;
      end
      else if (m_btEffect in [24 .. 25]) then
        m_HumWinSurface := GetWISHumWingImg(m_btEffect, m_btSex, m_nCurrentFrame, m_nSpx, m_nSpy)
      else if (m_btEffect <> 0) then
        m_HumWinSurface := GetWISHumWingImg(m_btEffect, m_btSex, m_nCurrentFrame, m_nSpx, m_nSpy);
      {$ENDREGION}
    end
    else
    begin

      m_BodySurface := GetWHumImg(m_btJob, m_btSex, m_btDress, m_nCurrentFrame, m_nPx, m_nPy);  //身体
      m_HairSurface := GetHumHairImg(m_btJob, m_btSex, m_btHair, m_nCurrentFrame, m_nHpx, m_nHpy); //头发
      m_WeaponSurface := GetWWeaponImg(m_btJob, m_btSex, m_btWeapon, m_nCurrentFrame, m_nWpx, m_nWpy); //武器

      //如果盾牌有 则获取盾牌 如果盾牌没有则获取左手武器
      if m_wShield = 0 then
      begin
        m_WeaponSurface_L := GetWLWeaponImg(m_btJob, m_btSex, m_btWeapon, m_nCurrentFrame, m_nWLPx, m_nWLPy);
        m_WeaponEffectSurface_L := GetWLWeaponWinImage(m_btJob, m_btSex, m_nWeaponEffect, m_nCurrentFrame, m_nWLPx_ef, m_nWLPy_ef);
      end
      else
      begin
        m_WeaponSurface_L := GetShieldImg(m_wShield, m_nCurrentFrame, m_nWLPx, m_nWLPy);
      end;

      if m_WeponOuterEffect <> nil then
        m_WeaponEffectSurface := m_WeponOuterEffect.GetImage(m_nCurrentFrame + HumFrame() * m_btSex, m_nWepx, m_nWepy)
      else if m_nWeaponEffect > 0 then
        m_WeaponEffectSurface := GetWWeaponWinImage(m_btJob, m_btSex, m_nWeaponEffect, m_nCurrentFrame, m_nWepx, m_nWepy);

      // ****翅膀****//
      if m_OuterEffect <> nil then
        m_HumWinSurface := m_OuterEffect.GetImage(m_nCurrentFrame + HumFrame() * m_btSex, m_nSpx, m_nSpy)
      else if (m_btEffect <> 0) then
        m_HumWinSurface := GetWHumWinImage(m_btJob, m_btSex, m_btEffect, m_nCurrentFrame, m_nSpx, m_nSpy)
    end;
    if m_btStall in [1..4] then
      m_StallSurface := g_77Images.GetCachedImage(489 + m_btStall, m_nStallX, m_nStallY);
  end
  else
  begin
    m_HorseSurface := GetHorseImage(m_btHorse, m_nCurrentFrame, m_nHX, m_nHY);
    m_BodySurface :=  GetHorseHumImage(m_btDress, m_btSex, m_nCurrentFrame, m_nPx, m_nPy);
    m_HairSurface := GetHorseHairImage(m_btHair, m_nCurrentFrame, m_nHpx, m_nHpy);
    m_HumWinSurface := GetHorseHumWinImage(m_btJob, m_btSex, m_btEffect, m_nCurrentFrame, m_nSpx, m_nSpy);
  end;
end;

procedure THumActor.NameTextOut(dsurface: TAsphyreCanvas; dx, dy: Integer);
var
  ATexture: TuTexture;
begin

  if m_btRace = 150 then
    inherited
  else if g_Config.Assistant.ShowName then
  begin
    if g_boSelectMyself and (g_MySelf = Self) then Exit;
    if g_FocusCret = Self then Exit;
    if g_Config.Assistant.ShowRankName then
      ATexture  :=  Textures.ObjectName(DSurface, m_sDescUserName + '\' + m_sUserName)
    else
      ATexture  :=  Textures.ObjectName(DSurface, m_sUserName);
    if ATexture <> nil then
    begin
      if m_btHorse > 0 then
        ATexture.Draw(dsurface, g_ClientCustomSetting.ActorNameShowXOffset + dx - ATexture.Width div 2, g_ClientCustomSetting.ActorNameShowYOffset + dy - 12, m_nNameColor)
      else
        ATexture.Draw(dsurface, g_ClientCustomSetting.ActorNameShowXOffset+ dx - ATexture.Width div 2, g_ClientCustomSetting.ActorNameShowYOffset + dy{ - ATexture.Height div 2}, m_nNameColor);
    end;
  end;

 // dsurface.TextOut(dx - 50 , dy -20 , Format('cr:%d , cy:%d , px:%d , py:%d',[m_nCurrX,m_nCurrY,m_nShiftX,m_nShiftY]),clred);
end;

procedure THumActor.TitleOut(dsurface: TAsphyreCanvas; dx, dy, AniIndex: Integer);
var
  ax, ay, ey: Integer;
  ATexture: TuTexture;
begin
  ey := 0;
  if not m_boDeath then
  begin
    ey := 10;
    if m_Abil.MaxHP > 1 then
      Inc(ey, 14);
    if m_btStall in [1..4] then
    begin
      if g_77Images.GetImgSize(496, ax, ay) then
        Inc(ey, ay);
    end;
  end;

  //组队招募
  if HaveStatus(STATE_Recruit) then
  begin
    ATexture  :=  Textures.ObjectName(DSurface, Format('[招募队员: %d/%d]', [m_nGrpCount,  g_nMaxGroupCount]));
    if ATexture <> nil then
    begin
      ATexture.Draw(dsurface, GetSayX() - ATexture.Width div 2, GetSayY() - ATexture.Height - ey, $00F2F200);
      ey  :=  ey + ATexture.Height;
    end;
  end;

  //头顶Title
  if g_Config.Assistant.ShowTitle then
  begin
    if m_sTitle <> '' then
    begin
      ATexture  :=  Textures.ObjectName(DSurface, m_sTitle);
      if ATexture <> nil then
      begin
        ATexture.Draw(dsurface, GetSayX() - ATexture.Width div 2, GetSayY() - ATexture.Height - ey, clWhite);
        ey  :=  ey + ATexture.Height;
      end;
    end;
  end;

      //头顶特效
  if g_boShowTitleEffect then
  begin
    if (m_oEffect <> nil) and (m_oEffect.MaxWidth > 0) and (m_oEffect.MaxHeight > 0) then
      m_oEffect.Draw(dsurface, GetSayX() - m_oEffect.MaxWidth div 2, GetSayY() - m_oEffect.MaxHeight - 24);
  end;

  if m_MyEffect <> nil then
    m_MyEffect.Draw(dsurface, dx + m_nShiftX, dy + m_nShiftY);
end;

{ ----------------------------------------------------------------- }
// 绘制人物
{ ----------------------------------------------------------------- }

procedure THumActor.DrawChr(dsurface: TAsphyreCanvas; dx, dy: Integer; blend: Boolean; boFlag: Boolean);
var
  idx, ax, ay, ey: Integer;
  d:           TAsphyreLockableTexture;
  ceff:        TColorEffect;
  wimg:        TWMImages;
  ATexture: TuTexture;
  boDrawEffect : Boolean;
begin
 // dsurface.BoldText(300,300,IntToStr(m_nCurrentFrame),clred,clWhite);
  if m_boChangeToMonster then
  begin
    inherited;
    Exit;
  end;
  if m_btDir > 7 then Exit;
  try
    if GetTickCount - m_dwLoadSurfaceTime > (FREE_TEXTURE_TIME div 2) then
    begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface;
    end;
    if NeedLoad then
    begin
      NeedLoad := FALSE;
      LoadSurface;
    end;
    ceff := GetDrawEffectValue; // 人物显示颜色

    if (m_nCurrentFrame >= 0) and (m_nCurrentFrame <= 887) then
    begin
      case m_btJob of
        _JOB_CIK : m_nWpord := WORDER_CKR[m_btSex, m_nCurrentFrame];
        _JOB_ARCHER :m_nWpord := WORDER_ARCHER[m_btSex, m_nCurrentFrame];
        else
        m_nWpord := WORDER[m_btSex, m_nCurrentFrame];
      end;
      m_nLWpord := WORDER_CKL[m_btSex, m_nCurrentFrame];
    end;

    if m_btHorse = 0 then
    begin
      if (m_btEffect <> 0) and ((Self <> g_MySelf) or (not boFlag)) then
      begin
        if (m_btDir in [3,4,5]) and (m_HumWinSurface <> nil) then
        begin
          dsurface.DrawBlend(dx + m_nSpx + m_nShiftX, dy + m_nSpy + m_nShiftY, m_HumWinSurface, 1);
        end;
      end;

      //先画武器
      if (m_btWeapon >= 2) and not blend then
      begin
        //绘制右手武器
        if (m_nWpord = 0) and (m_WeaponSurface <> nil) then
        begin
          DrawWeaponSurface(dsurface, m_WeaponSurface, dx + m_nWpx + m_nShiftX, dy + m_nWpy + m_nShiftY, blend, ceNone);
          if m_WeaponEffectSurface <> nil then
            dsurface.DrawBlend(dx + m_nWepx + m_nShiftX,  dy + m_nWepy + m_nShiftY, m_WeaponEffectSurface, 1);
        end;

        // 绘制左手武器
        if (m_nLWpord = 0) and (m_WeaponSurface_L <> nil) then
        begin
          DrawWeaponSurface(dsurface, m_WeaponSurface_L, dx + m_nWLPx + m_nShiftX, dy + m_nWLPy + m_nShiftY, blend, ceNone);
          if m_WeaponEffectSurface_L <> nil then
            dsurface.DrawBlend(dx + m_nWLPx_ef + m_nShiftX,  dy + m_nWLPy_ef + m_nShiftY, m_WeaponEffectSurface_L, 1);
        end;

      end;

      // 画人物
      if m_BodySurface <> nil then
        DrawBodySurface(dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, blend, ceff);
      // 画头发
      if m_HairSurface <> nil then
        DrawEffSurface(dsurface, m_HairSurface, dx + m_nHpx + m_nShiftX, dy + m_nHpy + m_nShiftY, blend, ceff);

      // 后画武器
      if (m_btWeapon >= 2) {and not blend} then
      begin
        //绘制右手武器
        if (m_nWpord = 1) and (m_WeaponSurface <> nil) then
        begin
          DrawWeaponSurface(dsurface, m_WeaponSurface, dx + m_nWpx + m_nShiftX, dy + m_nWpy + m_nShiftY, blend, ceNone);
          if m_WeaponEffectSurface <> nil then
            dsurface.DrawBlend(dx + m_nWepx + m_nShiftX,  dy + m_nWepy + m_nShiftY, m_WeaponEffectSurface, 1);
        end;

        //绘制左手武器
        if (m_nLWpord = 1) and (m_WeaponSurface_L <> nil) then
        begin
          DrawWeaponSurface(dsurface, m_WeaponSurface_L, dx + m_nWLPx + m_nShiftX, dy + m_nWLPy + m_nShiftY, blend, ceNone);
          if m_WeaponEffectSurface_L <> nil then
            dsurface.DrawBlend(dx + m_nWLPx_ef + m_nShiftX,  dy + m_nWLPy_ef + m_nShiftY, m_WeaponEffectSurface_L, 1);
        end;
      end;


      boDrawEffect := False;
      //绘制自身 第一次是 true  第二次是 false 其他人都是true
      if Self = g_MySelf then
      begin
        if boFlag = false then
          boDrawEffect := True;
      end else
      begin
        boDrawEffect := boFlag;
      end;

      if boDrawEffect then
      begin
        if HaveStatus(STATE_LOCKRUN) then
        begin // 小网状态
          idx := 3740 + (m_nGenAniCount mod 10);;
          d := g_WMonImagesArr[23].GetCachedImage(idx, ax, ay);
          if d <> nil then
            dsurface.DrawBlend(dx + ax + m_nShiftX, dy + ay + m_nShiftY, d, 1);
        end;
        if not m_boDeath then
        begin // 死亡不显示魔法盾效果
          if HaveStatus(STATE_BUBBLEDEFENCEUP) then
          begin
            if (m_nCurrentAction = SM_STRUCK) and (m_nCurBubbleStruck < 3) then
              idx := MAGBUBBLESTRUCKBASE + m_nCurBubbleStruck
            else
              idx := MAGBUBBLEBASE + (m_nGenAniCount mod 3);
            d := g_WMagicImages.GetCachedImage(idx, ax, ay);
            if d <> nil then
              dsurface.DrawBlend(dx + ax + m_nShiftX, dy + ay + m_nShiftY, d, 1);
          end;
          if m_btStall in [1..4] then
            dsurface.Draw(dx + m_nStallX + m_nShiftX, dy + m_nStallY + m_nShiftY, m_StallSurface);
        end;
      end;
    end
    else
    begin
      //画马
      if m_HorseSurface <> nil then
        DrawEffSurface(dsurface, m_HorseSurface, dx + m_nHX + m_nShiftX, dy + m_nHY + m_nShiftY, blend, ceff);
      //画人物
      if m_BodySurface <> nil then
        DrawBodySurface(dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, blend, ceff);
      // 画头发
      if m_HairSurface <> nil then
        DrawEffSurface(dsurface, m_HairSurface, dx + m_nHpx + m_nShiftX, dy + m_nHpy + m_nShiftY, blend, ceff);
      //画翅膀
      if (m_HumWinSurface <> nil) then
        dsurface.DrawBlend(dx + m_nSpx + m_nShiftX, dy + m_nSpy + m_nShiftY, m_HumWinSurface, 1);
    end;


//    if not boFlag then
//    begin
      DrawMyShow(dsurface, dx, dy);
      m_BodyEffect.DrawEffect(DSurface, dx + m_nShiftX, dy + m_nShiftY);
      DrawMagicEffect(dsurface, dx, dy);
      // 显示武器效果
      if m_boWeaponEffect and (m_btHorse = 0) then
      begin
        idx := WPEFFECTBASE + m_btDir * 10 + m_nCurWeaponEffect;
        d := g_WMagicImages.GetCachedImage(idx, ax, ay);
        if d <> nil then
          dsurface.DrawBlend(dx + ax + m_nShiftX, dy + ay + m_nShiftY, d, 1);
      end;
//    end;

    //绘制突进特效
    if not boFlag or (Self <> g_MySelf) then
    begin
      DrawQuickRushEffect(dsurface, dx, dy);
    end;

    if (Self <> g_MySelf) or (not boFlag) then
    begin
      if (m_btEffect = 50) then
      begin
        if not m_boDeath then
        begin
          if (m_HumWinSurface <> nil) then
            dsurface.DrawBlend(dx + m_nSpx + m_nShiftX, dy + m_nSpy + m_nShiftY, m_HumWinSurface, 1);
        end;
      end
      else if m_btEffect <> 0 then
      begin
        if (m_btDir in [0,1,2,6,7]) and (m_HumWinSurface <> nil) then
          dsurface.DrawBlend(dx + m_nSpx + m_nShiftX, dy + m_nSpy + m_nShiftY, m_HumWinSurface, 1);
      end;
    end;
  except
  end;
end;

procedure TActor.MoveStep(dir: byte; x, y, step: Word);
begin
  Self.m_btDir := dir;
  Self.m_nMoveStep := step;
  Self.m_nCurrX := x;
  Self.m_nCurrY := y;
end;

procedure TActor.NameTextOut(dsurface: TAsphyreCanvas; dx, dy: Integer);
var
  ATexture: TuTexture;
  ANameColor: TColor;
begin
  if not m_boDeath then
  begin
    if g_Config.Assistant.ShowNPCName and Self.m_boMonNPC then
    begin
      if g_FocusCret = Self then Exit;
      ANameColor := m_nNameColor;
      if m_nNameColor = clWhite then
        ANameColor := clLime;
      ATexture  :=  Textures.ObjectName(DSurface, m_sDescUserName + '\' + m_sUserName);
      if ATexture <> nil then
        ATexture.Draw(dsurface, g_ClientCustomSetting.ActorNameShowXOffset + dx - ATexture.Width div 2, g_ClientCustomSetting.ActorNameShowYOffset + dy{ - ATexture.Height div 2}, ANameColor);
    end
    else if g_Config.Assistant.ShowMonName then
    begin
      if g_FocusCret = Self then
        Exit;
      ATexture  :=  Textures.ObjectName(DSurface, m_sDescUserName + '\' + m_sUserName);
      if ATexture <> nil then
        ATexture.Draw(dsurface,g_ClientCustomSetting.ActorNameShowXOffset +  dx - ATexture.Width div 2, g_ClientCustomSetting.ActorNameShowYOffset + dy{ - ATexture.Height div 2}, m_nNameColor);
    end;
  end;
end;

procedure TActor.TitleOut(dsurface: TAsphyreCanvas; dx, dy, AniIndex: Integer);
var
  I, AImageIndex, AOffsetX, AOffsetY: Integer;
  ATexture: TuTexture;
  AIsDoing,
  AIsCompleted,
  AIsUndo,
  AIsUndNot: Boolean;
  D: TAsphyreLockableTexture;
  ey: Integer;
begin

  ey := 0;
  if m_sTitle <> '' then
  begin
    ATexture  :=  Textures.ObjectName(DSurface, m_sTitle);
    if ATexture <> nil then
    begin
      ATexture.Draw(dsurface, GetSayX() - ATexture.Width div 2, GetSayY() - ATexture.Height - ey, clWhite);
      ey  :=  ey + ATexture.Height;
    end;
  end;

  if (m_oEffect <> nil) and (m_oEffect.MaxWidth > 0) and (m_oEffect.MaxHeight > 0) then
  begin
    m_oEffect.Draw(dsurface, GetSayX() - m_oEffect.MaxWidth div 2, GetSayY() - m_oEffect.MaxHeight - ey);
    ey := Ey + m_oEffect.MaxHeight;
  end;

  if m_MyEffect <> nil then
  begin
    m_MyEffect.Draw(dsurface, dx + m_nShiftX, dy + m_nShiftY);
  end;

  if m_TitleEffects <> nil then
  begin
    for I := 0 to m_TitleEffects.Count - 1 do
    begin
      m_TitleEffects[i].Draw(dsurface, GetSayX() -  m_TitleEffects[i].MaxWidth div 2, GetSayY() -  m_TitleEffects[i].MaxHeight - ey);
      ey := Ey + m_TitleEffects[i].MaxHeight;
    end;
  end;


  if m_nTag <= 0 then
    Exit;

  AIsDoing := False;
  AIsCompleted := False;
  AIsUndo := False;
  AIsUndNot := False;
  AImageIndex := -1;
  for I := 0 to g_Missions.DoingCount - 1 do
  begin
    if g_Missions.Doing[I].TargetNPC = m_nTag then
    begin
      case g_Missions.Doing[I].State of
        msGoing: AIsDoing := True;
        msCompleted:
        begin
          AIsCompleted := True;
          Break;
        end;
      end;
    end;
  end;
  for I := 0 to g_Missions.UnDoCount - 1 do
  begin
    if g_Missions.UnDo[I].TargetNPC = m_nTag then
    begin
      if (g_MySelf.m_Abil.Level >= g_Missions.UnDo[I].Level) and (g_MySelf.m_btReLevel >= g_Missions.UnDo[I].ReLevel) then
      begin
        AIsUndo := True;
        Break;
      end
      else
        AIsUndNot := True;
    end;
  end;
  if AIsCompleted then
    AImageIndex := 460
  else if AIsDoing then
    AImageIndex := 440
  else if AIsUndo then
    AImageIndex := 470
  else if AIsUndNot then
    AImageIndex := 450;
  if AImageIndex <> -1 then
  begin
    D := g_77Images.GetCachedImage(AImageIndex + AniIndex mod 10, AOffsetX, AOffsetY);
    if D <> nil then
      dsurface.Draw(dx + AOffsetX - 25, dy + AOffsetY + 30, D);
  end;

end;

procedure TActor.ClearHitMsg;
var
  I: Integer;
  msg: pTChrMsg;
  AList: TList;
begin
  AList := m_MsgList.LockList;
  try
    for I := AList.Count - 1 downto 0 do
    begin
      msg := AList[I];
      if msg.Ident <> SM_BATTERBACKSTEP then
      begin
        Dispose(msg);
        AList.Delete(I);
      end;
    end;
  finally
    m_MsgList.UnlockList;
  end;
end;

function TActor.MsgCount: Integer;
var
  AList: TList;
begin
  AList := m_MsgList.LockList;
  try
    Result := AList.Count;
  finally
    m_MsgList.UnlockList;
  end;
end;

{ TMonActor }

procedure TMonActor.DrawChr(dsurface: TAsphyreCanvas; dx, dy: Integer;
  blend, boFlag: Boolean);
begin
  inherited;
end;

{ TBodyEffect }

constructor TBodyEffect.Create;
begin
  FActive := False;
  FBodyEffKind := 0;
  FBodyEffect := 0;
  FInnerEffect := nil;
end;

destructor TBodyEffect.Destroy;
begin
  Clear;
  inherited;
end;

procedure TBodyEffect.Clear;
begin
  if FInnerEffect <> nil then
    FreeAndNilEx(FInnerEffect);
end;

procedure TBodyEffect.DoSoundEffect(Sender: TObject; const Sound: String);
begin
  g_SoundManager.PlaySoundEx(Sound);
end;

procedure TBodyEffect.Run;
begin
  if FActive then
  begin
    if FInnerEffect <> nil then
      FInnerEffect.Run;
  end;
end;

procedure TBodyEffect.DrawEffect(DSurface: TAsphyreCanvas; X, Y: Integer);
begin
  if FActive then
  begin
    if FInnerEffect <> nil then
      FInnerEffect.Draw(DSurface, X, Y);
  end;
end;

procedure TBodyEffect.SetBodyEffect(Value: Integer);
var
  ABodyEffKind: Byte;
  ABodyEffect: Word;
  AClient: TuMagicClient;
begin
  ABodyEffKind := LoByte(LoWord(Value));
  FBodyEffLevel := HiByte(LoWord(Value));
  ABodyEffect := HiWord(Value);
  if (ABodyEffKind <> FBodyEffKind) or (ABodyEffect <> FBodyEffect) then
  begin
    FBodyEffKind := ABodyEffKind;
    FBodyEffect := ABodyEffect;
    FActive := False;
    Clear;
    if FBodyEffect > 0 then
    begin
      case FBodyEffKind of
        0:
        begin
          if g_MagicMgr.TryGet(FBodyEffect, AClient) then
          begin
            FInnerEffect := CreateEffectFromMagicRun(AClient, FBodyEffLevel);
            if FInnerEffect <> nil then
            begin
              FInnerEffect.OnSoundEvent :=  DoSoundEffect;
              FInnerEffect.Initializa;
              FActive := True;
            end;
          end;
        end;
        1:
        begin
          FInnerEffect :=  UIWindowManager.CreateEffect(FBodyEffect);
          if FInnerEffect <> nil then
          begin
            FInnerEffect.OnSoundEvent :=  DoSoundEffect;
            FInnerEffect.Initializa;
            FActive := True;
          end;
        end;
      end;
    end;
  end;
end;

end.

