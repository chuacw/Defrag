unit Winapi.Defrag;

interface

function GetVolumeHandle(const Drive: Char): THandle;
function CloseHandle(AHandle: THandle): Boolean;
function GetPhysicalDriveIdentifier(const Drive: Char): string;

implementation
uses
  Winapi.Windows, System.SysUtils, Winapi.Defrag.Consts;

function CloseHandle(AHandle: THandle): Boolean;
begin
  Result := Winapi.Windows.CloseHandle(AHandle);
end;

// See https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea
function GetPhysicalDriveIdentifier(const Drive: Char): string;
begin
//  DeviceIoControl()
end;

// See https://docs.microsoft.com/en-us/windows/win32/devio/calling-deviceiocontrol
function GetVolumeHandle(const Drive: Char): THandle;
var
  LFilename: string;
  LFileAttr: DWORD;
  LDesiredAccess: DWORD;
  LShareMode: DWORD;
  LSecurityAttr: PSecurityAttributes;
  LTemplateFile: THandle;
begin
  LFilename := Format('\\.\%s:', [Drive]);
//  LFilename := '\\.\PhysicalDrive0'; // works also but need to map drive letter to PhysicalDriveX format
  LFileAttr := 0;
  LDesiredAccess := GENERIC_READ or GENERIC_WRITE;
  LShareMode := FILE_SHARE_READ or FILE_SHARE_WRITE;
  LSecurityAttr := nil;
  LTemplateFile := 0;
  Result := CreateFile(PChar(LFileName), LDesiredAccess, LShareMode, LSecurityAttr,
    OPEN_EXISTING, LFileAttr, LTemplateFile);
end;

end.
