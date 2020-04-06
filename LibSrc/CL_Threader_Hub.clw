                              MEMBER

  INCLUDE('CL_Threader_Hub.inc'),ONCE
  INCLUDE('Errors.clw'),ONCE
  INCLUDE('CWSynchC.inc'),ONCE
  INCLUDE('CWSynchM.inc'),ONCE

                              MAP
CL_Threader_Debug               PROCEDURE(STRING DebugMessage)
                              END

!==============================================================================
IsDead                        BOOL(FALSE)

!==============================================================================
Sync                          CLASS
Sync                            &ICriticalSection
Construct                       PROCEDURE
Destruct                        PROCEDURE
DeleteMessage                   PROCEDURE
FreeQueues                      PROCEDURE
Wait                            PROCEDURE
Release                         PROCEDURE
                              END

!==============================================================================
HandlerQ                      QUEUE
Thread                          SIGNED
ManagerThread                   SIGNED
DeferringUntilDoneMessageID     LONG
Idle                            BOOL    !Is the worker waiting for work?
                              END

!==============================================================================
MessageQ                      QUEUE
ID                              LONG
Message                         &CL_Threader_Message
                              END

!==============================================================================
HubCriticalProcedure          CLASS(CriticalProcedure),TYPE
Construct                       PROCEDURE
                              END

!==============================================================================
!==============================================================================
!The Message class is at the bottom of the heap, so the cetral Debug method is
!there and can be disabled in one place.

CL_Threader_Debug             PROCEDURE(STRING DebugMessage)
MessageUtility                   &CL_Threader_Message
  CODE
  MessageUtility.Debug(DebugMessage)

!==============================================================================
!==============================================================================
HubCriticalProcedure.Construct    PROCEDURE
  CODE
  IF IsDead THEN RETURN.
  CL_Threader_Debug('HubCriticalProcedure.Construct/IN')
  SELF.Init(Sync.Sync)
  CL_Threader_Debug('HubCriticalProcedure.Construct/OUT')

!==============================================================================
!==============================================================================
Sync.Construct                PROCEDURE
  CODE
  SELF.Sync &= NewCriticalSection()
  
!==============================================================================
Sync.Destruct                 PROCEDURE
  CODE
  ;                ;  CL_Threader_Debug('Sync.Destruct/IN')
  SELF.FreeQueues();  CL_Threader_Debug('Sync.Destruct/1')
  IsDead = TRUE    ;  CL_Threader_Debug('Sync.Destruct/2')
  SELF.Sync.Kill() ;  CL_Threader_Debug('Sync.Destruct/OUT')
  
!==============================================================================
Sync.DeleteMessage            PROCEDURE
!Assume CS in effect
  CODE
  IF IsDead THEN RETURN.
  DISPOSE(MessageQ.Message)
  DELETE(MessageQ)
  
!==============================================================================
Sync.FreeQueues               PROCEDURE
  CODE
  IF IsDead THEN RETURN.;  CL_Threader_Debug('Sync.FreeQueues/IN')
  Sync.Wait()           ;  CL_Threader_Debug('Sync.FreeQueues/1')
  FREE(HandlerQ)        ;  CL_Threader_Debug('Sync.FreeQueues/2')
  DO FreeMessageQ       ;  CL_Threader_Debug('Sync.FreeQueues/3')
  Sync.Release()        ;  CL_Threader_Debug('Sync.FreeQueues/OUT')
  
FreeMessageQ                  ROUTINE
  LOOP WHILE RECORDS(MessageQ)
    GET(MessageQ, 1)
    SELF.DeleteMessage()
  END
  
!==============================================================================
Sync.Wait                     PROCEDURE
  CODE
  IF IsDead THEN RETURN.
  SELF.Sync.Wait()
  
!==============================================================================
Sync.Release                  PROCEDURE
  CODE
  IF IsDead THEN RETURN.
  SELF.Sync.Release()
  
!==============================================================================
!==============================================================================
!The Hub utility is ubiquitous, so this Debug method is here.

CL_Threader_Hub.Debug         PROCEDURE(STRING DebugMessage)
  CODE
  CL_Threader_Debug(DebugMessage)

!==============================================================================
CL_Threader_Hub.AddHandler    PROCEDURE(SIGNED HandlerThread,<SIGNED ManagerThread>)!,BYTE
ReturnValue                     BYTE(Level:Notify)
  CODE
  IF NOT IsDead
    SELF.Debug('CL_Threader_Hub.AddHandler/IN')
    Sync.Wait()
    IF SELF.FetchHandler(HandlerThread) <> Level:Benign
      HandlerQ.Thread        = HandlerThread
      HandlerQ.ManagerThread = ManagerThread
      ADD(HandlerQ, HandlerQ.Thread)
      DO SendPendingMessages
    ELSE
      HandlerQ.ManagerThread = ManagerThread
      PUT(HandlerQ)
    END
    ReturnValue = CHOOSE(ERRORCODE()=NoError, Level:Benign, Level:Notify)
    Sync.Release()
    SELF.Debug('CL_Threader_Hub.AddHandler/OUT: ReturnValue='& ReturnValue)
  END
  RETURN ReturnValue

SendPendingMessages           ROUTINE
  DATA
X   LONG,AUTO
  CODE
  SELF.Debug('CL_Threader_Hub.AddHandler/SendPendingMessages/IN')
  LOOP X = 1 TO RECORDS(MessageQ)
    GET(MessageQ, X)
    SELF.Debug('CL_Threader_Hub.AddHandler/SendPendingMessages/MessageQ.Message.ReceiverThread='& MessageQ.Message.ReceiverThread)
    SELF.Debug('CL_Threader_Hub.AddHandler/SendPendingMessages/MessageQ.Message.Status='& MessageQ.Message.Status)
    IF MessageQ.Message.ReceiverThread = HandlerThread |
        AND MessageQ.Message.Status = CL_Threader_MessageStatus:Pending
      SELF.NotifyReceiver(MessageQ.Message)
    END
  END
  SELF.Debug('CL_Threader_Hub.AddHandler/SendPendingMessages/OUT')
  
!==============================================================================
CL_Threader_Hub.FetchHandler  PROCEDURE(SIGNED HandlerThread)!,BYTE
ReturnValue                     BYTE(Level:Notify)
  CODE
  IF NOT IsDead
    SELF.Debug('CL_Threader_Hub.FetchHandler/IN')
    Sync.Wait()
    HandlerQ.Thread = HandlerThread
    GET(HandlerQ, HandlerQ.Thread)
    ReturnValue = CHOOSE(ERRORCODE()=NoError, Level:Benign, Level:Notify)
    Sync.Release()
    SELF.Debug('CL_Threader_Hub.FetchHandler/OUT: ReturnValue='& ReturnValue)
  END
  RETURN ReturnValue

!==============================================================================
CL_Threader_Hub.FetchMessage  PROCEDURE(SIGNED MessageID)!,BYTE
ReturnValue                     BYTE(Level:Notify)
  CODE
  IF NOT IsDead
    SELF.Debug('CL_Threader_Hub.FetchHandler/IN')
    Sync.Wait()
    MessageQ.ID = MessageID
    GET(MessageQ, MessageQ.ID)
    ReturnValue = CHOOSE(ERRORCODE()=NoError, Level:Benign, Level:Notify)
    Sync.Release()
    SELF.Debug('CL_Threader_Hub.FetchHandler/OUT: ReturnValue='& ReturnValue)
  END
  RETURN ReturnValue

!==============================================================================
CL_Threader_Hub.IsHandlerActive   PROCEDURE(SIGNED HandlerThread)!,BYTE
  CODE
  RETURN CHOOSE(SELF.FetchHandler(HandlerThread) = Level:Benign)

!==============================================================================
CL_Threader_Hub.IsMessageDoing    PROCEDURE(LONG MessageID)!,BOOL
IsMessageDoing                      BOOL(FALSE)
  CODE
  IF NOT IsDead
    SELF.Debug('CL_Threader_Hub.IsMessageDoing/IN')
    Sync.Wait()
    IF SELF.FetchMessage(MessageID) = Level:Benign
      IsMessageDoing = CHOOSE(MessageQ.Message.Status = CL_Threader_MessageStatus:Doing)
    END
    Sync.Release()
    SELF.Debug('CL_Threader_Hub.IsMessageDoing/OUT: IsMessageDoing='& IsMessageDoing)
  END
  RETURN IsMessageDoing
  
!==============================================================================
CL_Threader_Hub.ManagersWorkers   PROCEDURE(SIGNED ManagerThread)!,LONG
X                                   LONG,AUTO
Workers                             LONG(0)
  CODE
  IF NOT IsDead
    SELF.Debug('CL_Threader_Hub.ManagersWorkers/IN')
    ManagerThread = THREAD()
    Sync.Wait()
    LOOP X = 1 TO RECORDS(HandlerQ)
      GET(HandlerQ, X)
      IF HandlerQ.ManagerThread = ManagerThread
        Workers += 1
      END
    END
    Sync.Release()
    SELF.Debug('CL_Threader_Hub.ManagersWorkers/OUT')
  END
  RETURN Workers

!==============================================================================
CL_Threader_Hub.Messages      PROCEDURE!,LONG
Messages                        LONG(0)
  CODE
  IF IsDead THEN RETURN Messages.
  Sync.Wait()
  Messages = RECORDS(MessageQ)
  Sync.Release()
  SELF.Debug('CL_Threader_Hub.Messages: '& Messages)
  RETURN Messages

!==============================================================================
CL_Threader_Hub.NoteManagerClosed PROCEDURE  
ManagerThread                       SIGNED,AUTO
X                                   LONG,AUTO
  CODE
  IF IsDead THEN RETURN.
  SELF.Debug('CL_Threader_Hub.NoteManagerClosed/IN')
  ManagerThread = THREAD()
  Sync.Wait()
  LOOP X = 1 TO RECORDS(HandlerQ)
    GET(HandlerQ, X)
    IF HandlerQ.ManagerThread = ManagerThread
      HandlerQ.ManagerThread = 0
      PUT(HandlerQ)
    END
  END
  Sync.Release()
  SELF.Debug('CL_Threader_Hub.NoteManagerClosed/OUT')
  
!==============================================================================
CL_Threader_Hub.NoteMessageHandlerClosed  PROCEDURE
HandlerThread                               SIGNED,AUTO
  CODE
  IF IsDead THEN RETURN.
  SELF.Debug('CL_Threader_Hub.NoteMessageHandlerClosed/IN')
  HandlerThread = THREAD()
  Sync.Wait()
  DO CleanMessageQ
  DO CleanHandlerQ
  Sync.Release()
  SELF.Debug('CL_Threader_Hub.NoteMessageHandlerClosed/OUT')

CleanMessageQ                 ROUTINE
  DATA
X   LONG,AUTO
  CODE
  LOOP X = 1 TO RECORDS(MessageQ)
    GET(MessageQ, X)
    IF MessageQ.Message.ReceiverThread = HandlerThread
      MessageQ.Message.ReceiverThread = 0
      MessageQ.Message.Status         = CL_Threader_MessageStatus:Undeliverable
      !PUT(HandlerQ)
    END
  END

CleanHandlerQ                 ROUTINE
  IF SELF.FetchHandler(HandlerThread) = Level:Benign
    SELF.Debug('CL_Threader_Hub.NoteWorkerClosed/1')
    IF HandlerQ.ManagerThread <> 0
      !Signal Manager?
    END
    SELF.Debug('CL_Threader_Hub.NoteWorkerClosed/2')
    DELETE(HandlerQ)
    SELF.Debug('CL_Threader_Hub.NoteWorkerClosed/3')
  END  

!==============================================================================
CL_Threader_Hub.NotifyReceiver    PROCEDURE(CL_Threader_Message Message)
  CODE
  Message.Status = CL_Threader_MessageStatus:Sent
  IF Message.DeferOthersUntilDone  |
      AND SELF.FetchHandler(Message.ReceiverThread) = Level:Benign
    HandlerQ.DeferringUntilDoneMessageID = Message.MessageID
    PUT(HandlerQ)
  END
  NOTIFY(CL_Threader_Notify:NewMessage, Message.ReceiverThread, Message.MessageID)
  
!==============================================================================
CL_Threader_Hub.ReceiveMessage    PROCEDURE(LONG MessageID,CL_Threader_Message Message)!,BYTE
ReturnValue                         BYTE(Level:Notify)
  CODE
  IF IsDead THEN RETURN ReturnValue.
  SELF.Debug('CL_Threader_Hub.ReceiveMessage/IN: MessageID='& MessageID)
  Sync.Wait()
  MessageQ.ID = MessageID
  GET(MessageQ, MessageQ.ID)
  IF ERRORCODE() = NoError
    SELF.Debug('CL_Threader_Hub.ReceiveMessage/1')
    IF MessageQ.Message.DoneSignalRequired
      SELF.Debug('CL_Threader_Hub.ReceiveMessage/2')
      MessageQ.Message.Status = CL_Threader_MessageStatus:Doing
      MessageQ.Message.CopyTo(Message)
    ELSE
      SELF.Debug('CL_Threader_Hub.ReceiveMessage/3')
      MessageQ.Message.CopyTo(Message)
      DISPOSE(MessageQ.Message)
      SELF.Debug('CL_Threader_Hub.ReceiveMessage/4')
      DELETE(MessageQ)    
    END
    SELF.Debug('CL_Threader_Hub.ReceiveMessage/4')
    ReturnValue = CHOOSE(ERRORCODE()=NoError, LEVEL:Benign, Level:Notify)
  END
  Sync.Release()
  SELF.Debug('CL_Threader_Hub.ReceiveMessage/OUT: ReturnValue='& ReturnValue)
  RETURN ReturnValue
  
!==============================================================================
CL_Threader_Hub.ResetTest     PROCEDURE
  CODE
  SELF.Debug('CL_Threader_Hub.ResetTest/IN')
  Sync.FreeQueues()
  SELF.Debug('CL_Threader_Hub.ResetTest/OUT')
  
!==============================================================================
CL_Threader_Hub.SendMessage   PROCEDURE(SIGNED ReceiverThread,CL_Threader_Message Message,<BOOL DoneSignalRequired>)!,LONG
CP                              HubCriticalProcedure
LastID                          LONG,AUTO
  CODE
  IF IsDead
    RETURN 0
  ELSE
    ;                ;  SELF.Debug('CL_Threader_Hub.SendMessage/IN: Message.Code='& Message.Code)
    DO GetLastID     ;  SELF.Debug('CL_Threader_Hub.SendMessage/1: LastID='& LastID)
    DO AddMessage    ;  SELF.Debug('CL_Threader_Hub.SendMessage/2: Messages='& SELF.Messages())
    DO NotifyReceiver;  SELF.Debug('CL_Threader_Hub.SendMessage/OUT: ID='& MessageQ.ID)
    RETURN MessageQ.ID
  END

GetLastID                     ROUTINE
  GET(MessageQ, RECORDS(MessageQ))
  LastID = CHOOSE(ERRORCODE()=NoError, MessageQ.ID, 0)

AddMessage                    ROUTINE
  Message.MessageID      = LastID + 1
  Message.SenderThread   = THREAD()
  Message.ReceiverThread = ReceiverThread
  IF NOT OMITTED(DoneSignalRequired)
    Message.DoneSignalRequired = DoneSignalRequired
  END
  CLEAR(MessageQ)
  MessageQ.ID       = Message.MessageID
  MessageQ.Message &= NEW CL_Threader_Message
  Message.CopyTo(MessageQ.Message)
  ADD(MessageQ, MessageQ.ID)

NotifyReceiver                ROUTINE
  SELF.Debug('CL_Threader_Hub.SendMessage/NotifyReceiver/IN')
  IF SELF.IsHandlerActive(MessageQ.Message.ReceiverThread)
    SELF.Debug('CL_Threader_Hub.SendMessage/NotifyReceiver/Notifying')
    SELF.NotifyReceiver(MessageQ.Message)
  END
  SELF.Debug('CL_Threader_Hub.SendMessage/NotifyReceiver/OUT')
  
!==============================================================================
CL_Threader_Hub.SetWorkerIdle PROCEDURE(BOOL Idle)
CP                              HubCriticalProcedure
  CODE
  IF IsDead THEN RETURN.
  SELF.Debug('CL_Threader_Hub.SetWorkerIdle/IN')
  IF SELF.FetchHandler(THREAD()) = Level:Benign
    SELF.Debug('CL_Threader_Hub.SetWorkerIdle/1')
    HandlerQ.Idle = Idle
    PUT(HandlerQ)
  END
  SELF.Debug('CL_Threader_Hub.SetWorkerIdle/OUT')

!==============================================================================
CL_Threader_Hub.SignalMessageDone PROCEDURE(CL_Threader_Message Message)
  CODE
  IF IsDead THEN RETURN.
  SELF.Debug('CL_Threader_Hub.NoteMessageProcessed/IN: ID='& Message.MessageID)
  Sync.Wait()
  IF SELF.FetchMessage(Message.MessageID) = Level:Benign
    SELF.Debug('CL_Threader_Hub.NoteMessageProcessed/1')
    IF MessageQ.Message.DoneSignalRequired
      SELF.Debug('CL_Threader_Hub.NoteMessageProcessed/2')
      Message.DoneSignalRequired = FALSE
      Message.Status             = CL_Threader_MessageStatus:Done
      Message.CopyTo(MessageQ.Message)
      SELF.Debug('CL_Threader_Hub.NoteMessageProcessed/3: SenderThread='& MessageQ.Message.SenderThread)
      NOTIFY(CL_Threader_Notify:MessageDone, MessageQ.Message.SenderThread, MessageQ.ID)
    END
    SELF.Debug('CL_Threader_Hub.NoteMessageProcessed/4')
  END
  Sync.Release()
  SELF.Debug('CL_Threader_Hub.NoteMessageProcessed/OUT')
  
!==============================================================================
