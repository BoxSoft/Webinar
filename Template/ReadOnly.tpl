#!*****************************************************************************
#TEMPLATE(ReadOnlyFixer,'ReadOnly Fixer Template'),FAMILY('ABC','CW20')
#!*****************************************************************************
#!*****************************************************************************
#EXTENSION(ReadOnlyGlobal,'ReadOnly Fixer Global Support'),APPLICATION,DESCRIPTION('ReadOnly Fixer Global Support')
#PROMPT('Local Object Name:',@S100),%ReadOnlyObject,DEFAULT('ReadOnlyFixer')
#!*****
#AT(%AfterGlobalIncludes),DESCRIPTION('ReadOnlyClass Include')
   INCLUDE('ReadOnly.inc'),ONCE
#ENDAT
#!*****
#ATSTART
  #DECLARE(%rofControl),UNIQUE
#ENDAT
#!**********
#AT(%GatherSymbols),PRIORITY(1000)
  #CALL(%rofGatherSymbols1)
#ENDAT
#!**********
#AT(%GatherSymbols),PRIORITY(3000)
  #CALL(%rofGatherSymbols3)
#ENDAT
#!*****
#AT(%DataSection),WHERE(%WindowNeedsTreatment()),PRIORITY(8427)
%[20]ReadOnlyObject ReadOnlyClass
#ENDAT
#!*****
#AT(%AfterWindowOpening),WHERE(%WindowNeedsTreatment()),PRIORITY(8427)
%ReadOnlyObject.InitWindow()
#ENDAT
#!*****************************************************************************
#GROUP(%WindowNeedsTreatment)
  #RETURN(CHOOSE(ITEMS(%rofControl) <> 0, %True, %False))
#!*****************************************************************************
#GROUP(%ControlNeedsTreatment)
  #IF(EXTRACT(%ControlStatement, 'READONLY'))
    #IF(NOT (EXTRACT(%ControlStatement, 'SKIP') AND EXTRACT(%ControlStatement, 'TRN')))
      #RETURN(%True)
    #ENDIF
  #ENDIF
  #RETURN(%False)
#!*****************************************************************************
#!*****************************************************************************
#EXTENSION(ReadOnlyLocal,'ReadOnly Fixer Local Override'),DESCRIPTION('ReadOnly Fixer Local Override')
  #BOXED('Do not fix the ReadOnly state of these controls')
    #DISPLAY,AT(,,,2)
    #BUTTON('Do not fix the ReadOnly state of this control'),MULTI(%DoNotFixControls,' '&%DoNotFixControl),INLINE
      #PROMPT('Do not fix:',FROM(%Control, %ControlNeedsTreatment())),%DoNotFixControl,REQ
    #ENDBUTTON
  #ENDBOXED
#!**********
#AT(%GatherSymbols),PRIORITY(2000)
  #CALL(%rofGatherSymbols2)
#ENDAT
#!*****************************************************************************
#!*****************************************************************************
#GROUP(%rofGatherSymbols1)
#!Global survey
  #FREE(%rofControl)
  #FOR(%Control),WHERE(%ControlNeedsTreatment())
    #ADD(%rofControl, %Control)
  #ENDFOR
#!*****************************************************************************
#GROUP(%rofGatherSymbols2)
#!Local intervention
  #FOR(%DoNotFixControls),WHERE(INLIST(%DoNotFixControl, %rofControl))
    #!ERROR(%DoNotFixControls & ' - ' & %DoNotFixControl & ' - ' & INLIST(%DoNotFixControl, %rofControl))
    #FIX(%rofControl, %DoNotFixControl)
    #DELETE(%rofControl)
    #!ERROR('After: '& INLIST(%DoNotFixControl, %rofControl))
  #ENDFOR
#!*****************************************************************************
#GROUP(%rofGatherSymbols3)
#!Global response
#!*****************************************************************************
