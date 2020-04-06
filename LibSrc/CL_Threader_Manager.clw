                              MEMBER

  INCLUDE('CL_Threader_Manager.inc'),ONCE
  INCLUDE('CL_Threader_Hub.inc'),ONCE
  INCLUDE('Errors.clw'),ONCE

                              MAP
                              END

!==============================================================================
!==============================================================================
CL_Threader_Manager.Construct PROCEDURE
  CODE
  SELF.WorkerQ &= NEW CL_Threader_Manager_WorkerQueue
  
!==============================================================================
CL_Threader_Manager.Destruct  PROCEDURE
  CODE
  SELF.Hub.Debug('CL_Threader_Manager.Destruct/IN')
  SELF.Hub.NoteManagerClosed()
  LOOP WHILE RECORDS(SELF.WorkerQ)
    GET(SELF.WorkerQ, 1)
    SELF.CloseWorker(SELF.WorkerQ.Thread)
  END
  DISPOSE(SELF.WorkerQ)
  SELF.Hub.Debug('CL_Threader_Manager.Destruct/OUT')
  
!==============================================================================
CL_Threader_Manager.AddWorker PROCEDURE(SIGNED WorkerThread)
  CODE
  SELF.WorkerQ.Thread = WorkerThread
  ADD(SELF.WorkerQ, SELF.WorkerQ.Thread)
  
!==============================================================================
CL_Threader_Manager.CloseWorker   PROCEDURE(SIGNED WorkerThread)
  CODE
  SELF.DeleteWorker(WorkerThread)

!==============================================================================
CL_Threader_Manager.DeleteWorker  PROCEDURE(SIGNED WorkerThread)
  CODE
  IF SELF.FetchWorker(WorkerThread) = Level:Benign
    DELETE(SELF.WorkerQ)
  END

!==============================================================================
CL_Threader_Manager.FetchWorker   PROCEDURE(SIGNED WorkerThread)!,BYTE
  CODE
  SELF.WorkerQ.Thread = WorkerThread
  GET(SELF.WorkerQ, SELF.WorkerQ.Thread)
  RETURN CHOOSE(ERRORCODE()=NoError, Level:Benign, Level:Notify)
  
!==============================================================================
CL_Threader_Manager.Workers   PROCEDURE!,LONG
  CODE
  RETURN RECORDS(SELF.WorkerQ)
  
!==============================================================================
  