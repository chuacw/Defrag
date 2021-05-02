unit Winapi.DefragAPI;

interface
uses
  System.Generics.Collections, System.SysUtils, Winapi.Defrag.Types;

type
  TDrive = class
  protected
    FVolumeHandle: THandle;
    FVolumeBitmap: TBytes;
    procedure _GetNTFSVolumeData(out VNTFSVolumeDataBuffer: TNTFSVolumeDataBuffer);
  public
    constructor Create(const DriveLetter: Char);
    destructor Destroy; override;
    function FindFirstClustersFree(NumFree: UInt64;
      out VFoundStartingCluster: UInt64): Boolean;
    procedure GetClusterInfo;
    procedure GetVolumeBitmap;
    procedure GetVolumeInfo;
    function GetNTFSVolumeData: TNTFSVolumeDataBuffer;
    property VolumeBitmap: TBytes read FVolumeBitmap;
    procedure GetFileFragments(const AFileName: string);
    procedure MoveFileFragment;
  end;

  TVolumeClass = class of TVolume;
  TVolume = class
  protected
    class var FFileSystemClassTypeMap: TDictionary<string, TVolumeClass>;
    FVolumeHandle: THandle;
    FVolumeBitmap: TBytes;
    FFileSystemName: string;
    class function GetFileSystemName(const DriveChar: Char): string; static;
    constructor _Create(const DriveChar: Char); overload;
  public
    class constructor Create;
    class destructor Destroy;

    class function Create(const DriveChar: Char): TVolume; overload; static;
    destructor Destroy; override;
  end;

//  FFileSystemClassTypeMap.Add('CDFS', TCDFSVolume);
//  FFileSystemClassTypeMap.Add('EXFAT', TexFATVolume);
//  FFileSystemClassTypeMap.Add('FAT', TFATVolume);
//  FFileSystemClassTypeMap.Add('FAT32', TFAT32Volume);
//  FFileSystemClassTypeMap.Add('HPFS', THPFSVolume);
//  FFileSystemClassTypeMap.Add('NTFS', TNTFSVolume);
//  FFileSystemClassTypeMap.Add('NWFS', TNWFSVolume);
//  FFileSystemClassTypeMap.Add('UFS', TUFSVolume);

  TCDFSVolume = class(TVolume)
  public
  end;

  TexFATVolume = class(TVolume)
  public
  end;

  TFATVolume = class(TVolume)
  public
  end;

  TFAT32Volume = class(TVolume)
  public
  end;

  THPFSVolume = class(TVolume)
  public
  end;

  TNTFSVolume = class(TVolume)
  public
  end;

  TNWFSVolume = class(TVolume)
  public
  end;

  TUFSVolume = class(TVolume)
  public
  end;

implementation
uses
  Winapi.Windows, Winapi.Defrag, Winapi.Defrag.Consts;

{ TDrive }

constructor TDrive.Create(const DriveLetter: Char);
begin
  inherited Create;
  FVolumeHandle := GetVolumeHandle(DriveLetter);
end;

destructor TDrive.Destroy;
begin
  CloseHandle(FVolumeHandle);
  inherited;
end;

function TDrive.FindFirstClustersFree(NumFree: UInt64;
  // valid only when function returns True
  out VFoundStartingCluster: UInt64): Boolean;
type
  PWordArray = ^TWordArray;
  TWordArray = array[0..536870910] of UInt32;
var
  LVolumeBitmap: PWordArray;
  LHi, LFreeCount: UInt64;
begin
  LFreeCount := 0;
  LVolumeBitmap := @FVolumeBitmap[0];
  LHi := (Length(FVolumeBitmap) div 4)-1;
  try
    for var I := 0 to LHi do
      begin
        if LVolumeBitmap[I] <> $FFFFFFFF then
          begin
            LFreeCount := 0;
            Result := True;
            VFoundStartingCluster := I;
            // This might exceed the actual range allocated
            for var J := I to I+(NumFree div 4) do
              begin
                if LVolumeBitmap[J] <> 0 then
                  begin
                    Result := False;
                    Break;
                  end;
                Inc(LFreeCount, SizeOf(LVolumeBitmap[0])*8);
              end;
            if Result then
              begin
                Break;
              end;
          end;
      end;
  except
  end;
  Result := (LFreeCount >= NumFree) and (NumFree > 0);
end;

procedure TDrive.GetClusterInfo;
var
  lpInBuffer, lpOutBuffer: Pointer;
  nInBufferSize, nOutBufferSize: DWORD;
  LDiskClusterInfo: DISK_CLUSTER_INFO;
  LBytesReturned: DWORD;
  lpOverlapped: POverlapped;
  LResult: Winapi.Windows.Bool;
begin
  var LVolumeHandle := FVolumeHandle;
  lpInBuffer     := nil;
  nInBufferSize  := 0;
  LBytesReturned := 0;
  lpOverlapped   := nil;
  lpOutBuffer    := @LDiskClusterInfo;
  nOutBufferSize := SizeOf(LDiskClusterInfo);

//function DeviceIoControl(hDevice: THandle; dwIoControlCode: DWORD; lpInBuffer: Pointer;
//  nInBufferSize: DWORD; lpOutBuffer: Pointer; nOutBufferSize: DWORD;
//  var lpBytesReturned: DWORD; lpOverlapped: POverlapped): BOOL; stdcall;

  LResult := DeviceIoControl(LVolumeHandle, IOCTL_DISK_GET_CLUSTER_INFO,
    lpInBuffer, nInBufferSize, lpOutBuffer, nOutBufferSize,
    LBytesReturned, lpOverlapped);
end;

{$MESSAGE WARN 'Incomplete GetFileFragments!'}
procedure TDrive.GetFileFragments(const AFileName: string);
begin
end;

function TDrive.GetNTFSVolumeData: TNTFSVolumeDataBuffer;
begin
  _GetNTFSVolumeData(Result);
end;

procedure TDrive._GetNTFSVolumeData(out VNTFSVolumeDataBuffer: TNTFSVolumeDataBuffer);
var
  LResult: Bool;
  lpInBuffer, lpOutBuffer: Pointer;
  nInBufferSize, nOutBufferSize: DWORD;
  LBytesReturned: DWORD;
  lpOverlapped: POverlapped;

begin
  lpInBuffer     := nil;
  nInBufferSize  := 0;
  lpOutBuffer    := @VNTFSVolumeDataBuffer;
  nOutBufferSize := SizeOf(VNTFSVolumeDataBuffer);
  lpOverlapped   := nil;

  LResult := DeviceIoControl(FVolumeHandle, FSCTL_GET_NTFS_VOLUME_DATA,
    lpInBuffer, nInBufferSize, lpOutBuffer, nOutBufferSize,
    LBytesReturned, lpOverlapped);
end;

procedure TDrive.GetVolumeBitmap;
var
  LNTFSVolumeDataBuffer: TNTFSVolumeDataBuffer;
  LResult: Bool;
  lpInBuffer: Pointer;
  nInBufferSize: DWORD;
  lpOutBuffer: Pointer;
  nOutBufferSize, nBitmapLength,
  LBytesReturned: DWORD;
  lpOverlapped: POverlapped;

  LStartingLcnInputBuffer: TStartingLcnInputBuffer;
  LVolumeBitmapBuffer: PVolumeBitmapBuffer;
begin
  _GetNTFSVolumeData(LNTFSVolumeDataBuffer);
  nBitmapLength := (LNTFSVolumeDataBuffer.TotalClusters.QuadPart div 8)+1;
  nOutBufferSize := SizeOf(TVolumeBitmapBuffer) + nBitmapLength;
  GetMem(LVolumeBitmapBuffer, nOutBufferSize);
  try
    LStartingLcnInputBuffer.StartingLcn.QuadPart := 0;
    LVolumeBitmapBuffer.StartingLcn.QuadPart := LStartingLcnInputBuffer.StartingLcn.QuadPart;

    lpInBuffer     := @LStartingLcnInputBuffer;
    nInBufferSize  := SizeOf(LStartingLcnInputBuffer);
    LBytesReturned := 0;

    lpOutBuffer    := LVolumeBitmapBuffer;
    lpOverlapped   := nil;
    try
      LResult := DeviceIoControl(FVolumeHandle, FSCTL_GET_VOLUME_BITMAP,
        lpInBuffer, nInBufferSize, lpOutBuffer, nOutBufferSize,
        LBytesReturned, lpOverlapped);
      if LResult then
        begin
          SetLength(FVolumeBitmap, nBitmapLength);
          Move(LVolumeBitmapBuffer.Buffer[0], FVolumeBitmap[0], nBitmapLength);
          for var I := Low(FVolumeBitmap) to High(FVolumeBitmap) do
            if FVolumeBitmap[I] <> 255 then
              begin
                asm nop end;
                Break;
              end;
        end else
        begin
          SetLength(FVolumeBitmap, 0);
        end;
    except
      var LLastError := GetLastError;
      var LMsg := SysErrorMessage(LLastError);
      WriteLn(LMsg);
    end;
  finally
    FreeMem(LVolumeBitmapBuffer, nOutBufferSize);
  end;
end;

function GetVolumeInformationByHandle(
  AVolumeHandle: THandle; AVolumeNameBuffer:
  PChar; nVolumeNameSize: DWORD; lpVolumeSerialNumber: PDWORD; lpMaximumComponentLength: PDWORD;
  lpFileSystemFlags: PDWORD; lpFileSystemNameBuffer: PChar;
  nFileSystemNameSize: DWORD): Winapi.Windows.BOOL; overload; stdcall;
external kernel32 name 'GetVolumeInformationByHandleW';

function GetVolumeInformationByHandleW(AVolumeHandle: THandle;
  AVolumeNameBuffer: PChar; nVolumeNameSize: DWORD;
  var lpVolumeSerialNumber: DWORD; var lpMaximumComponentLength: DWORD;
  var lpFileSystemFlags: DWORD; lpFileSystemNameBuffer: PChar;
  nFileSystemNameSize: DWORD): Winapi.Windows.BOOL; overload; stdcall;
external kernel32 name 'GetVolumeInformationByHandleW';

procedure TDrive.GetVolumeInfo;
var
  LResult: Winapi.Windows.BOOL;
  LVolumeName, LFileSystemName,
  LVolumeNameBuffer, LFileSystemNameBuffer: string;
  VolumeSerialNumber: DWORD;
  MaximumComponentLength: DWORD;
  FileSystemFlags: DWORD;
begin
  SetLength(LVolumeNameBuffer, MAX_PATH+2);
  SetLength(LFileSystemNameBuffer, MAX_PATH+2);
  VolumeSerialNumber := 0;
  FileSystemFlags := 0;

  LResult := GetVolumeInformationByHandle(FVolumeHandle, PChar(LVolumeNameBuffer),
    Length(LVolumeNameBuffer)-1, @VolumeSerialNumber, @MaximumComponentLength,
    @FileSystemFlags, PChar(LFileSystemNameBuffer), Length(LFileSystemNameBuffer)-1);

  LVolumeName := PChar(LVolumeNameBuffer);
  // this would return NTFS, exFAT, FAT, UFS, etc...
  LFileSystemName := PChar(LFileSystemNameBuffer);
end;

{$MESSAGE WARN 'Incomplete MoveFileFragment!'}
procedure TDrive.MoveFileFragment;
var
  lpInBuffer: Pointer;
  nInBufferSize: DWORD;
  lpOutBuffer: Pointer;
  nOutBufferSize: DWORD;
  LBytesReturned: DWORD;
  lpOverlapped: POverlapped;
begin
//  lpInBuffer := // MOVE_FILE_DATA structure
  var LVolumeHandle := FVolumeHandle;
  LBytesReturned := 0;
  lpOverlapped := nil;

  DeviceIoControl(LVolumeHandle,
    FSCTL_MOVE_FILE,
    lpInBuffer,
    nInBufferSize,
    lpOutBuffer,
    nOutBufferSize,
    LBytesReturned,
    lpOverlapped);
end;

{ TVolume }

class function TVolume.Create(const DriveChar: Char): TVolume;
var
  LFileSystemName: string;
  LClass: TVolumeClass;
begin
  Result := nil;
  LFileSystemName := GetFileSystemName(DriveChar);
  if FFileSystemClassTypeMap.TryGetValue(LFileSystemName, LClass) then
    begin
      Result := LClass._Create(DriveChar);
      Result.FFileSystemName := LFileSystemName;
    end;
end;

destructor TVolume.Destroy;
begin
  CloseHandle(FVolumeHandle);
  inherited;
end;

class constructor TVolume.Create;
begin
  FFileSystemClassTypeMap := TDictionary<string, TVolumeClass>.Create;
  FFileSystemClassTypeMap.Add('CDFS', TCDFSVolume);
  FFileSystemClassTypeMap.Add('EXFAT', TexFATVolume);
  FFileSystemClassTypeMap.Add('FAT', TFATVolume);
  FFileSystemClassTypeMap.Add('FAT32', TFAT32Volume);
  FFileSystemClassTypeMap.Add('HPFS', THPFSVolume);
  FFileSystemClassTypeMap.Add('NTFS', TNTFSVolume);
  FFileSystemClassTypeMap.Add('NWFS', TNWFSVolume);
  FFileSystemClassTypeMap.Add('UFS', TUFSVolume);
end;

class destructor TVolume.Destroy;
begin
  FFileSystemClassTypeMap.Free;
end;

constructor TVolume._Create(const DriveChar: Char);
begin
  inherited Create;
  FVolumeHandle := GetVolumeHandle(DriveChar);
end;

class function TVolume.GetFileSystemName(const DriveChar: Char): string;
var
  LResult: Winapi.Windows.BOOL;
  LVolumeNameBuffer, LFileSystemNameBuffer: string;
  LVolumeNameBufferLen, LFileSystemNameBufferLen,
  VolumeSerialNumber: DWORD;
  MaximumComponentLength: DWORD;
  FileSystemFlags: DWORD;

  LVolumeHandle: THandle;
  lpInBuffer: PChar;
begin
  LVolumeHandle := GetVolumeHandle(DriveChar);
  try
    SetLength(LVolumeNameBuffer, MAX_PATH+2);
    SetLength(LFileSystemNameBuffer, MAX_PATH+2);
    VolumeSerialNumber := 0;
    FileSystemFlags := 0;
    LVolumeNameBufferLen := Length(LVolumeNameBuffer)-1;
    LFileSystemNameBufferLen := Length(LFileSystemNameBuffer)-1;

    lpInBuffer := PChar(LFileSystemNameBuffer);

    LResult := GetVolumeInformationByHandle(LVolumeHandle, PChar(LVolumeNameBuffer),
      LVolumeNameBufferLen, @VolumeSerialNumber, @MaximumComponentLength,
      @FileSystemFlags, lpInBuffer, LFileSystemNameBufferLen);

    SetLength(LFileSystemNameBuffer, StrLen(lpInBuffer));

    // this would return NTFS, exFAT, FAT, UFS, etc...
    Result := UpperCase(LFileSystemNameBuffer);
  finally
    CloseHandle(LVolumeHandle);
  end;
end;

end.
