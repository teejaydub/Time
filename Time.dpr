program Time;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}



uses
{$IFNDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms, zvdatetimectrls,
  DataForm in 'DataForm.pas' {HoursData: TDataModule},
  Grid in 'Grid.pas' {GridForm},
  Entry in 'Entry.pas',
  UserInfo in 'UserInfo.pas', lazreportpdfexport {UserInfoForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGridForm, GridForm);
  Application.CreateForm(THoursData, HoursData);
  Application.CreateForm(TEntryForm, EntryForm);
  Application.CreateForm(TUserInfoForm, UserInfoForm);
  Application.Run;
end.
