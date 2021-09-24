                              MEMBER

  INCLUDE('ReadOnly.inc'),ONCE
  INCLUDE('Property.clw'),ONCE

                              MAP
                              END

ReadOnlyClass.InitWindow      PROCEDURE
WT                              WindowTreatment
  CODE
  WT.ScanControls(SELF.WindowTreatmentControlInterface)
  
ReadOnlyClass.WindowTreatmentControlInterface.NeedsTreatment  PROCEDURE(SIGNED FEQ)!,BOOL
  CODE
  RETURN CHOOSE(FEQ{PROP:ReadOnly} AND NOT (FEQ{PROP:Skip} AND FEQ{PROP:Trn}))
  
ReadOnlyClass.WindowTreatmentControlInterface.Treat   PROCEDURE(SIGNED FEQ)

  Code
  IF NOT FEQ{PROP:Skip} THEN FEQ{PROP:Skip} = True.
  IF NOT FEQ{PROP:Trn } THEN FEQ{PROP:Trn } = True.
  DO RemoveAmpersandFromPrompt

RemoveAmpersandFromPrompt     ROUTINE
  DATA
PromptFEQ   SIGNED,AUTO
PromptStr   &STRING
PromptLen   LONG,AUTO
PromptAmp   LONG,AUTO
  CODE
  PromptFEQ = FEQ{PROP:Follows}
  IF PromptFEQ <> 0 AND PromptFEQ{PROP:Type} = CREATE:Prompt
    PromptLen = LEN(PromptFEQ{PROP:Text})
    IF PromptLen > 0
      PromptStr &= NEW STRING(PromptLen)
      PromptStr  = PromptFEQ{PROP:Text}
      PromptAmp  = INSTRING('&', PromptFEQ{PROP:Text})
      CASE PromptAmp
        ;OF 0 OROF PromptLen;  !No-op
        ;OF 1               ;  PromptFEQ{PROP:Text} = PromptStr[2 : PromptLen]
        ;ELSE               ;  PromptFEQ{PROP:Text} = PromptStr[1 : PromptAmp-1] & PromptStr[PromptAmp+1 : PromptLen]
      END
      DISPOSE(PromptStr)
    END
  END
