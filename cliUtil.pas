unit cliUtil;

interface

uses
  Classes, AbstractCanvas, AbstractTextures, AsphyreTypes, DXHelper, Graphics;
CONST
  ALPHAVALUE = 150;
type
  TColorEffect = (ceNone, ceGrayScale, ceBright, ceBlack, ceWhite, ceRed, ceGreen, ceBlue, ceYellow, ceFuchsia);

procedure MakeDark(ACanavas: TAsphyreCanvas; DarkLevel: integer); inline;
procedure DrawEffect(X, Y: Integer; ACanavas: TAsphyreCanvas; ATexture: TAsphyreLockableTexture; AColorEff: TColorEffect; ATransparent: Boolean); inline;

implementation

procedure MakeDark(ACanavas: TAsphyreCanvas; DarkLevel: integer);
begin
  if darklevel in [1 .. 30] then
    ACanavas.FillRectAlpha(ACanavas.ClipRect, 0, round((30-darklevel)*255/30));
end;

procedure DrawEffect(X, Y: Integer; ACanavas: TAsphyreCanvas; ATexture: TAsphyreLockableTexture; AColorEff: TColorEffect; ATransparent: Boolean);
begin
  if ATexture = nil then Exit;

  if not ATransparent then
  begin
    case AColorEff of
      ceNone: ACanavas.Draw(X, Y, ATexture, True);
      ceGrayScale: ACanavas.Draw(X, Y, ATexture, beGrayscale);
      //ceBright: ACanavas.Draw(X, Y, ATexture);
      ceBright: ACanavas.Draw(X, Y, ATexture.ClientRect, ATexture, cColor4(cRGB1(180, 180, 180, 255)), beBright);
      ceBlack: ACanavas.DrawColor(X, Y, ATexture, clBlack, True);
      ceWhite: ACanavas.DrawColor(X, Y, ATexture, clWhite, True);
      ceRed: ACanavas.DrawColor(X, Y, ATexture, clRed, True);
      ceGreen: ACanavas.DrawColor(X, Y, ATexture, clGreen, True);
      ceBlue: ACanavas.DrawColor(X, Y, ATexture, clBlue, True);
      ceYellow: ACanavas.DrawColor(X, Y, ATexture, clYellow, True);
      ceFuchsia: ACanavas.DrawColor(X, Y, ATexture, clFuchsia, True);
    end;
  end
  else
  begin
    case AColorEff of
      ceNone: ACanavas.DrawAlpha(X, Y, ATexture, ALPHAVALUE);
      ceGrayScale: ACanavas.DrawAlpha(X, Y, ATexture.ClientRect, ATexture, ALPHAVALUE, beGrayscale);
      //ceBright: ACanavas.Draw(X, Y, ATexture.ClientRect, ATexture, cColor4(cRGB1(150, 150, 150, 128)), beAdd);
      ceBright: ACanavas.Draw(X, Y, ATexture.ClientRect, ATexture, cColor4(cRGB1(ALPHAVALUE, ALPHAVALUE, ALPHAVALUE, 128{255})), beBright);
      ceBlack: ACanavas.DrawColorAlpha(X, Y, ATexture, clBlack, True, ALPHAVALUE);
      ceWhite: ACanavas.DrawColorAlpha(X, Y, ATexture, clWhite, True, ALPHAVALUE);
      ceRed: ACanavas.DrawColorAlpha(X, Y, ATexture, clRed, True, ALPHAVALUE);
      ceGreen: ACanavas.DrawColorAlpha(X, Y, ATexture, clGreen, True, ALPHAVALUE);
      ceBlue: ACanavas.DrawColorAlpha(X, Y, ATexture, clBlue, True, ALPHAVALUE);
      ceYellow: ACanavas.DrawColorAlpha(X, Y, ATexture, clYellow, True, ALPHAVALUE);
      ceFuchsia: ACanavas.DrawColorAlpha(X, Y, ATexture, clFuchsia, True, ALPHAVALUE);
    end;
  end;
end;

end.
