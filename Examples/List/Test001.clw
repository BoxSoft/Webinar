

   MEMBER('Test.clw')                                      ! This is a MEMBER module


   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE
   INCLUDE('mhList.inc'),ONCE

!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
Main PROCEDURE 

ListGroup            GROUP,PRE(LG)                         ! 
Name                 STRING(255)                           ! 
ShortName            STRING(13)                            ! 
Date                 LONG                                  ! 
Time                 LONG                                  ! 
Size                 LONG                                  ! 
Attrib               BYTE                                  ! 
                     END                                   ! 
!TODO: Another Template later, with a Generated Queue
DirQ    QUEUE
Name      STRING(255)
Name_Icon LONG
ShortName STRING(13)
ShortName_Icon    LONG
Date      LONG
Time      LONG
Size      LONG
Attrib    BYTE
WinMark   BYTE
RealMark  BYTE
        END
Window               WINDOW('List Test'),AT(1,200,343,125),FONT('Segoe UI',12,,FONT:regular),RESIZE,ALRT(F5Key), |
  GRAY,SYSTEM
                       LIST,AT(1,1),USE(?ListFiles),FULL,VSCROLL,FORMAT('100L(1)|MJ~Name~@s255@52L(1)|MJ~Short' & |
  ' Name~@s13@40R(1)|M~Date~C(1)@d17@40R(1)|M~Time~C(1)@t7@60R(1)|M~Size~C(1)@n-14@12L(' & |
  '1)|M~Attr~@s3@'),FROM(DirQ),MARK(DirQ.WinMark)
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
myList               CLASS(mhList)
Load                   PROCEDURE(),DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
TakeNewSelection       PROCEDURE(),BYTE,DERIVED
                     END

                     ITEMIZE(1),PRE(myList:Column)
LG:Name                EQUATE
LG:ShortName           EQUATE
LG:Date                EQUATE
LG:Time                EQUATE
LG:Size                EQUATE
LG:Attrib              EQUATE
                     END

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Main')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?ListFiles
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  SELF.Open(Window)                                        ! Open window
  !ST::DebugClear()
  myList.Init(?ListFiles, DirQ)
  myList.InitMarking(DirQ.RealMark, DirQ.WinMark)
  myList.InitTagging(myList:Column:LG:Name, DirQ.Name_Icon, 1, 2)
  ?ListFiles{PROP:IconList, 1} = '~BOXCHECK.ICO'
  ?ListFiles{PROP:IconList, 2} = '~BOXEMPTY.ICO'
  myList.Load()
  myList.SetSort(myList:Column:LG:Name)
  Do DefineListboxStyle
  INIMgr.Fetch('Main',Window)                              ! Restore window settings from non-volatile store
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('Main',Window)                           ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
   !ST::Debug(ST::DebugEventName())
    
    CASE myList.TakeEvent()
      ;OF Level:Notify;  CYCLE
      ;OF Level:Fatal ;  BREAK
    END
  ReturnValue = PARENT.TakeEvent()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeWindowEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all window specific events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeWindowEvent()
    CASE EVENT()
    OF EVENT:AlertKey
      IF KEYCODE() = F5Key
        C# = CLOCK()
        LOOP 100000 TIMES
          LOOP X# = 1 TO RECORDS(DirQ)
            GET(DirQ, X#)
          END
        END
        STOP((CLOCK() - C#) / 100)
      END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


myList.Load PROCEDURE

DQ            QUEUE(FILE:Queue),PRE(DQ)
              END
QNdx          LONG,AUTO
  CODE
  PARENT.Load
  FREE(DQ)
  DIRECTORY(DQ, WinTempBS&'*.*',ff_:NORMAL)
  LOOP QNdx = RECORDS(DQ) TO 1 BY -1        !--Keep directories, Delete files, Case Name
    GET(DQ,QNdx)
    IF BAND(DQ,FF_:Directory) OR DQ:Name='.' OR DQ:Name='..'   !. or .. Dirs
      !DELETE(DQ)
    ELSE
      CLEAR(DirQ)
      DQ:Name    = UPPER(DQ:Name[1]) & DQ:Name[2 : SIZE(DQ:Name) ]
      ListGroup :=: DQ
      myList.SetQueueRecord()
      ADD(DirQ)
    END
  END
  !ST::DebugQueue(DirQ, myList.UntaggedIconIndex)


myList.SetQueueRecord PROCEDURE

  CODE
  CLEAR(DirQ)
  PARENT.SetQueueRecord
  DirQ :=: ListGroup
  !TODO: Additional conditional icons


myList.TakeNewSelection PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.TakeNewSelection()
  0{PROP:Text} = DirQ.Name
  RETURN ReturnValue

