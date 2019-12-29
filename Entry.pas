unit Entry;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  SysUtils, StdCtrls, Forms, ExtCtrls, Calendar, DbCtrls,
  DateTimePicker, Classes;

type

  { TEntryForm }

  TEntryForm = class(TForm)
    ClassEdit: TDBEdit;
    DescEdit: TDBEdit;
    FromTime: TDateTimePicker;
    Paid: TDBCheckBox;
    SetToStart: TButton;
    Submitted: TDBCheckBox;
    ToTime: TDateTimePicker;
    ScrollBox: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    StartCalendar: TCalendar;
    OKButton: TButton;
    CancelBtn: TButton;
    procedure OKButtonClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SetToStartClick(Sender: TObject);
  private
  public
  end;

var
  EntryForm: TEntryForm;

implementation

{$R *.dfm}

uses DataForm, Dialogs, DateUtils;

procedure TEntryForm.FormShow(Sender: TObject);
begin
  // populate the controls with the values from the current record, or with
  // defaults if the table is in insert mode.
  With HoursData.Hours do begin
    // get the values from the database record
    StartCalendar.DateTime := DateOf(FieldByName('FromTime').AsDateTime);
    FromTime.DateTime := FieldByName('FromTime').AsDateTime;
    ToTime.DateTime := FieldByName('ToTime').AsDateTime;
  end;
end;

procedure TEntryForm.SetToStartClick(Sender: TObject);
begin
  ToTime.DateTime := FromTime.DateTime;
end;

procedure TEntryForm.CancelBtnClick(Sender: TObject);
begin
  // cancel the transaction
  HoursData.Hours.Cancel;
  Hide;
end;

procedure TEntryForm.OKButtonClick(Sender: TObject);
begin
  // copy the data back into its record
  with HoursData.Hours do begin
    // Copy the calendar date to the two DateTime controls.
    FieldByName('FromTime').Value := StartCalendar.DateTime + FromTime.Time;
    if (ToTime.Time >= FromTime.Time) then
      FieldByName('ToTime').Value := StartCalendar.DateTime + ToTime.Time
    else
      // Ensure the To time is at or after the From time - if not, move it to the next day.
      FieldByName('ToTime').Value := StartCalendar.DateTime + 1 + ToTime.Time;

    // post the transaction
    Post;
    ApplyUpdates;
  end;
  Hide;
end;

end.
