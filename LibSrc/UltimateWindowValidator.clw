                              MEMBER

  INCLUDE('UltimateWindowValidator.inc'),ONCE
  INCLUDE('Equates.clw'),ONCE
  INCLUDE('Keycodes.clw'),ONCE

                              MAP
                              END

!==============================================================================
UltimateWindowValidator.Construct PROCEDURE
  CODE
  SELF.ValidatorQueue &= NEW UltimateValueValidatorQueue

!==============================================================================
UltimateWindowValidator.Destruct  PROCEDURE
  CODE
  FREE(SELF.ValidatorQueue)
  DISPOSE(SELF.ValidatorQueue)

!==============================================================================
UltimateWindowValidator.AddValidator  PROCEDURE(UltimateValueValidator Validator)
  CODE
  CLEAR(SELF.ValidatorQueue)
  SELF.ValidatorQueue.Validator &= Validator
  ADD(SELF.ValidatorQueue)
  
!==============================================================================
UltimateWindowValidator.DisplayInvalidMessage PROCEDURE(STRING InvalidMessage)
  CODE
  !Empty virtual
  
!==============================================================================
UltimateWindowValidator.WindowComponent.Kill  PROCEDURE
  CODE
  
!==============================================================================
UltimateWindowValidator.WindowComponent.Reset PROCEDURE(BYTE Force)
  CODE

!==============================================================================
UltimateWindowValidator.WindowComponent.ResetRequired PROCEDURE!,BYTE      ! 1 if reset of window required
  CODE
  RETURN FALSE

!==============================================================================
UltimateWindowValidator.WindowComponent.SetAlerts PROCEDURE
  CODE

!==============================================================================
UltimateWindowValidator.WindowComponent.TakeEvent PROCEDURE!,BYTE
X                                                   LONG,AUTO
ReturnValue                                         BYTE(Level:Benign)
Validator                                           &UltimateValueValidator
FEQ                                                 SIGNED
  CODE
  LOOP X = 1 TO RECORDS(SELF.ValidatorQueue)
    GET(SELF.ValidatorQueue, X)
    Validator &= SELF.ValidatorQueue.Validator
    FEQ        = Validator.GetFEQ()
    IF FIELD() = FEQ
      CASE FIELD(){PROP:Type}
        ;OF CREATE:entry;  DO HandleEntry
        !Add more control types here
      END
      IF ReturnValue <> Level:Benign THEN BREAK.
    END
  END
  RETURN ReturnValue

HandleEntry                   ROUTINE
  DATA
LastInvalidMessage  STRING(200)
  CODE
  CASE EVENT()
  OF EVENT:Selected
    FEQ{PROP:Touched} = TRUE
  OF EVENT:Accepted
    IF Validator.Validate(LastInvalidMessage) <> Record:OK
      IF LastInvalidMessage
        SELF.DisplayInvalidMessage(LastInvalidMessage)
      END
      SELECT(FEQ)
      ReturnValue = Level:Notify
    END
  END

!==============================================================================
UltimateWindowValidator.WindowComponent.Update    PROCEDURE           ! Everything but the window!
  CODE

!==============================================================================
UltimateWindowValidator.WindowComponent.UpdateWindow  PROCEDURE
  CODE

!==============================================================================
