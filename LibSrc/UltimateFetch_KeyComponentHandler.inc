!ABCIncludeFile

UltimateFetch_KeyComponentQueue   QUEUE,TYPE
FieldRef                            ANY
Ascending                           BOOL
Value                               ANY
                                  END

UltimateFetch_KeyComponentHandler CLASS,TYPE,MODULE('UltimateFetch_KeyComponentHandler.clw'),LINK('UltimateFetch_KeyComponentHandler.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
File                                &FILE
Key                                 &KEY
Q                                   &UltimateFetch_KeyComponentQueue,PROTECTED
Rec                                 &GROUP
Components                          BYTE
PassedValues                        BYTE

Construct                           PROCEDURE
Destruct                            PROCEDURE
Init                                PROCEDURE(FILE File,KEY Key)
PassComponentValue                  PROCEDURE(? Value)
AreAllValuesPassed                  PROCEDURE,BOOL
IsValueOmitted                      PROCEDURE(BYTE ComponentNo),BOOL
GetValue                            PROCEDURE(BYTE ComponentNo),?
SetOrClearField                     PROCEDURE(SHORT Direction,BYTE ParmNo)
ClearOmittedComponents              PROCEDURE(SHORT Direction)
EqualsPassedValues                  PROCEDURE,BOOL
                                  END
