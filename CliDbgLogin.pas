unit CliDbgLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uEDCode, Share, ExtCtrls,HUtil32;

type
  TLoginForm = class(TForm)
    GroupBoxClient: TGroupBox;
    CheckBoxFullScreen: TCheckBox;
    ButtonStart: TButton;
    ComboBoxScreen: TComboBox;
    LabelScreen: TLabel;
    GroupBoxServer: TGroupBox;
    LabelServerName: TLabel;
    EditServerName: TEdit;
    LabelAddress: TLabel;
    EditHost: TEdit;
    EditPort: TEdit;
    LabelPort: TLabel;
    CheckBox3D: TCheckBox;
    CheckBoxWaitVBlank: TCheckBox;
    Label1: TLabel;
    EditNetPwd: TEdit;
    RadioGroup: TRadioGroup;
    CheckBoxAutoClientStyle: TCheckBox;
    EditStandardAssistant: TCheckBox;
    rg_EquipStyle: TRadioGroup;
    grp_Function: TGroupBox;
    chk_ViewUIDlg: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function HandleLogin: Boolean;

implementation
  uses OverbyteIcsPing,DWinCtl;

{$R *.dfm}

function GetHostIP(const AHost: String): String;
var
  IPPing: TPing;
begin
  IPPing  :=  TPing.Create(nil);
  try
    IPPing.Address :=  AHost;
    IPPing.Ping;
    Result  :=  IPPing.HostIP;
  finally
    IPPing.Free;
  end;
end;

function ConvertIP(IP:String):string;
begin
  {$IFDEF DEBUG}
   Result := IP;
   Exit;
  {$ENDIF}
  if not SameText(IP,uEDCode.DecodeSource('NWMUQRX+ffpDQLK1T5bBSKlnl3PfQ5AfzrA=')) then
  begin
    if not CompareLStr(IP,uEDCode.DecodeSource('UrulB6gXzDXh0dPwFOPLWTkVDcvlnA=='),Length('192.168')) then
    begin
      Result := uEDCode.DecodeSource('a5vJ7tBATB/5UaVngy2JKHhyvD1Caee1mgE=');
      Exit;
    end;
  end;
  Result := IP;
end;


function HandleLogin: Boolean;
var
  LS: TStrings;
  ANetPwd: AnsiString;
begin
  Result := False;
  with TLoginForm.Create(nil) do
  begin
    Try
      if ShowModal = mrOK then
      begin
        g_MirStartupInfo.nLocalMiniPort := 10555;
        g_MirStartupInfo.sServerName := EditServerName.Text;
        if StrToIntDef(EditHost.Text, -1) = -1 then
          g_MirStartupInfo.sServeraddr := GetHostIP(EditHost.Text)
        else
          g_MirStartupInfo.sServeraddr := EditHost.Text;

        g_MirStartupInfo.sServeraddr := ConvertIP(g_MirStartupInfo.sServeraddr);

        g_MirStartupInfo.nServerPort := StrToIntDef(EditPort.Text, 7000);
        g_MirStartupInfo.boFullScreen := CheckBoxFullScreen.Checked;
        g_MirStartupInfo.boWaitVBlank := CheckBoxWaitVBlank.Checked;
        g_MirStartupInfo.bo3D := CheckBox3D.Checked;
        g_MirStartupInfo.boMini := TRUE;
        g_MirStartupInfo.sResourceDir := '91Resource\';
        g_MirStartupInfo.sUIPakKey := '';
        g_MirStartupInfo.btMainInterface := 0;
        g_MirStartupInfo.AssistantKind := 0;
        if EditStandardAssistant.Checked then
          g_MirStartupInfo.AssistantKind := 1;
        g_MirStartupInfo.boAutoClientStyle := CheckBoxAutoClientStyle.Checked;
        g_MirStartupInfo.btClientStyle := 0;
        g_MirStartupInfo.sL := 'B';
        g_MirStartupInfo.sLogo := '';

        g_MirStartupInfo.btClientStyle := 0;
        case RadioGroup.ItemIndex of
          0: g_MirStartupInfo.btClientStyle := 0;
          1: g_MirStartupInfo.btClientStyle := 1;
          2: g_MirStartupInfo.btClientStyle := 2;
        end;

        g_MirStartupInfo.btEquipStyle := 0;
        case rg_EquipStyle.ItemIndex of
          0: g_MirStartupInfo.btEquipStyle := 0;
          1: g_MirStartupInfo.btEquipStyle := 1;
          2: g_MirStartupInfo.btEquipStyle := 2;
        end;

        g_MirStartupInfo.boViewUIDlg := chk_ViewUIDlg.Checked;

        ANetPwd := uEDCode.EncodeSource(EditNetPwd.Text);
        g_MirStartupInfo.sServerKey := ANetPwd;
        LS  :=  TStringList.Create;
        try
          ExtractStrings(['x'], [], PChar(ComboBoxScreen.Text), LS);
          g_MirStartupInfo.nScreenWidth  :=  StrToInt(ls.Strings[0]);
          g_MirStartupInfo.nScreenHegiht :=  StrToInt(ls.Strings[1]);
        finally
          LS.Free;
        end;
        Result := True;
      end;
    finally
    Free;
    end;
  end;
end;

type
  TDisplay = record
    X,
    Y: Integer;
  end;
  pTDisplay = ^TDisplay;

function _DoSort(Item1, Item2: Pointer): Integer;
begin
  Result  :=  pTDisplay(Item1).X - pTDisplay(Item2).X;
  if Result = 0 then
    Result  :=  pTDisplay(Item1).Y - pTDisplay(Item2).Y;
end;

procedure EnumDisplayMode(LS: TStrings);
var
  DevModeCount: Integer;             // 显示模式的数目
  DevModeInfo: TDevMode;            //指向显示模式信息的指针
  Line: String;
  L: TList;
  ADisplay: pTDisplay;
  I, AMin: Integer;
begin
  L :=  TList.Create;
  try
    DevModeCount := 0;

    while EnumDisplaySettings(nil, DevModeCount, DevModeInfo) do
    begin
      Inc(DevModeCount);
      Line  :=  IntToStr(DevModeInfo.dmPelsWidth) + 'x' + IntToStr(DevModeInfo.dmPelsHeight);
      if (DevModeInfo.dmPelsWidth >= 800) and (DevModeInfo.dmPelsHeight >= 600)  and (ls.IndexOf(Line)=-1) then
      begin
        New(ADisplay);
        ADisplay^.X :=  DevModeInfo.dmPelsWidth;
        ADisplay^.Y :=  DevModeInfo.dmPelsHeight;
        L.Add(ADisplay);
        LS.Add(Line);
      end;
    end;

    L.Sort(_DoSort);
    LS.Clear;
    for I :=  0 to L.Count - 1 do
    begin
      LS.Add(Format('%dx%d', [pTDisplay(L[I]).X, pTDisplay(L[I]).Y]));
      Dispose(pTDisplay(L[I]));
    end;
  finally
    L.Free;
  end;
end;

procedure TLoginForm.FormCreate(Sender: TObject);
var
  ls: TStringList;
  SceneKind : TSceneKind;
  StateKind : TStateWinKind;
begin
  RadioGroup.Items.Clear;
  for SceneKind := Low(TSceneKind) to High(TSceneKind) do
  begin
    RadioGroup.Items.Add(TSceneKindDesc[SceneKind]);
  end;

  rg_EquipStyle.Items.Clear;
  for StateKind := Low(TStateWinKind) to High(TStateWinKind) do
  begin
    rg_EquipStyle.Items.Add(TStateWinKindDesc[StateKind]);
  end;

  ls  :=  TStringList.Create;
  try
    EnumDisplayMode(ls);
    ComboBoxScreen.Items.AddStrings(ls);
  finally
    ls.Free;
  end;
  if ComboBoxScreen.Items.Count = 0 then
  begin
    ComboBoxScreen.Items.Add('800x600');
    ComboBoxScreen.Items.Add('960x600');
    ComboBoxScreen.Items.Add('1024x768');
  end
  else
  begin
    if ComboBoxScreen.Items.IndexOf('800x600') = 0 then
      ComboBoxScreen.Items.Insert(1, '960x600');
  end;
  ComboBoxScreen.ItemIndex := ComboBoxScreen.Items.IndexOf('1024x768');
  if ComboBoxScreen.ItemIndex = -1 then
    ComboBoxScreen.ItemIndex := 0;
end;

procedure TLoginForm.FormShow(Sender: TObject);
begin
  RadioGroup.ItemIndex := 0;
  rg_EquipStyle.ItemIndex := 0;
end;

end.
