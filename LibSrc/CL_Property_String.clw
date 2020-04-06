                              MEMBER

  INCLUDE('CL_Property_String.inc'),ONCE
                                   
                              MAP
                              END

!==============================================================================
!==============================================================================
CL_Property_String._Create    PROCEDURE(CL_PropertyList _Properties,STRING Name,<STRING Value>)!,*CL_Property_String
_Property                       &CL_Property_String
  CODE
  !MUST NOT USE SELF
  _Property &= NEW CL_Property_String
  IF NOT OMITTED(Value)
    _Property.Set(Value)
  END
  _Properties.Add(_Property.CL_PropertyInterface, Name)
  RETURN _Property

!==============================================================================
CL_Property_String.Destruct   PROCEDURE
  CODE
  DISPOSE(SELF._Value)

!==============================================================================
CL_Property_String.Get        PROCEDURE!,STRING
  CODE
  IF SELF._Value &= NULL
    RETURN ''
  ELSE
    RETURN SELF._Value
  END

!==============================================================================
CL_Property_String.Set        PROCEDURE(STRING Value)
L                               LONG,AUTO
  CODE
  DISPOSE(SELF._Value)
  L = LEN(Value)
  IF L > 0
    SELF._Value &= NEW STRING(L)
    SELF._Value  = Value
  END

!==============================================================================
CL_Property_String.Set        PROCEDURE(CL_Property_String Value)
  CODE
  SELF.Set(Value.Get())

!==============================================================================
!==============================================================================
CL_Property_String.CL_PropertyInterface.GetJsonType   PROCEDURE!,BYTE
  CODE
  RETURN CL_Property_JsonType:String

!==============================================================================
CL_Property_String.CL_PropertyInterface.GetJson   PROCEDURE!,STRING
  CODE
  RETURN SELF.Get()

!==============================================================================
CL_Property_String.CL_PropertyInterface.SetJson   PROCEDURE(STRING Value)
  CODE
  SELF.Set(Value)
  
!==============================================================================
