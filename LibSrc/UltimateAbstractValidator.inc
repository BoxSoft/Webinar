!ABCIncludeFile

  INCLUDE('UltimateWindowValidator.inc'),ONCE

UltimateAbstractValidator     CLASS,TYPE,IMPLEMENTS(UltimateValueValidator),MODULE('UltimateAbstractValidator.clw'),LINK('UltimateAbstractValidator.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
FEQ                             SIGNED
InvalidMessage                  STRING(200)
Init                            PROCEDURE(SIGNED FEQ,STRING InvalidMessage)
                              END
