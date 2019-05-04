unit ClMain;

interface

{$J+}
{$I MM.inc}
{$I Client.inc}

uses
  SkillInfo,ZLib, Windows, Messages, SysUtils, Graphics, Controls, Forms,
  Generics.Collections,
  Math, Clipbrd, StdCtrls, MMSystem, IniFiles, AsphyreTypes, Dialogs, SyncObjs,
  DrawScrn, IntroScn, PlayScn, MapUnit, WIL, Grobal2, uTypes, Actor, CliUtil,
  HUtil32, EdCode, DWinCtl, ClFunc, magiceff, SoundUtil, clEvent, ScktCompSy,
  MShare, Share, ExtCtrls, Classes, uMessageParse, uUITypes, uEDCode,
  uCliUITypes,
  Common, uSocket, uPathFind, uTextures, DXHelper, uMapDesc,
  NativeXmlObjectStorage,
  AssistantFrm, DXDialogs, PopupMeunuFrm, StrUtils, uFirewall, uLocalMessageer,
  AbstractTextures, AsphyreDef, Vectors2, Vectors2px, AsphyreEventTypes,
  AsphyreEvents,
  AsphyreFactory, AbstractDevices, AbstractCanvas, NativeConnectors,
  AnsiHUtil32,
  uDXLoader, uMagicMgr, uMagicTypes, DateUtils, uAutoRun, uAnsiStrings,
  AnsiStrings,uGameData,
  IOUtils, OSUtils, PngImage, uLog, uMemBuffer, GameSocketData,
  uSyProtocolBuffer, uGameClientPaxEngine,TypInfo,fastmm4, AppEvnts,SkillEffectConfig,SkillManager,uOnlineTimeCheck,uSyncObj;

type
  TfrmMain = class(TForm, IApplication)
    DecodeTimer: TTimer;
    MouseTimer: TTimer;
    WaitMsgTimer: TTimer;
    SelChrWaitTimer: TTimer;
    CmdTimer: TTimer;
    RunTimer: TTimer;
    CloseTimer: TTimer;
    ImageLogo: TImage;
    SpeedCheckTimer: TTimer;
    ApplicationEvent: TApplicationEvents;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DecodeTimerTimer(Sender: TObject);
    procedure MouseTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure WaitMsgTimerTimer(Sender: TObject);
    procedure SelChrWaitTimerTimer(Sender: TObject);
    procedure CmdTimerTimer(Sender: TObject);
    procedure RunTimerTimer(Sender: TObject);
    procedure CloseTimerTimer(Sender: TObject);
    procedure SendHeroMagicKeyChange(magid: Integer; keych: PPlatfromChr);
    procedure GetCheckNum();
    procedure SendCheckNum(num: string);
    procedure SendQueryAssessHero;
    procedure SendAssessMentHero;
    procedure SendChangeCheckNum();
    procedure AutoRunTimerTimer(Sender: TObject);
    procedure Autorun;
    procedure SendMakeWineItems();
    procedure OpenSdoAssistant();
    procedure SendChallenge;
    procedure SendAddChallengeItem(ci: TClientItem);
    procedure SendCancelChallenge;
    procedure SendDelChallengeItem(ci: TClientItem);
    procedure ClientGetChallengeRemoteAddItem(const body: PPlatfromString);
    procedure ClientGetChallengeRemoteDelItem(const body: PPlatfromString);
    procedure SendChallengeEnd;
    procedure SendChangeChallengeGold(gold: Integer);
    procedure SendChangeChallengeDiamond(Diamond: Integer);
    procedure SendHeroAutoOpenDefence(Mode: Integer);
    procedure SendTrainingHero;
    procedure ClientGetReceiveDelChrs(const body: PPlatfromString;
      DelChrCount: Integer);
    procedure SendQueryDelChr();
    procedure SendSetBatterOrder();
    procedure SendSetHeroBatterOrder();
    procedure SendResDelChr(Name: string);
    // procedure SendOpenPulse(BatterPage:Word; PulseNum: Word);  //冲脉  20091211
    procedure SendOpenPulseQuery(BatterPage: Word; PulseNum: Word); // 打通经脉查询
    procedure SendHeroOpenPulseQuery(HeroBatterPage, HeroPulseNum: Word);
    procedure SendRushPulse(BatterPage: Word; PulseLevel: Word); // 修炼脉络
    procedure SendHeroRushPulse(HeroBatterPage: Word; HeroPulseLevel: Word);
    procedure SendSighIconMsg;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormClick(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LibMemoryCheckTimerTimer(Sender: TObject);
    procedure ApplicationEventException(Sender: TObject; E: Exception);
  private
    FailureHandled: Boolean;
    FNetChanging: Boolean;
    FBreakOff: Boolean;
    SocStr, BufferStr: AnsiString;
    FBeijTime: AnsiString;
    TimerCmd: TTimerCommand;
    MakeNewId: String;
    ActionLockTime: LongWord;
    ActionFailLock: Boolean;
    ActionFailLockTime: LongWord;
    FailAction, FailDir, FMessageIndex: Integer;
    ActionKey: Word;
    AutoMagicID: Word;
    PopWindowUrl: string;
    FSpeedWarning: String;

    FInputHandled: Boolean;
    MouseDownTime: LongWord;
    LastActorClkTick: LongWord;
    WaitingMsg: TDefaultMessage;
    WaitingStr: string;
    WhisperName: string;
    FLastDialogItem: PTMessageDialogItem;
    FAppTerminated: Boolean;
    FSocketSection: TFixedCriticalSection;
    FMachineCode: String;
    FTimerSpeedCheck: TTimer;
    FLastSpeedCheckTime:Cardinal;
    FSpeedTick: LongWord;
    FSpeedTime: TDateTime;
    FSpeedError: Integer;
    FAutoRunner: TuAutoRunner;
    FCheckLibTime: LongWord;
    FLastStaticCheckSpeedTime:LongWord;
    FBoosTraceTime: LongWord;
    FNeedTokenID: Boolean;
    FRunRouteIndex: Integer;
    FRunRoutes: TStrings;
    FTryReconnet: Boolean;
    FTransDataTime: LongWord;
    FCheckHackTimeThread:TThread;
    procedure CSocketSessionConnected(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure CSocketSessionClosed(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketDataAvailable(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure TryConnectNextRoute;
    procedure TimerSpeedCheckTimer(Sender: TObject);

    // For ASP
    procedure OnAsphyreCreate(Sender: TObject; Param: Pointer;
      var Handled: Boolean);
    procedure OnAsphyreDestroy(Sender: TObject; Param: Pointer;
      var Handled: Boolean);
    procedure OnDeviceInit(Sender: TObject; Param: Pointer;
      var Handled: Boolean);
    procedure OnDeviceCreate(Sender: TObject; Param: Pointer;
      var Handled: Boolean);
    procedure OnDeviceDestroy(Sender: TObject; Param: Pointer;
      var Handled: Boolean);
    procedure OnEventDeviceLost(Sender: TObject; Param: Pointer;
      var Handled: Boolean);
    procedure RenderEvent(Sender: TObject);
    procedure HandleConnectFailure();
    procedure DoGetTextHeight(const Text: String; Font: TFont;
      var Value: Integer);
    procedure DoGetTextWidth(const Text: String; Font: TFont;
      var Value: Integer);
    procedure DoGetTextExtent(const Text: string; Font: TFont;
      var Value: TSize);

    procedure AutoPickUpItem();
    function ProcessKeyMessages: Boolean;
    procedure ProcessActionMessages;
    // procedure CheckSpeedHack (rtime: Longword);

    // 消息解码包部分
    procedure DecodeMessagePacket(const datablock: PPlatfromString);

    // 实际的消息处理
    procedure DoPacket(Msg: TDefaultMessage; const body: PPlatfromString;
      const Buf: Pointer; nLen: Integer);
    procedure DecodeCompressMessagePacket(const buff: PAnsiChar; nLen: Integer);

    procedure DecodePacketWithType(btMsgType: Byte;
      const datablock: PPlatfromString); // 解码不同的消息包
    procedure DecodePacketWithTypeBuffer(btMsgType: Byte; const Buffer: Pointer;
      nLen: Integer); //

    procedure ActionFailed;
    function GetMagicByKey(Key: PPlatfromChr): PTClientMagic;
    function CheckMagicTime(AMagic: PTClientMagic;
      ShowWarning: Boolean): Boolean;
    procedure UseMagic(X, Y: Integer; Magic: PTClientMagic;
      LoadNextMagic, ShowWarning: Boolean);
    procedure UseMagicSpell(ident, who, effnum, targetx, targety, magic_id,
      magLvl, magStrengthen, magTag: Integer);
    procedure UseMagicFire(who, efftype, effnum, targetx, targety,
      target: Integer; ShowHitEffect: Boolean);
    procedure UseMagicFireFail(who, AMagicID: Integer);

    procedure ClearDropItems;
    procedure ResetGameVariables;
    procedure ChangeServerClearGameVariables;
    procedure ShowHeroLoginOrLogOut(Actor: TActor);
    procedure _DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AttackTarget(target: TActor; Shift: TShiftState);
    procedure ClientReadOperateState(AState: Integer);
    procedure ClientReadSkillState(SkillID, AState, ATag: Integer);
    function AutoLieHuo: Boolean;
    function AutoZhuri: Boolean;
    function NearActor: Boolean;
    // 自动隐身，自动魔法盾    //自动抗拒
    procedure AutoEatItem;
    // 保护
    function CheckDoorAction(dx, dy: Integer): Boolean;
    procedure ClientGetPasswdSuccess(const body: PPlatfromString);
    procedure ClientGetNeedUpdateAccount(const body: PPlatfromString);
    procedure ClientGetSelectServer;
    procedure ClientGetPasswordOK(Msg: TDefaultMessage;
      const sBody: PPlatfromString);
    procedure ClientGetReceiveChrs(MaxChr: Integer;
      const body: PPlatfromString);
    procedure ClientGetStartPlay(const body: PPlatfromString);
    procedure ClientGetReconnect(const body: PPlatfromString);
    procedure ClientGetServerConfig(Msg: TDefaultMessage;
      const sBody: PPlatfromString);
    procedure ClientGetMapDescription(Msg: TDefaultMessage;
      const sBody: PPlatfromString);
    procedure ClientGetGameGoldName(Msg: TDefaultMessage;
      const sBody: PPlatfromString);
    procedure ClientGetAdjustBonus(bonus: Integer; body: string);
    procedure ClientGetAddItem(const body: PPlatfromString);
    procedure ClientGetUpdateItem(const body: PPlatfromString);
    procedure ClientGetDelItem(const body: PPlatfromString);
    procedure ClientGetDelItems(const body: PPlatfromString);
    procedure ClientGetBagItmes(body: PPlatfromString);
    procedure ClientGetDropItemFail(iname: string; sindex: Integer);
    procedure ClientGetShowItem(itemid, X, Y, looks, ItemInfo: Integer;
      const itmname: string);
    procedure ClientGetHideItem(itemid, X, Y: Integer);
    procedure ClientGetSenduseItems(body: PPlatfromString);
    procedure ClientGetUserOrder(body: string);
    procedure DeleteItemByMakeIndex(AMakeIndex: Integer);
    procedure ReadGoldNames(const S: String);
    // 英雄持久
    procedure ClientGetExpTimeItemChange(uidx, NewTime: Integer);
    // 聚灵珠时间改变 20080307
    procedure ClientGetAddMagic(const body: PPlatfromString);
    procedure ClientGetDelMagic(magid: Integer);
    procedure ClientGetUpdateMagic(const Body:PPlatfromString);
    procedure ClientGetMyShopSpecially(body: PPlatfromString);
    // 称号
    procedure ClientGetMyTitles(AActiveTitle: Integer; ABody: PPlatfromString);
    procedure ClientAddTitle(AActiveTitle: Integer;
      const ABody: PPlatfromString);
    procedure ClientRemoveTitle(AActiveTitle: Integer; ATitleID: Integer);
    procedure ClientSetActiveTitle(ATitleID: Integer);
    procedure ClientGetMyShop(body: PPlatfromString);
    // 商铺 清清 2007.11.14
    procedure ClientGetMyBoxsItem(AShap: Integer; ABody: PPlatfromString);
    procedure ClientGetShuffle(const body: PPlatfromString);
    // 接收宝箱物品 清清 2008.01.16
    procedure ClientGetMyMagics(body: PPlatfromString);
    procedure ClientGetMagicLvExp(magid, maglv, magtrain: Integer);
    procedure ClientGetDuraChange(uidx, newdura, newduramax: Integer);
    procedure ClientGetMerchantSay(merchant, face: Integer; saying: string);
    procedure ClientGetMerchantSayCustom(AType, AMerchant, AFace: Integer;
      AMessage: string);
    procedure ClientGetCloseWindow(const AUIName: String);
    procedure ClientGetSendGoodsList(merchant, count: Integer;
      body: PPlatfromString);
    procedure ClientGetSendMakeDrugList(merchant: Integer;
      body: PPlatfromString);
    procedure ClientGetSendUserSell(merchant: Integer);
    procedure ClientGetSendUserSellOff(merchant: Integer); // 元宝寄售显示窗口  20080316
    procedure ClientGetSellOffMyItem(const body: PPlatfromString);
    // 客户端寄售查询购买物品 20080317
    procedure ClientGetSellOffSellItem(const body: PPlatfromString);
    // 客户端寄售查询出售物品 20080317
    procedure ClientGetSendUserRepair(merchant: Integer);
    procedure ClientGetSendUserStorage(merchant: Integer; IsBigStore: Boolean);
    procedure ClientGetSendUserPlayDrink(merchant: Integer);
    procedure ClientGetSaveItemList(merchant, nType: Integer;
      bodystr: PPlatfromString);
    procedure ClientGetSendDetailGoodsList(merchant, count, topline: Integer;
      bodystr: PPlatfromString);
    procedure ClientGetSendNotice(const body: PPlatfromString);
    procedure ClientGetGroupMembers(Msg: TDefaultMessage; bodystr: string);
    procedure ClientGetOpenGuildDlg(const bodystr: PPlatfromString);
    procedure ClientGetSendGuildMemberList(const body: PPlatfromString);
    procedure ClientGetDealRemoteAddItem(const body: PPlatfromString);
    procedure ClientGetDealRemoteDelItem(const body: PPlatfromString);
    procedure ClientGetReadMiniMap(mapindex: Integer);
    procedure ClientGetChangeGuildName(body: string);
    procedure ClientGetSendUserState(const body: PPlatfromString);
    procedure DrawEffectHum(nType, nX, nY: Integer);
    procedure ClientGetNeedPassword(const body: String);
    procedure ClientGetOpenUI(const body: String);
    procedure ClientShowEffect(Msg: TDefaultMessage);
    procedure SetInputStatus();
    { procedure CmdShowHumanMsg(sParam1, sParam2, sParam3, sParam4,    20080723注释
      sParam5: String); }
    // procedure ShowHumanMsg(Msg: pTDefaultMessage);  20080723注释
    procedure CMDialogKey(var Msg: TCMDialogKey); message CM_DIALOGKEY;

    // procedure hotkeypress(var msg:TWMHotKey);message wm_hotkey;
    { ****************************************************************************** }
    procedure SocketOpen(const Address: String; Port: Integer);
    procedure ClientPlaySound(const ASoundFile: String);
    procedure ClientPlayVideo(const AVideoFile: String);
    procedure UpdateGroupUserHealth(Id, HP, MP, MaxHP, MaxMP: Integer);
    procedure UpdateGroupUserLevel(Id, ReLevel, Level: Integer);
    procedure ClientSetSpeed(wRunTime, wWalkTime, wHitTime,
      wSpellTime: Integer);
    procedure ClientGetStallNameList(count: Integer;
      const List: PPlatfromString);
    procedure ClientGetMyItems(const List: PPlatfromString);
    procedure ClientGetWhoItems(const List: PPlatfromString);
    procedure ClientParseItems(const Value: AnsiString);
    procedure ClientParseItemsDesc(const Value: AnsiString);
    procedure ClientParseUI(const Value: AnsiString);
    procedure ClientParseTypeNames(const Value: AnsiString);
    procedure ClientParseSuites(const Value: AnsiString);
    procedure ClientParseMap(const Value: AnsiString);
    procedure ClientParseMagics(const Value: AnsiString);
    procedure ClientParseMagicDesc(const Value: AnsiString);
    procedure ClientParseItemWay(const Value: AnsiString);
    procedure ClientCustomActorAction(const Value: AnsiString);
    procedure ClientParseSkill(const Value:AnsiString);
    procedure ClientParseSkillEffeect(Const Value:AnsiString);
    procedure ClientCheckDBVer(_Type: Integer; const Ver: AnsiString);
    procedure AddExtendButton(ImgIdx: Integer; const Value: PPlatfromString;
      ISTop: Boolean ; X:Integer = 0 ; Y : Integer = 0);
    procedure RemoveExtendButton(const Value: PPlatfromString);
    procedure ShowSighIcon(const Value: PPlatfromString);
    procedure UpdateSighIcon;
    procedure ClientGetActorName(nActor,nTitleEffect: Integer;btNameColor, btMiniMapHeroColor: Byte; const AName: PPlatfromString);
    procedure ClientGetSubAbility(const Value: String);
    procedure ClientGetReletions(const Command: Integer;
      const Data: PPlatfromString);
    procedure ReadMailList(const Value: PPlatfromString);
    procedure ReadMailData(const Value: PPlatfromString);
    procedure ReadNewMailData(const Value: PPlatfromString);
    procedure ReadMailGoldAdd(AGold, AGameGold, AGameGift: Integer;
      const Value: PPlatfromString);
    procedure DoDisappearIDs(const AIDs: String);
    procedure ClientShowQuestion(const Value: String);
    procedure LoadMissionsDoing(const Value: PPlatfromString);
    procedure LoadMissionsLink(const Value: PPlatfromString);
    procedure AddMission(Value: PPlatfromString);
    procedure DeleteMission(const Value: String);
    procedure UpdateMission(Value: PPlatfromString);
    procedure AddMissionLink(Value: PPlatfromString);
    procedure DeleteMissionLink(const Value: String);
    procedure SetLockMoveItem(AType, ATime: Integer);
    procedure ProcessDialogs;
    procedure ClearDialogMessages;
    function AutoUnPack(Eating: Boolean; AKind: Byte; const AMessage: String):Boolean;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    procedure OnClickSound(Sender: TObject; Clicksound: TClickSound);
    procedure OnDirectionKeyDown(K: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    { IApplication }
    procedure AddToChatBoardString(const Message: String;
      FColor, BColor: TColor);
    procedure LoadImage(const FileName: String; Index, Position: Integer);
    procedure AddMessageDialog(const Text: String; Buttons: TMsgDlgButtons;
      Handler: TMessageHandler = nil; Size: Integer = 1);
    function _CurPos: TPoint;

    procedure Terminate;
    procedure DisConnect;
  public
    CSocket: TuClientSocket;
    LoginID, LoginPasswd, CharName, SessionID: string;
    Certification: Integer;
    ActionLock: Boolean;
    FDlgMessageList: TList;
    BoPacketSplicingTest:Boolean; //测试RunGate粘包
    OnLineTimeCheck : TOnlineTimeCheck;
    procedure SendPacketSplicingTest();
    procedure CloseAllWindows;
    // 显示自身动画
    procedure OnIdle(Sender: TObject; var Done: Boolean);
    procedure ProcOnIdle;
    procedure AppLogout;
    procedure AppExit;
    procedure PrintScreenNow;
    function EatItem(idx: Integer; AItemMoved: Boolean = False ; Debug:Boolean = false):Boolean;
    procedure AutoLayOutItems;
    function FindItemPack(Item:TClientItem):Integer; //在背包找到能本物品的打包 物品
    procedure HeroEatItem(idx: Integer);
    procedure SendClientMessage(ident, Recog, Param, tag, series: Integer;
      const AData: AnsiString = '');
    procedure SendLogin(uid, passwd: string);
    procedure SendNewAccount(ue: TUserEntry);
    procedure SendUpdateAccount(ue: TUserEntry);
    procedure SendSelectServer(svname: string);
    procedure SendChgPw(Id, passwd, newpasswd: string);
    procedure SendNewChr(uid, uname, shair, sjob, ssex: string);
    procedure SendQueryChr(Code: Byte);
    // Code为1则查询验证码  为0则不查询
    procedure SendDelChr(chrname: string);
    procedure SendSelChr(chrname: string);
    procedure SendRunLogin;
    procedure SendSay(str: string);
    procedure SendShortCut(ACommand: Integer; const S: AnsiString = '');
    procedure SendMessageState(_Type: Integer; Value: Boolean);
    procedure SendSayEx(const str, ObjList: String);
    procedure SendActMsg(ident, X, Y, dir: Integer);
    procedure SendSpellMsg(ident, X, Y, dir, target: Integer);
    procedure SendHitMsg(ident, X, Y, dir, nMagicID, nTarget: Integer);
    procedure SendQueryUserName(targetid, X, Y: Integer);
    procedure SendDropItem(const name: string; itemserverindex: Integer);
    procedure SendPickup;
    procedure SendTakeOnItem(where: Byte; itmindex: Integer; itmname: string);
    procedure SendTakeOffItem(where: Byte; itmindex: Integer; itmname: string);
    // 首饰盒穿戴
    procedure SendAddItemToJewelryBox(where: Byte; itemindex: Integer);
    procedure SendJewelryBoxItemToBag(where: Byte; itemindex: Integer);

    // 十二生肖穿戴
    procedure SendTakeOnZodiacSignItem(where: Byte; itemindex: Integer);
    procedure SendZodiacSignItemToBag(where: Byte; itemindex: Integer);

    procedure SendItemUpOK(); // 淬炼点确定发消息 20080507
    procedure ClientGetUpDateUpItem(body: PPlatfromString);
    // 更新粹练物品! 20080507
    procedure ClientGetAssessMentHeroInfo(body: string);
    procedure SendSelHeroName(btType: Byte; SelHeroName: string);
    procedure SendHeroDropItem(name: string; itemserverindex: Integer);
    // 英雄往地上扔东西
    procedure SendHeroEat(itmindex: Integer; itmname: string);
    procedure SendItemToMasterBag(where: Byte; itmindex: Integer;
      itmname: string);
    procedure SendItemToHeroBag(where: Byte; itmindex: Integer;
      itmname: string);
    // 主人到英雄包裹
    procedure SendTakeOnHeroItem(where: Byte; itmindex: Integer;
      itmname: string);
    // 穿到英雄身上相应位置   清清 2007.10.23
    procedure SendTakeOffHeroItem(where: Byte; itmindex: Integer;
      itmname: string);
    procedure SendEat(itmindex: Integer; itmname: string);
    procedure SendButchAnimal(X, Y, dir, actorid: Integer);
    procedure SendCollectAnimal(X, Y, dir, actorid: Integer);
    procedure SendMagicKeyChange(magid: Integer; keych: PPlatfromChr);
    procedure SendMerchantDlgSelect(merchant: Integer;
      const SelectLabel: string; const WinName: String = '';
      const itemindex: String = '');
    procedure SendMissionCommandSelect(const SelectLabel: string);
    procedure SendQueryPrice(merchant, itemindex: Integer; itemname: string);
    procedure SendQueryRepairCost(merchant, itemindex: Integer;
      itemname: string);
    procedure SendSellItem(merchant, itemindex: Integer; itemname: string);
    procedure SendRepairItem(merchant, itemindex: Integer; itemname: string);
    procedure SendStorageItem(merchant, itemindex: Integer; itemname: string);
    procedure SendPlayDrinkItem(merchant, itemindex: Integer; itemname: string);
    procedure SendGetDetailItem(merchant, menuindex: Integer; itemname: string);
    procedure SendBuyItem(merchant, itemserverindex, itemcount: Integer; const itemname: string);
    procedure SendTakeBackStorageItem(merchant, itemserverindex: Integer;
      itemname: string);
    procedure SendMakeDrugItem(merchant: Integer; itemname: string);
    procedure SendDropGold(dropgold: Integer);
    procedure SendChangeState(STATE: Integer; OnOff: Boolean);
    procedure SendCreateGroup(withwho: string);
    procedure SendChangeHeroAttectMode;
    procedure SendWantMiniMap;
    procedure SendDealTry;
    procedure SendGuildDlg;
    procedure SendCancelDeal;
    procedure SendAddDealItem(ci: TClientItem);
    procedure SendDelDealItem(ci: TClientItem);
    procedure SendAddSellOffItem(ci: TClientItem);
    // 往寄售窗口加物品 发送到M2 20080316
    procedure SendDelSellOffItem(ci: TClientItem);
    // 往包裹里返回物品 发送到M2 20080316
    procedure SendCancelSellOffItem;
    // 取消寄售 发送到M2 20080316
    procedure SendSellOffEnd;
    // 发送寄售信息 发送到M2 20080316
    procedure SendCancelMySellOffIteming;
    // 取消正在寄售的物品 发送到M2 20080316
    procedure SendSellOffBuyCancel;
    // 取消寄售物品 收购 发送到M2 20080318
    procedure SendSellOffBuy;
    // 寄售物品 确定购买 发送到M2 20080318
    procedure SendChangeDealGold(gold: Integer);
    procedure SendDealEnd;
    procedure SendAddGroupMember(withwho: string);
    procedure SendDelGroupMember(withwho: string);
    procedure SendLeaveGroupMember;
    procedure SendGuildHome;
    procedure SendGuildMemberList;
    procedure SendGuildAddMem(who: string);
    procedure SendGuildDelMem(who: string);
    procedure SendBuyGameGird(GameGirdNum: Integer);
    // 商铺兑换灵符功能  20080302
    procedure SendGuildUpdateNotice(notices: string);
    procedure SendGuildUpdateGrade(rankinfo: string);
    procedure SendAdjustBonus(remain: Integer; babil: TNakedAbility);
    procedure SendPassword(const sPassword: String; nIdent: Integer);
    procedure SendOpenRefineBox;

    procedure SendOpenMember;
    procedure SendOpenPayHome;
    procedure SendItemClickFunc(SourceIdx, DestIdx: Integer);
    procedure SendItemClickUseItemFunc(where, SourceIdx, DestIdx: Integer);
    procedure SendItemUnite(SourceIdx, DestIdx: Integer);
    procedure SendItemSplit(SourceIdx, count: Integer);
    procedure SendQueryActorMenuState;
    procedure SendClientDataVer;
    procedure SendExtendCommandExecute(const CommandText: String);
    procedure SendSetActiveTitle(AIndex: Integer);
    procedure SendQueryOrders(AType, APage: Integer);

    function TargetInSwordLongAttackRange(ndir: Integer): Boolean;
    function TargetInSwordWideAttackRange(ndir: Integer): Boolean;
    function TargetInCanQTwnAttackRange(sx, sy, dx, dy: Integer): Boolean;
    function TargetInCanTwnAttackRange(sx, sy, dx, dy: Integer): Boolean;
    function TargetInLineRange(ndir, nLen: Integer): Boolean;
    procedure DoAppActivate(Sender: TObject);
    procedure DoAppDeactivate(Sender: TObject);
    procedure DoAppRestore(Sender: TObject);
    procedure DoAppMinimize(Sender: TObject);
    procedure SendSocket(AMessage: TDefaultMessage;
      const AData: PPlatfromString = ''); overload;
    // 发送数据并且指定消息头的类型 随云
    procedure SendSocket(const AData: PPlatfromString;
      DefMsgType: Byte = 0); overload;
    procedure SendStr(const AData: PPlatfromString);
    procedure SendHeartbeat;
    function ServerAcceptNextAction: Boolean; inline;
    function CanNextAction(ChrAction:TChrAction = caCommon): Boolean; inline;
    function CanNextHit: Boolean; inline;
    function IsUnLockAction(Action, adir: Integer): Boolean; inline;
    procedure ActiveCmdTimer(cmd: TTimerCommand);
    function IsGroupMember(const uname: string): Boolean;
    procedure AddMenuString(S: string);
    procedure AddHeroMenuString(S: string);

    function GetMagicByID(Id: Word): Boolean;
    procedure TurnDuFu(AMagic: PTClientMagic; AClient: TuMagicClient);
    // 自动换毒  20080315
    procedure SendPlayDrinkDlgSelect(merchant: Integer; rstr: string);
    procedure SendPlayDrinkGame(nParam1, GameNum: Integer);
    // 发送猜拳码数
    procedure ClientGetPlayDrinkSay(merchant, who: Integer; saying: string);
    // 接收斗酒说的话
    procedure SendDrinkUpdateValue(nParam1: Integer; nPlayNum, nCode: Byte);
    procedure SendDrinkDrinkOK();

    procedure SendHotClick;
    procedure SendHelpClick;
    procedure AutoGoto(DestX, DestY: Integer);
    procedure AutoFollow(DestX, DestY: Integer);
    procedure OpenURL(const AUrl: String; WinW, WinH: Integer);
    procedure BuildActorMenu(AMessage: TDefaultMessage);
    procedure AddChatBoardString(const AMessage: String; FColor, BColor: TColor;
      const ObjList: String = '');
    // 市场
    procedure SendMarketPutOn(MakeIndex: Integer;
      GoldPrice, GameGoldPrice: Integer);
    procedure SendMarketUpdate(MakeIndex: Integer;
      GoldPrice, GameGoldPrice: Integer);
    procedure SendMarketPutOff(MakeIndex: Integer);
    procedure SendMarketBuy(const StallUserName: String;
      MakeIndex, count: Integer);
    procedure SendMarketSetName(const NewName: String);
    procedure SendMarketGetList;
    procedure SendMarketGetItems(const who: String);
    procedure SendMarketExtractGold;
    procedure SendGetShuffleItem(itemid: Integer);
    // 摊位
    procedure SendStallPutOn(MakeIndex: Integer; gold, GameGold: Integer);
    procedure SendStallUpdate(MakeIndex: Integer;
      GoldPrice, GameGoldPrice: Integer);
    procedure SendStallBuy(const StallUserName: String;
      MakeIndex, count: Integer);
    procedure SendStallPutOff(MakeIndex: Integer);
    procedure SendStallBuyPutOn(GoldPrice, GameGoldPrice, count: Integer;
      const AName: String);
    procedure SendStallBuyUpdate(AIndex, count, GoldPrice,
      GameGoldPrice: Integer; const AName: String);
    procedure SendStallBuyPutOff(AIndex: Integer; const AName: String);
    procedure SendStallSaleToBuy(MakeIndex, AIndex: Integer;
      const StallUserName: String);
    procedure SendStallMessage(const AStallName, AMessage: String);
    procedure SendStallStart;
    procedure SendStallStop;
    procedure SendStallGetBack;
    // 邮箱
    procedure SendGetMailList;
    procedure SendGetMailData(Index: Integer);
    procedure SendDelMail(Index: Integer);
    procedure SendDelAllMail;
    procedure SendExtrAttMail(Index: Integer);
    procedure SendNewMail(const MailTo, Subject, Context: String;
      Item: TClientItem; GoldType, GoldCount, BuyAttGoldType,
      BuyAttGold: Integer);
    procedure CloseTopMost;

    procedure AddFriend(const AName: String);
    procedure AddEnemiy(const AName: String);
    procedure RemoveFriend(const AName: String);
    procedure RemoveEnemiy(const AName: String);
    // 特殊控制
    procedure SendAltLButtonUseItem(where, MakeIndex: Integer);
    procedure SendAltLButtonBagItem(Index, MakeIndex: Integer);
    // 发送骰子播放完成消息
    procedure SendAfterPlayDice(ATag, APoint1, APoint2, APoint3: Integer);
    procedure SendSideButtonClick(const AName: String);
    procedure SendGuildExtendButtonClick;
    procedure InitDisplaySet();
    procedure ActorCharDescChange(Msg: TDefaultMessage;
      const sBody: PPlatfromString);
    procedure StartBeCool(Open: Boolean);
    procedure OnMySelfLevelChange(nLevel: Integer); // 等级变更
    procedure OnGetUIProperty(const UIName,Prop:String);
    procedure ClientGetActorTitleEffects(Recog : Integer ; const Config:String);
    procedure SendUseSkill(ID,Level,TargetID,X,Y:Integer ; Direction:Byte);//发送使用技能。
    function SpellMagic(Magic: PTClientMagic;AEffNumber, ATargx, ATargY, ATargId: Integer ): Boolean;
    procedure ActorNewSpellSkill(Source:TActor;AMagic: PTClientMagic;ASkillLevel:TSkillLevel);//某个玩家使用技能 可以是g_MySelf
    procedure CheckHackTime();
{$IFDEF DEBUG}
    procedure DumpSocket();
{$ENDIF}

{$IFDEF DEVMODE}
    function DirectionKeyDown(K: Integer): Boolean;
{$ENDIF}
  end;

procedure PomiTextOut(DSurface: TAsphyreCanvas; X, Y: Integer; str: string);
procedure DebugOutStr(Msg: string);
procedure ExceptionOutStr(const Msg: string);

var
  frmMain: TfrmMain;
  DScreen: TDrawScreen;
  IntroScene: TIntroScene;
  LoginScene: TCustomLoginScene;
  SelectChrScene: TSelectChrScene;
  PlayScene: TPlayScene;
  LoginNoticeScene: TLoginNotice;
  LocalLanguage: TImeMode = imChinese;
  EventMan: TClEventManager;
  Map: TMap;
  m_boPasswordIntputStatus: Boolean = False;
  btRunHook: Byte = 0;

implementation

uses FState, uMD5, uDXVersion, uVerExtactor, CliMachineCode,
  OverbyteIcsHttpProt,
  AsphyreTextureFonts, RegularExpressions, uCliOrders, StandardAssistantFrm,
  clGuild, ExtUI,ClientCC,SystemCC,
  VMProtectSDK, NewItemDlg, {$IFDEF DEVMODE}DlgConfig, {$ENDIF}MsgHeaderConvert,
  uSyTickCount, uGameClientPaxType {$IF USE_SNAPPY = 1}, snappy {$IFEND};

procedure OnScriptButtonClick(Sender : TDControl ; FunctionName: String);
var
  DParent : TDControl;
  S:TStringList;
  Temp , RealFunction : string;
  I,K : Integer;
begin
  S := TStringList.Create;
  Try
    DParent := Sender.DParent;
    RealFunction := '';
    ArrestStringToList(FunctionName,'<','>',S);
    Temp := '';
    for K := 0 to S.Count - 1 do
    begin
      Temp := Trim(S[k]);
      if (Temp <> '') and (Temp[1] = '#') then
      begin
        Temp := '<' + Temp + '>';
        for i := 0 to g_DWinMan.DXControls.Count - 1 do
        begin
          if g_DWinMan.DXControls[i] is TDEdit then
          begin
            if CompareText(g_DWinMan.DXControls[i].Propertites.VarFlag,Temp) = 0 then
            begin
              RealFunction := RealFunction + TDEdit(g_DWinMan.DXControls[i]).Text;
            end;
          end;
        end;
      end else
      begin
        RealFunction := RealFunction + Temp;
      end;
    end;
    frmMain.SendClientMessage(CM_ScriptButton, 0, 0, 0, 0,
     EdCode.EncodeString(RealFunction));
  finally
   S.Free;
  end;
end;

procedure OnUIShowHint(Sender : TDControl ; X,Y:Integer);
var
  HintStr : string;
begin
  if Sender is TDExtendButton then
  begin
    if TDExtendButton(Sender).IsExtended then
      HintStr := TDExtendButton(Sender).Propertites.ExtendHint
    else
      HintStr :=  TDExtendButton(Sender).Propertites.Hint;
  end else
  begin
    HintStr :=  Sender.Propertites.Hint;
  end;

  DScreen.ShowHint(X,Y,HintStr);
end;


procedure DoClientMakeClientItem(IsItem: Boolean; const Value: String;
  var ClientItem: TClientItem);
var
  Index: Integer;
begin
  if IsItem then
    DecodeClientItem(Value, ClientItem)
  else
  begin
    Index := StrToIntDef(Value, -1);
    if Index = -1 then
      Index := GetItemIndexByName(Value);
    if Index > -1 then
    begin
      ClientItem.Index := Index;
      ClientItem.Name := ClientItem.S.Name;
      ClientItem.MakeIndex := -Random(100000);
      // 叠加物品只显示 1
      case ClientItem.S.StdMode of
        0, 1, 3, 42:
          ClientItem.Dura := 1;
      else
        ClientItem.Dura := ClientItem.S.DuraMax;
      end;
      ClientItem.DuraMax := ClientItem.S.DuraMax;
    //  ClientItem.BindState := 0;
      ClientItem.Limit := 0;
      FillChar(ClientItem.AddValue[0], SizeOf(TAddValue), #0);
      FillChar(ClientItem.AddPoint[0], SizeOf(TAddPoint), #0);
      FillChar(ClientItem.AddHold[0], SizeOf(TAddHold), -1);
    end;
  end;
end;

procedure DoClientItemNameProc(ClientItem: TClientItem;
  var ADisplayName: String);
begin
  ADisplayName := ClientItem.DisplayName;
end;

{$R *.DFM}

procedure PomiTextOut(DSurface: TAsphyreCanvas; X, Y: Integer; str: string);
var
  i, n: Integer;
  d: TAsphyreLockableTexture;
begin
  if Length(str) <= 0 then
    Exit;
  for i := 1 to Length(str) do
  begin
    n := Byte(str[i]) - Byte('0');
    if (n >= 0) and (n <= 9) then
    begin
      d := g_WMainImages.Images[30 + n];
      if d <> nil then
        DSurface.Draw(X + i * 8, Y, d);
    end
    else
    begin
      if str[i] = '-' then
      begin
        d := g_WMainImages.Images[40];
        if d <> nil then
          DSurface.Draw(X + i * 8, Y, d);
      end;
    end;
  end;
end;

procedure DebugOutStr(Msg: string);
var
  flname: string;
  fhandle: TextFile;
begin
  flname := BugFile;
  if FileExists(flname) then
  begin
    AssignFile(fhandle, flname);
    Append(fhandle);
  end
  else
  begin
    AssignFile(fhandle, flname);
    Rewrite(fhandle);
  end;
  WriteLn(fhandle, TimeToStr(Time) + ' ' + Msg);
  CloseFile(fhandle);
end;

procedure ExceptionOutStr(const Msg: string);
var
  flname: string;
  fhandle: TextFile;
begin
  flname := '!91Exception.log';
  if FileExists(flname) then
  begin
    AssignFile(fhandle, flname);
    Append(fhandle);
  end
  else
  begin
    AssignFile(fhandle, flname);
    Rewrite(fhandle);
  end;
  WriteLn(fhandle, DateTimeToStr(Now()) + ' ' + Msg);
  CloseFile(fhandle);
end;

function KeyboardHookProc(Code: Integer; WParam: Longint; LParam: Longint)
  : Longint; stdcall;
begin
  Result := 0;
  case WParam of
    VK_F12:
      begin
        if (HC_ACTION = Code) then
        begin
          if GetKeyState(WParam) < 0 then
          begin
            if g_MirStartupInfo.AssistantKind = 1 then
              StandardAssistantFrm.TStandardAssistantForm.Execute()
              // frmMain.OpenSdoAssistant
            else
            begin
              frmMain.OpenSdoAssistant;
            end;
            // OutputDebugString('RunHook');
          end;

        end;
      end;
  end;

  if ((WParam = 9) { or (WParam = 13) } ) and (g_nLastHookKey = 18) and
    (GetTickCount - g_dwLastHookKeyTime < 500) then
  begin
    if frmMain.WindowState <> wsMinimized then
    begin
      frmMain.WindowState := wsMinimized;
    end
    else
    begin
      Result := CallNextHookEx(g_ToolMenuHook, Code, WParam, LParam);
    end;
    Exit;
  end;
  g_nLastHookKey := WParam;
  g_dwLastHookKeyTime := GetTickCount;

  Result := CallNextHookEx(g_ToolMenuHook, Code, WParam, LParam);
end;

procedure ExtractResources(const APath: String);
var
  R: TResourceStream;
begin
  try
    if not FileExists(APath + 'Wav\Notify.mp3') then
    begin
      if not IOUtils.TDirectory.Exists(APath + 'Wav\') then
        IOUtils.TDirectory.CreateDirectory(APath + 'Wav\');
      R := TResourceStream.Create(HInstance, 'NOTIFY_MP3', RT_RCDATA);
      try
        R.SaveToFile(APath + 'Wav\Notify.mp3');
      finally
        FreeAndNilEx(R);
      end;
    end;
  except
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  flname: string;
  ExStyle: Integer;
  L: TStrings;
  P: TPngImage;
  ALogoLoaded: Boolean;
begin
  {$IFDEF DEVMODE}
    Visible := False;
  {$ENDIF}

  Set8087CW($133F);
{$IF USECURSOR = DEFAULTCURSOR}
  Screen.Cursor := crDefault;
{$IFEND}
  InitDisplaySet();
  FSpeedWarning := uEDCode.DecodeSource
    ('+NCAPDqW3b2PsTyoWsQXwsluxTEwySJz/vrkmeWUm1eehVu/SZt4KzQeGBtuRGXjkZHc7uRfyqWVYA==');

  FMachineCode := __LocalMachineCode;
{$IFDEF PAXCOMPLIER}
  LoadUIScript;
{$ENDIF}
  ExStyle := GetWindowLong(Application.Handle, GWL_EXSTYLE);
  ExStyle := ExStyle or WS_EX_TOOLWINDOW;
  SetWindowLong(Application.Handle, GWL_EXSTYLE, ExStyle);
  FSocketSection := TFixedCriticalSection.Create;
  Color := clWhite;
  Canvas.Font.Assign(Font);
  FCheckLibTime := GetTickCount;
  g_Application := Self;
  FLastDialogItem := nil;
  Randomize;
  ClientItemMaker := DoClientMakeClientItem;
  ClientItemNameProc := DoClientItemNameProc;
  SetNetPassWord(g_MirStartupInfo.sServerKey);
  if g_MirStartupInfo.nScreenWidth < 800 then
    g_MirStartupInfo.nScreenWidth := 800;
  if g_MirStartupInfo.nScreenHegiht < 600 then
    g_MirStartupInfo.nScreenHegiht := 600;
  SCREENWIDTH := g_MirStartupInfo.nScreenWidth;
  SCREENHEIGHT := g_MirStartupInfo.nScreenHegiht;
  g_boFullScreen := g_MirStartupInfo.boFullScreen;
  g_sServerAddr := g_MirStartupInfo.sServeraddr;
  g_nServerPort := g_MirStartupInfo.nServerPort;
  g_NewUI := g_MirStartupInfo.btMainInterface = 1;

  DWinCtl.GetClipValueProc := MShare.GetMySelfClipValue;
  // UI设置
  g_DWinMan.UIType := skNormal;
  case g_MirStartupInfo.btClientStyle of
    0:
      g_DWinMan.UIType := skNormal;
    1:
      g_DWinMan.UIType := skMir4;
    2:
      g_DWinMan.UIType := skReturn;
  end;

  // 装备UI
  g_DWinMan.StateWinType := wk195;
  case g_MirStartupInfo.btEquipStyle of
    0:
      g_DWinMan.StateWinType := wk195;
    1:
      g_DWinMan.StateWinType := wk185;
    2:
      g_DWinMan.StateWinType := wk176;
  end;

  if g_MirStartupInfo.boAutoClientStyle then
    g_DWinMan.UIType := uVerExtactor._ExtractClientVer(g_DWinMan.UIType);



  ALogoLoaded := False;
  if (g_MirStartupInfo.sLogo <> '') and FileExists(g_MirStartupInfo.sLogo) then
  begin
    try
      ImageLogo.Picture.LoadFromFile(g_MirStartupInfo.sLogo);
      ALogoLoaded := True;
    except
    end;
    DeleteFile(g_MirStartupInfo.sLogo);
  end;

  try
    if not ALogoLoaded then
    begin
      P := TPngImage.Create;
      P.LoadFromResourceName(HInstance, 'LOGO');
      ImageLogo.Picture.Graphic := P;
      P.Free;
    end;
  except
  end;

  FBreakOff := False;
  ResourceDir := ExcludeTrailingPathDelimiter
    (StringReplace(g_MirStartupInfo.sResourceDir, '/', '\', [rfReplaceAll]));
  repeat
    if (ResourceDir <> '') and (ResourceDir[1] in ['.', '\']) then
      Delete(ResourceDir, 1, 1);
  until (ResourceDir = '') or not(ResourceDir[1] in ['.', '\']);
  if ResourceDir = '' then
    ResourceDir := '91Resource';
  ResourceDir := IncludeTrailingPathDelimiter(ResourceDir);
  WIL.ResDir := ResourceDir;
  Wil.ExceptionOut := ExceptionOutStr;
  DWinCtl.ResourceDir := ResourceDir;

  UserCfgDir := ResourceDir + 'Users\';
  FAppTerminated := False;
  InitApplication;
  ExtractResources(ResourceDir);

  // 获取客户端所有资源文件目录
  WIL.GetClientLibFile(ResourceDir);

  //如果加载微端版本文件没有成功那么直接关闭微端。
  if not LibManager.LoadMiniImageFile(WIL.ResDir + 'MiniVer.91Ver' ) then
  begin
    ConsoleDebug(Format('因为没有在资源目录下:%s,发现有微端控制信息,所以设置微端关闭',[WIL.ResDir]));
    g_MirStartupInfo.boMini := False;
  end;

  g_LocalMessager.SetMini(g_MirStartupInfo.boMini);
  if g_MirStartupInfo.nLocalMiniPort > 0 then
  begin
    g_LocalMessager.SetPort(g_MirStartupInfo.nLocalMiniPort);
    g_LocalMessager.Open;
    ConsoleDebug(Format('设置本地通信:%d',[g_MirStartupInfo.nLocalMiniPort]));
  end;


  Randomize;
  g_DWinMan.OnClickSound := OnClickSound;
  ExtUI.GetStateWinDrawIndexFunc := FState.GetDrawStatePic;
  ExtUI.DrawItemImageProc := FState.DrawItemUI;
  DWinCtl.ScriptButtonClick := OnScriptButtonClick;
  DWinCtl.MouseMoveShowHintProc := OnUIShowHint;

  Caption := g_MirStartupInfo.sServerName;
  if g_boFullScreen then
  begin
    if (Screen.MonitorCount > 0) then
    begin
      BorderStyle := bsNone;
      Left := Screen.Monitors[0].Left;
      Top := Screen.Monitors[0].Top;
      Width := Screen.Monitors[0].Width;
      Height := Screen.Monitors[0].Height;
    end;
  end
  else
  begin
    BorderStyle := bsSingle;
    ClientWidth := SCREENWIDTH;
    ClientHeight := SCREENHEIGHT;
  end;
  ImageLogo.Left := (ClientWidth - ImageLogo.Width) div 2;
  ImageLogo.Top := (ClientHeight - ImageLogo.Height) div 2;
  DISPLAYSIZETYPE := 0;
  if (SCREENWIDTH < 1024) and (SCREENHEIGHT < 768) then
  begin
    if SCREENWIDTH < 960 then
      DISPLAYSIZETYPE := 2
    else
      DISPLAYSIZETYPE := 1;
  end;

  // NpcImageList:=TList.Create;
  // ItemImageList:=TList.Create;
  // WeaponImageList:=TList.Create;
  // HumImageList:=TList.Create;
  // DXDraw.Display.Width := SCREENWIDTH;
  // DXDraw.Display.Height := SCREENHEIGHT;
  //
  g_ToolMenuHook := SetWindowsHookEx(WH_KEYBOARD, @KeyboardHookProc, 0,
    GetCurrentThreadID);
  FDlgMessageList := TList.Create;
  g_SoundManager.Path := '';
  g_SoundManager.LoadSoundList('wav\sound.lst');
  g_SoundManager.LoadSkillSoundEffectList('wav\91Sound.lst');
  DScreen := TDrawScreen.Create;
  IntroScene := TIntroScene.Create;
  LoginScene := MShare.CreateLoginScene;
  SelectChrScene := MShare.CreateSelectChrScene;
  LoginNoticeScene := MShare.CreateLoginNotice;
  PlayScene := TPlayScene.Create;
  Map := TMap.Create;
  g_DropedItemList := TList.Create;
  g_MagicList := TList.Create;
  g_ActiveTitle := 0;
  g_TitlesPage := 0;
  g_Titles := TList.Create;
  g_InternalForceMagicList := TList.Create;
  g_HeroInternalForceMagicList := TList.Create;
  g_BatterMagicList := TList.Create;
  g_BatterMenuNameList := TStringList.Create;
  g_HeroBatterMenuNameList := TStringList.Create;
  g_HeroBatterMagicList := TList.Create;
  g_HeroMagicList := TList.Create;

  // 2007.10.25增加英雄技能表初始化
  g_ShopItemList := TList.Create;
  // 商铺物品列表初始化 清清 2007.11.14
  g_NpcRandomDrinkList := TList.Create;
  // 初始化酒馆NPC随机选酒 20080518
  g_AutoPickupList := TList.Create;
  g_ShopSpeciallyItemList := TList.Create;

  g_Orders := TuOrderObject.Create;

  { ****************************************************************************** }
  EventMan := TClEventManager.Create;
  g_ChangeFaceReadyList := TList.Create;
  g_Servers := TStringList.Create;
  g_MySelf := nil;
  { ****************************************************************************** }
  FillChar(g_SellOffItems[0], SizeOf(g_SellOffItems), #0); // 初始化寄售物品
  FillChar(g_UseItems[0], SizeOf(g_UseItems), #0);
  FillChar(g_BoxsItems[0], SizeOf(g_BoxsItems), #0); // 释放宝箱物品
  FillChar(g_SellOffItems[0], SizeOf(g_SellOffItems), #0); // 释放寄售窗口物品 20080318
  FillChar(g_SellOffInfo, SizeOf(TClientDealOffInfo), #0); // 清空寄售列表物品 20080318
  FillChar(g_ItemArr[0], SizeOf(g_ItemArr), #0);
  FillChar(g_DealItems[0], SizeOf(g_DealItems), #0);
  FillChar(g_DealRemoteItems[0], SizeOf(g_DealRemoteItems), #0);
  FillChar(g_ChallengeItems[0], SizeOf(g_ChallengeItems), #0);
  FillChar(g_ChallengeRemoteItems[0], SizeOf(g_ChallengeRemoteItems), #0);

  g_MenuItemList := TList.Create;
  g_WaitingUseItem.Item.Name := '';
  g_EatingItem.Name := '';
  g_nTargetX := -1;
  g_nTargetY := -1;
  g_TargetCret := nil;
  g_FocusCret := nil;
  g_MagicLockActor := nil;
  g_FocusItem := nil;
  g_MagicTarget := nil;
  g_LastSelNPC := nil;
  g_LastNpcClick := 0;
  g_boServerChanging := False;
  g_boBagLoaded := False;
  g_boAutoDig := False;
  g_boPutBoxsKey := False; // 宝箱钥匙 2008.01.16
  g_boBoxsFlash := False; // 宝箱物品闪烁 2008.01.16
  g_nDayBright := 3; // 广
  g_nAreaStateValue := 0;
  g_ConnectionStep := cnsLogin;
  g_boSendLogin := False;
  g_boServerConnected := False;
  SocStr := '';
  ActionFailLock := False;
  g_boMapMoving := False;
  g_boMapMovingWait := False;
  // g_boCheckSpeedHackDisplay := FALSE;
  g_boViewMiniMap := False;
  g_boTransparentMiniMap := False;
  FailDir := 0;
  FailAction := 0;
  g_nDupSelection := 0;

  FMessageIndex := 0;
  g_uPointList := TList<PPoint>.Create;

  // ======双英雄=============//
  g_HeroAutoTrainingNum := 0;
  // =========================//
  g_dwAutoPickupTick := GetTickCount;
  g_boItemMoving := False;
  g_boDoFadeIn := False;
  g_boDoFadeOut := False;
  g_boDoFastFadeOut := False;
  // g_boAttackSlow := FALSE;   //20080816 注释 腕力不足
  // g_boMoveSlow := False; 20080816注释掉起步负重
  g_SoftClosed := False;
  g_boQueryPrice := False;
  g_sSellPriceStr := '';

  g_boAllowGroup := False;
  g_boAllowDeal := False;
  g_boAllowGuild := False;
  g_GroupMembers := TList<PTGroupUser>.Create;
  { ****************************************************************************** }
  // 连击相关
  g_boUseBatter := False;
  g_boCanUseBatter := False;
  g_nBatterX := 0;
  g_nBatterY := 0;
  g_BatterDir := 0;
  g_nBatterTargetid := 0;
  ZeroMemory(@g_MyPulse, SizeOf(THumPulses));
  ZeroMemory(@g_MyHeroPulse, SizeOf(THumPulses));
  g_boisOpenPuls := False;
  LastActorClkTick := 0;
  g_SkillData := TSkillManager.Create;
  g_SkillEffectData := TSkillEffectManager.Create;
  // g_BatterOrder
  // g_HeroBatterOrder
  { ****************************************************************************** }
  // 盔努腐, 内齿岿靛 殿..
  FAutoRunner := TuAutoRunner.Create;
  FRunRoutes := TStringList.Create;
  CSocket := uSocket.TuClientSocket.Create(Self);
  CSocket.OnConnect := CSocketSessionConnected;
  CSocket.OnDisconnect := CSocketSessionClosed;
  CSocket.OnError := CSocketError;
  CSocket.OnRead := CSocketDataAvailable;
  Application.OnActivate := DoAppActivate;
  Application.OnDeactivate := DoAppDeactivate;
  Application.OnMinimize := DoAppMinimize;
  Application.OnRestore := DoAppRestore;
  Application.OnIdle := OnIdle;
  Self.Color := clBlack;

  if uDXLoader.LoadDirectX then
  begin
    EventAsphyreCreate.Subscribe(ClassName, OnAsphyreCreate);
    EventAsphyreDestroy.Subscribe(ClassName, OnAsphyreDestroy);
    EventDeviceInit.Subscribe(ClassName, OnDeviceInit);
    EventDeviceCreate.Subscribe(ClassName, OnDeviceCreate);
    EventDeviceDestroy.Subscribe(ClassName, OnDeviceDestroy);
    EventDeviceLost.Subscribe(ClassName, OnDeviceDestroy);
    EventDeviceReset.Subscribe(ClassName, OnDeviceCreate);
    EventDeviceLost.Subscribe(ClassName, OnEventDeviceLost);
    FailureHandled := False;

    FTimerSpeedCheck := TTimer.Create(Self);
    FTimerSpeedCheck.Interval := 50;
    FTimerSpeedCheck.OnTimer := TimerSpeedCheckTimer;
    FSpeedTick := GetTickCount;
    FSpeedTime := Now;
    FSpeedError := 0;
    FTimerSpeedCheck.Enabled := True;
  end
  else
  begin
    Application.MessageBox('DirectX装载失败，请确认机器是否安装DirectX9！', '提示', MB_OK);
    Application.Terminate;
  end;

  InitPassWordFile(g_MirStartupInfo.PassWordFileName);
  OnLineTimeCheck := TOnlineTimeCheck.Create;
  FCheckHackTimeThread := TThread.CreateAnonymousThread(CheckHackTime);
  FCheckHackTimeThread.Start;
end;

procedure GetBeijTime(var ATime: String);
var
  AHttp: THttpCli;
  S: String;
  AValue: Int64;
  d: TDateTime;
begin
  ATime := 'A';
  AHttp := THttpCli.Create(nil);
  try
    AHttp.Agent :=
      'Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20100101 Firefox/8.0';
    AHttp.RcvdStream := TStringStream.Create;
    AHttp.URL := uEDCode.DecodeSource
      ('mcOnytvcns/7laFSga4hqs+MF9bNLRN5SlHCGqX+8Hvqk49weCYpbOq9YXKkqo0IutIMCK//KxjsECaTUlQlOa2lnPZum1r/bDz/myR+Xinmzvk7ttTrYfE6')
      + IntToStr(Random(1000000));
    AHttp.NoCache := True;
    try
      AHttp.Get;
      AHttp.RcvdStream.Seek(0, soBeginning);
      S := TStringStream(AHttp.RcvdStream).DataString;
      with RegularExpressions.TRegEx.Match(S, 'baidu_time\((\d+)\)') do
      begin
        if Success then
        begin
          AValue := StrToInt64Def(Groups[1].Value, -1);
          if AValue <> -1 then
          begin
            d := ((25569.333333 * MSecsPerDay) + AValue) / MSecsPerDay;
            ATime := FormatDateTime('yyyy-MM-dd hh:mm:ss', d);
          end;
        end;
      end;
    except
      ATime := 'A';
    end;
  finally
    AHttp.RcvdStream.Free;
    FreeAndNilEx(AHttp);
  end;
end;


procedure TfrmMain.DoAppActivate(Sender: TObject);
begin
  if WindowState <> wsMinimized then
  begin
    if g_SoundManager.Silenced then
      g_SoundManager.Silenced := False;
  end;
end;

procedure TfrmMain.DoAppDeactivate(Sender: TObject);
begin
  if WindowState <> wsMinimized then
  begin
    if not g_SoundManager.Silenced then
      g_SoundManager.Silenced := True;
  end;
end;

procedure TfrmMain.DoAppRestore(Sender: TObject);
begin
  if g_SoundManager.Silenced then
    g_SoundManager.Silenced := False;
end;

procedure TfrmMain.DoAppMinimize(Sender: TObject);
begin
  if not g_SoundManager.Silenced then
    g_SoundManager.Silenced := True;
end;

procedure TfrmMain.AddToChatBoardString(const Message: String;
  FColor, BColor: TColor);
begin
  AddChatBoardString(Message, FColor, BColor);
end;

procedure TfrmMain.LibMemoryCheckTimerTimer(Sender: TObject);
begin
  LibManager.FreeMemory;
end;

procedure TfrmMain.LoadImage(const FileName: String; Index, Position: Integer);
begin
  LibManager.LoadImage(FileName, Index, Position); // todo
end;

procedure TfrmMain.Terminate;
begin
  Application.Terminate;
end;

procedure TfrmMain.CSocketDataAvailable(Sender: TObject;
  Socket: TCustomWinSocket);
{$I __MakeTokenID.INC}
{$I __GetTokenID.INC}
var
  n: Integer;
  AData, AData2: AnsiString;
  nRecvCount: Integer;
  PMem: PAnsiChar;
begin
  FSocketSection.Enter;
  try
    if g_ConnectionStep <> cnsPlay then
    begin
      FTransDataTime := GetTickCount;
      AData := CSocket.ReceiveText;
      if FNeedTokenID and (g_ConnectionStep = cnsLogin) then
      begin
        try
          AData := Copy(AData, 2, Length(AData) - 2);
          AData := __GetTokenID(AData);
          SendSocket(__MakeTokenID(AData));
          FNeedTokenID := False;
        except
        end;
        Exit;
      end;

      if not FBreakOff then
      begin
        n := Pos('*', AData);
        if n > 0 then
        begin
          AData2 := Copy(AData, 1, n - 1);
          AData := AData2 + Copy(AData, n + 1, Length(AData));
          CSocket.SendText('*');
        end;
        SocStr := SocStr + AData;
      end;
    end
    else
    begin // 游戏网关中的封包不一样  随云
      nRecvCount := CSocket.Socket.ReceiveLength;

      // 如果Socket 的缓冲区不够本次接收了 那就先接收到临时内存块
      if nRecvCount > g_SocketBuffer.LeftSize then
      begin
        GetMem(PMem, nRecvCount);
        CSocket.Socket.ReceiveBuf(PMem^, nRecvCount);
        g_SocketBuffer.Append(PMem, nRecvCount);
        FreeMem(PMem);
      end
      else
      begin // 如果缓冲区可以接受 那么直接接受到缓冲区
        CSocket.Socket.ReceiveBuf(g_SocketBuffer.OffsetMemory^, nRecvCount);
        g_SocketBuffer.SizeAdd(nRecvCount);
      end;

    end;
  finally
    FSocketSection.Leave;
  end;
end;

procedure TfrmMain.CSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  // case ErrorCode of
  // 10038: ;
  // 10061, 10060:
  // begin
  // if FTryReconnet and (g_ConnectionStep = cnsPlay) then
  // TryConnectNextRoute
  // else
  // begin
  // CSocket.Close;
  // if FrmDlg.DMessageDlg('无法连接服务器，请重新登录游戏！！！', [mbOk]) = mrOK then
  // Application.Terminate;
  // end;
  // end;
  // else
  // begin
  // if FTryReconnet and (g_ConnectionStep = cnsPlay) then
  // TryConnectNextRoute
  // else
  // begin
  // CSocket.Close;
  // if FrmDlg.DMessageDlg('连接断开，请重新登录游戏！！！', [mbOk]) = mrOK then
  // Application.Terminate;
  // end;
  // end;
  // end;
  CSocket.Close;
  ErrorCode := 0;
end;

procedure TfrmMain.TryConnectNextRoute;
begin
end;

procedure TfrmMain.CSocketSessionClosed(Sender: TObject;
  Socket: TCustomWinSocket);
var
  APort: String;
begin
  g_boServerConnected := False;
  CloseTimer.Enabled := True;
  if g_SoftClosed then
  begin
    g_SoftClosed := False;
    ActiveCmdTimer(tcReSelConnect);
  end;
  if not FNetChanging then
  begin
    if (g_ConnectionStep = cnsPlay) and (FRunRoutes.count > 1) then
      ActiveCmdTimer(tcReConnect)
    else if FrmDlg.DMessageDlg
      ('连接断开，请重新登录游戏！！！' { + IntToStr(Socket.RemotePort) } , [mbOk]) = mrOK then
      Application.Terminate;
  end;
end;

procedure TfrmMain.CSocketSessionConnected(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  g_boServerConnected := True;
  FAutoRunner.Enabled := False;
  case g_ConnectionStep of
    cnsLogin:
      begin
        if g_UIInitialized then
          DScreen.ChangeScene(stLogin);
      end;
    cnsSelChr:
      begin
        SendSocket(EdCode.EncodeString(SessionID));
        LoginScene.OpenLoginDoor;
        SelChrWaitTimer.Enabled := True;
      end;
    cnsReSelChr:
      begin
        SendSocket(EdCode.EncodeString(SessionID));
        CmdTimer.Interval := 1;
        ActiveCmdTimer(tcFastQueryChr);
      end;
    cnsPlay:
      begin
        VMProtectBeginVirtualization('OnConnectedRunGate');
        g_GameData.SendPackageIndex.Data := 1; // RunGate 需要序号对
        SendSocket(EdCode.EncodeString(SessionID));
        if not g_boServerChanging then
        begin
          ClearBag;
          DScreen.ClearChatBoard;
          DScreen.ChangeScene(stLoginNotice);
        end
        else if not FTryReconnet then
          ChangeServerClearGameVariables;
        SendRunLogin;
        VMProtectEnd();
      end;
  end;
  SocStr := '';
  BufferStr := '';
end;

procedure TfrmMain.FormDblClick(Sender: TObject);
var
  pt: TPoint;
begin
  if FTryReconnet then
    Exit;
  OutputDebugString(PChar('系统双击开始'));
  GetCursorPos(pt);
  pt := ScreenToClient(pt);
  pt.X := Round(SCREENWIDTH / ClientWidth * pt.X);
  pt.Y := Round(SCREENHEIGHT / ClientHeight * pt.Y);
  g_DWinMan.DblClick(pt.X, pt.Y);

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  i: Integer;
  AList: TList;
begin
  Reset8087CW;
  FAppTerminated := True;
  FCheckHackTimeThread.Terminate;
  FreeAndNilEx(CSocket);
  FreeAndNilEx(g_AutoPickupList);
  g_AutoPickupList := nil;
  if g_ToolMenuHook <> 0 then
    UnhookWindowsHookEx(g_ToolMenuHook);
  DecodeTimer.Enabled := False;
  RunTimer.Enabled := False;
  UnLoadWMImagesLib();
  DScreen.Finalize;
  PlayScene.Finalize;
  LoginNoticeScene.Finalize;
  FreeAndNilEx(DScreen);
  FreeAndNilEx(IntroScene);
  FreeAndNilEx(LoginScene);
  FreeAndNilEx(SelectChrScene);
  FreeAndNilEx(PlayScene);
  FreeAndNilEx(LoginNoticeScene);
  FreeAndNilEx(g_MenuItemList);
  FreeAndNilEx(FAutoRunner);
  FreeAndNilEx(FRunRoutes);
  FreeAndNilEx(Map);
  ClearDialogMessages;
  FreeAndNilEx(FDlgMessageList);
  g_HeroBatterMenuNameList.Free;
  g_BatterMenuNameList.Free;
  g_BatterMagicList.Free;
  g_HeroBatterMagicList.Free;
  g_SkillData.Free;
  g_SkillEffectData.Free;
  for i := 0 to g_DropedItemList.count - 1 do
  begin // 20080718释放内存
    if PTDropItem(g_DropedItemList.Items[i]) <> nil then
    begin
      System.Finalize(PTDropItem(g_DropedItemList[i])^);
      Dispose(PTDropItem(g_DropedItemList.Items[i]));
    end;
  end;
  FreeAndNilEx(g_DropedItemList);

  for i := 0 to g_MagicList.count - 1 do
  begin
    if PTClientMagic(g_MagicList.Items[i]) <> nil then
      Dispose(PTClientMagic(g_MagicList.Items[i]));
  end;
  FreeAndNilEx(g_MagicList);

  for i := 0 to g_Titles.count - 1 do
  begin
    if pTClientHumTitle(g_Titles.Items[i]) <> nil then
      Dispose(pTClientHumTitle(g_Titles.Items[i]));
  end;
  FreeAndNilEx(g_Titles);

  if g_InternalForceMagicList.count > 0 then
  begin
    for i := 0 to g_InternalForceMagicList.count - 1 do
    begin
      if PTClientMagic(g_InternalForceMagicList.Items[i]) <> nil then
        Dispose(PTClientMagic(g_InternalForceMagicList.Items[i]));
    end;
  end;
  FreeAndNilEx(g_InternalForceMagicList);

  if g_HeroInternalForceMagicList.count > 0 then
  begin
    for i := 0 to g_HeroInternalForceMagicList.count - 1 do
    begin
      if PTClientMagic(g_HeroInternalForceMagicList.Items[i]) <> nil then
        Dispose(PTClientMagic(g_HeroInternalForceMagicList.Items[i]));
    end;
  end;
  FreeAndNilEx(g_HeroInternalForceMagicList);

  for i := 0 to g_HeroMagicList.count - 1 do
  begin
    if PTClientMagic(g_HeroMagicList.Items[i]) <> nil then
      Dispose(PTClientMagic(g_HeroMagicList.Items[i]));
  end;
  FreeAndNilEx(g_HeroMagicList);

  ClearShopItems;
  FreeAndNilEx(g_ShopItemList);

  FreeAndNilEx(g_NpcRandomDrinkList);
  ClearShopSpeciallyItems;
  FreeAndNilEx(g_ShopSpeciallyItemList);
  FreeAndNilEx(g_Orders);

  ClearAutoRunPointList;
  FreeAndNilEx(g_uPointList);
  FreeAndNilEx(g_ChangeFaceReadyList);
  FreeAndNilEx(g_Servers);
  FreeAndNilEx(g_GroupMembers); // 20080528
  FreeAndNilEx(g_SoundManager);
  FreeAndNilEx(EventMan);
  FreeAndNilEx(g_DWinMan);
  FreeAndNilEx(FSocketSection);
  if (Assigned(g_GameDevice)) then
    g_GameDevice.DisConnect();
  NativeAsphyreConnect.Done();
  EventProviders.Unsubscribe(ClassName);
  OnLineTimeCheck.Free;
  Application.Terminate;
end;

{ function ComposeColor(Dest, Src: TRGBQuad; Percent: Integer): TRGBQuad;
  begin
  with Result do
  begin
  rgbRed := Src.rgbRed+((Dest.rgbRed-Src.rgbRed)*Percent div 256);
  rgbGreen := Src.rgbGreen+((Dest.rgbGreen-Src.rgbGreen)*Percent div 256);
  rgbBlue := Src.rgbBlue+((Dest.rgbBlue-Src.rgbBlue)*Percent div 256);
  rgbReserved := 0;
  end;
  end; }

function TfrmMain.FindItemPack(Item: TClientItem): Integer;
var
  I : Integer;
begin
  Result := -1;
  for i := 0 to MAXBAGITEM - 1  do
  begin
    if (g_ItemArr[i].S.StdMode = 31) and (g_ItemArr[i].AniCount = 1) then
    begin
      if g_ItemArr[i].S.ACMin = Item.Index - 1  then
      begin
        Result := i;
        Break;
      end;
    end;
  end;
end;

procedure TfrmMain.FormClick(Sender: TObject);
var
  pt: TPoint;
begin
//   if FTryReconnet then
//   Exit;
//   GetCursorPos(pt);
//   pt := ScreenToClient(pt);
//   pt.X := Round(SCREENWIDTH / ClientWidth  * pt.X);
//   pt.Y := Round(SCREENHEIGHT / ClientHeight  * pt.Y);
//   if g_DWinMan.Click(pt.X, pt.Y) then Exit;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
  if PopWindowUrl <> '' then
    WinExec(PPlatfromChar('Explorer ' + PopWindowUrl), 0);
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//  CanClose := FTryReconnet or
//    (mrOK = FrmDlg.DMessageDlg('是否确认退出游戏？', [mbOk, mbCancel]));
//  if CanClose and (g_MySelf <> nil) then
//    AppExit;
  if FTryReconnet then
  begin
    CanClose := True;
    Exit;
  end;
  CanClose := False;
  CloseTopMost;
  FrmDlg.DExitGame.Left := (SCREENWIDTH - FrmDlg.DExitGame.WIDTH) div 2;
  FrmDlg.DExitGame.Top := (SCREENHEIGHT - FrmDlg.DExitGame.Height) div 2;
  FrmDlg.DExitGame.Tag := 0;
  FrmDlg.DExitGameHint.Propertites.Caption.Text := '是否确认退出游戏？';
  FrmDlg.HideAllControls();
  FrmDlg.DExitGame.ShowModal();
end;

procedure TfrmMain.AppLogout;
begin
  CloseTopMost;
  FrmDlg.DExitGame.Left := (SCREENWIDTH - FrmDlg.DExitGame.WIDTH) div 2;
  FrmDlg.DExitGame.Top := (SCREENHEIGHT - FrmDlg.DExitGame.Height) div 2;
  FrmDlg.DExitGame.Tag := 1;
  FrmDlg.DExitGameHint.Propertites.Caption.Text := '是否确认退出？';
  FrmDlg.HideAllControls();
  FrmDlg.DExitGame.ShowModal();
//  if mrOK = FrmDlg.DMessageDlg('是否确认退出？', [mbOk, mbCancel]) then
//  begin
//    SendClientMessage(CM_SOFTCLOSE, 0, 0, 0, 0);
//    DScreen.Finalize;
//    g_Config.Save;
//    PlayScene.ClearActors;
//    CloseAllWindows;
//    FrmDlg.DBottom.Visible := False;
//    g_SoftClosed := True;
//    ActiveCmdTimer(tcSoftClose);
//    ClearRelation;
//    ClearMissions;
//    g_SoundManager.Stop;
//  end;
end;

procedure TfrmMain.AppExit;
begin
  SendClientMessage(CM_SOFTEXIT, 0, 0, 0, 0);
  DScreen.Finalize;
  g_Config.Save;
  PlayScene.ClearActors;
  CloseAllWindows;
  FrmDlg.DBottom.Visible := False;
  g_SoftClosed := True;
  ActiveCmdTimer(tcSoftClose);
  ClearRelation;
  ClearMissions;
  g_SoundManager.Stop;
end;

procedure TfrmMain.ApplicationEventException(Sender: TObject; E: Exception);
var
  SendeClassName:String;
begin
  if Sender <> nil then
    SendeClassName := Sender.ClassName
  else
    SendeClassName := 'NULL';

  ExceptionOutStr(format('[Exception] : Sender : %s ExcetionMsg: %s',[SendeClassName,E.Message]));
end;

procedure TfrmMain.PrintScreenNow;
var
  AFileName: String;
  HDC: THandle;
  BitMap: TBitmap;
  X, Y: Integer;
  function IntToStr2(n: Integer): string;
  begin
    if n < 10 then
      Result := '0' + IntToStr(n)
    else
      Result := IntToStr(n);
  end;

  function GetFileName: String;
  begin
    Result := '';
    while True do
    begin
      Inc(g_nCaptureSerial);
      Result := 'Images\Images' + IntToStr2(g_nCaptureSerial) + '.bmp';
      if not FileExists(Result) then
        Break;
    end;
  end;

begin
  if not DirectoryExists('Images') then
    CreateDir('Images');

  AFileName := GetFileName;

  BitMap := TBitmap.Create;
  BitMap.SetSize(SCREENWIDTH, SCREENHEIGHT);
  BitMap.Canvas.CopyRect(BitMap.Canvas.ClipRect, Self.Canvas,
    Self.Canvas.ClipRect);
  BitMap.SaveToFile(AFileName);
  BitMap.Free;
  PrintScreen(SCREENWIDTH, SCREENHEIGHT, AFileName);
  if AFileName <> '' then
  begin
    // if AFileName = 'Error' then
    // AddChatBoardString('[系统]屏幕载图失败', clRed, clWhite)
    // else
    AddChatBoardString('[屏幕载图：' + AFileName + ']', GetRGB(219), clWhite);
  end;
end;

function TfrmMain.ProcessKeyMessages: Boolean;
var
  AMagic: PTClientMagic;
  AClient: TuMagicClient;
  nX,nY:Integer;
  ATargx,ATargY,ATargId,nXY: Integer;
  SkillLevel:TSkillLevel;
  ActType : SpellActionType;
  CanUse:Boolean;
begin
  Result := False;
  if (g_MySelf <> nil) and (g_MySelf.m_btStall > 0) then
    Exit;
  if ActionKey > 0 then
  begin
    AMagic := nil;
    case ActionKey of
      VK_F1 .. VK_F8:
        AMagic := GetMagicByKey(PPlatfromChr((ActionKey - VK_F1) + Byte('1')));
      12 .. 19:
        AMagic := GetMagicByKey(PPlatfromChr((ActionKey - 12) + Byte('1') +
          Byte($14)));
    end;
    if AMagic <> nil then
    begin
      if g_MagicMgr.TryGet(AMagic.wMagicId, AClient) then
      begin
        case AClient.FireType of
          ftNone, ftAfterAttack, ftHitCallNext:
            ;
          ftHit:
            begin
              if CheckMagicTime(AMagic, True) then
                AddNextMagic(AMagic.wMagicId, 0);
            end;
          ftNextHit:
            begin
              if GetTickCount - g_GameData.LastSpellTick.Data > g_GameData.SpellTime.Data  then
              begin
                g_GameData.LastSpellTick.Data := GetTickCount;
                g_dwMagicDelayTime := 0;
                SendSpellMsg(CM_SPELL, g_MySelf.m_btDir, 0,
                  AMagic.wMagicId, 0);
              end;
            end
        else
          begin
            UseMagic(g_nMouseX, g_nMouseY, AMagic, True, True);
          end;
        end;
      end
      else
      if AMagic.boCustomMagic then  //新的自定义技能攻击
      begin

        if not AMagic.boPassive then
        begin
          CanUse := False;
          //特效类型
          if AMagic.btEffectType <= Ord(High(SpellActionType)) then
            ActType := SpellActionType(AMagic.btEffectType)
          else
            ActType := patNone;

          case ActType of
            patSpell,patNone:
            begin
              if CanNextAction(caSpell) and ServerAcceptNextAction then
              begin
                CanUse := True;
              end
            end;
            patAttack,patHeavyHit:
            begin
              if CanNextAction(caHit) and ServerAcceptNextAction then
              begin
                CanUse := True;
              end
            end;
          end;
          if CanUse then
          begin
            if CheckMagicTime(AMagic, True) then
            begin
              g_MySelf.SendMsg(SM_OtherActorSkillSpell,g_MySelf.m_nCurrX,g_MySelf.m_nCurrY,g_MySelf.m_btDir,AMagic.wMagicId,AMagic.Level,Integer(AMagic),0,'',0,0,0);
            end;
          end;
        end;

      end else
        UseMagic(g_nMouseX, g_nMouseY, AMagic, True, True);
    end;
    ActionKey := 0;
    g_nTargetX := -1;
    Result := True;
  end
  else if AutoMagicID > 0 then
  begin
    if TryGetMagic(AutoMagicID, AMagic) and
      (GetTickCount - AMagic.UseTime >= AMagic.dwDelayTime) then
    begin
      if g_MagicMgr.TryGet(AMagic.wMagicId, AClient) then
      begin
        case AClient.FireType of
          ftNone, ftAfterAttack, ftHitCallNext:
            ;
          ftHit:
            begin
              if CheckMagicTime(AMagic, False) then
                AddNextMagic(AMagic.wMagicId, 0);
            end
        else
          UseMagic(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, AMagic, True, False);
        end;
      end
      else
        UseMagic(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, AMagic, True, False);
      AutoMagicID := 0;
      Result := True;
    end;
  end;

  ActionKey := 0;
end;

procedure TfrmMain.OnIdle(Sender: TObject; var Done: Boolean);
var
  R: TRect;
begin
  Done := False;
  if (not NativeAsphyreConnect.Init()) then
    Exit;

  if (Assigned(g_GameDevice)) and (g_GameDevice.IsAtFault()) then
  begin
    if (not FailureHandled) then
      HandleConnectFailure();
    FailureHandled := True;
    Exit;
  end;
  if (not Assigned(g_GameDevice)) or (not g_GameDevice.Connect()) then
    Exit;

  if not g_LogoHide then
  begin
    ImageLogo.Visible := False;
    Color := clBlack;
    g_LogoHide := True;
  end;

  if GetTickCount - g_dwLastObjectsTick >= 5 then
  begin
    if g_MySelf <> nil then
      PlayScene.ProcessObecjts;
    ProcessActionMessages;
    ProcessKeyMessages;
    ProcessDialogs;
    g_dwLastObjectsTick := GetTickCount;
  end;

  if GetTickCount - g_dwDrawTick >= 5 then
  begin
    // GetClipBox(Canvas.Handle, R);
    // if R.Right > 0 then
    // begin
    Inc(g_DrawCount);
    g_GameCanvas.ResetStates;
    DScreen.BeginDrawScreen(g_GameDevice, g_GameCanvas);
    FrmDlg.BeginScene(g_GameDevice, g_GameCanvas);
    g_GameDevice.Render(RenderEvent, 0);
    g_GameCanvas.Flush;
    // end;
    g_dwDrawTick := GetTickCount;
  end;
  Sleep(1);
end;

procedure TfrmMain.OnMySelfLevelChange(nLevel: Integer);
begin
  FrmDlg.DTLevel.Propertites.Caption.Text := IntToStr(nLevel);
  if (g_MySelf.m_btJob = 0) and (nLevel < g_nShowMagBubbleLevel) then
  begin
    FrmDlg.DBWarEmptyBlood.Visible := True;
    FrmDlg.DAWarBlood.Visible := True;
    FrmDlg.DAWarBloodEffect.Visible := True;
    FrmDlg.DAMyHP.Visible := False;
    FrmDlg.DAMyMP.Visible := False;
    FrmDlg.DABloodEffect.Visible := False;
  end
  else
  begin
    FrmDlg.DBWarEmptyBlood.Visible := False;
    FrmDlg.DAWarBlood.Visible := False;
    FrmDlg.DAWarBloodEffect.Visible := False;
    FrmDlg.DAMyHP.Visible := True;
    FrmDlg.DAMyMP.Visible := True;
    FrmDlg.DABloodEffect.Visible := True;
  end;
end;

procedure TfrmMain.ProcOnIdle;
var
  ADone: Boolean;
begin
  Application.OnIdle(Self, ADone);
end;

procedure TfrmMain.ProcessActionMessages;
var
  mx, my, dx, dy, crun ,nLeftCount,nRightCount ,I: Integer;
  ndir, adir, mdir,LeftDir,RightDir: Byte;
  bowalk, bostop: Boolean;
  UseMagicInfo:PTUseMagicInfo;
label
  LB_WALK, TTTT, LB_ACTIONEXEC;
begin
  if g_MySelf = nil then
    Exit;

  if g_ChrAction in [caWalk, caSneak, caRun] then
  begin
    if (g_nTargetX >= 0) and CanNextAction(g_ChrAction) and ServerAcceptNextAction then
    begin
      if (g_nTargetX <> g_MySelf.m_nCurrX) or
        (g_nTargetY <> g_MySelf.m_nCurrY) then
      begin
      TTTT:
        mx := g_MySelf.m_nCurrX;
        my := g_MySelf.m_nCurrY;
        dx := g_nTargetX;
        dy := g_nTargetY;
        ndir := GetNextDirection(mx, my, dx, dy);
        // 当前动作
        case g_ChrAction of
          caWalk:
            begin
            LB_WALK:
              crun := g_MySelf.CanWalk;
              if IsUnLockAction(CM_WALK, ndir) and (crun > 0) then
              begin
                //根据 nDir 获取下一个坐标点 到 mx,my
                GetNextPosXY(ndir, mx, my);
                bostop := False;

                //判断目标位置能不能行走
                if not PlayScene.CanWalkEx(mx, my) then
                begin
                   //注释上面的 启用下面的 随云
                   //判断下一个坐标点是不是门  如果开门成功了 则不在走 等待
                   if CheckDoorAction(mx, my) then
                   begin
                     Goto LB_ACTIONEXEC;
                   end;

                  if g_boCanUseSmartWalk and g_Config.Assistant.SmartWalk then
                  begin
                    //获取前面一个的 5个坐标 和 后面一个方向的 5个坐标 哪个能走就走哪个

                    {获取左边方向的能移动坐标数量}
                    mx := g_MySelf.m_nCurrX;
                    my := g_MySelf.m_nCurrY;
                    LeftDir := PrivDir(ndir);
                    GetNextPosXY(LeftDir, mx, my);
                    if not PlayScene.CanWalkEx(mx, my) then //如果斜面左边不能走那就直接转90度
                    begin
                      LeftDir := PrivDir(LeftDir);
                      mx := g_MySelf.m_nCurrX;
                      my := g_MySelf.m_nCurrY;
                    end;
                    mx := g_MySelf.m_nCurrX;
                    my := g_MySelf.m_nCurrY;

                    I := 0;
                    nLeftCount := 0;
                    repeat
                       I := I + 1;
                       GetNextPosXY(LeftDir, mx, my);
                       if PlayScene.CanWalkEx(mx, my) then
                         nLeftCount := nLeftCount + 1
                       else
                         Break;

                    until I > 5 ;

                    {获取右边方向的能移动坐标数量}
                    mx := g_MySelf.m_nCurrX;
                    my := g_MySelf.m_nCurrY;
                    RightDir := NextDir(ndir);
                    GetNextPosXY(RightDir, mx, my);
                    if not PlayScene.CanWalkEx(mx, my) then //如果斜面左边不能走那就直接转90度
                    begin
                      RightDir := NextDir(RightDir);
                    end;
                    mx := g_MySelf.m_nCurrX;
                    my := g_MySelf.m_nCurrY;

                    I := 0;
                    nRightCount := 0;
                    repeat
                       I := I + 1;
                       GetNextPosXY(RightDir, mx, my);
                       if PlayScene.CanWalkEx(mx, my) then
                         nRightCount := nRightCount + 1
                       else
                         Break;
                    until I > 5 ;

                    if (nLeftCount > 0) or (nRightCount > 0) then
                    begin
                      if nLeftCount = nRightCount then
                      begin
                        mdir := LeftDir;
                      end else if nLeftCount > nRightCount then
                      begin
                        mdir := LeftDir;
                      end else if nRightCount > nLeftCount then
                      begin
                        mdir := RightDir;
                      end;
                      mx := g_MySelf.m_nCurrX;
                      my := g_MySelf.m_nCurrY;
                      GetNextPosXY(mdir, mx, my);
                      g_MySelf.UpdateMsg(CM_WALK, mx, my, mdir, 0, 0, 0,
                        0, '', 0);
                      g_GameData.LastMoveTime.Data := GetTickCount;

                    end else
                    begin
                      mdir := GetNextDirection(g_MySelf.m_nCurrX,
                        g_MySelf.m_nCurrY, dx, dy);
                      if mdir <> g_MySelf.m_btDir then
                        g_MySelf.SendMsg(CM_TURN, g_MySelf.m_nCurrX,
                          g_MySelf.m_nCurrY, mdir, 0, 0, 0, 0, '', 0);
                      g_nTargetX := -1;
                    end;
                  end
                  else
                  begin
                    if ndir <> g_MySelf.m_btDir then
                      g_MySelf.SendMsg(CM_TURN, g_MySelf.m_nCurrX,
                      g_MySelf.m_nCurrY, ndir, 0, 0, 0, 0, '', 0);
                    g_nTargetX := -1;
                  end;
                end else
                begin
                  g_MySelf.UpdateMsg(CM_WALK, mx, my, ndir, 0, 0, 0, 0, '', 0);
                    g_GameData.LastMoveTime.Data := GetTickCount;
                end;
              end
              else
              begin
                g_nTargetX := -1;
              end;
            end;
          caSneak:
            begin
              crun := g_MySelf.CanWalk;
              if IsUnLockAction(CM_SNEAK, ndir) and (crun > 0) then
              begin
                GetNextPosXY(ndir, mx, my);
                bostop := False;
                if not PlayScene.CanWalk(mx, my) then
                begin
                  bowalk := False;
                  adir := 0;
                  if not bowalk then
                  begin
                    mx := g_MySelf.m_nCurrX;
                    my := g_MySelf.m_nCurrY;
                    GetNextPosXY(ndir, mx, my);
                    if CheckDoorAction(mx, my) then
                      bostop := True;
                  end;
                  if not bostop and not PlayScene.CrashMan(mx, my) then
                  begin
                    mx := g_MySelf.m_nCurrX;
                    my := g_MySelf.m_nCurrY;
                    adir := PrivDir(ndir);
                    GetNextPosXY(adir, mx, my);
                    if not Map.CanMove(mx, my) then
                    begin
                      mx := g_MySelf.m_nCurrX;
                      my := g_MySelf.m_nCurrY;
                      adir := NextDir(ndir);
                      GetNextPosXY(adir, mx, my);
                      if Map.CanMove(mx, my) then
                        bowalk := True;
                    end
                    else
                      bowalk := True;
                  end;
                  if bowalk then
                  begin
                    g_MySelf.UpdateMsg(CM_SNEAK, mx, my, adir, 0, 0, 0,
                      0, '', 0);
                    g_GameData.LastMoveTime.Data  := GetTickCount;
                  end
                  else
                  begin
                    mdir := GetNextDirection(g_MySelf.m_nCurrX,
                      g_MySelf.m_nCurrY, dx, dy);
                    if mdir <> g_MySelf.m_btDir then
                      g_MySelf.SendMsg(CM_TURN, g_MySelf.m_nCurrX,
                        g_MySelf.m_nCurrY, mdir, 0, 0, 0, 0, '', 0);
                    g_nTargetX := -1;
                  end;
                end
                else
                begin
                  g_MySelf.UpdateMsg(CM_SNEAK, mx, my, ndir, 0, 0, 0, 0, '', 0);
                  g_GameData.LastMoveTime.Data  := GetTickCount;
                end;
              end
              else
              begin
                g_nTargetX := -1;
              end;
            end;
          caRun:
            begin
              if g_MySelf.HaveStatus(STATE_ONLYWALK) then
                goto LB_WALK;
              // 免助跑
              if g_boCanStartRun or (g_nRunReadyCount >= 1) then
              begin
                crun := g_MySelf.CanRun;
                if (g_MySelf.m_btHorse <> 0) and
                  (GetDistance(mx, my, dx, dy) >= 3) and (crun > 0) and
                  IsUnLockAction(CM_HORSERUN, ndir) then
                begin
                  GetNextHorseRunXY(ndir, mx, my);
                  if PlayScene.CanRun(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY,
                    mx, my) then
                  begin
                    g_MySelf.UpdateMsg(CM_HORSERUN, mx, my, ndir, 0, 0, 0,
                      0, '', 0);
                  end
                  else
                  begin // 如果跑失败则跳回去走
                    g_ChrAction := caWalk;
                    goto TTTT;
                  end;
                end
                else
                begin
                  if (GetDistance(mx, my, dx, dy) >= 2) and (crun > 0) then
                  begin
                    if IsUnLockAction(CM_RUN, ndir) then
                    begin
                      GetNextRunXY(ndir, mx, my);
                      if PlayScene.CanRun(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY,
                        mx, my) then
                      begin
                        g_MySelf.UpdateMsg(CM_RUN, mx, my, ndir, 0, 0, 0,
                          0, '', 0);
                        g_GameData.LastMoveTime.Data  := GetTickCount;
                      end
                      else
                      begin
                        g_ChrAction := caWalk;
                        goto TTTT;
                      end;
                    end
                    else
                      g_nTargetX := -1;
                  end
                  else
                  begin
                    mdir := GetNextDirection(g_MySelf.m_nCurrX,
                      g_MySelf.m_nCurrY, dx, dy);
                    if mdir <> g_MySelf.m_btDir then
                      g_MySelf.SendMsg(CM_TURN, g_MySelf.m_nCurrX,
                        g_MySelf.m_nCurrY, mdir, 0, 0, 0, 0, '', 0);
                    g_nTargetX := -1;
                    goto LB_WALK;
                  end;
                end; // 骑马结束 20080721 注释骑马
              end
              else
              begin
                Inc(g_nRunReadyCount);
                goto LB_WALK;
              end;
            end;
        end;
      end;
    end;
  end;

LB_ACTIONEXEC:
  g_nTargetX := -1;
  if g_MySelf.RealActionMsg.ident > 0 then
  begin
    FailAction := g_MySelf.RealActionMsg.ident;
    FailDir := g_MySelf.RealActionMsg.dir;
    case g_MySelf.RealActionMsg.ident of
      CM_SPELL:
        begin
          //这个Dir实际是技能ID
          if g_MySelf.RealActionMsg.dir >= 10000 then
          begin
            UseMagicInfo := PTUseMagicInfo(Pointer(g_MySelf.RealActionMsg.feature));
            SendUseSkill(g_MySelf.RealActionMsg.dir,UseMagicInfo.Level,g_MySelf.RealActionMsg.STATE,
            g_MySelf.RealActionMsg.X,
            g_MySelf.RealActionMsg.Y,
            g_MySelf.m_btDir);
          end else
          begin
            SendSpellMsg(g_MySelf.RealActionMsg.ident, g_MySelf.RealActionMsg.X,
              g_MySelf.RealActionMsg.Y, g_MySelf.RealActionMsg.dir, {技能ID}
              g_MySelf.RealActionMsg.STATE);
          end;
        end;
      CM_HIT { 普通攻击 } , CM_HEAVYHIT { 跳起攻击 } :
        begin
          SendHitMsg(g_MySelf.RealActionMsg.ident, g_MySelf.RealActionMsg.X,
            g_MySelf.RealActionMsg.Y, g_MySelf.RealActionMsg.dir,
            g_MySelf.RealActionMsg.STATE, g_MySelf.RealActionMsg.target);
          g_GameData.LastHitTime.Data := GetTickCount;
        end;
      CM_WALK, CM_RUN, CM_HORSERUN, CM_SNEAK:
        begin
          SendActMsg(g_MySelf.RealActionMsg.ident, g_MySelf.RealActionMsg.X,
            g_MySelf.RealActionMsg.Y, g_MySelf.RealActionMsg.dir);
          // g_wLastMoveTime := GetTickCount;
        end
    else
      begin
        SendActMsg(g_MySelf.RealActionMsg.ident, g_MySelf.RealActionMsg.X,
          g_MySelf.RealActionMsg.Y, g_MySelf.RealActionMsg.dir);
      end;
    end;
    g_MySelf.RealActionMsg.ident := 0;
    if g_nMDlgX <> -1 then
    begin
      if (abs(g_nMDlgX - g_MySelf.m_nCurrX) >= 8) or
        (abs(g_nMDlgY - g_MySelf.m_nCurrY) >= 8) then
      begin
        FrmDlg.CloseMDlg(False);
        g_nMDlgX := -1;
      end;
    end;
  end;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ASelect, sx, sy: Integer;
  ATarget: TActor;
begin
  FInputHandled := False;
  if FTryReconnet then
    Exit;
  if (g_MySelf <> nil) or (DScreen.CurrentScene = PlayScene) then
  begin
    case Key of
      VK_F1, VK_F2, VK_F3, VK_F4, VK_F5, VK_F6, VK_F7, VK_F8:
        begin
          if g_MySelf.m_btHorse = 0 then
          begin
            if g_Config.Assistant.AutoMagic and (g_nAutoMagicKey = Key) then
            begin
              g_nAutoMagicKey := 0;
              g_Config.Assistant.AutoMagic := False;
              AssistantForm.DCheckSdoAutoMagic.Checked := False;
              AddChatBoardString('自动练功结束！', clGreen, clWhite);
            end;

            if (GetTickCount - g_GameData.LastSpellTick.Data >
              (g_GameData.SpellTime.Data + g_dwMagicDelayTime)) then
            begin
              if ssCtrl in Shift then
                ActionKey := Key - 100
              else
                ActionKey := Key;

              g_GameData.LastSpellTick.Data := GetTickCount;

              //OutputDebugString(PChar('g_dwMagicDelayTime :' + IntToStr(g_dwMagicDelayTime)));


            end;
            Key := 0;
          end;
        end;
      VK_F9:
        FrmDlg.OpenItemBag;
      VK_F10:
        FrmDlg.OpenMyStatus(0);
      VK_F11:
        FrmDlg.OpenMyStatus(4);
      // VK_F12, VK_HOME:
      // begin
      // if g_MirStartupInfo.AssistantKind = 1 then
      // StandardAssistantFrm.TStandardAssistantForm.Execute()
      // else
      // OpenSdoAssistant;
      // end;
      VK_ESCAPE:
        FrmDlg.CloseTopMost;
      VK_DELETE:
        g_MagicLockActor := nil;
      VK_INSERT:
        g_boShowAllItemEx := not g_boShowAllItemEx;
      Ord('Q'):
        begin
          if ssAlt in Shift then
          begin
            g_dwLatestStruckTick := GetTickCount() + 10001;
            g_dwLatestMagicTick := GetTickCount() + 10001;
            g_dwLatestHitTick := GetTickCount() + 10001;
            if (GetTickCount - g_dwLatestStruckTick > 10000) and
              (GetTickCount - g_dwLatestMagicTick > 10000) and
              (GetTickCount - g_dwLatestHitTick > 10000) or
              (g_MySelf.m_boDeath) then
            begin
              Close;
            end
            else
              AddChatBoardString('你不能在战斗状态结束游戏.', clYellow, clRed);
            FInputHandled := True;
            Exit;
          end;
        end;
      Ord('X'):
        begin
          if ssAlt in Shift then
          begin
            // 强行退出
            g_dwLatestStruckTick := GetTickCount() + 10001;
            g_dwLatestMagicTick := GetTickCount() + 10001;
            g_dwLatestHitTick := GetTickCount() + 10001;
            //
            if (GetTickCount - g_dwLatestStruckTick > 10000) and
              (GetTickCount - g_dwLatestMagicTick > 10000) and
              (GetTickCount - g_dwLatestHitTick > 10000) or
              (g_MySelf.m_boDeath) then
            begin
              AppLogout;
            end
            else
              AddChatBoardString('你不能在战斗状态结束游戏.', clYellow, clRed);
            FInputHandled := True;
            Exit;
          end;
        end;
      Ord('R'):
      begin
        if ssAlt in Shift then
        begin
          FrmDlg.ReloadBagItems;
        end;
      end;
    end;
  end;

{$IFDEF DEVMODE}
  case Key of
    VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT:
      begin
        if DirectionKeyDown(Key) then
          Exit;
      end;
  end;
{$ENDIF}

  if g_DWinMan.KeyDown(Key, Shift) then
    Exit;

  if (g_MySelf = nil) or (DScreen.CurrentScene <> PlayScene) then
    Exit;
  case Key of
    VK_TAB:
      FrmDlg.OpenMiniMap;
    VK_UP:
      with DScreen do
      begin
        if DScreen.ChatMessage.topline > 0 then
          Dec(DScreen.ChatMessage.topline);
      end;
    VK_DOWN:
      with DScreen do
      begin
        if DScreen.ChatMessage.topline < ChatMessage.count - 1 then
          Inc(DScreen.ChatMessage.topline);
      end;
    VK_PRIOR:
      with DScreen do
      begin
        if DScreen.ChatMessage.topline > CHATBOXLINECOUNT then
          DScreen.ChatMessage.topline := DScreen.ChatMessage.topline -
            CHATBOXLINECOUNT
        else
          DScreen.ChatMessage.topline := 0;
      end;
    VK_NEXT:
      with DScreen do
      begin
        if DScreen.ChatMessage.topline + CHATBOXLINECOUNT <
          ChatMessage.count - 1 then
          DScreen.ChatMessage.topline := DScreen.ChatMessage.topline +
            CHATBOXLINECOUNT
        else
          DScreen.ChatMessage.topline := ChatMessage.count - 1;
        if DScreen.ChatMessage.topline < 0 then
          DScreen.ChatMessage.topline := 0;
      end;
    Ord('A'), Ord('a'):
      begin
        if ssCtrl in Shift then
        begin
          SendShortCut(_SC_Rest);
          FInputHandled := True;
        end;
      end;
    Ord('B'), Ord('b'):
      begin // 打开商铺
        if ssCtrl in Shift then
        begin
          if FrmDlg.DShop.Visible then
            FrmDlg.DShop.Visible := False
          else
            FrmDlg.DAOpenShopClick(FrmDlg.DAOpenShop, 0, 0);
          FInputHandled := True;
        end;
      end;
    Ord('D'), Ord('d'):
      begin // 连击技能  20091205 邱高奇
        if (ssCtrl in Shift) and (not g_boUseBatter) then
        begin
          g_MagicTarget := g_FocusCret;
          if not PlayScene.IsValidActor(g_MagicTarget) or
            (g_MagicTarget.m_boDeath) then
            g_MagicTarget := nil;
          if g_MagicTarget = nil then
          begin
            PlayScene.CXYfromMouseXY(g_nMouseX, g_nMouseY, g_nBatterX,
              g_nBatterY);
            g_nBatterTargetid := 0;
          end
          else
          begin
            g_nBatterX := g_MagicTarget.m_nCurrX;
            g_nBatterY := g_MagicTarget.m_nCurrY;
            g_nBatterTargetid := g_MagicTarget.m_nRecogId;
          end;
          PlayScene.ScreenXYfromMCXY(g_MySelf.m_nCurrX,
            g_MySelf.m_nCurrY, sx, sy);
          g_BatterDir := GetFlyDirection(sx, sy, g_nBatterX, g_nBatterY);
          SendClientMessage(CM_USEBATTER, MakeLong(g_nBatterX, g_nBatterY),
            Loword(g_nBatterTargetid), g_BatterDir, Hiword(g_nBatterTargetid));
          g_boCanUseBatter := False;
          FInputHandled := True;
        end;
      end;
    Ord('E'), Ord('e'):
      begin
        if ssCtrl in Shift then
        begin
          SendClientMessage(CM_HEROCHGSTATUS, 0, 0, 0, 0);
          FInputHandled := True;
        end
        else if ssAlt in Shift then
        begin
          if g_FocusCret <> nil then
            SendDelGroupMember(g_FocusCret.m_sUserName);
          FInputHandled := True;
        end;
      end;
    Ord('H'), Ord('h'):
      begin
        if ssCtrl in Shift then
        begin
          SendShortCut(_SC_AttackMode);
          FInputHandled := True;
        end;
      end;
    Ord('W'), Ord('w'):
      begin // 英雄锁定攻击 清清$015  2007.10.23
        if ssCtrl in Shift then
        begin
          ATarget := PlayScene.GetAttackFocusCharacter(g_nMouseX, g_nMouseY, 0,
            ASelect, False);
          if ATarget <> nil then
            SendClientMessage(CM_HEROATTACKTARGET, ATarget.m_nRecogId,
              ATarget.m_nCurrX, ATarget.m_nCurrY, 0);
          FInputHandled := True;
        end
        else if ssAlt in Shift then
        begin // 添加遍组  20080424
          if g_FocusCret <> nil then
            if g_GroupMembers.count = 0 then
              SendCreateGroup(g_FocusCret.m_sUserName)
            else
              SendAddGroupMember(g_FocusCret.m_sUserName);
          FInputHandled := True;
        end;
      end;
    Ord('L'), Ord('l'):
      begin
        if ClientConf.boEnableMission then
        begin
          FrmDlg.ShowMissionDetail(True);
          FInputHandled := True;
        end;
      end;
    Ord('M'), Ord('m'):
      begin
        FrmDlg.OpenMailView;
        FInputHandled := True;
      end;
    Ord('Q'), Ord('q'):
      begin // 英雄守护位置 2007.11.8
        if ssCtrl in Shift then
        begin
          SendClientMessage(CM_HEROPROTECT, 0, g_nMouseCurrX, g_nMouseCurry, 0);
          FInputHandled := True;
        end;
      end;
    Ord('T'), Ord('t'):
      begin
        if GetTickCount - g_dwLastSwitchHorse > 500 then
        begin
          SendShortCut(_SC_SwitchHorse);
          g_dwLastSwitchHorse := GetTickCount;
        end;
        FInputHandled := True;
      end;
    // Ord('Z'), Ord('z'):
    // begin
    // if ssCtrl in Shift then
    // begin
    // FAutoRunner.Reset;
    // FAutoRunner.Enabled := not FAutoRunner.Enabled;
    // if FAutoRunner.Enabled then
    // AddChatBoardString('【提示】开始自动打怪...', clWhite, clBlue)
    // else
    // AddChatBoardString('【提示】停止自动打怪...', clWhite, clBlue);
    // FInputHandled := True;
    // end;
    // end;
  end;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
var
  AChatText: String;
begin
  if FTryReconnet then
    Exit;

  OutputDebugString(PChar('KeyPress'));
  if g_DWinMan.KeyPress(Key) then
    Exit;


  if DScreen.CurrentScene = PlayScene then
  begin
    if g_MySelf = nil then
      Exit;
    if FInputHandled then
      Exit;
    if FrmDlg.DEChat.Focused then
      Exit;


    case Key of
      Char(VK_ESCAPE), #0, #1, #3:
        Exit;
      '1' .. '6':
        begin
          if g_EatingItem.Name = '' then
          begin
            g_EatingItemIndex := StrToIntDef(Key, 0) - 1;
            if g_EatingItemIndex in [0 .. 6] then
              EatItem(g_EatingItemIndex, False);
          end;
          Exit;
        end;
      ' ', #13: // 进入聊天信息输入状态
        begin
          if not AssistantForm.DWAssistant.Visible then
          begin
            SetDFocus(FrmDlg.DEChat);
            if (FrmDlg.DEChat.Text = '') and g_Guild.LogChat then
            begin
              PlayScene.SetChatText('!~');
              FrmDlg.DEChat.SelStart := Length(FrmDlg.DEChat.Text);
              FrmDlg.DEChat.SelLength := 0;
            end
            else
            begin
              FrmDlg.DEChat.SelStart := Length(FrmDlg.DEChat.Text);
              FrmDlg.DEChat.SelLength := 0;
            end;
          end;
          Exit;
        end;
      '@', '!', '/':
        begin
          if not AssistantForm.DWAssistant.Visible then
          begin
            SetDFocus(FrmDlg.DEChat);
            if Key = '/' then
            begin
              if WhisperName = '' then
                PlayScene.SetChatText(Key)
              else if Length(WhisperName) > 2 then
                PlayScene.SetChatText('/' + WhisperName + ' ')
              else
                PlayScene.SetChatText(Key);
              FrmDlg.DEChat.SelStart := Length(FrmDlg.DEChat.Text);
              FrmDlg.DEChat.SelLength := 0;
            end
            else
            begin
              PlayScene.SetChatText(Key);
              FrmDlg.DEChat.SelStart := 1;
              FrmDlg.DEChat.SelLength := 0;
            end;
          end;
          Exit;
        end;
      '`':
        begin
          if CanNextAction(caCommon) and ServerAcceptNextAction then
            SendPickup;
          Exit;
        end;
      Char(VK_TAB): // 屏蔽TAB按键 切换到 输入装填 随云
        begin
          Exit;
        end;
    end;

    if not AssistantForm.DWAssistant.Visible and (Ord(Key) > 32) then
    begin
      AChatText := FrmDlg.DEChat.Text;
      AChatText := AChatText + Key;
      SetDFocus(FrmDlg.DEChat);
      PlayScene.SetChatText(AChatText);
      FrmDlg.DEChat.SelStart := Length(AChatText);
      FrmDlg.DEChat.SelLength := 0;
      Key := #0;
    end;
  end;
end;

// 根据快捷键，查找对应的魔法
function TfrmMain.GetMagicByKey(Key: PPlatfromChr): PTClientMagic;
var
  i: Integer;
  pm: PTClientMagic;
begin
  Result := nil;
  if g_MagicList.count > 0 then
  begin // 20080629
    for i := 0 to g_MagicList.count - 1 do
    begin
      pm := PTClientMagic(g_MagicList[i]);
      if pm.Key = Key then
      begin
        Result := pm;
        Break;
      end;
    end;
  end;
end;

function TfrmMain.CheckMagicTime(AMagic: PTClientMagic;
  ShowWarning: Boolean): Boolean;
begin
  Result := GetTickCount - AMagic.UseTime >= AMagic.dwDelayTime;
  if not Result then
  begin
    if ShowWarning then
      DScreen.AddSysMsg(Format('技能[' + AMagic.sMagicName +
        ']冷却中，%d秒后可释放！！！',
        [Ceil((AMagic.dwDelayTime - (GetTickCount - AMagic.UseTime))
        / 1000)]));
  end;
end;


function TfrmMain.SpellMagic(Magic: PTClientMagic;AEffNumber, ATargx, ATargY, ATargId: Integer): Boolean;
var
  adir: Integer;
  AUseMag: PTUseMagicInfo;
  sx, sy: Integer;
begin
  Result := False;
  if CanNextAction(caSpell) and ServerAcceptNextAction then
  begin
    adir := GetFlyDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY,
      ATargx, ATargY);
    g_GameData.LastSpellTick.Data := GetTickCount;
    New(AUseMag);
    FillChar(AUseMag^, SizeOf(TUseMagicInfo), #0);
    AUseMag.EffectNumber := AEffNumber;
    AUseMag.nMagicID := Magic.wMagicId;
    AUseMag.ServerMagicCode := 0;
    AUseMag.Level := Magic.Level;
    AUseMag.Strengthen := Magic.Strengthen;
    if Magic.wMagicId = 6 then
      AUseMag.tag := g_nDuwhich;
    g_dwMagicDelayTime := 500;
    g_dwLatestMagicTick := GetTickCount;
    g_dwMagicPKDelayTime := 0;
    if g_MagicTarget <> nil then
    begin
      if (g_MagicTarget.Race = 0) or (g_MagicTarget.Race = 1) or
        (g_MagicTarget.Race = 150) then
        g_dwMagicPKDelayTime := 500;
    end;
    g_MySelf.SendMsg(CM_SPELL, ATargx, ATargY, adir, Integer(AUseMag),
      ATargId, 0, 0, '', 0);
    Result := True;
  end;
end;

procedure TfrmMain.UseMagic(X, Y: Integer; Magic: PTClientMagic;
  LoadNextMagic, ShowWarning: Boolean);
var
  adir, ATargx, ATargY, ATargId, AMinRange, ASpellPoint, AEffNumber: Integer;
  ANextMagic: PTClientMagic;
  AClient: TuMagicClient;
  AProperties: TuCustomMagicEffectProperties;
  btDir: Byte;
begin
  if (X <> 5000) and (X <> 5000) and (Magic = nil) then
    Exit;
  if (X = 5000) and (Y = 5000) then
  begin // 放合击
    g_dwMagicDelayTime := 450; // 修正放合击同时放技能会卡住
    g_GameData.LastSpellTick.Data := GetTickCount;
    SendSocket(MakeDefaultMsg(CM_HEROGOTETHERUSESPELL, 0, 0, 0, 0,
      Certification));
  end
  else
  begin
    // 魔法锁定
    if uMagicMgr.g_MagicMgr.TryGet(Magic.wMagicId, AClient) then
    begin
      case AClient.FireType of
        ftHit, ftSpell:
          begin
            if not g_Config.Assistant.MagicLock or
              not Grobal2.SetContain(Magic.nState, _MAGIC_STATE_LockTarget)
              or (PlayScene.IsValidActor(g_FocusCret) and
              (AClient.SelectDeath or not g_FocusCret.m_boDeath) and
              (g_FocusCret.Race <> 50)) then
              g_MagicLockActor := g_FocusCret;
          end;
      end;
      g_MagicTarget := g_MagicLockActor;
    end
    else
    begin
      // (Magic.wMagicId in [2, 9, 10, 14, 15, 19,  22, 23, 29, 31, 33, 40, 46, 49, 52, 56, 57, 58, 164, 165])
      if not Grobal2.SetContain(Magic.nState, _MAGIC_STATE_LockTarget) then
        g_MagicTarget := g_FocusCret
      else
      begin
        if not g_Config.Assistant.MagicLock or
          (PlayScene.IsValidActor(g_FocusCret) and not g_FocusCret.m_boDeath and
          (g_FocusCret.Race <> 50)) then
          g_MagicLockActor := g_FocusCret;
        g_MagicTarget := g_MagicLockActor;
      end;
    end;

    if not PlayScene.IsValidActor(g_MagicTarget) then
      g_MagicTarget := nil
    else if g_MagicTarget.m_boDeath then
    begin
      if AClient <> nil then
      begin
        if not AClient.SelectDeath then
          g_MagicTarget := nil;
      end
      else if Magic.wMagicId <> SKILL_57 then
        g_MagicTarget := nil;
    end;

    if g_MagicTarget = nil then
    begin
      PlayScene.CXYfromMouseXY(X, Y, ATargx, ATargY);
      ATargId := 0;
    end
    else
    begin
      ATargx := g_MagicTarget.m_nCurrX;
      ATargY := g_MagicTarget.m_nCurrY;
      ATargId := g_MagicTarget.m_nRecogId;
    end;
    // 开天 龙影 逐日 反复按使用 不能删除掉
    // if LoadNextMagic and ( not (Magic.wMagicId in [SKILL_FIRESWORD,SKILL_42,SKILL_74])) then
    // begin
    // AMinRange := Max(Abs(g_MySelf.m_nCurrX - ATargx), Abs(g_MySelf.m_nCurrY - ATargy));
    // if TryGetNextMagic(AMinRange, ANextMagic) then
    // begin
    // DeleteWarMagic(ANextMagic, 2);
    // Magic := ANextMagic;
    // end;
    // end;
    if uMagicMgr.g_MagicMgr.TryGet(Magic.wMagicId, AClient) then
    begin
      case AClient.FireType of
        // ftNone, ftAfterAttack, ftHitCallNext: Exit;
        ftTurnHit:
          begin
            if GetTickCount - g_GameData.LastSpellTick.Data > g_GameData.SpellTime.Data { 500 } then
            begin
              g_GameData.LastSpellTick.Data := GetTickCount;
              g_dwMagicDelayTime := 0;
              SendSpellMsg(CM_SPELL, g_MySelf.m_btDir { x } , 0,
                Magic.wMagicId, 0);
            end;
            Exit;
          end;
      end;
    end
    else
    begin
      case Magic.wMagicId of
        SKILL_ATTACK, 3 { 基本剑术 } , 4 { 精神力战法 } , 7 { 攻杀 } , 67 { 先天元力 } ,
          151 { 蓄势待发 } :
          Exit;
      end;
    end;
    if CheckMagicTime(Magic, ShowWarning) then
    begin
      ASpellPoint := SkillInfo.GetSpellPoint(Magic.Level, Magic^);
      if (ASpellPoint <= g_MySelf.m_Abil.MP) {or (Magic.btEffectType = 0)} or
        (Magic.wMagicId = 69 { 倚天劈地 } ) then
      begin
        if g_Config.Assistant.AutoTurnDuFu then
          TurnDuFu(Magic, AClient);

        if AClient <> nil then
        begin
          AProperties := AClient.GetEffectProperties(Magic.Strengthen);
          if (AProperties <> nil) and (AProperties.Start.LibFile = '') then
          begin
            if GetTickCount - g_GameData.LastSpellTick.Data > g_GameData.SpellTime.Data { 500 } then
            begin
              g_GameData.LastSpellTick.Data := GetTickCount;
              g_dwMagicDelayTime := 0;
              SendSpellMsg(CM_SPELL, g_MySelf.m_btDir { x } , 0,
                Magic.wMagicId, 0);
            end;
          end
          else
            SpellMagic(Magic,CUSTOM_SKILL_EFFECT, ATargx, ATargY, ATargId);
        end
        else
        begin
          // 12类型
          if Magic.btEffectType = 12 then
          begin
            if GetTickCount - g_GameData.LastSpellTick.Data > g_GameData.SpellTime.Data { 500 } then
            begin
              btDir := GetFlyDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY,
                ATargx, ATargY);
              g_MySelf.m_btDir := btDir;
              g_GameData.LastSpellTick.Data := GetTickCount;
              g_dwMagicDelayTime := 0;
              SendSpellMsg(CM_SPELL, btDir, 0, Magic.wMagicId, 0);
            end;

          end
          else if Magic.btEffectType = 0 then
          begin
            // 其他基本魔法500ms用一次
            if GetTickCount - g_GameData.LastSpellTick.Data > g_GameData.SpellTime.Data { 500 } then
            begin
              g_GameData.LastSpellTick.Data := GetTickCount;
              g_dwMagicDelayTime := 0;
              SendSpellMsg(CM_SPELL, g_MySelf.m_btDir { x } , 0,
                Magic.wMagicId, 0);
            end;
          end
          else
          begin
            if Magic.wMagicId in [69 { 倚天劈地 } , 96 { 血魄一击 } ] then
            begin
              SendSpellMsg(CM_SPELL, g_MySelf.m_btDir, 0,
                Magic.wMagicId, 0);
              Exit;
            end;

            if CanNextAction(caSpell) and ServerAcceptNextAction then
            begin
              AEffNumber := Magic.btEffect;
              if Magic.Level = 4 then
              begin
                case Magic.wMagicId of
                  13:
                    AEffNumber := 100; // 4级火符
                  45:
                    AEffNumber := 101; // 4级灭天火
                end;
              end;
              if SpellMagic(Magic,AEffNumber, ATargx, ATargY, ATargId) then
              begin
                case Magic.wMagicId of
                  2, 14, 15, 16, 17, 18, 19, 21, 12, 25, 26, 28, 29, 30, 31:
                    ;
                else
                  g_dwLatestMagicTick := GetTickCount;
                end;
              end;
            end;
          end;
        end;
      end
      else if ShowWarning then
        DScreen.AddSysMsg('魔力值不够！！！');
    end;
  end;
end;

procedure TfrmMain.UseMagicSpell(ident, who, effnum, targetx, targety, magic_id,
  magLvl, magStrengthen, magTag: Integer);
var
  Actor: TActor;
  adir: Integer;
  AUseMagic: PTUseMagicInfo;
begin
  Actor := PlayScene.FindActor(who);
  if Actor <> nil then
  begin
    adir := GetFlyDirection(Actor.m_nCurrX, Actor.m_nCurrY, targetx, targety);
    New(AUseMagic);
    FillChar(AUseMagic^, SizeOf(TUseMagicInfo), #0);
    AUseMagic.EffectNumber := effnum;
    AUseMagic.ServerMagicCode := 0;
    AUseMagic.nMagicID := magic_id;
    AUseMagic.Level := magLvl;
    AUseMagic.Strengthen := magStrengthen;
    AUseMagic.tag := magTag;
    Actor.SendMsg(ident, 0, 0, adir, Integer(AUseMagic), 0, 0, 0, '', 0);
    Inc(g_nSpellCount);
  end
  else
    Inc(g_nSpellFailCount);
end;

procedure TfrmMain.UseMagicFire(who, efftype, effnum, targetx, targety,
  target: Integer; ShowHitEffect: Boolean);
var
  Actor: TActor;
  sound: Integer;
begin
  sound := 0;
  Actor := PlayScene.FindActor(who);
  if Actor <> nil then
  begin
    Actor.UpdateMsg(SM_MAGICFIRE, target, efftype, effnum, targetx, targety, 0,
      Ord(ShowHitEffect), '', sound);
    if g_nFireCount < g_nSpellCount then
      Inc(g_nFireCount);
  end;
  g_MagicTarget := nil;
end;

procedure TfrmMain.UseMagicFireFail(who, AMagicID: Integer);
var
  Actor: TActor;
  AMagic: PTClientMagic;
begin
  Actor := PlayScene.FindActor(who);
  if Actor <> nil then
  begin
    Actor.UpdateMsg(SM_MAGICFIRE_FAIL, 0, 0, 0, 0, 0, 0, 0, '', 0);
    if Actor = g_MySelf then
    begin
      if TryGetMagicByID(AMagicID, AMagic) then
        AMagic.UseTime := AMagic.UseTime - AMagic.dwDelayTime;
    end;
  end;
  g_MagicTarget := nil;
end;

function TfrmMain.EatItem(idx: Integer; AItemMoved: Boolean = False ; Debug:Boolean = false):Boolean;
//  function CanUse(): Boolean;
//  begin
//    Result := True;
//    if (g_EatingItem.S.StdMode = 0) and (g_EatingItem.S.StdMode = 1) and
//      (g_EatingItem.S.StdMode = 3) then
//    begin
//      if GetTickCount - g_dwEatDrugTime < g_dwUseDrugInterval then
//        Result := False;
//    end
//    else
//    begin
//      if GetTickCount - g_dwEatTime < g_dwUseItemInterval then
//        Result := False;
//    end;
//  end;

  procedure SetEatTime(Value: LongWord);
  begin
    if (g_EatingItem.S.StdMode = 0) and (g_EatingItem.S.StdMode = 1) and
      (g_EatingItem.S.StdMode = 3) then
    begin
      g_dwEatDrugTime := Value;
    end
    else
    begin
      g_dwEatTime := Value;
    end;
  end;

begin
  Result := False;

  if (g_EatingItem.Name <> '') and (GetTickCount - g_dwEatTime > 5000) then
  begin
    g_EatingItem.Name := '';
    ArrangeItemBag;
  end;


  if not(idx in [0 .. MAXBAGITEM - 1]) then
    Exit;

  g_EatingItemIndex := idx;
  if g_EatingItem.Name = '' then
  begin
    if AItemMoved and not(FrmDlg.DBoxs.Visible) then
    begin
      g_boItemMoving := False;
      g_EatingItem := g_MovingItem.Item;
      g_MovingItem.Item.Name := '';

//      if not CanUse then
//        Exit;
      // 宝箱 2008.01.15
      if (g_EatingItem.S.StdMode = 48) then
      begin
        FillChar(g_BoxsItems[0], SizeOf(g_BoxsItems), #0);
        FrmDlg.DBoxsTautology.Visible := False;

        FrmDlg.DBoxs.SetImgIndex(g_WMain3Images, 520);
        FrmDlg.DBoxs.Left := (SCREENWIDTH - FrmDlg.DBoxs.Width) div 2;
        FrmDlg.DBoxs.Top := (SCREENHEIGHT - FrmDlg.DBoxs.Height) div 2;
        g_BoxShape := g_EatingItem.S.Shape;
        FrmDlg.DBoxs.Visible := True;
        Exit;
      end;

      if (g_EatingItem.S.StdMode = 4) and (g_EatingItem.S.Shape < 100) then
      begin
        if mrYes <> FrmDlg.DMessageDlg('[' + g_EatingItem.Name + '] 你想要开始训练吗？',
          [mbYes, mbNo]) then
        begin
          AddItemBag(g_EatingItem);
          Exit;
        end;
      end;
      SetEatTime(GetTickCount);
      SendEat(g_EatingItem.MakeIndex, g_EatingItem.Name);
      g_SoundManager.ItemUseSound(g_EatingItem.S.StdMode, g_EatingItem.S.Shape);
      Result := True;
    end
    else
    begin
     // OutputDebugString(PChar('尝试吃药品'));
      if (g_ItemArr[g_EatingItemIndex].Name <> '') and
        (g_ItemArr[g_EatingItemIndex].S.StdMode in [0 .. 4, 31,32, 60]) then
      begin
        g_EatingItem := g_ItemArr[g_EatingItemIndex];
        if not(g_ItemArr[g_EatingItemIndex].S.StdMode in [{$I AddinStdmode.INC}]
          ) or (g_ItemArr[g_EatingItemIndex].Dura <= 1) then
          g_ItemArr[g_EatingItemIndex].Name := '';
        // 学习书籍.
        if (g_ItemArr[g_EatingItemIndex].S.StdMode = 4) and
          (g_ItemArr[g_EatingItemIndex].S.Shape < 100) then
        begin
          if mrYes <> FrmDlg.DMessageDlg('[' + g_EatingItem.Name
            + '] 你想要开始训练吗？', [mbYes, mbNo]) then
          begin
            g_ItemArr[g_EatingItemIndex] := g_EatingItem;
            Exit;
          end;
        end;

        //OutputDebugString(PChar('尝试吃药品成功'));
        SetEatTime(GetTickCount);
        SendEat(g_ItemArr[g_EatingItemIndex].MakeIndex,
          g_ItemArr[g_EatingItemIndex].Name);
        g_SoundManager.ItemUseSound(g_ItemArr[g_EatingItemIndex].S.StdMode,
          g_ItemArr[g_EatingItemIndex].S.Shape);
        Result := True;
      end;
    end;
  end else
  begin
    if Debug then
    begin
      OutputDebugString(PChar('解包药水遇到正在食用物品问题名字为空'));
    end;
  end;
end;

procedure TfrmMain.AutoLayOutItems;
var
  i: Integer;
  AHMPItem, AHPItem, AMPItem, ANextEatItem: Integer;
  Item : pTStdItem;
label
  UnPack;
begin
  // 自动放物品
  AHMPItem := -1;
  AHPItem := -1;
  AMPItem := -1;
  ANextEatItem := -1;
  if g_EatingItem.Name <> '' then
  begin
    //遍历背包物品
    if g_EatingItemIndex in [0 .. MAXBAGITEM] then
    begin
      for i := 0 to MAXBAGITEM - 1 do
      begin
        if g_ItemArr[i].Name <> '' then
        begin

          if g_EatingItem.S.Index = g_ItemArr[i].S.Index then
          begin
            if (g_EatingItemIndex in [0 .. 5]) and (i > 5) then
            begin
              g_ItemArr[g_EatingItemIndex] := g_ItemArr[i];
              g_ItemArr[i].Name := '';
              Exit;;
            end;
          end;

          if g_ItemArr[i].S.StdMode = 0 then
          begin
            if (g_ItemArr[i].S.ACMin > 0) and (g_ItemArr[i].S.MACMin > 0) then
            begin
              if AHMPItem = -1 then
                AHMPItem := i;
            end
            else if g_ItemArr[i].S.ACMin > 0 then
            begin
              if AHPItem = -1 then
                AHPItem := i;
            end
            else if g_ItemArr[i].S.MACMin > 0 then
            begin
              if AMPItem = -1 then
                AMPItem := i;
            end;
          end;

        end;
      end;

      if g_EatingItem.S.StdMode = 0 then
      begin
        if (g_EatingItem.S.ACMin > 0) and (g_EatingItem.S.MACMin > 0) then
        begin
          if AHMPItem <> -1 then
            ANextEatItem := AHMPItem
        end
        else if g_EatingItem.S.ACMin > 0 then
        begin
          if AHPItem <> -1 then
            ANextEatItem := AHPItem
          else if FindItemPack(g_EatingItem) <> -1 then
            goto UnPack
          else if AHMPItem <> -1 then
            ANextEatItem := AHMPItem;
        end
        else if g_EatingItem.S.MACMin > 0 then
        begin
          if AMPItem <> -1 then
            ANextEatItem := AMPItem
          else if FindItemPack(g_EatingItem) <> -1 then
            goto UnPack
          else if AHMPItem <> -1 then
            ANextEatItem := AHMPItem;
        end;
        if ANextEatItem <> -1 then
        begin
          g_ItemArr[g_EatingItemIndex] := g_ItemArr[ANextEatItem];
          g_ItemArr[ANextEatItem].Name := '';
          Exit;
        end;
      end;
    end;
  end;
UnPack:
  g_EatingItemIndex := -1;
  g_EatingItem.Name := '';
  if (g_EatingItem.S.StdMode in [{$I AddinStdmode.INC}]) and
    (g_EatingItem.Dura > 1) then
    Exit;

  AutoUnPack(True, 0, '');
end;

procedure TfrmMain.HeroEatItem(idx: Integer);
begin
end;

// 判断在2格范围内是否可以小开天
function TfrmMain.TargetInCanQTwnAttackRange(sx, sy, dx, dy: Integer): Boolean;
begin
  Result := False;
  if (abs(sx - dx) = 2) and (abs(sy - dy) = 0) then
  begin
    Result := True;
    Exit;
  end;
  if (abs(sx - dx) = 0) and (abs(sy - dy) = 2) then
  begin
    Result := True;
    Exit;
  end;
  if (abs(sx - dx) = 2) and (abs(sy - dy) = 2) then
  begin
    Result := True;
    Exit;
  end;
end;

// 判断在4格范围内是否可以大开天、逐日剑法
function TfrmMain.TargetInCanTwnAttackRange(sx, sy, dx, dy: Integer): Boolean;
begin
  Result := False;
  if (abs(sx - dx) <= 4) and (abs(sy - dy) = 0) then
  begin
    Result := True;
    Exit;
  end;
  if (abs(sx - dx) = 0) and (abs(sy - dy) <= 4) then
  begin
    Result := True;
    Exit;
  end;
  if ((abs(sx - dx) = 2) and (abs(sy - dy) = 2)) or
    ((abs(sx - dx) = 3) and (abs(sy - dy) = 3)) or
    ((abs(sx - dx) = 4) and (abs(sy - dy) = 4)) then
  begin
    Result := True;
    Exit;
  end;
end;

function TfrmMain.TargetInLineRange(ndir, nLen: Integer): Boolean;
var
  nX, nY, i: Integer;
  Actor: TActor;
begin
  Result := False;
  if nLen > 0 then
  begin
    GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, ndir, nX, nY);
    for i := 1 to nLen do
    begin
      GetFrontPosition(nX, nY, ndir, nX, nY);
      Actor := PlayScene.FindActorXY(nX, nY);
      if Actor <> nil then
      begin
        if not Actor.m_boDeath then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
  end;
end;

// 判断在2格范围内是否有目标可以刺杀
function TfrmMain.TargetInSwordLongAttackRange(ndir: Integer): Boolean;
var
  nX, nY: Integer;
  Actor: TActor;
begin
  Result := False;
  GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, ndir, nX, nY);
  GetFrontPosition(nX, nY, ndir, nX, nY);
  if (abs(g_MySelf.m_nCurrX - nX) = 2) or (abs(g_MySelf.m_nCurrY - nY) = 2) then
  begin
    Actor := PlayScene.FindActorXY(nX, nY);
    if Actor <> nil then
      if not Actor.m_boDeath then
        Result := True;
  end;
end;

// 判断是否有目标在半月攻击范围内
function TfrmMain.TargetInSwordWideAttackRange(ndir: Integer): Boolean;
var
  nX, nY, rx, ry, mdir: Integer;
  Actor, ractor: TActor;
begin
  Result := False;
  GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, ndir, nX, nY);
  Actor := PlayScene.FindActorXY(nX, nY);

  mdir := (ndir + 1) mod 8;
  GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
  ractor := PlayScene.FindActorXY(rx, ry);
  if ractor = nil then
  begin
    mdir := (ndir + 2) mod 8;
    GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
    ractor := PlayScene.FindActorXY(rx, ry);
  end;
  if ractor = nil then
  begin
    mdir := (ndir + 7) mod 8;
    GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, mdir, rx, ry);
    ractor := PlayScene.FindActorXY(rx, ry);
  end;

  if (Actor <> nil) and (ractor <> nil) then
  begin
    if not Actor.m_boDeath and not ractor.m_boDeath then
      Result := True;
  end;
end;

procedure TfrmMain.AttackTarget(target: TActor; Shift: TShiftState);
var
  AMinRange, tdir, dx, dy,dx1,dy1, nHitMsg, nHitMagicID, nHitEff, nTarget: Integer;
  AMagicType: Integer;
  AMagic: PTClientMagic;
  AFounded: Boolean;
  uMagic: TuMagicClient;
  nSelfX,nSelfY:Integer;
  btDir:Byte;
begin
  //骑马中不能攻击。
  if g_MySelf.m_btHorse > 0 then
    Exit;

  if target = nil then
    exit;


  tdir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY,
    target.m_nCurrX, target.m_nCurrY);

  //如果目标是采集怪的话。
  if target.Race in [25, 26] then
  begin
    if (abs(g_MySelf.m_nCurrX - target.m_nCurrX) <= 1) and
      (abs(g_MySelf.m_nCurrY - target.m_nCurrY) <= 1) and
      (not target.m_boDeath) then
    begin
      if CanNextAction(caHit) and ServerAcceptNextAction then
      begin
        SendCollectAnimal(target.m_nCurrX, target.m_nCurrY, tdir,
          target.m_nRecogId);
        g_CollectCret := nil;
        g_TargetCret := nil;
      end;
    end
    else
    begin
      g_ChrAction := caRun;
      GetBackPosition(target.m_nCurrX, target.m_nCurrY, tdir, dx, dy);
      g_nTargetX := dx;
      g_nTargetY := dy;
    end;
    Exit;
  end;

  AMagic := nil;
  nHitMsg := CM_HIT;
  nHitMagicID := SKILL_ATTACK;
  nHitEff := 0;
  AMinRange := Max(abs(g_MySelf.m_nCurrX - target.m_nCurrX),
    abs(g_MySelf.m_nCurrY - target.m_nCurrY));


  if (ssShift in Shift) and (g_MySelf.m_btJob = _JOB_ARCHER) then
  begin
    if (AMinRange <= 1 ) and CanNextAction(caHit) and ServerAcceptNextAction and
      CanNextHit then
      g_MySelf.SendMsg(CM_HIT, MakeLong(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY),
        MakeLong(dx, dy), tdir, 0, nHitMagicID, 0, 0, '', 0, nTarget, nHitEff)
    else
    begin
      g_ChrAction := caRun;
      GetBackPosition(target.m_nCurrX, target.m_nCurrY, tdir, dx, dy);
      g_nTargetX := dx;
      g_nTargetY := dy;
    end;
    Exit;
  end;


  // 取得方向
  AFounded := TryGetWarMagic(AMinRange, Shift, AMagic, AMagicType);


  //开了隔位刺杀 可以范围是2
  if AFounded then
  begin
    //检测一下自己和目标是否构成刺杀位置
    if (AMagic.wMagicId = SKILL_ERGUM) or (AMagic.wMagicId = SKILL_89) then
    begin
      // 获取自己的方向 往前面 + 2 如果坐标等于 g_TargetCret 那就是说明可以刺杀打到。
      nSelfX := g_MySelf.m_nCurrX;
      nSelfY := g_MySelf.m_nCurrY;
      btDir := tdir;
      GetNextPosXY(btDir,nSelfX,nSelfY);
      GetNextPosXY(btDir,nSelfX,nSelfY);
      if (nSelfX = target.m_nCurrX) and  (nSelfY = target.m_nCurrY) and g_Config.Assistant.SPLongHit then
      begin
        AMinRange := 0; //如果是刺杀位 强制 范围为 0
      end else
      begin
        AFounded := False;
      end;

    end;
  end;

  if (AMinRange <= 1) or (AFounded and CanUseMagic(AMagic)) then
  begin
    if CanNextAction(caHit) and ServerAcceptNextAction and CanNextHit then
    begin
      if AMagic <> nil then
      begin
        nHitMagicID := AMagic.wMagicId;
        nHitEff := MakeLong(MakeWord(AMagic.btEffectType,
          AMagic.btEffect), AMagic.Strengthen);
        if AMagic.btJob = _JOB_ARCHER then
        begin
          nHitMsg := CM_HEAVYHIT;
          if (nHitMagicID = SKILL_150) or (nHitMagicID = SKILL_151) then
          begin
            // todo 弓箭手速度临时处理
            if GetTickCount - g_GameData.LastHitTime.Data  < g_GameData.SpellTime.Data then
              Exit;
          end;
        end;
      end;
      dx := 0;
      dy := 0;
      nTarget := 0;
      if target <> nil then
      begin
        dx := target.m_nCurrX;
        dy := target.m_nCurrY;
        nTarget := target.m_nRecogId;
      end;
      g_MySelf.SendMsg(nHitMsg, MakeLong(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY),
        MakeLong(dx, dy), tdir, 0, nHitMagicID, 0, 0, '', 0, nTarget, nHitEff);
      g_dwLatestHitTick := GetTickCount;
      g_GameData.LastHitTime.Data := GetTickCount;
      DeleteWarMagic(AMagic, AMagicType);
      g_nTargetX := -1;
      if g_Config.Assistant.AutoFireHit then
        AutoLieHuo;
      if g_Config.Assistant.AutoZhuRiHit then
        AutoZhuri;
    end
    else if not AFounded and (AMinRange > 1) then
      g_ChrAction := caRun;
  end
  else
  begin
    g_ChrAction := caRun;

    if g_Config.Assistant.SPLongHit then
    begin
      AFounded := TryGetMagic(SKILL_ERGUM, AMagic);
      if not AFounded then
        AFounded := TryGetMagic(SKILL_89, AMagic);

      if AFounded then
      begin
        GetBackPosition(target.m_nCurrX, target.m_nCurrY, tdir, dx, dy);
        GetBackPosition(dx, dy, tdir, dx1, dy1);
        g_nTargetX := dx1;
        g_nTargetY := dy1;
      end else
      begin
        GetBackPosition(target.m_nCurrX, target.m_nCurrY, tdir, dx, dy);
        g_nTargetX := dx;
        g_nTargetY := dy;
      end;  
    end else
    begin
      GetBackPosition(target.m_nCurrX, target.m_nCurrY, tdir, dx, dy);
      g_nTargetX := dx;
      g_nTargetY := dy;
    end;
  end;
end;

// 自动烈火
function TfrmMain.AutoLieHuo: Boolean;
var
  AMagic: PTClientMagic;
begin
  Result := False;
  if g_MySelf = nil then
    Exit;
  if ((GetTickCount - g_dwAutoZhuRi) > 7000) and (g_MySelf.m_btJob = 0) then
  begin
    if TryGetMagicByID(SKILL_FIRESWORD, AMagic) and
      (GetTickCount - AMagic.UseTime > AMagic.dwDelayTime) then
    begin
      if g_MySelf.m_Abil.MP >= GetSpellPoint(AMagic) then
      begin
        AutoMagicID := SKILL_FIRESWORD;
        g_dwAutoLieHuo := GetTickCount;
      end;
    end;
  end;
end;

function TfrmMain.AutoZhuri: Boolean;
var
  AMagic: PTClientMagic;
begin
  Result := False;
  if g_MySelf = nil then
    Exit;
  if ((GetTickCount - g_dwAutoZhuRi) > 10000) and (g_MySelf.m_btJob = 0) then
  begin
    if TryGetMagicByID(SKILL_74, AMagic) then
    begin
      if g_MySelf.m_Abil.MP >= GetSpellPoint(AMagic) then
      begin
        AutoMagicID := SKILL_74;
        g_dwAutoZhuRi := GetTickCount;
      end;
    end;
  end;
end;

// 自动魔法盾，自动抗拒，自动隐身过程
function TfrmMain.NearActor: Boolean;
var
  AMagic: PTClientMagic;
begin
  Result := False;
  if g_MySelf = nil then
    Exit;
  if g_MySelf.m_boDeath then
    Exit;
  if g_MySelf.m_btHorse <> 0 then
    Exit;

  // 自动魔盾
  if ((GetTickCount - g_nAutoMagic) > 500) and
    g_Config.Assistant.AutoShield then
  begin
    if g_MySelf.HaveStatus(STATE_BUBBLEDEFENCEUP) then
      Exit;
    if TryGetMagicByID(66, AMagic) then
    begin // 四级魔法盾
      AutoMagicID := SKILL_66;
      g_nAutoMagic := GetTickCount;
    end
    else if TryGetMagicByID(31, AMagic) then
    begin
      AutoMagicID := SKILL_SHIELD;
      g_nAutoMagic := GetTickCount;
    end;
  end;

  // 自动隐身
  if ((GetTickCount - g_nAutoMagic) > 500) and
    g_Config.Assistant.AutoHide then
  begin
    if g_MySelf.HaveStatus(STATE_TRANSPARENT) then
      Exit;
    if TryGetMagicByID(18, AMagic) then
    begin
      AutoMagicID := SKILL_CLOAK;
      g_nAutoMagic := GetTickCount;
    end;
  end;
end;

procedure TfrmMain.AutoEatItem;
var
  i: Integer;
  bo: Boolean;
  tdir: Byte;
  ASpecMPUsed: Boolean;
begin
  if g_MySelf = nil then
    Exit;
  if g_MySelf.m_boDeath then
    Exit;

  if g_EatingItem.Name <> '' then
    Exit;
  // g_EatingItemIndex := -1;
{$REGION '普通hp保护'}
  if g_Config.Assistant.CommonHp and
    (g_MySelf.m_Abil.HP < g_Config.Assistant.EditCommonHp) and
    ((GetTickCount - g_dwCommonHpTick) >
    g_Config.Assistant.EditCommonHpTimer) then
  begin
    g_dwCommonHpTick := GetTickCount;
    bo := False;
    if g_Config.Assistant.DefCommonHpName <> '' then
    begin
      for i := 0 to MAXBAGITEM - 1 do
      begin
        if (g_ItemArr[i].Name <> '') and
          (g_ItemArr[i].S.Name = g_Config.Assistant.DefCommonHpName) then
        begin
          if EatItem(i, False) then
          begin
            //OutputDebugString(PChar('Auto吃药'));
            bo := True;
          end;
          Exit;
        end;
      end;
    end;

    if not bo then
      for i := 0 to MAXBAGITEM - 1 do
      begin
        if (g_ItemArr[i].Name <> '') and (g_ItemArr[i].S.StdMode = 0) and
          (g_ItemArr[i].S.Shape = 0) and (g_ItemArr[i].S.ACMin > 0) then
        begin
          if  EatItem(i, False) then
          begin
            bo := True;
          end;
          Exit;
        end;
      end;

    if not bo then
     if AutoUnPack(False, 1, '提示:您的['+ g_Config.Assistant.DefCommonHpName+ ']没了,请及时补充!') then
       exit;
  end;
{$ENDREGION}
{$REGION '普通MP保护'}
  if g_Config.Assistant.CommonMp and
    (g_MySelf.m_Abil.MP < g_Config.Assistant.EditCommonMp) and
    ((GetTickCount - g_dwCommonMpTick) >
    g_Config.Assistant.EditCommonMpTimer) then
  begin
    g_dwCommonMpTick := GetTickCount;
    bo := False;
    if g_Config.Assistant.DefCommonMpName <> '' then
    begin
      for i := 0 to MAXBAGITEM - 1 do
      begin
        if (g_ItemArr[i].Name <> '') and
          (g_ItemArr[i].S.Name = g_Config.Assistant.DefCommonMpName) then
        begin
          if EatItem(i, False) then
          begin
            bo := True;
          end;
           Exit;
        end;
      end;
    end;
    if not bo then
    begin
      for i := 0 to MAXBAGITEM - 1 do
      begin
        if (g_ItemArr[i].Name <> '') and (g_ItemArr[i].S.StdMode = 0) and
          (g_ItemArr[i].S.Shape = 0) and (g_ItemArr[i].S.MACMin > 0) then
        begin
          if EatItem(i, False) then
          begin
            bo := True;
          end;
           Exit;
        end;
      end;
    end;
    if not bo then
     if  AutoUnPack(False, 2, '提示:您的[' + g_Config.Assistant.DefCommonMpName + ']没了,请及时补充!') then
       exit;
  end;
{$ENDREGION}
{$REGION '特殊HP保护'}
  ASpecMPUsed := False;
  if g_Config.Assistant.SpecialHp and
    (g_MySelf.m_Abil.HP < g_Config.Assistant.EditSpecialHp) and
    ((GetTickCount - g_dwSpecialHpTick) >
    g_Config.Assistant.EditSpecialHpTimer) then
  begin
    g_dwSpecialHpTick := GetTickCount;
    bo := False;
    if g_Config.Assistant.DefSpecialHpName <> '' then
    begin
      for i := 0 to MAXBAGITEM - 1 do
      begin
        if (g_ItemArr[i].Name <> '') and
          (g_ItemArr[i].S.Name = g_Config.Assistant.DefSpecialHpName) then
        begin
          if EatItem(i, False) then
          begin
            ASpecMPUsed := g_ItemArr[i].S.MACMin > 0;
            if ASpecMPUsed then
              g_dwSpecialMPTick := GetTickCount;
            bo := True;
          end;
          Exit;
        end;
      end;
    end;
    if not bo then
    begin
      for i := 0 to MAXBAGITEM - 1 do
      begin
        if (g_ItemArr[i].Name <> '') and (g_ItemArr[i].S.StdMode = 0) and
          (g_ItemArr[i].S.Shape = 1) and (g_ItemArr[i].S.ACMin > 0) then
        begin
          if EatItem(i, False) then
          begin
            ASpecMPUsed := g_ItemArr[i].S.MACMin > 0;
            if ASpecMPUsed then
              g_dwSpecialMPTick := GetTickCount;
            bo := True;
          end;
           Exit;
        end;
      end;
    end;
    if not bo then
      if AutoUnPack(False, 3, '提示:您的['+ g_Config.Assistant.DefSpecialHpName + ']没了,请及时补充!') then
        exit;
  end;
  if g_Config.Assistant.SpecialMP and not ASpecMPUsed and
    (g_MySelf.m_Abil.MP < g_Config.Assistant.EditSpecialMP) and
    ((GetTickCount - g_dwSpecialMPTick) >
    g_Config.Assistant.EditSpecialMPTimer) then
  begin
    g_dwSpecialMPTick := GetTickCount;
    bo := False;
    if g_Config.Assistant.DefSpecialMPName <> '' then
    begin
      for i := 0 to MAXBAGITEM - 1 do
      begin
        if (g_ItemArr[i].Name <> '') and
          (g_ItemArr[i].S.Name = g_Config.Assistant.DefSpecialMPName) then
        begin
          if EatItem(i, False) then
          begin
            if g_ItemArr[i].S.ACMin > 0 then
              g_dwSpecialHpTick := GetTickCount;
            bo := True;
          end;
          exit;
        end;
      end;
    end;
    if not bo then
    begin
      for i := 0 to MAXBAGITEM - 1 do
      begin
        if (g_ItemArr[i].Name <> '') and (g_ItemArr[i].S.StdMode = 0) and
          (g_ItemArr[i].S.Shape = 1) and (g_ItemArr[i].S.MACMin > 0) then
        begin
          if EatItem(i, False) then
          begin
            if g_ItemArr[i].S.ACMin > 0 then
              g_dwSpecialHpTick := GetTickCount;
            bo := True;
          end;
          exit;
        end;
      end;
    end;
    if not bo then
      if AutoUnPack(False, 4, '提示:您的[ '+ g_Config.Assistant.DefSpecialMPName + ']没了,请及时补充!') then
        exit;
  end;
{$ENDREGION}
{$REGION '随机HP保护'}
  if g_Config.Assistant.RandomHp and
    (g_MySelf.m_Abil.HP < g_Config.Assistant.EditRandomHp) and
    ((GetTickCount - g_dwRandomHpTick) >
    g_Config.Assistant.EditRandomHpTimer) then
  begin
    g_dwRandomHpTick := GetTickCount;
    bo := False;
    for i := 0 to MAXBAGITEM - 1 do
    begin
      if (g_ItemArr[i].Name <> '') and
        (g_ItemArr[i].Name = g_Config.Assistant.RandomName) then
      begin
        EatItem(i, False);
        bo := True;
        Break;
      end;
    end;
    if not bo then
      AddChatBoardString('提示:您的[' + g_Config.Assistant.RandomName +
        ']没了,请及时补充!', clRed, clWhite);
  end;
{$ENDREGION}
  // 人物自动喝普通酒
  if g_boAutoEatWine and
    ((100 * g_MySelf.m_Abil.WineDrinkValue div g_MySelf.m_Abil.MaxAlcohol) <=
    g_btEditWine) and ((GetTickCount - g_dwAutoEatWineTick) > 5000) then
  begin
    g_dwAutoEatWineTick := GetTickCount;
    bo := False;
    for i := 0 to MAXBAGITEM - 1 do
    begin
      if (g_ItemArr[i].Name <> '') and (g_ItemArr[i].S.StdMode = 60) and
        (g_ItemArr[i].AniCount = 1) then
      begin
        if EatItem(i, False) then
        begin
          bo := True;
        end;
        Exit;
      end;
    end;
    if not bo then
      AddChatBoardString('提示:您的[普通酒]没了,请及时补充!', clRed, clWhite);
  end;
  // 人物自动喝药酒
  if g_boAutoEatDrugWine and ((GetTickCount - g_dwAutoEatDrugWineTick) >=
    g_btEditDrugWine * 1000 * 60) then
  begin
    g_dwAutoEatDrugWineTick := GetTickCount;
    bo := False;
    for i := 0 to MAXBAGITEM - 1 do
    begin
      if (g_ItemArr[i].Name <> '') and (g_ItemArr[i].S.StdMode = 60) and
        (g_ItemArr[i].AniCount = 2) then
      begin
        EatItem(i, False);
        bo := True;
        Exit;
      end;
    end;
    if not bo then
      AddChatBoardString('提示:您的[药酒]没了,请及时补充!', clRed, clWhite);
  end;
  // 自动使用火龙珠
  if g_Config.Assistant.AutoUseHuoLong and
    ((GetTickCount - g_dwAutoUseHuoLong) >= 500) then
  begin
    g_dwAutoUseHuoLong := GetTickCount;
    for i := 0 to MAXBAGITEM - 1 do
    begin
      if (g_ItemArr[i].Name <> '') and (g_ItemArr[i].S.StdMode = 31) and
        (g_ItemArr[i].AniCount = 43) then
      begin
        EatItem(i, False);
        Break;
      end;
    end;
  end;
  // 自动使用金元丹
  if g_Config.Assistant.AutoUseJinyuan and
    ((GetTickCount - g_dwAutoUseJinyuan) >= 500) then
  begin
    g_dwAutoUseJinyuan := GetTickCount;
    for i := 0 to MAXBAGITEM - 1 do
    begin
      if (g_ItemArr[i].Name <> '') and (g_ItemArr[i].S.StdMode = 0) and
        (g_ItemArr[i].S.looks = 1586) then
      begin
        EatItem(i, False);
        Break;
      end;
    end;
  end;
  if g_Config.Assistant.AutoSearchItem and
    ((GetTickCount - g_dwButchItemTick) >= 1000) then
  begin
    if (g_AutoSearchItemTarget <> nil) then
    begin
      tdir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY,
        g_AutoSearchItemTarget.m_nCurrX, g_AutoSearchItemTarget.m_nCurrY);
      if CanNextAction and ServerAcceptNextAction then
      begin
        SendButchAnimal(g_AutoSearchItemTarget.m_nCurrX,
          g_AutoSearchItemTarget.m_nCurrY, tdir,
          g_AutoSearchItemTarget.m_nRecogId);
        g_MySelf.SendMsg(CM_SITDOWN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir,
          0, 0, 0, 0, '', 0);
      end;
    end;
  end;
end;

procedure TfrmMain.AutoFollow(DestX, DestY: Integer);
var
  P: PPoint;
begin
  if not g_uAutoRun then
    AutoGoto(DestX, DestY)
  else
  begin
    New(P);
    P.X := DestX;
    P.Y := DestY;
    g_uPointList.Add(P);
  end;
end;

procedure TfrmMain.AutoGoto(DestX, DestY: Integer);
var
  APath: uPathFind.TPath;
  i: Integer;
  P: PPoint;
begin
  if (g_uPathMap <> nil) and (Map.m_sCurrentMap <> g_uPathMap.MapName) then
    FreeAndNilEx(g_uPathMap);
  if g_uPathMap = nil then
  begin
    g_uPathMap := TLegendPathMap.Create;
    g_uPathMap.MapName := Map.m_sCurrentMap;
    g_uPathMap.CheckCrashMan := PlayScene.CrashMan;
    g_uPathMap.LoadMap(Map.m_sCurrentMap, Map.m_boAllowNewMap);
  end;
  ClearAutoRunPointList;
  APath := g_uPathMap.FindPath(g_MySelf.m_nCurrX + Map.m_btOffsetX,
    g_MySelf.m_nCurrY + Map.m_btOffsetY, DestX + Map.m_btOffsetX,
    DestY + Map.m_btOffsetY, 1);
  for i := Low(APath) to High(APath) do
  begin
    if (i = 0) or (i = High(APath)) or (i mod 4 = 1) then
    begin
      New(P);
      P.X := APath[i].X;
      P.Y := APath[i].Y;
      g_uPointList.Add(P);
    end;
  end;
  Finalize(APath);
  g_uAutoRun := g_uPointList.count > 0;
  if not g_uAutoRun then
    AddChatBoardString('目标无法到达...', GetRGB(255), GetRGB(56));
  if not g_boViewMiniMap then
  begin // 显示小地图
    if GetTickCount > g_dwQueryMsgTick then
    begin
      g_dwQueryMsgTick := GetTickCount + 3000;
      frmMain.SendWantMiniMap;
    end;
  end;
end;

// 英雄召唤或退出动画显示
procedure TfrmMain.ShowHeroLoginOrLogOut(Actor: TActor);
begin
  Actor.g_HeroLoginOrLogOut := True;
  Actor.HeroLoginStartFrame := 800; // 开始
  Actor.HeroLoginExplosionFrame := 10; // 往后播放
  Actor.HeroLoginNextFrameTime := 100;
  Actor.HeroTime := GetTickCount;
  Actor.HeroFrame := 0;
end;

function IsTarget(Shift: TShiftState; ATarget: TActor): Boolean;
{$IFDEF Release}inline; {$ENDIF}
begin
  Result := False;
  if ATarget = nil then
    Exit;
  if g_Config.Assistant.NoShift or
    ((ssShift in Shift) and (not FrmDlg.DEChat.Focused)) then
  begin
    Result := True;
    Exit;
  end;
  if ATarget.Race in [RCC_USERHUMAN, 1, RCC_MERCHANT] then
    Exit;
  if (ATarget.Race <> RCC_GUARD) or
    (ATarget.m_boMonNPC and not ATarget.m_boFriendly) then
    Result := True;
end;

procedure TfrmMain._DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  tdir, nX, nY, nHitMsg, sel, nHitMagicID, AMagicType, nHitEff,
    AMinRange: Integer;
  target: TActor;
  boHandleActor: Boolean;
  AMagic: PTClientMagic;
  ChatEditFocus : Boolean;
begin
  MouseDownTime := GetTickCount;
  boHandleActor := False;
  if GetTickCount - LastActorClkTick > 300 then
  begin
    LastActorClkTick := GetTickCount;
    boHandleActor := True;
  end;

  ActionKey := 0;
  AutoMagicID := 0;
  g_nMouseX := X;
  g_nMouseY := Y;
  g_AutoSearchItemTarget := nil; // 自动探索对象
  // 右键取消物品的移动
  if (Button = mbRight) and (g_boItemMoving) then
  begin
    FrmDlg.CancelItemMoving;
    Exit;
  end;

  //保存聊天框焦点状态
  ChatEditFocus := FrmDlg.DEChat = DWinCtl.FocusedControl;

  if g_DWinMan.MouseDown(Button, Shift, X, Y) then
  begin
    DXPopupMenu.HidePopup;
    g_SelCret := nil;
    MouseDownTime := GetTickCount + 100;
    Exit; // 鼠标移到窗口上了则跳过
  end;

  if ChatEditFocus then
  begin
    FrmDlg.DEChat.SetFocus;
  end;


  g_boActionLock := True;
  g_boAutoDig := False; // 取消挖矿
  DXPopupMenu.HidePopup;
  g_SelCret := nil;

  if (g_MySelf = nil) or (DScreen.CurrentScene <> PlayScene) then
    Exit; // 如果人物退出则跳过

  if FAutoRunner.Enabled then
  begin
    FAutoRunner.Enabled := False;
    AddChatBoardString('【提示】停止自动打怪...', clWhite, clBlue);
  end;
  if g_uAutoRun or g_boISTrail then
  begin
    g_uAutoRun := False;
    g_Pilot := nil;
    ClearAutoRunPointList;
    if g_boISTrail then
      AddChatBoardString('停止自动跟随', GetRGB(178), clWhite)
    else
      AddChatBoardString('停止自由移动', GetRGB(178), clWhite);
    g_boISTrail := False;
  end;

  if ssRight in Shift then
  begin // 鼠标右键
    if Shift = [ssRight] then
      Inc(g_nDupSelection);
    // 多选
    target := PlayScene.GetAttackFocusCharacter(X, Y, g_nDupSelection,
      sel, False);
    // 取指定坐标上的角色
    if g_nDupSelection <> sel then
      g_nDupSelection := 0;

    if target <> nil then
    begin

      if (ssDouble in Shift) and (target.Race = RCC_USERHUMAN) and
        target.HaveStatus(STATE_Recruit) and
        not g_MySelf.HaveStatus(STATE_Recruit) then
      begin
        SendClientMessage(CM_EXECMENUITEM, target.m_nRecogId, target.m_nCurrX,
          target.m_nCurrY, 111); // 这个111假设是招募状态的入队标志
        SetAllowGroup(True);
        Exit;
      end;

      if ssCtrl in Shift then
      begin
        if (target.Race in [0, 1, 150, 151, 152]) then
        begin
          if (g_SelCret <> target) or
            (GetTickCount - g_LastQueryChrTick > 2000) then
          begin
            g_SelCret := target;
            g_SelCretX := X;
            g_SelCretY := Y;
            case target.Race of
              0, 1:
                begin
                  if ClientConf.boRightClickShowHum then
                    SendClientMessage(CM_EXECMENUITEM, g_SelCret.m_nRecogId,
                      g_SelCret.m_nCurrX, g_SelCret.m_nCurrY, 1 { 查看装备 } )
                  else
                    SendQueryActorMenuState;
                end;
              150 .. 152:
                SendClientMessage(CM_EXECMENUITEM, g_SelCret.m_nRecogId,
                  g_SelCret.m_nCurrX, g_SelCret.m_nCurrY, 1);
            end;
            g_LastQueryChrTick := GetTickCount;
          end;
          Exit;
        end;
      end;
      if ssAlt in Shift then
      begin
        if boHandleActor and (target.Race in [0, 1, 150]) then
        begin
          PlayScene.SetChatText('/' + target.m_sUserName + ' ');
          SetDFocus(FrmDlg.DEChat);
          FrmDlg.DEChat.SelStart := Length(FrmDlg.DEChat.Text);
          Exit;
        end;
      end;
    end
    else
      g_nDupSelection := 0;

    // 按鼠标右键，并且鼠标指向空位置
    PlayScene.CXYfromMouseXY(X, Y, g_nMouseCurrX, g_nMouseCurry);

    if (g_MySelf.m_btStall > 0) or
      ((abs(g_MySelf.m_nCurrX - g_nMouseCurrX) <= 1) and
      (abs(g_MySelf.m_nCurrY - g_nMouseCurry) <= 1)) then
    begin // 目标座标  //两格范围内
      tdir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY,
        g_nMouseCurrX, g_nMouseCurry);
      if CanNextAction and ServerAcceptNextAction then
        g_MySelf.SendMsg(CM_TURN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, 0,
          0, 0, 0, '', 0);
    end
    else
    begin // 跑
      g_ChrAction := caRun;
      g_nTargetX := g_nMouseCurrX;
      g_nTargetY := g_nMouseCurry;
      Exit;
    end;
  end;

  if ssLeft in Shift { Button = mbLeft } then
  begin
    target := PlayScene.GetAttackFocusCharacter(X, Y, g_nDupSelection,
      sel, True);

    if target <> nil then
    begin
      if (target.Race = RCC_USERHUMAN) and (target.m_btStall > 0) then
      begin
        if boHandleActor then
        begin
          SendClientMessage(CM_STALL_COMMAND, _STALL_Query, 0, 0, 0,
            EdCode.EncodeString(target.m_sUserName));
          g_LastNpcClick := GetTickCount;
        end;
        Exit;
      end;
      if ((target.Race = RCC_MERCHANT) or (target.m_boMonNPC and
        target.m_boFriendly)) and not target.m_boGateMan then
      begin
        if (g_LastSelNPC = target) and
          (GetTickCount - g_LastNpcClick < 1000) then
          Exit;
        if boHandleActor then
        begin
          if (g_LastSelNPC <> nil) and (g_LastSelNPC <> target) then
            FrmDlg.CloseMDlg(False);
          SendClientMessage(CM_CLICKNPC, target.m_nRecogId, 0, 0, 0);
          g_LastSelNPC := target;
          g_LastNpcClick := GetTickCount;
        end;
        Exit;
      end;
    end;

    if g_MySelf.m_btStall > 0 then
      Exit;

    PlayScene.CXYfromMouseXY(X, Y, g_nMouseCurrX, g_nMouseCurry);
    g_TargetCret := nil;
    if g_MySelf.m_btHorse = 0 then
    begin
      if (target = nil) and (g_UseItems[U_WEAPON].Name <> '') then
      begin
        if g_UseItems[U_WEAPON].S.Shape = 19 then
        begin
          tdir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY,
            g_nMouseCurrX, g_nMouseCurry);
          GetFrontPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir, nX, nY);
          if not Map.CanMove(nX, nY) or (ssShift in Shift) then
          begin
            if CanNextAction(caHit) and ServerAcceptNextAction and CanNextHit then
            begin
              case g_MySelf.m_btJob of
                _JOB_ARCHER:
                  g_MySelf.SendMsg(CM_HIT, MakeLong(g_MySelf.m_nCurrX,
                    g_MySelf.m_nCurrY), MakeLong(nX, nY), tdir, 0, 0, 0,
                    0, '', 0);
              else
                g_MySelf.SendMsg(CM_HEAVYHIT, MakeLong(g_MySelf.m_nCurrX,
                  g_MySelf.m_nCurrY), MakeLong(nX, nY), tdir, 0, 0, 0,
                  0, '', 0);
              end;
            end;
            g_boAutoDig := True;
            Exit;
          end;
        end;
      end;
    end;

    if (ssAlt in Shift) and (g_MySelf.m_btHorse = 0) then
    begin
      tdir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY,
        g_nMouseCurrX, g_nMouseCurry);
      if CanNextAction(caSitdown) and ServerAcceptNextAction then
      begin
        target := PlayScene.ButchAnimal(g_nMouseCurrX, g_nMouseCurry);
        g_AutoSearchItemTarget := target;
        // 自动探索对象
        if target <> nil then
        begin
          if GetTickCount - g_dwButchItemTick >= 1000 then
          begin
            SendButchAnimal(g_nMouseCurrX, g_nMouseCurry, tdir,
              target.m_nRecogId);
            g_dwButchItemTick := GetTickCount;
          end;
          g_MySelf.SendMsg(CM_SITDOWN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY,
            tdir, 0, 0, 0, 0, '', 0);
          Exit;
        end;
        g_MySelf.SendMsg(CM_SITDOWN, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, tdir,
          0, 0, 0, 0, '', 0); // 蹲下
      end;
      g_nTargetX := -1;
    end
    else
    begin
      if (target <> nil) or (ssShift in Shift) then
      begin
        g_nTargetX := -1;
        if target <> nil then
        begin
          if (not target.m_boDeath) and (g_MySelf.m_btHorse = 0) then
          begin
            g_TargetCret := target;
            if IsTarget(Shift, target) then // todo 是否必要
            begin
              AttackTarget(target, Shift);
              g_dwLatestHitTick := GetTickCount;
            end;
          end;
        end
        else
        begin
          if (g_MySelf.m_btHorse = 0) then
          begin
            tdir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY,
              g_nMouseCurrX, g_nMouseCurry);
            if CanNextAction(caHit) and ServerAcceptNextAction and CanNextHit then
            begin
              AMagic := nil;
              nHitMagicID := SKILL_ATTACK;
              nHitEff := 0;
              g_nTargetX := g_nMouseCurrX;
              g_nTargetY := g_nMouseCurry;
              AMinRange := Max(abs(g_MySelf.m_nCurrX - g_nTargetX),
                abs(g_MySelf.m_nCurrY - g_nTargetY));
              if (g_MySelf.m_btJob <> _JOB_ARCHER) and
                TryGetWarMagic(AMinRange, Shift, AMagic, AMagicType) then
              begin
                nHitMagicID := AMagic.wMagicId;
                nHitEff := MakeLong(MakeWord(AMagic.btEffectType,
                  AMagic.btEffect), AMagic.Strengthen);
                DeleteWarMagic(AMagic, AMagicType);
              end;
              case g_MySelf.m_btJob of
                _JOB_ARCHER:
                  g_MySelf.SendMsg(CM_HIT, MakeLong(g_MySelf.m_nCurrX,
                    g_MySelf.m_nCurrY), MakeLong(nX, nY), tdir, 0, nHitMagicID,
                    0, 0, '', 0, 0, nHitEff);
              else
                if (ssShift in Shift) then
                begin
                  AMagic := FindMagic([SKILL_89,SKILL_ERGUM]);
                  if AMagic <> nil then
                    nHitMagicID := AMagic.wMagicId;
                end;
                g_MySelf.SendMsg(CM_HEAVYHIT, MakeLong(g_MySelf.m_nCurrX,
                  g_MySelf.m_nCurrY), MakeLong(nX, nY), tdir, 0, nHitMagicID, 0,
                  0, '', 0, 0, nHitEff);
              end;
            end;
          end;
        end;
      end
      else
      begin
        if (g_nMouseCurrX = g_MySelf.m_nCurrX) and
          (g_nMouseCurry = g_MySelf.m_nCurrY) then
        begin
          if CanNextAction(caCommon) and ServerAcceptNextAction then
            SendPickup;
        end
        else
        begin
          if ssCtrl in Shift then
            g_ChrAction := caRun
          else
          begin
            if g_MySelf.m_boInSneak then
              g_ChrAction := caSneak
            else
              g_ChrAction := caWalk;
          end;
          g_nTargetX := g_nMouseCurrX;
          g_nTargetY := g_nMouseCurry;
        end;
      end;
    end;
  end;
end;

function TfrmMain.CheckDoorAction(dx, dy: Integer): Boolean;
var
  door: Integer;
begin
  Result := False;
  door := Map.GetDoor(dx, dy);
  if door > 0 then
  begin
    if not Map.IsDoorOpen(dx, dy) then
    begin
      SendClientMessage(CM_OPENDOOR, door, dx, dy, 0);
      Result := True;
    end;
  end;
end;

procedure TfrmMain.CheckHackTime;
begin
  while (not FAppTerminated) do
  begin
    if ClientConf.btAntiHackErrorRate > 0 then
    begin
      if OnLineTimeCheck.Run > ClientConf.btAntiHackErrorRate then
        g_MySelf := nil;
    end;
    Sleep(10);
  end;
end;

// 鼠标事件:当选择了魔法等攻击前，显示一个选择被攻击对象的鼠标
procedure TfrmMain.MouseTimerTimer(Sender: TObject);
var
  i: Integer;
  pt: TPoint;
  keyvalue: TKeyBoardState;
  Shift: TShiftState;
  AWarning: String;
  AWarningCount: Integer;
begin
  if FTryReconnet then
    Exit;
  if g_MySelf = nil then
    Exit;

  GetCursorPos(pt);
  SetCursorPos(pt.X, pt.Y);
  if g_TargetCret <> nil then
  begin
    if not ProcessKeyMessages then
    begin
      OutputDebugString(PChar('进入处理TimerTimer成功'));
      if not g_TargetCret.m_boDeath and
        PlayScene.IsValidActor(g_TargetCret) then
      begin
        if not g_boActionLock then
        begin
          FillChar(keyvalue, SizeOf(TKeyBoardState), #0);
          if GetKeyboardState(keyvalue) then
          begin
            OutputDebugString(PChar('尝试攻击目标'));
            Shift := [];
            if ((keyvalue[VK_SHIFT] and $80) <> 0) then
              Shift := Shift + [ssShift];
            if IsTarget(Shift, g_TargetCret) then
            begin
              OutputDebugString(PChar('攻击目标'));
              AttackTarget(g_TargetCret, Shift);
              g_dwLatestHitTick := GetTickCount;
            end;
          end;
        end;
      end
      else
        g_TargetCret := nil;
    end else
    begin
      OutputDebugString(PChar('进入处理TimerTimer失败'));
    end;
  end;
  if g_boAutoDig then
  begin // 自动挖矿
    if g_MySelf.m_btHorse > 0 then
      Exit;
    if CanNextAction(caHit) and ServerAcceptNextAction and CanNextHit then
    begin
      case g_MySelf.m_btJob of
        _JOB_ARCHER:
          g_MySelf.SendMsg(CM_HIT, MakeLong(g_MySelf.m_nCurrX,
            g_MySelf.m_nCurrY), 0, g_MySelf.m_btDir, 0, 0, 0, 0, '', 0);
      else
        g_MySelf.SendMsg(CM_HEAVYHIT, MakeLong(g_MySelf.m_nCurrX,
          g_MySelf.m_nCurrY), 0, g_MySelf.m_btDir, 0, 0, 0, 0, '', 0);
      end;
    end;
  end;
  // 自动捡取
  if g_Config.Assistant.AutoPuckUpItem and (g_MySelf <> nil) and
    ((GetTickCount() - g_dwAutoPickupTick) > 200) then
  begin
    g_dwAutoPickupTick := GetTickCount();
    AutoPickUpItem();
  end;
  NearActor;
  AutoEatItem;

  // 持久力警告
  if ((GetTickCount - g_SHowWarningDura) > 1000 * 60 * 5) and
    g_Config.Assistant.DuraWarning then
  begin
    AWarning := '';
    AWarningCount := 0;
    for i := U_DRESS to U_MAXUSEITEMIDX do
    begin
      if (g_UseItems[i].Name <> '') then
      begin
        case g_UseItems[i].S.StdMode of
          7, 25:
            ;
          5, 6, 10, 11:
            begin
              if Round((g_UseItems[i].Dura / g_UseItems[i].DuraMax) * 100)
                < 30 then
              begin
                Inc(AWarningCount);
                AWarning := '提示:您的[' + g_UseItems[i].DisplayName +
                  ']持久力较低,请及时进行修理!';
              end;
            end;
        else
          begin
            if Round((g_UseItems[i].Dura / g_UseItems[i].DuraMax) * 100)
              < 10 then
            begin
              Inc(AWarningCount);
              AWarning := '提示:您的[' + g_UseItems[i].DisplayName +
                ']持久力较低,请及时进行修理!';
            end;
          end;
        end;
      end;
    end;
    if AWarningCount = 1 then
      DScreen.UpdateSysMsg(AWarning, clYellow)
      // AddChatBoardString(AWarning, clRed, clWhite)
    else if AWarningCount > 1 then
      DScreen.UpdateSysMsg('提示:您穿戴的多件装备持久力均较低,请及时进行修理!', clYellow);
    // AddChatBoardString('提示:您穿戴的多件装备持久力均较低,请及时进行修理!', clRed, clWhite);
    g_SHowWarningDura := GetTickCount;
  end;

  if g_Config.Assistant.AutoMagic and (g_nAutoMagicKey >= 112) then
  begin
    if g_MySelf.m_boDeath then
      Exit;
    if g_MySelf.m_btHorse > 0 then
      Exit;
    if g_Config.Assistant.AutoMagicTime < 2 then
      g_Config.Assistant.AutoMagicTime := 2;
    if GetTickCount - g_nAutoMagicTimeKick > g_Config.Assistant.AutoMagicTime
      * 1000 then
    begin
      ActionKey := g_nAutoMagicKey;
      g_nAutoMagicTimeKick := GetTickCount;
    end;
  end;
end;

procedure TfrmMain.AutoPickUpItem;
var
  i: Integer;
  DropItem: PTDropItem;
begin

  if g_AutoPickupList = nil then
    Exit;
  g_AutoPickupList.Clear;
  PlayScene.GetXYDropItemsList(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY,
    g_AutoPickupList);

  if g_AutoPickupList.count > 0 then
    for i := 0 to g_AutoPickupList.count - 1 do
    begin
      DropItem := g_AutoPickupList.Items[i];
      if (DropItem <> nil) and (DropItem.Name <> '') then
        if g_Config.Assistant.AutoPuckUpItem then
        begin
          if g_Config.Assistant.FilterPickItem then
          begin
            if DropItem.BoPickup then
              SendPickup;
          end
          else
          begin
            SendPickup;
          end;
        end;
    end;
end;

procedure TfrmMain.WaitMsgTimerTimer(Sender: TObject);
begin
  if g_MySelf = nil then
    Exit;
  if g_MySelf.ActionFinished then
  begin
    WaitMsgTimer.Enabled := False;
    if WaitingMsg.ident = SM_CHANGEMAP then
    begin
      g_boMapMovingWait := False;
      g_boMapMoving := False;
      if g_nMDlgX <> -1 then
      begin
        FrmDlg.CloseMDlg(False);
        g_nMDlgX := -1;
      end;
      FrmDlg.CloseForMapChanged;
      ClearDropItems;
      g_sMapTitle := '';
      FrmDlg.DTMiniMapName.Propertites.Caption.Text := g_sMapTitle;
      g_MySelf.CleanCharMapSetting(WaitingMsg.Param, WaitingMsg.tag);
      PlayScene.SendMsg(SM_CHANGEMAP, WaitingMsg.Recog, WaitingMsg.Param { x } ,
        WaitingMsg.tag { y } , WaitingMsg.series { darkness } , 0, 0, 0, 0,
        WaitingStr { mapname } );
      g_nTargetX := -1;
    end;
  end;
end;

{ ----------------------- Socket ----------------------- }
// 在选择服务器后开启，等待一段时间后进入选择角色状态（等待“开门”的动画完成）
procedure TfrmMain.SelChrWaitTimerTimer(Sender: TObject);
begin
  SelChrWaitTimer.Enabled := False;
  SendQueryChr(1);
end;

procedure TfrmMain.ActiveCmdTimer(cmd: TTimerCommand);
begin
  CmdTimer.Enabled := True;
  TimerCmd := cmd;
end;

procedure TfrmMain.ActorCharDescChange(Msg: TDefaultMessage;
  const sBody: PPlatfromString);
var
  Actor: TActor;
  CharDesc: TCharDesc;
begin
  if PlayScene <> nil then
  begin
    Actor := PlayScene.FindActor(Msg.Recog);
    if Actor <> nil then
    begin
      DecodeBuffer(sBody, @CharDesc, SizeOf(CharDesc));
      PlayScene.SendMsg(SM_CHARDESC, Msg.Recog, 0, 0, 0, 0, 0, 0, 0,
        ''{$I UpdateActorFromCharDesc.inc});
    end;

  end;
end;

procedure TfrmMain.ActorNewSpellSkill(Source:TActor; AMagic: PTClientMagic;ASkillLevel:TSkillLevel);
var
  ATargx,
  ATargY,
  ATargId , nX, nY:Integer;
  ActType : SpellActionType;
  Effect: TSkillEffectConfig;
   AUseMagic: PTUseMagicInfo;
begin
  if Source = g_MySelf then
  begin
    if not Grobal2.SetContain(AMagic.nState, _MAGIC_STATE_LockTarget) then
      g_MagicTarget := g_FocusCret
    else
    begin
      if not g_Config.Assistant.MagicLock or
        (PlayScene.IsValidActor(g_FocusCret) and not g_FocusCret.m_boDeath and
        (g_FocusCret.Race <> 50)) then
        g_MagicLockActor := g_FocusCret;
      g_MagicTarget := g_MagicLockActor;
    end;

    if not PlayScene.IsValidActor(g_MagicTarget) then
      g_MagicTarget := nil;

    if g_MagicTarget = nil then
    begin
      ATargx := g_nMouseCurrX ;
      ATargY := g_nMouseCurrY ;
      ATargId := 0;
    end
    else
    begin
      ATargx := g_MagicTarget.m_nCurrX;
      ATargY := g_MagicTarget.m_nCurrY;
      ATargId := g_MagicTarget.m_nRecogId;
    end;

    if AMagic.btEffectType <= Ord(High(SpellActionType)) then
      ActType := SpellActionType(AMagic.btEffectType)
    else
      ActType := patNone;
  end else
  begin
    ActType := ASkillLevel.ActionType;
  end;

  case ActType of
    patNone:begin
      if Source = g_MySelf then
      SendUseSkill(AMagic.wMagicId,AMagic.Level,ATargId,ATargx,ATargY,Source.m_btDir); //无动作
    end;
    patSpell: Begin //施法
      if Source = g_MySelf then
        SpellMagic(AMagic,0,ATargx,ATargY,ATargId)
      else
      begin
        Source.SendMsg(SM_SPELL,0,0,Source.m_btDir,0,0,0,0,'',0);
      end;
    end;
    patAttack: begin //攻击
      GetFrontPosition(Source.m_nCurrX, Source.m_nCurrY, Source.m_btDir, nX, nY);
      Source.SendMsg(CM_HEAVYHIT, MakeLong(Source.m_nCurrX,
            Source.m_nCurrY), MakeLong(nX, nY), Source.m_btDir, 0, AMagic.wMagicId, 0,
            0, '', 0, 0, AMagic.btEffect);
    end;
    patHeavyHit:
    begin
      //TODO
    end;
    patDefine:
    begin
      //自定义动作ID
    end;
  end;

  //添加特效。
  Source.AddSkillEffect(nil,ASkillLevel.EffectID,0,0,ASkillLevel.EffectDelay,0,False);

  PlayScene.AddDelaySound(ASkillLevel.SoundID,ASkillLevel.SoundDelay);
end;


procedure TfrmMain.CmdTimerTimer(Sender: TObject);
begin
  CmdTimer.Enabled := False;
  CmdTimer.Interval := 500;
  case TimerCmd of
    tcSoftClose:
      begin
        CmdTimer.Enabled := False;
        FNetChanging := True;
        try
          CSocket.Close;
        finally
          FNetChanging := False;
        end;
      end;
    tcReSelConnect:
      begin
        ResetGameVariables;
        DScreen.ChangeScene(stSelectChr);
        g_ConnectionStep := cnsReSelChr;
        SocketOpen(g_sSelChrAddr, g_nSelChrPort);
      end;
    tcFastQueryChr:
      begin
        SendQueryChr(0);
      end;
    tcReConnect:
      begin
        Inc(FRunRouteIndex);
        if FRunRouteIndex > FRunRoutes.count - 1 then
          FRunRouteIndex := 0;
        g_sRunServerAddr := FRunRoutes.Names[FRunRouteIndex];
        g_nRunServerPort :=
          StrToIntDef(FRunRoutes.ValueFromIndex[FRunRouteIndex], 0);

        g_ConnectionStep := cnsPlay;
        FTryReconnet := True;
        g_boServerChanging := True;
        SocketOpen(g_sRunServerAddr, g_nRunServerPort);
      end;
  end;
end;

procedure TfrmMain.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
end;

procedure TfrmMain.SocketOpen(const Address: String; Port: Integer);
begin
  VMProtectSDK.VMProtectBeginUltra('CreateSocket');
  FNetChanging := True;
  try
    CSocket.Close;
    CSocket.Address := Address;
    CSocket.Port := Port;
    CSocket.Open;
  finally
    FNetChanging := False;
  end;
  VMProtectSDK.VMProtectEnd;
end;

procedure TfrmMain.StartBeCool(Open: Boolean);
var
  Maigc: PTClientMagic;
begin
  ClearNextMagic(); // 清空所有下一次攻击的技能
  if Open then
  begin
    AddNextMagic(SKILL_167, 0);
    AddNextMagic(SKILL_163, 0);
    AddNextMagic(SKILL_159, 0);
  end;
end;

procedure TfrmMain.CloseAllWindows;
var
  i: Integer;
  d: TAsphyreLockableTexture;
begin
  with FrmDlg do
  begin
    DItemBag.Visible := False;
    DMsgDlg.Visible := False;
    DStateWin.Visible := False; // 人物信息栏
    DMerchantDlg.Visible := False;
    DSellDlg.Visible := False;
    DMenuDlg.Visible := False;
    DKeySelDlg.Visible := False;
    DGroupDlg.Visible := False;
    DDealDlg.Visible := False;
    DWChallenge.Visible := False;
    DDealRemoteDlg.Visible := False;
    DGuildDlg.Visible := False;
    DGuildEditNotice.Visible := False;
    DUserState1.Visible := False;
    DAdjustAbility.Visible := False;
    DBoxs.Visible := False;
    DWMiniMap.Visible := False;
    DWMaxMiniMap.Visible := False;
    FillChar(g_BoxsItems[0], SizeOf(g_BoxsItems), #0);
    FillChar(g_SellOffItems[0], SizeOf(g_SellOffItems), #0);
    DPlayDrink.Visible := False;
    DWPleaseDrink.Visible := False;
    // DBotMemo.Visible := False;
    DShop.Visible := False;
    DItemsUp.Visible := False;
    DFriendDlg.Visible := False;
    DWMakeWineDesk.Visible := False;
    DLevelOrder.Visible := False;
    DSighIcon.Visible := False;
    DWDice.Visible := False;
    // 隐藏感叹号图标 //****原版代码编译不成功 2009-10-27 邱高奇 已经被注释****//
    // DWExpCrystal.Visible := False;  //****原版代码编译不成功 2009-10-27 邱高奇 已经被注释****//
    FillChar(g_ItemsUpItem, ClientItemSize * 3, #0); // 清空淬炼格里的物品
    FillChar(g_PDrinkItem, ClientItemSize * 2, #0);
    FillChar(g_WineItem, ClientItemSize * 7, #0);
    FillChar(g_DrugWineItem, ClientItemSize * 3, #0);
    ShowBoxsGird(False); // 隐藏宝箱格
    g_BoxsShowPosition := -1;
    g_boIsInternalForce := False;
    g_btInternalForceLevel := 0;
    g_btHeroInternalForceLevel := 0;
    DWMarket.Visible := False;
    DWMarketItem.Visible := False;
    DMailList.Visible := False;
    DMailReader.Visible := False;
    DMailWriter.Visible := False;
    DWProgress.Visible := False;
    DHintWindow.Visible := False;
    DWMiniMissions.Visible := False;
    DWMissions.Visible := False;
    DMissionContent.Lines.Clear;
    DBMissionDoing.tag := 1;
    g_MissionTopIndex := 0;
    g_SelectMission := -1;
    g_MissionListTopIndex := 0;
    g_MissionListSelected := -1;
    g_MissionListFocused := -1;

    if g_InternalForceMagicList.count > 0 then
      for i := 0 to g_InternalForceMagicList.count - 1 do
        Dispose(PTClientMagic(g_InternalForceMagicList[i]));
    g_InternalForceMagicList.Clear;

    if g_BatterMagicList.count > 0 then
      for i := 0 to g_BatterMagicList.count - 1 do
        Dispose(PTClientMagic(g_BatterMagicList[i]));
    g_BatterMagicList.Clear;

    if g_HeroBatterMagicList.count > 0 then
      for i := 0 to g_HeroBatterMagicList.count - 1 do
        Dispose(PTClientMagic(g_HeroBatterMagicList[i]));
    g_HeroBatterMagicList.Clear;
    g_BatterMenuNameList.Clear;

    if g_HeroInternalForceMagicList.count > 0 then
      for i := 0 to g_HeroInternalForceMagicList.count - 1 do
        Dispose(PTClientMagic(g_HeroInternalForceMagicList[i]));
    g_HeroInternalForceMagicList.Clear;

    DWHeadHealth.Visible := False;
    DWGroups.Visible := False;
    ClearExtendbuttons;
    ClearBuffers;
    ClearSideBarButtons;
    DWChatHistory.Visible := False;
  end;
  frmNewItem.CloseAllDlg;
  FrmDlg.CloseMDlg(True);
  g_nMDlgX := -1;
  g_boItemMoving := False;
  g_boUseBatter := False;
  g_boCanUseBatter := False;
  AssistantForm.DWAssistant.Visible := False;
  FrmDXDialogs.CloseDialogs;
  g_Mail.Clear;
  g_MailLoaded := False;
  g_Guild.Clear;
end;

procedure TfrmMain.ClearDialogMessages;
var
  i: Integer;
begin
  for i := 0 to FDlgMessageList.count - 1 do
    FreeMem(FDlgMessageList[i]);
  FDlgMessageList.Clear;
end;

function TfrmMain.AutoUnPack(Eating: Boolean; AKind: Byte;
  const AMessage: String):Boolean;
var
  i, EmptyBagGrid: Integer;
  AAutoUnbind: Boolean;
  ABulkCount, ANeedBagSize: Integer;
  AFoundedItem: Boolean;
  AUnbindItem: pTStdItem;
  AHMPHItem, AHMPMItem, AHPItem, AMPItem, ANextEatItem: Integer;
begin
  Result := False;
  EmptyBagGrid := 0;
  for i := 6 to MAXBAGITEM + 6 - 1 do
  begin
    if g_ItemArr[i].Name = '' then
      Inc(EmptyBagGrid);
  end;
  g_EatingItemIndex := -1;

  ABulkCount := 0;
  ANeedBagSize := 0;
  AFoundedItem := False;
  if Eating then
  begin
    for i := 6 to MAXBAGITEM - 1 do
    begin
      if (g_ItemArr[i].Name <> '') and (g_ItemArr[i].S.StdMode = 31) and
        (g_ItemArr[i].AniCount = 1) then
      begin
        if (g_ItemArr[i].S.ACMin = g_EatingItem.S.Index - 1) then
        begin
          ANeedBagSize := Math.Ceil(g_ItemArr[i].S.MACMin /
            Math.Max(g_EatingItem.S.DuraMax, 1));
          AFoundedItem := True;
          if ANeedBagSize <= EmptyBagGrid then
          begin
            g_dwEatTime := 0;
            EatItem(i, False);
            Exit;
          end;
        end;
      end;
    end;
  end;

  AHMPHItem := -1;
  AHMPMItem := -1;
  AHPItem := -1;
  AMPItem := -1;
  ANextEatItem := -1;
  if not Eating or (g_EatingItem.S.StdMode = 0) then
  begin
    for i := 6 to MAXBAGITEM - 1 do
    begin
      if (g_ItemArr[i].Name <> '') and (g_ItemArr[i].S.StdMode = 31) and
        (g_ItemArr[i].AniCount = 1) and
        (not Eating or (g_ItemArr[i].S.ACMin <> g_EatingItem.S.Index - 1)) then
      begin
        if (g_ItemArr[i].S.ACMin >= 0) and
          (g_ItemArr[i].S.ACMin < g_ItemList.count - 1) then
        begin
          AUnbindItem := g_ItemList[g_ItemArr[i].S.ACMin + 1];
          if AUnbindItem <> nil then
          begin
            ANeedBagSize :=
              Math.Ceil(g_ItemArr[i].S.MACMin /
              Math.Max(AUnbindItem.DuraMax, 1));
            if AUnbindItem.Shape = 1 then
            begin
              if AUnbindItem.ACMin > 0 then
              begin
                if (ANeedBagSize <= EmptyBagGrid) and (AHMPHItem = -1) then
                  AHMPHItem := i;
                AFoundedItem := True;
              end
              else if AUnbindItem.MACMin > 0 then
              begin
                if (ANeedBagSize <= EmptyBagGrid) and (AHMPMItem = -1) then
                  AHMPMItem := i;
                AFoundedItem := True;
              end;
            end
            else
            begin
              if AUnbindItem.ACMin > 0 then
              begin
                if (ANeedBagSize <= EmptyBagGrid) and (AHPItem = -1) then
                begin
                  AHPItem := i;
                  AFoundedItem := True;
                end;
              end
              else if AUnbindItem.MACMin > 0 then
              begin
                if (ANeedBagSize <= EmptyBagGrid) and (AMPItem = -1) then
                begin
                  AMPItem := i;
                  AFoundedItem := True;
                end;
              end;
            end;
          end;
        end;
      end;
    end;

    if Eating then
    begin
      if g_EatingItem.S.Shape = 0 then
      begin
        if g_EatingItem.S.ACMin > 0 then
        begin
          if AHPItem <> -1 then
            ANextEatItem := AHPItem;
        end
        else if g_EatingItem.S.MACMin > 0 then
        begin
          if AMPItem <> -1 then
            ANextEatItem := AMPItem;
        end;
      end
      else
      begin
        if g_Config.Assistant.SpecialHp and
          (g_MySelf.m_Abil.HP < g_Config.Assistant.EditSpecialHp) and
          ((GetTickCount - g_dwSpecialHpTick) >
          g_Config.Assistant.EditSpecialHpTimer) then
        begin
          if AHMPHItem <> -1 then
            ANextEatItem := AHMPHItem;
        end;
        if g_Config.Assistant.SpecialMP and
          (g_MySelf.m_Abil.MP < g_Config.Assistant.EditSpecialMP) and
          ((GetTickCount - g_dwSpecialMPTick) >
          g_Config.Assistant.EditSpecialMPTimer) then
        begin
          if AHMPMItem <> -1 then
            ANextEatItem := AHMPMItem;
        end;
      end;
    end
    else
    begin
      case AKind of
        1:
          begin
            if AHPItem <> -1 then
              ANextEatItem := AHPItem;
          end;
        2:
          begin
            if AMPItem <> -1 then
              ANextEatItem := AMPItem;
          end;
        3:
          begin
            if AHMPHItem <> -1 then
              ANextEatItem := AHMPHItem;
          end;
        4:
          begin
            if AHMPMItem <> -1 then
              ANextEatItem := AHMPMItem;
          end;
      end;
    end;

    if ANextEatItem <> -1 then
    begin
      OutputDebugString(PChar('解包药水'));
      EatItem(ANextEatItem, False,true);
      Result := true;
      Exit;
    end;
  end;

  if AKind <> 0 then
  begin
    if AFoundedItem and (ANextEatItem <> - 1)  then
      DScreen.UpdateSysMsg('包裹空间不够，无法解包！', clYellow)
    else if AMessage <> '' then
      DScreen.UpdateSysMsg(AMessage, clYellow);
  end;
  // if AFoundedItem then
  // AddChatBoardString('包裹空间不够，无法解包！', clWhite, clBlue)
  // else if AMessage <> '' then
  // AddChatBoardString(AMessage, clWhite, clRed);
end;

procedure TfrmMain.WMSysCommand(var Message: TWMSysCommand);
begin
  if (Message.Msg = 274) and (Message.CmdType = 61696) then
  begin
    // ALT F10 卡界面
  end
  else
    inherited;
end;

procedure TfrmMain.OnClickSound(Sender: TObject; Clicksound: TClickSound);
begin
  case Clicksound of
    csNorm:
      g_SoundManager.DXPlaySound(s_norm_button_click);
    csStone:
      g_SoundManager.DXPlaySound(s_rock_button_click);
    csGlass:
      g_SoundManager.DXPlaySound(s_glass_button_click);
  end;
end;

procedure TfrmMain.ClearDropItems;
var
  i: Integer;
begin
  if g_DropedItemList.count > 0 then
  begin // 20080629
    for i := 0 to g_DropedItemList.count - 1 do
    begin
      System.Finalize(PTDropItem(g_DropedItemList[i])^);
      Dispose(PTDropItem(g_DropedItemList[i]));
    end;
    g_DropedItemList.Clear;
  end;
end;

procedure TfrmMain.ResetGameVariables;
var
  i: Integer;
begin
  try
    Caption := g_MirStartupInfo.sServerName;
    CloseAllWindows;
    ClearDropItems;
    if g_MagicList.count > 0 then
    begin // 20080629
      for i := 0 to g_MagicList.count - 1 do
      begin
        if PTClientMagic(g_MagicList[i]) <> nil then
          Dispose(PTClientMagic(g_MagicList[i]));
      end;
      g_MagicList.Clear;
    end;

    for i := 0 to g_Titles.count - 1 do
    begin
      if pTClientHumTitle(g_Titles.Items[i]) <> nil then
        Dispose(pTClientHumTitle(g_Titles.Items[i]));
    end;
    g_Titles.Clear;
    g_ActiveTitle := 0;
    g_TitlesPage := 0;

    g_MyNextMagics.Clear;
    g_MyOpendMagics.Clear;

    g_boItemMoving := False;
    g_WaitingUseItem.Item.Name := '';
    g_EatingItem.Name := '';
    g_nTargetX := -1;
    g_TargetCret := nil;
    g_FocusCret := nil;
    g_MagicLockActor := nil;
    g_MagicTarget := nil;
    g_LastSelNPC := nil;
    g_LastNpcClick := 0;
    ActionLock := False;
    g_GroupMembers.Clear;
    g_sGuildRankName := '';
    g_sGuildName := '';
    g_boMapMoving := False;
    WaitMsgTimer.Enabled := False;
    g_boMapMovingWait := False;
    DScreen.ChatMessage.topline := 0;
    g_boDialog := False;
    g_SighIconMethods.Clear;
    g_SighIconHints.Clear;
    UpdateSighIcon;

    FillChar(g_UseItems[0], SizeOf(g_UseItems), #0);
    g_MyDressInnerEff := nil;
    g_MyWeponInnerEff := nil;
    // 2008.01.16 修正  原为9

    FillChar(g_BoxsItems[0], SizeOf(g_BoxsItems), #0);
    FillChar(g_SellOffItems[0], SizeOf(g_SellOffItems), #0);
    FillChar(g_ItemArr[0], SizeOf(g_ItemArr), #0);

    SelectChrScene.ClearChrs;
    PlayScene.ClearActors;
    ClearDropItems;
    EventMan.ClearEvents;
    PlayScene.CleanObjects;
    ClearRelation;
    ClearDialogMessages;
    g_MySelf := nil;
    g_boLockMoveItem := False;
    g_dwLockMoveItemTimeStart := 0;
    g_nLockMoveItemTime := 0;
    DScreen.OutScene(stPlayGame);

    g_StartGameTick := GetTickCount + STARTGAMEWAIT
  except
  end;
end;

procedure TfrmMain.ChangeServerClearGameVariables;
var
  i: Integer;
begin
  CloseAllWindows;
  ClearDropItems;
  if g_MagicList.count > 0 then
    // 20080629
    for i := 0 to g_MagicList.count - 1 do
      Dispose(PTClientMagic(g_MagicList[i]));
  g_MagicList.Clear;
  g_boItemMoving := False;
  g_WaitingUseItem.Item.Name := '';
  g_EatingItem.Name := '';
  g_nTargetX := -1;
  g_TargetCret := nil;
  g_FocusCret := nil;
  g_MagicLockActor := nil;
  g_MagicTarget := nil;
  ActionLock := False;
  g_GroupMembers.Clear;
  g_sGuildRankName := '';
  g_sGuildName := '';

  g_boMapMoving := False;
  WaitMsgTimer.Enabled := False;
  g_boMapMovingWait := False;

  ClearDropItems;
  EventMan.ClearEvents;
  PlayScene.CleanObjects;
end;

procedure TfrmMain.SendSocket(AMessage: TDefaultMessage;
  const AData: PPlatfromString = '');
begin
  AMessage.nToken := FMessageIndex;
  Inc(FMessageIndex);
  if FMessageIndex >= 2100000000 then
    FMessageIndex := 0;
  if AData <> '' then
    AMessage.CRC := MakeCRC32(0, PPlatfromChar(AData), Length(AData));
  SendSocket(EncodeMessage(AMessage) + AData);
end;

procedure TfrmMain.SendSocket(const AData: PPlatfromString;
  DefMsgType: Byte = 0);
var
  C: AnsiChar;
  K: string;
  SocketIndex:Integer;
begin
  VMProtectBeginVirtualization('SendSocketData');
  if CSocket.Active and not FBreakOff then
  begin
    SocketIndex := g_GameData.SendPackageIndex.Data;

    if DefMsgType <> 0 then
    begin
      C := AnsiChar(58 + SocketIndex);
      SendStr('#' + C + IntToStr(DefMsgType) + AData + '!');
    end
    else
    begin
      SendStr('#' + IntToStr(SocketIndex) + AData + '!');
    end;

    SocketIndex := AddPackIdx(SocketIndex);

    g_GameData.SendPackageIndex.Data := SocketIndex;
  end;
  VMProtectEnd;
end;

procedure TfrmMain.SendClientMessage(ident, Recog, Param, tag, series: Integer;
  const AData: AnsiString);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(ident, Recog, Param, tag, series, Certification);
  SendSocket(Msg, AData);
end;

procedure TfrmMain.SendLogin(uid, passwd: string);
var
  Msg: TDefaultMessage;
begin
  LoginID := uid;
  LoginPasswd := passwd;
  Msg := MakeDefaultMsg(CM_IDPASSWORD, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(uid + '/' + passwd));
  g_boSendLogin := True;
end;

procedure TfrmMain.SendNewAccount(ue: TUserEntry);
var
  Msg: TDefaultMessage;
begin
  MakeNewId := ue.sAccount;
  Msg := MakeDefaultMsg(CM_ADDNEWUSER, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EncodeBuffer(@ue, SizeOf(TUserEntry)));
end;

procedure TfrmMain.SendUpdateAccount(ue: TUserEntry);
var
  Msg: TDefaultMessage;
begin
  MakeNewId := ue.sAccount;
  Msg := MakeDefaultMsg(CM_UPDATEUSER, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EncodeBuffer(@ue, SizeOf(TUserEntry)));
end;

procedure TfrmMain.SendUseSkill(ID,Level,TargetID, X, Y: Integer;Direction:Byte);
var
  nXY:Integer;
begin
  nXY := MakeLong(X,Y);     //目标 技能ID 坐标XY
  SendClientMessage(SYSTEMIDENT(SYSTEM_CODE_SKILL,SKILL_CM_Spell),TargetID,ID,nXY,MakeLong(Direction,Level));
  ActionLock := True;
  ActionLockTime := GetTickCount;
  Inc(g_nSendCount);
end;

procedure TfrmMain.SendSelectServer(svname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SELECTSERVER, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(svname) + '/' +
    EdCode.EncodeString(g_sServerAddr));
end;

procedure TfrmMain.SendChgPw(Id, passwd, newpasswd: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_CHANGEPASSWORD, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(Id + #9 + passwd + #9 + newpasswd));
end;

procedure TfrmMain.SendNewChr(uid, uname, shair, sjob, ssex: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_NEWCHR, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(uid + '/' + uname + '/' + shair + '/' +
    sjob + '/' + ssex));
end;

procedure TfrmMain.SendQueryChr(Code: Byte);
// Code为1则查询验证码  为0则不查询
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_QUERYCHR, 0, 0, 0, Code, Certification);
  SendSocket(Msg, EdCode.EncodeString(LoginID + '/' + IntToStr(Certification)));
end;

procedure TfrmMain.SendDelChr(chrname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DELCHR, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(chrname));
end;

procedure TfrmMain.SendSelChr(chrname: string);
var
  Msg: TDefaultMessage;
begin
  CharName := chrname;
  Msg := MakeDefaultMsg(CM_SELCHR, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(LoginID) + '/' +
    EdCode.EncodeString(chrname) + '/' + EdCode.EncodeString(g_sServerAddr));
  FrmDlg.btnRecvChrCloseClick(Self, 0, 0);
  Caption := g_MirStartupInfo.sServerName + ' - ' + CharName;
end;

procedure TfrmMain.SendRunLogin;
var
  sSendMsg, sBeijTime, sSL: String;
  AStartupInfo: TMirStartupInfo;
begin
  VMProtectSDK.VMProtectBeginVirtualization('SendRunLogin');
{$IF defined(DEBUG) or defined(DEVMODE)}
  AStartupInfo := g_MirStartupInfo;
{$ELSE}
  FillChar(AStartupInfo, SizeOf(TMirStartupInfo), #0);
  uEDCode.DecodeSourceData(ClientParamStr, AStartupInfo,
    SizeOf(TMirStartupInfo));
{$IFEND}
  sBeijTime := 'A';
  if FBeijTime <> '' then
  begin
    try
      sBeijTime := uEDCode.DecodeString(FBeijTime,
        uEDCode.DecodeSource
        ('5kiTHcfT6Btu+ixxoXAd1bA0w78NrekspG4BW78XoWKKG+qKPblpHZCSR8xLBTO2pxb61XIK')
        );
    except
      sBeijTime := 'A';
    end;
  end;
  // sSL := uEDCode.EncodeString(uMD5.MD5String('B46F3CFD-2D67-415B-94E8-0F68C6D76762'{ARecrodID} + 'B2C2BCCE-5002-4E53-B5C9-C953496F0346'{AUserID}), 'C2F40ED2-E8A9-4E99-9784-3A40F9BF26BF');
  sSL := AStartupInfo.sL;
  sSL := StringReplace(sSL, '/', 'X99', [rfReplaceAll]);
  sSL := StringReplace(sSL, '+', 'X98', [rfReplaceAll]);
  sBeijTime := uEDCode.EncodeSource(sBeijTime);
  sBeijTime := StringReplace(sBeijTime, '/', 'X99', [rfReplaceAll]);
  sBeijTime := StringReplace(sBeijTime, '+', 'X98', [rfReplaceAll]);
  sSendMsg := Format('**%s/%s/%d/%d/%d/%s/%s/%s/%s/%s/**********',
    [LoginID, CharName, Certification, CLIENT_VERSION_NUMBER, 0, APP_VERSION,
    FMachineCode, sBeijTime, sSL, OSUtils.TOSVersion.ToString]);
  SendSocket(EdCode.EncodeString(sSendMsg));
  VMProtectSDK.VMProtectEnd;
end;

procedure TfrmMain.SendSay(str: string);
var
  Msg: TDefaultMessage;
begin
  if str <> '' then
  begin
    if m_boPasswordIntputStatus then
    begin
      m_boPasswordIntputStatus := False;
      FrmDlg.DEChat.PasswordChar := #0;
      SendPassword(str, 1);
      Exit;
    end;

    if str = '@password' then
    begin
      if FrmDlg.DEChat.PasswordChar = #0 then
        FrmDlg.DEChat.PasswordChar := '*'
      else
        FrmDlg.DEChat.PasswordChar := #0;
      Exit;
    end;
    if FrmDlg.DEChat.PasswordChar = '*' then
      FrmDlg.DEChat.PasswordChar := #0;

    Msg := MakeDefaultMsg(CM_SAY, 0, 0, 0, 0, Certification);
    SendSocket(Msg, EdCode.EncodeString(str));
    if str[1] = '/' then
    begin
      AddChatBoardString(str, GetRGB(180), clWhite);
      GetValidStr3(Copy(str, 2, Length(str) - 1), WhisperName, [' ']);
    end;
  end;
end;

procedure TfrmMain.SendShortCut(ACommand: Integer; const S: AnsiString);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SHORTCUT, ACommand, 0, 0, 0, Certification);
  SendSocket(Msg, S);
end;

procedure TfrmMain.SendMessageState(_Type: Integer; Value: Boolean);
begin
  SendClientMessage(CM_SETMESSAGESTATE, _Type, Ord(Value), 0, 0, '');
end;

type
  TSayMatchEvaluator = class
  private
    FIDs: TStrings;
    function MatchEvaluator(const Match: TMatch): string;
    function DoMaskString(const S, ObjList: String): String;
  public
    class function MaskString(const S, ObjList: String): String;
  end;

function TSayMatchEvaluator.MatchEvaluator(const Match: TMatch): string;
begin
  Result := Common.MakeNewGUID32;
  FIDs.Add(Format('%s=%s', [Result, Match.Value]));
end;

function TSayMatchEvaluator.DoMaskString(const S, ObjList: String): string;
var
  C: Char;
  L: TStrings;
  i: Integer;
begin
  Result := S;
  C := #0;
  if Result[1] in ['/', '@'] then
  begin
    C := Result[1];
    Delete(Result, 1, 1);
  end;
  L := TStringList.Create;
  FIDs := TStringList.Create;
  try
    ExtractStrings(['/'], [], PChar(ObjList), L);
    for i := 0 to L.count - 1 do
    begin
      Result := TRegEx.Replace(Result, Format('\{S=.*?;E=%d}', [i]),
        MatchEvaluator);
    end;
    Result := Common.MakeMaskString(Result);
    for i := 0 to FIDs.count - 1 do
      Result := StringReplace(Result, FIDs.Names[i],
        FIDs.ValueFromIndex[i], []);
    if C <> #0 then
      Result := C + Result;
  finally
    FreeAndNilEx(L);
    FreeAndNilEx(FIDs);
  end;
end;

class function TSayMatchEvaluator.MaskString(const S, ObjList: String): String;
var
  AMatchEvaluator: TSayMatchEvaluator;
begin
  AMatchEvaluator := TSayMatchEvaluator.Create;
  try
    Result := AMatchEvaluator.DoMaskString(S, ObjList);
  finally
    FreeAndNilEx(AMatchEvaluator);
  end;
end;

procedure TfrmMain.SendSayEx(const str, ObjList: String);
var
  Msg: TDefaultMessage;
  S: String;
  AMatchEvaluator: TSayMatchEvaluator;
  sSend: string;
  i:Integer;
  List : TStringList;
begin
  if str <> '' then
  begin
{$IFDEF DEVMODE}
    if CompareText(str, '@debugui') = 0 then
    begin
      frmDlgConfig.Open;
      Exit;
    end;
{$ENDIF}
{$IFDEF DEBUG}
    if CompareText('@DumpSocket', str) = 0 then
    begin
      DumpSocket;
      Exit;
    end;

    if CompareText('@ShowHiTick', str) = 0 then
    begin
      DScreen.AddChatBoardString(Format('当前攻击时间:%d',[g_GameData.LastHitTime.Data]),'',clwhite,clred);
      Exit;
    end;

    if CompareText('@AddHitSpeed', str) = 0 then
    begin
      g_GameData.HitTime.Data := g_GameData.HitTime.Data - 10;
      DScreen.AddChatBoardString(Format('当前攻击间隔:%d',[g_GameData.HitTime.Data]),'',clwhite,clred);
      Exit;
    end;

    if CompareText('@DecHitSpeed', str) = 0 then
    begin
      g_GameData.HitTime.Data := g_GameData.HitTime.Data + 10;
      DScreen.AddChatBoardString(Format('当前攻击间隔:%d',[g_GameData.HitTime.Data]),'',clwhite,clred);
      Exit;
    end;

    if CompareText('@TestRunGate',Str) = 0 then
    begin
      BoPacketSplicingTest := not BoPacketSplicingTest;
      DScreen.AddChatBoardString(Format('粘包测试:%s',[BoolToStr(BoPacketSplicingTest)]),'',clwhite,clred);
      Exit;
    end;


    if CompareText('@ClearMem',Str) = 0 then
    begin
      LibManager.FreeAllTextureMemory;
      DScreen.AddChatBoardString('清除内存完成','',clwhite,clred);
      Exit;
    end;

    if CompareText('@ListWMI',Str) = 0 then
    begin
      List := TStringList.Create;
      for i := 0 to TWMImages.AllWMImages.Count - 1 do
      begin
        List.Add(TWMImages.AllWMImages[i].FileName);
      end;
      List.SaveToFile('D:\ListWMI.txt');
    end;

{$ENDIF}


    if CompareText('@DumpMemState',Str) = 0 then
    begin
      fastmm4.LogMemoryManagerStateToFile('.\91ClientDumpMemState.txt','  WILResourceMemUseage:' + IntToStr(WIL.TWMImages.MemmoryUsage));
      Exit;
    end;

    Msg := MakeDefaultMsg(CM_SAY, 0, 0, 0, 0, Certification);
    sSend := StringReplace(str, '<', '#60', [rfReplaceAll]);
    sSend := StringReplace(sSend, '>', '#62', [rfReplaceAll]);
    if ObjList = '' then
    begin
      sSend := StringReplace(sSend,'{','',[rfReplaceAll]);
      sSend := StringReplace(sSend,'}','',[rfReplaceAll]);
    end;

    SendSocket(Msg, EdCode.EncodeString(sSend) + '/' + ObjList);
    if str[1] = '/' then
    begin
      S := TSayMatchEvaluator.MaskString(str, ObjList);
      AddChatBoardString(S, GetRGB(180), clWhite, ObjList);
      DScreen.ChatHisMessage.AddMessage('{S=#91' + FormatDateTime('hh:mm:ss',
        Now) + '#93;C=248} ' + S, ObjList, clGreen, clNone);
      GetValidStr3(Copy(S, 2, Length(S) - 1), WhisperName, [' ']);
    end;
  end;
end;

// procedure TfrmMain.SendActMsg(ident, X, Y, dir: Integer);
// var
// Msg: TDefaultMessage;
// begin
// Msg := MakeDefaultMsg(ident, MakeLong(X, Y), 0, dir, 0, Certification);
// SendSocket(Msg);
// ActionLock := TRUE;
// ActionLockTime := GetTickCount;
// Inc(g_nSendCount);
// end;
//
var
  g_SendActTick: Cardinal = 0;

procedure TfrmMain.SendActMsg(ident, X, Y, dir: Integer);
var
  Msg: TMoveMessage;
  sText: AnsiString;
begin
  Msg.X_Y_Dir := BuildXYDir(X, Y, dir);
  Msg.wIdent := ident;
  Msg.dwClientTick := timeGetTime;

  g_SendActTick := Msg.dwClientTick;

  sText := EncodeBuffer(PAnsiChar(@Msg), SizeOf(Msg));
  SendSocket(sText, _MSGTYPE_MoveMsg);
  ActionLock := True;
  ActionLockTime := GetTickCount;
  Inc(g_nSendCount);
end;

procedure TfrmMain.SendSpellMsg(ident, X, Y, dir, target: Integer);
var
  Msg: TDefaultMessage;
  AMagic: PTClientMagic;
begin
  if TryGetMagic(dir, AMagic) then
    AMagic.UseTime := GetTickCount;
  Msg := MakeDefaultMsg(ident, MakeLong(X, Y), target, dir, 0, Certification);
  SendSocket(Msg);
  ActionLock := True;
  ActionLockTime := GetTickCount;
  Inc(g_nSendCount);
end;

// procedure TfrmMain.SendHitMsg(ident, X, Y, dir, nMagicID, nTarget: Integer);
// var
// Msg: TDefaultMessage;
// AMagic: PTClientMagic;
// begin
// if TryGetMagic(nMagicID, AMagic) then
// AMagic.UseTime := GetTickCount;
// Msg := MakeDefaultMsg(ident, X, Y, MakeLong(nMagicID, dir), nTarget, Certification);
// SendSocket(Msg);
// ActionLock := TRUE;
// ActionLockTime := GetTickCount;
// Inc(g_nSendCount);
// end;

procedure TfrmMain.SendHitMsg(ident, X, Y, dir, nMagicID, nTarget: Integer);
var
  Msg: TATTACKMSG;
  AMagic: PTClientMagic;
  sText: AnsiString;
  wSourceX, wSourceY, wDestX, wDestY: Word;
begin
  if TryGetMagic(nMagicID, AMagic) then
    AMagic.UseTime := GetTickCount;

  Msg.wIdent := ident;

  Msg.magid := nMagicID;
  Msg.TargetRecog := nTarget;
  wSourceX := Loword(X);
  wSourceY := Hiword(X);
  wDestX := Loword(Y);
  wDestY := Hiword(Y);

  Msg.SourceXY := BuildXYDir(wSourceX, wSourceY, 0);
  Msg.TargetXYDir := BuildXYDir(wDestX, wDestY, dir);

  sText := EncodeBuffer(PAnsiChar(@Msg), SizeOf(Msg));
  SendSocket(sText, _MSGTYPE_ATTACKMSG);

  ActionLock := True;
  ActionLockTime := GetTickCount;
  Inc(g_nSendCount);
end;

procedure TfrmMain.SendQueryUserName(targetid, X, Y: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_QUERYUSERNAME, targetid, X, Y, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendHeroDropItem(name: string; itemserverindex: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_HERODROPITEM, itemserverindex, 0, 0, 0,
    Certification);
  SendSocket(Msg, EdCode.EncodeString(name));
end;

procedure TfrmMain.SendDropItem(const name: string; itemserverindex: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DROPITEM, itemserverindex, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(name));
end;

procedure TfrmMain.SendPickup;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_PICKUP, 0, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, 0,
    Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendTakeOnHeroItem(where: Byte; itmindex: Integer;
  itmname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_HEROTAKEONITEM, itmindex, where, 0, 0,
    Certification);
  SendSocket(Msg, EdCode.EncodeString(itmname));
end;

procedure TfrmMain.SendTakeOnItem(where: Byte; itmindex: Integer;
  itmname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_TAKEONITEM, itmindex, where, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(itmname));
end;

procedure TfrmMain.SendItemToMasterBag(where: Byte; itmindex: Integer;
  itmname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SENDITEMTOMASTERBAG, itmindex, where, 0, 0,
    Certification);
  SendSocket(Msg, EdCode.EncodeString(itmname));
end;

procedure TfrmMain.SendItemClickFunc(SourceIdx, DestIdx: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SENDITEMClickFunc, SourceIdx, DestIdx, 0, 0,
    Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendItemClickUseItemFunc(where, SourceIdx, DestIdx: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SENDITEMClickFunc, SourceIdx, DestIdx, where, 1,
    Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendItemUnite(SourceIdx, DestIdx: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SENDITEMUnite, SourceIdx, DestIdx, 0, 0,
    Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendItemSplit(SourceIdx, count: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SENDITEMSPLIT, SourceIdx, count, 0, 0,
    Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendQueryActorMenuState;
begin
  if g_SelCret = nil then
    Exit;
  frmMain.SendClientMessage(CM_QUERYMENUSTATE, g_SelCret.m_nRecogId,
    g_SelCret.m_nCurrX, g_SelCret.m_nCurrY, 0);
end;

procedure TfrmMain.SendClientDataVer;

  function GetVer(const Ver: String): String;
  begin
    if Ver <> '' then
      Result := Ver
    else
      Result := '?';
  end;

var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_CLIENTDATA_VERSION, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(GetVer(g_ItemVer) + '/' + GetVer(g_UIVer)
    + '/' + GetVer(g_SuitVer) + '/' + GetVer(g_MapVer) + '/' +
    GetVer(g_ItemTypeNamesVer) + '/' + GetVer(g_MagicMgr.Ver) + '/' +
    GetVer(g_ItemWayVer) + '/' + GetVer(g_CustomActorActionVer) + '/' + GetVer(g_SkillDataVer) + '/' +
    GetVer(g_SkillEffectDataVer)));
end;

procedure TfrmMain.SendExtendCommandExecute(const CommandText: String);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_CLIENTEXTENDBUTTON, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(CommandText));
end;

procedure TfrmMain.SendSetActiveTitle(AIndex: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SETACTIVETITLE, AIndex, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendQueryOrders(AType, APage: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_QUERYSORT, APage, 0, 0, AType, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendItemToHeroBag(where: Byte; itmindex: Integer;
  itmname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SENDITEMTOHEROBAG, itmindex, where, 0, 0,
    Certification);
  SendSocket(Msg, EdCode.EncodeString(itmname));
end;

procedure TfrmMain.SendTakeOffHeroItem(where: Byte; itmindex: Integer;
  itmname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_HEROTAKEOFFITEM, itmindex, where, 0, 0,
    Certification);
  SendSocket(Msg, EdCode.EncodeString(itmname));
end;

procedure TfrmMain.SendTakeOffItem(where: Byte; itmindex: Integer;
  itmname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_TAKEOFFITEM, itmindex, where, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(itmname));
end;

procedure TfrmMain.SendHeroEat(itmindex: Integer; itmname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_HEROEAT, itmindex, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(itmname));
end;

procedure TfrmMain.SendEat(itmindex: Integer; itmname: string);
var
  Msg: TDefaultMessage;
begin
  //OutputDebugString(PChar('发送吃药品:' + IntToStr(itmindex)));
  Msg := MakeDefaultMsg(CM_EAT, itmindex, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(itmname));
end;

// 挖动物尸体
procedure TfrmMain.SendButchAnimal(X, Y, dir, actorid: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_BUTCH, actorid, X, Y, dir, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendCollectAnimal(X, Y, dir, actorid: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_COLLECT, actorid, X, Y, dir, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendMagicKeyChange(magid: Integer; keych: PPlatfromChr);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_MAGICKEYCHANGE, magid, Byte(keych), 0, 0,
    Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendMerchantDlgSelect(merchant: Integer;
  const SelectLabel: string; const WinName, itemindex: String);
var
  Msg: TDefaultMessage;
  AParam, AParams, NewSelect: string;
  Params: TStrings;
  DlgCaption: String;
  AButtons: TMsgDlgButtons;
  i: Integer;
begin
  Params := TStringList.Create;
  try
    AParam := '';
    ParseParamList(SelectLabel, NewSelect, Params);
    if Length(NewSelect) >= 2 then
    begin
      if (NewSelect[1] = '@') and (NewSelect[2] = '@') then
      begin
        AButtons := [];
        if SameText(NewSelect, '@@buildguildnow') then
        begin
          DlgCaption := '请输入行会名称';
          AButtons := [mbOk, mbCancel, mbAbort];
        end
        else if Pos('@@INPUTSTRING', UpperCase(NewSelect)) > 0 then
        begin
          DlgCaption := '输入信息';
          if Params.count > 0 then
          begin
            DlgCaption := Params.Strings[0];
            Params.Delete(0);
          end;
          AButtons := [mbOk, mbCancel, mbAbort];
        end
        else if Pos('@@INPUTINTEGER', UpperCase(NewSelect)) > 0 then
        begin
          DlgCaption := '输入信息';
          if Params.count > 0 then
          begin
            DlgCaption := Params.Strings[0];
            Params.Delete(0);
          end;
          AButtons := [mbOk, mbCancel, mbAbort];
        end
        else if Pos('@@QUESTION', UpperCase(NewSelect)) > 0 then
        begin
          DlgCaption := Params.Strings[0];
          Params.Delete(0);
          AButtons := [mbYes, mbCancel];
        end
        else if UpperCase(NewSelect) = '@@MAILBOX' then
        begin
          FrmDlg.OpenMailBox;
          Exit;
        end;
        if DlgCaption <> '' then
        begin
          case FrmDlg.DMessageDlg(DlgCaption, AButtons) of
            mrOK:
              begin
                AParam := MakeMaskString(Trim(FrmDlg.DlgEditText));
              end;
            mrYes:
              begin
                NewSelect := '';
                if Params.count > 0 then
                begin
                  NewSelect := Params.Strings[0];
                  Params.Delete(0);
                end;
              end;
            mrCancel:
              Exit;
          end;
        end;
      end;
    end;

    if NewSelect <> '' then
    begin
      AParams := '';
      for i := 0 to Params.count - 1 do
      begin
        if i > 0 then
          AParams := AParams + ',';
        AParams := AParams + Params.Strings[i];
      end;
      if (AParam <> '') or (mbAbort in AButtons) then
      begin
        if AParams <> '' then
          AParams := AParams + ',';
        AParams := AParams + AParam;
      end;
      if (AParams <> '') or (mbAbort in AButtons) then
        NewSelect := NewSelect + '(' + AParams + ')';
      NewSelect := NewSelect + #13 + Format('%s:%s', [WinName, itemindex]);
      Msg := MakeDefaultMsg(CM_MERCHANTDLGSELECT, merchant, 0, 0, 0,
        Certification);
      SendSocket(Msg, EdCode.EncodeString(NewSelect));
    end;
  finally
    FreeAndNilEx(Params);
  end;
end;

procedure TfrmMain.SendMissionCommandSelect(const SelectLabel: string);
var
  Msg: TDefaultMessage;
  AParam, AParams, NewSelect: string;
  Params: TStrings;
  DlgCaption: String;
  AButtons: TMsgDlgButtons;
  i: Integer;
begin
  Params := TStringList.Create;
  try
    AParam := '';
    ParseParamList(SelectLabel, NewSelect, Params);
    if Length(NewSelect) >= 2 then
    begin
      if (NewSelect[1] = '@') and (NewSelect[2] = '@') then
      begin
        AButtons := [];
        if SameText(NewSelect, '@@buildguildnow') then
        begin
          DlgCaption := '请输入行会名称';
          AButtons := [mbOk, mbCancel, mbAbort];
        end
        else if Pos('@@INPUTSTRING', UpperCase(NewSelect)) > 0 then
        begin
          DlgCaption := '输入信息';
          if Params.count > 0 then
          begin
            DlgCaption := Params.Strings[0];
            Params.Delete(0);
          end;
          AButtons := [mbOk, mbCancel, mbAbort];
        end
        else if Pos('@@INPUTINTEGER', UpperCase(NewSelect)) > 0 then
        begin
          DlgCaption := '输入信息';
          if Params.count > 0 then
          begin
            DlgCaption := Params.Strings[0];
            Params.Delete(0);
          end;
          AButtons := [mbOk, mbCancel, mbAbort];
        end
        else if Pos('@@QUESTION', UpperCase(NewSelect)) > 0 then
        begin
          DlgCaption := Params.Strings[0];
          Params.Delete(0);
          AButtons := [mbYes, mbCancel];
        end
        else if UpperCase(NewSelect) = '@@MAILBOX' then
        begin
          FrmDlg.OpenMailBox;
          Exit;
        end;
        if DlgCaption <> '' then
        begin
          case FrmDlg.DMessageDlg(DlgCaption, AButtons) of
            mrOK:
              begin
                AParam := MakeMaskString(Trim(FrmDlg.DlgEditText));
              end;
            mrYes:
              begin
                NewSelect := '';
                if Params.count > 0 then
                begin
                  NewSelect := Params.Strings[0];
                  Params.Delete(0);
                end;
              end;
            mrCancel:
              Exit;
          end;
        end;
      end;
    end;

    if NewSelect <> '' then
    begin
      AParams := '';
      for i := 0 to Params.count - 1 do
      begin
        if i > 0 then
          AParams := AParams + ',';
        AParams := AParams + Params.Strings[i];
      end;
      if (AParam <> '') or (mbAbort in AButtons) then
      begin
        if AParams <> '' then
          AParams := AParams + ',';
        AParams := AParams + AParam;
      end;
      if (AParams <> '') or (mbAbort in AButtons) then
        NewSelect := NewSelect + '(' + AParams + ')';
      Msg := MakeDefaultMsg(CM_MISSIONCOMMANDSELECT, 0, 0, 0, 0, Certification);
      SendSocket(Msg, EdCode.EncodeString(NewSelect));
    end;
  finally
    FreeAndNilEx(Params);
  end;
end;

// 询问物品价格
procedure TfrmMain.SendQueryPrice(merchant, itemindex: Integer;
  itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_MERCHANTQUERYSELLPRICE, merchant, Loword(itemindex),
    Hiword(itemindex), 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(itemname));
end;

// 询问修理价格
procedure TfrmMain.SendQueryRepairCost(merchant, itemindex: Integer;
  itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_MERCHANTQUERYREPAIRCOST, merchant, Loword(itemindex),
    Hiword(itemindex), 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(itemname));
end;

// 发送要出售的物品
procedure TfrmMain.SendSellItem(merchant, itemindex: Integer; itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_USERSELLITEM, merchant, Loword(itemindex),
    Hiword(itemindex), 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(itemname));
end;

// 发送要修理的物品
procedure TfrmMain.SendRepairItem(merchant, itemindex: Integer;
  itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_USERREPAIRITEM, merchant, Loword(itemindex),
    Hiword(itemindex), 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(itemname));
end;

procedure TfrmMain.SendMarketBuy(const StallUserName: String;
  MakeIndex, count: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_MARKET_COMMAND, CM_MARKET_BUY, MakeIndex, count, 0,
    Certification);
  SendSocket(Msg, EdCode.EncodeString(StallUserName));
end;

procedure TfrmMain.SendMarketGetItems(const who: String);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_MARKET_COMMAND, CM_MARKET_GETITEMS, 0, 0, 0,
    Certification);
  SendSocket(Msg, EdCode.EncodeString(who));
  if who = '' then
    g_boStallLoaded := True;
end;

procedure TfrmMain.SendMarketExtractGold;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_MARKET_COMMAND, CM_MARKET_EXTRACT, 0, 0, 0,
    Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendStallPutOn(MakeIndex: Integer; gold, GameGold: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_STALL_COMMAND, _STALL_PutOn, MakeIndex, gold,
    GameGold, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendStallUpdate(MakeIndex: Integer;
  GoldPrice, GameGoldPrice: Integer);
begin
  SendClientMessage(CM_STALL_COMMAND, _STALL_UPDATE, MakeIndex, GoldPrice,
    GameGoldPrice);
end;

procedure TfrmMain.SendStallBuy(const StallUserName: String;
  MakeIndex, count: Integer);
begin
  SendClientMessage(CM_STALL_COMMAND, _STALL_Buy, MakeIndex, count,
    g_QueryStallVersion, EdCode.EncodeString(StallUserName));
end;

procedure TfrmMain.SendStallPutOff(MakeIndex: Integer);
begin
  SendClientMessage(CM_STALL_COMMAND, _STALL_PutOff, MakeIndex, 0, 0);
end;

procedure TfrmMain.SendStallBuyPutOn(GoldPrice, GameGoldPrice, count: Integer;
  const AName: String);
begin
  SendClientMessage(CM_STALL_COMMAND, _STALL_PutOnBuy, count, GoldPrice,
    GameGoldPrice, EdCode.EncodeString(AName));
end;

procedure TfrmMain.SendStallBuyUpdate(AIndex, count, GoldPrice,
  GameGoldPrice: Integer; const AName: String);
begin
  SendClientMessage(CM_STALL_COMMAND, _STALL_UpdateBuy, count, GoldPrice,
    GameGoldPrice, IntToStr(AIndex) + '/' + EdCode.EncodeString(AName));
end;

procedure TfrmMain.SendStallBuyPutOff(AIndex: Integer; const AName: String);
begin
  SendClientMessage(CM_STALL_COMMAND, _STALL_PutOffBuy, AIndex, 0, 0,
    EdCode.EncodeString(AName));
end;

procedure TfrmMain.SendStallSaleToBuy(MakeIndex, AIndex: Integer;
  const StallUserName: String);
begin
  SendClientMessage(CM_STALL_COMMAND, _STALL_SaleToBuy, MakeIndex, AIndex,
    g_QueryStallVersion, EdCode.EncodeString(StallUserName));
end;

procedure TfrmMain.SendStallMessage(const AStallName, AMessage: String);
begin
  SendClientMessage(CM_STALL_COMMAND, _STALL_Message, 0, 0, 0,
    EdCode.EncodeString(AStallName) + '/' + EdCode.EncodeString(AMessage));
end;

procedure TfrmMain.SendStallStart;
begin
  SendClientMessage(CM_STALL_COMMAND, _STALL_Start, 0, 0, 0);
end;

procedure TfrmMain.SendStallStop;
begin
  SendClientMessage(CM_STALL_COMMAND, _STALL_Stop, 0, 0, 0);
end;

procedure TfrmMain.SendStallGetBack;
begin
  SendClientMessage(CM_STALL_COMMAND, _STALL_GetBack, 0, 0, 0);
end;

procedure TfrmMain.SendMarketGetList;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_MARKET_COMMAND, CM_MARKET_GETLIST, 0, 0, 0,
    Certification);
  SendSocket(Msg);
  g_boStallListLoaded := True;
end;

procedure TfrmMain.SendMarketPutOff(MakeIndex: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_MARKET_COMMAND, CM_MARKET_PUTOFF, MakeIndex, 0, 0,
    Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendMarketPutOn(MakeIndex, GoldPrice, GameGoldPrice
  : Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_MARKET_COMMAND, CM_MARKET_PUTON, MakeIndex,
    GoldPrice, GameGoldPrice, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendMarketUpdate(MakeIndex: Integer;
  GoldPrice, GameGoldPrice: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_MARKET_COMMAND, CM_MARKET_UPDATE, MakeIndex,
    GoldPrice, GameGoldPrice, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendMarketSetName(const NewName: String);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_MARKET_COMMAND, CM_MARKET_SETNAME, 0, 0, 0,
    Certification);
  SendSocket(Msg, EdCode.EncodeString(NewName));
end;

procedure TfrmMain.SendStorageItem(merchant, itemindex: Integer;
  itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_USERSTORAGEITEM, merchant, itemindex,
    Ord(g_boBigStore), 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(itemname));
end;

var
  SplicingSocketStr : PPlatfromString = '';
procedure TfrmMain.SendStr(const AData: PPlatfromString);
begin
  if CSocket.Active then
  begin
    FTransDataTime := GetTickCount;
    if BoPacketSplicingTest then
    begin
      SplicingSocketStr := SplicingSocketStr + AData;
    end else
    begin
      CSocket.SendText(AData);
    end;
  end;
end;

procedure TfrmMain.SendPacketSplicingTest;
var
  AData: PPlatfromString;
begin
  if CSocket.Active then
  begin
    if SplicingSocketStr <> '' then
    begin
      AData := Copy(SplicingSocketStr,1,10);
      delete(SplicingSocketStr,1,10);
      FTransDataTime := GetTickCount;
      CSocket.SendText(AData);
      Sleep(2);
    end;
  end;
end;

procedure TfrmMain.SendHeartbeat;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_RUNGATEHEARTBEAT, 0, 0, 0, 0, Certification);
  SendSocket(Msg, '');
end;

procedure TfrmMain.SendGetDetailItem(merchant, menuindex: Integer;
  itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_USERGETDETAILITEM, merchant, menuindex, 0, 0,
    Certification);
  SendSocket(Msg, EdCode.EncodeString(itemname));
end;

procedure TfrmMain.SendGetMailData(Index: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_EMAIL, _MAIL_DATA, Index, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendDelMail(Index: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_EMAIL, _MAIL_DEL, Index, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendDelAllMail;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_EMAIL, _MAIL_DELALL, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendExtrAttMail(Index: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_EMAIL, _MAIL_EXTRACT, Index, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendNewMail(const MailTo, Subject, Context: String;
  Item: TClientItem; GoldType, GoldCount, BuyAttGoldType, BuyAttGold: Integer);
var
  Msg: TDefaultMessage;
  AMessage: PPlatfromString;
begin
  Msg := MakeDefaultMsg(CM_EMAIL, _MAIL_NEW, 0, 0, 0, Certification);
  AMessage := IntToStr(GoldType) + '/' + IntToStr(GoldCount) + '/' +
    IntToStr(BuyAttGoldType) + '/' + IntToStr(BuyAttGold) + '/' +
    EdCode.EncodeString(MailTo) + '/' + EdCode.EncodeString(Subject) + '/' +
    EdCode.EncodeString(Context) + '/';
  if Item.Name <> '' then
    AMessage := AMessage + IntToStr(Item.MakeIndex) + '/';
  SendSocket(Msg, AMessage);
end;

procedure TfrmMain.SendGetMailList;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_EMAIL, _MAIL_LIST, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendGetShuffleItem(itemid: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_GETShuffleItem, itemid, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendBuyItem(merchant, itemserverindex, itemcount: Integer;
  const itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_USERBUYITEM, merchant, itemserverindex, 0, itemcount,
    Certification);
  SendSocket(Msg, EdCode.EncodeString(itemname));
end;

procedure TfrmMain.SendTakeBackStorageItem(merchant, itemserverindex: Integer;
  itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_USERTAKEBACKSTORAGEITEM, merchant, Ord(g_boBigStore),
    itemserverindex, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(itemname));
end;

procedure TfrmMain.SendMakeDrugItem(merchant: Integer; itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_USERMAKEDRUGITEM, merchant, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(itemname));
end;

procedure TfrmMain.SendDropGold(dropgold: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DROPGOLD, dropgold, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendChangeState(STATE: Integer; OnOff: Boolean);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_CHANGESTATE, STATE, Ord(OnOff), 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendCreateGroup(withwho: string);
var
  Msg: TDefaultMessage;
begin
  if withwho <> '' then
  begin
    Msg := MakeDefaultMsg(CM_CREATEGROUP, 0, 0, 0, 0, Certification);
    SendSocket(Msg, EdCode.EncodeString(withwho));
  end;
end;

procedure TfrmMain.SendAltLButtonBagItem(Index, MakeIndex: Integer);
begin
  SendClientMessage(CM_CTRLLBUTTONITEM, 0, Index, MakeIndex, 0, '');
end;

procedure TfrmMain.SendAfterPlayDice(ATag, APoint1, APoint2, APoint3: Integer);
begin
  SendClientMessage(CM_PLAYDICE, ATag, APoint1, APoint2, APoint3, '');
end;

procedure TfrmMain.SendSideButtonClick(const AName: String);
begin
  SendClientMessage(CM_SIDEBUTTONCLICK, 0, 0, 0, 0, EdCode.EncodeString(AName));
end;

procedure TfrmMain.SendGuildExtendButtonClick;
begin
  SendClientMessage(CM_GUILDEXTENDBUTTONCLICK, 0, 0, 0, 0, '');
end;

procedure TfrmMain.SendAltLButtonUseItem(where, MakeIndex: Integer);
begin
  SendClientMessage(CM_CTRLLBUTTONITEM, 1, where, MakeIndex, 0, '');
end;

procedure TfrmMain.SendWantMiniMap;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_WANTMINIMAP, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendDealTry;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DEALTRY, 0, 0, 0, 0, Certification);
  SendSocket(Msg, '');
end;

procedure TfrmMain.SendGuildDlg;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_OPENGUILDDLG, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendCancelDeal;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DEALCANCEL, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendAddDealItem(ci: TClientItem);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DEALADDITEM, ci.MakeIndex, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(ci.Name));
end;

procedure TfrmMain.SendDelDealItem(ci: TClientItem);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DEALDELITEM, ci.MakeIndex, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(ci.Name));
end;

{ ****************************************************************************** }
// 往寄售窗口加物品 发送到M2 20080316
procedure TfrmMain.SendAddSellOffItem(ci: TClientItem);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SELLOFFADDITEM, ci.MakeIndex, 0, 0, 0,
    Certification);
  SendSocket(Msg, EdCode.EncodeString(ci.Name));
end;

// 往包裹里返回物品 发送到M2 20080316
procedure TfrmMain.SendDelSellOffItem(ci: TClientItem);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SELLOFFDELITEM, ci.MakeIndex, 0, 0, 0,
    Certification);
  SendSocket(Msg, EdCode.EncodeString(ci.Name));
end;

// 取消寄售 发送到M2 20080316
procedure TfrmMain.SendCancelSellOffItem;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SELLOFFCANCEL, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

// 发送寄售信息 发送到M2 20080316
procedure TfrmMain.SendSellOffEnd;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SELLOFFEND, g_SellOffGameGold, g_SellOffGameDiaMond,
    High(Word), 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(g_SellOffName));
end;

// 取消正在寄售的物品 发送到M2 20080316
procedure TfrmMain.SendCancelMySellOffIteming;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_CANCELSELLOFFITEMING, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

// 取消寄售物品 收购 发送到M2 20080318
procedure TfrmMain.SendSellOffBuyCancel;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SELLOFFBUYCANCEL, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(g_SellOffInfo.sDealCharName));
end;

// 寄售物品 确定购买 发送到M2 20080318
procedure TfrmMain.SendSellOffBuy;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SELLOFFBUY, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(g_SellOffInfo.sDealCharName));
end;

procedure TfrmMain.SendChangeDealGold(gold: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DEALCHGGOLD, gold, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendDealEnd;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DEALEND, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendAddGroupMember(withwho: string);
var
  Msg: TDefaultMessage;
begin
  if withwho <> '' then
  begin
    Msg := MakeDefaultMsg(CM_ADDGROUPMEMBER, 0, 0, 0, 0, Certification);
    SendSocket(Msg, EdCode.EncodeString(withwho));
  end;
end;

procedure TfrmMain.SendAddItemToJewelryBox(where: Byte; itemindex: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_ADDITEMTOJEWELRYBOX, itemindex, where, 0, 0,
    Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendTakeOnZodiacSignItem(where: Byte; itemindex: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_TAKEONZODIACSIGN, itemindex, where, 0, 0,
    Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendJewelryBoxItemToBag(where: Byte; itemindex: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_JEWELRYBOXITEMTOBAG, itemindex, where, 0, 0,
    Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendZodiacSignItemToBag(where: Byte; itemindex: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_ZODIACSIGNTOBAG, itemindex, where, 0, 0,
    Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendDelGroupMember(withwho: string);
var
  Msg: TDefaultMessage;
begin
  if withwho <> '' then
  begin
    Msg := MakeDefaultMsg(CM_DELGROUPMEMBER, 0, 0, 0, 0, Certification);
    SendSocket(Msg, EdCode.EncodeString(withwho));
  end;
end;

procedure TfrmMain.SendLeaveGroupMember;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_GROUPLeave, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendGuildHome;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_GUILDHOME, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendGuildMemberList;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_GUILDMEMBERLIST, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendGuildAddMem(who: string);
var
  Msg: TDefaultMessage;
begin
  if Trim(who) <> '' then
  begin
    Msg := MakeDefaultMsg(CM_GUILDADDMEMBER, 0, 0, 0, 0, Certification);
    SendSocket(Msg, EdCode.EncodeString(who));
  end;
end;

procedure TfrmMain.SendGuildDelMem(who: string);
var
  Msg: TDefaultMessage;
begin
  if Trim(who) <> '' then
  begin
    Msg := MakeDefaultMsg(CM_GUILDDELMEMBER, 0, 0, 0, 0, Certification);
    SendSocket(Msg, EdCode.EncodeString(who));
  end;
end;

// 商铺兑换灵符功能  20080302
procedure TfrmMain.SendBuyGameGird(GameGirdNum: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_EXCHANGEGAMEGIRD, 0, GameGirdNum, 0, 0,
    Certification);
  SendSocket(Msg);
end;

// 发送行会公告信息更新
procedure TfrmMain.SendGuildUpdateNotice(notices: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_GUILDUPDATENOTICE, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(notices));
end;

procedure TfrmMain.SendGuildUpdateGrade(rankinfo: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_GUILDUPDATERANKINFO, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(rankinfo));
end;

procedure TfrmMain.SendAdjustBonus(remain: Integer; babil: TNakedAbility);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_ADJUST_BONUS, remain, 0, 0, 0, Certification);
  SendSocket(Msg, EncodeBuffer(@babil, SizeOf(TNakedAbility)));
end;

{ --------------------------------------------------------------- }

function TfrmMain.ServerAcceptNextAction: Boolean;
begin
  Result := True;
  if ActionLock then
  begin
    if GetTickCount - ActionLockTime > 10 * 1000 then
    begin
      ActionLock := False;
    end;
    Result := False;
  end;
end;

function TfrmMain.CanNextAction(ChrAction:TChrAction = caCommon): Boolean;
var
  boStoneStateActionCheck:Boolean;
begin
  boStoneStateActionCheck := True;
  if g_MySelf.HaveStatus(STATE_POISON_STONE) then
  begin
    case ChrAction of
     caWalk: boStoneStateActionCheck := ClientConf.boParalyCanWalk;
     caRun,caHorseRun : boStoneStateActionCheck := ClientConf.boParalyCanRun;
     caHit : boStoneStateActionCheck := ClientConf.boParalyCanHit;
     caSpell : boStoneStateActionCheck := ClientConf.boParalyCanSpell;
    else
       boStoneStateActionCheck := False;
    end;
  end;
  Result := (boStoneStateActionCheck) and (g_MySelf.IsIdle)
   and (GetTickCount - g_dwDizzyDelayStart > g_dwDizzyDelayTime);
end;

// 是否可以攻击，控制攻击速度
function TfrmMain.CanNextHit: Boolean;
begin
  Result := False;
  if GetTickCount - g_GameData.LastHitTime.Data > g_GameData.HitTime.Data + 50 then
    Result := True;
end;

procedure TfrmMain.ActionFailed;
begin
  g_nTargetX := -1;
  g_nTargetY := -1;
  ActionFailLock := True;
  ActionFailLockTime := GetTickCount(); // Jacky
  g_MySelf.MoveFail;
end;

function TfrmMain.IsUnLockAction(Action, adir: Integer): Boolean;
begin
  // if g_MySelf.HaveStatus(STATE_ONLYWALK) and ((Action = CM_RUN) or (Action = CM_HORSERUN)) then
  // begin
  // Result := False;
  // Exit;
  // end;

  if ActionFailLock then
  begin // 如果操作被锁定，则在指定时间后解锁
    if GetTickCount() - ActionFailLockTime > 1000 then
      ActionFailLock := False;
  end;
  if (ActionFailLock) or (g_boMapMoving) or (g_boServerChanging) then
  begin
    Result := False;
  end
  else
    Result := True;
end;

procedure TfrmMain.InitDisplaySet;
var
  DevNumber: Cardinal;
  Dev: TDisplayDevice;
  MainDev: Integer;
  DevMode: TDevMode;
  PName: array of Char;
  ChangeResult: Cardinal;
begin
  DevNumber := 0;
  while True do
  begin
    Dev.cb := SizeOf(TDisplayDevice);
    if not EnumDisplayDevices(nil, DevNumber, Dev, 0) then
    begin
      Break;
    end
    else
    begin
      if Dev.StateFlags and DISPLAY_DEVICE_PRIMARY_DEVICE <> 0 then
      begin
        MainDev := DevNumber;
        SetLength(PName, Length(Dev.DeviceName));
        Move(Dev.DeviceName[0], PName[0], Length(Dev.DeviceName));
      end;
    end;
    DevNumber := DevNumber + 1;
  end;

  DevMode.dmSize := SizeOf(TDevMode);
  DevMode.dmDriverExtra := 0;

  if EnumDisplaySettings(@PName[0], High(Cardinal), DevMode) then
  begin
    if DevMode.dmBitsPerPel <> 32 then
    begin
      DevMode.dmBitsPerPel := 32;
      ChangeResult := ChangeDisplaySettings(DevMode, 0);
      if DISP_CHANGE_SUCCESSFUL <> ChangeResult then
      begin
        ShowMessage('由于您的显示器颜色位数被非法篡改,且尝试修正失败,游戏无法开启' +
          #13#10'请您手动修改颜色位数为32位真彩色!' + #13#10 + '错误原因:' +
          IntToStr(ChangeResult));
      end;
    end;
  end;
end;

function TfrmMain.IsGroupMember(const uname: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to g_GroupMembers.count - 1 do
    if (g_GroupMembers[i] <> nil) and (g_GroupMembers[i].UserName = uname) then
    begin
      Result := True;
      Break;
    end;
end;

{ ------------------------------------------------------------- }
var
  g_CompressBuffer: Pointer = nil;
  g_nCompressBufferLen: Integer = 0;

procedure TfrmMain.DecodeTimerTimer(Sender: TObject);
var
  Data: AnsiString;
  btType: Byte;
  boBufferMsg: Boolean; // 是否 二进制类消息
  nLen: Integer;
  sLen: AnsiString;
  pPacket: pTGamePacket;
  nProcessBytes: Integer;
  pData: PAnsiChar;
  nPackLen:Integer;
const
  busy: Boolean = False;
begin
 {$IFDEF DEBUG}
  SendPacketSplicingTest();
  {$ENDIF}
  if busy then
    Exit;
  busy := True;
  try
    FSocketSection.Enter;
    if g_ConnectionStep <> cnsPlay then
    begin
      try
        BufferStr := BufferStr + SocStr;
        SocStr := '';
      finally
        FSocketSection.Leave;
      end;

      if BufferStr <> '' then
      begin
        while Length(BufferStr) >= 2 do
        begin
          if g_boMapMovingWait then
            Break;
          if Pos('!', BufferStr) <= 0 then
            Break;
          BufferStr := AnsiHUtil32.AnsiArrestStringEx(BufferStr, '#',
            '!', Data);

          if Data = '' then
            Break;
          DecodeMessagePacket(Data);
          if Pos('!', BufferStr) <= 0 then
            Break;
        end;
      end;
    end
    else
    begin
      repeat
        if g_boMapMovingWait then
          Break;

        pPacket := UnPackGamePacket(g_SocketBuffer.Memory, g_SocketBuffer.Size,
          nProcessBytes);
        if pPacket <> nil then
        begin
          // 处理具体的消息
          pData := PAnsiChar(Cardinal(pPacket) + GAMEPACKETSIZE);
          btType := pPacket.wMsgType and $7F;
          boBufferMsg := (pPacket.wMsgType and $80) <> 0;
          Try
            if not boBufferMsg then
            begin
              nPackLen :=  pPacket.GetPacketLen();
              SetLength(Data, nPackLen);
              Move(pData^, Data[1], nPackLen);
              if btType = $FF then // 这是一个压缩的字符串数据包
              begin
                sLen := Copy(Data, 2, 8); // 长度4个字节编码后是6字节
                DecodeBuffer(sLen, PAnsiChar(@nLen), 8); // 获取实际长度
                Data := Copy(Data, 10, Length(Data) - 9);
                if g_nCompressBufferLen < nLen then
                begin
                  g_nCompressBufferLen := nLen;
                  ReallocMem(g_CompressBuffer, nLen);
                end;
                DecodeBuffer(Data, g_CompressBuffer, nLen);
                DecodeCompressMessagePacket(g_CompressBuffer, nLen);
              end
              else
              begin
                if btType = 0 then
                  DecodeMessagePacket(Data)
                else
                  DecodePacketWithType(btType, Data);
              end;
            end
            else
            begin
              DecodePacketWithTypeBuffer(btType, pData, pPacket.GetPacketLen());
            end;
          except

          End;
          if nProcessBytes > 0 then
            g_SocketBuffer.Delete(nProcessBytes);
        end;
      until pPacket = nil;
    end;
  finally
    busy := False;
  end;

  if g_boQueryPrice then
  begin
    if GetTickCount - g_dwQueryPriceTime > 500 then
    begin
      g_boQueryPrice := False;
      case FrmDlg.SpotDlgMode of
        dmSell:
          SendQueryPrice(g_nCurMerchant, g_SellDlgItem.MakeIndex,
            g_SellDlgItem.Name);
        dmRepair:
          SendQueryRepairCost(g_nCurMerchant, g_SellDlgItem.MakeIndex,
            g_SellDlgItem.Name);
      end;
    end;
  end;
end;

procedure TfrmMain.DecodePacketWithType(btMsgType: Byte;
  const datablock: PPlatfromString);
var
  sMsg: AnsiString;
  Msg: TDefaultMessage2;
  RetMsg: TStateMsg;
  body, head, body2: AnsiString;
  nBodyState: Integer;
  CharDesc: TCharDesc;
  Actor: TActor;
  nDefBlockSize: Integer;
  DefMsg: TDefaultMessage;
begin
  sMsg := datablock;
  nDefBlockSize := GetDefBlockSize(btMsgType);
  if Length(sMsg) < nDefBlockSize then
    Exit;

  head := Copy(sMsg, 1, nDefBlockSize);
  body := Copy(sMsg, nDefBlockSize + 1, Length(sMsg) - nDefBlockSize);

  case btMsgType of
    _MSGTYPE_DEF2:
      begin
        DecodeBuffer(head, PAnsiChar(@Msg), SizeOf(Msg));
        DefMsg2ToDefMsg(@Msg, @DefMsg);
        DoPacket(DefMsg, body, nil, 0);
      end;
    _MSGTYPE_MoveMsg:
      begin
        // 服务端下发无需理会

      end;
    _MSGTYPE_StateMsg:
      begin
        DecodeBuffer(head, PAnsiChar(@RetMsg), SizeOf(RetMsg));
        StateRetMsgToDef(@RetMsg, @DefMsg);
        DoPacket(DefMsg, body, nil, 0);
        Exit;
      end;
  end;

  (*
    case Msg.Ident of
    SM_WALK,SM_RUN:
    begin
    if Msg.Recog <> g_MySelf.m_nRecogId then
    PlayScene.SendMsg(Msg.ident, Msg.Recog, Msg.param{ x } , Msg.Tag{ y } ,
    Msg.series { dir+light } , 0, 0, 0, 0, '',);
    end;
    SM_SPACEMOVE_SHOW,SM_SPACEMOVE_SHOW2,SM_SPACEMOVE_SHOW3:
    begin
    body := AnsiGetValidStr2(body, body2, ['\']);
    DecodeBuffer(body2, @CharDesc, SizeOf(TCharDesc));
    DecodeBuffer(body,PAnsiChar(@nBodyState),4);

    if Msg.Recog <> g_MySelf.m_nRecogId then
    PlayScene.NewActor(Msg.Recog, Msg.param, Msg.tag, Msg.series, CharDesc.feature, CharDesc.Status, CharDesc.Properties, CharDesc.DressWepon);


    PlayScene.SendMsg(Msg.ident, Msg.Recog, Msg.Param{ x } , Msg.Tag{ y } , Msg.series { dir + light } , CharDesc.feature, CharDesc.Status, CharDesc.Properties, CharDesc.DressWepon, ''{$I UpdateActorFromCharDescLite.Inc}); // 捞抚
    Actor := PlayScene.FindActor(Msg.Recog);
    if Actor <> nil then
    begin
    Actor.m_nTag := Msg.Recog;
    end;
    //{$I UpdateCharDesc.inc}
    end;
    else
    begin
    DefMsg2ToDefMsg(@Msg,@DefMsg);
    DecodeMessagePacket(DefMsg,body);
    end;


    end; *)
end;

procedure TfrmMain.DecodePacketWithTypeBuffer(btMsgType: Byte;
  const Buffer: Pointer; nLen: Integer);
var
  sMsg: AnsiString;
  Msg: TDefaultMessage2;
  RetMsg: TStateMsg;
  body, head, body2: AnsiString;
  nBodyState: Integer;
  CharDesc: TCharDesc;
  Actor: TActor;
  nHeaderSize: Integer;
  DefMsg: TDefaultMessage;
  pBody: PAnsiChar;
  pHeader: PAnsiChar;
begin
  nHeaderSize := GetMsgTypeSize(btMsgType);
  if nLen < nHeaderSize then
    Exit;

  pHeader := Buffer;
  pBody := PAnsiChar(Cardinal(Buffer) + nHeaderSize);
  case btMsgType of
    _MSGTYPE_DEF2:
      begin
        DefMsg2ToDefMsg(pTDefaultMessage2(pHeader), @DefMsg);
        DoPacket(DefMsg, '', pBody, nLen - nHeaderSize);
      end;
    _MSGTYPE_MoveMsg:
      begin
        // 服务端下发无需理会

      end;
    _MSGTYPE_StateMsg:
      begin
        StateRetMsgToDef(pTStateMsg(pHeader), @DefMsg);
        DoPacket(DefMsg, '', pBody, nLen - nHeaderSize);
        Exit;
      end;
  else
    begin
      Move(pHeader^, DefMsg, nHeaderSize);
      DoPacket(DefMsg, '', pBody, nLen - nHeaderSize);
    end;
  end;

end;

procedure TfrmMain.DecodeMessagePacket(const datablock: PPlatfromString);
var
  Msg: TDefaultMessage;
  body, head, body2: PPlatfromString;
begin
  if Length(datablock) < DEFBLOCKSIZE then
    Exit;

  head := Copy(datablock, 1, DEFBLOCKSIZE);
  body := Copy(datablock, DEFBLOCKSIZE + 1, Length(datablock) - DEFBLOCKSIZE);
  Msg := DecodeMessage(head);

  // if (Msg.CRC <> 0) or (body <> '') then
  // begin
  // if MakeCRC32(0, PPlatfromChar(body), Length(body)) <> Msg.CRC then
  // begin
  // {$IFDEF DEBUG}
  // uLog.TLogger.AddLog(Format('CRC校验失败>>Ident:%d Recog:%d Param:%d Tag:%d Series:%d nSessionID:%d nToken:%d CRC:%u Data: %s', [Msg.Ident, Msg.Recog, Msg.Param, Msg.Tag, Msg.Series, Msg.nSessionID, Msg.nToken, Msg.CRC, body]));
  // {$ELSE}
  // if g_MySelf <> nil then
  // AppExit;
  // Application.Terminate;
  // {$ENDIF}
  // Exit;
  // end;
  // end;

  DoPacket(Msg, body, nil, 0);

end;

// procedure TfrmMain.DecodeMessagePacket(var Msg: TDefaultMessage;
// const datablock: PPlatfromString);
// var
// body, head, body2: PPlatfromString;
// //Msg: TDefaultMessage;
// batmsg: TBatterZhuiXinMessage;
// CharDesc: TCharDesc;
// wl: TMessageBodyWL;
// i, n, param: Integer;
// Actor: TActor;
// Event: TCustomEvent;
// sLoginKey: string;
// d: TAsphyreLockableTexture;
// AMessage,
// ANode1, ANode2: String;
// begin

// if Length(datablock) < DEFBLOCKSIZE then
// Exit;
//
// head := Copy(datablock, 1, DEFBLOCKSIZE);
// body := Copy(datablock, DEFBLOCKSIZE + 1, Length(datablock) - DEFBLOCKSIZE);
// Msg := DecodeMessage(head);
// if (Msg.CRC <> 0) or (body <> '') then
// begin
// if MakeCRC32(0, PPlatfromChar(body), Length(body)) <> Msg.CRC then
// begin
// {$IFDEF DEBUG}
// uLog.TLogger.AddLog(Format('CRC校验失败>>Ident:%d Recog:%d Param:%d Tag:%d Series:%d nSessionID:%d nToken:%d CRC:%u Data: %s', [Msg.Ident, Msg.Recog, Msg.Param, Msg.Tag, Msg.Series, Msg.nSessionID, Msg.nToken, Msg.CRC, body]));
// {$ELSE}
// if g_MySelf <> nil then
// AppExit;
// Application.Terminate;
// {$ENDIF}
// Exit;
// end;
// end;

var
  g_SnappyBuff: Pointer = nil;
  g_nSnappyBufferLen: Integer;

procedure TfrmMain.DecodeCompressMessagePacket(const buff: PAnsiChar;
  nLen: Integer);
var
  pCH, pCH2: pTCompressMessageHeader;
  pTemp: PAnsiChar;
  MsgStr: AnsiString;
  nOffSet: Integer;
  nPostion: Integer;
  nHeaderSize: Integer;
  nBodyLen: Integer;
  DefMsg: TDefaultMessage;
  RetMsg: TStateMsg;
  DefMsg2: TDefaultMessage2;
  sBody: AnsiString;
  pDecompressBuffer: Pointer;
  nDecompressLen: Integer;
  pBuffer: PAnsiChar;
  nMaxLen: Integer;
const
  CH_HEADER = SizeOf(TCompressMessageHeader);
begin
{$IF USE_SNAPPY = 1}
  snappy.snappy_uncompressed_length(buff, nLen, @nMaxLen);
  if g_nSnappyBufferLen < nMaxLen then
  begin
    ReallocMem(g_SnappyBuff, nMaxLen);
    g_nSnappyBufferLen := nMaxLen;
  end;
  nDecompressLen := g_nSnappyBufferLen;
  snappy.snappy_uncompress(buff, nLen, g_SnappyBuff, @nDecompressLen);
  pDecompressBuffer := g_SnappyBuff;
{$ELSE}
  Exit;
{$IFEND}
  // ZDecompress(buff,nLen,pDecompressBuffer,nDecompressLen,0);
  if nDecompressLen <= 0 then
    Exit;
  pBuffer := pDecompressBuffer;
  pTemp := pDecompressBuffer;
  nOffSet := 0;
{$POINTERMATH ON}
  while nOffSet < nDecompressLen do
  begin
    pCH := pTCompressMessageHeader(pTemp);
    if pCH.MagicNumber = CPM_MAGIC then
    begin
      nPostion := CH_HEADER + pCH.nLen + nOffSet;
      // 检测这个包完了后是否是接着一个包的开始 否则就认为这个包也是无效的
      if nPostion < nDecompressLen then
      begin
        pCH2 := pTCompressMessageHeader(@(pBuffer[nPostion]));
        if pCH2.MagicNumber <> CPM_MAGIC then
        begin
          Inc(pTemp);
          Inc(nOffSet);
          Continue;
        end;
      end;

      // 到这下面了 就说明是一个合法的包了
      nHeaderSize := GetMsgTypeSize(pCH.btMsgType);
      if pCH.nLen >= nHeaderSize then
      begin
        nBodyLen := pCH.nLen - nHeaderSize;
        if nBodyLen > 0 then
        begin
          SetLength(sBody, nBodyLen);
          Move(pTemp[CH_HEADER + nHeaderSize], sBody[1], nBodyLen);
        end;

        Try
          case pCH.btMsgType of
            _MSGTYPE_DEF:
              begin
                Move(pTemp[CH_HEADER], DefMsg, SizeOf(DefMsg)); // 给消息头
                DoPacket(DefMsg, sBody, nil, 0);
              end;
            _MSGTYPE_DEF2:
              begin
                Move(pTemp[CH_HEADER], DefMsg2, SizeOf(DefMsg2));
                DefMsg2ToDefMsg(@DefMsg2, @DefMsg);
                DoPacket(DefMsg, sBody, nil, 0);
              end;
            _MSGTYPE_StateMsg:
              begin
                Move(pTemp[CH_HEADER], RetMsg, SizeOf(RetMsg));
                StateRetMsgToDef(@RetMsg, @DefMsg);
                DoPacket(DefMsg, sBody, nil, 0);
              end;
          end;
        except
          on E: Exception do
          begin
            uLog.TLogger.AddLog('DecodeCompressMessagePacket:' + E.Message);
          end;
        End;

      end;

      Inc(pTemp, CH_HEADER + pCH.nLen); // 到下一个包的位置   、
      Inc(nOffSet, CH_HEADER + pCH.nLen);
    end
    else
    begin
      Inc(pTemp); // 移动一个字节 进行搜索包头
      Inc(nOffSet);
    end;

  end;

{$POINTERMATH OFF}
end;

procedure TfrmMain.DoPacket(Msg: TDefaultMessage; const body: PPlatfromString;
  const Buf: Pointer; nLen: Integer);
const
  TEMP_BUFFERSIZE = 4096;
var
  // body, head, body2: PPlatfromString;
  // Msg: TDefaultMessage;
  batmsg: TBatterZhuiXinMessage;
  body2, Body3: PPlatfromString;
  CharDesc: TCharDesc;
  wl: TMessageBodyWL;
  health: TMessageHealth;
  i, n, Param: Integer;
  Actor: TActor;
  Event: TCustomEvent;
  sLoginKey: string;
  d: TAsphyreLockableTexture;
  AMessage, ANode1, ANode2: String;
  nBodyState: Integer;
  sStr: AnsiString;
  TempSocket: array [0 .. TEMP_BUFFERSIZE - 1] of Byte;
  Buffer: TProtocolBuffer;
  btByte: Byte;
begin

{$IFDEF DEBUG}
  g_SocketIdent[Msg.ident] := g_SocketIdent[Msg.ident] + 1;
  g_SocketLength[Msg.ident] := g_SocketLength[Msg.ident] + Length(body);
  // OutputDebugString(PChar(Format('收到消息ID:%d',[Msg.Ident])));
{$ENDIF}
  //如果新的系统处理了的话 那就用不让旧系统处理了
  if ClientCC.ClientOperate(Msg,Body,Buf,nLen) then
  begin
    Exit;
  end;

  if g_MySelf = nil then
  begin
    case Msg.ident of
      SM_GATEPASS_FAIL:
        begin
          FrmDlg.DMessageDlg('和网关密码不匹配!!', [mbOk]);
          LoginScene.PassWdFail;
        end;
      SM_SENDLOGINKEY:
        ;
      SM_NEWID_SUCCESS:
        begin
          AddMessageDialog('帐号已创建成功,请保管好您的帐号和密码.\' +
            '如有问题请咨询游戏的官方网站.\', [mbOk]);
        end;
      SM_NEWID_FAIL:
        begin
          case Msg.Recog of
            0:
              begin
                AddMessageDialog('"' + MakeNewId + '"这个帐号已注册.\', [mbOk],
                  procedure(AResult: Integer)begin LoginScene.NewIdRetry
                  (False); end);
              end;
            -2:
              AddMessageDialog('此帐号名被禁止使用！', [mbOk]);
          else
            AddMessageDialog('帐号无法创建，请不要用空格及非法字符注册 :  ' +
              IntToStr(Msg.Recog), [mbOk]);
          end;
        end;
      SM_PASSWD_FAIL:
        begin
          case Msg.Recog of
            - 1:
              AMessage := '密码输入错误。';
            -2:
              AMessage := '密码输入错误超过3次，此帐号被暂时锁定，请稍候再登录。';
            -3:
              AMessage := '此帐号已经登录或被异常锁定，请稍候再登录！';
            -4:
              AMessage := '这个帐号访问失败。';
            -5:
              AMessage := '这个帐号被锁定。';
          else
            AMessage := '帐号不存在，请检查你的帐号。';
          end;
          AddMessageDialog(AMessage, [mbOk], procedure(AResult: Integer)
          begin LoginScene.PassWdFail; end);
        end;
      SM_NEEDUPDATE_ACCOUNT:
        ClientGetNeedUpdateAccount(body);
      SM_UPDATEID_SUCCESS:
        begin
          AddMessageDialog('帐号信息更新成功。\', [mbOk], procedure(AResult: Integer)
          begin ClientGetSelectServer; end);
        end;
      SM_UPDATEID_FAIL:
        begin
          AddMessageDialog('更新帐号失败。\', [mbOk], procedure(AResult: Integer)
          begin ClientGetSelectServer; end);
        end;
      SM_PASSOK_SELECTSERVER:
        ClientGetPasswordOK(Msg, body);
      SM_SELECTSERVER_OK:
        ClientGetPasswdSuccess(body);
      SM_QUERYCHR:
        ClientGetReceiveChrs(Msg.Param, body);
      SM_QUERYDELCHR:
        ClientGetReceiveDelChrs(body, Msg.Recog);
      SM_QUERYDELCHR_FAIL:
        AddMessageDialog('[失败] 没有找到被删除的角色', [mbOk]);
      SM_RESDELCHR_SUCCESS:
        SendQueryChr(0);
      SM_RESDELCHR_FAIL:
        AddMessageDialog('[失败] 你最多只能为一个帐号设置两个角色。', [mbOk]);
      SM_NOCANRESDELCHR:
        AddMessageDialog('[失败] 服务器上设置禁止恢复人物。', [mbOk]);
      // ============================================================
      // 获取验证码
      SM_RANDOMCODE:
        begin
          AMessage := EdCode.DecodeString(body);
          if AMessage <> '' then
          begin
            g_pwdimgstr := AMessage;
            GetCheckNum();
            if not FrmDlg.DWCheckNum.Visible then
            begin
              FrmDlg.DWCheckNum.ShowModal;
              FrmDlg.DEditCheckNum.SetFocus;
            end;
          end;
        end;
      SM_CHECKNUM_OK:
        begin
          // FrmDlg.DWCheckNum.Visible := False;
          // UiDXImageList.Items[35].Picture.Assign(nil);
        end;
      SM_QUERYCHR_FAIL:
        begin
          if Msg.series = 1 then // 验证码 20080612
            FrmDlg.DWCheckNum.Visible := False;
          g_boDoFastFadeOut := False;
          g_boDoFadeIn := False;
          g_boDoFadeOut := False;
          AddMessageDialog('服务器验证失败。', [mbOk], procedure(AResult: Integer)
          begin Close; end);
        end;
      SM_NEWCHR_SUCCESS:
        SendQueryChr(0);
      SM_NEWCHR_FAIL:
        begin
          SelectChrScene.SelChrNewClose;
          case Msg.Recog of
            0:
              AddMessageDialog('[错误] 输入的名称包含非法字符！', [mbOk]);
            2:
              AddMessageDialog('[错误] 创建的名称服务器已有！', [mbOk]);
            3:
              AddMessageDialog('[错误] 超过服务器允许创建游戏人物数量！', [mbOk]);
            4:
              AddMessageDialog('[错误] 创建的职业不被服务器允许！', [mbOk]);
            5:
              AddMessageDialog('[错误] 输入的名称太短！', [mbOk]);
          else
            AddMessageDialog('[错误] 创建游戏人物时出现未知错误！', [mbOk]);
          end;
        end;
      SM_CHGPASSWD_SUCCESS:
        AddMessageDialog('密码已修改成功。', [mbOk]);
      SM_CHGPASSWD_FAIL:
        begin
          case Msg.Recog of
            - 1:
              AddMessageDialog('输入的原始密码不正确。', [mbOk]);
            -2:
              AddMessageDialog('此帐号被服务器锁定。', [mbOk]);
          else
            AddMessageDialog('输入的新密码长度小于四位。', [mbOk]);
          end;
        end;
      SM_DELCHR_SUCCESS:
        SendQueryChr(0);
      SM_DELCHR_FAIL:
        AddMessageDialog('[错误] 删除游戏人物时出现错误', [mbOk]);
      SM_STARTPLAY:
        ClientGetStartPlay(body);
      SM_STARTFAIL:
        begin
          AddMessageDialog('此服务器满员！。', [mbOk], procedure(AResult: Integer)
          begin g_ConnectionStep := cnsLogin; FNeedTokenID := True;
            SocketOpen(g_sServerAddr, g_nServerPort); end);
        end;
      SM_VERSION_FAIL:
        AddMessageDialog('游戏程序版本不正确，请下载最新版本游戏程序。', [mbOk]);
      SM_OUTOFCONNECTION, SM_NEWMAP, SM_LOGON, SM_RECONNECT, SM_SENDNOTICE:
        ;
    else
      begin
{$IFDEF DEBUG}
        uLog.TLogger.AddLog
          (Format('角色没创建收到数据>>Ident:%d Recog:%d Param:%d Tag:%d Series:%d nSessionID:%d nToken:%d',
          [Msg.ident, Msg.Recog, Msg.Param, Msg.tag, Msg.series, Msg.nSessionID,
          Msg.nToken]));
{$ENDIF}
        Exit;
      end;
    end;
  end;

  if g_boMapMoving then
  begin
    if Msg.ident = SM_CHANGEMAP then
    begin
      WaitingMsg := Msg;
      WaitingStr := EdCode.DecodeString(body);
      g_boMapMovingWait := True;
      WaitMsgTimer.Enabled := True;
    end;
    Exit;
  end;
  // 判断消息  清清 2007.10.20
  case Msg.ident of
    SM_OPERATESTATE:
      ClientReadOperateState(Msg.Recog);
    SM_SKILLSTATE:
      ClientReadSkillState(Msg.Recog, Msg.Param, Msg.tag);
    SM_OPENEXPCRYSTAL:
      ;
    SM_SENDCRYSTALNGEXP:
      begin // 接收天地结晶内功经验
        AMessage := EdCode.DecodeString(body);
        if AMessage <> '' then
        begin
          AMessage := GetValidStr3(AMessage, ANode1, ['/']);
          AMessage := GetValidStr3(AMessage, ANode2, ['/']);
          if ANode1 <> '' then
            g_dwCrystalNGExp := StrToInt64(ANode1); // 天地结晶当前内功经验 20090201
          if ANode2 <> '' then
            g_dwCrystalMaxExp := StrToInt64(ANode2); // 天地结晶升级经验 20090201
          if AMessage <> '' then
            g_dwCrystalNGMaxExp := StrToInt64(AMessage); // 天地结晶内功升级经验 20090201
        end;
      end;
    SM_SENDCRYSTALEXP:
      begin // 接收天地结晶经验
        AMessage := EdCode.DecodeString(body);
        if AMessage <> '' then
        begin
          AMessage := GetValidStr3(AMessage, ANode1, ['/']);
          AMessage := GetValidStr3(AMessage, ANode2, ['/']);
          if ANode1 <> '' then
            g_dwCrystalExp := StrToInt64(ANode1); // 天地结晶当前经验 20090201
          if ANode2 <> '' then
            g_dwCrystalMaxExp := StrToInt64(ANode2); // 天地结晶升级经验 20090201
          if AMessage <> '' then
            g_dwCrystalNGMaxExp := StrToInt64(AMessage); // 天地结晶内功升级经验 20090201
        end;
      end;
    SM_BATTERUSEFINALLY:
      begin
        g_boUseBatter := False;
        // DScreen.AddSysMsg('连击结束！！！！！！');
      end;
    SM_BATTERSTART:
      begin
        g_boUseBatter := True;
        g_boCanUseBatter := False;
      end;
    SM_STORMSRATE:
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          Actor.SetNextFixedEffect(17, 0);
        end;
      end;
    SM_STORMSRATECHANGED:
      begin
        if body <> '' then
          DecodeBuffer(body, @g_BatterStormsRate, SizeOf(THumStormsRate));
      end;
    SM_OPENPULSENEEDLEV:
      begin
        if body <> '' then
          DecodeBuffer(body, @g_OpenPulseNeedLev, 20);
      end;
    // SM_HEROSTORMSRATECHANGED: begin
    // if body <> '' then
    // DecodeBuffer (body, @g_HeroStormsRate, sizeof(THumStormsRate));
    // end;    //暴击几率表已经改为全局的 所以说只要一份就可以了
    SM_CANUSEBATTER:
      begin
        g_boCanUseBatter := True;
      end;
    SM_PULSECHANGED:
      begin
        if body <> '' then
          DecodeBuffer(body, @g_MyPulse, SizeOf(THumPulses));
      end;
    SM_HEROPULSECHANGED:
      begin
        if body <> '' then
          DecodeBuffer(body, @g_MyHeroPulse, SizeOf(THumPulses));
      end;
    SM_BATTERORDER:
      begin
        g_BatterOrder[0] := Msg.Param;
        g_BatterOrder[1] := Msg.tag;
        g_BatterOrder[2] := Msg.series;
      end;
    SM_HEROBATTERORDER:
      begin
        g_HeroBatterOrder[0] := Msg.Param;
        g_HeroBatterOrder[1] := Msg.tag;
        g_HeroBatterOrder[2] := Msg.series;
      end;
    SM_OPENPULS:
      begin
        g_boisOpenPuls := Boolean(Msg.Param);
      end;
    // SM_OPENPULSE_OK: begin
    // ShowMyShow(g_MySelf, 13);
    // end;
    // SM_RUSHPULSE_OK: begin
    // ShowMyShow(g_MySelf, 14);
    // end;
    SM_SENDCRYSTALLEVEL:
      begin // 接收天地结晶等级
        // ****原版代码编译不成功 2009-10-27 邱高奇 关于天地结晶 已经被注释****//
        // g_btCrystalLevel := msg.Recog;
        // if g_btCrystalLevel <= 5 then begin
        // with FrmDlg do begin
        // d := g_WMainImages.Images[464+g_btCrystalLevel-1];
        // if d <> nil then begin
        // DWExpCrystal.SetImgIndex(g_WMainImages, 464+g_btCrystalLevel-1);
        // case g_btCrystalLevel-1 of
        // 0: begin
        // DCrystalExp.SetImgIndex(g_WMainImages, 484);
        // DCrystalNGExp.SetImgIndex(g_WMainImages, 485);
        // end;
        // 1: begin
        // DCrystalExp.SetImgIndex(g_WMainImages, 486);
        // DCrystalNGExp.SetImgIndex(g_WMainImages, 487);
        // DExpCrystalTop.SetImgIndex(g_WMainImages, 468);
        // end;
        // 2: begin
        // DCrystalExp.SetImgIndex(g_WMainImages, 488);
        // DCrystalNGExp.SetImgIndex(g_WMainImages, 489);
        // DExpCrystalTop.SetImgIndex(g_WMainImages, 470);
        // end;
        // 3: begin
        // DCrystalExp.SetImgIndex(g_WMainImages, 490);
        // DCrystalNGExp.SetImgIndex(g_WMainImages, 491);
        // DExpCrystalTop.SetImgIndex(g_WMainImages, 472);
        // end;
        // 4: begin
        // DCrystalExp.SetImgIndex(g_WMainImages, 490);
        // DCrystalNGExp.SetImgIndex(g_WMainImages, 491);
        // DExpCrystalTop.SetImgIndex(g_WMainImages, 474);
        // d := g_WMainImages.Images[464+g_btCrystalLevel-2];
        // if d <> nil then
        // DWExpCrystal.SetImgIndex(g_WMainImages, 464+g_btCrystalLevel-2);
        // end;
        // end;
        // end;
        // end;
        // end;
      end;
    // 天地结晶
    // ============================================================
    // 感叹号 20090126
    SM_SHOWSIGHICON:
      ShowSighIcon(body);
    SM_UPDATETIME:
      ; // 统一与M2的时间 20090129
    // ============================================================
    // 内功
    SM_MAGIC69SKILLEXP:
      begin // 人物的内功
        g_btInternalForceLevel := Msg.series; // 内功等级
        g_dwNGDamage := Hiword(Msg.Param); // 内功伤害增加
        g_dwUnNGDamage := Loword(Msg.Param); // 内功伤害减免
        AMessage := EdCode.DecodeString(body);
        if AMessage <> '' then
        begin // 内功当前经验/内功升级经验
          AMessage := GetValidStr3(AMessage, ANode1, ['/']);
          ANode2 := GetValidStr3(AMessage, AMessage, ['/']);
          if ANode1 <> '' then
            g_dwExp69 := StrToInt64(ANode1);
          if AMessage <> '' then
            g_dwMaxExp69 := StrToInt64(AMessage);
          if ANode2 <> '' then
            g_dwAddNHPointer := StrToInt64(ANode2);; // 内功恢复速度
        end;
        d := g_77Images.Images[263];
        if d <> nil then
          FrmDlg.DStateWin.SetImgIndex(g_77Images, 263); // 人物状态  4格图
        g_boIsInternalForce := True;
      end;
    SM_HEROMAGIC69SKILLEXP:
      begin // 英雄的内功
        g_btHeroInternalForceLevel := Msg.series; // 内功等级
        g_dwHeroNGDamage := Hiword(Msg.Param); // 内功伤害增加
        g_dwHeroUnNGDamage := Loword(Msg.Param); // 内功伤害减免
        AMessage := EdCode.DecodeString(body);
        if AMessage <> '' then
        begin // 内功当前经验/内功升级经验
          AMessage := GetValidStr3(AMessage, ANode1, ['/']);
          ANode2 := GetValidStr3(AMessage, AMessage, ['/']);
          if ANode1 <> '' then
            g_dwHeroExp69 := StrToInt64(ANode1);
          if AMessage <> '' then
            g_dwHeroMaxExp69 := StrToInt64(AMessage);
          if ANode2 <> '' then
            g_dwHeroAddNHPointer := StrToInt64(ANode2);; // 内功恢复速度
        end;
      end;
    SM_MAGIC69SKILLNH:
      PlayScene.SendMsg(SM_MAGIC69SKILLNH, Msg.Recog, Msg.Param, Msg.tag,
        0 { darkness } , 0, 0, 0, 0, '');
    SM_WINNHEXP:
      DScreen.AddSysMsg(IntToStr(LongWord(MakeLong(Msg.Param, Msg.tag))) +
        ' 点内功经验增加');
    SM_HEROWINNHEXP:
      DScreen.AddSysMsg('(英雄)' + IntToStr(LongWord(MakeLong(Msg.Param, Msg.tag))
        ) + ' 点内功经验增加');
    // 可探索
    SM_CANEXPLORATION:
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          Actor.m_sUserName := '(可探索)\' + Actor.m_sUserName;
        end;
      end;
    // ============================================================
    // 挑战
    SM_CHALLENGE_FAIL:
      begin
        g_dwQueryMsgTick := GetTickCount;
        AddMessageDialog('挑战被取消，你必须和挑战的对象面对面', [mbOk], nil);
      end;
    SM_CHALLENGEMENU:
      begin // 打开挑战窗口
        g_dwQueryMsgTick := GetTickCount;
        g_sChallengeWho := EdCode.DecodeString(body);
        FrmDlg.OpenChallengeDlg;
      end;
    SM_CLOSECHALLENGE:
      FrmDlg.DWChallenge.Visible := False;
    SM_CHALLENGECANCEL:
      begin // 取消挑战
        MoveChallengeItemToBag;
        if g_ChallengeDlgItem.Name <> '' then
        begin
          AddItemBag(g_ChallengeDlgItem);
          g_ChallengeDlgItem.Name := '';
        end;
        if g_nDealGold > 0 then
        begin
          g_nGold := g_nGold + g_nChallengeGold;
          g_nChallengeGold := 0;
        end;
        FrmDlg.CloseChallengeDlg;
      end;
    SM_CHALLENGEADDITEM_OK:
      begin
        g_dwChallengeActionTick := GetTickCount;
        if g_ChallengeDlgItem.Name <> '' then
        begin
          AddChallengeItem(g_ChallengeDlgItem);
          g_ChallengeDlgItem.Name := '';
        end;
      end;
    SM_CHALLENGEADDITEM_FAIL:
      begin
        g_dwChallengeActionTick := GetTickCount;
        if g_ChallengeDlgItem.Name <> '' then
        begin
          AddItemBag(g_ChallengeDlgItem);
          g_ChallengeDlgItem.Name := '';
        end;
      end;
    SM_CHALLENGEDELITEM_OK:
      begin
        g_dwChallengeActionTick := GetTickCount;
        if g_ChallengeDlgItem.Name <> '' then
        begin
          g_ChallengeDlgItem.Name := '';
        end;
      end;
    SM_ZHUIXIN_OK:
      begin // 追心刺使用成功  20091210 邱高奇
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          Actor.Movestep(Msg.nSessionID, Msg.Param, Msg.tag, Msg.series);
        end;
      end;
    SM_CHALLENGEDELITEM_FAIL:
      begin
        g_dwChallengeActionTick := GetTickCount;
        if g_ChallengeDlgItem.Name <> '' then
        begin
          DelItemBag(g_ChallengeDlgItem.Name, g_ChallengeDlgItem.MakeIndex);
          AddChallengeItem(g_ChallengeDlgItem);
          g_ChallengeDlgItem.Name := '';
        end;
      end;
    SM_CHALLENGEREMOTEADDITEM:
      ClientGetChallengeRemoteAddItem(body);
    SM_CHALLENGEREMOTEDELITEM:
      ClientGetChallengeRemoteDelItem(body);
    SM_CHALLENCHGGOLD_OK:
      begin
        g_nChallengeGold := Msg.Recog;
        g_nGold := Msg.Param;
        g_dwChallengeActionTick := GetTickCount;
      end;
    SM_CHALLENCHGGOLD_FAIL:
      begin
        g_nChallengeGold := Msg.Recog;
        g_nGold := Msg.Param;
        g_dwChallengeActionTick := GetTickCount;
      end;
    SM_CHALLENREMOTECHGGOLD:
      begin
        g_nChallengeRemoteGold := Msg.Recog;
        g_SoundManager.DXPlaySound(s_money);
      end;
    // 金刚石
    SM_CHALLENCHGDIAMOND_OK:
      begin
        g_nChallengeDiamond := Msg.Recog;
        g_nGameDiaMond := Msg.Param;
        g_dwChallengeActionTick := GetTickCount;
      end;
    SM_CHALLENCHGDIAMOND_FAIL:
      begin
        g_nChallengeDiamond := Msg.Recog;
        g_nGameDiaMond := Msg.Param;
        g_dwChallengeActionTick := GetTickCount;
      end;
    SM_CHALLENREMOTECHGDIAMOND:
      begin
        g_nChallengeRemoteDiamond := Msg.Recog;
        g_SoundManager.DXPlaySound(s_money);
      end;
    // 自动寻路
    SM_AUTOGOTOXY:
      AutoGoto(Msg.Param, Msg.tag);
    // ============================================================
    // E系统
    SM_OPENURL:
      begin
        if body <> '' then
          FrmDXDialogs.Navigate(EdCode.DecodeString(body), Msg.Recog,
            Msg.Param);
      end;
    SM_REQUESTURL:
      begin
        if body <> '' then
          FrmDXDialogs.RequestURL(EdCode.DecodeString(body));
      end;
    SM_ISDEHERO:
      ;
    SM_SENDUSERPLAYDRINK:
      ClientGetSendUserPlayDrink(Msg.Recog); // 请酒
    SM_USERPLAYDRINK_OK:
      begin
        FrmDlg.LastestClickTime := GetTickCount;
        FrmDlg.CloseMDlg(False);
        // 关闭NPC界面
        FrmDlg.DItemBag.Visible := False;
        // FrmDlg.DPlayDrink.Visible := True; //斗酒界面出现
      end;
    SM_USERPLAYDRINK_FAIL:
      begin
        FrmDlg.LastestClickTime := GetTickCount;
        AddItemBag(g_SellDlgItemSellWait);
        g_SellDlgItemSellWait.Name := '';
        AddMessageDialog('你给我的酒在哪呢？', [mbOk], nil);
      end;
    SM_PLAYDRINKSAY:
      ClientGetPlayDrinkSay(Msg.Recog, Msg.Param, EdCode.DecodeString(body));
    SM_OPENPLAYDRINK:
      begin
        FrmDlg.CloseMDlg(False);
        // 关闭NPC界面
        g_btShowPlayDrinkFlash := 0; // 不显示动画
        if Msg.tag = 1 then
        begin
          FrmDlg.DPlayDrink.Visible := True; // 打开斗酒界面
          FrmDlg.DDrink1.Visible := True;
          FrmDlg.DDrink2.Visible := True;
          FrmDlg.DDrink3.Visible := True;
          FrmDlg.DDrink4.Visible := True;
          FrmDlg.DDrink5.Visible := True;
          FrmDlg.DDrink6.Visible := True;
          FrmDlg.DPlayDrinkFist.Visible := True;
          FrmDlg.DPlayDrinkScissors.Visible := True;
          FrmDlg.DPlayDrinkCloth.Visible := True;
          FrmDlg.DPlayDrinkWhoWin.Visible := False;
          FrmDlg.DPlayDrinkNpcNum.Visible := False;
          FrmDlg.DPlayDrinkPlayNum.Visible := False;
          g_boStopPlayDrinkGame := False;
          g_boPlayDrink := False;
          g_boPermitSelDrink := False;
          g_btDrinkValue[0] := 0;
          g_btDrinkValue[1] := 0;
          g_btTempDrinkValue[0] := 0;
          g_btTempDrinkValue[1] := 0;
          g_btWhoWin := 3; // 20080614
          FrmDlg.DPlayFist.Visible := False;
          g_btPlayDrinkGameNum := 4;
          // ---以下跟NPC随机选酒有关
          g_NpcRandomDrinkList.Clear;
          for i := 0 to 5 do
            g_NpcRandomDrinkList.Add(Pointer(i)); // 得到顺序排列的酒
          // ---
        end;
        if Msg.tag = 2 then
        begin
          FrmDlg.DWPleaseDrink.Visible := True; // 打开请酒界面
          FrmDlg.DWPleaseDrink.Left := 0;
          FrmDlg.DWPleaseDrink.Top := 0;
          FrmDlg.DItemBag.Left := 425;
          FrmDlg.DItemBag.Top := 20;
          FrmDlg.DItemBag.Visible := True;
        end;

        g_btNpcIcon := Msg.series;
        g_nShowPlayDrinkFlashImg := 0;
        g_sNpcName := '';
        if body <> '' then
          g_sNpcName := body; // TODO
      end;
    SM_PlayDrinkToDrink:
      begin // 引擎发来猜拳码 谁输谁赢
        g_btPlayNum := Msg.Recog;
        // 玩家的码
        g_btNpcNum := Msg.tag;
        // NPC的码
        g_btWhoWin := Msg.series;
        // 0-赢  1-输  2-平
        if g_btWhoWin = 2 then
          g_boPermitSelDrink := False;
        if g_btWhoWin = 0 then
          g_boHumWinDrink := False; // 20080614 玩家赢，是否喝了酒
        g_nImgLeft := 0;
        g_nPlayDrinkDelay := 0;
        g_boPlayDrink := True;
        FrmDlg.ShowPlayDrinkImg(True);
      end;
    SM_DrinkUpdateValue:
      begin
        if g_btWhoWin = 0 then
          g_boHumWinDrink := True; // 20080614 玩家赢，是否喝了酒
        if Msg.Param = 1 then
        begin // 参数0-可以继续喝 1-斗酒结束
          g_boStopPlayDrinkGame := True;
        end;
        g_btTempDrinkValue[0] := Msg.tag;
        g_btTempDrinkValue[1] := Msg.series;
        if Msg.Recog = 0 then // 玩家喝酒
          g_btShowPlayDrinkFlash := 2
        else
          g_btShowPlayDrinkFlash := 1;
        g_nShowPlayDrinkFlashImg := 0;
        g_boPermitSelDrink := False;
      end;
    SM_CLOSEDRINK:
      begin
        FrmDlg.DPlayDrink.Visible := False;
        FrmDlg.DWPleaseDrink.Visible := False;
      end;
    SM_USERPLAYDRINKITEM_OK:
      begin
        FillChar(g_PDrinkItem[0], ClientItemSize * 2, #0);
        g_btShowPlayDrinkFlash := 1;
      end;
    SM_USERPLAYDRINKITEM_FAIL:
      begin
        AddItemBag(g_PDrinkItem[0]);
        AddItemBag(g_PDrinkItem[1]);
      end;
    // 酒馆2卷
    SM_OPENMAKEWINE:
      begin
        if (Msg.Param in [0, 1]) and (body <> '') then
        begin
          g_MakeTypeWine := Msg.Param;
          g_sNpcName := body;
          if g_MakeTypeWine = 0 then
          begin // 普通酒
            with FrmDlg do
            begin
              DMakeWineHelp.Hint := '如何酿酒';
              DMaterialMemo.Hint := '材料说明';
            end;
          end
          else
          begin // 药酒
            with FrmDlg do
            begin
              DMakeWineHelp.Hint := '如何配置';
              DMaterialMemo.Hint := '药效说明';
            end;
          end;
          with FrmDlg do
          begin
            DMakeWineHelp.ShowHint := False;
            DMaterialMemo.ShowHint := False;
            ShowMakeWine(True);
            DWMakeWineDesk.Left := 380;
            DWMakeWineDesk.Top := 50;
            DWMakeWineDesk.Visible := True;
            CloseMDlg(False);
            // 关闭NPC界面
            DItemBag.Left := 20;
            DItemBag.Top := 34;
            DItemBag.Visible := True;
          end;
        end;
      end;
    SM_MAKEWINE_OK:
      begin // 酿酒成功
        if (Msg.Param in [0, 1]) then
        begin
          if Msg.Param = 1 then // 药酒
            FillChar(g_DrugWineItem, ClientItemSize * 3, #0)
          else // 普通酒
            FillChar(g_WineItem, ClientItemSize * 7, #0);
          FrmDlg.DWMakeWineDesk.Visible := False;
          FrmDlg.DItemBag.Visible := False;
        end;
      end;
    SM_MAKEWINE_FAIL:
      begin // 酿酒失败
        if (Msg.Param in [0, 1]) then
        begin
          if Msg.Param = 1 then
          begin // 药酒
            for i := Low(g_DrugWineItem) to High(g_DrugWineItem) do
            begin
              if g_DrugWineItem[i].Name <> '' then
              begin // 药酒
                AddItemBag(g_DrugWineItem[i]);
                g_DrugWineItem[i].Name := '';
              end;
            end;
          end
          else
          begin // 普通酒
            for i := Low(g_WineItem) to High(g_WineItem) do
            begin
              if g_WineItem[i].Name <> '' then
              begin
                AddItemBag(g_WineItem[i]);
                g_WineItem[i].Name := '';
              end;
            end;
          end;
          FrmDlg.DWMakeWineDesk.Visible := False;
          FrmDlg.DItemBag.Visible := False;
        end;
      end;
    SM_MAGIC68SKILLEXP:
      begin
        AMessage := EdCode.DecodeString(body);
        if AMessage <> '' then
        begin
          AMessage := GetValidStr3(AMessage, ANode1, ['/']);
          if ANode1 <> '' then
            g_dwExp68 := StrToInt64(ANode1);
          if AMessage <> '' then
            g_dwMaxExp68 := StrToInt64(AMessage);
        end;
      end;
    SM_HEROMAGIC68SKILLEXP:
      begin // 英雄酒气护体接收经验
        AMessage := EdCode.DecodeString(body);
        if AMessage <> '' then
        begin
          AMessage := GetValidStr3(AMessage, ANode1, ['/']);
          if ANode1 <> '' then
            g_dwHeroExp68 := StrToInt64(ANode1);
          if AMessage <> '' then
            g_dwHeroMaxExp68 := StrToInt64(AMessage);
        end;
      end;
    SM_PLAYMAKEWINEABILITY:
      begin // 人物酒2相关属性 20080804
        if Msg.Recog >= 0 then
          g_MySelf.m_Abil.Alcohol := Msg.Recog;
        g_MySelf.m_Abil.MaxAlcohol := Msg.Param;
        g_MySelf.m_Abil.WineDrinkValue := Msg.tag;
        g_MySelf.m_Abil.MedicineValue := Msg.series;
        AMessage := EdCode.DecodeString(body);
        if AMessage <> '' then
        begin
          if StrToInt(AMessage) >= 0 then
            g_MySelf.m_Abil.MaxMedicineValue := StrToInt(AMessage);
        end;
      end;
    SM_HEROMAKEWINEABILITY:
      ; // 英雄酒2相关属性
    // 粹练
    SM_QUERYREFINEITEM:
      begin // NPC打开粹练窗口 20080506
        if not FrmDlg.DItemsUp.Visible then
          FrmDlg.DItemsUp.Visible := True;
      end;
    SM_UPDATERYREFINEITEM:
      ClientGetUpDateUpItem(body); // 更新淬炼物品
    SM_REPAIRFINEITEM_OK:
      begin // 修补火云石成功  20080507
        g_boItemMoving := False;
        g_MovingItem.Item.Name := '';
        g_WaitingUseItem.Item.Name := '';
      end;
    SM_REPAIRFINEITEM_FAIL:
      begin // 修补火云石失败  20080507
        AddItemBag(g_WaitingUseItem.Item);
        g_WaitingUseItem.Item.Name := '';
      end;
    { ****************************************************************************** }

    SM_SELLOFFEND_FAIL:
      begin
        MoveSellOffItemToBag;
        if g_SellOffDlgItem.Name <> '' then
        begin
          AddItemBag(g_SellOffDlgItem);
          g_SellOffDlgItem.Name := '';
        end;
        FillChar(g_SellOffItems[0], SizeOf(g_SellOffItems), #0);
        g_SellOffName := '';
        g_SellOffGameGold := 0;
        g_SellOffGameDiaMond := 0;
      end;
    SM_QUERYYBSELL:
      ClientGetSellOffSellItem(body); // 查询元宝寄售正在出售的物品
    SM_QUERYYBDEAL:
      ClientGetSellOffMyItem(body);
    SM_SENDDEALOFFFORM:
      ClientGetSendUserSellOff(Msg.Recog);
    SM_SELLOFFADDITEM_OK:
      begin // 往出元宝寄售售物品窗口里加物品 成功 20080316
        if g_SellOffDlgItem.Name <> '' then
        begin
          AddSellOffItem(g_SellOffDlgItem);
          g_SellOffDlgItem.Name := '';
        end;
      end;
    SM_SellOffADDITEM_FAIL:
      begin // 往元宝寄售出售物品窗口里加物品 失败  20080316
        if g_SellOffDlgItem.Name <> '' then
        begin
          AddItemBag(g_SellOffDlgItem);
          g_SellOffDlgItem.Name := '';
        end;
      end;
    SM_SELLOFFDELITEM_OK:
      begin // 寄售物品返回包裹成功
        // g_dwDealActionTick:=GetTickCount;
        if g_SellOffDlgItem.Name <> '' then
        begin
          g_SellOffDlgItem.Name := '';
        end;
      end;
    SM_SELLOFFDELITEM_FAIL:
      begin // 寄售物品返回包裹失败
        // g_dwDealActionTick := GetTickCount;
        if g_SellOffDlgItem.Name <> '' then
        begin
          DelItemBag(g_SellOffDlgItem.Name, g_SellOffDlgItem.MakeIndex);
          AddSellOffItem(g_SellOffDlgItem);
          g_SellOffDlgItem.Name := '';
        end;
      end;
    SM_SellOffCANCEL:
      begin // 取消寄售窗口
        MoveSellOffItemToBag;
        if g_SellOffDlgItem.Name <> '' then
        begin
          AddItemBag(g_SellOffDlgItem);
          g_SellOffDlgItem.Name := '';
        end;
      end;
    SM_CHANGEATTATCKMODE:
      begin // 改变攻击模式
        g_sAttackMode := '';
        case Msg.Param of
          HAM_ALL:
            g_sAttackMode := '全体攻击';
          HAM_PEACE:
            g_sAttackMode := '和平攻击';
          HAM_DEAR:
            g_sAttackMode := '夫妻攻击';
          HAM_MASTER:
            g_sAttackMode := '师徒攻击';
          HAM_GROUP:
            g_sAttackMode := '编组攻击';
          HAM_GUILD:
            g_sAttackMode := '行会攻击';
          HAM_PKATTACK:
            g_sAttackMode := '红名攻击';
          HAM_NATION:
            g_sAttackMode := '国家攻击';
          HAM_CAMP:
            g_sAttackMode := '阵营攻击';
        end;
        if g_sAttackMode <> '' then
        begin
          AddChatBoardString('[攻击模式改变: ' + g_sAttackMode + ']',
            GetRGB(219), clWhite);
          g_sAttackMode := '[' + g_sAttackMode + ']';
        end;
        FrmDlg.DTAttackMode.Propertites.Caption.Text := g_sAttackMode;
      end;
    SM_OPENBOOKS:
      ;
    SM_OPENShuffle:
      ClientGetShuffle(body);
    SM_OPENBOXS:
      ClientGetMyBoxsItem(Msg.series, body);
    SM_OPENBOXS_FAIL:
      begin // 返回打开宝箱失败
        FrmDlg.OpenDragonBoxFail;
      end;
    SM_OPENDRAGONBOXS:
      begin // 卧龙开宝箱
        FrmDlg.OpenDragonBox;
      end;
    SM_MOVEBOXS:
      begin
        case Msg.series of
          0:
            begin
              g_BoxsMakeIndex := Msg.Recog;
              g_BoxsGold := Msg.Param;
              g_BoxsGameGold := Msg.tag;
            end;
          1:
            begin
              AddChatBoardString('您的金币或元宝数不足,不能再转动宝箱', clWhite, clRed);
              FrmDlg.DBoxs.Visible := False;
            end;
          2:
            begin
              AddChatBoardString('宝箱已无法再使用', clWhite, clRed);
              FrmDlg.DBoxs.Visible := False;
            end;
        end;
      end;
    SM_SENGSHOPITEMS:
      begin // 打开商铺的界面
        g_ShopReturnPage := Msg.Param;
        ClientGetMyShop(body);
      end;
    SM_BUYSHOPITEM_SUCCESS, SM_BUYSHOPITEMGIVE_SUCCESS, SM_BUYSHOPITEMGIVE_FAIL,
      SM_EXCHANGEGAMEGIRD_SUCCESS, SM_EXCHANGEGAMEGIRD_FAIL,
      SM_BUYSHOPITEM_FAIL:
      begin
        if body <> '' then
          AddMessageDialog(EdCode.DecodeString(body), [mbOk]);
      end;
    SM_SENGSHOPSPECIALLYITEMS:
      begin
        ClientGetMyShopSpecially(body); // 奇珍类型
      end;
    // 20080102
    SM_REPAIRDRAGON_OK:
      begin // 祝福罐.魔令包功能
        g_WaitingUseItem.Item.Name := '';
      end;
    SM_REPAIRDRAGON_FAIL:
      begin // 祝福罐.魔令包功能
        AddItemBag(g_WaitingUseItem.Item);
        g_WaitingUseItem.Item.Name := '';
      end;

    SM_MYSHOW:
      begin // msg.Param 为 类型
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          Actor.SetNextFixedEffect(Msg.Param, Msg.tag, Msg.series);
        end;
      end;
    SM_RECALLHERO:
      ;
    SM_CREATEHERO:
      ;
    SM_REPAIRFIRDRAGON_OK:
      ;
    SM_REPAIRFIRDRAGON_FAIL:
      ;
    SM_QUERYHEROBAGCOUNT:
      ;
    SM_GOTETHERUSESPELL:
      begin // 从M2反回来的英雄合击  清清 2007.11.1
        Actor := PlayScene.FindActor(Msg.Recog);
        Actor.SetNextFixedEffect(4, 0);
      end;
    { SM_DRAGONPOINT: begin //龙影怒气值   20080619
      nMaxDragonPoint := msg.Param;
      m_nDragonPoint  :=msg.Recog;
      FrmDlg.DCIDSpleen.Visible:=True;
      end; }
    { SM_CLOSEDRAGONPOINT: begin
      FrmDlg.DCIDSpleen.Visible := False;
      end; }
    SM_FIRDRAGONPOINT:
      begin // 英雄怒气值
        nMaxFirDragonPoint := Msg.Param;
        m_nFirDragonPoint := Msg.Recog;
      end;
    SM_HEROBAGITEMS:
      begin // 接收英雄包裹物品
      end;
    SM_HEROSENDMYMAGIC:
      begin // 20071025  清清$002
      end;
    SM_SENDHEROUSEITEMS:
      begin // 接收英雄身上装备   清清$002
      end;
    SM_HEROABILITY: // 接收 英雄属性1   清清$012
      begin
      end;
    SM_HEROSUBABILITY:
      begin // 接收 英雄属性2   清清$013
        g_nHeroHitPoint := Lobyte(Msg.Param);
        g_nHeroSpeedPoint := Hibyte(Msg.Param);
        g_nHeroAntiPoison := Lobyte(Msg.tag);
        g_nHeroPoisonRecover := Hibyte(Msg.tag);
        g_nHeroHealthRecover := Lobyte(Msg.series);
        g_nHeroSpellRecover := Hibyte(Msg.series);
        g_nHeroAntiMagic := Lobyte(LongWord(Msg.Recog));
      end;
    SM_SENDITEMTOHEROBAG_OK:
      ;
    SM_SENDITEMTOHEROBAG_FAIL:
      ;
    SM_SENDITEMTOMASTERBAG_OK:
      begin // 返回从英雄包裹到主人包裹成功 清清 2007.10.24
        // if g_WaitingUseItem.Index in [0..12] then
        AddItemBag(g_WaitingUseItem.Item);
        g_WaitingUseItem.Item.Name := '';
      end;
    SM_SENDITEMTOMASTERBAG_FAIL:
      ;
    SM_HEROTAKEON_OK:
      ;
    SM_HEROTAKEON_FAIL:
      ;
    SM_HEROTAKEOFF_OK:
      ;
    SM_HEROTAKEOFF_FAIL:
      ;
    SM_HEROEAT_OK:
      ;
    SM_HEROEAT_FAIL:
      ;
    SM_HEROWINEXP:
      ;
    SM_HEROLEVELUP:
      ;
    SM_HEROUPDATEITEM:
      ;
    SM_HEROADDITEM:
      ;
    SM_HERODROPITEM_SUCCESS:
      begin // 英雄成功的把物品扔在地上了
        DelDropItem(EdCode.DecodeString(body), Msg.Recog);
      end;
    SM_HERODROPITEM_FAIL:
      ;
    SM_HEROADDMAGIC:
      ;
    SM_HERODELMAGIC:
      ;
    SM_HEROWEIGHTCHANGED:
      ;
    SM_HEROMAGIC_LVEXP:
      ;
    SM_HERODURACHANGE:
      ;
    SM_EXPTIMEITEMS:
      begin // 聚灵珠时间改变 20080307
        ClientGetExpTimeItemChange(Msg.Recog { 物品MakeIndex } , Msg.tag);
      end;
    SM_HERODELITEMS:
      ;
    SM_HERODELITEM:
      ;
    SM_VERSION_FAIL:
      ;
    SM_NEWMAP:
      begin
        g_sMapTitle := '';
        FrmDlg.DTMiniMapName.Propertites.Caption.Text := g_sMapTitle;
        g_sMapMusic := '';
        g_nMapMusic := -1;
        PlayScene.SendMsg(SM_NEWMAP, Msg.Recog, Msg.Param { x } ,
          Msg.tag { y } , Msg.series { darkness } , 0, 0, 0, 0,
          EdCode.DecodeString(body) { mapname } );
      end;

    SM_LOGON:
      begin
        SendClientDataVer;
        with Msg do
        begin
          DecodeBuffer(body, @CharDesc, SizeOf(TCharDesc));
          PlayScene.SendMsg(SM_LOGON, Msg.Recog, Loword(Msg.Param) { x } ,
            Hiword(Msg.Param) { y } , Msg.series { dir } , CharDesc.Feature,
            CharDesc.Status, CharDesc.Properties, CharDesc.DressWepon, '');
          PlayScene.SendMsg(SM_FEATURECHANGED, Msg.Recog, 0, 0, Msg.nSessionID,
            CharDesc.Feature, CharDesc.Status, CharDesc.Properties,
            CharDesc.DressWepon, ''{$I UpdateActorFromCharDesc.Inc});
          DScreen.ChangeScene(stPlayGame);
          SendClientMessage(CM_QUERYBAGITEMS, 0, 0, 0, 0);
          g_boServerChanging := False;
          g_boStallLoaded := False;
          g_boStallListLoaded := False;
          g_boPutOn := False;
          g_boStallLock := False;
          g_MarketItem.Item.Item.Name := '';
          g_SelMarketName := '';
          g_SelMarketPlay := '';
          g_MyMarketName := '';
          g_MyMarketGold := 0;
          g_MyMarketGameGold := 0;
          FillChar(g_MyMarket, SizeOf(g_MyMarket), #0);
          FillChar(g_WhoStall, SizeOf(g_WhoStall), #0);
          FillChar(g_StallItems, SizeOf(g_StallItems), #0);
          FillChar(g_StallBuyItems, SizeOf(g_StallBuyItems), #0);
          FillChar(g_QueryStallItems, SizeOf(g_QueryStallItems), #0);
          FillChar(g_QueryStallBuyItems, SizeOf(g_QueryStallBuyItems), #0);
          AssistantForm.ClearFilter;
          FrmDlg.OpenMiniMap(False);
        end;
        if g_wAvailIDDay > 0 then
          AddChatBoardString('您当前通过包月帐号充值.', clGreen, clWhite)
        else if g_wAvailIPDay > 0 then
          AddChatBoardString('您当前通过包月IP 充值.', clGreen, clWhite)
        else if g_wAvailIPHour > 0 then
          AddChatBoardString('您当前通过计时IP 充值.', clGreen, clWhite)
        else if g_wAvailIDHour > 0 then
          AddChatBoardString('您当前通过计时帐号充值.', clGreen, clWhite);
      end;
    SM_SERVERCONFIG:
      ClientGetServerConfig(Msg, body);
    SM_RECONNECT:
      ClientGetReconnect(body);
    { SM_TIMECHECK_MSG:
      begin
      CheckSpeedHack (msg.Recog);
      end; }

    SM_AREASTATE:
      begin
        g_nAreaStateValue := Msg.Recog;
        g_boCanRunHuman := SetContain(g_nAreaStateValue,AREA_RUNHUMAN);
        g_boCanRunMon := SetContain(g_nAreaStateValue,AREA_RUNMON);
        g_boCanRunNpc := SetContain(g_nAreaStateValue,AREA_RunNPC);
      end;

    SM_MAPDESCRIPTION:
      begin
        ClientGetMapDescription(Msg, body);
      end;
    SM_GAMEGOLDNAME:
      begin
        ClientGetGameGoldName(Msg, body);
      end;
    SM_ADJUST_BONUS:
      begin
        ClientGetAdjustBonus(Msg.Recog, body);
      end;
    SM_MYSTATUS:
      begin
        g_nMyHungryState := Msg.Param;
      end;
    // SM_TURN:
    // begin
    // PlayScene.SendMsg(SM_CHANGEDIR, Msg.Recog, LoWord(Msg.param){ x } , HiWord(Msg.param){ y } , Msg.series { dir + light } ,0,0,0,0,'',nil)
    // end;
    // 随云优化 后面再处理 先还原到之前的
    // SM_VIEWNEWACTOR:
    // begin
    // Buffer.SetBuffer(Buf,nLen);
    // btByte := Buffer.ReadByte; //获取类型。
    // FillChar(CharDesc,SizeOf(TCharDesc),0);
    // if btByte = 1 then
    // begin
    // Buffer.ReadBuf(@CharDesc,SizeOf(TCharDesc));
    // end else
    // begin
    // Buffer.ReadBuf(@CharDesc,SizeOf(TCharSimpleDesc));
    // end;
    //
    // body2 := Buffer.ReadAnsiString();
    // PlayScene.SendMsg(SM_TURN, Msg.Recog, LoWord(Msg.param){ x } , HiWord(Msg.param){ y } , Msg.series { dir + light } , CharDesc.feature, CharDesc.Status, CharDesc.Properties, CharDesc.DressWepon, ''{$I UpdateActorFromCharDesc.Inc});
    // {$I UpdateCharDesc.inc}
    // end;

    SM_TURN:
      begin
        body2 := AnsiGetValidStr2(body, Body3, ['/']);
        DecodeBuffer(Body3, @CharDesc, SizeOf(TCharDesc));
        PlayScene.SendMsg(SM_TURN, Msg.Recog, Loword(Msg.Param) { x } ,
          Hiword(Msg.Param) { y } , Msg.series { dir + light } ,
          CharDesc.Feature, CharDesc.Status, CharDesc.Properties,
          CharDesc.DressWepon, ''{$I UpdateActorFromCharDesc.Inc});

{$I UpdateCharDesc.inc}
      end;

    SM_BACKSTEP:
      begin
        body2 := AnsiGetValidStr2(body, Body3, ['/']);
        DecodeBuffer(Body3, @CharDesc, SizeOf(TCharDesc));
        PlayScene.SendMsg(SM_BACKSTEP, Msg.Recog, Loword(Msg.Param) { x } ,
          Hiword(Msg.Param) { y } , Msg.series { dir + light } ,
          CharDesc.Feature, CharDesc.Status, CharDesc.Properties,
          CharDesc.DressWepon, ''{$I UpdateActorFromCharDesc.Inc}); // 捞抚
{$I UpdateCharDesc.inc}
      end;
    SM_BATTERBACKSTEP:
      begin
        body2 := AnsiGetValidStr2(body, Body3, ['/']);
        DecodeBuffer(Body3, @CharDesc, SizeOf(TCharDesc));
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          Actor.m_nBatterMoveStep := Msg.nSessionID;
          Actor.m_nBatterX := Msg.Param;
          Actor.m_nBatterY := Msg.tag;
        end;
        PlayScene.SendMsg(SM_BATTERBACKSTEP, Msg.Recog,
          Loword(Msg.Param) { x } , Hiword(Msg.Param) { y } ,
          Msg.series { dir + light } , CharDesc.Feature, CharDesc.Status,
          CharDesc.Properties, CharDesc.DressWepon,
          ''{$I UpdateActorFromCharDesc.Inc}); // 捞抚
{$I UpdateCharDesc.inc}
      end;

    SM_SPACEMOVE_HIDE, SM_SPACEMOVE_HIDE2:
      begin
        if Msg.Recog <> g_MySelf.m_nRecogId then
        begin
          PlayScene.SendMsg(Msg.ident, Msg.Recog, Msg.Param { x } ,
            Msg.tag { y } , 0, 0, 0, 0, 0, '')
        end;
      end;
    { TODO -o随云 -c流量 : 流量优化 }
    // SM_SPACEMOVE_SHOW, SM_SPACEMOVE_SHOW2, SM_SPACEMOVE_SHOW3:
    // begin
    // nBodyState := 0;
    // body2 := AnsiGetValidStr2(body, body3, ['\']);
    // DecodeBuffer(body3, @CharDesc, SizeOf(TCharDesc));
    // DecodeBuffer(body2,PAnsiChar(@nBodyState),4);
    //
    // if Msg.Recog <> g_MySelf.m_nRecogId then
    // PlayScene.NewActor(Msg.Recog, Msg.param, Msg.tag, Msg.series, CharDesc.feature, CharDesc.Status, CharDesc.Properties, CharDesc.DressWepon);
    //
    //
    // PlayScene.SendMsg(Msg.ident, Msg.Recog, Msg.Param{ x } , Msg.Tag{ y } , Msg.series { dir + light } , CharDesc.feature, CharDesc.Status, CharDesc.Properties, CharDesc.DressWepon, ''{$I UpdateActorFromCharDescLite.Inc}); // 捞抚
    // Actor := PlayScene.FindActor(Msg.Recog);
    // if Actor <> nil then
    // begin
    // Actor.m_nTag := Msg.Recog;
    // end;
    // end;

    SM_SPACEMOVE_SHOW, SM_SPACEMOVE_SHOW2, SM_SPACEMOVE_SHOW3:
      begin
        body2 := AnsiGetValidStr2(body, Body3, ['/']);
        DecodeBuffer(Body3, @CharDesc, SizeOf(TCharDesc));
        if Msg.Recog <> g_MySelf.m_nRecogId then
          PlayScene.NewActor(Msg.Recog, Msg.Param, Msg.tag, Msg.series,
            CharDesc.Feature, CharDesc.Status, CharDesc.Properties,
            CharDesc.DressWepon);
        PlayScene.SendMsg(Msg.ident, Msg.Recog, Loword(Msg.Param) { x } ,
          Hiword(Msg.Param) { y } , Msg.series { dir + light } ,
          CharDesc.Feature, CharDesc.Status, CharDesc.Properties,
          CharDesc.DressWepon, ''{$I UpdateActorFromCharDesc.Inc}); // 捞抚
{$I UpdateCharDesc.inc}
      end;

    SM_NPCWALK, SM_WALK, SM_SNEAK, SM_RUSH, SM_RUSHKUNG:
      begin
        body2 := AnsiGetValidStr2(body, Body3, ['/']);
        DecodeBuffer(Body3, @CharDesc, SizeOf(TCharDesc));
        if (Msg.Recog <> g_MySelf.m_nRecogId) or (Msg.ident = SM_RUSH) or
          (Msg.ident = SM_RUSHKUNG) then
          PlayScene.SendMsg(Msg.ident, Msg.Recog, Loword(Msg.Param) { x } ,
            Hiword(Msg.Param) { y } , Msg.series { dir+light } ,
            CharDesc.Feature, CharDesc.Status, CharDesc.Properties,
            CharDesc.DressWepon, ''{$I UpdateActorFromCharDesc.Inc});
{$I UpdateCharDesc.inc}
      end;

    SM_BloodRush:
      begin
        PlayScene.SendMsg(Msg.ident, Msg.Recog, Loword(Msg.Param) { x } ,
          Hiword(Msg.Param) { y } , Msg.series { dir+light } , Msg.tag, 0,
          0, 0, '', );
      end;

    SM_BloodRushHit:
      begin
        PlayScene.SendMsg(Msg.ident, Msg.Recog, Loword(Msg.Param) { x } ,
          Hiword(Msg.Param) { y } , Msg.series { 技能ID } , Msg.tag, 0, 0,
          0, '', nil);
      end;

    SM_RUN, SM_HORSERUN:
      begin
        body2 := AnsiGetValidStr2(body, Body3, ['/']);
        DecodeBuffer(Body3, @CharDesc, SizeOf(TCharDesc));
        if Msg.Recog <> g_MySelf.m_nRecogId then
          PlayScene.SendMsg(Msg.ident, Msg.Recog, Loword(Msg.Param) { x } ,
            Hiword(Msg.Param) { y } , Msg.series { dir+light } ,
            CharDesc.Feature, CharDesc.Status, CharDesc.Properties,
            CharDesc.DressWepon, ''{$I UpdateActorFromCharDesc.Inc});
{$I UpdateCharDesc.inc}
      end;

    { TODO -o随云 -c流量 : 流量优化 }
    // SM_WALK,SM_RUN:
    // begin
    // if Msg.Recog <> g_MySelf.m_nRecogId then
    // PlayScene.SendMsg(Msg.ident, Msg.Recog, Msg.param{ x } , Msg.Tag{ y } ,
    // Msg.series { dir+light } , 0, 0, 0, 0, '',);
    // end;

    // SM_HORSERUN:
    // begin
    // body2 := AnsiGetValidStr2(body, body3, ['/']);
    // DecodeBuffer(body3, @CharDesc, SizeOf(TCharDesc));
    // if Msg.Recog <> g_MySelf.m_nRecogId then
    // PlayScene.SendMsg(Msg.ident, Msg.Recog, Msg.param{ x } , Msg.tag{ y } , Msg.series { dir+light } , CharDesc.feature, CharDesc.Status, CharDesc.Properties, CharDesc.DressWepon, ''{$I UpdateActorFromCharDesc.Inc});
    // {$I UpdateCharDesc.inc}
    // end;

    // SM_NPCWALK, SM_WALK, SM_SNEAK, SM_RUSH, SM_RUSHKUNG:
    // begin
    // body2 := AnsiGetValidStr2(body, body3, ['/']);
    // DecodeBuffer(body3, @CharDesc, SizeOf(TCharDesc));
    // if (Msg.Recog <> g_MySelf.m_nRecogId) or (Msg.ident = SM_RUSH) or (Msg.ident = SM_RUSHKUNG) then
    // PlayScene.SendMsg(Msg.ident, Msg.Recog, LoWord(Msg.param){ x } , HiWord(Msg.param){ y } , Msg.series { dir+light } , CharDesc.feature, CharDesc.Status, CharDesc.Properties, CharDesc.DressWepon, ''{$I UpdateActorFromCharDesc.Inc});
    // {$I UpdateCharDesc.inc}
    // end;

    SM_CHANGELIGHT: // 游戏亮度
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          Actor.m_nChrLight := Msg.Param;
        end;
      end;

    SM_LAMPCHANGEDURA:
      begin
        if g_UseItems[U_RIGHTHAND].Name <> '' then
        begin
          g_UseItems[U_RIGHTHAND].Dura := Msg.Recog;
        end;
      end;

    SM_MOVEFAIL:
      begin
        ActionFailed;
        body2 := AnsiGetValidStr2(body, Body3, ['/']);
        DecodeBuffer(Body3, @CharDesc, SizeOf(TCharDesc));
        PlayScene.SendMsg(SM_TURN, Msg.Recog, Loword(Msg.Param) { x } ,
          Hiword(Msg.Param) { y } , Msg.series { dir } , CharDesc.Feature,
          CharDesc.Status, CharDesc.Properties, CharDesc.DressWepon, '',
          procedure(Sender: TActor)begin
          // {$I UpdateActorFromCharDesc.Inc}
          Sender.m_nTag := Msg.nToken; Sender.m_nFeature := CharDesc.Feature;
          Sender.m_nDressWeapon := CharDesc.DressWepon;
          Sender.m_nFeatureEx := CharDesc.DressWeponEffect;
          Sender.m_btHorse := Loword(CharDesc.HorseAndLeft);
          Sender.m_wShield := Hiword(CharDesc.HorseAndLeft); end);
{$I UpdateCharDesc.inc}
      end;
    SM_BUTCH:
      begin
        body2 := AnsiGetValidStr2(body, Body3, ['/']);
        DecodeBuffer(Body3, @CharDesc, SizeOf(TCharDesc));
        if Msg.Recog <> g_MySelf.m_nRecogId then
        begin
          Actor := PlayScene.FindActor(Msg.Recog);
          if Actor <> nil then
            Actor.SendMsg(SM_SITDOWN, Loword(Msg.Param) { x } ,
              Hiword(Msg.Param) { y } , Msg.series { dir } , 0, 0,
              CharDesc.Properties, CharDesc.DressWepon, '', 0);
        end;
{$I UpdateCharDesc.inc}
      end;
    SM_SITDOWN:
      begin
        body2 := AnsiGetValidStr2(body, Body3, ['/']);
        DecodeBuffer(Body3, @CharDesc, SizeOf(TCharDesc));
        if Msg.Recog <> g_MySelf.m_nRecogId then
        begin
          Actor := PlayScene.FindActor(Msg.Recog);
          if Actor <> nil then
            Actor.SendMsg(SM_SITDOWN, Loword(Msg.Param) { x } ,
              Hiword(Msg.Param) { y } , Msg.series { dir } , 0, 0,
              CharDesc.Properties, CharDesc.DressWepon, '', 0);
        end;
{$I UpdateCharDesc.inc}
      end;

    SM_HIT, SM_HEAVYHIT:
      begin
        if Msg.Recog <> g_MySelf.m_nRecogId then
        begin
          Actor := PlayScene.FindActor(Msg.Recog);
          if Actor <> nil then
          begin
            Actor.SendMsg(Msg.ident, Msg.Param { x } , Msg.tag { y } ,
              Loword(Msg.series) { dir } , 0, Hiword(Msg.series) -
              1 { magicid } , 0, 0, '', 0, Msg.nSessionID { target } ,
              Msg.nToken);
           // Actor.CleanUserMsgs;
           // Actor.CancelActionEx;
            if Msg.ident = SM_ZHUIXINHIT then
            begin
              Actor.m_nBatterMoveStep := Msg.nSessionID;
              DecodeBuffer(body, @batmsg, SizeOf(TBatterZhuiXinMessage));
              Actor.m_nBatterZhuiXin.Param1 := batmsg.X;
              Actor.m_nBatterZhuiXin.Param2 := batmsg.Y;
              Actor := PlayScene.FindActor(batmsg.DefMsg.Recog);
              if Actor <> nil then
              begin
                Actor.m_nBatterMoveStep := batmsg.DefMsg.nSessionID;
                Actor.m_nBatterX := batmsg.DefMsg.Param;
                Actor.m_nBatterY := batmsg.DefMsg.tag;
                Actor.m_nBatterdir := batmsg.DefMsg.series;
                PlayScene.SendMsg(SM_BATTERBACKSTEP, batmsg.DefMsg.Recog,
                  batmsg.DefMsg.Param { x } , batmsg.DefMsg.tag { y } ,
                  batmsg.DefMsg.series { dir + light } , batmsg.desc.Feature,
                  batmsg.desc.Status, 0, batmsg.desc.DressWepon, '');
              end;
            end;
            if Msg.ident = SM_HEAVYHIT then
            begin
              if body <> '' then
                Actor.m_boDigFragment := True;
            end;
          end;
        end;
      end;
    SM_LEITINGHIT:
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          Actor.SendMsg(Msg.ident, Loword(Msg.Param) { x } ,
            Hiword(Msg.Param) { y } , Msg.series { dir } , 0, 0, 0, 0, '', 0);
          if Msg.ident = SM_HEAVYHIT then
          begin
            if body <> '' then
              Actor.m_boDigFragment := True;
          end;
        end;
      end;
    SM_PIXINGHIT: // 20080611劈星
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          Actor.SendMsg(SM_HIT, Loword(Msg.Param) { x } ,
            Hiword(Msg.Param) { y } , Msg.series { dir } , 0, 0, 0, 0, '', 0);
          if Msg.ident = SM_HEAVYHIT then
          begin
            if body <> '' then
              Actor.m_boDigFragment := True;
          end;
        end;
      end;
    SM_FLYAXE:
      begin
        DecodeBuffer(body, @wl, SizeOf(TMessageBodyWL));
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          Actor.SendMsg(Msg.ident, Loword(Msg.Param) { x } ,
            Hiword(Msg.Param) { y } , Msg.series { dir } , 0, 0, 0, 0, '', 0);
          Actor.m_nTargetX := wl.Param1;
          Actor.m_nTargetY := wl.Param2;
          Actor.m_nTargetRecog := MakeLong(wl.Tag1, wl.Tag2);
        end;
      end;
    SM_FAIRYATTACKRATE,
    // 月灵重击 2007.12.14
    SM_LIGHTING:
      begin
        DecodeBuffer(body, @wl, SizeOf(TMessageBodyWL));
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          Actor.SendMsg(Msg.ident, Loword(Msg.Param) { x } ,
            Hiword(Msg.Param) { y } , Msg.series { dir } , 0, 0, 0, 0, '', 0);
          Actor.m_nTargetX := wl.Param1;
          Actor.m_nTargetY := wl.Param2;
          Actor.m_nTargetRecog := wl.Tag1;
          Actor.m_nMagicNum := wl.Tag2;
        end;
      end;

    SM_SPELL:
      begin
        UseMagicSpell(SM_SPELL, Msg.Recog { who } , Msg.series { effectnum } ,
          Msg.Param { tx } , Msg.tag { y } , Msg.nSessionID,
          Lobyte(Loword(Msg.nToken)), Hibyte(Loword(Msg.nToken)),
          Hiword(Msg.nToken));
      end;
    SM_MAGICFIRE:
      begin
        UseMagicFire(Msg.Recog { who } , Loword(Msg.Param) { efftype } ,
          Hiword(Msg.Param) { effnum } , Loword(Msg.tag) { tx } ,
          Hiword(Msg.tag) { y } , Msg.series, Hiword(Msg.nSessionID) = 0);
      end;
    SM_MAGICFIRE_FAIL:
      begin
        UseMagicFireFail(Msg.Recog { who } , Msg.Param);
      end;
    SM_OUTOFCONNECTION:
      begin
        g_boDoFastFadeOut := False;
        g_boDoFadeIn := False;
        g_boDoFadeOut := False;
        AddMessageDialog('服务器连接被强行中断。\连接时间可能超过限制。', [mbOk],
          procedure(AResult: Integer)begin Close; end);
      end;

    SM_DEATH, SM_NOWDEATH:
      begin
        body2 := AnsiGetValidStr2(body, Body3, ['/']);
        DecodeBuffer(Body3, @CharDesc, SizeOf(TCharDesc));
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          Actor.SendMsg(Msg.ident, Loword(Msg.Param) { x } ,
            Hiword(Msg.Param) { y } , Msg.series { damage } , CharDesc.Feature,
            CharDesc.Status, CharDesc.Properties, CharDesc.DressWepon, '', 0);
          Actor.m_Abil.HP := 0;
          if Actor = g_MySelf then
          g_MyAbil.HP := 0;
        end
        else
        begin
          PlayScene.SendMsg(SM_DEATH, Msg.Recog, Loword(Msg.Param) { x } ,
            Hiword(Msg.Param) { y } , Msg.series { damage } , CharDesc.Feature,
            CharDesc.Status, CharDesc.Properties, CharDesc.DressWepon,
            ''{$I UpdateActorFromCharDesc.Inc});
        end;
{$I UpdateCharDesc.inc}
      end;
    SM_SKELETON:
      begin
        body2 := AnsiGetValidStr2(body, Body3, ['/']);
        DecodeBuffer(Body3, @CharDesc, SizeOf(TCharDesc));
        PlayScene.SendMsg(SM_SKELETON, Msg.Recog, Loword(Msg.Param) { x } ,
          Hiword(Msg.Param) { y } , Msg.series { damage } , CharDesc.Feature,
          CharDesc.Status, CharDesc.Properties, CharDesc.DressWepon,
          ''{$I UpdateActorFromCharDesc.Inc});
{$I UpdateCharDesc.inc}
      end;
    SM_ALIVE:
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          body2 := AnsiGetValidStr2(body, Body3, ['/']);
          Actor.m_Abil.HP := Msg.nSessionID;
          if Actor = g_MySelf then
            g_MyAbil.HP := Msg.nSessionID;

          Actor.m_boDeath := False;
          DecodeBuffer(Body3, @CharDesc, SizeOf(TCharDesc));
          PlayScene.SendMsg(SM_ALIVE, Msg.Recog, Loword(Msg.Param) { x } ,
            Hiword(Msg.Param) { y } , Msg.series { DIR } , CharDesc.Feature,
            CharDesc.Status, CharDesc.Properties, CharDesc.DressWepon,
            ''{$I UpdateActorFromCharDesc.Inc});
{$I UpdateCharDesc.inc}
        end;
      end;

    SM_ABILITY:
      begin
        g_nGold := Msg.Recog;
        g_MySelf.m_btJob := Msg.Param;
        g_JobName := GetJobName(g_MySelf.m_btJob);
        if g_MySelf.m_btJob = _JOB_SHAMAN then
          g_MySelf.m_btSex := 0;

        g_dwGameGold := Msg.tag;
        g_nGamePoint := Msg.series;
        DecodeBuffer(body, @g_MySelf.m_Abil, SizeOf(TAbility));
        g_MyAbil := g_MySelf.m_Abil;
        g_MyMixedAbility := RecalcMyTotalAbility;
        OnMySelfLevelChange(g_MySelf.m_Abil.Level);
      end;

    SM_SUBABILITY:
      begin
        ClientGetSubAbility(body);
        g_MyMixedAbility := RecalcMyTotalAbility;
      end;

    SM_DAYCHANGING:
      begin
        g_nDayBright := Msg.Param;
        { 20080816注释显示黑暗
          DarkLevel := msg.Tag;
          if DarkLevel = 0 then g_boViewFog := FALSE
          else g_boViewFog := TRUE; }
      end;

    SM_WINEXP:
      begin
        g_MySelf.m_Abil.Exp := Msg.Recog;
        g_MyAbil.Exp := Msg.Recog;
        if Msg.tag > 0 then
          UpdateAddSoulExp(Msg.tag);
        if (g_MirStartupInfo.AssistantKind = 0) or
          (not g_Config.Assistant.FilterExp or
          (abs(Msg.Param) > g_Config.Assistant.FilterExpValue)) then
        begin
          if Msg.Param > 0 then
            DScreen.AddSysMsg(IntToStr(Msg.Param) + ' 经验值增加.')
          else if Msg.Param < 0 then
            DScreen.AddSysMsg(IntToStr(abs(Msg.Param)) + ' 经验值减少.')
        end;
      end;

    SM_LEVELUP:
      begin
        g_MySelf.m_Abil.Level := Msg.Param;
        DScreen.AddSysMsg('升级!');
      end;

    SM_HEALTHSPELLCHANGED:
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
          Actor.HealthSpellChange(Msg.Param, Msg.tag, Msg.series);
      end;
    SM_GROUPHEALTHSPELLCHANGED:
      begin
        UpdateGroupUserHealth(Msg.Recog, Msg.Param, Msg.tag, Msg.series,
          Msg.nSessionID);
      end;
    SM_GROUPLEVELCHANGED:
      begin
        UpdateGroupUserLevel(Msg.Recog, Msg.tag, Msg.Param);
      end;
    SM_STRUCK:
      begin
        // wl: TMessageBodyWL;
        // DecodeBuffer(body, @wl, SizeOf(TMessageBodyWL));
        // Actor := PlayScene.FindActor(Msg.Recog);
        // if Actor <> nil then
        // begin
        // if Actor = g_MySelf then
        // begin
        // if g_MySelf.m_nNameColor = 249 then // 红名
        // g_dwLatestStruckTick := GetTickCount;
        // end
        // else
        // begin
        // if Actor.CanCancelAction then
        // Actor.CancelAction;
        // end;
        // // 稳如泰山
        // if not g_boDiableSTRUCK or (Actor <> g_MySelf) then
        // Actor.UpdateMsg(SM_STRUCK, wl.Tag2, 0, Msg.series { damage } , wl.Param1, wl.Param2, wl.Param3, wl.Param4, '', wl.Tag1);
        // if Actor <> g_MySelf then
        // Actor.DamageHealthHPChange(Msg.param, Msg.tag, Msg.series);
        // end;

        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          if Actor = g_MySelf then
          begin
            if g_MySelf.m_nNameColor = 249 then // 红名
              g_dwLatestStruckTick := GetTickCount;
          end
          else
          begin
            if Actor.CanCancelAction then
              Actor.CancelAction;
          end;
          // 稳如泰山
          n := MakeLong(Msg.Param, Msg.tag);
          if not g_boDiableSTRUCK or (Actor <> g_MySelf) then
          begin
            Actor.UpdateMsg(SM_STRUCK, Msg.series, 0, n { damage } , 0, 0, 0,
              0, '', 0);
          end;

          DecodeBuffer(body, @health, SizeOf(health));
          if Actor <> g_MySelf then
            Actor.DamageHealthHPChange(health.Param1, health.Param2, n);
        end;
      end;
    SM_STRUCK_MISS:
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
          Actor.MissHealthSpellChange;
      end;
    SM_STORM:
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          case Msg.Param of
            0:
              Actor.SetNextFixedEffect(17, 0);
            1:
              Actor.SetNextFixedEffect(24, 0);
          end;
        end;
      end;
    SM_CHANGEFACE:
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          body2 := AnsiGetValidStr2(body, Body3, ['/']);
          DecodeBuffer(Body3, @CharDesc, SizeOf(TCharDesc));
          Actor.m_nWaitForRecogId := Msg.Param;
          Actor.m_nWaitForFeature := CharDesc.Feature;
          Actor.m_nWaitForStatus := CharDesc.Status;
          Actor.m_nWaitForProperties := CharDesc.Properties;
          Actor.m_nWaitForDressWeapon := CharDesc.DressWepon;
          AddChangeFace(Actor.m_nWaitForRecogId);
{$I UpdateCharDesc.inc}
        end;
      end;
    SM_PASSWORD:
      SetInputStatus();
    SM_OPENHEALTH:
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          if Actor <> g_MySelf then
          begin
            Actor.m_Abil.HP := Msg.Param;
            Actor.m_Abil.MaxHP := Msg.tag;
          end;
          Actor.m_boOpenHealth := True;
          // actor.OpenHealthTime := 999999999;
          // actor.OpenHealthStart := GetTickCount;
        end;
      end;
    SM_CLOSEHEALTH:
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          Actor.m_boOpenHealth := False;
        end;
      end;
    SM_INSTANCEHEALGUAGE:
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          Actor.m_Abil.HP := Msg.Param;
          Actor.m_Abil.MaxHP := Msg.tag;
          Actor.m_noInstanceOpenHealth := True;
          Actor.m_dwOpenHealthTime := 2 * 1000;
          Actor.m_dwOpenHealthStart := GetTickCount;
        end;
      end;

    SM_BREAKWEAPON: // 武器破碎
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          if Actor is THumActor then
            THumActor(Actor).DoWeaponBreakEffect;
        end;
      end;

    SM_CRY, // 喊话消息
    SM_GROUPMESSAGE,
    // 组队消息
    SM_GUILDMESSAGE,
    // 行会消息
    SM_WHISPER,
    // 私聊消息
    SM_MOVEMESSAGE,
    // 滚动消息
    SM_SYSMESSAGE, SM_NATIONMESSAGE, SM_CAMPMESSAGE: // 系统消息
      begin
        body2 := AnsiGetValidStr3(body, Body3, ['/']);
        AMessage := EdCode.DecodeString(Body3);
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          if not NameInEnemies(Actor.m_sUserName) then
          begin
            case Msg.ident of
              SM_MOVEMESSAGE:
                begin
                  case Msg.nSessionID of
                    0:
                      DScreen.AddSysBoard(AMessage);
                    1:
                      DScreen.AddCenterLetter(AMessage,Msg.Series);
                    2:
                      DScreen.AddCountDown(AMessage, Msg.Param, Msg.tag = 1);
                  end;
                end;
              SM_GUILDMESSAGE:
                begin
                  AddChatBoardString(AMessage, GetRGB(Lobyte(Msg.Param)),
                    GetRGB(Hibyte(Msg.Param)), body2);
                  g_Guild.AddChat(AMessage);
                end
            else
              begin
                AddChatBoardString(AMessage, GetRGB(Lobyte(Msg.Param)),
                  GetRGB(Hibyte(Msg.Param)), body2);
                if Msg.ident = SM_WHISPER then
                  DScreen.ChatHisMessage.AddMessage
                    ('{S=#91' + FormatDateTime('hh:mm:ss', Now) + '#93;C=248} '
                    + AMessage, body2, clWhite, clNone);
              end;
            end;
          end;
        end
        else if Msg.ident = SM_WHISPER then
        begin
          AddChatBoardString(AMessage, GetRGB(Lobyte(Msg.Param)),
            GetRGB(Hibyte(Msg.Param)), body2);
          DScreen.ChatHisMessage.AddMessage
            ('{S=#91' + FormatDateTime('hh:mm:ss', Now) + '#93;C=248} ' +
            AMessage, body2, clWhite, clNone);
        end;
      end;
    SM_DELETEMOVEMESSAGE:
      begin
        DScreen.DeleteCountDown(Msg.tag);
      end;
    SM_HEAR:
      begin
        Body3 := AnsiGetValidStr3(body, body2, ['/']);
        AMessage := EdCode.DecodeString(body2);
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          if not NameInEnemies(Actor.m_sUserName) then
            Actor.Say(AMessage,GetRGB(Lobyte(Msg.Param)),GetRGB(Hibyte(Msg.Param)));
        end;
        if not g_boOwnerMsg then // 拒绝公聊 2008.02.11
        begin
          if (Actor = nil) or ( not NameInEnemies(Actor.m_sUserName)) then
          begin
            if GetRGB(Lobyte(Msg.Param)) <> 0 then
            begin
               AMessage := GetValidStr3(AMessage,ANode1,[':']);
               AMessage := Format(ANode1 + ':{S=%s;C=%d}',[AMessage,Lobyte(Msg.Param)]);
               AddChatBoardString(AMessage, clblack,
                clwhite, Body3);
            end else
            begin
              AddChatBoardString(AMessage, GetRGB(Lobyte(Msg.Param)),
                GetRGB(Hibyte(Msg.Param)), Body3);
            end;

          end;

//          if Actor <> nil then
//          begin
//            if not NameInEnemies(Actor.m_sUserName) then
//            begin
//              AddChatBoardString(AMessage, GetRGB(Lobyte(Msg.Param)),
//                GetRGB(Hibyte(Msg.Param)), Body3);
//            end;
//          end
//          else
//          begin
//            AddChatBoardString(AMessage, GetRGB(Lobyte(Msg.Param)),
//              GetRGB(Hibyte(Msg.Param)), Body3);
//          end;
        end;
      end;
    SM_USERNAME:
      begin
        ClientGetActorName(Msg.Recog,Msg.nSessionID, Msg.Param, Msg.Param,
          EdCode.DecodeString(body));
      end;
    SM_CHANGENAMECOLOR:
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          Actor.m_nNameColor := GetRGB(Msg.Param);
          Actor.m_btMiniMapHeroColor := Msg.Param;
        end;
      end;

    SM_HIDE, SM_GHOST, SM_DISAPPEAR:
      begin
        if g_MySelf.m_nRecogId <> Msg.Recog then
          PlayScene.SendMsg(SM_HIDE, Msg.Recog, Loword(Msg.Param) { x } ,
            Hiword(Msg.Param) { y } , 0, 0, 0, 0, 0, '');
      end;
    SM_DISAPPEARIDS:
      begin
        DoDisappearIDs(EdCode.DecodeString(body));
      end;
    SM_DIGUP:
      begin
        DecodeBuffer(body, @wl, SizeOf(TMessageBodyWL));
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor = nil then
          Actor := PlayScene.NewActor(Msg.Recog, Msg.Param, Msg.tag, Msg.series,
            wl.Param1, wl.Param2, wl.Param3, wl.Param4);
        Actor.m_nCurrentEvent := wl.Tag1;
        Actor.SendMsg(SM_DIGUP, Loword(Msg.Param) { x } ,
          Hiword(Msg.Param) { y } , Msg.series { dir + light } , wl.Param1,
          wl.Param2, wl.Param3, wl.Param4, '', 0);
      end;
    SM_DIGDOWN:
      begin
        PlayScene.SendMsg(SM_DIGDOWN, Msg.Recog, Loword(Msg.Param) { x } ,
          Hiword(Msg.Param) { y } , 0, 0, 0, 0, 0, '');
      end;
    SM_SHOWEVENT:
      begin
        // case Msg.Recog of
        // ET_DIGOUTZOMBI .. ET_SOULETRAPLOCKED:
        // begin
        // Event := TClEvent.Create(Msg.param, LoWord(Msg.Tag{ x }), HiWord(Msg.Tag{ y }), Msg.Recog{ e-type } );
        // Event.m_nEventParam := 0;
        // Event.m_nTag := Msg.nSessionID;
        // EventMan.AddEvent(Event);
        // case Msg.Recog of
        // ET_FIREFLOWER_1, ET_FIREFLOWER_2, ET_FIREFLOWER_3, ET_FIREFLOWER_4, ET_FIREFLOWER_5, ET_FIREFLOWER_6, ET_FIREFLOWER_7, ET_FIREFLOWER_8: g_SoundManager.MyPlaySound(Protechny_ground);
        // ET_HEROLOGOUT: g_SoundManager.MyPlaySound(HeroHeroLogout_ground);
        // ET_FOUNTAIN: g_SoundManager.MyPlaySound(spring_ground);
        // ET_DIEEVENT: g_SoundManager.MyPlaySound(powerup_ground);
        // end;
        // end;
        // ET_MAGICEVENT:
        // begin
        // Event := TClMagicEvent.Create(Msg.param, LoWord(Msg.Tag{ x }), HiWord(Msg.Tag{ y }), Msg.Series{ e-type }, Msg.nSessionID);
        // EventMan.AddEvent(Event);
        // end
        // else
        // begin
        // Event := TClEffectEvent.Create(Msg.param, LoWord(Msg.Tag{ x }), HiWord(Msg.Tag{ y }), Msg.Recog);
        // EventMan.AddEvent(Event);
        // end;
        // end;

        n := Lobyte(Msg.series); // e-type
        case n of
          ET_DIGOUTZOMBI .. ET_SOULETRAPLOCKED:
            begin
              Event := TClEvent.Create(Msg.Recog, Msg.Param, Msg.tag, n);
              Event.m_nEventParam := 0;
              Event.m_nTag := Hibyte(Msg.series);
              EventMan.AddEvent(Event);
              case n of
                ET_FIREFLOWER_1, ET_FIREFLOWER_2, ET_FIREFLOWER_3,
                  ET_FIREFLOWER_4, ET_FIREFLOWER_5, ET_FIREFLOWER_6,
                  ET_FIREFLOWER_7, ET_FIREFLOWER_8:
                  g_SoundManager.MyPlaySound(Protechny_ground);
                ET_HEROLOGOUT:
                  g_SoundManager.MyPlaySound(HeroHeroLogout_ground);
                ET_FOUNTAIN:
                  g_SoundManager.MyPlaySound(spring_ground);
                ET_DIEEVENT:
                  g_SoundManager.MyPlaySound(powerup_ground);
              end;
            end;
          ET_MAGICEVENT:
            begin
              Event := TClMagicEvent.Create(Msg.Recog, Msg.Param, Msg.tag, n,
                Hibyte(Msg.series));
              EventMan.AddEvent(Event);
            end;
          ET_SKILLEVENT:
           begin
              Event := TCLSkillEvent.Create(Msg.Recog, Msg.Param, Msg.tag, n,
                Hibyte(Msg.series));
              EventMan.AddEvent(Event);
           end

        else
          begin
            Event := TClEffectEvent.Create(Msg.Recog, Msg.Param, Msg.tag, n);
            EventMan.AddEvent(Event);
          end;
        end;

      end;
    SM_HIDEEVENT:
      begin
        EventMan.DelEventById(Msg.Recog);
      end;
    SM_ADDITEM:
      begin
        ClientGetAddItem(body);
      end;
    SM_BAGITEMS:
      begin
        if g_boItemMoving then
          FrmDlg.CancelItemMoving;
        ClientGetBagItmes(body);
      end;
    SM_UPDATEITEM:
      begin
        ClientGetUpdateItem(body);
      end;
    SM_DELITEM:
      begin
        ClientGetDelItem(body);
      end;
    SM_DELITEMS:
      begin
        ClientGetDelItems(body);
      end;

    SM_DROPITEM_SUCCESS:
      begin
        DelDropItem(EdCode.DecodeString(body), Msg.Recog);
      end;
    SM_DROPITEM_FAIL:
      begin
        ClientGetDropItemFail(EdCode.DecodeString(body), Msg.Recog);
      end;

    SM_ITEMSHOW:
      ClientGetShowItem(Msg.Recog, Msg.Param { x } , Msg.tag { y } ,
        Msg.series { looks } , Msg.nSessionID, EdCode.DecodeString(body));
    SM_ITEMHIDE:
      ClientGetHideItem(Msg.Recog, Msg.Param, Msg.tag);
    SM_OPENDOOR_OK:
      Map.OpenDoor(Msg.Param, Msg.tag);
    SM_OPENDOOR_LOCK:
      DScreen.AddSysMsg('此门被锁定.');
    SM_CLOSEDOOR:
      Map.CloseDoor(Msg.Param, Msg.tag);
    SM_TAKEON_OK:
      begin
        g_MySelf.m_nFeature := Msg.Recog;
        g_MySelf.m_nDressWeapon := Msg.series;
        g_MySelf.m_btHorse := Msg.tag;
        g_MySelf.FeatureChanged;
        if g_WaitingUseItem.FromIndex in [U_DRESS .. U_MAXUSEITEMIDX] then
        begin
          g_UseItems[g_WaitingUseItem.FromIndex] := g_WaitingUseItem.Item;
          if g_WaitingUseItem.FromIndex = U_WEAPON then
            g_boAutoDig := False;
        end;
        g_WaitingUseItem.Item.Name := '';
      end;
    SM_TAKEON_FAIL:
      begin
        AddItemBag(g_WaitingUseItem.Item);
        g_WaitingUseItem.Item.Name := '';
        { g_boRightItem := FALSE;{右键穿戴装备 }
      end;
    SM_TAKEOFF_OK:
      begin
        g_MySelf.m_nFeature := Msg.Recog;
        g_MySelf.m_nDressWeapon := Msg.series;
        g_MySelf.FeatureChanged;
        if g_WaitingUseItem.FromIndex = U_WEAPON then
          g_boAutoDig := False;
        g_WaitingUseItem.Item.Name := '';
      end;
    SM_TAKEOFF_FAIL:
      begin
        if g_WaitingUseItem.Item.Name <> '' then
          g_UseItems[g_WaitingUseItem.FromIndex] := g_WaitingUseItem.Item;
        g_WaitingUseItem.Item.Name := '';
      end;
    SM_SENDUSEITEMS:
      begin
        ClientGetSenduseItems(body);
      end;
    SM_WEIGHTCHANGED:
      begin
        g_MySelf.m_Abil.Weight := Msg.Recog;
        g_MySelf.m_Abil.WearWeight := Msg.Param;
        g_MySelf.m_Abil.HandWeight := Msg.tag;

        g_MyAbil.Weight := Msg.Recog;
        g_MyAbil.WearWeight := Msg.Param;
        g_MyAbil.HandWeight := Msg.tag;
      end;
    SM_GOLDCHANGED: // 金币改变
      begin
        ReadGoldNames(EdCode.DecodeString(body));
        if (body = '') and (Msg.Recog <> g_nGold) then
        begin
          g_SoundManager.DXPlaySound(s_money); // 钱的声音
          if Msg.Recog > g_nGold then
            DScreen.AddSysMsg(IntToStr(Msg.Recog - g_nGold) + ' ' +
              g_sGoldName { '金币。' } + '增加.');
        end;
        g_nGold := Msg.Recog;
        g_dwGameGold := Msg.Param;
        g_nGamePoint := Msg.tag;
        g_nGameDiaMond := Msg.series;
        g_nGameGird := Msg.nSessionID;
        g_nGameGlory := Msg.nToken;
      end;
    SM_FEATURECHANGED:
      begin
        PlayScene.SendMsg(Msg.ident, Msg.Recog, 0, 0, Msg.series, Msg.Param,
          Msg.tag, 0, Msg.nSessionID, '', procedure(Sender: TActor)
        begin Sender.SetBodyEffectProperty(Msg.nToken); end);
      end;
    SM_CHARSTATUSCHANGED:
      begin // 队伍人数
        PlayScene.SendMsg(Msg.ident, Msg.Recog, 0, 0, 0,
          MakeLong(Msg.Param, Msg.tag), Msg.series, Msg.nSessionID, 0, '');
        // PlayScene.SendMsg (msg.Ident, msg.Recog, 0, 0, 0, MakeLong(msg.Param, msg.Tag), msg.Series, EDCode.DecodeString(Body));
      end;
    SM_CLEAROBJECTS:
      begin
        PlayScene.CleanObjects;
        g_boMapMoving := True; //
      end;

    SM_EAT_OK:
      begin

        if g_EatingItem.Name <> '' then
        begin
          n := 0;
          //如果使用成功 那么找所有快捷栏物品 如果是当前使用的物品 那么就清空

          for i := MAXBAGITEM + 6 - 1 downto 6 do
          begin
            if (g_ItemArr[i].MakeIndex = g_EatingItem.MakeIndex) then
            begin
              n := i;
              FillChar(g_ItemArr[i], ClientItemSize, #0);
              Break;
            end;
          end;

          // 快捷栏的物品使用才需要自动方药
          if n < 5 then
          begin
            AutoLayOutItems;
            ArrangeItemBag;
          end;
          g_EatingItem.Name := '';
        end;
      end;
    SM_EAT_FAIL:
      begin
        OutputDebugString(PChar('吃药失败：' + IntToStr(Msg.Recog) ));
        AddItemBag(g_EatingItem);
        g_EatingItem.Name := '';
      end;

    SM_ADDMAGIC:
      begin
        if body <> '' then
          ClientGetAddMagic(body);
        FrmDlg.SetMagicPage(FrmDlg.MagicPage);
      end;
    SM_UpdateMagic:
      begin
        if body <> '' then
          ClientGetUpdateMagic(body);
        FrmDlg.SetMagicPage(FrmDlg.MagicPage);
      end;
    SM_SENDMYMAGIC:
    begin
      if body <> '' then
        ClientGetMyMagics(body);
        FrmDlg.SetMagicPage(FrmDlg.MagicPage);
    end;
    SM_DELMAGIC:
      begin
        ClientGetDelMagic(Msg.Recog);
        FrmDlg.SetMagicPage(FrmDlg.MagicPage);
      end;
    SM_SENDMYTITLES:
      begin
        ClientGetMyTitles(Msg.Recog, body);
      end;
    SM_ADDTITLE:
      begin
        ClientAddTitle(Msg.Recog, body);
      end;
    SM_REMOVETITLE:
      begin
        ClientRemoveTitle(Msg.Recog, Msg.Param);
      end;
    SM_SETACTIVETITLE:
      begin
        ClientSetActiveTitle(Msg.Recog);
      end;
    SM_MAGIC_LVEXP:
      begin
        ClientGetMagicLvExp(Msg.Recog { magid } , Msg.Param { lv } ,
          MakeLong(Msg.tag, Msg.series));
        FrmDlg.SetMagicPage(FrmDlg.MagicPage);
      end;
    SM_DURACHANGE:
      begin
        ClientGetDuraChange(Msg.Param { useitem index } , Msg.Recog,
          MakeLong(Msg.tag, Msg.series));
        AMessage := EdCode.DecodeString(body);
        if AMessage <> '' then
        begin
          if StrToIntDef(AMessage, 0) > 0 then
            g_nBeadWinExp := StrToIntDef(AMessage, 0);
        end;
      end;

    SM_MERCHANTSAY:
      begin
        ClientGetMerchantSay(Msg.Recog, Msg.Param, EdCode.DecodeString(body));
      end;
    SM_MERCHANTSAYCUSTOM:
      begin
        ClientGetMerchantSayCustom(Msg.tag, Msg.Recog, Msg.Param,
          EdCode.DecodeString(body));
      end;
    SM_CLOSEWINDOW:
      begin
        ClientGetCloseWindow(EdCode.DecodeString(body));
      end;
    SM_MERCHANTDLGCLOSE:
      begin
        FrmDlg.CloseMDlg(False);
      end;
    SM_SENDGOODSLIST:
      begin
        ClientGetSendGoodsList(Msg.Recog, Msg.Param, body);
      end;
    SM_SENDUSERMAKEDRUGITEMLIST:
      begin
        ClientGetSendMakeDrugList(Msg.Recog, body);
      end;
    SM_SENDUSERSELL:
      begin
        ClientGetSendUserSell(Msg.Recog);
      end;
    SM_SENDUSERREPAIR:
      begin
        ClientGetSendUserRepair(Msg.Recog);
      end;
    SM_SENDBUYPRICE:
      begin
        if g_SellDlgItem.Name <> '' then
        begin
          if Msg.Recog > 0 then
            g_sSellPriceStr := IntToStr(Msg.Recog) + ' ' + g_sGoldName { 金币' }
          else
            g_sSellPriceStr := '(价格未知)';
        end;
      end;
    SM_USERSELLITEM_OK:
      begin
        FrmDlg.LastestClickTime := GetTickCount;
        g_nGold := Msg.Recog;
        g_SellDlgItemSellWait.Name := '';
      end;

    SM_USERSELLITEM_FAIL:
      begin
        FrmDlg.LastestClickTime := GetTickCount;
        AddItemBag(g_SellDlgItemSellWait);
        g_SellDlgItemSellWait.Name := '';
        AddMessageDialog('您不能出售此物品.', [mbOk]);
      end;

    SM_SENDREPAIRCOST:
      begin
        if g_SellDlgItem.Name <> '' then
        begin
          if Msg.Recog >= 0 then
            g_sSellPriceStr := IntToStr(Msg.Recog) + ' ' + g_sGoldName { 金币 }
          else
            g_sSellPriceStr := '(价格未知)';
        end;
      end;
    SM_USERREPAIRITEM_OK:
      begin
        if g_SellDlgItemSellWait.Name <> '' then
        begin
          FrmDlg.LastestClickTime := GetTickCount;
          g_nGold := Msg.Recog;
          g_SellDlgItemSellWait.Dura := Msg.Param;
          g_SellDlgItemSellWait.DuraMax := Msg.tag;
          AddItemBag(g_SellDlgItemSellWait);
          g_SellDlgItemSellWait.Name := '';
        end;
      end;
    SM_USERREPAIRITEM_FAIL:
      begin
        FrmDlg.LastestClickTime := GetTickCount;
        AddItemBag(g_SellDlgItemSellWait);
        g_SellDlgItemSellWait.Name := '';
        AddMessageDialog('您不能修理此物品.', [mbOk]);
      end;
    SM_STORAGE_OK, SM_STORAGE_FULL, SM_STORAGE_FAIL:
      begin
        FrmDlg.LastestClickTime := GetTickCount;
        if Msg.ident <> SM_STORAGE_OK then
        begin
          if Msg.ident = SM_STORAGE_FULL then
            AMessage := '您的仓库已经满了，不能再保管任何东西了.'
          else
            AMessage := '您不能寄存物品.';
          AddMessageDialog(AMessage, [mbOk], procedure(AResult: Integer)
          begin if g_SellDlgItemSellWait.Name <> '' then begin AddItemBag
            (g_SellDlgItemSellWait); g_SellDlgItemSellWait.Name := '';
          end; end);
        end
        else
          g_SellDlgItemSellWait.Name := '';
      end;
    SM_SAVEITEMLIST:
      begin
        g_boBigStore := Msg.tag = 1;
        ClientGetSaveItemList(Msg.Recog, Msg.Param, body);
      end;
    SM_TAKEBACKSTORAGEITEM_OK, SM_TAKEBACKSTORAGEITEM_FAIL,
      SM_TAKEBACKSTORAGEITEM_FULLBAG:
      begin
        FrmDlg.LastestClickTime := GetTickCount;
        if Msg.ident <> SM_TAKEBACKSTORAGEITEM_OK then
        begin
          if Msg.ident = SM_TAKEBACKSTORAGEITEM_FULLBAG then
            AddMessageDialog('您无法携带更多物品了.', [mbOk])
          else
            AddMessageDialog('您无法取回物品.', [mbOk]);
        end
        else
          FrmDlg.DelStorageItem(Msg.Recog);
        // itemserverindex
      end;

    SM_BUYITEM_SUCCESS:
      begin
        FrmDlg.LastestClickTime := GetTickCount;
        g_nGold := Msg.Recog;
        FrmDlg.SoldOutGoods(Msg.Param);
        // 迫赴 酒捞袍 皋春俊辑 画
      end;
    SM_BUYITEM_FAIL:
      begin
        FrmDlg.LastestClickTime := GetTickCount;
        case Msg.Recog of
          1:
            AddMessageDialog('物品被卖出.', [mbOk]);
          2:
            AddMessageDialog('您无法携带更多物品了.', [mbOk]);
          3:
            AddMessageDialog('您没有足够的钱来购买此物品.', [mbOk]);
          4:
            AddMessageDialog('物品被卖光了，请稍后再来吧！', [mbOk]);
        end;
      end;
    SM_MAKEDRUG_SUCCESS:
      begin
        FrmDlg.LastestClickTime := GetTickCount;
        g_nGold := Msg.Recog;
        AddMessageDialog('您要的物品已经搞好了', [mbOk]);
      end;
    SM_MAKEDRUG_FAIL:
      begin
        FrmDlg.LastestClickTime := GetTickCount;
        case Msg.Recog of
          1:
            AddMessageDialog('物品不存在.', [mbOk]);
          2:
            AddMessageDialog('您无法携带更多物品了.', [mbOk]);
          3:
            AddMessageDialog(g_sGoldName { '金币' } + '不足.', [mbOk]);
          4:
            AddMessageDialog('你缺乏所必需的物品。', [mbOk]);
        end;
      end;
    SM_716:
      begin
        DrawEffectHum(Msg.series { type } , Msg.Param { x } , Msg.tag { y } );
      end;
    SM_SENDDETAILGOODSLIST:
      begin
        ClientGetSendDetailGoodsList(Msg.Recog, Msg.Param, Msg.tag, body);
      end;

    SM_SENDNOTICE:
      begin
        ClientGetSendNotice(body);
      end;
    SM_GROUPMODECHANGED: // 辑滚俊辑 唱狼 弊缝 汲沥捞 函版登菌澜.
      begin
        SetAllowGroup(Msg.Param > 0);
        g_dwChangeGroupModeTick := GetTickCount;
      end;
    SM_CREATEGROUP_OK:
      begin
        g_dwChangeGroupModeTick := GetTickCount;
        SetAllowGroup(True);
        { GroupMembers.Add (Myself.UserName);
          GroupMembers.Add (EDCode.DecodeString(body)); }
      end;
    SM_CREATEGROUP_FAIL:
      begin
        g_dwChangeGroupModeTick := GetTickCount;
        case Msg.Recog of
          - 1:
            AddMessageDialog('编组还未成立.', [mbOk]);
          -2:
            AddMessageDialog('输入的人物名称不正确.', [mbOk]);
          -3:
            AddMessageDialog('您想邀请加入编组的人已经加入了其它组.', [mbOk]);
          -4:
            AddMessageDialog('对方不允许编组.', [mbOk]);
        end;
      end;
    SM_GROUPADDMEM_OK:
      begin
        g_dwChangeGroupModeTick := GetTickCount;
        // GroupMembers.Add (EDCode.DecodeString(body));
      end;
    SM_GROUPADDMEM_FAIL:
      begin
        g_dwChangeGroupModeTick := GetTickCount;
        case Msg.Recog of
          - 1:
            AddMessageDialog('编组还未成立.', [mbOk]);
          -2:
            AddMessageDialog('输入的人物名称不正确.', [mbOk]);
          -3:
            AddMessageDialog('已经加入编组.', [mbOk]);
          -4:
            AddMessageDialog('对方不允许编组.', [mbOk]);
          -5:
            AddMessageDialog('您想邀请加入编组的人已经加入了其它组！', [mbOk]);
          -6:
            AddMessageDialog('不同国家不允许加入同一队伍！', [mbOk]);
          -7:
            AddMessageDialog('不同阵营不允许加入同一队伍！', [mbOk]);
          -8:
            AddMessageDialog('只有队长才可以邀请其他玩家加入队伍！', [mbOk]);
          -9:
            AddMessageDialog('邀请失败，玩家已加入其他队伍！', [mbOk]);
        end;
      end;
    SM_GROUPDELMEM_OK:
      begin
        g_dwChangeGroupModeTick := GetTickCount;
      end;
    SM_GROUPDELMEM_FAIL:
      begin
        g_dwChangeGroupModeTick := GetTickCount;
        case Msg.Recog of
          - 1:
            AddMessageDialog('编组还未成立.', [mbOk]);
          -2:
            AddMessageDialog('输入的人物名称不正确.', [mbOk]);
          -3:
            AddMessageDialog('此人不在本组中.', [mbOk]);
        end;
      end;
    SM_GROUPCANCEL:
      begin
        g_GroupSelIndex := -1;
        g_ISGroupMaster := False;
        g_GroupMembers.Clear;
        FrmDlg.ReBuildGropuUI;
      end;
    SM_GROUPMEMBERS:
      begin
        ClientGetGroupMembers(Msg, EdCode.DecodeString(body));
      end;

    SM_GUILD_ERROR:
      begin
        case Msg.Recog of
          1:
            AddMessageDialog(Format('玩家[{S=%s;C=251}]已加入其它行会',
              [EdCode.DecodeString(body)]), [mbOk]);
          2:
            AddMessageDialog(Format('玩家[{S=%s;C=251}]拒绝了你的邀请',
              [EdCode.DecodeString(body)]), [mbOk]);
          3:
            AddMessageDialog('加入行会失败', [mbOk]);
          4:
            AddMessageDialog('你已加入了其他行会', [mbOk]);
          5:
            AddMessageDialog('加入行会成功', [mbOk]);
          6:
            AddMessageDialog('你的行会已经满员，无法加入新的成员', [mbOk]);
          7:
            AddMessageDialog(Format('[{S=%s;C=251}]同意了你的请求，行会加入成功',
              [EdCode.DecodeString(body)]), [mbOk]);
          8:
            AddMessageDialog(Format('{S=%s;C=251}拒绝了你的请求',
              [EdCode.DecodeString(body)]), [mbOk]);
          9:
            AddMessageDialog(Format('{S=%s;C=251}不允许邀请加入行会',
              [EdCode.DecodeString(body)]), [mbOk]);
          10:
            AddMessageDialog(Format('不同国家不可加入同一行会', [EdCode.DecodeString(body)]
              ), [mbOk]);
        end;
      end;
    SM_GUILD_INVITE:
      begin
        AddMessageDialog(EdCode.DecodeString(body), [mbOk, mbCancel],
          procedure(AResult: Integer)begin case AResult of mrOK
          : SendClientMessage(CM_GUILD_AGREE, Msg.Recog, 0, 0, 0);
          mrCancel: SendClientMessage(CM_GUILD_REJECT, Msg.Recog, 0, 0, 0);
        end; end);
      end;
    SM_GUILD_REQ:
      begin
        AddMessageDialog(Format('玩家[{S=%s;C=251}]请求加入行会，是否同意？',
          [EdCode.DecodeString(body)]), [mbOk, mbCancel],
          procedure(AResult: Integer)begin case AResult of mrOK
          : SendClientMessage(CM_GUILD_REQAGREE, Msg.Recog, 0, 0, 0);
          mrCancel: SendClientMessage(CM_GUILD_REQREJECT, Msg.Recog, 0, 0, 0);
        end; end);
      end;
    SM_GROUP_INVITE:
      begin
        AddMessageDialog(Format('[{S=%s;C=251}]邀请你加入队伍，是否同意加入？',
          [EdCode.DecodeString(body)]), [mbOk, mbCancel],
          procedure(AResult: Integer)begin case AResult of mrOK
          : SendClientMessage(CM_GROUP_AGREE, Msg.Recog, 0, 0, 0);
          mrCancel: SendClientMessage(CM_GROUP_REJECT, Msg.Recog, 0, 0, 0);
        end; end);
      end;
    SM_GROUP_REQ:
      begin
        AddMessageDialog(Format('玩家[{S=%s;C=251}]请求加入你的队伍.',
          [EdCode.DecodeString(body)]), [mbOk, mbCancel],
          procedure(AResult: Integer)begin case AResult of mrOK
          : SendClientMessage(CM_GROUP_REQAGREE, Msg.Recog, 0, 0, 0);
          mrCancel: SendClientMessage(CM_GROUP_REQREJECT, Msg.Recog, 0, 0,
          0); end; end)
      end;
    SM_GROUP_ERROR:
      begin
        case Msg.Recog of
          1:
            AddMessageDialog(Format('玩家[{S=%s;C=251}]拒绝了你的组队邀请',
              [EdCode.DecodeString(body)]), [mbOk]);
          2:
            AddMessageDialog(Format('玩家[{S=%s;C=251}]拒绝了你的组队申请',
              [EdCode.DecodeString(body)]), [mbOk]);
          3:
            AddMessageDialog(Format('玩家[{S=%s;C=251}]同意了你的组队邀请',
              [EdCode.DecodeString(body)]), [mbOk]);
          4:
            AddMessageDialog(Format('玩家[{S=%s;C=251}]同意了你的组队申请',
              [EdCode.DecodeString(body)]), [mbOk]);
          5:
            AddMessageDialog('队伍成员已满', [mbOk]);
          6:
            AddMessageDialog('已经加入到了队伍当中', [mbOk]);
        end;
      end;
    SM_OPENGUILDDLG:
      begin
        g_dwQueryMsgTick := GetTickCount;
        ClientGetOpenGuildDlg(body);
      end;
    SM_SENDGUILDMEMBERLIST:
      begin
        g_dwQueryMsgTick := GetTickCount;
        ClientGetSendGuildMemberList(body);
      end;

    SM_OPENGUILDDLG_FAIL:
      begin
        g_dwQueryMsgTick := GetTickCount;
        AddMessageDialog('您还没有加入行会.', [mbOk]);
      end;

    SM_QUERYMENUSTATE:
      begin
        BuildActorMenu(Msg);
      end;
    SM_DEALASK:
      begin
        AddMessageDialog(Format('玩家[{S=%s;C=251}]向您发起了交易请求.',
          [EdCode.DecodeString(body)]), [mbOk, mbCancel],
          procedure(AResult: Integer)begin case AResult of mrOK
          : SendClientMessage(CM_AGREEDEAL, Msg.Recog, 0, 0, 0);
          mrCancel: SendClientMessage(CM_REJECTDEAL, Msg.Recog, 0, 0, 0);
        end; end);
      end;
    SM_DEALTRY_FAIL:
      begin
        g_dwQueryMsgTick := GetTickCount;
        case Msg.Recog of
          1:
            AddMessageDialog(Format('不能和[{S=%s;C=251}]进行交易',
              [EdCode.DecodeString(body)]), [mbOk]);
          2:
            AddMessageDialog('无法和自己进行交易', [mbOk]);
          3:
            AddMessageDialog('只能和玩家进行交易', [mbOk]);
          4:
            AddMessageDialog(Format('玩家[{S=%s;C=251}]不能交易',
              [EdCode.DecodeString(body)]), [mbOk]);
          5:
            AddMessageDialog(Format('玩家[{S=%s;C=251}]正在交易中',
              [EdCode.DecodeString(body)]), [mbOk]);
          6:
            AddMessageDialog(Format('玩家[{S=%s;C=251}]拒绝了交易请求',
              [EdCode.DecodeString(body)]), [mbOk]);
          7:
            AddMessageDialog('距离太远，无法执行交易操作', [mbOk]);
          8:
            AddMessageDialog('交易目标不存在，无法执行交易操作', [mbOk]);
        end;
      end;
    SM_DEALMENU:
      begin
        g_dwQueryMsgTick := GetTickCount;
        g_sDealWho := EdCode.DecodeString(body);
        FrmDlg.OpenDealDlg;
      end;
    SM_DEALCANCEL:
      begin
        MoveDealItemToBag;
        if g_DealDlgItem.Name <> '' then
        begin
          AddItemBag(g_DealDlgItem);
          g_DealDlgItem.Name := '';
        end;
        if g_nDealGold > 0 then
        begin
          g_nGold := g_nGold + g_nDealGold;
          g_nDealGold := 0;
        end;
        FrmDlg.CloseDealDlg;
      end;
    SM_DEALADDITEM_OK:
      begin
        g_dwDealActionTick := GetTickCount;
        if g_DealDlgItem.Name <> '' then
        begin
          AddDealItem(g_DealDlgItem);
          // Deal Dlg俊 眠啊
          g_DealDlgItem.Name := '';
        end;
      end;
    SM_DEALADDITEM_FAIL:
      begin
        g_dwDealActionTick := GetTickCount;
        if g_DealDlgItem.Name <> '' then
        begin
          AddItemBag(g_DealDlgItem);
          // 啊规俊 眠啊
          g_DealDlgItem.Name := '';
        end;
      end;
    SM_DEALDELITEM_OK:
      begin
        g_dwDealActionTick := GetTickCount;
        if g_DealDlgItem.Name <> '' then
        begin
          // AddItemBag (DealDlgItem);  //啊规俊 眠啊
          g_DealDlgItem.Name := '';
        end;
      end;
    SM_DEALDELITEM_FAIL:
      begin
        g_dwDealActionTick := GetTickCount;
        if g_DealDlgItem.Name <> '' then
        begin
          DelItemBag(g_DealDlgItem.Name, g_DealDlgItem.MakeIndex);
          AddDealItem(g_DealDlgItem);
          g_DealDlgItem.Name := '';
        end;
      end;
    SM_DEALREMOTEADDITEM:
      ClientGetDealRemoteAddItem(body);
    SM_DEALREMOTEDELITEM:
      ClientGetDealRemoteDelItem(body);
    SM_DEALCHGGOLD_OK:
      begin
        g_nDealGold := Msg.Recog;
        g_nGold := Msg.Param;
        g_dwDealActionTick := GetTickCount;
      end;
    SM_DEALCHGGOLD_FAIL:
      begin
        g_nDealGold := Msg.Recog;
        g_nGold := Msg.Param;
        g_dwDealActionTick := GetTickCount;
      end;
    SM_DEALREMOTECHGGOLD:
      begin
        g_nDealRemoteGold := Msg.Recog;
        g_SoundManager.DXPlaySound(s_money);
      end;
    SM_DEALSUCCESS:
      begin
        FrmDlg.CloseDealDlg;
      end;
    SM_DEALMESSAGE:
      begin
        g_boRDealOK := Msg.series = 2;
        g_boDealOK := Msg.series = 1;
        AddChatBoardString(EdCode.DecodeString(body), GetRGB(219), clWhite);
      end;
    SM_SENDUSERSTORAGEITEM:
      begin
        ClientGetSendUserStorage(Msg.Recog, Msg.tag = 1);
      end;
    SM_READMINIMAP_OK:
      begin
        g_dwQueryMsgTick := GetTickCount;
        ClientGetReadMiniMap(Msg.Param);
      end;
    SM_READMINIMAP_FAIL:
      begin
        g_dwQueryMsgTick := GetTickCount;
        AddChatBoardString('没有可用的小地图.', clWhite, clRed);
        g_nMiniMapIndex := -1;
        g_boMiniMapExpand := False;
        FrmDlg.DBMiniMapImage.visible := False;
      end;
    SM_CHANGEGUILDNAME:
      begin
        ClientGetChangeGuildName(EdCode.DecodeString(body));
      end;
    SM_SENDUSERSTATE:
      begin // 查看别人装备
        g_boUserIsWho := Msg.Recog;
        ClientGetSendUserState(body);
      end;
    SM_GUILDADDMEMBER_OK:
      begin
        SendGuildMemberList;
      end;
    SM_GUILDADDMEMBER_FAIL:
      begin
        case Msg.Recog of
          1:
            AddMessageDialog('你没有权利使用这个命令.', [mbOk]);
          2:
            AddMessageDialog('想加入行会的应该来面对行会掌门人.', [mbOk]);
          3:
            AddMessageDialog('对方已经加入行会.', [mbOk]);
          4:
            AddMessageDialog('对方已经加入其他行会.', [mbOk]);
          5:
            AddMessageDialog('对方不想加入行会.', [mbOk]);
        end;
      end;
    SM_GUILDDELMEMBER_OK:
      begin
        SendGuildMemberList;
      end;
    SM_GUILDDELMEMBER_FAIL:
      begin
        case Msg.Recog of
          1:
            AddMessageDialog('不能使用命令！', [mbOk]);
          2:
            AddMessageDialog('此人非本行会成员！', [mbOk]);
          3:
            AddMessageDialog('行会掌门人不能开除自己！', [mbOk]);
          4:
            AddMessageDialog('不能使用命令Z！', [mbOk]);
        end;
      end;
    SM_GUILDRANKUPDATE_FAIL:
      begin
        case Msg.Recog of
          - 2:
            AddMessageDialog('[提示信息] 掌门人位置不能为空。', [mbOk]);
          -3:
            AddMessageDialog('[提示信息] 新的行会掌门人已经被传位。', [mbOk]);
          -4:
            AddMessageDialog('[提示信息] 一个行会最多只能有二个掌门人。', [mbOk]);
          -5:
            AddMessageDialog('[提示信息] 掌门人位置不能为空。', [mbOk]);
          -6:
            AddMessageDialog('[提示信息] 不能添加成员/删除成员。', [mbOk]);
          -7:
            AddMessageDialog('[提示信息] 职位重复或者出错。', [mbOk]);
        end;
      end;
    SM_GUILDMAKEALLY_OK, SM_GUILDMAKEALLY_FAIL:
      begin
        case Msg.Recog of
          - 1:
            AddMessageDialog('您无此权限！', [mbOk]);
          -2:
            AddMessageDialog('结盟失败！', [mbOk]);
          -3:
            AddMessageDialog('行会结盟必须双方掌门人面对面！', [mbOk]);
          -4:
            AddMessageDialog('对方行会掌门人不允许结盟！', [mbOk]);
          -5:
            AddMessageDialog('不可以和自己的行会结盟！', [mbOk]);
        end;
      end;
    SM_GUILDBREAKALLY_OK, SM_GUILDBREAKALLY_FAIL:
      begin
        case Msg.Recog of
          - 1:
            AddMessageDialog('解除结盟！', [mbOk]);
          -2:
            AddMessageDialog('此行会不是您行会的结盟行会！', [mbOk]);
          -3:
            AddMessageDialog('没有此行会！', [mbOk]);
        end;
      end;
    SM_BUILDGUILD_OK:
      begin
        FrmDlg.LastestClickTime := GetTickCount;
        AddMessageDialog('行会建立成功.', [mbOk]);
      end;
    SM_BUILDGUILD_FAIL:
      begin
        FrmDlg.LastestClickTime := GetTickCount;
        case Msg.Recog of
          - 1:
            AddMessageDialog('您已经加入其它行会。', [mbOk]);
          -2:
            AddMessageDialog('缺少创建费用。', [mbOk]);
          -3:
            AddMessageDialog('你没有准备好需要的全部物品。', [mbOk]);
        else
          AddMessageDialog('创建行会失败！！！', [mbOk]);
        end;
      end;
    SM_MENU_OK:
      begin
        FrmDlg.LastestClickTime := GetTickCount;
        if body <> '' then
        begin
          AMessage := EdCode.DecodeString(body);
          if Pos('/@', AMessage) > 0 then
          begin
            AMessage := GetValidStr3(AMessage, ANode1, ['/']); // 显示的信息
            AMessage := GetValidStr3(AMessage, ANode2, ['/']);
            // Str6触发参数1，data触发参数2
            AddMessageDialog(ANode1, [mbOk, mbCancel],
              procedure(AResult: Integer)begin if AResult = mrOK then begin if
              ANode2 <> '' then begin Msg := MakeDefaultMsg(CM_CLICKSIGHICON, 0,
              0, 0, 0, frmMain.Certification);
              SendSocket(Msg, EdCode.EncodeString(ANode2)); end;
            end else if AMessage <> '' then begin Msg :=
              MakeDefaultMsg(CM_CLICKSIGHICON, 0, 0, 0, 0,
              frmMain.Certification);
              SendSocket(Msg, EdCode.EncodeString(AMessage)); end; end);
          end
          else
            AddMessageDialog(AMessage, [mbOk]);
        end
        else
          AddMessageDialog('', [mbOk]);
      end;
    SM_QUESTION:
      begin
        if body <> '' then
          ClientShowQuestion(EdCode.DecodeString(body));
      end;
    SM_DLGMSG:
      begin
        if body <> '' then
          AddMessageDialog(EdCode.DecodeString(body), [mbOk]);
      end;
    SM_DONATE_OK:
      begin
        FrmDlg.LastestClickTime := GetTickCount;
      end;
    SM_DONATE_FAIL:
      begin
        FrmDlg.LastestClickTime := GetTickCount;
      end;

    SM_NEEDPASSWORD:
      begin
        ClientGetNeedPassword(body);
      end;
    SM_PASSWORDSTATUS:
      begin
        // ClientGetPasswordStatus(@Msg,Body);
      end;
    SM_MEMBERINFO:
      begin
        g_btMemberType := Msg.Recog;
        g_btMemberLevel := Msg.tag;
      end;
    SM_Effect:
      begin
        ClientShowEffect(Msg);
      end;
    SM_CHANGEEFFIGYSTATE:
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if (Actor <> nil) and (Actor is TNpcActor) then
          TNpcActor(Actor).SetEffigyState(Msg.nSessionID, Msg.Param, Msg.tag,
            Msg.series);
      end;
    SM_PLAYSOUND:
      begin
        ClientPlaySound(EdCode.DecodeString(body));
      end;
    SM_PLAYVIDEO:
      begin
        ClientPlayVideo(EdCode.DecodeString(body));
      end;
    SM_SPEEDTIME:
      begin
        ClientSetSpeed(Msg.Param, Msg.tag, Msg.series, Msg.nSessionID);
      end;
    SM_MARKET_NAMELIST:
      begin
        ClientGetStallNameList(Msg.Param, body);
      end;
    SM_MARKET_ITEMS:
      begin
        ClientGetMyItems(body);
      end;
    SM_MARKET_WHOITEMS:
      begin
        ClientGetWhoItems(body);
      end;
    SM_MARKET_PUTON_OK:
      begin
        AddMarketItemToMyMarket(Msg.Recog, Msg.Param, Msg.tag);
        g_MarketItem.Item.Item.Name := '';
        g_boStallLock := False;
      end;
    SM_MARKET_PUTON_FAILD, SM_STALL_PUTON_FAILD:
      begin
        AddItemBag(g_MarketItem.Item.Item);
        case Msg.Recog of
          1:
            AddMessageDialog('物品不存在，上架失败！', [mbOk]); // 不存在物品
          2:
            AddMessageDialog('摊位空间不足，上架失败！', [mbOk]); // 摊位空间不足
          3:
            AddMessageDialog('该物品禁止出售，上架失败！', [mbOk]); // 摊位空间不足
          4:
            AddMessageDialog('绑定物品不可出售，上架失败！', [mbOk]); // 摊位空间不足
          5:
            AddMessageDialog('总价超高，上架失败！,请修改单价。', [mbOk]); // 摊位空间不足
        end;
        g_MarketItem.Item.Item.Name := '';
        g_boStallLock := False;
        g_boPutOn := False;
      end;
    SM_MARKET_PUTOFF_OK:
      begin
        ClearMyMarketItem(Msg.Recog);
        g_MarketItem.Item.Item.Name := '';
        g_boStallLock := False;
      end;
    SM_MARKET_PUTOFF_FAILD, SM_STALL_PUTOFF_FAILD, SM_STALL_PUTOFFBUY_FAILD:
      begin
        case Msg.Recog of
          1:
            AddMessageDialog('摊位不存在，下架失败！', [mbOk]); // 摊位不存在
          2:
            AddMessageDialog('物品不存在，下架失败！', [mbOk]); // 物品不存在
          3:
            AddMessageDialog('包裹空间或负重不足，下架失败！', [mbOk]); // 包裹空间不足
        end;
        g_boStallLock := False;
        if Msg.ident <> SM_MARKET_PUTOFF_FAILD then
          g_boPutOn := False;
      end;
    SM_MARKET_BUY_OK:
      begin
        ClearWhoMarketItemByMoving(Msg.Recog = 0, Msg.Param);
        g_MarketItem.Item.Item.Name := '';
        g_boStallLock := False;
        FrmDlg.MarketItemIndex := -1;
      end;
    SM_MARKET_BUY_FAILD, SM_STALL_BUY_FAILD:
      begin
        g_boStallLock := False;
        case Msg.Recog of
          1:
            AddMessageDialog('包裹空间不足，购买物品失败！', [mbOk]); // 空间不足
          2:
            AddMessageDialog('摊位不存在，购买物品失败！', [mbOk]); // 摊位不存在
          3:
            AddMessageDialog('物品不存在，购买物品失败！', [mbOk]); // 物品不存在
          4:
            AddMessageDialog('资金不足，购买物品失败！', [mbOk]); //
          5:
            AddMessageDialog('购买物品失败！', [mbOk]); //
          6:
            AddMessageDialog('购买物品失败，摊位整理中！', [mbOk]); //
          7:
            begin
              AddMessageDialog('购买物品失败，摊位已刷新！', [mbOk]);
              if g_SelMarketPlay <> '' then
                SendClientMessage(CM_STALL_COMMAND, _STALL_Query, 0, 0, 0,
                  EdCode.EncodeString(g_SelMarketPlay));
            end;
          8:begin
            AddMessageDialog('购买物品失败，摊位无法携带更为金钱！', [mbOk]); //
          end;
        end;
        if Msg.ident = SM_STALL_BUY_FAILD then
          g_boPutOn := False;
      end;
    SM_MARKET_UPDATE_OK:
      begin
        UpdateMyMarketItem(Msg.Param, Msg.tag);
        g_boStallLock := False;
      end;
    SM_MARKET_UPDATE_FAILD, SM_STALL_UPDATE_FAILD, SM_STALL_PUTONBUY_FAILD,
      SM_STALL_UPDATEBUY_FAILD:
      begin
        g_boStallLock := False;
        case Msg.Recog of
          1:
            AddMessageDialog('摊位不存在，更新物品失败！', [mbOk]); //
          2:
            AddMessageDialog('物品不存在，更新物品失败！', [mbOk]); //
          5:
            AddMessageDialog('总价超高，上架失败！,请修改单价。', [mbOk]); // 摊位空间不足
        end;
        if Msg.ident <> SM_MARKET_UPDATE_FAILD then
          g_boPutOn := False;
      end;
    SM_MARKET_EXTRACT:
      begin
        case Msg.Recog of
          1:
            AddMessageDialog('摊位不存在，提取资金失败！', [mbOk]); //
          2:
            AddMessageDialog('摊位资金为零，提取资金失败！', [mbOk]); //
          3:
            AddMessageDialog('可携带资金，提取资金失败！', [mbOk]); // 容量不够
          4:
            begin
              g_SoundManager.DXPlaySound(s_money);
              g_MyMarketGold := 0;
              g_MyMarketGameGold := 0;
              g_nGold := Msg.Param;
              g_dwGameGold := Msg.tag;
            end;
        end;
      end;
    SM_STALL_COMMAND:
      begin
        case Msg.Recog of
          _STALL_Query:
            FrmDlg.OpenLookupStall(body);
        end;
      end;
    SM_STALL_PUTON_OK:
      begin
        AddStallItemToMyStall(Msg.Recog, Msg.Param, Msg.tag);
        g_MarketItem.Item.Item.Name := '';
        g_boStallLock := False;
        g_boPutOn := False;
      end;
    SM_STALL_UPDATE_OK:
      begin
        UpdateMyStallItem(Msg.Param, Msg.tag);
        g_boStallLock := False;
        g_boPutOn := False;
      end;
    SM_STALL_PUTOFF_OK:
      begin
        ClearMyStallItem(Msg.Recog);
        g_MarketItem.Item.Item.Name := '';
        g_boStallLock := False;
        g_boPutOn := False;
      end;
    SM_STALL_PUTONBUY_OK, SM_STALL_UPDATEBUY_OK:
      begin
        AddStallBuyItemToMyStallBuy(Msg.Recog, Msg.Param, Msg.tag, Msg.series);
        g_boStallLock := False;
        g_boPutOn := False;
      end;
    SM_STALL_PUTOFFBUY_OK:
      begin
        ClearMyStallBuyItem(Msg.Recog);
        g_MarketItem.Item.Item.Name := '';
        g_boStallLock := False;
        g_boPutOn := False;
      end;
    SM_STALL_STATEChanged:
      begin
        if Msg.Recog = 0 then
        begin
          FrmDlg.DWStallWinCtrl.Visible := True;
          FrmDlg.DWStallStop.Visible := False;
          FrmDlg.DWStallWinGetGold.Visible := True;
        end
        else
        begin
          FrmDlg.DWStallWinCtrl.Visible := False;
          FrmDlg.DWStallStop.Visible := True;
          FrmDlg.DWStallWinGetGold.Visible := False;
          g_MyStallGold := Msg.Param;
          g_MyStallGameGold := Msg.tag;
          g_MySelf.m_btDir := 5;
          g_StallLogs.Clear;
        end;
        g_boPutOn := False;
      end;
    SM_STALL_BUY_OK:
      begin
        ClearWhoStallItemByMoving(Msg.Recog = 0, Msg.Param);
        g_MarketItem.Item.Item.Name := '';
        g_boStallLock := False;
        FrmDlg.MarketItemIndex := -1;
        g_QueryStallLogs.Add(EdCode.DecodeString(body));
        g_boPutOn := False;
      end;
    SM_STALL_EXTRACT:
      begin
        case Msg.Recog of
          1:
            AddMessageDialog('摊位不存在，提取资金失败！', [mbOk]); //
          2:
            AddMessageDialog('摊位资金为零，提取资金失败！', [mbOk]); //
          3:
            AddMessageDialog('可携带资金，提取资金失败！', [mbOk]); // 容量不够
          4:
            begin
              g_SoundManager.DXPlaySound(s_money);
              g_MyStallGold := 0;
              g_MyStallGameGold := 0;
            end;
        end;
        g_boPutOn := False;
      end;
    SM_STALL_GETBACK_INFOR:
      begin
        case Msg.Recog of
          1:
            AddMessageDialog(Format('包裹已满或负重不足，摊位仍有%d个物品待提取', [Msg.Param]),
              [mbOk]); //
        end;
        g_boPutOn := False;
      end;
    SM_STALL_AddMessageOK:
      begin
        FrmDlg.AddStallQueryLog(EdCode.DecodeString(body));
        g_boPutOn := False;
      end;
    SM_STALL_START_FAILD:
      begin
        case Msg.Recog of
          1:
            AddMessageDialog('摆摊失败：资金不足以预付收购物品！', [mbOk]); //
          2:
            AddMessageDialog('摆摊失败：摊位没有需要出售或收购的物品！', [mbOk]); //
          3:
            AddMessageDialog('摆摊失败：当前地图不允许摆摊！', [mbOk]); //
          4:
            AddMessageDialog('摆摊失败：当前地图只允许在安全区摆摊！', [mbOk]); //
        end;
        g_boPutOn := False;
      end;
    SM_STALL_SALETOBUY_OK:
      begin
        UpdateQueryStallItemBuy(Msg.Recog, Msg.Param);
        g_QueryStallLogs.Add(EdCode.DecodeString(body));
        g_boStallLock := False;
        g_boPutOn := False;
      end;
    SM_STALL_SALETOBUY_FAILD:
      begin
        AddItemBag(g_MarketItem.Item.Item);
        g_boStallLock := False;
        g_boPutOn := False;
        case Msg.Recog of
          1:
            AddMessageDialog('出售物品失败：摊位整理中！', [mbOk]); //
          3:
            AddMessageDialog('出售物品失败：物品不存在！', [mbOk]); //
          4:
            AddMessageDialog('出售物品失败：物品不匹配！', [mbOk]); //
          5:
            AddMessageDialog('出售物品失败：数量超过对方收购数量！', [mbOk]); //
          6:
            AddMessageDialog('出售物品失败：对方资金不足！', [mbOk]); //
          7:
            AddMessageDialog('出售物品失败：你无法携带更多的金币了！', [mbOk]); //
          9:
            begin
              AddMessageDialog('出售物品失败，摊位已刷新！', [mbOk]);
              if g_SelMarketPlay <> '' then
                SendClientMessage(CM_STALL_COMMAND, _STALL_Query, 0, 0, 0,
                  EdCode.EncodeString(g_SelMarketPlay));
            end;
        end;
      end;
    SM_STALL_UPDATED:
      begin
        g_boPutOn := False;
        if FrmDlg.DWStallWin.Visible then
          frmMain.SendShortCut(_SC_UPDATESTALL);
      end;
    {
      SM_MARKET_BUY_OK:
      begin
      ClearWhoStallItemByMoving(Msg.Recog = 0, Msg.Param);
      g_MarketItem.Item.Item.Name := '';
      g_boStallLock := False;
      FrmDlg.MarketItemIndex := -1;
      end;
      SM_MARKET_EXTRACT:
      begin
      case Msg.Recog of
      1: AddMessageDialog('摊位不存在，提取资金失败！', [mbOk]); //
      2: AddMessageDialog('摊位资金为零，提取资金失败！', [mbOk]); //
      3: AddMessageDialog('可携带资金，提取资金失败！', [mbOk]); // 容量不够
      4:
      begin
      g_SoundManager.DXPlaySound(s_money);
      g_MyMarketGold := 0;
      g_MyMarketGameGold := 0;
      g_nGold := Msg.param;
      g_dwGameGold := Msg.tag;
      end;
      end;
      end;
    }
    SM_CLIENTDATA_COMMAND:
      begin
        g_ClientDataTempString := g_ClientDataTempString + body;
        // 表示分包完结
        if Msg.Param = 1 then
        begin
          case Msg.Recog of
            CD_CLIENTDATA_ITEMS:
              ClientParseItems(g_ClientDataTempString);
            CD_CLIENTDATA_ITEMSDSC:
              ClientParseItemsDesc(g_ClientDataTempString);
            CD_CLIENTDATA_SUITES:
              ClientParseSuites(g_ClientDataTempString);
            CD_CLIENTDATA_MAP:
              ClientParseMap(g_ClientDataTempString);
            CD_CLIENTDATA_UI:
              ClientParseUI(g_ClientDataTempString);
            CD_CLIENTDATA_TYPENAMES:
              ClientParseTypeNames(g_ClientDataTempString);
            CD_CLIENTDATA_MAGICS:
              ClientParseMagics(g_ClientDataTempString);
            CD_CLIENTDATA_MAGICDESC:
              ClientParseMagicDesc(g_ClientDataTempString);
            CD_CLIENTDATA_VERCHECK:
              ClientCheckDBVer(Msg.Param,
                EdCode.DecodeString(g_ClientDataTempString));
            CD_CLIENTDATA_ITEMWAY:
              ClientParseItemWay(g_ClientDataTempString);
            CD_CLIENTDATA_ACTORACTION:
              ClientCustomActorAction(g_ClientDataTempString);
            CD_CLIENTDATA_SKILLCONFIG:
              ClientParseSkill(g_ClientDataTempString);
            CD_CLIENTDATA_SKILLEFFECTCONFIG:
              ClientParseSkillEffeect(g_ClientDataTempString);

          end;
          g_ClientDataTempString := '';
        end;
      end;
    SM_CLIENTEXTENDBUTTON:
      begin
        case Msg.Recog of
          1:
            AddExtendButton(Msg.Param, body, Msg.tag = 1,Msg.Series,Msg.nSessionID);
          2:
            RemoveExtendButton(body);
        end;
      end;
    SM_CLIENTACTION:
      begin
        case Msg.Recog of
          CA_OPENBAG:
            FrmDlg.OpenBag;
          CA_OPENMARKET:
            FrmDlg.OpenMarket;
          CA_OPENSHOP:
            FrmDlg.OpenShop;
          CA_OPENMAILBOX:
            FrmDlg.OpenMailBox;
          CA_RELOADBAG:
            FrmDlg.ReloadBagItems;
          CA_OPENMAILVIEW:
            FrmDlg.OpenMailView;
          CA_OPENREFINEBOX:
            FrmDlg.OpenRefineBox;
          CA_OPENSTALL:
            FrmDlg.OpenMyStall(body);
        end;
      end;
    SM_SHOWGATE:
      begin
        Event := TClEffectEvent.Create(Msg.Recog, Msg.tag, Msg.series,
          Msg.Param);
        EventMan.AddEvent(Event);
      end;
    SM_HIDEGATE:
      begin
        EventMan.DelEventById(Msg.Recog);
      end;
    SM_SHOWPROGRESS:
      begin
        FrmDlg.ShowProgress(EdCode.DecodeString(body), Round(Msg.Recog));
      end;
    SM_CLOSEPROGRESS:
      begin
        FrmDlg.CloseProgress;
      end;
    SM_RELATION:
      ClientGetReletions(Msg.Recog, body);
    SM_CHANGESTATE:
      begin
        case Msg.Recog of
          STATE_ALLOWGROUP:
            SetAllowGroup(Msg.Param = 1);
          STATE_ALLOWGUILD:
            g_boAllowGuild := Msg.Param = 1;
          STATE_ALLOWGUILDRECALL:
            g_boAllowGuildRecall := Msg.Param = 1;
          STATE_ALLOWGROUPRECALL:
            g_boAllowGroupRecall := Msg.Param = 1;
          STATE_ALLOWDEAL:
            g_boAllowDeal := Msg.Param = 1;
          STATE_ALLOWRELIVE:
            g_boAllowReAlive := Msg.Param = 1;
          STATE_ALLOWFASHION:
            g_boShowFashion := Msg.Param = 1;
        end;
      end;
    SM_CHANGESPEED:
      begin
        ChangeClientSpeed(Msg.Recog);
      end;
    SM_EMAIL:
      begin
        case Msg.Recog of
          _MAIL_UNREADCOUNT:
            AddChatBoardString(Format('【邮件】你有%d封未读邮件...', [Msg.Param]),
              clWhite, clBlue);
          _MAIL_OPEN:
            FrmDlg.OpenMailBox;
          _MAIL_LIST:
            ReadMailList(body);
          _MAIL_DATA:
            ReadMailData(body);
          _MAIL_NEW:
            ReadNewMailData(body);
          _MAIL_DELSUC:
            g_Mail.DeleteByMainIndex(Msg.Param);
          _MAIL_DELFAIL:
            ;
          _MAIL_EXTRACTSUC:
            begin
              g_Mail.UpdateState(Msg.Param, 2);
            end;
          _MAIL_EXTRACTFAIL:
            begin
              case Msg.Param of
                _MAIL_EXTRACTFAIL_EXTRACTED:
                  g_Application.AddMessageDialog('你已提取过当前附件，不可重复提取！', [mbOk]);
                _MAIL_EXTRACTFAIL_BAGFULL:
                  g_Application.AddMessageDialog('你的背包空间不足！', [mbOk]);
                _MAIL_EXTRACTFAIL_GOLDFULL:
                  ;
                _MAIL_EXTRACTFAIL_NOBUYGOLD:
                  begin
                    case Msg.tag of
                      0:
                        g_Application.AddMessageDialog
                          (Format('费用不足，提取当前附件需要支付 {S=%d %s;C=249} ！',
                          [Msg.series, g_sGoldName]), [mbOk]);
                      1:
                        g_Application.AddMessageDialog
                          (Format('费用不足，提取当前附件需要支付 {S=%d %s;C=249} ！',
                          [Msg.series, g_sGameGoldName]), [mbOk]);
                      2:
                        g_Application.AddMessageDialog
                          (Format('费用不足，提取当前附件需要支付 {S=%d %s;C=249} ！',
                          [Msg.series, g_sGamePointName]), [mbOk]);
                    end;
                  end;
              end;
            end;
          _MAIL_NEW_SUC:
            begin
              FrmDlg.ClearMailWriter;
              g_Application.AddMessageDialog('邮件发送成功', [mbOk]);
            end;
          _MAIL_NEW_FAIL:
            begin
              case Msg.Param of
                _MAIL_NEW_FAIL_NOITEM:
                  g_Application.AddMessageDialog('要发送的物品附件不存在！', [mbOk]);
                _MAIL_NEW_FAIL_PRICE:
                  begin
                    case Msg.tag of
                      0:
                        g_Application.AddMessageDialog
                          (Format('邮资不足，发送邮件需要支付 {S=%d %s;C=249} ！',
                          [Msg.series, g_sGoldName]), [mbOk]);
                      1:
                        g_Application.AddMessageDialog
                          (Format('邮资不足，发送邮件需要支付 {S=%d %s;C=249} ！',
                          [Msg.series, g_sGameGoldName]), [mbOk]);
                      2:
                        g_Application.AddMessageDialog
                          (Format('邮资不足，发送邮件需要支付 {S=%d %s;C=249} ！',
                          [Msg.series, g_sGamePointName]), [mbOk]);
                    end;
                  end;
                _MAIL_NEW_FAIL_ITEMNOEX:
                  g_Application.AddMessageDialog('不可发送禁止交易的物品附件！', [mbOk]);
                _MAIL_NEW_FAIL_ITEMBIND:
                  g_Application.AddMessageDialog('不可发送绑定的物品附件！', [mbOk]);
                _MAIL_NEW_FAIL_GOLD:
                  g_Application.AddMessageDialog('没有足够的' + g_sGoldName +
                    '可供发送！', [mbOk]);
                _MAIL_NEW_FAIL_GAMEGOLD:
                  g_Application.AddMessageDialog('没有足够的' + g_sGameGoldName +
                    '可供发送！', [mbOk]);
                _MAIL_NEW_FAIL_GAMEPOINT:
                  g_Application.AddMessageDialog('没有足够的' + g_sGamePointName +
                    '可供发送！', [mbOk]);
                _MAIL_NEW_FAIL_QF:
                  ;
              end;
            end;
          _MAIL_GOLDADD:
            ReadMailGoldAdd(Msg.Param, Msg.tag, Msg.series, body);
        end;
      end;
    SM_BUFFERADDED:
      begin
        FrmDlg.AddOrUpdateBufferControl(Msg.Param, Msg.tag, Msg.series, '');
      end;
    SM_BUFFEREMOVED:
      begin
        FrmDlg.RemoveBufferControl(Msg.Param);
      end;
    SM_COLLECT:
      begin
        case Msg.Recog of
          _COLLECT_SUCCESS:
            begin
              g_CollectCret := PlayScene.FindActor(Msg.Param);
              if g_CollectCret <> nil then
              begin
                g_CollectTime := Msg.tag * 1000;
                g_CollectTick := GetTickCount + g_CollectTime;
              end;
              Exit;
            end;
          _COLLECT_SUSPEND:
            AddChatBoardString('采集被中断', clWhite, clRed);
          _COLLECT_FINISH:
            AddChatBoardString('采集完成', clWhite, clRed);
          _COLLECT_FAILD_DEATH:
            AddChatBoardString('目标已经死亡', clWhite, clRed);
          _COLLECT_FAILD_SLOW:
            AddChatBoardString('你动作太慢了', clWhite, clRed);
        end;
        if g_CollectCret <> nil then
        begin
          g_CollectCret := nil;
          g_CollectTick := 0;
          g_CollectTime := 0;
        end;
      end;
    SM_SNEAKSTATE:
      begin
        Actor := PlayScene.FindActor(Msg.Recog);
        if Actor <> nil then
        begin
          Actor.m_boInSneak := Msg.Param = 1;
        end;
      end;
    SM_FLASHWINDDOW:
      begin
        Windows.FlashWindow(Handle, False);
      end;
    SM_QUERYSORT:
      begin
        g_Orders.Read(Msg.Recog, Msg.Param, Msg.tag, Msg.series, body);
        FrmDlg.SetRankListViewData(g_Orders);
      end;
    SM_MISSIONLIST:
      LoadMissionsDoing(body);
    SM_MISSIONLINKS:
      LoadMissionsLink(body);
    SM_ADDMISSION:
      AddMission(body);
    SM_DELETEMISSION:
      DeleteMission(EdCode.DecodeString(body));
    SM_UPDATEMISSION:
      UpdateMission(body);
    SM_ADDMISSIONLINK:
      AddMissionLink(body);
    SM_DELMISSIONLINK:
      DeleteMissionLink(EdCode.DecodeString(body));
    SM_LOCKMOVEITEM:
      SetLockMoveItem(Msg.Recog, Msg.Param);
    SM_PLAYDICE:
      FrmDlg.StartDice(Msg.Recog, Msg.Param, Msg.tag, Msg.series);
    SM_CLOSEDICE:
      FrmDlg.DWDice.Visible := False;
    SM_SIDEBUTTONCommand:
      begin
        case Msg.Recog of
          1:
            begin
              ANode2 := GetValidStr3(body, ANode1, ['/']);
              FrmDlg.AddSideBarButton(EdCode.DecodeString(ANode1),
                EdCode.DecodeString(ANode2));
            end;
          2:
            FrmDlg.DeleteSideBarButton(EdCode.DecodeString(body));
          3:
            FrmDlg.ClearSideBarButtons;
        end;
      end;
    SM_SETCHATTEXT:
      begin
        SetDFocus(FrmDlg.DEChat);
        PlayScene.SetChatText(EdCode.DecodeString(body));
      end;
    SM_FunctionState:
      begin
        InitFunctionFlag(Msg.Recog);
      end;
    SM_CHARDESC:
      begin
        ActorCharDescChange(Msg, body);
      end;
    SM_StartBeCool:
      begin
        StartBeCool(Msg.Recog = 0);
      end;
    SM_CLIENTCHECKFLAG:
      begin
        g_SendSpeedTick := GetTickCount + Msg.Recog * 1000;
      end;
    SM_CLIENTCHECKFLAG_FAIL:
      begin
        VMProtectBeginUltra('SM_CLIENTCHECKFLAG_FAIL');
       // ShowMessage('发现超速服务端强制离线');
        g_MySelf := Pointer($FF29831F);
        VMProtectEnd;
      end;
    SM_LockClientState:
     begin
       FrmDlg.ShowLockClientWindows(Msg.Recog = 1,EdCode.DeCodeString(body));
     end;
     SM_LOADCLIENTUI:
     begin
       ANode1 := ExtractFilePath(ParamStr(0)) +'\' +  ResourceDir + EdCode.DecodeString(body) ;
       g_DWinMan.LoadFromFile(ANode1,True);
       g_DWinMan.LoadFromFile(ANode1,False);
     end;
     SM_TITLEEFFECTARRAY:
     begin
       ANode1 := EdCode.DeCodeString(body);
       ClientGetActorTitleEffects(Msg.Recog,ANode1);
     end;
     SM_SETCLIENTUPPROPERTY:
     begin
       ANode1 := EdCode.DeCodeString(body);
       ANode2 := GetValidStr3(ANode1, ANode1, ['\']);
       OnGetUIProperty(ANode1,ANode2);
     end
  else { TODO -o随云 -c通讯系统 : 处理服务端消息结尾 }
    begin
{$IFDEF DEBUG}

      uLog.TLogger.AddLog
        (Format('收到没处理的数据>>Ident:%d Recog:%d Param:%d Tag:%d Series:%d nSessionID:%d nToken:%d',
        [Msg.ident, Msg.Recog, Msg.Param, Msg.tag, Msg.series, Msg.nSessionID,
        Msg.nToken]));
{$ENDIF}
    end;
  end;
end;

{$IFDEF DEVMODE}
function TfrmMain.DirectionKeyDown(K: Integer): Boolean;
begin
  Result := False;
  if g_DWinMan.DragMode = false then
    Exit;

  if DWinCtl.SeletedControl <> nil then
  begin
    if GetAsyncKeyState(VK_CONTROL) = 0 then
    begin
      Result := True;
      case K of
        VK_LEFT:
          begin
            DWinCtl.SeletedControl.Left := DWinCtl.SeletedControl.Left - 1;
            if Assigned(OnControlPostionChange) then
              OnControlPostionChange(SeletedControl);
          end;
        VK_RIGHT:
          begin
            DWinCtl.SeletedControl.Left := DWinCtl.SeletedControl.Left + 1;
            if Assigned(OnControlPostionChange) then
              OnControlPostionChange(SeletedControl);
          end;
        VK_UP:
          begin
            DWinCtl.SeletedControl.Top := DWinCtl.SeletedControl.Top - 1;
            if Assigned(OnControlPostionChange) then
              OnControlPostionChange(SeletedControl);
          end;
        VK_DOWN:
          begin
            DWinCtl.SeletedControl.Top := DWinCtl.SeletedControl.Top + 1;
            if Assigned(OnControlPostionChange) then
              OnControlPostionChange(SeletedControl);
          end;
      end;
    end;
  end;

end;
{$ENDIF}

procedure TfrmMain.DisConnect;
begin
  CSocket.Close;
end;

procedure TfrmMain.ProcessDialogs;
var
  AResult: TModalResult;
begin
  if not g_boDialog and (FLastDialogItem = nil) then
  begin
    if FDlgMessageList.count > 0 then
    begin
      FLastDialogItem := FDlgMessageList[0];
      FDlgMessageList.Delete(0);
      if FLastDialogItem <> nil then
      begin
        try
          AResult := FrmDlg.DMessageDlg(FLastDialogItem.Text,
            FLastDialogItem.Buttons);
          if Assigned(FLastDialogItem.Handler) then
            FLastDialogItem.Handler(AResult);
        finally
          FreeMem(FLastDialogItem);
          FLastDialogItem := nil;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.ClientGetPasswdSuccess(const body: PPlatfromString);
var
  str, ASelAddr, ASelPort, ACertifystr: String;
begin
  str := EdCode.DecodeString(body);
  str := GetValidStr3(str, ASelAddr, ['/']);
  str := GetValidStr3(str, ASelPort, ['/']);
  str := GetValidStr3(str, ACertifystr, ['/']);
  str := GetValidStr3(str, SessionID, ['/']);
  Certification := Str_ToInt(ACertifystr, 0);

  FrmDlg.DSelServerDlg.Visible := False;
  LoadStdItems;
  LoadStdItemsDesc;
  LoadItemTypeNames;
  LoadSuitItems;
  LoadUI;
  LoadMapDesc;
  LoadItemWay;
  LoadCustomActorAction;
  LoadSkillData();
  LoadSkillEffectData();
  g_MagicMgr.LoadFromFile;
  g_MagicMgr.LoadDescFromFile;
  FrmDlg.InitUIPak;
  g_ConnectionStep := cnsSelChr;
  g_sSelChrAddr := ASelAddr;
  g_nSelChrPort := StrToIntDef(ASelPort, 0);
  SocketOpen(g_sSelChrAddr, g_nSelChrPort);
end;

procedure TfrmMain.ClientGetPasswordOK(Msg: TDefaultMessage;
  const sBody: PPlatfromString);
var
  i: Integer;
  sData, sServerName: String;
  sServerStatus: String;
  nCount: Integer;
begin
  sData := EdCode.DecodeString(sBody);
  nCount := _MIN(6, Msg.series);
  g_Servers.Clear;
  if nCount > 0 then // 20080629
    for i := 0 to nCount - 1 do
    begin
      sData := GetValidStr3(sData, sServerName, ['/']);
      sData := GetValidStr3(sData, sServerStatus, ['/']);
      g_Servers.AddObject(sServerName, TObject(Str_ToInt(sServerStatus, 0)));
    end;

  g_wAvailIDDay := Loword(Msg.Recog);
  g_wAvailIDHour := Hiword(Msg.Recog);
  g_wAvailIPDay := Msg.Param;
  g_wAvailIPHour := Msg.tag;

  if g_wAvailIDDay > 0 then
  begin
    if g_wAvailIDDay = 1 then
      AddMessageDialog('您当前ID费用到今天为止。', [mbOk])
    else if g_wAvailIDDay <= 3 then
      AddMessageDialog('您当前IP费用还剩 ' + IntToStr(g_wAvailIDDay) + ' 天。', [mbOk]);
  end
  else if g_wAvailIPDay > 0 then
  begin
    if g_wAvailIPDay = 1 then
      AddMessageDialog('您当前IP费用到今天为止。', [mbOk])
    else if g_wAvailIPDay <= 3 then
      AddMessageDialog('您当前IP费用还剩 ' + IntToStr(g_wAvailIPDay) + ' 天。', [mbOk]);
  end
  else if g_wAvailIPHour > 0 then
  begin
    if g_wAvailIPHour <= 100 then
      AddMessageDialog('您当前IP费用还剩 ' + IntToStr(g_wAvailIPHour) +
        ' 小时。', [mbOk]);
  end
  else if g_wAvailIDHour > 0 then
  begin
    AddMessageDialog('您当前ID费用还剩 ' + IntToStr(g_wAvailIDHour) + ' 小时。', [mbOk]);;
  end;

  if not LoginScene.m_boUpdateAccountMode then
    ClientGetSelectServer;
end;

procedure TfrmMain.ClientGetSelectServer;
begin
  LoginScene.HideLoginBox;
  FrmDlg.ShowSelectServerDlg;
end;

procedure TfrmMain.ClientGetNeedUpdateAccount(const body: PPlatfromString);
var
  ue: TUserEntry;
begin
  DecodeBuffer(body, @ue, SizeOf(TUserEntry));
  LoginScene.UpdateAccountInfos(ue);
end;

procedure TfrmMain.ClientGetReceiveChrs(MaxChr: Integer;
  const body: PPlatfromString);
var
  i, select: Integer;
  sJobs, str, uname, sjob, shair, slevel, ssex: string;
  nJobs: Integer;
begin
  SelectChrScene.ClearChrs;
  str := EdCode.DecodeString(body);
  str := GetValidStr3(str, sJobs, ['>']);
  nJobs := StrToIntDef(sJobs, 31 { All jobs } );
  g_ServerJobs := [];
  for i := 0 to SizeOf(TIntegerSet) * 8 - 1 do
  begin
    if i in TIntegerSet(nJobs) then
    begin
      Include(g_ServerJobs, TChrJob(i));
    end;
  end;
  select := 0;
  i := 0;
  while True do
  begin
    str := GetValidStr3(str, uname, ['/']);
    str := GetValidStr3(str, sjob, ['/']);
    str := GetValidStr3(str, shair, ['/']);
    str := GetValidStr3(str, slevel, ['/']);
    str := GetValidStr3(str, ssex, ['/']);
    if (uname <> '') and (slevel <> '') and (ssex <> '') then
    begin
      if uname[1] = '*' then
      begin
        select := i;
        uname := Copy(uname, 2, Length(uname) - 1);
      end;
      SelectChrScene.AddChr(uname, Str_ToInt(sjob, 0), Str_ToInt(shair, 0),
        Str_ToInt(slevel, 0), Str_ToInt(ssex, 0));
    end
    else
      Break;
    Inc(i);
    if str = '' then
      Break;
  end;
  SelectChrScene.SelectChr(select,false);
  SelectChrScene.SetMaxChrCount(MaxChr);
  FrmDlg.DscPriorPage.Enabled := SelectChrScene.PageIndex > 1;
  FrmDlg.DscNextPage.Enabled := SelectChrScene.PageIndex <
    SelectChrScene.MaxPage;

  SelectChrScene.InitChrPage(SelectChrScene.PageIndex);



  FBeijTime := '';
  TThread.CreateAnonymousThread( procedure var S: String;
  begin
     GetBeijTime(S);
    FBeijTime := uEDCode.EncodeString(S,
    uEDCode.DecodeSource
    ('b+rr+Xf6zX0OCoMQPjXg3gvgwmImLc+Ca9iz5GJmRUsSUuVrxHFL+qMrOgUVYPdW5WoggdvY')
    );
  end).Start;
end;

procedure TfrmMain.ClientGetStallNameList(count: Integer;
  const List: PPlatfromString);
var
  LS: TAnsiStrings;
  i: Integer;
  AName, AStallName: String;
begin
  g_MarketNames.Clear;
  g_MarketPlays.Clear;
  LS := TAnsiStringList.Create;
  try
    StrIToStrings(List, '/', LS);
    for i := 0 to (LS.count div 2) - 1 do
    begin
      AName := EdCode.DecodeString(LS.Strings[i * 2]);
      AStallName := EdCode.DecodeString(LS.Strings[i * 2 + 1]);
      g_MarketPlays.Add(AName);
      g_MarketNames.Add(AStallName);
    end;
    FrmDlg.ISMarketList := True;
  finally
    FreeAndNilEx(LS);
  end;
end;

procedure TfrmMain.ClientGetMyItems(const List: PPlatfromString);
var
  LS: TAnsiStrings;
  i: Integer;
  AStallItem: TClientStallItem;
begin
  FillChar(g_WhoStall, SizeOf(g_MyMarket), #0);
  LS := TAnsiStringList.Create;
  try
    StrIToStrings(List, '/', LS);
    g_MyMarketGold := 0;
    g_MyMarketGameGold := 0;
    for i := 0 to 11 do
      g_MyMarket[i].Item.Name := '';
    if LS.count >= 3 then
    begin
      g_MyMarketName := EdCode.DecodeString(LS.Strings[0]);
      g_MyMarketGold := StrToIntDef(LS.Strings[1], 0);
      g_MyMarketGameGold := StrToIntDef(LS.Strings[2], 0);
      for i := 3 to LS.count - 1 do
      begin
        EdCode.DecodeBuffer(LS.Strings[i], @AStallItem,
          SizeOf(TClientStallItem));
        g_MyMarket[AStallItem.Index] := AStallItem;
      end;
    end;
    FrmDlg.SetMarketTabIndex(1);
  finally
    FreeAndNilEx(LS);
  end;
end;

procedure TfrmMain.ClientGetWhoItems(const List: PPlatfromString);
var
  LS: TAnsiStrings;
  i: Integer;
  AStallItem: TClientStallItem;
begin
  FillChar(g_WhoStall, SizeOf(g_WhoStall), #0);
  LS := TAnsiStringList.Create;
  try
    for i := 0 to 11 do
      g_WhoStall[i].Item.Name := '';
    StrIToStrings(List, '/', LS);
    for i := 0 to LS.count - 1 do
    begin
      EdCode.DecodeBuffer(LS.Strings[i], @AStallItem, SizeOf(TClientStallItem));
      g_WhoStall[AStallItem.Index] := AStallItem;
    end;
    FrmDlg.ISMarketList := False;
    FrmDlg.SetMarketTabIndex(0);
  finally
    FreeAndNilEx(LS);
  end;
end;

procedure TfrmMain.ClientParseItems(const Value: AnsiString);
var
  sData: AnsiString;
  Stream: TMemoryStream;
  StdItem: pTStdItem;
begin
  try
    g_ItemVer := Copy(Value, 1, 16);
    sData := Copy(Value, 18, Length(Value) - 17);
    Stream := TMemoryStream.Create;
    g_boLockUpdate := True;
    try
      LoadStreamFromString(sData, Stream);
      ClearItems;
      Stream.Seek(0, soFromBeginning);
      New(StdItem);
      StdItem.Name := g_sGoldName;
      StdItem.Index := 0;
     // StdItem.Bind := 0;
      StdItem.State.ShowNameClient := True;
      StdItem.State.AutoPickUp := True;
//      AddSetValue(StdItem.Bind, 6);
//      AddSetValue(StdItem.Bind, 8);
      StdItem.CustomEff := 0;
      StdItem.StdMode := 254;
      g_ItemList.Add(StdItem);
      while Stream.Position < Stream.Size do
      begin
        New(StdItem);
        Stream.ReadBuffer(StdItem^, SizeOf(TStdItem));
        g_ItemList.Add(StdItem);
      end;
      SaveStdItems;
      AssistantForm.ClearFilter;
      g_Config.LoadFilters;

      SendClientMessage(CM_QUERYBAGITEMS, 1, 0, 0, 0);
      SendClientMessage(CM_QUERYUSEITEMS, 0, 0, 0, 0);
    finally
      FreeAndNilEx(Stream);
      g_boLockUpdate := False;
    end;
  except
    on E: Exception do
      uLog.TLogger.AddLog('ParseItems:' + E.Message);
  end;
end;

procedure TfrmMain.ClientParseItemsDesc(const Value: AnsiString);
var
  sData: AnsiString;
  Stream: TStringStream;
begin
  try
    g_ItemVer := Copy(Value, 1, 16);
    sData := Copy(Value, 18, Length(Value) - 17);
    Stream := TStringStream.Create;
    g_boLockUpdate := True;
    try
      g_ItemDesc.Clear;
      LoadStreamFromString(sData, Stream);
      Stream.Seek(0, soFromBeginning);
      g_ItemDesc.Text := Stream.DataString;
      g_ItemDesc.Insert(0, '');
      SaveStdItemsDesc;
    finally
      FreeAndNilEx(Stream);
      g_boLockUpdate := False;
    end;
  except
    on E: Exception do
      uLog.TLogger.AddLog('ParseItemsD:' + E.Message);
  end;
end;

procedure TfrmMain.ClientParseItemWay(const Value: AnsiString);
var
  sData: AnsiString;
  SName, SValue: String;
  Stream: TStringStream;
  List: TStrings;
  i: Integer;
begin
  try
    g_ItemWayVer := Copy(Value, 1, 16);
    sData := Copy(Value, 18, Length(Value) - 17);
    Stream := TStringStream.Create;
    g_boLockUpdate := True;
    List := TStringList.Create;
    try
      g_ItemWay.Clear;
      LoadStreamFromString(sData, Stream);
      Stream.Seek(0, soFromBeginning);
      List.Text := Stream.DataString;
      for i := 0 to List.count - 1 do
      begin
        SValue := GetValidStr3(List.Strings[i], SName, ['=']);
        if (SName <> '') and (SValue <> '') and
          (StrToIntDef(SName, 0) IN [0 .. 255]) then
          g_ItemWay.AddOrSetValue(StrToInt(SName), Trim(SValue));
      end;
      SaveItemWay;
    finally
      FreeAndNilEx(Stream);
      FreeAndNilEx(List);
      g_boLockUpdate := False;
    end;
  except
    on E: Exception do
      uLog.TLogger.AddLog('ParseTypes:' + E.Message);
  end;
end;

procedure TfrmMain.ClientCustomActorAction(const Value: AnsiString);
var
  sData: AnsiString;
  SName, SValue: String;
  Stream: TMemoryStream;
  List: TStrings;
  i: Integer;
begin
  try
    g_CustomActorActionVer := Copy(Value, 1, 16);
    sData := Copy(Value, 18, Length(Value) - 17);
    g_boLockUpdate := True;
    Stream := TMemoryStream.Create;
    try
      LoadStreamFromString(sData, Stream);
      Stream.saveToFile('D:\customMyActior.xml');
      g_CustomActorAction.Clear;
      NativeXmlObjectStorage.ObjectLoadFromXmlStream(g_CustomActorAction, Stream);
      SaveCustomActorAction;
      InitCustomAction();
    finally
      FreeAndNilEx(Stream);
      g_boLockUpdate := False;
    end;
  except
    on E: Exception do
      uLog.TLogger.AddLog('ParseCustomActorAction:' + E.Message);
  end;
end;

procedure TfrmMain.ClientParseUI(const Value: AnsiString);
var
  sData: AnsiString;
  Stream: TMemoryStream;
begin
  try
    Stream := TMemoryStream.Create;
    try
      g_UIVer := Copy(Value, 1, 16);
      g_boLockUpdate := True;
      sData := Copy(Value, 18, Length(Value) - 17);
      LoadStreamFromString(sData, Stream);
      Stream.Seek(0, soFromBeginning);
      g_UIManager.Clear;
      NativeXmlObjectStorage.ObjectLoadFromXmlStream(g_UIManager, Stream);
      SaveUI;
      FrmDlg.InitUIPak;
    finally
      FreeAndNilEx(Stream);
      g_boLockUpdate := False;
    end;
  except
    on E: Exception do
      uLog.TLogger.AddLog('ParseUI:' + E.Message);
  end;
end;

procedure TfrmMain.ClientParseTypeNames(const Value: AnsiString);
var
  sData: AnsiString;
  SName, SValue: String;
  Stream: TStringStream;
  List: TStrings;
  i: Integer;
begin
  try
    g_ItemTypeNamesVer := Copy(Value, 1, 16);
    sData := Copy(Value, 18, Length(Value) - 17);
    Stream := TStringStream.Create;
    g_boLockUpdate := True;
    List := TStringList.Create;
    try
      g_ItemTypeNames.Clear;
      LoadStreamFromString(sData, Stream);
      Stream.Seek(0, soFromBeginning);
      List.Text := Stream.DataString;
      for i := 0 to List.count - 1 do
      begin
        SValue := GetValidStr3(List.Strings[i], SName, ['=']);
        if (SName <> '') and (SValue <> '') and
          (StrToIntDef(SName, 0) IN [0 .. 255]) then
          g_ItemTypeNames.AddOrSetValue(StrToInt(SName), Trim(SValue));
      end;
      SaveItemTypeNames;
    finally
      FreeAndNilEx(Stream);
      FreeAndNilEx(List);
      g_boLockUpdate := False;
    end;
  except
    on E: Exception do
      uLog.TLogger.AddLog('ParseTypes:' + E.Message);
  end;
end;

procedure TfrmMain.ClientParseSkill(const Value: AnsiString);
var
  sData: AnsiString;
  SName, SValue: String;
  Stream: TMemoryStream;
  List: TStrings;
  i: Integer;
begin
  try
    g_SkillConfigVer := Copy(Value, 1, 16);
    sData := Copy(Value, 18, Length(Value) - 17);
    Stream := TMemoryStream.Create;
    g_boLockUpdate := True;
    try
      LoadStreamFromString(sData, Stream);
      Stream.Seek(0, soFromBeginning);
      NativeXmlObjectStorage.ObjectLoadFromXmlStream(g_SkillData,Stream);
      SaveSkillData();
    finally
      FreeAndNilEx(Stream);
      g_boLockUpdate := False;
    end;
  except
    on E: Exception do
      uLog.TLogger.AddLog('ParseSkill:' + E.Message);
  end;
end;

procedure TfrmMain.ClientParseSkillEffeect(const Value: AnsiString);
var
  sData: AnsiString;
  SName, SValue: String;
  Stream: TMemoryStream;
  List: TStrings;
  i: Integer;
begin
  try
    g_SkillEffectVer := Copy(Value, 1, 16);
    sData := Copy(Value, 18, Length(Value) - 17);
    Stream := TMemoryStream.Create;
    g_boLockUpdate := True;
    try
      LoadStreamFromString(sData, Stream);
      Stream.Seek(0, soFromBeginning);
      NativeXmlObjectStorage.ObjectLoadFromXmlStream(g_SkillEffectData,Stream);
      SaveSkillEffectData();
      InitSkillEffectData();
    finally
      FreeAndNilEx(Stream);
      g_boLockUpdate := False;
    end;
  except
    on E: Exception do
      uLog.TLogger.AddLog('ParseSkillEffect:' + E.Message);
  end;

end;

procedure TfrmMain.ClientParseSuites(const Value: AnsiString);
var
  sData: AnsiString;
  Stream: TMemoryStream;
  SuitItem: pTSuitItem;
begin
  try
    g_SuitVer := Copy(Value, 1, 16);
    sData := Copy(Value, 18, Length(Value) - 17);
    Stream := TMemoryStream.Create;
    g_boLockUpdate := True;
    try
      ClearSuitItems;
      LoadStreamFromString(sData, Stream);
      Stream.Seek(0, soFromBeginning);
      while Stream.Position < Stream.Size do
      begin
        New(SuitItem);
        Stream.ReadBuffer(SuitItem^, SizeOf(TSuitItem));
        g_SuitList.Add(SuitItem);
      end;
      SaveSuitItems;
    finally
      FreeAndNilEx(Stream);
      g_boLockUpdate := False;
    end;
  except
{$IFDEF WRITELOG}
    on E: Exception do
      uLog.TLogger.AddLog('ParseSuites:' + E.Message);
{$ENDIF}
  end;
end;

procedure TfrmMain.ClientParseMap(const Value: AnsiString);
var
  sData: AnsiString;
  Stream: TMemoryStream;
begin
  try
    Stream := TMemoryStream.Create;
    try
      g_MapVer := Copy(Value, 1, 16);
      sData := Copy(Value, 18, Length(Value) - 17);
      LoadStreamFromString(sData, Stream);
      Stream.Seek(0, soFromBeginning);
      g_MapDesc.Clear;
      NativeXmlObjectStorage.ObjectLoadFromXmlStream(g_MapDesc, Stream);
      SaveMapDesc;
    finally
      FreeAndNilEx(Stream);
    end;
  except
{$IFDEF WRITELOG}
    on E: Exception do
      uLog.TLogger.AddLog('ParseMap:' + E.Message);
{$ENDIF}
  end;
end;

procedure TfrmMain.ClientParseMagics(const Value: AnsiString);
begin
  g_MagicMgr.LoadFromString(Value);
end;

procedure TfrmMain.ClientParseMagicDesc(const Value: AnsiString);
begin
  g_MagicMgr.LoadDescFromString(Value);
end;

procedure TfrmMain.ClientCheckDBVer(_Type: Integer; const Ver: AnsiString);

  procedure CheckVer(const LocalVer: AnsiString);
  var
    Msg: TDefaultMessage;
  begin
    if LocalVer <> Ver then
    begin
      Msg := MakeDefaultMsg(CM_CLIENTDATA_VERSION, _Type, 0, 0, 0,
        Certification);
      SendSocket(Msg, EdCode.EncodeString(LocalVer));
    end;
  end;

begin
  case _Type of
    CD_CLIENTDATA_ITEMS, CD_CLIENTDATA_ITEMSDSC:
      CheckVer(g_ItemVer);
    CD_CLIENTDATA_SUITES:
      CheckVer(g_SuitVer);
    CD_CLIENTDATA_MAP:
      CheckVer(g_MapVer);
    CD_CLIENTDATA_UI:
      CheckVer(g_UIVer);
    CD_CLIENTDATA_TYPENAMES:
      CheckVer(g_ItemTypeNamesVer);
    CD_CLIENTDATA_MAGICS, CD_CLIENTDATA_MAGICDESC:
      CheckVer(g_ItemTypeNamesVer);
    CD_CLIENTDATA_ITEMWAY:
      CheckVer(g_ItemWayVer);
    CD_CLIENTDATA_ACTORACTION:
      CheckVer(g_CustomActorActionVer);
    CD_CLIENTDATA_SKILLCONFIG:
      CheckVer(g_SkillConfigVer);
    CD_CLIENTDATA_SKILLEFFECTCONFIG:
      CheckVer(g_SkillEffectVer);
  end;
end;

procedure TfrmMain.AddExtendButton(ImgIdx: Integer;
  const Value: PPlatfromString; ISTop: Boolean ; X:Integer = 0 ; Y : Integer = 0);
var
  SName, SHint, SCommand: PPlatfromString;
  AName, AHint, ACommand: String;
begin
  SCommand := AnsiGetValidStr3(Value, SName, ['/']);
  SCommand := AnsiGetValidStr3(SCommand, SHint, ['/']);
  AName := EdCode.DecodeString(SName);
  AHint := EdCode.DecodeString(SHint);
  ACommand := EdCode.DecodeString(SCommand);
  FrmDlg.AddExtendButton(AName, AHint, ACommand, ImgIdx, ISTop,X,Y);
end;

procedure TfrmMain.RemoveExtendButton(const Value: PPlatfromString);
var
  AName: String;
begin
  AName := EdCode.DecodeString(Value);
  FrmDlg.RemoveExtendButton(AName);
end;

procedure TfrmMain.ShowSighIcon(const Value: PPlatfromString);
var
  AMethod, AHint: String;
begin
  AHint := GetValidStr3(Value, AMethod, ['/']);
  AMethod := EdCode.DecodeString(AMethod);
  AHint := EdCode.DecodeString(AHint);
  g_SighIconMethods.Add(AMethod);
  g_SighIconHints.Add(AHint);
  UpdateSighIcon;
end;

procedure TfrmMain.UpdateSighIcon;
begin
  FrmDlg.DSighIcon.Hint := '';
  FrmDlg.DSighIcon.Visible := g_SighIconMethods.count > 0;
  if g_SighIconMethods.count > 0 then
    FrmDlg.DSighIcon.Hint := g_SighIconHints[0];
end;

// 玩家点击开始游戏
procedure TfrmMain.ClientGetStartPlay(const body: PPlatfromString);
var
  ARouteMsg, ALine, AAddr, APort: string;
begin
  ARouteMsg := uEDCode.DecodeString(body, {$I IPsEncode.inc});
  ARouteMsg := GetValidStr3(ARouteMsg, ALine, ['/']);

  APort := GetValidStr3(ALine, g_sRunServerAddr, [',']);
  g_nRunServerPort := Str_ToInt(APort, 0);
  FRunRoutes.Clear;
  try
    while ARouteMsg <> '' do
    begin
      ARouteMsg := GetValidStr3(ARouteMsg, ALine, ['/']);
      APort := GetValidStr3(ALine, AAddr, [',']);
      FRunRoutes.Add(AAddr + '=' + APort);
    end;
  except
  end;
  FTryReconnet := False;
  g_ConnectionStep := cnsPlay;
  FRunRouteIndex := FRunRoutes.IndexOf(g_sRunServerAddr + '=' +
    IntToStr(g_nRunServerPort));
  SocketOpen(g_sRunServerAddr, g_nRunServerPort);
  // SocketOpen('127.0.0.1', 7200);
end;

procedure TfrmMain.ClientGetSubAbility(const Value: String);
begin
  EdCode.DecodeBuffer(Value, @g_MySubAbility, SizeOf(TSubAbility));
  g_MySelf.m_btReLevel := g_MySubAbility.ReLevel;
end;

procedure TfrmMain.ClientGetReletions(const Command: Integer;
  const Data: PPlatfromString);

  procedure ClientPlayOnOffLine(const AName: String; OnLine: Boolean);
  var
    i: Integer;
  begin
    for i := 0 to g_Friends.count - 1 do
      if AName = String(pTFriendRecord(g_Friends[i]).Name) then
      begin
        pTFriendRecord(g_Friends[i]).OnLine := OnLine;
        Exit;
      end;
    for i := 0 to g_Enemies.count - 1 do
      if AName = String(pTFriendRecord(g_Enemies[i]).Name) then
      begin
        pTFriendRecord(g_Enemies[i]).OnLine := OnLine;
        Exit;
      end;
  end;

  procedure ClientGetFriends(const Value: PPlatfromString);
  var
    S, ALine: PPlatfromString;
    ADotIndex: Integer;
    ARecord: pTFriendRecord;
  begin
    S := Value;
    while True do
    begin
      S := AnsiGetValidStr3(S, ALine, ['/']);
      if ALine <> '' then
      begin
        ADotIndex := Pos(':', ALine);
        if ADotIndex > 0 then
        begin
          New(ARecord);
          ARecord.Name := EdCode.DecodeString(Copy(ALine, 1, ADotIndex - 1));
          Delete(ALine, 1, ADotIndex);
          ARecord.OnLine := ALine = '1'; // TODO
          g_Friends.Add(ARecord);
        end;
      end;
      if S = '' then
        Break;
    end;
  end;

  procedure ClientGetEnemies(const Value: PPlatfromString);
  var
    S, ALine: PPlatfromString;
    ADotIndex: Integer;
    ARecord: pTFriendRecord;
  begin
    S := Value;
    while True do
    begin
      S := AnsiGetValidStr3(S, ALine, ['/']);
      if ALine <> '' then
      begin
        ADotIndex := Pos(':', ALine);
        if ADotIndex > 0 then
        begin
          New(ARecord);
          ARecord.Name := EdCode.DecodeString(Copy(ALine, 1, ADotIndex - 1));
          Delete(ALine, 1, ADotIndex);
          ARecord.OnLine := ALine = '1';
          g_Enemies.Add(ARecord);
        end;
      end;
      if S = '' then
        Break;
    end;
  end;

  procedure ClientAddFriend(const Value: String);
  var
    ARecord: pTFriendRecord;
    Msg: TDefaultMessage;
  begin
    if NameAtFriends(Value) = -1 then
    begin
      New(ARecord);
      ARecord.Name := Value;
      ARecord.OnLine := True;
      g_Friends.Add(ARecord);
    end;
    AddMessageDialog('成功添加好友【' + Value + '】！！！', [mbOk]);
  end;

  procedure ClientDelFriend(const Value: String);
  var
    idx: Integer;
    ARecord: pTFriendRecord;
    Msg: TDefaultMessage;
  begin
    idx := NameAtFriends(Value);
    if idx <> -1 then
    begin
      ARecord := g_Friends[idx];
      g_Friends.Delete(idx);
      Dispose(ARecord);
    end;
    AddMessageDialog('成功将【' + Value + '】从好友列表中删除！！！', [mbOk]);
  end;

  procedure ClientAddEnemiy(const Value: String);
  var
    ARecord: pTFriendRecord;
    Msg: TDefaultMessage;
  begin
    if NameAtEnemies(Value) = -1 then
    begin
      New(ARecord);
      ARecord.Name := Value;
      ARecord.OnLine := True;
      g_Enemies.Add(ARecord);
    end;
    AddMessageDialog('成功将【' + Value + '】添加到黑名单！！！', [mbOk]);
  end;

  procedure ClientDelEnemiy(const Value: String);
  var
    idx: Integer;
    ARecord: pTFriendRecord;
  begin
    idx := NameAtEnemies(Value);
    if idx <> -1 then
    begin
      ARecord := g_Enemies[idx];
      g_Enemies.Delete(idx);
      Dispose(ARecord);
    end;
    AddMessageDialog('成功将【' + Value + '】从黑名单中删除！！！', [mbOk]);
  end;

  procedure ClientAddFirendWait(const Value: String);
  begin
    AddMessageDialog('请求已发送给玩家【' + Value + '】，请等待回应！！！', [mbOk]);
  end;

  procedure ClientAddFirendRequest(const Value: String);
  begin
    AddMessageDialog('玩家【' + Value + '】发出好友请求，你是否同意？', [mbOk, mbCancel],
      procedure(AResult: Integer)var Msg: TDefaultMessage;
    begin if AResult = mrOK then Msg := MakeDefaultMsg(CM_RELATION,
      _CM_RELATION_AGREEFIREND, 0, 0, 0, Certification) else Msg :=
      MakeDefaultMsg(CM_RELATION, _CM_RELATION_REJECTFIREND, 0, 0, 0,
      Certification); SendSocket(Msg, EdCode.EncodeString(Value)); end);
  end;

  procedure ClientAddFirendReject(const Value: String);
  begin
    AddMessageDialog('玩家【' + Value + '】拒绝了你的好友请求！！！', [mbOk]);
  end;

  procedure ClientPlayNotFound(const Value: String);
  begin
    AddMessageDialog('玩家【' + Value + '】不在线，操作失败！！！', [mbOk]);
  end;

begin
  case Command of
    RT_ONLINE:
      ClientPlayOnOffLine(EdCode.DecodeString(Data), True);
    RT_OFFLINE:
      ClientPlayOnOffLine(EdCode.DecodeString(Data), False);
    RT_FirendsNames:
      ClientGetFriends(Data);
    RT_EnemiesNames:
      ClientGetEnemies(Data);
    RT_ADDFRIENDSUC:
      ClientAddFriend(EdCode.DecodeString(Data));
    RT_ADDENEMIYSUC:
      ClientAddEnemiy(EdCode.DecodeString(Data));
    RT_DELFIRENTSUC:
      ClientDelFriend(EdCode.DecodeString(Data));
    RT_DELENEMIYSUC:
      ClientDelEnemiy(EdCode.DecodeString(Data));
    RT_ADDFRIENDWAIT:
      ClientAddFirendWait(EdCode.DecodeString(Data));
    RT_ADDFRIENDREQ:
      ClientAddFirendRequest(EdCode.DecodeString(Data));
    RT_ADDFRIENDREJ:
      ClientAddFirendReject(EdCode.DecodeString(Data));
    RT_PLAYNOTFOUND:
      ClientPlayNotFound(EdCode.DecodeString(Data));
  end;
end;

procedure TfrmMain.ClientGetReconnect(const body: PPlatfromString);
var
  str, Addr, sport: string;
begin
  str := EdCode.DecodeString(body);
  sport := GetValidStr3(str, Addr, ['/']);

  g_boServerChanging := True;
  CSocket.Close;
  CSocket.Address := '';
  CSocket.Port := 0;
  FTryReconnet := False;
  g_ConnectionStep := cnsPlay;
  SocketOpen(Addr, StrToIntDef(sport, 0));
end;

// 取地图音乐背景
procedure TfrmMain.ClientGetMapDescription(Msg: TDefaultMessage;
  const sBody: PPlatfromString);
var
  SOldMapMusic: String;
  AMapItem: TuMapDescItem;
  i, NOldMapMusic: Integer;
  L: TStrings;
begin
  L := TStringList.Create;
  try
    NOldMapMusic := g_nMapMusic;
    SOldMapMusic := g_sMapMusic;
    g_CurMapDesc.ClearDesc;
    L.Text := EdCode.DecodeString(sBody);
    g_sMapTitle := L._Line(0);
    FrmDlg.DTMiniMapName.Propertites.Caption.Text := g_sMapTitle;
    g_sMapMusic := L._Line(1);
    g_sMapName := L._Line(2);
    g_nMapMusic := Msg.Recog;
    g_nMapMusicLoop := Msg.Param * 1000;
    g_boMapDup := Msg.tag = 1;
    if (NOldMapMusic <> g_nMapMusic) or (SOldMapMusic <> g_sMapMusic) then
    begin
      g_SoundManager.PlayMapMusic(False);
      g_SoundManager.PlayMapMusic(True);
    end
    else
    begin
      if g_boChangeMapStopMusic then
      begin
        g_SoundManager.MapMusicSilenced := False;
        g_boChangeMapStopMusic := False;
      end;
    end;
    if Map <> nil then
    begin
      AMapItem := g_MapDesc.Maps.FindMap(g_sMapTitle, Map.m_sCurrentMap,
        g_sMapName, g_boMapDup);
      if AMapItem <> nil then
      begin
        for i := 0 to AMapItem.Tags.count - 1 do
          g_CurMapDesc.AddDesc(AMapItem.Tags.Items[i].X,
            AMapItem.Tags.Items[i].Y, AMapItem.Tags.Items[i]._Type,
            AMapItem.Tags.Items[i].desc, AMapItem.Tags.Items[i].Color);
      end;
    end;
  finally
    FreeAndNilEx(L);
  end;
end;

procedure TfrmMain.ClientGetGameGoldName(Msg: TDefaultMessage;
  const sBody: PPlatfromString);
var
  ABody, sData, sData1, sData2, sData3: String;
begin
  if sBody <> '' then
  begin
    ABody := EdCode.DecodeString(sBody);
    ABody := GetValidStr3(ABody, sData, [#13]);
    ABody := GetValidStr3(ABody, sData1, [#13]);
    ABody := GetValidStr3(ABody, sData2, [#13]);
    ABody := GetValidStr3(ABody, sData3, [#13]);

    g_sGameGoldName := sData;
    g_sGamePointName := sData1;
    g_sGameDiaMond := sData2;
    g_sGameGird := sData3;
  end;
  g_nGold := Msg.Recog;
  g_dwGameGold := Msg.Param;
  g_nGamePoint := Msg.tag;
  g_nGameDiaMond := Msg.series;
  g_nGameGird := Msg.nSessionID;
end;

procedure TfrmMain.ClientGetAdjustBonus(bonus: Integer; body: string);
var
  str1, str2, str3: string;
begin
  g_nBonusPoint := bonus;
  body := GetValidStr3(body, str1, ['/']);
  str3 := GetValidStr3(body, str2, ['/']);
  DecodeBuffer(str1, @g_BonusTick, SizeOf(TNakedAbility));
  DecodeBuffer(str2, @g_BonusAbil, SizeOf(TNakedAbility));
  DecodeBuffer(str3, @g_NakedAbil, SizeOf(TNakedAbility));
  FillChar(g_BonusAbilChg, SizeOf(TNakedAbility), #0);
  //FrmDlg.SetBottomButtonsPosition;
  FrmDlg.DBotPlusAbil.visible := g_nBonusPoint > 0;
end;

procedure TfrmMain.ClientGetActorName(nActor , nTitleEffect: Integer;
  btNameColor, btMiniMapHeroColor: Byte; const AName: PPlatfromString);
var
  _Pos: Integer;
  sTitle, sTitleEff, SName: String;
  Actor: TActor;
  List: TStrings;
  i: Integer;
begin

  Actor := PlayScene.FindActor(nActor);
  if Actor <> nil then
  begin
    _Pos := Pos(#$D#$A, AName);
    SName := AName;
    sTitle := '';
    if _Pos > 0 then
    begin
      List := TStringList.Create;
      try
        List.Text := AName;
        if List.count > 1 then
        begin
          sTitle := List[0];
          SName := '';
          for i := 1 to List.count - 1 do
            SName := SName + List[i];
        end;
      finally
        FreeAndNilEx(List);
      end;
    end;
    Actor.UpdateTitle(nTitleEffect);
    Actor.UpdateNameTitle(sTitle);
    Actor.m_sDescUserName := GetValidStr3(SName, Actor.m_sUserName, ['\']);
    Actor.m_nNameColor := GetRGB(btNameColor);
    Actor.m_btMiniMapHeroColor := btMiniMapHeroColor;

  end;
end;

procedure TfrmMain.ClientGetActorTitleEffects( Recog : Integer; const Config: String);
var
  Actor : TActor;
begin
  Actor := PlayScene.FindActor(Recog);
  if Actor <> nil then
  begin
    Actor.UpdateTitles(Config);
  end;
end;

procedure TfrmMain.ClientGetAddItem(const body: PPlatfromString);
var
  cu: TClientItem;
begin
  if body <> '' then
  begin
    DecodeClientItem(body, cu);
    AddItemBag(cu);
    DScreen.AddSysMsg(cu.DisplayName + ' 被发现.');
  end;
end;

// 接收排行榜
procedure TfrmMain.ClientGetUserOrder(body: string);
begin

end;

procedure TfrmMain.DeleteItemByMakeIndex(AMakeIndex: Integer);
var
  i, J: Integer;
  ATmp: TClientItem;
begin
  if g_MovingItem.Item.MakeIndex = AMakeIndex then
  begin
    g_MovingItem.FromIndex := 0;
    g_MovingItem.Source := msNone;
    g_MovingItem.Item.Name := '';
    g_MovingItem.Item.MakeIndex := -1;
    g_boItemMoving := False;
  end;

  DelItemBag('', AMakeIndex);
  for i := U_DRESS to U_MAXUSEITEMIDX do
  begin
    if (g_UseItems[i].Name <> '') and
      (g_UseItems[i].MakeIndex = AMakeIndex) then
    begin
      g_UseItems[i].Name := '';
      g_MyMixedAbility := RecalcMyTotalAbility;
    end;
  end;

  for i := 0 to UIWindowManager.UIItems.count - 1 do
  begin
    for J := 0 to UIWindowManager.UIItems.Items[i].ItemContainers.count - 1 do
    begin
      if UIWindowManager.UIItems.Items[i].ItemContainers.Items[J].DControl
        <> nil then
      begin
        ATmp := TuDItemControl(UIWindowManager.UIItems.Items[i]
          .ItemContainers.Items[J].DControl).ClientItem;
        if (ATmp.MakeIndex = AMakeIndex) and (ATmp.Name <> '') then
          FillChar(TuDItemControl(UIWindowManager.UIItems.Items[i]
            .ItemContainers.Items[J].DControl).ClientItem, ClientItemSize, #0);
      end;
    end;
  end;

  if DScreen.ItemHint and (g_MouseItem.MakeIndex = AMakeIndex) then
    DScreen.ClearHint;
end;

procedure TfrmMain.ClientPlaySound(const ASoundFile: String);
begin
  g_SoundManager.PlaySoundEx(ASoundFile);
end;

procedure TfrmMain.ClientPlayVideo(const AVideoFile: String);
begin
  // todo video
end;

procedure TfrmMain.ClientReadOperateState(AState: Integer);
begin
  case AState of
    _OP_FAIL:
      begin
        ActionFailed;
        ActionLock := False;
      end;
    _OP_SUC:
      BEGIN
        ActionLock := False;
      END;
    _OP_DIG:
      begin
        if g_MySelf <> nil then
          g_MySelf.m_boDigFragment := True;
      end;
  end;
end;

procedure TfrmMain.ClientReadSkillState(SkillID, AState, ATag: Integer);
var
  AOpend: Boolean;
  AMagic: PTClientMagic;
  AClient: TuMagicClient;
begin
  if TryGetMagic(SkillID, AMagic) then
  begin
    AOpend := AState = 1;
    if AOpend then
    begin
      if g_MagicMgr.TryGet(SkillID, AClient) then
      begin
        case AClient.FireType of
          ftNone:
            ;
          ftSpell:
            ;
          ftTurnHit:
            AddOpendMagic(SkillID);
          ftHitCallNext, ftNextHit:
            AddNextMagic(SkillID, ATag);
        end;
      end
      else
      begin
        case SkillID of
          SKILL_85, SKILL_82, SKILL_79, SKILL_76:
            begin
              AddNextBatterMagic(SkillID);
            end;

          SKILL_YEDO, SKILL_151, // 攻杀、蓄势待发
          SKILL_96, // 血魄一击
          SKILL_69, // 倚天劈地
          SKILL_43, // 龙影剑法
          SKILL_42, // 开天斩
          SKILL_74, // 逐日剑法
          SKILL_FIRESWORD, // 烈火剑法
          SKILL_159, // 暴击术
          SKILL_163, // 炎龙波
          SKILL_161, SKILL_167 // 火镰狂舞
            :
            begin
              AddNextMagic(SkillID, ATag);
            end;
          SKILL_40, // 抱月刀法
          SKILL_BANWOL, SKILL_170, // 半月、霜月
          SKILL_ERGUM: // 刺杀
            begin
              AddOpendMagic(SkillID);
            end;
        end;
      end;
    end
    else
      DeleteMagic(SkillID);
  end;
end;

procedure TfrmMain.ClientGetUpdateItem(const body: PPlatfromString);
var
  AItem, ATempItem: TClientItem;
  i, J: Integer;
begin
  if body <> '' then
  begin
    DecodeClientItem(body, AItem);
    UpdateItemBag(AItem);
    if (g_WaitingUseItem.Item.Name <> '') and
      (g_WaitingUseItem.Item.MakeIndex = AItem.MakeIndex) then
      g_WaitingUseItem.Item := AItem;
    for i := U_DRESS to U_MAXUSEITEMIDX do
    begin
      if (g_UseItems[i].Name <> '' { = AItem.Name } ) and
        (g_UseItems[i].MakeIndex = AItem.MakeIndex) then
      begin
        g_UseItems[i] := AItem;
        g_MyMixedAbility := RecalcMyTotalAbility;
      end;
    end;
    if g_boItemMoving then
    begin
      if (g_MovingItem.Item.Name <> '') and
        (g_MovingItem.Item.MakeIndex = AItem.MakeIndex) then
        g_MovingItem.Item := AItem;
    end;
    for i := 0 to UIWindowManager.UIItems.count - 1 do
    begin
      for J := 0 to UIWindowManager.UIItems.Items[i].ItemContainers.count - 1 do
      begin
        if UIWindowManager.UIItems.Items[i].ItemContainers.Items[J].DControl
          <> nil then
        begin
          ATempItem := TuDItemControl(UIWindowManager.UIItems.Items[i]
            .ItemContainers.Items[J].DControl).ClientItem;
          if (ATempItem.MakeIndex = AItem.MakeIndex) and
            (ATempItem.Name <> '') then
            TuDItemControl(UIWindowManager.UIItems.Items[i].ItemContainers.Items
              [J].DControl).ClientItem := AItem;
        end;
      end;
    end;
    if DScreen.ItemHint and (g_MouseItem.MakeIndex = AItem.MakeIndex) then
    begin
      DScreen.ClearHint;
    end;
  end;
end;



procedure TfrmMain.ClientGetDelItem(const body: PPlatfromString);
var
  cu: TClientItem;
begin
  if body <> '' then
  begin
    DecodeClientItem(body, cu);
    DeleteItemByMakeIndex(cu.MakeIndex);
  end;
end;

procedure TfrmMain.ClientGetDelItems(const body: PPlatfromString);
var
  AData: String;
  AMakeIndex: Integer;
  AIndexStr: String;
begin
  AData := EdCode.DecodeString(body);
  while AData <> '' do
  begin
    AData := GetValidStr3(AData, AIndexStr, ['/']);
    if AIndexStr <> '' then
    begin
      AMakeIndex := StrToIntDef(AIndexStr, 0);
      DeleteItemByMakeIndex(AMakeIndex);
    end
    else
      Break;
  end;
end;

procedure TfrmMain.ClientGetBagItmes(body: PPlatfromString);
var
  str: PPlatfromString;
  cu: TClientItem;
  ItemSaveArr: array [0 .. MAXBAGITEM + 6 - 1] of TClientItem;

  function CompareItemArr: Boolean;
  // 可能是检测复制物品
  var
    i, J: Integer;
    flag: Boolean;
  begin
    flag := True;
    for i := 0 to MAXBAGITEM + 6 - 1 do
    begin
      if ItemSaveArr[i].Name <> '' then
      begin
        flag := False;
        for J := 0 to MAXBAGITEM + 6 - 1 do
        begin
          if (g_ItemArr[J].Name = ItemSaveArr[i].Name) and
            (g_ItemArr[J].MakeIndex = ItemSaveArr[i].MakeIndex) then
          begin
            if (g_ItemArr[J].Dura = ItemSaveArr[i].Dura) and
              (g_ItemArr[J].DuraMax = ItemSaveArr[i].DuraMax) then
            begin
              flag := True;
            end;
            Break;
          end;
        end;
        if not flag then
          Break;
      end;
    end;
    if flag then
    begin
      for i := 0 to MAXBAGITEM + 6 - 1 do
      begin
        if g_ItemArr[i].Name <> '' then
        begin
          flag := False;
          for J := 0 to MAXBAGITEM + 6 - 1 do
          begin
            if (g_ItemArr[i].Name = ItemSaveArr[J].Name) and
              (g_ItemArr[i].MakeIndex = ItemSaveArr[J].MakeIndex) then
            begin
              if (g_ItemArr[i].Dura = ItemSaveArr[J].Dura) and
                (g_ItemArr[i].DuraMax = ItemSaveArr[J].DuraMax) then
              begin
                flag := True;
              end;
              Break;
            end;
          end;
          if not flag then
            Break;
        end;
      end;
    end;
    Result := flag;
  end;

begin
  FillChar(g_ItemArr[0], SizeOf(g_ItemArr), #0);
  while True do
  begin
    if body = '' then
      Break;
    body := AnsiGetValidStr3(body, str, ['/']);
    DecodeClientItem(str, cu);
    AddItemBag(cu);
  end;

  FillChar(ItemSaveArr, SizeOf(ItemSaveArr), #0);
  if CompareItemArr then
  begin
    Move(ItemSaveArr, g_ItemArr, ClientItemSize * MAXBAGITEM);
  end;

  ArrangeItemBag;
  g_boBagLoaded := True;
end;

procedure TfrmMain.ClientGetDropItemFail(iname: string; sindex: Integer);
var
  pc: PTClientItem;
begin
  pc := GetDropItem(iname, sindex);
  if pc <> nil then
  begin
    AddItemBag(pc^);
    DelDropItem(iname, sindex);
  end;
end;

procedure TfrmMain.ClientGetShowItem(itemid, X, Y, looks, ItemInfo: Integer;
  const itmname: string);
var
  i: Integer;
  DropItem: PTDropItem;
  AShowItem: TShowItem;
begin
  if g_DropedItemList.count > 0 then
  begin
    for i := 0 to g_DropedItemList.count - 1 do
    begin
      if PTDropItem(g_DropedItemList[i]).Id = itemid then
        Exit;
    end;
  end;
  New(DropItem);
  System.Initialize(DropItem^);
  DropItem.Id := itemid;
  DropItem.itemindex := Loword(ItemInfo);
  DropItem.X := X;
  DropItem.Y := Y;
  DropItem.looks := looks;
  DropItem.Color := GetItemNameColor(Loword(ItemInfo), Hiword(ItemInfo));
  DropItem.Name := itmname;
  DropItem.FlashTime := GetTickCount - LongWord(Random(3000));
  DropItem.BoFlash := False;
  DropItem.BoShowName := False;
  DropItem.BoSpec := False;
  DropItem.BoPickup := False;
{$IFDEF VirtualMap}
  DropItem.boDraw := False;
{$ELSE}
  DropItem.boDraw := True;
{$ENDIF}
  AShowItem := GetShowItem(Loword(ItemInfo));
  if AShowItem <> nil then
  begin
    DropItem.BoShowName := AShowItem.BoShowName;
    DropItem.BoSpec := AShowItem.BoSpec;
    DropItem.BoPickup := AShowItem.boAutoPickup;
  end;
  g_DropedItemList.Add(DropItem);
end;

procedure TfrmMain.ClientGetHideItem(itemid, X, Y: Integer);
var
  i: Integer;
  DropItem: PTDropItem;
begin
  if g_DropedItemList.count > 0 then
    // 20080629
    for i := 0 to g_DropedItemList.count - 1 do
    begin
      DropItem := g_DropedItemList[i];
      if DropItem.Id = itemid then
      begin
        System.Finalize(DropItem^);
        Dispose(DropItem);
        g_DropedItemList.Delete(i);
        Break;
      end;
    end;
end;

procedure TfrmMain.ClientGetSenduseItems(body: PPlatfromString);
var
  index: Integer;
  str, Data: PPlatfromString;
  cu: TClientItem;
  AEffect: TdxItemEffect;
begin
  FillChar(g_UseItems[0], SizeOf(g_UseItems), #0);
  while True do
  begin
    if body = '' then
      Break;
    body := AnsiGetValidStr3(body, str, ['/']);
    body := AnsiGetValidStr3(body, Data, ['/']);
    index := Str_ToInt(str, -1);
    if index in [U_DRESS .. U_MAXUSEITEMIDX] then
    begin
      DecodeClientItem(Data, cu);
      g_UseItems[index] := cu;
    end;
  end;
  if (g_UseItems[U_DRESS].Name <> '') and (g_UseItems[U_DRESS].Index > 0) and
    (g_UseItems[U_DRESS].CustomEff > 0) then
  begin
    if UIWindowManager.ItemEffects.TryGetEffect(g_UseItems[U_DRESS].CustomEff,
      AEffect) then
      UIWindowManager.TryGetItemInnerEffect(AEffect.InnerEffect,
        g_MyDressInnerEff);
  end;
  if (g_UseItems[U_WEAPON].Name <> '') and (g_UseItems[U_WEAPON].Index > 0) and
    (g_UseItems[U_WEAPON].CustomEff > 0) then
  begin
    if UIWindowManager.ItemEffects.TryGetEffect(g_UseItems[U_WEAPON].CustomEff,
      AEffect) then
      UIWindowManager.TryGetItemInnerEffect(AEffect.InnerEffect,
        g_MyWeponInnerEff);
  end;
end;

procedure TfrmMain.ClientSetSpeed(wRunTime, wWalkTime, wHitTime,
  wSpellTime: Integer);
begin
  g_GameData.RunTime.Data := wRunTime;
  g_GameData.WalkTime.Data := wWalkTime;
  g_GameData.HitTime.Data := wHitTime;
  g_GameData.SpellTime.Data := wSpellTime;

  g_RunTimeRate := wRunTime / (6 * 120 + 120);
  // ActRun: (start: 128; frame: 6; skip: 2; ftime: 120);
  g_WalkTimeRate := wWalkTime / (6 * 90 + 120);
  // ActWalk: (start: 64; frame: 6; skip: 2; ftime: 90);
  g_HitTimeRate := wHitTime / (85 * 6 + 120);
  // ActHit: (start: 200; frame: 6; skip: 2; ftime: 85);
  g_SpellTimeRate := wSpellTime / (6 * 60 + 120);
  // ActSpell: (start: 392; frame: 6; skip: 2; ftime: 60);
end;

procedure TfrmMain.ClientShowEffect(Msg: TDefaultMessage);
var
  AEvent: TCustomEvent;
begin
  case Msg.tag of
    ET_DIGOUTZOMBI .. ET_HEROLOGOUT:
      begin
        AEvent := TClEvent.Create(0, Msg.Recog { x } , Msg.Param { y } ,
          Msg.tag { e-type } );
        EventMan.AddEvent(AEvent);
        case Msg.Param of
          ET_FIREFLOWER_1, ET_FIREFLOWER_2, ET_FIREFLOWER_3, ET_FIREFLOWER_4,
            ET_FIREFLOWER_5, ET_FIREFLOWER_6, ET_FIREFLOWER_7, ET_FIREFLOWER_8:
            g_SoundManager.MyPlaySound(Protechny_ground);
          ET_HEROLOGOUT:
            g_SoundManager.MyPlaySound(HeroHeroLogout_ground);
          ET_FOUNTAIN:
            g_SoundManager.MyPlaySound(spring_ground);
          ET_DIEEVENT:
            g_SoundManager.MyPlaySound(powerup_ground);
        end;
      end
  else
    g_MySelf.ShowEffect(Msg.tag);
  end;
end;

procedure TfrmMain.ReadGoldNames(const S: String);

  procedure ReadValue(L: TStrings; Index: Integer; var V: String);
  begin

  end;

var
  L: TStrings;
begin
  if S <> '' then
  begin
    L := TStringList.Create;
    try
      L.Text := S;
      g_sGameGoldName := L[1];
      g_sGamePointName := L[2];
      g_sGameDiaMond := L[3];
      g_sGameGird := L[4];
    finally
      FreeAndNilEx(L);
    end;
  end;
end;

// 聚灵珠时间改变 20080307
procedure TfrmMain.ClientGetExpTimeItemChange(uidx, NewTime: Integer);
var
  i: Integer;
begin
  for i := 5 to MAXBAGITEM - 1 do
  begin
    if (g_ItemArr[i].MakeIndex = uidx) then
    begin
      if g_ItemArr[i].Name <> '' then
      begin
        // g_ItemArr[i].s.Need := NewTime;
      end;
    end;
  end;
end;

procedure TfrmMain.ClientGetAddMagic(const body: PPlatfromString);
var
  pcm: PTClientMagic;
begin
  New(pcm);
  FillChar(pcm^, SizeOf(TClientMagic), #0);
  DecodeBuffer(body, PPlatfromChar(pcm), SizeOf(TClientMagic));
  case pcm.btType of
    0:
      g_MagicList.Add(pcm);
    1:
      g_InternalForceMagicList.Add(pcm);
    2:
      begin
        g_BatterMagicList.Add(pcm);
        AddMenuString(pcm.sMagicName);
      end;
  end;
  //AddChatBoardString('技能“' + pcm.sMagicName + '”学习成功！', clGreen, clWhite);

end;

procedure TfrmMain.ClientGetUpdateMagic(const Body: PPlatfromString);
var
  pcm , pTemp: PTClientMagic;
  cm : TClientMagic;
  I:Integer;
label
  Update;
begin
  pcm := nil;
  FillChar(cm, SizeOf(TClientMagic), #0);
  DecodeBuffer(body, PPlatfromChar(@cm), SizeOf(TClientMagic));
  for I := 0 to g_MagicList.Count - 1 do
  begin
    pTemp := g_MagicList[i];
    if pTemp.wMagicId = cm.wMagicId then
    begin
      pcm := pTemp;
      goto Update;
    end;
  end;

  for I := 0 to g_InternalForceMagicList.Count - 1 do
  begin
    pTemp := g_InternalForceMagicList[i];
    if pTemp.wMagicId = cm.wMagicId then
    begin
      pcm := pTemp;
      goto Update;
    end;
  end;

  for I := 0 to g_BatterMagicList.Count - 1 do
  begin
    pTemp := g_BatterMagicList[i];
    if pTemp.wMagicId = cm.wMagicId then
    begin
      pcm := pTemp;
      goto Update;
    end;
  end;

Update:
  if pcm <> nil then
  begin
    Move(cm,pcm^,SizeOf(TClientMagic));
  end;
end;

procedure TfrmMain.ClientGetDelMagic(magid: Integer);
var
  i: Integer;
  bo123: Boolean;
begin
  bo123 := False;
  for i := g_MagicList.count - 1 downto 0 do
  begin
    if PTClientMagic(g_MagicList[i]).wMagicId = magid then
    begin
      Dispose(PTClientMagic(g_MagicList[i]));
      g_MagicList.Delete(i);
      bo123 := True;
      Break;
    end;
  end;
  DeleteMagic(magid);
  if not bo123 then
  begin
    if g_InternalForceMagicList.count > 0 then
    begin // 内功
      for i := g_InternalForceMagicList.count - 1 downto 0 do
      begin
        if PTClientMagic(g_InternalForceMagicList[i]).wMagicId = magid then
        begin
          Dispose(PTClientMagic(g_InternalForceMagicList[i]));
          g_InternalForceMagicList.Delete(i);
          Break;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.ClientGetMyShopSpecially(body: PPlatfromString);
var
  i: Integer;
  Data: PPlatfromString;
  pcm: pTShopItem;
begin
  ClearShopSpeciallyItems;
  while True do
  begin
    if body = '' then
      Break;
    body := AnsiGetValidStr3(body, Data, ['/']);
    if Data <> '' then
    begin
      New(pcm);
      DecodeBuffer(Data, @(pcm^), SizeOf(TShopItem));
      g_ShopSpeciallyItemList.Add(pcm);
    end
    else
      Break;
  end;
end;

procedure TfrmMain.ClientGetMyTitles(AActiveTitle: Integer;
  ABody: PPlatfromString);
var
  i: Integer;
  AData: PPlatfromString;
  ATitle: pTClientHumTitle;
begin
  g_ActiveTitle := AActiveTitle;
  for i := 0 to g_Titles.count - 1 do
    if pTClientHumTitle(g_Titles[i]) <> nil then
      Dispose(pTClientHumTitle(g_Titles[i]));
  g_Titles.Clear;

  while True do
  begin
    if ABody = '' then
      Break;
    ABody := AnsiGetValidStr3(ABody, AData, ['/']);
    if AData <> '' then
    begin
      New(ATitle);
      DecodeBuffer(AData, PAnsiChar(ATitle), SizeOf(TClientHumTitle));
      g_Titles.Add(ATitle);
    end
    else
      Break;
  end;
end;

procedure TfrmMain.ClientAddTitle(AActiveTitle: Integer;
  const ABody: PPlatfromString);
var
  ATitle: pTClientHumTitle;
begin
  if ABody <> '' then
  begin
    New(ATitle);
    DecodeBuffer(ABody, PAnsiChar(ATitle), SizeOf(TClientHumTitle));
    g_Titles.Add(ATitle);
  end;
end;

procedure TfrmMain.ClientRemoveTitle(AActiveTitle: Integer; ATitleID: Integer);
var
  i: Integer;
  ATitle: pTClientHumTitle;
begin
  g_ActiveTitle := AActiveTitle;
  for i := g_Titles.count - 1 downto 0 do
  begin
    ATitle := g_Titles[i];
    if ATitle.wIndex = ATitleID then
    begin
      Dispose(ATitle);
      g_Titles.Delete(i);
      g_TitlesPage := Min(g_TitlesPage, Ceil(g_Titles.count / 6) - 1);
      Break;
    end;
  end;
end;

procedure TfrmMain.ClientSetActiveTitle(ATitleID: Integer);
begin
  g_ActiveTitle := ATitleID;
end;

procedure TfrmMain.ClientGetMyShop(body: PPlatfromString);
var
  Data: PPlatfromString;
  pcm: pTShopItem;
begin
  ClearShopItems;
  while True do
  begin
    if body = '' then
      Break;
    body := AnsiGetValidStr3(body, Data, ['/']);
    if Data <> '' then
    begin
      New(pcm);
      DecodeBuffer(Data, @(pcm^), SizeOf(TShopItem));
      g_ShopItemList.Add(pcm);
    end
    else
      Break;
  end;
  FrmDlg.ReSetShopState;
end;

// 接收宝箱物品 2008.01.16
procedure TfrmMain.ClientGetMyBoxsItem(AShap: Integer; ABody: PPlatfromString);
var
  i: Integer;
  Data, sGold, sGameGold, sIncGold, sIncGameGold, sUseMax: PPlatfromString;
  pcm: TClientItem;
begin
  ABody := AnsiGetValidStr3(ABody, sGold, ['/']);
  ABody := AnsiGetValidStr3(ABody, sGameGold, ['/']);
  ABody := AnsiGetValidStr3(ABody, sIncGold, ['/']);
  ABody := AnsiGetValidStr3(ABody, sIncGameGold, ['/']);
  ABody := AnsiGetValidStr3(ABody, sUseMax, ['/']);
  g_nBoxGold := StrToIntDef(sGold, 0);
  g_nBoxGameGold := StrToIntDef(sGameGold, 0);
  g_nBoxIncGold := StrToIntDef(sIncGold, 0);
  g_nBoxIncGameGold := StrToIntDef(sIncGameGold, 0);
  g_nBoxsUseMax := StrToIntDef(sUseMax, 0);
  g_BoxsMoveDegree := 0;
  g_BoxsShowPosition := 8;
  i := 0;
  while True do
  begin
    if ABody = '' then
      Break;
    ABody := AnsiGetValidStr3(ABody, Data, ['/']);
    if Data <> '' then
    begin
      DecodeClientItem(Data, pcm);
      g_BoxsItems[i] := pcm;
      Inc(i);
      if i > 8 then
        Break;
    end
    else
      Break;
  end;
  if (AShap <> -1) and not FrmDlg.DBoxs.Visible then
  begin
    FrmDlg.DBoxsTautology.Visible := False;
    FrmDlg.DBoxs.SetImgIndex(g_WMain3Images, 520);
    FrmDlg.DBoxs.Left := (SCREENWIDTH - FrmDlg.DBoxs.Width) div 2;
    FrmDlg.DBoxs.Top := (SCREENHEIGHT - FrmDlg.DBoxs.Height) div 2;
    FrmDlg.BoxsRandomImg;
    g_BoxShape := AShap;
    g_boPutBoxsKey := True;
    g_nBoxsImg := 0;
    FrmDlg.DBoxs.Visible := True;
    g_SoundManager.MyPlaySound(Openbox_ground);
  end;
end;

procedure TfrmMain.ClientGetShuffle(const body: PPlatfromString);
begin
  DXDialogs.FrmDXDialogs.ShowBox(body);
end;

procedure TfrmMain.ClientGetMyMagics(body: PPlatfromString);
var
  i: Integer;
  Data: PPlatfromString;
  pcm: PTClientMagic;
begin
  if g_MagicList.count > 0 then
    // 20080629
    for i := 0 to g_MagicList.count - 1 do
      if PTClientMagic(g_MagicList[i]) <> nil then
        Dispose(PTClientMagic(g_MagicList[i]));
  g_MagicList.Clear;

  if g_InternalForceMagicList.count > 0 then
    for i := 0 to g_InternalForceMagicList.count - 1 do
      if PTClientMagic(g_InternalForceMagicList[i]) <> nil then
        Dispose(PTClientMagic(g_InternalForceMagicList[i]));
  g_InternalForceMagicList.Clear;

  while True do
  begin
    if body = '' then
      Break;
    body := AnsiGetValidStr3(body, Data, ['/']);
    if Data <> '' then
    begin
      New(pcm);
      FillChar(pcm^, SizeOf(TClientMagic), #0);
      DecodeBuffer(Data, PPlatfromChar(pcm), SizeOf(TClientMagic));
      case pcm.btType of
        0:
          g_MagicList.Add(pcm);
        1:
          g_InternalForceMagicList.Add(pcm); // 内功
        2:
          begin // 连击
            g_BatterMagicList.Add(pcm);
            AddMenuString(pcm.sMagicName);
          end
      end;
    end
    else
      Break;
  end;
end;

procedure TfrmMain.ClientGetMagicLvExp(magid, maglv, magtrain: Integer);
var
  i: Integer;
  bo123: Boolean;
  AMagic: PTClientMagic;
begin
  bo123 := False;
  if TryGetMagicByID(magid, AMagic) then
  begin
    AMagic.Level := maglv;
    AMagic.CurTrain := magtrain;
    bo123 := True;
  end;
  if not bo123 then
  begin
    if g_InternalForceMagicList.count > 0 then
      for i := g_InternalForceMagicList.count - 1 downto 0 do
      begin
        if PTClientMagic(g_InternalForceMagicList[i]).wMagicId = magid then
        begin
          PTClientMagic(g_InternalForceMagicList[i]).Level := maglv;
          PTClientMagic(g_InternalForceMagicList[i]).CurTrain := magtrain;
          bo123 := True;
          Break;
        end;
      end;
  end;
  if not bo123 then
  begin
    if g_BatterMagicList.count > 0 then
      // 20080629
      for i := g_BatterMagicList.count - 1 downto 0 do
      begin
        if PTClientMagic(g_BatterMagicList[i]).wMagicId = magid then
        begin
          PTClientMagic(g_BatterMagicList[i]).Level := maglv;
          PTClientMagic(g_BatterMagicList[i]).CurTrain := magtrain;
          bo123 := True;
          Break;
        end;
      end;
  end;
end;

procedure TfrmMain.ClientGetDuraChange(uidx, newdura, newduramax: Integer);
begin
  if uidx in [U_DRESS .. U_MAXUSEITEMIDX] then
  begin
    if g_UseItems[uidx].Name <> '' then
    begin
      g_UseItems[uidx].Dura := newdura;
      g_UseItems[uidx].DuraMax := newduramax;
    end;
  end;
end;

// 接收到的商人说的话
procedure TfrmMain.ClientGetMerchantSay(merchant, face: Integer;
  saying: string);
var
  npcname: string;
begin
  g_nMDlgX := g_MySelf.m_nCurrX;
  g_nMDlgY := g_MySelf.m_nCurrY;

  if g_nCurMerchant <> merchant then
  begin
    g_nCurMerchant := merchant;
    FrmDlg.ResetMenuDlg;
    FrmDlg.CloseMDlg(False);
    UIWindowManager.ResetItems;
  end;
  saying := GetValidStr3(saying, npcname, ['/']);
  FrmDlg.ShowMDlg(face, npcname, saying);
end;

procedure TfrmMain.ClientGetMerchantSayCustom(AType, AMerchant, AFace: Integer;
  AMessage: string);
var
  UIName, npcname: String;
  S:TStringList;
begin
  g_nMDlgX := g_MySelf.m_nCurrX;
  g_nMDlgY := g_MySelf.m_nCurrY;
  if g_nCurMerchant <> AMerchant then
  begin
    if AType = 1 then
      Exit;
    g_nCurMerchant := AMerchant;
    FrmDlg.ResetMenuDlg;
    FrmDlg.CloseMDlg(False);
    UIWindowManager.ResetItems;
  end;
  AMessage := GetValidStr3(AMessage, UIName, ['>']);
  AMessage := GetValidStr3(AMessage, npcname, ['/']);
  FrmDlg.ShowCustomMDlg(AMerchant, AType, AFace, UIName, npcname, AMessage);

//  S:= TStringList.Create;
//  Try
//    S.Text := AMessage;
//    S.SaveToFile('D:\91Debug\' + IntToStr(GetTickCount) + '.txt');
//  Finally
//    S.Free;
//  End;
end;

procedure TfrmMain.ClientGetCloseWindow(const AUIName: String);
var
  AWindow: TuDWindow;
begin
  if UIWindowManager.TryGet(AUIName, AWindow) then
    AWindow.Visible := False;
end;

// 接收到的商人出售商品的列表
procedure TfrmMain.ClientGetSendGoodsList(merchant, count: Integer;
  body: PPlatfromString);
var
  gname, gsub, gprice, gstock, gClientItem: PPlatfromString;
  pcg: PTClientGoods;
begin
  FrmDlg.ResetMenuDlg;
  g_nCurMerchant := merchant;
  FrmDlg.DLVGoods.Clear;
  with FrmDlg do
  begin
    while body <> '' do
    begin
      body := AnsiGetValidStr3(body, gname, ['/']);
      body := AnsiGetValidStr3(body, gsub, ['/']);
      body := AnsiGetValidStr3(body, gprice, ['/']);
      body := AnsiGetValidStr3(body, gstock, ['/']);
      if (gname <> '') and (gprice <> '') and (gstock <> '') then
      begin
        New(pcg);
        pcg.Item.Name := '';
        pcg.Item.MakeIndex := -1;
        pcg.Name := EdCode.DecodeString(gname); // 商品名称
        pcg.SubMenu := StrToIntDef(gsub, 0); // 子菜单
        pcg.Price := StrToIntDef(gprice, 0); // 价格
        pcg.Stock := StrToIntDef(gstock, 0); // 数量
        pcg.Grade := -1; // 等级
        //MenuList.Add(pcg);
        if pcg.SubMenu = 0 then
        begin
          body := AnsiGetValidStr3(body, gClientItem, ['/']);
          DecodeClientItem(gClientItem, pcg.Item);
        end;


        with FrmDlg.DLVGoods.Add do
        begin
          SubStrings.Add(pcg.Name);
          SubStrings.Add(gprice + ' 金币');
          if pcg.SubMenu = 0 then
            SubStrings.Add(IntToStr(pcg.Item.Dura div 1000));
          Data := pcg;
        end;
      end
      else
        Break;
    end;
    FrmDlg.ShowShopMenuDlg;
    FrmDlg.CurDetailItem := '';
  end;
end;

procedure TfrmMain.ClientGetSendMakeDrugList(merchant: Integer;
  body: PPlatfromString);
var
  gname, gsub, gprice, gstock: PPlatfromString;
  pcg: PTClientGoods;
begin
  FrmDlg.ResetMenuDlg;

  g_nCurMerchant := merchant;
  with FrmDlg do
  begin
    while body <> '' do
    begin
      body := AnsiGetValidStr3(body, gname, ['/']);
      body := AnsiGetValidStr3(body, gsub, ['/']);
      body := AnsiGetValidStr3(body, gprice, ['/']);
      body := AnsiGetValidStr3(body, gstock, ['/']);
      if (gname <> '') and (gprice <> '') and (gstock <> '') then
      begin
        New(pcg);
        pcg.Name := EdCode.DecodeString(gname);
        pcg.SubMenu := StrToIntDef(gsub, 0);
        pcg.Price := StrToIntDef(gprice, 0);
        pcg.Stock := StrToIntDef(gstock, 0);
        pcg.Grade := -1;
        //MenuList.Add(pcg);
      end
      else
        Break;
    end;
    FrmDlg.ShowShopMenuDlg;
    FrmDlg.CurDetailItem := '';
    FrmDlg.BoMakeDrugMenu := True;
  end;
end;

procedure TfrmMain.ClientGetSendUserSell(merchant: Integer);
begin
  FrmDlg.CloseDSellDlg;
  g_nCurMerchant := merchant;
  FrmDlg.SpotDlgMode := dmSell;
  FrmDlg.ShowShopSellDlg;
end;

procedure TfrmMain.ClientGetSendUserRepair(merchant: Integer);
begin
  FrmDlg.CloseDSellDlg;
  g_nCurMerchant := merchant;
  FrmDlg.SpotDlgMode := dmRepair;
  FrmDlg.ShowShopSellDlg;
end;

procedure TfrmMain.ClientGetSendUserStorage(merchant: Integer;
  IsBigStore: Boolean);
begin
  FrmDlg.CloseDSellDlg;
  g_nCurMerchant := merchant;
  g_boBigStore := IsBigStore;
  FrmDlg.SpotDlgMode := dmStorage;
  FrmDlg.ShowShopSellDlg;
end;

procedure TfrmMain.ClientGetSaveItemList(merchant, nType: Integer;
  bodystr: PPlatfromString);
var
  i: Integer;
  Data: PPlatfromString;
  pcg: PTClientGoods;
  ADura100: Boolean;
  Item : TClientItem;
begin
  FrmDlg.ResetMenuDlg;
  with FrmDlg do
  begin
    for I := 0 to DLVSaveItems.Items.Count - 1 do
    begin
      Dispose(PTClientItem(DLVSaveItems.Items[i].Data));
    end;
    DLVSaveItems.Clear;
  end;


  while True do
  begin
    if bodystr = '' then
      Break;
    bodystr := AnsiGetValidStr3(bodystr, Data, ['/']);
    if Data <> '' then
    begin
      DecodeClientItem(Data, Item);
      New(pcg);
      pcg.Name := Item.Name;
      pcg.Item := Item;
      pcg.SubMenu := 0;
      pcg.Price := Item.MakeIndex;

      ADura100 := False;
      case Item.S.StdMode of
        2:
          ADura100 := Item.S.Shape = 9;
        25:
          ADura100 := True;
      end;
      if ADura100 then
      begin
        pcg.Stock := Round(Item.Dura / 100);
        pcg.Grade := Round(Item.DuraMax / 100);
      end
      else
      begin
        pcg.Stock := Round(Item.Dura / 1000);
        pcg.Grade := Round(Item.DuraMax / 1000);
      end;

      with FrmDlg.DLVSaveItems.Add do
      begin
        SubStrings.Add(pcg.Name);
        SubStrings.Add(IntToStr(pcg.Stock) + '/' + IntToStr(Pcg.Grade));
        SubStrings.Add('1');
        Data := pcg;
      end;
    end
    else
      Break;
  end;

  with FrmDlg do
  begin
    if nType = 1 then
      ShowStorgeDlg()
    else
      ShowStorgeDlg();
  end;
end;

procedure TfrmMain.ClientGetSendDetailGoodsList(merchant, count,
  topline: Integer; bodystr: PPlatfromString);
var
  i: Integer;
  Data: PPlatfromString;
  pcg: PTClientGoods;
  pc: PTClientItem;
  ADura100: Boolean;
begin
  FrmDlg.ResetMenuDlg;
  g_nCurMerchant := merchant;
  while True do
  begin
    if bodystr = '' then
      Break;
    bodystr := AnsiGetValidStr3(bodystr, Data, ['/']);
    if Data <> '' then
    begin
      New(pc);
      DecodeClientItem(Data, pc^);
      g_MenuItemList.Add(pc);
    end
    else
      Break;
  end;


  with FrmDlg do
  begin
    DLVGoods.Clear;
    if g_MenuItemList.count > 0 then
      for i := 0 to g_MenuItemList.count - 1 do
      begin
        New(pcg);
        pcg.Name := PTClientItem(g_MenuItemList[i]).Name;
        pcg.SubMenu := 0;
        pcg.Price := PTClientItem(g_MenuItemList[i]).S.Price;
        pcg.Stock := PTClientItem(g_MenuItemList[i]).MakeIndex;
        pcg.Item := PTClientItem(g_MenuItemList[i])^;
        if PTClientItem(g_MenuItemList[i]).S.StdMode in [] then
          pcg.Grade := -1
        else
        begin
          ADura100 := False;
          case PTClientItem(g_MenuItemList[i]).S.StdMode of
            2:
              ADura100 := PTClientItem(g_MenuItemList[i]).S.Shape = 9;
            25:
              ADura100 := True;
          end;
          if ADura100 then
            pcg.Grade := Round(PTClientItem(g_MenuItemList[i]).DuraMax / 100)
          else
            pcg.Grade := Round(PTClientItem(g_MenuItemList[i]).DuraMax / 1000);
        end;
      //  MenuList.Add(pcg);

        with DLVGoods.Add do
        begin
          SubStrings.Add(Pcg.Name);
          SubStrings.Add(IntToStr(pcg.Price) + ' 金币');
          SubStrings.Add(IntToStr(pcg.Grade));
          Data := pcg;
        end;
      end;
    FrmDlg.ShowShopMenuDlg;
    FrmDlg.BoDetailMenu := True;
    FrmDlg.MenuTopLine := topline;
  end;
end;

procedure TfrmMain.ClientGetSendNotice(const body: PPlatfromString);
var
  ABody, Data, MsgStr: string;
begin
  g_boDoFastFadeOut := False;
  if not FTryReconnet then
  begin
    MsgStr := '';
    ABody := EdCode.DecodeString(body);
    while True do
    begin
      if ABody = '' then
        Break;
      ABody := GetValidStr3(ABody, Data, [#27]);
      MsgStr := MsgStr + Data + '\';
    end;

    FrmDlg.FDlgMessage.Clear;
    FrmDlg.FDlgMessage.Parse(MsgStr);
    FrmDlg.DLoginNotice.Visible := True;
    SetDFocus(FrmDlg.DLoginNotice);
  end
  else
  begin
    SendClientMessage(CM_LOGINNOTICEOK, 0, 0, 0, 0);
    ChangeServerClearGameVariables;
  end;
  FTryReconnet := False;
end;

procedure TfrmMain.ClientGetGroupMembers(Msg: TDefaultMessage; bodystr: string);
var
  memb: string;
  AGroupUser: PTGroupUser;
  i: Integer;
begin
  for i := 0 to g_GroupMembers.count - 1 do
    if g_GroupMembers[i] <> nil then
      Dispose(g_GroupMembers[i]);
  g_GroupMembers.Clear;
  g_ISGroupMaster := False;

  while True do
  begin
    if bodystr = '' then
      Break;
    bodystr := GetValidStr3(bodystr, memb, ['/']);
    if memb <> '' then
    begin
      New(AGroupUser);
      EdCode.DecodeBuffer(memb, PAnsiChar(AGroupUser), SizeOf(TGroupUser));
      g_GroupMembers.Add(AGroupUser);
    end
    else
      Break;
  end;
  if g_GroupMembers.count > 0 then
    g_ISGroupMaster := g_GroupMembers[0].UserName = g_MySelf.m_sUserName;
  FrmDlg.ReBuildGropuUI;
  if g_Config.Assistant.ShowGroupHead then
    FrmDlg.ReBuildGroupHeadUI;
end;

procedure TfrmMain.ClientGetOpenGuildDlg(const bodystr: PPlatfromString);
begin
  g_Guild.Load(EdCode.DecodeString(bodystr));
  FrmDlg.ShowGuildDlg;
end;

procedure TfrmMain.ClientGetOpenUI(const body: String);
begin
  FrmDlg.OpenUI(body);
end;

procedure TfrmMain.ClientGetSendGuildMemberList(const body: PPlatfromString);
begin
  g_Guild.LoadRankList(EdCode.DecodeString(body));
end;

procedure TfrmMain.RunTimerTimer(Sender: TObject);
const
  _Direction_Str: array [DR_UP .. DR_UPLEFT] of String = ('↑', '↗', '→', '↘',
    '↓', '↙', '←', '↖');
var
  i: Integer;
  T: PPoint;
  AActor: TActor;
  ADirection: Byte;
  AList: TList;
begin
  if GetTickCount - FCheckLibTime > CHECK_FREE_TEXTURE_INTERVAL then
  begin
    LibManager.FreeMemory;
    FCheckLibTime := GetTickCount;
  end;

  if FTryReconnet then
    Exit;
  if g_MySelf <> nil then
  begin
    if GetTickCount - FTransDataTime > 1000 then
      SendHeartbeat;
    FAutoRunner.Run;
    // 动喊话
    if g_boAutoTalk then
    begin
      if (GetTickCount - g_nAutoTalkTimer) > 10000 then
      begin
        SendSay(g_sAutoTalkStr);
        g_nAutoTalkTimer := GetTickCount;
      end;
    end;

    if g_boLockMoveItem and (g_nLockMoveItemTime > 0) then
    begin
      if GetTickCount - g_dwLockMoveItemTimeStart > g_nLockMoveItemTime then
        g_boLockMoveItem := False;
    end;

    AList := PlayScene.m_FreeActorList.LockList;
    try
      for i := AList.count - 1 downto 0 do
      begin
        if GetTickCount - TActor(AList[i]).m_dwDeleteTime > 60000 then
        begin
          try
            TActor(AList[i]).Free;
          except
          end;
          AList.Delete(i);
        end;
      end;
    finally
      PlayScene.m_FreeActorList.UnlockList;
    end;

    if g_uAutoRun then
    begin
      try
        if ServerAcceptNextAction then
        begin
          g_ChrAction := caRun;
          if g_uPointList.count = 0 then
          begin
            g_uAutoRun := False;
            Exit;
          end;

          T := g_uPointList.Items[0];
          if (g_MySelf.m_nCurrX = T.X) and (g_MySelf.m_nCurrY = T.Y) then
          begin
            Dispose(T);
            g_uPointList.Delete(0);
          end;
          if g_uPointList.count = 0 then
          begin
            g_uAutoRun := False;
            if not g_boISTrail then
              AddChatBoardString('到达目标', GetRGB(178), clWhite);
            Exit;
          end;
          T := g_uPointList.Items[0];
          g_nAutoRunx := T.X;
          if g_nAutoRunx = -1 then
            g_nAutoRunx := -1;
          g_nAutoRuny := T.Y;
          Autorun;
        end;
      except
      end;
    end;
    if g_MirStartupInfo.AssistantKind = 1 then
    begin
      if GetTickCount - FBoosTraceTime > g_Config.Assistant.MonHintInterval
        * 1000 then
      begin
        try
          AList := PlayScene.m_ActorList.LockList;
          try
            for i := AList.count - 1 downto 0 do
            begin
              AActor := AList[i];
              if not((AActor.Race in [0, 1, 150, 151, 152, 153, 50]) or
                AActor.m_boFriendly or AActor.m_boDeath or
                AActor.m_boDelActor) then
              begin
                if g_Config.Assistant.MonHints.IndexOf(AActor.m_sUserName)
                  <> -1 then
                begin
                  ADirection := GetNextDirection(g_MySelf.m_nCurrX,
                    g_MySelf.m_nCurrY, AActor.m_nCurrX, AActor.m_nCurrY);
                  if ADirection in [DR_UP .. DR_UPLEFT] then
                    AddChatBoardString(Format('[提示]发现"%s"(坐标%d,%d，方向%s)',
                      [AActor.m_sUserName, AActor.m_nCurrX, AActor.m_nCurrY,
                      _Direction_Str[ADirection]]), clBlue, clYellow);
                end;
              end;
            end;
          finally
            PlayScene.m_ActorList.UnlockList;
          end;
        except
        end;
        FBoosTraceTime := GetTickCount;
      end;
    end;
  end;
end;

procedure TfrmMain.ClientGetDealRemoteAddItem(const body: PPlatfromString);
var
  ci: TClientItem;
begin
  if body <> '' then
  begin
    DecodeClientItem(body, ci);
    AddDealRemoteItem(ci);
  end;
end;

procedure TfrmMain.ClientGetDealRemoteDelItem(const body: PPlatfromString);
var
  ci: TClientItem;
begin
  if body <> '' then
  begin
    DecodeClientItem(body, ci);
    DelDealRemoteItem(ci);
  end;
end;

procedure TfrmMain.ClientGetReadMiniMap(mapindex: Integer);
begin
  if mapindex >= 1 then
  begin
    g_boViewMiniMap := True;
    g_boMiniMapExpand := True;
    if not g_boSDMinimap then
    FrmDlg.DBMiniMapImage.visible := True;
    g_nMiniMapIndex := mapindex - 1;
    FrmDlg.ShowMap;
  end;
end;

procedure TfrmMain.ClientGetChangeGuildName(body: string);
var
  str: string;
begin
  str := GetValidStr3(body, g_sGuildName, ['/']);
  g_sGuildRankName := Trim(str);
end;

procedure TfrmMain.ClientGetSendUserState(const body: PPlatfromString);
var
  UserState: TUserStateInfo;
begin
  DecodeBuffer(body, @UserState, SizeOf(TUserStateInfo));
  UserState.NameColor := GetRGB(UserState.NameColor);
  FrmDlg.OpenUserState(UserState);
end;

procedure TfrmMain.DrawEffectHum(nType, nX, nY: Integer);
var
  Effect: TNormalDrawEffect;
  bo15: Boolean;
begin
  Effect := nil;
  case nType of
    0:
      begin
      end;
    1:
      Effect := TNormalDrawEffect.Create(nX, nY,
        { WMon14Img20080720注释 }
        g_WMonImagesArr[13], 410, 6, 120, False);
    2:
      Effect := TNormalDrawEffect.Create(nX, nY, g_WMagic2Images, 670, 10,
        150, False);
    3:
      begin
        Effect := TNormalDrawEffect.Create(nX, nY, g_WMagic2Images, 690, 10,
          150, False);
        g_SoundManager.DXPlaySound(48);
      end;
    4:
      begin
        PlayScene.NewMagic(nil, 70, 70, 0, 0, nX, nY, nX, nY, 0, mtThunder,
          False, 30, bo15);
        g_SoundManager.DXPlaySound(8301);
      end;
    5:
      begin
        PlayScene.NewMagic(nil, 71, 71, 0, 0, nX, nY, nX, nY, 0, mtThunder,
          False, 30, bo15);
        PlayScene.NewMagic(nil, 72, 72, 0, 0, nX, nY, nX, nY, 0, mtThunder,
          False, 30, bo15);
        g_SoundManager.DXPlaySound(8302);
      end;
    6:
      begin
        PlayScene.NewMagic(nil, 73, 73, 0, 0, nX, nY, nX, nY, 0, mtThunder,
          False, 30, bo15);
        g_SoundManager.DXPlaySound(8207);
      end;
    7:
      begin
        PlayScene.NewMagic(nil, 74, 74, 0, 0, nX, nY, nX, nY, 0, mtThunder,
          False, 30, bo15);
        g_SoundManager.DXPlaySound(8226);
      end;
    10:
      begin // 红闪电
        PlayScene.NewMagic(nil, 80, 80, 0, 0, nX, nY, nX, nY, 0, mtRedThunder,
          False, 30, bo15);
        g_SoundManager.DXPlaySound(8301);
      end;
    11:
      begin // 岩浆
        PlayScene.NewMagic(nil, 91, 91, 0, 0, nX, nY, nX, nY, 0, mtLava, False,
          30, bo15);
        g_SoundManager.DXPlaySound(8302);
      end;
    12:
      begin // 火龙守护兽发出的魔法效果
        PlayScene.NewMagic(nil, 92, 92, 0, 0, nX, nY, nX, nY, 0, mtLava, False,
          30, bo15);
      end;
  end;

  if Effect <> nil then
  begin
    Effect.MagOwner := g_MySelf;
    PlayScene.m_EffectList.Add(Effect);
  end;
end;
{$IFDEF DEBUG}

procedure TfrmMain.DumpSocket;
var
  sList: TStringList;
  sFileName: string;
  i: Integer;
begin
  sList := TStringList.Create;
  for i := 0 to High(Word) do
  begin
    if g_SocketIdent[i] > 0 then
    begin
      sList.Add(Format('%d %d %d', [i, g_SocketIdent[i], g_SocketLength[i]]));
    end;
  end;
  sFileName := ExtractFilePath(ParamStr(0)) + 'SocketDump.txt';
  try
    sList.SaveToFile(sFileName);
  finally
    sList.Free;
  end;

end;
{$ENDIF}

procedure TfrmMain.ClientGetNeedPassword(const body: String);
begin
  FrmDlg.DChgGamePwd.Visible := True;
end;

procedure TfrmMain.SendPassword(const sPassword: String; nIdent: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_PASSWORD, 0, nIdent, 0, 0, Certification);
  SendSocket((Msg), EdCode.EncodeString(sPassword));
end;

procedure TfrmMain.SendOpenRefineBox;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_OPENREFINEBOX, 0, 0, 0, 0, Certification);
  SendSocket((Msg), '');
end;

procedure TfrmMain.SetInputStatus;
begin
  if m_boPasswordIntputStatus then
  begin
    m_boPasswordIntputStatus := False;
    FrmDlg.DEChat.PasswordChar := #0;
  end
  else
  begin
    m_boPasswordIntputStatus := True;
    FrmDlg.DEChat.PasswordChar := '*';
    SetDFocus(FrmDlg.DEChat);
  end;
end;

procedure TfrmMain.ClientGetServerConfig(Msg: TDefaultMessage;
  const sBody: PPlatfromString);
var
  sBody1: string;
begin
  g_DeathColorEffect := TColorEffect(_MIN(Lobyte(Msg.Param), 8)); // 屏幕死亡颜色
  sBody1 := EdCode.DecodeString(sBody);
  DecodeBuffer(sBody1, @ClientConf, SizeOf(ClientConf));
  g_boDropBindFree := ClientConf.boDropBindFree;
  g_boAddPointEnabled := ClientConf.boAddPointEnabled;
  g_boSoulEnabled := ClientConf.boSoulEnabled;
  g_boHoleEnabled := ClientConf.boHoleEnabled;
  g_boUpgradeEnabled := ClientConf.boUpgradeEnabled;
  g_boAllowDeal := ClientConf.boAllowDeal;
  SetAllowGroup(ClientConf.boAllowGroup);
  g_boAllowGuild := ClientConf.boAllowGuild;
  g_boAllowGroupRecall := ClientConf.boAllowGroupReCall;
  g_boAllowGuildRecall := ClientConf.boAllowGuildReCall;
  g_boAllowReAlive := ClientConf.boAllowReAlive;
  g_boShowFashion := ClientConf.boShowFashion;
  g_boSDMinimap := ClientConf.boSDMinimap;
  g_boAutoUseSkill150 := ClientConf.boAutoSkill150;
  g_boMiniMapExpand := not ClientConf.boSDMinimap;
  g_boEnableItemBasePower := ClientConf.boEnableItemBasePower;
  g_nShowMagBubbleLevel := ClientConf.nShowMagBubbleLevel;
  g_nMaxGroupCount := ClientConf.btMaxGroupMember;
  g_dwUseItemInterval := ClientConf.dwUseItemInterval;
  g_dwUseDrugInterval := ClientConf.dwUseDrugInterval;

  FrmDlg.DWMiniMap.Visible := False;
  FrmDlg.DMiniMap_SD.Visible := False;

  if g_boSDMinimap then
  begin
    FrmDlg.DMiniMap_SD.Visible := True;
    FrmDlg.ResetSDMiniMapSizeAndPosition(g_btMiniMapType);
  end else
  begin
    FrmDlg.DWMiniMap.Visible := True;
  end;

  FrmDlg.DStallCtrl.Visible := ClientConf.boEnableStall;
  g_boDiableSTRUCK := ClientConf.boEnableStruck;

  Move(ClientConf.btAddLevelCondition[0], g_AddLevelCondition[0],
    SizeOf(TAddLevelCondition));
  ChangeClientSpeed(ClientConf.btSpeed);

  if not g_Config.Loaded or (g_Config.CharName <> CharName) then
  begin
    g_Config.Clear;
    g_Config.Load(CharName, ClientConf.boNewHum);
  end;

  g_SoundManager.SetBGSoundVolume(g_Config.Assistant.BGSoundVolume);
  g_SoundManager.SetSoundVolume(g_Config.Assistant.SoundVolume);
  FrmDlg.ShowMissionControl(ClientConf.boEnableMission);
  g_boCanUseSmartWalk := ClientConf.boClientUseSmartWalk;
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  pm: PTClientMagic;
begin
  case Key of
    VK_SNAPSHOT:
      begin // 拷贝屏幕
        Key := 0;
        PrintScreenNow();
        Exit;
      end;
  end;

  if FTryReconnet then
    Exit;
  if (Key >= 112) and (Key < 119) and g_Config.Assistant.AutoMagic then
  begin
    pm := GetMagicByKey(PPlatfromChr(Key - VK_F1 + Byte('1')));
    if pm <> nil then
    begin
      // 自动练功
      if pm.wMagicId in [12, 25] then
        Exit;
      g_nAutoMagicKey := Key;
      AddChatBoardString('自动练功开始 (再按一下这个魔法的快捷健停止自动练功)', clGreen, clWhite);
    end;
  end;
end;

procedure TfrmMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FTryReconnet then
    Exit;
  g_nRunReadyCount := 0;
  X := Round(SCREENWIDTH / ClientWidth * X);
  Y := Round(SCREENHEIGHT / ClientHeight * Y);
  _DXDrawMouseDown(Sender, Button, Shift, X, Y);
end;

procedure TfrmMain.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  mx, my, sel, nX, nY: Integer;
  target: TActor;
  itemnames, sRealItemName: string;
  rc: TRect;
begin
  if FTryReconnet then
    Exit;
  X := Round(SCREENWIDTH / ClientWidth * X);
  Y := Round(SCREENHEIGHT / ClientHeight * Y);
  g_boXYChanged := (g_OldPixeX <> X) or (g_OldPixeY <> Y);
  g_OldPixeX := X;
  g_OldPixeY := Y;
  if g_DWinMan.MouseMove(Shift, X, Y) then
  begin
    if DWinCtl.MouseControl <> DWinCtl.LastMouseControl then
      DScreen.ClearHint;
    DWinCtl.LastMouseControl := DWinCtl.MouseControl;
    Exit;
  end;

  if (g_MySelf = nil) or (DScreen.CurrentScene <> PlayScene) then
    Exit;

  g_boSelectMyself := PlayScene.IsSelectMyself(X, Y);

  target := PlayScene.GetAttackFocusCharacter(X, Y, g_nDupSelection,
    sel, False);
  if g_nDupSelection <> sel then
    g_nDupSelection := 0;
  if target <> nil then
  begin
    if (not target.m_boGateMan) and (target.m_sUserName = '') and
      (GetTickCount - target.m_dwSendQueryUserNameTime > 10 * 1000) then
    begin
      target.m_dwSendQueryUserNameTime := GetTickCount;
      SendQueryUserName(target.m_nRecogId, target.m_nCurrX, target.m_nCurrY);
    end;
    g_FocusCret := target;
  end
  else
    g_FocusCret := nil;

  g_FocusItem := PlayScene.GetDropItems(X, Y, itemnames);
  if g_FocusItem <> nil then
  begin
    nY := 1 - g_MySelf.m_nShiftY mod 2;
    GetValidStr2(itemnames, sRealItemName, ['\']);
    nX := Round(FontManager.Default.TextWidth(sRealItemName) / 2);
    // nY := FontManager.Default.TextHeight(itemnames) div 2 ;
    PlayScene.ScreenXYfromMCXY(g_FocusItem.X, g_FocusItem.Y, mx, my);
    DScreen.ShowHint(mx - nX - 4, my - UNITY + 8, 4, itemnames);
  end
  else
    DScreen.ClearHint;

  PlayScene.CXYfromMouseXY(X, Y, g_nMouseCurrX, g_nMouseCurry);
  g_nMouseX := X;
  g_nMouseY := Y;
  g_MouseItem.Name := '';

  g_nMouseMinMapX := 0;
  g_nMouseMinMapY := 0;
  FrmDlg.DMouseXYMiniMap.Propertites.Caption.Text := '';

  if ((ssLeft in Shift) or (ssRight in Shift)) and
    (GetTickCount - MouseDownTime > 50) and
    (GetTickCount - g_dwLastDropItem > 500) then
    _DXDrawMouseDown(Self, mbLeft, Shift, X, Y);
end;

procedure TfrmMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FTryReconnet then
    Exit;
  X := Round(SCREENWIDTH / ClientWidth * X);
  Y := Round(SCREENHEIGHT / ClientHeight * Y);
  g_boActionLock := False;
  if g_DWinMan.MouseUp(Button, Shift, X, Y) then
    Exit;
  g_boActionLock := False;
  if g_TargetCret <> nil then
  begin
    g_nTargetX := g_TargetCret.m_nCurrX;
    g_nTargetY := g_TargetCret.m_nCurrY;
  end
  else
    g_nTargetX := -1;
end;

procedure TfrmMain.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if FTryReconnet then
    Exit;
  MousePos := ScreenToClient(MousePos);
  Handled := g_DWinMan.MouseWheelDown(Shift, MousePos);
end;

procedure TfrmMain.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if FTryReconnet then
    Exit;
  MousePos := ScreenToClient(MousePos);
  Handled := g_DWinMan.MouseWheelUp(Shift, MousePos);
end;

procedure TfrmMain.TurnDuFu(AMagic: PTClientMagic; AClient: TuMagicClient);
var
  AItem: TClientItem;
  i: Integer;
  AShape, Acount: Integer;
begin
  if g_WaitingUseItem.Item.Name <> '' then
    Exit;

  Acount := 0;
  if AClient <> nil then
  begin
    if AClient.NeedBujuk then
    begin
      Acount := AClient.NeedBujukCount;
      if g_nDuFuIndex > High(AClient.BujukShapes) then
        g_nDuFuIndex := 0;
      AShape := AClient.BujukShapes[g_nDuFuIndex];
      Inc(g_nDuFuIndex);
    end;
  end
  else
  begin
    if AMagic.wMagicId in [SKILL_AMYOUNSUL, SKILL_93,
      SKILL_GROUPAMYOUNSUL] then
    begin
      if g_nDuwhich = 1 then
        g_nDuwhich := 2
      else
        g_nDuwhich := 1;
      Acount := 1;
      AShape := g_nDuwhich;
    end
    else
    begin
      AShape := 5;
      if AMagic.wMagicId in [SKILL_SINSU, SKILL_SACRED, SKILL_72] then
        Acount := 5
      else if AMagic.wMagicId in [SKILL_FIRECHARM { 13 } ,
        SKILL_HANGMAJINBUB { 14 } , SKILL_DEJIWONHO { 15 } ,
        SKILL_HOLYSHIELD { 16 } , SKILL_SKELLETON { 17 } , SKILL_CLOAK { 18 } ,
        SKILL_BIGCLOAK { 19 } , SKILL_52, { 52 } SKILL_94 { 94 } , SKILL_57,
        SKILL_59] then
        Acount := 1;
    end;
  end;
  if Acount = 0 then
    Exit;

  AItem := g_UseItems[U_BUJUK];
  if (AItem.S.StdMode = 25) and (AItem.S.Shape = AShape) then
    Exit; // 如果是相同的毒或符就退出

  g_WaitingUseItem.FromIndex := U_BUJUK;
  for i := 6 to MAXBAGITEM - 1 do
  begin
    if (g_ItemArr[i].S.StdMode = 25) and (g_ItemArr[i].S.Shape = AShape) and
      (g_ItemArr[i].Dura > Acount * 100) then
    begin
      SendTakeOnItem(g_WaitingUseItem.FromIndex, g_ItemArr[i].MakeIndex,
        g_ItemArr[i].Name);
      g_WaitingUseItem.Item := g_ItemArr[i];
      g_ItemArr[i].Name := '';
      ArrangeItemBag;
      Exit;
    end;
  end;
end;

procedure TfrmMain.CMDialogKey(var Msg: TCMDialogKey);
begin
  if Msg.Charcode = VK_TAB then
  begin
    if (ActiveControl <> nil) and (ActiveControl is TWinControl) then
      inherited;
  end
  else
    inherited
end;

// 元宝寄售显示窗口 20080316
procedure TfrmMain.ClientGetSendUserSellOff(merchant: Integer);
begin
  FrmDlg.CloseMDlg(False);
  g_nCurMerchant := merchant;
  FrmDlg.ShowShopSellOffDlg;
end;

// 客户端寄售查询购买物品 20080317
procedure TfrmMain.ClientGetSellOffMyItem(const body: PPlatfromString);
begin
  FillChar(g_SellOffInfo, SizeOf(TClientDealOffInfo), #0);
  DecodeBuffer(body, @g_SellOffInfo, SizeOf(TClientDealOffInfo));
  FrmDlg.ShowSellOffListDlg;
end;

// 客户端寄售查询出售物品 20080317
procedure TfrmMain.ClientGetSellOffSellItem(const body: PPlatfromString);
begin
  FillChar(g_SellOffInfo, SizeOf(TClientDealOffInfo), #0);
  DecodeBuffer(body, @g_SellOffInfo, SizeOf(TClientDealOffInfo));
  FrmDlg.ShowSellOffListDlg;
end;
{ ****************************************************************************** }

procedure TfrmMain.SendItemUpOK();
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_REFINEITEM, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(IntToStr(g_ItemsUpItem[0].MakeIndex) + '/'
    + IntToStr(g_ItemsUpItem[1].MakeIndex) + '/' +
    IntToStr(g_ItemsUpItem[2].MakeIndex)));
end;

// 更新粹练物品! 20080507
procedure TfrmMain.ClientGetUpDateUpItem(body: PPlatfromString);
var
  cu: TClientItem;
  i: Integer;
  str: PPlatfromString;
begin
  FillChar(g_ItemsUpItem[0], ClientItemSize * 3, #0); // 清空淬炼格里的物品
  while True do
  begin
    if body = '' then
      Break;
    for i := Low(g_ItemsUpItem) to High(g_ItemsUpItem) do
    begin
      body := AnsiGetValidStr3(body, str, ['/']);
      DecodeClientItem(str, cu);
      g_ItemsUpItem[i] := cu;
    end;
  end;
end;

procedure TfrmMain.ClientGetAssessMentHeroInfo(body: string);
var
  cu: TAssessHeroDataInfo;
  i: Integer;
  str: string;
begin
  FillChar(g_AssessHeroDataInfo, SizeOf(TAssessHeroDataInfo) * 2, #0);
  // 20100306
  while True do
  begin
    if body = '' then
      Break;
    for i := Low(g_AssessHeroDataInfo) to High(g_AssessHeroDataInfo) do
    begin
      body := GetValidStr3(body, str, ['/']);
      DecodeBuffer(str, @cu, SizeOf(TAssessHeroDataInfo));
      g_AssessHeroDataInfo[i] := cu;
    end;
  end;
end;

// 发送取回英雄信息 发送到M2 20080514
procedure TfrmMain.SendSelHeroName(btType: Byte; SelHeroName: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SELGETHERO, btType, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(SelHeroName));
end;

// 请酒
procedure TfrmMain.ClientGetSendUserPlayDrink(merchant: Integer);
begin
  FrmDlg.CloseDSellDlg;
  g_nCurMerchant := merchant;
  FrmDlg.SpotDlgMode := dmPlayDrink;
  FrmDlg.ShowShopSellDlg;
end;

// 发送要存放的物品
procedure TfrmMain.SendPlayDrinkItem(merchant, itemindex: Integer;
  itemname: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_USERPLAYDRINKITEM, merchant, Loword(itemindex),
    Hiword(itemindex), 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(itemname));
end;

// 接收斗酒说的话
procedure TfrmMain.ClientGetPlayDrinkSay(merchant, who: Integer;
  saying: string);
begin
  if g_nCurMerchant <> merchant then
  begin
    g_nCurMerchant := merchant;
  end;

  FrmDlg.ShowPlayDrink(who, saying);
end;

procedure TfrmMain.SendPlayDrinkDlgSelect(merchant: Integer; rstr: string);
var
  Msg: TDefaultMessage;
  i: Integer;
begin
  if Length(rstr) >= 2 then
  begin
    if (rstr[1] = '@') and (rstr[2] = '@') and (rstr[3] = '@') then
    begin
      frmMain.ClientGetPlayDrinkSay(g_nCurMerchant, 2, '这坛酒给谁喝好呢？');
      if rstr = '@@@对方' then
        SendDrinkUpdateValue(g_nCurMerchant, 1, 1);
      if rstr = '@@@自己' then
        SendDrinkUpdateValue(g_nCurMerchant, 0, 1);
      if g_btPlaySelDrink = 0 then
      begin
        FrmDlg.DDrink1.Visible := False;
      end;
      if g_btPlaySelDrink = 1 then
      begin
        FrmDlg.DDrink2.Visible := False;
      end;
      if g_btPlaySelDrink = 2 then
      begin
        FrmDlg.DDrink4.Visible := False;
      end;
      if g_btPlaySelDrink = 3 then
      begin
        FrmDlg.DDrink6.Visible := False;
      end;
      if g_btPlaySelDrink = 4 then
      begin
        FrmDlg.DDrink5.Visible := False;
      end;
      if g_btPlaySelDrink = 5 then
      begin
        FrmDlg.DDrink3.Visible := False;
      end;
      if g_NpcRandomDrinkList.count > 0 then
        // 20080629
        for i := 0 to g_NpcRandomDrinkList.count - 1 do
        begin
          if Integer(g_NpcRandomDrinkList[i]) = g_btPlaySelDrink then
          begin
            g_NpcRandomDrinkList.Delete(i);
            Break;
          end;
        end;
    end
    else
    begin
      Msg := MakeDefaultMsg(CM_PlAYDRINKDLGSELECT, merchant, 0, 0, 0,
        Certification);
      SendSocket(Msg, EdCode.EncodeString(rstr));
    end;
  end;
end;

// 发送猜拳码数
procedure TfrmMain.SendPlayDrinkGame(nParam1, GameNum: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_PlAYDRINKGAME, nParam1, GameNum, 0, 0,
    Certification);
  SendSocket(Msg, '');
end;

// 喝酒并增加醉酒值 20080517
// 参数:nPlayNum--谁喝酒(0-玩家喝 1-NPC喝)  nCode--谁赢(0-NPC 1-玩家)
// 参数:nParam1--为NPC ID号
procedure TfrmMain.SendDrinkUpdateValue(nParam1: Integer;
  nPlayNum, nCode: Byte);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_DrinkUpdateValue, nParam1, nPlayNum, nCode, 0,
    Certification);
  SendSocket(Msg, '');
end;

procedure TfrmMain.SendDrinkDrinkOK();
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_USERPLAYDRINK, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(IntToStr(g_nCurMerchant) + '/' +
    IntToStr(g_PDrinkItem[0].MakeIndex) + '/' +
    IntToStr(g_PDrinkItem[1].MakeIndex)));
end;

procedure TfrmMain.CloseTimerTimer(Sender: TObject);
begin
  CloseTimer.Enabled := False;
  if (g_ConnectionStep = cnsLogin) and not g_boSendLogin then
  begin
    AddMessageDialog('服务器关闭或网络不稳定,请联系官方客服人员!!', [mbOk],
      procedure(AResult: Integer)begin if AResult = mrOK then Close; end);
  end;
end;

procedure TfrmMain.CloseTopMost;
begin
  FrmDXDialogs.CloseTopMost;
end;

{ ****************************************************************************** }
// 英雄技能开关
procedure TfrmMain.SendHeroMagicKeyChange(magid: Integer; keych: PPlatfromChr);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_HEROMAGICKEYCHANGE, magid, Byte(keych), 0, 0,
    Certification);
  SendSocket(Msg);
end;

{ ****************************************************************************** }
// 验证码相关
procedure TfrmMain.GetCheckNum();
// var
// i, o, p: Integer;
// vPoint: TPoint;
// vLeft: Integer;
// img: Timage;
begin
  // try
  // img := Timage.Create(frmMain.Owner);
  // try
  // img.Width := 80;
  // img.Height := 40;
  // with img.Canvas do
  // begin
  // vLeft := 10;
  // for o := 0 to 80 - 1 do
  // begin
  // for p := 0 to 40 - 1 do
  // begin
  // Pixels[o, p] := $00ADC6D6 { RGB(Random(256) and $C0,
  // Random(256) and $C0,Random(256) and $C0) };
  // end;
  // end;
  // for i := 1 to Length(g_pwdimgstr) do
  // begin
  // Font.Size := Random(10) + 10;
  // Font.Color := clBlack;
  // case Random(3) of // 随机字体
  // 0:
  // Font.Style := [fsBold];
  // 1:
  // Font.Style := [fsBold, fsUnderline];
  // 2:
  // Font.Style := [fsBold, fsUnderline, fsUnderline];
  // end;
  // vPoint.X := Random(4) + vLeft;
  // vPoint.Y := Random(5) + 2;
  // // Canvas.Font.Name := Screen.Fonts[10];
  // SetBkMode(Handle, TRANSPARENT);
  // TextOut(vPoint.X, vPoint.Y, g_pwdimgstr[i]);
  // vLeft := vPoint.X + Canvas.TextWidth(g_pwdimgstr[i]) + 8;
  // end;
  //
  // Font.Size := 9;
  // Font.Style := []; // 字体去掉粗体
  // end;
  // // img.Picture.Bitmap.PixelFormat := pf8bit;
  // if img.Picture.Bitmap <> nil then
  // begin
  // UiDXImageList.Items[35].Picture.Bitmap := img.Picture.Bitmap;
  // UiDXImageList.Items[35].Restore;
  // end;
  // finally
  // img.Free;
  // end;
  // except
  // DebugOutStr('TfrmMain.GetCheckNum');
  // end;
end;

procedure TfrmMain.SendCheckNum(num: string);
var
  Msg: TDefaultMessage;
begin
  if num = '' then
    Exit;
  Msg := MakeDefaultMsg(CM_CHECKNUM, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(num));
end;

procedure TfrmMain.SendChangeCheckNum();
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_CHANGECHECKNUM, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.Autorun();
var
  mx, my, mx1, my1, dx, dy, crun: Integer;
  ndir: Byte;
  RunStep: Byte;
  T: PPoint;
label
  LB_WALK;
begin
  try
    if (g_nAutoRunx <> g_MySelf.m_nCurrX) or
      (g_nAutoRuny <> g_MySelf.m_nCurrY) then
    begin
      mx := g_MySelf.m_nCurrX;
      my := g_MySelf.m_nCurrY;

      dx := g_nAutoRunx;
      dy := g_nAutoRuny;
      ndir := GetNextDirection(mx, my, dx, dy);
      case g_ChrAction of
        caWalk:
          begin
          LB_WALK:
            crun := g_MySelf.CanWalk;
            if IsUnLockAction(CM_WALK, ndir) and (crun > 0) then
            begin
              GetNextPosXY(ndir, mx, my);
              if not PlayScene.CanWalk(mx, my) then
              begin
                if g_uPointList.count > 0 then
                begin
                  T := PPoint(g_uPointList[g_uPointList.count - 1]);
                  DScreen.AddSysMsg('重新查找路径');
                  AutoGoto(T.X, T.Y);
                end;
              end
              else
              begin
                g_MySelf.UpdateMsg(CM_WALK, mx, my, ndir, 0, 0, 0, 0, '', 0);
                g_GameData.LastMoveTime.Data  := GetTickCount;
              end;
            end
            else
              g_nAutoRunx := -1;
          end;
        caSneak:
          begin
            crun := g_MySelf.CanWalk;
            if IsUnLockAction(CM_SNEAK, ndir) and (crun > 0) then
            begin
              GetNextPosXY(ndir, mx, my);
              if PlayScene.CanWalk(mx, my) then
              begin
                g_MySelf.UpdateMsg(CM_SNEAK, mx, my, ndir, 0, 0, 0, 0, '', 0);
                g_GameData.LastMoveTime.Data  := GetTickCount;
              end;
            end
            else
              g_nAutoRunx := -1;
          end;
        caRun:
          begin
            if (g_nRunReadyCount >= 1) { or (neigua.Base.NoRunReady > 0) }
            then
            begin // 免助跑
              crun := g_MySelf.CanRun;
              RunStep := 2;
              if (GetDistance(mx, my, dx, dy) >= RunStep) and (crun > 0) then
              begin
                if IsUnLockAction(CM_RUN, ndir) then
                begin
                  mx1 := mx;
                  my1 := my;
                  GetNextRunXY(ndir, mx, my);
                  if PlayScene.CanRun(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY,
                    mx, my) then
                  begin
                    g_MySelf.UpdateMsg(CM_RUN, mx, my, ndir, 0, 0, 0, 0, '', 0);
                  end
                  else
                  begin
                    mx := mx1;
                    my := my1;
                    goto LB_WALK;
                  end;
                end
                else
                begin
                  g_nAutoRunx := -1;
                  goto LB_WALK;
                end;
              end
              else
              begin
                g_nAutoRunx := -1;
                goto LB_WALK;
              end;
            end
            else
            begin
              Inc(g_nRunReadyCount);
              goto LB_WALK;
            end;
          end;
      end;
    end;
  except
  end;
end;

procedure TfrmMain.AutoRunTimerTimer(Sender: TObject);
begin
end;

{ ****************************************************************************** }
// 内挂检查是否有这魔法
// 根据快捷键，查找对应的魔法
function TfrmMain.GetMagicByID(Id: Word): Boolean;
var
  pm: PTClientMagic;
begin
  Result := TryGetMagicByID(Id, pm);
end;

{ ****************************************************************************** }
// 酒馆2卷                            //0为普通酒，1为药酒
procedure TfrmMain.SendMakeWineItems();
var
  Msg: TDefaultMessage;
  sStr: string;
  TypeWine: Byte;
begin
  sStr := '';
  if g_MakeTypeWine = 0 then
  begin // 普通酒
    if (g_WineItem[0].Name = '') or (g_WineItem[2].Name = '') or
      (g_WineItem[3].Name = '') or (g_WineItem[4].Name = '') or
      (g_WineItem[5].Name = '') or (g_WineItem[6].Name = '') then
      Exit;
    if g_WineItem[1].Name = '' then // 判断酒曲是否为空
      sStr := IntToStr(g_WineItem[0].MakeIndex) + '/' + '0/' +
        IntToStr(g_WineItem[2].MakeIndex) + '/' +
        IntToStr(g_WineItem[3].MakeIndex) + '/' +
        IntToStr(g_WineItem[4].MakeIndex) + '/' +
        IntToStr(g_WineItem[5].MakeIndex) + '/' +
        IntToStr(g_WineItem[6].MakeIndex)
    else
      sStr := IntToStr(g_WineItem[0].MakeIndex) + '/' +
        IntToStr(g_WineItem[1].MakeIndex) + '/' +
        IntToStr(g_WineItem[2].MakeIndex) + '/' +
        IntToStr(g_WineItem[3].MakeIndex) + '/' +
        IntToStr(g_WineItem[4].MakeIndex) + '/' +
        IntToStr(g_WineItem[5].MakeIndex) + '/' +
        IntToStr(g_WineItem[6].MakeIndex);
    TypeWine := 0;
  end
  else
  begin
    if (g_DrugWineItem[0].Name = '') or (g_DrugWineItem[1].Name = '') or
      (g_DrugWineItem[2].Name = '') then
      Exit;
    sStr := IntToStr(g_DrugWineItem[0].MakeIndex) + '/' +
      IntToStr(g_DrugWineItem[1].MakeIndex) + '/' +
      IntToStr(g_DrugWineItem[2].MakeIndex);
    TypeWine := 1;
  end;
  Msg := MakeDefaultMsg(CM_BEGINMAKEWINE, 0, 0, 0, TypeWine, Certification);
  SendSocket(Msg, EdCode.EncodeString(sStr));
end;

procedure TfrmMain.OpenSdoAssistant;
begin
  AssistantForm.UpdateForm;
  AssistantForm.DWAssistant.Visible := not AssistantForm.DWAssistant.Visible;
end;

procedure TfrmMain.OpenURL(const AUrl: String; WinW, WinH: Integer);
begin
  OpenBrowser(AUrl);
end;

{ ****************************************************************************** }
// 挑战
procedure TfrmMain.SendChallenge;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_CHALLENGETRY, 0, 0, 0, 0, Certification);
  SendSocket(Msg, '');
end;

procedure TfrmMain.SendAddChallengeItem(ci: TClientItem);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_CHALLENGEADDITEM, ci.MakeIndex, 0, 0, 0,
    Certification);
  SendSocket(Msg, EdCode.EncodeString(ci.Name));
end;

procedure TfrmMain.SendCancelChallenge;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_CHALLENGECANCEL, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendDelChallengeItem(ci: TClientItem);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_CHALLENGEDELITEM, ci.MakeIndex, 0, 0, 0,
    Certification);
  SendSocket(Msg, EdCode.EncodeString(ci.Name));
end;

procedure TfrmMain.ClientGetChallengeRemoteAddItem(const body: PPlatfromString);
var
  ci: TClientItem;
begin
  if body <> '' then
  begin
    DecodeClientItem(body, ci);
    AddChallengeRemoteItem(ci);
  end;
end;

procedure TfrmMain.ClientGetChallengeRemoteDelItem(const body: PPlatfromString);
var
  ci: TClientItem;
begin
  if body <> '' then
  begin
    DecodeClientItem(body, ci);
    DelChallengeRemoteItem(ci);
  end;
end;

procedure TfrmMain.SendChallengeEnd;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_CHALLENGEEND, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendChangeChallengeGold(gold: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_CHALLENGECHGGOLD, gold, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendChangeChallengeDiamond(Diamond: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_CHALLENGECHGDIAMOND, Diamond, 0, 0, 0,
    Certification);
  SendSocket(Msg);
end;

// Mode 0为关 1为开
procedure TfrmMain.SendHeroAutoOpenDefence(Mode: Integer);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_HEROAUTOOPENDEFENCE, Mode, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

{ ****************************************************************************** }
// 恢复角色
procedure TfrmMain.ClientGetReceiveDelChrs(const body: PPlatfromString;
  DelChrCount: Integer);
var
  i: Integer;
  str, uname, sjob, shair, slevel, ssex: string;
  DelChr: TDelChr;
begin
  str := EdCode.DecodeString(body);
  if DelChrCount > 0 then
  begin
    for i := 0 to DelChrCount - 1 do
    begin
      str := GetValidStr3(str, uname, ['/']);
      str := GetValidStr3(str, sjob, ['/']);
      str := GetValidStr3(str, shair, ['/']);
      str := GetValidStr3(str, slevel, ['/']);
      str := GetValidStr3(str, ssex, ['/']);
      if (uname <> '') and (slevel <> '') and (ssex <> '') then
      begin
        //New(DelChr);
        DelChr.ChrInfo.Name := uname;
        DelChr.ChrInfo.Job := Str_ToInt(sjob, 0);
        DelChr.ChrInfo.Hair := Str_ToInt(shair, 0);
        DelChr.ChrInfo.Level := Str_ToInt(slevel, 0);
        DelChr.ChrInfo.sex := Str_ToInt(ssex, 0);

        // SelectChrScene.AddChr (uname, Str_ToInt(sjob, 0), Str_ToInt(shair, 0), Str_ToInt(slevel, 0), Str_ToInt(ssex, 0));
        with FrmDlg.DVRecoverCharNames.Add do
        begin
          SubStrings.Add(uname);
          case DelChr.ChrInfo.job of
                0:
                  sJob := '武士';
                1:
                  sJob := '法师';
                2:
                  sJob := '道士';
                3:
                  sJob := '刺客';
                4:
                  sJob := '弓箭手';
                5:
                  sJob := '武僧';
          end;
          SubStrings.Add(slevel);
          SubStrings.Add(sJob);
          if DelChr.ChrInfo.sex = 0 then
            SubStrings.Add('男')
          else
            SubStrings.Add('女')

        end;
      end;
    end;
  end;
  FrmDlg.dwRecoverChr.Visible := True;
end;

procedure TfrmMain.SendQueryDelChr();
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_QUERYDELCHR, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(LoginID + '/' + IntToStr(Certification)));
end;

procedure TfrmMain.SendResDelChr(Name: string);
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_RESDELCHR, 0, 0, 0, 0, Certification);
  SendSocket(Msg, EdCode.EncodeString(LoginID + '/' + Name));
end;

procedure TfrmMain.SendSetBatterOrder();
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SETBATTERORDER, 0, g_BatterOrder[0],
    g_BatterOrder[1], g_BatterOrder[2], Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendSetHeroBatterOrder();
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_SETHEROBATTERORDER, 0, g_HeroBatterOrder[0],
    g_HeroBatterOrder[1], g_HeroBatterOrder[2], Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.UpdateGroupUserHealth(Id, HP, MP, MaxHP, MaxMP: Integer);
var
  i: Integer;
begin
  for i := 0 to g_GroupMembers.count - 1 do
    if (g_GroupMembers[i] <> nil) and (g_GroupMembers[i].Id = Id) then
    begin
      g_GroupMembers[i].HP := HP;
      g_GroupMembers[i].MP := MP;
      g_GroupMembers[i].MaxHP := MaxHP;
      g_GroupMembers[i].MaxMP := MaxMP;
      Break;
    end;
end;

procedure TfrmMain.UpdateGroupUserLevel(Id, ReLevel, Level: Integer);
var
  i: Integer;
begin
  for i := 0 to g_GroupMembers.count - 1 do
    if (g_GroupMembers[i] <> nil) and (g_GroupMembers[i].Id = Id) then
    begin
      g_GroupMembers[i].Level := Level;
      Break;
    end;
end;

// procedure TfrmMain.SendOpenPulse(BatterPage, PulseNum: Word);
// var
// msg: TDefaultMessage;
// begin
// if (BatterPage in [0..3]) and (PulseNum in [1..5]) then begin
// if g_MyPulse[BatterPage].Pulse = PulseNum - 1 then begin
// msg:=MakeDefaultMsg (CM_OPENPULSE, BatterPage, PulseNum, 0, 0, Certification);
// SendSocket (EncodeMessage (msg));
// end;
// end;
// end;
//
// procedure TfrmMain.SendOpenPulse(BatterPage, PulseNum: Word);
// var
// msg: TDefaultMessage;
// begin
// if (BatterPage in [0..3]) and (PulseNum in [1..5]) then begin
// if g_MyPulse[BatterPage].Pulse = PulseNum - 1 then begin
// msg:=MakeDefaultMsg (CM_OPENPULSE, BatterPage, PulseNum, 0, 0, Certification);
// SendSocket (EncodeMessage (msg));
// end;
// end;
// end;

procedure TfrmMain.SendRushPulse(BatterPage: Word; PulseLevel: Word);
var
  Msg: TDefaultMessage;
begin
  if (BatterPage in [0 .. 3]) and (PulseLevel in [1 .. 5]) then
  begin
    if (g_MyPulse[BatterPage].Pulse > 4) and
      (g_MyPulse[BatterPage].PulseLevel <> 5) then
    begin
      Msg := MakeDefaultMsg(CM_RUSHPULSE, BatterPage, PulseLevel, 0, 0,
        Certification);
      SendSocket(Msg);
    end
    else
      FrmDlg.ShowMDlg(0, '', '经络未通！！！');
  end;
end;

procedure TfrmMain.SendHeroRushPulse(HeroBatterPage: Word;
  HeroPulseLevel: Word);
var
  Msg: TDefaultMessage;
begin
  if (HeroBatterPage in [0 .. 3]) and (HeroPulseLevel in [1 .. 5]) then
  begin
    if (g_MyHeroPulse[HeroBatterPage].Pulse > 4) and
      (g_MyHeroPulse[HeroBatterPage].PulseLevel <> 5) then
    begin
      Msg := MakeDefaultMsg(CM_RUSHHEROPULSE, HeroBatterPage, HeroPulseLevel, 0,
        0, Certification);
      SendSocket(Msg);
    end
    else
      FrmDlg.ShowMDlg(0, '', '英雄 经络未通！！！');
  end;
end;

procedure TfrmMain.SendOpenMember;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_OPENMEMBER, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendOpenPayHome;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_OPENPayHome, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendOpenPulseQuery(BatterPage, PulseNum: Word);
var
  Msg: TDefaultMessage;
begin
  if (BatterPage in [0 .. 3]) and (PulseNum in [1 .. 5]) then
  begin
    Msg := MakeDefaultMsg(CM_QUERYOPENPULSE, BatterPage, PulseNum, 0, 0,
      Certification);
    SendSocket(Msg);
  end;
end;

procedure TfrmMain.SendHeroOpenPulseQuery(HeroBatterPage, HeroPulseNum: Word);
var
  Msg: TDefaultMessage;
begin
  if (HeroBatterPage in [0 .. 3]) and (HeroPulseNum in [1 .. 5]) then
  begin
    Msg := MakeDefaultMsg(CM_QUERYHEROOPENPULSE, HeroBatterPage, HeroPulseNum,
      0, 0, Certification);
    SendSocket(Msg);
  end;
end;

procedure TfrmMain.SendChangeHeroAttectMode;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_CHANGEHEROATTECTMODE, 0, g_HEROATTECTMODE, 0, 0,
    Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendQueryAssessHero;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_QUERYASSESSHERO, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendAssessMentHero;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_ASSESSMENTHERO, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendTrainingHero;
var
  DefMsg: TDefaultMessage;
begin
  DefMsg := MakeDefaultMsg(CM_TRAININGHERO, 0, 8, 9, 0, Certification)
end;

procedure TfrmMain.SendSighIconMsg;
var
  Msg: TDefaultMessage;
begin
  if g_SighIconMethods.count > 0 then
  begin
    Msg := MakeDefaultMsg(CM_CLICKSIGHICON, 0, 0, 0, 0, frmMain.Certification);
    SendSocket(Msg, EdCode.EncodeString(g_SighIconMethods[0]));
    g_SighIconMethods.Delete(0);
    g_SighIconHints.Delete(0);
    UpdateSighIcon;
  end;
end;

procedure TfrmMain.AddMenuString(S: string);
const
  BatterStr: array [0 .. 2, 0 .. 3] of string = (('三绝杀', '追心刺', '断岳斩', '横扫千军'),
    ('双龙破', '凤舞祭', '惊雷爆', '冰天雪地'), ('虎啸诀', '八卦掌', '三焰咒', '万剑归宗'));
var
  i: Integer;
  sMenu: string;
  L: TStringList;
begin
  if g_BatterMenuNameList.count >= 6 then
    Exit;
  if g_BatterMenuNameList.IndexOfName(S) > -1 then
    Exit;
  g_BatterMenuNameList.Add(S);
  L := TStringList.Create;
  try
    L.Clear;
    for i := 0 to 3 do
    begin
      if g_BatterMenuNameList.IndexOf(BatterStr[g_MySelf.m_btJob][i]) > -1 then
      begin
        L.Add(BatterStr[g_MySelf.m_btJob][i]);
      end;
    end;
    g_BatterMenuNameList.Clear;
    for i := 0 to L.count - 1 do
      g_BatterMenuNameList.Add(L.Strings[i]);
    g_BatterMenuNameList.Add('空');
    g_BatterMenuNameList.Add('随机');
  finally
    FreeAndNilEx(L);
  end;
end;

procedure TfrmMain.AddMessageDialog(const Text: String; Buttons: TMsgDlgButtons;
  Handler: TMessageHandler; Size: Integer);
var
  AItem: PTMessageDialogItem;
begin
  New(AItem);
  AItem.Text := Text;
  AItem.Buttons := Buttons;
  AItem.Handler := Handler;
  AItem.Size := Size;
  FDlgMessageList.Add(AItem);
end;

function TfrmMain._CurPos: TPoint;
begin
  GetCursorPos(Result);
  Result := frmMain.ScreenToClient(Result);
  Result.X := Round(SCREENWIDTH / ClientWidth * Result.X);
  Result.Y := Round(SCREENHEIGHT / ClientHeight * Result.Y);
end;

procedure TfrmMain.AddChatBoardString(const AMessage: String;
  FColor, BColor: TColor; const ObjList: String);
var
  MsgCount: Integer;
begin
  DScreen.AddChatBoardString(AMessage, ObjList, FColor, BColor);
  MsgCount := DScreen.ChatMessage.count; // 有多少条聊天信息
  if MsgCount > CHATBOXLINECOUNT then
  begin
    MsgCount := MsgCount - CHATBOXLINECOUNT; // 从哪一行起始
    DScreen.ChatMessage.topline := MsgCount;
  end;
  FrmDlg.UpdateChatSroll;
end;

procedure TfrmMain.AddHeroMenuString(S: string);
const
  BatterStr: array [0 .. 2, 0 .. 3] of string = (('三绝杀', '追心刺', '断岳斩', '横扫千军'),
    ('双龙破', '凤舞祭', '惊雷爆', '冰天雪地'), ('虎啸诀', '八卦掌', '三焰咒', '万剑归宗'));
var
  i: Integer;
  sMenu: string;
  L: TStringList;
begin
  if g_HeroBatterMenuNameList.count >= 6 then
    Exit;
  if g_HeroBatterMenuNameList.IndexOfName(S) > -1 then
    Exit;
  g_HeroBatterMenuNameList.Add(S);
  L := TStringList.Create;
  try
    L.Clear;
    for i := 0 to 3 do
    begin
      if g_HeroBatterMenuNameList.IndexOf(BatterStr[g_MySelf.m_btJob][i])
        > -1 then
      begin
        L.Add(BatterStr[g_MySelf.m_btJob][i]);
      end;
    end;
    g_HeroBatterMenuNameList.Clear;
    for i := 0 to L.count - 1 do
      g_HeroBatterMenuNameList.Add(L.Strings[i]);
    g_HeroBatterMenuNameList.Add('空');
    g_HeroBatterMenuNameList.Add('随机');
  finally
    FreeAndNilEx(L);
  end;
end;

procedure TfrmMain.SendHotClick;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_HOTCLICK, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.SendHelpClick;
var
  Msg: TDefaultMessage;
begin
  Msg := MakeDefaultMsg(CM_HELP, 0, 0, 0, 0, Certification);
  SendSocket(Msg);
end;

procedure TfrmMain.BuildActorMenu(AMessage: TDefaultMessage);

  procedure CheckAndAddMenuItem(ATag: Byte; const ACaption: String);
  begin
    if SetContain(AMessage.Recog, ATag) then
      DXPopupMenu.AddMenuItem(ATag, ACaption);
  end;

var
  ASelActor: TActor;
begin
  if (g_SelCret <> nil) and (g_SelCret.m_nRecogId = AMessage.Param) then
  begin
    {
      1:  AMenuText :=  '查看装备';
      2:  AMenuText :=  '邀请加入行会';
      3:  AMenuText :=  '申请加入行会';
      4:  AMenuText :=  '邀请加入组队';
      5:  AMenuText :=  '请求加入队伍';
      6:  AMenuText :=  '踢出队伍';
      7:  AMenuText :=  '添加好友';
      8:  AMenuText :=  '删除好友';
      9:  AMenuText :=  '添加黑名单';
      10: AMenuText :=  '申请交易';
      11: AMenuText :=  '发送邮件';
      12: AMenuText :=  '私聊';
      13: AMenuText :=  '复制名称';
      14: AMenuText :=  '自动跟随';
    }
    ASelActor := g_SelCret;
    if DXPopupMenu.PopVisible then
      DXPopupMenu.HidePopup;
    DXPopupMenu.BeginUpdate;
    DXPopupMenu.Clear;
    DXPopupMenu.AddMenuItem(1, '查看装备');
    CheckAndAddMenuItem(2, '邀请加入行会');
    CheckAndAddMenuItem(3, '申请加入行会');
    CheckAndAddMenuItem(4, '邀请加入组队');
    CheckAndAddMenuItem(5, '请求加入队伍');
    CheckAndAddMenuItem(6, '踢出队伍');
    DXPopupMenu.AddMenuItem(10, '申请交易');
    DXPopupMenu.AddMenuItem(11, '私聊');
    DXPopupMenu.AddMenuItem(12, '复制名称');
    DXPopupMenu.AddMenuItem(13, '自动跟随');
    if not NameInFriends(ASelActor.m_sUserName) and
      not NameInEnemies(ASelActor.m_sUserName) then
      DXPopupMenu.AddMenuItem(14, '添加好友');
    DXPopupMenu.EndUpdate;
    DXPopupMenu.Popup(g_DXUIWindow, g_SelCretX, g_SelCretY, 0,
      procedure(tag: Integer; const ACaption: String)
    begin if ASelActor = nil then Exit;
      case tag of 1, 2, 3, 6: begin SendClientMessage(CM_EXECMENUITEM,
      ASelActor.m_nRecogId, ASelActor.m_nCurrX, ASelActor.m_nCurrY, tag); end;
      4, 5: begin if g_boAllowGroup then SendClientMessage(CM_EXECMENUITEM,
      ASelActor.m_nRecogId, ASelActor.m_nCurrX, ASelActor.m_nCurrY, tag)
    else begin AddMessageDialog('你当前为不允许组队状态，请求组队后将开启允许组队，确定执行吗？',
      [mbOk, mbCancel], procedure(AResult: Integer)
    begin if AResult = mrOK then begin SetAllowGroup(True);
      SendClientMessage(CM_EXECMENUITEM, ASelActor.m_nRecogId,
      ASelActor.m_nCurrX, ASelActor.m_nCurrY, tag); end; end); end; end;
      10: begin if g_boAllowDeal then SendClientMessage(CM_EXECMENUITEM,
      ASelActor.m_nRecogId, ASelActor.m_nCurrX, ASelActor.m_nCurrY, tag)
    else begin AddMessageDialog('你当前为不允许交易状态，请求交易后将开启允许交易，确定执行吗？',
      [mbOk, mbCancel], procedure(AResult: Integer)begin SendClientMessage
      (CM_EXECMENUITEM, ASelActor.m_nRecogId, ASelActor.m_nCurrX,
      ASelActor.m_nCurrY, tag); end); end; end;
      11: begin PlayScene.SetChatText('/' + ASelActor.m_sUserName + ' ');
      SetDFocus(FrmDlg.DEChat);
      FrmDlg.DEChat.SelStart := Length(FrmDlg.DEChat.Text); end;
      12: begin Clipbrd.Clipboard.SetTextBuf(PChar(ASelActor.m_sUserName)); end;
      13: begin g_Pilot := ASelActor;
      if g_Pilot <> nil then begin AutoFollow(g_Pilot.m_nCurrX,
      g_Pilot.m_nCurrY); g_boISTrail := True; end; end;
      14: begin Self.AddFriend(ASelActor.m_sUserName); end; end; end);
  end;
end;

procedure TfrmMain.AddFriend(const AName: String);
var
  Msg: TDefaultMessage;
begin
  if not NameInFriends(AName) then
  begin
    Msg := MakeDefaultMsg(CM_RELATION, _CM_RELATION_ADDFIREND, 0, 0, 0,
      Certification);
    SendSocket(Msg, EdCode.EncodeString(AName));
  end
  else
    g_Application.AddMessageDialog('你们已经是好友了，不需要重复添加！', [mbOk]);
end;

procedure TfrmMain.AddEnemiy(const AName: String);
var
  Msg: TDefaultMessage;
begin
  if not NameInEnemies(AName) then
  begin
    Msg := MakeDefaultMsg(CM_RELATION, _CM_RELATION_ADDENEMIY, 0, 0, 0,
      Certification);
    SendSocket(Msg, EdCode.EncodeString(AName));
  end
  else
    g_Application.AddMessageDialog('对方已经存在于你的黑名单中，不需要重复添加！', [mbOk]);
end;

procedure TfrmMain.RemoveFriend(const AName: String);
var
  idx: Integer;
  Msg: TDefaultMessage;
begin
  idx := NameAtFriends(AName);
  if idx <> -1 then
  begin
    Msg := MakeDefaultMsg(CM_RELATION, _CM_RELATION_DELFRIEND, 0, 0, 0,
      Certification);
    SendSocket(Msg, EdCode.EncodeString(AName));
  end;
end;

procedure TfrmMain.RemoveEnemiy(const AName: String);
var
  idx: Integer;
  Msg: TDefaultMessage;
begin
  idx := NameAtEnemies(AName);
  if idx <> -1 then
  begin
    Msg := MakeDefaultMsg(CM_RELATION, _CM_RELATION_DELENEMIY, 0, 0, 0,
      Certification);
    SendSocket(Msg, EdCode.EncodeString(AName));
  end;
end;

procedure TfrmMain.ReadMailData(const Value: PPlatfromString);
var
  List: TAnsiStrings;
  AIdx, AContent, AItem1, AItem2, AItem3, AItem4, AItem5, AGold, AGameGold,
    AGameGift, APrice, ACurrencyType: PPlatfromString;
  AIntGold, AIntGameGold, AIntGamePoint, AIntPrice, AIntCurrencyType: Integer;
  AMailItem: TMailItem;
begin
  List := TAnsiStringList.Create;
  try
    uAnsiStrings.StrIToStrings(Value, '/', List);
    if List.count = 12 then
    begin
      AIdx := List[0];
      AContent := List[1];
      AItem1 := AnsiStrings.Trim(List[2]);
      AItem2 := AnsiStrings.Trim(List[3]);
      AItem3 := AnsiStrings.Trim(List[4]);
      AItem4 := AnsiStrings.Trim(List[5]);
      AItem5 := AnsiStrings.Trim(List[6]);
      AGold := List[7];
      AGameGold := List[8];
      AGameGift := List[9];
      ACurrencyType := List[10];
      APrice := List[11];
      if g_Mail.TryGet(StrToIntDef(AIdx, -1), AMailItem) then
      begin
        AMailItem.Content := StringReplace(EdCode.DecodeString(AContent), '\',
          #$D#$A, [rfReplaceAll]);
        AIntGold := StrToIntDef(AGold, 0);
        AIntGameGold := StrToIntDef(AGameGold, 0);
        AIntGamePoint := StrToIntDef(AGameGift, 0);
        AMailItem.GoldStr := '';
        if AIntGold > 0 then
          AMailItem.GoldStr := IntToStr(AIntGold) + g_sGoldName;
        if AIntGameGold > 0 then
        begin
          if AMailItem.GoldStr <> '' then
            AMailItem.GoldStr := AMailItem.GoldStr + '、';
          AMailItem.GoldStr := AMailItem.GoldStr + IntToStr(AIntGameGold) +
            g_sGameGoldName;
        end;
        if AIntGamePoint > 0 then
        begin
          if AMailItem.GoldStr <> '' then
            AMailItem.GoldStr := AMailItem.GoldStr + '、';
          AMailItem.GoldStr := AMailItem.GoldStr + IntToStr(AIntGamePoint) +
            g_sGamePointName;
        end;
        if AMailItem.GoldStr <> '' then
          AMailItem.GoldStr := '内含：' + AMailItem.GoldStr;

        AIntPrice := StrToIntDef(APrice, 0);
        AIntCurrencyType := StrToIntDef(ACurrencyType, 0);
        AMailItem.PriceStr := '';
        if AIntPrice > 0 then
        begin
          case AIntCurrencyType of
            0:
              AMailItem.PriceStr := '提取附件需要支付：' + IntToStr(AIntPrice) +
                g_sGoldName;
            1:
              AMailItem.PriceStr := '提取附件需要支付：' + IntToStr(AIntPrice) +
                g_sGameGoldName;
          end;
        end;

        if AMailItem.STATE = 0 then
          AMailItem.STATE := 1;
        if AItem1 <> '<' then
          DecodeClientItem(AItem1, AMailItem.Item1);
        if AItem2 <> '<' then
          DecodeClientItem(AItem2, AMailItem.Item2);
        if AItem3 <> '<' then
          DecodeClientItem(AItem3, AMailItem.Item3);
        if AItem4 <> '<' then
          DecodeClientItem(AItem4, AMailItem.Item4);
        if AItem5 <> '<' then
          DecodeClientItem(AItem5, AMailItem.Item5);
        AMailItem.Loaded := True;
        if FrmDlg.DMailReader.Visible and (g_Mail.Selected <> nil) and
          (g_Mail.Selected.Index = AMailItem.Index) then
        begin
          FrmDlg.DMMReader.Lines.Text := AMailItem.Content;
          FrmDlg.DMMReader.BuildLines;
        end;
      end;
    end;
  finally
    FreeAndNilEx(List);
  end;
end;

procedure TfrmMain.ReadNewMailData(const Value: PPlatfromString);
var
  ARecord: TAnsiStrings;
  i: Integer;
  AIndex, AFrom, ASubject, ADate, AState, AAttachment: String;
  AMailItem: TMailItem;
begin
  if Value <> '' then
  begin
    ARecord := TAnsiStringList.Create;
    try
      uAnsiStrings.StrIToStrings(Value, '/', ARecord);
      if ARecord.count = 6 then
      begin
        AIndex := ARecord[0];
        AFrom := ARecord[1];
        ASubject := ARecord[2];
        ADate := ARecord[3];
        AState := ARecord[4];
        AAttachment := ARecord[5];
        AMailItem := TMailItem.Create;
        AMailItem.Index := StrToIntDef(AIndex, 0);
        AMailItem.AFrom := EdCode.DecodeString(AFrom);
        AMailItem.Subject := EdCode.DecodeString(ASubject);
        AMailItem._ShortDate := FormatDateTime('MM.DD',
          StrToFloatDef(ADate, 0));
        AMailItem._Date := FormatDateTime('YYYY年MM月DD日hh时mm分',
          StrToFloatDef(ADate, 0));
        AMailItem.STATE := StrToIntDef(AState, 0);
        AMailItem.Attachment := StrToIntDef(AAttachment, 0);
        AMailItem.Loaded := False;
        g_Mail.Insert(0, AMailItem);
        AddChatBoardString('【邮件】' + AMailItem.AFrom + '给你发了一封新邮件，请注意查收！',
          clWhite, clBlue);
        g_SoundManager.PlaySoundEx(ResourceDir + 'Wav\Notify.mp3');
      end;
    finally
      FreeAndNilEx(ARecord);
    end;
  end;
end;

procedure TfrmMain.ReadMailList(const Value: PPlatfromString);
var
  List: TAnsiStrings;
  i, Acount: Integer;
  ALine: PPlatfromString;
  AIndex, AFrom, ASubject, ADate, AState, AAttachment: PPlatfromString;
  AMailItem: TMailItem;
begin
  List := TAnsiStringList.Create;
  try
    g_Mail.Clear;
    uAnsiStrings.StrIToStrings(Value, '/', List);
    Acount := List.count div 6;
    for i := 0 to Acount - 1 do
    begin
      AIndex := List[i * 6 + 0];
      AFrom := List[i * 6 + 1];
      ASubject := List[i * 6 + 2];
      ADate := List[i * 6 + 3];
      AState := List[i * 6 + 4];
      AAttachment := List[i * 6 + 5];
      AMailItem := TMailItem.Create;
      AMailItem.Index := StrToIntDef(AIndex, 0);
      AMailItem.AFrom := EdCode.DecodeString(AFrom);
      AMailItem.Subject := EdCode.DecodeString(ASubject);
      AMailItem._ShortDate := FormatDateTime('MM.DD', StrToFloatDef(ADate, 0));
      AMailItem._Date := FormatDateTime('YYYY年MM月DD日hh时mm分',
        StrToFloatDef(ADate, 0));
      AMailItem.STATE := StrToIntDef(AState, 0);
      AMailItem.Attachment := StrToIntDef(AAttachment, 0);
      AMailItem.Loaded := False;
      g_Mail.Add(AMailItem);
    end;
    g_Mail.SelIndex := 0;
    g_MailLoaded := True;
  finally
    FreeAndNilEx(List);
  end;
end;

procedure TfrmMain.ReadMailGoldAdd(AGold, AGameGold, AGameGift: Integer;
  const Value: PPlatfromString);
var
  SBuyer, SSubject: PPlatfromString;
  S, ABuyer, ASubject: String;
begin
  S := '';
  if AGold > 0 then
    S := IntToStr(AGold) + g_sGoldName;
  if AGameGold > 0 then
  begin
    if S <> '' then
      S := S + '，';
    S := S + IntToStr(AGameGold) + g_sGameGoldName;
  end;
  if AGameGift > 0 then
  begin
    if S <> '' then
      S := S + '，';
    S := S + IntToStr(AGameGift) + g_sGamePointName;
  end;
  ABuyer := '';
  ASubject := '';
  if Value <> '' then
  begin
    SSubject := AnsiGetValidStr3(Value, SBuyer, ['/']);
    ABuyer := EdCode.DecodeString(SBuyer);
    ASubject := EdCode.DecodeString(SSubject);
  end;
  if S <> '' then
  begin
    if ABuyer <> '' then
    begin
      AddChatBoardString(Format('【邮件】玩家“%s”购买你的信件“%s”的附件：%s',
        [ABuyer, ASubject, S]), clWhite, clBlue);
    end
    else
      AddChatBoardString('【邮件】从邮局中提取资金：' + S, clWhite, clBlue);
  end;
end;

procedure TfrmMain.DoDisappearIDs(const AIDs: String);
var
  AList: TStrings;
  i: Integer;
begin
  AList := TStringList.Create;
  try
    ExtractStrings([','], [], PChar(AIDs), AList);
    for i := 0 to AList.count - 1 do
      PlayScene.SendMsg(SM_HIDE, StrToIntDef(AList[i], -1), 0, 0, 0, 0, 0,
        0, 0, '');
    // PlayScene.DeleteActor(StrToIntDef(AList[I], -1));
  finally
    FreeAndNilEx(AList);
  end;
end;

procedure TfrmMain.ClientShowQuestion(const Value: String);
var
  AList: TStrings;
  YMethod, NMethod: String;
begin
  AList := TStringList.Create;
  try
    AList.Text := Value;
    YMethod := '';
    NMethod := '';
    if AList.count >= 2 then
    begin
      NMethod := AList[AList.count - 1];
      AList.Delete(AList.count - 1);
    end;
    if AList.count >= 1 then
    begin
      YMethod := AList[AList.count - 1];
      AList.Delete(AList.count - 1);
    end;
    AddMessageDialog(AList.Text, [mbOk, mbCancel], procedure(AResult: Integer)
    begin if AResult = mrOK then begin if YMethod <>
      '' then SendMerchantDlgSelect(g_nCurMerchant, YMethod);
    end else if NMethod <> '' then SendMerchantDlgSelect(g_nCurMerchant,
      NMethod); end);
  finally
    FreeAndNilEx(AList);
  end;
end;

procedure TfrmMain.LoadMissionsDoing(const Value: PPlatfromString);
var
  L: TAnsiStrings;
  i, ADataLen, ABufferLen: Integer;
  ABuffer, AOrgBuffer: PAnsiChar;
  S: PPlatfromString;
begin
  try
    L := TAnsiStringList.Create;
    try
      EdCode.Base64Decode(Value, ABuffer, ADataLen, ABufferLen);
      Common.DecompressBufZ(ABuffer, ADataLen, 0, AOrgBuffer, ADataLen);
      SetLength(S, ADataLen);
      Move(AOrgBuffer^, S[1], ADataLen);
      g_Missions.ClearDogin;
      uAnsiStrings.StrIToStrings(S, #$D#$A, L);
      for i := 0 to L.count - 1 do
        AddMission(L[i]);
    finally
      FreeAndNilEx(L);
      FreeMem(ABuffer, ABufferLen);
    end;
  except
  end;
end;

procedure TfrmMain.LoadMissionsLink(const Value: PPlatfromString);
var
  L: TAnsiStrings;
  i, ADataLen, ABufferLen: Integer;
  ABuffer, AOrgBuffer: PAnsiChar;
  S: PPlatfromString;
begin
  try
    L := TAnsiStringList.Create;
    try
      EdCode.Base64Decode(Value, ABuffer, ADataLen, ABufferLen);
      Common.DecompressBufZ(ABuffer, ADataLen, 0, AOrgBuffer, ADataLen);
      SetLength(S, ADataLen);
      Move(AOrgBuffer^, S[1], ADataLen);
      g_Missions.ClearUndo;
      uAnsiStrings.StrIToStrings(S, #$D#$A, L);
      for i := 0 to L.count - 1 do
        AddMissionLink(L[i]);
    finally
      FreeAndNilEx(L);
      FreeMem(ABuffer, ABufferLen);
      FreeMem(AOrgBuffer);
    end;
  except
  end;
end;

procedure TfrmMain.AddMission(Value: PPlatfromString);
var
  ARecordID, AKind, AMissionID, ASubject, AContent, ANeedMax, ANeedProgress,
    AState, ATargetNPC: PPlatfromString;
begin
  if Value <> '' then
  begin
    Value := AnsiGetValidStr3(Value, ARecordID, ['/']);
    Value := AnsiGetValidStr3(Value, AKind, ['/']);
    Value := AnsiGetValidStr3(Value, AMissionID, ['/']);
    Value := AnsiGetValidStr3(Value, ASubject, ['/']);
    Value := AnsiGetValidStr3(Value, AContent, ['/']);
    Value := AnsiGetValidStr3(Value, ANeedMax, ['/']);
    Value := AnsiGetValidStr3(Value, ANeedProgress, ['/']);
    Value := AnsiGetValidStr3(Value, AState, ['/']);
    Value := AnsiGetValidStr3(Value, ATargetNPC, ['/']);
    g_Missions.AddDoing(TMissonKind(StrToIntDef(AKind, 0)),
      EdCode.DecodeString(ARecordID), EdCode.DecodeString(AMissionID),
      EdCode.DecodeString(ASubject), EdCode.DecodeString(AContent),
      StrToIntDef(ANeedMax, 0), StrToIntDef(ANeedProgress, 0),
      StrToIntDef(ATargetNPC, 0), TMissionState(StrToIntDef(AState, 0)));
  end;
end;

procedure TfrmMain.DeleteMission(const Value: String);
var
  i: Integer;
begin
  for i := g_Missions.DoingCount - 1 downto 0 do
  begin
    if SameText(g_Missions.Doing[i].RecordID, Value) then
    begin
      g_Missions.DeleteDoing(i);
      FrmDlg.UpdateMissions;
      Exit;
    end;
  end;
end;

procedure TfrmMain.UpdateMission(Value: PPlatfromString);
var
  i: Integer;
  ARecordID, AKind, AMissionID, ASubject, AContent, ANeedMax, ANeedProgress,
    AState, ATargetNPC: PPlatfromString;
begin
  if Value <> '' then
  begin
    Value := AnsiGetValidStr3(Value, ARecordID, ['/']);
    Value := AnsiGetValidStr3(Value, AKind, ['/']);
    Value := AnsiGetValidStr3(Value, AMissionID, ['/']);
    Value := AnsiGetValidStr3(Value, ASubject, ['/']);
    Value := AnsiGetValidStr3(Value, AContent, ['/']);
    Value := AnsiGetValidStr3(Value, ANeedMax, ['/']);
    Value := AnsiGetValidStr3(Value, ANeedProgress, ['/']);
    Value := AnsiGetValidStr3(Value, AState, ['/']);
    Value := AnsiGetValidStr3(Value, ATargetNPC, ['/']);
    ARecordID := EdCode.DecodeString(ARecordID);
    for i := g_Missions.DoingCount - 1 downto 0 do
    begin
      if SameText(g_Missions.Doing[i].RecordID, ARecordID) then
      begin
        g_Missions.Doing[i].Kind := TMissonKind(StrToIntDef(AKind, 0));
        g_Missions.Doing[i].MissionID := EdCode.DecodeString(AMissionID);
        g_Missions.Doing[i].Subject := EdCode.DecodeString(ASubject);
        g_Missions.Doing[i].Content := EdCode.DecodeString(AContent);
        g_Missions.Doing[i].NeedProgress := StrToIntDef(ANeedProgress, 0);
        g_Missions.Doing[i].NeedMax := StrToIntDef(ANeedMax, 0);
        g_Missions.Doing[i].TargetNPC := StrToIntDef(ATargetNPC, 0);
        g_Missions.Doing[i].STATE := TMissionState(StrToIntDef(AState, 0));
        if g_MissionListFocused = i then
          FrmDlg.UpdateMissionContent;
        Exit;
      end;
    end;
  end;
end;

procedure TfrmMain.AddMissionLink(Value: PPlatfromString);
var
  AKind, AMissionID, ASubject, AContent, ATargetNPC, ALevel,
    AReLevel: PPlatfromString;
begin
  if Value <> '' then
  begin
    Value := AnsiGetValidStr3(Value, AKind, ['/']);
    Value := AnsiGetValidStr3(Value, AMissionID, ['/']);
    Value := AnsiGetValidStr3(Value, ASubject, ['/']);
    Value := AnsiGetValidStr3(Value, AContent, ['/']);
    Value := AnsiGetValidStr3(Value, ATargetNPC, ['/']);
    Value := AnsiGetValidStr3(Value, ALevel, ['/']);
    Value := AnsiGetValidStr3(Value, AReLevel, ['/']);
    g_Missions.AddUndo(TMissonKind(StrToIntDef(AKind, 0)),
      EdCode.DecodeString(AMissionID), EdCode.DecodeString(ASubject),
      EdCode.DecodeString(AContent), StrToIntDef(ATargetNPC, 0),
      StrToIntDef(ALevel, 0), StrToIntDef(AReLevel, 0));
  end;
end;

procedure TfrmMain.DeleteMissionLink(const Value: String);
var
  i: Integer;
begin
  for i := g_Missions.UnDoCount - 1 downto 0 do
  begin
    if SameText(g_Missions.UnDo[i].MissionID, Value) then
      g_Missions.DeleteUndo(i);
  end;
  FrmDlg.UpdateMissions;
end;

procedure TfrmMain.SetLockMoveItem(AType, ATime: Integer);
begin
  g_boLockMoveItem := AType = 1;
  g_dwLockMoveItemTimeStart := GetTickCount;
  g_nLockMoveItemTime := ATime;
end;

procedure TfrmMain.OnAsphyreCreate(Sender: TObject; Param: Pointer;
  var Handled: Boolean);
begin
  g_GameDevice := Factory.CreateDevice();
  g_GameCanvas := Factory.CreateCanvas();
  FontManager.OnGetTextExtent := DoGetTextExtent;
end;

procedure TfrmMain.OnAsphyreDestroy(Sender: TObject; Param: Pointer;
  var Handled: Boolean);
begin
  FreeAndNilEx(g_GameCanvas);
  FreeAndNilEx(g_GameDevice);
end;

procedure TfrmMain.OnDeviceInit(Sender: TObject; Param: Pointer;
  var Handled: Boolean);
begin
  g_DisplaySize := Point2px(SCREENWIDTH, SCREENHEIGHT);
  g_GameDevice.SwapChains.RemoveAll;
  g_GameDevice.SwapChains.Add(Self.Handle, g_DisplaySize, 0, False,
    TAsphyrePixelFormat.apf_A8R8G8B8);
end;

procedure TfrmMain.OnDirectionKeyDown(K: Integer);
begin

end;


procedure TfrmMain.OnDeviceCreate(Sender: TObject; Param: Pointer;
  var Handled: Boolean);
begin
  if not g_UIInitialized then
  begin
    g_DWinMan.TryLoadStyle(); // 尝试读取UI类型
    m_dwUiMemChecktTick := GetTickCount;
    LoadWMImagesLib(nil);
    uTextures.TitleImages := MShare.g_77Title;

    Textures := TuTextures.Create;
    Textures_Sys := TuTextureList.Create;
    TextNum := TextNumeric.Create;

    TextNum.Init(g_GameCanvas);
    InitWMImagesLib();
    InitMonImg();
    InitNpcImg();
    InitObjectImg();
    InitTitles;
    InitSmTiles;
    DScreen.Initialize;
    PlayScene.Initialize;

    g_DXUIWindow := FrmDlg.DBackground;
    FrmDlg.InitializeForLogin;
    BuildMapOffsetUnit;

    FrmDlg.Initialize;
    FrmDlg.InitializePlace;
    FrmDlg.InitStateWin;
    AssistantForm.Initialize;
    FrmDXDialogs.Initialize;
    DXPopupMenu.Initialize;
    SelectChrScene.InitSceneUI;

    FrmDlg.LoadCustomUI();
    FState.InitVarTextField();
    g_UIInitialized := True;
    g_boForceMapDraw := True;

    FrmDlg.DBelt1.Propertites.MouseThrough := False;
    FrmDlg.DBelt2.Propertites.MouseThrough := False;
    FrmDlg.DBelt3.Propertites.MouseThrough := False;
    FrmDlg.DBelt4.Propertites.MouseThrough := False;
    FrmDlg.DBelt5.Propertites.MouseThrough := False;
    FrmDlg.DBelt6.Propertites.MouseThrough := False;

{$IFDEF DEVMODE}
    if g_MirStartupInfo.boViewUIDlg then
    begin

      frmDlgConfig.Open;
//      frmDlgConfig.Left := Self.Left + Self.Width;
//      frmDlgConfig.Top := Self.Top;
//      frmDlgConfig.Height := Self.Height;
      frmDlgConfig.tmr_SetClientToChild.Enabled := True;

      //frmDlgConfig.hide;
//      SetParent(frmDlgConfig.pnl_Client);
//      Self.Left := 0;
//      Self.Top := 0;

    end;
{$ENDIF}

    ResourceInitOK := true;
  end;

  if not g_LoginConnected then
  begin
    FNeedTokenID := True;
    SocketOpen(g_sServerAddr, g_nServerPort);
    g_LoginConnected := True;
  end;

end;

procedure TfrmMain.OnDeviceDestroy(Sender: TObject; Param: Pointer;
  var Handled: Boolean);
begin
  FontManager.Finalize;
  FreeAndNilEx(Textures);
  FreeAndNilEx(Textures_Sys);
  FreeAndNilEx(TextNum);

  if g_UIInitialized and not FAppTerminated then
  begin
    DScreen.Finalize;
    PlayScene.Finalize;
    FrmDlg.Finalize;
    UnLoadWMImagesLib;
    g_UIInitialized := False;
  end;
end;

procedure TfrmMain.OnEventDeviceLost(Sender: TObject; Param: Pointer;
  var Handled: Boolean);
begin
end;

procedure TfrmMain.OnGetUIProperty(const UIName, Prop: String);
var
  Control : TDControl;
  PropName,PropValue,Field:string;
  L:TStringList;
  I:Integer;
  TempList: PPropList;
  Count : Integer;
  SetObject,PropertyObject : TObject;
  PropInfo :PPropInfo;
begin
  //
  Control := g_DWinMan.FindControlByName(UIName);
  L := TStringList.Create;
  if Control <> nil then
  begin
    ExtractStrings([';'],[' ',#9],PChar(Prop),L);
    for i := 0 to L.Count - 1 do
    begin
      if L[i]  <> '' then
      begin
        Try
          PropValue := GetValidStr3(L[i],PropName,['=']);
          PropValue := ConvertMaskString(PropValue);
          PropertyObject := Control.Propertites;
          repeat
            SetObject := nil;
            PropName := Trim(GetValidStr3(PropName,Field,['.']));
            Field := Trim(Field);
            if PropName = '' then
            begin
              SetPropValue(PropertyObject,Field,PropValue);
            end else
            begin
              if PropIsType(PropertyObject,Field,tkClass) then
              begin
                SetObject := GetObjectProp(PropertyObject,Field,TObject);
                if SetObject <> nil then
                  PropertyObject := SetObject;
              end;
            end;
          until PropName = '' ;
        except

        End;
      end;
    end;

  end;

end;

procedure TfrmMain.TimerSpeedCheckTimer(Sender: TObject);
var
  L1, L2: LongWord;
  nErrorTime:Cardinal;
  DivTime:Cardinal;
begin

  if (g_SendSpeedTick > 0) and (GetTickCount > g_SendSpeedTick) then
  begin
    g_SendSpeedTick := 0;
    SendClientMessage(CM_CLIENTCHECKFLAG, 0, 0, 0, 0);
  end;



  if GetTickCount - FLastSpeedCheckTime > 1000 then
  begin
    FLastSpeedCheckTime := GetTickCount;
    L1 := DateUtils.MilliSecondsBetween(Now, FSpeedTime);
    L2 := GetTickCount - FSpeedTick;
    if abs(L2 - L1) > 20 then
    begin
      // [提示]: 请爱护游戏环境，关闭加速外挂重新登陆
      if FSpeedError mod 2 = 0 then
        AddChatBoardString(FSpeedWarning, clWhite, clRed, '');
      Inc(FSpeedError);
      if FSpeedError > 5 then
        CSocket.Close;
    end
    else
    begin
      if FSpeedError > 0 then
        Dec(FSpeedError);
    end;
    FSpeedTick := GetTickCount;
    FSpeedTime := Now;
  end;


  if GetTickCount - FLastStaticCheckSpeedTime > 30 * 1000 then
  begin
    //封挂检测
    FLastStaticCheckSpeedTime := GetTickCount;
    if ClientConf.btAntiHackErrorRate > 0 then
    begin
      if g_MySelf <> nil then
      begin
        nErrorTime := Trunc(30 * 1000 * (ClientConf.btAntiHackErrorRate / 100));
        DivTime := abs(GetTickCount - timeGetTime);
        if DivTime >  nErrorTime then
        begin
          ConsoleDebug(Format('HackFind 1 : ErrorTime:%d DivTime:%d',[nErrorTime,DivTime]));
          g_MySelf := nil;
        end;

        DivTime := abs(_SyGetTickCount64 - timeGetTime);
        if DivTime > nErrorTime then
        begin
           ConsoleDebug(Format('HackFind 2 : ErrorTime:%d DivTime:%d',[nErrorTime,DivTime]));
          g_MySelf := nil;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.RenderEvent(Sender: TObject);
var
  P: TPoint;
  ATexture: TAsphyreLockableTexture;
  HoleAt, HoleSize: TPoint2;
  ABrief: String;
begin
  DScreen.DrawScreen(g_GameCanvas);

  // HoleAt:=Point2(SCREENWIDTH / 2,SCREENHEIGHT / 2);
  // HoleSize:= Point2(SCREENHEIGHT, SCREENHEIGHT);
  // g_GameCanvas.FillRibbon(HoleAt, Point2(0, 0), HoleSize * 0.25, 0.0, 2.0 * Pi, 64, cColor1(clBlack), cColor1(clBlack), cColor1(clBlack), cColor1(clBlack), cColor1(clBlack), cColor1(clBlack));
  // g_GameCanvas.FillRibbon(HoleAt, Point2(0, 0), HoleSize, 0.0, 2.0 * Pi, 64, $004E4433, $004E4433, $004E4433, cColor1(clBlack), cColor1(clBlack), cColor1(clBlack));

  g_DWinMan.DirectPaint(g_GameCanvas);
  DScreen.DrawScreenTop(g_GameCanvas);
  DScreen.DrawMoveMessage(g_GameCanvas);
  DScreen.DrawHint(g_GameCanvas);
  DoOnEndRender(g_GameCanvas);

  if g_boItemMoving then
  begin
    if (g_MovingItem.Item.Name <> g_sGoldName { '金币' } ) then
    begin
      if g_MovingItem.Item.looks > 9999 then
        ATexture := g_77WBagItemImages.Images[g_MovingItem.Item.looks - 10000]
      else
        ATexture := g_WBagItemImages.Images[g_MovingItem.Item.looks]
    end
    else
      ATexture := g_WBagItemImages.Images[115];

    if ATexture <> nil then
    begin
      GetCursorPos(P);
      P := ScreenToClient(P);
      P.X := Round(SCREENWIDTH / ClientWidth * P.X);
      P.Y := Round(SCREENHEIGHT / ClientHeight * P.Y);
      g_GameCanvas.Draw(P.X - (ATexture.ClientRect.Right div 2),
        P.Y - (ATexture.ClientRect.Bottom div 2), ATexture);
    end;
  end;

  if g_boDoFadeOut then
  begin
    if g_nFadeIndex < 1 then
      g_nFadeIndex := 1;
    MakeDark(g_GameCanvas, g_nFadeIndex);
    if g_nFadeIndex <= 1 then
      g_boDoFadeOut := False
    else
      Dec(g_nFadeIndex, 2);
  end
  else if g_boDoFadeIn then
  begin
    if g_nFadeIndex > 29 then
      g_nFadeIndex := 29;
    MakeDark(g_GameCanvas, g_nFadeIndex);
    if g_nFadeIndex >= 29 then
      g_boDoFadeIn := False
    else
      Inc(g_nFadeIndex, 2);
  end
  else if g_boDoFastFadeOut then
  begin
    if g_nFadeIndex < 1 then
      g_nFadeIndex := 1;
    MakeDark(g_GameCanvas, g_nFadeIndex);
    if g_nFadeIndex > 1 then
      Dec(g_nFadeIndex, 4);
  end;

  if FTryReconnet then
  begin
    g_GameCanvas.FillRect(Rect(0, 0, SCREENWIDTH, SCREENHEIGHT), $AF000000);
    ATexture := g_77Images.Images[244];
    if ATexture <> nil then
      g_GameCanvas.Draw((SCREENWIDTH - ATexture.Width) div 2,
        (SCREENHEIGHT - ATexture.Height) div 2, ATexture);
    ATexture := FontManager.Default.TextOut('连接断开,正在尝试重连...');
    if ATexture <> nil then
      g_GameCanvas.DrawBoldText((SCREENWIDTH - ATexture.Width) div 2,
        (SCREENHEIGHT - ATexture.Height) div 2, ATexture, clWhite,
        FontBorderColor);
  end;

  if ClientConf.boShowBrief and (g_MySelf <> nil) then
  begin
    ABrief := '时间: ' + FormatDateTime('hh:mm:ss', Now) +
      Format(' 经验: %d/%d', [g_MySelf.m_Abil.Exp, g_MySelf.m_Abil.MaxExp]);
    if g_nGold > 0 then
      ABrief := ABrief + ' 金币: ' + IntToStr(g_nGold);
    if g_dwGameGold > 0 then
      ABrief := ABrief + ' 元宝: ' + IntToStr(g_dwGameGold);
    if g_TargetCret <> nil then
      ABrief := ABrief + Format(' 目标: %s(%d/%d)', [g_TargetCret.m_sUserName,
        g_TargetCret.m_nCurrX, g_TargetCret.m_nCurrY])
    else if g_MagicLockActor <> nil then
      ABrief := ABrief + Format(' 目标: %s(%d/%d)', [g_MagicLockActor.m_sUserName,
        g_MagicLockActor.m_nCurrX, g_MagicLockActor.m_nCurrY]);
    g_GameCanvas.BoldText(4, 4, ABrief, clLime, clBlack);
  end;
{$IFDEF DEBUG}
  // GetCursorPos(p);
  // p := ScreenToClient(p);
  // p.X := Round(SCREENWIDTH / ClientWidth  * p.X);
  // p.Y := Round(SCREENHEIGHT / ClientHeight  * p.Y);
  // g_GameCanvas.BoldText(32, 70, Format('%d, %d', [p.X, p.Y]), clLime, clBlack);
{$ENDIF}
end;

procedure TfrmMain.HandleConnectFailure();
begin

end;

procedure TfrmMain.DoGetTextHeight(const Text: String; Font: TFont;
  var Value: Integer);
var
  ASize: TSize;
begin
  DoGetTextExtent(Text, Font, ASize);
  Value := ASize.cy;
end;

procedure TfrmMain.DoGetTextWidth(const Text: String; Font: TFont;
  var Value: Integer);
var
  ASize: TSize;
begin
  DoGetTextExtent(Text, Font, ASize);
  Value := ASize.cx;
end;

procedure TfrmMain.DoGetTextExtent(const Text: string; Font: TFont;
  var Value: TSize);
begin
  Canvas.Font.Assign(Font);
  Value.cx := 0;
  Value.cy := 0;
  Windows.GetTextExtentPoint32(Canvas.Handle, Text, Length(Text), Value);
end;
end.






