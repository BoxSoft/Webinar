                              MEMBER

  INCLUDE('CL_Property_Date.inc'),ONCE
  INCLUDE('DateTime.equ'),ONCE

                                   
                              MAP
                              END

DatePicture                   CSTRING('@D10-')

!==============================================================================
!==============================================================================
CL_Property_Date._Create      PROCEDURE(CL_PropertyList _Properties,STRING Name,<LONG Value>)!,*CL_Property_Date
_Property                       &CL_Property_Date
  CODE
  !MUST NOT USE SELF
  _Property &= NEW CL_Property_Date
  IF NOT OMITTED(Value)
    _Property.Set(Value)
  END
  _Properties.Add(_Property.CL_PropertyInterface, Name)
  RETURN _Property

!==============================================================================
CL_Property_Date.Set          PROCEDURE(CL_Property_Date Value)
  CODE
  SELF._Value = Value.Get()

!==============================================================================
!==============================================================================
CL_Property_Date.CL_PropertyInterface.GetJsonType PROCEDURE!,BYTE
  CODE
  IF SELF.Get() >= MIN_DATE
    RETURN CL_Property_JsonType:String
  ELSE
    RETURN CL_Property_JsonType:Null
  END

!==============================================================================
CL_Property_Date.CL_PropertyInterface.GetJson PROCEDURE!,STRING
  CODE
  IF SELF.Get() >= MIN_DATE
    RETURN FORMAT(SELF.Get(), DatePicture)
  ELSE
    RETURN 'null'
  END

!==============================================================================
CL_Property_Date.CL_PropertyInterface.SetJson PROCEDURE(STRING Value)
_Value                                          LONG,AUTO
  CODE
  _Value = DEFORMAT(Value, DatePicture)
  IF _Value = -1
    SELF.Set(0)
  ELSE
    SELF.Set(_Value)
  END

!==============================================================================
