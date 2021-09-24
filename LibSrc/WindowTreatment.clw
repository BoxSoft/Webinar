  MEMBER

  INCLUDE('WindowTreatment.inc'),ONCE
  INCLUDE('Property.clw'),ONCE

  MAP
  END

WindowTreatment.ScanControls  PROCEDURE(WindowTreatmentControlInterface ControlInterface)
FEQ                             LONG,AUTO
  CODE
  FEQ = 0
  LOOP
    FEQ = 0{PROP:NextField, FEQ}
    IF FEQ = 0 THEN BREAK.
    !IF FEQ < 0 THEN CYCLE.  !Menu controls on frame
    IF ControlInterface.NeedsTreatment(FEQ)
      ControlInterface.Treat(FEQ)
    END
  END
