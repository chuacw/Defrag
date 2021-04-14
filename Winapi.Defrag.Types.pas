unit Winapi.Defrag.Types;

interface
uses
  Winapi.Windows;

type
  MOVE_FILE_DATA = record
    FileHandle: THandle;
    StartingVcn: LARGE_INTEGER;
    StartingLcn: LARGE_INTEGER;
    ClusterCount: Winapi.Windows.DWORD;
  end;
  PMOVE_FILE_Data = ^MOVE_FILE_DATA;
  TMoveFileData = MOVE_FILE_DATA;
  PMoveFileData = ^TMoveFileData;

  MARK_HANDLE_INFO = record
  type
    TDummyUnionName = record
      MappedValue1: DWORD;
      property UsnSourceInfo: DWORD read MappedValue1;
      property CopyNumber: DWORD read MappedValue1;
    end;
  var
    DummyUnionName: TDummyUnionName;
    UsnSourceInfo: DWORD;
    VolumeHandle: THandle;
    HandleInfo: DWORD;
  end;
  PMARK_HANDLE_INFO = ^MARK_HANDLE_INFO;
  TMarkHandleInfo = MARK_HANDLE_INFO;
  PMarkHandleInfo = ^TMarkHandleInfo;

  TUSN = record end; // USN record

  USN_RECORD_V2 = record
    RecordLength: DWORD;
    MajorVersion: WORD;
    MinorVersion: WORD;
    FileReferenceNumber: DWORDLONG;
    ParentFileReferenceNumber: DWORDLONG;
    Usn: TUSN;
    TimeStamp: LARGE_INTEGER;
    Reason: DWORD;
    SourceInfo: DWORD;
    SecurityId: DWORD;
    FileAttributes: DWORD;
    FileNameLength: WORD;
    FileNameOffset: WORD;
    FileName: array[0..0] of WCHAR;
  end;
  PUSN_RECORD_V2 = ^USN_RECORD_V2;

  TWords = TArray<Word>;
  TWord = Word;
  // output buffer for the FSCTL_GET_VOLUME_BITMAP control code.
  VOLUME_BITMAP_BUFFER = record
    StartingLcn: LARGE_INTEGER;
    BitmapSize: LARGE_INTEGER;
    case Byte of
      0: (Buffer: array[0..0] of Byte); // array of Bytes, not just 1 byte!!!!
      1: (BufferUInt16: array[0..0] of UInt16);
      2: (BufferUInt32: array[0..0] of UInt32);
      3: (BufferUInt64: array[0..0] of UInt64);
  end;

  PVOLUME_BITMAP_BUFFER = ^VOLUME_BITMAP_BUFFER;
  TVolumeBitmapBuffer = VOLUME_BITMAP_BUFFER;
  PVolumeBitmapBuffer = ^TVolumeBitmapBuffer;

  _GET_DISK_ATTRIBUTES = record
    Version: DWORD;
    Reserved1: DWORD;
    Attributes: DWORDLONG;
    class operator Initialize(out Dest: _GET_DISK_ATTRIBUTES);
  end;
  GET_DISK_ATTRIBUTES = _GET_DISK_ATTRIBUTES;

  DISK_CLUSTER_INFO = record
    Version: ULONG;
    Flags: ULONGLONG;
    FlagsMask: ULONGLONG;
    Notify: LongBool;
    class operator Initialize(out Dest: DISK_CLUSTER_INFO);
  end;

  _DISK_EXTENT = record
    DiskNumber: DWORD;
    StartingOffset: LARGE_INTEGER;
    ExtentLength: LARGE_INTEGER;
  end;
  DISK_EXTENT = _DISK_EXTENT;
  PDISK_EXTENT = ^DISK_EXTENT;
  TDiskExtent = DISK_EXTENT;
  PDiskExtent = ^TDiskExtent;

  _VOLUME_DISK_EXTENTS = record
    NumberOfDiskExtents: DWORD;
    Extents: array[0..0] of DISK_EXTENT;
  end;
  VOLUME_DISK_EXTENTS = _VOLUME_DISK_EXTENTS;
  PVOLUME_DISK_EXTENTS = ^VOLUME_DISK_EXTENTS;
  TVolumeDiskExtents = VOLUME_DISK_EXTENTS;
  PVolumeDiskExtents = ^TVolumeDiskExtents;

  NTFS_VOLUME_DATA_BUFFER = record
    VolumeSerialNumber: LARGE_INTEGER;
    NumberSectors: LARGE_INTEGER;
    TotalClusters: LARGE_INTEGER;
    FreeClusters: LARGE_INTEGER;
    TotalReserved: LARGE_INTEGER;
    BytesPerSector: DWORD;
    BytesPerCluster: DWORD;
    BytesPerFileRecordSegment: DWORD;
    ClustersPerFileRecordSegment: DWORD;
    MftValidDataLength: LARGE_INTEGER;
    MftStartLcn: LARGE_INTEGER;
    Mft2StartLcn: LARGE_INTEGER;
    MftZoneStart: LARGE_INTEGER;
    MftZoneEnd: LARGE_INTEGER;
    class operator Initialize(out Dest: NTFS_VOLUME_DATA_BUFFER);
  end;
  PNTFS_VOLUME_DATA_BUFFER = ^NTFS_VOLUME_DATA_BUFFER;
  TNTFSVolumeDataBuffer = NTFS_VOLUME_DATA_BUFFER;
  PNTFSVolumeDataBuffer = ^TNTFSVolumeDataBuffer;

  STARTING_LCN_INPUT_BUFFER = record
    StartingLcn: LARGE_INTEGER;
  end;
  TStartingLcnInputBuffer = STARTING_LCN_INPUT_BUFFER;
  PStartingLcnInputBuffer = ^TStartingLcnInputBuffer;

  STARTING_VCN_INPUT_BUFFER = record
    StartingVcn: LARGE_INTEGER;
  end;
  TStartingVcnInputBuffer = STARTING_VCN_INPUT_BUFFER;
  PStartingVcnInputBuffer = ^TStartingVcnInputBuffer;

  function GetVolumeBitmapBuffer: PVolumeBitmapBuffer;

implementation

function GetVolumeBitmapBuffer: PVolumeBitmapBuffer;
begin
end;

{ _GET_DISK_ATTRIBUTES }

class operator _GET_DISK_ATTRIBUTES.Initialize(out Dest: _GET_DISK_ATTRIBUTES);
begin
  FillChar(Dest, SizeOf(Dest), 0);
  Dest.Version := SizeOf(Dest);
end;

{ DISK_CLUSTER_INFO }

class operator DISK_CLUSTER_INFO.Initialize(out Dest: DISK_CLUSTER_INFO);
begin
  FillChar(Dest, SizeOf(Dest), 0);
  Dest.Version := SizeOf(Dest);
end;

{ NTFS_VOLUME_DATA_BUFFER }

class operator NTFS_VOLUME_DATA_BUFFER.Initialize(
  out Dest: NTFS_VOLUME_DATA_BUFFER);
begin
  FillChar(Dest, SizeOf(Dest), 0);
end;

end.
