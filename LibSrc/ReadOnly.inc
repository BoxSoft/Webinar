!ABCIncludeFile

  INCLUDE('WindowTreatment.inc'),ONCE

ReadOnlyClass                 CLASS,TYPE,IMPLEMENTS(WindowTreatmentControlInterface),MODULE('ReadOnly.clw'),LINK('ReadOnly.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
InitWindow                      PROCEDURE
                              END
