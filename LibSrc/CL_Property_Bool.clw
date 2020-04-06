                              MEMBER

  INCLUDE('CL_Property_Bool.inc'),ONCE
                                   
                              MAP
                              END

!==============================================================================
!==============================================================================
CL_Property_Bool._Create      PROCEDURE(CL_PropertyList _Properties,STRING Name,<BOOL Value>)!,*CL_Property_Bool
_Property                       &CL_Property_Bool
  CODE
  !MUST NOT USE SELF
  _Property &= NEW CL_Property_Bool
  IF NOT OMITTED(Value)
    _Property.Set(Value)
  END
  _Properties.Add(_Property.CL_PropertyInterface, Name)
  RETURN _Property

!==============================================================================
CL_Property_Bool.Get          PROCEDURE!,BOOL
  CODE
  RETURN SELF._Value

!==============================================================================
CL_Property_Bool.Set          PROCEDURE(BOOL Value)
  CODE
  IF Value = FALSE
    SELF._Value = FALSE
  ELSE
    SELF._Value = TRUE
  END

!==============================================================================
CL_Property_Bool.Set          PROCEDURE(CL_Property_Bool Value)
  CODE
  SELF.Set(Value.Get())

!==============================================================================
!==============================================================================
CL_Property_Bool.CL_PropertyInterface.GetJsonType PROCEDURE!,STRING
  CODE
  RETURN CL_Property_JsonType:Bool

!==============================================================================
CL_Property_Bool.CL_PropertyInterface.GetJson PROCEDURE!,STRING
  CODE
  IF SELF.Get()
    RETURN 'true'
  ELSE
    RETURN 'false'
  END

!==============================================================================
CL_Property_Bool.CL_PropertyInterface.SetJson PROCEDURE(STRING Value)
  CODE
  CASE UPPER(Value)
  OF 'TRUE' OROF '1'
    SELF.Set(TRUE)
  ELSE
    SELF.Set(FALSE)
  END

!==============================================================================
