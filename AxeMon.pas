unit AxeMon;

interface

uses
  Windows, Classes, Graphics, CliUtil, ClFunc, magiceff, Actor, AbstractCanvas,
  AbstractTextures, DXHelper, ClEvent, uTextures, Grobal2, SysUtils, Math,
  uMagicMgr, uActionsMgr;

const
  DEATHEFFECTBASE     = 340; // ÷¼÷Ã¶´ÀïµÄ÷¼÷ÃËÀÍöÐ§¹û
  DEATHFIREEFFECTBASE = 2860; // µÀ²ÝÈËËÀÍöÐ§¹û
  AXEMONATTACKFRAME   = 6; // mon3ÖÐÖÀ¸«¿ÞÂ·520-525,,530-535,,540-545,,
  KUDEGIGASBASE       = 1445; // mon3ÖÐ¶´ÇùÅç¶¾Ö­Ð§¹û,,ÔÚ´«Ææ·þÎñÆ÷ÎÄ¼þÖÐ,kudegigas,,±í¶´Çù?
  COWMONFIREBASE      = 1800; // mon4ÖÐ»ðÑæÎÖÂê»ðÑæ¹¥»÷Ð§¹û,,,,´«Ææ·þÎñÆ÷µÄmonÖÐ,,cowmon ±í»ðÑæÎÖÂê»¹ÊÇËüËùÊôµÄÒ»¸ö´óÀà?
  // »ðÑæÎÖÂêÊôÓÚcowmon?
  COWMONLIGHTBASE    = 1900; // mon4ÖÐÎÖÂê½ÌÖ÷µÄÄ§·¨¹¥»÷Ð§¹û£¬light??µç¹â¹¥»÷??
  ZOMBILIGHTINGBASE  = 350; // mon5ÖÐµç½©Ê¬µÄ¼«¹â¹¥»÷Ð§¹û
  ZOMBIDIEBASE       = 340; // mon5ÖÐµç½©Ê¬ËÀÍöµÄ¹âÓ°Ð§¹û
  SCULPTUREFIREBASE  = 1680; // mon7ÖÐ×æÂê½ÌÖ÷ÊÖÖÐÄÇÍÅ»ðµÄ¹¥»÷Ð§¹û
  MOTHPOISONGASBASE  = 3590; // mon4ÖÐïÆ¶êÅç¶¾Ö­Ð§¹û,,ïÆ¶êÔÚ´«Ææ·þÎñ¶ËµÄÃû×Ö½Ð
  DUNGPOISONGASBASE  = 3590; // mon3ÖÐºçÄ§Ð«ÎÀ¹¥»÷Ð§¹û
  WARRIORELFFIREBASE = 820; // warrior elf fire mon18ÖÐÉñÊÞ´µ»ðµÄÄ§·¨¹¥»÷Ð§¹û
  SUPERIORGUARDBASE  = 760; // ´øµ¶»¤ÎÀ

type
  TSkeletonOma = class(TMonActor) // Size:25C   //¿ÞÂ·ºÍ°ëÊÞ×å
  protected
    EffectSurface: TAsphyreLockableTexture; // 0x240
    ax: Integer; // 0x244
    ay: Integer; // 0x248
  public
    constructor Create; override;
    procedure CalcActorFrame; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
    procedure LoadSurface; override;
    procedure Run; override;
    procedure DrawChr(dsurface: TAsphyreCanvas; dx, dy: Integer; blend: Boolean; boFlag: Boolean); override;
  end;

  TDualAxeOma = class(TSkeletonOma) // µµ³¢´øÁö´Â ¸÷ //Ë«¸«¹Ö£¬£¬ÖÀ¸«¿ÞÂ·??
  private
  public
    procedure Run; override;
    destructor Destroy; override;
  end;

  TCatMon = class(TSkeletonOma);
  TScorpionMon = class(TCatMon); // Ð«×Ó¹ÖÎï

  TArcherMon = class(TCatMon)
  public
    procedure Run; override;
  end;

  THuSuABi = class(TSkeletonOma)
  public
    procedure LoadSurface; override;
  end;

  TZombiDigOut = class(TSkeletonOma) // Ê¯Ä¹Ê¬ÍõÅÀ³öÀ´  ,,´ÓtskeletonomaÅÉÉú,,Ê¯Ä¹Ê¬Íõ(½©Ê¬ZombiÀàµÄÒ»ÖÖ)Ò²ÊôÓÚ°ëÊÞ¿ÞÂ·×å?
  public
    procedure RunFrameAction(frame: Integer); override;
  end;

  TZombiZilkin = class(TSkeletonOma);

  TWhiteSkeleton = class(TSkeletonOma); // °×É«¿ÞÂ·??

  TGasKuDeGi = class(TMonActor) // Size 0x274
  protected
    AttackEffectSurface: TAsphyreLockableTexture; // 0x250
    DieEffectSurface: TAsphyreLockableTexture; // 0x254
    m_LightSurface: TAsphyreLockableTexture; // ÔÂÁé±íÃæ²ã¹â 20080722
    BoUseDieEffect: Boolean; // 0x258
    firedir: Integer; // 0x25C
    fire16dir: Integer; // 0c260
    m_nLightX: Integer;
    m_nLightY: Integer;
    ax: Integer; // 0x264
    ay: Integer; // 0x268
    bx: Integer;
    by: Integer;
  public
    constructor Create; override;
    procedure CalcActorFrame; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
    procedure LoadSurface; override;
    procedure Run; override;
    procedure DrawChr(dsurface: TAsphyreCanvas; dx, dy: Integer; blend: Boolean; boFlag: Boolean); override;
    procedure DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer); override;
  end;

  TFireCowFaceMon = class(TGasKuDeGi)
  public
    function Light: Integer; override;
  end;

  TCowFaceKing = class(TGasKuDeGi)
  public
    function Light: Integer; override;
  end;

  TZombiLighting = class(TGasKuDeGi);

  TFairyMonster = class(TGasKuDeGi); // ÔÂÁé

  TheCrutchesSpider = class(TGasKuDeGi) // ½ðÕÈÖ©Öë
  public
    procedure Run; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
  end;

  TYanLeiWangSpider = class(TGasKuDeGi) // À×Ñ×ÖëÍõ
  protected
  public
    procedure CalcActorFrame; override;
    procedure Run; override;
  end;

  TSnowy = class(TGasKuDeGi) // Ñ©Óòº®±ùÄ§¡¢Ñ©ÓòÃðÌìÄ§¡¢Ñ©ÓòÎå¶¾Ä§
  protected
  public
    procedure Run; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
  end;

  TSuperiorGuard = class(TGasKuDeGi);

  TSwordsmanMon = class(TGasKuDeGi); // Áé»êÊÕ¸îÕß,À¶Ó°µ¶¿Ís

  TExplosionSpider = class(TGasKuDeGi)
  protected
  public
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    destructor Destroy; override;
  end;

  TFlyingSpider = class(TSkeletonOma) // Size: 0x25C Address: 0x00461F38
  protected
  public
    procedure CalcActorFrame; override;
    destructor Destroy; override;
  end;

  TSculptureMon = class(TSkeletonOma) // µñÏñÀà¹ÖÎï?
  private
    AttackEffectSurface: TAsphyreLockableTexture;
    ax, ay, firedir: Integer;
  public
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
    procedure DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer); override;
    procedure Run; override;
  end;

  TSculptureKingMon = class(TSculptureMon); // ×æÂê½ÌÖ÷

  TRedThunderZuma = class(TGasKuDeGi)
    boCasted: Boolean;
  public
    procedure CalcActorFrame; override;
    constructor Create; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
    procedure LoadSurface; override;
  end;

  TSmallElfMonster = class(TSkeletonOma); // elf,,Ð¡¾«Áé£¬£¬°«ÈË, ÌÔÆø¹í, ¶ñ×÷¾çµÄÈË£¬£¬

  TWarriorElfMonster = class(TSkeletonOma) // warrior,,ÓÂÊ¿ ,,,ÓÂÊ¿¾«Áé=ÉñÊÞ(¿´À´´Ó×ÖÃæÉÏÕæÄÑÀí½â,±ØÐë¿¿ÍæCQµÄÊµ¼ù+¶ÁÏÂÃæ¾ßÌåµÄÔ´³ÌÐòÀ´²Â½âËüµÄÒâË¼)
  private
    oldframe: Integer;
  public
    procedure RunFrameAction(frame: Integer); override;
    destructor Destroy; override;
  end;

  // ´óòÚò¼
  TElectronicScolpionMon = class(TGasKuDeGi) // Size 0x274 0x3c
  protected
  public
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    destructor Destroy; override;
  end;

  TBossPigMon = class(TGasKuDeGi) // 0x3d
  protected
  public
    procedure LoadSurface; override;
    destructor Destroy; override;
  end;

  TKingOfSculpureKingMon = class(TGasKuDeGi) // 0x3e
  protected
  public
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    destructor Destroy; override;
  end;

  TSkeletonKingMon = class(TGasKuDeGi) // 0x3f
  protected
  public
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure Run; override;
    destructor Destroy; override;
  end;

  TSamuraiMon = class(TGasKuDeGi);

  TSkeletonSoldierMon = class(TGasKuDeGi);

  TSkeletonArcherMon = class(TArcherMon) // Size: 0x26C Address: 0x004623B4 //0x45
    AttackEffectSurface: TAsphyreLockableTexture; // 0x25C
    bo260: Boolean;
    n264: Integer;
    n268: Integer;
  protected
  public
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure Run; override;
    procedure DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer); override;
    destructor Destroy; override;
  end;

  TBanyaGuardMon = class(TSkeletonArcherMon) // Size: 0x270 Address: 0x00462430 0x46 0x47 0x48 0x4e
    n26C: TAsphyreLockableTexture;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure Run; override;
    procedure DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer); override;
  end;

  TStoneMonster = class(TSkeletonArcherMon) // Size: 0x270 0x4d 0x4b
    n26C: TAsphyreLockableTexture;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure Run; override;
    procedure DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer); override;
  end;

  TPBOMA1Mon = class(TCatMon) // 0x49
  protected
  public
    destructor Destroy; override;
    procedure Run; override;
  end;

  TPBOMA6Mon = class(TCatMon) // 0x4f
  public
    procedure Run; override;
  end;

  TAngel = class(TBanyaGuardMon) // Size: 0x27C 0x51
    n270: Integer;
    n274: Integer;
    n278: TAsphyreLockableTexture;
  public
    procedure LoadSurface; override;
    procedure DrawChr(dsurface: TAsphyreCanvas; dx, dy: Integer; blend: Boolean; boFlag: Boolean); override;
  end;

  TFireDragon = class(TSkeletonArcherMon) // 0x53
    n270: TAsphyreLockableTexture;
  private
    procedure AttackEff;
  protected
    firedir: Byte;
  public
    constructor Create; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure Run; override;
    procedure DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer); override;
  end;

  TDragonStatue = class(TSkeletonArcherMon)
  public
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure Run; override;
    procedure DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer); override;
  end;

  TMaterialMonster = class(TMonActor)
  public
    procedure DrawBlood(dsurface: TAsphyreCanvas); override;
  end;

  //±¦Ïä¹ÖÎï
  TBoxSpider = class(TMaterialMonster)
  protected
    EffectSurface: TAsphyreLockableTexture;
    procedure CalcActorFrame; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
  public
    constructor Create; override;
    procedure LoadSurface; override;
    procedure Run(); override;
    procedure DrawChr(dsurface: TAsphyreCanvas; dx, dy: integer; blend: Boolean; boFlag: Boolean); override;
  end;

  //Ò©²Ý¹ÖÎï
  TGrassSpider = class(TMaterialMonster)
  protected
    procedure CalcActorFrame; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
  public
    procedure LoadSurface; override;
    procedure Run; override;
  end;

implementation

uses
  ClMain, SoundUtil, WIL, MShare;

{ ============================== TSkeletonOma ============================= }

// ÇØ°ñ ¿À¸¶(ÇØ°ñ, Å«µµ³¢ÇØ°ñ, ÇØ°ñÀü»ç)

{ -------------------------- }

constructor TSkeletonOma.Create;
begin
  inherited Create;
  EffectSurface := nil;
  m_boUseEffect := FALSE;
end;

{ destructor TSkeletonOma.Destroy;
  begin
  inherited;
  end; }

procedure TSkeletonOma.CalcActorFrame;
var
  pm: PTMonsterAction;
  AEffects: TuCustomMagicEffectProperties;
begin
  m_nCurrentFrame := -1;
  m_boReverseFrame := FALSE;
  m_boUseEffect := FALSE;

  m_nBodyOffset := GetOffset(m_wAppearance);
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    exit;

  case m_nCurrentAction of
    SM_TURN:
      begin
        m_nStartFrame := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
        m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
        m_dwFrameTime := pm.ActStand.ftime;
        m_dwStartTime := GetTickCount;
        m_nDefFrameCount := pm.ActStand.frame;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_WALK, SM_BACKSTEP, SM_BATTERBACKSTEP:
      begin
        m_nStartFrame := pm.ActWalk.start + m_btDir * (pm.ActWalk.frame + pm.ActWalk.skip);
        m_nEndFrame := m_nStartFrame + pm.ActWalk.frame - 1;
        m_dwFrameTime := pm.ActWalk.ftime;
        m_dwStartTime := GetTickCount;
        m_nCurTick := 0;
        // WarMode := FALSE;
        m_nMoveStep := 1;
        if m_nCurrentAction = SM_BATTERBACKSTEP then
        begin
          m_nMoveStep := m_nBatterMoveStep;
          m_nCurrX := m_nBatterX;
          m_nCurrY := m_nBatterY;
        end;
        if m_nCurrentAction = SM_WALK then
          Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1)
        else // sm_backstep
          Shift(GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    SM_DIGUP: // °È±â ¾øÀ½, SM_DIGUP, ¹æÇâ ¾øÀ½.
      begin
        if (m_btRace = 23) then
        begin // or (m_btRace = 54) or (m_btRace = 55) then begin
          // ¹é°ñ
          m_nStartFrame := pm.ActDeath.start;
        end
        else
        begin
          m_nStartFrame := pm.ActDeath.start + m_btDir * (pm.ActDeath.frame + pm.ActDeath.skip);
        end;
        m_nEndFrame := m_nStartFrame + pm.ActDeath.frame - 1;
        m_dwFrameTime := pm.ActDeath.ftime;
        m_dwStartTime := GetTickCount;
        // WarMode := FALSE;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_DIGDOWN:
      begin
        if m_btRace = 55 then
        begin
          // ½Å¼ö1 ÀÎ °æ¿ì ¿ªº¯½Å
          m_nStartFrame := pm.ActCritical.start + m_btDir * (pm.ActCritical.frame + pm.ActCritical.skip);
          m_nEndFrame := m_nStartFrame + pm.ActCritical.frame - 1;
          m_dwFrameTime := pm.ActCritical.ftime;
          m_dwStartTime := GetTickCount;
          m_boReverseFrame := TRUE;
          // WarMode := FALSE;
          Shift(m_btDir, 0, 0, 1);
        end;
      end;
    SM_SPELL: // ½ÓÊÕÊ¹ÓÃÄ§·¨ÏûÏ¢
      begin
        CalcActorSpellHitFrame(pm);
      end;
    SM_HIT, SM_FLYAXE, SM_LIGHTING:
      begin
        m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
        m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
        m_dwFrameTime := pm.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        // WarMode := TRUE;
        m_dwWarModeTime := GetTickCount;
        if (m_btRace = 16) or (m_btRace = 54) then
          m_boUseEffect := TRUE;
        Shift(m_btDir, 0, 0, 1);

        m_nEffectFrame := m_nStartFrame;
        m_nEffectStart := m_nStartFrame;

      end;
    SM_STRUCK:
      begin
        m_nStartFrame := pm.ActStruck.start + m_btDir * (pm.ActStruck.frame + pm.ActStruck.skip);
        m_nEndFrame := m_nStartFrame + pm.ActStruck.frame - 1;
        m_dwFrameTime := m_dwStruckFrameTime; // pm.ActStruck.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_DEATH:
      begin
        m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
        m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
        m_nStartFrame := m_nEndFrame; //
        m_dwFrameTime := pm.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_NOWDEATH:
      begin
        m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
        m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
        m_dwFrameTime := pm.ActDie.ftime;
        m_dwStartTime := GetTickCount;
        if m_btRace <> 22 then
          m_boUseEffect := TRUE;
      end;
    SM_SKELETON:
      begin
        m_nStartFrame := pm.ActDeath.start;
        m_nEndFrame := m_nStartFrame + pm.ActDeath.frame - 1;
        m_dwFrameTime := pm.ActDeath.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_ALIVE:
      begin
        m_nStartFrame := pm.ActDeath.start + m_btDir * (pm.ActDeath.frame + pm.ActDeath.skip);
        m_nEndFrame := m_nStartFrame + pm.ActDeath.frame - 1;
        m_dwFrameTime := pm.ActDeath.ftime;
        m_dwStartTime := GetTickCount;
      end;
  end;
end;

function TSkeletonOma.GetDefaultFrame(wmode: Boolean): Integer;
var
  cf: Integer;
  pm: PTMonsterAction;
begin
  Result := 0; // jacky
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    exit;

  if m_boDeath then
  begin
    // ¿ì¸é±ÍÀÏ °æ¿ì
    if m_wAppearance in [30 .. 34, 151] then // ¿ì¸é±ÍÀÎ °æ¿ì ½ÃÃ¼°¡ »ç¶÷À» µ¤´Â °ÍÀ» ¸·±â À§ÇØ
      m_nDownDrawLevel := 1;

    if m_boSkeleton then
      Result := pm.ActDeath.start
    else
      Result := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip) + (pm.ActDie.frame - 1);
  end
  else
  begin
    m_nDefFrameCount := pm.ActStand.frame;
    if m_nCurrentDefFrame < 0 then
      cf := 0
    else if m_nCurrentDefFrame >= pm.ActStand.frame then
      cf := 0
    else
      cf := m_nCurrentDefFrame;
    Result := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip) + cf;
  end;
end;

procedure TSkeletonOma.LoadSurface;
begin
  inherited LoadSurface;
  case m_btRace of
    // ¸ó½ºÅÍ
    14, 15, 17, 22, 53:
      begin
        if m_boUseEffect then
          EffectSurface := { FrmMain.WMon3Img20080720×¢ÊÍ } g_WMonImagesArr[2].GetCachedImage(DEATHEFFECTBASE + m_nCurrentFrame - m_nStartFrame, ax, ay);
      end;
    23:
      begin
        if m_nCurrentAction = SM_DIGUP then
        begin
          m_BodySurface := nil;
          EffectSurface := { FrmMain.WMon4Img20080720×¢ÊÍ } g_WMonImagesArr[3].GetCachedImage(m_nBodyOffset + m_nCurrentFrame, ax, ay);
          m_boUseEffect := TRUE;
        end
        else
          m_boUseEffect := FALSE;
      end;
  end;
end;

procedure TSkeletonOma.Run;
var
  prv: Integer;
  m_dwFrameTimetime: longword;
begin
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_BATTERBACKSTEP) or (m_nCurrentAction = SM_RUN)
   or (m_nCurrentAction = SM_HORSERUN) then
    exit;

  m_boMsgMuch := FALSE;
  if MsgCount >= 2 then
    m_boMsgMuch := TRUE;

  // »ç¿îµå È¿°ú
  RunActSound(m_nCurrentFrame - m_nStartFrame);
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then
  begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if m_boMsgMuch then
      m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
    else
      m_dwFrameTimetime := m_dwFrameTime;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then
    begin
      if m_nCurrentFrame < m_nEndFrame then
      begin
        Inc(m_nCurrentFrame);
        m_dwStartTime := GetTickCount;
      end
      else
      begin
        // µ¿ÀÛÀÌ ³¡³².
        m_nCurrentAction := 0; // µ¿ÀÛ ¿Ï·á
        m_boUseEffect := FALSE;
      end;
    end;
    Inc(m_nMagicFrame);
    m_nCurrentDefFrame := 0;
    m_dwDefFrameTime := GetTickCount;
    CreateMagicObject;
  end
  else
    DefaultFrameRun;

  if prv <> m_nCurrentFrame then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  m_BodyEffect.Run;
end;

procedure TSkeletonOma.DrawChr(dsurface: TAsphyreCanvas; dx, dy: Integer; blend: Boolean; boFlag: Boolean);
var
  ceff: TColorEffect;
begin
  // if not (m_btDir in [0..7]) then exit;
  if m_btDir > 7 then
    exit;

  if GetTickCount - m_dwLoadSurfaceTime > (FREE_TEXTURE_TIME div 2) then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface; // bodysurfaceµîÀÌ loadsurface¸¦ ´Ù½Ã ºÎ¸£Áö ¾Ê¾Æ ¸Þ¸ð¸®°¡ ÇÁ¸®µÇ´Â °ÍÀ» ¸·À½
  end;

  DrawMyShow(dsurface, dx, dy); // ÏÔÊ¾×ÔÉí¶¯»­
  if m_ShadowBodySurface <> nil then
    dsurface.DrawBlend(dx + m_nSdPx + m_nShiftX, dy + m_nSdPy + m_nShiftY, m_ShadowBodySurface, 0);
  if m_BodySurface <> nil then
  begin
    ceff := GetDrawEffectValue;
    DrawBodySurface(dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, blend, ceff);
  end;

  if m_boUseEffect then
    // È¾ºÚ
    if EffectSurface <> nil then
    begin
      dsurface.DrawBlend(dx + ax + m_nShiftX, dy + ay + m_nShiftY, EffectSurface, 1);
    end;
  DrawMyShow(dsurface, dx, dy);
  m_BodyEffect.DrawEffect(DSurface, dx + m_nShiftX, dy + m_nShiftY);
  DrawMagicEffect(dsurface, dx, dy);
end;

{ ============================== TSkeletonOma ============================= }

// ÇØ°ñ ¿À¸¶(ÇØ°ñ, Å«µµ³¢ÇØ°ñ, ÇØ°ñÀü»ç)

{ -------------------------- }

destructor TDualAxeOma.Destroy;
begin
  inherited;
end;

procedure TDualAxeOma.Run;
var
  prv: Integer;
  m_dwFrameTimetime: longword;
  meff: TFlyingAxe;
begin
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_BATTERBACKSTEP) or (m_nCurrentAction = SM_RUN)
  or (m_nCurrentAction = SM_HORSERUN) then
    exit;

  m_boMsgMuch := FALSE;
  if MsgCount >= 2 then
    m_boMsgMuch := TRUE;

  // »ç¿îµå È¿°ú
  RunActSound(m_nCurrentFrame - m_nStartFrame);
  // ÇÁ·¡ÀÓ¸¶´Ù ÇØ¾ß ÇÒÀÏ
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then
  begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if m_boMsgMuch then
      m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
    else
      m_dwFrameTimetime := m_dwFrameTime;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then
    begin
      if m_nCurrentFrame < m_nEndFrame then
      begin
        Inc(m_nCurrentFrame);
        m_dwStartTime := GetTickCount;
      end
      else
      begin
        // µ¿ÀÛÀÌ ³¡³².
        m_nCurrentAction := 0; // µ¿ÀÛ ¿Ï·á
        m_boUseEffect := FALSE;
      end;
      if (m_nCurrentAction = SM_FLYAXE) and (m_nCurrentFrame - m_nStartFrame = AXEMONATTACKFRAME - 4) then
      begin
        // ¸¶¹ý ¹ß»ç
        meff := TFlyingAxe(PlayScene.NewFlyObject(self, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mtFlyAxe));
        if meff <> nil then
        begin
          meff.ImgLib := { FrmMain.WMon3Img20080720×¢ÊÍ } g_WMonImagesArr[2];
          case m_btRace of
            15:
              meff.FlyImageBase := FLYOMAAXEBASE;
            22:
              meff.FlyImageBase := THORNBASE;
          end;
        end;
      end;
    end;
    m_nCurrentDefFrame := 0;
    m_dwDefFrameTime := GetTickCount;
    Inc(m_nMagicFrame);
    CreateMagicObject;
  end
  else
    DefaultFrameRun;

  if prv <> m_nCurrentFrame then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  m_BodyEffect.Run;
end;

{ ============================== TGasKuDeGi ============================= }

destructor TWarriorElfMonster.Destroy;
begin
  inherited;
end;

procedure TWarriorElfMonster.RunFrameAction(frame: Integer);
var
  meff: TMapEffect;
begin
  if m_nCurrentAction = SM_HIT then
  begin
    if (frame = 5) and (oldframe <> frame) then
    begin
      meff := TMapEffect.Create(WARRIORELFFIREBASE + 10 * m_btDir + 1, 5, m_nCurrX, m_nCurrY);
      meff.ImgLib := g_WMonImagesArr[17];
      meff.NextFrameTime := 100;
      PlayScene.m_EffectList.Add(meff);
    end;
    oldframe := frame;
  end;
end;

procedure TArcherMon.Run;
var
  prv: Integer;
  m_dwFrameTimetime: longword;
  meff: TFlyingAxe;
begin
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_BATTERBACKSTEP) or (m_nCurrentAction = SM_RUN)
  or (m_nCurrentAction = SM_HORSERUN) then
    exit;

  m_boMsgMuch := FALSE;
  if MsgCount >= 2 then
    m_boMsgMuch := TRUE;

  RunActSound(m_nCurrentFrame - m_nStartFrame);
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then
  begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if m_boMsgMuch then
      m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
    else
      m_dwFrameTimetime := m_dwFrameTime;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then
    begin
      if m_nCurrentFrame < m_nEndFrame then
      begin
        Inc(m_nCurrentFrame);
        m_dwStartTime := GetTickCount;
      end
      else
      begin
        m_nCurrentAction := 0;
        m_boUseEffect := FALSE;
      end;
      if (m_nCurrentAction = SM_FLYAXE) and (m_nCurrentFrame - m_nStartFrame = 4) then
      begin
        meff := TFlyingArrow(PlayScene.NewFlyObject(self, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mtFlyArrow));
        if meff <> nil then
        begin
          meff.ImgLib := g_WEffectImages;
          meff.NextFrameTime := 30;
          meff.FlyImageBase := ARCHERBASE2;
        end;
      end;
    end;
    m_nCurrentDefFrame := 0;
    m_dwDefFrameTime := GetTickCount;
    Inc(m_nMagicFrame);
    CreateMagicObject;
  end
  else
    DefaultFrameRun;

  if prv <> m_nCurrentFrame then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  m_BodyEffect.Run;
end;

{ ============================= TZombiDigOut ============================= }

procedure TZombiDigOut.RunFrameAction(frame: Integer);
var
  ClEvent: TClEvent;
begin
  if m_nCurrentAction = SM_DIGUP then
  begin
    if frame = 6 then
    begin
      ClEvent := TClEvent.Create(m_nCurrentEvent, m_nCurrX, m_nCurrY, ET_DIGOUTZOMBI);
      ClEvent.m_nDir := m_btDir;
      EventMan.AddEvent(ClEvent);
      // pdo.DSurface := FrmMain.WMon6Img.GetCachedImage (ZOMBIDIGUPDUSTBASE+Dir, pdo.px, pdo.py);
    end;
  end;
end;

{ ============================== THuSuABi ============================= }

// Çã¼ö¾Æºñ

{ -------------------------- }

procedure THuSuABi.LoadSurface;
begin
  inherited LoadSurface;
  if m_boUseEffect then
    EffectSurface := g_WMonImagesArr[2].GetCachedImage(DEATHFIREEFFECTBASE + m_nCurrentFrame - m_nStartFrame, ax, ay);
end;

{ ============================== TGasKuDeGi ============================= }

// ´ëÇü±¸µ¥±â (°¡½º½î´Â ±¸µ¥±â)

{ -------------------------- }

constructor TGasKuDeGi.Create;
begin
  inherited Create;
  AttackEffectSurface := nil;
  DieEffectSurface := nil;
  m_boUseEffect := FALSE;
  BoUseDieEffect := FALSE;
end;

procedure TGasKuDeGi.CalcActorFrame;
var
  pm: PTMonsterAction;
  Actor: TActor;
  scx, scy, stx, sty: Integer;
begin
  m_nCurrentFrame := -1;

  m_nBodyOffset := GetOffset(m_wAppearance);
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    exit;

  case m_nCurrentAction of
    SM_TURN:
      begin
        m_nStartFrame := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
        m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
        m_dwFrameTime := pm.ActStand.ftime;
        m_dwStartTime := GetTickCount;
        m_nDefFrameCount := pm.ActStand.frame;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_WALK:
      begin
        m_nStartFrame := pm.ActWalk.start + m_btDir * (pm.ActWalk.frame + pm.ActWalk.skip);
        m_nEndFrame := m_nStartFrame + pm.ActWalk.frame - 1;
        m_dwFrameTime := pm.ActWalk.ftime;
        m_dwStartTime := GetTickCount;
        m_nCurTick := 0;
        // WarMode := FALSE;
        m_nMoveStep := 1;
        if m_nCurrentAction = SM_WALK then
          Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1)
        else // sm_backstep
          Shift(GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    SM_FAIRYATTACKRATE:
      begin // ÔÂÁéÖØ»÷
        m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
        m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
        m_dwFrameTime := pm.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        m_boUseEffect := TRUE;
        m_nEffectFrame := m_nStartFrame;
        m_nEffectStart := m_nStartFrame;
        m_nEffectEnd := m_nEndFrame;
        m_dwEffectStartTime := GetTickCount;
        m_dwEffectFrameTime := m_dwFrameTime;
        Shift(m_btDir, 0, 0, 1);

        m_nMagicStartSound := 11010;
        m_nMagicExplosionSound := 11012;

        g_SoundManager.DXPlaySound(m_nMagicStartSound);
      end;
    SM_HIT, SM_LIGHTING:
      begin
        m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
        m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
        m_dwFrameTime := pm.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        // WarMode := TRUE;
        // m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
        if m_btRace <> 96 then
          m_boUseEffect := TRUE;
        firedir := m_btDir;
        m_nEffectFrame := m_nStartFrame;
        m_nEffectStart := m_nStartFrame;
        if m_btRace = 20 then
          m_nEffectEnd := m_nEndFrame + 1
        else
          m_nEffectEnd := m_nEndFrame;
        m_dwEffectStartTime := GetTickCount;
        m_dwEffectFrameTime := m_dwFrameTime;

        // 16¹æÇâÀÎ ¸¶¹ý ¼³Á¤
        Actor := PlayScene.FindActor(m_nTargetRecog);
        if Actor <> nil then
        begin
          PlayScene.ScreenXYfromMCXY(m_nCurrX, m_nCurrY, scx, scy);
          PlayScene.ScreenXYfromMCXY(Actor.m_nCurrX, Actor.m_nCurrY, stx, sty);
          fire16dir := GetFlyDirection16(scx, scy, stx, sty);
        end
        else
          fire16dir := firedir * 2;

        if (m_btRace = 100) then
        begin // ÔÂÁé¹¥»÷ÉùÒô 20080405
          m_nMagicStartSound := 11000;
          m_nMagicExplosionSound := 11002;
          g_SoundManager.DXPlaySound(m_nMagicStartSound);
        end;

      end;
    SM_STRUCK:
      begin
        m_nStartFrame := pm.ActStruck.start + m_btDir * (pm.ActStruck.frame + pm.ActStruck.skip);
        m_nEndFrame := m_nStartFrame + pm.ActStruck.frame - 1;
        m_dwFrameTime := m_dwStruckFrameTime; // pm.ActStruck.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_DEATH:
      begin
        m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
        m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
        m_nStartFrame := m_nEndFrame; //
        m_dwFrameTime := pm.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_NOWDEATH:
      begin
        m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
        m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
        m_dwFrameTime := pm.ActDie.ftime;
        m_dwStartTime := GetTickCount;

        if (m_btRace = 40) or (m_btRace = 65) or (m_btRace = 66) or (m_btRace = 67) or (m_btRace = 68) or (m_btRace = 69) or (m_btRace = 100) then
          BoUseDieEffect := TRUE;
      end;
    SM_SKELETON:
      begin
        m_nStartFrame := pm.ActDeath.start;
        m_nEndFrame := m_nStartFrame + pm.ActDeath.frame - 1;
        m_dwFrameTime := pm.ActDeath.ftime;
        m_dwStartTime := GetTickCount;
      end;
  end;
end;

function TGasKuDeGi.GetDefaultFrame(wmode: Boolean): Integer;
var
  cf: Integer;
  pm: PTMonsterAction;
begin
  Result := 0; // jacky
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    exit;

  if m_boDeath then
  begin
    if m_boSkeleton then
      Result := pm.ActDeath.start
    else
      Result := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip) + (pm.ActDie.frame - 1);
  end
  else
  begin
    m_nDefFrameCount := pm.ActStand.frame;
    if m_nCurrentDefFrame < 0 then
      cf := 0
    else if m_nCurrentDefFrame >= pm.ActStand.frame then
      cf := 0
    else
      cf := m_nCurrentDefFrame;
    Result := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip) + cf;
  end;
end;

procedure TGasKuDeGi.LoadSurface;
begin
  inherited LoadSurface;
  case m_btRace of
    // ¹¥»÷Ð§¹û
    16: // ¶´Çù
      begin
        if m_boUseEffect then
          AttackEffectSurface := { FrmMain.WMon3Img20080720×¢ÊÍ } g_WMonImagesArr[2].GetCachedImage(KUDEGIGASBASE - 1 + (firedir * 10) + m_nEffectFrame -
            m_nEffectStart, // °¡½º´Â Ã³À½ ÇÑÇÁ·¹À½ ´Ê°Ô ½ÃÀÛÇÔ.
            ax, ay);
      end;
    20: // »ðÑæÎÖÂê
      begin
        if m_boUseEffect then
          AttackEffectSurface := g_WMonImagesArr[3].GetCachedImage(COWMONFIREBASE + (firedir * 10) + m_nEffectFrame - m_nEffectStart, //
            ax, ay);
      end;
    21: // ÎÖÂê½ÌÖ÷
      begin
        if m_boUseEffect then
          AttackEffectSurface := { FrmMain.WMon4Img20080720×¢ÊÍ } g_WMonImagesArr[3].GetCachedImage(COWMONLIGHTBASE + (firedir * 10) + m_nEffectFrame -
            m_nEffectStart, //
            ax, ay);
      end;
    24: // ´øµ¶»¤ÎÀ
      begin
        if m_boUseEffect then
          AttackEffectSurface := { FrmMain.WMonImg0080720×¢ÊÍ } g_WMonImagesArr[0].GetCachedImage(SUPERIORGUARDBASE + (m_btDir * 8) + m_nEffectFrame -
            m_nEffectStart, //
            ax, ay);
      end;

    40: // ½©Ê¬1
      begin
        if m_boUseEffect then
        begin
          AttackEffectSurface := { FrmMain.WMon5Img20080720×¢ÊÍ } g_WMonImagesArr[4].GetCachedImage(ZOMBILIGHTINGBASE + (fire16dir * 10) + m_nEffectFrame -
            m_nEffectStart, //
            ax, ay);
        end;
        if BoUseDieEffect then
        begin
          DieEffectSurface := { FrmMain.WMon5Img20080720×¢ÊÍ } g_WMonImagesArr[4].GetCachedImage(ZOMBIDIEBASE + m_nCurrentFrame - m_nStartFrame, //
            bx, by);
        end;
      end;
    52: // Ð¨¶ê
      begin
        if m_boUseEffect then
          AttackEffectSurface := { FrmMain.WMon4Img20080720×¢ÊÍ } g_WMonImagesArr[3].GetCachedImage(MOTHPOISONGASBASE + (firedir * 10) + m_nEffectFrame -
            m_nEffectStart, //
            ax, ay);
      end;
    53: // ·à³æ
      begin
        if m_boUseEffect then
          AttackEffectSurface := { FrmMain.WMon3Img20080720×¢ÊÍ } g_WMonImagesArr[2].GetCachedImage(DUNGPOISONGASBASE + (firedir * 10) + m_nEffectFrame -
            m_nEffectStart, //
            ax, ay);
      end;
    64:
      begin
        if m_boUseEffect then
        begin
          AttackEffectSurface := { FrmMain.WMon20Img20080720×¢ÊÍ } g_WMonImagesArr[19].GetCachedImage(720 + (firedir * 10) + m_nEffectFrame - m_nEffectStart, //
            ax, ay);
        end;
      end;
    65:
      begin
        if BoUseDieEffect then
        begin
          DieEffectSurface := { FrmMain.WMon20Img20080720×¢ÊÍ } g_WMonImagesArr[19].GetCachedImage(350 + m_nCurrentFrame - m_nStartFrame, bx, by);
        end;
      end;
    66:
      begin
        if BoUseDieEffect then
        begin
          DieEffectSurface := { FrmMain.WMon20Img20080720×¢ÊÍ } g_WMonImagesArr[19].GetCachedImage(1600 + m_nCurrentFrame - m_nStartFrame, bx, by);
        end;
      end;
    67:
      begin
        if BoUseDieEffect then
        begin
          DieEffectSurface := { FrmMain.WMon20Img20080720×¢ÊÍ } g_WMonImagesArr[19]
            .GetCachedImage(1160 + (m_btDir * 10) + m_nCurrentFrame - m_nStartFrame, bx, by);
        end;
      end;
    68:
      begin
        if BoUseDieEffect then
        begin
          DieEffectSurface := { FrmMain.WMon20Img20080720×¢ÊÍ } g_WMonImagesArr[19].GetCachedImage(1600 + m_nCurrentFrame - m_nStartFrame, bx, by);
        end;
      end;
    96:
      begin
        if m_boUseEffect then
          AttackEffectSurface := { FrmMain.WMonImg0080720×¢ÊÍ } g_WMonImagesArr[24].GetCachedImage(426 + (m_btDir * 10) + m_nEffectFrame - m_nEffectStart, //
            ax, ay);
      end;
    97:
      begin
        if m_boUseEffect then
          AttackEffectSurface := { FrmMain.WMonImg0080720×¢ÊÍ } g_WMonImagesArr[24].GetCachedImage(932 + (m_btDir * 10) + m_nEffectFrame - m_nEffectStart, //
            ax, ay);
      end;
    100:
      begin // ÔÂÁé ¹¥»÷
        m_LightSurface := g_WMonImagesArr[17].GetCachedImage(920 + m_nCurrentFrame, m_nLightX, m_nLightY); // ÔÂÁé2007.12.12
        if (m_boUseEffect) and (m_nCurrentAction = SM_LIGHTING) then
          AttackEffectSurface := g_WMagic5Images.GetCachedImage(100 + m_nEffectFrame - m_nEffectStart, ax, ay);
        if (m_boUseEffect) and (m_nCurrentAction = SM_FAIRYATTACKRATE) then
        begin
          AttackEffectSurface := g_WMagic5Images.GetCachedImage(280 + m_nEffectFrame - m_nEffectStart, ax, ay);
        end;
        if BoUseDieEffect then
        begin // ÔÂÁéËÀÍö 20080322
          DieEffectSurface := { FrmMain.WMon18Img20080720×¢ÊÍ } g_WMonImagesArr[17].GetCachedImage(1180 + (m_btDir * 9) + m_nCurrentFrame - m_nEndFrame, bx, by);
        end;
      end;
  end;
end;

procedure TGasKuDeGi.Run;
var
  prv: Integer;
  m_dwEffectFrameTimetime, m_dwFrameTimetime: longword;
  bo11: Boolean;
begin
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_BATTERBACKSTEP) or (m_nCurrentAction = SM_RUN)
  or (m_nCurrentAction = SM_HORSERUN) then
    exit;

  m_boMsgMuch := FALSE;
  if MsgCount >= 2 then
    m_boMsgMuch := TRUE;
  //
  RunActSound(m_nCurrentFrame - m_nStartFrame);
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);

  if m_btRace = 96 then
  begin
    if (m_nCurrentAction = SM_HIT) and (m_nCurrentFrame - m_nStartFrame = 2) then
      m_boUseEffect := TRUE;
  end;

  if m_boUseEffect then
  begin
    if m_boMsgMuch then
      m_dwEffectFrameTimetime := Round(m_dwEffectFrameTime * 2 / 3)
    else
      m_dwEffectFrameTimetime := m_dwEffectFrameTime;
    if GetTickCount - m_dwEffectStartTime > m_dwEffectFrameTimetime then
    begin
      if m_nEffectFrame < m_nEffectEnd then
      begin
        Inc(m_nEffectFrame);
        m_dwEffectStartTime := GetTickCount;
      end
      else
      begin
        m_boUseEffect := FALSE;
      end;
    end;
  end;

  // ÔÂÁé Ê¹ÓÃÄ§·¨
  if m_boUseEffect then
  begin
    if m_nEffectFrame >= m_nEffectEnd - 1 then
    begin // ¸¶¹ý ¹ß»ç ½ÃÁ¡
      if (m_btRace = 100) and (m_nCurrentAction = SM_LIGHTING) then
      begin
        PlayScene.NewMagic(self, 199, 199, 0, 0, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mtFly, TRUE, 0, bo11);
      end;
      if (m_btRace = 100) and (m_nCurrentAction = SM_FAIRYATTACKRATE) then
      begin
        PlayScene.NewMagic(self, 200, 200, 0, 0, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mtFly, TRUE, 0, bo11);
      end;

      if bo11 then
        g_SoundManager.DXPlaySound(m_nMagicExplosionSound);
      { else
        g_SoundManager.DXPlaySound (m_nMagicExplosionSound); }
    end;
  end;
  // ÔÂÁé Ê¹ÓÃÄ§·¨

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then
  begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if m_boMsgMuch then
      m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
    else
      m_dwFrameTimetime := m_dwFrameTime;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then
    begin
      if m_nCurrentFrame < m_nEndFrame then
      begin
        Inc(m_nCurrentFrame);
        m_dwStartTime := GetTickCount;
      end
      else
      begin
        m_nCurrentAction := 0;
        BoUseDieEffect := FALSE;
      end;
    end;
    m_nCurrentDefFrame := 0;
    m_dwDefFrameTime := GetTickCount;
    Inc(m_nMagicFrame);
    CreateMagicObject;
  end
  else
    DefaultFrameRun;

  if prv <> m_nCurrentFrame then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  m_BodyEffect.Run;
end;

procedure TGasKuDeGi.DrawChr(dsurface: TAsphyreCanvas; dx, dy: Integer; blend: Boolean; boFlag: Boolean);
var
  ceff: TColorEffect;
begin
  // if not (m_btDir in [0..7]) then exit;
  if m_btDir > 7 then
    exit;
  if GetTickCount - m_dwLoadSurfaceTime > (FREE_TEXTURE_TIME div 2) then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;

  ceff := GetDrawEffectValue;
  DrawMyShow(dsurface, dx, dy);
  if m_ShadowBodySurface <> nil then
    dsurface.DrawBlend(dx + m_nSdPx + m_nShiftX, dy + m_nSdPy + m_nShiftY, m_ShadowBodySurface, 0);
  if m_BodySurface <> nil then
  begin
    if m_btRace = 100 then
      dsurface.DrawBlend(dx + m_nLightX + m_nShiftX, dy + m_nLightY + m_nShiftY, m_LightSurface, 1);
    DrawBodySurface(dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, blend, ceff);
  end;
  m_BodyEffect.DrawEffect(DSurface, dx + m_nShiftX, dy + m_nShiftY);
  //DrawHealthState(dsurface);
end;

procedure TGasKuDeGi.DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer);
begin
  try
    if m_boUseEffect and (AttackEffectSurface <> nil) then
    begin
      dsurface.DrawBlend(dx + ax + m_nShiftX, dy + ay + m_nShiftY, AttackEffectSurface, 1);
    end;

    if BoUseDieEffect and (DieEffectSurface <> nil) then
    begin
      dsurface.DrawBlend(dx + bx + m_nShiftX, dy + by + m_nShiftY, DieEffectSurface, 1);
    end;
  except
    DebugOutStr('TGasKuDeGi.DrawEff');
  end
end;

function TFireCowFaceMon.Light: Integer; // »ðÃæÅ£¹Ö??
var
  l: Integer;
begin
  l := m_nChrLight;
  if l < 2 then
  begin
    if m_boUseEffect then
      l := 2;
  end;
  Result := l;
end;

function TCowFaceKing.Light: Integer;
var
  l: Integer;
begin
  l := m_nChrLight;
  if l < 2 then
  begin
    if m_boUseEffect then
      l := 2;
  end;
  Result := l;
end;

{ ----------------------------------------------------------- }

// procedure TZombiLighting.Run;

{ ----------------------------------------------------------- }

procedure TSculptureMon.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  m_nCurrentFrame := -1;

  m_nBodyOffset := GetOffset(m_wAppearance); // È¡Í¼
  pm := GetRaceByPM(m_btRace, m_wAppearance); // È¡¶¯×÷Ïà¹Ø²½Êý
  if pm = nil then
    exit;
  m_boUseEffect := FALSE;

  case m_nCurrentAction of
    SM_TURN: // ×ªÉí
      begin
        if HaveStatus(STATE_STONE_MODE) then
        begin
          if (m_btRace = 48) or (m_btRace = 49) then
            m_nStartFrame := pm.ActDeath.start // + Dir * (pm.ActDeath.frame + pm.ActDeath.skip)
          else // ´ËÎªµñÏó
            m_nStartFrame := pm.ActDeath.start + m_btDir * (pm.ActDeath.frame + pm.ActDeath.skip);
          m_nEndFrame := m_nStartFrame;
          m_dwFrameTime := pm.ActDeath.ftime;
          m_dwStartTime := GetTickCount;
          m_nDefFrameCount := pm.ActDeath.frame;
        end
        else
        begin
          m_nStartFrame := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
          m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
          m_dwFrameTime := pm.ActStand.ftime;
          m_dwStartTime := GetTickCount;
          m_nDefFrameCount := pm.ActStand.frame;
        end;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_WALK, SM_BACKSTEP, SM_BATTERBACKSTEP: // ×ßÂ·£¬ºóÍË
      begin
        m_nStartFrame := pm.ActWalk.start + m_btDir * (pm.ActWalk.frame + pm.ActWalk.skip);
        m_nEndFrame := m_nStartFrame + pm.ActWalk.frame - 1;
        m_dwFrameTime := pm.ActWalk.ftime;
        m_dwStartTime := GetTickCount;
        m_nCurTick := 0;
        // WarMode := FALSE;
        m_nMoveStep := 1;
        if m_nCurrentAction = SM_BATTERBACKSTEP then
        begin
          m_nMoveStep := m_nBatterMoveStep;
          m_nCurrX := m_nBatterX;
          m_nCurrY := m_nBatterY;
        end;
        if m_nCurrentAction = SM_WALK then
          Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1)
        else // sm_backstep
          Shift(GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    SM_DIGUP: // °È±â ¾øÀ½, SM_DIGUP, ¹æÇâ ¾øÀ½.
      begin
        if (m_btRace = 48) or (m_btRace = 49) then
        begin
          m_nStartFrame := pm.ActDeath.start;
        end
        else
        begin
          m_nStartFrame := pm.ActDeath.start + m_btDir * (pm.ActDeath.frame + pm.ActDeath.skip);
        end;
        m_nEndFrame := m_nStartFrame + pm.ActDeath.frame - 1;
        m_dwFrameTime := pm.ActDeath.ftime;
        m_dwStartTime := GetTickCount;
        // WarMode := FALSE;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_HIT:
      begin
        m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
        m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
        m_dwFrameTime := pm.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        if m_btRace = 49 then
        begin
          m_boUseEffect := TRUE;
          firedir := m_btDir;
          m_nEffectFrame := 0; // startframe;
          m_nEffectStart := 0; // startframe;
          m_nEffectEnd := m_nEffectStart + 8;
          m_dwEffectStartTime := GetTickCount;
          m_dwEffectFrameTime := m_dwFrameTime;
        end;
      end;
    SM_STRUCK:
      begin
        m_nStartFrame := pm.ActStruck.start + m_btDir * (pm.ActStruck.frame + pm.ActStruck.skip);
        m_nEndFrame := m_nStartFrame + pm.ActStruck.frame - 1;
        m_dwFrameTime := m_dwStruckFrameTime; // pm.ActStruck.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_DEATH:
      begin
        m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
        m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
        m_nStartFrame := m_nEndFrame; //
        m_dwFrameTime := pm.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_NOWDEATH:
      begin
        m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
        m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
        m_dwFrameTime := pm.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
  end;
end;

procedure TSculptureMon.LoadSurface;
begin
  inherited LoadSurface;
  case m_btRace of
    48, 49:
      begin
        if m_boUseEffect then
          AttackEffectSurface := { FrmMain.WMon7Img20080720×¢ÊÍ } g_WMonImagesArr[6].GetCachedImage(SCULPTUREFIREBASE + (firedir * 10) + m_nEffectFrame -
            m_nEffectStart, //
            ax, ay);
      end;
    (* 91: begin
      case m_nCurrentAction of
      SM_WALK: begin
      m_boUseEffect := TRUE;
      m_nEffectStart:=0;
      m_nEffectFrame:=0;
      m_nEffectEnd:=6;
      m_dwEffectStartTime:=GetTickCount;
      m_dwEffectFrameTime:=150;
      AttackEffectSurface := g_WMonImagesArr[23].GetCachedImage (
      2350 + (m_btDir * 10) + m_nEffectFrame - m_nEffectStart,
      ax, ay);
      end;
      SM_Hit: begin
      m_boUseEffect := TRUE;
      m_nEffectStart:=0;
      m_nEffectFrame:=0;
      m_nEffectEnd:=6;
      m_dwEffectStartTime:=GetTickCount;
      m_dwEffectFrameTime:=150;
      AttackEffectSurface := g_WMonImagesArr[23].GetCachedImage (
      2430 + (firedir * 10) + m_nEffectFrame - m_nEffectStart,
      ax, ay);
      end;
      {else begin
      m_boUseEffect := TRUE;
      m_nEffectStart:=0;
      m_nEffectFrame:=0;
      m_nEffectEnd:=4;
      m_dwEffectStartTime:=GetTickCount;
      m_dwEffectFrameTime:=150;
      AttackEffectSurface := g_WMonImagesArr[23].GetCachedImage (
      1770 + (m_btDir * 10) + m_nEffectFrame,
      ax, ay);
      end;  }
      end;
      end; *)
  end;
end;

function TSculptureMon.GetDefaultFrame(wmode: Boolean): Integer;
var
  cf: Integer;
  pm: PTMonsterAction;
begin
  Result := 0; // jacky
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    exit;

  if m_boDeath then
  begin
    Result := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip) + (pm.ActDie.frame - 1);
  end
  else
  begin
    if HaveStatus(STATE_STONE_MODE) then
    begin
      case m_btRace of
        47:
          Result := pm.ActDeath.start + m_btDir * (pm.ActDeath.frame + pm.ActDeath.skip);
        48, 49:
          Result := pm.ActDeath.start;
      end;
    end
    else
    begin
      m_nDefFrameCount := pm.ActStand.frame;
      if m_nCurrentDefFrame < 0 then
        cf := 0
      else if m_nCurrentDefFrame >= pm.ActStand.frame then
        cf := 0
      else
        cf := m_nCurrentDefFrame;
      Result := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip) + cf;
    end;
  end;
end;

procedure TSculptureMon.DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer);
begin
  try
    if m_boUseEffect and (AttackEffectSurface <> nil) then
    begin
      dsurface.DrawBlend(dx + ax + m_nShiftX, dy + ay + m_nShiftY, AttackEffectSurface, 1);
    end;
  except
    DebugOutStr('TSculptureMon.DrawEff');
  end;
end;

procedure TSculptureMon.Run;
var
  m_dwEffectFrameTimetime: longword;
begin
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_BATTERBACKSTEP) or (m_nCurrentAction = SM_RUN)
  or (m_nCurrentAction = SM_HORSERUN) then
    exit;
  if m_boUseEffect then
  begin
    m_dwEffectFrameTimetime := m_dwEffectFrameTime;
    if GetTickCount - m_dwEffectStartTime > m_dwEffectFrameTimetime then
    begin
      m_dwEffectStartTime := GetTickCount;
      if m_nEffectFrame < m_nEffectEnd then
      begin
        Inc(m_nEffectFrame);
      end
      else
      begin
        m_boUseEffect := FALSE;
      end;
    end;
  end;
  inherited Run;
end;

{ TBanyaGuardMon }

procedure TBanyaGuardMon.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  m_nCurrentFrame := -1;
  m_nBodyOffset := GetOffset(m_wAppearance);
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    exit;
  case m_nCurrentAction of
    SM_HIT:
      begin
        m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
        m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
        m_dwFrameTime := pm.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
        m_boUseEffect := TRUE;

        m_nEffectFrame := m_nStartFrame;
        m_nEffectStart := m_nStartFrame;
        m_nEffectEnd := m_nEndFrame;
        m_dwEffectStartTime := GetTickCount;
        m_dwEffectFrameTime := m_dwFrameTime;
      end;
    SM_LIGHTING:
      begin
        m_nStartFrame := pm.ActCritical.start + m_btDir * (pm.ActCritical.frame + pm.ActCritical.skip);
        m_nEndFrame := m_nStartFrame + pm.ActCritical.frame - 1;
        m_dwFrameTime := pm.ActCritical.ftime;
        m_dwStartTime := GetTickCount;
        m_nCurEffFrame := 0;
        m_boUseMagic := TRUE;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
        if (m_btRace = 71) then
        begin
          m_boUseEffect := TRUE;
          m_nEffectFrame := m_nStartFrame;
          m_nEffectStart := m_nStartFrame;
          m_nEffectEnd := m_nEndFrame;
          m_dwEffectStartTime := GetTickCount;
          m_dwEffectFrameTime := m_dwFrameTime;
        end;
      end;
  else
    begin
      inherited;
    end;
  end;

end;

constructor TBanyaGuardMon.Create;
begin
  inherited;
  n26C := nil;
end;

destructor TBanyaGuardMon.Destroy;
begin
  inherited;
end;

procedure TBanyaGuardMon.DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer);
begin
  try
    inherited;
    if m_boUseEffect and (n26C <> nil) then
    begin
      dsurface.DrawBlend(dx + ax + m_nShiftX, dy + ay + m_nShiftY, n26C, 1);
    end;
  except
    DebugOutStr('TBanyaGuardMon.DrawEff');
  end;
end;

procedure TBanyaGuardMon.LoadSurface;
begin
  inherited;
  if bo260 then
  begin
    case m_btRace of
      70:
        begin
          AttackEffectSurface := { FrmMain.WMon21Img20080720×¢ÊÍ } g_WMonImagesArr[20].GetCachedImage(2320 + m_nCurrentFrame - m_nStartFrame, n264, n268);

        end;
      71:
        begin
          AttackEffectSurface := { FrmMain.WMon21Img20080720×¢ÊÍ } g_WMonImagesArr[20].GetCachedImage(2870 + (m_btDir * 10) + m_nCurrentFrame - m_nStartFrame,
            n264, n268);
        end;
      78:
        begin
          AttackEffectSurface := { FrmMain.WMon22Img20080720×¢ÊÍ } g_WMonImagesArr[21].GetCachedImage(3120 + (m_btDir * 20) + m_nCurrentFrame - m_nStartFrame,
            n264, n268);
        end;
    end;
  end
  else
  begin
    if m_boUseEffect then
    begin
      case m_btRace of
        70:
          begin
            if m_nCurrentAction = SM_HIT then
            begin
              n26C := { FrmMain.WMon21Img20080720×¢ÊÍ } g_WMonImagesArr[20].GetCachedImage(2230 + (m_btDir * 10) + m_nEffectFrame - m_nEffectStart, ax, ay);
            end;
          end;
        71:
          begin
            case m_nCurrentAction of
              SM_HIT:
                begin
                  n26C := { FrmMain.WMon21Img20080720×¢ÊÍ } g_WMonImagesArr[20].GetCachedImage(2780 + (m_btDir * 10) + m_nEffectFrame - m_nEffectStart, ax, ay);
                end;
              SM_FLYAXE .. SM_LIGHTING:
                begin
                  n26C := { FrmMain.WMon21Img20080720×¢ÊÍ } g_WMonImagesArr[20].GetCachedImage(2960 + (m_btDir * 10) + m_nEffectFrame - m_nEffectStart, ax, ay);
                end;
            end;
          end;
        72:
          begin
            if m_nCurrentAction = SM_HIT then
            begin
              n26C := { FrmMain.WMon21Img20080720×¢ÊÍ } g_WMonImagesArr[20].GetCachedImage(3490 + (m_btDir * 10) + m_nEffectFrame - m_nEffectStart, ax, ay);
            end;
          end;
        78:
          begin
            if m_nCurrentAction = SM_HIT then
            begin
              n26C := { FrmMain.WMon22Img20080720×¢ÊÍ } g_WMonImagesArr[21].GetCachedImage(3440 + (m_btDir * 10) + m_nEffectFrame - m_nEffectStart, ax, ay);
            end;
          end;
      end;
    end;
  end;
end;

procedure TBanyaGuardMon.Run;
var
  prv: Integer;
  m_dwEffectFrameTimetime, m_dwFrameTimetime: longword;
  bo11: Boolean;
begin
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then
    exit;
  m_boMsgMuch := FALSE;
  if MsgCount >= 2 then
    m_boMsgMuch := TRUE;

  RunActSound(m_nCurrentFrame - m_nStartFrame);
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);

  if m_boUseEffect then
  begin
    if m_boMsgMuch then
      m_dwEffectFrameTimetime := Round(m_dwEffectFrameTime * 2 / 3)
    else
      m_dwEffectFrameTimetime := m_dwEffectFrameTime;
    if GetTickCount - m_dwEffectStartTime > m_dwEffectFrameTimetime then
    begin
      m_dwEffectStartTime := GetTickCount;
      if m_nEffectFrame < m_nEffectEnd then
      begin
        Inc(m_nEffectFrame);
      end
      else
      begin
        m_boUseEffect := FALSE;
      end;
    end;
  end;

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then
  begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if m_boMsgMuch then
      m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
    else
      m_dwFrameTimetime := m_dwFrameTime;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then
    begin
      if m_nCurrentFrame < m_nEndFrame then
      begin
        Inc(m_nCurrentFrame);
        m_dwStartTime := GetTickCount;
      end
      else
      begin
        m_nCurrentAction := 0;
        m_boUseEffect := FALSE;
        bo260 := FALSE;
      end;
      if m_nCurrentAction = SM_LIGHTING then
      begin
        if (m_nCurrentFrame - m_nStartFrame) = 4 then
        begin
          if (m_btRace = 70) or (m_btRace = 81) then
          begin
            PlayScene.NewMagic(self, m_nMagicNum, 8, 0, 0, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mtThunder, FALSE, 30, bo11);
            g_SoundManager.DXPlaySound(10112);
          end;
          if (m_btRace = 71) then
          begin
            PlayScene.NewMagic(self, 1, 1, 0, 0, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mtFly, TRUE, 30, bo11);
            g_SoundManager.DXPlaySound(10012);
          end;
          if (m_btRace = 72) then
          begin
            PlayScene.NewMagic(self, 11, 32, 0, 0, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mt13, FALSE, 30, bo11);
            g_SoundManager.DXPlaySound(2276);
          end;
          if (m_btRace = 78) then
          begin
            PlayScene.NewMagic(self, 11, 37, 0, 0, m_nCurrX, m_nCurrY, m_nCurrX, m_nCurrY, m_nRecogId, mt13, FALSE, 30, bo11);
            g_SoundManager.DXPlaySound(2396);
          end;
        end;
      end;
      m_nCurrentDefFrame := 0;
      m_dwDefFrameTime := GetTickCount;
      Inc(m_nMagicFrame);
      CreateMagicObject;
    end;
  end
  else
    DefaultFrameRun;

  if prv <> m_nCurrentFrame then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  m_BodyEffect.Run;
end;

{ TElectronicScolpionMon }

procedure TElectronicScolpionMon.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  m_nCurrentFrame := -1;
  m_nBodyOffset := GetOffset(m_wAppearance);
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    exit;
  case m_nCurrentAction of
    SM_HIT:
      begin
        m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
        m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
        m_dwFrameTime := pm.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_LIGHTING:
      begin
        m_nStartFrame := pm.ActCritical.start + m_btDir * (pm.ActCritical.frame + pm.ActCritical.skip);
        m_nEndFrame := m_nStartFrame + pm.ActCritical.frame - 1;
        m_dwFrameTime := pm.ActCritical.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
        m_boUseEffect := TRUE;
        firedir := m_btDir;
        m_nEffectFrame := m_nStartFrame;
        m_nEffectStart := m_nStartFrame;
        m_nEffectEnd := m_nEndFrame;
        m_dwEffectStartTime := GetTickCount;
        m_dwEffectFrameTime := m_dwFrameTime;
      end;
  else
    begin
      inherited;
    end;
  end;
end;

destructor TElectronicScolpionMon.Destroy;
begin
  inherited;
end;

procedure TElectronicScolpionMon.LoadSurface;
begin
  inherited;
  if (m_btRace = 60) and m_boUseEffect and (m_nCurrentAction = SM_LIGHTING) then
  begin
    AttackEffectSurface := { FrmMain.WMon19Img20080720×¢ÊÍ } g_WMonImagesArr[18].GetCachedImage(430 + (firedir * 10) + m_nEffectFrame - m_nEffectStart, ax, ay);
  end;
end;

{ TBossPigMon }

destructor TBossPigMon.Destroy;
begin
  inherited;
end;

procedure TBossPigMon.LoadSurface;
begin
  inherited;
  if (m_btRace = 61) and m_boUseEffect then
  begin
    AttackEffectSurface := { FrmMain.WMon19Img20080720×¢ÊÍ } g_WMonImagesArr[18].GetCachedImage(860 + (firedir * 10) + m_nEffectFrame - m_nEffectStart, ax, ay);
  end;
end;

{ TKingOfSculpureKingMon }

procedure TKingOfSculpureKingMon.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  m_nCurrentFrame := -1;
  m_nBodyOffset := GetOffset(m_wAppearance);
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    exit;
  case m_nCurrentAction of
    SM_HIT:
      begin
        m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
        m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
        m_dwFrameTime := pm.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
        m_boUseEffect := TRUE;
        firedir := m_btDir;
        m_nEffectFrame := m_nStartFrame;
        m_nEffectStart := m_nStartFrame;
        m_nEffectEnd := m_nEndFrame;
        m_dwEffectStartTime := GetTickCount;
        m_dwEffectFrameTime := m_dwFrameTime;
      end;
    SM_LIGHTING:
      begin
        m_nStartFrame := pm.ActCritical.start + m_btDir * (pm.ActCritical.frame + pm.ActCritical.skip);
        m_nEndFrame := m_nStartFrame + pm.ActCritical.frame - 1;
        m_dwFrameTime := pm.ActCritical.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
        m_boUseEffect := TRUE;
        firedir := m_btDir;
        m_nEffectFrame := m_nStartFrame;
        m_nEffectStart := m_nStartFrame;
        m_nEffectEnd := m_nEndFrame;
        m_dwEffectStartTime := GetTickCount;
        m_dwEffectFrameTime := m_dwFrameTime;
      end;
    SM_NOWDEATH:
      begin
        m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
        m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
        m_dwFrameTime := pm.ActDie.ftime;
        m_dwStartTime := GetTickCount;
        m_nEffectFrame := pm.ActDie.start;
        m_nEffectStart := pm.ActDie.start;
        m_nEffectEnd := pm.ActDie.start + pm.ActDie.frame - 1;
        m_dwEffectStartTime := GetTickCount;
        m_dwEffectFrameTime := m_dwFrameTime;
        m_boUseEffect := TRUE;
      end;
  else
    begin
      inherited;
    end;
  end;
end;

destructor TKingOfSculpureKingMon.Destroy;
begin
  inherited;
end;

procedure TKingOfSculpureKingMon.LoadSurface;
begin
  inherited;
  if (m_btRace = 62) and m_boUseEffect then
  begin
    case m_nCurrentAction of
      SM_HIT:
        begin
          AttackEffectSurface := { FrmMain.WMon19Img20080720×¢ÊÍ } g_WMonImagesArr[18]
            .GetCachedImage(1490 + (firedir * 10) + m_nEffectFrame - m_nEffectStart, ax, ay);
        end;
      SM_LIGHTING:
        begin
          AttackEffectSurface := { FrmMain.WMon19Img20080720×¢ÊÍ } g_WMonImagesArr[18]
            .GetCachedImage(1380 + (firedir * 10) + m_nEffectFrame - m_nEffectStart, ax, ay);
        end;
      SM_NOWDEATH:
        begin
          AttackEffectSurface := { FrmMain.WMon19Img20080720×¢ÊÍ } g_WMonImagesArr[18].GetCachedImage(1470 + m_nEffectFrame - m_nEffectStart, ax, ay);
        end;
    end;

  end;
end;

{ TSkeletonArcherMon }

procedure TSkeletonArcherMon.CalcActorFrame;
begin
  inherited;
  if (m_nCurrentAction = SM_NOWDEATH) and (m_btRace <> 72) then
  begin
    bo260 := TRUE;
  end;
end;

destructor TSkeletonArcherMon.Destroy;
begin
  inherited;
end;

procedure TSkeletonArcherMon.DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer);
begin
  try
    inherited;
    if bo260 and (AttackEffectSurface <> nil) then
    begin
      dsurface.DrawBlend(dx + n264 + m_nShiftX, dy + n268 + m_nShiftY, AttackEffectSurface, 1);
    end;
  except
    DebugOutStr('TSkeletonArcherMon.DrawEff');
  end;
end;

procedure TSkeletonArcherMon.LoadSurface;
begin
  inherited;
  if bo260 then
  begin
    AttackEffectSurface := { FrmMain.WMon20Img20080720×¢ÊÍ } g_WMonImagesArr[19].GetCachedImage(1600 + m_nEffectFrame - m_nEffectStart, n264, n268);
  end;
end;

procedure TSkeletonArcherMon.Run;
var
  m_dwFrameTimetime: longword;
begin

  if m_boMsgMuch then
    m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
  else
    m_dwFrameTimetime := m_dwFrameTime;
  if m_nCurrentAction <> 0 then
  begin
    if (GetTickCount - m_dwStartTime) > m_dwFrameTimetime then
    begin
      if m_nCurrentFrame < m_nEndFrame then
      begin
      end
      else
      begin
        m_nCurrentAction := 0;
        bo260 := FALSE;
      end;
    end;
  end;

  inherited;
end;

{ TFlyingSpider }

procedure TFlyingSpider.CalcActorFrame;
var
  Eff8: TNormalDrawEffect;
begin
  inherited;
  if m_nCurrentAction = SM_NOWDEATH then
  begin
    Eff8 := TNormalDrawEffect.Create(m_nCurrX, m_nCurrY, { FrmMain.WMon12Img20080720×¢ÊÍ } g_WMonImagesArr[11], 1420, 20, m_dwFrameTime, TRUE);
    if Eff8 <> nil then
    begin
      Eff8.MagOwner := g_MySelf;
      PlayScene.m_EffectList.Add(Eff8);
    end;
  end;
end;

destructor TFlyingSpider.Destroy;
begin
  inherited;
end;

{ TExplosionSpider }

procedure TExplosionSpider.CalcActorFrame;
begin
  inherited;
  case m_nCurrentAction of
    SM_HIT:
      begin
        m_boUseEffect := FALSE;
      end;
    SM_NOWDEATH:
      begin
        m_nEffectStart := m_nStartFrame;
        m_nEffectFrame := m_nStartFrame;
        m_dwEffectStartTime := GetTickCount();
        m_dwEffectFrameTime := m_dwFrameTime;
        m_nEffectEnd := m_nEndFrame;
        m_boUseEffect := TRUE;
      end;
  end;
end;

destructor TExplosionSpider.Destroy;
begin
  inherited;
end;

procedure TExplosionSpider.LoadSurface;
begin
  inherited;
  if m_boUseEffect then
    AttackEffectSurface := { WMon14Img20080720×¢ÊÍ } g_WMonImagesArr[13].GetCachedImage(730 + m_nEffectFrame - m_nEffectStart, ax, ay);
end;

{ TSkeletonKingMon }

procedure TSkeletonKingMon.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  m_nCurrentFrame := -1;

  m_nBodyOffset := GetOffset(m_wAppearance);
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    exit;

  case m_nCurrentAction of
    SM_BACKSTEP, SM_WALK:
      begin
        m_nStartFrame := pm.ActWalk.start + m_btDir * (pm.ActWalk.frame + pm.ActWalk.skip);
        m_nEndFrame := m_nStartFrame + pm.ActWalk.frame - 1;
        m_dwFrameTime := pm.ActWalk.ftime;
        m_dwStartTime := GetTickCount;
        m_nEffectFrame := pm.ActWalk.start;
        m_nEffectStart := pm.ActWalk.start;
        m_nEffectEnd := pm.ActWalk.start + pm.ActWalk.frame - 1;
        m_dwEffectStartTime := GetTickCount();
        m_dwEffectFrameTime := m_dwFrameTime;
        m_boUseEffect := TRUE;
        m_nCurTick := 0;
        // WarMode := FALSE;
        m_nMoveStep := 1;
        if m_nCurrentAction = SM_WALK then
          Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1)
        else
          Shift(GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    SM_HIT:
      begin
        m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
        m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
        m_dwFrameTime := pm.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
        m_boUseEffect := TRUE;
        firedir := m_btDir;
        m_nEffectFrame := m_nStartFrame;
        m_nEffectStart := m_nStartFrame;
        m_nEffectEnd := m_nEndFrame;
        m_dwEffectStartTime := GetTickCount();
        m_dwEffectFrameTime := m_dwFrameTime;
      end;
    SM_FLYAXE:
      begin
        m_nStartFrame := pm.ActCritical.start + m_btDir * (pm.ActCritical.frame + pm.ActCritical.skip);
        m_nEndFrame := m_nStartFrame + pm.ActCritical.frame - 1;
        m_dwFrameTime := pm.ActCritical.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
        m_boUseEffect := TRUE;
        firedir := m_btDir;
        m_nEffectFrame := m_nStartFrame;
        m_nEffectStart := m_nStartFrame;
        m_nEffectEnd := m_nEndFrame;
        m_dwEffectStartTime := GetTickCount();
        m_dwEffectFrameTime := m_dwFrameTime;
      end;
    SM_LIGHTING:
      begin
        m_nStartFrame := 80 + pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
        m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
        m_dwFrameTime := pm.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
        m_boUseEffect := TRUE;
        firedir := m_btDir;
        m_nEffectFrame := m_nStartFrame;
        m_nEffectStart := m_nStartFrame;
        m_nEffectEnd := m_nEndFrame;
        m_dwEffectStartTime := GetTickCount();
        m_dwEffectFrameTime := m_dwFrameTime;
      end;
    SM_STRUCK:
      begin
        m_nStartFrame := pm.ActStruck.start + m_btDir * (pm.ActStruck.frame + pm.ActStruck.skip);
        m_nEndFrame := m_nStartFrame + pm.ActStruck.frame - 1;
        m_dwFrameTime := pm.ActStruck.ftime;
        m_dwStartTime := GetTickCount;
        m_nEffectFrame := pm.ActStruck.start;
        m_nEffectStart := pm.ActStruck.start;
        m_nEffectEnd := pm.ActStruck.start + pm.ActStruck.frame - 1;
        m_dwEffectStartTime := GetTickCount;
        m_dwEffectFrameTime := m_dwFrameTime;
        m_boUseEffect := TRUE;
      end;
    SM_NOWDEATH:
      begin
        m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
        m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
        m_dwFrameTime := pm.ActDie.ftime;
        m_dwStartTime := GetTickCount;
        m_nEffectFrame := pm.ActDie.start;
        m_nEffectStart := pm.ActDie.start;
        m_nEffectEnd := pm.ActDie.start + pm.ActDie.frame - 1;
        m_dwEffectStartTime := GetTickCount;
        m_dwEffectFrameTime := m_dwFrameTime;
        m_boUseEffect := TRUE;
      end;
  else
    begin
      inherited;
    end;
  end;
end;

destructor TSkeletonKingMon.Destroy;
begin
  inherited;
end;

procedure TSkeletonKingMon.LoadSurface;
begin
  inherited;
  if (m_btRace = 63) and m_boUseEffect then
  begin
    case m_nCurrentAction of
      SM_WALK:
        begin
          AttackEffectSurface := g_WMonImagesArr[19].GetCachedImage(3060 + (m_btDir * 10) + m_nEffectFrame - m_nEffectStart, ax, ay);
        end;
      SM_HIT:
        begin
          AttackEffectSurface := g_WMonImagesArr[19].GetCachedImage(3140 + (firedir * 10) + m_nEffectFrame - m_nEffectStart, ax, ay);
        end;
      SM_FLYAXE:
        begin
          AttackEffectSurface := g_WMonImagesArr[19].GetCachedImage(3300 + (firedir * 10) + m_nEffectFrame - m_nEffectStart, ax, ay);
        end;
      SM_LIGHTING:
        begin
          AttackEffectSurface := g_WMonImagesArr[19].GetCachedImage(3220 + (firedir * 10) + m_nEffectFrame - m_nEffectStart, ax, ay);
        end;
      SM_STRUCK:
        begin
          AttackEffectSurface := g_WMonImagesArr[19].GetCachedImage(3380 + (m_btDir * 2) + m_nEffectFrame - m_nEffectStart, ax, ay);
        end;
      SM_NOWDEATH:
        begin
          AttackEffectSurface := g_WMonImagesArr[19].GetCachedImage(3400 + (m_btDir * 4) + m_nEffectFrame - m_nEffectStart, ax, ay);
        end;
    end;
  end;
end;

procedure TSkeletonKingMon.Run;
var
  prv: Integer;
  m_dwEffectFrameTimetime, m_dwFrameTimetime: longword;
  meff: TFlyingFireBall;
begin
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then
    exit;

  m_boMsgMuch := FALSE;
  if MsgCount >= 2 then
    m_boMsgMuch := TRUE;

  //
  RunActSound(m_nCurrentFrame - m_nStartFrame);
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);

  if m_boUseEffect then
  begin
    if m_boMsgMuch then
      m_dwEffectFrameTimetime := Round(m_dwEffectFrameTime * 2 / 3)
    else
      m_dwEffectFrameTimetime := m_dwEffectFrameTime;
    if GetTickCount - m_dwEffectStartTime > m_dwEffectFrameTimetime then
    begin
      m_dwEffectStartTime := GetTickCount;
      if m_nEffectFrame < m_nEffectEnd then
      begin
        Inc(m_nEffectFrame);
      end
      else
      begin
        m_boUseEffect := FALSE;
      end;
    end;
  end;

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then
  begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if m_boMsgMuch then
      m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
    else
      m_dwFrameTimetime := m_dwFrameTime;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then
    begin
      if m_nCurrentFrame < m_nEndFrame then
      begin
        Inc(m_nCurrentFrame);
        m_dwStartTime := GetTickCount;
      end
      else
      begin
        m_nCurrentAction := 0;
        m_boUseEffect := FALSE;
        BoUseDieEffect := FALSE;
      end;

      if (m_nCurrentAction = SM_FLYAXE) and (m_nCurrentFrame - m_nStartFrame = 4) then
      begin
        meff := TFlyingFireBall(PlayScene.NewFlyObject(self, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mt12));
        if meff <> nil then
        begin
          meff.ImgLib := { FrmMain.WMon20Img20080720×¢ÊÍ } g_WMonImagesArr[19];
          meff.NextFrameTime := 40;
          meff.FlyImageBase := 3573;
        end;
      end;
      m_nCurrentDefFrame := 0;
      m_dwDefFrameTime := GetTickCount;
      Inc(m_nMagicFrame);
      CreateMagicObject;
    end;
  end
  else
    DefaultFrameRun;

  if prv <> m_nCurrentFrame then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  m_BodyEffect.Run;
end;

{ TStoneMonster }

procedure TStoneMonster.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  m_boUseMagic := FALSE;
  m_nCurrentFrame := -1;
  m_nBodyOffset := GetOffset(m_wAppearance);
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    exit;
  m_btDir := 0;
  case m_nCurrentAction of
    SM_TURN:
      begin
        m_nStartFrame := pm.ActStand.start;
        m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
        m_dwFrameTime := pm.ActStand.ftime;
        m_dwStartTime := GetTickCount;
        m_nDefFrameCount := pm.ActStand.frame;
        if not m_boUseEffect then
        begin
          m_boUseEffect := TRUE;
          m_nEffectFrame := m_nStartFrame;
          m_nEffectStart := m_nStartFrame;
          m_nEffectEnd := m_nEndFrame;
          m_dwEffectStartTime := GetTickCount;
          m_dwEffectFrameTime := 300;
        end;
      end;
    SM_HIT:
      begin
        m_nStartFrame := pm.ActAttack.start;
        m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
        m_dwFrameTime := pm.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        if not m_boUseEffect then
        begin
          m_boUseEffect := TRUE;
          m_nEffectFrame := m_nStartFrame;
          m_nEffectStart := m_nStartFrame;
          m_nEffectEnd := m_nStartFrame + 25;
          m_dwEffectStartTime := GetTickCount;
          m_dwEffectFrameTime := 150;
        end;
      end;
    SM_STRUCK:
      begin
        m_nStartFrame := pm.ActStruck.start;
        m_nEndFrame := m_nStartFrame + pm.ActStruck.frame - 1;
        m_dwFrameTime := pm.ActStruck.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_DEATH:
      begin
        m_nStartFrame := pm.ActDie.start;
        m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
        m_dwFrameTime := pm.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_NOWDEATH:
      begin
        m_nStartFrame := pm.ActDie.start;
        m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
        m_dwFrameTime := pm.ActDie.ftime;
        m_dwStartTime := GetTickCount;
        bo260 := TRUE;
        m_nEffectFrame := m_nStartFrame;
        m_nEffectStart := m_nStartFrame;
        m_nEffectEnd := m_nStartFrame + 19;
        m_dwEffectStartTime := GetTickCount;
        m_dwEffectFrameTime := 80;
      end;
    SM_SPELL:
    begin
      CalcActorSpellHitFrame(pm);
    end;
  end;
end;

constructor TStoneMonster.Create;
begin
  inherited;
  n26C := nil;
  m_boUseEffect := FALSE;
  bo260 := FALSE;
end;

destructor TStoneMonster.Destroy;
begin
  inherited;
end;

procedure TStoneMonster.DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer);
begin
  try
    inherited;
    if m_boUseEffect and (n26C <> nil) then
    begin
      dsurface.DrawBlend(dx + ax + m_nShiftX, dy + ay + m_nShiftY, n26C, 1);
    end;
  except
    DebugOutStr('TStoneMonster.DrawEff');
  end;
end;

procedure TStoneMonster.LoadSurface;
begin
  inherited;
  if bo260 then
  begin
    case m_btRace of
      75:
        begin
          AttackEffectSurface := { FrmMain.WMon22Img20080720×¢ÊÍ } g_WMonImagesArr[21].GetCachedImage(2530 + m_nEffectFrame - m_nEffectStart, n264, n268);
        end;
      77:
        begin
          AttackEffectSurface := { FrmMain.WMon22Img20080720×¢ÊÍ } g_WMonImagesArr[21].GetCachedImage(2660 + m_nEffectFrame - m_nEffectStart, n264, n268);
        end;
    end;
  end
  else
  begin
    if m_boUseEffect then
      case m_btRace of
        75:
          begin
            case m_nCurrentAction of
              SM_HIT:
                begin
                  n26C := { FrmMain.WMon22Img20080720×¢ÊÍ } g_WMonImagesArr[21].GetCachedImage(2500 + m_nEffectFrame - m_nEffectStart, ax, ay);
                end;
              SM_TURN:
                begin
                  n26C := { FrmMain.WMon22Img20080720×¢ÊÍ } g_WMonImagesArr[21].GetCachedImage(2490 + m_nEffectFrame - m_nEffectStart, ax, ay);
                end;
            end;
          end;
        77:
          begin
            case m_nCurrentAction of
              SM_HIT:
                begin
                  n26C := { FrmMain.WMon22Img20080720×¢ÊÍ } g_WMonImagesArr[21].GetCachedImage(2630 + m_nEffectFrame - m_nEffectStart, ax, ay);
                end;
              SM_TURN:
                begin
                  n26C := { FrmMain.WMon22Img20080720×¢ÊÍ } g_WMonImagesArr[21].GetCachedImage(2620 + m_nEffectFrame - m_nEffectStart, ax, ay);
                end;
            end;
          end;
      end;
  end;
end;

procedure TStoneMonster.Run;
var
  prv: Integer;
  m_dwEffectFrameTimetime: longword;
  m_dwFrameTimetime: longword;
begin
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then
    exit;
  m_boMsgMuch := FALSE;
  if MsgCount >= 2 then
    m_boMsgMuch := TRUE;

  RunActSound(m_nCurrentFrame - m_nStartFrame);
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);

  if m_boUseEffect or bo260 then
  begin
    if m_boMsgMuch then
      m_dwEffectFrameTimetime := Round(m_dwEffectFrameTime * 2 / 3)
    else
      m_dwEffectFrameTimetime := m_dwEffectFrameTime;
    if GetTickCount - m_dwEffectStartTime > m_dwEffectFrameTimetime then
    begin
      m_dwEffectStartTime := GetTickCount;
      if m_nEffectFrame < m_nEffectEnd then
      begin
        Inc(m_nEffectFrame);
      end
      else
      begin
        m_boUseEffect := FALSE;
        bo260 := FALSE;
      end;
    end;
  end;

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then
  begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if m_boMsgMuch then
      m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
    else
      m_dwFrameTimetime := m_dwFrameTime;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then
    begin
      if m_nCurrentFrame < m_nEndFrame then
      begin
        Inc(m_nCurrentFrame);
        m_dwStartTime := GetTickCount;
      end
      else
      begin
        m_nCurrentAction := 0;
      end;
      m_nCurrentDefFrame := 0;
      m_dwDefFrameTime := GetTickCount;
      Inc(m_nMagicFrame);
      CreateMagicObject;
    end;
  end
  else
    DefaultFrameRun;

  if (prv <> m_nCurrentFrame) or (prv <> m_nEffectFrame) then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  m_BodyEffect.Run;
end;

{ TAngel }

procedure TAngel.DrawChr(dsurface: TAsphyreCanvas; dx, dy: Integer; blend, boFlag: Boolean);
var
  ceff: TColorEffect;
begin
  // if not (m_btDir in [0..7]) then exit;
  if m_btDir > 7 then
    exit;
  if GetTickCount - m_dwLoadSurfaceTime > (FREE_TEXTURE_TIME div 2) then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface; // bodysurfaceµîÀÌ loadsurface¸¦ ´Ù½Ã ºÎ¸£Áö ¾Ê¾Æ ¸Þ¸ð¸®°¡ ÇÁ¸®µÇ´Â °ÍÀ» ¸·À½
  end;

  if n278 <> nil then
    dsurface.DrawBlend(dx + n270 + m_nShiftX, dy + n274 + m_nShiftY, n278, 1);
  ceff := GetDrawEffectValue;
  if m_ShadowBodySurface <> nil then
    dsurface.DrawBlend(dx + m_nSdPx + m_nShiftX, dy + m_nSdPy + m_nShiftY, m_ShadowBodySurface, 0);
  if m_BodySurface <> nil then
  begin
    DrawBodySurface(dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, blend, ceff);
  end;
  m_BodyEffect.DrawEffect(DSurface, dx + m_nShiftX, dy + m_nShiftY);
end;

procedure TAngel.LoadSurface;
var
  mimg: TWMImages;
begin
  mimg := GetMonImg(m_wAppearance);
  if mimg <> nil then
  begin
    if (not m_boReverseFrame) then
    begin
      m_BodySurface := mimg.GetCachedImage(1280 + m_nCurrentFrame, m_nPx, m_nPy);
      n278 := mimg.GetCachedImage(920 + m_nCurrentFrame, n270, n274);
    end
    else
    begin
      m_BodySurface := mimg.GetCachedImage(1280 + m_nEndFrame - (m_nCurrentFrame - m_nStartFrame), m_nPx, m_nPy);
      n278 := mimg.GetCachedImage(920 + m_nEndFrame - (m_nCurrentFrame - m_nStartFrame), n270, n274);
    end;
  end;
end;

{ TPBOMA6Mon }

procedure TPBOMA6Mon.Run;
var
  prv: Integer;
  m_dwFrameTimetime: longword;
  meff: TFlyingAxe;
begin
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then
    exit;

  m_boMsgMuch := FALSE;
  if MsgCount >= 2 then
    m_boMsgMuch := TRUE;

  RunActSound(m_nCurrentFrame - m_nStartFrame);
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then
  begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if m_boMsgMuch then
      m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
    else
      m_dwFrameTimetime := m_dwFrameTime;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then
    begin
      if m_nCurrentFrame < m_nEndFrame then
      begin
        Inc(m_nCurrentFrame);
        m_dwStartTime := GetTickCount;
      end
      else
      begin
        m_nCurrentAction := 0;
        m_boUseEffect := FALSE;
      end;
      if (m_nCurrentAction = SM_FLYAXE) and (m_nCurrentFrame - m_nStartFrame = 4) then
      begin
        meff := TFlyingAxe(PlayScene.NewFlyObject(self, m_nCurrX, m_nCurrY, g_nTargetX, g_nTargetY, m_nTargetRecog, mt16));
        if meff <> nil then
        begin
          meff.ImgLib := { FrmMain.WMon22Img20080720×¢ÊÍ } g_WMonImagesArr[21];
          meff.NextFrameTime := 50;
          meff.FlyImageBase := 1989;
        end;
      end;
      Inc(m_nMagicFrame);
      CreateMagicObject;
    end;
    m_nCurrentDefFrame := 0;
    m_dwDefFrameTime := GetTickCount;
  end
  else
    DefaultFrameRun;

  if prv <> m_nCurrentFrame then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  m_BodyEffect.Run;
end;

{ TDragonStatue }

procedure TDragonStatue.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  m_btDir := 0;
  m_nCurrentFrame := -1;
  m_nBodyOffset := GetOffset(m_wAppearance);
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    exit;
  case m_nCurrentAction of
    SM_DIGUP:
      begin
        Shift(0, 0, 0, 1);
        m_nStartFrame := 0;
        m_nEndFrame := 9;
        m_dwFrameTime := 100;
        m_dwStartTime := GetTickCount;
      end;
    SM_LIGHTING:
      begin
        m_nStartFrame := 0;
        m_nEndFrame := 9;
        m_dwFrameTime := 100;
        m_dwStartTime := GetTickCount;
        m_boUseEffect := TRUE;
        m_nEffectStart := 0;
        m_nEffectFrame := 0;
        m_nEffectEnd := 9;
        m_dwEffectStartTime := GetTickCount;
        m_dwEffectFrameTime := 100;
      end;
  end;
end;

procedure TDragonStatue.DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer);
begin
  try
    inherited;
    if m_boUseEffect and (EffectSurface <> nil) then
      dsurface.DrawBlend(dx + ax + m_nShiftX, dy + ay + m_nShiftY, EffectSurface, 1);
  except
  end;
end;

procedure TDragonStatue.LoadSurface;
var
  mimg: TWMImages;
begin
  mimg := { FrmMain.WDragonImg } g_WDragonImages;
  if mimg <> nil then
    m_BodySurface := mimg.GetCachedImage(GetOffset(m_wAppearance) + m_nCurrentFrame, m_nPx, m_nPy);
  if m_boUseEffect then
  begin
    case m_btRace of
      84 .. 86:
        begin
          EffectSurface := mimg.GetCachedImage(310 + m_nEffectFrame, ax, ay);
        end;
      87 .. 89:
        begin
          EffectSurface := mimg.GetCachedImage(330 + m_nEffectFrame, ax, ay);
        end;
    end;
  end;
end;

procedure TDragonStatue.Run;
var
  prv: Integer;
  dwEffectFrameTime, m_dwFrameTimetime: longword;
  bo11: Boolean;
begin
  m_btDir := 0;
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) { or 20080803×¢ÊÍÆïÂíÏûÏ¢
    (m_nCurrentAction = SM_HORSERUN) } then
    exit;

  m_boMsgMuch := FALSE;
  if MsgCount >= 2 then
    m_boMsgMuch := TRUE;

  if m_boUseEffect then
  begin
    if m_boMsgMuch then
      dwEffectFrameTime := Round(m_dwEffectFrameTime * 2 / 3)
    else
      dwEffectFrameTime := m_dwEffectFrameTime;
    if GetTickCount - m_dwEffectStartTime > dwEffectFrameTime then
    begin
      m_dwEffectStartTime := GetTickCount;
      if m_nEffectFrame < m_nEffectEnd then
      begin
        Inc(m_nEffectFrame);
      end
      else
      begin
        m_boUseEffect := FALSE;
      end;
    end;
  end;

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then
  begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if m_boMsgMuch then
      m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
    else
      m_dwFrameTimetime := m_dwFrameTime;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then
    begin
      if m_nCurrentFrame < m_nEndFrame then
      begin
        Inc(m_nCurrentFrame);
        m_dwStartTime := GetTickCount;
      end
      else
      begin
        m_nCurrentAction := 0;
        m_boUseEffect := FALSE;
        bo260 := FALSE;
      end;
      if (m_nCurrentAction = SM_LIGHTING) and (m_nCurrentFrame = 4) then
      begin
        PlayScene.NewMagic(self, 74, 74, 0, 0, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, 0, mtThunder, FALSE, 30, bo11);
        g_SoundManager.DXPlaySound(8222);
      end;
      Inc(m_nMagicFrame);
      CreateMagicObject;
    end;
    m_nCurrentDefFrame := 0;
    m_dwDefFrameTime := GetTickCount;
  end
  else
    DefaultFrameRun;

  if prv <> m_nCurrentFrame then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  m_BodyEffect.Run;
end;

{ TPBOMA1Mon }

destructor TPBOMA1Mon.Destroy;
begin
  inherited;
end;

procedure TPBOMA1Mon.Run;
var
  prv: Integer;
  m_dwFrameTimetime: longword;
  meff: TFlyingBug;
begin
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then
    exit;

  m_boMsgMuch := FALSE;
  if MsgCount >= 2 then
    m_boMsgMuch := TRUE;

  RunActSound(m_nCurrentFrame - m_nStartFrame);
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then
  begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if m_boMsgMuch then
      m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
    else
      m_dwFrameTimetime := m_dwFrameTime;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then
    begin
      if m_nCurrentFrame < m_nEndFrame then
      begin
        Inc(m_nCurrentFrame);
        m_dwStartTime := GetTickCount;
      end
      else
      begin
        m_nCurrentAction := 0;
        m_boUseEffect := FALSE;
      end;
      if (m_nCurrentAction = SM_FLYAXE) and (m_nCurrentFrame - m_nStartFrame = 4) then
      begin
        meff := TFlyingBug(PlayScene.NewFlyObject(self, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mt15));
        if meff <> nil then
        begin
          meff.ImgLib := { FrmMain.WMon22Img20080720×¢ÊÍ } g_WMonImagesArr[21];
          meff.NextFrameTime := 50;
          meff.FlyImageBase := 350;
          meff.MagExplosionBase := 430;
        end;
      end;
      Inc(m_nMagicFrame);
      CreateMagicObject;
    end;
    m_nCurrentDefFrame := 0;
    m_dwDefFrameTime := GetTickCount;
  end
  else
    DefaultFrameRun;

  if prv <> m_nCurrentFrame then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  m_BodyEffect.Run;
end;

{ ****************************************************************************** }
procedure TFireDragon.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  try
    m_boUseMagic := FALSE;
    case m_btDir of
      3, 4:
        firedir := 0;
      5:
        firedir := 1;
      6, 7:
        firedir := 2;
    end;
    m_btDir := 0;
    m_nCurrentFrame := -1;
    m_nBodyOffset := GetOffset(m_wAppearance);
    pm := GetRaceByPM(m_btRace, m_wAppearance);
    if pm = nil then
      exit;
    case m_nCurrentAction of
      SM_DIGUP:
        begin
          Shift(0, 0, 0, 1);
          m_nStartFrame := 0;
          m_nEndFrame := 9;
          m_dwFrameTime := 300;
          m_dwStartTime := GetTickCount;
        end;
      SM_HIT:
        begin
          m_btDir := 0;

          m_nStartFrame := 0;
          m_nEndFrame := 19;
          m_dwFrameTime := 150;
          m_dwStartTime := GetTickCount;
          m_boUseEffect := TRUE;
          m_nEffectStart := 0;
          m_nEffectFrame := 0;
          m_nEffectEnd := 19;
          m_dwEffectStartTime := GetTickCount;
          m_dwEffectFrameTime := 150;
          m_nCurEffFrame := 0;
          m_boUseMagic := TRUE;
          m_dwWarModeTime := GetTickCount;
          Shift(m_btDir, 0, 0, 1);
        end;
      SM_LIGHTING:
        begin // ´ó»ðÈ¦¹¥»÷
          m_nStartFrame := 0;
          m_nEndFrame := 5;
          m_dwFrameTime := 150;
          m_dwStartTime := GetTickCount;
          m_boUseEffect := TRUE;
          m_nEffectStart := 0;
          m_nEffectFrame := 0;
          m_nEffectEnd := 4;
          m_dwEffectStartTime := GetTickCount;
          m_dwEffectFrameTime := 150;
          m_nCurEffFrame := 0;
          m_boUseMagic := TRUE;
          m_dwWarModeTime := GetTickCount;
          Shift(m_btDir, 0, 0, 1);
        end;
      SM_STRUCK:
        begin
          m_nStartFrame := 0;
          m_nEndFrame := 9;
          m_dwFrameTime := 300;
          m_dwStartTime := GetTickCount;
        end;
      else
        inherited;
      { 81..83: begin
        m_nStartFrame:=0;
        m_nEndFrame:=5;
        m_dwFrameTime:=150;
        m_dwStartTime:=GetTickCount;
        m_boUseEffect:=True;
        m_nEffectStart:=0;
        m_nEffectFrame:=0;
        m_nEffectEnd:=10;
        m_dwEffectStartTime:=GetTickCount;
        m_dwEffectFrameTime:=150;
        m_nCurEffFrame:=0;
        m_boUseMagic:=True;
        m_dwWarModeTime:=GetTickcount;
        Shift (m_btDir, 0, 0, 1);
        end; }
    end;
  except
    DebugOutStr('TFireDragon.CalcActorFrame');
  end;
end;

constructor TFireDragon.Create;
begin
  inherited;
  n270 := nil;
  firedir := 0;
end;

procedure TFireDragon.AttackEff;
var
  n8, nC, n10, n14, n18: Integer;
  bo11: Boolean;
  i, iCount: Integer;
begin
  try
    if m_boDeath then
      exit;
    n8 := m_nCurrX;
    nC := m_nCurrY;
    iCount := Random(1);
    for i := 0 to iCount do
    begin
      n10 := Random(4);
      n14 := Random(8);
      n18 := Random(8);
      case n10 of
        0:
          begin
            PlayScene.NewMagic(self, 80, 80, 0, 0, m_nCurrX, m_nCurrY, n8 - n14 - 2, nC + n18 + 1, 0, mtRedThunder, FALSE, 30, bo11);
          end;
        1:
          begin
            PlayScene.NewMagic(self, 80, 80, 0, 0, m_nCurrX, m_nCurrY, n8 - n14, nC + n18, 0, mtRedThunder, FALSE, 30, bo11);
          end;
        2:
          begin
            PlayScene.NewMagic(self, 80, 80, 0, 0, m_nCurrX, m_nCurrY, n8 - n14, nC + n18 + 1, 0, mtRedThunder, FALSE, 30, bo11);
          end;
        3:
          begin
            PlayScene.NewMagic(self, 80, 80, 0, 0, m_nCurrX, m_nCurrY, n8 - n14 - 2, nC + n18, 0, mtRedThunder, FALSE, 30, bo11);
          end;
      end;
      g_SoundManager.DXPlaySound(8206);
    end;
  except
    DebugOutStr('TFireDragon.AttackEff');
  end;
end;

procedure TFireDragon.DrawEff(dsurface: TAsphyreCanvas; dx, dy: Integer);
begin
  try
    inherited;
    if m_boUseEffect and (n270 <> nil) then
    begin
      dsurface.DrawBlend(dx + ax + m_nShiftX, dy + ay + m_nShiftY, n270, 1);
    end;
  except
    DebugOutStr('TFireDragon.DrawEff');
  end;
end;

procedure TFireDragon.LoadSurface;
var
  mimg: TWMImages;
begin
  try
    mimg := { FrmMain.WDragonImg } g_WDragonImages;
    if mimg = nil then
      exit;
    // if (not m_boReverseFrame) then begin
    case m_nCurrentAction of
      SM_HIT:
        begin
          m_BodySurface := mimg.GetCachedImage(40 + m_nCurrentFrame, m_nPx, m_nPy);
        end;
      SM_LIGHTING:
        begin
          m_BodySurface := mimg.GetCachedImage(10 + firedir * 10 + m_nCurrentFrame, m_nPx, m_nPy);
        end;
      { 81: begin
        m_BodySurface := mimg.GetCachedImage (10 + m_nCurrentFrame, m_nPx, m_nPy);
        end;
        82: begin
        m_BodySurface := mimg.GetCachedImage (20 + m_nCurrentFrame, m_nPx, m_nPy);
        end;
        83: begin
        m_BodySurface := mimg.GetCachedImage (30 + m_nCurrentFrame, m_nPx, m_nPy);
        end; }
    else
      begin
        m_BodySurface := mimg.GetCachedImage(GetOffset(m_wAppearance) + m_nCurrentFrame, m_nPx, m_nPy);
      end;
    end;
    (* end else begin
      case m_nCurrentAction of
      SM_HIT: begin
      m_BodySurface := mimg.GetCachedImage (40 + m_nEndFrame - m_nCurrentFrame, ax, ay);
      end;
      SM_LIGHTING: begin
      m_BodySurface := mimg.GetCachedImage (10 + m_btDir * 10 + m_nCurrentFrame, m_nPx, m_nPy);
      end;
      {81: begin
      m_BodySurface := mimg.GetCachedImage (10 + m_nEndFrame - m_nCurrentFrame, ax, ay);
      end;
      82: begin
      m_BodySurface := mimg.GetCachedImage (20 + m_nEndFrame - m_nCurrentFrame, ax, ay);
      end;
      83: begin
      m_BodySurface := mimg.GetCachedImage (30 + m_nEndFrame - m_nCurrentFrame, ax, ay);
      end; }
      else begin
      m_BodySurface := mimg.GetCachedImage (GetOffset (m_wAppearance) + m_nEndFrame - m_nCurrentFrame, m_nPx, m_nPy);
      end;
      end;
      end; *)

    if m_boUseEffect then
    begin
      case m_nCurrentAction of
        SM_HIT:
          begin
            n270 := { FrmMain.WDragonImg } g_WDragonImages.GetCachedImage(60 + m_nEffectFrame, ax, ay);
          end;
        SM_LIGHTING:
          begin
            n270 := { FrmMain.WDragonImg } g_WDragonImages.GetCachedImage(90 + firedir * 10 + m_nEffectFrame, ax, ay);
          end;
        (* 81: begin
          n270 := {FrmMain.WDragonImg}g_WDragonImages.GetCachedImage (90 + m_nEffectFrame, ax, ay);
          end;
          82: begin
          n270 := {FrmMain.WDragonImg}g_WDragonImages.GetCachedImage (100 + m_nEffectFrame, ax, ay);
          end;
          83: begin
          n270 := {FrmMain.WDragonImg}g_WDragonImages.GetCachedImage (110 + m_nEffectFrame, ax, ay);
          end; *)

      end;
    end;
  except
    DebugOutStr('TFireDragon.LoadSurface');
  end;
end;

procedure TFireDragon.Run;
var
  prv: Integer;
  m_dwEffectFrameTimetime, m_dwFrameTimetime: longword;
  bo11: Boolean;
begin
  try
    if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN)
    or (m_nCurrentAction = SM_HORSERUN) then
      exit;

    m_boMsgMuch := FALSE;
    if MsgCount >= 2 then
      m_boMsgMuch := TRUE;
    if m_boRunSound then
    begin
      g_SoundManager.DXPlaySound(8201);
      m_boRunSound := FALSE;
    end;

    if m_boUseEffect then
    begin
      if m_boMsgMuch then
        m_dwEffectFrameTimetime := Round(m_dwEffectFrameTime * 2 / 3)
      else
        m_dwEffectFrameTimetime := m_dwEffectFrameTime;
      if GetTickCount - m_dwEffectStartTime > m_dwEffectFrameTimetime then
      begin
        m_dwEffectStartTime := GetTickCount;
        if m_nEffectFrame < m_nEffectEnd then
        begin
          Inc(m_nEffectFrame);
        end
        else
        begin
          m_boUseEffect := FALSE;
        end;
      end;
    end;

    prv := m_nCurrentFrame;
    if m_nCurrentAction <> 0 then
    begin
      if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
        m_nCurrentFrame := m_nStartFrame;

      if m_boMsgMuch then
        m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
      else
        m_dwFrameTimetime := m_dwFrameTime;

      if GetTickCount - m_dwStartTime > m_dwFrameTimetime then
      begin
        if m_nCurrentFrame < m_nEndFrame then
        begin
          Inc(m_nCurrentFrame);
          m_dwStartTime := GetTickCount;
        end
        else
        begin
          m_nCurrentAction := 0;
          m_boUseEffect := FALSE;
          bo260 := FALSE;
        end;

        if (m_nCurrentAction = SM_LIGHTING) and (m_nCurrentFrame - m_nStartFrame = 1) then
        begin
          PlayScene.NewMagic(self, 102, 102, 0, 0, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mtFly, TRUE, 30, bo11);
        end;

        if (m_nCurrentAction = SM_HIT) { and (m_nCurrentFrame = 4) } then
        begin // and (m_nCurrentFrame = 4) then begin
          AttackEff;
          g_SoundManager.DXPlaySound(8202);
        end;

        { if (m_nCurrentAction = 81) or (m_nCurrentAction = 82) or (m_nCurrentAction = 83) then begin
          if (m_nCurrentFrame - m_nStartFrame) = 4 then begin
          PlayScene.NewMagic (Self,m_nCurrentAction,m_nCurrentAction,m_nCurrX,m_nCurrY,m_nTargetX,m_nTargetY,m_nTargetRecog,mtFly,True,30,bo11);
          g_SoundManager.DXPlaySound(8203);
          end;
          end; }
        Inc(m_nMagicFrame);
        CreateMagicObject;
      end;
      m_nCurrentDefFrame := 0;
      m_dwDefFrameTime := GetTickCount;
    end
    else
      DefaultFrameRun;

    if prv <> m_nCurrentFrame then
    begin
      m_dwLoadSurfaceTime := GetTickCount;
      LoadSurface;
    end;
    m_BodyEffect.Run;
  except
  end;
end;

// Ê¥µîÎÀÊ¿
constructor TRedThunderZuma.Create;
begin
  inherited;
  boCasted := FALSE;
end;

procedure TRedThunderZuma.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  m_nCurrentFrame := -1;
  m_nBodyOffset := GetOffset(m_wAppearance);
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    exit;

  case m_nCurrentAction of
    SM_TURN:
      begin
        if HaveStatus(STATE_STONE_MODE) then
        begin
          m_nStartFrame := pm.ActDeath.start + m_btDir * (pm.ActDeath.frame + pm.ActDeath.skip);
          m_nEndFrame := m_nStartFrame;
          m_dwFrameTime := pm.ActDeath.ftime;
          m_dwStartTime := GetTickCount;
          m_nDefFrameCount := pm.ActDeath.frame;
        end
        else
          inherited;
      end;
    SM_LIGHTING:
      begin
        m_nStartFrame := pm.ActCritical.start + m_btDir * (pm.ActCritical.frame + pm.ActCritical.skip);
        m_nEndFrame := m_nStartFrame + pm.ActCritical.frame - 1;
        m_dwFrameTime := pm.ActCritical.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        firedir := m_btDir;
        Shift(m_btDir, 0, 0, 1);
        m_boUseEffect := TRUE;
        m_nEffectStart := 0;
        m_nEffectFrame := 0;
        m_nEffectEnd := 6;
        m_dwEffectStartTime := GetTickCount;
        m_dwEffectFrameTime := 150;
        m_nCurEffFrame := 0;
        boCasted := TRUE;
      end;
    SM_DIGUP:
      begin
        m_nStartFrame := pm.ActDeath.start + m_btDir * (pm.ActDeath.frame + pm.ActDeath.skip);
        m_nEndFrame := m_nStartFrame + pm.ActDeath.frame - 1;
        m_dwFrameTime := pm.ActDeath.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_HIT:
      begin
        m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
        m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
        m_dwFrameTime := pm.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        m_boUseEffect := TRUE;
        firedir := m_btDir;
        m_nEffectFrame := 0; // startframe;
        m_nEffectStart := 0; // startframe;
        m_nEffectEnd := m_nEffectStart + 6;
        m_dwEffectStartTime := GetTickCount;
        m_dwEffectFrameTime := m_dwFrameTime;
      end;
  else
    begin
      inherited;
    end;
  end;
end;

function TRedThunderZuma.GetDefaultFrame(wmode: Boolean): Integer;
var
  pm: PTMonsterAction;
begin
  Result := 0;
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  {
    if boActive = FALSE then begin

    if pm = nil then exit;
    if m_boDeath then begin
    inherited GetDefaultFrame(wmode);
    exit;
    end;
    m_nDefFrameCount := 1;
    if m_nCurrentDefFrame < 0 then cf := 0
    else if m_nCurrentDefFrame >= 0 then cf := 0
    else cf := m_nCurrentDefFrame;
    Result := pm.ActDeath.start + m_btDir * (pm.ActDeath.frame + pm.ActDeath.skip) + cf;
  }

  if HaveStatus(STATE_STONE_MODE) then
  begin
    Result := pm.ActDeath.start + m_btDir * (pm.ActDeath.frame + pm.ActDeath.skip);
  end
  else
  begin
    Result := inherited GetDefaultFrame(wmode);
    m_boUseEffect := TRUE;
    m_nEffectStart := 0;
    m_nEffectFrame := 0;
    m_nEffectEnd := 4;
    m_dwEffectStartTime := GetTickCount;
    m_dwEffectFrameTime := 150;
    AttackEffectSurface := g_WMonImagesArr[23].GetCachedImage(2270 + (m_btDir * 10) + m_nEffectFrame, ax, ay);
  end;
end;

procedure TRedThunderZuma.LoadSurface;
begin
  inherited;
  if HaveStatus(STATE_STONE_MODE) then
    exit;
  case m_nCurrentAction of
    SM_WALK:
      begin
        m_nEffectStart := 0;
        m_nEffectFrame := 0;
        m_nEffectEnd := 6;
        AttackEffectSurface := g_WMonImagesArr[23].GetCachedImage(2350 + (m_btDir * 10) + m_nEffectFrame - m_nEffectStart, ax, ay);
      end;
    SM_HIT:
      begin
        AttackEffectSurface := g_WMonImagesArr[23].GetCachedImage(2430 + (firedir * 10) + m_nEffectFrame - m_nEffectStart, ax, ay);
      end;
    { else begin
      m_boUseEffect := TRUE;
      m_nEffectStart:=0;
      m_nEffectFrame:=0;
      m_nEffectEnd:=4;
      m_dwEffectStartTime:=GetTickCount;
      m_dwEffectFrameTime:=150;
      AttackEffectSurface := g_WMonImagesArr[23].GetCachedImage (
      2270 + (m_btDir * 10) + m_nEffectFrame,
      ax, ay);
      end; }
  end;
end;

{ TheCrutchesSpider }
// ½ðÕÈÖ©Öë
procedure TheCrutchesSpider.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  m_nCurrentFrame := -1;
  m_nBodyOffset := GetOffset(m_wAppearance);
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    exit;

  case m_nCurrentAction of
    SM_FAIRYATTACKRATE, SM_LIGHTING:
      begin
        m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
        m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
        m_dwFrameTime := pm.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
        m_boUseEffect := TRUE;
        m_nEffectStart := 0;
        m_nEffectFrame := 0;
        m_nEffectEnd := 2;
        m_dwEffectStartTime := GetTickCount;
        m_dwEffectFrameTime := pm.ActAttack.ftime;
        m_nCurEffFrame := 0;
      end;
  else
    begin
      inherited;
    end;
  end;
end;

procedure TheCrutchesSpider.LoadSurface;
var
  meff: TMagicEff;
begin
  inherited;
  case m_nCurrentAction of
    SM_LIGHTING:
      begin
        AttackEffectSurface := nil;
        if (m_nEffectFrame = 1) then
        begin
          meff := TObjectEffects.Create(self, g_WMagicImages, 3840, 10, 60, TRUE);
          meff.ImgLib := g_WMagicImages;
          PlayScene.m_EffectList.Add(meff);
          g_SoundManager.DXPlaySound(10330);
        end;
      end;
    SM_FAIRYATTACKRATE:
      begin
        AttackEffectSurface := nil;
        if (m_nEffectFrame = 1) then
        begin
          meff := TObjectEffects.Create(self, g_WMagicImages, 1790, 10, 60, TRUE);
          meff.ImgLib := g_WMagicImages;
          PlayScene.m_EffectList.Add(meff);
          g_SoundManager.DXPlaySound(10290);
        end;
      end;
  end;
end;

procedure TheCrutchesSpider.Run;
var
  prv: Integer;
  m_dwEffectFrameTimetime, m_dwFrameTimetime: longword;
  bo11: Boolean;
begin
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then
    exit;

  m_boMsgMuch := FALSE;
  if MsgCount >= 2 then
    m_boMsgMuch := TRUE;
  //
  RunActSound(m_nCurrentFrame - m_nStartFrame);
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);
  if m_boUseEffect then
  begin
    if m_boMsgMuch then
      m_dwEffectFrameTimetime := Round(m_dwEffectFrameTime * 2 / 3)
    else
      m_dwEffectFrameTimetime := m_dwEffectFrameTime;
    if GetTickCount - m_dwEffectStartTime > m_dwEffectFrameTimetime then
    begin
      if m_nEffectFrame < m_nEffectEnd then
      begin
        Inc(m_nEffectFrame);
        m_dwEffectStartTime := GetTickCount;
      end
      else
      begin
        m_boUseEffect := FALSE;
      end;
    end;
  end;

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then
  begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if m_boMsgMuch then
      m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
    else
      m_dwFrameTimetime := m_dwFrameTime;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then
    begin
      if m_nCurrentFrame < m_nEndFrame then
      begin
        Inc(m_nCurrentFrame);
        m_dwStartTime := GetTickCount;
      end
      else
      begin
        m_nCurrentAction := 0;
        BoUseDieEffect := FALSE;
      end;
      // ½ðÕÈÖ©Öë ÊÍ·Å±ùÅØÏøÄ§·¨
      if (m_btRace = 92) and (m_nCurrentAction = SM_LIGHTING) and (m_nCurrentFrame - m_nStartFrame = 1) then
      begin
        PlayScene.NewMagic(self, ACTOR_EFFECTID, 31, 0, 0, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mtExplosion, TRUE, 0, bo11);
        g_SoundManager.DXPlaySound(10332);
      end;
      // ½ðÕÈÖ©Öë ÊÍ·ÅÖÎÁÆÊõÄ§·¨
      if (m_btRace = 92) and (m_nCurrentAction = SM_FAIRYATTACKRATE) and (m_nCurrentFrame - m_nStartFrame = 1) then
      begin
        PlayScene.NewMagic(self, ACTOR_EFFECTID, 27, 0, 0, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mtExplosion, TRUE, 0, bo11);
        g_SoundManager.DXPlaySound(10292);
      end;
    end;
    m_nCurrentDefFrame := 0;
    m_dwDefFrameTime := GetTickCount;
    Inc(m_nMagicFrame);
    CreateMagicObject;
  end
  else
    DefaultFrameRun;

  if prv <> m_nCurrentFrame then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  m_BodyEffect.Run;
end;

{ TYanLeiWangSpider }

procedure TYanLeiWangSpider.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  m_nCurrentFrame := -1;
  m_nBodyOffset := GetOffset(m_wAppearance);
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    exit;

  case m_nCurrentAction of
    SM_LIGHTING:
      begin
        m_nStartFrame := pm.ActCritical.start + m_btDir * (pm.ActCritical.frame + pm.ActCritical.skip);
        m_nEndFrame := m_nStartFrame + pm.ActCritical.frame - 1;
        m_dwFrameTime := pm.ActCritical.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
        m_boUseEffect := TRUE;
        m_nEffectStart := 0;
        m_nEffectFrame := 0;
        m_nEffectEnd := 10;
        m_dwEffectStartTime := GetTickCount;
        m_dwEffectFrameTime := pm.ActCritical.ftime;
        m_nCurEffFrame := 0;
      end;
  else
    begin
      inherited;
    end;
  end;
end;

procedure TYanLeiWangSpider.Run;
var
  prv: Integer;
  m_dwEffectFrameTimetime, m_dwFrameTimetime: longword;
  bo11: Boolean;
  meff: TMagicEff;
begin
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then
    exit;

  m_boMsgMuch := FALSE;
  if MsgCount >= 2 then
    m_boMsgMuch := TRUE;
  //
  RunActSound(m_nCurrentFrame - m_nStartFrame);
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);
  if m_boUseEffect then
  begin
    if m_boMsgMuch then
      m_dwEffectFrameTimetime := Round(m_dwEffectFrameTime * 2 / 3)
    else
      m_dwEffectFrameTimetime := m_dwEffectFrameTime;
    if GetTickCount - m_dwEffectStartTime > m_dwEffectFrameTimetime then
    begin
      if m_nEffectFrame < m_nEffectEnd then
      begin
        Inc(m_nEffectFrame);
        m_dwEffectStartTime := GetTickCount;
      end
      else
      begin
        m_boUseEffect := FALSE;
      end;
    end;
  end;

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then
  begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if m_boMsgMuch then
      m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
    else
      m_dwFrameTimetime := m_dwFrameTime;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then
    begin
      if m_nCurrentFrame < m_nEndFrame then
      begin
        Inc(m_nCurrentFrame);
        m_dwStartTime := GetTickCount;
      end
      else
      begin
        m_nCurrentAction := 0;
        BoUseDieEffect := FALSE;
      end;
      // ½ðÕÈÖ©Öë ÊÍ·Å±ùÅØÏøÄ§·¨
      if (m_nCurrentAction = SM_LIGHTING) and (m_nCurrentFrame - m_nStartFrame = 1) then
      begin
        PlayScene.NewMagic(self, ACTOR_EFFECTID, 102, 0, 0, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mtExplosion, TRUE, 0, bo11);
      end;
    end;
    m_nCurrentDefFrame := 0;
    m_dwDefFrameTime := GetTickCount;
    Inc(m_nMagicFrame);
    CreateMagicObject;
  end
  else
    DefaultFrameRun;

  if prv <> m_nCurrentFrame then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  m_BodyEffect.Run;
end;

{ TSnowy }

procedure TSnowy.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  m_nCurrentFrame := -1;
  m_nBodyOffset := GetOffset(m_wAppearance);
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    exit;

  case m_nCurrentAction of
    SM_FAIRYATTACKRATE, SM_LIGHTING:
      begin
        m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
        m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
        m_dwFrameTime := pm.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
        m_boUseEffect := TRUE;
        m_nEffectStart := 0;
        m_nEffectFrame := 0;
        m_nEffectEnd := 2;
        m_dwEffectStartTime := GetTickCount;
        m_dwEffectFrameTime := pm.ActAttack.ftime;
        m_nCurEffFrame := 0;
      end;
  else
    begin
      inherited;
    end;
  end;
end;

procedure TSnowy.LoadSurface;
var
  meff: TMagicEff;
begin
  inherited;
  case m_wAppearance of
    252:
      begin
        case m_nCurrentAction of
          SM_LIGHTING:
            begin // ±ù
              AttackEffectSurface := nil;
              if (m_nEffectFrame = 1) then
              begin
                meff := TObjectEffects.Create(self, g_WMagicImages, 3840, 10, 60, TRUE);
                meff.ImgLib := g_WMagicImages;
                PlayScene.m_EffectList.Add(meff);
                g_SoundManager.DXPlaySound(10330);
              end;
            end;
          SM_FAIRYATTACKRATE:
            begin // ÊÍ·Å¶¾Êõ
              AttackEffectSurface := nil;
              if (m_nEffectFrame = 1) then
              begin
                meff := TObjectEffects.Create(self, g_WMagicImages, 600, 10, 60, TRUE);
                meff.ImgLib := g_WMagicImages;
                PlayScene.m_EffectList.Add(meff);
                g_SoundManager.DXPlaySound(10060);
              end;
            end;
        end;
      end;
    253:
      begin
        case m_nCurrentAction of
          SM_LIGHTING:
            begin // ÃðÌì»ð
              AttackEffectSurface := nil;
              if (m_nEffectFrame = 1) then
              begin
                meff := TObjectEffects.Create(self, g_WMagic2Images, 130, 10, 60, TRUE);
                meff.ImgLib := g_WMagic2Images;
                PlayScene.m_EffectList.Add(meff);
                g_SoundManager.DXPlaySound(10450);
              end;
            end;
          SM_FAIRYATTACKRATE:
            begin // ÊÍ·Å¶¾Êõ
              AttackEffectSurface := nil;
              if (m_nEffectFrame = 1) then
              begin
                meff := TObjectEffects.Create(self, g_WMagicImages, 600, 10, 60, TRUE);
                meff.ImgLib := g_WMagicImages;
                PlayScene.m_EffectList.Add(meff);
                g_SoundManager.DXPlaySound(10060);
              end;
            end;
        end;
      end;
    254:
      begin
        case m_nCurrentAction of
          SM_LIGHTING:
            begin // º®±ùÕÆ
              AttackEffectSurface := nil;
              if (m_nEffectFrame = 1) then
              begin
                meff := TObjectEffects.Create(self, g_WMagic2Images, 400, 10, 60, TRUE);
                meff.ImgLib := g_WMagic2Images;
                PlayScene.m_EffectList.Add(meff);
                g_SoundManager.DXPlaySound(10390);
              end;
            end;
          SM_FAIRYATTACKRATE:
            begin // ÖÎÓúÊõ
              AttackEffectSurface := nil;
              if (m_nEffectFrame = 1) then
              begin
                meff := TObjectEffects.Create(self, g_WMagicImages, 200, 10, 60, TRUE);
                meff.ImgLib := g_WMagicImages;
                PlayScene.m_EffectList.Add(meff);
                g_SoundManager.DXPlaySound(10020);
              end;
            end;
        end;
      end;
  end;
end;

procedure TSnowy.Run;
var
  prv: Integer;
  m_dwEffectFrameTimetime, m_dwFrameTimetime: longword;
  bo11: Boolean;
begin
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then
    exit;

  m_boMsgMuch := FALSE;
  if MsgCount >= 2 then
    m_boMsgMuch := TRUE;
  //
  RunActSound(m_nCurrentFrame - m_nStartFrame);
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);
  if m_boUseEffect then
  begin
    if m_boMsgMuch then
      m_dwEffectFrameTimetime := Round(m_dwEffectFrameTime * 2 / 3)
    else
      m_dwEffectFrameTimetime := m_dwEffectFrameTime;
    if GetTickCount - m_dwEffectStartTime > m_dwEffectFrameTimetime then
    begin
      if m_nEffectFrame < m_nEffectEnd then
      begin
        Inc(m_nEffectFrame);
        m_dwEffectStartTime := GetTickCount;
      end
      else
      begin
        m_boUseEffect := FALSE;
      end;
    end;
  end;

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then
  begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if m_boMsgMuch then
      m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
    else
      m_dwFrameTimetime := m_dwFrameTime;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then
    begin
      if m_nCurrentFrame < m_nEndFrame then
      begin
        Inc(m_nCurrentFrame);
        m_dwStartTime := GetTickCount;
      end
      else
      begin
        m_nCurrentAction := 0;
        BoUseDieEffect := FALSE;
      end;
      Inc(m_nMagicFrame);
      CreateMagicObject;
      case m_wAppearance of
        252:
          begin
            // ÊÍ·Å±ùÅØÏøÄ§·¨
            if (m_btRace = 94) and (m_nCurrentAction = SM_LIGHTING) and (m_nCurrentFrame - m_nStartFrame = 1) then
            begin
              PlayScene.NewMagic(self, ACTOR_EFFECTID, 31, 0, 0, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mtExplosion, TRUE, 0, bo11);
              g_SoundManager.DXPlaySound(10332);
            end;
            // ÊÍ·ÅÊ©¶¾ÊõÄ§·¨
            if (m_btRace = 94) and (m_nCurrentAction = SM_FAIRYATTACKRATE) and (m_nCurrentFrame - m_nStartFrame = 1) then
            begin
              PlayScene.NewMagic(self, ACTOR_EFFECTID, 4, 0, 0, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mtExplosion, TRUE, 0, bo11);
              g_SoundManager.DXPlaySound(10062);
            end;
          end;
        253:
          begin
            // ÊÍ·ÅÃðÌì»ðÄ§·¨
            if (m_btRace = 94) and (m_nCurrentAction = SM_LIGHTING) and (m_nCurrentFrame - m_nStartFrame = 1) then
            begin
              PlayScene.NewMagic(self, ACTOR_EFFECTID, 34, 0, 0, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mtExplosion, TRUE, 0, bo11);
            end;
            // ÊÍ·ÅÊ©¶¾ÊõÄ§·¨
            if (m_btRace = 94) and (m_nCurrentAction = SM_FAIRYATTACKRATE) and (m_nCurrentFrame - m_nStartFrame = 1) then
            begin
              PlayScene.NewMagic(self, ACTOR_EFFECTID, 4, 0, 0, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mtExplosion, TRUE, 0, bo11);
              g_SoundManager.DXPlaySound(10062);
            end;
          end;
        254:
          begin
            // ÊÍ·Åº®±ùÕÆÄ§·¨
            if (m_btRace = 94) and (m_nCurrentAction = SM_LIGHTING) and (m_nCurrentFrame - m_nStartFrame = 1) then
            begin
              PlayScene.NewMagic(self, ACTOR_EFFECTID, 39, 0, 0, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mtFly, TRUE, 0, bo11);
              g_SoundManager.DXPlaySound(10391);
            end;
            // ÊÍ·ÅÖÎÓúÊõÄ§·¨
            if (m_btRace = 94) and (m_nCurrentAction = SM_FAIRYATTACKRATE) and (m_nCurrentFrame - m_nStartFrame = 1) then
            begin
              PlayScene.NewMagic(self, ACTOR_EFFECTID, 2, 0, 0, m_nCurrX, m_nCurrY, m_nTargetX, m_nTargetY, m_nTargetRecog, mtExplosion, TRUE, 0, bo11);
              g_SoundManager.DXPlaySound(10022);
            end;
          end;
      end;
    end;
    m_nCurrentDefFrame := 0;
    m_dwDefFrameTime := GetTickCount;
  end
  else
    DefaultFrameRun;

  if prv <> m_nCurrentFrame then
  begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  m_BodyEffect.Run;
end;

{ TBoxSpider }

procedure TBoxSpider.CalcActorFrame;
begin
  m_btDir := m_btDir mod 3;
  inherited CalcActorFrame;
end;

constructor TBoxSpider.Create;
begin
  inherited;
  EffectSurface := nil;
  m_boShowHealthBar := False;
end;

procedure TBoxSpider.DrawChr(dsurface: TAsphyreCanvas; dx, dy: integer; blend, boFlag: Boolean);
begin
  inherited;
  if m_boUseEffect then
  begin
    if EffectSurface <> nil then
    begin
      dsurface.DrawBlend(dx + m_nShiftX, dy + m_nShiftY, EffectSurface, 1);
    end;
  end;
end;

function TBoxSpider.GetDefaultFrame(wmode: Boolean): Integer;
begin
  m_btDir := m_btDir mod 3;
  Result := inherited GetDefaultFrame(wmode);
end;

procedure TBoxSpider.LoadSurface;
begin
  m_btDir := m_btDir mod 3;
  inherited LoadSurface;
  m_boUseEffect := FALSE;
end;

procedure TBoxSpider.Run();
begin
  m_btDir := m_btDir mod 3;
  inherited;
end;

{ TGrassSpider }

procedure TGrassSpider.CalcActorFrame;
begin
  m_btDir := 0;
  inherited CalcActorFrame;
end;

function TGrassSpider.GetDefaultFrame(wmode: Boolean): Integer;
begin
  m_btDir := 0;
  Result := inherited GetDefaultFrame(wmode);
end;

procedure TGrassSpider.LoadSurface;
begin
  m_btDir := 0;
  inherited LoadSurface;
  m_boUseEffect := FALSE;
end;

procedure TGrassSpider.Run;
begin
  m_btDir := 0;
  inherited;
end;

{ TMaterialMonster }

procedure TMaterialMonster.DrawBlood(dsurface: TAsphyreCanvas);
var
  d: TAsphyreLockableTexture;
  rc: TRect;
  Prc: Double;
begin
  if g_CollectCret <> Self then
    inherited
  else
  begin
    if not m_boDeath then
    begin
      d := g_77Images.Images[2];
      if d <> nil then
        dsurface.Draw(GetSayX() - d.Width div 2, GetSayY() - 10, d.ClientRect, d, TRUE);
      if GetTickCount < g_CollectTick then
      begin
        d := g_77Images.Images[3];
        if d <> nil then
        begin
          Prc := 1 - (g_CollectTick - GetTickCount) / g_CollectTime;
          rc := d.ClientRect;
          rc.Right := Round((rc.Right - rc.Left) * Prc);
          dsurface.Draw(GetSayX() - d.Width div 2, GetSayY() - 10, rc, d, TRUE);
          TextNum.DrawNumberMiddle(IntToStr(Round(Prc * 100)) + '%', dsurface, GetSayX(), GetSayY() - 24);
        end;
      end;
    end;
  end;
end;

end.
