unit TimeMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls;

type
	TTimeMainForm = class(TForm)
		DBGrid1: TDBGrid;
		UpdateBtn: TButton;
		procedure UpdateClick(Sender: TObject);
	private
		{ Private declarations }
	public
		{ Public declarations }
	end;

var
	TimeMainForm: TTimeMainForm;

function RoundTime(time: TDateTime; minute: integer): TDateTime;

implementation

uses DataForm;

{$R *.DFM}

procedure TTimeMainForm.UpdateClick(Sender: TObject);
begin
	with HoursData.HoursTable do
	begin
		DisableControls;
		First;
		while not(EOF) do begin
			Edit;

			FieldByName('FromTime').Value :=
					FieldByName('FromTime').Value - 2;

			FieldByName('ToTime').Value :=
					FieldByName('ToTime').Value - 2;

			Post;
			Next;
		end;
		EnableControls;
	end;
end;

{ Rounds a TDateTime to the nearest multiple of minute. }
function RoundTime(time: TDateTime; minute: integer): TDateTime;
var
	Hour, Min, Sec, MSec: Word;
begin
	DecodeTime(time, Hour, Min, Sec, MSec);

	// round MSec
	if MSec >= 500 then
		Sec := Sec + 1;  // overflow will be handled
	MSec := 0;

	// round Sec
	if Sec >= 30 then
		Min := Min + 1;  // overflow will be handled
	Sec := 0;

	// round Min
	if Min mod minute >= minute / 2 then
		Min := Min + minute - Min mod minute;

	// handle overflow
	if Min > 60 then begin
		if Hour = 23 then
			// overflowed to the next day; just handle it as a 24-hour wraparound
			Hour := 0
		else
			Hour := Hour + 1;
		Min := 0;
	end;

	Result := EncodeTime(Hour, Min, Sec, MSec);
end;

end.
