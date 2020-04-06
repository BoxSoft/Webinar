                              MEMBER

  INCLUDE('CL_Threader_Message.inc'),ONCE

                              MAP
                                INCLUDE('STDebug.inc')
                              END

!==============================================================================
!==============================================================================
CL_Threader_Message.Construct PROCEDURE
  CODE
  SELF.Debug('CL_Threader_Message.Construct/IN')
  SELF.Status = CL_Threader_MessageStatus:Pending
  SELF.Debug('CL_Threader_Message.Construct/OUT')

!==============================================================================
CL_Threader_Message.Destruct  PROCEDURE
  CODE
  SELF.Debug('CL_Threader_Message.Destruct/IN')
  DISPOSE(SELF.Data)
  SELF.Debug('CL_Threader_Message.Destruct/OUT')

!==============================================================================
!============                                                     =============
!============ Central Debug method for all CL_Threader_* classes. =============
!============                                                     =============
!==============================================================================
!To disable trace messages, prevent this call.
CL_Threader_Message.Debug     PROCEDURE(STRING M)
  CODE
  !ST::Debug(M)

!==============================================================================
CL_Threader_Message.CopyTo    PROCEDURE(CL_Threader_Message Target)
  CODE
  SELF.Debug('CL_Threader_Message.CopyTo/IN')
  Target.MessageID          = SELF.MessageID
  Target.SenderThread       = SELF.SenderThread
  Target.ReceiverThread     = SELF.ReceiverThread
  Target.Status             = SELF.Status
  Target.DoneSignalRequired = SELF.DoneSignalRequired
  Target.Code               = SELF.Code
  Target.SetData            ( SELF.GetData())
  SELF.Debug('CL_Threader_Message.CopyTo/OUT')

!==============================================================================
CL_Threader_Message.GetData   PROCEDURE!,STRING
  CODE
  IF SELF.Data &= NULL
    SELF.Debug('CL_Threader_Message.GetData: Data=NULL')
    RETURN ''
  ELSE
    SELF.Debug('CL_Threader_Message.GetData: Data='& SELF.Data)
    RETURN SELF.Data
  END

!==============================================================================
CL_Threader_Message.SetData   PROCEDURE(STRING S)
Length                           LONG,AUTO
  CODE
  SELF.Debug('CL_Threader_Message.SetData/IN')
  Length = LEN(S)
  IF Length > 0 AND Length = SIZE(SELF.Data)
    SELF.Data = S
  ELSE  
    DISPOSE(SELF.Data)
    IF Length = 0
      SELF.Data &= NULL
    ELSE
      SELF.Data &= NEW STRING(Length)
      SELF.Data  = S
    END
  END
  SELF.Debug('CL_Threader_Message.SetData/OUT')

!==============================================================================
