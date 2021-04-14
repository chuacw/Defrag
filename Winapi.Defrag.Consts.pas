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

implementation

end.
