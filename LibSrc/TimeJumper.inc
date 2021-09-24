!ABCIncludeFile

  INCLUDE('WindowTreatment.inc'),ONCE

  OMIT('!END-OMIT', TIME:Second=100)
TIME:Second                   EQUATE(100              )
TIME:Minute                   EQUATE( 60 * TIME:Second)
TIME:Hour                     EQUATE( 60 * TIME:Minute)
TIME:Day                      EQUATE( 24 * TIME:Hour  )
  !END-OMIT('END-OMIT', TIME:Second=100)

TimeJumperClass               CLASS,TYPE,IMPLEMENTS(WindowTreatmentControlInterface),MODULE('TimeJumper.clw'),LINK('TimeJumper.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
InitWindow                      PROCEDURE
TakeEvent                       PROCEDURE,BYTE,PROC
                              END
