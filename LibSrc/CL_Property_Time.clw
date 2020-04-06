                              MEMBER

  INCLUDE('CL_Property_Time.inc'),ONCE
  INCLUDE('DateTime.equ'),ONCE
                                   
                              MAP
                              END

TimePicture                   CSTRING('@T04')

!==============================================================================
!==============================================================================
CL_Property_Time._Create      PROCEDURE(CL_PropertyList _Properties,STRING Name,<LONG Value>)!,*CL_Property_Time
_Property                       &CL_Property_Time
  CODE
  !MUST NOT USE SELF
  _Property &= NEW CL_Property_Time
  IF NOT OMITTED(Value)
    _Property.Set(Value)
  END
  _Properties.Add(_Property.CL_PropertyInterface, Name)
  RETURN _Property

!==============================================================================
CL_Property_Time.Set          PROCEDURE(CL_Property_Time Value)
  CODE
  SELF.Set(Value.Get())

!==============================================================================
CL_Property_Time.DeformatJson PROCEDURE(STRING Formatted)!,LONG
L                               LONG,AUTO
Approx                          LONG(0)
Cents                           BYTE(0)
  CODE
  L = LEN(Formatted)
  !STOP('L='& L)
  IF L >= 8
    Approx = DEFORMAT(Formatted[1:8], TimePicture)
    !STOP('Approx='& Approx)
    
    IF LEN(Formatted) >= 10 AND Formatted[9] = '.' AND NUMERIC(Formatted[10:L])
      Cents = ROUND(100 * Formatted[9:L], 1)
      !STOP('Formatted[9:'& L &']='& Formatted[9:L])
      !STOP('Cents='& Cents)
    ELSE
      Cents = 0
    END
  END
  RETURN Approx + Cents
  
!==============================================================================
CL_Property_Time.FormatJson   PROCEDURE(<LONG Value>)!,STRING
Formatted                       STRING(8)
Approx                          LONG
Cents                           BYTE
  CODE
  IF OMITTED(Value)
    Value = SELF.Get()
  END
  IF Value >= MIN_TIME
    Formatted = FORMAT(Value, TimePicture)
    Approx    = DEFORMAT(Formatted, TimePicture)
    Cents     = Value - Approx
    IF Cents = 0
      RETURN Formatted
    ELSIF Cents <= 9
      RETURN Formatted & '.0' & Cents
    ELSIF SUB(Cents, 2, 1) = '0'
      RETURN Formatted & '.' & SUB(Cents, 1, 1)
    ELSE
      RETURN Formatted & '.' & Cents
    END
  ELSE
    RETURN 'null'
  END
  
!==============================================================================
CL_Property_Time.FormatTime  PROCEDURE(<BYTE MaxLen>)!,STRING
  CODE
  IF INRANGE(MaxLen, 1, 6)
    RETURN SUB(FORMAT(SELF.Get(), @T3), 1, 5)
  ELSE  
    RETURN LOWER(FORMAT(SELF.Get(), @T3))
  END
  
!==============================================================================
!==============================================================================
CL_Property_Time.CL_PropertyInterface.GetJsonType PROCEDURE!,BYTE
  CODE
  IF SELF.Get() >= TIME:MIDNIGHT
    RETURN CL_Property_JsonType:String
  ELSE
    RETURN CL_Property_JsonType:Null
  END

!==============================================================================
CL_Property_Time.CL_PropertyInterface.GetJson PROCEDURE!,STRING
  CODE
  RETURN SELF.FormatJson()

!==============================================================================
CL_Property_Time.CL_PropertyInterface.SetJson PROCEDURE(STRING Value)
  CODE
  SELF.Set(SELF.DeformatJson(Value))

!==============================================================================
