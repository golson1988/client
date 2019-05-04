unit uCliUITypes;

interface
  uses Windows, Classes, SysUtils, Generics.Collections, Forms, uTypes, ComCtrls, DWinCtl, WIL,
  Graphics, AbstractCanvas, AbstractTextures, Controls, DXHelper, HUtil32, uEDCode, ZLib, uUITypes,
  Grobal2, SoundUtil, ClFunc, uMessageParse, uTextures, cliUtil, Math, Common;

  type
  TdxClientWindowManager = class;
  TuDButton = class(TDButton)
  private
    FIdx: Integer;
    FTick: Integer;
    FImgInterval: Integer;
    FImgEnd: Integer;
    FMouseDown: Integer;
    FTranspant: Boolean;
    FButtonHandler: TdxButtonHandler;
    FWindowManager: TdxClientWindowManager;
    FFontColor, FBorderColor: TColor;
    FWinName: String;
    FBlendMode: Byte;
    procedure DoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  public
    constructor Create (AOwner: TComponent); override;

    procedure DirectPaint(dsurface: TAsphyreCanvas); override;
    property ImgEnd: Integer read FImgEnd write FImgEnd;
    property ImgInterval: Integer read FImgInterval write FImgInterval;
    property MouseDown: Integer read FMouseDown write FMouseDown default -1;
    property Transpant: Boolean read FTranspant write FTranspant;
    property BlendMode: Byte read FBlendMode write FBlendMode;
  end;

  TuDControl = class(TDControl)
  private
    FIdx: Integer;
    FImgInterval: Integer;
    FImgEnd: Integer;
    FTranspant: Boolean;
    FWindowManager: TdxClientWindowManager;
    FWinName: String;
    FBlendMode: Byte;
    procedure DoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  public
    constructor Create (AOwner: TComponent); override;

    procedure DirectPaint (dsurface: TAsphyreCanvas); override;
    property ImgEnd: Integer read FImgEnd write FImgEnd;
    property ImgInterval: Integer read FImgInterval write FImgInterval;
    property Transpant: Boolean read FTranspant write FTranspant;
    property BlendMode: Byte read FBlendMode write FBlendMode;
  end;

  TuDEdit = class(TDEdit)
  private
    FWindowManager: TdxClientWindowManager;
    FWinName: String;
    FOffsetX, FOffsetY: Integer;
  public
    constructor Create (AOwner: TComponent); override;
    procedure DirectPaint(DSurface: TAsphyreCanvas); override;
  end;

  TuDItemControl = class(TDButton)
  private
    FWinName,
    FTakeOnMethod,
    FTakeOffMethod: String;
    FNode: TMessageNode;
    FItemMode: TdxUIItemContainerMode;
    FWindowManager: TdxClientWindowManager;
    FBlendMode: Byte;
    function ItemCanDrop(AItem: TClientItem): Boolean;
    procedure DoClick(Sender: TObject; X, Y: Integer);
    procedure DoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  public
    ClientItem: TClientItem;
    Names: TStrings;
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DirectPaint (dsurface: TAsphyreCanvas); override;
    property BlendMode: Byte read FBlendMode write FBlendMode;
  end;

  TuDWindow = class(TDWindow)
  private
    LastestClickTime: Longword;
    FTranspant: Boolean;
    FMessage: String;
    FMsgLeft,
    FMsgTop: Integer;
    FWinName: String;
    FMerchantMessage: TuMerchantMessage;
    FWindowManager: TdxClientWindowManager;
    FBlendMode: Byte;
    FInDownded: Boolean;
    procedure SetMessage(const Value: String);
    procedure DoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure DoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure DoClick(Sender: TObject; X, Y: integer);
    procedure DrawMessageBackGround(Sender: TObject);
    procedure DoMessageGetItemImages(ANode: TMessageNode);
  protected
    procedure SetVisible(const Value: Boolean); override;
     procedure DirectPaint(DSurface: TAsphyreCanvas); override;
  public
    Npc: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Transpant: Boolean read FTranspant write FTranspant;
    property BlendMode: Byte read FBlendMode write FBlendMode;
    property Message: String read FMessage write SetMessage;
  end;

  TuDLabel = class(TDControl)
  private
    FWindowManager: TdxClientWindowManager;
    FFontColor, FBorderColor: TColor;
    FWinName: String;
    FBlendMode: Byte;
    procedure DoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;

    procedure DirectPaint (dsurface: TAsphyreCanvas); override;
    function  MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function  MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function Click(X, Y: integer): Boolean; override;
    property BlendMode: Byte read FBlendMode write FBlendMode;
  end;

  TuDBufferControl = class(TDButton)
  private
    FBufferItem: TdxUIBufferItem;
    FIconImages: TWMImages;
    FHoverIconImages: TWMImages;
    FBufferTime: Integer;
    FBufferValue: Integer;
    FStartTick: LongWord;
    FEndTick: LongWord;
    FOnTimeEnd: TNotifyEvent;
    FValue: Integer;
    FTimeLimit: Integer;
    FPermannent: Boolean;
    procedure SetBufferItem(const Value: TdxUIBufferItem);
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;

    procedure DirectPaint(dsurface: TAsphyreCanvas); override;
    function TimeToStr(ATick: Integer): String;

    property BufferItem: TdxUIBufferItem read FBufferItem write SetBufferItem;
    property TimeLimit: Integer read FTimeLimit write FTimeLimit;
    property Value: Integer read FValue write FValue;
    property BufferTime: Integer read FBufferTime write FBufferTime;
    property BufferValue: Integer read FBufferValue write FBufferValue;
    property StartTick: LongWord read FStartTick write FStartTick;
    property EndTick: LongWord read FEndTick write FEndTick;
    property Permannent: Boolean read FPermannent write FPermannent;
    property OnTimeEnd: TNotifyEvent read FOnTimeEnd write FOnTimeEnd;
  end;

  TEffectFrame = class
    Lib: TWMImages;
    ImgIndex: Integer;
    OffsetX: Integer;
    OffsetY: Integer;
    Stay: Integer;
    Alpha: Byte;
  end;

  TOnSoundEvent = procedure(Sender: TObject; const SoundFile: String) of Object;
  TEffect = class
  private
    FPrelude,
    FFrames,
    FTheEnd: TList<TEffectFrame>;
    FPreludeSound,
    FFramesSound,
    FTheEndSound: String;
    FCurFrame: TEffectFrame;
    FLastTick: LongWord;
    FCurrentFrame: Integer;
    FLoop: Integer;
    FCanDraw,
    FStop: Boolean;
    FManager: TdxClientWindowManager;
    FStep: Byte;
    FOnEndFrame: TNotifyEvent;
    FOnSoundEvent: TOnSoundEvent;
    FEffectID: Integer;
    FMaxWidth: Integer;
    FMaxHeight: Integer;
    FOffsetX,
    FOffsetY: Integer;
    procedure Clear;
    function GetNextFrame: TEffectFrame; inline;
    procedure DoEndFrame;
    procedure DoSoundFile(const AFileName: String);
  public
    LoopMax: Integer;

    constructor Create;
    destructor Destroy; override;
    procedure Initializa;
    procedure Stop;
    procedure Run;
    procedure AddPreludeFrame(AFrame: TEffectFrame);
    procedure AddFrame(AFrame: TEffectFrame);
    procedure AddEndFrame(AFrame: TEffectFrame);
    procedure Draw(dsurface: TAsphyreCanvas; X, Y: Integer);
    property EffectID: Integer read FEffectID write FEffectID;
    property MaxWidth: Integer read FMaxWidth;
    property MaxHeight: Integer read FMaxHeight;
    property PreludeSound: String read FPreludeSound write FPreludeSound;
    property FramesSound: String read FFramesSound write FFramesSound;
    property TheEndSound: String read FTheEndSound write FTheEndSound;
    property OnEndFrame: TNotifyEvent read FOnEndFrame write FOnEndFrame;
    property OnSoundEvent: TOnSoundEvent read FOnSoundEvent write FOnSoundEvent;
  end;

  TItemSmallEffect = class
    TimeTick: LongWord;
    ID: Integer;
    Intrval: Integer;
    LibFile: String;
    Start: Integer;
    Lib: TWMImages;
    Count :Integer;
    OffsetX, OffsetY: Integer;
    BlendMode:Byte;
    procedure Draw(DSurface: TAsphyreCanvas; CellWidth, CellHeight, X, Y: Integer);
  end;

  TItemInnerEffect = class
    TimeTick: LongWord;
    ID: Integer;
    Intrval: Integer;
    Count: Integer;
    LibFile: String;
    Start: Integer;
    Lib: TWMImages;
    OffsetX, OffsetY: Integer;
    BlendMode:Byte;
    procedure Draw(DSurface: TAsphyreCanvas; X, Y: Integer);overload;
    procedure Draw(DSurface: TAsphyreCanvas; CellWidth, CellHeight, X, Y: Integer);overload;
  end;

  TItemOuterEffect = class
    Lib: TWMImages;
    ID: Integer;
    Start: Integer;
    OffsetX, OffsetY: Integer;
    BlendMode:Byte;
    function GetImage(CurrentFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
  end;

  TdxOnCreateUI = procedure(AControl: TDControl) of Object;
  TdxOnClick = procedure(ANpc: Integer; const Selected, WinName, ItemIndex: String) of Object;
  TdxOnClickSound = procedure(AClickSound: TClickSound) of Object;
  TdxClientWindowManager  = class(TdxWindowManager)
  private
    FCanDraw: Boolean;
    FWinForm: TForm;
    FDxParent: TDControl;
    FScreenHeight: Integer;
    FScreenWidth: Integer;
    FOnCreateUI: TdxOnCreateUI;
    FOnClick: TdxOnClick;
    FOnMoveInCommandNode: TOnMoveInCommandNode;
    FOnMoveInHint: TOnMoveInHint;
    FItemLock: Boolean;
    FSmallEffects: TList<TItemSmallEffect>;
    FInnerEffects: TList<TItemInnerEffect>;
    FOuterEffects: TList<TItemOuterEffect>;
    procedure SetUIProp(DParent, DUI: TDControl; AProperties: TdxCustomUIProperties);
    function CreateUIWindow(DParent: TDControl; AProperties: TdxCustomUIProperties; const WinName: String; Visible: Boolean): TDControl;
    function CreateUIButton(DParent: TDControl; AProperties: TdxCustomUIProperties; const WinName: String): TDControl;
    function CreateUILabel(DParent: TDControl; AProperties: TdxCustomUIProperties; const WinName: String): TDControl;
    function CreateUIControl(DParent: TDControl; AProperties: TdxCustomUIProperties; const WinName: String): TDControl;
    function CreateUIText(DParent: TDControl; AProperties: TdxCustomUIProperties; const WinName: String): TDControl;
    function CreateUIElement(DParent: TDControl; Kind: TdxUIKind; AProperties: TdxCustomUIProperties; const WinName: String): TDControl;
    procedure DodxButtonClick(Sender: TObject; X, Y: integer);
    function GetItemIndexes(AWindow: TdxUIWindow): String;
    function GetParameters(AWindow: TdxUIWindow): String;
    procedure DoSelect(const AWinName, ALabel: String);
    function CreateItemControl(DParent: TDControl; AItemContainer: TdxUIItemContainer; const AWinName: String): TDControl;
    procedure MoveInCommandNode(Sender: TObject; ACommandNode: TMessageNode; X, Y: Integer);
    procedure ShowHint(Sender: TObject; const Hint: String; X, Y: Integer);
    function CreateClientEffect(AEffect: TdxEffect): TEffect;
    procedure CheckLocked;
    procedure CheckWindowCreated(AWin: TdxUIWindow);
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure CreateAllUI;
    function CreateWindow(ADxParent: TDControl; AWindowItem: TdxUIWindow; const Visible: Boolean=False): TuDWindow;
    function CreateUI(ADxParent: TDControl; AWindowItem: TdxUIItem; const WinName: String): TDControl;
    function TryGet(const AName: String; out AWin: TuDWindow): Boolean;
    function ShowWindow(IsUpdate: Boolean; AMerchant: Integer; const AName, AMessage: String): Boolean;
    function CreateEffect(EffectID: Integer): TEffect;
    function CreateItemSmallEffect(AEffect: TdxItemSmallEffect): TItemSmallEffect;
    function TryGetItemSmallEffect(EffectID: Integer; out AEffect: TItemSmallEffect): Boolean;
    function CreateItemInnerEffect(AEffect: TdxItemInnerEffect): TItemInnerEffect;
    function TryGetItemInnerEffect(EffectID: Integer; out AEffect: TItemInnerEffect): Boolean;
    function CreateItemOuterEffect(AEffect: TdxItemOuterEffect): TItemOuterEffect;
    function TryGetItemOuterEffect(EffectID: Integer; out AEffect: TItemOuterEffect): Boolean;
    procedure CloseAll(CloseManual: Boolean);
    property WinForm: TForm read FWinForm write FWinForm;
    procedure ResetItems;
    property DxParent: TDControl read FDxParent write FDxParent;
    property ScreenWidth: Integer read FScreenWidth write FScreenWidth;
    property ScreenHeight: Integer read FScreenHeight write FScreenHeight;
    property ItemLock: Boolean read FItemLock;

    property OnCreateUI: TdxOnCreateUI read FOnCreateUI write FOnCreateUI;
    property OnClick: TdxOnClick read FOnClick write FOnClick;
    property OnMoveInCommandNode: TOnMoveInCommandNode read FOnMoveInCommandNode write FOnMoveInCommandNode;
    property OnMoveInHint: TOnMoveInHint read FOnMoveInHint write FOnMoveInHint;
  end;

implementation
  uses AsphyreTextureFonts, FState, MShare;

function FindWLib(const AName: String): TWMImages;
begin
  Result := nil;
  if AName <> '' then
    LibManager.TryGetLib2(AName, Result);
end;

procedure DoPropertiesResetSize(AProperties: TdxCustomUIProperties);
var
  AImages: TWMImages;
  X, Y: Integer;
begin
  if (AProperties<>nil) then
  begin
    AImages :=  FindWLib(AProperties.DataName);
    if AImages<>nil then
    begin
      if AImages.GetImgSize(AProperties.ImgIndex, X, Y) then
      begin
        AProperties.Width   :=  X;
        AProperties.Height  :=  Y;
      end;
    end;
  end;
end;

{ TuDButton }

constructor TuDButton.Create(AOwner: TComponent);
begin
  inherited;
  OnMouseMove  :=  DoMouseMove;
  NoSaveUI := True;
end;

procedure TuDButton.DirectPaint(dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ATexture: TAsphyreLockableTexture;
begin
  if Assigned(Propertites.Images) then
  begin
    D :=  nil;
    if Downed and (FMouseDown>-1) then
      D :=  Propertites.Images.Images[FMouseDown]
    else if (FImgEnd>0) and (self.FImgInterval>0) then
    begin
      Inc(FTick);
      if FTick > FImgInterval then
      begin
        Inc(FIdx);
        if FIdx > FImgEnd then
          FIdx  :=  Propertites.ImageIndex;
      end;
      D :=  Propertites.Images.Images[FIdx];
    end
    else
      D :=  Propertites.Images.Images[Propertites.ImageIndex];
    if D <> nil then
    begin
      if FBlendMode > 0 then
        DSurface.DrawBlend(SurfaceX(Left), SurfaceY(Top), D, FBlendMode)
      else
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D, FTranspant);
    end;
  end;
  if Caption <> '' then
  begin
    ATexture  :=  FontManager.Default.TextOut(Caption);
    if Downed then
      dsurface.DrawBoldText(SurfaceX(Left)+(Width-ATexture.Width) div 2+1, SurfaceY(Top)+(Height-ATexture.Height) div 2+1, ATexture, FFontColor, FBorderColor)
    else
      dsurface.DrawBoldText(SurfaceX(Left)+(Width-ATexture.Width) div 2, SurfaceY(Top)+(Height-ATexture.Height) div 2, ATexture, FFontColor, FBorderColor)
  end;
end;

procedure TuDButton.DoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  FWindowManager.ShowHint(Self, Hint, X, Y);
end;

{ TuDControl }

constructor TuDControl.Create(AOwner: TComponent);
begin
  inherited;
  OnMouseMove :=  DoMouseMove;
  FIdx        :=  -1;
  NoSaveUI := True;
end;

procedure TuDControl.DirectPaint(dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  I: Integer;
begin
  if Assigned(Propertites.Images) then
  begin
    D :=  nil;
    if FIdx = -1 then
      FIdx  :=  Propertites.ImageIndex;
    if (FImgEnd>0) and (FImgInterval>0) then
    begin
      if (GetTickCount - TimeTick) > FImgInterval then
      begin
        TimeTick  :=  GetTickCount;
        Inc(FIdx);
        if FIdx > FImgEnd then
          FIdx  :=  Propertites.ImageIndex;
      end;
      D :=  Propertites.Images.Images[FIdx];
    end
    else
      D :=  Propertites.Images.Images[Propertites.ImageIndex];
    if D <> nil then
    begin
      if FBlendMode > 0 then
        DSurface.DrawBlend(SurfaceX(Left), SurfaceY(Top), D, FBlendMode)
      else
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D, FTranspant);
    end;
  end;
end;

procedure TuDControl.DoMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  FWindowManager.ShowHint(Self, '', X, Y);
end;

{ TuDWindow }

procedure TuDWindow.DoClick(Sender: TObject; X, Y: integer);
var
  ANode: TMessageNode;
begin
  if GetTickCount < LastestClickTime then Exit;
  if FMerchantMessage.GetNodeBy(X - SurfaceX(Left)-FMsgLeft, Y - SurfaceY(Top)-FMsgTop, ANode) then
  begin
    g_DWinMan.ClickSound(Self, csGlass);
    FWindowManager.DoSelect(FWinName, ANode.Command);
    LastestClickTime := GetTickCount + 300;
  end;
end;

constructor TuDWindow.Create(AOwner: TComponent);
begin
  inherited;
  FMsgLeft          :=  0;
  FMsgTop           :=  0;
  EnableFocus := False;
  FMerchantMessage  :=  TuMerchantMessage.Create;
  FMerchantMessage.OnDrawBackGround := DrawMessageBackGround;
  FMerchantMessage.OnGetItemImages := DoMessageGetItemImages;
  OnMouseMove       :=  DoMouseMove;
  OnMouseDown       :=  DoMouseDown;
  OnMouseUp         :=  DoMouseUp;
  OnClick           :=  DoClick;
  NoSaveUI := True;
end;

destructor TuDWindow.Destroy;
begin
  FreeAndNilEx(FMerchantMessage);
  inherited;
end;

procedure TuDWindow.DirectPaint(DSurface: TAsphyreCanvas);
var
  I: integer;
  D: TAsphyreLockableTexture;
begin

  if Assigned(Propertites.Images) then
  begin
    D :=  Propertites.Images.Images[Propertites.ImageIndex];
    if D <> nil then
    begin
      if FBlendMode > 0 then
        DSurface.DrawBlend(SurfaceX(Left), SurfaceY(Top), D, FBlendMode)
      else
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D, FTranspant);
    end;
  end;

  for I := 0 to DControls.Count - 1 do
  if DControls[I].Visible then
  begin
    try
      DControls[I].DirectPaint(DSurface);
    except
    end;
  end;

  FMerchantMessage.Draw(dsurface, SurfaceX(Left)+FMsgLeft, SurfaceY(Top)+FMsgTop);
//
//  if Assigned(FOnDirectPaint) then
//  begin
//    try
//      FOnDirectPaint(Self, DSurface);
//    except
//    end;
//  end
//  else if FDefaultDraw then
//    DefaultPaint(DSurface);
//
  DirectPaintDesign(DSurface);
end;


procedure TuDWindow.DoMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  ANode: TMessageNode;
begin
  if not FInDownded then
  begin
    if FMerchantMessage.GetNodeBy(X - SurfaceX(Left) - FMsgLeft, Y - SurfaceY(Top) - FMsgTop, ANode) then
    begin
      FMerchantMessage.MouseCapture(X - SurfaceX(Left) - FMsgLeft, Y - SurfaceY(Top) - FMsgTop, TRUE);
      FWindowManager.MoveInCommandNode(Self, ANode, X, Y);
    end
    else
      FWindowManager.MoveInCommandNode(Self, nil, X, Y);
  end;
end;

procedure TuDWindow.DoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  FInDownded := FMerchantMessage.MouseCapture(X-SurfaceX(Left)-FMsgLeft, Y-SurfaceY(Top)-FMsgTop, False);
end;

procedure TuDWindow.DoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if FInDownded then
  begin
    FMerchantMessage.NoActiveCommand;
    FInDownded := False;
  end;
end;

procedure TuDWindow.DrawMessageBackGround(Sender: TObject);
begin
  DrawMerchantMessageBackground(SurfaceX(Left), SurfaceY(Top), FMerchantMessage);
end;

procedure TuDWindow.DoMessageGetItemImages(ANode: TMessageNode);
begin
  MerchantMessageGetItemImages(ANode);
end;

procedure TuDWindow.SetMessage(const Value: String);
var
  I : Integer;
  D : TDControl;
begin
  //清空创建的临时 组件
  for i := Self.DControls.Count - 1 downto  0 do
  begin
    if Self.DControls[i] is TDMerchatAniButton then
    begin
      D := Self.DControls[i];
      Self.DControls.Delete(I);
      D.Parent := nil;
      D.DParent := nil;
      D.Free;
    end;
  end;

  FMerchantMessage.DParent := Self;
  FMerchantMessage.Parse(Value);
  FMessage := Value;
end;

procedure TuDWindow.SetVisible(const Value: Boolean);
var
  AWinItem: TdxUIWindow;
  I: Integer;
  ATemp: TClientItem;
begin
  if not Value and (FWindowManager<>nil) and FWindowManager.TryGetWindowItem(FWinName, AWinItem) then
  begin
    if g_boLockMoveItem and (AWinItem.ItemContainers.Count > 0) then
      Exit;
    if AWinItem.ItemResetMode = irmClose then
    begin
      for I := 0 to AWinItem.ItemContainers.Count - 1 do
        if AWinItem.ItemContainers.Items[I].DControl<>nil then
        begin
          ATemp :=  TuDItemControl(AWinItem.ItemContainers.Items[I].DControl).ClientItem;
          if (ATemp.MakeIndex>0) and (ATemp.Name<>'') then
            AddItemBag(ATemp);
          FillChar(TuDItemControl(AWinItem.ItemContainers.Items[I].DControl).ClientItem, ClientItemSize, #0);
        end;
    end;
  end;
  FWindowManager.CheckLocked;
  inherited;
end;

{ TuDLabel }

function TuDLabel.Click(X, Y: integer): Boolean;
begin
end;

constructor TuDLabel.Create(AOwner: TComponent);
begin
  inherited;
  OnMouseMove  :=  DoMouseMove;
  NoSaveUI := True;
end;

destructor TuDLabel.Destroy;
begin
  inherited;
end;

procedure TuDLabel.DirectPaint(dsurface: TAsphyreCanvas);
begin
  if Caption <> '' then
    dsurface.BoldText(SurfaceX(Left), SurfaceY(Top), Caption, FFontColor, FBorderColor);
end;

procedure TuDLabel.DoMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  FWindowManager.ShowHint(Self, Hint, X, Y);
end;

function TuDLabel.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  Result  :=  inherited MouseDown(Button, Shift, X, Y);
end;

function TuDLabel.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  Result  :=  inherited MouseUp(Button, Shift, X, Y);
end;

{ TdxClientWindowManager }

procedure TdxClientWindowManager.CheckLocked;
var
  I: Integer;
begin
  for I := 0 to UIItems.Count - 1 do
    if (UIItems.Items[I].Properties.DControl<>nil) and TDControl(UIItems.Items[I].Properties.DControl).Visible and UIItems.Items[I].EnableArmComponent then
    begin
      FItemLock  :=  True;
      Exit;
    end;
  FItemLock :=  False;
end;

procedure TdxClientWindowManager.CheckWindowCreated(AWin: TdxUIWindow);
begin
  if not AWin.Created then
  begin
    CreateWindow(FDxParent, AWin, False);
    AWin.Created := True;
  end;
end;

procedure TdxClientWindowManager.CloseAll(CloseManual: Boolean);
var
  I: Integer;
begin
  for I := 0 to UIItems.Count - 1 do
  begin
    if (UIItems.Items[I].Properties.DControl<>nil) then
    begin
      if UIItems.Items[I].Properties.ManualClose then
      begin
        if CloseManual then
          TDControl(UIItems.Items[I].Properties.DControl).Visible := False;
      end
      else
        TDControl(UIItems.Items[I].Properties.DControl).Visible := False;
    end;
  end;
end;

constructor TdxClientWindowManager.Create;
begin
  inherited;
  FItemLock :=  False;
  FCanDraw  :=  True;
  FSmallEffects := TList<TItemSmallEffect>.Create;
  FInnerEffects := TList<TItemInnerEffect>.Create;
  FOuterEffects := TList<TItemOuterEffect>.Create;
end;

procedure TdxClientWindowManager.CreateAllUI;
var
  I: Integer;
  ASmallEffect: TItemSmallEffect;
  AInnerEffect: TItemInnerEffect;
  AOuterEffect: TItemOuterEffect;
begin
//  for I := 0 to UIItems.Count - 1 do
//    if UIItems.Items[I].Enable then
//      CreateWindow(FDxParent, UIItems.Items[I], False);
  for I := 0 to SmallEffects.Count - 1 do
  begin
     ASmallEffect := CreateItemSmallEffect(SmallEffects.Items[I]);
     if ASmallEffect <> nil then
       FSmallEffects.Add(ASmallEffect);
  end;
  for I := 0 to InnerEffects.Count - 1 do
  begin
     AInnerEffect := CreateItemInnerEffect(InnerEffects.Items[I]);
     if AInnerEffect <> nil then
       FInnerEffects.Add(AInnerEffect);
  end;
  for I := 0 to OuterEffects.Count - 1 do
  begin
     AOuterEffect := CreateItemOuterEffect(OuterEffects.Items[I]);
     if AOuterEffect <> nil then
       FOuterEffects.Add(AOuterEffect);
  end;
end;

function TdxClientWindowManager.CreateClientEffect(AEffect: TdxEffect): TEffect;
var
  CFrame: TEffectFrame;
  I: Integer;
begin
  Result :=  TEffect.Create;
  Result.LoopMax   :=  Max(AEffect.Loop, 0);
  Result.FManager  :=  Self;
  Result.FEffectID :=  AEffect.ID;
  Result.FPreludeSound  :=  AEffect.Sound.PreludeSound;
  Result.FFramesSound   :=  AEffect.Sound.FramesSound;
  Result.FTheEndSound   :=  AEffect.Sound.TheEndSound;
  Result.FOffsetX := AEffect.OffsetX;
  Result.FOffsetY := AEffect.OffsetY;
  //
  for I := 0 to AEffect.Prelude.Count - 1 do
  begin
    CFrame  :=  TEffectFrame.Create;
    CFrame.Lib      :=  FindWLib(AEffect.Prelude.Items[I].LibFile);
    CFrame.ImgIndex :=  AEffect.Prelude.Items[I].ImgIndex;
    CFrame.OffsetX  :=  AEffect.Prelude.Items[I].OffsetX;
    CFrame.OffsetY  :=  AEffect.Prelude.Items[I].OffsetY;
    CFrame.Stay     :=  AEffect.Prelude.Items[I].Stay;
    CFrame.Alpha    :=  AEffect.Prelude.Items[I].Alpha;
    Result.FPrelude.Add(CFrame);
  end;
  //
  for I := 0 to AEffect.Frames.Count - 1 do
  begin
    CFrame  :=  TEffectFrame.Create;
    CFrame.Lib      :=  FindWLib(AEffect.Frames.Items[I].LibFile);
    CFrame.ImgIndex :=  AEffect.Frames.Items[I].ImgIndex;
    CFrame.OffsetX  :=  AEffect.Frames.Items[I].OffsetX;
    CFrame.OffsetY  :=  AEffect.Frames.Items[I].OffsetY;
    CFrame.Stay     :=  AEffect.Frames.Items[I].Stay;
    CFrame.Alpha    :=  AEffect.Frames.Items[I].Alpha;
    Result.FFrames.Add(CFrame);
  end;
  //
  for I := 0 to AEffect.TheEnd.Count - 1 do
  begin
    CFrame  :=  TEffectFrame.Create;
    CFrame.Lib      :=  FindWLib(AEffect.TheEnd.Items[I].LibFile);
    CFrame.ImgIndex :=  AEffect.TheEnd.Items[I].ImgIndex;
    CFrame.OffsetX  :=  AEffect.TheEnd.Items[I].OffsetX;
    CFrame.OffsetY  :=  AEffect.TheEnd.Items[I].OffsetY;
    CFrame.Stay     :=  AEffect.TheEnd.Items[I].Stay;
    CFrame.Alpha    :=  AEffect.TheEnd.Items[I].Alpha;
    Result.FTheEnd.Add(CFrame);
  end;
  Result.FCanDraw  :=  True;
end;

function TdxClientWindowManager.CreateItemControl(DParent: TDControl; AItemContainer: TdxUIItemContainer; const AWinName: String): TDControl;
var
  I: Integer;
begin
  Result  :=  TuDItemControl.Create(FWinForm);
  Result.Parent := FWinForm;
  Result.DParent := DParent;
  AItemContainer.DControl  :=  Result;
  TuDItemControl(Result).FItemMode  :=  AItemContainer.ItemContainerMode;
  TuDItemControl(Result).Hint  :=  AItemContainer.Hint;
  TuDItemControl(Result).FWindowManager :=  Self;
  TuDItemControl(Result).FWinName := AWinName;
  TuDItemControl(Result).FTakeOnMethod := AItemContainer.TakeOnMethod;
  TuDItemControl(Result).FTakeOffMethod := AItemContainer.TakeOffMethod;
  DParent.AddChild(Result);
  Result.Left :=  AItemContainer.Left;
  Result.Top :=  AItemContainer.Top;
  ExtractStrings([',',';'], [], PChar(AItemContainer.Names), TuDItemControl(Result).Names);
  for I := 0 to TuDItemControl(Result).Names.Count - 1 do
  begin
    if TuDItemControl(Result).Names[I] = '*' then
    begin
      TuDItemControl(Result).Names.Clear;
      Break;
    end;
  end;
  Result.SetImgIndex(FindWLib(AItemContainer.BkDataName), AItemContainer.Background);
  if AItemContainer.Width>0 then
    Result.Width   :=  AItemContainer.Width;
  if AItemContainer.Height>0 then
    Result.Height  :=  AItemContainer.Height;
  if Assigned(FOnCreateUI) then
    FOnCreateUI(Result);
end;

function TdxClientWindowManager.CreateItemSmallEffect(AEffect: TdxItemSmallEffect): TItemSmallEffect;
begin
  Result := nil;
  if AEffect <> nil then
  begin
    Result := TItemSmallEffect.Create;
    Result.ID := AEffect.ID;
    Result.TimeTick := GetTickCount;
    Result.Intrval := AEffect.Intrval;
    Result.Count := AEffect.Count;
    if Result.Count <= 0 then
      Result.Count := 1;
    Result.Start := AEffect.Start;
    Result.Lib := FindWLib(AEffect.LibFile);
    Result.Intrval := AEffect.Intrval;
    Result.OffsetX := AEffect.OffsetX;
    Result.OffsetY := AEffect.OffsetY;
    Result.BlendMode := AEffect.BlendMode;
  end;
end;

function TdxClientWindowManager.CreateUI(ADxParent: TDControl; AWindowItem: TdxUIItem; const WinName: String): TDControl;
var
  I: Integer;
begin
  Result := nil;
  if FWinForm = nil then Exit;
  Result :=  CreateUIElement(ADxParent, AWindowItem.Kind, AWindowItem.Properties, WinName);
  AWindowItem.Properties.DControl :=  Result;
  if Assigned(FOnCreateUI) then
    FOnCreateUI(Result);
end;

function TdxClientWindowManager.CreateUIButton(DParent: TDControl;
  AProperties: TdxCustomUIProperties; const WinName: String): TDControl;
begin
  Result  :=  TuDButton.Create(FWinForm);
  SetUIProp(DParent, Result, AProperties);
  TuDButton(Result).ImgEnd          :=  AProperties.ImgEnd;
  TuDButton(Result).ImgInterval     :=  AProperties.ImgInterval;
  TuDButton(Result).MouseDown       :=  AProperties.MouseDown;
  TuDButton(Result).Transpant       :=  AProperties.Transpant;
  TuDButton(Result).FButtonHandler  :=  TdxUIButtonProperties(AProperties).Handler;
  TuDButton(Result).OnClick         :=  DodxButtonClick;
  TuDButton(Result).Caption         :=  TdxUIButtonProperties(AProperties).Caption.Text;
  TuDButton(Result).Hint            :=  TdxUIButtonProperties(AProperties).Hint;
  TuDButton(Result).FFontColor      :=  TdxUIButtonProperties(AProperties).Caption.FontColor;
  TuDButton(Result).FBorderColor    :=  TdxUIButtonProperties(AProperties).Caption.BorderColor;
  TuDButton(Result).FWindowManager  :=  Self;
  TuDButton(Result).FWinName  :=  WinName;
  TuDButton(Result).BlendMode     :=  AProperties.BlendMode;
end;

function TdxClientWindowManager.CreateUIControl(DParent: TDControl;
  AProperties: TdxCustomUIProperties; const WinName: String): TDControl;
begin
  Result  :=  TuDControl.Create(FWinForm);
  SetUIProp(DParent, Result, AProperties);
  TuDControl(Result).ImgEnd       :=  AProperties.ImgEnd;
  TuDControl(Result).ImgInterval  :=  AProperties.ImgInterval;
  TuDControl(Result).FTranspant   :=  AProperties.Transpant;
  TuDControl(Result).FWindowManager  :=  Self;
  TuDControl(Result).FWinName  :=  WinName;
  TuDControl(Result).BlendMode     :=  AProperties.BlendMode;
end;

function TdxClientWindowManager.CreateUIText(DParent: TDControl; AProperties: TdxCustomUIProperties; const WinName: String): TDControl;
begin
  Result  :=  TuDEdit.Create(FWinForm);
  SetUIProp(DParent, Result, AProperties);
  TuDEdit(Result).DefaultDraw := False;
  TuDEdit(Result).Transparent := AProperties.Transpant;
  TuDEdit(Result).FWindowManager := Self;
  TuDEdit(Result).FWinName := WinName;
  TuDEdit(Result).FOffsetX := TdxUITextProperties(AProperties).OffsetX;
  TuDEdit(Result).FOffsetY := TdxUITextProperties(AProperties).OffsetY;
  TuDEdit(Result).MaxLength := TdxUITextProperties(AProperties).MaxLength;
  TuDEdit(Result).Propertites.TextHint := TdxUITextProperties(AProperties).TextHint;
  TuDEdit(Result).Propertites.TextHintColor := TdxUITextProperties(AProperties).TextHintColor;
  TuDEdit(Result).Font.Color := TdxUITextProperties(AProperties).FontColor;
  TuDEdit(Result).Color := TdxUITextProperties(AProperties).BgColor;
  TuDEdit(Result).NumbersOnly := TdxUITextProperties(AProperties).NumberOnly;
  TuDEdit(Result).EnableFocus := True;
end;

function TdxClientWindowManager.CreateUIElement(DParent: TDControl; Kind: TdxUIKind; AProperties: TdxCustomUIProperties; const WinName: String): TDControl;
begin
  Result := nil;
  case Kind of
    ukButton:     Result  :=  CreateUIButton(DParent, AProperties, WinName);
    ukLabel:      Result  :=  CreateUILabel(DParent, AProperties, WinName);
    ukControl:    Result  :=  CreateUIControl(DParent, AProperties, WinName);
    ukText:       Result  :=  CreateUIText(DParent, AProperties, WinName);
  end;
end;

function TdxClientWindowManager.CreateUILabel(DParent: TDControl;
  AProperties: TdxCustomUIProperties; const WinName: String): TDControl;
begin
  Result  :=  TuDLabel.Create(FWinForm);
  SetUIProp(DParent, Result, AProperties);
  TuDLabel(Result).FWindowManager  :=  Self;
  TuDLabel(Result).FWinName  :=  WinName;
  TuDLabel(Result).Caption :=  TdxUILabelProperties(AProperties).Text.Text;
  TuDLabel(Result).Hint :=  TdxUILabelProperties(AProperties).Hint;
  TuDLabel(Result).FFontColor :=  TdxUILabelProperties(AProperties).Text.FontColor;
  TuDLabel(Result).FBorderColor :=  TdxUILabelProperties(AProperties).Text.BorderColor;
  TuDLabel(Result).BlendMode :=  AProperties.BlendMode;
end;

function TdxClientWindowManager.CreateUIWindow(DParent: TDControl;
  AProperties: TdxCustomUIProperties; const WinName: String; Visible: Boolean): TDControl;
begin
  Result  :=  TuDWindow.Create(FWinForm);
  TuDWindow(Result).FWindowManager  :=  Self;
  TuDWindow(Result).FWinName  :=  WinName;
  TuDWindow(Result).BlendMode     :=  AProperties.BlendMode;
  Result.Visible := Visible;
  SetUIProp(DParent, Result, AProperties);
  TuDWindow(Result).Transpant :=  AProperties.Transpant;
  TuDWindow(Result).Floating  :=  TdxUIWindowProperties(AProperties).Floating;
  TuDWindow(Result).FMsgTop   :=  TdxUIWindowProperties(AProperties).Memo.Top;
  TuDWindow(Result).FMsgLeft  :=  TdxUIWindowProperties(AProperties).Memo.Left;
  TuDWindow(Result).AllowESC  :=  TdxUIWindowProperties(AProperties).AllowESC;
end;

function TdxClientWindowManager.CreateWindow(ADxParent: TDControl;
  AWindowItem: TdxUIWindow; const Visible: Boolean): TuDWindow;
var
  I: Integer;
begin
  if FWinForm = nil then Exit;

  Result := CreateUIWindow(ADxParent, AWindowItem.Properties, AWindowItem.Name, Visible) as TuDWindow;
  Result.Visible := Visible;
  AWindowItem.Properties.DControl :=  Result;
  Result.Left  :=  0;
  Result.Top   :=  0;
  case AWindowItem.Properties.Position of
    wpScreenCenter:
    begin
      Result.Left  :=  (FScreenWidth - AWindowItem.Properties.Width) div 2;
      Result.Top   :=  (FScreenHeight - AWindowItem.Properties.Height) div 2;
    end;
    wpRightTop:
    begin
      Result.Left  :=  FScreenWidth - AWindowItem.Properties.Width;
    end;
    wpTopCenter:
    begin
      Result.Left  :=  (FScreenWidth - AWindowItem.Properties.Width) div 2;
    end;
    wpBottomCenter:
    begin
      Result.Left  :=  (FScreenWidth - AWindowItem.Properties.Width) div 2;
      Result.Top   :=  (FScreenHeight - AWindowItem.Properties.Height) - 251;
    end;
  end;
  if Assigned(FOnCreateUI) then
    FOnCreateUI(Result);
  for I := 0 to AWindowItem.Children.Count - 1 do
    CreateUI(Result, AWindowItem.Children.Items[I], AWindowItem.Name);
  if AWindowItem.EnableArmComponent then
    for I := 0 to AWindowItem.ItemContainers.Count - 1 do
      CreateItemControl(Result, AWindowItem.ItemContainers.Items[I], AWindowItem.Name);
end;

destructor TdxClientWindowManager.Destroy;
var
  I: Integer;
begin
  for I := 0 to FSmallEffects.Count - 1 do
    FSmallEffects[I].Free;
  FreeAndNilEx(FSmallEffects);
  for I := 0 to FInnerEffects.Count - 1 do
    FInnerEffects[I].Free;
  FreeAndNilEx(FInnerEffects);
  for I := 0 to FOuterEffects.Count - 1 do
    FOuterEffects[I].Free;
  FreeAndNilEx(FOuterEffects);
  inherited;
end;

procedure TdxClientWindowManager.DodxButtonClick(Sender: TObject; X, Y: integer);
var
  AWin: TuDWindow;
  AParent: TDControl;
begin
  case TuDButton(Sender).FButtonHandler.Event of
    beCommand:
    begin
      DoSelect(TuDButton(Sender).FWinName, TuDButton(Sender).FButtonHandler.Command);
    end;
    beCloseWindow:
    begin
      if TuDButton(Sender).FButtonHandler.Command<>'' then
      begin
        if TryGet(TuDButton(Sender).FButtonHandler.Command, AWin) then
          AWin.Visible  :=  False;
      end
      else
      begin
        AParent :=  TuDButton(Sender).DParent;
        while (AParent<>nil) and not (AParent is TuDWindow) do
          AParent :=  AParent.DParent;
        if AParent<>nil then
        begin
          if AParent is TuDWindow then
            TuDWindow(AParent).Visible  :=  False
          else
            AParent.Visible :=  False;
        end;
      end;
    end;
    beOpenWindow:
    begin
      if TryGet(TuDButton(Sender).FButtonHandler.Command, AWin) then
        AWin.Visible  :=  True;
    end;
  end;
end;

procedure TdxClientWindowManager.MoveInCommandNode(Sender: TObject; ACommandNode: TMessageNode; X, Y: Integer);
begin
  if Assigned(FOnMoveInCommandNode) then
    FOnMoveInCommandNode(Sender, ACommandNode, X, Y);
end;

procedure TdxClientWindowManager.ShowHint(Sender: TObject; const Hint: String; X, Y: Integer);
begin
  if Assigned(FOnMoveInHint) then
    FOnMoveInHint(Sender, Hint, X, Y);
end;

function TdxClientWindowManager.GetItemIndexes(AWindow: TdxUIWindow): String;
var
  I: Integer;
  Temp: TClientItem;
begin
  Result := '';
  if AWindow.EnableArmComponent then
  begin
    for I := 0 to AWindow.ItemContainers.Count - 1 do
    begin
      if Result <> '' then
        Result :=  Result + ',';
      if (AWindow.ItemContainers.Items[I].DControl<>nil) then
      begin
        Temp  :=  TuDItemControl(AWindow.ItemContainers.Items[I].DControl).ClientItem;
        if (Temp.MakeIndex>0) and (Temp.Name<>'') then
          Result := Result + IntToStr(Temp.MakeIndex)
        else
          Result := Result + '0';
      end;
    end;
  end;
end;

function TdxClientWindowManager.GetParameters(AWindow: TdxUIWindow): String;
var
  I, ATextIndex: Integer;
  AValue: String;
begin
  Result := '';
  ATextIndex := 0;
  for I := 0 to AWindow.Children.Count - 1 do
  begin
    case AWindow.Children.Items[I].Kind of
      ukText:
      begin
        AValue := MakeMaskString(TuDEdit(AWindow.Children.Items[I].Properties.DControl).Text);
        if ATextIndex > 0 then
          Result := Result + ',';
        Result := Result + AValue;
        Inc(ATextIndex);
      end;
    end;
  end;
end;

procedure TdxClientWindowManager.DoSelect(const AWinName, ALabel: String);
var
  AWin: TdxUIWindow;
  ANewLabel, AItems, AParameters: String;
begin
  if not Assigned(FOnClick) then Exit;

  ANewLabel := ALabel;
  if TryGetWindowItem(AWinName, AWin) then
  begin
    AItems := GetItemIndexes(AWin);
    AParameters := GetParameters(AWin);
    if AParameters <> '' then
    begin
      if Pos(')', ANewLabel) > 0 then
        ANewLabel := StringReplace(ANewLabel, ')', ',' + AParameters + ')', [])
      else
        ANewLabel := ANewLabel + '(' + AParameters + ')';
    end;
    FOnClick(TuDWindow(AWin.Properties.DControl).Npc, ANewLabel, AWinName, AItems);
  end
  else
    FOnClick(-1, ANewLabel, '', '');
end;

procedure TdxClientWindowManager.ResetItems;
var
  I: Integer;
  J: Integer;
  Temp: TClientItem;
begin
  for I := 0 to UIItems.Count - 1 do
    for J := 0 to UIItems.Items[I].ItemContainers.Count - 1 do
    begin
      if UIItems.Items[I].ItemContainers.Items[J].DControl<>nil then
      begin
        Temp  :=  TuDItemControl(UIItems.Items[I].ItemContainers.Items[J].DControl).ClientItem;
        if (Temp.MakeIndex>0) and (Temp.Name<>'') then
          AddItemBag(Temp);
        FillChar(TuDItemControl(UIItems.Items[I].ItemContainers.Items[J].DControl).ClientItem, ClientItemSize, #0);
      end;
    end;
end;

procedure TdxClientWindowManager.SetUIProp(DParent, DUI: TDControl;
  AProperties: TdxCustomUIProperties);
begin
  DUI.Parent  :=  FWinForm;
  DUI.DParent :=  DParent;
  DParent.AddChild(DUI);
  DUI.Left    :=  AProperties.Left;
  DUI.Top     :=  AProperties.Top;
  if DUI is TDButton then
  begin
    case AProperties.ClickSound of
      ucsNone:  TDButton(DUI).Propertites.Sound  :=  TClickSound.csNone;
      ucsGlass: TDButton(DUI).Propertites.Sound  :=  TClickSound.csGlass;
      ucsNorm:  TDButton(DUI).Propertites.Sound  :=  TClickSound.csNorm;
      ucsStone: TDButton(DUI).Propertites.Sound  :=  TClickSound.csStone;
    end;
  end;
  DUI.SetImgIndex(FindWLib(AProperties.DataName), AProperties.ImgIndex);
  if AProperties.Width>0 then
    DUI.Width   :=  AProperties.Width;
  if AProperties.Height>0 then
    DUI.Height  :=  AProperties.Height;
end;

function TdxClientWindowManager.CreateEffect(EffectID: Integer): TEffect;
var
  I: Integer;
begin
  Result  :=  nil;
  for I := 0 to Effectes.Count - 1 do
    if Effectes.Items[I].ID = EffectID then
    begin
      Result  :=  CreateClientEffect(Effectes.Items[I]);
      Exit;
    end;
end;

function TdxClientWindowManager.ShowWindow(IsUpdate: Boolean; AMerchant: Integer; const AName, AMessage: String): Boolean;
var
  AWin: TuDWindow;
  AWinItem: TdxUIWindow;
  I: Integer;
begin
  Result := False;
  if TryGetWindowItem(AName, AWinItem) then
  begin
    CheckWindowCreated(AWinItem);
    if AWinItem.Properties.DControl <> nil then
    begin
      Result := True;
      AWin  :=  TuDWindow(AWinItem.Properties.DControl);
      AWin.Npc := AMerchant;
      if not IsUpdate then
      begin
        for I := 0 to AWinItem.Children.Count - 1 do
        begin
          if AWinItem.Children.Items[I].Kind = ukText then
            TuDEdit(AWinItem.Children.Items[I].Properties.DControl).Text := '';
        end;
         //注释掉以下 每次打开窗口更新都要更新UI位置  随云 2016-5-17
        {AWin.Left  :=  0;
        AWin.Top   :=  0;
        case AWinItem.Properties.Position of
          wpScreenCenter:
          begin
            AWin.Left  :=  (FScreenWidth - AWinItem.Properties.Width) div 2;
            AWin.Top   :=  (FScreenHeight - AWinItem.Properties.Height) div 2;
          end;
          wpRightTop:
          begin
            AWin.Left  :=  FScreenWidth - AWinItem.Properties.Width;
          end;
          wpTopCenter:
          begin
            AWin.Left  :=  (FScreenWidth - AWinItem.Properties.Width) div 2;
          end;
          wpBottomCenter:
          begin
            AWin.Left  :=  (FScreenWidth - AWinItem.Properties.Width) div 2;
            AWin.Top   :=  FScreenHeight - AWinItem.Properties.Height;
          end;
        end;
        if AWin.Left<0 then
          AWin.Left :=  0;
        if AWin.Top<0 then
          AWin.Top  :=  0;  }
      end
      else if not AWin.Visible then
      begin
        Result := False;
        Exit;
      end;
      AWin.Message  :=  AMessage;
      AWin.Visible  :=  True;
    end;
  end;
end;

function TdxClientWindowManager.TryGet(const AName: String; out AWin: TuDWindow): Boolean;
var
  AWinItem: TdxUIWindow;
begin
  Result := TryGetWindowItem(AName, AWinItem);
  if Result then
  begin
    CheckWindowCreated(AWinItem);
    AWin  :=  TuDWindow(AWinItem.Properties.DControl);
  end;
end;

function TdxClientWindowManager.TryGetItemSmallEffect(EffectID: Integer;
  out AEffect: TItemSmallEffect): Boolean;
var
  I: Integer;
begin
  Result := False;
  AEffect := nil;
  for I := 0 to self.FSmallEffects.Count - 1 do
    if FSmallEffects[I].ID = EffectID then
    begin
      AEffect := FSmallEffects[I];
      Result := True;
      Break;
    end;
end;

function TdxClientWindowManager.CreateItemInnerEffect(AEffect: TdxItemInnerEffect): TItemInnerEffect;
begin
  Result := nil;
  if AEffect <> nil then
  begin
    Result := TItemInnerEffect.Create;
    Result.ID := AEffect.ID;
    Result.TimeTick := GetTickCount;
    Result.Intrval := AEffect.Intrval;
    Result.Count := AEffect.Count;
    if Result.Count <= 0 then
      Result.Count := 1;
    Result.Start := AEffect.Start;
    Result.Lib := FindWLib(AEffect.LibFile);
    Result.Intrval := AEffect.Intrval;
    Result.OffsetX := AEffect.OffsetX;
    Result.OffsetY := AEffect.OffsetY;
    Result.BlendMode := AEffect.BlendMode;
  end;
end;

function TdxClientWindowManager.TryGetItemInnerEffect(EffectID: Integer; out AEffect: TItemInnerEffect): Boolean;
var
  I: Integer;
begin
  Result := False;
  AEffect := nil;
  for I := 0 to FInnerEffects.Count - 1 do
    if FInnerEffects[I].ID = EffectID then
    begin
      AEffect := FInnerEffects[I];
      Result := True;
      Break;
    end;
end;

function TdxClientWindowManager.CreateItemOuterEffect(AEffect: TdxItemOuterEffect): TItemOuterEffect;
begin
  Result := nil;
  if AEffect <> nil then
  begin
    Result := TItemOuterEffect.Create;
    Result.ID := AEffect.ID;
    Result.Start := AEffect.Start;
    Result.Lib := FindWLib(AEffect.LibFile);
    Result.OffsetX := AEffect.OffsetX;
    Result.OffsetY := AEffect.OffsetY;
  end;
end;

function TdxClientWindowManager.TryGetItemOuterEffect(EffectID: Integer; out AEffect: TItemOuterEffect): Boolean;
var
  I: Integer;
begin
  Result := False;
  AEffect := nil;
  for I := 0 to FOuterEffects.Count - 1 do
    if FOuterEffects[I].ID = EffectID then
    begin
      AEffect := FOuterEffects[I];
      Result := True;
      Break;
    end;
end;

{ TuDItemControl }

constructor TuDItemControl.Create(AOwner: TComponent);
begin
  inherited;
  EnableFocus := False;
  Names :=  TStringList.Create;
  FillChar(ClientItem, ClientItemSize, #0);
  OnClick :=  DoClick;
  OnMouseMove :=  DoMouseMove;
  FNode := TMessageNode.Create;
  FWinName := '';
  FTakeOnMethod := '';
  FTakeOffMethod := '';
  NoSaveUI := True;
end;

destructor TuDItemControl.Destroy;
begin
  FreeAndNilEx(Names);
  FreeAndNilEx(FNode);
  inherited;
end;

procedure TuDItemControl.DirectPaint(dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  if Propertites.Images<>nil then
  begin
    D :=  Propertites.Images.Images[Propertites.ImageIndex];
    if D <> nil then
    begin
      if FBlendMode > 0 then
        DSurface.DrawBlend(SurfaceX(Left), SurfaceY(Top), D, FBlendMode)
      else
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D);
    end;
  end;
  DrawItem(ClientItem, dsurface, SurfaceX(Left), SurfaceY(Top), Width, HeighT, TimeTick);
end;

procedure TuDItemControl.DoClick(Sender: TObject; X, Y: Integer);
var
  temp: TClientItem;
  Butt: TDButton;
  sel:  Integer;
begin
  if g_boLockMoveItem then
    Exit;
  if not g_boItemMoving then
  begin
    if ClientItem.Name <> '' then
    begin
      g_SoundManager.ItemClickSound(ClientItem.s);
      g_boItemMoving := TRUE;
      g_MovingItem.FromIndex := -200;
      g_MovingItem.Source := msCustomItem;
      g_MovingItem.Item   :=  ClientItem;
      FillChar(ClientItem, ClientItemSize, #0);
      if FTakeOffMethod <> '' then
        FWindowManager.DoSelect(FWinName, FTakeOffMethod);
    end;
  end
  else
  begin
    if ItemCanDrop(g_MovingItem.Item) then
    begin
      g_SoundManager.ItemClickSound(g_MovingItem.Item.s);
      if ClientItem.Name <> '' then
      begin
        temp := ClientItem;
        ClientItem := g_MovingItem.Item;
        g_MovingItem.FromIndex := 10000;
        g_MovingItem.Source := msCustomItem;
        g_MovingItem.Item := Temp
      end
      else
      begin
        ClientItem := g_MovingItem.Item;
        g_MovingItem.Item.Name := '';
        g_boItemMoving := False;
      end;
      if FTakeOnMethod <> '' then
        FWindowManager.DoSelect(FWinName, FTakeOnMethod);
    end;
  end;
end;

procedure TuDItemControl.DoMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ClientItem.Name <> '' then
  begin
    FNode.Item := ClientItem;
    FWindowManager.MoveInCommandNode(Self, FNode, X, Y);
  end
  else
    FWindowManager.ShowHint(Self, Hint, X, Y);
end;

function TuDItemControl.ItemCanDrop(AItem: TClientItem): Boolean;
begin
  Result  :=  False;
  if g_MovingItem.Source in [msBag, msCustomItem] then
  begin
    if (g_MovingItem.FromIndex >= 0) or (g_MovingItem.FromIndex=-200) then
      case FItemMode of
        ucmStdMode: Result := (Names.Count = 0) or (Names.IndexOf(IntToStr(AItem.S.StdMode)) <> -1);
        ucmItemName: Result :=  (Names.Count = 0) or (Names.IndexOf(AItem.Name) <> -1);
      end;
  end;
end;

{ TEffect }

procedure TEffect.Clear;
var
  I: Integer;
begin
  for I := 0 to FPrelude.Count - 1 do
    FPrelude.Items[I].Free;
  FPrelude.Clear;
  for I := 0 to FFrames.Count - 1 do
    FFrames.Items[I].Free;
  FTheEnd.Clear;
  for I := 0 to FTheEnd.Count - 1 do
    FTheEnd.Items[I].Free;
  FTheEnd.Clear;
end;

constructor TEffect.Create;
begin
  FPrelude  :=  TList<TEffectFrame>.Create;
  FFrames   :=  TList<TEffectFrame>.Create;
  FTheEnd   :=  TList<TEffectFrame>.Create;
  FCurFrame :=  nil;
  FLastTick :=  0;
  FStep :=  0;
  FCurrentFrame :=  0;
  FStop :=  False;
  FLoop :=  0;
  LoopMax  :=  1;
  FPreludeSound :=  '';
  FFramesSound  :=  '';
  FTheEndSound  :=  '';
end;

destructor TEffect.Destroy;
begin
  Clear;
  FPrelude.Free;
  FFrames.Free;
  FTheEnd.Free;
  inherited;
end;

procedure TEffect.DoEndFrame;
begin
  if Assigned(FOnEndFrame) then
    FOnEndFrame(Self);
end;

procedure TEffect.DoSoundFile(const AFileName: String);
begin
  if (AFileName<>'') and Assigned(FOnSoundEvent) then
    FOnSoundEvent(Self, AFileName);
end;

function TEffect.GetNextFrame: TEffectFrame;
begin
  Result  :=  nil;
  case FStep of
    0:
    begin
      if (FPrelude.Count > 0) and (FCurrentFrame <= FPrelude.Count) then
      begin
        Result  :=  FPrelude.Items[FCurrentFrame];
        if FCurrentFrame = 0 then
          DoSoundFile(FPreludeSound);
        Inc(FCurrentFrame);
        if FCurrentFrame > FPrelude.Count - 1 then
        begin
          FCurrentFrame :=  0;
          Inc(FStep);
        end;
      end
      else
      begin
        FCurrentFrame :=  0;
        Inc(FStep);
        Result  :=  GetNextFrame;
      end;
    end;
    1:
    begin
      if (FFrames.Count > 0) and (FCurrentFrame <= FFrames.Count - 1) then
      begin
        if FCurrentFrame = 0 then
          DoSoundFile(FFramesSound);
        Result  :=  FFrames.Items[FCurrentFrame];
        Inc(FCurrentFrame);
        if FCurrentFrame > FFrames.Count - 1 then
        begin
          FCurrentFrame :=  0;
          Inc(FLoop);
          if FStop or ((LoopMax>0) and (FLoop >= LoopMax)) then
            Inc(FStep);
        end;
      end
      else
      begin
        FCurrentFrame :=  0;
        Inc(FStep);
        Result  :=  GetNextFrame;
      end;
    end;
    2:
    begin
      if (FTheEnd.Count > 0) and (FCurrentFrame <= FTheEnd.Count - 1) then
      begin
        if FCurrentFrame = 0 then
          DoSoundFile(FTheEndSound);
        Result  :=  FTheEnd.Items[FCurrentFrame];
        Inc(FCurrentFrame);
        if FCurrentFrame > FTheEnd.Count - 1 then
        begin
          FCurrentFrame :=  0;
          Inc(FStep);
        end;
      end;
    end;
    3:
    begin
      FCanDraw :=  False;
      DoEndFrame;
    end;
  end;
end;

procedure TEffect.Initializa;
var
  I, W, H: Integer;
begin
  FMaxWidth :=  0;
  FMaxHeight  :=  0;
  for I := 0 to FPrelude.Count - 1 do
    if FPrelude.Items[I].Lib <> nil then
      if FPrelude.Items[I].ImgIndex >= 0 then
      begin
        if FPrelude.Items[I].Lib.GetImgSize(FPrelude.Items[I].ImgIndex, W, H) then
        begin
          FMaxWidth  :=  Max(FMaxWidth, W);
          FMaxHeight :=  Max(FMaxHeight, H);
        end;
      end;
  for I := 0 to FFrames.Count - 1 do
    if FFrames.Items[I].Lib <> nil then
      if FFrames.Items[I].ImgIndex >= 0 then
      begin
        if FFrames.Items[I].Lib.GetImgSize(FFrames.Items[I].ImgIndex, W, H) then
        begin
          FMaxWidth  :=  Max(FMaxWidth, W);
          FMaxHeight :=  Max(FMaxHeight, H);
        end;
      end;
  for I := 0 to FTheEnd.Count - 1 do
    if FTheEnd.Items[I].Lib <> nil then
      if FTheEnd.Items[I].ImgIndex >= 0 then
      begin
        if FTheEnd.Items[I].Lib.GetImgSize(FTheEnd.Items[I].ImgIndex, W, H) then
        begin
          FMaxWidth  :=  Max(FMaxWidth, W);
          FMaxHeight :=  Max(FMaxHeight, H);
        end;
      end;
end;

procedure TEffect.Run;
begin
  if FCurFrame <> nil then
  begin
    if GetTickCount - FLastTick >= FCurFrame.Stay then
    begin
      FCurFrame :=  GetNextFrame;
      FLastTick :=  GetTickCount;
    end;
  end
  else
  begin
    FCurFrame :=  GetNextFrame;
    FLastTick :=  GetTickCount;
  end;
  FCanDraw := FCurFrame <> nil;
end;

procedure TEffect.AddPreludeFrame(AFrame: TEffectFrame);
begin
  FPrelude.Add(AFrame);
end;

procedure TEffect.AddFrame(AFrame: TEffectFrame);
begin
  FFrames.Add(AFrame);
end;

procedure TEffect.AddEndFrame(AFrame: TEffectFrame);
begin
  FTheEnd.Add(AFrame);
end;

procedure TEffect.Draw(dsurface: TAsphyreCanvas; X, Y: Integer);
var
  D: TAsphyreLockableTexture;
begin
  if not FCanDraw then Exit;

  if FCurFrame <> nil then
  begin
    if FCurFrame.Lib<>nil then
    begin
      D :=  FCurFrame.Lib.Images[FCurFrame.ImgIndex];
      if D <> nil then
      begin
        if FCurFrame.Alpha > 0 then
          DSurface.DrawBlend(X + FCurFrame.OffsetX + FOffsetX, Y + FCurFrame.OffsetY + FOffsetY, D, FCurFrame.Alpha)
        else
          dsurface.Draw(X + FCurFrame.OffsetX + FOffsetX, Y + FCurFrame.OffsetY + FOffsetY, D, True);
      end;
    end;
  end
  else
    FCanDraw :=  False;
end;

procedure TEffect.Stop;
begin
  FStop :=  True;
end;

{ TItemSmallEffect }

procedure TItemSmallEffect.Draw(DSurface: TAsphyreCanvas; CellWidth, CellHeight, X, Y: Integer);
var
  D: TAsphyreLockableTexture;
  ax, ay: Integer;
begin
  if Lib <> nil then
  begin
    D := Lib.GetCachedImage(Start + (GetTickCount - TimeTick) div Intrval mod Count, ax, ay);
    if D <> nil then
      DSurface.DrawBlendEffect(X - (D.Width - CellWidth) div 2 + OffsetX, Y - (D.Height - CellHeight) div 2 + OffsetY, D, BlendMode);
  end;
end;

{ TItemInnerEffect }

procedure TItemInnerEffect.Draw(DSurface: TAsphyreCanvas; X, Y: Integer);
begin
  StateDrawBlendEx(Lib, DSurface, X + OffsetX, Y + OffsetY, Start + (GetTickCount - TimeTick) div Intrval mod Count, BlendMode);
end;

procedure TItemInnerEffect.Draw(DSurface: TAsphyreCanvas; CellWidth, CellHeight,
  X, Y: Integer);
var
  D: TAsphyreLockableTexture;
  ax, ay: Integer;
begin
  if (Lib <> nil) then
  begin
    D := Lib.GetCachedImage(Start + (GetTickCount - TimeTick) div Intrval mod Count, ax, ay);
    if D <> nil then
      DSurface.DrawBlendEffect(X - (D.Width - CellWidth) div 2 + OffsetX + ax, Y - (D.Height - CellHeight) div 2 + OffsetY + ay, D, BlendMode);
  end;
end;

{ TItemOuterEffect }

function TItemOuterEffect.GetImage(CurrentFrame: Integer; var ax, ay: Integer): TAsphyreLockableTexture;
begin
  if Lib <> nil then
  begin
    Result := Lib.GetCachedImage(Start + CurrentFrame, ax, ay);
    ax := ax + OffsetX;
    ay := ay + OffsetY;
  end
  else
  begin
    Result := nil;
    ax := 0;
    ay := 0;
  end;
end;

{ TuDBufferControl }

constructor TuDBufferControl.Create(AOwner: TComponent);
begin
  inherited;
  Height := 24;
  Width := 24;
  FBufferItem := nil;
  FIconImages := nil;
  FHoverIconImages := nil;
  FPermannent := False;
  NoSaveUI := True;
end;

destructor TuDBufferControl.Destroy;
begin

  inherited;
end;

procedure TuDBufferControl.DirectPaint(dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ATimeStr: String;
  AText: TAsphyreLockableTexture;
  ATick: Integer;
  AShow: Boolean;
begin
  FStartTick := GetTickCount;
  ATick := FEndTick - FStartTick;
  if FIconImages <> nil then
  begin
    D := nil;
    AShow := True;
    if FBufferItem.FlashBeforeHide and (ATick div 1000 <= FBufferItem.FlashBeforeHideTime) then
      AShow := (ATick div 500) mod 2 = 0;
    if AShow then
    begin
      if Moveed and (FHoverIconImages <> nil) then
        D := FHoverIconImages.Images[FBufferItem.HoverImage.ImageIndex];
      if D = nil then
        D := FIconImages.Images[FBufferItem.Image.ImageIndex];
      if D <> nil then
      begin
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D);
        if FBufferItem.ShowTime then
        begin
          if ATick > 0 then
          begin
            ATimeStr := TimeToStr(ATick);
            if ATimeStr <> '' then
            begin
              AText := FontManager.Default.TextOut(ATimeStr);
              if AText <> nil then
                dsurface.DrawBoldText(SurfaceX(Left) + (D.Width - AText.Width) div 2, SurfaceY(Top) + D.Height, AText, clWhite, FontBorderColor);
            end;
          end
          else
          begin
            if Assigned(FOnTimeEnd) then
              FOnTimeEnd(Self);
          end;
        end;
      end;
    end;
  end;
end;

procedure TuDBufferControl.SetBufferItem(const Value: TdxUIBufferItem);
var
  D: TAsphyreLockableTexture;
  AWidth, AHeight: Integer;
begin
  FBufferItem := Value;
  FIconImages := nil;
  FHoverIconImages := nil;
  if FBufferItem <> nil then
  begin
    FIconImages := FindWLib(FBufferItem.Image.LibFile);
    FHoverIconImages := FindWLib(FBufferItem.HoverImage.LibFile);
    if FIconImages <> nil then
    begin
      if FIconImages.GetImgSize(FBufferItem.Image.ImageIndex, AWidth, AHeight) then
      begin
        Width := AWidth;
        Height := AHeight;
      end;
    end;
  end;
end;

function TuDBufferControl.TimeToStr(ATick: Integer): String;
begin
  Result := '';
  if ATick >= 3600000 then
  begin
    Result := IntToStr(ATick div 3600000) + '时';
    ATick := ATick mod 3600000;
    ATick := ATick - (ATick mod 3600000);
    if ATick < 60000 then
      ATick := 0;
  end;
  if ATick >= 60000 then
  begin
    Result := Result + IntToStr(ATick div 60000) + '分';
    ATick := ATick mod 60000;
  end;
  if ATick > 0 then
    Result := Result + IntToStr(Ceil(ATick / 1000)) + '秒';
end;

{ TuDEdit }

constructor TuDEdit.Create(AOwner: TComponent);
begin
  inherited;
  NoSaveUI := True;
end;

procedure TuDEdit.DirectPaint(DSurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  if Propertites.Images <> nil then
  begin
    D := Propertites.Images.Images[Propertites.ImageIndex];
    if D <> nil then
      DSurface.Draw(SurfaceX(Left) + FOffsetX, SurfaceY(Top) + FOffsetY, D, True);
  end;
  inherited;
end;

initialization
  PropertiesResetSize :=  DoPropertiesResetSize;

end.
