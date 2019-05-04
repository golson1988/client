unit NewItemDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DWinCtl, AbstractCanvas, AbstractTextures, DXHelper, Grobal2, uTypes;

type
  TfrmNewItem = class(TForm)
    DJewelryBox: TDWindow;
    DZodiacSigns: TDWindow;
    DJBClose: TDButton;
    DZodiacClose: TDButton;
    DJeweBoxItem1: TDButton;
    DJeweBoxItem2: TDButton;
    DJeweBoxItem3: TDButton;
    DJeweBoxItem5: TDButton;
    DJeweBoxItem4: TDButton;
    DJeweBoxItem6: TDButton;
    DZodiacItem1: TDButton;
    DZodiacItem2: TDButton;
    DZodiacItem3: TDButton;
    DZodiacItem4: TDButton;
    DZodiacItem5: TDButton;
    DZodiacItem6: TDButton;
    DZodiacItem7: TDButton;
    DZodiacItem8: TDButton;
    DZodiacItem12: TDButton;
    DZodiacItem10: TDButton;
    DZodiacItem11: TDButton;
    DZodiacItem9: TDButton;
    procedure DJBCloseClick(Sender: TObject; X, Y: Integer);
    procedure DZodiacCloseClick(Sender: TObject; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Initialize;
    procedure CloseAllDlg();
  end;

var
  frmNewItem: TfrmNewItem;

implementation

uses FState, MShare, SoundUtil, ClMain, DrawScrn;
{$R *.dfm}


procedure TfrmNewItem.CloseAllDlg;
begin
  DJewelryBox.Visible := False;
  DZodiacSigns.Visible := False;
end;

procedure TfrmNewItem.DJBCloseClick(Sender: TObject; X, Y: Integer);
begin
  DJewelryBox.Visible := False;
end;

procedure TfrmNewItem.DZodiacCloseClick(Sender: TObject; X, Y: Integer);
begin
  DZodiacSigns.Visible := False;
end;

procedure TfrmNewItem.Initialize;
var
  i : Integer;
begin
  FrmDlg.DBackground.AddSub(DJewelryBox);
  FrmDlg.DBackground.AddSub(DZodiacSigns);

  DZodiacSigns.SetImgIndex(g_77Images, 72);
  DJewelryBox.SetImgIndex(g_77Images, 71);

  DZodiacSigns.Left := 30;
  DZodiacSigns.Top := 160;

  DJewelryBox.Left := 70;
  DJewelryBox.Top := 210;

  DJBClose.SetImgIndex(g_77Images, 52);
  DJBClose.Propertites.DownedIndex := 53;
  DJBClose.Left := DJewelryBox.Width - DJBClose.Width - 14;
  DJBClose.Top := 16;

  DZodiacClose.SetImgIndex(g_77Images, 52);
  DZodiacClose.Propertites.DownedIndex := 53;
  DZodiacClose.Left := DZodiacSigns.Width - DZodiacClose.Width - 14;
  DZodiacClose.Top := 12;

  // 十二生肖Tag
  DZodiacItem1.Tag := U_ZODIAC1;
  DZodiacItem2.Tag := U_ZODIAC2;
  DZodiacItem3.Tag := U_ZODIAC3;
  DZodiacItem4.Tag := U_ZODIAC4;
  DZodiacItem5.Tag := U_ZODIAC5;
  DZodiacItem6.Tag := U_ZODIAC6;
  DZodiacItem7.Tag := U_ZODIAC7;
  DZodiacItem8.Tag := U_ZODIAC8;
  DZodiacItem9.Tag := U_ZODIAC9;
  DZodiacItem10.Tag := U_ZODIAC10;
  DZodiacItem11.Tag := U_ZODIAC11;
  DZodiacItem12.Tag := U_ZODIAC12;

  // 首饰盒Tag
  DJeweBoxItem1.Tag := U_JEWELRYITEM1;
  DJeweBoxItem2.Tag := U_JEWELRYITEM2;
  DJeweBoxItem3.Tag := U_JEWELRYITEM3;
  DJeweBoxItem4.Tag := U_JEWELRYITEM4;
  DJeweBoxItem5.Tag := U_JEWELRYITEM5;
  DJeweBoxItem6.Tag := U_JEWELRYITEM6;

  //绑定绘制 和mousemove 等事件
  for i := 0 to Self.ComponentCount - 1 do
  begin
    if Self.Components[i] is TDButton then
    begin
      if TDButton(Self.Components[i]).Tag <> 0 then
      begin
        TDButton(Self.Components[i]).OnMouseMove := FrmDlg.DSWWeaponMouseMove;
        TDButton(Self.Components[i]).OnClick := FrmDlg.DSWWeaponClick;
        TDButton(Self.Components[i]).OnDirectPaint := FrmDlg.DSWLightDirectPaint;
        TDButton(Self.Components[i]).Width := 36;
        TDButton(Self.Components[i]).Height := 32;
      end;
    end;
  end;

  //首饰盒位置  和 十二生肖位置
  DJeweBoxItem1.Top := 79; DJeweBoxItem1.Left := 42;
  DJeweBoxItem2.Top := 79; DJeweBoxItem2.Left := 86;
  DJeweBoxItem3.Top := 79; DJeweBoxItem3.Left := 130;
  DJeweBoxItem4.Top := 116; DJeweBoxItem4.Left := 42;
  DJeweBoxItem5.Top := 116; DJeweBoxItem5.Left := 86;
  DJeweBoxItem6.Top := 116; DJeweBoxItem6.Left := 130;

  DZodiacItem1.Top := 48; DZodiacItem1.Left := 41;
  DZodiacItem2.Top := 48; DZodiacItem2.Left := 89;
  DZodiacItem3.Top := 48; DZodiacItem3.Left := 137;
  DZodiacItem4.Top := 48; DZodiacItem4.Left := 186;

  DZodiacItem5.Top := 97; DZodiacItem5.Left := 41;
  DZodiacItem6.Top := 97; DZodiacItem6.Left := 89;
  DZodiacItem7.Top := 97; DZodiacItem7.Left := 137;
  DZodiacItem8.Top := 97; DZodiacItem8.Left := 186;

  DZodiacItem9.Top := 144; DZodiacItem9.Left := 41;
  DZodiacItem10.Top := 144; DZodiacItem10.Left := 89;
  DZodiacItem11.Top := 144; DZodiacItem11.Left := 137;
  DZodiacItem12.Top := 144; DZodiacItem12.Left := 186;

end;

end.
