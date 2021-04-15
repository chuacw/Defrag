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

implementation

end.
