                              MEMBER

  INCLUDE('CL_Threader_Worker.inc'),ONCE
  INCLUDE('CL_Threader_Hub.inc'),ONCE
  INCLUDE('Errors.clw'),ONCE

                              MAP
                                INCLUDE('STDebug.inc')
                              END

!==============================================================================
!==============================================================================
CL_Threader_Worker.Destruct   PROCEDURE
  CODE
  SELF.Hub.Debug('CL_Threader_Worker.Destruct')
  
!==============================================================================
CL_Threader_Worker.NoteRunning    PROCEDURE
  CODE
  PARENT.NoteRunning()
  IF SELF.ManagerThread
    SELF.Hub.AddHandler(SELF.Thread, SELF.ManagerThread)
  END

!==============================================================================
CL_Threader_Worker.Run        PROCEDURE
Window                          WINDOW,AT(,,0,0),TOOLBOX
                                END
  CODE
  SELF.Hub.Debug('CL_Threader_Worker.Run/IN')
  OPEN(Window)
  ACCEPT
    SELF.Hub.Debug('CL_Threader_Worker.Run/Event: '& ST::DebugEventName())
    CASE SELF.TakeEvent()
      ;OF Level:Notify;  CYCLE
      ;OF Level:Fatal ;  BREAK
    END
  END
  CLOSE(Window)
  SELF.Hub.Debug('CL_Threader_Worker.Run/OUT')
  
!==============================================================================
CL_Threader_Worker.SetBusy    PROCEDURE
  CODE
  SELF.Hub.SetWorkerIdle(FALSE)

!==============================================================================
CL_Threader_Worker.SetIdle    PROCEDURE(<BOOL Idle>)
  CODE
  SELF.Hub.SetWorkerIdle(CHOOSE(~OMITTED(Idle), Idle, TRUE))

!==============================================================================
