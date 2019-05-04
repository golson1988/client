unit PlayScn;

interface

{$I Client.inc}

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, IntroScn, Grobal2, CliUtil,
  HUtil32, Math, Actor, HerbActor, AxeMon, SoundUtil, ClEvent, Wil, StdCtrls, clFunc,
  Magiceff, extctrls, MShare, Share, Generics.Collections, uTextures, uInputString,
  AbstractCanvas, AbstractTextures, AbstractDevices, DXHelper, AsphyreFactory, AsphyreTypes,
  ClipBrd, MMSystem, uMagicMgr{$IFDEF VirtualMap}, uVirtualMap{$ENDIF}, uLog, Common,uSyncObj;

const
  LONGHEIGHT_IMAGE = 35;
  FLASHBASE = 410;
  AAX = 16;
  { 20080816注释显示黑暗
    LMX = 30;
    LMY = 26; }

  { 20080816注释显示黑暗
    MAXLIGHT = 5;
    LightFiles : array[0..MAXLIGHT] of string = (
    'Data\lig0a.dat',
    'Data\lig0b.dat',
    'Data\lig0c.dat',
    'Data\lig0d.dat',
    'Data\lig0e.dat',
    'Data\lig0f.dat'
    );

    LightMask0 : array[0..2, 0..2] of shortint = (
    (0,1,0),
    (1,3,1),
    (0,1,0)
    );
    LightMask1 : array[0..4, 0..4] of shortint = (
    (0,1,1,1,0),
    (1,1,3,1,1),
    (1,3,4,3,1),
    (1,1,3,1,1),
    (0,1,2,1,0)
    );
    LightMask2 : array[0..8, 0..8] of shortint = (
    (0,0,0,1,1,1,0,0,0),
    (0,0,1,2,3,2,1,0,0),
    (0,1,2,3,4,3,2,1,0),
    (1,2,3,4,4,4,3,2,1),
    (1,3,4,4,4,4,4,3,1),
    (1,2,3,4,4,4,3,2,1),
    (0,1,2,3,4,3,2,1,0),
    (0,0,1,2,3,2,1,0,0),
    (0,0,0,1,1,1,0,0,0)
    );
    LightMask3 : array[0..10, 0..10] of shortint = (
    (0,0,0,0,1,1,1,0,0,0,0),
    (0,0,0,1,2,2,2,1,0,0,0),
    (0,0,1,2,3,3,3,2,1,0,0),
    (0,1,2,3,4,4,4,3,2,1,0),
    (1,2,3,4,4,4,4,4,3,2,1),
    (2,3,4,4,4,4,4,4,4,3,2),
    (1,2,3,4,4,4,4,4,3,2,1),
    (0,1,2,3,4,4,4,3,2,1,0),
    (0,0,1,2,3,3,3,2,1,0,0),
    (0,0,0,1,2,2,2,1,0,0,0),
    (0,0,0,0,1,1,1,0,0,0,0)
    );

    LightMask4 : array[0..14, 0..14] of shortint = (
    (0,0,0,0,0,0,1,1,1,0,0,0,0,0,0),
    (0,0,0,0,0,1,1,1,1,1,0,0,0,0,0),
    (0,0,0,0,1,1,2,2,2,1,1,0,0,0,0),
    (0,0,0,1,1,2,3,3,3,2,1,1,0,0,0),
    (0,0,1,1,2,3,4,4,4,3,2,1,1,0,0),
    (0,1,1,2,3,4,4,4,4,4,3,2,1,1,0),
    (1,1,2,3,4,4,4,4,4,4,4,3,2,1,1),
    (1,2,3,4,4,4,4,4,4,4,4,4,3,2,1),
    (1,1,2,3,4,4,4,4,4,4,4,3,2,1,1),
    (0,1,1,2,3,4,4,4,4,4,3,2,1,1,0),
    (0,0,1,1,2,3,4,4,4,3,2,1,1,0,0),
    (0,0,0,1,1,2,3,3,3,2,1,1,0,0,0),
    (0,0,0,0,1,1,2,2,2,1,1,0,0,0,0),
    (0,0,0,0,0,1,1,1,1,1,0,0,0,0,0),
    (0,0,0,0,0,0,1,1,1,0,0,0,0,0,0)
    );

    LightMask5 : array[0..16, 0..16] of shortint = (
    (0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0),
    (0,0,0,0,0,0,1,2,2,2,1,0,0,0,0,0,0),
    (0,0,0,0,0,1,2,4,4,4,2,1,0,0,0,0,0),
    (0,0,0,0,1,2,4,4,4,4,4,2,1,0,0,0,0),
    (0,0,0,1,2,4,4,4,4,4,4,4,2,1,0,0,0),
    (0,0,1,2,4,4,4,4,4,4,4,4,4,2,1,0,0),
    (0,1,2,4,4,4,4,4,4,4,4,4,4,4,2,1,0),
    (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
    (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
    (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
    (0,1,2,4,4,4,4,4,4,4,4,4,4,4,2,1,0),
    (0,0,1,2,4,4,4,4,4,4,4,4,4,2,1,0,0),
    (0,0,0,1,2,4,4,4,4,4,4,4,2,1,0,0,0),
    (0,0,0,0,1,2,4,4,4,4,4,2,1,0,0,0,0),
    (0,0,0,0,0,1,2,4,4,4,2,1,0,0,0,0,0),
    (0,0,0,0,0,0,1,2,2,2,1,0,0,0,0,0,0),
    (0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0)
    ); }

type
  // PShoftInt = ^ShortInt;
  { 20080816注释显示黑暗
    TLightEffect = record
    Width: integer;
    Height: integer;
    PFog: Pbyte;
    end;
    TLightMapInfo = record
    ShiftX: integer;
    ShiftY: integer;
    light:  integer;
    bright: integer;
    end; }
  TActorHookProc = reference to procedure(Sender: TActor);

  pTPlaySceneDelayMessage = ^TPlaySceneDelayMessage;
  TPlaySceneDelayMessage = record
    MessageType:Byte; // 0 音效 1 特效
    SoundID:Integer;
    PlayTime:Cardinal; //播放的时间
  end;

  TPlayScene = class(TScene)
  private
    m_MapSurface: TAsphyreRenderTargetTexture;
    m_nAniCount:      Integer;
    m_nDefXX:         Integer;
    m_nDefYY:         Integer;
    m_MainSoundTimer: TTimer;
    m_MsgList:        TList;
    m_DelayMsg:       TList; //带延迟的场景消息 一般是特效延迟 或者声效延迟 随云。
    m_LastProcessDelayMsgTime:Cardinal;
    m_dwAniTime,
    m_dwMoveTime:      LongWord;
    m_btDark: Byte;
    procedure DrawTileMap(Sender: TObject);
    procedure SoundOnTimer(Sender: TObject);
    function CrashManEx(mx, my: Integer): Boolean;
    procedure ClearDropItem();
  public
    m_ActorList: TFixedThreadList;
    m_FreeActorList: TFixedThreadList;
    m_ActorIndex: Integer;
    m_EffectList: TList;
    m_FlyList: TList;
    m_TopMost: TList;

    procedure SetChatText(const S: String);
    procedure AddChatText(const S: String);
    procedure AddChatObjText(const S, Obj: String);

    constructor Create;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Finalize; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure OpeningScene; override;
    procedure BeginScene(Device: TAsphyreDevice; MSurface: TAsphyreCanvas); override;
    procedure PlayScene(MSurface: TAsphyreCanvas); override;
    function ButchAnimal(x, y: Integer): TActor;

    function FindActor(id: Integer): TActor; overload;
    function FindActor(const sName: String): TActor; overload;
    function FindActorXY(x, y: Integer): TActor;
    function IsValidActor(Actor: TActor): Boolean; inline;
    function NewActor(chrid: Integer; cx, cy, cdir: word; cfeature, cstate, properties, dressweapon: Integer): TActor;
    procedure ActorDied(Actor: TActor);
    procedure AddTopMostActor(Actor: TActor);
    procedure ClearActors;
    function DeleteActor(id: Integer): TActor;
    procedure DelActor(Actor: TObject);
    procedure SendMsg(ident, chrid, x, y, cdir, feature, state, properties, dressweapon: Integer; const str: string; AHookProc: TActorHookProc = nil);
    procedure AddDelaySound(SoundID:Integer;Delay:Integer); //添加场景延迟声效。
    procedure NewMagic(aowner: TActor; magid, magnumb, magStrengthen, mTag, cx, cy, tx, ty, targetcode: Integer; mtype: TMagicType; Recusion: Boolean; anitime: Integer; var bofly: Boolean); overload;
    procedure NewMagic(AOwner: TActor; AProperties: TuCustomMagicEffectProperties; magid, cx, cy, tx, ty, targetcode: Integer; Recusion: Boolean; anitime: Integer; var bofly: Boolean); overload;
    // procedure DelMagic (magid: integer);
    function NewFlyObject(aowner: TActor; cx, cy, tx, ty, targetcode: Integer; mtype: TMagicType): TMagicEff;
    procedure ScreenXYfromMCXY(cx, cy: Integer; var sx, sy: Integer); inline;
    procedure CXYfromMouseXY(mx, my: Integer; var ccx, ccy: Integer); inline;
    function GetCharacter(x, y, wantsel: Integer; var nowsel: Integer; liveonly: Boolean): TActor;
    function GetAttackFocusCharacter(x, y, wantsel: Integer; var nowsel: Integer; liveonly: Boolean): TActor;
    function IsSelectMyself(x, y: Integer): Boolean;
    function GetDropItems(x, y: Integer; out inames: string): PTDropItem;
    // function  GetXYDropItems (nX,nY:Integer):pTDropItem;
    procedure GetXYDropItemsList(nX, nY: Integer; var ItemList: TList);
    function CanRun(sx, sy, ex, ey: Integer): Boolean;
    function CanWalk(mx, my: Integer): Boolean;
    function CanWalkEx(mx, my: Integer): Boolean;
    function CrashMan(X, Y: Integer): Boolean;
    // function  CanFly (mx, my: integer): Boolean;
    // procedure RefreshScene;
    procedure CleanObjects;
    procedure ProcessObecjts;
    procedure ProcessDelayList;
  end;

implementation

uses
  AsphyreTextureFonts, ClMain, FState;

function GetReversalKind(Tag: Byte): TReversalKind; //inline;
begin
  Result := TReversalKind.rkNone;
  if Tag = 15 then
    Result := TReversalKind.rkHor;
end;

constructor TPlayScene.Create;
begin
  m_MsgList := TList.Create; // 消息列表
  m_ActorList := TFixedThreadList.Create; // 角色列表
  m_FreeActorList := TFixedThreadList.Create;
  // m_GroundEffectList := TList.Create; 20080721注释  没用到
  m_EffectList := TList.Create;
  m_FlyList := TList.Create;
  m_TopMost := TList.Create;
  m_dwBlinkTime := GetTickCount;
  m_boViewBlink := FALSE;

  m_dwAniTime := GetTickCount;
  m_nAniCount := 0;
  m_ActorIndex := 0;
  m_DelayMsg := TList.Create;
  if FrmMain <> nil then
  begin
    m_MainSoundTimer := TTimer.Create(FrmMain.Owner);
    with m_MainSoundTimer do
    begin
      OnTimer := SoundOnTimer;
      Interval := 1;
      Enabled := FALSE;
    end;
  end;
end;

destructor TPlayScene.Destroy;
var
  I: Integer;
  AList: TList;
begin
  if m_MsgList.Count > 0 then
  begin // 20080629
    for I := 0 to m_MsgList.Count - 1 do
      if pTChrMsg(m_MsgList.Items[I]) <> nil then
        Dispose(pTChrMsg(m_MsgList.Items[I]));
  end;
  FreeAndNilEx(m_MsgList);
  FreeAndNilEx(m_TopMost);

  AList := m_ActorList.LockList;
  try
    for I := 0 to AList.Count - 1 do
    begin
      if AList[I] <> nil then
        TObject(AList[I]).Free;
    end;
  finally
    m_ActorList.UnlockList;
  end;
  FreeAndNilEx(m_ActorList);

  AList := m_FreeActorList.LockList;
  try
    for I := 0 to AList.Count - 1 do
    begin
      if TActor(AList[I]) <> nil then
        TActor(AList[I]).Free;
    end;
    AList.Clear;
  finally
    m_FreeActorList.UnlockList;
  end;
  FreeAndNilEx(m_FreeActorList);
  if m_EffectList.Count > 0 then
  begin // 释放主类 20080718
    for I := 0 to m_EffectList.Count - 1 do
      if TMagicEff(m_EffectList[I]) <> nil then
        TMagicEff(m_EffectList[I]).Free;
  end;
  FreeAndNilEx(m_EffectList);
  if m_FlyList.Count > 0 then
  begin // 释放主类 20080718
    for I := 0 to m_FlyList.Count - 1 do
      if TMagicEff(m_FlyList.Items[I]) <> nil then
        TMagicEff(m_FlyList.Items[I]).Free;
  end;
  FreeAndNilEx(m_FlyList);


  if m_DelayMsg.Count > 0 then
  begin // 20080629
    for I := 0 to m_DelayMsg.Count - 1 do
      if m_DelayMsg.Items[I] <> nil then
        Dispose(pTPlaySceneDelayMessage(m_DelayMsg.Items[I]));
  end;
  m_DelayMsg.Free;

  inherited Destroy;
end;

// 游戏主场景的背景音乐（长度：43秒）
procedure TPlayScene.SoundOnTimer(Sender: TObject);
begin
  g_SoundManager.DXPlaySound(s_main_theme);
  m_MainSoundTimer.Interval := 46 * 1000;
end;

procedure TPlayScene.SetChatText(const S: String);
begin
  g_InputStr.Clear;
  g_InputStr.Append(S);
  FrmDlg.DEChat.Text := g_InputStr.Text;
  FrmDlg.DEChat.SelStart := Length(FrmDlg.DEChat.Text);
  FrmDlg.DEChat.SelLength := 0;
end;

procedure TPlayScene.AddChatText(const S: String);
var
  OldX: Integer;
begin
  OldX  :=  FrmDlg.DEChat.SelStart;
  g_InputStr.Insert(FrmDlg.DEChat.SelStart, S);
  FrmDlg.DEChat.Text :=  g_InputStr.Text;
  FrmDlg.DEChat.SelStart :=  OldX + Length(S);
end;

procedure TPlayScene.AddDelaySound(SoundID, Delay: Integer);
var
  PMsg : pTPlaySceneDelayMessage;
begin
  if Delay <= 0 then
  begin
    g_SoundManager.SkillEffectPlaySound(SoundID);
  end else
  begin
    New(PMsg);
    PMsg.MessageType := 0;
    PMsg.SoundID := SoundID;
    PMsg.PlayTime := GetTickCount() + Delay;
    m_DelayMsg.Add(PMsg);
  end;
end;

procedure TPlayScene.AddChatObjText(const S, Obj: String);
var
  OldX: Integer;
begin
  if g_InputStr.InsertObject(FrmDlg.DEChat.SelStart, S, Obj) then
  begin
    OldX  :=  FrmDlg.DEChat.SelStart;
    FrmDlg.DEChat.Text :=  g_InputStr.Text;
    FrmDlg.DEChat.SelStart :=  OldX + Length(S);
    FrmDlg.DEChat.SelLength := 0;
  end;
end;

// 初始化场景
procedure TPlayScene.Initialize;
begin
  m_MapSurface := Factory.CreateRenderTargetTexture;
  m_MapSurface.Format := apf_A8R8G8B8;
  m_MapSurface.SetSize(MAPSURFACEWIDTH + UNITX * 7, MAPSURFACEHEIGHT + UNITY * 6, True);
end;

procedure TPlayScene.Finalize;
begin
  if m_MapSurface <> nil then
    FreeAndNilEx(m_MapSurface);
end;

// 场景开始
procedure TPlayScene.OpenScene;
begin
  g_boDoFastFadeOut := False;
  g_WMainImages.ClearCache; // 释放场景
  FrmDlg.ViewBottomBox(True);
  FrmDlg.ViewHeadHealtBox(True);
  SetImeMode(FrmMain.Handle, imClose);
end;

// 关闭场景
procedure TPlayScene.CloseScene;
begin
  g_SoundManager.SilenceSound;
  FrmDlg.ViewBottomBox(FALSE);
  FrmDlg.ViewHeadHealtBox(FALSE);
  FrmDlg.ViewGroupHeadHealtBox(False);
end;

procedure TPlayScene.OpeningScene;
begin
end;

procedure TPlayScene.CleanObjects;
var
  I: Integer;
  AList: TList;
begin
  AList := m_ActorList.LockList;
  try
    for I := AList.Count - 1 downto 0 do
    begin
      if AList[I] <> g_MySelf then
      begin
        try
          TObject(AList[I]).Free;
        except
        end;
        AList.Delete(I);
      end;
    end;
  finally
    m_ActorList.UnlockList;
  end;
  m_MsgList.Clear;
  g_TargetCret := nil;
  g_FocusCret := nil;
  g_MagicTarget := nil;
  g_MagicLockActor := nil;

  if m_EffectList.Count > 0 then
  begin
    for I := 0 to m_EffectList.Count - 1 do
      TMagicEff(m_EffectList[I]).Free;
    m_EffectList.Clear;
  end;
  {$IFDEF VirtualMap}
  VirtualMap.Clear;
  {$ENDIF}
end;

// 画地图
procedure TPlayScene.DrawTileMap(Sender: TObject);
var
  I, j, nY, nX, nImgNumber: Integer;
  DSurface: TAsphyreLockableTexture;
  MirrorX: Boolean;
begin
  Map.m_OldClientRect := Map.m_ClientRect;
  with Map.m_ClientRect do
  begin
    nY := -UNITY * 2; // -32*2=-64
    for j := (Top - Map.m_nBlockTop - 2) to (Bottom - Map.m_nBlockTop + 2) do
    begin // 从地图顶部到下部
      nX := AAX + 14 - UNITX; // 16+14-48=-18
      for I := (Left - Map.m_nBlockLeft - 3) to (Right - Map.m_nBlockLeft + 2) do
      begin // 从左边到右边
        if (I >= 0) and (I < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then
        begin
          nImgNumber := (Map.m_MArr[I, j].wBkImg and $7FFF);
          if nImgNumber > 0 then
          begin
            if (I mod 2 = 0) and (j mod 2 = 0) then
            begin
              nImgNumber := nImgNumber - 1;
              GetTilesImages(Map.m_MArr[I, j].btBkIndex, nImgNumber, DSurface);
              if DSurface <> nil then
              begin
                g_GameCanvas.Draw(nX, nY, DSurface.ClientRect, DSurface, FALSE, GetReversalKind(Map.m_MArr[I, j].Reserved[10]));
              end;
            end;
          end;
        end;
        Inc(nX, UNITX);
      end;
      Inc(nY, UNITY);
    end;
  end;

  // 显示地上的草 比如比齐安全区的草
  with Map.m_ClientRect do
  begin
    nY := -UNITY * 2;
    for j := (Top - Map.m_nBlockTop - 2) to (Bottom - Map.m_nBlockTop + 2) do
    begin
      nX := AAX + 14 - UNITX;
      for I := (Left - Map.m_nBlockLeft - 3) to (Right - Map.m_nBlockLeft + 2) do
      begin
        if (I >= 0) and (I < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then
        begin
          nImgNumber := Map.m_MArr[I, j].wMidImg;
          if nImgNumber > 0 then
          begin
            nImgNumber := nImgNumber - 1;
            GetSmTilesImages(Map.m_MArr[I, j].btSmIndex, nImgNumber, DSurface);
            if DSurface <> nil then
              g_GameCanvas.Draw(nX, nY, DSurface.ClientRect, DSurface, True, GetReversalKind(Map.m_MArr[I, j].Reserved[10]));
          end;
        end;
        Inc(nX, UNITX);
      end;
      Inc(nY, UNITY);
    end;
  end;
end;

{ ----------------------- 器弊, 扼捞飘 贸府 ----------------------- }

{ 20080816注释显示黑暗
  //从文件中装载雾
  procedure TPlayScene.LoadFog;
  var
  i, fhandle, w, h, prevsize: integer;
  Cheat: Boolean;
  begin
  prevsize := 0; //炼累 眉农
  Cheat := FALSE;
  for i:=0 to MAXLIGHT do begin
  if FileExists (LightFiles[i]) then begin
  fhandle := FileOpen (LightFiles[i], fmOpenRead or fmShareDenyNone);
  FileRead (fhandle, w, sizeof(integer));
  FileRead (fhandle, h, sizeof(integer));
  m_Lights[i].Width := w;
  m_Lights[i].Height := h;
  m_Lights[i].PFog := AllocMem  (w * h + 8);
  if prevsize < w * h then begin
  FileRead (fhandle, m_Lights[i].PFog^, w*h);
  end else
  cheat := TRUE;
  prevsize := w * h;
  FileClose (fhandle);
  end;
  end;
  if cheat then
  for i:=0 to MAXLIGHT do begin
  if m_Lights[i].PFog <> nil then
  FillChar (m_Lights[i].PFog^, m_Lights[i].Width*m_Lights[i].Height+8, #0);
  end;
  end;
}
procedure TPlayScene.ClearDropItem;
var
  I:        Integer;
  DropItem: PTDropItem;
begin
  if g_DropedItemList.Count > 0 then
  begin
    for I := g_DropedItemList.Count - 1 downto 0 do
    begin
      DropItem := g_DropedItemList.Items[I];
      if DropItem = nil then
      begin
        g_DropedItemList.Delete(I);
        Continue;
      end;
      {$IFDEF VirtualMap}
      VirtualMap.CheckDrawItemInMap(DropItem.X, DropItem.Y, DropItem.boDraw);
      {$ENDIF}
      if (g_MySelf=nil) or ((ABS(DropItem.x - g_MySelf.m_nCurrX) > 20) and (ABS(DropItem.y - g_MySelf.m_nCurrY) > 20)) then
      begin
        System.Finalize(DropItem^);
        Dispose(DropItem);
        g_DropedItemList.Delete(I);
      end;
    end;
  end;
end;

procedure TPlayScene.BeginScene(Device: TAsphyreDevice; MSurface: TAsphyreCanvas);
begin
  if g_MySelf = nil then  Exit;
  
  try
    Map.m_ClientRect.Left := g_MySelf.m_nRx - MapLeftUnit;
    Map.m_ClientRect.Top := g_MySelf.m_nRy - MapTopUnit;
    Map.m_ClientRect.Right := g_MySelf.m_nRx + MapRightUnit;
    Map.m_ClientRect.Bottom := g_MySelf.m_nRy + MapBottomUnit;
    Map.UpdateMapPos(g_MySelf.m_nRx, g_MySelf.m_nRy);

    if g_boForceMapDraw then
    begin
      if g_boForceMapFileLoad then
        Map.LoadMap(Map.m_sCurrentMap, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY);
      g_boForceMapDraw := False;
      g_boForceMapFileLoad := False;
    end
    else
    begin
      with Map do
        if (m_ClientRect.Left = m_OldClientRect.Left) and (m_ClientRect.Top = m_OldClientRect.Top) then
          Exit;
    end;

    Device.RenderTo(DrawTileMap, 0, True, m_MapSurface);
  except
  end;
end;

// 画游戏正式场景
procedure TPlayScene.PlayScene(MSurface: TAsphyreCanvas);
var
  I, j, k, n, m, mmm, ix, iy, defx, defy, wunit, fridx, ani, anitick, ax, ay,mx,my: Integer;
  DSurface, d: TAsphyreLockableTexture;
  blend: Boolean;
  DropItem: PTDropItem;
  evn: TCustomEvent;
  Actor: TActor;
  meff: TMagicEff;
  ATexture: TAsphyreLockableTexture;
  OffsetY: Integer;
  AList: TList;
  ItemNameTexture : TuTexture;
begin
  if (g_MySelf = nil) then
  begin
    D :=  g_77Images.Images[244];
    if D <> nil then
      MSurface.Draw((SCREENWIDTH - D.Width) div 2, (SCREENHEIGHT - D.Height) div 2, D);
    ATexture  :=  FontManager.Default.TextOut('正在退出游戏，请稍后...');
    if ATexture <> nil then
      MSurface.DrawBoldText((SCREENWIDTH - ATexture.Width) div 2, (SCREENHEIGHT - ATexture.Height) div 2, ATexture, clWhite, FontBorderColor);
    Exit;
  end;

  if TimeGetTime - m_dwAniTime >= 50 then
  begin
    m_dwAniTime := TimeGetTime;
    Inc(m_nAniCount);
    if m_nAniCount > 100000 then
      m_nAniCount := 0;
  end;
  OffsetY := 1 - g_MySelf.m_nShiftY mod 2;
  MSurface.Draw(0, 0, Bounds(UNITX * 4 + g_MySelf.m_nShiftX, UNITY * 3 + g_MySelf.m_nShiftY - OffsetY, MAPSURFACEWIDTH, MAPSURFACEHEIGHT), m_MapSurface, False);

  defx := -UNITX * 2 - g_MySelf.m_nShiftX + AAX + 14;
  defy := -UNITY * 2 - g_MySelf.m_nShiftY;
  m_nDefXX := defx;
  m_nDefYY := defy;
  // 画地面上的物体，如房屋等
  try
    m := defy - UNITY + OffsetY;
    for j := (Map.m_ClientRect.Top - Map.m_nBlockTop) to (Map.m_ClientRect.Bottom - Map.m_nBlockTop + LONGHEIGHT_IMAGE) do
    begin
      if j < 0 then
      begin
        Inc(m, UNITY);
        Continue;
      end;
      n := defx - UNITX * 2;
      //48*32 是一个物体小图片的大小
      for I := (Map.m_ClientRect.Left - Map.m_nBlockLeft - 2) to (Map.m_ClientRect.Right - Map.m_nBlockLeft + 2 ) do
      begin
        if (I >= 0) and (I < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then
        begin
          fridx := (Map.m_MArr[I, j].wFrImg) and $7FFF;
          if fridx > 0 then
          begin
            ani := Map.m_MArr[I, j].btAniFrame;
            wunit := Map.m_MArr[I, j].btArea;
            if (ani and $80) > 0 then
            begin
              blend := True;
              ani := ani and $7F;
            end;
            if ani > 0 then
            begin
              anitick := Map.m_MArr[I, j].btAniTick;
              fridx := fridx + (m_nAniCount mod (ani + (ani * anitick))) div (1 + anitick);
            end;
            if (Map.m_MArr[I, j].btDoorOffset and $80) > 0 then
            begin
              if (Map.m_MArr[I, j].btDoorIndex and $7F) > 0 then
                fridx := fridx + (Map.m_MArr[I, j].btDoorOffset and $7F);
            end;
            fridx := fridx - 1;
            // 取图片
            GetObjs(wunit, fridx, DSurface);
            if DSurface <> nil then
            begin
              if (DSurface.Width = 48) and (DSurface.Height = 32) then
              begin
                mmm := m + UNITY - 32;
                if (n + 48 > 0) and (n <= SCREENWIDTH) and (mmm + 32 > 0) and (mmm < SCREENHEIGHT) then
                begin
                  MSurface.Draw(n, mmm, DSurface.ClientRect, DSurface, True, GetReversalKind(Map.m_MArr[I, j].Reserved[10]));
                end
                else
                begin
                  if mmm < SCREENHEIGHT then
                  begin
                    MSurface.Draw(n, mmm, DSurface.ClientRect, DSurface, True, GetReversalKind(Map.m_MArr[I, j].Reserved[10]));
                  end;
                end;
              end;
            end;
          end;
        end;
        Inc(n, UNITX);
      end;
      Inc(m, UNITY);
    end;
  except
  end;

  try
    m := defy - UNITY + OffsetY;
    for j := (Map.m_ClientRect.Top - Map.m_nBlockTop) to (Map.m_ClientRect.Bottom - Map.m_nBlockTop + LONGHEIGHT_IMAGE) do
    begin
      if j < 0 then
      begin
        Inc(m, UNITY);
        Continue;
      end;
      n := defx - UNITX * 2;
      for I := (Map.m_ClientRect.Left - Map.m_nBlockLeft - 2) to (Map.m_ClientRect.Right - Map.m_nBlockLeft + 2) do
      begin
        if (I >= 0) and (I < LOGICALMAPUNIT * 3) and (j >= 0) and (j < LOGICALMAPUNIT * 3) then
        begin
          fridx := (Map.m_MArr[I, j].wFrImg) and $7FFF;
          if fridx > 0 then
          begin
            blend := FALSE;
            wunit := Map.m_MArr[I, j].btArea;
            ani := Map.m_MArr[I, j].btAniFrame;
            if (ani and $80) > 0 then
            begin
              blend := True;
              ani := ani and $7F;
            end;
            if ani > 0 then
            begin
              anitick := Map.m_MArr[I, j].btAniTick;
              fridx := fridx + (m_nAniCount mod (ani + (ani * anitick))) div (1 + anitick);
            end;
            if (Map.m_MArr[I, j].btDoorOffset and $80) > 0 then
            begin
              if (Map.m_MArr[I, j].btDoorIndex and $7F) > 0 then
                fridx := fridx + (Map.m_MArr[I, j].btDoorOffset and $7F);
            end;
            fridx := fridx - 1;
            if not blend then
            begin
              GetObjs(wunit, fridx, DSurface);
              if DSurface <> nil then
              begin
                if (DSurface.Width <> 48) or (DSurface.Height <> 32) then
                begin
                  mmm := m + UNITY - DSurface.Height;
                  if (n + DSurface.Width > 0) and (n <= SCREENWIDTH) and (mmm + DSurface.Height > 0) and (mmm < SCREENHEIGHT) then
                  begin
                    MSurface.Draw(n, mmm, DSurface.ClientRect, DSurface, True, GetReversalKind(Map.m_MArr[I, j].Reserved[10]));
                  end
                  else
                  begin
                    if mmm < SCREENHEIGHT then
                    begin
                      MSurface.Draw(n, mmm, DSurface.ClientRect, DSurface, True, GetReversalKind(Map.m_MArr[I, j].Reserved[10]));
                    end;
                  end;
                end;
              end;
            end
            else
            begin
              //显示灯光的地方
              GetObjsEx(wunit, fridx, ax, ay, DSurface);
              if DSurface <> nil then
              begin
                mmm := m + ay - 68 - (Map.m_MArr[I, j].Reserved[15] - Map.m_MArr[I, j].Reserved[14]);
                if (n > 0) and (mmm + DSurface.Height > 0) and (n + DSurface.Width < SCREENWIDTH) and (mmm < SCREENHEIGHT) then
                begin
                  MSurface.DrawBlend(n + ax - 2 - (Map.m_MArr[I, j].Reserved[13] - Map.m_MArr[I, j].Reserved[12]), mmm, DSurface, 1, GetReversalKind(Map.m_MArr[I, j].Reserved[10]));
                end
                else
                begin
                  if mmm < SCREENHEIGHT then
                  begin
                    MSurface.DrawBlend(n + ax - 2 - (Map.m_MArr[I, j].Reserved[13] - Map.m_MArr[I, j].Reserved[12]), mmm, DSurface, 1, GetReversalKind(Map.m_MArr[I, j].Reserved[10]));
                  end;
                end;
              end;
            end;
          end;
        end;
        Inc(n, UNITX);
      end;
      {$REGION '移动目标绘制'}
      if (j <= (Map.m_ClientRect.Bottom - Map.m_nBlockTop)) and (not g_boServerChanging) then
      begin
        {$REGION '事件特效'}
        if EventMan.EventList.Count > 0 then
        begin
          for k := EventMan.EventList.Count - 1 downto 0 do
          begin
            evn := EventMan.EventList[k];
            if j = (evn.m_nY - Map.m_nBlockTop) then
            begin
              evn.DrawEvent(MSurface, (evn.m_nX - Map.m_ClientRect.Left) * UNITX + defx, m);
            end;
          end;
        end;
        {$ENDREGION}
        {$REGION '显示地面物品外形'}
        for K := g_DropedItemList.Count - 1 downto 0 do
        begin
          DropItem := PTDropItem(g_DropedItemList[k]);
          if (DropItem <> nil) and (DropItem.boDraw or (DropItem = g_FocusItem)) then
          begin
            if j = (DropItem.y - Map.m_nBlockTop) then
            begin
              if DropItem.Looks > 9999 then
                d := g_77WDnItemImages.Images[DropItem.Looks - 10000]
              else
                d := g_WDnItemImages.Images[DropItem.Looks];
              if d <> nil then
              begin
                ix := (DropItem.x - Map.m_ClientRect.Left) * UNITX + defx;
                iy := m;
                MSurface.Draw(ix + HALFX - (d.Width div 2), iy + HALFY - (d.Height div 2), d.ClientRect, d, True);
                if DropItem = g_FocusItem then
                  DrawEffect(ix + HALFX - (d.Width div 2), iy + HALFY - (d.Height div 2), MSurface, d, ceBright, True);
              end;
            end;
          end;
        end;
        {$ENDREGION}
        {$REGION '角色'}
        AList := m_ActorList.LockList;
        try
          for K := 0 to AList.Count - 1 do
          begin
            Actor := AList[K];
            if (Actor<>nil) and (j = Actor.m_nRy - Map.m_nBlockTop - Actor.m_nDownDrawLevel) then
            begin
              Actor.m_boVisible := True;
              if g_Config.Assistant.CleanCorpse and Actor.m_boDeath then
                Actor.m_boVisible := False;
              if Actor.m_boVisible then
              begin
                OffsetY := 1 - Actor.m_nShiftY mod 2;
                Actor.m_nSayX := (Actor.m_nRx - Map.m_ClientRect.Left) * UNITX + defx + Actor.m_nShiftX + 24;
                if Actor.m_boDeath then
                  Actor.m_nSayY := m + UNITY + Actor.m_nShiftY + 16 - 60 + (Actor.m_nDownDrawLevel * UNITY) - OffsetY
                else
                begin
                  Actor.m_nSayY := m + UNITY + Actor.m_nShiftY + 16 - 95 + (Actor.m_nDownDrawLevel * UNITY) - OffsetY;
                  if Actor.m_btHorse > 0 then
                    Actor.m_nSayY := Actor.m_nSayY - 12;
                end;
                Actor.DrawChr(MSurface, (Actor.m_nRx - Map.m_ClientRect.Left) * UNITX + defx, m + (Actor.m_nDownDrawLevel * UNITY) - OffsetY, FALSE, True);
                case Actor.m_btActionEffect of
                  1:
                  begin
                    Actor.DrawChr(MSurface, (Actor.m_nRx + Actor.LeftX - Map.m_ClientRect.Left) * UNITX + defx, m + (Actor.m_nDownDrawLevel + Actor.LeftY) * UNITY - OffsetY, True, True);
                    Actor.DrawChr(MSurface, (Actor.m_nRx + Actor.RightX - Map.m_ClientRect.Left) * UNITX + defx, m + (Actor.m_nDownDrawLevel + Actor.RightY) * UNITY - OffsetY, True, True);
                  end;
                end;
                if g_Config.Assistant.ShowHealthStatus then
                  Actor.ShowHealthStatus(MSurface, Actor.m_nSayX, Actor.m_nSayY);
              end;
            end;
          end;
        finally
          m_ActorList.UnlockList;
        end;
        {$ENDREGION}
        {$REGION '画飞行魔法地方'}
        for k := m_FlyList.Count - 1 downto 0 do
        begin
          meff := TMagicEff(m_FlyList[k]);
          if meff <> nil then
          begin
            if j = (meff.Ry - Map.m_nBlockTop) then
            begin
              meff.DrawEff(MSurface);
            end;
          end;
        end;
        {$ENDREGION}
      end;
      {$ENDREGION}
      Inc(m, UNITY);
    end;
  except
  end;

    // 显示物品
  if g_Config.Assistant.ShowAllItem or g_boShowAllItemEx then
  begin
    if g_DropedItemList.Count > 0 then
    begin
      OffsetY := 1 - g_MySelf.m_nShiftY mod 2;
      for K := 0 to g_DropedItemList.Count - 1 do
      begin
        DropItem := PTDropItem(g_DropedItemList[K]);
        if (DropItem <> nil) {and (DropItem <> g_FocusItem)} and DropItem.boDraw then
        begin
          if g_boShowAllItemEx or DropItem.BoShowName then
          begin
            ScreenXYfromMCXY(DropItem.X, DropItem.Y, mx, my);
            if (Abs(g_MySelf.m_nCurrX - DropItem.X) >= 12) or (abs(g_MySelf.m_nCurrY - DropItem.Y) >= 12) then
              Continue;
            ItemNameTexture  :=  Textures.ObjectName(MSurface, DropItem.Name);
            if ItemNameTexture <> nil then
            begin
              if DropItem.BoSpec then
                ItemNameTexture.Draw(MSurface, mx - ItemNameTexture.Width div 2, my - ItemNameTexture.Height - 8 + OffsetY, clRed)
              else
                ItemNameTexture.Draw(MSurface, mx - ItemNameTexture.Width div 2, my - ItemNameTexture.Height - 8 + OffsetY, DropItem.Color);
            end;
          end;
        end;
      end;
    end;
  end;

  {$REGION '自身及选中角色绘制'}
  if not g_boServerChanging then
  begin
    try
      if not g_MySelf.HaveStatus(STATE_TRANSPARENT) then
        g_MySelf.DrawChr(MSurface, (g_MySelf.m_nRx - Map.m_ClientRect.Left) * UNITX + defx, (g_MySelf.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy, True, FALSE);

      if (g_FocusCret <> nil) and g_FocusCret.m_boVisible and (g_FocusCret <> g_MySelf) then
      begin
        if ( not g_FocusCret.HaveStatus(STATE_TRANSPARENT) ) and IsValidActor(g_FocusCret) then
        begin
          if (g_FocusCret.Race = 50) then
          begin
            if g_FocusCret.m_wAppearance <> 54 then
              g_FocusCret.DrawChr(MSurface, (g_FocusCret.m_nRx - Map.m_ClientRect.Left) * UNITX + defx, (g_FocusCret.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy, True, FALSE);
          end
          else
            g_FocusCret.DrawChr(MSurface, (g_FocusCret.m_nRx - Map.m_ClientRect.Left) * UNITX + defx, (g_FocusCret.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy, True, FALSE);
        end;
      end
      else if (g_MagicTarget <> nil) and (g_MagicTarget <> g_MySelf) and g_MagicTarget.m_boVisible then
      begin
        if (not g_MagicTarget.HaveStatus(STATE_TRANSPARENT)) and IsValidActor(g_MagicTarget) then
          g_MagicTarget.DrawChr(MSurface, (g_MagicTarget.m_nRx - Map.m_ClientRect.Left) * UNITX + defx, (g_MagicTarget.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy, True, FALSE);
      end;
    except
    end;
  end;
  {$ENDREGION}
  {$REGION '绘制魔法'}
  try
    AList := m_ActorList.LockList;
    try
      for K := 0 to AList.Count - 1 do
      begin
        Actor := AList[K];
        if Actor.m_boVisible then
          Actor.DrawEff(MSurface, (Actor.m_nRx - Map.m_ClientRect.Left) * UNITX + defx, (Actor.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + defy);
      end;
    finally
      m_ActorList.UnlockList;
    end;

    for k := m_EffectList.Count - 1 downto 0 do
    begin
      meff := TMagicEff(m_EffectList[k]);
      if (meff <> nil) and (not meff.IsWaiting()) then
      begin
        meff.DrawEff(MSurface);
      end;
    end;
  except
  end;
  {$ENDREGION}
  {$REGION '地面物品闪亮'}
  try
    for k := g_DropedItemList.Count - 1 downto 0 do
    begin
      DropItem := PTDropItem(g_DropedItemList[k]);
      if (DropItem <> nil) and DropItem.boDraw then
      begin
        if GetTickCount - DropItem.FlashTime > 5000 then
        begin // 闪烁
          DropItem.FlashTime := GetTickCount;
          DropItem.BoFlash := True;
          DropItem.FlashStepTime := GetTickCount;
          DropItem.FlashStep := 0;
        end;
        ix := (DropItem.x - Map.m_ClientRect.Left) * UNITX + defx;
        iy := (DropItem.y - Map.m_ClientRect.Top - 1) * UNITY + defy;
        if DropItem.BoFlash then
        begin
          if GetTickCount - DropItem.FlashStepTime >= 20 then
          begin
            DropItem.FlashStepTime := GetTickCount;
            Inc(DropItem.FlashStep);
          end;
          if (DropItem.FlashStep >= 0) and (DropItem.FlashStep < 10) then
          begin
            DSurface := g_WMainImages.GetCachedImage(FLASHBASE + DropItem.FlashStep, ax, ay);
            if DSurface<>nil then
              MSurface.DrawBlend(ix + ax, iy + ay, DSurface, 1);
          end
          else
            DropItem.BoFlash := FALSE;
        end;
      end;
    end;
  except
  end;
  {$ENDREGION}

  if g_MySelf.m_boDeath then
    MSurface.FillRect(MSurface.ClipRect, $FF808080, beInvMultiply);
end;

procedure TPlayScene.ProcessDelayList;
var
  I :Integer;
  PMsg : pTPlaySceneDelayMessage;
  NowTick:Cardinal;
begin
  NowTick := TimeGetTime;
  //20毫秒才处理一次免得浪费时间
  if NowTick - m_LastProcessDelayMsgTime > 20 then
  begin
    m_LastProcessDelayMsgTime  := NowTick;
    for i := 0 to m_DelayMsg.Count - 1 do
    begin
      PMsg := m_DelayMsg[i];
      if PMsg <> nil then
      begin
        if NowTick > PMsg.PlayTime then
        begin
          case PMsg.MessageType of
            0:begin
                g_SoundManager.SkillEffectPlaySound(PMsg.SoundID);
              end;
            1:begin

              end;
          end;
          Dispose(PMsg);
          m_DelayMsg[i] := nil;
        end;
      end;
    end;

    for i := m_DelayMsg.Count - 1 downto 0 do
    begin
      if m_DelayMsg[i] = nil then
        m_DelayMsg.Delete(i);
    end;
  end;

end;

procedure TPlayScene.ProcessObecjts;
var
  I, K: Integer;
  AEvn: TCustomEvent;
  AActor: TActor;
  AMeff: TMagicEff;
  CanMoveActor: Boolean;
  AList: TList;
begin
  CanMoveActor := g_MySelf.CheckMoveTime(m_dwMoveTime);
  if CanMoveActor then
    m_dwMoveTime := TimeGetTime;

//  if CanMoveActor then
//    m_dwMoveTime := GetTickCount;
//  CanMoveActor := False;
//  if TimeGetTime - m_dwMoveTime >= TIME_MOVEOBJECTS then
//  begin
//    m_dwMoveTime := TimeGetTime;
//    CanMoveActor := True;
//  end;
  // 处理角色一些相关东西
  {$IFDEF VirtualMap}
  VirtualMap.Clear;
  {$ENDIF}
  try
    AList := m_ActorList.LockList;
    try
      for I := m_TopMost.Count - 1 downto 0 do
      begin
        if not TActor(m_TopMost[I]).m_boDelActor and (AList.IndexOf(m_TopMost[I]) <> -1) then
        begin
          AList.Remove(m_TopMost[I]);
          AList.Insert(0, m_TopMost[I]);
        end;
      end;
      m_TopMost.Clear;

      for I := AList.Count - 1 downto 0 do
      begin
        AActor := AList[I];
        if AActor <> nil then
        begin
          AActor.m_boVisible := False;
          {$IFDEF VirtualMap}
          if AActor.m_btRace <> 0 then
            VirtualMap.CheckDrawActorInMap(AActor);
          {$ENDIF}

          AActor.ProcessDynamicEffect;
          if CanMoveActor then
            AActor.m_boLockEndFrame := False;
          if not AActor.m_boLockEndFrame then
          begin
            AActor.ProcMsg;
            if CanMoveActor then
            begin
              if AActor.Move then
                Continue;
            end;
            AActor.Run;
            AActor.ProcHurryMsg;
          end;
          if (AActor.m_nWaitForRecogId <> 0) and (AActor.IsIdle) { 当前是否没有可执行的动作 } then
          begin
            DelChangeFace(AActor.m_nWaitForRecogId);
            NewActor(AActor.m_nWaitForRecogId, AActor.m_nCurrX, AActor.m_nCurrY, AActor.m_btDir, AActor.m_nWaitForFeature, AActor.m_nWaitForStatus, AActor.m_nWaitForProperties, AActor.m_nWaitForDressWeapon);
            AActor.m_nWaitForRecogId := 0;
            AActor.m_boDelActor := True;
          end;
          if (GetTickCount - AActor.m_dwLastGetMessageTime > 2000) and ((ABS(AActor.m_nCurrX - g_MySelf.m_nCurrX) > 16) or (ABS(AActor.m_nCurrY - g_MySelf.m_nCurrY) > 16)) then
          begin
            AActor.m_boDelActor := True;
          end;
          if AActor.m_boDelActor then
          begin
            m_FreeActorList.Add(AActor);
            AList.Delete(I);
            if g_TargetCret = AActor then
              g_TargetCret := nil;
            if g_FocusCret = AActor then
              g_FocusCret := nil;
            if g_MagicTarget = AActor then
              g_MagicTarget := nil;
            if g_MagicLockActor = AActor then
              g_MagicLockActor := nil;
          end;
        end
        else
          AList.Delete(I);
      end;
    finally
      m_ActorList.UnlockList;
    end;
    ClearDropItem();
  except
  end;
  // 跌落物品消隐

  // 特效物体运动属性的计算
  try
    I := 0;
    while True do
    begin
      if I >= m_EffectList.Count then
        break;
      AMeff := m_EffectList[I];
      if (AMeff<>nil) and (not AMeff.IsWaiting()) and AMeff.m_boActive then
      begin
        if not AMeff.Run then
        begin
          AMeff.Free;
          m_EffectList.Delete(I);
          Continue;
        end;
      end;
      Inc(I);
    end;
    // 飞行魔法释放
    I := 0;
    while True do
    begin
      if I >= m_FlyList.Count then
        break;
      AMeff := m_FlyList[I];
      if (AMeff<>nil) and AMeff.m_boActive then
      begin
        if not AMeff.Run then
        begin // 档尝,拳混殿 朝酒啊绰
          AMeff.Free;
          m_FlyList.Delete(I);
          Continue;
        end;
      end;
      Inc(I);
    end;
    EventMan.Execute;
  except
  end;

  try
    // 释放事件的地方
    if EventMan.EventList.Count > 0 then
    begin // 20080629
      for K := 0 to EventMan.EventList.Count - 1 do
      begin
        AEvn := EventMan.EventList[K];
        if (g_MySelf<>nil) and ((Abs(AEvn.m_nX - g_MySelf.m_nCurrX) > 20) or (Abs(AEvn.m_nY - g_MySelf.m_nCurrY) > 20)) then
        begin
          AEvn.Free;
          EventMan.EventList.Delete(K);
          break; // 茄锅俊 茄俺究
        end;
      end;
    end;
  except
  end;

  ProcessDelayList();
end;

{ ------------------------------------------------------------------------------ }
// 实现在指定目标播放某个魔法效果(20071029 清清)
// NewMagic(aowner, magid,magnumb,cx,cy,tx,ty,targetcode,mtype,Recusion,anitime,bofly)
procedure TPlayScene.NewMagic(aowner: TActor; magid, magnumb { Effect }, magStrengthen, mTag, cx, cy, tx, ty, targetcode: Integer; mtype: TMagicType; // EffectType
  Recusion: Boolean; anitime: Integer; var bofly: Boolean);
var
  I, scx, scy, sctx, scty, effnum: Integer;
  meff: TMagicEff;
  target: TActor;
  wimg: TWMImages;
begin
  try
    bofly := FALSE;
    if magid <> ACTOR_EFFECTID then //
      if m_EffectList.Count > 0 then // 20080629
        for I := 0 to m_EffectList.Count - 1 do
          if TMagicEff(m_EffectList[I]).m_nServerMagicId = magid then
            Exit;

    ScreenXYfromMCXY(cx, cy, scx, scy);
    ScreenXYfromMCXY(tx, ty, sctx, scty);
    if magnumb > 0 then
      GetEffectBase(magnumb, magStrengthen, mTag, 0, wimg, effnum) // magnumb为Effect
    else
      effnum := -magnumb;
    target := FindActor(targetcode); // 目标
    meff := nil;

    case mtype of // EffectType
      mtReady, mtFly, mtFlyAxe:
        begin
          case magnumb of
            39:
              begin // 寒冰掌
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target;
                meff.frame := 4;
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            63:
              begin // 噬魂沼泽
                meff := TFireFixedEffect.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target;
                meff.ExplosionFrame := 36;
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            42:
              begin // 分身术
                meff := TfenshenThunder.Create(10, scx, scy, sctx, scty, aowner);
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            100:
              begin // 月灵普通攻击
                effnum := 100;
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target; // nil;//是目标
                meff.NextFrameTime := 120;
                meff.frame := 3;
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            101:
              begin
                effnum := 280;
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target; // nil;//是目标
                meff.NextFrameTime := 120;
                meff.frame := 3;
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            102:
              begin
                effnum := 130;
                meff := TFireDragonEffect.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target; // nil;//是目标
                meff.NextFrameTime := 120;
                meff.MagExplosionBase := 200;
                meff.ExplosionFrame := 20;
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;

            103:
              begin // 双龙破
                meff := TBatterMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target; // nil;//是目标
                meff.NextFrameTime := 120;
                meff.MagExplosionBase := 2770;
                TBatterMagicEff(meff).BatterImageBase := 1570;
                meff.frame := 5;
                if wimg <> nil then
                  meff.ImgLib := wimg;
                aowner.m_nCurrentAction := 0;
                aowner.m_boUseMagic := FALSE;
              end;
            106:
              begin // 凤舞祭
                meff := TBatterMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target; // nil;//是目标
                meff.NextFrameTime := 120;
                meff.MagExplosionBase := 2580;
                TBatterMagicEff(meff).BatterImageBase := 1770;
                meff.frame := 3;
                if wimg <> nil then
                  meff.ImgLib := wimg;
                aowner.m_nCurrentAction := 0;
                aowner.m_boUseMagic := FALSE;
              end;
            107:
              begin // 八卦掌
                meff := TBatterMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target; // nil;//是目标
                meff.NextFrameTime := 120;
                meff.MagExplosionBase := 2251;
                TBatterMagicEff(meff).BatterImageBase := 650;
                meff.frame := 3;
                if wimg <> nil then
                  meff.ImgLib := wimg;
                aowner.m_nCurrentAction := 0;
                aowner.m_boUseMagic := FALSE;
              end;
            109:
              begin // 惊雷爆
                meff := TJingLeiMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target; // nil;//是目标
                meff.NextFrameTime := 120;
                meff.MagExplosionBase := 4240; // 人物1360
                TJingLeiMagicEff(meff).BatterImageBase := 30;
                meff.frame := 4;
                if wimg <> nil then
                  meff.ImgLib := wimg;
                aowner.m_nCurrentAction := 0;
                aowner.m_boUseMagic := FALSE;
              end;
            113:
              begin // 万剑归宗
                meff := TBatterMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target; // nil;//是目标
                meff.NextFrameTime := 50;
                meff.MagExplosionBase := 2980;
                meff.frame := 8;
                TBatterMagicEff(meff).BatterImageBase := 1060;
                TBatterMagicEff(meff).skipNum := 2;
                if wimg <> nil then
                  meff.ImgLib := wimg;
                aowner.m_nCurrentAction := 0;
                aowner.m_boUseMagic := FALSE;
              end;
            199:
              begin // 月灵普通攻击
                effnum := 100;
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target; // nil;//是目标
                meff.NextFrameTime := 120;
                meff.frame := 3;
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            200:
              begin
                effnum := 280;
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target; // nil;//是目标
                meff.NextFrameTime := 120;
                meff.frame := 3;
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;

            60:
              meff := TPHHitEffect.Create(0, scx, scy, sctx, scty, aowner);
          else
            begin
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.TargetActor := target;
            end;
          end;
          bofly := True;
        end;
      mtExplosion:
        case magnumb of
          4:
          begin
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.TargetActor := target;
            meff.NextFrameTime := 80;
            if magStrengthen > 0 then
            begin
              meff.ImgLib := g_WMagic716Images;
              case mTag of
                1:
                begin
                  case magStrengthen of
                    1..3:
                    begin
                      meff.MagExplosionBase := 620;
                      meff.ExplosionFrame := 8;
                    end;
                    4..6:
                    begin
                      meff.MagExplosionBase := 630;
                      meff.ExplosionFrame := 8;
                    end
                    else
                    begin
                      meff.MagExplosionBase := 640;
                      meff.ExplosionFrame := 8;
                    end;
                  end;
                end;
                2:
                begin
                  case magStrengthen of
                    1..3:
                    begin
                      meff.MagExplosionBase := 830;
                      meff.ExplosionFrame := 8;
                    end;
                    4..6:
                    begin
                      meff.MagExplosionBase := 840;
                      meff.ExplosionFrame := 8;
                    end
                    else
                    begin
                      meff.MagExplosionBase := 850;
                      meff.ExplosionFrame := 8;
                    end;
                  end;
                end;
              end;
            end;
          end;
          18:
            begin // 诱惑之光
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 1570;
              meff.TargetActor := target;
              meff.NextFrameTime := 80;
            end;
          19:
            begin // 移行换位 20080424
              meff := nil;
            end;
          21:
            begin // 爆裂火焰
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 1660;
              meff.TargetActor := nil; // target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 20;
              meff.Light := 3;
              if magStrengthen > 0 then
              begin
                case magStrengthen of
                  1..3:
                  begin
                    meff.MagExplosionBase := 350;
                    meff.ExplosionFrame := 11;
                    meff.ImgLib := g_WMagic716Images;
                  end;
                  4..6:
                  begin
                    meff.MagExplosionBase := 380;
                    meff.ExplosionFrame := 11;
                    meff.ImgLib := g_WMagic716Images;
                  end
                  else
                  begin
                    meff.MagExplosionBase := 410;
                    meff.ExplosionFrame := 14;
                    meff.ImgLib := g_WMagic716Images;
                  end;
                end;
              end;
            end;
          26:
            begin // 心灵启示
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 3990;
              meff.TargetActor := target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 10;
              meff.Light := 2;
            end;
          27:
            begin // 群体治疗术
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 1800;
              meff.TargetActor := nil; // target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 10;
              meff.Light := 3;
            end;
          30:
            begin // 圣言术
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 3930;
              meff.TargetActor := target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 16;
              meff.Light := 3;
            end;
          31:
            begin // 冰咆哮
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 3850;
              meff.TargetActor := nil; // target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 20;
              meff.Light := 3;
              if magStrengthen > 0 then
              begin
                case magStrengthen of
                  1..3:
                  begin
                    meff.MagExplosionBase := 90;
                    meff.ExplosionFrame := 17;
                    meff.ImgLib := g_WMagic816Images;
                  end;
                  4..6:
                  begin
                    meff.MagExplosionBase := 110;
                    meff.ExplosionFrame := 20;
                    meff.ImgLib := g_WMagic816Images;
                  end;
                  else
                  begin
                    meff.MagExplosionBase := 130;
                    meff.ExplosionFrame := 20;
                    meff.ImgLib := g_WMagic816Images;
                  end;
                end;
              end;
            end;
          34:
            begin // 灭天火
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 140;
              meff.TargetActor := nil; // target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 20;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          40:
            begin // 净化术
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 620;
              meff.TargetActor := nil; // target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 20;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          45:
            begin // 火龙气焰
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 920;
              meff.TargetActor := nil; // target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 20;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          47:
            begin // 飓风破
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 1010;
              meff.TargetActor := nil; // target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 20;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          48, 74:
            begin // 噬血术 四级噬血术
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 1060;
              meff.TargetActor := nil; // target;
              meff.NextFrameTime := 50;
              meff.ExplosionFrame := 20;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          49:
            begin // 骷髅咒
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 1110;
              meff.TargetActor := nil; // target;
              meff.NextFrameTime := 80;
              meff.ExplosionFrame := 10;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          51:
            begin // 流星火雨 20080510
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 640;
              meff.TargetActor := nil; // target;
              meff.NextFrameTime := 70;
              meff.ExplosionFrame := 30;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          77: { 四级施毒术 }
            begin
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 70;
              meff.TargetActor := nil; // target;
              meff.NextFrameTime := 70;
              meff.ExplosionFrame := 8;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          80: { 四级流星火雨 }
            begin
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 260;
              meff.TargetActor := nil; // target;
              meff.NextFrameTime := 70;
              meff.ExplosionFrame := 30;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := wimg;
            end;
          102:
            begin // 雷炎蛛王 吐网
              effnum := 3730;
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.MagExplosionBase := 3730;
              meff.TargetActor := nil; // target;
              meff.NextFrameTime := 200;
              meff.ExplosionFrame := 10;
              meff.Light := 3;
              if wimg <> nil then
                meff.ImgLib := g_WMonImagesArr[23];
            end;
          112:
            begin
              meff := TBatterMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.TargetActor := target; // nil;//是目标
              meff.NextFrameTime := 120;
              meff.MagExplosionBase := 3150;
              TBatterMagicEff(meff).BatterImageBase := 1120;
              meff.frame := 7;
              if wimg <> nil then
                meff.ImgLib := wimg;
              aowner.m_nCurrentAction := 0;
              aowner.m_boUseMagic := FALSE;
            end;
        else
          begin // 默认
            meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
            meff.TargetActor := target;
            meff.NextFrameTime := 80;
          end;
        end;
      mtFireWind:
        if magnumb = 35 then
        begin
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtExplosion, Recusion, anitime);
          meff.MagExplosionBase := 165; // 为wil里的idx
          meff.TargetActor := TActor(aowner); // nil;//是目标
          meff.NextFrameTime := 60; // 时间
          meff.ExplosionFrame := 10; // 往后播放的帧数
          if wimg <> nil then
            meff.ImgLib := wimg;
        end
        else
          meff := nil;
      mtFireGun: // 拳堪规荤    //暴烈火焰
        meff := TFireGunEffect.Create(930, scx, scy, sctx, scty);
      mtThunder:
        begin // 雷电术
          case magnumb of
            9, 80, 70 { 群体雷电 } , 71, 72, 73, 74:
              begin
                meff := TThuderEffect.Create(10, sctx, scty, nil); // target);
                meff.ExplosionFrame := 6;
                meff.ImgLib := g_WMagic2Images;
                if magStrengthen > 0 then
                begin
                  case magnumb of
                    9:
                    begin
                      case magStrengthen of
                        1..3:
                        begin
                          meff.EffectBase := 210;
                          meff.ExplosionFrame := 5;
                          meff.ImgLib := g_WMagic716Images;
                        end;
                        4..6:
                        begin
                          meff.EffectBase := 230;
                          meff.ExplosionFrame := 5;
                          meff.ImgLib := g_WMagic716Images;
                        end;
                        else
                        begin
                          meff.EffectBase := 250;
                          meff.ExplosionFrame := 7;
                          meff.ImgLib := g_WMagic716Images;
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            75: { 四级雷电 }
              begin
                meff := TThuderEffect.Create(20, sctx, scty, nil); // target);
                meff.ExplosionFrame := 6;
                meff.ImgLib := g_WMagic7Images;
              end;
            61:
              begin // 英雄合击 劈星斩 清清2007.10.29
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtExplosion, Recusion, anitime);
                meff.MagExplosionBase := 495; // 为wil里的idx
                meff.TargetActor := nil; // nil;//是目标
                meff.NextFrameTime := 80; // 时间
                meff.ExplosionFrame := 19; // 往后播放的帧数
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            62:
              begin // 英雄合击 雷霆一击 清清2007.10.31
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtExplosion, Recusion, anitime);
                meff.MagExplosionBase := 390; // 为wil里的idx
                meff.TargetActor := nil; // nil;//是目标
                meff.NextFrameTime := 80; // 时间
                meff.ExplosionFrame := 25; // 往后播放的帧数
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            64:
              begin // 英雄合击 末日审判 清清2007.10.29
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtExplosion, Recusion, anitime);
                meff.MagExplosionBase := 230; // 为wil里的idx
                meff.TargetActor := nil; // nil;//是目标
                meff.NextFrameTime := 80; // 时间
                meff.ExplosionFrame := 27; // 往后播放的帧数
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            65:
              begin // 英雄合击 火龙气焰 清清2007.10.29
                meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtExplosion, Recusion, anitime);
                meff.MagExplosionBase := 561; // 为wil里的idx
                meff.TargetActor := nil; // nil;//是目标
                meff.NextFrameTime := 80; // 时间
                meff.ExplosionFrame := 37; // 往后播放的帧数
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
          end;
        end;
      mtRedThunder:
        begin
          meff := TRedThunderEffect.Create(230, sctx, scty, nil);
          meff.ExplosionFrame := 6;
        end;
      mtLava:
        begin
          case magnumb of
            91:
              meff := TLavaEffect.Create(470, sctx, scty, nil, 10); // 岩浆
            92:
              meff := TLavaEffect.Create(350, sctx, scty, nil, 34); // 火龙守护攻击效果
          end;
        end;
      mtLightingThunder: // 激光电影 魔法
      begin
        meff := TLightingThunder.Create(970, scx, scy, sctx, scty, target);
        if magStrengthen > 0 then
        begin
          case magnumb of
            8:
            begin
              case magStrengthen of
                1..3:
                begin
                  meff.EffectBase := 1100;
                  meff.ImgLib := g_WMagic716Images;
                end;
                4..6:
                begin
                  meff.EffectBase := 1270;
                  meff.ImgLib := g_WMagic716Images;
                end;
                else
                begin
                  meff.EffectBase := 1440;
                  meff.ImgLib := g_WMagic716Images;
                end;
              end;
            end;
          end;
        end;
      end;
      mtExploBujauk:
        begin
          case magnumb of
            10:
              begin // 灵魂火符
                meff := TExploBujaukEffect.Create(1160, scx, scy, sctx, scty, target);
                meff.MagExplosionBase := 1360;
                meff.NextFrameTime := 80; // 时间
                if magStrengthen > 0 then
                begin
                  case magStrengthen of
                    1..3:
                    begin
                      meff.EffectBase := 600;
                      meff.ExplosionFrame := 6;
                      meff.MagExplosionBase := 1620;
                      meff.ImgLib := g_WMagic816Images;
                      TExploBujaukEffect(meff).m_boDrawShadow := True;
                    end;
                    4..6:
                    begin
                      meff.EffectBase := 940;
                      meff.ExplosionFrame := 6;
                      meff.MagExplosionBase := 1630;
                      meff.ImgLib := g_WMagic816Images;
                      TExploBujaukEffect(meff).m_boDrawShadow := True;
                    end;
                    else
                    begin
                      meff.EffectBase := 1280;
                      meff.ExplosionFrame := 7;
                      meff.MagExplosionBase := 1640;
                      meff.ImgLib := g_WMagic816Images;
                      TExploBujaukEffect(meff).m_boDrawShadow := True;
                    end;
                  end;
                end;
              end;
            17:
              begin // 集体隐身术
                meff := TExploBujaukEffect.Create(1160, scx, scy, sctx, scty, target);
                meff.MagExplosionBase := 1540;
              end;
            100:
              begin // 4级灵魂火符 20080111
                meff := TExploBujaukEffect.Create(140, scx, scy, sctx, scty, target);
                meff.MagExplosionBase := 300;
                meff.TargetActor := target; // nil;//是目标
                meff.NextFrameTime := 80; // 时间
                meff.ExplosionFrame := 4; // 往后播放的帧数
                TExploBujaukEffect(meff).m_boDrawShadow := True;
                if wimg <> nil then
                  meff.ImgLib := wimg;
              end;
            104:
              begin
                meff := THuXiaoMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target; // nil;//是目标
                meff.NextFrameTime := 120;
                meff.MagExplosionBase := 3740;
                THuXiaoMagicEff(meff).BatterImageBase := 2380;
                meff.frame := 5;
                if wimg <> nil then
                  meff.ImgLib := wimg;
                aowner.m_nCurrentAction := 0;
                aowner.m_boUseMagic := FALSE;
              end;
            110:
              begin // 三焰咒
                // 3333333
                meff := TBatterSanyanEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
                meff.TargetActor := target; // nil;//是目标
                meff.NextFrameTime := 120;
                meff.MagExplosionBase := 3560;
                TBatterSanyanEff(meff).BatterImageBase := 1640;
                meff.frame := 5;
                if wimg <> nil then
                  meff.ImgLib := wimg;
                aowner.m_nCurrentAction := 0;
                aowner.m_boUseMagic := FALSE;
              end;
          end;
          bofly := True;
        end;
      mtBujaukGroundEffect:
        begin
          meff := TBujaukGroundEffect.Create(1160, magnumb, scx, scy, sctx, scty);
          case magnumb of
            11:
            begin
              meff.MagExplosionBase := 1320;
              meff.ExplosionFrame := 16;
            end;
            12:
            begin
              meff.MagExplosionBase := 1340;
              meff.ExplosionFrame := 16;
            end;
            46:
              meff.ExplosionFrame := 24; // 诅咒术
          end;
          if magStrengthen > 0 then
          begin
            case magnumb of
              11:
              begin
                case magStrengthen of
                  1..3: meff.MagExplosionBase := 2470;
                  4..6: meff.MagExplosionBase := 2490;
                  else
                    meff.MagExplosionBase := 2520;
                end;
                meff.ExplosionFrame := 20;
                TBujaukGroundEffect(meff).StrengthenLib := g_WMagic716Images;
              end;
              12:
              begin
                case magStrengthen of
                  1..3: meff.MagExplosionBase := 2410;
                  4..6: meff.MagExplosionBase := 2430;
                  else
                    meff.MagExplosionBase := 2450;
                end;
                meff.ExplosionFrame := 20;
                TBujaukGroundEffect(meff).StrengthenLib := g_WMagic716Images;
              end;
            end;
          end;
          bofly := True;
        end;
      mtKyulKai:
        begin
          meff := nil; // TKyulKai.Create (1380, scx, scy, sctx, scty);
        end;
      mt12:
        begin

        end;
      mt13:
        begin
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
          if meff <> nil then
          begin
            case magnumb of
              32:
                begin
                  meff.ImgLib := { FrmMain.WMon21Img20080720注释 } g_WMonImagesArr[20];
                  meff.MagExplosionBase := 3580;
                  meff.TargetActor := target;
                  meff.Light := 3;
                  meff.NextFrameTime := 20;
                end;
              37:
                begin
                  meff.ImgLib := { FrmMain.WMon22Img20080720注释 } g_WMonImagesArr[21];
                  meff.MagExplosionBase := 3520;
                  meff.TargetActor := target;
                  meff.Light := 5;
                  meff.NextFrameTime := 20;
                end;
            end;
          end;
        end;
      mt14:
        begin
          case magnumb of
            101:
              begin
                meff := TThuderEffect.Create(100, sctx, scty, nil); // target);
                meff.ExplosionFrame := 15;
                meff.ImgLib := g_WMagic6Images;
              end;
            34:
              begin
                meff := TThuderEffect.Create(140, sctx, scty, nil); // target);
                meff.ExplosionFrame := 10;
                meff.ImgLib := g_WMagic2Images;
              end;
          end;
        end;
      mt15:
        begin
          meff := TFlyingBug.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
          meff.TargetActor := target;
          bofly := True;
        end;
      mt16:
        begin

        end;
      mtFlyArrow:
        begin
          case magnumb of
            150:
            begin
              meff := TAcherFlyArrow.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.Repetition := True;
              TAcherFlyArrow(meff).boBlend := False;
              meff.ImgLib := g_WEffectGJSImages;
              meff.EffectBase := 0;
              meff.NextFrameTime := 50;
              meff.TargetActor := target;
              meff.MagExplosionBase := 0;
            end;
            170:
            begin
              meff := TAcherFlyArrow151.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.Repetition := True;
              TAcherFlyArrow151(meff).boBlend := True;
              meff.ImgLib := g_WEffectGJSImages;
              meff.EffectBase := 0;
              meff.NextFrameTime := 50;
              meff.TargetActor := target;
              TAcherFlyArrow151(meff).HitLib := g_WMagicCKImages;
              meff.MagExplosionBase := 1210;
              meff.ExplosionFrame := 4;
            end;
            151:
            begin
              meff := TAcherFlyArrow.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.Repetition := True;
              TAcherFlyArrow(meff).boBlend := True;
              meff.ImgLib := g_WEffectGJSImages;
              meff.EffectBase := 110;
              meff.NextFrameTime := 50;
              meff.TargetActor := target;
              meff.MagExplosionBase := 200;
              meff.ExplosionFrame := 7;
              TAcherFlyArrow(meff).boTail := True;
              TAcherFlyArrow(meff).nTailStart := 190;
              TAcherFlyArrow(meff).nTailLen := 8;
            end;
            153:
            begin
              meff := TAcherFlyArrow.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.Repetition := True;
              TAcherFlyArrow(meff).boBlend := True;
              meff.ImgLib := g_WEffectGJSImages;
              meff.EffectBase := 270;
              meff.NextFrameTime := 50;
              meff.TargetActor := target;
              meff.MagExplosionBase := 360;
              meff.ExplosionFrame := 7;
              TAcherFlyArrow(meff).boTail := True;
              TAcherFlyArrow(meff).nTailStart := 350;
              TAcherFlyArrow(meff).nTailLen := 9;
            end;
            156:
            begin
              meff := TMagicEff.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              //meff.boTrack := False;
              meff.Repetition := False;
              meff.MagExplosionBase := 13520;
              meff.TargetActor := nil;
              meff.NextFrameTime := 70;
              meff.ExplosionFrame := 22;
              meff.frame := 22;
              meff.Light := 3;
              meff.ImgLib := g_WHumWingImages[1];
              meff.FixedEffect := True;
            end;
            157:
            begin
              meff := TAcherFlyArrow.Create(magid, effnum, scx, scy, sctx, scty, mtype, Recusion, anitime);
              meff.Repetition := True;
              TAcherFlyArrow(meff).boBlend := True;
              meff.ImgLib := g_WEffectGJSImages;
              meff.EffectBase := 660;
              meff.NextFrameTime := 50;
              meff.TargetActor := target;
              meff.MagExplosionBase := 750;
              meff.ExplosionFrame := 5;
              TAcherFlyArrow(meff).boTail := True;
              TAcherFlyArrow(meff).nTailStart := 740;
              TAcherFlyArrow(meff).nTailLen := 10;
            end;
          end;
        end;
      mtAssassin:
      begin
      end;
    end;
    if (meff = nil) then
      Exit;

    meff.TargetRx := tx;
    meff.TargetRy := ty;
    if meff.TargetActor <> nil then
    begin
      meff.TargetRx := TActor(meff.TargetActor).m_nCurrX;
      meff.TargetRy := TActor(meff.TargetActor).m_nCurrY;
    end;
    meff.MagOwner := aowner;
    m_EffectList.Add(meff);
  except
    DebugOutStr('TPlayScene.NewMagic' + IntToStr(magnumb));
  end;
end;

procedure TPlayScene.NewMagic(AOwner: TActor; AProperties: TuCustomMagicEffectProperties; magid, cx, cy, tx, ty, targetcode: Integer; Recusion: Boolean; anitime: Integer; var bofly: Boolean);
var
  I, scx, scy, sctx, scty: Integer;
  AMeff: TCustomMagicEffect;
begin
  try
    bofly := FALSE;
    if magid <> ACTOR_EFFECTID then //
      if m_EffectList.Count > 0 then // 20080629
        for I := 0 to m_EffectList.Count - 1 do
          if TMagicEff(m_EffectList[I]).m_nServerMagicId = magid then
            Exit;

    ScreenXYfromMCXY(cx, cy, scx, scy);
    ScreenXYfromMCXY(tx, ty, sctx, scty);
    AMeff := TCustomMagicEffect.Create(magid, AProperties.Run.StartIndex, scx, scy, sctx, scty, mtReady, Recusion, anitime);
    AMeff.RunFrameTime := AProperties.Run.FrameTime;
    AMeff.HitFrameTime := AProperties.Hit.FrameTime;
    AMeff.TargetActor := FindActor(targetcode);
    AMeff.TargetRx := tx;
    AMeff.TargetRy := ty;
    if AMeff.TargetActor <> nil then
    begin
      AMeff.TargetRx := TActor(AMeff.TargetActor).m_nCurrX;
      AMeff.TargetRy := TActor(AMeff.TargetActor).m_nCurrY;
    end;
    AMeff.MagOwner := aowner;
    AMeff.HitSound := AProperties.Hit.Sound;
    AMeff.HitSoundFrame := AProperties.Hit.SoundFrame;
    AMeff.FixedEffect := (uMagicMgr.TuMagicEffects(AProperties.Run).Images = nil) or uMagicMgr.TuMagicEffects(AProperties.Run).Images.VT or (AProperties.Run.Count = 0);
    AMeff.RunLib := TuMagicEffects(AProperties.Run).Images;
    AMeff.HitLib := TuMagicEffects(AProperties.Hit).Images;
    AMeff.RunFrameCount := AProperties.Run.Count;
    AMeff.MagExplosionBase := AProperties.Hit.StartIndex;
    AMeff.ExplosionFrame := AProperties.Hit.Count - AProperties.Hit.Skip;
    m_EffectList.Add(AMeff);
  except
  end;
end;

function TPlayScene.NewFlyObject(aowner: TActor; cx, cy, tx, ty, targetcode: Integer; mtype: TMagicType): TMagicEff;
var
  scx, scy, sctx, scty: Integer;
  meff:                 TMagicEff;
begin
  ScreenXYfromMCXY(cx, cy, scx, scy);
  ScreenXYfromMCXY(tx, ty, sctx, scty);
  case mtype of
    mtFlyArrow:
      meff := TFlyingArrow.Create(1, 1, scx, scy, sctx, scty, mtype, True, 0);
    mt12:
      meff := TFlyingFireBall.Create(1, 1, scx, scy, sctx, scty, mtype, True, 0);
    mt15:
      meff := TFlyingBug.Create(1, 1, scx, scy, sctx, scty, mtype, True, 0);
  else
    meff := TFlyingAxe.Create(1, 1, scx, scy, sctx, scty, mtype, True, 0);
  end;
  meff.TargetRx := tx;
  meff.TargetRy := ty;
  meff.TargetActor := FindActor(targetcode);
  meff.MagOwner := aowner;
  m_FlyList.Add(meff);
  Result := meff;
end;

procedure TPlayScene.ScreenXYfromMCXY(cx, cy: Integer; var sx, sy: Integer);
begin
  if g_MySelf = nil then Exit;
  sx := (cx - g_MySelf.m_nRx) * UNITX + MapXToPixeXOffset - g_MySelf.m_nShiftX;
  sy := (cy - g_MySelf.m_nRy) * UNITY + MapYToPixeYOffset - g_MySelf.m_nShiftY;
end;

// 屏幕座标 mx, my转换成ccx, ccy地图座标
procedure TPlayScene.CXYfromMouseXY(mx, my: Integer; var ccx, ccy: Integer);
begin
  if g_MySelf = nil then Exit;
  ccx := Ceil((mx - PixeXToMapXOffset - m_nDefXX + g_MySelf.m_nShiftX) / UNITX) + g_MySelf.m_nRx - 1;
  ccy := Ceil((my - PixeYToMapYOffset - m_nDefYY + g_MySelf.m_nShiftY) / UNITY) + g_MySelf.m_nRy;
end;

function TPlayScene.GetCharacter(x, y, wantsel: Integer; var nowsel: Integer; liveonly: Boolean): TActor;
var
  k, I, ccx, ccy, dx, dy: Integer;
  a: TActor;
  AList: TList;
begin
  Result := nil;
  nowsel := -1;
  CXYfromMouseXY(x, y, ccx, ccy);
  AList := m_ActorList.LockList;
  try
    for k := ccy + 8 downto ccy - 1 do
    begin
      if AList.Count > 0 then
      begin // 20080629
        for I := AList.Count - 1 downto 0 do
        begin
          if AList[I] <> g_MySelf then
          begin
            a := AList[I];
            if (not liveonly or not a.m_boDeath) and (a.m_boHoldPlace) then
            begin
              if a.m_nCurrY = k then
              begin
                dx := (a.m_nRx - Map.m_ClientRect.Left) * UNITX + m_nDefXX + a.m_nPx + a.m_nShiftX;
                dy := (a.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + m_nDefYY + a.m_nPy + a.m_nShiftY;
                if a.CheckSelect(x - dx, y - dy) then
                begin
                  Result := a;
                  Inc(nowsel);
                  if nowsel >= wantsel then
                    Exit;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    m_ActorList.UnlockList;
  end;
end;

// 取得鼠标所指坐标的角色
function TPlayScene.GetAttackFocusCharacter(x, y, wantsel: Integer; var nowsel: Integer; liveonly: Boolean): TActor;
var
  k, I, ccx, ccy, dx, dy, centx, centy: Integer;
  a: TActor;
  AList: TList;
begin
  Result := GetCharacter(x, y, wantsel, nowsel, liveonly);
  if Result = nil then
  begin
    nowsel := -1;
    CXYfromMouseXY(x, y, ccx, ccy);
    AList := m_ActorList.LockList;
    try
      for k := ccy + 8 downto ccy - 1 do
      begin
        for I := AList.Count - 1 downto 0 do
        begin
          if AList[I] <> g_MySelf then
          begin
            a := AList[I];
            if (not liveonly or not a.m_boDeath) and (a.m_boHoldPlace) then
            begin
              if a.m_nCurrY = k then
              begin
                dx := (a.m_nRx - Map.m_ClientRect.Left) * UNITX + m_nDefXX + a.m_nPx + a.m_nShiftX;
                dy := (a.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + m_nDefYY + a.m_nPy + a.m_nShiftY;
                if a.CharWidth > 40 then
                  centx := (a.CharWidth - 40) div 2
                else
                  centx := 0;
                if a.CharHeight > 70 then
                  centy := (a.CharHeight - 70) div 2
                else
                  centy := 0;
                if (x - dx >= centx) and (x - dx <= a.CharWidth - centx) and (y - dy >= centy) and (y - dy <= a.CharHeight - centy) then
                begin
                  Result := a;
                  Inc(nowsel);
                  if nowsel >= wantsel then
                    Exit;
                end;
              end;
            end;
          end;
        end;
      end;
    finally
      m_ActorList.UnlockList;
    end;
  end;
  // if (Result.m_btRace = 50) and (Result.m_wAppearance in [54..58]) then Result := nil;
end;

function TPlayScene.IsSelectMyself(x, y: Integer): Boolean;
var
  k, ccx, ccy, dx, dy: Integer;
begin
  Result := FALSE;
  CXYfromMouseXY(x, y, ccx, ccy);
  for k := ccy + 2 downto ccy - 1 do
  begin
    if g_MySelf.m_nCurrY = k then
    begin
      dx := (g_MySelf.m_nRx - Map.m_ClientRect.Left) * UNITX + m_nDefXX + g_MySelf.m_nPx + g_MySelf.m_nShiftX;
      dy := (g_MySelf.m_nRy - Map.m_ClientRect.Top - 1) * UNITY + m_nDefYY + g_MySelf.m_nPy + g_MySelf.m_nShiftY;
      if g_MySelf.CheckSelect(x - dx, y - dy) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

// 取得指定座标地面物品
// x,y 为屏幕座标
function TPlayScene.GetDropItems(x, y: Integer; out inames: string): PTDropItem;
var
  I, ccx, ccy, ssx, ssy: Integer;
  d: PTDropItem;
begin
  Result := nil;
  CXYfromMouseXY(x, y, ccx, ccy);
  ScreenXYfromMCXY(ccx, ccy, ssx, ssy);
  inames := '';
  if g_DropedItemList.Count > 0 then
    for I := 0 to g_DropedItemList.Count - 1 do
    begin
      d := PTDropItem(g_DropedItemList[I]);
      if (d.x = ccx) and (d.y = ccy) then
      begin
        if Result = nil then
          Result := d;
        if inames <> '' then
          inames  :=  inames + '\';
        inames := inames + d.Name;
      end;
    end;
end;

procedure TPlayScene.GetXYDropItemsList(nX, nY: Integer; var ItemList: TList);
var
  I:        Integer;
  DropItem: PTDropItem;
begin
  if g_DropedItemList.Count > 0 then // 20080629
    for I := 0 to g_DropedItemList.Count - 1 do
    begin
      DropItem := g_DropedItemList[I];
      if (DropItem.x = nX) and (DropItem.y = nY) then
      begin
        ItemList.Add(DropItem);
      end;
    end;
end;

function TPlayScene.CanRun(sx, sy, ex, ey: Integer): Boolean;
var
  ndir, rx, Ry: Integer;
begin
  ndir := GetNextDirection(sx, sy, ex, ey);
  rx := sx;
  Ry := sy;
  GetNextPosXY(ndir, rx, Ry);

  if Map.CanMove(rx, Ry) and Map.CanMove(ex, ey) then
    Result := True
  else
    Result := FALSE;

  if CanWalkEx(rx, Ry) and CanWalkEx(ex, ey) then
    Result := True
  else
    Result := FALSE;
end;

function TPlayScene.CanWalkEx(mx, my: Integer): Boolean;
begin
  Result := FALSE;
  if Map.CanMove(mx, my) then
    Result := not CrashManEx(mx, my); { true; } // 穿人
end;

// 穿人
function TPlayScene.CrashManEx(mx, my: Integer): Boolean;
var
  I: Integer;
  Actor: TActor;
  AList: TList;
begin
  Result := FALSE;
  AList := m_ActorList.LockList;
  try
    for I := 0 to AList.Count - 1 do
    begin
      Actor := AList[I];
      if (Actor.m_boHoldPlace) and (not Actor.m_boDeath) and (Actor.m_nCurrX = mx) and (Actor.m_nCurrY = my) then
      begin
        if (Actor.Race in [RCC_USERHUMAN, 1, 150]) and g_boCanRunHuman then
          Continue;
        if (Actor.Race = RCC_MERCHANT) and g_boCanRunNpc then
          Continue;
        if (Actor.Race <> 0) and (Actor.Race <> 50) and g_boCanRunMon then
          Continue;
        // if ((Actor.m_btRace > RCC_USERHUMAN) and (Actor.m_btRace <> RCC_MERCHANT)) and g_boCanRunMon then Continue;
        // m_btRace 大于 0 并不等于 50 则为怪物
        Result := True;
        Break;
      end;
    end;
  finally
    m_ActorList.UnlockList;
  end;
end;

function TPlayScene.CanWalk(mx, my: Integer): Boolean;
begin
  Result := FALSE;
  if Map.CanMove(mx, my) then
    Result := not CrashMan(mx, my);
end;

function TPlayScene.CrashMan(X, Y: Integer): Boolean;
var
  I: Integer;
  AActor: TActor;
  AList: TList;
begin
  Result := False;
  AList := m_ActorList.LockList;
  try
    for I := 0 to AList.Count - 1 do
    begin
      AActor := AList[I];
      if AActor.m_boHoldPlace and not AActor.m_boDeath and not AActor.m_boGateMan and (AActor.m_nCurrX = X) and (AActor.m_nCurrY = Y) then
      begin
        Result := True;
        Break;
      end;
    end;
  finally
    m_ActorList.UnlockList;
  end;
end;

function TPlayScene.FindActor(id: Integer): TActor;
var
  I: Integer;
  AList: TList;
begin
  Result := nil;
  AList := m_ActorList.LockList;
  try
    for I := 0 to AList.Count - 1 do
    begin
      if TActor(AList[I]).m_nRecogId = id then
      begin
        Result := AList[I];
        break;
      end;
    end;
  finally
    m_ActorList.UnlockList;
  end;
end;

// 通过名字找这个角色
function TPlayScene.FindActor(const sName: String): TActor;
var
  I: Integer;
  Actor: TActor;
  AList: TList;
begin
  Result := nil;
  AList := m_ActorList.LockList;
  try
    for I := 0 to AList.Count - 1 do
    begin
      Actor := AList[I];
      if SameText(Actor.m_sUserName, sName) then
      begin
        Result := Actor;
        break;
      end;
    end;
  finally
    m_ActorList.UnlockList;
  end;
end;

function TPlayScene.FindActorXY(x, y: Integer): TActor;
var
  I: Integer;
  AList: TList;
begin
  Result := nil;
  AList := m_ActorList.LockList;
  try
    for I := 0 to AList.Count - 1 do
    begin
      if (TActor(AList[I]).m_nCurrX = x) and (TActor(AList[I]).m_nCurrY = y) then
      begin
        Result := AList[I];
        if not Result.m_boDeath and Result.m_boHoldPlace then
          break;
      end;
    end;
  finally
    m_ActorList.UnlockList;
  end;
end;

// 列表里是否有这个角色
function TPlayScene.IsValidActor(Actor: TActor): Boolean;
begin
  with m_ActorList do
  begin
    try
      Result := LockList.IndexOf(Actor) <> -1;
    finally
      UnlockList;
    end;
  end;
end;

function TPlayScene.NewActor(chrid: Integer; // 角色ID
  cx: word; // x
  cy: word; // y
  cdir: word; cfeature: Integer; // race, hair, dress, weapon
  cstate, properties, dressweapon: Integer): TActor;
var
  I: Integer;
  Actor: TActor;
  AList: TList;
begin
  Result := nil;
  AList := m_ActorList.LockList;
  try
    for I := 0 to AList.Count - 1 do
    begin
      if TActor(AList[I]).m_nRecogId = chrid then
      begin
        Result := AList[I];
        Exit;
      end;
    end;
  finally
    m_ActorList.UnlockList;
  end;

  if IsChangingFace(chrid) then
    Exit;
  // 变脸中...
  // 根据Race创建对应的角色对象
  case RACEfeature(cfeature) of // m_btRaceImg
    0, 1, 150, 151, 152, 153:  Actor := THumActor.Create; // 人
    9:  Actor := TSoccerBall.Create; // 足球
    13: Actor := TKillingHerb.Create; // 食人花
    14: Actor := TSkeletonOma.Create; // 骷髅
    15: Actor := TDualAxeOma.Create; // 掷斧骷髅
    16: Actor := TGasKuDeGi.Create; // 洞蛆
    17: Actor := TCatMon.Create; // 钩爪猫
    18: Actor := THuSuABi.Create; // 稻草人
    19: Actor := TCatMon.Create; // 沃玛战士
    20: Actor := TFireCowFaceMon.Create; // 火焰沃玛
    21: Actor := TCowFaceKing.Create; // 沃玛教主
    22: Actor := TDualAxeOma.Create; // 黑暗战士
    23: Actor := TWhiteSkeleton.Create; // 变异骷髅
    24: Actor := TSuperiorGuard.Create; // 带刀卫士
    25: Actor := TGrassSpider.Create;
    26: Actor := TBoxSpider.Create;
    30: Actor := TCatMon.Create; // 朝俺窿
    31: Actor := TCatMon.Create; // 角蝇
    32: Actor := TScorpionMon.Create; // 蝎子
    33: Actor := TCentipedeKingMon.Create; // 触龙神
    34: Actor := TBigHeartMon.Create; // 赤月恶魔
    35: Actor := TSpiderHouseMon.Create; // 幻影蜘蛛
    36: Actor := TExplosionSpider.Create; // 月魔蜘蛛
    37: Actor := TFlyingSpider.Create; //
    40: Actor := TZombiLighting.Create; // 僵尸1
    41: Actor := TZombiDigOut.Create; // 僵尸2
    42: Actor := TZombiZilkin.Create; // 僵尸3
    43: Actor := TBeeQueen.Create; // 角蝇巢
    45: Actor := TArcherMon.Create; // 弓箭手
    47: Actor := TSculptureMon.Create; // 祖玛雕像
    48: Actor := TSculptureMon.Create; //
    49: Actor := TSculptureKingMon.Create; // 祖玛教主
    50:
    begin
      Actor := TNpcActor.Create;
    end;
    52: Actor := TGasKuDeGi.Create; // 楔蛾
    53: Actor := TGasKuDeGi.Create; // 粪虫
    54: Actor := TSmallElfMonster.Create; // 神兽
    55: Actor := TWarriorElfMonster.Create; // 神兽1
    60: Actor := TElectronicScolpionMon.Create;
    61: Actor := TBossPigMon.Create;
    62: Actor := TKingOfSculpureKingMon.Create;
    63: Actor := TSkeletonKingMon.Create;
    64: Actor := TGasKuDeGi.Create;
    65: Actor := TSamuraiMon.Create;
    66: Actor := TSkeletonSoldierMon.Create;
    67: Actor := TSkeletonSoldierMon.Create;
    68: Actor := TSkeletonSoldierMon.Create;
    69: Actor := TSkeletonArcherMon.Create;
    70: Actor := TBanyaGuardMon.Create; // 牛魔法师
    71: Actor := TBanyaGuardMon.Create; // 牛魔祭司
    72: Actor := TBanyaGuardMon.Create; // 暗之牛魔王
    73: Actor := TPBOMA1Mon.Create;
    74: Actor := TCatMon.Create;
    75: Actor := TStoneMonster.Create;
    76: Actor := TSuperiorGuard.Create;
    77: Actor := TStoneMonster.Create;
    78: Actor := TBanyaGuardMon.Create; // 魔龙怪
    79: Actor := TPBOMA6Mon.Create;
    80: Actor := TMineMon.Create;
    81: Actor := TAngel.Create;
    83: Actor := TFireDragon.Create; // 火龙教主  20080304
    84: Actor := TDragonStatue.Create;  //火龙神
    90: Actor := TDragonBody.Create; // 龙
    91: Actor := TRedThunderZuma.Create;
    92: Actor := TheCrutchesSpider.Create; // 金杖蜘蛛
    93: Actor := TYanLeiWangSpider.Create; // 雷炎蛛王 20080812
    94: Actor := TSnowy.Create; // 雪域寒冰魔、雪域灭天魔、雪域五毒魔
    95: Actor := TFireDragonGuard.Create; // 火龙守护兽
    96: Actor := TSwordsmanMon.Create;
    97: Actor := TSwordsmanMon.Create;
    98: Actor := TWallStructure.Create; // LeftWall
    99: Actor := TCastleDoor.Create; // MainDoor
    100:Actor := TFairyMonster.Create; // 月灵
  else
    Actor := TMonActor.Create;
  end;

  with Actor do
  begin
    m_nRecogId := chrid;
    m_nCurrX := cx;
    m_nCurrY := cy;
    m_nRx := m_nCurrX;
    m_nRy := m_nCurrY;
    m_btDir := cdir;
    m_nFeature := cfeature;
    m_nDressWeapon := dressweapon;

    Race := RACEfeature(cfeature); // 种族
    m_btHair := HAIRfeature(cfeature); // 头发
    m_btSex := LoByte(HiWord(cfeature));
    m_wAppearance := APPRfeature(cfeature); // 外貌
    m_boMonNPC := HiByte(LoWord(cfeature)) in [1, 2];
    m_boFriendly := HiByte(LoWord(cfeature)) in [1, 3];

    m_btDress := DRESSfeature(dressweapon);
    if m_btDress < 1000 then
      m_btDress := m_btDress * 2 + m_btSex;
    m_btWeapon := WEAPONfeature(dressweapon);
    if m_btWeapon < 1000 then
      m_btWeapon := m_btWeapon * 2 + m_btSex;

    if properties > 0 then
    begin
      m_btJob := LoByte(LoWord(properties));
      m_btHorse := HiWord(properties);
    end;
    if not (Race in [0, 1, 150]) then
      m_btSex := 0;
    SetStatus(cstate);
    m_SayingArr[0] := '';
  end;
  m_ActorList.Add(Actor);
  Result := Actor;
end;

procedure TPlayScene.ActorDied(Actor: TActor);
var
  I: Integer;
  AList: TList;
begin
  try
    Actor.m_btHorse := 0;
    AList := m_ActorList.LockList;
    try
      AList.Remove(Actor);
      if AList.Count > 0 then
      begin
        for I := 0 to AList.Count - 1 do
        begin
          if not TActor(AList[I]).m_boDeath then
          begin
            AList.Insert(I, Actor);
            Exit;
          end;
        end;
      end;
      AList.Add(Actor);
    finally
      m_ActorList.UnlockList;
    end;
  except
  end;
end;

// 设置角色的显示层级（角色列表的顺序）
// 当Level=0时，将把指定的角色置于角色列表的最前面
procedure TPlayScene.AddTopMostActor(Actor: TActor);
begin
  try
    if (Actor <> nil) and (m_TopMost.IndexOf(Actor) = -1) then
      m_TopMost.Add(Actor);
  except
  end;
end;

// 清除所有角色
procedure TPlayScene.ClearActors; // 肺弊酒眶父 荤侩
var
  I: Integer;
  AList: TList;
begin
  try
    AList := m_ActorList.LockList;
    try
      for I := 0 to AList.Count - 1 do
        TActor(AList[I]).Free;
      AList.Clear;
    finally
      m_ActorList.UnlockList;
    end;
    m_TopMost.Clear;

    g_MySelf := nil;
    g_TargetCret := nil;
    g_FocusCret := nil;
    g_MagicTarget := nil;
    g_MagicLockActor := nil;

    // 清除魔法效果对象
    if m_EffectList.Count > 0 then
    begin // 20080629
      for I := 0 to m_EffectList.Count - 1 do
        TMagicEff(m_EffectList[I]).Free;
      m_EffectList.Clear;
    end;
  except
    DebugOutStr('TPlayScene.ClearActors');
  end;
end;

// 根据角色ID删除一个角色
function TPlayScene.DeleteActor(id: Integer): TActor;
var
  I: Integer;
  AList: TList;
begin
  try
    Result := nil;
    I := 0;
    AList := m_ActorList.LockList;
    try
      for I := AList.Count - 1 downto 0 do
      begin
        if TActor(AList[I]).m_nRecogId = id then
        begin
          if g_TargetCret = AList[I] then
            g_TargetCret := nil;
          if g_FocusCret = AList[I] then
            g_FocusCret := nil;
          if g_MagicTarget = AList[I] then
            g_MagicTarget := nil;
          if g_MagicLockActor = AList[I] then
            g_MagicLockActor := nil;
          TActor(AList[I]).m_dwDeleteTime := GetTickCount;
          TActor(AList[I]).m_boDelActor := True;
          m_FreeActorList.Add(AList[I]);
          AList.Delete(I);
        end;
      end;
    finally
      m_ActorList.UnlockList;
    end;
  except
  end;
end;

// 从角色列表中删除一个角色
procedure TPlayScene.DelActor(Actor: TObject);
begin
  try
    if (Actor <> nil) and (Actor is TActor) then
    begin
      m_ActorList.Remove(Actor);
      TActor(Actor).m_dwDeleteTime := GetTickCount;
      TActor(Actor).m_boDelActor := True;
      m_FreeActorList.Add(Actor);
    end;
  except
  end;
end;

// 返回坐标(X,Y)处的角色，这个角色已经死亡，且不是人类
function TPlayScene.ButchAnimal(x, y: Integer): TActor;
var
  I: Integer;
  AActor: TActor;
  AList: TList;
begin
  Result := nil;
  AList := m_ActorList.LockList;
  try
    for I := 0 to AList.Count - 1 do
    begin
      AActor := AList[I];
      if AActor.m_boDeath and (AActor.Race <> 0) then
      begin
        if (abs(AActor.m_nCurrX - x) <= 1) and (abs(AActor.m_nCurrY - y) <= 1) then
        begin
          Result := AActor;
          break;
        end;
      end;
    end;
  finally
    m_ActorList.UnlockList;
  end;
end;

procedure TPlayScene.SendMsg(ident, chrid, x, y, cdir, feature, state, properties, dressweapon: Integer; const str: string; AHookProc: TActorHookProc);
var
  Actor: TActor;
begin
  try
    case ident of
      SM_CHANGEMAP, SM_NEWMAP:
        begin
          g_Pilot :=  nil;
          g_boAutoDig := False;
          g_uAutoRun := False;
          m_btDark := cdir;
          ClearAutoRunPointList;
          g_boChangeMapStopMusic := False;
          if not g_SoundManager.MapMusicSilenced then
          begin
            g_SoundManager.MapMusicSilenced := True;
            g_boChangeMapStopMusic := True;
          end;
          Map.m_boAllowNewMap := LoWord(chrid) = 1;
          if Map.m_boAllowNewMap then
          begin
            Map.m_btOffsetX := LoByte(HiWord(chrid));
            Map.m_btOffsetY := HiByte(HiWord(chrid));
          end
          else
          begin
            Map.m_btOffsetX := 0;
            Map.m_btOffsetY := 0;
          end;
          Map.LoadMap(str, x, y);
          if g_boViewMiniMap then
          begin
            g_nMiniMapIndex := -1;
            FrmMain.SendWantMiniMap;
          end;
          //
          if (ident = SM_NEWMAP) and (g_MySelf <> nil) then
          begin
            g_MySelf.m_nCurrX := x;
            g_MySelf.m_nCurrY := y;
            g_MySelf.m_nRx := x;
            g_MySelf.m_nRy := y;
            DelActor(g_MySelf);
          end;
          if HiWord(cdir) = 1 then
            DScreen.ChangeMapDeleteCountDown;
        end;
      SM_RECALLHERO:
        begin
          Actor := FindActor(chrid);
          if Actor = nil then
          begin
            Actor := NewActor(chrid, x, y, Lobyte(cdir), feature, state, properties, dressweapon);
            Actor.m_nChrLight := Hibyte(cdir);
          end;
        end;
      SM_CREATEHERO:
        begin
          Actor := FindActor(chrid);
          if Actor = nil then
          begin
            Actor := NewActor(chrid, x, y, Lobyte(cdir), feature, state, properties, dressweapon);
            Actor.m_nChrLight := Hibyte(cdir);
          end;
        end;
      SM_LOGON:
        begin
          Actor := FindActor(chrid);
          if Actor = nil then
          begin
            Actor := NewActor(chrid, x, y, Lobyte(cdir), feature, state, properties, dressweapon);
            Actor.m_nChrLight := Hibyte(cdir);
//TODO
//            cdir := Lobyte(cdir);
//            Actor.SendMsg(SM_TURN, x, y, cdir, feature, state, properties, dressweapon, '', 0); // 转向
          end;
          if g_MySelf <> nil then
            g_MySelf := nil;
          g_MySelf := THumActor(Actor);
        end;
      SM_HIDE:
        begin
          Actor := FindActor(chrid);
          if Actor <> nil then
          begin
            if g_Pilot = Actor then
              g_Pilot :=  nil;
            if Actor.m_boDelActionAfterFinished then
              Exit;
            if Actor.m_nWaitForRecogId <> 0 then
              Exit;
          end;
          DeleteActor(chrid);
        end;
    else
      begin
        Actor := FindActor(chrid);
        case ident of
          SM_TURN, SM_HORSERUN, SM_WALK, SM_RUN, SM_NPCWALK, SM_BACKSTEP, SM_BATTERBACKSTEP, SM_DEATH, SM_SKELETON, SM_DIGUP,SM_ALIVE, SM_SNEAK:
          begin
            if Actor = nil then
              Actor := NewActor(chrid, x, y, Lobyte(cdir), feature, state, properties, dressweapon);
            if Actor <> nil then
            begin
                            //由于服务端优化的原因 可能导致SM_ALIVE 消息没有下发下来 导致 可能出现  3：使用复活命令复活后，会出现“A杀死B，B跑回到A身边砍A，A有几率看不到B 的问题
              //考虑到服务端的优化是必要性的所以客户端这里检测一下执行解决此BUG  随云
              if (Actor.m_boDeath) and ((ident = SM_RUN) or (ident = SM_WALK) )then
              begin
                Actor.m_Abil.HP := 1;
                Actor.m_boDeath := FALSE;
                Actor.m_boSkeleton := FALSE;
              end;

              if Assigned(AHookProc) then
              begin
                try
                  AHookProc(Actor);
                except
                end;
              end;

              Actor.m_nChrLight := Hibyte(cdir);
              cdir := Lobyte(cdir);
              if ident = SM_SKELETON then
              begin
                Actor.m_boDeath := True;
                Actor.m_boSkeleton := True;
              end;
            end;
          end;

//          SM_WALK,SM_RUN:
//          begin
//            if Actor <> nil then
//            begin
//              //由于服务端优化的原因 可能导致SM_ALIVE 消息没有下发下来 导致 可能出现  3：使用复活命令复活后，会出现“A杀死B，B跑回到A身边砍A，A有几率看不到B 的问题
//              //考虑到服务端的优化是必要性的所以客户端这里检测一下执行解决此BUG  随云
//              if (Actor.m_boDeath) and ((ident = SM_RUN) or (ident = SM_WALK) )then
//              begin
//                Actor.m_Abil.HP := 1;
//                Actor.m_boDeath := FALSE;
//                Actor.m_boSkeleton := FALSE;
//              end;
//
//              Actor.SendMsg(ident, x, y, cdir, 0, 0, 0, 0, '', 0);
//              Exit;
//            end;
//          end;
        end;


        if Actor = nil then
          Exit;
        if (Actor<>g_MySelf) and (g_Pilot = Actor) and ((ABS(Actor.m_nCurrX-g_MySelf.m_nCurrX)> 1) or (ABS(Actor.m_nCurrY-g_MySelf.m_nCurrY)> 1)) then
          FrmMain.AutoFollow(Actor.m_nCurrX, Actor.m_nCurrY);
        case ident of
          SM_FEATURECHANGED:
            begin
              Actor.m_nFeature := feature;
              Actor.m_nDressWeapon := dressweapon;
              Actor.m_nFeatureEx := state;
              Actor.m_btHorse := LoWord(cdir);
              Actor.m_wShield := HiWord(cdir);
              if Assigned(AHookProc) then
              begin
                try
                  AHookProc(Actor);
                except
                end;
              end;
              Actor.FeatureChanged;
            end;
          SM_CHARSTATUSCHANGED:
            begin
              Actor.SetStatus(feature);
              Actor.m_nHitSpeed := state;
              Actor.m_nGrpCount :=  properties;
            end;
          SM_MAGIC69SKILLNH:
            begin
              Actor.m_Skill69NH := x;
              Actor.m_Skill69MaxNH := y;
            end;
          SM_CHARDESC:
          begin
             if Assigned(AHookProc) then
             begin
               try
                 AHookProc(Actor);
               except
               end;
             end;
          end
        else
          begin
            if ident = SM_TURN then
            begin
              if str <> '' then
                Actor.m_sUserName := str;
            end;
            Actor.SendMsg(ident, x, y, cdir, feature, state, properties, dressweapon, '', 0);
          end;
        end;
      end;
    end;
  except
  end;
end;

end.
