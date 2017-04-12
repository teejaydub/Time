unit UserInfo;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Graphics, Controls, StdCtrls, Forms,
  Dialogs, DBCtrls, ExtCtrls, DataForm;

type
  TUserInfoForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EditUserName: TDBEdit;
    EditAddress: TDBEdit;
    EditAddress2: TDBEdit;
    EditAddress3: TDBEdit;
    EditPhone: TDBEdit;
    EditHoursPerPeriod: TDBEdit;
    OK: TButton;
    Cancel: TButton;
    procedure OKClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  UserInfoForm: TUserInfoForm;

implementation

{$R *.dfm}

procedure TUserInfoForm.FormShow(Sender: TObject);
begin
  with HoursData.UserInfo do
    if IsEmpty then
      Insert
    else
      Edit
end;

procedure TUserInfoForm.OKClick(Sender: TObject);
begin
  HoursData.UserInfo.Post;
end;

procedure TUserInfoForm.CancelClick(Sender: TObject);
begin
  HoursData.UserInfo.Cancel;
end;

end.
