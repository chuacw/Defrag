program CrashBDS;

{$APPTYPE CONSOLE}

{$R *.res}

// Press F7 to step into Crash Main,
// Pres F8 to step over SetLength
// hover cursor to any LBytes, then press the magnifying icon
// and watch BDS become unresponsive due to the memory dump visualizer!
procedure CrashMain;
var
  LBytes: array of Byte;
begin
  SetLength(LBytes, 9600000);
  for var I := Low(LBytes) to High(LBytes) do
    if LBytes[I] <> 0 then
      Break;
end;

begin
  CrashMain;
end.
