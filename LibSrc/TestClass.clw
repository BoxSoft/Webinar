                                        MEMBER()
        omit('***',_c55_)
_ABCDllMode_        EQUATE(0)
_ABCLinkMode_       EQUATE(1)
        ***
!
!--------------------------
!ClarionLive! Basic Class Template
!--------------------------

        INCLUDE('EQUATES.CLW')
        INCLUDE('TestClass.INC'),ONCE

                                        MAP
                                        END


!-----------------------------------
TestClass.Init       PROCEDURE()
!-----------------------------------

        CODE

                SELF.InDebug = FALSE

                RETURN

!-----------------------------------
TestClass.Kill       PROCEDURE()
!-----------------------------------

        CODE

                RETURN

!-----------------------------------------
TestClass.HelloWorld PROCEDURE()
!-----------------------------------------

        CODE

                BEEP(BEEP:SystemAsterisk)
                MESSAGE('Hello World From Clarion Live', 'Hello', ICON:ASTERISK)

                SELF.RaiseError('Display some kind of Error (only in Debug Mode)')

                RETURN

!---------------------------------------------------------
TestClass.RaiseError PROCEDURE(STRING pErrorMsg)
!---------------------------------------------------------

        CODE

                IF SELF.InDebug = TRUE
                        BEEP(BEEP:SystemExclamation)
                        MESSAGE(CLIP(pErrorMsg), 'ClarionLive Error', ICON:EXCLAMATION)
                END

                RETURN


!-----------------------------------------------------------------------
!.Construct - This procedure is recommended
!-----------------------------------------------------------------------
!----------------------------------------
TestClass.Construct  PROCEDURE()
!----------------------------------------
        CODE

                RETURN


!-----------------------------------------------------------------------
!.Destruct - This procedure is recommended
!-----------------------------------------------------------------------
!---------------------------------------
TestClass.Destruct   PROCEDURE()
!---------------------------------------
        CODE

                RETURN


!-----------------------------------------------------------------------
! NOTES:
! Construct procedure executes automatically at the beginning of each procedure
! Destruct procedure executes automatically at the end of each procedure
! Construct/Destruct Procedures are implicit under the hood but don't have to be declared in the class as such if there is no need.
! It's ok to have them there for good measure, although some programmers only include them as needed.
! Normally some prefer Init() and Kill(),  but Destruct() can be handy to DISPOSE of stuff (to avoid mem leak)
!-----------------------------------------------------------------------
