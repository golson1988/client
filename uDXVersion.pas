unit uDXVersion;

interface

function GetDXVersion: Byte;

implementation

uses Windows, SysUtils, Classes, Registry;

type
  TIsWow64Process =  function(Handle: THandle; var Res: BOOL): BOOL; stdcall;
var
  IsWow64: BOOL;

function OpenRegistryReadOnly: TRegistry;
var
  KeyAccess: Cardinal;
begin
  KeyAccess := KEY_READ;
  if IsWow64 then
    KeyAccess := KeyAccess or KEY_WOW64_64KEY;
  Result := TRegistry.Create(KeyAccess);
end;

function GetDXVersion: Byte;
var
  bdata: PChar;
  k: Integer;
  X64: Integer;
  Reg: TRegistry;
  AVer: String;
const
  rkDirectX = { HKEY_LOCAL_MACHINE } '\SOFTWARE\Microsoft\DirectX';
  rvDXVersionNT = 'InstalledVersion';
  rvDXVersion95 = 'Version';
begin
  Result := 7;

  if IsWow64 then
    X64 := 1
  else
    X64 := 0;

  AVer := '';
  for k := 0 to X64 do
  begin
    if k = 0 then
      Reg := TRegistry.Create
    else
      Reg := OpenRegistryReadOnly;
    with Reg do
    begin
      rootkey := HKEY_LOCAL_MACHINE;
      if OpenKey(rkDirectX, False) then
      begin
        bdata := stralloc(255);
        if ValueExists(rvDXVersion95) then
          AVer := ReadString(rvDXVersion95);
        if AVer = '' then
          if ValueExists(rvDXVersionNT) then
            try
              readbinarydata(rvDXVersionNT, bdata^, 4);
              AVer := inttostr(lo(Integer(bdata^))) + '.' + inttostr(hi(Integer(bdata^)));
            except
              try
                readbinarydata(rvDXVersionNT, bdata^, 8);
                AVer := inttostr(lo(Integer(bdata^))) + '.' + inttostr(hi(Integer(bdata^)));
              except
              end;
            end;
        closekey;
        strdispose(bdata);
      end;
      free;
    end;
  end;
  if AVer <> '' then
  begin
    if Pos('4.09.00.', AVer) > 0 then
      //Result := 9;
  end;
end;

procedure CheckWinVer;
var
  Kernel32Handle: THandle;
  IsWOW64Process: TIsWow64Process;
begin
  Kernel32Handle := GetModuleHandle(PChar('KERNEL32.DLL'));
  IsWOW64Process := GetProcAddress(Kernel32Handle, PChar('IsWow64Process'));
  if Assigned(IsWOW64Process) then
    IsWOW64Process(GetCurrentProcess, IsWow64);
end;

//initialization
//  CheckWinVer;
//
end.

