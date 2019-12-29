unit DataForm;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ZConnection,
  ZDataset, DB, IBConnection, sqldb;

type

{ THoursData }

  THoursData = class(TDataModule)
    ClassList: TZReadOnlyQuery;
    ClassListCLASS: TStringField;
    HoursSrc: TDataSource;
    Hours: TZQuery;
    LiveHours: TZReadOnlyQuery;
    LiveHoursNETHOURS: TFloatField;
    OldHoursCLASS: TStringField;
    OldHoursDESCRIPTION: TStringField;
    OldHoursFROMTIME: TDateTimeField;
    OldHoursID: TLargeintField;
    OldHoursNETHOURS: TFloatField;
    OldHoursPAID: TStringField;
    OldHoursSUBMITTED: TStringField;
    OldHoursTOTIME: TDateTimeField;
    OldUserInfoADDRESS1: TStringField;
    OldUserInfoADDRESS2: TStringField;
    OldUserInfoADDRESS3: TStringField;
    OldUserInfoHOURSPERPERIOD: TLongintField;
    OldUserInfoPHONE: TStringField;
    OldUserInfoUSERNAME: TStringField;
    OldTimeSumSUM: TFloatField;
    TimeSumSUM: TFloatField;
    UnsubmittedHours: TZReadOnlyQuery;
    UserInfoSrc: TDataSource;
    Connection: TZConnection;
    HoursCLASS: TStringField;
    HoursDESCRIPTION: TStringField;
    HoursFROMTIME: TDateTimeField;
    HoursID: TLargeintField;
    HoursNETHOURS: TFloatField;
    HoursPAID: TStringField;
    HoursSUBMITTED: TStringField;
    HoursTOTIME: TDateTimeField;
    UserInfo: TZTable;
    UserInfoADDRESS1: TStringField;
    UserInfoADDRESS2: TStringField;
    UserInfoADDRESS3: TStringField;
    UserInfoHOURSPERPERIOD: TLongintField;
    UserInfoPHONE: TStringField;
    UserInfoUSERNAME: TStringField;
    TimeSum: TZReadOnlyQuery;
    procedure ConnectionAfterConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure HoursAfterApplyUpdates(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SaveAll;
    function GetHoursSince(SinceTime: TDateTime): Single;
    function GetLiveHours: Single;
end;

var
  HoursData: THoursData;
  ViewingClass: string;  // '' means all, a single class means we're filtering

implementation

{$R *.dfm}

procedure THoursData.HoursAfterApplyUpdates(Sender: TObject);
begin
  // This is so the NETHOURS field, calculated by the server, can be refreshed.
  Hours.Refresh;
end;

procedure THoursData.ConnectionAfterConnect(Sender: TObject);
begin

end;

procedure THoursData.DataModuleCreate(Sender: TObject);
begin

end;

procedure THoursData.SaveAll;
begin
  // Nothing to do at the moment.
  // We could disconnect and reconnect here, and trigger it just on a timer or File > Save or explicit Refresh.
end;

function THoursData.GetHoursSince(SinceTime: TDateTime): Single;
begin
  TimeSum.ParamByName('MinDate').Value := SinceTime;
  if ViewingClass <> '' then
    TimeSum.ParamByName('FilterClass').Value := 'Y'
  else
    TimeSum.ParamByName('FilterClass').Value := 'N';
  TimeSum.ParamByName('Class').Value := ViewingClass;
  TimeSum.Open;
  Result := TimeSumSUM.Value;
  TimeSum.Close;
end;

function THoursData.GetLiveHours: Single;
begin
  LiveHours.Open;
  Result := LiveHoursNETHOURS.AsFloat;
  LiveHours.Close;
end;

initialization

end.
