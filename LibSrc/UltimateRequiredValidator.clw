                              MEMBER

  INCLUDE('UltimateRequiredValidator.inc'),ONCE
  INCLUDE('Equates.clw'),ONCE

                              MAP
                              END

!==============================================================================
UltimateRequiredValidator.UltimateValueValidator.Validate  PROCEDURE(*STRING MessageOUT)!,BYTE
  CODE
  IF CONTENTS(SELF.FEQ)
    MessageOUT = ''
    RETURN Record:OK
  ELSE
    MessageOUT = 'Entry is required!'
    RETURN Record:OutOfRange
  END

!==============================================================================
