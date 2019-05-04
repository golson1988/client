unit StandardAssistantFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Spin, ExtCtrls, Generics.Collections, Math, Grobal2;

type
  TStandardAssistantForm = class(TForm)
    PageControl: TPageControl;
    TabStd: TTabSheet;
    TabJobs: TTabSheet;
    TabProtect: TTabSheet;
    TabFight: TTabSheet;
    TabItems: TTabSheet;
    TabVoice: TTabSheet;
    StdPageControl: TPageControl;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    TabHelp: TTabSheet;
    EditBGSound: TCheckBox;
    EditSound: TCheckBox;
    EditShowItemName: TCheckBox;
    EditFilterItemName: TCheckBox;
    EditAutoPick: TCheckBox;
    EditPickFilter: TCheckBox;
    EditAutoUnpack: TCheckBox;
    EditAutoPutEat: TCheckBox;
    EditShowName: TCheckBox;
    EditShowMonName: TCheckBox;
    EditShowNPCName: TCheckBox;
    EditAvoidShift: TCheckBox;
    EditShowBloodHeader: TCheckBox;
    EditShowBloodNum: TCheckBox;
    EditShowJobLv: TCheckBox;
    EditShowBloodChange: TCheckBox;
    EditNotAllowDeal: TCheckBox;
    EditFilterExp: TCheckBox;
    EditHideDressEff: TCheckBox;
    EditHideWepEff: TCheckBox;
    EditMonNameList: TListBox;
    EditMonName: TEdit;
    BtnAddMonName: TButton;
    BtnEditMonName: TButton;
    BtnDeleteMonName: TButton;
    EditHelp: TMemo;
    TrackBGSound: TTrackBar;
    TrackSound: TTrackBar;
    ListViewItems: TListView;
    EditItemName: TEdit;
    EditItemKind: TComboBox;
    BtnSearchItem: TButton;
    EditMagicLock: TCheckBox;
    CheckBox22: TCheckBox;
    EditCleanCorpse: TCheckBox;
    EditAutoMagic: TCheckBox;
    Label1: TLabel;
    EditAutoMagicInterval: TSpinEdit;
    EditCommonHp: TCheckBox;
    EditCommonHpValue: TSpinEdit;
    Label2: TLabel;
    EditCommonHpTimer: TSpinEdit;
    PageControlJobs: TPageControl;
    TabJob0: TTabSheet;
    TabJob1: TTabSheet;
    TabJob2: TTabSheet;
    TabJob3: TTabSheet;
    TabJob4: TTabSheet;
    TabJo5: TTabSheet;
    BtnSave: TButton;
    BtnClose: TButton;
    EditDufu: TCheckBox;
    EditHonlvdu: TCheckBox;
    EditAutoHide: TCheckBox;
    EditShieldAlways: TCheckBox;
    EditAutoShield: TCheckBox;
    EditSdoLongHit: TCheckBox;
    EditGWLongHit: TCheckBox;
    EditAutoFireHit: TCheckBox;
    EditAutoWideHit: TCheckBox;
    EditKait: TCheckBox;
    EditZhuri: TCheckBox;
    EditFilterExpNum: TSpinEdit;
    EditShowRankName: TCheckBox;
    EditDuraWarning: TCheckBox;
    EditShowTitle: TCheckBox;
    EditAllowGroup: TCheckBox;
    EditAllowGroupReCall: TCheckBox;
    EditAllowGuildReCall: TCheckBox;
    EditAllowGuild: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    EditCommonHpName: TComboBox;
    EditCommonMP: TCheckBox;
    EditCommonMpValue: TSpinEdit;
    EditCommonMpTimer: TSpinEdit;
    EditCommonMpName: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    EditSpecialHp: TCheckBox;
    EditSpecialMp: TCheckBox;
    EditSpecialMpValue: TSpinEdit;
    EditSpecialHpValue: TSpinEdit;
    Label7: TLabel;
    Label8: TLabel;
    EditSpecialMpTimer: TSpinEdit;
    EditSpecialHpTimer: TSpinEdit;
    EditSpecialHpName: TComboBox;
    EditSpecialMpName: TComboBox;
    Label9: TLabel;
    EditRandomHp: TCheckBox;
    EditRandomHpValue: TSpinEdit;
    Label10: TLabel;
    EditRandomHpTimer: TSpinEdit;
    EditRandomName: TComboBox;
    Label11: TLabel;
    Label12: TLabel;
    EditMonHintInterval: TSpinEdit;
    chk_SmartWalk: TCheckBox;
    procedure EditBGSoundClick(Sender: TObject);
    procedure EditSoundClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnAddMonNameClick(Sender: TObject);
    procedure EditMonNameListClick(Sender: TObject);
    procedure BtnEditMonNameClick(Sender: TObject);
    procedure BtnDeleteMonNameClick(Sender: TObject);
    procedure EditShowNameClick(Sender: TObject);
    procedure EditShowItemNameClick(Sender: TObject);
    procedure EditFilterItemNameClick(Sender: TObject);
    procedure EditAutoPickClick(Sender: TObject);
    procedure EditPickFilterClick(Sender: TObject);
    procedure EditShowRankNameClick(Sender: TObject);
    procedure EditShowTitleClick(Sender: TObject);
    procedure EditShowJobLvClick(Sender: TObject);
    procedure EditShowNPCNameClick(Sender: TObject);
    procedure EditShowMonNameClick(Sender: TObject);
    procedure EditShowBloodHeaderClick(Sender: TObject);
    procedure EditShowBloodNumClick(Sender: TObject);
    procedure EditShowBloodChangeClick(Sender: TObject);
    procedure EditHideDressEffClick(Sender: TObject);
    procedure EditHideWepEffClick(Sender: TObject);
    procedure EditAvoidShiftClick(Sender: TObject);
    procedure EditAllowGroupClick(Sender: TObject);
    procedure EditAllowGroupReCallClick(Sender: TObject);
    procedure EditAllowGuildClick(Sender: TObject);
    procedure EditAllowGuildReCallClick(Sender: TObject);
    procedure EditDuraWarningClick(Sender: TObject);
    procedure EditNotAllowDealClick(Sender: TObject);
    procedure EditFilterExpClick(Sender: TObject);
    procedure EditFilterExpNumChange(Sender: TObject);
    procedure TrackBGSoundChange(Sender: TObject);
    procedure TrackSoundChange(Sender: TObject);
    procedure EditSdoLongHitClick(Sender: TObject);
    procedure EditGWLongHitClick(Sender: TObject);
    procedure EditAutoWideHitClick(Sender: TObject);
    procedure EditAutoFireHitClick(Sender: TObject);
    procedure EditZhuriClick(Sender: TObject);
    procedure EditShieldAlwaysClick(Sender: TObject);
    procedure EditAutoHideClick(Sender: TObject);
    procedure EditMagicLockClick(Sender: TObject);
    procedure EditCleanCorpseClick(Sender: TObject);
    procedure EditAutoMagicClick(Sender: TObject);
    procedure EditAutoMagicIntervalChange(Sender: TObject);
    procedure EditItemKindChange(Sender: TObject);
    procedure BtnSearchItemClick(Sender: TObject);
    procedure ListViewItemsClick(Sender: TObject);
    procedure EditCommonHpClick(Sender: TObject);
    procedure EditCommonHpValueChange(Sender: TObject);
    procedure EditCommonHpTimerChange(Sender: TObject);
    procedure EditCommonHpNameChange(Sender: TObject);
    procedure EditCommonMPClick(Sender: TObject);
    procedure EditCommonMpTimerChange(Sender: TObject);
    procedure EditCommonMpNameChange(Sender: TObject);
    procedure EditSpecialHpClick(Sender: TObject);
    procedure EditSpecialMpClick(Sender: TObject);
    procedure EditSpecialHpValueChange(Sender: TObject);
    procedure EditSpecialMpValueChange(Sender: TObject);
    procedure EditSpecialHpTimerChange(Sender: TObject);
    procedure EditSpecialMpTimerChange(Sender: TObject);
    procedure EditSpecialHpNameChange(Sender: TObject);
    procedure EditSpecialMpNameChange(Sender: TObject);
    procedure EditRandomHpClick(Sender: TObject);
    procedure EditRandomHpValueChange(Sender: TObject);
    procedure EditRandomHpTimerChange(Sender: TObject);
    procedure EditRandomNameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditMonNameKeyPress(Sender: TObject; var Key: Char);
    procedure EditMonHintIntervalChange(Sender: TObject);
    procedure EditCommonMpValueChange(Sender: TObject);
    procedure EditDufuClick(Sender: TObject);
    procedure chk_SmartWalkClick(Sender: TObject);
  private
    { Private declarations }
    FLoading: Boolean;
    procedure Load;
    procedure Save;
    procedure Modify;
    procedure UpdateButtonsState;
  public
    { Public declarations }
    class procedure Execute;
    class procedure Hide;
  end;


implementation
  uses Types, Themes, MShare, ClMain, SoundUtil, uSoundEngine,FState;

const
  _S_: array[Boolean] of String = ('', '√');

var
  StandardAssistantForm: TStandardAssistantForm = nil;
  FAllowGroupReCallTick,
  FAllowGuildTick,
  FAllowGuildReCallTick,
  FAllowDealTick: LongWord;
  FboOpen:Boolean = False;

{$R *.dfm}

{ TStandardAssistantForm }

procedure TStandardAssistantForm.BtnAddMonNameClick(Sender: TObject);
var
  S: String;
begin
  S := Trim(EditMonName.Text);
  if (S <> '') and (EditMonNameList.Items.IndexOf(S) = -1) then
  begin
    EditMonNameList.Items.Add(S);
    EditMonName.Text := '';
    EditMonName.SetFocus;
    Modify;
    UpdateButtonsState;
  end;
end;

procedure TStandardAssistantForm.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TStandardAssistantForm.BtnDeleteMonNameClick(Sender: TObject);
begin
  if EditMonNameList.ItemIndex <> -1 then
  begin
    EditMonNameList.Items.Delete(EditMonNameList.ItemIndex);
    UpdateButtonsState;
    Modify;
  end;
end;

procedure TStandardAssistantForm.BtnEditMonNameClick(Sender: TObject);
var
  S: String;
  AIndex: Integer;
begin
  if EditMonNameList.ItemIndex <> -1 then
  begin
    S := Trim(EditMonName.Text);
    if S <> '' then
    begin
      AIndex := EditMonNameList.Items.IndexOf(S);
      if (AIndex = -1) or (AIndex = EditMonNameList.ItemIndex) then
      begin
        EditMonNameList.Items[EditMonNameList.ItemIndex] := S;
        EditMonName.Text := '';
        EditMonName.SetFocus;
        Modify;
        UpdateButtonsState;
      end;
    end;
  end;
end;

procedure TStandardAssistantForm.BtnSaveClick(Sender: TObject);
begin
  Save;
end;

procedure TStandardAssistantForm.BtnSearchItemClick(Sender: TObject);

  function DoSearch(Start: Integer; const AName: String): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := Start to ListViewItems.Items.Count - 1 do
    begin
      if Pos(AName, ListViewItems.Items[I].Caption) > 0 then
      begin
        ListViewItems.Selected := ListViewItems.Items[I];
        ListViewItems.Selected.MakeVisible(True);
        ListViewItems.SetFocus;
        Result := True;
        Break;
      end;
    end;
  end;

var
  AItemName: String;
  I, AStart: Integer;
begin
  AItemName := EditItemName.Text;
  if AItemName <> '' then
  begin
    if ListViewItems.ItemIndex = -1 then
      AStart := 0
    else
      AStart := ListViewItems.ItemIndex + 1;
    if not DoSearch(AStart, AItemName) and (AStart <> 0) then
      DoSearch(0, AItemName);
  end
  else
    g_Application.AddMessageDialog('请输入物品名称的关键字', [mbOk]);
end;

procedure TStandardAssistantForm.chk_SmartWalkClick(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.SmartWalk := chk_SmartWalk.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditAllowGroupClick(Sender: TObject);
begin
  if GetTickCount > g_dwChangeGroupModeTick then
  begin
    g_boAllowGroup := EditAllowGroup.Checked;
    g_dwChangeGroupModeTick := GetTickCount + 1000;
    FrmMain.SendChangeState(STATE_ALLOWGROUP, g_boAllowGroup);
    SetAllowGroup(g_boAllowGroup);
  end
  else
    EditAllowGroup.Checked := g_boAllowGroup;
end;

procedure TStandardAssistantForm.EditAllowGroupReCallClick(Sender: TObject);
begin
  if GetTickCount - FAllowGroupReCallTick > 1000 then
  begin
    g_boAllowGroupRecall := EditAllowGroupReCall.Checked;
    FAllowGroupReCallTick := GetTickCount;
    FrmMain.SendChangeState(STATE_ALLOWGROUPRECALL, g_boAllowGroupRecall);
  end
  else
    EditAllowGroupReCall.Checked := g_boAllowGroupRecall;
end;

procedure TStandardAssistantForm.EditAllowGuildClick(Sender: TObject);
begin
  if GetTickCount - FAllowGuildTick > 1000 then
  begin
    FAllowGuildTick := GetTickCount;
    g_boAllowGuild := EditAllowGuild.Checked;
    FrmMain.SendChangeState(STATE_ALLOWGUILD, g_boAllowGuild);
  end
  else
    EditAllowGuild.Checked := g_boAllowGuild;
end;

procedure TStandardAssistantForm.EditAllowGuildReCallClick(Sender: TObject);
begin
  if GetTickCount - FAllowGuildReCallTick > 1000 then
  begin
    g_boAllowGuildRecall := EditAllowGuildReCall.Checked;
    FAllowGuildReCallTick := GetTickCount;
    FrmMain.SendChangeState(STATE_ALLOWGUILDRECALL, g_boAllowGuildRecall);
  end
  else
    EditAllowGuildReCall.Checked := g_boAllowGuildRecall;
end;

procedure TStandardAssistantForm.EditAutoFireHitClick(Sender: TObject);
begin
  g_Config.Assistant.AutoFireHit := EditAutoFireHit.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditAutoHideClick(Sender: TObject);
begin
  g_Config.Assistant.AutoHide := EditAutoHide.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditAutoMagicClick(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.AutoMagic := EditAutoMagic.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditAutoMagicIntervalChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.AutoMagicTime := Max(EditAutoMagicInterval.Value, 0);
  Modify;
end;

procedure TStandardAssistantForm.EditAutoPickClick(Sender: TObject);
begin
  g_Config.Assistant.AutoPuckUpItem := EditAutoPick.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditAutoWideHitClick(Sender: TObject);
begin
  g_Config.Assistant.AutoWideHit := EditAutoWideHit.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditAvoidShiftClick(Sender: TObject);
begin
  g_Config.Assistant.NoShift := EditAvoidShift.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditBGSoundClick(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.BGSound := EditBGSound.Checked;
  TrackBGSound.Enabled := g_Config.Assistant.BGSound;
  if not g_Config.Assistant.BGSound then
    g_SoundManager.BGSoundStop;
  Modify;
end;

procedure TStandardAssistantForm.EditCleanCorpseClick(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.CleanCorpse := EditCleanCorpse.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditCommonHpClick(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.CommonHp := EditCommonHp.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditCommonHpNameChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.DefCommonHpName := EditCommonHpName.Text;
  Modify;
end;

procedure TStandardAssistantForm.EditCommonHpTimerChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.EditCommonHpTimer := Max(g_dwUseDrugInterval, EditCommonHpTimer.Value);
  Modify;
end;

procedure TStandardAssistantForm.EditCommonHpValueChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.EditCommonHp := Max(0, EditCommonHpValue.Value);

  if g_MySelf <> nil then
  begin
    if g_Config.Assistant.EditCommonHp > g_MySelf.m_Abil.MaxHP then
    begin
      g_Config.Assistant.EditCommonHp := g_MySelf.m_Abil.MaxHP;
      EditCommonHpValue.Value := g_MySelf.m_Abil.MaxHP;
    end;
  end;
  Modify;
end;

procedure TStandardAssistantForm.EditCommonMPClick(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.CommonMp := EditCommonMp.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditCommonMpNameChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.DefCommonMpName := EditCommonMpName.Text;
  Modify;
end;

procedure TStandardAssistantForm.EditCommonMpTimerChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.EditCommonMpTimer := Max(g_dwUseDrugInterval, EditCommonMpTimer.Value);
  Modify;
end;

procedure TStandardAssistantForm.EditCommonMpValueChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.EditCommonMp := Max(0, EditCommonMpValue.Value);

  if g_MySelf <> nil then
  begin
    if g_Config.Assistant.EditCommonMp > g_MySelf.m_Abil.MaxMP then
    begin
      g_Config.Assistant.EditCommonMp :=  g_MySelf.m_Abil.MaxMP;
      EditCommonMpValue.Value := g_MySelf.m_Abil.MaxMP;
    end;
  end;
  Modify;
end;

procedure TStandardAssistantForm.EditDufuClick(Sender: TObject);
begin
    g_Config.Assistant.AutoTurnDuFu := EditDufu.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditDuraWarningClick(Sender: TObject);
begin
  g_Config.Assistant.DuraWarning := EditDuraWarning.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditFilterExpClick(Sender: TObject);
begin
  g_Config.Assistant.FilterExp := EditFilterExp.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditFilterExpNumChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.FilterExpValue := EditFilterExpNum.Value;
  Modify;
end;

procedure TStandardAssistantForm.EditFilterItemNameClick(Sender: TObject);
begin
  g_Config.Assistant.FilterItemName := EditFilterItemName.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditGWLongHitClick(Sender: TObject);
begin
  g_Config.Assistant.SPLongHit := EditGWLongHit.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditHideDressEffClick(Sender: TObject);
begin
  g_Config.Assistant.HideDressEff := EditHideDressEff.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditHideWepEffClick(Sender: TObject);
begin
  g_Config.Assistant.HideWepEff := EditHideWepEff.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditItemKindChange(Sender: TObject);

  function TestStdModeIn(Value: Byte; StdModes: array of Byte): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := Low(StdModes) to High(StdModes) do
      if Value = StdModes[I] then
      begin
        Result := True;
        Exit;
      end;
  end;

  procedure DoFilter(StdModes: array of Byte);
  var
    I: Integer;
    AItem: TListItem;
  begin
    for I := 0 to g_ItemList.Count - 1 do
      if TestStdModeIn(g_ItemList[I].StdMode, StdModes) then
      begin
        AItem := ListViewItems.Items.Add;
        AItem.Caption := g_ItemList[I].Name;
        AItem.SubItems.Add(_S_[g_ItemList[I].State.ShowNameClient]);
        AItem.SubItems.Add(_S_[g_ItemList[I].State.AutoPickUp]);
        AItem.SubItems.Add(_S_[g_ItemList[I].State.SpecialShow]);
        AItem.Data := g_ItemList[I];
      end;
  end;

  procedure DoFilterNot(StdModes: array of Byte);
  var
    I: Integer;
    AItem: TListItem;
  begin
    for I := 0 to g_ItemList.Count - 1 do
      if not TestStdModeIn(g_ItemList[I].StdMode, StdModes) then
      begin
        AItem := ListViewItems.Items.Add;
        AItem.Caption := g_ItemList[I].Name;
        AItem.SubItems.Add(_S_[g_ItemList[I].State.ShowNameClient]);
        AItem.SubItems.Add(_S_[g_ItemList[I].State.AutoPickUp]);
        AItem.SubItems.Add(_S_[g_ItemList[I].State.SpecialShow]);
        AItem.Data := g_ItemList[I];
      end;
  end;

begin
  ListViewItems.Clear;

  case EditItemKind.ItemIndex of
    0: DoFilterNot([]);
    1: DoFilter([5, 6]);
    2: DoFilter([10, 11]);
    3: DoFilter([15, 16]);
    4: DoFilter([19, 20, 21]);
    5: DoFilter([24, 26]);
    6: DoFilter([22, 23]);
    7: DoFilter([27]);
    8: DoFilter([28]);
    9: DoFilter([29]);
    10: DoFilter([17, 18]);
    11: DoFilter([0]);
    13: DoFilter([35]);
    14: DoFilter([8]);
    15: DoFilterNot([0,4,5,6,8,10,11,15,16,17,18,19,20,21,22,23,24,26,27,28,29,35]);
  end;
end;

procedure TStandardAssistantForm.EditMagicLockClick(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.MagicLock := EditMagicLock.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditMonNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key =#13 then
    BtnAddMonNameClick(nil);
end;

procedure TStandardAssistantForm.EditMonNameListClick(Sender: TObject);
begin
  EditMonName.Text := '';
  if EditMonNameList.ItemIndex <> -1 then
    EditMonName.Text := EditMonNameList.Items[EditMonNameList.ItemIndex];
  UpdateButtonsState;
end;

procedure TStandardAssistantForm.EditNotAllowDealClick(Sender: TObject);
begin
  if GetTickCount - FAllowDealTick > 1000 then
  begin
    g_boAllowDeal := not EditNotAllowDeal.Checked;
    FAllowDealTick := GetTickCount;
    FrmMain.SendChangeState(STATE_ALLOWDEAL, g_boAllowDeal);
  end
  else
    EditNotAllowDeal.Checked := not g_boAllowDeal;
end;

procedure TStandardAssistantForm.EditPickFilterClick(Sender: TObject);
begin
  g_Config.Assistant.FilterPickItem := EditPickFilter.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditRandomHpClick(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.RandomHp := EditRandomHp.Checked;
end;

procedure TStandardAssistantForm.EditRandomHpTimerChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.EditRandomHpTimer := Max(g_dwUseItemInterval, EditRandomHpTimer.Value);
  Modify;
end;

procedure TStandardAssistantForm.EditRandomHpValueChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.EditRandomHp := Max(0, EditRandomHpValue.Value);

  if g_MySelf <> nil then
  begin
    if g_Config.Assistant.EditRandomHp > g_MySelf.m_Abil.MaxHP then
    begin
      g_Config.Assistant.EditRandomHp :=  g_MySelf.m_Abil.MaxHP;
      EditRandomHpValue.Value := g_MySelf.m_Abil.MaxHP;
    end;
  end;
  Modify;
end;

procedure TStandardAssistantForm.EditRandomNameChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.RandomType :=  EditRandomName.ItemIndex;
  g_Config.Assistant.RandomName :=  EditRandomName.Text;
end;

procedure TStandardAssistantForm.EditSdoLongHitClick(Sender: TObject);
begin
  g_Config.Assistant.LongHit := EditSdoLongHit.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditShieldAlwaysClick(Sender: TObject);
begin
  g_Config.Assistant.AutoShield := EditShieldAlways.Checked;
end;

procedure TStandardAssistantForm.EditShowBloodChangeClick(Sender: TObject);
begin
  g_Config.Assistant.ShowHealthStatus := EditShowBloodChange.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditShowBloodHeaderClick(Sender: TObject);
begin
  g_Config.Assistant.ShowBlood := EditShowBloodHeader.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditShowBloodNumClick(Sender: TObject);
begin
  g_Config.Assistant.ShowBloodNum := EditShowBloodNum.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditShowItemNameClick(Sender: TObject);
begin
  g_Config.Assistant.ShowAllItem := EditShowItemName.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditShowJobLvClick(Sender: TObject);
begin
  g_Config.Assistant.ShowJobLevel := EditShowJobLv.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditShowMonNameClick(Sender: TObject);
begin
  g_Config.Assistant.ShowMonName := EditShowMonName.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditShowNameClick(Sender: TObject);
begin
  g_Config.Assistant.ShowName := EditShowName.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditShowNPCNameClick(Sender: TObject);
begin
  g_Config.Assistant.ShowNPCName := EditShowNPCName.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditShowRankNameClick(Sender: TObject);
begin
  g_Config.Assistant.ShowRankName := EditShowRankName.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditShowTitleClick(Sender: TObject);
begin
  g_Config.Assistant.ShowTitle := EditShowTitle.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditSoundClick(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.Sound := EditSound.Checked;
  TrackSound.Enabled := g_Config.Assistant.Sound;
  if not g_Config.Assistant.Sound then
    g_SoundManager.SoundStop;
  Modify;
end;

procedure TStandardAssistantForm.EditSpecialHpClick(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.SpecialHp := EditSpecialHp.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditSpecialHpNameChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.DefSpecialHpName := EditSpecialHpName.Text;
  Modify;
end;

procedure TStandardAssistantForm.EditSpecialHpTimerChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.EditSpecialHpTimer := Max(g_dwUseDrugInterval, EditSpecialHpTimer.Value);
  Modify;
end;

procedure TStandardAssistantForm.EditSpecialHpValueChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.EditSpecialHp := Max(EditSpecialHpValue.Value, 0);

  if g_MySelf <> nil then
  begin
    if g_Config.Assistant.EditSpecialHp > g_MySelf.m_Abil.MaxHP then
    begin
      g_Config.Assistant.EditSpecialHp :=  g_MySelf.m_Abil.MaxHP;
      EditSpecialHpValue.Value := g_MySelf.m_Abil.MaxHP;
    end;
  end;

  Modify;
end;

procedure TStandardAssistantForm.EditSpecialMpClick(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.SpecialMp := EditSpecialMp.Checked;
  Modify;
end;

procedure TStandardAssistantForm.EditSpecialMpNameChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.DefSpecialMpName := EditSpecialMpName.Text;
  Modify;
end;

procedure TStandardAssistantForm.EditSpecialMpTimerChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.EditSpecialMpTimer := Max(g_dwUseDrugInterval, EditSpecialMpTimer.Value);
  Modify;
end;

procedure TStandardAssistantForm.EditSpecialMpValueChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.EditSpecialMp := Max(EditSpecialMPValue.Value, 0);

  if g_MySelf <> nil then
  begin
    if g_Config.Assistant.EditSpecialMp > g_MySelf.m_Abil.MaxMP then
    begin
      g_Config.Assistant.EditSpecialMp :=  g_MySelf.m_Abil.MaxMP;
      EditSpecialMPValue.Value := g_MySelf.m_Abil.MaxMP;
    end;
  end;

  Modify;
end;

procedure TStandardAssistantForm.EditZhuriClick(Sender: TObject);
begin
  g_Config.Assistant.AutoZhuriHit := EditZhuri.Checked;
  Modify;
end;

class procedure TStandardAssistantForm.Execute;
begin
  if StandardAssistantForm = nil then
  begin
    StandardAssistantForm := TStandardAssistantForm.Create(Application);
    StandardAssistantForm.Load;
    StandardAssistantForm.chk_SmartWalk.Visible := g_boCanUseSmartWalk;
    StandardAssistantForm.Show;
    FboOpen := True;
    Exit;
  end;

  if FboOpen then
  begin
    FboOpen := False;
    StandardAssistantForm.Close;
  end
  else
  begin
    FboOpen := True;
    StandardAssistantForm.chk_SmartWalk.Visible := g_boCanUseSmartWalk;
    StandardAssistantForm.Show;
  end;

end;

procedure TStandardAssistantForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TStandardAssistantForm.FormCreate(Sender: TObject);
begin
  StandardAssistantForm := Self;
end;

procedure TStandardAssistantForm.FormDestroy(Sender: TObject);
begin
  if StandardAssistantForm = Self then
    StandardAssistantForm := nil;
end;

class procedure TStandardAssistantForm.Hide;
begin
  if StandardAssistantForm <> nil then
    StandardAssistantForm.Close;
end;

procedure TStandardAssistantForm.ListViewItemsClick(Sender: TObject);
var
  P: TPoint;
  AItem: TListItem;
  AStdItem: PTStdItem;
  AShowItem: TShowItem;
  I, W, ANewBind: Integer;
begin
  GetCursorPos(P);
  P := ListViewItems.ScreenToClient(P);
  AItem := ListViewItems.GetItemAt(8, P.Y);
  if AItem <> nil then
  begin
    W := 0;
    for I := 0 to ListViewItems.Columns.Count - 1 do
    begin
      if (I > 0) and (P.X >= W) and (P.X <= W + ListViewItems.Columns[I].Width) then
      begin
        AStdItem := AItem.Data;
        case I of
          1:
          begin
            AStdItem.State.ShowNameClient := Not AStdItem.State.ShowNameClient;
            AItem.SubItems[0] := _S_[AStdItem.State.ShowNameClient];
          end;
          2:
          begin
            AStdItem.State.AutoPickUp := Not AStdItem.State.AutoPickUp;
            AItem.SubItems[1] := _S_[AStdItem.State.AutoPickUp];
          end;
          3:
          begin
            AStdItem.State.SpecialShow := Not AStdItem.State.SpecialShow;
            AItem.SubItems[2] := _S_[AStdItem.State.SpecialShow];
          end;
        end;
        if g_FilterItemNameList.TryGetValue(AStdItem.Name, AShowItem) then
        begin
//          AShowItem.boShowName    :=  SetContain(ANewBind, 6);
//          AShowItem.boAutoPickup  :=  SetContain(ANewBind, 8);
//          AShowItem.boSpec        :=  SetContain(ANewBind, 7);

          AShowItem.boShowName    :=  AStdItem.State.ShowNameClient;
          AShowItem.boAutoPickup  :=  AStdItem.State.AutoPickUp;
          AShowItem.boSpec        :=  AStdItem.State.SpecialShow;
          UpdateShowItem(AStdItem.Name, AShowItem);
        end;
        Break;
      end;

      Inc(W, ListViewItems.Columns[I].Width);
    end;
  end;
end;

procedure TStandardAssistantForm.Load;
var
  I: Integer;
begin
  FLoading := True;
  try
    EditCommonHpTimer.MinValue := g_dwUseDrugInterval;
    EditCommonMpTimer.MinValue := g_dwUseDrugInterval;
    EditSpecialHpTimer.MinValue := g_dwUseDrugInterval;
    EditSpecialMpTimer.MinValue := g_dwUseDrugInterval;
    EditRandomHpTimer.MinValue := g_dwUseItemInterval;


    EditCommonHpName.Clear;
    for I := 0 to g_ItemList.Count - 1 do
    begin
      if (g_ItemList.Items[I]<>nil) and (g_ItemList.Items[I].StdMode = 0) and (g_ItemList.Items[I].Shape = 0) and (g_ItemList.Items[I].ACMin > 0) then
        EditCommonHpName.Items.Add(g_ItemList.Items[I].DisplayName);
    end;
    EditCommonMpName.Clear;
    for I := 0 to g_ItemList.Count - 1 do
    begin
      if (g_ItemList.Items[I]<>nil) and (g_ItemList.Items[I].StdMode = 0) and (g_ItemList.Items[I].Shape = 0) and (g_ItemList.Items[I].MACMin > 0) then
        EditCommonMpName.Items.Add(g_ItemList.Items[I].DisplayName);
    end;
    EditSpecialHpName.Clear;
    for I := 0 to g_ItemList.Count - 1 do
    begin
      if (g_ItemList.Items[I]<>nil) and (g_ItemList.Items[I].StdMode = 0) and (g_ItemList.Items[I].Shape = 1) and (g_ItemList.Items[I].ACMin > 0) then
        EditSpecialHpName.Items.Add(g_ItemList.Items[I].DisplayName);
    end;
    EditSpecialMpName.Clear;
    for I := 0 to g_ItemList.Count - 1 do
    begin
      if (g_ItemList.Items[I]<>nil) and (g_ItemList.Items[I].StdMode = 0) and (g_ItemList.Items[I].Shape = 1) and (g_ItemList.Items[I].MACMin > 0) then
        EditSpecialMpName.Items.Add(g_ItemList.Items[I].DisplayName);
    end;
    EditRandomName.Clear;
    EditRandomName.Items.Add('回城卷');
    EditRandomName.Items.Add('行会回城卷');
    EditRandomName.Items.Add('盟重传送石');
    EditRandomName.Items.Add('比奇传送石');
    EditRandomName.Items.Add('随机传送石');
    EditRandomName.Items.Add('随机传送卷');
    EditRandomName.Items.Add('地牢逃脱卷');

    EditMonNameList.Items.Assign(g_Config.Assistant.MonHints);
    EditItemKind.Clear;

    EditItemKind.Clear;
    for I := Low(STR_STDMODEFILTER) to High(STR_STDMODEFILTER) do
      EditItemKind.Items.Add(STR_STDMODEFILTER[I]);
    EditItemKind.ItemIndex := 0;
    EditItemKindChange(nil);


    EditAllowGroup.Checked := g_boAllowGroup;
    EditAllowGroupReCall.Checked := g_boAllowGroupRecall;
    EditAllowGuild.Checked := g_boAllowGuild;
    EditAllowGuildReCall.Checked := g_boAllowGuildRecall;
    EditNotAllowDeal.Checked := not g_boAllowDeal;

    EditAutoFireHit.Checked := g_Config.Assistant.AutoFireHit;
    EditAutoHide.Checked := g_Config.Assistant.AutoHide;
    EditAutoMagic.Checked := g_Config.Assistant.AutoMagic;
    EditAutoMagicInterval.Value := g_Config.Assistant.AutoMagicTime;
    EditAutoPick.Checked := g_Config.Assistant.AutoPuckUpItem;
    EditAutoWideHit.Checked := g_Config.Assistant.AutoWideHit;
    EditAvoidShift.Checked := g_Config.Assistant.NoShift;
    EditBGSound.Checked := g_Config.Assistant.BGSound;
    EditCleanCorpse.Checked := g_Config.Assistant.CleanCorpse;
    EditDuraWarning.Checked := g_Config.Assistant.DuraWarning;
    EditFilterExp.Checked := g_Config.Assistant.FilterExp;
    EditFilterExpNum.Value := g_Config.Assistant.FilterExpValue;
    EditFilterItemName.Checked := g_Config.Assistant.FilterItemName;
    EditGWLongHit.Checked := g_Config.Assistant.SPLongHit;
    EditHideDressEff.Checked := g_Config.Assistant.HideDressEff;
    EditHideWepEff.Checked := g_Config.Assistant.HideWepEff;
    EditMagicLock.Checked := g_Config.Assistant.MagicLock;
    EditPickFilter.Checked := g_Config.Assistant.FilterPickItem;
    EditSdoLongHit.Checked := g_Config.Assistant.LongHit;
    EditShieldAlways.Checked := g_Config.Assistant.AutoShield;
    EditShowBloodChange.Checked := g_Config.Assistant.ShowHealthStatus;
    EditShowBloodHeader.Checked := g_Config.Assistant.ShowBlood;
    EditShowBloodNum.Checked := g_Config.Assistant.ShowBloodNum;
    EditShowItemName.Checked := g_Config.Assistant.ShowAllItem;
    EditShowJobLv.Checked := g_Config.Assistant.ShowJobLevel;
    EditShowMonName.Checked := g_Config.Assistant.ShowMonName;
    EditShowName.Checked := g_Config.Assistant.ShowName;
    EditShowNPCName.Checked := g_Config.Assistant.ShowNPCName;
    EditShowRankName.Checked := g_Config.Assistant.ShowRankName;
    EditShowTitle.Checked := g_Config.Assistant.ShowTitle;
    EditSound.Checked := g_Config.Assistant.Sound;
    EditZhuri.Checked := g_Config.Assistant.AutoZhuriHit;
    EditMonNameList.Items.Assign(g_Config.Assistant.MonHints);
    EditMonNameList.Items.Assign(g_Config.Assistant.MonHints);
    TrackBGSound.Position := g_Config.Assistant.BGSoundVolume;
    TrackSound.Position := g_Config.Assistant.SoundVolume;

    EditCommonHp.Checked := g_Config.Assistant.CommonHp;
    EditCommonHpValue.Value := g_Config.Assistant.EditCommonHp;
    EditCommonHpTimer.Value := g_Config.Assistant.EditCommonHpTimer;
    EditCommonHpName.Text := g_Config.Assistant.DefCommonHpName;
    EditCommonMp.Checked := g_Config.Assistant.CommonMp;
    EditCommonMpValue.Value := g_Config.Assistant.EditCommonMp;
    EditCommonMpTimer.Value := g_Config.Assistant.EditCommonMpTimer;
    EditCommonMpName.Text := g_Config.Assistant.DefCommonMpName;
    EditSpecialHp.Checked := g_Config.Assistant.SpecialHp;
    EditSpecialHpValue.Value := g_Config.Assistant.EditSpecialHp;
    EditSpecialHpTimer.Value := g_Config.Assistant.EditSpecialHpTimer;
    EditSpecialHpName.Text := g_Config.Assistant.DefSpecialHpName;
    EditSpecialMp.Checked := g_Config.Assistant.SpecialMp;
    EditSpecialMpValue.Value := g_Config.Assistant.EditSpecialMp;
    EditSpecialMpTimer.Value := g_Config.Assistant.EditSpecialMpTimer;
    EditSpecialMpName.Text := g_Config.Assistant.DefSpecialMpName;
    EditRandomHp.Checked := g_Config.Assistant.RandomHp;
    EditRandomHpValue.Value := g_Config.Assistant.EditRandomHp;
    EditRandomHpTimer.Value := g_Config.Assistant.EditRandomHpTimer;
    EditRandomName.ItemIndex := g_Config.Assistant.RandomType;
    EditRandomName.Text := g_Config.Assistant.RandomName;
    EditMonHintInterval.Value := g_Config.Assistant.MonHintInterval;

    g_Config.Assistant.EditRandomHp := Max(0, EditRandomHpValue.Value);
    g_Config.Assistant.RandomType :=  EditRandomName.ItemIndex;
    g_Config.Assistant.RandomName :=  EditRandomName.Text;

    EditDufu.Checked := g_Config.Assistant.AutoTurnDuFu;
    chk_SmartWalk.Checked := g_Config.Assistant.SmartWalk;


    BtnSave.Enabled := False;
  finally
    FLoading := False;
  end;
end;

procedure TStandardAssistantForm.Save;
begin
  g_Config.Assistant.MonHints.Assign(EditMonNameList.Items);
  g_Config.Save;
  BtnSave.Enabled := False;
end;

procedure TStandardAssistantForm.EditMonHintIntervalChange(Sender: TObject);
begin
  g_Config.Assistant.MonHintInterval := EditMonHintInterval.Value;
  Modify;
end;

procedure TStandardAssistantForm.TrackBGSoundChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.BGSoundVolume := TrackBGSound.Position;
  g_SoundManager.SetBGSoundVolume(TrackBGSound.Position);
  Modify;
end;

procedure TStandardAssistantForm.TrackSoundChange(Sender: TObject);
begin
  if FLoading then
    Exit;
  g_Config.Assistant.SoundVolume := TrackSound.Position;
  g_SoundManager.SetSoundVolume(TrackSound.Position);
  Modify;
end;

procedure TStandardAssistantForm.UpdateButtonsState;
begin
  BtnEditMonName.Enabled := EditMonNameList.ItemIndex <> -1;
  BtnDeleteMonName.Enabled := EditMonNameList.ItemIndex <> -1;
end;

procedure TStandardAssistantForm.Modify;
begin
  BtnSave.Enabled := True;
end;

end.
