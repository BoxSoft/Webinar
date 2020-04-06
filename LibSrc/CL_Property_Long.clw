                              MEMBER

  INCLUDE('CL_Property_Long.inc'),ONCE
                                   
                              MAP
                              END

!==============================================================================
!==============================================================================
CL_Property_Long._Create      PROCEDURE(CL_PropertyList _Properties,STRING Name,<LONG Value>)!,*CL_Property_Long
_Property                       &CL_Property_Long
  CODE
  !MUST NOT USE SELF
  _Property &= NEW CL_Property_Long
  IF NOT OMITTED(Value)
    _Property.Set(Value)
  END
  _Properties.Add(_Property.CL_PropertyInterface, Name)
  RETURN _Property

!==============================================================================
CL_Property_Long.Get          PROCEDURE!,LONG
  CODE
  RETURN SELF._Value

!==============================================================================
CL_Property_Long.Set          PROCEDURE(LONG Value)
  CODE
  SELF._Value = Value

!==============================================================================
CL_Property_Long.Set          PROCEDURE(CL_Property_Long Value)
  CODE
  SELF.Set(Value.Get())

!==============================================================================
!==============================================================================
CL_Property_Long.CL_PropertyInterface.GetJsonType PROCEDURE!,BYTE
  CODE
  RETURN CL_Property_JsonType:Number

!==============================================================================
CL_Property_Long.CL_PropertyInterface.GetJson PROCEDURE!,STRING
  CODE
  RETURN SELF.Get()

!==============================================================================
CL_Property_Long.CL_PropertyInterface.SetJson PROCEDURE(STRING Value)
  CODE
  SELF.Set(Value)
  
!==============================================================================
