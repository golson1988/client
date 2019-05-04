unit CliMachineCode;

interface

uses
  Windows, SysUtils, uMD5, MSI_Disk, MSI_CPU, MSI_SMBIOS;
{.$DEFINE CheckUseTime}
function __LocalMachineCode: String;

implementation

uses Nb30;

function __LocalMachineCode: String;

  function MACAddress: string;
  type
    TAStat = packed record
      Adapt: TAdapterStatus;
      NameBuff: array [0 .. 29] of TNameBuffer;
    end;
  var
    Adapter: TAStat;
    AdapterList: TLanaEnum;
    Ncb: TNCB;
    I: Integer;
    {$IFDEF CheckUseTime}
    dwTick : Cardinal;
    {$ENDIF}
    function NetBiosSucceeded(const RetCode: AnsiChar): Boolean;
    begin
      Result := UCHAR(RetCode) = NRC_GOODRET;
    end;

  begin
    {$IFDEF CheckUseTime}
    dwTick := GetTickCount;
    {$ENDIF}
    Result := '';
    FillChar(Ncb, SizeOf(Ncb), 0);
    Ncb.ncb_command := AnsiChar(NCBENUM);
    Ncb.ncb_buffer := PAnsiChar(@AdapterList);
    Ncb.ncb_length := SizeOf(AdapterList);
    if not NetBiosSucceeded(Netbios(@Ncb)) then
      Exit;
    for I := 0 to Pred(Integer(AdapterList.length)) do
    begin
      FillChar(Ncb, SizeOf(Ncb), 0);
      Ncb.ncb_command := AnsiChar(NCBRESET);
      Ncb.ncb_lana_num := AdapterList.lana[I];
      if not NetBiosSucceeded(Netbios(@Ncb)) then
        Exit;
      FillChar(Ncb, SizeOf(Ncb), 0);
      Ncb.ncb_command := AnsiChar(NCBASTAT);
      Ncb.ncb_lana_num := AdapterList.lana[I];
      Ncb.ncb_callname := '*               ';
      Ncb.ncb_buffer := PAnsiChar(@Adapter);
      Ncb.ncb_length := SizeOf(Adapter);
      if NetBiosSucceeded(Netbios(@Ncb)) then
      begin
        with Adapter.Adapt do
          Result := Format('%.2x-%.2x-%.2x-%.2x-%.2x-%.2x', [Ord(adapter_address[0]), Ord(adapter_address[1]), Ord(adapter_address[2]), Ord(adapter_address[3]),
            Ord(adapter_address[4]), Ord(adapter_address[5])]);
        Exit;
      end;
    end;

    {$IFDEF CheckUseTime}
    Writeln('MACAddress:' + IntToStr(GetTickCount - dwTick));
    {$ENDIF}
  end;

  function GetBIOSUUID: String;
  var
    ABIOS: TMiTeC_SMBIOS;
    {$IFDEF CheckUseTime}
    dwTick : Cardinal;
    {$ENDIF}
  begin
    {$IFDEF CheckUseTime}
    dwTick := GetTickCount;
    {$ENDIF}
    ABIOS := TMiTeC_SMBIOS.Create(nil);
    try
      ABIOS.RefreshData;
      Result := ABIOS.SystemUUID;
    finally
      ABIOS.Free;
    end;
    {$IFDEF CheckUseTime}
    Writeln('GetBIOSUUID:' + IntToStr(GetTickCount - dwTick));
    {$ENDIF}
  end;

  function GetDiskSerialID: String;
  var
    ADisk: TMiTeC_Disk;
  {$IFDEF CheckUseTime}
  dwTick : Cardinal;
  {$ENDIF}
  begin
    {$IFDEF CheckUseTime}
    dwTick := GetTickCount;
    {$ENDIF}
    ADisk := TMiTeC_Disk.Create(nil);
    try
      ADisk.RefreshData;
      Result := ADisk.SerialNumber;
    finally
      ADisk.Free;
    end;
    {$IFDEF CheckUseTime}
    Writeln('GetDiskSerialID:' + IntToStr(GetTickCount - dwTick));
    {$ENDIF}
  end;

  function GetCPUSerialID: String;
  var
    ACPU: TMiTeC_CPU;
  {$IFDEF CheckUseTime}
  dwTick : Cardinal;
  {$ENDIF}
  begin
    {$IFDEF CheckUseTime}
    dwTick := GetTickCount;
    {$ENDIF}
    ACPU := TMiTeC_CPU.Create(nil);
    try
      ACPU.RefreshData;
      Result := ACPU.SerialNumber;
    finally
      ACPU.Free;
    end;
    {$IFDEF CheckUseTime}
    Writeln('GetCPUSerialID:' + IntToStr(GetTickCount - dwTick));
    {$ENDIF}
  end;

var
  MD5Str: String;
  I: Integer;
begin
  Result := '';
  MD5Str := Format('DISK:%s;BIOS:%s;CpuID:%s', [GetCPUSerialID, 'GetBIOSUUID', GetDiskSerialID]);
  MD5Str := uMD5.MD5String(MD5Str);
  for I := 1 to length(MD5Str) do
  begin
    if I mod 2 = 1 then
      Result := Result + MD5Str[I];
    if (I mod 8 = 0) and (I < length(MD5Str)) then
      Result := Result + '-';
  end;
end;

end.
