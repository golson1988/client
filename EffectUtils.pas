unit EffectUtils;

interface
  uses Windows, Classes, SysUtils, AbstractCanvas, AbstractTextures, Wil, DXHelper;

type
  TDirectivity = (dtNone, dtDirection8, dtDirection16);
  TEffectProperties = class
  public
    Enabled: Boolean;
    Lib: TWMImages;
    Directivity: TDirectivity;
    StartIndex: Integer;
    FrameCount: Integer;
    SkipCount: Integer;
    FrameTime: Integer;
    Sound: String;
    PlaySoundAtFrame: Integer;
    function GetStartIndex(ADir: Byte): Integer; inline;
  end;

  TEffect = class
  private
    FRunTime: LongWord;
  public
    RunEffect: TEffectProperties;
    constructor Create; virtual;
    destructor Destroy; override;
    function Run: Boolean; virtual; abstract;
    procedure DirectPaint(Surface: TAsphyreCanvas); virtual; abstract;
  end;

  TMapEffect = class(TEffect)
  private
    FMapX, FMapY: Integer;
    FRepeatCount: Integer;
    FCurFrame: Integer;
  public
    constructor Create(X, Y: Integer);
    function Run: Boolean; override;
    procedure DirectPaint(Surface: TAsphyreCanvas); override;
  end;

  TObjectEffect = class(TEffect)
  private
    FOwner: TObject;
    FRepeatCount: Integer;
    FCurFrame: Integer;
  public
    constructor Create(AOwner: TObject);
    function Run: Boolean; override;
    procedure DirectPaint(Surface: TAsphyreCanvas); override;
  end;

  TMagicEffect = class(TEffect)
  private
    FOwner: TObject;
    FTarget: TObject;
    Repetition: Boolean;
    FixedEffect: Boolean;
    FSourceX, FSourceY, FTargetX, FTargetY: Integer;
    FireMyselfX, FireMyselfY: Integer;
    FCurFrame: Integer;
    FlyXf, FlyYf: Real;
    FXStep, FYStep: Real;
    FlyX, FlyY: integer;
    FDir16, FOldDir16: Byte;
    FRunFrameTime: LongWord;
    prevdisx: Integer;
    prevdisy: Integer;
  public
    HitEffect: TEffectProperties;
    constructor Create(AOwner, ATarget: TObject; AMagicID, SourceX, SourceY, TargetX, TargetY: Integer);
    function Run: Boolean; override;
    procedure DirectPaint(Surface: TAsphyreCanvas); override;
  end;

implementation
  uses CLMain, Grobal2, Actor, CLFunc, MShare;

{ TEffectProperties }

function TEffectProperties.GetStartIndex(ADir: Byte): Integer;
begin
  case Directivity of
    dtNone: Result := StartIndex;
    dtDirection8, dtDirection16: Result := StartIndex + ADir * FrameCount;
  end;
end;

{ TEffect }

constructor TEffect.Create;
begin
  RunEffect := TEffectProperties.Create;
end;

destructor TEffect.Destroy;
begin
  FreeAndNil(RunEffect);
  inherited;
end;

{ TMapEffect }

constructor TMapEffect.Create(X, Y: Integer);
begin
  inherited Create;
  FMapX := X;
  FMapY := Y;
end;

function TMapEffect.Run: Boolean;
begin
  Result := True;
  if GetTickCount - FRunTime > RunEffect.FrameTime then
  begin
    FRunTime := GetTickCount;
    Inc(FCurFrame);
    if FCurFrame > RunEffect.StartIndex + RunEffect.FrameCount - RunEffect.SkipCount - 1 then
    begin
      FCurFrame := RunEffect.StartIndex + RunEffect.FrameCount - RunEffect.SkipCount - 1;
      if FRepeatCount > 0 then
      begin
        Dec(FRepeatCount);
        FCurFrame := RunEffect.StartIndex;
      end
      else
        Result := False;
    end;
  end;
end;

procedure TMapEffect.DirectPaint(Surface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  X, Y, PX, PY: Integer;
begin
  PlayScene.ScreenXYfromMCXY(FMapX, FMapY, X, Y);
  D := RunEffect.Lib.GetCachedImage(FCurFrame, PX, PY);
  if d <> nil then
    Surface.DrawBlend(X + PX - UNITX div 2, Y + PY - UNITY div 2, D, 1);
end;

{ TObjectEffect }

constructor TObjectEffect.Create(AOwner: TObject);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TObjectEffect.Run: Boolean;
var
  AStartIdx: Integer;
begin
  Result := True;
  if GetTickCount - FRunTime > RunEffect.FrameTime then
  begin
    FRunTime := GetTickCount;
    AStartIdx := RunEffect.GetStartIndex(TActor(FOwner).m_btDir);
    Inc(FCurFrame);
    if FCurFrame > AStartIdx - RunEffect.SkipCount - 1 then
    begin
      FCurFrame := AStartIdx - RunEffect.SkipCount - 1;
      if FRepeatCount > 0 then
      begin
        Dec(FRepeatCount);
        FCurFrame := AStartIdx;
      end
      else
        Result := False;
    end;
  end;
end;

procedure TObjectEffect.DirectPaint(Surface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  X, Y, PX, PY: Integer;
begin
  if FOwner <> nil then
  begin
    PlayScene.ScreenXYfromMCXY(TActor(FOwner).m_nRx, TActor(FOwner).m_nRy, Y, X);
    Y := Y + TActor(FOwner).m_nShiftX;
    X := X + TActor(FOwner).m_nShiftY;
    D := RunEffect.Lib.GetCachedImage(FCurFrame, px, py);
    if D <> nil then
      Surface.DrawBlend(Y + px - UNITX div 2, X + py - UNITY div 2, D, 1);
  end;
end;

{ TMagicEffect }

constructor TMagicEffect.Create(AOwner, ATarget: TObject; AMagicID, SourceX, SourceY, TargetX, TargetY: Integer);
begin
  inherited Create;
  HitEffect := TEffectProperties.Create;
  FOwner := AOwner;
  FTarget := ATarget;
  FixedEffect := False;
  Repetition := True;
  FSourceX := SourceX;
  FSourceY := SourceY;
  FlyXf := SourceX;
  FlyYf := SourceY;
  FlyX := SourceX; //
  FlyY := SourceY;
  FTargetX := TargetX;
  FTargetY := TargetY;
  FireMyselfX := g_Myself.m_nRx * UNITX + g_Myself.m_nShiftX;
  FireMyselfY := g_Myself.m_nRy * UNITY + g_Myself.m_nShiftY;
  FDir16 := GetFlyDirection16(SourceX, SourceY, TargetX, TargetY);
  FOldDir16 := FDir16;
end;

function TMagicEffect.Run: Boolean;

  function OverThrough(AOlddir, ANewdir: Byte): Boolean;
  begin
    Result := False;
    if ABS(AOlddir - ANewdir) >= 2 then
    begin
      Result := True;
      if ((AOlddir = 0) and (ANewdir = 15)) or ((AOlddir = 15) and (ANewdir = 0)) then
        Result := False;
    end;
  end;

var
  AStart: Integer;
  ms, stepx, stepy: integer;
  shx, shy, passdir16: integer;
  crash: Boolean; // Åö×²
  NewXStep, NewYStep, stepxf, stepyf: Real;
  L: Real;
begin
  Result := True;
  if FixedEffect then
  begin
    if GetTickCount - FRunTime > RunEffect.FrameTime then
    begin
      FRunTime := GetTickCount;
      Inc(FCurFrame);
      AStart := RunEffect.GetStartIndex(FDir16);
      if FCurFrame > AStart + RunEffect.FrameCount - RunEffect.SkipCount - 1 then
        FCurFrame := AStart;
    end;
  end
  else
  begin
    if GetTickCount - FRunTime > HitEffect.FrameTime then
    begin
      FRunTime := GetTickCount;
      Inc(FCurFrame);
      AStart := HitEffect.GetStartIndex(FDir16);
      if FCurFrame > AStart + HitEffect.FrameCount - HitEffect.SkipCount - 1 then
      begin
        FCurFrame := AStart + HitEffect.FrameCount - HitEffect.SkipCount - 1;
        Result := False;
      end;
    end;
  end;
  if not FixedEffect then
  begin
    Crash := False;
    if FTarget <> nil then
    begin
      ms := GetTickCount - FRunFrameTime;
      FRunFrameTime := GetTickCount;
      PlayScene.ScreenXYfromMCXY(TActor(FTarget).m_nRx, TActor(FTarget).m_nRy, FTargetX, FTargetY);
      shx := (g_Myself.m_nRx * UNITX + g_Myself.m_nShiftX) - FireMyselfX;
      shy := (g_Myself.m_nRy * UNITY + g_Myself.m_nShiftY) - FireMyselfY;
      FTargetX := FTargetX + shx;
      FTargetY := FTargetY + shy;

      L := Sqrt(Sqr(FTargetX - FSourceX) + Sqr(FTargetY - FSourceY));
      NewXStep := (FTargetX - FSourceX) / L;
      NewYStep := (FTargetY - FSourceY) / L;
      FXStep := FXStep + (NewXStep - FXStep) / 2;
      FYStep := FYStep + (NewYStep - FYStep) / 2;

      stepxf := FXStep * ms / 1.3;
      stepyf := FYStep * ms / 1.3;
      FlyXf := FlyXf + stepxf;
      FlyYf := FlyYf + stepyf;
      FlyX := Round(FlyXf);
      FlyY := Round(FlyYf);
      passdir16 := GetFlyDirection16(FlyX, FlyY, FTargetX, FTargetY);
      if ((abs(FTargetX - FlyX) <= 15) and (abs(FTargetY - FlyY) <= 15)) or ((abs(FTargetX - FlyX) >= prevdisx) and (abs(FTargetY - FlyY) >= prevdisy)) or OverThrough(FOldDir16, passdir16) then
      begin
        crash := True;
      end
      else
      begin
        prevdisx := abs(FTargetX - FlyX);
        prevdisy := abs(FTargetY - FlyY);
      end;
      FOldDir16 := passdir16;
    end
    else
    begin
      ms := GetTickCount - FRunFrameTime;
      stepx := Round(FXStep * ms / 1.3);
      stepy := Round(FYStep * ms / 1.3);
      FlyX := FSourceX + stepx;
      FlyY := FSourceY + stepy;
    end;

    if Crash and (FTarget <> nil) then
    begin
      FixedEffect := True;
      FCurFrame := HitEffect.GetStartIndex(FDir16);
      Repetition := False;
    end;
  end;
  if FixedEffect then
  begin
    if FTarget = nil then
    begin
      FlyX := FTargetX - ((g_Myself.m_nRx * UNITX + g_Myself.m_nShiftX) - FireMyselfX);
      FlyY := FTargetY - ((g_Myself.m_nRy * UNITY + g_Myself.m_nShiftY) - FireMyselfY);
    end
    else
    begin
      PlayScene.ScreenXYfromMCXY(TActor(FTarget).m_nRx, TActor(FTarget).m_nRy, FlyX, FlyY);
      FlyX := FlyX + TActor(FTarget).m_nShiftX;
      FlyY := FlyY + TActor(FTarget).m_nShiftY;
    end;
  end;
end;

procedure TMagicEffect.DirectPaint(Surface: TAsphyreCanvas);
var
  d: TAsphyreLockableTexture;
  shx, shy: integer;
  px, py: integer;
begin
  if ((abs(FlyX - FSourceX) > 15) or (abs(FlyY - FSourceY) > 15) or FixedEffect) then
  begin
    shx := (g_Myself.m_nRx * UNITX + g_Myself.m_nShiftX) - FireMyselfX;
    shy := (g_Myself.m_nRy * UNITY + g_Myself.m_nShiftY) - FireMyselfY;
    if not FixedEffect then
    begin
      D := RunEffect.Lib.GetCachedImage(FCurFrame, px, py);
      if D <> nil then
        Surface.DrawBlend(FlyX + px - UNITX div 2 - shx, FlyY + py - UNITY div 2 - shy, d, 1);
    end
    else
    begin
      d := HitEffect.Lib.GetCachedImage(FCurFrame, px, py);
      if d <> nil then
        Surface.DrawBlend(FlyX + px - UNITX div 2, FlyY + py - UNITY div 2, d, 1);
    end;
  end;
end;

end.
