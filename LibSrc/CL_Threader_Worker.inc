!ABCIncludeFile
                              
  INCLUDE('CL_Threader_MessageHandler.inc'),ONCE

CL_Threader_Worker            CLASS(CL_Threader_MessageHandler),TYPE,MODULE('CL_Threader_Worker.clw'),LINK('CL_Threader_Worker.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
ManagerThread                   SIGNED
Destruct                        PROCEDURE,DERIVED
NoteRunning                     PROCEDURE,DERIVED
Run                             PROCEDURE,VIRTUAL
SetBusy                         PROCEDURE,VIRTUAL
SetIdle                         PROCEDURE(<BOOL Idle>),VIRTUAL
                              END
