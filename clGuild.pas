unit clGuild;

interface
  uses Classes, SysUtils, JSON, Graphics;

type
  TclGuildMember = class
  private
    FName: String;
    FOnLine: Boolean;
  public
    property Name: String read FName write FName;
    property OnLine: Boolean read FOnLine write FOnLine;
  end;

  TclGuildRank = class
  private
    FRankNo: Integer;
    FRankName: String;
    FMembers: TList;
    function Get(index: Integer): TclGuildMember;
    function GetCount: Integer;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;

    property RankNo: Integer read FRankNo write FRankNo;
    property RankName: String read FRankName write FRankName;
    property Count: Integer read GetCount;
    property Members[index: Integer]: TclGuildMember read Get; default;
  end;

  TclGuildTextNode = class
  private
    FColor: TColor;
    FValue: String;
    FLeft: Integer;
  public
    property Value: String read FValue write FValue;
    property Color: TColor read FColor write FColor;
    property Left: Integer read FLeft write FLeft;
  end;

  TclGuildTextLine = class
  private
    FList: TList;
    function Get(index: Integer): TclGuildTextNode;
    function GetCount: Integer;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const S: String; Color: TColor = clWhite): TclGuildTextNode;
    property Count: Integer read GetCount;
    property Items[index: Integer]: TclGuildTextNode read Get; default;
  end;

  TclGuildTexts = class
  private
    FList: TList;
    function Get(index: Integer): TclGuildTextLine;
    function GetCount: Integer;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;

    function Add: TclGuildTextLine;
    property Count: Integer read GetCount;
    property Lines[index: Integer]: TclGuildTextLine read Get; default;
  end;

  TclGuild = class
  private
    FGuildName: String;
    FCommanderMode: Boolean;
    FNotice: TStrings;
    FKillGuilds: TStrings;
    FAllyGuilds: TStrings;
    FRankList: TList;
    FTexts: TclGuildTexts;
    FMembers: TStrings;
    FChats: TStrings;
    FLogChat: Boolean;
    FIsChatView: Boolean;
    function Get(index: Integer): TclGuildRank;
    function GetCount: Integer;
    procedure ClearGuild;
    procedure ClearRankList;
    procedure BuildGuildTexts;
    procedure BuildRankListTexts;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Load(const S: String);
    procedure LoadRankList(const S: String);
    procedure LoadChats;
    procedure AddChat(const S: String);

    property GuildName: String read FGuildName write FGuildName;
    property CommanderMode: Boolean read FCommanderMode write FCommanderMode;
    property Notice: TStrings read FNotice write FNotice;
    property KillGuilds: TStrings read FKillGuilds;
    property AllyGuilds: TStrings read FAllyGuilds;
    property Count: Integer read GetCount;
    property Ranks[index:Integer]: TclGuildRank read Get; default;
    property Texts: TclGuildTexts read FTexts;
    property Members: TStrings read FMembers;
    property Chats: TStrings read FChats;
    property LogChat: Boolean read FLogChat write FLogChat;
  end;

var
  g_Guild: TclGuild;

implementation
  uses CLFunc;

{ TclGuildRank }

constructor TclGuildRank.Create;
begin
  FMembers := TList.Create;
end;

destructor TclGuildRank.Destroy;
begin
  Clear;
  FMembers.Free;
  inherited;
end;

procedure TclGuildRank.Clear;
var
  I: Integer;
begin
  for I := 0 to FMembers.Count - 1 do
    TObject(FMembers[I]).Free;
  FMembers.Clear;
end;

function TclGuildRank.Get(index: Integer): TclGuildMember;
begin
  Result := FMembers[index];
end;

function TclGuildRank.GetCount: Integer;
begin
  Result := FMembers.Count;
end;

{ TclGuildTextLine }

constructor TclGuildTextLine.Create;
begin
  FList := TList.Create;
end;

destructor TclGuildTextLine.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TclGuildTextLine.Add(const S: String; Color: TColor): TclGuildTextNode;
begin
  Result := TclGuildTextNode.Create;
  Result.FColor := Color;
  Result.FValue := S;
  FList.Add(Result);
end;

procedure TclGuildTextLine.Clear;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    TObject(FList[I]).Free;
  FList.Clear;
end;

function TclGuildTextLine.Get(index: Integer): TclGuildTextNode;
begin
  Result := FList[index];
end;

function TclGuildTextLine.GetCount: Integer;
begin
  Result := FList.Count;
end;

{ TclGuildTexts }

constructor TclGuildTexts.Create;
begin
  FList := TList.Create;
end;

destructor TclGuildTexts.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TclGuildTexts.Add: TclGuildTextLine;
begin
  Result := TclGuildTextLine.Create;
  FList.Add(Result);
end;

procedure TclGuildTexts.Clear;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    TObject(FList[I]).Free;
  FList.Clear;
end;

function TclGuildTexts.Get(index: Integer): TclGuildTextLine;
begin
  Result := FList[index];
end;

function TclGuildTexts.GetCount: Integer;
begin
  Result := FList.Count;
end;

{ TclGuild }

constructor TclGuild.Create;
begin
  FNotice := TStringList.Create;
  FKillGuilds := TStringList.Create;
  FAllyGuilds := TStringList.Create;
  FRankList := TList.Create;
  FTexts := TclGuildTexts.Create;
  FMembers := TStringList.Create;
  FChats := TStringList.Create;
end;

destructor TclGuild.Destroy;
begin
  FNotice.Free;
  FKillGuilds.Free;
  FAllyGuilds.Free;
  FRankList.Free;
  FTexts.Free;
  FMembers.Free;
  FChats.Free;
  inherited;
end;

function TclGuild.Get(index: Integer): TclGuildRank;
begin
  Result := FRankList[index];
end;

function TclGuild.GetCount: Integer;
begin
  Result := FRankList.Count;
end;

procedure TclGuild.Clear;
begin
  ClearGuild;
  ClearRankList;
  FMembers.Clear;
  FChats.Clear;
  FIsChatView := False;
end;

procedure TclGuild.ClearGuild;
begin
  FNotice.Clear;
  FKillGuilds.Clear;
  FAllyGuilds.Clear;
end;

procedure TclGuild.ClearRankList;
var
  I: Integer;
begin
  for I := 0 to FRankList.Count - 1 do
    TObject(FRankList[I]).Free;
  FRankList.Clear;
  FMembers.Clear;
end;

procedure TclGuild.BuildGuildTexts;
var
  I: Integer;
  ATextLine: TclGuildTextLine;
  ATextNode: TclGuildTextNode;
begin
  FTexts.Add.Add(Char(7) + '公告');
  FTexts.Add;
  if FNotice.Count > 0 then
  begin
    for I := 0 to FNotice.Count - 1 do
      FTexts.Add.Add(FNotice[I], clSilver);
    FTexts.Add;
  end;

  FTexts.Add.Add(Char(7) + '敌对行会');
  FTexts.Add;
  if FKillGuilds.Count > 0 then
  begin
    ATextLine := nil;
    for I := 0 to FKillGuilds.Count - 1 do
    begin
      if ATextLine = nil then
        ATextLine := FTexts.Add;
      ATextNode := ATextLine.Add(FKillGuilds[I], clSilver);
      case ATextLine.Count of
        1: ATextNode.FLeft := 8;
        2: ATextNode.FLeft := 192;
        3: ATextNode.FLeft := 376;
      end;
      if ATextLine.Count = 3 then
        ATextLine := nil;
    end;
    FTexts.Add;
  end;

  FTexts.Add.Add(Char(7) + '联盟行会');
  FTexts.Add;
  if FAllyGuilds.Count > 0 then
  begin
    ATextLine := nil;
    for I := 0 to FAllyGuilds.Count - 1 do
    begin
      if ATextLine = nil then
        ATextLine := FTexts.Add;
      ATextNode := ATextLine.Add(FAllyGuilds[I], clSilver);
      case ATextLine.Count of
        1: ATextNode.FLeft := 8;
        2: ATextNode.FLeft := 192;
        3: ATextNode.FLeft := 376;
      end;
      if ATextLine.Count = 3 then
        ATextLine := nil;
    end;
    FTexts.Add;
  end;
end;

procedure TclGuild.BuildRankListTexts;
var
  I, J: Integer;
  ARank: TclGuildRank;
  ATextLine: TclGuildTextLine;
  ATextNode: TclGuildTextNode;
begin
  for I := 0 to FRankList.Count - 1 do
  begin
    ARank := FRankList[I];
    if FCommanderMode then
    begin
      FTexts.Add.Add(PaddingString('(' + IntToStr(ARank.FRankNo) + ')', 3) + '<' + ARank.FRankName + '>');
      FMembers.Add('#' + IntToStr(ARank.FRankNo) + ' <' + ARank.FRankName + '>');
    end
    else
      FTexts.Add.Add('<' + ARank.FRankName + '>');
    FTexts.Add;
    ATextLine := nil;
    for J := 0 to ARank.Count - 1 do
    begin
      if ATextLine = nil then
        ATextLine := FTexts.Add;
      ATextNode := ATextLine.Add(ARank[J].Name, clSilver);
      FMembers.Add(ARank[J].Name);
      if ARank[J].FOnLine then
        ATextNode.FColor := clGreen;
      case ATextLine.Count of
        1: ATextNode.FLeft := 8;
        2: ATextNode.FLeft := 118;
        3: ATextNode.FLeft := 228;
        4: ATextNode.FLeft := 338;
        5: ATextNode.FLeft := 448;
      end;
      if ATextLine.Count = 5 then
        ATextLine := nil;
    end;
    FTexts.Add;
  end;
end;

procedure TclGuild.Load(const S: String);
var
  AJGuild: TJSONObject;
  AJKillGuilds, AJAllyGuilds: TJSONArray;
  I: Integer;
begin
  try
    FIsChatView := False;
    ClearGuild;
    FTexts.Clear;
    AJGuild := TJSONObject.ParseJSONValue(S) as TJSONObject;
    FGuildName := AJGuild.GetValue('GuildName').Value;

    FCommanderMode := AJGuild.GetValue('CommanderMode') is TJSONTrue;
    FNotice.Text := AJGuild.GetValue('Notice').Value;

    AJKillGuilds := AJGuild.GetValue('KillGuilds') as TJSONArray;
    for I := 0 to AJKillGuilds.Count - 1 do
      FKillGuilds.Add(AJKillGuilds.Items[I].Value);

    AJAllyGuilds := AJGuild.GetValue('AllyGuilds') as TJSONArray;
    for I := 0 to AJAllyGuilds.Count - 1 do
      FAllyGuilds.Add(AJAllyGuilds.Items[I].Value);
    AJGuild.Free;
    BuildGuildTexts;
  except
  end;
end;

procedure TclGuild.LoadRankList(const S: String);
var
  AJRankList, AJMembers: TJSONArray;
  AJRank, AJMember: TJSONObject;
  I, J: Integer;
  ARank: TclGuildRank;
  AMember: TclGuildMember;
begin
  try
    FIsChatView := False;
    ClearRankList;
    FTexts.Clear;
    AJRankList := TJSONObject.ParseJSONValue(S) as TJSONArray;
    for I := 0 to AJRankList.Count - 1 do
    begin
      AJRank := AJRankList.Items[I] as TJSONObject;
      ARank := TclGuildRank.Create;
      FRankList.Add(ARank);
      ARank.FRankNo := StrToIntDef(AJRank.GetValue('RankNo').Value, 0);
      ARank.RankName := AJRank.GetValue('RankName').Value;
      AJMembers := AJRank.GetValue('Members') as TJSONArray;
      for J := 0 to AJMembers.Count - 1 do
      begin
        AJMember := AJMembers.Items[J] as TJSONObject;
        AMember := TclGuildMember.Create;
        AMember.FName := AJMember.GetValue('Name').Value;
        AMember.FOnLine := AJMember.GetValue('Online') <> nil;
        ARank.FMembers.Add(AMember);
      end;
    end;
    AJRankList.Free;
    BuildRankListTexts;
  except
  end;
end;

procedure TclGuild.LoadChats;
var
  I: Integer;
begin
  FTexts.Clear;
  FIsChatView := True;
  for I := 0 to FChats.Count - 1 do
    FTexts.Add.Add(FChats[I], clGreen);
end;

procedure TclGuild.AddChat(const S: String);
begin
  FChats.Add(S);
  if FChats.Count > 500 then
    FChats.Delete(0);
  if FIsChatView then
  begin
    FTexts.Add.Add(S, clGreen);
    if FTexts.Count > 500 then
    begin
      TObject(FTexts.FList[0]).Free;
      FTexts.FList.Delete(0);
    end;
  end;
end;

initialization
  g_Guild := TclGuild.Create;

finalization
  g_Guild.Free;

end.
