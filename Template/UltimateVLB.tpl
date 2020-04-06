#TEMPLATE(UltimateVLB, 'Ultimate VLB Template'),FAMILY('ABC','CW20')
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#EXTENSION(UltimateVLBGlobal,'Ultimate VLB (Global Extension)'),APPLICATION
#SHEET,HSCROLL
  #TAB('General')
    #PROMPT('Use only when local template is also present',CHECK),%VLBOnlyWithLocal,AT(10,,180)
    #PROMPT('Derive stripe color from selector color',CHECK),%VLBDeriveStripeColor,DEFAULT(%TRUE),AT(10,,180)
    #ENABLE(~%VLBDeriveStripeColor)
      #PROMPT('Stripe Color:',COLOR),%VLBStripeColor,REQ
    #ENDENABLE
  #ENDTAB
#ENDSHEET
#!----------
#ATSTART
  #CALL(%VLBDeclareGlobalSymbols)
#ENDAT
#!----------
#AT(%AfterGlobalIncludes)
   INCLUDE('UltimateVLB.inc'),ONCE
#ENDAT
#!----------
#AT(%GatherSymbols),PRIORITY(1000)
  #CALL(%VLBGatherSymbols1)
#ENDAT
#!----------
#AT(%GatherSymbols),PRIORITY(3000)
  #CALL(%VLBGatherSymbols3)
#ENDAT
#!----------
#AT(%DataSection),PRIORITY(1243),WHERE(%VLBEnable),DESCRIPTION(%ApplicationTemplateInstanceDescription)
    #FOR(%VLBList)
%[20]VLBObject UltimateVLB
    #ENDFOR
#ENDAT
#!----------
#AT(%AfterWindowOpening),PRIORITY(6243),WHERE(%VLBEnable),DESCRIPTION(%ApplicationTemplateInstanceDescription & ' - Initialize')
    #FOR(%VLBList)
      #FIX(%Control, %VLBList)
%VLBObject.InitAddAndApply(%Control, %ControlFrom%VLBStripeColorParm)
    #ENDFOR
#ENDAT
#!---------------------------------------------------------------------
#GROUP(%VLBDeclareGlobalSymbols)
  #DECLARE(%VLBList),UNIQUE
  #DECLARE(%VLBEnable, %VLBList)
  #DECLARE(%VLBObject, %VLBList)
  #DECLARE(%VLBStripeColorParm, %VLBList)
#!---------------------------------------------------------------------
#GROUP(%VLBGatherSymbols1)
  #PURGE(%VLBList)
  #FOR(%Control),WHERE(%ControlType = 'LIST')
    #IF(SUB(%ControlFrom,1,1)<>'<39>')
      #ADD(%VLBList, %Control)
      #SET(%VLBEnable, CHOOSE(~%VLBOnlyWithLocal, %True, %False))
      #SET(%VLBObject, SLICE(%Control,2,LEN(%Control)) &':Stripes')
      #IF(%VLBDeriveStripeColor)
        #SET(%VLBStripeColorParm, '')
      #ELSE
        #SET(%VLBStripeColorParm, ', '& %VLBStripeColor)
      #ENDIF
    #ENDIF
  #ENDFOR
#!---------------------------------------------------------------------
#GROUP(%VLBGatherSymbols3)
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#EXTENSION(UltimateVLBLocal,'Ultimate VLB (Local Extension)'),WINDOW,PROCEDURE
#SHEET,HSCROLL
  #TAB('General')
    #PROMPT('Disable template for this procedure',CHECK),%VLBDisableProc,AT(10,,180)
    #ENABLE(~%VLBDisableProc)
      #PROMPT('Use stripe color from global settings',CHECK),%VLBUseGlobalStripeColor,DEFAULT(%TRUE),AT(10,,180)
      #ENABLE(~%VLBUseGlobalStripeColor)
        #PROMPT('Local Stripe Color:',COLOR),%VLBLocalStripeColor,REQ
      #ENDENABLE
    #ENDENABLE
  #ENDTAB
#ENDSHEET
#!----------
#AT(%GatherSymbols),PRIORITY(2000)
#!  #FOR(%VLBList)
#!    #ERROR(%Procedure &':'& %VLBList)
#!  #END
  #IF(%VLBDisableProc)
    #PURGE(%VLBList)
  #ELSE
    #SET(%VLBEnable, %True)
    #IF(~%VLBUseGlobalStripeColor)
      #FOR(%VLBList)
        #SET(%VLBStripeColorParm, ', '& %VLBLocalStripeColor)
      #ENDFOR
    #ENDIF
  #ENDIF
#ENDAT
#!---------------------------------------------------------------------
