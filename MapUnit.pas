unit MapUnit;

interface

uses
  Windows, Classes, SysUtils, Grobal2, HUtil32, Share, uTypes, Common;

type
  TMapHeader = packed record
    wWidth: Word;
    wHeight: Word;
    sTitle: array[0..13] of PPlatfromChr;
    Tag: array[0..1] of PPlatfromChr;
    UpdateDate: TDateTime;
    Ver: Byte;
    Reserved: array [0 .. 22] of PPlatfromChr;
  end;

  TMapInfo = packed record
    wBkImg: Word;
    wMidImg: Word;
    wFrImg: Word;
    btDoorIndex: Byte;
    btDoorOffset: Byte;
    btAniFrame: Byte;
    btAniTick: Byte;
    btArea: Byte;
    btLight: Byte;
    btBkIndex: Byte;
    btSmIndex: Byte;
    Reserved: array[0..21] of Byte;
  end;
  pTMapInfo = ^TMapInfo;

  TMapInfoV2 = packed record
    BkImg: word;
    MidImg: word;
    FrImg: word;
    DoorIndex: byte;
    DoorOffset: byte;
    AniFrame: byte;
    AniTick: byte;
    Area: byte;
    light: byte;
    btBkIndex: byte;
    btSmIndex: byte;
  end;

  TOldMapInfo = packed record
    wBkImg: Word;
    wMidImg: Word;
    wFrImg: Word;
    btDoorIndex: Byte;
    btDoorOffset: Byte;
    btAniFrame: Byte;
    btAniTick: Byte;
    btArea: Byte;
    btLight: Byte;
  end;

  TMap = class
  private
    FOldMap: Boolean;
    FMapVer: Byte;
    procedure LoadMapArr(nCurrX, nCurrY: Integer);
    procedure InitMapArr;
    procedure UpdateMapSquare(cx, cy: Integer);
  public
    m_sMapBase:                string;
    m_MArr:                    array of array of TMapInfo;  //
    m_boChange:                Boolean;
    m_ClientRect:              TRect;
    m_OldClientRect:           TRect;
    m_nBlockLeft:              Integer;
    m_nBlockTop:               Integer;
    m_nOldLeft:                Integer;
    m_nOldTop:                 Integer;
    m_sOldMap:                 String;
    m_nCurUnitX:               Integer;
    m_nCurUnitY:               Integer;
    m_sCurrentMap:             String;
    m_nSegXCount:              Integer;
    m_nSegYCount:              Integer;
    m_btOffsetX, m_btOffsetY: Byte;
    m_boAllowNewMap: Boolean;
    m_nMapWidth, M_nMapHeight: Word;
    constructor Create;
    destructor Destroy; override;
    procedure UpdateMapPos(mx, my: Integer);
    procedure ReadyReload;
    procedure LoadMap(const sMapName: String; nMx, nMy: Integer);
    procedure MarkCanWalk(mx, my: Integer; bowalk: Boolean);
    function CanMove(mx, my: Integer): Boolean;
    function CanFly(mx, my: Integer): Boolean;
    function GetDoor(mx, my: Integer): Integer;
    function IsDoorOpen(mx, my: Integer): Boolean;
    function OpenDoor(mx, my: Integer): Boolean;
    function CloseDoor(mx, my: Integer): Boolean;
    function GetNextPosition(sX, sY, nDir, nFlag: Integer; var snx: Integer; var sny: Integer): Boolean;

    class procedure GetMapSize(const MapName: String; var ASize: TSize);
    class function GetMapBorder(const OldMapName, NewMapName: String; var Left, Top: Integer): Boolean;
  end;
  TOnAddDownloadFile = procedure(const AFileName: String; Important: Boolean) of Object;

  function GetMapFileName(const DefaultMapDir, MapFile: String; AllowNew: Boolean): String;

var
  OnAddDownloadMapFile: TOnAddDownloadFile = nil;

implementation

uses
  ClMain;

function GetMapFileName(const DefaultMapDir, MapFile: String; AllowNew: Boolean): String;
var
  AMapFile: String;
begin

  AMapFile := MapFile;
  if AMapFile[1] = '$' then
  begin
    Delete(AMapFile, 1, 1);
    Result := ResourceDir + 'Map\' + AMapFile;
    if ExtractFileExt(Result) = '' then
      Result := Result + '.map';
  end
  else
  begin
    if ExtractFileExt(AMapFile) = '' then
      AMapFile := AMapFile + '.map';
    Result := ResourceDir + 'Map\' + AMapFile;
    if not FileExists(Result) then
    begin
      if AllowNew and FileExists(DefaultMapDir + 'n' + AMapFile) then
        Result := DefaultMapDir + 'n' + AMapFile
      else
        Result := DefaultMapDir + AMapFile;
    end;
  end;
  if not FileExists(Result) then
  begin
    if Assigned(OnAddDownloadMapFile) then
      OnAddDownloadMapFile(Result, True);
  end;
end;

constructor TMap.Create;
var
  I: Integer;
begin
  inherited Create;
  FOldMap := True;
  InitMapArr;
  m_ClientRect := Rect(0, 0, 0, 0);
  m_boChange := False;
  m_sMapBase := 'Map\'; // 地图文件所在目录
  m_sCurrentMap := ''; // 当前地图文件名（不含.MAP）
  m_nSegXCount := 0;
  m_nSegYCount := 0;
  m_nCurUnitX := -1; // 当前单元位置X、Y
  m_nCurUnitY := -1;
  m_nBlockLeft := -1; // 当前块X,Y左上角
  m_nBlockTop := -1;
  m_sOldMap := ''; // 前一个地图文件名（在换地图的时候用）
end;

destructor TMap.Destroy;
begin
  //SetLength(m_MArr, 0, 0);
  Finalize(m_MArr);
  //FillChar(m_MArr, SizeOf(m_MArr), #0);
  inherited Destroy;
end;

// 加载地图段数据
// 以当前座标为准
procedure TMap.LoadMapArr(nCurrX, nCurrY: Integer);
var
  I:         Integer;
  nAline:    Integer;
  nLx:       Integer;
  nRx:       Integer;
  nTy:       Integer;
  nBy:       Integer;
  sFileName: String;
  nHandle:   Integer;
  Header:    TMapHeader;
  J: Integer;
  ADataBuf: PAnsiChar;
begin
  InitMapArr;
  sFileName :=  GetMapFileName(m_sMapBase, m_sCurrentMap, m_boAllowNewMap);
  if FileExists(sFileName) then
  begin
    nHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    try
      if nHandle > 0 then
      begin
        FileRead(nHandle, Header, SizeOf(TMapHeader));
        FOldMap := Header.Tag <> #$D#$A;
        FMapVer := header.Ver;
        if FMapVer = 0 then FMapVer := $D;
        if (FMapVer = $2) and (header.Reserved[0] = #1) then
        begin
          FMapVer := $6;
        end;
        nLx := (nCurrX - 1) * LOGICALMAPUNIT;
        nRx := (nCurrX + 2) * LOGICALMAPUNIT; // rx
        nTy := (nCurrY - 1) * LOGICALMAPUNIT;
        nBy := (nCurrY + 2) * LOGICALMAPUNIT;

        if nLx < 0 then
          nLx := 0;
        if nTy < 0 then
          nTy := 0;
        if nBy >= Header.wHeight then
          nBy := Header.wHeight;
        if FOldMap then
          nAline := SizeOf(TOldMapInfo) * Header.wHeight
        else
        begin
          case FMapVer of
            $2,$D: nAline := SizeOf(TMapInfoV2) * Header.wHeight;
            else nAline := SizeOf(TMapInfo) * Header.wHeight;
          end;
        end;
        m_nMapWidth := Header.wWidth;
        M_nMapHeight := Header.wHeight;
        for I := nLx to nRx - 1 do
        begin // i最多有 3*LOGICALMAPUNIT 值,这就是要更新的地图的行数
          if (I >= 0) and (I < Header.wWidth) then
          begin
            // 当前行列为X,Y，则应从X*每行字节数+Y*每项字节数开始读第一行数据
            if FOldMap then
            begin
              {$POINTERMATH ON}
              FileSeek(nHandle, SizeOf(TMapHeader) + (nAline * I) + (SizeOf(TOldMapInfo) * nTy), 0);
              GetMem(ADataBuf, SizeOf(TOldMapInfo) * (nBy - nTy));
              try
                FileRead(nHandle, ADataBuf^, SizeOf(TOldMapInfo) * (nBy - nTy));
                for J := 0 to nBy - nTy - 1 do
                  Move(ADataBuf[J * SizeOf(TOldMapInfo)], m_MArr[I - nLx, J], SizeOf(TOldMapInfo));
              finally
                FreeMem(ADataBuf);
              end;
              {$POINTERMATH OFF}
            end
            else
            begin
              case FMapVer of
                $2,$D:
                begin
                  {$POINTERMATH ON}
                  FileSeek(nHandle, SizeOf(TMapHeader) + (nAline * I) + (SizeOf(TMapInfoV2) * nTy), 0);
                  GetMem(ADataBuf, SizeOf(TMapInfoV2) * (nBy - nTy));
                  try
                    FileRead(nHandle, ADataBuf^, SizeOf(TMapInfoV2) * (nBy - nTy));
                    for J := 0 to nBy - nTy - 1 do
                      Move(ADataBuf[J * SizeOf(TMapInfoV2)], m_MArr[I - nLx, J], SizeOf(TMapInfoV2));
                  finally
                    FreeMem(ADataBuf);
                  end;
                  {$POINTERMATH OFF}
                end;
                else
                begin
                  FileSeek(nHandle, SizeOf(TMapHeader) + (nAline * I) + (SizeOf(TMapInfo) * nTy), 0);
                  FileRead(nHandle, m_MArr[I - nLx, 0], SizeOf(TMapInfo) * (nBy - nTy));
                end;
              end;
            end;
          end;
        end;
      end;
    finally
      FileClose(nHandle);
    end;
  end;
end;

procedure TMap.ReadyReload;
begin
  m_nCurUnitX := -1;
  m_nCurUnitY := -1;
end;

// cx, cy: 位置, 以LOGICALMAPUNIT为单位
procedure TMap.UpdateMapSquare(cx, cy: Integer);
begin
  try
    if (cx <> m_nCurUnitX) or (cy <> m_nCurUnitY) then
    begin
      LoadMapArr(cx, cy);
      m_nCurUnitX := cx;
      m_nCurUnitY := cy;
    end;
  except
    DebugOutStr('TMap.UpdateMapSquare');
  end;
end;

procedure TMap.UpdateMapPos(mx, my: Integer); // mx,my象素坐标
var
  cx, cy: Integer; // 地图的逻辑坐标

  procedure Unmark(xx, yy: Integer); // xx,yy是象素点坐标
  var
    ax, ay: Integer;
  begin
    if (cx = xx div LOGICALMAPUNIT) and (cy = yy div LOGICALMAPUNIT) then
    begin
      ax := xx - m_nBlockLeft;
      ay := yy - m_nBlockTop;
      m_MArr[ax, ay].wFrImg := m_MArr[ax, ay].wFrImg and $7FFF;
      m_MArr[ax, ay].wBkImg := m_MArr[ax, ay].wBkImg and $7FFF;
    end;
  end;

begin
  try
    cx := mx div LOGICALMAPUNIT; // 折算成逻辑坐标
    cy := my div LOGICALMAPUNIT;
    m_nBlockLeft := _MAX(0, (cx - 1) * LOGICALMAPUNIT) - m_btOffsetX; // 象素坐标
    m_nBlockTop := _MAX(0, (cy - 1) * LOGICALMAPUNIT) - m_btOffsetY;

    UpdateMapSquare(cx, cy);

    if (m_nOldLeft <> m_nBlockLeft) or (m_nOldTop <> m_nBlockTop) or (m_sOldMap <> m_sCurrentMap) then
    begin
      if m_sCurrentMap = '3' then
      begin
        Unmark(624, 278);
        Unmark(627, 278);
        Unmark(634, 271);
        Unmark(564, 287);
        Unmark(564, 286);
        Unmark(661, 277);
        Unmark(578, 296);
      end;
    end;
    m_nOldLeft := m_nBlockLeft;
    m_nOldTop := m_nBlockTop;
  except
    DebugOutStr('TMap.UpdateMapPos');
  end;
end;

// 甘函版矫 贸澜 茄锅 龋免..
procedure TMap.LoadMap(const sMapName: String; nMx, nMy: Integer);
begin
  m_nCurUnitX := -1;
  m_nCurUnitY := -1;
  m_sCurrentMap := sMapName;
  UpdateMapPos(nMx, nMy);
  m_sOldMap := m_sCurrentMap;
  m_ClientRect.Left := -1;
  m_ClientRect.Top := -1;

end;

// 置前景是否可以行走
procedure TMap.MarkCanWalk(mx, my: Integer; bowalk: Boolean);
var
  cx, cy: Integer;
begin
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) then exit;
  if cx > MAXX * 3 then Exit;
  if cy > MAXY * 3 then Exit;
  if bowalk then // 该坐标可以行走，则MArr[cx,cy]的值最高位为0
    Map.m_MArr[cx, cy].wFrImg := Map.m_MArr[cx, cy].wFrImg and $7FFF
  else // 不可以行走的，最高位为1
    Map.m_MArr[cx, cy].wFrImg := Map.m_MArr[cx, cy].wFrImg or $8000;
end;

// 若前景和背景都可以走，则返回真
function TMap.CanMove(mx, my: Integer): Boolean;
var
  cx, cy: Integer;
begin
  Result := False;
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) then exit;
  if cx > MAXX * 3 then Exit;
  if cy > MAXY * 3 then Exit;
    // 前景和背景都可以走（最高位为0）
  Result := ((m_MArr[cx, cy].wBkImg and $8000) + (m_MArr[cx, cy].wFrImg and $8000)) = 0;
  if Result then
  begin
    if m_MArr[cx, cy].btDoorIndex and $80 > 0 then
    begin
      if (m_MArr[cx, cy].btDoorOffset and $80) = 0 then
        Result := False;
    end;
  end;
end;

// 若前景可以走，则返回真。
function TMap.CanFly(mx, my: Integer): Boolean;
var
  cx, cy: Integer;
begin
  Result := False;
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) then exit;
  if cx > MAXX * 3 then Exit;
  if cy > MAXY * 3 then Exit;

  Result := (m_MArr[cx, cy].wFrImg and $8000) = 0;
  if Result then
  begin
    if m_MArr[cx, cy].btDoorIndex and $80 > 0 then
    begin
      if (m_MArr[cx, cy].btDoorOffset and $80) = 0 then
        Result := False;
    end;
  end;
end;

// 获得指定坐标的门的索引号
function TMap.GetDoor(mx, my: Integer): Integer;
var
  cx, cy: Integer;
begin
  Result := 0;
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) then exit;
  if cx > MAXX * 3 then Exit;
  if cy > MAXY * 3 then Exit;
  if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then
  begin // 是门
    Result := Map.m_MArr[cx, cy].btDoorIndex and $7F; // 门的索引在低7位
  end;
end;

procedure TMap.InitMapArr;
begin
  Finalize(m_MArr);
  SetLength(m_MArr, MAXX * 3 + 1, MAXY * 3 + 1);
end;

// 判断门是否打开
function TMap.IsDoorOpen(mx, my: Integer): Boolean;
var
  cx, cy: Integer;
begin
  Result := False;
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) then exit;
  if cx > MAXX * 3 then Exit;
  if cy > MAXY * 3 then Exit;
  if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then
  begin // 是门
    Result := (Map.m_MArr[cx, cy].btDoorOffset and $80 <> 0);
  end;
end;

// 打开门
function TMap.OpenDoor(mx, my: Integer): Boolean;
var
  I, j, cx, cy, idx: Integer;
begin
  Result := False;
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) then exit;
  if cx > MAXX * 3 then Exit;
  if cy > MAXY * 3 then Exit;

  if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then
  begin
    idx := Map.m_MArr[cx, cy].btDoorIndex and $7F;
    for I := cx - 10 to cx + 10 do
      for j := cy - 10 to cy + 10 do
      begin
        if (I > 0) and (j > 0) then
          if (Map.m_MArr[I, j].btDoorIndex and $7F) = idx then
            Map.m_MArr[I, j].btDoorOffset := Map.m_MArr[I, j].btDoorOffset or $80;
      end;
  end;
end;

function TMap.CloseDoor(mx, my: Integer): Boolean;
var
  I, j, cx, cy, idx: Integer;
begin
  Result := False;
  cx := mx - m_nBlockLeft;
  cy := my - m_nBlockTop;
  if (cx < 0) or (cy < 0) then exit;
  if cx > MAXX * 3 then Exit;
  if cy > MAXY * 3 then Exit;
  if Map.m_MArr[cx, cy].btDoorIndex and $80 > 0 then
  begin
    idx := Map.m_MArr[cx, cy].btDoorIndex and $7F;
    for I := cx - 8 to cx + 10 do
      for j := cy - 8 to cy + 10 do
      begin
        if (Map.m_MArr[I, j].btDoorIndex and $7F) = idx then
          Map.m_MArr[I, j].btDoorOffset := Map.m_MArr[I, j].btDoorOffset and $7F;
      end;
  end;
end;

function TMap.GetNextPosition(sX, sY, nDir, nFlag: Integer; var snx: Integer; var sny: Integer): Boolean;
begin
  snx := sX;
  sny := sY;
  case nDir of
    DR_UP { 0 } :
      if sny > nFlag - 1 then
        Dec(sny, nFlag);
    DR_DOWN { 4 } :
      if sny < (M_nMapHeight - nFlag) then
        Inc(sny, nFlag);
    DR_LEFT { 6 } :
      if snx > nFlag - 1 then
        Dec(snx, nFlag);
    DR_RIGHT { 2 } :
      if snx < (m_nMapWidth - nFlag) then
        Inc(snx, nFlag);
    DR_UPLEFT { 7 } :
      begin
        if (snx > nFlag - 1) and (sny > nFlag - 1) then
        begin
          Dec(snx, nFlag);
          Dec(sny, nFlag);
        end;
      end;
    DR_UPRIGHT { 1 } :
      begin
        if (snx > nFlag - 1) and (sny < (M_nMapHeight - nFlag)) then
        begin
          Inc(snx, nFlag);
          Dec(sny, nFlag);
        end;
      end;
    DR_DOWNLEFT { 5 } :
      begin
        if (snx < (m_nMapWidth - nFlag)) and (sny > nFlag - 1) then
        begin
          Dec(snx, nFlag);
          Inc(sny, nFlag);
        end;
      end;
    DR_DOWNRIGHT { 3 } :
      begin
        if (snx < (m_nMapWidth - nFlag)) and (sny < (M_nMapHeight - nFlag)) then
        begin
          Inc(snx, nFlag);
          Inc(sny, nFlag);
        end;
      end;
  end;
  if (snx = sX) and (sny = sY) then
    Result := False
  else
    Result := True;
end;

class procedure TMap.GetMapSize(const MapName: String; var ASize: TSize);
var
  nHandle: Integer;
  Header: TMapHeader;
begin
  nHandle := FileOpen(MapName, fmOpenRead or fmShareDenyNone);
  try
    if nHandle > 0 then
    begin
      FileRead(nHandle, Header, SizeOf(TMapHeader));
      ASize.cx := Header.wWidth;
      ASize.cy := Header.wHeight;
    end;
  finally
    FileClose(nHandle);
  end;
end;

class function TMap.GetMapBorder(const OldMapName, NewMapName: String; var Left, Top: Integer): Boolean;

  function ISEmptyMapCell(AMapInfo: TMapInfo): Boolean;
  begin
    Result := ((AMapInfo.wBkImg = 0) or (AMapInfo.wBkImg = $8000)) and
              ((AMapInfo.wFrImg = 0) or (AMapInfo.wFrImg = $8000)) and
              (AMapInfo.wMidImg = 0) and (AMapInfo.btDoorIndex = 0) and
              (AMapInfo.btDoorOffset = 0) and (AMapInfo.btAniFrame = 0) and
              (AMapInfo.btAniTick = 0) and (AMapInfo.btArea = 0) and
              (AMapInfo.btLight = 0) and (AMapInfo.btBkIndex = 0) and
              (AMapInfo.btSmIndex = 0);
  end;

  function ISEmptyRow(ARow: array of TMapInfo): Boolean;
  var
    I: Integer;
  begin
    Result := True;
    for I := Low(ARow) to High(ARow) do
    begin
      if not ISEmptyMapCell(ARow[I]) then
      begin
        Result := False;
        Exit;
      end;
    end;
  end;

var
  AOldMapSize, ANewMapSize: TSize;
  AXSize, AYSize: Integer;
  I: Integer;
  nAline: Integer;
  nHandle: Integer;
  Header: TMapHeader;
  J: Integer;
  AMapArr: array of array of TMapInfo;
begin
  Left := 0;
  Top := 0;
  Result := False;
  if FileExists(OldMapName) and FileExists(NewMapName) then
  begin
    GetMapSize(OldMapName, AOldMapSize);
    GetMapSize(NewMapName, ANewMapSize);
    if (AOldMapSize.cx < ANewMapSize.cx) or (AOldMapSize.cy < ANewMapSize.cy) then
    begin
      AXSize := ANewMapSize.cx - AOldMapSize.cx;
      AYSize := ANewMapSize.cy - AOldMapSize.cy;
      nHandle := FileOpen(NewMapName, fmOpenRead or fmShareDenyNone);
      FileRead(nHandle, Header, SizeOf(TMapHeader));
      nAline := SizeOf(TMapInfo) * Header.wHeight;
      if AXSize > 0 then
      begin
        SetLength(AMapArr, AXSize, ANewMapSize.cy);
        try
          for I := 0 to AXSize - 1 do
          begin
            FileSeek(nHandle, SizeOf(TMapHeader) + nAline * I, 0);
            FileRead(nHandle, AMapArr[I, 0], nAline);
            if ISEmptyRow(AMapArr[I]) then
              Left := I + 1
            else
              Break;
          end;
        finally
          Finalize(AMapArr);
        end;
      end;
      if AYSize > 0 then
      begin
        SetLength(AMapArr, AYSize, ANewMapSize.cx);
        try
          for I := 0 to AYSize - 1 do
          begin
            for J := 0 to ANewMapSize.cx - 1 do
            begin
              FileSeek(nHandle, SizeOf(TMapHeader) + nAline * J + SizeOf(TMapInfo) * I, 0);
              FileRead(nHandle, AMapArr[I, J], SizeOf(TMapInfo));
            end;
            if ISEmptyRow(AMapArr[I]) then
              Top := I + 1
            else
              Break;
          end;
        finally
          Finalize(AMapArr);
        end;
      end;
      FileClose(nHandle);
    end;
    Result := True;
  end;
end;

end.
