unit SoundUtil;

interface

uses
  Windows, Forms, SysUtils, Classes, Grobal2, HUtil32, Generics.Collections,
  uSoundEngine, Share, Common,uSyncObj;

type
  TSoundManager = class;

  TSoundFile = class
  private
    Loop, Wait: Boolean;
    FileName: String;
  end;

  TSoundInnerThread = class(TThread)
  private
    FManager: TSoundManager;
  protected
    procedure Execute; override;
  public
    constructor Create(AManager: TSoundManager);
  end;

  TOnAddDownloadSoundFile = procedure(const AFileName: String;
    Important: Boolean) of Object;

  TSoundManager = class
  private
    FSoundList: TStrings;
    FSkillSoundEffect:TStringList;
    FMapSound: TSoundHandler;
    FSoundEngine: TSoundEngine;
    FSoundFiles: TFixedThreadList;
    FPath: String;
    FMapMusicEndTick: LongWord;
    FTerminated, FSilenced, FMapMusicSilenced: Boolean;
    FBGSoundVolume: Single;
    FAddDownloadSoundFile: TOnAddDownloadSoundFile;
    FAddDownLoadFile: TOnAddDownloadSoundFile;
    FInnerThread: TSoundInnerThread;
    function ExtactSoundFileName(var S: String): Boolean;
    procedure AddDownloadSoundFile(const AFileName: String);
    procedure AddDownLoadFile(const AFileName: String);
    procedure _SoundEffectFile(const AFileName: String; Loop, Wait: Boolean);
    procedure DoMapMusicEnd(Sender: TObject);
    procedure SetPath(const Value: String);
    procedure SetSilenced(const Value: Boolean);
    procedure SetMapMusicSilenced(const Value: Boolean);
    procedure Run;
    procedure LoadSoundListCommon(Const ASoundListFile:string;List:TStrings);
    procedure PlaySoundWithConfig(Idx:Integer;Config:TStrings);
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadSoundList(const ASoundListFile: string);
    procedure LoadSkillSoundEffectList(const ASoundListFile: String);
    procedure DXPlaySound(idx: integer);
    procedure SkillEffectPlaySound(idx: integer);
    // 技能播放声效 区别是 1000000 以下播放自带 100W以上使用 技能配置
    procedure PlaySoundEx(const ASoundFile: String);
    procedure MyPlaySound(wavname: string);
    // 合击声音
    procedure PHHitSound(WhatSound: integer);
    procedure PlayBGM(wavname: string);
    procedure SilenceSound;
    procedure ItemClickSound(std: TStdItem);
    procedure ItemUseSound(stdmode, shape: integer);
    procedure PlayMapMusic(boFlag: Boolean);
    procedure Stop;
    procedure BGSoundStop;
    procedure SoundStop;
    procedure SetBGSoundVolume(V: integer);
    procedure SetSoundVolume(V: integer);

    property Path: String read FPath write SetPath;
    property SoundList: TStrings read FSoundList write FSoundList;
    property Silenced: Boolean read FSilenced write SetSilenced;
    property MapMusicSilenced: Boolean read FMapMusicSilenced
      write SetMapMusicSilenced;
    property OnAddDownloadSoundFile: TOnAddDownloadSoundFile
      read FAddDownloadSoundFile write FAddDownloadSoundFile;
    property OnAddDownloadFile: TOnAddDownloadSoundFile read FAddDownLoadFile
      write FAddDownLoadFile;
  end;

const
  // bmg_intro             = 'wav\Game over2.wav';
  // bmg_select            = 'wav\main_theme.wav';
  bmg_intro = 'wav\log-in-long2.wav';
  bmg_select = 'wav\sellect-loop2.wav';
  bmg_field = 'wav\Field2.wav';
  bmg_gameover = 'wav\game over2.wav';

  HeroLogin_ground = 'wav\HeroLogin.wav';
  HeroHeroLogout_ground = 'wav\HeroLogout.wav';
  Protechny_ground = 'wav\newysound-mix.wav'; // 烟花声音
  heroshield_ground = 'wav\hero-shield.wav'; // 护体神盾声音
  SelectBoxFlash_ground = 'wav\SelectBoxFlash.wav'; // 点宝箱声音
  Openbox_ground = 'wav\Openbox.wav'; // 打开宝箱声音
  longswordhit_ground = 'wav\longsword-hit.wav'; // 开天斩 20080302
  powerup_ground = 'wav\powerup.wav'; // 人物升级声音 20080311
  darewin_ground = 'wav\dare-win.wav'; // 卧龙挖东西声音
  spring_ground = 'wav\spring.wav'; // 泉水声音 20080624

  s_walk_ground_l = 1;
  s_walk_ground_r = 2;
  s_run_ground_l = 3;
  s_run_ground_r = 4;
  s_walk_stone_l = 5;
  s_walk_stone_r = 6;
  s_run_stone_l = 7;
  s_run_stone_r = 8;
  s_walk_lawn_l = 9;
  s_walk_lawn_r = 10;
  s_run_lawn_l = 11;
  s_run_lawn_r = 12;
  s_walk_rough_l = 13;
  s_walk_rough_r = 14;
  s_run_rough_l = 15;
  s_run_rough_r = 16;
  s_walk_wood_l = 17;
  s_walk_wood_r = 18;
  s_run_wood_l = 19;
  s_run_wood_r = 20;
  s_walk_cave_l = 21;
  s_walk_cave_r = 22;
  s_run_cave_l = 23;
  s_run_cave_r = 24;
  s_walk_room_l = 25;
  s_walk_room_r = 26;
  s_run_room_l = 27;
  s_run_room_r = 28;
  s_walk_water_l = 29;
  s_walk_water_r = 30;
  s_run_water_l = 31;
  s_run_water_r = 32;

  s_hit_short = 50;
  s_hit_wooden = 51;
  s_hit_sword = 52;
  s_hit_do = 53;
  s_hit_axe = 54;
  s_hit_club = 55;
  s_hit_long = 56;
  s_hit_fist = 57;

  s_struck_short = 60;
  s_struck_wooden = 61;
  s_struck_sword = 62;
  s_struck_do = 63;
  s_struck_axe = 64;
  s_struck_club = 65;

  s_struck_body_sword = 70;
  s_struck_body_axe = 71;
  s_struck_body_longstick = 72;
  s_struck_body_fist = 73;

  s_struck_armor_sword = 80;
  s_struck_armor_axe = 81;
  s_struck_armor_longstick = 82;
  s_struck_armor_fist = 83;

  // s_powerup_man         = 80;
  // s_powerup_woman       = 81;
  // s_die_man             = 82;
  // s_die_woman           = 83;
  // s_struck_man          = 84;
  // s_struck_woman        = 85;
  // s_firehit             = 86;

  // s_struck_magic        = 90;
  s_strike_stone = 91;
  s_drop_stonepiece = 92;

  s_rock_door_open = 100;
  s_intro_theme = 102;
  s_meltstone = 101;
  s_main_theme = 102;
  s_norm_button_click = 103;
  s_rock_button_click = 104;
  s_glass_button_click = 105;
  s_money = 106;
  s_eat_drug = 107;
  s_click_drug = 108;
  s_spacemove_out = 109;
  s_spacemove_in = 110;

  s_click_weapon = 111;
  s_click_armor = 112;
  s_click_ring = 113;
  s_click_armring = 114;
  s_click_necklace = 115;
  s_click_helmet = 116;
  s_click_grobes = 117;
  s_itmclick = 118;

  s_yedo_man = 130;
  s_yedo_woman = 131;
  s_longhit = 132;
  s_widehit = 133;
  s_rush_l = 134;
  s_rush_r = 135;
  s_firehit_ready = 136;
  s_firehit = 137;

  s_man_struck = 138;
  s_wom_struck = 139;
  s_man_die = 144;
  s_wom_die = 145;

var
  g_SoundManager: TSoundManager;

implementation

uses
  ClMain, MShare, BASS;

{ TSoundManager }
function FindSoundFile(var FileName: String): Boolean;
var
  MP3FileName, OGGFileName, WavFileName: String;
begin
  Result := False;
  MP3FileName := ChangeFileExt(FileName, '.MP3');
  OGGFileName := ChangeFileExt(FileName, '.OGG');
  WavFileName := ChangeFileExt(FileName, '.WAV');
  if FileExists(OGGFileName) then
  begin
    FileName := OGGFileName;
    Result := True;
  end
  else if FileExists(MP3FileName) then
  begin
    FileName := MP3FileName;
    Result := True;
  end
  else if FileExists(WavFileName) then
  begin
    FileName := WavFileName;
    Result := True;
  end;
end;

function TSoundManager.ExtactSoundFileName(var S: String): Boolean;
var
  FileName: String;
begin
  Result := False;
  if S <> '' then
  begin
    if S[1] = '$' then
    begin
      Delete(S, 1, 1);
      if ExtractFileName(S) = S then
        S := 'Wav\' + S;
      S := ResourceDir + S;
    end
    else
    begin
      if ExtractFileName(S) = S then
        S := 'Wav\' + S;
      if FileExists(ResourceDir + S) then
        S := ResourceDir + S;
    end;

    if FindSoundFile(S) then
    begin
      Result := True;
    end
    else
    begin
      AddDownloadSoundFile(S);
    end;

    // if FileExists(S) then
    // Result := True
    // else
    // AddDownloadFile(S);
  end;
end;

procedure TSoundManager.AddDownLoadFile(const AFileName: String);
begin
  if Assigned(FAddDownLoadFile) then
    FAddDownLoadFile(AFileName, False);
end;

procedure TSoundManager.AddDownloadSoundFile(const AFileName: String);
begin
  if Assigned(FAddDownloadSoundFile) then
    FAddDownloadSoundFile(AFileName, False);
end;

constructor TSoundManager.Create;
begin
  FSoundList := TStringList.Create;
  FSkillSoundEffect := TStringList.Create;
  FSoundFiles := TFixedThreadList.Create;
  FSoundEngine := TSoundEngine.Create;
  FMapSound := nil;
  FPath := '';
  FSilenced := False;
  FBGSoundVolume := 1;
  FInnerThread := TSoundInnerThread.Create(Self);
end;

destructor TSoundManager.Destroy;
begin
  FTerminated := True;
  FInnerThread.Terminate;
  Stop;
  FreeAndNilEx(FSoundList);
  FreeAndNilEx(FSoundFiles);
  FreeAndNilEx(FSoundEngine);
  FreeAndNilEx(FSkillSoundEffect);
  inherited;
end;

procedure TSoundManager.DoMapMusicEnd(Sender: TObject);
begin
  if FMapSound = Sender then
    FreeAndNilEx(FMapSound);
  FMapMusicEndTick := GetTickCount;
end;

procedure TSoundManager._SoundEffectFile(const AFileName: String;
  Loop, Wait: Boolean);
var
  L: TList;
  I, ACount: integer;
  ASoundFile: TSoundFile;
begin
  L := FSoundFiles.LockList;
  try
    ACount := 0;
    for I := L.Count - 1 downto 0 do
    begin
      if SameText(TSoundFile(L[I]).FileName, AFileName) then
      begin
        if ACount > 3 then
        begin
          try
            TSoundFile(L[I]).Free;
            L.Delete(I);
          except
          end;
        end
        else if SameText(TSoundFile(L[I]).FileName, AFileName) then
          Inc(ACount);
      end;
    end;
    ASoundFile := TSoundFile.Create;
    ASoundFile.Loop := Loop;
    ASoundFile.Wait := Wait;
    ASoundFile.FileName := AFileName;
    L.Add(ASoundFile);
  finally
    FSoundFiles.UnlockList;
  end;
end;

procedure TSoundManager.DXPlaySound(idx: integer);
begin
  PlaySoundWithConfig(Idx,FSoundList);
end;

procedure TSoundManager.ItemClickSound(std: TStdItem);
begin
  case std.stdmode of
    0:
      begin
        if std.shape <> 3 then
          DXPlaySound(s_click_drug)
        else
          DXPlaySound(s_itmclick);
      end;
    5, 6:
      DXPlaySound(s_click_weapon);
    10, 11, 17, 18:
      DXPlaySound(s_click_armor);
    15:
      DXPlaySound(s_click_helmet);
    19, 20, 21:
      DXPlaySound(s_click_necklace);
    22, 23:
      DXPlaySound(s_click_ring);
    24, 26, 35:
      begin
        if (pos('手镯', std.Name) > 0) or (pos('手套', std.Name) > 0) then
          DXPlaySound(s_click_grobes)
        else
          DXPlaySound(s_click_armring);
      end;
    31:
      begin
        if (std.AniCount in [1 .. 3]) and (std.Source = 0) then
          DXPlaySound(s_click_drug)
        else
          DXPlaySound(s_itmclick);
      end;
  else
    DXPlaySound(s_itmclick);
  end;
end;

procedure TSoundManager.ItemUseSound(stdmode, shape: integer);
begin
  case stdmode of
    0:
      begin
        if shape = 3 then
          DXPlaySound(s_eat_drug)
        else
          DXPlaySound(s_click_drug);
      end;
    1, 2:
      DXPlaySound(s_eat_drug);
  end;
end;

procedure TSoundManager.PlayMapMusic(boFlag: Boolean);
var
  S: String;
begin
  if FMapSound <> nil then
  begin
    FMapSound.Stop;
    FreeAndNilEx(FMapSound);
  end;
  if not boFlag then
    Exit;
  FMapMusicEndTick := GetTickCount;
  if g_Config.Assistant.BGSound then
  begin
    if g_nMapMusic >= 0 then
    begin
      if g_nMapMusic < FSoundList.Count then
      begin
        if FSoundList[g_nMapMusic] <> '' then
        begin
          FMapSound := TSoundHandler.Create(FSoundList[g_nMapMusic],
            FBGSoundVolume);
          FMapSound.OnPlayEnd := DoMapMusicEnd;
          FMapSound.Silenced := FSilenced;
          FMapSound.Play;
        end;
      end;
    end
    else if g_sMapMusic <> '' then
    begin
      S := g_sMapMusic;
      if ExtactSoundFileName(S) then
      begin
        FMapSound := TSoundHandler.Create(S, FBGSoundVolume);
        FMapSound.OnPlayEnd := DoMapMusicEnd;
        FMapSound.Silenced := FSilenced;
        FMapSound.Play;
      end;
    end;
  end;
end;

procedure TSoundManager.LoadSkillSoundEffectList(const ASoundListFile: String);
begin
  LoadSoundListCommon(ASoundListFile,FSkillSoundEffect);
end;

procedure TSoundManager.LoadSoundList(const ASoundListFile: string);
begin
  LoadSoundListCommon(ASoundListFile,FSoundList);
end;

procedure TSoundManager.LoadSoundListCommon(const ASoundListFile: string;
  List: TStrings);
var
  I, J, K: integer;
  AList: TStringList;
  ALine, AIndexStr: string;
begin
  if FileExists(ASoundListFile) then
  begin
    AList := TStringList.Create;
    try
      AList.LoadFromFile(ASoundListFile);
      List.Clear;
      for I := 0 to AList.Count - 1 do
      begin
        ALine := AList[I];
        if ALine <> '' then
        begin
          if ALine[1] = ';' then
            continue;
          ALine := Trim(GetValidStr3(ALine, AIndexStr, [':', ' ', #9]));
          K := StrToIntDef(AIndexStr, 0);
          if K > List.Count - 1 then
          begin
            if K - List.Count > 0 then
              for J := 0 to K - List.Count - 1 do
                List.Add('');
            List.Add(FPath + ALine);
          end
          else
            List[K] := FPath + ALine;
        end;
      end;
    finally
      AList.Free;
    end;
  end
  else
  begin
    AddDownLoadFile(ASoundListFile);
  end;
end;

procedure TSoundManager.MyPlaySound(wavname: string);
begin
  if g_Config.Assistant.Sound then
  begin
    if wavname <> '' then
    begin
      if ExtactSoundFileName(wavname) then
        _SoundEffectFile(wavname, False, False);
    end;
  end;
end;

procedure TSoundManager.PHHitSound(WhatSound: integer);
var
  I: integer;
  TimerTick: integer;
begin
  case WhatSound of
    1:
      begin // 破魂合击声音
        for I := 0 to 8 do
        begin
          TimerTick := GetTickCount;
          repeat
            Application.HandleMessage;
          until GetTickCount - TimerTick > 20;
          DXPlaySound(57);
          DXPlaySound(122);
        end;
      end;
    2:
      begin // 劈星斩声音
        for I := 0 to 8 do
        begin
          TimerTick := GetTickCount;
          repeat
            Application.HandleMessage;
          until GetTickCount - TimerTick > 20;
          DXPlaySound(124);
          DXPlaySound(10512);
        end;
      end;
  end;
end;

procedure TSoundManager.PlayBGM(wavname: string);
begin
  SilenceSound;
  if g_Config.Assistant.BGSound and (wavname <> '') then
  begin
    if ExtactSoundFileName(wavname) then
      _SoundEffectFile(wavname, False, False);
  end;
end;

procedure TSoundManager.PlaySoundEx(const ASoundFile: String);
var
  ASoundIdx: integer;
  S: String;
begin
  if g_Config.Assistant.Sound and (ASoundFile <> '') then
  begin
    ASoundIdx := StrToIntDef(ASoundFile, -1);
    if ASoundIdx <> -1 then
    begin
      DXPlaySound(ASoundIdx);
    end
    else
    begin
      S := ASoundFile;
      if ExtactSoundFileName(S) then
        _SoundEffectFile(S, False, False)
    end;
  end;
end;

procedure TSoundManager.PlaySoundWithConfig(Idx: Integer; Config: TStrings);
var
  MP3FileName, OGGFileName, WavFileName: String;
begin
  if g_Config.Assistant.Sound then
  begin
    if (idx >= 0) and (idx < Config.Count) then
    begin
      if Config[idx] <> '' then
      begin
        MP3FileName := ChangeFileExt(Config[idx], '.MP3');
        OGGFileName := ChangeFileExt(Config[idx], '.OGG');
        WavFileName := ChangeFileExt(Config[idx], '.WAV');
        if FileExists(OGGFileName) then
          _SoundEffectFile(OGGFileName, False, False)
        else if FileExists(MP3FileName) then
          _SoundEffectFile(MP3FileName, False, False)
        else if FileExists(WavFileName) then
          _SoundEffectFile(WavFileName, False, False)
        else
          AddDownloadSoundFile(Config[idx]);
      end;
    end;
  end;
end;

procedure TSoundManager.Run;
var
  I: integer;
  L, List: TList;
begin
  if (g_MySelf <> nil) and (FMapSound = nil) and (g_nMapMusicLoop > 0) then
  begin
    if GetTickCount - FMapMusicEndTick > g_nMapMusicLoop then
      PlayMapMusic(True);
  end;
  FSoundEngine.Run;
  List := TList.Create;
  try
    L := FSoundFiles.LockList;
    try
      for I := 0 to L.Count - 1 do
        List.Add(L[I]);
      L.Clear;
    finally
      FSoundFiles.UnlockList;
    end;
    for I := 0 to List.Count - 1 do
    begin
      if FTerminated then
        Exit;
      try
        FSoundEngine.PlaySound(TSoundFile(List[I]).FileName,
          TSoundFile(List[I]).Loop);
        TObject(List[I]).Free;
      except
      end;
    end;
  finally
    List.Free;
  end;
end;

procedure TSoundManager.SetPath(const Value: String);
begin
  FPath := Value;
  if FPath = '\' then
    FPath := '';
  if FPath <> '' then
    FPath := IncludeTrailingPathDelimiter(FPath);
end;

procedure TSoundManager.SetSilenced(const Value: Boolean);
begin
  FSilenced := Value;
  FMapMusicSilenced := Value;
  FSoundEngine.SetSilenced(Value);
  if FMapSound <> nil then
    FMapSound.Silenced := Value;
end;

procedure TSoundManager.SetMapMusicSilenced(const Value: Boolean);
begin
  if FMapSound <> nil then
    FMapSound.Silenced := Value;
end;

procedure TSoundManager.SilenceSound;
begin
  FSoundEngine.Clear;
end;

procedure TSoundManager.SkillEffectPlaySound(idx: integer);
begin
  if idx < 1000000 then
  begin
    DXPlaySound(idx);
  end
  else
  begin
    PlaySoundWithConfig(idx,FSkillSoundEffect);
  end;
end;

procedure TSoundManager.Stop;
var
  I: integer;
  L: TList;
begin
  L := FSoundFiles.LockList;
  try
    for I := 0 to L.Count - 1 do
      TObject(L[I]).Free;
    L.Clear;
  finally
    FSoundFiles.UnlockList;
  end;
  FSoundEngine.Clear;
  if FMapSound <> nil then
    FreeAndNilEx(FMapSound);
end;

procedure TSoundManager.BGSoundStop;
begin
  if FMapSound <> nil then
    FreeAndNilEx(FMapSound);
end;

procedure TSoundManager.SoundStop;
begin
  FSoundEngine.Clear;
end;

procedure TSoundManager.SetBGSoundVolume(V: integer);
begin
  FBGSoundVolume := V / 100;
  if FMapSound <> nil then
    FMapSound.Volume := FBGSoundVolume;
end;

procedure TSoundManager.SetSoundVolume(V: integer);
begin
  FSoundEngine.SetVolume(V / 100);
end;

{ TSoundInnerThread }

constructor TSoundInnerThread.Create(AManager: TSoundManager);
begin
  FManager := AManager;
  inherited Create(False);
  FreeOnTerminate := True;
end;

procedure TSoundInnerThread.Execute;
begin
  while not Terminated do
  begin
    FManager.Run;
    Sleep(1);
  end;
end;

initialization

g_SoundManager := TSoundManager.Create;

finalization

FreeAndNil(g_SoundManager);

end.
