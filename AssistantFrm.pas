unit AssistantFrm;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Generics.Collections,
  StdCtrls, Grids, Grobal2, clFunc, hUtil32, cliUtil, EDcode, SoundUtil, Actor,
  DWinCtl, DXHelper, uUITypes, uCliUITypes, uTypes, Common, uMapDesc, uMessageParse,
  AbstractCanvas, AbstractTextures, AsphyreTypes, uEDcode, uTextures, Clipbrd,
  ExtCtrls, Math, Menus;

type
  TAssistantForm = class(TForm)
    DWAssistant: TDWindow;
    DNewSdoAssistantClose: TDButton;
    DNewSdoBasic: TDButton;
    DNewSdoProtect: TDButton;
    DNewSdoSkill: TDButton;
    DNewSdoKey: TDButton;
    DNedSdoHelp: TDButton;
    DCheckSdoNameShow: TDCheckBox;
    DCheckSdoDuraWarning: TDCheckBox;
    DCheckSdoAvoidShift: TDCheckBox;
    DCheckSdoItemsHint: TDCheckBox;
    DCheckSdoShowFiltrate: TDCheckBox;
    DCheckSdoAutoPickItems: TDCheckBox;
    DCheckSdoPickFiltrate: TDCheckBox;
    DCheckSdoLongHit: TDCheckBox;
    DCheckSdoAutoWideHit: TDCheckBox;
    DCheckSdoAutoFireHit: TDCheckBox;
    DCheckSdoZhuri: TDCheckBox;
    DCheckSdoAutoShield: TDCheckBox;
    DCheckSdoAutoHide: TDCheckBox;
    DCheckSdoAutoMagic: TDCheckBox;
    DEdtSdoAutoMagicTimer: TDEdit;
    DCheckSdoCommonHp: TDCheckBox;
    DEdtSdoCommonHp: TDEdit;
    DEdtSdoCommonHpTimer: TDEdit;
    DCheckSdoCommonMp: TDCheckBox;
    DEdtSdoCommonMp: TDEdit;
    DEdtSdoCommonMpTimer: TDEdit;
    DCheckSdoSpecialHp: TDCheckBox;
    DEdtSdoSpecialHp: TDEdit;
    DEdtSdoSpecialHpTimer: TDEdit;
    DCheckSdoRandomHp: TDCheckBox;
    DEdtSdoRandomHp: TDEdit;
    DEdtSdoRandomHpTimer: TDEdit;
    DSdoHelpUp: TDButton;
    DSdoHelpNext: TDButton;
    DCheckSdoStartKey: TDCheckBox;
    DBtnSdoAttackModeKey: TDButton;
    DBtnSdoMinMapKey: TDButton;
    DBtnSdoRandomName: TDButton;
    DCheckSdoAutoDrinkWine: TDCheckBox;
    DEdtSdoDrunkWineDegree: TDEdit;
    DCheckSdoShowMonName: TDCheckBox;
    DCheckSdoAutoDrinkDrugWine: TDCheckBox;
    DEdtSdoDrunkDrugWineDegree: TDEdit;
    DCheckSdoAutoUseHuoLong: TDCheckBox;
    DCheckSdoAutoSearchItem: TDCheckBox;
    DChecksdoAutoUseJinyuan: TDCheckBox;
    DBtnSdoUseBatterKey: TDButton;
    DCheckSdoNPCNameShow: TDCheckBox;
    DCheckSdoBloodShow: TDCheckBox;
    DGoodFilter: TDButton;
    DSdoItemUp: TDButton;
    DSdoItemDown: TDButton;
    DCheckSdoRankNameShow: TDCheckBox;
    DWBasic: TDWindow;
    DWProtect: TDWindow;
    DWSkill: TDWindow;
    DWKey: TDWindow;
    DWItems: TDWindow;
    DWHelp: TDWindow;
    DCheckSdoTitle: TDCheckBox;
    DCheckGroupHeader: TDCheckBox;
    DBtnCommonHpName: TDButton;
    DBtnCommonMpName: TDButton;
    DEdtSdoSpecialHpName: TDButton;
    DCheckAllowDeal: TDCheckBox;
    DCheckAllowGuild: TDCheckBox;
    DCheckAllowGroup: TDCheckBox;
    DCheckAllowGroupReCall: TDCheckBox;
    DCheckAllowGuildReCall: TDCheckBox;
    DEditItemSearch: TDEdit;
    DBtnItemSearch: TDButton;
    DCheckAllowReAlive: TDCheckBox;
    DBItemScroll: TDButton;
    EditStdItemMode: TDButton;
    ItemScrollTimer: TTimer;
    DCheckSdoGWLongHit: TDCheckBox;
    DCheckCleanCorpse: TDCheckBox;
    DCheckMagicLock: TDCheckBox;
    DCheckSdoSpecialMp: TDCheckBox;
    DEdtSdoSpecialMp: TDEdit;
    DEdtSdoSpecialMpTimer: TDEdit;
    DEdtSdoSpecialMpName: TDButton;
    DSmartWalk: TDCheckBox;
    DCheckSdoAutoDufu: TDCheckBox;
    procedure DWAssistantMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DNewSdoBasicClick(Sender: TObject; X, Y: Integer);
    procedure DNewSdoBasicDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DNewSdoAssistantCloseClick(Sender: TObject; X, Y: Integer);
    procedure DNewSdoAssistantCloseDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DCheckSdoNameShowClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoNameShowDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DEdtSdoCommonMpDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DCheckSdoNPCNameShowClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoRankNameShowClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoDuraWarningClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoAvoidShiftClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoShowMonNameClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoBloodShowClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoItemsHintClick(Sender: TObject; X, Y: Integer);
    procedure f(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoAutoPickItemsClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoPickFiltrateClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoAutoSearchItemClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoAutoUseHuoLongClick(Sender: TObject; X, Y: Integer);
    procedure DChecksdoAutoUseJinyuanClick(Sender: TObject; X, Y: Integer);
    procedure DBtnSdoRandomNameClick(Sender: TObject; X, Y: Integer);
    procedure DBtnSdoRandomNameDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DBtnSdoUseBatterKeyDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DBtnSdoUseBatterKeyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBtnSdoUseBatterKeyMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DWItemsClick(Sender: TObject; X, Y: Integer);
    procedure DSdoHelpUpClick(Sender: TObject; X, Y: Integer);
    procedure DSdoHelpNextClick(Sender: TObject; X, Y: Integer);
    procedure DWBasicDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DWProtectDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DWSkillDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DWKeyDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DWItemsDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DWHelpDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DCheckSdoNameShowMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DEdtSdoCommonHpChange(Sender: TObject);
    procedure DEdtSdoCommonHpKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DEdtSdoCommonHpKeyPress(Sender: TObject; var Key: Char);
    procedure DCheckSdoCommonHpClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoSpecialHpClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoCommonMpClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoRandomHpClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoAutoDrinkWineClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoAutoDrinkDrugWineClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoLongHitClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoAutoWideHitClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoAutoFireHitClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoZhuriClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoAutoShieldClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoAutoHideClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoAutoMagicClick(Sender: TObject; X, Y: Integer);
    procedure DEdtSdoCommonHpTimerChange(Sender: TObject);
    procedure DEdtSdoCommonMpChange(Sender: TObject);
    procedure DEdtSdoSpecialHpChange(Sender: TObject);
    procedure DEdtSdoRandomHpChange(Sender: TObject);
    procedure DEdtSdoDrunkWineDegreeChange(Sender: TObject);
    procedure DEdtSdoDrunkDrugWineDegreeChange(Sender: TObject);
    procedure DEdtSdoCommonMpTimerChange(Sender: TObject);
    procedure DEdtSdoSpecialHpTimerChange(Sender: TObject);
    procedure DEdtSdoRandomHpTimerChange(Sender: TObject);
    procedure DEdtSdoAutoMagicTimerChange(Sender: TObject);
    procedure DCheckSdoTitleClick(Sender: TObject; X, Y: Integer);
    procedure DCheckGroupHeaderClick(Sender: TObject; X, Y: Integer);
    procedure DBtnCommonHpNameClick(Sender: TObject; X, Y: Integer);
    procedure DBtnCommonMpNameClick(Sender: TObject; X, Y: Integer);
    procedure DEdtSdoSpecialHpNameClick(Sender: TObject; X, Y: Integer);
    procedure DEdtSdoSpecialHpNameDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DBtnCommonMpNameDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DBtnCommonHpNameDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DCheckAllowDealClick(Sender: TObject; X, Y: Integer);
    procedure DCheckAllowDealDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DCheckAllowGroupClick(Sender: TObject; X, Y: Integer);
    procedure DCheckAllowGroupDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DCheckAllowGuildDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DCheckAllowGuildClick(Sender: TObject; X, Y: Integer);
    procedure DCheckAllowGroupReCallClick(Sender: TObject; X, Y: Integer);
    procedure DCheckAllowGuildReCallClick(Sender: TObject; X, Y: Integer);
    procedure DCheckAllowGroupReCallDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DCheckAllowGuildReCallDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DBtnItemSearchDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure FormCreate(Sender: TObject);
    procedure DBtnItemSearchClick(Sender: TObject; X, Y: Integer);
    procedure DWItemsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DCheckAllowReAliveDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DCheckAllowReAliveClick(Sender: TObject; X, Y: Integer);
    procedure DSdoItemUpMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DSdoItemDownMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DEditItemSearchDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DWAssistantVisibleChange(Sender: TObject);
    procedure DWProtectClick(Sender: TObject; X, Y: Integer);
    procedure DWKeyClick(Sender: TObject; X, Y: Integer);
    procedure EditStdItemModeDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure EditStdItemModeClick(Sender: TObject; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure DBItemScrollMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DBItemScrollMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBItemScrollMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DSdoItemUpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DSdoItemUpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DSdoItemDownMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DSdoItemDownMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ItemScrollTimerTimer(Sender: TObject);
    procedure DCheckSdoGWLongHitClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoGWLongHitDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DWItemsMouseWheelDownEvent(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DWItemsMouseWheelUpEvent(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DCheckCleanCorpseClick(Sender: TObject; X, Y: Integer);
    procedure DCheckCleanCorpseDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DCheckMagicLockClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoAutoShieldDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoLongHitDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoAutoWideHitDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoAutoFireHitDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoZhuriDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoAutoHideDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckMagicLockDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoAutoMagicDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoAvoidShiftDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoNPCNameShowDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoRankNameShowDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoDuraWarningDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoShowMonNameDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoBloodShowDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoTitleDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckGroupHeaderDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoItemsHintDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoAutoPickItemsDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoPickFiltrateDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoAutoSearchItemDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoAutoUseHuoLongDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DChecksdoAutoUseJinyuanDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoStartKeyClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoStartKeyDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoCommonHpDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoCommonMpDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoSpecialHpDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoRandomHpDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoSpecialMpDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DCheckSdoSpecialMpClick(Sender: TObject; X, Y: Integer);
    procedure DEdtSdoSpecialMpChange(Sender: TObject);
    procedure DEdtSdoSpecialMpDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DEdtSdoSpecialMpTimerChange(Sender: TObject);
    procedure DEdtSdoSpecialMpNameClick(Sender: TObject; X, Y: Integer);
    procedure DEdtSdoSpecialMpNameDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DSmartWalkClick(Sender: TObject; X, Y: Integer);
    procedure DSmartWalkDirectPaint(Sender: TObject; DSurface: TAsphyreCanvas);
    procedure DCheckSdoAutoDufuClick(Sender: TObject; X, Y: Integer);
    procedure DCheckSdoAutoDufuDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
  private
    { Private declarations }
    FItemIndex: Integer; //辅助物品顶部序号
    FActiveItemIndex: Integer;
    FilterItemMode: Integer;
    FliterItems: TList<pTStdItem>;
    FOldScrollTop: Integer;
    procedure NewSdoAssistantPageChanged;
    procedure DrawControl(DSurface: TAsphyreCanvas; Button: TDButton; out FontColor: TColor);
    procedure DrawCheckControl(DSurface: TAsphyreCanvas; ACheckBox: TDCheckBox; AChecked: Boolean; const ACaption: String);
    procedure DrawEdit(AEdit: TDEdit; DSurface: TAsphyreCanvas);
    procedure Filter(ATag: Integer);
    procedure ReCalcItemScrollPos;
  public
    { Public declarations }
    procedure Initialize;
    procedure UpdateForm;
    procedure Save(const ChrName: String);
    procedure ClearFilter;
  end;

var
  AssistantForm: TAssistantForm;

implementation
  uses AsphyreTextureFonts, ClMain, MShare, Share, DrawScrn, FState, PopupMeunuFrm;

{$R *.dfm}

{ TForm1 }

function ItemIntervalText(const S : String):Integer;
begin
  Result := Max(StrToIntDef(S,1),g_dwUseItemInterval);
end;

function DrugIntervalText(const S : string):Integer;
begin
  Result := Max(StrToIntDef(S,1),g_dwUseDrugInterval);
end;


procedure TAssistantForm.ClearFilter;
begin
  Filter(0);
end;

procedure TAssistantForm.DBItemScrollMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FOldScrollTop := Y;
end;

procedure TAssistantForm.DBItemScrollMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  AScrollHeight,
  NewTop: Integer;
begin
  if DBItemScroll.Downed then
  begin
    if FOldScrollTop <> Y then
    begin
      NewTop := DBItemScroll.Top - (FOldScrollTop - Y);
      if NewTop < DSdoItemUp.Top + DSdoItemUp.Height then
        NewTop := DSdoItemUp.Top + DSdoItemUp.Height
      else if NewTop > DSdoItemDown.Top - DBItemScroll.Height then
        NewTop := DSdoItemDown.Top - DBItemScroll.Height;
      DBItemScroll.Top := NewTop;
      FOldScrollTop := Y;

      AScrollHeight := DSdoItemDown.Top - DSdoItemUp.Top - DSdoItemUp.Height - DBItemScroll.Height;
      NewTop := DBItemScroll.Top - DSdoItemUp.Top - DSdoItemUp.Height;

      NewTop := Round((NewTop / AScrollHeight) * FliterItems.Count);
      NewTop := Max(0, NewTop);
      NewTop := Min(NewTop, FliterItems.Count - 1);
      FItemIndex := NewTop;
    end;
  end;
end;

procedure TAssistantForm.DBItemScrollMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FOldScrollTop := 0;
end;

procedure TAssistantForm.DBtnCommonHpNameClick(Sender: TObject; X, Y: Integer);
var
  I: Integer;
begin
  if DXPopupMenu.PopVisible then
    DXPopupMenu.HidePopup
  else
  begin
    with DBtnCommonHpName do
    begin
      DXPopupMenu.BeginUpdate;
      DXPopupMenu.Clear;
      DXPopupMenu.AddMenuItem(0, '<无>');
      for I := 0 to g_ItemList.Count - 1 do
        if (g_ItemList.Items[I]<>nil) and (g_ItemList.Items[I].StdMode = 0) and (g_ItemList.Items[I].Shape = 0) and (g_ItemList.Items[I].ACMin > 0) then
          DXPopupMenu.AddMenuItem(I, g_ItemList.Items[I].DisplayName);
      DXPopupMenu.EndUpdate;
      DXPopupMenu.Popup(DWProtect, Left, Top + Height, Width,
        procedure(ATag: Integer; const ACaption: String)
        begin
          g_Config.Assistant.DefCommonHpName := '';
          if Tag <> 0 then
            g_Config.Assistant.DefCommonHpName := ACaption;
        end
      );
    end;
  end;
end;

procedure TAssistantForm.DBtnCommonHpNameDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  FontColor: TColor;
begin
  DrawControl(dsurface, DBtnCommonHpName, FontColor);
  with Sender as TDButton do
  begin
    DSurface.BoldText(g_Config.Assistant.DefCommonHpName, FontColor, clBlack, SurfaceX(Left) + 2, SurfaceY(Top) + 4);
  end;
end;

procedure TAssistantForm.DBtnCommonMpNameClick(Sender: TObject; X, Y: Integer);
var
  I: Integer;
begin
  if DXPopupMenu.PopVisible then
    DXPopupMenu.HidePopup
  else
  begin
    with DBtnCommonMpName do
    begin
      DXPopupMenu.BeginUpdate;
      DXPopupMenu.Clear;
      DXPopupMenu.AddMenuItem(0, '<无>');
      for I := 0 to g_ItemList.Count - 1 do
        if (g_ItemList.Items[I]<>nil) and (g_ItemList.Items[I].StdMode = 0) and (g_ItemList.Items[I].Shape = 0) and (g_ItemList.Items[I].MACMin > 0) then
          DXPopupMenu.AddMenuItem(I, g_ItemList.Items[I].DisplayName);
      DXPopupMenu.EndUpdate;
      DXPopupMenu.Popup(DWProtect, Left, Top + Height, Width,
        procedure(ATag: Integer; const ACaption: String)
        begin
          g_Config.Assistant.DefCommonMpName := '';
          if Tag <> 0 then
            g_Config.Assistant.DefCommonMpName := ACaption;
        end
      );
    end;
  end;
end;

procedure TAssistantForm.DBtnCommonMpNameDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  FontColor: TColor;
begin
  DrawControl(dsurface, DBtnCommonMpName, FontColor);
  with Sender as TDButton do
  begin
    DSurface.BoldText(g_Config.Assistant.DefCommonMpName, FontColor, clBlack, SurfaceX(Left) + 2, SurfaceY(Top) + 4);
  end;
end;

procedure TAssistantForm.DBtnItemSearchClick(Sender: TObject; X, Y: Integer);

  function DoSearch(Start: Integer; const AName: String): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := Start to FliterItems.Count - 1 do
    begin
      if FliterItems[I] <> nil then
      begin
        if Pos(AName, FliterItems[I].Name) > 0 then
        begin
          FActiveItemIndex := I;
          FItemIndex := (Ceil(I / 9) - 1) * 9;
          Result := True;
          Break;
        end;
      end;
    end;
  end;

var
  AItemName: String;
  I, AStart: Integer;
begin
  AItemName := DEditItemSearch.Text;
  if AItemName <> '' then
  begin
    if FActiveItemIndex = -1 then
      AStart := 0
    else
      AStart := FActiveItemIndex + 1;
    FActiveItemIndex := -1;
    if not DoSearch(AStart, AItemName) and (AStart <> 0) then
      DoSearch(0, AItemName);
  end
  else
    g_Application.AddMessageDialog('请输入物品名称的关键字', [mbOk]);
end;

procedure TAssistantForm.DBtnItemSearchDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  d: TAsphyreLockableTexture;
  ATexture: TAsphyreLockableTexture;
begin
  with DBtnItemSearch do
  begin
    if Downed then
      d := g_77Images.Images[153]
    else
      d := g_77Images.Images[152];
    if D <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
    ATexture := FontManager.Default.TextOut('搜索...');
    if ATexture <> nil then
    begin
      if Downed then
        dsurface.DrawBoldText(SurfaceX(Left) + (Width - ATexture.Width) div 2 + 1, SurfaceY(Top) + (Height - ATexture.Height) div 2 + 1, ATexture, clWhite, FontBorderColor)
      else
        dsurface.DrawBoldText(SurfaceX(Left) + (Width - ATexture.Width) div 2, SurfaceY(Top) + (Height - ATexture.Height) div 2, ATexture, clWhite, FontBorderColor);
    end;
  end;
end;

procedure TAssistantForm.DBtnSdoRandomNameClick(Sender: TObject; X, Y: Integer);
begin
  if DXPopupMenu.PopVisible then
    DXPopupMenu.HidePopup
  else
  begin
    with DBtnSdoRandomName do
    begin
      DXPopupMenu.BeginUpdate;
      DXPopupMenu.Clear;
      DXPopupMenu.AddMenuItem(0, '回城卷');
      DXPopupMenu.AddMenuItem(1, '行会回城卷');
      DXPopupMenu.AddMenuItem(2, '盟重传送石');
      DXPopupMenu.AddMenuItem(3, '比奇传送石');
      DXPopupMenu.AddMenuItem(4, '随机传送石');
      DXPopupMenu.AddMenuItem(5, '随机传送卷');
      DXPopupMenu.AddMenuItem(6, '地牢逃脱卷');
      DXPopupMenu.EndUpdate;
      DXPopupMenu.Popup(DWProtect, Left, Top + Height, Width,
        procedure(ATag: Integer; const ACaption: String)
        begin
          g_Config.Assistant.RandomType :=  ATag;
          g_Config.Assistant.RandomName :=  ACaption;
        end
      );
    end;
  end;
end;

procedure TAssistantForm.DBtnSdoRandomNameDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  FontColor: TColor;
begin
  DrawControl(dsurface, DBtnSdoRandomName, FontColor);
  with Sender as TDButton do
  begin
    DSurface.BoldText(g_Config.Assistant.RandomName, FontColor, clBlack, SurfaceX(Left) + 2, SurfaceY(Top) + 4);
  end;
end;

procedure TAssistantForm.DBtnSdoUseBatterKeyDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  TextColor: TColor;
begin
  with Sender as TDButton do
  begin
    if Focused then
    begin
      Color := $005993BD;
      TextColor := clAqua;
    end
    else if Moveed then
    begin
      Color := $005993BD;
      TextColor := clYellow;
    end
    else
    begin
      Color := $00638494;
      TextColor := clWhite;
    end;
    dsurface.FillRect(Rect(SurfaceX(Left), SurfaceY(Top), SurfaceX(Left) + WIDTH, SurfaceY(Top) + Height), cColor4(cColor1(clBlack)));
    dsurface.FrameRect(Rect(SurfaceX(Left), SurfaceY(Top), SurfaceX(Left) + WIDTH, SurfaceY(Top) + Height), cColor4(cColor1(Color)));
    dsurface.FrameRect(Rect(SurfaceX(Left) - 1, SurfaceY(Top) - 1, SurfaceX(Left) + WIDTH + 1, SurfaceY(Top) + Height + 1), cColor4(cColor1(Color)));
    DSurface.BoldText(TDButton(Sender).Hint, TextColor, clBlack, SurfaceX(Left) + 64 - FrmMain.Canvas.TextWidth(TDButton(Sender).Hint) div 2, SurfaceY(Top) + 4);
  end;
end;

procedure TAssistantForm.DBtnSdoUseBatterKeyKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  CombinationKey: Integer;
begin
  if Key in [DBtnSdoUseBatterKey.Tag, DBtnSdoAttackModeKey.Tag, DBtnSdoMinMapKey.Tag] then
  begin
    Exit;
  end;
  if Key in [0 .. 7, 9 .. 11, 12, 14 .. 15, 21 .. 32, 41 .. 45, 47 .. 92, 94 .. 123, 144 .. 145, 186 .. 192, 219 .. 222, 226] then
  begin
    TDButton(Sender).Hint := '';
    CombinationKey := 0;
    if ssCtrl in Shift then
      TDButton(Sender).Hint := 'Ctrl+';
    if ssShift in Shift then
      TDButton(Sender).Hint := TDButton(Sender).Hint + 'Shift+';
    if ssAlt in Shift then
      TDButton(Sender).Hint := TDButton(Sender).Hint + 'Alt+';
    case Key of
      0 .. 7, 9 .. 11, 14 .. 15, 21 .. 26, 28 .. 32, 41 .. 44, 47 .. 92, 94 .. 95:
        TDButton(Sender).Hint := TDButton(Sender).Hint + Char(Key);
      12:
        TDButton(Sender).Hint := TDButton(Sender).Hint + 'Num 5';
      27:
        TDButton(Sender).Hint := TDButton(Sender).Hint + 'Esc';
      45:
        TDButton(Sender).Hint := TDButton(Sender).Hint + 'Insert';
      96 .. 105: // 小键盘
        TDButton(Sender).Hint := TDButton(Sender).Hint + 'Num ' + Char(Key - 48);
      106 .. 111:
        TDButton(Sender).Hint := TDButton(Sender).Hint + 'Num ' + Char(Key - 64);
      112 .. 122: // 功能键
        TDButton(Sender).Hint := TDButton(Sender).Hint + 'F' + IntToStr(Key - 112 + 1);
      123:
        begin
          FrmMain.OpenSdoAssistant();
          Exit;
        end;
      144: // Pause 小键开启灯那个
        TDButton(Sender).Hint := TDButton(Sender).Hint + 'Pause';
      145: // Scroll Lock
        TDButton(Sender).Hint := TDButton(Sender).Hint + 'Scroll Lock';
      192:
        TDButton(Sender).Hint := TDButton(Sender).Hint + Char(Key - 96);
      186:
        TDButton(Sender).Hint := TDButton(Sender).Hint + Char(Key - 127);
      187 .. 191:
        TDButton(Sender).Hint := TDButton(Sender).Hint + Char(Key - 144);
      219 .. 221:
        TDButton(Sender).Hint := TDButton(Sender).Hint + Char(Key - 128);
      222:
        TDButton(Sender).Hint := TDButton(Sender).Hint + Char(Key - 183);
      226:
        TDButton(Sender).Hint := TDButton(Sender).Hint + Char(Key - 134);
    else
      // TDButton(Sender).Hint := inttostr(key);
    end;
    // if  not DCheckSdoStartKey.Checked then begin TDButton(Sender).Tag := Key //else begin
    if pos('Ctrl', TDButton(Sender).Hint) > 0 then
      CombinationKey := 16384;
    if pos('Shift', TDButton(Sender).Hint) > 0 then
      CombinationKey := CombinationKey + 8192;
    if pos('Alt', TDButton(Sender).Hint) > 0 then
      CombinationKey := CombinationKey + 32768;
    TDButton(Sender).Tag := Key;
  end;
end;

procedure TAssistantForm.DBtnSdoUseBatterKeyMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    if Sender = DBtnSdoUseBatterKey then
    begin
      DBtnSdoUseBatterKey.Hint := '';
      DBtnSdoUseBatterKey.Tag := 0;
    end;
    if Sender = DBtnSdoAttackModeKey then
    begin
      DBtnSdoAttackModeKey.Hint := '';
      DBtnSdoAttackModeKey.Tag := 0;
    end;
    if Sender = DBtnSdoMinMapKey then
    begin
      DBtnSdoMinMapKey.Hint := '';
      DBtnSdoMinMapKey.Tag := 0;
    end;
  end;
end;

procedure TAssistantForm.DCheckAllowDealClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DCheckAllowDeal.TimeTick > 1000 then
  begin
    g_boAllowDeal := not g_boAllowDeal;
    DCheckAllowDeal.TimeTick := GetTickCount;
    FrmMain.SendChangeState(STATE_ALLOWDEAL, g_boAllowDeal);
  end;
end;

procedure TAssistantForm.DCheckAllowDealDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  DrawCheckControl(dsurface, DCheckAllowDeal, g_boAllowDeal, DCheckAllowDeal.Caption);
end;

procedure TAssistantForm.DCheckAllowGroupClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount > g_dwChangeGroupModeTick then
  begin
    g_boAllowGroup := not g_boAllowGroup;
    g_dwChangeGroupModeTick := GetTickCount + 1000;
    FrmMain.SendChangeState(STATE_ALLOWGROUP, g_boAllowGroup);
    SetAllowGroup(g_boAllowGroup);
  end;
end;

procedure TAssistantForm.DCheckAllowGroupDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  DrawCheckControl(dsurface, DCheckAllowGroup, g_boAllowGroup, DCheckAllowGroup.Caption);
end;

procedure TAssistantForm.DCheckAllowGroupReCallClick(Sender: TObject; X,
  Y: Integer);
begin
  if GetTickCount - DCheckAllowGroupReCall.TimeTick > 1000 then
  begin
    g_boAllowGroupRecall := not g_boAllowGroupRecall;
    DCheckAllowGroupReCall.TimeTick := GetTickCount;
    FrmMain.SendChangeState(STATE_ALLOWGROUPRECALL, g_boAllowGroupRecall);
  end;
end;

procedure TAssistantForm.DCheckAllowGroupReCallDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  DrawCheckControl(dsurface, DCheckAllowGroupReCall, g_boAllowGroupRecall, DCheckAllowGroupReCall.Caption);
end;

procedure TAssistantForm.DCheckAllowGuildClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DCheckAllowGuild.TimeTick > 1000 then
  begin
    DCheckAllowGuild.TimeTick := GetTickCount;
    g_boAllowGuild := not g_boAllowGuild;
    FrmMain.SendChangeState(STATE_ALLOWGUILD, g_boAllowGuild);
  end;
end;

procedure TAssistantForm.DCheckAllowGuildDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  DrawCheckControl(dsurface, DCheckAllowGuild, g_boAllowGuild, DCheckAllowGuild.Caption);
end;

procedure TAssistantForm.DCheckAllowGuildReCallClick(Sender: TObject; X,
  Y: Integer);
begin
  if GetTickCount - DCheckAllowGuildReCall.TimeTick > 1000 then
  begin
    g_boAllowGuildRecall := not g_boAllowGuildRecall;
    DCheckAllowGuildReCall.TimeTick := GetTickCount;
    FrmMain.SendChangeState(STATE_ALLOWGUILDRECALL, g_boAllowGuildRecall);
  end;
end;

procedure TAssistantForm.DCheckAllowGuildReCallDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  DrawCheckControl(dsurface, DCheckAllowGuildReCall, g_boAllowGuildRecall, DCheckAllowGuildReCall.Caption);
end;

procedure TAssistantForm.DCheckAllowReAliveClick(Sender: TObject; X,
  Y: Integer);
begin
  if GetTickCount - DCheckAllowReAlive.TimeTick > 1000 then
  begin
    g_boAllowReAlive := not g_boAllowReAlive;
    DCheckAllowReAlive.TimeTick := GetTickCount;
    FrmMain.SendChangeState(STATE_ALLOWRELIVE, g_boAllowReAlive);
  end;
end;

procedure TAssistantForm.DCheckAllowReAliveDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  DrawCheckControl(dsurface, DCheckAllowReAlive, g_boAllowReAlive, DCheckAllowReAlive.Caption);
end;

procedure TAssistantForm.DCheckCleanCorpseClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.CleanCorpse := not g_Config.Assistant.CleanCorpse;
end;

procedure TAssistantForm.DCheckCleanCorpseDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  DrawCheckControl(dsurface, DCheckCleanCorpse, g_Config.Assistant.CleanCorpse, DCheckCleanCorpse.Caption);
end;

procedure TAssistantForm.DCheckGroupHeaderClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.ShowGroupHead := not g_Config.Assistant.ShowGroupHead;
  if not g_Config.Assistant.ShowGroupHead then
    FrmDlg.DWGroups.Visible := False
  else
  begin
    if g_GroupMembers.Count > 0 then
    begin
      FrmDlg.ReBuildGroupHeadUI;
      FrmDlg.DWGroups.Visible := True;
    end;
  end;
end;

procedure TAssistantForm.DCheckGroupHeaderDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckGroupHeader, g_Config.Assistant.ShowGroupHead, DCheckGroupHeader.Caption);
end;

procedure TAssistantForm.DCheckMagicLockClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.MagicLock := not g_Config.Assistant.MagicLock;
end;

procedure TAssistantForm.DCheckMagicLockDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckMagicLock, g_Config.Assistant.MagicLock, DCheckMagicLock.Caption);
end;

procedure TAssistantForm.DCheckSdoAutoDrinkDrugWineClick(Sender: TObject; X,
  Y: Integer);
begin
  g_boAutoEatDrugWine := DCheckSdoAutoDrinkDrugWine.Checked;
end;

procedure TAssistantForm.DCheckSdoAutoDrinkWineClick(Sender: TObject; X,
  Y: Integer);
begin
  g_boAutoEatWine := DCheckSdoAutoDrinkWine.Checked;
end;

procedure TAssistantForm.DCheckSdoAutoDufuClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.AutoTurnDuFu := not g_Config.Assistant.AutoTurnDuFu;
end;

procedure TAssistantForm.DCheckSdoAutoDufuDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoAutoDufu, g_Config.Assistant.AutoTurnDuFu, DCheckSdoAutoDufu.Caption);
end;

procedure TAssistantForm.DCheckSdoAutoFireHitClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.AutoFireHit := not g_Config.Assistant.AutoFireHit;
end;

procedure TAssistantForm.DCheckSdoAutoFireHitDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoAutoFireHit, g_Config.Assistant.AutoFireHit, DCheckSdoAutoFireHit.Caption);
end;

procedure TAssistantForm.DCheckSdoAutoHideClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.AutoHide := not g_Config.Assistant.AutoHide;
end;

procedure TAssistantForm.DCheckSdoAutoHideDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoAutoHide, g_Config.Assistant.AutoHide, DCheckSdoAutoHide.Caption);
end;

procedure TAssistantForm.DCheckSdoAutoMagicClick(Sender: TObject; X,
  Y: Integer);
begin
  g_Config.Assistant.AutoMagic := not g_Config.Assistant.AutoMagic
end;

procedure TAssistantForm.DCheckSdoAutoMagicDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoAutoMagic, g_Config.Assistant.AutoMagic, DCheckSdoAutoMagic.Caption);
end;

procedure TAssistantForm.DCheckSdoAutoPickItemsClick(Sender: TObject; X,
  Y: Integer);
begin
  g_Config.Assistant.AutoPuckUpItem := not g_Config.Assistant.AutoPuckUpItem;
end;

procedure TAssistantForm.DCheckSdoAutoPickItemsDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoAutoPickItems, g_Config.Assistant.AutoPuckUpItem, DCheckSdoAutoPickItems.Caption);
end;

procedure TAssistantForm.DCheckSdoAutoSearchItemClick(Sender: TObject; X,
  Y: Integer);
begin
  g_Config.Assistant.AutoSearchItem := not g_Config.Assistant.AutoSearchItem;
end;

procedure TAssistantForm.DCheckSdoAutoSearchItemDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoAutoSearchItem, g_Config.Assistant.AutoSearchItem, DCheckSdoAutoSearchItem.Caption);
end;

procedure TAssistantForm.DCheckSdoAutoShieldClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.AutoShield := not g_Config.Assistant.AutoShield;
end;

procedure TAssistantForm.DCheckSdoAutoShieldDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoAutoShield, g_Config.Assistant.AutoShield, DCheckSdoAutoShield.Caption);
end;

procedure TAssistantForm.DCheckSdoAutoUseHuoLongClick(Sender: TObject; X,
  Y: Integer);
begin
  g_Config.Assistant.AutoUseHuoLong := not g_Config.Assistant.AutoUseHuoLong;
end;

procedure TAssistantForm.DCheckSdoAutoUseHuoLongDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoAutoUseHuoLong, g_Config.Assistant.AutoUseHuoLong, DCheckSdoAutoUseHuoLong.Caption);
end;

procedure TAssistantForm.DChecksdoAutoUseJinyuanClick(Sender: TObject; X,
  Y: Integer);
begin
  g_Config.Assistant.AutoUseJinyuan := not g_Config.Assistant.AutoUseJinyuan;
end;

procedure TAssistantForm.DChecksdoAutoUseJinyuanDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DChecksdoAutoUseJinyuan, g_Config.Assistant.AutoUseJinyuan, DChecksdoAutoUseJinyuan.Caption);
end;

procedure TAssistantForm.DCheckSdoAutoWideHitClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.AutoWideHit := not g_Config.Assistant.AutoWideHit;
end;

procedure TAssistantForm.DCheckSdoAutoWideHitDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoAutoWideHit, g_Config.Assistant.AutoWideHit, DCheckSdoAutoWideHit.Caption);
end;

procedure TAssistantForm.DCheckSdoAvoidShiftClick(Sender: TObject; X,
  Y: Integer);
begin
  g_Config.Assistant.NoShift := not g_Config.Assistant.NoShift;
end;

procedure TAssistantForm.DCheckSdoAvoidShiftDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoAvoidShift, g_Config.Assistant.NoShift, DCheckSdoAvoidShift.Caption);
end;

procedure TAssistantForm.DCheckSdoBloodShowClick(Sender: TObject; X,
  Y: Integer);
begin
  g_Config.Assistant.ShowBlood := not g_Config.Assistant.ShowBlood;
end;

procedure TAssistantForm.DCheckSdoBloodShowDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoBloodShow, g_Config.Assistant.ShowBlood, DCheckSdoBloodShow.Caption);
end;

procedure TAssistantForm.DCheckSdoCommonHpClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.CommonHp := not g_Config.Assistant.CommonHp;
end;

procedure TAssistantForm.DCheckSdoCommonHpDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoCommonHp, g_Config.Assistant.CommonHp, DCheckSdoCommonHp.Caption);
end;

procedure TAssistantForm.DCheckSdoCommonMpClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.CommonMp := not g_Config.Assistant.CommonMp;
end;

procedure TAssistantForm.DCheckSdoCommonMpDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoCommonMp, g_Config.Assistant.CommonMp, DCheckSdoCommonMp.Caption);
end;

procedure TAssistantForm.DCheckSdoDuraWarningClick(Sender: TObject; X,
  Y: Integer);
begin
  g_Config.Assistant.DuraWarning := not g_Config.Assistant.DuraWarning;
end;

procedure TAssistantForm.DCheckSdoDuraWarningDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoDuraWarning, g_Config.Assistant.DuraWarning, DCheckSdoDuraWarning.Caption);
end;

procedure TAssistantForm.DCheckSdoShowMonNameClick(Sender: TObject; X,
  Y: Integer);
begin
  g_Config.Assistant.ShowMonName := not g_Config.Assistant.ShowMonName;
end;

procedure TAssistantForm.DCheckSdoShowMonNameDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoShowMonName, g_Config.Assistant.ShowMonName, DCheckSdoShowMonName.Caption);
end;

procedure TAssistantForm.DCheckSdoGWLongHitClick(Sender: TObject; X,
  Y: Integer);
begin
  g_Config.Assistant.SPLongHit := not g_Config.Assistant.SPLongHit;
end;

procedure TAssistantForm.DCheckSdoGWLongHitDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  DrawCheckControl(dsurface, DCheckSdoGWLongHit, g_Config.Assistant.SPLongHit, DCheckSdoGWLongHit.Caption);
end;

procedure TAssistantForm.DCheckSdoItemsHintClick(Sender: TObject; X,
  Y: Integer);
begin
  g_Config.Assistant.ShowAllItem := not g_Config.Assistant.ShowAllItem;
end;

procedure TAssistantForm.DCheckSdoItemsHintDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoItemsHint, g_Config.Assistant.ShowAllItem, DCheckSdoItemsHint.Caption);
end;

procedure TAssistantForm.DCheckSdoLongHitClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.LongHit := not g_Config.Assistant.LongHit;
end;

procedure TAssistantForm.DCheckSdoLongHitDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoLongHit, g_Config.Assistant.LongHit, DCheckSdoLongHit.Caption);
end;

procedure TAssistantForm.DCheckSdoNameShowClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.ShowName := not g_Config.Assistant.ShowName;
end;

procedure TAssistantForm.DCheckSdoNameShowDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoNameShow, g_Config.Assistant.ShowName, DCheckSdoNameShow.Caption);
end;

procedure TAssistantForm.DCheckSdoNameShowMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if g_MySelf = nil then Exit;

  with TDCheckBox(Sender) do
    if Hint <> '' then
      DScreen.ShowHint(SurfaceX(Left), SurfaceY(Top + Height), Hint);
end;

procedure TAssistantForm.DCheckSdoNPCNameShowClick(Sender: TObject; X,
  Y: Integer);
begin
  g_Config.Assistant.ShowNPCName := not g_Config.Assistant.ShowNPCName;
end;

procedure TAssistantForm.DCheckSdoNPCNameShowDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoNPCNameShow, g_Config.Assistant.ShowNPCName, DCheckSdoNPCNameShow.Caption);
end;

procedure TAssistantForm.DCheckSdoPickFiltrateClick(Sender: TObject; X,
  Y: Integer);
begin
  g_Config.Assistant.FilterPickItem := not g_Config.Assistant.FilterPickItem;
end;

procedure TAssistantForm.DCheckSdoPickFiltrateDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoPickFiltrate, g_Config.Assistant.FilterPickItem, DCheckSdoPickFiltrate.Caption);
end;

procedure TAssistantForm.DCheckSdoRandomHpClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.RandomHp := not g_Config.Assistant.RandomHp;
end;

procedure TAssistantForm.DCheckSdoRandomHpDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoRandomHp, g_Config.Assistant.RandomHp, DCheckSdoRandomHp.Caption);
end;

procedure TAssistantForm.DCheckSdoRankNameShowClick(Sender: TObject; X,
  Y: Integer);
begin
  g_Config.Assistant.ShowRankName := not g_Config.Assistant.ShowRankName;
end;

procedure TAssistantForm.DCheckSdoRankNameShowDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoRankNameShow, g_Config.Assistant.ShowRankName, DCheckSdoRankNameShow.Caption);
end;

procedure TAssistantForm.f(Sender: TObject; X,
  Y: Integer);
begin
//  g_boFilterAutoItemShow := DCheckSdoShowFiltrate.Checked;
end;

procedure TAssistantForm.DCheckSdoSpecialHpClick(Sender: TObject; X,
  Y: Integer);
begin
  g_Config.Assistant.SpecialHp := not g_Config.Assistant.SpecialHp;
end;

procedure TAssistantForm.DCheckSdoSpecialHpDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoSpecialHp, g_Config.Assistant.SpecialHp, DCheckSdoSpecialHp.Caption);
end;

procedure TAssistantForm.DCheckSdoSpecialMpClick(Sender: TObject; X,
  Y: Integer);
begin
  g_Config.Assistant.SpecialMp := not g_Config.Assistant.SpecialMp;
end;

procedure TAssistantForm.DCheckSdoSpecialMpDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoSpecialMp, g_Config.Assistant.SpecialMp, DCheckSdoSpecialMp.Caption);
end;

procedure TAssistantForm.DCheckSdoStartKeyClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.UseHotkey := not g_Config.Assistant.UseHotkey;
end;

procedure TAssistantForm.DCheckSdoStartKeyDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoStartKey, g_Config.Assistant.UseHotkey, DCheckSdoStartKey.Caption);
end;

procedure TAssistantForm.DCheckSdoTitleClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.ShowTitle := not g_Config.Assistant.ShowTitle;
end;

procedure TAssistantForm.DCheckSdoTitleDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoTitle, g_Config.Assistant.ShowTitle, DCheckSdoTitle.Caption);
end;

procedure TAssistantForm.DCheckSdoZhuriClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.AutoZhuriHit := not g_Config.Assistant.AutoZhuriHit;
end;

procedure TAssistantForm.DCheckSdoZhuriDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(DSurface, DCheckSdoZhuri, g_Config.Assistant.AutoZhuriHit, DCheckSdoZhuri.Caption);
end;

procedure TAssistantForm.DEditItemSearchDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  DrawEdit(DEditItemSearch, dsurface);
end;

procedure TAssistantForm.DEdtSdoAutoMagicTimerChange(Sender: TObject);
begin
  if DEdtSdoAutoMagicTimer.Text = '' then
    Exit;
  g_Config.Assistant.AutoMagicTime := StrToIntDef(DEdtSdoAutoMagicTimer.Text, 0);
end;

procedure TAssistantForm.DEdtSdoCommonHpChange(Sender: TObject);
begin
  if DEdtSdoCommonHp.Text = '' then
    Exit;
  g_Config.Assistant.EditCommonHp := StrToIntDef(DEdtSdoCommonHp.Text, 0);
  if g_MySelf <> nil then
  begin
    if g_Config.Assistant.EditCommonHp > g_MySelf.m_Abil.MaxHP then
    begin
      g_Config.Assistant.EditCommonHp := g_MySelf.m_Abil.MaxHP;
      DEdtSdoCommonHp.Text := IntToStr(g_MySelf.m_Abil.MaxHP);
    end;
  end;
end;

procedure TAssistantForm.DEdtSdoCommonHpKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 123 then
  begin
    FrmMain.OpenSdoAssistant();
  end;
end;

procedure TAssistantForm.DEdtSdoCommonHpKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not(Key in ['0' .. '9', #8, #13]) then
    Key := #0;
end;

procedure TAssistantForm.DEdtSdoCommonHpTimerChange(Sender: TObject);
begin
  if DEdtSdoCommonHpTimer.Text = '' then
    Exit;
  g_Config.Assistant.EditCommonHpTimer := DrugIntervalText(DEdtSdoCommonHpTimer.Text);
  //DEdtSdoCommonHpTimer.Text := IntToStr(g_Config.Assistant.EditCommonHpTimer);
end;

procedure TAssistantForm.DEdtSdoCommonMpChange(Sender: TObject);
begin
  if DEdtSdoCommonMp.Text = '' then
    Exit;
  g_Config.Assistant.EditCommonMp := StrToIntDef(DEdtSdoCommonMp.Text, 0);

  if g_MySelf <> nil then
  begin
    if g_Config.Assistant.EditCommonMp > g_MySelf.m_Abil.MaxMP then
    begin
      g_Config.Assistant.EditCommonMp := g_MySelf.m_Abil.MaxMP;
      DEdtSdoCommonMp.Text := IntToStr(g_MySelf.m_Abil.MaxMP);
    end;
  end;
end;

procedure TAssistantForm.DEdtSdoCommonMpDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  DrawEdit(TDEdit(Sender), dsurface);
end;

procedure TAssistantForm.DEdtSdoCommonMpTimerChange(Sender: TObject);
begin
  if DEdtSdoCommonMpTimer.Text = '' then
    Exit;
  g_Config.Assistant.EditCommonMpTimer := DrugIntervalText(DEdtSdoCommonMpTimer.Text);
 // DEdtSdoCommonMpTimer.Text := IntToStr(g_Config.Assistant.EditCommonMpTimer);
end;

procedure TAssistantForm.DEdtSdoDrunkDrugWineDegreeChange(Sender: TObject);
begin
  if DEdtSdoDrunkDrugWineDegree.Text = '' then
    Exit;
  g_btEditDrugWine := strtoint(DEdtSdoDrunkDrugWineDegree.Text);
end;

procedure TAssistantForm.DEdtSdoDrunkWineDegreeChange(Sender: TObject);
begin
    if DEdtSdoDrunkWineDegree.Text = '' then
      Exit;
    g_btEditWine := strtoint(DEdtSdoDrunkWineDegree.Text);
end;

procedure TAssistantForm.DEdtSdoRandomHpChange(Sender: TObject);
begin
  if DEdtSdoRandomHp.Text = '' then
    Exit;
  g_Config.Assistant.EditRandomHp := StrToIntDef(DEdtSdoRandomHp.Text, 0);

  if g_MySelf <> nil then
  begin
    if g_Config.Assistant.EditRandomHp > g_MySelf.m_Abil.MaxHP then
    begin
      g_Config.Assistant.EditRandomHp := g_MySelf.m_Abil.MaxHP;
      DEdtSdoRandomHp.Text := IntToStr(g_MySelf.m_Abil.MaxHP);
    end;
  end;
end;

procedure TAssistantForm.DEdtSdoRandomHpTimerChange(Sender: TObject);
begin
  if DEdtSdoRandomHpTimer.Text = '' then
    Exit;
  g_Config.Assistant.EditRandomHpTimer := ItemIntervalText(DEdtSdoRandomHpTimer.Text);
  //DEdtSdoRandomHpTimer.Text := IntToStr(g_Config.Assistant.EditRandomHpTimer);
end;

procedure TAssistantForm.DEdtSdoSpecialHpChange(Sender: TObject);
begin
  if DEdtSdoSpecialHp.Text = '' then
    Exit;
  g_Config.Assistant.EditSpecialHp := StrToIntDef(DEdtSdoSpecialHp.Text, 0);

  if g_MySelf <> nil then
  begin
    if g_Config.Assistant.EditSpecialHp > g_MySelf.m_Abil.MaxHP then
    begin
      g_Config.Assistant.EditSpecialHp := g_MySelf.m_Abil.MaxHP;
      DEdtSdoSpecialHp.Text := IntToStr(g_MySelf.m_Abil.MaxHP);
    end;
  end;
end;

procedure TAssistantForm.DEdtSdoSpecialHpNameClick(Sender: TObject; X,
  Y: Integer);
var
  I: Integer;
begin
  if DXPopupMenu.PopVisible then
    DXPopupMenu.HidePopup
  else
  begin
    with DEdtSdoSpecialHpName do
    begin
      DXPopupMenu.BeginUpdate;
      DXPopupMenu.Clear;
      DXPopupMenu.AddMenuItem(0, '<无>');
      for I := 0 to g_ItemList.Count - 1 do
        if (g_ItemList.Items[I]<>nil) and (g_ItemList.Items[I].StdMode = 0) and (g_ItemList.Items[I].Shape = 1) and (g_ItemList.Items[I].ACMin > 0) then
          DXPopupMenu.AddMenuItem(I, g_ItemList.Items[I].DisplayName);
      DXPopupMenu.EndUpdate;
      DXPopupMenu.Popup(DWProtect, Left, Top + Height, Width,
        procedure(ATag: Integer; const ACaption: String)
        begin
          g_Config.Assistant.DefSpecialHpName := '';
          if Tag <> 0 then
            g_Config.Assistant.DefSpecialHpName := ACaption;
        end
      );
    end;
  end;
end;

procedure TAssistantForm.DEdtSdoSpecialHpNameDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  FontColor: TColor;
begin
  DrawControl(dsurface, DEdtSdoSpecialHpName, FontColor);
  with Sender as TDButton do
  begin
    DSurface.BoldText(g_Config.Assistant.DefSpecialHpName, FontColor, clBlack, SurfaceX(Left) + 2, SurfaceY(Top) + 4);
  end;
end;

procedure TAssistantForm.DEdtSdoSpecialHpTimerChange(Sender: TObject);
begin
  if DEdtSdoSpecialHpTimer.Text = '' then
    Exit;
  g_Config.Assistant.EditSpecialHpTimer := DrugIntervalText(DEdtSdoSpecialHpTimer.Text);
  //DEdtSdoSpecialHpTimer.Text := IntToStr(g_Config.Assistant.EditSpecialHpTimer);
end;

procedure TAssistantForm.DEdtSdoSpecialMpChange(Sender: TObject);
begin
  if DEdtSdoSpecialMp.Text = '' then
    Exit;
  g_Config.Assistant.EditSpecialMp := StrToIntDef(DEdtSdoSpecialMp.Text, 0);

  if g_MySelf <> nil then
  begin
    if g_Config.Assistant.EditSpecialMp > g_MySelf.m_Abil.MaxMP then
    begin
      g_Config.Assistant.EditSpecialMp := g_MySelf.m_Abil.MaxMP;
      DEdtSdoSpecialMp.Text := IntToStr(g_MySelf.m_Abil.MaxMP);
    end;
  end;
end;

procedure TAssistantForm.DEdtSdoSpecialMpDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawEdit(TDEdit(Sender), dsurface);
end;

procedure TAssistantForm.DEdtSdoSpecialMpNameClick(Sender: TObject; X,
  Y: Integer);
var
  I: Integer;
begin
  if DXPopupMenu.PopVisible then
    DXPopupMenu.HidePopup
  else
  begin
    with DEdtSdoSpecialMPName do
    begin
      DXPopupMenu.BeginUpdate;
      DXPopupMenu.Clear;
      DXPopupMenu.AddMenuItem(0, '<无>');
      for I := 0 to g_ItemList.Count - 1 do
        if (g_ItemList.Items[I]<>nil) and (g_ItemList.Items[I].StdMode = 0) and (g_ItemList.Items[I].Shape = 1) and (g_ItemList.Items[I].MACMin > 0) then
          DXPopupMenu.AddMenuItem(I, g_ItemList.Items[I].DisplayName);
      DXPopupMenu.EndUpdate;
      DXPopupMenu.Popup(DWProtect, Left, Top + Height, Width,
        procedure(ATag: Integer; const ACaption: String)
        begin
          g_Config.Assistant.DefSpecialMPName := '';
          if Tag <> 0 then
            g_Config.Assistant.DefSpecialMPName := ACaption;
        end
      );
    end;
  end;
end;

procedure TAssistantForm.DEdtSdoSpecialMpNameDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
var
  FontColor: TColor;
begin
  DrawControl(dsurface, DEdtSdoSpecialMpName, FontColor);
  with Sender as TDButton do
  begin
    DSurface.BoldText(g_Config.Assistant.DefSpecialMpName, FontColor, clBlack, SurfaceX(Left) + 2, SurfaceY(Top) + 4);
  end;
end;

procedure TAssistantForm.DEdtSdoSpecialMpTimerChange(Sender: TObject);
begin
  if DEdtSdoSpecialMpTimer.Text = '' then
    Exit;
  g_Config.Assistant.EditSpecialMpTimer := DrugIntervalText(DEdtSdoSpecialMpTimer.Text);
  //DEdtSdoSpecialMpTimer.Text := IntToStr(g_Config.Assistant.EditSpecialMpTimer);
end;

procedure TAssistantForm.DNewSdoAssistantCloseClick(Sender: TObject; X,
  Y: Integer);
begin
  FrmMain.OpenSdoAssistant;
end;

procedure TAssistantForm.DNewSdoAssistantCloseDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  d: TAsphyreLockableTexture;
begin
  with Sender as TDButton do
  begin
    if Propertites.Images <> nil then
    begin
      if not TDButton(Sender).Downed then
      begin
        d := Propertites.Images.Images[Propertites.ImageIndex];
        if d <> nil then
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      end
      else
      begin
        d := Propertites.Images.Images[Propertites.ImageIndex + 1];
        if d <> nil then
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      end;
    end;
  end;
end;

procedure TAssistantForm.DNewSdoBasicClick(Sender: TObject; X, Y: Integer);
begin
  g_btSdoAssistantPage := TDButton(Sender).Tag;
  NewSdoAssistantPageChanged();
  ReleaseDFocus;
end;

procedure TAssistantForm.DNewSdoBasicDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  d: TAsphyreLockableTexture;
begin
  with Sender as TDButton do
  begin
    if TDButton(Sender).Tag <> g_btSdoAssistantPage then
    begin
      if Propertites.Images <> nil then
      begin
        d := Propertites.Images.Images[Propertites.ImageIndex];
        if d <> nil then
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
      end;
      DSurface.BoldText(TDButton(Sender).Hint, clWhite, clBlack, SurfaceX(Left) + 24 - FrmMain.Canvas.TextWidth(TDButton(Sender).Hint) div 2, SurfaceY(Top) + 4);
    end
    else
    begin
      if Propertites.Images <> nil then
      begin
        d := Propertites.Images.Images[Propertites.ImageIndex + 1];
        if d <> nil then
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top) - 2, d.ClientRect, d, TRUE);
      end;
      DSurface.BoldText(TDButton(Sender).Hint, clWhite, clBlack, SurfaceX(Left) + 24 - FrmMain.Canvas.TextWidth(TDButton(Sender).Hint) div 2, SurfaceY(Top) + 2);
    end;
  end;
end;

procedure TAssistantForm.DSdoHelpNextClick(Sender: TObject; X, Y: Integer);
begin
  if g_btSdoAssistantHelpPage >= 4 then
    Exit
  else
    Inc(g_btSdoAssistantHelpPage);
end;

procedure TAssistantForm.DSdoHelpUpClick(Sender: TObject; X, Y: Integer);
begin
  if g_btSdoAssistantHelpPage <= 0 then
    Exit
  else
    Dec(g_btSdoAssistantHelpPage);
end;

procedure TAssistantForm.DSdoItemDownMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FItemIndex + 1 < FliterItems.Count then
    Inc(FItemIndex, 1);
  ReCalcItemScrollPos;
  ItemScrollTimer.Enabled := True;
end;

procedure TAssistantForm.DSdoItemDownMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TAssistantForm.DSdoItemDownMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ItemScrollTimer.Enabled := False;
end;

procedure TAssistantForm.DSdoItemUpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Dec(FItemIndex);
  FItemIndex := Max(0, FItemIndex);
  ReCalcItemScrollPos;
  ItemScrollTimer.Enabled := True;
end;

procedure TAssistantForm.DSdoItemUpMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TAssistantForm.DSdoItemUpMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ItemScrollTimer.Enabled := False;
end;

procedure TAssistantForm.DSmartWalkClick(Sender: TObject; X, Y: Integer);
begin
  g_Config.Assistant.SmartWalk := not g_Config.Assistant.SmartWalk;
end;

procedure TAssistantForm.DSmartWalkDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  DrawCheckControl(dsurface, DSmartWalk, g_Config.Assistant.SmartWalk, DSmartWalk.Caption);
end;

procedure TAssistantForm.DWAssistantMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TAssistantForm.DWAssistantVisibleChange(Sender: TObject);
begin
  if g_MySelf <> nil then
  begin
    if not DWAssistant.Visible then
    begin
      Save(g_MySelf.m_sUserName);
      ReleaseDFocus;
    end
    else
      DCheckSdoStartKey.Checked := g_Config.Assistant.UseHotkey;
  end;

end;

procedure TAssistantForm.DWBasicDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  with DWBasic do
  begin
    DSurface.BoldText('基本功能设置', clYellow, clBlack, SurfaceX(Left) + 16, SurfaceY(Top) + 14);
    DSurface.BoldText('物品设置', clYellow, clBlack, SurfaceX(Left) + 246, SurfaceY(Top) + 14);
    DSurface.BoldText('自动探索', clYellow, clBlack, SurfaceX(Left) + 246, SurfaceY(Top) + 120);
  end;
end;

procedure TAssistantForm.DWHelpDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  d: TAsphyreLockableTexture;
  I, Int: Integer;
begin
  with DWHelp do
  begin
    d := g_WMain2Images.Images[291]; // 上面图
    if d <> nil then
      dsurface.Draw(d.ClientRect, Rect(SurfaceX(Left + 368), SurfaceY(Top + 2), SurfaceX(Left + 368) + 16, SurfaceY(Top + 24) + 183), d, clWhite4);
    Int := 16;
    case g_btSdoAssistantHelpPage of
      0:
        begin
          DSurface.BoldText('辅助功能说明', clWhite, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8);
          DSurface.BoldText('  物品显示   显示屏幕范围内地上的所有物品', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int);
          DSurface.BoldText('  自动拣物   只要站在需要拾取的物品上即可自动拣去该物品', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 2);
          DSurface.BoldText('  显示过滤   只显示屏幕范围内地上的贵重物品', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 3);
          DSurface.BoldText('  拣取过滤   同“自动拣物”功能但只拣去贵重物品', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 4);
          DSurface.BoldText('  免Shift    勾选此功能后可以自动追杀目标', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 5);
          DSurface.BoldText('  人名显示   显示屏幕范围内所有角色的名字', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 6);
          DSurface.BoldText('  持久警告   对即将损坏的物品，在聊天框中进行提前报警', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 7);
          DSurface.BoldText('鼠标控制说明', clWhite, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 9);
          DSurface.BoldText('  鼠标左键    制基本的行动：行走、攻击、拾取物品和其他东西', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 10);
          DSurface.BoldText('  鼠标右键    远处的点击能够在地图上跑动', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 11);
        end;
      1:
        begin
          DSurface.BoldText('  Shift+左键  强行攻击指定目标', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8);
          DSurface.BoldText('  Ctrl+右键   你能够看到其他玩家的信息,它的作用和F10一样 ', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int);
          DSurface.BoldText('  Alt+左键    收集物品 ', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 2);
          DSurface.BoldText('  双击右键    双击掉落在地上的物品，你就可以捡起它', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 3);
          DSurface.BoldText('  　　　　　　双击在包裹里的物品，你将可以直接使用该物品', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 4);
          DSurface.BoldText('快捷键说明', clWhite, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 6);
          DSurface.BoldText('  F1到F8   可以自设置的技能快捷键', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 7);
          DSurface.BoldText('  F9       打开/关闭包裹窗口', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 8);
          DSurface.BoldText('  F10      打开/关闭角色窗口', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 9);
          DSurface.BoldText('  F11      打开/关闭角色技能窗口', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 10);
          DSurface.BoldText('  F12      打开/关闭辅助功能窗口', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 11);
        end;
      2:
        begin
          DSurface.BoldText('  Alt+X    返回到角色选择界面', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8);
          DSurface.BoldText('  Alt+Q    直接退出游戏', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int);
          DSurface.BoldText('  Pause    在游戏中截图保存在游戏\Images目录下面 ', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 2);
          DSurface.BoldText('  Ctrl+B   打开/关闭商铺窗口', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 3);
          DSurface.BoldText('  Ctrl+H   选择自己喜欢的攻击模式：', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 4);
          DSurface.BoldText('  　和平攻击模式 - 对任何玩家攻击都无效', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 5);
          DSurface.BoldText('  　行会攻击模式 - 对自己行会内的其他玩家攻击无效', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 6);
          DSurface.BoldText('  　编组攻击模式 - 处于同一小组的玩家攻击无效', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 7);
          DSurface.BoldText('  　全体攻击模式 - 对所有的玩家都具有攻击效果', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 8);
          DSurface.BoldText('  　善恶攻击模式 - PK红名专用攻击模式', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 9);
          DSurface.BoldText('特殊命令说明', clWhite, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 11);
        end;
      3:
        begin
          DSurface.BoldText('  /玩家名字     私聊', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8);
          DSurface.BoldText('  !交流文字     喊话', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int);
          DSurface.BoldText('  !!文字        组队聊天', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 2);
          DSurface.BoldText('  !~文字        行会聊天', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 3);
          DSurface.BoldText('  上下方向键    查看过去的聊天信息', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 4);
          DSurface.BoldText('  @拒绝私聊     拒绝所有的私人聊天的命令 ', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 6);
          DSurface.BoldText('  @拒绝+人名    对特定的某一个人聊天文字进行屏蔽 ', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 7);
          DSurface.BoldText('  @拒绝行会聊天 屏蔽行会聊天所有消息的命令 ', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 8);
          DSurface.BoldText('  @退出门派     脱离行会 ', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 9);
          DSurface.BoldText('黑名单说明', clWhite, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 11);
        end;
      4:
        begin
          DSurface.BoldText('  鼠标点中指定角色同时按ALT+S即可将该玩家加入黑名单，再次使', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8);
          DSurface.BoldText('  用鼠标点中指定角色同时ALT+S即可将该玩家移出黑名单，玩家加', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int);
          DSurface.BoldText('  入黑名单后，您将屏蔽该玩家的喊话', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 2);
          DSurface.BoldText('  使用指令 @加入黑名单+空格+玩家名，也可将玩家加入黑名单', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 4);
          DSurface.BoldText('  再次输入 @清除黑名单+空格+玩家名，可将该玩家移出黑名单', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 5);
          DSurface.BoldText('快速编组说明', clWhite, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 7);
          DSurface.BoldText('  鼠标点中要组队的角色同时按ALT+W即可自动和该角色组队，再次', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 8);
          DSurface.BoldText('  按ALT+E即可自动把该角色从队伍中删除', clSilver, clBlack, SurfaceX(Left) + 11, SurfaceY(Top) + 8 + Int * 9);
        end;
    end;
  end;
end;

procedure TAssistantForm.DWItemsClick(Sender: TObject; X, Y: Integer);

  function GetIndexByYPos(Value: Integer): Integer;
  var
    I: Integer;
  begin
    Result := -1;
    for I := 0 to 8 do
    begin
      if (Value >= (62 + I * 18)) and ((Value <= (62 + I * 18 + 16))) then
      begin
        Result := I;
        Break;
      end;
    end;
  end;

var
  Idx, ANewBind: Integer;
  AItem: pTStdItem;
  AShowItem: TShowItem;
  ACliItem: TClientItem;
begin
  DScreen.ClearHint;
  ReleaseDFocus;
  with DWItems do
  begin
    Idx   :=  GetIndexByYPos(Y);
    if (Idx in [0..8]) then
    begin
      g_SoundManager.DXPlaySound(s_norm_button_click);
      FActiveItemIndex := FItemIndex + Idx;
//      if FActiveItemIndex <> 0 then
//      begin
//        FillChar(ACliItem, ClientItemSize, #0);
//        ACliItem.Index := FActiveItemIndex;
//        ACliItem.MakeIndex := -1;
//        ACliItem.Name  := FliterItems[FActiveItemIndex].Name;
//        ACliItem.Dura  := FliterItems[FActiveItemIndex].DuraMax;
//        ACliItem.DuraMax  := FliterItems[FActiveItemIndex].DuraMax;
//        ACliItem.AddHold[0] := -1;
//        ACliItem.AddHold[1] := -1;
//        ACliItem.AddHold[2] := -1;
//        DScreen.ShowItemHint(SurfaceX(Left) + 16, SurfaceY(Top) + 50 + IDX * 18, ACliItem, False, False);
//      end;
    end;
    if (Idx in [0..8]) and (((X>=237) and (X<=252)) or ((X>=291) and (X<=306)) or ((X>=343) and (X<=359))) then
    begin
      if FItemIndex + Idx<FliterItems.Count then
      begin
        AItem :=  FliterItems[FItemIndex + Idx];
        case X of
          237..252: AItem.State.ShowNameClient := not AItem.State.ShowNameClient;
          291..306: AItem.State.AutoPickUp := not AItem.State.AutoPickUp;
          343..359: AItem.State.SpecialShow := not AItem.State.SpecialShow;
        end;

        if g_FilterItemNameList.TryGetValue(AItem.Name, AShowItem) then
        begin
          AShowItem.boShowName    :=  AItem.State.ShowNameClient;
          AShowItem.boAutoPickup  :=  AItem.State.AutoPickUp;
          AShowItem.boSpec        :=  AItem.State.SpecialShow;
          UpdateShowItem(AItem.Name, AShowItem);
        end;
      end;
    end;
  end;
end;

procedure TAssistantForm.DWItemsDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  d, dc, duc: TAsphyreLockableTexture;
  I, Int: Integer;
begin
  with DWItems do
  begin
    d   :=  g_WMain2Images.Images[291]; // 上面图
    dc  :=  g_77Images.Images[239];
    duc :=  g_77Images.Images[238];
    if d <> nil then
      dsurface.Draw(d.ClientRect, Rect(SurfaceX(Left + 368), SurfaceY(Top + 2), SurfaceX(Left + 368) + 16, SurfaceY(Top) + 207), d, clWhite4);
    DSurface.BoldText('物品名称', clYellow, clBlack, SurfaceX(Left) + 16, SurfaceY(Top) + 6);
    DSurface.BoldText('显名', clYellow, clBlack, SurfaceX(Left) + 220, SurfaceY(Top) + 6);
    DSurface.BoldText('拾取', clYellow, clBlack, SurfaceX(Left) + 274, SurfaceY(Top) + 6);
    DSurface.BoldText('特显', clYellow, clBlack, SurfaceX(Left) + 326, SurfaceY(Top) + 6);
    for I := 0 to 8 do
    begin
      if FliterItems.Count > I+FItemIndex then
      begin
        if FActiveItemIndex = I + FItemIndex then
          uTextures.Textures.ObjectName(DSurface, FliterItems[I+FItemIndex]^.DisplayName).Draw(DSurface, SurfaceX(Left) + 8, SurfaceY(Top) + 28 + I*18, clRed)
        else
          uTextures.Textures.ObjectName(DSurface, FliterItems[I+FItemIndex]^.DisplayName).Draw(DSurface, SurfaceX(Left) + 8, SurfaceY(Top) + 28 + I*18, clSilver);
      end;
    end;
    for I := 0 to 8 do
    begin
      if FliterItems.Count > I+FItemIndex then
      begin
        if FliterItems[I+FItemIndex].State.ShowNameClient then
      //  if SetContain(FliterItems[I+FItemIndex].Bind, 6) then
          dsurface.Draw(SurfaceX(Left)+222, SurfaceY(Top) + 26 + I*18, dc.ClientRect, dc, TRUE)
        else
          dsurface.Draw(SurfaceX(Left)+222, SurfaceY(Top) + 26 + I*18, duc.ClientRect, duc, TRUE);

        if FliterItems[I+FItemIndex].State.AutoPickUp then
 //       if SetContain(FliterItems[I+FItemIndex].Bind, 8) then
          dsurface.Draw(SurfaceX(Left)+276, SurfaceY(Top) + 26 + I*18, dc.ClientRect, dc, TRUE)
        else
          dsurface.Draw(SurfaceX(Left)+276, SurfaceY(Top) + 26 + I*18, duc.ClientRect, duc, TRUE);

        if FliterItems[I+FItemIndex].State.SpecialShow then
          dsurface.Draw(SurfaceX(Left)+328, SurfaceY(Top) + 26 + I*18, dc.ClientRect, dc, TRUE)
        else
          dsurface.Draw(SurfaceX(Left)+328, SurfaceY(Top) + 26 + I*18, duc.ClientRect, duc, TRUE);
      end;
    end;
  end;
end;

procedure TAssistantForm.DWItemsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  IDX: Integer;
begin
  with DWItems do
  begin
    if FActiveItemIndex <> -1 then
    begin
      IDX := (FActiveItemIndex+1) mod 9;
      if IDX = 0 then
        IDX := 9;
      if (Y < 62 + (IDX-1) * 18) or (Y > 62 + IDX * 18) then
        DScreen.ClearHint;
    end;
  end;
end;

procedure TAssistantForm.DWItemsMouseWheelDownEvent(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if FItemIndex + 1 < FliterItems.Count then
    Inc(FItemIndex, 1);
  ReCalcItemScrollPos;
end;

procedure TAssistantForm.DWItemsMouseWheelUpEvent(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  Dec(FItemIndex);
  FItemIndex := Max(0, FItemIndex);
  ReCalcItemScrollPos;
end;

procedure TAssistantForm.DWKeyClick(Sender: TObject; X, Y: Integer);
begin
  ReleaseDFocus;
end;

procedure TAssistantForm.DWKeyDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  with DWKey do
  begin
    DSurface.BoldText('功能描述', clYellow, clBlack, SurfaceX(Left) + 14, SurfaceY(Top) + 30);
    DSurface.BoldText('默认快捷键', clYellow, clBlack, SurfaceX(Left) + 136, SurfaceY(Top) + 30);
    DSurface.BoldText('自定义快捷键', clYellow, clBlack, SurfaceX(Left) + 266, SurfaceY(Top) + 30);

    DSurface.BoldText('使用连击技能', clSilver, clBlack, SurfaceX(Left) + 14, SurfaceY(Top) + 49);
    DSurface.BoldText('切换攻击模式', clSilver, clBlack, SurfaceX(Left) + 14, SurfaceY(Top) + 69);
    DSurface.BoldText('切换小地图', clSilver, clBlack, SurfaceX(Left) + 14, SurfaceY(Top) + 89);

    dsurface.Line(SurfaceX(Left) + 12, SurfaceY(Top) + 46, SurfaceX(Left) + 376, SurfaceY(Top) + 46, cColor1($0053424A));
    //画格
    dsurface.FillRect(Rect(SurfaceX(Left) + 101, SurfaceY(Top) + 49, SurfaceX(Left) + 231, SurfaceY(Top) + 47 + 21), clGray, clBlack);
    dsurface.FillRect(Rect(SurfaceX(Left) + 101, SurfaceY(Top) + 69, SurfaceX(Left) + 231, SurfaceY(Top) + 69 + 19), clGray, clBlack);
    dsurface.FillRect(Rect(SurfaceX(Left) + 101, SurfaceY(Top) + 89, SurfaceX(Left) + 231, SurfaceY(Top) + 91 + 17), clGray, clBlack);
    DSurface.BoldText('Ctrl+D', clSilver, clBlack, SurfaceX(Left) + 146, SurfaceY(Top) + 31 + 21);
    DSurface.BoldText('Ctrl+H', clSilver, clBlack, SurfaceX(Left) + 146, SurfaceY(Top) + 73);
    DSurface.BoldText('Tab', clSilver, clBlack, SurfaceX(Left) + 146, SurfaceY(Top) + 94);
  end;
end;

procedure TAssistantForm.DWProtectClick(Sender: TObject; X, Y: Integer);
begin
  ReleaseDFocus;
end;

procedure TAssistantForm.DWProtectDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  with DWProtect do
  begin
    DSurface.BoldText('普通药品', clYellow, clBlack, SurfaceX(Left) + 16, SurfaceY(Top) + 14);
//    DSurface.BoldText(dsurface, SurfaceX(Left) + 186, SurfaceY(Top) + 14, clYellow, clBlack, '自动饮酒');
    DSurface.BoldText('特殊药品', clYellow, clBlack, SurfaceX(Left) + 16, SurfaceY(Top) + 86);
    DSurface.BoldText('随机保护', clYellow, clBlack, SurfaceX(Left) + 16, SurfaceY(Top) + 164);

    DSurface.BoldText('毫秒 优先使用', clSilver, clBlack, SurfaceX(Left) + 180, SurfaceY(Top) + 36);
    DSurface.BoldText('毫秒 优先使用', clSilver, clBlack, SurfaceX(Left) + 180, SurfaceY(Top) + 60);
    DSurface.BoldText('毫秒 优先使用', clSilver, clBlack, SurfaceX(Left) + 180, SurfaceY(Top) + 108);
    DSurface.BoldText('毫秒 优先使用', clSilver, clBlack, SurfaceX(Left) + 180, SurfaceY(Top) + 132);
    DSurface.BoldText('毫秒 卷轴类型', clSilver, clBlack, SurfaceX(Left) + 180, SurfaceY(Top) + 184);

//    DSurface.BoldText(dsurface, SurfaceX(Left) + 196, SurfaceY(Top) + 40, clSilver, clBlack, '普通酒');
//    DSurface.BoldText(dsurface, SurfaceX(Left) + 196, SurfaceY(Top) + 64, clSilver, clBlack, '药酒');
//
//    DSurface.BoldText(dsurface, SurfaceX(Left) + 326, SurfaceY(Top) + 40, clSilver, clBlack, '% 醉酒度');
//    DSurface.BoldText(dsurface, SurfaceX(Left) + 326, SurfaceY(Top) + 64, clSilver, clBlack, '分钟');
  end;
end;

procedure TAssistantForm.DWSkillDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  with DWSkill do
  begin
    DSurface.BoldText('战士技能', clYellow, clBlack, SurfaceX(Left) + 16, SurfaceY(Top) + 14);
    DSurface.BoldText('道士技能', clYellow, clBlack, SurfaceX(Left) + 134, SurfaceY(Top) + 14); //
    DSurface.BoldText('法师技能', clYellow, clBlack, SurfaceX(Left) + 16, SurfaceY(Top) + 136);
    DSurface.BoldText('辅助功能', clYellow, clBlack, SurfaceX(Left) + 134, SurfaceY(Top) + 74);
    DSurface.BoldText('自动练功', clYellow, clBlack, SurfaceX(Left) + 252, SurfaceY(Top) + 14);
    DSurface.BoldText('打开自动练功后,使用', clRed, clBlack, SurfaceX(Left) + 250, SurfaceY(Top) + 60);
    DSurface.BoldText('一次要修炼的技能,该', clRed, clBlack, SurfaceX(Left) + 250, SurfaceY(Top) + 74);
    DSurface.BoldText('技能会按照您设定的', clRed, clBlack, SurfaceX(Left) + 250, SurfaceY(Top) + 88);
    DSurface.BoldText('间隔时间重复使用.', clRed, clBlack, SurfaceX(Left) + 250, SurfaceY(Top) + 102);

    DSurface.BoldText('秒', clSilver, clBlack, SurfaceX(Left) + 362, SurfaceY(Top) + 41);
    // =================================================
    dsurface.Line(SurfaceX(Left) + 246, SurfaceY(Top) + 33, SurfaceX(Left) + 376, SurfaceY(Top) + 33, $00638494);
    dsurface.Line(SurfaceX(Left) + 246, SurfaceY(Top) + 33, SurfaceX(Left) + 246, SurfaceY(Top) + 118, $00638494);
    dsurface.Line(SurfaceX(Left) + 376, SurfaceY(Top) + 33, SurfaceX(Left) + 376, SurfaceY(Top) + 118, $00638494);
    dsurface.Line(SurfaceX(Left) + 246, SurfaceY(Top) + 118, SurfaceX(Left) + 376, SurfaceY(Top) + 118, $00638494);
  end;
end;

procedure TAssistantForm.EditStdItemModeClick(Sender: TObject; X, Y: Integer);
var
  I: Integer;
begin
  if DXPopupMenu.PopVisible then
    DXPopupMenu.HidePopup
  else
  begin
    with EditStdItemMode do
    begin
      DXPopupMenu.BeginUpdate;
      DXPopupMenu.Clear;
      for I := Low(STR_STDMODEFILTER) to High(STR_STDMODEFILTER) do
        DXPopupMenu.AddMenuItem(I, STR_STDMODEFILTER[I]);
      DXPopupMenu.EndUpdate;
      DXPopupMenu.Popup(DWItems, Left, Top + Height, Width,
        procedure(ATag: Integer; const ACaption: String)
        begin
          FActiveItemIndex := -1;
          FItemIndex := 0;
          FilterItemMode := ATag;
          Filter(FilterItemMode);
          ReCalcItemScrollPos;
        end
      );
    end;
  end;
end;

procedure TAssistantForm.EditStdItemModeDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  FontColor: TColor;
begin
  DrawControl(dsurface, EditStdItemMode, FontColor);
  with Sender as TDButton do
  begin
    if FilterItemMode = 0 then
      DSurface.BoldText('<选择物品类型>', clGray, clBlack, SurfaceX(Left) + 2, SurfaceY(Top) + 4)
    else
      DSurface.BoldText(STR_STDMODEFILTER[FilterItemMode], clWhite, clBlack, SurfaceX(Left) + 2, SurfaceY(Top) + 4);
  end;
end;

procedure TAssistantForm.Filter(ATag: Integer);

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
  begin
    for I := 0 to g_ItemList.Count - 1 do
      if TestStdModeIn(g_ItemList[I].StdMode, StdModes) then
        FliterItems.Add(g_ItemList[I]);
  end;

  procedure DoFilterNot(StdModes: array of Byte);
  var
    I: Integer;
  begin
    for I := 0 to g_ItemList.Count - 1 do
      if not TestStdModeIn(g_ItemList[I].StdMode, StdModes) then
        FliterItems.Add(g_ItemList[I]);
  end;

begin
  FliterItems.Clear;
  case ATag of
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

procedure TAssistantForm.FormCreate(Sender: TObject);
begin
  FActiveItemIndex := -1;
  FilterItemMode := 0;
  FliterItems := TList<pTStdItem>.Create;
end;

procedure TAssistantForm.FormDestroy(Sender: TObject);
begin
  FreeAndNilEx(FliterItems);
end;

procedure TAssistantForm.Initialize;
begin
  DWAssistant.DParent :=  g_DXUIWindow;
  DWAssistant.SetImgIndex(g_77Images, 240);
  DNewSdoAssistantClose.SetImgIndex(g_WMain2Images, 279);
  DNewSdoBasic.SetImgIndex(g_77Images, 241);
  DNewSdoProtect.SetImgIndex(g_77Images, 241);
  DNewSdoSkill.SetImgIndex(g_77Images, 241);
  DNewSdoKey.SetImgIndex(g_77Images, 241);
  DGoodFilter.SetImgIndex(g_77Images, 241);
  DNedSdoHelp.SetImgIndex(g_77Images, 241);
  DSdoHelpUp.SetImgIndex(g_WMain2Images, 292);
  DSdoHelpNext.SetImgIndex(g_WMain2Images, 294);
  DSdoItemUp.SetImgIndex(g_WMain2Images, 292);
  DSdoItemDown.SetImgIndex(g_WMain2Images, 294);
  DBItemScroll.SetImgIndex(g_WMain2Images, 581);

  // 盛大新内挂 20080624
  DWAssistant.Left := (ScreenWidth-DWAssistant.Width) div 2;;
  DWAssistant.Top := (ScreenHeight - DWAssistant.Height - g_BottomHeight) div 2;

  DNewSdoAssistantClose.Left := 394;
  DNewSdoAssistantClose.Top := 1;
  DNewSdoBasic.Left := 10;
  DNewSdoBasic.Top := 14;
  DNewSdoProtect.Left := 58; // DNewSdoBasic+48
  DNewSdoProtect.Top := 14;
  DNewSdoSkill.Left := 106;
  DNewSdoSkill.Top := 14;
  DNewSdoKey.Left := 154;
  DNewSdoKey.Top := 14;
  DGoodFilter.Left  :=  202;
  DGoodFilter.Top :=  14;
  DNedSdoHelp.Left := 250;
  DNedSdoHelp.Top := 14;
  // 基本页里
  DWBasic.Width :=  384;
  DWBasic.Height  :=  207;
  DWBasic.Left  :=  14;
  DWBasic.Top :=  36;

  DCheckSdoNameShow.Left := 26;
  DCheckSdoNameShow.Top := 36;
  DCheckSdoNameShow.WIDTH := 71;
  DCheckSdoNameShow.Height := 17;
  DCheckSdoRankNameShow.Left  :=  26;
  DCheckSdoRankNameShow.Top   :=  56;
  DCheckSdoRankNameShow.Width :=  71;
  DCheckSdoRankNameShow.Height:=  17;
  DCheckSdoNPCNameShow.Left := 26;
  DCheckSdoNPCNameShow.Top := 76;
  DCheckSdoNPCNameShow.WIDTH := 71;
  DCheckSdoNPCNameShow.Height := 17;
  DCheckSdoShowMonName.Top := 96;
  DCheckSdoShowMonName.Left := 26;
  DCheckSdoShowMonName.WIDTH := 78;
  DCheckSdoShowMonName.Height := 17;
  DCheckSdoDuraWarning.Top := 116;
  DCheckSdoDuraWarning.Left := 26;
  DCheckSdoDuraWarning.WIDTH := 78;
  DCheckSdoDuraWarning.Height := 17;
  DCheckSdoAvoidShift.Top := 136;
  DCheckSdoAvoidShift.Left := 26;
  DCheckSdoAvoidShift.WIDTH := 78;
  DCheckSdoAvoidShift.Height := 17;
  DCheckSdoBloodShow.Top := 156;
  DCheckSdoBloodShow.Left := 26;
  DCheckSdoBloodShow.WIDTH := 78;
  DCheckSdoBloodShow.Height := 17;
  DCheckSdoTitle.Top  :=  176;
  DCheckSdoTitle.Left :=  26;
  DCheckSdoTitle.Height :=  17;
  DCheckSdoTitle.Width  :=  78;

  DCheckCleanCorpse.Left := 128;
  DCheckCleanCorpse.Top := 36;
  DCheckCleanCorpse.Width := 78;
  DCheckGroupHeader.Width := 78;
  DCheckGroupHeader.Height := 17;
  DCheckGroupHeader.Left := 128;
  DCheckGroupHeader.Top :=  56;
  DCheckAllowDeal.Left := 128;
  DCheckAllowDeal.Top := 76;
  DCheckAllowDeal.Width := 78;
  DCheckAllowDeal.Height := 17;
  DCheckAllowGuild.Left := 128;
  DCheckAllowGuild.Top := 96;
  DCheckAllowGuild.Width := 78;
  DCheckAllowGuild.Height := 17;
  DCheckAllowGroup.Left := 128;
  DCheckAllowGroup.Top := 116;
  DCheckAllowGroup.Width := 78;
  DCheckAllowGroup.Height := 17;
  DCheckAllowGroupReCall.Left := 128;
  DCheckAllowGroupReCall.Top := 136;
  DCheckAllowGroupReCall.Width := 78;
  DCheckAllowGroupReCall.Height := 17;
  DCheckAllowGuildReCall.Left := 128;
  DCheckAllowGuildReCall.Top := 156;
  DCheckAllowGuildReCall.Width := 78;
  DCheckAllowGuildReCall.Height := 17;
  DCheckAllowReAlive.Left := 128;
  DCheckAllowReAlive.Top := 176;
  DCheckAllowReAlive.Width := 78;
  DCheckAllowReAlive.Height := 17;

  DSmartWalk.Left := 128;
  DSmartWalk.Top := 18;
  DSmartWalk.Width := 78;
  DSmartWalk.Height := 17;

  DCheckSdoAutoSearchItem.Left := 255;
  DCheckSdoAutoSearchItem.Top := 136;
  DCheckSdoAutoSearchItem.WIDTH := 71;
  DCheckSdoAutoSearchItem.Height := 17;
  DCheckSdoAutoUseHuoLong.Left := 255;
  DCheckSdoAutoUseHuoLong.Top := 158;
  DCheckSdoAutoUseHuoLong.WIDTH := 71;
  DCheckSdoAutoUseHuoLong.Height := 17;
  DChecksdoAutoUseJinyuan.Left := 255;
  DChecksdoAutoUseJinyuan.Top := 180;
  DChecksdoAutoUseJinyuan.WIDTH := 71;
  DChecksdoAutoUseJinyuan.Height := 17;

  DCheckSdoItemsHint.Top := 36;
  DCheckSdoItemsHint.Left := 255;
  DCheckSdoItemsHint.WIDTH := 71;
  DCheckSdoItemsHint.Height := 17;
  DCheckSdoShowFiltrate.Top := 56;
  DCheckSdoShowFiltrate.Left := 255;
  DCheckSdoShowFiltrate.WIDTH := 71;
  DCheckSdoShowFiltrate.Height := 17;
  DCheckSdoAutoPickItems.Top := 76;
  DCheckSdoAutoPickItems.Left := 255;
  DCheckSdoAutoPickItems.WIDTH := 71;
  DCheckSdoAutoPickItems.Height := 17;
  DCheckSdoPickFiltrate.Top := 96;
  DCheckSdoPickFiltrate.Left := 255;
  DCheckSdoPickFiltrate.WIDTH := 71;
  DCheckSdoPickFiltrate.Height := 17;

  // 保护页里
  DWProtect.Width :=  384;
  DWProtect.Height  :=  207;
  DWProtect.Left  :=  14;
  DWProtect.Top :=  36;

  DCheckSdoCommonHp.Top := 32;
  DCheckSdoCommonHp.Left := 26;
  DCheckSdoCommonHp.WIDTH := 48;
  DCheckSdoCommonHp.Height := 17;
  DEdtSdoCommonHp.Top := 32;
  DEdtSdoCommonHp.Left := 75;
  DEdtSdoCommonHp.WIDTH := 50;
  DEdtSdoCommonHp.Height := 19;
  DEdtSdoCommonHpTimer.Top := 32;
  DEdtSdoCommonHpTimer.Left := 136;
  DEdtSdoCommonHpTimer.WIDTH := 40;
  DEdtSdoCommonHpTimer.Height := 19;
  DBtnCommonHpName.Left := 260;
  DBtnCommonHpName.Top := 32;
  DBtnCommonHpName.Width := 120;
  DBtnCommonHpName.Height := 19;

  DCheckSdoCommonMp.Top := 56;
  DCheckSdoCommonMp.Left := 26;
  DCheckSdoCommonMp.WIDTH := 48;
  DCheckSdoCommonMp.Height := 17;
  DEdtSdoCommonMp.Top := 56;
  DEdtSdoCommonMp.Left := 75;
  DEdtSdoCommonMp.WIDTH := 50;
  DEdtSdoCommonMp.Height := 19;
  DEdtSdoCommonMpTimer.Top := 56;
  DEdtSdoCommonMpTimer.Left := 136;
  DEdtSdoCommonMpTimer.WIDTH := 40;
  DEdtSdoCommonMpTimer.Height := 19;
  DBtnCommonMpName.Top := 56;
  DBtnCommonMpName.Left := 260;
  DBtnCommonMpName.Width := 120;
  DBtnCommonMpName.Height := 19;

  DCheckSdoSpecialHp.Top := 104;
  DCheckSdoSpecialHp.Left := 26;
  DCheckSdoSpecialHp.WIDTH := 48;
  DCheckSdoSpecialHp.Height := 17;
  DEdtSdoSpecialHp.Top := 104;
  DEdtSdoSpecialHp.Left := 75;
  DEdtSdoSpecialHp.WIDTH := 50;
  DEdtSdoSpecialHp.Height := 19;
  DEdtSdoSpecialHpTimer.Top := 104;
  DEdtSdoSpecialHpTimer.Left := 136;
  DEdtSdoSpecialHpTimer.WIDTH := 40;
  DEdtSdoSpecialHpTimer.Height := 19;
  DEdtSdoSpecialHpName.Left := 260;
  DEdtSdoSpecialHpName.Top := 104;
  DEdtSdoSpecialHpName.Width := 120;
  DEdtSdoSpecialHpName.Height := 19;

  DCheckSdoSpecialMP.Top := 128;
  DCheckSdoSpecialMP.Left := 26;
  DCheckSdoSpecialMP.WIDTH := 48;
  DCheckSdoSpecialMP.Height := 17;
  DEdtSdoSpecialMP.Top := 128;
  DEdtSdoSpecialMP.Left := 75;
  DEdtSdoSpecialMP.WIDTH := 50;
  DEdtSdoSpecialMP.Height := 19;
  DEdtSdoSpecialMPTimer.Top := 128;
  DEdtSdoSpecialMPTimer.Left := 136;
  DEdtSdoSpecialMPTimer.WIDTH := 40;
  DEdtSdoSpecialMPTimer.Height := 19;
  DEdtSdoSpecialMPName.Left := 260;
  DEdtSdoSpecialMPName.Top := 128;
  DEdtSdoSpecialMPName.Width := 120;
  DEdtSdoSpecialMPName.Height := 19;

  DCheckSdoRandomHp.Top := 180;
  DCheckSdoRandomHp.Left := 26;
  DCheckSdoRandomHp.WIDTH := 48;
  DCheckSdoRandomHp.Height := 17;
  DEdtSdoRandomHp.Top := 180;
  DEdtSdoRandomHp.Left := 75;
  DEdtSdoRandomHp.WIDTH := 50;
  DEdtSdoRandomHp.Height := 19;
  DEdtSdoRandomHpTimer.Top := 180;
  DEdtSdoRandomHpTimer.Left := 136;
  DEdtSdoRandomHpTimer.WIDTH := 40;
  DEdtSdoRandomHpTimer.Height := 19;
  DBtnSdoRandomName.Top := 180;
  DBtnSdoRandomName.Left := 260;
  DBtnSdoRandomName.WIDTH := 120;
  DBtnSdoRandomName.Height := 20;

//  DEHedge.Top :=  157;
//  DEHedge.Left  :=  281;
//  DEHedge.Width :=  40;
//  DEHedge.Height  :=  19;

  DCheckSdoAutoDrinkWine.Top := 38;
  DCheckSdoAutoDrinkWine.Left := 276;
  DCheckSdoAutoDrinkWine.WIDTH := 20;
  DCheckSdoAutoDrinkWine.Height := 17;
  DEdtSdoDrunkWineDegree.Top := 36;
  DEdtSdoDrunkWineDegree.Left := 303;
  DEdtSdoDrunkWineDegree.WIDTH := 20;
  DEdtSdoDrunkWineDegree.Height := 19;

  DCheckSdoAutoDrinkDrugWine.Top := 62;
  DCheckSdoAutoDrinkDrugWine.Left := 276;
  DCheckSdoAutoDrinkDrugWine.WIDTH := 20;
  DCheckSdoAutoDrinkDrugWine.Height := 17;
  DEdtSdoDrunkDrugWineDegree.Top := 62;
  DEdtSdoDrunkDrugWineDegree.Left := 303;
  DEdtSdoDrunkDrugWineDegree.WIDTH := 20;
  DEdtSdoDrunkDrugWineDegree.Height := 19;

  // 技能页里
  DWSkill.Width :=  384;
  DWSkill.Height  :=  207;
  DWSkill.Left  :=  14;
  DWSkill.Top :=  36;
  DCheckSdoLongHit.Top := 36;
  DCheckSdoLongHit.Left := 26;
  DCheckSdoLongHit.WIDTH := 71;
  DCheckSdoLongHit.Height := 17;

  DCheckSdoGWLongHit.Top := 56;
  DCheckSdoGWLongHit.Left := 26;
  DCheckSdoGWLongHit.Width := 71;
  DCheckSdoGWLongHit.Height := 17;

  DCheckSdoAutoWideHit.Top := 76;
  DCheckSdoAutoWideHit.Left := 26;
  DCheckSdoAutoWideHit.WIDTH := 71;
  DCheckSdoAutoWideHit.Height := 17;

  DCheckSdoAutoFireHit.Top := 96;
  DCheckSdoAutoFireHit.Left := 26;
  DCheckSdoAutoFireHit.WIDTH := 71;
  DCheckSdoAutoFireHit.Height := 17;

  DCheckSdoZhuri.Top := 116;
  DCheckSdoZhuri.Left := 26;
  DCheckSdoZhuri.WIDTH := 71;
  DCheckSdoZhuri.Height := 17;

  DCheckSdoAutoShield.Top := 157;
  DCheckSdoAutoShield.Left := 26;
  DCheckSdoAutoShield.WIDTH := 71;
  DCheckSdoAutoShield.Height := 17;

  DCheckSdoAutoHide.Top := 32;
  DCheckSdoAutoHide.Left := 143;
  DCheckSdoAutoHide.WIDTH := 71;
  DCheckSdoAutoHide.Height := 17;

  DCheckSdoAutoDuFu.Top := 52;
  DCheckSdoAutoDuFu.Left := 143;
  DCheckSdoAutoDuFu.WIDTH := 71;
  DCheckSdoAutoDuFu.Height := 17;


  DCheckMagicLock.Top := 96;
  DCheckMagicLock.Left := 143;
  DCheckMagicLock.Width := 71;
  DCheckMagicLock.Height := 17;

  DCheckSdoAutoMagic.Top := 36;
  DCheckSdoAutoMagic.Left := 256;
  DCheckSdoAutoMagic.WIDTH := 71;
  DCheckSdoAutoMagic.Height := 17;
  DEdtSdoAutoMagicTimer.Top := 36;
  DEdtSdoAutoMagicTimer.Left := 332;
  DEdtSdoAutoMagicTimer.WIDTH := 24;
  DEdtSdoAutoMagicTimer.Height := 19;


  // 按键页里
  DWKey.Width :=  384;
  DWKey.Height  :=  207;
  DWKey.Left  :=  14;
  DWKey.Top :=  36;
  DCheckSdoStartKey.Top := 7;
  DCheckSdoStartKey.Left := 9;
  DCheckSdoStartKey.WIDTH := 118;
  DCheckSdoStartKey.Height := 19;

  DBtnSdoUseBatterKey.Top := 49;
  DBtnSdoUseBatterKey.Left := 241;
  DBtnSdoUseBatterKey.WIDTH := 130;
  DBtnSdoUseBatterKey.Height := 19;

  DBtnSdoAttackModeKey.Top := 69;
  DBtnSdoAttackModeKey.Left := 241;
  DBtnSdoAttackModeKey.WIDTH := 130;
  DBtnSdoAttackModeKey.Height := 19;

  DBtnSdoMinMapKey.Top := 89;
  DBtnSdoMinMapKey.Left := 241;
  DBtnSdoMinMapKey.WIDTH := 130;
  DBtnSdoMinMapKey.Height := 19;

  //物品页
  DWItems.Width :=  384;
  DWItems.Height  :=  207;
  DWItems.Left  :=  14;
  DWItems.Top :=  36;
  DSdoItemUp.Left := 369;
  DSdoItemUp.Top := 3;
  DSdoItemDown.Left := 369;
  DSdoItemDown.Top := 189;
  DBItemScroll.Left := 369;
  DBItemScroll.Top := 3 + DSdoItemUp.Height;
  EditStdItemMode.Left := 8;
  EditStdItemMode.Top := 189;
  EditStdItemMode.Width := 120;
  EditStdItemMode.Height := 18;
  DEditItemSearch.Left := 130;
  DEditItemSearch.Top := 189;
  DEditItemSearch.Height := 17;
  DEditItemSearch.Width := 150;
  DBtnItemSearch.Left := 288;
  DBtnItemSearch.Top := 188;
  DBtnItemSearch.Width := 70;
  DBtnItemSearch.Height := 19;
  DBtnItemSearch.SetImgIndex(g_77Images, 152);

  // 帮助页里
  DWHelp.Width :=  384;
  DWHelp.Height  :=  207;
  DWHelp.Left  :=  14;
  DWHelp.Top :=  36;
  DSdoHelpUp.Left := 369;
  DSdoHelpUp.Top := 3;
  DSdoHelpNext.Left := 369;
  DSdoHelpNext.Top := 189;
end;

procedure TAssistantForm.ItemScrollTimerTimer(Sender: TObject);
begin
  if DSdoItemUp.Downed then
  begin
    Dec(FItemIndex);
    FItemIndex := Max(0, FItemIndex);
  end
  else
  begin
    if FItemIndex + 1 < FliterItems.Count then
      Inc(FItemIndex, 1);
  end;
  ReCalcItemScrollPos;
end;

procedure TAssistantForm.NewSdoAssistantPageChanged;
begin
  DScreen.ClearHint;
  DWBasic.Visible :=  False;
  DWProtect.Visible :=  False;
  DWSkill.Visible :=  False;
  DWKey.Visible :=  False;
  DWItems.Visible :=  False;
  DWHelp.Visible  :=  False;
  case g_btSdoAssistantPage of
    0: DWBasic.Visible :=  True;
    1: DWProtect.Visible :=  True;
    2: DWSkill.Visible :=  True;
    3: DWKey.Visible :=  True;
    4: DWItems.Visible :=  True;
    5: DWHelp.Visible  :=  True;
  end;
end;

procedure TAssistantForm.ReCalcItemScrollPos;
var
  AScrollHeight,
  NewTop: Integer;
begin
  AScrollHeight := DSdoItemDown.Top - DSdoItemUp.Top - DSdoItemUp.Height - DBItemScroll.Height;
  NewTop := DSdoItemUp.Top + DSdoItemUp.Height + Round((FItemIndex / (FliterItems.Count-1)) * AScrollHeight);
  if NewTop < DSdoItemUp.Top + DSdoItemUp.Height then
    NewTop := DSdoItemUp.Top + DSdoItemUp.Height
  else if NewTop > DSdoItemDown.Top - DBItemScroll.Height then
    NewTop := DSdoItemDown.Top - DBItemScroll.Height;
  DBItemScroll.Top := NewTop;
end;

procedure TAssistantForm.Save(const ChrName: String);
begin
  g_Config.Save;
end;

procedure TAssistantForm.UpdateForm;
begin
  //DCheckSdoShowFiltrate.Checked := g_boFilterAutoItemShow;
  DEdtSdoCommonHp.Text := IntToStr(g_Config.Assistant.EditCommonHp);
  DEdtSdoCommonHpTimer.Text := IntToStr(Max(1, g_Config.Assistant.EditCommonHpTimer));
  DEdtSdoCommonMp.Text := IntToStr(g_Config.Assistant.EditCommonMp);
  DEdtSdoCommonMpTimer.Text := IntToStr(Max(1, g_Config.Assistant.EditCommonMpTimer));
  DEdtSdoSpecialHp.Text := IntToStr(Max(g_Config.Assistant.EditSpecialHp,1));
  DEdtSdoSpecialHpTimer.Text := IntToStr(Max(1, g_Config.Assistant.EditSpecialHpTimer));
  DEdtSdoSpecialMp.Text := IntToStr(Max(g_Config.Assistant.EditSpecialMp,1));
  DEdtSdoSpecialMpTimer.Text := IntToStr(Max(1, g_Config.Assistant.EditSpecialMpTimer));
  DEdtSdoRandomHp.Text := IntToStr(g_Config.Assistant.EditRandomHp);
  DEdtSdoRandomHpTimer.Text := IntToStr(Max(1, g_Config.Assistant.EditRandomHpTimer));
  DEdtSdoAutoMagicTimer.Text := IntToStr(g_Config.Assistant.AutoMagicTime);
  DCheckSdoAutoDrinkWine.Checked := g_boAutoEatWine;
  DEdtSdoDrunkWineDegree.Text := IntToStr(g_btEditWine);
  DCheckSdoAutoDrinkDrugWine.Checked := g_boAutoEatDrugWine;
  DEdtSdoDrunkDrugWineDegree.Text := IntToStr(g_btEditDrugWine);
end;

procedure TAssistantForm.DrawCheckControl(DSurface: TAsphyreCanvas;
  ACheckBox: TDCheckBox; AChecked: Boolean; const ACaption: String);
var
  d: TAsphyreLockableTexture;
  ATexture: TAsphyreLockableTexture;
begin
  with ACheckBox do
  begin
    if not AChecked then
    begin
      d := g_77Images.Images[238];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
    end
    else
    begin
      d := g_77Images.Images[239];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
    end;
    if Moveed then
      Color := clWhite
    else
      Color := clSilver;
      ATexture  :=  FontManager.Default.TextOut(ACaption);
      if ATexture <> nil then
        dsurface.DrawBoldText(SurfaceX(Left + d.WIDTH + 2), SurfaceY(Top) + 3, ATexture, Color, FontBorderColor);
  end;
end;

procedure TAssistantForm.DrawControl(DSurface: TAsphyreCanvas; Button: TDButton; out FontColor: TColor);
var
  D: TAsphyreLockableTexture;
begin
  DSmartWalk.Visible := g_boCanUseSmartWalk;
  with Button do
  begin
    if Moveed then
    begin
      Color := $00387B9C;
      FontColor := clYellow;
    end
    else
    begin
      Color := $00498394;
      FontColor := clWhite;
    end;
    DSurface.FillRect(Rect(SurfaceX(Left), SurfaceY(Top), SurfaceX(Left) + WIDTH, SurfaceY(Top) + Height), cColor4(cColor1(clBlack)));
    DSurface.FrameRect(Rect(SurfaceX(Left), SurfaceY(Top), SurfaceX(Left) + WIDTH, SurfaceY(Top) + Height), cColor4(cColor1(Color)));
    D := g_77Images.Images[410 + Ord(Downed)];
    if D <> nil then
    begin
      DSurface.Draw(SurfaceX(Left) + WIDTH - D.Width - 2, SurfaceY(Top) + (Height - D.Height) div 2, D);
    end;
  end;
end;

procedure TAssistantForm.DrawEdit(AEdit: TDEdit; DSurface: TAsphyreCanvas);
var
  ALineColor: TColor;
begin
  with AEdit do
  begin
    if Moveed then
      ALineColor := $00387B9C
    else
      ALineColor := $00638494;
    if Focused then
      ALineColor := $005993BD;
    DSurface.Line(SurfaceX(Left), SurfaceY(Top), SurfaceX(Left) + WIDTH, SurfaceY(Top), cColor1(ALineColor));
    DSurface.Line(SurfaceX(Left), SurfaceY(Top), SurfaceX(Left), SurfaceY(Top) + Height, cColor1(ALineColor));
    DSurface.Line(SurfaceX(Left) + WIDTH, SurfaceY(Top), SurfaceX(Left) + WIDTH, SurfaceY(Top) + Height, cColor1(ALineColor));
    DSurface.Line(SurfaceX(Left), SurfaceY(Top) + Height, SurfaceX(Left) + WIDTH, SurfaceY(Top) + Height, cColor1(ALineColor));
  end;
end;

end.
