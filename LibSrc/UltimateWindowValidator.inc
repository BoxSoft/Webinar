!ABCIncludeFile

  INCLUDE('ABWINDOW.INC'),ONCE

UltimateValueValidator        INTERFACE
GetFEQ                          PROCEDURE,SIGNED
Validate                        PROCEDURE(*STRING MessageOUT),BYTE
                              END
            
UltimateValueValidatorQueue   QUEUE,TYPE
Validator                       &UltimateValueValidator
                              END

UltimateWindowValidator       CLASS,TYPE,IMPLEMENTS(WindowComponent),MODULE('UltimateWindowValidator.clw'),LINK('UltimateWindowValidator.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
ValidatorQueue                  &UltimateValueValidatorQueue
Construct                       PROCEDURE
Destruct                        PROCEDURE
AddValidator                    PROCEDURE(UltimateValueValidator Validator)
DisplayInvalidMessage           PROCEDURE(STRING InvalidMessage),VIRTUAL
                              END
