                              MEMBER

  INCLUDE('CL_Property_Byte.inc'),ONCE
                                   
                              MAP
                              END

!==============================================================================
!==============================================================================
CL_Property_Byte._Create      PROCEDURE(CL_PropertyList _Properties,STRING Name,<BYTE Value>)!,*CL_Property_Byte
_Property                       &CL_Property_Byte
  CODE
  !MUST NOT USE SELF
  _Property &= NEW CL_Property_Byte
  IF NOT OMITTED(Value)
    _Property.Set(Value)
  END
  _Properties.Add(_Property.CL_PropertyInterface, Name)
  RETURN _Property

!==============================================================================
CL_Property_Byte.Get          PROCEDURE!,BYTE
  CODE
  RETURN SELF._Value

!==============================================================================
CL_Property_Byte.Set          PROCEDURE(BYTE Value)
  CODE
  SELF._Value = Value

!==============================================================================
CL_Property_Byte.Set          PROCEDURE(CL_Property_Byte Value)
  CODE
  SELF.Set(Value.Get())

!==============================================================================
!==============================================================================
CL_Property_Byte.CL_PropertyInterface.GetJsonType PROCEDURE!,STRING
  CODE
  RETURN CL_Property_JsonType:Number

!==============================================================================
CL_Property_Byte.CL_PropertyInterface.GetJson PROCEDURE!,STRING
  CODE
  RETURN SELF.Get()

!==============================================================================
CL_Property_Byte.CL_PropertyInterface.SetJson PROCEDURE(STRING Value)
  CODE
  SELF.Set(Value)

!==============================================================================
