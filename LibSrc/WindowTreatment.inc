!ABCIncludeFile

WindowTreatmentControlInterface   INTERFACE
NeedsTreatment                      PROCEDURE(SIGNED FEQ),BOOL
Treat                               PROCEDURE(SIGNED FEQ)
                                  END

WindowTreatment               CLASS,TYPE,MODULE('WindowTreatment.clw'),LINK('WindowTreatment.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
ScanControls                    PROCEDURE(WindowTreatmentControlInterface ControlInterface)
                              END
