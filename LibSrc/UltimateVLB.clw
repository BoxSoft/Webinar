                              MEMBER

  INCLUDE('UltimateVLB.inc'),ONCE
  INCLUDE('Equates.clw'),ONCE
  INCLUDE('Errors.clw'),ONCE
  INCLUDE('Keycodes.clw'),ONCE

                              ITEMIZE
ELEMENT:DisplayValue            EQUATE(1)
ELEMENT:NormalFG                EQUATE
ELEMENT:NormalBG                EQUATE
ELEMENT:SelectedFG              EQUATE
ELEMENT:SelectedBG              EQUATE
ELEMENT:Icon                    EQUATE
ELEMENT:Tree                    EQUATE
ELEMENT:Style                   EQUATE
ELEMENT:Tip                     EQUATE
                              END

                              MAP
                                MODULE('Windows API')
WinAPI:GetSysColor                PROCEDURE(SIGNED nIndex),LONG,PASCAL,NAME('GetSysColor')
                                END
                                INCLUDE('CWUtil.inc')
                                INCLUDE('STDebug.inc')
                              END

LONG_COLOR:NONE               LONG(COLOR:NONE)
LONG_NoIcon                   LONG(0)
LONG_NoTree                   LONG,OVER(LONG_NoIcon)
LONG_NoStyle                  LONG,OVER(LONG_NoIcon)
STRING_Blank                  STRING(' ')

!==============================================================================
!==============================================================================
UltVLB:ColumnClass.Construct  PROCEDURE
  CODE
  SELF.Width          = UltVLB:Width:String
  SELF.Justification  = UltVLB:Justify:Left;  SELF.Offset  = UltVLB:Offset:Data
  SELF.HJustification = UltVLB:Justify:Left;  SELF.HOffset = UltVLB:Offset:Header
  SELF.IsResizable    = TRUE
  SELF.HasRightBorder = TRUE
  
!==============================================================================
UltVLB:ColumnClass.Destruct   PROCEDURE
  CODE
  !Empty virtual

!==============================================================================
UltVLB:ColumnClass.FormatColumn   PROCEDURE(SIGNED ListFEQ,SHORT ColumnNo)
  CODE
  DO FormatBasicAttribute
  DO FormatJustification
  DO FormatHeaderJustification
  DO FormatColor
  DO FormatIcon
  DO FormatTree
  DO FormatStyle
  DO FormatTip
  DO FormatBorder

FormatBasicAttribute          ROUTINE
  ListFEQ{PROPLIST:Width    , ColumnNo} = SELF.Width
  ListFEQ{PROPLIST:Header   , ColumnNo} = SELF.Header
  ListFEQ{PROPLIST:Picture  , ColumnNo} = SELF.Picture

FormatJustification           ROUTINE
  CASE SELF.Justification
    ;OF UltVLB:Justify:Default ;  !No-op
    ;OF UltVLB:Justify:Left    ;  ListFEQ{PROPLIST:Left        , ColumnNo} = TRUE;  ListFEQ{PROPLIST:LeftOffset  , ColumnNo} = SELF.Offset
    ;OF UltVLB:Justify:Right   ;  ListFEQ{PROPLIST:Right       , ColumnNo} = TRUE;  ListFEQ{PROPLIST:RightOffset , ColumnNo} = SELF.Offset
    ;OF UltVLB:Justify:Center  ;  ListFEQ{PROPLIST:Center      , ColumnNo} = TRUE;  ListFEQ{PROPLIST:CenterOffset, ColumnNo} = SELF.Offset
  END

FormatHeaderJustification     ROUTINE
  CASE SELF.HJustification
    ;OF UltVLB:Justify:Default ;  !No-op
    ;OF UltVLB:Justify:Left    ;  ListFEQ{PROPLIST:HeaderLeft  , ColumnNo} = TRUE;  ListFEQ{PROPLIST:HeaderLeftOffset  , ColumnNo} = SELF.HOffset
    ;OF UltVLB:Justify:Right   ;  ListFEQ{PROPLIST:HeaderRight , ColumnNo} = TRUE;  ListFEQ{PROPLIST:HeaderRightOffset , ColumnNo} = SELF.HOffset
    ;OF UltVLB:Justify:Center  ;  ListFEQ{PROPLIST:HeaderCenter, ColumnNo} = TRUE;  ListFEQ{PROPLIST:HeaderCenterOffset, ColumnNo} = SELF.HOffset
  END

FormatColor                   ROUTINE
  ListFEQ{PROPLIST:Color, ColumnNo} = CHOOSE(SELF.Color <> UltVLB:Color:None)

FormatIcon                    ROUTINE
  CASE SELF.Icon
    ;OF UltVLB:Icon:Regular    ;  ListFEQ{PROPLIST:Icon        , ColumnNo} = TRUE
    ;OF UltVLB:Icon:Transparent;  ListFEQ{PROPLIST:IconTrn     , ColumnNo} = TRUE
  END

FormatTree                    ROUTINE
  IF SELF.HasTree
    ListFEQ{PROPLIST:Tree      , ColumnNo} = TRUE
    ListFEQ{PROPLIST:TreeBoxes , ColumnNo} = SELF.HasTreeBoxes
    ListFEQ{PROPLIST:TreeIndent, ColumnNo} = SELF.HasTreeIndent
    ListFEQ{PROPLIST:TreeLines , ColumnNo} = SELF.HasTreeLines
    ListFEQ{PROPLIST:TreeOffset, ColumnNo} = SELF.HasTreeOffset
    ListFEQ{PROPLIST:TreeRoot  , ColumnNo} = SELF.HasTreeRoot
  END

FormatStyle                   ROUTINE
  IF SELF.HasStyle
    ListFEQ{PROPLIST:CellStyle, ColumnNo} = TRUE
  END

FormatTip                     ROUTINE
  IF SELF.HasTip
    ListFEQ{PROPLIST:Tip      , ColumnNo} = TRUE
  END

FormatBorder                  ROUTINE
  ListFEQ{PROPLIST:RightBorder, ColumnNo} = SELF.HasRightBorder
  ListFEQ{PROPLIST:Resize     , ColumnNo} = SELF.IsResizable

!==============================================================================
UltVLB:ColumnClass.GetElementCount       PROCEDURE!,SHORT
Elements                        SHORT(0)
  CODE
  ;                                       Elements += 1
  IF SELF.Color <> UltVLB:Color:None THEN Elements += 4.
  IF SELF.Icon  <> UltVLB:Icon:None  THEN Elements += 1.
  IF SELF.HasTree                    THEN Elements += 1.
  IF SELF.HasStyle                   THEN Elements += 1.
  IF SELF.HasTip                     THEN Elements += 1.
  RETURN Elements

!==============================================================================
UltVLB:ColumnClass.GetElementLONG PROCEDURE(SHORT Elem)!,LONG
R                                   LONG(COLOR:NONE)  !TODO
  CODE
  !NB: The following probably comment doesn't apply, but just in case, let's leave the comment for now, as a help.
  !If we ever get a STRING in the middle of the elements, 
  !then this must be changed to a CASE structure, similar 
  !to GetElementSTRING.
  EXECUTE Elem - 1
    R = SELF.NormalFGRef
    R = SELF.NormalBGRef
    R = SELF.SelectedFGRef
    R = SELF.SelectedBGRef
    R = SELF.IconRef
    R = SELF.TreeRef
    R = SELF.StyleRef
  END
  !ST::Debug('GetElementLONG/#'& Elem &' is '& R)
  RETURN R
  
!==============================================================================
UltVLB:ColumnClass.GetElementSTRING   PROCEDURE(SHORT Elem)!,STRING
  CODE
  CASE Elem
    ;OF ELEMENT:DisplayValue;  RETURN SELF.GetValue()
    ;OF ELEMENT:Tip         ;  RETURN SELF.TipRef
    ;ELSE                   ;  RETURN SELF.GetElementLONG(Elem)
  END
  
!==============================================================================
UltVLB:ColumnClass.GetValue   PROCEDURE!,STRING
  CODE
  IF NOT SELF.FieldRef &= NULL
    RETURN SELF.FieldRef
  ELSE
    RETURN ''
  END

!==============================================================================
UltVLB:ColumnClass.ScrapeProperties   PROCEDURE(SIGNED ListFeq,QUEUE Q,LONG ColNo)
                              MAP
ScrapeJustification             PROCEDURE
ScrapeHeaderJustification       PROCEDURE
AssignFieldRefs                 PROCEDURE
ScrapeColor                     PROCEDURE
ScrapeIcon                      PROCEDURE
ScrapeTree                      PROCEDURE
ScrapeStyle                     PROCEDURE
ScrapeTip                       PROCEDURE
ScrapeBorder                    PROCEDURE
NextAttributeField              PROCEDURE,*?
                              END
AttributeFieldOffset                    BYTE(0)
  CODE
  SELF.Header  = ListFeq{PROPLIST:Header, ColNo}
  SELF.Picture = ListFeq{PROPLIST:Picture, ColNo}
  SELF.Width   = ListFeq{PROPLIST:Width, ColNo}
  ScrapeJustification
  ScrapeHeaderJustification
  AssignFieldRefs
  ScrapeColor
  ScrapeIcon
  ScrapeTree
  ScrapeStyle
  ScrapeTip
  ScrapeBorder

ScrapeJustification           PROCEDURE
  CODE
  IF ListFeq{PROPLIST:Left, ColNo}
    SELF.Justification = UltVLB:Justify:Left
    SELF.Offset        = ListFeq{PROPLIST:LeftOffset, ColNo}
  ELSIF ListFeq{PROPLIST:Right, ColNo}
    SELF.Justification = UltVLB:Justify:Right
    SELF.Offset        = ListFeq{PROPLIST:RightOffset, ColNo}
  ELSIF ListFeq{PROPLIST:Center, ColNo}
    SELF.Justification = UltVLB:Justify:Center
    SELF.Offset        = ListFeq{PROPLIST:CenterOffset, ColNo}
  ELSE
    SELF.Justification = UltVLB:Justify:Default
    SELF.Offset        = 0
  END

ScrapeHeaderJustification     PROCEDURE
  CODE
  IF ListFeq{PROPLIST:HeaderLeft, ColNo}
    SELF.HJustification = UltVLB:Justify:Left
    SELF.HOffset        = ListFeq{PROPLIST:HeaderLeftOffset, ColNo}
  ELSIF ListFeq{PROPLIST:HeaderRight, ColNo}
    SELF.HJustification = UltVLB:Justify:Right
    SELF.HOffset        = ListFeq{PROPLIST:HeaderRightOffset, ColNo}
  ELSIF ListFeq{PROPLIST:HeaderCenter, ColNo}
    SELF.HJustification = UltVLB:Justify:Center
    SELF.HOffset        = ListFeq{PROPLIST:HeaderCenterOffset, ColNo}
  ELSE
    SELF.HJustification = UltVLB:Justify:Default
    SELF.HOffset        = 0
  END

AssignFieldRefs               PROCEDURE
  CODE
  SELF.FieldNo   = ListFeq{PROPLIST:FieldNo, ColNo}
  SELF.FieldRef &= WHAT(Q, SELF.FieldNo)

NextAttributeField            PROCEDURE!,*?
A                               ANY
  CODE
  AttributeFieldOffset += 1
  A &= WHAT(Q, SELF.FieldNo + AttributeFieldOffset)
  RETURN A

ScrapeColor                   PROCEDURE
  CODE
  IF ListFeq{PROPLIST:Color, ColNo}
    SELF.Color          = UltVLB:Color:Regular
    SELF.NormalFGRef   &= NextAttributeField()
    SELF.NormalBGRef   &= NextAttributeField()
    SELF.SelectedFGRef &= NextAttributeField()
    SELF.SelectedBGRef &= NextAttributeField()
  ELSE
    SELF.Color          = UltVLB:Color:Pretend
    SELF.NormalFGRef   &= LONG_COLOR:NONE
    SELF.NormalBGRef   &= LONG_COLOR:NONE
    SELF.SelectedFGRef &= LONG_COLOR:NONE
    SELF.SelectedBGRef &= LONG_COLOR:NONE
  END
  
ScrapeIcon                    PROCEDURE
  CODE
  IF ListFeq{PROPLIST:IconTrn, ColNo}
    SELF.Icon = UltVLB:Icon:Transparent
    DO AssignIconRef
  ELSIF ListFeq{PROPLIST:Icon, ColNo}
    SELF.Icon = UltVLB:Icon:Regular
    DO AssignIconRef
  ELSE
    SELF.Icon     = UltVLB:Icon:None
    SELF.IconRef &= LONG_NoIcon
  END
  
AssignIconRef                 ROUTINE
  SELF.IconRef &= NextAttributeField()

ScrapeTip                     PROCEDURE
  CODE
  IF ListFeq{PROPLIST:Tip, ColNo}
    SELF.HasTip  = TRUE
    SELF.TipRef &= NextAttributeField()
  ELSE
    SELF.HasTip  = FALSE
    SELF.TipRef &= STRING_Blank
  END
  
ScrapeTree                    PROCEDURE
  CODE
  IF ListFeq{PROPLIST:Tree, ColNo}
    SELF.HasTree       = TRUE
    SELF.HasTreeBoxes  = ListFeq{PROPLIST:TreeBoxes  , ColNo}
    SELF.HasTreeIndent = ListFeq{PROPLIST:TreeIndent , ColNo}
    SELF.HasTreeLines  = ListFeq{PROPLIST:TreeLines  , ColNo}
    SELF.HasTreeOffset = ListFeq{PROPLIST:TreeOffset , ColNo}
    SELF.HasTreeRoot   = ListFeq{PROPLIST:TreeRoot   , ColNo}
    SELF.TreeRef      &= NextAttributeField()
  ELSE
    SELF.HasTree       = FALSE
    SELF.HasTreeBoxes  = FALSE
    SELF.HasTreeIndent = FALSE
    SELF.HasTreeLines  = FALSE
    SELF.HasTreeOffset = FALSE
    SELF.HasTreeRoot   = FALSE
    SELF.TreeRef      &= LONG_NoTree
  END
  
ScrapeStyle                   PROCEDURE
  CODE
  IF ListFeq{PROPLIST:CellStyle, ColNo}
    SELF.HasStyle  = TRUE
    SELF.StyleRef &= NextAttributeField()
  ELSE
    SELF.HasStyle  = FALSE
    SELF.StyleRef &= LONG_NoStyle
  END
  
ScrapeBorder                  PROCEDURE  !***
  CODE
  SELF.HasRightBorder = CHOOSE(ListFeq{PROPLIST:RightBorder, ColNo})
  SELF.IsResizable    = CHOOSE(ListFeq{PROPLIST:Resize     , ColNo})

!==============================================================================
!==============================================================================
UltVLB:ColumnClassForNumber.Construct PROCEDURE
  CODE
  SELF.Width          = UltVLB:Width:Number
  SELF.Justification  = UltVLB:Justify:Right ;  SELF.Offset  = UltVLB:Offset:Data
  SELF.HJustification = UltVLB:Justify:Center;  SELF.HOffset = 0

!==============================================================================
!==============================================================================
UltimateVLB.Construct           PROCEDURE
  CODE
  SELF.ColumnQueue        &= NEW UltVLB:ColumnQueue
  SELF.StripeColorAddition = 5
  SELF.StripeColorDivisor  = 6

!==============================================================================
UltimateVLB.Destruct            PROCEDURE
  CODE
  LOOP WHILE RECORDS(SELF.ColumnQueue)
    GET(SELF.ColumnQueue, 1)
    IF SELF.ColumnQueue.DisposeObject
      DISPOSE(SELF.ColumnQueue.Column)
    END
    DELETE(SELF.ColumnQueue)
  END
  DISPOSE(SELF.ColumnQueue)
!  IF NOT SELF.FromQueue &= NULL
!    FREE(SELF.FromQueue)
!    DISPOSE(SELF.FromQueue)
!  END

!==============================================================================
UltimateVLB.Init              PROCEDURE(SIGNED FEQ,<QUEUE ListQueue>)
!                              MAP
!ParseFromString                 PROCEDURE
!ExtractValues                   PROCEDURE
!                              END
  CODE
  SELF.FEQ = FEQ
  IF OMITTED(ListQueue)
!    REGISTER(EVENT:Accepted, ADDRESS(SELF.TakeAccepted), ADDRESS(SELF),, SELF.FEQ)
!    SELF.FromQueue &= NEW UltVLB:FromQueue
!    SELF.ListQueue &= SELF.FromQueue  
!    ParseFromString
!    ExtractValues
    SELF.ListQueue &= NULL  !Temporarily disabled above, and possibly will never work
  ELSE
    SELF.ListQueue &= ListQueue
  END

!ParseFromString               PROCEDURE
!                              MAP
!AddItem                         PROCEDURE(STRING I)
!                              END
!F                               STRING(1000)
!S                               LONG(1)
!P                               LONG
!D                               STRING(100)
!  CODE
!  F = SELF.FEQ{PROP:From}
!  LOOP
!    P = INSTRING('|', F, 1, S)
!    IF P = 0
!      IF SUB(F, S, LEN(F)) <> ''
!        AddItem(SUB(F, S, LEN(F)))
!      END
!      BREAK
!    END
!    AddItem(SUB(F, S, P-S))
!    S = P + 1
!  END
!    
!AddItem                       PROCEDURE(STRING I)
!  CODE
!  CLEAR(SELF.FromQueue)
!  SELF.FromQueue.Display = I
!  SELF.FromQueue.Value   = I
!  ADD(SELF.FromQueue)
!
!ExtractValues                 PROCEDURE
!X                               LONG
!V                               STRING(100)
!  CODE
!  X = RECORDS(SELF.FromQueue)
!  LOOP WHILE X > 0
!    GET(SELF.FromQueue, X)
!    IF X > 1 AND SUB(SELF.FromQueue.Value, 1, 1) = '#'
!      V = SUB(SELF.FromQueue.Value, 2, SIZE(V))
!      DELETE(SELF.FromQueue)
!      X -= 1
!      GET(SELF.FromQueue, X)
!      SELF.FromQueue.Value = V
!      PUT(SELF.FromQueue)
!    END
!    X -= 1
!  END
    
!==============================================================================
UltimateVLB.InitAddAndApply   PROCEDURE(SIGNED FEQ,<QUEUE ListQueue>,<LONG StripeColor>)
  CODE
  DO Init
  IF NOT SELF.ListQueue &= NULL
    DO AddColumns
    DO ApplyVLB
  END
  
!--------------------------------------
Init                          ROUTINE
  IF OMITTED(ListQueue)
    SELF.Init(FEQ)
  ELSE
    SELF.Init(FEQ, ListQueue)
  END

!--------------------------------------
AddColumns                    ROUTINE
  DATA
ColumnCount LONG,AUTO
Column  LONG,AUTO
  CODE
  ColumnCount = FEQ{PROPLIST:Exists, 0}
  LOOP Column = 1 TO ColumnCount
    SELF.AddColumn(Column)
  END

!--------------------------------------
ApplyVLB                      ROUTINE
  IF OMITTED(StripeColor)
    SELF.ApplyVLB
  ELSE
    SELF.ApplyVLB(StripeColor)
  END
  
!==============================================================================
UltimateVLB.ApplyVLB          PROCEDURE(<LONG StripeColor>)
                              MAP
AssignVLB                       PROCEDURE
AssignListAttributes            PROCEDURE
DeriveStripeColorFromBarColor   PROCEDURE
FormatColumns                   PROCEDURE
                              END
  CODE
  IF OMITTED(StripeColor) THEN StripeColor = COLOR:NONE.
  SELF.OriginalListHeight = SELF.FEQ{PROP:Height}
  SELF.MeasureList
  DeriveStripeColorFromBarColor
  AssignListAttributes
  SELF.GetElementCount()  !From Columns
  FormatColumns
  !MESSAGE(FEQ{PROP:Format})
  AssignVLB
  
!--------------------------------------
AssignVLB                     PROCEDURE
  CODE
  SELF.FEQ{PROP:VLBval } = ADDRESS(SELF)           !Must assign this first
  SELF.FEQ{PROP:VLBproc} = ADDRESS(SELF.VLBproc)    ! then this

!--------------------------------------
AssignListAttributes          PROCEDURE
  CODE
  SELF.FEQ{PROP:VScroll} = TRUE

!--------------------------------------
DeriveStripeColorFromBarColor PROCEDURE
H                               REAL
S                               REAL
L                               REAL
COLOR_HIGHLIGHT                 EQUATE(13)
  CODE
  IF StripeColor <> COLOR:NONE
    SELF.StripeColor = StripeColor
  ELSE
    SELF.StripeColor = SELF.FEQ{PROP:SelectedFillColor}
    IF SELF.StripeColor = COLOR:NONE
      SELF.StripeColor = WinAPI:GetSysColor(COLOR_HIGHLIGHT)
    END
    ColorToHSL(SELF.StripeColor, H, S, L)
    HSLToColor(H, S, (L + SELF.StripeColorAddition) / SELF.StripeColorDivisor, SELF.StripeColor)
  END

!--------------------------------------
FormatColumns                 PROCEDURE
                              MAP
CreateFormatStringToSignalNumberOfColumns   PROCEDURE
                              END
C                               BYTE,AUTO
  CODE
  CreateFormatStringToSignalNumberOfColumns
  LOOP C = 1 TO RECORDS(SELF.ColumnQueue)
    GET(SELF.ColumnQueue, C)
    SELF.ColumnQueue.Column.FormatColumn(SELF.FEQ, C)
  END
  
!..................
CreateFormatStringToSignalNumberOfColumns PROCEDURE
F                                           CSTRING(10000)
  CODE
  LOOP C = 1 TO RECORDS(SELF.ColumnQueue)
    F = F & '1L'
  END
  SELF.FEQ{PROP:Format} = F
  

!==============================================================================
UltimateVLB.AddColumn         PROCEDURE(LONG ColumnNo)
ColumnObj                       &UltVLB:ColumnClass
  CODE
  ColumnObj &= NEW UltVLB:ColumnClass
  SELF.AddColumn(ColumnObj, ColumnNo, TRUE)

!==============================================================================
UltimateVLB.AddColumn         PROCEDURE(UltVLB:ColumnClass ColumnObj,LONG ColumnNo,<BOOL DisposeObject>)
  CODE
  ASSERT(SELF.FEQ <> 0, 'FEQ is zero in UltimateVLB.AddColumn for Column #'& ColumnNo)
  ASSERT(NOT SELF.ListQueue &= NULL, 'ListQueue is NULL in UltimateVLB.AddColumn for Column #'& ColumnNo)
  ColumnObj.ScrapeProperties(SELF.FEQ, SELF.ListQueue, ColumnNo)
  SELF.AddColumnQueue(ColumnObj, DisposeObject)

!==============================================================================
UltimateVLB.AddColumnQueue    PROCEDURE(UltVLB:ColumnClass ColumnObj,<BOOL DisposeObject>)
  CODE
  CLEAR(SELF.ColumnQueue)
  SELF.ColumnQueue.Column       &= ColumnObj
  SELF.ColumnQueue.DisposeObject = DisposeObject
  SELF.ColumnQueue.ElementCount  = ColumnObj.GetElementCount()
  ADD(SELF.ColumnQueue)

!==============================================================================
UltimateVLB.GetColumnValue    PROCEDURE(LONG Row,SHORT Col)!,STRING
  CODE
  RETURN ''

!==============================================================================
UltimateVLB.FetchRow          PROCEDURE(LONG Row)!,BYTE
  CODE
  IF NOT SELF.ListQueue &= NULL
    GET(SELF.ListQueue, Row)
    RETURN CHOOSE(ERRORCODE()=NoError, Level:Benign, Level:Notify)
  ELSE
    RETURN Level:Notify
  END

!==============================================================================
UltimateVLB.GetElement        PROCEDURE(LONG Row,SHORT Elem)!,STRING
Column                          SHORT(0)
ElementValue                    LONG
ElemOffset                      BYTE
  CODE
  LOOP UNTIL Column = RECORDS(SELF.ColumnQueue)
    Column += 1
    GET(SELF.ColumnQueue, Column)
    IF Elem <= SELF.ColumnQueue.ElementCount
      IF SELF.FetchRow(Row) = Level:Benign
        IF Elem = ELEMENT:DisplayValue
          RETURN SELF.ColumnQueue.Column.GetValue()
        ELSE
          ElemOffset = 1
          IF SELF.ColumnQueue.Column.Color <> UltVLB:Color:None
            EXECUTE Elem - ElemOffset
              RETURN SELF.ColumnQueue.Column.GetElementLONG(ELEMENT:NormalFG)
              BEGIN
                ElementValue = SELF.ColumnQueue.Column.GetElementLONG(ELEMENT:NormalBG)
                IF ElementValue = COLOR:NONE
                  RETURN SELF.GetStripeColor(Row)
                ELSE
                  RETURN ElementValue
                END
              END
              RETURN SELF.ColumnQueue.Column.GetElementLONG(ELEMENT:SelectedFG)
              RETURN SELF.ColumnQueue.Column.GetElementLONG(ELEMENT:SelectedBG)
            END
            ElemOffset += 4
          END
          IF SELF.ColumnQueue.Column.Icon <> UltVLB:Icon:None
            IF Elem - ElemOffset = 1
              RETURN SELF.ColumnQueue.Column.GetElementLONG(ELEMENT:Icon)
            END
            ElemOffset += 1
          END
          IF SELF.ColumnQueue.Column.HasTree
            IF Elem - ElemOffset = 1
              RETURN SELF.ColumnQueue.Column.GetElementLONG(ELEMENT:Tree)
            END
            ElemOffset += 1
          END
          IF SELF.ColumnQueue.Column.HasStyle
            IF Elem - ElemOffset = 1
              RETURN SELF.ColumnQueue.Column.GetElementLONG(ELEMENT:Style)
            END
            ElemOffset += 1
          END
          IF SELF.ColumnQueue.Column.HasTip
            IF Elem - ElemOffset = 1
              RETURN SELF.ColumnQueue.Column.GetElementSTRING(ELEMENT:Tip)
            END
            ElemOffset += 1
          END
          RETURN '' !TODO
        END
      ELSE
        BREAK
      END
    ELSE
      Elem -= SELF.ColumnQueue.ElementCount
    END
  END
  RETURN ''

!==============================================================================
UltimateVLB.GetElementCount   PROCEDURE!,SHORT
Col                             SHORT,AUTO
  CODE
  IF SELF.ElementCount = 0
    LOOP Col = 1 TO RECORDS(SELF.ColumnQueue)
      GET(SELF.ColumnQueue, Col)
      SELF.ElementCount += SELF.ColumnQueue.Column.GetElementCount()
    END
  END
  !ST::Debug('GetElementCount: '& SELF.ElementCount)
  RETURN SELF.ElementCount
  
!==============================================================================
UltimateVLB.GetStripeColor    PROCEDURE(LONG Row)!,LONG
  CODE
  RETURN CHOOSE(BAND(Row,1), COLOR:NONE, SELF.StripeColor)
  
!==============================================================================
UltimateVLB.HasDataChanged    PROCEDURE!,BOOL
NewCHANGES                      LONG
  CODE
  IF SELF.ListQueue &= NULL
    RETURN FALSE
  ELSE
    NewCHANGES = CHANGES(SELF.ListQueue)
    !ST::Debug('Old='& SELF.OldChanges &'; New='& NewCHANGES)
    IF NewCHANGES <> SELF.OldCHANGES
      SELF.OldCHANGES = NewCHANGES
      RETURN TRUE
    ELSE
      RETURN FALSE
    END
  END
  
!==============================================================================
UltimateVLB.MeasureList       PROCEDURE
  CODE
  SELF.ListItems       = SELF.FEQ{PROP:Items}
  SELF.FEQ{PROP:Items} = SELF.ListItems
  
!==============================================================================
UltimateVLB.Records           PROCEDURE(BYTE ReturnAtLeastOnePage=1)!,LONG
R                               LONG(0)
  CODE
  IF NOT SELF.ListQueue &= NULL
    R = RECORDS(SELF.ListQueue)
!    IF ReturnAtLeastOnePage AND R < SELF.ListItems
!      R = SELF.ListItems.
!    END
  END
  RETURN R
  
!==============================================================================
UltimateVLB.VLBproc           PROCEDURE(LONG Row, SHORT Elem)  !Required first parameter is implied
VLB:RowParm:RecordCount         EQUATE(-1)
VLB:RowParm:ElementCount        EQUATE(-2)
VLB:RowParm:HasChanges          EQUATE(-3)
Recs                            LONG,AUTO
ElementCount                    LONG,AUTO
HasDataChanged                  BOOL,AUTO
  CODE
  CASE Row
    ;OF VLB:RowParm:RecordCount ;  Recs = SELF.Records()
    ;                           ;  !ST::Debug('VLB:RecordCount='& Recs)
    ;                           ;  RETURN Recs
    ;OF VLB:RowParm:ElementCount;  ElementCount = SELF.GetElementCount()
    ;                           ;  !ST::Debug('VLB:GetElems='& ElementCount)
    ;                           ;  RETURN ElementCount
    ;OF VLB:RowParm:HasChanges  ;  HasDataChanged = SELF.HasDataChanged()
    ;                           ;  !ST::Debug('VLB:HasChanged='& HasDataChanged)
    ;                           ;  RETURN HasDataChanged
    ;ELSE                       ;  !ST::Debug('VLB:GetElem['& Row &':'& Elem &']='& SELF.GetElement(Row, Elem))
    ;                           ;  RETURN SELF.GetElement(Row, Elem)
  END

!==============================================================================
!UltimateVLB.TakeAccepted      PROCEDURE!,BYTE
!N                               LONG
!  CODE
!  IF NOT SELF.FromQueue &= NULL
!    N = CHOICE(SELF.FEQ)
!    GET(SELF.FromQueue, N)
!    IF ERRORCODE() = NoError
!      CHANGE(SELF.FEQ, SELF.FromQueue.Value)
!    END
!    SELF.FEQ{PROP:Selected} = N
!  END
!  RETURN Level:Benign

!==============================================================================
