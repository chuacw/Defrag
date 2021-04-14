unit Winapi.DefragAPI;

interface
uses
  System.SysUtils, Winapi.Defrag.Types;

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
  Result := LFreeCount >= NumFree;
end;

procedure TDrive.GetClusterInfo;
var
  lpInBuffer: Pointer;
  nInBufferSize: DWORD;
  LDiskClusterInfo: DISK_CLUSTER_INFO;
  LBytesReturned: DWORD;
  lpOverlapped: POverlapped;
  nOutBufferSize: DWORD;
  LResult: Winapi.Windows.Bool;
begin
  lpInBuffer     := nil;
  nInBufferSize  := 0;
  LBytesReturned := 0;
  lpOverlapped   := nil;
  nOutBufferSize := SizeOf(LDiskClusterInfo);

//function DeviceIoControl(hDevice: THandle; dwIoControlCode: DWORD; lpInBuffer: Pointer;
//  nInBufferSize: DWORD; lpOutBuffer: Pointer; nOutBufferSize: DWORD;
//  var lpBytesReturned: DWORD; lpOverlapped: POverlapped): BOOL; stdcall;

  LResult := DeviceIoControl(FVolumeHandle, IOCTL_DISK_GET_CLUSTER_INFO,
    lpInBuffer, nInBufferSize, @LDiskClusterInfo, nOutBufferSize,
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
  lpInBuffer: Pointer;
  nInBufferSize: DWORD;
  lpOutBuffer: Pointer;
  LBytesReturned: DWORD;
  lpOverlapped: POverlapped;

begin
  lpInBuffer    := nil;
  nInBufferSize := 0;
  lpOutBuffer   := @VNTFSVolumeDataBuffer;

  LResult := DeviceIoControl(FVolumeHandle, FSCTL_GET_NTFS_VOLUME_DATA,
    lpInBuffer, nInBufferSize, lpOutBuffer, SizeOf(VNTFSVolumeDataBuffer),
    LBytesReturned, @lpOverlapped);
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
  lpVolumeSerialNumber: DWORD;
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
  BytesReturned: DWORD;
  lpOverlapped: POverlapped;
begin
//  lpInBuffer := // MOVE_FILE_DATA structure

  DeviceIoControl(FVolumeHandle,
    FSCTL_MOVE_FILE,
    lpInBuffer,
    nInBufferSize,
    lpOutBuffer,
    nOutBufferSize,
    BytesReturned,
    lpOverlapped);
end;

end.
