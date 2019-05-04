unit MShare;

interface

{$J+}

uses
  Windows, Classes, SysUtils, Controls, Dialogs, cliutil, DWinCtl, uUITypes, IntroScn,
  uCliUITypes, WIL, Actor, Grobal2, IniFiles, Share, Generics.Collections,
  uMapDesc, Forms, uPathFind, Registry, ShellAPI, Graphics, uEDCode, NativeXmlObjectStorage,
  AbstractCanvas, AbstractTextures, AsphyreTypes, DXHelper, AbstractDevices,
  Vectors2px, Math, uMessageParse, IOUtils, uAutoRun, uCliOrders, uTypes, Common,uMemBuffer,
  Types,ExtUI,uActionsMgr,SkillInfo,SkillManager,SkillEffectConfig;

const
  g_btBColor = 18;
  g_btAlpha = 150;
  g_lineStartCount = 8;
  RES_IMG_BASE = 10000;
  RES_IMG_MAX = 10999;
  ACTOR_EFFECTID = 65535;
  CREATECHARNAMELEN = 15 ; //创建角色允许的长度
  STARTGAMEWAIT = 3000; //小退后点击开始游戏 需要等待的时间
  CUSTOM_ACTOR_ACTION_APPR_BASE = 20000;
  CUSTOM_ACTOR_ACTION_APPR_MAX = 20999;
var
  g_sAutoLoginAccount :string =  'qqqq';
  g_sAutoLoginPwd : string = 'qqqq';
  g_boAutoLogin :Boolean = True;
  g_StartGameTick : Cardinal;
  g_SendSpeedTick : Cardinal = 0;
type
  TTimerCommand = (tcSoftClose, tcReSelConnect, tcFastQueryChr, tcQueryItemPrice, tcReConnect);
  TChrAction = (caWalk, caSneak, caRun, caHorseRun, caHit, caSpell, caSitdown,caCommon); //caCommmon 表示其他一些通用动作 比如拾取物品
  TConnectionStep = (cnsLogin, cnsSelChr, cnsReSelChr, cnsPlay);
  TMoveItemSource = (msNone, msGold{背包金币}, msBag{背包}, msItemUp{淬炼}, msDrinkItem{饮酒}, msUses{穿戴},
  msDealItem{交易}, msDealGold{交易金币}, msSellItem{出售}, msMailItem{邮件}, msWineMateria{造酒材料}, msWineDrug,
  msChallenge{挑战}, msCustomItem{自定义物品框}, msStall{摆摊});
  TMovingItem = record
    FromIndex: Integer;
    Source: TMoveItemSource;
    Item: TClientItem;
  end;

  TMovingStallItem = record
    Inedex: Integer;
    Item: TClientStallItem;
  end;

  TuMapDesc = class
    MapX, MapY: Integer;
    _Type: Integer;
    Desc: String;
    Color: TColor;
  end;

  TuMapDescManager = class(TList)
  private
    function Get(index: Integer): TuMapDesc;
  public
    destructor Destroy; override;
    procedure ClearDesc;
    procedure AddDesc(aMapX, AMapY: Integer; AType: Integer; const ADesc: String; Color: TColor);
    property Items[index: Integer]: TuMapDesc read Get;
  end;

  IApplication = interface
    ['{501687F1-F936-4A5F-A235-34643269AF55}']
    procedure AddToChatBoardString(const Message: String; FColor, BColor: TColor);
    procedure LoadImage(const FileName: String; Index, Position: Integer);
    procedure AddMessageDialog(const Text: String; Buttons: TMsgDlgButtons; Handler: TMessageHandler = nil; Size: Integer = 1);
    procedure Terminate;
    procedure DisConnect;
    function _CurPos: TPoint;
  end;

  TMailItem = class
    Index: Integer;
    AFrom: String;
    Subject: String;
    Content: String;
    Item1: TClientItem;
    Item2: TClientItem;
    Item3: TClientItem;
    Item4: TClientItem;
    Item5: TClientItem;
    GoldStr: String;
    PriceStr: String;
    _Date,
    _ShortDate: String;
    State: Integer;
    Attachment: Integer;
    Loaded: Boolean;
    constructor Create;
  end;

  TMailManager = class(TList)
  private
    FSelected: TMailItem;
    FSelIndex: Integer;
    procedure SetSelIndex(const Value: Integer);
  public
    TopIndex: Integer;
    constructor Create;
    procedure Clear; override;
    procedure DeleteByMainIndex(const AIndex: Integer);
    procedure UpdateState(Index, State: Integer);
    function TryGet(Index: Integer; out AMailItem: TMailItem): Boolean;
    property SelIndex: Integer read FSelIndex write SetSelIndex;
    property Selected: TMailItem read FSelected;
  end;

  TFriendRecord = record
    Name: String[16];
    OnLine: Boolean;
  end;
  pTFriendRecord = ^TFriendRecord;

  TAssistant = class(uTypes.TuSerialObject)
  private
    FDefCommonHpName: String;
    FShowAllItem: Boolean;
    FEditHeroDrugWine: Byte;
    FAutoMagicTime: Integer;
    FAutoWideHit: Boolean;
    FEditCommonMpTimer: Integer;
    FAutoShield: Boolean;
    FAutoEatHeroDrugWine: Boolean;
    FDefCommonMpName: String;
    FUseHotkey: Boolean;
    FAutoHide: Boolean;
    FShowMonName: Boolean;
    FAutoUseHuoLong: Boolean;
    FShowTitle: Boolean;
    FFilterItemName: Boolean;
    FEditWine: Byte;
    FSPLongHit: Boolean;
    FSound: Boolean;
    FCleanCorpse: Boolean;
    FNoShift: Boolean;
    FFilterPickItem: Boolean;
    FAutoSearchItem: Boolean;
    FEditSpecialHp: Integer;
    FAutoEatWine: Boolean;
    FAutoUseJinYuan: Boolean;
    FAutoMagic: Boolean;
    FEditRandomHp: Integer;
    FAutoZhuriHit: Boolean;
    FRandomType: Integer;
    FEditSpecialMp: Integer;
    FSwitchMiniMap: Integer;
    FSpecialHp: Boolean;
    FAutoPuckUpItem: Boolean;
    FEditHeroWine: Byte;
    FEditCommonHp: Integer;
    FUseBatter: Integer;
    FRandomHp: Boolean;
    FEditSpecialHpTimer: Integer;
    FSwitchAttackMode: Integer;
    FEditDrugWine: Byte;
    FAutoEatHeroWine: Boolean;
    FMagicLock: Boolean;
    FSpecialMp: Boolean;
    FLongHit: Boolean;
    FEditCommonMp: Integer;
    FEditRandomHpTimer: Integer;
    FDefSpecialHpName: String;
    FCommonHp: Boolean;
    FShowBlood: Boolean;
    FShowName: Boolean;
    FAutoEatDrugWine: Boolean;
    FAutoFireHit: Boolean;
    FEditSpecialMpTimer: Integer;
    FRandomName: String;
    FEditCommonHpTimer: Integer;
    FDuraWarning: Boolean;
    FShowGroupHead: Boolean;
    FCommonMp: Boolean;
    FDefSpecialMpName: String;
    FShowNPCName: Boolean;
    FShowRankName: Boolean;
    FFilters: TStrings;
    FMonHints: TStrings;
    FShowJobLevel: Boolean;
    FShowBloodNum: Boolean;
    FHideDressEff: Boolean;
    FHideWepEff: Boolean;
    FFilterExpValue: Integer;
    FFilterExp: Boolean;
    FBGSound: Boolean;
    FSoundVolume: Integer;
    FBGSoundVolume: Integer;
    FShowHealthStatus: Boolean;
    FMonHintInterval: Integer;
    FAutoTurnDuFu:Boolean; //自动切换毒符
    FSmartWalk : Boolean;
    procedure SetMonHintInterval(const Value: Integer);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadDefault; override;
    procedure CheckValue;
  published
    property ShowAllItem: Boolean read FShowAllItem write FShowAllItem;
    property AutoPuckUpItem: Boolean read FAutoPuckUpItem write FAutoPuckUpItem;
    property FilterItemName: Boolean read FFilterItemName write FFilterItemName;
    property FilterPickItem: Boolean read FFilterPickItem write FFilterPickItem;
    property NoShift: Boolean read FNoShift write FNoShift;
    property ShowMonName: Boolean read FShowMonName write FShowMonName;
    property ShowName: Boolean read FShowName write FShowName;
    property ShowRankName: Boolean read FShowRankName write FShowRankName;
    property ShowNPCName: Boolean read FShowNPCName write FShowNPCName;
    property ShowTitle: Boolean read FShowTitle write FShowTitle;
    property ShowJobLevel: Boolean read FShowJobLevel write FShowJobLevel;
    property ShowGroupHead: Boolean read FShowGroupHead write FShowGroupHead;
    property ShowBlood: Boolean read FShowBlood write FShowBlood;
    property ShowHealthStatus: Boolean read FShowHealthStatus write FShowHealthStatus;
    property ShowBloodNum: Boolean read FShowBloodNum write FShowBloodNum;
    property CleanCorpse: Boolean read FCleanCorpse write FCleanCorpse;
    property DuraWarning: Boolean read FDuraWarning write FDuraWarning;
    property CommonHp: Boolean read FCommonHp write FCommonHp;
    property EditCommonHp: Integer read FEditCommonHp write FEditCommonHp;
    property EditCommonHpTimer: Integer read FEditCommonHpTimer write FEditCommonHpTimer;
    property DefCommonHpName: String read FDefCommonHpName write FDefCommonHpName;
    property DefCommonMpName: String read FDefCommonMpName write FDefCommonMpName;
    property DefSpecialHpName: String read FDefSpecialHpName write FDefSpecialHpName;
    property DefSpecialMpName: String read FDefSpecialMpName write FDefSpecialMpName;
    property RandomName: String read FRandomName write FRandomName;
    property CommonMp: Boolean read FCommonMp write FCommonMp;
    property EditCommonMp: Integer read FEditCommonMp write FEditCommonMp;
    property EditCommonMpTimer: Integer read FEditCommonMpTimer write FEditCommonMpTimer;
    property SpecialHp: Boolean read FSpecialHp write FSpecialHp;
    property EditSpecialHp: Integer read FEditSpecialHp write FEditSpecialHp;
    property EditSpecialHpTimer: Integer read FEditSpecialHpTimer write FEditSpecialHpTimer;
    property SpecialMp: Boolean read FSpecialMp write FSpecialMp;
    property EditSpecialMp: Integer read FEditSpecialMp write FEditSpecialMp;
    property EditSpecialMpTimer: Integer read FEditSpecialMpTimer write FEditSpecialMpTimer;
    property RandomHp: Boolean read FRandomHp write FRandomHp;
    property EditRandomHp: Integer read FEditRandomHp write FEditRandomHp;
    property EditRandomHpTimer: Integer read FEditRandomHpTimer write FEditRandomHpTimer;
    property RandomType: Integer read FRandomType write FRandomType;
    property LongHit: Boolean read FLongHit write FLongHit;
    property SPLongHit: Boolean read FSPLongHit write FSPLongHit;
    property AutoWideHit: Boolean read FAutoWideHit write FAutoWideHit;
    property AutoFireHit: Boolean read FAutoFireHit write FAutoFireHit;
    property AutoZhuriHit: Boolean read FAutoZhuriHit write FAutoZhuriHit;
    property AutoShield: Boolean read FAutoShield write FAutoShield;
    property AutoHide: Boolean read FAutoHide write FAutoHide;
    property AutoMagic: Boolean read FAutoMagic write FAutoMagic;
    property AutoMagicTime: Integer read FAutoMagicTime write FAutoMagicTime;
    property MagicLock: Boolean read FMagicLock write FMagicLock;
    property AutoEatWine: Boolean read FAutoEatWine write FAutoEatWine;
    property AutoEatHeroWine: Boolean read FAutoEatHeroWine write FAutoEatHeroWine;
    property AutoEatDrugWine: Boolean read FAutoEatDrugWine write FAutoEatDrugWine;
    property AutoEatHeroDrugWine: Boolean read FAutoEatHeroDrugWine write FAutoEatHeroDrugWine;
    property EditWine: Byte read FEditWine write FEditWine;
    property EditHeroWine: Byte read FEditHeroWine write FEditHeroWine;
    property EditDrugWine: Byte read FEditDrugWine write FEditDrugWine;
    property EditHeroDrugWine: Byte read FEditHeroDrugWine write FEditHeroDrugWine;
    property AutoSearchItem: Boolean read FAutoSearchItem write FAutoSearchItem;
    property AutoUseHuoLong: Boolean read FAutoUseHuoLong write FAutoUseHuoLong;
    property AutoUseJinYuan: Boolean read FAutoUseJinYuan write FAutoUseJinYuan;
    property Sound: Boolean read FSound write FSound;
    property SoundVolume: Integer read FSoundVolume write FSoundVolume;
    property BGSound: Boolean read FBGSound write FBGSound;
    property BGSoundVolume: Integer read FBGSoundVolume write FBGSoundVolume;
    property UseHotkey: Boolean read FUseHotkey write FUseHotkey;
    property SwitchAttackMode: Integer read FSwitchAttackMode write FSwitchAttackMode;
    property SwitchMiniMap: Integer read FSwitchMiniMap write FSwitchMiniMap;
    property UseBatter: Integer read FUseBatter write FUseBatter;
    property HideDressEff: Boolean read FHideDressEff write FHideDressEff;
    property HideWepEff: Boolean read FHideWepEff write FHideWepEff;
    property FilterExp: Boolean read FFilterExp write FFilterExp;
    property FilterExpValue: Integer read FFilterExpValue write FFilterExpValue;
    property Filters: TStrings read FFilters write FFilters;
    property MonHintInterval: Integer read FMonHintInterval write SetMonHintInterval;
    property MonHints: TStrings read FMonHints write FMonHints;
    property AutoTurnDuFu :Boolean read FAutoTurnDuFu write FAutoTurnDuFu;
    property SmartWalk : Boolean read FSmartWalk write FSmartWalk;
  end;

  TConfig = class(uTypes.TuSerialObject)
  private
    FAssistant: TAssistant;
    FCharName: String;
    FLoaded: Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadDefault; override;
    procedure Clear;
    procedure Load(const CharName: String; DeleteExists: Boolean);
    procedure LoadFilters;
    procedure Save;
    property CharName: String read FCharName;
    property Loaded: Boolean read FLoaded;
  published
    property Assistant: TAssistant read FAssistant write FAssistant;
  end;

  TDelChr = record
    ChrInfo: TUserCharacterInfo;
  end;

  pTDelChr = ^TDelChr;

  TStdItemHelper = record helper for TStdItem
    function sDesc: String;
    function DisplayName: String; inline;
  end;

  TClientItemHelper = record helper for TClientItem
    function S: TStdItem; inline;
    function DisplayName: String; inline;
    function Bind: Boolean;
    function TotalAbility: Int64;
    function Looks : Integer;
    function AniCount:Word;
  end;

  TShopItemHelper = record helper for TShopItem
    function StdItem: TStdItem; inline;
    function TotalAbility: Int64;
  end;

  TMissonKind = (mkMaster, mkLateral, mkDaily, mkBounty);
  TMissionState = (msGoing, msCompleted, msFinished, msOverdue, msDelete);

  TMissionItem = class
  public
    Kind: TMissonKind;
    RecordID: String;
    MissionID: String;
    State: TMissionState;
    NeedProgress: Integer;
    NeedMax: Integer;
    TargetNPC: Integer;
    Subject: String;
    Content: String;
  end;

  TMissionLinkItem = class
  public
    Kind: TMissonKind;
    MissionID: String;
    Subject: String;
    Content: String;
    TargetNPC: Integer;
    Level: Integer;
    ReLevel: Integer;
  end;

  TcMissions = class(TPersistent)
  private
    FDoing: TList;
    FUndo: TList;
    function GetDoing(index: Integer): TMissionItem;
    function GetDoingCount: Integer;
    function GetUnDo(index: Integer): TMissionLinkItem;
    function GetUnDoCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ClearDogin;
    procedure ClearUndo;
    procedure AddDoing(AKind: TMissonKind; const ARecordID, AMissionID, ASubject, AContent: String; ANeedMax, ANeedProgress, ATargetNPC: Integer; AState: TMissionState);
    procedure AddUndo(AKind: TMissonKind; const AMissionID, ASubject, AContent: String; ATargetNPC, ALevel, AReLevel: Integer);
    procedure DeleteDoing(AIndex: Integer);
    procedure DeleteUndo(AIndex: Integer);
    property DoingCount: Integer read GetDoingCount;
    property Doing[index: Integer]: TMissionItem read GetDoing; default;
    property UnDoCount: Integer read GetUnDoCount;
    property UnDo[index: Integer]: TMissionLinkItem read GetUnDo;
  end;

const
  BugFile = '!91M2Log.log';
  STR_STDMODEFILTER: array[0..15] of String =
    (
      '<全部>', '武器', '衣服', '头盔', '项链', '手镯', '戒指',
      '腰带', '靴子', '宝石', '时装', '药品', '技能', '坐骑', '盾', '其他'
    );


  // ==========================================
var
  g_Application: IApplication = nil;
  g_GameDevice: TAsphyreDevice;
  g_GameCanvas: TAsphyreCanvas;
  g_DisplaySize: TPoint2px;
  g_UIInitialized: Boolean = False;
  g_LoginConnected: Boolean = False;
  g_LogoHide: Boolean = False;
  g_Mail: TMailManager;
  g_MailItem: TClientItem;
  g_MailLoaded: Boolean;
  g_NewUI: Boolean = False;
  g_SNDAVer: Integer;
  g_sGoldName: String = '金币';
  g_sGameGoldName: String = '元宝';
  g_sGamePointName: String = '礼券';
  g_sGameGird: String = '灵符';
  g_sGameDiaMond: String = '金刚石';
  g_DrawCount: LongWord = 0;
  g_BottomHeight: Integer = 0;
  { ********************************************************************************* }
  g_boLockUpdate: Boolean;
  g_ItemVer: String;
  g_ItemList: TList<pTStdItem>;
  g_ItemEffList: TList<TItemSmallEffect>;
  g_ItemDesc: TStrings;
  g_ItemTypeNamesVer: String;
  g_ItemTypeNames: TDictionary<Byte, String>;
  g_ItemWay: TDictionary<Byte, String>; //物品产出途径来源
  g_SuitVer: String;
  g_SuitList: TList<pTSuitItem>;
  g_UIVer: String;
  g_UIManager: TdxWindowManager;
  g_MapVer: String;
  g_MapDesc: TMapDesc;
  g_DXUIWindow: TDWindow;
  g_ServerJobs: TChrJobs;
  g_AutoRunner: TuAutoRunner;
  g_SocketBuffer: TuMemBuffer; //Socket缓冲区
  g_ItemWayVer : string;
  g_CustomActorActionVer:String;
  g_CustomActorAction:TuCustomActorAction;
  g_SkillConfigVer:String;
  g_SkillEffectVer:String;
  (* ***************************************************************************** *)
  // 装备物品发光相关 20080223
  ItemLightTimeTick: LongWord;
  ItemLightImgIdx: Integer;
  g_ItemFlash: Integer;
  g_ItemFlash32: Integer;
  g_ItemFlashTick: Integer;
  g_PulseFlash: Boolean;
  g_PulseFlashTick: Integer;
  (* **************************************************************************** *)
  g_pwdimgstr: string;
  g_sAttackMode: string; // 攻击模式  20080228
  { ****************************************************************************** }
  m_dwUiMemChecktTick: LongWord; // UI释放内存检测时间间隔
  { ****************************************************************************** }
  // 天地结晶
  g_btCrystalLevel: Byte; // 天地结晶等级 20090201
  g_dwCrystalExp: LongWord; // 天地结晶当前经验 20090201
  g_dwCrystalMaxExp: LongWord; // 天地结晶升级经验 20090201
  g_dwCrystalNGExp: LongWord; // 天地结晶当前内功经验 20090201
  g_dwCrystalNGMaxExp: LongWord; // 天地结晶内功升级经验 20090201
  // 感叹号图标
  g_SighIconMethods: TStrings;
  g_SighIconHints: TStrings;
  { ****************************************************************************** }
  // 内功
  g_boIsInternalForce: Boolean; // 是否有内功
  g_btInternalForceLevel: Byte; // 内功等级
  g_btHeroInternalForceLevel: Byte; // 英雄内功等级
  g_dwAddNHPointer: LongWord = 0; // 内功恢复速度
  g_dwHeroAddNHPointer: LongWord = 0; // 英雄内功恢复速度
  g_dwNGDamage: LongWord = 0; // 内功伤害增加
  g_dwHeroNGDamage: LongWord = 0; // 英雄内功伤害增加
  g_dwUnNGDamage: LongWord = 0; // 内功伤害减少
  g_dwHeroUnNGDamage: LongWord = 0; // 英雄内功伤害减少
  g_dwExp69: LongWord = 0; // 内功当前经验
  g_dwMaxExp69: LongWord = 0; // 内功升级经验
  g_dwHeroExp69: LongWord = 0; // 英雄内功当前经验
  g_dwHeroMaxExp69: LongWord = 0; // 英雄内功升级经验
  g_InternalForceMagicList: TList; // 内功技能列表
  g_BatterMagicList: TList; // 连击技能列表
  g_BatterMenuNameList: TStringList;
  g_HeroBatterMenuNameList: TStringList;
  g_HeroBatterMagicList: TList; // 英雄连击列表
  g_HeroInternalForceMagicList: TList; // 英雄内功技能列表
  g_HeroAttectMode: Byte = 0; // 副将英雄攻击模式
  { --------------------英雄版2007.10.17 清清添加--------------------------- }
  g_RefuseCRY: Boolean = true; // 拒绝喊话
  g_Refuseguild: Boolean = true; // 拒绝行会聊天信息
  g_RefuseWHISPER: Boolean = true; // 拒绝私聊信息
  nMaxFirDragonPoint: Integer; // 英雄最大怒气
  m_nFirDragonPoint: Integer; // 英雄当前怒气
  g_nHeroSpeedPoint: Integer; // 敏捷
  g_nHeroHitPoint: Integer; // 准确
  g_nHeroAntiPoison: Integer; // 魔法躲避
  g_nHeroPoisonRecover: Integer; // 中毒恢复
  g_nHeroHealthRecover: Integer; // 体力恢复
  g_nHeroSpellRecover: Integer; // 魔法恢复
  g_nHeroAntiMagic: Integer; // 魔法躲避
  g_nHeroHungryState: Integer; // 饥饿状态
  g_HeroMagicList: TList; // 技能列表
  { ****************************************************************************** }
  // 右键穿装备代码
  g_boDblItem: Boolean = False; // 正在从背包双击点物品穿装备
  g_boHeroDblItem: Boolean = False; // 正在从英雄背包双击点物品穿装备
  g_boRightItem: Boolean = False; // 正在从背包右键点到英雄包裹
  g_boHeroRightItem: Boolean = False; // 正在从英雄背包右键点物品到主人包裹
  g_nDblItemTick: LongWord; // 右键穿装备时间间隔 20080308
  g_boRightItemRingEmpty: Boolean = False; // 人物戒指哪头是空 20080319
  g_boRightItemArmRingEmpty: Boolean = False; // 人物手镯哪头是空 20080319
  g_boHeroRightItemRingEmpty: Boolean = False; // 英雄物品哪头是空 20080319
  g_boHeroRightItemArmRingEmpty: Boolean = False; // 英雄手镯哪头是空 20080319
  { ****************************************************************************** }

  { ****************************************************************************** }
  // 粹练系统20080506
  g_ItemsUpItem: array [0 .. 2] of TClientItem;
  { ****************************************************************************** }
  // 酒馆1卷 20080515
  g_HeroAutoTrainingNum: Byte; // 副将英雄训练强度
  g_MentSayNum: Byte = 4;
  g_AssessHeroDataInfo: array [0 .. 1] of TAssessHeroDataInfo;
  g_TrainingHeroData: THeroDataInfo;
  g_boPlayDrink: Boolean; // 是否正在出拳 20080515
  g_sPlayDrinkStr1: string; // 斗酒对话框文字 上
  g_sPlayDrinkStr2: string; // 斗酒对话框文字 下
  g_PlayDrinkPoints: TList; // 酒馆NPC定点
  g_boRequireAddPoints1: Boolean; // 是否需要添加定点
  g_boRequireAddPoints2: Boolean; // 是否需要添加定点
  g_btNpcIcon: Byte; // NPC头像
  g_sNpcName: string; // NPC名字
  g_btPlayDrinkGameNum: Byte; // 猜拳码数
  g_btPlayNum: Byte; // 玩家码数
  g_btNpcNum: Byte; // NPC码数
  g_btWhoWin: Byte; // 0-赢  1-输  2-平
  g_DwPlayDrinkTick: LongWord; // 显示拳动画的时间间隔
  g_nImgLeft: Integer = 0; // 减去X坐标
  g_nPlayDrinkDelay: Integer = 0; // 延时
  g_nNpcDrinkLeft: Integer;
  g_nPlayDrinkLeft: Integer;
  g_dwPlayDrinkSelImgTick: LongWord; // 斗酒选择拳的动画
  g_nPlayDrinkSelImg: Integer; // 斗酒选择拳的浈

  g_btShowPlayDrinkFlash: Byte; // 显示喝酒动画 1为NPC 2为玩家
  g_DwShowPlayDrinkFlashTick: LongWord; // 显示喝酒动画的时间间隔
  g_nShowPlayDrinkFlashImg: Integer = 0; // 显示喝酒动画的图
  g_boPermitSelDrink: Boolean; // 是否禁止选酒
  g_boNpcAutoSelDrink: Boolean; // 是否NPC自动选酒
  g_btNpcAutoSelDrinkCircleNum: Byte = 0; // NPC选酒转动圈数
  g_DwShowNpcSelDrinkTick: LongWord; // NPC自动选酒圈数间隔
  g_btNpcDrinkTarget: Byte; // NPC选哪瓶酒  目标
  g_nNpcSelDrinkPosition: Integer = -1; // 显示选择酒动画位置
  g_NpcRandomDrinkList: TList; // NPC选酒随机不重复列表
  g_btPlaySelDrink: Byte = 7; // 玩家选择的酒 不为 0..5 那么不选择酒
  g_btDrinkValue: array [0 .. 1] of Byte; // 喝酒的醉酒值 0-NPC 1-玩家 20080517
  g_btTempDrinkValue: array [0 .. 1] of Byte; // 临时保存醉酒值 0-NPC 1-玩家 20080518
  g_boStopPlayDrinkGame: Boolean; // 结束了斗酒游戏
  g_boHumWinDrink: Boolean; // 玩家赢，是否喝了酒 20080614
  g_PDrinkItem: array [0 .. 1] of TClientItem; // 请酒的两个物品
  // 酒馆2卷
  g_MakeTypeWine: Byte = 1; // 酿造什么类型的酒    0为普通酒，1为药酒
  g_WineItem: array [0 .. 6] of TClientItem; // 酒的物品
  g_DrugWineItem: array [0 .. 2] of TClientItem; // 药酒的物品
  g_dwShowStartMakeWineTick: LongWord; // 显示酿酒动画
  g_nShowStartMakeWineImg: Integer; // 显示酿酒动画
  g_dwExp68: LongWord = 0; // 酒气护体当前经验
  g_dwMaxExp68: LongWord = 0; // 酒气护体最大经验
  g_dwHeroExp68: LongWord = 0; // 英雄酒气护体当前经验
  g_dwHeroMaxExp68: LongWord = 0; // 英雄酒气护体最大经验
  { ****************************************************************************** }
  // 自动寻路相关 20080617
  g_uAutoRun: Boolean = False;
  g_uPathMap: TLegendPathMap = nil;
  g_uPointList: TList<PPoint>;
  g_nAutoRunx: Integer; // 啊绊磊 窍绰 格利瘤
  g_nAutoRuny: Integer;
  { ****************************************************************************** }
  //内挂
  g_Config: TConfig;
  g_btSdoAssistantPage: Byte = 0;
  g_btSdoAssistantHelpPage: Byte = 0;
  g_dwAutoZhuRi: LongWord;
  g_dwAutoLieHuo: LongWord;
  g_AutoSearchItemTarget: TActor;
  // 时间间隔
  g_dwCommonHpTick: LongWord; // 普通HP保护的时间
  g_dwCommonMpTick: LongWord; // 普通MP保护的时间
  g_dwSpecialHpTick: LongWord; // 特殊HP保护的时间
  g_dwSpecialMpTick: LongWord; // 特殊HP保护的时间
  g_dwRandomHpTick: LongWord; // 随机HP保护的时间
  g_dwAutoUseHuoLong: LongWord; // 自动使用火龙珠时间
  g_dwAutoUseJinyuan: LongWord; // 自动使用金元丹时间
  g_dwButchItemTick: LongWord;

  g_boAutoEatWine: Boolean;
  g_boAutoEatHeroWine: Boolean;
  g_boAutoEatDrugWine: Boolean;
  g_boAutoEatHeroDrugWine: Boolean;
  g_dwAutoEatWineTick: LongWord; // 人物喝普通酒的时间间隔
  g_dwAutoEatHeroWineTick: LongWord; // 英雄喝普通酒的时间间隔
  g_dwAutoEatDrugWineTick: LongWord; // 人物喝药洒的时间间隔
  g_dwAutoEatHeroDrugWineTick: LongWord; // 英雄喝药酒的时间间隔
  g_btEditWine: Byte;
  g_btEditHeroWine: Byte;
  g_btEditDrugWine: Byte;
  g_btEditHeroDrugWine: Byte;
  { ****************************************************************************** }

  g_77Images: TWMImages;
  g_77CustomImages: TWMImages;
  g_77Title: TWMImages;
  g_77Icons: TWMImages;
  g_77MMap: TWMImages;
  g_77WBagItemImages: TWMImages;
  g_77WStateItemImages: TWMImages;
  g_77WDnItemImages: TWMImages;
//  g_77HumImages: TWMImages;
  g_77WWeaponImages: TWMImages;

  //地图相关 随云
  g_WTilesImages: array [0 .. 255] of TWMImages;
  g_WSmTilesImages: array [0 .. 255] of TWMImages;
  g_WObjectArr: array [0 .. 255] of TWMImages;

  g_WMonImagesArr: array [0 .. 99] of TWMImages;
  g_WHumWingImages: array [0 .. 19] of TWMImages;
  g_WHumImgImages: array [0 .. 19] of TWMImages;

  //刺客衣服 以及 刺客衣服特效
  g_WHumImgCKImages: array [0 .. 19] of TWMImages;
  g_WHumWingCKImages: array [0 .. 19] of TWMImages;

  g_WHumImgWSImages: array [0 .. 19] of TWMImages;
  g_WWeaponImages: array [0 .. 19] of TWMImages;
  g_WeaponEffectImages: array[0..19] of TWMImages;
  g_WHumImgGJSImages: array [0 .. 19] of TWMImages;
  g_WWeaponGJSImages: array[0..19] of TWMImages;

  //刺客左右手武器
  g_WWeaponCKLImages: array[0..9] of TWMImages;
  g_WWeaponCKRImages: array[0..9] of TWMImages;

  //刺客左右手武器特效
  g_WWeaponCKLEffect: array[0..9] of TWMImages;
  g_WWeaponCKREffect: array[0..9] of TWMImages;

  g_WWeaponWSImages: array[0..19] of TWMImages;
  g_WHorseImages: array[0..9] of TWMImages;
  g_WHorseHumImages: array[0..19] of TWMImages;
  g_WHorseHumWingImages: array[0..19] of TWMImages;
  g_WNpcImagesArr: array [0..9] of TWMImages;

  g_77HumImages: array[RES_IMG_BASE..RES_IMG_MAX] of TWMImages;
  g_77WeponImages: array[RES_IMG_BASE..RES_IMG_MAX] of TWMImages;
  g_77WeponLImages: array[RES_IMG_BASE..RES_IMG_MAX] of TWMImages;
  g_77HorseImages: array[RES_IMG_BASE..RES_IMG_MAX] of TWMImages;
  g_77HorseHumImages: array[RES_IMG_BASE..RES_IMG_MAX] of TWMImages;
  g_77MonImages: array[RES_IMG_BASE..RES_IMG_MAX] of TWMImages;
  g_77ShieldImages: array[RES_IMG_BASE..RES_IMG_MAX] of TWMImages;

  g_WMainImages: TWMImages;
  g_WMain2Images: TWMImages;
  g_WMain3Images: TWMImages;
  g_WChrSelImages: TWMImages;
  g_WChrSel2Images: TWMImages;
  g_WEffectLogin: TWMImages;
  g_WMMapImages: TWMImages;
  g_WBagItemImages: TWMImages;
  g_WStateItemImages: TWMImages;
  g_WStateEffectImages: TWMImages;
  g_WDnItemImages: TWMImages;
  g_WNSelectImages: TWMImages;

  g_WHairImgImages: TWMImages;
  g_WHair2ImgImages: TWMImages;
  g_WHair3ImgImages: TWMImages;
  g_WHairGJSImages: TWMImages;
  g_WHairCIKImages: TWMImages;
  g_WHorseHairImgImages: TWMImages;

  g_WMagIconImages: TWMImages;
  g_WMagIcon2Images: TWMImages;
  g_WMagicImages: TWMImages;
  g_WMagic2Images: TWMImages;
  g_WMagic3Images: TWMImages;
  g_WMagic4Images: TWMImages;
  g_WMagic5Images: TWMImages;
  g_WMagic6Images: TWMImages;
  g_WMagic7Images: TWMImages;
  g_WMagic716Images: TWMImages;
  g_WMagic8Images: TWMImages;
  g_WMagic816Images: TWMImages;
  g_WMagic9Images: TWMImages;
  g_WMagic10Images: TWMImages;
  g_WMagicCKImages: TWMImages;
  g_WMagicCk_NsImage : TWMImages;
  g_WEffectImages: TWMImages;
  g_WEffectGJSImages: TWMImages;
  g_WEffectWSImages: TWMImages;
  g_WDragonImages: TWMImages;
  g_WUi1Images: TWMImages;
  g_WUi2Images: TWMImages;
  g_WUi3Images: TWMImages;
  g_WMonEffect: TWMImages;
  g_WUiNImages: TWMImages;
  g_WUiCommonImages: TWMImages;

  g_WWisWeapon2: TWMImages;
  g_WWiscboWeapon: TWMImages;
  g_WWiscboWeapon3: TWMImages;
  g_WWiscboHumhair: TWMImages;
  g_WWiscboHumWing: TWMImages;
  g_WWiscboHumWing2: TWMImages;
  g_WWiscboHumWing3: TWMImages;
  g_WWiscboWing: TWMImages;
  g_WWiscboHum: TWMImages;
  g_WWiscboHum3: TWMImages;

  g_sServerName: String; // 服务器显示名称
  g_sServerMiniName: String; // 服务器名称
  g_sServerAddr: String = '127.0.0.1'; // 127.0.0.1
  g_nServerPort: Integer = 7000;
  g_sSelChrAddr: String;
  g_nSelChrPort: Integer;
  g_sRunServerAddr: String;
  g_nRunServerPort: Integer;

  g_boSendLogin: Boolean; // 是否发送登录消息
  g_boServerConnected: Boolean;
  g_SoftClosed: Boolean; // 小退游戏
  g_ChrAction: TChrAction;
  g_ConnectionStep: TConnectionStep;

  g_sCurFontName: String = '宋体'; // 宋体
  g_boFullScreen: Boolean = False;

  g_OldPixeX, g_OldPixeY: Integer;
  g_boXYChanged: Boolean;
  g_sMapTitle: String;
  g_sMapName: String;
  g_nMapMusic: Integer;
  g_sMapMusic: String;
  g_nMapMusicLoop: Integer;
  g_boMapDup: Boolean;
  g_boDialog: Boolean;
  g_boChangeMapStopMusic: Boolean;

  g_Pilot: TActor;
  g_boISTrail: Boolean;
  g_Servers: TStringList; // 服务器列表
  g_MagicList: TList; // 技能列表
  g_Titles: TList;
  g_ActiveTitle: Byte;
  g_TitlesPage: Integer;
  g_FocusTitle: Integer;
  g_GroupMembers: TList<PTGroupUser>;
  g_GroupSelIndex: Integer;
  g_ISGroupMaster: Boolean;
  g_MenuItemList: TList;
  g_DropedItemList: TList; // 地面物品列表
  g_ChangeFaceReadyList: TList; //

  g_nBonusPoint: Integer;
  g_nSaveBonusPoint: Integer;
  g_BonusTick: TNakedAbility;
  g_BonusAbil: TNakedAbility;
  g_NakedAbil: TNakedAbility;
  g_BonusAbilChg: TNakedAbility;

  g_sGuildName: String; // 行会名称
  g_sGuildRankName: String; // 职位名称

  g_btMemberType: Byte = 0;
  g_btMemberLevel: Byte = 0;

  g_dwLastObjectsTick: LongWord = 0;
  g_dwDrawTick: LongWord = 0;
  g_boInObjectsProc: Boolean = False;
  g_dwLatestStruckTick: LongWord; // 最后弯腰时间
  //g_dwLatestSpellTick: LongWord; // 最后魔法攻击时间
  g_dwLatestHitTick: LongWord; // 最后物理攻击时间(用来控制攻击状态不能退出游戏)
  g_dwLatestMagicTick: LongWord; // 最后放魔法时间(用来控制攻击状态不能退出游戏)
  g_dwLastSwitchHorse: LongWord;

  g_dwMagicDelayTime: LongWord;
  g_dwMagicPKDelayTime: LongWord;

  g_nMouseCurrX: Integer; // 鼠标所在地图位置座标X
  g_nMouseCurrY: Integer; // 鼠标所在地图位置座标Y
  g_nMouseX: Integer; // 鼠标所在屏幕位置座标X
  g_nMouseY: Integer; // 鼠标所在屏幕位置座标Y
  g_boActionLock: Boolean;

  g_nTargetX: Integer; // 目标座标
  g_nTargetY: Integer; // 目标座标
  g_TargetCret: TActor;
  g_FocusCret: TActor;
  g_MagicLockActor: TActor;
  g_MagicTarget: TActor;
  g_SelCret: TActor;
  g_CollectCret: TActor;
  g_CollectTick: LongWord;
  g_CollectTime: Integer;
  g_LastQueryChrTick: LongWord;
  g_LastSelNPC: TActor;
  g_LastNpcClick: LongWord;
  g_SelCretX, g_SelCretY: Integer;

  g_boMapMoving: Boolean; // 甘 捞悼吝, 钱副锭鳖瘤 捞悼 救凳
  g_boMapMovingWait: Boolean;
  // g_boCheckSpeedHackDisplay :Boolean;   //是否显示机器速度数据
  g_boViewMiniMap: Boolean; // 是否显示小地图
  g_boMiniMapExpand: Boolean = true; // 是否展开小地图
  g_boTransparentMiniMap: Boolean; // 是否透明显示小地图
  g_nMiniMapIndex: Integer; // 小地图号
  g_ISOpenMiniMap: Boolean; // 要求显示小地图
  g_ISOpenMaxMiniMap: Boolean; // 是否显示大号小地图
  g_btMiniMapType: Byte;
  g_boEnableItemBasePower: Boolean;
  g_nShowMagBubbleLevel : Integer = 28;

  // NPC 相关
  g_nCurMerchant: Integer;
  g_boBigStore: Boolean;
  g_nMDlgX: Integer;
  g_nMDlgY: Integer;
  g_dwChangeGroupModeTick: LongWord;
  g_dwChangeRecruitMemberModeTick: LongWord;
  g_dwDealActionTick: LongWord;
  g_dwQueryMsgTick: LongWord;
  g_nDupSelection: Integer;
  // g_boMoveSlow              :Boolean;   //负重不够时慢动作跑   20080816注释掉起步负重
  g_boAllowGroup: Boolean;
  g_boAllowDeal: Boolean;
  g_boAllowGuild: Boolean;
  g_boAllowGroupRecall: Boolean;
  g_boAllowGuildRecall: Boolean;
  g_boAllowReAlive: Boolean;
  g_boDiableSTRUCK: Boolean = True;
  g_boRecruitMember:Boolean; //是否招募队员
  g_nMaxGroupCount:Integer; //一个队伍最多的人数
  // 人物信息相关
  g_MyAbil: TAbility; // 基本属性 g_Myself 中也有 这里只是左右一个副本 提供TDVarText 来进行获取变量值
  g_MySubAbility: TSubAbility;
  g_nMyHungryState: Integer; // 饥饿状态
  g_btGameGlory: Byte;
  g_MyMixedAbility: Int64;
  g_dwUseItemInterval : Cardinal = 500;
  g_dwUseDrugInterval : Cardinal = 500;
  g_nBeadWinExp: Word; // 聚灵珠的经验    由M2发来  20080404
  { ****************************************************************************** }
  // 商铺
  g_ShopTypePage: Integer; // 商铺类型页
  g_ShopPage: Integer; // 商铺页数
  g_ShopReturnPage: Integer; // 插件返回商铺页数
  g_ShopItem: TShopItem;
  g_MouseShopItem: TShopItem;
  g_ShopItemList: TList; // 商铺物品列表
  g_ShopSpeciallyItemList: TList; // 商铺奇珍物品列表
  g_BuyGameGirdNum: Integer; // 兑换灵符的数量  20080302
  ShopIndex: Integer;
  ShopSpeciallyIndex: Integer;
  ShopGifTime: LongWord;
  ShopGifFrame: Integer;
  ShopGifExplosionFrame: Integer;
  g_dwShopTick: LongWord;
  g_dwQueryItems: LongWord; // 限制人物刷新包裹
  { ****************************************************************************** }
  // 元宝寄售系统 20080316
  g_SellOffItems: array [0 .. 8] of TClientItem;
  g_SellOffDlgItem: TClientItem;
  g_SellOffInfo: TClientDealOffInfo; // 寄售查看正在出售物品 和买物品
  g_SellOffName: string; // 寄售对方名字
  g_SellOffGameGold: LongWord; // 寄售的元宝数量
  g_SellOffGameDiaMond: Integer; // 寄售的金刚石数量
  g_SellOffItemIndex: Byte = 200; // 选择某个物品红字显示
  { ****************************************************************************** }
  // 小地图
  g_nMouseMinMapX: Integer;
  g_nMouseMinMapY: Integer;
  g_nMouseMaxMapX: Integer;
  g_nMouseMaxMapY: Integer;
  g_nMouseMaxMapOldX: Integer = 0;
  g_nMouseMaxMapOldY: Integer = 0;
  g_nMouseMaxMapOffsetX: Integer = 0;
  g_nMouseMaxMapOffsetY: Integer = 0;
  g_nMouseMaxMapKeep: Boolean;
  m_dwBlinkTime: LongWord;
  m_boViewBlink: Boolean;
  { ****************************************************************************** }
  // 排行榜
  g_Orders: TuOrderObject;
  { ****************************************************************************** }

  g_wAvailIDDay: Word;
  g_wAvailIDHour: Word;
  g_wAvailIPDay: Word;
  g_wAvailIPHour: Word;

  g_MySelf: THumActor;
  g_MyNextBatterMagics: TList;
  g_MyNextMagics: TList;
  g_MyOpendMagics: TList;
  g_UseItems: array [U_DRESS .. U_MAXUSEITEMIDX] of TClientItem;
  g_MyDressInnerEff: TItemInnerEffect;
  g_MyWeponInnerEff: TItemInnerEffect;

  { ****************************************************************************** }
  // 宝箱
  g_dwBoxsTick: LongWord;
  g_nBoxsImg: Integer;
  g_boPutBoxsKey: Boolean; // 是否放上宝箱钥匙
  g_BoxsItems: array [0 .. 8] of TClientItem;
  g_BoxShape: Integer;
  g_nBoxGold, g_nBoxGameGold, g_nBoxIncGold, g_nBoxIncGameGold, g_nBoxsUseMax: Integer;

  g_dwBoxsTautologyTick: LongWord; // 乾坤动画
  g_BoxsTautologyImg: Integer; // 乾坤动画

  g_boBoxsFlash: Boolean;
  g_dwBoxsFlashTick: LongWord;
  g_BoxsFlashImg: Integer;
  g_BoxsbsImg: Integer; // 边框图
  g_BoxsShowPosition: Integer = -1; // 显示转动动画位置
  g_BoxsShowPositionTick: LongWord;
  g_boBoxsShowPosition: Boolean; // 是否开始转动
  g_BoxsMoveDegree: Integer; // 转动次数
  g_BoxsShowPositionTime: Integer; // 转动间隔
  g_BoxsCircleNum: Integer; // 转动圈数
  g_boBoxsMiddleItems: Boolean; // 显示中间物品
  g_BoxsMakeIndex: Integer; // 接收过来的可得物品ID
  g_BoxsGold: Integer; // 接收过来的转动需要金币
  g_BoxsGameGold: LongWord; // 接收过来的转动需要元宝
  g_BoxsFirstMove: Boolean; // 是否第一次转动宝箱
  g_BoxsTempKeyItems: TClientItem; // 宝箱钥匙临时存放物品  失败则返回次物品   20080306
  g_ItemArr: array [0 .. MAXBAGITEM + 6 - 1] of TClientItem;
  (* ***************************************************************************** *)
  // 自动防药临时变量
  g_TempItemArr: TClientItem; // 自动放药 临时储存 20080229
  g_TempIdx: Byte;
  (* ***************************************************************************** *)
  g_boBagLoaded: Boolean;
  g_boServerChanging: Boolean;

  // 键盘相关
  g_ToolMenuHook: HHOOK;
  g_nLastHookKey: Integer;
  g_dwLastHookKeyTime: LongWord;

  g_nCaptureSerial: Integer; // 抓图文件名序号
  g_nSendCount: Integer; // 发送操作计数
  // g_nReceiveCount              :Integer; //接改操作状态计数
  g_nSpellCount: Integer; // 使用魔法计数
  g_nSpellFailCount: Integer; // 使用魔法失败计数
  g_nFireCount: Integer; //

  // 买卖相关
  g_SellDlgItem: TClientItem;
  g_SellDlgItemSellWait: TClientItem;
  g_DealDlgItem: TClientItem;
  g_boQueryPrice: Boolean;
  g_dwQueryPriceTime: LongWord;
  g_sSellPriceStr: String;

  // 交易相关
  g_DealItems: array [0 .. 9] of TClientItem;
  g_DealRemoteItems: array [0 .. 19] of TClientItem;
  g_nDealGold: Integer;
  g_nDealRemoteGold: Integer;
  g_boDealEnd: Boolean;
  g_sDealWho: String; // 交易对方名字
  g_MouseItem: TClientItem;
  g_boRDealOK: Boolean = False;
  g_boDealOK: Boolean = False;
  { ****************************************************************************** }
  // 挑战
  g_sChallengeWho: String; // 挑战对方名字
  g_ChallengeItems: array [0 .. 3] of TClientItem;
  g_ChallengeRemoteItems: array [0 .. 3] of TClientItem;
  g_nChallengeGold: Integer;
  g_nChallengeRemoteGold: Integer;
  g_nChallengeDiamond: Integer;
  g_nChallengeRemoteDiamond: Integer;
  g_boChallengeEnd: Boolean;
  g_dwChallengeActionTick: LongWord;
  g_ChallengeDlgItem: TClientItem;
  { ****************************************************************************** }
  // 查看别人装备
  g_boUserIsWho: Byte; // 1为英雄 2为分身

  { ****************************************************************************** }
  // 连击相关
  g_nBatterX: Integer;
  g_nBatterY: Integer;
  g_BatterDir: Byte;
  g_nBatterTargetid: Integer;
  g_MyPulse: THumPulses;
  g_MyHeroPulse: THumPulses;
  g_boisOpenPuls: Boolean; // 是否打开英雄经络
  g_BatterOrder: array [0 .. 2] of Word; // 记录连击次序的ID
  g_HeroBatterOrder: array [0 .. 2] of Word; // 记录连击次序的ID
  g_BatterStormsRate: THumStormsRate; // 暴击几率表
  g_OpenPulseNeedLev: array [0 .. 19] of Byte;
  { ****************************************************************************** }
  // 关系系统
  g_btFriendTypePage: Byte = 1; // 菜单页数 20080527
  g_btFriendPage: Byte = 0; // 好友和黑名单页数 20080527
  g_btFriendIndex: Integer = 0;
  g_btFriendMoveX: Integer;
  g_btFriendMoveY: Integer;
  { ****************************************************************************** }
  g_boItemMoving: Boolean; // 正在移动物品
  g_MovingItem: TMovingItem;
  g_WaitingUseItem: TMovingItem;
  g_WaitingUseItemTime:Cardinal; //加入穿戴物品时间 以便防止 服务端 因为异常不下发 导致卡装备
  g_FocusItem: pTDropItem;
  g_dwLastDropItem: LongWord;
  g_dwLastClkFun: LongWord;
  g_boLockMoveItem: Boolean;
  g_dwLockMoveItemTimeStart: LongWord;
  g_nLockMoveItemTime: Integer;
  g_boDBClickItemWait:Boolean = False;

  // g_boViewFog                  :Boolean;  //是否显示黑暗 20080816注释显示黑暗
  // g_boForceNotViewFog          :Boolean = False;  //免蜡烛  20080816注释免蜡
  g_nDayBright: Integer;
  g_nAreaStateValue: Integer; // 显示当前所在地图状态(攻城区域、)
  g_nRunReadyCount: Integer; // 助跑就绪次数，在跑前必须走几步助跑

  ClientConf: TClientConf;
  g_dwPHHitSound: LongWord;
  g_EatingItem: TClientItem;
  g_EatingItemIndex: Integer;
  g_dwEatTime: LongWord; // timeout...
  g_dwEatDrugTime:LongWord;

  g_dwDizzyDelayStart: LongWord;
  g_dwDizzyDelayTime: LongWord;

  g_boDoFadeOut: Boolean;
  g_boDoFadeIn: Boolean;
  g_nFadeIndex: Integer;
  g_boDoFastFadeOut: Boolean;

  g_dwCIDHitTime: LongWord;

  g_boAutoDig: Boolean; // 自动锄矿
  g_boSelectMyself: Boolean; // 鼠标是否指到自己
  g_boZodiac : Boolean;    //十二生肖和首饰盒功能是否开启
  g_boJewelryBox :Boolean;

  {$IFDEF DEBUG}
  g_SocketIdent : Array [0..High(WORD)] of Cardinal; //每个通讯消息收到的次数
  g_SocketLength : Array [0..High(WORD)] of Cardinal;//每个通讯消息收到的共计长度
  {$ENDIF}

  { ****************************************************************************** }
  g_nDuFuIndex: Byte = 0; // 自动毒符的索引  20080315
  g_nDuWhich: Byte; // 记录当前使用的是哪种毒 20080315
  g_WalkTimeRate: Single = 1.0;
  g_HitTimeRate : Single = 1.0;
  g_RunTimeRate: Single = 1.0;

  g_SpellTimeRate: Single = 1.0;
  g_DeathColorEffect: TColorEffect = ceGrayScale; // 死亡颜色
  g_boCanRunHuman: Boolean = False; // 是否可以穿人
  g_boCanRunMon: Boolean = False; // 是否可以穿怪
  g_boCanRunNpc: Boolean = False; // 是否可以穿NPC
  g_boCanStartRun: Boolean = true; // 是否允许免助跑
  g_boParalyCanRun: Boolean = False; // 麻痹是否可以跑
  g_boParalyCanWalk: Boolean = False; // 麻痹是否可以走
  g_boParalyCanHit: Boolean = False; // 麻痹是否可以攻击
  g_boParalyCanSpell: Boolean = False; // 麻痹是否可以魔法
  g_boAddPointEnabled: Boolean = True;
  g_boSoulEnabled: Boolean = true;
  g_boHoleEnabled: Boolean = true;
  g_boUpgradeEnabled: Boolean = true;
  g_boDropBindFree: Boolean = true;
  // g_boMoveSlow1          :Boolean  = False; //免负重； 20080816注释掉起步负重
  g_boShowFashion: Boolean = true;
  g_boShowTitleEffect: Boolean = true;
  g_AutoPut: Boolean = true; // 自动解包
  g_boAutoTalk: Boolean = False; // 自动喊话
  g_sAutoTalkStr: string; // 喊话内容
  g_boSDMinimap: Boolean = False;
  // 外挂功能变量结束
  { ****************************************************************************** }
  g_nAutoTalkTimer: LongWord = 8; // 自动喊话  间隔

  g_nAutoMagicTimekick: LongWord;
  g_nAutoMagicKey: Word;
  g_nAutoMagic: LongWord;
  g_SHowWarningDura: DWord;
  g_dwAutoPickupTick: LongWord;
  g_AutoPickupList: TList;

  g_boOwnerMsg: Boolean;
  g_boUseBatter: Boolean; // 使用连击
  g_boCanUseBatter: Boolean; // 可以使用连击
  g_boCanSJUEHit: Boolean; // 三绝杀     20091205 邱高奇
  g_boCanZXINHit: Boolean; // 追心刺     20091205 邱高奇
  g_boAutoUseSkill150: Boolean = True; //自动使用精准箭术
  g_boCanUseSmartWalk:Boolean; //服务端是否允许客户端使用 智能追踪

  g_FilterItemNameList: TObjectDictionary<String, TShowItem>;
  g_boShowAllItemEx: Boolean = False; // Alt键显示全部物品
  UIWindowManager: TdxClientWindowManager;
  g_CurMapDesc: TuMapDescManager;
  g_Missions: TcMissions;
  g_MissionTopIndex: Integer = 0;
  g_SelectMission: Integer = -1;
  g_MissionListTopIndex: Integer = 0;
  g_MissionListSelected: Integer = -1;
  g_MissionListFocused: Integer = -1;

  g_nGold :Integer;   //金币数量
  g_dwGameGold:Cardinal;  // 游戏币 元宝
  g_nGamePoint:Integer;   //游戏点
  g_nGameDiaMond : Integer; //金刚石数量
  g_nGameGird : Integer; // 灵符数量  2008.02.11
  g_nGameGlory: Integer; // 荣誉数量 20080511

  // 市场
  g_boStallLock: Boolean;
  g_boPutOn: Boolean;
  g_boStallLoaded, g_boStallListLoaded: Boolean;
  g_MarketItem: TMovingStallItem;
  g_SelMarketName: String;
  g_SelMarketPlay: String;
  g_MarketNames: TStrings;
  g_MarketPlays: TStrings;
  g_MyMarketName: String;
  g_MyMarketGold: Integer;
  g_MyMarketGameGold: Integer;
  g_MyMarket: array [0 .. 11] of TClientStallItem;
  g_WhoStall: array [0 .. 11] of TClientStallItem;
  g_StallItems: array[0..11] of TClientStallItem;
  g_StallBuyItems: array[0..11] of TClientStallBuyItemFull;
  g_StallLogs: TStrings;
  g_QueryStallItems: array[0..11] of TClientStallItem;
  g_QueryStallBuyItems: array[0..11] of TClientStallBuyItemFull;
  g_QueryStallLogs: TStrings;
  g_QueryStallVersion: Integer = 0;
  g_MyStallGold: Integer;
  g_MyStallGameGold: Integer;
  g_StallGoldCommission: Integer = 0;
  g_StallGameGoldCommission: Integer = 0;
  g_btHowUpgradeOneStar: Byte = 1;
  g_AddLevelCondition: array [0 .. 5] of Byte = (
    3,
    6,
    9,
    12,
    15,
    18
  );
  g_Friends: TList; // 好友
  g_Enemies: TList; // 仇人(黑名单)
  g_boForceMapDraw: Boolean = False;
  g_boForceMapFileLoad: Boolean = False;
  g_ClientDataTempString : AnsiString = '';

  UserState1: TUserStateInfo;
  UserFightPower : Int64;
  g_JobName : String = ''; //为TDVarTextField 做副本拷贝
  g_MyName : String = '';  //为TDVarTextField 做副本拷贝
  ClientParamStr:string;
  g_SkillData : TSkillManager;
  g_SkillEffectData:TSkillEffectManager;
  g_SkillDataVer:String;
  g_SkillEffectDataVer:String;


type
  pTCustomAction = ^ TCustomAction;
  TCustomAction = record
    StartOffset:Integer;
    MonsterAction : TMonsterAction;
    Lib:TWMImages;
  end;
var
  g_CustomNPCAction : array [CUSTOM_ACTOR_ACTION_APPR_BASE..CUSTOM_ACTOR_ACTION_APPR_MAX] of pTCustomAction;
  g_CustomMonsterAction : array [CUSTOM_ACTOR_ACTION_APPR_BASE..CUSTOM_ACTOR_ACTION_APPR_MAX] of pTCustomAction;
//场景创建
function CreateLoginScene: TCustomLoginScene;
function CreateSelectChrScene: TSelectChrScene;
function CreateLoginNotice: TLoginNotice;
//
procedure LoadWMImagesLib(AOwner: TComponent);
procedure InitWMImagesLib();
procedure UnLoadWMImagesLib();
procedure GetObjs(nUnit, nIdx: Integer; var D: TAsphyreLockableTexture); inline;
procedure GetObjsEx(nUnit, nIdx: Integer; var px, py: Integer; var D: TAsphyreLockableTexture); inline;
procedure GetTilesImages(BkIndex: Byte; ImageIndex: Integer; var D: TAsphyreLockableTexture); inline;
procedure GetSmTilesImages(SmIndex: Byte; ImageIndex: Integer; var D: TAsphyreLockableTexture); inline;
function GetMonImg(nAppr: Integer): TWMImages;
function GetNpcImg(nAppr: Integer): TWMImages;
procedure InitMonImg();
procedure InitNpcImg();
procedure InitObjectImg();
procedure InitTitles;
procedure InitSmTiles;
function GetShowItem(ItemIdx: Integer): TShowItem;
function GetItemNameColor(ItemIdx: Word; Default: Byte): TColor;
function GetItemIndexByName(const ItemName: String): Integer;
function GetClientItemByName(const ItemName: String): TClientItem;
procedure UpdateShowItem(const ItemName: String; AShowItem: TShowItem);
procedure InitApplication;
function GetStorePriceName(_Type: Byte): String; inline;
procedure OpenBrowser(const AUrl: String);
function TryGetMMap(MiniMapID: Integer; out DSurface: TAsphyreLockableTexture): Boolean; inline;

function GetStateItemImgXY(nIndex: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetDressStateItemImgXY(Job, Sex: Byte; Item: TClientItem; var ax, ay: Integer): TAsphyreLockableTexture;
procedure StateDrawBlend(DSurface: TAsphyreCanvas; X, Y, StateImageIndex : Integer; Blendmode: Integer = 0);
procedure StateDrawBlendEx(Images: TWMImages; DSurface: TAsphyreCanvas; X, Y, StateImageIndex, Blendmode: Integer);
procedure StateDressDrawBlend(DSurface: TAsphyreCanvas; Dress, X, Y, ImageIndex, Blendmode: Integer);
procedure DressStateDrawBlend(ADress, AniCount, TimeTick: Integer; DSurface: TAsphyreCanvas; X, Y: Integer); inline;
procedure StateWeponDrawBlend(DSurface: TAsphyreCanvas; Weapon, X, Y, ImageIndex:Integer; Blendmode: Integer = 0);
procedure WeponStateDrawBlend(AWeapon, AniCount, TimeTick: Integer; DSurface: TAsphyreCanvas; X, Y: Integer); inline;
procedure ShieldDrawBlend(AShield, AniCount, TimeTick: Integer; DSurface: TAsphyreCanvas; X, Y: Integer); inline;
function GetImageItemXY(Images: TWMImages; nIndex: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetImageItem(Images: TWMImages; nIndex: Integer): TAsphyreLockableTexture; inline;
procedure ImageItemDrawBlend(Images: TWMImages; DSurface: TAsphyreCanvas; X, Y, ImageIndex, Blendmode: Integer);
procedure ItemFlashDrawBlend(Flash, TimeTick: Integer; DSurface: TAsphyreCanvas; X, Y: Integer); inline;
procedure ItemFlashDrawBlendEx(PItem:PTClientItem; DSurface: TAsphyreCanvas; CellWidth, CellHeight, X, Y: Integer);
procedure ItemFlashDrawBlendEx_StateItem(PItem: PTClientItem; DSurface: TAsphyreCanvas; CellWidth, CellHeight, X, Y: Integer);

function GetHumHairImg(Job, Sex, Hair: Byte; nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetHumInnerHairImg(Job, Sex, Hair: Byte; var ax, ay: Integer): TAsphyreLockableTexture; inline;
// 普通
function GetWWeaponImg(Job, m_btSex: Byte; Weapon, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetWWeaponWinImage(Job, m_btSex: Byte; nEffect, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetWLWeaponImg(Job, m_btSex: Byte; Weapon, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetWLWeaponWinImage(Job, m_btSex: Byte; nEffect, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetShieldImg(Shield, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetShieldWinImage(Shield, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetWHumImg(Job, m_btSex: Byte; Dress, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetWHumWinImage(Job, m_btSex: Byte; nEffect, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
// 合击
function GetWCBOHumImg(Dress, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetWCBOHumEffectImg(Effect, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetWCBOWeaponImg(Weapon, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
//骑马
function GetHorseImage(Horse, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetHorseHumImage(Dress, m_btSex, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetHorseHumWinImage(Job, m_btSex: Byte; nEffect, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetHorseHairImage(Hair, HairOffset: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
//
function GetMagicIcon(var AMagic: TClientMagic; Lvl, Strengthen: Integer; ADowned: Boolean): TAsphyreLockableTexture;

//
function GetWISWeaponImg(Weapon, m_btSex, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetWISHumImg(Dress, m_btSex, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetWISHumHairImg(Dress, m_btSex, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;
function GetWISHumWingImg(Effect, m_btSex, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture; inline;

procedure AddMarketItemToMyMarket(Idx, Gold, GameGold: Integer);
procedure UpdateMyMarketItem(Gold, GameGold: Integer);
procedure ClearMyMarketItem(Idx: Integer);
procedure ClearWhoMarketItemByMoving(IsUpdate: Boolean; Count: Integer);

procedure AddStallItemToMyStall(Idx, Gold, GameGold: Integer);
procedure UpdateMyStallItem(Gold, GameGold: Integer);
procedure ClearMyStallItem(Idx: Integer);
procedure ClearWhoStallItemByMoving(IsUpdate: Boolean; Count: Integer);
procedure AddStallBuyItemToMyStallBuy(Idx, Gold, GameGold, Count: Integer);
procedure ClearMyStallBuyItem(Idx: Integer);
procedure UpdateQueryStallItemBuy(AIndex, ACount: Integer);

procedure LoadStdItems;
procedure SaveStdItems;
procedure LoadStdItemsDesc;
procedure SaveStdItemsDesc;
procedure LoadItemTypeNames;
procedure SaveItemTypeNames;
procedure LoadItemWay;
procedure SaveItemWay;
procedure ClearItems;
procedure LoadSuitItems;
procedure SaveSuitItems;
procedure ClearSuitItems;
procedure LoadUI;
procedure SaveUI;
procedure LoadMapDesc;
procedure SaveMapDesc;
procedure LoadSkillData();
procedure SaveSkillData();
procedure LoadSkillEffectData();
procedure SaveSkillEffectData();
procedure InitSkillEffectData();
procedure ClearShopItems;
procedure ClearShopSpeciallyItems;
procedure ClearRelation;
procedure ClearMissions;
procedure LoadCustomActorAction();
procedure SaveCustomActorAction();
procedure BuildItemEffect;
function NameInFriends(const AName: String): Boolean;
function NameInEnemies(const AName: String): Boolean;
function NameAtFriends(const AName: String): Integer;
function NameAtEnemies(const AName: String): Integer;
procedure UpdateAddSoulExp(Value: Integer);
procedure ClearAutoRunPointList;
function RecalcMyTotalAbility: Int64;
function RecalcTotalAbility(AUserStateInfo: TUserStateInfo): Int64;
function GetHumOffset(AJob: Byte; ADress: Word): Integer; inline;
function GetHumWinOffset(AJob: Byte; ADress: Word): Integer; inline;
function GetNpcOffset(nAppr: Integer): Integer; inline;
function GetOffset(Appr: Integer): Integer; inline;
function GetShadowOffset(Appr: Integer): Integer; inline;
procedure DrawMerchantMessageBackground(X, Y: Integer; AMerchantMessage: TuMerchantMessage);
procedure MerchantMessageGetItemImages(ANode: TMessageNode);
function ContainMagic(AMagicID: Integer): Boolean;
function TryGetMagic(AMagicID: Integer; var AMagic: PTClientMagic): Boolean;
procedure DeleteMagic(AMagicID: Integer);
procedure AddNextBatterMagic(AMagicID: Integer);
procedure AddNextMagic(AMagicID, ATag: Integer);
procedure AddOpendMagic(AMagicID: Integer);
function TryGetNextBatterMagic(ARange: Integer; var AMagic: PTClientMagic): Boolean;
function TryGetNextMagic(ARange: Integer; var AMagic: PTClientMagic): Boolean;
function TryGetOpendMagic(ARange: Integer; AShift: TShiftState; var AMagic: PTClientMagic): Boolean;
function TryGetMagicByID(Id: Word; out AMagic: PTClientMagic): Boolean;
function TryGetWarMagic(ARange: Integer; AShift: TShiftState; var AMagic: PTClientMagic; var AType: Integer): Boolean;
procedure DeleteWarMagic(AMagic: PTClientMagic; AType: Byte);
function CanUseMagic(AMagic: PTClientMagic): Boolean;
function GetSpellPoint(AMagic: PTClientMagic): Integer;
procedure InitFunctionFlag(n:Integer);
procedure ClearNextMagic(); //清空所有下一次攻击的技能
function IsMirReturnClient():Boolean;

procedure GetWeaponLibIndex(const Weapon:Integer; var nIndex , nRealWeapon : Integer); //以 100作为基数

procedure GetWeaponEffLibIndex(const Weapon:Integer;const Sex:Byte; var nIndex , nRealWeapon : Integer); //以 100作为基数
function GetMySelfClipValue (clType : TClipType; var Value,MaxValue : Int64):Single;
function GetStdItem(Index:Integer):pTStdItem;
procedure ClearCustomAction();
procedure InitCustomAction();
function IsCustomAppr(Appr : Integer):Boolean;
function GetStartTime(nTime: LongWord): string;
function FindMagic(MagicIds:Array of Integer):PTClientMagic;
function ItemCanShowInQuickBar(var Item: TClientItem): Boolean;
procedure InitPassWordFile(const FileName:String);
implementation
  uses FState, ClMain, DXDialogs, HUtil32, StrUtils, uMagicMgr, ClFunc,uServerList;


function ItemCanShowInQuickBar(var Item: TClientItem): Boolean;
begin
  Result := False;
  if Item.Index >= 0 then
  begin
    if Item.s.StdMode in  [0 .. 3] then
      Result := True
    else if Item.State.CanInQuickBar then
      Result := True
  end;
end;

procedure InitPassWordFile(const FileName:String);
var
  PassWordFile:TSecurityFiles;
  PassWord : TSecurityFile;
  I:Integer;
begin
  PassWordFile := TSecurityFiles.Create(nil,TSecurityFile);
  if FileExists(FileName) then
  begin
    Try
      PassWordFile.LoadFromFile(FileName);

      for i := 0 to PassWordFile.Count - 1  do
      begin
        PassWord := PassWordFile.Items[i];
        LibManager.addPassWord(PassWord.FileName,PassWord.Password);
      end;
    finally
      PassWordFile.Free;
    end;
  end;
end;

function GetStartTime(nTime: LongWord): string;
var
  h, s, m, s1: LongWord;
begin
  h := nTime div 3600;
  s1 := nTime mod 3600; // 剩余秒
  m := s1 div 60;
  s := s1 mod 60;

  if h = 0 then
  begin
    if m = 0 then
    begin
      Result := Format('%d秒', [s]);
    end else
    begin
      Result := Format('%d分钟%d秒', [m, s]);
    end;
  end else
  begin
    if s = 0 then
    begin
      Result := Format('%d小时%d分钟', [h, m]);
      if m = 0 then
        Result := Format('%d小时', [h]);
    end else
    begin
      Result := Format('%d小时%d分钟%d秒', [h, m, s]);
    end;
  end;
end;

function IsCustomAppr(Appr : Integer):Boolean;
begin
  if (Appr >= CUSTOM_ACTOR_ACTION_APPR_BASE) and (Appr < CUSTOM_ACTOR_ACTION_APPR_MAX) then
  begin
    Result := True;
  end else
    Result := False;
end;


procedure ClearCustomAction();
var
 I :integer;
begin
  for I := CUSTOM_ACTOR_ACTION_APPR_BASE to CUSTOM_ACTOR_ACTION_APPR_MAX do
  begin
    if g_CustomNPCAction[i] <> nil then
    begin
      DisPoseAndNil(g_CustomNPCAction[i]);
    end;
  end;

  for I := CUSTOM_ACTOR_ACTION_APPR_BASE to CUSTOM_ACTOR_ACTION_APPR_MAX do
  begin
    if g_CustomMonsterAction[i] <> nil then
    begin
      DisPoseAndNil(g_CustomNPCAction[i]);
    end;
  end;

end;

procedure InitCustomAction();
  function FindAction(const Name:String):TuMonsterAction;
  var
    I : Integer;
  begin
    Result := nil;
    for i := 0 to g_CustomActorAction.MonsterActions.Count - 1 do
    begin
      if SameText(Name,g_CustomActorAction.MonsterActions.Items[i].Name) then
      begin
        Result := g_CustomActorAction.MonsterActions.Items[i];
        Exit;
      end;

    end;
  end;

  Procedure uActionToActorAction(uAction : TuActionInfo ; Action : pTActionInfo);
  begin
    Action.start := uAction.StartOrder;
    Action.frame := uAction.AnDirectionFrameCount;
    Action.skip := uAction.AnDirectionSkipFrame;
    Action.ftime := uAction.FramePerMS;
  end;
var
  I : Integer;
  pAction : pTCustomAction;
  Appr:TuActorAppearance;
  MonsterAction : TuMonsterAction;
  WMLib:TWMImages;
begin
  ClearCustomAction;
  g_CustomActorAction.MonsterActions.InitActionItem();
  for i := 0 to g_CustomActorAction.NPCAppr.Count - 1 do
  begin
    Appr := g_CustomActorAction.NPCAppr.Items[i];
    if IsCustomAppr(Appr.Appr) and (g_CustomNPCAction[Appr.Appr] = nil) then
    begin
      MonsterAction := FindAction(Appr.ActionName);
      if (MonsterAction <> nil) then
      begin
        if LibManager.TryGetLib(Appr.Lib,WMLib) then
        begin
          New(pAction);
          uActionToActorAction(MonsterAction.ActStand,@pAction.MonsterAction.ActStand);
          uActionToActorAction(MonsterAction.ActWalk,@pAction.MonsterAction.ActWalk);
          uActionToActorAction(MonsterAction.ActAttack,@pAction.MonsterAction.ActAttack);
          uActionToActorAction(MonsterAction.ActCritical,@pAction.MonsterAction.ActCritical);
          uActionToActorAction(MonsterAction.ActStruck,@pAction.MonsterAction.ActStruck);
          uActionToActorAction(MonsterAction.ActDie,@pAction.MonsterAction.ActDie);
          uActionToActorAction(MonsterAction.ActDeath,@pAction.MonsterAction.ActDeath);
          pAction.Lib := WMLib;
          pAction.StartOffset := Appr.OffsetIndex;
          g_CustomNPCAction[Appr.Appr] := pAction;
        end;
      end;
    end;
  end;

  for i := 0 to g_CustomActorAction.MonsterAppr.Count - 1 do
  begin
    Appr := g_CustomActorAction.MonsterAppr.Items[i];
    if IsCustomAppr(Appr.Appr) and (g_CustomMonsterAction[Appr.Appr] = nil) then
    begin
      MonsterAction := FindAction(Appr.ActionName);
      if (MonsterAction <> nil) then
      begin
        if LibManager.TryGetLib(Appr.Lib,WMLib) then
        begin
          New(pAction);
          uActionToActorAction(MonsterAction.ActStand,@pAction.MonsterAction.ActStand);
          uActionToActorAction(MonsterAction.ActWalk,@pAction.MonsterAction.ActWalk);
          uActionToActorAction(MonsterAction.ActAttack,@pAction.MonsterAction.ActAttack);
          uActionToActorAction(MonsterAction.ActCritical,@pAction.MonsterAction.ActCritical);
          uActionToActorAction(MonsterAction.ActStruck,@pAction.MonsterAction.ActStruck);
          uActionToActorAction(MonsterAction.ActDie,@pAction.MonsterAction.ActDie);
          uActionToActorAction(MonsterAction.ActDeath,@pAction.MonsterAction.ActDeath);
          pAction.Lib := WMLib;
          pAction.StartOffset := Appr.OffsetIndex;
          g_CustomMonsterAction[Appr.Appr] := pAction;
        end;
      end;
    end;
  end;
end;

function GetStdItem(Index:Integer):pTStdItem;
begin
  Result := nil;
  if (Index >= 0) and (Index <= g_ItemList.Count) then
  begin
    Result := g_ItemList[Index];
  end;
end;


procedure GetWeaponLibIndex(const Weapon:Integer; var nIndex , nRealWeapon : Integer);
var
  nSex : Integer;
  nWeapon : Integer;
begin
  // 因为这里传进来的 Weapon 其实是  数据库设置 * 2  + 性别 因为设置一个文件存放100 所以需要 div 2
  nSex := Weapon mod 2;
  nWeapon := Weapon div 2;
  nIndex := nWeapon div 100;
  nRealWeapon := (nWeapon mod 100) + nSex;
end;

procedure GetWeaponEffLibIndex(const Weapon:Integer;const Sex:Byte; var nIndex , nRealWeapon : Integer); //以 100作为基数
begin
    // 这里传进来的weapon 就是数据库设置的Weapon值  所以 这里因为要以 100作为基数 所以这里直接计算性别
  nIndex := Weapon div 100;
  nRealWeapon := (Weapon mod 100) + Sex;
end;


procedure InitFunctionFlag(n:Integer);
begin
  g_boJewelryBox := False;
  g_boZodiac := False;
  FrmDlg.DSWZodiacSigns.Visible := False;
  FrmDlg.DSWJewelryBox.Visible := False;

  if SetContain(n,Byte(ffJewelryBox)) then
  begin
    g_boJewelryBox := True;
    FrmDlg.DSWJewelryBox.Visible := True;
  end;

  if SetContain(n,Byte(ffZodiac)) then
  begin
    g_boZodiac := True;
    FrmDlg.DSWZodiacSigns.Visible := True;
  end
end;
function ImageFileExists(const AFileName: String): Boolean;
var
  TmpFileName: String;
begin
  Result := False;
  TmpFileName := ChangeFileExt(MIRPath + AFileName, '.wzl');
  if FileExists(TmpFileName) then
    Result := True
  else if FileExists(ChangeFileExt(TmpFileName, '.wil')) then
    Result := True
  else if FileExists(ChangeFileExt(TmpFileName, '.wis')) then
    Result := True
  else if FileExists(ChangeFileExt(TmpFileName, '.data')) then
    Result := True;
end;

procedure InitApplication;
begin
  MAPSURFACEWIDTH := SCREENWIDTH;
//  if g_NewUI then
    MAPSURFACEHEIGHT := SCREENHEIGHT;
//  else
//    MAPSURFACEHEIGHT := SCREENHEIGHT - 155;
  WINRIGHT := SCREENWIDTH - 60;
  CHATBOXWIDTH := SCREENWIDTH - 447; // 41 聊天框文字宽度
  CHATBOXWIDTH := SCREENWIDTH - 447;
end;

function CreateLoginScene: TCustomLoginScene;
begin
  Result := nil;
//  case g_DWinMan.UIType of
//    skReturn: Result := TMir3LoginScene.Create;
//    skNormal: Result := TLoginScene.Create;
//    //skMir4: Result := TMir4LoginScene.Create;
//    skMir4: Result := TLoginScene.Create;
//  end;

  Result := TLoginScene.Create;
end;

function CreateSelectChrScene: TSelectChrScene;
begin
//  Result := nil;
//  case g_DWinMan.UIType of
//    skReturn: Result := TMir3SelectChrScene.Create;
//    skMir4: Result := TMir4SelectChrScene.Create;
//    skNormal: Result := TSelectChrScene.Create;
//  end;

  Result := TSelectChrScene.Create;
end;

function CreateLoginNotice: TLoginNotice;
begin
  Result := nil;
  case g_DWinMan.UIType of
    skReturn: Result := TMir3LoginNotice.Create;
    skMir4: Result := TMir4LoginNotice.Create;
    skNormal: Result := TLoginNotice.Create;
  end;
end;

procedure LoadWMImagesLib(AOwner: TComponent);
var
  I: Integer;
begin
  g_77Images := CreateImages(ResourceDir + 'Data\Prguse.data');
  g_77CustomImages := CreateImages(ResourceDir + 'Data\Images.data');
  g_77Title := CreateImages(ResourceDir + 'Data\Title.Data');
  g_77MMap := CreateImages(ResourceDir + 'Data\MMap.Data');
  g_77Icons := CreateImages(ResourceDir + 'Data\Icons.data');
  g_WMainImages := CreateImages(MAINIMAGEFILE);
  g_WMain2Images := CreateImages(MAINIMAGEFILE2);
  g_WMain3Images := CreateImages(MAINIMAGEFILE3);
  g_WChrSelImages := CreateImages(CHRSELIMAGEFILE);
  g_WChrSel2Images := CreateImages('Data\ChrSel2.wil');
  g_WEffectLogin := CreateImages('Data\Effect_login.wil');
  g_WNSelectImages := CreateImages('Data\nselect.wil');
  g_WMMapImages := CreateImages(MINMAPIMAGEFILE);
  for I := Low(g_WHumWingImages) to High(g_WHumWingImages) do
  begin
    if I = 0 then
      g_WHumWingImages[I] := CreateImages('Data\HumEffect.wil')
    else
      g_WHumWingImages[I] := CreateImages(Format('Data\HumEffect%d.wil', [I + 1]));
  end;
  g_WBagItemImages := CreateImages(BAGITEMIMAGESFILE);
  g_WStateItemImages := CreateImages(STATEITEMIMAGESFILE);
  g_WStateEffectImages := CreateImages('Data\StateEffect.wil');
  g_WDnItemImages := CreateImages(DNITEMIMAGESFILE);

  g_77WBagItemImages := CreateImages(ResourceDir + 'Data\Items.data');
  g_77WStateItemImages := CreateImages(ResourceDir + 'Data\StateItem.data');
  g_77WDnItemImages := CreateImages(ResourceDir + 'Data\DnItems.data');
  g_77WWeaponImages := CreateImages(ResourceDir + 'Data\Weapon.data');

  for I := Low(g_WHumImgImages) to High(g_WHumImgImages) do
  begin
    if I = 0 then
      g_WHumImgImages[I] := CreateImages('Data\Hum.wil')
    else
      g_WHumImgImages[I] := CreateImages(Format('Data\Hum%d.wil', [I + 1]));
  end;
  for I := Low(g_WHumImgGJSImages) to High(g_WHumImgGJSImages) do
  begin
    if I = 0 then
      g_WHumImgGJSImages[I] := CreateImages('Data\hum_gjs.wil')
    else
      g_WHumImgGJSImages[I] := CreateImages(Format('Data\hum_gjs%d.wil', [I + 1]));
  end;

  //刺客衣服
  for I := Low(g_WHumImgCKImages) to High(g_WHumImgCKImages) do
  begin
    case I of
      0: g_WHumImgCKImages[I] := CreateImages('Data\hum_ck.wil');
      1: g_WHumImgCKImages[I] := CreateImages('Data\hum_ck02.wil');
      else
        g_WHumImgCKImages[I] := CreateImages(Format('Data\Hum_ck%d.wil', [I + 1]));
    end;
  end;

  for I := Low(g_WHumWingCKImages) to High(g_WHumWingCKImages) do
  begin
    case I of
      0: g_WHumWingCKImages[I] := CreateImages('Data\hum_ckef.wil');
      1: g_WHumWingCKImages[I] := CreateImages('Data\hum_ck02_effect.wil');
      2: g_WHumWingCKImages[I] := CreateImages('Data\hum_ck3_effect.wil');
      6: g_WHumWingCKImages[I] := CreateImages('Data\humeffect7_ck.wil');
      else
        g_WHumWingCKImages[I] := CreateImages(Format('Data\Hum_ck%d_ef.wil', [I + 1]));
    end;
  end;

  for I := Low(g_WHumImgWSImages) to High(g_WHumImgWSImages) do
  begin
    case I of
      0: g_WHumImgWSImages[I] := CreateImages('Data\hum_ws.wil');
      else
        g_WHumImgWSImages[I] := CreateImages(Format('Data\hum_ws%d.wil', [I + 1]));
    end;
  end;

  g_WHairImgImages := CreateImages(HAIRIMGIMAGESFILE);
  g_WHair2ImgImages := CreateImages(HAIR2IMGIMAGESFILE);
  g_WHair3ImgImages := CreateImages('Data\Hair3.wil');
  g_WHairGJSImages := CreateImages('Data\hair_gjs.wil');
  g_WHairCIKImages := CreateImages('Data\hair_ck.wil');
  g_WHorseHairImgImages := CreateImages(ResourceDir + 'Data\HorseHair.data');
  for I := Low(g_WWeaponImages) to High(g_WWeaponImages) do
  begin
    if I = 0 then
      g_WWeaponImages[I] := CreateImages('Data\Weapon.wil')
    else
      g_WWeaponImages[I] := CreateImages(Format('Data\Weapon%d.wil', [I + 1]));
  end;
  for I := Low(g_WeaponEffectImages) to High(g_WeaponEffectImages) do
  begin
    if I = 0 then
      g_WeaponEffectImages[I] := CreateImages('Data\WeaponEffect.wil')
    else
      g_WeaponEffectImages[I] := CreateImages(Format('Data\weaponeffect-%d.wil', [I + 1]));
  end;

  for I := Low(g_WWeaponGJSImages) to High(g_WWeaponGJSImages) do
  begin
    if I = 0 then
      g_WWeaponGJSImages[I] := CreateImages('Data\weapon_gjs.wil')
    else
      g_WWeaponGJSImages[I] := CreateImages(Format('Data\weapon_gjs%d.wil', [I + 1]));
  end;

  //刺客武器图库
  for I := Low(g_WWeaponCKLImages) to High(g_WWeaponCKLImages) do
  begin
    case I of
      0: g_WWeaponCKLImages[I] := CreateImages('Data\wep_ck_l.wil');
      1: g_WWeaponCKLImages[I] := CreateImages('Data\weapon_ck02_l.wil');
      2: g_WWeaponCKLImages[I] := CreateImages('Data\wep_ck_l3.wil');
      3: g_WWeaponCKLImages[I] := CreateImages('Data\weapon_ck04_l.wil');
      else
        g_WWeaponCKLImages[I] := CreateImages(Format('Data\wep_ck_l%d.wil', [I + 1]));
    end;
  end;

  for I := Low(g_WWeaponCKRImages) to High(g_WWeaponCKRImages) do
  begin
    case I of
      0: g_WWeaponCKRImages[I] := CreateImages('Data\wep_ck_r.wil');
      1: g_WWeaponCKRImages[I] := CreateImages('Data\weapon_ck02_r.wil');
      2: g_WWeaponCKRImages[I] := CreateImages('Data\wep_ck_r3.wil');
      3: g_WWeaponCKRImages[I] := CreateImages('Data\weapon_ck04_r.wil');
      else
        g_WWeaponCKRImages[I] := CreateImages(Format('Data\wep_ck_r%d.wil', [I + 1]));
    end;
  end;

  //刺客左右手武器特效
  for i := Low(g_WWeaponCKLEffect) to High(g_WWeaponCKLEffect) do
  begin
    case I of
      0: g_WWeaponCKLEffect[I] := CreateImages('Data\weaponEffect_CK_L.wil');
      1: g_WWeaponCKLEffect[I] := CreateImages('Data\weapon_ck02_l_effect.wil');
      2: g_WWeaponCKLEffect[I] := CreateImages('Data\weapon_ck03_l_ef.wil');
      3: g_WWeaponCKLEffect[I] := CreateImages('Data\wep_ck_l_effect04.wil');
      else
        g_WWeaponCKLEffect[I] := CreateImages(Format('Data\weapon_ck0%d_l_effect.wil', [I + 1]));
    end;
  end;

  for i := Low(g_WWeaponCKREffect) to High(g_WWeaponCKREffect) do
  begin
    case I of
      0: g_WWeaponCKREffect[I] := CreateImages('Data\weaponEffect_CK_R.wil');
      1: g_WWeaponCKREffect[I] := CreateImages('Data\weapon_ck02_r_effect.wil');
      2: g_WWeaponCKREffect[I] := CreateImages('Data\weapon_ck03_r_ef.wil');
      3: g_WWeaponCKREffect[I] := CreateImages('Data\wep_ck_r_effect04.wil');
      else
        g_WWeaponCKREffect[I] := CreateImages(Format('Data\weapon_ck0%d_r_effect.wil', [I + 1]));
    end;
  end;



  for I := Low(g_WWeaponWSImages) to High(g_WWeaponWSImages) do
  begin
    case I of
      0: g_WWeaponWSImages[I] := CreateImages('Data\weapon_ws.wil');
      else
        g_WWeaponWSImages[I] := CreateImages(Format('Data\weapon_ws%d.wil', [I + 1]));
    end;
  end;

  for I := Low(g_WHorseImages) to High(g_WHorseImages) do
  begin
    if I = 0 then
      g_WHorseImages[I] := CreateImages(ResourceDir + 'Data\Horse.wil')
    else
      g_WHorseImages[I] := CreateImages(ResourceDir + Format('Data\Horse%d.wil', [I + 1]));
  end;
  for I := Low(g_WHorseHumImages) to High(g_WHorseHumImages) do
  begin
    if I = 0 then
      g_WHorseHumImages[I] := CreateImages(ResourceDir + 'Data\HumHorse.wil')
    else
      g_WHorseHumImages[I] := CreateImages(ResourceDir + Format('Data\HumHorse%d.wil', [I + 1]));
  end;
  for I := Low(g_WHorseHumWingImages) to High(g_WHorseHumWingImages) do
  begin
    if I = 0 then
      g_WHorseHumWingImages[I] := CreateImages(ResourceDir + 'Data\HumEffectHorse.wil')
    else
      g_WHorseHumWingImages[I] := CreateImages(ResourceDir + Format('Data\HumEffectHorse%d.wil', [I + 1]));
  end;

  for I := RES_IMG_BASE to RES_IMG_MAX do
  begin
    g_77HumImages[I] := CreateImages(ResourceDir + Format('Data\Hum\%d.data', [I]), True);
    g_77MonImages[I] := CreateImages(ResourceDir + Format('Data\Mon\%d.data', [I]), True);
    g_77WeponImages[I] := CreateImages(ResourceDir + Format('Data\Weapon\%d.data', [I]), True);
    g_77WeponLImages[I] := CreateImages(ResourceDir + Format('Data\Weapon\%dL.data', [I]), True);
    g_77HorseImages[I] := CreateImages(ResourceDir + Format('Data\Horse\%d.data', [I]), True);
    g_77HorseHumImages[I] := CreateImages(ResourceDir + Format('Data\HumHorse\%d.data', [I]), True);
    g_77ShieldImages[I] := CreateImages(ResourceDir + Format('Data\Shield\%d.data', [I]), True);
  end;

  g_WMagIconImages := CreateImages(MAGICONIMAGESFILE);
  g_WMagIcon2Images := CreateImages(MAGICON2IMAGESFILE);

  g_WMagicImages := CreateImages(MAGICIMAGESFILE);
  g_WMagic2Images := CreateImages(MAGIC2IMAGESFILE);
  g_WMagic3Images := CreateImages(MAGIC3IMAGESFILE);
  g_WMagic4Images := CreateImages(MAGIC4IMAGESFILE);
  g_WMagic5Images := CreateImages(MAGIC5IMAGESFILE);
  g_WMagic6Images := CreateImages(MAGIC6IMAGESFILE);
  g_WMagic7Images := CreateImages(MAGIC7IMAGESFILE);
  g_WMagic716Images := CreateImages(MAGIC716IMAGESFILE);
  g_WMagic8Images := CreateImages(MAGIC8IMAGESFILE);
  g_WMagic816Images := CreateImages(MAGIC816IMAGESFILE);
  g_WMagic9Images := CreateImages(MAGIC9IMAGESFILE);
  g_WMagic10Images := CreateImages(MAGIC10IMAGESFILE);
  g_WMagicCKImages := CreateImages('Data\magic_ck.wil');
  g_WMagicCk_NsImage := CreateImages('Data\magicns.wil');
  g_WEffectImages := CreateImages(EFFECTIMAGEFILE);
  g_WEffectGJSImages := CreateImages('Data\Effect_gjs.wil');
  g_WEffectWSImages := CreateImages('Data\Effect_ws.wil');
  g_WDragonImages := CreateImages(DRAGONIMAGEFILE);
  g_WUi1Images := CreateImages(UI1IMAGESFILE);
  g_WUi2Images := CreateImages(UI2IMAGESFILE);
  g_WUi3Images := CreateImages(UI3IMAGESFILE);
  g_WMonEffect := CreateImages('MonEffect.wil');
  g_WUiNImages := CreateImages('Data\ui_n.wil');
  g_WUiCommonImages := CreateImages('Data\ui_common.wil');

  g_WWisWeapon2 := CreateImages(WEAPON2WISFILE);
  g_WWiscboWeapon := CreateImages(CBOWEAPONWISFILE);
  g_WWiscboWeapon3 := CreateImages(CBOWEAPONWIS3FILE);
  g_WWiscboHumhair := CreateImages(CBOHAIRWISFILE);
  g_WWiscboHumWing := CreateImages(CBOHUMWINGWISFILE);
  g_WWiscboHumWing2 := CreateImages(CBOHUMWINGWIS2FILE);
  g_WWiscboHumWing3 := CreateImages(CBOHUMWINGWIS3FILE);
  g_WWiscboWing := CreateImages(CBOWINGWISFILE);
  g_WWiscboHum := CreateImages(CBOHUMWISFILE);
  g_WWiscboHum3 := CreateImages(CBOHUMWIS3FILE);
  FillChar(g_WObjectArr, SizeOf(g_WObjectArr), #0);
  FillChar(g_WMonImagesArr, SizeOf(g_WMonImagesArr), #0);
  FillChar(g_WNpcImagesArr, SizeOf(g_WNpcImagesArr), #0);
end;

procedure InitImages(AImages: TWMImages);
begin
  if AImages <> nil then
  Try
    AImages.Initialize;
  except
    ConsoleDebug('异常:Init:' + AImages.FileName);
  end;
end;

procedure InitWMImagesLib;
var
  I: Integer;
begin
  InitImages(g_77Images);
  InitImages(g_77CustomImages);
  InitImages(g_77Icons);
  InitImages(g_77Title);
  InitImages(g_77MMap);
  InitImages(g_77WBagItemImages);
  InitImages(g_77WStateItemImages);
  InitImages(g_77WDnItemImages);
  InitImages(g_77WWeaponImages);

  InitImages(g_WChrSelImages);
  InitImages(g_WChrSel2Images);
  InitImages(g_WEffectLogin);
  InitImages(g_WNSelectImages);
  InitImages(g_WMainImages);
  InitImages(g_WBagItemImages);
  InitImages(g_WMain2Images);
  InitImages(g_WMain3Images);
  InitImages(g_WMMapImages);
  for I := Low(g_WHumWingImages) to High(g_WHumWingImages) do
    InitImages(g_WHumWingImages[I]);
  InitImages(g_WStateItemImages);
  InitImages(g_WStateEffectImages);
  InitImages(g_WDnItemImages);
  for I := Low(g_WHumImgImages) to High(g_WHumImgImages) do
    InitImages(g_WHumImgImages[I]);
  for I := Low(g_WHumImgGJSImages) to High(g_WHumImgGJSImages) do
    InitImages(g_WHumImgGJSImages[I]);

  for I := Low(g_WHumImgCKImages) to High(g_WHumImgCKImages) do
    InitImages(g_WHumImgCKImages[I]);

  //初始化 刺客的衣服 和衣服特效
  for I := Low(g_WHumWingCKImages) to High(g_WHumWingCKImages) do
    InitImages(g_WHumWingCKImages[I]);

  for I := Low(g_WHumImgWSImages) to High(g_WHumImgWSImages) do
    InitImages(g_WHumImgWSImages[I]);
  InitImages(g_WHairImgImages);
  InitImages(g_WHair2ImgImages);
  InitImages(g_WHair3ImgImages);
  InitImages(g_WHairGJSImages);
  InitImages(g_WHairCIKImages);
  InitImages(g_WHorseHairImgImages);
  for I := Low(g_WWeaponImages) to High(g_WWeaponImages) do
    InitImages(g_WWeaponImages[I]);
  for I := Low(g_WeaponEffectImages) to High(g_WeaponEffectImages) do
    InitImages(g_WeaponEffectImages[I]);
  for I := Low(g_WWeaponGJSImages) to High(g_WWeaponGJSImages) do
    InitImages(g_WWeaponGJSImages[I]);

  for I := Low(g_WWeaponCKLImages) to High(g_WWeaponCKLImages) do
    InitImages(g_WWeaponCKLImages[I]);
  for I := Low(g_WWeaponCKRImages) to High(g_WWeaponCKRImages) do
    InitImages(g_WWeaponCKRImages[I]);

  for I := Low(g_WWeaponCKLEffect) to High(g_WWeaponCKLEffect) do
    InitImages(g_WWeaponCKLEffect[I]);
  for I := Low(g_WWeaponCKREffect) to High(g_WWeaponCKREffect) do
    InitImages(g_WWeaponCKREffect[I]);


  for I := Low(g_WWeaponWSImages) to High(g_WWeaponWSImages) do
    InitImages(g_WWeaponWSImages[I]);
  for I := Low(g_WHorseImages) to High(g_WHorseImages) do
    InitImages(g_WHorseImages[I]);
  for I := Low(g_WHorseHumImages) to High(g_WHorseHumImages) do
    InitImages(g_WHorseHumImages[I]);
  for I := Low(g_WHorseHumWingImages) to High(g_WHorseHumWingImages) do
    InitImages(g_WHorseHumWingImages[I]);

  for I := RES_IMG_BASE to RES_IMG_MAX do
  begin
    InitImages(g_77HumImages[I]);
    InitImages(g_77MonImages[I]);
    InitImages(g_77WeponImages[I]);
    InitImages(g_77WeponLImages[I]);
    InitImages(g_77HorseImages[I]);
    InitImages(g_77HorseHumImages[I]);
    InitImages(g_77ShieldImages[I]);
  end;

  InitImages(g_WMagIconImages);
  InitImages(g_WMagIcon2Images);
  InitImages(g_WMagicImages);
  InitImages(g_WMagic2Images);
  InitImages(g_WMagic3Images);
  InitImages(g_WMagic4Images);
  InitImages(g_WMagic5Images);
  InitImages(g_WMagic6Images);
  InitImages(g_WMagic7Images);
  InitImages(g_WMagic716Images);
  InitImages(g_WMagic8Images);
  InitImages(g_WMagic816Images);
  InitImages(g_WMagic9Images);
  InitImages(g_WMagic10Images);
  InitImages(g_WMagicCKImages);
  InitImages(g_WMagicCk_NsImage);
  InitImages(g_WEffectImages);
  InitImages(g_WEffectGJSImages);
  InitImages(g_WEffectWSImages);
  InitImages(g_WDragonImages);
  InitImages(g_WUi1Images);
  InitImages(g_WUi2Images);
  InitImages(g_WUi3Images);
  InitImages(g_WUiNImages);
  InitImages(g_WUiCommonImages);
  InitImages(g_WMonEffect);
  InitImages(g_WWisWeapon2);
  InitImages(g_WWiscboWeapon);
  InitImages(g_WWiscboWeapon3);
  InitImages(g_WWiscboHumhair);
  InitImages(g_WWiscboHumWing);
  InitImages(g_WWiscboHumWing2);
  InitImages(g_WWiscboHumWing3);
  InitImages(g_WWiscboWing);
  InitImages(g_WWiscboHum);
  InitImages(g_WWiscboHum3);
end;

procedure UnLoadWMImages(AImages: TWMImages);
begin
  if AImages <> nil then
  begin
    AImages.Finalize;
    AImages.Free;
    AImages := nil;
  end;
end;

procedure UnLoadWMImagesLib();
var
  i:Integer;
  AImages :TWMImages;
begin
  for i := 0 to TWMImages.AllWMImages.Count - 1 do
  begin
    AImages := TWMImages.AllWMImages[i];
    AImages.Free;
  end;

  TWMImages.AllWMImages.Clear;
end;

//procedure UnLoadWMImagesLib();
//var
//  I: Integer;
//begin
//  for I := Low(g_WTilesImages) to High(g_WTilesImages) do
//    UnLoadWMImages(g_WTilesImages[I]);
//  for I := Low(g_WSmTilesImages) to High(g_WSmTilesImages) do
//    UnLoadWMImages(g_WSmTilesImages[I]);
//  for I := Low(g_WObjectArr) to High(g_WObjectArr) do
//    UnLoadWMImages(g_WObjectArr[I]);
//  for I := Low(g_WMonImagesArr) to High(g_WMonImagesArr) do
//    UnLoadWMImages(g_WMonImagesArr[I]);
//  for I := Low(g_WNpcImagesArr) to High(g_WNpcImagesArr) do
//    UnLoadWMImages(g_WNpcImagesArr[I]);
//  UnLoadWMImages(g_77Images);
//  UnLoadWMImages(g_77CustomImages);
//  UnLoadWMImages(g_77Icons);
//  UnLoadWMImages(g_77Title);
//  UnLoadWMImages(g_77MMap);
//  UnLoadWMImages(g_77WBagItemImages);
//  UnLoadWMImages(g_77WStateItemImages);
//  UnLoadWMImages(g_77WDnItemImages);
//  UnLoadWMImages(g_77WWeaponImages);
//
//  UnLoadWMImages(g_WMainImages);
//  UnLoadWMImages(g_WMain2Images);
//  UnLoadWMImages(g_WMain3Images);
//  UnLoadWMImages(g_WChrSelImages);
//  UnLoadWMImages(g_WChrSel2Images);
//  UnLoadWMImages(g_WEffectLogin);
//  UnLoadWMImages(g_WNSelectImages);
//  UnLoadWMImages(g_WMMapImages);
//  for I := Low(g_WHumWingImages) to High(g_WHumWingImages) do
//    UnLoadWMImages(g_WHumWingImages[I]);
//  UnLoadWMImages(g_WBagItemImages);
//  UnLoadWMImages(g_WStateItemImages);
//  UnLoadWMImages(g_WStateEffectImages);
//  UnLoadWMImages(g_WDnItemImages);
//  for I := Low(g_WHumImgImages) to High(g_WHumImgImages) do
//    UnLoadWMImages(g_WHumImgImages[I]);
//  for I := Low(g_WHumImgGJSImages) to High(g_WHumImgGJSImages) do
//    UnLoadWMImages(g_WHumImgGJSImages[I]);
//  for I := Low(g_WHumImgCKImages) to High(g_WHumImgCKImages) do
//    UnLoadWMImages(g_WHumImgCKImages[I]);
//  for I := Low(g_WHumImgWSImages) to High(g_WHumImgWSImages) do
//    UnLoadWMImages(g_WHumImgWSImages[I]);
//  UnLoadWMImages(g_WHairImgImages);
//  UnLoadWMImages(g_WHair2ImgImages);
//  UnLoadWMImages(g_WHair3ImgImages);
//  UnLoadWMImages(g_WHairGJSImages);
//  UnLoadWMImages(g_WHairCIKImages);
//  UnLoadWMImages(g_WHorseHairImgImages);
//  for I := Low(g_WWeaponImages) to High(g_WWeaponImages) do
//    UnLoadWMImages(g_WWeaponImages[I]);
//  for I := Low(g_WeaponEffectImages) to High(g_WeaponEffectImages) do
//    UnLoadWMImages(g_WeaponEffectImages[I]);
//  for I := Low(g_WWeaponGJSImages) to High(g_WWeaponGJSImages) do
//    UnLoadWMImages(g_WWeaponGJSImages[I]);
//  for I := Low(g_WWeaponCKLImages) to High(g_WWeaponCKLImages) do
//    UnLoadWMImages(g_WWeaponCKLImages[I]);
//  for I := Low(g_WWeaponCKRImages) to High(g_WWeaponCKRImages) do
//    UnLoadWMImages(g_WWeaponCKRImages[I]);
//  for I := Low(g_WWeaponWSImages) to High(g_WWeaponWSImages) do
//    UnLoadWMImages(g_WWeaponWSImages[I]);
//  for I := Low(g_WHorseImages) to High(g_WHorseImages) do
//    UnLoadWMImages(g_WHorseImages[I]);
//  for I := Low(g_WHorseHumImages) to High(g_WHorseHumImages) do
//    UnLoadWMImages(g_WHorseHumImages[I]);
//  for I := Low(g_WHorseHumWingImages) to High(g_WHorseHumWingImages) do
//    UnLoadWMImages(g_WHorseHumWingImages[I]);
//
//  for I := RES_IMG_BASE to RES_IMG_MAX do
//  begin
//    UnLoadWMImages(g_77HumImages[I]);
//    UnLoadWMImages(g_77MonImages[I]);
//    UnLoadWMImages(g_77WeponImages[I]);
//    UnLoadWMImages(g_77WeponLImages[I]);
//    UnLoadWMImages(g_77HorseImages[I]);
//    UnLoadWMImages(g_77HorseHumImages[I]);
//    UnLoadWMImages(g_77ShieldImages[I]);
//  end;
//
//  UnLoadWMImages(g_WMagIconImages);
//  UnLoadWMImages(g_WMagIcon2Images);
//  UnLoadWMImages(g_WMagicImages);
//  UnLoadWMImages(g_WMagic2Images);
//  UnLoadWMImages(g_WMagic3Images);
//  UnLoadWMImages(g_WMagic4Images);
//  UnLoadWMImages(g_WMagic5Images);
//  UnLoadWMImages(g_WMagic6Images);
//  UnLoadWMImages(g_WMagic7Images);
//  UnLoadWMImages(g_WMagic716Images);
//  UnLoadWMImages(g_WMagic8Images);
//  UnLoadWMImages(g_WMagic816Images);
//  UnLoadWMImages(g_WMagic9Images);
//  UnLoadWMImages(g_WMagic10Images);
//
//  UnLoadWMImages(g_WMagicCKImages);
//  UnLoadWMImages(g_WMagicCk_NsImage);
//  UnLoadWMImages(g_WEffectImages);
//  UnLoadWMImages(g_WEffectGJSImages);
//  UnLoadWMImages(g_WEffectWSImages);
//  UnLoadWMImages(g_WDragonImages);
//  UnLoadWMImages(g_WUi1Images);
//  UnLoadWMImages(g_WUi2Images);
//  UnLoadWMImages(g_WUi3Images);
//  UnLoadWMImages(g_WUiNImages);
//  UnLoadWMImages(g_WUiCommonImages);
//  UnLoadWMImages(g_WMonEffect);
//  UnLoadWMImages(g_WWiscboHumWing);
//  UnLoadWMImages(g_WWiscboHumWing2);
//  UnLoadWMImages(g_WWiscboHumWing3);
//end;

procedure GetObjs(nUnit, nIdx: Integer; var D: TAsphyreLockableTexture);
begin
  D := nil;
  if (nUnit < Low(g_WObjectArr)) or (nUnit > High(g_WObjectArr)) then
    nUnit := 0;
  if g_WObjectArr[nUnit] <> nil then
    D := g_WObjectArr[nUnit].Images[nIdx];
end;

procedure GetObjsEx(nUnit, nIdx: Integer; var px, py: Integer; var D: TAsphyreLockableTexture);
begin
  D := nil;
  if (nUnit < Low(g_WObjectArr)) or (nUnit > High(g_WObjectArr)) then
    nUnit := 0;
  if g_WObjectArr[nUnit] <> nil then
    D := g_WObjectArr[nUnit].GetCachedImage(nIdx, px, py);
end;

procedure GetTilesImages(BkIndex: Byte; ImageIndex: Integer; var D: TAsphyreLockableTexture);
begin
  D := nil;
  if BkIndex in [Low(g_WTilesImages) .. High(g_WTilesImages)] then
    D := g_WTilesImages[BkIndex].Images[ImageIndex];
end;

procedure GetSmTilesImages(SmIndex: Byte; ImageIndex: Integer; var D: TAsphyreLockableTexture);
begin
  D := nil;
  if SmIndex in [Low(g_WSmTilesImages) .. High(g_WSmTilesImages)] then
    D := g_WSmTilesImages[SmIndex].Images[ImageIndex];
end;

procedure InitObjectImg();
var
  I: Integer;
  sFileName: string;
begin
  for I := Low(g_WObjectArr) to ( High(g_WObjectArr)) do
  begin
    if I = 0 then
      sFileName := OBJECTIMAGEFILE
    else
      sFileName := Format(OBJECTIMAGEFILE1, [I + 1]);
    if ImageFileExists(ResourceDir + '\' + sFileName) then
      sFileName := ResourceDir + '\' + sFileName;
    g_WObjectArr[I] := CreateImages(sFileName);
    InitImages(g_WObjectArr[I]);
  end;
end;

procedure InitTitles;
var
  I: Integer;
  sFileName: string;
begin
  for I := Low(g_WTilesImages) to ( High(g_WTilesImages)) do
  begin
    if I = 0 then
      sFileName := 'Data\Tiles.wil'
    else
      sFileName := Format('Data\Tiles%d.wil', [I + 1]);
    if ImageFileExists(ResourceDir + '\' + sFileName) then
      sFileName := ResourceDir + '\' + sFileName;
    g_WTilesImages[I] := CreateImages(sFileName);
    InitImages(g_WTilesImages[I]);
    g_WTilesImages[I].Important := True;
  end;
end;

procedure InitSmTiles;
var
  I: Integer;
  sFileName: string;
begin
  for I := Low(g_WSmTilesImages) to ( High(g_WSmTilesImages)) do
  begin
    if I = 0 then
      sFileName := 'Data\SmTiles.wil'
    else
      sFileName := Format('Data\SmTiles%d.wil', [I + 1]);
    if ImageFileExists(ResourceDir + '\' + sFileName) then
      sFileName := ResourceDir + '\' + sFileName;
    g_WSmTilesImages[I] := CreateImages(sFileName);
    InitImages(g_WSmTilesImages[I]);
    g_WSmTilesImages[i].Important := True;
  end;
end;

procedure InitMonImg();
var
  I: Integer;
  sFileName: string;
begin
  for I := Low(g_WMonImagesArr) to ( High(g_WMonImagesArr)) do
  begin
    sFileName := '';
    if I = 99 then
    begin
      sFileName := Format(MONIMAGESFILE, ['Mon-kulou']);
      g_WMonImagesArr[I] := CreateImages(sFileName);
      InitImages(g_WMonImagesArr[I]);
    end
    else if I >= 50 then
    begin
      sFileName := Format(ResMonImagFile, [ResourceDir, I - 50 + 1]);
      g_WMonImagesArr[I] := CreateImages(sFileName);
      InitImages(g_WMonImagesArr[I]);
    end
    else
    begin
      sFileName := Format(MONIMAGEFILE, [I + 1]);
      g_WMonImagesArr[I] := CreateImages(sFileName);
      InitImages(g_WMonImagesArr[I]);
    end;
  end;
end;

function GetMonImg(nAppr: Integer): TWMImages;
var
  nUnit: Integer;
begin
  Result := nil;
  if IsCustomAppr(nAppr) and (g_CustomMonsterAction[nAppr] <> nil) then
  begin
    Result := g_CustomMonsterAction[nAppr].Lib;
  end else
  begin
    nUnit := 0;
    case nAppr of
      RES_IMG_BASE..RES_IMG_MAX:
      begin
        Result := g_77MonImages[nAppr];
        Exit;
      end;
      0..999: nUnit := nAppr div 10;
      1000..9999: nUnit := nAppr div 100;
    end;

    if nUnit <> 90 then
    begin
      if (nUnit < Low(g_WMonImagesArr)) or (nUnit > High(g_WMonImagesArr)) then
        nUnit := 0;
      if g_WMonImagesArr[nUnit] <> nil then
        Result := g_WMonImagesArr[nUnit];
    end
    else
    begin
      // 沙城门、城墙之类的
      case nAppr of
        904..906: Result := g_WMonImagesArr[33];
        else Result := g_WEffectImages;
      end;
    end;
  end;
end;

procedure InitNpcImg();
var
  I: Integer;
  sFileName: string;
begin
  for I := Low(g_WNpcImagesArr) to High(g_WNpcImagesArr) do
  begin
    sFileName := '';
    if I >= 5 then
    begin
      if I = 5 then
        sFileName := ResourceDir + 'Data\Npc.wil'
      else
        sFileName := Format(ResourceDir + 'Data\Npc%d.wil', [I - 5 + 1]);
    end
    else
    begin
      if I = 0 then
        sFileName := 'Data\Npc.wil'
      else
        sFileName := Format('Data\Npc%d.wil', [I + 1]);
    end;
    g_WNpcImagesArr[I] := CreateImages(sFileName);
    InitImages(g_WNpcImagesArr[I]);
  end;
end;

function GetNpcImg(nAppr: Integer): TWMImages;
var
  nUnit: Integer;
begin
  Result := nil;
  if IsCustomAppr(nAppr) and (g_CustomNPCAction[nAppr] <> nil) then
  begin
    Result := g_CustomNPCAction[nAppr].Lib;
  end else
  begin
    nUnit := nAppr div 100;
    if (nUnit < Low(g_WNpcImagesArr)) or (nUnit > High(g_WNpcImagesArr)) then
      nUnit := 0;
    if g_WNpcImagesArr[nUnit] <> nil then
      Result := g_WNpcImagesArr[nUnit];
    end
end;

function GetShowItem(ItemIdx: Integer): TShowItem;
var
  AStdItem: pTStdItem;
begin
  Result := nil;
  if (ItemIdx >= 0) and (ItemIdx < g_ItemList.Count) then
  begin
    AStdItem := g_ItemList.Items[ItemIdx];
    if AStdItem <> nil then
    begin
      if not g_FilterItemNameList.TryGetValue(String(AStdItem^.Name), Result) then
        Result := nil;
    end;
  end;
end;

function GetItemNameColor(ItemIdx: Word; Default: Byte): TColor;
var
  AStdItem: pTStdItem;
begin
  if Default > 0 then
    Result := GetRGB(Default)
  else
  begin
    Result := clWhite;
    if (ItemIdx > 0) and (ItemIdx < g_ItemList.Count) then
    begin
      AStdItem := g_ItemList.Items[ItemIdx];
      if AStdItem <> nil then
      begin
        if AStdItem.Color > 0 then
          Result := GetRGB(AStdItem.Color);
      end;
    end;
  end;
end;

function GetItemIndexByName(const ItemName: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to g_ItemList.Count - 1 do
    if ItemName = g_ItemList[I].Name then
    begin
      Result := I;
      Exit;
    end;
end;

function GetClientItemByName(const ItemName: String): TClientItem;
begin
  FillChar(Result, SizeOf(TClientItem), #0);
  Result.Index := GetItemIndexByName(ItemName);
  Result.Name := ItemName;
  Result.MakeIndex := -1;
end;

procedure UpdateShowItem(const ItemName: String; AShowItem: TShowItem);
var
  Idx, I: Integer;
begin
  Idx := GetItemIndexByName(ItemName);
  if Idx >= 0 then
  begin
    for I := 0 to g_DropedItemList.Count - 1 do
    begin
      if pTDropItem(g_DropedItemList.Items[I]).ItemIndex = Idx then
      begin
        pTDropItem(g_DropedItemList.Items[I]).BoShowName := AShowItem.BoShowName;
        pTDropItem(g_DropedItemList.Items[I]).BoSpec := AShowItem.BoSpec;
        pTDropItem(g_DropedItemList.Items[I]).BoPickup := AShowItem.boAutoPickup;
      end;
    end;
  end;
end;

function GetStorePriceName(_Type: Byte): String;
begin
  case _Type of
    1:
      Result := g_sGameGoldName;
    4:
      Result := g_sGamePointName;
  else
    Result := g_sGoldName;
  end;
end;

procedure OpenBrowser(const AUrl: String);
var
  AReg: TRegistry;
  ACmdStr: String;
begin
  AReg := TRegistry.Create;
  try
    AReg.RootKey := HKEY_CLASSES_ROOT;
    AReg.OpenKey('HTTP\Shell\open\command', False);
    ACmdStr := AReg.ReadString('');
    ACmdStr := Copy(ACmdStr, Pos('"', ACmdStr) + 1, Length(ACmdStr));
    ACmdStr := Copy(ACmdStr, 1, Pos('"', ACmdStr) - 1);
    if ACmdStr <> '' then
      ShellExecute(0, 'open', PChar(ACmdStr), PChar(AUrl), nil, sw_shownormal)
    else
      ShellExecute(0, nil, PChar(AUrl), nil, nil, sw_shownormal);
  finally
    AReg.Free;
  end;
end;

function TryGetMMap(MiniMapID: Integer; out DSurface: TAsphyreLockableTexture): Boolean;
begin
  Result := False;
  DSurface := nil;
  if MiniMapID < 0 then
    Exit;
  if MiniMapID > 9998 then
  begin
    if g_77MMap <> nil then
      DSurface := g_77MMap.Images[MiniMapID - 9999];
  end
  else
  begin
    DSurface := g_WMMapImages.Images[MiniMapID];
  end;
  Result := DSurface <> nil;
end;

function GetStateItemImgXY(nIndex: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
begin
  Result := nil;
  if nIndex < 10000 then
    Result := g_WStateItemImages.GetCachedImage(nIndex, ax, ay)
  else
    Result := g_77WStateItemImages.GetCachedImage(nIndex - 10000, ax, ay);
end;

function GetDressStateItemImgXY(Job, Sex: Byte; Item: TClientItem; var ax, ay: Integer): TAsphyreLockableTexture;
var
  AIndex: Integer;
  ox, oy: Integer;
begin
  Result := nil;
  AIndex := Item.Looks();
  ox := 0;
  oy := 0;
  case Job of
    _JOB_ARCHER:
    begin
      if Item.S.Shape in [1, 2] then
        AIndex := 3585 + Sex * 10 + Item.S.Shape - 1;
      ox := 9;
    end;
  end;
  if AIndex < 10000 then
    Result := g_WStateItemImages.GetCachedImage(AIndex, ax, ay)
  else
    Result := g_77WStateItemImages.GetCachedImage(AIndex - 10000, ax, ay);
  ax := ax + ox;
  ay := ay + oy;
end;

procedure StateDrawBlend(DSurface: TAsphyreCanvas; X, Y, StateImageIndex:Integer ;Blendmode: Integer = 0);
var
  D: TAsphyreLockableTexture;
  ax, ay: Integer;
begin
  D := GetStateItemImgXY(StateImageIndex, ax, ay);
  if D <> nil then
    DSurface.DrawBlendEffect(X + ax, Y + ay, D, Blendmode);
end;

procedure StateDrawBlendEx(Images: TWMImages; DSurface: TAsphyreCanvas; X, Y, StateImageIndex, Blendmode: Integer);
var
  D: TAsphyreLockableTexture;
  ax, ay: Integer;
begin
  if Images <> nil then
  begin
    D := Images.GetCachedImage(StateImageIndex, ax, ay);
    if D <> nil then
      DSurface.DrawBlendEffect(X + ax, Y + ay, D, Blendmode);
  end;
end;

procedure StateDressDrawBlend(DSurface: TAsphyreCanvas; Dress, X, Y, ImageIndex, Blendmode: Integer);
var
  D: TAsphyreLockableTexture;
  ax, ay: Integer;
begin
  D := g_77HumImages[Dress].GetCachedImage(ImageIndex, ax, ay);
  if D <> nil then
    DSurface.DrawBlendEffect(X + ax, Y + ay, D, Blendmode);
end;

procedure DressStateDrawBlend(ADress, AniCount, TimeTick: Integer; DSurface: TAsphyreCanvas; X, Y: Integer);
begin
  case ADress of
    RES_IMG_BASE..RES_IMG_MAX:
    begin
      if AniCount in [1..100] then
        StateDressDrawBlend(DSurface, ADress, X, Y, ((GetTickCount - TimeTick) div 120) mod AniCount,0);
    end
    else
    begin
      case AniCount of
        29:
          StateDrawBlend(DSurface, X, Y, 2425);
        30:
          StateDrawBlend(DSurface, X, Y, 2426);
        33:
          StateDrawBlend(DSurface, X, Y, 2541);
        34:
          StateDrawBlend(DSurface, X, Y, 2543);
        41, 42:
          StateDrawBlend(DSurface, X, Y, 2600 + (GetTickCount - TimeTick) div 120 mod 20);
        57:
          StateDrawBlend(DSurface, X, Y, 3550 + (GetTickCount - TimeTick) div 120 mod 10);
        58:
          StateDrawBlend(DSurface, X, Y, 3570 + (GetTickCount - TimeTick) div 120 mod 10);
        65:
          StateDrawBlend(DSurface, X, Y, 3680 + (GetTickCount - TimeTick) div 120 mod 8); //
        56:
          StateDrawBlend(DSurface, X, Y, 3690 + (GetTickCount - TimeTick) div 120 mod 8);
        67:
          StateDrawBlend(DSurface, X, Y, 3800 + (GetTickCount - TimeTick) div 120 mod 8); //
        61:
          StateDrawBlend(DSurface, X, Y, 3950 + (GetTickCount - TimeTick) div 120 mod 9);
        62:
          StateDrawBlend(DSurface, X, Y, 3959 + (GetTickCount - TimeTick) div 120 mod 9);
        63:
          StateDrawBlend(DSurface, X, Y, 3968 + (GetTickCount - TimeTick) div 120 mod 20);
      end;
    end;
  end;
end;

procedure StateWeponDrawBlend(DSurface: TAsphyreCanvas; Weapon, X, Y, ImageIndex, Blendmode: Integer);
var
  D: TAsphyreLockableTexture;
  ax, ay: Integer;
begin
  D := g_77WeponImages[Weapon].GetCachedImage(ImageIndex, ax, ay);
  if D <> nil then
    DSurface.DrawBlend(X + ax, Y + ay, D, Blendmode);
end;

procedure WeponStateDrawBlend(AWeapon, AniCount, TimeTick: Integer; DSurface: TAsphyreCanvas; X, Y: Integer);
begin
  case AWeapon of
    RES_IMG_BASE..RES_IMG_MAX:
    begin
      if AniCount in [1..100] then
        StateWeponDrawBlend(DSurface, AWeapon, X, Y, ((GetTickCount - TimeTick) div 120) mod AniCount);
    end;
    else
    begin
      case AniCount of
        21, 22:
          StateDrawBlend(DSurface, X, Y, 1403); //
        23, 24:
          StateDrawBlend(DSurface, X, Y, 1890 + (GetTickCount - TimeTick) div 120 mod 10); //
        31, 32:
          StateDrawBlend(DSurface, X, Y, 2427);
        35, 36:
          StateDrawBlend(DSurface, X, Y, 2530 + (GetTickCount - TimeTick) div 120 mod 8);
        37, 38:
          StateDrawBlend(DSurface, X, Y, 2550 + (GetTickCount - TimeTick) div 120 mod 10);
        39, 40:
          StateDrawBlend(DSurface, X, Y, 2560 + (GetTickCount - TimeTick) div 120 mod 10);
        43, 44:
          StateDrawBlend(DSurface, X, Y, 2850 + (GetTickCount - TimeTick) div 120 mod 16);
        55, 56:
          StateDrawBlend(DSurface, X, Y, 3480 + (GetTickCount - TimeTick) div 120 mod 14); //
        51, 52:
          StateDrawBlend(DSurface, X, Y, 3500 + (GetTickCount - TimeTick) div 120 mod 14); //
        53, 54:
          StateDrawBlend(DSurface, X, Y, 3520 + (GetTickCount - TimeTick) div 120 mod 14); //
        61:
          StateDrawBlend(DSurface, X, Y, 3610 + (GetTickCount - TimeTick) div 120 mod 18); //
        59:
          StateDrawBlend(DSurface, X, Y, 3630 + (GetTickCount - TimeTick) div 120 mod 18); //
        63:
          StateDrawBlend(DSurface, X, Y, 3650 + (GetTickCount - TimeTick) div 120 mod 18); //
        69:
          StateDrawBlend(DSurface, X, Y, 3820 + (GetTickCount - TimeTick) div 120 mod 18); //
        71:
          StateDrawBlend(DSurface, X, Y, 3840 + (GetTickCount - TimeTick) div 120 mod 18); //
        73:
          StateDrawBlend(DSurface, X, Y, 3860 + (GetTickCount - TimeTick) div 120 mod 18); //
      end;
    end;
  end;
end;

procedure ShieldDrawBlend(AShield, AniCount, TimeTick: Integer; DSurface: TAsphyreCanvas; X, Y: Integer); inline;
var
  D: TAsphyreLockableTexture;
  ax, ay, ImageIndex: Integer;
begin
  case AShield of
    RES_IMG_BASE..RES_IMG_MAX:
    begin
      if AniCount in [1..100] then
      begin
        ImageIndex := ((GetTickCount - TimeTick) div 120) mod AniCount;
        D := g_77ShieldImages[AShield].GetCachedImage(ImageIndex, ax, ay);
        if D <> nil then
          DSurface.DrawBlend(X + ax, Y + ay, D,0);
      end;
    end;
  end;
end;

function GetImageItemXY(Images: TWMImages; nIndex: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
begin
  Result := Images.GetCachedImage(nIndex, ax, ay)
end;

function GetImageItem(Images: TWMImages; nIndex: Integer): TAsphyreLockableTexture;
begin
  Result := Images.Images[nIndex];
end;

procedure ImageItemDrawBlend(Images: TWMImages; DSurface: TAsphyreCanvas; X, Y, ImageIndex, Blendmode: Integer);
var
  D: TAsphyreLockableTexture;
  ax, ay: Integer;
begin
  if Images = nil then
    Exit;

  D := GetImageItemXY(Images, ImageIndex, ax, ay);
  if D <> nil then
    DSurface.DrawBlend(X - (D.Width - 36) div 2, Y - (D.Height - 32) div 2, D, Blendmode);
end;

procedure ItemFlashDrawBlend(Flash, TimeTick: Integer; DSurface: TAsphyreCanvas; X, Y: Integer);
begin
  case Flash of
    1:
      ImageItemDrawBlend(g_WMainImages, DSurface, X, Y, 640 + (GetTickCount - TimeTick) div 120 mod 9, 0);
    2:
      ImageItemDrawBlend(g_WMain2Images, DSurface, X, Y + 2, 260 + (GetTickCount - TimeTick) div 120 mod 6, 0);
    3:
      ImageItemDrawBlend(g_WUi1Images, DSurface, X, Y, 100 + (GetTickCount - TimeTick) div 120 mod 32, 0);
    4:
      ImageItemDrawBlend(g_WUi1Images, DSurface, X, Y, 140 + (GetTickCount - TimeTick) div 120 mod 32, 0);
    5:
      ImageItemDrawBlend(g_WUi1Images, DSurface, X, Y, 180 + (GetTickCount - TimeTick) div 120 mod 32, 0);
    6:
      ImageItemDrawBlend(g_WUi1Images, DSurface, X, Y, 220 + (GetTickCount - TimeTick) div 120 mod 32, 0);
    7:
      ImageItemDrawBlend(g_WUi1Images, DSurface, X, Y, 260 + (GetTickCount - TimeTick) div 120 mod 32, 0);
    8:
      ImageItemDrawBlend(g_WUi1Images, DSurface, X, Y, 300 + (GetTickCount - TimeTick) div 120 mod 32, 0);
    9:
      ImageItemDrawBlend(g_WUi1Images, DSurface, X, Y, 340 + (GetTickCount - TimeTick) div 120 mod 32, 0);
    10:
      ImageItemDrawBlend(g_WStateItemImages, DSurface, X, Y, 2630 + (GetTickCount - TimeTick) div 120 mod 15, 0);
    11:
      ImageItemDrawBlend(g_WStateItemImages, DSurface, X, Y, 2650 + (GetTickCount - TimeTick) div 120 mod 15, 0);
    12:
      ImageItemDrawBlend(g_WStateItemImages, DSurface, X, Y, 3580 + (GetTickCount - TimeTick) div 120 mod 26, 0);
    13:
      ImageItemDrawBlend(g_WBagItemImages, DSurface, X, Y, 3711 + (GetTickCount - TimeTick) div 120 mod 14, 0);
    14:
      ImageItemDrawBlend(g_WBagItemImages, DSurface, X, Y, 3731 + (GetTickCount - TimeTick) div 120 mod 14, 0);
    15:
      ImageItemDrawBlend(g_WStateItemImages, DSurface, X, Y, 3910 + (GetTickCount - TimeTick) div 120 mod 10, 0);
  end;
end;

procedure ItemFlashDrawBlendEx(PItem: PTClientItem; DSurface: TAsphyreCanvas; CellWidth, CellHeight, X, Y: Integer);
var
  ASmallEffect: TItemSmallEffect;
begin
 if UIWindowManager.TryGetItemSmallEffect(PItem.SmallEffect, ASmallEffect) then
 begin
     if ASmallEffect <> nil then
    ASmallEffect.Draw(DSurface, CellWidth, CellHeight, X, Y);
 end;
end;

procedure ItemFlashDrawBlendEx_StateItem(PItem: PTClientItem; DSurface: TAsphyreCanvas; CellWidth, CellHeight, X, Y: Integer);
var
  AInnerEffect: TItemInnerEffect;
begin
 if UIWindowManager.TryGetItemInnerEffect(PItem.InnerEffect, AInnerEffect) then
 begin
     if AInnerEffect <> nil then
    AInnerEffect.Draw(DSurface, CellWidth, CellHeight, X, Y);
 end;
end;

function GetHumHairImg(Job, Sex, Hair: Byte; nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
var
  ACount: Integer;
begin
  Result := nil;
  if Job = _JOB_SHAMAN then
  begin
    case Hair of
      1: Result := g_WHair3ImgImages.GetCachedImage(nFrame, ax, ay);
      else
        Result := g_WHair3ImgImages.GetCachedImage(728 + nFrame, ax, ay);
    end;
    Exit;
  end;
  if Hair > 0 then
  begin
    case Job of
      _JOB_WAR.._JOB_DAO:
      begin
        case Hair of
          240, 241: Result := g_WHair2ImgImages.GetCachedImage(HUMANFRAME * (Sex + 6) + nFrame, ax, ay);
          242, 243: Result := g_WHair2ImgImages.GetCachedImage(HUMANFRAME * (Sex + 8) + nFrame, ax, ay);
          244, 245: Result := g_WHair2ImgImages.GetCachedImage(HUMANFRAME * (Sex + 8) + nFrame, ax, ay);
          246, 247: Result := g_WHair2ImgImages.GetCachedImage(HUMANFRAME * (Sex + 12) + nFrame, ax, ay);
          248, 249: Result := g_WHair2ImgImages.GetCachedImage(HUMANFRAME * (Sex + 10) + nFrame, ax, ay);
          252 .. 255:
            begin
              Result := g_WHair2ImgImages.GetCachedImage(HUMANFRAME * (Hair + Hair + Sex) + nFrame, ax, ay);
            end;
        else
          begin
            ACount := g_WHairImgImages.ImageCount div 1200;
            if Hair > ACount - 1 then
              Hair := ACount - 1;
            Result := g_WHairImgImages.GetCachedImage(HUMANFRAME * (Hair + Hair + Sex) + nFrame, ax, ay);
          end;
        end;
      end;
      _JOB_ARCHER:
      begin
        case Hair of
          1:
          begin
            case Sex of
              0: Result := g_WHairGJSImages.GetCachedImage(nFrame, ax, ay);
              1: Result := g_WHairGJSImages.GetCachedImage(600 + nFrame, ax, ay);
            end;
          end;
          else
          begin
            case Sex of
              0: Result := g_WHairGJSImages.GetCachedImage(1200 + nFrame, ax, ay);
              1: Result := g_WHairGJSImages.GetCachedImage(1800 + nFrame, ax, ay);
            end;
          end;
        end;
      end;
      _JOB_CIK:
      begin
        case Sex of
          0: Result := g_WHairCIKImages.GetCachedImage(3552 + nFrame, ax, ay);
          1: Result := g_WHairCIKImages.GetCachedImage(4440 + nFrame, ax, ay);
        end;

      end;
    end;
  end;
end;

function GetHumInnerHairImg(Job, Sex, Hair: Byte; var ax, ay: Integer): TAsphyreLockableTexture; inline;
var
  ACount: Integer;
  nIdx : Integer;
begin
  Result := nil;
  if Job = _JOB_SHAMAN then
  begin
    case Hair of
      1: Result := g_WHair3ImgImages.GetCachedImage(727, ax, ay);
      else
        Result := g_WHair3ImgImages.GetCachedImage(1455, ax, ay);
    end;
    Exit;
  end;

  if Hair > 0 then
  begin
    case Job of
      0..2:
      begin
        if Hair > 2 then
          Hair := 2;

        case Sex of
          0: nIdx := 444;
          1: nIdx := 440;
        end;

        if (Hair = 2) and (Sex = 1) then
          nIdx := 441;

        nIdx := nIdx + Hair;
        Result := g_wMainImages.GetCachedImage(nIdx,ax,ay);

        if (Hair = 1) and (Sex = 0) then
        begin
         ay := 0;

        end;


      end;
      _JOB_ARCHER:
      begin
        case Hair of
          1:
          begin
            case Sex of
              0: Result := g_WHairGJSImages.GetCachedImage(599, ax, ay);
              1:
              begin
                Result := g_WHairGJSImages.GetCachedImage(1199, ax, ay);
                ax := ax + 68;
                ay := ay - 37;
              end;
            end;
          end;
          else
          begin
            case Sex of
              0: Result := g_WHairGJSImages.GetCachedImage(1799, ax, ay);
              1: Result := g_WHairGJSImages.GetCachedImage(2399, ax, ay);
            end;
          end;
          ax := ax + 68;
          ay := ay - 37;
        end;
      end;
      _JOB_CIK:
      begin
        case Sex of
          0: Result := g_WHairCIKImages.GetCachedImage(4439, ax, ay);
          1: Result := g_WHairCIKImages.GetCachedImage(5327, ax, ay);
        end;
      end;
    end;
  end;
end;

function GetWHumImg(Job, m_btSex: Byte; Dress, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
var
 nIndex:Integer;
 nRealDress:Integer;
begin
  Result := nil;
  case Dress of
    RES_IMG_BASE..RES_IMG_MAX:
    begin
      Result := g_77HumImages[Dress].GetCachedImage(100 + nFrame, ax, ay);
      if Result <> nil then
        Exit;
      Dress := 0;
    end;
  end;

  case Job of
    0..2:
    begin


      case Dress of
        0 .. 23: Result := g_WHumImgImages[0].GetCachedImage(HUMANFRAME * Dress + nFrame, ax, ay);
        24 .. 47: Result := g_WHumImgImages[1].GetCachedImage(HUMANFRAME * (Dress - 24) + nFrame, ax, ay);
        48 .. 95: Result := g_WHumImgImages[2].GetCachedImage(HUMANFRAME * (Dress - 48) + nFrame, ax, ay);
        96 .. 181: Result := g_WHumImgImages[3].GetCachedImage(HUMANFRAME * (Dress - 96) + nFrame, ax, ay);
        182 .. 299: Result := g_WHumImgImages[4].GetCachedImage(HUMANFRAME * (Dress - 182) + nFrame, ax, ay);
        300 .. 1999:
        begin
          Dress := Dress - 300;
          nIndex := (Dress div 100) + 5;
          nRealDress := Dress mod 100;
          if nIndex in [Low(g_WHumImgImages)..High(g_WHumImgImages)] then
          begin
            Result := g_WHumImgImages[nIndex].GetCachedImage(HUMANFRAME * nRealDress + nFrame, ax, ay);
          end;
        end;
      end;
      if Result = nil then
        Result := g_WHumImgImages[0].GetCachedImage(HUMANFRAME * m_btSex + nFrame, ax, ay);
    end;
    _JOB_ARCHER:
    begin
      case Dress of
        0..17: Result := g_WHumImgGJSImages[0].GetCachedImage(HUMANFRAME * Dress + nFrame, ax, ay);
        18, 19: Result := g_WHumImgGJSImages[0].GetCachedImage(11400 + HUMANFRAME * (Dress - 18) + nFrame, ax, ay);
        20, 21: Result := g_WHumImgGJSImages[0].GetCachedImage(12600 + nFrame, ax, ay);
        22, 23: Result := g_WHumImgGJSImages[0].GetCachedImage(13800 + HUMANFRAME * (Dress - 22) + nFrame, ax, ay);
        24..27: Result := g_WHumImgGJSImages[0].GetCachedImage(15600 + HUMANFRAME * (Dress - 24) + nFrame, ax, ay);
        28, 29: Result := g_WHumImgGJSImages[0].GetCachedImage(18000 + nFrame, ax, ay);
        30, 31: Result := g_WHumImgGJSImages[0].GetCachedImage(18600 + HUMANFRAME * (Dress - 30) + nFrame, ax, ay);
        32..39: Result := g_WHumImgImages[3].GetCachedImage(HUMANFRAME * (Dress - 32) + nFrame, ax, ay);
      end;
      if Result = nil then
        Result := g_WHumImgGJSImages[0].GetCachedImage(HUMANFRAME * m_btSex + nFrame, ax, ay);
    end;
    _JOB_CIK:
    begin

      nIndex := Dress div 200;
      nRealDress := Dress mod 200;



      if nIndex in [Low(g_WHumImgCKImages)..High(g_WHumImgCKImages)] then
      begin
        Result := g_WHumImgCKImages[nIndex].GetCachedImage(888 * nRealDress + nFrame, ax, ay);
      end;
      if Result = nil then
        Result := g_WHumImgCKImages[0].GetCachedImage(888{(HUMANFRAME + 288)} * m_btSex + nFrame, ax, ay);
    end;
    _JOB_SHAMAN:
    begin
      Result := g_WHumImgWSImages[0].GetCachedImage(728{(HUMANFRAME + 128)} * (Dress div 2) + nFrame, ax, ay);
      if Result = nil then
        Result := g_WHumImgWSImages[0].GetCachedImage(728{(HUMANFRAME + 128)} * m_btSex + nFrame, ax, ay);
    end;
  end;
end;

function GetWWeaponImg(Job, m_btSex: Byte; Weapon, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
var
  nIndex : Integer;
  nRealWeapon : Integer;
begin
  Result := nil;
  case Weapon of
    RES_IMG_BASE..RES_IMG_MAX:
    begin
      Result := g_77WeponImages[Weapon].GetCachedImage(100 + nFrame, ax, ay);
      if Result <> nil then
        Exit;
      Weapon := 0;
    end;
  end;

  case Job of
    0..2:
    begin
//      case Weapon of
//        0 .. 75: Result := g_WWeaponImages[0].GetCachedImage(HUMANFRAME * Weapon + nFrame, ax, ay);
//        76 .. 117: Result := g_WWeaponImages[1].GetCachedImage(HUMANFRAME * (Weapon - 76) + nFrame, ax, ay);
//        118 .. 171: Result := g_WWeaponImages[2].GetCachedImage(HUMANFRAME * (Weapon - 118) + nFrame, ax, ay);
//        172 .. 225: Result := g_WWeaponImages[3].GetCachedImage(HUMANFRAME * (Weapon - 172) + nFrame, ax, ay);
//        226 .. 243: Result := g_WWeaponImages[4].GetCachedImage(HUMANFRAME * (Weapon - 226) + nFrame, ax, ay);
//        244 .. 255: Result := g_77WWeaponImages.GetCachedImage(HUMANFRAME * (Weapon - 244) + nFrame, ax, ay);
//      end;

      case Weapon of
        0 .. 75: Result := g_WWeaponImages[0].GetCachedImage(HUMANFRAME * Weapon + nFrame, ax, ay);
        76 .. 117: Result := g_WWeaponImages[1].GetCachedImage(HUMANFRAME * (Weapon - 76) + nFrame, ax, ay);
        118 .. 171: Result := g_WWeaponImages[2].GetCachedImage(HUMANFRAME * (Weapon - 118) + nFrame, ax, ay);
        172 .. 225: Result := g_WWeaponImages[3].GetCachedImage(HUMANFRAME * (Weapon - 172) + nFrame, ax, ay);
        226 .. 299: Result := g_WWeaponImages[4].GetCachedImage(HUMANFRAME * (Weapon - 226) + nFrame, ax, ay);
        300 .. 1999:
        begin
          Weapon := Weapon - 300;
          nIndex := (Weapon div 100) + 5;
          nRealWeapon := Weapon mod 100;
          if nIndex in [Low(g_WWeaponImages)..High(g_WWeaponImages)] then
          begin
            Result := g_WWeaponImages[nIndex].GetCachedImage(HUMANFRAME * nRealWeapon + nFrame, ax, ay);
          end;
        end;
        2000 .. 9999: Result := g_77WWeaponImages.GetCachedImage(HUMANFRAME * (Weapon - 244) + nFrame, ax, ay);
      end;

      if Result = nil then
        Result := g_WWeaponImages[0].GetCachedImage(HUMANFRAME * m_btSex + nFrame, ax, ay);
    end;
    _JOB_ARCHER:
    begin
      Result := g_WWeaponGJSImages[0].GetCachedImage(HUMANFRAME * Weapon + nFrame, ax, ay);
//      case Weapon of
//        0..37: Result := g_WWeaponGJSImages[0].GetCachedImage(HUMANFRAME * Weapon + nFrame, ax, ay);
//      end;
      if Result = nil then
        Result := g_WWeaponGJSImages[0].GetCachedImage(HUMANFRAME * m_btSex + nFrame, ax, ay);
    end;
    _JOB_CIK:
    begin

      GetWeaponLibIndex(Weapon,nIndex,nRealWeapon);
      if nIndex in [Low(g_WWeaponCKRImages)..High(g_WWeaponCKRImages)] then
      begin
        Result := g_WWeaponCKRImages[nIndex].GetCachedImage(888 * nRealWeapon + nFrame, ax, ay);
      end;

      if Result = nil then
        Result := g_WWeaponCKRImages[0].GetCachedImage(888 * m_btSex + nFrame, ax, ay);

    end;
    _JOB_SHAMAN:
    begin
      Result := g_WWeaponWSImages[0].GetCachedImage(728 * (Weapon div 2) + nFrame, ax, ay);
      if Result = nil then
        Result := g_WWeaponWSImages[0].GetCachedImage(728 + nFrame, ax, ay);
    end;
  end;
end;

function GetWLWeaponImg(Job, m_btSex: Byte; Weapon, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
var
  nIndex , nRealWeapon : Integer;
begin
  Result := nil;
  case Weapon of
    RES_IMG_BASE..RES_IMG_MAX: Result := g_77WeponLImages[Weapon].GetCachedImage(100 + nFrame, ax, ay);
    else
    begin
      if Job = _JOB_CIK then
      begin
        GetWeaponLibIndex(Weapon,nIndex,nRealWeapon);

        if nIndex in [Low(g_WWeaponCKLImages)..High(g_WWeaponCKLImages)] then
        begin
          Result := g_WWeaponCKLImages[nIndex].GetCachedImage(888 * nRealWeapon + nFrame, ax, ay);
        end;

        if Result = nil then
          Result := g_WWeaponCKLImages[0].GetCachedImage(888 * m_btSex + nFrame, ax, ay);
      end;
    end;
  end;
end;


function GetWLWeaponWinImage(Job, m_btSex: Byte; nEffect, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
var
 nIndex , nRealWeapon :Integer;
begin
  Result := nil;
  if Job = _JOB_CIK then
  begin
    GetWeaponEffLibIndex(nEffect,m_btSex,nIndex,nRealWeapon);
    if nIndex in [Low(g_WWeaponCKLEffect)..High(g_WWeaponCKLEffect)] then
    begin
      Result := g_WWeaponCKLEffect[nIndex].GetCachedImage( 888 * nRealWeapon + nFrame, ax, ay);
    end;
  end;

end;

function GetWWeaponWinImage(Job, m_btSex: Byte; nEffect, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
var
  AIndex: Integer;
  nIndex , nRealWeapon : Integer;
begin
  Result := nil;
  case nEffect of
    RES_IMG_BASE..RES_IMG_MAX: Result := g_77WeponImages[nEffect].GetCachedImage(2100 + nFrame, ax, ay);
  else
      AIndex := GetHumWinOffset(Job, nEffect + m_btSex) + nFrame;
      case Job of
        0..2:
        begin
          case AIndex of
            0 .. 11999: Result := g_WHumWingImages[0].GetCachedImage(AIndex, ax, ay);
            12000 .. 26399: Result := g_WHumWingImages[1].GetCachedImage(AIndex - 12000, ax, ay);
            26400 .. 44399: Result := g_WHumWingImages[2].GetCachedImage(AIndex - 26400, ax, ay);
            44400 .. 53999: Result := g_WHumWingImages[3].GetCachedImage(AIndex - 44400, ax, ay);
            54000 .. 58799: Result := g_WHumWingImages[4].GetCachedImage(AIndex - 54000, ax, ay);
          end;
        end;
        _JOB_CIK:
        begin
          GetWeaponEffLibIndex(nEffect,m_btSex,nIndex,nRealWeapon);
          if nIndex in [Low(g_WWeaponCKREffect)..High(g_WWeaponCKREffect)] then
          begin
            Result := g_WWeaponCKREffect[nIndex].GetCachedImage(888 * nRealWeapon + nFrame, ax, ay);
          end;
        end;
        _JOB_ARCHER:
        begin
          case AIndex of
            21000..23400: Result := g_WHumImgImages[3].GetCachedImage(4800 + AIndex - 21000, ax, ay);
          end;
        end;
      end;
   end;
end;


function GetShieldImg(Shield, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
begin
  Result := nil;
  case Shield of
    RES_IMG_BASE..RES_IMG_MAX:
    begin
      Result := g_77ShieldImages[Shield].GetCachedImage(100 + nFrame, ax, ay);
    end;
  end;
end;

function GetShieldWinImage(Shield, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
begin
  Result := nil;
  case Shield of
    RES_IMG_BASE..RES_IMG_MAX:
    begin
      Result := g_77ShieldImages[Shield].GetCachedImage(2100 + nFrame, ax, ay);
    end;
  end;
end;

function GetWHumWinImage(Job, m_btSex: Byte; nEffect, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
var
  AIndex,nRealDress: Integer;

begin
  Result := nil;
  case nEffect of
    RES_IMG_BASE..RES_IMG_MAX:
    begin
      Result := g_77HumImages[nEffect].GetCachedImage(2100 + nFrame, ax, ay);
      Exit;
    end;
  end;
  AIndex := GetHumWinOffset(Job, nEffect) + nFrame;
  case Job of
    0..2:
    begin
      case AIndex of
        0 .. 11999: Result := g_WHumWingImages[0].GetCachedImage(AIndex, ax, ay);
        12000 .. 26399: Result := g_WHumWingImages[1].GetCachedImage(AIndex - 12000, ax, ay);
        26400 .. 44399: Result := g_WHumWingImages[2].GetCachedImage(AIndex - 26400, ax, ay);
        44400 .. 53999: Result := g_WHumWingImages[3].GetCachedImage(AIndex - 44400, ax, ay);
        54000 .. 58799: Result := g_WHumWingImages[4].GetCachedImage(AIndex - 54000, ax, ay);
      end;
    end;
    _JOB_CIK:
    begin
      AIndex := nEffect div 100;
      nRealDress := nEffect mod 100;
      if AIndex in [Low(g_WHumWingCKImages)..High(g_WHumWingCKImages)] then
      begin
        Result := g_WHumWingCKImages[AIndex].GetCachedImage(888 * nRealDress + nFrame, ax, ay);
      end;
    end;
    _JOB_ARCHER:
    begin
      case AIndex of
        21000..23400: Result := g_WHumImgImages[3].GetCachedImage(4800 + AIndex - 21000, ax, ay);
      end;
    end;
  end;
end;

function GetWCBOHumImg(Dress, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
begin
  Result := nil;
  if Dress < 48 then
  begin
    Result := g_WWiscboHum.GetCachedImage(HUMCBOANFRAME * Dress + nFrame, ax, ay);
  end
  else
  begin
    Result := g_WWiscboHum3.GetCachedImage(HUMCBOANFRAME * (Dress - 48) + nFrame, ax, ay);
  end;
end;

function GetWCBOHumEffectImg(Effect, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
begin
  Result := nil;
  case Effect of
    0 .. 27:
      Result := g_WWiscboHumWing.GetCachedImage(HUMCBOANFRAME * Effect + nFrame, ax, ay);
    28 .. 41:
      Result := g_WWiscboHumWing2.GetCachedImage(HUMCBOANFRAME * (Effect - 28) + nFrame, ax, ay);
  else
    Result := g_WWiscboHumWing3.GetCachedImage(HUMCBOANFRAME * (Effect - 42) + nFrame, ax, ay);
  end;
end;

function GetWCBOWeaponImg(Weapon, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
begin
  Result := nil;
  if Weapon < 118 then
  begin
    Result := g_WWiscboWeapon.GetCachedImage(HUMCBOANFRAME * Weapon + nFrame, ax, ay);
  end
  else
  begin
    Result := g_WWiscboWeapon3.GetCachedImage(HUMCBOANFRAME * (Weapon - 118) + nFrame, ax, ay);
  end;
end;

function GetHorseImage(Horse, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
begin
  Result := nil;
  case Horse of
    1..19: Result := g_WHorseImages[0].GetCachedImage(HUMANFRAME *(Horse - 1) + nFrame, ax, ay);
    20..39: Result := g_WHorseImages[1].GetCachedImage(HUMANFRAME *(Horse - 20) + nFrame, ax, ay);
    40..59: Result := g_WHorseImages[2].GetCachedImage(HUMANFRAME *(Horse - 40) + nFrame, ax, ay);
    60..79: Result := g_WHorseImages[3].GetCachedImage(HUMANFRAME *(Horse - 60) + nFrame, ax, ay);
    80..99: Result := g_WHorseImages[4].GetCachedImage(HUMANFRAME *(Horse - 80) + nFrame, ax, ay);
    100..119: Result := g_WHorseImages[5].GetCachedImage(HUMANFRAME *(Horse - 100) + nFrame, ax, ay);
    120..139: Result := g_WHorseImages[6].GetCachedImage(HUMANFRAME *(Horse - 120) + nFrame, ax, ay);
    140..159: Result := g_WHorseImages[7].GetCachedImage(HUMANFRAME *(Horse - 140) + nFrame, ax, ay);
    160..179: Result := g_WHorseImages[8].GetCachedImage(HUMANFRAME *(Horse - 160) + nFrame, ax, ay);
    180..199: Result := g_WHorseImages[9].GetCachedImage(HUMANFRAME *(Horse - 180) + nFrame, ax, ay);
    RES_IMG_BASE..RES_IMG_MAX: Result := g_77HorseImages[Horse].GetCachedImage(nFrame, ax, ay);
  end;
  if Result = nil then
    Result := g_WHorseImages[0].GetCachedImage(nFrame, ax, ay);
end;

function GetHorseHumImage(Dress, m_btSex, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
begin
  Result := nil;
  case Dress of
    0 .. 23: Result := g_WHorseHumImages[0].GetCachedImage(HUMANFRAME * Dress + nFrame, ax, ay);
    24 .. 47: Result := g_WHorseHumImages[1].GetCachedImage(HUMANFRAME * (Dress - 24) + nFrame, ax, ay);
    48 .. 94: Result := g_WHorseHumImages[2].GetCachedImage(HUMANFRAME * (Dress - 48) + nFrame, ax, ay);
    95 .. 102: Result := g_WHorseHumImages[3].GetCachedImage(HUMANFRAME * (Dress - 95) + nFrame, ax, ay);
    103: Result := g_WHorseHumImages[3].GetCachedImage(HUMANFRAME * (Dress - 95) + nFrame, ax, ay); // 刺客衣服
    104 .. 105: Result := g_WHorseHumImages[4].GetCachedImage(HUMANFRAME * (Dress - 104) + nFrame, ax, ay);
    RES_IMG_BASE..RES_IMG_MAX: Result := g_77HorseHumImages[Dress].GetCachedImage(nFrame, ax, ay);
  end;
  if Result = nil then
    Result := g_WHorseHumImages[0].GetCachedImage(HUMANFRAME * m_btSex + nFrame, ax, ay);
end;

function GetHorseHairImage(Hair, HairOffset: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
begin
  Result := g_WHorseHairImgImages.GetCachedImage(HUMANFRAME * Hair + HairOffset, ax, ay);
end;

function GetHorseHumWinImage(Job, m_btSex: Byte; nEffect, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
var
  AIndex: Integer;
begin
  Result := nil;
  if nEffect > 0 then
  begin
    case nEffect of
      RES_IMG_BASE..RES_IMG_MAX:
      begin
        Result := g_77HumImages[nEffect].GetCachedImage(2100 + nFrame, ax, ay);
        Exit;
      end;
    end;
    AIndex := GetHumWinOffset(Job, nEffect);
    case AIndex of
      0 .. 11999: Result := g_WHorseHumWingImages[0].GetCachedImage(AIndex, ax, ay);
      12000 .. 26399: Result := g_WHorseHumWingImages[1].GetCachedImage(AIndex - 12000, ax, ay);
      26400 .. 44399: Result := g_WHorseHumWingImages[2].GetCachedImage(AIndex - 26400, ax, ay);
      44400 .. 53999: Result := g_WHorseHumWingImages[3].GetCachedImage(AIndex - 44400, ax, ay);
      54000 .. 58799: Result := g_WHorseHumWingImages[4].GetCachedImage(AIndex - 54000, ax, ay);
    end;
  end;
end;

var
  g_boInitClientType : Boolean = False;
  g_boReturnMir : Boolean = false;

function IsMirReturnClient():Boolean;
begin
  if g_boInitClientType = False then
  begin
    if FileExists('.\Data\backtiles.wzl') then
    begin
      g_boReturnMir := True;
    end else
    begin
      g_boReturnMir := False;
    end;
    g_boInitClientType := True;
  end;

   Result := g_boReturnMir;
end;

function GetMagicIcon(var AMagic: TClientMagic; Lvl, Strengthen: Integer; ADowned: Boolean): TAsphyreLockableTexture;
var
  AClient: TuMagicClient;
  AImages: TWMImages;
  AIcon: Integer;
  FileIndex : Integer;
  ImgFile:String;
begin
  Result := nil;
  if g_MagicMgr.TryGet(AMagic.wMagicId, AClient) then
  begin
    Result := AClient.GetIcon(Strengthen, ADowned);
  end
  else if AMagic.boCustomMagic then
  begin
    FileIndex := AMagic.MagicIcon div 10000;
    AIcon := AMagic.MagicIcon mod 10000;
    if FileIndex = 0 then
    begin
      Result := g_WMagIconImages.Images[AIcon + Ord(ADowned)];
    end else
    begin
      ImgFile := 'MagIcon' + IntToStr(FileIndex) + '.data';
      LibManager.TryGetLib(ImgFile, AImages);
      if AImages <> nil then
      begin
        Result := AImages.Images[AIcon + Ord(ADowned)];
      end;
    end;
  end
  else
  begin

    AIcon := AMagic.btEffect * 2;
    case AMagic.wMagicId of
      13:
      begin
        if Lvl = 4 then
          AIcon := 140; // 4级灵魂火符图标
      end;
      26:
      begin
        if Lvl = 4 then
          AIcon := 142; // 4级烈火图标
      end;
      45:
      begin
        if Lvl = 4 then
          AIcon := 144; // 4级灭天火图标
      end;
      75: AIcon := 104;  //护体神盾
      88: AIcon := 444;//四级基本剑术
      89: AIcon := 432; // 四级刺杀
      90: AIcon := 420; // 圆月弯刀
      91: AIcon := 456; // 四级雷电术
      92: AIcon := 160; // 四级流星火雨
      93: AIcon := 474; // 四级施毒术
      150: AIcon := 916;
      151: AIcon := 918;
      152: AIcon := 900;
      153: AIcon := 906;
      154: AIcon := 908;
      155: AIcon := 920;
      156: AIcon := 926;
      157: AIcon := 938;
      158: AIcon := 910;
      SKILL_159..SKILL_170: //刺客图标
      begin
        if not IsMirReturnClient then
        begin
          case AMagic.wMagicId of
            159: AIcon := 748;
            160: AIcon := 778;
            161: AIcon := 780;
            162: AIcon := 794;
            163: AIcon := 786;
            164: AIcon := 782;
            165: AIcon := 756;
            166: AIcon := 766;
            167: AIcon := 758;
            168: AIcon := 784;
            169: AIcon := 742;
            170: AIcon := 836;
          end;
        end else
        begin
          case AMagic.wMagicId of
            159: AIcon := 822;
            160: AIcon := 820;
            161: AIcon := 906;
            162: AIcon := 834;
            163: AIcon := 832;
            164: AIcon := 830;
            165: AIcon := 836;
            166: AIcon := 840;
            167: AIcon := 838;
            168: AIcon := 824;
            169: AIcon := 826;
            170: AIcon := 828;
          end;
        end;

      end;

    end;

    AImages := g_WMagIconImages;
    if AMagic.wMagicId in [88 .. 93, 150..170] then
      AImages := g_WMagIcon2Images;
    if AIcon <> -1 then
      Result := AImages.Images[AIcon + Ord(ADowned)];
  end;
end;

function GetWISWeaponImg(Weapon, m_btSex, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
begin
  Result := nil;
  if Weapon > 239 then
    Result := g_WWiscboWeapon.GetCachedImage(2000 * (Weapon - 126) + nFrame, ax, ay)
  else if Weapon > 237 then
    Result := g_WWiscboHumWing.GetCachedImage(44000 + nFrame, ax, ay)
  else if Weapon > 199 then
    Result := g_WWiscboWeapon.GetCachedImage(2000 * (Weapon - 126) + nFrame, ax, ay)
  else
    Result := g_WWiscboWeapon.GetCachedImage(2000 * (Weapon) + nFrame, ax, ay);
end;

function GetWISHumImg(Dress, m_btSex, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
begin
  Result := nil;
  if Dress > 100 then
  begin
    Result := g_WWiscboHum.GetCachedImage(2000 * (Dress - 78) + nFrame, ax, ay);
  end
  else
  begin
    Result := g_WWiscboHum.GetCachedImage(2000 * (Dress) + nFrame, ax, ay);
  end;
end;

function GetWISHumHairImg(Dress, m_btSex, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
begin
  Result := g_WWiscboHumhair.GetCachedImage(4000 + 2000 * (m_btSex) + nFrame, ax, ay);
end;

function GetWISHumWingImg(Effect, m_btSex, nFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
begin
  Result := nil;
  case Effect of
    7: Result := g_WWiscboHumWing.GetCachedImage(48000 + (2000 * m_btSex) + nFrame, ax, ay);
    24 .. 25: Result := g_WWiscboHumWing.GetCachedImage(48000 + (2000 * m_btSex) + nFrame, ax, ay);
  else
      Result := g_WWiscboHumWing.GetCachedImage(2000 * (Effect + m_btSex) + nFrame, ax, ay);
  end;
end;

{ TuMapDescManager }

procedure TuMapDescManager.AddDesc(aMapX, AMapY, AType: Integer; const ADesc: String; Color: TColor);
var
  AMapDesc: TuMapDesc;
begin
  AMapDesc := TuMapDesc.Create;
  AMapDesc.MapX := aMapX;
  AMapDesc.MapY := AMapY;
  AMapDesc._Type := AType;
  AMapDesc.Desc := ADesc;
  AMapDesc.Color := Color;
  Add(AMapDesc);
end;

procedure TuMapDescManager.ClearDesc;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].Free;
  Clear;
end;

destructor TuMapDescManager.Destroy;
begin
  ClearDesc;
  inherited;
end;

function TuMapDescManager.Get(index: Integer): TuMapDesc;
begin
  Result := TuMapDesc( inherited Items[index]);
end;

procedure AddMarketItemToMyMarket(Idx, Gold, GameGold: Integer);
begin
  if Idx in [0 .. 11] then
  begin
    g_MyMarket[Idx] := g_MarketItem.Item;
    g_MyMarket[Idx].RegTime := Now;
    g_MyMarket[Idx].Gold := Gold;
    g_MyMarket[Idx].GameGold := GameGold;
    g_MyMarket[Idx].Index := Idx;
  end;
end;

procedure UpdateMyMarketItem(Gold, GameGold: Integer);
var
  I: Integer;
begin
  for I := 0 to 11 do
    if g_MarketItem.Item.Item.MakeIndex = g_MyMarket[I].Item.MakeIndex then
    begin
      g_MyMarket[I].Gold := Gold;
      g_MyMarket[I].GameGold := GameGold;
      Break;
    end;
end;

procedure ClearMyMarketItem(Idx: Integer);
var
  I: Integer;
begin
  if Idx in [0 .. 11] then
    g_MyMarket[Idx].Item.Name := '';
end;

procedure ClearWhoMarketItemByMoving(IsUpdate: Boolean; Count: Integer);
var
  I: Integer;
begin
  for I := 0 to 11 do
  begin
    if g_MarketItem.Item.Item.MakeIndex = g_WhoStall[I].Item.MakeIndex then
    begin
      if IsUpdate then
        g_WhoStall[I].Item.Dura := Count
      else
        g_WhoStall[I].Item.Name := '';
      Break;
    end;
  end;
end;

procedure AddStallItemToMyStall(Idx, Gold, GameGold: Integer);
begin
  if Idx in [0 .. 11] then
  begin
    g_StallItems[Idx] := g_MarketItem.Item;
    g_StallItems[Idx].RegTime := Now;
    g_StallItems[Idx].Gold := Gold;
    g_StallItems[Idx].GameGold := GameGold;
    g_StallItems[Idx].Index := Idx;
  end;
end;

procedure UpdateMyStallItem(Gold, GameGold: Integer);
var
  I: Integer;
begin
  for I := 0 to 11 do
    if g_MarketItem.Item.Item.MakeIndex = g_StallItems[I].Item.MakeIndex then
    begin
      g_StallItems[I].Gold := Gold;
      g_StallItems[I].GameGold := GameGold;
      Break;
    end;
end;

procedure ClearMyStallItem(Idx: Integer);
var
  I: Integer;
begin
  if Idx in [0 .. 11] then
    g_StallItems[Idx].Item.Name := '';
end;

procedure ClearWhoStallItemByMoving(IsUpdate: Boolean; Count: Integer);
var
  I: Integer;
begin
  for I := 0 to 11 do
  begin
    if g_MarketItem.Item.Item.MakeIndex = g_QueryStallItems[I].Item.MakeIndex then
    begin
      if IsUpdate then
        g_QueryStallItems[I].Item.Dura := Count
      else
        g_QueryStallItems[I].Item.Name := '';
      Break;
    end;
  end;
end;

procedure AddStallBuyItemToMyStallBuy(Idx, Gold, GameGold, Count: Integer);
begin
  if Idx in [0 .. 11] then
  begin
    g_StallBuyItems[Idx].Item := g_MarketItem.Item;
    g_StallBuyItems[Idx].Item.Gold := Gold;
    g_StallBuyItems[Idx].Item.GameGold := GameGold;
    g_StallBuyItems[Idx].Item.Index := Idx;
    g_StallBuyItems[Idx].Item.RegTime := Now;
    g_StallBuyItems[Idx].ItemName := g_MarketItem.Item.Item.Name;
    g_StallBuyItems[Idx].RegTime := Now;
    g_StallBuyItems[Idx].Gold := Gold;
    g_StallBuyItems[Idx].GameGold := GameGold;
    g_StallBuyItems[Idx].Count := Count;
    g_StallBuyItems[Idx].Index := Idx;
    if g_StallBuyItems[Idx].Item.Item.S.StdMode in [{$I AddinStdmode.INC}] then
    begin
      g_StallBuyItems[Idx].Item.Item.DuraMax := Count;
      g_StallBuyItems[Idx].Item.Item.Dura := Count;
    end
    else
    begin
      g_StallBuyItems[Idx].Item.Item.DuraMax := g_StallBuyItems[Idx].Item.Item.S.DuraMax;
      g_StallBuyItems[Idx].Item.Item.Dura := g_StallBuyItems[Idx].Item.Item.DuraMax;
    end;
  end;
  g_StallBuyItems[Idx].Item.Item.AddHold[0] := -1;
  g_StallBuyItems[Idx].Item.Item.AddHold[1] := -1;
  g_StallBuyItems[Idx].Item.Item.AddHold[2] := -1;
end;

procedure ClearMyStallBuyItem(Idx: Integer);
var
  I: Integer;
begin
  if Idx in [0 .. 11] then
  begin
    g_StallBuyItems[Idx].ItemName := '';
    g_StallBuyItems[Idx].Item.Item.Name := '';
  end;
end;

procedure UpdateQueryStallItemBuy(AIndex, ACount: Integer);
begin
  if AIndex in [0 .. 11] then
  begin
    g_QueryStallBuyItems[AIndex].Count := ACount;
    if g_QueryStallBuyItems[AIndex].Item.Item.S.StdMode in [{$I AddinStdmode.INC}] then
    begin
      g_QueryStallBuyItems[AIndex].Item.Item.DuraMax := ACount;
      g_QueryStallBuyItems[AIndex].Item.Item.Dura := ACount;
    end;
    if g_QueryStallBuyItems[AIndex].Count <= 0 then
    begin
      g_QueryStallBuyItems[AIndex].ItemName := '';
      g_QueryStallBuyItems[AIndex].Item.Item.Name := '';
    end;
  end;
end;

type
  TVerStrData = class(TPersistent)
  private
    FVer: String;
    FData: AnsiString;
  published
    property Ver: String read FVer write FVer;
    property Data: AnsiString read FData write FData;
  end;

procedure LoadStdItems;
var
  AVerData: TVerStrData;
  Stream, ItemStream: TStream;
  F: TFileStream;
  Item: pTStdItem;
  FileName: String;
begin
  FileName := ResourceDir + g_sServerName + '\Items.dat';
  if FileExists(FileName) then
  begin
    try
      ClearItems;
      g_ItemVer := '';
      AVerData := TVerStrData.Create;
      Stream := TMemoryStream.Create;
      ItemStream := TMemoryStream.Create;
      F := TFileStream.Create(FileName, fmOpenRead);
      try
        uEDCode.DecodeStream(F, Stream, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
        Stream.Seek(0, soFromBeginning);
        NativeXmlObjectStorage.ObjectLoadFromXmlStream(AVerData, Stream);
        LoadStreamFromString(AVerData.Data, ItemStream);
        if ItemStream.Size mod SizeOf(TStdItem) = 0 then
        begin
          g_ItemVer := AVerData.Ver;
          ItemStream.Seek(0, soFromBeginning);
          New(Item);
          Item.Name := g_sGoldName;
          Item.StdMode := 254;
          g_ItemList.Add(Item);
          while ItemStream.Position < ItemStream.Size do
          begin
            New(Item);
            ItemStream.ReadBuffer(Item^, SizeOf(TStdItem));
            g_ItemList.Add(Item);
          end;
        end;
      finally
        Stream.Free;
        ItemStream.Free;
        F.Free;
        AVerData.Free;
      end;
    except
      ClearItems;
      g_ItemVer := '';
    end;
  end;
end;

procedure SaveStdItems;
var
  AVerData: TVerStrData;
  Stream: TMemoryStream;
  F: TFileStream;
  I: Integer;
  FileName: String;
begin
  if not DirectoryExists(ResourceDir + g_sServerName + '\') then
    CreateDir(ResourceDir + g_sServerName + '\');

  FileName := ResourceDir + g_sServerName + '\Items.dat';
  if FileExists(FileName) then
    IOUtils.TFile.Delete(FileName);
  AVerData := TVerStrData.Create;
  Stream := TMemoryStream.Create;
  F := TFileStream.Create(FileName, fmCreate);
  try
    for I := 1 to g_ItemList.Count - 1 do
      Stream.WriteBuffer(g_ItemList.Items[I]^, SizeOf(TStdItem));
    AVerData.Ver := g_ItemVer;
    AVerData.Data := Common.SaveStreamToString(Stream);
    Stream.Clear;
    NativeXmlObjectStorage.ObjectSaveToXmlStream(AVerData, Stream);
    uEDCode.EncodeStream(Stream, F, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
  finally
    Stream.Free;
    F.Free;
    AVerData.Free;
  end;
end;

procedure LoadStdItemsDesc;
var
  Stream: TStringStream;
  F: TFileStream;
  I: Integer;
  FileName: String;
begin
  FileName := ResourceDir + g_sServerName + '\ItemsDesc.dat';
  if FileExists(FileName) then
  begin
    g_ItemDesc.Clear;
    Stream := TStringStream.Create;
    F := TFileStream.Create(FileName, fmOpenRead);
    try
      uEDCode.DecodeStream(F, Stream, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
      Stream.Seek(0, soFromBeginning);
      g_ItemDesc.Text := Stream.DataString;
      if g_ItemDesc.Count <> g_ItemList.Count then
      begin
        g_ItemDesc.Clear;
        g_ItemDesc.Add('');
        for I := 1 to g_ItemList.Count - 1 do
          g_ItemDesc.Add('');
      end;
    finally
      Stream.Free;
      F.Free;
    end;
  end;
  if g_ItemDesc.Count <> g_ItemList.Count then
    g_ItemVer := '';
end;

procedure SaveStdItemsDesc;
var
  Stream: TStringStream;
  F: TFileStream;
  FileName: String;
begin
  if not DirectoryExists(ResourceDir + g_sServerName + '\') then
    CreateDir(ResourceDir + g_sServerName + '\');
  FileName := ResourceDir + g_sServerName + '\ItemsDesc.dat';
  if FileExists(FileName) then
    IOUtils.TFile.Delete(FileName);
  Stream := TStringStream.Create(g_ItemDesc.Text);
  F := TFileStream.Create(FileName, fmCreate);
  try
    uEDCode.EncodeStream(Stream, F, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
  finally
    Stream.Free;
    F.Free;
  end;
end;

procedure LoadItemTypeNames;
var
  AVerData: TVerStrData;
  Stream: TStream;
  F: TFileStream;
  I: Integer;
  List: TStrings;
  FileName, SName, SValue: String;
begin
  FileName := ResourceDir + g_sServerName + '\ItemTypeNames.dat';
  if FileExists(FileName) then
  begin
    g_ItemTypeNames.Clear;
    g_ItemTypeNamesVer := '';
    try
      Stream := TMemoryStream.Create;
      AVerData := TVerStrData.Create;
      List := TStringList.Create;
      F := TFileStream.Create(FileName, fmOpenRead);
      try
        uEDCode.DecodeStream(F, Stream, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
        Stream.Seek(0, soFromBeginning);
        NativeXmlObjectStorage.ObjectLoadFromXmlStream(AVerData, Stream);
        g_ItemTypeNamesVer := AVerData.FVer;
        List.Text := AVerData.FData;
        for I := 0 to List.Count - 1 do
        begin
          SValue := GetValidStr3(List.Strings[I], SName, ['=']);
          if (SName <> '') and (SValue <> '') and (StrToIntDef(SName, 0) IN [0 .. 255]) then
            g_ItemTypeNames.AddOrSetValue(StrToInt(SName), Trim(SValue));
        end;
      finally
        Stream.Free;
        F.Free;
        AVerData.Free;
        List.Free;
      end;
    except
      g_ItemTypeNames.Clear;
      g_ItemTypeNamesVer := '';
    end;
  end;
end;

procedure SaveItemTypeNames;
var
  Stream: TMemoryStream;
  F: TFileStream;
  FileName: String;
  TypeNames: TStrings;
  APairEnum: TDictionary<Byte, String>.TPairEnumerator;
  AVerData: TVerStrData;
begin
  if not DirectoryExists(ResourceDir + g_sServerName + '\') then
    CreateDir(ResourceDir + g_sServerName + '\');
  FileName := ResourceDir + g_sServerName + '\ItemTypeNames.dat';
  if FileExists(FileName) then
    IOUtils.TFile.Delete(FileName);
  TypeNames := TStringList.Create;
  Stream := TMemoryStream.Create;
  AVerData := TVerStrData.Create;
  F := TFileStream.Create(FileName, fmCreate);
  try
    APairEnum := g_ItemTypeNames.GetEnumerator;
    while APairEnum.MoveNext do
      TypeNames.Add(Format('%d=%s', [APairEnum.Current.Key, APairEnum.Current.Value]));

    AVerData.FVer := g_ItemTypeNamesVer;
    AVerData.FData := TypeNames.Text;
    NativeXmlObjectStorage.ObjectSaveToXmlStream(AVerData, Stream);
    uEDCode.EncodeStream(Stream, F, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
  finally
    Stream.Free;
    F.Free;
    TypeNames.Free;
    AVerData.Free;
  end;
end;

procedure LoadItemWay;
var
  AVerData: TVerStrData;
  Stream: TStream;
  F: TFileStream;
  I: Integer;
  List: TStrings;
  FileName, SName, SValue: String;
begin
  FileName := ResourceDir + g_sServerName + '\ItemWay.dat';
  if FileExists(FileName) then
  begin
    g_ItemWay.Clear;
    g_ItemWayVer := '';
    try
      Stream := TMemoryStream.Create;
      AVerData := TVerStrData.Create;
      List := TStringList.Create;
      F := TFileStream.Create(FileName, fmOpenRead);
      try
        uEDCode.DecodeStream(F, Stream, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
        Stream.Seek(0, soFromBeginning);
        NativeXmlObjectStorage.ObjectLoadFromXmlStream(AVerData, Stream);
        g_ItemWayVer := AVerData.FVer;
        List.Text := AVerData.FData;
        for I := 0 to List.Count - 1 do
        begin
          SValue := GetValidStr3(List.Strings[I], SName, ['=']);
          if (SName <> '') and (SValue <> '') and (StrToIntDef(SName, 0) IN [0 .. 255]) then
            g_ItemWay.AddOrSetValue(StrToInt(SName), Trim(SValue));
        end;
      finally
        Stream.Free;
        F.Free;
        AVerData.Free;
        List.Free;
      end;
    except
      g_ItemWay.Clear;
      g_ItemWayVer := '';
    end;
  end;
end;

procedure SaveItemWay;
var
  Stream: TMemoryStream;
  F: TFileStream;
  FileName: String;
  ItemWays: TStrings;
  APairEnum: TDictionary<Byte, String>.TPairEnumerator;
  AVerData: TVerStrData;
begin
  if not DirectoryExists(ResourceDir + g_sServerName + '\') then
    CreateDir(ResourceDir + g_sServerName + '\');
  FileName := ResourceDir + g_sServerName + '\ItemWay.dat';
  if FileExists(FileName) then
    IOUtils.TFile.Delete(FileName);
  ItemWays := TStringList.Create;
  Stream := TMemoryStream.Create;
  AVerData := TVerStrData.Create;
  F := TFileStream.Create(FileName, fmCreate);
  try
    APairEnum := g_ItemWay.GetEnumerator;
    while APairEnum.MoveNext do
      ItemWays.Add(Format('%d=%s', [APairEnum.Current.Key, APairEnum.Current.Value]));

    AVerData.FVer := g_ItemWayVer;
    AVerData.FData := ItemWays.Text;
    NativeXmlObjectStorage.ObjectSaveToXmlStream(AVerData, Stream);
    uEDCode.EncodeStream(Stream, F, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
  finally
    Stream.Free;
    F.Free;
    ItemWays.Free;
    AVerData.Free;
  end;
end;



procedure LoadCustomActorAction();
var
  AVerData: TVerStrData;
  Stream: TMemoryStream;
  F: TFileStream;
  FileName: String;
  sData : String;
begin
  FileName := ResourceDir + g_sServerName + '\CustomActorAction.dat';
  g_CustomActorAction := TuCustomActorAction.Create(nil);
  if FileExists(FileName) then
  begin
    g_CustomActorActionVer := '';
    try
      Stream := TMemoryStream.Create;
      AVerData := TVerStrData.Create;
      F := TFileStream.Create(FileName, fmOpenRead);
      try
        uEDCode.DecodeStream(F, Stream, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
        Stream.Seek(0, soFromBeginning);
        NativeXmlObjectStorage.ObjectLoadFromXmlStream(AVerData, Stream);
        g_CustomActorActionVer := AVerData.FVer;
        Stream.Clear;
        LoadStreamFromString(AVerData.Data, Stream);
        NativeXmlObjectStorage.ObjectLoadFromXmlStream(g_CustomActorAction,Stream);
        InitCustomAction();
      finally
        Stream.Free;
        F.Free;
        AVerData.Free;
      end;
    except
      g_CustomActorActionVer := '';
    end;
  end;
end;

procedure SaveCustomActorAction();
var
  Stream: TMemoryStream;
  F: TFileStream;
  FileName: String;
  CustomActorAction: TStrings;
  APairEnum: TDictionary<Byte, String>.TPairEnumerator;
  AVerData: TVerStrData;
begin
  if not DirectoryExists(ResourceDir + g_sServerName + '\') then
    CreateDir(ResourceDir + g_sServerName + '\');
  FileName := ResourceDir + g_sServerName + '\CustomActorAction.dat';
  if FileExists(FileName) then
    IOUtils.TFile.Delete(FileName);
  CustomActorAction := TStringList.Create;
  Stream := TMemoryStream.Create;
  AVerData := TVerStrData.Create;
  F := TFileStream.Create(FileName, fmCreate);
  try

    AVerData.FVer := g_CustomActorActionVer;
    NativeXmlObjectStorage.ObjectSaveToXmlStream(g_CustomActorAction,Stream);
    AVerData.FData := Common.SaveStreamToString(Stream);
    Stream.Clear;
    NativeXmlObjectStorage.ObjectSaveToXmlStream(AVerData, Stream);
    uEDCode.EncodeStream(Stream, F, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
  finally
    Stream.Free;
    F.Free;
    CustomActorAction.Free;
    AVerData.Free;
  end;
end;

procedure ClearItems;
var
  I: Integer;
begin
  for I := 0 to g_ItemList.Count - 1 do
    Dispose(g_ItemList.Items[I]);
  g_ItemList.Clear;
  g_ItemEffList.Clear;
end;

procedure LoadSuitItems;
var
  AVerData: TVerStrData;
  Stream, SuitStream: TStream;
  F: TFileStream;
  I: Integer;
  Item: pTSuitItem;
  FileName: String;
begin
  FileName := ResourceDir + g_sServerName + '\Suites.dat';
  if FileExists(FileName) then
  begin
    ClearSuitItems;
    g_SuitVer := '';
    try
      Stream := TMemoryStream.Create;
      SuitStream := TMemoryStream.Create;
      AVerData := TVerStrData.Create;
      F := TFileStream.Create(FileName, fmOpenRead);
      try
        uEDCode.DecodeStream(F, Stream, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
        Stream.Seek(0, soFromBeginning);
        NativeXmlObjectStorage.ObjectLoadFromXmlStream(AVerData, Stream);
        LoadStreamFromString(AVerData.Data, SuitStream);
        if SuitStream.Size mod SizeOf(TSuitItem) = 0 then
        begin
          g_SuitVer := AVerData.Ver;
          SuitStream.Seek(0, soFromBeginning);
          while SuitStream.Position < SuitStream.Size do
          begin
            New(Item);
            SuitStream.ReadBuffer(Item^, SizeOf(TSuitItem));
            g_SuitList.Add(Item);
          end;
        end;
      finally
        Stream.Free;
        SuitStream.Free;
        F.Free;
        AVerData.Free;
      end;
    except
      ClearSuitItems;
      g_SuitVer := '';
    end;
  end;
end;

procedure SaveSuitItems;
var
  Stream: TMemoryStream;
  F: TFileStream;
  I: Integer;
  FileName: String;
  AVerData: TVerStrData;
begin
  if not DirectoryExists(ResourceDir + g_sServerName + '\') then
    CreateDir(ResourceDir + g_sServerName + '\');
  FileName := ResourceDir + g_sServerName + '\Suites.dat';
  if FileExists(FileName) then
    IOUtils.TFile.Delete(FileName);
  Stream := TMemoryStream.Create;
  AVerData := TVerStrData.Create;
  F := TFileStream.Create(FileName, fmCreate);
  try
    for I := 0 to g_SuitList.Count - 1 do
      Stream.WriteBuffer(g_SuitList.Items[I]^, SizeOf(TSuitItem));
    AVerData.Ver := g_SuitVer;
    AVerData.Data := Common.SaveStreamToString(Stream);
    Stream.Clear;
    NativeXmlObjectStorage.ObjectSaveToXmlStream(AVerData, Stream);
    uEDCode.EncodeStream(Stream, F, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
  finally
    Stream.Free;
    F.Free;
    AVerData.Free;
  end;
end;

procedure ClearSuitItems;
var
  I: Integer;
begin
  for I := 0 to g_SuitList.Count - 1 do
    Dispose(g_SuitList.Items[I]);
  g_SuitList.Clear;
end;

procedure LoadUI;
var
  Stream: TMemoryStream;
  F: TFileStream;
  FileName: String;
begin
  FileName := ResourceDir + g_sServerName + '\UI.dat';
  if FileExists(FileName) then
  begin
    g_UIManager.Clear;
    g_UIVer := '';
    try
      Stream := TMemoryStream.Create;
      F := TFileStream.Create(FileName, fmOpenRead);
      try
        uEDCode.DecodeStream(F, Stream, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
        Stream.Seek(0, soFromBeginning);
        NativeXmlObjectStorage.ObjectLoadFromXmlStream(g_UIManager, Stream);
        g_UIVer := g_UIManager.Ver;
      finally
        Stream.Free;
        F.Free;
      end;
    except
      g_UIManager.Clear;
      g_UIVer := '';
    end;
  end;
end;

procedure SaveUI;
var
  Stream: TMemoryStream;
  F: TFileStream;
  FileName: String;
begin
  if not DirectoryExists(ResourceDir + g_sServerName + '\') then
    CreateDir(ResourceDir + g_sServerName + '\');
  FileName := ResourceDir + g_sServerName + '\UI.dat';
  if FileExists(FileName) then
    IOUtils.TFile.Delete(FileName);
  Stream := TMemoryStream.Create;
  F := TFileStream.Create(FileName, fmCreate);
  try
    g_UIManager.Ver := g_UIVer;
    NativeXmlObjectStorage.ObjectSaveToXmlStream(g_UIManager, Stream);
    uEDCode.EncodeStream(Stream, F, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
  finally
    Stream.Free;
    F.Free;
  end;
end;

procedure LoadMapDesc;
var
  Stream: TStream;
  F: TFileStream;
  FileName: String;
begin
  FileName := ResourceDir + g_sServerName + '\MapDesc.dat';
  if FileExists(FileName) then
  begin
    g_MapDesc.Clear;
    g_MapVer := '';
    try
      Stream := TMemoryStream.Create;
      F := TFileStream.Create(FileName, fmOpenRead);
      try
        uEDCode.DecodeStream(F, Stream, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
        Stream.Seek(0, soFromBeginning);
        NativeXmlObjectStorage.ObjectLoadFromXmlStream(g_MapDesc, Stream);
        g_MapVer := g_MapDesc.Ver;
      finally
        Stream.Free;
        F.Free;
      end;
    except
      g_MapVer := '';
    end;
  end;
end;

procedure SaveMapDesc;
var
  Stream: TStream;
  F: TFileStream;
  FileName: String;
begin
  if not DirectoryExists(ResourceDir + g_sServerName + '\') then
    CreateDir(ResourceDir + g_sServerName + '\');
  FileName := ResourceDir + g_sServerName + '\MapDesc.dat';
  if FileExists(FileName) then
    IOUtils.TFile.Delete(FileName);
  Stream := TMemoryStream.Create;
  F := TFileStream.Create(FileName, fmCreate);
  try
    g_MapDesc.Ver := g_MapVer;
    NativeXmlObjectStorage.ObjectSaveToXmlStream(g_MapDesc, Stream);
    uEDCode.EncodeStream(Stream, F, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
  finally
    Stream.Free;
    F.Free;
  end;
end;


procedure LoadSkillData();
var
  Stream: TStream;
  F: TFileStream;
  FileName: String;
begin
  FileName := ResourceDir + g_sServerName + '\SkillData.dat';
  if FileExists(FileName) then
  begin
    g_SkillData.Free;
    g_SkillData := TSkillManager.Create;
    try
      Stream := TMemoryStream.Create;
      F := TFileStream.Create(FileName, fmOpenRead);
      try
        uEDCode.DecodeStream(F, Stream, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
        Stream.Seek(0, soFromBeginning);
        NativeXmlObjectStorage.ObjectLoadFromXmlStream(g_SkillData, Stream);
        g_SkillDataVer := g_SkillData.Ver;
      finally
        Stream.Free;
        F.Free;
      end;
    except
      g_SkillDataVer := '';
    end;
  end;
end;

procedure SaveSkillData();
var
  Stream: TStream;
  F: TFileStream;
  FileName: String;
begin
  if not DirectoryExists(ResourceDir + g_sServerName + '\') then
    CreateDir(ResourceDir + g_sServerName + '\');
  FileName := ResourceDir + g_sServerName + '\SkillData.dat';
  if FileExists(FileName) then
    IOUtils.TFile.Delete(FileName);
  Stream := TMemoryStream.Create;
  F := TFileStream.Create(FileName, fmCreate);
  try
    NativeXmlObjectStorage.ObjectSaveToXmlStream(g_SkillData, Stream);
    uEDCode.EncodeStream(Stream, F, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
  finally
    Stream.Free;
    F.Free;
  end;
end;

procedure LoadSkillEffectData();
var
  Stream: TStream;
  F: TFileStream;
  FileName: String;
begin
  FileName := ResourceDir + g_sServerName + '\SkillEffectData.dat';
  if FileExists(FileName) then
  begin
    g_SkillEffectData.Free;
    g_SkillEffectData := TSkillEffectManager.Create;
    try
      Stream := TMemoryStream.Create;
      F := TFileStream.Create(FileName, fmOpenRead);
      try
        uEDCode.DecodeStream(F, Stream, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
        Stream.Seek(0, soFromBeginning);
        NativeXmlObjectStorage.ObjectLoadFromXmlStream(g_SkillEffectData, Stream);
        g_SkillEffectDataVer := g_SkillEffectData.Ver;
      finally
        Stream.Free;
        F.Free;
      end;
      InitSkillEffectData();
    except
      g_SkillEffectDataVer := '';
    end;
  end;
end;

procedure SaveSkillEffectData();
var
  Stream: TStream;
  F: TFileStream;
  FileName: String;
begin
  if not DirectoryExists(ResourceDir + g_sServerName + '\') then
    CreateDir(ResourceDir + g_sServerName + '\');
  FileName := ResourceDir + g_sServerName + '\SkillEffectData.dat';
  if FileExists(FileName) then
    IOUtils.TFile.Delete(FileName);
  Stream := TMemoryStream.Create;
  F := TFileStream.Create(FileName, fmCreate);
  try
    NativeXmlObjectStorage.ObjectSaveToXmlStream(g_SkillEffectData, Stream);
    uEDCode.EncodeStream(Stream, F, 'Ard8momjvAvv3OsDuwHmaG5Y4iKw6a8edlMJv6/JNSQWKDeaSVg0270N' + 'DkeQQXqgbDsIQII+uhqd5BvVWlOM2GvjlYwOPB+J7eyCiHQgsiU=');
  finally
    Stream.Free;
    F.Free;
  end;
end;

procedure InitSkillEffectData();
var
  Effect:TSkillEffectConfig;
  WMLib:TWMImages;
  I:Integer;
begin
  for i := 0 to g_SkillEffectData.Effects.Count - 1 do
  begin
    Effect := TSkillEffectConfig(g_SkillEffectData.Effects.Items[i]);
    if  LibManager.TryGetLib(Effect.FileName,WMLib) then
    begin
      Effect.Data := WMLib;
    end;
  end;
end;

procedure ClearShopItems;
var
  I: Integer;
begin
  if g_ShopItemList.Count > 0 then
    for I := 0 to g_ShopItemList.Count - 1 do
      if pTShopItem(g_ShopItemList[I]) <> nil then
        Dispose(pTShopItem(g_ShopItemList[I]));
  g_ShopItemList.Clear;
end;

procedure ClearShopSpeciallyItems;
var
  I: Integer;
begin
  for I := 0 to g_ShopSpeciallyItemList.Count - 1 do
  begin
    if pTBoxsInfo(g_ShopSpeciallyItemList.Items[I]) <> nil then
      Dispose(pTBoxsInfo(g_ShopSpeciallyItemList.Items[I]));
  end;
  g_ShopSpeciallyItemList.Clear;
end;

procedure DoInitialization;
begin
  UIWindowManager := TdxClientWindowManager.Create;
  g_FilterItemNameList := TObjectDictionary<String, TShowItem>.Create([doOwnsValues]);
  g_CurMapDesc := TuMapDescManager.Create;
  g_MyMarketGold := 0;
  g_MyMarketGameGold := 0;
  FillChar(g_MyMarket, SizeOf(g_MyMarket), #0);
  FillChar(g_WhoStall, SizeOf(g_WhoStall), #0);
  g_MarketNames := TStringList.Create;
  g_MarketPlays := TStringList.Create;
  g_ItemList := TList<pTStdItem>.Create;
  g_ItemEffList := TList<TItemSmallEffect>.Create;
  g_SuitList := TList<pTSuitItem>.Create;
  g_UIManager := TdxWindowManager.Create;
  g_MapDesc := TMapDesc.Create;
  g_ItemDesc := TStringList.Create;
  g_ItemTypeNames := TDictionary<Byte, String>.Create;
  g_ItemWay := TDictionary<Byte, String>.Create;
  g_ItemVer := '';
  g_SuitVer := '';
  g_UIVer := '';
  g_ItemTypeNamesVer := '';
  g_SighIconMethods := TStringList.Create;
  g_SighIconHints := TStringList.Create;
  g_Friends := TList.Create;
  g_Enemies := TList.Create;
  g_Mail := TMailManager.Create;
  g_MyNextBatterMagics := TList.Create;
  g_MyNextMagics := TList.Create;
  g_MyOpendMagics := TList.Create;
  g_Missions := TcMissions.Create;
  g_StallLogs := TStringList.Create;
  g_QueryStallLogs := TStringList.Create;

  g_Config := TConfig.Create;

  g_SocketBuffer := TuMemBuffer.Create(1024 * 1024);
end;

procedure ClearRelation;
var
  I: Integer;
begin
  for I := 0 to g_Friends.Count - 1 do
    Dispose(pTFriendRecord(g_Friends[I]));
  g_Friends.Clear;

  for I := 0 to g_Enemies.Count - 1 do
    Dispose(pTFriendRecord(g_Enemies[I]));
  g_Enemies.Clear;
end;

procedure ClearMissions;
begin
  g_Missions.ClearDogin;
  g_Missions.ClearUndo;
  g_MissionTopIndex := -1;
  g_SelectMission := -1;
  g_MissionListTopIndex := -1;
  g_MissionListSelected := -1;
  g_MissionListFocused := -1;
end;

procedure BuildItemEffect;
var
  I: Integer;
  AEffect: TdxItemEffect;
  ASmallEffect: TItemSmallEffect;
begin
  g_ItemEffList.Clear;
  for I := 0 to g_ItemList.Count - 1 do
  begin
    if UIWindowManager.ItemEffects.TryGetEffect(g_ItemList[I].CustomEff, AEffect) then
    begin
      if UIWindowManager.TryGetItemSmallEffect(AEffect.SmallEffect, ASmallEffect) then
        g_ItemEffList.Add(ASmallEffect)
      else
        g_ItemEffList.Add(nil);
    end
    else
      g_ItemEffList.Add(nil);
  end;
end;

function NameInFriends(const AName: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to g_Friends.Count - 1 do
    if SameText(AName, String(pTFriendRecord(g_Friends[I]).Name)) then
    begin
      Result := true;
      Exit;
    end;
end;

function NameInEnemies(const AName: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to g_Enemies.Count - 1 do
    if SameText(AName, String(pTFriendRecord(g_Enemies[I]).Name)) then
    begin
      Result := true;
      Exit;
    end;
end;

function NameAtFriends(const AName: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to g_Friends.Count - 1 do
    if SameText(AName, String(pTFriendRecord(g_Friends[I]).Name)) then
    begin
      Result := I;
      Exit;
    end;
end;

function NameAtEnemies(const AName: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to g_Enemies.Count - 1 do
    if SameText(AName, String(pTFriendRecord(g_Enemies[I]).Name)) then
    begin
      Result := I;
      Exit;
    end;
end;

procedure UpdateAddSoulExp(Value: Integer);
var
  I: Integer;
begin
  for I := Low(g_UseItems) to High(g_UseItems) do
  begin
    if (g_UseItems[I].Name <> '') and (g_UseItems[I].AddProperty.SoulLevel > 0) and (g_UseItems[I].AddProperty.SoulLevel - 1 < ClientConf.nMaxSoulLevel) then
    begin
      g_UseItems[I].SoulExp := g_UseItems[I].SoulExp + Value;
      if g_UseItems[I].SoulExp > g_UseItems[I].SoulMaxExp then
        g_UseItems[I].SoulExp := g_UseItems[I].SoulMaxExp;
    end;
  end;
end;

procedure ClearAutoRunPointList;
var
  I: Integer;
begin
  for I := 0 to g_uPointList.Count - 1 do
    Dispose(g_uPointList.Items[I]);
  g_uPointList.Clear;
end;

function RecalcMyTotalAbility: Int64;
begin
  Result := 0;
  if g_MySelf <> nil then
  begin
    SafeAddValue(Result, g_MySelf.m_Abil.ACMin * ClientConf.nMixedAbility[_TA_ACMIN] + g_MySelf.m_Abil.ACMax * ClientConf.nMixedAbility[_TA_ACMAX]);
    SafeAddValue(Result, g_MySelf.m_Abil.MACMin * ClientConf.nMixedAbility[_TA_MACMIN] + g_MySelf.m_Abil.MACMax * ClientConf.nMixedAbility[_TA_MACMAX]);
    SafeAddValue(Result, g_MySelf.m_Abil.DCMin * ClientConf.nMixedAbility[_TA_DCMIN] + g_MySelf.m_Abil.DCMax * ClientConf.nMixedAbility[_TA_DCMAX]);
    SafeAddValue(Result, g_MySelf.m_Abil.MCMin * ClientConf.nMixedAbility[_TA_MCMIN] + g_MySelf.m_Abil.MCMax * ClientConf.nMixedAbility[_TA_MCMAX]);
    SafeAddValue(Result, g_MySelf.m_Abil.SCMin * ClientConf.nMixedAbility[_TA_SCMIN] + g_MySelf.m_Abil.SCMax * ClientConf.nMixedAbility[_TA_SCMAX]);
    SafeAddValue(Result, g_MySelf.m_Abil.TCMin * ClientConf.nMixedAbility[_TA_TCMIN] + g_MySelf.m_Abil.TCMax * ClientConf.nMixedAbility[_TA_TCMAX]);
    SafeAddValue(Result, g_MySelf.m_Abil.PCMin * ClientConf.nMixedAbility[_TA_PCMIN] + g_MySelf.m_Abil.PCMax * ClientConf.nMixedAbility[_TA_PCMAX]);
    SafeAddValue(Result, g_MySelf.m_Abil.WCMin * ClientConf.nMixedAbility[_TA_WCMIN] + g_MySelf.m_Abil.WCMax * ClientConf.nMixedAbility[_TA_WCMAX]);
    SafeAddValue(Result, g_MySubAbility.Absorbing * ClientConf.nMixedAbility[_TA_Absorbing]);
    SafeAddValue(Result, g_MySubAbility.Rebound * ClientConf.nMixedAbility[_TA_Rebound]);
    SafeAddValue(Result, g_MySubAbility.AttackAdd * ClientConf.nMixedAbility[_TA_AttackAdd]);
    SafeAddValue(Result, g_MySubAbility.PunchHit * ClientConf.nMixedAbility[_TA_PunchHit]);
    SafeAddValue(Result, g_MySubAbility.CriticalHit * ClientConf.nMixedAbility[_TA_CriticalHit]);
    SafeAddValue(Result, g_MySubAbility.HealthRecover * ClientConf.nMixedAbility[_TA_HealthRecover]);
    SafeAddValue(Result, g_MySubAbility.SpellRecover * ClientConf.nMixedAbility[_TA_SpellRecover]);
    SafeAddValue(Result, g_MySelf.m_Abil.MaxHP * ClientConf.nMixedAbility[_TA_MaxHP]);
    SafeAddValue(Result, g_MySelf.m_Abil.MaxMP * ClientConf.nMixedAbility[_TA_MaxMP]);
    SafeAddValue(Result, g_MySubAbility.HitPoint * ClientConf.nMixedAbility[_TA_HitPoint]);
    SafeAddValue(Result, g_MySubAbility.SpeedPoint * ClientConf.nMixedAbility[_TA_SpeedPoint]);
    SafeAddValue(Result, g_MySubAbility.AntiMagic * ClientConf.nMixedAbility[_TA_AntiMagic]);
    SafeAddValue(Result, g_MySubAbility.AntiPoison * ClientConf.nMixedAbility[_TA_AntiPoison]);
    SafeAddValue(Result, g_MySubAbility.PoisonRecover * ClientConf.nMixedAbility[_TA_PoisonRecover]);
  end;
  if Result < 0 then
    Result := High(Int64);
end;

function RecalcTotalAbility(AUserStateInfo: TUserStateInfo): Int64;
begin
  Result := 0;
  SafeAddValue(Result, AUserStateInfo.m_Abil.ACMin * ClientConf.nMixedAbility[_TA_ACMIN] + AUserStateInfo.m_Abil.ACMax * ClientConf.nMixedAbility[_TA_ACMAX]);
  SafeAddValue(Result, AUserStateInfo.m_Abil.MACMin * ClientConf.nMixedAbility[_TA_MACMIN] + AUserStateInfo.m_Abil.MACMax * ClientConf.nMixedAbility[_TA_MACMAX]);
  SafeAddValue(Result, AUserStateInfo.m_Abil.DCMin * ClientConf.nMixedAbility[_TA_DCMIN] + AUserStateInfo.m_Abil.DCMax * ClientConf.nMixedAbility[_TA_DCMAX]);
  SafeAddValue(Result, AUserStateInfo.m_Abil.MCMin * ClientConf.nMixedAbility[_TA_MCMIN] + AUserStateInfo.m_Abil.MCMax * ClientConf.nMixedAbility[_TA_MCMAX]);
  SafeAddValue(Result, AUserStateInfo.m_Abil.SCMin * ClientConf.nMixedAbility[_TA_SCMIN] + AUserStateInfo.m_Abil.SCMax * ClientConf.nMixedAbility[_TA_SCMAX]);
  SafeAddValue(Result, AUserStateInfo.m_Abil.TCMin * ClientConf.nMixedAbility[_TA_TCMIN] + AUserStateInfo.m_Abil.TCMax * ClientConf.nMixedAbility[_TA_TCMAX]);
  SafeAddValue(Result, AUserStateInfo.m_Abil.PCMin * ClientConf.nMixedAbility[_TA_PCMIN] + AUserStateInfo.m_Abil.PCMax * ClientConf.nMixedAbility[_TA_PCMAX]);
  SafeAddValue(Result, AUserStateInfo.m_Abil.WCMin * ClientConf.nMixedAbility[_TA_WCMIN] + AUserStateInfo.m_Abil.WCMax * ClientConf.nMixedAbility[_TA_WCMAX]);
  SafeAddValue(Result, AUserStateInfo.m_SubAbility.Absorbing * ClientConf.nMixedAbility[_TA_Absorbing]);
  SafeAddValue(Result, AUserStateInfo.m_SubAbility.Rebound * ClientConf.nMixedAbility[_TA_Rebound]);
  SafeAddValue(Result, AUserStateInfo.m_SubAbility.AttackAdd * ClientConf.nMixedAbility[_TA_AttackAdd]);
  SafeAddValue(Result, AUserStateInfo.m_SubAbility.PunchHit * ClientConf.nMixedAbility[_TA_PunchHit]);
  SafeAddValue(Result, AUserStateInfo.m_SubAbility.CriticalHit * ClientConf.nMixedAbility[_TA_CriticalHit]);
  SafeAddValue(Result, AUserStateInfo.m_SubAbility.HealthRecover * ClientConf.nMixedAbility[_TA_HealthRecover]);
  SafeAddValue(Result, AUserStateInfo.m_SubAbility.SpellRecover * ClientConf.nMixedAbility[_TA_SpellRecover]);
  SafeAddValue(Result, AUserStateInfo.m_Abil.MaxHP * ClientConf.nMixedAbility[_TA_MaxHP]);
  SafeAddValue(Result, AUserStateInfo.m_Abil.MaxMP * ClientConf.nMixedAbility[_TA_MaxMP]);
  SafeAddValue(Result, AUserStateInfo.m_SubAbility.HitPoint * ClientConf.nMixedAbility[_TA_HitPoint]);
  SafeAddValue(Result, AUserStateInfo.m_SubAbility.SpeedPoint * ClientConf.nMixedAbility[_TA_SpeedPoint]);
  SafeAddValue(Result, AUserStateInfo.m_SubAbility.AntiMagic * ClientConf.nMixedAbility[_TA_AntiMagic]);
  SafeAddValue(Result, AUserStateInfo.m_SubAbility.AntiPoison * ClientConf.nMixedAbility[_TA_AntiPoison]);
  SafeAddValue(Result, AUserStateInfo.m_SubAbility.PoisonRecover * ClientConf.nMixedAbility[_TA_PoisonRecover]);
  if Result < 0 then
    Result := High(Int64);
end;

function GetHumOffset(AJob: Byte; ADress: Word): Integer;
begin
  Result := 0;
  case ADress of
    RES_IMG_BASE..RES_IMG_MAX: Result := 0;
    else
    begin
      case AJob of
        _JOB_WAR.._JOB_DAO: Result := HUMANFRAME * ADress;
        _JOB_SHAMAN: Result := 728 * ADress;
        _JOB_ARCHER: Result := HUMANFRAME * ADress;
        _JOB_CIK: Result := 888 * ADress;
        else
          Result := HUMANFRAME * ADress;
      end;
    end;
  end;
end;

function GetHumWinOffset(AJob: Byte; ADress: Word): Integer;
begin
  Result := 0;
  case AJob of
    _JOB_WAR.._JOB_DAO: Result := HUMANFRAME * (ADress - 1);
    _JOB_SHAMAN: Result := 728 * (ADress - 1);
    _JOB_ARCHER: Result := HUMANFRAME * (ADress - 1);
    _JOB_CIK: Result := 888 * (ADress - 1);
    else
      Result := HUMANFRAME * (ADress - 1);
  end;
end;

function GetNpcOffset(nAppr: Integer): Integer;
begin
  Result := 0;
  if IsCustomAppr(nAppr) and (g_CustomNPCAction[nAppr] <> nil) then
  begin
    Result := g_CustomNPCAction[nAppr].StartOffset;
  end else
  begin
    case nAppr of
      0 .. 22:
        Result := nAppr * 60;
      23:
        Result := 1380;
      24, 25:
        Result := (nAppr - 24) * 60 + 1470;
      27, 32:
        Result := (nAppr - 26) * 60 + 1620 - 30;
      26, 28 .. 31, 33 .. 41:
        Result := (nAppr - 26) * 60 + 1620;
      42, 43:
        Result := 2580;
      44 .. 47:
        Result := 2640;
      48 .. 50:
        Result := (nAppr - 48) * 60 + 2700;
      51:
        Result := 2880;
      52:
        Result := 2960; // 雪人
      53:
        Result := 3040;
      54:
        Result := 3060;
      55:
        Result := 3120;
      56:
        Result := 3180;
      57:
        Result := 3240;
      58:
        Result := 3300;
      59:
        Result := 3360;
      60:
        Result := 3420;
      61:
        Result := 3480;
      62:
        Result := 3600;
      63:
        Result := 3750;
      64:
        Result := 3780;
      65:
        Result := 3790;
      66:
        Result := 3800;
      67:
        Result := 3810;
      68:
        Result := 3820;
      69:
        Result := 3830;
      70:
        Result := 3840;
      71:
        Result := 3900;
      72:
        Result := 3960;
      73:
        Result := 3980;
      74:
        Result := 4000;
      75:
        Result := 4030;
      76:
        Result := 4060;
      77:
        Result := 4120;
      78:
        Result := 4180;
      79:
        Result := 4240;
      80:
        Result := 4250;
      81:
        Result := 4490;
      82:
        Result := 4500;
      83:
        Result := 4510;
      84:
        Result := 4520;
      85:
        Result := 4530;
      86:
        Result := 4540;
      87:
        Result := 4560;
      88:
        Result := 4600;
      89:
        Result := 4630;
      90:
        Result := 4690;
      91:
        Result := 4770;
      92:
        Result := 4810;
      93: Result := 4850;
      94: Result := 4860;
      95: Result := 4861;

      // npc2.wzl
      100 .. 109:
        Result := (nAppr - 100) * 70;
      110:
        Result := 700;
      111:
        Result := 740;
      112 .. 117:
        Result := 810 + (nAppr - 112) * 10;
      118:
        Result := 870;
      119:
        Result := 900;
      120:
        Result := 930;
      121:
        Result := 970;
      122:
        Result := 980;
      123:
        Result := 990;
      124:
        Result := 1020;
      125:
        Result := 1030;
      126:
        Result := 1060;
      127: Result := 1061;
      128: Result := 1062;
      129: Result := 1070;
      130: Result := 1071;
      else
        Result := (nAppr mod 100) * 60;
    end;
  end;
end;

function GetOffsetEx(btUnit, btIndex: Byte): Integer; inline;
begin
  Result := 0;
  case btUnit of
    0:
      Result := btIndex * 280;
    1:
      Result := btIndex * 230;
    2, 3, 7 .. 12:
      Result := btIndex * 360;
    4:
      begin
        Result := btIndex * 360; //
        if btIndex = 1 then
          Result := 600;
      end;
    5:
      Result := btIndex * 430; //
    6:
      Result := btIndex * 440; //
    13:
      case btIndex of
        0:
          Result := 0;
        1:
          Result := 360;
        2:
          Result := 440;
        3:
          Result := 550;
      else
        Result := btIndex * 360;
      end;
    14:
      Result := btIndex * 360;
    15:
      Result := btIndex * 360;
    16:
      Result := btIndex * 360;
    17:
      case btIndex of
        2:
          Result := 920;
        3:
          Result := 1280;
      else
        Result := btIndex * 350;
      end;
    18:
      case btIndex of
        0:
          Result := 0;
        1:
          Result := 520;
        2:
          Result := 950;
        3:
          Result := 1574;
        4:
          Result := 1934;
        5:
          Result := 2294;
        6:
          Result := 2654;
        7:
          Result := 3014;
      end;
    19:
      case btIndex of     //mon20.wil
        0:
          Result := 0; // 己巩
        1:
          Result := 370;
        2:
          Result := 810;
        3:
          Result := 1250;
        4:
          Result := 1630;
        5:
          Result := 2010;
        6:
          Result := 2390;
      end;
    20:                 //mon21.wil
      case btIndex of
        0:
          Result := 0; // 己巩
        1:
          Result := 360;
        2:
          Result := 720;
        3:
          Result := 1080;
        4:
          Result := 1440;
        5:
          Result := 1800;
        6:
          Result := 2350;
        7:
          Result := 3060;
      end;
    21:         //mon22.wil
      case btIndex of
        0:
          Result := 0; // 己巩
        1:
          Result := 460;
        2:
          Result := 820;
        3:
          Result := 1180;
        4:
          Result := 1540;
        5:
          Result := 1900;
        6:
          Result := 2440;
        7:
          Result := 2570;
        8:
          Result := 2700;
      end;
    22:               //mon23.wil
      case btIndex of
        0:
          Result := 0;
        1:
          Result := 430;
        2:
          Result := 1290;
        3:
          Result := 1810;
      end;
    23:              //mon24.wil
      case btIndex of
        0:
          Result := 0;
        1:
          Result := 340;
        2:
          Result := 680;
        3:
          Result := 1180;
        4:
          Result := 1770;
        5:
          Result := 2610;
        6:
          Result := 2950;
        7:
          Result := 3290;
        8:
          Result := 3750;
        9:
          Result := 4100;
        10:
          Result := 4460;
        11:
          Result := 4810;
      end;
    24:            //mon25.wil
      case btIndex of
        0:
          Result := 0;
        1:
          Result := 510;
        2:
          Result := 1020;
        3:
          Result := 1090;
      end;
    25:          //mon26.wil
      case btIndex of
        0:
          Result := 0;
        1:
          Result := 510;
        2:
          Result := 1020;
        3:
          Result := 1370;
        4:
          Result := 1720;
        5:
          Result := 2070;
        6:
          Result := 2740;
        7:
          Result := 3780;
        8:
          Result := 3820;
        9:
          Result := 4170;
      end;
    26:        //mon27.wil
      case btIndex of
        0:
          Result := 0;
        1:
          Result := 340;
        2:
          Result := 680;
        3:
          Result := 1190;
        4:
          Result := 1930;
        5:
          Result := 2100;
        6:
          Result := 2440;
        7:
          Result := 2540;
        8:
          Result := 3040;
        9:
          Result := 3570;
      end;
    27:        //mon28.wil
      case btIndex of
        0:
          Result := 0;
        1:
          Result := 350; // 1020
        2:
          Result := 780; // 1020
        3:
          Result := 1130;
        4:
          Result := 1560;
        5:
          Result := 1910;
      end;
    28:         //mon29.wil
      case btIndex of
        0:
          Result := 0;
        1:
          Result := 600;
      end;
    29:     //mon30.wil
      case btIndex of
        0:
          Result := 0;
        1:
          Result := 360; // 1020
        2:
          Result := 720;
      end;
    30:    //mon31.wil
      case btIndex of // 归来版
        0:
          Result := 0;
        1:
          Result := 360;
        2:
          Result := 720;
        3:
          Result := 1080;
        4:
          Result := 1440;
        5:
          Result := 1790;
        6:
          Result := 2290;
        7:
          Result := 2390;
      end;
    31:     //mon32.wil
      case btIndex of // 国际版
        0:
          Result := 0;
        1:
          Result := 170;
        2:
          Result := 610;
        3:
          Result := 1050;
        4:
          Result := 1420;
        5:
          Result := 1860;
        6:
          Result := 2230;
        7:
          Result := 2670;
        8:
          Result := 3190;
        9:
          Result := 3710;
        10:
          Result := 4391;
        11:
          Result := 4751;
        12:
          Result := 5271;
        13:
          Result := 5871;
        14:
          Result := 6681;
      end;
    32:      //mon33.wil
      case btIndex of
        0: Result := 0;
        1: Result := 440;
        2: Result := 820;
        3: Result := 1360;
        4: Result := 2590;
        5: Result := 2680;
        6: Result := 2790;
        7: Result := 2900;
        8: Result := 3500;
        9: Result := 3930;
       10: Result := 4370;
       11: Result := 4440;
      end;
    33:      //mon34.wil
      case btIndex of
        0:
          Result := 4;
        1:
          Result := 720;
        2:
          Result := 1160;
        3:
          Result := 1170; // 城墙不用做
        4:
          Result := 1824;
        5:
          Result := 2540;
        6:
          Result := 2900;
      end;
    34:      //mon35.wil
      case btIndex of
        0:
          Result := 0;
        1:
          Result := 680;
        2:
          Result := 1030;
      end;
    // 35,36,37: Mon36
    35:     //mon36.wil
      case btIndex of
        0:
          Result := 0;
        1:
          Result := 810;
        2:
          Result := 1800;
        3:
          Result := 2610;
        4:
          Result := 3420;
        5:
          Result := 4390;
        6:
          Result := 5200;
        7:
          Result := 6170;
        8:
          Result := 6980;
        9:
          Result := 7790;
        10:
          Result := 8760;
        11:
          Result := 9570;
        12:
          Result := 10380;
        13:
          Result := 11030;
        14:
          Result := 12000;
        15:
          Result := 13800;
        16:
          Result := 14770;
        17:
          Result := 15580;
        18:
          Result := 16390;
        19:
          Result := 17360;
        20:
          Result := 18330;
        21:
          Result := 19300;
        22:
          Result := 20270;
        23:
          Result := 21240;
        24:
          Result := 22050;
        25:
          Result := 22860;
        26:
          Result := 23990;
        27:
          Result := 24800;
        28:
          Result := 25930;
      end;
    36:  //mon37.wil
      case btIndex of
        0:
          Result := 0;
        1:
          Result := 400;
        2:
          Result := 960;
        3:
          Result := 1440;
        4:
          Result := 1840;
        5:
          Result := 2240;
        6:
          Result := 2840;
      end;
    37:    //mon38.wil
      case btIndex of
        0:
          Result := 170;
        1:
          Result := 610;
        2:
          Result := 1050;
        3:
          Result := 1420;
        4:
          Result := 1860;
        5:
          Result := 2230;
        6:
          Result := 2670;
        7:
          Result := 3190;
        8:
          Result := 3710;
        9:
          Result := 4390;
        10:
          Result := 4750;
        11:
          Result := 5270;
        12:
          Result := 5870;
        13:
          Result := 6680;
      end;
    38:   //mon39.wil
      case btIndex of
        0:
          Result := 0;
        1:
          Result := 752;
        2:
          Result := 1504;
        3:
          Result := 2256;
        4:
          Result := 3008;
      end;
    39:     //mon40.wil
      case btIndex of
        0:
          Result := 0;
        1:
          Result := 488;
        2:
          Result := 1272;
        3:
          Result := 2056;
        4:
          Result := 2328;
        5:
          Result := 3208;
        6:
          Result := 3584;
        7:
          Result := 3872;
      end;
    40:      //mon41.wil
      case btIndex of
        0:
          Result := 16;
      end;

    49, 50, 51, 52, 53:
      Result := btIndex * 360;
    80:
      case btIndex of
        0:
          Result := 0; // 己巩
        1:
          Result := 80;
        2:
          Result := 300;
        3:
          Result := 301;
        4:
          Result := 302;
        5:
          Result := 320;
        6:
          Result := 321;
        7:
          Result := 322;
        8:
          Result := 321;
      end;
    90:
      case btIndex of
        0: Result := 80; // 己巩
        1: Result := 168;
        2: Result := 184;
        3: Result := 200;
        4: Result := 1770;
        5: Result := 1790;
        6: Result := 1780;
      end;
    99:
      case btIndex of
        0:
          Result := 0;
        1:
          Result := 360;
        2:
          Result := 720;
      end;
  end;
end;

// 根据种族和外貌确定在图片库中的开始位置
function GetOffset(Appr: Integer): Integer;
begin
  Result := 0;
  if IsCustomAppr(Appr) and (g_CustomMonsterAction[Appr] <> nil) then
  begin
    Result := g_CustomMonsterAction[Appr].StartOffset;
  end else
  begin
    case Appr of
      0..999: Result := GetOffsetEx(Appr div 10, Appr mod 10);
      1000..9999: Result := GetOffsetEx(Appr div 100, Appr mod 100);
      RES_IMG_BASE..RES_IMG_MAX: Result := 0;
    end;
  end;
end;

function GetShadowOffsetEx(btUnit, btIndex: Byte): Integer; inline;
begin
  Result := 0;
  case btUnit of
    35:
      case btIndex of
        0:
          Result := 400;
        1:
          Result := 1290;
        2:
          Result := 2200;
        3:
          Result := 3010;
        4:
          Result := 3900;
        5:
          Result := 4790;
        6:
          Result := 5680;
        7:
          Result := 6570;
        8:
          Result := 7380;
        9:
          Result := 8270;
      end;
    36:
      case btIndex of
        0:
          Result := 9160;
        1:
          Result := 9970;
        2:
          Result := 10700;
        3:
          Result := 11510;
        4:
          Result := 12400;
        5:
          Result := 14280;
        6:
          Result := 15170;
        7:
          Result := 15980;
        8:
          Result := 16870;
        9:
          Result := 17840;
      end;
    37:
      case btIndex of
        0:
          Result := 18810;
        1:
          Result := 19780;
        2:
          Result := 20750;
        3:
          Result := 21640;
        4:
          Result := 22450;
        5:
          Result := 23420;
        6:
          Result := 24390;
        7:
          Result := 25360;
        8:
          Result := 26330;
      end;
    38:
      case btIndex of
        6:
          Result := 3320;
      end;
  end;
end;

function GetShadowOffset(Appr: Integer): Integer;
begin
  Result := 0;
  if (Appr >= 1000) then
  begin
    Result := GetShadowOffsetEx(HiByte(Appr), LoByte(Appr));
  end
  else
  begin
    Result := GetShadowOffsetEx(Appr div 10, Appr mod 10);
  end;
end;

procedure DoFinalization;
var
  I: Integer;
begin
  UIWindowManager.Free;
  FreeAndNilEx(g_FilterItemNameList);
  FreeAndNilEx(g_CurMapDesc);
  FreeAndNilEx(g_MarketNames);
  FreeAndNilEx(g_MarketPlays);
  Finalize(g_MyMarket);
  Finalize(g_WhoStall);
  ClearItems;
  FreeAndNilEx(g_ItemList);
  FreeAndNilEx(g_ItemEffList);
  FreeAndNilEx(g_ItemDesc);
  FreeAndNilEx(g_ItemTypeNames);
  FreeAndNilEx(g_ItemWay);
  ClearSuitItems;
  FreeAndNilEx(g_SuitList);
  FreeAndNilEx(g_UIManager);
  FreeAndNilEx(g_MapDesc);
  FreeAndNilEx(g_SighIconMethods);
  FreeAndNilEx(g_SighIconHints);
  ClearRelation;
  FreeAndNilEx(g_Friends);
  FreeAndNilEx(g_Enemies);
  FreeAndNilEx(g_Mail);
  FreeAndNilEx(g_MyNextBatterMagics);
  FreeAndNilEx(g_MyNextMagics);
  FreeAndNilEx(g_MyOpendMagics);
  FreeAndNilEx(g_Missions);
  FreeAndNilEx(g_StallLogs);
  FreeAndNilEx(g_QueryStallLogs);
  FreeAndNilEx(g_Config);
  FreeAndNilEx(g_SocketBuffer);
  FreeAndNilEx(g_CustomActorAction);
end;

{ TStdItemHelper }

function TStdItemHelper.DisplayName: String;
begin
  Result := Name;
  if StdMode in [5, 6, 8, 9, 10, 11, 15 .. 24, 26 .. 28, 30] then
  begin
    Result := StrUtils.ReverseString(Result);
    while (Length(Result) > 0) and (Result[1] in ['0' .. '9']) do
    begin
      Delete(Result, 1, 1);
      if (Length(Result) > 0) and (Result[1] = '+') then
      begin
        Result := Name;
        Exit;
      end;
    end;
    Result := StrUtils.ReverseString(Result);
  end;
end;

function TStdItemHelper.sDesc: String;
begin
  Result := '';
  if (Index >= 0) and (Index < g_ItemDesc.Count) then
    Result := g_ItemDesc.Strings[Index];
end;

{ TClientItemHelper }

function TClientItemHelper.AniCount: Word;
begin
  Result := Self.wAniCount;
  if Result = 0 then
  begin
    Result :=  S.AniCount;
  end;
end;

function TClientItemHelper.Bind: Boolean;
begin
  Result := State.Bind;
end;

function TClientItemHelper.TotalAbility: Int64;
var
  I: Integer;
  AItem: pTStdItem;
begin
  Result := -1;
  if IsEquipItem(S) then
  begin
    GetStdItemTotalAbility(S, Self.AddValue, ClientConf.nMixedAbility, Result);
    GetAddPointTotalAbility(Self.AddPoint, ClientConf.nMixedAbility, Result);
    GetAddLevelTotalAbility(Self.AddLevel, ClientConf.nMixedAbility, Result);
    for I := 0 to 2 do
      if (AddHold[I] > 0) and (AddHold[I] < g_ItemList.Count) then
      begin
        AItem := g_ItemList.Items[AddHold[I]];
        if AItem <> nil then
          GetAddHoleTotalAbility(AItem^, ClientConf.nMixedAbility, Result);
      end;
  end;
end;

function TClientItemHelper.S: TStdItem;
begin
  Result.StdMode := 255;
  Result.Name := '';
  if (Index >= 0) and (Index < g_ItemList.Count) then
  begin
    Move(g_ItemList[Index]^, Result, SizeOf(TStdItem));
  end;
end;

function TClientItemHelper.DisplayName: String;
begin
  if S.StdMode = 32 then
    Result := S.Name
  else
  begin
    Result := Name;
    if not Self.AddProperty.CustomName and (S.StdMode in [5, 6, 8, 9, 10, 11, 15 .. 24, 26 .. 28, 30]) then
      Result := S.DisplayName;
  end;
end;

function TClientItemHelper.Looks: Integer;
begin
  Result := Self.wLook;

  if Result = 0 then
  begin
    Result := S.Looks;
  end;

end;

{ TShopItemHelper }

function TShopItemHelper.TotalAbility: Int64;
begin
  Result := 0;
  GetStdItemTotalAbility(StdItem, Self.AddValue, ClientConf.nMixedAbility, Result);
  GetAddPointTotalAbility(Self.AddPoint, ClientConf.nMixedAbility, Result);
end;

function TShopItemHelper.StdItem: TStdItem;
begin
  Result.Name := '';
  if (Index > 0) and (Index <= g_ItemList.Count) then
    Result := g_ItemList.Items[Index]^;
end;

{ TMailItem }

constructor TMailItem.Create;
begin
  Index := 0;
  AFrom := '';
  Subject := '';
  Content := '';
  Item1.Name := '';
  Item2.Name := '';
  Item3.Name := '';
  Item4.Name := '';
  Item5.Name := '';
  _Date := '';
  _ShortDate := '';
  State := 0;
end;

{ TMailManager }

procedure TMailManager.Clear;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    TMailItem(Items[I]).Free;
  FSelIndex := -1;
  inherited;
end;

constructor TMailManager.Create;
begin
  inherited;
  TopIndex := 0;
  SelIndex := 0;
end;

procedure TMailManager.DeleteByMainIndex(const AIndex: Integer);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if TMailItem(Items[I]).Index = AIndex then
    begin
      TMailItem(Items[I]).Free;
      Delete(I);
      if I > 0 then
        SelIndex := I - 1
      else if Count > 0 then
        SelIndex := 0;
      Break;
    end;
end;

procedure TMailManager.SetSelIndex(const Value: Integer);
begin
  FSelIndex := Value;
  FSelected := nil;
  if (Count > 0) and (FSelIndex >= 0) and (FSelIndex < Count) then
    FSelected := TMailItem(Items[FSelIndex]);
end;

function TMailManager.TryGet(Index: Integer; out AMailItem: TMailItem): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
  begin
    if TMailItem(Items[I]).Index = Index then
    begin
      Result := true;
      AMailItem := TMailItem(Items[I]);
      Exit;
    end;
  end;
end;

procedure TMailManager.UpdateState(Index, State: Integer);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    if TMailItem(Items[I]).Index = Index then
    begin
      TMailItem(Items[I]).State := State;
      if State = 2 then
      begin
        TMailItem(Items[I]).Item1.Name := '';
        TMailItem(Items[I]).Item2.Name := '';
        TMailItem(Items[I]).Item3.Name := '';
        TMailItem(Items[I]).Item4.Name := '';
        TMailItem(Items[I]).Item5.Name := '';
        TMailItem(Items[I]).GoldStr := '';
        TMailItem(Items[I]).PriceStr := '';
        TMailItem(Items[I]).Attachment := 0;
      end;
      Exit;
    end;
  end;
end;

{ TcMissions }

constructor TcMissions.Create;
begin
  FDoing := TList.Create;
  FUndo := TList.Create;
end;

destructor TcMissions.Destroy;
begin
  ClearDogin;
  ClearUndo;
  FreeAndNilEx(FDoing);
  FreeAndNilEx(FUndo);
  inherited;
end;

procedure TcMissions.AddDoing(AKind: TMissonKind; const ARecordID, AMissionID, ASubject, AContent: String;
  ANeedMax, ANeedProgress, ATargetNPC: Integer; AState: TMissionState);
var
  AMissionItem: TMissionItem;
begin
  AMissionItem := TMissionItem.Create;
  AMissionItem.Kind := AKind;
  AMissionItem.RecordID := ARecordID;
  AMissionItem.MissionID := AMissionID;
  AMissionItem.State := AState;
  AMissionItem.NeedProgress := ANeedProgress;
  AMissionItem.NeedMax := ANeedMax;
  AMissionItem.TargetNPC := ATargetNPC;
  AMissionItem.Subject := ASubject;
  AMissionItem.Content := AContent;
  FDoing.Add(AMissionItem);
end;

procedure TcMissions.AddUndo(AKind: TMissonKind; const AMissionID, ASubject, AContent: String; ATargetNPC, ALevel, AReLevel: Integer);
var
  ALinkItem: TMissionLinkItem;
begin
  ALinkItem := TMissionLinkItem.Create;
  ALinkItem.Kind := AKind;
  ALinkItem.MissionID := AMissionID;
  ALinkItem.Subject := ASubject;
  ALinkItem.Content := AContent;
  ALinkItem.TargetNPC := ATargetNPC;
  ALinkItem.Level := ALevel;
  ALinkItem.ReLevel := AReLevel;
  FUndo.Add(ALinkItem);
end;

procedure TcMissions.DeleteDoing(AIndex: Integer);
begin
  FDoing.Delete(AIndex);
end;

procedure TcMissions.DeleteUndo(AIndex: Integer);
begin
  FUndo.Delete(AIndex);
end;

procedure TcMissions.ClearDogin;
var
  I: Integer;
begin
  for I := 0 to FDoing.Count - 1 do
    TObject(FDoing[I]).Free;
  FDoing.Clear;
end;

procedure TcMissions.ClearUndo;
var
  I: Integer;
begin
  for I := 0 to FUndo.Count - 1 do
    TObject(FUndo[I]).Free;
  FUndo.Clear;
end;

function TcMissions.GetDoing(index: Integer): TMissionItem;
begin
  Result := TMissionItem(FDoing[index]);
end;

function TcMissions.GetDoingCount: Integer;
begin
  Result := FDoing.Count;
end;

function TcMissions.GetUnDo(index: Integer): TMissionLinkItem;
begin
  Result := TMissionLinkItem(FUndo[index]);
end;

function TcMissions.GetUnDoCount: Integer;
begin
  Result := FUndo.Count;
end;

procedure DrawMerchantMessageBackground(X, Y: Integer; AMerchantMessage: TuMerchantMessage);
var
  d: TAsphyreLockableTexture;
  nW, nH: Integer;
begin
  d := g_77Images.Images[44];
  if (d = nil) or (d.Width * d.Height < 10) then
  begin
    Exit;
  end
  else
  begin
    g_GameCanvas.Draw(X, Y, g_77Images.Images[44]);
    d := g_77Images.Images[46];
    if d <> nil then
      g_GameCanvas.Draw(X + AMerchantMessage.Width - d.Width, Y, d);
    d := g_77Images.Images[49];
    if d <> nil then
      g_GameCanvas.Draw(X, Y + AMerchantMessage.Height - d.Height, d);
    d := g_77Images.Images[51];
    if d <> nil then
      g_GameCanvas.Draw(X + AMerchantMessage.Width - d.Width, Y + AMerchantMessage.Height - d.Height, d);

    nW := AMerchantMessage.Width - AMerchantMessage.OffSetXY * 2;
    nH := AMerchantMessage.Height - AMerchantMessage.OffSetXY * 2;
    if nW > 0 then
    begin
      g_GameCanvas.HorFillDraw(X + AMerchantMessage.OffSetXY, X + AMerchantMessage.OffSetXY + nW, Y, g_77Images.Images[45]);
      d := g_77Images.Images[50];
      if d <> nil then
        g_GameCanvas.HorFillDraw(X + AMerchantMessage.OffSetXY, X + AMerchantMessage.OffSetXY + nW, Y + AMerchantMessage.Height - d.Height, d);
    end;

    if nH > 0 then
    begin
      d := g_77Images.Images[47];
      if d <> nil then
        g_GameCanvas.VerFillDraw(X, Y + AMerchantMessage.OffSetXY, Y + AMerchantMessage.Height - d.Height, d);
      d := g_77Images.Images[48];
      if d <> nil then
        g_GameCanvas.VerFillDraw(X + AMerchantMessage.Width - d.Width, Y + AMerchantMessage.OffSetXY, Y + AMerchantMessage.Height - d.Height, d);
    end;
  end;
end;

procedure MerchantMessageGetItemImages(ANode: TMessageNode);
begin
  if (ANode.Item.Name = 'DEBUG') and (_DebguDIB <> nil) then
  begin
    ANode.Image := g_WBagItemImages;
    ANode.ImageIndex := 0;
  end
  else
  begin
    if ANode.Item.S.Looks < 10000 then
    begin
      ANode.Image := g_WBagItemImages;
      ANode.ImageIndex := ANode.Item.S.Looks;
    end
    else
    begin
      ANode.Image := g_77WBagItemImages;
      ANode.ImageIndex := ANode.Item.S.Looks - 10000;
    end;
  end;
end;

function ContainMagic(AMagicID: Integer): Boolean;
var
  AMagic: PTClientMagic;
begin
  Result := TryGetMagic(AMagicID, AMagic);
end;

function TryGetMagic(AMagicID: Integer; var AMagic: PTClientMagic): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to g_MagicList.Count - 1 do
  begin
    if PTClientMagic(g_MagicList[I]).wMagicId = AMagicID then
    begin
      Result := True;
      AMagic := g_MagicList[I];
      Break;
    end;
  end;
end;

procedure DeleteMagic(AMagicID: Integer);
var
  I: Integer;
begin
  for I := g_MyNextMagics.Count - 1 downto 0 do
  begin
    if PTClientMagic(g_MyNextMagics[I]).wMagicId = AMagicID then
      g_MyNextMagics.Delete(I);
  end;
  for I := g_MyOpendMagics.Count - 1 downto 0 do
  begin
    if PTClientMagic(g_MyOpendMagics[I]).wMagicId = AMagicID then
      g_MyOpendMagics.Delete(I);
  end;
end;

procedure AddNextBatterMagic(AMagicID: Integer);
var
  I: Integer;
  AMagic: PTClientMagic;
begin
  if TryGetMagic(AMagicID, AMagic) then
  begin
    //Delete
    for I := g_MyNextBatterMagics.Count - 1 downto 0 do
    begin
      if PTClientMagic(g_MyNextBatterMagics[I]).wMagicId = AMagicID then
      begin
        g_MyNextBatterMagics.Delete(I);
        Break;
      end;
    end;
    //Add
    g_MyNextBatterMagics.Insert(0, AMagic);
  end;
end;

procedure AddNextMagic(AMagicID, ATag: Integer);
var
  I: Integer;
  AMagic: PTClientMagic;
begin
  if TryGetMagic(AMagicID, AMagic) then
  begin
    //Delete
    for I := g_MyNextMagics.Count - 1 downto 0 do
    begin
      if PTClientMagic(g_MyNextMagics[I]).wMagicId = AMagicID then
      begin
        g_MyNextMagics.Delete(I);
        Break;
      end;
    end;
    //Add
    AMagic.Tag := ATag;
    g_MyNextMagics.Insert(0, AMagic);
  end;
end;


procedure ClearNextMagic(); //清空所有下一次攻击的技能
begin
  g_MyNextMagics.Clear;
end;

procedure AddOpendMagic(AMagicID: Integer);
var
  AMagic: PTClientMagic;
begin
  if TryGetMagic(AMagicID, AMagic) then
  begin
    g_MyOpendMagics.Add(AMagic);
    g_MyOpendMagics.SortList(
      function (Item1, Item2: Pointer): Integer
      begin
        Result := PTClientMagic(Item1).btPriority - PTClientMagic(Item2).btPriority;
      end
    );
  end;
end;

function GetSpellPoint(AMagic: PTClientMagic): Integer;
begin
  Result := 0;
  if AMagic <> nil then
    Result := Round(AMagic.wSpell / (AMagic.btTrainLv + 1) * (AMagic.Level + 1)) + AMagic.btDefSpell;
end;

function TryGetNextBatterMagic(ARange: Integer; var AMagic: PTClientMagic): Boolean;
var
  I, ASpellPoint: Integer;
begin
  AMagic := nil;
  Result := False;
  for I := 0 to g_MyNextBatterMagics.Count - 1 do
  begin
    ASpellPoint := GetSpellPoint(g_MyNextBatterMagics[I]);
    if (g_MySelf.m_Abil.MP >= ASpellPoint) and (PTClientMagic(g_MyNextBatterMagics[I]).btMaxRange >= ARange) then
    begin
      Result := True;
      AMagic := g_MyNextBatterMagics[I];
      Break;
    end;
  end;
end;

function TryGetNextMagic(ARange: Integer; var AMagic: PTClientMagic): Boolean;
var
  I, ASpellPoint: Integer;
begin
  AMagic := nil;
  Result := False;
  for I := 0 to g_MyNextMagics.Count - 1 do
  begin
   //砍下去的时候不需要计算蓝 随云
     //ASpellPoint := GetSpellPoint(g_MyNextMagics[I]);
    if {(g_MySelf.m_Abil.MP >= ASpellPoint) and } (PTClientMagic(g_MyNextMagics.Items[I]).btMaxRange >= ARange) then
    begin
      Result := True;
      AMagic := g_MyNextMagics[I];
      Break;
    end;
  end;
end;

function FindMagic(MagicIds:Array of Integer):PTClientMagic;
var I :integer;
begin
  Result := nil;
  for I := Low(MagicIds) to High(MagicIds) do
  begin
    if TryGetMagic(MagicIds[i],Result) then
    break;
  end;
end;

function TryGetOpendMagic(ARange: Integer; AShift: TShiftState; var AMagic: PTClientMagic): Boolean;

var
  I, ADir, ASpellPoint: Integer;
  AClient: TuMagicClient;
  _Magic: PTClientMagic;
  AHandled: Boolean;
  nSelfX,nSelfY:Integer;
  btDir:Byte;
label
  EndGet;
begin
  AMagic := nil;
  Result := False;
  if g_MySelf = nil then
    exit;


  if g_TargetCret <> nil then
    ADir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_TargetCret.m_nCurrX, g_TargetCret.m_nCurrY)
  else
    ADir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nTargetX, g_nTargetY);

//    //按住了Shift一定出刺杀
//  if (ssShift in AShift) and (ssLeft in AShift) then
//  begin
//    AMagic := FindMagic([SKILL_89,SKILL_ERGUM]);
//    if AMagic <> nil then
//    begin
//      Result := True;
//      Exit;
//    end;
//  end;

  //半月弯刀
  if g_Config.Assistant.AutoWideHit then
  begin
    if (g_MySelf <> nil) and (g_TargetCret <> nil) then
    begin
      if FrmMain.TargetInSwordWideAttackRange(ADir) { or (not g_Config.Assistant.LongHit or (not ContainMagic(SKILL_ERGUM) and not ContainMagic(SKILL_89)))} then
      begin
        AMagic := FindMagic([SKILL_40, SKILL_90,SKILL_BANWOL]);
        if AMagic <> nil then
        begin
          Goto EndGet;
        end;
      end;
    end;
  end;

  //开启刀刀刺杀要能手动控制半月
  for I := 0 to g_MyOpendMagics.Count - 1 do
  begin
    _Magic := PTClientMagic(g_MyOpendMagics.Items[I]);
    if (_Magic <> nil) and ( _Magic.wMagicId in [SKILL_40, SKILL_90,SKILL_BANWOL]) then
    begin
      AMagic := _Magic;
      goto EndGet;
    end;
  end;


  for I := 0 to g_MyOpendMagics.Count - 1 do
  begin

    _Magic := PTClientMagic(g_MyOpendMagics.Items[I]);
    ASpellPoint := GetSpellPoint(_Magic);
    AHandled := False;
    if g_MySelf.m_Abil.MP >= ASpellPoint then
    begin
      if g_MagicMgr.TryGet(_Magic.wMagicId, AClient) then
      begin
        if (_Magic.btMaxRange = 0) or (ARange <= _Magic.btMaxRange) then
        begin
          if AClient.Assistant.CheckLine then
          begin
            AHandled := True;
            if g_TargetCret <> nil then
              Result := (g_MySelf.m_nCurrX - g_TargetCret.m_nCurrX = 0) or (g_MySelf.m_nCurrY - g_TargetCret.m_nCurrY = 0) or (ABS(g_MySelf.m_nCurrX - g_TargetCret.m_nCurrX) = ABS(g_MySelf.m_nCurrY - g_TargetCret.m_nCurrY))
            else
              Result := FrmMain.TargetInLineRange(ADir, _Magic.btMaxRange);
          end
          else if AClient.Assistant.CheckWide then
          begin
            AHandled := True;
            if g_MySelf <> nil then
              Result := FrmMain.TargetInSwordWideAttackRange(ADir);
          end;
          if Result then
          begin
            AMagic := _Magic;
            Break;
          end;
          if AHandled then
            Continue;
        end;
      end;

      case _Magic.wMagicId of
        SKILL_ERGUM, SKILL_89:
        begin
          if g_Config.Assistant.LongHit and (ARange = 1) then
            AMagic := _Magic
          else if (g_Config.Assistant.SPLongHit and (ARange = 2)){ or (ssShift in AShift)} then
          begin
            if FrmMain.TargetInSwordLongAttackRange(ADir) then
              AMagic := _Magic;
          end
          else if (g_MySelf <> nil) and (g_TargetCret <> nil) and (ARange = 1) then
          begin
            if FrmMain.TargetInSwordLongAttackRange(ADir) then
              AMagic := _Magic;
          end;
        end;
        SKILL_BANWOL, SKILL_40, SKILL_90:
        begin
         (*
          if g_Config.Assistant.AutoWideHit then
          begin
            if (g_MySelf <> nil) and (g_TargetCret <> nil) then
            begin
              if FrmMain.TargetInSwordWideAttackRange(ADir) or (not g_Config.Assistant.LongHit or (not ContainMagic(SKILL_ERGUM) and not ContainMagic(SKILL_89))) then
              begin
                if _Magic.btMaxRange >= ARange then
                  AMagic := _Magic;
              end;
            end;
          end
          else
          begin
            if not g_Config.Assistant.LongHit or (not ContainMagic(SKILL_ERGUM) and not ContainMagic(SKILL_89)) then
            begin
              if _Magic.btMaxRange >= ARange then
                AMagic := _Magic;
            end;
          end;    *)
        end  
        else
        begin
          if _Magic.btMaxRange >= ARange then
            AMagic := _Magic;
        end;
      end;
    end;

    if AMagic <> nil then
    begin
      Result := True;
      Break;
    end;
  end;

  //如果没有选中技能这里处理 刀刀刺杀。
  if (AMagic = nil) and
   ((ssShift in AShift) or (g_Config.Assistant.LongHit)) then
  begin
    Result := TryGetMagic(SKILL_ERGUM, AMagic);
    if not Result then
      Result := TryGetMagic(SKILL_89, AMagic);
  end;

   //如果没有选中技能这里处理 隔位刺杀。
  if (AMagic = nil) and (g_TargetCret <> nil) and (g_Config.Assistant.SPLongHit) then
  begin
    // 获取自己的方向 往前面 + 2 如果坐标等于 g_TargetCret 那就是说明可以刺杀打到。
    nSelfX := g_MySelf.m_nCurrX;
    nSelfY := g_MySelf.m_nCurrY;
    btDir := ADir;

    GetNextPosXY(btDir,nSelfX,nSelfY);
    GetNextPosXY(btDir,nSelfX,nSelfY);

    if (g_TargetCret.m_nCurrX = nSelfX) and (g_TargetCret.m_nCurrY = nSelfY) then
    begin
      Result := TryGetMagic(SKILL_ERGUM, AMagic);
      if not Result then
        Result := TryGetMagic(SKILL_89, AMagic);
    end;
  end;


EndGet:
  //没蓝不给用
  if AMagic <> nil then
  begin
    ASpellPoint := GetSpellPoint(AMagic);
   if (g_MySelf.m_Abil.MP < ASpellPoint) then
   begin
     Result := False;
     AMagic := nil;
   end;
  end;
end;

function TryGetMagicByID(Id: Word; out AMagic: PTClientMagic): Boolean;
var
  i: Integer;
  pm: PTClientMagic;
begin
  Result := False;
  if g_MagicList.count > 0 then
  begin
    for i := 0 to g_MagicList.count - 1 do
    begin
      pm := PTClientMagic(g_MagicList[i]);
      if (pm <> nil) and (pm.wMagicId = Id) then
      begin
        Result := TRUE;
        AMagic := pm;
        Break;
      end;
    end;
  end;
end;

function TryGetWarMagic(ARange: Integer; AShift: TShiftState; var AMagic: PTClientMagic; var AType: Integer): Boolean;
begin
  Result := False;
  AMagic := nil;
  AType := 0;
  if TryGetNextBatterMagic(1, AMagic) then
    AType := 1
  else if TryGetNextMagic(ARange, AMagic) then
    AType := 2
  else if TryGetOpendMagic(ARange, AShift, AMagic) then
    AType := 3
  else if (g_UseItems[U_WEAPON].Name <> '') and (g_UseItems[U_WEAPON].S.Job = _JOB_ARCHER) and g_boAutoUseSkill150 then
  begin
    TryGetMagicByID(SKILL_150, AMagic);
    if (AMagic <> nil) and (AMagic.btMaxRange >= ARange) then
      AType := 4;
  end;
  Result := AType > 0;
end;

procedure DeleteWarMagic(AMagic: PTClientMagic; AType: Byte);
var
  AIndex: Integer;
begin
  if AMagic <> nil then
  begin
    case AType of
      1:
      begin
        AIndex := g_MyNextBatterMagics.IndexOf(AMagic);
        if AIndex <> -1 then
          g_MyNextBatterMagics.Delete(AIndex);
      end;
      2:
      begin
        AIndex := g_MyNextMagics.IndexOf(AMagic);
        if AIndex <> -1 then
          g_MyNextMagics.Delete(AIndex);
      end;
    end;
  end;
end;

function CanUseMagic(AMagic: PTClientMagic): Boolean;
var
  AClient: TuMagicClient;
  ADir: Integer;
begin
  Result := True;
  if g_MagicMgr.TryGet(AMagic.wMagicId, AClient) then
  begin
    if AClient.Assistant.CheckLine then
    begin
      if g_TargetCret <> nil then
        Result := (g_MySelf.m_nCurrX - g_TargetCret.m_nCurrX = 0) or (g_MySelf.m_nCurrY - g_TargetCret.m_nCurrY = 0) or (ABS(g_MySelf.m_nCurrX - g_TargetCret.m_nCurrX) = ABS(g_MySelf.m_nCurrY - g_TargetCret.m_nCurrY))
      else
      begin
        ADir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nTargetX, g_nTargetY);
        Result := FrmMain.TargetInLineRange(ADir, AMagic.btMaxRange);
      end;
    end;
  end
  else
  begin
    case AMagic.wMagicId of
      SKILL_42, SKILL_43, SKILL_74:
      begin
        if g_TargetCret <> nil then
          Result := (g_MySelf.m_nCurrX - g_TargetCret.m_nCurrX = 0) or (g_MySelf.m_nCurrY - g_TargetCret.m_nCurrY = 0) or (ABS(g_MySelf.m_nCurrX - g_TargetCret.m_nCurrX) = ABS(g_MySelf.m_nCurrY - g_TargetCret.m_nCurrY))
        else
        begin
          ADir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_nTargetX, g_nTargetY);
          Result := FrmMain.TargetInLineRange(ADir, AMagic.btMaxRange);
        end;
      end;
    end;
  end;
end;

{ TAssistant }

constructor TAssistant.Create;
begin
  FFilters := TStringList.Create;
  FMonHints := TStringList.Create;
  inherited;
end;

destructor TAssistant.Destroy;
begin
  FreeAndNilEx(FFilters);
  FreeAndNilEx(FMonHints);
  inherited;
end;

procedure TAssistant.CheckValue;
begin
  FEditCommonMpTimer := Max(FEditCommonMpTimer, 500);
  FEditSpecialHpTimer := Max(FEditSpecialHpTimer, 500);
  FEditRandomHpTimer := Max(FEditRandomHpTimer, 500);
  FEditSpecialMpTimer := Max(FEditSpecialMpTimer, 500);
  FEditCommonHpTimer := Max(FEditCommonHpTimer, 500);
end;

procedure TAssistant.LoadDefault;
begin
  FShowAllItem := True;
  FDefCommonHpName := '';
  FEditHeroDrugWine := 0;
  FAutoMagicTime := 4;
  FAutoWideHit := False;
  FEditCommonMpTimer := 4000;
  FAutoShield := False;
  FAutoEatHeroDrugWine := False;
  FDefCommonMpName := '';
  FUseHotkey := False;
  FAutoHide := False;
  FShowMonName := True;
  FAutoUseHuoLong := False;
  FShowTitle := True;
  FFilterItemName := False;
  FEditWine := 10;
  FSPLongHit := False;
  FSound := True;
  FBGSound := True;
  FCleanCorpse := False;
  FNoShift := False;
  FFilterPickItem := False;
  FAutoSearchItem := False;
  FEditSpecialHp := 10;
  FAutoEatWine := False;
  FAutoUseJinYuan := False;
  FAutoMagic := False;
  FEditRandomHp := 10;
  FAutoZhuriHit := False;
  FRandomType := 0;
  FEditSpecialMp := 10;
  FSwitchMiniMap := 0;
  FSpecialHp := False;
  FAutoPuckUpItem := True;
  FEditHeroWine := 0;
  FEditCommonHp := 10;
  FUseBatter := 0;
  FRandomHp := False;
  FEditSpecialHpTimer := 4000;
  FSwitchAttackMode := 0;
  FEditDrugWine := 0;
  FAutoEatHeroWine := False;
  FMagicLock := True;
  FSpecialMp := False;
  FLongHit := False;
  FEditCommonMp := 10;
  FEditRandomHpTimer := 4000;
  FDefSpecialHpName := '';
  FCommonHp := False;
  FShowBlood := True;
  FShowHealthStatus := True;
  FShowName := True;
  FAutoEatDrugWine := False;
  FAutoFireHit := False;
  FEditSpecialMpTimer := 4000;
  FRandomName := '';
  FEditCommonHpTimer := 4000;
  FDuraWarning := False;
  FShowGroupHead := False;
  FCommonMp := False;
  FDefSpecialMpName := '';
  FShowNPCName := True;
  FShowRankName := True;
  FShowJobLevel := False;
  FShowBloodNum := True;
  FHideDressEff := False;
  FHideWepEff := False;
  FFilterExp := True;
  FFilterExpValue := 2000;
  FSoundVolume := 100;
  FBGSoundVolume := 100;
  FMonHintInterval := 5;
  FMonHints.Clear;
  FFilters.Clear;
end;

procedure TAssistant.SetMonHintInterval(const Value: Integer);
begin
  FMonHintInterval := Value;
  if (FMonHintInterval < 1) or (FMonHintInterval > 600) then
    FMonHintInterval := 5;
end;

function GetMySelfClipValue (clType : TClipType; var Value,MaxValue : Int64):Single;
begin
  if g_MySelf = nil then
  begin
    Value := 1;
    MaxValue := 1;
    Exit;
  end;

  case clType of
    ctNone:;
    ctHp:
    begin
      Value := g_MySelf.m_Abil.HP;
      MaxValue := g_MySelf.m_Abil.MaxHP;
    end;
    ctMP:
    begin
      Value := g_MySelf.m_Abil.MP;
      MaxValue := g_MySelf.m_Abil.MaxMP;
    end;
    ctExp:
    begin
      Value := g_MySelf.m_Abil.Exp;
      MaxValue := g_MySelf.m_Abil.MaxExp;
    end;
    ctWeight:
    begin
      Value := g_MySelf.m_Abil.Weight;
      MaxValue := g_MySelf.m_Abil.MaxWeight;
    end;
  end;

  if Value > MaxValue then
  begin
    Value := MaxValue;
  end;

  Result := Value / MaxValue;
end;

{ TConfig }

procedure TConfig.Clear;
begin
  LoadDefault;
  FLoaded := False;
end;

constructor TConfig.Create;
begin
  FAssistant := TAssistant.Create;
  inherited;
end;

destructor TConfig.Destroy;
begin
  FreeAndNilEx(FAssistant);
  inherited;
end;

procedure TConfig.Load(const CharName: String; DeleteExists: Boolean);
var
  AFileName, AName: String;
  I, ItemIndex: Integer;
  AStdItem: pTStdItem;
  AShowItem: TShowItem;
  nBind: Integer;
begin
  if not DirectoryExists(UserCfgDir) then
    CreateDir(UserCfgDir);

  AFileName := '';
  FCharName := CharName;
  if FCharName <> '' then
  begin
    if not DirectoryExists(UserCfgDir + Format('%s\', [g_sServerName])) then
      CreateDir(UserCfgDir + Format('%s\', [g_sServerName]));
    AFileName := UserCfgDir + Format('%s\%s.xml', [g_sServerName, FCharName]);
  end;
  if (AFileName <> '') and FileExists(AFileName) then
  begin
    if DeleteExists then
    begin
      try
        DeleteFile(AFileName);
      except
      end;
    end
    else
    begin
      LoadFromXMLFile(AFileName);
    end;
  end;
  FAssistant.CheckValue;

  g_FilterItemNameList.Clear;
  for I := 0 to g_ItemList.Count - 1 do
  begin
    AStdItem := g_ItemList.Items[I];
    AShowItem := TShowItem.Create;
   // AShowItem.nOldBind := AStdItem.Bind;
    AShowItem.State := AStdItem.State;
    AShowItem.BoShowName := AStdItem.State.ShowNameClient;
    AShowItem.BoSpec := AStdItem.State.SpecialShow;
    AShowItem.boAutoPickup := AStdItem.State.AutoPickUp;
    g_FilterItemNameList.AddOrSetValue(AStdItem.Name, AShowItem);
  end;

  if not DeleteExists then
  begin
    for I := 0 to FAssistant.Filters.Count - 1 do
    begin
      AName := FAssistant.Filters.Names[I];
      nBind := StrToIntDef(FAssistant.Filters.ValueFromIndex[I], -1);

      if (nBind > -1) and g_FilterItemNameList.TryGetValue(AName, AShowItem) then
      begin
        AShowItem.BoShowName := SetContain(nBind, 1);
        AShowItem.BoSpec := SetContain(nBind, 2);
        AShowItem.boAutoPickup := SetContain(nBind, 3);
        ItemIndex := GetItemIndexByName(AName);
        if (ItemIndex >= 0) and (ItemIndex < g_ItemList.Count) then
          AStdItem := g_ItemList.Items[ItemIndex];
        if AStdItem <> nil then
        begin
          AStdItem.State.ShowNameClient := AShowItem.BoShowName;
          AStdItem.State.SpecialShow := AShowItem.BoSpec;
          AStdItem.State.AutoPickUp := AShowItem.boAutoPickup;

//          if AShowItem.BoShowName then
//            AddSetValue(AStdItem.Bind, 6)
//          else
//            DecSetValue(AStdItem.Bind, 6);
//          if AShowItem.BoSpec then
//            AddSetValue(AStdItem.Bind, 7)
//          else
//            DecSetValue(AStdItem.Bind, 7);
//          if AShowItem.boAutoPickup then
//            AddSetValue(AStdItem.Bind, 8)
//          else
//            DecSetValue(AStdItem.Bind, 8);

         // AShowItem.nOldBind := AStdItem.Bind;
           AShowItem.State := AStdItem.State;
        end;
      end;
    end;
  end;

  FLoaded := True;
end;

procedure TConfig.LoadFilters;
var
  AName: String;
  I, ItemIndex: Integer;
  AStdItem: pTStdItem;
  AShowItem: TShowItem;
  nBind: Integer;
begin
  g_FilterItemNameList.Clear;
  for I := 0 to g_ItemList.Count - 1 do
  begin
    AStdItem := g_ItemList.Items[I];
    AShowItem := TShowItem.Create;
//    AShowItem.nOldBind := AStdItem.Bind;
//    AShowItem.BoShowName := SetContain(AStdItem.Bind, 6);
//    AShowItem.BoSpec := SetContain(AStdItem.Bind, 7);
//    AShowItem.boAutoPickup := SetContain(AStdItem.Bind, 8);

    AShowItem.State := AStdItem.State;
    AShowItem.BoShowName := AStdItem.State.ShowNameClient;
    AShowItem.BoSpec := AStdItem.State.SpecialShow;
    AShowItem.boAutoPickup := AStdItem.State.AutoPickUp;
    g_FilterItemNameList.AddOrSetValue(AStdItem.Name, AShowItem);
  end;

  for I := 0 to FAssistant.Filters.Count - 1 do
  begin
    AName := FAssistant.Filters.Names[I];
    nBind := StrToIntDef(FAssistant.Filters.ValueFromIndex[I], -1);
    if (nBind > -1) and g_FilterItemNameList.TryGetValue(AName, AShowItem) then
    begin
      AShowItem.BoShowName := SetContain(nBind, 1);
      AShowItem.BoSpec := SetContain(nBind, 2);
      AShowItem.boAutoPickup := SetContain(nBind, 3);
      ItemIndex := GetItemIndexByName(AName);
      if (ItemIndex >= 0) and (ItemIndex < g_ItemList.Count) then
        AStdItem := g_ItemList.Items[ItemIndex];
      if AStdItem <> nil then
      begin
        AStdItem.State.ShowNameClient := AShowItem.BoShowName;
        AStdItem.State.SpecialShow := AShowItem.BoSpec;
        AStdItem.State.AutoPickUp := AShowItem.boAutoPickup;
//        if AShowItem.BoShowName then
//          AddSetValue(AStdItem.Bind, 6)
//        else
//          DecSetValue(AStdItem.Bind, 6);
//        if AShowItem.BoSpec then
//          AddSetValue(AStdItem.Bind, 7)
//        else
//          DecSetValue(AStdItem.Bind, 7);
//        if AShowItem.boAutoPickup then
//          AddSetValue(AStdItem.Bind, 8)
//        else
//          DecSetValue(AStdItem.Bind, 8);
//        AShowItem.nOldBind := AStdItem.Bind;
        AShowItem.State := AStdItem.State;
      end;
    end;
  end;
end;

procedure TConfig.Save;
var
  AFileName: String;
  I, nBind: Integer;
  AStdItem: pTStdItem;
  AShowItem: TShowItem;
begin
  AFileName := UserCfgDir + Format('%s\%s.xml', [g_sServerName, FCharName]);
  Assistant.Filters.Clear;

  for I := 0 to g_ItemList.Count - 1 do
  begin
    AStdItem := g_ItemList.Items[I];
    if g_FilterItemNameList.TryGetValue(AStdItem.Name, AShowItem) then
    begin
      if not (AShowItem.State = AStdItem.State) then
      begin
        nBind := 0;
        if AShowItem.BoShowName then
          AddSetValue(nBind, 1);
        if AShowItem.BoSpec then
          AddSetValue(nBind, 2);
        if AShowItem.boAutoPickup then
          AddSetValue(nBind, 3);
        Assistant.Filters.Add(Format('%s=%d', [AStdItem.Name, nBind]));
      end;
    end;
  end;
  SaveToXMLFile(AFileName);
end;

procedure TConfig.LoadDefault;
begin
  inherited;
  FAssistant.LoadDefault;
end;



initialization
  DoInitialization;
finalization
  DoFinalization;

end.
