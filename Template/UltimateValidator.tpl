#TEMPLATE(UltimateValidator, 'Ultimate Validator Template'),FAMILY('ABC','CW20')
#!---------------------------------------------------------------------
#!---------------------------------------------------------------------
#EXTENSION(UltimateWindowValidator,'Ultimate Window Validator'),WINDOW,PROCEDURE
#SHEET,HSCROLL
  #TAB('General')
    #PROMPT('WindowValidator Object:',@S50),%WindowValidator,DEFAULT('WindowValidator')
    #BOXED('Controls to Validate')
      #BUTTON('Control to Validate'),MULTI(%ValidateControls,%ValidateControl & CHOOSE(~%InvalidMessage, '', ' - '& %InvalidMessage)),INLINE
        #PROMPT('Control:',CONTROL),%ValidateControl,REQ
        #PROMPT('Validation:',DROP('Required|Email|Custom')),%ValidationType,REQ
        #DISPLAY
        #DISPLAY('Invalid Message:'),AT(,,,8)
        #PROMPT('',@S250),%InvalidMessage,AT(10,,180)
        #ENABLE(%ValidationType='Custom')
          #DISPLAY
          #DISPLAY('Custom IsValid Expression:'),AT(,,,8)
          #PROMPT('',EXPR),%ValidationExpression,REQ,AT(10,,180)
        #ENDENABLE
      #ENDBUTTON
    #ENDBOXED
  #ENDTAB
#ENDSHEET
#!----------
#AT(%AfterGlobalIncludes),PRIORITY(6543),WHERE(~INLIST('UltimateValidatorInclude', %CustomFlags))
  #ADD(%CustomFlags,'UltimateValidatorInclude')
   INCLUDE('UltimateValidator.inc'),ONCE
#ENDAT
#!----------
#AT(%LocalDataAfterClasses),WHERE(UPPER(%AppTemplateFamily)='ABC'),PRIORITY(6543)
#INSERT(%ValidatorObjectDeclarations)
#ENDAT
#!---
#AT(%DataSectionAfterWindow),WHERE(UPPER(%AppTemplateFamily)<>'ABC'),PRIORITY(6543)
#INSERT(%ValidatorObjectDeclarations)
#ENDAT
#!----------
#AT(%WindowManagerMethodCodeSection,'Init','(),BYTE'),WHERE(UPPER(%AppTemplateFamily)='ABC'),PRIORITY(6543)
#INSERT(%ValidatorObjectInitialization)
#ENDAT
#!---
#AT(%BeforeWindowOpening),WHERE(UPPER(%AppTemplateFamily)<>'ABC'),PRIORITY(6543)
#INSERT(%ValidatorObjectInitialization)
#ENDAT
#!----------
#AT(%AcceptLoopBeforeEventHandling),WHERE(UPPER(%AppTemplateFamily)<>'ABC'),PRIORITY(6543)
CASE Legacy%WindowValidator.TakeEvent()
  OF Level:Notify;  CYCLE
  OF Level:Fatal ;  BREAK
END
#ENDAT
#!----------
#AT(%LocalProcedures),PRIORITY(6543)

%WindowValidator.DisplayInvalidMessage PROCEDURE(STRING InvalidMessage)
  CODE
  MESSAGE(InvalidMessage)

     #FOR(%ValidateControls),WHERE(%ValidationType = 'Custom')
%(%ValueValidator()).UltimateValueValidator.GetFEQ PROCEDURE!,SIGNED
  CODE
  RETURN %ValidateControl
  
%(%ValueValidator()).UltimateValueValidator.Validate   PROCEDURE(*STRING MessageOUT)!,BYTE
  CODE
  IF %ValidationExpression
    MessageOUT = ''
    RETURN Record:OK
  ELSE
    MessageOUT = %(%StripPling(%InvalidMessage))
    RETURN Record:OutOfRange
  END

     #ENDFOR
#ENDAT
#!---------------------------------------------------------------------
#GROUP(%ValueValidator)
  #RETURN(SLICE(%ValidateControl,2,LEN(%ValidateControl)) &':Validator')
#!
#!---------------------------------------------------------------------
#GROUP(%ValidatorObjectDeclarations)
     #IF(UPPER(%AppTemplateFamily)<>'ABC')
%[20]('Legacy' & %WindowValidator) UltimateLegacyWindowValidator
     #END
%[20]WindowValidator CLASS(UltimateWindowValidator)
%[22]('DisplayInvalidMessage') PROCEDURE(STRING InvalidMessage),DERIVED
%[20]NULL END
     #FOR(%ValidateControls)
       #IF(%ValidationType <> 'Custom')
%[20](%ValueValidator()) Ultimate%(%ValidationType)Validator
       #ELSE
%[20](%ValueValidator()) CLASS,IMPLEMENTS(UltimateValueValidator)
%[20]NULL END
       #ENDIF
     #ENDFOR
#!---------------------------------------------------------------------
#GROUP(%ValidatorObjectInitialization),AUTO
  #DECLARE(%WindowManagerName)
  #IF(UPPER(%AppTemplateFamily)='ABC')
    #SET(%WindowManagerName,'SELF')
  #ELSE
    #SET(%WindowManagerName,'Legacy'&%WindowValidator)
  #ENDIF
%WindowManagerName.AddItem(%WindowValidator.WindowComponent)
     #FOR(%ValidateControls)
       #IF(%ValidationType <> 'Custom')
%WindowValidator.AddValidator(%(%ValueValidator()).UltimateValueValidator);  %(%ValueValidator()).Init(%ValidateControl, %(%StripPling(%InvalidMessage)))
       #ELSE
%WindowValidator.AddValidator(%(%ValueValidator()).UltimateValueValidator)
       #ENDIF
     #ENDFOR
#!---------------------------------------------------------------------
#GROUP(%StripPling,%Incoming),AUTO
  #DECLARE(%RetVal)
  #CALL(%StripPling(ABC), %Incoming),%RetVal
  #RETURN(%RetVal)
#!---------------------------------------------------------------------
