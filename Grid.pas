unit Grid;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  SysUtils, Dialogs, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBGrids, Grids, ExtCtrls, Menus,
  ActnList, LR_Class, LR_DBSet, lr_e_pdf, MruMenu;

type

{ TGridForm }

 TGridForm = class(TForm)
    ApplicationProperties: TApplicationProperties;
    BottomPanel: TPanel;
    DBGrid1: TDBGrid;
    DBNavigator: TDBNavigator;
    AllClassesMenuItem: TMenuItem;
    ClassMenuSeparator: TMenuItem;
    HoursSummary: TfrReport;
    HoursToday: TEdit;
    HoursWeek: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Remaining: TEdit;
    SelectedTotal: TEdit;
    SelectedSumLabel: TLabel;
    Timer: TTimer;
    MruMenu: TMruMenu;
    ReportHoursSrc: TDatasource;
    ReportUserInfo: TfrDBDataSet;
    ReportUserInfoSrc: TDatasource;
    SummaryReportItem: TMenuItem;
    OpenDialog: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    ClassMenu: TMenuItem;
    RecordsMenu: TMenuItem;
    MarkSubmitted: TMenuItem;
    MarkPaid: TMenuItem;
    ReportExportPDF: TfrTNPDFExport;
    ReportHours: TfrDBDataSet;
    StartBtn: TButton;
    StopBtn: TButton;
    UpperMruSep: TMenuItem;
    UserInfo1: TMenuItem;
    Open1: TMenuItem;
    Close1: TMenuItem;
    LowerMruSep: TMenuItem;
    ReportsMenu: TMenuItem;
    Graphs1: TMenuItem;
    HoursWorked1: TMenuItem;
    ime1: TMenuItem;
    StartWork1: TMenuItem;
    EndWork1: TMenuItem;
    StartQuick1: TMenuItem;
    QuickFinish1: TMenuItem;
    ActionList1: TActionList;
    StartWork: TAction;
    EndWork: TAction;
    QuickRestart: TAction;
    QuickFinish: TAction;
    procedure ApplicationPropertiesIdle(Sender: TObject; var Done: Boolean);
    procedure ClassMenuClick(Sender: TObject);
    procedure ClassMenuItemClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure MarkSubmittedClick(Sender: TObject);
    procedure MarkPaidClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBNavigatorClick(Sender: TObject; Button: TNavigateBtn);
    procedure MruMenuClick(name: String);
    procedure N1Click(Sender: TObject);
    procedure SummaryReportItemClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure UserInfo1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure HoursWorked1Click(Sender: TObject);
    procedure StartWorkExecute(Sender: TObject);
    procedure EndWorkExecute(Sender: TObject);
    procedure QuickRestartExecute(Sender: TObject);
    procedure QuickFinishExecute(Sender: TObject);
  private
    procedure StartNewPeriod;
    { private declarations }
    procedure UpdateClassMenu;
    procedure UpdateClassFilter;
    procedure UpdateAll;
    procedure EnableControls;
    procedure OpenData;
    procedure UpdateTotals;
  public
    { public declarations }
  end;

var
  GridForm: TGridForm;

implementation

{$R *.dfm}

uses DataForm, DateUtils, Entry, UserInfo, LCLType, DateTimePicker, ZDataset;

function TruncToMultiple(x, multiple: Integer): Integer;
begin
  Result := (x div multiple) * multiple;
end;

function TruncTime(t: TDateTime; minuteResolution: Integer): TDateTime;
begin
  Result := RecodeMinute(t, TruncToMultiple(MinuteOf(t), 5));
  Result := RecodeSecond(Result, 0);
end;

procedure TGridForm.FormShow(Sender: TObject);
begin
  if MruMenu.LastOpened <> '' then
    MruMenu.OnClick(MruMenu.LastOpened);

  UpdateAll;
  DBGrid1.SetFocus;
end;

procedure TGridForm.MruMenuClick(name: String);
begin
  HoursData.Connection.Connected := False;
  HoursData.Connection.Database := name;

  OpenData;
end;

procedure TGridForm.OpenData;
begin
  with HoursData do begin
    Connection.Connected := True;

    UserInfo.Open;
    Hours.Open;
    Hours.Last;

    MruMenu.AddFile(HoursData.Connection.Database);
  end;

  EnableControls;
end;

procedure TGridForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  HoursData.Connection.Connected := False;
end;

{ Populate the Classes menu with all the class names used in the data. }
procedure TGridForm.UpdateClassMenu;
var
  item: integer;
  found: Boolean;
  newItem: TMenuItem;
begin
  // tag all menu items to show they're not found
  for item := 0 to ClassMenu.Count - 1 do
    ClassMenu.Items[item].Tag := 0;

  // Treat the "all" and separator entries specially.
  // 1 = regular class entries; 2 = keep them there, but don't allow them as filter components.
  AllClassesMenuItem.Tag := 2;
  ClassMenuSeparator.Tag := 2;

  // loop through the unique classes
  HoursData.ClassList.Open;
  while not HoursData.ClassList.EOF do
  begin
    // search for the class in the menu
    found := false;
    for item := 0 to ClassMenu.Count - 1 do
      if ClassMenu.Items[item].Caption = HoursData.ClassListClass.AsString then begin
        found := true;
        ClassMenu.Items[item].Tag := 1;
        break;
      end;

    // add the class to the menu, if it's not there
    if not found then begin
      newItem := TMenuItem.Create(Self);
      newItem.Caption := HoursData.ClassListClass.AsString;
      newItem.AutoCheck := true;
      newItem.GroupIndex := 1;
      newItem.RadioItem := true;
      newItem.OnClick := ClassMenuItemClick;
      newItem.Tag := 1;
      ClassMenu.Add(newItem);
    end;

    HoursData.ClassList.Next;
  end;
  HoursData.ClassList.Close;

  // now, delete any items that weren't found
  item := 0;
  while item < ClassMenu.Count do
    if ClassMenu.Items[item].Tag = 0 then
      ClassMenu.Delete(item)
    else
      item := item + 1;
end;

procedure TGridForm.UpdateTotals;
var
  totalToday, totalWeek, liveHours, totalSelected: Single;

  function SumOfSelectedHours: Single;
  var
    i, oldSelectedIndex: Integer;
    oldCurrentRowSelected: Boolean;
    oldBookmark: TBookmark;
  begin
    DBGrid1.BeginUpdate;
    try
      oldSelectedIndex := DBGrid1.SelectedIndex;
      oldCurrentRowSelected := DBGrid1.SelectedRows.CurrentRowSelected;
      oldBookmark := HoursData.Hours.GetBookmark;
      Result := 0;

      for i := 0 to DBGrid1.SelectedRows.Count - 1 do begin
        if HoursData.Hours.BookmarkValid(DBGrid1.SelectedRows.Items[i]) then begin
          HoursData.Hours.GotoBookmark(DBGrid1.SelectedRows.Items[i]);
          Result := Result + HoursData.HoursNETHOURS.Value;
        end;
      end;

      HoursData.Hours.GotoBookmark(oldBookmark);
      DBGrid1.SelectedIndex := oldSelectedIndex;
      DBGrid1.SelectedRows.CurrentRowSelected := oldCurrentRowSelected;
    except
    end;
    DBGrid1.EndUpdate;
  end;

begin
  totalToday := HoursData.GetHoursSince(Today);
  totalWeek := HoursData.GetHoursSince(StartOfTheWeek(Today));

  liveHours := HoursData.GetLiveHours;
  totalToday := totalToday + liveHours;
  totalWeek := totalWeek + liveHours;

  if DBGrid1.SelectedRows.Count <= 1 then
    // There's only one row selected (or the user didn't try to select anything).
    // The user knows how many hours are in that period, because they're listed in the row.
    // So, show the total of all visible periods instead.
    totalSelected := HoursData.GetHoursSince(0)
  else
    totalSelected := SumOfSelectedHours;

  HoursToday.Text := FloatToStrF(totalToday, ffNumber, 15, 2);
  HoursWeek.Text := FloatToStrF(totalWeek, ffNumber, 15, 2);
  Remaining.Text := FloatToStrF(HoursData.UserInfoHoursPerPeriod.Value - totalWeek, ffNumber, 15, 2);
  SelectedTotal.Text := FloatToStrF(totalSelected, ffNumber, 15, 2);
end;

procedure TGridForm.ClassMenuClick(Sender: TObject);
begin
  UpdateClassMenu;
end;

procedure TGridForm.ApplicationPropertiesIdle(Sender: TObject;
  var Done: Boolean);
begin
  UpdateTotals;
  Done := True;
end;

procedure TGridForm.ClassMenuItemClick(Sender: TObject);
begin
  UpdateClassFilter;
end;

procedure TGridForm.UpdateClassFilter;
var
  newFilter: string;
  item: integer;
  hadOne: Boolean;
begin
  newFilter := '';
  hadOne := false;
  for item := 0 to ClassMenu.Count - 1 do
  begin
    if ClassMenu.Items[item].Checked and (ClassMenu.Items[item].Tag = 1) then
    begin
      if hadOne then
        newFilter := newFilter + ' OR ';

      hadOne := true;

      // A bit asymmetric here - we support one class in HoursData, but multiple here, but only one in the UI.
      DataForm.ViewingClass := ClassMenu.Items[item].Caption;

      newFilter := newFilter + 'Class='''
        + ClassMenu.Items[item].Caption
        + '''';
    end;
  end;

  if not hadOne then
    DataForm.ViewingClass := '';

  // update SelectedHoursTable
  HoursData.Hours.Filter := newFilter;
  HoursData.Hours.Filtered := hadOne;
  HoursData.Hours.Last;

  UpdateAll;
end;

procedure TGridForm.UpdateAll;
begin
  HoursData.SaveAll;
  DBGrid1.Refresh;

  UpdateClassMenu;

  UpdateTotals;

  EnableControls;
end;

procedure TGridForm.EnableControls;
begin
  UserInfo1.Enabled := HoursData.Connection.Connected;

  ClassMenu.Enabled := HoursData.Connection.Connected;
  RecordsMenu.Enabled := HoursData.Connection.Connected;

  StartBtn.Enabled := HoursData.Connection.Connected;
  StopBtn.Enabled := HoursData.Connection.Connected;
end;

procedure TGridForm.DBGrid1DblClick(Sender: TObject);
begin
  HoursData.HoursSrc.Edit;

  EntryForm.Caption := 'Edit Record';

  if DBGrid1.SelectedField.FieldName = 'FromTime' then
    EntryForm.ActiveControl := EntryForm.FromTime
  else if DBGrid1.SelectedField.FieldName = 'ToTime' then
    EntryForm.ActiveControl := EntryForm.ToTime
  else if DBGrid1.SelectedField.FieldName = 'Class' then
    EntryForm.ActiveControl := EntryForm.ClassEdit
  else if DBGrid1.SelectedField.FieldName = 'Description' then
    EntryForm.ActiveControl := EntryForm.DescEdit
  else if DBGrid1.SelectedField.FieldName = 'Submitted' then
    EntryForm.ActiveControl := EntryForm.Submitted
  else if DBGrid1.SelectedField.FieldName = 'Paid' then
    EntryForm.ActiveControl := EntryForm.Paid;

  EntryForm.ShowModal;
  UpdateAll;
end;

procedure TGridForm.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    DBGrid1DblClick(Sender)  // Pressing Enter is the same as double-clicking a row: opens it for editing.
end;

procedure TGridForm.MarkSubmittedClick(Sender: TObject);
var
  i: Integer;
  oldSpot: TBookmark;
begin
  with HoursData.Hours do
  begin
    DisableControls;
    oldSpot := Bookmark;
    for i := 0 to DBGrid1.SelectedRows.Count - 1 do begin
      Bookmark := TBookmark(DBGrid1.SelectedRows.Items[i]);
      Edit;
      HoursData.HoursSubmitted.AsBoolean :=
        not HoursData.HoursSubmitted.AsBoolean;
      Post;
    end;
    ApplyUpdates;
    Bookmark := oldSpot;
    EnableControls;
  end;
  UpdateAll;
end;

procedure TGridForm.MarkPaidClick(Sender: TObject);
var
  i: Integer;
  oldSpot: TBookmark;
begin
  with HoursData.Hours do
  begin
    DisableControls;
    oldSpot := Bookmark;
    for i := 0 to DBGrid1.SelectedRows.Count - 1 do begin
      Bookmark := TBookmark(DBGrid1.SelectedRows.Items[i]);
      Edit;
      HoursData.HoursPaid.AsBoolean := not HoursData.HoursPaid.AsBoolean;
      Post;
    end;
    ApplyUpdates;
    Bookmark := oldSpot;
    EnableControls;
  end;
  UpdateAll;
end;

procedure TGridForm.StartWorkExecute(Sender: TObject);
begin
  StartNewPeriod;
  With HoursData.Hours do
  begin
    Application.ProcessMessages;

    EntryForm.Caption := 'Start Work';
    EntryForm.ActiveControl := EntryForm.FromTime;
    EntryForm.FromTime.SelectTime;
    EntryForm.ShowModal;

    UpdateAll;
    Last;
  end;
end;

procedure TGridForm.QuickRestartExecute(Sender: TObject);
begin
  StartNewPeriod;
  With HoursData.Hours do
  begin
    Post;
    ApplyUpdates;

    UpdateAll;
    Last;
  end;
end;

// Returns the latest End time for any record in the database.
// Returns 0 if there are no records.
function LatestEndTime: TDateTime;
var
  q: TZQuery;
begin
  q := TZQuery.Create(nil);
  try
    q.Connection := HoursData.Connection;
    q.SQL.Text := 'SELECT MAX(ToTime) FROM HOURS';
    q.Open;
    if q.EOF then
      Result := 0
    else
      Result := q.Fields[0].AsDateTime;
  finally
    q.Free;
  end;
end;

procedure TGridForm.StartNewPeriod;
var
  defaultClass, defaultDescription: string;
  newStartTime: TDateTime;
begin
  With HoursData.Hours do
  begin
    defaultClass := FieldByName('Class').AsString;
    defaultDescription := FieldByName('Description').AsString;

    // End the previous period now, if it's still live (signified by its being empty).
    Last;
    if (FieldByName('ToTime').Value = FieldByName('FromTime').Value)
      // But only do it for records from today!
      and (FieldByName('FromTime').Value >= Today)
    then begin
      Edit;
      FieldByName('ToTime').Value := IncMinute(TruncTime(Now, 5), 5);
      newStartTime := FieldByName('ToTime').Value;  // match it exactly
      Post;
    end else begin
      newStartTime := TruncTime(Now, 5);  // just say we've already started, within the past five minutes.

      // But don't let the start time be earlier than the last end time in the database.
      // (Regardless of filtering.)
      // This happens sometimes when you end manually, then start manually.
      if newStartTime < LatestEndTime then
        newStartTime := LatestEndTime;
    end;

    Insert;

    FieldByName('FromTime').Value := newStartTime;
    FieldByName('ToTime').Value := newStartTime;
    FieldByName('Class').AsString := defaultClass;
    FieldByName('Description').Value := defaultDescription;
    FieldByName('Submitted').AsBoolean := false;
    FieldByName('Paid').AsBoolean := false;
  end;
end;

procedure TGridForm.EndWorkExecute(Sender: TObject);
begin
  With HoursData.Hours do
  begin
    Last;
    Edit;

    FieldByName('ToTime').Value := IncMinute(TruncTime(Now, 5), 5);
    Application.ProcessMessages;

    EntryForm.Caption := 'End Work';
    EntryForm.ActiveControl := EntryForm.ToTime;
    EntryForm.ToTime.SelectTime;
    EntryForm.ShowModal;
  end;
  UpdateAll;
end;

procedure TGridForm.QuickFinishExecute(Sender: TObject);
begin
  With HoursData.Hours do
  begin
    Last;
    Edit;

    FieldByName('ToTime').Value := IncMinute(TruncTime(Now, 5), 5);

    Post;
    ApplyUpdates;
  end;
  UpdateAll;
end;

procedure TGridForm.DBNavigatorClick(Sender: TObject;
  Button: TNavigateBtn);
begin
  if Button = nbDelete then
    UpdateAll
  else if Button = nbRefresh then begin
    UpdateAll;
    HoursData.Hours.Last;
  end;
end;

procedure TGridForm.N1Click(Sender: TObject);
begin
  Close;
end;

procedure TGridForm.UserInfo1Click(Sender: TObject);
begin
  UserInfoForm.ShowModal;
  UpdateAll;
end;

procedure TGridForm.Open1Click(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    HoursData.Connection.Connected := False;
    HoursData.Connection.Database := OpenDialog.FileName;

    OpenData;
  end;
end;

procedure TGridForm.HoursWorked1Click(Sender: TObject);
begin
  //HoursWorkedForm.Show;
end;

procedure TGridForm.Close1Click(Sender: TObject);
begin
  HoursData.SaveAll;
  HoursData.Connection.Connected := False;
  UpdateAll;
end;

function RemoveAmpersands(S: String): String;
begin
  Result := StringReplace(S, '&', '', [rfReplaceAll])
end;

function ConcatWithSep(A, B, Sep: String): String;
begin
  if (A <> '') and (B <> '') then
    Result := A + Sep + B
  else
    Result := A + B
end;

procedure TGridForm.SummaryReportItemClick(Sender: TObject);
begin
  // Include only unsubmitted records in the report.
  HoursData.Hours.Filter := ConcatWithSep(HoursData.Hours.Filter, 'Submitted = ''F''', ' and ');
  HoursData.Hours.Filtered := True;

  // Run the report.
  HoursSummary.LoadFromFile('HoursSummary.lrf');
  HoursSummary.DoublePass := True;
  HoursSummary.ShowReport;

  // Restore the submitted records in the filter.
  UpdateClassFilter;
end;

procedure TGridForm.TimerTimer(Sender: TObject);
begin
  UpdateTotals;
end;

end.
