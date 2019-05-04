unit uAutoRun;

interface
  uses Windows, Classes, Actor, Grobal2,SkillInfo;

type
  TuAutoRunner = class
  private
    FDoSpellMagic: Boolean;
    FLastDir, FLastRunX, FLastRunY: Integer;
    FEnabled: Boolean;
    procedure SearchTarget;
    function SelectMagic(ADir, ARange: Integer; var AMagic: PTClientMagic): Boolean;
    procedure GotoTargetXY(X, Y: Integer);
    procedure AttackTarget;
    function CheckTargetXYCount(nX, nY, nRange: Integer): Integer;

    function CheckDoSpellMagic: Boolean;
    function StartAutoAvoid: Boolean;
    procedure AutoAvoid;

    procedure SearchPickUpItem;
  public
    procedure Reset;
    procedure Run;
    property Enabled: Boolean read FEnabled write FEnabled;
  end;

implementation
  uses ClMain, CLFunc, MShare, Share, PlayScn, uMagicMgr, uMagicTypes, magiceff, Math,uGameData;

function GetBackDir(nDir: Integer): Integer;
begin
  Result := 0;
  case nDir of
    DR_UP: Result := DR_DOWN;
    DR_DOWN: Result := DR_UP;
    DR_LEFT: Result := DR_RIGHT;
    DR_RIGHT: Result := DR_LEFT;
    DR_UPLEFT: Result := DR_DOWNRIGHT;
    DR_UPRIGHT: Result := DR_DOWNLEFT;
    DR_DOWNLEFT: Result := DR_UPRIGHT;
    DR_DOWNRIGHT: Result := DR_UPLEFT;
  end;
end;

{ TuAutoRunner }

procedure TuAutoRunner.Reset;
begin
  FLastRunX := -1;
  FLastRunY := -1;
  FLastDir := -1;
end;

procedure TuAutoRunner.Run;
var
  AActor: TActor;
  ANeedRun: Boolean;
  ADir, ATryCount: Integer;
begin
  if not FEnabled then
    Exit;
  if (g_MySelf = nil) or (g_MySelf.m_boDeath) then
    Exit;

  SearchPickUpItem;
  //if GetTickCount - g_dwLatestSpellTick > 1000 then
  FDoSpellMagic := CheckDoSpellMagic;
  if FDoSpellMagic and StartAutoAvoid then
    AutoAvoid;

  ANeedRun := True;
  if g_MySelf.m_btHorse = 0 then
  begin
    if (g_TargetCret = nil) or g_TargetCret.m_boDeath or g_TargetCret.m_boDelActor then
      SearchTarget;
    if g_TargetCret <> nil then
    begin
      AttackTarget;
      ANeedRun := False;
      FLastRunX := -1;
      FLastRunY := -1;
    end;
  end;
  if ANeedRun then
  begin
    if (g_nTargetX = -1) or (g_nTargetY = -1) then
    begin
      if (FLastRunX = -1) or (FLastRunY = -1) or (g_MySelf.m_nCurrX = FLastRunX) or (g_MySelf.m_nCurrY = FLastRunY) then
      begin
        ATryCount := 0;
        repeat
          ADir := Random(8);
          if ADir <> GetBackDir(FLastDir) then
          begin
            Map.GetNextPosition(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, ADir, 10, FLastRunX, FLastRunY);
            if Map.CanMove(FLastRunX, FLastRunY) then
            begin
              FLastDir := ADir;
              Break;
            end;
          end;
          Inc(ATryCount);
          if ATryCount > 3 then
          begin
            FLastRunX := -1;
            FLastRunY := -1;
            Exit;
          end;
        until False;
      end;
      GotoTargetXY(FLastRunX, FLastRunY);
    end;
  end;
end;

procedure TuAutoRunner.SearchTarget;
var
  I: Integer;
  AActor,
  ANear: TActor;
  AList: TList;
begin
  ANear := nil;
  g_TargetCret := nil;
  AList := PlayScene.m_ActorList.LockList;
  try
    for I := 0 to AList.count - 1 do
    begin
      AActor := AList.Items[i];
      if (AActor <> nil) and not AActor.m_boDeath and not AActor.m_boDelActor and
        not(AActor.Race in [0, 1, 12, 25, 26, 31{镖车}, 50{NPC}, 55{练功师}, 112{弓箭手}]) then
      begin
        if AActor.m_boFriendly then
          Continue;
        if (ANear = nil) or (ABS(ANear.m_nCurrX - g_MySelf.m_nCurrX) + ABS(ANear.m_nCurrY - g_MySelf.m_nCurrY) > ABS(AActor.m_nCurrX - g_MySelf.m_nCurrX) + ABS(AActor.m_nCurrY - g_MySelf.m_nCurrY)) then
        begin
          if Map.CanMove(AActor.m_nCurrX, AActor.m_nCurrY) then
            ANear := AActor;
        end;
      end;
    end;
    if ANear <> nil then
      g_TargetCret := ANear;
  finally
    PlayScene.m_ActorList.UnlockList;
  end;
end;

function TuAutoRunner.SelectMagic(ADir, ARange: Integer; var AMagic: PTClientMagic): Boolean;
var
  ABSingleMag,
  ABLMag,
  ABMuitlMag,
  M: PTClientMagic;
  I: Integer;
begin
  Result := False;
  AMagic := nil;
  ABLMag := nil;
  ABSingleMag := nil;
  ABMuitlMag := NIL;
  for I := 0 to g_MagicList.Count - 1 do
  begin
    M := g_MagicList[I];
    if (M <> nil) and ((ARange <= M.btMaxRange) or (M.btMaxRange = 0)) then
    begin
      if (g_MySelf.m_Abil.MP >= M.wSpell) and MShare.CanUseMagic(M) and (GetTickCount - M.UseTime >= M.dwDelayTime) then
      begin
        case M.nUseType of
          1{mutAttackSingle}:
          begin
            if ABSingleMag = nil then
              ABSingleMag := M
            else if M.btPriority > ABSingleMag.btPriority then
              ABSingleMag := M;
          end;
          2{mutAttackLine}:
          begin
            if ABLMag = nil then
              ABLMag := M
            else if M.btPriority > ABLMag.btPriority then
              ABLMag := M;
          end;
          3{mutAttackMulti}:
          begin
            if ABMuitlMag = nil then
              ABMuitlMag := M
            else if M.btPriority > ABMuitlMag.btPriority then
              ABMuitlMag := M;
          end;
        end;
      end;
    end;
  end;
  if (ABMuitlMag <> nil) and (CheckTargetXYCount(g_TargetCret.m_nCurrY, g_TargetCret.m_nCurrY, 4) > 0) then
  begin
    Result := True;
    AMagic := ABMuitlMag;
  end
  else if (ABLMag <> nil) and FrmMain.TargetInLineRange(ADir, ABLMag.btMaxRange) then
  begin
    Result := True;
    AMagic := ABLMag;
  end
  else
  begin
    Result := ABSingleMag <> nil;
    AMagic := ABSingleMag;
  end;
end;

procedure TuAutoRunner.GotoTargetXY(X, Y: Integer);
begin
  g_ChrAction := caRun;
  g_nTargetX := X;
  g_nTargetY := Y;
end;

procedure TuAutoRunner.AttackTarget;

  procedure __UseMagic(AMagID, AEffNumber: Integer);
  var
    ADir: Integer;
    AUseMag: PTUseMagicInfo;
    SX, SY, X, Y: Integer;
  begin
    PlayScene.ScreenXYfromMCXY(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, SX, SY);
    PlayScene.ScreenXYfromMCXY(g_TargetCret.m_nCurrX, g_TargetCret.m_nCurrY, X, Y);
    ADir := GetFlyDirection(SX, SY, X, Y);
    g_GameData.LastSpellTick.Data := GetTickCount;
    New(AUseMag);
    FillChar(AUseMag^, SizeOf(TUseMagicInfo), #0);
    AUseMag.EffectNumber := AEffNumber;
    AUseMag.nMagicId := AMagID;
    AUseMag.ServerMagicCode := 0;
    g_dwMagicDelayTime := 200;
    g_dwLatestMagicTick := GetTickCount;
    g_dwMagicPKDelayTime := 0;
    if g_MagicTarget <> nil then
    begin
      if (g_MagicTarget.Race = 0) or (g_MagicTarget.Race = 1) or (g_MagicTarget.Race = 150) then
        g_dwMagicPKDelayTime := 500;
    end;
    g_MySelf.SendMsg(CM_SPELL, g_TargetCret.m_nCurrX, g_TargetCret.m_nCurrY, ADir, Integer(AUseMag), g_TargetCret.m_nRecogId, 0, 0, '', 0);
  end;

  function IsWarrSkill(wMagIdx: Integer): Boolean;
  begin
    Result := wMagIdx in [SKILL_ATTACK, SKILL_ONESWORD, SKILL_ILKWANG, SKILL_YEDO, SKILL_ERGUM, SKILL_BANWOL, SKILL_FIRESWORD, SKILL_MOOTEBO, SKILL_40, SKILL_42, SKILL_43, SKILL_74];
  end;

var
  AMinRange, ADir, AHitMsg, AHitMagicID, AHitEff: Integer;
  AMagicType: Integer;
  AMagic: PTClientMagic;
  AClient: TuMagicClient;
  AFounded, ACanUseMag: Boolean;
begin
  if g_MySelf.m_btHorse > 0 then
    Exit;

  if FrmMain.CanNextAction and FrmMain.ServerAcceptNextAction  then
  begin
    ADir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_TargetCret.m_nCurrX, g_TargetCret.m_nCurrY);
    AMinRange := Max(Abs(g_MySelf.m_nCurrX - g_TargetCret.m_nCurrX), Abs(g_MySelf.m_nCurrY - g_TargetCret.m_nCurrY));
    AFounded := SelectMagic(ADir, AMinRange, AMagic);
    ACanUseMag := AFounded and CanUseMagic(AMagic);
    if (AMinRange <= 1) or ACanUseMag then
    begin
      if (AMagic <> nil) and g_MagicMgr.TryGet(AMagic.wMagicId, AClient) then
      begin
        case AClient.FireType of
          ftNone, ftAfterAttack, ftHitCallNext: ;
          ftHit: AddNextMagic(AMagic.wMagicId, 0);
          ftNextHit:
          begin
            if GetTickCount - g_GameData.LastSpellTick.Data > g_GameData.SpellTime.Data  then
            begin
              g_GameData.LastSpellTick.Data := GetTickCount;
              g_dwMagicDelayTime := 0;
              FrmMain.SendSpellMsg(CM_SPELL, g_MySelf.m_btDir , 0, AMagic.wMagicId, 0);
            end;
          end
          else if GetTickCount - g_GameData.LastSpellTick.Data > g_GameData.SpellTime.Data then
            __UseMagic(AMagic.wMagicId, AMagic.btEffect);
        end;
      end
      else if ((AMagic = nil) or IsWarrSkill(AMagic.wMagicId)) and FrmMain.CanNextHit then
      begin
        AHitMsg := CM_HIT;
        AHitMagicID := SKILL_ATTACK;
        AHitEff := 0;
        if AMagic <> nil then
        begin
          AHitMagicID := AMagic.wMagicId;
          AHitEff := MakeLong(AMagic.btEffectType, AMagic.btEffect);
        end;
        g_MySelf.SendMsg(AHitMsg, MakeLong(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY) , MakeLong(g_TargetCret.m_nCurrX, g_TargetCret.m_nCurrY), ADir, 0, AHitMagicID, 0, 0, '', 0, g_TargetCret.m_nRecogId, AHitEff);
        g_dwLatestHitTick := GetTickCount;
        g_GameData.LastHitTime.Data := GetTickCount;
      end
      else if (AMagic <> nil) and (GetTickCount - g_GameData.LastSpellTick.Data > g_GameData.SpellTime.Data) then
        __UseMagic(AMagic.wMagicId, AMagic.btEffect);
    end
    else
    begin
      g_ChrAction := caRun;
      GetBackPosition(g_TargetCret.m_nCurrX, g_TargetCret.m_nCurrY, ADir, g_nTargetX, g_nTargetY);
    end;
  end;
end;

function TuAutoRunner.CheckTargetXYCount(nX, nY, nRange: Integer): Integer;
var
  I: Integer;
  AActor: TActor;
  AList: TList;
begin
  Result := 0;
  AList := PlayScene.m_ActorList.LockList;
  try
    for I := AList.Count - 1 downto 0 do
    begin
      AActor := AList[I];
      if (AActor <> nil) and not AActor.m_boDeath and not AActor.m_boDelActor and not (AActor.Race in [0, 1, 12, 25, 26, 31{镖车}, 50{NPC}, 55{练功师}, 112{弓箭手}]) and not AActor.m_boFriendly then
      begin
        if (ABS(AActor.m_nCurrX - nX) <= nRange) and (ABS(AActor.m_nCurrY - nY) <= nRange) then
          Inc(Result);
      end;
    end;
  finally
    PlayScene.m_ActorList.UnlockList;
  end;
end;

function TuAutoRunner.CheckDoSpellMagic: Boolean;
var
  I: Integer;
  AMagic: PTClientMagic;
begin
  Result := False;
  if g_MySelf.m_Abil.MP = 0 then
  begin
    Result := False;
    Exit;
  end;
  if g_MySelf.m_btJob in [_JOB_WAR, _JOB_CIK] then
    Exit;

  for I := 0 to g_MagicList.Count - 1 do
  begin
    AMagic := g_MagicList[I];
    if (AMagic <> nil) and (AMagic.nUseType in [1{mutAttackSingle}, 2{mutAttackLine}, 3{mutAttackMulti}]) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function TuAutoRunner.StartAutoAvoid: Boolean;
begin
  Result := False;
  if ((g_MySelf.m_btJob in [_JOB_MAG, _JOB_DAO, _JOB_ARCHER]) or (g_MySelf.m_Abil.HP <= Round(g_MySelf.m_Abil.MaxHP * 0.25))) {and FDoSpellMagic }and (g_TargetCret <> nil) and not g_TargetCret.m_boDeath and not g_TargetCret.m_boDelActor then
  begin
    case g_MySelf.m_btJob of
      _JOB_MAG: Result := CheckTargetXYCount(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, 4) > 0;
      _JOB_DAO: Result := CheckTargetXYCount(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, 3) > 0;
      _JOB_ARCHER: Result := CheckTargetXYCount(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, 4) > 0;
    end;
  end;
end;

procedure TuAutoRunner.AutoAvoid;
var
  nDir, ANextTargetX, ANextTargetY: Integer;
begin
  nDir := GetNextDirection(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, g_TargetCret.m_nCurrX, g_TargetCret.m_nCurrY);
  nDir := GetBackDir(nDir);
  Map.GetNextPosition(g_TargetCret.m_nCurrX, g_TargetCret.m_nCurrY, nDir, 5, ANextTargetX, ANextTargetY);
  GotoTargetXY(ANextTargetX, ANextTargetY);
end;

procedure TuAutoRunner.SearchPickUpItem;
begin

end;

end.
