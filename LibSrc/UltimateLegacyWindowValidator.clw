                              MEMBER

  INCLUDE('UltimateLegacyWindowValidator.inc'),ONCE
  INCLUDE('Equates.clw'),ONCE
  INCLUDE('Keycodes.clw'),ONCE

                              MAP
                              END

WCType                        EQUATE(UNSIGNED)

ComponentList                 QUEUE,TYPE
WC                              &WindowComponent                        ! all must be a derivative of WindowComponent
                              END

!==============================================================================
UltimateLegacyWindowValidator.Construct           PROCEDURE
  CODE
  SELF.CL &= NEW ComponentList     ! Kill method assumes this will always happen in init

!==============================================================================
UltimateLegacyWindowValidator.Destruct            PROCEDURE
cur                                                 &WindowComponent,auto
  CODE
  LOOP WHILE (RECORDS(SELF.Cl) <> 0)
    GET(SELF.Cl,1)
    cur &= SELF.Cl.WC
    DELETE(SELF.Cl)
    cur.Kill()
  END

!==============================================================================
UltimateLegacyWindowValidator.AddItem         PROCEDURE(WindowComponent WC)
  CODE
  ASSERT(~SELF.CL&=NULL)
  SELF.CL.WC &= WC
  ADD(SELF.CL)
  ASSERT(~ERRORCODE())

!==============================================================================
UltimateLegacyWindowValidator.TakeEvent   PROCEDURE!,BYTE
RVal                                        BYTE(Level:Benign)
I                                           UNSIGNED,AUTO
  CODE
  LOOP I = 1 TO RECORDS(SELF.CL)
    GET(SELF.CL,I)
    RVal = SELF.CL.WC.TakeEvent()
    IF RVal <> Level:Benign THEN BREAK.
  END
  RETURN RVal
  
!==============================================================================
