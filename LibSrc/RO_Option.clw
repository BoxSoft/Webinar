                              MEMBER

  INCLUDE('RO_Option.inc'),ONCE
  INCLUDE('Equates.clw'),ONCE
  INCLUDE('Errors.clw'),ONCE

                              MAP
                                !INCLUDE('STDebug.inc')
                              END

!==============================================================================
RO_Option.Init                PROCEDURE(BYTE Type,STRING Label,<String Picture>,<STRING Choices>,<? Value>)
  CODE
  SELF.Type    = Type
  SELF.Label   = Label
  SELF.Picture = Picture
  SELF.Choices = Choices
  SELF.SetValue(Value)

!==============================================================================
RO_Option.GetLabel            PROCEDURE!,STRING
  CODE
  RETURN SELF.Label

!==============================================================================
RO_Option.GetType             PROCEDURE!,BYTE
  CODE
  RETURN SELF.Type

!==============================================================================
RO_Option.ResetValue          PROCEDURE
  CODE
  CASE SELF.Type
    ;OF RO_Option_Type:Number;  SELF.SetValue(0    )
    ;OF RO_Option_Type:Date  ;  SELF.SetValue(0    )
    ;OF RO_Option_Type:Check ;  SELF.SetValue(FALSE)
    ;ELSE                    ;  SELF.SetValue(''   )
  END
  
!--------------------------------------
RO_Option.SetValue            PROCEDURE(? Value)
  CODE
  CASE SELF.Type
    ;OF RO_Option_Type:Number;  SELF.Value.Real   = Value
    ;OF RO_Option_Type:Date  ;  SELF.Value.Long   = Value
    ;OF RO_Option_Type:Check ;  SELF.Value.Long   = Value
    ;ELSE                    ;  SELF.Value.String = Value
  END
  
!--------------------------------------
RO_Option.GetValue            PROCEDURE!,?
  CODE
  CASE SELF.Type
    ;OF RO_Option_Type:Number;  RETURN SELF.Value.Real
    ;OF RO_Option_Type:Date  ;  RETURN SELF.Value.Long
    ;OF RO_Option_Type:Check ;  RETURN SELF.Value.Long
    ;ELSE                    ;  RETURN SELF.Value.String
  END

!--------------------------------------
RO_Option.GetValueForDisplay  PROCEDURE!,STRING
                              MAP
ChoiceForDisplay                PROCEDURE,STRING
                              END
  CODE
  CASE SELF.Type
    ;OF   RO_Option_Type:Number;
    ;OROF RO_Option_Type:Date  ;  RETURN LEFT(FORMAT(1*SELF.GetValue(), SELF.Picture))
    ;OF   RO_Option_Type:Check ;  RETURN CHOOSE(SELF.GetValue()=TRUE, 'Yes', '')
    ;OF   RO_Option_Type:Choice;  RETURN ChoiceForDisplay()
    ;ELSE                      ;  RETURN SELF.GetValue()
  END
  
ChoiceForDisplay              PROCEDURE!,STRING
  CODE
  RETURN SELF.GetValue()  !TODO - Check if "|#" exists in string, parse choices, and return display value corresponding with underlying value

!==============================================================================
RO_Option.Ask                 PROCEDURE!,BYTE
                              MAP
ShowControlAndAdjustWindow      PROCEDURE(SIGNED FEQ)
                              END
ReturnValue                     BYTE(Level:Cancel)
Value                           LIKE(RO_Option_ValueGroup)
Window                          WINDOW('Option'),AT(,,216,107),CENTER,MDI,GRAY,SYSTEM,ICON('RO_Option.ico'),FONT('Segoe UI',12),DOUBLE
                                  PROMPT('Prompt'),AT(8,8,200),USE(?Prompt)
                                  ENTRY(@n6b),AT(8,18,200,10),USE(Value.Real,, ?Number),HIDE
                                  ENTRY(@s20),AT(8,33,200,10),USE(Value.String,, ?String),HIDE
                                  ENTRY(@d1b),AT(8,47,200,10),USE(Value.Long,, ?Date),HIDE
                                  CHECK('Check'),AT(8,61),USE(Value.Long,, ?Check),HIDE
                                  LIST,AT(8,75,200,10),USE(Value.String,, ?Choice),HIDE,DROP(25),FROM('Choice')
                                  BUTTON('&OK'),AT(125,89,40,14),USE(?OK),DEFAULT
                                  BUTTON('Cancel'),AT(168,89,40,14),USE(?Cancel)
                                END
  CODE
  OPEN(Window)
  CASE SELF.Type
  OF RO_Option_Type:Number
    ?Prompt{PROP:Text} = SELF.Label
    ?Number{PROP:Text} = SELF.Picture
    ShowControlAndAdjustWindow(?Number)
  OF RO_Option_Type:String
    ?Prompt{PROP:Text} = SELF.Label
    ?String{PROP:Text} = SELF.Picture
    ShowControlAndAdjustWindow(?String)
  OF RO_Option_Type:Date
    ?Prompt{PROP:Text} = SELF.Label
    ?Date  {PROP:Text} = SELF.Picture
    ShowControlAndAdjustWindow(?Date)
  OF RO_Option_Type:Check
    HIDE(?Prompt)
    ?Check{PROP:Text} = SELF.Label
    ShowControlAndAdjustWindow(?Check)
  OF RO_Option_Type:Choice
    ?Prompt{PROP:Text} = SELF.Label
    ?Choice{PROP:From} = SELF.Choices
    ShowControlAndAdjustWindow(?Choice)
  ELSE
    ASSERT(FALSE, 'Unexpected Type='& SELF.Type &' in call to RO_Option.Ask')
    RETURN Level:Fatal
  END
  ACCEPT
    CASE EVENT()
    OF EVENT:Accepted
      CASE ACCEPTED()
      OF ?OK
        CASE SELF.Type
          ;OF RO_Option_Type:Number;  SELF.SetValue(Value.Real  )
          ;OF RO_Option_Type:Date  ;  SELF.SetValue(Value.Long  )
          ;OF RO_Option_Type:Check ;  SELF.SetValue(Value.Long  )
          ;ELSE                    ;  SELF.SetValue(Value.String)
        END
        ReturnValue = Level:Benign
        POST(EVENT:CloseWindow)
      OF ?Cancel
        POST(EVENT:CloseWindow)
      END
    END
  END
  RETURN ReturnValue
  
ShowControlAndAdjustWindow    PROCEDURE(SIGNED FEQ)
YPos                            LONG,AUTO
Margin                          BYTE,AUTO
ButtonY                         LONG,AUTO
  CODE
  YPos    = ?Prompt{PROP:YPos} + CHOOSE(~?Prompt{PROP:Hide}, 10, 0)
  Margin  = ?Prompt{PROP:YPos}
  ButtonY = YPos + FEQ{PROP:Height} + Margin
  
  FEQ    {PROP:YPos  } = YPos
  FEQ    {PROP:Hide  } = FALSE
  ?OK    {PROP:YPos  } = ButtonY
  ?Cancel{PROP:YPos  } = ButtonY
  Window {PROP:Height} = ButtonY + ?OK{PROP:Height} + Margin

  CHANGE(FEQ, SELF.GetValue())
  SELECT(FEQ)

  IF SELF.Type = RO_Option_Type:Choice AND NOT SELF.GetValue()
    FEQ{PROP:Selected} = 1
  END
  
!==============================================================================
! Utility Methods (do not use SELF)
!==============================================================================
RO_Option.NewOption           PROCEDURE!,*RO_Option
Object                          &RO_Option
  CODE
  Object &= NEW RO_Option
  RETURN Object
    
!--------------------------------------
RO_Option.NewNumber           PROCEDURE(STRING Label,String Picture,<REAL Value>)!,*RO_Option
Object                          &RO_Option
  CODE
  Object &= SELF.NewOption()
  Object.Init(RO_Option_Type:Number, Label, Picture,, Value)
  RETURN Object

!--------------------------------------
RO_Option.NewString           PROCEDURE(STRING Label,String Length ,<STRING Value>)!,*RO_Option
Object                          &RO_Option
  CODE
  Object &= SELF.NewOption()
  Object.Init(RO_Option_Type:String, Label, '@S'& Length,, Value)
  RETURN Object

!--------------------------------------
RO_Option.NewDate             PROCEDURE(STRING Label,String Picture,<LONG Value>)!,*RO_Option
Object                          &RO_Option
  CODE
  Object &= SELF.NewOption()
  Object.Init(RO_Option_Type:Date, Label, Picture,, Value)
  RETURN Object

!--------------------------------------
RO_Option.NewCheck            PROCEDURE(STRING Label,<BOOL Value>)!,*RO_Option
Object                          &RO_Option
  CODE
  Object &= SELF.NewOption()
  Object.Init(RO_Option_Type:Check, Label,,, Value)
  RETURN Object

!--------------------------------------
RO_Option.NewChoice           PROCEDURE(STRING Label,String Choices,<STRING Value>)!,*RO_Option
Object                          &RO_Option
  CODE
  Object &= SELF.NewOption()
  Object.Init(RO_Option_Type:Choice, Label,, Choices, Value)
  RETURN Object

!==============================================================================
