                              MEMBER

  INCLUDE('CL_Property_Real.inc'),ONCE
                                   
                              MAP
                              END

!==============================================================================
!==============================================================================
CL_Property_Real._Create      PROCEDURE(CL_PropertyList _Properties,STRING Name,<REAL Value>)!,*CL_Property_Real
_Property                       &CL_Property_Real
  CODE
  !MUST NOT USE SELF
  _Property &= NEW CL_Property_Real
  IF NOT OMITTED(Value)
    _Property.Set(Value)
  END
  _Properties.Add(_Property.CL_PropertyInterface, Name)
  RETURN _Property

!==============================================================================
CL_Property_Real.Get          PROCEDURE!,REAL
  CODE
  RETURN SELF._Value

!==============================================================================
CL_Property_Real.Set          PROCEDURE(REAL Value)
  CODE
  SELF._Value = Value

!==============================================================================
CL_Property_Real.Set          PROCEDURE(CL_Property_Real Value)
  CODE
  SELF.Set(Value.Get())

!==============================================================================
!==============================================================================
CL_Property_Real.CL_PropertyInterface.GetJsonType PROCEDURE!,BYTE
  CODE
  RETURN CL_Property_JsonType:Number

!==============================================================================
CL_Property_Real.CL_PropertyInterface.GetJson PROCEDURE!,STRING
  CODE
  RETURN SELF.Get()

!==============================================================================
CL_Property_Real.CL_PropertyInterface.SetJson PROCEDURE(STRING Value)
  CODE
  SELF.Set(Value)
  
!==============================================================================
