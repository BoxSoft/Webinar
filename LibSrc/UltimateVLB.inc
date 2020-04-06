!ABCIncludeFile

UltVLB:Justify:Default        EQUATE('D')
UltVLB:Justify:Left           EQUATE('L')
UltVLB:Justify:Right          EQUATE('R')
UltVLB:Justify:Center         EQUATE('C')
                                      
UltVLB:Offset:Data            EQUATE(2)
UltVLB:Offset:Header          EQUATE(1)

UltVLB:Width:String           EQUATE(100)
UltVLB:Width:Number           EQUATE(40)

                              ITEMIZE(0)
UltVLB:Icon:None               EQUATE
UltVLB:Icon:Regular            EQUATE
UltVLB:Icon:Transparent        EQUATE
                              END

                              ITEMIZE(0)
UltVLB:Color:None               EQUATE
UltVLB:Color:Regular            EQUATE
UltVLB:Color:Pretend            EQUATE
                              END

!                              ITEMIZE(1)
!UltVLB:QColor:NormalFG          EQUATE
!UltVLB:QColor:NormalBG          EQUATE
!UltVLB:QColor:SelectedFG        EQUATE
!UltVLB:QColor:SelectedBG        EQUATE
!                              END

UltVLB:ColumnGroup            GROUP,TYPE
FieldNo                         LONG        !Queue field number
FieldRef                        ANY         !Queue field reference
NormalFGRef                     ANY
NormalBGRef                     ANY
SelectedFGRef                   ANY
SelectedBGRef                   ANY
IconRef                         ANY         !Icon  field reference
TreeRef                         ANY         !Tree  field reference
StyleRef                        ANY         !Style field reference
TipRef                          ANY         !Tip   field reference
!FieldName                      STRING(255) !Queue field name (for sorting)
Header                          STRING(255) !Saved Header text, also used for descriptive field name
!GroupHeader                    STRING(255) !Saved Group Header text    !MJH 2009/10/16
Width                           SHORT       !Column Width
Picture                         STRING(50)  !Column Picture
Justification                   STRING(1)   !Column Justification: L/R/C/D
Offset                          SHORT       !Column Justification Offset
HJustification                  STRING(1)   !Header Justification: L/R/C/D
HOffset                         SHORT       !Header Justification Offset
IsFixed                         BOOL
IsResizable                     BOOL
Color                           BYTE
Icon                            BYTE
HasRightBorder                  BOOL
HasTree                         BOOL
HasTreeBoxes                    BOOL
HasTreeIndent                   BOOL
HasTreeLines                    BOOL
HasTreeOffset                   BOOL
HasTreeRoot                     BOOL
HasStyle                        BOOL
HasTip                          BOOL
                              END

UltVLB:ColumnClass            CLASS(UltVLB:ColumnGroup),TYPE,MODULE('UltimateVLB.clw'),LINK('UltimateVLB.clw')!,_ABCLinkMode_),DLL(_ABCDllMode_)
Construct                       PROCEDURE
Destruct                        PROCEDURE,VIRTUAL
FormatColumn                    PROCEDURE(SIGNED ListFEQ,SHORT ColumnNo)
GetElementCount                 PROCEDURE,SHORT,VIRTUAL
GetElementLONG                  PROCEDURE(SHORT Elem),LONG
GetElementSTRING                PROCEDURE(SHORT Elem),STRING
GetValue                        PROCEDURE,STRING,VIRTUAL
ScrapeProperties                PROCEDURE(SIGNED ListFeq,QUEUE Q,LONG ColNo)
                              END

UltVLB:ColumnClassForNumber   CLASS(UltVLB:ColumnClass),TYPE,MODULE('UltimateVLB.clw'),LINK('UltimateVLB.clw')!,_ABCLinkMode_),DLL(_ABCDllMode_)
Construct                       PROCEDURE
                              END

UltVLB:ColumnQueue            QUEUE,TYPE
Column                          &UltVLB:ColumnClass
DisposeObject                   BOOL
ElementCount                    BYTE
                              END

!UltVLB:FromQueue              QUEUE,TYPE
!Display                         STRING(100)
!Value                           STRING(100)
!                              END

UltimateVLB                   CLASS,TYPE,MODULE('UltimateVLB.clw'),LINK('UltimateVLB.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
Construct                       PROCEDURE
Destruct                        PROCEDURE,VIRTUAL
ColumnQueue                     &UltVLB:ColumnQueue
ElementCount                    BYTE,PROTECTED
FEQ                             SIGNED
!FromQueue                       &UltVLB:FromQueue,PROTECTED
ListItems                       LONG,PROTECTED
OldCHANGES                      LONG,PROTECTED
OriginalListHeight              SHORT,PROTECTED
ListQueue                       &QUEUE,PROTECTED  !Optional QUEUE
StripeColor                     LONG
StripeColorAddition             REAL
StripeColorDivisor              REAL
AddColumn                       PROCEDURE(LONG ColumnNo)
AddColumn                       PROCEDURE(UltVLB:ColumnClass ColumnObj,LONG ColumnNo,<BOOL DisposeObject>)
AddColumnQueue                  PROCEDURE(UltVLB:ColumnClass ColumnObj,<BOOL DisposeObject>),PROTECTED
ApplyVLB                        PROCEDURE(<LONG StripeColor>)
FetchRow                        PROCEDURE(LONG Row),BYTE,PROC,VIRTUAL
GetColumnValue                  PROCEDURE(LONG Row,SHORT Col),STRING,VIRTUAL
GetElement                      PROCEDURE(LONG Row,SHORT Elem),STRING,VIRTUAL
GetElementCount                 PROCEDURE,LONG,PROC,VIRTUAL
GetStripeColor                  PROCEDURE(LONG Row),LONG,VIRTUAL
HasDataChanged                  PROCEDURE,BOOL,VIRTUAL
Init                            PROCEDURE(SIGNED FEQ,<QUEUE ListQueue>)
InitAddAndApply                 PROCEDURE(SIGNED FEQ,<QUEUE ListQueue>,<LONG StripeColor>)
MeasureList                     PROCEDURE,VIRTUAL
Records                         PROCEDURE(BYTE ReturnAtLeastOnePage=1),LONG,VIRTUAL
!TakeAccepted                    PROCEDURE,BYTE,VIRTUAL
VLBproc                         PROCEDURE(LONG Row, SHORT Column),STRING,PROTECTED,VIRTUAL  !Required first parameter is implicit in a CLASS method
                              END
