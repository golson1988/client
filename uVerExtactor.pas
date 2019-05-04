unit uVerExtactor;

interface
  uses SysUtils, IntroScn,DWinCtl;

function _ExtractClientVer(ADefault: TSceneKind): TSceneKind;

implementation

function File_Size(const AFileName:String):Int64;
var
  AHandle: THandle;
begin
  AHandle := FileOpen(AFileName, fmOpenRead + fmShareDenyNone);
  if AHandle = INVALID_HANDLE_VALUE then
    Result:=-1
  else
  begin
    Result := FileSeek(AHandle, Int64(0), 2);
    FileClose(AHandle);
  end;
end;


function _ExtractClientVer(ADefault: TSceneKind): TSceneKind;
begin
  Result := ADefault;
  if FileExists('mir3.dat') then
    Result := skReturn
  else if FileExists('data\ui_n.wzl') and (File_Size('data\ui_n.wzl') > 64) and FileExists('mir4.dat') then
    Result := skMir4
  else
    Result := skNormal;
end;

end.
