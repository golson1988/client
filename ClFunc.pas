unit ClFunc;

interface

uses
  Windows, SysUtils, Classes, Graphics, Math, Character, Grobal2, HUtil32, Share,
  uTypes, uTextures, Common;

var
  DropItems: TList;
  dwPixelsMemChecktTick: LongWord;

function PaddingString(const AStr: string; ALength: Integer): string;
function AnsiLength(const AStr: string): Integer;
function GetGoldStr(gold: Int64): string;
procedure ClearBag;
function AddItemBag(cu: TClientItem): Boolean;
function UpdateItemBag(cu: TClientItem): Boolean;
function DelItemBag(const iname: string; iindex: Integer): Boolean;
procedure ArrangeItemBag;
procedure AddDropItem(ci: TClientItem);
function GetDropItem(const iname: string; MakeIndex: Integer): PTClientItem;
procedure DelDropItem(const iname: string; MakeIndex: Integer);
procedure AddDealItem(ci: TClientItem);
procedure DelDealItem(ci: TClientItem);
procedure AddSellOffItem(ci: TClientItem); // 添加到寄售出售框中 20080316
procedure MoveSellOffItemToBag; // 寄售相关 20080316
procedure AddChallengeItem(ci: TClientItem);
procedure DelChallengeItem(ci: TClientItem);
procedure MoveChallengeItemToBag;
procedure AddChallengeRemoteItem(ci: TClientItem);
procedure DelChallengeRemoteItem(ci: TClientItem);
procedure MoveDealItemToBag;
procedure AddDealRemoteItem(ci: TClientItem);
procedure DelDealRemoteItem(ci: TClientItem);
function GetDistance(sx, sy, dx, dy: Integer): Integer; inline;
procedure GetNextPosXY(dir: byte; var x, y: Integer); inline;
function GetNextPosCanXY(var dir: byte; x, y: Integer): Boolean;
procedure GetNextRunXY(dir: byte; var x, y: Integer); inline;
procedure GetNextHorseRunXY(dir: byte; var x, y: Integer); inline;
function GetNextDirection(sx, sy, dx, dy: Integer): byte;
function GetBack(dir: Integer): Integer; inline;
procedure GetBackPosition(sx, sy, dir: Integer; var newx, newy: Integer); inline;
procedure GetFrontPosition(sx, sy, dir: Integer; var newx, newy: Integer); inline;
function GetFlyDirection(sx, sy, ttx, tty: Integer): Integer;
function GetFlyDirection16(sx, sy, ttx, tty: Integer): Integer;
function PrivDir(ndir: Integer): Integer; inline;
function NextDir(ndir: Integer): Integer; inline;
// 图片和文字混合成图片画出
function GetTakeOnPosition(var Item : TClientItem): Integer; inline;
function IsKeyPressed(key: byte): Boolean;
procedure AddChangeFace(recogid: Integer);
procedure DelChangeFace(recogid: Integer);
function IsChangingFace(recogid: Integer): Boolean;
function EmptyClientItem: TClientItem;
procedure GetDirXYSymbol(const btDir:Byte ;var X,Y : Integer);

implementation

uses
  clMain, MShare, cliUtil,DWinCtl;

// 格式化字符串为指定长度（后面添空格）
function PaddingString(const AStr: string; ALength: Integer): string;
var
  I, _Len: Integer;
begin
  try
    Result := AStr + ' ';
    _Len := 0;
    for I := 1 to Length(AStr) do
    begin
      if Integer(AStr[I]) <= $7F then
        Inc(_Len)
      else
        Inc(_Len, 2);
    end;
    for I := 1 to ALength - _Len do
      Result := Result + ' ';
  except
    Result := AStr + ' ';
  end;
end;

function AnsiLength(const AStr: string): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(AStr) do
  begin
    if Integer(AStr[I]) <= $7F then
      Inc(Result)
    else
      Inc(Result, 2);
  end;
end;

// 整数转换为千位带逗号的字符串，例如1234567转换为“1,234,567”
// 这里用于显示金钱数量
function GetGoldStr(gold: Int64): string;
var
  i, n: Integer;
  str: string;
begin
  str := IntToStr(gold);
  n := 0;
  Result := '';
  for i := Length(str) downto 1 do
  begin
    if n = 3 then
    begin
      Result := str[i] + ',' + Result;
      n := 1;
    end
    else
    begin
      Result := str[i] + Result;
      Inc(n);
    end;
  end;
end;

// 清除物品
procedure ClearBag;
begin
  FillChar(g_ItemArr[0], SizeOf(g_ItemArr), #0);
end;

// 添加物品
function AddItemBag(cu: TClientItem): Boolean;
var
  i: Integer;
begin
  Result := FALSE;
  // 检查要添加的物品是否已经存在
  for i := 0 to MAXBAGITEM + 6 - 1 do
  begin
    if (g_ItemArr[i].MakeIndex = cu.MakeIndex) and (g_ItemArr[i].Name = cu.Name) then
    begin
      exit;
    end;
  end;

  if cu.Name = '' then
    exit;
  if ItemCanShowInQuickBar(cu) then
  begin
    for i := 0 to 5 do
     if g_ItemArr[i].Name = '' then
     begin
       g_ItemArr[i] := cu;
       Result := TRUE;
       Exit;
     end;
  end;
  for i := 6 to MAXBAGITEM + 6 - 1 do
  begin
    if g_ItemArr[i].Name = '' then
    begin
      g_ItemArr[i] := cu;
      Result := TRUE;
      break;
    end;
  end;
  ArrangeItemBag;
end;

// 用当前的物品属性替代已经存在的该物品属性
function UpdateItemBag(cu: TClientItem): Boolean;
var
  i: Integer;
begin
  Result := FALSE;
  for i := MAXBAGITEM + 6 - 1 downto 0 do
  begin
//    if (((g_ItemArr[i].S.StdMode <> 32) and (g_ItemArr[i].Name = cu.Name)) or
//      ((g_ItemArr[i].S.StdMode = 32) and (g_ItemArr[i].S.Name = cu.S.Name))) and
//      (g_ItemArr[i].MakeIndex = cu.MakeIndex) then
    if (g_ItemArr[i].MakeIndex = cu.MakeIndex) and (g_ItemArr[i].Name <> '') then
    begin
      g_ItemArr[i] := cu;
      Result := TRUE;
      break;
    end;
  end;
  ArrangeItemBag;
end;

// 删除指定的物品
function DelItemBag(const iname: string; iindex: Integer): Boolean;
var
  i: Integer;
begin
  Result := FALSE;
  for i := MAXBAGITEM + 6 - 1 downto 0 do
  begin
//    if (((g_ItemArr[i].S.StdMode <> 32) and (g_ItemArr[i].Name = iname)) or
//      ((g_ItemArr[i].S.StdMode = 32) and (g_ItemArr[i].S.Name = iname))) and
//      (g_ItemArr[i].MakeIndex = iindex) then
    if (g_ItemArr[i].MakeIndex = iindex) and (g_ItemArr[i].Name <> '') then
    begin
      FillChar(g_ItemArr[i], ClientItemSize, #0);
      Result := TRUE;
      break;
    end;
  end;
  ArrangeItemBag;
end;

// 整理物品包
procedure ArrangeItemBag;
var
  i, k: Integer;
begin
  for i := 0 to MAXBAGITEM + 6 - 1 do
  begin
    if g_ItemArr[i].Name <> '' then
    begin
      for k := i + 1 to MAXBAGITEM + 6 - 1 do
      begin
        if (g_ItemArr[i].MakeIndex = g_ItemArr[k].MakeIndex) then
        begin
          FillChar(g_ItemArr[k], ClientItemSize, #0);
        end;
      end;
      if (g_ItemArr[i].MakeIndex = g_MovingItem.Item.MakeIndex) then
      begin
        g_MovingItem.FromIndex := 0;
        g_MovingItem.Source := msNone;
        g_MovingItem.Item.Name := '';
      end;
    end;
  end;

  for I := MAXBAGITEM to MAXBAGITEM + 6 - 1 do
  begin
    if (g_ItemArr[I].Name <> '') and (not g_boItemMoving or (g_MovingItem.Item.MakeIndex <> g_ItemArr[i].MakeIndex)) then
    begin
      for K := 6 to MAXBAGITEM - 1 do
      begin
        if g_ItemArr[K].Name = '' then
        begin
          g_ItemArr[K] := g_ItemArr[I];
          g_ItemArr[I].Name := '';
          Break;
        end;
      end;
    end;
  end;
end;

{ ---------------------------------------------------------- }
// 添加跌落物品
procedure AddDropItem(ci: TClientItem);
var
  pc: PTClientItem;
begin
  new(pc);
  pc^ := ci;
  DropItems.Add(pc);
end;

// 获取跌落物品
function GetDropItem(const iname: string; MakeIndex: Integer): PTClientItem;
var
  i: Integer;
begin
  Result := nil;
  if DropItems.Count > 0 then // 20080629
    for i := 0 to DropItems.Count - 1 do
    begin
      if (PTClientItem(DropItems[i]).Name = iname) and
        (PTClientItem(DropItems[i]).MakeIndex = MakeIndex) then
      begin
        Result := PTClientItem(DropItems[i]);
        break;
      end;
    end;
end;

// 删除跌落物品
procedure DelDropItem(const iname: string; MakeIndex: Integer);
var
  i: Integer;
begin
  if DropItems.Count > 0 then // 20080629
    for i := 0 to DropItems.Count - 1 do
    begin
      if (PTClientItem(DropItems[i]).Name = iname) and
        (PTClientItem(DropItems[i]).MakeIndex = MakeIndex) then
      begin
        Dispose(PTClientItem(DropItems[i]));
        DropItems.Delete(i);
        break;
      end;
    end;
end;

{ ---------------------------------------------------------- }

procedure AddDealItem(ci: TClientItem);
var
  i: Integer;
begin
  for i := 0 to 10 - 1 do
  begin
    if g_DealItems[i].Name = '' then
    begin
      g_DealItems[i] := ci;
      break;
    end;
  end;
end;

procedure DelDealItem(ci: TClientItem);
var
  i: Integer;
begin
  for i := 0 to 10 - 1 do
  begin
    if (g_DealItems[i].Name = ci.Name) and
      (g_DealItems[i].MakeIndex = ci.MakeIndex) then
    begin
      FillChar(g_DealItems[i], ClientItemSize, #0);
      break;
    end;
  end;
end;

{ ****************************************************************************** }
// 挑战 20080705
procedure AddChallengeItem(ci: TClientItem);
var
  i: Integer;
begin
  for i := 0 to 3 do
  begin
    if g_ChallengeItems[i].Name = '' then
    begin
      g_ChallengeItems[i] := ci;
      break;
    end;
  end;
end;

procedure DelChallengeItem(ci: TClientItem);
var
  i: Integer;
begin
  for i := 0 to 3 do
  begin
    if (g_ChallengeItems[i].Name = ci.Name) and
      (g_ChallengeItems[i].MakeIndex = ci.MakeIndex) then
    begin
      FillChar(g_ChallengeItems[i], ClientItemSize, #0);
      break;
    end;
  end;
end;

procedure MoveChallengeItemToBag;
var
  i: Integer;
begin
  for i := 0 to 3 do
  begin
    if g_ChallengeItems[i].Name <> '' then
      AddItemBag(g_ChallengeItems[i]);
  end;
  FillChar(g_ChallengeItems[0], SizeOf(g_ChallengeItems), #0);
end;

procedure AddChallengeRemoteItem(ci: TClientItem);
var
  i: Integer;
begin
  for i := 0 to 3 do
  begin
    if g_ChallengeRemoteItems[i].Name = '' then
    begin
      g_ChallengeRemoteItems[i] := ci;
      break;
    end;
  end;
end;

procedure DelChallengeRemoteItem(ci: TClientItem);
var
  i: Integer;
begin
  for i := 0 to 3 do
  begin
    if (g_ChallengeRemoteItems[i].Name = ci.Name) and
      (g_ChallengeRemoteItems[i].MakeIndex = ci.MakeIndex) then
    begin
      FillChar(g_ChallengeRemoteItems[i], ClientItemSize, #0);
      break;
    end;
  end;
end;

{ ****************************************************************************** }
// 元宝寄售系统 20080316
procedure AddSellOffItem(ci: TClientItem); // 添加到寄售出售框中
var
  i: Integer;
begin
  for i := 0 to 9 - 1 do
  begin
    if g_SellOffItems[i].Name = '' then
    begin
      g_SellOffItems[i] := ci;
      break;
    end;
  end;
end;

procedure MoveSellOffItemToBag; // 寄售相关 20080316
var
  i: Integer;
begin
  for i := 0 to 9 - 1 do
  begin
    if g_SellOffItems[i].Name <> '' then
      AddItemBag(g_SellOffItems[i]);
  end;
  FillChar(g_SellOffItems, ClientItemSize * 9, #0);
end;

{ ****************************************************************************** }
procedure MoveDealItemToBag;
var
  i: Integer;
begin
  for i := 0 to 10 - 1 do
  begin
    if g_DealItems[i].Name <> '' then
      AddItemBag(g_DealItems[i]);
  end;
  FillChar(g_DealItems[0], SizeOf(g_DealItems), #0);
end;

procedure AddDealRemoteItem(ci: TClientItem);
var
  i: Integer;
begin
  for i := 0 to 20 - 1 do
  begin
    if g_DealRemoteItems[i].Name = '' then
    begin
      g_DealRemoteItems[i] := ci;
      break;
    end;
  end;
end;

procedure DelDealRemoteItem(ci: TClientItem);
var
  i: Integer;
begin
  for i := 0 to 20 - 1 do
  begin
    if (g_DealRemoteItems[i].Name = ci.Name) and
      (g_DealRemoteItems[i].MakeIndex = ci.MakeIndex) then
    begin
      FillChar(g_DealRemoteItems[i], ClientItemSize, #0);
      break;
    end;
  end;
end;

{ ---------------------------------------------------------- }
// 计算两点间的距离（X或Y方向）
function GetDistance(sx, sy, dx, dy: Integer): Integer;
begin
  Result := _MAX(abs(sx - dx), abs(sy - dy));
end;

//获取朝向方向的XY 坐标系数  [0,-1,1] 三种
procedure GetDirXYSymbol(const btDir:Byte ;var X,Y : Integer);
begin
  X := 0;
  Y := 0;
  case btDir of
    DR_UP:
      begin
        x := 0;
        y := -1;
      end;
    DR_UPRIGHT:
      begin
        x := 1;
        y := -1;
      end;
    DR_RIGHT:
      begin
        x := 1;
        y := 0;
      end;
    DR_DOWNRIGHT:
      begin
        x := 1;
        y := 1;
      end;
    DR_DOWN:
      begin
        x := 0;
        y := 1;
      end;
    DR_DOWNLEFT:
      begin
        x := - 1;
        y := 1;
      end;
    DR_LEFT:
      begin
        x := - 1;
        y := 0;
      end;
    DR_UPLEFT:
      begin
        x := - 1;
        y := - 1;
      end;
  end;
end;

// 根据方向和当前位置确定下一个位置坐标(位移量=1）
procedure GetNextPosXY(dir: byte; var x, y: Integer);
begin
  case dir of
    DR_UP:
      begin
        x := x;
        y := y - 1;
      end;
    DR_UPRIGHT:
      begin
        x := x + 1;
        y := y - 1;
      end;
    DR_RIGHT:
      begin
        x := x + 1;
        y := y;
      end;
    DR_DOWNRIGHT:
      begin
        x := x + 1;
        y := y + 1;
      end;
    DR_DOWN:
      begin
        x := x;
        y := y + 1;
      end;
    DR_DOWNLEFT:
      begin
        x := x - 1;
        y := y + 1;
      end;
    DR_LEFT:
      begin
        x := x - 1;
        y := y;
      end;
    DR_UPLEFT:
      begin
        x := x - 1;
        y := y - 1;
      end;
  end;
end;

// 找方向和当前位置确定可走下一个位置坐标(位移量=1)
function GetNextPosCanXY(var dir: byte; x, y: Integer): Boolean;
var
  mx, my: Integer;
begin
  Result := FALSE;
  dir := 0; // GetNextDirection(x, y, TargetX, TargetY);
  while TRUE do
  begin
    if dir > DR_UPLEFT then
      break; // DIR 到最后一个方向 还走不了 那么退出
    case dir of
      DR_UP:
        begin
          mx := x;
          my := y;
          GetNextPosXY(DR_UP, mx, my);
          if PlayScene.CanWalk(mx, my) then
          begin
            // x:=mx;
            // y:=my;
            dir := DR_UP;
            Result := TRUE;
            break;
          end
          else
          begin
            Inc(dir);
            Continue;
          end;
        end;
      DR_UPRIGHT:
        begin
          mx := x;
          my := y;
          GetNextPosXY(DR_UPRIGHT, mx, my);
          if PlayScene.CanWalk(mx, my) then
          begin
            // x:=mx;
            // y:=my;
            dir := DR_UPRIGHT;
            Result := TRUE;
            break;
          end
          else
          begin
            Inc(dir);
            Continue;
          end;
        end;
      DR_RIGHT:
        begin
          mx := x;
          my := y;
          GetNextPosXY(DR_RIGHT, mx, my);
          if PlayScene.CanWalk(mx, my) then
          begin
            // x:=mx;
            // y:=my;
            dir := DR_RIGHT;
            Result := TRUE;
            break;
          end
          else
          begin
            Inc(dir);
            Continue;
          end;
        end;
      DR_DOWNRIGHT:
        begin
          mx := x;
          my := y;
          GetNextPosXY(DR_DOWNRIGHT, mx, my);
          if PlayScene.CanWalk(mx, my) then
          begin
            // x:=mx;
            // y:=my;
            dir := DR_DOWNRIGHT;
            Result := TRUE;
            break;
          end
          else
          begin
            Inc(dir);
            Continue;
          end;
        end;
      DR_DOWN:
        begin
          mx := x;
          my := y;
          GetNextPosXY(DR_DOWN, mx, my);
          if PlayScene.CanWalk(mx, my) then
          begin
            // x:=mx;
            // y:=my;
            dir := DR_DOWN;
            Result := TRUE;
            break;
          end
          else
          begin
            Inc(dir);
            Continue;
          end;
        end;
      DR_DOWNLEFT:
        begin
          mx := x;
          my := y;
          GetNextPosXY(DR_DOWNLEFT, mx, my);
          if PlayScene.CanWalk(mx, my) then
          begin
            // x:=mx;
            // y:=my;
            dir := DR_DOWNLEFT;
            break;
          end
          else
          begin
            Inc(dir);
            Continue;
          end;
        end;
      DR_LEFT:
        begin
          mx := x;
          my := y;
          GetNextPosXY(DR_LEFT, mx, my);
          if PlayScene.CanWalk(mx, my) then
          begin
            // x:=mx;
            // y:=my;
            dir := DR_LEFT;
            break;
          end
          else
          begin
            Inc(dir);
            Continue;
          end;
        end;
      DR_UPLEFT:
        begin
          mx := x;
          my := y;
          GetNextPosXY(DR_UPLEFT, mx, my);
          if PlayScene.CanWalk(mx, my) then
          begin
            // x:=mx;
            // y:=my;
            dir := DR_UPLEFT;
            Result := TRUE;
            break;
          end
          else
          begin
            Inc(dir);
            Continue;
          end;
        end;
    else
      break;
    end;
  end;
end;

// 根据方向和当前位置确定下一个位置坐标(位移量=2）
procedure GetNextRunXY(dir: byte; var x, y: Integer);
begin
  case dir of
    DR_UP:
      begin
        x := x;
        y := y - 2;
      end;
    DR_UPRIGHT:
      begin
        x := x + 2;
        y := y - 2;
      end;
    DR_RIGHT:
      begin
        x := x + 2;
        y := y;
      end;
    DR_DOWNRIGHT:
      begin
        x := x + 2;
        y := y + 2;
      end;
    DR_DOWN:
      begin
        x := x;
        y := y + 2;
      end;
    DR_DOWNLEFT:
      begin
        x := x - 2;
        y := y + 2;
      end;
    DR_LEFT:
      begin
        x := x - 2;
        y := y;
      end;
    DR_UPLEFT:
      begin
        x := x - 2;
        y := y - 2;
      end;
  end;
end;

procedure GetNextHorseRunXY(dir: byte; var x, y: Integer);
begin
  case dir of
    DR_UP:
      begin
        x := x;
        y := y - 3;
      end;
    DR_UPRIGHT:
      begin
        x := x + 3;
        y := y - 3;
      end;
    DR_RIGHT:
      begin
        x := x + 3;
        y := y;
      end;
    DR_DOWNRIGHT:
      begin
        x := x + 3;
        y := y + 3;
      end;
    DR_DOWN:
      begin
        x := x;
        y := y + 3;
      end;
    DR_DOWNLEFT:
      begin
        x := x - 3;
        y := y + 3;
      end;
    DR_LEFT:
      begin
        x := x - 3;
        y := y;
      end;
    DR_UPLEFT:
      begin
        x := x - 3;
        y := y - 3;
      end;
  end;
end;

// 根据两点计算移动的方向
function GetNextDirection(sx, sy, dx, dy: Integer): byte;
var
  flagx, flagy: Integer;
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

// 根据当前方向获得转身后的方向
function GetBack(dir: Integer): Integer;
begin
  Result := DR_UP;
  case dir of
    DR_UP:
      Result := DR_DOWN;
    DR_DOWN:
      Result := DR_UP;
    DR_LEFT:
      Result := DR_RIGHT;
    DR_RIGHT:
      Result := DR_LEFT;
    DR_UPLEFT:
      Result := DR_DOWNRIGHT;
    DR_UPRIGHT:
      Result := DR_DOWNLEFT;
    DR_DOWNLEFT:
      Result := DR_UPRIGHT;
    DR_DOWNRIGHT:
      Result := DR_UPLEFT;
  end;
end;

// 根据当前坐标和方向获得后退的坐标
procedure GetBackPosition(sx, sy, dir: Integer; var newx, newy: Integer);
begin
  newx := sx;
  newy := sy;
  case dir of
    DR_UP:
      newy := newy + 1;
    DR_DOWN:
      newy := newy - 1;
    DR_LEFT:
      newx := newx + 1;
    DR_RIGHT:
      newx := newx - 1;
    DR_UPLEFT:
      begin
        newx := newx + 1;
        newy := newy + 1;
      end;
    DR_UPRIGHT:
      begin
        newx := newx - 1;
        newy := newy + 1;
      end;
    DR_DOWNLEFT:
      begin
        newx := newx + 1;
        newy := newy - 1;
      end;
    DR_DOWNRIGHT:
      begin
        newx := newx - 1;
        newy := newy - 1;
      end;
  end;
end;

// 根据当前位置和方向获得前进一步的坐标
procedure GetFrontPosition(sx, sy, dir: Integer; var newx, newy: Integer);
begin
  newx := sx;
  newy := sy;
  case dir of
    DR_UP:
      newy := newy - 1;
    DR_DOWN:
      newy := newy + 1;
    DR_LEFT:
      newx := newx - 1;
    DR_RIGHT:
      newx := newx + 1;
    DR_UPLEFT:
      begin
        newx := newx - 1;
        newy := newy - 1;
      end;
    DR_UPRIGHT:
      begin
        newx := newx + 1;
        newy := newy - 1;
      end;
    DR_DOWNLEFT:
      begin
        newx := newx - 1;
        newy := newy + 1;
      end;
    DR_DOWNRIGHT:
      begin
        newx := newx + 1;
        newy := newy + 1;
      end;
  end;
end;

// 根据两点位置获得飞行方向（8个方向）
function GetFlyDirection(sx, sy, ttx, tty: Integer): Integer;
var
  fx, fy: Real;
begin
  fx := ttx - sx;
  fy := tty - sy;
  { sx := 0;
    sy := 0; }
  Result := DR_DOWN;
  if fx = 0 then
  begin // 两点的X坐标相等
    if fy < 0 then
      Result := DR_UP
    else
      Result := DR_DOWN;
    exit;
  end;
  if fy = 0 then
  begin // 两点的Y坐标相等
    if fx < 0 then
      Result := DR_LEFT
    else
      Result := DR_RIGHT;
    exit;
  end;
  if (fx > 0) and (fy < 0) then
  begin
    if -fy > fx * 2.5 then
      Result := DR_UP
    else if -fy < fx / 3 then
      Result := DR_RIGHT
    else
      Result := DR_UPRIGHT;
  end;
  if (fx > 0) and (fy > 0) then
  begin
    if fy < fx / 3 then
      Result := DR_RIGHT
    else if fy > fx * 2.5 then
      Result := DR_DOWN
    else
      Result := DR_DOWNRIGHT;
  end;
  if (fx < 0) and (fy > 0) then
  begin
    if fy < -fx / 3 then
      Result := DR_LEFT
    else if fy > -fx * 2.5 then
      Result := DR_DOWN
    else
      Result := DR_DOWNLEFT;
  end;
  if (fx < 0) and (fy < 0) then
  begin
    if -fy > -fx * 2.5 then
      Result := DR_UP
    else if -fy < -fx / 3 then
      Result := DR_LEFT
    else
      Result := DR_UPLEFT;
  end;
end;

function GetDirection(SoureceX, SourceY, TargetX, TargetY: Extended): Byte;
var
  ExtensionX, ExtensionY, A, B, C: Extended;
  V: Integer;
begin
  Result := 0;
  ExtensionX := SoureceX;
  ExtensionY := SourceY - 100;
  A := Sqrt(Power((ExtensionX - SoureceX), 2) + Power((ExtensionY - SourceY), 2));
  B := Sqrt(Power((SoureceX - TargetX), 2) + Power((SourceY - TargetY), 2));
  C := Sqrt(Power((TargetX - ExtensionX), 2) + Power((TargetY - ExtensionY), 2));
  V := Round(Arccos((Power(A,2) + Power(B,2) - Power(C,2)) / 2 / B / A) / PI * 180 * 100);
  if TargetX > SoureceX then
  begin
    case V of
      0..1125: Result := 0;
      1126..3375: Result := 1;
      3376..5625: Result := 2;
      5626..7875: Result := 3;
      7876..10125: Result := 4;
      10126..12375: Result := 5;
      12376..14625: Result := 6;
      14626..16875: Result := 7;
      16876..18000: Result := 8;
    end;
  end
  else
  begin
    case V of
      0..1125: Result := 0;
      1126..3375: Result := 15;
      3376..5625: Result := 14;
      5626..7875: Result := 13;
      7876..10125: Result := 12;
      10126..12375: Result := 11;
      12376..14625: Result := 10;
      14626..16875: Result := 9;
      16876..18000: Result := 8;
    end;
  end;
end;

// 根据两点位置获得飞行方向(16个方向)
function GetFlyDirection16(sx, sy, ttx, tty: Integer): Integer;
var
  fx, fy: Real;
begin
  fx := ttx - sx;
  fy := tty - sy;
  { sx := 0;
    sy := 0; }
  Result := 0;
  if fx = 0 then
  begin
    if fy < 0 then
      Result := 0
    else
      Result := 8;
    exit;
  end;
  if fy = 0 then
  begin
    if fx < 0 then
      Result := 12
    else
      Result := 4;
    exit;
  end;
  if (fx > 0) and (fy < 0) then
  begin
    Result := 4;
    if -fy > fx / 4 then
      Result := 3;
    if -fy > fx / 1.9 then
      Result := 2;
    if -fy > fx * 1.4 then
      Result := 1;
    if -fy > fx * 4 then
      Result := 0;
  end;
  if (fx > 0) and (fy > 0) then
  begin
    Result := 4;
    if fy > fx / 4 then
      Result := 5;
    if fy > fx / 1.9 then
      Result := 6;
    if fy > fx * 1.4 then
      Result := 7;
    if fy > fx * 4 then
      Result := 8;
  end;
  if (fx < 0) and (fy > 0) then
  begin
    Result := 12;
    if fy > -fx / 4 then
      Result := 11;
    if fy > -fx / 1.9 then
      Result := 10;
    if fy > -fx * 1.4 then
      Result := 9;
    if fy > -fx * 4 then
      Result := 8;
  end;
  if (fx < 0) and (fy < 0) then
  begin
    Result := 12;
    if -fy > -fx / 4 then
      Result := 13;
    if -fy > -fx / 1.9 then
      Result := 14;
    if -fy > -fx * 1.4 then
      Result := 15;
    if -fy > -fx * 4 then
      Result := 0;
  end;
end;

// 按逆时针转动一个方向后的方向
function PrivDir(ndir: Integer): Integer;
begin
  if ndir - 1 < 0 then
    Result := 7
  else
    Result := ndir - 1;
end;

// 按顺时针转动一个方向后的方向
function NextDir(ndir: Integer): Integer;
begin
  if ndir + 1 > 7 then
    Result := 0
  else
    Result := ndir + 1;
end;

function GetTakeOnPosition(var Item : TClientItem): Integer;
var
  smode:Integer;
  I:Integer;
begin
  smode := Item.S.StdMode;
  Result := -1;
  case smode of // StdMode
    5, 6: Result := U_WEAPON; // 武器
    7:
    begin
      if g_DWinMan.StateWinType <> wk176 then
        Result := U_CHARM; //气血石, 宝石
    end;
    8: Result := U_SHIED;
    10, 11: Result := U_DRESS;
    15: Result := U_HELMET;
    16: Result := U_ZHULI; // 斗笠
    17, 18: Result := U_FASHION;
    19, 20, 21: Result := U_NECKLACE;
    22, 23: Result := U_RINGL;
    24, 26: Result := U_ARMRINGR;
    30{, 29}: Result := U_RIGHTHAND;
    25, 2 { 祝福罐,魔令包 } :
    begin
      if g_DWinMan.StateWinType = wk176 then
      begin
        Result := U_ARMRINGR; // 符
      end else
      begin
        Result := U_BUJUK; // 符
      end;
    end;
    28:
    begin
      if g_DWinMan.StateWinType <> wk176 then
        Result := U_BOOTS; // 鞋
    end;
    27: begin
      if g_DWinMan.StateWinType <> wk176 then
        Result := U_BELT; // 腰带

    end;
    35: begin
      if g_DWinMan.StateWinType <> wk176 then
        Result := U_MOUNT;
    end;
    68:begin
      if (Item.S.Source = 0) then
      begin
        //找一个没有穿戴的十二生肖位置。
        for I := U_ZODIAC1 to U_ZODIAC12 do
        begin
          if g_UseItems[i].Name = '' then
          begin
            Result := I;
            break;
          end;
        end;

        if Result = -1 then
          Result := U_ZODIAC1;
      end else if Item.S.Source in [1..12] then
      begin
        Result := U_ZODIAC1 + Item.S.Source - 1;
      end;
    end;

  end;
end;

// 判断某个键是否按下
function IsKeyPressed(key: byte): Boolean;
var
  keyvalue: TKeyBoardState;
begin
  Result := FALSE;
  FillChar(keyvalue, sizeof(TKeyBoardState), #0);
  if GetKeyboardState(keyvalue) then
    if (keyvalue[key] and $80) <> 0 then
      Result := TRUE;
end;

procedure AddChangeFace(recogid: Integer);
begin
  g_ChangeFaceReadyList.Add(pointer(recogid));
end;

procedure DelChangeFace(recogid: Integer);
var
  i: Integer;
begin
  if g_ChangeFaceReadyList.Count > 0 then // 20080629
    for i := 0 to g_ChangeFaceReadyList.Count - 1 do
    begin
      if Integer(g_ChangeFaceReadyList[i]) = recogid then
      begin
        g_ChangeFaceReadyList.Delete(i);
        break;
      end;
    end;
end;

function IsChangingFace(recogid: Integer): Boolean;
var
  i: Integer;
begin
  Result := FALSE;
  if g_ChangeFaceReadyList.Count > 0 then // 20080629
    for i := 0 to g_ChangeFaceReadyList.Count - 1 do
    begin
      if Integer(g_ChangeFaceReadyList[i]) = recogid then
      begin
        Result := TRUE;
        break;
      end;
    end;
end;

function EmptyClientItem: TClientItem;
begin
  FillChar(Result, ClientItemSize, #0);
end;

Initialization
  DropItems := TList.Create;

Finalization
  DropItems.Free;

end.
