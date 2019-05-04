unit uGameData;

interface
uses Generics.Collections,VMProtectSDK,SysUtils,Forms;

Type

  TEncryptMethod = array[0..7] of Byte;

  TAntiHackObject<T> = class
  type
    ptrT = ^T;
    DefalutRefProc = function():T;
  private
    FData:ptrT;
    FCheckData:ptrT;
    FCheckMethod:TEncryptMethod; //对每个字节的加密方式

    FDefalutValueCheck:ptrT;
    FDefalutCheckMethod:TEncryptMethod; //对每个字节的加密方式

    FDataSize:Integer;
    function GetData:T;
    procedure SetData(Value:T);
  protected
    function DoGetData():T; virtual;
    procedure DoSetData(Value : T);virtual;

    procedure Encrypt(Value:T; EncryptPoint:ptrT; var Method:TEncryptMethod); //加密数据保存到地址。
    function  Decrypt(DecryptPoint:ptrT; var Method:TEncryptMethod) : T;
    function IsDataModify():Boolean;
    function GetDefalut():T;
  public
    constructor Create(DefalutValue:T);overload;
    property Data:T read GetData write SetData;
  end;

  DWord_Anti = TAntiHackObject<Cardinal>;

  TGameData = class
  public
    LastHitTime:DWord_Anti;
    HitTime:DWord_Anti;
    LastMoveTime : DWord_Anti;
    LastSpellTick:DWord_Anti;
    RunTime:DWord_Anti;
    WalkTime:DWord_Anti;
    SpellTime:DWord_Anti;
    SendPackageIndex:DWord_Anti;

  public
    constructor Create();
    destructor Destroy();override;
  end;

var
  LAST_HIT_TIME :string; //上次攻击时间。
  HIT_SPEED : String; //攻击速度 间隔。

  g_GameData : TGameData;

implementation
uses MShare;

{ TAntiHackObject<T> }

constructor TAntiHackObject<T>.Create(DefalutValue: T);
begin
  FDataSize:= SizeOf(DefalutValue);
  FData := GetMemory(FDataSize);
  FCheckData := GetMemory(FDataSize);

  FDefalutValueCheck:= GetMemory(FDataSize);
  Encrypt(DefalutValue,FDefalutValueCheck,FDefalutCheckMethod);
end;

function TAntiHackObject<T>.Decrypt(DecryptPoint: ptrT;
  var Method: TEncryptMethod): T;
var
  Data:array [0..7] of Byte;
  i: Integer;
begin
  //先把数据拷贝到data
  Move(DecryptPoint^,Data[0],FDataSize);
  for i := 0 to FDataSize - 1 do
  begin
    //说明是 not 操作
    if Method[i] < 128 then
    begin
      Data[i] := not Data[i];
    end else
    begin
      Data[i] := Data[i] xor 133;
    end;
  end;

  Move(Data[0],Result,FDataSize);
end;

procedure TAntiHackObject<T>.Encrypt(Value:T; EncryptPoint: ptrT;
  var Method: TEncryptMethod);
var
  Data:array [0..7] of Byte;
  i: Integer;
begin
  //先将数据移动到等待加密快
  Move(Value,Data[0],FDataSize);

  for i := 0 to FDataSize - 1 do
  begin
    // not 操作
    if Random(2) = 0 then
    begin
      Method[i] := Random(128);
      Data[i] := not Data[i];
    end else
    begin
      Method[i] := Random(128) + 128;
      Data[i] := Data[i] xor 133;
    end;
  end;

  Move(Data[0],EncryptPoint^,FDataSize);
end;

function TAntiHackObject<T>.DoGetData: T;
begin
  VMProtectBeginUltra('ANTI_GETDATA');
  if IsDataModify then
  begin
    g_MySelf := Pointer($FFAC5412);
  end else
  begin
    Result := FData^;
  end;
  VMProtectEnd;
end;

procedure TAntiHackObject<T>.DoSetData(Value: T);
var
  Data:array [0..7] of Byte;
  i: Integer;
begin
  VMProtectBeginUltra('ANTI_SETDATA');
  FData^ := Value;
  Encrypt(Value,FCheckData,FCheckMethod);
  VMProtectEnd;
end;

function TAntiHackObject<T>.GetData: T;
begin
  Result := DoGetData;
end;

function TAntiHackObject<T>.GetDefalut: T;
begin
  Result := Decrypt(FDefalutValueCheck,FDefalutCheckMethod);
end;

function TAntiHackObject<T>.IsDataModify: Boolean;
var
  Data , R :T;
begin
  Move(FData^,Data,FDataSize);
  R := Decrypt(FCheckData,FCheckMethod);
  Result := not CompareMem(@Data,@R,FDataSize);
end;

procedure TAntiHackObject<T>.SetData(Value: T);
begin
  DoSetData(Value);
end;

{ TGameData }

constructor TGameData.Create;
var
  C,B:Cardinal;
begin
   LastHitTime := DWord_Anti.Create(0);
   HitTime := DWord_Anti.Create(0);
   LastMoveTime := DWord_Anti.Create(0);
   LastSpellTick := DWord_Anti.Create(0);
   RunTime := DWord_Anti.Create(0);
   WalkTime := DWord_Anti.Create(0);
   SpellTime := DWord_Anti.Create(0);
   SendPackageIndex := DWord_Anti.Create(0);

   LastHitTime.Data := 0;
   HitTime.Data := 1200;  //攻击间隔时间
   LastMoveTime.Data := 0;//上次移动时间
   LastSpellTick.Data := 0;
   RunTime.Data := 600;
   WalkTime.Data := 600;
   SpellTime.Data := 1000;
   SendPackageIndex.Data := 0;

end;

destructor TGameData.Destroy;
begin
  LastHitTime.Free;
  HitTime.Free;
  LastMoveTime.Free;
  LastSpellTick.Free;
  RunTime.Free;
  inherited;
end;

initialization
g_GameData := TGameData.create;
end.
