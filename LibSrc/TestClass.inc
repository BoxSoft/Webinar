        OMIT('_EndOfInclude_',_IFDef_TestClass_)
_IFDef_TestClass_            EQUATE(1)
!
!--------------------------
!Created From ClarionLive! Basic Class Template
!--------------------------
!--------------------------------------------------------------------------------
!Category: Clarion Live!
!--------------------------------------------------------------------------------
! Skelton Class used to begin building your own classes with!
! The OMIT at the top is used to load the class only once, so you do not have to use the "once" statement when you INCLUDE the class in your global includes
!
!--------------------------------------------------------------------------------
TestClass    CLASS,TYPE,MODULE('TestClass.CLW'),LINK('TestClass.CLW',_ABCLinkMode_),DLL(_ABCDllMode_)
!
!--------------------------------------------------------------------------------
! Add properties here, which are variables
!--------------------------------------------------------------------------------
!Properties
!----------
InDebug                 BYTE
!
!--------------------------------------------------------------------------------
! Add Methods here, which are just procedures or functions
!--------------------------------------------------------------------------------
!Methods
!-------
Init                    PROCEDURE()
Kill                    PROCEDURE()
HelloWorld              PROCEDURE()
RaiseError              PROCEDURE(STRING pErrorMsg)
Construct               PROCEDURE()
Destruct                PROCEDURE()
                                        END
        _EndOfInclude_
