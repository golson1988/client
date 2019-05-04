unit uDXGrayFilter;

interface

// ---------------------------------------------------------------------------
uses
  Types, Classes, SysUtils, DXBase, AbstractTextures, AsphyreDef,
  AsphyreTypes, DX9Types, Vectors2, AsphyreD3D9;

// ---------------------------------------------------------------------------
type
  TGrayFilter = class
  private
    VertexBuf: Pointer;
    FAntialias: Boolean;

    procedure PrepareVertexBuf();
    procedure SetupAntialias();
    procedure PrepareStates();
    procedure SetCoords(const Points: TPoint4);
    procedure SetupImage(Image: TAsphyreLockableTexture);
    procedure ApplyFilter();
  public
    property Antialias: Boolean read FAntialias write FAntialias;

    procedure Filter(Source: TAsphyreLockableTexture; const Points: TPoint4);

    constructor Create();
    destructor Destroy(); override;
  end;

  // ---------------------------------------------------------------------------
implementation

// ----------------------------------------------------------------------------
const
  VertexType = D3DFVF_XYZRHW or D3DFVF_TEX1;
  WrapIndex: array [0 .. 3] of Integer = (0, 1, 3, 2);

  // --------------------------------------------------------------------------
type
  PVertexRecord = ^TVertexRecord;

  TVertexRecord = record
    Vector: TD3DVector;
    rhw: Single;
    TexPt: TPoint2;
  end;

  // ---------------------------------------------------------------------------
constructor TGrayFilter.Create();
begin
  inherited;

  VertexBuf := AllocMem(SizeOf(TVertexRecord) * 4);
  PrepareVertexBuf();

  FAntialias := True;
end;

// ---------------------------------------------------------------------------
destructor TGrayFilter.Destroy();
begin
  FreeMem(VertexBuf);

  inherited;
end;

// ---------------------------------------------------------------------------
procedure TGrayFilter.PrepareVertexBuf();
var
  Vertex: PVertexRecord;
  i: Integer;
begin
  Vertex := VertexBuf;

  for i := 0 to 3 do
  begin
    Vertex.rhw := 1.0;
    Vertex.Vector.z := 0.0;
    Inc(Vertex);
  end;
end;

// ---------------------------------------------------------------------------
procedure TGrayFilter.SetupImage(Image: TAsphyreLockableTexture);
var
  TexNum: Integer;
  TexPts: TPoint4;
  Vertex: PVertexRecord;
  u0, v0, u1, v1: Real;
  i: Integer;
begin
  TexPts[0] := Point2(0.0, 0.0);
  TexPts[1] := Point2(1.0, 0.0);
  TexPts[2] := Point2(1.0, 1.0);
  TexPts[3] := Point2(0.0, 1.0);

  Vertex := VertexBuf;
  for i := 0 to 3 do
  begin
    Vertex.TexPt.x := TexPts[WrapIndex[i]].x;
    Vertex.TexPt.y := TexPts[WrapIndex[i]].y;
    Inc(Vertex);
  end;
end;

// ---------------------------------------------------------------------------
procedure TGrayFilter.SetupAntialias();
begin
  if (FAntialias) then
  begin
    D3D9Device.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
    D3D9Device.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
  end
  else
  begin
    D3D9Device.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_POINT);
    D3D9Device.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_POINT);
  end;
end;

// ---------------------------------------------------------------------------
procedure TGrayFilter.PrepareStates();
{ var
  color: TD3DCOLOR; }
begin
  with D3D9Device do
  begin
    SetRenderState(D3DRS_ALPHABLENDENABLE, iFalse);
    SetRenderState(D3DRS_ALPHATESTENABLE, iFalse);

    SetRenderState(D3DRS_TEXTUREFACTOR, $FFFFFFFF);

    SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
    SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_TFACTOR);
    SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
    SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_TFACTOR);

    SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_DOTPRODUCT3);
    SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_ADD);

    SetTextureStageState(1, D3DTSS_COLORARG1, D3DTA_CURRENT);
    SetTextureStageState(1, D3DTSS_COLORARG2, D3DTA_CURRENT);
    SetTextureStageState(1, D3DTSS_ALPHAARG1, D3DTA_CURRENT);
    SetTextureStageState(1, D3DTSS_ALPHAARG2, D3DTA_CURRENT);
    SetTexture(1, nil);
  end;
end;

// ---------------------------------------------------------------------------
procedure TGrayFilter.SetCoords(const Points: TPoint4);
var
  Vertex: PVertexRecord;
  i: Integer;
begin
  Vertex := VertexBuf;

  for i := 0 to 3 do
  begin
    Vertex.Vector.x := Points[WrapIndex[i]].x - 0.5;
    Vertex.Vector.y := Points[WrapIndex[i]].y - 0.5;
    Inc(Vertex);
  end;
end;

// ---------------------------------------------------------------------------
procedure TGrayFilter.ApplyFilter();
begin
  with D3D9Device do
  begin
    SetVertexShader(nil);
    SetFVF(VertexType);
    DrawPrimitiveUP(D3DPT_TRIANGLESTRIP, 2, VertexBuf^, SizeOf(TVertexRecord));
  end;
end;

// ---------------------------------------------------------------------------
procedure TGrayFilter.Filter(Source: TAsphyreLockableTexture; const Points: TPoint4);
begin
  if (D3D9Device = nil) then
    Exit;

  SetupAntialias();
  PrepareStates();
  SetCoords(Points);
  SetupImage(Source);
  ApplyFilter();
end;

// ---------------------------------------------------------------------------
end.
