                              MEMBER

  INCLUDE('UltimateFetch_KeyComponentHandler.inc'),ONCE
  INCLUDE('Equates.clw'),ONCE
  INCLUDE('Keycodes.clw'),ONCE

                              MAP
                              END

!==============================================================================
UltimateFetch_KeyComponentHandler.Construct   PROCEDURE
  CODE
  SELF.Q &= NEW UltimateFetch_KeyComponentQueue
  
!==============================================================================
UltimateFetch_KeyComponentHandler.Destruct    PROCEDURE
  CODE
  LOOP WHILE RECORDS(SELF.Q)
    GET(SELF.Q, 1)
    SELF.Q.FieldRef &= NULL
    SELF.Q.Value    &= NULL
    DELETE(SELF.Q)
  END
  DISPOSE(SELF.Q)

!==============================================================================
UltimateFetch_KeyComponentHandler.Init    PROCEDURE(FILE File,KEY Key)
  CODE
  DO ValidateKey
  SELF.File     &= File
  SELF.Key      &= Key
  SELF.Components = Key{PROP:Components}
  SELF.Rec      &= File{PROP:Record}
  DO AddComponenents

!--------------------------------------
ValidateKey                   ROUTINE
  DATA
Keys    LONG
KeyNo   LONG
ThisKey &KEY
  CODE
  Keys = File{PROP:Keys}
  IF Keys > 0
    LOOP KeyNo = 1 TO Keys
      ThisKey &= File{PROP:Key, KeyNo}
      IF ThisKey &= Key
        EXIT
      END
    END
  END
  ASSERT(FALSE, 'Key does not belong to File ('& File{PROP:Name} &') in call to UltimateFetch_KeyComponentHandler!')

!--------------------------------------
AddComponenents               ROUTINE
  DATA
ComponentNo LONG,AUTO
  CODE
  LOOP ComponentNo = 1 TO SELF.Components
    CLEAR(SELF.Q)
    SELF.Q.FieldRef &= WHAT(SELF.Rec, Key{PROP:Field, ComponentNo})
    SELF.Q.Ascending = CHOOSE(Key{PROP:Ascending, ComponentNo})
    ADD(SELF.Q)
  END

!==============================================================================
UltimateFetch_KeyComponentHandler.PassComponentValue  PROCEDURE(? Value)
  CODE
  IF SELF.PassedValues < SELF.Components
    SELF.PassedValues += 1
    GET(SELF.Q, SELF.PassedValues)
    SELF.Q.FieldRef = Value  !Assign the value to the key component
    SELF.Q.Value    = Value  !Remember the value
    PUT(SELF.Q)
  ELSE
    ASSERT(FALSE, 'Key has only '& SELF.Components &' component field'& CHOOSE(SELF.Components=1, '', 's') &'.  Too many values specified via UltimateFetch_KeyComponentHandler.AddPassedValue!')
  END
  
!==============================================================================
UltimateFetch_KeyComponentHandler.AreAllValuesPassed  PROCEDURE!,BOOL
  CODE
  RETURN CHOOSE(SELF.PassedValues = RECORDS(SELF.Q))

!==============================================================================
UltimateFetch_KeyComponentHandler.IsValueOmitted  PROCEDURE(BYTE ComponentNo)!,BOOL
  CODE
  RETURN CHOOSE(ComponentNo > SELF.PassedValues)
  
!==============================================================================
UltimateFetch_KeyComponentHandler.GetValue    PROCEDURE(BYTE ComponentNo)!,?
  CODE
  IF INRANGE(ComponentNo, 1, SELF.PassedValues)
    GET(SELF.Q, ComponentNo)
    RETURN SELF.Q.Value
  ELSE
    ASSERT(FALSE, 'There is no ComponentNo='& ComponentNo &' in call to UltimateFetch_KeyComponentHandler.GetValue!')
    RETURN ''
  END
  
!==============================================================================
UltimateFetch_KeyComponentHandler.SetOrClearField PROCEDURE(SHORT Direction,BYTE ComponentNo)
  CODE
  IF INRANGE(ComponentNo, 1, SELF.Components)
    GET(SELF.Q, ComponentNo)
    IF ComponentNo <= SELF.PassedValues
      SELF.Q.FieldRef = SELF.Q.Value
    ELSIF SELF.Q.Ascending
      CLEAR(SELF.Q.FieldRef, CHOOSE(Direction>0, -1, +1))
    ELSE
      CLEAR(SELF.Q.FieldRef, CHOOSE(Direction>0, +1, -1))
    END
  ELSE
    ASSERT(FALSE, 'There is no ComponentNo='& ComponentNo &' in call to UltimateFetch_KeyComponentHandler.SetOrClearField!')
  END
  
!==============================================================================
UltimateFetch_KeyComponentHandler.ClearOmittedComponents  PROCEDURE(SHORT Direction)
ComponentNo                                                 BYTE,AUTO
  CODE
  LOOP ComponentNo = SELF.PassedValues + 1 TO SELF.Components
    SELF.SetOrClearField(Direction, ComponentNo)
  END

!==============================================================================
UltimateFetch_KeyComponentHandler.EqualsPassedValues  PROCEDURE!,BOOL
ComponentNo                                             BYTE,AUTO
  CODE
  LOOP ComponentNo = SELF.PassedValues TO 1 BY -1
    GET(SELF.Q, ComponentNo)
    IF SELF.Q.FieldRef <> SELF.Q.Value
      RETURN FALSE
    END
  END
  RETURN TRUE

!==============================================================================
