unit clEvent;

interface

uses
  Windows, Classes, AbstractCanvas, AbstractTextures, Grobal2, CliUtil, MShare,
  DXHelper, uMagicTypes, Generics.Collections, uCliUITypes, SoundUtil,magiceff;

const
  ZOMBIDIGUPDUSTBASE = 420;
  // 石墓尸王从土中钻出来(的事件event),,这里是图片帧，存在于mon6.wil中从第420开始的地图效果
  STONEFRAGMENTBASE = 64;
  // Effect.wil中,,,挖矿时会有二个地图效果，1，尘土飞扬，不在地面堆积 2,碎石坠落，，在地面产生变化就像ZOMBIDIGUPDUSTBASE,,
  HOLYCURTAINBASE = 1390; // Magic.wil,,困魔咒的地面效果
  FIREBURNBASE = 1630; // 火墙的地面效果
  SCULPTUREFRAGMENT = 1349; // mon7.wil中祖玛教主被激活

type
  TClEventManager = class;
  TCustomEvent = class
  private
    FManager: TClEventManager;
  public
    m_nServerId: Integer;
    m_nEventType: Integer;
    m_nEventParam: Integer;
    m_nX: Integer;
    m_nY: Integer;
    m_nTag: Integer;
  public
    constructor Create(svid, ax, ay, evtype: Integer); virtual;

    procedure DrawEvent(backsurface: TAsphyreCanvas; ax, ay: Integer); virtual;
    procedure Run; virtual;
    procedure Stop; virtual;
  end;

  TClEffectEvent = class(TCustomEvent)
  private
    FEffect: TEffect;
    procedure DoEndFrame(Sender: TObject);
    procedure DoSoundEffect(Sender: TObject; const Sound: String);
  public
    constructor Create(svid, ax, ay, evtype: Integer); override;
    destructor Destroy; override;

    procedure DrawEvent(backsurface: TAsphyreCanvas; ax, ay: Integer); override;
    procedure Run; override;
    procedure Stop; override;
  end;

  TClMagicEvent = class(TCustomEvent)
  private
    FEffect: TEffect;
    procedure DoSoundEffect(Sender: TObject; const Sound: String);
  public
    constructor Create(svid, ax, ay, evtype, aTag: Integer);
    destructor Destroy; override;

    procedure DrawEvent(backsurface: TAsphyreCanvas; ax, ay: Integer); override;
    procedure Run; override;
    procedure Stop; override;
  end;

  //技能的特效  随云
  TClSkillEvent = class(TCustomEvent)
  private
    FEffect: TPlayAnimationEffect;
  public
    constructor Create(svid, ax, ay, evtype, aTag: Integer);
    destructor Destroy; override;

    procedure DrawEvent(backsurface: TAsphyreCanvas; ax, ay: Integer); override;
    procedure Run; override;
    procedure Stop; override;
  end;


  TClEvent = class(TCustomEvent)
    m_nDir: Integer;
    m_nPx: Integer;
    m_nPy: Integer;
    m_Dsurface: TAsphyreLockableTexture;
    m_boBlend: Boolean;
    m_dwFrameTime: LongWord;
    m_dwFrameTime1: LongWord; // 烟花
    m_dwCurframe: LongWord;
    m_dwCurframe1: LongWord; // 烟花
    m_nLight: Integer;
  public
    constructor Create(svid, ax, ay, evtype: Integer); override;

    procedure DrawEvent(backsurface: TAsphyreCanvas; ax, ay: Integer); override;
    procedure Run; override;
  end;

  TClEventManager = class
  private
    procedure DeleteEvent(AEvent: TCustomEvent);
  public
    EventList: TList<TCustomEvent>;
    constructor Create;
    destructor Destroy; override;
    procedure ClearEvents;
    function AddEvent(evn: TCustomEvent): TCustomEvent;
    procedure DelEvent(evn: TCustomEvent);
    procedure DelEventById(svid: Integer);
    function GetEvent(ax, ay, etype: Integer): TCustomEvent;
    procedure Execute;
  end;

implementation
  uses uMagicMgr,SkillEffectConfig,PlayScn,ClMain;

{ TCustomEvent }

constructor TCustomEvent.Create(svid, ax, ay, evtype: Integer);
begin
  m_nServerId := svid;
  m_nX := ax;
  m_nY := ay;
  m_nEventType := evtype;
  m_nEventParam := 0;
end;

procedure TCustomEvent.DrawEvent(backsurface: TAsphyreCanvas; ax, ay: Integer);
begin

end;

procedure TCustomEvent.Run;
begin

end;

procedure TCustomEvent.Stop;
begin
  if FManager <> nil then
    FManager.DeleteEvent(Self);
end;

{ TClEffectEvent }

constructor TClEffectEvent.Create(svid, ax, ay, evtype: Integer);
begin
  inherited;
  FEffect := UIWindowManager.CreateEffect(evtype);
  if FEffect <> nil then
  begin
    FEffect.OnEndFrame  :=  DoEndFrame;
    FEffect.OnSoundEvent:=  DoSoundEffect;
  end;
end;

destructor TClEffectEvent.Destroy;
begin
  if FEffect <> nil then
    FEffect.Free;
  inherited;
end;

procedure TClEffectEvent.DoEndFrame(Sender: TObject);
begin
  if FManager <> nil then
    FManager.DeleteEvent(Self);
end;

procedure TClEffectEvent.DoSoundEffect(Sender: TObject; const Sound: String);
begin
  g_SoundManager.PlaySoundEx(Sound);
end;

procedure TClEffectEvent.DrawEvent(backsurface: TAsphyreCanvas; ax, ay: Integer);
begin
  if FEffect <> nil then
    FEffect.Draw(backsurface, ax, ay);
end;

procedure TClEffectEvent.Run;
begin
  if FEffect <> nil then
    FEffect.Run;
end;

procedure TClEffectEvent.Stop;
begin
  if FEffect <> nil then
    FEffect.Stop;
end;


{ TClMagicEvent }

constructor TClMagicEvent.Create(svid, ax, ay, evtype, aTag: Integer);
var
  AClient: TuMagicClient;
begin
  inherited Create(svid, ax, ay, evtype);
  FEffect := nil;
  if g_MagicMgr.TryGet(evtype, AClient) then
  begin
    FEffect := CreateEffectFromMagicRun(AClient, aTag);
    if FEffect <> nil then
    begin
      FEffect.OnSoundEvent :=  DoSoundEffect;
      FEffect.Initializa;
    end;
  end;
end;

destructor TClMagicEvent.Destroy;
begin
  if FEffect <> nil then
    FEffect.Free;
  inherited;
end;

procedure TClMagicEvent.DoSoundEffect(Sender: TObject; const Sound: String);
begin
  g_SoundManager.PlaySoundEx(Sound);
end;

procedure TClMagicEvent.DrawEvent(backsurface: TAsphyreCanvas; ax, ay: Integer);
begin
  if FEffect <> nil then
    FEffect.Draw(backsurface, ax, ay);
end;

procedure TClMagicEvent.Run;
begin
  if FEffect <> nil then
    FEffect.Run;
end;

procedure TClMagicEvent.Stop;
begin
  if FEffect <> nil then
    FEffect.Stop;
end;

{ TClEvent }

constructor TClEvent.Create(svid, ax, ay, evtype: Integer);
begin
  inherited;
  m_boBlend := FALSE;
  m_dwFrameTime := GetTickCount;
  m_dwCurframe := 0;
  m_dwCurframe1 := 0;
  m_nLight := 0;
  m_nDir  :=  0;
  m_nTag := 0;
end;

procedure TClEvent.DrawEvent(backsurface: TAsphyreCanvas; ax, ay: Integer);
begin
  if m_Dsurface <> nil then
  begin
    if m_boBlend then
      backsurface.DrawBlend(ax + m_nPx, ay + m_nPy, m_Dsurface, 1)
    else
      backsurface.Draw(ax + m_nPx, ay + m_nPy, m_Dsurface);
  end;
end;

procedure TClEvent.Run;
begin
  m_Dsurface := nil;
  if GetTickCount - m_dwFrameTime > { 100{ } 20 then
  begin
    m_dwFrameTime := GetTickCount;
    Inc(m_dwCurframe);
  end;

  case m_nEventType of
    ET_FIREFLOWER_1 .. ET_FIREFLOWER_7:
      begin
        if GetTickCount - m_dwFrameTime1 > 120 then
        begin
          m_dwFrameTime1 := GetTickCount;
          Inc(m_dwCurframe1);
        end;
        if m_dwCurframe1 >= 20 then
        begin
          Stop;
          Exit;
        end;
      end;
    ET_HEROLOGOUT:
      begin
        if GetTickCount - m_dwFrameTime1 > 100 then
        begin
          m_dwFrameTime1 := GetTickCount;
          Inc(m_dwCurframe1);
        end;
        if m_dwCurframe1 >= 10 then
        begin
          Stop;
          Exit;
        end;
      end;
    ET_SOULETRAP:
      begin
        if GetTickCount - m_dwFrameTime1 > 100 then
        begin
          m_dwFrameTime1 := GetTickCount;
          Inc(m_dwCurframe1);
          if m_dwCurframe1 >= 10 then
            m_dwCurframe1 := 0;
        end;
      end;
    ET_SOULETRAPLOCKED:
      begin
        if GetTickCount - m_dwFrameTime1 > 100 then
        begin
          m_dwFrameTime1 := GetTickCount;
          Inc(m_dwCurframe1);
          if m_dwCurframe1 >= 8 then
            m_dwCurframe1 := 0;
        end;
      end;
    ET_DIEEVENT:
      begin
        if GetTickCount - m_dwFrameTime1 > 60 then
        begin
          m_dwFrameTime1 := GetTickCount;
          Inc(m_dwCurframe1);
        end;
        if m_dwCurframe1 >= 15 then
        begin
          Stop;
          Exit;
        end;
      end;
    ET_FIREDRAGON:
      begin
        if GetTickCount - m_dwFrameTime1 > 50 then
        begin
          m_dwFrameTime1 := GetTickCount;
          Inc(m_dwCurframe1);
        end;
        if m_dwCurframe1 >= 34 then
        begin
          Stop;
          Exit;
        end;
      end;
    ET_FOUNTAIN:
      begin
        // 喷发泉水
        if GetTickCount - m_dwFrameTime1 > 80 then
        begin
          m_dwFrameTime1 := GetTickCount;
          Inc(m_dwCurframe1);
        end;
        if m_dwCurframe1 >= 12 then
          m_dwCurframe1 := 0;
      end;
  end;

  case m_nEventType of
    ET_DIGOUTZOMBI:
      m_Dsurface := g_WMonImagesArr[5].GetCachedImage(ZOMBIDIGUPDUSTBASE + m_nDir, m_nPx, m_nPy);
    ET_PILESTONES:
      begin
        if m_nEventParam <= 0 then
          m_nEventParam := 1;
        if m_nEventParam > 5 then
          m_nEventParam := 5;
        m_Dsurface := g_WEffectImages.GetCachedImage(STONEFRAGMENTBASE + (m_nEventParam - 1), m_nPx, m_nPy);
      end;
    ET_HOLYCURTAIN:
      begin
        m_Dsurface := g_WMagicImages.GetCachedImage(HOLYCURTAINBASE + (m_dwCurframe mod 10), m_nPx, m_nPy);

        m_boBlend := TRUE;
        m_nLight := 1;
      end;
    ET_FIRE:
    begin
      case m_nTag of
        0: m_Dsurface := g_WMagicImages.GetCachedImage(FIREBURNBASE + ((m_dwCurframe div 2) mod 6), m_nPx, m_nPy);
        1..3: m_Dsurface := g_WMagic716Images.GetCachedImage(90 + ((m_dwCurframe div 2) mod 8), m_nPx, m_nPy);
        4..6: m_Dsurface := g_WMagic716Images.GetCachedImage(100 + ((m_dwCurframe div 2) mod 8), m_nPx, m_nPy);
        else{7..9}
          m_Dsurface := g_WMagic716Images.GetCachedImage(110 + ((m_dwCurframe div 2) mod 8), m_nPx, m_nPy);
      end;
      m_boBlend := TRUE;
      m_nLight := 1;
    end;

    ET_HEROLOGOUT:
      begin
        m_Dsurface := g_WEffectImages.GetCachedImage(810 + m_dwCurframe1, m_nPx, m_nPy);
        m_boBlend := TRUE;
        m_nLight := 1;
      end;
    ET_SOULETRAP:
      begin
        m_Dsurface := g_WMagicCKImages.GetCachedImage(1340 + m_dwCurframe1, m_nPx, m_nPy);
        m_boBlend := TRUE;
        m_nLight := 1;
      end;
    ET_SOULETRAPLOCKED:
      begin
        m_Dsurface := g_WMagicCKImages.GetCachedImage(1360 + m_dwCurframe1, m_nPx, m_nPy);
        m_boBlend := TRUE;
        m_nLight := 1;
      end;
    ET_FIREDRAGON:
      begin
        m_Dsurface := g_WDragonImages.GetCachedImage(350 + m_dwCurframe1, m_nPx, m_nPy);
        m_boBlend := TRUE;
        m_nLight := 1;
      end;
    ET_FIREFLOWER_1:
      begin // 一心一意
        m_Dsurface := g_WMagic3Images.GetCachedImage(60 + m_dwCurframe1, m_nPx, m_nPy);
        m_boBlend := TRUE;
        m_nLight := 1;
      end;
    ET_FIREFLOWER_2:
      begin // 心心相印
        m_Dsurface := g_WMagic3Images.GetCachedImage(80 + m_dwCurframe1, m_nPx, m_nPy);
        m_boBlend := TRUE;
        m_nLight := 1;
      end;
    ET_FIREFLOWER_3:
      begin
        m_Dsurface := g_WMagic3Images.GetCachedImage(100 + m_dwCurframe1, m_nPx, m_nPy);
        m_boBlend := TRUE;
        m_nLight := 1;
      end;
    ET_FIREFLOWER_4:
      begin
        m_Dsurface := g_WMagic3Images.GetCachedImage(120 + m_dwCurframe1, m_nPx, m_nPy);
        m_boBlend := TRUE;
        m_nLight := 1;
      end;
    ET_FIREFLOWER_5:
      begin
        m_Dsurface := g_WMagic3Images.GetCachedImage(140 + m_dwCurframe1, m_nPx, m_nPy);
        m_boBlend := TRUE;
        m_nLight := 1;
      end;
    ET_FIREFLOWER_6:
      begin
        m_Dsurface := g_WMagic3Images.GetCachedImage(160 + m_dwCurframe1, m_nPx, m_nPy);
        m_boBlend := TRUE;
        m_nLight := 1;
      end;
    ET_FIREFLOWER_7:
      begin
        m_Dsurface := g_WMagic3Images.GetCachedImage(180 + m_dwCurframe1, m_nPx, m_nPy);
        m_boBlend := TRUE;
        m_nLight := 1;
      end;
    // ---------------------------------------------------------------------------------

    ET_SCULPEICE:
      begin
        m_Dsurface := g_WMonImagesArr[6].GetCachedImage(SCULPTUREFRAGMENT, m_nPx, m_nPy);
      end;
    ET_FOUNTAIN:
      begin // 泉水喷发 20080624
        m_Dsurface := g_WMain2Images.GetCachedImage(550 + m_dwCurframe1, m_nPx, m_nPy);
        m_boBlend := TRUE;
        m_nLight := 1;
      end;
    ET_DIEEVENT:
      begin
        m_Dsurface := g_WMain2Images.GetCachedImage(110 + m_dwCurframe1, m_nPx, m_nPy);
        m_boBlend := TRUE;
        m_nLight := 1;
      end;
  end;
end;

{TClEventManager}

constructor TClEventManager.Create;
begin
  EventList := TList<TCustomEvent>.Create;
end;

destructor TClEventManager.Destroy;
var
  i: Integer;
begin
  if EventList.Count > 0 then
    for i := 0 to EventList.Count - 1 do
      EventList[i].Free;
  EventList.Free;
  inherited Destroy;
end;

procedure TClEventManager.ClearEvents;
var
  i: Integer;
begin
  if EventList.Count > 0 then
    for i := 0 to EventList.Count - 1 do
      TClEvent(EventList[i]).Free;
  EventList.Clear;
end;

function TClEventManager.AddEvent(evn: TCustomEvent): TCustomEvent;
var
  i: Integer;
begin
  Result := nil;
  if EventList.Count > 0 then
  begin
    for i := 0 to EventList.Count - 1 do
    begin
      if (EventList[i] = evn) then
      begin
        Result := evn;
        Exit;
      end
      else if (EventList[i].m_nServerId = evn.m_nServerId) and (evn.m_nX = EventList[i].m_nX) and (evn.m_nY = EventList[i].m_nY) then
      begin
        EventList[I].Stop;
        Break;
      end;
    end;
  end;
  evn.FManager := Self;
  EventList.Add(evn);
  Result := evn;
end;

procedure TClEventManager.DeleteEvent(AEvent: TCustomEvent);
begin
  if AEvent <> nil then
  begin
    EventList.Remove(AEvent);
    AEvent.Free;
  end;
end;

procedure TClEventManager.DelEvent(evn: TCustomEvent);
var
  i: Integer;
begin
  if EventList.Count > 0 then
    for i := 0 to EventList.Count - 1 do
      if EventList[i] = evn then
      begin
        EventList[i].Stop;
        break;
      end;
end;

procedure TClEventManager.DelEventById(svid: Integer);
var
  i: Integer;
begin
  if EventList.Count > 0 then
  begin
    for i := 0 to EventList.Count - 1 do
      if EventList[i].m_nServerId = svid then
      begin
        EventList[i].Stop;
        break;
      end;
  end;
end;

function TClEventManager.GetEvent(ax, ay, etype: Integer): TCustomEvent;
var
  i: Integer;
begin
  Result := nil;
  if EventList.Count > 0 then
    for i := 0 to EventList.Count - 1 do
      if (EventList[i].m_nX = ax) and (EventList[i].m_nY = ay) and (EventList[i].m_nEventType = etype) then
      begin
        Result := EventList[i];
        break;
      end;
end;

procedure TClEventManager.Execute;
var
  i: Integer;
begin
  if EventList.Count > 0 then
    for i := EventList.Count - 1 downto 0 do
    begin
      EventList[i].Run;
    end;
end;

{ TClSkillEvent }

constructor TClSkillEvent.Create(svid, ax, ay, evtype, aTag: Integer);
var
  Effect:TSkillEffectConfig;
begin
  inherited Create(svid, ax, ay, evtype);
  Effect := g_SkillEffectData.FindEffectConfigByID(aTag);
  if Effect <> nil then
  begin
    if Effect.EffectType = seAnimation then
    begin
      FEffect := TPlayAnimationEffect.Create(nil,Effect.Data,Effect.ImageIndex,Effect.FrameCountPerDir,Effect.FramePerTime);

      TPlayAnimationEffect(FEffect).SetIsSceneEffect();
      FEffect.Repetition := True;

      if Effect.FramePerTime = -1then
        TPlayAnimationEffect(FEffect).SetFrameTime(Effect.FrameTimeArray);
    end;
  end;
end;

destructor TClSkillEvent.Destroy;
begin
  if FEffect <> nil then
    FEffect.Free;
  inherited;
end;

procedure TClSkillEvent.DrawEvent(backsurface: TAsphyreCanvas; ax, ay: Integer);
begin
  inherited;
  if FEffect <> nil then
  begin
    FEffect.Shift;
    FEffect.EventDraw := True;
    FEffect.FlyX := ax;
    FEffect.FlyY := ay;
    FEffect.DrawEff(backsurface);
  end;
end;

procedure TClSkillEvent.Run;
begin
  inherited;

end;

procedure TClSkillEvent.Stop;
begin
  inherited;
  if FEffect <> nil then
    FEffect.m_boActive := False;
end;

end.
