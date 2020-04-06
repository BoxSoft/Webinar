                              MEMBER

  INCLUDE('CL_Property.inc'),ONCE
                                   
                              MAP
                              END

!==============================================================================
!==============================================================================
CL_Property_Abstract.Destruct PROCEDURE
  CODE
  !Empty Virtual

!==============================================================================
!==============================================================================
! This method is used to dispose of a property object that was NEW'ed.
! Do NOT call it for an an object not created with NEW.
CL_Property_Abstract.CL_PropertyInterface.Destroy PROCEDURE
  CODE
  DISPOSE(SELF)
  
!==============================================================================
CL_Property_Abstract.CL_PropertyInterface.GetJsonType PROCEDURE!,BYTE
  CODE
  RETURN CL_Property_JsonType:Null

!==============================================================================
CL_Property_Abstract.CL_PropertyInterface.GetJson PROCEDURE!,STRING
  CODE
  !Empty Virtual
  RETURN ''

!==============================================================================
CL_Property_Abstract.CL_PropertyInterface.SetJson PROCEDURE(STRING Value)
  CODE
  !Empty Virtual
  
!==============================================================================
