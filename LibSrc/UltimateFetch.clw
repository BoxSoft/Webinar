                              MEMBER

  INCLUDE('UltimateFetch_KeyComponentHandler.inc'),ONCE
  INCLUDE('Errors.clw'),ONCE

                              MAP
                                INCLUDE('UltimateFetch.inc')
FetchEdge                       PROCEDURE(STRING Operation,UltimateFetch_KeyComponentHandler KeyComponentHandler),BYTE,PROC
                              END

!==============================================================================
OmitsSize                     EQUATE(9)
ParmOmitted                   EQUATE('1')
ParmPassed                    EQUATE(' ')

Operation:Get                 EQUATE('G')
Operation:Next                EQUATE('N')
Operation:Previous            EQUATE('P')

!==============================================================================

FileContextGroup              GROUP,TYPE
FileAddress                     LONG
PrimaryKeyRef                   &KEY
KeyComponentHandler             &UltimateFetch_KeyComponentHandler
Filter                          ANY
                              END

FileContextQueue              QUEUE(FileContextGroup),TYPE
                              END

FileContextHandler            CLASS,THREAD
Q                               &FileContextQueue,PROTECTED
Construct                       PROCEDURE
Destruct                        PROCEDURE
DeleteQ                         PROCEDURE
Fetch                           PROCEDURE(FILE File,<*FileContextGroup FileContext_OUT>),BYTE,PROC
GetPrimaryKey                   PROCEDURE(FILE File),*KEY
GetKeyComponentHandler          PROCEDURE(FILE File),*UltimateFetch_KeyComponentHandler
NewKeyComponentHandler          PROCEDURE(FILE File),*UltimateFetch_KeyComponentHandler
SetFilter                       PROCEDURE(FILE File,STRING Filter)
                              END

!==============================================================================
!==============================================================================
FileContextHandler.Construct  PROCEDURE
  CODE
  SELF.Q &= NEW FileContextQueue
  
!==============================================================================
FileContextHandler.Destruct   PROCEDURE
  CODE
  LOOP WHILE RECORDS(SELF.Q)
    GET(SELF.Q, 1)
    SELF.DeleteQ()
  END

!==============================================================================
FileContextHandler.DeleteQ    PROCEDURE
  CODE
  DISPOSE(SELF.Q.KeyComponentHandler)
  SELF.Q.Filter &= NULL
  DELETE(SELF.Q)
  
!==============================================================================
FileContextHandler.Fetch      PROCEDURE(FILE File,<*FileContextGroup FileContext_OUT>)!,BYTE
ReturnValue                     BYTE(Level:Benign)
  CODE
  SELF.Q.FileAddress = ADDRESS(File)
  GET(SELF.Q, SELF.Q.FileAddress)
  IF ERRORCODE() <> NoError
    ReturnValue = Level:Notify
    CLEAR(SELF.Q)
    SELF.Q.FileAddress = ADDRESS(File)
    DO CheckForPrimaryKey
    ADD(SELF.Q)
  END
  IF NOT OMITTED(FileContext_OUT)
    FileContext_OUT = SELF.Q
  END
  RETURN ReturnValue
  
CheckForPrimaryKey            ROUTINE
  DATA
Keys LONG
N    LONG 
Key  &KEY
  CODE
  Keys = File{PROP:Keys}
  LOOP N = 1 TO Keys
    Key &= File{PROP:Key, N}
    IF Key{PROP:Primary}
      SELF.Q.PrimaryKeyRef &= Key
    END
  END

!==============================================================================
FileContextHandler.NewKeyComponentHandler PROCEDURE(FILE File)!,UltimateFetch_KeyComponentHandler
  CODE
  SELF.Fetch(File)
  DISPOSE(SELF.Q.KeyComponentHandler)
  SELF.Q.KeyComponentHandler &= NEW UltimateFetch_KeyComponentHandler
  SELF.Q.Filter               = ''
  PUT(SELF.Q)
  RETURN SELF.Q.KeyComponentHandler

!==============================================================================
FileContextHandler.GetPrimaryKey  PROCEDURE(FILE File)!,*KEY
Key                                 &KEY
  CODE
  IF SELF.Fetch(File) = Level:Benign
    Key &= SELF.Q.PrimaryKeyRef
  END
  RETURN Key

!==============================================================================
FileContextHandler.GetKeyComponentHandler PROCEDURE(FILE File)!,*UltimateFetch_KeyComponentHandler
  CODE
  IF SELF.Fetch(File) <> Level:Benign
    SELF.Q.KeyComponentHandler &= NULL
  END
  RETURN SELF.Q.KeyComponentHandler

!==============================================================================
FileContextHandler.SetFilter  PROCEDURE(FILE File,STRING Filter)
  CODE
  IF SELF.Fetch(File) = Level:Benign
    SELF.Q.Filter = Filter
    PUT(SELF.Q)
  ELSE
    ASSERT(FALSE, 'There is no SELF.Q record for the passed File in call to UltimateFetch/FileContextHandler.SetFilter!')
  END

!==============================================================================
!==============================================================================
FetchPrimary                  PROCEDURE  (FILE File,? Component1,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>)!,BYTE
FileContext                     LIKE(FileContextGroup)
ReturnValue                     BYTE(Level:Notify)
Key                             &KEY
KeyComponentHandler             &UltimateFetch_KeyComponentHandler
  CODE
  FileContextHandler.Fetch(File, FileContext)
  IF NOT FileContext.PrimaryKeyRef &= NULL
    DO FetchRecord
  END
  RETURN ReturnValue

FetchRecord                   ROUTINE
  Key                 &= FileContext.PrimaryKeyRef
  KeyComponentHandler &= FileContextHandler.NewKeyComponentHandler(File)
  DO PassComponentValues
  IF KeyComponentHandler.AreAllValuesPassed()
    GET(File, Key)
    IF ERRORCODE() = NoError
      ReturnValue = Level:Benign
    END
  END

  INCLUDE('UltimateFetch_Routines.clw', 'PassComponentValues')

!==============================================================================
FetchUnique                   PROCEDURE(FILE File,KEY Key,? Component1,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>)!,BYTE
KeyComponentHandler             UltimateFetch_KeyComponentHandler
ReturnValue                     BYTE(Level:Notify)
  CODE
  DO PassComponentValues
  IF KeyComponentHandler.AreAllValuesPassed()
    GET(File, Key)
    IF ERRORCODE() = NoError
      ReturnValue = Level:Benign
    END
  END
  RETURN ReturnValue

  INCLUDE('UltimateFetch_Routines.clw', 'PassComponentValues')

!==============================================================================
FetchFirst                    PROCEDURE(FILE File,KEY Key,<? Component1>,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>)!,BYTE,PROC
KeyComponentHandler             UltimateFetch_KeyComponentHandler
  CODE
  DO PassComponentValues
  RETURN FetchEdge(Operation:Next, KeyComponentHandler)

  INCLUDE('UltimateFetch_Routines.clw', 'PassComponentValues')

!==============================================================================
FetchLast                     PROCEDURE(FILE File,KEY Key,<? Component1>,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>)!,BYTE,PROC
KeyComponentHandler             UltimateFetch_KeyComponentHandler
  CODE
  DO PassComponentValues
  RETURN FetchEdge(Operation:Previous, KeyComponentHandler)

  INCLUDE('UltimateFetch_Routines.clw', 'PassComponentValues')

!==============================================================================
FetchEdge                     PROCEDURE(STRING Operation,UltimateFetch_KeyComponentHandler KeyComponentHandler)!,BYTE
  CODE
  KeyComponentHandler.ClearOmittedComponents(CHOOSE(Operation=Operation:Next, +1, -1))
  SET(KeyComponentHandler.Key, KeyComponentHandler.Key)
  CASE Operation
    ;OF Operation:Next    ;  NEXT    (KeyComponentHandler.File)
    ;OF Operation:Previous;  PREVIOUS(KeyComponentHandler.File)
  END
  IF ERRORCODE() = NoError AND KeyComponentHandler.EqualsPassedValues()
    RETURN Level:Benign
  ELSE
    RETURN Level:Notify
  END

!==============================================================================
SetWhere                      PROCEDURE(FILE File,KEY Key,<? Component1>,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>)
KeyComponentHandler             &UltimateFetch_KeyComponentHandler
  CODE
  KeyComponentHandler &= FileContextHandler.NewKeyComponentHandler(File)
  DO PassComponentValues
  KeyComponentHandler.ClearOmittedComponents(+1) !CHOOSE(Operation=Operation:Next, +1, -1))
  SET(KeyComponentHandler.Key, KeyComponentHandler.Key)

  INCLUDE('UltimateFetch_Routines.clw', 'PassComponentValues')

!==============================================================================
FilterWhere                   PROCEDURE(FILE File,<STRING Filter>)
  CODE
  FileContextHandler.SetFilter(File, Filter)
  
!==============================================================================
NextWhere                     PROCEDURE(FILE File)!,BYTE
FileContext                     LIKE(FileContextGroup)
ReturnValue                     BYTE(Level:Notify)
  CODE
  IF FileContextHandler.Fetch(File, FileContext) = Level:Benign
    LOOP
      NEXT(File)
      IF ERRORCODE() = NoError AND FileContext.KeyComponentHandler.EqualsPassedValues()
        !STOP(EVALUATE(FileContext.Filter) & ' --- '& ERROR())
        IF FileContext.Filter <> '' AND EVALUATE(FileContext.Filter) = FALSE
          CYCLE
        ELSE
          ReturnValue = Level:Benign
          BREAK
        END
      ELSE
        BREAK
      END
    END
  ELSE
    ASSERT(FALSE, 'NextWhere called before SetWhere in UltimateFetch')
  END
  RETURN ReturnValue

!==============================================================================
