unit uCliOrders;

interface
  uses Classes, SysUtils, Math, Grobal2, Common;

type
  TuOrderItem = class
    Name: String;
    Job: String;
    Sex: String;
    Data: String;
  end;

  TuOrderObject = class
  public
    OrderType: Integer;
    Page: Integer;
    PageCount: Integer;
    MyOrder: Integer;
    RecordCount: Integer;
    SelectOrder: Integer;
    HoverOrder: Integer;
    Items: TList;
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Read(AType, APage, ACount, AMyOrder: Integer; S: AnsiString);
  end;

implementation
  uses AnsiHUtil32, EDCode;

{ TuOrderObject }

procedure TuOrderObject.Clear;
var
  I: Integer;
begin
  OrderType := 0;
  Page := 0;
  PageCount := 0;
  MyOrder := 0;
  RecordCount := 0;
  SelectOrder := -1;
  HoverOrder := -1;
  for I := 0 to Items.Count - 1 do
    TObject(Items[I]).Free;
  Items.Clear;
end;

constructor TuOrderObject.Create;
begin
  Items := TList.Create;
end;

destructor TuOrderObject.Destroy;
begin
  Clear;
  FreeAndNilEx(Items);
  inherited;
end;

procedure TuOrderObject.Read(AType, APage, ACount, AMyOrder: Integer; S: AnsiString);
var
  ALine: AnsiString;
  L, LS: TStrings;
  I: Integer;
  AItem: TuOrderItem;
begin
  Clear;
  OrderType := AType;
  Page := APage - 1;
  PageCount := Ceil(ACount / 10);
  MyOrder := AMyOrder;
  RecordCount := ACount;
  L := TStringList.Create;
  LS := TStringList.Create;
  try
    while True do
    begin
      if S = '' then
        Break;
      S := AnsiGetValidStr3(S, ALine, ['/']);
      L.Add(EDCode.DeCodeString(ALine));
    end;
    for I := 0 to L.Count - 1 do
    begin
      LS.Clear;
      AItem := TuOrderItem.Create;
      AItem.Name := L.Names[I];
      ExtractStrings([','], [], PChar(L.ValueFromIndex[I]), LS);
      if LS.Count = 3 then
      begin
        AItem.Job := GetJobName(StrToIntDef(LS[0], 0));
        AItem.Sex := MaleToString(StrToIntDef(LS[1], 0));
        AItem.Data := LS[2];
      end;
      Items.Add(AItem);
    end;
  finally
    L.Free;
    LS.Free;
  end;
end;

end.
