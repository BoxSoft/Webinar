                              MEMBER

  INCLUDE('MTD3_Grid.inc'),ONCE
  INCLUDE('Errors.clw'),ONCE

                              MAP
                                INCLUDE('STDebug.inc')
                              END

!==============================================================================
MTD3_Grid.Construct           PROCEDURE
Row                             BYTE,AUTO
Col                             BYTE,AUTO
  CODE
  LOOP Row = 1 TO MTD3_GRID:MAX_ROWS
    SELF.Cell[Row] = ALL(MTD3_Cell:Empty, MTD3_GRID:MAX_COLS)
  END
  
!==============================================================================
MTD3_Grid.Init                PROCEDURE(BYTE Rows,BYTE Cols,<STRING Cells>)
  CODE
  ASSERT(INRANGE(Rows, 1, MTD3_GRID:MAX_ROWS), 'Invalid Rows ('& Rows &') in call to MTD3_Grid.Init')
  ASSERT(INRANGE(Cols, 1, MTD3_GRID:MAX_COLS), 'Invalid Cols ('& Cols &') in call to MTD3_Grid.Init')
  SELF.Rows = Rows
  SELF.Cols = Cols
  IF OMITTED(Cells)
    SELF.Set(ALL(MTD3_Cell:Empty, Rows*Cols))
  ELSE
    SELF.Set(Cells)
  END
  
!==============================================================================
MTD3_Grid.Get                 PROCEDURE!,STRING
Str                             CLASS
S                                 &STRING
Construct_                        PROCEDURE(MTD3_Grid Grid)
Destruct                          PROCEDURE
                                END
Row                             BYTE,AUTO
Col                             BYTE,AUTO
  CODE
  Str.Construct_(SELF)
  LOOP Row = 1 TO SELF.Rows
    LOOP Col = 1 TO SELF.Cols
      Str.S[(Row-1)*SELF.Cols+Col] = SELF.GetCell(Row, Col)
    END
  END
  RETURN Str.S

Str.Construct_                PROCEDURE(MTD3_Grid Grid)
  CODE
  ASSERT(Grid.Rows AND Grid.Cols, 'Invalid Rows and/or Cols in MTD3_Grid.Get')
  SELF.S &= NEW STRING(Grid.Rows * Grid.Cols)

Str.Destruct                  PROCEDURE
  CODE
  DISPOSE(SELF.S)

!==============================================================================
MTD3_Grid.Set                 PROCEDURE(STRING Cells)
Row                             BYTE,AUTO
Col                             BYTE,AUTO
!Cell                            STRING(SELF.Cols),DIM(SELF.Rows),OVER(Cells)
  CODE
  ASSERT(SELF.Rows AND SELF.Cols, 'Invalid Rows and/or Cols in MTD3_Grid.Set')
  LOOP Row = 1 TO SELF.Rows
    LOOP Col = 1 TO SELF.Cols
      SELF.SetCell(Row, Col, Cells[(Row-1)*SELF.Cols+Col])
!      SELF.SetCell(Row, Col, Cells[(Row-1)*SELF.Cols+Col])
    END
  END
  
!==============================================================================
MTD3_Grid.Save                PROCEDURE!,*STRING
Saved                               &STRING
  CODE
  Saved &= NEW STRING(SELF.Rows * SELF.Cols)
  Saved  = SELF.Get()
  RETURN Saved
  
!==============================================================================
MTD3_Grid.GetCell             PROCEDURE(BYTE Row,BYTE Col)!,STRING
  CODE
  RETURN SELF.Cell[Row][Col]
  
!==============================================================================
MTD3_Grid.SetCell             PROCEDURE(BYTE Row,BYTE Col,STRING Cell)
  CODE
  SELF.Cell[Row][Col] = Cell
  
!==============================================================================
MTD3_Grid.CalcScore           PROCEDURE!,REAL
Row                             BYTE
Col                             BYTE
Damage                          LONG(0)
Cost                            LONG(0)
BoosterCost                     LONG(MTD3_BoosterBaseCost)
  CODE
  LOOP Row = 1 TO SELF.Rows
    LOOP Col = 1 TO SELF.Cols
      Damage += SELF.CalcDamage(Row, Col)
      CASE SELF.GetCell(Row, Col)
      OF   MTD3_Cell:Gun
      OROF MTD3_Cell:Missile
      OROF MTD3_Cell:Laser
        Cost += MTD3_WeaponCost
      OF   MTD3_Cell:Booster
      OF   '1' TO '9'
        Cost += BoosterCost
        BoosterCost += MTD3_BoosterIncrementalCost
      END
    END
  END
  RETURN 1.0 * Damage / Cost

!==============================================================================
MTD3_Grid.CalcDamage          PROCEDURE(BYTE Row,BYTE Col)!,LONG
                              MAP
IsNotMe                         PROCEDURE,BOOL  !Uses R & C
Multiplier                      PROCEDURE,BYTE
SetDamageAndTargetRange         PROCEDURE(BYTE WeaponRange,LONG WeaponDamage)
AreaDamage                      PROCEDURE,LONG
                              END
RangeClass                      CLASS,TYPE
Min                               SHORT
Max                               SHORT
Set                               PROCEDURE(BYTE Reach,BYTE Pos,BYTE Ceiling)
                                END
TargetRows                      RangeClass
TargetCols                      RangeClass
HitDamage                       LONG
R                               SHORT,AUTO
C                               SHORT,AUTO
  CODE
  CASE SELF.GetCell(Row, Col)
    ;OF MTD3_Cell:Laser  ;  SetDamageAndTargetRange(3, MTD3_WeaponDamage:Laser)
    ;OF MTD3_Cell:Missile;  SetDamageAndTargetRange(2, MTD3_WeaponDamage:Missle)
    ;OF MTD3_Cell:Gun    ;  SetDamageAndTargetRange(1, MTD3_WeaponDamage:Gun)
    ;ELSE                ;  RETURN 0
  END
  RETURN AreaDamage()
  
IsNotMe                       PROCEDURE!,BOOL
  CODE
  RETURN CHOOSE(R <> Row OR C <> Col)

Multiplier                    PROCEDURE!,BYTE
BoostRows                       RangeClass
BoostCols                       RangeClass
MultiplerReturn                 BYTE(1)
  CODE
  BoostRows.Set(1, Row, SELF.Rows)
  BoostCols.Set(1, Col, SELF.Cols)
  LOOP R = BoostRows.Min TO BoostRows.Max
    LOOP C = BoostCols.Min TO BoostCols.Max
      IF IsNotMe()
        CASE SELF.GetCell(R, C)
        OF MTD3_Cell:Booster OROF '1' TO '9'
          MultiplerReturn += 1
        END
      END
    END
  END
  RETURN MultiplerReturn
  
SetDamageAndTargetRange       PROCEDURE(BYTE WeaponRange,LONG WeaponDamage)
  CODE
  HitDamage = WeaponDamage * Multiplier()
  TargetRows.Set(WeaponRange, Row, SELF.Rows)
  TargetCols.Set(WeaponRange, Col, SELF.Cols)

AreaDamage                    PROCEDURE!,LONG
TotalDamage                     LONG(0)
  CODE
  !ST::Debug('TargetRows: '& TargetRows.Min &'-'& TargetRows.Max)
  !ST::Debug('TargetCols: '& TargetCols.Min &'-'& TargetCols.Max)
  LOOP R = TargetRows.Min TO TargetRows.Max
    LOOP C = TargetCols.Min TO TargetCols.Max
      IF IsNotMe()
        !ST::Debug('['& R &','& C &'] '& SELF.GetCell(R, C))
        IF SELF.GetCell(R, C) = MTD3_Cell:Path
          TotalDamage += HitDamage
        END
      END
    END
  END
  RETURN TotalDamage

RangeClass.Set                PROCEDURE(BYTE Reach,BYTE Pos,BYTE Ceiling)
  CODE
  SELF.Min = Pos - Reach;  IF SELF.Min < 1       THEN SELF.Min = 1.
  SELF.Max = Pos + Reach;  IF SELF.Max > Ceiling THEN SELF.Max = Ceiling.

!==============================================================================
MTD3_Grid.Show                PROCEDURE
Window                          WINDOW('Mini TD 3'),AT(,,150,150),CENTER,SYSTEM,FONT('Consolas',24,COLOR:White,FONT:bold),COLOR(COLOR:Black),DOUBLE
                                  STRING('X'),AT(4,4,9,9),USE(?CellSample),TRN,HIDE,CENTER
                                END
Row                             BYTE,AUTO
Col                             BYTE,AUTO
OrigX                           LONG,AUTO
X                               LONG,AUTO
Y                               LONG,AUTO
W                               LONG,AUTO
H                               LONG,AUTO
FEQ                             SIGNED,AUTO
  CODE
  OPEN(Window)
  Window{PROP:Pixels} = True
  GETPOSITION(?CellSample, OrigX, Y, W, H)
  LOOP Row = 1 TO SELF.Rows
    X = OrigX
    LOOP Col = 1 TO SELF.Cols
      FEQ = CREATE(0, CREATE:string)
      SETPOSITION(FEQ, X, Y, W, H)
      FEQ{PROP:Text}   = SELF.GetCell(Row, Col)
      FEQ{PROP:Center} = ?CellSample{PROP:Center}
      FEQ{PROP:Trn}    = ?CellSample{PROP:Trn}
      CASE FEQ{PROP:Text}
        ;OF MTD3_Cell:Path   ;  FEQ{PROP:FontColor} = COLOR:Gray
        ;OF MTD3_Cell:Gun    ;  FEQ{PROP:FontColor} = COLOR:White
        ;OF MTD3_Cell:Missile;  FEQ{PROP:FontColor} = COLOR:Red
        ;OF MTD3_Cell:Laser  ;  FEQ{PROP:FontColor} = COLOR:Fuschia
        ;OF MTD3_Cell:Booster;  FEQ{PROP:FontColor} = COLOR:Yellow
        ;OF '1' TO '9'       ;  FEQ{PROP:FontColor} = COLOR:Yellow
      END
      UNHIDE(FEQ)
      X += W
    END
    Y += H
  END
  Window{PROP:Pixels} = False
  ACCEPT
  END
      
!==============================================================================
MTD3_Grid.Optimize            PROCEDURE(BOOL FindBoosters=TRUE)
                              MAP
FindBoosters                    PROCEDURE
                              END
WeaponGroup                     GROUP
                                  STRING(MTD3_Cell:Gun)
                                  STRING(MTD3_Cell:Missile)
                                  STRING(MTD3_Cell:Laser)
                                END
Weapons                         STRING(SIZE(WeaponGroup)),OVER(WeaponGroup)
WeaponDamage                    LONG,AUTO
BestWeapon                      STRING(1),AUTO
BestDamage                      LONG,AUTO
Row                             BYTE,AUTO
Col                             BYTE,AUTO
Weapon                          BYTE,AUTO
  CODE
  LOOP Row = 1 TO SELF.Rows
    LOOP Col = 1 TO SELF.Cols
      IF SELF.GetCell(Row, Col) <> MTD3_Cell:Path
        BestDamage = 0
        LOOP Weapon = 1 TO SIZE(WeaponGroup)
          SELF.SetCell(Row, Col, Weapons[Weapon])
          WeaponDamage = SELF.CalcDamage(Row, Col)
          IF BestDamage < WeaponDamage
            BestDamage = WeaponDamage
            BestWeapon = Weapons[Weapon]
          END
        END
        SELF.SetCell(Row, Col, BestWeapon)
      END
    END
  END
  IF FindBoosters
    !SELF.Show()
    FindBoosters()
  END
  
FindBoosters                  PROCEDURE
BaseGrid                        &STRING
BaseScore                       REAL
OptimalQ                        QUEUE
Grid                              &STRING
Score                             REAL
                                END
TestScore                       REAL,AUTO
BoosterNumber                   BYTE(1)
  CODE
  BaseGrid    &= NEW STRING(SELF.Rows * SELF.Cols)
  BaseGrid     = SELF.Get()
  BaseScore    = SELF.CalcScore()
    
  LOOP !8 TIMES
    ST::Debug('------------------')
    ST::Debug('BaseScore: '& BaseScore)
    LOOP Row = 1 TO SELF.Rows
      LOOP Col = 1 TO SELF.Cols
        CASE SELF.GetCell(Row, Col)
        OF   MTD3_Cell:Laser
        OROF MTD3_Cell:Missile
        OROF MTD3_Cell:Gun
          SELF.SetCell(Row, Col, BoosterNumber)
          TestScore = SELF.CalcScore()
          ST::Debug('['& Row &','& Col &'] '& TestScore)
          IF BaseScore < TestScore
            CLEAR(OptimalQ)
            OptimalQ.Grid &= NEW STRING(SELF.Rows * SELF.Cols)
            OptimalQ.Grid  = SELF.Get()
            OptimalQ.Score = TestScore
            ADD(OptimalQ, OptimalQ.Score)
          END
          SELF.Set(BaseGrid)
        END
      END
    END
    IF RECORDS(OptimalQ)
      GET(OptimalQ, RECORDS(OptimalQ))
      BaseGrid     = OptimalQ.Grid
      BaseScore    = OptimalQ.Score
    
      LOOP WHILE RECORDS(OptimalQ)
        GET(OptimalQ, 1)
        DISPOSE(OptimalQ.Grid)
        DELETE(OptimalQ)
      END
      BoosterNumber += 1
    ELSE
      BREAK
    END
  END
  SELF.Set(BaseGrid)
  DISPOSE(BaseGrid)
  
!==============================================================================
MTD3_Grid.OptimizeVisually    PROCEDURE
                              MAP
InitWindow                      PROCEDURE
CalcFEQ                         PROCEDURE(BYTE R,BYTE C),SIGNED
ApplyColor                      PROCEDURE(SIGNED FEQ)
FindAnother                     PROCEDURE
FindBoosters                    PROCEDURE
                              END
Window                          WINDOW('Mini TD 3'),AT(,,150,136),CENTER,SYSTEM,FONT('Consolas',24,COLOR:White,FONT:bold),COLOR(COLOR:Black),DOUBLE
                                  BUTTON('!'),AT(4,4,12,12),USE(?Go,1000),DEFAULT,FLAT
                                  STRING('X'),AT(20,4,9,9),USE(?CellSample,1001),TRN,HIDE,CENTER
                                END
WeaponGroup                     GROUP
                                  STRING(MTD3_Cell:Gun)
                                  STRING(MTD3_Cell:Missile)
                                  STRING(MTD3_Cell:Laser)
                                  STRING(MTD3_Cell:Booster)
                                END
Weapons                         STRING(SIZE(WeaponGroup)),OVER(WeaponGroup)
Row                             BYTE,AUTO
Col                             BYTE,AUTO
LastPlacement                   SIGNED(0)
OptimalQ                        QUEUE
Grid                              &STRING
Row                               BYTE
Col                               BYTE
Weapon                            STRING(1)
Score                             REAL
                                END
BaseGrid                        &STRING
  CODE
  InitWindow()
  ACCEPT
    IF ACCEPTED() = 1000
      FindAnother()
    END
  END

InitWindow                    PROCEDURE
OrigX                           LONG,AUTO
X                               LONG,AUTO
Y                               LONG,AUTO
W                               LONG,AUTO
H                               LONG,AUTO
FEQ                             SIGNED,AUTO
  CODE
  OPEN(Window)
  Window{PROP:Pixels} = TRUE
  GETPOSITION(?CellSample, OrigX, Y, W, H)
  LOOP Row = 1 TO SELF.Rows
    X = OrigX
    LOOP Col = 1 TO SELF.Cols
      FEQ = CREATE(CalcFEQ(Row, Col), CREATE:string)
      SETPOSITION(FEQ, X, Y, W, H)
      FEQ{PROP:Text}   = SELF.GetCell(Row, Col)
      FEQ{PROP:Center} = TRUE
      FEQ{PROP:Trn}    = TRUE
      ApplyColor(FEQ)
      UNHIDE(FEQ)
      X += W
    END
    Y += H
  END
  Window{PROP:Pixels} = FALSE

CalcFEQ                       PROCEDURE(BYTE R,BYTE C)
  CODE
  RETURN (R - 1) * SELF.Cols + C
  
ApplyColor                    PROCEDURE(SIGNED FEQ)
  CODE
  CASE FEQ{PROP:Text}
    ;OF MTD3_Cell:Path   ;  FEQ{PROP:FontColor} = COLOR:Gray
    ;OF MTD3_Cell:Gun    ;  FEQ{PROP:FontColor} = COLOR:White
    ;OF MTD3_Cell:Missile;  FEQ{PROP:FontColor} = COLOR:Red
    ;OF MTD3_Cell:Laser  ;  FEQ{PROP:FontColor} = COLOR:Fuschia
    ;OF MTD3_Cell:Booster;  FEQ{PROP:FontColor} = COLOR:Yellow
    ;OF '1' TO '9'       ;  FEQ{PROP:FontColor} = COLOR:Yellow
  END

FindAnother                   PROCEDURE
Weapon                          BYTE,AUTO
  CODE
  IF LastPlacement <> 0
    LastPlacement{PROP:Trn} = TRUE
  END
  !STOP(SELF.Get())

  LOOP Row = 1 TO SELF.Rows
    LOOP Col = 1 TO SELF.Cols
      IF SELF.GetCell(Row, Col) = MTD3_Cell:Empty
        LOOP Weapon = 1 TO SIZE(WeaponGroup)
          IF LastPlacement = 0 AND Weapons[Weapon] <> MTD3_Cell:Gun
            CYCLE
          END
          
          SELF.SetCell(Row, Col, Weapons[Weapon])

          CLEAR(OptimalQ)
!         OptimalQ.Grid  &= NEW STRING(SELF.Rows * SELF.Cols)
!         OptimalQ.Grid   = SELF.Get()
          OptimalQ.Row    = Row
          OptimalQ.Col    = Col
          OptimalQ.Weapon = Weapons[Weapon]
          OptimalQ.Score  = SELF.CalcScore()
          ADD(OptimalQ)

          SELF.SetCell(Row, Col, MTD3_Cell:Empty)
        END
      END
    END
  END
  
  IF RECORDS(OptimalQ) = 0
    LastPlacement = 0
  ELSE
    SORT(OptimalQ, OptimalQ.Score)
    GET(OptimalQ, RECORDS(OptimalQ))
    
    LastPlacement            = CalcFEQ(OptimalQ.Row, OptimalQ.Col)
    LastPlacement{PROP:Text} = OptimalQ.Weapon
    LastPlacement{PROP:Trn}  = FALSE
    ApplyColor(LastPlacement)
    
    SELF.SetCell(OptimalQ.Row, OptimalQ.Col, OptimalQ.Weapon)

!    LOOP WHILE RECORDS(OptimalQ)
!      GET(OptimalQ, 1)
!      DISPOSE(OptimalQ.Grid)
!      DELETE(OptimalQ)
!    END
    FREE(OptimalQ)
  END
  
FindBoosters                  PROCEDURE
BaseScore                       REAL
TestScore                       REAL,AUTO
BoosterNumber                   BYTE(1)
  CODE
  BaseGrid &= SELF.Save()
  BaseScore = SELF.CalcScore()
    
  LOOP 6 TIMES
    ST::Debug('------------------')
    ST::Debug('BaseScore: '& BaseScore)
    LOOP Row = 1 TO SELF.Rows
      LOOP Col = 1 TO SELF.Cols
        CASE SELF.GetCell(Row, Col)
        OF   MTD3_Cell:Laser
        OROF MTD3_Cell:Missile
        OROF MTD3_Cell:Gun
          SELF.SetCell(Row, Col, BoosterNumber)
          TestScore = SELF.CalcScore()
          ST::Debug('['& Row &','& Col &'] '& TestScore)
          IF BaseScore < TestScore
            CLEAR(OptimalQ)
            OptimalQ.Grid &= NEW STRING(SELF.Rows * SELF.Cols)
            OptimalQ.Grid  = SELF.Get()
            OptimalQ.Row   = Row
            OptimalQ.Col   = Col
            OptimalQ.Score = TestScore
            ADD(OptimalQ)
          END
          SELF.Set(BaseGrid)
        END
      END
    END
    IF RECORDS(OptimalQ)
      SORT(OptimalQ, OptimalQ.Score)
      GET(OptimalQ, RECORDS(OptimalQ))
      BaseGrid     = OptimalQ.Grid
      BaseScore    = OptimalQ.Score
    
      LOOP WHILE RECORDS(OptimalQ)
        GET(OptimalQ, 1)
        DISPOSE(OptimalQ.Grid)
        DELETE(OptimalQ)
      END
      BoosterNumber += 1
    ELSE
      BREAK
    END
  END
  SELF.Set(BaseGrid)
  DISPOSE(BaseGrid)

!==============================================================================
