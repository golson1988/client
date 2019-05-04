unit uInputString;

interface
  uses Classes, SysUtils, Generics.Collections, EDCode, Common;

type
  TCharObj  = record
    DataString: String;
  end;
  pTCharObj = ^TCharObj;

  TChar = record
    C: Char;
    Obj: pTCharObj;
  end;
  pTChar = ^TChar;

  TInputString = class
  private
    FChrList: TList<pTChar>;
    FChrObjList: TList<pTCharObj>;
    FObjSize: Integer;
    function GetDataString: String;
    function GetObjList: String;
    function GetText: String;
    procedure AppendChar(const C: Char);
    procedure InsertChar(Index: Integer; const C: Char);
    procedure AppendObjectChar(const C: Char; Obj: pTCharObj);
    procedure InsertObjectChar(Index: Integer; const C: Char; Obj: pTCharObj);
    procedure DeleteCharAt(Index: Integer);
    procedure EraseObjAt(Index: Integer);
    function ContainDataString(const Value: String): Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Append(const S: String);
    procedure Insert(Index: Integer; const S: string);
    function AppendObject(const Caption, Obj: String): Boolean;
    function InsertObject(Index: Integer; const Caption, Obj: String): Boolean;
    procedure Delete(Index: Integer); overload;
    procedure Delete(Start, Stop, Length: Integer); overload;
    property DataString: String read GetDataString;
    property ObjList: String read GetObjList;
    property Text: String read GetText;
    property ObjSize: Integer read FObjSize write FObjSize;
  end;

var
  g_InputStr: TInputString;

implementation

{ TInputString }

constructor TInputString.Create;
begin
  FObjSize    :=  4;
  FChrList    :=  TList<pTChar>.Create;
  FChrObjList :=  TList<pTCharObj>.Create;
end;

destructor TInputString.Destroy;
begin
  Clear;
  FreeAndNilEx(FChrList);
  FreeAndNilEx(FChrObjList);
  inherited;
end;

procedure TInputString.Clear;
var
  I: Integer;
begin
  for I := 0 to FChrList.Count - 1 do
    Dispose(FChrList.Items[I]);
  FChrList.Clear;

  for I := 0 to FChrObjList.Count - 1 do
  begin
    System.Finalize(FChrObjList[I]^);
    Dispose(FChrObjList[I]);
  end;
  FChrObjList.Clear;
end;

function TInputString.ContainDataString(const Value: String): Boolean;
var
  I: Integer;
begin
  Result  :=  False;
  for I := 0 to FChrObjList.Count - 1 do
    if (FChrObjList.Items[I]<>nil) and (FChrObjList.Items[I].DataString = Value) then
    begin
      Result  :=  True;
      Break;
    end;
end;

function TInputString.GetDataString: String;
var
  I, ObjIdx: Integer;
  Obj: pTCharObj;
  ASObj: String;
begin
  Result  :=  '';
  I       :=  0;
  ObjIdx  :=  0;
  while I < FChrList.Count do
  begin
    Obj :=  nil;
    if FChrList.Items[I]^.Obj = nil then
      Result  :=  Result + FChrList.Items[I]^.C
    else
    begin
      Obj :=  FChrList.Items[I]^.Obj;
      ASObj :=  FChrList.Items[I]^.C;
      while True do
      begin
        if I > FChrList.Count - 2 then
          Break;
        if FChrList.Items[I + 1]^.Obj = Obj then
        begin
          ASObj :=  ASObj + FChrList.Items[I + 1]^.C;
          Inc(I);
        end
        else
          Break;
      end;
      Result  :=  Result  + Format('{S=%s;E=%d}', [ASObj, ObjIdx]);
      Inc(ObjIdx);
    end;
    Inc(I);
  end;
end;

function TInputString.GetObjList: String;
var
  I: Integer;
  Obj: pTCharObj;
begin
  Result  :=  '';
  I       :=  0;
  while I < FChrList.Count do
  begin
    Obj :=  nil;
    if FChrList.Items[I]^.Obj <> nil then
    begin
      Obj :=  FChrList.Items[I]^.Obj;
      while True do
      begin
        if I > FChrList.Count - 2 then
          Break;
        if FChrList.Items[I + 1]^.Obj = Obj then
          Inc(I)
        else
          Break;
      end;
      Result :=  Result + Obj.DataString + '/';
    end;
    Inc(I);
  end;
end;

function TInputString.GetText: String;
var
  I: Integer;
begin
  Result  :=  '';
  for I := 0 to FChrList.Count - 1 do
    Result  :=  Result + FChrList.Items[I]^.C;
end;

procedure TInputString.AppendChar(const C: Char);
var
  aC: pTChar;
begin
  New(aC);
  aC.C    :=  C;
  aC.Obj  :=  nil;
  FChrList.Add(aC);
end;

procedure TInputString.InsertChar(Index: Integer; const C: Char);
var
  aC: pTChar;
begin
  New(aC);
  aC.C    :=  C;
  aC.Obj  :=  nil;
  if Index > FChrList.Count - 1 then
    FChrList.Add(aC)
  else
    FChrList.Insert(Index, aC);
end;

procedure TInputString.AppendObjectChar(const C: Char; Obj: pTCharObj);
var
  aC: pTChar;
begin
  New(aC);
  aC.C    :=  C;
  aC.Obj  :=  Obj;
  FChrList.Add(aC);
end;

procedure TInputString.InsertObjectChar(Index: Integer; const C: Char; Obj: pTCharObj);
var
  aC: pTChar;
begin
  New(aC);
  aC.C    :=  C;
  aC.Obj  :=  Obj;
  if Index > FChrList.Count - 1 then
    FChrList.Add(aC)
  else
    FChrList.Insert(Index, aC);
end;

procedure TInputString.DeleteCharAt(Index: Integer);
begin
  if (Index >=0) and (Index < self.FChrList.Count) then
  begin
    EraseObjAt(Index);
    FChrList.Delete(Index);
  end;
end;

procedure TInputString.EraseObjAt(Index: Integer);
var
  Obj: pTCharObj;
  I: Integer;
begin
  if FChrList.Count > Index then
  begin
    if FChrList.Items[Index].Obj<>nil then
    begin
      Obj :=  FChrList.Items[Index].Obj;
      for I := Index downto 0 do
        if FChrList.Items[I].Obj = Obj then
          FChrList.Items[I].Obj :=  nil;
      for I := Index + 1 to FChrList.Count - 1 do
        if FChrList.Items[I].Obj = Obj then
          FChrList.Items[I].Obj :=  nil;
      FChrObjList.Remove(Obj);
      System.Finalize(Obj^);
      Dispose(Obj);
    end;
  end;
end;

procedure TInputString.Append(const S: String);
var
  I: Integer;
begin
  for I := 1 to Length(S) do
    AppendChar(S[I]);
end;

procedure TInputString.Insert(Index: Integer; const S: string);
var
  I: Integer;
begin
  if Index > 0 then
    EraseObjAt(Index);
  for I := 1 to Length(S) do
    InsertChar(Index + I - 1, S[I]);
end;

function TInputString.AppendObject(const Caption, Obj: String): Boolean;
var
  ACharObj: pTCharObj;
  I: Integer;
begin
  Result  :=  (FChrObjList.Count < FObjSize) and not ContainDataString(Obj);
  if Result then
  begin
    New(ACharObj);
    System.Initialize(ACharObj^);
    ACharObj.DataString :=  Obj;
    FChrObjList.Add(ACharObj);
    for I := 1 to Length(Caption) do
      AppendObjectChar(Caption[I], ACharObj);
  end;
end;

function TInputString.InsertObject(Index: Integer; const Caption, Obj: String): Boolean;
var
  ACharObj: pTCharObj;
  I: Integer;
begin
  Result  :=  (FChrObjList.Count < FObjSize) and not ContainDataString(Obj);
  if Result then
  begin
    New(ACharObj);
    System.Initialize(ACharObj^);
    ACharObj.DataString :=  Obj;
    FChrObjList.Add(ACharObj);
    EraseObjAt(Index);
    for I := 1 to Length(Caption) do
      InsertObjectChar(Index + I - 1, Caption[I], ACharObj);
  end;
end;

procedure TInputString.Delete(Index: Integer);
begin
  DeleteCharAt(Index);
end;

procedure TInputString.Delete(Start, Stop, Length: Integer);
var
  I: Integer;
begin
  if Length > 0 then
  begin
    if Start < Stop then
    begin
      for I := 0 to Length - 1 do
        DeleteCharAt(Start);
    end
    else for I := 0 to Length - 1 do
    begin
      DeleteCharAt(Stop);
    end;
  end;
end;

initialization
  g_InputStr  :=  TInputString.Create;

finalization
  FreeAndNilEx(g_InputStr);

end.
