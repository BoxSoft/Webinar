                              MEMBER

  INCLUDE('ListPeekaboo.inc'),ONCE
  INCLUDE('Equates.clw'),ONCE
  INCLUDE('Errors.clw'),ONCE
  INCLUDE('Keycodes.clw'),ONCE

                              MAP
                                !INCLUDE('STDebug.inc')
                              END

!==============================================================================
ListPeekabooClass.Construct   PROCEDURE
  CODE
  SELF.ColumnQ  &=  NEW ListPeekabooClass_ColumnQueue

!==============================================================================
ListPeekabooClass.Destruct    PROCEDURE
  CODE
  SELF.FreeColumnQ();  DISPOSE(SELF.ColumnQ)

!==============================================================================
ListPeekabooClass.FreeColumnQ PROCEDURE
  CODE
  LOOP WHILE RECORDS(SELF.ColumnQ)
    GET(SELF.ColumnQ, 1)
    SELF.DeleteColumnQ()
  END

!==============================================================================
ListPeekabooClass.DeleteColumnQ   PROCEDURE
  CODE
  !Dispose any references within queue record
  DELETE(SELF.ColumnQ)

!==============================================================================
ListPeekabooClass.FetchColumn PROCEDURE(USHORT Column)!,BYTE
  CODE
  SELF.ColumnQ.ColumnNo  =  Column
  GET(SELF.ColumnQ, SELF.ColumnQ.ColumnNo)
  RETURN CHOOSE(ERRORCODE()=NoError, Level:Benign, Level:Notify)
  
!==============================================================================
ListPeekabooClass.Init        PROCEDURE(SIGNED ListControl,<USHORT SlushColumn>,<USHORT LastColumnWidth>)
                              MAP
LoadColumns                     PROCEDURE
                              END
  CODE
  SELF.ListControl  =  ListControl
  SELF.SlushColumn  =  SlushColumn
  LoadColumns()

!--------------------------------------
LoadColumns                   PROCEDURE
Columns                         USHORT,AUTO
Column                          USHORT,AUTO
  CODE
  Columns  =  SELF.ListControl{PROPLIST:Exists, 0}  !Get number of columns
  IF Columns
    LOOP Column = 1 TO Columns
      CLEAR(SELF.ColumnQ)
      SELF.ColumnQ.ColumnNo  =  Column
      SELF.ColumnQ.FieldNo   =  SELF.ListControl{PROPLIST:FieldNo, Column}
      SELF.ColumnQ.Resize    =  CHOOSE(SELF.ListControl{PROPLIST:Resize , Column})
      SELF.ColumnQ.Fixed     =  CHOOSE(SELF.ListControl{PROPLIST:Fixed  , Column})
      IF Column < Columns OR LastColumnWidth = 0
        SELF.ColumnQ.Width  =  SELF.ListControl{PROPLIST:Width  , Column}
      ELSE
        SELF.ColumnQ.Width  =  LastColumnWidth
      END
      ADD(SELF.ColumnQ)
    END
  END
  !ST::DebugQueue(SELF.ColumnQ)

!==============================================================================
ListPeekabooClass.InitHidePriority    PROCEDURE(USHORT Column,BYTE HidePriority)
  CODE
  IF SELF.FetchColumn(Column) = LEVEL:Benign
    SELF.ColumnQ.HidePriority  =  HidePriority
    PUT(SELF.ColumnQ)
  END

!==============================================================================
ListPeekabooClass.HideColumn  PROCEDURE(USHORT Column,BYTE ForceRefresh=TRUE)
  CODE
  IF SELF.FetchColumn(Column) = LEVEL:Benign
    IF NOT SELF.ColumnQ.IsHidden
      SELF.ColumnQ.IsHidden  =  TRUE
      PUT(SELF.ColumnQ)
      IF ForceRefresh 
        SELF.TakeWindowSized(ForceRefresh)
      END 
    END 
  END

!==============================================================================
ListPeekabooClass.UnHideColumn    PROCEDURE(USHORT Column,BYTE ForceRefresh=TRUE)
  CODE
  IF SELF.FetchColumn(Column) = LEVEL:Benign
    IF SELF.ColumnQ.IsHidden
      SELF.ColumnQ.IsHidden  =  FALSE
      PUT(SELF.ColumnQ)
      IF ForceRefresh 
        SELF.TakeWindowSized(ForceRefresh)
      END 
    END        
  END

!==============================================================================
ListPeekabooClass.UpdateColumnWidth   PROCEDURE(USHORT Column,SHORT ColumnWidth,BYTE ForceRefresh=TRUE)
  CODE
  IF SELF.FetchColumn(Column) = LEVEL:Benign
    SELF.ColumnQ.Width  =  ColumnWidth
    PUT(SELF.ColumnQ)
    IF ForceRefresh 
      SELF.TakeWindowSized(ForceRefresh)
    END 
  END

!==============================================================================
ListPeekabooClass.TakeEvent   PROCEDURE
  CODE
  CASE EVENT()
  OF EVENT:OpenWindow OROF EVENT:Sized OROF EVENT:DoResize
    SELF.TakeWindowSized()
  OF EVENT:ColumnResize
    SELF.TakeColumnResize()
  END

!==============================================================================
ListPeekabooClass.TakeWindowSized PROCEDURE(<BYTE ForceRefresh>)
ListW                               SHORT,AUTO
  CODE
  ListW  =  SELF.ListControl{PROP:Width}
  DO HandleListColumns

HandleListColumns             ROUTINE
  IF SELF.LastListWidth <> ListW OR ForceRefresh
    SELF.LastListWidth  =  ListW
    SELF.HandleListColumns()
  END

!==============================================================================
ListPeekabooClass.TakeColumnResize    PROCEDURE
Column                                  USHORT
  CODE
  !STOP(SELF.ListControl{PROPLIST:MouseDownField} &'  '& SELF.ListControl{PROPLIST:MouseUpField})
  SORT(SELF.ColumnQ, SELF.ColumnQ.ColumnNo)
  Column  =  SELF.ListControl{PROPLIST:MouseDownField}
  GET(SELF.ColumnQ, Column)
  SELF.ColumnQ.Width  =  SELF.ListControl{PROPLIST:Width, Column}
  PUT(SELF.ColumnQ)
  SELF.HandleListColumns()

!==============================================================================
ListPeekabooClass.HandleListColumns   PROCEDURE
Column                                  USHORT,AUTO
ColumnsProcessed                        USHORT(0)
HidePriority                            BYTE,AUTO
HidingFromPriority                      BYTE(0)
ListWidth                               LONG,AUTO
AccumulatedColumnWidth                  LONG(0)
  CODE  
  ListWidth  =  SELF.ListControl{PROP:Width} - 12  !12 is approximate VSCROLL Width
  SORT(SELF.ColumnQ, SELF.ColumnQ.HidePriority)
  LOOP HidePriority = 0 TO 255
    IF HidingFromPriority = 0 THEN DO TotalHidePriorityWidth.
    DO HideUnhideColumns
    IF ColumnsProcessed >= RECORDS(SELF.ColumnQ) THEN BREAK.
  END
  DO HandleSlushColumn

TotalHidePriorityWidth        ROUTINE
  DATA
TotalPriorityWidth  LONG(0)
  CODE
  LOOP Column = 1 TO RECORDS(SELF.ColumnQ)
    GET(SELF.ColumnQ, Column)
    IF SELF.ColumnQ.IsHidden = True 
      CYCLE 
    ELSIF SELF.ColumnQ.HidePriority > HidePriority
      BREAK
    ELSIF SELF.ColumnQ.HidePriority = HidePriority
      TotalPriorityWidth  +=  SELF.ColumnQ.Width
    END
  END
  IF AccumulatedColumnWidth + TotalPriorityWidth > ListWidth
    HidingFromPriority  =  HidePriority
  END

HideUnhideColumns             ROUTINE
  LOOP Column = 1 TO RECORDS(SELF.ColumnQ)
    GET(SELF.ColumnQ, Column)
    IF SELF.ColumnQ.HidePriority > HidePriority 
      BREAK
    ELSIF SELF.ColumnQ.HidePriority = HidePriority
      IF SELF.ColumnQ.IsHidden = True 
        DO HideColumn
      ELSIF HidePriority = 0
        DO ShowColumn
        !ELSIF 0 < HidingFromPriority AND HidingFromPriority <= HidePriority
      ELSIF INRANGE(HidingFromPriority, 1, HidePriority)
        DO HideColumn
      ELSE
        DO ShowColumn
      END  
      ColumnsProcessed  +=  1
    END
  END

ShowColumn                    ROUTINE
  SELF.ListControl{PROPLIST:Width, SELF.ColumnQ.ColumnNo} = SELF.ColumnQ.Width
  AccumulatedColumnWidth  +=  SELF.ColumnQ.Width

HideColumn                    ROUTINE
  SELF.ListControl{PROPLIST:Width, SELF.ColumnQ.ColumnNo} = 0

HandleSlushColumn             ROUTINE
  DATA
SlushWidth  SHORT,AUTO
  CODE
  IF SELF.SlushColumn <> 0
    SlushWidth  =  ListWidth - AccumulatedColumnWidth
    !MESSAGE('SlushColumn='& SELF.SlushColumn &'; SlushWidth='& SlushWidth &'; Fetch='& SELF.FetchColumn(SELF.SlushColumn) &'; PROPLIST:Width='& SELF.ListControl{PROPLIST:Width, SELF.SlushColumn})
    IF SlushWidth > 0  |
        AND SELF.FetchColumn(SELF.SlushColumn) = Level:Benign  |
        AND SELF.ListControl{PROPLIST:Width, SELF.SlushColumn} <> 0
      SELF.ListControl{PROPLIST:Width, SELF.SlushColumn} = SELF.ColumnQ.Width + SlushWidth
      !ST::DebugQueue(SELF.ColumnQ, SELF.SlushColumn)
    END
  END

!==============================================================================
