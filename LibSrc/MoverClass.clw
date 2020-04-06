                              MEMBER

  INCLUDE('MoverClass.inc'),ONCE
  INCLUDE('Errors.clw'),ONCE
  INCLUDE('Keycodes.clw'),ONCE

                              MAP
                                INCLUDE('STDebug.inc')
                              END

BEEP_ERROR                    STRING('BEEP')

!==============================================================================
!==============================================================================
Mover_Abstract.Construct      PROCEDURE
  CODE
  SELF.MoveUpKeycode       = CtrlUp
  SELF.MoveDownKeycode     = CtrlDown
  SELF.MoveToTopKeycode    = CtrlShiftUp
  SELF.MoveToBottomKeycode = CtrlShiftDown
  
!==============================================================================
Mover_Abstract.Destruct       PROCEDURE
  CODE
  
!==============================================================================
Mover_Abstract.AfterMove      PROCEDURE(SHORT Direction)
  CODE
  !Empty virtual

!==============================================================================
Mover_Abstract.CanMoveUp      PROCEDURE!,BOOL
  CODE
  RETURN SELF.CanMove(Mover:Direction:Up)

!==============================================================================
Mover_Abstract.CanMoveDown    PROCEDURE!,BOOL
  CODE
  RETURN SELF.CanMove(Mover:Direction:Down)

!==============================================================================
Mover_Abstract.CanMove        PROCEDURE(SHORT Direction)!,BOOL
  CODE
  ASSERT(FALSE, 'Mover_Abstract.CanMove is an abstract virtual method, and must be derived.')
  RETURN FALSE
  
!==============================================================================
Mover_Abstract.InitWindow     PROCEDURE
  CODE
  ASSERT(SELF.ListControl <> 0, 'ListControl not initialized in Mover_Legacy.InitWindow.')
  ASSERT(NOT SELF.File &= NULL, 'File not initialized in Mover_Legacy.InitWindow.')
  !Etc.
  SELF.ListControl{PROP:Alrt, 255} = SELF.MoveUpKeycode
  SELF.ListControl{PROP:Alrt, 255} = SELF.MoveDownKeycode
  
!==============================================================================
Mover_Abstract.MoveUp         PROCEDURE
  CODE
  SELF.Move(Mover:Direction:Up)

!==============================================================================
Mover_Abstract.MoveDown       PROCEDURE
  CODE
  SELF.Move(Mover:Direction:Down)

!==============================================================================
Mover_Abstract.Move           PROCEDURE(SHORT Direction)
  CODE
  ASSERT(FALSE, 'Mover_Abstract.Move is an abstract virtual method, and must be derived.')

!==============================================================================
Mover_Abstract.BeforeHidingThat   PROCEDURE(SHORT Direction)
  CODE
  !EmptyVirtual

!==============================================================================
Mover_Abstract.SetThatSequence    PROCEDURE(LONG ThisSequence,SHORT Direction)
  CODE
  SELF.Sequence = ThisSequence

!==============================================================================
Mover_Abstract.SetThisSequence    PROCEDURE(LONG ThatSequence,SHORT Direction)
  CODE
  SELF.Sequence = ThatSequence

!==============================================================================
Mover_Abstract.TakeEvent      PROCEDURE!,BYTE
ReturnValue                     BYTE(Level:Benign)
  CODE
  CASE EVENT()
  OF EVENT:Accepted
    CASE ACCEPTED()
      ;OF SELF.MoveUpControl  ;  SELF.MoveUp()
      ;OF SELF.MoveDownControl;  SELF.MoveDown()
    END
  OF EVENT:AlertKey
    IF FIELD() = SELF.ListControl
      CASE KEYCODE()
        ;OF SELF.MoveUpKeycode  ;  ReturnValue = Level:Notify;  POST(EVENT:Accepted, SELF.MoveUpControl)
        ;OF SELF.MoveDownKeycode;  ReturnValue = Level:Notify;  POST(EVENT:Accepted, SELF.MoveDownControl)
      END
    END
  END
  RETURN ReturnValue

!==============================================================================
Mover_Abstract.UpdateWindow   PROCEDURE
  CODE
  SELF.MoveUpControl  {PROP:Disable} = CHOOSE(~SELF.CanMoveUp  ())
  SELF.MoveDownControl{PROP:Disable} = CHOOSE(~SELF.CanMoveDown())

!==============================================================================
!==============================================================================
Mover_ABC.Init           PROCEDURE(BrowseClass Browse,*? Sequence,SIGNED MoveUpControl,SIGNED MoveDownControl)
  CODE
  SELF.File           &= Browse.Primary.Me.File
  SELF.View           &= Browse.View
  SELF.Sequence       &= Sequence
  SELF.Browse         &= Browse
  SELF.ListControl     = Browse.ILC.GetControl()
  SELF.MoveUpControl   = MoveUpControl
  SELF.MoveDownControl = MoveDownControl

  SELF.InitWindow()

!==============================================================================
Mover_ABC.CanMove             PROCEDURE(SHORT Direction)!,BOOL
  CODE
  IF SELF.Browse.ListQueue.Records()
    IF  (Direction = Mover:Direction:Up   AND SELF.Browse.ILC.Choice() > 1) OR |
        (Direction = Mover:Direction:Down AND SELF.Browse.ILC.Choice() < SELF.Browse.ListQueue.Records())
      RETURN TRUE
    END
  END
  RETURN FALSE

!==============================================================================
Mover_ABC.Move                PROCEDURE(SHORT Direction)
ThatPosition                    STRING(1024)
ThisPosition                    STRING(1024)
ThatSequence                    ANY
ThisSequence                    ANY
ErrorMessage                    CSTRING(200)
Stage                           BYTE(0)
  CODE
  IF SELF.CanMove(Direction)
    LOOP UNTIL ErrorMessage
      Stage += 1
      EXECUTE Stage
        DO StartTransaction
        DO FetchThatRecord
        DO MoveThatOutOfTheWay
        DO FetchThisRecord
        DO MoveThisToThat
        DO RefetchThatRecord
        DO MoveThatToThis
        DO RefetchThisRecord
        DO CommitTransaction
        DO AfterMove
        BREAK
      END
    END
    IF ErrorMessage
      ROLLBACK
      IF ErrorMessage = BEEP_ERROR
        BEEP()
      ELSE
        MESSAGE(ErrorMessage, 'Error!', ICON:Asterisk)
      END
    END
  END

!--------------------------------------
StartTransaction              ROUTINE
  LOGOUT(5, SELF.Browse.Primary.Me.File)
  IF ERRORCODE() <> NoError
    ErrorMessage = 'Cannot begin transaction!  Please try again later.'
  END

!--------------------------------------
CommitTransaction             ROUTINE
  COMMIT
  IF ERRORCODE() <> NoError
    ErrorMessage = 'Cannot commit transaction!'
  END

!--------------------------------------
FetchThatRecord               ROUTINE
  SELF.Browse.ListQueue.Fetch(SELF.Browse.ILC.Choice() + Direction)
  REGET(SELF.Browse.View, SELF.Browse.ListQueue.GetViewPosition())
  IF ERRORCODE() <> NoError
    ErrorMessage = 'Cannot reget other item.'
  ELSE
    ThatSequence = SELF.Sequence
  END
    
!--------------------------------------
FetchThisRecord               ROUTINE
  SELF.Browse.ListQueue.Fetch(SELF.Browse.ILC.Choice())
  REGET(SELF.Browse.View, SELF.Browse.ListQueue.GetViewPosition())
  IF ERRORCODE() <> NoError
    ErrorMessage = 'Cannot reget current item.'
  ELSE
    ThisSequence = SELF.Sequence
  END

!--------------------------------------
RefetchThatRecord             ROUTINE
  IF SELF.Browse.Primary.Me.TryReget(ThatPosition) <> LEVEL:Benign
    ErrorMessage = 'Cannot reget temporarily moved item.'
  END

!--------------------------------------
RefetchThisRecord             ROUTINE
  IF SELF.Browse.Primary.Me.TryReget(ThisPosition) <> Level:Benign
    ErrorMessage = 'Cannot reget moved item.'
  END

!--------------------------------------
MoveThatOutOfTheWay           ROUTINE
  SELF.BeforeHidingThat(Direction)
  CLEAR(SELF.Sequence, +1)
  IF SELF.Browse.Primary.Me.Update() <> Level:Benign
    ErrorMessage = 'Cannot shift previous item.'
  ELSE
    ThatPosition = SELF.Browse.Primary.Me.Position()
  END

!--------------------------------------
MoveThisToThat                ROUTINE
  SELF.SetThisSequence(ThatSequence, Direction)
  IF SELF.Browse.Primary.Me.Update() <> Level:Benign
    ErrorMessage = 'Cannot update current item.'
  ELSE
    ThisPosition = SELF.Browse.Primary.Me.Position()
  END

!--------------------------------------
MoveThatToThis                ROUTINE
  SELF.SetThatSequence(ThisSequence, Direction)
  IF SELF.Browse.Primary.Me.Update() <> Level:Benign
    ErrorMessage = 'Cannot update other item.'
  END
  
!--------------------------------------
AfterMove                     ROUTINE
  SELF.AfterMove(Direction)
  SELF.Browse.ResetFromFile()
  SELF.Browse.PostNewSelection()
  IF FOCUS() <> SELF.Browse.ILC.GetControl() THEN SELECT(SELF.Browse.ILC.GetControl()).

!==============================================================================
!==============================================================================
Mover_Legacy.CanMove          PROCEDURE(SHORT Direction)!,BOOL
  CODE
  ASSERT(NOT SELF.ListQueue &= NULL, 'ListQueue not initialized in Mover_Legacy.CanMove.')
  RETURN CHOOSE(RECORDS(SELF.ListQueue) > 0)

!==============================================================================
Mover_Legacy.Move             PROCEDURE(SHORT Direction)
ThatPosition                    STRING(1024)
ThisPosition                    STRING(1024)
ThatSequence                    ANY
ThisSequence                    ANY
ErrorMessage                    CSTRING(200)
Stage                           BYTE(0)
  CODE
  IF SELF.CanMove(Direction)
    LOOP UNTIL ErrorMessage
      Stage += 1
      EXECUTE Stage
        DO StartTransaction
        DO FetchThatRecord
        DO MoveThatOutOfTheWay
        DO FetchThisRecord
        DO MoveThisToThat
        DO RefetchThatRecord
        DO MoveThatToThis
        DO RefetchThisRecord
        DO CommitTransaction
        DO AfterMove
        BREAK
      END
    END
    IF ErrorMessage
      ROLLBACK
      IF ErrorMessage = BEEP_ERROR
        BEEP()
      ELSE
        MESSAGE(ErrorMessage, 'Error!', ICON:Asterisk)
      END
    END
  END

!--------------------------------------
StartTransaction              ROUTINE
  LOGOUT(5, SELF.File)
  IF ERRORCODE() <> NoError
    ErrorMessage = 'Cannot begin transaction!  Please try again later.'
  END

!--------------------------------------
CommitTransaction             ROUTINE
  COMMIT
  IF ERRORCODE() <> NoError
    ErrorMessage = 'Cannot commit transaction!'
  END

!--------------------------------------
FetchThatRecord               ROUTINE
  GET(SELF.ListQueue, CHOICE(SELF.ListControl) + Direction)
  IF ERRORCODE() <> NoError
    GET(SELF.ListQueue, CHOICE(SELF.ListControl))
    IF ERRORCODE() <> NoError
      ErrorMessage = 'Cannot reget other item.'
    ELSE
      RESET(SELF.View, SELF.ViewPosition)
      SKIP(SELF.View, Direction)
      IF ERRORCODE() <> NoError
        ErrorMessage = 'Cannot reget other item.'
      ELSE
        CASE Direction
          ;OF Mover:Direction:Up  ;  PREVIOUS(SELF.View)
          ;OF Mover:Direction:Down;      NEXT(SELF.View)
        END
      END
    END
  ELSE
    REGET(SELF.View, SELF.ViewPosition)
  END
  IF ErrorMessage = ''
    IF ERRORCODE() <> NoError
      ErrorMessage = BEEP_ERROR
    ELSE
      ThatSequence = SELF.Sequence
    END
  END
    
!--------------------------------------
FetchThisRecord               ROUTINE
  GET(SELF.ListQueue, CHOICE(SELF.ListControl))
  REGET(SELF.View, SELF.ViewPosition)
  IF ERRORCODE() <> NoError
    ErrorMessage = 'Cannot reget current item.'
  ELSE
    ThisSequence = SELF.Sequence
  END

!--------------------------------------
RefetchThatRecord             ROUTINE
  REGET(SELF.File, ThatPosition)
  IF ERRORCODE() <> NoError
    ErrorMessage = 'Cannot reget temporarily moved item.'
  END
  
RefetchThisRecord             ROUTINE
  REGET(SELF.File, ThisPosition)
  IF ERRORCODE() <> NoError
    ErrorMessage = 'Cannot reget moved item.'
  END

!--------------------------------------
MoveThatOutOfTheWay           ROUTINE
  SELF.BeforeHidingThat(Direction)
  CLEAR(SELF.Sequence, +1)
  PUT(SELF.File)
  IF ERRORCODE() <> NoError
    ErrorMessage = 'Cannot shift previous item.'
  ELSE
    ThatPosition = POSITION(SELF.File)
  END

!--------------------------------------
MoveThisToThat                ROUTINE
  SELF.SetThisSequence(ThatSequence, Direction)
  PUT(SELF.File)
  IF ERRORCODE() <> NoError
    ErrorMessage = 'Cannot update current item.'
  ELSE
    ThisPosition = POSITION(SELF.File)
  END

!--------------------------------------
MoveThatToThis                ROUTINE
  SELF.SetThatSequence(ThisSequence, Direction)
  PUT(SELF.File)
  IF ERRORCODE() <> NoError
    ErrorMessage = 'Cannot update other item.'
  END
  
!--------------------------------------
AfterMove                     ROUTINE
  SELF.AfterMove(Direction)
  IF FOCUS() <> SELF.ListControl THEN SELECT(SELF.ListControl).

!==============================================================================
