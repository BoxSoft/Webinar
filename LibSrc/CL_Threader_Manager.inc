!ABCIncludeFile
               
  INCLUDE('CL_Threader_MessageHandler.inc'),ONCE

CL_Threader_Manager_WorkerQueue   QUEUE,TYPE
Thread                              SIGNED
                                  END

CL_Threader_Manager           CLASS(CL_Threader_MessageHandler),TYPE,MODULE('CL_Threader_Manager.clw'),LINK('CL_Threader_Manager.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
WorkerQ                         &CL_Threader_Manager_WorkerQueue
Construct                       PROCEDURE
Destruct                        PROCEDURE,DERIVED
AddWorker                       PROCEDURE(SIGNED WorkerThread),VIRTUAL
CloseWorker                     PROCEDURE(SIGNED WorkerThread),VIRTUAL
DeleteWorker                    PROCEDURE(SIGNED WorkerThread),VIRTUAL
FetchWorker                     PROCEDURE(SIGNED WorkerThread),BYTE,VIRTUAL
Workers                         PROCEDURE,LONG
                              END
