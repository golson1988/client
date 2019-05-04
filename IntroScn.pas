unit IntroScn; // 游戏的引导场景，，比如选人,注册，，登录等,,与游戏的主场景构成游戏的整个场景

// 一般场景定义
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, StdCtrls, Controls, Forms,
  extctrls, FState, Grobal2, cliUtil, clFunc, SoundUtil, DWinCtl, DXHelper,
  AbstractCanvas, AbstractTextures, AbstractDevices, HUtil32, uTextures,
  Dialogs,AsphyreTypes,
  Math, Common,ExtUI;

const
  SELECTEDFRAME = 16; // selected frame 选人时点了左边或右边的角色此时会有人物动画，有16帧
  // 打开ChrSel.wil,,可以看到男54是40-55,,
  FREEZEFRAME = 13; // freeze frame 男54,,60-72,,共13帧

type
  TLoginState = (lsLogin, lsNewid, lsNewidRetry, lsChgpw, lsCloseAll);
  TSceneType = (stIntro, stLogin, stSelectCountry, stSelectChr, stNewChr,
    stLoading, stLoginNotice, stPlayGame);

  TSelChar = record
    Valid: Boolean;
    UserChr: TUserCharacterInfo;
    Selected: Boolean;
    FreezeState: Boolean;
    Unfreezing: Boolean;
    Freezing: Boolean;
    AniIndex: integer;
    DarkLevel: integer;
    EffIndex: integer;
    StartTime: longword;
    moretime: longword;
    startefftime: longword;
  end;

  PTSelChar = ^TSelChar;

  TScene = class
  private
  public
    SceneType: TSceneType;
    constructor Create(SceneType: TSceneType);
    destructor Destroy; override;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure OpenScene; virtual;
    procedure CloseScene; virtual;
    procedure OpeningScene; virtual;
    procedure KeyPress(var Key: Char); virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); virtual;
    procedure BeginScene(Device: TAsphyreDevice;
      MSurface: TAsphyreCanvas); virtual;
    procedure PlayScene(MSurface: TAsphyreCanvas); virtual;
  end;

  TIntroScene = class(TScene)
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure PlayScene(MSurface: TAsphyreCanvas); override;
  end;

  TCustomLoginScene = class(TScene)
  public
    m_sLoginId: String;
    m_sLoginPasswd: String;
    m_boUpdateAccountMode: Boolean;
    m_boNowOpening: Boolean;
    m_boOpenFirst: Boolean;
    m_NewIdRetryUE: TUserEntry;
    m_nCurFrame: integer;
    m_nMaxFrame: integer;
    m_dwStartTime: longword;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure ChangeLoginState(state: TLoginState); virtual;
    procedure NewClick; virtual;
    procedure NewIdRetry(boupdate: Boolean); virtual;
    procedure UpdateAccountInfos(ue: TUserEntry); virtual;
    function Login(const Id, Pass: String): Boolean;
    procedure ChgPwClick; virtual;
    procedure NewAccountOk; virtual;
    procedure NewAccountClose; virtual;
    procedure ChgpwOk; virtual;
    procedure ChgpwCancel; virtual;
    procedure HideLoginBox; virtual;
    procedure OpenLoginDoor; virtual;
    procedure PassWdFail; virtual;
    procedure initUI;virtual;
  end;

  TLoginScene = class(TCustomLoginScene)
  private
//    // 建立新ID对话框(新用户对话框)
//    m_EdNewId: TEdit;
//    m_EdNewPasswd: TEdit;
//    m_EdConfirm: TEdit;
//    m_EdYourName: TEdit;
//    m_EdSSNo: TEdit;
//    m_EdBirthDay: TEdit;
//    m_EdQuiz1: TEdit; // 密码提示问题1
//    m_EdAnswer1: TEdit;
//    m_EdQuiz2: TEdit;
//    m_EdAnswer2: TEdit;
//    m_EdPhone: TEdit;
//    m_EdMobPhone: TEdit;
//    m_EdEMail: TEdit;
//    // 密码修改
//    m_EdChgId: TEdit;
//    m_EdChgCurrentpw: TEdit;
//    m_EdChgNewPw: TEdit;
//    m_EdChgRepeat: TEdit;
    { ****************************************************************************** }
    procedure EdNewIdKeyPress(Sender: TObject; var Key: Char);
    procedure EdNewOnEnter(Sender: TObject ;Shift:TShiftState; X,Y:Integer);
    function CheckUserEntrys: Boolean;
    function NewIdCheckNewId: Boolean;
    function NewIdCheckBirthDay: Boolean;
  public
    m_sLoginId: String;
    m_sLoginPasswd: String;
    m_boUpdateAccountMode: Boolean;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure PlayScene(MSurface: TAsphyreCanvas); override;
    procedure ChangeLoginState(state: TLoginState); override;
    procedure NewClick; override;
    procedure NewIdRetry(boupdate: Boolean); override;
    procedure NewAccountOk; override;
    procedure ChgpwOk; override;
    procedure PassWdFail; override;
    procedure InitUI();override;
  end;

type
  THumPosition = record
    MinLeft: array[0..1] of TPoint;
    MinRight: array[0..1] of TPoint;
    MaxLeft: array[0..1] of TPoint;
    MaxRight: array[0..1] of TPoint;
    MinEffLeft: array[0..1] of TPoint;
    MinEffRight: array[0..1] of TPoint;
    MaxEffLeft: array[0..1] of TPoint;
    MaxEffRight: array[0..1] of TPoint;
  end;
  THumOffset = record
    MinLeft: array[0..1] of TPoint;
    MinRight: array[0..1] of TPoint;
    MaxLeft: array[0..1] of TPoint;
    MaxRight: array[0..1] of TPoint;
  end;

  {$REGION ' 新传奇角色坐标修正'}
const
  _JOB_SCR_POSITION:array[0..3] of THumPosition =
(
  //战
  (
   MinLeft:((X: 200; Y: 200), (X: 200; Y:140));
   MinRight:((X: 600; Y: 200), (X: 600; Y:140));
   MaxLeft:((X: 280; Y: 280), (X: 260; Y:210));
   MaxRight:((X: 760; Y: 280), (X: 750; Y:210));
   MinEffLeft:((X: 186; Y: 200), (X: 198; Y:206));
   MinEffRight:((X: 586; Y: 200), (X: 598; Y:206));
   MaxEffLeft:((X: 270; Y: 280), (X: 280; Y:280));
   MaxEffRight:((X: 745; Y: 283), (X: 750; Y:280));
  ),
  //法
  (
   MinLeft:((X: 200; Y: 200), (X: 200; Y:200));
   MinRight:((X: 600; Y: 200), (X: 600; Y:200));
   MaxLeft:((X: 280; Y: 280), (X: 280; Y:280));
   MaxRight:((X: 760; Y: 280), (X: 760; Y:280));
   MinEffLeft:((X: 186; Y: 140), (X: 200; Y:200));
   MinEffRight:((X: 568; Y: 140), (X: 600; Y:200));
   MaxEffLeft:((X: 246; Y: 220), (X: 280; Y:280));
   MaxEffRight:((X: 730; Y: 220), (X: 760; Y:280));
  ),
  //道
  (
   MinLeft:((X: 200; Y: 200), (X: 220; Y:200));
   MinRight:((X: 600; Y: 200), (X: 620; Y:200));
   MaxLeft:((X: 280; Y: 280), (X: 280; Y:280));
   MaxRight:((X: 760; Y: 280), (X: 760; Y:280));
   MinEffLeft:((X: 200; Y: 140), (X: 210; Y:140));
   MinEffRight:((X: 600; Y: 140), (X: 610; Y:140));
   MaxEffLeft:((X: 300; Y: 200), (X: 270; Y:220));
   MaxEffRight:((X: 780; Y: 200), (X: 750; Y:220));
  ),
  //刺
  (
   MinLeft:((X: 200; Y: 140), (X: 200; Y:140));
   MinRight:((X: 600; Y: 140), (X: 600; Y:140));
   MaxLeft:((X: 280; Y: 220), (X: 280; Y:220));
   MaxRight:((X: 760; Y: 220), (X: 760; Y:220));
   MinEffLeft:((X: 200; Y: 140), (X: 210; Y:140));
   MinEffRight:((X: 600; Y: 140), (X: 600; Y:140));
   MaxEffLeft:((X: 280; Y: 220), (X: 280; Y:220));
   MaxEffRight:((X: 760; Y: 220), (X: 760; Y:220));
  )
);
  _JOB_SCR_OFFSET:array[0..3] of THumOffset =
(
  //战
  (
   MinLeft:((X: 190; Y: 132), (X: 200; Y:140));
   MinRight:((X: 588; Y: 132), (X: 600; Y:140));
   MaxLeft:((X: 268; Y: 212), (X: 260; Y:210));
   MaxRight:((X: 750; Y: 212), (X: 740; Y:210));
  ),
  //法
  (
   MinLeft:((X: 171; Y: 139), (X: 206; Y:129));
   MinRight:((X: 571; Y: 139), (X: 606; Y:129));
   MaxLeft:((X: 251; Y: 220), (X: 286; Y:209));
   MaxRight:((X: 731; Y: 220), (X: 766; Y:209));
  ),
  //道
  (
   MinLeft:((X: 212; Y: 120), (X: 206; Y:132));
   MinRight:((X: 612; Y: 120), (X: 606; Y:132));
   MaxLeft:((X: 292; Y: 200), (X: 266; Y:212));
   MaxRight:((X: 772; Y: 200), (X: 746; Y:212));
  ),
  //刺
  (
   MinLeft:((X: 200; Y: 140), (X: 200; Y:140));
   MinRight:((X: 600; Y: 140), (X: 600; Y:140));
   MaxLeft:((X: 280; Y: 220), (X: 280; Y:220));
   MaxRight:((X: 760; Y: 220), (X: 760; Y:220));
  )
);
{$ENDREGION}

type
  TChrState = (csNormal,csFreeze,csUnfreeze,csStone,csCreateChr); //角色状态
  TSelectChrScene = class(TScene)
  private
    SoundTimer: TTimer;
    procedure SoundOnTimer(Sender: TObject);
    procedure EdChrnameKeyPress(Sender: TObject; var Key: Char);
    function Get(Index: integer): PTSelChar;
    function GetCount: integer;
    function GetStartCharIndex: integer;
    function GetEndCharIndex: integer;
    procedure InitUI_MirReturn();
    procedure InitUI_NewMir();
    procedure InitUI_Mir2();
    function PageCount():Integer;
    procedure SetPageChrCount(Count:Integer);
    //设置角色动画图库信息
    procedure SetJobLibAndAnimate();
    procedure SetJobLibAndAnimate_MirReturn();
    procedure SetJobLibAndAnimate_NewMir();
    procedure SetJobLibAndAnimate_Mir();



    function GetSelChrAniButton(Index:Integer):TDAniButton; //根据索引得到对应的AniButton
    function GetJobImageInfo(Job:BYte):TJobImageInfo;
    procedure FreezeFinished(Sender: TDControl); //动画框冻结完毕。
    procedure UnFreezeFinished(Sender : TDControl); //动画解冻完毕
    procedure ShowButtons(Visible: Boolean);
    procedure SetCharToUI(Chr:PTSelChar;UI:TDAniButton;ChrState:TChrState);//设置角色关联到UI
    //获取绘制角色偏移的函数
    procedure _GetDrawChrOffset_NewMir(dType:Byte;Chr:PTSelChar;index:Integer;out X,Y:Integer);
    procedure _GetDrawChrOffset_Mir2(dType:Byte;Chr:PTSelChar;index:Integer;out X,Y:Integer);
    procedure _GetDrawChrOffset_MirReturn(dType:Byte;Chr:PTSelChar;index:Integer;out X,Y:Integer);
    procedure GetDrawChrOffset(Chr:PTSelChar;index:Integer;out X,Y:Integer);
    procedure GetDrawChrEffOffset(Chr:PTSelChar;Index:Integer;out X,Y:Integer);
    procedure GetDrawChrFreezeOffset(Chr:PTSelChar;Index:Integer; out X,Y:Integer);

  protected
    FChars: TList;
  public
    NewIndex: integer;
    SelIndex: integer;
    PageIndex, MaxPage: integer;
    ShowPage: Boolean;
    MaxChrCount: integer;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure InitSceneUI; virtual;
    procedure OnDrawChrEffect(Sender: TObject; DSurface: TAsphyreCanvas);
    procedure OnCreateChrDrawEffect(Sender: TObject; DSurface: TAsphyreCanvas);
    procedure InitChrPage(PageIndex: integer); virtual;
    procedure SelChrSelectClick(Index: integer); virtual;
    procedure SetSelCharAni(Index: integer);
    procedure SelChrStartClick;
    procedure SelChrNewChrClick; virtual;
    procedure MakeNewChar(index: integer); virtual;
    procedure SelChrEraseChrClick; virtual;
    procedure SelChrCreditsClick; virtual;
    procedure SelChrExitClick; virtual;
    procedure SelChrNewOk; virtual;
    procedure SelChrNewClose; virtual;
    procedure SelChrNewJob(job: integer); virtual;
    procedure SelChrNewm_btSex(sex: integer); virtual;
    procedure SelChrNewPrevHair; virtual;
    procedure SelChrNewNextHair; virtual;
    procedure ClearChrs; virtual;
    procedure AddChr(uname: string; job, hair, level, sex: integer);
    procedure SelectChr(index: integer;ShowAni:Boolean = true);
    procedure SetMaxChrCount(V: integer);
    procedure IncPage;
    procedure DecPage;
    property Count: integer read GetCount;
    property CharCountOfAPage:Integer  read PageCount write SetPageChrCount;
    property Chars[Index: integer]: PTSelChar read Get;
    property StartCharIndex: integer read GetStartCharIndex;
    property EndCharIndex: integer read GetEndCharIndex;
  end;

  TLoginNotice = class(TScene)
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TMir3LoginNotice = class(TLoginNotice)

  end;

  TMir4LoginNotice = class(TLoginNotice)

  end;

implementation

uses
  AsphyreTextureFonts, ClMain, MShare, Share,WIL;

constructor TScene.Create(SceneType: TSceneType);
begin
  SceneType := SceneType;
end;

procedure TScene.Initialize;
begin
end;

procedure TScene.Finalize;
begin
end;

procedure TScene.OpenScene;
begin;
end;

procedure TScene.CloseScene;
begin;
end;

procedure TScene.OpeningScene;
begin
end;

procedure TScene.KeyPress(var Key: Char);
begin
end;

procedure TScene.KeyDown(var Key: Word; Shift: TShiftState);
begin
end;

procedure TScene.MouseMove(Shift: TShiftState; X, Y: integer);
begin
end;

procedure TScene.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
end;

procedure TScene.PlayScene(MSurface: TAsphyreCanvas);
begin
end;

procedure TScene.BeginScene(Device: TAsphyreDevice; MSurface: TAsphyreCanvas);
begin

end;

{ ------------------- TIntroScene ---------------------- }

// 游戏介绍场景（这里没有内容），一般用来播放片头动画
constructor TIntroScene.Create;
begin
  inherited Create(stIntro);
end;

destructor TIntroScene.Destroy;
begin
  inherited Destroy;
end;

procedure TIntroScene.OpenScene;
begin
end;

procedure TIntroScene.CloseScene;
begin
end;

procedure TIntroScene.PlayScene(MSurface: TAsphyreCanvas);
begin
end;

constructor TCustomLoginScene.Create;
begin
  inherited Create(stLogin);
end;

destructor TCustomLoginScene.Destroy;
begin

end;

procedure TCustomLoginScene.OpenScene;
begin
  m_boNowOpening := FALSE;
  g_SoundManager.PlayBGM(bmg_intro);
end;

procedure TCustomLoginScene.CloseScene;
begin
  g_SoundManager.SilenceSound;
end;

procedure TCustomLoginScene.ChangeLoginState(state: TLoginState);
begin

end;

procedure TCustomLoginScene.NewClick;
begin

end;

procedure TCustomLoginScene.NewIdRetry(boupdate: Boolean);
begin

end;

procedure TCustomLoginScene.UpdateAccountInfos(ue: TUserEntry);
begin
  m_NewIdRetryUE := ue;
  m_boUpdateAccountMode := TRUE;
  NewIdRetry(TRUE);
  FrmDlg.NewAccountTitle := '(请填写帐号相关信息。)';
end;

function TCustomLoginScene.Login(const Id, Pass: String): Boolean;
var
  Key: Char;
begin
  Result := FALSE;
  Key := #13;
  m_sLoginId := LowerCase(Id);
  m_sLoginPasswd := Pass;
  if (m_sLoginId <> '') and (m_sLoginPasswd <> '') then
  begin
    FrmMain.SendLogin(m_sLoginId, m_sLoginPasswd);
    Result := TRUE;
  end;
end;

procedure TCustomLoginScene.ChgPwClick;
begin
  ChangeLoginState(lsChgpw);
end;

procedure TCustomLoginScene.NewAccountOk;
begin
end;

procedure TCustomLoginScene.NewAccountClose;
begin
  if not m_boUpdateAccountMode then
    ChangeLoginState(lsLogin)
  else
    FrmMain.Close;
end;

procedure TCustomLoginScene.ChgpwOk;
begin

end;

procedure TCustomLoginScene.ChgpwCancel;
begin
  ChangeLoginState(lsLogin);
end;

procedure TCustomLoginScene.HideLoginBox;
begin
  ChangeLoginState(lsCloseAll);
end;

procedure TCustomLoginScene.initUI;
begin

end;

procedure TCustomLoginScene.OpenLoginDoor;
begin
  m_boNowOpening := TRUE;
  HideLoginBox;
  g_SoundManager.DXPlaySound(s_rock_door_open);
  FrmDlg.DAOpenDoor.Visible := TRUE;
end;

procedure TCustomLoginScene.PassWdFail;
begin

end;

{ --------------------- Login ---------------------- }

// 登录场景
constructor TLoginScene.Create;
begin
  inherited;

end;

destructor TLoginScene.Destroy;
begin
  inherited Destroy;
end;

procedure TLoginScene.OpenScene;
begin
  m_nCurFrame := 0;
  m_nMaxFrame := 10;
  m_sLoginId := '';
  m_sLoginPasswd := '';
  m_boOpenFirst := TRUE;

  FrmDlg.DLogin.Visible := TRUE;
  FrmDlg.DNewAccount.Visible := FALSE;
  FrmDlg.DELoginID.SetFocus;
  inherited;
  FrmDlg.DTAPP_Version.Propertites.Caption.Text := APP_VERSION;
end;

procedure TLoginScene.CloseScene;
begin
  inherited;
  FrmDlg.DLogin.Visible := FALSE;
end;

procedure TLoginScene.PassWdFail;
begin
  FrmDlg.DELoginPwd.SetFocus;
  FrmDlg.DELoginPwd.SelStart := Length(FrmDlg.DELoginPwd.Text);
  FrmDlg.DELoginPwd.SelLength := 0;
end;

function TLoginScene.NewIdCheckNewId: Boolean;
begin
  Result := TRUE;
  with FrmDlg do
  begin
    m_EdNewId.Text := Trim(m_EdNewId.Text);
    if Length(m_EdNewId.Text) < 3 then
    begin
      g_Application.AddMessageDialog('你的ID必须至少有4个字符且不能有空格。再输入一遍吧。', [mbOk]);
      Beep;
      m_EdNewId.SetFocus;
      Result := FALSE;
    end;
  end;
end;

function TLoginScene.NewIdCheckBirthDay: Boolean;
var
  str, syear, smon, sday: string;
  ayear, amon, aday: integer;
  flag: Boolean;
begin
  with FrmDlg do
  begin
    Result := TRUE;
    flag := TRUE;
    str := m_EdBirthDay.Text;
    str := GetValidStr3(str, syear, ['/']);
    str := GetValidStr3(str, smon, ['/']);
    str := GetValidStr3(str, sday, ['/']);
    ayear := Str_ToInt(syear, 0);
    amon := Str_ToInt(smon, 0);
    aday := Str_ToInt(sday, 0);
    if (ayear <= 1890) or (ayear > 2101) then
      flag := FALSE;
    if (amon <= 0) or (amon > 12) then
      flag := FALSE;
    if (aday <= 0) or (aday > 31) then
      flag := FALSE;
    if not flag then
    begin
      Beep;
      m_EdBirthDay.SetFocus;
      Result := FALSE;
    end;
  end;
end;

procedure TLoginScene.EdNewIdKeyPress(Sender: TObject; var Key: Char);
var
 C,D : TDControl;

begin
  with FrmDlg do
  begin
   if Key = #9 then
   begin
     C := TDControl(Sender);
     C.SelectNext;
    Exit;
   end;
    if (Sender = m_EdNewPasswd) or (Sender = m_EdChgNewPw) or
      (Sender = m_EdChgRepeat) then
      if (Key = '~') or (Key = '''') or (Key = ' ') then
        Key := #0;
    if Key = #13 then
    begin
      Key := #0;
      if Sender = m_EdNewId then
      begin
        if not NewIdCheckNewId then
          exit;
      end;
      if Sender = m_EdNewPasswd then
      begin
        if Length(m_EdNewPasswd.Text) < 4 then
        begin
          g_Application.AddMessageDialog('密码长度必须大于 4位.', [mbOk]);
          Beep;
          m_EdNewPasswd.SetFocus;
          exit;
        end;
      end;
      if Sender = m_EdConfirm then
      begin
        if m_EdNewPasswd.Text <> m_EdConfirm.Text then
        begin
          g_Application.AddMessageDialog('二次输入的密码不一至！！！', [mbOk]);
          Beep;
          m_EdConfirm.SetFocus;
          exit;
        end;
      end;
      if (Sender = m_EdYourName) or (Sender = m_EdQuiz1) or (Sender = m_EdAnswer1)
        or (Sender = m_EdQuiz2) or (Sender = m_EdAnswer2) or (Sender = m_EdPhone)
        or (Sender = m_EdMobPhone) or (Sender = m_EdEMail) then
      begin
        TEdit(Sender).Text := Trim(TEdit(Sender).Text);
        if TEdit(Sender).Text = '' then
        begin
          Beep;
          TEdit(Sender).SetFocus;
          exit;
        end;
      end;
      if Sender = m_EdBirthDay then
      begin
        if not NewIdCheckBirthDay then
          exit;
      end;
      if TEdit(Sender).Text <> '' then
      begin
        if Sender = m_EdNewId then
          m_EdNewPasswd.SetFocus;
        if Sender = m_EdNewPasswd then
          m_EdConfirm.SetFocus;
        if Sender = m_EdConfirm then
          m_EdYourName.SetFocus;
        if Sender = m_EdYourName then
          m_EdSSNo.SetFocus;
        if Sender = m_EdSSNo then
          m_EdBirthDay.SetFocus;
        if Sender = m_EdBirthDay then
          m_EdQuiz1.SetFocus;
        if Sender = m_EdQuiz1 then
          m_EdAnswer1.SetFocus;
        if Sender = m_EdAnswer1 then
          m_EdQuiz2.SetFocus;
        if Sender = m_EdQuiz2 then
          m_EdAnswer2.SetFocus;
        if Sender = m_EdAnswer2 then
          m_EdPhone.SetFocus;
        if Sender = m_EdPhone then
          m_EdMobPhone.SetFocus;
        if Sender = m_EdMobPhone then
          m_EdEMail.SetFocus;
        if Sender = m_EdEMail then
        begin
          if m_EdNewId.Enabled then
            m_EdNewId.SetFocus
          else if m_EdNewPasswd.Enabled then
            m_EdNewPasswd.SetFocus;
        end;

        if Sender = m_EdChgId then
          m_EdChgCurrentpw.SetFocus;
        if Sender = m_EdChgCurrentpw then
          m_EdChgNewPw.SetFocus;
        if Sender = m_EdChgNewPw then
          m_EdChgRepeat.SetFocus;
        if Sender = m_EdChgRepeat then
          m_EdChgId.SetFocus;
      end;
    end;
  end;
end;

procedure TLoginScene.EdNewOnEnter(Sender: TObject ;Shift:TShiftState; X,Y:Integer);
begin
  // 腮飘
  FrmDlg.NAHelps.Clear;
  with FrmDlg do
  begin
    if Sender = m_EdNewId then
    begin
      FrmDlg.NAHelps.Add('你的ID可以是以下内容的组合');
      FrmDlg.NAHelps.Add('字符和数字.');
      FrmDlg.NAHelps.Add('ID必须至少有4位.');
      FrmDlg.NAHelps.Add('你输入的名字是你游戏中角色的名字');
      FrmDlg.NAHelps.Add('请仔细选择你的ID');
      FrmDlg.NAHelps.Add('你的登陆名可以');
      FrmDlg.NAHelps.Add('用于我们所有的服务器.');
      FrmDlg.NAHelps.Add('');
      FrmDlg.NAHelps.Add('我建议你用一个不同的名字');
      FrmDlg.NAHelps.Add('和你想给游戏角色用的那个');
      FrmDlg.NAHelps.Add('区别开来.');
    end;
    if Sender = m_EdNewPasswd then
    begin
      FrmDlg.NAHelps.Add('你的密码可以是一个');
      FrmDlg.NAHelps.Add('组合，包括字符和数字，而且');
      FrmDlg.NAHelps.Add('它至少要有4位');
      FrmDlg.NAHelps.Add('把你的密码记住是玩');
      FrmDlg.NAHelps.Add('我们的游戏的最基本的要素');
      FrmDlg.NAHelps.Add('所以请确认你已经记好了它.');
      FrmDlg.NAHelps.Add('我们建议你最好不要用');
      FrmDlg.NAHelps.Add('一个简单的密码');
      FrmDlg.NAHelps.Add('已消除一些');
      FrmDlg.NAHelps.Add('不安定的因素');
    end;
    if Sender = m_EdConfirm then
    begin
      FrmDlg.NAHelps.Add('再次输入密码');
      FrmDlg.NAHelps.Add('以便确认.');
    end;
    if Sender = m_EdYourName then
    begin
      FrmDlg.NAHelps.Add('键入你的全名.');
    end;
    if Sender = m_EdSSNo then
    begin
      FrmDlg.NAHelps.Add('寸脚狼 林刮殿废锅龋甫 涝仿窍绞');
      FrmDlg.NAHelps.Add('矫坷. 抗) 720101-146720');
    end;
    if Sender = m_EdBirthDay then
    begin
      FrmDlg.NAHelps.Add('请键入你的出生日期和月份');
      FrmDlg.NAHelps.Add('年/月/日 1977/10/15');
    end;
    if (Sender = m_EdQuiz1) or (Sender = m_EdQuiz2) then
    begin
      FrmDlg.NAHelps.Add('请输入一个密码提示问题');
      FrmDlg.NAHelps.Add('请明确只有你本人才知道这个问题.');
    end;
    if (Sender = m_EdAnswer1) or (Sender = m_EdAnswer2) then
    begin
      FrmDlg.NAHelps.Add('请输入上面问题的');
      FrmDlg.NAHelps.Add('答案.');
    end;
    if (Sender = m_EdYourName) or (Sender = m_EdSSNo) or (Sender = m_EdQuiz1) or
      (Sender = m_EdQuiz2) or (Sender = m_EdAnswer1) or
      (Sender = m_EdAnswer2) then
    begin
      FrmDlg.NAHelps.Add('你必须输入正确');
      FrmDlg.NAHelps.Add('的信息');
      FrmDlg.NAHelps.Add('如果使用可错误的信息.');
      FrmDlg.NAHelps.Add('');
      FrmDlg.NAHelps.Add('你将不能接受');
      FrmDlg.NAHelps.Add('我们所有的服务');
      FrmDlg.NAHelps.Add('如果你提供了');
      FrmDlg.NAHelps.Add('错误信息，你的帐户 ');
      FrmDlg.NAHelps.Add('将被取消');
    end;

    if Sender = m_EdPhone then
    begin
      FrmDlg.NAHelps.Add('请键入你的电话');
      FrmDlg.NAHelps.Add('号码.');
    end;
    if Sender = m_EdMobPhone then
    begin
      FrmDlg.NAHelps.Add('请键入你的手机号码.');
    end;
    if Sender = m_EdEMail then
    begin
      FrmDlg.NAHelps.Add('请键入你的邮件地址，你的邮件 ');
      FrmDlg.NAHelps.Add('将被用于访问我们的一些服务器.');
      FrmDlg.NAHelps.Add('你能收到最近更新的一些信息');
    end;
  end;
end;

procedure TLoginScene.InitUI;
var
  nx,ny:Integer;
begin

//  nx := SCREENWIDTH div 2 - 320 { 192 }{ 79 };
//  ny := SCREENHEIGHT div 2 - 238 { 146 }{ 64 };
  nx := 0;
  ny := 0;

   with FrmDlg.m_EdNewId do
  begin
    Height := 16;
    Width := 116;
    Left := nx + 161;
    Top := ny + 116;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 11;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;

  with FrmDlg.m_EdNewPasswd do
  begin
    Height := 16;
    Width := 116;
    Left := nx + 161;
    Top := ny + 137;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 11;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;

  with FrmDlg.m_EdConfirm do
  begin
    Height := 16;
    Width := 116;
    Left := nx + 161;
    Top := ny + 158;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 11;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;

  with FrmDlg.m_EdYourName do
  begin
    Height := 16;
    Width := 116;
    Left := nx + 161;
    Top := ny + 187;
    Color := 1;
    Font.Color := clWhite;
    MaxLength := 20;
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 11;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;

  with FrmDlg.m_EdSSNo do
  begin
    Height := 16;
    Width := 116;
    Left := nx + 161;
    Top := ny + 207;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 14;
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 11;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;

  with FrmDlg.m_EdBirthDay do
  begin
    Height := 16;
    Width := 116;
    Left := nx + 161;
    Top := ny + 227;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 10;
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 11;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;

  with FrmDlg.m_EdQuiz1 do
  begin
    Height := 16;
    Width := 163;
    Left := nx + 161;
    Top := ny + 256;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 20;
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 11;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;

  with FrmDlg.m_EdAnswer1 do
  begin
    Height := 16;
    Width := 163;
    Left := nx + 161;
    Top := ny + 276;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 12;
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 11;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;

  with FrmDlg.m_EdQuiz2 do
  begin
    Height := 16;
    Width := 163;
    Left := nx + 161;
    Top := ny + 297;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 20;
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 11;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;

  with FrmDlg.m_EdAnswer2 do
  begin
    Height := 16;
    Width := 163;
    Left := nx + 161;
    Top := ny + 317;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 12;
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 11;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;

  with FrmDlg.m_EdPhone do
  begin
    Height := 16;
    Width := 116;
    Left := nx + 161;
    Top := ny + 347;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 14;
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 11;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;

  with FrmDlg.m_EdMobPhone do
  begin
    Height := 16;
    Width := 116;
    Left := nx + 161;
    Top := ny + 368;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 13;
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 11;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;

  with FrmDlg.m_EdEMail do
  begin
    Height := 16;
    Width := 163;
    Left := nx + 161;
    Top := ny + 388;
    Color := clBlack;
    Font.Color := clWhite;
    MaxLength := 40;
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 11;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;


//   nx := SCREENWIDTH div 2 - 210 { 192 }{ 192 };
//   ny := SCREENHEIGHT div 2 - 150 { 146 }{ 150 };
   nx := 0;
   ny := 0;
  with FrmDlg.m_EdChgId do
  begin
    Height := 16;
    Width := 137;
    Left := nx + 239;
    Top := ny + 117;
    Color := 1;
    Font.Color := clWhite;
    MaxLength := 10;
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 12;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;


  with FrmDlg.m_EdChgCurrentpw do
  begin
    Height := 16;
    Width := 137;
    Left := nx + 239;
    Top := ny + 149;
    Color := 1;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 12;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;


  with FrmDlg.m_EdChgNewPw do
  begin
    Height := 16;
    Width := 137;
    Left := nx + 239;
    Top := ny + 176;
    Color := 1;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 12;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;

  with FrmDlg.m_EdChgRepeat do
  begin
    Height := 16;
    Width := 137;
    Left := nx + 239;
    Top := ny + 208;
    Color := 1;
    Font.Color := clWhite;
    MaxLength := 10;
    PasswordChar := '*';
    OnKeyPress := EdNewIdKeyPress;
    OnMouseMove := EdNewOnEnter;
    Tag := 12;
    EnableFocus := True;
    Propertites.BlurColor := clBlack;
    Propertites.Color := clBlack;
    Propertites.Alpha := $FF;
  end;
end;


procedure TLoginScene.PlayScene(MSurface: TAsphyreCanvas);
var
  d: TAsphyreLockableTexture;
  X, Y: integer;
begin
  if m_boOpenFirst then
  begin
    m_boOpenFirst := FALSE;
    FrmDlg.DELoginID.SetFocus;
  end;

  X := (SCREENWIDTH - 800) div 2;
  Y := (SCREENHEIGHT - 600) div 2;
  // d := g_WChrSelImages.Images[102 - 80];
  // if d <> nil then
  // begin
  // MSurface.Draw(X, Y, d.ClientRect, d, FALSE);
  // end;

  // if m_boNowOpening then
  // begin
  // // 开门速度
  // if GetTickCount - m_dwStartTime > 35 then
  // begin
  // m_dwStartTime := GetTickCount;
  // Inc(m_nCurFrame);
  // end;
  //
  // if m_nCurFrame >= m_nMaxFrame - 1 then
  // begin
  // m_nCurFrame := m_nMaxFrame - 1;
  // if not g_boDoFadeOut and not g_boDoFadeIn then
  // begin
  // g_boDoFadeOut := TRUE;
  // g_boDoFadeIn := TRUE;
  // g_nFadeIndex := 29;
  // end;
  // end;
  // d := g_WChrSelImages.Images[103 + m_nCurFrame - 80];
  //
  // if d <> nil then
  // MSurface.Draw(X + 152 { 152 } , Y + 96 { 96 } , d.ClientRect, d, TRUE);
  //
  // if g_boDoFadeOut then
  // begin
  // if g_nFadeIndex <= 1 then
  // begin
  // g_WMainImages.ClearCache;
  // g_WChrSelImages.ClearCache;
  // DScreen.ChangeScene(stSelectChr); //
  // end;
  // end;
  // end;

  // MSurface.TextOut((SCREENWIDTH - 800) div 2 + 360, (SCREENHEIGHT - 600) div 2 + 535, '健康游戏公告', $0093F4F2);
  // MSurface.TextOut((SCREENWIDTH - 800) div 2 + 190, (SCREENHEIGHT - 600) div 2 + 553, '抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。适度游戏益脑，', $0093F4F2);
  // MSurface.TextOut((SCREENWIDTH - 800) div 2 + 190, (SCREENHEIGHT - 600) div 2 + 571, '沉迷游戏伤身。合理安排游戏，享受健康生活。严厉打击赌博，营造和谐环境。', $0093F4F2);
  // MSurface.TextOut(16, 16, APP_VERSION, clLime);
end;

procedure TLoginScene.ChangeLoginState(state: TLoginState);
var
  i, focus: integer;
  c: TControl;
begin
  focus := -1;
  case state of
    lsLogin:
      focus := 10;
    lsNewidRetry, lsNewid:
      focus := 11;
    lsChgpw:
      focus := 12;
    lsCloseAll:
      focus := -1;
  end;
  with FrmMain do
  begin // login
    if ControlCount > 0 then // 20080629
      for i := 0 to ControlCount - 1 do
      begin
        c := Controls[i];
        if c is TEdit then
        begin
          if c.Tag in [10 .. 12] then
          begin
            if c.Tag = focus then
            begin
              c.Visible := TRUE;
              TEdit(c).Text := '';
            end
            else
            begin
              c.Visible := FALSE;
              TEdit(c).Text := '';
            end;
          end;
        end;
      end;
    with FrmDlg do
    begin
      m_EdSSNo.Visible := FALSE;

      case state of
        lsLogin:
          begin
            FrmDlg.DNewAccount.Visible := FALSE;
            FrmDlg.DChgPw.Visible := FALSE;
            FrmDlg.DLogin.Visible := TRUE;
            FrmDlg.DELoginID.SetFocus;
          end;
        lsNewidRetry, lsNewid:
          begin
            if m_boUpdateAccountMode then
              m_EdNewId.Enabled := FALSE
            else
              m_EdNewId.Enabled := TRUE;
            FrmDlg.DNewAccount.Visible := TRUE;
            FrmDlg.DChgPw.Visible := FALSE;
            FrmDlg.DLogin.Visible := FALSE;
            if m_EdNewId.Visible and m_EdNewId.Enabled then
            begin
              m_EdNewId.SetFocus;
            end
            else
            begin
              if m_EdConfirm.Visible and m_EdConfirm.Enabled then
                m_EdConfirm.SetFocus;
            end;
          end;
        lsChgpw:
          begin
            FrmDlg.DNewAccount.Visible := FALSE;
            FrmDlg.DChgPw.Visible := TRUE;
            FrmDlg.DLogin.Visible := FALSE;
            if m_EdChgId.Visible then
              m_EdChgId.SetFocus;
          end;
        lsCloseAll:
          begin
            FrmDlg.DNewAccount.Visible := FALSE;
            FrmDlg.DChgPw.Visible := FALSE;
            FrmDlg.DLogin.Visible := FALSE;
          end;
      end;
    end;
  end;
end;

procedure TLoginScene.NewClick;
begin
  m_boUpdateAccountMode := FALSE;
  FrmDlg.NewAccountTitle := '';
  ChangeLoginState(lsNewid);
end;

procedure TLoginScene.NewIdRetry(boupdate: Boolean);
begin
  m_boUpdateAccountMode := boupdate;
  ChangeLoginState(lsNewidRetry);
  with FrmDlg do
  begin
    m_EdNewId.Text := m_NewIdRetryUE.sAccount;
    m_EdNewPasswd.Text := m_NewIdRetryUE.sPassword;
    m_EdYourName.Text := m_NewIdRetryUE.sUserName;
    m_EdSSNo.Text := m_NewIdRetryUE.sSSNo;
    m_EdQuiz1.Text := m_NewIdRetryUE.sQuiz;
    m_EdAnswer1.Text := m_NewIdRetryUE.sAnswer;
    m_EdPhone.Text := m_NewIdRetryUE.sPhone;
    m_EdEMail.Text := m_NewIdRetryUE.sEMail;
    m_EdQuiz2.Text := m_NewIdRetryUE.sQuiz2;
    m_EdAnswer2.Text := m_NewIdRetryUE.sAnswer2;
    m_EdMobPhone.Text := m_NewIdRetryUE.sMobilePhone;
    m_EdBirthDay.Text := m_NewIdRetryUE.sBirthDay;
  end;
end;

procedure TLoginScene.NewAccountOk;
var
  ue: TUserEntry;
begin
  with FrmDlg do
  begin
    if CheckUserEntrys then
    begin
      FillChar(ue, sizeof(TUserEntry), #0);
      ue.sAccount := LowerCase(m_EdNewId.Text);
      ue.sPassword := m_EdNewPasswd.Text;
      ue.sUserName := m_EdYourName.Text;
      ue.sSSNo := '650101-1455111';
      ue.sQuiz := m_EdQuiz1.Text;
      ue.sAnswer := Trim(m_EdAnswer1.Text);
      ue.sPhone := m_EdPhone.Text;
      ue.sEMail := Trim(m_EdEMail.Text);

      ue.sQuiz2 := m_EdQuiz2.Text;
      ue.sAnswer2 := Trim(m_EdAnswer2.Text);
      ue.sBirthDay := m_EdBirthDay.Text;
      ue.sMobilePhone := m_EdMobPhone.Text;

      m_NewIdRetryUE := ue; // 犁矫档锭 荤侩
      m_NewIdRetryUE.sAccount := '';
      m_NewIdRetryUE.sPassword := '';

      if not m_boUpdateAccountMode then
        FrmMain.SendNewAccount(ue)
      else
        FrmMain.SendUpdateAccount(ue);
      m_boUpdateAccountMode := FALSE;
      NewAccountClose;
    end;
  end;
end;

function TLoginScene.CheckUserEntrys: Boolean;
begin
  Result := FALSE;
  with FrmDlg do
  begin
    m_EdNewId.Text := Trim(m_EdNewId.Text);
    m_EdQuiz1.Text := Trim(m_EdQuiz1.Text);
    m_EdYourName.Text := Trim(m_EdYourName.Text);
    if not NewIdCheckNewId then
      exit;

    if not NewIdCheckBirthDay then
      exit;
    if Length(m_EdNewId.Text) < 3 then
    begin
      m_EdNewId.SetFocus;
      exit;
    end;
    if Length(m_EdNewPasswd.Text) < 3 then
    begin
      m_EdNewPasswd.SetFocus;
      exit;
    end;
    if m_EdNewPasswd.Text <> m_EdConfirm.Text then
    begin
      m_EdConfirm.SetFocus;
      exit;
    end;
    if Length(m_EdQuiz1.Text) < 1 then
    begin
      m_EdQuiz1.SetFocus;
      exit;
    end;
    if Length(m_EdAnswer1.Text) < 1 then
    begin
      m_EdAnswer1.SetFocus;
      exit;
    end;
    if Length(m_EdQuiz2.Text) < 1 then
    begin
      m_EdQuiz2.SetFocus;
      exit;
    end;
    if Length(m_EdAnswer2.Text) < 1 then
    begin
      m_EdAnswer2.SetFocus;
      exit;
    end;
    if Length(m_EdYourName.Text) < 1 then
    begin
      m_EdYourName.SetFocus;
      exit;
    end;
    Result := TRUE;
  end;
end;

procedure TLoginScene.ChgpwOk;
var
  uid, passwd, newpasswd: string;
begin
  With FrmDlg do
  begin
    if m_EdChgNewPw.Text = m_EdChgRepeat.Text then
    begin
      uid := m_EdChgId.Text;
      passwd := m_EdChgCurrentpw.Text;
      newpasswd := m_EdChgNewPw.Text;
      FrmMain.SendChgPw(uid, passwd, newpasswd);
      ChgpwCancel;
    end
    else
    begin
      g_Application.AddMessageDialog('两次输入的新密码不一致，请重新输入。', [mbOk]);
      m_EdChgNewPw.SetFocus;
    end;
  end;
end;

{ TSelectChrScene }

constructor TSelectChrScene.Create;
begin
  NewIndex := 0;
  SelIndex := -1;
  SoundTimer := TTimer.Create(nil);
  with SoundTimer do
  begin
    OnTimer := SoundOnTimer;
    Interval := 1;
    Enabled := FALSE;
  end;
  PageIndex := 1;
  MaxPage := 1;
  ShowPage := TRUE;
  MaxChrCount := 2;
  FChars := TList.Create;
  inherited Create(stSelectChr);
end;


destructor TSelectChrScene.Destroy;
begin
  FreeAndNilEx(SoundTimer);
  ClearChrs;
  FreeAndNilEx(FChars);
  inherited Destroy;
end;

procedure TSelectChrScene.SoundOnTimer(Sender: TObject);
begin

end;

procedure TSelectChrScene.UnFreezeFinished(Sender: TDControl);
var
  Chr :PTSelChar;
  J:TJobImageInfo;
  Button : TDAniButton;
begin
  Chr := Sender.Data;
  J := GetJobImageInfo(Chr.UserChr.Job);
  Button := TDAniButton(Sender);
  SetCharToUI(Chr,Button,csNormal);
end;


procedure TSelectChrScene._GetDrawChrOffset_Mir2(dType: Byte; Chr: PTSelChar;
  index: Integer; out X, Y: Integer);
begin
  X := 0;
  Y := 0;
  case dType of
   1:begin
     if (Chr.UserChr.sex  <> 0)  and  (Chr.UserChr.Job in [1,2]) then
     begin
       if Chr.UserChr.Job = 1 then
       begin
         X := 60;
         Y := 36;
       end else if Chr.UserChr.Job = 2 then
       begin
         X := 80;
         Y := 30;
       end;
     end else if Chr.UserChr.Job = 3 then
     begin
       if (Chr.UserChr.sex  = 0) then
       begin
         X := 80;
         Y := 60;
       end else
       begin
         X := 30;
         Y := 80;
       end;
     end;
   end;
   2:
   begin

   end;
   3:
   begin
     if Chr.UserChr.Job = 3 then
     begin
       if (Chr.UserChr.sex  = 0) then
       begin
         X := 80;
         Y := 60;
       end else
       begin
         X := 30;
         Y := 80;
       end;
     end;

     if (Chr.UserChr.Job in [1,2]) and (Chr.UserChr.sex  = 1) then
     begin

       if Chr.UserChr.Job = 1 then
       begin
         X := 90;
         Y := 50;
       end else if Chr.UserChr.Job = 2 then
       begin
         X := 103;
         Y := 50;
       end;
     end;

   end;
  end;
end;

procedure TSelectChrScene._GetDrawChrOffset_MirReturn(dType: Byte;
  Chr: PTSelChar; index: Integer; out X, Y: Integer);
begin

end;

procedure TSelectChrScene._GetDrawChrOffset_NewMir(dType: Byte; Chr: PTSelChar;
  index: Integer; out X, Y: Integer);
var
  APosition: THumPosition;
  ALeft,ATop:Integer;
  LX, LY, OX, OY, EffX, EffY, EffOX, EffOY, FOX, FOY: Integer;
  AOffset: THumOffset;
begin
  APosition := _JOB_SCR_POSITION[Chr.UserChr.Job];
  AOffset := _JOB_SCR_OFFSET[Chr.UserChr.Job];

  case DISPLAYSIZETYPE of
    0:
    begin
      case index mod PageCount of
        0:
        begin
          LX := APosition.MaxLeft[Chr.UserChr.sex].X;
          LY := APosition.MaxLeft[Chr.UserChr.sex].Y;
          EffX := APosition.MaxEffLeft[Chr.UserChr.sex].X;
          EffY := APosition.MaxEffLeft[Chr.UserChr.sex].Y;
          FOX := AOffset.MaxLeft[Chr.UserChr.sex].X;
          FOY := AOffset.MaxLeft[Chr.UserChr.sex].Y;
        end;
        1:
        begin
          LX := APosition.MaxRight[Chr.UserChr.sex].X;
          LY := APosition.MaxRight[Chr.UserChr.sex].Y;
          EffX := APosition.MaxEffRight[Chr.UserChr.sex].X;
          EffY := APosition.MaxEffRight[Chr.UserChr.sex].Y;
          FOX := AOffset.MaxRight[Chr.UserChr.sex].X;
          FOY := AOffset.MaxRight[Chr.UserChr.sex].Y;
        end;
      end;
    end;
    1,2:
    begin
      case index mod PageCount of
        0:
        begin
          LX := APosition.MinLeft[Chr.UserChr.sex].X;
          LY := APosition.MinLeft[Chr.UserChr.sex].Y;
          EffX := APosition.MinEffLeft[Chr.UserChr.sex].X;
          EffY := APosition.MinEffLeft[Chr.UserChr.sex].Y;
          FOX := AOffset.MinLeft[Chr.UserChr.sex].X;
          FOY := AOffset.MinLeft[Chr.UserChr.sex].Y;
        end;
        1:
        begin
          LX := APosition.MinRight[Chr.UserChr.sex].X;
          LY := APosition.MinRight[Chr.UserChr.sex].Y;
          EffX := APosition.MinEffRight[Chr.UserChr.sex].X;
          EffY := APosition.MinEffRight[Chr.UserChr.sex].Y;
          FOX := AOffset.MinRight[Chr.UserChr.sex].X;
          FOY := AOffset.MinRight[Chr.UserChr.sex].Y;
        end;
      end;
    end;
  end;

  case dType of
    1:begin
      X := LX;
      Y := LY;
    end;
    2:begin
      X := EffX;
      Y := EffY;
      if Index = 0 then
      begin
        X := X - 114;
        Y := Y - 105;
      end else if Index = 1 then
      begin
        X := X - 600;
        Y := Y - 110;
      end;
    end;
    3: begin
      X := FOX;
      Y := FOY;
    end;
  end;

end;

procedure TSelectChrScene.FreezeFinished(Sender: TDControl);
var
  Chr :PTSelChar;
  J:TJobImageInfo;
  Button : TDAniButton;
begin
  Chr := Sender.Data;
  J := GetJobImageInfo(Chr.UserChr.Job);
  Button := TDAniButton(Sender);
  SetCharToUI(Chr,Button,csStone);
end;

procedure TSelectChrScene.MakeNewChar(index: integer);
var
  AChar: PTSelChar;
begin
  if (Count > 0) and not(Chars[Count - 1].Valid) then
    NewIndex := Count - 1
  else
  begin
    NewIndex := Count;
    New(AChar);
    FillChar(AChar^, sizeof(AChar^), 0);
    AChar.FreezeState := TRUE;
    AChar.Freezing := FALSE;
    AChar.Unfreezing := FALSE;
    AChar.Selected := FALSE;
    AChar.Valid := TRUE;
    FChars.Add(AChar);
  end;
  FillChar(Chars[NewIndex].UserChr, sizeof(TUserCharacterInfo), #0);
  SelectChr(NewIndex);

  SetCharToUI(Chars[NewIndex],FrmDlg.DANewChr,csCreateChr);

  FrmDlg.DCreateChr.Visible := TRUE;
  FrmDlg.DEChrName.Text := '';
  FrmDlg.DEChrName.SetFocus;


  ShowButtons(False);
end;

procedure TSelectChrScene.EdChrnameKeyPress(Sender: TObject;
  var Key: Char);
begin

end;

function TSelectChrScene.Get(Index: integer): PTSelChar;
begin
  Result := nil;
  if (Index >= 0) and (Index < FChars.Count) then
    Result := FChars[Index];
end;

function TSelectChrScene.GetCount: integer;
begin
  Result := FChars.Count;
end;

procedure TSelectChrScene.GetDrawChrEffOffset(Chr: PTSelChar;index:Integer; out X,
  Y: Integer);
begin
  case FrmDlg.DSelectChr.SelChrWinProperites.ChrOffsetType of
    cofNone:
    begin
      X := 0;
      Y := 0;
    end;
    cofMir: _GetDrawChrOffset_Mir2(2,Chr,Index,X,Y);
    cofNewMir: _GetDrawChrOffset_NewMir(2,Chr,Index,X,Y);
    cofMirReturn:_GetDrawChrOffset_MirReturn(2,Chr,Index,X,Y);
  end;
end;

procedure TSelectChrScene.GetDrawChrFreezeOffset(Chr: PTSelChar;index:Integer; out X,
  Y: Integer);
begin
  case FrmDlg.DSelectChr.SelChrWinProperites.ChrOffsetType of
    cofNone:
    begin
      X := 0;
      Y := 0;
    end;
    cofMir: _GetDrawChrOffset_Mir2(3,Chr,Index,X,Y);
    cofNewMir: _GetDrawChrOffset_NewMir(3,Chr,Index,X,Y);
    cofMirReturn:_GetDrawChrOffset_MirReturn(3,Chr,Index,X,Y);
  end;
end;

procedure TSelectChrScene.GetDrawChrOffset(Chr: PTSelChar;index:Integer; out X, Y: Integer);
begin
  case FrmDlg.DSelectChr.SelChrWinProperites.ChrOffsetType of
    cofNone:
    begin
      X := 0;
      Y := 0;
    end;
    cofMir: _GetDrawChrOffset_Mir2(1,Chr,Index,X,Y);
    cofNewMir: _GetDrawChrOffset_NewMir(1,Chr,Index,X,Y);
    cofMirReturn:_GetDrawChrOffset_MirReturn(1,Chr,Index,X,Y);
  end;
end;

function TSelectChrScene.GetSelChrAniButton(Index: Integer): TDAniButton;
var
  nStartIndex,nEndIndex : Integer;
begin
  Result := nil;
  nStartIndex := GetStartCharIndex;
  nEndIndex := nStartIndex + PageCount;
  if (Index >= nStartIndex) and ( Index < nEndIndex) then
  begin
    if Index < FChars.Count then
      Result := FrmDlg.ChrAnis[Index mod PageCount];
  end;
end;

function TSelectChrScene.GetStartCharIndex: integer;
begin
  Result := Max(0, (PageIndex - 1) * PageCount);
end;

function TSelectChrScene.GetEndCharIndex: integer;
begin
  Result := GetStartCharIndex + PageCount - 1;
end;

function TSelectChrScene.GetJobImageInfo(Job: BYte): TJobImageInfo;
begin
  Result := nil;
  With FrmDlg.DSelectChr.SelChrWinProperites do
  begin
     case Job of
        _JOB_WAR: Result := JobWarriorIndex;
        _JOB_MAG: Result := JobWizardIndex;
        _JOB_DAO: Result := JobTaoistIndex;
        _JOB_CIK: Result := JobAssassinIndex;
        _JOB_ARCHER: Result := JobArcherIndex;
        _JOB_SHAMAN: Result := JobMonkInde;
      end;
  end;
end;

procedure TSelectChrScene.OnCreateChrDrawEffect(Sender: TObject;
  DSurface: TAsphyreCanvas);
var
  UI : TDAniButton;
  Chr:PTSelChar;
  JobIndex:TJobImageInfo;
  Image :TWMImages;
  ImageIndex : Integer;
  D:TAsphyreLockableTexture;
  nPx,nPy:Integer;
  nOffsetX,nOffsetY:Integer;
  ALeft,ATop : Integer;
begin
//  if FrmDlg.DSelectChr.SelChrWinProperites.DrawChrEffect = false then
//    Exit;
  ALeft := (SCREENWIDTH - FrmDlg.DPanelSelChrBGP.Width) div 2;
  ATop := (SCREENHEIGHT - FrmDlg.DPanelSelChrBGP.Height) div 2;

  UI := TDAniButton(Sender);
  Chr := UI.Data;
  JobIndex := GetJobImageInfo(chr.UserChr.Job);

  LibManager.TryGetLib(JobIndex.Lib,Image);
  if Image <> nil then
  begin
    if Chr.UserChr.sex = 0 then
      ImageIndex := JobIndex.MaleActionEffectIndex
    else
      ImageIndex := JobIndex.FeMaleActionEffectIndex;

    ImageIndex := UI.FrameIndex + ImageIndex;
    D := Image.GetCachedImage(ImageIndex,nPx,nPy);
    nOffsetX := 0;
    nOffsetY := 0;
    //GetDrawChrEffOffset(Chr,UI.Tag,nOffsetX,nOffsetY);
    if D <> nil then
    begin
      with UI do
      begin
       DSurface.Draw(ALeft + SurfaceX(Left) + nOffsetX + nPx, ATop +  SurfaceY(Top) + nPy + nOffsetY, D, clWhite4,
        beSrcColorAdd);
      end;
    end;
  end;
end;

procedure TSelectChrScene.OnDrawChrEffect(Sender: TObject;
  DSurface: TAsphyreCanvas);
var
  UI : TDAniButton;
  Chr:PTSelChar;
  JobIndex:TJobImageInfo;
  Image :TWMImages;
  ImageIndex : Integer;
  D:TAsphyreLockableTexture;
  nPx,nPy:Integer;
  nOffsetX,nOffsetY:Integer;
  ALeft,ATop : Integer;
begin
  if FrmDlg.DSelectChr.SelChrWinProperites.DrawChrEffect = false then
    Exit;
  ALeft := (SCREENWIDTH - FrmDlg.DPanelSelChrBGP.Width) div 2;
  ATop := (SCREENHEIGHT - FrmDlg.DPanelSelChrBGP.Height) div 2;

  UI := TDAniButton(Sender);
  Chr := UI.Data;
  JobIndex := GetJobImageInfo(chr.UserChr.Job);

  LibManager.TryGetLib(JobIndex.Lib,Image);
  if Image <> nil then
  begin
    if Chr.UserChr.sex = 0 then
      ImageIndex := JobIndex.MaleEffectIndex
    else
      ImageIndex := JobIndex.FemaleEffectIndex;

    ImageIndex := UI.FrameIndex + ImageIndex;
    D := Image.GetCachedImage(ImageIndex,nPx,nPy);
    GetDrawChrEffOffset(Chr,UI.Tag,nOffsetX,nOffsetY);
    if D <> nil then
    begin
      with UI do
      begin
       DSurface.Draw(ALeft + SurfaceX(Left) + nOffsetX + nPx, ATop +  SurfaceY(Top) + nPy + nOffsetY, D, clWhite4,
        beSrcColorAdd);
      end;
    end;
  end;
end;

procedure TSelectChrScene.OpenScene;
begin
  SoundTimer.Enabled := TRUE;
  SoundTimer.Interval := 1;
  FrmDlg.DSelectChr.ChangeChildOrder(FrmDlg.DscStart, FALSE);
  FrmDlg.DSelectChr.ChangeChildOrder(FrmDlg.DscNewChr, FALSE);
  FrmDlg.DSelectChr.ChangeChildOrder(FrmDlg.DscEraseChr, FALSE);
  FrmDlg.DSelectChr.ChangeChildOrder(FrmDlg.DscCredits, FALSE);
  FrmDlg.DSelectChr.ChangeChildOrder(FrmDlg.DscExit, FALSE);
  FrmDlg.DSelectChr.Visible := TRUE;
  FrmDlg.DTServerName.Propertites.Caption.Text := g_sServerName;
end;

function TSelectChrScene.PageCount: Integer;
begin
  Result := FrmDlg.DSelectChr.SelChrWinProperites.CharCountAPage;
end;

procedure TSelectChrScene.CloseScene;
begin
  g_SoundManager.SilenceSound;
  SoundTimer.Enabled := FALSE;
  FrmDlg.DSelectChr.Visible := FALSE;
  FrmDlg.DCreateChr.Visible := FALSE;
end;

procedure TSelectChrScene.SelChrSelectClick(Index: integer);
var
  i: integer;
  Button:TDAniButton;
  J:TJobImageInfo;
begin
  Index := StartCharIndex + Index;
  if SelIndex = Index  then
    Exit;
  if not FrmDlg.DCreateChr.Visible and (Chars[Index] <> nil) and
    not Chars[Index].Selected and Chars[Index].Valid then
  begin
    SelIndex := Index;
    Chars[Index].Selected := TRUE;
    Chars[Index].Unfreezing := TRUE;
    Chars[Index].Freezing := FALSE;
    Chars[Index].AniIndex := 0;
    Chars[Index].DarkLevel := 0;
    Chars[Index].EffIndex := 0;
    Chars[Index].StartTime := GetTickCount;
    Chars[Index].moretime := GetTickCount;
    Chars[Index].startefftime := GetTickCount;
    g_SoundManager.DXPlaySound(s_meltstone);

    for i := 0 to Count - 1 do
    begin
      if i <> Index then
      begin
        if Chars[i].Selected then
        begin
          Chars[i].Freezing := TRUE;
          Chars[i].AniIndex := 0;
          Chars[i].EffIndex := 0;
          if FrmDlg.DSelectChr.SelChrWinProperites.NotSelectChrFreeze then
          begin
            Button := GetSelChrAniButton(i);
            if Button <> nil then
              SetCharToUI(Chars[i],Button,csFreeze);
          end;

        end;
        Chars[i].Unfreezing := FALSE;
        Chars[i].Selected := FALSE;
      end;
    end;
    if FrmDlg.DSelectChr.SelChrWinProperites.NotSelectChrFreeze then
    begin
      Button := GetSelChrAniButton(Index);
      if Button <> nil then
        SetCharToUI(Chars[Index],Button,csUnfreeze);
    end;
  end;
  SelectChr(Index);
  SetSelCharAni(Index);
end;

procedure TSelectChrScene.SelChrStartClick;
begin
  if (Chars[SelIndex] <> nil) and Chars[SelIndex].Valid and
    Chars[SelIndex].Selected then
  begin
    if not FrmDlg.DCreateChr.Visible then
      FrmMain.SendSelChr(Chars[SelIndex].UserChr.Name);
  end
  else
    g_Application.AddMessageDialog
      ('当前没有可选择的角色。\<创建角色>按钮可以打开创建角色对话框以便创建新的角色。', [mbOk]);
end;

procedure TSelectChrScene.SelChrNewChrClick;
begin
  if Count < MaxChrCount then
  begin
    MakeNewChar(Count);
    exit;
  end;
  g_Application.AddMessageDialog
    (Format('你最多可以创建{S=%d;C=249}个角色。\你可以先删除已有的角色再创建新的角色。', [MaxChrCount]
    ), [mbOk]);
end;

procedure TSelectChrScene.SelChrEraseChrClick;
begin
  if (Chars[SelIndex] <> nil) and (Chars[SelIndex].Valid) and
    (not Chars[SelIndex].FreezeState) and
    (Chars[SelIndex].UserChr.Name <> '') then
  begin
    g_Application.AddMessageDialog('“' + Chars[SelIndex].UserChr.Name +
      '” 删除的角色是不能被恢复的,\一段时间内您将不能使用相同的角色名称.\你真的确定要删除吗？', [mbYes, mbNo],
      procedure(AResult: integer)begin if AResult = mrYes then FrmMain.
      SendDelChr(Chars[SelIndex].UserChr.Name); end);
  end;
end;

procedure TSelectChrScene.SelChrCreditsClick;
begin
  FrmMain.SendQueryDelChr();
end;

procedure TSelectChrScene.SelChrExitClick;
begin
  FrmMain.Close;
end;

procedure TSelectChrScene.SelChrNewClose;
begin
  if (NewIndex >= 0) and (NewIndex < FChars.Count) then
  begin
    FreeMem(FChars[NewIndex]);
    FChars.Delete(NewIndex);
  end;
  FrmDlg.DCreateChr.Visible := FALSE;
  SelectChr(NewIndex - 1);

  ShowButtons(True);
  InitChrPage(PageIndex);
end;

procedure TSelectChrScene.SelChrNewJob(job: integer);
begin
  if (job in [_JOB_WAR .. _JOB_SHAMAN]) and
    (Chars[NewIndex].UserChr.job <> job) then
  begin
    if job = _JOB_SHAMAN then
      Chars[NewIndex].UserChr.sex := 0;

    Chars[NewIndex].UserChr.job := job;
    SelectChr(NewIndex);
    SetCharToUI(Chars[NewIndex],FrmDlg.DANewChr,csCreateChr);
  end;
end;

procedure TSelectChrScene.SelChrNewm_btSex(sex: integer);
begin
  if sex <> Chars[NewIndex].UserChr.sex then
  begin
    if Chars[NewIndex].UserChr.job = _JOB_SHAMAN then
      sex := 0;
    Chars[NewIndex].UserChr.sex := sex;
    SelectChr(NewIndex);
    SetCharToUI(Chars[NewIndex],FrmDlg.DANewChr,csCreateChr);
  end;
end;

procedure TSelectChrScene.SelChrNewPrevHair;
begin

end;

procedure TSelectChrScene.SelChrNewNextHair;
begin

end;

procedure TSelectChrScene.SelChrNewOk;
var
  AChrName, AShair, ASjob, ASsex: string;
  i: integer;
  AJobOK: Boolean;
begin
  AChrName := Trim(FrmDlg.DEChrName.Text);
  if Length(AChrName) < 2 then
  begin
    g_Application.AddMessageDialog('角色名不能少于两个字符', [mbOk]);
    exit;
  end;
  for i := 1 to Length(AChrName) do
  begin
    if CharInSet(AChrName[i], ['/', '\', '@', ';', ',', '?', '.', '<', '>', '{',
      '}', '*', '(', ')', '%', #32, Char($3000)]) then
    begin
      g_Application.AddMessageDialog('名称包含了非法字符', [mbOk]);
      exit;
    end;
  end;

  if (AChrName <> '') and (Chars[NewIndex].UserChr.job
    in [_JOB_WAR .. _JOB_SHAMAN]) then
  begin
    AJobOK := FALSE;
    case Chars[NewIndex].UserChr.job of
      _JOB_WAR:
        AJobOK := cjWAR in g_ServerJobs;
      _JOB_MAG:
        AJobOK := cjMAG in g_ServerJobs;
      _JOB_DAO:
        AJobOK := cjDAO in g_ServerJobs;
      _JOB_CIK:
        AJobOK := cjCIK in g_ServerJobs;
      _JOB_ARCHER:
        AJobOK := cjARCHER in g_ServerJobs;
      _JOB_SHAMAN:
        AJobOK := cjShaman in g_ServerJobs;
    end;
    if AJobOK then
    begin
      Chars[NewIndex].Valid := FALSE;
      FrmDlg.DCreateChr.Visible := FALSE;
      AShair := IntToStr(2);
      ASjob := IntToStr(Chars[NewIndex].UserChr.job);
      ASsex := IntToStr(Chars[NewIndex].UserChr.sex);
      FrmMain.SendNewChr(FrmMain.LoginId, AChrName, AShair, ASjob, ASsex);
      if NewIndex > 0 then
        SelectChr(NewIndex,False);
    end
    else
      g_Application.AddMessageDialog
        ('服务器不允许创建“' + GetJobName(Chars[NewIndex].UserChr.job) +
        '”职业的角色', [mbOk]);
  end;

  ShowButtons(True);
end;


procedure TSelectChrScene.ClearChrs;
var
  i: integer;
begin
  for i := 0 to FChars.Count - 1 do
  begin
    if FChars[i] <> nil then
      FreeMem(FChars[i]);
  end;
  FChars.Clear;
end;

procedure TSelectChrScene.AddChr(uname: string;
  job, hair, level, sex: integer);
var
  i: integer;
  AChar: PTSelChar;
begin
  New(AChar);
  FillChar(AChar^, sizeof(AChar^), 0);
  AChar.UserChr.Name := uname;
  AChar.UserChr.job := job;
  AChar.UserChr.hair := hair;
  AChar.UserChr.level := level;
  AChar.UserChr.sex := sex;
  AChar.FreezeState := TRUE;
  AChar.Freezing := FALSE;
  AChar.Unfreezing := FALSE;
  AChar.Selected := FALSE;
  AChar.Valid := TRUE;
  FChars.Add(AChar);
end;

procedure TSelectChrScene.SelectChr(index: integer;ShowAni:Boolean = true);
var
  i: integer;
  UI:TDAniButton;
begin
  if (Index < 0) or (index >= FChars.Count) then
    Exit;
  //    index := 0;
  for i := 0 to FChars.Count - 1 do
  begin
    if i = index then
    begin
      PTSelChar(FChars[i]).Selected := TRUE;
      PTSelChar(FChars[i]).DarkLevel := 30;
      PTSelChar(FChars[i]).FreezeState := FALSE;
      PTSelChar(FChars[i]).StartTime := GetTickCount;
      PTSelChar(FChars[i]).moretime := GetTickCount;
      SelIndex := i;
    end
    else
    begin
      PTSelChar(FChars[i]).Selected := FALSE;
      PTSelChar(FChars[i]).FreezeState := TRUE;
    end;
  end;

  PageIndex := Ceil((index + 1) / PageCount);
  MaxPage := Max(Ceil(Count / PageCount),1);
  if ShowAni then
    SetSelCharAni(Index mod PageCount );
end;

procedure TSelectChrScene.SetCharToUI(Chr: PTSelChar; UI: TDAniButton;
  ChrState: TChrState);
var
  JobIndex : TJobImageInfo;
  ImgIdx : Integer;
  Image : TWMImages;
  ALeft,ATop:Integer;
  LX, LY,  FOX, FOY: Integer;
label
  NormalState;
begin
  ALeft := (SCREENWIDTH - FrmDlg.DPanelSelChrBGP.Width) div 2;
  ATop := (SCREENHEIGHT - FrmDlg.DPanelSelChrBGP.Height) div 2;

  GetDrawChrOffset(Chr,UI.Tag,LX,LY);
  GetDrawChrFreezeOffset(Chr,UI.Tag,FOX,FOY);
  JobIndex := GetJobImageInfo(Chr.UserChr.Job);

  if LibManager.TryGetLib(JobIndex.Lib,Image) then
  begin
    case ChrState of
      csNormal: begin
NormalState:
        if Chr.UserChr.sex = 0 then
          ImgIdx := JobIndex.MaleIndex
        else
          ImgIdx := JobIndex.FemaleIndex;

        case FrmDlg.DSelectChr.SelChrWinProperites.ChrUIOffsetType of
          coaCenter:begin
            UI.Propertites.OffsetX := (ALeft - UI.Left)+  LX;
            UI.Propertites.OffsetY := (ATop - UI.Top) +  LY;
          end;
          coaPosition:
          begin
            UI.Propertites.OffsetX :=  LX;
            UI.Propertites.OffsetY :=  LY;
          end;
        end;



        UI.Propertites.AniLoop := True;
        UI.SetImgIndexNoWH(Image,ImgIdx);
        UI.Propertites.AniInterval := JobIndex.AniTick;
        UI.Propertites.AniCount := JobIndex.AniCount;
        UI.OnAniFinished := nil;

        UI.OnDirectPaint := Self.OnDrawChrEffect;

      end;
      csFreeze:
      begin
        if Chr.UserChr.sex = 0 then
          ImgIdx := JobIndex.MaleFreezeIndex
        else
          ImgIdx := JobIndex.FemalFreezeIndex;

        UI.SetImgIndexNoWH(Image,ImgIdx);
        UI.Propertites.AniInterval := JobIndex.FreezeFrameTick;
        UI.Propertites.AniCount := JobIndex.FreezeAniCount;
        UI.Propertites.AniLoop := False;

        UI.OnAniFinished := FreezeFinished;


        case FrmDlg.DSelectChr.SelChrWinProperites.ChrUIOffsetType of
          coaCenter:
          begin
            UI.Propertites.OffsetX := (ALeft - UI.Left)+  FOX;
            UI.Propertites.OffsetY := (ATop - UI.Top) +  FOY;
          end;
          coaPosition:
          begin
            UI.Propertites.OffsetX := FOX;
            UI.Propertites.OffsetY := FOY;
          end;
        end;

        UI.OnDirectPaint := nil;
      end;
      csUnfreeze:
      begin

        if Chr.UserChr.sex = 0 then
          ImgIdx := JobIndex.MaleUnFreezeIndex
        else
          ImgIdx := JobIndex.FemaleUnFreezeIndex;

        UI.SetImgIndexNoWH(Image,ImgIdx);
        UI.Propertites.AniInterval := JobIndex.UnFreezeFrameTick;
        UI.Propertites.AniCount := JobIndex.UnFreezeAniCount;

        UI.Propertites.AniLoop := False;
        UI.OnAniFinished := UnFreezeFinished;

        case FrmDlg.DSelectChr.SelChrWinProperites.ChrUIOffsetType of
          coaCenter:
          begin
            UI.Propertites.OffsetX := (ALeft - UI.Left)+  FOX;
            UI.Propertites.OffsetY := (ATop - UI.Top) +  FOY;
          end;
          coaPosition:
          begin
            UI.Propertites.OffsetX := FOX;
            UI.Propertites.OffsetY := FOY;
          end;
        end;

        UI.OnDirectPaint := nil;
      end;
      csStone:
      begin

        if Chr.UserChr.sex = 0 then
          ImgIdx := JobIndex.MaleUnFreezeIndex
        else
          ImgIdx := JobIndex.FemaleUnFreezeIndex;

        UI.SetImgIndexNoWH(Image,ImgIdx);
        UI.Propertites.AniInterval := JobIndex.UnFreezeFrameTick;

        UI.Propertites.AniCount := 1;
        UI.Propertites.AniLoop := True;
        UI.OnAniFinished := nil;

        case FrmDlg.DSelectChr.SelChrWinProperites.ChrUIOffsetType of
          coaCenter:begin
            UI.Propertites.OffsetX := (ALeft - UI.Left)+  FOX;
            UI.Propertites.OffsetY := (ATop - UI.Top) +  FOY;
          end;
          coaPosition:
          begin
            UI.Propertites.OffsetX := FOX;
            UI.Propertites.OffsetY := FOY;
          end;
        end;

        UI.OnDirectPaint := nil;
      end;
      csCreateChr:
      begin
        if FrmDlg.DSelectChr.SelChrWinProperites.CreateChrActrion = chaNormal  then
          Goto NormalState;

        if Chr.UserChr.sex = 0 then
          ImgIdx := JobIndex.MaleActionIndex
        else
          ImgIdx := JobIndex.FeMaleActionIndex;

        UI.SetImgIndexNoWH(Image,ImgIdx);

        if Chr.UserChr.sex = 0 then
        begin
          UI.Propertites.AniInterval := JobIndex.MaleActionFrameTick;
          UI.Propertites.AniCount := JobIndex.MaleActionAniCount;
        end
        else
        begin
          UI.Propertites.AniInterval := JobIndex.FeMaleActionFrameTick;
          UI.Propertites.AniCount := JobIndex.FeMaleActionAniCount;
        end;

        if FrmDlg.DSelectChr.SelChrWinProperites.CreateChrActrion = chaActionToNormal  then
        begin
          UI.Propertites.AniLoop := False;
          UI.OnAniFinished := UnFreezeFinished;
        end else
        begin
          UI.Propertites.AniLoop := True;
          UI.OnAniFinished := nil;
        end;

        case FrmDlg.DSelectChr.SelChrWinProperites.ChrUIOffsetType of
          coaCenter:begin
            UI.Propertites.OffsetX := (ALeft - UI.Left)+  LX;
            UI.Propertites.OffsetY := (ATop - UI.Top) +  LY;
          end;
          coaPosition:
          begin
            UI.Propertites.OffsetX :=  LX;
            UI.Propertites.OffsetY :=  LY;
          end;
        end;

        UI.OnDirectPaint := OnCreateChrDrawEffect;
      end;
    end;
  end;

  if (FrmDlg.DSelectChr.SelChrWinProperites.ChrOffsetType = cofNone) or
    (FrmDlg.DSelectChr.SelChrWinProperites.ChrUIOffsetType = coaNone) then
  begin
    UI.Propertites.OffsetX := 0;
    UI.Propertites.OffsetY := 0;
  end;

  UI.ResetAniFrame;
  UI.Data := Chr;
end;

procedure TSelectChrScene.SetJobLibAndAnimate;
begin
  case g_DWinMan.UIType of
    skReturn:SetJobLibAndAnimate_MirReturn;
    skMir4:SetJobLibAndAnimate_NewMir;
    skNormal:SetJobLibAndAnimate_Mir;
  end;
end;

procedure TSelectChrScene.SetJobLibAndAnimate_Mir;
  procedure  _Set(ChrImage:TJobImageInfo;MaleIndex,FemaleIndex:Integer);
  begin
    ChrImage.Lib := g_WChrSelImages.FileName;
    ChrImage.AniCount := 16;
    ChrImage.MaleIndex := MaleIndex;
    ChrImage.FemaleIndex := FemaleIndex;
    ChrImage.AniTick := 100;

    ChrImage.FreezeAniCount := -13;
    ChrImage.FemalFreezeIndex := FemaleIndex + 20 + 13 - 1;
    ChrImage.MaleFreezeIndex := MaleIndex + 20 + 13 - 1;
    ChrImage.FreezeFrameTick := 80;

    ChrImage.UnFreezeAniCount := 13;
    ChrImage.FemaleUnFreezeIndex := FemaleIndex + 20;
    ChrImage.MaleUnFreezeIndex := MaleIndex + 20 ;
    ChrImage.UnFreezeFrameTick := 80;

  end;
begin
  with FrmDlg.DSelectChr.SelChrWinProperites do
  begin
    _Set(JobWarriorIndex,40,160);
    _Set(JobWizardIndex,80,200);
    _Set(JobTaoistIndex,120,240);
    _Set(JobAssassinIndex,280,320);
  end;
end;

procedure TSelectChrScene.SetJobLibAndAnimate_MirReturn;
  procedure  _SetSmall(ChrImage:TJobImageInfo;Job:Byte);
  begin
    ChrImage.Lib := g_WChrSel2Images.FileName;
    ChrImage.AniCount := 13;
    ChrImage.MaleIndex := 600 + Job * 120;
    ChrImage.FemaleIndex := 600 + Job * 120 + 60;
    ChrImage.AniTick := 100;

    if Job = _JOB_SHAMAN then
    begin
      ChrImage.MaleIndex := 3160;
      ChrImage.AniCount := 15;
    end;
  end;

  procedure  _SetBig(ChrImage:TJobImageInfo;Job:Byte);
  begin
    ChrImage.Lib := g_WChrSel2Images.FileName;
    ChrImage.AniCount := 13;
    ChrImage.MaleIndex := Job * 120;;
    ChrImage.FemaleIndex := Job * 120 + 60;
    ChrImage.AniTick := 100;

    if Job = _JOB_SHAMAN then
    begin
      ChrImage.MaleIndex := 3080;
      ChrImage.AniCount := 15;
    end;
  end;

  procedure  _SetCrateAction(ChrImage:TJobImageInfo;MaleIndex,MaleImageCount,MaleEffectIndex,FemaleIndex,FemaleImageCount,FemaleEffectIndex:Integer);
  begin
    ChrImage.MaleActionAniCount := MaleImageCount;
    ChrImage.MaleActionFrameTick := 80;
    ChrImage.MaleActionIndex := MaleIndex;

    ChrImage.FeMaleActionAniCount := FeMaleImageCount;
    ChrImage.FeMaleActionFrameTick := 80;
    ChrImage.FeMaleActionIndex := FemaleIndex;

    ChrImage.MaleActionEffectIndex := MaleEffectIndex;
    ChrImage.FemaleActionEffectIndex := FemaleEffectIndex;
  end;

  procedure SetBigCreateChr();
  begin
        with FrmDlg.DSelectChr.SelChrWinProperites do
    begin
      _SetCrateAction(JobWarriorIndex,20,21,1200,80,25,1260);
      _SetCrateAction(JobWizardIndex,140,24,1320,200,25,1380);
      _SetCrateAction(JobTaoistIndex,260,25,1440,320,25,1500);
      _SetCrateAction(JobAssassinIndex,380,25,1560,440,25,1620);
      _SetCrateAction(JobArcherIndex,500,25,1680,560,250,1740);
      _SetCrateAction(JobMonkInde,3020,25,3050,0,0,0);
    end;
  end;

  procedure SetSmallCreateChr();
  begin
        with FrmDlg.DSelectChr.SelChrWinProperites do
    begin
      _SetCrateAction(JobWarriorIndex,620,21,1230,680,25,1290);
      _SetCrateAction(JobWizardIndex,740,24,1350,800,25,1410);
      _SetCrateAction(JobTaoistIndex,860,25,1470,1120,25,1530);
      _SetCrateAction(JobAssassinIndex,980,25,1590,1040,25,1650);
      _SetCrateAction(JobArcherIndex,1100,25,1710,1160,250,1770);
      _SetCrateAction(JobMonkInde,3100,25,3130,0,0,0);
    end;
  end;

begin
  if DISPLAYSIZETYPE = 0 then
  begin
    with FrmDlg.DSelectChr.SelChrWinProperites do
    begin
      _SetBig(JobWarriorIndex,_JOB_WAR);
      _SetBig(JobWizardIndex,_JOB_MAG);
      _SetBig(JobTaoistIndex,_JOB_DAO);
      _SetBig(JobAssassinIndex,_JOB_CIK);
      _SetBig(JobArcherIndex,_JOB_ARCHER);
      _SetBig(JobMonkInde,_JOB_SHAMAN);
    end;
  end else
  begin
    with FrmDlg.DSelectChr.SelChrWinProperites do
    begin
      _SetSmall(JobWarriorIndex,_JOB_WAR);
      _SetSmall(JobWizardIndex,_JOB_MAG);
      _SetSmall(JobTaoistIndex,_JOB_DAO);
      _SetSmall(JobAssassinIndex,_JOB_CIK);
      _SetSmall(JobArcherIndex,_JOB_ARCHER);
      _SetSmall(JobMonkInde,_JOB_SHAMAN);
    end;
  end;

  Case DISPLAYSIZETYPE of
  0:begin
    SetBigCreateChr;
  end;
  2,1:begin
    SetSmallCreateChr;
  end;
  end;
end;

procedure TSelectChrScene.SetJobLibAndAnimate_NewMir;
    procedure  _Set(ChrImage:TJobImageInfo;Job:Integer);
  begin
    ChrImage.Lib := g_WNSelectImages.FileName;
    ChrImage.AniCount := 12;
    ChrImage.MaleIndex := Job * 80;
    ChrImage.FemaleIndex := Job * 80 + 40;
    ChrImage.AniTick := 100;

    //冻结角色 应该是倒序的
    ChrImage.FreezeAniCount := -12;
    ChrImage.FreezeFrameTick := 80;
    ChrImage.MaleFreezeIndex := Job * 80 + 20 + 12 - 1;
    ChrImage.FemalFreezeIndex := Job * 80  + 40 + 20 + 12 - 1;

    //解冻角色
    ChrImage.UnFreezeAniCount := 12;
    ChrImage.UnFreezeFrameTick := 80;
    ChrImage.MaleUnFreezeIndex:= Job * 80 + 20 ;
    ChrImage.FemaleUnFreezeIndex := Job * 80  + 40 + 20;

    ChrImage.MaleEffectIndex := Job * 40 + 320;
    ChrImage.FemaleEffectIndex := Job * 40 + 320 + 20;
  end;
begin
  with FrmDlg.DSelectChr.SelChrWinProperites do
  begin
    _Set(JobWarriorIndex,_JOB_WAR);
    _Set(JobWizardIndex,_JOB_MAG);
    _Set(JobTaoistIndex,_JOB_DAO);
    _Set(JobAssassinIndex,_JOB_CIK);
    _Set(JobArcherIndex,_JOB_ARCHER);
    _Set(JobArcherIndex,_JOB_SHAMAN);
  end;
end;

procedure TSelectChrScene.SetMaxChrCount(V: integer);
begin
  if V > 0 then
    MaxChrCount := V;
  ShowPage := MaxChrCount > PageCount;
end;

procedure TSelectChrScene.SetPageChrCount(Count: Integer);
var
  i: Integer;
begin
  Count := Max(0,Count);
  Count := Min(5,Count);

  for i := 0 to 5 - 1 do
  begin
    FrmDlg.ChrInfoPanel[i].Visible := False;
  end;

  for i := 0 to Count - 1 do
  begin
    FrmDlg.ChrInfoPanel[i].Visible := True
  end;

  FrmDlg.DSelectChr.SelChrWinProperites.CharCountAPage := Count;
end;

procedure TSelectChrScene.SetSelCharAni(Index: integer);
var
  Ani:TDAniButton;
begin
  if FrmDlg.DSelectChr.SelChrWinProperites.ChrOffsetType = cofMirReturn then
  begin
    case Index of
      0:
        begin
          FrmDlg.DAChrFoucs.Left :=
            (FrmDlg.DscSelect1.Left + FrmDlg.DscSelect1.Width div 2) -
            (FrmDlg.DAChrFoucs.Width div 2);
          FrmDlg.DAChrFoucs.Top := FrmDlg.DscSelect1.Top +
            FrmDlg.DscSelect1.Height - FrmDlg.DAChrFoucs.Height;
        end;
      1:
        begin
          FrmDlg.DAChrFoucs.Left :=
            (FrmDlg.DscSelect2.Left + FrmDlg.DscSelect2.Width div 2) -
            (FrmDlg.DAChrFoucs.Width div 2);
          FrmDlg.DAChrFoucs.Top := FrmDlg.DscSelect2.Top +
            FrmDlg.DscSelect2.Height - FrmDlg.DAChrFoucs.Height;
        end;
      2:
        begin
          FrmDlg.DAChrFoucs.Left :=
            (FrmDlg.DscSelect3.Left + FrmDlg.DscSelect3.Width div 2) -
            (FrmDlg.DAChrFoucs.Width div 2);
          FrmDlg.DAChrFoucs.Top := FrmDlg.DscSelect3.Top +
            FrmDlg.DscSelect3.Height - FrmDlg.DAChrFoucs.Height;
        end;
      3:
        begin
          FrmDlg.DAChrFoucs.Left :=
            (FrmDlg.DscSelect4.Left + FrmDlg.DscSelect4.Width div 2) -
            (FrmDlg.DAChrFoucs.Width div 2);
          FrmDlg.DAChrFoucs.Top := FrmDlg.DscSelect4.Top +
            FrmDlg.DscSelect4.Height - FrmDlg.DAChrFoucs.Height;
        end;
      4:
        begin
          FrmDlg.DAChrFoucs.Left :=
            (FrmDlg.DscSelect5.Left + FrmDlg.DscSelect5.Width div 2) -
            (FrmDlg.DAChrFoucs.Width div 2);
          FrmDlg.DAChrFoucs.Top := FrmDlg.DscSelect5.Top +
            FrmDlg.DscSelect5.Height - FrmDlg.DAChrFoucs.Height;
        end;
    end;

    FrmDlg.DAChrFoucs.Visible := not FrmDlg.DCreateChr.Visible;
  end else if FrmDlg.DSelectChr.SelChrWinProperites.ChrOffsetType = cofNewMir then
  begin
//    case Index of
//      0:
//      begin
//        FrmDlg.DAChrFoucs.Left := 152;
//        FrmDlg.DAChrFoucs.Top := 106;
//      end;
//      1:
//      begin
//        FrmDlg.DAChrFoucs.Left := 641;
//        FrmDlg.DAChrFoucs.Top := 98;
//      end;
//    end;
//    FrmDlg.DAChrFoucs.ResetAniFrame;
    FrmDlg.DAChrFoucs.Visible := False;
  end else if FrmDlg.DSelectChr.SelChrWinProperites.ChrOffsetType = cofMir then
  begin
    if (not FrmDlg.DAChrFoucs.Visible) and ( not FrmDlg.DCreateChr.Visible)then
    begin
      Ani := GetSelChrAniButton(Index);
      if Ani <> nil then
      begin
        case Ani.Tag of
          0:
          begin
            FrmDlg.DAChrFoucs.Left := 75;
            FrmDlg.DAChrFoucs.Top := 85;
          end;
          1:
          begin
            FrmDlg.DAChrFoucs.Left := 420;
            FrmDlg.DAChrFoucs.Top := 85;
          end;
        end;
        FrmDlg.DAChrFoucs.ResetAniFrame;
        FrmDlg.DAChrFoucs.Visible := True;
      end;
    end;
  end;

end;

procedure TSelectChrScene.ShowButtons(Visible: Boolean);
var
  i: Integer;
begin
  FrmDlg.DscSelect1.Visible := Visible;
  FrmDlg.DscSelect2.Visible := Visible;
  FrmDlg.DscSelect3.Visible := Visible;
  FrmDlg.DscSelect4.Visible := Visible;
  FrmDlg.DscSelect5.Visible := Visible;
  FrmDlg.DscStart.Visible := Visible;
  FrmDlg.DscNewChr.Visible := Visible;
  FrmDlg.DscEraseChr.Visible := Visible;
  FrmDlg.DscCredits.Visible := Visible;
  FrmDlg.DscExit.Visible := Visible;
  FrmDlg.DscPriorPage.Visible := Visible;
  FrmDlg.DscNextPage.Visible := Visible;
  FrmDlg.DTChrPage.Visible := Visible;

  for i := 0 to PageCount - 1 do
  begin
    FrmDlg.ChrInfoPanel[i].Visible := Visible;
    FrmDlg.ChrAnis[i].Visible := Visible;
    FrmDlg.ChrSelectButton[i].Visible := Visible;
  end;

  FrmDlg.DANewChr.Visible := not Visible;
  if not Visible then
  begin
    FrmDlg.DAChrFoucs.Visible := False;
  end;
end;

procedure TSelectChrScene.IncPage;
begin
  if ShowPage  then
  begin
    if (PageIndex < MaxPage) then
    begin
      PageIndex := PageIndex + 1;
      SelectChr(Max(0, (PageIndex - 1) * PageCount),False);
      InitChrPage(PageIndex );
    end;
  end;
end;

procedure TSelectChrScene.InitChrPage(PageIndex: integer);
var
  nStartIndex, nEndIndex, i, ImgIdx: integer;
  AChar: PTSelChar;
  A: integer;
  JobIndex : TJobImageInfo;
  Image: TWMImages;
begin
  nStartIndex := GetStartCharIndex();
  nEndIndex := Min(nStartIndex + PageCount - 1, FChars.Count - 1);
  FrmDlg.DTChrPage.Propertites.Caption.Text := Format('%d/%d', [PageIndex, MaxPage]);

  for i := 0 to 4 do
  begin
    FrmDlg.ChrAnis[i].Visible := False;
    FrmDlg.ChrInfoPanel[I].Visible := False;
  end;

  A := 0;
  for i := nStartIndex to nEndIndex do
  begin
    ImgIdx := 0;
    AChar := PTSelChar(FChars[i]);

    JobIndex := GetJobImageInfo(AChar.UserChr.Job);
    LibManager.TryGetLib(JobIndex.Lib,Image);
    if Image <> nil then
    begin
      if AChar.UserChr.sex = 0 then
        ImgIdx := JobIndex.MaleIndex
      else
        ImgIdx := JobIndex.FemaleIndex;

      if A in [0..5] then
      begin
        if FrmDlg.DSelectChr.SelChrWinProperites.NotSelectChrFreeze then
        begin
          if AChar.Selected then
             SetCharToUI(AChar,FrmDlg.ChrAnis[A],csNormal)
          else
            SetCharToUI(AChar,FrmDlg.ChrAnis[A],csStone);
        end else
        begin
          SetCharToUI(AChar,FrmDlg.ChrAnis[A],csNormal);
        end;

        FrmDlg.ChrAnis[A].Visible := TRUE;
        FrmDlg.ChrLevel[A].Propertites.Caption.Text := IntToStr(AChar.UserChr.Level);
        FrmDlg.ChrNames[A].Propertites.Caption.Text := AChar.UserChr.Name;
        FrmDlg.ChrJobName[A].Propertites.Caption.Text := GetJobName(AChar.UserChr.job);
        FrmDlg.ChrInfoPanel[A].Visible := True;
      end;

    end;

    Inc(A);
  end;
end;

procedure TSelectChrScene.InitSceneUI;
begin

    case g_DWinMan.UIType of
      skReturn:
        InitUI_MirReturn();
      skMir4:
        InitUI_NewMir();
      skNormal:
        InitUI_Mir2();
    end;

    SetJobLibAndAnimate();

end;

procedure TSelectChrScene.InitUI_Mir2;
procedure _SetColor(D:TDControl);
var
  i : Integer;
begin
  for I := 0 to D.DControls.Count - 1 do
  begin
    if D.DControls[i] is TDTextField then
    begin
      TDTextField(D.DControls[i]).Propertites.Caption.Color := clWhite;
    end;

  end;
end;
var
  W, H, LX, LY, ALeft, ATop, Idx: integer;
  d: TAsphyreLockableTexture;
begin
   CharCountOfAPage := 2;

  d := g_WMainImages.Images[65];
  ALeft := 0;
  ATop := 0;
  if d <> nil then
  begin
    ALeft := (SCREENWIDTH - d.Width) div 2;
    ATop := (SCREENHEIGHT - d.Height) div 2;
  end;

  FrmDlg.DSelectChr.SelChrWinProperites.NotSelectChrFreeze := True;
  FrmDlg.DPanelSelChrBGP.SetImgIndex(g_WMainImages, 65);

  with FrmDlg do
  begin
    DPanelSelChrBGP.Left := 0;
    DPanelSelChrBGP.Top := 0;


     DPanelChr1.Width := 250;
     DPanelChr1.Height := 100;
     DPanelChr1.Left := DPanelSelChrBGP.Left + 26;
     DPanelChr1.Top := DPanelSelChrBGP.Top + 483;
     DPanelChr1.Propertites.BorderPixel := 0;
     DPanelChr1.Propertites.Alpha := 0;
     _SetColor(DPanelChr1);

     Name0.Left := 98;
     Name0.Top := 10;


     Level0.Left := 98;
     Level0.Top := 40;

     JobName0.Left := 98;
     JobName0.Top := 70;

     NameDesc0.Left := 0;
     NameDesc0.Top := 10;

     LevelDesc0.Left := 0;
     LevelDesc0.Top := 40;

     JobDesc0.Left := 0;
     JobDesc0.Top := 70;

     LevelDesc0.Propertites.Caption.Text := '';
     NameDesc0.Propertites.Caption.Text := '';
     JobDesc0.Propertites.Caption.Text := '';

     DPanelChr2.Propertites.BorderPixel := 0;
     DPanelChr2.Propertites.Alpha := 0;
     DPanelChr2.Width := 250;
     DPanelChr2.Height := 100;
     DPanelChr2.Left := DPanelSelChrBGP.Left + 578;
     DPanelChr2.Top := DPanelSelChrBGP.Top + 485;
     _SetColor(DPanelChr2);


     Name1.Left := 98;
     Name1.Top := 10;

     Level1.Left := 98;
     Level1.Top := 40;

     JobName1.Left := 98;
     JobName1.Top := 70 ;

     NameDesc1.Left := 0;
     NameDesc1.Top := 10;

     LevelDesc1.Left := 0;
     LevelDesc1.Top := 40;

     JobDesc1.Left := 0;
     JobDesc1.Top := 70;

     LevelDesc1.Propertites.Caption.Text := '';
     NameDesc1.Propertites.Caption.Text := '';
     JobDesc1.Propertites.Caption.Text := '';

     FrmDlg.DCreateChr.Left := FrmDlg.DPanelSelChrBGP.Left + 427;
     FrmDlg.DCreateChr.Top := FrmDlg.DPanelSelChrBGP.Top + 19;

     FrmDlg.DTChrPage.Left := FrmDlg.DPanelSelChrBGP.Left + 392;
     FrmDlg.DTChrPage.Top := FrmDlg.DPanelSelChrBGP.Top + 422;





     FrmDlg.DAChr1.Width := 240;
     FrmDlg.DAChr1.Height := 300;

     FrmDlg.DAChr1.Left := FrmDlg.DPanelSelChrBGP.Left + 48;
     FrmDlg.DAChr1.Top := FrmDlg.DPanelSelChrBGP.Top + 83;

     FrmDlg.DANewChr.Left := FrmDlg.DAChr1.Left;
     FrmDlg.DANewChr.Top := FrmDlg.DAChr1.Top;



     FrmDlg.DAChr2.Left := FrmDlg.DPanelSelChrBGP.Left + 410;
     FrmDlg.DAChr2.Top := FrmDlg.DPanelSelChrBGP.Top + 83;
     FrmDlg.DAChr2.Width := 240;
     FrmDlg.DAChr2.Height := 300;

     FrmDlg.DSelectChr.SelChrWinProperites.NotSelectChrFreeze := True;


     FrmDlg.DTServerName.Left := (FrmDlg.DTServerName.DParent.Width - 200) div 2;
     FrmDlg.DTServerName.Top := 7;

     FrmDlg.DANewChr.Width := 200;
     FrmDlg.DANewChr.Height := 300;

     FrmDlg.DSelectChr.SelChrWinProperites.ChrOffsetType := cofMir;
     FrmDlg.DSelectChr.SelChrWinProperites.ChrUIOffsetType := coaPosition;
     FrmDlg.DSelectChr.SelChrWinProperites.CreateChrActrion := chaNormal;

     FrmDlg.DAChrFoucs.SetImgIndex(g_WChrSelImages,4);
     FrmDlg.DAChrFoucs.Propertites.AniCount := 14;
     FrmDlg.DAChrFoucs.Propertites.AniInterval := 80;
     FrmDlg.DAChrFoucs.Propertites.AniLoop := False;
     FrmDlg.DAChrFoucs.Propertites.AniOverHide := True;
     FrmDlg.DAChrFoucs.Propertites.OffsetX := 0;
     FrmDlg.DAChrFoucs.Propertites.OffsetY := 0;
     FrmDlg.DAChrFoucs.Propertites.DrawMode := beBlend;
     FrmDlg.DAChrFoucs.Propertites.Visible := False;
  end;
end;

procedure TSelectChrScene.InitUI_MirReturn;
var
  W, H, LX, LY, ALeft, ATop, Idx: integer;
  d: TAsphyreLockableTexture;
  i: Integer;
begin
  CharCountOfAPage := 5;
  case DISPLAYSIZETYPE of
    0:
      begin
        FrmDlg.DASelChrFire1.Left := 684;
        FrmDlg.DASelChrFire1.Top := 328;

        FrmDlg.DASelChrFire2.Left := 334;
        FrmDlg.DASelChrFire2.Top := 318;

        FrmDlg.DASelChrFire3.Left := 504;
        FrmDlg.DASelChrFire3.Top := 288;

        FrmDlg.DASelChrFire4.Left := 554;
        FrmDlg.DASelChrFire4.Top := 292;

        FrmDlg.DAWater1.Left := 510;
        FrmDlg.DAWater1.Top := 388;

        FrmDlg.DAWater2.Left := 510;
        FrmDlg.DAWater2.Top := 388;

      end;
    1:
      begin
        FrmDlg.DASelChrFire1.Left := 628;
        FrmDlg.DASelChrFire1.Top := 230;

        FrmDlg.DASelChrFire2.Left := 302;
        FrmDlg.DASelChrFire2.Top := 230;

        FrmDlg.DASelChrFire3.Left := 470;
        FrmDlg.DASelChrFire3.Top := 204;

        FrmDlg.DASelChrFire4.Left := 520;
        FrmDlg.DASelChrFire4.Top := 204;

        FrmDlg.DAWater1.Left := 480;
        FrmDlg.DAWater1.Top := 300;

        FrmDlg.DAWater2.Left := 480;
        FrmDlg.DAWater2.Top := 300;
      end;
    2:
      begin
        FrmDlg.DASelChrFire1.Left := 570;
        FrmDlg.DASelChrFire1.Top := 230;

        FrmDlg.DASelChrFire2.Left := 224;
        FrmDlg.DASelChrFire2.Top := 230;

        FrmDlg.DASelChrFire3.Left := 390;
        FrmDlg.DASelChrFire3.Top := 204;

        FrmDlg.DASelChrFire4.Left := 440;
        FrmDlg.DASelChrFire4.Top := 204;

        FrmDlg.DAWater1.Left := 400;
        FrmDlg.DAWater1.Top := 300;

        FrmDlg.DAWater2.Left := 400;
        FrmDlg.DAWater2.Top := 300;
      end;
  end;

  case DISPLAYSIZETYPE of
    0:
      begin
        W := 1024;
        H := 768;
      end;
    1:
      begin
        W := 960;
        H := 600;
      end;
    2:
      begin
        W := 800;
        H := 600;
      end;
  end;

  d := nil;
  case DISPLAYSIZETYPE of
    0:
      d := g_WEffectLogin.Images[3];
    1:
      d := g_WEffectLogin.Images[4];
    2:
      d := g_WEffectLogin.Images[5];
  end;

  case DISPLAYSIZETYPE of
    0:
      FrmDlg.DPanelSelChrBGP.SetImgIndex(g_WEffectLogin, 3);
    1:
      FrmDlg.DPanelSelChrBGP.SetImgIndex(g_WEffectLogin, 4);
    2:
      FrmDlg.DPanelSelChrBGP.SetImgIndex(g_WEffectLogin, 5);
  end;

  ALeft := 0;
  ATop := 0;
//  if d <> nil then
//  begin
//    ALeft := (SCREENWIDTH - d.Width) div 2;
//    ATop := (SCREENHEIGHT - d.Height) div 2;
//  end;

  FrmDlg.DAChr1.Left := ALeft + W div 2;
  FrmDlg.DAChr1.Top := ATop + H div 5 * 2 - 20;
  FrmDlg.DPanelChr1.Left := FrmDlg.DscSelect1.Left - 25;
  FrmDlg.DPanelChr1.Top := FrmDlg.DscSelect1.Top - 80;

  FrmDlg.DAChr2.Left := ALeft + W div 3;
  FrmDlg.DAChr2.Top := ATop + H div 2;
  FrmDlg.DPanelChr2.Left := FrmDlg.DscSelect2.Left - 25;
  FrmDlg.DPanelChr2.Top := FrmDlg.DscSelect2.Top - 80;

  FrmDlg.DAChr3.Left := ALeft + W div 3 * 2;
  FrmDlg.DAChr3.Top := ATop + H div 2;
  FrmDlg.DPanelChr3.Left := FrmDlg.DscSelect3.Left - 25;
  FrmDlg.DPanelChr3.Top := FrmDlg.DscSelect3.Top - 80;

  FrmDlg.DAChr4.Left := ALeft + W div 6;
  FrmDlg.DAChr4.Top := ATop + H div 3 * 2;
  FrmDlg.DPanelChr4.Left := FrmDlg.DscSelect4.Left - 25;
  FrmDlg.DPanelChr4.Top := FrmDlg.DscSelect4.Top - 80;

  FrmDlg.DAChr5.Left := ALeft + W div 6 * 5;
  FrmDlg.DAChr5.Top := ATop + H div 3 * 2;
  FrmDlg.DPanelChr5.Left := FrmDlg.DscSelect5.Left - 25;
  FrmDlg.DPanelChr5.Top := FrmDlg.DscSelect5.Top - 80;

  case DISPLAYSIZETYPE of
    0: begin
       FrmDlg.DTChrPage.Left := 504;
       FrmDlg.DTChrPage.Top := 677;
       FrmDlg.DANewChr.Left := 550;
       FrmDlg.DANewChr.Top := 400;

       for i := 0 to 4 do
       begin
         FrmDlg.ChrInfoPanel[i].Top := FrmDlg.ChrInfoPanel[i].Top - 140;
       end;

       for I := 0 to 4 do
       begin
         FrmDlg.ChrSelectButton[i].Top :=  FrmDlg.ChrSelectButton[i].Top - 140;
         FrmDlg.ChrSelectButton[i].Height := FrmDlg.ChrSelectButton[i].Height + 140;
         FrmDlg.ChrAnis[i].Top :=  FrmDlg.ChrAnis[i].Top - 140;
         FrmDlg.ChrAnis[i].Height :=  FrmDlg.ChrAnis[i].Height + 140;
       end;
    end;
    1:
    begin
       FrmDlg.DTChrPage.Left := 473;
       FrmDlg.DTChrPage.Top := 499;
       FrmDlg.DANewChr.Left := 500;
       FrmDlg.DANewChr.Top := 300;
    end;
    2:
    begin
       FrmDlg.DTChrPage.Left := 393;
       FrmDlg.DTChrPage.Top := 450;
       FrmDlg.DANewChr.Left := 400;
       FrmDlg.DANewChr.Top := 300;
    end;
  end;

  FrmDlg.DTServerName.Left := (FrmDlg.DTServerName.DParent.Width - FrmDlg.DTServerName.Width) div 2;
  FrmDlg.DTServerName.Top := FrmDlg.DTServerName.DParent.Width + 10;

  FrmDlg.DSelectChr.SelChrWinProperites.ChrOffsetType := cofMirReturn;
  FrmDlg.DSelectChr.SelChrWinProperites.ChrUIOffsetType := coaNone;
  FrmDlg.DSelectChr.SelChrWinProperites.CreateChrActrion := chaActionToNormal;

  for i := 0 to 4 do
  begin
    FrmDlg.ChrNameDesc[i].Propertites.Caption.Text := '';
  end;

  for i := 0 to 4 do
  begin
    FrmDlg.ChrNames[i].Left := 30;
  end;

  FrmDlg.DCreateChr.Left := FrmDlg.DCreateChr.DParent.Width - FrmDlg.DCreateChr.Width - 10;
  FrmDlg.DCreateChr.Top := FrmDlg.DCreateChr.DParent.Height - FrmDlg.DCreateChr.Height - 50;

  FrmDlg.DAChrFoucs.Visible := False;


end;

procedure TSelectChrScene.InitUI_NewMir;
procedure _SetColor(D:TDControl);
var
  i : Integer;
begin
  for I := 0 to D.DControls.Count - 1 do
  begin
    if D.DControls[i] is TDTextField then
    begin
      TDTextField(D.DControls[i]).Propertites.Caption.Color := clWhite;
    end;

  end;
end;
var
  W, H, LX, LY, ALeft, ATop, Idx: integer;
  d: TAsphyreLockableTexture;
begin
   CharCountOfAPage := 2;

  d := nil;
  case DISPLAYSIZETYPE of
    0:d := g_WUINImages.Images[281];
    1,2:d := g_WUINImages.Images[280];
  end;

  ALeft := 0;
  ATop := 0;
  if d <> nil then
  begin
    ALeft := (SCREENWIDTH - d.Width) div 2;
    ATop := (SCREENHEIGHT - d.Height) div 2;
  end;

  FrmDlg.DSelectChr.SelChrWinProperites.NotSelectChrFreeze := True;
  case DISPLAYSIZETYPE of
    0:
      FrmDlg.DPanelSelChrBGP.SetImgIndex(g_WUINImages, 281);
    1:
      FrmDlg.DPanelSelChrBGP.SetImgIndex(g_WUINImages, 280);
    2:
      FrmDlg.DPanelSelChrBGP.SetImgIndex(g_WUINImages, 280);
  end;

  with FrmDlg do
  begin
    DPanelSelChrBGP.Left := (SCREENWIDTH - DPanelSelChrBGP.Width) div 2;
    DPanelSelChrBGP.Top := (SCREENHEIGHT - DPanelSelChrBGP.Height) div 2;

    case DISPLAYSIZETYPE of
      0:
      begin
         DPanelChr1.Width := 250;
         DPanelChr1.Height := 100;
         DPanelChr1.Left := DPanelSelChrBGP.Left + 60;
         DPanelChr1.Top := DPanelSelChrBGP.Top + 634;
         DPanelChr1.Propertites.BorderPixel := 0;
         DPanelChr1.Propertites.Alpha := 0;
         _SetColor(DPanelChr1);

         Name0.Left := 98;
         Name0.Top := 10;

         Level0.Left := 98;
         Level0.Top := 45;

         JobName0.Left := 98;
         JobName0.Top := 80;

         NameDesc0.Left := 0;
         NameDesc0.Top := 10;

         LevelDesc0.Left := 0;
         LevelDesc0.Top := 45;

         JobDesc0.Left := 0;
         JobDesc0.Top := 80;


         DPanelChr2.Propertites.BorderPixel := 0;
         DPanelChr2.Propertites.Alpha := 0;
         DPanelChr2.Width := 250;
         DPanelChr2.Height := 100;
         DPanelChr2.Left := DPanelSelChrBGP.Left + 662;
         DPanelChr2.Top := DPanelSelChrBGP.Top + 634;
         _SetColor(DPanelChr2);


         Name1.Left := 98;
         Name1.Top := 10;

         Level1.Left := 98;
         Level1.Top := 45;

         JobName1.Left := 98;
         JobName1.Top := 80;

         NameDesc1.Left := 0;
         NameDesc1.Top := 10;

         LevelDesc1.Left := 0;
         LevelDesc1.Top := 45;

         JobDesc1.Left := 0;
         JobDesc1.Top := 80;

         FrmDlg.DCreateChr.Left := FrmDlg.DPanelSelChrBGP.Left + 580;
         FrmDlg.DCreateChr.Top := FrmDlg.DPanelSelChrBGP.Top + 100;

         FrmDlg.DTChrPage.Left := FrmDlg.DPanelSelChrBGP.Left + 503;
         FrmDlg.DTChrPage.Top := FrmDlg.DPanelSelChrBGP.Top + 551;
      end;
      1,2:
      begin
         DPanelChr1.Width := 250;
         DPanelChr1.Height := 100;
         DPanelChr1.Left := DPanelSelChrBGP.Left + 30;
         DPanelChr1.Top := DPanelSelChrBGP.Top + 502;
         DPanelChr1.Propertites.BorderPixel := 0;
         DPanelChr1.Propertites.Alpha := 0;
         _SetColor(DPanelChr1);

         Name0.Left := 98;
         Name0.Top := 10;

         Level0.Left := 98;
         Level0.Top := 40;

         JobName0.Left := 98;
         JobName0.Top := 70;

         NameDesc0.Left := 0;
         NameDesc0.Top := 10;

         LevelDesc0.Left := 0;
         LevelDesc0.Top := 40;

         JobDesc0.Left := 0;
         JobDesc0.Top := 70;


         DPanelChr2.Propertites.BorderPixel := 0;
         DPanelChr2.Propertites.Alpha := 0;
         DPanelChr2.Width := 250;
         DPanelChr2.Height := 100;
         DPanelChr2.Left := DPanelSelChrBGP.Left + 544;
         DPanelChr2.Top := DPanelSelChrBGP.Top + 502;
         _SetColor(DPanelChr2);


         Name1.Left := 98;
         Name1.Top := 10;

         Level1.Left := 98;
         Level1.Top := 40;

         JobName1.Left := 98;
         JobName1.Top := 70;

         NameDesc1.Left := 0;
         NameDesc1.Top := 10;

         LevelDesc1.Left := 0;
         LevelDesc1.Top := 40;

         JobDesc1.Left := 0;
         JobDesc1.Top := 70;

         FrmDlg.DCreateChr.Left := FrmDlg.DPanelSelChrBGP.Left + 421;
         FrmDlg.DCreateChr.Top := FrmDlg.DPanelSelChrBGP.Top + 14;

         FrmDlg.DTChrPage.Left := FrmDlg.DPanelSelChrBGP.Left + 392;
         FrmDlg.DTChrPage.Top := FrmDlg.DPanelSelChrBGP.Top + 450;
      end;
    end;



     FrmDlg.DAChr1.Width := 320;
     FrmDlg.DAChr1.Height := 400;

     FrmDlg.DAChr1.Left := ALeft + 108;
     FrmDlg.DAChr1.Top := 108;

     FrmDlg.DANewChr.Left := FrmDlg.DAChr1.Left;
     FrmDlg.DANewChr.Top := FrmDlg.DAChr1.Top;



     FrmDlg.DAChr2.Left := ALeft + 600;
     FrmDlg.DAChr2.Top := 108;
     FrmDlg.DAChr2.Width := 320;
     FrmDlg.DAChr2.Height := 400;

     FrmDlg.DSelectChr.SelChrWinProperites.NotSelectChrFreeze := True;


     FrmDlg.DTServerName.Left := (FrmDlg.DTServerName.DParent.Width - 200) div 2;
     FrmDlg.DTServerName.Top := 20;

     FrmDlg.DANewChr.Width := 200;
     FrmDlg.DANewChr.Height := 300;

     FrmDlg.DSelectChr.SelChrWinProperites.ChrOffsetType := cofNewMir;
     FrmDlg.DSelectChr.SelChrWinProperites.ChrUIOffsetType := coaCenter;
     FrmDlg.DSelectChr.SelChrWinProperites.DrawChrEffect := True;
     FrmDlg.DSelectChr.SelChrWinProperites.CreateChrActrion := chaNormal;

     FrmDlg.DAChrFoucs.SetImgIndex(g_WNSelectImages,480);
     FrmDlg.DAChrFoucs.Propertites.AniCount := 10;
     FrmDlg.DAChrFoucs.Propertites.AniInterval := 80;
     FrmDlg.DAChrFoucs.Propertites.AniLoop := False;
     FrmDlg.DAChrFoucs.Propertites.AniOverHide := True;
     FrmDlg.DAChrFoucs.Propertites.OffsetX := 120;
     FrmDlg.DAChrFoucs.Propertites.OffsetY := 130;
     FrmDlg.DAChrFoucs.Propertites.DrawMode := beNormal;
     FrmDlg.DAChrFoucs.Visible := False;
  end;
end;

procedure TSelectChrScene.DecPage;
begin
  if ShowPage then
  begin
    if (PageIndex > 1) then
    begin
      PageIndex := PageIndex - 1;
      SelectChr(Max(0, (PageIndex - 1) * PageCount));
      InitChrPage(PageIndex);
    end;
  end;
end;



{ --------------------------- TLoginNotice ---------------------------- }

constructor TLoginNotice.Create;
begin
  inherited Create(stLoginNotice);
end;

destructor TLoginNotice.Destroy;
begin
  inherited Destroy;
end;

destructor TScene.Destroy;
begin
  inherited;
end;

end.
