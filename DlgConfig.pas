unit DlgConfig;

interface

uses
  Classes, Controls, Forms, ExtUI, Dialogs, Windows,Messages,
  StdCtrls, Spin, ComCtrls, DWinCtl, SysUtils, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxEdit, ImgList, TypInfo,
  Rtti,
  ExtCtrls, ButtonGroup, cxInplaceContainer, cxVGrid, Graphics,
  Generics.Collections,
  cxOI, Menus, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxBar, cxClasses, cxCheckBox, cxBarEditItem,
  dxSkinsdxBarPainter, dxSkinscxPCPainter, dxBarBuiltInMenu, cxPC, cxScrollBox,
  cxSplitter, cxCheckComboBox,uDListView, AppEvnts, ActnList, dxSkinTheBezier,
  cxDataControllerConditionalFormattingRulesManagerDialog, cxImageList;

type
  TControlClass = class of TDControl;

  TfrmDlgConfig = class(TForm)
    GroupBox1: TGroupBox;
    GameWindowName: TGroupBox;
    InspectorUI: TcxRTTIInspector;
    TreeView: TTreeView;
    pnl_UIInfo: TPanel;
    lbl_Class: TLabel;
    lbl_Component: TLabel;
    lbl_Caption: TLabel;
    btn1: TButtonGroup;
    cxmglst1: TcxImageList;
    dlgSave1: TSaveDialog;
    dlgOpen1: TOpenDialog;
    chk_LangChange: TCheckBox;
    edt_ClassName: TEdit;
    edt_ComponetName: TEdit;
    edt_CaptionText: TEdit;
    DxBarManager: TdxBarManager;
    dxbrManagerBar: TdxBar;
    cxBar: TcxImageList;
    dxOpen: TdxBarButton;
    dxSave: TdxBarButton;
    dxImport: TdxBarButton;
    cxShowUIFrame: TcxBarEditItem;
    cxDesigningMode: TcxBarEditItem;
    cxAutoTrace: TcxBarEditItem;
    cxPgc1: TcxPageControl;
    cxtbsht1: TcxTabSheet;
    cxtbsht2: TcxTabSheet;
    cxspltr1: TcxSplitter;
    cxscrlbx1: TcxScrollBox;
    cxspltr2: TcxSplitter;
    cxBarEditItem1: TcxBarEditItem;
    pnl_Client: TPanel;
    tmr_SetClientToChild: TTimer;
    tmr_SetCaption: TTimer;
    dxExport: TdxBarButton;
    dxbrbtnBringToFront: TdxBarButton;
    dxbrbtnSendToBack: TdxBarButton;
    dxbrbtnExportUI: TdxBarButton;
    dxbrbtnImportUI: TdxBarButton;
    dxbrbtnDeleteUI: TdxBarButton;
    dxbrbtnCutComponent: TdxBarButton;
    dxbrbtnPasteUI: TdxBarButton;
    pm1: TPopupMenu;
    SetUIFront: TMenuItem;
    SetUIBackend: TMenuItem;
    Export: TMenuItem;
    Import: TMenuItem;
    CutUI: TMenuItem;
    PasteUI: TMenuItem;
    DelUI: TMenuItem;
    cxmglstpopup: TcxImageList;
    cxShowUIFrame1: TcxBarEditItem;
    tmr_CheckInsperObject: TTimer;
    EventHandler: TApplicationEvents;
    btnsdfsdfasdf: TButton;
    btn3sss: TButton;
    actlst1: TActionList;
    act_Save: TAction;
    cxtbsht_Config: TcxTabSheet;
    dxbrbtn_ClientConfig: TdxBarButton;
    ClientSettingRtti: TcxRTTIInspector;
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure ButtonShowClick(Sender: TObject);
    procedure EditImageChange(Sender: TObject);
    procedure tv1Change(Sender: TObject; Node: TTreeNode);
    procedure Btn2Click(Sender: TObject);
    procedure se1Change(Sender: TObject);
    procedure chk_ShowUIFrameClick(Sender: TObject);
    procedure TreeViewCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure btn1ButtonClicked(Sender: TObject; Index: Integer);
    procedure InspectorUIFilterPropertyEx(Sender: TObject;
      const PropertyName: string; var Accept: Boolean);
    procedure dxbrbtnBringToFrontClick(Sender: TObject);
    procedure dxbrbtnSendToBackClick(Sender: TObject);
    procedure chk_LangChangeClick(Sender: TObject);
    procedure dxbrbtnExportUIClick(Sender: TObject);
    procedure dxbrbtnImportUIClick(Sender: TObject);
    procedure dxbrbtnDeleteUIClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure TreeViewDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TreeViewEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure TreeViewDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dxbrbtnCutComponentClick(Sender: TObject);
    procedure dxbrbtnPasteUIClick(Sender: TObject);
    procedure pmPopup(Sender: TObject);
    procedure dxOpenClick(Sender: TObject);
    procedure dxSaveClick(Sender: TObject);
    procedure cxAutoTraceChange(Sender: TObject);
    procedure tmr_SetClientToChildTimer(Sender: TObject);
    procedure tmr_SetCaptionTimer(Sender: TObject);
    procedure tmr_CheckInsperObjectTimer(Sender: TObject);
    procedure EventHandlerMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure btnsdfsdfasdfClick(Sender: TObject);
    procedure btn3sssClick(Sender: TObject);
    procedure act_SaveExecute(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
    procedure RefWindowsList();
    procedure RefWindowsListChild(TreeNode: TTreeNode; DControl: TDControl);
    procedure RefAcherWorder();
    procedure OnControlPostionChange(Sender: TDControl);
  end;

  TDXPropStringPropertyEditor = class(TcxStringProperty)
    function GetName: String; override;
    function GetValue: string; override;
  end;

  TDXPropIntPropertyEditor = class(TcxIntegerProperty)
    function GetName: string; override;
    function GetValue: string; override;
  end;

  TDXPropFloatPropertyEditor = class(TcxFloatProperty)
    function GetName: string; override;
  end;

  TDXPropBoolPropertyEditor = class(TcxBoolProperty)
    function GetName: string; override;
    function GetValue: string; override;
  end;

  TDXEnumPropertyEditor = class(TcxEnumProperty)
    function GetName: string; override;
    function GetValue: string; override;
  end;

  TDXSetsPropertyEditor = class(TcxSetProperty)
    function GetName: string; override;
    function GetValue: string; override;
    procedure GetProperties(AOwner: TComponent;
      Proc: TcxGetPropEditProc); override;
  end;

  TDXSetsElement = class(TcxSetElementProperty)
    function GetName: string; override;
  end;

  TDXClassPropertyEditor = class(TcxClassProperty)
    function GetName: string; override;
    function GetValue: string; override;
  end;

  TDXColorProperty = class(cxOI.TcxColorProperty)
    function GetName: string; override;
  end;

  TDXSelChrJobInfo = class(TcxClassProperty)
    function GetName: string; override;
    function GetValue: string; override;
  end;

  TDXPropIntJobImage = class(TcxIntegerProperty)
    function GetName: string; override;
    function GetValue: string; override;
  end;
var
  frmDlgConfig: TfrmDlgConfig;
  sXML1: string = 'MS';
  sXML8: string = 'ET';

  const
  STDHEIGHT = 55;
  STDWIDTH = 545;

implementation

uses
  MShare, uActionsMgr, FState,ClMain,InputUIName,PopupMeunuFrm,uClientCustomSetting;

var
  DefDControl: TDControl;
  CopyContorl: TDControl;
  CopyTreeNode: TTreeNode;
  ControlClass: TControlClass;
  PropertyNames: TDictionary<String, String>; // 属性中英文对照表

  ValueNames: TDictionary<String, String>; // 属性值 中英文对照表
  ValueNames_Search: TDictionary<String, String>; // 属性值反查表 。 中文查找英文
  AttrTypeInfo: TDictionary<String, PTypeInfo>;

  // 过滤显示的属性
  FilterPropertyList: TDictionary<String, Boolean>; // 过滤显示的属性

  g_BoChinese: Boolean = True;

  g_NowLoadFile:string = '';

{$R *.dfm}
  { TfrmDlgConfig }

procedure OnUITrace(D: TDControl);
var
  I: Integer;
  Node: TTreeNode;
begin
  for I := 0 to frmDlgConfig.TreeView.Items.Count - 1 do
  begin
    Node := frmDlgConfig.TreeView.Items[I];
    if Node.Data = D then
    begin
      frmDlgConfig.TreeView.Select(Node);
      Break;
    end;
  end;
end;

procedure TfrmDlgConfig.dxbrbtnBringToFrontClick(Sender: TObject);
var
  I: Integer;
  D: TDControl;
begin
  if (DefDControl <> nil) and (DefDControl.DParent <> nil) then
  begin
    DefDControl.DParent.RemoveControl(DefDControl);
    DefDControl.DParent.AddChild(DefDControl);
  end;
end;

procedure TfrmDlgConfig.act_SaveExecute(Sender: TObject);
begin
  dxSaveClick(nil);
end;

procedure TfrmDlgConfig.btn1ButtonClicked(Sender: TObject; Index: Integer);
var
  Control: TWinControl;
  D: TDControl;
  UIName: string;
  TreeNode: TTreeNode;
  I: Integer;
begin

  btn1.ItemIndex := -1;

  if DefDControl = nil then
    Exit;

  if not DefDControl.CanAddChildControl then
  begin
    Application.MessageBox('该组件不能添加子组件！', '错误！', MB_OK + MB_ICONWARNING);
    Exit;
  end;

  if  GetNewUIName(UIName) then
  begin

    if g_DWinMan.FindControlByName(UIName) <> nil then
    begin
      Application.MessageBox('已经存在同名组件！请更换组件名。', '错误！', MB_OK + MB_ICONSTOP);
      Exit;
    end;

    if not IsValidIdent(UIName,False) then
    begin
      Application.MessageBox('组件名称不能以数字开头', '错误！', MB_OK + MB_ICONSTOP);
      Exit;
    end;

    Control := TWinControl(Sender);
    case Index of
      0:
        D := TDTextField.Create(DefDControl);
      1:
        begin
          D := TDEdit.Create(DefDControl);
          D.Propertites.EnableFocus := True;
        end;
      2:
        D := TDWindow.Create(DefDControl);
      3:
        D := TDAniButton.Create(DefDControl);
      4:
        D := TDScriptButton.Create(DefDControl);
      5:
        D := TDCloseWindowButton.Create(DefDControl);
      6:
        D := TDSetControlVisiableButton.Create(DefDControl);
      7:
        D := TDDrawItemImage.Create(DefDControl);
      8:
        D := TDVarTextField.Create(DefDControl);

    end;

    D.DParent := DefDControl;
    D.Parent := DefDControl;
    D.IsCustomUI := True;
    DefDControl.AddChild(D);

    D.Left := 0;
    D.Top := 0;
    D.Width := 16;
    D.Height := 16;

    D.Name := UIName;
    D.Visible := True;
    D.Caption := UIName;

    // 增加到列表
    for I := 0 to TreeView.Items.Count - 1 do
    begin
      TreeNode := TreeView.Items[I];
      if TreeNode.Data = DefDControl then
      begin
        TreeNode := TreeView.Items.AddChild(TreeNode,
          D.Caption + '(' + D.Name + ')');
        TreeNode.Data := D;
        TreeView.Select(TreeNode);
        Break;
      end;
    end;

  end;
end;

procedure TfrmDlgConfig.btn1Click(Sender: TObject);
begin
  btn1.ItemIndex := -1;
end;

procedure TfrmDlgConfig.Btn2Click(Sender: TObject);
const
  sData = 'WORDER_CKL : Array[0..1,0..887] of Byte = (' + #13#10 + '(' + #13#10
    + '%s' + '),' + #13#10 + '(' + #13#10 + '%s' + #13#10 + '));';
var
  sMan: string;
  swomen: string;
  I: Integer;
  sList: TStringList;
begin
  sList := TStringList.Create;
  for I := 0 to 887 do
  begin
    if (I <> 0) and (I mod 40 = 0) then
    begin
      sMan := sMan + #13#10;
    end;

    if I = 887 then
      sMan := sMan + IntToStr(WORDER_CKL[0, I])
    else
      sMan := sMan + IntToStr(WORDER_CKL[0, I]) + ',';
  end;

  for I := 0 to 887 do
  begin
    if (I <> 0) and (I mod 40 = 0) then
    begin
      swomen := swomen + #13#10;
    end;
    if I = 887 then

      swomen := swomen + IntToStr(WORDER_CKL[1, I])
    else
      swomen := swomen + IntToStr(WORDER_CKL[1, I]) + ',';
  end;

  sList.Text := Format(sData, [sMan, swomen]);
  sList.SaveToFile('D:\22.txt');

  sList.Free;

end;

procedure TfrmDlgConfig.btn3sssClick(Sender: TObject);
var
  UIName, npcname , AMessage: String;
  S:TStringList;
begin
  g_nMDlgX := g_MySelf.m_nCurrX;
  g_nMDlgY := g_MySelf.m_nCurrY;

  S:= TStringList.Create;
  Try
    S.LoadFromFile('D:\91Debug\2.txt');
    FrmDlg.ShowCustomMDlg(1122, 0, 0,'命运通关', '命运之神',  S.Text);
  Finally
    S.Free;
  End;
end;

procedure TfrmDlgConfig.btnsdfsdfasdfClick(Sender: TObject);
var
  UIName, npcname , AMessage: String;
  S:TStringList;
begin
  g_nMDlgX := g_MySelf.m_nCurrX;
  g_nMDlgY := g_MySelf.m_nCurrY;

  S:= TStringList.Create;
  Try
    S.LoadFromFile('D:\91Debug\1.txt');
    FrmDlg.ShowCustomMDlg(1122, 0, 0,'命运通关', '命运之神',  S.Text);
  Finally
    S.Free;
  End;
end;

procedure TfrmDlgConfig.RefAcherWorder;
var
  I: Integer;
  ManNode, womenNode, Node: TTreeNode;
begin
//  ManNode := tv1.Items.AddFirst(nil, '男');
//  womenNode := tv1.Items.AddFirst(ManNode, '女');
//
//  for I := 0 to 887 do
//  begin
//    Node := tv1.Items.AddChild(ManNode, IntToStr(I));
//    Node.Data := @WORDER_CKL[0, I];
//  end;
//
//  for I := 0 to 887 do
//  begin
//    Node := tv1.Items.AddChild(womenNode, IntToStr(I));
//    Node.Data := @WORDER_CKL[1, I];
//  end;

end;


procedure TfrmDlgConfig.ButtonShowClick(Sender: TObject);
begin
  if DefDControl <> nil then
    DefDControl.Visible := not DefDControl.Visible;
end;


procedure TfrmDlgConfig.chk_LangChangeClick(Sender: TObject);
var
  obj: TPersistent;
begin
  g_BoChinese := chk_LangChange.Checked;
  obj := InspectorUI.InspectedObject;
  InspectorUI.InspectedObject := nil;
  InspectorUI.InspectedObject := obj;
  InspectorUI.FullExpand;
end;



procedure TfrmDlgConfig.chk_ShowUIFrameClick(Sender: TObject);
begin
  DWinCtl.ShowUIFrame := not DWinCtl.ShowUIFrame;
end;

procedure TfrmDlgConfig.dxbrbtnCutComponentClick(Sender: TObject);
begin
  CopyContorl := DefDControl;
  CopyTreeNode := TreeView.Selected;
end;

procedure TfrmDlgConfig.cxAutoTraceChange(Sender: TObject);
begin
  if Sender = cxAutoTrace then
  begin
    g_DWinMan.AutoUITrace := TcxBarEditItem(Sender).EditValue;
  end else if Sender = cxShowUIFrame then
  begin
    DWinCtl.ShowUIFrame := TcxBarEditItem(Sender).EditValue;
  end else if Sender = cxDesigningMode then
  begin
    g_DWinMan.DragMode := TcxBarEditItem(Sender).EditValue;
  end;


end;

procedure TfrmDlgConfig.dxbrbtnDeleteUIClick(Sender: TObject);
begin
  if DefDControl <> nil then
  begin
    if DefDControl.IsCustomUI then
    begin
      DefDControl.DParent.RemoveControl(DefDControl);
      DefDControl.DParent := nil;
      InspectorUI.InspectedObject := nil;
      DefDControl.Free;
      RefWindowsList;
    end
    else
    begin
      Application.MessageBox('系统内置组件只能屏蔽。不允许删除!', '错误！', MB_OK + MB_ICONSTOP);
    end;
  end;
end;

procedure TfrmDlgConfig.dxOpenClick(Sender: TObject);
begin
  // g_DWinMan.LoadFromFile('D:\360data\重要数据\桌面\qqqq.xml');
  if dlgOpen1.Execute then
  begin
    g_DWinMan.LoadFromFile(dlgOpen1.FileName);
    g_NowLoadFile := dlgOpen1.FileName;
    ClientSettingRtti.InspectedObject := nil;
    ClientSettingRtti.InspectedObject := g_ClientCustomSetting;
  end;

  RefWindowsList;
end;

procedure TfrmDlgConfig.dxSaveClick(Sender: TObject);
var
  DirName:String;
  FileName:String;
  OldFormatSettings :TFormatSettings;
begin
  // g_DWinMan.SaveToFile('D:\360data\重要数据\桌面\qqqq.xml');
  PopupMeunuFrm.DXPopupMenu.HidePopup;
  if (g_NowLoadFile <> '')  and (FileExists(g_NowLoadFile))then
  begin
    g_DWinMan.SaveToFile(g_NowLoadFile);
    ShowMessage('保存成功！');
  end else
  begin

    if dlgSave1.Execute then
    begin
      if FileExists(dlgSave1.FileName) then
      begin
        if Application.MessageBox('当前路径已经存在同名文件。是否覆盖？', '是否覆盖？',
          MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
        begin
          g_DWinMan.SaveToFile(dlgSave1.FileName);
        end;
      end
      else
      begin
        g_DWinMan.SaveToFile(dlgSave1.FileName);
      end;

      g_NowLoadFile := dlgSave1.FileName;
    end else
    begin
      Exit;
    end;
  end;


  DirName := ExtractFilePath(Application.ExeName) + '91UIBak\';
  if not DirectoryExists(DirName) then
    ForceDirectories(DirName);
  OldFormatSettings := FormatSettings;
  FormatSettings.DateSeparator := '-';
  FormatSettings.TimeSeparator := '_';
  FormatSettings.ListSeparator := '_';
  FormatSettings.DecimalSeparator := '_';
  FormatSettings.ThousandSeparator := '_';
  Try
    FileName := DirName + DateTimeToStr(Now) + '.UI';
    FileName := StringReplace(FileName,' ','-',[rfReplaceAll]);

    g_DWinMan.SaveToFile(FileName);
  Finally
    FormatSettings := OldFormatSettings;
  End;






end;

procedure TfrmDlgConfig.EditImageChange(Sender: TObject);
begin
  if DefDControl = nil then
    Exit;
end;

procedure TfrmDlgConfig.EventHandlerMessage(var Msg: tagMSG;
  var Handled: Boolean);
var
  KeyCode : Word;
begin
//  if Msg.message = WM_KEYDOWN then
//  begin
//    case Msg.wParam of
//      VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN:
//      begin
//        if GetForegroundWindow <> ClMain.frmMain.Handle  then
//        begin
//          SetForegroundWindow(ClMain.frmMain.Handle);
//          Handled := True;
//        end;
//      end;
//    end;
//  end;
end;

procedure TfrmDlgConfig.dxbrbtnExportUIClick(Sender: TObject);
begin
  if DefDControl = nil then
    Exit;

  if dlgSave1.Execute then
  begin

    if FileExists(dlgSave1.FileName) then
    begin

      if Application.MessageBox('当前路径已经存在同名文件。是否覆盖？', '是否覆盖？',
        MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
      begin
        DefDControl.SaveToFile(dlgSave1.FileName);
      end;
    end
    else
    begin
      DefDControl.SaveToFile(dlgSave1.FileName);
    end;
  end;

end;

procedure TfrmDlgConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  g_DWinMan.DragMode := False;
  DWinCtl.ShowUIFrame := False;
end;

// 过滤的项目为 标题.内容
procedure TfrmDlgConfig.dxbrbtnImportUIClick(Sender: TObject);
begin
  if DefDControl = nil then
    Exit;

  if dlgOpen1.Execute then
  begin
    DefDControl.LoadFromFile(dlgOpen1.FileName);
  end;

  RefWindowsList;
end;

procedure TfrmDlgConfig.InspectorUIFilterPropertyEx(Sender: TObject;
  const PropertyName: string; var Accept: Boolean);
begin
  if FilterPropertyList.ContainsKey(PropertyName) then
    Accept := False;
end;

procedure TfrmDlgConfig.OnControlPostionChange(Sender: TDControl);
begin
  InspectorUI.InspectedObject := nil;
  if Sender <> nil then
    InspectorUI.InspectedObject := Sender.Propertites;

  DWinCtl.SeletedControl := Sender;
  InspectorUI.FullExpand;
end;

procedure TfrmDlgConfig.Open;
begin
  DefDControl := nil;
  RefWindowsList();
  RefAcherWorder();
  DWinCtl.UITraceProc := OnUITrace;
  DWinCtl.OnControlPostionChange := OnControlPostionChange;
  Visible := True;
end;

procedure TfrmDlgConfig.dxbrbtnPasteUIClick(Sender: TObject);
var
  Node: TTreeNode;
begin
  if (DefDControl <> nil) and (CopyContorl <> nil) and (CopyTreeNode <> nil) and
    (TreeView.Selected <> nil) then
  begin
    if not DefDControl.CanAddChildControl then
      Application.MessageBox('该组件不能添加子组件！', '错误！', MB_OK + MB_ICONSTOP);
    if (CopyContorl.DParent <> DefDControl)  and (CopyContorl <> DefDControl) then
    begin
      CopyContorl.DParent.RemoveControl(CopyContorl);
      DefDControl.AddSub(CopyContorl);
      CopyContorl.PositionChanged();
      Node := TreeView.Items.AddChild(TreeView.Selected, CopyTreeNode.Text);
      Node.Data := CopyTreeNode.Data;

      TreeView.Items.Delete(CopyTreeNode);

      CopyContorl := nil;
    end;
  end;
end;

procedure TfrmDlgConfig.pmPopup(Sender: TObject);
begin
  if (CopyContorl = nil) or (CopyTreeNode = nil) then
  begin
  //  PasteUI.Enabled := False;
  end
  else
  begin
  //  PasteUI.Enabled := True;
  end;
end;

procedure TfrmDlgConfig.RefWindowsList();
var
  I: Integer;
  DControl, GlobalControl: TDControl;
  BoAddGlobal: Boolean;
  GlobalNode, ANode: TTreeNode;
begin
  TreeView.Items.Clear;
  BoAddGlobal := False;

  TreeView.Items.BeginUpdate;
  Try
    DControl := g_DWinMan.DWinList.Items[0];
    GlobalNode := TreeView.Items.AddChildObjectFirst(nil, '全局窗口',TObject(DControl));
    RefWindowsListChild(GlobalNode, DControl);
    GlobalNode.Expand(False);
  Finally
    TreeView.Items.EndUpdate;
  End;

end;

procedure TfrmDlgConfig.RefWindowsListChild(TreeNode: TTreeNode;
  DControl: TDControl);
var
  I: Integer;
  TempTreeNode: TTreeNode;
  TempDControl: TDControl;
begin
  for I := 0 to DControl.DControls.Count - 1 do
  begin
    TempDControl := DControl.DControls.Items[I];
    TempTreeNode := TreeView.Items.AddChildObjectFirst(TreeNode,
      TempDControl.Caption + '(' + TempDControl.Name + ')',
      TObject(TempDControl));
    RefWindowsListChild(TempTreeNode, TempDControl);
  end;
end;

procedure TfrmDlgConfig.se1Change(Sender: TObject);
var
  Node: TTreeNode;
begin
//  Node := tv1.Selected;
//  if Node.Data <> nil then
//  begin
//    PByte(Node.Data)^ := Byte(se1.Value);
//  end;
end;

procedure TfrmDlgConfig.dxbrbtnSendToBackClick(Sender: TObject);
var
  I: Integer;
  D: TDControl;
begin
  if (DefDControl <> nil) and (DefDControl.DParent <> nil) then
  begin
    DefDControl.DParent.RemoveControl(DefDControl);
    DefDControl.DParent.AddControlFirst(DefDControl);
  end;
end;

procedure TfrmDlgConfig.tmr_CheckInsperObjectTimer(Sender: TObject);
begin
  if InspectorUI.InspectedObject is TDControl then
    InspectorUI.InspectedObject := TDControl(InspectorUI.InspectedObject).Propertites;
end;

procedure TfrmDlgConfig.tmr_SetCaptionTimer(Sender: TObject);
begin
  Caption := frmMain.Caption;
end;

procedure TfrmDlgConfig.tmr_SetClientToChildTimer(Sender: TObject);
var
  W,H:Integer;
begin
  tmr_SetClientToChild.Enabled := False;
  frmMain.Visible := True;
  W := frmMain.ClientWidth;
  H := frmMain.ClientHeight;

  frmMain.BorderStyle := bsNone;


  frmMain.ClientWidth := W;
  frmMain.ClientHeight := h;

  pnl_Client.ClientWidth := W;
  pnl_Client.ClientHeight := H;
  frmMain.Left := 0;
  frmMain.Top := 0;

  Self.Width := W + STDWIDTH + GetSystemMetrics(SM_CXFRAME);
  Self.Height := H + STDHEIGHT + GetSystemMetrics(SM_CXFRAME);
  Windows.SetParent(frmMain.Handle,pnl_Client.Handle);

  SetWindowPos(Self.handle,HWND_NOTOPMost,left,top,width,height,0);

  ClientSettingRtti.InspectedObject := g_ClientCustomSetting;
end;
procedure TfrmDlgConfig.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  if Node <> nil then
  begin
    DefDControl := Node.Data;
    InspectorUI.InspectedObject := DefDControl.Propertites;
    edt_ClassName.Text := g_DWinMan.GetControlDesc(DefDControl.ClassName);
    edt_ComponetName.Text := DefDControl.Name;
    edt_CaptionText.Text := DefDControl.Caption;

    DWinCtl.SeletedControl := DefDControl;
    InspectorUI.FullExpand;
  end;
end;

procedure TfrmDlgConfig.TreeViewCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if (cdsSelected in State) or (cdsFocused in State) or
    (TreeView.Selected = Node) then
  begin
    TreeView.Canvas.Font.Color := clRed;
    TreeView.Canvas.Brush.Color := clYellow;
  end;
end;

procedure TfrmDlgConfig.TreeViewDragDrop(Sender, Source: TObject;
  X, Y: Integer);
var
  Node, ANode: TTreeNode;
  Control, SourceControl: TDControl;
begin
  Node := TreeView.GetNodeAt(X, Y);
  if Node <> nil then
    Control := Node.Data;
  if (Control <> nil) and (TreeView.Selected <> nil) then
  begin
    SourceControl := TreeView.Selected.Data;
    if (SourceControl <> nil) and SourceControl.CanAddChildControl and
      (Control.DParent <> SourceControl)  and (SourceControl <> Control) then
    begin
      SourceControl.DParent.RemoveControl(SourceControl);
      Control.AddChild(SourceControl);
      SourceControl.DParent := Control;
      SourceControl.Parent := Control;

      ANode := TreeView.Selected;
      Node := TreeView.Items.AddChild(Node, ANode.Text);
      Node.Text := ANode.Text;
      Node.Data := ANode.Data;
      TreeView.Items.Delete(ANode);
	  RefWindowsListChild(Node,SourceControl);
      CopyContorl := nil;
    end else
    begin
      CopyContorl := nil;
    end;
  end;
end;

procedure TfrmDlgConfig.TreeViewDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  Node, SourceNode: TTreeNode;
  Control, SourceControl: TDControl;
begin
  Accept := True;
  case State of
    dsDragEnter, dsDragMove:
      begin
        Node := TTreeView(Sender).GetNodeAt(X, Y);
        if Node <> nil then
          Control := Node.Data;

        SourceNode := TreeView.Selected;
        if SourceNode <> nil then
        begin
          SourceControl := SourceNode.Data;
          if SourceControl = FrmDlg.DBackground then
          begin
            Accept := False;
          end;
        end;

        if Accept and (SourceControl <> nil) and (Control <> nil) then
        begin
          if SourceControl.DParent = Control then
            Accept := False;
        end
        else
          Accept := False;
      end
  end;
end;

procedure TfrmDlgConfig.TreeViewEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  if Sender <> nil then
  begin

  end;
end;

procedure TfrmDlgConfig.tv1Change(Sender: TObject; Node: TTreeNode);
begin
//  if Node.Data <> nil then
//  begin
//    se1.Value := PByte(Node.Data)^;
//  end;
end;

function GetPropertyName(const S: String): string;
begin
  if g_BoChinese then
  begin
    PropertyNames.TryGetValue(S, Result);
    if Result = '' then
      Result := S;
  end
  else
  begin
    Result := S;
  end;
end;

function GetValueName(const S: String): string;
begin
  if g_BoChinese then
  begin
    ValueNames.TryGetValue(S, Result);
    if Result = '' then
      Result := S;
  end
  else
  begin
    Result := S;
  end;
end;

procedure AddValueName(const ValueName, Name: String);
begin
  ValueNames.Add(ValueName, Name);
  // ValueNames_Search.Add(Name,ValueName);
end;

procedure AddPropertyName(AttrName, Name: String);
var
  PInfo: PTypeInfo;
begin
  PInfo := nil;
  AttrTypeInfo.TryGetValue(AttrName, PInfo);
  if PInfo <> nil then
  begin
    case PInfo.Kind of
      tkInteger:
        cxOI.cxRegisterPropertyEditor(PInfo, TCustomDXPropertites, AttrName,
          TDXPropIntPropertyEditor);
      tkString, tkUString, tkLString, tkWString, tkWChar, tkChar:
        cxOI.cxRegisterPropertyEditor(PInfo, TCustomDXPropertites, AttrName,
          TDXPropStringPropertyEditor);
      tkEnumeration:
        cxOI.cxRegisterPropertyEditor(PInfo, TCustomDXPropertites, AttrName,
          TDXPropBoolPropertyEditor);
      tkSet:
        cxOI.cxRegisterPropertyEditor(PInfo, TCustomDXPropertites, AttrName,
          TDXSetsPropertyEditor);
      tkFloat:
        cxOI.cxRegisterPropertyEditor(PInfo, TCustomDXPropertites, AttrName,
          TDXPropFloatPropertyEditor);
    end;
    PropertyNames.Add(AttrName, Name);
  end;
end;

function GetEditorClass(PInfo: PTypeInfo; out PType: PTypeInfo)
  : TcxPropertyEditorClass;
begin
  Result := nil;
  PType := PInfo;
  if PInfo <> nil then
  begin
    case PInfo.Kind of
      tkInteger:
        begin
          if PInfo.Name = 'TColor' then
          begin
            PType := TypeInfo(TColor);

            if PType <> nil then
              Result := TcxColorProperty;
          end
          else
          begin
            Result := TDXPropIntPropertyEditor;
          end;
        end;
      tkString, tkUString, tkLString, tkWString, tkWChar, tkChar:
        Result := TDXPropStringPropertyEditor;
      tkEnumeration:
        Result := TDXPropBoolPropertyEditor;
      tkSet:
        Result := TDXSetsPropertyEditor;
      tkFloat:
      Result := TDXPropFloatPropertyEditor;
    end;
  end;
end;

procedure InitRttiName();
var
  ctx: TRttiContext;
  t: TRttiType;
  p: TRttiProperty;
  PType: PTypeInfo;
  F: TRttiField;
  S, SS: string;
  nIndex, I: Integer;
  Classes: TcxPropertyEditorClass;
begin
  t := ctx.GetType(TDX9GirdImagePropertites);
  for p in t.GetProperties do
  begin
    Classes := GetEditorClass(p.PropertyType.Handle, PType);
    if Classes <> nil then
    begin
      cxOI.cxRegisterPropertyEditor(PType, TDX9GirdImagePropertites,
        p.Name, Classes);
    end;
  end;

  t := ctx.GetType(TCustomDXPropertites);
  for p in t.GetProperties do
  begin
    AttrTypeInfo.Add(p.Name, p.PropertyType.Handle);
  end;

  // 注册 String 类中文
  PropertyNames.Add('LibFile', '文件名称');
  PropertyNames.Add('Lib', '图库文件');
  AddPropertyName('FontName', '字体名称');
  AddPropertyName('FontSize', '字体大小');
  AddPropertyName('Hint', '提示内容');

  // 注册 Interger 类中文
  PropertyNames.Add('Height', '高度');
  PropertyNames.Add('Left', 'X');
  PropertyNames.Add('Width', '宽度');
  PropertyNames.Add('Top', 'Y');

  AddPropertyName('RowCount', '行格子数量');
  AddPropertyName('ColCount', '列格子数量');
  AddPropertyName('GridWidth', '格子宽度');
  AddPropertyName('GridHeight', '格子高度');

  PropertyNames.Add('ImageIndex', '图片序号');
  PropertyNames.Add('DownedIndex', '按下序号');
  PropertyNames.Add('DisabledIndex', '禁止状态');
  PropertyNames.Add('AniCount', '动画图片数量');
  PropertyNames.Add('AniInterval', '每帧间隔');
  PropertyNames.Add('AniLoop', '循环播放');
  PropertyNames.Add('OutLinePixel', '描边像素');
  PropertyNames.Add('CheckedIndex', '选中图像序号');
  PropertyNames.Add('MoveIndex', '鼠标经过');

  // 注册 Boolean类中文
  AddPropertyName('ShowHint', '显示提示信息');
  AddPropertyName('Visible', '可见');
  AddPropertyName('MouseThrough', '鼠标穿透');
//  AddPropertyName('EngineResourceFirst','优先读取91资源');
  AddPropertyName('Floating', '浮动');
  AddPropertyName('AllowESC', 'ESC关闭窗口');
  AddPropertyName('EnableFocus', '允许获取焦点');
  AddPropertyName('NotFront', '不允许前置');
  AddPropertyName('AutoSize', '宽高自动调整');
  AddPropertyName('Align', '对齐方式');

  AddPropertyName('ClipType', '裁剪方式');
  AddPropertyName('DAnchors', '布局');
  AddPropertyName('ClipOrientation', '裁剪方向');

  AddPropertyName('Sound', '点击声音');
  AddPropertyName('FontStyle', '字体风格');
  AddPropertyName('Caption', '标题');
  AddPropertyName('IntoSceneShow', '进入场景显示');
  AddPropertyName('OutSceneHide', '退出场景隐藏');
  AddPropertyName('Position', '位置信息');
  AddPropertyName('ImageProperty', '图片设置');
  AddPropertyName('OwnerScene', '所属场景');
  AddPropertyName('OffsetX', 'X偏移');
  AddPropertyName('OffsetY', 'Y偏移');
  AddPropertyName('UseImageOffset', '使用资源文件XY偏移');
  AddPropertyName('DrawMode', '绘制模式');
  AddPropertyName('InCenter', '屏幕居中');
  AddPropertyName('BorderPixel', '边框像素量');
  AddPropertyName('Abandon', '屏蔽此组件');
  AddPropertyName('DisableMouseEvent', '禁止鼠标消息');
  AddPropertyName('QuteNumber','数字千分号');
  AddPropertyName('AnchorX','位置锚点X');
  AddPropertyName('AnchorY','位置锚点Y');
  AddPropertyName('AnchorPx','中心锚点X');
  AddPropertyName('AnchorPy','中心锚点Y');
  AddPropertyName('UseAnchorPosition','使用锚点');
  AddPropertyName('ChatBoxStyle','聊天框背景风格');

  AddValueName('aLeft', '左对齐');
  AddValueName('aCenter', '居中');
  AddValueName('aRight', '右对齐');

  AddValueName('ctNone', '不裁剪');
  AddValueName('ctHp', '根据HP裁剪');
  AddValueName('ctMP', '根据MP裁剪');
  AddValueName('ctExp', '根据经验裁剪');
  AddValueName('ctWeight', '根据负重裁剪');
  AddValueName('ctDynamicValue', '动态裁剪值');

  AddValueName('coBottom2Top', '从下往上');
  AddValueName('coTop2Bottom', '从上往下');
  AddValueName('coRight2Left', '从右往左');
  AddValueName('coLeftToRight', '从左往右');

  AddValueName('True', '是');
  AddValueName('False', '否');

  PropertyNames.Add('akLeft', '锁定左边');
  PropertyNames.Add('akTop', '锁定顶部');
  PropertyNames.Add('akRight', '锁定右边');
  PropertyNames.Add('akBottom', '锁定底部');
  PropertyNames.Add('akVertCenter', '垂直中间');
  PropertyNames.Add('akHoriCenter', '水平中间');

  PropertyNames.Add('Border', '边框');
  PropertyNames.Add('Color', '颜色');
  PropertyNames.Add('Text', '内容');
  AddPropertyName('Alpha', '透明度');
  PropertyNames.Add('BorderColor', '边框颜色');

  // AddPropertyName('Color','颜色');
  PropertyNames.Add('ActiveColor', '激活字体颜色');
  // PropertyNames.Add('ActiveIndex','激活页签序号');

  PropertyNames.Add('SheetCount', '页签数量');
  PropertyNames.Add('TabDirection', '页签方向');
  PropertyNames.Add('TabImageIndex', '页签对应图片序号');
  PropertyNames.Add('TabText', '页签文字');
  PropertyNames.Add('TabTextOffsetX', '页签文字偏移X');
  PropertyNames.Add('TabTextOffsetY', '页签文字偏移Y');

  PropertyNames.Add('ItemFileType', '物品显示类型');
  PropertyNames.Add('ItemGroupType', '物品源位置');
  PropertyNames.Add('ItemIndex', '物品对应下标');

  PropertyNames.Add('ArcherFemaleIndex', '弓箭手女图');
  PropertyNames.Add('ArcherMaleIndex', '弓箭手男图');
  PropertyNames.Add('FemaleIndex', '女性底图');
  PropertyNames.Add('MaleIndex', '男性底图');

  // ===========================================
  PropertyNames.Add('GridLeftTop', '左上');
  PropertyNames.Add('GridTop', '上');
  PropertyNames.Add('GridRightTop', '右上');

  PropertyNames.Add('GridLeft', '左');
  PropertyNames.Add('GridCenter', '中');
  PropertyNames.Add('GridRight', '右');

  PropertyNames.Add('GridLeftBottom', '左下');
  PropertyNames.Add('GridBottom', '下');
  PropertyNames.Add('GridRightBottom', '右下');
  PropertyNames.Add('FillColor', '填充颜色');
  PropertyNames.Add('FillColorAlpha', '颜色透明值');

  AddValueName('cisNone', '无');
  AddValueName('cisLogin', '登录场景');
  AddValueName('cisSelChr', '选择角色');
  AddValueName('cisNotice', '游戏公告');
  AddValueName('cisPlayGame', '游戏场景');

  AddValueName('vbtChange', '切换');
  AddValueName('vbtClose', '关闭');
  AddValueName('vbtShow', '显示');

  AddValueName('ttdVert', '垂直');
  AddValueName('ttdHorv', '水平');

  AddValueName('dipStateItem', '身上');
  AddValueName('dipBagItem', '背包');

  AddValueName('igtCustomItem', '自定义物品');
  AddValueName('igtStoreItem', '仓库物品');
  AddValueName('igtUseItem', '身上物品');
  AddValueName('igtItemBag', '背包物品');

  AddValueName('csNone', '无');
  AddValueName('csStone', '石头声音');
  AddValueName('csGlass', '玻璃声音');
  AddValueName('csNorm', '点击声音');

  PropertyNames.Add('fsBold', '粗体');
  PropertyNames.Add('fsItalic', '斜体');
  PropertyNames.Add('fsUnderline', '下划线');
  PropertyNames.Add('fsStrikeOut', '删除线');

  PropertyNames.Add('DrawOtherStateInfo', '查看他人');

  PropertyNames.Add('CharYSpace', '垂直文字间距');
  PropertyNames.Add('SelectdTextColor', '选中文字颜色');
  PropertyNames.Add('TextVert', '垂直文本');

  PropertyNames.Add('TabIndexOrder', '页签激活序号');

  PropertyNames.Add('ButtonMode', '页签按钮模式');
  PropertyNames.Add('CallFunction', '调用QM函数名称');

  PropertyNames.Add('VarFlag', '关联变量');
  PropertyNames.Add('SelColor', '选中颜色');
  PropertyNames.Add('BlurColor', '失焦颜色');
  PropertyNames.Add('BlurColorAlpha', '失焦颜色透明度');

  PropertyNames.Add('FontColor', '字体颜色');
  PropertyNames.Add('TextHint', '输入提示');
  PropertyNames.Add('TextHintColor', '提示颜色');

  PropertyNames.Add('Alignment', '对齐方式');
  PropertyNames.Add('Tag', '标记');
  PropertyNames.Add('ColumnWidth', '列宽');

  PropertyNames.Add('CaptionHeight', '标题高度');
  PropertyNames.Add('LineHeight','行高');
  PropertyNames.Add('SelAlpha','选中透明度');
  PropertyNames.Add('HotAlpha','激活透明度');
  PropertyNames.Add('DrawRectLine','绘制边框线');
  PropertyNames.Add('ItemCountOfPage','每页行数');
  PropertyNames.Add('ItemTextCaption','行内容风格');
  PropertyNames.Add('ShowCaption','显示标题');
  PropertyNames.Add('RectLinePixel','边框线像素');

  PropertyNames.Add('SelectedTextColor','选中文本颜色');
  PropertyNames.Add('HotColor','激活颜色');
  PropertyNames.Add('RectLineColor','线条颜色');
  PropertyNames.Add('CharCountAPage','每页角色数量');
  PropertyNames.Add('ChrOffsetType','角色绘制偏移类型');
  PropertyNames.Add('NotSelectChrFreeze','未选中角色石化');
  PropertyNames.Add('DrawChrEffect','绘制角色特效');
  PropertyNames.Add('CreateChrActrion','创建角色动画');
  PropertyNames.Add('ChrUIOffsetType','角色框UI偏移方式');
  PropertyNames.Add('AllowDragSpot','允许拉伸位置');
  PropertyNames.add('dsNone','预留无用');
  PropertyNames.add('dsCenter','中部移动');
  PropertyNames.add('dsLeft','左边');
  PropertyNames.add('dsRight','右边');
  PropertyNames.add('dsTop','顶部');
  PropertyNames.add('dsBottom','底部');
  PropertyNames.add('dsLeftTop','左上角');
  PropertyNames.add('dsLeftBottom','左下角');
  PropertyNames.add('dsRightTop','右上角');
  PropertyNames.add('dsRightBottom','右下角');

  PropertyNames.Add('AutoAlignCenter','图像自动偏移到中间');
  PropertyNames.Add('DynamicClipValue','动态裁剪值');

  AddValueName('cofNone', '无');
  AddValueName('cofNewMir', '新热血传奇');
  AddValueName('cofMir', '热血传奇');
  AddValueName('cofMirReturn', '传奇归来');

  AddValueName('coaPosition', '根据UI位置');
  AddValueName('coaCenter', '根据屏幕中央');
  AddValueName('coaNone', '无');

  AddValueName('chaActionAlways', '一直播放动作');
  AddValueName('chaActionToNormal', '播放动作到普通');
  AddValueName('chaNormal', '普通动作');
  AddValueName('cbFillBgColor', '填充背景色');
  AddValueName('cbAlpha', '透明显示');

  PropertyNames.Add('BloodShowXOffset','血条偏移X');
  PropertyNames.Add('BloodShowYOffset','血条偏移Y');
  PropertyNames.Add('ActorNameShowXOffset','名字偏移X');
  PropertyNames.Add('ActorNameShowYOffset','名字偏移Y');

  t := ctx.GetType(TDXAniButtonPropertites);
  for p in t.GetProperties do
  begin
    Classes := GetEditorClass(p.PropertyType.Handle, PType);
    if Classes <> nil then
    begin
      cxOI.cxRegisterPropertyEditor(PType, TDXAniButtonPropertites, p.Name, Classes);
    end;
  end;


  cxRegisterPropertyEditor(TypeInfo(TClipType), TCustomDXPropertites,
    'ClipType', TDXEnumPropertyEditor);
  cxRegisterPropertyEditor(TypeInfo(TClipOrientation), TCustomDXPropertites,
    'ClipOrientation', TDXEnumPropertyEditor);
  cxRegisterPropertyEditor(TypeInfo(TClipOrientation), TCustomDXPropertites,
    'FontStyle', TDXSetsPropertyEditor);
  cxRegisterPropertyEditor(TypeInfo(TDXCaption), TCustomDXPropertites,
    'Caption', TDXClassPropertyEditor);
  cxRegisterPropertyEditor(TypeInfo(TAlignment), TCustomDXPropertites, 'Align',
    TDXEnumPropertyEditor);
  cxRegisterPropertyEditor(TypeInfo(TDAnchors), TCustomDXPropertites, 'Anchors',
    TDXSetsPropertyEditor);
  cxRegisterPropertyEditor(TypeInfo(TDXImageProperty), TCustomDXPropertites,
    'ImageProperty', TDXClassPropertyEditor);
  cxRegisterPropertyEditor(TypeInfo(TDXPosition), TCustomDXPropertites,
    'Position', TDXClassPropertyEditor);
  cxRegisterPropertyEditor(TypeInfo(TControlInScene), TCustomDXPropertites,
    'OwnerScene', TDXEnumPropertyEditor);
    cxRegisterPropertyEditor(TypeInfo(TAllowDragSpot), TCustomDXPropertites, 'AllowDragSpot',
    TDXSetsPropertyEditor);


  t := ctx.GetType(TDXCaption);
  for p in t.GetProperties do
  begin
    Classes := GetEditorClass(p.PropertyType.Handle, PType);
    if Classes <> nil then
    begin
      cxOI.cxRegisterPropertyEditor(PType, TDXCaption, p.Name, Classes);
    end;
  end;




  t := ctx.GetType(TDXAniImageProperty);
  for p in t.GetProperties do
  begin
    Classes := GetEditorClass(p.PropertyType.Handle, PType);
    if Classes <> nil then
    begin
      cxOI.cxRegisterPropertyEditor(PType, TDXAniImageProperty, p.Name,
        Classes);
    end;
  end;

  t := ctx.GetType(TDXImageProperty);
  for p in t.GetProperties do
  begin
    Classes := GetEditorClass(p.PropertyType.Handle, PType);
    if Classes <> nil then
    begin
      cxOI.cxRegisterPropertyEditor(PType, TDXImageProperty, p.Name, Classes);
    end;
  end;

  t := ctx.GetType(TDXPosition);
  for p in t.GetProperties do
  begin
    Classes := GetEditorClass(p.PropertyType.Handle, PType);
    if Classes <> nil then
    begin
      cxOI.cxRegisterPropertyEditor(PType, TDXPosition, p.Name, Classes);
    end;
  end;

  t := ctx.GetType(TStateWinProperties);
  for p in t.GetProperties do
  begin
    Classes := GetEditorClass(p.PropertyType.Handle, PType);
    if Classes <> nil then
    begin
      cxOI.cxRegisterPropertyEditor(PType, TStateWinProperties, p.Name,
        Classes);
    end;
  end;

  t := ctx.GetType(TDXTabPropertites);
  for p in t.GetProperties do
  begin
    Classes := GetEditorClass(p.PropertyType.Handle, PType);
    if Classes <> nil then
    begin
      cxOI.cxRegisterPropertyEditor(PType, TDXTabPropertites, p.Name, Classes);
    end;
  end;

  t := ctx.GetType(TDrawItemProperties);
  for p in t.GetProperties do
  begin
    Classes := GetEditorClass(p.PropertyType.Handle, PType);
    if Classes <> nil then
    begin
      cxOI.cxRegisterPropertyEditor(PType, TDrawItemProperties, p.Name,
        Classes);
    end;
  end;

  t := ctx.GetType(TDXLabelPropertites);
  for p in t.GetProperties do
  begin
    Classes := GetEditorClass(p.PropertyType.Handle, PType);
    if Classes <> nil then
    begin
      cxOI.cxRegisterPropertyEditor(PType, TDXLabelPropertites, p.Name,
        Classes);
    end;
  end;

  t := ctx.GetType(TDXScriptButtonPropertites);
  for p in t.GetProperties do
  begin
    Classes := GetEditorClass(p.PropertyType.Handle, PType);
    if Classes <> nil then
    begin
      cxOI.cxRegisterPropertyEditor(PType, TDXScriptButtonPropertites,
        p.Name, Classes);
    end;
  end;

  t := ctx.GetType(TDXEditProperties);
  for p in t.GetProperties do
  begin
    Classes := GetEditorClass(p.PropertyType.Handle, PType);
    if Classes <> nil then
    begin
      cxOI.cxRegisterPropertyEditor(PType, TDXEditProperties,
        p.Name, Classes);
    end;
  end;

  t := ctx.GetType(TDXListViewProperites);
  for p in t.GetProperties do
  begin
    Classes := GetEditorClass(p.PropertyType.Handle, PType);
    if Classes <> nil then
    begin
      cxOI.cxRegisterPropertyEditor(PType, TDXListViewProperites,
        p.Name, Classes);
    end;
  end;

  t := ctx.GetType(TDListColumn);
  for p in t.GetProperties do
  begin
    Classes := GetEditorClass(p.PropertyType.Handle, PType);
    if Classes <> nil then
    begin
      cxOI.cxRegisterPropertyEditor(PType, TDListColumn,
        p.Name, Classes);
    end;
  end;

  cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDXCaption, 'Color',
    TDXColorProperty);
  cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDXCaption, 'Border',
    TDXColorProperty);
  cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDXPanelPropertites, 'Color',
    TDXColorProperty);
  cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDXPanelPropertites,
    'BorderColor', TDXColorProperty);
  cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDXLabelPropertites,
    'SelectdTextColor', TDXColorProperty);
  cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDXPropertites, 'BorderColor',
    TDXColorProperty);
  cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDX9GirdImagePropertites,
    'FillColor', TDXColorProperty);
  cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDX9GirdImagePropertites,
    'BorderColor', TDXColorProperty);

  cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDXEditProperties,
    'BorderColor', TDXColorProperty);
  cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDXEditProperties,
'SelColor', TDXColorProperty);
      cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDXEditProperties,
    'Color', TDXColorProperty);
          cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDXEditProperties,
    'BlurColor', TDXColorProperty);

              cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDXEditProperties,
    'TextHintColor', TDXColorProperty);
   cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDXEditProperties,
    'FontColor', TDXColorProperty);
   cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDXListViewProperites,
    'SelectedTextColor', TDXColorProperty);
      cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDXListViewProperites,
    'HotColor', TDXColorProperty);
    cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDXListViewProperites,
    'SelColor', TDXColorProperty);
       cxOI.cxRegisterPropertyEditor(TypeInfo(TColor), TDXListViewProperites,
    'RectLineColor', TDXColorProperty);

     cxRegisterPropertyEditor(TypeInfo(TDXCaption), TDXListViewProperites,
    'ItemTextCaption', TDXClassPropertyEditor);


         cxRegisterPropertyEditor(TypeInfo(TJobImageInfo), TDSelChrWinProperites,
    'JobWarriorIndex', TDXSelChrJobInfo);
    cxRegisterPropertyEditor(TypeInfo(TJobImageInfo), TDSelChrWinProperites,
    'JobWizardIndex', TDXSelChrJobInfo);
    cxRegisterPropertyEditor(TypeInfo(TJobImageInfo), TDSelChrWinProperites,
    'JobTaoistIndex', TDXSelChrJobInfo);
    cxRegisterPropertyEditor(TypeInfo(TJobImageInfo), TDSelChrWinProperites,
    'JobAssassinIndex', TDXSelChrJobInfo);
    cxRegisterPropertyEditor(TypeInfo(TJobImageInfo), TDSelChrWinProperites,
    'JobArcherIndex', TDXSelChrJobInfo);
        cxRegisterPropertyEditor(TypeInfo(TJobImageInfo), TDSelChrWinProperites,
    'JobMonkInde', TDXSelChrJobInfo);

    cxRegisterPropertyEditor(TypeInfo(String), TJobImageInfo,
    'Lib', TDXPropStringPropertyEditor);
    cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'AniCount', TDXPropIntJobImage);
    cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'MaleIndex', TDXPropIntJobImage);
    cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'FemaleIndex', TDXPropIntJobImage);
    cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'AniTick', TDXPropIntJobImage);
    cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'MaleEffectIndex', TDXPropIntJobImage);
    cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'FemaleEffectIndex', TDXPropIntJobImage);
    cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'FreezeAniCount', TDXPropIntJobImage);
    cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'FreezeFrameTick', TDXPropIntJobImage);
    cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'MaleFreezeIndex', TDXPropIntJobImage);
    cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'FemalFreezeIndex', TDXPropIntJobImage);
    cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'UnFreezeAniCount', TDXPropIntJobImage);
    cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'UnFreezeFrameTick', TDXPropIntJobImage);
    cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'FemaleUnFreezeIndex', TDXPropIntJobImage);
    cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'MaleUnFreezeIndex', TDXPropIntJobImage);

        cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'MaleActionAniCount', TDXPropIntJobImage);
       cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'MaleActionFrameTick', TDXPropIntJobImage);
       cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'MaleActionIndex', TDXPropIntJobImage);
       cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'FeMaleActionAniCount', TDXPropIntJobImage);
       cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'FeMaleActionFrameTick', TDXPropIntJobImage);
       cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'FeMaleActionIndex', TDXPropIntJobImage);
       cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'MaleActionEffectIndex', TDXPropIntJobImage);
       cxRegisterPropertyEditor(TypeInfo(Integer), TJobImageInfo,
    'FemaleActionEffectIndex', TDXPropIntJobImage);



    cxRegisterPropertyEditor(TypeInfo(Integer), TDSelChrWinProperites,
    'CharCountAPage', TDXPropIntPropertyEditor);

    cxRegisterPropertyEditor(TypeInfo(Boolean), TDSelChrWinProperites,
    'NotSelectChrFreeze', TDXEnumPropertyEditor);

    cxRegisterPropertyEditor(TypeInfo(Boolean), TDSelChrWinProperites,
    'DrawChrEffect', TDXEnumPropertyEditor);

    cxRegisterPropertyEditor(TypeInfo(TChrOffsetFix), TDSelChrWinProperites,
    'ChrOffsetType', TDXEnumPropertyEditor);

                cxRegisterPropertyEditor(TypeInfo(TCreateChrAction), TDSelChrWinProperites,
    'CreateChrActrion', TDXEnumPropertyEditor);

                cxRegisterPropertyEditor(TypeInfo(TChrUIOffsetType), TDSelChrWinProperites,
    'ChrUIOffsetType', TDXEnumPropertyEditor);

                    cxRegisterPropertyEditor(TypeInfo(TDChatBoxStyle), TDChatBoxProperites,
    'ChatBoxStyle', TDXEnumPropertyEditor);

    cxRegisterPropertyEditor(TypeInfo(Integer), TClientCustomSetting,
    'BloodShowXOffset', TDXPropIntPropertyEditor);

    cxRegisterPropertyEditor(TypeInfo(Integer), TClientCustomSetting,
    'BloodShowYOffset', TDXPropIntPropertyEditor);

    cxRegisterPropertyEditor(TypeInfo(Integer), TClientCustomSetting,
    'ActorNameShowXOffset', TDXPropIntPropertyEditor);

    cxRegisterPropertyEditor(TypeInfo(Integer), TClientCustomSetting,
    'ActorNameShowYOffset', TDXPropIntPropertyEditor);


end;

{ TStringPropertyEditor }
function TDXPropStringPropertyEditor.GetName: String;
begin
  Result := GetPropertyName(GetPropInfo^.Name)
end;

{ TDXPropIntPropertyEditor }

function TDXPropIntPropertyEditor.GetName: string;
begin
  Result := GetPropertyName(GetPropInfo^.Name)
end;

function TDXPropIntPropertyEditor.GetValue: string;
var
  Value: string;
begin
  Value := inherited;
  Result := GetValueName(Value)
end;

{ TDXPropBoolPropertyEditor }

function TDXPropBoolPropertyEditor.GetName: string;
begin
  Result := GetPropertyName(GetPropInfo^.Name)
end;

function TDXPropBoolPropertyEditor.GetValue: string;
var
  Value: string;
begin
  Value := inherited;
  Result := GetValueName(Value)
end;

{ TDXEnumPropertyEditor }

function TDXEnumPropertyEditor.GetName: string;
begin
  Result := GetPropertyName(GetPropInfo^.Name)
end;

function TDXEnumPropertyEditor.GetValue: string;
var
  Name: string;
  L: LongInt;
begin
  L := GetOrdValue;
  with GetTypeData(GetPropType)^ do
  begin
    if (L < MinValue) or (L > MaxValue) then
      L := MaxValue;
    Name := TypInfo.GetEnumName(GetPropType, L);
    Result := GetValueName(Name);
  end;
end;

{ TDXSetsPropertyEditor }

function TDXSetsPropertyEditor.GetName: string;
var
  Name: string;
  L: LongInt;
begin
  Name := inherited;
  Result := GetPropertyName(Name);
end;

procedure TDXSetsPropertyEditor.GetProperties(AOwner: TComponent;
  Proc: TcxGetPropEditProc);
var
  I: Integer;
begin
  with GetTypeData(GetTypeData(GetPropType)^.CompType^)^ do
  begin
    for I := MinValue to MaxValue do
      Proc(TDXSetsElement.Create(PropList, 1 { PropCount TODO } , I));
  end;
end;

function TDXSetsPropertyEditor.GetValue: string;
var
  Name: string;
  L: LongInt;
begin
  L := GetOrdValue;
  with GetTypeData(GetPropType)^ do
  begin
    if (L < MinValue) or (L > MaxValue) then
      L := MaxValue;
    Name := TypInfo.GetSetProp(GetComponent(0), GetPropInfo);
    Result := GetValueName(Name);
  end;
end;

{ TDXClassPropertyEditor }

function TDXClassPropertyEditor.GetName: string;
begin
  Result := GetPropertyName(GetPropInfo^.Name)
end;

function TDXClassPropertyEditor.GetValue: string;
begin
  Result := '属性';
end;

{ TDXSetsElement }

function TDXSetsElement.GetName: string;
var
  S: string;
begin
  S := inherited;
  Result := GetPropertyName(S);
end;

// 增加不显示的数据
procedure AddFilterPropertyName();
begin

  FilterPropertyList.Add('Right', False);
  FilterPropertyList.Add('Bottom', False);

  // 如果有需要过滤中文的一定要把中英问的都加上否则 对应语种会无法过滤

  FilterPropertyList.Add('Left', False);
  FilterPropertyList.Add('X', False);

  FilterPropertyList.Add('Top', False);
  FilterPropertyList.Add('Y', False);

  FilterPropertyList.Add('Width', False);
  FilterPropertyList.Add('宽度', False);

  FilterPropertyList.Add('Height', False);
  FilterPropertyList.Add('高度', False);

  FilterPropertyList.Add('Lib', False);

  FilterPropertyList.Add('ImageIndex', False);
  FilterPropertyList.Add('图片序号', False);

  FilterPropertyList.Add('AniCount', False);
  FilterPropertyList.Add('动画图片数量', False);

  FilterPropertyList.Add('AniInterval', False);
  FilterPropertyList.Add('每帧间隔', False);

  FilterPropertyList.Add('DisabledIndex', False);
  FilterPropertyList.Add('禁止状态', False);

  FilterPropertyList.Add('DownedIndex', False);
  FilterPropertyList.Add('按下序号', False);

  FilterPropertyList.Add('MoveIndex', False);
  FilterPropertyList.Add('鼠标经过', False);

  FilterPropertyList.Add('AniLoop', False);
  FilterPropertyList.Add('循环播放', False);

  FilterPropertyList.Add('ActiveIndex', False);

end;

function TDXPropStringPropertyEditor.GetValue: string;
var
  Value: string;
begin
  Value := inherited;
  Result := GetValueName(Value)
end;

{ TDXColorProperty }
function TDXColorProperty.GetName: string;
var
  S: string;
begin
  S := inherited;
  Result := GetPropertyName(S);
end;

{ TDXPropFloatPropertyEditor }

function TDXPropFloatPropertyEditor.GetName: string;
var
  S: string;
begin
  S := inherited;
  Result := GetPropertyName(S);
end;


{ TDXSelChrJobInfo }

function TDXSelChrJobInfo.GetName: string;
var
  Name:string;
begin
  Name := inherited;
  if Name = 'JobWarriorIndex' then
  begin
    Result := '战士职业动画';
    Exit;
  end else if Name = 'JobWizardIndex' then
  begin
    Result := '法师职业动画';
    Exit;
  end else if Name = 'JobTaoistIndex' then
  begin
    Result := '道士职业动画';
    Exit;
  end else if Name = 'JobAssassinIndex' then
  begin
    Result := '刺客职业动画';
    Exit;
  end else if Name = 'JobArcherIndex' then
  begin
    Result := '弓箭手职业动画';
    Exit;
  end else if Name = 'JobMonkInde' then
  begin
    Result := '武僧职业动画';
    Exit;
  end;
end;

function TDXSelChrJobInfo.GetValue: string;
begin
  Result := '属性'
end;


{ TDXPropIntJobImage }

function TDXPropIntJobImage.GetName: string;
var
  Name : string;
begin
  Name := inherited;
  if Name = 'AniCount' then
  begin
    Result := '角色动画图片数量';
    Exit;
  end else if Name = 'MaleIndex' then
  begin
    Result := '男性角色序号';
    Exit;
  end else if Name = 'FemaleIndex' then
  begin
    Result := '女性角色序号';
    Exit;
  end else if Name = 'AniTick' then
  begin
    Result := '动画间隔(毫秒)';
    Exit;
  end else if Name = 'MaleEffectIndex' then
  begin
    Result := '男性角色特效序号';
    Exit;
  end else if Name = 'FemaleEffectIndex' then
  begin
    Result := '女性角色特效序号';
    Exit;
  end else if Name = 'FreezeAniCount' then
  begin
    Result := '冻结图片数量';
    Exit;
  end else if Name = 'FreezeFrameTick' then
  begin
    Result := '冻结动画间隔(毫秒)';
    Exit;
  end else if Name = 'MaleFreezeIndex' then
  begin
    Result := '男性冻结动画序号';
    Exit;
  end else if Name = 'FemalFreezeIndex' then
  begin
    Result := '女性冻结动画序号';
    Exit;
  end else if Name = 'UnFreezeAniCount' then
  begin
    Result := '解冻动画图片数量';
    Exit;
  end else if Name = 'UnFreezeFrameTick' then
  begin
    Result := '解冻动画图片间隔(毫秒)';
    Exit;
  end else if Name = 'FemaleUnFreezeIndex' then
  begin
    Result := '女性解冻图片序号';
    exit;
  end else if Name = 'MaleUnFreezeIndex' then
  begin
    Result := '男性解冻图片序号';
    Exit;
  end else if Name = 'MaleActionAniCount' then
  begin
    Result := '男性装逼动作图片数量';
    Exit;
  end else if Name = 'MaleActionFrameTick' then
  begin
    Result := '男性装逼动作图片间隔(毫秒)';
    Exit;
  end else if Name = 'MaleActionIndex' then
  begin
    Result := '男性装逼动作图片序号';
    Exit;
  end else if Name = 'FeMaleActionAniCount' then
  begin
    Result := '女性装逼动作图片数量';
    Exit;
  end else if Name = 'FeMaleActionFrameTick' then
  begin
    Result := '女性装逼动作图片间隔(毫秒)';
    Exit;
  end else if Name = 'FeMaleActionIndex' then
  begin
    Result := '女性动作装逼动作序号';
    Exit;
  end else if Name = 'MaleActionEffectIndex' then
  begin
    Result := '男性装逼动作特效序号';
    Exit;
  end else if Name = 'FemaleActionEffectIndex' then
  begin
    Result := '女性装逼动作特效序号';
  end;
end;

function TDXPropIntJobImage.GetValue: string;
begin
  Result := inherited;
end;

initialization

PropertyNames := TDictionary<String, String>.Create;
ValueNames := TDictionary<String, String>.Create;
AttrTypeInfo := TDictionary<String, PTypeInfo>.Create;
ValueNames_Search := TDictionary<String, String>.Create;
FilterPropertyList := TDictionary<String, Boolean>.Create;

InitRttiName();
AddFilterPropertyName();

finalization

PropertyNames.Free;
ValueNames.Free;
AttrTypeInfo.Free;
ValueNames_Search.Free;
FilterPropertyList.Free;

end.
