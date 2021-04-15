program Defrag;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Winapi.Defrag.Consts in 'Winapi.Defrag.Consts.pas',
  Winapi.Defrag.Types in 'Winapi.Defrag.Types.pas',
  Winapi.Defrag in 'Winapi.Defrag.pas',
  Winapi.DefragAPI in 'Winapi.DefragAPI.pas';

procedure DefragMain;
var
  LDrive: TDrive;
begin
  LDrive := TDrive.Create('K');
  try
    LDrive.GetVolumeBitmap;
  finally
    LDrive.Free;
  end;
end;

procedure DefragVolume;
var
  LVolume: TVolume;
begin
  LVolume := TVolume.Create('K');
  try

  finally
    LVolume.Free;
  end;
end;

begin
  DefragVolume;
end.
