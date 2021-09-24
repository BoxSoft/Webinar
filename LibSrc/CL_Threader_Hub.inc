!ABCIncludeFile

  INCLUDE('CL_Threader_Message.inc'),ONCE

                              ITEMIZE(84932403)
CL_Threader_Notify:NewMessage   EQUATE
CL_Threader_Notify:MessageDone  EQUATE
                              END


CL_Threader_Hub               CLASS,TYPE,MODULE('CL_Threader_Hub.clw'),LINK('CL_Threader_Hub.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
!!! THIS IS A UTILITY CLASS. DO NOT ADD ANY CLASS PROPERTIES !!!
AddHandler                      PROCEDURE(SIGNED HandlerThread,<SIGNED ManagerThread>),BYTE,PROC
Debug                           PROCEDURE(STRING DebugMessage)
FetchHandler                    PROCEDURE(SIGNED HandlerThread),BYTE
FetchMessage                    PROCEDURE(SIGNED MessageID),BYTE
IsHandlerActive                 PROCEDURE(SIGNED HandlerThread),BOOL
IsMessageDoing                  PROCEDURE(LONG MessageID),BOOL
ManagersWorkers                 PROCEDURE(SIGNED ManagerThread),LONG
Messages                        PROCEDURE,LONG
NoteManagerClosed               PROCEDURE
NoteMessageHandlerClosed        PROCEDURE
NotifyReceiver                  PROCEDURE(CL_Threader_Message Message)
ReceiveMessage                  PROCEDURE(LONG MessageID,CL_Threader_Message Message),BYTE
ResetTest                       PROCEDURE
SendMessage                     PROCEDURE(SIGNED ReceiverThread,CL_Threader_Message Message,<BOOL DoneSignalRequired>),LONG,PROC
SetWorkerIdle                   PROCEDURE(BOOL Idle)
SignalMessageDone               PROCEDURE(CL_Threader_Message Message)
                              END
