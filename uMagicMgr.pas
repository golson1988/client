unit uMagicMgr;

{$I Client.inc}

interface
  uses Classes, SysUtils, uMagicTypes, Generics.Collections, Common, Share,
  NativeXmlObjectStorage, IOUtils, uEDCode, Wil, uCliUITypes, VMProtectSDK,
  AbstractTextures, uLog;

type
  TuMagicEffects = class(uMagicTypes.TuMagicEffects)
  public
    Images: TWMImages;
    constructor Create; override;
  published
    property Directivity;
    property LibFile;
    property StartIndex;
    property EffectStartIndex;
    property Count;
    property Skip;
    property Sound;
  end;

  TuCustomMagicEffectProperties = class(uMagicTypes.TuCustomMagicEffectProperties)
  protected
    function CreateMagicEffects: uMagicTypes.TuMagicEffects; override;
  public
    IconImages: TWMImages;
    constructor Create; override;
    procedure Initializa;
  published
    property IconLib;
    property IconIndex;
    property WarFrame;
    property Start;
    property Run;
    property Hit;
    property Target;
  end;

  TuMagicStrengthenEffectProperties = class(TuCustomMagicEffectProperties)
  published
    property LvlStart;
    property LvlEnd;
    property IconLib;
    property IconIndex;
    property WarFrame;
    property Start;
    property Run;
    property Hit;
    property Target;
  end;

  TuMagicStrengthenItem = class(uMagicTypes.TuMagicStrengthenItem)
  protected
    function GetMagicEffectPropertiesClass: TuCustomMagicEffectPropertiesClass; override;
  end;

  TuMagicClient = class(TuCustomMagicClient)
  private
    FSelectDeath: Boolean;
    FFireType: TFireType;
    FTargetSelectType: TMagicTargetSelectType;
    FNeedBujukShapes: String;
    FMagicID: Integer;
    FNeedBujukCount: Integer;
    FSelfCentred: Boolean;
    FBuilkItemNotEnoughErr: String;
    FNeedBujuk: Boolean;
  protected
    function GetMagicEffectPropertiesClass: TuCustomMagicEffectPropertiesClass; override;
    function GetStrengthenItemClass: TuMagicStrengthenItemClass; override;
  public
    BujukShapes: array of Byte;
    function GetIcon(AStrengthen: Integer; ADowned: Boolean): TAsphyreLockableTexture;
    function GetEffectProperties(AStrengthen: Integer): TuCustomMagicEffectProperties;
    procedure Initializa;
    property NeedBujuk: Boolean read FNeedBujuk;
  published
    property MagicID: Integer read FMagicID write FMagicID;
    property FireType: TFireType read FFireType write FFireType;
    property TargetSelectType: TMagicTargetSelectType read FTargetSelectType write FTargetSelectType;
    property ActionType;
    property TargetEffect;
    property SelectDeath: Boolean read FSelectDeath write FSelectDeath;
    property SelfCentred: Boolean read FSelfCentred write FSelfCentred;
    property NeedBujukShapes: String read FNeedBujukShapes write FNeedBujukShapes;
    property NeedBujukCount: Integer read FNeedBujukCount write FNeedBujukCount;
    property BuilkItemNotEnoughErr: String read FBuilkItemNotEnoughErr write FBuilkItemNotEnoughErr;
    property Default;
    property Strengthen;
    property Assistant;
  end;

  TuMagicManager = class
  private
    FVer: AnsiString;
    FList: TList;
    FDescList: TStringList;
    FItems: TObjectDictionary<Integer, TuMagicClient>;
    FDesc: TDictionary<Integer, String>;
    function FileName: String;
    function DescFileName: String;
    procedure SaveToFile;
    procedure SaveDescToFile;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile;
    procedure LoadDescFromFile;
    procedure LoadFromString(const ASource: AnsiString);
    procedure LoadDescFromString(const ASource: AnsiString);
    procedure Clear;
    function TryGet(const AMagicID: Integer; var AClient: TuMagicClient): Boolean; overload;
    function TryGet(const AMagicID, ALevel: Integer; var AProperties: TuCustomMagicEffectProperties): Boolean; overload;
    function Desc(AMagicID: Integer): String;
    property Ver: AnsiString read FVer write FVer;
  end;

  function CreateEffectFromMagicRun(AClient: TuMagicClient; ALevel: Integer): TEffect;

var
  g_MagicMgr: TuMagicManager;

implementation
  uses MShare;

function CreateEffectFromMagicRun(AClient: TuMagicClient; ALevel: Integer): TEffect;
var
  I: Integer;
  AProperties: TuCustomMagicEffectProperties;
  AFrame: TEffectFrame;
  AWidth, AHeight, APx, APy: Integer;
begin
  Result := nil;
  AProperties := AClient.GetEffectProperties(ALevel);
  if AProperties <> nil then
  begin
    Result :=  TEffect.Create;
    Result.LoopMax := 0;
    Result.EffectID := AClient.FMagicID;
    Result.FramesSound := AProperties.Hit.Sound;
    for I := 0 to AProperties.Hit.Count - 1 do
    begin
      AFrame := TEffectFrame.Create;
      AFrame.Lib := FindWLib(AProperties.Hit.LibFile);
      AFrame.ImgIndex := AProperties.Hit.StartIndex + I;
      if AFrame.Lib <> nil then
      begin
        if AFrame.Lib.GetImgSize(AFrame.ImgIndex, AWidth, AHeight, APx, APy) then
        begin
          AFrame.OffsetX := APx;
          AFrame.OffsetY := APy;
        end;
      end;
      AFrame.Stay := 75;
      AFrame.Alpha := 195;
      Result.AddFrame(AFrame);
    end;
  end;
end;

{ TuMagicManager }

constructor TuMagicManager.Create;
begin
  FItems := TObjectDictionary<Integer, TuMagicClient>.Create([doOwnsValues]);
  FDesc := TDictionary<Integer, String>.Create;
  FList := TList.Create;
  FDescList := TStringList.Create;
end;

function TuMagicManager.Desc(AMagicID: Integer): String;
begin
  if not FDesc.TryGetValue(AMagicID, Result) then
    Result := '';
end;

destructor TuMagicManager.Destroy;
begin
  FreeAndNil(FItems);
  FreeAndNil(FDesc);
  FreeAndNil(FList);
  FreeAndNil(FDescList);
  inherited;
end;

function TuMagicManager.FileName: String;
begin
  if not DirectoryExists(ResourceDir + g_sServerName + '\') then
    CreateDir(ResourceDir + g_sServerName + '\');
  Result := ResourceDir + g_sServerName + '\CustomMagic.dat';
end;

function TuMagicManager.DescFileName: String;
begin
  if not DirectoryExists(ResourceDir + g_sServerName + '\') then
    CreateDir(ResourceDir + g_sServerName + '\');
  Result := ResourceDir + g_sServerName + '\MagicDesc.dat';
end;

procedure TuMagicManager.LoadDescFromFile;
var
  Stream: TMemoryStream;
  F: TFileStream;
  S: AnsiString;
  I, AMagID: Integer;
begin
  try
    if FileExists(DescFileName) then
    begin
      FDescList.Clear;
      FDesc.Clear;
      Stream := TMemoryStream.Create;
      F := TFileStream.Create(DescFileName, fmOpenRead or fmShareDenyNone);
      try
        uEDCode.DecodeStream(F, Stream, uEDCode.DecodeSource('hEZgXn4NhtHpnnPHIv0Dgp3XgO3p7I5jQ2ahshfPVV1ch3cth+u6qpSKyaIrvI+/l9o1aXPvghvTSpYbirbzLxr0vEJXhCFbALA='));
        Stream.Position := 0;
        SetLength(S, Stream.Size);
        Stream.Read(S[1], Stream.Size);
        g_MagicMgr.Ver := Copy(S, 1, 16);
        S := Copy(S, 18, Length(S) - 17);
        Stream.Clear;
        Common.LoadStreamFromString(S, Stream);
        NativeXmlObjectStorage.ObjectLoadFromXmlStream(FDescList, Stream);
        for I := 0 to FDescList.Count - 1 do
        begin
          if FDescList[I] <> '' then
          begin
            AMagID := StrToIntDef(FDescList.Names[I], -1);
            if AMagID > -1 then
              FDesc.AddOrSetValue(AMagID, FDescList.ValueFromIndex[I]);
          end;
        end;
      finally
        F.Free;
        Stream.Free;
      end;
    end;
  except
    on E: Exception do
    begin
      FVer := '';
    {$IFDEF WRITELOG}
      uLog.TLogger.AddLog('MagicManager.LoadDescFromFile:'+ E.Message);
    {$ENDIF}
    end;
  end;
end;

procedure TuMagicManager.LoadDescFromString(const ASource: AnsiString);
var
  SData, S: AnsiString;
  C: AnsiChar;
  Stream: TStringStream;
  I, AMagID: Integer;
begin
  try
    FDescList.Clear;
    FDesc.Clear;
    FVer := Copy(ASource, 1, 16);
    SData := Copy(ASource, 18, Length(ASource) - 17);
    Stream := TStringStream.Create;
    try
      LoadStreamFromString(SData, Stream);
      FDescList.Text := Stream.DataString;
      for I := 0 to FDescList.Count - 1 do
      begin
        if FDescList[I] <> '' then
        begin
          AMagID := StrToIntDef(FDescList.Names[I], -1);
          if AMagID > -1 then
            FDesc.AddOrSetValue(AMagID, FDescList.ValueFromIndex[I]);
        end;
      end;
      SaveDescToFile;
    finally
      Stream.Free;
    end;
  except
    {$IFDEF WRITELOG}
    on E: Exception do
      uLog.TLogger.AddLog('MagicManager.LoadFromString:'+ E.Message);
    {$ENDIF}
  end;
end;

procedure TuMagicManager.LoadFromFile;
var
  Stream: TMemoryStream;
  F: TFileStream;
  S: AnsiString;
  I: Integer;
  LS: TStrings;
  AClient: TuMagicClient;
begin
  VMProtectSDK.VMProtectBeginVirtualization('MagicManager.LoadFromFile');
  try
    if FileExists(FileName) then
    begin
      Clear;
      Stream := TMemoryStream.Create;
      LS := TStringList.Create;
      F := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
      try
        uEDCode.DecodeStream(F, Stream, uEDCode.DecodeSource('NeG7lDTIub1KUJhUo9T9xwEuQfBwf2gG/XVWr0JxqNWV1fmuABKhS2dEqCLMGi5gDTqlEGMypmdSwrGxUycx/dquzPoxfgbVoE4='));
        Stream.Position := 0;
        SetLength(S, Stream.Size);
        Stream.Read(S[1], Stream.Size);
        FVer := Copy(S, 1, 16);
        S := Copy(S, 18, Length(S) - 17);
        LS.Text := S;
        for I := 0 to LS.Count - 1 do
        begin
          Stream.Clear;
          AClient := TuMagicClient.Create;
          Common.LoadStreamFromString(LS[I], Stream);
          NativeXmlObjectStorage.ObjectLoadFromXmlStream(AClient, Stream);
          AClient.Initializa;
          FItems.AddOrSetValue(AClient.FMagicID, AClient);
          FList.Add(AClient);
        end;
      finally
        F.Free;
        Stream.Free;
        LS.Free;
      end;
    end;
  except
    on E: Exception do
    begin
      FVer := '';
    {$IFDEF WRITELOG}
      uLog.TLogger.AddLog('MagicManager.LoadFromFile:'+ E.Message);
    {$ENDIF}
    end;
  end;
  VMProtectSDK.VMProtectEnd;
end;

procedure TuMagicManager.LoadFromString(const ASource: AnsiString);
var
  SData, S: AnsiString;
  LS: TStrings;
  Stream: TMemoryStream;
  AMagicObject: TuBaseMagicObject;
  AClient: TuMagicClient;
  I, AMagID: Integer;
begin
  VMProtectSDK.VMProtectBeginVirtualization('MagicManager.LoadFromString');
  try
    Clear;
    FVer := Copy(ASource, 1, 16);
    SData := Copy(ASource, 18, Length(ASource) - 17);
    LS := TStringList.Create;
    Stream := TMemoryStream.Create;
    try
      LS.Text := SData;
      for I := 0 to LS.Count - 1 do
      begin
        if LS[I] <> '' then
        begin
          AMagID := StrToIntDef(LS.Names[I], -1);
          if AMagID > -1 then
          begin
            AMagicObject := TuBaseMagicObject.Create(nil);
            try
              Stream.Clear;
              S := LS.ValueFromIndex[I];
              Common.LoadStreamFromString(S, Stream);
              NativeXmlObjectStorage.ObjectLoadFromXmlStream(AMagicObject, Stream);
              AClient := TuMagicClient.Create;
              AClient.Assign(AMagicObject.Client);
              AClient.FMagicID := AMagID;
              AClient.FireType := AMagicObject.FireType;
              AClient.TargetSelectType := AMagicObject.TargetSelectType;
              AClient.SelectDeath := AMagicObject.SelectDeath;
              AClient.SelfCentred := AMagicObject.SelfCentred;
              AClient.FNeedBujukShapes := AMagicObject.NeedBujukShapes;
              AClient.FNeedBujukCount := AMagicObject.NeedBujukCount;
              AClient.FBuilkItemNotEnoughErr := AMagicObject.BuilkItemNotEnoughErr;
              AClient.Initializa;
              FItems.AddOrSetValue(AMagID, AClient);
              FList.Add(AClient);
            finally
              AMagicObject.Free;
            end;
          end;
        end;
      end;
      SaveToFile;
    finally
      LS.Free;
      Stream.Free;
    end;
  except
    {$IFDEF WRITELOG}
    on E: Exception do
      uLog.TLogger.AddLog('MagicManager.LoadFromString:'+ E.Message);
    {$ENDIF}
  end;
  VMProtectSDK.VMProtectEnd;
end;

procedure TuMagicManager.SaveDescToFile;
var
  Stream: TMemoryStream;
  F: TFileStream;
  S: AnsiString;
begin
  try
    if FileExists(DescFileName) then
      IOUtils.TFile.Delete(DescFileName);

    S := '';
    Stream := TMemoryStream.Create;
    F := TFileStream.Create(DescFileName, fmCreate);
    try
      NativeXmlObjectStorage.ObjectSaveToXmlStream(FDescList, Stream);
      S := FVer + '/' + Common.SaveStreamToString(Stream);

      Stream.Clear;
      Stream.Write(S[1], Length(S));
      uEDCode.EncodeStream(Stream, F, uEDCode.DecodeSource('UuGYKY65Llic87dbBHHdBuYTCC4ynogMmiMN2/EFJjApTUwgyifO/7lpkW7xkujaHVsHCf8sBMntEA6L12P0NMSNTyyNQGuUbxM='));
    finally
      Stream.Free;
      F.Free;
    end;
  except
    {$IFDEF WRITELOG}
    on E: Exception do
      uLog.TLogger.AddLog('MagicManager.SaveToFile:'+ E.Message);
    {$ENDIF}
  end;
end;

procedure TuMagicManager.SaveToFile;
var
  Stream: TMemoryStream;
  F: TFileStream;
  S: AnsiString;
  I: Integer;
begin
  VMProtectSDK.VMProtectBeginVirtualization('MagicManager.SaveToFile');
  try
    if FileExists(FileName) then
      IOUtils.TFile.Delete(FileName);

    S := '';
    Stream := TMemoryStream.Create;
    F := TFileStream.Create(FileName, fmCreate);
    try
      S := FVer + '/';
      for I := 0 to FList.Count - 1 do
      begin
        Stream.Clear;
        NativeXmlObjectStorage.ObjectSaveToXmlStream(TuMagicClient(FList[I]), Stream);
        S := S + Common.SaveStreamToString(Stream) + #$D#$A;
      end;
      Stream.Clear;
      Stream.Write(S[1], Length(S));
      uEDCode.EncodeStream(Stream, F, uEDCode.DecodeSource('a0lhpOmA72Pm02oOsSL1QvIDr59HtXrnTNDfp2uFQ6ZQc9ywZ8GaMZn0cPHy7FsS7CzBpODKYcPC7JMOiifkiG1zyYHHI6Nt7oo='));
    finally
      Stream.Free;
      F.Free;
    end;
  except
    {$IFDEF WRITELOG}
    on E: Exception do
      uLog.TLogger.AddLog('MagicManager.SaveToFile:'+ E.Message);
    {$ENDIF}
  end;
  VMProtectSDK.VMProtectEnd;
end;

procedure TuMagicManager.Clear;
begin
  FItems.Clear;
  FList.Clear;
  FDescList.Clear;
  FDesc.Clear;
end;

function TuMagicManager.TryGet(const AMagicID: Integer; var AClient: TuMagicClient): Boolean;
begin
  Result := FItems.TryGetValue(AMagicID, AClient);
end;

function TuMagicManager.TryGet(const AMagicID, ALevel: Integer; var AProperties: TuCustomMagicEffectProperties): Boolean;
var
  AClient: TuMagicClient;
begin
  Result := False;
  if TryGet(AMagicID, AClient) then
  begin
    AProperties := AClient.GetEffectProperties(ALevel);
    Result := AProperties <> nil;
  end;
end;

{ TuCustomMagicEffectProperties }

constructor TuCustomMagicEffectProperties.Create;
begin
  inherited;
  IconImages := nil;
end;

function TuCustomMagicEffectProperties.CreateMagicEffects: uMagicTypes.TuMagicEffects;
begin
  Result := TuMagicEffects.Create;
end;

procedure TuCustomMagicEffectProperties.Initializa;
begin
  LibManager.TryGetLib(IconLib, IconImages);
  LibManager.TryGetLib(Start.LibFile, TuMagicEffects(Start).Images);
  LibManager.TryGetLib(Run.LibFile, TuMagicEffects(Run).Images);
  LibManager.TryGetLib(Hit.LibFile, TuMagicEffects(Hit).Images);
end;

{TuMagicClient}

function TuMagicClient.GetMagicEffectPropertiesClass: TuCustomMagicEffectPropertiesClass;
begin
  Result := TuCustomMagicEffectProperties;
end;

function TuMagicClient.GetStrengthenItemClass: TuMagicStrengthenItemClass;
begin
  Result := TuMagicStrengthenItem;
end;

procedure TuMagicClient.Initializa;
var
  I: Integer;
  L: TStrings;
begin
  TuCustomMagicEffectProperties(Default).Initializa;
  for I := 0 to Strengthen.Count - 1 do
    TuMagicStrengthenEffectProperties(Strengthen[I].Properties).Initializa;
  L := TStringList.Create;
  try
    ExtractStrings([',', ';'], [], PChar(FNeedBujukShapes), L);
    for I := L.Count - 1 downto 0 do
    begin
      if StrToIntDef(L[I], -1) = -1 then
        L.Delete(I);
    end;
    FNeedBujuk := (L.Count > 0) and (FNeedBujukCount > 0);
    if FNeedBujuk then
    begin
      SetLength(BujukShapes, L.Count);
      for I := 0 to L.Count - 1 do
        BujukShapes[I] := StrToInt(L[I]);
    end;
  finally
    L.Free;
  end;
end;

function TuMagicClient.GetIcon(AStrengthen: Integer; ADowned: Boolean): TAsphyreLockableTexture;
begin
  Result := nil;
  with TuCustomMagicEffectProperties(Default) do
  begin
    if (IconIndex >= 0) and (IconImages <> nil) then
      Result := IconImages.Images[IconIndex + Ord(ADowned)];
  end;
end;

function TuMagicClient.GetEffectProperties(AStrengthen: Integer): TuCustomMagicEffectProperties;
var
  I: Integer;
begin
  Result := nil;
  if AStrengthen > 0 then
  begin
    for I := 0 to Strengthen.Count - 1 do
    begin
      if (AStrengthen >= Strengthen[I].Properties.LvlStart) and (AStrengthen <= Strengthen[I].Properties.LvlEnd) then
      begin
        Result := TuCustomMagicEffectProperties(Strengthen[I].Properties);
        Break;
      end;
    end;
  end;
  if Result = nil then
    Result := TuCustomMagicEffectProperties(Default);
end;

{ TuMagicEffects }

constructor TuMagicEffects.Create;
begin
  inherited;
  Images := nil;
end;

{ TuMagicStrengthenItem }

function TuMagicStrengthenItem.GetMagicEffectPropertiesClass: TuCustomMagicEffectPropertiesClass;
begin
  Result := TuMagicStrengthenEffectProperties;
end;

initialization
  g_MagicMgr := TuMagicManager.Create;

finalization
  FreeAndNil(g_MagicMgr);

end.
