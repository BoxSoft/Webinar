                              MEMBER

  INCLUDE('CL_Property_StringTheory.inc'),ONCE
                                   
                              MAP
                              END

!==============================================================================
!==============================================================================
CL_Property_StringTheory._Create  PROCEDURE(CL_PropertyList _Properties,STRING Name,<STRING Value>)!,*CL_Property_StringTheory
_Property                           &CL_Property_StringTheory
  CODE
  !MUST NOT USE SELF
  _Property &= NEW CL_Property_StringTheory
  IF NOT OMITTED(Value)
    _Property.Set(Value)
  END
  _Properties.Add(_Property.CL_PropertyInterface, Name)
  RETURN _Property

!==============================================================================
CL_Property_StringTheory.Get  PROCEDURE!,STRING
  CODE
  RETURN SELF.GetValue()

!==============================================================================
CL_Property_StringTheory.Set  PROCEDURE(STRING Value)
  CODE
  SELF.SetValue(Value)

!==============================================================================
CL_Property_StringTheory.Set  PROCEDURE(StringTheory Value)
  CODE
  SELF.Set(Value.GetValue())
  
!==============================================================================
CL_Property_StringTheory.Set  PROCEDURE(CL_Property_StringTheory Value)
  CODE
  SELF.Set(Value.Get())

!==============================================================================
!==============================================================================
! This method is used to dispose of a property object that was NEW'ed.
! Do NOT call it for an an object not created with NEW.
CL_Property_StringTheory.CL_PropertyInterface.Destroy PROCEDURE!,BYTE
  CODE
  DISPOSE(SELF)

!==============================================================================
CL_Property_StringTheory.CL_PropertyInterface.GetJsonType PROCEDURE!,BYTE
  CODE
  RETURN CL_Property_JsonType:String

!==============================================================================
CL_Property_StringTheory.CL_PropertyInterface.GetJson PROCEDURE!,STRING
  CODE
  RETURN SELF.Get()

!==============================================================================
CL_Property_StringTheory.CL_PropertyInterface.SetJson PROCEDURE(STRING Value)
  CODE
  SELF.Set(Value)
  
!==============================================================================
