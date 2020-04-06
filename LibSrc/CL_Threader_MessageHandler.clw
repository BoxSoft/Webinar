                              MEMBER

  INCLUDE('CL_Threader_MessageHandler.inc'),ONCE
  INCLUDE('CL_Threader_Hub.inc'),ONCE

                              MAP
                              END

!==============================================================================
!==============================================================================
CL_Threader_MessageHandler.Destruct   PROCEDURE
  CODE
  SELF.Hub.Debug('CL_Threader_MessageHandler.Destruct/IN')
  SELF.Hub.NoteMessageHandlerClosed()
  SELF.Hub.Debug('CL_Threader_MessageHandler.Destruct/OUT')
  
!==============================================================================
CL_Threader_MessageHandler.Close  PROCEDURE
  CODE
  ;                                        ;  SELF.Hub.Debug('CL_Threader_MessageHandler.Close/IN')
  CASE SELF.Thread
  OF 0 OROF THREAD()                       ;  SELF.Hub.Debug('CL_Threader_MessageHandler.Close/1')
    POST(EVENT:CloseWindow)
  ELSE                                     ;  SELF.Hub.Debug('CL_Threader_MessageHandler.Close/2')
    POST(EVENT:CloseWindow,, SELF.Thread)
  END
  ;                                        ;  SELF.Hub.Debug('CL_Threader_MessageHandler.Close/OUT')

!==============================================================================
CL_Threader_MessageHandler.HandleMessage  PROCEDURE(CL_Threader_Message Message)
  CODE
  !Empty Virtual
  
!==============================================================================
CL_Threader_MessageHandler.HandleMessageDone PROCEDURE(CL_Threader_Message Message)
  CODE
  !Empty Virtual
  
!==============================================================================
CL_Threader_MessageHandler.NoteRunning    PROCEDURE
  CODE
  ;                               ;  SELF.Hub.Debug('CL_Threader_MessageHandler.NoteRunning/IN')
  SELF.Thread = THREAD()
  SELF.Hub.AddHandler(SELF.Thread);  SELF.Hub.Debug('CL_Threader_MessageHandler.NoteRunning/OUT')

!==============================================================================
CL_Threader_MessageHandler.TakeEvent  PROCEDURE!,BYTE
                              MAP
TakeNotification                PROCEDURE
                              END
  CODE
  !SELF.Hub.Debug('CL_Threader_MessageHandler.TakeEvent: '& SELF.Hub.DebugEventName())
  CASE EVENT()
    ;OF EVENT:OpenWindow;  SELF.NoteRunning()
    ;OF EVENT:Notify    ;  TakeNotification()
  END
  RETURN Level:Benign

TakeNotification              PROCEDURE
NotifyCode                      UNSIGNED
NotifyThread                    SIGNED
MessageID                       LONG
Message                         CL_Threader_Message
  CODE
  NOTIFICATION(NotifyCode, NotifyThread, MessageID)              ;  SELF.Hub.Debug('CL_Threader_MessageHandler.TakeEvent/Notify/Code='& NotifyCode &'; Thread='& NotifyThread &'; ID='& MessageID)
  CASE NotifyCode
  OF CL_Threader_Notify:NewMessage                               ;  SELF.Hub.Debug('CL_Threader_MessageHandler.TakeEvent/Notify/NewMessage')
    IF SELF.Hub.ReceiveMessage(MessageID, Message) = Level:Benign;  SELF.Hub.Debug('CL_Threader_MessageHandler.TakeEvent/Notify/NewMessage/Received')
      SELF.HandleMessage(Message)
    END
  OF CL_Threader_Notify:MessageDone                              ;  SELF.Hub.Debug('CL_Threader_MessageHandler.TakeEvent/Notify/MessageDone')
    IF SELF.Hub.ReceiveMessage(MessageID, Message) = Level:Benign;  SELF.Hub.Debug('CL_Threader_MessageHandler.TakeEvent/Notify/MessageDone/Received')
      SELF.HandleMessageDone(Message)
    END
  END

!==============================================================================
CL_Threader_MessageHandler.SendMessage    PROCEDURE(SIGNED ReceiverThread,CL_Threader_Message Message,<BOOL DoneSignalRequired>)!,LONG
  CODE
  IF OMITTED(DoneSignalRequired)
    RETURN SELF.Hub.SendMessage(ReceiverThread, Message)
  ELSE
    RETURN SELF.Hub.SendMessage(ReceiverThread, Message, DoneSignalRequired)
  END

!==============================================================================
CL_Threader_MessageHandler.SignalMessageDone  PROCEDURE(CL_Threader_Message Message)
  CODE
  SELF.Hub.Debug('CL_Threader_MessageHandler.SignalMessageDone/IN: ID='& Message.MessageID)
  SELF.Hub.SignalMessageDone(Message)
  SELF.Hub.Debug('CL_Threader_MessageHandler.SignalMessageDone/OUT')

!==============================================================================
