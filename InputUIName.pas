unit InputUIName;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Menus, StdCtrls, cxButtons, cxTextEdit;

type
  TfrmInputUIName = class(TForm)
    lbl1: TLabel;
    btn_Ok: TcxButton;
    btn_Cancel: TcxButton;
    CxUIName: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function  GetNewUIName(var uiName:String):Boolean;
implementation
uses
   DlgConfig;
{$R *.dfm}

function  GetNewUIName(var uiName:String):Boolean;
var
  W :TfrmInputUIName;
begin
  Result := False;
  W := TfrmInputUIName.Create(nil);
  with W  do
  begin
    if ShowModal = mrOk then
    begin
      uiName := W.cxUIName.Text;
      Result := True;
    end;
  end;
  W.Free;
end;

end.
