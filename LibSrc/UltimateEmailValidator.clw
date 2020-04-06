                              MEMBER

  INCLUDE('UltimateEmailValidator.inc'),ONCE
  INCLUDE('Equates.clw'),ONCE
  INCLUDE('Keycodes.clw'),ONCE

                              MAP
                              END

!==============================================================================
UltimateEmailValidator.UltimateValueValidator.Validate    PROCEDURE(*STRING MessageOUT)!,BYTE
  CODE
  IF MATCH(CONTENTS(SELF.FEQ), '^[-A-Za-z0-9._]+@{{[-A-Za-z0-9._]+\.}+[A-Za-z][A-Za-z]+$', Match:Regular)
    MessageOUT = ''
    RETURN Record:OK
  ELSE
    MessageOUT = 'Email is incorrect format!'
    RETURN Record:OutOfRange
  END

!==============================================================================
