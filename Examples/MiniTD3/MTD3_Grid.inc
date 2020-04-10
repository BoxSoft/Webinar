  INCLUDE('MTD3_Cell.inc'),ONCE

MTD3_GRID:MAX_ROWS            EQUATE(20)
MTD3_GRID:MAX_COLS            EQUATE(20)

MTD3_Grid                     CLASS,TYPE,MODULE('MTD3_Grid.clw'),LINK('MTD3_Grid.clw')
Cell                            STRING(MTD3_GRID:MAX_COLS),DIM(MTD3_GRID:MAX_ROWS)
Rows                            BYTE
Cols                            BYTE

Construct                       PROCEDURE
Init                            PROCEDURE(BYTE Rows,BYTE Cols,<STRING Cells>)
Get                             PROCEDURE,STRING
Set                             PROCEDURE(STRING Cells)
Save                            PROCEDURE,*STRING
GetCell                         PROCEDURE(BYTE Row,BYTE Col),STRING
SetCell                         PROCEDURE(BYTE Row,BYTE Col,STRING Cell)
CalcScore                       PROCEDURE,REAL
CalcDamage                      PROCEDURE(BYTE Row,BYTE Col),LONG
Optimize                        PROCEDURE(BOOL FindBoosters=TRUE)
OptimizeVisually                PROCEDURE
Show                            PROCEDURE
                              END
