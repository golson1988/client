unit uVirtualMap;

interface
  uses Classes, SysUtils, Generics.Collections, Actor, clEvent, Grobal2;

type
  TVirtualMapCell = record
    Deaths: Byte;
    Actors: Byte;
    Items: Byte;
  end;
  TVirtualMapRow = array[0..999, 0..999] of TVirtualMapCell;
  PTVirtualMapRow = ^TVirtualMapRow;

  TVirtualMap = class
  private
    FVirtualMapRow: PTVirtualMapRow;
    FLocker: TObject;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Lock;
    procedure UnLock;
    procedure Clear;
    procedure CheckDrawActorInMap(AActor: TActor);
    procedure CheckDrawItemInMap(X, Y: Integer; var Value: Boolean);
  end;

const
  MAX_CELL_LEN = 3;

var
  VirtualMap: TVirtualMap;

implementation

{ TVirtualMap }

procedure TVirtualMap.CheckDrawItemInMap(X, Y: Integer; var Value: Boolean);
begin
  Value := False;
  if FVirtualMapRow[X, Y].Items < MAX_CELL_LEN then
  begin
    Inc(FVirtualMapRow[X, Y].Items);
    Value := True;
  end;
end;

procedure TVirtualMap.Clear;
begin
  FillChar(FVirtualMapRow^, SizeOf(TVirtualMapRow), #0);
end;

constructor TVirtualMap.Create;
begin
  FLocker := TObject.Create;
  New(FVirtualMapRow);
  FillChar(FVirtualMapRow^, SizeOf(TVirtualMapRow), #0);
end;

destructor TVirtualMap.Destroy;
begin
  FreeMem(FVirtualMapRow);
  FreeAndNil(FLocker);
  inherited;
end;

procedure TVirtualMap.Lock;
begin
  TMonitor.Enter(FLocker);
end;

procedure TVirtualMap.UnLock;
begin
  TMonitor.Exit(FLocker);
end;

procedure TVirtualMap.CheckDrawActorInMap(AActor: TActor);
begin
  if AActor.m_boDeath then
  begin
    if FVirtualMapRow[AActor.m_nCurrX, AActor.m_nCurrY].Deaths < MAX_CELL_LEN then
      Inc(FVirtualMapRow[AActor.m_nCurrX, AActor.m_nCurrY].Deaths)
    else
      AActor.m_boVisible := False;
  end
  else
  begin
    if FVirtualMapRow[AActor.m_nCurrX, AActor.m_nCurrY].Actors < MAX_CELL_LEN then
      Inc(FVirtualMapRow[AActor.m_nCurrX, AActor.m_nCurrY].Actors)
    else
      AActor.m_boVisible := False;
  end;
end;

initialization
  VirtualMap := TVirtualMap.Create;

finalization
  FreeAndNil(VirtualMap);

end.
