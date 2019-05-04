unit uPathFind;

interface

uses
  Windows, Classes, SysUtils, MapUnit, Math;

type
  TPath = array of TPoint; // 路径数组
  TPathMapCell = record // 路径图元
    Distance: Integer; // 离起点的距离
    Direction: Integer;
  end;

  TPathMapArray = array of array of TPathMapCell; // 路径图存储数组
  pTPathMapArray = ^TPathMapArray;

  TGetCostFunc = function(X, Y, Direction: Integer; PathWidth: Integer = 0): Integer;

  TPathMap = class // 寻路类
  private
    FPath: TPath;
    FRunPath: TPath;
    FFillPathMap: Boolean;
    FFindPathOnMap: Boolean;
    function DirToDX(Direction: Integer): Integer;
    function DirToDY(Direction: Integer): Integer;
  public
    PathMapArray: TPathMapArray;
    MapHeight: Integer;
    MapWidth: Integer;
    GetCostFunc: TGetCostFunc;
    PathWidth: Integer;
    ClientRect: TRect;
    StartFind: Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure GetClientRect(X1, Y1, X2, Y2: Integer);
    procedure FindPathOnMap(X, Y: Integer);
    procedure WalkToRun(); // 把WALK合并成RUN
    procedure WalkToHouseRun();
    function MapX(X: Integer): Integer;
    function MapY(Y: Integer): Integer;
    function LoaclX(X: Integer): Integer;
    function LoaclY(Y: Integer): Integer;
    property Path: TPath read FPath write FPath;
    property RunPath: TPath read FRunPath write FRunPath;
  protected
    function GetCost(X, Y, Direction: Integer): Integer; virtual;
    function FillPathMap(X1, Y1, X2, Y2: Integer): TPathMapArray;
  end;

  TCheckCrashManFun = function(X, Y: Integer): Boolean of Object;
  TMapBuf = array of array of TOldMapInfo;
  TLegendPathMap = class(TPathMap)
  private
    FOldMap: Boolean;
    FMapVer: Byte;
    MapBuf: TMapBuf;
    MapHeader: TMapHeader;
    function CanWalk(X, Y: Integer): Boolean;
  protected
    function GetCost(X, Y, Direction: Integer): Integer; override;
  public
    MapName: string;
    CheckCrashMan: TCheckCrashManFun;
    FindCount, BeginX, BeginY, EndX, EndY, FindX, FindY, PathPositionIndex: Integer;
    House: byte;
    constructor Create;
    destructor Destroy; override;
    function LoadMap(const MapFile: string; AllowNew: Boolean): Boolean;
    function FindPath(StartX, StartY, StopX, StopY: Integer; PathSpace: Integer = 0): TPath;
  end;

  TWaveCell = record
    X, Y: Integer;
    Cost: Integer;
    Direction: Integer;
  end;

  TWave = class
  private
    FData: array of TWaveCell;
    FPos: Integer;
    FCount: Integer;
    FMinCost: Integer;
    function GetItem: TWaveCell;
  public
    property Item: TWaveCell read GetItem;
    property MinCost: Integer read FMinCost;

    constructor Create;
    destructor Destroy; override;
    procedure Add(NewX, NewY, NewCost, NewDirection: Integer);
    procedure Clear;
    function Start: Boolean;
    function Next: Boolean;
  end;

implementation

constructor TWave.Create;
begin
  Clear; //
end;

destructor TWave.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TWave.GetItem: TWaveCell;
begin
  Result := FData[FPos]; //
end;

procedure TWave.Add(NewX, NewY, NewCost, NewDirection: Integer);
begin
  if FCount >= Length(FData) then //
    SetLength(FData, Length(FData) + 30); //
  with FData[FCount] do
  begin
    X := NewX;
    Y := NewY;
    Cost := NewCost;
    Direction := NewDirection;
  end;
  if NewCost < FMinCost then // NewCost
    FMinCost := NewCost;
  Inc(FCount); //
end;

procedure TWave.Clear;
begin
  FPos := 0;
  FCount := 0;
  Finalize(FData);
  FData := nil; //
  FMinCost := High(Integer);
end;

function TWave.Start: Boolean;
begin
  FPos := 0; //
  Result := (FCount > 0); //
end;

function TWave.Next: Boolean;
begin
  Inc(FPos); //
  Result := (FPos < FCount); // false,
end;

constructor TPathMap.Create;
begin
  inherited Create;
end;

destructor TPathMap.Destroy;
begin
  Finalize(FPath);
  Finalize(FRunPath);
  Finalize(PathMapArray);
  inherited;
end;

// *************************************************************
// 方向编号转为X方向符号
// 7  0  1
// 6  X  2
// 5  4  3
// *************************************************************

function TPathMap.DirToDX(Direction: Integer): Integer;
begin
  case Direction of
    0, 4:
      Result := 0;
    1 .. 3:
      Result := 1;
  else
    Result := -1;
  end;
end;

function TPathMap.DirToDY(Direction: Integer): Integer;
begin
  case Direction of
    2, 6:
      Result := 0;
    3 .. 5:
      Result := 1;
  else
    Result := -1;
  end;
end;
// *************************************************************
// 从TPathMap中找出 TPath
// *************************************************************

procedure TPathMap.FindPathOnMap(X, Y: Integer);
var
  I: Integer;
  nX, nY: Integer;
  Direction: Integer;
begin
  nX := LoaclX(X);
  nY := LoaclY(Y);
  if (nX < 0) or (nY < 0) or (nX >= ClientRect.Right - ClientRect.Left) or (nY >= ClientRect.Bottom - ClientRect.Top) then
  begin
    StartFind := False;
    PathMapArray := nil;
    Exit;
  end;

  if (Length(PathMapArray) <= 0) or (PathMapArray[nY, nX].Distance < 0) then
  begin
    StartFind := False;
    PathMapArray := nil;
    Exit;
  end;
  FFindPathOnMap := True;

  SetLength(FPath, PathMapArray[nY, nX].Distance + 1);
  while PathMapArray[nY, nX].Distance > 0 do
  begin
    if not StartFind then
      Break;
    FPath[PathMapArray[nY, nX].Distance] := Point(nX, nY);
    Direction := PathMapArray[nY, nX].Direction;
    nX := nX - DirToDX(Direction);
    nY := nY - DirToDY(Direction);
  end;
  FPath[0] := Point(nX, nY);
  for I := 0 to Length(FPath) - 1 do
    FPath[I] := Point(MapX(FPath[I].X), MapY(FPath[I].Y));

  WalkToRun;
  FFindPathOnMap := False;
  StartFind := False;
end;

procedure TPathMap.WalkToRun(); // 把WALK合并成RUN
  function GetNextDirection(sx, sy, dx, dy: Integer): byte;
  var
    flagx, flagy: Integer;
  const
    DR_UP = 0;
    DR_UPRIGHT = 1;
    DR_RIGHT = 2;
    DR_DOWNRIGHT = 3;
    DR_DOWN = 4;
    DR_DOWNLEFT = 5;
    DR_LEFT = 6;
    DR_UPLEFT = 7;
  begin
    Result := DR_DOWN;
    if sx < dx then
      flagx := 1
    else if sx = dx then
      flagx := 0
    else
      flagx := -1;
    if abs(sy - dy) > 2 then
      if (sx >= dx - 1) and (sx <= dx + 1) then
        flagx := 0;

    if sy < dy then
      flagy := 1
    else if sy = dy then
      flagy := 0
    else
      flagy := -1;
    if abs(sx - dx) > 2 then
      if (sy > dy - 1) and (sy <= dy + 1) then
        flagy := 0;

    if (flagx = 0) and (flagy = -1) then
      Result := DR_UP;
    if (flagx = 1) and (flagy = -1) then
      Result := DR_UPRIGHT;
    if (flagx = 1) and (flagy = 0) then
      Result := DR_RIGHT;
    if (flagx = 1) and (flagy = 1) then
      Result := DR_DOWNRIGHT;
    if (flagx = 0) and (flagy = 1) then
      Result := DR_DOWN;
    if (flagx = -1) and (flagy = 1) then
      Result := DR_DOWNLEFT;
    if (flagx = -1) and (flagy = 0) then
      Result := DR_LEFT;
    if (flagx = -1) and (flagy = -1) then
      Result := DR_UPLEFT;
  end;

var
  nDir1, nDir2: Integer;
  I, n01: Integer;
  WalkPath: TPath;
  nStep: Integer;
begin
  FRunPath := nil;
  WalkPath := nil;
  if (FPath <> nil) and (Length(FPath) > 1) then
  begin
    SetLength(WalkPath, Length(FPath));

    for I := 0 to Length(FPath) - 1 do
      WalkPath[I] := FPath[I];

    nStep := 0;
    I := 0;
    while True do
    begin
      if not StartFind then
        Break;
      if I >= Length(WalkPath) then
        Break;
      if nStep >= 2 then
      begin
        nDir1 := GetNextDirection(WalkPath[I - 2].X, WalkPath[I - 2].Y, WalkPath[I - 1].X, WalkPath[I - 1].Y);
        nDir2 := GetNextDirection(WalkPath[I - 1].X, WalkPath[I - 1].Y, WalkPath[I].X, WalkPath[I].Y);
        if nDir1 = nDir2 then
        begin
          WalkPath[I - 1].X := -1;
          WalkPath[I - 1].Y := -1;
          nStep := 0;
          // Continue;
        end
        else
        begin // 需要转向不能合并
          Dec(I);
          nStep := 0;
          Continue;
        end;
      end;
      Inc(nStep);
      Inc(I);
    end;

    n01 := 0;
    for I := 1 to Length(WalkPath) - 1 do
    begin
      if (WalkPath[I].X <> -1) and (WalkPath[I].Y <> -1) then
      begin
        Inc(n01);
        SetLength(FRunPath, n01);
        FRunPath[n01 - 1] := WalkPath[I];
      end;
    end;
    Exit;
  end;
  if (FPath <> nil) and (Length(FPath) > 0) then
  begin
    SetLength(FRunPath, Length(FPath) - 1);
    for I := 1 to Length(FPath) - 1 do
      FRunPath[I - 1] := FPath[I];
  end
  else
  begin
    SetLength(FRunPath, 0);
    FRunPath := nil;
  end;
end;

procedure TPathMap.WalkToHouseRun();

  function GetNextDirection(sx, sy, dx, dy: Integer): byte;
  var
    flagx, flagy: Integer;
  const
    DR_UP = 0;
    DR_UPRIGHT = 1;
    DR_RIGHT = 2;
    DR_DOWNRIGHT = 3;
    DR_DOWN = 4;
    DR_DOWNLEFT = 5;
    DR_LEFT = 6;
    DR_UPLEFT = 7;
  begin
    Result := DR_DOWN;
    if sx < dx then
      flagx := 1
    else if sx = dx then
      flagx := 0
    else
      flagx := -1;
    if abs(sy - dy) > 2 then
      if (sx >= dx - 1) and (sx <= dx + 1) then
        flagx := 0;

    if sy < dy then
      flagy := 1
    else if sy = dy then
      flagy := 0
    else
      flagy := -1;
    if abs(sx - dx) > 2 then
      if (sy > dy - 1) and (sy <= dy + 1) then
        flagy := 0;

    if (flagx = 0) and (flagy = -1) then
      Result := DR_UP;
    if (flagx = 1) and (flagy = -1) then
      Result := DR_UPRIGHT;
    if (flagx = 1) and (flagy = 0) then
      Result := DR_RIGHT;
    if (flagx = 1) and (flagy = 1) then
      Result := DR_DOWNRIGHT;
    if (flagx = 0) and (flagy = 1) then
      Result := DR_DOWN;
    if (flagx = -1) and (flagy = 1) then
      Result := DR_DOWNLEFT;
    if (flagx = -1) and (flagy = 0) then
      Result := DR_LEFT;
    if (flagx = -1) and (flagy = -1) then
      Result := DR_UPLEFT;
  end;

var
  nDir1, nDir2, nDir3: Integer;
  I, n01: Integer;
  WalkPath: TPath;
  nStep: Integer;
begin
  FRunPath := nil;
  WalkPath := nil;
  if (FPath <> nil) and (Length(FPath) > 1) then
  begin
    SetLength(WalkPath, Length(FPath));

    for I := 0 to Length(FPath) - 1 do
      WalkPath[I] := FPath[I];

    // WalkPath := FPath;
    nStep := 0;
    I := 0;
    while True do
    begin
      if not StartFind then
        Break;
      if I >= Length(WalkPath) then
      begin
        Break;
      end;
      if nStep >= 3 then
      begin
        nDir1 := GetNextDirection(WalkPath[I - 3].X, WalkPath[I - 3].Y, WalkPath[I - 2].X, WalkPath[I - 2].Y);
        nDir2 := GetNextDirection(WalkPath[I - 2].X, WalkPath[I - 2].Y, WalkPath[I - 1].X, WalkPath[I - 1].Y);
        nDir3 := GetNextDirection(WalkPath[I - 1].X, WalkPath[I - 1].Y, WalkPath[I].X, WalkPath[I].Y);
        if (nDir1 = nDir2) and (nDir2 = nDir3) then
        begin
          WalkPath[I - 1].X := -1;
          WalkPath[I - 1].Y := -1;
          WalkPath[I - 2].X := -1;
          WalkPath[I - 2].Y := -1;
          nStep := 0;
          Continue;
        end
        else if nDir1 = nDir2 then
        begin
          WalkPath[I - 2].X := -1;
          WalkPath[I - 2].Y := -1;
          Dec(I);
          nStep := 0;
          Continue;
        end
        else if nDir2 = nDir3 then
        begin
          WalkPath[I - 1].X := -1;
          WalkPath[I - 1].Y := -1;
          nStep := 0;
          Continue;
        end
        else
        begin // 需要转向不能合并
          Dec(I);
          nStep := 0;
          Continue;
        end;
      end;
      Inc(nStep);
      Inc(I);
    end;

    n01 := 0;
    for I := 1 to Length(WalkPath) - 1 do
    begin
      if (WalkPath[I].X <> -1) and (WalkPath[I].Y <> -1) then
      begin
        Inc(n01);
        SetLength(FRunPath, n01);
        FRunPath[n01 - 1] := WalkPath[I];
      end;
    end;
    Exit;
  end;
  if (FPath <> nil) and (Length(FPath) > 0) then
  begin
    SetLength(FRunPath, Length(FPath) - 1);
    for I := 1 to Length(FPath) - 1 do
      FRunPath[I - 1] := FPath[I];
  end
  else
  begin
    SetLength(FRunPath, 0);
    FRunPath := nil;
  end;
end;

function TPathMap.MapX(X: Integer): Integer;
begin
  Result := X + ClientRect.Left;
end;

function TPathMap.MapY(Y: Integer): Integer;
begin
  Result := Y + ClientRect.Top;
end;

function TPathMap.LoaclX(X: Integer): Integer;
begin
  Result := X - ClientRect.Left;
end;

function TPathMap.LoaclY(Y: Integer): Integer;
begin
  Result := Y - ClientRect.Top;
end;

procedure TPathMap.GetClientRect(X1, Y1, X2, Y2: Integer);
begin
  ClientRect := Bounds(0, 0, MapWidth, MapHeight);
end;

function TPathMap.FillPathMap(X1, Y1, X2, Y2: Integer): TPathMapArray;
var
  OldWave, NewWave: TWave;
  Finished: Boolean;
  I: TWaveCell;
  nX1, nY1, nX2, nY2: Integer;

  procedure PreparePathMap; // 初始化PathMapArray
  var
    X, Y: Integer; //
  begin
    SetLength(Result, ClientRect.Bottom - ClientRect.Top, ClientRect.Right - ClientRect.Left);
    for Y := 0 to (ClientRect.Bottom - ClientRect.Top - 1) do
    begin
      if not StartFind then
        Exit;
      for X := 0 to (ClientRect.Right - ClientRect.Left - 1) do
      begin
        if not StartFind then
          Exit;
        Result[Y, X].Distance := -1;
      end;
    end;
  end;

// 计算相邻8个节点的权cost，并合法点加入NewWave(),并更新最小cost
// 合法点是指非障碍物且Result[X，Y]中未访问的点
  procedure TestNeighbours;
  var
    X, Y, C, D: Integer;
  begin
    for D := 0 to 7 do
    begin
      X := OldWave.Item.X + DirToDX(D);
      Y := OldWave.Item.Y + DirToDY(D);
      C := GetCost(X, Y, D);
      if (C >= 0) and (Result[Y, X].Distance < 0) then
        NewWave.Add(X, Y, C, D); //
    end;
  end;

  procedure ExchangeWaves; //
  var
    W: TWave;
  begin
    W := OldWave;
    OldWave := NewWave;
    NewWave := W;
    NewWave.Clear;
  end;

begin
  FFillPathMap := True;
  GetClientRect(X1, Y1, X2, Y2);

  nX1 := LoaclX(X1);
  nY1 := LoaclY(Y1);
  nX2 := LoaclX(X2);
  nY2 := LoaclY(Y2);

  if X2 < 0 then
    nX2 := X2;
  if Y2 < 0 then
    nY2 := Y2;

  if (X2 >= 0) and (Y2 >= 0) then
  begin
    if (abs(nX1 - nX2) > (ClientRect.Right - ClientRect.Left)) or (abs(nY1 - nY2) > (ClientRect.Bottom - ClientRect.Top)) then
    begin
      SetLength(Result, 0, 0);
      FFillPathMap := False;
      Exit;
    end;
  end;

  PreparePathMap; // 初始化PathMapArray ,Distance:=-1

  OldWave := TWave.Create;
  NewWave := TWave.Create;
  Result[nY1, nX1].Distance := 0; // 起点Distance:=0
  OldWave.Add(nX1, nY1, 0, 0); // 将起点加入OldWave
  TestNeighbours; //

  Finished := ((nX1 = nX2) and (nY1 = nY2)); // 检验是否到达终点
  while not Finished do
  begin
    ExchangeWaves;
    if not StartFind then
      Break;
    if not OldWave.Start then
      Break;
    repeat
      if not StartFind then
        Break;
      I := OldWave.Item;
      I.Cost := I.Cost - OldWave.MinCost; // 如果大于MinCost
      if I.Cost > 0 then // 加入NewWave
        NewWave.Add(I.X, I.Y, I.Cost, I.Direction) // 更新Cost= cost-MinCost
      else
      begin // 处理最小COST的点
        if Result[I.Y, I.X].Distance >= 0 then
          Continue;

        Result[I.Y, I.X].Distance := Result[I.Y - DirToDY(I.Direction), I.X - DirToDX(I.Direction)].Distance + 1; // 此点 Distance:=上一个点Distance+1

        Result[I.Y, I.X].Direction := I.Direction;
        //
        Finished := ((I.X = nX2) and (I.Y = nY2)); // 检验是否到达终点
        if Finished then
          Break;
        TestNeighbours;
      end;
    until not OldWave.Next; //
  end; // OldWave;
  NewWave.Free;
  OldWave.Free;
  FFillPathMap := False;
end;

function TPathMap.GetCost(X, Y, Direction: Integer): Integer;
begin
  Direction := (Direction and 7);
  if (X < 0) or (X >= ClientRect.Right - ClientRect.Left) or (Y < 0) or (Y >= ClientRect.Bottom - ClientRect.Top) then
    Result := -1
  else
    Result := GetCostFunc(X, Y, Direction, PathWidth);
end;

constructor TLegendPathMap.Create;
begin
  inherited Create;
  StartFind := False;
  FFillPathMap := False;
  FFindPathOnMap := False;
  PathPositionIndex := 0;
  FindCount := 0;
  CheckCrashMan := nil;
end;

destructor TLegendPathMap.Destroy;
begin
  Finalize(MapBuf);
  Finalize(MapHeader);
  inherited;
end;

function TLegendPathMap.LoadMap(const MapFile: string; AllowNew: Boolean): Boolean;
var
  nHandle, I, j, nAline: Integer;
  hh: widestring;
  AFileName: String;
  Buf: PAnsiChar;
begin
  AFileName := MapUnit.GetMapFileName('Map\', MapFile, AllowNew);
  if not FileExists(AFileName) then
    Exit;

  nHandle := FileOpen(AFileName, fmOpenRead or fmShareDenyNone);
  try
    FileRead(nHandle, MapHeader, SizeOf(TMapHeader));
    FOldMap := MapHeader.Tag <> #$D#$A;
    FMapVer := MapHeader.Ver;
    SetLength(MapBuf, MapHeader.wWidth, MapHeader.wHeight);
    if FOldMap then
      nAline := SizeOf(TOldMapInfo) * MapHeader.wHeight
    else
    begin
      case FMapVer of
        $2: nAline := SizeOf(TMapInfoV2) * MapHeader.wHeight;
        else nAline := SizeOf(TMapInfo) * MapHeader.wHeight;
      end;
    end;
    {$POINTERMATH ON}
    for I := 0 to MapHeader.wWidth - 1 do
    begin
      if FOldMap then
        FileRead(nHandle, MapBuf[I, 0], nAline)
      else
      begin
        case FMapVer of
          $2:
          begin
            GetMem(Buf, nAline);
            try
              FileRead(nHandle, Buf^, nAline);
              for J := 0 to MapHeader.wHeight - 1 do
                Move(Buf[J * SizeOf(TMapInfoV2)], MapBuf[I, J], SizeOf(TOldMapInfo));
            finally
              FreeMem(Buf);
            end;
          end;
          else
          begin
            GetMem(Buf, nAline);
            try
              FileRead(nHandle, Buf^, nAline);
              for J := 0 to MapHeader.wHeight - 1 do
                Move(Buf[J * SizeOf(TMapInfo)], MapBuf[I, J], SizeOf(TOldMapInfo));
            finally
              FreeMem(Buf);
            end;
          end;
        end;
      end;
    end;
    {$POINTERMATH OFF}
  finally
    FileClose(nHandle);
  end;

  MapWidth := MapHeader.wWidth;
  MapHeight := MapHeader.wHeight;
  Result := true;
end;

function TLegendPathMap.FindPath(StartX, StartY, StopX, StopY: Integer; PathSpace: Integer = 0): TPath;
begin
  StartFind := False;
  Inc(FindCount);
  SetLength(PathMapArray, 0, 0);
  PathMapArray := nil;
  FRunPath := nil;
  FPath := nil;
  FindX := StopX;
  FindY := StopY;
  PathWidth := PathSpace;
  StartFind := True;
  PathMapArray := FillPathMap(StartX, StartY, StopX, StopY);
  FindPathOnMap(StopX, StopY);
  Result := FPath;
end;

function TLegendPathMap.CanWalk(X, Y: Integer): Boolean;
begin
  Result := ((MapBuf[X, Y].wBkImg and $8000) + (MapBuf[X, Y].wFrImg and $8000)) = 0;
  if Result then
  begin
    if MapBuf[X, Y].btDoorIndex and $80 > 0 then
    begin
      if (MapBuf[X, Y].btDoorOffset and $80) = 0 then
      begin
        Result := False;
        Exit;
      end;
    end;
    if Assigned(CheckCrashMan) then
      Result := not CheckCrashMan(X, Y);
  end;
end;

function TLegendPathMap.GetCost(X, Y, Direction: Integer): Integer;
var
  Cost: Integer;
  nX, nY: Integer;
begin
  Direction := (Direction and 7);
  if (X < 0) or (X >= ClientRect.Right - ClientRect.Left) or (Y < 0) or (Y >= ClientRect.Bottom - ClientRect.Top) then
    Result := -1
  else
  begin
    nX := MapX(X);
    nY := MapY(Y);
    if CanWalk(nX, nY) then
      Result := 4
    else
      Result := -1;
    if ((Direction and 1) = 1) and (Result > 0) then
      Result := Result + (Result shr 1); // 应为Result*sqt(2),此处近似为1.5
  end;
end;

end.
