  MEMBER

  INCLUDE('TimeJumper.inc'),Once
  INCLUDE('Keycodes.clw'),Once

  MAP
  END

TimeJumperClass.InitWindow    PROCEDURE
WT                              WindowTreatment
  CODE
  WT.ScanControls(SELF.WindowTreatmentControlInterface)
  
TimeJumperClass.WindowTreatmentControlInterface.NeedsTreatment    PROCEDURE(SIGNED FEQ)!,BOOL
  CODE
  CASE FEQ{PROP:Type}
  OF CREATE:entry OROF CREATE:spin
    IF UPPER(SUB(FEQ{PROP:Text}, 1, 1)) = 'T'
      IF NOT FEQ{PROP:ReadOnly}
        RETURN True
      END
    END
  END
  RETURN False
  
TimeJumperClass.WindowTreatmentControlInterface.Treat PROCEDURE(SIGNED FEQ)
  CODE
  FEQ{PROP:Alrt, 255} = HomeKey   !Now
  FEQ{PROP:Alrt, 255} = NKey      !Now
  FEQ{PROP:Alrt, 255} = HKey      !Prev Hour
  FEQ{PROP:Alrt, 255} = RKey      !Next Hour
  FEQ{PROP:Alrt, 255} = MKey      !Prev Minute
  FEQ{PROP:Alrt, 255} = EKey      !Next Minute
  !FEQ{PROP:Alrt, 255} = MKey     !Midnight
  !FEQ{PROP:Alrt, 255} = NKey     !Noon

TimeJumperClass.TakeEvent     PROCEDURE
                              MAP
TakeHotKey                      PROCEDURE(SIGNED FEQ)
                              END
PeriodClass                     CLASS,TYPE
Min                               LONG
Max                               LONG
Construct                         PROCEDURE
GetP                              PROCEDURE,LONG,VIRTUAL
Mod                               PROCEDURE(LONG T),LONG
Prev                              PROCEDURE(LONG T),LONG
Next                              PROCEDURE(LONG T),LONG
                                END
HourClass                       CLASS(PeriodClass)
GetP                              PROCEDURE,LONG,DERIVED
                                END
MinuteClass                     CLASS(PeriodClass)
GetP                              PROCEDURE,LONG,DERIVED
                                END
  CODE
  IF EVENT() = EVENT:AlertKey
    IF SELF.ControlNeedsTreatment(FIELD())
      TakeHotKey(FIELD())
    END
  END
  RETURN Level:Benign

TakeHotKey                    PROCEDURE(LONG FEQ)
  CODE
  CASE KEYCODE()
    ;OF HomeKey;  CHANGE(FEQ, CLOCK()) 
    ;OF NKey   ;  CHANGE(FEQ, CLOCK())
    ;OF HKey   ;  CHANGE(FEQ, HourClass.Prev  (CONTENTS(FEQ)))
    ;OF RKey   ;  CHANGE(FEQ, HourClass.Next  (CONTENTS(FEQ)))
    ;OF MKey   ;  CHANGE(FEQ, MinuteClass.Prev(CONTENTS(FEQ)))
    ;OF EKey   ;  CHANGE(FEQ, MinuteClass.Next(CONTENTS(FEQ)))
!   ;OF MKey   ;  CHANGE(FEQ, TIME:MIDNIGHT) 
!   ;OF NKey   ;  CHANGE(FEQ, TIME:MIDNIGHT + 12 * 60 * 60 * 100)
  END

PeriodClass.Construct         PROCEDURE
  CODE
  SELF.Min = TIME:MIDNIGHT
  SELF.Max = TIME:DAY - SELF.GetP()
  
PeriodClass.GetP              PROCEDURE!,LONG
  CODE
  ASSERT(FALSE, 'PeriodClass.GetP is an abstract virtual method, and must be derived!')
  RETURN 0

PeriodClass.Mod               PROCEDURE(LONG T)!,LONG
  CODE
  RETURN (T-1) % SELF.GetP()
  
PeriodClass.Prev              PROCEDURE(LONG T)!,LONG
Mod                             LONG,AUTO
  CODE
  IF T <= SELF.Min THEN RETURN T.
  
  Mod = SELF.Mod(T)
  IF Mod > 0
    RETURN T - Mod
  ELSE
    RETURN T - SELF.GetP()
  END

PeriodClass.Next              PROCEDURE(LONG T)!,LONG
Mod                             LONG,AUTO
  CODE
  IF T > SELF.Max THEN RETURN T.
  
  Mod = SELF.Mod(T)
  IF Mod > 0
    RETURN T + SELF.GetP() - Mod
  ELSE
    RETURN T + SELF.GetP()
  END

HourClass.GetP                PROCEDURE!,LONG
  CODE
  RETURN TIME:Hour
  
MinuteClass.GetP              PROCEDURE!,LONG
  CODE
  RETURN TIME:Minute
