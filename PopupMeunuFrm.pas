unit PopupMeunuFrm;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Generics.Collections,
  StdCtrls, Grids, Grobal2, clFunc, hUtil32, cliUtil, EDcode, soundUtil, Actor,
  DWinCtl, DXHelper, uUITypes, uCliUITypes, uTypes, Common, uMapDesc, uMessageParse,
  AbstractCanvas, AbstractTextures, AsphyreFactory, AsphyreTypes, uEDcode, uTextures,
  Clipbrd, ExtCtrls, Math, Menus;

type
  TOnDXPopupItemClick = reference to procedure(Tag: Integer; const Caption: String);
  TDXPopupMenu = class(TForm)
    DXPopupMenu: TDButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DXPopupMenuDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DXPopupMenuMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DXPopupMenuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FItems: TStringList;
    FGutterWidth,
    FItemHeight,
    FPMenuIdx: Integer;
    FParent: TDControl;
    FPopupItemClick: TOnDXPopupItemClick;
    FPopVisible: Boolean;
    procedure SetItems(const Value: TStringList);
    procedure DoItemsChange(Sender: TObject);
    procedure RebuildPopupmenu;
  public
    procedure Initialize;
    procedure Popup(AParent: TDControl; X, Y: Integer; MinWidth: Integer=0; AEvent: TOnDXPopupItemClick=nil);
    procedure HidePopup;
    procedure BeginUpdate;
    procedure Clear;
    procedure AddMenuItem(ATag: Integer; const ACaption: String);
    procedure EndUpdate;
    property PopVisible: Boolean read FPopVisible;
  end;

var
  DXPopupMenu: TDXPopupMenu;

implementation
  uses AsphyreTextureFonts, MShare;

{$R *.dfm}

type
  TMenuItem = class
    Tag: Integer;
  end;

{ TDXPopupMenu }

procedure TDXPopupMenu.DoItemsChange(Sender: TObject);
begin
  RebuildPopupmenu;
end;

procedure TDXPopupMenu.DXPopupMenuDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  d: TAsphyreLockableTexture;
  nW, nH, I, ATag: Integer;
  Width, Height: Integer;
  ATexture: TAsphyreLockableTexture;
  AMenuText: String;
begin
  with DXPopupMenu do
  begin
    //绘制背景

    dsurface.FillRectAlpha(Bounds(SurfaceX(Left), SurfaceY(Top), Width, Height), clWhite, 175);
    dsurface.FillQuad(pBounds4(SurfaceX(Left), SurfaceY(Top), FGutterWidth, Height), cColor4(cColor1(clBtnface), cColor1(clWhite), cColor1(clWhite), cColor1(clBtnface)), beNormal);
    dsurface.VertLine(SurfaceX(Left) + FGutterWidth + 1, SurfaceY(Top), Height, cColor1(clBtnface));
    dsurface.FrameRect(pBounds4(SurfaceX(Left), SurfaceY(Top), Width, Height), cColor4(cColor1(clBtnface)));

    //绘制菜单项
    for I := 0 to FItems.Count - 1 do
    begin
      AMenuText :=  FItems.Strings[I];
      ATexture  :=  FontManager.Default.TextOut(AMenuText);
      if ATexture <> nil then
      begin
        if I = FPMenuIdx then
        begin
          dsurface.FillRectAlpha(Bounds(SurfaceX(Left) + FGutterWidth + 2, SurfaceY(Top) + 4 + I * FItemHeight, Width - FGutterWidth - 2, FItemHeight), clBlack, 175);
          dsurface.DrawBoldText(SurfaceX(Left) + FGutterWidth + 4, SurfaceY(Top) + 4 + I * FItemHeight + (FItemHeight - ATexture.Height) div 2+1, ATexture, clYellow, FontBorderColor);
        end
        else
          dsurface.DrawBoldText(SurfaceX(Left) + FGutterWidth + 4, SurfaceY(Top) + 4 + I * FItemHeight + (FItemHeight - ATexture.Height) div 2+1, ATexture, clBlack, clWhite);
      end;
    end;

   // dsurface.TextOut(SurfaceX(Left),SurfaceY(Top),Self.Name,clRed);
  end;
end;

procedure TDXPopupMenu.DXPopupMenuMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FPMenuIdx>=0) and (FPMenuIdx<=FItems.Count - 1) then
  begin
    DXPopupMenu.Visible :=  False;
    FPopVisible :=  False;
    g_SoundManager.DXPlaySound(s_norm_button_click);
    if Assigned(FPopupItemClick) then
      FPopupItemClick(TMenuItem(FItems.Objects[FPMenuIdx]).Tag, FItems[FPMenuIdx]);
  end;
end;

procedure TDXPopupMenu.DXPopupMenuMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  FPMenuIdx :=  -1;
  if X > DXPopupMenu.Left + FGutterWidth then
    FPMenuIdx :=  (Y - DXPopupMenu.Top - 4) div FItemHeight;
end;

procedure TDXPopupMenu.FormCreate(Sender: TObject);
begin
  FItems  :=  TStringList.Create;
  FItems.OwnsObjects  :=  True;
  FItems.OnChange :=  DoItemsChange;
  FGutterWidth  :=  16;
  FParent :=  nil;
end;

procedure TDXPopupMenu.FormDestroy(Sender: TObject);
begin
  Clear;
  FreeAndNilEx(FItems);
end;

procedure TDXPopupMenu.HidePopup;
begin
//  if FPopVisible then
//  begin
    if FParent <> nil then
    begin
      FParent.DControls.Remove(DXPopupMenu);
      FParent :=  nil;
    end;
    DXPopupMenu.Visible :=  False;
    FPopVisible :=  False;
//  end;
end;

procedure TDXPopupMenu.BeginUpdate;
begin
  FItems.BeginUpdate;
end;

procedure TDXPopupMenu.Clear;
begin
  FItems.Clear;
end;

procedure TDXPopupMenu.AddMenuItem(ATag: Integer; const ACaption: String);
var
  AMenuItem: TMenuItem;
begin
  AMenuItem :=  TMenuItem.Create;
  AMenuItem.Tag :=  ATag;
  FItems.AddObject(ACaption, AMenuItem);
end;

procedure TDXPopupMenu.EndUpdate;
begin
  FItems.EndUpdate;
end;

procedure TDXPopupMenu.Initialize;
begin
end;

procedure TDXPopupMenu.Popup(AParent: TDControl; X, Y, MinWidth: Integer; AEvent: TOnDXPopupItemClick);
begin
  if FParent <> nil then
    FParent.DControls.Remove(DXPopupMenu);
  if FItems.Count > 0 then
  begin
    FParent :=  AParent;
    FPopupItemClick :=  AEvent;
    FParent.DControls.Add(DXPopupMenu);
    DXPopupMenu.DParent :=  AParent;
    DXPopupMenu.Left  :=  X;
    DXPopupMenu.Top   :=  Y;
    if (DXPopupMenu.Width < MinWidth) and (MinWidth > 0) then
      DXPopupMenu.Width :=  MinWidth;
    DXPopupMenu.Visible :=  True;
    FPopVisible :=  True;
  end;
end;

procedure TDXPopupMenu.RebuildPopupmenu;
var
  I, MaxW, MaxLineH: Integer;
  ASize: TSize;
begin
  DXPopupMenu.Visible :=  False;
  MaxW  :=  0;
  MaxLineH  :=  0;
  for I := 0 to FItems.Count - 1 do
  begin
    ASize :=  Canvas.TextExtent(FItems.Strings[I]);
    MaxLineH    :=  Max(MaxLineH, ASize.cy);
    MaxW  :=  Max(MaxW, ASize.cx);
  end;
  DXPopupMenu.Width :=  MaxW + FGutterWidth + 10;
  DXPopupMenu.Height:=  (MaxLineH + 2) * FItems.Count + 8;
  FItemHeight :=  MaxLineH + 2;
end;

procedure TDXPopupMenu.SetItems(const Value: TStringList);
begin
  FItems.Assign(Value);
  RebuildPopupmenu;
end;

end.
