                              MEMBER

  INCLUDE('RO_Options.inc'),ONCE
  INCLUDE('Equates.clw'),ONCE
  INCLUDE('Errors.clw'),ONCE
  INCLUDE('Keycodes.clw'),ONCE

COLOR:GreenBar                EQUATE(0F0F0F0h)

                              MAP
                                !INCLUDE('STDebug.inc')
                              END

!==============================================================================
RO_Options.Construct          PROCEDURE
  CODE
  SELF.OptionQ &= NEW RO_Option_Queue

!==============================================================================
RO_Options.Destruct           PROCEDURE
  CODE
  LOOP WHILE RECORDS(SELF.OptionQ)
    GET(SELF.OptionQ, 1)
    IF SELF.OptionQ.AutoDispose
      DISPOSE(SELF.OptionQ.Option)
    END
    DELETE(SELF.OptionQ)
  END
  DISPOSE(SELF.OptionQ)
  
!==============================================================================
RO_Options.AddOption          PROCEDURE(LONG ID)!,*RO_Option
Object                          &RO_Option
  CODE
  Object &= NEW RO_Option
  RETURN SELF.AddOption(ID, Object, TRUE)
  
!==============================================================================
RO_Options.AddOption          PROCEDURE(BYTE ID,RO_Option Option,<BOOL AutoDispose>)!,*RO_Option
  CODE
  SELF.OptionQ.ID          = ID
  SELF.OptionQ.Option     &= Option
  SELF.OptionQ.AutoDispose = AutoDispose
  ADD(SELF.OptionQ)
  
  RETURN Option

!==============================================================================
RO_Options.Ask                PROCEDURE!,BYTE
                                ITEMIZE(1)
STYLE:LABEL_NORMAL                EQUATE
STYLE:LABEL_GREEN                 EQUATE
STYLE:VALUE_NORMAL                EQUATE
STYLE:VALUE_GREEN                 EQUATE
                                END
                              MAP
AddStyles                       PROCEDURE
FillQ                           PROCEDURE
AdjustHeight                    PROCEDURE
FetchListItem                   PROCEDURE,BYTE
UpdateQValue                    PROCEDURE
                              END
ReturnValue                     BYTE(Level:Cancel)
Q                               QUEUE
Label                             STRING(255)
Label_Style                       LONG
Value                             STRING(255)
Value_Style                       LONG
ID                                BYTE
                                END
LabelWidth                      LONG(0)
Window                          WINDOW('Options'),AT(,,308,320),CENTER,MDI,GRAY,SYSTEM,ICON('RO_Option.ico'),FONT('Segoe UI',12),DOUBLE
                                  LIST,AT(4,4,300,294),USE(?List),VSCROLL,FROM(Q),FORMAT('200L(2)|Y@S250@200L(2)Y@S250@'),ALRT(MouseLeft2)
                                  BUTTON('&Set'),AT(4,302,40,14),USE(?Set),DEFAULT
                                  BUTTON('&Reset'),AT(47,302,40,14),USE(?Reset)
                                  BUTTON('&OK'),AT(222,302,40,14),USE(?OK)
                                  BUTTON('Cancel'),AT(265,302,40,14),USE(?Cancel)
                                  STRING('Label'),AT(89,306),USE(?Label),HIDE
                                END
  CODE
  OPEN(Window)
  AddStyles()
  HIDE(0)
  ACCEPT
    CASE EVENT()
    OF EVENT:OpenWindow
      FillQ()
      IF LabelWidth > 0
        ?List{PROPLIST:Width, 1} = LabelWidth + 6
      END
      AdjustHeight()
      UNHIDE(0)
      SELECT(?List, 1)
    OF EVENT:Accepted
      CASE ACCEPTED()
      OF ?Set
        IF FetchListItem() = Level:Benign
          IF SELF.OptionQ.Option.Ask() = Level:Benign
            UpdateQValue()
          END
        END
        SELECT(?List)
      OF ?Reset
        IF FetchListItem() = Level:Benign
          SELF.OptionQ.Option.ResetValue()
          UpdateQValue()
        END
        SELECT(?List)
      OF ?OK
        ReturnValue = Level:Benign
        POST(EVENT:CloseWindow)
      OF ?Cancel
        POST(EVENT:CloseWindow)
      END  
    OF EVENT:AlertKey
      IF FIELD() = ?List AND KEYCODE() = MouseLeft2
        POST(EVENT:Accepted, ?Set)
      END
    END
  END
  RETURN ReturnValue
  
!--------------------------------------
AddStyles                     PROCEDURE
                              MAP
AddStyle                        PROCEDURE(BYTE Style)
                              END
  CODE
  AddStyle(STYLE:LABEL_NORMAL)
  AddStyle(STYLE:LABEL_GREEN )
  AddStyle(STYLE:VALUE_NORMAL)
  AddStyle(STYLE:VALUE_GREEN )

AddStyle                      PROCEDURE(BYTE Style)
FONT:WithoutWeight              EQUATE(0FFFFF800h)
StyleWithoutWeight              LONG,AUTO
StyleWithWeight                 LONG,AUTO
BackColor                       LONG,AUTO
  CODE
  StyleWithoutWeight = BAND(0{PROP:FontStyle}, FONT:WithoutWeight)
  StyleWithWeight    = BOR(StyleWithoutWeight, CHOOSE(~INLIST(Style, STYLE:VALUE_NORMAL, STYLE:VALUE_GREEN), 0         , FONT:Bold     ))
  BackColor          =                         CHOOSE(~INLIST(Style, STYLE:LABEL_GREEN , STYLE:VALUE_GREEN), COLOR:NONE, COLOR:GreenBar)
  
  ?List{PROPSTYLE:FontName    , Style} = 0{PROP:FontName}
  ?List{PROPSTYLE:FontSize    , Style} = 0{PROP:FontSize}
  ?List{PROPSTYLE:FontStyle   , Style} = StyleWithWeight
  ?List{PROPSTYLE:TextColor   , Style} = COLOR:NONE
  ?List{PROPSTYLE:BackColor   , Style} = BackColor
  ?List{PROPSTYLE:TextSelected, Style} = COLOR:NONE
  ?List{PROPSTYLE:BackSelected, Style} = COLOR:NONE

!--------------------------------------
FillQ                         PROCEDURE
                              MAP
IsGreen                         PROCEDURE,BOOL
DetermineMaxLabelWidth          PROCEDURE
                              END
X                               LONG,AUTO
  CODE
  LOOP X = 1 TO RECORDS(SELF.OptionQ)
    GET(SELF.OptionQ, X)

    CLEAR(Q)
    Q.Label       = SELF.OptionQ.Option.GetLabel()
    Q.Value       = SELF.OptionQ.Option.GetValueForDisplay()
    Q.ID          = SELF.OptionQ.ID

    Q.Label_Style = CHOOSE(IsGreen(), STYLE:LABEL_GREEN, STYLE:LABEL_NORMAL)
    Q.Value_Style = CHOOSE(IsGreen(), STYLE:VALUE_GREEN, STYLE:VALUE_NORMAL)

    ADD(Q)
    
    DetermineMaxLabelWidth()
  END

IsGreen                       PROCEDURE!,BOOL
  CODE
  RETURN CHOOSE(X % 2 = 0)
  
DetermineMaxLabelWidth        PROCEDURE
ThisWidth                       LONG,AUTO
  CODE
  ?Label{PROP:Text} = SELF.OptionQ.Option.GetLabel()
  ThisWidth = ?Label{PROP:Width}
  IF LabelWidth < ThisWidth
    LabelWidth = ThisWidth
  END

!--------------------------------------
AdjustHeight                  PROCEDURE
                              MAP
AdjustProp                      PROCEDURE(STRING Prop,SIGNED FEQ,REAL Fraction=1)
                              END
LINE_HEIGHT                     EQUATE(10)
Adjustment                      LONG,AUTO
  CODE
  ?List{PROP:LineHeight} = LINE_HEIGHT
  Adjustment = ?List{PROP:Height} - RECORDS(Q) * LINE_HEIGHT - 1
  IF Adjustment > 0
    AdjustProp(PROP:Height, ?List  )
    AdjustProp(PROP:YPos  , ?Set   )
    AdjustProp(PROP:YPos  , ?Reset )
    AdjustProp(PROP:YPos  , ?OK    )
    AdjustProp(PROP:YPos  , ?Cancel)
    AdjustProp(PROP:Height, 0      )
    AdjustProp(PROP:YPos  , 0, -1/2)
  END

AdjustProp                    PROCEDURE(STRING Prop,SIGNED FEQ,REAL Fraction)
  CODE
  FEQ{Prop} = FEQ{Prop} - Adjustment * Fraction
  
!--------------------------------------
FetchListItem                 PROCEDURE!,BYTE
  CODE
  GET(Q, CHOICE(?List))
  IF ERRORCODE() = NoError
    GET(SELF.OptionQ, CHOICE(?List))
    RETURN Level:Benign
  ELSE
    RETURN Level:Notify
  END
  
!--------------------------------------
UpdateQValue                  PROCEDURE
  CODE
  Q.Value = SELF.OptionQ.Option.GetValueForDisplay()
  PUT(Q)
  
!==============================================================================
RO_Options.FetchByIndex       PROCEDURE(LONG QIndex,*RO_Option_Group OptionG)!,BYTE
  CODE
  GET(SELF.OptionQ, QIndex)
  IF ERRORCODE() = NoError
    OptionG = SELF.OptionQ
    RETURN Level:Benign
  ELSE
    CLEAR(OptionG)
    RETURN Level:Notify
  END

!==============================================================================
RO_Options.FetchByID          PROCEDURE(LONG ID)!,BYTE
  CODE
  SELF.OptionQ.ID = ID
  GET(SELF.OptionQ, SELF.OptionQ.ID)
  RETURN CHOOSE(ERRORCODE()=NoError, Level:Benign, Level:Notify)

!==============================================================================
RO_Options.GetValue           PROCEDURE(LONG ID)!,?
  CODE
  IF SELF.FetchByID(ID) = Level:Benign
    RETURN SELF.OptionQ.Option.GetValue()
  END
  RETURN ''
  
!==============================================================================
RO_Options.GetValueForDisplay PROCEDURE(LONG ID)!,STRING
  CODE
  IF SELF.FetchByID(ID) = Level:Benign
    RETURN SELF.OptionQ.Option.GetValueForDisplay()
  END
  RETURN ''
  
!==============================================================================
RO_Options.Records            PROCEDURE!,LONG
  CODE
  RETURN RECORDS(SELF.OptionQ)

!==============================================================================
RO_Options.ResetValues        PROCEDURE
X                               LONG,AUTO
  CODE
  LOOP X = 1 TO RECORDS(SELF.OptionQ)
    GET(SELF.OptionQ, X)
    SELF.OptionQ.Option.ResetValue()
  END
  
!==============================================================================
