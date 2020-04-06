                              MEMBER

  INCLUDE('UltimateAbstractValidator.inc'),ONCE
  INCLUDE('Equates.clw'),ONCE

                              MAP
                              END

!==============================================================================
UltimateAbstractValidator.Init    PROCEDURE(SIGNED FEQ,STRING InvalidMessage)
  CODE
  SELF.FEQ            = FEQ
  SELF.InvalidMessage = InvalidMessage

!==============================================================================
UltimateAbstractValidator.UltimateValueValidator.GetFEQ   PROCEDURE!,SIGNED
  CODE
  RETURN SELF.FEQ

!==============================================================================
UltimateAbstractValidator.UltimateValueValidator.Validate PROCEDURE(*STRING MessageOUT)!,BYTE
  CODE
  ASSERT(0, 'UltimateAbstractValidator.UltimateValueValidator.Validate is abstract, and must be derived!')
  MessageOUT = ''
  RETURN Record:OK

!==============================================================================
