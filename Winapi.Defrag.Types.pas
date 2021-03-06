unit Winapi.Defrag.Types;

interface
uses
  Winapi.Windows;

{$RANGECHECKS OFF}

type
  MOVE_FILE_DATA = record
    FileHandle: THandle;
    StartingVcn: LARGE_INTEGER;
    StartingLcn: LARGE_INTEGER;
    ClusterCount: Winapi.Windows.DWORD;
  end;
  PMOVE_FILE_DATA = ^MOVE_FILE_DATA;
  TMoveFileData   = MOVE_FILE_DATA;
  PMoveFileData   = ^TMoveFileData;

  MARK_HANDLE_INFO = record
    DummyUnionName: record
    case Byte of
      0: (UsnSourceInfo: DWORD);
      1: (CopyNumber: DWORD);
    end;
    UsnSourceInfo: DWORD;
    VolumeHandle: THandle;
    HandleInfo: DWORD;
  end;
  PMARK_HANDLE_INFO = ^MARK_HANDLE_INFO;
  TMarkHandleInfo   = MARK_HANDLE_INFO;
  PMarkHandleInfo   = ^TMarkHandleInfo;

  TUSN = UInt64; // USN record

  PUSN_RECORD_V2 = ^USN_RECORD_V2;
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
    class function Alloc(const AFileNameLength: WORD): PUSN_RECORD_V2; static;
  end;

  FILE_ID_128 = record
    Identifier: array[0..15] of BYTE;
  end;
  PFILE_ID_128 = ^FILE_ID_128;

  PUSN_RECORD_V3 = ^USN_RECORD_V3;
  USN_RECORD_V3 = record
    RecordLength: DWORD;
    MajorVersion: WORD;
    MinorVersion: WORD;
    FileReferenceNumber: FILE_ID_128;
    ParentFileReferenceNumber: FILE_ID_128;
    Usn: TUSN;
    TimeStamp: LARGE_INTEGER;
    Reason: DWORD;
    SourceInfo: DWORD;
    SecurityId: DWORD;
    FileAttributes: DWORD;
    FileNameLength: WORD;
    FileNameOffset: WORD;
    FileName: array[0..0] of WCHAR;
    class function Alloc(const AFileNameLength: DWORD): PUSN_RECORD_V3; static;
  end;

  USN_RECORD_COMMON_HEADER = record
    RecordLength: DWORD;
    MajorVersion: WORD;
    MinorVersion: WORD;
  end;
  PUSN_RECORD_COMMON_HEADER = ^USN_RECORD_COMMON_HEADER;

  USN_RECORD_EXTENT = record
    Offset: LONGLONG;
    Length: LONGLONG;
  end;
  PUSN_RECORD_EXTENT = ^USN_RECORD_EXTENT;

  PUSN_RECORD_V4 = ^USN_RECORD_V4;
  USN_RECORD_V4 = record
    Header: USN_RECORD_COMMON_HEADER;
    FileReferenceNumber: FILE_ID_128;
    ParentFileReferenceNumber: FILE_ID_128;
    Usn: TUSN;
    Reason: DWORD;
    SourceInfo: DWORD;
    RemainingExtents: DWORD;
    NumberOfExtents: WORD;
    ExtentSize: WORD;
    Extents: array[0..0] of USN_RECORD_EXTENT;
    class function Alloc(const ANumberOfExtents: WORD): PUSN_RECORD_V4; static;
  end;

  TWords = TArray<Word>;
  TWord = Word;
  // output buffer for the FSCTL_GET_VOLUME_BITMAP control code.
  PVOLUME_BITMAP_BUFFER = ^VOLUME_BITMAP_BUFFER;
  VOLUME_BITMAP_BUFFER = record
    StartingLcn: LARGE_INTEGER;
    BitmapSize: LARGE_INTEGER;
    class function Alloc(const BufferLen: DWORD): PVOLUME_BITMAP_BUFFER; static;
    // The following is free flow, hence the Alloc method
    case Byte of
      0: (Buffer: array[0..0] of Byte); // array of Bytes, not just 1 byte!!!!
      1: (BufferUInt16: array[0..0] of UInt16);
      2: (BufferUInt32: array[0..0] of UInt32);
      3: (BufferUInt64: array[0..0] of UInt64);
  end;
  TVolumeBitmapBuffer   = VOLUME_BITMAP_BUFFER;
  PVolumeBitmapBuffer   = ^TVolumeBitmapBuffer;

  _GET_DISK_ATTRIBUTES = record
    Version: DWORD;
    Reserved1: DWORD;
    Attributes: DWORDLONG;
    class operator Initialize(out Dest: _GET_DISK_ATTRIBUTES);
  end;
  GET_DISK_ATTRIBUTES  = _GET_DISK_ATTRIBUTES;
  PGET_DISK_ATTRIBUTES = ^GET_DISK_ATTRIBUTES;
  TGetDiskAttributes   = GET_DISK_ATTRIBUTES;
  PGetDiskAttributes   = ^TGetDiskAttributes;

  _SET_DISK_ATTRIBUTES = record
    Version: DWORD;
    Persist: BOOLEAN;
    Reserved1: array[0..3] of BYTE;
    Attributes: DWORDLONG;
    AttributesMask: DWORDLONG;
    Reserved2: array[0..3] of DWORD;
    class operator Initialize(out Dest: _SET_DISK_ATTRIBUTES);
  end;
  SET_DISK_ATTRIBUTES = _SET_DISK_ATTRIBUTES;
  PSET_DISK_ATTRIBUTES = ^SET_DISK_ATTRIBUTES;
  TSetDiskAttributes = SET_DISK_ATTRIBUTES;
  PSetDiskAttributes = ^TSetDiskAttributes;

  DISK_CLUSTER_INFO = record
    Version: ULONG;
    Flags: ULONGLONG;
    FlagsMask: ULONGLONG;
    Notify: LongBool;
    class operator Initialize(out Dest: DISK_CLUSTER_INFO);
  end;
  PDISK_CLUSTER_INFO = ^DISK_CLUSTER_INFO;
  TDiskClusterInfo = DISK_CLUSTER_INFO;
  PDiskClusterInfo = ^TDiskClusterInfo;

  _DISK_EXTENT = record
    DiskNumber: DWORD;
    StartingOffset: LARGE_INTEGER;
    ExtentLength: LARGE_INTEGER;
  end;
  DISK_EXTENT  = _DISK_EXTENT;
  PDISK_EXTENT = ^DISK_EXTENT;
  TDiskExtent  = DISK_EXTENT;
  PDiskExtent  = ^TDiskExtent;

  PVOLUME_DISK_EXTENTS = ^VOLUME_DISK_EXTENTS;
  _VOLUME_DISK_EXTENTS = record
    NumberOfDiskExtents: DWORD;
    Extents: array[0..0] of DISK_EXTENT;
    class function Alloc(ExtentCount: DWORD): PVOLUME_DISK_EXTENTS; static;
  end;
  VOLUME_DISK_EXTENTS  = _VOLUME_DISK_EXTENTS;
  TVolumeDiskExtents   = VOLUME_DISK_EXTENTS;
  PVolumeDiskExtents   = ^TVolumeDiskExtents;

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
  TNTFSVolumeDataBuffer    = NTFS_VOLUME_DATA_BUFFER;
  PNTFSVolumeDataBuffer    = ^TNTFSVolumeDataBuffer;

  STARTING_LCN_INPUT_BUFFER = record
    StartingLcn: LARGE_INTEGER;
  end;
  PSTARTING_LCN_INPUT_BUFFER = ^STARTING_LCN_INPUT_BUFFER;
  TStartingLcnInputBuffer    = STARTING_LCN_INPUT_BUFFER;
  PStartingLcnInputBuffer    = ^TStartingLcnInputBuffer;

  STARTING_VCN_INPUT_BUFFER = record
    StartingVcn: LARGE_INTEGER;
  end;
  PSTARTING_VCN_INPUT_BUFFER = ^STARTING_VCN_INPUT_BUFFER;
  TStartingVcnInputBuffer    = STARTING_VCN_INPUT_BUFFER;
  PStartingVcnInputBuffer    = ^TStartingVcnInputBuffer;

  EXTENT = record
    NextVcn: LARGE_INTEGER;
    Lcn: LARGE_INTEGER;
  end;
  PEXTENT = ^EXTENT;

{$MESSAGE WARN 'Check definition!!! Incomplete!!!'}
  PRETRIEVAL_POINTERS_BUFFER = ^RETRIEVAL_POINTERS_BUFFER;
  RETRIEVAL_POINTERS_BUFFER = record
    ExtentCount: DWORD;
    StartingVcn: LARGE_INTEGER;
    Extents: array[0..0] of EXTENT; // This is free flow
    class function Alloc(const ExtentCount: DWORD): PRETRIEVAL_POINTERS_BUFFER; static;
  end;

implementation

{ USN_RECORD_V2 }

class function USN_RECORD_V2.Alloc(const AFileNameLength: WORD): PUSN_RECORD_V2;
begin
  GetMem(Result, SizeOf(USN_RECORD_V2) + AFileNameLength - SizeOf(WCHAR));
  Result.FileNameLength := AFileNameLength;
  Result.FileNameOffset := NativeUInt(@Result.FileName) - NativeUInt(Result);
end;

class function USN_RECORD_V3.Alloc(const AFileNameLength: DWORD): PUSN_RECORD_V3;
begin
  GetMem(Result, SizeOf(USN_RECORD_V3) + AFileNameLength - SizeOf(WCHAR));
  Result.FileNameLength := AFileNameLength;
  Result.FileNameOffset := NativeUInt(@Result.FileName) - NativeUInt(Result);
end;

{ USN_RECORD_V4 }

class function USN_RECORD_V4.Alloc(const ANumberOfExtents: WORD): PUSN_RECORD_V4;
begin
  GetMem(Result, SizeOf(USN_RECORD_V4) +
                 ((ANumberOfExtents-1) * SizeOf(USN_RECORD_EXTENT))
  );
  Result.NumberOfExtents := ANumberOfExtents;
end;

{ _GET_DISK_ATTRIBUTES }

class operator _GET_DISK_ATTRIBUTES.Initialize(out Dest: _GET_DISK_ATTRIBUTES);
begin
  FillChar(Dest, SizeOf(Dest), 0);
  Dest.Version := SizeOf(Dest);
end;

{ _SET_DISK_ATTRIBUTES }

class operator _SET_DISK_ATTRIBUTES.Initialize(out Dest: _SET_DISK_ATTRIBUTES);
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

{ _VOLUME_DISK_EXTENTS }

class function _VOLUME_DISK_EXTENTS.Alloc(ExtentCount: DWORD): PVOLUME_DISK_EXTENTS;
begin
  GetMem(Result, SizeOf(VOLUME_DISK_EXTENTS) +
                 (SizeOf(DISK_EXTENT) * (ExtentCount-1))
  );
end;

{ RETRIEVAL_POINTERS_BUFFER }

class function RETRIEVAL_POINTERS_BUFFER.Alloc(const ExtentCount: DWORD): PRETRIEVAL_POINTERS_BUFFER;
begin
  GetMem(Result, SizeOf(RETRIEVAL_POINTERS_BUFFER) +
                 // For Extents: remove the built-in array[0..0] of X
                 (SizeOf(EXTENT) * (ExtentCount-1))
  );
  Result.ExtentCount := ExtentCount;
end;

{ VOLUME_BITMAP_BUFFER }

class function VOLUME_BITMAP_BUFFER.Alloc(const BufferLen: DWORD): PVOLUME_BITMAP_BUFFER;
begin
  GetMem(Result, SizeOf(VOLUME_BITMAP_BUFFER) +
                 (BufferLen - SizeOf(Byte))
  );
end;

end.
