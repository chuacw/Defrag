unit Winapi.Defrag.Consts;

interface
uses
  Winapi.Windows;

const
  FSCTL_GET_RETRIEVAL_POINTERS = Winapi.Windows.FSCTL_GET_RETRIEVAL_POINTERS;
  FSCTL_MARK_HANDLE = Winapi.Windows.FSCTL_MARK_HANDLE;
  FSCTL_GET_VOLUME_BITMAP = Winapi.Windows.FSCTL_GET_VOLUME_BITMAP;
  FSCTL_MOVE_FILE = Winapi.Windows.FSCTL_MOVE_FILE;
//  MARK_HANDLE_PROTECT_CLUSTERS = Winapi.Windows.MARK_HANDLE_PROTECT_CLUSTERS;
  IOCTL_VOLUME_GET_VOLUME_DISK_EXTENTS = Winapi.Windows.IOCTL_VOLUME_GET_VOLUME_DISK_EXTENTS;
  IOCTL_DISK_GET_DRIVE_GEOMETRY = Winapi.Windows.IOCTL_DISK_GET_DRIVE_GEOMETRY;

// See https://social.technet.microsoft.com/wiki/contents/articles/24653.decoding-io-control-codes-ioctl-fsctl-and-deviceiocodes-with-table-of-known-values.aspx?Sort=MostUseful&PageIndex=1
  IOCTL_DISK_GET_CLUSTER_INFO = $00070214; // 0x00070214

  MARK_HANDLE_PROTECT_CLUSTERS                    = $00000001;
  MARK_HANDLE_TXF_SYSTEM_LOG                      = $00000004;
  MARK_HANDLE_NOT_TXF_SYSTEM_LOG                  = $00000008;
  MARK_HANDLE_REALTIME                            = $00000020;
  MARK_HANDLE_NOT_REALTIME                        = $00000040;
  MARK_HANDLE_READ_COPY                           = $00000080;
  MARK_HANDLE_NOT_READ_COPY                       = $00000100;
  MARK_HANDLE_RETURN_PURGE_FAILURE                = $00000400;
  MARK_HANDLE_DISABLE_FILE_METADATA_OPTIMIZATION  = $00001000;
  MARK_HANDLE_ENABLE_USN_SOURCE_ON_PAGING_IO      = $00002000;
  MARK_HANDLE_SKIP_COHERENCY_SYNC_DISALLOW_WRITES = $00004000;

  DISK_ATTRIBUTE_OFFLINE   = $0000000000000001;
  DISK_ATTRIBUTE_READ_ONLY = $0000000000000002;

  USN_SOURCE_AUXILIARY_DATA                = $00000002;
  USN_SOURCE_DATA_MANAGEMENT               = $00000001;
  USN_SOURCE_REPLICATION_MANAGEMENT        = $00000004;
  USN_SOURCE_CLIENT_REPLICATION_MANAGEMENT = $00000008;

  USN_REASON_DATA_OVERWRITE        = $00000001;
  USN_REASON_DATA_EXTEND           = $00000002;
  USN_REASON_DATA_TRUNCATION       = $00000004;
  USN_REASON_NAMED_DATA_OVERWRITE  = $00000010;
  USN_REASON_NAMED_DATA_EXTEND     = $00000020;
  USN_REASON_NAMED_DATA_TRUNCATION = $00000040;
  USN_REASON_FILE_CREATE           = $00000100;
  USN_REASON_FILE_DELETE           = $00000200;
  USN_REASON_EA_CHANGE             = $00000400;
  USN_REASON_SECURITY_CHANGE       = $00000800;
  USN_REASON_RENAME_OLD_NAME       = $00001000;
  USN_REASON_RENAME_NEW_NAME       = $00002000;
  USN_REASON_INDEXABLE_CHANGE      = $00004000;
  USN_REASON_BASIC_INFO_CHANGE     = $00008000;
  USN_REASON_HARD_LINK_CHANGE      = $00010000;
  USN_REASON_COMPRESSION_CHANGE    = $00020000;
  USN_REASON_ENCRYPTION_CHANGE     = $00040000;
  USN_REASON_OBJECT_ID_CHANGE      = $00080000;
  USN_REASON_REPARSE_POINT_CHANGE  = $00100000;
  USN_REASON_STREAM_CHANGE         = $00200000;
  USN_REASON_TRANSACTED_CHANGE     = $00400000;
  USN_REASON_INTEGRITY_CHANGE      = $00800000;
  USN_REASON_CLOSE                 = $80000000;

implementation

end.
