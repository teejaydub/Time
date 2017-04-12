object UserInfoForm: TUserInfoForm
  Left = 288
  Height = 201
  Top = 251
  Width = 349
  Caption = 'User Information'
  ClientHeight = 201
  ClientWidth = 349
  Color = clBtnFace
  OnShow = FormShow
  ParentFont = True
  Position = poScreenCenter
  LCLVersion = '1.0.1.3'
  object Label1: TLabel
    Left = 8
    Height = 13
    Top = 19
    Width = 124
    AutoSize = False
    Caption = '&Name:'
    FocusControl = EditUserName
    ParentColor = False
  end
  object Label2: TLabel
    Left = 8
    Height = 13
    Top = 41
    Width = 124
    AutoSize = False
    Caption = 'Address &1:'
    FocusControl = EditAddress
    ParentColor = False
  end
  object Label3: TLabel
    Left = 8
    Height = 13
    Top = 63
    Width = 124
    AutoSize = False
    Caption = 'Address &2:'
    FocusControl = EditAddress2
    ParentColor = False
  end
  object Label4: TLabel
    Left = 8
    Height = 13
    Top = 85
    Width = 124
    AutoSize = False
    Caption = 'Address &3:'
    FocusControl = EditAddress3
    ParentColor = False
  end
  object Label5: TLabel
    Left = 8
    Height = 13
    Top = 107
    Width = 124
    AutoSize = False
    Caption = '&Phone:'
    FocusControl = EditPhone
    ParentColor = False
  end
  object Label6: TLabel
    Left = 8
    Height = 18
    Top = 137
    Width = 124
    AutoSize = False
    Caption = '&Hours per pay period:'
    FocusControl = EditHoursPerPeriod
    ParentColor = False
  end
  object EditUserName: TDBEdit
    Left = 144
    Height = 23
    Top = 16
    Width = 200
    DataField = 'UserName'
    DataSource = HoursData.UserInfoSrc
    CharCase = ecNormal
    MaxLength = 0
    TabOrder = 0
  end
  object EditAddress: TDBEdit
    Left = 144
    Height = 23
    Top = 38
    Width = 200
    DataField = 'Address1'
    DataSource = HoursData.UserInfoSrc
    CharCase = ecNormal
    MaxLength = 0
    TabOrder = 1
  end
  object EditAddress2: TDBEdit
    Left = 144
    Height = 23
    Top = 60
    Width = 200
    DataField = 'Address2'
    DataSource = HoursData.UserInfoSrc
    CharCase = ecNormal
    MaxLength = 0
    TabOrder = 2
  end
  object EditAddress3: TDBEdit
    Left = 144
    Height = 23
    Top = 82
    Width = 200
    DataField = 'Address3'
    DataSource = HoursData.UserInfoSrc
    CharCase = ecNormal
    MaxLength = 0
    TabOrder = 3
  end
  object EditPhone: TDBEdit
    Left = 144
    Height = 23
    Top = 104
    Width = 115
    DataField = 'Phone'
    DataSource = HoursData.UserInfoSrc
    CharCase = ecNormal
    MaxLength = 0
    TabOrder = 4
  end
  object EditHoursPerPeriod: TDBEdit
    Left = 144
    Height = 23
    Top = 134
    Width = 55
    DataField = 'HoursPerPeriod'
    DataSource = HoursData.UserInfoSrc
    CharCase = ecNormal
    MaxLength = 0
    TabOrder = 5
  end
  object OK: TButton
    Left = 97
    Height = 25
    Top = 168
    Width = 75
    Caption = 'OK'
    Default = True
    ModalResult = 1
    OnClick = OKClick
    TabOrder = 6
  end
  object Cancel: TButton
    Left = 177
    Height = 25
    Top = 168
    Width = 75
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    OnClick = CancelClick
    TabOrder = 7
  end
end
