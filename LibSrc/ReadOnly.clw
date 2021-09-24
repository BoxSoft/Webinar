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
