#!*****************************************************************************
#!*****************************************************************************
#TEMPLATE(ListPeekaboo,'ListPeekaboo'),FAMILY('ABC')
#INCLUDE('StAbABC.tpw')
#INCLUDE('STGroups.tpw')
#!*****************************************************************************
#!*****************************************************************************
#EXTENSION(ListPeekaboo,'List Peekaboo'),DESCRIPTION('List Peekaboo for '& %ListControl),PROCEDURE,MULTI
#PREPARE
  #CALL(%SetClassDefaults)
#ENDPREPARE
#!**********
#BOXED,HIDE,AT(,,0,0)
  #PROMPT('ProductName',@S30),%ProductName,DEFAULT('Super Stuff - Resize')
  #INSERT(%OOPHiddenPrompts(ABC))
  #PROMPT('',@S30),%stObjectID,DEFAULT('MyID')
  #PROMPT('',@S30),%stObjectDefaultName,DEFAULT('ListPeekaboo')
  #PROMPT('',@S30),%stObjectDefaultClass,DEFAULT('ListPeekabooClass')
#ENDBOXED
#!**********
#SHEET,ADJUST
  #TAB('General')
    #DISPLAY('List Control:'),AT(,,,8)
    #PROMPT('',FROM(%Control,%ControlType='LIST')),%ListControl,REQ,AT(10,,180)
    #DISPLAY
    #BOXED('Slush Column')
      #DISPLAY('The slush column gets any extra bit of width available as the list box is resized.'),AT(10,,180,18)
      #BOXED,SECTION
        #DISPLAY('Slush Column:'),AT(10,0,90,10)
        #PROMPT('Clear',CHECK),%ClearSlushColumn,AT(140,0,90)
        #ENABLE(~%ClearSlushColumn),CLEAR
          #BOXED,WHERE(~%ClearSlushColumn)
            #PROMPT('',FROM(%ControlField)),%SlushColumn,AT(10,12,180)
            #PREPARE
              #FIX(%Control,%ListControl)
            #ENDPREPARE
          #ENDBOXED
        #ENDENABLE
      #ENDBOXED
    #ENDBOXED
  #ENDTAB
  #TAB('Columns')
    #BUTTON('Column Hide Priority'),FROM(%ControlField,%ControlFieldDisplay()),INLINE,AT(,,,200)
      #PREPARE
        #FIX(%Control,%ListControl)
      #ENDPREPARE
      #DISPLAY(%ControlField)
      #PROMPT('Column Hide Priority:',@N2b),%ColumnHidePriority
      #DISPLAY
      #DISPLAY('- Columns with Priority=0 are always visible.')
      #DISPLAY('- Lower priority is shown sooner.')
      #DISPLAY('- Matching priorities are shown/hidden synchronously.')
    #ENDBUTTON
    #PROMPT('Generate commented code for columns with Priority=0',CHECK),%ColumnHidePriority0Too,AT(10,,180)
  #ENDTAB
  #TAB('Classes')
    #WITH(%ClassItem,%stObjectID)
      #INSERT(%ClassPrompts(ABC))
    #ENDWITH
  #ENDTAB
#ENDSHEET
#!**********
#ATSTART
  #CALL(%SetClassDefaults)
  #!-----
  #EQUATE(%MyObject, %ThisObjectName)
  #EQUATE(%InitMethodID, CALL(%AddNewMethod, 'Init', '()'))
  #!-----
  #CALL(%MakeDeclr(ABC),24,%OOPConstruct,'ColumnNumber','LIKE('& %MyObject &':ColumnNumbers)')
  #CALL(%MakeDeclr(ABC),60,%OOPConstruct,%OOPConstruct,'! Group with column numbers by name')
  #ADD(%ClassLines,%OOPConstruct)
#ENDAT
#!**********
#AT(%GatherObjects),PRIORITY(5000)
  #CALL(%AddObjectList)
#ENDAT
#!**********
#AT(%LocalDataClasses),PRIORITY(5000)
#CALL(%GenerateControlNumbers)
#CALL(%GenerateClass)
#ENDAT
#!**********
#AT(%WindowManagerMethodCodeSection,'Init','(),BYTE'),PRIORITY(8050)
%MyObject.Init()
#ENDAT
#!**********
#AT(%WindowManagerMethodCodeSection,'TakeEvent','(),BYTE'),PRIORITY(6300),DESCRIPTION(%ActiveTemplateInstanceDescription &' - Take Event')
  %MyObject.TakeEvent()
#ENDAT
#!**********
#AT(%ResizerMethodCodeSection,,'Resize','(),BYTE'),PRIORITY(6300)
%MyObject.TakeWindowSized()
#ENDAT
#!**********
#AT(%NewMethodCodeSection,%ActiveTemplateInstance,%stObjectID,%InitMethodID),PRIORITY(5000),DESCRIPTION(%ActiveTemplateInstanceDescription &' - Call base class Init method')
#INSERT(%InitParent)
#ENDAT
#!
#AT(%NewMethodCodeSection,%ActiveTemplateInstance,%stObjectID,%InitMethodID),PRIORITY(5300),DESCRIPTION(%ActiveTemplateInstanceDescription &' - Init HidePriority for columns')
#INSERT(%InitHidePriority)
#ENDAT
#!**********
#AT(%LocalProcedures)
#CALL(%GenerateVirtuals(ABC), %stObjectID, 'Local Objects|ListPeekaboo Manager', '%ListPeekabooVirtuals(ListPeekaboo)')
#ENDAT
#!**********
#AT(%ListPeekabooMethodCodeSection),PRIORITY(5000),DESCRIPTION('Parent Call'),WHERE(%ParentCallValid())
  #CALL(%GenerateParentCall(ABC))
#ENDAT
#!*****************************************************************************
#GROUP(%ControlFieldDisplay)
  #RETURN(' '&CHOOSE(%ColumnHidePriority=0,'  ',%ColumnHidePriority) &'  '& %ControlField)
#!*****************************************************************************
#GROUP(%GenerateControlNumbers)
    #FIX(%Control,%ListControl)
%[20](%MyObject&':ColumnNumbers') GROUP,TYPE
    #FOR(%ControlField)
%[22]ControlField USHORT(%(INSTANCE(%ControlField)))
    #ENDFOR
                     END
#!*****************************************************************************
#GROUP(%InitParent),AUTO,PRESERVE
    #FIX(%Control, %ListControl)
    #SELECT(%ControlField, ITEMS(%ControlField))
    #IF(~%ClearSlushColumn AND %SlushColumn AND %SlushColumn <> %ControlField)
      #DECLARE(%LastColumnWidth)
      #DECLARE(%Pos, LONG)
      #LOOP,FOR(%Pos,1,LEN(%ControlFieldFormat))
        #IF(NOT INSTRING(SUB(%ControlFieldFormat, %Pos, 1), '0123456789'))
          #IF(%Pos > 1)
            #SET(%LastColumnWidth, SUB(%ControlFieldFormat, 1, %Pos-1))
          #ENDIF
          #BREAK
        #ENDIF
      #ENDLOOP
      #IF(%LastColumnWidth)
SELF.Init(%ListControl, SELF.ColumnNumber.%SlushColumn, %LastColumnWidth)
      #ELSE
SELF.Init(%ListControl, SELF.ColumnNumber.%SlushColumn)
      #ENDIF
    #ELSE
SELF.Init(%ListControl)
    #ENDIF
#!*****************************************************************************
#GROUP(%InitHidePriority),AUTO
    #FIX(%Control,%ListControl)
    #!---
    #DECLARE(%Widest,LONG)
    #DECLARE(%W,LONG)
    #SET(%Widest,0)
    #FOR(%ControlField)
      #SET(%W,LEN(%ControlField))
      #IF(%Widest < %W)
        #SET(%Widest,%W)
      #ENDIF
    #ENDFOR
    #!---
    #FOR(%ControlField)
      #IF(%ColumnHidePriority <> 0)
SELF.InitHidePriority(SELF.ColumnNumber.%[%Widest]ControlField, %ColumnHidePriority)
      #ELSIF(%ColumnHidePriority0Too)
!SELF.InitHidePriority(SELF.ColumnNumber.%[%Widest]ControlField, 0)
      #ENDIF
    #ENDFOR
#!*****************************************************************************
#GROUP(%ListPeekabooVirtuals, %TreeText, %DataText, %CodeText)
#EMBED(%ListPeekabooMethodDataSection,'ListPeekaboo Method Data Section'),%pClassMethod,%pClassMethodPrototype,LABEL,DATA,PREPARE(%FixClassName(%FixBaseClassToUse(%stObjectID))),TREE(%TreeText & %DataText)
  #?CODE
  #EMBED(%ListPeekabooMethodCodeSection,'ListPeekaboo Method Code Section'),%pClassMethod,%pClassMethodPrototype,PREPARE(%FixClassName(%FixBaseClassToUse(%stObjectID))),TREE(%TreeText & %CodeText)
#!*****************************************************************************
