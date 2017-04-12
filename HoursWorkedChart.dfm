object HoursWorkedForm: THoursWorkedForm
  Left = 0
  Top = 0
  Caption = 'HoursWorkedForm'
  ClientHeight = 456
  ClientWidth = 659
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBChart1: TDBChart
    Left = 0
    Top = 0
    Width = 659
    Height = 456
    Title.Text.Strings = (
      'TDBChart')
    SeriesGroups = <
      item
        Name = 'Group1'
      end>
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 235
    ExplicitWidth = 300
    ExplicitHeight = 400
    ColorPaletteIndex = 2
    object Series1: TBarSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Visible = False
      DataSource = HoursData.Hours
      XLabelsSource = '#DAY#FromTime'
      Gradient.Direction = gdTopBottom
      MultiBar = mbStacked
      Shadow.Color = 8487297
      XValues.DateTime = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      XValues.ValueSource = 'FromTime'
      YValues.Name = 'Bar'
      YValues.Order = loNone
      YValues.ValueSource = '#SUM#HoursWorked'
    end
    object Series2: TBarSeries
      Active = False
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Visible = False
      DataSource = DBCrossTabSource1
      Gradient.Direction = gdTopBottom
      MultiBar = mbStacked
      Shadow.Color = 8553090
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object DBCrossTabSource1: TDBCrossTabSource
    Active = True
    DataSet = HoursData.Hours
    Formula = gfCount
    GroupField = 'Class'
    LabelField = 'FromTime'
    Series = Series2
    ValueField = 'HoursWorked'
  end
end
