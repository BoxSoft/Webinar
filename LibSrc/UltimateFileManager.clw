                              MEMBER

  INCLUDE('UltimateFileManager.inc'),ONCE
  INCLUDE('Equates.clw'),ONCE
  INCLUDE('Keycodes.clw'),ONCE

  PRAGMA('project(#compile UltimateFetch.clw)')
                              MAP
                                MODULE('UltimateFetch.clw')
                                  INCLUDE('UltimateFetch.inc')
                                END
                              END

!==============================================================================
!UltimateFileManager.Construct           PROCEDURE
!  CODE
!
!==============================================================================
!UltimateFileManager.Destruct            PROCEDURE
!  CODE
!
!==============================================================================
UltimateFileManager.Fetch     PROCEDURE(KEY Key,? Component1,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>)!,BYTE
ReturnValue                     BYTE,AUTO
  CODE
  IF    OMITTED(Component2) THEN ReturnValue = FetchUnique(SELF.File, Key, Component1)
  ELSIF OMITTED(Component3) THEN ReturnValue = FetchUnique(SELF.File, Key, Component1, Component2)
  ELSIF OMITTED(Component4) THEN ReturnValue = FetchUnique(SELF.File, Key, Component1, Component2, Component3)
  ELSIF OMITTED(Component5) THEN ReturnValue = FetchUnique(SELF.File, Key, Component1, Component2, Component3, Component4)
  ELSIF OMITTED(Component6) THEN ReturnValue = FetchUnique(SELF.File, Key, Component1, Component2, Component3, Component4, Component5)
  ELSIF OMITTED(Component7) THEN ReturnValue = FetchUnique(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6)
  ELSIF OMITTED(Component8) THEN ReturnValue = FetchUnique(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7)
  ELSIF OMITTED(Component9) THEN ReturnValue = FetchUnique(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7, Component8)
  ELSE                           ReturnValue = FetchUnique(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7, Component8, Component9)
  END
  IF ReturnValue <> Level:Benign
    CLEAR(SELF.File)
  END
  RETURN ReturnValue

!==============================================================================
UltimateFileManager.TryFetch  PROCEDURE(KEY Key,? Component1,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>)!,BYTE
ReturnValue                     BYTE(Level:Fatal)
  CODE
  IF    OMITTED(Component2) THEN ReturnValue = FetchUnique(SELF.File, Key, Component1)
  ELSIF OMITTED(Component3) THEN ReturnValue = FetchUnique(SELF.File, Key, Component1, Component2)
  ELSIF OMITTED(Component4) THEN ReturnValue = FetchUnique(SELF.File, Key, Component1, Component2, Component3)
  ELSIF OMITTED(Component5) THEN ReturnValue = FetchUnique(SELF.File, Key, Component1, Component2, Component3, Component4)
  ELSIF OMITTED(Component6) THEN ReturnValue = FetchUnique(SELF.File, Key, Component1, Component2, Component3, Component4, Component5)
  ELSIF OMITTED(Component7) THEN ReturnValue = FetchUnique(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6)
  ELSIF OMITTED(Component8) THEN ReturnValue = FetchUnique(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7)
  ELSIF OMITTED(Component9) THEN ReturnValue = FetchUnique(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7, Component8)
  ELSE                           ReturnValue = FetchUnique(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7, Component8, Component9)
  END
  RETURN ReturnValue

!==============================================================================
UltimateFileManager.FetchPrimary  PROCEDURE(? Component1,<? Component2>,<? Component3>)!,BYTE
ReturnValue                         BYTE(Level:Fatal)
  CODE
  IF SELF.HasPrimaryKey()
    IF    OMITTED(Component2) THEN ReturnValue = FetchUnique(SELF.File, SELF.PrimaryKeyRef, Component1)
    ELSIF OMITTED(Component3) THEN ReturnValue = FetchUnique(SELF.File, SELF.PrimaryKeyRef, Component1, Component2)
    ELSE                           ReturnValue = FetchUnique(SELF.File, SELF.PrimaryKeyRef, Component1, Component2, Component3)
    END
  ELSE
    ASSERT(FALSE, 'FetchPrimary: There is no primary key for '& NAME(SELF.File))
    RETURN Level:Fatal
  END
  IF ReturnValue <> Level:Benign
    CLEAR(SELF.File)
  END
  RETURN ReturnValue
  
!==============================================================================
UltimateFileManager.TryFetchPrimary   PROCEDURE(? Component1,<? Component2>,<? Component3>)!,BYTE
ReturnValue                             BYTE(Level:Fatal)
  CODE
  IF SELF.HasPrimaryKey()
    IF    OMITTED(Component2) THEN ReturnValue = FetchUnique(SELF.File, SELF.PrimaryKeyRef, Component1)
    ELSIF OMITTED(Component3) THEN ReturnValue = FetchUnique(SELF.File, SELF.PrimaryKeyRef, Component1, Component2)
    ELSE                           ReturnValue = FetchUnique(SELF.File, SELF.PrimaryKeyRef, Component1, Component2, Component3)
    END
  ELSE
    ASSERT(FALSE, 'TryFetchPrimary: There is no primary key for '& NAME(SELF.File))
    ReturnValue = Level:Fatal
  END
  RETURN ReturnValue

!==============================================================================
UltimateFileManager.FetchFirst    PROCEDURE(KEY Key,<? Component1>,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>)!,BYTE
ReturnValue                         BYTE(Level:Fatal)
  CODE
  IF    OMITTED(Component1) THEN ReturnValue = FetchFirst(SELF.File, Key)
  ELSIF OMITTED(Component2) THEN ReturnValue = FetchFirst(SELF.File, Key, Component1)
  ELSIF OMITTED(Component3) THEN ReturnValue = FetchFirst(SELF.File, Key, Component1, Component2)
  ELSIF OMITTED(Component4) THEN ReturnValue = FetchFirst(SELF.File, Key, Component1, Component2, Component3)
  ELSIF OMITTED(Component5) THEN ReturnValue = FetchFirst(SELF.File, Key, Component1, Component2, Component3, Component4)
  ELSIF OMITTED(Component6) THEN ReturnValue = FetchFirst(SELF.File, Key, Component1, Component2, Component3, Component4, Component5)
  ELSIF OMITTED(Component7) THEN ReturnValue = FetchFirst(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6)
  ELSIF OMITTED(Component8) THEN ReturnValue = FetchFirst(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7)
  ELSIF OMITTED(Component9) THEN ReturnValue = FetchFirst(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7, Component8)
  ELSE                           ReturnValue = FetchFirst(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7, Component8, Component9)
  END
  IF ReturnValue <> Level:Benign
    CLEAR(SELF.File)
  END
  RETURN ReturnValue
  
!==============================================================================
UltimateFileManager.TryFetchFirst PROCEDURE(KEY Key,<? Component1>,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>)!,BYTE
ReturnValue                         BYTE(Level:Fatal)
  CODE
  IF    OMITTED(Component1) THEN ReturnValue = FetchFirst(SELF.File, Key)
  ELSIF OMITTED(Component2) THEN ReturnValue = FetchFirst(SELF.File, Key, Component1)
  ELSIF OMITTED(Component3) THEN ReturnValue = FetchFirst(SELF.File, Key, Component1, Component2)
  ELSIF OMITTED(Component4) THEN ReturnValue = FetchFirst(SELF.File, Key, Component1, Component2, Component3)
  ELSIF OMITTED(Component5) THEN ReturnValue = FetchFirst(SELF.File, Key, Component1, Component2, Component3, Component4)
  ELSIF OMITTED(Component6) THEN ReturnValue = FetchFirst(SELF.File, Key, Component1, Component2, Component3, Component4, Component5)
  ELSIF OMITTED(Component7) THEN ReturnValue = FetchFirst(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6)
  ELSIF OMITTED(Component8) THEN ReturnValue = FetchFirst(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7)
  ELSIF OMITTED(Component9) THEN ReturnValue = FetchFirst(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7, Component8)
  ELSE                           ReturnValue = FetchFirst(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7, Component8, Component9)
  END
  RETURN ReturnValue
  
!==============================================================================
UltimateFileManager.FetchLast PROCEDURE(KEY Key,<? Component1>,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>)!,BYTE
ReturnValue                     BYTE(Level:Fatal)
  CODE
  IF    OMITTED(Component1) THEN ReturnValue = FetchLast(SELF.File, Key)
  ELSIF OMITTED(Component2) THEN ReturnValue = FetchLast(SELF.File, Key, Component1)
  ELSIF OMITTED(Component3) THEN ReturnValue = FetchLast(SELF.File, Key, Component1, Component2)
  ELSIF OMITTED(Component4) THEN ReturnValue = FetchLast(SELF.File, Key, Component1, Component2, Component3)
  ELSIF OMITTED(Component5) THEN ReturnValue = FetchLast(SELF.File, Key, Component1, Component2, Component3, Component4)
  ELSIF OMITTED(Component6) THEN ReturnValue = FetchLast(SELF.File, Key, Component1, Component2, Component3, Component4, Component5)
  ELSIF OMITTED(Component7) THEN ReturnValue = FetchLast(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6)
  ELSIF OMITTED(Component8) THEN ReturnValue = FetchLast(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7)
  ELSIF OMITTED(Component9) THEN ReturnValue = FetchLast(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7, Component8)
  ELSE                           ReturnValue = FetchLast(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7, Component8, Component9)
  END
  IF ReturnValue <> Level:Benign
    CLEAR(SELF.File)
  END
  RETURN ReturnValue
  
!==============================================================================
UltimateFileManager.TryFetchLast  PROCEDURE(KEY Key,<? Component1>,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>)!,BYTE
ReturnValue                         BYTE(Level:Fatal)
  CODE
  IF    OMITTED(Component1) THEN ReturnValue = FetchLast(SELF.File, Key)
  ELSIF OMITTED(Component2) THEN ReturnValue = FetchLast(SELF.File, Key, Component1)
  ELSIF OMITTED(Component3) THEN ReturnValue = FetchLast(SELF.File, Key, Component1, Component2)
  ELSIF OMITTED(Component4) THEN ReturnValue = FetchLast(SELF.File, Key, Component1, Component2, Component3)
  ELSIF OMITTED(Component5) THEN ReturnValue = FetchLast(SELF.File, Key, Component1, Component2, Component3, Component4)
  ELSIF OMITTED(Component6) THEN ReturnValue = FetchLast(SELF.File, Key, Component1, Component2, Component3, Component4, Component5)
  ELSIF OMITTED(Component7) THEN ReturnValue = FetchLast(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6)
  ELSIF OMITTED(Component8) THEN ReturnValue = FetchLast(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7)
  ELSIF OMITTED(Component9) THEN ReturnValue = FetchLast(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7, Component8)
  ELSE                           ReturnValue = FetchLast(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7, Component8, Component9)
  END
  RETURN ReturnValue
  
!==============================================================================
UltimateFileManager.SetWhere  PROCEDURE(KEY Key,<? Component1>,<? Component2>,<? Component3>,<? Component4>,<? Component5>,<? Component6>,<? Component7>,<? Component8>,<? Component9>)
  CODE
  IF    OMITTED(Component1) THEN SetWhere(SELF.File, Key)
  ELSIF OMITTED(Component2) THEN SetWhere(SELF.File, Key, Component1)
  ELSIF OMITTED(Component3) THEN SetWhere(SELF.File, Key, Component1, Component2)
  ELSIF OMITTED(Component4) THEN SetWhere(SELF.File, Key, Component1, Component2, Component3)
  ELSIF OMITTED(Component5) THEN SetWhere(SELF.File, Key, Component1, Component2, Component3, Component4)
  ELSIF OMITTED(Component6) THEN SetWhere(SELF.File, Key, Component1, Component2, Component3, Component4, Component5)
  ELSIF OMITTED(Component7) THEN SetWhere(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6)
  ELSIF OMITTED(Component8) THEN SetWhere(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7)
  ELSIF OMITTED(Component9) THEN SetWhere(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7, Component8)
  ELSE                           SetWhere(SELF.File, Key, Component1, Component2, Component3, Component4, Component5, Component6, Component7, Component8, Component9)
  END
  
!==============================================================================
UltimateFileManager.FilterWhere   PROCEDURE(<STRING Filter>)
  CODE
  FilterWhere(SELF.File, Filter)

!==============================================================================
UltimateFileManager.NextWhere PROCEDURE!,BYTE
  CODE
  RETURN NextWhere(SELF.File)
  
!==============================================================================
UltimateFileManager.HasPrimaryKey PROCEDURE!,BOOL
  CODE
  IF SELF.PrimaryKey = 0
    RETURN FALSE
  ELSE
    IF SELF.PrimaryKeyRef &= NULL
      SELF.PrimaryKeyRef &= SELF.File{PROP:Key, SELF.PrimaryKey}
    END
    RETURN TRUE
  END

! IF k{PROP:Primary}

!==============================================================================
