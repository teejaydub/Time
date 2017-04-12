object HoursData: THoursData
  OldCreateOrder = True
  Height = 309
  HorizontalOffset = 481
  VerticalOffset = 183
  Width = 484
  object HoursSrc: TDatasource
    DataSet = Hours
    left = 224
    top = 82
  end
  object UserInfoSrc: TDatasource
    DataSet = UserInfo
    left = 224
    top = 24
  end
  object Connection: TZConnection
    UTF8StringsAsWideField = False
    PreprepareSQL = False
    Properties.Strings = (
      'PreprepareSQL='
    )
    TransactIsolationLevel = tiRepeatableRead
    Connected = True
    DesignConnection = True
    HostName = 'localhost'
    Port = 0
    Database = 'C:\TJW\Dev\Time\TIME.FDB'
    User = 'tjw'
    Password = 'funstuff'
    Protocol = 'firebird-2.5'
    left = 32
    top = 24
  end
  object UserInfo: TZTable
    Connection = Connection
    TableName = 'USERINFO'
    left = 112
    top = 24
    object UserInfoUSERNAME: TStringField
      DisplayWidth = 80
      FieldKind = fkData
      FieldName = 'USERNAME'
      Index = 0
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = False
      Required = True
      Size = 80
    end
    object UserInfoADDRESS1: TStringField
      DisplayWidth = 80
      FieldKind = fkData
      FieldName = 'ADDRESS1'
      Index = 1
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = False
      Required = False
      Size = 80
    end
    object UserInfoADDRESS2: TStringField
      DisplayWidth = 80
      FieldKind = fkData
      FieldName = 'ADDRESS2'
      Index = 2
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = False
      Required = False
      Size = 80
    end
    object UserInfoADDRESS3: TStringField
      DisplayWidth = 80
      FieldKind = fkData
      FieldName = 'ADDRESS3'
      Index = 3
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = False
      Required = False
      Size = 80
    end
    object UserInfoPHONE: TStringField
      DisplayWidth = 20
      FieldKind = fkData
      FieldName = 'PHONE'
      Index = 4
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = False
      Required = False
    end
    object UserInfoHOURSPERPERIOD: TLongintField
      Alignment = taLeftJustify
      DisplayWidth = 10
      FieldKind = fkData
      FieldName = 'HOURSPERPERIOD'
      Index = 5
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = False
      Required = True
    end
  end
  object TimeSum: TZReadOnlyQuery
    Connection = Connection
    SQL.Strings = (
      'SELECT SUM(NETHOURS)'
      'FROM HOURS'
      'WHERE (:FilterClass = ''N'' OR Class = :Class)'
      'AND FromTime >= :MinDate        '
    )
    Params = <    
      item
        DataType = ftUnknown
        Name = 'FilterClass'
        ParamType = ptUnknown
      end    
      item
        DataType = ftString
        Name = 'Class'
        ParamType = ptUnknown
      end    
      item
        DataType = ftDateTime
        Name = 'MinDate'
        ParamType = ptUnknown
      end>
    left = 112
    top = 200
    ParamData = <    
      item
        DataType = ftUnknown
        Name = 'FilterClass'
        ParamType = ptUnknown
      end    
      item
        DataType = ftString
        Name = 'Class'
        ParamType = ptUnknown
      end    
      item
        DataType = ftDateTime
        Name = 'MinDate'
        ParamType = ptUnknown
      end>
    object TimeSumSUM: TFloatField
      DisplayWidth = 10
      FieldKind = fkData
      FieldName = 'SUM'
      Index = 0
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = True
      Required = False
      MaxValue = 0
      MinValue = 0
      Precision = 2
    end
  end
  object ClassList: TZReadOnlyQuery
    Connection = Connection
    SQL.Strings = (
      'select DISTINCT CLASS FROM HOURS'
      'WHERE CLASS IS NOT NULL'
      '  AND CLASS <> '''''
      '  AND DATEADD(365 DAY TO FROMTIME) > ''NOW'''
      'ORDER BY CLASS'
    )
    Params = <>
    left = 112
    top = 144
    object ClassListCLASS: TStringField
      DisplayWidth = 9
      FieldKind = fkData
      FieldName = 'CLASS'
      Index = 0
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = False
      Required = True
      Size = 9
    end
  end
  object UnsubmittedHours: TZReadOnlyQuery
    Connection = Connection
    SQL.Strings = (
      'SELECT CLASS, SUM(NETHOURS)'
      'FROM HOURS'
      'WHERE SUBMITTED = ''F'' AND PAID = ''F'''
      'GROUP BY CLASS'
      'ORDER BY CLASS'
    )
    Params = <>
    left = 224
    top = 200
  end
  object Hours: TZQuery
    Connection = Connection
    SortedFields = 'FromTime'
    Filtered = True
    AfterApplyUpdates = HoursAfterApplyUpdates
    SQL.Strings = (
      'SELECT * FROM Hours'
      'ORDER BY FromTime'
    )
    Params = <>
    IndexFieldNames = 'FromTime Asc'
    left = 112
    top = 82
    object HoursID: TLargeintField
      DisplayWidth = 10
      FieldKind = fkData
      FieldName = 'ID'
      Index = 0
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = False
      Required = True
    end
    object HoursFROMTIME: TDateTimeField
      DisplayLabel = 'From Time'
      DisplayWidth = 10
      FieldKind = fkData
      FieldName = 'FROMTIME'
      Index = 1
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = False
      Required = True
      DisplayFormat = 'ddddd h:mm am/pm'
    end
    object HoursTOTIME: TDateTimeField
      DisplayLabel = 'To Time'
      DisplayWidth = 10
      FieldKind = fkData
      FieldName = 'TOTIME'
      Index = 2
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = False
      Required = True
      DisplayFormat = 'h:mm am/pm'
    end
    object HoursNETHOURS: TFloatField
      DisplayLabel = 'Hours'
      DisplayWidth = 10
      FieldKind = fkInternalCalc
      FieldName = 'NETHOURS'
      Index = 3
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = False
      Required = False
      DisplayFormat = '#0.00'
      MaxValue = 0
      MinValue = 0
      Precision = 2
    end
    object HoursCLASS: TStringField
      DisplayLabel = 'Class'
      DisplayWidth = 9
      FieldKind = fkData
      FieldName = 'CLASS'
      Index = 4
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = False
      Required = True
      Size = 9
    end
    object HoursDESCRIPTION: TStringField
      DisplayLabel = 'Description'
      DisplayWidth = 50
      FieldKind = fkData
      FieldName = 'DESCRIPTION'
      Index = 5
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = False
      Required = True
      Size = 50
    end
    object HoursSUBMITTED: TStringField
      DisplayLabel = 'Submitted'
      DisplayWidth = 1
      FieldKind = fkData
      FieldName = 'SUBMITTED'
      Index = 6
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = False
      Required = True
      Size = 1
    end
    object HoursPAID: TStringField
      DisplayLabel = 'Paid'
      DisplayWidth = 1
      FieldKind = fkData
      FieldName = 'PAID'
      Index = 7
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = False
      Required = True
      Size = 1
    end
  end
  object LiveHours: TZReadOnlyQuery
    Connection = Connection
    SQL.Strings = (
      'SELECT (DATEDIFF(MINUTE FROM MAX(FromTime) TO current_timestamp) / 60.0000)  AS NetHours'
      'FROM (SELECT * FROM Hours ORDER BY ID DESCENDING ROWS(1))'
      'WHERE ToTime = FromTime'
      'AND Submitted = ''F'''
      'AND DATEDIFF(DAY FROM FromTime To current_date) = 0'
    )
    Params = <>
    left = 328
    top = 200
    object LiveHoursNETHOURS: TFloatField
      DisplayWidth = 10
      FieldKind = fkData
      FieldName = 'NETHOURS'
      Index = 0
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = True
      Required = False
      MaxValue = 0
      MinValue = 0
      Precision = 2
    end
  end
end
