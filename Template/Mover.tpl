#!*****************************************************************************
#!*****************************************************************************
#TEMPLATE(Mover,'ClarionLive Mover Template'),FAMILY('ABC','CW20')
#INCLUDE('MyABC.tpw')
#!*****************************************************************************
#!*****************************************************************************
#CONTROL(BrowseMover,'Manually move/reorder browse records up and down'),DESCRIPTION('Move/reorder records using '& %Sequence),REQ(BrowseBox(ABC))
  CONTROLS
    BUTTON,AT(,,20,14),USE(?MoveUp),ICON('MoveUp.ico'),TIP('Move Up [Ctrl+Up]')
    BUTTON,AT(24,0,20,14),USE(?MoveDown),ICON('MoveDown.ico'),TIP('Move Down [Ctrl+Down]')
  END
#!**********
#PREPARE
  #CALL(%SetClassDefaults)
#ENDPREPARE
#!**********
#BOXED,HIDE,AT(,,0,0)
  #PROMPT('',@S30),%MyObjectID,DEFAULT('BrowseMover')
  #PROMPT('',@S30),%MyObjectDefaultName,DEFAULT('Mover'& %ActiveTemplateInstance)
  #PROMPT('',@S30),%MyObjectDefaultClass,DEFAULT('Mover_ABC')
  #INSERT(%OOPHiddenPrompts(ABC))
#ENDBOXED
#!**********
#SHEET,ADJUST
  #TAB('General')
    #PROMPT('Sequence Field:',COMPONENT(%PrimaryKey)),%Sequence
  #ENDTAB
  #TAB('Classes')
    #WITH(%ClassItem,%MyObjectID)
      #INSERT(%ClassPrompts(ABC))
    #ENDWITH
  #ENDTAB
#ENDSHEET
#!**********
#ATSTART
  #CALL(%AtMyClassStart)
  #!***
  #DECLARE(%MoveUpButton)
  #DECLARE(%MoveDownButton)
  #FOR(%Control),WHERE(%ControlInstance=%ActiveTemplateInstance)
    #CASE(%ControlOriginal)
    #OF('?MoveUp')
      #SET(%MoveUpButton, %Control)
    #OF('?MoveDown')
      #SET(%MoveDownButton, %Control)
    #ENDCASE
  #ENDFOR
#ENDAT
#!**********
#AT(%GatherObjects)
  #CALL(%AddObjectList)
#ENDAT
#!**********
#AT(%LocalDataClasses)
#CALL(%GenerateClass)
#ENDAT
#!**********
#AT(%WindowManagerMethodCodeSection,'Init','(),BYTE'),PRIORITY(8050)
%MyObject.Init(%ManagerName, %Sequence, %MoveUpButton, %MoveDownButton)
#ENDAT
#!**********
#AT(%WindowManagerMethodCodeSection,'TakeEvent','(),BYTE'),PRIORITY(1300),DESCRIPTION(%ActiveTemplateInstanceDescription)
ReturnValue = %MyObject.TakeEvent()
IF ReturnValue <> Level:Benign
  RETURN ReturnValue
END
#ENDAT
#!**********
#AT(%BrowserMethodCodeSection,%ActiveTemplateParentInstance,'UpdateWindow','()'),PRIORITY(2500),DESCRIPTION(%ActiveTemplateInstanceDescription)
%MyObject.UpdateWindow()
#ENDAT
#!**********
#AT(%LocalProcedures)
#CALL(%GenerateVirtuals(ABC), %MyObjectID, 'Local Objects|'& %ActiveTemplateInstanceDescription(), '%MyClassVirtuals(Mover)')
#ENDAT
#!**********
#AT(%MyClassMethodCodeSection,%ActiveTemplateInstance),PRIORITY(5000),DESCRIPTION('Parent Call'),WHERE(%ParentCallValid())
  #CALL(%GenerateParentCall(ABC))
#ENDAT
#!*****************************************************************************
#GROUP(%MyClassVirtuals, %TreeText, %DataText, %CodeText)
#EMBED(%MoverMethodDataSection,'Mover Method Data Section'),%ActiveTemplateInstance,%pClassMethod,%pClassMethodPrototype,LABEL,DATA,PREPARE(,%FixClassName(%FixBaseClassToUse(%MyObjectID))),TREE(%TreeText & %DataText)
  #?CODE
  #EMBED(%MoverMethodCodeSection,'Mover Method Code Section'),%ActiveTemplateInstance,%pClassMethod,%pClassMethodPrototype,PREPARE(,%FixClassName(%FixBaseClassToUse(%MyObjectID))),TREE(%TreeText & %CodeText)
#!*****************************************************************************
#!*****************************************************************************
#CONTROL(BrowseMoverLegacy,'Manually move/reorder browse records up and down'),DESCRIPTION('Move/reorder records using '& %Sequence),REQ(BrowseBox(Clarion))
  CONTROLS
    BUTTON,AT(,,20,14),USE(?MoveUp),ICON('MoveUp.ico'),TIP('Move Up [Ctrl+Up]')
    BUTTON,AT(24,0,20,14),USE(?MoveDown),ICON('MoveDown.ico'),TIP('Move Down [Ctrl+Down]')
  END
#!**********
#!#PREPARE
#!  #CALL(%SetClassDefaults)
#!#ENDPREPARE
#!**********
#BOXED,HIDE,AT(,,0,0)
#!#PROMPT('',@S30),%MyObjectID,DEFAULT('BrowseMover')
  #PROMPT('',@S30),%MyObjectDefaultName,DEFAULT('Mover'& %ActiveTemplateInstance)
  #PROMPT('',@S30),%MyObjectDefaultClass,DEFAULT('Mover_Legacy')
#!#INSERT(%OOPHiddenPrompts(ABC))
#ENDBOXED
#!**********
#SHEET,ADJUST
  #TAB('General')
    #PROMPT('Sequence Field:',COMPONENT(%PrimaryKey)),%Sequence
  #ENDTAB
  #TAB('Classes')
    #PROMPT('Object Name:',@S50),%MyObjectName,DEFAULT(%MyObjectDefaultName)
    #PROMPT('Class Name:',@S50),%MyObjectClass,DEFAULT(%MyObjectDefaultClass)
#!  #WITH(%ClassItem,%MyObjectID)
#!    #INSERT(%ClassPrompts(ABC))
#!  #ENDWITH
  #ENDTAB
#ENDSHEET
#!**********
#ATSTART
#!#CALL(%AtMyClassStart)
  #!***
  #DECLARE(%MoveUpButton)
  #DECLARE(%MoveDownButton)
  #FOR(%Control),WHERE(%ControlInstance=%ActiveTemplateInstance)
    #CASE(%ControlOriginal)
    #OF('?MoveUp')
      #SET(%MoveUpButton, %Control)
    #OF('?MoveDown')
      #SET(%MoveDownButton, %Control)
    #ENDCASE
  #ENDFOR
#ENDAT
#!**********
#AT(%BeforeGenerateApplication)
  #PDEFINE('_ABCDllMode_',0)
  #PDEFINE('_ABCLinkMode_',1)
#ENDAT
#!**********
#!#AT(%GatherObjects)
#!  #CALL(%AddObjectList)
#!#ENDAT
#!**********
#AT(%AfterGlobalIncludes),PRIORITY(2832),WHERE(~INLIST('MoverClass', %CustomFlags))
       #ADD(%CustomFlags,'MoverClass')
   INCLUDE('MoverClass.inc'),ONCE
#ENDAT
#!**********
#AT(%DeclarationSection),PRIORITY(2832),DESCRIPTION(%ActiveTemplateInstanceDescription)
#CALL(%GenerateLegacyClass)
#ENDAT
#!**********
#AT(%AfterWindowOpening),PRIORITY(2832),DESCRIPTION(%ActiveTemplateInstanceDescription)
%MyObjectName.Init()
#ENDAT
#!**********
#AT(%AcceptLoopBeforeEventHandling),PRIORITY(2832),DESCRIPTION(%ActiveTemplateInstanceDescription)
CASE %MyObjectName.TakeEvent()
  OF Level:Notify;  CYCLE
  OF Level:Fatal ;  BREAK
END
#ENDAT
#!**********
#!#AT(%BrowserMethodCodeSection,%ActiveTemplateParentInstance,'UpdateWindow','()'),PRIORITY(2500),DESCRIPTION(%ActiveTemplateInstanceDescription)
#!%MyObject.UpdateWindow()
#!#ENDAT
#!**********
#AT(%LocalProcedures),PRIORITY(2832),DESCRIPTION(%ActiveTemplateInstanceDescription)
#CALL(%GenerateVirtuals)
#ENDAT
#!**********
#AT(%MyClassMethodCodeSection,%ActiveTemplateInstance),PRIORITY(5000),DESCRIPTION('Parent Call'),WHERE(%ParentCallValid())
  #CALL(%GenerateParentCall(ABC))
#ENDAT
#!*****************************************************************************
#GROUP(%GenerateLegacyClass)
%[20]MyObjectName CLASS(%MyObjectClass)
Init                   PROCEDURE
AfterMove              PROCEDURE(SHORT Direction),DERIVED
                     END
#!*****************************************************************************
#GROUP(%GenerateVirtuals)

%MyObjectName.Init PROCEDURE
  CODE
  SELF.File           &= %Primary
  SELF.View           &= %ListView
  SELF.Sequence       &= %Sequence
  SELF.ListControl     = %ListControl
  SELF.MoveDownControl = %MoveDownButton
  SELF.MoveUpControl   = %MoveUpButton
  SELF.ListQueue      &= %ListQueue
  SELF.ViewPosition   &= %ListQueue.%InstancePrefix:Position

  SELF.InitWindow()

%MyObjectName.AfterMove PROCEDURE(SHORT Direction)
  CODE
  %InstancePrefix:LocateMode = LocateOnValue
  DO %InstancePrefix:LocateRecord

#!*****************************************************************************
