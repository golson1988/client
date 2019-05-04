unit DrawScrn;

interface
{$J+}
uses
  Windows, SysUtils, Classes, Graphics, GraphUtil, Controls, Math, IntroScn, Actor,
  cliUtil, clFunc, HUtil32, Grobal2, DateUtils, DXHelper, uTextures, uMessageParse,
  Generics.Collections, Common, StrUtils, AbstractCanvas, AbstractTextures, AbstractDevices,
  AsphyreFactory, AsphyreTypes, RegularExpressions, uMapDesc, uTypes, WIL, MMSystem,ItemState,
  uUITypes,uSyncObj;

const
  AREASTATEICONBASE = 150; // area state icon base Prguse.wil中150战斗151安全
  HEALTHBAR_BLACK = 0; // Prguse3.wil中
  HEALTHBAR_RED = 1; // Prguse3.wil中
  STR_ADDTION = '[+%d]';
  STR_ADDTIONFULL = '[+ %d-%d]';

type
  TItemFromKind = (fkNormal, fkUse, fkMarket, fkMall, fkStall, fkStallBuy, fkQueryStall, fkQueryStallBuy,fkShowCommondE);
  TDrawItemManager = class;
  // 走马灯
  TDrawScreen = class
  private
    m_dwFrameTime: LongWord;
    m_CountDownLines: TList<TuSimpleMessage>;
    m_CenterLines: TList<TuSimpleMessage>;
    m_BoardLines: TList<TuSimpleMessage>;
    m_HintMessage: TuMerchantMessage;
    m_MsgSection: TFixedCriticalSection;
    // 滚动消息
    m_SysBoardxPos: Integer;
    m_SysBoardTime: LongWord;
    FDrawItemManager,
    FClickItemHint: TDrawItemManager;
    FOnClickHintInited: TNotifyEvent;
    m_dwAniTime: LongWord;
    m_nAniCount: Integer;
    function GetItemHint: Boolean;
    procedure ClearMoveMessages;
    procedure DoDrawHintMessageBackGround(Sender: TObject);
    procedure DoHintMessageGetItemImages(ANode: TMessageNode);
    procedure DoChatItemMoved(AItem: TClientItem; X, Y: Integer);
    procedure DoChatItemClick(AItem: TClientItem; X, Y: Integer);
    procedure DoChatCommandClick(const ACommand: String);
    procedure MessageLock;
    procedure MessageUnLock;
    procedure ParseItemHint(AItemManager: TDrawItemManager; X, Y: Integer; AItem: TClientItem; AItemFrom: TItemFromKind; AGold, AGameGold, ACount: Integer);
    procedure DoClickItemHintInited(Sender: TObject);
  public
    CurrentScene: TScene; // 当前场景
    ChatMessage: TuChatMessage;
    ChatHisMessage: TuChatMessage;

    HintX, HintY, HintWidth, HintHeight: Integer;
    HintAlign: Byte;
    HintUp: Boolean;
    HintColor: TColor;

    constructor Create;
    destructor Destroy; override;
    procedure KeyPress(var Key: Char);
    procedure KeyDown(var Key: Word; Shift: TShiftState);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Initialize;
    procedure Finalize;
    procedure ChangeScene(scenetype: TSceneType);
    procedure BeginDrawScreen(Device: TAsphyreDevice; MSurface: TAsphyreCanvas);
    procedure EnterScene(SceneType : TSceneType);
    procedure OutScene(SceneType : TSceneType);
    procedure DrawScreen(MSurface: TAsphyreCanvas);
    procedure DrawScreenTop(MSurface: TAsphyreCanvas);
    procedure DrawMoveMessage(MSurface: TAsphyreCanvas); inline;
    procedure AddSysMsg(const msg: string; AColor: TColor = clGreen);
    procedure UpdateSysMsg(const msg: string; AColor: TColor);
    procedure AddChatBoardString(const Str, ObjList: string; FColor, BColor: TColor);
    procedure ClearChatBoard;

    procedure ShowHint(X, Y: Integer; str: string; color: TColor; drawup: Boolean; s1: string = ''; s2: string = ''); overload;
    procedure ShowHint(X, Y: Integer; const HintStr: String); overload;
    procedure ShowHint(X, Y: Integer; const HintStr: String; Align: Byte); overload;
    procedure ShowHint(X, Y: Integer; FixPixel : Integer ; const HintStr: String); overload;
    procedure ShowHint(P: TPoint; const HintStr: String); overload;
    procedure ClearHint;
    {走马灯}
    procedure AddSysBoard(const msg: String);
    procedure DrawScreenBoard(MSurface: TAsphyreCanvas);
    {居中信息}
    procedure AddCenterLetter(const Data: string; DuraTick : Integer);
    procedure DrawScreenCenterLetter(MSurface: TAsphyreCanvas);
    {置底信息}
    procedure AddCountDown(const Message: string; Flag: Integer; ChangeMapDelete: Boolean );
    procedure DeleteCountDown(Flag: Integer);
    procedure ChangeMapDeleteCountDown;
    procedure DrawScreenCountDown(MSurface: TAsphyreCanvas);
    procedure DrawHint(MSurface: TAsphyreCanvas);

    procedure ShowClickItemHint(AItem: TClientItem; AItemFrom: TItemFromKind);

    procedure ShowItemHint(X, Y: Integer; AItem: TClientItem; AItemFrom: TItemFromKind; AGold: Integer = 0; AGameGold: Integer = 0; ACount: Integer = 0); overload;
    procedure ShowItemHint(P: TPoint; AItem: TClientItem; AItemFrom: TItemFromKind; AGold: Integer = 0; AGameGold: Integer = 0; ACount: Integer = 0); overload;
    procedure ShowShopItemHint(X, Y: Integer; AItem: TShopItem; const ISGift: Boolean = False); overload;
    procedure ShowShopItemHint(P: TPoint; AItem: TShopItem; const ISGift: Boolean = False; const OffsetX: Integer = 0; const OffsetY: Integer = 20); overload;
    procedure UpdateItemHintPostion(P: TPoint; const OffsetX: Integer = 0; const OffsetY: Integer = 20);
    property ItemHint: Boolean read GetItemHint;
    property ClickItemHint: TDrawItemManager read FClickItemHint;
    property OnClickHintInited: TNotifyEvent read FOnClickHintInited write FOnClickHintInited;
  end;

  TDrawItemInfo = class;

  TItemDrawGroup = class
  private
    FDrawItemInfo: TDrawItemInfo;
    Width: Integer;
    Height: Integer;
    Spacing: Boolean;
  protected
    procedure Calc(ISurface: TAsphyreCanvas); virtual; abstract;
    procedure Draw(ISurface: TAsphyreCanvas; var Y: Integer; const ALeft, HintW, HintH: Integer); virtual;
    function GetHasItem: Boolean; virtual;
  public
    constructor Create(ADrawItemInfo: TDrawItemInfo); virtual;
    property HasItem: Boolean read GetHasItem;
  end;

  TItemNameDrawGroup = class(TItemDrawGroup)
  private
    type
      TNameNode = class
        S: String;
        Color: TColor;
      end;
  private
    FName: String;
    FUpgradeDesc:string;
    FUpgradeDescColor:TColor;
    FShowUpgrade:Boolean;
    FNodes: TList;
    FNameColor: TColor;
    procedure AddStrNode(const Value: String);
    procedure AddPropNode(const Prop: String);
    procedure Parse;
    function GetDisplayText: String;
  protected
    procedure Calc(ISurface: TAsphyreCanvas); override;
    procedure Draw(ISurface: TAsphyreCanvas; var Y: Integer; const ALeft, HintW, HintH: Integer); override;
  public
    constructor Create(ADrawItemInfo: TDrawItemInfo; const AName: String);
    destructor Destroy; override;
  end;

  TItemStarDrawGroup = class(TItemDrawGroup)
  private
    FStartIdx: Integer;
    FSum: Integer;
    FStarLen,
    FStarSize,
    FOffsetY: Integer;
  protected
    procedure Calc(ISurface: TAsphyreCanvas); override;
    procedure Draw(ISurface: TAsphyreCanvas; var Y: Integer; const ALeft, HintW, HintH: Integer); override;
    procedure DrawEx(ISurface: TAsphyreCanvas; ALeft, X, Y: Integer);
  public
    constructor Create(ADrawItemInfo: TDrawItemInfo; const AStarLen, AStrarSize: Integer);
  end;

  TItemSoulDrawGroup = class(TItemDrawGroup)
  private
    FExp,
    FMaxExp: Integer;
  protected
    procedure Calc(ISurface: TAsphyreCanvas); override;
    procedure Draw(ISurface: TAsphyreCanvas; var Y: Integer; const ALeft, HintW, HintH: Integer); override;
  public
    constructor Create(ADrawItemInfo: TDrawItemInfo; const Exp, MaxExp: Integer);
  end;

  TuDescLineItem = class
    FontColor: TColor;
    OffsetX,
    Width: Integer;
    Data: String;
  end;

  TuDescLine = class
    Items: TList<TuDescLineItem>;
    Width: Integer;
    constructor Create;
    destructor Destroy; override;
    function Add(const Data: String; FontColor: TColor): TuDescLineItem;
  end;

  TItemDescDrawGroup = class(TItemDrawGroup)
  private
    Lines: TList<TuDescLine>;
    FDesc: String;
  protected
    procedure Calc(ISurface: TAsphyreCanvas); override;
    procedure Draw(ISurface: TAsphyreCanvas; var Y: Integer; const ALeft, HintW, HintH: Integer); override;
  public
    constructor Create(ADrawItemInfo: TDrawItemInfo; const ADesc: String);
    destructor Destroy; override;
  end;

  TItemInfoDrawGroup = class;

  TLineType = (ltNormal,ltSample,ltTitle,ltSplitLine);
  TDrawItemLine = class
  private
    Caption, Value, Extend: String;
    clCaption, clValue, clExtend: TColor;
    Height,Width: Integer;
    LineType:TLineType;

//    Sample: Boolean;
//    ISTitle: Boolean;
//    ISHR: Boolean;
//    isSplitLine : Boolean;
  end;

  TItemInfoDrawGroup = class(TItemDrawGroup)
  private
    FLines: TList;
    FMaxCaptionW, FMaxValueW, FMaxExtendW: Integer;
  protected
    procedure Calc(ISurface: TAsphyreCanvas); override;
    procedure Draw(ISurface: TAsphyreCanvas; var Y: Integer; const ALeft, HintW, HintH: Integer); override;
    function GetHasItem: Boolean; override;
  public
    function AddLine(const ACaption, AValue: String; const DefColor: TColor = clWhite): TDrawItemLine;
    function AddSampleLine(const ACaption: String; const DefColor: TColor = clWhite): TDrawItemLine;
    function AddSplitlLine(nHeight : Integer = 0):TDrawItemLine;
    function AddSplitlLineFirst(nHeight : Integer = 0):TDrawItemLine;
    constructor Create(ADrawItemInfo: TDrawItemInfo); override;
    destructor Destroy; override;
    procedure SetSplitlLineWidth(nWidth:Integer);
  end;

  TItemHoleDrawGroup = class(TItemDrawGroup)
  private
    const SPACE_WIDTH = 8;
  private
    FLineH: Integer;
    FMax, FCount: Integer;
    function GetHoleName(ItemIndex: Integer): String;
  protected
    procedure Calc(ISurface: TAsphyreCanvas); override;
    procedure Draw(ISurface: TAsphyreCanvas; var Y: Integer; const ALeft, HintW, HintH: Integer); override;
  end;

  TDrawItemInfo = class
  private
    const SPACINGHEIGHT = 4;
  private
    FItemWay : Byte; //物品产出途径
    FItemIndex: Integer;
    FBGColor: TColor;
    FName,
    FPropLine: String;
    FStdItem: TStdItem;
    FLooks : Integer;
    FGold,
    FGameGold,
    FGamePoint,
    FCount: Integer;
    FNeed,
    FNeedLevel,
    FDura: Integer;
    FDuraMax: Integer;
    FSoulExp,
    FSoulMaxExp: Integer;
    FAddLValue: TAddValue;
    FAddValue: TAddValue;
    FAddProperty: TAddProperty;
    FAddPoint: TAddPoint;
    FAddLevel: TAddLevel;
    FAddHold: TAddHold;
    FBindState: Integer;
    FMaxDate: TDateTime;
    FTotalAbility: Int64;
    MaxLineWidth,
    ItemWidth, ItemHeight: Integer;
    FItemFrom: TItemFromKind;
    FSpaceW: Integer;
    FGroups: TList;
    FHasStart,
    FHasHole: Boolean;
    FStartDrawGroup: TItemStarDrawGroup;
    FCaption1:string; //地图名称标题。    //12
    FCaption2:string; //物品来源标题      // 12
    FCaption3:string; //物品归属者标题    // 12
    FText1:string;  //24    //地图名称
    FText2:string; //24    //来源
    FText3:string; //24   //归属
    FFromDateTime:TDateTime;  // 8  //时间
    FDesc : string;     // 128
    procedure DrawBackGround(MSurface: TAsphyreCanvas; ALeft: Integer);
    function GetItemTypeName: String;
    function GetItemWayName:string;
    function GetDuraStr(Dura, maxdura: Integer): string;
    function SoulEnabled: Boolean;
    function GetDura100Str(Dura, maxdura: Integer): string;
    function GetPrice: Integer;
    procedure CalcBounds(MSurface: TAsphyreCanvas);
    procedure Init(MSurface: TAsphyreCanvas);
    procedure DrawItemTexture(MSurface: TAsphyreCanvas; ALeft: Integer);
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TDrawClientItemInfo = class(TDrawItemInfo)
  public
    constructor Create(AItem: TClientItem);
  end;

  TDrawShopItemInfo = class(TDrawItemInfo)
  public
    constructor Create(AItem: TShopItem);
  end;

  TDrawItemManager = class
  private
    Left, Top: Integer;
    FInited,
    FScroll: Boolean;
    FScrollSize: Integer;
    FScrollTime: LongWord;
    FScrollPosition: Integer;
    FScrollTop: Boolean;
    FTargetTexture: TAsphyreRenderTargetTexture;
    ADrawItemInfo: TDrawItemInfo;
    ADrawItemInfo1: TDrawItemInfo;
    ADrawItemInfo2: TDrawItemInfo;
    FOnInited: TNotifyEvent;
    procedure ChangeXY(X, Y: Integer);
    procedure Init(Sender: TObject);
    procedure DrawTarget(Sender: TObject);
    function GetWidth: Integer;
    function GetHeight: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure BeginDrawScreen(Device: TAsphyreDevice; MSurface: TAsphyreCanvas);
    procedure Draw(MSurface: TAsphyreCanvas); overload;
    procedure Draw(MSurface: TAsphyreCanvas; X, Y: Integer); overload;
    function InRealArea(X, Y: Integer): Boolean;
    procedure Clear;
    property Inited: Boolean read FInited;
    property OnInited: TNotifyEvent read FOnInited write FOnInited;
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
  end;

  function GetHoleDisplayValue(AProp, AValue: Integer): String;

implementation

uses
  AsphyreTextureFonts, ClMain, MShare, Share, SoundUtil,DWinCtl,FState,uClientCustomSetting;

constructor TDrawScreen.Create;
begin
  CurrentScene := nil;
  m_MsgSection := TFixedCriticalSection.Create;
  m_dwFrameTime := GetTickCount;
  //ChatMessage.OnChatItemMoved := DoChatItemMoved;


  ChatMessage := TuChatMessage.Create;
  ChatMessage.OnChatItemClick := DoChatItemClick;
  ChatMessage.OnCommandClick := DoChatCommandClick;
  ChatMessage.ChatBoxWidth  :=  SCREENWIDTH - 412;
  ChatMessage.ChatBoxHeight :=  108;
  ChatMessage.TopLine :=  0;

  ChatHisMessage := TuChatMessage.Create;
  ChatHisMessage.OnChatItemClick := DoChatItemClick;
  ChatHisMessage.OnCommandClick := DoChatCommandClick;
  ChatHisMessage.ChatBoxWidth  :=  348;
  ChatHisMessage.ChatBoxHeight :=  190;
  ChatHisMessage.TopLine :=  0;

  // 走马灯
  m_SysBoardxPos  := 0;
  m_nAniCount := 0;
  m_CountDownLines  :=  TList<TuSimpleMessage>.Create;
  m_CenterLines     :=  TList<TuSimpleMessage>.Create;
  m_BoardLines      :=  TList<TuSimpleMessage>.Create;
  FDrawItemManager  :=  TDrawItemManager.Create;
  FClickItemHint  :=  TDrawItemManager.Create;
  FClickItemHint.OnInited := DoClickItemHintInited;
  m_HintMessage :=  TuMerchantMessage.Create;
  m_HintMessage.DrawBackground := False;
  m_HintMessage.OnDrawBackGround := DoDrawHintMessageBackGround;
  m_HintMessage.OnGetItemImages := DoHintMessageGetItemImages;
end;

destructor TDrawScreen.Destroy;
begin
  ClearMoveMessages;
  FreeAndNilEx(m_CountDownLines);
  FreeAndNilEx(m_CenterLines);
  FreeAndNilEx(m_BoardLines);
  FreeAndNilEx(FDrawItemManager);
  FreeAndNilEx(FClickItemHint);
  FreeAndNilEx(m_HintMessage);
  FreeAndNilEx(ChatMessage);
  FreeAndNilEx(ChatHisMessage);
  m_MsgSection.Free;
  inherited Destroy;
end;

procedure TDrawScreen.DoDrawHintMessageBackGround(Sender: TObject);
var
  X, Y: Integer;
begin
  X := HintX;
  Y := HintY;
  case HintAlign of
    1: X := X - m_HintMessage.Width;
    2: X := X - m_HintMessage.Width div 2;
  end;
  if X < 0 then
    X :=  0
  else if X + m_HintMessage.Width > SCREENWIDTH then
    X :=  SCREENWIDTH - m_HintMessage.Width;
  if Y < 0 then
    Y :=  0
  else if Y + m_HintMessage.Height > SCREENHEIGHT then
    Y :=  SCREENHEIGHT - m_HintMessage.Height;
  DrawMerchantMessageBackground(X, Y, m_HintMessage);
end;

procedure TDrawScreen.DoHintMessageGetItemImages(ANode: TMessageNode);
begin
  MerchantMessageGetItemImages(ANode);
end;

procedure TDrawScreen.DoChatItemMoved(AItem: TClientItem; X, Y: Integer);
begin
  if AItem.Name <> '' then
  begin
    if (AItem.MakeIndex = g_MouseItem.MakeIndex) and ItemHint then
      UpdateItemHintPostion(g_Application._CurPos)
    else
    begin
      g_MouseItem := AItem;
      ShowItemHint(g_Application._CurPos, g_MouseItem, fkNormal);
    end;
  end
  else
  begin
    g_MouseItem.Name := '';
    ClearHint;
  end;
end;

procedure TDrawScreen.DoChatItemClick(AItem: TClientItem; X, Y: Integer);
begin
  ShowClickItemHint(AItem, fkNormal);
end;

procedure TDrawScreen.DoChatCommandClick(const ACommand: String);
begin
  g_SoundManager.DXPlaySound(s_glass_button_click);
  if ACommand <> '' then
  begin
    if (ACommand[1] + ACommand[2] + ACommand[3] + ACommand[4] + ACommand[5] + ACommand[6] = '@Link:') then
      OpenBrowser(Copy(ACommand, 7, Length(ACommand) - 6))
    else
      FrmMain.SendMerchantDlgSelect(g_nCurMerchant, ACommand);
  end;
end;

procedure TDrawScreen.Initialize;
begin
end;

procedure TDrawScreen.Finalize;
begin
  ClearMoveMessages;
  ClearChatBoard;
  m_SysBoardxPos  :=  0;
  m_SysBoardTime  :=  0;
end;

function TDrawScreen.GetItemHint: Boolean;
begin
  Result  :=  Assigned(FDrawItemManager.ADrawItemInfo);
end;

procedure TDrawScreen.KeyPress(var Key: Char);
begin
  if CurrentScene <> nil then
    CurrentScene.KeyPress(Key);
end;

procedure TDrawScreen.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if CurrentScene <> nil then
    CurrentScene.KeyDown(Key, Shift);
end;

procedure TDrawScreen.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if CurrentScene <> nil then
    CurrentScene.MouseMove(Shift, X, Y);
end;



procedure TDrawScreen.MessageLock;
begin
  m_MsgSection.Enter;
end;

procedure TDrawScreen.MessageUnLock;
begin
  m_MsgSection.Leave;
end;

procedure TDrawScreen.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if CurrentScene <> nil then
    CurrentScene.MouseDown(Button, Shift, X, Y);
end;

procedure TDrawScreen.ChangeScene(scenetype: TSceneType);
begin
  if CurrentScene <> nil then
  begin
    CurrentScene.CloseScene;
    if CurrentScene.SceneType <> stPlayGame then
      OutScene(CurrentScene.SceneType);
  end;

  case scenetype of
    stIntro:
      CurrentScene := IntroScene;
    stLogin:
      CurrentScene := LoginScene;
    stSelectCountry:
      ;
    stSelectChr:
      CurrentScene := SelectChrScene;
    stNewChr:
      ;
    stLoading:
      ;
    stLoginNotice:
      CurrentScene := LoginNoticeScene;
    stPlayGame:
    begin
      CurrentScene := PlayScene;
      ClearMoveMessages;
      g_WEffectLogin.ClearCache;
      g_WNSelectImages.ClearCache;
      g_WChrSelImages.ClearCache;
      g_WChrSel2Images.ClearCache;
    end;
  end;

  EnterScene(scenetype);

  if CurrentScene <> nil then
    CurrentScene.OpenScene;
end;

// 添加系统信息
procedure TDrawScreen.AddSysMsg(const msg: string; AColor: TColor);
begin
  Textures_Sys.AddItem(msg, AColor);
end;

procedure TDrawScreen.UpdateSysMsg(const msg: string; AColor: TColor);
var
  I: Integer;
begin
  for I := 0 to Textures_Sys.Count - 1 do
  begin
    if SameText(msg, Textures_Sys[I].Message) then
    begin
      Textures_Sys[I].TimeTick := GetTickCount;
      Textures_Sys[I].Color := AColor;
      Exit;
    end;
  end;
  AddSysMsg(msg, AColor);
end;

procedure TDrawScreen.AddSysBoard(const msg: String );
var
  ALine: TuSimpleMessage;
begin
  ALine       :=  TuSimpleMessage.Create;
  ALine.DefFontColor  :=  clYellow;
  ALine.Bold  :=  True;
  ALine.TimeEnd :=  0;
  ALine.Parse(msg);
  m_BoardLines.Add(ALine);
end;

// 添加信息聊天板
procedure TDrawScreen.AddChatBoardString(const Str, ObjList: string; FColor, BColor: TColor);
begin
  ChatMessage.AddMessage(Str, ObjList, FColor, BColor);
end;

procedure TDrawScreen.ShowHint(X, Y: Integer; const HintStr: String);
begin
  HintX := X;
  HintY := Y;
  HintAlign := 0;
  if HintStr <> m_HintMessage.MessageStr then
  begin
    m_HintMessage.DrawBackground  :=  g_UIManager.Form.HintEditor.ShowHintBorder;
    m_HintMessage.Parse(HintStr);
  end;
end;

procedure TDrawScreen.ShowHint(X, Y: Integer; const HintStr: String; Align: Byte);
begin
  HintX := X;
  HintY := Y;
  HintAlign := Align;
  if HintStr <> m_HintMessage.MessageStr then
  begin
    m_HintMessage.DrawBackground  :=  g_UIManager.Form.HintEditor.ShowHintBorder;
    m_HintMessage.Parse(HintStr);
  end;
end;

procedure TDrawScreen.ShowHint(P: TPoint; const HintStr: String);
begin
  ShowHint(P.X, P.Y + 18, HintStr);
end;

procedure TDrawScreen.ShowHint(X, Y: Integer; FixPixel : Integer ; const HintStr: String);
begin
  HintX := X;
  HintY := Y;
  HintAlign := 0;
  if HintStr <> m_HintMessage.MessageStr then
  begin
    m_HintMessage.DrawBackground  := true;
    m_HintMessage.OffSetXY :=  FixPixel;
    m_HintMessage.Parse(HintStr);
  end;
end;

//鼠标放在某个物品上显示的信息
procedure TDrawScreen.ShowHint(X, Y: Integer; str: string; color: TColor;
  drawup: Boolean; s1: string = ''; s2: string = '');
var
  data: string;
  w: Integer;
  i01: Integer;
begin
  HintX := X;
  HintY := Y;
  HintAlign := 0;
  data  :=  Str;
  if s1 <> '' then
  begin
    if data <> '' then
      data  :=  data + '\';
    data  :=  data + s1;
  end;
  if s2 <> '' then
  begin
    if data <> '' then
      data  :=  data + '\';
    data  :=  data + s2;
  end;
  if data <> m_HintMessage.MessageStr then
  begin
    m_HintMessage.DrawBackground  :=  g_UIManager.Form.HintEditor.ShowHintBorder;
    m_HintMessage.Parse(data);
  end;
end;

procedure TDrawScreen.ClearHint;
begin
  FDrawItemManager.Clear;
  m_HintMessage.Clear;
end;

procedure TDrawScreen.ClearMoveMessages;
var
  I: Integer;
begin
  for I := 0 to m_BoardLines.Count - 1 do
    m_BoardLines.Items[I].Free;
  m_BoardLines.Clear;
  for I := 0 to m_CountDownLines.Count - 1 do
    m_CountDownLines.Items[I].Free;
  m_CountDownLines.Clear;
  for I := 0 to m_CenterLines.Count - 1 do
    m_CenterLines.Items[I].Free;
  m_CenterLines.Clear;
  for I := 0 to m_BoardLines.Count - 1 do
    m_BoardLines.Items[I].Free;
  m_BoardLines.Clear;
end;

procedure TDrawScreen.ClearChatBoard;
begin
  Textures_Sys.Clear;
  ChatMessage.Clear;
  ChatMessage.TopLine := 0;
  ChatHisMessage.Clear;
  ChatHisMessage.TopLine := 0;
end;

procedure TDrawScreen.BeginDrawScreen(Device: TAsphyreDevice; MSurface: TAsphyreCanvas);
begin
  if CurrentScene <> nil then
    CurrentScene.BeginScene(Device, MSurface);
  FDrawItemManager.BeginDrawScreen(Device, MSurface);
  FClickItemHint.BeginDrawScreen(Device, MSurface);
end;

procedure TDrawScreen.DrawScreen(MSurface: TAsphyreCanvas);
var
  i, K: Integer;
  Actor: TActor;
  d: TAsphyreLockableTexture;
  DropItem: PTDropItem;
  mx, my, OffsetY: Integer;
  ATexture: TuTexture;
  AList: TList;
begin
  if CurrentScene <> nil then
    CurrentScene.PlayScene(MSurface);
  if g_MySelf = nil then
    Exit;

  if CurrentScene = PlayScene then
  begin
    if TimeGetTime - m_dwAniTime >= 100 then
    begin
      m_dwAniTime := TimeGetTime;
      Inc(m_nAniCount);
      if m_nAniCount > 100000 then
        m_nAniCount := 0;
    end;

    with PlayScene do
    begin
      AList := m_ActorList.LockList;
      try
        for K := 0 to AList.Count - 1 do
        begin
          Actor := AList.Items[K];
          if (Actor <> nil) and (g_FocusCret <> Actor) and Actor.m_boVisible and (Actor.m_nSayX <> -9999) then
          begin
            Actor.NameTextOut(MSurface, Actor.m_nSayX, Actor.m_nSayY + 30);
            Actor.DrawBlood(MSurface);
            Actor.TitleOut(MSurface, Actor.m_nSayX, Actor.m_nSayY, m_nAniCount);
            Actor.DrawSaying(MSurface, Actor.GetSayX(), Actor.GetSayY());
          end;
        end;
      finally
        m_ActorList.UnlockList;
      end;
    end;


    // 画当前选择的物品/人物的名字
    if g_FocusCret <> nil then
    begin
      if PlayScene.IsValidActor(g_FocusCret) then
      begin
        g_FocusCret.DrawBlood(MSurface);
        g_FocusCret.TitleOut(MSurface, g_FocusCret.m_nSayX, g_FocusCret.m_nSayY, m_nAniCount);
        g_FocusCret.DrawSaying(MSurface, g_FocusCret.GetSayX(), g_FocusCret.GetSayY());

        ATexture  :=  Textures.ObjectName(MSurface, g_FocusCret.m_sDescUserName + '\' + g_FocusCret.m_sUserName);
        if ATexture <> nil then
        begin
          case g_FocusCret.Race of
            0, 1:  ATexture.Draw(MSurface, g_FocusCret.GetSayX() - ATexture.Width div 2, g_FocusCret.GetSayY() + 30, g_FocusCret.m_nNameColor);
            50:
            begin
              if not TNpcActor(g_FocusCret).g_boNpcWalk and (g_FocusCret.m_sUserName <> '') then
                ATexture.Draw(MSurface, g_FocusCret.GetSayX() - ATexture.Width div 2, g_FocusCret.GetSayY() + 30, g_FocusCret.m_nNameColor);
            end;
            else
            begin
              if g_FocusCret.m_boVisible then
              begin
                if g_FocusCret.m_boMonNPC and (g_FocusCret.m_nNameColor = clWhite) then
                  ATexture.Draw(MSurface, g_FocusCret.GetSayX() - ATexture.Width div 2, g_FocusCret.GetSayY(){-ATexture.Height div 2} + 30, clLime)
                else
                  ATexture.Draw(MSurface, g_FocusCret.GetSayX() - ATexture.Width div 2, g_FocusCret.GetSayY() + 30, g_FocusCret.m_nNameColor);
              end;
            end;
          end;
        end;
      end;
    end;

    // 玩家名称
    if g_boSelectMyself then
    begin
      ATexture := Textures.ObjectName(MSurface, g_MySelf.m_sDescUserName + '\' + g_MySelf.m_sUserName);
      if ATexture <> nil then
        ATexture.Draw(MSurface, g_MySelf.GetSayX() - ATexture.Width div 2, g_MySelf.GetSayY(){-ATexture.Height div 2} + 30, g_MySelf.m_nNameColor);
    end;

    if g_boSDMinimap then
    begin
      FrmDlg.DMiniMap_SD.Visible := True;
      FrmDlg.DWMiniMap.Visible := False;
    end;

  end;
end;

// 显示左上角信息文字
procedure TDrawScreen.DrawScreenTop(MSurface: TAsphyreCanvas);
begin
  if g_MySelf = nil then Exit;

  if CurrentScene = PlayScene then
  begin
    case UIWindowManager.Form.Buffers.Position of
      upAbsoluteLeftBottom: Textures_Sys.Draw(MSurface, 8, SCREENHEIGHT - g_BottomHeight + UIWindowManager.Form.Buffers.YMargin - 8, False);
      else
        Textures_Sys.Draw(MSurface, 8, SCREENHEIGHT - g_BottomHeight, False);
    end;
  end;
end;

function _SceneType(SceneType: TSceneType):DWinCtl.TControlInScene;
begin
  Result := cisNone;
  case SceneType of
    stIntro: Result := cisLogin ;
    stLogin: Result := cisLogin ;
    stSelectCountry: ;
    stSelectChr: Result := cisSelChr;
    stNewChr: ;
    stLoading: ;
    stLoginNotice: Result := cisNotice ;
    stPlayGame: Result := cisPlayGame ;
  end;
end;

procedure TDrawScreen.EnterScene(SceneType: TSceneType);
var
  St : TControlInScene;
  D : TDControl;
  I : Integer;
begin
  St := _SceneType(SceneType);
  g_DWinMan.NowScene := St;
  if St = cisNone then
    Exit;



  for i := 0 to g_DWinMan.DXControls.Count - 1 do
  begin
    D := g_DWinMan.DXControls[i];
    if (D.Propertites.OwnerScene = St) and (D.Propertites.IntoSceneShow)then
    begin
      D.Visible := True;
    end;
  end;
end;

procedure TDrawScreen.OutScene(SceneType: TSceneType);
var
  St : TControlInScene;
  D : TDControl;
  I : Integer;
begin
  St := _SceneType(SceneType);
  if St = cisNone then
    Exit;
  for i := 0 to g_DWinMan.DXControls.Count - 1 do
  begin
    D := g_DWinMan.DXControls[i];
    if (D.Propertites.OwnerScene = St) and (D.Propertites.OutSceneHide)then
    begin
      D.Visible := False;
    end;
  end;
end;

function _Copy(str: String; Index, Count: Integer): String;
var
  s: WideString;
Begin
  s := WideString(str);
  Result := Copy(s, index, Count);
End;

procedure TDrawScreen.AddCenterLetter(const Data: string; DuraTick:Integer);
var
  ALine: TuSimpleMessage;
begin
  if m_CenterLines.Count > 5 then
  begin
    m_CenterLines.Items[0].Free;
    m_CenterLines.Delete(0);
  end;

  ALine               :=  TuSimpleMessage.Create;
  ALine.DefFontColor  :=  clYellow;
  ALine.Bold          :=  True;
  ALine.TimeEnd       :=  GetTickCount() + DuraTick;
  ALine.Parse(Data);
  m_CenterLines.Add(ALine);
end;

procedure DrawBackground(MSurface: TAsphyreCanvas; Left, Top, Width, Height: Integer);
begin
  MSurface.FillRectAlpha(Rect(Left - 8, Top - 4, Left + Width + 8, Top + Height + 3), clBlack, 155);
end;

procedure TDrawScreen.DrawScreenCenterLetter(MSurface: TAsphyreCanvas);
var
  I, X, Y, AllHeight, AWidth: Integer;
  ALine: TuSimpleMessage;
begin
  if CurrentScene <> PlayScene then Exit;
  if m_CenterLines.Count = 0 then Exit;

  AllHeight :=  0;
  AWidth  :=  0;
  for I := m_CenterLines.Count -1 downto 0 do
  begin
    ALine :=  m_CenterLines.Items[I];
    if GetTickCount >= ALine.TimeEnd then
    begin
      FreeAndNilEx(ALine);
      m_CenterLines.Delete(I);
    end
    else
    begin
      ALine.Init(MSurface);
      AllHeight :=  AllHeight + ALine.Height + 2;
      AWidth  :=  Max(AWidth, ALine.Width);
    end;
  end;
  if m_CenterLines.Count > 0 then
  begin
    Y :=  (SCREENHEIGHT - g_BottomHeight - AllHeight) div 2;
    DrawBackground(MSurface, (SCREENWIDTH - AWidth) div 2, Y, AWidth, AllHeight);
    for I := m_CenterLines.Count -1 downto 0 do
    begin
      X :=  (SCREENWIDTH - m_CenterLines.Items[I].Width) div 2;
      m_CenterLines.Items[I].Draw(MSurface, X, Y);
      Y :=  Y + m_CenterLines.Items[I].Height + 2;
    end;
  end;
end;

procedure TDrawScreen.DrawScreenBoard(MSurface: TAsphyreCanvas);
var
  X: Integer;
  ALine: TuSimpleMessage;
  I: Integer;
begin
  if CurrentScene <> PlayScene then Exit;
  if m_BoardLines.Count = 0 then Exit;

  if m_BoardLines.Count > 0 then
  begin
    ALine :=  m_BoardLines.Items[0];
    if GetTickCount - m_SysBoardTime > 35 then
    begin
      Inc(m_SysBoardxPos, 1);
      m_SysBoardTime := GetTickCount;
    end;
    X :=  SCREENWIDTH - m_SysBoardxPos;
    MSurface.FillRectAlpha(Rect(0, 2, SCREENWIDTH, ALine.Height + 8), clBlack, 155);
    ALine.Draw(MSurface, X, 4);
    if m_SysBoardxPos > SCREENWIDTH + ALine.Width then
    begin
      m_SysBoardxPos  :=  0;
      m_BoardLines.Items[0].Free;
      m_BoardLines.Delete(0);
    end;
  end;
end;

// 显示提示信息
procedure TDrawScreen.DrawHint(MSurface: TAsphyreCanvas);
var
  AHintX, AHintY: Integer;
begin
  if m_HintMessage.HasData then
  begin
    AHintX := HintX;
    AHintY := HintY;
    m_HintMessage.Init(MSurface);
    case HintAlign of
      0: //靠左
      begin
      end;
      1: //靠右
      begin
        AHintX := AHintX - m_HintMessage.Width;
      end;
      2: //居中
      begin
        AHintX := AHintX - m_HintMessage.Width div 2;
      end;
    end;
    if AHintX < 0 then
      AHintX :=  0
    else if AHintX + m_HintMessage.Width > SCREENWIDTH then
      AHintX :=  SCREENWIDTH - m_HintMessage.Width;
    if AHintY < 0 then
      AHintY :=  0
    else if AHintY + m_HintMessage.Height > SCREENHEIGHT then
      AHintY :=  SCREENHEIGHT - m_HintMessage.Height;
    if not g_UIManager.Form.HintEditor.ShowHintBorder then
    begin
      MSurface.FillRectAlpha(Bounds(AHintX, AHintY, m_HintMessage.Width + 8, m_HintMessage.Height + 8), g_UIManager.Form.HintEditor.HintBgColor, g_UIManager.Form.HintEditor.HintAlpha);
      m_HintMessage.Draw(MSurface, AHintX + 4, AHintY + 4);
    end
    else
    begin
      MSurface.FillRectAlpha(Bounds(AHintX, AHintY, m_HintMessage.Width, m_HintMessage.Height), g_UIManager.Form.HintEditor.HintBgColor, g_UIManager.Form.HintEditor.HintAlpha);
      m_HintMessage.Draw(MSurface, AHintX, AHintY);
    end;
  end;
  FDrawItemManager.Draw(MSurface);
end;

procedure TDrawScreen.DrawMoveMessage(MSurface: TAsphyreCanvas);
begin
  DrawScreenCenterLetter(MSurface);
  DrawScreenCountDown(MSurface);
  DrawScreenBoard(MSurface);
end;

procedure TDrawScreen.ParseItemHint(AItemManager: TDrawItemManager; X, Y: Integer; AItem: TClientItem; AItemFrom: TItemFromKind; AGold, AGameGold, ACount: Integer);
var
  AItem1, AItem2: TClientItem;
begin
  AItemManager.Clear;
  AItemManager.Left :=  X;
  AItemManager.Top :=  Y;

  AItemManager.ADrawItemInfo := TDrawClientItemInfo.Create(AItem);
  AItemManager.ADrawItemInfo.FItemFrom := AItemFrom;
  AItemManager.ADrawItemInfo.FGold := AGold;
  AItemManager.ADrawItemInfo.FGameGold := AGameGold;
  AItemManager.ADrawItemInfo.FCount := ACount;
  if (AItemFrom <> fkUse) and ClientConf.boItemCompare then
  begin
    AItem1.Name :=  '';
    AItem2.Name :=  '';
    case AItem.S.StdMode of
      5,6:    AItem1  :=  g_UseItems[U_WEAPON];
      7:      AItem1  :=  g_UseItems[U_CHARM];
      10,11:  AItem1  :=  g_UseItems[U_DRESS];
      15:     AItem1  :=  g_UseItems[U_HELMET];
      16:     AItem1  :=  g_UseItems[U_ZHULI];
      17,18:  AItem1  :=  g_UseItems[U_FASHION];
      19..21: AItem1  :=  g_UseItems[U_NECKLACE];
      22,23:
      begin
        AItem1  :=  g_UseItems[U_RINGR];
        AItem2  :=  g_UseItems[U_RINGL];
      end;
      24,26:
      begin
        AItem1  :=  g_UseItems[U_ARMRINGR];
        AItem2  :=  g_UseItems[U_ARMRINGL];
      end;
      25:     AItem1  :=  g_UseItems[U_BUJUK];
      27:     AItem1  :=  g_UseItems[U_BELT];
      28:     AItem1  :=  g_UseItems[U_BOOTS];
      30:     AItem1  :=  g_UseItems[U_RIGHTHAND];
      35:     AItem1  :=  g_UseItems[U_MOUNT];
      8:      AItem1  :=  g_UseItems[U_SHIED];
    end;

    if AItem1.Name <> '' then
    begin
      AItemManager.ADrawItemInfo1 :=  TDrawClientItemInfo.Create(AItem1);
      AItemManager.ADrawItemInfo1.FItemFrom := fkUse;
    end;

    if (AItem2.Name <> '')  then
    begin
      if AItem1.Name <> '' then
      begin
        AItemManager.ADrawItemInfo2 := TDrawClientItemInfo.Create(AItem2);
        AItemManager.ADrawItemInfo2.FItemFrom  :=  fkUse;
      end
      else
      begin
        AItemManager.ADrawItemInfo1  := TDrawClientItemInfo.Create(AItem2);
        AItemManager.ADrawItemInfo1.FItemFrom  :=  fkUse;
      end;
    end;
  end;
end;

procedure TDrawScreen.DoClickItemHintInited(Sender: TObject);
begin
  if Assigned(FOnClickHintInited) then
    FOnClickHintInited(Sender);
end;

procedure TDrawScreen.ShowClickItemHint(AItem: TClientItem; AItemFrom: TItemFromKind);
begin
  ParseItemHint(FClickItemHint, 0, 0, AItem, AItemFrom, 0, 0, 0);
end;

procedure TDrawScreen.ShowItemHint(X, Y: Integer; AItem: TClientItem; AItemFrom: TItemFromKind; AGold, AGameGold, ACount: Integer);
begin
  ParseItemHint(FDrawItemManager, X, Y, AItem, AItemFrom, AGold, AGameGold, ACount);
end;

procedure TDrawScreen.ShowShopItemHint(X, Y: Integer; AItem: TShopItem; const ISGift: Boolean = False);
var
  AItem1, AItem2: TClientItem;
begin
  FDrawItemManager.Clear;
  FDrawItemManager.Left :=  X;
  FDrawItemManager.Top :=  Y;

  FDrawItemManager.ADrawItemInfo := TDrawShopItemInfo.Create(AItem);
  FDrawItemManager.ADrawItemInfo.FItemFrom := fkMall;
  if ISGift then
    FDrawItemManager.ADrawItemInfo.FGamePoint := AItem.nPrice
  else
    FDrawItemManager.ADrawItemInfo.FGameGold := AItem.nPrice;

  if ClientConf.boItemCompare then
  begin
    AItem1.Name :=  '';
    AItem2.Name :=  '';
    case AItem.StdItem.StdMode of
      5,6:    AItem1  :=  g_UseItems[U_WEAPON];
      10,11:  AItem1  :=  g_UseItems[U_DRESS];
      15:     AItem1  :=  g_UseItems[U_HELMET];
      16:     AItem1  :=  g_UseItems[U_ZHULI];
      17,18:  AItem1  :=  g_UseItems[U_FASHION];
      19..21: AItem1  :=  g_UseItems[U_NECKLACE];
      22,23:
      begin
        AItem1  :=  g_UseItems[U_RINGR];
        AItem2  :=  g_UseItems[U_RINGL];
      end;
      24,26:
      begin
        AItem1  :=  g_UseItems[U_ARMRINGR];
        AItem2  :=  g_UseItems[U_ARMRINGL];
      end;
      27:     AItem1  :=  g_UseItems[U_BELT];
      28:     AItem1  :=  g_UseItems[U_BOOTS];
      35:     AItem1  :=  g_UseItems[U_MOUNT];
      8:      AItem1  :=  g_UseItems[U_SHIED];
    end;
    if AItem1.Name <> '' then
    begin
      FDrawItemManager.ADrawItemInfo1       :=  TDrawClientItemInfo.Create(AItem1);
      FDrawItemManager.ADrawItemInfo1.FItemFrom  :=  fkUse;
    end;

    if (AItem2.Name <> '')  then
    begin
      if AItem1.Name <> '' then
      begin
        FDrawItemManager.ADrawItemInfo2     :=  TDrawClientItemInfo.Create(AItem2);
        FDrawItemManager.ADrawItemInfo2.FItemFrom  :=  fkUse;
      end
      else
      begin
        FDrawItemManager.ADrawItemInfo1         :=  TDrawClientItemInfo.Create(AItem2);
        FDrawItemManager.ADrawItemInfo1.FItemFrom  :=  fkUse;
      end;
    end;
  end;
end;

procedure TDrawScreen.ShowItemHint(P: TPoint; AItem: TClientItem; AItemFrom: TItemFromKind; AGold, AGameGold, ACount: Integer);
begin
  ShowItemHint(P.X, P.Y, AItem, AItemFrom, AGold, AGameGold, ACount);
end;

procedure TDrawScreen.ShowShopItemHint(P: TPoint; AItem: TShopItem;
  const ISGift: Boolean = False; const OffsetX: Integer = 0;
  const OffsetY: Integer = 20);
begin
  ShowShopItemHint(P.X+OffsetX, P.Y+OffsetY, AItem, ISGift);
end;

procedure TDrawScreen.UpdateItemHintPostion(P: TPoint;
  const OffsetX: Integer = 0; const OffsetY: Integer = 20);
begin
  FDrawItemManager.ChangeXY(P.X + OffsetX, P.Y + OffsetY);
end;

procedure TDrawScreen.DrawScreenCountDown(MSurface: TAsphyreCanvas);
var
  I, X, Y: Integer;
  ALine: TuSimpleMessage;
begin
  if CurrentScene <> PlayScene then Exit;
  if m_CountDownLines.Count = 0 then Exit;

  MessageLock;
  try
    if m_CountDownLines.Count > 0 then
    begin
//      if not g_NewUI then
//        Y :=  SCREENHEIGHT - 218
//      else
//        Y :=  SCREENHEIGHT - 110;

      Y := FrmDlg.DTCountDownHint.Top;
      for I := m_CountDownLines.Count - 1 downto 0 do
      begin
        ALine :=  m_CountDownLines.Items[I];
        if ALine.TimeEnd <= GetTickCount then
        begin
          FreeAndNilEx(ALine);
          m_CountDownLines.Delete(I);
        end
        else
        begin
          ALine.ChangeTick(GetTickCount, ALine.TimeEnd);
          ALine.Init(MSurface);
          X :=  ((SCREENWIDTH - ALine.Width) div 2) + FrmDlg.DTCountDownHint.Left ;
          ALine.Draw(MSurface, X, Y);
          Y :=  Y - ALine.Height - 2;
        end;
      end;
    end;
  finally
    MessageUnLock;
  end;
end;

procedure TDrawScreen.AddCountDown(const Message: string; Flag: Integer; ChangeMapDelete: Boolean);
var
  I, ATime: Integer;
  AMessage: TuSimpleMessage;
  ANewMessage: String;
  AHandled: Boolean;
begin
  MessageLock;
  try
    if m_CountDownLines.Count > 5 then
    begin
      for I := 0 to m_CountDownLines.Count - 1 do
      begin
        if not m_CountDownLines.Items[I].Fixed then
        begin
          m_CountDownLines.Items[I].Free;
          m_CountDownLines.Delete(I);
          Break
        end;
      end;
    end;

    ANewMessage := Message;
    ATime := 2;
    AHandled := False;
    with TRegEx.Match(Message, '\<\$TIME\:(\d+)\$\>', [roIgnoreCase]) do
      if Success then
      begin
        ATime := StrToIntDef(Groups[1].Value, 2);
        ANewMessage := TRegEx.Replace(Message, '\<\$TIME\:(\d+)\$\>', '<$TIME$>', [roIgnoreCase]);
        AHandled := True;
      end;
    if not AHandled then
    begin
      with TRegEx.Match(Message, '\<\$HTIME\:(\d+)\$\>', [roIgnoreCase]) do
        if Success then
        begin
          ATime := StrToIntDef(Groups[1].Value, 2);
          ANewMessage := TRegEx.Replace(Message, '\<\$HTIME\:(\d+)\$\>', '', [roIgnoreCase]);
          AHandled := True;
        end;
    end;

    AMessage := TuSimpleMessage.Create;
    AMessage.Tag := Flag;
    AMessage.ChangeMapDelete := ChangeMapDelete;
    AMessage.DefFontColor  :=  clYellow;
    AMessage.Bold :=  True;
    AMessage.TimeEnd := GetTickCount + ATime * 1000;
    AMessage.Parse(ANewMessage);
    m_CountDownLines.Add(AMessage);
  finally
    MessageUnLock;
  end;
end;

procedure TDrawScreen.DeleteCountDown(Flag: Integer);
var
  I: Integer;
begin
  MessageLock;
  try
    for I := m_CountDownLines.Count - 1 downto 0 do
    begin
      if m_CountDownLines[I].Tag = Flag then
      begin
        m_CountDownLines[I].Free;
        m_CountDownLines.Delete(I);
      end;
    end;
  finally
    MessageUnLock;
  end;
end;

procedure TDrawScreen.ChangeMapDeleteCountDown;
var
  I: Integer;
begin
  MessageLock;
  try
    for I := m_CountDownLines.Count - 1 downto 0 do
    begin
      if m_CountDownLines[I].ChangeMapDelete then
      begin
        m_CountDownLines[I].Free;
        m_CountDownLines.Delete(I);
      end;
    end;
  finally
    MessageUnLock;
  end;
end;

{ TDrawClientItemInfo }

constructor TDrawClientItemInfo.Create(AItem: TClientItem);
var
  ABindValue: Integer;
begin
  inherited Create;
  FItemIndex  :=  AItem.Index;
  FStdItem := AItem.S;
  FLooks := AItem.Looks;
  FItemWay := AItem.btOutWay;
  GetItemAddValue(AItem.AddLValue, AItem.AddValue, AItem.AddProperty, FStdItem, g_boEnableItemBasePower);
  case FItemIndex of
    -8..-2:FDura  :=  AItem.AddHold[0];
    else
      FDura := AItem.Dura;
  end;
  FNeed := FStdItem.Need;
  FNeedLevel := FStdItem.NeedLevel;
  if (AItem.Need > 0) or (AItem.NeedLevel > 0) then
  begin
    FNeed := AItem.Need;
    FNeedLevel := AItem.NeedLevel;
  end;
  FDuraMax := AItem.DuraMax;
  FSoulExp := AItem.SoulExp;
  FSoulMaxExp := AItem.SoulMaxExp;
  if ClientConf.boMixedAbility then
    FTotalAbility := AItem.TotalAbility
  else
    FTotalAbility := -1;
  Move(AItem.AddLValue[0], FAddLValue[0], SizeOf(TAddValue));
  Move(AItem.AddValue[0], FAddValue[0], SizeOf(TAddValue));
  Move(AItem.AddProperty, FAddProperty, SizeOf(TAddProperty));
  Move(AItem.AddPoint[0], FAddPoint[0], SizeOf(TAddPoint));
  Move(AItem.AddLevel[0], FAddLevel[0], SizeOf(TAddLevel));
  Move(AItem.AddHold[0], FAddHold[0], SizeOf(TAddHold));


  FBindState  :=  0;
  ABindValue := AItem.State.Flag;
  if ABindValue > 0 then
  begin
    if SetContain(ABindValue, ITEM_STATE_Bind) then
      AddSetValue(FBindState, _ITEM_STATE_BIND);
    if SetContain(ABindValue, ITEM_STATE_NERVERDROP) then
      AddSetValue(FBindState, _ITEM_STATE_NEVERDROP);
    if SetContain(ABindValue, ITEM_STATE_NOREPAIR) then
      AddSetValue(FBindState, _ITEM_STATE_NOREPAIR);
    if SetContain(ABindValue, ITEM_STATE_NOSTORE) then
      AddSetValue(FBindState, _ITEM_STATE_NOTSTORE);
    if SetContain(ABindValue, ITEM_STATE_OFFLINEFREE) then
      AddSetValue(FBindState, _ITEM_STATE_OFFLINEFREE);
    if SetContain(ABindValue, ITEM_STATE_NODROP) then
      AddSetValue(FBindState, _ITEM_STATE_NOTDROP);
    if SetContain(ABindValue, ITEM_STATE_DeathFree) then
      AddSetValue(FBindState, _ITEM_STATE_DIEFREE);
    if SetContain(ABindValue, ITEM_STATE_NOTAKEOFF) then
      AddSetValue(FBindState, _ITEM_STATE_NOTTAKEOFF);
    if SetContain(ABindValue, ITEM_STATE_AutoBindAfterTakeOn) then
      AddSetValue(FBindState, _ITEM_STATE_TAKEONBIND);
  end;

  if FStdItem.StdMode = 32 then
  begin
    FName := FStdItem.Name;
    FPropLine := AItem.Name;
  end
  else
    FName := AItem.DisplayName;
  FMaxDate  :=  0;
  if Round(AItem.Limit)> 0 then
    FMaxDate := AItem.Limit;

  ItemWidth := 0;
  ItemHeight := 0;

  FCaption1 := AItem.Caption1;
  FCaption2 := AItem.Caption2;
  FCaption3 := AItem.Caption3;

  FText1 := AItem.Text1;
  FText2 := AItem.Text2;
  FText3 := AItem.Text3;
  FFromDateTime := AItem.FromDateTime;
  FDesc := AItem.Desc;
end;

{ TDrawItemInfo }

constructor TDrawItemInfo.Create;
begin
  FGroups := TList.Create;
  FBGColor:=  FontBorderColor;
  ItemWidth := 0;
  ItemHeight := 0;
  MaxLineWidth  :=  0;
  FSpaceW := 16;
  FBindState :=  0;
  FItemFrom  :=  fkNormal;
  FName :=  '';
  FillChar(FAddValue, SizeOf(TAddValue), #0);
  FillChar(FAddLValue, SizeOf(TAddValue), #0);
  FillChar(FAddPoint, SizeOf(TAddPoint), #0);
  FillChar(FAddProperty, SizeOf(TAddProperty), #0);
  FStartDrawGroup :=  nil;
end;

destructor TDrawItemInfo.Destroy;
var
  i: Integer;
begin
  for i := 0 to FGroups.Count - 1 do
    TObject(FGroups.Items[i]).Free;
  FreeAndNilEx(FGroups);
  inherited;
end;

procedure TDrawItemInfo.DrawBackGround(MSurface: TAsphyreCanvas; ALeft: Integer);
var
  d: TAsphyreLockableTexture;
  Width, Height: Integer;
begin
  Width := ItemWidth + 16;
  Height := ItemHeight + 16;

  d := g_77Images.Images[44];
  if (d = nil) or (d.Width * d.Height < 10) then
  begin
    Exit;
  end
  else
  begin
    d := g_77Images.Images[44];
    if d <> nil then
      MSurface.Draw(ALeft, 0, d, False);

    d := g_77Images.Images[46];
    if d <> nil then
      MSurface.Draw(ALeft + Width - d.Width, 0, d, False);

    d := g_77Images.Images[49];
    if d <> nil then
      MSurface.Draw(ALeft, Height - d.Height, d, False);

    d := g_77Images.Images[51];
    if d <> nil then
      MSurface.Draw(ALeft + Width - d.Width, Height - d.Height, d, False);

    d := g_77Images.Images[45];
    if d <> nil then
      MSurface.HorFillDraw(ALeft + 8, ALeft + 8 + ItemWidth, 0, d);

    d := g_77Images.Images[50];
    if d <> nil then
      MSurface.HorFillDraw(ALeft + 8, ALeft + 8 + ItemWidth, Height - d.Height, d);

    d := g_77Images.Images[47];
    if d <> nil then
      MSurface.VerFillDraw(ALeft, 8, 8 + ItemHeight, d);

    d := g_77Images.Images[48];
    if d <> nil then
      MSurface.VerFillDraw(ALeft + Width - d.Width, 8, 8 + ItemHeight, d);
  end;
end;

function TDrawItemInfo.GetDura100Str(Dura, maxdura: Integer): string;
begin
  Result := IntToStr(Round(Dura / 100)) + '/' + IntToStr(Round(maxdura / 100))
end;

function TDrawItemInfo.GetDuraStr(Dura, maxdura: Integer): string;
begin
  Result := IntToStr(Round(Dura / 1000)) + '/' + IntToStr(Round(maxdura / 1000))
end;

function TDrawItemInfo.GetItemTypeName: String;
const
  NORMAL_ITEM = '物品';
begin
  g_ItemTypeNames.TryGetValue(FStdItem.TypeID, Result);
  if Result = '' then
  begin
    case FStdItem.StdMode of
      0:
      begin
        case FStdItem.Shape of
          0:
          begin
            if FStdItem.ACMin > 0 then
              Result  :=  '药品(持续恢复HP)'
            else if FStdItem.MACMin > 0 then
              Result  :=  '药品(持续恢复MP)'
            else
              Result  :=  '药品';
          end;
          1:  Result  :=  '药品(快速恢复HP及MP)';
          else
            Result  :=  '药品';
        end;
      end;
      3:
      begin
        case FStdItem.Shape of
          1,2,3,5:  Result  :=  '传送卷轴';
          4:  Result  :=  '武器幸运强化';
          9,10: Result  :=  '武器修复';
          11: Result  :=  '彩票';
          12: Result  :=  '特殊药水';
          13:
          begin
            case FStdItem.AniCount of
              1:  Result  :=  '经验卷轴';
              2:  Result  :=  '金币卷轴';
            end;
          end;
        end;
      end;
      7:
      begin
        case FStdItem.Shape of
          0..3: Result  :=  '药品';
          else  Result  :=  '宝石';
        end;
      end;
      8: Result := '盾牌(副手)';
      4:          Result  :=  '秘籍';
      5: Result := '武器';
      6: Result := '双手武器';
      10, 11:     Result  :=  '铠甲';
      15:         Result  :=  '头盔';
      16:         Result  :=  '斗笠';
      17,18:      Result  :=  '时装';
      19, 20, 21: Result  :=  '项链';
      22, 23:     Result  :=  '戒指';
      24, 26:     Result  :=  '手镯';
      25:
      begin
        case FStdItem.Shape of
          1:  Result  :=  '毒(持续减少体力值)';
          2:  Result  :=  '毒(降低防御)';
          3,5,6:  Result  :=  '符';
        end;
      end;
      27:         Result  :=  '腰带';
      28:         Result  :=  '靴子';
      29:         Result  :=  '宝石';
      30:         Result  :=  '勋章';
      31,71:         Result  :=  '功能物品';
      32:         Result  :=  '坐标记录';
      35:         Result  :=  '马牌';
      43:         Result  :=  '矿石';
      40:         Result  :=  '肉制品';
      68:         Result  :=  '生肖勋章';
    end;
  end;
end;

function TDrawItemInfo.GetItemWayName: string;
begin
  Result := '';
  g_ItemWay.TryGetValue(FItemWay,Result);
  if Result = '' then
  begin
    Result := '未知途径';
  end;
end;

function TDrawItemInfo.GetPrice: Integer;
begin
  Result  :=  0;
  Result := FStdItem.Price;
  if Result > 0 then
    Result := GetStandardItemPrice(ClientConf.boPriceDura, ClientConf.boPriceAddValue, ClientConf.boPriceLimit, Result, FStdItem, FDura, FDuraMax, FAddValue, FAddPoint, FAddLevel, FAddHold, FMaxDate);
  Result := Round(ClientConf.btPriceSaleDiscount / 100 * Result);
end;

procedure TDrawItemInfo.CalcBounds(MSurface: TAsphyreCanvas);
var
  I, Y: Integer;
begin
  for I := 0 to FGroups.Count - 1 do
  begin
    if not (TItemDrawGroup(FGroups.Items[i]) is TItemDescDrawGroup) then
    begin
      TItemDrawGroup(FGroups.Items[i]).Calc(MSurface);
      if ItemWidth < TItemDrawGroup(FGroups.Items[i]).Width then
        ItemWidth := TItemDrawGroup(FGroups.Items[i]).Width;
      Inc(ItemHeight, TItemDrawGroup(FGroups.Items[i]).Height);
      if g_UIManager.Form.HintEditor.ShowGroupSpace and (I < FGroups.Count) and TItemDrawGroup(FGroups.Items[i]).Spacing then
        Inc(ItemHeight, SPACINGHEIGHT);
    end;
  end;

  for I := 0 to FGroups.Count - 1 do
  begin
    if TItemDrawGroup(FGroups.Items[i]) is TItemDescDrawGroup then
    begin
      TItemDrawGroup(FGroups.Items[i]).Calc(MSurface);
      if ItemWidth < TItemDrawGroup(FGroups.Items[i]).Width then
        ItemWidth := TItemDrawGroup(FGroups.Items[i]).Width;
      Inc(ItemHeight, TItemDrawGroup(FGroups.Items[i]).Height);
      if g_UIManager.Form.HintEditor.ShowGroupSpace and (I < FGroups.Count) and TItemDrawGroup(FGroups.Items[i]).Spacing then
        Inc(ItemHeight, SPACINGHEIGHT);
    end;
  end;


  ItemWidth := Max(ItemWidth, 100);
  if (FItemFrom = fkUse) and (ItemWidth < 120) then
    ItemWidth := 120;


    //给分割线计算宽度
  for I := 0 to FGroups.Count - 1 do
  begin
    if TItemDrawGroup(FGroups.Items[i]) is TItemInfoDrawGroup then
    begin
      TItemInfoDrawGroup(FGroups.Items[i]).SetSplitlLineWidth(ItemWidth);
    end;
  end;
end;

procedure TDrawItemInfo.Init(MSurface: TAsphyreCanvas);
const
  _TxtColor: array [Boolean] of TColor = (clRed, clLime);


  procedure AddItemCaptionAndText(G: TItemInfoDrawGroup);
  begin
    if g_UIManager.Form.HintEditor.ItemFrom.Visible then
    begin
      if (FCaption1 <> '') or (FCaption2 <> '') or (FCaption3 <> '') or (FFromDateTime > 0) then
      begin
        G.AddSplitlLine(10);
        G.AddSampleLine(g_UIManager.Form.HintEditor.ItemFrom.Caption,g_UIManager.Form.HintEditor.ItemFrom.Color);

        if FCaption1 <> '' then
          G.AddLine(FCaption1, FText1, clYellow);

        if FCaption2 <> '' then
          G.AddLine(FCaption2, FText2, clYellow);

        if FCaption3 <> '' then
          G.AddLine(FCaption3, FText3, clYellow);

        if FFromDateTime <> 0 then
          G.AddLine('产出时间', DateTimeToStr(FFromDateTime), clYellow);
      end;
    end;

  end;

  procedure AddTypeName(G: TItemInfoDrawGroup);
  var
    iType: String;
  begin
    iType := GetItemTypeName();
    if iType <> '' then
      G.AddLine('类型', iType, GetRGB(94));
  end;

  procedure AddItemWay(G: TItemInfoDrawGroup);
  var
    iType: String;
    MessageParse : TuMerchantMessage;
    Line : TMessageLine;
    Node : TMessageNode;
    i:Integer;
  begin

    iType := GetItemWayName();
    //iType := '{S=测试第一节点;C=253}\这个我就不知道了';
    if iType <> '' then
    begin
      MessageParse := TuMerchantMessage.Create;
      MessageParse.Parse(iType);
      for i := 0 to MessageParse.LineCount - 1 do
      begin
        Line := MessageParse.Lines[i];
        Node := Line.FirstNode;
        if Node <> nil then
        begin
          G.AddLine(Node.Data, '', Node.FontColor);
        end;
      end;
    end;
  end;

  procedure AddSexuality(G: TItemInfoDrawGroup; Male: Boolean);
  var
    sSex: String;
    bCamUse: Boolean;
  begin
    if Male then
    begin
      sSex    :=  '男';
      bCamUse :=  (g_MySelf.m_btSex=0) and Male;
    end
    else
    begin
      sSex  :=  '女';
      bCamUse :=  (g_MySelf.m_btSex=1) and not Male;
    end;
    with G.AddLine('性别', sSex) do
    begin
      clCaption := _TxtColor[bCamUse];
      clValue   := _TxtColor[bCamUse];
    end
  end;

  procedure GetJobNameAndState(AJob: Byte; var JobName: String; var CanUse: Boolean);
  begin
    JobName := GetJobName(AJob);
    case AJob of
      _JOB_WAR: CanUse := g_MySelf.m_btJob = _JOB_WAR;
      _JOB_MAG: CanUse := g_MySelf.m_btJob = _JOB_MAG;
      _JOB_DAO: CanUse := g_MySelf.m_btJob = _JOB_DAO;
      _JOB_CIK: CanUse := g_MySelf.m_btJob = _JOB_CIK;
      _JOB_ARCHER: CanUse := g_MySelf.m_btJob = _JOB_ARCHER;
      _JOB_SHAMAN: CanUse := g_MySelf.m_btJob = _JOB_SHAMAN;
      98:
      begin
        if [cjCIK, cjARCHER, cjSHAMAN] * g_ServerJobs <> [] then
          JobName := '战法道通用';
        CanUse := g_MySelf.m_btJob in [0,1,2];
      end;
      99:
      begin
        CanUse := True;
        JobName := '';
      end;
    end;
  end;

  procedure AddJob(G: TItemInfoDrawGroup);
  var
    sJob: String;
    bCamUse: Boolean;
  begin
    GetJobNameAndState(FStdItem.Job, sJob, bCamUse);
    if sJob <> '' then
    begin
      with G.AddLine('职业', sJob) do
      begin
        clCaption := _TxtColor[bCamUse];
        clValue := _TxtColor[bCamUse];
      end
    end;
  end;

  procedure AddNeedLevel(G: TItemInfoDrawGroup);
  begin
    case FNeed of
      0:
      begin
        if FNeedLevel > 0 then
        begin
          with G.AddLine('等级', IntToStr(FNeedLevel)) do
          begin
            clCaption := _TxtColor
              [g_MySelf.m_Abil.Level >= FNeedLevel];
            clValue := _TxtColor[g_MySelf.m_Abil.Level >= FNeedLevel];
          end;
        end;
      end;
      1:
      begin
        if FNeedLevel > 0 then
          with G.AddLine('需要攻击', IntToStr(FNeedLevel)) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.DCMax >=FNeedLevel];
            clValue := _TxtColor[g_MySelf.m_Abil.DCMax >=FNeedLevel];
          end;
      end;
      2:
      begin
        if FNeedLevel > 0 then
          with G.AddLine('需要魔法', IntToStr(FNeedLevel)) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.MCMax >=FNeedLevel];
            clValue := _TxtColor[g_MySelf.m_Abil.MCMax >=FNeedLevel];
          end;
      end;
      3:
      begin
        if FNeedLevel > 0 then
          with G.AddLine('需要道术', IntToStr(FNeedLevel)) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.SCMax >=FNeedLevel];
            clValue := _TxtColor[g_MySelf.m_Abil.SCMax >=FNeedLevel];
          end;
      end;
      90:
      begin
        if FNeedLevel > 0 then
          with G.AddLine('需要刺术', IntToStr(FNeedLevel)) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.PcMax >=FNeedLevel];
            clValue := _TxtColor[g_MySelf.m_Abil.PcMax >=FNeedLevel];
          end;
      end;
      91:
      begin
        if FNeedLevel > 0 then
          with G.AddLine('需要射术', IntToStr(FNeedLevel)) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.TCMax >=FNeedLevel];
            clValue := _TxtColor[g_MySelf.m_Abil.TCMax >=FNeedLevel];
          end;
      end;
      92:
      begin
        if FNeedLevel > 0 then
          with G.AddLine('需要武术', IntToStr(FNeedLevel)) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.WCMax >=FNeedLevel];
            clValue := _TxtColor[g_MySelf.m_Abil.WCMax >=FNeedLevel];
          end;
      end;
      4:
      begin
        if FNeedLevel > 0 then
          with G.AddLine('需要转生', IntToStr(FNeedLevel) + '级') do
          begin
            clCaption := _TxtColor[g_MySelf.m_btReLevel >= FNeedLevel];
            clValue := _TxtColor[g_MySelf.m_btReLevel >= FNeedLevel];
          end;
      end;
      10:
      begin
        with G.AddLine('职业', GetJobName(LoWord(FNeedLevel))) do
        begin
          clCaption := _TxtColor[g_MySelf.m_btJob = LoWord(FNeedLevel)];
          clValue := _TxtColor[g_MySelf.m_btJob = LoWord(FNeedLevel)];
        end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('需要等级', IntToStr(Hiword(FNeedLevel)) + '级') do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.Level >=Hiword(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_Abil.Level >=Hiword(FNeedLevel)];
          end;
      end;
      11:
      begin
        with G.AddLine('职业', GetJobName(LoWord(FNeedLevel))) do
        begin
          clCaption := _TxtColor[g_MySelf.m_btJob = LoWord(FNeedLevel)];
          clValue := _TxtColor[g_MySelf.m_btJob = LoWord(FNeedLevel)];
        end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('需要攻击', IntToStr(Hiword(FNeedLevel)) + '点') do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.DCMax >=Hiword(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_Abil.DCMax >=Hiword(FNeedLevel)];
          end;
      end;
      12:
      begin
        with G.AddLine('职业', GetJobName(LoWord(FNeedLevel))) do
        begin
          clCaption := _TxtColor[g_MySelf.m_btJob = LoWord(FNeedLevel)];
          clValue := _TxtColor[g_MySelf.m_btJob = LoWord(FNeedLevel)];
        end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('需要魔法', IntToStr(Hiword(FNeedLevel)) + '点') do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.MCMax >=Hiword(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_Abil.MCMax >=Hiword(FNeedLevel)];
          end;
      end;
      13:
      begin
        with G.AddLine('职业', GetJobName(LoWord(FNeedLevel))) do
        begin
          clCaption := _TxtColor[g_MySelf.m_btJob = LoWord(FNeedLevel)];
          clValue := _TxtColor[g_MySelf.m_btJob = LoWord(FNeedLevel)];
        end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('需要道术', IntToStr(Hiword(FNeedLevel)) + '点') do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.SCMax >=Hiword(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_Abil.SCMax >=Hiword(FNeedLevel)];
          end;
      end;
      14:
      begin
        with G.AddLine('职业', GetJobName(LoWord(FNeedLevel))) do
        begin
          clCaption := _TxtColor[g_MySelf.m_btJob = LoWord(FNeedLevel)];
          clValue := _TxtColor[g_MySelf.m_btJob = LoWord(FNeedLevel)];
        end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('需要刺术', IntToStr(Hiword(FNeedLevel)) + '点') do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.PCMax >=Hiword(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_Abil.PCMax >=Hiword(FNeedLevel)];
          end;
      end;
      15:
      begin
        with G.AddLine('职业', GetJobName(LoWord(FNeedLevel))) do
        begin
          clCaption := _TxtColor[g_MySelf.m_btJob = LoWord(FNeedLevel)];
          clValue := _TxtColor[g_MySelf.m_btJob = LoWord(FNeedLevel)];
        end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('需要射术', IntToStr(Hiword(FNeedLevel)) + '点') do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.TCMax >=Hiword(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_Abil.TCMax >=Hiword(FNeedLevel)];
          end;
      end;
      16:
      begin
        with G.AddLine('职业', GetJobName(LoWord(FNeedLevel))) do
        begin
          clCaption := _TxtColor[g_MySelf.m_btJob = LoWord(FNeedLevel)];
          clValue := _TxtColor[g_MySelf.m_btJob = LoWord(FNeedLevel)];
        end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('需要武术', IntToStr(Hiword(FNeedLevel)) + '点') do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.WCMax >=Hiword(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_Abil.WCMax >=Hiword(FNeedLevel)];
          end;
      end;
      40:
      begin
        if LoWord(FNeedLevel) > 0 then
          with G.AddLine('需要转生', IntToStr(LoWord(FNeedLevel)) + '级') do
          begin
            clCaption := _TxtColor[g_MySelf.m_btReLevel >= LoWord(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_btReLevel >=LoWord(FNeedLevel)];
          end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('需要等级', IntToStr(Hiword(FNeedLevel)) + '级') do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.Level >=Hiword(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_Abil.Level >=Hiword(FNeedLevel)];
          end;
      end;
      41:
      begin
        if LoWord(FNeedLevel) > 0 then
          with G.AddLine('需要转生', IntToStr(LoWord(FNeedLevel)) + '级') do
          begin
            clCaption := _TxtColor[g_MySelf.m_btReLevel >= LoWord(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_btReLevel >=LoWord(FNeedLevel)];
          end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('需要攻击', IntToStr(Hiword(FNeedLevel))) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.DCMax >= Hiword(FNeedLevel)];
            clValue   := _TxtColor[g_MySelf.m_Abil.DCMax >= Hiword(FNeedLevel)];
          end;
      end;
      42:
      begin
        if LoWord(FNeedLevel) > 0 then
          with G.AddLine('需要转生', IntToStr(LoWord(FNeedLevel)) + '级') do
          begin
            clCaption := _TxtColor[g_MySelf.m_btReLevel >= LoWord(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_btReLevel >=LoWord(FNeedLevel)];
          end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('需要魔法', IntToStr(Hiword(FNeedLevel))) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.MCMax >= Hiword(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_Abil.MCMax >= Hiword(FNeedLevel)];
          end;
      end;
      43:
      begin
        if LoWord(FNeedLevel) > 0 then
          with G.AddLine('需要转生', IntToStr(LoWord(FNeedLevel)) + '级') do
          begin
            clCaption := _TxtColor[g_MySelf.m_btReLevel >= LoWord(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_btReLevel >= LoWord(FNeedLevel)];
          end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('需要道术', IntToStr(Hiword(FNeedLevel))) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.SCMax >= Hiword(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_Abil.SCMax >= Hiword(FNeedLevel)];
          end;
      end;
      44:
      begin
        if LoWord(FNeedLevel) > 0 then
          with G.AddLine('需要转生', IntToStr(LoWord(FNeedLevel)) + '级') do
          begin
            clCaption := _TxtColor[g_MySelf.m_btReLevel >= LoWord(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_btReLevel >=LoWord(FNeedLevel)];
          end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('需要声望', IntToStr(Hiword(FNeedLevel)) + '点') do
          begin
            clCaption := _TxtColor[g_MySubAbility.CreditPoint >= Hiword(FNeedLevel)];
            clValue := _TxtColor[g_MySubAbility.CreditPoint >= Hiword(FNeedLevel)];
          end;
      end;
      45:
      begin
        if LoWord(FNeedLevel) > 0 then
          with G.AddLine('需要转生', IntToStr(LoWord(FNeedLevel)) + '级') do
          begin
            clCaption := _TxtColor[g_MySelf.m_btReLevel >= LoWord(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_btReLevel >= LoWord(FNeedLevel)];
          end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('需要刺术', IntToStr(Hiword(FNeedLevel))) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.PCMax >= Hiword(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_Abil.PCMax >= Hiword(FNeedLevel)];
          end;
      end;
      46:
      begin
        if LoWord(FNeedLevel) > 0 then
          with G.AddLine('需要转生', IntToStr(LoWord(FNeedLevel)) + '级') do
          begin
            clCaption := _TxtColor[g_MySelf.m_btReLevel >= LoWord(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_btReLevel >= LoWord(FNeedLevel)];
          end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('需要射术', IntToStr(Hiword(FNeedLevel))) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.TCMax >= Hiword(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_Abil.TCMax >= Hiword(FNeedLevel)];
          end;
      end;
      47:
      begin
        if LoWord(FNeedLevel) > 0 then
          with G.AddLine('需要转生', IntToStr(LoWord(FNeedLevel)) + '级') do
          begin
            clCaption := _TxtColor[g_MySelf.m_btReLevel >= LoWord(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_btReLevel >= LoWord(FNeedLevel)];
          end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('需要武术', IntToStr(Hiword(FNeedLevel))) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.WCMax >= Hiword(FNeedLevel)];
            clValue := _TxtColor[g_MySelf.m_Abil.WCMax >= Hiword(FNeedLevel)];
          end;
      end;
      5:
      begin
        if FNeedLevel > 0 then
          with G.AddLine('需要声望', IntToStr(FNeedLevel) + '点') do
          begin
            clCaption := _TxtColor[g_MySubAbility.CreditPoint >= FNeedLevel];
            clValue := _TxtColor[g_MySubAbility.CreditPoint >= FNeedLevel];
          end;
      end;
      6:
      begin
        with G.AddLine('(行会成员专用)', '') do
        begin
          clCaption := clLime;
          clValue := clLime;
        end;
        if FNeedLevel > 0 then
          with G.AddLine('等级', IntToStr(FNeedLevel)) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.Level >= FNeedLevel];
            clValue := _TxtColor[g_MySelf.m_Abil.Level >= FNeedLevel];
          end;
      end;
      60:
      begin
        with G.AddLine('(行会掌门专用)', '') do
        begin
          clCaption := clLime;
          clValue := clLime;
        end;
        if FNeedLevel > 0 then
          with G.AddLine('等级', IntToStr(FNeedLevel)) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.Level >= FNeedLevel];
            clValue := _TxtColor[g_MySelf.m_Abil.Level >= FNeedLevel];
          end;
      end;
      7:
      begin
        with G.AddLine('(沙城成员专用)', '') do
        begin
          clCaption := clLime;
          clValue := clLime;
        end;
        if FNeedLevel > 0 then
          with G.AddLine('等级', IntToStr(FNeedLevel)) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.Level >= FNeedLevel];
            clValue := _TxtColor[g_MySelf.m_Abil.Level >= FNeedLevel];
          end;
      end;
      70:
      begin
        with G.AddLine('(沙城城主专用)', '') do
        begin
          clCaption := clLime;
          clValue := clLime;
        end;
        if FNeedLevel > 0 then
          with G.AddLine('等级', IntToStr(FNeedLevel)) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.Level >= FNeedLevel];
            clValue := _TxtColor[g_MySelf.m_Abil.Level >= FNeedLevel];
          end;
      end;
      8:
      begin
        with G.AddLine('(会员专用)', '') do
        begin
          clCaption := clLime;
          clValue := clLime;
        end;
        if FNeedLevel > 0 then
          with G.AddLine('等级', IntToStr(FNeedLevel)) do
          begin
            clCaption := _TxtColor[g_MySelf.m_Abil.Level >= FNeedLevel];
            clValue := _TxtColor[g_MySelf.m_Abil.Level >= FNeedLevel];
          end;
      end;
      81:
      begin
        if LoWord(FNeedLevel) > 0 then
          with G.AddLine('会员类型(等于)', IntToStr(LoWord(FNeedLevel)) + '级') do
          begin
            clCaption := clLime;
            clValue := clLime;
          end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('会员等级', IntToStr(Hiword(FNeedLevel)) + '级') do
          begin
            clCaption := clLime;
            clValue := clLime;
          end;
      end;
      82:
      begin
        if LoWord(FNeedLevel) > 0 then
          with G.AddLine('会员类型', IntToStr(LoWord(FNeedLevel)) + '级') do
          begin
            clCaption := clLime;
            clValue := clLime;
          end;
        if Hiword(FNeedLevel) > 0 then
          with G.AddLine('会员等级', IntToStr(Hiword(FNeedLevel)) + '级') do
          begin
            clCaption := clLime;
            clValue := clLime;
          end;
      end;
    end;
  end;

  procedure AddWeight(G: TItemInfoDrawGroup);
  begin
    if FStdItem.Weight > 0 then
    begin
      case FStdItem.StdMode of
        {$I AddinStdmode.INC}: G.AddLine('重量', IntToStr(FStdItem.Weight * Max(1, FDura)));
        else
                  G.AddLine('重量', IntToStr(FStdItem.Weight));
      end;
    end;
  end;

  procedure AddCount(G: TItemInfoDrawGroup);
  begin
    G.AddLine('数量', 'x' + IntToStr(FDura));
  end;

  procedure AddSpeed(G: TItemInfoDrawGroup);
  begin
    if FStdItem.MACMin <> 0 then
    begin
      if FStdItem.MACMin > 0 then
      begin
        with G.AddLine('攻击速度', '+' + IntToStr(FStdItem.MACMin)) do
        begin
          clCaption := clLime;
          clValue := clLime;
        end;
      end
      else
      begin
        with G.AddLine('攻击速度', '-' + IntToStr(ABS(FStdItem.MACMin))) do
        begin
          clCaption := clRed;
          clValue := clRed;
        end;
      end;
    end;
  end;

  procedure AddLuck(G: TItemInfoDrawGroup);
  begin
    if FStdItem.MACMax <> 0 then
    begin
      if FStdItem.MACMax > 0 then
      begin
        with G.AddLine('幸运', '+' + IntToStr(FStdItem.MACMax)) do
        begin
          clCaption := clLime;
          clValue := clLime;
        end;
      end
      else
      begin
        with G.AddLine('诅咒', '+' + IntToStr(ABS(FStdItem.MACMax))) do
        begin
          clCaption := clRed;
          clValue := clRed;
        end;
      end;
    end;
  end;

  procedure Add56Source(G: TItemInfoDrawGroup);
  begin
    if FStdItem.Source <> 0 then
    begin
      if FStdItem.Source in [1..9] then
      begin
        with G.AddLine('强度', '+' + IntToStr(FStdItem.Source)) do
        begin
          clCaption := clLime;
          clValue := clLime;
        end;
      end
      else if FStdItem.Source < 0 then
      begin
        case ABS(FStdItem.Source) of
          1..50:
          begin
            with G.AddLine('神圣', '+' + IntToStr(ABS(FStdItem.Source))) do
            begin
              clCaption := clLime;
              clValue := clLime;
            end;
          end;
          51..100:
          begin
            with G.AddLine('神圣', '-' + IntToStr(ABS(FStdItem.Source) - 50)) do
            begin
              clCaption := clRed;
              clValue := clRed;
            end;
          end;
        end;
      end;
    end;
  end;

  procedure AddStdMode0(G: TItemInfoDrawGroup);
  begin
    AddTypeName(G);
    AddNeedLevel(G);
    if FStdItem.ACMin > 0 then
      G.AddLine('体力恢复', IntToStr(FStdItem.ACMin) + '点', clLime);

    if FStdItem.MACMin > 0 then
      G.AddLine('魔力恢复', IntToStr(FStdItem.MACMin) + '点', clLime);
    if FDura > 1 then
      AddCount(G);
    AddWeight(G);
  end;

  procedure AddStdMode1(G: TItemInfoDrawGroup);
  begin
    AddTypeName(G);
    AddNeedLevel(G);
    case FStdItem.Shape of
      1, 2, 5, 6, 7:
        begin
          G.AddLine('持续使用', GetDuraStr(FDura, FDuraMax) + ' 小时', clLime);
        end;
      3, 4, 8, 9, 10:
        begin
          G.AddLine('累积使用', GetDuraStr(FDura, FDuraMax) + ' 小时', clLime);
        end;
    end;
    if FDura > 1 then
      AddCount(G);
    AddWeight(G);
  end;

  procedure AddStdMode2(G: TItemInfoDrawGroup);
  var
    SRate:String;
  begin
    AddTypeName(G);
    AddNeedLevel(G);
    AddWeight(G);
    case FStdItem.Shape of
      2:
      begin
        if FStdItem.AniCount = 15 then
        begin

        end;
      end;
    end;
    case FStdItem.Shape of
      3:begin
        SRate := Format('%0.1f倍',[FStdItem.ACMin /100]);
        G.AddLine('使用', GetDuraStr(FDura, FDuraMax) + ' 次', clLime);
        G.AddLine('经验倍率增加:' ,SRate,clYellow);
        G.AddLine('持续倍率时间:', GetStartTime(FStdItem.MACMin),clYellow);
      end;
      0..2,4..8:
      begin

        G.AddLine('使用', GetDuraStr(FDura, FDuraMax) + ' 次', clLime);
      end;
      9:
      begin
        G.AddLine('可修复持久', GetDura100Str(FDura, FDuraMax) + ' 点', clLime);
      end;
    end;
  end;

  procedure AddStdMode3(G: TItemInfoDrawGroup);
  var
    boFounded: Boolean;
  begin
    AddTypeName(G);
    AddNeedLevel(G);
    if FDura > 1 then
      AddCount(G);
    AddWeight(G);
    case FStdItem.Shape of
      12:
      begin
        if FStdItem.DCMin > 0 then
        begin
          G.AddSampleLine(Format('使用后物理攻击+%d', [FStdItem.DCMin]), clLime);
          boFounded :=  True;
        end;
        if FStdItem.MCMin > 0 then
        begin
          G.AddSampleLine(Format('使用后魔法攻击+%d', [FStdItem.MCMin]), clLime);
          boFounded :=  True;
        end;
        if FStdItem.SCMin > 0 then
        begin
          G.AddSampleLine(Format('使用后道术攻击+%d', [FStdItem.SCMin]), clLime);
          boFounded :=  True;
        end;
        if FStdItem.TCMin > 0 then
        begin
          G.AddSampleLine(Format('使用后射术攻击+%d', [FStdItem.TCMin]), clLime);
          boFounded :=  True;
        end;
        if FStdItem.PCMin > 0 then
        begin
          G.AddSampleLine(Format('使用后刺术攻击+%d', [FStdItem.PCMin]), clLime);
          boFounded :=  True;
        end;
        if FStdItem.WCMin > 0 then
        begin
          G.AddSampleLine(Format('使用后武术攻击+%d', [FStdItem.WCMin]), clLime);
          boFounded :=  True;
        end;
        if FStdItem.ACMax > 0 then
        begin
          G.AddSampleLine(Format('使用后攻击速度+%d', [FStdItem.ACMax]), clLime);
          boFounded :=  True;
        end;
        if FStdItem.ACMin > 0 then
        begin
          G.AddSampleLine(Format('使用后体力值上限+%d', [FStdItem.ACMin]), clLime);
          boFounded :=  True;
        end;
        if FStdItem.MACMin > 0 then
        begin
          G.AddSampleLine(Format('使用后魔力值上限+%d', [FStdItem.MACMin]), clLime);
          boFounded :=  True;
        end;
        if boFounded then
        begin
          G.AddSampleLine(Format('持续时间%d秒', [FStdItem.MACMax]), $F75600);
          G.AddSampleLine('(双击直接使用)', clYellow);
        end;
      end;
      13:
      begin
        case FStdItem.AniCount of
          1:  G.AddSampleLine(Format('内含%d点经验值', [FStdItem.ACMin]), clLime);
          2:  G.AddSampleLine(Format('内含%d金币', [FStdItem.ACMin]), clLime);
          3:  G.AddSampleLine(Format('内含%d元宝', [FStdItem.ACMin]), clLime);
          4:  G.AddSampleLine(Format('内含%d礼金', [FStdItem.ACMin]), clLime);
          5:  G.AddSampleLine(Format('内含%d声望', [FStdItem.ACMin]), clLime);
        end;
        G.AddSampleLine('(双击直接使用)', clYellow);
      end;
    end;
  end;

  procedure AddStdMode4(G: TItemInfoDrawGroup);
  var
    sJob: String;
    bCanUse: Boolean;
  begin
    AddTypeName(G);
    case FStdItem.Shape of
      _JOB_WAR:
        begin
          sJob := '战士';
          bCanUse := g_MySelf.m_btJob = _JOB_WAR;
        end;
      _JOB_MAG:
        begin
          sJob := '法师';
          bCanUse := g_MySelf.m_btJob = _JOB_MAG;
        end;
      _JOB_DAO:
        begin
          sJob := '道士';
          bCanUse := g_MySelf.m_btJob = _JOB_DAO;
        end;
      _JOB_ARCHER:
        begin
          sJob := '弓箭手';
          bCanUse := g_MySelf.m_btJob = _JOB_ARCHER;
        end;
      _JOB_CIK:
        begin
          sJob := '刺客';
          bCanUse := g_MySelf.m_btJob = _JOB_CIK;
        end;
      _JOB_SHAMAN:
        begin
          sJob := '武僧';
          bCanUse := g_MySelf.m_btJob = _JOB_SHAMAN;
        end;
      99:
        begin
          sJob := '全职通用';
          bCanUse := TRUE;
        end;
    end;

    with G.AddLine('职业', sJob) do
    begin
      clCaption := _TxtColor[bCanUse];
      clValue := _TxtColor[bCanUse];
    end;

    bCanUse :=  g_MySelf.m_Abil.Level >= FStdItem.DuraMax;
    if FStdItem.Need = 4 then
    begin
      bCanUse :=  (g_MySelf.m_Abil.Level >= FStdItem.DuraMax) and (g_MySelf.m_btReLevel >= FStdItem.NeedLevel);
      with G.AddLine('需要转生', IntToStr(FStdItem.NeedLevel) + '级') do
      begin
        clCaption := _TxtColor[bCanUse];
        clValue := _TxtColor[bCanUse];
      end;
    end;
    with G.AddLine('等级', IntToStr(FStdItem.DuraMax)) do
    begin
      clCaption := _TxtColor[bCanUse];
      clValue   := _TxtColor[bCanUse];
    end;
    AddWeight(G);
  end;

  procedure AddDC(G: TItemInfoDrawGroup);
  var
    sDC: String;
  begin
    if (FStdItem.DCMin > 0) or (FStdItem.DCMax > 0) then
    begin
      sDC := '';
      if g_boEnableItemBasePower then
      begin
        if (FAddValue[2] > 0) or (FAddLValue[2] > 0) then
          sDC :=  Format(STR_ADDTIONFULL, [FAddLValue[2], FAddValue[2]]);
      end
      else if FAddValue[2] > 0 then
        sDC :=  Format(STR_ADDTION, [FAddValue[2]]);
      with G.AddLine('攻击', IntToStr(FStdItem.DCMin) + '-' + IntToStr(FStdItem.DCMax)) do
      begin
        Extend := sDC;
        clExtend := $66CCFF;
      end;
    end;
  end;

  procedure AddMC(G: TItemInfoDrawGroup);
  var
    sMC: String;
  begin
    if (FStdItem.MCMin > 0) or (FStdItem.MCMax > 0) then
    begin
      sMC := '';
      if g_boEnableItemBasePower then
      begin
        if (FAddValue[3] > 0) or (FAddLValue[3] > 0) then
          sMC :=  Format(STR_ADDTIONFULL, [FAddLValue[3], FAddValue[3]]);
      end
      else if FAddValue[3] > 0 then
        sMC :=  Format(STR_ADDTION, [FAddValue[3]]);
      with G.AddLine('魔法', IntToStr(FStdItem.MCMin) + '-' +
        IntToStr(FStdItem.MCMax)) do
      begin
        Extend := sMC;
        clExtend := $66CCFF;
      end;
    end;
  end;

  procedure AddSC(G: TItemInfoDrawGroup);
  var
    sSC: String;
  begin
    if (FStdItem.SCMin > 0) or (FStdItem.SCMax > 0) then
    begin
      sSC := '';
      if g_boEnableItemBasePower then
      begin
        if (FAddValue[4] > 0) or (FAddLValue[4] > 0) then
          sSC :=  Format(STR_ADDTIONFULL, [FAddLValue[4], FAddValue[4]]);
      end
      else if FAddValue[4]>0 then
        sSC :=  Format(STR_ADDTION, [FAddValue[4]]);
      with G.AddLine('道术', IntToStr(FStdItem.SCMin) + '-' +
        IntToStr(FStdItem.SCMax)) do
      begin
        Extend := sSC;
        clExtend := $66CCFF;
      end;
    end;
  end;

  procedure AddTC(G: TItemInfoDrawGroup);
  var
    sTC: String;
  begin
    if cjARCHER in g_ServerJobs then
    begin
      if (FStdItem.TCMin > 0) or (FStdItem.TCMax > 0) then
      begin
        sTC := '';
        if g_boEnableItemBasePower then
        begin
          if (FAddValue[5] > 0) or (FAddLValue[5] > 0) then
            sTC :=  Format(STR_ADDTIONFULL, [FAddLValue[5], FAddValue[5]]);
        end
        else if FAddValue[5]>0 then
          sTC :=  Format(STR_ADDTION, [FAddValue[5]]);
        with G.AddLine('箭术', IntToStr(FStdItem.TCMin) + '-' + IntToStr(FStdItem.TCMax)) do
        begin
          Extend := sTC;
          clExtend := $66CCFF;
        end;
      end;
    end;
  end;

  procedure AddPC(G: TItemInfoDrawGroup);
  var
    sPC: String;
  begin
    if cjCIK in g_ServerJobs then
    begin
      if (FStdItem.PCMin > 0) or (FStdItem.PCMax > 0) then
      begin
        sPC := '';
        if g_boEnableItemBasePower then
        begin
          if (FAddValue[6] > 0) or (FAddLValue[6] > 0) then
            sPC :=  Format(STR_ADDTIONFULL, [FAddLValue[6], FAddValue[6]]);
        end
        else if FAddValue[6]>0 then
          sPC :=  Format(STR_ADDTION, [FAddValue[6]]);
        with G.AddLine('刺术', IntToStr(FStdItem.PCMin) + '-' + IntToStr(FStdItem.PCMax)) do
        begin
          Extend := sPC;
          clExtend := $66CCFF;
        end;
      end;
    end;
  end;

  procedure AddWC(G: TItemInfoDrawGroup);
  var
    sWC: String;
  begin
    if cjShaman in g_ServerJobs then
    begin
      if (FStdItem.WCMin > 0) or (FStdItem.WCMax > 0) then
      begin
        sWC := '';
        if g_boEnableItemBasePower then
        begin
          if (FAddValue[7] > 0) or (FAddLValue[7] > 0) then
            sWC :=  Format(STR_ADDTIONFULL, [FAddLValue[7], FAddValue[7]]);
        end
        else if FAddValue[7]>0 then
          sWC :=  Format(STR_ADDTION, [FAddValue[7]]);
        with G.AddLine('武术', IntToStr(FStdItem.WCMin) + '-' + IntToStr(FStdItem.WCMax)) do
        begin
          Extend := sWC;
          clExtend := $66CCFF;
        end;
      end;
    end;
  end;

  procedure AddLine(G: TItemInfoDrawGroup);
  begin



  end;

  procedure Add56AC(G: TItemInfoDrawGroup);
  var
    V: Integer;
  begin
    V := FStdItem.ACMax;
    if V > 0 then
    begin
      with G.AddLine('准确', IntToStr(V)) do
      begin
        if FAddProperty.Undefined1 > 0 then
          Extend := Format(STR_ADDTION, [FAddProperty.Undefined1])
        else if FAddProperty.Undefined1 < 0 then
        begin
          Extend := Format('[%d]', [FAddProperty.Undefined1]);
          clExtend :=  clRed;
        end;
      end;
    end;
  end;

  procedure AddDuraMax(G: TItemInfoDrawGroup);
  var
    sDuraMax: String;
    c: TColor;
  begin
    c := $66CCFF;
    sDuraMax := '';
    if FDuraMax > FStdItem.DuraMax then
    begin
      if (FDuraMax - FStdItem.DuraMax) div 1000 > 0 then
        sDuraMax := Format(STR_ADDTION, [(FDuraMax - FStdItem.DuraMax) div 1000]);
      c := $66CCFF;
    end;
    {else if FDuraMax < FStdItem.DuraMax then
    begin
      if (FStdItem.DuraMax - FDuraMax) div 1000 > 0 then
        sDuraMax := Format('[-%d]', [(FStdItem.DuraMax - FDuraMax) div 1000]);
      c := clRed;
    end; todo 取消负数持久显示}
    with G.AddLine('持久', GetDuraStr(FDura, FDuraMax)) do
    begin
      if FDura = 0 then
      begin
        clExtend :=  clRed;
        sDuraMax:=  sDuraMax + '(已破损)';
      end;
      Extend := sDuraMax;
      clValue :=  C;
    end;
  end;

  procedure AddSoulLevel(G: TItemInfoDrawGroup);
  begin
    if SoulEnabled then
    begin
      if FAddProperty.SoulLevel = 0 then
      begin
        G.AddLine(g_UIManager.Form.HintEditor.SoulName, '<未激活>').clValue := clRed;
      end
      else
      begin
        if FAddProperty.SoulLevel - 1 >= ClientConf.nMaxSoulLevel then
          G.AddLine(g_UIManager.Form.HintEditor.SoulName, 'MAX')
        else
          G.AddLine(g_UIManager.Form.HintEditor.SoulName, Format('%d级', [FAddProperty.SoulLevel-1]), clLime);
      end;
    end;
  end;

  procedure AddInfoStdMode56(G: TItemInfoDrawGroup);
  begin
    AddTypeName(G);
    AddJob(G);
    AddNeedLevel(G);
    AddDuraMax(G);
    AddWeight(G);
    AddSoulLevel(G);
  end;

  procedure AddStdMode56(G: TItemInfoDrawGroup);
  begin
    AddDC(G);
    AddMC(G);
    AddSC(G);
    AddTC(G);
    AddPC(G);
    AddWC(G);
    Add56AC(G);
    AddSpeed(G);
    AddLuck(G);
    Add56Source(G);
    AddItemCaptionAndText(G);
  end;

  procedure AddInfoStdMode7(G: TItemInfoDrawGroup);
  var
    GDsc: TItemDescDrawGroup;
    S: String;
  begin
    AddTypeName(G);
    if FStdItem.Shape = 4 then
      AddJob(G);
    AddNeedLevel(G);
    case FStdItem.Shape of
      0:
      begin
        G.AddLine('使用', GetDuraStr(FDura, FDuraMax) + ' 次');
        AddWeight(G);
      end;
      1:
      begin
        AddWeight(G);
        G.AddLine('存储HP', IntToStr(FDura),M2StrToColor('254'));
        G.AddLine('恢复启动临界点', IntToStr(FStdItem.ACMin) + '%',M2StrToColor('254'));
        G.AddLine('恢复上限', IntToStr(FStdItem.MACMax) + '%',M2StrToColor('254'));
        G.AddLine('恢复间隔(秒)', Format('%.2f',[FStdItem.ACMax / 1000]),M2StrToColor('254'));
        G.AddLine('单次恢复', IntToStr(FStdItem.MACMin),M2StrToColor('254'));
      end;
      2:
      begin
        AddWeight(G);
        G.AddLine('存储MP', IntToStr(FDura),M2StrToColor('254'));
        G.AddLine('恢复启动临界点', IntToStr(FStdItem.ACMin) + '%',M2StrToColor('254'));
        G.AddLine('恢复上限', IntToStr(FStdItem.MACMax) + '%',M2StrToColor('254'));
        G.AddLine('恢复间隔(秒)', Format('%.2f',[FStdItem.ACMax / 1000]),M2StrToColor('254'));
        G.AddLine('单次恢复', IntToStr(FStdItem.MACMin),M2StrToColor('254'));
      end;
      3:
      begin
        AddWeight(G);

        G.AddLine('存储HP&MP', IntToStr(FDura),M2StrToColor('254'));
        G.AddLine('恢复启动临界点', IntToStr(FStdItem.ACMin) + '%',M2StrToColor('254'));
        G.AddLine('恢复上限', IntToStr(FStdItem.MACMax) + '%',M2StrToColor('254'));
        G.AddLine('恢复间隔(秒)', Format('%.2f',[FStdItem.ACMax / 1000]),M2StrToColor('254'));
        G.AddLine('单次恢复', IntToStr(FStdItem.MACMin),M2StrToColor('254'));
      end;
      4:
      begin
        AddDuraMax(G);
        AddWeight(G);
        AddSoulLevel(G);
      end;
    end;
  end;

  procedure AddStdMode8(G: TItemInfoDrawGroup);
  begin
    AddTypeName(G);
    AddJob(G);
    AddNeedLevel(G);
    AddDuraMax(G);
    AddWeight(G);
    AddSoulLevel(G);
  end;

  procedure AddAC(G: TItemInfoDrawGroup);
  var
    sAC: String;
  begin
    if (FStdItem.ACMin > 0) or (FStdItem.ACMax > 0) then
    begin
      sAC := '';
      if g_boEnableItemBasePower then
      begin
        if (FAddValue[0] > 0) or (FAddLValue[0] > 0) then
          sAC := Format(STR_ADDTIONFULL, [FAddLValue[0], FAddValue[0]]);
      end
      else if FAddValue[0]>0 then
        sAC := Format(STR_ADDTION, [FAddValue[0]]);
      with G.AddLine('防御', IntToStr(FStdItem.ACMin) + '-' + IntToStr(FStdItem.ACMax)) do
      begin
        Extend := sAC;
        clExtend := $66CCFF;
      end;
    end;
  end;

  procedure AddMAC(G: TItemInfoDrawGroup);
  var
    sMAC: String;
  begin
    if (FStdItem.MACMin > 0) or (FStdItem.MACMax > 0) then
    begin
      sMAC := '';
      if g_boEnableItemBasePower then
      begin
        if (FAddValue[1] > 0) or (FAddLValue[1] > 0) then
          sMAC := Format(STR_ADDTIONFULL, [FAddLValue[1], FAddValue[1]]);
      end
      else if FAddValue[1]>0 then
        sMAC :=  Format(STR_ADDTION, [FAddValue[1]]);
      with G.AddLine('魔御', IntToStr(FStdItem.MACMin) + '-' + IntToStr(FStdItem.MACMax)) do
      begin
        Extend := sMAC;
        clExtend := $66CCFF;
      end;
    end;
  end;

  procedure AddInfoStdMode1011(G: TItemInfoDrawGroup; Male: Boolean);
  begin
    AddTypeName(G);
    AddSexuality(G, Male);
    AddJob(G);
    AddNeedLevel(G);
    AddDuraMax(G);
    AddWeight(G);
    AddSoulLevel(G);
  end;

  procedure AddInfoStdMode1718(G: TItemInfoDrawGroup; Male: Boolean);
  begin
    AddTypeName(G);
    AddSexuality(G, Male);
    AddJob(G);
    AddNeedLevel(G);
    AddDuraMax(G);
    AddWeight(G);
    AddSoulLevel(G);
  end;

  procedure AddStdMode1011(G: TItemInfoDrawGroup; Male: Boolean);
  begin
    AddAC(G);
    AddMAC(G);
    AddDC(G);
    AddMC(G);
    AddSC(G);
    AddTC(G);
    AddPC(G);
    AddWC(G);
    AddItemCaptionAndText(G);
  end;

  procedure AddInfoEq(G: TItemInfoDrawGroup);
  begin
    AddTypeName(G);
    AddJob(G);
    AddNeedLevel(G);
    AddDuraMax(G);
    AddWeight(G);
    AddSoulLevel(G);
  end;

  procedure AddEq(G: TItemInfoDrawGroup);
  begin
    case FStdItem.StdMode of
      19: // 项链
      begin
        AddDC(G);
        AddMC(G);
        AddSC(G);
        AddTC(G);
        AddPC(G);
        AddWC(G);
        if FStdItem.ACMax > 0 then
          G.AddLine('魔法躲避', '+' + IntToStr(FStdItem.ACMax) + '%');
        AddLuck(G);
      end;
      20, 24: // 项链 及 手镯: MaxAC -> Hit,  MaxMac -> Speed
      begin
        AddDC(G);
        AddMC(G);
        AddSC(G);
        AddTC(G);
        AddPC(G);
        AddWC(G);
        if FStdItem.ACMax > 0 then
          G.AddLine('准确', '+' + IntToStr(FStdItem.ACMax));
        if FStdItem.MACMax > 0 then
          G.AddLine('敏捷', '+' + IntToStr(FStdItem.MACMax));
      end;
      21: // 项链
      begin
        AddDC(G);
        AddMC(G);
        AddSC(G);
        AddTC(G);
        AddPC(G);
        AddWC(G);
        if FStdItem.ACMax > 0 then
          G.AddLine('体力值恢复', '+' + IntToStr(FStdItem.ACMax) + '%');
        if FStdItem.MACMax > 0 then
          G.AddLine('魔力值恢复', '+' + IntToStr(FStdItem.MACMax) + '%');
        AddSpeed(G);
      end;
      23: // 戒指
      begin
        AddDC(G);
        AddMC(G);
        AddSC(G);
        AddTC(G);
        AddPC(G);
        AddWC(G);
        if FStdItem.ACMax > 0 then
          G.AddLine('毒物躲避', '+' + IntToStr(FStdItem.ACMax) + '%');
        if FStdItem.MACMax > 0 then
          G.AddLine('中毒恢复', '+' + IntToStr(FStdItem.MACMax) + '%');
        AddSpeed(G);
      end;
      27:
      begin
        AddAC(G);
        AddMAC(G);
        AddDC(G);
        AddMC(G);
        AddSC(G);
        AddTC(G);
        AddPC(G);
        AddWC(G);
        if FStdItem.AniCount * FStdItem.Weight > 0 then
          G.AddLine('负重', IntToStr(FStdItem.AniCount * FStdItem.Weight));
      end;
    else
      begin
        AddAC(G);
        AddMAC(G);
        AddDC(G);
        AddMC(G);
        AddSC(G);
        AddTC(G);
        AddPC(G);
        AddWC(G);
      end;
    end;

    AddItemCaptionAndText(G);
  end;

  procedure AddAddPoint(G: TItemInfoDrawGroup);
  var
    ALine: TDrawItemLine;
    I: Integer;
  begin
    if g_UIManager.Form.HintEditor.Addition.Visible then
    begin
      for I := Low(FAddPoint) to High(FAddPoint) do
      begin
        if FAddPoint[I].Value > 0 then
          case FAddPoint[I].ValueType of
            tIpDamageDec: G.AddLine('伤害吸收','+'+IntToStr(FAddPoint[I].Value)+'%', $000336E7);
            tIpDamageRebound: G.AddLine('伤害反弹','+'+IntToStr(FAddPoint[I].Value)+'%', $000336E7);
            tIpDamageAdd: G.AddLine('伤害加成','+'+IntToStr(FAddPoint[I].Value)+'%', $000336E7);
            tIpPunchHit: G.AddLine('致命一击','+'+IntToStr(FAddPoint[I].Value)+'%', $000336E7);
            tIpCriticalHit: G.AddLine('会心一击','+'+IntToStr(FAddPoint[I].Value)+'%', $000336E7);
            tIpHPRecovery: G.AddLine('体力值恢复','+'+IntToStr(FAddPoint[I].Value)+'%', $000336E7);
            tIpMPRecovery: G.AddLine('魔力值恢复','+'+IntToStr(FAddPoint[I].Value)+'%', $000336E7);
            tIpExpAddRate: G.AddLine('经验加成','+'+IntToStr(FAddPoint[I].Value)+'%', $000336E7);
            tIpItemDropRate: G.AddLine('物品爆率加成','+'+IntToStr(FAddPoint[I].Value)+'%', $000336E7);
            tIpGoldDropRate: G.AddLine('金币爆率加成','+'+IntToStr(FAddPoint[I].Value)+'%', $000336E7);
            tIpHitAdd: G.AddLine('准确','+'+IntToStr(FAddPoint[I].Value), $000336E7);
            tIpSpeedAdd: G.AddLine('敏捷','+'+IntToStr(FAddPoint[I].Value), $000336E7);
            tIpHPMax: G.AddLine('体力值上限','+'+IntToStr(FAddPoint[I].Value) + 'HP', $000336E7);
            tIpMPMax: G.AddLine('魔力值上限','+'+IntToStr(FAddPoint[I].Value) + 'MP', $000336E7);
            tIpFixDamage: G.AddLine('固定伤害','+'+IntToStr(FAddPoint[I].Value), $000336E7);
            tIpHPMaxRate: G.AddLine('体力值上限','+'+IntToStr(FAddPoint[I].Value) + '%', $000336E7);
            tIpMPMaxRate: G.AddLine('魔力值上限','+'+IntToStr(FAddPoint[I].Value) + '%', $000336E7);
            tIpPunchHitAppendDamage:G.AddLine('致命一击额外伤害','+'+IntToStr(FAddPoint[I].Value), $000336E7);
            tIpCriticalHitAppendDamage:G.AddLine('会心一击额外伤害','+'+IntToStr(FAddPoint[I].Value), $000336E7);
          end;
      end;

      if G.HasItem and (g_UIManager.Form.HintEditor.Addition.Caption <> '') then
      begin
        ALine :=  TDrawItemLine.Create;
        G.FLines.Insert(0, ALine);
        ALine.Caption := g_UIManager.Form.HintEditor.Addition.Caption;
        ALine.clCaption := g_UIManager.Form.HintEditor.Addition.Color;
        ALine.Height := 15;
        ALine.LineType := ltSample;
        G.AddSplitlLineFirst(10);
      end;
    end;
  end;

  procedure AddAddLevel(G: TItemInfoDrawGroup);
  var
    ALine: TDrawItemLine;
    I: Integer;
    AColor: TColor;
    sLevel, S: String;
  begin
    if g_UIManager.Form.HintEditor.Upgrade.Visible then
    begin
      for I := Low(FAddLevel) to High(FAddLevel) do
      begin
        if (FAddLevel[I].State in [1, 2]) and (FAddProperty.MaxUpgrade >= g_AddLevelCondition[I]) then
        begin
          if FAddLevel[I].Value > 0 then
          begin
            if FAddLevel[I].State = 2 then
              AColor := $000099FF
            else
              AColor := $00888888;
            if g_AddLevelCondition[I] > 9 then
              sLevel := '[+' + IntToStr(g_AddLevelCondition[I]) + ']'
            else
              sLevel := '[+ ' + IntToStr(g_AddLevelCondition[I]) + ']';
            case FAddLevel[I].ValueType of
              tIpDamageDec: G.AddLine(sLevel, '伤害吸收+'+IntToStr(FAddLevel[I].Value)+'%', AColor);
              tIpDamageRebound: G.AddLine(sLevel, '伤害反弹'+IntToStr(FAddLevel[I].Value)+'%', AColor);
              tIpDamageAdd: G.AddLine(sLevel, '伤害加成+'+IntToStr(FAddLevel[I].Value)+'%', AColor);
              tIpPunchHit: G.AddLine(sLevel, '致命一击+'+IntToStr(FAddLevel[I].Value)+'%', AColor);
              tIpCriticalHit: G.AddLine(sLevel, '会心一击+'+IntToStr(FAddLevel[I].Value)+'%', AColor);
              tIpHPRecovery: G.AddLine(sLevel, '体力值恢复+'+IntToStr(FAddLevel[I].Value)+'%', AColor);
              tIpMPRecovery: G.AddLine(sLevel, '魔力值恢复+'+IntToStr(FAddLevel[I].Value)+'%', AColor);
              tIpExpAddRate: G.AddLine(sLevel, '经验加成+'+IntToStr(FAddLevel[I].Value)+'%', AColor);
              tIpItemDropRate: G.AddLine(sLevel, '物品爆率加成+'+IntToStr(FAddLevel[I].Value)+'%', AColor);
              tIpGoldDropRate: G.AddLine(sLevel, '金币爆率加成+'+IntToStr(FAddLevel[I].Value)+'%', AColor);
              tIpHitAdd: G.AddLine(sLevel, '准确+'+IntToStr(FAddLevel[I].Value), AColor);
              tIpSpeedAdd: G.AddLine(sLevel, '敏捷+'+IntToStr(FAddLevel[I].Value), AColor);
              tIpHPMax: G.AddLine(sLevel, '体力值上限+'+IntToStr(FAddLevel[I].Value) + 'HP', AColor);
              tIpMPMax: G.AddLine(sLevel, '魔力值上限+'+IntToStr(FAddLevel[I].Value) + 'MP', AColor);
              tIpFixDamage : G.AddLine(sLevel, '固定伤害+'+IntToStr(FAddLevel[I].Value), AColor);
              tIpHPMaxRate : G.AddLine(sLevel, '体力值上限+'+IntToStr(FAddLevel[I].Value)+'%', AColor);
              tIpMPMaxRate : G.AddLine(sLevel, '魔力值上限+'+IntToStr(FAddLevel[I].Value)+'%', AColor);
              tIpPunchHitAppendDamage:G.AddLine(sLevel, '致命一击额外伤害+'+IntToStr(FAddLevel[I].Value), AColor);
              tIpCriticalHitAppendDamage:G.AddLine(sLevel, '会心一击额外伤害+'+IntToStr(FAddLevel[I].Value), AColor);
            end;
          end;
        end
        else
          Break;
      end;
      if G.HasItem and (g_UIManager.Form.HintEditor.Upgrade.Caption <> '') then
      begin
        ALine :=  TDrawItemLine.Create;
        G.FLines.Insert(0, ALine);
        ALine.Caption := g_UIManager.Form.HintEditor.Upgrade.Caption;
        ALine.clCaption := g_UIManager.Form.HintEditor.Upgrade.Color;
        ALine.Height := 15;
        ALine.LineType := ltSample;
        G.AddSplitlLineFirst(10);
      end;
    end;
  end;

  procedure AddCountIfSuitItem(Item: TClientItem; ItemIndex: Integer; var ASuitItemCount, ACount: Integer; ANames: TStrings);
  var
    AStdItem: pTStdItem;
    S: String;
    AFounded: Boolean;
  begin
    if ItemIndex > 0 then
    begin
      Inc(ASuitItemCount);
      AFounded := False;
      if (Item.Name<>'') and (Item.MakeIndex>0) and (Item.Index = ItemIndex) then
      begin
        Inc(ACount);
        AFounded := True;
      end;
      if ItemIndex < g_ItemList.Count then
      begin
        AStdItem := g_ItemList[ItemIndex];
        if AStdItem <> nil then
        begin
          case AStdItem.StdMode of
            5,6: S := '[武] '+ AStdItem.DisplayName;
            8: S := '[盾] '+ AStdItem.DisplayName;
            10: S := '[衣] '+ AStdItem.DisplayName;
            11: S := '[衣] '+ AStdItem.DisplayName;
            15: S := '[盔] '+ AStdItem.DisplayName;
            16: S := '[笠] '+ AStdItem.DisplayName;
            17,18: S := '[时] '+ AStdItem.DisplayName;
            19,20,21: S := '[链] '+ AStdItem.DisplayName;
            22,23: S := '[戒] '+ AStdItem.DisplayName;
            24,26: S := '[镯] '+ AStdItem.DisplayName;
            27: S := '[腰] '+ AStdItem.DisplayName;
            28: S := '[靴] '+ AStdItem.DisplayName;
            30: S := '[章] '+ AStdItem.DisplayName;
            35: S := '[马] '+ AStdItem.DisplayName;
            7: S := '[石] ' +  AStdItem.DisplayName
            else
              S := AStdItem.DisplayName;;
          end;
          ANames.Add(IntToStr(Ord(AFounded)) + S);
        end;
      end;
    end;
  end;

  procedure DrawSuitPropertyLine(G: TItemInfoDrawGroup; Need, Count: Integer; AProperty: TSuitProperty; var boPrefix: Boolean);
  var
    APrefix,
    APropValue: String;
  begin
    if AProperty.PropType = sptNone then Exit;

    if not boPrefix then
    begin
      boPrefix  :=  True;
      APrefix   :=  '('+IntToStr(Need)+') ';
    end
    else
      APrefix   :=  '    ';
    case AProperty.PropType of
      sptMaxHP:           APropValue  :=  '体力值上限+'+IntToStr(AProperty.Value) + 'HP';
      sptMaxMP:           APropValue  :=  '魔力值上限+'+IntToStr(AProperty.Value) + 'MP';
      sptfMaxHP:          APropValue  :=  '体力值上限+'+formatfloat('0.00',AProperty.Value / 100) + '% HP';   //注意这里不是100 是10000 前面0.00 /100  共计1W
      sptfMaxMP:          APropValue  :=  '魔力值上限+'+formatfloat('0.00',AProperty.Value / 100) + '% MP';
      sptDC:              APropValue  :=  '物理攻击下限+'+IntToStr(AProperty.Value);
      sptMaxDC:           APropValue  :=  '物理攻击上限+'+IntToStr(AProperty.Value);
      sptMC:              APropValue  :=  '魔法攻击下限+'+IntToStr(AProperty.Value);
      sptMaxMC:           APropValue  :=  '魔法攻击上限+'+IntToStr(AProperty.Value);
      sptSC:              APropValue  :=  '道术攻击下限+'+IntToStr(AProperty.Value);
      sptMaxSC:           APropValue  :=  '道术攻击上限+'+IntToStr(AProperty.Value);
      sptTc:              APropValue  :=  '箭术攻击下限+'+IntToStr(AProperty.Value);
      sptMaxTc:           APropValue  :=  '箭术攻击上限+'+IntToStr(AProperty.Value);
      sptPc:              APropValue  :=  '刺术攻击下限+'+IntToStr(AProperty.Value);
      sptMaxPc:           APropValue  :=  '刺术攻击上限+'+IntToStr(AProperty.Value);
      sptWc:              APropValue  :=  '武术攻击下限+'+IntToStr(AProperty.Value);
      sptMaxWc:           APropValue  :=  '武术攻击上限+'+IntToStr(AProperty.Value);
      sptAC:              APropValue  :=  '物理防御下限+'+IntToStr(AProperty.Value);
      sptMaxAC:           APropValue  :=  '物理防御上限+'+IntToStr(AProperty.Value);
      sptMAC:             APropValue  :=  '魔法防御下限+'+IntToStr(AProperty.Value);
      sptMaxMAC:          APropValue  :=  '魔法防御上限+'+IntToStr(AProperty.Value);
      sptHitPoint:        APropValue  :=  '准确+'+IntToStr(AProperty.Value);
      sptSpeedPoint:      APropValue  :=  '敏捷+'+IntToStr(AProperty.Value);
      sptHealthRecover:   APropValue  :=  '体力值恢复+'+IntToStr(AProperty.Value) + '%';
      sptSpellRecover:    APropValue  :=  '魔力值恢复+'+IntToStr(AProperty.Value) + '%';
      sptbtReserved:      APropValue  :=  '吸血+'+IntToStr(AProperty.Value);
      sptnEXPRATE:        APropValue  :=  '经验倍数+'+IntToStr(AProperty.Value);
      sptnPowerRate:      APropValue  :=  '攻击倍数+'+IntToStr(AProperty.Value) + '%';
      sptnMagicRate:      APropValue  :=  '魔法倍数+'+IntToStr(AProperty.Value) + '%';
      sptnSCRate:         APropValue  :=  '道术倍数+'+IntToStr(AProperty.Value) + '%';
      sptnTCRate:         APropValue  :=  '箭术倍数+'+IntToStr(AProperty.Value) + '%';
      sptnPCRate:         APropValue  :=  '刺术倍数+'+IntToStr(AProperty.Value) + '%';
      sptnWCRate:         APropValue  :=  '武术倍数+'+IntToStr(AProperty.Value) + '%';
      sptnACRate:         APropValue  :=  '防御倍数+'+IntToStr(AProperty.Value) + '%';
      sptnMACRate:        APropValue  :=  '魔御倍数+'+IntToStr(AProperty.Value) + '%';
      sptnAntiMagic:      APropValue  :=  '魔法躲避+'+IntToStr(AProperty.Value);
      sptnAntiPoison:     APropValue  :=  '毒物躲避+'+IntToStr(AProperty.Value);
      sptnPoisonRecover:  APropValue  :=  '中毒恢复+'+IntToStr(AProperty.Value);
      sptboTeleport:      APropValue  :=  '传送';
      sptboParalysis:     APropValue  :=  '麻痹';
      sptboRevival:       APropValue  :=  '复活';
      sptboMagicShield:   APropValue  :=  '护身';
      sptboUnParalysis:   APropValue  :=  '防麻痹';
    end;
    if Count >= Need then
      G.AddSampleLine(APrefix + APropValue, g_UIManager.Form.HintEditor.Suit.ActivePropertyColor)
    else
      G.AddSampleLine(APrefix + APropValue, g_UIManager.Form.HintEditor.Suit.PropertyColor);
  end;

  procedure DrawSuitProperties(G: TItemInfoDrawGroup; AProperties: TSuitProperties; ACount: Integer);
  var
    boPrefix: Boolean;
  begin
    if AProperties.ItemCount > 0 then
    begin
      boPrefix  :=  False;
      DrawSuitPropertyLine(G, AProperties.ItemCount, ACount, AProperties.PropertiesI, boPrefix);
      DrawSuitPropertyLine(G, AProperties.ItemCount, ACount, AProperties.PropertiesII, boPrefix);
      DrawSuitPropertyLine(G, AProperties.ItemCount, ACount, AProperties.PropertiesIII, boPrefix);
    end;
  end;

  procedure AddSuitInfo(G: TItemInfoDrawGroup);
  var
    I, J, ACount, ASuitItemCount: Integer;
    ASuiteItem: TSuitItem;
    boFounded: Boolean;
    S: String;
    ANames: TStrings;
  begin
    if g_UIManager.Form.HintEditor.Suit.Visible then
    begin
      boFounded := False;
      for I := 0 to g_SuitList.Count - 1 do
      begin
        ASuiteItem  :=  g_SuitList.Items[I]^;
        case FStdItem.StdMode of
          5, 6:   boFounded :=  FStdItem.Index = ASuiteItem.ItemIndex[U_WEAPON];
          8:      boFounded :=  FStdItem.Index = ASuiteItem.ItemIndex[U_SHIED];
          10:     boFounded :=  FStdItem.Index = ASuiteItem.MaleDress;
          11:     boFounded :=  FStdItem.Index = ASuiteItem.FemaleDress;
          15:     boFounded :=  FStdItem.Index = ASuiteItem.ItemIndex[U_HELMET];
          16:     boFounded :=  FStdItem.Index = ASuiteItem.ItemIndex[U_ZHULI];
          17:     boFounded :=  FStdItem.Index = ASuiteItem.MaleFashion;
          18:     boFounded :=  FStdItem.Index = ASuiteItem.FemaleFashion;
          19..21: boFounded :=  FStdItem.Index = ASuiteItem.ItemIndex[U_NECKLACE];
          22,23:  boFounded :=  (FStdItem.Index = ASuiteItem.ItemIndex[U_RINGL]) or (FStdItem.Index = ASuiteItem.ItemIndex[U_RINGR]);
          24,26:  boFounded :=  (FStdItem.Index = ASuiteItem.ItemIndex[U_ARMRINGL]) or (FStdItem.Index = ASuiteItem.ItemIndex[U_ARMRINGR]);
          25:     boFounded :=  FStdItem.Index = ASuiteItem.ItemIndex[U_BUJUK];
          27:     boFounded :=  FStdItem.Index = ASuiteItem.ItemIndex[U_BELT];
          28:     boFounded :=  FStdItem.Index = ASuiteItem.ItemIndex[U_BOOTS];
          7:     boFounded :=  FStdItem.Index = ASuiteItem.ItemIndex[U_CHARM];
          30:     boFounded :=  FStdItem.Index = ASuiteItem.ItemIndex[U_RIGHTHAND];
          35:     boFounded :=  FStdItem.Index = ASuiteItem.ItemIndex[U_MOUNT];
        end;
        if boFounded then
        begin
          if ASuiteItem.ShowInClient then
          begin
            ANames := TStringList.Create;
            try
              ACount  :=  0;
              ASuitItemCount  :=  0;
              AddCountIfSuitItem(g_UseItems[U_HELMET], ASuiteItem.ItemIndex[U_HELMET], ASuitItemCount, ACount, ANames);
              if g_MySelf.m_btSex = 0 then
                AddCountIfSuitItem(g_UseItems[U_DRESS], ASuiteItem.MaleDress, ASuitItemCount, ACount, ANames)
              else
              AddCountIfSuitItem(g_UseItems[U_DRESS], ASuiteItem.FemaleDress, ASuitItemCount, ACount, ANames);
              AddCountIfSuitItem(g_UseItems[U_FASHION], ASuiteItem.MaleFashion, ASuitItemCount, ACount, ANames);
              AddCountIfSuitItem(g_UseItems[U_FASHION], ASuiteItem.FemaleFashion, ASuitItemCount, ACount, ANames);
              AddCountIfSuitItem(g_UseItems[U_WEAPON], ASuiteItem. ItemIndex[U_WEAPON], ASuitItemCount, ACount, ANames);
              AddCountIfSuitItem(g_UseItems[U_SHIED], ASuiteItem. ItemIndex[U_SHIED], ASuitItemCount, ACount, ANames);
              AddCountIfSuitItem(g_UseItems[U_RIGHTHAND], ASuiteItem.ItemIndex[U_RIGHTHAND], ASuitItemCount, ACount, ANames);
              AddCountIfSuitItem(g_UseItems[U_NECKLACE], ASuiteItem.ItemIndex[U_NECKLACE], ASuitItemCount, ACount, ANames);
              AddCountIfSuitItem(g_UseItems[U_ARMRINGL], ASuiteItem.ItemIndex[U_ARMRINGL], ASuitItemCount, ACount, ANames);
              AddCountIfSuitItem(g_UseItems[U_ARMRINGR], ASuiteItem.ItemIndex[U_ARMRINGR], ASuitItemCount, ACount, ANames);
              AddCountIfSuitItem(g_UseItems[U_RINGL], ASuiteItem.ItemIndex[U_RINGL], ASuitItemCount, ACount, ANames);
              AddCountIfSuitItem(g_UseItems[U_RINGR], ASuiteItem.ItemIndex[U_RINGR], ASuitItemCount, ACount, ANames);
              AddCountIfSuitItem(g_UseItems[U_BUJUK], ASuiteItem.ItemIndex[U_BUJUK], ASuitItemCount, ACount, ANames);
              AddCountIfSuitItem(g_UseItems[U_BELT], ASuiteItem.ItemIndex[U_BELT], ASuitItemCount, ACount, ANames);
              AddCountIfSuitItem(g_UseItems[U_BOOTS], ASuiteItem.ItemIndex[U_BOOTS], ASuitItemCount, ACount, ANames);
              AddCountIfSuitItem(g_UseItems[U_CHARM], ASuiteItem.ItemIndex[U_CHARM], ASuitItemCount, ACount, ANames);
              AddCountIfSuitItem(g_UseItems[U_ZHULI], ASuiteItem.ItemIndex[U_ZHULI], ASuitItemCount, ACount, ANames);
              AddCountIfSuitItem(g_UseItems[U_MOUNT], ASuiteItem.ItemIndex[U_MOUNT], ASuitItemCount, ACount, ANames);

              if FItemFrom = fkUse then
              begin
                S := g_UIManager.Form.HintEditor.Suit.UsedCaption;
                S := StringReplace(S, '#套装名#', ASuiteItem.Name, [rfReplaceAll]);
                S := StringReplace(S, '#激活数#', IntToStr(ACount), [rfReplaceAll]);
                S := StringReplace(S, '#总数#', IntToStr(ASuitItemCount), [rfReplaceAll]);
              end
              else
              begin
                S := g_UIManager.Form.HintEditor.Suit.Caption;
                S := StringReplace(S, '#套装名#', ASuiteItem.Name, [rfReplaceAll]);
                S := StringReplace(S, '#激活数#', IntToStr(ACount), [rfReplaceAll]);
                S := StringReplace(S, '#总数#', IntToStr(ASuitItemCount), [rfReplaceAll]);
                ACount  :=  0;
              end;
              if S <> '' then
                G.AddSampleLine(S, g_UIManager.Form.HintEditor.Suit.Color);
              DrawSuitProperties(G, ASuiteItem.PropertiesI, ACount);
              DrawSuitProperties(G, ASuiteItem.PropertiesII, ACount);
              DrawSuitProperties(G, ASuiteItem.PropertiesIII, ACount);
              if g_UIManager.Form.HintEditor.Suit.ShowNames then
              begin
                for J := 0 to ANames.Count - 1 do
                begin
                  S := ANames[J];
                  boFounded := (FItemFrom = fkUse) and (S[1] = '1');
                  Delete(S, 1, 1);
                  if boFounded then
                    G.AddSampleLine(S, g_UIManager.Form.HintEditor.Suit.ActiveNameColor)
                  else
                    G.AddSampleLine(S, g_UIManager.Form.HintEditor.Suit.NameColor);
                end;
              end;
            finally
              FreeAndNilEx(ANames);
            end;
          end;
          Break;
        end;
      end;
    end;
  end;

  procedure AddHoleInfo(G: TItemInfoDrawGroup);
  begin
  end;

  procedure LoadDefaultProp(G: TItemInfoDrawGroup);
  var
    C: TColor;
    S: String;
    APrice: Integer;
  begin
    if g_UIManager.Form.HintEditor.Price.Visible then
    begin
      APrice := GetPrice;
      if APrice>0 then
      begin
        C := g_UIManager.Form.HintEditor.Price.Color;
        S := g_UIManager.Form.HintEditor.Price.Caption;
        S := StringReplace(S, '#金额#', IntToStr(APrice), [rfReplaceAll]);
        S := StringReplace(S, '#类型#', g_sGoldName, [rfReplaceAll]);
        G.AddSampleLine(S, C);
      end;
    end;
  end;

  procedure LoadStallItemDesc(G: TItemInfoDrawGroup);
  var
    C: TColor;
    S, APrefix: String;
  begin
    case FItemFrom of
      fkMarket, fkMall, fkStall, fkQueryStall:
      begin
        C := clYellow;
        case FItemFrom of
          fkMarket: G.AddSampleLine('[市场]', C);
          fkMall: G.AddSampleLine('[商城]', C);
          fkStall,
          fkQueryStall: G.AddSampleLine('[摊位]', C);
        end;
        APrefix := '出售单价';
        if FGold > 0 then
        begin
          G.AddLine(APrefix, Format('%d%s', [FGold, g_sGoldName]), C);
          APrefix := '';
        end;
        if FGameGold > 0 then
        begin
          G.AddLine(APrefix, Format('%d%s', [FGameGold, g_sGameGoldName]), C);
          APrefix := '    ';
        end;
        if FGamePoint > 0 then
        begin
          G.AddLine(APrefix, Format('%d%s', [FGamePoint, g_sGamePointName]), C);
          APrefix := '';
        end;

        if FItemFrom = fkQueryStall then
          G.AddSampleLine('<点击购买>', clYellow);
      end;
      fkStallBuy, fkQueryStallBuy:
      begin
        C := clYellow;
        G.AddSampleLine('[摊位]', clYellow);
        APrefix := '收购单价';
        if FGold > 0 then
        begin
          G.AddLine(APrefix, Format('%d%s', [FGold, g_sGoldName]), C);
          APrefix := '';
        end;
        if FGameGold > 0 then
        begin
          G.AddLine(APrefix, Format('%d%s', [FGameGold, g_sGameGoldName]), C);
          APrefix := '';
        end;
        if FGamePoint > 0 then
        begin
          G.AddLine(APrefix, Format('%d%s', [FGamePoint, g_sGamePointName]), C);
          APrefix := '';
        end;
        if FCount > 0 then
          G.AddLine('收购数量', IntToStr(FCount), C);
        if FItemFrom = fkQueryStallBuy then
          G.AddSampleLine('<拿起背包物品点击本物品可出售>', clYellow);
      end;
    end;
  end;

  procedure LoadBindProp(G: TItemInfoDrawGroup);
  const
    SBind: array [1 .. 8] of string = ('永不掉落', '不可修理', '不可存仓', '离线消失', '死亡消失', '不可丢弃', '穿戴后绑定到人物', '穿戴后无法取下');
  var
    I, c: Integer;
    Line: String;
    LS: TStrings;
  begin
    if g_UIManager.Form.HintEditor.Bind.Visible then
    begin
      Line := '';
      c := 0;
      LS := TStringList.Create;
      try
        for I := 1 to 6 do
          if SetContain(FBindState, I) then
            LS.Add(SBind[I]);
        if LS.Count > 0 then
        begin
          if LS.Count > 2 then
          begin
            for I := 0 to (LS.Count div 2) - 1 do
            begin
              G.AddSampleLine(LS[0] + '  ' + LS[1], g_UIManager.Form.HintEditor.Bind.Color);
              LS.Delete(0);
              LS.Delete(0);
            end;
            if LS.Count > 0 then
              G.AddSampleLine(LS[0], g_UIManager.Form.HintEditor.Bind.Color);
          end
          else
          begin
            for I := 0 to LS.Count - 1 do
              G.AddSampleLine(LS[I], g_UIManager.Form.HintEditor.Bind.Color);
          end;
        end;
      finally
        FreeAndNilEx(LS);
      end;
      if SetContain(FBindState, 7) then
        G.AddSampleLine(SBind[7], g_UIManager.Form.HintEditor.Bind.Color);
      if SetContain(FBindState, 8) then
        G.AddSampleLine(SBind[8], g_UIManager.Form.HintEditor.Bind.Color);
      if FStdItem.State.AutoBindAfterTakeOn and (not SetContain(FBindState, _ITEM_STATE_BIND)) then
        G.AddSampleLine(g_UIManager.Form.HintEditor.Bind.UsedBindCaption, g_UIManager.Form.HintEditor.Bind.UsedBindColor);
    end;
  end;

  procedure LoadBindDateProp(G: TItemInfoDrawGroup);
  begin
    if g_UIManager.Form.HintEditor.LimitDate.Visible then
    begin
      if FMaxDate > 0 then
      begin
        if (FMaxDate < Now) or (DateUtils.DaysBetween(Now, FMaxDate) <= 1) then
          G.AddLine(g_UIManager.Form.HintEditor.LimitDate.Caption, FormatDateTime('yyyy-MM-dd hh:mm', FMaxDate), g_UIManager.Form.HintEditor.LimitDate.LimitColor)
        else
          G.AddLine(g_UIManager.Form.HintEditor.LimitDate.Caption, FormatDateTime('yyyy-MM-dd hh:mm', FMaxDate), g_UIManager.Form.HintEditor.LimitDate.Color);
      end;
    end;
  end;

  procedure AddStdMode25(G: TItemInfoDrawGroup);
  begin
    AddTypeName(G);
    AddNeedLevel(G);
    AddWeight(G);
    G.AddLine('次数', GetDura100Str(FDura, FDuraMax), clLime);
  end;

  procedure AddInfoStdMode29(G: TItemInfoDrawGroup);
  begin
    AddTypeName(G);
    AddWeight(G);
  end;

  procedure AddStdMode29(G: TItemInfoDrawGroup);
  var
    ADisplay: String;
  begin
    ADisplay := GetHoleDisplayValue(FStdItem.ACMin, FStdItem.ACMax);
    if ADisplay <> '' then
      G.AddSampleLine(ADisplay, clLime);

    ADisplay := GetHoleDisplayValue(FStdItem.MACMin, FStdItem.MACMax);
    if ADisplay <> '' then
      G.AddSampleLine(ADisplay, clLime);

    ADisplay := GetHoleDisplayValue(FStdItem.DCMin, FStdItem.DCMax);
    if ADisplay <> '' then
      G.AddSampleLine(ADisplay, clLime);

    ADisplay := GetHoleDisplayValue(FStdItem.MCMin, FStdItem.MCMax);
    if ADisplay <> '' then
      G.AddSampleLine(ADisplay, clLime);

    ADisplay := GetHoleDisplayValue(FStdItem.SCMin, FStdItem.SCMax);
    if ADisplay <> '' then
      G.AddSampleLine(ADisplay, clLime);

    AddItemCaptionAndText(G);
  end;

  procedure AddStdMode40(G: TItemInfoDrawGroup);
  begin
    AddTypeName(G);
    AddWeight(G);
    G.AddLine('品质', IntToStr(FDura div 1000), clLime);
  end;

  procedure AddStdMode42(G: TItemInfoDrawGroup);
  begin
    AddTypeName(G);
    AddWeight(G);
    if FDura > 1 then
      AddCount(G);
  end;

  procedure AddStdMode43(G: TItemInfoDrawGroup);
  begin
    AddTypeName(G);
    AddWeight(G);
    G.AddLine('纯度', IntToStr(FDura div 1000), clLime);
  end;

  procedure AddStdMode31(G: TItemInfoDrawGroup);
  var
    UnbindItem: pTStdItem;
  begin
    AddTypeName(G);
    AddNeedLevel(G);
    AddWeight(G);
    if FStdItem.AniCount = 1 then
    begin
      UnbindItem  :=  g_ItemList.Items[FStdItem.ACMin + 1];
      if UnbindItem <> nil then
      begin
        G.AddSampleLine('', 0).Height :=  4;
        G.AddSampleLine(Format('内含 %s x%d', [UnbindItem.Name, FStdItem.MACMin]), clLime);
      end;
    end;
    if FDura > 0 then
      G.AddLine('剩余使用次数', Format('%d/%d', [FDura, FDuraMax]), clLime);
  end;

  procedure AddStdMode32(G: TItemInfoDrawGroup);
  begin
    AddTypeName(G);
    AddNeedLevel(G);
    AddWeight(G);
    if (FAddHold[0]>0) then
    begin
      G.AddSampleLine(Format('%s(%d:%d)', [FPropLine, FAddHold[1], FAddHold[2]]), clLime);
      G.AddLine('次数', GetDuraStr(FDura, FDuraMax), clLime);
    end
    else
      G.AddSampleLine(FPropLine, clLime);
  end;

  procedure AddStdMode34(G: TItemInfoDrawGroup);
  begin
    AddTypeName(G);
    AddNeedLevel(G);
    AddWeight(G);
    if (FItemFrom = fkMarket) or (FItemFrom = fkShowCommondE) then
      G.AddSampleLine(Format('可储存经验%d万', [FDuraMax]), clLime)
    else
    begin
      if FDura = FDuraMax then
        G.AddSampleLine(Format('已蓄满经验%d万 双击释放', [FDuraMax]), clLime)
      else
      begin
        G.AddSampleLine(Format('聚集经验 %d/%d万', [FDura, FDuraMax]), clLime);
        if FStdItem.AniCount > 0 then
          G.AddSampleLine(Format('%d小时后停止累积经验', [FStdItem.AniCount * 24]), clYellow);
      end;
    end;
  end;

  procedure AddHorseInfo(G: TItemInfoDrawGroup);
  begin
    AddTypeName(G);
    AddNeedLevel(G);
    AddWeight(G);
  end;

  procedure AddStdMode35(G: TItemInfoDrawGroup);
  begin
    AddAC(G);
    AddMAC(G);
    AddDC(G);
    AddMC(G);
    AddSC(G);
    AddTC(G);
    AddPC(G);
    AddWC(G);
    if FStdItem.Reserved > 0 then
      G.AddLine('负重', IntToStr(FStdItem.Reserved));
    if FStdItem.AniCount > 0 then
      G.AddLine('体力值', IntToStr(FStdItem.AniCount * 10));
    if FStdItem.Source > 0 then
      G.AddLine('魔力值', IntToStr(FStdItem.Source * 10));
    if (FDuraMax > 0) and (FDura / FDuraMax > 0.1) then
      G.AddLine('体力', Format('%d/%d', [FDura, FDuraMax]), clLime)
    else
      G.AddLine('体力', Format('%d/%d', [FDura, FDuraMax]), clRed);

    AddItemCaptionAndText(G);
  end;

  procedure AddDefault(G: TItemInfoDrawGroup);
  begin
    AddTypeName(G);
    AddWeight(G);
  end;

  procedure AddMixedAbility(G: TItemInfoDrawGroup);
  var
    S: String;
  begin
    if g_UIManager.Form.HintEditor.MixedAbility.Visible and (g_UIManager.Form.HintEditor.MixedAbility.Caption <> '') then
    begin
      S := g_UIManager.Form.HintEditor.MixedAbility.Caption;
      S := StringReplace(S, '#战力#', IntToStr(FTotalAbility), [rfReplaceAll]);
      G.AddSampleLine(S, g_UIManager.Form.HintEditor.MixedAbility.Color);
    end;
  end;

var
  G, G1: TItemDrawGroup;
  Bind: Boolean;
  _Pos: Integer;
  ALine: TDrawItemLine;
  S: String;
begin
  case FItemIndex of
    -8..-2:
    begin
      FHasStart :=  False;
      FHasHole  :=  False;
      G :=  TItemNameDrawGroup.Create(Self, FName);
      FGroups.Add(G);
      G := TItemInfoDrawGroup.Create(Self);
      AddCount(G as TItemInfoDrawGroup);
      FGroups.Add(G);
    end
    else
    begin
      FHasStart :=  g_boUpgradeEnabled and g_UIManager.Form.HintEditor.ShowStar and IsEquipItem(FStdItem) and (FAddProperty.MaxUpgrade > 0);
      FHasHole  :=  g_boHoleEnabled and IsEquipItem(FStdItem) and (FAddHold[0] >= 0);
      G :=  TItemNameDrawGroup.Create(Self, FName);
      FGroups.Add(G);
      if FHasStart then
      begin
        FStartDrawGroup :=  TItemStarDrawGroup.Create(Self, Round(FAddProperty.Upgrade/g_btHowUpgradeOneStar), Round(FAddProperty.MaxUpgrade/g_btHowUpgradeOneStar));
        FGroups.Add(FStartDrawGroup);
      end;

      G := TItemInfoDrawGroup.Create(Self);
      FGroups.Add(G);
      case FStdItem.StdMode of
        0:    AddStdMode0(G as TItemInfoDrawGroup);
        1:    AddStdMode1(G as TItemInfoDrawGroup);
        2:    AddStdMode2(G as TItemInfoDrawGroup);
        3:    AddStdMode3(G as TItemInfoDrawGroup);
        4:    AddStdMode4(G as TItemInfoDrawGroup);
        5,6:  AddInfoStdMode56(G as TItemInfoDrawGroup);
        7:    AddInfoStdMode7(G as TItemInfoDrawGroup);
        8:    AddStdMode8(G as TItemInfoDrawGroup);
        10:   AddInfoStdMode1011(G as TItemInfoDrawGroup, True);
        11:   AddInfoStdMode1011(G as TItemInfoDrawGroup, False);
        17:   AddInfoStdMode1718(G as TItemInfoDrawGroup, True);
        18:   AddInfoStdMode1718(G as TItemInfoDrawGroup, False);
        25:   AddStdMode25(G as TItemInfoDrawGroup);
        15, 16,// 头盔,捧备
        19, 20, 21, // 项链
        22, 23, // 戒指
        24, 26, // 手镯
        27, // 鞋
        28,// 腰带
        30: //勋章
          AddInfoEq(G as TItemInfoDrawGroup);
        29: AddInfoStdMode29(G as TItemInfoDrawGroup);//宝石
        31: AddStdMode31(G as TItemInfoDrawGroup);
        32: AddStdMode32(G as TItemInfoDrawGroup);
        34: AddStdMode34(G as TItemInfoDrawGroup);
        35: AddHorseInfo(G as TItemInfoDrawGroup);
        40: AddStdMode40(G as TItemInfoDrawGroup);
        42: AddStdMode42(G as TItemInfoDrawGroup);
        43: AddStdMode43(G as TItemInfoDrawGroup);
        else
          AddDefault(G as TItemInfoDrawGroup);
      end;

      if not G.HasItem then
      begin
        FGroups.Remove(G);
        FreeAndNilEx(G);
      end;

       if SoulEnabled then
      begin
        if IsEquipItem(FStdItem) and (FSoulMaxExp>0) and (FAddProperty.SoulLevel - 1 < ClientConf.nMaxSoulLevel) then
        begin
          G := TItemSoulDrawGroup.Create(Self, FSoulExp, FSoulMaxExp);
          FGroups.Add(G);
        end;
      end;

      if IsEquipItem(FStdItem) then
      begin
        if g_UIManager.Form.HintEditor.Standard.Visible then
        begin
          G := TItemInfoDrawGroup.Create(Self);
          case FStdItem.StdMode of
            5,6:  AddStdMode56(G as TItemInfoDrawGroup);
            10:   AddStdMode1011(G as TItemInfoDrawGroup, True);
            11:   AddStdMode1011(G as TItemInfoDrawGroup, False);
            7,
            8,
            15, 16,// 头盔,捧备
            17,18,
            19, 20, 21, // 项链
            22, 23, // 戒指
            24, 26, // 手镯
            27, // 鞋
            28,// 腰带
            30,68: //勋章
              AddEq(G as TItemInfoDrawGroup);
            29: AddStdMode29(G as TItemInfoDrawGroup);//宝石
            35: AddStdMode35(G as TItemInfoDrawGroup);
          end;
          if G.HasItem then
          begin
            if g_UIManager.Form.HintEditor.Standard.Caption <> '' then
            begin
              ALine :=  TDrawItemLine.Create;
              TItemInfoDrawGroup(G).FLines.Insert(0, ALine);
              ALine.Caption := g_UIManager.Form.HintEditor.Standard.Caption;
              ALine.clCaption := g_UIManager.Form.HintEditor.Standard.Color;
              ALine.Height := 15;
              ALine.LineType := ltSample;
              TItemInfoDrawGroup(G).AddSplitlLineFirst(10);
            end;
            FGroups.Add(G);
          end
          else
            FreeAndNilEx(G);
        end;
      end;

      if g_boAddPointEnabled then
      begin
        if IsEquipItem(FStdItem) then
        begin
          G := TItemInfoDrawGroup.Create(Self);
          AddAddPoint(G as TItemInfoDrawGroup);
          if G.HasItem then
            FGroups.Add(G)
          else
            FreeAndNilEx(G);
        end;
      end;

      if g_boUpgradeEnabled then
      begin
        if IsEquipItem(FStdItem) then
        begin
          G := TItemInfoDrawGroup.Create(Self);
          AddAddLevel(G as TItemInfoDrawGroup);
          if G.HasItem then
            FGroups.Add(G)
          else
            FreeAndNilEx(G);
        end;
      end;

      if IsEquipItem(FStdItem) then
      begin
        if FHasHole then
        begin
          G := TItemHoleDrawGroup.Create(Self);
          FGroups.Add(G);
        end;

        G := TItemInfoDrawGroup.Create(Self);
        AddSuitInfo(G as TItemInfoDrawGroup);
        if G.HasItem then
        begin
          FGroups.Add(G);
          TItemInfoDrawGroup(G).AddSplitlLineFirst(10);

        end
        else
          FreeAndNilEx(G);
      end;

      if IsEquipItem(FStdItem) and (FTotalAbility<>-1) then
      begin
        G := TItemInfoDrawGroup.Create(Self);
        AddMixedAbility(G as TItemInfoDrawGroup);
        FGroups.Add(G);
      end;

      G1 := TItemInfoDrawGroup.Create(Self);
      LoadBindProp(G1 as TItemInfoDrawGroup);
      if G1.HasItem then
      begin
        FGroups.Add(G1);
        Bind := TRUE;
      end
      else
        G1.Free;

      G := TItemInfoDrawGroup.Create(Self);
      LoadBindDateProp(G as TItemInfoDrawGroup);
      if G.HasItem then
      begin
        if Bind then
          G1.Spacing := False;
        FGroups.Add(G);
      end
      else
        FreeAndNilEx(G);

      G := TItemInfoDrawGroup.Create(Self);
      LoadDefaultProp(G as TItemInfoDrawGroup);
      if G.HasItem then
        FGroups.Add(G)
      else
        FreeAndNilEx(G);

      S := FStdItem.sDesc;
      if not (FItemFrom in [fkMarket, fkMall, fkStall, fkQueryStall, fkStallBuy, fkQueryStallBuy]) and (FStdItem.StdMode in [{$I AddinStdmode.INC}]) and (FDura > 1) then
      begin
        if S <> '' then
          S := S + '\';
        S := S + '{S=(提示:Ctrl加鼠标左键拆分)}';
      end;

      if g_UIManager.Form.HintEditor.ItemOutWay.Visible then
      begin
        //添加物品产出来源
        G := TItemInfoDrawGroup.Create(Self);
        ALine :=  TDrawItemLine.Create;
        TItemInfoDrawGroup(G).FLines.Insert(0, ALine);

        ALine.Caption := g_UIManager.Form.HintEditor.ItemOutWay.Caption;
        ALine.clCaption := g_UIManager.Form.HintEditor.ItemOutWay.Color;
        ALine.Height := 15;
        ALine.LineType := ltSample;
        TItemInfoDrawGroup(G).AddSplitlLineFirst(10);

        AddItemWay(G as TItemInfoDrawGroup);
        FGroups.Add(G);
      end;

      if g_UIManager.Form.HintEditor.Desc.Visible and (S <> '') then
      begin
        G := TItemDescDrawGroup.Create(Self, S);
        FGroups.Add(G);
      end;

      if FItemFrom in [fkMarket, fkMall, fkStall, fkQueryStall, fkStallBuy, fkQueryStallBuy] then
      begin
        G := TItemInfoDrawGroup.Create(Self);
        LoadStallItemDesc(G as TItemInfoDrawGroup);
        if G.HasItem then
          FGroups.Add(G)
        else
          FreeAndNilEx(G);
      end;
    end;
  end;
  CalcBounds(MSurface);
end;

function TDrawItemInfo.SoulEnabled: Boolean;
begin
  Result := g_boSoulEnabled;
  if Result then
  begin
    case FStdItem.StdMode of
      5,6:  Result := ClientConf.boSoulOpend[1];
      10,11:  Result := ClientConf.boSoulOpend[2];
      15:  Result := ClientConf.boSoulOpend[0];
      16:  Result := ClientConf.boSoulOpend[8];
      19,20, 21:  Result := ClientConf.boSoulOpend[3];
      22,23:  Result := ClientConf.boSoulOpend[5];
      24,26:  Result := ClientConf.boSoulOpend[4];
      27:  Result := ClientConf.boSoulOpend[6];
      28:  Result := ClientConf.boSoulOpend[7];
      else
        Result := False;
    end;
  end;
end;

procedure TDrawItemInfo.DrawItemTexture(MSurface: TAsphyreCanvas; ALeft: Integer);
var
  I, Y: Integer;
  D: TAsphyreLockableTexture;
begin
  //绘制图形
  MSurface.FillRectAlpha(Bounds(ALeft+2, 2, ItemWidth + 14, ItemHeight + 14), g_UIManager.Form.HintEditor.BgColor, g_UIManager.Form.HintEditor.Alpha);
  Y := 0;
  if g_UIManager.Form.HintEditor.ShowBorder then
    DrawBackGround(MSurface, ALeft);
  if (FItemFrom = fkUse) and g_UIManager.Form.HintEditor.ShowInUseIcon then
  begin
    D := g_77Images.Images[137];
    if D <> nil then
      MSurface.Draw(ALeft + ItemWidth - D.Width + 14, 2, D);
    //MSurface.DrawAlpha(ALeft + 2, 2, D, 175);
  end;
  Y := 8;
  for I := 0 to FGroups.Count - 1 do
  begin
    TItemDrawGroup(FGroups.Items[i]).Draw(MSurface, Y, ALeft, ItemWidth, ItemHeight);
    if g_UIManager.Form.HintEditor.ShowGroupSpace and (I < FGroups.Count) and TItemDrawGroup(FGroups.Items[i]).Spacing then
      Inc(Y, SPACINGHEIGHT);
  end;
end;

{ TDrawShopItemInfo }

constructor TDrawShopItemInfo.Create(AItem: TShopItem);
var
  I: Integer;
begin
  inherited Create;
  FItemIndex  :=  -1;
  FStdItem := AItem.StdItem;
  FLooks := FStdItem.Looks;
  GetItemAddValue(AItem.AddLValue, AItem.AddValue, AItem.AddProperty, FStdItem, g_boEnableItemBasePower);
  FName := FStdItem.Name;
  if ClientConf.boMixedAbility then
    FTotalAbility := AItem.TotalAbility
  else
    FTotalAbility := -1;
  FStdItem.Price  :=  AItem.nPrice;
  FNeed := FStdItem.Need;
  FNeedLevel := FStdItem.NeedLevel;
  if FStdItem.StdMode in [{$I AddinStdmode.INC}] then
    FDura :=  1
  else
    FDura := AItem.StdItem.DuraMax;
  FDuraMax := AItem.StdItem.DuraMax;
  FSoulExp := 0;
  FSoulMaxExp := 0;
  FBindState  :=  AItem.State.Flag;
  Move(AItem.AddLValue[0], FAddLValue[0], SizeOf(TAddValue));
  Move(AItem.AddValue[0], FAddValue[0], SizeOf(TAddValue));
  Move(AItem.AddPoint[0], FAddPoint[0], SizeOf(TAddPoint));
  FAddHold[0] := -1;
  FAddHold[1] := -1;
  FAddHold[2] := -1;
  for I := Low(FAddLevel) to High(FAddLevel) do
    FAddLevel[I].State := 0;
  FMaxDate  :=  0;
  if AItem.Limit <> 0 then
    FMaxDate := IncDay(Now, AItem.Limit);

  ItemWidth := 0;
  ItemHeight := 0;
end;

{ TDrawItemManager }

procedure TDrawItemManager.ChangeXY(X, Y: Integer);
var
  W, H: Integer;
begin
  W := ADrawItemInfo.ItemWidth + 16;
  H := ADrawItemInfo.ItemHeight + 16;
  if ADrawItemInfo1 <> nil then
  begin
    W :=  W + ADrawItemInfo1.ItemWidth + 16;
    H :=  Max(H, ADrawItemInfo1.ItemHeight + 16);
  end;
  if ADrawItemInfo2 <> nil then
  begin
    W :=  W + ADrawItemInfo2.ItemWidth + 16;
    H :=  Max(H, ADrawItemInfo2.ItemHeight + 16);
  end;
  if X + W > SCREENWIDTH then
    Left  :=  Max(0, SCREENWIDTH - W)
  else
    Left  :=  X;
  FScroll := H > SCREENHEIGHT;
  FScrollSize := H - SCREENHEIGHT;
  if Y + H > SCREENHEIGHT then
    Top := Max(0, SCREENHEIGHT - H)
  else
    Top :=  Y;
end;

procedure TDrawItemManager.Clear;
begin
  FInited :=  False;
  if Assigned(ADrawItemInfo) then
    FreeAndNilEx(ADrawItemInfo);
  if Assigned(ADrawItemInfo1) then
    FreeAndNilEx(ADrawItemInfo1);
  if Assigned(ADrawItemInfo2) then
    FreeAndNilEx(ADrawItemInfo2);
end;

constructor TDrawItemManager.Create;
begin
  ADrawItemInfo   :=  nil;
  ADrawItemInfo1  :=  nil;
  ADrawItemInfo2  :=  nil;
  FInited         :=  False;
end;

destructor TDrawItemManager.Destroy;
begin
  Clear;
  inherited;
end;

procedure TDrawItemManager.BeginDrawScreen(Device: TAsphyreDevice; MSurface: TAsphyreCanvas);
begin
  if g_boLockUpdate then Exit;
  if ADrawItemInfo = nil then Exit;

  if not FInited then
  begin
    try
      if FTargetTexture <> nil then
        FreeAndNilEx(FTargetTexture);
      FScrollPosition := 0;
      Init(Self);
      FTargetTexture := Factory.CreateRenderTargetTexture;
      FTargetTexture.Format := apf_A8R8G8B8;
      FTargetTexture.SetSize(Width + 16, Height + 16, True);
      Device.RenderTo(DrawTarget, 0, True, FTargetTexture);
      FScrollTime := GetTickCount;
      if Assigned(FOnInited) then
        FOnInited(Self);
    except
    end;
    FInited :=  True;
  end;
  ChangeXY(Left, Top);
end;

procedure TDrawItemManager.Draw(MSurface: TAsphyreCanvas);
begin
  if FScroll then
  begin
    if GetTickCount - FScrollTime > 150 then
    begin
      if FScrollTop then
      begin
        Inc(FScrollPosition);
        if FScrollPosition >= FScrollSize then
        begin
          FScrollPosition := FScrollSize;
          FScrollTop := False;
        end;
      end
      else
      begin
        Dec(FScrollPosition);
        if FScrollPosition < 0 then
        begin
          FScrollPosition := 0;
          FScrollTop := True;
        end;
      end;
    end;
  end;

  Draw(MSurface, Left, Top - FScrollPosition);
end;

procedure TDrawItemManager.Draw(MSurface: TAsphyreCanvas; X, Y: Integer);
begin
  if g_boLockUpdate then Exit;
  if ADrawItemInfo = nil then Exit;

  MSurface.Draw(X, Y, FTargetTexture);
end;

function TDrawItemManager.InRealArea(X, Y: Integer): Boolean;
begin
  Result := False;
  if (X >= 0) and (X <= ADrawItemInfo.ItemWidth) then
    Result := (Y >= 0) and (Y <= ADrawItemInfo.ItemHeight)
  else if (ADrawItemInfo1 <> nil) and (X >= ADrawItemInfo.ItemWidth + 16) and (X <= ADrawItemInfo.ItemWidth + 16 + ADrawItemInfo1.ItemWidth) then
    Result := (Y >= 0) and (Y <= ADrawItemInfo1.ItemHeight)
  else if (ADrawItemInfo2 <> nil) and (X >= ADrawItemInfo.ItemWidth + 16 + ADrawItemInfo1.ItemWidth + 16) and (X <= ADrawItemInfo.ItemWidth + 16 + ADrawItemInfo1.ItemWidth + 16 + ADrawItemInfo2.ItemWidth) then
    Result := (Y >= 0) and (Y <= ADrawItemInfo2.ItemHeight)
end;

procedure TDrawItemManager.Init(Sender: TObject);
begin
  ADrawItemInfo.Init(g_GameCanvas);
  if ADrawItemInfo1 <> nil then
    ADrawItemInfo1.Init(g_GameCanvas);
  if ADrawItemInfo2 <> nil then
    ADrawItemInfo2.Init(g_GameCanvas);
end;

procedure TDrawItemManager.DrawTarget(Sender: TObject);
begin
  ADrawItemInfo.DrawItemTexture(g_GameCanvas, 0);
  if ADrawItemInfo1 <> nil then
    ADrawItemInfo1.DrawItemTexture(g_GameCanvas, ADrawItemInfo.ItemWidth + 16);
  if ADrawItemInfo2 <> nil then
    ADrawItemInfo2.DrawItemTexture(g_GameCanvas, ADrawItemInfo.ItemWidth + ADrawItemInfo1.ItemWidth + 32);
end;

function TDrawItemManager.GetWidth: Integer;
begin
  Result := ADrawItemInfo.ItemWidth + 16;
  if ADrawItemInfo1 <> nil then
    Result := Result + ADrawItemInfo1.ItemWidth + 16;
  if ADrawItemInfo2 <> nil then
    Result := Result + ADrawItemInfo2.ItemWidth + 16;
end;

function TDrawItemManager.GetHeight: Integer;
begin
  Result := ADrawItemInfo.ItemHeight;
  if (ADrawItemInfo1 <> nil) and (Result < ADrawItemInfo1.ItemHeight) then
    Result := ADrawItemInfo1.ItemHeight;
  if (ADrawItemInfo2 <> nil) and (Result < ADrawItemInfo2.ItemHeight) then
    Result := ADrawItemInfo2.ItemHeight;
end;

{ TItemDrawGroup }

constructor TItemDrawGroup.Create(ADrawItemInfo: TDrawItemInfo);
begin
  FDrawItemInfo := ADrawItemInfo;
  Width := 0;
  Height := 0;
  Spacing := TRUE;
end;

procedure TItemDrawGroup.Draw(ISurface: TAsphyreCanvas; var Y: Integer;
  const ALeft, HintW, HintH: Integer);
begin
  Inc(Y, Height);
end;

function TItemDrawGroup.GetHasItem: Boolean;
begin
  Result := TRUE;
end;

{ TItemNameDrawGroup }

procedure TItemNameDrawGroup.Calc(ISurface: TAsphyreCanvas);
var
  AName: String;
begin
  inherited;
  AName := GetDisplayText;
  if g_boUpgradeEnabled and (FDrawItemInfo.FAddProperty.MaxUpgrade > 0) and IsEquipItem(FDrawItemInfo.FStdItem) then
    AName := AName + Format(' (%d/%d)', [FDrawItemInfo.FAddProperty.Upgrade, FDrawItemInfo.FAddProperty.MaxUpgrade]);
  if g_UIManager.Form.HintEditor.ShowIcon then
  begin
    Height := 50;
    if SetContain(FDrawItemInfo.FBindState, _ITEM_STATE_BIND) then
      Width := FontManager.Default.TextWidth(g_UIManager.Form.HintEditor.BindValue) + 62;
    Width := Max(Width, FontManager.Default.TextWidth(AName) + 62);
  end
  else
  begin
    Height := 15;
    if SetContain(FDrawItemInfo.FBindState, _ITEM_STATE_BIND) then
      Height := 30;
    if SetContain(FDrawItemInfo.FBindState, _ITEM_STATE_BIND) then
      Width := FontManager.Default.TextWidth(g_UIManager.Form.HintEditor.BindValue);
    Width := Max(Width, FontManager.Default.TextWidth(AName));
  end;

  FDrawItemInfo.MaxLineWidth  :=  Max(FDrawItemInfo.MaxLineWidth, Width);
end;

constructor TItemNameDrawGroup.Create(ADrawItemInfo: TDrawItemInfo;
  const AName: String);
begin
  inherited Create(ADrawItemInfo);
  FNameColor := clWhite;
  if FDrawItemInfo.FAddProperty.Color <> 0 then
    FNameColor := GetRGB(FDrawItemInfo.FAddProperty.Color)
  else if (FDrawItemInfo.FStdItem.Name <> '') and (FDrawItemInfo.FStdItem.Color > 0) then
    FNameColor := GetRGB(FDrawItemInfo.FStdItem.Color);
  FName := AName;

  FUpgradeDesc := g_UIManager.Form.HintEditor.ItemUpgradeDesc.Caption;
  FUpgradeDesc := StringReplace(FUpgradeDesc,'#已强化次数#',IntToStr(ADrawItemInfo.FAddProperty.Upgrade),[rfReplaceAll]);
  FUpgradeDesc := StringReplace(FUpgradeDesc,'#可强化次数#',IntToStr(ADrawItemInfo.FAddProperty.MaxUpgrade),[rfReplaceAll]);
  FUpgradeDescColor := g_UIManager.Form.HintEditor.ItemUpgradeDesc.Color;
  FShowUpgrade := g_UIManager.Form.HintEditor.ItemUpgradeDesc.Visible;
  Spacing := False;
  FNodes := TList.Create;
  Parse;
end;

destructor TItemNameDrawGroup.Destroy;
var
  I: Integer;
begin
  for I := 0 to FNodes.Count - 1 do
    TNameNode(FNodes[I]).Free;
  FreeAndNilEx(FNodes);
  inherited;
end;

procedure TItemNameDrawGroup.Draw(ISurface: TAsphyreCanvas; var Y: Integer;
  const ALeft, HintW, HintH: Integer);
var
  d: TAsphyreLockableTexture;
  OX, OY, NameX: Integer;
  AName: String;
  I: Integer;
begin
  AName := GetDisplayText;
  if SetContain(FDrawItemInfo.FBindState, _ITEM_STATE_BIND) then
    OY := Round((Height - FontManager.Default.TextHeight(AName) * 2 - 2) / 2)
  else
    OY := Round((Height - FontManager.Default.TextHeight(AName)) / 2);

  OX := 0;
  NameX := 8;
  if g_UIManager.Form.HintEditor.ShowIcon then
    NameX := 62;
  NameX := NameX + ALeft;
  for I := 0 to FNodes.Count - 1 do
  begin
    ISurface.BoldText(NameX + OX, Y + OY, TNameNode(FNodes[I]).S, TNameNode(FNodes[I]).Color, FDrawItemInfo.FBGColor);
    OX := OX + FontManager.Default.TextWidth(TNameNode(FNodes[I]).S);
  end;

  //显示强化次数
  if FShowUpgrade and (FDrawItemInfo.FAddProperty.MaxUpgrade > 0) then
    ISurface.BoldText(NameX + OX, Y + OY, FUpgradeDesc, FUpgradeDescColor, FDrawItemInfo.FBGColor);

  if SetContain(FDrawItemInfo.FBindState, _ITEM_STATE_BIND) then
  begin
    ISurface.BoldText(NameX, Y + OY + FontManager.Default.TextHeight(FName) + 2, g_UIManager.Form.HintEditor.BindValue, g_UIManager.Form.HintEditor.BindColor, FDrawItemInfo.FBGColor);
  end;

  if g_UIManager.Form.HintEditor.ShowIcon then
  begin
    D := g_77Images.Images[138];
    if D <> nil then
      ISurface.Draw(ALeft + 8, 8, D);
    D := nil;
    case FDrawItemInfo.FItemIndex of
      -2: D :=  g_WBagItemImages.Images[1186];
      -3: D :=  g_WBagItemImages.Images[1185];
      -4: D :=  g_WBagItemImages.Images[2155];
      -5: D :=  g_WBagItemImages.Images[2156];
      -6: D :=  g_WBagItemImages.Images[1189];
      -7: D :=  g_WBagItemImages.Images[1187];
      -8: D :=  g_WBagItemImages.Images[122];
      else
      begin
//        if FDrawItemInfo.FStdItem.Looks > 9999 then
//          D :=  g_77WBagItemImages.Images[FDrawItemInfo.FStdItem.Looks - 10000]
//        else
//          D :=  g_WBagItemImages.Images[FDrawItemInfo.FStdItem.Looks];
        if FDrawItemInfo.FLooks > 9999 then
          D :=  g_77WBagItemImages.Images[FDrawItemInfo.FLooks - 10000]
        else
          D :=  g_WBagItemImages.Images[FDrawItemInfo.FLooks];
      end;
    end;
    if D <> nil then
      ISurface.Draw(ALeft + 31 - D.Width div 2, Y + 23 - D.Height div 2, D);
  end;
  inherited;
end;

function TItemNameDrawGroup.GetDisplayText: String;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to FNodes.Count - 1 do
    Result := Result + TNameNode(FNodes[I]).S;
end;

procedure TItemNameDrawGroup.AddStrNode(const Value: String);
var
  AStrNode: TNameNode;
begin
  AStrNode := TNameNode.Create;
  AStrNode.S := Value;
  AStrNode.Color := FNameColor;
  FNodes.Add(AStrNode);
end;

procedure TItemNameDrawGroup.AddPropNode(const Prop: String);
var
  APropNode: TNameNode;
  LS: TStrings;
  AProp, AValue: String;
  I: Integer;
begin
  APropNode := TNameNode.Create;
  APropNode.Color := FNameColor;
  LS  :=  TStringList.Create;
  try
    ExtractStrings([';'], [], PChar(Prop), LS);
    for I := 0 to LS.Count - 1 do
    begin
      AProp   :=  UpperCase(LS.Names[I]);
      AValue  :=  LS.ValueFromIndex[I];
      if AProp <> '' then
      begin
        case AProp[1] of
          'S': APropNode.S := AValue;
          'C':
          begin
            APropNode.Color := M2StrToColor(AValue);
          end;
        end;
      end;
    end;
    if APropNode.S<>'' then
      FNodes.Add(APropNode)
    else
      FreeAndNilEx(APropNode);
  finally
    FreeAndNilEx(LS);
  end;
end;

procedure TItemNameDrawGroup.Parse;
var
  _Len, _Pos: Integer;
  AChr: Char;
  ANodeStr: String;
  APropFounded: Boolean;
begin
  _Len  :=  Length(FName);
  _Pos  :=  1;
  ANodeStr  :=  '';
  repeat
    AChr  :=  FName[_Pos];
    case AChr of
      '{':
      begin
        if ANodeStr <> '' then
        begin
          AddStrNode(ANodeStr);
          ANodeStr  :=  '';
        end;
        Inc(_Pos);
        APropFounded  :=  False;
        repeat
          AChr  :=  FName[_Pos];
          if AChr = '}' then
          begin
            APropFounded  :=  True;
            Break;
          end
          else
            ANodeStr  :=  ANodeStr + AChr;
          Inc(_Pos);
        until _Pos > _Len;
        if APropFounded then
          AddPropNode(ANodeStr);
        ANodeStr  :=  '';
      end
      else
      begin
        ANodeStr  :=  ANodeStr + AChr;
      end;
    end;
    Inc(_Pos);
  until _Pos > _Len;
  if ANodeStr <> '' then
    AddStrNode(ANodeStr);
end;

{TuDescLine}
constructor TuDescLine.Create;
begin
  Items :=  TList<TuDescLineItem>.Create;
end;

destructor TuDescLine.Destroy;
var
  I: Integer;
begin
  for I := 0 to Items.Count - 1 do
    Items.Items[I].Free;
  FreeAndNilEx(Items);
  inherited;
end;

function TuDescLine.Add(const Data: String; FontColor: TColor): TuDescLineItem;
begin
  Result  :=  TuDescLineItem.Create;
  Items.Add(Result);
  Result.FontColor  :=  FontColor;
  Result.OffsetX    :=  0;
  Result.Width      :=  0;
  Result.Data       :=  Data;
end;

type
  TDescProperty = class
    Color: TColor;
    Data: String;
  end;

  TDescChrItem = class
  public
    C: Char;
    Width: Integer;
    Prop: TDescProperty;
  end;

  TDescParser = class
  private
    FCanvas: TAsphyreCanvas;
    FList: TList<TDescChrItem>;
    FProperties: TList<TDescProperty>;
    function CreateProperty: TDescProperty;
    function AddChar(const C: Char): TDescChrItem;
    procedure AddSpliter;
    procedure AddProperty(const PropStr: String; AProperty: TDescProperty);
    procedure ExtractString(const Text: String; Size: Integer; var Start: Integer; var Value: String; const Spliter: Char);
    procedure Parse(const Data: String);
    procedure ExtractTexts(List: TList<TuDescLine>; Width: Integer);

    constructor Create(ACanvas: TAsphyreCanvas);
    destructor Destroy; override;
  end;

constructor TDescParser.Create(ACanvas: TAsphyreCanvas);
begin
  FCanvas := ACanvas;
  FList :=  TList<TDescChrItem>.Create;
  FProperties :=  TList<TDescProperty>.Create;
end;

destructor TDescParser.Destroy;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    FList.Items[I].Free;
  FreeAndNilEx(FList);
  for I := 0 to FProperties.Count - 1 do
    FProperties.Items[I].Free;
  FreeAndNilEx(FProperties);
  inherited;
end;

function TDescParser.CreateProperty: TDescProperty;
begin
  Result := TDescProperty.Create;
  Result.Color := g_UIManager.Form.HintEditor.Desc.Color;
  FProperties.Add(Result);
end;

procedure TDescParser.ExtractString(const Text: String; Size: Integer; var Start: Integer; var Value: String; const Spliter: Char);
var
  C: Char;
begin
  Inc(Start);
  Value :=  '';
  while Start < Size do
  begin
    C :=  Text[Start];
    if C <> Spliter then
      Value :=  Value + C
    else
      Break;
    Inc(Start);
  end
end;

function TDescParser.AddChar(const C: Char): TDescChrItem;
begin
  Result :=  TDescChrItem.Create;
  Result.C :=  C;
  Result.Width :=  FontManager.Default.TextWidth(C);
  Result.Prop  :=  nil;
  FList.Add(Result);
end;

procedure TDescParser.AddProperty(const PropStr: String; AProperty: TDescProperty);
var
  APropName,
  APropValue: String;
  APropLS: TStrings;
  I: Integer;
begin
  APropLS :=  TStringList.Create;
  try
    ExtractStrings([';'], [], PChar(PropStr), APropLS);
    for I := 0 to APropLS.Count - 1 do
    begin
      APropName :=  UpperCase(APropLS.Names[I]);
      APropValue:=  APropLS.ValueFromIndex[I];
      if (APropName<>'') and (APropValue<>'') then
      begin
        case APropName[1] of
          'C': AProperty.Color :=  M2StrToColor(APropValue);
          'S':  AProperty.Data  :=  ConvertMaskString(APropValue);
        end;
      end;
    end;
    if AProperty.Data <> '' then
      for I := 1 to Length(AProperty.Data) do
        AddChar(AProperty.Data[I]).Prop  :=  AProperty;
  finally
    FreeAndNilEx(APropLS);
  end;
end;

procedure TDescParser.AddSpliter;
begin
  FList.Add(nil);
end;

procedure TDescParser.Parse(const Data: String);
var
  Size, I: Integer;
  C: Char;
  ANodeStr: String;
  AProp: TDescProperty;
begin
  Size    :=  Length(Data);
  I       :=  0;
  while I < Size do
  begin
    Inc(I);
    C :=  Data[I];
    case C of
      '{':
        begin
          ANodeStr  :=  '';
          ExtractString(Data, Size, I, ANodeStr, '}');
          AProp :=  CreateProperty;
          AddProperty(ANodeStr, AProp);
        end;
        '\':
        begin
          AddSpliter;
        end
      else
        AddChar(C);
    end;
  end;
end;

procedure TDescParser.ExtractTexts(List: TList<TuDescLine>; Width: Integer);
var
  I, AWidth: Integer;
  ALine: TuDescLine;
  AItem: TuDescLineItem;
  APrChar, ACurChr: TDescChrItem;
begin
  I       :=  0;
  AWidth  :=  0;
  ALine   :=  nil;
  APrChar :=  nil;
  ACurChr :=  nil;
  while I < FList.Count do
  begin
    APrChar :=  ACurChr;
    ACurChr :=  FList.Items[I];
    if ACurChr <> nil then
    begin
      if (APrChar=nil) or (AWidth + ACurChr.Width > Width) then
      begin
        ALine :=  TuDescLine.Create;
        ALine.Width :=  0;
        AItem :=  nil;
        List.Add(ALine);
        AWidth  :=  0;
      end;
      if (AItem=nil) or (APrChar.Prop <> ACurChr.Prop) then
      begin
        AItem :=  TuDescLineItem.Create;
        ALine.Items.Add(AItem);
        if ACurChr.Prop <> nil then
        begin
          AItem.FontColor :=  ACurChr.Prop.Color;
        end
        else
          AItem.FontColor :=  g_UIManager.Form.HintEditor.Desc.Color;
      end;
      AItem.Data  :=  AItem.Data + ACurChr.C;
      AItem.Width :=  AItem.Width + ACurChr.Width;
      Inc(AWidth, ACurChr.Width);
      ALine.Width :=  ALine.Width + ACurChr.Width;
    end;
    Inc(I);
  end;
end;

{ TItemDescDrawGroup }

procedure TItemDescDrawGroup.Calc(ISurface: TAsphyreCanvas);
var
  ALine: TuDescLine;
  AParser: TDescParser;
  I: Integer;
begin
  Height  := 5;
  Width   := Max(FDrawItemInfo.MaxLineWidth, 180);
  AParser := TDescParser.Create(ISurface);
  try
    AParser.Parse(FDesc);
    AParser.ExtractTexts(Lines, Width);
    Inc(Height, (FontManager.Default.TextHeight('AH')+2) * Lines.Count - 2);
    Width := 0;
    for I := 0 to Lines.Count - 1 do
    begin
      if Lines[I].Width > Width then
        Width := Lines[I].Width;
    end;
  finally
    AParser.Free;
  end;
end;

constructor TItemDescDrawGroup.Create(ADrawItemInfo: TDrawItemInfo;
  const ADesc: String);
begin
  inherited Create(ADrawItemInfo);
  Lines :=  TList<TuDescLine>.Create;
  FDesc :=  ADesc;
end;

destructor TItemDescDrawGroup.Destroy;
var
  I: Integer;
begin
  for I := 0 to Lines.Count - 1 do
    Lines.Items[I].Free;
  FreeAndNilEx(Lines);
  inherited;
end;

procedure TItemDescDrawGroup.Draw(ISurface: TAsphyreCanvas; var Y: Integer;
  const ALeft, HintW, HintH: Integer);
var
  ALine: TuDescLine;
  I: Integer;
  J: Integer;
  X: Integer;
  H: Integer;
begin
  Inc(Y, 5);
  H :=  FontManager.Default.TextHeight('H');
  for I := 0 to Lines.Count - 1 do
  begin
    ALine :=  Lines.Items[I];
    X :=  ALeft + 8;
    for J := 0 to ALine.Items.Count - 1 do
    begin
      ISurface.BoldText(X, Y, ALine.Items[J].Data, ALine.Items[J].FontColor, FontBorderColor);
      X :=  X + ALine.Items[J].Width;
    end;
    Y :=  Y + H + 2;
  end;
end;

{ TItemInfoDrawGroup }

function TItemInfoDrawGroup.AddLine(const ACaption, AValue: String;
  const DefColor: TColor): TDrawItemLine;
begin
  Result := TDrawItemLine.Create;
  Result.Caption := ACaption;
  Result.Value := AValue;
  Result.Extend := '';
  Result.clCaption := DefColor;
  Result.clValue := DefColor;
  Result.clExtend := $66CCFF;
  Result.Height := 15;
  Result.LineType := ltNormal;
  FLines.Add(Result);
end;

function TItemInfoDrawGroup.AddSampleLine(const ACaption: String;
  const DefColor: TColor): TDrawItemLine;
begin
  Result := AddLine(ACaption, '', DefColor);
  //Result.Sample := TRUE;
  Result.LineType := ltSample;
end;

function TItemInfoDrawGroup.AddSplitlLine(nHeight : Integer = 0):TDrawItemLine;
var
  D : TAsphyreLockableTexture;
begin
  D := g_77Images.Images[521];
  Result := AddLine('', '', clwhite);
  if nHeight <> 0 then
    Result.Height := nHeight
  else
    Result.Height := D.Height;
  Result.LineType := ltSplitLine;
end;

function TItemInfoDrawGroup.AddSplitlLineFirst(nHeight : Integer = 0):TDrawItemLine;
var
  D : TAsphyreLockableTexture;
begin

  Result := TDrawItemLine.Create;
  Result.Caption := '';
  Result.Value := '';
  Result.Extend := '';
  Result.clCaption := 0;
  Result.clValue := 0;
  Result.clExtend := $66CCFF;
  Result.Height := 15;
  Result.LineType := ltNormal;
  FLines.Insert(0,Result);

  D := g_77Images.Images[521];
  if D <> nil then
    Result.Height := D.Height;
  if nHeight <> 0 then
    Result.Height := nHeight;


  Result.LineType := ltSplitLine;
end;

procedure TItemInfoDrawGroup.Calc(ISurface: TAsphyreCanvas);
var
  i: Integer;
  aline: TDrawItemLine;
  ACW, AVW, AEW, ASW, w: Integer;
begin
  FMaxCaptionW := 0;
  FMaxValueW := 0;
  FMaxExtendW := 0;
  ASW := 0;
  for i := 0 to FLines.Count - 1 do
  begin
    aline := TDrawItemLine(FLines.Items[i]);
    case aline.LineType of
      ltSample:begin
        ACW := FontManager.Default.TextWidth(aline.Caption);
        if ASW < ACW then
          ASW := ACW;
      end ;
      ltNormal : begin
         ACW := FontManager.Default.TextWidth(aline.Caption);
          AVW := FontManager.Default.TextWidth(aline.Value);
          AEW := 0;
          if g_UIManager.Form.HintEditor.ShowExtend then
            AEW := FontManager.Default.TextWidth(aline.Extend);
          if FMaxCaptionW < ACW then
            FMaxCaptionW := ACW;
          if FMaxValueW < AVW then
            FMaxValueW := AVW;
          if FMaxExtendW < AEW then
            FMaxExtendW := AEW;
      end;
      ltTitle: ;
      ltSplitLine: ;
    end;

    Inc(Height, aline.Height);
  end;

  Width := FMaxCaptionW + FDrawItemInfo.FSpaceW + FMaxValueW;
  if FMaxExtendW > 0 then
    Width := Width + FDrawItemInfo.FSpaceW + FMaxExtendW;
  if Width < ASW then
    Width := ASW;
  FDrawItemInfo.MaxLineWidth  :=  Max(FDrawItemInfo.MaxLineWidth, Width);
end;

constructor TItemInfoDrawGroup.Create(ADrawItemInfo: TDrawItemInfo);
begin
  inherited;
  FLines := TList.Create;
end;

destructor TItemInfoDrawGroup.Destroy;
var
  i: Integer;
begin
  for i := 0 to FLines.Count - 1 do
    TObject(FLines.Items[i]).Free;
  FreeAndNilEx(FLines);
  inherited;
end;

procedure TItemInfoDrawGroup.Draw(ISurface: TAsphyreCanvas; var Y: Integer;
  const ALeft, HintW, HintH: Integer);
var
  I: Integer;
  Aline: TDrawItemLine;
  D:TAsphyreLockableTexture;
  nLineRight, nLineLeft : Integer;
  nY : Integer;

begin
  for I := 0 to FLines.Count - 1 do
  begin
    Aline := TDrawItemLine(FLines.Items[I]);
    case Aline.LineType of
      ltNormal:begin
        ISurface.BoldText(ALeft + 8, Y + Round(FontManager.Default.TextHeight(Aline.Caption) / 2), Aline.Caption, Aline.clCaption, FontBorderColor);
        ISurface.BoldText(ALeft + 8 + FMaxCaptionW + FDrawItemInfo.FSpaceW, Y + Round(FontManager.Default.TextHeight(Aline.Value) / 2), Aline.Value, Aline.clValue, FontBorderColor);
        if g_UIManager.Form.HintEditor.ShowExtend and (Aline.Extend <> '') then
          ISurface.BoldText(ALeft + 8 + FMaxCaptionW + FDrawItemInfo.FSpaceW + FMaxValueW + FDrawItemInfo.FSpaceW, Y + Round(FontManager.Default.TextHeight(Aline.Extend) / 2), Aline.Extend, Aline.clExtend, FontBorderColor);
      end;
      ltSample: ISurface.BoldText(ALeft + 8, Y + Round(FontManager.Default.TextHeight(Aline.Caption) / 2), Aline.Caption, Aline.clCaption, FontBorderColor);
      ltTitle: ;
      ltSplitLine:
      begin
        //绘制分割线
        nY := Y  + Aline.Height div 2;

        D:=  g_77Images.Images[521];
        if D <> nil then
        begin
          ISurface.Draw(ALeft,nY,D);
          nLineLeft := ALeft + D.Width;
        end;

        D:=  g_77Images.Images[523];
        if D <> nil then
        begin
          nLineRight := ALeft + Aline.Width + 16 - D.Width;
          ISurface.Draw(nLineRight,nY,D);
        end;

        D:= g_77Images.Images[522];
        if D <> nil then
        begin
          ISurface.HorFillDraw(nLineLeft,nLineRight,nY,D,false);
        end;

      end;
    end;

    Inc(Y, Aline.Height);
  end;
end;

function TItemInfoDrawGroup.GetHasItem: Boolean;
begin
  Result := FLines.Count > 0;
end;

procedure TItemInfoDrawGroup.SetSplitlLineWidth(nWidth: Integer);
var
  Aline: TDrawItemLine;
  I : Integer;
begin
  for I := 0 to FLines.Count - 1 do
  begin
    Aline := TDrawItemLine(FLines.Items[I]);
    if Aline.LineType = ltSplitLine then
      Aline.Width := nWidth;
  end;
end;

{ TItemStarDrawGroup }

procedure TItemStarDrawGroup.Calc(ISurface: TAsphyreCanvas);
begin
  Height := 13 * Ceil(FStarSize / g_UIManager.Form.HintEditor.LineStar);
  Width := 16 * Min(FStarSize, g_UIManager.Form.HintEditor.LineStar);
  FDrawItemInfo.MaxLineWidth  :=  Max(FDrawItemInfo.MaxLineWidth, Width);
end;

constructor TItemStarDrawGroup.Create(ADrawItemInfo: TDrawItemInfo;
  const AStarLen, AStrarSize: Integer);
begin
  inherited Create(ADrawItemInfo);
  FStartIdx := 0;
  FSum      := 0;
  FStarLen  := AStarLen;
  FStarSize := AStrarSize;
  Spacing   := False;
  FOffsetY  :=  0;
end;

procedure TItemStarDrawGroup.Draw(ISurface: TAsphyreCanvas; var Y: Integer;
  const ALeft, HintW, HintH: Integer);
var
  I, cH: Integer;
  d1, d2: TAsphyreLockableTexture;
  ALine, AOffsetX: Integer;
  ASize, Row, Col: Integer;
begin
  d1 := g_77Images.Images[159];
  d2 := g_77Images.Images[158];
  ASize :=  0;
  for Row := 0 to Ceil(FStarSize / g_UIManager.Form.HintEditor.LineStar) - 1 do
  begin
    for Col := 0 to g_UIManager.Form.HintEditor.LineStar - 1 do
    begin
      if ASize < FStarLen then
        ISurface.Draw(ALeft + 8 + Col * 16, Y + Row * 13, d2)
      else
        ISurface.Draw(ALeft + 8 + Col * 16, Y + Row * 13, d1);
      Inc(ASize);
      if ASize > FStarSize - 1 then
      begin
        Break;
      end;
    end;
  end;
  inherited;
end;

procedure TItemStarDrawGroup.DrawEx(ISurface: TAsphyreCanvas; ALeft, X, Y: Integer);
var
  i: Integer;
  d: TAsphyreLockableTexture;
  ALine, AOffsetX: Integer;
begin
  Inc(FSum);
  if FSum mod 3 = 0 then
  begin
    Inc(FStartIdx);
    if FStartIdx > 4 then
      FStartIdx := 0;
  end;
  case FStartIdx of
    0:  d := g_77Images.Images[256];
    1:  d := g_77Images.Images[257];
    2:  d := g_77Images.Images[258];
    3:  d := g_77Images.Images[259];
    4:  d := g_77Images.Images[260];
  end;
  ALine     :=  0;
  AOffsetX  :=  0;
  for i := 1 to FStarLen do
  begin
    ISurface.DrawBlend(ALeft + X + AOffsetX, Y + FOffsetY{ + 1} + ALine * 24, d, 1);
    if i mod g_lineStartCount = 0  then
    begin
      Inc(ALine);
      AOffsetX  :=  -24;
    end;
    Inc(AOffsetX, 24);
  end;
end;

{TItemSoulDrawGroup}

constructor TItemSoulDrawGroup.Create(ADrawItemInfo: TDrawItemInfo; const Exp,
  MaxExp: Integer);
begin
  inherited Create(ADrawItemInfo);
  FExp := Exp;
  FMaxExp := MaxExp;
end;

procedure TItemSoulDrawGroup.Calc(ISurface: TAsphyreCanvas);
begin
  Height := 16;//FontManager.Default.TextHeight('123');
  Width  := FontManager.Default.TextWidth(Format('%d/%d', [FExp, FMaxExp])) + 4;
end;

procedure TItemSoulDrawGroup.Draw(ISurface: TAsphyreCanvas; var Y: Integer; const ALeft, HintW, HintH: Integer);
var
  Prc: Integer;
  ASize: TSize;
begin
  Prc := Round((HintW - 2) * (FExp / FMaxExp));
  ASize := FontManager.Default.TextExtent(Format('%d/%d', [FExp, FMaxExp]));
  ISurface.FillRect(Rect(ALeft + 9, Y + 1, ALeft + 9 + Prc, Y+15), cColor4(cColor1(g_UIManager.Form.HintEditor.SoulColor)));
  ISurface.BoldText(ALeft + 8 + (HintW - ASize.cx) div 2 + 2, Y + (16-ASize.cy) div 2, Format('%d/%d', [FExp, FMaxExp]), g_UIManager.Form.HintEditor.SoulExpColor, FontBorderColor);
  ISurface.FrameRect(Rect(ALeft + 8, Y, ALeft + HintW + 8, Y+16), cColor4(cColor1(g_UIManager.Form.HintEditor.SoulBorder)));
  Inc(Y, Height);
end;

{ TItemHoleDrawGroup }

procedure TItemHoleDrawGroup.Calc(ISurface: TAsphyreCanvas);

  procedure GetPropSize(AProp, AValue: Integer; var W: Integer);
  var
    ADisplay: String;
  begin
    W := 0;
    ADisplay := GetHoleDisplayValue(AProp, AValue);
    if ADisplay <> '' then
      W := FontManager.Default.TextWidth(ADisplay);
  end;

  procedure CalcHole(AItemIndex, ALineH: Integer; var H, W: Integer);
  var
    AStdItem: pTStdItem;
    AWidth: Integer;
  begin
    if (AItemIndex >= 0) and (AItemIndex < g_ItemList.Count) then
    begin
      AStdItem := g_ItemList.Items[AItemIndex];
      if (AStdItem <> nil) and (AStdItem.StdMode = 29) then
      begin
        //1
        GetPropSize(AStdItem.ACMin, AStdItem.ACMax, AWidth);
        if AWidth > 0 then
        begin
          H := H + ALineH + 2;
          W := Max(W, AWidth);
        end;
        //2
        GetPropSize(AStdItem.MACMin, AStdItem.MACMax, AWidth);
        if AWidth > 0 then
        begin
          H := H + ALineH + 2;
          W := Max(W, AWidth);
        end;
        //3
        GetPropSize(AStdItem.DCMin, AStdItem.DCMax, AWidth);
        if AWidth > 0 then
        begin
          H := H + ALineH + 2;
          W := Max(W, AWidth);
        end;
        //4
        GetPropSize(AStdItem.MCMin, AStdItem.MCMax, AWidth);
        if AWidth > 0 then
        begin
          H := H + ALineH + 2;
          W := Max(W, AWidth);
        end;
        //5
        GetPropSize(AStdItem.SCMin, AStdItem.SCMax, AWidth);
        if AWidth > 0 then
        begin
          H := H + ALineH + 2;
          W := Max(W, AWidth);
        end;
      end;
    end;
  end;

var
  ACaptionWidth, AValueWidth: Integer;
  AName, S: String;
begin
  FMax  :=  0;
  FCount:=  0;
  if FDrawItemInfo.FAddHold[0] >= 0 then
  begin
    Inc(FMax);
    if FDrawItemInfo.FAddHold[0] > 0 then
      Inc(FCount);
  end;
  if FDrawItemInfo.FAddHold[1] >= 0 then
  begin
    Inc(FMax);
    if FDrawItemInfo.FAddHold[1] > 0 then
      Inc(FCount);
  end;
  if FDrawItemInfo.FAddHold[2] >= 0 then
  begin
    Inc(FMax);
    if FDrawItemInfo.FAddHold[2] > 0 then
      Inc(FCount);
  end;
  S := g_UIManager.Form.HintEditor.Hole.Caption;
  S := StringReplace(S, '#激活数#', IntToStr(FCount), [rfReplaceAll]);
  S := StringReplace(S, '#总数#', IntToStr(FMax), [rfReplaceAll]);
  Width   :=  FontManager.Default.TextWidth(S);
  Height  :=  FontManager.Default.TextHeight('H') + 2;
  FLineH  :=  Max(14, FontManager.Default.TextHeight('H'));
  if FDrawItemInfo.FAddHold[0] >= 0 then
  begin
    Height := Height + FLineH + 2;
    AValueWidth := 0;
    CalcHole(FDrawItemInfo.FAddHold[0], FLineH, Height, AValueWidth);
    AName := GetHoleName(FDrawItemInfo.FAddHold[0]);
    ACaptionWidth := FontManager.Default.TextWidth(AName);
    ACaptionWidth := Max(ACaptionWidth, AValueWidth);
    Width := Max(Width, ACaptionWidth + 18);
  end;
  if FDrawItemInfo.FAddHold[1] >= 0 then
  begin
    Height := Height + FLineH + 2;
    AValueWidth := 0;
    CalcHole(FDrawItemInfo.FAddHold[1], FLineH, Height, AValueWidth);
    AName := GetHoleName(FDrawItemInfo.FAddHold[1]);
    ACaptionWidth := FontManager.Default.TextWidth(AName);
    ACaptionWidth := Max(ACaptionWidth, AValueWidth);
    Width := Max(Width, ACaptionWidth + 18);
  end;
  if FDrawItemInfo.FAddHold[2] >= 0 then
  begin
    Height := Height + FLineH + 2;
    AValueWidth := 0;
    CalcHole(FDrawItemInfo.FAddHold[2], FLineH, Height, AValueWidth);
    AName := GetHoleName(FDrawItemInfo.FAddHold[2]);
    ACaptionWidth := FontManager.Default.TextWidth(AName);
    ACaptionWidth := Max(ACaptionWidth, AValueWidth);
    Width := Max(Width, ACaptionWidth + 18);
  end;
end;

procedure TItemHoleDrawGroup.Draw(ISurface: TAsphyreCanvas; var Y: Integer;
  const ALeft, HintW, HintH: Integer);

  procedure DrawTitle(var _Y: Integer);
  var
    S: String;
  begin
    S := g_UIManager.Form.HintEditor.Hole.Caption;
    S := StringReplace(S, '#激活数#', IntToStr(FCount), [rfReplaceAll]);
    S := StringReplace(S, '#总数#', IntToStr(FMax), [rfReplaceAll]);
    ISurface.BoldText(ALeft + 8, _Y, S, clYellow, FDrawItemInfo.FBGColor);
    Inc(_Y, FontManager.Default.TextHeight('凹') + 2);
  end;

  procedure DrawPropty(ItemIndex, ALeft: Integer; var _Y: Integer; const ValueColor: TColor);
  var
    ADisplay: String;
    AStdItem: pTStdItem;
  begin
    if (ItemIndex >= 0) and (ItemIndex < g_ItemList.Count) then
    begin
      AStdItem := g_ItemList.Items[ItemIndex];
      if (AStdItem <> nil) and (AStdItem.StdMode = 29) then
      begin
        //1
        ADisplay := GetHoleDisplayValue(AStdItem.ACMin, AStdItem.ACMax);
        if ADisplay <> '' then
        begin
          ISurface.BoldText(ALeft, _Y + (FLineH - FontManager.Default.TextHeight(ADisplay)) div 2, ADisplay, ValueColor, FDrawItemInfo.FBGColor);
          Inc(_Y, FLineH + 2);
        end;
        //2
        ADisplay := GetHoleDisplayValue(AStdItem.MACMin, AStdItem.MACMax);
        if ADisplay <> '' then
        begin
          ISurface.BoldText(ALeft, _Y + (FLineH - FontManager.Default.TextHeight(ADisplay)) div 2, ADisplay, ValueColor, FDrawItemInfo.FBGColor);
          Inc(_Y, FLineH + 2);
        end;
        //3
        ADisplay := GetHoleDisplayValue(AStdItem.DCMin, AStdItem.DCMax);
        if ADisplay <> '' then
        begin
          ISurface.BoldText(ALeft, _Y + (FLineH - FontManager.Default.TextHeight(ADisplay)) div 2, ADisplay, ValueColor, FDrawItemInfo.FBGColor);
          Inc(_Y, FLineH + 2);
        end;
        //4
        ADisplay := GetHoleDisplayValue(AStdItem.MCMin, AStdItem.MCMax);
        if ADisplay <> '' then
        begin
          ISurface.BoldText(ALeft, _Y + (FLineH - FontManager.Default.TextHeight(ADisplay)) div 2, ADisplay, ValueColor, FDrawItemInfo.FBGColor);
          Inc(_Y, FLineH + 2);
        end;
        //5
        ADisplay := GetHoleDisplayValue(AStdItem.SCMin, AStdItem.SCMax);
        if ADisplay <> '' then
        begin
          ISurface.BoldText(ALeft, _Y + (FLineH - FontManager.Default.TextHeight(ADisplay)) div 2, ADisplay, ValueColor, FDrawItemInfo.FBGColor);
          Inc(_Y, FLineH + 2);
        end;
      end;
    end;
  end;

  procedure DrawHole(ItemIndex: Integer; var _Y: Integer);
  var
    D: TAsphyreLockableTexture;
    AName, SValue: String;
  begin
    if ItemIndex < 0 then Exit;

    if ItemIndex = 0 then
    begin
      D :=  g_77Images.Images[156];
      if D <> nil then
        ISurface.Draw(ALeft + 8, _Y, D);
      ISurface.BoldText(ALeft + 24, _Y + (FLineH - FontManager.Default.TextHeight(g_UIManager.Form.HintEditor.Hole.NoStone)) div 2, g_UIManager.Form.HintEditor.Hole.NoStone, g_UIManager.Form.HintEditor.Hole.NoStoneColor, FDrawItemInfo.FBGColor);
      Inc(_Y, FLineH + 2);
    end
    else if ItemIndex > 0 then
    begin
      D :=  g_77Images.Images[157];
      if D <> nil then
        ISurface.Draw(ALeft + 8, _Y, D);
      AName := GetHoleName(ItemIndex);
      ISurface.BoldText(ALeft + 24, _Y + (FLineH - FontManager.Default.TextHeight(AName)) div 2, AName, g_UIManager.Form.HintEditor.Hole.StoneNameColor, FDrawItemInfo.FBGColor);
      Inc(_Y, FLineH + 2);
      DrawPropty(ItemIndex, ALeft + 24, _Y, g_UIManager.Form.HintEditor.Hole.StoneValueColor);
    end;
  end;

var
  _Y: Integer;
begin
  _Y  :=  Y + 5;
  DrawTitle(_Y);
  DrawHole(FDrawItemInfo.FAddHold[0], _Y);
  DrawHole(FDrawItemInfo.FAddHold[1], _Y);
  DrawHole(FDrawItemInfo.FAddHold[2], _Y);
  inherited;
end;

function TItemHoleDrawGroup.GetHoleName(ItemIndex: Integer): String;
begin
  if (ItemIndex > 0) and (ItemIndex < g_ItemList.Count) then
    Result := g_ItemList.Items[ItemIndex].DisplayName
  else
    Result := g_UIManager.Form.HintEditor.Hole.NoStone
end;

function GetHoleDisplayValue(AProp, AValue: Integer): String;
begin
  Result := '';
  if AValue > 0 then
  begin
    case AProp of
      1:  Result  :=  '物理防御 +'+IntToStr(AValue);
      2:  Result  :=  '魔法防御 +'+IntToStr(AValue);
      3:  Result  :=  '物理攻击 +'+IntToStr(AValue);
      4:  Result  :=  '魔法攻击 +'+IntToStr(AValue);
      5:  Result  :=  '道术攻击 +'+IntToStr(AValue);
      6:  Result  :=  '体力值上限 +'+IntToStr(AValue) +'HP';
      7:  Result  :=  '魔力值上限 +'+IntToStr(AValue) +'MP';
      8:  Result  :=  '射术攻击 +'+IntToStr(AValue);
      9:  Result  :=  '刺术攻击 +'+IntToStr(AValue);
      10: Result  :=  '伤害吸收 +'+IntToStr(AValue)+'%';
      11: Result  :=  '伤害反弹 +'+IntToStr(AValue)+'%';
      12: Result  :=  '伤害加成 +'+IntToStr(AValue)+'%';
      13: Result  :=  '致命一击 +'+IntToStr(AValue)+'%';
      14: Result  :=  '会心一击 +'+IntToStr(AValue)+'%';
      15: Result  :=  '体力值恢复 +'+IntToStr(AValue)+'%';
      16: Result  :=  '魔力值恢复 +'+IntToStr(AValue)+'%';
      17: Result  :=  '准确 +'+IntToStr(AValue);
      18: Result  :=  '敏捷 +'+IntToStr(AValue);
      19: Result  :=  '武术攻击 +'+IntToStr(AValue);
    end;
  end;
end;

end.
