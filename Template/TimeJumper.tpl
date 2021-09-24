#!*****************************************************************************
#TEMPLATE(TimeJumper,'TimeJumper Template'),FAMILY('ABC','CW20')
#!*****************************************************************************
#EXTENSION(TimeJumper,'TimeJumper Global Support'),APPLICATION,DESCRIPTION('TimeJumper Global Template')
#PROMPT('Local Object Name:',@S100),%TimeJumperObject,DEFAULT('TimeJumper')
#!*****
#AT(%AfterGlobalIncludes),DESCRIPTION('TimeJumperClass Include')
   INCLUDE('TimeJumper.inc'),ONCE
#ENDAT
#!*****
#AT(%DataSection),WHERE(%HasTimeControl()),PRIORITY(8423)
%[20]TimeJumperObject TimeJumperClass
#ENDAT
#!*****
#AT(%AfterWindowOpening),WHERE(%HasTimeControl()),PRIORITY(8423)
%TimeJumperObject.InitWindow()
#ENDAT
#!*****
#AT(%AcceptLoopBeforeEventHandling),WHERE(%HasTimeControl()),PRIORITY(1423)
%TimeJumperObject.TakeEvent()
#ENDAT
#!*****************************************************************************
#GROUP(%HasTimeControl)
  #FOR(%Control)
    #CASE(%ControlType)
    #OF('ENTRY')
    #OROF('SPIN')
      #IF(UPPER(SUB(EXTRACT(%ControlStatement, %ControlType,1),2,1))='T')
        #RETURN(%True)
      #ENDIF
    #ENDCASE
  #ENDFOR
  #RETURN(%False)
#!*****************************************************************************
