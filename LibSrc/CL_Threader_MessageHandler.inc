!ABCIncludeFile
                              
  INCLUDE('CL_Threader_Message.inc'),ONCE

CL_Threader_MessageHandler    CLASS,TYPE,MODULE('CL_Threader_MessageHandler.clw'),LINK('CL_Threader_MessageHandler.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
Hub                             &CL_Threader_Hub  !Utility Class
Thread                          SIGNED            !Currently always equals THREAD()
Destruct                        PROCEDURE,VIRTUAL
Close                           PROCEDURE,VIRTUAL
HandleMessage                   PROCEDURE(CL_Threader_Message Message),VIRTUAL
HandleMessageDone               PROCEDURE(CL_Threader_Message Message),VIRTUAL
NoteRunning                     PROCEDURE,VIRTUAL
SendMessage                     PROCEDURE(SIGNED ReceiverThread,CL_Threader_Message Message,<BOOL DoneSignalRequired>),LONG,PROC
SignalMessageDone               PROCEDURE(CL_Threader_Message Message),VIRTUAL
TakeEvent                       PROCEDURE,BYTE,PROC,VIRTUAL
                              END
