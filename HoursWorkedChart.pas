unit HoursWorkedChart;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, ExtCtrls, TeeProcs, Chart, DBChart, TeeDBEdit,
  TeeDBCrossTab;

type
  THoursWorkedForm = class(TForm)
    DBChart1: TDBChart;
    Series1: TBarSeries;
    Series2: TBarSeries;
    DBCrossTabSource1: TDBCrossTabSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HoursWorkedForm: THoursWorkedForm;

implementation

uses DataForm;

{$R *.dfm}

end.
